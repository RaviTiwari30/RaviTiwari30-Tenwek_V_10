using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_Emergency_EMG_Services : System.Web.UI.Page
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
            DataTable dt = StockReports.GetDataTable("SELECT DATE(EnteredOn)StartDate,DATE(edp.BillingCleanTimeStamp)EndDate,edp.IsReleased,lt.BillNo FROM emergency_patient_details edp "+
                           " LEFT JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=edp.LedgerTransactionNo "+
                           " WHERE edp.TransactionId='"+ ViewState["transactionID"].ToString() +"' ");
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsReleased"].ToString() == "1")
                {
                    txtDate.Text = Util.GetDateTime(dt.Rows[0]["EndDate"]).ToString("dd-MMM-yyyy");
                    calucDate.EndDate = Util.GetDateTime(dt.Rows[0]["EndDate"].ToString());
                    calucDate.StartDate = Util.GetDateTime(dt.Rows[0]["StartDate"].ToString());
                }
                else if (dt.Rows[0]["IsReleased"].ToString() == "0") {
                    txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    calucDate.EndDate = DateTime.Now;
                    calucDate.StartDate = Util.GetDateTime(dt.Rows[0]["StartDate"].ToString());
                }
            }
        }
        txtDate.Attributes.Add("readOnly", "true");

    }



    [WebMethod(EnableSession = true)]
    public static string BindInvestigation(string transactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT (pt.Test_ID) ItemID, pt.PatientTest_ID, pt.IsIssue, IsUrgent, fit.Typename, IFNULL(pt.OutSource, 0) IsOutSource, pt.DoctorID, SUM(Quantity) Quantity, pt.ConfigID, fit.Type_id, IFNULL(fit.ItemCode,'')ItemCode, fit.`IsAdvance` `isadvance`, fit.`SubCategoryID`, ( CASE WHEN cr.ConfigID = 3 THEN 'LAB' WHEN cr.ConfigID IN (25) THEN 'PRO' WHEN cr.ConfigID IN (7) THEN 'BB' WHEN cr.ConfigID IN (20, 6) THEN 'OTH' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN 'OPD-BILLING' END ) LabType, ( CASE WHEN cr.ConfigID = 3 THEN '3' WHEN cr.ConfigID IN (25) THEN '4' WHEN cr.ConfigID IN (7) THEN '6' WHEN cr.ConfigID IN (20, 6) THEN '5' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN '16' END ) TnxType, (SELECT IF(TYPE = 'R', TYPE, 'N')  FROM Investigation_master WHERE Investigation_ID = fit.Type_ID) Sample,pt.Remarks FROM patient_test pt INNER JOIN f_itemmaster fit ON pt.test_id = fit.itemid INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = fit.SubCategoryID INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid  where pt.IsEmergencyData=1 and  pt.TransactionID='" + transactionID + "' AND pt.IsEmergencyData=1 ");
        sb.Append(" GROUP BY ItemID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}