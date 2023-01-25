using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mortuary_Mortuary_ReceivedSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromdate.EndDate = DateTime.Now;
            calTodate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly","readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }
}