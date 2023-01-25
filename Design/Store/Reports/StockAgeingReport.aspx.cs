using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_Report_StockAgeingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string Store_Get_StockAgeing(List<string> data)
    {
        try
        {
            string ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "TotalCostValue", "0", data[8], data[9], false);

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_StockAgeing(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo,@vToDate,@vStoreType,@vAgeingDays,@vAgeingFor)", CommandType.Text, new
            {
                vCenterID = data[0],
                vCategoryID = data[2],
                vSubcategoryID = data[3],
                vItemID = data[4],
                vDeptledgerNo = data[1],
                vToDate = Util.GetDateTime(data[5]).ToString("yyyy-MM-dd"),
                vStoreType = data[6],
                vAgeingDays = ageingcriteria.Replace("'", "\""),
                vAgeingFor = data[8]
                
            });
            if (dt.Rows.Count > 0)
            {
                if (dt.Columns.Contains("StockID"))
                    dt.Columns.Remove("StockID");

                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "As On Date : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + "";
                    dt.Columns.Add(dc);
                    dt = Util.GetDataTableRowSum(dt);

                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCachedt(CacheName, dt);
                    string ReportName = "Stock Ageing Report";
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