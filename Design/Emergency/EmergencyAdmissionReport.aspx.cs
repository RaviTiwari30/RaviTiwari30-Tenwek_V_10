
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Emergency_EmergencyAdmissionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string BindEMRPatientDetails(string RoomType, string PID, string EmergencyNo)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT ifnull( CONCAT(dtm.Title,' ',dtm.Name),'')MedicResidenceDoc,IFNULL((select ifnull(CodeType,'')CodeType from codemaster cm where cm.id=pmh.PatientCodeType),'')PatientCode, pmh.`DoctorID`,IFNULL(epd.Complaint,'') as 'Complaint',IFNULL(epd.Alert,'') as 'Alert',pmh.TransactionID as 'TransactionID1',IFNULL((select IFNULL(ipo.T,'')  'Temp'  from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'') as 'Temp',IFNULL((select IFNULL(ipo.P ,'') from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'') as 'Pulse'" +
    ",IFNULL((select IFNULL(ipo.BP,'')  from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'') as 'BP',IFNULL((select IFNULL(ipo.R,'')  from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'') as  'Resp',IFNULL((select IFNULL(ROUND(ipo.SPO2,2),'')  from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'') as 'SPO2',(SELECT COUNT(*) FROM patient_labinvestigation_OPD pli1   INNER JOIN `investigation_master` im ON im.investigation_ID=pli1.investigation_ID where im.ReportType='5' " +
" AND  pli1.TransactionID=pmh.`TransactionID` and pli1.Approved='1' )'v2',(SELECT COUNT(*) FROM patient_labinvestigation_OPD pli1   INNER JOIN `investigation_master` im ON im.investigation_ID=pli1.investigation_ID where im.ReportType='5' " +
" AND  pli1.TransactionID=pmh.`TransactionID` )'v5', (SELECT COUNT(*)  FROM  `patient_labinvestigation_OPD`   pli3   INNER JOIN `investigation_master` im ON im.investigation_ID=pli3.investigation_ID WHERE TransactionID=pmh.`TransactionID` AND im.ReportType in ('1','3') AND approved='1') 'v1', (SELECT COUNT(*)  FROM  `patient_labinvestigation_OPD`   pli2   INNER JOIN `investigation_master` im ON im.investigation_ID=pli2.investigation_ID WHERE TransactionID=pmh.`TransactionID` AND im.ReportType <>'5'  ) 'v3',IFNULL(TIMESTAMPDIFF(MINUTE,CONCAT(PatientReceiveddate,' ',PatientReceivedTime),NOW()),0)'TT',ifnull(CONCAT(rm.`Name`,'/',rm.`Bed_No`),'') as Bed_No1,IFNULL((select CONCAT('Temp: ',ipo.T,' Pulse: ',ipo.P,' BP: ',ipo.BP,' Resp: ',ipo.R,' SPO2: ',ROUND(ipo.SPO2,2))Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1),'')Vital ,pmh.CentreID,pm.`PatientID`,epd.`EmergencyNo`,CONCAT(pm.`Title`,' ',pm.`PName`)'Name',CONCAT(pm.`Age`,'/',SUBSTR(pm.`Gender`,1,1))'AgeSex',Date_Format(pm.DOB,'%d-%b-%Y') DOB, ");
            sb.Append(" CONCAT(dm.`Title`,' ',dm.`Name`)'Doctor',pnl.`Company_Name` 'Panel',DATE_FORMAT(epd.`EnteredOn`,'%d-%b-%Y %h:%i %p')'InDateTime', ");
            sb.Append(" IFNULL(DATE_FORMAT(epd.`ReleasedDateTime`,'%d-%b-%Y %h:%i %p'),'')'ReleasedDateTime', ");
            sb.Append(" IF(epd.`IsReleased`=0,'IN',IF(epd.`IsReleased`=1,'OUT',IF(epd.`IsReleased`=2,'RFI','STI')))'Status',pmh.`TransactionID` TID,lt.`LedgerTransactionNo` LTnxNo,CONCAT(rm.`Name`,'/',rm.`Room_No`,'/',rm.`Bed_No`)'Room',rm.`RoomId`,pnl.`PanelID`,IFNULL(lt.BillNo,'')BillNo,tr.ColorCode,tr.CodeType, ifnull(tr.ID,'') as ColorSeq,");
            //Pending Investigation and Medicine
            sb.Append(" IFNULL((SELECT SUM(IFNULL((idp.ReqQty-(IFNULL(idp.ReceiveQty,0)+IFNULL(idp.RejectQty,0))),1))PendingQty  FROM patient_medicine ptm  ");
            sb.Append(" LEFT JOIN f_indent_detail_patient idp ON IDP.TransactionID=PTM.TransactionID AND  ptm.IndentNo = idp.IndentNo AND ptm.Medicine_ID = idp.ItemId  ");
            sb.Append(" WHERE ptm.TransactionID=epd.TransactionId),0)MedPending, ");
            sb.Append(" IFNULL((SELECT 1 FROM patient_test pt WHERE pt.TransactionID = pmh.TransactionID AND pt.IsIssue=0 AND pt.IsActive=1 LIMIT 1),0)TestPending, ");
            sb.Append(" ifnull((SELECT pv.ID FROM emergency_prescriptionvisit pv WHERE pv.TransactionID=pmh.TransactionID AND pv.DoctorID=(SELECT DoctorID FROM doctor_employee WHERE Employeeid='"+ HttpContext.Current.Session["ID"].ToString() +"' LIMIT 1)),'')App_ID ");
            sb.Append(" ,IFNULL(Concat(em.Title,' ',Ifnull(em.name,'')),'')NurseName,epd.Ispatientreceived,IFNULL(DATE_FORMAT(epd.`PatientReceiveddate`,'%d-%b-%Y %h:%i %p'),'')'PatientReceiveddate' ");
          //  sb.Append(" , IFNULL( CONCAT( TIME_FORMAT(IF(WaitingID=4 AND WaitingLastID=3,IF(WaitingIDLastDateTime='0001-01-01 00:00:00','',TIMEDIFF(WaitingIDDateTime,WaitingIDLastDateTime)),''),'%I'),' MINS'),'')ConsultantStatus,IF(WaitingID=3 OR WaitingID=4 ,ewc.WaitingType,'')WaitingType ");
            sb.Append(",(case when WaitingID=4 AND WaitingLastID=3 then concat(MINUTE(TIMEDIFF(WaitingIDDateTime,WaitingIDLastDateTime)),' MINS') WHEN WaitingID=3 THEN CONCAT(MINUTE(TIMEDIFF(NOW(),WaitingIDDateTime)),' MINS') ELSE '' END)ConsultantStatus,IF(WaitingID=3 OR WaitingID=4 ,ewc.WaitingType,'')WaitingType ");
            sb.Append(" FROM Emergency_Patient_Details epd  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=epd.`TransactionId` ");
            if (EmergencyNo != "")
            {
                sb.Append(" AND epd.EmergencyNo='" + EmergencyNo + "'");
            }
                
        sb.Append(" left JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID` ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
            if (PID != "")
            {
                sb.Append(" AND pmh.PatientID='" + PID + "'");

            }
            //sb.Append("  AND pmh.`PatientID`='" + Util.GetFullPatientID(PID) + "' ");
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
            sb.Append(" LEFT JOIN Doctor_master dtm ON dtm.DoctorID = epd.MedicResidenceDocID  ");
            sb.Append(" WHERE epd.`EmergencyNo`<>'' and epd.IsReleased=0 AND pmh.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND rm.`Bed_No` is not null");
            if (EmergencyNo != "")
            {
                sb.Append(" AND epd.EmergencyNo='"+EmergencyNo+"'");
            }
            if (PID != "")
            {
                sb.Append(" AND epd.PatientID='" + PID + "'");
            
            }
                
  	        sb.Append(" GROUP BY epd.TransactionId ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        HttpContext.Current.Session["dtExport2Excel"] = dt;
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        
          
else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); }
        
    
    }

    [WebMethod(EnableSession = true)]
    public static string Bindwardtypepatientlistreport(string RoomType, string PID, string EmergencyNo)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(CONCAT(rm.`Name`,rm.`Bed_No`),'') as BedNo,tr.ID as 'Acuity level',pm.`PName` as 'Patient Name',CONCAT(pm.`Age`,'/',SUBSTR(pm.`Gender`,1,1))'AgeSex',IFNULL(epd.Complaint,'') as 'Chief Complaint',IFNULL(TIMESTAMPDIFF(MINUTE,CONCAT(PatientReceiveddate,' ',PatientReceivedTime),NOW()),0)'Treatment Time','' as 'Time in Status','' as 'MOA',Concat(em.Title,' ',Ifnull(em.name,'')) 'Nurse', CONCAT(dm.`Title`,' ',dm.`Name`)'Doctor'," +
            "(select ipo.T Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) as 'Temp',(select ipo.P Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) as 'Pulse'"+
        ",(select ipo.BP Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) as 'BP',(select ipo.R Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) as  'Resp',(select ROUND(ipo.SPO2,2) Vitial from cpoe_vital ipo where TransactionID=pmh.TransactionID ORDER BY ID DESC LIMIT 1) as 'SPO2','' as 'New Results', CONCAT((SELECT COUNT(*)  FROM  `patient_labinvestigation_OPD`   pli2   INNER JOIN `investigation_master` im ON im.investigation_ID=pli2.investigation_ID WHERE TransactionID=pmh.`TransactionID` AND im.ReportType  in('1','3') AND approved='1'),'/0/', (SELECT COUNT(*)  FROM  `patient_labinvestigation_OPD`   pli2   INNER JOIN `investigation_master` im ON im.investigation_ID=pli2.investigation_ID WHERE TransactionID=pmh.`TransactionID` AND im.ReportType <>'5'  ) ) 'Lab status',CONCAT((SELECT COUNT(*) FROM patient_labinvestigation_OPD pli1   INNER JOIN `investigation_master` im ON im.investigation_ID=pli1.investigation_ID where im.ReportType='5' " +
