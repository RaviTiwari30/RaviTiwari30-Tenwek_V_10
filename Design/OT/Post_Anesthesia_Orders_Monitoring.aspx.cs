using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;


public partial class Design_OT_Post_Anesthesia_Orders_Monitoring : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtCurrentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            CalendarExtender2.StartDate = System.DateTime.Now;
            CalendarExtender1.StartDate = System.DateTime.Now;
            txtCurrentTime.Text = System.DateTime.Now.ToString("h:mm tt");

            ViewState["TransactionID"] = Request.QueryString["TID"].ToString();
            ViewState["PatientID"] = Request.QueryString["PID"].ToString();
            ViewState["OTBookingID"] = Request.QueryString["OTBookingID"].ToString();
        }


        txtShiftOutDate.Attributes.Add("readonly", "readonly");
        txtCurrentDate.Attributes.Add("readonly", "readonly");
    }


    public class OtOrders
    {
        public int Id { get; set; }
        public string NPOFor { get; set; }
        public string Analgesics { get; set; }
        public string Antiemetics { get; set; }
        public string Ivfluids { get; set; }
        public string Thromboprophalaxis { get; set; }
        public string Antibiotics { get; set; }
        public string Other { get; set; }
        public string Createby { get; set; }
        public string Createon { get; set; }
        public int Isactive { get; set; }
        public string OTBookingID { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
    }

    public class OtMonitoring
    {
        public int Id { get; set; }
        public string Monitordate { get; set; }
        public string Monitortime { get; set; }
        public string Heartrate { get; set; }
        public string Bp { get; set; }
        public string Spo2 { get; set; }
        public string Painscore { get; set; }
        public string Sedation_score { get; set; }
        public string SedationscoreText { get; set; }
        public string SedationscoreValue { get; set; }
        public string Bromage_score { get; set; }
        public string BromagescoreText { get; set; }
        public string BromagescoreValue { get; set; }
        public string Aldretescore { get; set; }
        public string ActivityText { get; set; }
        public string ActivityValue { get; set; }
        public string RespirationsText { get; set; }
        public string RespirationsValue { get; set; }
        public string CirculationText { get; set; }
        public string CirculationValue { get; set; }
        public string ConsciousText { get; set; }
        public string ConsciousValue { get; set; }
        public string O2saturationText { get; set; }
        public string O2saturationValue { get; set; }
        public string Coments { get; set; }
        public string _Anesthesiologist { get; set; }
        public string Anesthesiologistid { get; set; }
        public string Shiftoutdate { get; set; }
        public string Shiftouttime { get; set; }
        public int Isactive { get; set; }
        public string Createdby { get; set; }
        public string Createdon { get; set; }
        public string OTBookingID { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
    }




    [WebMethod]
    public static string Save(OtOrders _OtOrders, OtMonitoring _OtMonitoring, string otBookingID, string transactionID, string patientID, int savetype)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();
        var centreID = HttpContext.Current.Session["CentreID"].ToString();
        var outPatientID = string.Empty;

        try
        {

            if (savetype == 2)
            {

                if (_OtMonitoring.Id > 0)
                {
                    excuteCMD.DML(tnx, "UPDATE  ot_post_anesthesia_monitoring t SET t.IsActive=0 ,t.LastUpdateDateTime=NOW(),t.LastUpdateBy=@userID WHERE t.ID=@monitoringID ", CommandType.Text, new
                    {

                        userID = userID,
                        monitoringID = _OtMonitoring.Id
                    });
                }

                StringBuilder sqlCMD = new StringBuilder("INSERT INTO ot_post_anesthesia_monitoring  ");
                sqlCMD.Append("( MonitorDate, MonitorTime, HeartRate, BP, SPO2, PainScore, SedationScore, SedationScore_text,");
                sqlCMD.Append("SedationScore_value, BromageScore, BromageScore_text, BromageScore_Value, AldreteScore, Activity_text, Activity_value, Respirations_text, Respirations_value,");
                sqlCMD.Append("Circulation_text, Circulation_value, Conscious_text, Conscious_value, O2Saturation_text, O2Saturation_value, Coments, Anesthesiologist, AnesthesiologistID, ShiftOutDate, ShiftOutTime, CreatedBy, OTID, PatientID, TransactionID )");
                sqlCMD.Append("VALUES (@Monitordate,@Monitortime,@Heartrate,@Bp,@Spo2,@Painscore,@Sedation_score,@SedationscoreText,");
                sqlCMD.Append("@SedationscoreValue,@Bromage_score,@BromagescoreText,@BromagescoreValue,@Aldretescore,@ActivityText,@ActivityValue,@RespirationsText,@RespirationsValue,");
                sqlCMD.Append("@CirculationText, @CirculationValue, @ConsciousText, @ConsciousValue, @O2saturationText, @O2saturationValue, @Coments, @_Anesthesiologist, @Anesthesiologistid, @Shiftoutdate, @Shiftouttime, @Createdby, @OTBookingID, @PatientID, @TransactionID )");

                _OtMonitoring.OTBookingID = otBookingID;
                _OtMonitoring.PatientID = patientID;
                _OtMonitoring.TransactionID = transactionID;
                _OtMonitoring.Monitordate = Util.GetDateTime(_OtMonitoring.Monitordate).ToString("yyyy-MM-dd");
                _OtMonitoring.Monitortime = Util.GetDateTime(_OtMonitoring.Monitortime).ToString("HH:mm");
                _OtMonitoring.Shiftoutdate = Util.GetDateTime(_OtMonitoring.Shiftoutdate).ToString("yyyy-MM-dd");
                _OtMonitoring.Shiftouttime = Util.GetDateTime(_OtMonitoring.Shiftoutdate + " " + _OtMonitoring.Shiftouttime).ToString("HH:mm");
                _OtMonitoring.Createdby = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, _OtMonitoring);
            }
            else if (savetype == 1)
            {


                excuteCMD.DML(tnx, "UPDATE  ot_post_anesthesia_orders t SET t.IsActive=0 ,t.LastUpdateDateTime=NOW(),t.LastUpdateBy=@userID WHERE t.TransactionID=@transactionID", CommandType.Text, new
                    {

                        userID = userID,
                        transactionID = transactionID
                    });



                StringBuilder sqlCMD = new StringBuilder("INSERT INTO ot_post_anesthesia_orders");
                sqlCMD.Append("(Analgesics, Antiemetics, IVFluids, Thromboprophalaxis, Antibiotics, Other, CreateBy,OTID, PatientID, TransactionID, NPOFor )");
                sqlCMD.Append("VALUES (@Analgesics,@Antiemetics,@Ivfluids,@Thromboprophalaxis,@Antibiotics,@Other,@Createby,@OTBookingID,@PatientID,@TransactionID,@NPOFor)");

                _OtOrders.OTBookingID = otBookingID;
                _OtOrders.PatientID = patientID;
                _OtOrders.TransactionID = transactionID;
                _OtOrders.Createby = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, _OtOrders);
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage, otNumber = otBookingID });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public static string GetPostAnesthesiaOrder(string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT ");
        sqlCMD.Append("ID, ");
        sqlCMD.Append("Analgesics, ");
        sqlCMD.Append("Antiemetics, ");
        sqlCMD.Append("IVFluids, ");
        sqlCMD.Append("Thromboprophalaxis, ");
        sqlCMD.Append("Antibiotics, ");
        sqlCMD.Append("Other, ");
        sqlCMD.Append("CreateBy, ");
        sqlCMD.Append("CreateOn, ");
        sqlCMD.Append("IsActive, ");
        sqlCMD.Append("OTID, ");
        sqlCMD.Append("PatientID, ");
        sqlCMD.Append("TransactionID, ");
        sqlCMD.Append("NPOFor ");
        sqlCMD.Append("FROM ");
        sqlCMD.Append("ot_post_anesthesia_orders sc WHERE sc.TransactionID=@transactionID AND sc.IsActive=1 ");

        ExcuteCMD excuteCMD = new ExcuteCMD();

        return Newtonsoft.Json.JsonConvert.SerializeObject(excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID
        }));
    }



    [WebMethod]
    public static string GetPostAnesthesiaMonitoring(string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder();

        sqlCMD.Append("  SELECT ID,");
        sqlCMD.Append("  DATE_FORMAT(MonitorDate,'%d-%b-%Y')MonitorDate, ");
        sqlCMD.Append("  TIME_FORMAT(MonitorTime,'%h:%i %p ')MonitorTime, ");
        sqlCMD.Append("  HeartRate, ");
        sqlCMD.Append("  BP, ");
        sqlCMD.Append("  SPO2, ");
        sqlCMD.Append("  PainScore, ");
        sqlCMD.Append("  SedationScore, ");
        sqlCMD.Append("  SedationScore_text, ");
        sqlCMD.Append("  SedationScore_value, ");
        sqlCMD.Append("  BromageScore, ");
        sqlCMD.Append("  BromageScore_text, ");
        sqlCMD.Append("  BromageScore_Value, ");
        sqlCMD.Append("  AldreteScore, ");
        sqlCMD.Append("  Activity_text, ");
        sqlCMD.Append("  Activity_value, ");
        sqlCMD.Append("  Respirations_text, ");
        sqlCMD.Append("  Respirations_value, ");
        sqlCMD.Append("  Circulation_text, ");
        sqlCMD.Append("  Circulation_value, ");
        sqlCMD.Append("  Conscious_text, ");
        sqlCMD.Append("  Conscious_value, ");
        sqlCMD.Append("  O2Saturation_text, ");
        sqlCMD.Append("  O2Saturation_value, ");
        sqlCMD.Append("  Coments, ");
        sqlCMD.Append("  Anesthesiologist, ");
        sqlCMD.Append("  AnesthesiologistID, ");
        sqlCMD.Append("  IF(ShiftOutDate='0001-01-01','',DATE_FORMAT(ShiftOutDate,'%d-%b-%Y'))ShiftOutDate, ");
        sqlCMD.Append("  IF(ShiftOutDate='0001-01-01','',TIME_FORMAT(ShiftOutTime,'%h:%i %p '))ShiftOutTime,   ");
        sqlCMD.Append("  IsActive, ");
        sqlCMD.Append("  CreatedBy, ");
        sqlCMD.Append("  CreatedOn, ");
        sqlCMD.Append("  OTID, ");
        sqlCMD.Append("  PatientID, ");
        sqlCMD.Append("  TransactionID ");
        sqlCMD.Append("FROM ");
        sqlCMD.Append("  ot_post_anesthesia_monitoring r WHERE r.TransactionID=@transactionID AND r.IsActive=1 ");

        ExcuteCMD excuteCMD = new ExcuteCMD();

        return Newtonsoft.Json.JsonConvert.SerializeObject(excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID
        }));

    }





}