<%@ WebService Language="C#" Class="OT_SchedulingDetails" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[System.Web.Script.Services.ScriptService]
public class OT_SchedulingDetails  : System.Web.Services.WebService
{




    public class Slot
    {

        public string status { get; set; }
        public string isDoctorAlloted { get; set; }
        public string allotedDoctorID { get; set; }
        public string allotedDoctorName { get; set; }
        public string isPatientAlloted { get; set; }
        public string bookedPatientID { get; set; }
        public string bookedDoctorID { get; set; }
        public string bookedDoctorDepartmentID { get; set; }
        public string bookedDoctorName { get; set; }
        public string bookeddoctorDepartment { get; set; }
        public string OTDate { get; set; }
        public string tooltipString { get; set; }
        public int index { get; set; }
        public string BookingId { get; set; }
        public string startDisplayTime { get; set; }
        public string endDisplayTime { get; set; }
        public string htmlDisplayString { get; set; }
    }


    public class OTDetail
    {

        public string OTName { get; set; }
        public string OTID { get; set; }
        public string DisplayMonth { get; set; }
        public string DisplayDate { get; set; }
        private List<Slot> _slots;
        public List<Slot> slots
        {
            get { return _slots; }
            set { _slots = value; }
        }
    }



    public class OTSlotCreationParam
    {

        public string scheduleDate { get; set; }
        public string scheduleDay { get; set; }
        public string doctorID { get; set; }
        public int applyExpiredFilter { get; set; }
        public int checkedDoctorBookedSlots { get; set; }
        public int checkedPatientBookedSlots { get; set; }

        public int isForDoctorSlotAllocation { get; set; }
        public int filterDoctorSpecifiedSlot { get; set; }
    }



    [WebMethod(EnableSession = true)]
    public string GetOTSlots(OTSlotCreationParam _OTSlotCreationParam)
    {

        var centreID = HttpContext.Current.Session["CentreID"].ToString();

        if (string.IsNullOrEmpty(_OTSlotCreationParam.scheduleDate))
            _OTSlotCreationParam.scheduleDate = System.DateTime.Now.ToString("dd-MMM-yyyy");

        var todayDate = Util.GetDateTime(_OTSlotCreationParam.scheduleDate).ToString("dd-MMM-yyyy");

        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dt = excuteCMD.GetDataTable("SELECT ot.ID,ot.Name,ot.SlotMins,TIME_FORMAT(ot.StartTime,'%h:%i %p') StartTime,TIME_FORMAT(ot.EndTime,'%h:%i %p') EndTime FROM ot_master ot WHERE ot.CentreID=@centreID AND ot.IsActive=1", CommandType.Text, new
        {
            centreID = centreID
        });


        if (_OTSlotCreationParam.filterDoctorSpecifiedSlot > 0)
        {

            dt = excuteCMD.GetDataTable("SELECT d.OTID ID,ot.Name,ot.SlotMins,TIME_FORMAT(d.StartTime,'%h:%i %p') StartTime,TIME_FORMAT(d.EndTime,'%h:%i %p') EndTime FROM  ot_doctor_slotsallocation_datewise d INNER JOIN ot_master ot ON ot.id=d.OTID WHERE d.IsActive=1 AND d.CentreID=@centreID AND d.DoctorID=@doctorID AND d.SlotDate=@slotDate", CommandType.Text, new
            {
                doctorID = _OTSlotCreationParam.doctorID,
                centreID = centreID,
                slotDate = Util.GetDateTime(todayDate).ToString("yyyy-MM-dd")
            });

            if (dt.Rows.Count < 1)
            {
                var day = Util.GetDateTime(todayDate).ToString("ddd");
                dt = excuteCMD.GetDataTable("SELECT d.OTID ID,ot.Name,ot.SlotMins,TIME_FORMAT(d.StartTime,'%h:%i %p') StartTime,TIME_FORMAT(d.EndTime,'%h:%i %p') EndTime FROM  ot_doctor_slotsallocation_daywise d INNER JOIN ot_master ot ON ot.id=d.OTID WHERE d.IsActive=1 AND d.CentreID=@centreID AND d.DoctorID=@doctorID AND d.Day=@day", CommandType.Text, new
                {
                    doctorID = _OTSlotCreationParam.doctorID,
                    centreID = centreID,
                    day = day
                });
            }
        }




        List<OTDetail> OTDetails = new List<OTDetail>();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string startTime = dt.Rows[i]["StartTime"].ToString();
            string endTime = dt.Rows[i]["EndTime"].ToString();
            int slotMins = Util.GetInt(dt.Rows[i]["SlotMins"].ToString());
            int OTID = Util.GetInt(dt.Rows[i]["ID"].ToString());

            var _starttime = Util.GetDateTime(todayDate + " " + startTime);
            var _endTime = Util.GetDateTime(todayDate + " " + endTime);

            var slots = CreateSlots(_starttime, _endTime, slotMins, _OTSlotCreationParam.doctorID, _OTSlotCreationParam.checkedDoctorBookedSlots, _OTSlotCreationParam.checkedPatientBookedSlots, _OTSlotCreationParam.applyExpiredFilter, OTID, _OTSlotCreationParam.scheduleDay, _OTSlotCreationParam.isForDoctorSlotAllocation, ref excuteCMD);
            CreateHTMLSlots(ref slots);
            OTDetail _OTDetail = new OTDetail();
            _OTDetail.slots = slots;
            _OTDetail.OTName = dt.Rows[i]["Name"].ToString();
            _OTDetail.OTID = dt.Rows[i]["ID"].ToString();
            OTDetails.Add(_OTDetail);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(OTDetails);
    }



