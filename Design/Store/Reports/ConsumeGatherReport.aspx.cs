using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_ConsumeGatherReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      

    }
    //vCenterID INT,vCategoryID VARCHAR(500),vSubcategoryID VARCHAR(1000),
//vItemID LONGTEXT,vDeptledgerNo VARCHAR(200),vFromPeriod DATE, vToPeriod DATE,vStoreLedgerNo VARCHAR(25),vTranType VARCHAR(1)
    [WebMethod]
    public static string Store_Get_ConsumeData(List<string> data)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_ConsumeData(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@vPeriodFrom,@vPeriodTo,@vStoreLedgerNo,@vTranType)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    vPeriodFrom = Util.GetDateTime(data[7]).ToString("yyyy-MM-dd"),
                    vPeriodTo = Util.GetDateTime(data[8]).ToString("yyyy-MM-dd"),
                    vStoreLedgerNo = data[5],
                    vTranType = data[9]
                });
            if (dt.Rows.Count > 0)
            {
                string responseURL = string.Empty;
                if (data[6] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = " Date From : " + Util.GetDateTime(data[7]).ToString("dd-MMM-yyyy") + "   To : " + Util.GetDateTime(data[8]).ToString("dd-MMM-yyyy");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //ds.WriteXml("E:\\ConsumeGatherReport.xml");
                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCache(CacheName, ds);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "Commonreport.aspx?ReportName=ConsumeGatherReport" });
                }
                if (data[6] == "EXCEL")
                {
					DataColumn dc = new DataColumn();
					dc.ColumnName = "Period";
					dc.DefaultValue = "Period From : " + Util.GetDateTime(data[7]).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(data[8]).ToString("dd-MMM-yyyy");
					dt.Columns.Add(dc);
					
                    dt = Util.GetDataTableRowSum(dt);
                    string ReportName = "Consumption Report";
					string CacheName = HttpContext.Current.Session["ID"].ToString();
					Common.CreateCachedt(CacheName, dt);
					responseURL = "../../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E";
                }
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = responseURL });
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
