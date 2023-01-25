using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_AdvanceRoomBookingSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblUserID.Text = Session["ID"].ToString();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txtRescheduleDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }

        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
        txtRescheduleDate.Attributes.Add("readOnly", "readOnly");
        cdRescheduleDate.StartDate = System.DateTime.Now;

    }

    [WebMethod(Description = "Search Advance Room Booking")]
    public static string SearchAdvanceBooking(string mrNo, string roomType, string firstName, string lastName, string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT arb.PatientAdvance,arb.ReceiptNo,arb.ID,pm.PatientID,arb.RoomID AS Room_ID, arb.IPDCaseTypeID AS IPDCaseType_ID,pm.PName,pm.Age,pm.Gender,pm.Mobile,DATE_FORMAT(arb.BookingDate,'%d-%b-%y')BookingDate,CONCAT(rm.Name,'-',rm.Room_No,'-',rm.Bed_No)RoomName,ict.Name AS RoomType, ");
        query.Append(" CONCAT(em.Title,' ',em.Name) AS EntryBy,DATE_FORMAT(arb.EntryDate,'%d-%b-%y')EntryDate,arb.Remarks,arb.IsCancel,IFNULL(DATE_FORMAT(arb.CancelDate,'%d-%b-%Y'),'')CancelDate, ");
        query.Append(" IFNULL((SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE employeeid=arb.CancelBy),'')CancelBy,IFNULL(arb.CancelReason,'')CancelReason, ");
        query.Append(" arb.IsRescheduled,IFNULL(DATE_FORMAT(arb.RescheduledDate,'%d-%b-%Y'),'')RescheduledDateTime, ");
        query.Append(" IFNULL((SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE employeeid=arb.RescheduledBy),'')RescheduledBy, ");
        query.Append(" IFNULL(arb.RescheduledReason,'')RescheduledReason,  ");
        query.Append(" arb.IsAdmitted,IFNULL(DATE_FORMAT(arb.AdmittedDateTime,'%d-%b-%Y'),'')AdmittedDateTime, ");
        query.Append(" IFNULL((SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE employeeid=arb.AdmittedBy),'')AdmittedBy, ");
        query.Append(" IF(arb.IsRescheduled=0 AND arb.IsAdmitted=0 AND arb.IsCancel=0 AND BookingDate<CURDATE(),1, ");
        query.Append(" IF(arb.IsRescheduled=1 AND arb.IsAdmitted=0 AND arb.IsCancel=0 AND RescheduledDate<CURDATE(),1,0))IsExpired ,Replace(arb.TransactionID,'ISHHI','')TransactionID ");
        query.Append(" FROM advance_room_booking arb INNER JOIN patient_master pm ON arb.PatientID=pm.PatientID LEFT JOIN room_master rm ON arb.RoomID=rm.RoomId ");
        query.Append(" INNER JOIN ipd_case_type_master ict ON ict.IPDCaseTypeID = arb.IPDCaseTypeID INNER JOIN employee_master em ON em.EmployeeID=arb.EntryBy ");
        query.Append(" WHERE arb.CentreID="+ HttpContext.Current.Session["CentreID"].ToString() +" AND arb.BookingDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND arb.BookingDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        if (mrNo != "")
        {
            query.Append(" AND arb.PatientID='" + Util.GetFullPatientID(mrNo) + "' ");
        }

        if (roomType != "0")
        {
            query.Append(" AND arb.IPDCaseTypeID='" + roomType + "' ");
        }

        if (firstName != "")
        {
            query.Append(" AND pm.PFirstName LIKE '" + firstName + "%' ");
        }

        if (lastName != "")
        {
            query.Append(" AND pm.PLastName LIKE '" + lastName + "%' ");
        }

        query.Append(" ORDER BY arb.BookingDate DESC LIMIT 500 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(Description = "")]
    public static string CancelAdvanceBooking(string id, string cancelReason, string userID)
    {
        string result = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            string query = "UPDATE advance_room_booking SET IsCancel=1,CancelBy='" + userID + "',CancelDate=NOW(),CancelReason='" + cancelReason + "' WHERE ID='" + id + "'";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, query);
            tranx.Commit();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }

        return result;
    }

    [WebMethod]
    public static string RescheduleAdvanceBooking(string id, string rescheduleReason, string userID, string rescheduleDate,string RoomID)
    {
        string result = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            string query = "UPDATE advance_room_booking SET IsRescheduled=1,RescheduledBy='" + userID + "',RescheduledDateTime=NOW(),RescheduledReason='" + rescheduleReason + "',RescheduledDate='" + Util.GetDateTime(rescheduleDate).ToString("yyyy-MM-dd") + "',RoomID='" + RoomID + "' WHERE ID='" + id + "'";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, query);
            tranx.Commit();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }

        return result;
    }

}