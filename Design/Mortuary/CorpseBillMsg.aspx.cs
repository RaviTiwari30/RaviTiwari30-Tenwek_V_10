using System;

public partial class Design_Mortuary_CorpseBillMsg : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string msg = Request.QueryString["msg"].ToString();
        lblMsg.Text = msg;
    }
}
