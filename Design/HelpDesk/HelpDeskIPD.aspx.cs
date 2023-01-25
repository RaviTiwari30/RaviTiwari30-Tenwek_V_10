using System;

public partial class Design_HelpDesk_HelpDeskIPD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtMRNo.Focus();
            txtFDSearch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTDSearch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calfDate.EndDate = DateTime.Now;
            Fromdatecal.EndDate = DateTime.Now;
        }
        txtFDSearch.Attributes.Add("readOnly", "true");
        txtTDSearch.Attributes.Add("readOnly", "true");
    }
}