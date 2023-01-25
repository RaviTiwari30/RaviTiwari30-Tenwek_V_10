using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_OTAnalysis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSchedulingDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate.Text = System.DateTime.Now.AddDays(-10).ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.AddDays(10).ToString("dd-MMM-yyyy");
        }

        txtSchedulingDate.Attributes.Add("readOnly", "readOnly");
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }




    [WebMethod]
    public static string GetDoctors()
    {
        DataTable dtDoctor = StockReports.GetDataTable("select DoctorID, Name from doctor_master where isactive=1 order by Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtDoctor);
    }


    public class OTStatus
    {
        public int status { get; set; }
    }


    [WebMethod]
    public static string GetAnalysis(string fromDate, int day)
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




        List<List<int>> otSchedule = new List<List<int>>(5);

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
            var rejected = 1;
            var expired = 2;


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


                    var confirmed = 4;


                    if (start_hr <= ti && end_hr > ti)
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            if (j == otcell)
                                otSchedule[j].Add(confirmed);
                            else
                                if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                                    otSchedule[j].Add(expired);
                                else
                                    otSchedule[j].Add(avilable);
                        }
                    }
                    else if ((Util.GetDateTime(fromDate).Date <= System.DateTime.Now.Date && System.DateTime.Now > endDateTime))
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            otSchedule[j].Add(expired);
                        }
                    }
                    else
                    {
                        for (int j = 0; j < otSchedule.Count; j++)
                        {
                            otSchedule[j].Add(avilable);
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
                        otSchedule[j].Add(expired);
                    }
                }
                else
                {
                    for (int j = 0; j < otSchedule.Count; j++)
                    {
                        otSchedule[j].Add(avilable);
                    }

                }
            }
        }


        return Newtonsoft.Json.JsonConvert.SerializeObject(otSchedule);

    }



}