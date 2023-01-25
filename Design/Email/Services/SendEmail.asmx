<%@ WebService Language="C#" Class="SendEmail" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SendEmail : System.Web.Services.WebService
{
    [WebMethod]
    public string SendEmails()
    {
        //return "";
        string Status = string.Empty;
        DataTable dtsend = StockReports.GetDataTable("SELECT AttachementPath,PageCallPath,ReportPath,ID,FromEamilID,FromEmailPassword,ToEmailID,EmailSubject, " +
                   "EmailBody,AttachementType,StoreProcedureName,smtp_host,email_port,IncludeCentreLogo,ErrorNotifyEmail FROM email_log WHERE IsSend=0 AND FromEamilID<>'' AND FromEmailPassword<>'' AND ToEmailID<>'' LIMIT 10");
        if (dtsend.Rows.Count > 0)
        {
            //string MailServer = ;
            //int EMAILPORT = 587;// Util.GetInt(Util.GetMailPort());
            string CCMailID = string.Empty;
            
            Parallel.ForEach(dtsend.AsEnumerable(), row =>
            {
                Status = Sendmailmessage(row["FromEamilID"].ToString(), row["FromEmailPassword"].ToString(), row["smtp_host"].ToString(), Util.GetInt(row["email_port"]), row["ToEmailID"].ToString(), CCMailID,
                    row["EmailSubject"].ToString(), row["EmailBody"].ToString(), "", row["StoreProcedureName"].ToString(), row["AttachementType"].ToString(), row["ReportPath"].ToString(),
                    row["PageCallPath"].ToString(), row["AttachementPath"].ToString(), Util.GetInt(row["ID"]), Util.GetInt(row["IncludeCentreLogo"]), row["ErrorNotifyEmail"].ToString());
            });
        }
        return Status;
    }
    public string Sendmailmessage(string FROMMAIL, string FROMPWD, string MailServer, int EMAILPORT, string ToMailID, string CCMailID, string EmailSubject,
         string EmailBody, string AttachmentFilename, string StoreProcedureName, string AttachementType, string ReportPath, string PageCallPath, string AttachementPath, int ID, int IncludeCentreLogo, string ErrorNotifyEmail)
    {
        try
        {
            MailMessage message;
            message = new MailMessage();
            SmtpClient MailClient = new SmtpClient(MailServer);

            if (StoreProcedureName != "")
            {
                if (!string.IsNullOrEmpty(AttachementType) && !string.IsNullOrEmpty(ReportPath))
                {
                    if (!File.Exists(Server.MapPath(ReportPath)))
                    {
                        return "File Not Exist.";
                    }
                    AttachmentFilename = AttachementGenerate.GeneratePDF(StoreProcedureName, Server.MapPath(ReportPath), AttachementType, IncludeCentreLogo);
                }

                else if (AttachementType== "P" && string.IsNullOrEmpty(ReportPath))
                {
                    PageCallPath = "http://localhost/his/Design/Email/HTMLToPDF.aspx";
                    AttachmentFilename = CallWebClient(PageCallPath + "?StoreProcedureName=" + StoreProcedureName + "&EmailSubject=" + EmailSubject);
                }
                else if (AttachementType == "E" && string.IsNullOrEmpty(ReportPath))
                {
                    AttachmentFilename = ConvertDataTableToExcel.GenerateExcel(StoreProcedureName, AttachementType);
                }
                else if (AttachementType == "H" && string.IsNullOrEmpty(ReportPath))
                {
                    EmailBody += DatatableToHTML.HTMLBody(StoreProcedureName);
                }
            }
            else if (!string.IsNullOrEmpty(AttachementPath))
            {
                if (!string.IsNullOrEmpty(PageCallPath))
                {
                    ReportCall(PageCallPath);
                }
                AttachmentFilename = AttachementPath;
            }
            else if (!string.IsNullOrEmpty(PageCallPath))
            {
                AttachmentFilename = CallWebClient(PageCallPath);
            }
           // EmailBody += "<br/><br/><br/><br/><html><body><h1>Picture</h1><br><img src=\"cid:filename\"></body></html>"; //(Server.MapPath("../../../Images/wellkinheader.png"));
            message.From = new MailAddress(FROMMAIL);

            foreach (var address in ToMailID.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
            {
                message.To.Add(address);
            }
            
            foreach (var address in CCMailID.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
            {
                message.CC.Add(address);
            }
            
            message.IsBodyHtml = true;
            message.Subject = EmailSubject;
            message.Body = EmailBody;

            if (AttachmentFilename != string.Empty)
            {
                var attachmentPaths = AttachmentFilename.Split(',');
                for (int k = 0; k < attachmentPaths.Length; k++)
                {
                    message.Attachments.Add(new Attachment(attachmentPaths[k]));
                }
            }
            message.Priority = MailPriority.High;
            if (!string.IsNullOrEmpty(ErrorNotifyEmail))
            {
                message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure | DeliveryNotificationOptions.OnSuccess;
                message.Headers.Add("Disposition-Notification-To", ErrorNotifyEmail);
            }
            MailClient.EnableSsl = true;
            System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate(object s,
            System.Security.Cryptography.X509Certificates.X509Certificate certificate,
            System.Security.Cryptography.X509Certificates.X509Chain chain,
            System.Net.Security.SslPolicyErrors sslPolicyErrors)
            {
                return true;
            };
            MailClient.UseDefaultCredentials = false;
            System.Net.NetworkCredential Credential = new System.Net.NetworkCredential(FROMMAIL, FROMPWD);
            MailClient.Credentials = Credential;
            MailClient.Port = EMAILPORT;

            try
            {
                MailClient.Send(message);
                message.Attachments.Clear();
                message.Attachments.Dispose();
                message.Dispose();
                MailClient.Dispose();
                StockReports.ExecuteDML("UPDATE Email_log Set IsSend=1,EmailSendDate=Now(),AttachmentFilename='"+ Path.GetFileName(AttachmentFilename) +"' WHERE ID='" + ID + "'");
                return "Success";
            }
            catch 
            {
                message.Attachments.Clear();
                message.Attachments.Dispose();
                message.Dispose();
                MailClient.Dispose();
                StockReports.ExecuteDML("UPDATE Email_log Set IsSend=2,EmailSendDate=Now() WHERE ID='" + ID + "'");
                return "Fail";
            }
        }
        catch (Exception ex)
        {
            ClassLog lc = new ClassLog();
            lc.errLog(ex);
            StockReports.ExecuteDML("UPDATE Email_log Set IsSend=2,EmailSendDate=Now() WHERE ID='" + ID + "'");
            return "Fail";
        }
    }
    public void ReportCall(string Path)
    {
        using (WebClient webclient = new WebClient())
        {
            byte[] pdfBuffer = webclient.DownloadData(Path);
        }
    }
    public static string CallWebClient(string PagePath)
    {
        string FileName = string.Empty;
        ClassLog lc = new ClassLog();
        if (All_LoadData.chkDocumentDrive() == 0)
        {
            lc.GeneralLog("Please Create " + Resources.Resource.DocumentDriveName + " Drive");
            return "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
        }
        var directoryPath = All_LoadData.createDocumentFolder("EmailFiles", "");
        if (directoryPath == null)
        {
            lc.GeneralLog("Please Create Document Folder");
            return "Please Create Document Folder";
        }
        FileName = Path.Combine(directoryPath.ToString(), "" + Guid.NewGuid() + ".pdf");
        if (File.Exists(FileName))
        {
            File.Delete(FileName);
        }
        using (WebClient webclient = new WebClient())
        {
            byte[] pdfBuffer = webclient.DownloadData(PagePath);
            File.WriteAllBytes(FileName, pdfBuffer);
        }
        return FileName;
    }

    public static string Imagetobase64(string fileNameandPath)
    { 
        byte[] byteArray = File.ReadAllBytes(fileNameandPath);
        string base64 = Convert.ToBase64String(byteArray);
        return string.Format("data:image/png;base64,{0}", base64);
    }
}