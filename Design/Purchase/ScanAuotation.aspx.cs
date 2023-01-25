using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Purchase_ScanAuotation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string RefNo = "";
        if (!Page.IsPostBack)
        {
            if(Request.QueryString["RefNo"] != null)
            {
             
                RefNo = Request.QueryString["RefNo"].ToString();
             
                BindQuotation(RefNo);
            }
            lblNote.Visible = false;
            BindVendor();
            
        }
      
    }

    private void BindQuotation(string RefNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT prq.Quote_id, ");
        sb.Append(" IF(prq.VendorID LIKE 'LSHHI%',(SELECT Vendorname FROM f_vendormaster WHERE vendor_id=prq.VendorID),        ");
        sb.Append(" IFNULL((SELECT ven.Vendorname FROM f_vendormaster ven INNER JOIN d_f_vendormaster dven ON ven.vendor_id=dven.vendor_idMain            ");
        sb.Append(" WHERE dven.Vendor_id=prq.VendorID),(SELECT Vendorname FROM d_f_vendormaster ven  WHERE ven.Vendor_id=prq.VendorID)))VendorName     ");
        sb.Append(" ,prq.VendorID,prq.QuotationRefNo,DATE_FORMAT(prq.Date,'%d-%b-%y')DATE,prq.Remarks,DATE_FORMAT(prq.RefDate,'%d-%b-%y')RefDate     ");
        sb.Append(" ,prq.url,IF(prq.UploadStatus=1,'true','false')UploadStatus,prq.RefrenceNo     ");
        sb.Append(" FROM d_f_purchaserequestquotation prq WHERE prq.IsActive=1 AND prq.QuotationRefNo='" + RefNo + "' GROUP BY QuotationRefNo     ");

        DataTable dtquot = StockReports.GetDataTable(sb.ToString());
        if (dtquot.Rows.Count > 0)
        {
            grdUploadDocs.DataSource = dtquot;
            grdUploadDocs.DataBind();
            lblNote.Visible = true;
            lblMsg.Text = "";
        }
        else
        {
            grdUploadDocs.DataSource = null;
            grdUploadDocs.DataBind();
            lblNote.Visible = false;
            //lblMsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }

    }
    private void BindVendor()
    {
        ddlVendor.Controls.Clear();

       // string str = "select * from ( SELECT Concat(Vendor_Id,'#','N')Vendor_Id,vendorName FROM f_vendormaster  UNION ALL  SELECT Concat(Vendor_Id,'#','Y')Vendor_Id,vendorName FROM f_vendormaster where Vendor_IDMain='' ) t order by t.vendorName";
        string str = "select * from ( SELECT Concat(Vendor_Id,'#','N')Vendor_Id,vendorName FROM f_vendormaster  UNION ALL  SELECT Concat(Vendor_Id,'#','Y')Vendor_Id,vendorName FROM f_vendormaster where Vendor_ID='' ) t order by t.vendorName";
        DataTable dt = StockReports.GetDataTable(str);
        ddlVendor.DataSource = dt;
        ddlVendor.DataTextField = "vendorName";
        ddlVendor.DataValueField = "Vendor_Id";
        ddlVendor.DataBind();
        ddlVendor.Items.Insert(0, new ListItem("ALL", "0"));


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
               
               
                string VendorID = ((Label)row.FindControl("lblvendorid")).Text.ToString();
                string QuotRefNo = ((Label)row.FindControl("lblQuotRefNo")).Text.ToString();
                DirectoryInfo MyDir = new DirectoryInfo(@"C:\QuotationFiles");

                {

                    DirectoryInfo[] f2 = MyDir.GetDirectories(VendorID);
                    foreach (DirectoryInfo di in f2)
                    {

                        f1 = di.GetDirectories(QuotRefNo);


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
                                            if (file == QuotRefNo)
                                            {
                                                string FileName = file + fl.Extension;
                                                string path1 = Path.Combine(@"C:\QuotationFiles", Di.Name);
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
                                                if (fl.Extension == ".jpg")
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
                                                    Response.ContentType = "image / jpeg";

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
            //string File;

            string path = "";
            string upld = "";

            string Doc = "";
            if (((FileUpload)row.FindControl("FileUpload1")).PostedFile.ContentLength == 0)
            {
                lblMsg.Visible = true;
                //lblMsg.Text = "Please Browse File ..";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM037','" + lblMsg.ClientID + "');", true);
                return;
            }

            try
            {

              
                string VendorID = ((Label)row.FindControl("lblvendorid")).Text.ToString();
                string QuotRefNo = ((Label)row.FindControl("lblQuotRefNo")).Text.ToString();
                string Ext = ((FileUpload)row.FindControl("FileUpload1")).PostedFile.FileName.ToString().Split('.')[1];
                DirectoryInfo folder = new DirectoryInfo(@"C:\QuotationFiles");

                if (Ext != "pdf" && Ext != "jpg" && Ext != "jpeg" && Ext != "txt" && Ext != "doc" && Ext != "docx" && Ext != "csv" && Ext != "xls" && Ext != "xlsx" && Ext != "gif")
                {
                    lblMsg.Visible = true;
                    //lblMsg.Text = "Wrong File Extension Selected";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblMsg.ClientID + "');", true);
                    return;
                }
                if (folder.Exists)
                {
                    DirectoryInfo[] SubFolder = folder.GetDirectories(VendorID);
                    int a = 0;
                    if (SubFolder.Length > 0)
                    {
                        foreach (DirectoryInfo Sub in SubFolder)
                        {
                            if (Sub.Name == VendorID)
                            {
                                //Sub.CreateSubdirectory(ID);


                                DirectoryInfo[] SubFo = Sub.GetDirectories(QuotRefNo);
                                if (SubFo.Length <= 0)
                                {
                                    Sub.CreateSubdirectory(QuotRefNo);
                                }
                                foreach (DirectoryInfo s in SubFo)
                                {



                                    FileInfo[] files = s.GetFiles();
                                    foreach (FileInfo fl in files)
                                    {
                                        string fil = fl.Name.Split('.')[0];
                                        Sub.CreateSubdirectory(QuotRefNo);
                                        if (fil == QuotRefNo)
                                        {
                                            fl.Delete();
                                        }
                                    }
                                }
                                string IpFolder = Sub.Name;
                
                                Doc = QuotRefNo + "." + Ext;
                                string Ip = Path.Combine(@"C:\QuotationFiles", IpFolder);
                
                                path = Path.Combine(Ip, QuotRefNo);


                                upld = Path.Combine(path, Doc);

                                ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                                a = 1;
                                lblMsg.Visible = true;
                                string Text = upld;

                                cmd.CommandText = "update d_f_purchaserequestquotation set URL=@URL,UploadStatus=1 where RefrenceNo='" + ((Label)row.FindControl("lblRefNo")).Text.ToString().Trim() + "' ";
                                cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                                int result = cmd.ExecuteNonQuery();
                                ((Button)row.FindControl("btnView")).Visible = true;
                                //lblMsg.Text = "File Uploaded Sucessfully..";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM038','" + lblMsg.ClientID + "');", true);
                                
                                break;

                            }
                        }
                        if (a <= 0)
                        {
                            DirectoryInfo subfolder = folder.CreateSubdirectory(VendorID);
                            subfolder.CreateSubdirectory(QuotRefNo);
                            DirectoryInfo[] sub = subfolder.GetDirectories();


                            foreach (DirectoryInfo di in sub)
                            {
                                DirectoryInfo[] SubFo = di.GetDirectories(QuotRefNo);
                                foreach (DirectoryInfo s in SubFo)
                                {
                                    FileInfo[] files = s.GetFiles();
                                    foreach (FileInfo fl in files)
                                    {
                                        string fil = fl.Name.Split('.')[0];
                                        if (fil == QuotRefNo)
                                        {
                                            fl.Delete();
                                            //lblMsg.Visible = true;
                                            ////lblMsg.Text = "File Already Exist..";
                                            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM024','" + lblMsg.ClientID + "');", true);
                                            //return;

                                        }
                                    }
                                }
                

                                string IpFolder = subfolder.Name;

                                Doc = QuotRefNo + "." + Ext;
                                string Ip = Path.Combine(@"C:\QuotationFiles", IpFolder);
                                //File = ID;

                                path = Path.Combine(Ip, QuotRefNo);
                                upld = Path.Combine(path, Doc);
                                ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                                lblMsg.Visible = true;
                                string Text = upld;

                                cmd.CommandText = "update d_f_purchaserequestquotation set URL=@URL,UploadStatus=1 where RefrenceNo='" + ((Label)row.FindControl("lblRefNo")).Text.ToString().Trim() + "' ";
                                cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                                int result = cmd.ExecuteNonQuery();

                                //string sql = "update mrd_file_detail set URL='" + upld + "',UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                                // int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
                                ((Button)row.FindControl("btnView")).Visible = true;
                                //lblMsg.Text = "File Uploaded Sucessfully..";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM038','" + lblMsg.ClientID + "');", true);
                                
                            }
                        }
                    }
                    else
                    {
                        DirectoryInfo subfolder = folder.CreateSubdirectory(VendorID);
                        subfolder.CreateSubdirectory(QuotRefNo);
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
                                    if (fil == QuotRefNo)
                                    {
                                        fl.Delete();
                                        //lblMsg.Visible = true;
                                        ////lblMsg.Text = "File Already Exist..";
                                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM024','" + lblMsg.ClientID + "');", true);
                                        //return;

                                    }
                                }
                            }
                            string IpFolder = subfolder.Name;

                            Doc = QuotRefNo + "." + Ext;
                            string Ip = Path.Combine(@"C:\QuotationFiles", IpFolder);
                           // File = ID;
                            path = Path.Combine(Ip, QuotRefNo);
                            upld = Path.Combine(path, Doc);
                            ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                            lblMsg.Visible = true;
                            string Text = upld;

                            cmd.CommandText = "update  d_f_purchaserequestquotation set URL=@URL,UploadStatus=1 where RefrenceNo='" + ((Label)row.FindControl("lblRefNo")).Text.ToString().Trim() + "' ";
                            cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                            int result = cmd.ExecuteNonQuery();
                            //string sql = "update mrd_file_detail set URL='" + upld + "',UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                            // int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
                            ((Button)row.FindControl("btnView")).Visible = true;
                            //lblMsg.Text = "File Uploaded Sucessfully..";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM038','" + lblMsg.ClientID + "');", true);
                            
                        }

                    }
                }
                else
                {
                    //DirectoryInfo subfolder = folder.CreateSubdirectory(ViewState["TransactionID"].ToString());
                    DirectoryInfo subfolder = folder.CreateSubdirectory(VendorID);
                    //subfolder.CreateSubdirectory(ID);
                    subfolder.CreateSubdirectory(QuotRefNo);
                    DirectoryInfo[] sub = subfolder.GetDirectories();
                    foreach (DirectoryInfo di in sub)
                    {
                        //string IpFolder = subfolder.Name;
                        string QuotFolder = subfolder.Name;

                        // Doc = DocID + "." + Ext;
                        QuotRefNo = QuotRefNo + "." + Ext;
                        // string Ip = Path.Combine(@"C:\QuotationFiles", IpFolder);
                        string Ip = Path.Combine(@"C:\QuotationFiles", QuotFolder);

                        //File = ID;
                        // path = Path.Combine(Ip, File);
                        //  upld = Path.Combine(path, Doc);
                        upld = Path.Combine(Ip, QuotRefNo);
                        ((FileUpload)row.FindControl("FileUpload1")).PostedFile.SaveAs(upld);
                       // lblmsg.Visible = true;

                        string Text = upld;

                        cmd.CommandText = "update d_f_purchaserequestquotation set URL=@URL,UploadStatus=1 where QuotationRefNo='" + QuotRefNo + "' ";
                        cmd.Parameters.Add(new MySqlParameter("@URL", upld));
                        int result = cmd.ExecuteNonQuery();
                        //string sql = "update mrd_file_detail set URL='" + upld + "',UploadStatus=1 where FileDetID='" + ((Label)row.FindControl("DocDetID")).Text.ToString().Trim() + "' ";
                        //  int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
                        //((Button)row.FindControl("btnView")).Visible = true;
                        //lblMsg.Text = "File Uploaded Sucessfully..";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM038','" + lblMsg.ClientID + "');", true);
                        
                    }
                }

                btnSearch_Click(this, new EventArgs());
            }
            catch (Exception ex)
            {
                ClassLog objErr = new ClassLog();
                objErr.errLog(ex);
            }

        }
    }



    private DataTable GetDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("url", typeof(string)));
        dt.Columns.Add(new DataColumn("UploadStatus", typeof(string)));
        dt.Columns.Add(new DataColumn("Rate", typeof(float)));
        dt.Columns.Add(new DataColumn("RefDate", typeof(string)));
        dt.Columns.Add(new DataColumn("VendorName", typeof(string)));
        dt.Columns.Add(new DataColumn("Vendor_id", typeof(string)));
        dt.Columns.Add(new DataColumn("RefrenceNo", typeof(string)));
        dt.Columns.Add(new DataColumn("QuotationRefNo", typeof(string)));
        

        ViewState["dtItems"] = dt;
        return dt;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
       
        DataTable dtquot;
        
            
           
            sb.Append(" SELECT prq.Quote_id, ");
            sb.Append(" (SELECT VendorName FROM f_vendormaster WHERE Vendor_id=prq.VendorID)VendorName ");
            sb.Append(" ,prq.VendorID,prq.QuotationRefNo,DATE_FORMAT(prq.Date,'%d-%b-%y')DATE,prq.Remarks,DATE_FORMAT(prq.RefDate,'%d-%b-%y')RefDate     ");
            sb.Append(" ,prq.RefrenceNo     ");
            sb.Append(" FROM f_purchaserequestquotation prq WHERE prq.IsActive=1 ");

            if (ddlVendor.SelectedItem.Value != "0")
            {
                sb.Append(" and prq.vendorid='" + ddlVendor.SelectedItem.Value.Split('#')[0] + "' ");

            }
                if(txtQuotationNo.Text.ToString() != "")
                {
                    sb.Append(" and prq.QuotationRefNo='" + txtQuotationNo.Text.Trim() + "' ");
                }
                sb.Append(" GROUP BY QuotationRefNo     ");


             dtquot = StockReports.GetDataTable(sb.ToString());
        //}
        //else
        //{

        //    sb.Append(" select url,if(UploadStatus=1,'true','false')UploadStatus,SUM(Rate)Rate,DATE_FORMAT(RefDate,'%d-%b-%y')RefDate,ven.VendorName,ven.Vendor_id,RefrenceNo,QuotationRefNo from d_f_purchaserequestquotation dQuot ");
        //    if (ddlVendor.SelectedItem.Value != "0")
        //    {
        //        if (ddlVendor.SelectedItem.Value.ToString().Split('#').GetValue(1).ToString() == "N")
        //        {
        //            sb.Append(" inner join f_vendormaster ven on dquot.VendorID=ven.Vendor_ID ");
        //        }
        //        else
        //        {
        //            sb.Append(" inner join d_f_vendormaster ven on dquot.VendorID=ven.Vendor_ID ");
        //        }
        //        sb.Append(" where  ven.Vendor_ID='" + ddlVendor.SelectedItem.Value.ToString().Split('#').GetValue(0).ToString() + "' ");
        //    }
        //    if (txtQuotationNo.Text.ToString() != "")
        //    {
        //        sb.Append(" and QuotationRefNo='" + txtQuotationNo.Text.ToString() + "' ");
        //    }
        //    sb.Append(" group by  RefrenceNo ");

            // dtquot = StockReports.GetDataTable(sb.ToString());
        //}
        if (dtquot.Rows.Count > 0)
        {
            grdUploadDocs.DataSource = dtquot;
            grdUploadDocs.DataBind();
            lblNote.Visible = true;
        }
        else
        {
            grdUploadDocs.DataSource = null;
            grdUploadDocs.DataBind();
            lblNote.Visible = false;
        }
    }
}