    public static List<Slot> CreateSlots(DateTime startDateTime, DateTime endDateTime, int slotDifference, string doctorID, int checkedDoctorBookedSlots, int checkedPatientBookedSlots, int applyExpiredFilter, int OTID, string scheduleDay, int isForDoctorSlotAllocation, ref ExcuteCMD excuteCMD)
    {

        List<Slot> dd = new List<Slot>();


        DateTime start = startDateTime;
        DateTime end = endDateTime;
        int duration = (slotDifference);

        while (true)
        {
            DateTime dtNext = start.AddMinutes(duration);
            Slot slot = new Slot();
            if (start > end || dtNext > end)
                break;

            if (applyExpiredFilter > 0)
            {
                if (dtNext < System.DateTime.Now)
                    slot.status = "Expired";
                else
                    slot.status = "Available";
            }
            else
                slot.status = "Available";

            slot.startDisplayTime = start.ToString("hh:mm tt");
            slot.endDisplayTime = dtNext.ToString("hh:mm tt");

            dd.Add(slot);
            start = dtNext;
        }


        var dtConfirmed = new DataTable();
        var dtBooked = new DataTable();


        //filter for doctor scheduling
        if (isForDoctorSlotAllocation > 0)
        {
            if (!string.IsNullOrEmpty(doctorID))
            {
                if (!String.IsNullOrEmpty(scheduleDay))
                {
                    dtConfirmed = excuteCMD.GetDataTable("SELECT ot.StartTime,ot.EndTime,ot.OTID FROM ot_doctor_slotsallocation_daywise ot WHERE Ot.OTID=@OTID and  ot.IsActive=1 AND ot.CentreID=@centreID AND Day=@scheduleDay", CommandType.Text, new
                    {
                        centreID = HttpContext.Current.Session["CentreID"].ToString(),
                        scheduleDay = scheduleDay,
                        OTID = OTID
                    });
                }
                else
                {
                    dtConfirmed = excuteCMD.GetDataTable("SELECT ot.StartTime,ot.EndTime,ot.OTID FROM ot_doctor_slotsallocation_datewise ot WHERE Ot.OTID=@OTID and  ot.IsActive=1 AND ot.CentreID=@centreID AND SlotDate=@scheduleDate", CommandType.Text, new
                    {
                        centreID = HttpContext.Current.Session["CentreID"].ToString(),
                        scheduleDate = Util.GetDateTime(startDateTime).ToString("yyyy-MM-dd"),
                        OTID = OTID
                    });
                }


            }
        }
        //filter for doctor scheduling





        //filter for patient scheduling
        if (isForDoctorSlotAllocation == 0)
        {
            dtBooked = excuteCMD.GetDataTable("SELECT ot.ID bookingID, ot.OTNumber,ot.SlotFromTime StartTime,ot.SlotToTime EndTime,ot.OTID,ot.PatientName,IFNULL(ot.PatientID,ot.OutPatientID )PatientID, IF( IFNULL(ot.SurgeryNameForOther,'')<>'',ot.SurgeryNameForOther,(SELECT sm.NAME FROM f_surgery_master sm  WHERE sm.Surgery_ID=ot.SurgeryID)) SurgeryName,(SELECT CONCAT(dm.Title,' ',dm.NAME) FROM doctor_master dm  WHERE dm.DoctorID=ot.DoctorID)DocotrName FROM ot_booking ot WHERE Ot.OTID=@OTID AND  ot.IsActive=1 AND ot.IsConfirm=0 AND ot.IsCancel=0 AND ot.CentreID=@centreID AND ot.SurgeryDate=@scheduleDate", CommandType.Text, new
            {
                centreID = HttpContext.Current.Session["CentreID"].ToString(),
                scheduleDate = Util.GetDateTime(startDateTime).ToString("yyyy-MM-dd"),
                OTID = OTID
            });

        }

        if (isForDoctorSlotAllocation == 0)
        {
            dtConfirmed = excuteCMD.GetDataTable("SELECT ot.SlotFromTime StartTime,ot.SlotToTime EndTime,ot.OTID,ot.PatientName,IFNULL(ot.PatientID,ot.OutPatientID )PatientID,IF( IFNULL(ot.SurgeryNameForOther,'')<>'',ot.SurgeryNameForOther,(SELECT sm.NAME FROM f_surgery_master sm  WHERE sm.Surgery_ID=ot.SurgeryID))SurgeryName,(SELECT CONCAT(dm.Title,' ',dm.NAME) FROM doctor_master dm  WHERE dm.DoctorID=ot.DoctorID)DocotrName  FROM ot_booking ot WHERE Ot.OTID=@OTID AND  ot.IsActive=1 AND ot.IsConfirm=1 AND ot.IsCancel=0 AND ot.CentreID=@centreID AND ot.SurgeryDate=@scheduleDate", CommandType.Text, new
            {
                centreID = HttpContext.Current.Session["CentreID"].ToString(),
                scheduleDate = Util.GetDateTime(startDateTime).ToString("yyyy-MM-dd"),
                OTID = OTID
            });

        }


        //filter for patient scheduling


        if (true)
        {
            for (int i = 0; i < dd.Count; i++)
            {


                DateTime startTime = Util.GetDateTime(dd[i].startDisplayTime);
                DateTime endTime = Util.GetDateTime(dd[i].endDisplayTime);
                for (int j = 0; j < dtConfirmed.Rows.Count; j++)
                {

                    var bookedStartTime = Util.GetDateTime(dtConfirmed.Rows[j]["StartTime"]);
                    var bookedEndTime = Util.GetDateTime(dtConfirmed.Rows[j]["EndTime"]);

                    StringBuilder sb=new  StringBuilder();
                    sb.Append("Name : "+Util.GetString(dtConfirmed.Rows[j]["PatientName"])+" , ");
                    sb.Append("UHID : " + Util.GetString(dtConfirmed.Rows[j]["PatientID"])+" , ");
                    sb.Append("Slot :" + bookedStartTime.ToString("hh:mm tt") + " to " + bookedEndTime.ToString("hh:mm tt") + " , ");
                     sb.Append("Doctor :" + Util.GetString(dtConfirmed.Rows[j]["DocotrName"])+" , ");
                     sb.Append("Surgery :" + Util.GetString(dtConfirmed.Rows[j]["SurgeryName"]) + " , ");
                    

                    if (startTime > bookedStartTime && startTime < bookedEndTime)
                    {
                        dd[i].status = "Confirmed";
                        dd[i].tooltipString = sb.ToString();
                         
                    }
                    if (startTime == bookedStartTime)
                    {
                        dd[i].status = "Confirmed";
                        dd[i].tooltipString = sb.ToString();
                         

                    }
                    if (endTime > bookedStartTime && endTime < bookedEndTime)
                    {
                        dd[i].status = "Confirmed";
                        dd[i].tooltipString = sb.ToString();
                       

                    }

                }
            }
        }



        if (true)
        {
            for (int i = 0; i < dd.Count; i++)
            {


                DateTime startTime = Util.GetDateTime(dd[i].startDisplayTime);
                DateTime endTime = Util.GetDateTime(dd[i].endDisplayTime);


                //if (Util.GetDateTime(dd[i].startDisplayTime).ToString("hh:mm") == "08:00")
                //{
                //    int s = 0;
                //}

                for (int j = 0; j < dtBooked.Rows.Count; j++)
                {

                    var bookedStartTime = Util.GetDateTime(dtBooked.Rows[j]["StartTime"]);
                    var bookedEndTime = Util.GetDateTime(dtBooked.Rows[j]["EndTime"]);
                      
                    StringBuilder sb=new StringBuilder();
                    sb.Append("Name : "+Util.GetString(dtBooked.Rows[j]["PatientName"])+" , ");
                    sb.Append("UHID : " + Util.GetString(dtBooked.Rows[j]["PatientID"])+" , ");
                    sb.Append("Slot :" + bookedStartTime.ToString("hh:mm tt") + " to " + bookedEndTime.ToString("hh:mm tt") + " , ");
                     sb.Append("Doctor :" + Util.GetString(dtBooked.Rows[j]["DocotrName"])+" , ");
                     sb.Append("Surgery :" + Util.GetString(dtBooked.Rows[j]["SurgeryName"])+" , ");
                   
                    if (startTime > bookedStartTime && startTime < bookedEndTime)
                    {
                        dd[i].status = "Booked";
                        dd[i].tooltipString = sb.ToString();
                        dd[i].BookingId = Util.GetString(dtBooked.Rows[j]["bookingID"]);

                    }
                    if (startTime == bookedStartTime)
                    {
                        dd[i].status = "Booked";
                        dd[i].tooltipString = sb.ToString();
                        dd[i].BookingId = Util.GetString(dtBooked.Rows[j]["bookingID"]);

                    }
                    if (endTime > bookedStartTime && endTime < bookedEndTime)
                    {
                        dd[i].status = "Booked";
                        dd[i].tooltipString = sb.ToString();
                        dd[i].BookingId = Util.GetString(dtBooked.Rows[j]["bookingID"]);

                    }

                }
            }
        }



        return dd;

    }



