<%@ WebService Language="C#" Class="IPD" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to <a href="IPD.asmx">IPD.asmx</a>be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class IPD : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindAmtDiff(string TID)
    {
        string retn = "";
        StringBuilder sbBill = new StringBuilder();
        sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round((t2.GrossAmt-t2.TotalDiscount),2)NetAmt,");
        sbBill.Append(" Round(((((t2.GrossAmt-t2.TotalDiscount)*5)/100)+(t2.GrossAmt-t2.TotalDiscount)),2)TotalAmt,");
        sbBill.Append("  ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt FROM ( ");
        sbBill.Append("     select ltd.TransactionID,sum(ltd.Rate*ltd.Quantity)GrossAmt,");
        sbBill.Append("     IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100)");
        sbBill.Append("     +IFNULL(ipd.DiscountOnBill,0),2),0)TotalDiscount,IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2),0)TotalItemWiseDiscount, ");
        sbBill.Append("     IFNULL(ipd.PanelApprovedAmt,0)PanelApprovedAmt From f_ledgertnxdetail ltd ");
        sbBill.Append("     inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo");
        sbBill.Append("     INNER JOIN f_ipdadjustment ipd ON ipd.TransactionID=lt.TransactionID ");
        sbBill.Append("     INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID ");
        sbBill.Append("     WHERE Lt.IsCancel = 0 and ltd.IsFree = 0 and ltd.IsVerified = 1 ");
        sbBill.Append("     and ltd.IsPackage = 0");
        sbBill.Append("     and lt.TransactionID = '" + TID + "' ");
        sbBill.Append("     group by lt.TransactionID ");
        sbBill.Append(")T2  Left join (");
        sbBill.Append("     select TransactionID,sum(AmountPaid)RecAmt from f_reciept where IsCancel = 0 ");
        sbBill.Append("     and TransactionID = '" + TID + "' ");
        sbBill.Append("      group by TransactionID ");
        sbBill.Append(")T3 on T2.TransactionID = T3.TransactionID");
        DataTable dtBill = new DataTable();
        dtBill = StockReports.GetDataTable(sbBill.ToString());
        if (dtBill.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dtBill);
            return retn;
        }
        else
        {
            return retn;
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string dischargeType(string TID)
    {
        if (TID != "")
            TID = StockReports.getTransactionIDbyTransNo(TID.Trim());//"ISHHI" +
        
        
        DataTable dt = StockReports.GetDataTable("select PM.PatientID,PMH.TransactionID,PMH.TransNo,PMH.DischargeType,CONCAT(PM.Title,' ',PM.PName)PName,CONCAT(PM.House_No,' ',Street_Name,' ',City)Address from patient_medical_history PMH inner join patient_master PM on PMH.PatientID=PM.PatientID where PMH.TransactionID='" + TID + "' AND PMH.Type='IPD' AND PMH.Status='OUT'");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public bool changeDischargeType(string TID, string DischargeType)
    {
        AllUpdate AU = new AllUpdate();
        return AU.UpdateDischargeType(TID, DischargeType);

    }


    [WebMethod]
    public string bindUserRemarks(string TID)
    {
        string userRemarks = StockReports.ExecuteScalar("SELECT Remarks FROM  IPD_UserRemarks WHERE TransactionID='" + TID + "' ORDER BY ID DESC LIMIT 1");
        if (userRemarks != "")
        {
            return userRemarks;
        }
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string IPDUserRemarks(string TID, string userRemarks)
    {
        try
        {
            StockReports.ExecuteScalar("INSERT INTO IPD_UserRemarks(TransactionID,Remarks,CreatedBy) VALUES('" + TID + "','" + userRemarks + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindIPDUserRemarks(string TID)
    {
        DataTable userRemarks = StockReports.GetDataTable("SELECT Remarks,CONCAT(em.Title,' ',em.Name)CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate FROM  IPD_UserRemarks re INNER JOIN employee_master em on re.CreatedBy=em.employeeID WHERE TransactionID='" + TID + "' ORDER BY re.ID DESC ");
        if (userRemarks.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(userRemarks);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string GetThesoldLimit(string TID)
    {
        string IPDCaseTypeID = StockReports.ExecuteScalar("SELECT IPDCaseType_ID FROM patient_ipd_profile WHERE TransactionID='" + TID + "' AND STATUS='IN' ");
        string PanelID = StockReports.ExecuteScalar("SELECT pm.ReferenceCode FROM patient_medical_history pmh INNER JOIN f_panel_master pm ON pm.PanelID=pmh.PanelID WHERE TransactionID='" + TID + "'");
        decimal BillAmount = Util.GetDecimal(StockReports.ExecuteScalar(" SELECT (BillAmount-Discount)TotalBillAmt FROM (SELECT IFNULL(SUM(Amount),0) AS BillAmount,IFNULL(adj.DiscountOnBill,0)Discount FROM f_ledgertnxdetail ltd INNER JOIN f_ipdadjustment adj ON adj.TransactionID=ltd.TransactionID WHERE ltd.TransactionID='" + TID + "' AND isverified=1)t "));
        decimal AdvanceAmt = Util.GetDecimal(StockReports.ExecuteScalar(" SELECT IFNULL(SUM(AmountPaid),0)AdvanceAmount FROM f_reciept WHERE TransactionID='" + TID + "'  AND isCancel=0 "));
        decimal ThresholdAmt = Util.GetDecimal(StockReports.ExecuteScalar(" SELECT amount FROM f_thresholdlimit WHERE Isactive=1 AND PanelID=" + PanelID + " AND Room_type='" + IPDCaseTypeID + "' "));
        if (ThresholdAmt > 0)
        {
            if ((BillAmount - AdvanceAmt) > ThresholdAmt)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("This Patient Cross the Threshold Limit, BillAmount is : " + BillAmount +", Advance Amount is : " + AdvanceAmt + " And Threshold Limit is : "+ThresholdAmt);
            }
            else
            {
                return "0";
            }
        }
        else
            return "0";
    }
    
    
    
    //Check Discharge Check List
    [WebMethod]
    public string getDischargeCheckList(string TID)
    {

        string sqlCommand = "SELECT CONCAT(rim.`ItemName`,'(QTY :',ROUND(rim.`Quantity`,0),')')'Item' FROM `roomtype_roomitem_mapping` rim ";
        sqlCommand += " INNER JOIN `ipd_case_type_master` ict ON rim.`IPDCaseTypeId`=ict.`IPDCaseTypeID` ";
        sqlCommand += " WHERE ict.`IPDCaseTypeID`=(SELECT IPDCaseTypeID FROM `patient_ipd_profile` WHERE TransactionID='" + TID + "' ORDER BY PatientIPDProfile_ID DESC  LIMIT 1) ";
        DataTable dt = StockReports.GetDataTable(sqlCommand);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]

    public string PatientTransferSearch(string FromDate, string ToDate, string patientID, int PatientCategory)
    {
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("CALL getRPT_TransferOnRequestPatient ('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + patientID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "'," + PatientCategory + ")");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); }
        }
        catch (Exception ex)
        {

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }

    }
     [WebMethod(EnableSession = true)]

    public string BindSelctedReffereHospital(string RefferingHospital)
    {
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.NAME)Dname FROM f_center_doctor cd INNER JOIN doctor_master dm ON dm.DoctorID=cd.DoctorID WHERE cd.CentreID='" + RefferingHospital.Trim() + "' AND cd.isActive=1 order by dm.Name");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Doctor Record Found Against Selected Reffering Hospital" }); }
        }
        catch (Exception ex)
        {

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }

    }

     [WebMethod(EnableSession = true)]
     public string SaveEditPatientTransferRequest(object PTransferDetail)
     {
         List<TransferPatientRequestFromOutside> dataTP = new JavaScriptSerializer().ConvertToType<List<TransferPatientRequestFromOutside>>(PTransferDetail);
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try {
             if (dataTP[0].PatientTransferCategory == 2) { dataTP[0].CentreIDTo = Util.GetInt(HttpContext.Current.Session["CentreID"]); }
             
             string sqlCMD = " UPDATE PatientTransferReqest SET CentreIDFrom=@CentreID,CentreIDTo=@CentreIDTo,InchargeDoctorID=@InchargeDoctorID,DiagnosisReason=@DiagnosisReason,ManagmentStatusReason=@ManagmentStatusReason,NeedIcuandHdu=@NeedIcuandHdu";
             sqlCMD += " ,CentreID=@CentreID,DiscussWithConsultantName=@DiscussWithConsultantName,DiscussWithResidentName=@DiscussWithResidentName,DiscussWithInternName=@DiscussWithInternName,CallBackAfterDiscussionName=@CallBackAfterDiscussionName,UpdateBy=@UpdateBy,UpdatedDate=NOW(),CallerName=@CallerName,ReturnPhoneNo=@ReturnPhoneNo ";
             sqlCMD += " ,OutSidePName=@OutSidePName,OutSideAge=@OutSideAge,OutSideVitalGCS=@OutSideVitalGCS,OutSideVitalPulse=@OutSideVitalPulse,OutSideVitalBP=@OutSideVitalBP";
             sqlCMD += " ,OutSideVitalRR=@OutSideVitalRR,OutSideVitalSAT=@OutSideVitalSAT,OutSideVitalTemp=@OutSideVitalTemp,OutSideModeofPayment=@OutSideModeofPayment";
             sqlCMD += " ,OutSideNHIFCardNo=@OutSideNHIFCardNo,OutSideIsBillingOfficer=@OutSideIsBillingOfficer,OutSideReason=@OutSideReason ,OutSideRefferingHospitalName=@OutSideRefferingHospitalName,OutSideInchargeDoctor=@OutSideInchargeDoctor,RoomTypeID=@RoomTypeID,RoomNoId=@RoomNoId where ID=@ID ";      

                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new {
                        CentreIDFrom= Util.GetInt(HttpContext.Current.Session["CentreID"]),
                        CentreIDTo=Util.GetInt(dataTP[0].CentreIDTo),
                        InchargeDoctorID = Util.GetInt(dataTP[0].InchargeDoctorID),
                        DiagnosisReason = Util.GetString(dataTP[0].DiagnosisReason),
                        ManagmentStatusReason = Util.GetString(dataTP[0].ManagmentStatusReason),
                        NeedIcuandHdu=Util.GetInt(dataTP[0].NeedIcuandHdu),
                        CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                        DiscussWithConsultantName = dataTP[0].DiscussWithConsultantName,
                        DiscussWithResidentName = dataTP[0].DiscussWithResidentName,
                        DiscussWithInternName = dataTP[0].DiscussWithInternName,
                        CallBackAfterDiscussionName = dataTP[0].CallBackAfterDiscussionName,
                        UpdateBy = Util.GetString(HttpContext.Current.Session["ID"]),
                        ID = Util.GetInt(dataTP[0].ID),
                        CallerName = dataTP[0].CallerName,
                        ReturnPhoneNo = dataTP[0].ReturnPhoneNo,
                        IsActive = 1,
                        OutSidePName = dataTP[0].OutSidePName,
                        OutSideAge = dataTP[0].OutSideAge,
                        OutSideVitalGCS = dataTP[0].OutSideVitalGCS,
                        OutSideVitalPulse = dataTP[0].OutSideVitalPulse,
                        OutSideVitalBP = dataTP[0].OutSideVitalBP,
                        OutSideVitalRR = dataTP[0].OutSideVitalRR,
                        OutSideVitalSAT = dataTP[0].OutSideVitalSAT,
                        OutSideVitalTemp = dataTP[0].OutSideVitalTemp,
                        OutSideModeofPayment = dataTP[0].OutSideModeofPayment,
                        OutSideNHIFCardNo = dataTP[0].OutSideNHIFCardNo,
                        OutSideIsBillingOfficer = Util.GetInt(dataTP[0].OutSideIsBillingOfficer),
                        OutSideReason = Util.GetString(dataTP[0].OutSideReason),
                        OutSideRefferingHospitalName = dataTP[0].OutSideRefferingHospitalName,
                        OutSideInchargeDoctor = dataTP[0].OutSideInchargeDoctor,
                        RoomTypeID=dataTP[0].RoomTypeID.ToString(),
                        RoomNoId=dataTP[0].RoomNoId
                    });
                    tnx.Commit();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }

     [WebMethod(EnableSession = true)]
     public string RefferingDoctor(string centreID)
     {
         try
         {

             StringBuilder sb = new StringBuilder();
             sb.Append("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.NAME)Dname FROM f_center_doctor cd INNER JOIN doctor_master dm ON dm.DoctorID=cd.DoctorID WHERE cd.CentreID='" + centreID.Trim() + "' AND cd.isActive=1 order by dm.Name");
             DataTable dt = StockReports.GetDataTable(sb.ToString());
             if (dt.Rows.Count > 0)
             {
                 return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
             }
             else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Doctor Record Found Against Selected Reffering Hospital" }); }
         }
         catch (Exception ex)
         {

             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
     }
     [WebMethod(EnableSession = true)]
     public string PatientTransferRequestAcknowledge(int ID)
     { 
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try { string sqlCMD = " Update PatientTransferReqest set IsAcknowledge=@IsAcknowledge,AcknowledgeBy=@AcknowledgeBy,AcknowledgeDate=NOW(),CentreID=@CentreID where ID=@ID";
         excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
         {
             IsAcknowledge=1,
             AcknowledgeBy=HttpContext.Current.Session["ID"].ToString(),
             CentreID = HttpContext.Current.Session["CentreID"],
             ID=ID
         });
             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Acknowledge  Successfully" });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }
     [WebMethod(EnableSession = true)]
     public string PatientTransferRequestReceive(int ID)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {
             string sqlCMD = " Update PatientTransferReqest set IsReceived=@IsReceived,ReceivedBy=@ReceivedBy,ReceivedDate=NOW(),CentreID=@CentreID where ID=@ID";
             excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
             {
                 IsReceived = 1,
                 ReceivedBy = HttpContext.Current.Session["ID"].ToString(),
                 CentreID = HttpContext.Current.Session["CentreID"],
                 ID = ID
             });
             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Received  Successfully" });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }

     public class TransferPatientRequestFromOutside
     {
         public string CallerName { get; set; }
         public string ReturnPhoneNo { get; set; }
         public string OutSideInchargeDoctor { get; set; }
         public string OutSidePName { get; set; }
         public string OutSideAge { get; set; } 
         public string OutSideVitalGCS { get; set; }
         public string OutSideVitalPulse { get; set; }
         public string OutSideVitalBP { get; set; }
         public string OutSideVitalRR { get; set; }
         public string OutSideVitalSAT { get; set; }
         public string OutSideVitalTemp { get; set; }
         public string OutSideModeofPayment { get; set; }
         public string OutSideNHIFCardNo { get; set; }
         public int OutSideIsBillingOfficer { get; set; }
         public string OutSideReason { get; set; }
         public string OutSideRefferingHospitalName { get; set; }
         public string DiagnosisReason { get; set; }
         public string ManagmentStatusReason { get; set; }
         public int NeedIcuandHdu { get; set; }
         public string DiscussWithConsultantName { get; set; }
         public string DiscussWithResidentName { get; set; }
         public string DiscussWithInternName { get; set; }
         public string CallBackAfterDiscussionName { get; set; }
         public int PatientTransferCategory { get; set; }
         public int CentreIDTo { get; set; }
         public int InchargeDoctorID { get; set; }
         public int ID { get; set; }
         public string RoomTypeID { get; set; }
         public string RoomNoId { get; set; }
     }

     [WebMethod(EnableSession = true)]

     public string SavePatientTransferFromOutside(object PTransferDetail)
     {
         List<TransferPatientRequestFromOutside> dataTP = new JavaScriptSerializer().ConvertToType<List<TransferPatientRequestFromOutside>>(PTransferDetail);
         
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();

         var message = "";
         try { 
         string sqlCMD="  INSERT INTO PatientTransferReqest(CentreIDTo,DiagnosisReason,ManagmentStatusReason,NeedIcuandHdu,CreatedBy,CreatedDate,CentreID,IPAddress,DiscussWithConsultantName,DiscussWithResidentName ";
                sqlCMD+=" ,DiscussWithInternName,CallBackAfterDiscussionName,CallerName,ReturnPhoneNo,IsActive,OutSidePName,OutSideAge,OutSideVitalGCS,OutSideVitalPulse,OutSideVitalBP ";
                sqlCMD += " ,OutSideVitalRR,OutSideVitalSAT,OutSideVitalTemp,OutSideModeofPayment,OutSideNHIFCardNo,OutSideIsBillingOfficer,OutSideReason,OutSideRefferingHospitalName,OutSideInchargeDoctor,PatientTransferCategory) ";
                sqlCMD+=" VALUES(@CentreIDTo,@DiagnosisReason,@ManagmentStatusReason,@NeedIcuandHdu,@CreatedBy,NOW(),@CentreID,@IPAddress,@DiscussWithConsultantName, ";
                sqlCMD+=" @DiscussWithResidentName,@DiscussWithInternName,@CallBackAfterDiscussionName,@CallerName,@ReturnPhoneNo,@IsActive,@OutSidePName,@OutSideAge,  ";
                sqlCMD+=" @OutSideVitalGCS,@OutSideVitalPulse,@OutSideVitalBP,@OutSideVitalRR,@OutSideVitalSAT,@OutSideVitalTemp,@OutSideModeofPayment,@OutSideNHIFCardNo, ";
                sqlCMD += " @OutSideIsBillingOfficer,@OutSideReason,@OutSideRefferingHospitalName,@OutSideInchargeDoctor,@PatientTransferCategory) ";

                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    CentreIDTo=Util.GetInt(HttpContext.Current.Session["CentreID"]),
                    DiagnosisReason=Util.GetString(dataTP[0].DiagnosisReason),
                    ManagmentStatusReason = Util.GetString(dataTP[0].ManagmentStatusReason),
                    NeedIcuandHdu=Util.GetInt(dataTP[0].NeedIcuandHdu),
                    CreatedBy=HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                    IPAddress = HttpContext.Current.Request.UserHostAddress,
                    DiscussWithConsultantName=dataTP[0].DiscussWithConsultantName,
                    DiscussWithResidentName=dataTP[0].DiscussWithResidentName,
                    DiscussWithInternName=dataTP[0].DiscussWithInternName,
                    CallBackAfterDiscussionName=dataTP[0].CallBackAfterDiscussionName,
                    CallerName=dataTP[0].CallerName,
                    ReturnPhoneNo=dataTP[0].ReturnPhoneNo,
                    IsActive=1,
                    OutSidePName=dataTP[0].OutSidePName,
                    OutSideAge=dataTP[0].OutSideAge,
                    OutSideVitalGCS=dataTP[0].OutSideVitalGCS,
                    OutSideVitalPulse = dataTP[0].OutSideVitalPulse,
                    OutSideVitalBP = dataTP[0].OutSideVitalBP,
                    OutSideVitalRR = dataTP[0].OutSideVitalRR,
                    OutSideVitalSAT = dataTP[0].OutSideVitalSAT,
                    OutSideVitalTemp = dataTP[0].OutSideVitalTemp,
                    OutSideModeofPayment = dataTP[0].OutSideModeofPayment,
                    OutSideNHIFCardNo = dataTP[0].OutSideNHIFCardNo,
                    OutSideIsBillingOfficer=Util.GetInt(dataTP[0].OutSideIsBillingOfficer),
                    OutSideReason=Util.GetString(dataTP[0].OutSideReason),
                    OutSideRefferingHospitalName=dataTP[0].OutSideRefferingHospitalName,
                    OutSideInchargeDoctor=dataTP[0].OutSideInchargeDoctor,
                    PatientTransferCategory=2 //2 Means Tranfer Patient From Other Hospital
                });
                message = "Record Save successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
         }

         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
         
     }
        

}
