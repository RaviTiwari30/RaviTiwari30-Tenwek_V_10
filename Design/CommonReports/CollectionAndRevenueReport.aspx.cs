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
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

[Serializable]
public partial class Design_Finance_CollectionAndRevenueReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly","true");
        txtToDate.Attributes.Add("readonly","true");
    }


    protected void btnPreview_Click(object sender, EventArgs e)
    {
        string startDate = string.Empty, toDate = string.Empty;
        
            startDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
          
            toDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");

            string Sql = " CALL RevenueVsCollectionReport('" + startDate + "','" + toDate + "'," + Util.GetInt(rbtGroupType.SelectedItem.Value) + ",'1','" + Util.GetString(rbtPatientType.SelectedItem.Value) + "')";
            Session["ReportQuery"] = Sql;
            Session["ReportType"] = rbtReportType.SelectedItem.Value;
            Session["Period"] = "Period From : " + txtFromDate.Text + " To : " + txtToDate.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/OPD/RevenueCollectionPrint.aspx');", true);

    }

}
