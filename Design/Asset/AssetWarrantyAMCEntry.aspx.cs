using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Asset_AssetWarrantyAMCEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
             txtFromDate.Text = DateTime.Now.AddDays(-3).ToString("dd-MMM-yyyy");
             txtToDate.Text = txtAMCFromDate.Text = txtInsuranceFromDate.Text=txtInsuranceToDate.Text =DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
}