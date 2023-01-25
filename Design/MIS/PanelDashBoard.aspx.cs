using System;
using System.Linq;
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
using System.Web.Services;

public partial class Design_MIS_PanelDashBoard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }


    [WebMethod(EnableSession=true)]
    public static string bindPanelSummaryDashBoard(string DateFrom, string DateTo)
    {
        int isCashBillling = 2;

        //int BillingTypeFilter = Util.GetInt(StockReports.ExecuteScalar(" SELECT IFNULL(r.`PatientaBillingType`,0) FROM f_Centre_Role_PatientaBillingType r WHERE r.`RoleID`=" + HttpContext.Current.Session["RoleID"].ToString() + " AND r.`CentreID`=" + HttpContext.Current.Session["CentreID"].ToString() + " AND r.`isActive`=1 ORDER BY r.`ID` DESC  LIMIT 1 "));
       
        //if (BillingTypeFilter == 0)
        //{
        //    isCashBillling = -1;
        //}
        //else if (BillingTypeFilter == 1)
        //{
        //    isCashBillling = 1;
        //}
        //if (BillingTypeFilter == 2)
        //{
        //    isCashBillling = 0;
        //}
        //if (BillingTypeFilter == 3)
        //{
        //    isCashBillling = 2;
        //}
       
        string Sql = " CALL PanelSummaryDashBoard(" + isCashBillling + "," + HttpContext.Current.Session["CentreID"].ToString() + ",'" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "') ";
        DataTable dt = StockReports.GetDataTable(Sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession=true)]
    public static string bindPanelDashBoardDetails(int Type)
    {
        int isCashBillling = 2;

        //int BillingTypeFilter = Util.GetInt(StockReports.ExecuteScalar(" SELECT IFNULL(r.`PatientaBillingType`,0) FROM f_Centre_Role_PatientaBillingType r WHERE r.`RoleID`=" + HttpContext.Current.Session["RoleID"].ToString() + " AND r.`CentreID`=" + HttpContext.Current.Session["CentreID"].ToString() + " AND r.`isActive`=1 ORDER BY r.`ID` DESC  LIMIT 1 "));

        //if (BillingTypeFilter == 0)
        //{
        //    isCashBillling = -1;
        //}
        //else if (BillingTypeFilter == 1)
        //{
        //    isCashBillling = 1;
        //}
        //if (BillingTypeFilter == 2)
        //{
        //    isCashBillling = 0;
        //}
        //if (BillingTypeFilter == 3)
        //{
        //    isCashBillling = 2;
        //}

       // Type = 1;
        string Sql = " CALL PanelDashBoardDetails(" + isCashBillling + "," + HttpContext.Current.Session["CentreID"].ToString() + ","+ Type +") ";
        DataTable dt = StockReports.GetDataTable(Sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession=true)]
    public static string exportToExcel(int Type,string reportName)
    {
        int isCashBillling = 2;

        //int BillingTypeFilter = Util.GetInt(StockReports.ExecuteScalar(" SELECT IFNULL(r.`PatientaBillingType`,0) FROM f_Centre_Role_PatientaBillingType r WHERE r.`RoleID`=" + HttpContext.Current.Session["RoleID"].ToString() + " AND r.`CentreID`=" + HttpContext.Current.Session["CentreID"].ToString() + " AND r.`isActive`=1 ORDER BY r.`ID` DESC  LIMIT 1 "));

        //if (BillingTypeFilter == 0)
        //{
        //    isCashBillling = -1;
        //}
        //else if (BillingTypeFilter == 1)
        //{
        //    isCashBillling = 1;
        //}
        //if (BillingTypeFilter == 2)
        //{
        //    isCashBillling = 0;
        //}
        //if (BillingTypeFilter == 3)
        //{
        //    isCashBillling = 2;
        //}

       // Type = 1;
        string Sql = " CALL PanelDashBoardDetails(" + isCashBillling + "," + HttpContext.Current.Session["CentreID"].ToString() + ","+ Type +") ";
        DataTable dt = StockReports.GetDataTable(Sql);

        if (dt.Rows.Count > 0)
        {
            if (dt.Columns.Contains("PanelID"))
                dt.Columns.Remove("PanelID");

            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "As on Date : " + Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy") + "";

            dt.Columns.Add(dc);
            dt = Util.GetDataTableRowSum(dt);

            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt);
            string ReportName = reportName + " Detail`s";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found" });
        }
    }


}

