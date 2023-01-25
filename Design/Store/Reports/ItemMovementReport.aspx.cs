using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_ItemMovementReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static string Store_Get_ItemMovement(List<string> data)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_ItemMovement(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@vPeriodFrom,@vPeriodTo,@SearchType)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    vPeriodFrom = Util.GetDateTime(data[5]).ToString("yyyy-MM-dd HH:mm")+":00",
                    vPeriodTo = Util.GetDateTime(data[6]).ToString("yyyy-MM-dd HH:mm") + ":59",
                    SearchType = data[7]
                });
            if (dt.Rows.Count > 0)
            {
                string responseURL = string.Empty;
                if (data[9] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = " Date From : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy hh:mm tt") + "   To : " + Util.GetDateTime(data[6]).ToString("dd-MMM-yyyy hh:mm tt");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    
                    dc.ColumnName = "ReportType";
                    if (data[7] == "N")
                        dc.DefaultValue = "Non Moving Item";
                    else if (data[7] == "S")
                        dc.DefaultValue = "Slow Moving Item";
                    else if(data[7] == "F")
                        dc.DefaultValue = "Fast Moving Item";
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "ItemMovementReport";

                    //ds.WriteXmlSchema("c:/Ankur/ItemMovementReport.xml");
                    responseURL = "../../../Design/common/Commonreport.aspx";
                }
                if (data[9] == "EXCEL")
                {
                    dt = Util.GetDataTableRowSum(dt);
                    HttpContext.Current.Session["ReportName"] = "Item Movement Report";
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["Period"] = " Date From : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + "   To : " + Util.GetDateTime(data[6]).ToString("dd-MMM-yyyy");
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }
    }
}