


using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class Design_Emergency_EmergencyComplaint : System.Web.UI.Page
{
    protected void BindData(string TID)
    {
        try
        {
            string alert = StockReports.ExecuteScalar("SELECT Complaint FROM emergency_patient_details WHERE TransactionID='" + TID + "'");
            if (alert != "")
            {
                txtComplaint.Text = alert.Replace("@", "'");
            }
            else
            {
                txtComplaint.Text = "";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM Emergency_Patient_Details WHERE TransactionID='" + ViewState["TID"].ToString() + "'"));
            if (ChkEntery > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Emergency_Patient_Details SET Complaint='" + txtComplaint.Text.Replace("'", "@").Trim() + "' WHERE TransactionID='" + ViewState["TID"].ToString() + "'");
            }
            else
            {
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO cpoe_Assessment(TransactionID,PatientID,IllnessHistory,IllnessHistoryCreatedBy,IllnessHistoryCreatedDate)VALUE('" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + txtHistory.Text.Replace("'", "@").Trim() + "','" + ViewState["UserID"].ToString() + "',now())");
            }
            tnx.Commit();
            BindData(ViewState["TID"].ToString());
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                ViewState["UserID"] = Session["ID"].ToString();
                ViewState["TID"] = Request.QueryString["TID"].ToString();
                ViewState["PID"] = Request.QueryString["PID"].ToString();
                BindData(ViewState["TID"].ToString());
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}