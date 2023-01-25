using System;
using System.Web.UI;

public partial class Design_CSSD_ReciveAsSet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            ddlSetItem.Focus();
        }
    }
}