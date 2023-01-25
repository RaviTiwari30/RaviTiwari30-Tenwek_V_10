using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;



public class Sms_Host
{
    MySqlConnection con;
    bool IsLocalConn;
    public Sms_Host()
    {
        con = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Sms_Host(MySqlConnection con)
    {
        this.con = con;
        this.IsLocalConn = false;
    }
    public string _SmsTo { get; set; }
    public string _Msg { get; set; }
    public string _PatientID { get; set; }
    public string _DoctorID { get; set; }
    public string _EmployeeID { get; set; }
    public int _TemplateID { get; set; }
    public string _UserID { get; set; }
    public int _smsType { get; set; }
    public int _CentreID { get; set; }
    public string _TransactionID { get; set; }
    public int sendSms()
    {
        string Sms_api = "";
        string Result = "";
        int isSend = 0;
        try
        {
            if (IsLocalConn)
            {
                this.con.Open();
            }
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO `sms_log`(`SMS_Text`, `sms_api`, `sms_response`,`Mobile_No`,`PatientID`,`TemplateID`,`UserID`,`smsType`,`DoctorID`,`isSend`,`EmployeeID`,CentreID,TransactionID) VALUES (@SMS_Text,@sms_api,@sms_response,@Mobile_No,@PatientID,@TemplateID,@UserID,@smsType,@DoctorID,@IsSend,@EmployeeID,@CentreID,@TransactionID);");

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con);
            cmd.Parameters.Add(new MySqlParameter("@SMS_Text", _Msg));
            cmd.Parameters.Add(new MySqlParameter("@sms_api", Sms_api));
            cmd.Parameters.Add(new MySqlParameter("@sms_response", Result.Trim()));
            cmd.Parameters.Add(new MySqlParameter("@Mobile_No", _SmsTo));
            cmd.Parameters.Add(new MySqlParameter("@PatientID", _PatientID));
            cmd.Parameters.Add(new MySqlParameter("@TemplateID", _TemplateID));
            cmd.Parameters.Add(new MySqlParameter("@UserID", _UserID));
            cmd.Parameters.Add(new MySqlParameter("@smsType", _smsType));
            cmd.Parameters.Add(new MySqlParameter("@DoctorID", _DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@IsSend", isSend));
            cmd.Parameters.Add(new MySqlParameter("@EmployeeID", _EmployeeID));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", _CentreID));
            cmd.Parameters.Add(new MySqlParameter("@TransactionID", _TransactionID));
            cmd.ExecuteNonQuery();
            if (IsLocalConn)
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }
            }
            return 1;
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            con.Close();
            con.Dispose();
            return 0;
        }


    }
    public string LoadTinySMS(string LedgertransactionNo, string PatientID, string MobileNo, string SmsText)
    {
        ClassLog dl = new ClassLog();
        string result;
        try
        {
            //string TinyConverterURL = "http://9url.in/?_url=";
            StringBuilder sbSQL = new StringBuilder();
            //sbSQL.Append("INSERT INTO `sms`(LabNo,`MOBILE_NO`,`SMS_TEXT`,`IsSend`,`UserID`,`Type`) VALUES");
            sbSQL.Append("INSERT INTO `sms_log`(`SMS_Text`, `sms_api`, `sms_response`,`Mobile_No`,`PatientID`,`TemplateID`,`UserID`,`smsType`,`DoctorID`,`isSend`,`EmployeeID`,BookingNo,CentreID) VALUES ");
            //string ReportURL = "https://41.212.212.214:4210/his/Design/LAB/printLabReport_pdf.aspx?LedgertransactionNo=LabNo&isOnlinePrint=OnlinePrint";
            string SMS_TEXT = string.Empty;
            //ReportURL = ReportURL.Replace("LabNo", Common.Encrypt(LedgertransactionNo)).Replace("OnlinePrint", Common.Encrypt("1"));
            //WebClient Client = new WebClient();
            //string RequestData = "";
            //byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
            //byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
            //string turl = Encoding.ASCII.GetString(Response);
            SMS_TEXT = "Dear Customer, Thank you for using services of C-Care(Darne/Wellkin/C-Lab). Your report is ready for collection. You can also view the result by clicking on the following link (For Password Enter your Date of Birth format is ddMMyyyy):";
            SMS_TEXT += SmsText;
            sbSQL.Append("('" + SMS_TEXT + "','','','" + MobileNo + "','" + PatientID + "','0','" + HttpContext.Current.Session["ID"].ToString() + "','100','',0,'" + HttpContext.Current.Session["ID"].ToString() + "','" + LedgertransactionNo + "',"+ HttpContext.Current.Session["CentreID"].ToString() +") ");
            StockReports.ExecuteDML(sbSQL.ToString());

            result = "1";
        }
        catch (Exception ex)
        {
            dl.errLog(ex);
            result = "0";
        }
        return result;
    }

}