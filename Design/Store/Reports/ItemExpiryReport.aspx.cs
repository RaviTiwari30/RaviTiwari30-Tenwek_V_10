using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_ItemExpiryReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }
    [WebMethod]
    public static string Store_Get_ExpiryDetail(List<string> data)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_ExpiryDetail(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@vValue,@ValueType,@SearchType,@vVendor)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    vValue = data[5],
                    ValueType = data[6],
                    SearchType = data[10],
                    vVendor = data[9]
                });
            if (dt.Rows.Count > 0)
            {
                string responseURL = string.Empty;
                if (data[8] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Util.GetString(HttpContext.Current.Session["ID"])).Rows[0][0].ToString();
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //ds.WriteXmlSchema("D://ItemExpiryReport.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "ItemExpiryReport";
                    responseURL = "../../../Design/common/Commonreport.aspx";
                }
                if (data[8] == "EXCEL")
                {
                    dt = Util.GetDataTableRowSum(dt);
                    HttpContext.Current.Session["ReportName"] = "Item Expiry Report";
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["Period"] = "As On Date :" + DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss tt");
                    responseURL = "../../../Design/Common/ExportToExcel.aspx";
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }
    }
            
       
}