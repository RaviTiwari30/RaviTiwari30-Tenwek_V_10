using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_ManpowerSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtrequestDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtrequestDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtrequestDateFrom.Attributes.Add("readonly", "readonly");
        txtrequestDateTo.Attributes.Add("readonly", "readonly");
    }

   
}