using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Finance_SearchStockAdjustment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static string Store_Get_AdjustmentDetail(List<string> data)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_AdjustmentDetail(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@ItemType,@vPeriodFrom,@vPeriodTo,@SearchType)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    ItemType = data[8],
                    vPeriodFrom = Util.GetDateTime(data[5]).ToString("yyyy-MM-dd"),
                    vPeriodTo = Util.GetDateTime(data[6]).ToString("yyyy-MM-dd"),
                    SearchType = data[7]
                });
            if (dt.Rows.Count > 0)
            {
                string responseURL = string.Empty;
                if (data[9] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = " Date From : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + "   To : " + Util.GetDateTime(data[6]).ToString("dd-MMM-yyyy");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    dc = new DataColumn();

                    dc.ColumnName = "ReportType";
                    if (data[7] == "A")
                        dc.DefaultValue = "Stock Adjustment(+) Report";
                    else if (data[7] == "P")
                        dc.DefaultValue = "Stock Process(-) Report";
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //HttpContext.Current.Session["ds"] = ds;
                    //HttpContext.Current.Session["ReportName"] = "StockAdjustmentReport";

                    //ds.WriteXmlSchema("D:/StockAdjustment.xml");
                    //responseURL = "../../../Design/common/Commonreport.aspx";
                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCache(CacheName, ds);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "Commonreport.aspx?ReportName=StockAdjustment" });
                }
                if (data[9] == "EXCEL")
                {
                  //  dt = Util.GetDataTableRowSum(dt);
				  
				 // List<decimal> columns = new List<decimal>() { 11,12 };
				 
				  if (data[7] == "A")
                    {
                        List<decimal> columns = new List<decimal>() { 12, 13 };

                        ProcessSummaryRow(dt, columns);
                    }
                    else if (data[7] == "P") {

                        List<decimal> columns = new List<decimal>() { 11, 12 };

                        ProcessSummaryRow(dt, columns);
                    }
				 
				 
				 
				 

                  //  ProcessSummaryRow(dt,columns);
                    HttpContext.Current.Session["ReportName"] = "Stock Adjustment Report";
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
	
	
	  private static DataTable ProcessSummaryRow(DataTable dt_, List<decimal> _columns)
    {
        List<decimal> columns = _columns;


        decimal[] RowTotals = new decimal[dt_.Columns.Count];
        foreach (DataRow row in dt_.Rows)
        {

            for (int i = 0; i < dt_.Columns.Count; i++)
            {
                if (columns.IndexOf(i) > -1)
                    RowTotals[i] += Util.GetDecimal(row[dt_.Columns[i].ColumnName]);
                else
                    continue;
            }
        }

        DataRow dtrow = dt_.NewRow();
        dtrow[0] = "Total";
        dt_.Rows.Add(dtrow);


        for (int i = 0; i < dt_.Columns.Count; i++)
        {

            if (columns.IndexOf(i) > -1)
                dt_.Rows[dt_.Rows.Count - 1][i] = RowTotals[i];
            else
                continue;
        }



        return dt_;

    }
   
}