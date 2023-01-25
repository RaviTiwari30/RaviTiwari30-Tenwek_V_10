<%@ WebService Language="C#" Class="AutoCompleteICD" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[ScriptService]
public class AutoCompleteICD  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string[] GetCompletionList(string prefixText, int count)
    {
        string sql = "Select who_full_desc from icd_10_new Where ISActive=1 AND who_full_desc like '%" + prefixText + "%'";
        DataTable ICD = StockReports.GetDataTable(sql);
        string[] items = new string[ICD.Rows.Count];
        int i = 0;
        foreach (DataRow dr in ICD.Rows)
        {
            items.SetValue(dr["who_full_desc"].ToString(), i);
            i++;
        }
        return items;
    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string[] GetCompletionListCode(string prefixText, int count)
    {
        string sql = "Select ICD10_Code from icd_10_new Where ISActive=1 AND ICD10_Code like '%" + prefixText + "%'";
        DataTable ICD = StockReports.GetDataTable(sql);
        string[] items = new string[ICD.Rows.Count];
        int i = 0;
        foreach (DataRow dr in ICD.Rows)
        {
            items.SetValue(dr["ICD10_Code"].ToString(), i);
            i++;
        }
        return items;
    }

    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string[] GetLabPrescriptionOPD(string prefixText, int count)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,im.Typename FROM f_itemmaster im  ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.subcategoryid ");
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.categoryid  ");
        sb.Append(" INNER JOIN f_configrelation cfg ON cfg.categoryid=cm.categoryid WHERE cfg.configID IN (3) AND im.isactive=1 ");
        sb.Append(" and im.TypeName like '%" + prefixText + "%'");
        sb.Append(" ORDER BY im.typename ");

        DataTable ICD = StockReports.GetDataTable(sb.ToString());
        string[] items = new string[ICD.Rows.Count];
        int i = 0;
        foreach (DataRow dr in ICD.Rows)
        {
            items.SetValue(dr["Typename"].ToString(), i);
            i++;
        }
        return items;
    }
    
}