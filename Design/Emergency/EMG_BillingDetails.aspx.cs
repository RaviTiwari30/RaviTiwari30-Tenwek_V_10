using System;
using System.Collections.Generic;
using System.Linq;

using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Emergency_EMG_BillingDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["transactionID"] = Request.QueryString["TID"].ToString();
            ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
	   if (Session["ID"].ToString() != "LSHHI446")
            {
                if (Resources.Resource.AllowFiananceIntegration == "1")//
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
                    {
                        string Msga = "Patient Final Bill Already Posted To Finance...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
                    }
                }
		}
            txtDeathofDate.Text= DateTime.Now.ToString("dd-MMM-yyyy");
            caldate.EndDate = DateTime.Now;
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            AllLoadData_IPD.bindDischargeType(ddlReleaseType);
            ddlReleaseType.Items.Add(new ListItem("Patient Discharge Without Bill", "Patient Discharge Without Bill"));
            ddlReleaseType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            AllLoadData_IPD.bindTypeOfDeath(ddltypeOfDeath);
            string status = Util.GetString(StockReports.ExecuteScalar("SELECT pmh.STATUS FROM patient_medical_history pmh WHERE pmh.TransactionID='" + ViewState["transactionID"].ToString() + "' "));
            
            lblDischargeStatus.Text = status.ToString();
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string pid = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "(SELECT PatientID FROM patient_medical_history WHERE  transactionid='" + ViewState["transactionID"].ToString() + "' LIMIT 1)").ToString();
            ViewState["pid"] = pid;
            tnx.Commit();
            con.Close();
            txtDeathofDate.Attributes.Add("readOnly", "readOnly");
        }
        catch (Exception ex)
        {
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