using System;
using System.Text;
using System.Data;
using System.Web.Services;

public partial class Design_HelpDesk_HelpDeskOPD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientID.Focus();
            

            txtFDSearch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTDSearch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            Fromdatecal.EndDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now;
        }
        txtFDSearch.Attributes.Add("readOnly","true");
        txtTDSearch.Attributes.Add("readOnly", "true");
    }
    [WebMethod]
    public static string BindOPDDetail(string PatientID, string Name, string ContactNo, string City, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pm.PatientID,pm.PName, ");
        sb.Append("CONCAT(IF(pm.House_No<>'',CONCAT(pm.House_No,','),''),IF(pm.City<>'', ");
        sb.Append("CONCAT(pm.City,','),''),IF(pm.District<>'',CONCAT(pm.District,','),''),IF(pm.Country<>'',pm.Country,''))Address,pm.Mobile ContactNo, ");
        sb.Append("pm.Gender,Date_Format(pmh.DateOfVisit,'%d-%b-%Y') Dateofvisit,dm.NAME DName  ");
        sb.Append("FROM patient_medical_history pmh  ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
        sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
        sb.Append("WHERE pm.Active=1 AND pmh.DateOfVisit>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND pmh.DateOfVisit<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        if (!string.IsNullOrEmpty(ContactNo)) {
            sb.Append(" AND pm.Mobile ='"+ ContactNo.Trim() +"' ");
        }
        if (!string.IsNullOrEmpty(Name)) {
            sb.Append(" AND pm.PName LIKE '%" + ContactNo.Trim() + "%' ");
        }
        if (!string.IsNullOrEmpty(PatientID))
        {
            sb.Append(" AND pm.PatientID = '" + Util.GetFullPatientID(PatientID) + "' ");
        }
        if (!string.IsNullOrEmpty(City))
        {
            sb.Append(" AND pm.City = '" + City + "' ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}