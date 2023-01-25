using System;

public partial class Design_Transport_VehicleMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calInsurance.StartDate = DateTime.Now;
            calLicenceDate.EndDate = DateTime.Now;
        }
    }
}