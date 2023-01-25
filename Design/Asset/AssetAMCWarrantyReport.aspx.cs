using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_Asset_AssetAMCWarrantyReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    [WebMethod(EnableSession=true)]
    public static string GetAssetAMCWarrantyReport(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("CALL get_Asset_AMCWarrantReport('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "')");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
         //   ds.WriteXmlSchema("E:/AMCWarrantyReport.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "AMCWarrantyReport";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { response = "No Record Found" });
        }
    }
}