<%@ WebHandler Language="C#" Class="SaveImage" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Net;
using System.IO;
using System.Data;
public class SaveImage : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Form["CallFor"] == "NewsMaster")
        {
            if (context.Request.Files.Count > 0)
            {
                HttpFileCollection files = context.Request.Files;
                HttpPostedFile postedFile = context.Request.Files[0];
                var DateFrom = context.Request.Form["DateFrom"];
                var DateTo = context.Request.Form["DateTo"];
                var Subject = context.Request.Form["Subject"];
                var Details = context.Request.Form["Details"];
                var IsImportant = context.Request.Form["IsImportant"];
                var Savetype = context.Request.Form["Savetype"];
                var NewsId = context.Request.Form["NewsId"];
                var CreatedBy = context.Request.Form["UserID"];
                for (int i = 0; i < files.Count; i++)
                {
                    string str1 = "SELECT COUNT(*) FROM news_master ";
                    var NewsId1 = Util.GetInt(StockReports.ExecuteScalar(str1));
                    var Nid = NewsId1 + 1;
                    var pathname = All_LoadData.createDocumentFolder("NewsDocuments", DateFrom + "_" + Nid);
                    if (pathname == null)
                    {
                        string json = new JavaScriptSerializer().Serialize(new { Result = "Please create the C Drive or Share the C Drive" });
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
                    string Url = System.IO.Path.Combine(pathname + "/" + ImgName);
                    var androidUrl = "http://itd.infosysmicro.com/HISDocument/OPDDocument/" + DateFrom + "_" + Nid + "/" + ImgName;
                    //string urlm="http://itd.infosysmicro.com";
                    //string UrlforMobile = System.IO.Path.Combine(urlm + pathname + "/" + ImgName);






                    if (!File.Exists(Url))
                    {

                        file.SaveAs(Url);

                        Url = Url.Replace("\\", "''");
                        Url = Url.Replace("'", "\\");



                        if (NewsId == "")
                        {

                            StockReports.ExecuteDML("INSERT INTO news_master(ValidFrom,VaildTo,Sub,Message,imageurl_his,imageurl_mobile,isImp,EntryBy,NewsId,dtEntry)VALUES('" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "','" + Subject + "','" + Details + "','" + Url + "','" + androidUrl + "','" + IsImportant + "','" + CreatedBy + "','" + Nid + "',NOW())");
                            string json = new JavaScriptSerializer().Serialize(new { Result = 1 });
                            context.Response.StatusCode = (int)HttpStatusCode.OK;
                            context.Response.ContentType = "text/json";
                            context.Response.Write(json);
                            context.Response.End();
                        }
                        else
                        {
                            StockReports.ExecuteDML("update news_master set  ValidFrom='" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "',VaildTo='" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "',Sub='" + Subject + "',Message='" + Details + "',imageurl_his='" + Url + "',imageurl_mobile='" + androidUrl + "',isImp='" + IsImportant + "',EntryBy='" + CreatedBy + "',dtEntry=NOW() WHERE NewsId='" + NewsId + "'");
                            string json = new JavaScriptSerializer().Serialize(new { Result = 2 });
                            context.Response.StatusCode = (int)HttpStatusCode.OK;
                            context.Response.ContentType = "text/json";
                            context.Response.Write(json);
                            context.Response.End();
                        }




                    }

                    else
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write("Error occurred, Please contact administrator");
                    }

                }

            }
        }

        if (context.Request.Form["CallFor"] == "KnowledgeBaseSystem")
        {
            var DateFrom = context.Request.Form["DateFrom"];
            var DateTo = context.Request.Form["DateTo"];
            var Subject = context.Request.Form["Subject"];
            var Details = context.Request.Form["Details"];
            var IsImportant = context.Request.Form["IsImportant"];
            var Savetype = context.Request.Form["Savetype"];
            var Id = context.Request.Form["Id"];
            var GuidenceType = context.Request.Form["GuidenceType"];
            var CreatedBy = context.Request.Form["UserID"];
            if (context.Request.Files.Count > 0)
            {
                HttpFileCollection files = context.Request.Files;
                HttpPostedFile postedFile = context.Request.Files[0];

                for (int i = 0; i < files.Count; i++)
                {
                    string str1 = "SELECT COUNT(*) FROM guidence_for_railwayuser ";
                    var GId1 = Util.GetInt(StockReports.ExecuteScalar(str1));
                    var Gid = GId1 + 1;
                    var pathname = All_LoadData.createDocumentFolder("GudienceDocument", DateFrom + "_" + GuidenceType + "_" + Gid);
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
                    string Url = System.IO.Path.Combine(pathname + "/" + ImgName);
                    var androidUrl = "http://itd.infosysmicro.com/HISDocument/GudienceDocument/" + DateFrom + "_" + GuidenceType + "/" + ImgName;
                    //string urlm="http://itd.infosysmicro.com";
                    //string UrlforMobile = System.IO.Path.Combine(urlm + pathname + "/" + ImgName);
                    if (!File.Exists(Url))
                    {

                        file.SaveAs(Url);

                        Url = Url.Replace("\\", "''");
                        Url = Url.Replace("'", "\\");



                        if (Id == "")
                        {

                            StockReports.ExecuteDML("INSERT INTO guidence_for_railwayuser(ValidFrom,VaildTo,Sub,Message,imageurl_his,imageurl_mobile,isImp,EntryBy,GuidenceType,dtEntry)VALUES('" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "','" + Subject + "','" + Details + "','" + Url + "','" + androidUrl + "','" + IsImportant + "','" + CreatedBy + "','" + GuidenceType + "',NOW())");
                            string json = new JavaScriptSerializer().Serialize(new { Result = 1 });
                            context.Response.StatusCode = (int)HttpStatusCode.OK;
                            context.Response.ContentType = "text/json";
                            context.Response.Write(json);
                            context.Response.End();
                        }
                        else
                        {
                            StockReports.ExecuteDML("update guidence_for_railwayuser set  ValidFrom='" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "',VaildTo='" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "',Sub='" + Subject + "',Message='" + Details + "',imageurl_his='" + Url + "',imageurl_mobile='" + androidUrl + "',isImp='" + IsImportant + "',EntryBy='" + CreatedBy + "',GuidenceType='" + GuidenceType + "',dtEntry=NOW() WHERE Id='" + Id + "'");
                            string json = new JavaScriptSerializer().Serialize(new { Result = 2 });
                            context.Response.StatusCode = (int)HttpStatusCode.OK;
                            context.Response.ContentType = "text/json";
                            context.Response.Write(json);
                            context.Response.End();
                        }




                    }

                    else
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write("Error occurred, Please contact administrator");
                    }

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