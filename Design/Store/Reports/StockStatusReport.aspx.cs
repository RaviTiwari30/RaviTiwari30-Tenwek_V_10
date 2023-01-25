using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_StockStatusReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string Store_Get_StockStatus(List<string> data)
    {
        try
        {
            //vCenterID INT,vLedgerNo VARCHAR(500),vCategoryID VARCHAR(500),vSubcategoryID VARCHAR(1000),
            //vItemID VARCHAR(2500),vStoreLedgerNo VARCHAR(50),vUserName VARCHAR(50),vStorename VARCHAR(50),vClientName VARCHAR(50)
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_StockStatus(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo,@vPeriod,@vStoreType)", CommandType.Text, new
            {
                vCenterID = data[0],
                vCategoryID = data[2],
                vSubcategoryID = data[3],
                vItemID = data[4],
                vDeptledgerNo = data[1],
                vPeriod = Util.GetDateTime(data[5]).ToString("yyyy-MM-dd"),
                vStoreType = data[6],
            });
            if (dt.Rows.Count > 0)
            {
                if (data[7] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = " As on Date : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + " " + DateTime.Now.ToString("hh:mm:ss tt");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //ds.WriteXmlSchema("C:/Ankur/CurrStock.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "StockStatusReport";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../../Design/common/Commonreport.aspx" });
                }
                else
                {
                    dt.Columns.Remove("StockID");
                    dt = Util.GetDataTableRowSum(dt);
                    string ReportName = "Stock Status Report";
					string CacheName = HttpContext.Current.Session["ID"].ToString();
					Common.CreateCachedt(CacheName, dt);
					return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
                }
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