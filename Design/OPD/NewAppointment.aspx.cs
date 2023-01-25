using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.UI.HtmlControls;

public partial class Design_OPD_NewAppointment : System.Web.UI.Page
{

   
    [WebMethod]
    public static string bindAppDetail(string App_ID)
    {
        DataTable dtAppDetail = AllLoadData_OPD.bindAppointmentDetail(App_ID);
        if (dtAppDetail.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtAppDetail);
        else
            return "";
    }

    [WebMethod]
    public static string bindAppointmentDetail(string App_ID)
    {
        DataTable dtAppointmentDetail = StockReports.GetDataTable("SELECT DATE_FORMAT(DATE,'%d-%b-%Y')AppDate,DATE_FORMAT(TIME,'%h:%i %p')AppTime, " +
                   " (SELECT DATE_FORMAT(DATE_ADD( TIME,INTERVAL 10 MINUTE),'%h:%i %p') FROM  appointment_detail WHERE id=(SELECT MAX(id) FROM appointment_detail " +
                   " WHERE IsCancel=0 AND App_id=" + Util.GetInt(App_ID) + "))maxAppTime FROM appointment_detail WHERE IsCancel=0 AND App_ID=" + Util.GetInt(App_ID) + " ");
        if (dtAppointmentDetail.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtAppointmentDetail);
        else
            return "";
    }

    [WebMethod]
    public static string bindSubCategory(string ItemID)
    {
        DataTable dtSubCategory = All_LoadData.LoadSubcategoryIDByItemsID(ItemID);
        if (dtSubCategory.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSubCategory);
        else
            return "";
    }

