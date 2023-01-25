using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_NursingDischargeNote : System.Web.UI.Page
{
    private DataTable dtDetails;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TransactionID"] = TID;
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtNextVisit.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["dtDetails"] = dtDetails;
            BindDetails();
            AllQuery AQ = new AllQuery();
            DataTable Discharge = AQ.GetPatientDischargeStatus(TID);
            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(TID));

            calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
            calucDate.EndDate = DateTime.Now;
            txtNextVisitCal.StartDate = DateTime.Now.AddDays(0);
        }
        txtdate.Attributes.Add("readOnly", "true");
        txtdate.Attributes.Add("readOnly", "readOnly");
        txtNextVisit.Attributes.Add("readOnly", "readOnly");
    }

    protected void BindDetails()
    {
        string str = "SELECT ID,TransactionID AS TransactionId,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p') AS DATE,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,Note AS ProgressNote,Issueitem,DATE_FORMAT(NextVisit,'%d-%b-%y')NextVisit,EntryBy AS UserID,TIMESTAMPDIFF(MINUTE,EntryDate,NOW())createdDateDiff FROM Nursing_DischargeNote WHERE TransactionID='" + ViewState["TransactionID"] + "' and isActive=1 ORDER BY EntryDate DESC";
        //  DataTable dtDetails = StockReports.GetDataTable("Select ID,TransactionId,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p') as Date,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=UserID)EntryBy,Replace(ProgressNote)ProgressNote from nursing_doctorprogressnote where TransactionId='" + ViewState["TransactionID"] + "' order by EntryDate desc");
        //  str = str.Replace("@", "'");
        DataTable dtDetails = StockReports.GetDataTable(str.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            pnlhide.Visible = true;
            grid.DataSource = dtDetails;
            grid.DataBind();
            ViewState["dtDetails"] = dtDetails;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string entrydate = DateTime.Now.ToString("dd-MMM-yyyy");
            string sql = "insert into Nursing_DischargeNote(PatientID,TransactionID,NoteDate,Note,Issueitem,NextVisit,EntryBy)values('" + Util.GetString(ViewState["PatientID"]).ToString() + "','" + Util.GetString(ViewState["TransactionID"]) + "','" + Util.GetDateTime(txtdate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetString(txtnote.Text).Replace("'", "@") + "','" + txtIssueItem.Text.Trim() + "','" + Util.GetDateTime(txtNextVisit.Text).ToString("yyyy-MM-dd") + "','" + Util.GetString(ViewState["UserID"]) + "')";
            StockReports.ExecuteDML(sql);
            tnx.Commit();
            con.Close();
            con.Dispose();
            BindDetails();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
            txtnote.Text = "";
            txtIssueItem.Text = "";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }

    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (ViewState["dtDetails"] != null)
        {
            dtDetails = ((DataTable)ViewState["dtDetails"]);
            decimal createdDateDiff = Util.GetDecimal(dtDetails.Rows[e.RowIndex]["createdDateDiff"].ToString());
            string UserID = dtDetails.Rows[e.RowIndex]["UserID"].ToString();
            int id = Int32.Parse(dtDetails.Rows[e.RowIndex]["ID"].ToString());
            if (UserID == Session["ID"].ToString())
            {
                dtDetails.Rows.RemoveAt(e.RowIndex);
                ViewState["dtDetails"] = dtDetails as DataTable;

                string sql = "update Nursing_DischargeNote set isActive='0' where ID=" + id + " ";
                StockReports.ExecuteDML(sql);
                grid.DataSource = dtDetails;
                grid.DataBind();
            }
            else
            {
                lblMsg.Text = "You are not able to Delete the Note";
            }
        }
    }

    protected void grid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string pro = ((Label)e.Row.FindControl("lblpro")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblpro")).Text = pro;
        }
    }
}