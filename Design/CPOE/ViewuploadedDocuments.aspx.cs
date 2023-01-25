using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_ViewuploadedDocuments : System.Web.UI.Page
{
    private MySqlConnection con;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["IsViewable"] == null)
            {
                string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
               // string msg = "File Has Been Closed...";
                if (IsDone == "1")
                {
                    btnSave.Visible = false;
                }
            }
            if (Request.QueryString["TransactionID"] == null)
            {
                ViewState["TID"] = Request.QueryString["TID"].ToString();
                ViewState["PID"] = Request.QueryString["PID"].ToString();
            }
            else
            {
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["PID"] = Request.QueryString["PatientID"].ToString();
            }
            ViewState["App_ID"] = Request.QueryString["App_ID"].ToString();
            BindDocument();
            BindDocumentName();
        }
    }

    private void BindDocument()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT rm.Formid,Formname,rmd.Name,IFNULL(pd.ID,0)Visible,IF(IFNULL(pd.url,'')='','false','true')STATUS,pd.Remark, ");
        sb.Append("  pd.Url,ImageName, IF(IFNULL(pd.Url,'')='','false','true')FileStatus,DATE_FORMAT(pd.UploadDate,'%d-%b-%y')Upload_Date,DATE_FORMAT(pd.UploadDate,'%H:%i %p')Upload_Time FROM research_master rm    INNER JOIN research_master_detail rmd    ON rmd.formid = rm.FormID ");
        sb.Append("  INNER JOIN Patient_DocumentDetails pd  ON pd.DocumentID=rmd.ID INNER JOIN appointment app ON app.App_ID =pd.AppID ");
        sb.Append("  WHERE rm.IsActive=1  AND rm.Isresearch=0 AND app.PatientID='" + ViewState["PID"].ToString() + "' ");
        sb.Append(" UNION ALL ");
        sb.Append("  SELECT rm.Formid,Rm.FormName,rmd.Name");
        sb.Append(" ,IFNULL(pd.ID,0)Visible,IF(IFNULL(pd.url,'')='','false','true')STATUS,pd.Remark, ");
        sb.Append(" pd.Url,ImageName, IF(IFNULL(pd.Url,'')='','false','true')FileStatus,DATE_FORMAT(pd.UploadDate,'%d-%b-%y')Upload_Date,DATE_FORMAT(pd.UploadDate,'%H:%i %p')Upload_Time FROM research_master  rm INNER JOIN research_master_detail rmd    ON rmd.formid = rm.FormID");
        sb.Append("  INNER JOIN patient_researchdetail pr ON  pr.ResearchID=rmd.ID  ");
        sb.Append("  INNER JOIN Patient_DocumentDetails ");
        sb.Append(" pd ON pd.DocumentID=rmd.ID INNER JOIN appointment app ON app.App_ID =pd.AppID WHERE rm.IsActive=1  AND rm.Isresearch=1 AND app.PatientID='" + ViewState["PID"].ToString() + "' Order by Upload_Date,Upload_Time Desc");
        DataTable dtDetail = StockReports.GetDataTable(sb.ToString());
        if (dtDetail.Rows.Count > 0)
        {
            lblMsg.Text = "";
            grdDocDetails.DataSource = dtDetail;
            grdDocDetails.DataBind();
        }
        else
        {
            grdDocDetails.DataSource = "";
            grdDocDetails.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
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
                    lblMsg.Text = "File Type Not Identified";
                }
            }
        }
    }

    protected void grdDocDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int IsFile = 0;

        foreach (GridViewRow grv in GridView1.Rows)
        {
            if ((((FileUpload)grv.FindControl("ddlupload_doc")).HasFile))
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
        var pathname = All_LoadData.createDocumentFolder("OPDDocument", ViewState["App_ID"].ToString());
        if (pathname == null)
        {
            lblMsg.Text = "Error occurred, Please contact administrator ";
            return;
        }
        int ID = 0;
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            //DataTable dtRefNo=StockReports.GetDataTable("Select Employee_ID from pay_offerletter_new where ")
            foreach (GridViewRow row in GridView1.Rows)
            {
                if (((FileUpload)row.FindControl("ddlupload_doc")).FileName != "")
                {
                    string name = Util.GetString(((Label)row.FindControl("lblName")).Text);
                    string Remark = Util.GetString(((TextBox)row.FindControl("txtRemarkDocument")).Text);
                    string Exte = System.IO.Path.GetExtension(((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.FileName);
                    if (Exte != "")
                    {
                        if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif" && Exte != ".txt" && Exte != ".xlsx")
                        {
                            lblMsg.Text = "Wrong File Extension of Selected Document " + name;
                            return;
                        }
                    }
                    string ImgName = ((FileUpload)row.FindControl("ddlupload_doc")).FileName;
                    ID = Util.GetInt(((Label)row.FindControl("lblID")).Text);
                    string newFile = Guid.NewGuid().ToString() + Exte;
                    string Url = System.IO.Path.Combine(pathname + "/" + ID + newFile);
                    
                    if (!File.Exists(Url))
                    {
                        File.Delete(Url);
                        DataTable dt = StockReports.GetDataTable("select * from Patient_DocumentDetails where DocumentID='" + ID + "' and AppID='" + ViewState["App_ID"].ToString() + "'");
                        if (dt.Rows.Count > 0)
                        {
                            StockReports.ExecuteDML("Delete from Patient_DocumentDetails where DocumentID='" + ID + "' and AppID='" + ViewState["App_ID"].ToString() + "'");
                        }
                        ((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.SaveAs(Url);
                        Url = Url.Replace("\\", "''");
                        Url = Url.Replace("'", "\\");
                        StockReports.ExecuteDML("INSERT INTO Patient_DocumentDetails(AppID,DocumentID,ImageName,Url,UploadBy,UploadDate,Remark)VALUES('" + ViewState["App_ID"].ToString() + "'," + ID + ",'" + ImgName + "','" + Url + "','" + Session["ID"].ToString() + "','" + System.DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "','" + Remark + "')");
                    }
                }
            }
            Tranx.Commit();
            lblMsg.Text = "Patient File Uploaded Successfully";
            lblMsg.Focus();
            BindDocument();
            BindDocumentName();
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

    private void BindDocumentName()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM( ");
        sb.Append("   SELECT rm.Formid,Formname,IFNULL(pd.ID,0)Visible,IF(IFNULL(pd.url,'')='','false','true')STATUS,pd.Remark, ");
        sb.Append(" pd.Url,ImageName, IF(IFNULL(pd.Url,'')='','false','true')FileStatus, rmd.Name,rmd.ID,DATE_FORMAT(pd.UploadDate,'%d-%b-%y')Upload_Date,DATE_FORMAT(pd.UploadDate,'%H:%i %p')Upload_Time FROM research_master rm  INNER JOIN research_master_detail rmd     ON rmd.formid = rm.FormID ");
        sb.Append("  LEFT JOIN Patient_DocumentDetails pd  ON pd.DocumentID=rmd.ID AND pd.appid='" + ViewState["App_ID"].ToString() + "' ");
        sb.Append("  WHERE rm.IsActive=1  AND rm.Isresearch=0");
        sb.Append(" UNION ALL ");
        sb.Append("  SELECT rm.Formid,Rm.FormName");
        sb.Append(",IFNULL(pd.ID,0)Visible,IF(IFNULL(pd.url,'')='','false','true')STATUS,pd.Remark,");
        sb.Append(" pd.Url,ImageName, IF(IFNULL(pd.Url,'')='','false','true')FileStatus,rmd.Name,rmd.ID,DATE_FORMAT(pd.UploadDate,'%d-%b-%y')Upload_Date,DATE_FORMAT(pd.UploadDate,'%H:%i %p')Upload_Time FROM research_master  rm INNER JOIN research_master_detail rmd ON rmd.formid=rm.FormID");
        sb.Append("  INNER JOIN patient_researchdetail pr ON  pr.ResearchID=rmd.FormID AND pr.appid='" + ViewState["App_ID"].ToString() + "' ");
        sb.Append("  LEFT JOIN Patient_DocumentDetails ");
        sb.Append(" pd ON pd.DocumentID=rmd.ID AND pd.appid='" + ViewState["App_ID"].ToString() + "' WHERE rm.IsActive=1  AND rm.Isresearch=1");
        sb.Append(" )t ");
        DataTable dtDetail = StockReports.GetDataTable(sb.ToString());
        if (dtDetail.Rows.Count > 0)
        {
            GridView1.DataSource = dtDetail;
            GridView1.DataBind();
        }
        else
        {
            GridView1.DataSource = "";
            GridView1.DataBind();
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
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
                    lblMsg.Text = "File Type Not Identified";
                }
            }
        }
        if (e.CommandName == "UpdateRemark")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string Re = ((TextBox)GridView1.Rows[id].FindControl("txtRemarkDocument")).Text;
            StockReports.ExecuteDML("Update Patient_DocumentDetails SET Remark='" + ((TextBox)GridView1.Rows[id].FindControl("txtRemarkDocument")).Text + "' WHERE AppID='" + ViewState["App_ID"].ToString() + "' AND DocumentID='" + ((Label)GridView1.Rows[id].FindControl("lblID")).Text + "' ");
            BindDocumentName();
            BindDocument();
        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //GridViewRow gvr = e.Row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("lblStatus")).Text;
            if (status.ToUpper() == "TRUE")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = true;
                ((ImageButton)e.Row.FindControl("imgUpdateRemark")).Visible = true;
            }
            else
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                ((ImageButton)e.Row.FindControl("imgUpdateRemark")).Visible = false;
            }
        }
    }
}