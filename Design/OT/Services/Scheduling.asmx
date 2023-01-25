<%@ WebService Language="C#" Class="Scheduling" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Scheduling : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }





    public class ScheduleStatus
    {
        private List<List<slotDetail>> _schedule;
        public string date { get; set; }
        public string displayDate { get; set; }
        public string displayMonth { get; set; }
        public int IsCurrentDate { get; set; }
        public List<List<slotDetail>> schedule
        {
            get { return _schedule; }
            set { _schedule = value; }
        }
    }

    public class slotDetail
    {
        public int status { get; set; }
        public string doctorID { get; set; }
        public string doctorDepartmentID { get; set; }
        public string doctorName { get; set; }
        public string doctorDepartment { get; set; }
        public string OTDate { get; set; }
        public string tooltipString { get; set; }
        public int index { get; set; }
        public string startDisplayTime { get; set; }
        public string endDisplayTime { get; set; }
    }







    [WebMethod]
    public string GetOTSchedule(string fromDate, int day)
    {

        var selectedFromDate = Util.GetDateTime(fromDate).AddDays(Util.GetDouble(day));

        fromDate = selectedFromDate.ToString("dd-MMM-yyyy");





        string query = "select dm.Name as DoctorName,sur.Name  as SurgeryName, TransactionID,(select concat(Title,PName)" +
                         " from patient_master where PatientID=ot.PatientID) as PatientName ,PatientID,OT,Start_DateTime," +
                         " time(Start_DateTime) as start_time,time(End_Datetime) as end_time,Ass_Doc1,Anaesthetist1 from ot_surgery_schedule ot inner " +
                         " join f_surgery_master sur on ot.Surgery_ID=sur.Surgery_ID inner join doctor_master dm on " +
                         " ot.DoctorID=dm.DoctorID where IsCancel=0 and date(Start_DateTime)='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' order by time(Start_DateTime) ";
        DataTable dt1 = StockReports.GetDataTable(query);
        int count = dt1.Rows.Count;
        DataTable dt = StockReports.GetDataTable("select Time,TIME_FORMAT(concat(replace(time,'.',':')),'%l: %i %p') as DisplayTime from ot_timing where IsActive=1");


        List<string> otScheduleHtmlString = new List<string>() { string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty };
        List<List<slotDetail>> otSchedule = new List<List<slotDetail>>() { new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0) };
        List<string> StatusClassList = new List<string>() { "badge-avilable", "", "" };
        for (int a = 0; a < dt.Rows.Count; a++)
        {
            if (a == 46) {
                var de = 0;
            }
            
            
            
            decimal timeing = Convert.ToDecimal(dt.Rows[a]["Time"]);
            string time = timeing.ToString("f2");
            decimal ti = Convert.ToDecimal(time);

            var startDateTime = Util.GetDateTime(fromDate + " " + dt.Rows[a]["DisplayTime"].ToString());
            string startDisplayTime = startDateTime.AddMinutes(0).ToString("hh:mm tt"); //dt.Rows[a]["DisplayTime"].ToString();

            var endDateTime = Util.GetDateTime(fromDate + " " + dt.Rows[a]["DisplayTime"].ToString());
            string endDisplayTime = endDateTime.AddMinutes(30).ToString("hh:mm tt");


            var avilable = 0;
            var confirmed = 1;
            var expired = 2;

            for (int j = 0; j < otSchedule.Count; j++)
            {
                otSchedule[j].Add(new slotDetail { status = -1, doctorDepartment = "", doctorDepartmentID = "", doctorName = "", doctorID = "", OTDate = fromDate });
            }




            if (dt1.Rows.Count > 0)
            {
                for (int i = 0; i < dt1.Rows.Count; i++)
                {

                    decimal start_hr = Convert.ToDecimal(dt1.Rows[i]["start_time"].ToString().Split(':')[0]);
                    decimal start_min = Convert.ToInt32(dt1.Rows[i]["start_time"].ToString().Split(':')[1]);
                    //int start_min=
                    start_hr += Util.GetDecimal("." + start_min);
                    decimal end_hr = Convert.ToDecimal(dt1.Rows[i]["end_time"].ToString().Split(':')[0]);
                    decimal end_min = Convert.ToInt32(dt1.Rows[i]["end_time"].ToString().Split(':')[1]);
                    end_hr += Util.GetDecimal("." + end_min);
                    //int end_hr = Convert.ToInt32(dt1.Rows[0]["end_time"]);

                    if (start_hr == 00)
                        start_hr = 24;


                    if (end_hr == 00)
                        end_hr = 24;
                    
                    
                    string ot = dt1.Rows[i]["OT"].ToString();
                    int otcell = 0;
                    if (ot == "OT1")
                    { otcell = 1; }
                    else if (ot == "OT2")
                    { otcell = 2; }
                    else if (ot == "OT3")
                    { otcell = 3; }
                    else if (ot == "OT4")
                    { otcell = 4; }
                    else if (ot == "OT5")
                    { otcell = 5; }


                    //((Util.GetDateTime(fromDate).Date == System.DateTime.Now.Date && System.DateTime.Now > endDateTime) ? "class='circle badge-grey'" : 

                    var toolTip = "Surgeon Name:  " + dt1.Rows[i]["DoctorName"].ToString();
                    toolTip += "<br />Patient Name:  " + dt1.Rows[i]["PatientName"].ToString();
                    toolTip += "<br /> Surgery Name:  " + dt1.Rows[i]["SurgeryName"].ToString();
                    toolTip += "<br /> Start Time:  " + dt1.Rows[i]["start_time"].ToString() + "  End Time: " + dt1.Rows[i]["end_time"].ToString();





                    if (start_hr <= ti && end_hr > ti)
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {

                            var d = otSchedule[j][a].status;
                            if (j == otcell)
                            {
                                if (d == confirmed)
                                    continue;



                                otSchedule[j][a].status = confirmed;
                                otSchedule[j][a].index = a;
                                otSchedule[j][a].startDisplayTime = startDisplayTime;
                                otSchedule[j][a].endDisplayTime = endDisplayTime;
                                otSchedule[j][a].tooltipString = toolTip;
                            }
                            else
                            {
                                if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                                {

                                    if (d == confirmed)
                                        continue;

                                    if (d == expired)
                                        continue;

                                    if (d == avilable)
                                        continue;

                                    otSchedule[j][a].status = expired;
                                    otSchedule[j][a].index = a;
                                    otSchedule[j][a].startDisplayTime = startDisplayTime;
                                    otSchedule[j][a].endDisplayTime = endDisplayTime;

                                }
                                else
                                {

                                    if (d == confirmed)
                                        continue;

                                    if (d == expired)
                                        continue;

                                    if (d == avilable)
                                        continue;

                                    otSchedule[j][a].status = avilable;
                                    otSchedule[j][a].index = a;
                                    otSchedule[j][a].startDisplayTime = startDisplayTime;
                                    otSchedule[j][a].endDisplayTime = endDisplayTime;
                                }
                            }
                        }
                    }
                    else if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            var d = otSchedule[j][a].status;
                            if (d == confirmed)
                                continue;

                            if (d == expired)
                                continue;

                            if (d == avilable)
                                continue;

                            otSchedule[j][a].status = expired;
                            otSchedule[j][a].index = a;
                            otSchedule[j][a].startDisplayTime = startDisplayTime;
                            otSchedule[j][a].endDisplayTime = endDisplayTime;
                        }
                    }
                    else
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            var d = otSchedule[j][a].status;
                            if (d == confirmed)
                                continue;

                            if (d == expired)
                                continue;

                            if (d == avilable)
                                continue;

                            otSchedule[j][a].status = avilable;
                            otSchedule[j][a].index = a;
                            otSchedule[j][a].startDisplayTime = startDisplayTime;
                            otSchedule[j][a].endDisplayTime = endDisplayTime;
                        }

                    }

                }
            }
            else
            {
                if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                {
                    for (int j = 0; j < otSchedule.Count; j++)
                    {
                        otSchedule[j][a].status = expired;
                        otSchedule[j][a].index = a;
                        otSchedule[j][a].startDisplayTime = startDisplayTime;
                        otSchedule[j][a].endDisplayTime = endDisplayTime;
                    }
                }
                else
                {
                    for (int j = 0; j < otSchedule.Count; j++)
                    {
                        otSchedule[j][a].status = avilable;
                        otSchedule[j][a].index = a;
                        otSchedule[j][a].startDisplayTime = startDisplayTime;
                        otSchedule[j][a].endDisplayTime = endDisplayTime;
                    }

                }
            }
        }



        for (int i = 0; i < otSchedule.Count; i++)
        {
            var ot = otSchedule[i];
            for (int j = 0; j < ot.Count; j++)
            {

                var s = otSchedule[i][j];



                var avilable = "<div class='ellipsis' style='float:left;margin: 2px;'> ";
                avilable += "<div id='" + s.index + "'  class='square badge-avilable'   onclick='$selectSlot(this)'>  ";
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
                confirmed += "<div id='" + s.index + "' data-title='" + s.tooltipString + "' class='square badge-purple' " + "  >  ";
                confirmed += "<span id='spnSlotTime' style='display:none'>" + s.startDisplayTime + "-" + s.endDisplayTime + "</span>";
                confirmed += s.startDisplayTime;
                confirmed += "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> ";
                confirmed += s.endDisplayTime;
                confirmed += " </div> </div> ";

                if (s.status == 0)
                    otScheduleHtmlString[i] = otScheduleHtmlString[i] + avilable;
                else if (s.status == 1)
                    otScheduleHtmlString[i] = otScheduleHtmlString[i] + confirmed;
                else if (s.status == 2)
                    otScheduleHtmlString[i] = otScheduleHtmlString[i] + expired;
            }
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { data = otScheduleHtmlString, date = fromDate });

    }


}