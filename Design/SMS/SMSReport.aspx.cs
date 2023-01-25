using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.Services;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;

public partial class Design_SMS_SMSreport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sms_id,mobile_no,sms_text sms ,if(smsType=1,'Patient','Doctor')smsType,PatientID,DoctorID, ");
        sb.Append(" DATE_FORMAT(EntryDate,'%d-%b-%y %h:%i %p') EntryDate,sms_response FROM  sms_log ");
        sb.Append(" where  Date(EntryDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and date(EntryDate) <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' order by sms_id  desc ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            if (ddlreporttype.SelectedValue == "PDF")
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                //  ds.WriteXmlSchema("E:\\smsreport.xml");
                Session["ds"] = ds;

                Session["ReportName"] = "SMSReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                string CacheName = Session["ID"].ToString();
                Common.CreateCachedt(CacheName, dt);
                string ReportName = "SMS Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
            }
        }
        else
            lblMsg.Text = "No Record found";
    }
    [WebMethod]
    public static string GetSMSResponse(string smsid)
    {
        try
        {
            string IniSms_api = "https://138.68.136.189:9090/sms/check/{sms_id}/80ae4db038374c7f63e292e9cbfc1ff2/a57256e09c3850cce07785f5b439b560";
            string sms_resposeapi = IniSms_api.Replace("{sms_id}", smsid);
	    ServicePointManager.Expect100Continue = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12 | SecurityProtocolType.Ssl3;
            WebClient Client = new WebClient();
            String RequestURL, RequestData;
            RequestURL = sms_resposeapi;
            RequestData = "";
            byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
            byte[] Response = Client.UploadData(RequestURL, PostData);
            string Result = Encoding.ASCII.GetString(Response);
            SMSDetails objList = Newtonsoft.Json.JsonConvert.DeserializeObject<SMSDetails>(Result);
            Result = objList.status;
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Result });
        }
        catch (Exception ex) {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message });
        }
    }
    public class SMSDetails
    {
        public string status { get; set; }
    }
}