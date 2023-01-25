using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_BillGenerateRights : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
        {

        if (!IsPostBack)
            {
            loadRole();
            }
        }
    private void loadRole()
        {
        DataTable dt = All_LoadData.LoadRole();
        ddlLoginType.DataSource = dt;
        ddlLoginType.DataTextField = "RoleName";
        ddlLoginType.DataValueField = "ID";
        ddlLoginType.DataBind();

        if (ddlLoginType.Items != null && ddlLoginType.Items.Count > 0)
            bindEmployee(ddlLoginType.SelectedItem.Value);
        }

    private void bindEmployee(string RoleID)
        {
        string str = "SELECT em.EmployeeID,em.Name,IF(ua.EmployeeID IS NULL,'false','true')isExist FROM employee_master em INNER JOIN f_login log ON em.EmployeeID=log.employeeID LEFT JOIN  UserAuthorization_IPDBill ua ON em.EmployeeID=ua.EmployeeID AND ua.IsActive=1 AND ua.roleID='" + ddlLoginType.SelectedValue + "'  WHERE em.IsActive=1 AND log.roleID='" + ddlLoginType.SelectedValue + "'";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            {
            chkEmployee.DataSource = dt;
            chkEmployee.DataTextField = "Name";
            chkEmployee.DataValueField = "EmployeeID";
            chkEmployee.DataBind();

            foreach (DataRow dr in dt.Rows)
                {
                foreach (ListItem li in chkEmployee.Items)
                    {
                    if (dr["EmployeeID"].ToString() == li.Value)
                        {
                        li.Selected = Util.GetBoolean(dr["isExist"]);
                        break;
                        }
                    }
                }
            }

        else
            {

            }
        }
    [WebMethod(EnableSession = true)]
    public static string SaveBillAuthorized(string[] Values, string RoleID)
        {
        string sb = "";
        if (Values.Length > 0)
            {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
                {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE UserAuthorization_IPDBill SET IsActive=0 WHERE RoleID='" + RoleID + "'");
                for (int i = 0; i < Values.Length; i++)
                    {
                    sb = "Insert into UserAuthorization_IPDBill (EmployeeID,RoleID,CreatedBy)";
                    sb += " values('" + Values[i].ToString() + "'," + RoleID + ",'" + HttpContext.Current.Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb);
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
    [WebMethod]
    public static string loadEmployee(string RoleID)
        {
        string str = "SELECT em.EmployeeID,em.Name,IF(ua.EmployeeID IS NULL,'false','true')isExist FROM employee_master em INNER JOIN f_login log ON em.EmployeeID=log.employeeID LEFT JOIN  UserAuthorization_IPDBill ua ON em.EmployeeID=ua.EmployeeID AND ua.IsActive=1  WHERE em.IsActive=1 AND log.roleID='" + RoleID + "'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

        }
    protected void ddlLoginType_SelectedIndexChanged(object sender, EventArgs e)
        {
        bindEmployee(ddlLoginType.SelectedValue);
        }
    }