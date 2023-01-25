using System;
using System.Web.UI;

public partial class Premade_Reply_master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Resources.Resource.Ticketing == "0")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            return;
        }
    }
}