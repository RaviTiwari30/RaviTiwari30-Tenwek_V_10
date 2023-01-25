using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;


public partial class Design_OPD_AppointmentConformation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = TextBox1.Text = txtInvestigationCurrDate.Text = txtInvestigationSlotDate.Text = txtAppointmentSlotDate.Text = lblAppointmentCurrentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //calExdTxtAppointmentSearchFromDate.EndDate = System.DateTime.Now;
            ViewState["IsDiscount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsDiscount");
        }

    }

    [WebMethod(EnableSession = true)]
    public static string GetApppointmentDetails(string doctorID, string fromDate, string toDate, string appointmentNo, string isConform, string visitType, string status, string doctorDepartmentID, string Pname, string mobileOrUHID, string mobileOrUHIDNo)
    {
        try
        {

            //var appointmentDetails = AllLoadData_OPD.SearchAppointment(doctorID, Util.GetDateTime(fromDate), Util.GetDateTime(toDate), appointmentNo, isConform, visitType, status, HttpContext.Current.Session["CentreID"].ToString());

            var appointmentDetails = All_StoreProcedures.GetApppointmentDetails(doctorID, Util.GetDateTime(fromDate), Util.GetDateTime(toDate), appointmentNo, isConform, visitType, status, doctorDepartmentID, Pname, mobileOrUHID, mobileOrUHIDNo ,HttpContext.Current.Session["CentreID"].ToString());

            return Newtonsoft.Json.JsonConvert.SerializeObject(appointmentDetails);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateAppointmentStatus(string appointmentID, string status, string remark, string PatientID, string PName, string DoctorName, string ContactNo, string AppDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var result = "0";
            AllUpdate Updt = new AllUpdate();
            if (status == "confirm")
                result = Updt.UpdateAppointmentStatus(appointmentID, "1", "", "", "", tnx);
            if (status == "cancel")
                result = Updt.UpdateAppointmentStatus(appointmentID, "", "1", "", remark, tnx);

            if (result == "0")
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
            else
            {
                if (status == "cancel")
                {

                    ExcuteCMD excuteCMD = new ExcuteCMD();
                    var dt = excuteCMD.GetDataTable("SELECT ap.PatientID,ap.sex,ap.Pname,ap.Title,ap.ContactNo,Concat(dm.Title,dm.Name) DoctorName, DATE_FORMAT(ap.Date,'%d-%b-%Y') AppointmentDate,TIME_FORMAT(ap.time,'%H:%i:%s')AppointmentTime ,ap.Email FROM appointment ap INNER JOIN doctor_master dm ON dm.DoctorID=ap.DoctorID WHERE ap.App_ID=@appointmentID", CommandType.Text,

                        new
                        {
                            appointmentID = appointmentID

                        });



                    //**************** SMS************************//
                    if (Resources.Resource.SMSApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["ContactNo"])))
                    {
                        var templateID = 2;
                        var columninfo = smstemplate.getColumnInfo(templateID, con);
                        if (columninfo.Count > 0)
                        {
                            columninfo[0].PatientID = Util.GetString(dt.Rows[0]["PatientID"]);
                            columninfo[0].PName = Util.GetString(dt.Rows[0]["Pname"]);
                            columninfo[0].Title = Util.GetString(dt.Rows[0]["Title"]);
                            columninfo[0].Gender = Util.GetString(dt.Rows[0]["Sex"]);
                            columninfo[0].ContactNo = Util.GetString(dt.Rows[0]["ContactNo"]);
                            columninfo[0].DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]);
                            columninfo[0].AppointmentDate = Util.GetString(dt.Rows[0]["AppointmentDate"]);
                            columninfo[0].AppointmentTime = Util.GetString(dt.Rows[0]["AppointmentTime"]);
                            columninfo[0].TemplateID = templateID;
                              string sms = smstemplate.getSMSTemplate(templateID, columninfo, 1, con, Util.GetString(HttpContext.Current.Session["ID"]));
                        }
                    }



                    //**************** Email************************//
                    if (Resources.Resource.EmailApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["Email"])))
                    {
                        var d = new EmailTemplateInfo()
                        {
                            PatientID = Util.GetString(dt.Rows[0]["PatientID"]),
                            PName = Util.GetString(dt.Rows[0]["Pname"]),
                            Title = Util.GetString(dt.Rows[0]["Title"]),
                            Gender = Util.GetString(dt.Rows[0]["Sex"]),
                            ContactNo = Util.GetString(dt.Rows[0]["ContactNo"]),
                            DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]),
                            AppointmentDate = Util.GetString(dt.Rows[0]["AppointmentDate"]),
                            AppointmentTime = Util.GetString(dt.Rows[0]["AppointmentTime"]),
                            EmailTo = Util.GetString(dt.Rows[0]["Email"]),
                            TransactionID = string.Empty
                        };
                        List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                        dd.Add(d);
                        //  int sendEmailID = Email_Master.SaveEmailTemplate(3, Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "1", dd, string.Empty, null, con);
                    }
                }

            }
            tnx.Commit();
            if (status == "confirm")
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Appointment Confirm Successfully" });
            if (status == "cancel")
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Appointment Cancel Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Appointment Status MisMatch" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetAppointmentReport(string doctorID, string fromDate, string toDate, string appointmentNo, string isConform, string visitType, string status, string reportType, string doctorDepartmentID)
    {

        try
        {
            string DoctorID = doctorID;



            DataTable dtReport = AllLoadData_OPD.SearchAppointment(DoctorID, Util.GetDateTime(fromDate), Util.GetDateTime(toDate), appointmentNo, "", visitType, status, doctorDepartmentID);

            if (dtReport != null && dtReport.Rows.Count > 0)
            {
                if (reportType == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtReport.Copy());
                    //ds.WriteXmlSchema(@"D:\AppConfirmationReport.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "AppConfirmationReport";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
                }
                else
                {
                    dtReport.Columns.Remove("TransactionID");
                    dtReport.Columns.Remove("App_ID");
                    dtReport.Columns.Remove("DoctorID");
                    dtReport.Columns.Remove("IsConform");
                    dtReport.Columns.Remove("IsReschedule");
                    dtReport.Columns.Remove("IsCancel");
                    dtReport.Columns.Remove("AppTime");
                    dtReport.Columns.Remove("LedgerTnxNo");
                    dtReport.Columns.Remove("CentreID");
                    dtReport.Columns[5].ColumnName = "Name";
                    dtReport.Columns[11].ColumnName = "Status";
                    dtReport.Columns[13].ColumnName = "Confirmed";
                    dtReport.Columns[14].ColumnName = "ConfirmedDate";
                    dtReport.Columns[15].ColumnName = "ConfirmedBy";
                    dtReport.Columns[16].ColumnName = "Rescheduled";
                    dtReport.Columns[17].ColumnName = "RescheduledDate";
                    dtReport.Columns[18].ColumnName = "RescheduledBy";
                    dtReport.Columns[19].ColumnName = "Cancelled";
                    dtReport.Columns[20].ColumnName = "CancelledDate";
                    dtReport.Columns[21].ColumnName = "CancelledBy";
                    dtReport.AcceptChanges();
                    // HttpContext.Current.Session["dtExport2Excel"] = dtReport;
                    //  HttpContext.Current.Session["ReportName"] = "Appointment Status Report";
                    // HttpContext.Current.Session["Period"] = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                    // return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/ExportToExcel.aspx" });


                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    HttpContext.Current.Cache.Remove(CacheName);
                    HttpContext.Current.Cache.Insert(CacheName, dtReport, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddSeconds(Util.GetInt(Resources.Resource.ReportCacheTimeOutSec)), System.Web.Caching.Cache.NoSlidingExpiration);
                    //Common.CreateCachedt(CacheName, dtReport);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/commonReports/Commonreport.aspx?ReportName=Appointment Status Report&Type=E" });


                }


            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found." });
        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });

        }



    }

    [WebMethod(EnableSession = true)]
    public static string GetRadiologyApppointmentDetails(string fromDate, string toDate, string UHID, string PName, string Mobile, string SubCategoryID, string LabNo, string TokenNo, string isConform, string status)
    {
        try
        {
            var appointmentDetails = All_StoreProcedures.GetApppointmentRadiologyDetails(Util.GetDateTime(fromDate), Util.GetDateTime(toDate), UHID, PName, Mobile, SubCategoryID, LabNo, TokenNo, isConform, status, HttpContext.Current.Session["CentreID"].ToString());

            return Newtonsoft.Json.JsonConvert.SerializeObject(appointmentDetails);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string GetInvestigationTimeSlot(string DoctorId, string InvestigationDate, string BookingType, string ItemID, string SubCategoryID, string centreId, string Modality)
    {
        try
        {
            DateTime startDateTime = new DateTime();
            DateTime endDateTime = new DateTime();
            int DurationofTest = 10;
            DataTable dtDoctorSlot = new DataTable();
            //     InvestigationDate = DateTime.Now.ToString();
            string Query = " SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName,ifnull(DurationforPatient,10)DurationforPatient FROM investigation_slot_master WHERE SubCategoryID='" + SubCategoryID + "' AND DAY='" + Util.GetDateTime(InvestigationDate).DayOfWeek.ToString() + "' and CentreID='" + centreId + "' and ModalityID='" + Modality + "' ";
            dtDoctorSlot = StockReports.GetDataTable(Query);




            DataTable dtBookedSlotinHospital = StockReports.GetDataTable("SELECT BookDate,StartTime,EndTime FROM Investigation_TimeSlot WHERE isactive=1 AND IsOnlineBooking=1 AND SubCategoryID='" + SubCategoryID + "' and CentreID ='" + centreId + "' and ModalityID='" + Modality + "'");
            DataTable dtBookedSlotOnline = StockReports.GetDataTable("SELECT BookDate,StartTime,EndTime FROM Investigation_TimeSlot WHERE isactive=1 AND IsOnlineBooking=2 AND SubCategoryID='" + SubCategoryID + "' and CentreID ='" + centreId + "' and ModalityID='" + Modality + "'");
            DataTable dtholdSlot = StockReports.GetDataTable("Select BookingDate,StartTime,EndTime from investigation_timeslot_hold where SubCategoryID='" + SubCategoryID + "' and CentreID ='" + centreId + "' and ModalityID='" + Modality + "'");
            string output = string.Empty;
            string defaultAvilableSlot = string.Empty;


            if (Util.GetDateTime(InvestigationDate).Date >= System.DateTime.Now.Date)
            {
                foreach (DataRow drSlot in dtDoctorSlot.Rows)
                {
                    startDateTime = Util.GetDateTime(drSlot["StartTime"].ToString());
                    endDateTime = Util.GetDateTime(drSlot["EndTime"].ToString());
                    DurationofTest = Util.GetInt(drSlot["DurationforPatient"]);
                    string slots = GetSlotDateWise(dtBookedSlotinHospital, dtBookedSlotOnline, dtholdSlot, startDateTime, endDateTime, InvestigationDate, defaultAvilableSlot, DurationofTest, Modality, out defaultAvilableSlot);
                    if (slots != "")
                    {
                        slots = "<div class='row' ><div  class='col-md-24' ><b class='modal-title'># " + drSlot["ShiftName"].ToString() + "<br /><hr /><b /></div>" + slots + "</div>";
                        output += slots;
                    }
                }
                if (string.IsNullOrWhiteSpace(output))
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Slot Not Avilable" });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = output, defaultAvilableSlot = defaultAvilableSlot });

            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Not A Valid Appointment Date" });

        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    public static string GetSlotDateWise(DataTable dtBookedSlotinHospital, DataTable dtBookedSlotOnline, DataTable dtholdSlot, DateTime startDateTime, DateTime endDateTime, string InvestigationDate, string currentdefaultAvilableSlot, int DurationofTest, string Modality, out string defaultAvilableSlot)
    {
        DateTime currentTime = System.DateTime.Now;
        string output = "";
        int flag = 0;

        while (startDateTime < endDateTime)
        {
            foreach (DataRow row in dtBookedSlotinHospital.Rows)
            {
                if (Util.GetDateTime(InvestigationDate).Date == Util.GetDateTime(row["BookDate"]).Date && Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 1;
                }
            }

            foreach (DataRow row in dtBookedSlotOnline.Rows)
            {
                if (Util.GetDateTime(InvestigationDate).Date == Util.GetDateTime(row["BookDate"]).Date && Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 2;
                }
            }
            foreach (DataRow row in dtholdSlot.Rows)
            {
                if (Util.GetDateTime(InvestigationDate).Date == Util.GetDateTime(row["BookingDate"]).Date && Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 3;
                }

            }

            if (flag == 1)
            {
                //for Booked in hosp
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-yellow' ><span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";
            }

            else if (flag == 2)
            {
                //for online Appointments
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-info'> <span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";

            }
            else if (flag == 3)
            {
                //for hold slots by user
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div  id='" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "' " + ((Util.GetDateTime(InvestigationDate).Date == System.DateTime.Now.Date && currentTime > startDateTime.AddMinutes(DurationofTest)) ? "class='circle badge-grey'" : "data-title='Double Click To Select' class='circle badge-darkgoldenrod' ondblclick='$InvdobuleClick(this)'") + "  onclick='$selectInvSlot(this)'> <span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";

            }
            else
            {

                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div id='" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "' " + ((Util.GetDateTime(InvestigationDate).Date == System.DateTime.Now.Date && currentTime > startDateTime.AddMinutes(DurationofTest)) ? "class='circle badge-grey'" : "data-title='Double Click To Select' class='circle badge-avilable' ondblclick='$InvdobuleClick(this)'") + " onclick='$selectInvSlot(this)'> <span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";
                if (string.IsNullOrWhiteSpace(currentdefaultAvilableSlot) && startDateTime.AddMinutes(DurationofTest) > currentTime)
                    currentdefaultAvilableSlot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt");

            }
            flag = 0;
            startDateTime = startDateTime.AddMinutes(DurationofTest);
        }

        defaultAvilableSlot = currentdefaultAvilableSlot;
        return output;
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateRadiologySchedule(string modalityID, string SubCategoryID, string ItemID, string BookingDate, string TimeSlot, string BookingID, string isOnlineBooking)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string TokenNoSub = string.Empty; string TokenRoomName = string.Empty; string startdate = string.Empty, enddate = string.Empty;
        try
        {
            startdate = TimeSlot.Split('-')[0].ToString();
            enddate = TimeSlot.Split('-')[1].ToString();


            int isBooked = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM investigation_timeslot WHERE BookDate ='" + Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd") + "' and StartTime='" + Util.GetDateTime(startdate).ToString("HH:mm:ss") + "' AND EndTime ='" + Util.GetDateTime(enddate).ToString("HH:mm:ss") + "'AND modalityid='" + modalityID + "'"));
            if (isBooked > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This Slot is Not Available.Please Select Another Slot" });
            }


            ExcuteCMD cmd = new ExcuteCMD();

            if (!string.IsNullOrEmpty(BookingID))
            {
                if (isOnlineBooking == "1")
                {
                    TokenNoSub = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_Token_No_Inv_Appointment('" + SubCategoryID + "','" + modalityID + "','" + Util.GetDateTime(BookingDate).DayOfWeek.ToString() + "','" + TimeSlot + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                    TokenRoomName = AllLoadData_OPD.getTokenRoom(tnx, "7", SubCategoryID, modalityID, Util.GetInt(HttpContext.Current.Session["CentreID"]));

                    cmd.DML(tnx, " UPDATE f_ledgertnxdetail SET TokenRoomName=@roomName,TokenNo=@tokenno  WHERE ID=@id ", CommandType.Text, new
                    {
                        roomName = TokenRoomName,
                        tokenno = TokenNoSub,
                        id = BookingID
                    });
                    cmd.DML(tnx, " UPDATE patient_labinvestigation_opd SET BookingDate=@BookingDate,BookingTime=@TimeSlot  WHERE ledgertnxid=@id ", CommandType.Text, new
                    {
                        BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                        TimeSlot = TimeSlot,
                        id = BookingID,
                    });
                    cmd.DML(tnx, " UPDATE investigation_timeslot SET BookDate=@BookingDate,  StartTime=@StartTime, EndTime=@EndTime,  ModalityID =@ModalityID, IsReSchedule=@IsReSchedule    WHERE BookingID=@id ", CommandType.Text, new
                    {
                        BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                        StartTime = Util.GetDateTime(startdate).ToString("HH:mm:ss"),
                        EndTime = Util.GetDateTime(enddate).ToString("HH:mm:ss"),
                        ModalityID = modalityID,
                        IsReSchedule = "1",
                        id = BookingID
                    });

                }
                else
                {
                    cmd.DML(tnx, " UPDATE app_investigationbooking SET BookingDate=@BookingDate Where ID=@id ", CommandType.Text, new
                    {
                        BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                        id = BookingID
                    });


                    cmd.DML(tnx, " UPDATE investigation_timeslot SET BookDate=@BookingDate,  StartTime=@StartTime, EndTime=@EndTime,  ModalityID =@ModalityID, IsReSchedule=IsReSchedule    WHERE BookingID=@id ", CommandType.Text, new
                    {
                        BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                        StartTime = Util.GetDateTime(startdate).ToString("HH:mm:ss"),
                        EndTime = Util.GetDateTime(enddate).ToString("HH:mm:ss"),
                        ModalityID = modalityID,
                        IsReSchedule = "1",
                        id = BookingID
                    });

                }

            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured !!! Please Contact to Administrator" });


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Appointment Reschedule Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetRadiologyAppointmentReport(string fromDate, string toDate, string UHID, string PName, string Mobile, string SubCategoryID, string LabNo, string TokenNo, string isConform, string status, string reportType)
    {
        HttpContext.Current.Session["dtExport2Excel"] = "";
        HttpContext.Current.Session["ReportName"] = "Radiology Appointment Status Report";
        HttpContext.Current.Session["Period"] = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/ExportToExcel.aspx" });
    }
    [WebMethod(EnableSession = true)]
    public static string UpdateDoctorAppointmentSchedule(string slotTiming, string appID, string IsSlotWiseToken, string doctorID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string TokenNoSub = string.Empty; string TokenRoomName = string.Empty; string startdate = string.Empty, enddate = string.Empty;
        try
        {
            var appointmentDate = slotTiming.Split('#')[0].ToString();
            var appointmentTime = slotTiming.Split('#')[1].ToString();

            int AppNo = 0;
            if (IsSlotWiseToken == "0")
            {
                AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + doctorID + "','" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));
            }
            else
            {
                AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_Token_No_Doctor_Appointment('" + doctorID + "','" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "','" + appointmentTime + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));
            }
            var str = "Update appointment set AppNo=@AppNo,TIME=@startTime,EndTime=@EndTime,DATE=@AppDate,IsReSchedule=1,RescheduleDate=NOW(),RescheduleBy=@RescheduleBy  where App_ID=@App_ID";
            excuteCMD.DML(tnx, str, CommandType.Text, new
            {
                AppNo = AppNo,
                startTime = Util.GetDateTime(appointmentTime.Split('-')[0].ToString()),
                EndTime = Util.GetDateTime(appointmentTime.Split('-')[1].ToString()),
                AppDate = Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd"),
                RescheduleBy = HttpContext.Current.Session["ID"].ToString(),
                App_ID = appID
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Appointment Reschedule Successfully</br> Appointment No. : " + AppNo });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


}