using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;

public partial class Design_OT_OperationList : System.Web.UI.Page
{
    private MySqlConnection con = Util.GetMySqlCon();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00 AM"; ;
            txtToTime.Text = "11:59 PM";

            todalcal.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txttodate.Attributes.Add("readOnly", "true");
        txtfromdate.Attributes.Add("readOnly", "true");

        
    }

    protected void btnsubmit_Click(object sender, EventArgs e)
    {
        string fromdate = Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss");
        string todate = Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtToTime.Text.Trim()).ToString("HH:mm:ss");

        System.Text.StringBuilder sb = new System.Text.StringBuilder();

     /*   sb.Append(" select PM.PName,PM.Address,PM.AgeSex,PM.Relation,PM.RelationName,ot.PatientID, ");
        sb.Append(" (select (select Name from ipd_case_type_master where IPDCaseTypeID=pip.IPDCaseTypeID) as Room from patient_ipd_profile pip where TransactionID=ot.TransactionID  order by pip.PatientIPDProfile_ID desc limit 1)as Room,ot.TransactionID,ot.LedgerTransactionNo,(select Name from doctor_master where DoctorID=ot.DoctorID) as Sergeon,sur.Name,sur.Department,ot.OT,TIME_FORMAT(time(ot.Start_DateTime),'%h %i %p') as Start,TIME_FORMAT(time(ot.End_Datetime),'%h %i %p') as End,ot.Surgery_ID, ");
        sb.Append(" ot.Ass_Doc1,ot.Ass_Doc2,ot.Ass_Doc3,(select Name from doctor_master where DoctorID=ot.Anaesthetist1) as Anaesthetist,ot.Anaesthetist2,ot.CoAnaesthesia,ot.technician,ot.ScNurse, ");
        sb.Append(" ot.Nurse1,ot.Nurse2,ot.FloorSuprevisior,ot.CirculatingNurse,ot.PadiatriciansRecort,ot.Weight,ot.Remarks, ");
        sb.Append(" ot.ApgarScore,ot.IsCancel,ot.CancelUserID,ot.CancelReason,ot.CancelDatetime,ot.EntDate,(select Name from employee_master Where EmployeeID=ot.UserID) as User,surdet.Diagnosis, ");
        sb.Append(" surdet.Is_Surgery_Schedule,if(surdet.Is_PAC=1,'Yes','No')PAC,surdet.Is_Post  ");
        sb.Append(" from ");
        sb.Append(" (select PatientID,PName,House_No as Address,concat(Age,'/',if(gender='Male','M','F'))as AgeSex,Relation,RelationName from patient_master) PM  ");
        sb.Append(" inner join ot_surgery_schedule ot  ");
        sb.Append(" on ot.PatientID=PM.PatientID  ");
        sb.Append(" inner join f_surgery_master sur  ");
        sb.Append(" on sur.Surgery_ID=ot.Surgery_ID  ");
        sb.Append(" inner join ot_surgerydetail surdet  ");
        sb.Append(" on surdet.TransactionID=ot.TransactionID  ");
        sb.Append(" where ot.IsCancel=0 and surdet.Is_Surgery_Schedule=1  and ot.Start_DateTime>='" + fromdate + "' and  ot.Start_DateTime<='" + todate + "'  order by Start   "); */
        sb.Append(" SELECT ot.`PatientID`,ot.`PatientName`,ot.`Age`,ot.`Gender`,ot.`Address`,ot.`ContactNo`,CONCAT(dm.`Title`,' ',dm.`NAME`)Doctor,  ");
        sb.Append(" surg.`NAME` SurgeryName,otm.`NAME` OT,DATE_FORMAT(ot.`SurgeryDate`,'%d-%M-%Y')SurgeryDate,TIME_FORMAT(ot.`SlotToTime`,'%h:%i %p')SlotToTime, ");
        sb.Append(" TIME_FORMAT(ot.`SlotToTime`,'%h:%i %p')SlotToTime, (SELECT TransNo FROM patient_medical_history WHERE TransactionID = ot.transactionID)IPDNo, ");
        sb.Append(" DATE_FORMAT(ot.`PatientReceivedDate`,'%d-%M-%Y')PtntRecvDate,TIME_FORMAT(ot.`PatientReceivedDate`,'%h:%i %p')PtntRecvTime,  ");
        sb.Append(" CONCAT(em.`Title`,' ',em.`NAME`)PtntRcvBy FROM ot_booking ot  ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=ot.`DoctorID`  ");
        sb.Append(" INNER JOIN `f_surgery_master` surg ON surg.`surgery_id`=ot.`SurgeryID`  ");
        sb.Append(" INNER JOIN ot_master otm ON ot.`OTID`=otm.`ID`  ");
        sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID` = ot.`PatientReceivedBy`  ");
        sb.Append(" WHERE ot.`IsPatientReceived`=1 AND ot.`IsCancel`=0   ");
        sb.Append(" AND DATE(ot.`PatientReceivedDate`) >='" + fromdate + "' AND DATE(ot.`PatientReceivedDate`) <='" + todate + "'  ");
        sb.Append(" AND ot.`CentreID`='" + Session["CentreID"].ToString() + "'  ");
        sb.Append(" ORDER BY IPDNo,PtntRecvDate,PtntRecvTime ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn DC = new DataColumn("DATE_Range");
            DC.DefaultValue = "From : " + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " " + txtFromTime.Text.Trim() + "  To : " + Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + " " + txtToTime.Text.Trim();
            dt.Columns.Add(DC);

            DataColumn DC3 = new DataColumn("Printedby");
            DC3.DefaultValue = Session["LoginName"].ToString();
            dt.Columns.Add(DC3);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
          //  ds.WriteXml("E:/opeartionrecord.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OperationList";
            lblmsg.Text = dt.Rows.Count + " Record Found.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        { lblmsg.Text = "No Record found"; }
    }
}