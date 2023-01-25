<%@ WebService Language="C#" Class="StoreItemSearch" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Linq;
using System.Data;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class StoreItemSearch : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public List<string> SearchItems(string prefixText, int count, string contextKey)
    {
        string sql = "SELECT TypeName ItemName,ItemID FROM f_itemmaster im   INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID = '" + contextKey + "' AND im.IsActive=1 AND im.TypeName LIKE '" + prefixText + "%'";
        DataTable dtItem = StockReports.GetDataTable(sql);

        List<string> storeItem = new List<string>();
        for (int i = 0; i < dtItem.Rows.Count; i++)
        {
            string item = AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(dtItem.Rows[i]["ItemName"].ToString(), dtItem.Rows[i]["ItemID"].ToString());
            storeItem.Add(item);
        }
        if (storeItem.Count == 0)
        {
            storeItem.Add("No match found.");
        }

        return storeItem;
    }
}