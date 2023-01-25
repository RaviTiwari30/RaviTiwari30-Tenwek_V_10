<%@ WebService Language="C#" Class="SMSApi" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SMSApi : System.Web.Services.WebService
{

    [WebMethod]
    public string SendSMS()
    {
        //ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
        int IsUploadWebClient = 1;
      //  string IniSms_api = "https://www.aerislive.com/api/api/sendSmsUrl?phone_number={Mobile_No}&sms_text={sms_text}&camp_name=campaign_name&app_id=80ae4db038374c7f63e292e9cbfc1ff2&app_key=a57256e09c3850cce07785f5b439b560"; //StockReports.ExecuteScalar("SELECT api.Key_Value FROM sms_api api WHERE api.IsActive=1;");

        string IniSms_api = "http://www.onex-ultimo.in/api/pushsms?user=Neotrans&authkey=92mQKSxOQsfhU&sender=NEOHOS&mobile={Mobile_No}&text={sms_text}&rpt=1&summary=1&output=json";
            
        
        string Result = "";
        string _SmsTo = "";
        string _Msg = "";
        string status = "";
        if (!string.IsNullOrEmpty(IniSms_api))
        {
            DataTable dtsmssend = StockReports.GetDataTable("SELECT sms_ID AS ID,Mobile_No,SMS_Text,smsType FROM sms_log WHERE IsSend in (0,2) LIMIT 50 ");
            if (dtsmssend.Rows.Count > 0)
            {
                for (int i = 0; i < dtsmssend.Rows.Count; i++)
                {
                    try
                    {
                        string smsto = string.Empty;
                        _SmsTo = dtsmssend.Rows[i]["Mobile_No"].ToString();
                        string Sms_api = IniSms_api;
                        //_SmsTo = dtsmssend.Rows[i]["Mobile_No"].ToString();
                        _Msg = dtsmssend.Rows[i]["SMS_Text"].ToString().Replace("&", "and");
                        Sms_api = Sms_api.Replace("{Mobile_No}", _SmsTo);
                        Sms_api = Sms_api.Replace("{sms_text}", _Msg);
                        if (IsUploadWebClient == 1)
                        {
                            ServicePointManager.Expect100Continue = true;
                            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12 | SecurityProtocolType.Ssl3;
                            WebClient Client = new WebClient();
                            Client.CachePolicy  = new System.Net.Cache.RequestCachePolicy(System.Net.Cache.RequestCacheLevel.NoCacheNoStore);
                            String RequestURL = String.Empty;
                            String RequestData = String.Empty;
                            RequestURL = Sms_api;
                            RequestData = "";
                            byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                            byte[] Response = Client.UploadData(RequestURL, "POST", PostData);
                            //byte[] Response = Client.UploadDataAsync(RequestURL, PostData);
                            Result = Encoding.ASCII.GetString(Response);
                            SMSDetails objList = Newtonsoft.Json.JsonConvert.DeserializeObject<SMSDetails>(Result);
                            Result = objList.STATUS;
                        }
                        else
                        {
                            using (WebClient client = new WebClient())
                            {
                                Result = client.DownloadString(Sms_api);
                            }
                        }
                        StockReports.ExecuteDML("Update SMS_log SET sms_response='" + Result.Trim() + "',IsSend=1,DeliveryDate=NOW() Where sms_ID=" + dtsmssend.Rows[i]["ID"].ToString() + "");
                        status = "Success";
                    }
                    catch (Exception ex) {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("Update SMS_log SET sms_response='" + ex.Message + "',IsSend=2 Where sms_ID='" + dtsmssend.Rows[0]["ID"].ToString() + "'");
                        status = ex.Message;
                    }
                }
            }
        }
        return status;
    }
    public class SMSDetails
    {
        public string STATUS { get; set; }
    }
}