using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_EDP_Notification_AccessMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }

    [WebMethod]
    public static string bindNotification()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID NotificationID,NotificationType,IFNULL(Description,'')Description,IsDependent FROM notification_master where isActive=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession=true)]
    public static string bindRole(string SearchType)
    {
        DataTable dt = StockReports.GetDataTable("SELECT rm.ID,rm.RoleName FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.ID WHERE rm.Active=1 AND cr.isActive=1 AND cr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND RoleName LIKE '" + SearchType + "%' ORDER BY RoleName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession=true)]
    public static string bindEmployee(string SearchType)
    {
        DataTable dt = StockReports.GetDataTable("SELECT em.Employee_ID,CONCAT(em.Title,' ',em.Name)EmpName FROM employee_master em INNER JOIN f_login fl ON fl.EmployeeID=em.Employee_ID WHERE fl.Active=1 And fl.CentreID="+ HttpContext.Current.Session["CentreID"].ToString() +" AND em.IsActive=1 AND em.Employee_ID<>'EMP001' AND Name LIKE '" + SearchType + "%' ORDER BY Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindSearchType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT SearchType FROM master_searchingType  WHERE IsActive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession=true)]
    public static string bindLoginType(string employee_ID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT rm.RoleName ,rm.ID FROM f_rolemaster rm INNER JOIN f_login lo ON rm.id=lo.RoleID WHERE rm.Active=1 AND lo.Active=1 AND lo.centreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND lo.EmployeeID='" + employee_ID + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession=true)]
    public static string bindEmpLoginType(string SearchType, int isRole, int isEmp, int NotificationID)
    {
        StringBuilder sb = new StringBuilder();
        if (isEmp == 1)
            sb.Append(" SELECT CAST(GROUP_CONCAT(rm.ID SEPARATOR '$') AS CHAR) RoleID,CAST(GROUP_CONCAT(rm.RoleName SEPARATOR '$')AS CHAR)RoleName,em.EmployeeID as Employee_ID,em.Name EmployeeName  ");
        else
            sb.Append(" SELECT CAST(GROUP_CONCAT(em.EmployeeID SEPARATOR '$') AS CHAR) Employee_ID,CAST(GROUP_CONCAT(em.Name  SEPARATOR '$')AS CHAR)EmployeeName,rm.ID RoleID,rm.RoleName RoleName  ");
        sb.Append("  ,IFNULL(CAST(GROUP_CONCAT(na.RoleID SEPARATOR '$' )AS CHAR),'0')RoleCheck,IFNULL(CAST(GROUP_CONCAT(na.EmployeeID SEPARATOR '$') AS CHAR),0)EmpCheck ");
        sb.Append("   FROM f_rolemaster rm INNER JOIN f_login lo ON rm.id=lo.RoleID INNER JOIN employee_master em ON em.EmployeeID=lo.EmployeeID ");
        sb.Append("   LEFT JOIN notification_access na ON na.RoleID=rm.ID AND na.EmployeeID=em.EmployeeID  AND na.IsActive=1 AND na.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' AND na.NotificationID=" + NotificationID + " ");
        sb.Append("   WHERE em.IsActive=1 AND rm.Active=1 AND lo.Active=1  AND lo.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' AND ");
        if (isEmp == 1)
            sb.Append(" em.Name LIKE '" + SearchType + "%'  GROUP BY  em.EmployeeID ORDER BY em.Name ");
        else
            sb.Append(" rm.RoleName LIKE '" + SearchType + "%'  GROUP BY  rm.ID ORDER BY rm.RoleName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    public class notification
    {
        public string Employee_ID { get; set; }
        public string RoleID { get; set; }
        public int NotificationID { get; set; }
        public string NotificationName { get; set; }
        public int IsRole { get; set; }
        public int IsEmployee { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string notificationAccess(List<notification> notification, int isRole, int isEmp, int NotificationID)
    {
        int len = notification.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                int CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                for (int i = 0; i < notification.Count; i++)
                {
                    if (isRole == 0)
                    {
                        int roleLen = Util.GetInt(notification[i].RoleID.Split('#').Length);
                        string[] Item = new string[roleLen];
                        Item = notification[i].RoleID.Split('#');

                        for (int k = 0; k < roleLen; k++)
                        {
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Delete From notification_access Where  NotificationID='" + notification[i].NotificationID + "' AND RoleID='" + Item[k].ToString() + "' AND EmployeeID='" + notification[i].Employee_ID + "' AND CentreID='"+ CentreID +"' ");
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO notification_access(NotificationID,NotificationName,IsRole,IsEmployee,RoleID,EmployeeID,CreatedBy,IPAddress,CentreID) " +
                                " VALUES('" + notification[i].NotificationID + "','" + notification[i].NotificationName + "','" + isRole + "','" + isEmp + "','" + Item[k].ToString() + "','" + notification[i].Employee_ID + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + CentreID + ") ");
                        }
                    }
                    else
                    {
                        int empLen = Util.GetInt(notification[i].Employee_ID.Split('#').Length);
                        string[] Item = new string[empLen];
                        Item = notification[i].Employee_ID.Split('#');

                        for (int k = 0; k < empLen; k++)
                        {
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Delete From notification_access Where  NotificationID='" + notification[i].NotificationID + "' AND RoleID='" + notification[i].RoleID + "' AND EmployeeID='" + Item[k].ToString() + "' AND CentreID=" + CentreID + " ");
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO notification_access(NotificationID,NotificationName,IsRole,IsEmployee,RoleID,EmployeeID,CreatedBy,IPAddress,CentreID) " +
                                " VALUES('" + notification[i].NotificationID + "','" + notification[i].NotificationName + "','" + isRole + "','" + isEmp + "','" + notification[i].RoleID + "','" + Item[k].ToString() + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + CentreID + ") ");
                        }
                    }
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
        else
        {
            return "0";
        }
    }
}