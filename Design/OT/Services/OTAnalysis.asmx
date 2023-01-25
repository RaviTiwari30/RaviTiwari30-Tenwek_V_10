<%@ WebService Language="C#" Class="OTAnalysis" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[System.Web.Script.Services.ScriptService]
public class OTAnalysis : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    public static IEnumerable<DateTime> EachDay(DateTime from, DateTime thru)
    {
        for (var day = from.Date; day.Date <= thru.Date; day = day.AddDays(1))
            yield return day;
    }





    [WebMethod]
    public string GetAnalysis(string fromDate, string toDate, string departmentID, string doctorID, string month, string year, int isRangeSearch)
    {


        if (isRangeSearch == 0)
        {
            var dateFromMonth = Util.GetDateTime("01-" + month + "-" + year);
            fromDate = new DateTime(dateFromMonth.Year, dateFromMonth.Month, 1).ToString("yyyy-MMM-dd");
            toDate = new DateTime(dateFromMonth.Year, dateFromMonth.Month, 1).AddMonths(1).AddDays(-1).ToString("yyyy-MMM-dd");
        }

        List<ScheduleStatus> analysis = new List<ScheduleStatus>();

        //Util.GetDateTime(fromDate).ToString("yyyy-MM-dd")



        StringBuilder sqlCmd = new StringBuilder("select sur.Name  as SurgeryName, TransactionID,(select concat(Title,PName) ");
        sqlCmd.Append(" from patient_master where PatientID=ot.PatientID) as PatientName ,PatientID,OT,Start_DateTime, ");
        sqlCmd.Append(" time(Start_DateTime) as start_time,time(End_Datetime) as end_time,Ass_Doc1,Anaesthetist1,DATE(Start_DateTime)OTDate,dm.DoctorID,dm.DocDepartmentID,dm.Designation,CONCAT(dm.Title,' ',dm.Name)DoctorName from ot_surgery_schedule ot inner ");
        sqlCmd.Append(" join f_surgery_master sur on ot.Surgery_ID=sur.Surgery_ID inner join doctor_master dm on ");
        sqlCmd.Append(" ot.DoctorID=dm.DoctorID where IsCancel=0   AND DATE(Start_DateTime) >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(Start_DateTime) <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");

        if (departmentID != "0")
            sqlCmd.Append(" AND dm.DocDepartmentID='" + departmentID + "' ");
        
        if (doctorID != "0")
                sqlCmd.Append(" AND dm.DoctorID='" + doctorID + "' ");




        sqlCmd.Append(" order by time(Start_DateTime) ");

        DataTable dt1 = StockReports.GetDataTable(sqlCmd.ToString());




        int count = dt1.Rows.Count;
        DataTable dt = StockReports.GetDataTable("select Time,TIME_FORMAT(concat(replace(time,'.',':')),'%l: %i %p') as DisplayTime from ot_timing where IsActive=1");

        foreach (DateTime day in EachDay(Util.GetDateTime(fromDate), Util.GetDateTime(toDate)))
        {
            DataView dv = dt1.AsDataView();
            dv.RowFilter = "OTDate='" + day.ToString("yyyy-MM-dd") + " '";
            analysis.Add(GetData(day, departmentID, doctorID, dt, dv.ToTable()));
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(analysis);
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
    }



    public static ScheduleStatus GetData(DateTime date, string departmentID, string doctorID, DataTable dt, DataTable dt1)
    {


        // var selectedFromDate = Util.GetDateTime(fromDate).AddDays(Util.GetDouble(0));

        var fromDate = date.ToString("dd-MMM-yyyy");








        List<List<slotDetail>> otSchedule = new List<List<slotDetail>>() { new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0), new List<slotDetail>(0) };

        for (int a = 0; a < dt.Rows.Count; a++)
        {
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
                otSchedule[j].Add(new slotDetail { status = avilable, doctorDepartment = "", doctorDepartmentID = "", doctorName = "", doctorID = "", OTDate = fromDate });
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



                    if (start_hr == 00)
                        start_hr = 24;


                    if (end_hr == 00)
                        end_hr = 24;
                    
                    
                    
                    //int end_hr = Convert.ToInt32(dt1.Rows[0]["end_time"]);
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
                            if (d == confirmed)
                                continue;

                            if (j == otcell)
                            {
                                otSchedule[j][a].status = confirmed;
                                otSchedule[j][a].doctorID = dt1.Rows[i]["DoctorID"].ToString();
                                otSchedule[j][a].doctorName = dt1.Rows[i]["DoctorName"].ToString();
                                otSchedule[j][a].doctorDepartmentID = dt1.Rows[i]["DocDepartmentID"].ToString();
                                otSchedule[j][a].doctorDepartment = dt1.Rows[i]["Designation"].ToString();

                            }
                            else
                                if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                                    otSchedule[j][a].status = expired;
                                else
                                    otSchedule[j][a].status = avilable;
                        }
                    }
                    else if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            var d = otSchedule[j][a].status;
                            if (d == confirmed)
                                continue;

                            otSchedule[j][a].status = expired;
                        }
                    }
                    else
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            var d = otSchedule[j][a].status;
                            if (d == confirmed)
                                continue;

                            otSchedule[j][a].status = avilable;
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
                    }
                }
            }
        }



        var displayDate = date.ToString("dd");
        var displayMonth = date.ToString("MMM");
        var isCurrentDate = date.Date == System.DateTime.Now.Date ? 1 : 0;
        return new ScheduleStatus { date = fromDate, displayDate = displayDate, displayMonth = displayMonth, IsCurrentDate = isCurrentDate, schedule = otSchedule };

    }


    public class detail
    {
        public decimal value { get; set; }
        public decimal percent { get; set; }
        public int total { get; set; }
        public string display { get; set; }
    }



    [WebMethod]
    public string Analyse(List<slotDetail> slots, int analyseType)
    {
        
        List<detail> detailList = new List<detail>();
        if (analyseType == 0)
        {
            var distinctDate = slots.Select(s => s.OTDate).Distinct().ToList();

            for (int i = 0; i < distinctDate.Count; i++)
            {
                var date = distinctDate[i];
                var todaySlots = slots.Where(s => (s.OTDate == date && s.status==1)).ToList();
                var percent = ((todaySlots.Count * 100) / slots.Count);
                detailList.Add(new detail
                { 
                    display=date,
                    percent = percent,
                    total = slots.Count,
                    value = todaySlots.Count
                });

            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(detailList);
        }

        if (analyseType == 1)
        {
            var distinctDoctorIDs = slots.Where(s=> s.doctorID !="").ToList().Select(s => s.doctorID).Distinct().ToList();

            for (int i = 0; i < distinctDoctorIDs.Count; i++)
            {
                var doctor = distinctDoctorIDs[i];
                var doctorSlots = slots.Where(s => (s.doctorID == doctor && s.status == 1)).ToList();
                var percent = ((doctorSlots.Count * 100) / slots.Count);
                detailList.Add(new detail
                {
                    display = doctorSlots[0].doctorName,
                    percent = percent,
                    total = slots.Count,
                    value = doctorSlots.Count
                });

            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(detailList);
        }

        if (analyseType == 2)
        {
            var distinctDoctorDepartmentIds = slots.Where(s => s.doctorDepartmentID != "").ToList().Select(s => s.doctorDepartmentID).Distinct().ToList();

            for (int i = 0; i < distinctDoctorDepartmentIds.Count; i++)
            {
                var doctorDepartmentID = distinctDoctorDepartmentIds[i];
                var doctorDepartmentSlots = slots.Where(s => (s.doctorDepartmentID == doctorDepartmentID && s.status == 1)).ToList();
                var percent = ((doctorDepartmentSlots.Count * 100) / slots.Count);
                detailList.Add(new detail
                {
                    display = doctorDepartmentSlots[0].doctorDepartment,
                    percent = percent,
                    total = slots.Count,
                    value = doctorDepartmentSlots.Count
                });

            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(detailList);
        }

        return "[]";

    }



}