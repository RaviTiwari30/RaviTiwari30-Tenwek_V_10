using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_OPD_TCSPatientData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            
        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
        txtDOB.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string SearchPatient(List<string> searchdata)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pmt.UHID,CONCAT(pmt.FIRSTNAME,' ',pmt.LASTNAME)PatientName,ifnull(pmt.NewPatientID,'')NewPatientID,v.BillingNumber,IFNULL(v.VisitType,'')VisitType,IFNULL(v.VisitID,'')VisitID,v.FileName,if(v.VisitDate = '0001-01-01 00:00:00','',v.VisitDate)VisitDate FROM patient_visit_tcs v ");
        sb.Append("INNER JOIN patient_master_tcs pmt ON pmt.UHID=v.UHID WHERE pmt.UHID<>'' ");
        if (!String.IsNullOrEmpty(searchdata[0].ToString()))
            sb.Append("AND pmt.UHID='" + searchdata[0].ToString() + "' ");
        if (!String.IsNullOrEmpty(searchdata[1].ToString()))
            sb.Append("AND CONCAT(pmt.FIRSTNAME,' ',pmt.LASTNAME) LIKE '%" + searchdata[1].ToString() + "%'  ");
        if (searchdata[2].ToString() != "0")
            sb.Append("AND v.VisitType='" + searchdata[2].ToString() + "' ");
        if (!String.IsNullOrEmpty(searchdata[5].ToString()))
            sb.Append("AND pmt.BirthDate='" + Util.GetDateTime(searchdata[5]).ToString("yyyy-MM-dd") + "' ");
        if (!string.IsNullOrEmpty(searchdata[3]))
            sb.Append("AND v.VisitDate>='" + Util.GetDateTime(searchdata[3]).ToString("yyyy-MM-dd") + " 00:00:00' ");
        if (!string.IsNullOrEmpty(searchdata[4]))
            sb.Append("AND v.VisitDate<='" + Util.GetDateTime(searchdata[4]).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" ORDER BY pmt.UHID,v.VisitDate DESC LIMIT 100 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found.", message = "No Record Found." });
    }
    [WebMethod]
    public static string MergeUHID(string newuhid, string olduhid)
    {
        try
        {
            bool check = StockReports.ExecuteDML("UPDATE patient_master_tcs t SET t.NewPatientID='" + newuhid.Trim() + "',MergedBy='" + HttpContext.Current.Session["ID"].ToString() + "',MergedDateTime=NOW() WHERE UHID='" + olduhid + "'");
            if (check)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully.", message = "Record Saved Successfully." });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Mapping UHID" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
    }
}