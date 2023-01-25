using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Controls_IPDAdmissionBedDetail : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAdmissionDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtHr.Text = System.DateTime.Now.ToString("hh");
            txtMin.Text = System.DateTime.Now.ToString("mm");
            cmbAMPM.SelectedIndex = cmbAMPM.Items.IndexOf(cmbAMPM.Items.FindByText(System.DateTime.Now.ToString("tt")));
            txtPolicyExpieryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        
        txtAdmissionDate.Attributes.Add("readOnly", "readOnly");
        if (Parent.FindControl("spnAdvanceRoomBooking") != null)
        {
            CalendarExteAdmission.StartDate = DateTime.Now.AddDays(0);
            
        }
        else
        {
            CalendarExteAdmission.EndDate = DateTime.Now.AddDays(0);
        }
        calpolicyexpiery.StartDate = DateTime.Now.AddDays(1);
        txtAdmissionDate.Attributes.Add("readOnly", "true");
        txtPolicyExpieryDate.Attributes.Add("readonly", "true");
    }
}