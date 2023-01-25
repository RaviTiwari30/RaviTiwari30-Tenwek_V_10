using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.IO;


public partial class IPD_ConsentForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {        
        if (!IsPostBack)
        {           

            ViewState["PatientID"] = Request.QueryString["PatientId"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();

            DateTime AdmitDate = Util.GetDateTime((new AllQuery()).getAdmitDate(ViewState["TransactionID"].ToString()));
            txtConsentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtRelConsentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            calConsentDate.StartDate = AdmitDate;
            calConsentDate2.StartDate = AdmitDate;


            this.BindNameTitle();
            this.BindSurgery();
            this.BindDataGrid();
            btnUpdate.Visible = false;
        }
        txtConsentDate.Attributes.Add("readOnly", "true");
        txtRelConsentDate.Attributes.Add("readOnly", "true");
    }

    private void BindNameTitle()
    {
        List<String> NameTitle = AllGlobalFunction.NameTitle.ToList();
        NameTitle.Remove("Master");
        NameTitle.Remove("Baby");
        NameTitle.Remove("B/O");

        ddlRelTitle.DataSource = NameTitle;
        ddlRelTitle.DataBind();

        ddlWitnessTitle.DataSource = NameTitle;
        ddlWitnessTitle.DataBind();

        ddlRelWitnessTitle.DataSource = NameTitle;
        ddlRelWitnessTitle.DataBind();

    }

    private void BindSurgery()
    {
        string Query = "SELECT Surgery_ID,`Name` FROM f_surgery_master";
        DataTable dt = StockReports.GetDataTable(Query);
        ddlSurgery.DataTextField = "Name";
        ddlSurgery.DataValueField = "Surgery_ID";
        ddlSurgery.DataSource = dt;
        ddlSurgery.DataBind();
        ddlSurgery.Items.Insert(0, new ListItem("Select Surgery", "0"));
    }

