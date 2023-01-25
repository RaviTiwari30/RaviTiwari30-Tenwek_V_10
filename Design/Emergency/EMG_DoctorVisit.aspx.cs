using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_Emergency_EMG_DoctorVisit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["transactionID"] = HttpContext.Current.Request.QueryString["TID"].ToString();
            ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
            if (Resources.Resource.AllowFiananceIntegration == "1")//
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
                {
                    string Msga = "Patient Final Bill Already Posted To Finance...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
                }
            }
            DataTable dt = StockReports.GetDataTable("SELECT DATE(EnteredOn)StartDate,DATE(edp.BillingCleanTimeStamp)EndDate,edp.IsReleased,lt.BillNo FROM emergency_patient_details edp " +
                           " LEFT JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=edp.LedgerTransactionNo " +
                           " WHERE edp.TransactionId='" + ViewState["transactionID"].ToString() + "' ");
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsReleased"].ToString() == "1")
                {
                    txtDate.Text = Util.GetDateTime(dt.Rows[0]["EndDate"]).ToString("dd-MMM-yyyy");
                    calucDate.EndDate = Util.GetDateTime(dt.Rows[0]["EndDate"].ToString());
                    calucDate.StartDate = Util.GetDateTime(dt.Rows[0]["StartDate"].ToString());
                }
                else if (dt.Rows[0]["IsReleased"].ToString() == "0")
                {
                    txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    calucDate.EndDate = DateTime.Now;
                    calucDate.StartDate = Util.GetDateTime(dt.Rows[0]["StartDate"].ToString());
                }
            }
        }
        txtDate.Attributes.Add("readOnly", "true");

    }
}