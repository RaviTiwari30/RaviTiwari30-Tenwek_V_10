using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;

public class Email_Host
{
     MySqlConnection con; 
    bool IsLocalConn;

    public Email_Host()
    {
        con = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Email_Host(MySqlConnection con)
    {
        this.con = con;
        this.IsLocalConn = false;
    }
    public string _FromEamilID { get; set; }
    public string _FromEmailPassword { get; set; }
    public string _ToEmailID { get; set; }
    public string _EmailSubject { get; set; }
    public string _EmailBody { get; set; }
    public string _StoreProcedureName { get; set; }
    public int _TemplateID { get; set; }
    public int _RoleID { get; set; }
    public string _AttachementType { get; set; }
    public string _EmailSendDate { get; set; }
    public int _IsSend { get; set; }
    public string _EntryBy { get; set; }
    public string _PatientID { get; set; }
    public string _TransactionID { get; set; }
    public string _AttachementPath { get; set; }
    public string _PageCallPath { get; set; }
    public string _patientID { get; set; }
    public string _transactionID { get; set; }
    public int _CentreID { get; set; }
    public string _smtp_host { get; set; }
    public int _emailport { get; set; }
    public string _ErrorNotifyEmail { get; set; }
    public int sendEmail()
    {
        try
        {

            if (IsLocalConn)
                this.con.Open();

            StringBuilder objSQL = new StringBuilder();
            //objSQL.Append("INSERT INTO Email_log (FromEamilID,FromEmailPassword,ToEmailID,EmailSubject,EmailBody,StoreProcedureName,TemplateID,RoleID,AttachementType,EmailSendDate,EntryBy,AttachementPath,PageCallPath,PatientID,TransactionID,CentreID,smtp_host,email_port,ErrorNotifyEmail) ");
            //objSQL.Append("VALUES (@FromEamilID,@FromEmailPassword,@ToEmailID,@EmailSubject,@EmailBody,@StoreProcedureName,@TemplateID,@RoleID,@AttachementType,@EmailSendDate,@EntryBy,@AttachementPath,@PageCallPath,@patientID,@transactionID,@CentreID,@smtp_host,@email_port,@ErrorNotifyEmail); SELECT @@identity; ");

            objSQL.Append("INSERT INTO Email_log (FromEamilID,FromEmailPassword,ToEmailID,EmailSubject,EmailBody,StoreProcedureName,TemplateID,RoleID,AttachementType,EmailSendDate,EntryBy,AttachementPath,PageCallPath,PatientID,TransactionID) ");
            objSQL.Append("VALUES (@FromEamilID,@FromEmailPassword,@ToEmailID,@EmailSubject,@EmailBody,@StoreProcedureName,@TemplateID,@RoleID,@AttachementType,@EmailSendDate,@EntryBy,@AttachementPath,@PageCallPath,@patientID,@transactionID); SELECT @@identity; ");

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con);
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.Add(new MySqlParameter("@FromEamilID", _FromEamilID));
            cmd.Parameters.Add(new MySqlParameter("@FromEmailPassword", _FromEmailPassword));
            cmd.Parameters.Add(new MySqlParameter("@ToEmailID", _ToEmailID));
            cmd.Parameters.Add(new MySqlParameter("@EmailSubject", _EmailSubject));
            cmd.Parameters.Add(new MySqlParameter("@EmailBody", _EmailBody));
            cmd.Parameters.Add(new MySqlParameter("@StoreProcedureName", _StoreProcedureName));
            cmd.Parameters.Add(new MySqlParameter("@TemplateID", _TemplateID));
            cmd.Parameters.Add(new MySqlParameter("@RoleID", _RoleID));
            cmd.Parameters.Add(new MySqlParameter("@AttachementType", _AttachementType));
            cmd.Parameters.Add(new MySqlParameter("@EmailSendDate", _EmailSendDate));
            cmd.Parameters.Add(new MySqlParameter("@EntryBy", _EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@AttachementPath", _AttachementPath));
            cmd.Parameters.Add(new MySqlParameter("@PageCallPath", _PageCallPath));
            cmd.Parameters.Add(new MySqlParameter("@patientID", _patientID));
            cmd.Parameters.Add(new MySqlParameter("@transactionID", _transactionID));
          
            //cmd.Parameters.Add(new MySqlParameter("@CentreID", _CentreID));
            //cmd.Parameters.Add(new MySqlParameter("@smtp_host", _smtp_host));
            //cmd.Parameters.Add(new MySqlParameter("@email_port", _emailport));
            //cmd.Parameters.Add(new MySqlParameter("@ErrorNotifyEmail", _ErrorNotifyEmail));



            cmd.ExecuteNonQuery();
            return 1;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
        finally
        {
            if (IsLocalConn)
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }
            }
        }
    }
    public string LoadTinyEmail(string LedgertransactionNo)
    {
        ClassLog dl = new ClassLog();
        string result;
        try
        {
            string TinyConverterURL = "http://9url.in/?_url=";
            //string ReportURL = "https://41.212.212.214:4210/his/Design/LAB/printLabReport_pdf.aspx?LedgertransactionNo=LabNo&isOnlinePrint=OnlinePrint";
            string ReportURL = "https://owa.c-care.mu:4210/his/Design/LAB/printLabReport_pdf.aspx?LedgertransactionNo=LabNo&isOnlinePrint=OnlinePrint";
            ReportURL = ReportURL.Replace("LabNo", Common.Encrypt(LedgertransactionNo)).Replace("OnlinePrint", Common.Encrypt("1")); ;
            WebClient Client = new WebClient();
            string RequestData = "";
            byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
            byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
            string turl = Encoding.ASCII.GetString(Response);
            result = turl;
        }
        catch (Exception ex)
        {
            dl.errLog(ex);
            result = "0";
        }
        return result;
    }
}
