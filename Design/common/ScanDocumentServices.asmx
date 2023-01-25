<%@ WebService Language="C#" Class="ScanDocumentServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using System.Linq;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ScanDocumentServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }




    [WebMethod]
    public string GetShareScanners()
    {
        try
        {
            ScanDocument scanDocument = new ScanDocument();
            return JsonConvert.SerializeObject(new{status=true,data=scanDocument.GetScanners()});
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }
        
    }

    [WebMethod]
    public string Scan(string deviceID)
    {
        try
        {
            ScanDocument scanDocument = new ScanDocument();
            var path = "E:\\";
            var fileName = "abc";
            var response= scanDocument.ScanDoc(deviceID, "abc", "E:\\");
            if (response=="ok")
            {
                var fileData = System.IO.File.ReadAllBytes(path + "\\" + fileName + ".jpeg");
                return JsonConvert.SerializeObject(new { status = true, data = Convert.ToBase64String(fileData) });
            }
            else
                return JsonConvert.SerializeObject(new { status = false, data = response });
            
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }
        
    }


     [WebMethod]
    public string GetMasterDocuments(string patientID)
    {
        try
        {  
        var patientDocumentMasters = StockReports.GetDataTable("SELECT rm.FormID,rm.FormName FROM research_master rm").AsEnumerable().Select(i=> new{
            FormID = i.Field<int>("FormID"),
            FormName = i.Field<string>("FormName")
        }).ToList();

        if (All_LoadData.chkDocumentDrive() == 0)
            return JsonConvert.SerializeObject(new { status = false, response = "Please Create " + Resources.Resource.DocumentDriveName + " Drive" });

        var pathname = All_LoadData.createDocumentFolder("OPDDocument", patientID.Replace("/", "_"));
        List<object> patientDocuments = new List<object>(); 
        patientDocumentMasters.ForEach(i =>
        {
            var files = System.IO.Directory.GetFiles(pathname.ToString(), i.FormName.Replace('/','-') + "*");
            var document = new { FormName = i.FormName, FormID = i.FormID, ExitsCount = files.Length };
            patientDocuments.Add(document);
        });
        return JsonConvert.SerializeObject(new { status = true, patientDocumentMasters = patientDocuments });

        }
        catch (Exception ex)
        {

            return JsonConvert.SerializeObject(new { status = false, response = "Please Create " + Resources.Resource.DocumentDriveName + " Drive",errorMessage=ex.Message });
        }
    }

     [WebMethod]
     public string GetDocument(string patientId,string documentName)
     {
         try
         {
             if (All_LoadData.chkDocumentDrive() == 0)
                 throw new Exception("Please Create " + Resources.Resource.DocumentDriveName + " Drive");

             var pathname = All_LoadData.createDocumentFolder("OPDDocument", patientId.Replace("/", "_"));
             string Url = System.IO.Path.Combine(pathname + "\\" + documentName.Replace('/','-') + ".jpeg");

             var fileData = System.IO.File.ReadAllBytes(Url);
             return JsonConvert.SerializeObject(new { status = true, data =string.Format("data:image/jpeg;base64,{0}",Convert.ToBase64String(fileData))});
         }
         catch (Exception ex)
         {
             return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
         }
        
     }

     [WebMethod]
     public bool SaveScanFile(string ID, string patientID, string documentID, string documentName, string documentFileType, string base64Document, string savePath)
     {
         try
         {
             System.IO.File.WriteAllBytes(savePath, Convert.FromBase64String(base64Document));
             return true;
         }
         catch (Exception)
         {

             return false;
         }
         
     }
    
    
}