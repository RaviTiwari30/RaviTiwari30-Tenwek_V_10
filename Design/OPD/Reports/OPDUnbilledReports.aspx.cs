using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;



public partial class Design_OPD_OPDUnbilledReports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            CalendarExteFromDate.EndDate = System.DateTime.Now;
            CalendarExtenderToDate.EndDate = System.DateTime.Now;

            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtToDate.Attributes.Add("readonly", "true");
        txtFromDate.Attributes.Add("readonly", "true");


    }


    [WebMethod]
    public static string GetUnbilled(string fromDate, string toDate, string patientID, int searchType, string doctorID)
    {
        StringBuilder sqlCMD = new StringBuilder();
        var searchParams = new
         {
             fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
             toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
             patientID = Util.GetFullPatientID(patientID),
             doctorID = doctorID
         };
        if (searchType == 0 || searchType == 2)
        {
            sqlCMD.Append(" SELECT  CONCAT(dm.Title,' ',dm.Name) DoctorName,CONCAT(pm.Title,' ',pm.PName)PatientName, cm.PatientID ,im.TypeName ItemName,sd.SoldUnits Quantity ,DATE_FORMAT(sd.Date,'%d-%b-%Y') `Date` ,'Consumables' Type  FROM patient_consumables cm  ");
            sqlCMD.Append(" INNER JOIN f_salesdetails sd ON sd.SalesID=cm.SalesID ");
            sqlCMD.Append(" INNER JOIN f_itemmaster im  ON im.ItemID=sd.ItemID ");
            sqlCMD.Append(" INNER JOIN appointment ap ON ap.App_ID=cm.App_ID ");
            sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=ap.DoctorID  ");
            sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID=cm.PatientID ");
            sqlCMD.Append(" WHERE sd.LedgertransactionNo = 0   ");
            sqlCMD.Append(" and (sd.Date)>=@fromDate  AND (sd.Date)<= @toDate ");
            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" and pm.PatientID=@patientID");

            if (!string.IsNullOrEmpty(doctorID))
                sqlCMD.Append(" and dm.DoctorID=@doctorID");
        }
        if (searchType == 0)
        {
            sqlCMD.Append(" UNION ALL ");
        }
        if (searchType == 0 || searchType == 1)
        {

            sqlCMD.Append(" SELECT CONCAT(dm.Title,' ',dm.Name) DoctorName,CONCAT(ap.Title,' ',ap.PName)PatientName, ap.PatientID PatientID ,sm.name ItemName , ");
            sqlCMD.Append(" (ap.App_ID) AppointmentNo,  ");
            sqlCMD.Append(" DATE_FORMAT(ap.Date,'%d-%b-%Y') `Date` ,'Appointment' Type  ");
            sqlCMD.Append(" FROM appointment ap                         ");
            sqlCMD.Append(" INNER JOIN f_itemmaster im ON ap.ItemID=im.ItemID ");
            sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=ap.DoctorID ");
            sqlCMD.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID ");
            sqlCMD.Append(" WHERE ap.IsConform=1 AND ap.LedgerTnxNo=0 AND ap.PatientID <> ''  ");
            sqlCMD.Append(" and ap.Date>=@fromDate  AND ap.Date<= @toDate ");
            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" and ap.PatientID=@patientID");

            if (!string.IsNullOrEmpty(doctorID))
                sqlCMD.Append(" and dm.DoctorID=@doctorID");
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dataTable = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, searchParams);
        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), searchParams);
        if (dataTable.Rows.Count > 0)
        {
            HttpContext.Current.Session["ReportName"] = "Unbilled Item Service Report";
            HttpContext.Current.Session["dtExport2Excel"] = dataTable;
            HttpContext.Current.Session["Period"] = "From " + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(toDate).ToString("yyyy-MM-dd");
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dataTable });

    }
}