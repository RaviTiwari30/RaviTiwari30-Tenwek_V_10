<%@ WebService Language="C#" Class="GetDoctorSIgnatureForRadiolodyApp" %>

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
public class GetDoctorSIgnatureForRadiolodyApp : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetSignature(string DoctorID)
    {
        string Path = Server.MapPath("~/Design/Lab/Signature/");
        Path = Path + DoctorID + ".jpg";      
        string Url = System.IO.Path.Combine(Path);       
        if (System.IO.File.Exists(Url))
        {
            byte[] bytes = System.IO.File.ReadAllBytes(Path);
            string base64String = Convert.ToBase64String(bytes);
            return base64String;

        }
        else
            return "";
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetHeaderFooter(string HeaderFooter)
    {
        string Path = Server.MapPath("~/Design/");
        Path = Path + HeaderFooter;
        byte[] bytehead = System.IO.File.ReadAllBytes(Path);
        string base64String = Convert.ToBase64String(bytehead);
        return base64String;
    }

  
    
    
}

