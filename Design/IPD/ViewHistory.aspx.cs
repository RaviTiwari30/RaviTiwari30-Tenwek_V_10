using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_IPD_ViewHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TransactionID"] = TID;
            ViewState["PID"] = Request.QueryString["PatientID"].ToString();
            BindPreviousVisit();
            BindIPDHistory();
            bindEmergencyHistory();
            bindothistory();
        }
    }
    protected void BindPreviousVisit()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select DATE_FORMAT(DateOfVisit,'%d-%b-%Y')DateVisit,CONCAT(dm.Title,' ',dm.Name)DName,pmh.DoctorID,lt.TransactionID,lt.LedgerTransactionNo ");
        sb.Append(" from patient_medical_history pmh INNER JOIN Doctor_master dm on pmh.DoctorID=dm.DoctorID INNER JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID`  AND");
        sb.Append("  lt.`TypeOfTnx`='OPD-APPOINTMENT' where  pmh.PatientID='" + ViewState["PID"].ToString() + "' ");
        //sb.Append(" and Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND  Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd")+"' ORDER BY DateOfVisit DESC");
        sb.Append(" ORDER BY DateOfVisit DESC");
        DataTable visit = StockReports.GetDataTable(sb.ToString());
        if (visit.Rows.Count > 0)
        {
            grdOPDHistory.DataSource = visit;
            grdOPDHistory.DataBind();

        }
        else
        {
            grdOPDHistory.DataSource = null;
            grdOPDHistory.DataBind();

        }
    }
    protected void BindIPDHistory()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ich.TransactionID,REPLACE(ich.TransactionID,'ISHHI','')AS IPD,ich.Status AS STATUS,ich.PatientID PatientID,   ");
        sb.Append(" DATE_FORMAT(ich.DateOfAdmit, '%d-%b-%Y')AS AdmissionDate,  IF(ich.DateOfDischarge != '0001-01-01', ");
        sb.Append(" DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'),'Not Discharged')AS DischargeDate,dm.Name DoctorName  ");
        sb.Append(" FROM patient_medical_history ich  ");//ipd_case_history
       // sb.Append(" INNER JOIN f_ipdadjustment adj ON adj.TransactionID=ich.TransactionID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=ich.DoctorID ");//Consultant_ID
        sb.Append(" WHERE  ich.PatientID='" + ViewState["PID"].ToString() + "' ");
        DataTable IPDVIsit = StockReports.GetDataTable(sb.ToString());
        if (IPDVIsit.Rows.Count > 0)
        {
            grdIPDHistory.DataSource = IPDVIsit;
            grdIPDHistory.DataBind();
        }
        else
        {
            grdIPDHistory.DataSource = null;
            grdIPDHistory.DataBind();
        }


    }
    protected void bindEmergencyHistory()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT CONCAT(dm.title,' ',dm.Name)DName,dm.DoctorID,pm.PatientID,pm.PName, ");
        sb.Append("DATE_FORMAT(epd.EnteredOn,'%d-%b-%Y')AppDate,DATE_FORMAT(epd.ReleasedDateTime,'%d-%b-%Y')DischargeDate,pm.Gender Sex, ");
        sb.Append("pm.Mobile ContactNo,pm.Age,  ");
        sb.Append("epd.TransactionId TransactionID ");
        sb.Append("FROM emergency_patient_details epd ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=epd.PatientId ");
        sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=epd.TransactionId ");
        sb.Append("LEFT JOIN Doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append("WHERE pm.PatientID='" + ViewState["PID"].ToString() + "' ");
        DataTable EmergencyVIsit = StockReports.GetDataTable(sb.ToString());
        if (EmergencyVIsit.Rows.Count > 0)
        {
            grdEmergency.DataSource = EmergencyVIsit;
            grdEmergency.DataBind();
        }
        else
        {
            grdEmergency.DataSource = null;
            grdEmergency.DataBind();
        }
    }



    protected void bindothistory()
    {
        string FromDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string sql = " SELECT ot.IsPatientReceived,ot.`ID` AS OTBookingID,ot.`PatientID`,REPLACE(ot.`TransactionID`,'ISHHI','') AS IPDNo,OT.`TransactionID`,PM.`PName`,CONCAT(PM.`Age`,'/',PM.`Gender`) AS AgeSex," +
                     "ot.`OTNumber`,ot.`OTID`,om.`Name` AS OTName,CONCAT(dm.`Title`,' ',DM.`Name`)AS DoctorName, OT.`SurgeryID`," +
                     "	sm.`Name` AS SurgeryName, DATE_FORMAT(ot.`SurgeryDate`,'%d-%b-%y') AS SurgeryDate, " +
                     "	CONCAT('From :' ,TIME_FORMAT(ot.`SlotFromTime`,'%I:%i %p'),' </br>To : ',TIME_FORMAT(ot.`SlotToTime`,'%I:%i %p')) AS SurgeryTiming, " +
                     "	DATE_FORMAT(ot.`ConfirmDate`,'%d-%b-%y %I:%i %p') AS ConfirmedDate " +
                     "	FROM `ot_booking` ot " +
                     "	INNER JOIN patient_master pm ON pm.`PatientID`=ot.`PatientID` " +
                     "	INNER JOIN ot_master om ON om.`ID`=ot.`OTID` " +
                     "	INNER JOIN doctor_master dm ON dm.`DoctorID`=ot.`DoctorID` " +
                     "	INNER JOIN f_surgery_master sm ON sm.`Surgery_ID`=ot.`SurgeryID` " +
                     "	WHERE ot.`IsActive`=1 AND ot.`IsConfirm`=1 AND  ot.IsPatientReceived=1 AND ot.PatientID='" + ViewState["PID"] + "' ";

        //  sql = " CALL `Get_OTPatientSearchData`('','','','0','','0','" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','1','0') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            grdothistory.DataSource = dt;
            grdothistory.DataBind();
        }
        else
        {
            grdothistory.DataSource = null;
            grdothistory.DataBind();
        }

    }

}