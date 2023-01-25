using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;

public partial class Design_Investigation_InvComments : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            BindObservation();
            btnSave.Visible = true;
        }
    }
    private void BindObservation()
    {
        string str = "SELECT * FROM labobservation_master ORDER BY NAME";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObservation.DataSource = dt;
            ddlObservation.DataTextField = "Name";
            ddlObservation.DataValueField = "LabObservation_ID";
            ddlObservation.DataBind();
            ddlObservation.SelectedIndex = 0;
        }
        else
        {
            ddlObservation.Items.Clear();
        }

        //LoadComments();

    }
    private void LoadComments()
    {
        if (ddlObservation.SelectedIndex != -1)
        {
            string str = " SELECT Comments_ID,labobservation_id,Comments_Head,Comments,(SELECT NAME FROM " +
                          " Labobservation_master WHERE labobservation_id='" + ddlObservation.SelectedValue + "')Investigation " +
                          " FROM labobservation_comments WHERE labobservation_id='" + ddlObservation.SelectedValue + "'";

            DataTable dt = StockReports.GetDataTable(str);

            if (dt != null && dt.Rows.Count > 0)
            {
                grdTemplate.DataSource = dt;
                grdTemplate.DataBind();

            }
            else
            {
                grdTemplate.DataSource = null;
                grdTemplate.DataBind();

            }
        }
    }


    protected void ddlObservation_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnSave.Text = "Save";
        LoadComments();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (txtCommentsName.Text == "" || txtLimit.Text == "")
            {
                lblMsg.Text = "Please enter the information";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please enter the information');", true);
                return;

            }


            //if (chkDefault.Checked)
            //{
            //    string UpdateInves_Description = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_comments set Comments='" + Util.GetString(txtLimit.Text).Replace("'", "") + "' where Investigation_Id='" + ddlInvestigation.SelectedValue + "'"));
            //}

            if (btnSave.Text != "Update")
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into labobservation_comments (labobservation_id,Comments_Head,Comments,CreatorUSER,CreatorDate) values( '" + ddlObservation.SelectedValue + "','" + txtCommentsName.Text.Trim() + "','" + Util.GetString(txtLimit.Text).Replace("'", "") + "','" + Session["ID"].ToString() + "',now())"));
                lblMsg.Text = "Record Saved Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
            }
            else
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update labobservation_comments set Comments_Head = '" + txtCommentsName.Text.Trim() + "',Comments='" + Util.GetString(txtLimit.Text).Replace("'", "") + "',UpdateBy='" + Session["ID"].ToString() + "', UpdateRemarks='" + Session["LoginName"].ToString() + "',UpdateDate=NOW() Where Comments_ID =" + ViewState["Comments_ID"].ToString()));
                ViewState["Comments_ID"] = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
                lblMsg.Text = "Record Updated Successfully";
            }


            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            LoadComments();
            btnSave.Text = "Save";
            txtLimit.Text = "";
            txtCommentsName.Text = "";
            //chkDefault.Checked = false;
            //LoadComments();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void grdTemplate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            btnSave.Text = "Save";
            string Comments_ID = e.CommandArgument.ToString();
            StockReports.ExecuteDML("Delete from labobservation_comments where Comments_ID =" + Comments_ID);
            lblMsg.Text = "Record Deleted Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Deleted Successfully');", true);
            txtLimit.Text = "";
            txtCommentsName.Text = "";
            //LoadComments();
        }
        else if (e.CommandName == "vEdit")
        {
            string Comments_ID = e.CommandArgument.ToString();

            DataTable dt = StockReports.GetDataTable("Select * from labobservation_comments where Comments_ID =" + Comments_ID);

            if (dt != null && dt.Rows.Count > 0)
            {
                txtCommentsName.Text = dt.Rows[0]["Comments_Head"].ToString();
                txtLimit.Text = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Comments"]));
                btnSave.Text = "Update";
                ViewState["Comments_ID"] = Comments_ID;
            }

        }
        LoadComments();
    }
    //protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    btnSave.Text = "Save";
    //    BindInvestigation();
    //}
}
