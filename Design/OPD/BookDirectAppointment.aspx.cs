using System;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Text;
using System.Web.Services;
using Newtonsoft.Json;
using System.Collections.Generic;

public partial class Design_OPD_BookDirectAppointment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            txtAppointmentOn.Text = txtAppointmentSlotDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["IsDiscount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsDiscount");
            ViewState["CanViewVitalPopUp"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "CanViewVitalPopUp");
        }
        txtAppointmentOn.Attributes.Add("readOnly", "readOnly");
        txtAppointmentSlotDate.Attributes.Add("readOnly", "readOnly");
        calendarExteAppointmentOn.StartDate = DateTime.Now;
        calendarExteAppointmentSlotDate.StartDate = DateTime.Now;
    }
    [WebMethod]
    public static string bindAppDetail(string DocGroupID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT t0.DoctorID,t0.DoctorName,IFNULL(t0.TotalPatient,0)TotalPatient,IFNULL(t1.PendingPatient,0)PendingPatient,IFNULL(t2.ViewedPatient,0)ViewedPatient FROM ( ");
        sb.Append("SELECT t.DoctorID,t.DoctorName,t.TotalPatient FROM  ");
        sb.Append("(SELECT app.DoctorID,CONCAT(dm.Title,'',dm.Name)DoctorName,COUNT(App_ID)TotalPatient ");
        sb.Append("FROM appointment app INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ");
        sb.Append("WHERE  DATE=DATE(NOW()) AND DocGroupID='" + DocGroupID + "' AND app.iscancel=0 ");
        sb.Append("GROUP BY app.DoctorID)t GROUP BY t.DoctorID)t0 ");
        sb.Append("LEFT JOIN ( ");
        sb.Append("SELECT t.DoctorID,t.DoctorName,t.PendingPatient FROM  ");
        sb.Append("(SELECT app.DoctorID,CONCAT(dm.Title,'',dm.Name)DoctorName,COUNT(App_ID)PendingPatient ");
        sb.Append("FROM appointment app INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ");
        sb.Append("WHERE  DATE=DATE(NOW()) AND app.isview=0  AND DocGroupID='" + DocGroupID + "' AND app.iscancel=0 ");
        sb.Append("GROUP BY app.DoctorID)t GROUP BY t.DoctorID)t1 ON t1.DoctorID=t0.DoctorID  ");
        sb.Append("LEFT JOIN ( ");
        sb.Append("SELECT t.DoctorID,t.DoctorName,t.ViewedPatient FROM  ");
        sb.Append("(SELECT app.DoctorID,CONCAT(dm.Title,'',dm.Name)DoctorName,COUNT(App_ID)ViewedPatient ");
        sb.Append("FROM appointment app INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ");
        sb.Append("WHERE  DATE=DATE(NOW()) AND app.isview=1  AND DocGroupID='" + DocGroupID + "' AND app.iscancel=0 ");
        sb.Append("GROUP BY app.DoctorID)t GROUP BY t.DoctorID)t2 ON t2.DoctorID=t0.DoctorID  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }


    [WebMethod]
    public static string GetDoctorAppointmentTimeSlotConsecutive(string DoctorId, string _appointmentDate, string appointmentType, string centreId, string AppSlot, string IsManualSlot)
    {
        try
        {
            List<String> consecutiveDate = new List<string>();
            consecutiveDate.Add(Util.GetDateTime(_appointmentDate).ToString("yyyy-MM-dd"));
            consecutiveDate.Add(Util.GetDateTime(_appointmentDate).AddDays(1).ToString("yyyy-MM-dd"));
            consecutiveDate.Add(Util.GetDateTime(_appointmentDate).AddDays(2).ToString("yyyy-MM-dd"));
            consecutiveDate.Add(Util.GetDateTime(_appointmentDate).AddDays(3).ToString("yyyy-MM-dd"));
            consecutiveDate.Add(Util.GetDateTime(_appointmentDate).AddDays(4).ToString("yyyy-MM-dd"));
            consecutiveDate.Add(Util.GetDateTime(_appointmentDate).AddDays(5).ToString("yyyy-MM-dd"));
            List<object> slotDetails = new List<object>();
            for (int i = 0; i < consecutiveDate.Count; i++)
            {

               string appointmentDate=consecutiveDate[i];

                string LeaveQuery = "SELECT COUNT(*)OnLeave FROM Pay_Leave_Master pl WHERE pl.IsActive=1 AND pl.`Date`='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' AND pl.`DoctorID`='" + DoctorId + "'";
                int IsLeave = Util.GetInt(StockReports.ExecuteScalar(LeaveQuery));
                if (IsLeave > 0)
                {
                    slotDetails.Add(new { status = false, response = "<div style='color:brown' class='bold textCenter'>Doctor on Leave.</div>", appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
                    continue;
                }
                LeaveQuery = "SELECT ph.`HolidaysName` FROM holidays_details ph WHERE ph.`IsActive`=1 AND ph.`HolidaysDate`='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' ";
                string holidaysName = Util.GetString(StockReports.ExecuteScalar(LeaveQuery));
                if (!string.IsNullOrEmpty(holidaysName))
                {
                    slotDetails.Add(new { status = false, response = "<div style='color:brown' class='bold textCenter'>Public Holiday<br/>" + holidaysName + "</div>" ,appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
                    continue;
                }

                //var startTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' "));
                //if (string.IsNullOrWhiteSpace(startTime))
                //    startTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' and Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' "));
                //var endTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' "));
                //if (string.IsNullOrWhiteSpace(endTime))
                //    endTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' and Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' "));

                DateTime startDateTime = new DateTime();
                DateTime endDateTime = new DateTime();
                DataTable dtDoctorSlot = new DataTable();
                string Query = " SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName,DurationForOldPatient FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' and CentreID='" + centreId + "' ";
                dtDoctorSlot = StockReports.GetDataTable(Query);

                if (dtDoctorSlot == null || dtDoctorSlot.Rows.Count == 0)
                {
                    dtDoctorSlot = StockReports.GetDataTable(" SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' AND Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' and CentreID='" + centreId + "'  ");
                }
                else
                {
                    if (IsManualSlot == "0")
                        AppSlot = dtDoctorSlot.Rows[0]["DurationForOldPatient"].ToString();
                }
                DataTable dtBookDetail = StockReports.GetDataTable("SELECT a.Time,  CONCAT(Title, ' ', PName) NAME,  a.IsConform FROM  appointment a WHERE a.DoctorID = '" + DoctorId + "'   AND a.Date = '" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'   AND a.IScancel =0  ");

                DataTable dtMobileApplicationBookedAppointments = StockReports.GetDataTable("SELECT app.StartTime,app.AppointmentDate FROM app_appointment app WHERE app.AppointmentDate='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'");

                DataTable dtDoctorNotAvailableDetail = StockReports.GetDataTable("SELECT d.FromTime,d.ToTime FROM doctor_notavailable_datewise d  WHERE  d.isActive=1 and d.DoctorID = '" + DoctorId + "'   AND d.Date = '" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' and CentreID='" + centreId + "' ");

                // int flag = 0;
                string output = string.Empty;
                string defaultAvilableSlot = string.Empty;
                if (Util.GetDateTime(appointmentDate).Date >= System.DateTime.Now.Date)
                {
                    foreach (DataRow drSlot in dtDoctorSlot.Rows)
                    {
                        startDateTime = Util.GetDateTime(drSlot["StartTime"].ToString());
                        endDateTime = Util.GetDateTime(drSlot["EndTime"].ToString());
                        string slots = GetSlotDateWise(dtDoctorNotAvailableDetail, dtBookDetail, dtMobileApplicationBookedAppointments, startDateTime, endDateTime, appointmentDate, defaultAvilableSlot, out defaultAvilableSlot, AppSlot);
                        if (slots != "")
                        {
                            slots = "<div class='row' ><div  class='col-md-24' ><b class='modal-title'># " + drSlot["ShiftName"].ToString() + "<br /><hr /><b /></div>" + slots + "</div>";
                            output += slots;
                        }
                    }

                    if (string.IsNullOrWhiteSpace(output) && Util.GetInt(appointmentType) == 4)
                    {
                        DateTime lastBookedSlotTime = DateTime.Now;
                        var lastBookedSlot = StockReports.ExecuteScalar(" SELECT ad.Time FROM appointment_detail ad INNER JOIN appointment a ON ad.app_ID=a.App_ID WHERE ad.DoctorID='" + DoctorId + "' AND ad.Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' AND ad.IScancel=0 ORDER BY ad.`ID` DESC LIMIT 1 ");
                        if (lastBookedSlot != "")
                        {
                            lastBookedSlotTime = Util.GetDateTime(lastBookedSlot);
                        }
                        slotDetails.Add(new { status = true, response = "<div style='color:brown' class='bold textCenter'>Slot Not Avilable.</div>", defaultAvilableSlot = lastBookedSlotTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt"), appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
                    }
                    else if (string.IsNullOrWhiteSpace(output))
                        slotDetails.Add(new { status = false, response = "<div style='color:brown' class='bold textCenter'>Slot Not Avilable.</div>", appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
                    else
                        slotDetails.Add(new { status = true, response = output, defaultAvilableSlot = defaultAvilableSlot, appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
                }
                else
                    slotDetails.Add(new { status = false, response = "<div style='color:brown' class='bold textCenter'>Invalid Appointment Date.</div>", appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
            }


            return JsonConvert.SerializeObject(new { status = true, response = slotDetails });

        }
        catch (Exception ex)
        {
            
                return JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }






    [WebMethod]
    public static string GetDoctorAppointmentTimeSlot(string DoctorId, string appointmentDate, string appointmentType, string centreId, string AppSlot, string IsManualSlot)
    {
        try
        {
            string LeaveQuery = "SELECT COUNT(*)OnLeave FROM Pay_Leave_Master pl WHERE pl.IsActive=1 AND pl.`Date`='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' AND pl.`DoctorID`='" + DoctorId + "'";
            int IsLeave = Util.GetInt(StockReports.ExecuteScalar(LeaveQuery));
            if (IsLeave > 0)
                return JsonConvert.SerializeObject(new { status = false, response = "Doctor on Leave" });

            LeaveQuery = "SELECT ph.`HolidaysName` FROM holidays_details ph WHERE ph.`IsActive`=1 AND ph.`HolidaysDate`='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' ";
            string HolidaysName = Util.GetString(StockReports.ExecuteScalar(LeaveQuery));
            if (HolidaysName != "" )
                return JsonConvert.SerializeObject(new { status = false, response = "Public Holiday <span class='patientInfo'>'" + HolidaysName + "'</span> on Selected Date " });


            //var startTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' "));
            //if (string.IsNullOrWhiteSpace(startTime))
            //    startTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' and Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' "));
            //var endTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' "));
            //if (string.IsNullOrWhiteSpace(endTime))
            //    endTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' and Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' "));

            DateTime startDateTime = new DateTime();
            DateTime endDateTime = new DateTime();
            DataTable dtDoctorSlot = new DataTable();
            string Query = " SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName,DurationForOldPatient FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' and CentreID='" + centreId + "' ";
            dtDoctorSlot = StockReports.GetDataTable(Query);

            if (dtDoctorSlot == null || dtDoctorSlot.Rows.Count == 0)
            {
                dtDoctorSlot = StockReports.GetDataTable(" SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' AND Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' and CentreID='" + centreId + "'  ");
            }
            else
            {
                if (IsManualSlot == "0")
                AppSlot = dtDoctorSlot.Rows[0]["DurationForOldPatient"].ToString();
            }
            DataTable dtBookDetail = StockReports.GetDataTable("SELECT a.Time,  CONCAT(Title, ' ', PName) NAME,  a.IsConform FROM  appointment a WHERE a.DoctorID = '" + DoctorId + "'   AND a.Date = '" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'   AND a.IScancel =0  ");

            DataTable dtMobileApplicationBookedAppointments = StockReports.GetDataTable("SELECT app.StartTime,app.AppointmentDate FROM app_appointment app WHERE app.AppointmentDate='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'");

            DataTable dtDoctorNotAvailableDetail = StockReports.GetDataTable("SELECT d.FromTime,d.ToTime FROM doctor_notavailable_datewise d  WHERE  d.isActive=1 and d.DoctorID = '" + DoctorId + "'   AND d.Date = '" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' and CentreID='" + centreId + "' ");

            // int flag = 0;
            string output = string.Empty;
            string defaultAvilableSlot = string.Empty;
            if (Util.GetDateTime(appointmentDate).Date >= System.DateTime.Now.Date)
            {
                foreach (DataRow drSlot in dtDoctorSlot.Rows)
                {
                    startDateTime = Util.GetDateTime(drSlot["StartTime"].ToString());
                    endDateTime = Util.GetDateTime(drSlot["EndTime"].ToString());
                    string slots = GetSlotDateWise(dtDoctorNotAvailableDetail, dtBookDetail, dtMobileApplicationBookedAppointments, startDateTime, endDateTime, appointmentDate, defaultAvilableSlot, out defaultAvilableSlot, AppSlot);
                    if (slots != "")
                    {
                        slots = "<div class='row' ><div  class='col-md-24' ><b class='modal-title'># " + drSlot["ShiftName"].ToString() + "<br /><hr /><b /></div>" + slots + "</div>";
                        output += slots;
                    }
                }

                if (string.IsNullOrWhiteSpace(output) && Util.GetInt(appointmentType) == 4)
                {
                    DateTime lastBookedSlotTime = DateTime.Now;
                    var lastBookedSlot = StockReports.ExecuteScalar(" SELECT ad.Time FROM appointment_detail ad INNER JOIN appointment a ON ad.app_ID=a.App_ID WHERE ad.DoctorID='" + DoctorId + "' AND ad.Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' AND ad.IScancel=0 ORDER BY ad.`ID` DESC LIMIT 1 ");
                    if (lastBookedSlot != "")
                    {
                         lastBookedSlotTime = Util.GetDateTime(lastBookedSlot);
                    }
                    return JsonConvert.SerializeObject(new { status = true, response = output, defaultAvilableSlot = lastBookedSlotTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") });
                }
                else if (string.IsNullOrWhiteSpace(output))
                    return JsonConvert.SerializeObject(new { status = false, response = "Slot Not Avilable." });
                else
                    return JsonConvert.SerializeObject(new { status = true, response = output, defaultAvilableSlot = defaultAvilableSlot });
            }
            else
                return JsonConvert.SerializeObject(new { status = false, response = "Not A Valid Appointment Date." });

        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }


    public static string GetSlotDateWise(DataTable dtDoctorNotAvailableDetail,DataTable dtBookDetail, DataTable dtMobileApplicationBookedAppointments, DateTime startDateTime, DateTime endDateTime, string appointmentDate, string currentdefaultAvilableSlot, out string defaultAvilableSlot,string AppSlot)
    {
        DateTime currentTime = System.DateTime.Now;
        string output = "";
        int flag = 0;

        while (startDateTime < endDateTime)
        {
            foreach (DataRow row in dtBookDetail.Rows)
            {
                if (Util.GetDateTime(row["Time"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    if (Util.GetInt(row["IsConform"]) == 1)
                    {
                        flag = 2;

                    }
                    else
                    {
                        flag = 1;

                    }
                }
            }

            foreach (DataRow row in dtMobileApplicationBookedAppointments.Rows)
            {
                if (Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 3;
                }
            }
            foreach (DataRow row in dtDoctorNotAvailableDetail.Rows)
            {
                if (Util.GetDateTime(row["FromTime"].ToString()) <= Util.GetDateTime(startDateTime) && Util.GetDateTime(row["ToTime"].ToString()) >= Util.GetDateTime(startDateTime))
                {
                    flag = 4;
                }
            }
            
            if (flag == 1)
            {
                //for Booked
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-yellow' ><span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + " </div> </div> ";
            }
            else if (flag == 2)
            {
                //for confirm
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-purple'> <span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + " </div> </div> ";
            }
            else if (flag == 3)
            {
                //for Mobile Application Appointments
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-info'> <span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + " </div> </div> ";

            }
            else if (flag == 4)
            {
                //Doctor Not-Available For this slots
            }
            else
            {

                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div id='" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + "' " + ((Util.GetDateTime(appointmentDate).Date == System.DateTime.Now.Date && currentTime > startDateTime.AddMinutes(Util.GetInt(AppSlot))) ? "class='circle badge-grey'" : "data-title='Double Click To Select' class='circle badge-avilable' ondblclick='$dobuleClick(this)'") + " onclick='$selectSlot(this)'> <span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + " </div> </div> ";
                if (string.IsNullOrWhiteSpace(currentdefaultAvilableSlot) && startDateTime.AddMinutes(Util.GetInt(AppSlot)) > currentTime)
                    currentdefaultAvilableSlot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt");

            }
            flag = 0;
            startDateTime = startDateTime.AddMinutes(Util.GetInt(AppSlot));
        }

        defaultAvilableSlot = currentdefaultAvilableSlot;
        return output;
    }

    [WebMethod]
    public static string GetAppointmentCount(string doctorID, string appointmentDate)
    {
        return StockReports.ExecuteScalar("SELECT  IF(LENGTH(COUNT(ap.App_ID))>1,COUNT(ap.App_ID),LPAD(COUNT(ap.App_ID),2,0)) COUNT FROM appointment ap WHERE ap.DoctorID='" + doctorID + "' AND ap.Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'");
    }


    [WebMethod]
    public static string GetDefaultAvilableSlot(string doctorID, string appointmentDate, string startTime, string endTime,string centreId,string preDefinedSlot)
    {
        if (!string.IsNullOrEmpty(preDefinedSlot))
            return preDefinedSlot;
 
        DataTable dtBookDetail = StockReports.GetDataTable("SELECT a.Time,  CONCAT(Title, ' ', PName) NAME,  a.IsConform FROM appointment a WHERE a.DoctorID = '" + doctorID + "'   AND a.Date = '" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'   AND a.IScancel =0  ");

        DataTable dtMobileApplicationBookedAppointments = StockReports.GetDataTable("SELECT app.StartTime,app.AppointmentDate FROM app_appointment app WHERE app.AppointmentDate='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'");
        DataTable dtDoctorNotAvailableDetail = StockReports.GetDataTable("SELECT d.FromTime,d.ToTime FROM doctor_notavailable_datewise d  WHERE  d.isActive=1 and d.DoctorID = '" + doctorID + "'   AND d.Date = '" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'  and CentreID='" + centreId + "'  ");

        
        var startDateTime = Util.GetDateTime(appointmentDate + " " + startTime);
        var endDateTime = Util.GetDateTime(appointmentDate + " " + endTime);
        string defaultAvilableSlot = string.Empty;



        GetSlotDateWise(dtDoctorNotAvailableDetail, dtBookDetail, dtMobileApplicationBookedAppointments, startDateTime, endDateTime, appointmentDate, defaultAvilableSlot, out defaultAvilableSlot, preDefinedSlot);
        return defaultAvilableSlot;
    }




    //[WebMethod]
    //public static string GetDirectAppointMentTimeSlot(string DoctorId, string appointmentDate)
    //{
    //    try
    //    {

    //        var startTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' "));
    //        if (string.IsNullOrWhiteSpace(startTime))
    //            startTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' and Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' "));
    //        var endTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' "));
    //        if (string.IsNullOrWhiteSpace(endTime))
    //            endTime = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorId + "' and Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' "));


    //        DateTime startDateTime = Util.GetDateTime(startTime);
    //        DateTime endDateTime = Util.GetDateTime(endTime);
    //        DataTable dtBookDetail = StockReports.GetDataTable(" SELECT ad.Time,CONCAT(Title,' ',PName)NAME,a.IsConform FROM appointment_detail ad INNER JOIN appointment a ON ad.app_ID=a.App_ID WHERE ad.DoctorID='" + DoctorId + "' and ad.Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' and ad.IScancel=0");
    //        int flag = 0;
    //        string output = string.Empty;
    //        var defaultAvilableSlot = string.Empty;
    //        if (Util.GetDateTime(appointmentDate).Date == System.DateTime.Now.Date)
    //        {
    //            while (startDateTime < endDateTime)
    //            {
    //                foreach (DataRow row in dtBookDetail.Rows)
    //                {
    //                    if (Util.GetDateTime(row["Time"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
    //                    {
    //                        if (Util.GetInt(row["IsConform"]) == 1)
    //                        {
    //                            flag = 2;
    //                        }
    //                        else
    //                        {
    //                            flag = 1;
    //                        }
    //                    }
    //                }
    //                if (flag == 1)
    //                {
    //                    output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-yellow' onclick='$selectSlot(this)'><span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(10).ToString("hh:mm tt") + " </div> </div> ";
    //                }
    //                else if (flag == 2)
    //                {
    //                    output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-purple' onclick='$selectSlot(this)'> <span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(10).ToString("hh:mm tt") + " </div> </div> ";
    //                }
    //                else
    //                {
    //                    defaultAvilableSlot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(10).ToString("hh:mm tt");
    //                    output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-avilable' data-title='Double Click To Select' onclick='$selectSlot(this)'> <span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(10).ToString("hh:mm tt") + " </div> </div> ";
    //                }
    //                flag = 0;
    //                startDateTime = startDateTime.AddMinutes(10);
    //            }

    //            if (string.IsNullOrWhiteSpace(output))
    //                return JsonConvert.SerializeObject(new { status = false, response = "Slot Not Avilable" });
    //            else
    //                return JsonConvert.SerializeObject(new { status = true, response = output, defaultAvilableSlot = defaultAvilableSlot });
    //        }
    //        else
    //            return JsonConvert.SerializeObject(new { status = false, response = "Not A Valid Appointment Date" });

    //    }
    //    catch (Exception ex)
    //    {
    //        return JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
    //    }

    //}


    [WebMethod(EnableSession = true)]
    public static string bindAppointmentDetail(string App_ID)
    {
        DataTable dtAppDetail = AllLoadData_OPD.bindAppointmentDetail(App_ID);
        if (dtAppDetail.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dtAppDetail });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Appointment Details Not Found" });
    }
    [WebMethod]
    public static string NextPrevDate(string selectedDate,int addDays) {

        var calculatedAppointmentDate= Util.GetDateTime(selectedDate).AddDays(addDays);

        var d = (calculatedAppointmentDate - Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"))).Days;

        if (d<0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, calculatedAppointmentDate = calculatedAppointmentDate.ToString("dd-MMM-yyyy"), message = "Invalid Appointment Date." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, calculatedAppointmentDate = calculatedAppointmentDate.ToString("dd-MMM-yyyy") });
    }

}