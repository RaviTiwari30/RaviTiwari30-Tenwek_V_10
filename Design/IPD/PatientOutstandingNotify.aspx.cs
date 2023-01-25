using System;
using System.Data;
using System.Web;
using System.Web.Services;


using System.Collections.Generic;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;



public partial class Design_IPD_PatientOutstandingNotify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindFloor()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT FloorID AS ID,Role_ID,fm.Name AS NAME FROM f_roomtype_role  rm INNER JOIN Floor_master fm ON fm.ID=rm.FloorID WHERE Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' GROUP BY FloorID,Role_ID ORDER BY fm.SequenceNo+0 ");
        if (dt.Rows.Count < 1)
            dt = AllLoadData_IPD.loadFloor();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string BindRoomType(string FloorID, int isAttenderRoom)
    {
        DataTable dtData = new DataTable();
        if (FloorID == "0")
        {
            if ((isAttenderRoom == 0) || (isAttenderRoom == 1))
                dtData = AllLoadData_IPD.LoadCaseType().AsEnumerable().Where(r => r.Field<int>("isAttenderRoom") == isAttenderRoom).AsDataView().ToTable();
            else
                dtData = AllLoadData_IPD.LoadCaseType();
        }
        else
        {
            dtData = StockReports.GetDataTable("SELECT DISTINCT(ich.IPDCaseType_ID)IPDCaseType_ID,ich.Name,Role_ID FROM f_roomtype_role rt INNER JOIN ipd_case_type_master ich ON ich.IPDCaseType_ID=rt.IPDCaseType_ID  where Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' And FloorID='" + FloorID + "'");
            if (dtData.Rows.Count < 1)
                dtData = AllLoadData_IPD.LoadCaseType();
        }
        if (dtData.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string PatientSearch(string MRNo, string PName, string Department, string Floor, string AgeFrom, string ddlAgeFrom, string AgeTo, string ddlAgeTo, string RoomType, string IPDNo, string DoctorID, string Panel, string ParentPanel, string FromDate, string ToDate, string AdmitDischarge, string Type, string id, int IsPatientReceived)
    {
        string FromAdmitDate = "", LabNo = "", ToAdmitDate = "", VisitDateFrom = "", VisitDateTo = "", DischargeDateFrom = "", DischargeDateTo = "";
        string TransactionId = "", status = "";
        string PAgeFrom = "", PAgeTo = "", FromIntimationDate = "", ToIntimationDate = "", UserType = "", UserID = "";


        if (IPDNo != "")
            TransactionId = "ISHHI" + IPDNo.Trim();
        if (AgeFrom != "")
            PAgeFrom = AgeFrom.Trim() + " " + ddlAgeFrom.Trim();
        if (AgeTo != "")
            PAgeTo = AgeTo.Trim() + " " + ddlAgeTo.Trim();
        if (AdmitDischarge.ToUpper() == "CAD")
        {
            status = "IN";
            FromAdmitDate = "";
            ToAdmitDate = "";
        }
        else if (AdmitDischarge.ToUpper() == "AD")
        {
            status = "IN";
            FromAdmitDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            ToAdmitDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        }
        else if (AdmitDischarge.ToUpper() == "ID")
        {
            status = "IN";
            FromIntimationDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            ToIntimationDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        }
        else
        {
            status = "OUT";
            DischargeDateFrom = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            DischargeDateTo = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        }

        UserID = HttpContext.Current.Session["ID"].ToString();
        UserType = StockReports.ExecuteScalar("SELECT UCASE(utm.name) FROM employee_master em INNER JOIN user_type_master utm ON utm.User_Type_ID = em.UserType_ID AND em.employee_Id='" + UserID + "'");

        DataTable dt = AllLoadData_IPD.SearchPatient(Util.GetFullPatientID(MRNo), PName, TransactionId, RoomType, DoctorID, Panel, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status, LabNo, Department, PAgeFrom, PAgeTo, ParentPanel, Floor, FromIntimationDate, ToIntimationDate, AdmitDischarge, Type, IsPatientReceived, UserType, UserID, 1);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("LoginType");
            dc.DefaultValue = HttpContext.Current.Session["RoleID"].ToString();
            dt.Columns.Add(dc);
            DataView dv = dt.DefaultView;
            if (id != "0")
            {
                if (id == "1")
                {
                    dv.RowFilter = "amtpaid='1' AND TransactionID <> ''";
                }
                else if (id == "2")
                {
                    dv.RowFilter = "amtpaid='2' AND TransactionID <> ''";
                }
                else if (id == "3")
                {
                    dv.RowFilter = "amtpaid='0' AND TransactionID <> ''";
                }
            }
            else
            {
                dv.RowFilter = "TransactionID <> ''";
            }
            if (dv.ToTable().Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
            else
                return "";
        }
        else
            return "";
    }


    public class patientDetails
    {
        public string TransactionID { get; set; }
        public string PatientID { get; set; }
        public string OutStandingAmount { get; set; }
        public string PanelName { get; set; }
        public string PName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string SendBy { get; set; }
        public string NotifyThrough { get; set; }
    }


    [WebMethod(EnableSession = true)]
    public static string SendEmail(List<patientDetails> selectedPatients)
    {

        //MySqlConnection con = Util.GetMySqlCon();
        //con.Open();
        ExcuteCMD excuteCMD = new ExcuteCMD();


        try
        {


            for (int i = 0; i < selectedPatients.Count; i++)
            {
                if (!string.IsNullOrEmpty(selectedPatients[i].Email))
                {

                    // List<EmailTemplateInfo> emailDetails = Email_Master.getemailColumnInfo("PatientID#TransactionID#PatientName#Age#DoctorID#DoctorName#TemplateID#Title#AppDate#RoomNo#BedNo#PanelName#EmployeeName#UserName#RoomType#IPNo#Discount#ApprovalAmount");
                    List<EmailTemplateInfo> emailDetails = new List<EmailTemplateInfo>();
                    emailDetails.Add(new EmailTemplateInfo
                    {
                        EmailTo = selectedPatients[i].Email,
                        TransactionID = selectedPatients[i].TransactionID,
                        PatientID = selectedPatients[i].PatientID,
                        PanelName = selectedPatients[i].PatientID,
                        PName = selectedPatients[i].PName,
                        BillAmount = selectedPatients[i].OutStandingAmount,
                    });

                    Email_Master.SaveEmailTemplate(1, Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "", emailDetails, null);

                }

                selectedPatients[i].SendBy = HttpContext.Current.Session["ID"].ToString();
                selectedPatients[i].NotifyThrough = "EMAIL";
                var sqlCMD = new StringBuilder("INSERT INTO ipd_outstanding_notify (TransactionID, OutStandingAmount, Email, Phone, SendBy,NotifyThrough )  ");
                sqlCMD.Append(" VALUES (@TransactionID,@OutStandingAmount,@Email,@Phone,@SendBy,@NotifyThrough) ");
                selectedPatients[i].SendBy = HttpContext.Current.Session["ID"].ToString();
                excuteCMD.DML(sqlCMD.ToString(), CommandType.Text, selectedPatients[i]);
            }





            //Sms_Host objSms = new Sms_Host();
            //objSms._Msg = "";
            //objSms._SmsTo = "";
            //objSms._PatientID = "";
            //objSms._TemplateID = 3;
            //objSms._UserID = HttpContext.Current.Session["ID"].ToString();
            //objSms._smsType = 1;
            //int smsCon = objSms.sendSms();


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });


        }
        catch (Exception ex)
        {
            //tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            //  tnx.Dispose();
            //con.Close();
            //con.Dispose();
        }
    }




    [WebMethod(EnableSession = true)]
    public static string SendSMS(List<patientDetails> selectedPatients)
    {

        //MySqlConnection con = Util.GetMySqlCon();
        //con.Open();
        ExcuteCMD excuteCMD = new ExcuteCMD();


        try
        {


            for (int i = 0; i < selectedPatients.Count; i++)
            {
                if (!string.IsNullOrEmpty(selectedPatients[i].Phone))
                {

                    var message = "Dear Patient,OutStandingAmount:" + selectedPatients[i].OutStandingAmount;
                    
                    Sms_Host objSms = new Sms_Host();
                    objSms._Msg = message;
                    objSms._SmsTo = selectedPatients[i].Phone;
                    objSms._PatientID = selectedPatients[i].PatientID;
                    objSms._TemplateID = 3;
                    objSms._UserID = HttpContext.Current.Session["ID"].ToString();
                    objSms._smsType = 1;
                    int smsCon = objSms.sendSms();

                }

                selectedPatients[i].SendBy = HttpContext.Current.Session["ID"].ToString();
                selectedPatients[i].NotifyThrough = "SMS";
                var sqlCMD = new StringBuilder("INSERT INTO ipd_outstanding_notify (TransactionID, OutStandingAmount, Email, Phone, SendBy,NotifyThrough )  ");
                sqlCMD.Append(" VALUES (@TransactionID,@OutStandingAmount,@Email,@Phone,@SendBy,@NotifyThrough) ");
                selectedPatients[i].SendBy = HttpContext.Current.Session["ID"].ToString();
                excuteCMD.DML(sqlCMD.ToString(), CommandType.Text, selectedPatients[i]);
            }


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });


        }
        catch (Exception ex)
        {
            //tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            //  tnx.Dispose();
            //con.Close();
            //con.Dispose();
        }
    }




}
