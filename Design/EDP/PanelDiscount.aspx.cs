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
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;

public partial class Design_EDP_PanelDiscount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = (new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");         
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }      
   
}
