using System;

public partial class Design_IPD_PatientBillMsg : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["msg"] != null)
        {
            string msg = Request.QueryString["msg"].ToString();
            lblMsg.Text = msg;
        }
    }
}
