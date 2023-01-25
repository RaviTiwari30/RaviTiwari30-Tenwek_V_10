using System;

public partial class Design_NotAuthorized : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {        
        //Response.AddHeader("Refresh","5;URL='default.aspx'");
        string msg = string.Empty;
        if (Request.QueryString.Count > 0)
        {
            msg = Request.QueryString["msg"].ToString();
        }
        else
        {
            msg = "!!! Unathorised Access !!!";
        }
        lblMsg.Text = msg;
    }
}
