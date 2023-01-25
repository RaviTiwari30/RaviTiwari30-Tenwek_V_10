using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Web.Script.Serialization;
using System.Web.Script.Services;

using System.Web.UI;


public partial class Design_Emergency_EmergencyAdmission : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //((HtmlGenericControl)PatientInfo.FindControl("divApp")).Attributes.Add("style", "display:none");
       // ((HtmlTableRow)PatientInfo.FindControl("divAppointment")).Attributes.Add("style", "display:none");

        if (!IsPostBack)
        {
            txtAdmissionDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtAdmissionTimeHour.Text = System.DateTime.Now.ToString("hh");
            txtAdmissionTimeMinute.Text = System.DateTime.Now.ToString("mm");
            ddlAdmissionTimeMeridiem.SelectedIndex = ddlAdmissionTimeMeridiem.Items.IndexOf(ddlAdmissionTimeMeridiem.Items.FindByText(System.DateTime.Now.ToString("tt")));
            CalendarExteAdmissionDate.StartDate = System.DateTime.Now;
            CalendarExteAdmissionDate.EndDate = System.DateTime.Now;
        }
        txtAdmissionDate.Attributes.Add("readOnly", "readOnly");
        
    }
    [WebMethod (EnableSession=true)]
    public static string BindAdmissionDetails(string PatientID, string TransactionID)
    {
        DataTable dt = AllLoadData_IPD.bindAdmissionDetails(PatientID, TransactionID);
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Generate Name")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GenerateName1()
    {
        string name = StockReports.ExecuteScalar("SELECT max(ID)+1 as Name from patient_master ");
        return name;
    }
    [WebMethod(EnableSession = true)]
    public static string BindAllRoomDetail(string caseType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT CONCAT(RM.Name,'-',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) Name,RM.Room_Id  ");
        sb.Append(" FROM  room_master rm WHERE  IPDCaseTypeID='" + caseType + "' ");
       


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string bindEmergencyRoomType()
    {
        DataTable dt = AllLoadData_IPD.LoadCaseType();
        if (dt.Rows.Count > 0)
        {
            DataView RoomTypeView = dt.DefaultView;
            RoomTypeView.RowFilter = "IsEmergency='1'";
            return Newtonsoft.Json.JsonConvert.SerializeObject(RoomTypeView.ToTable());
        }
        else
            return "";
    }
    [WebMethod]
    public static string getCurrentDate() {

        return DateTime.Now.ToString("dd-MMM-yyyy");
    }

    public static string PatientFromTriage()
    {
        DataTable dt = StockReports.GetDataTable("SELECT COUNT(*) FROM cpoe_transfertoemergency WHERE IsPatientAdmitted=0");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}