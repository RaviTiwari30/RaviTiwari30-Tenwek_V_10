using System;
using System.Data;
using System.Web.UI;
public partial class MyTicket : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Resources.Resource.Ticketing == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                ViewState["RoleID"] = Session["RoleID"].ToString();
                All_LoadData.bindRole(ddlDepartment);
                ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(ViewState["RoleID"].ToString()));
                ddlDepartment.Enabled = false;
            }
        }
    }
    
}