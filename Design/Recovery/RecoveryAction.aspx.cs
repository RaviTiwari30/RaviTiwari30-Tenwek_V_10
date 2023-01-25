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
using MySql.Data.MySqlClient;

public partial class Design_Recovery_RecoveryAction : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)    
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = (new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDispatchDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtExpectedDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
        txtDispatchDate.Attributes.Add("readonly", "readonly");
        txtExpectedDate.Attributes.Add("readonly", "readonly");
    }

    
}
