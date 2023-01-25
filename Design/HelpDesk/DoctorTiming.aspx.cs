using System;
using System.Text;
using System.Data;
using System.Web;
using System.Web.Services;
public partial class Design_HelpDesk_DoctorTiming : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {        
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "All");
            All_LoadData.bindDocTypeList(ddlSpecialization, 3, "All");
            txtAppDate.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy");
            txtAppointmentSlotDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ViewState["CentreID"] = Session["CentreID"].ToString();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindDoctorCentrewise(string CentreID, string Department, string Specilization)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))Name,dm.Designation Department,dm.DocDepartmentID,dm.Specialization,dm.docGroupID, ");
        sb.Append("dm.IsDocShare,dm.IsEmergencyAvailable  FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 ");
        if (CentreID != "0")
            sb.Append("AND fcp.CentreID=" + CentreID + " ");
        if (Department != "0")
            sb.Append("AND dm.DocDepartmentID='" + Department + "' ");
        if (Specilization != "All")
            sb.Append("AND dm.Specialization='" + Specilization + "' ");
        sb.Append(" AND fcp.isActive=1 Group By dm.DoctorID ORDER BY dm.name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}