using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ViewFile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string fileUrl = Request.QueryString["FileUrl"].ToString();
            string extension = Request.QueryString["Extension"].ToString();
            string documenttype = Util.GetString(Request.QueryString["DocumentType"]);
            string url = string.Empty;

            url = string.Concat(Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, "\\", Resources.Resource.DocumentFolderName, fileUrl.Replace("%20", ""));

            if (extension == "pdf")
            {
                img.Visible = false;

                if (File.Exists(url))
                {
                    FileInfo Filetemp = new FileInfo(url);
                    string FileName = Filetemp.Name;
                    Response.AddHeader("Content-Disposition", "inline; filename=" + fileUrl);
                    Response.AddHeader("Content-Length", Filetemp.Length.ToString());
                    Response.ContentType = "application/pdf";
                    Response.TransmitFile(Filetemp.FullName);
                    Response.Flush();
                }
                else
                {
                    lblmsg.Text = "File Not Exist";
                }
            }
            if (extension == "jpg")
            {
                if (File.Exists(Server.MapPath("~/Uploaded Document") + fileUrl.Replace("//", "\\").Replace("/", "\\")))
                {
                    img.Visible = true;
                    img.ImageUrl = "~/Uploaded Document" + fileUrl.Replace("//", "\\").Replace("/", "\\");
                }
                else
                {
                    img.Visible = false;
                    lblmsg.Text = "File Not Exist";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = ex.Message;
        }
    }

}