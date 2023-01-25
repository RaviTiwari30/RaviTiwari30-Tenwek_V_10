<%@ WebService Language="C#" Class="OPDBillEdit" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[System.Web.Script.Services.ScriptService]
public class OPDBillEdit : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


     [WebMethod(EnableSession = true)]
    public string SearchOPDBills(string fromDate, string toDate, string billNo)
    {


        if (Resources.Resource.AllowFiananceIntegration == "2")//
        {
            string TransactionID = StockReports.ExecuteScalar("Select pmh.TransactionID from patient_medical_history pmh where pmh.Billno='" + billNo + "'");
            if (TransactionID != "")
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(TransactionID) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "../IPD/PatientBillMsg.aspx?msg=" + Msga });

                  
                }
            }
        }
         
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT lt.TransactionID,IFNULL(pmh.KinRelation,'')KinRelation,IFNULL(pmh.KinName,'')KinName,IFNULL(pmh.KinPhone,'')KinPhone,lt.CurrentAge, IF(lt.TypeOfTnx='OPD-Package',1,0)IsPackage,IF(lt.TypeOfTnx='Pharmacy-Issue',1,0)IsPharmacy,(SELECT l.CoPayPercent FROM f_ledgertnxdetail l WHERE l.TypeOfTnx<>'CR' AND l.TypeOfTnx<>'DR' AND l.LedgerTransactionNo=lt.LedgertransactionNo Limit 1)CoPayPercent, lt.TransactionID,lt.PanelID,lt.PatientID, lt.BillNo,lt.NetAmount,DATE_FORMAT(lt.Date,'%d-%b-%Y')`Date`,lt.TypeOfTnx ,lt.Adjustment,CONCAT(em.title,' ',em.name)CreatedBy,lt.LedgertransactionNo,pm.Company_Name PanelName,pm.PanelID ");

        sqlCMD.Append(",IFNULL(ApprovalAmount,'')ApprovalAmount,IFNULL(ApprovalRemark,'')ApprovalRemark,IFNULL(pnl.ReferenceCodeOPD,0)ReferenceCodeOPD,IFNULL(pnl.HideRate,0)HideRate,IFNULL(pnl.ShowPrintOut,0)ShowPrintOut,pmh.RelationWith_holder,pmh.CorporatePanelID,pmh.ParentID,pmh.ProId,pmh.ReferedBy, pmh.PanelID,pmh.CardNo,pmh.PolicyNo,DATE_FORMAT(pmh.ExpiryDate,'%d-%b-%Y') AS ExpiryDate,pmh.CardHolderName,pmh.RelationWith_holder,pmh.doctorid,pmh.CardHolderName,pmh.CorporatePanelID ");
        sqlCMD.Append("  FROM  f_ledgertransaction lt  LEFT JOIN  f_panel_master pm ON pm.PanelID=lt.PanelID  ");
        sqlCMD.Append(" INNER JOIN  employee_master em ON em.EmployeeID=lt.UserID ");
        sqlCMD.Append(" LEFT JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sqlCMD.Append(" LEFT JOIN f_panel_master pnl ON pnl.PanelID=Pmh.PanelID ");
        sqlCMD.Append(" WHERE lt.IsCancel=0 AND lt.NetAmount>0 AND lt.CentreID=@centreID  AND lt.TypeOfTnx IN  ");
        sqlCMD.Append(" ('OPD-APPOINTMENT','OPD-BILLING','OPD-LAB','OPD-OTHERS','OPD-Package','Pharmacy-Issue') ");

        if (string.IsNullOrEmpty(billNo))
            sqlCMD.Append(" and lt.Date>=@fromDate and lt.Date<=@toDate   ");
        else
            sqlCMD.Append(" and lt.BillNo=@billNo  ");

        //sqlCMD.Append(" group by r.ReceiptNo ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
            billNo = billNo.Trim(),
            centreID = HttpContext.Current.Session["CentreID"].ToString()
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);




    }




    [WebMethod(EnableSession=true)]
    public string GetBillDetails(string ledgerTransactionNo, int isPackage)
    {
        if (Resources.Resource.AllowFiananceIntegration == "1")//
        {
            if (AllLoadData_IPD.CheckDataPostToFinance(ledgerTransactionNo) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." });
            }
        }
        StringBuilder sqlCMD = new StringBuilder("SELECT IF(ltd.ConfigID=5,CONCAT('DR. ',im.TypeName),concat(dm.Title,' ',dm.Name))CashCollectedDoctor, ltd.*,if(ltd.TypeOfTnx='OPD-LAB','LAB',if(ltd.TypeOfTnx='OPD-APPOINTMENT','OPD','OTH'))LabType,lt.DiscountApproveBy,lt.DiscountReason,plo.IsSampleCollected FROM  f_ledgertnxdetail ltd INNER JOIN f_ItemMaster im ON ltd.ItemID = im.ItemID  LEFT JOIN Doctor_Master dm ON dm.DoctorID = ltd.DoctorID INNER JOIN  f_ledgertransaction lt ON lt.LedgertransactionNo=ltd.LedgerTransactionNo LEFT JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.LedgerTnxID WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo AND ltd.IsRefund=0  and lt.CentreID=@centreID And ltd.TypeOfTnx<>'CR' AND ltd.TypeOfTnx<>'DR' and ltd.IsVerified<>2 ");

        //if (isPackage == 1)
        //    sqlCMD.Append("AND LTD.IsPackage=1");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            ledgerTransactionNo = ledgerTransactionNo,
            centreID=HttpContext.Current.Session["CentreID"].ToString()
        });


        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = dt });


    }



    [WebMethod(EnableSession = true)]
    public string ChangeBillDetails(object LTD, string DiscountReason, string ApprovedBy)
    {

        List<LedgerTnxDetail> ledgerTransactionDetails = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCMD;

        try
        {


            var dataLTD = ledgerTransactionDetails.Where(i => (string.IsNullOrEmpty(i.LedgerTnxID) && i.IsVerified == 1)).ToList();

            var oldLTD = ledgerTransactionDetails.Where(i => !string.IsNullOrEmpty(i.LedgerTnxID)).ToList();


            string ledgerTransactionNo = oldLTD[0].LedgerTransactionNo;
            if (Resources.Resource.AllowFiananceIntegration == "1")//
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(ledgerTransactionNo) > 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient Final Bill Already Posted To Finance..." });
                }
            }
            for (int i = 0; i < oldLTD.Count; i++)
            {
                if (oldLTD[i].IsVerified == 2)
                {
                    int ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.LedgerTnxID='" + oldLTD[i].LedgerTnxID + "' AND IFNULL(plo.Result_Flag,0)=1 AND im.ReportType<>5"));
                    if (ResultFlag > 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.saveMessage, message = "Result Already Done, Can Not Reject this Test." });
                        // return;
                    }
                    ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.LedgerTnxID='" + oldLTD[i].LedgerTnxID + "' AND IFNULL(plo.P_IN,0)=1 AND im.ReportType = 5 "));
                    if (ResultFlag > 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.saveMessage, message = "Patient Already Done the Scan, Can Not Reject this Test." });
                    }
                }
            }
            sqlCMD = new StringBuilder("UPDATE f_ledgertnxdetail  ltd set ltd.`LastUpdatedBy`=@userID,ltd.`UpdatedDate`=now(),ltd.`DiscUserID`=@discUserID,ltd.`DiscountReason`=@discountReason,ltd.TotalDiscAmt=@totalDiscAmt, ltd.IsVerified=@isVerified,ltd.DoctorID=@doctorID,ltd.DiscountPercentage=@discountPercent,ltd.DiscAmt=@discountAmount, ltd.Rate=@rate,ltd.Quantity=@quantity,ltd.Amount=@amount,ltd.GrossAmount=@grossAmount,ltd.NetItemAmt=@netItemAmount WHERE ltd.LedgerTnxID=@ledgerTnxID ");
            for (int i = 0; i < oldLTD.Count; i++)
            {
               
                decimal grossAmount = oldLTD[i].Rate * oldLTD[i].Quantity;
                decimal discountAmount = (grossAmount * oldLTD[i].DiscountPercentage / 100);
                decimal netAmount = grossAmount - discountAmount;


                if (oldLTD[i].IsPackage == 1)
                    netAmount = 0;



                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    rate = oldLTD[i].Rate,
                    quantity = oldLTD[i].Quantity,
                    discountPercent = oldLTD[i].DiscountPercentage,
                    discountAmount = discountAmount,
                    amount = netAmount,
                    grossAmount = grossAmount,
                    netItemAmount = netAmount,
                    ledgerTnxID = oldLTD[i].LedgerTnxID,
                    doctorID = oldLTD[i].DoctorID,
                    isVerified = oldLTD[i].IsVerified,
                    totalDiscAmt = discountAmount,
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    discountReason = discountAmount > 0 ? DiscountReason : "",
                    discUserID = discountAmount > 0 ? HttpContext.Current.Session["ID"].ToString() : ""
                });
                string docstring = All_LoadData.CalcaluteDoctorShare(oldLTD[i].LedgerTnxID, "", "1", "HOSP", tnx, con);
            }





            for (int i = 0; i < dataLTD.Count; i++)
            {
                if (dataLTD[i].isDocCollect == 0)
                {
                    LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                    ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjLdgTnxDtl.LedgerTransactionNo = Util.GetString(dataLTD[i].LedgerTransactionNo).Trim();
                    ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[i].ItemID).Trim();
                    ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[i].Rate);
                    ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                    ObjLdgTnxDtl.StockID = string.Empty;
                    ObjLdgTnxDtl.IsTaxable = "NO";



                decimal grossAmount = dataLTD[i].Rate * dataLTD[i].Quantity;
                decimal discountAmount = (grossAmount * dataLTD[i].DiscountPercentage / 100);
                decimal netAmount = grossAmount - discountAmount;

                ObjLdgTnxDtl.IsPackage = dataLTD[i].IsPackage;
                if (ObjLdgTnxDtl.IsPackage == 1)
                    netAmount = 0;

                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(discountAmount);
                ObjLdgTnxDtl.DiscountPercentage = dataLTD[i].DiscountPercentage;
                ObjLdgTnxDtl.Amount = netAmount;
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = discountAmount;

                if (Util.GetDecimal(dataLTD[i].Rate) == 0)
                    ObjLdgTnxDtl.DiscountPercentage = 0;
                //else
                //{
                //    ObjLdgTnxDtl.DiscountPercentage = (Util.GetDecimal(dataLTD[i].DiscAmt) * 100) / ((Util.GetDecimal(dataLTD[i].Rate)) * (Util.GetDecimal(dataLTD[i].Quantity)));
                //    itemWiseDiscountPercent = ObjLdgTnxDtl.DiscountPercentage;
                //}


                if (ObjLdgTnxDtl.DiscountPercentage > 0)
                    ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                

                if (ObjLdgTnxDtl.IsPackage == 1)
                    ObjLdgTnxDtl.PackageID = oldLTD[1].PackageID;
                else
                    ObjLdgTnxDtl.PackageID = string.Empty;

                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = Util.GetString(dataLTD[i].TransactionID).Trim();
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[i].ItemName).Trim();
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.DiscountReason = Util.GetString(DiscountReason);
                ObjLdgTnxDtl.DoctorID = dataLTD[i].DoctorID.Trim();
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dataLTD[i].TnxTypeID);

                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.RateListID = dataLTD[i].RateListID;
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.rateItemCode = dataLTD[i].rateItemCode.Trim();
                ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.roundOff = Util.GetDecimal(0 / dataLTD.Count);
                // ObjLdgTnxDtl.typeOfTnx = ObjLdgTnx.TypeOfTnx;//"OPD-LAB"


                if (Util.GetString(dataLTD[i].Type).ToUpper() == "LAB")
                    ObjLdgTnxDtl.typeOfTnx = "OPD-LAB";
                else if (Util.GetInt(dataLTD[i].TnxTypeID) == 16)
                    ObjLdgTnxDtl.typeOfTnx = "Pharmacy-Issue";
                else if (Util.GetString(dataLTD[i].Type).ToUpper() == "PRO")
                    ObjLdgTnxDtl.typeOfTnx = "OPD-PROCEDURE";
                else if (Util.GetString(dataLTD[i].Type).ToUpper() == "OPD")
                    ObjLdgTnxDtl.typeOfTnx = "OPD-APPOINTMENT";
                else
                    ObjLdgTnxDtl.typeOfTnx = "OPD-OTHERS";

                    ObjLdgTnxDtl.CoPayPercent = oldLTD[0].CoPayPercent;
                    ObjLdgTnxDtl.IsPayable = oldLTD[0].IsPayable;
                    ObjLdgTnxDtl.isPanelWiseDisc = oldLTD[0].isPanelWiseDisc;
                    ObjLdgTnxDtl.panelCurrencyCountryID = oldLTD[0].panelCurrencyCountryID;
                    ObjLdgTnxDtl.panelCurrencyFactor = oldLTD[0].panelCurrencyFactor;
                    ObjLdgTnxDtl.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    ObjLdgTnxDtl.salesID = dataLTD[i].salesID;
                    string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                }
            }


            string sqlDocCollect = string.Empty;
            DataTable dtDocShareDetails = new DataTable();
            string cashCollectedDoctorID = string.Empty;
            decimal cashCollectedDocShare = 0;
            string PatientID = string.Empty;
            for (int k = 0; k < ledgerTransactionDetails.Count; k++)
            {
                if (ledgerTransactionDetails[k].isDocCollect == 1)
                {

                    if (Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ledgerTransactionDetails[k].SubCategoryID), con)) == 5)
                    {
                        cashCollectedDoctorID = Util.GetString(excuteCMD.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster  im WHERE im.ItemID=@itemID", new
                       {
                           itemID = ledgerTransactionDetails[k].ItemID
                       }));
                    }
                    else
                        cashCollectedDoctorID = ledgerTransactionDetails[k].DoctorID;


                    decimal grossAmount = ledgerTransactionDetails[k].Rate * ledgerTransactionDetails[k].Quantity;
                    decimal discountAmount = (grossAmount * ledgerTransactionDetails[k].DiscountPercentage / 100);
                    decimal netAmount = grossAmount - discountAmount;
                    decimal sharebleAmt = 0;
                    if (ledgerTransactionDetails[k].IsPackage == 1)
                        sharebleAmt = grossAmount;
                    else
                        sharebleAmt = netAmount;

                    if(string.IsNullOrEmpty(ledgerTransactionDetails[k].LedgerTnxID))
                        dtDocShareDetails = StockReports.GetDataTable(" CALL `Get_DoctorShare_Details`(" + HttpContext.Current.Session["CentreID"].ToString() + ",'" + Util.GetString(ledgerTransactionDetails[k].ItemID).Trim() + "','" + cashCollectedDoctorID + "','" + Util.GetString(ledgerTransactionDetails[k].SubCategoryID).Trim() + "'," + sharebleAmt + ",1,'HOSP') ");
                    else
                        dtDocShareDetails = StockReports.GetDataTable(" SELECT ltd.DoctorShareAmt AS ShareAmt FROM f_DocShare_TransactionDetail ltd WHERE ltd.LedgerTnxID='" + ledgerTransactionDetails[k].LedgerTnxID + "' UNION ALL SELECT ltd.DoctorShareAmt AS ShareAmt FROM f_DocShare_TransactionDetail_lab ltd WHERE ltd.LedgerTnxID='" + ledgerTransactionDetails[k].LedgerTnxID + "' LIMIT 1 ");
                      
                    if (dtDocShareDetails.Rows.Count > 0 && dtDocShareDetails != null)
                        cashCollectedDocShare = Util.GetDecimal(dtDocShareDetails.Rows[0]["ShareAmt"].ToString());


                    PatientID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT pmh.PatientID FROM patient_medical_history pmh WHERE pmh.TransactionID='" + Util.GetString(ledgerTransactionDetails[k].TransactionID).Trim() + "' LIMIT 1"));
                    sqlDocCollect = "INSERT INTO f_Doctor_Self_Collection(PatientID,TransactionID,ItemID,DoctorID,GrossAmt,DiscAmt,NetAmt,DocCollection,DocShare,HospShare,EntryDate,EntryBy,PageURL,CentreID) VALUES(@PatientID, @TransactionID, @ItemID, @DoctorID, @GrossAmt, @DiscAmt, @NetAmt, @DocCollection, @DocShare, @HospShare,NOW(), @EntryBy,@PageURL,@CentreID)";
                    excuteCMD.DML(tnx, sqlDocCollect, CommandType.Text, new
                    {
                        PatientID = PatientID,
                        TransactionID =  Util.GetString(ledgerTransactionDetails[k].TransactionID).Trim(),
                        ItemID = Util.GetString(ledgerTransactionDetails[k].ItemID).Trim(),
                        DoctorID = cashCollectedDoctorID,
                        GrossAmt = grossAmount,
                        DiscAmt = discountAmount,
                        NetAmt = netAmount,
                        DocCollection = Util.GetDecimal(ledgerTransactionDetails[k].docCollectAmt),
                        DocShare = cashCollectedDocShare,
                        HospShare = netAmount - cashCollectedDocShare,
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        PageURL = All_LoadData.getCurrentPageName(),
                        CentreID = HttpContext.Current.Session["CentreID"].ToString()
                    });
                }
            }


            sqlCMD = new StringBuilder("UPDATE f_ledgertransaction lt SET lt.DiscountReason=@discountReason,lt.DiscountApproveBy=@discountApprovedBy WHERE lt.LedgertransactionNo=@ledgerTransactionNo");


            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                discountReason = DiscountReason,
                discountApprovedBy = ApprovedBy,
                ledgerTransactionNo = ledgerTransactionNo
            });


            string UpdateQuery = "Call updateEmergencyBillAmounts(" + ledgerTransactionNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
            
            sqlCMD = new StringBuilder(" UPDATE patient_medical_history pmh SET ");
            if (oldLTD[0].CoPayPercent > 0)
            {
                sqlCMD.Append(" pmh.PanelPaybleAmt=IFNULL((SELECT SUM(ltd.NetItemAmt-((ltd.NetItemAmt)*" + oldLTD[0].CoPayPercent + "/100)) PanelPayableAmount FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0),0), ");
                sqlCMD.Append(" pmh.PatientPaybleAmt=IFNULL((SELECT  SUM((ltd.NetItemAmt)*" + oldLTD[0].CoPayPercent + "/100) PatientPableAmt FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0),0) ");
            }
            else
                sqlCMD.Append(" pmh.PanelPaybleAmt=0.000000,pmh.PatientPaybleAmt=IFNULL((SELECT  SUM(ltd.NetItemAmt) PatientPableAmt FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0),0) ");
            sqlCMD.Append(" WHERE pmh.TransactionID=@transactionID ");


            var param = new
            {

                ledgerTransactionNo = ledgerTransactionNo,
                transactionID = oldLTD[0].TransactionID
            };

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string ChangeRelationChange(string TransactionID, string KinRelation, string KinName, string KinPhone)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            sqlCMD = new StringBuilder("UPDATE patient_medical_history  pmh SET pmh.KinRelation=@KinRelation,pmh.KinName=@KinName,pmh.KinPhone=@KinPhone  WHERE pmh.TransactionID=@TransactionID ");
            var param = new
            {
                TransactionID = TransactionID,
                KinRelation = KinRelation,
                KinName = KinName,
                KinPhone=KinPhone
            };
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public string ChangeBillPanelDetails(string PanelGroup, int panelID, string ParentPanel, string PanelCorporate, string PolicyNO, string PolicyCardNO, string CardHolderName, string ExpireDate, string CardHolder, string PanelApprovalAmount, string PanelApprovalRemark, string Doctor, string ReferDoctor,string PRONAme, string ledgerTransactionNo, string transactionID)
    {
        if (Resources.Resource.AllowFiananceIntegration == "1")//
        {
            if (AllLoadData_IPD.CheckDataPostToFinance(ledgerTransactionNo) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." });
            }
        }
        if (string.IsNullOrEmpty(ledgerTransactionNo) && string.IsNullOrEmpty(transactionID))
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Invalid Details." });
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            //decimal _coPayPercent = Util.GetDecimal(coPayPercent);
           // sqlCMD = new StringBuilder(" UPDATE f_ledgertnxdetail ltd  SET ltd.CoPayPercent=@coPayPercent WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo ");
          //  excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
         //  {
        //       coPayPercent = Util.GetDecimal(_coPayPercent),
       //       ledgerTransactionNo = ledgerTransactionNo
      //    });
          //  if (panelID == Util.GetInt(Resources.Resource.DefaultPanelID))
           //     _coPayPercent = 100;
            sqlCMD = new StringBuilder("UPDATE patient_medical_history pmh SET pmh.PanelID=@panelID,pmh.ParentID=@ParentPanel,pmh.CorporatePanelID=@PanelCorporate,pmh.PolicyNo=@PolicyNo,pmh.CardNo=@PolicyCardNO,pmh.CardHolderName=@CardHolderName,pmh.ExpiryDate=@ExpiryDate,pmh.RelationWith_holder=@CardHolder,pmh.ApprovalAmount=@PanelApprovalAmount,pmh.ApprovalRemark=@PanelApprovalRemark,pmh.ReferedBy=@ReferDoctor,pmh.ProId=@PROID ");
           // sqlCMD.Append(" pmh.PanelPaybleAmt=(SELECT SUM(ltd.NetItemAmt-((ltd.NetItemAmt)*" + _coPayPercent + "/100)) PanelPayableAmount FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0), ");
          // sqlCMD.Append(" pmh.PatientPaybleAmt=(SELECT  SUM((ltd.NetItemAmt)*" + _coPayPercent + "/100) PatientPableAmt FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0) ");
            sqlCMD.Append(" WHERE pmh.TransactionID=@transactionID ");
            var param = new
            {
                panelID = panelID,
                ParentPanel = ParentPanel,
                PanelCorporate=PanelCorporate,
                PolicyNO=PolicyNO,
                PolicyCardNO=PolicyCardNO,
                CardHolderName=CardHolderName,
                ExpiryDate =Util.GetDateTime(ExpireDate),
                CardHolder=CardHolder,
                PanelApprovalAmount = Util.GetDecimal(PanelApprovalAmount),
                PanelApprovalRemark=PanelApprovalRemark,
                Doctor=Doctor,
                ReferDoctor=ReferDoctor,
                PROID=Util.GetInt(PRONAme),
                transactionID = transactionID,
                ledgerTransactionNo = ledgerTransactionNo,
            };
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);
            string query = "SELECT COUNT(*) AS COUNT,SUM(IF(ConfigID=5,'1','0')) AS allitem FROM f_ledgertnxdetail  WHERE transactionid=@transactionid GROUP BY transactionid";
            DataTable dt = excuteCMD.GetDataTable(tnx, query, CommandType.Text, param);
            //if (dt.Rows.Count > 0)
            //{
            //    int count = Util.GetInt(dt.Rows[0]["COUNT"].ToString());
            //    int Allitem = Util.GetInt(dt.Rows[0]["allitem"].ToString());
            //    if (Allitem == 0)
            //    {
            //        sqlCMD = new StringBuilder("UPDATE patient_medical_history pmh SET pmh.doctorid=@Doctor WHERE pmh.transactionid=@transactionid; ");
            //    }
            //    else {
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Refund the bill." });
            //    }
            //}
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);
            sqlCMD = new StringBuilder("UPDATE f_ledgertransaction lt   SET lt.PanelID=@panelID WHERE lt.LedgertransactionNo=@ledgertransactionNo ");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);
            sqlCMD = new StringBuilder("UPDATE f_reciept r SET r.PanelID=@panelID WHERE r.AsainstLedgerTnxNo=@ledgertransactionNo; ");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string ChangeBillPanel(int panelID, string ledgerTransactionNo, string transactionID, string coPayPercent)
    {
        if (Resources.Resource.AllowFiananceIntegration == "1")//
        {
            if (AllLoadData_IPD.CheckDataPostToFinance(ledgerTransactionNo) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." });
            }
        }

        if (string.IsNullOrEmpty(ledgerTransactionNo) && string.IsNullOrEmpty(transactionID))
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Invalid Details." });

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            decimal _coPayPercent = Util.GetDecimal(coPayPercent);

            sqlCMD = new StringBuilder(" UPDATE f_ledgertnxdetail ltd  SET ltd.CoPayPercent=@coPayPercent WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo ");

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                coPayPercent = Util.GetDecimal(_coPayPercent),
                ledgerTransactionNo = ledgerTransactionNo
            });


            if (panelID == Util.GetInt(Resources.Resource.DefaultPanelID))
                _coPayPercent = 100;

            sqlCMD = new StringBuilder(" UPDATE patient_medical_history pmh SET pmh.PanelID=@panelID, ");
            sqlCMD.Append(" pmh.PanelPaybleAmt=(SELECT SUM(ltd.NetItemAmt-((ltd.NetItemAmt)*" + _coPayPercent + "/100)) PanelPayableAmount FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0), ");
            sqlCMD.Append(" pmh.PatientPaybleAmt=(SELECT  SUM((ltd.NetItemAmt)*" + _coPayPercent + "/100) PatientPableAmt FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=@ledgerTransactionNo  AND ltd.isverified !=2 AND ltd.isPackage=0) ");
            sqlCMD.Append(" WHERE pmh.TransactionID=@transactionID ");


            var param = new
            {
                panelID = panelID,
                ledgerTransactionNo = ledgerTransactionNo,
                transactionID = transactionID
            };

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);

            sqlCMD = new StringBuilder("UPDATE f_ledgertransaction lt   SET lt.PanelID=@panelID WHERE lt.LedgertransactionNo=@ledgertransactionNo ");

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);

            sqlCMD = new StringBuilder("UPDATE f_reciept r SET r.PanelID=@panelID WHERE r.AsainstLedgerTnxNo=@ledgertransactionNo; ");

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, param);

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string savePanelDocuments(string TransactionId,string PatientID,int PanelID, List<PanelDocument> panelDocuments)
    {
        try
        {
         var result= PatientDocument.SavePanelDocument(panelDocuments, TransactionId, PatientID, PanelID);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response =result.message});// AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
    }
    [WebMethod]
    public string GetPanelDocument(string panelID, string transactionID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
     //   var dt = excuteCMD.GetDataTable("SELECT pd.DocumentID,pd.Document FROM  f_paneldocumentMaster pd INNER JOIN f_paneldocumentdetail pdd ON pd.DocumentID=pdd.DocumentID WHERE pd.IsActive=1  AND pdd.PanelID=@panelID", CommandType.Text, new { panelID = panelID });
        var dt = excuteCMD.GetDataTable("SELECT pd.DocumentID,pd.Document ,IFNULL(pdp.ImageInBase64,'') AS FilePath, IF(IFNULL(pdp.ImageInBase64,'')='',0,1) IsDocumentsExist FROM  f_paneldocumentMaster pd INNER JOIN f_paneldocumentdetail pdd ON pd.DocumentID=pdd.DocumentID LEFT JOIN f_paneldocument_patient pdp ON pdd.`DocumentID`=pdp.`PanelDocumentID` AND pdp.`PanelID`=pdd.`PanelID` AND pdp.`TransactionID`=@transactionID WHERE pd.IsActive=1  AND pdd.PanelID=@panelID GROUP BY pd.`DocumentID` ", CommandType.Text, new { panelID = panelID, transactionID = transactionID });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}