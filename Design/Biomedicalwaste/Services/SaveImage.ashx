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
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            HttpPostedFile postedFile = context.Request.Files[0];
            var Bagname = context.Request.Form["Bagname"];
            var BagColor = context.Request.Form["BagColor"];
            var Description = context.Request.Form["Description"];
            var IsActive = context.Request.Form["IsActive"];
            var Savetype = context.Request.Form["Savetype"];
            var BagId = context.Request.Form["BagId"];
            //System.IO.Stream fs = postedFile.InputStream;
            var CreatedBy = context.Request.Form["UserID"];
            //System.IO.BinaryReader br = new System.IO.BinaryReader(fs);
            //Byte[] bytes = br.ReadBytes((Int32)fs.Length);
            //string base64image = Convert.ToBase64String(bytes, 0, bytes.Length);
            for (int i = 0; i < files.Count; i++)
            {
               
                var pathname = All_LoadData.createDocumentFolder("BagImage", Bagname);
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
                string Url = System.IO.Path.Combine(pathname + "/" + Bagname + Exte);


                string str = "SELECT COUNT(*) FROM bio_InsertBagMaster WHERE isactive=1 and BagName = '" + Bagname + "' ";
                if (BagId != "")
                {
                    str += " and Id <> '" + BagId + "' ";
                }

                var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
                if (IsExist > 0)
                {
                    string json = new JavaScriptSerializer().Serialize(new { Result = 0 });
                    context.Response.StatusCode = (int)HttpStatusCode.OK;
                    context.Response.ContentType = "text/json";
                    context.Response.Write(json);
                    context.Response.End();
                }
                else if (IsExist == 0)
                {
                    if (!File.Exists(Url))
                    {

                        file.SaveAs(Url);
                        Url = Url.Replace("\\", "''");
                        Url = Url.Replace("'", "\\");


                        //StockReports.ExecuteDML("INSERT INTO pay_Employee_documentdetails(EmployeeId,DocumentID,FileName,Url,UploadBy,UploadDate)VALUES('" + EmployeeId + "','" + DocumentId + "','" + ImgName + "','" + Url + "','" + UploadBy + "',NOW())");
                        if (BagId == "")
                        {
                            StockReports.ExecuteDML("INSERT INTO bio_InsertBagMaster(BagName,BagColour,Description,Image,IsActive,CreatedBy,CreatedDateTime)VALUES('" + Bagname + "','" + BagColor + "','" + Description + "','" + Url + "','" + IsActive + "','" + CreatedBy + "',NOW())");
                            string json = new JavaScriptSerializer().Serialize(new { Result = 1 });
                            context.Response.StatusCode = (int)HttpStatusCode.OK;
                            context.Response.ContentType = "text/json";
                            context.Response.Write(json);
                            context.Response.End();
                        }
                        else
                        {
                            StockReports.ExecuteDML("update bio_InsertBagMaster set  BagName='" + Bagname + "',BagColour='" + BagColor + "',Description='" + Description + "',Image='" + Url + "',IsActive='" + IsActive + "',UpdatedBy='" + CreatedBy + "',CreatedDateTime=NOW() WHERE Id='" + BagId + "'");
                            string json = new JavaScriptSerializer().Serialize(new { Result = 2 });
                            context.Response.StatusCode = (int)HttpStatusCode.OK;
                            context.Response.ContentType = "text/json";
                            context.Response.Write(json);
                            context.Response.End();
                        }



                        //context.Response.Write("File(s) Uploaded Successfully!");
                    }
                }
                else
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("Error occurred, Please contact administrator");
                }

            }
            //for (int i = 0; i < files.Count; i++)
            //{
            //    //StockReports.ExecuteDML("INSERT INTO bio_InsertBagMaster(BagName,BagColour,Image,Description,IsActive,CreatedBy,CreatedDateTime)VALUES('" + Bagname + "','" + BagColor + "','" + string.Format("data:image/jpg;base64,{0}", base64image) + "','" + Description + "','" + IsActive + "','" + CreatedBy + "',NOW())");
            //    //string json = new JavaScriptSerializer().Serialize(new { Result = 1 });
            //    //context.Response.StatusCode = (int)HttpStatusCode.OK;
            //    //context.Response.ContentType = "text/json";
            //    //context.Response.Write(json);
            //    //context.Response.End();
            //    //context.Response.Write(" Record Save Successfully!");
            //}
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