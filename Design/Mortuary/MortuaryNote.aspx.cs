using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Mortuary_MortuaryNote : System.Web.UI.Page
{


    DataTable dtDetails;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = "";
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                TID = Util.GetString(StockReports.ExecuteScalar("select mcm.TransactionID Transaction_ID from mortuary_corpse_master mcm inner join mortuary_corpse_deposite mcd on mcd.CorpseID=mcm.Corpse_ID where mcd.TransactionID='" + Request.QueryString["TransactionID"].ToString() + "' limit 1"));
            else
                TID = Request.QueryString["Transaction_ID"].ToString();

            if (TID == "")
            {
                return;
            }

            ViewState["Transaction_ID"] = TID;
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["dtDetails"] = dtDetails;
            BindDetails();
            AllQuery AQ = new AllQuery();
            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(TID));

            calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calucDate.EndDate = DateTime.Now;
        }
        txtdate.Attributes.Add("readOnly", "true");
        string logintype = Session["RoleID"].ToString();
       /* if (logintype != "52")
        {
            btnSave.Visible = false;
        }*/
        txtdate.Attributes.Add("readOnly", "readOnly");
    }
    protected void BindDetails()
    {
        string str = "Select ID,TransactionId,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p') as Date,(Select Concat(title,' ',Name) from Employee_master where EmployeeID=UserID)EntryBy,ProgressNote,UserID,TIMESTAMPDIFF(MINUTE,EntryDate,NOW())createdDateDiff from Mortuary_MortuaryNote where TransactionId='" + ViewState["Transaction_ID"] + "' order by EntryDate desc";
        //  DataTable dtDetails = StockReports.GetDataTable("Select ID,TransactionId,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p') as Date,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=UserID)EntryBy,Replace(ProgressNote)ProgressNote from nursing_doctorprogressnote where TransactionId='" + ViewState["Transaction_ID"] + "' order by EntryDate desc");
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
            string sql = "insert into Mortuary_MortuaryNote(TransactionId,NoteDate,ProgressNote,UserID)values('" + Util.GetString(ViewState["Transaction_ID"]) + "','" + Util.GetDateTime(txtdate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetString(txtnote.Text).Replace("'", "@") + "','" + Util.GetString(ViewState["UserID"]) + "')";
            StockReports.ExecuteDML(sql);
            tnx.Commit();
            con.Close();
            con.Dispose();
            BindDetails();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
            txtnote.Text = "";
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
            if (UserID == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {

                dtDetails.Rows.RemoveAt(e.RowIndex);
                ViewState["dtDetails"] = dtDetails as DataTable;

                string sql = "delete from nursing_doctorprogressnote where ID=" + id + " ";
                StockReports.ExecuteDML(sql);
                grid.DataSource = dtDetails;
                grid.DataBind();
            }
            else
            {
                lblMsg.Text = "You are not able to Delete the Note Or Delete Time Period Expired";
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