using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
public partial class Design_Emergency_EMG_PatinetSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindEmergencyRoomType(string FloorID)
    {
        DataTable dtData = new DataTable();
        string sql = "SELECT DISTINCT(ich.IPDCaseTypeID)IPDCaseType_ID,ich.Name,Role_ID FROM f_roomtype_role rt INNER JOIN ipd_case_type_master ich ON ich.IPDCaseTypeID=rt.IPDCaseTypeID  where Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ";
        if (FloorID != "0")
            sql += " and FloorID='" + FloorID + "'";
        dtData = StockReports.GetDataTable(sql);
        if (dtData.Rows.Count < 1)
        {
            DataTable dt = AllLoadData_IPD.LoadCaseType();
            DataView RoomTypeView = dt.DefaultView;
            RoomTypeView.RowFilter = "IsEmergency='1'";
            dtData = RoomTypeView.ToTable();
        }
        if (dtData.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string PatientSearch(string MRNo, string PName, string EmergencyNo, string PanelId, string fromDate, string toDate, string Status, string TriageCode, string WaitingType)
    {
        StringBuilder sb = new StringBuilder();

        if (Status == "STI")
        {
            sb.Append(" SELECT  IFNULL((select ifnull(CodeType,'')CodeType from codemaster cm where cm.id=pmh.PatientCodeType),'')PatientCode,'' 'v1','' 'v3',IFNULL(TIMESTAMPDIFF(MINUTE,CONCAT(PatientReceiveddate,' ',PatientReceivedTime),NOW()),0)'TT',IFNULL((select CONCAT('Temp: ',ipo.T,' Pulse: ',ipo.P,' BP: ',ipo.BP,' Resp: ',ipo.R,' SPO2: ',ROUND(ipo.SPO2,2))Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'')Vital, pmh.CentreID,pm.`PatientID`,epd.`EmergencyNo`,CONCAT(pm.`Title`,' ',pm.`PName`)'Name',CONCAT(pm.`Age`,'/',SUBSTR(pm.`Gender`,1,1))'AgeSex',Date_Format(pm.DOB,'%d-%b-%Y') DOB,   ");
            sb.Append(" '' 'Doctor','' 'Panel',DATE_FORMAT(epd.`EnteredOn`,'%d-%b-%Y %h:%i %p')'InDateTime',   ");
            sb.Append(" IFNULL(DATE_FORMAT(epd.`ReleasedDateTime`,'%d-%b-%Y %h:%i %p'),'')'ReleasedDateTime',   ");
            sb.Append(" 'STI' AS 'Status',pmh.TransactionID TID,'' LTnxNo,'' AS'Room','' `RoomId`,'' `PanelID`,'' BillNo ,'' ColorCode,'' CodeType,  ");
            sb.Append(" ifnull((SELECT pv.ID FROM emergency_prescriptionvisit pv WHERE pv.TransactionID=epd.transactionID AND pv.DoctorID=(SELECT DoctorID FROM doctor_employee WHERE Employeeid='" + HttpContext.Current.Session["ID"].ToString() + "' LIMIT 1)),'')App_ID ");
            sb.Append(" ,Concat(em.Title,' ',Ifnull(em.name,''))NurseName ,epd.Ispatientreceived,IFNULL(DATE_FORMAT(CONCAT(epd.`PatientReceiveddate`,' ',PatientReceivedTime),'%d-%b-%Y %h:%i %p'),'')'PatientReceiveddate',IFNULL(CONCAT(emm.`Title`,' ',emm.`NAME`),'')AdmittedBy  ");
            sb.Append(" FROM Emergency_Patient_Details epd   INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=epd.`TransactionId` ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=epd.`PatientId` AND epd.`IsReleased`=3  ");
            sb.Append(" LEFT JOIN patient_nurse_assignment pna ON pna.TransactionID=epd.TransactionId AND pna.STATUS=0 ");
            sb.Append(" LEFT JOIN employee_master em ON em.EmployeeID=pna.NurseID ");
            sb.Append(" LEFT JOIN employee_master emm ON epd.`EnteredBy`=emm.`EmployeeID` ");
            if (!String.IsNullOrEmpty(MRNo))
                sb.Append(" AND pm.`PatientID`='" + Util.GetFullPatientID(MRNo) + "' ");
            if (!String.IsNullOrEmpty(EmergencyNo))
                sb.Append(" AND epd.`EmergencyNo`='" + EmergencyNo + "' ");
            if (!String.IsNullOrEmpty(PName))
                sb.Append(" AND pm.PName like '" + PName + "%' ");
            sb.Append(" WHERE pmh.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' and epd.`ReleasedDateTime`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND epd.`ReleasedDateTime`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        }
        else
        {
 
            sb.Append(" SELECT  dm.DoctorID,IFNULL((select ifnull(CodeType,'')CodeType from codemaster cm where cm.id=pmh.PatientCodeType),'')PatientCode,epd.Complaint, epd.Alert,(SELECT COUNT(*) FROM patient_labinvestigation_OPD pli1   INNER JOIN `investigation_master` im ON im.investigation_ID=pli1.investigation_ID where im.ReportType='5' ");
            sb.Append(" AND  pli1.TransactionID=pmh.`TransactionID` and pli1.Approved='1' )'v2',(SELECT COUNT(*) FROM patient_labinvestigation_OPD pli1   INNER JOIN `investigation_master` im ON im.investigation_ID=pli1.investigation_ID where im.ReportType='5' ");
            sb.Append(" AND  pli1.TransactionID=pmh.`TransactionID` )'v5', (SELECT COUNT(*)  FROM  `patient_labinvestigation_OPD`  pli2   INNER JOIN `investigation_master` im ON im.investigation_ID=pli2.investigation_ID WHERE TransactionID=pmh.`TransactionID` AND im.ReportType  in('1','3') AND approved='1') 'v1', (SELECT COUNT(*)  FROM  `patient_labinvestigation_OPD` pli2   INNER JOIN `investigation_master` im ON im.investigation_ID=pli2.investigation_ID WHERE TransactionID=pmh.`TransactionID` AND im.ReportType<>'5' ) 'v3',IFNULL(TIMESTAMPDIFF(MINUTE,CONCAT(PatientReceiveddate,' ',PatientReceivedTime),NOW()),0)'TT',rm.Bed_No as Bed_No1,IFNULL((select CONCAT('Temp: ',ipo.T,' Pulse: ',ipo.P,' BP: ',ipo.BP,' Resp: ',ipo.R,' SPO2: ',ROUND(ipo.SPO2,2))Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'')Vital1 ,pmh.CentreID,pm.`PatientID`,epd.`EmergencyNo`,CONCAT(pm.`Title`,' ',pm.`PName`)'Name',CONCAT(pm.`Age`,'/',SUBSTR(pm.`Gender`,1,1))'AgeSex',Date_Format(pm.DOB,'%d-%b-%Y') DOB, ");
            sb.Append(" CONCAT(dm.`Title`,' ',dm.`Name`)'Doctor',pnl.`Company_Name` 'Panel',DATE_FORMAT(epd.`EnteredOn`,'%d-%b-%Y %h:%i %p')'InDateTime', ");

            sb.Append("    (SELECT ipo.T FROM cpoe_vital ipo  WHERE  IFNULL(ipo.t,'')<>'' AND TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) Temp, ");
            sb.Append("  (SELECT ipo.P FROM cpoe_vital ipo   WHERE  IFNULL(ipo.p,'')<>'' AND TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) Pulse, ");
            sb.Append("  (SELECT ipo.BP FROM cpoe_vital ipo   WHERE  IFNULL(ipo.BP,'')<>'' AND TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) BP, ");
            sb.Append("  (SELECT ipo.R FROM cpoe_vital ipo   WHERE  IFNULL(ipo.R,'')<>'' AND TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) RESP, ");
            sb.Append("  (SELECT ROUND(ipo.SPO2,2) FROM cpoe_vital ipo  WHERE  IFNULL(ROUND(ipo.SPO2,2),'')<>'' AND TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1)SPO2 ,");


            sb.Append(" IFNULL(DATE_FORMAT(epd.`ReleasedDateTime`,'%d-%b-%Y %h:%i %p'),'')'ReleasedDateTime', ");
            sb.Append(" IF(epd.`IsReleased`=0,'IN',IF(epd.`IsReleased`=1,'OUT',IF(epd.`IsReleased`=2,'RFI','STI')))'Status',pmh.`TransactionID` TID,lt.`LedgerTransactionNo` LTnxNo,CONCAT(rm.`Name`,'/',rm.`Room_No`,'/',rm.`Bed_No`)'Room',ifnull(rm.`RoomId`,'0')RoomId,pnl.`PanelID`,IFNULL(lt.BillNo,'')BillNo,tr.ColorCode,tr.CodeType, tr.ID as ColorSeq,");
            //Pending Investigation and Medicine
            sb.Append(" IFNULL((SELECT SUM(IFNULL((idp.ReqQty-(IFNULL(idp.ReceiveQty,0)+IFNULL(idp.RejectQty,0))),1))PendingQty  FROM patient_medicine ptm  ");
            sb.Append(" LEFT JOIN f_indent_detail_patient idp ON IDP.TransactionID=PTM.TransactionID AND  ptm.IndentNo = idp.IndentNo AND ptm.Medicine_ID = idp.ItemId  ");
            sb.Append(" WHERE ptm.TransactionID=epd.TransactionId),0)MedPending, ");
            sb.Append(" IFNULL((SELECT 1 FROM patient_test pt WHERE pt.TransactionID = pmh.TransactionID AND pt.IsIssue=0 AND pt.IsActive=1 LIMIT 1),0)TestPending, ");
            sb.Append(" ifnull((SELECT pv.ID FROM emergency_prescriptionvisit pv WHERE pv.TransactionID=pmh.TransactionID AND pv.DoctorID=(SELECT DoctorID FROM doctor_employee WHERE Employeeid='"+ HttpContext.Current.Session["ID"].ToString() +"' LIMIT 1)),'')App_ID ");
            sb.Append(" ,Concat(em.Title,'',Ifnull(em.name,''))NurseName,epd.Ispatientreceived,IFNULL(concat(DATE_FORMAT(epd.`PatientReceiveddate`,'%d-%b-%Y'),' ',Time_format(epd.PatientReceivedTime,'%h:%i %p')),'')'PatientReceiveddate',IFNULL(ewc.WaitingType,'')WaitingType,IFNULL(ewc.WaitingColorCode,'')WaitingColorCode ");
            sb.Append(" ,Ifnull(( SELECT CONCAT(dtm.Title,' ',dtm.Name)FROM employee_master dtm where dtm.EmployeeID = epd.MedicResidenceDocID and  epd.MedicResidenceDocID <>'0'),'')MedicResidenceDoc,IFNULL(CONCAT(emm.`Title`,' ',emm.`NAME`),'')AdmittedBy   ");
            sb.Append(" FROM Emergency_Patient_Details epd  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=epd.`TransactionId` ");
            if (!String.IsNullOrEmpty(EmergencyNo))
                sb.Append(" AND epd.`EmergencyNo`='" + EmergencyNo.Trim() + "' ");
            sb.Append(" left JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID` ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
            if (!String.IsNullOrEmpty(MRNo))
                sb.Append("  AND pmh.`PatientID`='" + Util.GetFullPatientID(MRNo.Trim()) + "' ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append(" left JOIN room_master rm ON rm.`RoomId`=epd.`RoomId` ");
            sb.Append(" LEFT JOIN emr_triagingcodes tr ON tr.ID=pmh.TriagingCode  ");
            sb.Append(" LEFT JOIN patient_medicine ptm ON ptm.TransactionID=epd.TransactionId AND ptm.IndentNo IS NOT NULL ");
            sb.Append(" LEFT JOIN f_indent_detail_patient idp ON idp.TransactionID=epd.TransactionId AND idp.ReqQty>=(idp.ReceiveQty+idp.RejectBy) ");
            sb.Append(" LEFT JOIN patient_test pt ON pt.TransactionID=epd.TransactionId AND pt.IsIssue=1 AND pt.IsActive=1 ");
            sb.Append(" LEFT JOIN patient_nurse_assignment pna ON pna.TransactionID=epd.TransactionId AND pna.STATUS=0 ");
            sb.Append(" LEFT JOIN employee_master em ON em.EmployeeID=pna.NurseID ");
            sb.Append(" LEFT JOIN emr_waitingvitalconsultant ewc ON ewc.ID=epd.WaitingID  ");
            //sb.Append(" LEFT JOIN Doctor_master dtm ON dtm.DoctorID = epd.MedicResidenceDocID  ");
            sb.Append(" LEFT JOIN employee_master emm ON epd.`EnteredBy`=emm.`EmployeeID` ");

            sb.Append(" WHERE epd.`EmergencyNo`<>'' AND pmh.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
            if (!String.IsNullOrEmpty(PName))
                sb.Append(" AND pm.PName like '" + PName + "%' ");
            if (String.IsNullOrEmpty(EmergencyNo) && String.IsNullOrEmpty(MRNo))
            {
                if (Status == "OUT")
                    sb.Append(" AND epd.`ReleasedDateTime`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND epd.`ReleasedDateTime`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                else if (Status != "IN" && Status != "OUT")
                    sb.Append(" AND epd.`EnteredOn`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND epd.`EnteredOn`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                if (PanelId != "null" && PanelId != "0")
                    sb.Append(" AND pnl.`PanelID`=" + Util.GetInt(PanelId) + "  ");
                if (WaitingType != "null" && WaitingType != "0")
                    sb.Append(" AND ewc.ID=" + WaitingType + " ");
                //sb.Append(" GROUP BY epd.TransactionId ");
               // if (Status != "Admission")
                  //  sb.Append(" HAVING STATUS='" + Status + "' ");
                if (TriageCode != "null" && TriageCode != "0")
                    sb.Append(" AND tr.ID=" + TriageCode + " ");
                if (Status == "IN")
                    sb.Append(" AND epd.`IsReleased`=0 ");
                else if (Status == "OUT")
                    sb.Append(" AND epd.`IsReleased`=1 ");
                else if (Status == "RFI")
                    sb.Append(" AND epd.`IsReleased`=2 ");
            }
            sb.Append("  GROUP BY epd.TransactionId Order by rm.`Name`,RoomId asc,epd.ID Desc");

          


        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }



    [WebMethod]
    public static string GetPendingInvestigationAndServices( string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT pt.Name, CONCAT(dm.Title,' ',dm.Name)DoctorName,pt.Quantity,DATE_FORMAT(pt.createdDate,'%d-%b-%Y')`Date`  FROM ");
        sqlCMD.Append(" patient_test pt  ");
        sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pt.DoctorID ");
        sqlCMD.Append(" WHERE pt.IsEmergencyData=1 AND pt.TransactionID='" + transactionID + "' AND pt.IsIssue=0 AND pt.IsActive=1 ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCMD.ToString()));
    }

    [WebMethod]
    public static string GetPendingMedicines(string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT pc.MedicineName `Name` , CONCAT(dm.Title,' ',dm.Name) DoctorName, pc.IssueQuantity `Quantity`, DATE_FORMAT(pc.Date,'%d-%b-%Y')`Date` FROM patient_medicine pc INNER JOIN doctor_master dm ON dm.DoctorID=pc.DoctorID WHERE pc.IsEmergencyData=1 AND pc.IsActive=1 AND pc.TransactionID='" + transactionID + "' ");
        sqlCMD.Append(" AND pc.IndentNo IS NULL UNION ALL SELECT f.ItemName  `Name` , CONCAT(dm.Title,' ',dm.Name) DoctorName, f.ReqQty `Quantity`, DATE_FORMAT(f.dtEntry,'%d-%b-%Y')`Date` FROM f_indent_detail_patient  f INNER JOIN doctor_master dm ON  dm.DoctorID=f.DoctorID WHERE f.TransactionID='" + transactionID + "'  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCMD.ToString()));
    }

    [WebMethod]
    public static string getWaitingType()
    {
        var dt = StockReports.GetDataTable("SELECT cc.ID,cc.WaitingType,cc.WaitingColorCode FROM emr_waitingVitalConsultant cc WHERE cc.IsActive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public static string SaveWaitingType(string waitingID, string TID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var message = "";
        try
        {
            string LastWaitng = StockReports.ExecuteScalar(" SELECT  CONCAT(IFNULL(WaitingID,''),'#',IFNULL(WaitingIDDateTime,''))Waiting FROM emergency_patient_details epd WHERE epd.TransactionID='" + TID + "' ");
            var SqlCMD = " Update emergency_patient_details epd set WaitingID=@WaitingID,WaitingLastID=@WaitingLastID,WaitingIDDateTime=NOW(),WaitingIDLastDateTime=@WaitingIDLastDateTime,WaitingCreatedBy=@WaitingCreatedBy WHERE epd.TransactionID=@TransactionID  ";
            excuteCMD.DML(tnx, SqlCMD, CommandType.Text, new
            {
                WaitingID = Util.GetInt(waitingID),
                WaitingLastID = Util.GetInt(LastWaitng.Split('#')[0]),
                WaitingIDLastDateTime = Util.GetDateTime(LastWaitng.Split('#')[1]),
                WaitingCreatedBy = HttpContext.Current.Session["ID"].ToString(),
                TransactionID=TID
            });

            message = "Record Save Sucessfully";

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