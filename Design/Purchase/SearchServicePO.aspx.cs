using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
public partial class Design_Purchase_SearchServicePO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            CalendarExtender2.EndDate = DateTime.Now;
            CalendarExtender4.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");

    }
}