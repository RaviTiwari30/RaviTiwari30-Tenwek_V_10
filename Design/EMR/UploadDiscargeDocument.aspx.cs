using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;
using System.Web;

public partial class Design_EMR_UploadDiscargeDocument : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int DefaultWidth = Util.GetInt(txtWidth.Text.Trim());
        int DefaultHeight = Util.GetInt(txtHeight.Text.Trim());
        int pxlw = Convert.ToInt32(DefaultWidth * 37.8);
        int pxlh = Convert.ToInt32(DefaultHeight * 37.8);
        
        Random ran = new Random();
        string Ext = System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName.ToString());
            if (!(Ext.EndsWith("pdf") ))
            {
                lblMsg.Text = "Please Upload only PDF file";
                return;
            }
            string fileName = "";
            //fileName = FileUpload1.FileName;
            fileName =  DateTime.Now.ToString("yyyyMMdd_HHmmss");
            fileName += ran.Next().ToString();
            fileName += ".pdf";

            if (All_LoadData.chkDocumentDrive() == 0)
            {
                lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                return;
            }
            var pathname = All_LoadData.createDocumentFolder("DischargeDocument", ViewState["TID"].ToString());
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
                        
                      

                       
                        string imgurl;
                    

                        imgurl = pathname + "" + fileName;
                     
                        string filename = FileUpload1.FileName;
                        FileUpload1.PostedFile.SaveAs(imgurl);

                        fileName = ViewState["TID"].ToString() + fileName;
                        int sno = Util.GetInt(StockReports.ExecuteScalar("select max(Priority) from emr_ipd_details_image where TransactionID='" + ViewState["TID"].ToString() + "'"));
                        sno += 1;
                        string str = "insert into emr_ipd_details_image(TransactionID,OtImage,OtImageNarration,UserID,priority,PhotoWidth,PhotoHeight,DocumentType) values(";
                        str += "'" + ViewState["TID"].ToString() + "','" + fileName + "','" + txtNarration.Text + "','" + Session["ID"].ToString() + "'," + sno.ToString() + ",'"+ txtWidth.Text.Trim()+"px" +"','"+ txtHeight.Text.Trim()+"px" +"','DischargeDocument')";
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
        if (e.CommandName == "imgRemove")
        {
           // var dirPath = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\OtImages" + "\\" + ViewState["TID"].ToString() + "\\" + e.CommandArgument.ToString());
            var dirPath = string.Concat(Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, "\\", Resources.Resource.DocumentFolderName, "\\DischargeDocument\\" + e.CommandArgument.ToString());

            StockReports.ExecuteDML("delete from emr_ipd_details_image where TransactionID='" + ViewState["TID"].ToString() + "' and otimage='" + e.CommandArgument.ToString() + "'");
            File.Delete(dirPath.ToString());
            lblMsg.Text = "Image Deleted Successfully";
            BindOTImages();
        }
        if (e.CommandName == "aView")
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
            }
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
        var dirPath  = string.Concat(Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, "//", Resources.Resource.DocumentFolderName, "//DischargeDocument//");
        grvImages.DataSource = StockReports.GetDataTable("SELECT id,TransactionID,OtImage,OtImageNarration,UserID,Priority,CONCAT('" + dirPath + "/',OtImage)imgUrl,PhotoWidth,PhotoHeight  FROM emr_ipd_details_image where TransactionID='" + ViewState["TID"].ToString() + "' and DocumentType='DischargeDocument' order by Priority asc");
        grvImages.DataBind();
    }

    
}