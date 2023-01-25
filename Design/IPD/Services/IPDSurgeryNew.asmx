<%@ WebService Language="C#" Class="IPDSurgeryNew" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class IPDSurgeryNew : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string BindPatientDetails(string TID, string PID)
    {
        DataTable dt = AllLoadData_IPD.LoadIPDPatientDetail(PID, TID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindSurgeryClass()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT s.`GroupID`,s.`GroupName` FROM `f_surgery_groupmaster` s WHERE s.`IsActive`=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindSurgeryItem(int classId)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CONCAT(im.`ItemID`,'#',IF(im.`Type_ID` IN('D','S'),1,0),'#',ROUND(IFNULL(g.Rate,0)*IFNULL(g.ScaleOfCost,1),4),'#',IFNULL(g.ScaleOfCost,1)) AS ItemID,im.`TypeName`,im.`Type_ID` FROM f_surgery_group g INNER JOIN `f_itemmaster` im ON im.`ItemID`=g.`ItemID` WHERE g.`Isactive`=1 AND im.`IsActive`=1 AND im.`IsSurgery`=1 AND g.`GroupID`=" + classId + " ORDER BY im.`TypeName` ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string validateAlreadyPrescrivedItemSelection(string transactionID, string itemID, string surgeryID, string doctorID)
    {
        int isExist = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) AS IsExist FROM f_LedgerTnxDetail ltd WHERE ltd.`TransactionID`='" + transactionID + "' AND ltd.`IsVerified`=1 AND ltd.`SurgeryID`='" + surgeryID + "' AND ltd.`ItemID`='" + itemID + "' AND ltd.`IsSurgery`=1  AND ltd.`DoctorID`='" + doctorID + "' "));
        if (isExist > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Selected Item Already prescribed with Same Doctor Under the Selected Surgery. Kindly Remove First!" });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" });
    }
    [WebMethod]
    public string BindPrescribedSurgery(string transactionID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("select IF((SELECT COUNT(*) FROM f_IPD_OTSurgeryClearance WHERE LedgerTransactionNo=lt.LedgerTransactionNo AND IsActive=1)>0,1,0)IsOTClearance, lt.LedgerTransactionNo,lt.TransactionID,date_format(CONCAT(lt.Date,' ',lt.Time),'%d-%b-%Y %l:%i %p')IssueDate,ltd.SurgeryName ItemName,");
        sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,");
        sb.Append("Round(lt.GrossAmount,2) Rate,1 Quantity,");
        sb.Append(" lt.DiscountOnTotal DiscPer,ROUND((lt.GrossAmount*lt.DiscountOnTotal)/100,2) DiscAmt,Round(lt.NetAmount,1) Amount,'---' Package,em.Name,");
        sb.Append("(SELECT (NAME)DiscGivenBy FROM employee_master WHERE employeeid=ltd.DiscUserID LIMIT 1)DiscGivenBy  ");
        sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
        sb.Append(" inner join employee_master em on ltd.UserID = em.EmployeeID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ");
        sb.Append(" ltd.IsSurgery = 1 and lt.TransactionID = '" + transactionID + "' group by lt.LedgerTransactionNo order by lt.Date Desc ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true, Description = "Save Surgery Prescription")]
    public string SaveSurgeryBilling(object LT, object LTD, string PatientTypeID, string MembershipNo)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
            List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);

            string userID = HttpContext.Current.Session["ID"].ToString();


            string LedTxnID = "";
            string str = "select LM.LedgerNumber,PMH.PanelID,PMH.PatientID,PMH.Patient_Type from patient_medical_history PMH inner join f_ledgermaster LM on LM.LedgerUserID=PMH.PatientID where PMH.Type='IPD' and PMH.TransactionID='" + dataLT[0].TransactionID + "'";
            DataTable dtPatient = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, str).Tables[0];
            string PatientID = Util.GetString(dtPatient.Rows[0]["PatientID"]);
            int PanelID = Util.GetInt(dtPatient.Rows[0]["PanelID"]);
            string LedgerNo = Util.GetString(dtPatient.Rows[0]["LedgerNumber"]);
            string patientType = Util.GetString(dtPatient.Rows[0]["Patient_Type"]);

            string IsExistSurgery = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT CONCAT(COUNT(*),'#',IFNULL(ltd.`LedgerTransactionNo`,0)) AS IsExist FROM f_LedgerTnxDetail ltd WHERE ltd.`TransactionID`='" + dataLT[0].TransactionID + "' AND ltd.`IsVerified`=1 AND ltd.`SurgeryID`='" + dataLTD[0].SurgeryID + "' AND ltd.`IsSurgery`=1 "));
            if (Util.GetInt(IsExistSurgery.Split('#')[0]) == 0)
            {
                var objLedTran = new Ledger_Transaction(Tranx);
                objLedTran.LedgerNoCr = LedgerNo;
                objLedTran.LedgerNoDr = "HOSP0001";
                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objLedTran.TypeOfTnx = "IPD Surgery";
                objLedTran.Date = Util.GetDateTime(System.DateTime.Now);
                objLedTran.Time = DateTime.Now;
                objLedTran.DiscountOnTotal = dataLT[0].DiscountOnTotal;
                objLedTran.GrossAmount = Util.GetDecimal(dataLT[0].GrossAmount);
                objLedTran.NetAmount = Util.GetDecimal(dataLT[0].NetAmount);
                objLedTran.UserID = userID;
                objLedTran.PatientID = PatientID;
                objLedTran.TransactionID = dataLT[0].TransactionID;
                objLedTran.PanelID = PanelID;
                objLedTran.DiscountReason = dataLT[0].DiscountReason;
                objLedTran.DiscountApproveBy = dataLT[0].DiscountApproveBy;
                objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLedTran.PatientType = patientType;
                objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
                LedTxnID = objLedTran.Insert();
                if (LedTxnID == string.Empty)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in LT." });
                }
            }
            else
            {
                LedTxnID = IsExistSurgery.Split('#')[1].ToString();
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE `f_ledgertransaction` lt SET lt.`GrossAmount`= lt.`GrossAmount`+" + Util.GetDecimal(dataLT[0].GrossAmount) + ",lt.`DiscountOnTotal`=lt.`DiscountOnTotal`+" + Util.GetDecimal(dataLT[0].DiscountOnTotal) + ",lt.`NetAmount`=lt.`NetAmount`+" + Util.GetDecimal(dataLT[0].NetAmount) + ", lt.`Updatedate`=NOW() WHERE lt.`LedgertransactionNo`='" + LedTxnID + "' ");
            }

            int SendToPackage = 0; string PackageID = "";
            //Checking if Patient is prescribed any IPD Packages
            DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(dataLT[0].TransactionID, con);
            if (dtPkg != null && dtPkg.Rows.Count > 0)
            {
                int iCtr = 0;
                foreach (DataRow drPkg in dtPkg.Rows)
                {
                    if (iCtr == 0)
                    {
                        DataTable dtPkgDetl = StockReports.ShouldSurgerySendToIPDPackage(dataLT[0].TransactionID, drPkg["PackageID"].ToString(), Util.GetString(dataLTD[0].SurgeryID), Util.GetDecimal(dataLT[0].NetAmount), Util.GetInt("1"),Util.GetInt(dataLTD[0].IPDCaseTypeID),con);
                        if (dtPkgDetl != null)
                        {
                            if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                            {
                                SendToPackage = 1;
                                PackageID = drPkg["PackageID"].ToString();
                            }
                        }
                    }
                }
            }
            for (int i = 0; i < dataLTD.Count; i++)
            {

                string subCatgoryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT im.`SubCategoryID` FROM `f_itemmaster` im WHERE im.`ItemID`='" + dataLTD[i].ItemID + "' "));
                var objLTDetail = new LedgerTnxDetail(Tranx);

                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.LedgerTransactionNo = LedTxnID;
                objLTDetail.TransactionID = dataLT[0].TransactionID;
                objLTDetail.ItemID = Util.GetString(dataLTD[i].ItemID);
                objLTDetail.Rate = Util.GetDecimal(dataLTD[i].Rate);
                objLTDetail.SubCategoryID = Util.GetString(subCatgoryID);
                objLTDetail.Quantity = 1;
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(subCatgoryID, con));

                if (SendToPackage == 1)
                {
                    objLTDetail.Amount = 0;
                    objLTDetail.DiscountPercentage = 0;
                    objLTDetail.DiscAmt = 0;
                    objLTDetail.IsPackage = 1;
                    objLTDetail.PackageID = Util.GetString(PackageID);
                    objLTDetail.NetItemAmt = 0;
                    objLTDetail.TotalDiscAmt = 0;
                }
                else
                {
                    objLTDetail.DiscountPercentage = Util.GetDecimal(dataLTD[i].DiscountPercentage);
                    objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Amount);
                    objLTDetail.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                    if (Util.GetDecimal(dataLTD[i].DiscAmt) > 0)
                    {
                        objLTDetail.DiscUserID = userID;
                        objLTDetail.DiscountReason = dataLTD[i].DiscountReason;
                    }
                    objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].NetItemAmt);
                    objLTDetail.TotalDiscAmt = Util.GetDecimal(dataLTD[i].TotalDiscAmt);
                }
                objLTDetail.EntryDate = Util.GetDateTime(System.DateTime.Now);
                objLTDetail.UserID = userID;
                objLTDetail.ItemName = Util.GetString(dataLTD[i].ItemName);
                objLTDetail.IsSurgery = 1;
                objLTDetail.SurgeryID = Util.GetString(dataLTD[i].SurgeryID);
                objLTDetail.SurgeryName = Util.GetString(dataLTD[i].SurgeryName);
                objLTDetail.IsVerified = 1;
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.IPDCaseTypeID = dataLTD[i].IPDCaseTypeID;
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.Type = "I";
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLTDetail.DoctorID = dataLTD[i].DoctorID;
                objLTDetail.RoomID = dataLTD[i].RoomID;
                objLTDetail.VarifiedUserID = userID;
                objLTDetail.VerifiedDate = Util.GetDateTime(System.DateTime.Now);
                objLTDetail.typeOfTnx = "IPD Surgery";
                objLTDetail.IsPayable = Util.GetInt(dataLTD[i].IsPayable);
                objLTDetail.CoPayPercent = Util.GetDecimal(dataLTD[i].CoPayPercent);
                objLTDetail.isPanelWiseDisc = Util.GetInt(dataLTD[i].isPanelWiseDisc);
                objLTDetail.scaleOfCost = Util.GetDecimal(dataLTD[i].scaleOfCost);
             
                int LTDetailID = objLTDetail.Insert();
                if (LTDetailID == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in LTD." });
                }


                if (dataLTD[i].DoctorNotes != string.Empty)
                {
                    string sqlQuery = "INSERT INTO patient_doctornotes_data(PatientID,TransactionID,LedgerTransactionNo,LedgerTnxID,DoctorNotes,SurgeryID,EntryDate,EntryBy) values(@PatientID, @TransactionID, @LedgerTransactionNo, @LedgerTnxID, @DoctorNotes, @SurgeryID,now(), @EntryBy)";
                    excuteCMD.DML(Tranx, sqlQuery, CommandType.Text, new
                    {
                        PatientID = PatientID,
                        TransactionID = dataLT[0].TransactionID,
                        LedgerTransactionNo = LedTxnID,
                        LedgerTnxID = LTDetailID,
                        DoctorNotes = dataLTD[i].DoctorNotes,
                        SurgeryID = Util.GetString(dataLTD[i].SurgeryID),
                        EntryBy = HttpContext.Current.Session["ID"].ToString()

                    });
                }

                //Insert into Surgery Description

                var objSD = new Surgery_Description(Tranx);
                objSD.LedgerTransactionNo = LedTxnID;
                objSD.TransactionID = dataLT[0].TransactionID;
                objSD.PatientID = PatientID;
                objSD.ItemID = Util.GetString(dataLTD[i].ItemID);
                objSD.Surgery_ID = Util.GetString(dataLTD[i].SurgeryID);
                objSD.Rate = Util.GetDecimal(dataLTD[i].Rate);
                objSD.Amount = Util.GetDecimal(dataLTD[i].Amount);
                objSD.Discount = Util.GetDecimal(dataLTD[i].DiscAmt);
                string SurgeryTransactionID = objSD.Insert();
                if (SurgeryTransactionID == string.Empty)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in Surgery Discription." });
                }
                //Insert into Surgery Doctor

                if (dataLTD[i].DoctorID != "" && dataLTD[i].DoctorID != "0")
                {
                    decimal doctorPer = 0;
                    decimal SurgeryAmount = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT lt.`NetAmount` FROM `f_ledgertransaction` lt WHERE lt.`LedgertransactionNo`='" + LedTxnID + "'"));
                    if (SurgeryAmount > 0)
                        doctorPer = Math.Round((dataLTD[i].Amount * 100 / SurgeryAmount), 6);

                    var objSDoc = new Surgery_Doctor(Tranx);
                    objSDoc.SurgeryTransactionID = SurgeryTransactionID;
                    objSDoc.DoctorID = Util.GetString(dataLTD[i].DoctorID);
                    objSDoc.Percentage = Util.GetDecimal(doctorPer);
                    objSDoc.Amount = Util.GetDecimal(dataLTD[i].Amount);
                    objSDoc.Discount = Util.GetDecimal(dataLTD[i].DiscAmt);
                    objSDoc.ItemID = Util.GetString(dataLTD[i].ItemID);

                    int SurDoc = objSDoc.Insert();
                    if (SurDoc == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in Surgery Doctor." });
                    }
                }

            }

            Tranx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, ledgerTransactionNo = LedTxnID, response = AllGlobalFunction.saveMessage });
            // return LedTxnID;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string OTClearence(int isOTClearence, string ledgerTnxNo, string remarks, string transactionId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            if (isOTClearence == 0)
            {
                excuteCMD.DML(tnx, "INSERT INTO f_IPD_OTSurgeryClearance(TransactionID,LedgerTransactionNo,Remarks,EntryBy,CentreId,IPAddress,EntryDateTime) values(@TransactionID,@LedgerTransactionNo,@Remarks,@EntryBy,@CentreId,@IPAddress,now()) ", CommandType.Text, new
                {
                    TransactionID = transactionId,
                    LedgerTransactionNo = ledgerTnxNo,
                    Remarks = remarks,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    CentreId = HttpContext.Current.Session["CentreID"].ToString(),
                    IPAddress = All_LoadData.IpAddress()
                });
            }
            else
            {
                excuteCMD.DML(tnx, "update f_IPD_OTSurgeryClearance set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=now(),UpdatedRemarks=@UpdatedRemarks,UpdatedIPAdress=@UpdatedIPAdress where LedgerTransactionNo=@LedgerTransactionNo and IsActive=1 ", CommandType.Text, new
                {
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    UpdatedRemarks = remarks,
                    UpdatedIPAdress = All_LoadData.IpAddress(),
                    LedgerTransactionNo = ledgerTnxNo
                });
            }

            tnx.Commit();
            if (isOTClearence == 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Billing Clearance Done Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Billing Clearance Revert Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }



    [WebMethod(EnableSession = true)]
    public string onRemoveSurgeryItem(int id, string LedgerTransactionNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            excuteCMD.DML(tnx, "update f_ledgertnxdetail set IsVerified = 2,CancelUserId=@UpdatedBy,CancelDatetime=now(),CancelReason='',LastUpdatedBy = @UpdatedBy,Updateddate =now(),IpAddress =@UpdatedIPAdress where ID=@LedgetTnxId ", CommandType.Text, new
            {
                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                UpdatedIPAdress = All_LoadData.IpAddress(),
                LedgetTnxId = id
            });

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + id + " ");

            string UpdateQuery = "Call updateEmergencyBillAmounts(" + LedgerTransactionNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);



            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ltd.`LedgerTransactionNo`,ltd.`SurgeryID`,ltd.`ItemID`,ltd.`DoctorID`,ltd.`Rate`,ltd.`NetItemAmt`,ltd.`DiscAmt`, ");
            sb.Append("ltd.`TransactionID`,lt.`PatientID`, IF(ltd.`NetItemAmt`=0,0,ROUND((ltd.`NetItemAmt`*100/lt.`NetAmount`),4)) DocPercentage ");
            sb.Append("FROM f_ledgertnxdetail ltd  ");
            sb.Append("INNER JOIN `f_ledgertransaction` lt ON lt.`LedgertransactionNo`=ltd.`LedgerTransactionNo` ");
            sb.Append("WHERE ltd.`IsVerified`=1 AND ltd.`IsSurgery`=1 AND ltd.`LedgerTransactionNo`='" + LedgerTransactionNo + "' ");

            DataTable dtBilling = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];
            sb = new StringBuilder();

            //delete Prevous Surgery Discription and doctor;
            sb.Append(" DELETE FROM f_surgery_discription ,f_surgery_doctor USING  ");
            sb.Append(" f_surgery_discription LEFT JOIN f_surgery_doctor ON f_surgery_discription.SurgeryTransactionID  = f_surgery_doctor.SurgeryTransactionID  ");
            sb.Append(" WHERE f_surgery_discription.LedgerTransactionNo = '" + LedgerTransactionNo + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


            //Insert into Surgery Description

            if (dtBilling.Rows.Count > 0)
            {
                for (int i = 0; i < dtBilling.Rows.Count; i++)
                {
                    var objSD = new Surgery_Description(tnx);
                    objSD.LedgerTransactionNo = dtBilling.Rows[i]["LedgerTransactionNo"].ToString();
                    objSD.TransactionID = dtBilling.Rows[i]["TransactionID"].ToString();
                    objSD.PatientID = dtBilling.Rows[i]["PatientID"].ToString();
                    objSD.ItemID = dtBilling.Rows[i]["ItemID"].ToString();
                    objSD.Surgery_ID = dtBilling.Rows[i]["SurgeryID"].ToString();
                    objSD.Rate = Util.GetDecimal(dtBilling.Rows[i]["Rate"].ToString());
                    objSD.Amount = Util.GetDecimal(dtBilling.Rows[i]["NetItemAmt"].ToString());
                    objSD.Discount = Util.GetDecimal(dtBilling.Rows[i]["DiscAmt"].ToString());
                    string SurgeryTransactionID = objSD.Insert();
                    if (SurgeryTransactionID == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in Surgery Discription." });
                    }


                    //Insert into Surgery Doctor

                    if (dtBilling.Rows[i]["DoctorID"].ToString() != "" && dtBilling.Rows[i]["DoctorID"].ToString() != "0")
                    {
                        var objSDoc = new Surgery_Doctor(tnx);
                        objSDoc.SurgeryTransactionID = SurgeryTransactionID;
                        objSDoc.DoctorID = Util.GetString(dtBilling.Rows[i]["DoctorID"].ToString());
                        objSDoc.Percentage = Util.GetDecimal(dtBilling.Rows[i]["DocPercentage"].ToString());
                        objSDoc.Amount = Util.GetDecimal(dtBilling.Rows[i]["NetItemAmt"].ToString());
                        objSDoc.Discount = Util.GetDecimal(dtBilling.Rows[i]["DiscAmt"].ToString());
                        objSDoc.ItemID = Util.GetString(dtBilling.Rows[i]["ItemID"].ToString());

                        int SurDoc = objSDoc.Insert();
                        if (SurDoc == 0)
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in Surgery Doctor." });
                        }
                    }
                }
            }


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Surgery Item Removed Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession=true)]
    public string bindSurgeryItems(string ledgerTnxNo)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT ltd.`LedgerTransactionNo`,ltd.ID,ltd.`ItemName`,DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%Y %I:%i %p') AS EntryDate,ltd.`NetItemAmt`, ");
        sb.Append("IF(ltd.`IsPackage`=1,'Yes','No') AS IsPackage ,IFNULL(CONCAT(dm.`Title`,' ',dm.`Name`),'') AS DoctorName ");
        sb.Append(",CONCAT(em.`Title`,' ',em.`Name`) AS UserName,ltd.`SurgeryName`,lt.`NetAmount` ");
        sb.Append(" ,IFNULL((SELECT d.`DoctorNotes` FROM patient_doctornotes_data d WHERE d.`LedgerTnxID`=ltd.ID),'') AS DoctorNotes  ");
        sb.Append(" ,IF(" + HttpContext.Current.Session["RoleID"].ToString() + "=4 OR ltd.`UserID`='"+ HttpContext.Current.Session["ID"].ToString() +"',1,0) IsRemove ");
        sb.Append("FROM f_ledgertnxdetail ltd  ");
        sb.Append("INNER JOIN `f_ledgertransaction` lt ON lt.`LedgertransactionNo`=ltd.`LedgerTransactionNo` ");
        sb.Append("INNER JOIN employee_master em ON em.`EmployeeID`=ltd.`UserID` ");
        sb.Append("LEFT JOIN doctor_master dm ON dm.`DoctorID`=ltd.`DoctorID` ");
        sb.Append("WHERE ltd.`IsVerified`=1 AND ltd.`IsSurgery`=1 AND ltd.`LedgerTransactionNo`='" + ledgerTnxNo + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindType()
    {
        StringBuilder sb = new StringBuilder("Select Temp_Name AS Name,Template_Value as ID from ot_procedure_template order by Temp_Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



}