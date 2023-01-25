using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
public partial class Design_IPD_AttendentPassIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            divAttendentDetail.Visible = false;
            divPatientDetail.Visible = false;
            txtIPDNo.Focus();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            string IPDNo = "";
            if (txtIPDNo.Text.Trim() != "")
                IPDNo = StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim());//"" +
        

            lblMsg.Text = "";
            divAttendentDetail.Visible = false;
            divVisitorIssuedDetail.Visible = false;
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT CONCAT(t2.Title, ' ',t2.PName)PName,t2.PatientID,t2.TransactionID,ictm1.Name,t2.RelativeOf,t2.RelativeName,");
            sb.Append("  CONCAT(House_No,' ',Street_Name,' ',Locality,',',City)Address");
            sb.Append("  ,rm.Bed_No,t2.IPDCaseTypeID,t2.TransNo FROM ( ");
            sb.Append("  SELECT pm.ID,TransactionID,TransNo,IPDCaseTypeID,RoomId,pm.Title,PName,House_No,Street_Name,Locality,City,Pincode,Age,pm.PatientID,pm.Relation AS RelativeOf,pm.RelationName AS RelativeName    FROM (  ");
            sb.Append("  	SELECT pip.PatientID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,pip.RoomId, pip.TransactionID,pmh.TransNo,");
            sb.Append("  	pip.Status,DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')DateOfAdmit,TIME_FORMAT(pmh.TimeOfAdmit,'%l: %i %p')");
            sb.Append("  	TimeOfAdmit,pmh.DoctorID FROM     ( ");
            sb.Append("  		SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,pip1.IPDCaseTypeID_Bill,pip1.RoomId,pip1.TransactionID,");
            sb.Append("  	pip1.Status FROM patient_ipd_profile pip1 ");
            sb.Append("  	INNER JOIN ( ");
            sb.Append("  		SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID FROM patient_ipd_profile ");
            sb.Append("  		WHERE STATUS = 'IN' ");
            if (txtIPDNo.Text.Trim() != string.Empty)
                sb.Append("  		AND TransactionID= '" + IPDNo + "' ");
            if (txtMRNo.Text.Trim() != string.Empty)
                sb.Append("  		AND PatientID= '" + Util.GetFullPatientID(txtMRNo.Text.Trim()) + "' ");
            sb.Append("  AND CentreID="+ HttpContext.Current.Session["CentreID"].ToString() +"	GROUP BY TransactionID  ");
            sb.Append("  	)pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID  ");
            sb.Append("  	)pip INNER JOIN patient_medical_history pmh ON pmh.TransactionID = pip.TransactionID ");
            sb.Append("  	AND pmh.Type='IPD' WHERE pmh.status='IN'  ");
            sb.Append("  ) t1 INNER JOIN  patient_master pm  ON t1.PatientID = pm.PatientID ");
            sb.Append("  )t2");
            sb.Append("   INNER JOIN ipd_case_type_master ictm1 ON ictm1.IPDCaseTypeID = t2.IPDCaseTypeID ");
            sb.Append("  INNER JOIN room_master rm ON rm.RoomId = t2.RoomId ORDER BY t2.ID DESC, t2.PName, t2.PatientID  ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                divPatientDetail.Visible = true;
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
            }
            else
            {
                divPatientDetail.Visible = false;
                lblMsg.Text = "No Record Found";
                grdPatient.DataSource = null;
                grdPatient.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Pass")
        {
            divAttendentDetail.Visible = true;
            txtVisitorName.Text = "";
            string TID = e.CommandArgument.ToString();
            BindVisitorDetail(TID);
            ViewState["TID"] = TID;

        }
    }
    protected void btnIssue_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string VisitorNo = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT CONCAT('VIST/',LPAD(IFNULL(MAX(ID),0)+1,8,0))VisitorID FROM f_patient_visitorpass "));

            string Sql = "INSERT INTO f_patient_visitorpass(VisitorID,TransactionID,VisitorName,IssuedDateTime,IssuedBy) values('" + VisitorNo + "','" + ViewState["TID"].ToString() + "','" + txtVisitorName.Text.Trim() + "',now(),'" + Session["ID"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            BindVisitorDetail(ViewState["TID"].ToString());
            //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Your Visitor No. :" + VisitorNo + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('AttendantPass.aspx?TID=" + ViewState["TID"].ToString() + "&Visitorid=" + VisitorNo + "&VisitorName=" + txtVisitorName.Text.Trim() + "');", true);
            txtVisitorName.Text = "";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void BindVisitorDetail(string TID)
    {
        string Sql = "SELECT p.`TransactionID`,p.ID,IF(p.`IsSubmit`=0,'true','false')IsSubmitShow, IF(p.`IsSubmit`=0,'Issued','Submitted')Status, p.`VisitorID`,p.`VisitorName`,DATE_FORMAT(p.`IssuedDateTime`,'%d-%b-%y %I:%i %p')IssueDate, CONCAT(em.`Title`,' ',em.`Name`)IssueBy FROM f_patient_visitorpass p INNER JOIN employee_master em ON em.`EmployeeID`=p.`IssuedBy` WHERE p.`TransactionID`='" + TID + "'";
        DataTable dtIssue = StockReports.GetDataTable(Sql);
        if (dtIssue.Rows.Count > 0)
        {
            grdVisitorDetails.DataSource = dtIssue;
            grdVisitorDetails.DataBind();
            divVisitorIssuedDetail.Visible = true;
        }
        else
        {
            grdVisitorDetails.DataSource = null;
            grdVisitorDetails.DataBind();
            divVisitorIssuedDetail.Visible = false;
        }
    }
    protected void grdVisitorDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "Submit")
        {
            divAttendentDetail.Visible = true;
            txtVisitorName.Text = "";
            string TID = e.CommandArgument.ToString().Split('#')[1];
            int ID = Util.GetInt(e.CommandArgument.ToString().Split('#')[0]);
            StockReports.ExecuteDML("update f_patient_visitorpass p set p.`IsSubmit`=1,p.`SubmitDateTime`=now(),p.`SubmitBy`='" + Session["ID"].ToString() + "' where p.ID=" + ID + " ");
            lblMsg.Text = "Visitor pass Submitted Successfully";
            BindVisitorDetail(TID);
            ViewState["TID"] = TID;

        }
        if (e.CommandName == "Print")
        {
            divAttendentDetail.Visible = true;
            txtVisitorName.Text = "";
            string TID = e.CommandArgument.ToString().Split('#')[2];
            string VisitorNo = e.CommandArgument.ToString().Split('#')[0];
            string VisitorName = e.CommandArgument.ToString().Split('#')[1];
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('AttendantPass.aspx?TID=" + TID + "&Visitorid=" + VisitorNo + "&VisitorName=" + VisitorName + "');", true);


        }
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {

    }
}