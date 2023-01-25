<%@ WebService Language="C#"  Class="SetItems" %>


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

/// <summary>
/// Summary description for SetItems
/// </summary>
[WebService(Namespace = "http://www.itdoseinfo.com/CSSD/Sets1")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class SetItems : System.Web.Services.WebService
{

    public SetItems()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
   

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string loadSets()
    {

        Set st = new Set();
        DataTable dt= st.LoadSets();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }


    

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string loadSetItems(string SetID)
    {

        Set st = new Set();
        DataTable dt = st.loadSetItems(SetID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }

    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public string SaveSetItem(string ItemData)
    {
        Setitemdetails objitem = new Setitemdetails();
        return objitem.SaveDetails(ItemData);
       
    }
    
      [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public string EditSetItemsDetails(string ItemData)
    {
        Setitemdetails objitem = new Setitemdetails();
        return objitem.EditSetItemsDetails(ItemData);
       
    }

    [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
      public string LoadSetItemsWithStock(string SetID, string SetStockID)
    {
        Setitemdetails setdtl = new Setitemdetails();
        DataTable dt = setdtl.LoadSetItemsWithStock(SetID, SetStockID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
    
    
    [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    public string LoadSetItemsWithOutStock(string SetID)
    {
        Setitemdetails setdtl = new Setitemdetails();
        DataTable dt = setdtl.LoadSetItemsWithOutStock(SetID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
      
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string RecieveSet(object ItemData, string SetStockID)
    {
        Setitemdetails objitem = new Setitemdetails();
        return objitem.RecieveSet(ItemData, SetStockID);
        
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SetStockID(string SetID)
    {

        string rtrn = Util.GetString(StockReports.ExecuteScalar(" SELECT SetStockID FROM cssd_recieve_Set_stock WHERE SetId=" + SetID + " AND Batchprocess=0 "));
        return rtrn;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string chkSetQty(string SetID, int qty)
    {

        string rtrn = Util.GetString(StockReports.ExecuteScalar(" SELECT SetStockID FROM cssd_recieve_Set_stock WHERE SetId=" + SetID + " AND Batchprocess=0 "));
        return rtrn;
    }
   
    
     [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    public string ReciveAsSet()
    {
        Setitemdetails setdtl = new Setitemdetails();
        DataTable dt = setdtl.LoadSetHavingItem();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
     [WebMethod(EnableSession = true)]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public string SearchCSSDItems(string ItemCode)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append(" SELECT concat(IM.Typename,'#',IFNULL(IM.ItemCatalog,''),'#',IFNULL(IM.itemcode,'')) ItemName,IM.ItemID");
         sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
         sb.Append(" INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID  ");
         sb.Append(" WHERE CR.ConfigRelationID IN (11) AND im.IsActive=1  and sm.subcategoryID in ('LSHHI88','LSHHI100')");
         if (ItemCode != "")
             sb.Append(" AND IM.ItemCode like '%" + ItemCode + "%'");
         sb.Append(" ORDER BY im.TypeName ");

         DataTable dt = StockReports.GetDataTable(sb.ToString());

         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
         
     }
}

