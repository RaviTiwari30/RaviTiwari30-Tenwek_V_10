using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_IPD_DownloadFinanceData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(" CALL insert_financeDetail_demo()  ");

        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Finance Report";
            Session["Period"] = "As on  " + DateTime.Now.ToString("dd-MMM-yyyy") + "";
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            lblMsg.Text = "";
            string Path = "~/FianceUpload";
            bool IsExists = System.IO.Directory.Exists(Server.MapPath(Path));
            if (!IsExists)
            {
                System.IO.Directory.CreateDirectory(Server.MapPath(Path));
            }
            string Url = System.IO.Path.Combine(Server.MapPath("~/FianceUpload/FinanceReport.xls"));
            if (System.IO.File.Exists(Url))
                System.IO.File.Delete(Url);
            dt.WriteXml(Url);
        }
        else
        {
            lblMsg.Text = "No Record Found!";
        }
    }
}