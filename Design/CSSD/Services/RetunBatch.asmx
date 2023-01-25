<%@ WebService Language="C#" Class="RetunBatch" %>



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

[WebService(Namespace = "http:www.itdoseinfo.com/2012/11/20")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class RetunBatch : System.Web.Services.WebService
{

    public RetunBatch()
    {
        
    }
   
    
    [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    public string LoadBatchReturn()
    {
        BatchTransactionDetail bt = new BatchTransactionDetail();
        DataTable dt = bt.LoadBatchReturn();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
     [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    public string LoadBatchDetailReturn(string BatchNo)
    {
         BatchTransactionDetail bt = new BatchTransactionDetail();
         DataTable dt = bt.LoadBatchDetailReturn(BatchNo);
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
     }
    
    
    [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    public string ReturnBatchData(string ItemData)
    {
         BatchTransactionDetail bt = new BatchTransactionDetail();
         return bt.ReturnBatchData(ItemData);
         
     }
   
}