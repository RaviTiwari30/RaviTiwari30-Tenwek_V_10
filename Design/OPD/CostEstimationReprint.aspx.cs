using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;



public partial class Design_OPD_CostEstimationReprint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            CalendarExtender1.EndDate = CalendarExtender2.EndDate = System.DateTime.Now;
        }

        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");


    }


    [WebMethod]
    public static string SearchCostEstimation(string patientID, string fromDate, string toDate, string costEstimationID)
    {

        var sqlCmd = new StringBuilder(" SELECT es.EstimationNumber id,es.PatientName,pm.PatientID,es.TotalEstimate,es.ContactNo,es.Address,es.Age FROM f_costestimationBilling  es ");
        sqlCmd.Append(" INNER JOIN patient_master pm ON es.PatientID=pm.PatientID   ");
        sqlCmd.Append(" WHERE es.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  ");

        if (!string.IsNullOrEmpty(patientID))
            sqlCmd.Append(" AND pm.PatientID=@patientID  GROUP BY es.PatientID ");
        else if (!string.IsNullOrEmpty(costEstimationID))
            sqlCmd.Append(" AND es.EstimationNumber=@costEstimationID  GROUP BY es.PatientID ");
        else
            sqlCmd.Append("  AND es.EntryDateTime>=@fromDate AND  es.EntryDateTime<=@toDate GROUP BY es.EstimationNumber ");

        ExcuteCMD excuteCMD = new ExcuteCMD();

        var sqlCMD = excuteCMD.GetRowQuery(sqlCmd.ToString(), new
        {
            patientID = Util.GetFullPatientID(patientID),
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
            costEstimationID = costEstimationID
        });


        var dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            patientID = Util.GetFullPatientID(patientID),
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59" ,
            costEstimationID = costEstimationID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }






}