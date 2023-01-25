using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_EDP_WelcomePageMessage : System.Web.UI.Page
{
    private DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Search();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int Active;
        if (chkActive.Checked)
            Active = 1;
        else
            Active = 0;
        DataTable dtmessage = (DataTable)ViewState["Message"];
        if (dtmessage.Rows.Count > 0)
        {
            StockReports.ExecuteScalar(" update welcome_message set Active='0' where Active='1' ");
        }
        StockReports.ExecuteScalar(" insert into welcome_message (Message,DescriptionMessage,Active,CreatedBy,CreatedDate,IPAddress,CentreID)values('" + txtMessage.Text.Replace("'", "").Trim() + "','" + txtWelcomeDescription.Text.Replace("'", "").Trim() + "','" + Active + "','" + Session["ID"].ToString() + "',Now(),'" + All_LoadData.IpAddress() + "','" + Session["CentreID"].ToString() + "') ");
        LoadCacheQuery.dropCache("WelcomeMessage_" + Session["CentreID"].ToString());
        Search();
        chkActive.Checked = false;
        txtMessage.Text = "";
    }

    private void Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT wm.ID,Message,IF(Active=1,'Yes','No')Current,CONCAT(em.title,' ',em.name)CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')CreatedDate,ifnull(DescriptionMessage,'')DescriptionMessage FROM welcome_message wm ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID = wm.CreatedBy ");
        dt = StockReports.GetDataTable(sb.ToString());
        ViewState["Message"] = dt;
        if (dt.Rows.Count > 0)
        {
            grdMessage.DataSource = dt;
            grdMessage.DataBind();
        }
        else
        {
            grdMessage.DataSource = null;
            grdMessage.DataBind();
        }
    }

    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblID.Text = ((Label)grdMessage.Rows[id].FindControl("lblID")).Text;
            txtMessage.Text = ((Label)grdMessage.Rows[id].FindControl("lblMessage")).Text;
            string Current = ((Label)grdMessage.Rows[id].FindControl("lblCurrent")).Text;
            if (Current == "Yes")
                chkActive.Checked = true;
            else
                chkActive.Checked = false;
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = true;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int Active;
        if (chkActive.Checked)
            Active = 1;
        else
            Active = 0;
        DataTable dtmessage = (DataTable)ViewState["Message"];
        if (dtmessage.Rows.Count > 0)
        {
            StockReports.ExecuteScalar(" update welcome_message set Active='0' where Active='1' ");
        }
        StockReports.ExecuteScalar(" update welcome_message set Active='" + Active + "',Message='" + txtMessage.Text.Replace("'", "").Trim() + "',IPAddress='" + All_LoadData.IpAddress() + "',DescriptionMessage='" + txtWelcomeDescription.Text.Replace("'", "").Trim() + "' where id='" + lblID.Text + "' ");
        LoadCacheQuery.dropCache("WelcomeMessage_"+ Session["CentreID"].ToString());
        Search();
        txtMessage.Text = "";
        chkActive.Checked = false;
        lblID.Text = "";
        btnUpdate.Visible = false;
        btnSave.Visible = true;
        btnCancel.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtMessage.Text = "";
        chkActive.Checked = false;
        lblID.Text = "";
        btnUpdate.Visible = false;
        btnSave.Visible = true;
        btnCancel.Visible = false;
    }
}