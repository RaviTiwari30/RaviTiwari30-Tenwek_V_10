using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

public partial class JavaScript_uploadify_FileUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      

        try
        {
            
           HttpFileCollection files = HttpContext.Current.Request.Files;
            HttpPostedFile uploadfile = files["Filedata"];
            bool needcompress = NeedCompressImage(uploadfile);
            string FileName =  uploadfile.FileName;

            string name = Request.QueryString["name"].ToString();
            string foldername = "";
            if (Util.GetString(Request.QueryString["type"]) == "")
            {
                foldername = "HistoUploads";
            }
            else
            {
                foldername = "Uploads";
            }
            string filelocation = DateTime.Now.Year + "\\" + DateTime.Now.ToString("MMM") + "\\" + name + "_" + FileName;
            string Path = "~/" + foldername + "/" + DateTime.Now.Year + "/" + DateTime.Now.ToString("MMM"); // your code goes here
                bool IsExists = System.IO.Directory.Exists(Server.MapPath(Path));

                if (!IsExists)
                {
                    System.IO.Directory.CreateDirectory(Server.MapPath(Path));
                }
                string Img = Path + "/" + name + "_" + FileName;
                if (needcompress)
                {
                    using (System.Drawing.Image myImage =
               System.Drawing.Image.FromStream(uploadfile.InputStream))
                    {
                        save(myImage, Server.MapPath(Img), 30, uploadfile);
                    }
 
                }
                else
                {
                    uploadfile.SaveAs(Server.MapPath(Img));
                }
                if (foldername.Trim() == "Uploads")
                {
                    byte[] UploadFileButes = System.IO.File.ReadAllBytes(Server.MapPath(Img));
                    //ReportServerFileUpload.FileUploadedService FlReportService = new ReportServerFileUpload.FileUploadedService();
                    //FlReportService.UploadFile(UploadFileButes, name + "_" + FileName, foldername + "/" + DateTime.Now.Year + "/" + DateTime.Now.ToString("MMM"));
                    Session["CurrentFileUploadedLocation"] = foldername + "/" + DateTime.Now.Year + "/" + DateTime.Now.ToString("MMM");
                }
            

                Session["WorkingImage"] = filelocation;
                Session["filename"] = name + "_" + FileName;
   
        }
        catch (Exception ex)
        {

        }

    }
    public bool NeedCompressImage(HttpPostedFile uploadfile)
    {
        using (System.Drawing.Image myImage = System.Drawing.Image.FromStream(uploadfile.InputStream))
        {
            if (myImage.Height > 320 || myImage.Width > 240)
            {
                //save(myImage,path, 60);
                return true;
            }
            else
            {
                return false;
            }

        }
    }

    private void save(System.Drawing.Image myImage, string path, int quality, HttpPostedFile uploadfile)
        {
            System.Drawing.Image img = CompressImage(myImage, uploadfile);
            ////Setting the quality of the picture
            EncoderParameter qualityParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);
            ////Seting the format to save
            ImageCodecInfo imageCodec = GetImageCoeInfo("image/jpeg");
            ////Used to contain the poarameters of the quality
            EncoderParameters parameters = new EncoderParameters(1); 
            parameters.Param[0] = qualityParam;
            ////Used to save the image to a  given path
            img.Save(path, imageCodec, parameters);
        }

    private ImageCodecInfo GetImageCoeInfo(string mimeType)
    {
        ImageCodecInfo[] codes = ImageCodecInfo.GetImageEncoders();
        for (int i = 0; i < codes.Length; i++)
        {
            if (codes[i].MimeType == mimeType)
            {
                return codes[i];
            }
        }
        return null;
    } 

    private System.Drawing.Image CompressImage(System.Drawing.Image myImage,HttpPostedFile uploadfile)
    {
        if (myImage != null)
        {
            int Width = myImage.Width;
            int Height = myImage.Height;
            if (myImage.Width > 700)
            {
                 Width = 700;
              
            }
            if (myImage.Height > 450)
            {
                Height = 450;

            }
          
            Bitmap newBitmap = new Bitmap(Width, Height, PixelFormat.Format24bppRgb);
            newBitmap = new System.Drawing.Bitmap(myImage);
            //newBitmap.SetResolution(80, 80);
            return newBitmap.GetThumbnailImage(Width, Height, null, IntPtr.Zero);
        }
        else
        {
            throw new Exception("Please provide bitmap");
        }
    }

}
