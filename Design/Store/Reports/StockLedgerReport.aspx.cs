using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Finance_StockLedgerReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static string Store_Get_StockLedger(List<string> data)
    {
        try
        {
            //vCenterID VARCHAR(500),vCategoryID VARCHAR(500),vSubcategoryID VARCHAR(1000),
            //vItemID VARCHAR(2500),vDeptledgerNo VARCHAR(200),vPeriodFrom DATE, vPeriodTo DATE
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_StockLedger(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@vPeriodFrom,@vPeriodTo,@vStoreType)", CommandType.Text, new  //,@vStoreType
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    vPeriodFrom = Util.GetDateTime(data[5]).ToString("yyyy-MM-dd"),
                    vPeriodTo = Util.GetDateTime(data[6]).ToString("yyyy-MM-dd"),
		    vStoreType = data[7],
                });
            if (dt.Rows.Count > 0)
            {
               DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(data[6]).ToString("dd-MMM-yyyy");

                dt.Columns.Add(dc);
                dt = Util.GetDataTableRowSum(dt);
                string ReportName = "Stock Ledger Report";
                string CacheName = HttpContext.Current.Session["ID"].ToString();
                Common.CreateCachedt(CacheName, dt);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }
    }
}