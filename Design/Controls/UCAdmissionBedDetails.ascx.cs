using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Controls_UCAdmissionBedDetails : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAdmissionDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtAdmissionTimeHour.Text = System.DateTime.Now.ToString("hh");
            txtAdmissionTimeMinute.Text = System.DateTime.Now.ToString("mm");
            ddlAdmissionTimeMeridiem.SelectedIndex = ddlAdmissionTimeMeridiem.Items.IndexOf(ddlAdmissionTimeMeridiem.Items.FindByText(System.DateTime.Now.ToString("tt")));

            if (((Label)this.Parent.FindControl("lblAdvanceRoomBooking")) == null)
            {
                CalendarExteAdmissionDate.EndDate = System.DateTime.Now;
            }
            else
            {
                CalendarExteAdmissionDate.StartDate = System.DateTime.Now;
            }
        }
        txtAdmissionDate.Attributes.Add("readOnly", "readOnly");
    }
}