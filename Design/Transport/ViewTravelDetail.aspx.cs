using System;

public partial class Design_Transport_EditTravelDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtArrivalDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDepartureDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtDepartureDate.Attributes.Add("readOnly", "readOnly");
        txtArrivalDate.Attributes.Add("readOnly", "readOnly");
    }
}