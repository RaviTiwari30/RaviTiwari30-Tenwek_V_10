<%@ WebHandler Language="C#" Class="FileUploader" %>

using System;
using System.Web;
using System.IO;
using System.Web.Hosting;
using System.Diagnostics;

public class FileUploader : IHttpHandler
{
    private HttpContext _httpContext;
    private string _preSaveExt = "tmp";
    private string _fName;
    private bool _lastChunk;
    private bool _firstChunk;
    private long _startByte;
    private string _patientID;
    private string _transactionID;
    private string _user;
    private string _type;
    
    public void ProcessRequest(HttpContext context)
    {
        string _returnMessage = "ERROR: Unknown error";                
        _httpContext = context;        
        try
        {
            if (context.Request.InputStream.Length > 0)
            {
                GetQueryStringParameters();
                string Path = context.Server.MapPath("~/") + "Audio";
                DirectoryInfo dirDoc = new DirectoryInfo(Path);
                if (!dirDoc.Exists)
                {
                    dirDoc.Create();
                }

                string uploadFolder = "Audio";
                string tempFileName = _fName + _preSaveExt;

                if (_firstChunk)
                {
                    //Delete temp file
                    if (File.Exists(@HostingEnvironment.ApplicationPhysicalPath + "/" + uploadFolder + "/" + tempFileName))
                        File.Delete(@HostingEnvironment.ApplicationPhysicalPath + "/" + uploadFolder + "/" + tempFileName);

                    //Delete target file
                    if (File.Exists(@HostingEnvironment.ApplicationPhysicalPath + "/" + uploadFolder + "/" + _fName))
                        File.Delete(@HostingEnvironment.ApplicationPhysicalPath + "/" + uploadFolder + "/" + _fName);

                }

                using (FileStream fs = File.Open(@HostingEnvironment.ApplicationPhysicalPath + "/" + uploadFolder + "/" + tempFileName, FileMode.Append))
                {
                    SaveFile(context.Request.InputStream, fs);
                    fs.Close();
                }

                string fileName = "";
                if (_lastChunk)
                {
                    Path += "\\" + _transactionID;
                    dirDoc = new DirectoryInfo(Path);
                    if (!dirDoc.Exists)
                    {
                        dirDoc.Create();
                    }

                    string date = DateTime.Now.ToString("dd-MM-yyyy");
                    Path += "\\" + date;
                    dirDoc = new DirectoryInfo(Path);
                    if (!dirDoc.Exists)
                    {
                        dirDoc.Create();
                    }
                    System.IO.DirectoryInfo di = new DirectoryInfo(Path);

                    int NoOfFiles = di.GetFiles().Length + 1;
                    fileName = "Audio" + NoOfFiles.ToString();
                    Path += "\\" + fileName + ".wav";

                    File.Move(HostingEnvironment.ApplicationPhysicalPath + "/" + uploadFolder + "/" + tempFileName, Path);

                    string path = Path.Replace(@"\", @"\\");

                    string doctorID = Util.GetString(StockReports.ExecuteScalar("SELECT DoctorID FROM patient_medical_history WHERE TransactionID='" + _transactionID + "'"));

                    StockReports.ExecuteDML("insert into cpoe_voicerecord (Path,EntryDate,PatientID,TransactionID,Userid,DoctorID,FileName,Type) values('" + path + "',Now(),'" + _patientID + "','" + _transactionID + "','" + _user + "','" + doctorID + "','" + fileName + "','"+_type+"')");
                    
                    _returnMessage="Audio saved successfully";
                }
            }
            else
            {
                _returnMessage = "ERROR: Nothing to read from input stream";
            }         
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            _returnMessage = string.Format("ERROR: {0}", ex.Message);    
        }

        // Write out our response for our Silverlight app
        context.Response.ContentType = "text/plain";
        context.Response.Clear();
        context.Response.Write(_returnMessage);
        context.Response.Flush();
        context.Response.Close();        
    }

    private void GetQueryStringParameters()
    {
        _fName = _httpContext.Request.QueryString["file"];
        _lastChunk = string.IsNullOrEmpty(_httpContext.Request.QueryString["last"]) ? true : bool.Parse(_httpContext.Request.QueryString["last"]);
        _firstChunk = string.IsNullOrEmpty(_httpContext.Request.QueryString["first"]) ? true : bool.Parse(_httpContext.Request.QueryString["first"]);
        _startByte = string.IsNullOrEmpty(_httpContext.Request.QueryString["offset"]) ? 0 : long.Parse(_httpContext.Request.QueryString["offset"]);
        _patientID = _httpContext.Request.QueryString["PatientID"].ToString();
        _transactionID = _httpContext.Request.QueryString["TransactionID"].ToString();
        _user = _httpContext.Request.QueryString["User"].ToString();
        _type = _httpContext.Request.QueryString["Type"].ToString();
    }
    
    private void SaveFile(Stream stream, FileStream fs)
    {
        byte[] buffer = new byte[4096];
        int bytesRead;
        while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) != 0)
        {
            fs.Write(buffer, 0, bytesRead);
        }
    }  
      
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}