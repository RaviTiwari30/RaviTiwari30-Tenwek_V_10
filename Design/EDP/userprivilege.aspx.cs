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

public partial class Design_EDP_userprivilege : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string SearchEmp(string EmpName, int Department)
    {
        string Query = " SELECT DISTINCT emp.EmployeeID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,emp.TabPosition FROM employee_master emp Left Outer JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID where emp.IsActive=1  ";
        if (Department > 0 && EmpName.Length <= 0)
            Query += "  and RoleID=" + Department + " ";

        if (EmpName.Length > 0 && Department <= 0)
            Query += "  and  Name like '%" + EmpName + "%' ";

        if (EmpName.Length > 0 && Department > 0)
            Query += " and  Name like '" + EmpName + "%' and RoleID=" + Department + "";
		
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod]
    public static string SearchEmpforCopyToBind()
    {
        string Query = " SELECT emp.EmployeeID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,emp.TabPosition  FROM employee_master emp WHERE emp.EmployeeID NOT IN (SELECT em.EmployeeID FROM employee_master em INNER JOIN f_login fl ON em.EmployeeID=fl.EmployeeID )";
        
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod]
    public static string SearchEmpforCopyFromBind(string EmpName, int Department)
    {
        string Query = "SELECT DISTINCT emp.EmployeeID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,emp.TabPosition FROM employee_master emp INNER JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID ";
        if (Department > 0 && EmpName.Length <= 0)
            Query += " where RoleID=" + Department + " ";

        if (EmpName.Length > 0 && Department <= 0)
            Query += " where Name like '%" + EmpName + "%' ";

        if (EmpName.Length > 0 && Department > 0)
            Query += " where Name like '" + EmpName + "%' and RoleID=" + Department + "";

        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod]
    public static string SearchEmpToBindForCopy(string EmpName, int Department)
    {
        string Query = "SELECT DISTINCT emp.EmployeeID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,emp.TabPosition FROM employee_master emp INNER JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID ";
        if (Department > 0 && EmpName.Length <= 0)
            Query += " where RoleID=" + Department + " ";

        if (EmpName.Length > 0 && Department <= 0)
            Query += " where Name like '%" + EmpName + "%' ";

        if (EmpName.Length > 0 && Department > 0)
            Query += " where Name like '" + EmpName + "%' and RoleID=" + Department + "";

        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }



    [WebMethod]
    public static string SearchEmpByEmpID(string EmpID)
    {
        string Query = " SELECT EmployeeID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,emp.TabPosition FROM employee_master emp where emp.EmployeeID='" + EmpID + "' ";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod (EnableSession=true)]
    public static string GetRoles() {
        DataTable dt = All_LoadData.LoadRole();
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetSetRole(string EmployeeId)
    {
        string str = "SELECT RM.id,UPPER(RM.roleName) roleName,IF(FL.`RoleID` IS NULL,'FALSE','TRUE')RoleSet  FROM f_rolemaster RM "+
            " LEFT JOIN f_login FL ON FL.`RoleID`=RM.`ID` AND FL.EmployeeID='" + EmployeeId + "' AND FL.`CentreID`="+ Util.GetInt(HttpContext.Current.Session["CentreId"])+" " +
            "  WHERE RM.active=1 GROUP BY RoleName ORDER BY RoleName; ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Getprescription()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT up.ID,up.AccordianName,up.ViewUrl FROM user_privilege_master up ORDER BY up.Order");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string loadPrescriptionView()
     {
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT up.ID,up.AccordianName,up.ViewUrl FROM user_privilege_master up  ");
            sb.Append(" WHERE up.IsActive=1 ORDER BY up.Order ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public static string EmployeeData()
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT EmployeeID,Name FROM employee_master   ");
            sb.Append(" WHERE IsActive=1");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateRole(string EmployeeID, string RoleID, Boolean IsChecked)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (IsChecked)
            {
                sb.Append("insert into f_login(RoleID,EmployeeID,UserName,Password,CentreID)");
                sb.Append("values(" + RoleID + ",'" + EmployeeID + "','mgr','itdose','" + HttpContext.Current.Session["CentreID"].ToString() + "')");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
                result = "1";
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "delete from f_login where RoleID='" + RoleID + "' AND EmployeeID='" + EmployeeID + "'");
                result = "2";
            }
            MySqltrans.Commit();
            return result;
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}