<%@ WebService Language="C#" Class="EmergencyBilling" %>
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
using System.IO;
using System.Text;
using System.Linq;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//[ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class EmergencyBilling : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string getEmergencyPatientDetails(string EmergencyNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT pm.`PatientID`,epd.`EmergencyNo`,pmh.PatientTypeID,IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo,CONCAT(pm.`Title`,' ',pm.`PName`)'Name',CONCAT(pm.`Age`,'/',pm.`Gender`)'AgeSex',   ");
        sb.Append("  CONCAT(dm.`Title`,' ',dm.`Name`)'Doctor',pnl.`Company_Name` 'Panel',DATE_FORMAT(epd.`EnteredOn`,'%d-%b-%Y %h:%i %p')'InDateTime',    ");
        sb.Append("  IFNULL(DATE_FORMAT(epd.`ReleasedDateTime`,'%d-%b-%Y %h-%i %p'),'')'ReleasedDateTime',    ");
        sb.Append("  IF(epd.`IsReleased`=0,'IN',IF(epd.`IsReleased`=1,'OUT',IF(epd.`IsReleased`=2,'RFI','STI')))'Status',pmh.`TransactionID` TID  ");
        sb.Append("  ,lt.`LedgerTransactionNo` LTnxNo,CONCAT(rm.`Name`,'/',rm.`Room_No`,'/',rm.`Bed_No`)'Room',rm.`RoomId`,pnl.`PanelID`,epd.`IPDCaseTypeID`,dm.`DoctorID` ");
        sb.Append(" ,lt.`GrossAmount`,lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`RoundOff`,ifnull(lt.`BillNo`,'')BillNo,IF(lt.`BillNo`<>'',DATE_FORMAT(lt.`BillDate`,'%d-%b-%Y'),'')'BillDate',pnl.ReferenceCodeOPD  ");
        sb.Append("   FROM Emergency_Patient_Details epd     ");
        sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=epd.`TransactionId`  AND epd.`EmergencyNo`='" + EmergencyNo + "'  ");
        sb.Append("  left JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID`    ");
        sb.Append("  INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID`    ");
        sb.Append("  INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID`    ");
        sb.Append("  INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID`    ");
        sb.Append("  left JOIN room_master rm ON rm.`RoomId`=epd.`RoomId`  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";


    }
    [WebMethod(EnableSession = true)]
    public string getEmergencyUserRights()
    {
        DataTable dt = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), HttpContext.Current.Session["ID"].ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            dt = StockReports.GetDataTable(" SELECT 0 CanEditEMGBilling,0 CanRejectEMGBilling,0 CanViewRatesEMGBilling,0 CanReleaseEMGPatient,0 CanCloseEMGBilling, 0 CanEditCloseEMGBilling  ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

    }
    [WebMethod]
    public string getEmergencyBillItemDetails(string LTnxNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ltd.`ID`,cm.`Name` 'Category',sb.`Name` 'Subcategory',ltd.`ItemName` 'Item',ltd.`Rate`,ltd.`Quantity`,ltd.`DiscountPercentage` 'DiscPer' ");
        sb.Append(" ,ltd.`DiscAmt`,ltd.`Amount`,IF(ltd.`ConfigID`=3 OR ltd.`ConfigID`=5,1,100)'MaxValue',if(ltd.TypeOfTnx IN ('CR','DR'),11,c.ConfigID)ConfigID,CONCAT(ltd.ItemID,'#',ifnull(ltd.CrDrNo,''))TypeOfTnx,DATE_FORMAT(ltd.EntryDate,'%d-%b-%y %h:%m %p')EntryDate,CONCAT(dm.Title,'',dm.Name)DoctorName FROM `f_ledgertnxdetail` ltd  ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sb ON sb.`SubCategoryID`=ltd.`SubCategoryID` ");
        sb.Append(" INNER JOIN `f_categorymaster` cm ON cm.`CategoryID`=sb.`CategoryID` ");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID=cm.CategoryID INNER JOIN doctor_master dm ON dm.DoctorID=ltd.DoctorID ");
        sb.Append(" WHERE ltd.`LedgerTransactionNo`='" + LTnxNo + "' AND ltd.`IsVerified`=1   GROUP BY ltd.ID ORDER BY cm.`Name`,sb.`Name`,ltd.`ItemName` ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string SaveEmergencyVisit(object LTD)
    {
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);


        ExcuteCMD excuteCMD = new ExcuteCMD();
        var isReleased = Util.GetInt(excuteCMD.ExecuteScalar("SELECT s.IsReleased FROM emergency_patient_details s WHERE  s.TransactionId=@transactionID", new
        {
            transactionID = dataLTD[0].TransactionID

        }));



        if (isReleased > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                status = false,
                response = (isReleased == 1 ? "Patient Has Been Released." : (isReleased == 2 ? "Patient Has Been Released for IPD." : "Patient Shifted To IPD."))
            });

        }





        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnxDtl.LedgerTransactionNo = dataLTD[0].LedgerTransactionNo;
            ObjLdgTnxDtl.ItemID = dataLTD[0].ItemID;
            ObjLdgTnxDtl.Rate = dataLTD[0].Rate;
            ObjLdgTnxDtl.Quantity = 1;
            ObjLdgTnxDtl.StockID = "";
            ObjLdgTnxDtl.IsTaxable = "NO";
            ObjLdgTnxDtl.Amount = dataLTD[0].Amount;
            ObjLdgTnxDtl.DiscountPercentage = 0;
            ObjLdgTnxDtl.DiscAmt = 0;
            ObjLdgTnxDtl.IsPackage = 0;
            ObjLdgTnxDtl.PackageID = "";
            ObjLdgTnxDtl.IsVerified = 1;
            ObjLdgTnxDtl.TransactionID = dataLTD[0].TransactionID;
            ObjLdgTnxDtl.SubCategoryID = dataLTD[0].SubCategoryID;
            ObjLdgTnxDtl.ItemName = dataLTD[0].ItemName;
            ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnxDtl.EntryDate = Util.GetDateTime(dataLTD[0].EntryDate.ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:ss"));
            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[0].SubCategoryID), con));
            ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
            ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[0].DiscAmt);
            ObjLdgTnxDtl.DoctorID = dataLTD[0].DoctorID;
            ObjLdgTnxDtl.RateListID = dataLTD[0].RateListID;
            ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
            ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnxDtl.Type = "E";
            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnxDtl.rateItemCode = dataLTD[0].rateItemCode;
            ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnxDtl.roundOff = 0;
            ObjLdgTnxDtl.CoPayPercent = 0;
            ObjLdgTnxDtl.typeOfTnx = "OPD-APPOINTMENT";
            ObjLdgTnxDtl.TnxTypeID = 5;
            ObjLdgTnxDtl.IPDCaseTypeID = dataLTD[0].IPDCaseTypeID;
            ObjLdgTnxDtl.RoomID = dataLTD[0].RoomID;
            string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
            if (string.IsNullOrEmpty(LdgTnxDtlID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In LdgTnx Details" });

            }
            int IsUpdate = updateEmergencyBillAmounts(tnx, dataLTD[0].LedgerTransactionNo);
            if (IsUpdate != 1)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction" });
            }


            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                // string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dataLTD[0].LedgerTransactionNo), "", "E", tnx));
                string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dataLTD[0].LedgerTransactionNo), "", "R", LdgTnxDtlID, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    throw new Exception("Error In Finance Integration Details");
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", message = "" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveEmergencyServices(object LTD, object PT, string CurrentAge, string PID)
    {
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var isReleased = Util.GetInt(excuteCMD.ExecuteScalar("SELECT s.IsReleased FROM emergency_patient_details s WHERE  s.TransactionId=@transactionID", new
        {
            transactionID = dataLTD[0].TransactionID

        }));



        if (isReleased > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                status = false,
                response = (isReleased == 1 ? "Patient Has Been Released." : (isReleased == 2 ? "Patient Has Been Released for IPD." : "Patient Shifted To IPD."))
            });

        }
        List<Patient_Test> dataPatient_Test = new JavaScriptSerializer().ConvertToType<List<Patient_Test>>(PT);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionId = dataLTD[0].TransactionID;
            string LedgerTransactionNo = dataLTD[0].LedgerTransactionNo;
            int sampleCollectCount = 0;
            string BarcodeNo = string.Empty;
            ///////////////
            string query = " SELECT UCASE(sc.DisplayName)DisplayName,sc.SubcategoryID,sc.Name FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON sc.CategoryID = cf.CategoryID " +
                           " WHERE sc.Active=1 AND cf.ConfigID=3 AND DisplayName='Radiology' ";
            List<int> subcategory = StockReports.GetDataTable(query).AsEnumerable().Select(r => r.Field<int>("SubcategoryID")).ToList<int>();
            int[] tokenNo = new int[subcategory.Count];
            ///////////////
            string typeOfTnx = string.Empty;
            int iCtr = 0, iNum = 0;
            iNum = Util.GetInt(dataLTD.Count(s => s.Type.Contains("LAB")));
            if (iNum > 0) iCtr += 1;
            iNum = Util.GetInt(dataLTD.Count(s => s.Type.Contains("PRO")));
            if (iNum > 0) iCtr += 1;
            iNum = Util.GetInt(dataLTD.Count(s => s.Type.Contains("OTH")));
            if (iNum > 0) iCtr += 1;
            if (iCtr == 1)
            {
                if (Util.GetString(dataLTD[0].Type) == "LAB")
                    typeOfTnx = "OPD-LAB";
                else if (Util.GetString(dataLTD[0].Type) == "PRO")
                    typeOfTnx = "OPD-PROCEDURE";
                else
                    typeOfTnx = "OPD-OTHERS";
            }
            else
            {
                typeOfTnx = "OPD-BILLING";
            }
            for (int i = 0; i < dataLTD.Count; i++)
            {
                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = dataLTD[i].LedgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[i].ItemID).Trim();
                ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[i].Rate);
                ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";
                
                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                ObjLdgTnxDtl.DiscountPercentage = 0;
                ObjLdgTnxDtl.Amount = Util.GetDecimal(dataLTD[i].Amount);
                if (ObjLdgTnxDtl.DiscountPercentage > 0)
                    ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = dataLTD[i].TransactionID;
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[i].ItemName).Trim();
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(dataLTD[i].EntryDate.ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:ss"));
                ObjLdgTnxDtl.DoctorID = dataLTD[i].DoctorID.Trim();
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dataLTD[i].TnxTypeID);
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.RateListID = dataLTD[i].RateListID;
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.Type = "E";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.rateItemCode = dataLTD[i].rateItemCode.Trim();
                ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.roundOff = 0;
                ObjLdgTnxDtl.typeOfTnx = typeOfTnx;
                ObjLdgTnxDtl.CoPayPercent = dataLTD[i].CoPayPercent;
                ObjLdgTnxDtl.IsPayable = dataLTD[i].IsPayable;
                ObjLdgTnxDtl.isPanelWiseDisc = dataLTD[i].isPanelWiseDisc;
                ObjLdgTnxDtl.IPDCaseTypeID = dataLTD[0].IPDCaseTypeID;
                ObjLdgTnxDtl.RoomID = dataLTD[0].RoomID;
                ////Get Token No  for Radiology Test//
                //if (subcategory.Contains(ObjLdgTnxDtl.SubCategoryID) && tokenNo[subcategory.IndexOf(ObjLdgTnxDtl.SubCategoryID)] == 0)
                //{
                //    int tmpToken = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_DeptSerialNo('" + ObjLdgTnxDtl.SubCategoryID + "') "));
                //    if (tmpToken > 0)
                //    {
                //        tokenNo[subcategory.IndexOf(ObjLdgTnxDtl.SubCategoryID)] = tmpToken;
                //        ObjLdgTnxDtl.TokenNo = tmpToken;
                //    }
                //}
                string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                if (LdgTnxDtlID == "")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In LdgTnx Details" });
                }

                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    //string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dataLTD[0].LedgerTransactionNo), "", "E", tnx));
                    string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dataLTD[i].LedgerTransactionNo), "", "R", LdgTnxDtlID, tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        throw new Exception("Error In Finance Integration Details");
                    }
                }

                if (dataLTD[i].Type == "LAB")
                {
                    Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                    objPLI.Investigation_ID = dataLTD[i].Type_ID;
                    objPLI.IsUrgent = Util.GetInt(dataPatient_Test[i].IsUrgent);
                    objPLI.Date = Util.GetDateTime(dataLTD[i].EntryDate.ToString("yyyy-MM-dd"));
                    objPLI.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    objPLI.Lab_ID = "LAB1";
                    objPLI.DoctorID = dataLTD[i].DoctorID.Trim();
                    objPLI.TransactionID = TransactionId;
                    string sampletypedetail = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(im.sampletypename,'#',im.SampleTypeID,'#',IFNULL(OutSourceLabID,'0')) FROM investigation_master im WHERE im.Investigation_Id='" + dataLTD[i].Type_ID + "'").ToString();
                    if (BarcodeNo == "")
                        BarcodeNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                    objPLI.BarcodeNo = BarcodeNo;
                    if (BarcodeNo == "0")
                        objPLI.PrePrintedBarcode = 1;
                    string sampleType = dataLTD[i].sampleType;
                    if (sampleType == "R")
                    {
                        objPLI.IsSampleCollected = "N";
                        sampleCollectCount += 1;
                    }
                    else
                    {
                        objPLI.IsSampleCollected = "S";
                        objPLI.SampleDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        objPLI.sampleCollectCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objPLI.SampleCollectionBy = HttpContext.Current.Session["ID"].ToString();
                        objPLI.SampleCollectionDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        objPLI.SampleCollector = HttpContext.Current.Session["LoginName"].ToString();
                        //objPLI.SampleReceiveDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        //objPLI.SampleReceivedBy = HttpContext.Current.Session["ID"].ToString();
                        //objPLI.SampleReceiver = HttpContext.Current.Session["LoginName"].ToString();
                    }
                    string[] stringList = Resources.Resource.HistoCytoSubcategoryID.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                    if (stringList.Contains(dataLTD[i].SubCategoryID))
                    {
                        objPLI.HistoCytoSampleDetail = 1;
                    }
                    objPLI.CurrentAge = CurrentAge;
                    objPLI.PatientID = PID;
                    objPLI.Special_Flag = 0;
                    objPLI.LedgerTransactionNo = LedgerTransactionNo;
                    objPLI.IPNo = "";
                    objPLI.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objPLI.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objPLI.LedgerTnxID = Util.GetInt(LdgTnxDtlID);
                    objPLI.OutSourceLabID = 0;
                    if (dataLTD[i].IsOutSource == 1)
                    {
                        objPLI.IsOutSource = 1;
                        objPLI.OutSourceBy = HttpContext.Current.Session["ID"].ToString();
                        objPLI.OutsourceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        objPLI.OutSourceLabID = Util.GetInt(sampletypedetail.Split('#')[2]);
                    }
                    objPLI.ReportDispatchModeID = 1;
                    objPLI.Type = 3;
                    objPLI.BookingCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objPLI.IPDCaseTypeID = dataLTD[0].IPDCaseTypeID;
                    objPLI.RoomID = dataLTD[0].RoomID;
                    objPLI.Remarks = dataLTD[i].Remark;
                    int resultPLI = objPLI.Insert();
                    if (resultPLI == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient LAB Investingation" });
                    }
                }
                string labPrescribedID = Util.GetString(dataPatient_Test[i].PatientTest_ID).Trim();
                if (labPrescribedID != "0")
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_Test SET IsIssue=1,OPDTransactionID='" + TransactionId + "',OPDLedgertansactionNO='" + LedgerTransactionNo + "',OPDLedgerTnxID='" + LdgTnxDtlID + "' WHERE PatientTest_ID='" + labPrescribedID + "' ");
            }


            int IsUpdate = updateEmergencyBillAmounts(tnx, dataLTD[0].LedgerTransactionNo);
            if (IsUpdate != 1)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction" });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });

        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string shiftEmergencyBed(string TID, string LtnxNo, string oldRoomId, string newRoomType, string newRoomId, string DoctorId, string PanelId)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var isReleased = Util.GetInt(excuteCMD.ExecuteScalar("SELECT s.IsReleased FROM emergency_patient_details s WHERE  s.TransactionId=@transactionID", new
        {
            transactionID = TID

        }));



        if (isReleased > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                status = false,
                response = (isReleased == 1 ? "Patient Has Been Released." : (isReleased == 2 ? "Patient Has Been Released for IPD." : "Patient Shifted To IPD."))
            });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string Query = "UPDATE `f_ledgertnxdetail` ltd SET ltd.`IsVerified`=2 ,ltd.`CancelUserId`='" + HttpContext.Current.Session["ID"].ToString() + "',ltd.`Canceldatetime`=NOW(),ltd.`CancelReason`='Bed Shifted' WHERE  ltd.`LedgerTransactionNo`='" + LtnxNo + "' AND ltd.`ConfigID`=2";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Query);
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE roomid='" + oldRoomId + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=2 WHERE roomid='" + newRoomId + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE `f_ledgertnxdetail` ltd SET ltd.`RoomID`='" + newRoomId + "',ltd.`IPDCaseTypeID`='" + newRoomType + "' WHERE ltd.`LedgerTransactionNo`='" + LtnxNo + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE emergency_patient_details SET RoomId='" + newRoomId + "',IPDCaseTypeID='" + newRoomType + "' WHERE TransactionId='" + TID + "' ");
            string ScheduleChargeID = AllLoadData_IPD.GetScheduleChargeID(Util.GetInt(PanelId));
            RoomBilling objRoom = new RoomBilling();
            string RoomDetail = objRoom.GetRoomItemDetails(Util.GetInt(PanelId), newRoomType, Util.GetInt(ScheduleChargeID));
            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnxDtl.LedgerTransactionNo = LtnxNo;
            ObjLdgTnxDtl.ItemID = Util.GetString(RoomDetail.Split('#')[0].ToString());
            ObjLdgTnxDtl.Rate = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
            ObjLdgTnxDtl.Quantity = 1;
            ObjLdgTnxDtl.StockID = "";
            ObjLdgTnxDtl.IsTaxable = "NO";
            ObjLdgTnxDtl.Amount = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
            ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0.00);
            ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
            ObjLdgTnxDtl.IsPackage = 0;
            ObjLdgTnxDtl.PackageID = "";
            ObjLdgTnxDtl.IsVerified = 1;
            ObjLdgTnxDtl.TransactionID = TID;
            ObjLdgTnxDtl.SubCategoryID = Util.GetString(RoomDetail.Split('#')[3]);
            ObjLdgTnxDtl.ItemName = Util.GetString(RoomDetail.Split('#')[1].ToString());
            ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ObjLdgTnxDtl.SubCategoryID), con));
            ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
            ObjLdgTnxDtl.IPDCaseTypeID = newRoomType;
            ObjLdgTnxDtl.RateListID = Util.GetInt(RoomDetail.Split('#')[5]);
            ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnxDtl.Type = "E";
            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            ObjLdgTnxDtl.IpAddress = HttpContext.Current.Request.UserHostAddress;
            ObjLdgTnxDtl.DoctorID = DoctorId;
            ObjLdgTnxDtl.RoomID = newRoomId;
            ObjLdgTnxDtl.typeOfTnx = "EMERGENCY";
            ObjLdgTnxDtl.TnxTypeID = 27;
            string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
            if (LdgTnxDtlID == string.Empty)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction Details" });
            }
            int IsUpdate = updateEmergencyBillAmounts(tnx, LtnxNo);



            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                // string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(LtnxNo), "", "E", tnx));
                string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(LtnxNo), "", "R", LdgTnxDtlID, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    throw new Exception("Error In Finance Integration Details");
                }
            }


            if (IsUpdate != 1)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction" });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Bed Shifted Successfully" });

        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public int updateEmergencyBillAmounts(MySqlTransaction tnx, string LedgerTnxNo)
    {
        try
        {
            string UpdateQuery = "Call updateEmergencyBillAmounts(" + LedgerTnxNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);

            return 1;


        }
        catch (Exception ex)
        {
            throw ex;
        }

    }
    [WebMethod(EnableSession = true)]
    public string rejectEmergencyItem(string LtdId, string LedgerTnxNo, string Reason, string TypeofTnx)
    {
        int ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.ID='" + LtdId + "' AND IFNULL(plo.Result_Flag,0)=1 AND im.ReportType<>5"));
        if (ResultFlag > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Result Already Done, Can Not Reject this Test." });
        }
        ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.ID='" + LtdId + "' AND IFNULL(plo.P_IN,0)=1 AND im.ReportType = 5 "));
        if (ResultFlag > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Already Done the Scan, Can Not Reject this Test." });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = 0;
            //count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_labinvestigation_opd plo WHERE plo.LedgertnxID=" + LtdId + " AND plo.IsSampleCollected<>'N'"));
            string Query = "UPDATE `f_ledgertnxdetail` ltd SET ltd.`IsVerified`=2,ltd.`CancelUserId`='" + HttpContext.Current.Session["ID"].ToString() + "',ltd.`Canceldatetime`=NOW(),ltd.`CancelReason`='" + Reason + "' WHERE  ltd.`ID`='" + LtdId + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Query);
            string docstring = All_LoadData.CalcaluteDoctorShare("", LtdId, "1", "HOSP", tnx, con);
            if (!String.IsNullOrEmpty(TypeofTnx.Split('#')[1]))
            {
                string drQuery = "UPDATE f_drcrnote dr SET dr.Cancel=1, dr.CancelUserID='" + HttpContext.Current.Session["ID"].ToString() + "', dr.CancelReason='" + Reason + "',dr.CancelDateTime=NOW() WHERE dr.CrDrNo='" + TypeofTnx.Split('#')[1] + "' AND dr.ItemID='" + TypeofTnx.Split('#')[0] + "' ; ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, drQuery);
            }
            Query = " UPDATE `patient_labinvestigation_opd` plo SET plo.`LedgerTransactionNo`='0',plo.`LedgerTransactionNo_Old`='" + LedgerTnxNo + "' WHERE plo.`LedgertnxID`='" + LtdId + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Query);
            int IsUpdate = updateEmergencyBillAmounts(tnx, LedgerTnxNo);
            if (IsUpdate != 1)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction" });
            }
            //if (Resources.Resource.AllowFiananceIntegration == "1")
            //{
            //    string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(LedgerTnxNo), "", "E", tnx));
            //    if (IsIntegrated == "0")
            //    {
            //        tnx.Rollback();
            //        throw new Exception("Error In Finance Integration Details");
            //    }
            //}
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Item Rejected Successfully.", message = "Item Rejected Successfully." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string updateBillItems(object LTD)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);


            //max Discount Validation
            string userID = HttpContext.Current.Session["ID"].ToString();
            var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(userID));

            var maxDiscountItems = dataLTD.Where(d => d.DiscountPercentage > maxEligibleDiscountPercent).ToList();


            if (maxDiscountItems.Count > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>", message = string.Empty });
            }

            //max Discount Validation
            
            
            
            
            for (int i = 0; i < dataLTD.Count; i++)
            {
                string Query = " UPDATE `f_ledgertnxdetail` ltd SET ltd.`Rate`=" + dataLTD[i].Rate + ",ltd.`Quantity`=" + dataLTD[i].Quantity + ",ltd.GrossAmount=(" + dataLTD[i].Rate * dataLTD[i].Quantity + "),ltd.`Amount`=" + dataLTD[i].Amount + ",ltd.`DiscountPercentage`=" + dataLTD[i].DiscountPercentage + ",ltd.`DiscAmt`=" + dataLTD[i].DiscAmt + ",ltd.`NetItemAmt`=" + dataLTD[i].Amount + ",ltd.`TotalDiscAmt`=" + dataLTD[i].DiscAmt + " WHERE ltd.`ID`=" + dataLTD[i].ID + " ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Query);
                string docstring = All_LoadData.CalcaluteDoctorShare("", Util.GetString(dataLTD[i].ID), "1", "HOSP", tnx, con);
            }
            int IsUpdate = updateEmergencyBillAmounts(tnx, dataLTD[0].LedgerTransactionNo);
            if (IsUpdate != 1)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction" });
            }



            //if (Resources.Resource.AllowFiananceIntegration == "1")
            //{
            //    string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dataLTD[0].LedgerTransactionNo), "", "E", tnx));
            //    if (IsIntegrated == "0")
            //    {
            //        tnx.Rollback();
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
            //    }
            //}


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string RelaseEmergencyPatient(string TID, string IsDeath, string ReleaseType, string DeathDate, string DeathTime, string DeathCause, string Remarks, string DeathType, string DathOver48hr, string ReleasedReason, int IsWithoutBill)
    {
        try
        {
            if (IsWithoutBill == 0)
            {
                AllUpdate AU = new AllUpdate();
                int isNurseClearanceDone = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM emergency_patient_details emr WHERE emr.IsNurseClean=1 AND emr.TransactionId='" + TID + "'"));
                int isBillClearanceDone = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM emergency_patient_details emr WHERE emr.IsBillingClean=1 AND emr.TransactionId='" + TID + "'"));
                int isDoctorClearanceDone = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM emergency_patient_details emr WHERE emr.IsDoctorClean=1 AND emr.TransactionId='" + TID + "'"));

                //if (isNurseClearanceDone > 0 && isBillClearanceDone > 0 && isDoctorClearanceDone > 0)
                //{
                //    if (IsDeath == "0")
                //    {
                //        StockReports.ExecuteDML(" Update patient_medical_history Set DischargeType ='" + ReleaseType + "' Where TransactionID ='" + TID + "' ");
                //    }
                //    else
                //    {
                //        StockReports.ExecuteDML(" Update patient_medical_history Set DischargeType ='" + ReleaseType + "',TimeOfDeath='" + Util.GetDateTime(DeathDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(DeathTime).ToString("HH:mm:ss") + "',TypeOfDeathID=" + DeathType + ",IsDeathOver48HRS=" + DathOver48hr + ",CauseOfDeath='" + DeathCause + "',Remarks='" + Remarks + "' Where TransactionID ='" + TID + "' ");
                //    }
                //    StockReports.ExecuteDML(" UPDATE Emergency_Patient_Details epd SET epd.`IsReleased`=1,epd.`ReleasedDateTime`='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',epd.`ReleasedBy`='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE epd.`TransactionId`='" + TID + "' ");
                //}
                if (IsDeath == "0")
                {
                    StockReports.ExecuteDML(" Update patient_medical_history Set DischargeType ='" + ReleaseType + "' Where TransactionID ='" + TID + "' ");
                }
                else
                {
                    StockReports.ExecuteDML(" Update patient_medical_history Set DischargeType ='" + ReleaseType + "',TimeOfDeath='" + Util.GetDateTime(DeathDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(DeathTime).ToString("HH:mm:ss") + "',TypeOfDeathID=" + DeathType + ",IsDeathOver48HRS=" + DathOver48hr + ",CauseOfDeath='" + DeathCause + "',Remarks='" + Remarks + "' Where TransactionID ='" + TID + "' ");
                }
                StockReports.ExecuteDML(" UPDATE Emergency_Patient_Details epd SET epd.`IsReleased`=1,epd.`ReleasedDateTime`='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',epd.`ReleasedBy`='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE epd.`TransactionId`='" + TID + "' ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Released Successfully" });
            }
                 
            else if (IsWithoutBill == 1)
            {
                StockReports.ExecuteDML(" Update patient_medical_history Set DischargeType ='" + ReleaseType + "',Remarks ='" + ReleasedReason + "' Where TransactionID ='" + TID + "' ");
                StockReports.ExecuteDML(" UPDATE Emergency_Patient_Details epd SET epd.`IsReleased`=1,epd.`ReleasedDateTime`='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',epd.`ReleasedBy`='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE epd.`TransactionId`='" + TID + "' ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Released Successfully" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Do Clearance First." });
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }

    }
    [WebMethod]
    public int checkZeroRateItems(string LTnxNo)
    {
        return Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`='" + LTnxNo + "' AND ltd.`IsVerified`=1 AND ltd.GrossAmount=0 AND ltd.LedgerTnxRefID= -1 "));
    }



    [WebMethod(EnableSession = true)]
    public string GenerateEmergencyBill(string LTnxNo, string PID, string TID, string RoomId, string PanelID)
    {
        //if (PanelID != Resources.Resource.DefaultPanelID)
        //{
        //    decimal billAmount = Util.round(Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(lt.NetAmount) FROM f_ledgertransaction lt WHERE lt.`LedgerTransactionNo`='" + LTnxNo + "'")));
        //    decimal AllocationAmount = Util.round(AllLoadData_IPD.GetAllocationAmount(TID));
        //    if ((billAmount - AllocationAmount) != 0)
        //    {
        //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Kindly do the panel allocation first." });
        //    }
        //}
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
		 ExcuteCMD excuteCMD = new ExcuteCMD(); 
        try
        {
            string BillNo = SalesEntry.genBillNo_opd(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            if (String.IsNullOrEmpty(BillNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Bill No" });
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE `f_ledgertransaction` lt SET lt.`BillNo`='" + BillNo + "',lt.`BillDate`='" + DateTime.Now.ToString("yyyy-MM-dd") + "',UserID='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE lt.`LedgerTransactionNo`='" + LTnxNo + "' ");


            string BillAmount = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT CONCAT(lt.`NetAmount`,'#',LT.GrossAmount,'#',lt.DiscountOnTotal)Amount FROM f_ledgertransaction lt WHERE lt.`LedgerTransactionNo`='" + LTnxNo + "' "));
           
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE roomid='" + RoomId + "' ");

            if (!string.IsNullOrEmpty(BillNo))
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE patient_medical_history SET TotalBilledAmt='" +  Util.GetDecimal(BillAmount.Split('#')[1]) + "',NetBillAmount='" +  Util.GetDecimal(BillAmount.Split('#')[0]) + "',ItemDiscount='" + Util.GetDecimal(BillAmount.Split('#')[2]) + "', BillNo='" + BillNo + "',BillDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',BillGeneratedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID=" + TID + " ");
            }

            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                //  string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(LTnxNo), "", "E", tnx));
                string IsIntegrated = Util.GetString(EbizFrame.InsertBillGenerate(Util.GetString(LTnxNo), "E", tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }
			
			 //doctor Share transaction update

             //excuteCMD.DML(tnx, "UPDATE f_DocShare_TransactionDetail s SET s.Transferdate=CURRENT_DATE() WHERE s.TransactionID=@transactionID", CommandType.Text, new
            //{
            //    transactionID = TID
            //});

            excuteCMD.DML(tnx, " CALL PostBillWiseDoctorShare(@TransactionID,@UserID,0) ", CommandType.Text, new
            {
                TransactionID = TID,
                UserID = HttpContext.Current.Session["ID"].ToString()

            });

            //doctor Share transaction update
			
			
			
			


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully.<br> Bill No. :<span style='color: black;'>" + BillNo + "</span>", });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string ShiftToIPD(string LTnxNo, string PID, string oldTID, string oldRoomId, string newRoomId, string newBillCategory, string IPDCaseTypeId, string HashCode,string doctorID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Patient_IPd_Profile pip WHERE pip.Status='IN' AND pip.PatientID='" + PID + "' "));
        if (count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Already Admitted.", message = "Patient Already Admitted." }); 
        }
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TID = string.Empty;
            string ScheduleChargeID = string.Empty;
            if (PID != "")
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT pmh.`DoctorID`,pmh.`Time`,pmh.`DateOfVisit`,pmh.`FeesPaid`,pmh.`PanelID`,pmh.`Source`,pmh.`ReferedBy`,pmh.`KinRelation`, ");
                sb.Append(" pmh.`KinName`,pmh.`KinPhone`,pmh.`ParentID`,pmh.`patient_type`,pmh.`PolicyNo`,pmh.`ExpiryDate`,pmh.`EmployeeDependentName`,pmh.`DependentRelation`, ");
                sb.Append(" pmh.`CardNo`,pmh.`Admission_Type`,pmh.`PanelIgnoreReason`,pmh.`CardHolderName`,pmh.`RelationWith_holder`,pmh.`MLC_NO`,pmh.`MLC_Type`, ");
                sb.Append(" pmh.`IsAdvance`,pmh.`IsNewPatient`,pmh.`ProId` FROM `patient_medical_history` pmh WHERE pmh.`TransactionID`='" + oldTID + "' ");
                DataTable dataPMH = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];

                Patient_Medical_History objPatient_Medical_History = new Patient_Medical_History(tnx);
                objPatient_Medical_History.PatientID = PID;
                objPatient_Medical_History.DoctorID = Util.GetString(doctorID);
                objPatient_Medical_History.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPatient_Medical_History.Time = Util.GetDateTime(dataPMH.Rows[0]["Time"]);
                objPatient_Medical_History.IsMultipleDoctor = Util.GetInt(0);
                objPatient_Medical_History.DateOfVisit = Convert.ToDateTime(dataPMH.Rows[0]["DateOfVisit"]);
                objPatient_Medical_History.FeesPaid = Util.GetDecimal(dataPMH.Rows[0]["FeesPaid"]);
                objPatient_Medical_History.Type = "IPD";
                objPatient_Medical_History.UserID = HttpContext.Current.Session["ID"].ToString();
                objPatient_Medical_History.EntryDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                objPatient_Medical_History.PanelID = Util.GetInt(dataPMH.Rows[0]["PanelID"]);
                objPatient_Medical_History.Source = Util.GetString(dataPMH.Rows[0]["Source"]);
                objPatient_Medical_History.ReferedBy = Util.GetString(dataPMH.Rows[0]["ReferedBy"]);
                objPatient_Medical_History.KinRelation = Util.GetString(dataPMH.Rows[0]["KinRelation"]);
                objPatient_Medical_History.KinName = Util.GetString(dataPMH.Rows[0]["KinName"]);
                objPatient_Medical_History.KinPhone = Util.GetString(dataPMH.Rows[0]["KinPhone"]);
                objPatient_Medical_History.ParentID = Util.GetInt(dataPMH.Rows[0]["ParentID"]);
                objPatient_Medical_History.patient_type = Util.GetString(dataPMH.Rows[0]["patient_type"]);
                objPatient_Medical_History.PolicyNo = Util.GetString(dataPMH.Rows[0]["PolicyNo"]);
                objPatient_Medical_History.ExpiryDate = Util.GetDateTime(dataPMH.Rows[0]["ExpiryDate"]);
                objPatient_Medical_History.EmployeeID = "";
                objPatient_Medical_History.EmployeeDependentName = Util.GetString(dataPMH.Rows[0]["EmployeeDependentName"]);
                objPatient_Medical_History.DependentRelation = Util.GetString(dataPMH.Rows[0]["DependentRelation"]);
                objPatient_Medical_History.CardNo = Util.GetString(dataPMH.Rows[0]["CardNo"]);
                ScheduleChargeID = AllLoadData_IPD.GetScheduleChargeID(objPatient_Medical_History.PanelID);
                objPatient_Medical_History.Admission_Type = Util.GetString(dataPMH.Rows[0]["Admission_Type"]);
                objPatient_Medical_History.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
                objPatient_Medical_History.PanelIgnoreReason = Util.GetString(dataPMH.Rows[0]["PanelIgnoreReason"]);
                objPatient_Medical_History.CardHolderName = Util.GetString(dataPMH.Rows[0]["CardHolderName"]);
                objPatient_Medical_History.RelationWith_holder = Util.GetString(dataPMH.Rows[0]["RelationWith_holder"]);
                objPatient_Medical_History.HashCode = HashCode;
                objPatient_Medical_History.MLC_NO = Util.GetString(dataPMH.Rows[0]["MLC_NO"]);
                objPatient_Medical_History.MLC_Type = Util.GetString(dataPMH.Rows[0]["MLC_Type"]);
                objPatient_Medical_History.isAdvance = Util.GetInt(dataPMH.Rows[0]["IsAdvance"]);
                objPatient_Medical_History.BirthIgnoreReason = "";
                objPatient_Medical_History.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPatient_Medical_History.IsNewPatient = Util.GetInt(dataPMH.Rows[0]["IsNewPatient"]);
                objPatient_Medical_History.ProId = Util.GetInt(dataPMH.Rows[0]["ProId"]);
                objPatient_Medical_History.STATUS = "IN";
                objPatient_Medical_History.DateOfAdmit = Util.GetDateTime(dataPMH.Rows[0]["DateOfVisit"]);
                objPatient_Medical_History.TimeOfAdmit = Util.GetDateTime(dataPMH.Rows[0]["Time"]);
                TID = objPatient_Medical_History.Insert();
                if (TID == string.Empty)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });
                }


                // Update Old Details
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE room_master SET IsRoomClean=1 WHERE roomid='" + oldRoomId + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE `emergency_patient_details` SET IsReleased=3,UpdatedOn=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionId='" + oldTID + "' ");
                sb.Clear();
                sb.Append(" UPDATE `f_ledgertransaction` lt INNER JOIN `f_ledgertnxdetail` ltd ON lt.`LedgerTransactionNo`=ltd.`LedgerTransactionNo` ");
                sb.Append(" SET ltd.`TransactionID`='" + TID + "',ltd.`RoomID`='" + newRoomId + "',ltd.`IPDCaseTypeID`='" + IPDCaseTypeId + "',lt.`TransactionID`='" + TID + "',lt.`TypeOfTnx`='IPD-Billing', ");
                sb.Append(" ltd.`TypeOfTnx`=IF(ltd.`TypeOfTnx` NOT IN('CR','DR'),'IPD-Billing',ltd.`TypeOfTnx`),ltd.`Type`='I',ltd.IsShiftToIPD=1,ltd.oldTransactionID='" + oldTID + "',ltd.ShiftedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ltd.ShiftedDateTime=NOW() WHERE lt.`LedgerTransactionNo`='" + LTnxNo + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                sb.Clear();
                sb.Append(" UPDATE `f_docshare_transactiondetail` ds  SET ds.`TransactionID`='" + TID + "',ds.`Type`='I',ds.`TypeOfTnx`= IF(ds.`TypeOfTnx` IN('CR','DR'),ds.`TypeOfTnx`,'IPD-Billing'),ds.`UpdatedBy`='" + HttpContext.Current.Session["ID"].ToString() + "',ds.`UpdatedDateTime`=NOW() WHERE ds.`LedgerTransactionNo`='" + LTnxNo + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                sb.Clear();
                sb.Append(" UPDATE `f_docshare_transactiondetail_lab` ds  SET ds.`TransactionID`='" + TID + "',ds.`Type`='I',ds.`TypeOfTnx`= IF(ds.`TypeOfTnx` IN('CR','DR'),ds.`TypeOfTnx`,'IPD-Billing'),ds.`UpdatedBy`='" + HttpContext.Current.Session["ID"].ToString() + "',ds.`UpdatedDateTime`=NOW() WHERE ds.`LedgerTransactionNo`='" + LTnxNo + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString()); 
                

                sb.Clear();
                //sb.Append(" SELECT plo.`Investigation_ID`,plo.`Date`,plo.`Time`,plo.`IsSampleCollected`,DATE_FORMAT(plo.`SampleDate`,'%Y-%c-%d %H:%i:%S')SampleDate,plo.`LedgertnxID`, ");
                //sb.Append(" plo.`Remarks`,plo.`DoctorID`,plo.`IsUrgent`,plo.`IsOutSource`,plo.`OutSourceBy`,plo.`OutsourceDate`,plo.`OutSourceLab` ");
                //sb.Append(" ,plo.Result_Flag,plo.LabInves_Description,plo.ResultEnteredBy,DATE_FORMAT(plo.`ResultEnteredDate`,'%Y-%c-%d %H:%i:%S')ResultEnteredDate,plo.IsCritical,plo.CriticalDoctor,plo.`Test_ID` ");
                //sb.Append(" FROM `patient_labinvestigation_opd` plo WHERE plo.`LedgerTransactionNo`='" + LTnxNo + "'  ");
                //DataTable dataPLO = StockReports.GetDataTable(sb.ToString());
                //foreach (DataRow dr in dataPLO.Rows)
                //{
                //    string LTDId = Util.GetString(dr["LedgertnxID"]);
                //    Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                //    objPLI.Investigation_ID = Util.GetString(dr["Investigation_ID"]);
                //    objPLI.Date = Util.GetDateTime(dr["Date"]);
                //    objPLI.Time = Util.GetDateTime(dr["Time"]);
                //    objPLI.TransactionID = TID;
                //    objPLI.IsSampleCollected = Util.GetString(dr["IsSampleCollected"]);
                //    objPLI.SampleDate = Util.GetDateTime(dr["SampleDate"].ToString());
                //    objPLI.Special_Flag = 0;
                //    //objPLI. = 0;
                //    objPLI.Result_Flag = Util.GetInt(dr["Result_Flag"]);
                //    objPLI.LedgerTransactionNo = LTnxNo;
                //    objPLI.LedgerTnxID = Util.GetInt(dr["LedgertnxID"]);
                //    objPLI.PatientID = PID;
                //    objPLI.Remarks = Util.GetString(dr["Remarks"]);
                //    objPLI.DoctorID = Util.GetString(dr["DoctorID"]);
                //    objPLI.IsUrgent = Util.GetInt(dr["IsUrgent"]);
                //    objPLI.IsOutSource = Util.GetInt(dr["IsOutSource"]);
                //    objPLI.OutSourceLabID = Util.GetInt(dr["OutSourceLab"]);
                //    objPLI.OutSourceBy = Util.GetString(dr["OutSourceBy"]);
                //    objPLI.OutsourceDate = Util.GetDateTime(dr["OutsourceDate"]);
                //    objPLI.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                //    objPLI.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                //    objPLI.IPDCaseType_ID = IPDCaseTypeId;
                //    objPLI.Room_ID = newRoomId;

                //    objPLI.Insert();
                //    string lastTestId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT pli.`Test_ID` FROM patient_labinvestigation_opd pli WHERE pli.`Investigation_ID`='" + Util.GetString(dr["Investigation_ID"]) + "' AND pli.`LedgertnxID`='" + LTDId + "' AND pli.`LedgerTransactionNo`='" + LTnxNo + "'"));
                //    sb.Clear();
                //    sb.Append(" UPDATE patient_labinvestigation_opd pli SET pli.LabInves_Description='" + Util.GetString(dr["LabInves_Description"]) + "',pli.ResultEnteredBy='" + Util.GetString(dr["ResultEnteredBy"]) + "',pli.ResultEnteredDate='" + Util.GetDateTime(dr["ResultEnteredDate"].ToString()) + "', ");
                //    sb.Append(" pli.IsCritical='" + Util.GetInt(dr["IsCritical"]) + "',pli.CriticalDoctor='" + Util.GetString(dr["CriticalDoctor"]) + "' WHERE pli.`Test_ID`='" + lastTestId + "' ");
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                //    sb.Clear();
                //    sb.Append(" INSERT INTO patient_labobservation_ipd(LabObservation_ID, Result_Date, Result_Time, VALUE, Description,Test_ID,`MinValue`,`MaxValue`,LabObservationName,Priorty,InvPriorty,COMMENT,ReadingFormat,IsBold,IsUnderLine) ");
                //    sb.Append(" SELECT LabObservation_ID, Result_Date, Result_Time, VALUE, Description,'" + lastTestId + "',`MinValue`,`MaxValue`,LabObservationName,Priorty,InvPriorty,COMMENT,ReadingFormat,IsBold,IsUnderLine FROM patient_labobservation_opd  ");
                //    sb.Append(" WHERE Test_ID='" + Util.GetString(dr["Test_ID"]) + "' ");
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                //}
                
                
             //   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE patient_labinvestigation_opd plo SET plo.`LedgerTransactionNo`=0,plo.`LedgerTransactionNo_Old`='" + LTnxNo + "' WHERE plo.`LedgerTransactionNo`='" + LTnxNo + "' ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE patient_labinvestigation_opd plo SET plo.TransactionID='" + TID + "',plo.Type=2 WHERE plo.`LedgerTransactionNo`='" + LTnxNo + "' ");

                
                //
                DateTime InDateTime = Util.GetDateTime(Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT DATE_FORMAT(epd.`EnteredOn`,'%Y-%c-%d %H:%i:%S')  FROM Emergency_Patient_Details epd WHERE epd.`TransactionId`='" + oldTID + "' ")));

                //-----Insert Into IPD_Case_History-----//
                //IPD_Case_History objIPD_Case_History = new IPD_Case_History(tnx);
                //objIPD_Case_History.TransactionID = TID;
                //objIPD_Case_History.Consultant_ID = Util.GetString(dataPMH.Rows[0]["DoctorID"]);
                //objIPD_Case_History.Consultant_ID1 = "";
                //objIPD_Case_History.Employed = "No";
                //objIPD_Case_History.DateOfAdmit = Util.GetDateTime(InDateTime.ToString("yyyy-MM-dd"));
                //objIPD_Case_History.TimeOfAdmit = Util.GetDateTime(InDateTime.ToString("HH:mm:ss"));
                //objIPD_Case_History.DateOfDischarge = DateTime.Parse("01/01/0001");
                //objIPD_Case_History.TimeOfDischarge = DateTime.Parse("00:00:00");
                //objIPD_Case_History.Status = "IN";
                //objIPD_Case_History.Insurance = "No";
                //objIPD_Case_History.GroupID = "1";
                //objIPD_Case_History.Consultant_Name = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT CONCAT(dm.`Title`,' ',dm.`Name`) FROM doctor_master dm WHERE dm.`DoctorID`='" + Util.GetString(dataPMH.Rows[0]["DoctorID"]) + "' "));
                //objIPD_Case_History.IsRoomRequest = 0;
                //objIPD_Case_History.RequestedRoomType = "";
                //objIPD_Case_History.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                //objIPD_Case_History.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                //int ichCount = objIPD_Case_History.Insert();
                //if (ichCount == 0)
                //{
                //    tnx.Rollback();
                //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In IPD Case History" });
                //}
                //---Insert into Patient_IPD_Profile-----------//
                Patient_IPD_Profile objPatient_IPD_Profile = new Patient_IPD_Profile(tnx);
                objPatient_IPD_Profile.IsTempAllocated = 0;
                objPatient_IPD_Profile.Status = "IN";
                objPatient_IPD_Profile.TransactionID = TID;
                objPatient_IPD_Profile.IPDCaseTypeID = IPDCaseTypeId;
                objPatient_IPD_Profile.StartDate = Util.GetDateTime(InDateTime.ToString("yyyy-MM-dd"));
                objPatient_IPD_Profile.StartTime = Util.GetDateTime(InDateTime.ToString("HH:mm:ss"));
                objPatient_IPD_Profile.RoomID = newRoomId;
                objPatient_IPD_Profile.TobeBill = 1;
                objPatient_IPD_Profile.PatientID = PID;
                objPatient_IPD_Profile.IPDCaseTypeID_Bill = newBillCategory;
                objPatient_IPD_Profile.PanelID = Util.GetInt(dataPMH.Rows[0]["PanelID"]);
                objPatient_IPD_Profile.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPatient_IPD_Profile.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                int pIPCount = objPatient_IPD_Profile.Insert();
                if (pIPCount == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In IPD Profile" });
                }
                AllQuery AQ = new AllQuery();
                string ledgerNumber = AQ.GetLedgerNoByPatientID(PID, tnx);

                //ipdadjustment iAdj = new ipdadjustment(tnx);
                //iAdj.PatientID = PID;
                //iAdj.TransactionID = TID;
                //iAdj.PatientLedgerNo = ledgerNumber;
                //iAdj.CreditLimitPanel = 0;
                //iAdj.DoctorID = Util.GetString(dataPMH.Rows[0]["DoctorID"]);
                //iAdj.PanelID = Util.GetInt(dataPMH.Rows[0]["PanelID"]);
                //iAdj.CreditLimitType = "A";
                //iAdj.BillingRemarks = "";
                //iAdj.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                //iAdj.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                //iAdj.Patient_Type = Util.GetString(dataPMH.Rows[0]["patient_type"]);
                //iAdj.CurrentAge = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Get_Current_Age('" + PID + "')"));

                //int adjCount = iAdj.Insert();
                //if (ichCount == 0)
                //{
                //    tnx.Rollback();
                //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In IPD Adjustment" });
                //}
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert into f_DoctorShift (TransactionID,DoctorID,FromDate,FromTime,UserID,Status) values('" + TID + "','" + Util.GetString(doctorID) + "','" + InDateTime.ToString("yyyy-MM-dd") + "','" + InDateTime.ToString("HH:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','IN' )");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " Insert into emr_ipd_details (TransactionID) values ('" + TID + "')");

                //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " INSERT INTO IPD_Bill_PrintCount(FormatName,TransactionID) SELECT FormatName,'" + TID + "' AS 'TID' FROM `IPD_Bill_FormatMaster` WHERE IsActive=1 ");

		//BloodBank Service 
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE ipdservices_request ip SET ip.TransactionID='" + TID + "' , ip.Patient_Type='IPD' WHERE ip.TransactionID='" + oldTID + "' AND ip.IsBilled=0");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE roomid='" + oldRoomId + "' ");
                
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Shifted Successfully.<br> IPD No. :<span style='color: blue;'>" + TID.Replace("ISHHI", "") + "</span>", IPDNO = TID.Replace("ISHHI", ""), patientID = PID });
            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });

            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string RelaseForIPD(string TID, string EMGNo, string RoomId)
    {
        string Released = string.Empty;
        //DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        //if (dtAuthority.Rows.Count > 0)
        //{
        //    Released = dtAuthority.Rows[0]["CanReleaseEMGPatient"].ToString();
        //}
        Released = "1";
        if (Released == "0" || Released == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "You Are Not Authorize To Released The Patient." });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE roomid='" + RoomId + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE `emergency_patient_details` SET IsReleased=2,ReleasedDateTime=NOW(),ReleasedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE EmergencyNo='" + EMGNo + "' "); // AND TransactionId='" + TID + "'
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Released Successfully." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public int getBillCloseRights(string TID)
    {
        int clean = Util.GetInt(StockReports.ExecuteScalar("SELECT IsBillingClean FROM emergency_patient_details WHERE TransactionID='" + TID + "'"));
        return clean;
    }

    [WebMethod(EnableSession = true)]
    public string SendPanelApprovalEmail(PanelApprovalDetails panelApprovalDetails)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var costEstimationPath = string.Empty;
        try
        {
            if (Util.GetDecimal(panelApprovalDetails.approvalAmount) < 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Approval Amont." });
            
            var panelEmailID = Util.GetString(excuteCMD.ExecuteScalar("SELECT pm.EmailID FROM f_panel_master pm WHERE pm.PanelID=@panelID", new
            {
                panelID = panelApprovalDetails.panelID
            }));


            var NICNumber = Util.GetString(excuteCMD.ExecuteScalar("SELECT s.IDProofNumber FROM PatientID_proofs s WHERE s.PatientID=@patientID AND s.IDProofID=1", new
            {
                patientID = panelApprovalDetails.patientID

            }));




            //if (string.IsNullOrEmpty(panelEmailID))
              //  return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Email Not found for this panel." });

            var notifyMessage = string.Empty;



            if (panelApprovalDetails.attachCostEstimation)
            {
                costEstimationPath = Util.GetString(excuteCMD.ExecuteScalar("SELECT  s.path FROM f_costestimationbilling s WHERE s.PatientID=@patientID LIMIT 1", new
                {
                    patientID = panelApprovalDetails.patientID

                }));

                if (string.IsNullOrEmpty(costEstimationPath))
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Cost Estimation Not Found." });

            }

            var attchments = PatientDocument.SavePanelDocument(panelApprovalDetails.panelDocuments, panelApprovalDetails.transactionID, panelApprovalDetails.patientID, Util.GetInt(panelApprovalDetails.panelID));

            var sqlCMD = new StringBuilder();

            sqlCMD = new StringBuilder(" SELECT pm.PatientID, pm.PatientID MRNo, CAST(pmh.TransactionID AS CHAR(50))AS TransactionID, CONCAT(pm.Title,' ',pm.PName)PatientName, pm.Age, CAST(dm.DoctorID AS CHAR(50))AS DoctorID,  ");
            sqlCMD.Append(" CONCAT(dm.Title,'',dm.Name) DoctorName, pm.Title, '' AppDate, '' RoomNo,0 Bed_No, fpm.Company_Name  PanelName, '' EmployeeName,    ");
            sqlCMD.Append("  '' UserName, '' RoomType, CAST(pmh.TransactionID AS CHAR(50)) IPNo, '' Discount,''  ApprovalAmount    ");
            sqlCMD.Append(" FROM  patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID    ");
            sqlCMD.Append(" INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID    ");
            sqlCMD.Append(" WHERE pmh.TransactionID=@transactionID  ");

            DataTable dtEmailDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                transactionID = panelApprovalDetails.transactionID,
                patientID = panelApprovalDetails.patientID
            });


            var d = Util.GetListFromDataTable<EmailTemplateInfo>(dtEmailDetails);

            d[0].EmployeeName = HttpContext.Current.Session["UserName"].ToString();
            d[0].UserName = HttpContext.Current.Session["UserName"].ToString();
            d[0].EmailTo = panelEmailID;
            d[0].ApprovalAmount = panelApprovalDetails.approvalAmount;
            d[0].PolicyCardNumber = panelApprovalDetails.policyCardNumber;
            d[0].PolicyNumber = panelApprovalDetails.policyNumber;
            d[0].PolicyExpiryDate = Util.GetDateTime(panelApprovalDetails.policyExpiryDate).ToString("yyyy-MM-dd");
            d[0].NICNumber = NICNumber;
            d[0].Password = string.Empty;


            var attchmentPaths = string.Join(",", attchments.panelDocuments.Select(i => i.DocumentSaveURLPath).ToList());

            if (!string.IsNullOrEmpty(costEstimationPath))
                attchmentPaths += "," + costEstimationPath;


int sendEmailID = 0;// Email_Master.SaveEmailTemplate(2, Util.GetInt(Session["RoleID"].ToString()), "1", d, attchmentPaths, tnx);

            // if (sendEmailID < 1)
            // return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Unable to Schedule Email." });


sqlCMD = new StringBuilder("INSERT INTO panelapproval_emaildetails (Email,TransactionID,SendEmailID,ApprovalAmount,PolicyCardNumber,PolicyExpiryDate,PolicyNumber,NICNumber,EntryBy ,ApprovalRemark,PanelID,NameOnCard,CardHolderRelation,IgnorePolicy,IgnorePolicyReason) ");
sqlCMD.Append(" VALUES ( @Email,@TransactionID,@SendEmailID,@ApprovalAmount,@PolicyCardNumber,@PolicyExpiryDate,@PolicyNumber,@NICNumber,@EntryBy,@ApprovalRemark,@panelID,@NameOnCard,@CardHolderRelation,@IgnorePolicy,@IgnorePolicyReason) ");


            var response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                Email = panelEmailID,
                TransactionID = panelApprovalDetails.transactionID,
                SendEmailID = sendEmailID,
                ApprovalAmount = panelApprovalDetails.approvalAmount,
                PolicyCardNumber = panelApprovalDetails.policyCardNumber,
                PolicyExpiryDate = Util.GetDateTime(panelApprovalDetails.policyExpiryDate).ToString("yyyy-MM-dd"),
                PolicyNumber = panelApprovalDetails.policyNumber,
                NICNumber = panelApprovalDetails.NICNumber,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                ApprovalRemark = panelApprovalDetails.approvalRemark,
                panelID = panelApprovalDetails.panelID,
                NameOnCard = panelApprovalDetails.nameOnCard,
                CardHolderRelation = panelApprovalDetails.cardHolderRelation,
                IgnorePolicy = panelApprovalDetails.ignorePolicy == true ? 1 : 0,
                IgnorePolicyReason = panelApprovalDetails.ignorePolicyReason,
            });

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
    public string checkSampleCollected(string ltdID, string configID)
    {
 //       int CanRefund = Util.GetInt(StockReports.ExecuteScalar(" SELECT CanRefundAfterResult FROM userauthorization WHERE RoleId=" + Util.GetInt(HttpContext.Current.Session["RoleID"]) + " and  EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "' "));

        DataTable dt = StockReports.GetDataTable("SELECT IsSampleCollected,TYPE FROM patient_labinvestigation_opd WHERE LedgertnxID='" + ltdID + "'");
        if (dt.Rows.Count > 0 && Util.GetString(dt.Rows[0]["TYPE"]) == "3" && Util.GetString(dt.Rows[0]["IsSampleCollected"]) == "Y")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Sample has been Collected" });
        }
        else if (dt.Rows.Count > 0 && Util.GetString(dt.Rows[0]["TYPE"]) == "1" && Util.GetString(dt.Rows[0]["IsSampleCollected"]) == "Y")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient has been accepted" });
        }
        else {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
        }
    }
}