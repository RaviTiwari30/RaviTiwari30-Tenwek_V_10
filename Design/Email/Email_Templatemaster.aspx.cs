using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Email_Email_Templatemaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txttime.Text = System.DateTime.Now.ToString("hh:mm tt");
        }
        txtdate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string SaveEmailTemplate(string TemplateName, string Status, string ScheduleType, string ScheduleTime, string ScheduleDate, int isPanelWise, string emailrepeattype, string repeatparameter)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            string Str = "";
            if (ScheduleType == "1")
            {
                string event_ = "EVERY " + repeatparameter + " " + emailrepeattype + " START ";
                Str = "INSERT INTO email_templatemaster (TemplateName,STATUS,ScheduleType,ScheduleTime,ScheduleDate,Createby,IsPanelWise,Email_repeat) values ('" + TemplateName + "','" + Status + "','" + ScheduleType + "','" + Util.GetDateTime(ScheduleTime).ToString("HH:mm:ss") + "','0001-01-01','" + HttpContext.Current.Session["ID"] + "'," + isPanelWise + ",'" + event_ + "') ";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
            }
            else if (ScheduleType == "2")
            {
                string event_ = "EVERY " + repeatparameter + " " + emailrepeattype + " START";
                Str = "INSERT INTO email_templatemaster (TemplateName,STATUS,ScheduleType,ScheduleTime,ScheduleDate,Createby,IsPanelWise,Email_repeat) values ('" + TemplateName + "','" + Status + "','" + ScheduleType + "','" + Util.GetDateTime(ScheduleTime).ToString("HH:mm:ss") + "','" + Util.GetDateTime(ScheduleDate).ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"] + "'," + isPanelWise + ",'" + event_ + "') ";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
            }
            else
            {
                Str = "INSERT INTO email_templatemaster (TemplateName,STATUS,ScheduleType,ScheduleTime,ScheduleDate,Createby,IsPanelWise) values ('" + TemplateName + "','" + Status + "','" + ScheduleType + "','00:00:00','0001-01-01','" + HttpContext.Current.Session["ID"] + "'," + isPanelWise + ") ";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
            }
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindTemplateMaster()
    {
        var sb = new StringBuilder();
        sb.Append("select ID,TemplateName,IF(STATUS=0, 'Deactive', 'Active')STATUS, ");
        sb.Append(" CASE WHEN (ScheduleType='1' ) THEN 'Daily' WHEN (ScheduleType='2' ) THEN 'Monthly' WHEN (ScheduleType='3') THEN 'RunTime'  END AS ScheduleType ");
        sb.Append(",DATE_FORMAT(ScheduleTime,'%l:%i %p')ScheduleTime,DATE_FORMAT(ScheduleDate,'%d-%b-%Y')ScheduleDate,IsPanelWise,Email_repeat FROM `email_templatemaster` ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string UpdateType(string TemplateName, string Status, string ScheduleType, string ScheduleTime, string ScheduleDate, string ID, string IsPanelWise,string emailrepeattype, int repeatparameter)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string date = "0001-01-01";
            string time = "00:00:00";
            if (ScheduleType == "1")
            {
               time = Util.GetDateTime(ScheduleTime).ToString("HH:mm:ss");
            }
            else if(ScheduleType == "2")
            {
                 time = Util.GetDateTime(ScheduleTime).ToString("HH:mm:ss");
                 date = Util.GetDateTime(ScheduleDate).ToString("yyyy-MM-dd");
            }
            string event_ = "EVERY " + repeatparameter + " " + emailrepeattype + " START ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update email_templatemaster Set Email_repeat='" + event_ + "',TemplateName='" + TemplateName + "',Status='" + Status + "',ScheduleType='" + ScheduleType + "',ScheduleTime='" + time + "',ScheduleDate='" + date + "',IsPanelWise=" + IsPanelWise + " where ID ='" + ID + "' ");
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}