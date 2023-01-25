using System;
using System.Web.UI.WebControls;
using System.Web.UI;
public partial class Design_HelpDesk_TicketingAllInfo : System.Web.UI.Page
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
                ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                All_LoadData.bindRole(ddlRaised);
                All_LoadData.bindRole(ddlResolved);
                ddlRaised.Items.Insert(0, new ListItem("Select", "0"));
                ddlResolved.Items.Insert(0, new ListItem("Select", "0"));
            }
            Fromdatecal.EndDate = DateTime.Now;
            Todatecal.EndDate = DateTime.Now;
        }
        ToDate.Attributes.Add("readOnly", "true");
        FrmDate.Attributes.Add("readOnly", "true");
      
    }
}