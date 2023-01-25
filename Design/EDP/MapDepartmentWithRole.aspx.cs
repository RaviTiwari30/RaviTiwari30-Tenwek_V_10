using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_MapDepartmentWithRole : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string GetRole()
    {
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





    [WebMethod(EnableSession = true, Description = "Map Role To Dept")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string MapRoleToDept(MapDepartment Data)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (CheckIsAlreadyMap(Data.DeptId))
            {
                string RoleName = Util.GetString(StockReports.ExecuteScalar("SELECT pm.RoleName  FROM tenwek_map_department_to_role pm WHERE pm.IsActive=1 AND pm.Centre=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND pm.DocDepartment=" + Util.GetInt(Data.DeptId) + " "));

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = " Department " + Data.DeptName + " is Already Map With Role " + RoleName + " " });

            }

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert  into tenwek_map_department_to_role ");
            sb.Append(" (DocDepartment,DocDepartmentName,RoleId,RoleName,EntryBy,Centre) ");
            sb.Append("values(" + Util.GetInt(Data.DeptId) + ",'" + Util.GetString(Data.DeptName) + "'," + Util.GetInt(Data.RoleID) + ",  ");
            sb.Append(" '" + Util.GetString(Data.RoleName) + "',");
            sb.Append(" '" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "   )");

            if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
            {
                Tranx.Rollback();
                con.Close();
                con.Dispose();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error In Mapping Master. Contact To Administrator." });

            }

            Tranx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Department Map Successfully" });

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error In Mapping Master. Contact To Administrator." });

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }



    }
 

    public static bool CheckIsAlreadyMap(int DeptId)
    {


        int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT IF(IFNULL(COUNT(pm.id),0)=0,0,1)IsValid FROM tenwek_Map_Department_to_Role pm WHERE pm.IsActive=1 AND pm.Centre=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND pm.DocDepartment=" + Util.GetInt(DeptId) + " "));

        if (Count == 0)
        {
            return false;
        }
        else
        {
            return true;
        }


    }

    [WebMethod(EnableSession = true)]
    public static string GetDataToFill(string Id, int Type)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            sbnew.Append(" SELECT pm.* FROM tenwek_Map_Department_to_Role pm ");
            sbnew.Append(" WHERE pm.IsActive=1 ");
            if (!string.IsNullOrEmpty(Id) && Id != "0")
            {
                if (Type == 0)
                {
                    sbnew.Append(" and pm.DocDepartment=" + Util.GetInt(Id) + " ");
                }
                else
                {
                    sbnew.Append(" and pm.RoleId=" + Util.GetInt(Id) + " ");
                }
            }

            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }


    [WebMethod(EnableSession = true, Description = "Un Mapped")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Unmapped(int Id)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            string str = "update tenwek_Map_Department_to_Role  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
            if (i > 0)
            {
                Tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Un Mapped Successfully" });

            }
            else
            {
                Tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });

        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }






    }

    public class MapDepartment
    {
        public int Id { get; set; }
        public int DeptId { get; set; }
        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public string DeptName { get; set; }
        public int IsActive { get; set; }

    }


}