using System;

public partial class Design_Transport_MonthClosing : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtMonthYear.Text = System.DateTime.Now.ToString("MMM-yyyy");
        }
        txtMonthYear.Attributes.Add("readonly", "true");
    }
}