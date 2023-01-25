using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_OT_OTPatientSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    [WebMethod]
    public static string bindOT()
    {
        DataTable dt = StockReports.GetDataTable("SELECT om.ID,om.Name FROM  ot_master om WHERE om.IsActive=1 order by om.Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession=true)]
    public static string GetOTPatientSearchData(string UHID, string IPDNo, string PatientName, string DoctorID, string BookingOTNo, int OTID, string FromDate, string ToDate, int isReceived, int isMap)
    {
        string GetTransactionID =string.Empty;
        if (IPDNo != "")
            GetTransactionID = StockReports.ExecuteScalar("SELECT TransactionID FROM patient_medical_history WHERE TransNo='" + IPDNo + "' AND Centreid='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        else
            GetTransactionID = IPDNo;

        string sql = " CALL `Get_OTPatientSearchData`('" + UHID + "','" + GetTransactionID + "','" + PatientName + "','" + DoctorID + "','" + BookingOTNo + "'," + OTID + ",'" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'," + isReceived + "," + isMap + "," + HttpContext.Current.Session["CentreID"].ToString() + ") ";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession=true)]
    public static string ReceivedOTPatient(int otBookingID)
    {

       MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            DataTable dtBookingDetails = StockReports.GetDataTable("SELECT TransactionID,PatientID,SurgeryID,OTNumber,OTID FROM ot_booking WHERE ID=" + otBookingID + "");
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO ot_PatientTAT(OTBookingID,TransactionID,PatientID,SurgeryID,OTBookingNo,OTID,TATTypeID,StaffTypeID,StaffID,StaffName,StartTime,EndTme,CentreID,EntryBy,EntryDateTime,IPAdress) ");
            sb.Append(" VALUES(@OTBookingID, @TransactionID, @PatientID, @SurgeryID, @OTBookingNo, @OTID, @TATTypeID, @StaffTypeID, @StaffID, @StaffName, @StartTime, @EndTme, @CentreID, @EntryBy, now(), @IPAdress) ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            sqlQuery = "UPDATE ot_booking SET IsPatientReceived=1,PatientReceivedBy=@PatientReceivedBy,PatientReceivedDate=NOW() WHERE ID=@OTBookingID ";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                OTBookingID = otBookingID,
                PatientReceivedBy = HttpContext.Current.Session["ID"].ToString()
            });

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                OTBookingID = otBookingID,
                TransactionID = dtBookingDetails.Rows[0]["TransactionID"].ToString(),
                PatientID = dtBookingDetails.Rows[0]["PatientID"].ToString(),
                SurgeryID = dtBookingDetails.Rows[0]["SurgeryID"].ToString(),
                OTBookingNo = dtBookingDetails.Rows[0]["OTNumber"].ToString(),
                OTID = dtBookingDetails.Rows[0]["OTID"].ToString(),
                TATTypeID = 1,
                StaffTypeID = 0,
                StaffID = "",
                StaffName = "",
                StartTime = Util.GetDateTime(System.DateTime.Now).ToString("HH:mm:ss"),
                EndTme = Util.GetDateTime(System.DateTime.Now).ToString("HH:mm:ss"),
                CentreID = HttpContext.Current.Session["CentreID"].ToString(),
                IPAdress = All_LoadData.IpAddress(),
                EntryBy = HttpContext.Current.Session["ID"].ToString()
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Received" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    


}
