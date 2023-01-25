using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

public partial class Design_OPD_PatientDocumetnDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.getCurrentDate(txtToDate, txtfromDate);
            All_LoadData.bindDoctor(ddlDoctor, "All");
            ViewState["UserID"] = Session["ID"].ToString();
            pnldetails.Visible = false;
            divPatientDoc.Visible = false;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    protected void Search()
    {
        string DocID = "";
        lblMsg.Text = "";
        if (ddlDoctor.SelectedItem.Text != "All")
        {
            DocID = ddlDoctor.SelectedItem.Value;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT TransactionID,PatientID,App_ID,AppNo,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
        sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%Y')AppDate,IsConform,IsReschedule, IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%Y %l:%i %p')ConformDate,ifnull(LedgerTnxNo,'')LedgerTnxNo,CONCAT(DATE,' ',TIME)AppDateTime,ContactNo,'' Status FROM appointment app ");
        sb.Append(" where Date>='" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" and Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' and app.IsCancel=0");

        if (DocID != "")
        {
            sb.Append(" and DoctorID='" + DocID + "'");
        }
        if (txtAppNo.Text != "")
        {
            sb.Append(" and AppNo='" + txtAppNo.Text + "'");
        }

        if (txtMrno.Text != "")
        {
            sb.Append(" and PatientID='" + txtMrno.Text + "' ");
        }
        if (txtPname.Text != "")
        {
            sb.Append(" and Pname like '" + txtPname.Text + "%' ");
        }
        sb.Append(" and IsConform=1");

        sb.Append("  ORDER BY DATE,TIME,AppNo");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            grdAppointment.DataSource = dtSearch;
            grdAppointment.DataBind();
            pnldetails.Visible = true;
        }
        else
        {
            grdAppointment.DataSource = "";
            grdAppointment.DataBind();
            pnldetails.Visible = false;
            lblMsg.Text = "Record Not Found";
        }
    }

    protected void grdAppointment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "AView")
        {
            divPatientDoc.Visible = true;
            lblAppID.Text = e.CommandArgument.ToString().Split('#')[0];
            lblPatientName.Text = e.CommandArgument.ToString().Split('#')[1];
            lblAppointmentNo.Text = e.CommandArgument.ToString().Split('#')[2];
            lblAppdate.Text = e.CommandArgument.ToString().Split('#')[3];
            PatientDocument_Detail();
        }
    }

    protected void PatientDocument_Detail()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM( ");
        sb.Append("   SELECT rm.Formid,Formname,IFNULL(pd.ID,0)Visible,IF(IFNULL(pd.url,'')='','false','true')STATUS,pd.Remark, ");
        sb.Append(" pd.Url,ImageName, IF(IFNULL(pd.Url,'')='','false','true')FileStatus, rmd.Name,rmd.ID FROM research_master rm  INNER JOIN research_master_detail rmd     ON rmd.formid = rm.FormID ");
        sb.Append("  LEFT JOIN Patient_DocumentDetails pd  ON pd.DocumentID=rmd.ID AND pd.appid='" + lblAppID.Text + "' ");
        sb.Append("  WHERE rm.IsActive=1  AND rm.Isresearch=0");
        sb.Append(" UNION ALL ");
        sb.Append("  SELECT rm.Formid,Rm.FormName");
        sb.Append(",IFNULL(pd.ID,0)Visible,IF(IFNULL(pd.url,'')='','false','true')STATUS,pd.Remark, ");
        sb.Append(" pd.Url,ImageName, IF(IFNULL(pd.Url,'')='','false','true')FileStatus,rmd.Name,rmd.ID FROM research_master  rm INNER JOIN research_master_detail rmd ON rmd.formid=rm.FormID");
        sb.Append("  INNER JOIN patient_researchdetail pr ON  pr.ResearchID=rmd.FormID AND pr.appid='" + lblAppID.Text + "' ");
        sb.Append("  LEFT JOIN Patient_DocumentDetails ");
        sb.Append(" pd ON pd.DocumentID=rmd.ID AND pd.appid='" + lblAppID.Text + "' WHERE rm.IsActive=1  AND rm.Isresearch=1");
        sb.Append(" )t ");
        DataTable dtDetail = StockReports.GetDataTable(sb.ToString());
        if (dtDetail.Rows.Count > 0)
        {
            grdDocDetails.DataSource = dtDetail;
            grdDocDetails.DataBind();
        }
        else
        {
            grdDocDetails.DataSource = "";
            grdDocDetails.DataBind();
            divPatientDoc.Visible = false;
        }
    }

    protected void grdDocDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gvr = e.Row;

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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //   if (ServerSideValidation() == true)
        //    {
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
        var pathname = All_LoadData.createDocumentFolder("OPDDocument", lblAppID.Text.Trim());
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
                        if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif" && Exte != ".txt" && Exte != ".JPG")
                        {
                            lblMsg.Text = "Wrong File Extension of Selected Document " + name;
                            return;
                        }
                    }
                    string ImgName = ((FileUpload)row.FindControl("ddlupload_doc")).FileName;
                    ID = Util.GetInt(((Label)row.FindControl("lblID")).Text);
                    string newFile = Guid.NewGuid().ToString() + Exte;
                    //  string Url = System.IO.Path.Combine(directory + "\\" + ID +"#"+ newFile);
                    string Url = System.IO.Path.Combine(pathname + "\\" + name + Exte);

                    //Check For File Already Exit for this Patient if Yes then delete file
                    if (!File.Exists(Url))
                    {
                        int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(*) FROM Patient_DocumentDetails WHERE DocumentID='" + ID + "' AND AppID='" + lblAppID.Text.Trim() + "' "));
                        if (count > 0)
                        {
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete FROM Patient_DocumentDetails where DocumentID='" + ID + "' AND AppID='" + lblAppID.Text.Trim() + "' ");
                        }
                        ((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.SaveAs(Url);
                        Url = Url.Replace("\\", "''");
                        Url = Url.Replace("'", "\\");
                        int result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO Patient_DocumentDetails(AppID,DocumentID,ImageName,Url,UploadBy,UploadDate,Remark)VALUES('" + lblAppID.Text.Trim() + "'," + ID + ",'" + ImgName + "','" + Url + "','" + ViewState["UserID"].ToString() + "','" + System.DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "','" + Remark + "') ");
                        if (result > 0)
                        {
                            // File.Delete(Url);
                        }
                    }
                }
            }
            Tranx.Commit();
            lblMsg.Text = "Patient File Uploaded Successfully";
            lblMsg.Focus();
            PatientDocument_Detail();
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
                else if (File.Extension == ".jpg" || File.Extension == ".JPG")
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
            StockReports.ExecuteDML("Update Patient_DocumentDetails SET Remark='" + ((TextBox)grdDocDetails.Rows[id].FindControl("txtRemark")).Text + "' WHERE AppID='" + lblAppID.Text.Trim() + "' AND DocumentID='" + ((Label)grdDocDetails.Rows[id].FindControl("lblID")).Text + "' ");
        }
    }

    private string GetFileName(string filePath)
    {
        FileInfo fi = new FileInfo(filePath);
        return fi.Name;
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
        int FileMaxSize = 204800;
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

    private bool IsValidFile(string filePath)
    {
        bool isValid = false;

        string[] fileExtensions = { ".BMP", ".JPG", ".PNG", ".GIF", ".JPEG", ".DOC", ".DOCX", ".PDF" };

        for (int i = 0; i < fileExtensions.Length; i++)
        {
            if (filePath.ToUpper().Contains(fileExtensions[i]))
            {
                isValid = true; break;
            }
        }
        return isValid;
    }

    private string GetFileExtension(string FileName)
    {
        char saperator = '.';
        string[] temp = FileName.Split(saperator);

        return "." + temp[1].ToString();
    }

    private string GetUniqueKey()
    {
        int maxSize = 8;
        char[] chars = new char[62];
        string a;

        a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";

        chars = a.ToCharArray();

        int size = maxSize;
        byte[] data = new byte[1];

        RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider();

        crypto.GetNonZeroBytes(data);
        size = maxSize;
        data = new byte[size];
        crypto.GetNonZeroBytes(data);
        StringBuilder result = new StringBuilder(size);

        foreach (byte b in data)
        {
            result.Append(chars[b % (chars.Length - 1)]);
        }

        return result.ToString();
    }
}