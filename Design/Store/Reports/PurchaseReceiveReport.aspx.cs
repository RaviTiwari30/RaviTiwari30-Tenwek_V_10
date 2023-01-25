using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_PurchaseReceiveReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    [WebMethod]
    public static string Store_Get_SupplierPurchaseAndReturn(List<string> data)
    {
        try
        {
            //vCenterID INT,vCategoryID VARCHAR(500),vSubcategoryID VARCHAR(1000),
            //vItemID VARCHAR(2500),vStoreLedgerNo VARCHAR(50),vDeptledgerNo VARCHAR(200),vPeriodFrom DATE, vPeriodTo DATE,vDateType VARCHAR(1),
            //vVendorLedgerNo VARCHAR(500),vRefType VARCHAR(1),vRefNumber VARCHAR(20),vItemType VARCHAR(1),vTranType VARCHAR(1),vReportType VARCHAR(1)
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_SupplierPurchaseAndReturn(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vStoreLedgerNo, " +
                "@vDeptledgerNo,@vPeriodFrom,@vPeriodTo,@vDateType,@vVendorLedgerNo,@vRefType,@vRefNumber,@vItemType,@vTranType,@vReportType)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vStoreLedgerNo = data[14],
                    vDeptledgerNo = data[1],
                    vPeriodFrom = Util.GetDateTime(data[11]).ToString("yyyy-MM-dd"),
                    vPeriodTo = Util.GetDateTime(data[12]).ToString("yyyy-MM-dd"),
                    vDateType = data[6],
                    vVendorLedgerNo = data[5],
                    vRefType = data[7],
                    vRefNumber = data[8],
                    vItemType = data[9],
                    vTranType = data[10],
                    vReportType = data[13]
                });
            if (dt.Rows.Count > 0)
            {
				string ReportName ="";
                if (data[13] == "D")
                {
                    ReportName = "Purchase Report (Detailed)";
                }
                else if (data[13] == "S")
                {
                    ReportName = "Purchase Report (Summary)";
                }
                else
                    ReportName = "Purchase Report";
                dt = Util.GetDataTableRowSum(dt);
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
