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
using System.Web.Services;
using System.IO;
using System.Collections.Generic;

[Serializable]
public partial class Design_CommonReports_TransferReportHisVsFinance : System.Web.UI.Page
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
    public static string GetExcelReports(int centreID, string fromDate, string toDate, int type, string ReportName, string reporttype)
    {
        try
        {
            string sql = "CALL sp_HISvsSteging(" + centreID + ",'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + type + ") ";
            DataTable dtHISVsFianance = StockReports.GetDataTable(sql);
            if (dtHISVsFianance.Rows.Count > 0)
            {
                foreach (DataRow row in dtHISVsFianance.Rows)
                {
                    row["Diff_HISMain_vs_FinStagging"] = Util.round(Util.GetDecimal(Util.GetDecimal(row["HIS_Amount"]) - Util.GetDecimal(row["FIN_Amount"])));
                }

                if (reporttype == "R")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "From Date : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To Date : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "";
                    dtHISVsFianance.Columns.Add(dc);
                    dtHISVsFianance = Util.GetDataTableRowSum(dtHISVsFianance);
                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCachedt(CacheName, dtHISVsFianance);
                    ReportName = ReportName + " Report";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
                }
                else if (reporttype == "S")
                {
                    dtHISVsFianance = Util.GetDataTableRowSum(dtHISVsFianance);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dtHISVsFianance, period = "From Date : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To Date : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "" });
                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error." });
                }
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found." });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }
    }    
}
