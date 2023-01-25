using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Text;
using System.Data;
using System.Text.RegularExpressions;

public partial class Design_SMS_PatientWiseSMS : System.Web.UI.Page
{
    string TID = "";
    string PID = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            TID = Request.QueryString["TransactionID"].ToString();
            PID = Request.QueryString["PID"].ToString();
            ViewState["PID"] = PID;
            ViewState["TID"] = TID;
            lblPatientMobile.Text = Util.GetString(StockReports.ExecuteScalar("select IFNULL(Mobile,'')Mobile from patient_master pm where pm.PatientID='" + PID + "'"));
            lblPatientEmail.Text = Util.GetString(StockReports.ExecuteScalar("select IFNULL(Email,'')Email from patient_master pm where pm.PatientID='" + PID + "'"));

            if (lblPatientMobile.Text == "" || lblPatientMobile.Text.Length > 10 || lblPatientMobile.Text == "0000000000")
            {
                lblMsg.Text = "Please  update the patient mobile no";
                btnSave.Visible = false;

                return;
            }
            else { btnSave.Visible = true; }

        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string msg = txtMessage.Text;
            if (string.IsNullOrEmpty(msg.Trim()))
            {
                lblMsg.Text = "Please Enter the SMS Text";
                return;
            }


            string contact = "0";
            int smsCon = 0;
            string[] str = contact.Split(",".ToCharArray());
            for (int i = 0; i < str.Length; i++)
            {
                string MobNo = "";
                if (chkIsOtherMobileNumber.Checked)
                {
                    MobNo = txtOtherMobileNo.Text;
                }
                else
                {
                    MobNo = lblPatientMobile.Text;
                }
                
                Sms_Host objSms = new Sms_Host();
                objSms._Msg = msg.ToString();
                objSms._SmsTo = MobNo;// lblPatientMobile.Text;
                objSms._PatientID = ViewState["PID"].ToString();
                objSms._DoctorID = "";
                objSms._EmployeeID = Session["ID"].ToString();
                objSms._TemplateID = 0;
                objSms._UserID = HttpContext.Current.Session["ID"].ToString();
                objSms._smsType = 1;//For Patient
                objSms._CentreID = Util.GetInt(Session["CentreID"]);
                objSms._TransactionID = ViewState["TID"].ToString();
                smsCon = objSms.sendSms();
            }
            if (smsCon != 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Message Send Successfully');", true);
                txtMessage.Text = "";
                txtOtherMobileNo.Text = "";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Message Not Sent');", true);
            }

            //lblMsg.Text = "Message Send Successfully";


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindPatientSMSList(string TID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sl.Mobile_No,IFNULL(sl.SMS_Text,'')SMS_Text,pmh.type,CONCAT(em.Title,' ',em.NAME)SendBy,DATE_FORMAT(sl.EntryDate,'%d-%b-%Y')SendDate ");
        sb.Append(" ,IF(sl.IsSend=1 AND sl.IsDelivered=1,'Delivered','Pending')STATUS,IFNULL(DATE_FORMAT(sl.Deliverydate,'%d-%b-%Y'),'')DeliveryDate ");
        sb.Append(" FROM patient_medical_history pmh INNER JOIN sms_log sl ON pmh.TransactionID=sl.TransactionID ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID=sl.EmployeeID ");
        sb.Append(" WHERE sl.TransactionID='" + TID + "' ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }
    protected void btnEmailSave_Click(object sender, EventArgs e)
    {
        string ToEmailId = "";

        lblEmailError.Text = "";

        if (chkAlternatEmail.Checked)
        {
            ToEmailId = txtOtherEmail.Text;
        }
        else
        {
            ToEmailId = lblPatientEmail.Text;
        }


        if (string.IsNullOrEmpty(ToEmailId))
        {
            lblEmailError.Text = "Please Enter the Email Id";
            return;
        }
        bool IsValidEmailId = isValidEmail(ToEmailId);

        if (!IsValidEmailId)
        {

            lblEmailError.Text = "Please Enter the Valid Email Id";
            return;
        }



        if (txtEmailSubject.Text == "")
        {
            lblEmailError.Text = "Please Enter the Email Subject";
            return;
        }

        if (txtEmailBody.Text == "")
        {
            lblEmailError.Text = "Please Enter the Email Body";
            return;
        }

        int issend = 0;
        string attachementpath = string.Empty;
        try
        {
            DataTable dtEmail = StockReports.GetDataTable("SELECT EmailID,PASSWORD FROM Emailid_master WHERE UniversalEmail=1");

            if (dtEmail.Rows.Count > 0)
            {

                Email_Host objEmail = new Email_Host();
                objEmail._FromEamilID = dtEmail.Rows[0]["EmailID"].ToString();
                objEmail._FromEmailPassword = dtEmail.Rows[0]["PASSWORD"].ToString();
                objEmail._ToEmailID = ToEmailId;
                objEmail._EmailSubject = Util.GetString(txtEmailSubject.Text.Trim());
                objEmail._EmailBody = txtEmailBody.Text.ToString();
                objEmail._StoreProcedureName = "";
                objEmail._TemplateID = 0;
                objEmail._RoleID = Util.GetInt(Session["RoleID"].ToString());
                objEmail._AttachementType = "";
                objEmail._AttachementPath = attachementpath;
                objEmail._PageCallPath = "";
                objEmail._EmailSendDate = "0001-01-01 00:00:00";
                objEmail._EntryBy = HttpContext.Current.Session["ID"].ToString();

                objEmail._patientID = ViewState["PID"].ToString();
                objEmail._transactionID = ViewState["TID"].ToString();

                issend = objEmail.sendEmail();
            }
            else
            {
                lblEmailError.Text = "Please Make a Universal Mail ID";
                return;
            }
            if (issend > 0)
            {
                lblEmailError.Text = "Mail Send Successfully";
                txtEmailBody.Text = "";
                txtEmailSubject.Text = "";
                txtOtherEmail.Text = "";

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblEmailError.Text = "Some Error Occured.";
        }





    }
    [WebMethod(EnableSession = true)]
    public static string bindPatientEmailList(string TID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("    SELECT el.`ToEmailID` Email,el.`EmailSubject` EmailSubject,el.`EmailBody` EmailBody,   ");
        sb.Append("    IF(el.IsSend=1 ,'Delivered','Pending')STATUS,   ");
        sb.Append("    IF(el.IsSend=1 ,IFNULL( DATE_FORMAT(el.`EmailSendDate`,'%d-%b-%Y'),''),'') DeliveryDate,   ");
        sb.Append("    CONCAT(em.Title,' ',em.NAME)SendBy,DATE_FORMAT(el.EntryDate,'%d-%b-%Y')SendDate,   ");
        sb.Append("    pmh.type   ");
        sb.Append("    FROM email_log el    ");
        sb.Append("    INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=el.`TransactionID`   ");
        sb.Append("    INNER JOIN employee_master em ON em.EmployeeID=el.`EntryBy`   ");
        sb.Append("    WHERE el.`TransactionID`='" + TID + "'   ");



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }
    public bool isValidEmail(string inputEmail)
    {
        string strRegex = @"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +
              @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" +
              @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
        Regex re = new Regex(strRegex);
        if (re.IsMatch(inputEmail))
            return (true);
        else
            return (false);
    }
}