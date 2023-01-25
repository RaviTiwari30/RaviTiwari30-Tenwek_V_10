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
using System.Web.Services;
using System.IO;
using System.Collections.Generic;

public partial class Design_CommonReports_OpeningBalanceEditReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string GetExcelReports(int centreID, string fromDate, string toDate, int reporttype)
    {
        string reportName = "";

        DataTable dt_ = new DataTable();
        try
        {
            if (reporttype == 1)
                reportName = "OPENING BALANCE EDIT REPORT(Item-Wise)";
            else
                reportName = "OPENING BALANCE EDIT REPORT(Bill-Wise)";

            string sqlQuery = " CALL OpeningBalanceEditReport(" + centreID + ",'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + reporttype + ") ";

            dt_ = StockReports.GetDataTable(sqlQuery);

            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");

            dt_.Columns.Add(dc);
            dt_ = Util.GetDataTableRowSum(dt_);

            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt_); 
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../CommonReports/Commonreport.aspx?ReportName=" + reportName + "&Type=E" });


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });
        }
        finally
        {

        }
    }
}