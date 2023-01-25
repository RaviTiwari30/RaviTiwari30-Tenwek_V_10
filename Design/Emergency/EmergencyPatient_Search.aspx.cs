using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Web.Services;

public partial class Design_Emergency_EmergencyPatient_Search : System.Web.UI.Page
{
    [WebMethod]
    public static string bindEmerDetail(string fromDate, string toDate, string PatientID, string PName, string status, string Doctor)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT app.App_ID,CONCAT(dm.title,' ',dm.Name)DName,dm.DoctorID,pm.PatientID,pm.PName,DATE_FORMAT(app.Date,'%d-%b-%Y')AppDate,pm.Gender Sex,pm.Mobile ContactNo,pm.Age,app.IsView,app.EmerIsDischarge, ");
        sb.Append("  app.TransactionID,app.LedgerTnxNo FROM Appointment app INNER JOIN patient_master pm ON pm.PatientID=app.PatientID ");
        sb.Append("  INNER JOIN Doctor_master dm on dm.DoctorID=app.DoctorID");
        sb.Append("  WHERE app.IsConform =1 AND app.IsCancel=0 AND LedgerTnxNo<>''  AND  app.subcategoryID='" + HttpContext.GetGlobalResourceObject("Resource", "EmergencySubcategoryID").ToString() + "' ");
        sb.Append(" AND app.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (status != "0")
        {
            if (fromDate != string.Empty)
                sb.Append(" AND app.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'");
            if (toDate != string.Empty)
                sb.Append(" AND app.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");
        }
        if (PName.Trim() != string.Empty)
            sb.Append(" AND pm.Pname like '%" + PName.Trim() + "%'");
        if (PatientID.Trim() != string.Empty)
            sb.Append(" AND pm.PatientID='" + PatientID.Trim() + "' ");
        if (Doctor != "0")
            sb.Append(" AND dm.DoctorID ='" + Doctor + "'");
        sb.Append(" AND app.EmerIsDischarge='" + status + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            toDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtRegNo.Focus();
            BindDoctor();
        }
        fromDate.Attributes.Add("readonly", "readonly");
        toDate.Attributes.Add("readonly", "readonly");
    }
    private void BindDoctor()
    {
        DataTable dt = EDPReports.GetConsultantsWithoutTitle();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "text";
            ddlDoctor.DataValueField = "value";
            ddlDoctor.DataBind();
            ddlDoctor.Items.Insert(0, new ListItem("--------", "0"));
        }
    }
    private void GetDoctor()
    {
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR")
        {
            string str = StockReports.ExecuteScalar("SELECT DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'");

            if (str != null)
                ddlDoctor.Text = Util.GetString(str);
            ddlDoctor.Enabled = false;
        }
    }
}