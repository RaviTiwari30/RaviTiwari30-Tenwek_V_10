using System;
using System.Data;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_CPOE_PastHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            if(Request.QueryString["TID"]!=null)
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            if (Request.QueryString["TransactionID"] != null)
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            if (Request.QueryString["PID"] != null)
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            if (Request.QueryString["PatientId"] != null)
                ViewState["PID"] = Request.QueryString["PatientId"].ToString();
            BindData();
        }
    }
    protected void BindData()
    {
        DataTable dtdetail = StockReports.GetDataTable("SELECT PastHistoryEntryDate Date,Illnesses,Hospitalizations,Allergies,Medications,(SELECT CONCAT(Title,'',NAME)NAME FROM employee_master WHERE employeeID=pasthistoryentryby)NAME FROM cpoe_hpexam WHERE PatientID='" + ViewState["PID"].ToString() + "' ORDER BY PastHistoryEntryDate DESC ");
        if (dtdetail.Rows.Count > 0)
        {
            txtIllnesses.Text = dtdetail.Rows[0]["Illnesses"].ToString().Replace("@", "'");
            txtSurgeries.Text = dtdetail.Rows[0]["Hospitalizations"].ToString().Replace("@", "'");
            txtAllergies.Text = dtdetail.Rows[0]["Allergies"].ToString().Replace("@", "'");
            txtMedications.Text = dtdetail.Rows[0]["Medications"].ToString().Replace("@", "'");
            lblEntryBy.Text = dtdetail.Rows[0]["NAME"].ToString().Replace("@", "'");
            grid.DataSource = dtdetail;
            grid.DataBind();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM cpoe_hpexam WHERE TransactionID='" + ViewState["TID"].ToString() + "'"));
            if (ChkEntery > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE cpoe_hpexam SET Illnesses='" + txtIllnesses.Text.Replace("'", "@") + "',Hospitalizations='" + txtSurgeries.Text.Replace("'", "@") + "',Allergies='" + txtAllergies.Text.Replace("'", "@") + "',PastHistoryEntryBy='" + ViewState["UserID"].ToString() + "',PastHistoryEntryDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TID"].ToString() + "'");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO cpoe_hpexam(TransactionID,PatientID,Illnesses,Hospitalizations,Allergies,Medications,PastHistoryEntryBy,PastHistoryEntryDate)VALUE('" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + txtIllnesses.Text.Replace("'", "@") + "','" + txtSurgeries.Text.Replace("'", "@") + "','" + txtAllergies.Text.Replace("'", "@") + "','" + txtMedications.Text.Replace("'", "@") + "','" + ViewState["UserID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')");
            }
            tnx.Commit();
            BindData();
            lblMsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}