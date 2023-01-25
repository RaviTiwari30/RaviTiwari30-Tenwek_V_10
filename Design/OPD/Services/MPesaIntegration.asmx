<%@ WebService Language="C#" Class="MPesaIntegration" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Net.Http;
using Newtonsoft.Json.Linq;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class MPesaIntegration  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
     
 
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetAccessToken()
    {
        // string recivedata = "";
        MpesaTokenResponseModel tokenResponse = MpesaGetAccessToken.GetMpesaAccessToken();


        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = tokenResponse.AccessToken });

    }



    [WebMethod]
    public string MpesaRequest()
    {
        return "Hello World";
    }
    
   
    
    
    
}