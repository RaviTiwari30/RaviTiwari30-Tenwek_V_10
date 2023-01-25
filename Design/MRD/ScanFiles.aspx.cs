using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_ScanFiles : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string type = Request.QueryString["Type"].ToString();
            ViewState["Type"] = type.ToString();
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                string TID = Request.QueryString["TID"].ToString();
                ViewState["TID"] = TID.ToString();
            //}
            string PID = Request.QueryString["PatientID"];
            ViewState["PatientID"] = PID.ToString();
            bindgrd();
        }
        lblMsg.Text = "";
    }

    public void bindgrd()
    {
        string str = "SELECT mdm.Name,concat(mfd.FileID,'#',mfd.DocumentID)ID,ifnull(mfd.URL,''),mfd.FileDetID,if(ifnull(mfd.UploadStatus,'0')='0','false','true')UploadStatus,ifnull(mfd.url,'')URL FROM mrd_file_master mfm INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID INNER JOIN mrd_document_master mdm ON mfd.DocumentID=mdm.DocumentID WHERE PatientID='" + ViewState["PatientID"].ToString() + "' AND TransactionID='" + ViewState["TID"].ToString() + "' and mfd.status='A' ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count <= 0)
        {
            lblMsg.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdUploadDocs.DataSource = null;
            grdUploadDocs.DataBind();
            return;
        }

        grdUploadDocs.DataSource = dt;
        grdUploadDocs.DataBind();
    }

    private string ReturnExtension(string p)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    protected void grdUploadDocs_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "VIEW")
        {
            int index = Util.GetInt(e.CommandArgument);
            GridViewRow row = grdUploadDocs.Rows[index];
            DirectoryInfo[] f1 = null;


            try
            {
                string DocID = ((Label)row.FindControl("lblDocID")).Text.Split('#')[1];
                string ID = ((Label)row.FindControl("lblDocID")).Text.Split('#')[0];
                string PatientID = ViewState["PatientID"].ToString();
                PatientID = PatientID.Replace("/", "_");
                DirectoryInfo MyDir = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\MRDFiles\\" + PatientID);
               
                {
                    string TransactionID = ViewState["TID"].ToString();

                    DirectoryInfo[] f2 = MyDir.GetDirectories(TransactionID.Trim());
                    foreach (DirectoryInfo di in f2)
                    {
                        f1 = di.GetDirectories(ID);
                    }
                    if (f2.Length > 0)
                    {
                        if (f1.Length > 0)
                        {
                            foreach (DirectoryInfo Di in f2)
                            {
                                foreach (DirectoryInfo Dir in f1)
                                {
                                    FileInfo[] files = Dir.GetFiles();
                                    if (files.Length > 0)
                                    {
                                        foreach (FileInfo fl in files)
                                        {
                                            string file = fl.Name.Split('.')[0];
                                            if (file == DocID)
                                            {
                                                string FileName = file + fl.Extension;
                                                string path1 = Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\MRDFiles", Di.Name);
                                                string Path2 = Path.Combine(path1, Dir.Name);
                                                string Path3 = Path.Combine(Path2, FileName);

                                                if (fl.Extension == ".pdf")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "application/pdf";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".jpeg")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "image / jpeg";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".jpg")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "image / jpg";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".txt")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "text/plain";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".doc")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "application/ms-word";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".docx")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "application/ms-word";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".csv")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "application/vnd.ms-excel";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".xlsx")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "application/vnd.ms-excel";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".xls")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "application/vnd.ms-excel";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                                if (fl.Extension == ".gif")
                                                {
                                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                    // Add the file size into the response header
                                                    Response.AddHeader("Content-Length", fl.Length.ToString());

                                                    // Set the ContentType
                                                    Response.ContentType = "image/gif";

                                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                    Response.TransmitFile(fl.FullName);

                                                    // End the response
                                                    Response.Flush();
                                                }
                                            }
                                        }
                                        //List<long> li = new List<long>();
                                    }
                                    else
                                    {
                                        lblMsg.Visible = true;
                                        //lblMsg.Text = "File Not Found..";
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM011','" + lblMsg.ClientID + "');", true);

                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog objErr = new ClassLog();
                objErr.errLog(ex);
            }
        }
        else if (e.CommandName == "UPLOAD")
        {
            int index = Util.GetInt(e.CommandArgument);
            GridViewRow row = grdUploadDocs.Rows[index];

            MySqlConnection con = Util.GetMySqlCon();
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.Text;
            con.Open();
            string File;

            string path = "";
            string upld = "";

            string Doc = "";
            if (((FileUpload)row.FindControl("FileUpload1")).PostedFile.ContentLength == 0)
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM037','" + lblMsg.ClientID + "');", true);
                return;
            }

            try
            {
                //if (((RadioButton)row.FindControl("rbtnupld")).Checked == true)
                //{
                string DocID = ((Label)row.FindControl("lblDocID")).Text.Split('#')[1];
                string ID = ((Label)row.FindControl("lblDocID")).Text.Split('#')[0];
                string Ext = System.IO.Path.GetExtension(((FileUpload)row.FindControl("FileUpload1")).FileName);
                //   DirectoryInfo folder = new DirectoryInfo(@"C:\MRDFiles");

                if (All_LoadData.chkDocumentDrive() == 0)
                {
                    lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                    return;
                }
                string PatientID = ViewState["PatientID"].ToString();
                PatientID = PatientID.Replace("/", "_");
                string TransactionID = ViewState["TID"].ToString();
                var folder = All_LoadData.createDocumentFolder("MRDFiles", PatientID, TransactionID);
                if (folder == null)
                {
                    lblMsg.Text = "Error occurred, Please contact administrator ";
                    return;
                }


                if (Ext != ".pdf" && Ext != ".jpg" && Ext != ".jpeg" && Ext != ".txt" && Ext != ".doc" && Ext != ".docx" && Ext != ".csv" && Ext != ".xls" && Ext != ".xlsx" && Ext != ".gif")
                {
                    lblMsg.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Only pdf, jpg, jpeg, txt, doc, docx, csv, xls, xlsx, gif file will be accepted.',function(){});", true);
                    return;
                }

                if (folder.Exists)
                {
                    //string PatientID = ViewState["PatientID"].ToString();
                    //PatientID = PatientID.Replace("/", "_");

                    DirectoryInfo[] SubFolder = folder.GetDirectories(PatientID);
                    int a = 0;
                    if (SubFolder.Length > 0)
                    {
                        foreach (DirectoryInfo Sub in SubFolder)
                        {
                            if (Sub.Name == PatientID)
                            {
                                DirectoryInfo[] SubFo = Sub.GetDirectories(ID);
                                if (SubFo.Length <= 0)
                                {
                                    Sub.CreateSubdirectory(ID);
                                }
                                foreach (DirectoryInfo s in SubFo)
                                {
                                    FileInfo[] files = s.GetFiles();
                                    foreach (FileInfo fl in files)
                                    {
                                        string fil = fl.Name.Split('.')[0];
                                        if (fil == DocID)
                                        {
                                            fl.Delete();
                                        }
                                    }
                                }
                                string IpFolder = Sub.Name;
                                Doc = DocID + Ext;
                              //  string Ip = Path.Combine(folder.ToString(), IpFolder);
                                File = ID;
                                path = Path.Combine(folder.ToString(), File);

                                upld = Path.Combine(path, Doc);

                                ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                                a = 1;
                                lblMsg.Visible = true;
                                string Text = upld;

                                cmd.CommandText = "update mrd_file_detail set URL=@URL,UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                                cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                                int result = cmd.ExecuteNonQuery();
                                ((Button)row.FindControl("btnView")).Visible = true;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM038','" + lblMsg.ClientID + "');", true);
                                break;
                            }
                        }
                        if (a <= 0)
                        {
                            DirectoryInfo subfolder = folder.CreateSubdirectory(PatientID);
                            subfolder.CreateSubdirectory(ID);
                            DirectoryInfo[] sub = subfolder.GetDirectories();

                            foreach (DirectoryInfo di in sub)
                            {
                                DirectoryInfo[] SubFo = di.GetDirectories(ID);
                                foreach (DirectoryInfo s in SubFo)
                                {
                                    FileInfo[] files = s.GetFiles();
                                    foreach (FileInfo fl in files)
                                    {
                                        string fil = fl.Name.Split('.')[0];
                                        if (fil == DocID)
                                        {
                                            fl.Delete();
                                        }
                                    }
                                }
                                //FileInfo[] files=di.

                                string IpFolder = subfolder.Name;

                                Doc = DocID + Ext;
                               // string Ip = Path.Combine(folder.ToString(), IpFolder);
                                File = ID;

                                path = Path.Combine(folder.ToString(), File);
                                upld = Path.Combine(path, Doc);
                                ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                                lblMsg.Visible = true;
                                string Text = upld;

                                cmd.CommandText = "update mrd_file_detail set URL=@URL,UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                                cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                                int result = cmd.ExecuteNonQuery();

                                ((Button)row.FindControl("btnView")).Visible = true;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert(' File Upload Successfully',function(){});", true);
                            }
                        }
                    }
                    else
                    {
                        // string PatientID = ViewState["PatientID"].ToString();
                        //  PatientID = PatientID.Replace("/", "_");
                        //  DirectoryInfo subfolder = folder.CreateSubdirectory(PatientID);
                        folder.CreateSubdirectory(ID);
                        DirectoryInfo[] sub = folder.GetDirectories();
                        foreach (DirectoryInfo di in sub)
                        {
                            DirectoryInfo[] SubFo = di.GetDirectories(ID);
                            foreach (DirectoryInfo s in SubFo)
                            {
                                FileInfo[] files = s.GetFiles();
                                foreach (FileInfo fl in files)
                                {
                                    string fil = fl.Name.Split('.')[0];
                                    if (fil == DocID)
                                    {
                                        fl.Delete();
                                    }
                                }
                            }
                            string IpFolder = folder.Name;

                            Doc = DocID + Ext;
                            //string Ip = Path.Combine(folder.ToString(), IpFolder);
                            File = ID;
                            path = Path.Combine(folder.ToString(), File);
                            upld = Path.Combine(path, Doc);
                            ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                            lblMsg.Visible = true;
                            string Text = upld;

                            cmd.CommandText = "update mrd_file_detail set URL=@URL,UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                            cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                            int result = cmd.ExecuteNonQuery();
                            ((Button)row.FindControl("btnView")).Visible = true;
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert(' File Uploaded Successfully ', function(){});", true);
                        }
                    }
                }
                else
                {
                    //string PatientID = ViewState["PatientID"].ToString();
                    //PatientID = PatientID.Replace("/", "_");
                    //  DirectoryInfo subfolder = folder.CreateSubdirectory(PatientID);
                    folder.CreateSubdirectory(ID);
                    DirectoryInfo[] sub = folder.GetDirectories();
                    foreach (DirectoryInfo di in sub)
                    {
                        string IpFolder = folder.Name;

                        Doc = DocID + Ext;
                        //string Ip = Path.Combine(folder.ToString(), IpFolder);
                        File = ID;
                        path = Path.Combine(folder.ToString(), File);
                        upld = Path.Combine(path, Doc);
                        ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                        lblMsg.Visible = true;

                        string Text = upld;

                        cmd.CommandText = "update mrd_file_detail set URL=@URL,UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                        cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                        int result = cmd.ExecuteNonQuery();
                        ((Button)row.FindControl("btnView")).Visible = true;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", " alert('File  Upload  Sucessfully ',function(){});", true);
                    }
                }
                string patientid = ViewState["PatientID"].ToString();
                string TID = "";
                //if (ViewState["Type"].ToString() == "IPD")
                //{
                    TID = ViewState["TID"].ToString();
                //   // Response.Redirect("~/Design/MRD/ScanFiles.aspx?PatientID=" + patientid + "&TID=" + ViewState["TID"].ToString() + " &Type=" + ViewState["Type"].ToString(), false);
                //}
                //else
                //{
                //    Response.Redirect("~/Design/MRD/ScanFiles.aspx?PatientID=" + patientid + " &Type=" + ViewState["Type"].ToString(), false);
                //}
                bindgrd();
            }
            catch (Exception ex)
            {
                ClassLog objErr = new ClassLog();
                objErr.errLog(ex);
            }
        }
    }
}