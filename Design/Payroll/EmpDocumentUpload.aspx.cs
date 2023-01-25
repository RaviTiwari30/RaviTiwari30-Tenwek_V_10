using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_EmpDocumentUpload : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        btnSave.Attributes.Add("OnClick", "javascript:return validate()");
        int ID = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        //try
        //{
        //    StringBuilder sb = new StringBuilder();

        //    foreach (GridViewRow grv in EarningGrid.Rows)
        //    {
        //        if (((CheckBox)grv.FindControl("chkSelect")).Checked)
        //        {
        //            string FilePath = ""; string ExistingFile = "";
        //            ///////////
        //             ExistingFile = ((Label)grv.FindControl("lblFilePath")).Text;

        //            string Ext = ((FileUpload)grv.FindControl("ddlupload_doc")).PostedFile.FileName;
        //            if (Ext != "")
        //            {
        //                string Ext1 = ((FileUpload)grv.FindControl("ddlupload_doc")).PostedFile.FileName.ToString().Split('.')[1];
        //                if (Ext1 != "pdf" && Ext1 != "jpg" && Ext1 != "jpeg" && Ext1 != "doc" && Ext1 != "docx" && Ext1 != "gif")
        //                {
        //                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblmsg.ClientID + "');", true);
        //                    return;
        //                }
        //            }
        //            if (Ext == "")
        //                Ext = ExistingFile;

        //            string Filename = ((FileUpload)grv.FindControl("ddlupload_doc")).FileName;
        //            string ExistingFileName = ((Label)grv.FindControl("lblFileName")).Text;
        //            string NewFileName = Guid.NewGuid().ToString() + Ext;
        //            if (Filename == "")
        //                Filename = ExistingFileName;

        //            string IpFolder = "";
        //            string Ip = "";

        //            if (Ext != "")
        //            {
        //                DirectoryInfo folder = new DirectoryInfo(@"C:\Payroll\EmpVerificationDoc");
        //                if (folder.Exists)
        //                {
        //                    DirectoryInfo[] SubFolder = folder.GetDirectories(lblEmpID.Text.Trim());

        //                    if (SubFolder.Length > 0)
        //                    {
        //                        foreach (DirectoryInfo Sub in SubFolder)
        //                        {
        //                            if (Sub.Name == lblEmpID.Text.Trim())
        //                            {
        //                                IpFolder = Sub.Name;
        //                                Ip = Path.Combine(@"C:\Payroll\EmpVerificationDoc", IpFolder);
        //                                FilePath = Path.Combine(Ip, Filename);
        //                                break;
        //                            }
        //                        }
        //                    }
        //                    else
        //                    {
        //                        DirectoryInfo subFold = folder.CreateSubdirectory(lblEmpID.Text.Trim());
        //                        IpFolder = subFold.Name;
        //                        Ip = Path.Combine(@"C:\Payroll\EmpVerificationDoc", IpFolder);
        //                        FilePath = Path.Combine(Ip, Filename);
        //                    }

        //                }
        //                else
        //                {
        //                    DirectoryInfo subfolder = folder.CreateSubdirectory(lblEmpID.Text.Trim());
        //                    DirectoryInfo[] sub = subfolder.GetDirectories();

        //                    IpFolder = subfolder.Name;
        //                    Ip = Path.Combine(@"C:\Payroll\EmpVerificationDoc", IpFolder);
        //                    FilePath = Path.Combine(Ip, Filename);
        //                }
        //            }

        //            if (FilePath != "")
        //            {
        //                string UpLoadFile = FilePath.Replace("\\", "''");
        //                UpLoadFile = UpLoadFile.Replace("'", "\\");
        //                StringBuilder sb1 = new StringBuilder();
        //                if (ExistingFile != "")
        //                {
        //                    sb1.Append("Update pay_EmpVerificationDocument set ISActive=0 where EmployeeID='" + lblEmpID.Text.Trim() + "' and VerificationID= ");
        //                    sb1.Append(" " + ((Label)grv.FindControl("lblVerificationID")).Text + " ");
        //                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
        //                    sb1.Append("Insert into pay_EmpVerificationDocument(EmployeeID,VerificationID,FilePath,FileName,UploadedBy,UploadedDate) values");
        //                    sb1.Append(" ('" + lblEmpID.Text.Trim() + "','" + ((Label)grv.FindControl("lblVerificationID")).Text + "' ,'" + UpLoadFile + "','" + Filename + "',");
        //                    sb1.Append(" '" + Util.GetString(Session["ID"]) + "' ,now())");
        //                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
        //                }
        //                else
        //                {
        //                    sb1.Append("Insert into pay_EmpVerificationDocument(EmployeeID,VerificationID,FilePath,FileName,UploadedBy,UploadedDate) values");
        //                    sb1.Append(" ('" + lblEmpID.Text.Trim() + "','" + ((Label)grv.FindControl("lblVerificationID")).Text + "' ,'" + UpLoadFile + "','" + Filename + "',");
        //                    sb1.Append(" '" + Util.GetString(Session["ID"]) + "' ,now())");
        //                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
        //                }

        //                //Deleting the existing File
        //                FileInfo FileExist = new FileInfo(FilePath);
        //                if (FileExist.Exists)
        //                    FileExist.Delete();

        //                //Saving File at desired location
        //                ((FileUpload)grv.FindControl("ddlupload_doc")).PostedFile.SaveAs(FilePath);

        //            }
        //        }
        //    }

        try
        {
            string Path = "~/Design/Payroll/Documents";
            bool IsExists = System.IO.Directory.Exists(Server.MapPath(Path));
            if (!IsExists)
            {
                System.IO.Directory.CreateDirectory(Server.MapPath(Path));
            }
            Path += "/" + lblEmpID.Text.Trim();
            bool IsLabFolderExists = System.IO.Directory.Exists(Server.MapPath(Path));

            if (!IsLabFolderExists)
            {
                System.IO.Directory.CreateDirectory(Server.MapPath(Path));
            }
            foreach (GridViewRow row in EarningGrid.Rows)
            {
                if (((FileUpload)row.FindControl("ddlupload_doc")).FileName != "")
                {
                    string name = Util.GetString(((Label)row.FindControl("lblName")).Text);
                    string Ext = System.IO.Path.GetExtension(((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.FileName);
                    if (Ext != "")
                    {
                        if (Ext != "pdf" && Ext != "jpg" && Ext != "jpeg" && Ext != "doc" && Ext != "docx" && Ext != "gif")
                        {
                            //   ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblmsg.ClientID + "');", true);
                            lblmsg.Text = "Wrong File Extension Selected of Document " + name;
                            return;
                        }
                    }
                    string ImgName = ((FileUpload)row.FindControl("ddlupload_doc")).FileName;
                    ID = Util.GetInt(((Label)row.FindControl("lblVerificationID")).Text);
                    string newFile = Guid.NewGuid().ToString() + Ext;
                    string Url = System.IO.Path.Combine(Server.MapPath(Path + "/" + ID + newFile));
                    if (!File.Exists(Url))
                    {
                        File.Delete(Url);
                        string dt = StockReports.ExecuteScalar("select FilePath from pay_EmpVerificationDocument where VerificationID='" + ID + "' and EmployeeID='" + lblEmpID.Text.Trim() + "'");
                        if (dt != "")
                        {
                            File.Delete(dt);
                            StockReports.ExecuteDML("update pay_EmpVerificationDocument set Isactive=0  where VerificationID='" + ID + "' and EmployeeID='" + lblEmpID.Text.Trim() + "'");
                        }
                        ((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.SaveAs(Url);
                        Url = Url.Replace("\\", "''");
                        Url = Url.Replace("'", "\\");
                        StockReports.ExecuteDML("INSERT INTO  pay_EmpVerificationDocument(EmployeeID,VerificationID,FileName,FilePath,UploadedBy,UploadedDate)VALUES('" + lblEmpID.Text.Trim() + "'," + ID + ",'" + ImgName + "','" + Url + "', '" + Util.GetString(Session["ID"]) + "' ,now())");
                    }
                }
            }

            tnx.Commit();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            BindDetail(lblEmpID.Text);
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (txtEmpID.Text != "")
        {
            lblmsg.Text = "";
            DataTable dtEmpDetail = StockReports.GetDataTable("select EmployeeID,Name,desi_name from Pay_Employee_master where EmployeeID='" + txtEmpID.Text.Trim() + "'");
            if (dtEmpDetail.Rows.Count > 0)
            {
                lblEmpID.Text = dtEmpDetail.Rows[0]["EmployeeID"].ToString();
                lblName.Text = dtEmpDetail.Rows[0]["Name"].ToString();
                lblDesignation.Text = dtEmpDetail.Rows[0]["desi_name"].ToString();
                BindDetail(lblEmpID.Text);
            }
            else
            {
                lblEmpID.Text = "";
                lblName.Text = "";
                lblDesignation.Text = "";
                EarningGrid.DataSource = null;
                EarningGrid.DataBind();
                pnlhide.Visible = false;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            EarningGrid.DataSource = null;
            EarningGrid.DataBind();
            pnlhide.Visible = false;
        }
    }

    protected void EarningGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            string FilePath = Util.GetString(e.CommandArgument);

            if (FilePath != "")
            {
                FileInfo File = new FileInfo(FilePath);
                string FileName = File.Name;

                if (File.Extension == ".pdf")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/pdf";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
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
                else if (File.Extension == ".jpg")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "image / jpeg";

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
                    lblmsg.Text = "File Type Not Identified...";
                }
            }
        }
    }

    protected void EarningGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gvr = e.Row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            CheckBox gvkchkbox = (CheckBox)gvr.FindControl("chkSelect");
            ClientScript.RegisterArrayDeclaration("gvchks", string.Concat("'", gvkchkbox.ClientID, "'"));
            FileUpload f1 = (FileUpload)gvr.FindControl("ddlupload_doc");
            ClientScript.RegisterArrayDeclaration("gvfls", string.Concat("'", f1.ClientID, "'"));
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatus")).Text != "")
            {
                string status = ((Label)e.Row.FindControl("lblStatus")).Text;

                if (status.ToUpper() == "TRUE")
                    e.Row.BackColor = System.Drawing.Color.LightGreen;
                else
                    e.Row.BackColor = System.Drawing.Color.LightPink;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    private void BindDetail(string EmpID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pev.EmployeeID,Pav.Name,pav.ID,if(ifnull(t.FilePath,'')='','false','true')STATUS,FilePath,FileName,if(ifnull(t.FilePath,'')='','false','true')FileStatus FROM  pay_employee_verification pev INNER JOIN ");
        sb.Append("pay_verificationtypemaster pav ON pev.VID=pav.ID LEFT JOIN ( ");
        sb.Append(" SELECT VerificationID,FilePath,FileName FROM pay_EmpVerificationDocument pv WHERE EmployeeID='" + EmpID.ToString() + "' and IsActive=1");
        sb.Append(" )t ON  pav.id=t.VerificationID WHERE pav.IsActive=1 and pev.EmployeeID='" + EmpID.ToString() + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EarningGrid.DataSource = dt;
            EarningGrid.DataBind();
            pnlhide.Visible = true;
        }
        else
        {
            EarningGrid.DataSource = null;
            EarningGrid.DataBind();
            pnlhide.Visible = false;
        }
    }
}