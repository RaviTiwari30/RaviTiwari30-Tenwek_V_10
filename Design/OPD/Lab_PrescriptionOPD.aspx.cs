using System;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Data;
using Newtonsoft.Json;

public partial class Design_OPD_Lab_PrescriptionOPD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            lblAppointmentCurrentDate.Text = txtAppointmentSlotDate.Text = txtOnlineFromDate.Text = txtOnlineToDate.Text = txtOldInvestigationModelFromDate.Text = txtOldInvestigationModelToDate.Text = txtInvestigationSlotDate.Text = txtInvestigationOn.Text = txtInvestigationCurrDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //cdOnlineToDate.EndDate = cdOnlineFromDate.EndDate = calExdTxtOldInvestigationModelFromDate.EndDate = calExdTxtOldInvestigationModelToDate.EndDate = System.DateTime.Now;

            ViewState["IsDiscount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsDiscount");
            ViewState["maxEligibleDiscountPercent"] = Util.round(All_LoadData.GetEligiableDiscountPercent(Session["ID"].ToString()));

        }
        txtOldInvestigationModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtOldInvestigationModelFromDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string checkTRFSlip(string LedgerTransactionNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(GROUP_CONCAT(DISTINCT sm.SubCategoryID SEPARATOR '#'),'') DEPT  ");
        sb.Append(" FROM  ");
        sb.Append(" ( SELECT investigation_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + LedgerTransactionNo + "'  ) plo ");
        sb.Append(" INNER JOIN f_itemmaster itm ON itm.type_id=plo.investigation_id ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=itm.`SubCategoryID`   ");
        sb.Append(" AND sm.categoryid='7' ");
        return StockReports.ExecuteScalar(sb.ToString());
    }

    [WebMethod]
    public static string ValidateDoctorLeave(string itemID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        string leaveQuery = "SELECT COUNT(*)OnLeave FROM Pay_Leave_Master pl WHERE pl.IsActive=1 AND pl.`Date`=@appointmentDate AND pl.`DoctorID`=(SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID=@itemID)";

        var isOnLeave = excuteCMD.ExecuteScalar(leaveQuery, new
        {
            appointmentDate = Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd"),
            itemID = itemID
        });


        if (Util.GetInt(isOnLeave) > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Dotor On Leave." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });

    }

    [WebMethod(EnableSession=true)]
    public static string ValidateDoctorMap(string itemID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        string MapQuery = "SELECT COUNT(*)Map FROM f_center_doctor dm WHERE dm.isActive=1 AND dm.CentreID=@CentreID AND dm.DoctorID=(SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID=@itemID)";

        var isMap = excuteCMD.ExecuteScalar(MapQuery, new
        {
            CentreID = HttpContext.Current.Session["CentreID"].ToString(),
            itemID = itemID
        });


        if (Util.GetInt(isMap) <= 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Dotor Not Mapped." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });

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

                string appointmentDate = consecutiveDate[i];

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
                    slotDetails.Add(new { status = false, response = "<div style='color:brown' class='bold textCenter'>Public Holiday<br/>" + holidaysName + "</div>", appointmentDate = Util.GetDateTime(appointmentDate).ToString("dd-MMM-yyyy") });
                    continue;
                }

                DateTime startDateTime = new DateTime();
                DateTime endDateTime = new DateTime();
                DataTable dtDoctorSlot = new DataTable();
                string Query = " SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName,AvgTime DurationForOldPatient FROM doctor_hospital WHERE DoctorID='" + DoctorId + "' AND DAY='" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "' and CentreID='" + centreId + "' ";
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
                if (dtDoctorSlot == null || dtDoctorSlot.Rows.Count == 0)
                    AppSlot = "10"; 
                else
                    AppSlot = dtDoctorSlot.Rows[0]["DurationForOldPatient"].ToString();

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

    public static string GetSlotDateWise(DataTable dtDoctorNotAvailableDetail, DataTable dtBookDetail, DataTable dtMobileApplicationBookedAppointments, DateTime startDateTime, DateTime endDateTime, string appointmentDate, string currentdefaultAvilableSlot, out string defaultAvilableSlot, string AppSlot)
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

                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div id='" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + "' " + ((Util.GetDateTime(appointmentDate).Date == System.DateTime.Now.Date && currentTime > startDateTime.AddMinutes(Util.GetInt(AppSlot))) ? "class='circle badge-grey'" : "data-title='Double Click To Select' class='circle badge-avilable' onclick='$selectSlot(this)' ondblclick='$dobuleClick(this)'  ") + "> <span id='spnAppointmentDate' style='display:none'>" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "</span> <span id='spnAppointmentTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(Util.GetInt(AppSlot)).ToString("hh:mm tt") + " </div> </div> ";
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
    public static string NextPrevDate(string selectedDate, int addDays)
    {

        var calculatedAppointmentDate = Util.GetDateTime(selectedDate).AddDays(addDays);

        var d = (calculatedAppointmentDate - Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"))).Days;

        if (d < 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, calculatedAppointmentDate = calculatedAppointmentDate.ToString("dd-MMM-yyyy"), message = "Invalid Appointment Date." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, calculatedAppointmentDate = calculatedAppointmentDate.ToString("dd-MMM-yyyy") });
    }
    [WebMethod]
    public static string GetAppointmentCount(string doctorID, string appointmentDate)
    {
        return StockReports.ExecuteScalar("SELECT  IF(LENGTH(COUNT(ap.App_ID))>1,COUNT(ap.App_ID),LPAD(COUNT(ap.App_ID),2,0)) COUNT FROM appointment ap WHERE ap.DoctorID='" + doctorID + "' AND ap.Date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'");
    }

    [WebMethod(EnableSession = true)]
    public static string bindAppointmentDetail(string App_ID)
    {
        DataTable dtAppDetail = AllLoadData_OPD.bindAppointmentDetail(App_ID);
        if (dtAppDetail.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dtAppDetail });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Appointment Details Not Found" });
    }

   
}