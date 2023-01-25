using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Collections;
using System.Data;


public partial class Design_OPD_Calender : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetDoctor();
        }
    }
    public class Event
    {
        public Guid EventID { get { return new Guid(); } }
        public string EventName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string EventStarttime { get; set; }
        public string EventEndtime { get; set; }
        public string ImageType { get; set; }
        public string tooltip { get; set; }
        public bool allDays;
    }
    [WebMethod]
    public static IList GetEvents(string DocID)
    {
        IList events = new List<Event>();
        try
        {

        string query = "CALL Appointment_calender('" + DocID + "')";

            DataTable dt = StockReports.GetDataTable(query);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                events.Add(new Event
                {

                    EventName = dt.Rows[i]["PatientID"].ToString() + Environment.NewLine + dt.Rows[i]["Pname"].ToString(),
                    StartDate = Util.GetDateTime(dt.Rows[i]["date"].ToString()).ToString("MM-dd-yyyy"),
                    EndDate = Util.GetDateTime(dt.Rows[i]["date"].ToString()).ToString("MM-dd-yyyy"),
                    EventStarttime = Util.GetDateTime(dt.Rows[i]["time"].ToString()).ToString("H:mm"),
                    EventEndtime = Util.GetDateTime(dt.Rows[i]["EndTime"].ToString()).ToString("H:mm"),
                    ImageType = dt.Rows[i]["ISConform"].ToString(),
                    tooltip = "<p id='tooltip' style='position:absolute;background-color:#C2E6FF'><strong>Patient Name</strong> : " + dt.Rows[i]["Pname"].ToString() + "</p>",

                    allDays = true
                });
            }
            return events;
        }
        catch(Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return events;
        }
    }

   
    private long ConvertToTimestamp(DateTime value)
    {
        long epoch = (value.ToUniversalTime().Ticks - 621355968000000000) / 10000000;
        return epoch;
    }
    private long ToUnixTimespan(DateTime date)
    {
        TimeSpan tspan = date.ToUniversalTime().Subtract(
            new DateTime(1970, 1, 1, 0, 0, 0));

        return (long)Math.Truncate(tspan.TotalSeconds);
    }

    private void GetDoctor()
    {

    string DoctorID = StockReports.ExecuteScalar("select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'");

    if (DoctorID != null && DoctorID!="")
        lblDocID.Text = Util.GetString(DoctorID);

        
    }
}