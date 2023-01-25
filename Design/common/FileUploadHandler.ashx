<%@ WebHandler Language="C#" Class="FileUploadHandler" %>
using System;
using System.Web;
public class FileUploadHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string fname = "";
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                 fname = context.Server.MapPath("~/Documents/" + file.FileName);
                file.SaveAs(fname);
                fname = file.FileName;
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write(fname);
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