<%@ WebService Language="C#" Class="PushIansoft" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using System.Xml;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class PushIansoft  : System.Web.Services.WebService {

    string fiancedatabasename = "finance";
    
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
    public class InfoPoAdvance {
        public string Service_Category { get; set; }
        public string G_L_Account { get; set; }
        public string Test_Name { get; set; }
        public bool Synced { get;set;}
        public DateTime Synced_Date { get; set; }
    }
    
    
    [WebMethod]
    public void PushDatatoFiance() 
    {

        DataTable dt = new DataTable();
        string result = string.Empty;
        //for (int i = 0; i < dt.Rows.Count; i++)
        //{
            result = string.Empty;
            var request = (HttpWebRequest)WebRequest.Create("http://10.10.2.37:7047/BC140/WS/Tenwek%20Hospital/Page/ITDoseCOA");
            request.Method = WebRequestMethods.Http.Post;
            request.ContentType = "application/xml; charset=UTF-8";
            request.UseDefaultCredentials = true;
        
            InfoPoAdvance po = new InfoPoAdvance();
            po.Service_Category = "1";
            po.G_L_Account = "A001";
            po.Test_Name = "Test";
            po.Synced = true;
            po.Synced_Date = DateTime.Now;
            
            try
            {
                using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                {
                    streamWriter.Write(JsonConvert.SerializeObject(po));
                }
                var response = (HttpWebResponse)request.GetResponse();
                using (var streamReader = new StreamReader(response.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                    //XmlDocument doc = new XmlDocument();
                    //doc.LoadXml(result);
                    //string jsonText = JsonConvert.SerializeXmlNode(doc);
                    //InfoResponse objList = JsonConvert.DeserializeObject<InfoResponse>(streamReader.ReadToEnd());
                    //StockReports.ExecuteDML("UPDATE cafe_integration Set ErrorCode='" + objList.ErrorCode + "',Messgae='" + objList.Message + "',IsSync=1,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                }
                response.Close();
                result = "Success";
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                //StockReports.ExecuteDML("UPDATE cafe_integration Set ErrorCode='" + ex.Message + "',Messgae='" + ex.Message + "',IsSync=5,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                result = "Fail";
            }
        //}
        
        //Tenwekfinance.ITDoseRevenue cr = new Tenwekfinance.ITDoseRevenue();
        //string result = string.Empty;
        //DataTable dt = StockReports.GetDataTable("SELECT * FROM "+ fiancedatabasename +".revenue$detail r WHERE r.IsSync=0 ");
        //if (dt.Rows.Count > 0) {
        //    for (int i = 0; i < dt.Rows.Count; i++)
        //    {
        //        //HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(url);
        //        //webRequest.Headers.Add("SOAPAction", soapAction ?? url);
        //        //webRequest.ContentType = (useSOAP12) ? "application/soap+xml;charset=\"utf-8\"" : "text/xml;charset=\"utf-8\"";
        //        //webRequest.Accept = (useSOAP12) ? "application/soap+xml" : "text/xml";
        //        //webRequest.Method = "POST";
               
        //        cr.TransactionNo = dt.Rows[i]["TRANSNO"].ToString();
        //        cr.PatientID = dt.Rows[i]["PATIENTID"].ToString();
        //        cr.Patient_Name = dt.Rows[i]["PATIENTNAME"].ToString();
        //        cr.Doctor_ID = dt.Rows[i]["DOCTORID"].ToString();
        //        cr.Doctor_Name = dt.Rows[i]["DOCTORNAME"].ToString();
        //        cr.DepartmentID = dt.Rows[i]["DEPARTMENTID"].ToString();
        //        cr.BillDate = Util.GetDateTime(dt.Rows[i]["BillDate"]);
        //        cr.BillNo = dt.Rows[i]["BILLNO"].ToString();
        //        cr.Amount = Util.GetDecimal(dt.Rows[i]["ItemAmount"]);
        //        cr.Line_Discount = Util.GetDecimal(dt.Rows[i]["DISCAMT"]);
        //        cr.Line_Amount = Util.GetDecimal(dt.Rows[i]["ItemNetAmount"]);
        //        cr.Remarks = Util.GetString(dt.Rows[i]["REMARK"]);
        //        cr.Panel_ID = Util.GetString(dt.Rows[i]["PANELID"]);
        //        cr.Item_Code = Util.GetString(dt.Rows[i]["ItemCode"]);
        //        cr.Panel_Name = Util.GetString(dt.Rows[i]["PANELNAME"]);
        //        cr.Revenue_Account = Util.GetString(dt.Rows[i]["REVENUEACCOUNT"]);
        //        cr.Currency_Code = Util.GetString(dt.Rows[i]["CURRENCYNAME"]);
        //        cr.Currency_Rate = Util.GetDecimal(dt.Rows[i]["CURRCONV"]);
        //        cr.Transaction_Type = Util.GetInt(0); //Util.GetString(dt.Rows[i]["TRANTYPE"]);
        //        cr.Module = Util.GetString(dt.Rows[i]["MODULE"]);
        //        cr.Branch_ID = Util.GetString(dt.Rows[i]["BOOKINGBRNCHID"]);
        //        cr.Is_Walkin = Util.GetString(dt.Rows[i]["IsWalkin"]) == "1" ? true : false;
        //        cr.HISID = Util.GetInt(dt.Rows[i]["HISID"]);
        //        cr.Config_Id = Util.GetString(dt.Rows[i]["ConfigID"]);
        //        cr.Tax_Amt = Util.GetDecimal(dt.Rows[i]["Tax_amt"]);
        //        cr.Tax_Per_unit = Util.GetDecimal(dt.Rows[i]["Tax_Per"]);
        //        try
        //        {
        //            using (WebResponse response = webRequest.GetResponse())
        //            {
        //                using (StreamReader rd = new StreamReader(response.GetResponseStream()))
        //                {
        //                    result = rd.ReadToEnd();
        //                }
        //            }
        //            result = "Success";
        //        }
        //        catch (Exception ex)
        //        {
        //            ClassLog cl = new ClassLog();
        //            cl.errLog(ex);
        //            StockReports.ExecuteDML("UPDATE cafe_integration Set ErrorCode='" + ex.Message + "',Messgae='" + ex.Message + "',IsSync=5,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
        //            result = "Fail";
        //        }
        //    }
        //}
    }
}