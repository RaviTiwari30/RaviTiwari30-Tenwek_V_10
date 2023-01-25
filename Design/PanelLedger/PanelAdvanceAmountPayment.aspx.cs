using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Text;

public partial class Design_PanelLedger_PanelAdvanceAmountPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtReceiveDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtReceiveDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            CalendarExteDOB.EndDate = DateTime.Now;
        }
        txtReceiveDate.Attributes.Add("readOnly", "true");
    }
}
