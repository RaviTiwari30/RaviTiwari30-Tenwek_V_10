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

public partial class Design_Email_Email_accessmaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string loadSets()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,TemplateName from email_templatemaster Where ScheduleType<>3 ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string LoadEmpolyee()
    {
        DataTable dt = StockReports.GetDataTable("SELECT EmployeeID,Name FROM employee_master");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string SaveEmailMaster(string TemplateName,string EmailName, List<Employee> Employee)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            string Str = "";
            string msg = "";
            int len = Employee.Count;
            int count = 0;
            if (len > 0)
            {
                for (int i = 0; i < Employee.Count; i++)
                {
                    string hnid = "";
                    if (Employee[i].Id == "")
                    {
                        hnid = Employee[i].Employeename;
                    }
                    else
                    {
                        hnid = Employee[i].Id;
                    }
                    count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM email_typemaster WHERE TemplateName='" + TemplateName + "' and Email='" + hnid + "'"));
                    if (count == 0)
                    {
                        Str = "INSERT INTO email_typemaster (TemplateName,EmailTO,Email,CreateBy) values ('" + TemplateName + "','" + Employee[i].EmployeeType + "','" + hnid + "','" + HttpContext.Current.Session["ID"] + "') ";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
                        msg = "1";
                    }
                    else
                    {
                        msg = "1";
                    }
                }
            }
            else
            {
                count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM email_typemaster WHERE TemplateName='" + TemplateName + "' and EmailTO='1'"));
                if (count == 0)
                {
                    Str = "INSERT INTO email_typemaster (TemplateName,EmailTO,CreateBy) values ('" + TemplateName + "','" + 1 + "','" + HttpContext.Current.Session["ID"] + "') ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
                    msg = "1";
                }
                else
                    msg = "1";
            }
            tranX.Commit();
            return msg;
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
    public static string BindEmailMaster()
    {
        var sb = new StringBuilder();
        sb.Append("SELECT emp.`ID`,emptemp.ID AS TemplateID,CASE WHEN (emp.`EmailTO`='1' )  ");
        sb.Append("THEN 'Patient' WHEN (emp.`EmailTO`='2' ) THEN 'Employee' WHEN (emp.`EmailTO`='3') THEN 'Other'  END AS EmailTO ,emptemp.`TemplateName`, ");
        sb.Append("emp.EmailTO AS EmailID, IF((SELECT COUNT(*) FROM employee_master WHERE EmployeeID=emp.Email)=0,emp.email,(SELECT NAME FROM employee_master WHERE EmployeeID=emp.Email)) ");
        sb.Append(" AS Name,(SELECT EmployeeID FROM employee_master WHERE EmployeeID=emp.Email) EmployeeID FROM email_typemaster emp INNER JOIN email_templatemaster emptemp ON emp.`TemplateName`=`emptemp`.`ID` ");
        sb.Append("WHERE emp.Email IN (SELECT EmployeeID FROM employee_master) OR emp.emailto=3 OR emp.emailto=1 ");
        sb.Append("ORDER BY emp.ID ASC");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    public class Employee {
        public string Id { get; set; }
        public string Employeename { get; set; }
        public string EmployeeType { get; set; }
    }

    [WebMethod]
    public static string UpdateType(string Templatenametype, List<Employee> Email, string ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            string Str = "";
            int len = Email.Count;
            Str = "delete  from  email_typemaster where TemplateName='" + ID + "'";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
            if (len > 0)
            {
                for (int i = 0; i < Email.Count; i++)
                {
                    string hnid = "";
                    if (Email[i].Id == "")
                    {
                        hnid = Email[i].Employeename;
                    }
                    else
                    {
                        hnid = Email[i].Id;
                    }
                    Str = "insert into email_typemaster (TemplateName,EMailTo,Email,CreateBy) values ('" + Templatenametype + "','" + Email[i].EmployeeType + "','" + hnid + "','" + HttpContext.Current.Session["ID"] + "') ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Str);
                }
            }
            else
            {
                Str = "insert into email_typemaster (TemplateName,EMailTo,CreateBy) values ('" + Templatenametype + "','" + 1 + "','" + HttpContext.Current.Session["ID"] + "') ";
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
    public static string BindEmailTo(string TemplateId)
    {
        var sb = new StringBuilder();
        sb.Append("SELECT IFNULL(em.EmployeeID,'')EmployeeID,IF(emp.EmailTo=2,em.Name,emp.Email)Name,emp.EmailTo FROM `email_typemaster` emp LEFT JOIN `employee_master` em ON emp.email=em.EmployeeID WHERE emp.TemplateName='" + TemplateId + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}