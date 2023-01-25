using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.IO;
public partial class Design_Store_ABCReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static string Store_Get_ABCData(List<string> data)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_ABCData(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@vStoreType)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    vStoreType = data[5]
                });
            if (dt.Rows.Count > 0)
            {
                string responseURL = string.Empty;
                //dt = Util.GetDataTableRowSum(dt);
                decimal TotalConsumAnualAmt = Util.GetDecimal(dt.Compute("sum([Average Consume Annual Amount]) ", ""));
                DataColumn dc1 = new DataColumn();
                dc1.ColumnName = "ConsumeAnualPer";
                dc1.DataType = typeof(decimal);
                dt.Columns.Add(dc1);
                dc1 = new DataColumn();
                dc1.ColumnName = "ABC Status";
                dc1.DataType = typeof(string);
                dt.Columns.Add(dc1);
                foreach (DataRow dr in dt.Rows)
                {
                    if (TotalConsumAnualAmt == 0) { dr["ConsumeAnualPer"] = 0; }
                    else{ dr["ConsumeAnualPer"] = Util.round((Util.GetDecimal(dr["Cumulative Size Amount"]) * 100) / TotalConsumAnualAmt);}
                    if (Util.GetDecimal(dr["ConsumeAnualPer"]) <= Util.GetDecimal(data[6]))
                        dr["ABC Status"] = "A";
                    else if (Util.GetDecimal(dr["ConsumeAnualPer"]) > Util.GetDecimal(data[6]) && Util.GetDecimal(dr["ConsumeAnualPer"]) <= Util.GetDecimal(data[7]))
                        dr["ABC Status"] = "B";
                    else if (Util.GetDecimal(dr["ConsumeAnualPer"]) >= Util.GetDecimal(data[8]))
                        dr["ABC Status"] = "C";
                }
                dt.Columns.Remove("Cumulative Size Amount");
               // dt.Columns.Remove("ConsumeAnualPer");
                if (data[9] == "EXCEL")
                {
                    HttpContext.Current.Session["ReportName"] = "ABC Analysis Report";
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["Period"] = "As On Date : " + DateTime.Now.ToString("dd-MM-yyyy hh:mm:ss tt");
                    responseURL = "../../../Design/Common/ExportToExcel.aspx";
                }
                else if (data[9] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = " As on Date : " + Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy")) + " " + DateTime.Now.ToString("hh:mm:ss tt");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //ds.WriteXmlSchema("C:/Ankur/ABCAnalysisReport.xml");
                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCache(CacheName, ds);
                    responseURL = "Commonreport.aspx?ReportName=ABCAnalysisReport";
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
