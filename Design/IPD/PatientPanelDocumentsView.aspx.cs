using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;

public partial class Design_IPD_PatientPanelDocumentsView : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            {
                ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            }

            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(ViewState["TransactionID"].ToString());
            
            float AmountBilled = Util.GetFloat(AQ.GetBillAmount(ViewState["TransactionID"].ToString(),null));
            float TotalDisc = Util.GetFloat(StockReports.ExecuteScalar("Select (IFNULL(SUM(TotalDiscAmt),0) + (SELECT IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + ViewState["TransactionID"].ToString() + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0"));
            AmountBilled = AmountBilled - TotalDisc;
            lblBillAmount.Text = AmountBilled.ToString();
            lblApprovalAmt.Text = Util.GetString(dt.Rows[0]["PanelApprovedAmt"]);            

            lblPanelNAme.Text = Util.GetString(StockReports.ExecuteScalar("SELECT Company_Name FROM f_panel_master WHERE PanelID='" + dt.Rows[0]["PanelId"].ToString() + "'"));

            DataTable dtAdj = StockReports.GetDataTable("Select PanelAppRemarks,ClaimNo from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'");
            // txtRemarks.Text = dtAdj.Rows[0]["PanelAppRemarks"].ToString();
            lblClaimNo.Text = dtAdj.Rows[0]["ClaimNo"].ToString();
            //lblRemarks.Text = dtAdj.Rows[0]["PanelAppRemarks"].ToString();          
            BindPanelDetail();
            lblMsg.Text = "";
        }
    }

    //private void InsertPendingDocument()
    //{
    //    string PanelID = StockReports.ExecuteScalar("Select PanelID from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'");

    //    if (PanelID != "")
    //    {
    //        StringBuilder sb = new StringBuilder();
    //        sb.Append("SELECT pdd.PanelDocumentID,pdm.Document,if(ifnull(t.FilePath,'')='','false','true')STATUS, ");
    //        sb.Append("FilePath,FileName,if(ifnull(t.FilePath,'')='','false','true')FileStatus FROM f_paneldocumentdetail pdd INNER JOIN ");
    //        sb.Append("f_paneldocumentMaster pdm ON pdd.DocumentID = pdm.DocumentID ");
    //        sb.Append("LEFT JOIN ( ");
    //        sb.Append("       SELECT PanelDocumentID,FilePath,FileName FROM f_paneldocument_patient ");
    //        sb.Append("       WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' AND IsActive=1 ");
    //        sb.Append(")t ON pdd.PanelDocumentID = t.PanelDocumentID Where pdd.IsActive=1 ");
    //        sb.Append("and PanelID='" + PanelID + "' AND t.PanelDocumentID IS NULL ");

    //        DataTable dt = StockReports.GetDataTable(sb.ToString());

    //        if (dt != null && dt.Rows.Count > 0)
    //        {

    //            MySqlConnection con = new MySqlConnection();
    //            con = Util.GetMySqlCon();
    //            con.Open();
    //            MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);

    //            try
    //            {
    //                foreach (DataRow drDocs in dt.Rows)
    //                {
    //                    sb = new StringBuilder();
    //                    sb.Append("Insert into f_paneldocument_patient(PanelDocumentID,TransactionID,IsActive)");
    //                    sb.Append("values(" + drDocs["PanelDocumentID"].ToString() + ",'" + ViewState["TransactionID"].ToString() + "',1)");
    //                    MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
    //                }
    //                MySqltrans.Commit();
    //                con.Close();
    //                con.Dispose();
    //            }
    //            catch (Exception ex)
    //            {
    //                MySqltrans.Rollback();
    //                con.Close();
    //                con.Dispose();

    //                ClassLog cl = new ClassLog();
    //                cl.errLog(ex);
    //            }
    //        }            
    //    }
    //}


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
            }
            else
            {
                lblMsg.Text = "Document not Set or Required for Under this Patient's Panel...";
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
   
