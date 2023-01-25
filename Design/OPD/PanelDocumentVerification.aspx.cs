using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;
using System.IO;
using System.Web.UI.HtmlControls;

public partial class Design_OPD_PanelDocumentVerification : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {           
            txtFDSearch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTDSearch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFDSearch.Attributes.Add("readOnly","true");
        txtTDSearch.Attributes.Add("readOnly", "true");
    }
}