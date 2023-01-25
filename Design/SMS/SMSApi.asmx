<%@ WebService Language="C#" Class="SMSApi" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class SMSApi  : System.Web.Services.WebService {

   
    [WebMethod]
    public void followUPSms()
    {
        DataTable SMSdt = StockReports.GetDataTable(" SELECT Sms_Id,Mobile_No,SMS_Text FROM sms_log WHERE IsSend=0 AND IsFollowUp=1 AND DATE_ADD(FollowUpDate, INTERVAL -1 DAY)=CURRENT_DATE() ");

        string SMSId = "";
        if (SMSdt.Rows.Count > 0)
        {
            
            foreach (DataRow dr in SMSdt.Rows)
            {
                string Result = "";
                if (SMSId == String.Empty)
                    SMSId += Util.GetString(dr["SMS_Id"]);
                else
                    SMSId += "," + Util.GetString(dr["SMS_Id"]);

                string Sms_api = AllGlobalFunction.SMSAPI;

                Sms_api = Sms_api.Replace("{Mobile}", Util.GetString(dr["Mobile_No"]));
                Sms_api = Sms_api.Replace("{Sms}", Util.GetString(dr["SMS_Text"]));

                System.Net.WebClient Client = new System.Net.WebClient();

                String RequestURL, RequestData;

                RequestURL = Sms_api;
                RequestData = "";
                byte[] PostData = System.Text.Encoding.ASCII.GetBytes(RequestData);
                byte[] Response = Client.UploadData(RequestURL, PostData);
                Result = System.Text.Encoding.ASCII.GetString(Response);
               

            }
            StockReports.ExecuteDML("UPDATE sms_log set IsSend=1 WHERE SMS_Id IN (" + SMSId + ") ");
        }
    }
   

    
}