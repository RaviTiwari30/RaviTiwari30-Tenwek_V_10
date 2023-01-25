using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

public partial class Design_IPD_ViewUploadDocument : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            txtDocumentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtDocumentDate.Attributes.Add("readOnly", "true");
            ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            string TID = ViewState["TID"].ToString();
            PatientDocumentDetail();
            DataTable dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            CalendarExtender1.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
            {
                CalendarExtender1.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
            }
            else
                CalendarExtender1.EndDate = DateTime.Now;
            txtuploadDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            Fromdatecal.EndDate = DateTime.Now.AddDays(0);
            txtuploadDate.Attributes.Add("readOnly", "true");
        }
    }
    private void PatientDocumentDetail()
    {
        DataTable oDT = StockReports.GetDataTable("SELECT odm.`ID`,odm.`Name`,opdd.`ImageName`,opdd.Remark, " +
            " opdd.`URL`, IF(IFNULL(opdd.`URL`,'')='','False','True') AS 'Status',IFNULL(opdd.`ID`,0) AS Visible,DATE_FORMAT(DocumentDate,'%d-%b-%Y')DocumentDate FROM ot_document_master odm " +
            " LEFT JOIN ot_patient_document_detail opdd ON odm.`ID`=opdd.`MasterID` and opdd.TransactionID='" + ViewState["TID"].ToString() + "' And opdd.DocumentDate='" + Util.GetDateTime(txtDocumentDate.Text).ToString("yyyy-MM-dd") + "' where odm.IsActive=1 ");
        if (oDT.Rows.Count > 0)
        {
            grdDocDetails.DataSource = oDT;
            grdDocDetails.DataBind();
        }
        else
        {
            grdDocDetails.DataSource = null;
            grdDocDetails.DataBind();
        }
    }

    protected void grdDocDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblVisible")).Text == "0")
            {
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                ((ImageButton)e.Row.FindControl("imgUpdateRemark")).Visible = false;
            }

        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("lblStatus")).Text;
            if (status.ToUpper() == "TRUE")
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            else
                e.Row.BackColor = System.Drawing.Color.LightPink;
        }
    }

    protected void grdDocDetails_RowCommand(object sender, GridViewCommandEventArgs e)
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
                else if (File.Extension == ".jpg" || File.Extension == ".jpeg" || File.Extension == ".png")
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
                    lblMsg.Text = "File Type Not Identified";
                }
            }
        }
        if (e.CommandName == "UpdateRemark")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            StockReports.ExecuteDML("Update ot_patient_document_detail SET Remark='" + ((TextBox)grdDocDetails.Rows[id].FindControl("txtRemark")).Text + "',UpdatedBy='"+ Session["ID"].ToString() +"',UpdatedDate=NOW() WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND ID='" + ((Label)grdDocDetails.Rows[id].FindControl("lblVisible")).Text + "' And DocumentDate='" + ((Label)grdDocDetails.Rows[id].FindControl("lbluploadDate")).Text + "' ");
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (ServerSideValidation() == true)
        {
            int IsFile = 0;

            foreach (GridViewRow grv in grdDocDetails.Rows)
            {
                if ((((FileUpload)grv.FindControl("ddlupload_doc")).HasFile && (((ImageButton)grv.FindControl("imbView")).Visible = true)))
                    IsFile = 1;
            }

            if (IsFile == 0)
            {
                lblMsg.Text = "Please Select File";
                return;
            }
            if (All_LoadData.chkDocumentDrive() == 0)
            {
                lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                return;
            }
            var pathname = All_LoadData.createDocumentFolder("IPDDocuments", txtuploadDate.Text.Trim(), ViewState["TID"].ToString().Replace("ISHHI", ""));
            if (pathname == null)
            {
                lblMsg.Text = "Error occurred, Please contact administrator ";
                return;
            }
            int ID = 0;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                foreach (GridViewRow row in grdDocDetails.Rows)
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).FileName != "")
                    {
                        string name = Util.GetString(((Label)row.FindControl("lblName")).Text);
                        string Remark = Util.GetString(((TextBox)row.FindControl("txtRemark")).Text);
                        string Exte = System.IO.Path.GetExtension(((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.FileName);
                        if (Exte != "")
                        {
                            if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif" && Exte != ".xlsx" && Exte != ".xls"&& Exte!=".png")
                            {
                                lblMsg.Text = "Wrong File Extension of Selected Document " + name;
                                return;
                            }
                        }
                        string ImgName = ((FileUpload)row.FindControl("ddlupload_doc")).FileName;
                        ID = Util.GetInt(((Label)row.FindControl("lblID")).Text);
                        string fileName = ((Label)row.FindControl("lblName")).Text;
                        
                        string newFile = Guid.NewGuid().ToString() + Exte;
                        string Url = System.IO.Path.Combine(pathname + "\\" + fileName + Exte);

                        if (!File.Exists(Url))
                        {
                            File.Delete(Url);
                            string FilePath = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select url from ot_patient_document_detail where TransactionID='" + ViewState["TID"].ToString() + "' AND MasterID='" + ID + "' And DocumentDate='" + Util.GetDateTime(txtuploadDate.Text).ToString("yyyy-MM-dd") + "' "));
                            if (FilePath != "")
                            {
                                FileInfo FileExist = new FileInfo(FilePath);
                                if (FileExist.Exists)
                                    FileExist.Delete();
                            }
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM ot_patient_document_detail WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND MasterID='" + ID + "' And DocumentDate='" + Util.GetDateTime(txtuploadDate.Text).ToString("yyyy-MM-dd") + "' ");

                            ((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.SaveAs(Url);
                            Url = Url.Replace("\\", "''");
                            Url = Url.Replace("'", "\\");

                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO ot_patient_document_detail(MasterID,TransactionID,ImageName,URL,UploadedBy,DocumentDate,Remark,IpAddress) VALUES (" + ID + ",'" + ViewState["TID"].ToString() + "','" + ImgName + "','" + Url + "','" + Session["ID"].ToString() + "','" + Util.GetDateTime(txtuploadDate.Text).ToString("yyyy-MM-dd") + "','" + Remark + "','"+ HttpContext.Current.Request.UserHostAddress +"')");


                        }
                    }
                }
                Tranx.Commit();
                lblMsg.Text = "Patient File Uploaded Successfully";
                lblMsg.Focus();
                PatientDocumentDetail();
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message;
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

    }

    private bool ServerSideValidation()
    {
        string errorMsg = string.Empty, temp = null;
        bool errorFlag = true;


        HttpFileCollection hfc = Request.Files;
        for (int i = 0; i < hfc.Count; i++)
        {
            HttpPostedFile hpf = hfc[i];
            if (hpf.ContentLength > 0)
            {
                temp = ValidateImage(hpf);
                if (temp != null)
                {
                    errorMsg += GetFileName(hpf.FileName.ToString()) + " has error : " + temp;
                    temp = null;
                }
            }
        }

        if (errorMsg != "")
        {
            lblMsg.Text = errorMsg;
            errorFlag = false;
        }
        return errorFlag;
    }

    private string ValidateImage(HttpPostedFile myFile)
    {
        string msg = null;
        int FileMaxSize = 50000000;
        if (myFile.ContentLength > FileMaxSize)
        {
            msg = msg + "File Size is Too Large.";
        }

        if (!IsValidFile(myFile.FileName))
        {
            msg = msg + "Invalid File Type.";
        }
        return msg;
    }

    private string GetFileName(string filePath)
    {
        FileInfo fi = new FileInfo(filePath);
        return fi.Name;
    }

    private bool IsValidFile(string filePath)
    {
        bool isValid = false;

        string[] fileExtensions = { ".BMP", ".JPG", ".PNG", ".GIF", ".JPEG", ".DOC", ".DOCX", ".PDF",".XLSX",".XLS" };

        for (int i = 0; i < fileExtensions.Length; i++)
        {
            if (filePath.ToUpper().Contains(fileExtensions[i]))
            {
                isValid = true; break;
            }
        }
        return isValid;
    }
    protected void txtDocumentDate_TextChanged(object sender, EventArgs e)
    {
        PatientDocumentDetail();
    }

    protected void rdbDocument_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdbDocument.SelectedItem.Value == "1")
        {
            DataTable oDT = StockReports.GetDataTable("SELECT odm.`ID`,odm.`Name`,opdd.`ImageName`,opdd.Remark, " +
                        " opdd.`URL`, IF(IFNULL(opdd.`URL`,'')='','False','True') AS 'Status',IFNULL(opdd.`ID`,0) AS Visible,DATE_FORMAT(DocumentDate,'%d-%b-%Y')DocumentDate FROM ot_document_master odm " +
                        " Inner JOIN ot_patient_document_detail opdd ON odm.`ID`=opdd.`MasterID` and opdd.TransactionID='" + ViewState["TID"].ToString() + "'  where odm.IsActive=1 Order by DocumentDate Desc ");
            if (oDT.Rows.Count > 0)
            {
                grdDocDetails.DataSource = oDT;
                grdDocDetails.DataBind();
                btnSave.Visible = false;
                txtuploadDate.Visible = false;
                txtDocumentDate.Enabled = false;
            }
            else
            {
                grdDocDetails.DataSource = null;
                grdDocDetails.DataBind();
                btnSave.Visible = false;
                txtuploadDate.Visible = false;
                txtDocumentDate.Enabled = false;
            }
        }
        else
        {
            PatientDocumentDetail();
            btnSave.Visible = true;
            txtuploadDate.Visible = true;
            txtDocumentDate.Enabled = true;
        }
    }
}