    private void BindDataGrid()
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT ic.ID,sm.Name SurgeryName,DATE_FORMAT(ConsentDate,'%d-%b-%Y')ConsentDate,WitnessName,RelName,  ");
        Query.Append("DATE_FORMAT(RelConsentDate,'%d-%b-%Y')RelConsentDate,RelWitnessName,em.Name CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate,UploadStatus, ");
        Query.Append("DocumentName,date_format(UploadedDate,'%d-%b-%Y')UploadedDate,(select Name from employee_master where EmployeeID=UploadedBy)UploadedBy,DocumentURL ");
        Query.Append("FROM ipd_consentform ic INNER JOIN f_surgery_master sm ON ic.Surgery_ID=sm.Surgery_ID  INNER JOIN employee_master em ON ic.CreatedBy=em.EmployeeID ");
        Query.Append("where ic.PatientID='" + ViewState["PatientID"].ToString() + "' AND ic.TransactionID='" + ViewState["TransactionID"].ToString() + "' order by UploadStatus desc");
        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            grdDataView.DataSource = dt;
            grdDataView.DataBind();
            hide.Visible = true;
        }       
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            IPD_Consent consent = new IPD_Consent(Tranx);

            consent.PatientID = ViewState["PatientID"].ToString().Trim();
            consent.TransactionID = ViewState["TransactionID"].ToString().Trim();
            consent.Surgery_ID = ddlSurgery.SelectedValue;
            consent.ConsentDate = Util.GetDateTime(txtConsentDate.Text);
            consent.WitnessName = ddlWitnessTitle.SelectedValue + " " + txtWitnessName.Text.Trim();
            consent.RelName = ddlRelTitle.SelectedValue + " " + txtRelativeName.Text.Trim();
            consent.RelConsentDate = Util.GetDateTime(txtRelConsentDate.Text);
            consent.RelWitnessName = ddlRelWitnessTitle.SelectedValue + " " + txtRelWitnessName.Text.Trim();
            consent.CreatedBy = Session["ID"].ToString();
            consent.Insert();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            Tranx.Commit();
            ClearControls();
            BindDataGrid();
        }
        catch (Exception ex)
        {

            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
        }

        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            StringBuilder Query = new StringBuilder();
            Query.Append("Update ipd_consentform set Surgery_ID='" + ddlSurgery.SelectedValue.ToString() + "',ConsentDate='" + Util.GetDateTime(txtConsentDate.Text).ToString("yyyy-MM-dd") + "',");
            Query.Append("WitnessName='" + (ddlWitnessTitle.SelectedValue + " " + txtWitnessName.Text.Trim()) + "',RelName='" + (ddlRelTitle.SelectedValue + " " + txtRelativeName.Text.Trim()) + "',");
            Query.Append("RelConsentDate='" + Util.GetDateTime(txtRelConsentDate.Text).ToString("yyyy-MM-dd") + "',RelWitnessName='" + (ddlRelWitnessTitle.SelectedValue + " " + txtRelWitnessName.Text.Trim()) + "' ");
            Query.Append("where ID=" + ViewState["ID"].ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, Query.ToString());
            tranX.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            ClearControls();
            BindDataGrid();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    protected void grdDataView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string str = string.Empty;
        ViewState["ID"] = e.CommandArgument.ToString();
        if (e.CommandName == "Print")
        {
            StringBuilder QueryStr = new StringBuilder();
            QueryStr.Append("SELECT sm.Name SurgeryName,CONCAT(Title,' ',PName)PatientName,DATE_FORMAT(ConsentDate,'%d-%M-%Y')ConsentDate, ");
            QueryStr.Append("WitnessName,RelName,DATE_FORMAT(RelConsentDate,'%d-%M-%Y')RelConsentDate,RelWitnessName FROM ipd_consentform ic INNER JOIN patient_master pm ON ic.PatientID=pm.PatientID ");
            QueryStr.Append("INNER JOIN f_surgery_master sm ON ic.Surgery_ID=sm.Surgery_ID ");
            QueryStr.Append("where ic.ID=" + ViewState["ID"].ToString());

            DataTable dts = StockReports.GetDataTable(QueryStr.ToString());

            if (dts.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());                

                DataColumn dc = new DataColumn();
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dts.Columns.Add(dc);
                
                ds.Tables.Add(dts.Copy());
                Session["ReportName"] = "ConsentForm";
                Session["ds"] = ds;
                //ds.WriteXmlSchema(@"D:\ConsentForm.xml");

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                lblMsg.Text = "";
            }
        }
        else if (e.CommandName == "EditRow")
        {
            string Query = "SELECT * FROM ipd_consentform where ID=" + ViewState["ID"].ToString();
            DataTable dt = StockReports.GetDataTable(Query);
            ddlSurgery.SelectedValue = dt.Rows[0]["Surgery_ID"].ToString();
            txtConsentDate.Text = Util.GetDateTime((dt.Rows[0]["ConsentDate"].ToString())).ToString("dd-MMM-yyyy");
            str = dt.Rows[0]["WitnessName"].ToString();
            ddlWitnessTitle.SelectedValue = str.Split((str.Contains('.') ? '.' : ' '))[0].ToString() + (str.Contains('.') ? "." : "");
            txtWitnessName.Text = str.Substring(str.IndexOf((str.Contains('.') ? '.' : ' ')) + 1);
            str = dt.Rows[0]["RelName"].ToString();
            ddlRelTitle.SelectedValue = str.Split((str.Contains('.') ? '.' : ' '))[0].ToString() + (str.Contains('.') ? "." : "");
            txtRelativeName.Text = str.Substring(str.IndexOf((str.Contains('.') ? '.' : ' ')) + 1);
            txtRelConsentDate.Text = Util.GetDateTime(dt.Rows[0]["RelConsentDate"].ToString()).ToString("dd-MMM-yyyy");
            str = dt.Rows[0]["RelWitnessName"].ToString();
            ddlRelWitnessTitle.SelectedValue = str.Split((str.Contains('.') ? '.' : ' '))[0].ToString() + (str.Contains('.') ? "." : "");
            txtRelWitnessName.Text = str.Substring(str.IndexOf((str.Contains('.') ? '.' : ' ')) + 1);
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            lblMsg.Text = "";

        }
        else if (e.CommandName == "SaveImage")
        {
            this.Save_Image(e.CommandArgument.ToString());            
        }
        else if (e.CommandName == "AView")
        {            
            this.ViewDocument(Util.GetString(e.CommandArgument));
        }

    }


    private void ClearControls()
    {
        ddlSurgery.SelectedIndex = 0;
        txtConsentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy"); 
        ddlWitnessTitle.SelectedIndex = 0;
        txtWitnessName.Text = "";
        ddlRelTitle.SelectedIndex = 0;
        txtRelativeName.Text = "";
        txtRelConsentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy"); 
        ddlRelWitnessTitle.SelectedIndex = 0;
        txtRelWitnessName.Text = "";
        btnUpdate.Visible = false;
        btnSave.Visible = true;

    }

    protected void Save_Image(string ID)
    {
        if (ServerSideValidation() == true)
        {
            int IsFile = 0;

            foreach (GridViewRow grv in grdDataView.Rows)
            {
                if ((((FileUpload)grv.FindControl("ddlupload_doc")).HasFile && (((ImageButton)grv.FindControl("imbView")).Visible = true)))
                    IsFile = 1;
            }

            if (IsFile == 0)
            {
                lblMsg.Text = "Please Select File";
                return;
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                //string Path = @"c:\HISDocuments";
                string Path = "~/HISDocuments";
                bool IsExists = System.IO.Directory.Exists(Server.MapPath(Path));
                if (!IsExists)
                {
                    System.IO.Directory.CreateDirectory(Server.MapPath(Path));
                }
                //var Path = new FileInfo(Path.Combine(Path.FullName, lblAppID.Text.Trim()));

                Path += "/" + "ConsentForms";
                bool IsLabFolderExists = System.IO.Directory.Exists(Server.MapPath(Path));

                if (!IsLabFolderExists)
                {
                    System.IO.Directory.CreateDirectory(Server.MapPath(Path));
                }
                //DataTable dtRefNo=StockReports.GetDataTable("Select EmployeeID from pay_offerletter_new where ")
                foreach (GridViewRow row in grdDataView.Rows)
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).FileName != "")
                    {
                        string Exte = System.IO.Path.GetExtension(((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.FileName).ToLower();
                        if (Exte != "")
                        {
                            if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif")
                            {
                                lblMsg.Text = "Wrong File Extension of Document ";
                                return;
                            }
                        }                       

                        string ImgName = ((FileUpload)row.FindControl("ddlupload_doc")).FileName;
                        string newFile = Guid.NewGuid().ToString() + Exte;
                        string Url = System.IO.Path.Combine(Server.MapPath(Path + "/" +ID+newFile));
                        //Check For File Already Exit for this Patient if Yes then delete file
                        if (!File.Exists(Url))
                        {
                            ((FileUpload)row.FindControl("ddlupload_doc")).PostedFile.SaveAs(Url);
                            Url = Url.Replace("\\", "''");
                            Url = Url.Replace("'", "\\");
                            StockReports.ExecuteDML("UPDATE ipd_consentform SET UploadStatus=1,DocumentName='" + ImgName + "',DocumentURL='" + Url + "',UploadedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',UploadedBy='" + Session["ID"] + "' where ID=" + ID);
                        }
                        else
                        {
                            lblMsg.Text = "File Already Exists";
                            return;
                        }
                    }
                }
                Tranx.Commit();
                this.BindDataGrid();
                lblMsg.Text = "File Uploaded Successfully";
                lblMsg.Focus();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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

    private void ViewDocument(string FilePath)
    {
        if (FilePath != "")
        {
            FileInfo File = new FileInfo(FilePath);
            string FileName = File.Name;
            //DataTable dtImage = new DataTable();
            //dtImage = StockReports.GetDataTable("select * from Patient_DocumentDetails where DocumentID='" + ID + "' and AppID='" + lblAppID.Text.Trim() + "'");
            //if (dtImage.Rows.Count == 0 || dtImage == null)
            //{
            //    lblMsg.Text = "File Not Found";
            //    return;
            //}
            //string url = dtImage.Rows[0]["Url"].ToString();
            //string Ext = url.Split('.')[1];
            //string Name = dtImage.Rows[0]["ImageName"].ToString();
            //int NewID = url.IndexOf("HISDocuments");
            //string UrlNew = url.Substring(NewID);
            //Response.Clear();

            if (File.Extension.ToLower() == ".pdf")
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
            else if (File.Extension.ToLower() == ".xlsx")
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
            else if (File.Extension.ToLower() == ".jpg")
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
            else if (File.Extension.ToLower() == ".txt")
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
            else if (File.Extension.ToLower() == ".htm")
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
            else if (File.Extension.ToLower() == ".html")
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
            else if (File.Extension.ToLower() == ".doc")
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
            else if (File.Extension.ToLower() == ".docx")
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
            else if (File.Extension.ToLower() == ".csv")
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
            else if (File.Extension.ToLower() == ".gif")
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
    protected void grdDataView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
        GridViewRow gvr = e.Row;
       
        if (e.Row.RowIndex > -1)
        {            
            if (((Label)e.Row.FindControl("lblStatus")).Text == "0")
            {
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imbEdit")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbPrint")).Visible = false;
                ((FileUpload)e.Row.FindControl("ddlupload_doc")).Visible = false;
                ((Button)e.Row.FindControl("btnUpload")).Visible = false;
            }

        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("lblStatus")).Text;
            if (status.ToUpper() == "1")
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            else
                e.Row.BackColor = System.Drawing.Color.LightPink;
        }
    }
}