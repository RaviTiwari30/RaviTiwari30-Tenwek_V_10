<%@ WebService Language="C#" Class="QuotationAndCompare" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Text.RegularExpressions;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[System.Web.Script.Services.ScriptService]
public class QuotationAndCompare : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }




    [WebMethod(EnableSession = true)]
    public string ConvertToExcel(string fileName, object data)
    {
        try
        {
            var s = Newtonsoft.Json.JsonConvert.SerializeObject(data);
            DataTable dt = JsonStringToDataTable(s);
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = fileName;
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                status = true,
            });
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }




    }



    public static DataTable JsonStringToDataTable(string jsonString)
    {
        DataTable dt = new DataTable();
        string[] jsonStringArray = Regex.Split(jsonString.Replace("[", "").Replace("]", ""), "},{");
        List<string> ColumnsName = new List<string>();
        foreach (string jSA in jsonStringArray)
        {
            string[] jsonStringData = Regex.Split(jSA.Replace("{", "").Replace("}", ""), ",");
            foreach (string ColumnsNameData in jsonStringData)
            {
                try
                {
                    int idx = ColumnsNameData.IndexOf(":");
                    string ColumnsNameString = ColumnsNameData.Substring(0, idx - 1).Replace("\"", "");
                    if (!ColumnsName.Contains(ColumnsNameString))
                    {
                        ColumnsName.Add(ColumnsNameString);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(string.Format("Error Parsing Column Name : {0}", ColumnsNameData));
                }
            }
            break;
        }
        foreach (string AddColumnName in ColumnsName)
        {
            dt.Columns.Add(AddColumnName);
        }
        foreach (string jSA in jsonStringArray)
        {
            string[] RowData = Regex.Split(jSA.Replace("{", "").Replace("}", ""), ",");
            DataRow nr = dt.NewRow();
            foreach (string rowData in RowData)
            {
                try
                {
                    int idx = rowData.IndexOf(":");
                    string RowColumns = rowData.Substring(0, idx - 1).Replace("\"", "");
                    string RowDataString = rowData.Substring(idx + 1).Replace("\"", "");
                    nr[RowColumns] = RowDataString;
                }
                catch (Exception ex)
                {
                    continue;
                }
            }
            dt.Rows.Add(nr);
        }
        return dt;
    }




    [WebMethod]
    public string GetItemMaster()
    {

        System.Text.StringBuilder sqlCMD = new System.Text.StringBuilder();

        sqlCMD.Append("  SELECT im.ItemID ItemId,im.TypeName ItemName,'' fromDate,''  toDate,'' vendorID, ");
        sqlCMD.Append("  '' vendorName,'' rate,0 discountPercent,0 minimum_Tolerance_Qty ,0 maximum_Tolerance_Qty,0 minimum_Tolerance_Rate,0 maximum_Tolerance_Rate, ");
        sqlCMD.Append("  '' currencyNotation,'' currencyFactor,'YES' SetDefault ");
        sqlCMD.Append("  FROM f_itemmaster im ");
        sqlCMD.Append("  INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID ");
        sqlCMD.Append("  INNER JOIN f_configrelation c ON c.CategoryID=sm.CategoryID ");
        sqlCMD.Append("  WHERE im.IsActive=1 AND c.ConfigID IN (11,28)  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCMD.ToString()));


    }





}
