using System;
using System.Collections.Generic;
using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web.Services;

public partial class Design_IPD_GetReqforProceduresForIPDpatients : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Calendarextender1.EndDate = System.DateTime.Now;
            Calendarextender2.EndDate = System.DateTime.Now;
        }
        ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string GetPatientBookingDetails(string RoomType, string PID, string TID, string Fromdate, string Todate)
    {
        Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        DataTable dt = Getdata(RoomType, PID, TID, Fromdate, Todate); 

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Pstatus = true, Sstatus = true, PatientList = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Pstatus = false, Sstatus = false, response = "No Record Found" });
        }
    }

    public static DataTable Getdata(string RoomType, string PID, string TID, string Fromdate, string Todate)
    {
        StringBuilder query = new StringBuilder();

        // Note: In this Query, below SubcategoryId is hard code(78) for Orthopaedic Dept Only. As per client Requirement. 

        query.Append(" SELECT DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,pm.PatientID AS UHID,CONCAT(pm.Title,' ',pm.PName)PName,  ");
        query.Append(" pm.Age,pm.Gender,pmh.TransNo IPDNo,CONCAT(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)Ward,ltd.ItemName,ltd.Quantity,sm.Name SubCat, ");
        query.Append(" (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID LIMIT 1)Doctorname,");
        query.Append(" CONCAT(em.Title,' ',em.Name)EntryBy FROM f_ledgertnxdetail ltd  ");
        query.Append(" INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
        query.Append(" INNER JOIN employee_master em ON ltd.UserID = em.EmployeeID   ");
        query.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = ltd.SubCategoryID  ");
        query.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ");
        query.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
        query.Append(" INNER JOIN patient_ipd_profile pip ON pmh.TransactionId=pip.TransactionID  AND pip.STATUS='IN' ");
        query.Append(" INNER JOIN room_master rm ON rm.RoomID= pip.RoomID ");
        query.Append(" INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID   ");
        query.Append(" WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND sm.subCategoryID = '78' AND pmh.Type IN ('IPD') ");
        query.Append(" AND Date(lt.Date) >= '" + Fromdate + "' AND Date(lt.Date) <= '" + Todate + "'  ");

        if (!string.IsNullOrEmpty(RoomType) && RoomType != "0")
        {
            query.Append(" AND icm.IPDCaseTypeID='" + RoomType + "' ");
        }
        if (!string.IsNullOrEmpty(PID))
        {
            query.Append(" AND pmh.PatientID='" + PID + "' ");
        }
        if (!string.IsNullOrEmpty(TID))
        {
            query.Append(" AND pmh.TransNo='" + TID + "' ");
        }
        query.Append(" ORDER BY ltd.ID Desc ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        return dt;
    }

    [WebMethod(EnableSession = true)]
    public static string GetPatientBookingReport (string RoomType, string PID, string TID, string Fromdate, string Todate)
    {
        Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        DataTable dt = Getdata(RoomType, PID, TID, Fromdate, Todate);      

        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();

            HttpContext.Current.Session["ReportName"] = "IPD Procedures Request Report";
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["Period"] = "Period From Date : " + Fromdate + " To Date : " + Todate;

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dt });
    }

}