using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_OT_OT_CancelReport : System.Web.UI.Page
{
    private MySqlConnection con = Util.GetMySqlCon();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            todalcal.EndDate = DateTime.Now;
            Fromdalcal.EndDate = DateTime.Now;
        }
        txttodate.Attributes.Add("readOnly", "true");
        txtfromdate.Attributes.Add("readOnly", "true");
    }

    protected void btnsubmit_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        StringBuilder sb = new System.Text.StringBuilder();
      /*  sb.Append("   select PM.PName,PM.AgeSex,ot.PatientID ,  ");
        sb.Append("   (select (select Name from ipd_case_type_master where IPDCaseTypeID=pip.IPDCaseTypeID) as Room from patient_ipd_profile pip where TransactionID=ot.TransactionID)as Room,ot.TransactionID,ot.LedgerTransactionNo, ");
        sb.Append(" (select Name from doctor_master where DoctorID=ot.DoctorID) as Sergeon,sur.Name,sur.Department,ot.OT,concat(Date_FORMAT(date(ot.Start_DateTime),'%d %b %Y'),' ',TIME_FORMAT(time(ot.Start_DateTime),'%d %i %p')) as OTDate ,ot.Surgery_ID,  ");
        sb.Append("  ot.Ass_Doc1,ot.Ass_Doc2,ot.Ass_Doc3,(select Name from doctor_master where DoctorID=ot.Anaesthetist1) as Anaesthetist,ot.Anaesthetist2,ot.CoAnaesthesia,ot.technician,ot.ScNurse,  ");
        sb.Append("   ot.ApgarScore,ot.IsCancel,(select name from employee_master where EmployeeID=ot.CancelUserID)as CancelUserID,ot.CancelReason,Date_Format(date(ot.CancelDatetime),'%d %b %Y')as CancelDatetime,ot.EntDate,(select Name from employee_master Where EmployeeID=ot.UserID) as User,surdet.Diagnosis,surdet.weight,  ");
        sb.Append("  surdet.Is_Surgery_Schedule,if(surdet.Is_PAC=1,'Yes','LA')PAC,surdet.Is_Post   ");
        sb.Append("   from  ");
        sb.Append("   (select PatientID,PName,House_No as Address,concat(Age,'/',if(gender='Male','M','F'))as AgeSex,Relation,RelationName from patient_master) PM   ");
        sb.Append("   inner join ot_surgery_schedule ot   ");
        sb.Append("   on ot.PatientID=PM.PatientID   ");
        sb.Append("   inner join f_surgery_master sur  ");
        sb.Append("   on sur.Surgery_ID=ot.Surgery_ID   ");
        sb.Append("   inner join ot_surgerydetail surdet   ");
        sb.Append("   on surdet.TransactionID=ot.TransactionID   ");
        sb.Append("   where ot.IsCancel=1  and date(ot.CancelDatetime)>='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + "' and  date(ot.CancelDatetime)<='" + Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + "'  order by ot.CancelDatetime   "); */

        sb.Append(" SELECT IF(ot.`PatientID`='',ot.`OutPatientID`,ot.`PatientID`)PatientID, ");
        sb.Append(" IF(ot.transactionid IS NULL,'Non Reg. Ptnt',(SELECT TransNo FROM patient_medical_history WHERE TransactionID = ot.transactionID))IPDNo, ");
        sb.Append(" ot.`PatientName`,ot.`Age`,ot.`Gender`,ot.`Address`,ot.`ContactNo`,CONCAT(dm.`Title`,' ',dm.`NAME`)Doctor, ");
        sb.Append(" surg.`NAME` SurgeryName,otm.`NAME` OT,DATE_FORMAT(ot.`SurgeryDate`,'%d-%M-%Y')SurgeryDate,TIME_FORMAT(ot.`SlotToTime`,'%h:%i %p')SlotToTime, ");
        sb.Append(" TIME_FORMAT(ot.`SlotToTime`,'%h:%i %p')SlotToTime, ");
        sb.Append(" DATE_FORMAT(ot.`Canceldate`,'%d-%M-%Y')CancelDate,TIME_FORMAT(ot.`Canceldate`,'%h:%i %p')CancelTime, ");
        sb.Append(" CONCAT(em.`Title`,' ',em.`NAME`)CancelBy,ot.`CancelReason` ");
        sb.Append(" FROM ot_booking ot ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=ot.`DoctorID` ");
        sb.Append(" INNER JOIN `f_surgery_master` surg ON surg.`surgery_id`=ot.`SurgeryID` ");
        sb.Append(" INNER JOIN ot_master otm ON ot.`OTID`=otm.`ID` ");
        sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID` = ot.`CancelBy` ");
        sb.Append(" WHERE ot.`IsCancel`=1 AND DATE(ot.`Canceldate`)>='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd")+ " ' ");
        sb.Append(" AND DATE(ot.`Canceldate`)<= '" + Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + "' AND ot.`CentreID`= '" + Session["CentreID"].ToString() + "' ");
        sb.Append(" ORDER BY CancelDate,CancelTime ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn DC = new DataColumn("DATE_Range");
            DC.DefaultValue = "From : " + Util.GetDateTime(txtfromdate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txttodate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(DC);

            DataColumn DC3 = new DataColumn("Printedby");
            DC3.DefaultValue = Session["LoginName"].ToString();
            dt.Columns.Add(DC3);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
        //  ds.WriteXml("E:/OTCancelReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OTCancelReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        { lblmsg.Text = "No Record found"; }
    }
}