    public List<Slot> CreateHTMLSlots(ref List<Slot> slotList)
    {


        for (int i = 0; i < slotList.Count; i++)
        {

            Slot s = slotList[i];
            s.index = i;
            var avilable = "<div class='ellipsis' style='float:left;margin: 2px;'> ";
            avilable += "<div id='" + s.index + "'  class='square badge-avilable'   onclick='onSelectOTSlotDetails(this)'>  ";
            avilable += "<span id='spnSlotTime' style='display:none'>" + s.startDisplayTime + "-" + s.endDisplayTime + "</span>";
            avilable += s.startDisplayTime;
            avilable += "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> ";
            avilable += s.endDisplayTime;
            avilable += " </div> </div> ";


            var expired = "<div class='ellipsis' style='float:left;margin: 2px;'> ";
            expired += "<div id='" + s.index + "'  class='square badge-grey' >  ";
            expired += "<span id='spnSlotTime' style='display:none'>" + s.startDisplayTime + "-" + s.endDisplayTime + "</span>";
            expired += s.startDisplayTime;
            expired += "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> ";
            expired += s.endDisplayTime;
            expired += " </div> </div> ";


            var confirmed = "<div class='ellipsis' style='float:left;margin: 2px;'> ";
            confirmed += "<div id='" + s.index + "'  data-tooltip='" + s.tooltipString + "' class='square badge-purple' " + "  >  ";
            confirmed += "<span id='spnSlotTime' style='display:none'>" + s.startDisplayTime + "-" + s.endDisplayTime + "</span>";
            confirmed += s.startDisplayTime;
            confirmed += "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> ";
            confirmed += s.endDisplayTime;
            confirmed += " </div> </div> ";

            var booked = "<div class='ellipsis' style='float:left;margin: 2px;'> ";
            booked += "<div id='" + s.index + "'  data-tooltip='" + s.tooltipString + "' class='square badge-yellow' " + " ondblclick=GetPatientDetailsForRescheduling('" + s.BookingId + "','" + s.bookedPatientID + "')  >  ";
            booked += "<span id='spnSlotTime' style='display:none'>" + s.startDisplayTime + "-" + s.endDisplayTime + "</span>";
            booked += s.startDisplayTime;
            booked += "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> ";
            booked += s.endDisplayTime;
            booked += " </div> </div> ";



            if (s.status == "Available")
                slotList[i].htmlDisplayString = avilable;
            else if (s.status == "Confirmed")
                slotList[i].htmlDisplayString = confirmed;
            else if (s.status == "Expired")
                slotList[i].htmlDisplayString = expired;
            else if (s.status == "Booked")
                slotList[i].htmlDisplayString = booked;

        }

        return slotList;
    }

}