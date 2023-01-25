using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;
public partial class Design_Store_StockLedger : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    [WebMethod]
    public static string Store_Get_CurrentStock(List<string> data)
    {
        try
        {
            //vCenterID INT,vLedgerNo VARCHAR(500),vCategoryID VARCHAR(500),vSubcategoryID VARCHAR(1000),
            //vItemID VARCHAR(2500),vStoreLedgerNo VARCHAR(50),vUserName VARCHAR(50),vStorename VARCHAR(50),vClientName VARCHAR(50)
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_CurrentStock(@vCenterID,@vLedgerNo,@vCategoryID,@vSubcategoryID,@vItemID,@vStoreLedgerNo,@vUserName,@vStorename,@vClientName,@vZeroStock)", CommandType.Text, new
            {
                vCenterID =  data[0],
                vLedgerNo = data[1],
                vCategoryID = data[2],
                vSubcategoryID = data[3],
                vItemID = data[4],
                vStoreLedgerNo = data[7],
                vUserName = HttpContext.Current.Session["LoginName"].ToString(),
                vStorename = HttpContext.Current.Session["LoginType"].ToString(),
                vClientName = HttpContext.Current.Session["CentreName"].ToString(),
                vZeroStock = data[6]
            });
            if (dt.Rows.Count > 0)
            {
                if (data[5] == "PDF")
                {
                    DataSet ds = new DataSet();
                    dt.TableName = "CurrStock";
                    ds.Tables.Add(dt.Copy());
                    //ds.WriteXmlSchema("F:/CurrStock.xml");
                    //HttpContext.Current.Session["ds"] = ds;
                    //HttpContext.Current.Session["ReportName"] = "StoreCurrentReport";
                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCache(CacheName, ds);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "Commonreport.aspx?ReportName=CurrentStockLedger" });
                }
                else
                {
                    dt.Columns.Remove("CentreID"); dt.Columns.Remove("StockDate"); dt.Columns.Remove("DeptLedgerNo"); dt.Columns.Remove("CategoryID"); dt.Columns.Remove("SubCategoryID"); dt.Columns.Remove("ItemID");
                    //dt.Columns.Remove("StockID"); 
					dt.Columns.Remove("UserName"); dt.Columns.Remove("ClientName"); dt.Columns.Remove("Storename");
                    dt.Columns["CurrentQty"].SetOrdinal(9);
                    dt.Columns["Margin"].SetOrdinal(10);
                    dt.Columns["ProfitPer"].SetOrdinal(11);
					
					DataColumn dc = new DataColumn();
					dc.ColumnName = "Period";
					dc.DefaultValue =  "As on :" + DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss tt");
					dt.Columns.Add(dc);
                    
					dt = Util.GetDataTableRowSum(dt);
					string ReportName = "Current Stock Report";
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }
    }
}