" AND  pli1.TransactionID=pmh.`TransactionID` and pli1.Approved='1' ),'/',(SELECT COUNT(*) FROM patient_labinvestigation_OPD pli1   INNER JOIN `investigation_master` im ON im.investigation_ID=pli1.investigation_ID where im.ReportType='5' " +
" AND  pli1.TransactionID=pmh.`TransactionID` )) 'Imaging Stat', IFNULL(epd.Alert,'') as 'Alert'" +
            ",'' as 'R/M','' as 'SCR','' as 'Unack',"+
        "'' as 'Consult stat','' as 'dispo',IFNULL(DATE_FORMAT(epd.`PatientReceiveddate`,'%d-%b-%Y %h:%i %p'),'')'Received Date Time',epd.`EmergencyNo` ");
        sb.Append(" FROM Emergency_Patient_Details epd  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=epd.`TransactionId` ");
        sb.Append(" left JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID` ");
        sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
        sb.Append(" left JOIN room_master rm ON rm.`RoomId`=epd.`RoomId` ");
        sb.Append(" LEFT JOIN emr_triagingcodes tr ON tr.ID=pmh.TriagingCode  ");
        sb.Append(" LEFT JOIN patient_medicine ptm ON ptm.TransactionID=epd.TransactionId AND ptm.IndentNo IS NOT NULL ");
        sb.Append(" LEFT JOIN f_indent_detail_patient idp ON idp.TransactionID=epd.TransactionId AND idp.ReqQty>=(idp.ReceiveQty+idp.RejectBy) ");
        sb.Append(" LEFT JOIN patient_test pt ON pt.TransactionID=epd.TransactionId AND pt.IsIssue=1 AND pt.IsActive=1 ");
        sb.Append(" LEFT JOIN patient_nurse_assignment pna ON pna.TransactionID=epd.TransactionId AND pna.STATUS=0 ");
        sb.Append(" LEFT JOIN employee_master em ON em.EmployeeID=pna.NurseID ");
        sb.Append(" WHERE epd.`EmergencyNo`<>''  and epd.IsReleased=0 AND pmh.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  AND rm.`Bed_No` is not null");
        if (EmergencyNo != "")
        {
            sb.Append(" AND epd.EmergencyNo='" + EmergencyNo + "'");
        }
        if (PID != "")
        {
            sb.Append(" AND epd.PatientID='" + PID + "'");

        }

        sb.Append(" GROUP BY epd.TransactionId ");
        
        dt = StockReports.GetDataTable(sb.ToString());
        //dt = (DataTable)HttpContext.Current.Session["dtExport2Excel"];
        if (dt.Rows.Count > 0)
        {
        
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Emergency Admission Report";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "No Record Found" });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); }


    }

    [WebMethod(EnableSession = true)]

    public static string SaveNotes(string DoctorID, string TransactionID, string PatientID, string ProblemNote, string PlanNote, string  SaveType,string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";

            if (SaveType == "Save")
            {
                var sqlCMD = "insert into doctorpatientnoteslist (ProblemNotes,DoctorID,TransactionID,PatientID,Createdby,PlanNotes,Active,CreatedDate)value(@ProblemNotes,@DoctorID,@TransactionID,@PatientID,@Createdby,@PlanNotes,@Active,NOW())";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                      {
                          ProblemNotes = ProblemNote,
                          DoctorID = Util.GetString(DoctorID),
                          TransactionID = TransactionID,
                          PatientID = PatientID,
                          PlanNotes = PlanNote,
                          Createdby = HttpContext.Current.Session["ID"].ToString(),
                          Active = 1

                      });
                message = "Record Save Sucessfully";
            }
            else
            {
                var sqlCMD = "UPDATE doctorpatientnoteslist SET ProblemNotes=@ProblemNotes,PlanNotes=@PlanNotes,UpdateDate=NOW(),UpdateBy=@UpdateBy WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    ProblemNotes = ProblemNote,
                    PlanNotes = PlanNote,
                    UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                    ID = Util.GetInt(ID)

                });
                message = "Record Update Successfully";
            }

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
    [WebMethod(EnableSession = true)]
    public static string bindpatientnotes(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable("select d.ID,Ifnull(ProblemNotes,'')ProblemNotes,Ifnull(PlanNotes,'')PlanNotes,TransactionID,concat(em.Title,' ',em.NAME)CreatedBy,DATE_FORMAT(d.CreatedDate,'%d-%b-%Y')CreatedDate from doctorpatientnoteslist d inner join employee_master em on em.EmployeeID=d.Createdby where TransactionID='" + TransactionID + "'");
     
        if (dt.Rows.Count > 0)
        {
         
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }

    [WebMethod(EnableSession = true)]
    public static string bindPMP(string TID)
    {
        DataTable dt = StockReports.GetDataTable("select d.ID,ProblemNotes,PlanNotes,TransactionID from doctorpatientnoteslist d where TransactionID='"+TID+"' ORDER BY D.ID desc limit 1");

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Problem,Plan & Medication Found.." }); }


    }
    [WebMethod(EnableSession = true)]
    public static string BindRoomType()
    {
        DataTable dt = AllLoadData_IPD.LoadCaseType();
        if (dt.Rows.Count > 0)
        {
            DataView RoomTypeView = dt.DefaultView;
            RoomTypeView.RowFilter = "IsEmergency='1'";
            return Newtonsoft.Json.JsonConvert.SerializeObject(RoomTypeView.ToTable());
        }
        else
            return "";
    }
  
}