using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.IO.Compression;

public partial class Design_Controls_wuc_AudioRecording : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrids();
        }
    }

    protected void gridpredetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        Label lblMsg = (Label)Parent.FindControl("lblMsg");
        lblMsg.Text = "";
        string userID = ((Label)Parent.FindControl("lblUser_ID")).Text;
        string commandArg = Util.GetString(e.CommandArgument).ToString();
        string id = commandArg.Split('#')[0];
        string entryBy = commandArg.Split('#')[1];

        if (e.CommandName == "Delete")
        {
            if (userID == entryBy)
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update cpoe_voicerecord Set IsActive=0 where ID = '" + id + "' ");
                    lblMsg.Text = "Record Deleted Successfully";
                    tnx.Commit();
                    BindPreviousData();
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "Error occurred, Please contact administrator";
                    tnx.Rollback();
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                    lblMsg.Text = ex.Message;
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
                lblMsg.Text = "You are Not authorized to Delete Audio File";
            }
        }
        else if (e.CommandName == "Play")
        {
            try
            {
                string Path = "";
                string source = "";
                DataTable dtAudio = StockReports.GetDataTable("select Path from cpoe_voicerecord where ID = '" + id + "' ");
                if (dtAudio.Rows.Count > 0)
                {
                    Path = dtAudio.Rows[0]["Path"].ToString();
                    FileInfo fileToDecompress = new FileInfo(Path.Replace(".txt", ".gz"));
                    Decompress(fileToDecompress);
                    source = File.ReadAllText(Path);
                    System.IO.File.Delete(Path);
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DHTMLSound('" + source + "')", true);
                BindCurrentData();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }

    protected void griddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        Label lblMsg = (Label)Parent.FindControl("lblMsg");
        lblMsg.Text = "";
        string userID = ((Label)Parent.FindControl("lblUser_ID")).Text;
        string commandArg = Util.GetString(e.CommandArgument).ToString();
        string id = commandArg.Split('#')[0];
        string entryBy = commandArg.Split('#')[1];
        if (e.CommandName == "Delete")
        {
            if (userID == entryBy)
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update cpoe_voicerecord Set IsActive=0 where ID = '" + id + "' ");
                    lblMsg.Text = "Record Deactivated Successfully";
                    tnx.Commit();
                    BindCurrentData();
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "Error occurred, Please contact administrator";
                    tnx.Rollback();
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                    lblMsg.Text = ex.Message;
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
                lblMsg.Text = "You are Not authorized to Delete Audio File";
            }
        }
        else if (e.CommandName == "Play")
        {
            try
            {
                string Path = "";
                string source = "";
                DataTable dtAudio = StockReports.GetDataTable("select Path from cpoe_voicerecord where ID = '" + id + "' ");
                if (dtAudio.Rows.Count > 0)
                {
                    Path = dtAudio.Rows[0]["Path"].ToString();
                    FileInfo fileToDecompress = new FileInfo(Path.Replace(".txt", ".gz"));
                    Decompress(fileToDecompress);
                    source = File.ReadAllText(Path);
                    System.IO.File.Delete(Path);
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DHTMLSound('" + source + "')", true);
                BindCurrentData();
            }
            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }

    protected void rblType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrids();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        BindGrids();
    }

    protected void gridpredetail_RowDeleting(object sender, GridViewDeleteEventArgs e)
    { }

    protected void griddetail_RowDeleting(object sender, GridViewDeleteEventArgs e)
    { }

    private void BindCurrentData()
    {
        string patientID = ((Label)Parent.FindControl("lblPatientID")).Text;
        StringBuilder query = new StringBuilder();
        query.Append(" SELECT ID,SPLIT_STR(FileName,'_','1')FileName,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate,TIME_FORMAT(EntryDate,'%h:%i %p')EntryTime,UserID,Path,Type FROM cpoe_voicerecord  ");
        query.Append(" WHERE PatientID='" + patientID + "' and date(EntryDate)=curdate() AND IsActive=1");

        if (rblType.SelectedItem.Text != "All")
        {
            query.Append(" AND Type='" + rblType.SelectedItem.Text + "' ");
        }

        DataTable dtdetail = StockReports.GetDataTable(query.ToString());
        if (dtdetail.Rows.Count > 0)
        {
            griddetail.DataSource = dtdetail;
            griddetail.DataBind();
        }
        else
        {
            griddetail.DataSource = null;
            griddetail.DataBind();
        }
    }

    private void BindPreviousData()
    {
        string patientID = ((Label)Parent.FindControl("lblPatientID")).Text;
        StringBuilder query = new StringBuilder();
        query.Append(" SELECT ID,SPLIT_STR(FileName,'_','1')FileName,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate,TIME_FORMAT(EntryDate,'%h:%i %p')EntryTime,UserID,Path,Type FROM cpoe_voicerecord ");
        query.Append(" WHERE PatientID='" + patientID + "' and date(EntryDate)!=curdate() and IsActive=1 ");

        if (rblType.SelectedItem.Text != "All")
        {
            query.Append(" AND Type='" + rblType.SelectedItem.Text + "' ");
        }

        DataTable dtdetail = StockReports.GetDataTable(query.ToString());
        if (dtdetail.Rows.Count > 0)
        {
            gridpredetail.DataSource = dtdetail;
            gridpredetail.DataBind();
        }
        else
        {
            gridpredetail.DataSource = null;
            gridpredetail.DataBind();
        }
    }

    private void BindGrids()
    {
        Label lblMsg = (Label)Parent.FindControl("lblMsg");
       
        BindCurrentData();
        BindPreviousData();

        if (griddetail.Rows.Count == 0 && gridpredetail.Rows.Count == 0)
        {
            lblMsg.Text = "Record Not Found";
        }
        else
        {
            lblMsg.Text = "";
        }
    }
    public static void Decompress(FileInfo fileToDecompress)
    {
        using (FileStream originalFileStream = fileToDecompress.OpenRead())
        {
            string currentFileName = fileToDecompress.FullName;
            string newFileName = currentFileName.Remove(currentFileName.Length - fileToDecompress.Extension.Length);
            using (FileStream decompressedFileStream = File.Create(newFileName + ".txt"))
            {
                using (GZipStream decompressionStream = new GZipStream(originalFileStream, CompressionMode.Decompress))
                {
                    decompressionStream.CopyTo(decompressedFileStream);
                }
            }
        }
    }
}