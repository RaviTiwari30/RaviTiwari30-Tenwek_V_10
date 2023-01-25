<%@ WebService Language="C#" Class="AssetItems" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.None)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AssetItems : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    //[WebMethod(MessageName = "abc")]
    //public void LoadItems(string cmd, string type, string stockid, string page, string rows)
    //{
    //    HttpContext.Current.Response.Write("[]");
    //}




    [WebMethod]
    public void LoadItems(string cmd, string q, string stock_id, string DeptLedgerNo, string page, string rows)
    {
        var dt = new System.Data.DataTable();
        try
        {
            
            
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(" SELECT em.assetid,(st.initialcount-st.releasedcount)AvailableQty,em.serialno,DATE_FORMAT(em.warrantyto,'%d %b %y')warrantyto,DATE_FORMAT(em.warrantyfrom,'%d %b %y')warrantyfrom, st.ItemName,st.ItemID,st.StockID,st.IGSTPercent,st.SGSTPercent,st.CGSTPercent  FROM f_stock st ");
                sb.Append(" INNER JOIN ass_assetstock ast ON ast.GRNStockID=st.StockID AND (st.initialcount-st.releasedcount)>0 ");
                sb.Append(" INNER JOIN eq_asset_master em ON em.assetid=ast.assetid ");
                sb.Append(" AND st.ispost=1 AND st.isasset=1 and st.DeptLedgerNo='" + DeptLedgerNo + "'  ");
                if(q.Trim()!="")
                    sb.Append(" and st.itemname like '" + q.Trim() + "%'");
                if (stock_id.Trim() != "")
                    sb.Append(" and st.stockid = '" + stock_id + "'");
                sb.Append(" GROUP BY st.stockid; ");
                dt = StockReports.GetDataTable(sb.ToString());
            
            HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
        }
        catch (Exception)
        {

            throw;
        }
    }



}