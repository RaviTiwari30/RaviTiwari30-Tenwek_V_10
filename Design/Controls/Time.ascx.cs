using System;

public partial class Design_Controls_Time : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtTime.Text = System.DateTime.Now.ToString("hh:mm tt");
        }
    }
}