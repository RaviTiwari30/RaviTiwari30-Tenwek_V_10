using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_IPD_nursing_diagnosis : System.Web.UI.Page
{
    private DataTable dtDetails;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();

            BindGroup();
            BindDetails();
        }

        lblMsg.Text = "";
    }

    protected void BindGroup()
    {
        DataTable dtGroup = StockReports.GetDataTable("SELECT DISTINCT(GroupName)GroupName FROM nanda_nursing_diagnosis WHERE IsActive = 1");

        if (dtGroup.Rows.Count > 0)
        {
            ddlGroupName.DataSource = dtGroup;
            ddlGroupName.DataTextField = "GroupName";
            ddlGroupName.DataValueField = "GroupName";
            ddlGroupName.DataBind();

            ddlGroupNamePopup.DataSource = dtGroup;
            ddlGroupNamePopup.DataTextField = "GroupName";
            ddlGroupNamePopup.DataValueField = "GroupName";
            ddlGroupNamePopup.DataBind();
            BindDiagnosis();
        }
    }

    protected void BindDiagnosis()
    {
        DataTable dtGroup = StockReports.GetDataTable("SELECT DiagnosisName FROM nanda_nursing_diagnosis WHERE GroupName='" + ddlGroupName.SelectedItem.Value + "' AND IsActive = 1 AND DiagnosisName IS NOT NULL");

        if (dtGroup.Rows.Count > 0)
        {
            ddlDiagnosisName.DataSource = dtGroup;
            ddlDiagnosisName.DataTextField = "DiagnosisName";
            ddlDiagnosisName.DataValueField = "DiagnosisName";
            ddlDiagnosisName.DataBind();
        }
    }

    protected void BindDetails()
    {
        DataTable dtDetails = StockReports.GetDataTable("SELECT ID,TransactionID,DATE_FORMAT(CreatedDate,'%d-%b-%Y %l:%i %p') AS EntryDate,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID = CreatedBy)EntryBy,Diagnosis,GroupName FROM patient_nursing_diagnosis WHERE TransactionID='" + ViewState["TransactionID"] + "' AND IsActive = 1 ORDER BY CreatedDate DESC");

        if (dtDetails.Rows.Count > 0)
        {
            grdDiagnosis.DataSource = dtDetails;
            grdDiagnosis.DataBind();
            ViewState["dtDetails"] = dtDetails;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string sql = "INSERT INTO patient_nursing_diagnosis (TransactionID,PatientID,GroupName,Diagnosis,CreatedBy,CreatedDate) VALUES('" + Util.GetString(ViewState["TransactionID"]) + "','" + Util.GetString(ViewState["PatientID"]) + "','" + Util.GetString(ddlGroupName.SelectedItem.Value) + "','" + Util.GetString(ddlDiagnosisName.SelectedItem.Value) + "','" + Util.GetString(ViewState["UserID"]) + "',NOW())";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            tnx.Commit();

            BindDetails();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
        }
        catch (Exception ex)
        {
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

    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (ViewState["dtDetails"] != null)
        {
            dtDetails = ((DataTable)ViewState["dtDetails"]);
            int id = Int32.Parse(dtDetails.Rows[e.RowIndex]["ID"].ToString());

            dtDetails.Rows.RemoveAt(e.RowIndex);
            ViewState["dtDetails"] = dtDetails as DataTable;

            string sql = "DELETE FROM patient_nursing_diagnosis WHERE ID=" + id + " ";
            StockReports.ExecuteDML(sql);

            grdDiagnosis.DataSource = dtDetails;
            grdDiagnosis.DataBind();
        }
    }

    protected void ddlGroupName_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDiagnosis();
    }

    protected void btnSaveGroupName_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string sql = "INSERT INTO nanda_nursing_diagnosis (GroupName,CreatedBy,CreatedDate) VALUES('" + Util.GetString(txtGroupName.Text.Trim()) + "','" + Util.GetString(ViewState["UserID"]) + "',NOW())";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            tnx.Commit();

            BindGroup();

            txtGroupName.Text = "";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
        }
        catch (Exception ex)
        {
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

    protected void btnSaveDiagnosis_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string sql = "INSERT INTO nanda_nursing_diagnosis (GroupName,DiagnosisName,CreatedBy,CreatedDate) VALUES('" + Util.GetString(ddlGroupNamePopup.SelectedItem.Value) + "','" + Util.GetString(txtDiagnosisName.Text.Trim()) + "','" + Util.GetString(ViewState["UserID"]) + "',NOW())";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            tnx.Commit();

            BindGroup();

            ddlGroupNamePopup.SelectedIndex = 0;
            txtDiagnosisName.Text = "";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
        }
        catch (Exception ex)
        {
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
}