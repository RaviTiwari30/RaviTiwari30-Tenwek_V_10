<%@ WebHandler Language="C#" Class="ImageHandler" %>

using System;
using System.Web;
using System.IO;
using System.Net;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Data;


public class ImageHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            HttpPostedFile postedFile = context.Request.Files[0];
            var AssetID = context.Request.Form["AssetID"];
            int ID = Util.GetInt(context.Request.Form["ID"]);
            var Remark = context.Request.Form["Remark"];
            var UploadBy = context.Request.Form["UserID"];
            for (int i = 0; i < files.Count; i++)
            {

                var pathname = All_LoadData.createDocumentFolder("AssetDocument", AssetID);
                if (pathname == null)
                {
                    string json = new JavaScriptSerializer().Serialize(new { Result = "Please create the D Drive or Share the D Drive" });
                    context.Response.StatusCode = (int)HttpStatusCode.OK;
                    context.Response.ContentType = "text/json";
                    context.Response.Write(json);
                    context.Response.End();
                    return;
                }
                HttpPostedFile file = files[i];
                string ImgName = file.FileName;
                string Exte = System.IO.Path.GetExtension(file.FileName);
                string newFile = Guid.NewGuid().ToString() + Exte;
                string Url = System.IO.Path.Combine(pathname + "/" + ID + newFile);

                if (!File.Exists(Url))
                {
                    File.Delete(Url);
                    DataTable dt = StockReports.GetDataTable("select * from eq_Asset_documentdetails where DocumentID='" + ID + "' and AssetID='" + AssetID + "'");
                    if (dt.Rows.Count > 0)
                    {
                        StockReports.ExecuteDML("Delete from eq_Asset_documentdetails where DocumentID='" + ID + "' and AssetID='" + AssetID + "'");
                    }
                    file.SaveAs(Url);
                    Url = Url.Replace("\\", "''");
                    Url = Url.Replace("'", "\\");
                    StockReports.ExecuteDML("INSERT INTO eq_Asset_documentdetails(AssetID,DocumentID,FileName,Url,UploadBy,UploadDate,Remark)VALUES('" + AssetID + "'," + ID + ",'" + ImgName + "','" + Url + "','" + UploadBy + "',NOW(),'" + Remark + "')");


                    string json = new JavaScriptSerializer().Serialize(new{Result = ImgName+" has been uploaded."});
                    context.Response.StatusCode = (int)HttpStatusCode.OK;
                    context.Response.ContentType = "text/json";
                    context.Response.Write(json);
                    context.Response.End();



                    //context.Response.Write("File(s) Uploaded Successfully!");
                }
                else
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("Error occurred, Please contact administrator");
                }

            }
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