    [WebMethod]
    public static string CreateSlot(string start, string end, string DoctorID, string Date)
    {
        DateTime StartTime = Util.GetDateTime(start);
        DateTime EndTime = Util.GetDateTime(end);
        DataTable dtBookDetail = StockReports.GetDataTable(" SELECT ad.Time,CONCAT(Title,' ',PName)NAME,a.IsConform FROM appointment_detail ad INNER JOIN appointment a ON ad.app_ID=a.App_ID WHERE ad.DoctorID='" + DoctorID + "' and ad.Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' and ad.IScancel=0");

        int flag = 0;
        string output = "<div id='main'>";
        if (Util.GetDateTime(Date) > System.DateTime.Now)
        {
            while (StartTime < EndTime)
            {
                foreach (DataRow row in dtBookDetail.Rows)
                {
                    if (Util.GetDateTime(row["Time"]).ToString("HH:mm") == StartTime.ToString("HH:mm"))
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
                if (flag == 1)
                {
                    output += " <div id='row' class='BlockApp' style='border:thin dotted Black;  height:12px;width:100%; font-size:12px;'>" + StartTime.ToString("hh:mm tt") + "</div> ";
                }
                else if (flag == 2)
                {
                    output += " <div id='row' class='ConfirmApp' style='border:thin dotted Black;  height:12px;width:100%; font-size:12px;'>" + StartTime.ToString("hh:mm tt") + "</div> ";
                }
                else
                {
                    output += " <div id='row' style='border:thin dotted Black; cursor:pointer; height:12px;width:100%; font-size:12px;'>" + StartTime.ToString("hh:mm tt") + "</div> ";
                }
                flag = 0;
                StartTime = StartTime.AddMinutes(10);
            }

            output += "</div>";
            return output;
        }
        else
        {
            string[] time = System.DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt").Split(':');
            string str = time[1].Split(' ')[1];
            double Min = Util.GetDouble(System.DateTime.Now.Minute) / 10;
            int TMin = Util.GetInt(Math.Round(Min, 0));
            TMin = TMin * 10;
            string strTmin = TMin.ToString();
            if (strTmin.Length == 1)
            {
                strTmin = "0" + strTmin;
            }
            string RoundTime = string.Empty;
            if (strTmin == "60")
            {
                string ampm = Util.GetString(Util.GetDateTime(time[0] + ":" + time[1]).AddMinutes(10).ToString("tt"));

                RoundTime = System.DateTime.Now.ToString("dd/MMM/yyyy");
                //string hrs = Util.GetString(Util.GetInt(time[0].Split(' ')[1]) + 1);
                string hrs = Util.GetString(Util.GetDateTime(time[0] + ":" + time[1]).AddMinutes(10).ToString("hh"));

                if (hrs.Length == 1)
                {
                    hrs = "0" + hrs;
                }
                //if (str == "AM")
                //    RoundTime = RoundTime + " " + hrs + ":00 " + "PM";
                //else
                RoundTime = RoundTime + " " + hrs + ":00 " + ampm;
            }
            else
            {
                string ampm = Util.GetString(Util.GetDateTime(time[0] + ":" + time[1]).ToString("tt"));

                RoundTime = time[0] + ":" + strTmin + " " + ampm;
            }
            //  DateTime StartRTime = DateTime.ParseExact(RoundTime, "dd-MMM-yyyy hh:mm tt", CultureInfo.InvariantCulture);
            DateTime StartRTime = Convert.ToDateTime(RoundTime);
            if (StartTime > DateTime.Now)
            {
                StartRTime = StartTime;
            }

            while (StartRTime < EndTime)
            {
                foreach (DataRow row in dtBookDetail.Rows)
                {
                    if (Util.GetDateTime(row["Time"]).ToString("HH:mm") == StartRTime.ToString("HH:mm"))
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
                if (flag == 1)
                {
                    output += " <div id='row' class='BlockApp' style='border:thin dotted Black;  height:12px;width:100%; font-size:12px;'>" + StartRTime.ToString("hh:mm tt") + "</div> ";
                }
                else if (flag == 2)
                {
                    output += " <div id='row' class='ConfirmApp' style='border:thin dotted Black;  height:12px;width:100%; font-size:12px;'>" + StartRTime.ToString("hh:mm tt") + "</div> ";
                }
                else
                {
                    output += " <div id='row' style='border:thin dotted Black; cursor:pointer; height:12px;width:100%; font-size:12px;'>" + StartRTime.ToString("hh:mm tt") + "</div> ";
                }
                flag = 0;
                StartRTime = StartRTime.AddMinutes(10);
            }

            output += "</div>";
            return output;
        }
    }

    [WebMethod]
    public static int DurationforNewPatient(string DoctorID, string Day, string Date)
    {
        var Result = Util.GetInt(StockReports.ExecuteScalar(" SELECT  DurationforNewPatient FROM doctor_hospital WHERE DoctorID='" + DoctorID + "' AND DAY='" + Day + "' "));
        if (Result == 0)
        {
            Result = Util.GetInt(StockReports.ExecuteScalar(" SELECT  DurationforNewPatient FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' and Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' "));
        }
        return Result;
    }

    [WebMethod]
    public static int DurationforOldPatient(string DoctorID, string Day, string Date)
    {
        var Result = Util.GetInt(StockReports.ExecuteScalar(" SELECT  DurationforOldPatient FROM doctor_hospital WHERE DoctorID='" + DoctorID + "' AND DAY='" + Day + "' "));
        if (Result == 0)
        {
            Result = Util.GetInt(StockReports.ExecuteScalar(" SELECT  DurationforOldPatient FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' and Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' "));
        }
        return Result;
    }

    [WebMethod]
    public static string EndTime(string DoctorID, string Day, string Date)
    {
        var Result = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM doctor_hospital WHERE DoctorID='" + DoctorID + "' AND DAY='" + Day + "' "));
        if (Result == "")
        {
            Result = Util.GetString(StockReports.ExecuteScalar(" SELECT  EndTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' and Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' "));
        }
        return Result;
    }

    [WebMethod]
    public static string getDocDays(string DoctorID)
    {
        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT DISTINCT(DAY) FROM `doctor_hospital` WHERE DoctorID='" + DoctorID + "'"));
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT DISTINCT(DAY) FROM `doctor_hospital` WHERE DoctorID='" + DoctorID + "'");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string getDocName(string DoctorID)
    {
        return StockReports.ExecuteScalar("SELECT CONCAT(title,'',NAME)Name FROM doctor_master WHERE DoctorID='" + DoctorID + "' ");
    }

    [WebMethod]
    public static string[] getDoTimingDateWise(string DoctorID)
    {
        List<string> dates = new List<string>();
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT CONCAT(DATE_FORMAT(DATE,'%Y-%c-%e'))DocDate  FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' AND DATE(DATE)>=CURDATE()");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                //  dates.Add(string.Format("{0:dd/MM/yyyy}", dt.Rows[i]["DocDate"].ToString()));
                dates.Add(dt.Rows[i]["DocDate"].ToString());
            }
        }
        return dates.ToArray();
    }
    [WebMethod]
    public static string getScheduledAppTime(string DoctorID, string Date, string App_ID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT TIME,DATE FROM appointment WHERE DoctorID='" + DoctorID + "' AND DATE='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND App_ID='" + App_ID + "' ");
        if (dt.Rows.Count > 0)
            return Util.GetDateTime(dt.Rows[0]["TIME"]).ToString("HH:mm");
        else
            return "";
    }

    [WebMethod]
    public static string StartTime(string DoctorID, string Day, string Date)
    {
        var Result = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM doctor_hospital WHERE DoctorID='" + DoctorID + "' AND DAY='" + Day + "' "));
        if (Result == "")
        {
            Result = Util.GetString(StockReports.ExecuteScalar(" SELECT  StartTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' and Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' "));
        }
        return Result;
    }

    
    protected void Page_Load(object sender, EventArgs e)
    {
        // ((HtmlTableRow)PatientInfo.FindControl("divAppointment")).Attributes.Add("style", "display:none");
        //((HtmlGenericControl)PatientInfo.FindControl("divApp")).Attributes.Add("style", "display:none");
    }
    [WebMethod]
    public static string bindAppVisitType()
    {
        DataTable dtAppVisitType = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("5"));
        DataView appVisitTypeView = dtAppVisitType.DefaultView;
        appVisitTypeView.RowFilter = "SubCategoryID<>'LSHHI46'";
        dtAppVisitType = appVisitTypeView.ToTable();
        if (dtAppVisitType.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtAppVisitType);
        else
            return "";
    }
}