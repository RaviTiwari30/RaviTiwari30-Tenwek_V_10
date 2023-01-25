<%@ WebService Language="C#" Class="StockStatusRpt" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class StockStatusRpt  : System.Web.Services.WebService {
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
     

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDDlManufacture(string ItemID, string MacID, string IsAllItems)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_DDlManufacture(ItemID, MacID, IsAllItems);
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDDLMachine(string ItemID, string IsAllItems)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_DDLMachine(ItemID, IsAllItems);
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDDLPacking(string ItemID, string ManufactureID, string IsAllItems)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_DDLPacking(ItemID, ManufactureID, IsAllItems);
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetReport(string StarStore, string OrganStore, string JantaStore, string ItemID, string Centers, string Department, string MacID, string ManufactureID, string Packing, string IsAllItems, string SubCategoryID)
    {
        StockStatusReport objRpt = new StockStatusReport();
        string rtrn = objRpt.GetReport(StarStore, OrganStore, JantaStore, ItemID, Centers, Department, MacID, ManufactureID, Packing, IsAllItems, SubCategoryID);
        return rtrn;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindListBox(string SubCategoryID)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_ListBox(SubCategoryID);
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindListAmtInfo(string ItemID,string VendorID,string DeptLedgerNo)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_ListAmtInfo(ItemID, VendorID, DeptLedgerNo);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindListAmtInfoItemWise(string ItemID, string DeptLedgerNo)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_ListAmtInfo_ItemWise(ItemID, DeptLedgerNo);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindLastPurchaseInfo(string ItemID)
    {
        StockStatusReport objRpt = new StockStatusReport();
        DataTable dt = objRpt.Bind_LastPurchaseInfo(ItemID);
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    
    
    
    
    
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
}

