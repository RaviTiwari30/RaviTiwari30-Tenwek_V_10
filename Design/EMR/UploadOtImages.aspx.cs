using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;
using System.Web;
using System.Web.UI;

public partial class Design_EMR_UploadOtImages : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int DefaultWidth = Util.GetInt(txtWidth.Text.Trim());
        int DefaultHeight = Util.GetInt(txtHeight.Text.Trim());
        int pxlw = Convert.ToInt32(DefaultWidth * 37.8);
        int pxlh = Convert.ToInt32(DefaultHeight * 37.8);
     
        Random ran = new Random();
        string Ext = System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName.ToString());
            if (!(Ext.EndsWith("jpg") || Ext.EndsWith("JPEG")))
            {
                lblMsg.Text = "Please Upload only jpg Image";
                return;
            }
            string fileName = "";
            //fileName = FileUpload1.FileName;
            fileName = DateTime.Now.ToString("yyyyMMdd_HHmmss");
            fileName += ran.Next().ToString();
            fileName += ".jpg";

            if (All_LoadData.chkDocumentDrive() == 0)
            {
                lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                return;
            }
            var pathname = All_LoadData.createDocumentFolder("OtImages", ViewState["TID"].ToString(), ViewState["TID"].ToString());
            if (pathname == null)
            {
                lblMsg.Text = "Error occurred, Please contact administrator ";
                return;
            }
            if (fileName != "")
            {
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();

                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

                try
                {  
                    if (FileUpload1.HasFile)
                    {
                       // string ss = Server.MapPath(@"..\EMR\OtImages\" + ViewState["TID"].ToString() + "\\");
                        
                        int thumbHeight;
                        int srcWidth;
                        int srcHeight;
                        int thumbWidth;
                        System.Drawing.Image image;
                        //System.Drawing.Image image1;
                        System.Drawing.Graphics gr;
                        System.Drawing.Rectangle rectDestination;
                        Bitmap bmp;
                        fileName = Server.HtmlEncode(fileName);
                        image = System.Drawing.Image.FromStream(FileUpload1.FileContent);

                        srcWidth = image.Width;

                        srcHeight = image.Height;

                        if (srcWidth > pxlw)
                        {
                            thumbWidth = pxlw;
                            thumbHeight = (srcHeight * thumbWidth) / srcWidth;
                        }

                        if (srcHeight > srcWidth & srcHeight > pxlh)
                        {
                            thumbHeight = pxlh;
                            thumbWidth = (srcWidth * thumbHeight) / srcHeight;
                        }
                        else if (srcWidth > srcHeight & srcWidth > pxlw)
                        {
                            thumbWidth = pxlw;
                            thumbHeight = (thumbWidth * srcHeight) / srcWidth;
                        }
                        else
                        {
                            thumbHeight = srcHeight;
                            thumbWidth = srcWidth;
                        }
                        string imgurl;
                        bmp = new Bitmap(thumbWidth, thumbHeight);
                        gr = System.Drawing.Graphics.FromImage(bmp);
                        gr.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                        gr.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                        gr.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                        rectDestination = new System.Drawing.Rectangle(0, 0, thumbWidth, thumbHeight);
                        gr.DrawImage(image, rectDestination, 0, 0, srcWidth, srcHeight, GraphicsUnit.Pixel);

                        imgurl = pathname + "" + fileName;                        
                        bmp.Save(imgurl, System.Drawing.Imaging.ImageFormat.Jpeg);
                        imgurl = imgurl.Replace("\\", "''");
                        imgurl = imgurl.Replace("'", "\\");
                        
                        bmp.Dispose();
                        image.Dispose();

                        int sno = Util.GetInt(StockReports.ExecuteScalar("select max(Priority) from emr_ipd_details_image where TransactionID='" + ViewState["TID"].ToString() + "'"));
                        sno += 1;
                        string str = "insert into emr_ipd_details_image(TransactionID,OtImage,OtImageNarration,UserID,priority,PhotoWidth,PhotoHeight,URL) values(";
                        str += "'" + ViewState["TID"].ToString() + "','" + fileName + "','" + txtNarration.Text + "','" + Session["ID"].ToString() + "'," + sno.ToString() + ",'" + txtWidth.Text.Trim() + "px" + "','" + txtHeight.Text.Trim() + "px" + "','" + imgurl + "')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

                        tnx.Commit();

                        lblMsg.Text = " Record Saved Successfully";
                    }

                }

                catch (Exception ex)
                {
                    lblMsg.Text = "Error occurred, Please contact administrator";
                    tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    
                    return;
                 
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
            {
                lblMsg.Text = "Please Select a image file..";
                return;
            }

            BindOTImages();       
        
    }

    protected void grvImages_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        grvImages.EditIndex = -1;
        BindOTImages();
    }

    protected void grvImages_RowCommand(object sender, GridViewCommandEventArgs e)
    {
         if (e.CommandName == "AView")
        {
            string FilePath = Util.GetString(e.CommandArgument);
            if (FilePath != "")
            {
                FileInfo File = new FileInfo(FilePath);
                string FileName = File.Name;
                if (File.Extension == ".pdf" || File.Extension == ".PDF")
                {
                   /* Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/pdf";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush(); */

                    Session["FileUrl"] = FilePath;
                    Session["Extension"] = File.Extension;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../OPD/ViewFile.aspx');", true);
                }
                else if (File.Extension == ".jpg" || File.Extension == ".JPG" || File.Extension == ".jpeg" || File.Extension == ".JPEG")
                {
                   /* Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "image / jpeg";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush(); */

                    Session["FileUrl"] = FilePath;
                    Session["Extension"] = File.Extension;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../OPD/ViewFile.aspx');", true);                    
                }
                else if (File.Extension == ".xlsx")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/vnd.xlsx";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }               
                else if (File.Extension == ".txt")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "text/plain";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else if (File.Extension == ".htm")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "text/html";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else if (File.Extension == ".html")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "text/html";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else if (File.Extension == ".doc")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/ms-word";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else if (File.Extension == ".docx")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/ms-word";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else if (File.Extension == ".csv")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/vnd.ms-excel";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else if (File.Extension == ".gif")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "image/gif";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else
                {
                    lblMsg.Text = "File Type Not Identified";
                }
            }
        }
        if (e.CommandName == "imgRemove")
        {

            var dirPath = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\OtImages" + "\\" + ViewState["TID"].ToString() + "\\" + e.CommandArgument.ToString());

            StockReports.ExecuteDML("delete from emr_ipd_details_image where TransactionID='" + ViewState["TID"].ToString() + "' and otimage='" + e.CommandArgument.ToString() + "'");
            File.Delete(dirPath.ToString());
            lblMsg.Text = "Image Deleted Successfully";
            BindOTImages();
        }
    }

    protected void grvImages_RowEditing(object sender, GridViewEditEventArgs e)
    {
        grvImages.EditIndex = e.NewEditIndex;
        BindOTImages();
    }
    protected void grvImages_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("Select Priority from emr_ipd_details_image where ID='" + ((Label)grvImages.Rows[e.RowIndex].FindControl("lblID")).Text +"' "));
        StringBuilder sb = new StringBuilder();
        sb.Append(" update emr_ipd_details_image ");
        sb.Append("set OtImageNarration='" + ((TextBox)grvImages.Rows[e.RowIndex].FindControl("txtNarration")).Text + "',");
        sb.Append("Priority=" + ((TextBox)grvImages.Rows[e.RowIndex].FindControl("txtPriority")).Text + ", ");
        sb.Append("PhotoWidth='" + ((TextBox)grvImages.Rows[e.RowIndex].FindControl("txtwidth")).Text +"px"+ "', ");
        sb.Append("PhotoHeight='" + ((TextBox)grvImages.Rows[e.RowIndex].FindControl("txtHeight")).Text +"px"+"' ");
        sb.Append(" where id=" + ((Label)grvImages.Rows[e.RowIndex].FindControl("lblID")).Text);
        StockReports.ExecuteDML(sb.ToString());
        grvImages.EditIndex = -1;
        BindOTImages();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState.Add("TID", TID);
            BindOTImages();
        }
        lblMsg.Text = "";
    }

    private void BindOTImages()
    {
        //var dirPath = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\OtImages" );
        grvImages.DataSource = StockReports.GetDataTable("SELECT id,TransactionID,OtImage,OtImageNarration,(SELECT CONCAT(em.Title,' ',em.Name)FROM employee_master em WHERE em.employeeID=UserID)USER,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate,Priority,URL as imgUrl,PhotoWidth,PhotoHeight  FROM emr_ipd_details_image where TransactionID='" + ViewState["TID"].ToString() + "' order by Priority asc");
        grvImages.DataBind();
    }
}