using System;

public partial class Design_Transport_Drivermaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtLicenceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["CentreID"] = Session["CentreID"].ToString();
        }
        txtLicenceDate.Attributes.Add("readOnly", "readOnly");
        cal.StartDate = DateTime.Now;
    }
}