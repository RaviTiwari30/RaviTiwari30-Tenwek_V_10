using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;

public partial class Design_IPD_PatientPanelDocuments : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            {
                ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            }

            if (Request.QueryString["PatientId"] != null && Request.QueryString["PatientId"].ToString() != "")
            {
                ViewState["PatientId"] = Request.QueryString["PatientId"].ToString();
            }


            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(ViewState["TransactionID"].ToString());

            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TransactionID"].ToString(), null));
            decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(SUM((Rate*Quantity)-Amount),0) + (SELECT IFNULL(DiscountOnBill,0)  from patient_medical_history where `Type`='IPD' AND TransactionID='" + ViewState["TransactionID"].ToString() + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + ViewState["TransactionID"].ToString() + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0"));
            AmountBilled = AmountBilled - TotalDisc;
            lblBillAmount.Text = Math.Round(Util.GetDecimal(AmountBilled), 2).ToString();
            lblApprovalAmt.Text = Util.GetString(dt.Rows[0]["PanelApprovedAmt"]);

            lblPanelNAme.Text = Util.GetString(StockReports.ExecuteScalar("SELECT Company_Name FROM f_panel_master WHERE PanelID=" + dt.Rows[0]["PanelId"].ToString() + " "));
            if (lblPanelNAme.Text.ToUpper() == "CASH")
            {
                btnSave.Enabled = false;
            }
            else
            {
                btnSave.Enabled = true;
            }
            DataTable dtAdj = StockReports.GetDataTable("Select PanelAppRemarks,ClaimNo from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'");
            // txtRemarks.Text = dtAdj.Rows[0]["PanelAppRemarks"].ToString();
            lblClaimNo.Text = dtAdj.Rows[0]["ClaimNo"].ToString();
            //lblRemarks.Text = dtAdj.Rows[0]["PanelAppRemarks"].ToString();

            InsertPendingDocument();
            BindPanelDetail();
            lblMsg.Text = "";
        }
    }

    private void InsertPendingDocument()
    {
        string PanelID = StockReports.ExecuteScalar("Select PanelID from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'");

        if (PanelID != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pdd.PanelDocumentID,pdm.Document,if(ifnull(t.FilePath,'')='','false','true')STATUS, ");
            sb.Append("FilePath,FileName,if(ifnull(t.FilePath,'')='','false','true')FileStatus FROM f_paneldocumentdetail pdd INNER JOIN ");
            sb.Append("f_paneldocumentMaster pdm ON pdd.DocumentID = pdm.DocumentID ");
            sb.Append("LEFT JOIN ( ");
            sb.Append("       SELECT PanelDocumentID,FilePath,FileName FROM f_paneldocument_patient ");
            sb.Append("       WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' AND IsActive=1 ");
            sb.Append(")t ON pdd.PanelDocumentID = t.PanelDocumentID Where pdd.IsActive=1 ");
            sb.Append("and PanelID=" + PanelID + " AND t.PanelDocumentID IS NULL ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {

                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);

                try
                {
                    foreach (DataRow drDocs in dt.Rows)
                    {
                        sb = new StringBuilder();
                        sb.Append("Insert into f_paneldocument_patient(PanelDocumentID,TransactionID,IsActive)");
                        sb.Append("values(" + drDocs["PanelDocumentID"].ToString() + ",'" + ViewState["TransactionID"].ToString() + "',1)");
                        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
                    }
                    MySqltrans.Commit();

                }
                catch (Exception ex)
                {
                    MySqltrans.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    MySqltrans.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
        }
    }


    private void BindPanelDetail()
    {
        string PanelID = StockReports.ExecuteScalar("Select PanelID from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'");

        if (PanelID != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pdd.PanelDocumentID,pdm.Document,if(ifnull(t.FilePath,'')='','false','true')STATUS, ");
            sb.Append("FilePath,FileName,if(ifnull(t.FilePath,'')='','false','true')FileStatus FROM f_paneldocumentdetail pdd INNER JOIN ");
            sb.Append("f_paneldocumentMaster pdm ON pdd.DocumentID = pdm.DocumentID ");
            sb.Append("LEFT JOIN ( ");
            sb.Append("       SELECT PanelDocumentID,FilePath,FileName FROM f_paneldocument_patient ");
            sb.Append("       WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' AND IsActive=1 ");
            sb.Append(")t ON pdd.PanelDocumentID = t.PanelDocumentID Where pdd.IsActive=1 and PanelID=" + PanelID + " ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                grdDocuments.DataSource = dt;
                grdDocuments.DataBind();
                btnSave.Enabled = true;

            }
            else
            {
                lblMsg.Text = "Document not Set or Required for Under this Patient Panel";
                btnSave.Enabled = false;
            }
        }

    }
    protected void grdDocuments_RowDataBound(object sender, GridViewRowEventArgs e)
    {
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
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int IsChecked = 0;

        int panelID = 8;

        foreach (GridViewRow grv in grdDocuments.Rows)
        {
            if (((CheckBox)grv.FindControl("chkSelect")).Checked)
                IsChecked = 1;
        }

        if (IsChecked == 0)
        {
            lblMsg.Text = "Please Select Documents";
            return;
        }
        if (All_LoadData.chkDocumentDrive() == 0)
        {
            lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
            return;
        }
        var directoryPath = All_LoadData.createDocumentFolder("PanelDocuments", ViewState["PatientId"].ToString().Replace("/", "_"), panelID.ToString());
        if (directoryPath == null)
        {
            lblMsg.Text = "Error occurred, Please contact administrator ";
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb = new StringBuilder();
            foreach (GridViewRow grv in grdDocuments.Rows)
            {
                string FilePath = "";
                ///////////
                string ExistingFile = ((Label)grv.FindControl("lblFilePath")).Text;

                string Ext = ((FileUpload)grv.FindControl("FileUpload1")).PostedFile.FileName;

                if (Ext == "")
                    Ext = ExistingFile;

                string Filename = ((FileUpload)grv.FindControl("FileUpload1")).FileName;
                string ExistingFileName = ((Label)grv.FindControl("lblFileName")).Text;

                if (Filename == "")
                    Filename = ExistingFileName;

                if (Ext != "")
                {

                    //  DirectoryInfo[] sub = directoryPath.GetDirectories();

                    //   IpFolder = directoryPath.Name;
                    //   Ip = Path.Combine(Resources.Resource.DocumentDriveName + Resources.Resource.DocumentFolderName + "\\PanelDocuments", IpFolder);
                    FilePath = Path.Combine(directoryPath.ToString(), Filename);

                    //DirectoryInfo folder = new DirectoryInfo(@"C:\FileApprovalUpload\PanelDocuments");
                    //if (folder.Exists)
                    //{
                    //    DirectoryInfo[] SubFolder = folder.GetDirectories(ViewState["TransactionID"].ToString());

                    //    if (SubFolder.Length > 0)
                    //    {
                    //        foreach (DirectoryInfo Sub in SubFolder)
                    //        {
                    //            if (Sub.Name == ViewState["TransactionID"].ToString())
                    //            {
                    //                IpFolder = Sub.Name;
                    //                Ip = Path.Combine(@"C:\FileApprovalUpload\PanelDocuments", IpFolder);
                    //                FilePath = Path.Combine(Ip, Filename);
                    //                break;
                    //            }
                    //        }
                    //    }
                    //    else
                    //    {
                    //        DirectoryInfo subFold = folder.CreateSubdirectory(ViewState["TransactionID"].ToString());
                    //        IpFolder = subFold.Name;
                    //        Ip = Path.Combine(@"C:\FileApprovalUpload\PanelDocuments", IpFolder);
                    //        FilePath = Path.Combine(Ip, Filename);
                    //    }

                    //}
                    //else
                    //{
                    //    DirectoryInfo subfolder = folder.CreateSubdirectory(ViewState["TransactionID"].ToString());
                    //    DirectoryInfo[] sub = subfolder.GetDirectories();

                    //    IpFolder = subfolder.Name;
                    //    Ip = Path.Combine(@"C:\FileApprovalUpload\PanelDocuments", IpFolder);
                    //    FilePath = Path.Combine(Ip, Filename);
                    //}
                }

                if (FilePath != "")
                {
                    string UpLoadFile = FilePath.Replace("\\", "''");
                    UpLoadFile = UpLoadFile.Replace("'", "\\");

                    sb = new StringBuilder();
                    sb.Append("Update f_paneldocument_patient ");
                    sb.Append("Set FilePath='" + UpLoadFile + "',FileName='" + Filename + "',");
                    sb.Append("UserID='" + Util.GetString(Session["ID"]) + "',PanelID= " + panelID + " ");
                    sb.Append("Where TransactionID='" + ViewState["TransactionID"].ToString() + "' ");
                    sb.Append("and PanelDocumentID=" + ((Label)grv.FindControl("lblPanelDocumentID")).Text + " ");
                    int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    if (result > 0)
                    {
                        //Deleting the existing File
                        FileInfo FileExist = new FileInfo(FilePath);
                        if (FileExist.Exists)
                            FileExist.Delete();

                        //Saving File at desired location
                        ((FileUpload)grv.FindControl("FileUpload1")).PostedFile.SaveAs(FilePath);
                    }

                }
            }

            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            BindPanelDetail();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdDocuments_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "VIEW")
        {
            string FilePath = Util.GetString(e.CommandArgument);

            if (FilePath != "")
            {
                FileInfo File = new FileInfo(FilePath);
                string FileName = File.Name;

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
                    lblMsg.Text = "File Type Not Identified...";
                }
            }
        }

    }
}

