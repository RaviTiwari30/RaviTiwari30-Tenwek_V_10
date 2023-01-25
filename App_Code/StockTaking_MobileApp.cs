using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using System.Xml;
using System.Security.Cryptography;

/// <summary>
/// Summary description for StockTaking_MobileApp
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class StockTaking_MobileApp : System.Web.Services.WebService
{

    DataTable dt;
    public StockTaking_MobileApp()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadCenter()
    {
        dt = All_LoadData.dtbind_Center();
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("");
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoginInfo(string CenterID, string UserName, string Password)
    {
        //By Default it will login as a Center one user but can access the other center from the center master drop down in the App.
        dt = StockReports.GetDataTable("CALL f_login('" + CenterID + "','" + UserName + "','" + EncryptPassword(Password) + "')");
        if (dt != null && dt.Rows.Count > 0)
        {
            DataTable dtUser = new DataTable();
            dtUser.Columns.Add("UserID");
            dtUser.Columns.Add("UserName");

            DataRow dr = dtUser.NewRow();
            dr["UserID"] = dt.Rows[0]["EmployeeID"].ToString();
            dr["UserName"] = dt.Rows[0]["EmpName"].ToString();

            dtUser.Rows.Add(dr);
            dtUser.AcceptChanges();

            return Newtonsoft.Json.JsonConvert.SerializeObject(dtUser);
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("");
        }
    }
    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2").ToLower());
        }
        return strBuilder.ToString();
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ScrinkItemMaster()
    {
        string Query = "SELECT im.ItemID,IFNULL(im.ItemCode,'')ItemCode, im.TypeName,IFNULL(im.UnitType,'')UnitType,sc.SubCategoryID,sc.Name SubCategoryName,cm.CategoryID,cm.Name CategoryName FROM f_itemmaster im ";
        Query += " INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ";
        Query += " INNER JOIN f_categorymaster cm ON cm.CategoryID=sc.CategoryID";
        Query += " INNER JOIN f_configrelation cn ON cm.CategoryID=cn.CategoryID";
        Query += " WHERE cn.ConfigID  IN ('11','28') AND cm.Active=1 AND sc.Active=1 AND im.IsActive=1";

        dt = StockReports.GetDataTable(Query);
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("");
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadDepartment()
    {
        dt = LoadCacheQuery.bindStoreDepartment();
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("");
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string InsertStockTake_Data(string ItemID, string ItemName, string BarcodeID, decimal Qty, string UnitType, decimal UnitPrice, decimal SellingPrice, int CenterID, string DepartmentID, string AppDateTime, string UserID, string Remark)
    {
        bool Result = StockReports.ExecuteDML("INSERT INTO sarvodaya.stocktaking_temptable    (ItemID,     ItemName,     BarcodeID,     Qty,     UnitType,     UnitPrice,     SellingPrice,     AppDateTime,     UserID,     Remark ,CenterID , DepartmentID)VALUES ('" + ItemID + "','" + ItemName + "','" + BarcodeID + "','" + Util.GetDecimal(Qty) + "','" + UnitType + "','" + Util.GetDecimal(UnitPrice) + "','" + Util.GetDecimal(SellingPrice) + "','" + Util.GetDateTime(AppDateTime).ToString("yyyy-MM-dd hh:mm:ss") + "','" + UserID + "','" + Remark + "','" + Util.GetInt(CenterID) + "','" + DepartmentID + "')");

        if (Result)
        {
            List<object> ReturnResult = new List<object>();
            ReturnResult.Add(new { StockID = BarcodeID });
            return Newtonsoft.Json.JsonConvert.SerializeObject(ReturnResult);
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("0");
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadUnit()
    {
        dt = StockReports.GetDataTable("select UnitName from f_unit_master ORDER BY unitname");
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("");
        }
    }
}
