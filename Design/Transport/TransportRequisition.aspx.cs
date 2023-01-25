using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Text;
using System.Web.Script.Services;

public partial class Design_Transport_TransportRequisition : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtBookingDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtBookingDatePopUp.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calBookingDate.StartDate = calBookingDatePopUp.StartDate = DateTime.Now.AddDays(0);
        }
        txtBookingDate.Attributes.Add("readonly", "readonly");
        txtBookingDatePopUp.Attributes.Add("readonly", "readonly");
    }  



}