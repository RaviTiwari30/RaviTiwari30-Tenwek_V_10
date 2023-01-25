<%@ WebService Language="C#"  Class="BatchProcess" %>
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

public class BatchProcess : System.Web.Services.WebService
{

    public BatchProcess()
    {
        
    }
 
    
    [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    
    public string LoadBatch()
    {
        BatchTransactionDetail bt = new BatchTransactionDetail();
        DataTable dt = bt.LoadBatch();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }
     [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
    
    public string LoadBatchDetail(string BatchNo)
    {


        string sqlCommand = " SELECT BatchNo,BatchName,BoilerName,DATE_FORMAT(startDate,'%d-%b-%y %h:%i %p')ApproxStartDate,  ";
        sqlCommand += " DATE_FORMAT(EndDate,'%d-%b-%y %h:%i %p')ApproxEndDate,SetID,setstockid,SetName,'' ItemID,'' ItemName,SUM(Quantity) Qty,'' stockid FROM ";
        sqlCommand += "  cssd_f_batch_tnxdetails WHERE BatchNo='" + BatchNo + "' AND IsProcess=1   GROUP BY SetID ";

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));

        //BatchTransactionDetail bt = new BatchTransactionDetail();
        //DataTable dt = bt.LoadBatchDetail(BatchNo);
        //return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateBatchProcessing(string ItemData)
    {
         BatchTransactionDetail bt = new BatchTransactionDetail();
         return bt.UpdateBatchDetail(ItemData);
       
     }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public string BtchProcessDateTime(string BatchNo)
    {
        BatchTransactionDetail bt = new BatchTransactionDetail();
        DataTable dt = bt.BtchProcessDateTime(BatchNo);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }
    
   
}