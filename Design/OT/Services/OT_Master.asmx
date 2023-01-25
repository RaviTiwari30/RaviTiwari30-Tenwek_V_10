<%@ WebService Language="C#" Class="OT_Master" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class OT_Master  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }



    [WebMethod]
    public string GetOTs() {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt=  excuteCMD.GetDataTable("SELECT om.ID,om.Name FROM  ot_master om WHERE om.IsActive=1",CommandType.Text);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    
    
}