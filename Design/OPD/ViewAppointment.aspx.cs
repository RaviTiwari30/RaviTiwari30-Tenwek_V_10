using System;
using System.Data;
using System.Text;

public partial class Design_OPD_ViewAppointment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAppointmentDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtAppointmentdateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");            
            ViewState["UserID"] = Session["ID"].ToString();
        }
        txtAppointmentdateTo.Attributes.Add("readOnly", "true");
        txtAppointmentDateFrom.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        //PopUpQuery = "SELECT DISTINCT pm.Title,pm.PName, pm.PFirstName,pm.PLastName,pm.PatientID, pm.PatientID MRNo,Get_Current_Age(pm.PatientID)Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y') AS Date,pm.House_No,IFNULL(mobile,'') AS Contact_No,Email,pm.LanguageSpoken,CONCAT(pm.Title,'$',pm.pfirstname,'$',pm.PName,'$',pm.plastname,'$',pm.PatientID,'$',(SELECT Get_Current_Age(pm.PatientID)Age),'$',pm.Gender,'$',IFNULL(DATE_FORMAT(DateEnrolled,'%d-%b-%Y'),''),'$',IFNULL(pm.House_No,''),'$',IFNULL(pm.mobile,''),'$',IFNULL(pm.Email,''),'$',IFNULL(pm.City,''),'$',IFNULL(pm.DOB,''),'$',IFNULL(IsDob,''),'$',IFNULL(pm.LanguageSpoken,''),'$',IFNULL(Country,''),IFNULL(pm.PlaceOfBirth,''),'$',('Old Patient'))PatientData FROM patient_master pm WHERE pm.PatientID <> ''";



        sb.Append(" SELECT '' AppNo,PatientID,CONCAT(pm.Title,pm.PName)Name,'' DoctorName,'' VisitType,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y')AppDate,'' ConformDate,'' AppTime FROM patient_master pm WHERE pm.PatientID <> ''");




        //sb.Append(" SELECT PatientID,AppNo,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
        //sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        //sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%y')AppDate,DATE_FORMAT(ConformDate,'%d-%b-%y %l:%i %p')ConformDate FROM appointment app where IsConform=1 and PatientID<>''");

        if (txtPFirstName.Text != "")
        {
            sb.Append(" and PFirstName like '" + txtPFirstName.Text.Trim() + "%'");
        }
        else if (txtPLastname.Text != "")
        {
            sb.Append("  and PlastName like '" + txtPLastname.Text.Trim() + "%'");
        }
        else
        {
            //sb.Append(" and Date>='" + Util.GetDateTime(txtAppointmentDateFrom.Text).ToString("yyyy-MM-dd") + "'");
            //sb.Append(" and Date<='" + Util.GetDateTime(txtAppointmentdateTo.Text).ToString("yyyy-MM-dd") + "'");
            sb.Append(" and Date(DateEnrolled)>='" + Util.GetDateTime(txtAppointmentDateFrom.Text).ToString("yyyy-MM-dd") + "'");
            sb.Append(" and Date(DateEnrolled)<='" + Util.GetDateTime(txtAppointmentdateTo.Text).ToString("yyyy-MM-dd") + "'");
        }

        sb.Append(" order by PatientID");
       // sb.Append("  ORDER BY PatientID,DATE,TIME,AppNo");
        DataTable dtappList = StockReports.GetDataTable(sb.ToString());
        if (dtappList != null && dtappList.Rows.Count > 0)
        {
            grdAppointment.DataSource = dtappList;
            grdAppointment.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            grdAppointment.DataSource = "";
            grdAppointment.DataBind();
            lblMsg.Text = "Record Not Found";

        }
    }
}