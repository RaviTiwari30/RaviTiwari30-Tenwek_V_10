<%@ WebService Language="C#"  Class="SetItemStock" %>

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

[WebService(Namespace="http:www.itdoseinfo.com/2012/11/17")]
[WebServiceBinding(ConformsTo=WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class SetItemStock:System.Web.Services.WebService
{
    public SetItemStock()
    {
        
    }
 
    
    [WebMethod(EnableSession=true,MessageName="LoadData")]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    public string LoadStockData()
    {
        SetItemStockDetail st = new SetItemStockDetail();
        DataTable dt= st.LoadSetItemStock();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
      
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadStockDataSetNew(string setID, string SetStockID)
    {
        SetItemStockDetail st = new SetItemStockDetail();
        DataTable dt = st.LoadSetItemStockNEW(setID, SetStockID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
    
    [WebMethod(EnableSession = true,MessageName="LoadStockDatanew")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadStockData(string ItemData)
    {
        SetItemStockDetail st = new SetItemStockDetail();
        DataTable dt = st.LoadSetItemStock(ItemData);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
     

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveBatchProcessing(string ItemData)
    {

       
        
        SetItemStockDetail st = new SetItemStockDetail();
        return st.SaveStockData(ItemData);
      
    }
    
    
}