
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Transactions;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HelpDesk_Section_Master : System.Web.UI.Page
{
    string CurentID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Resources.Resource.Ticketing == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
               // All_LoadData.bindRole(ddlDepartment);
                //ddlDepartment.Focus();
                // All_LoadData.bindEmployee(ddlEmployee, "Select");
               }

            Page.GetPostBackEventReference(btnBind);
        }

        BindAdditionalInfo();
        CurentID = Session["ID"].ToString();
    }

    
    public void BindAdditionalInfo()
    {
        string query = "SELECT * FROM ass_additional_info WHERE IsActive=1";

        DataTable dt = StockReports.GetDataTable(query);

        if (dt.Rows.Count > 0)
        {
            ddlAditionalInfo.DataSource = dt;
            ddlAditionalInfo.DataTextField = "NAME";
            ddlAditionalInfo.DataValueField = "InfoID";
            ddlAditionalInfo.DataBind();

             //ddlAditionalInfo.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlAditionalInfo.Items.Clear();
            ddlAditionalInfo.DataSource = null;
            ddlAditionalInfo.DataBind();
        }
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string CheckInfoName(string Infoname, int Id) 
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int IsExits = 0;
        string res = "";

        using (MySqlTransaction tr = con.BeginTransaction()) 
        {
            try
            {
                string query = "SELECT COUNT(*) FROM ass_additional_info WHERE InfoID!='" + Id + "' AND NAME='" + Infoname + "'";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    IsExits = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                }
            }
            catch { tr.Rollback(); }
        }

        if (IsExits > 0)
        {
            res = "1";
        }
        else { res = "0"; }

        return Newtonsoft.Json.JsonConvert.SerializeObject(res);
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string CheckIsInfoExists(string Inf) 
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int IsExits = 0;
        string res = "";

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "SELECT COUNT(*) FROM ass_additional_info WHERE NAME='" + Inf + "'";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    IsExits = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                }
            }
            catch { tr.Rollback(); }
        }

        if (IsExits > 0)
        {
            res = "1";
        }
        else { res = "0"; }

        return Newtonsoft.Json.JsonConvert.SerializeObject(res);
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string UpdateInfo(string Infoname, int Active, int InID)
    {
        string Result = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "UPDATE ass_additional_info SET NAME=@NAME, IsActive=@IsActive, UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "', UpdatedDatetime=CURDATE() WHERE InfoID=@InfoID";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@NAME", Infoname);
                    cmd.Parameters.AddWithValue("@IsActive", Active);
                    cmd.Parameters.AddWithValue("@InfoID", InID);

                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    con.Close();
                    
                    Result = "1";
                }
            }
            catch { 
                tr.Rollback();
                Result = "0";
            }
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(Result);
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string SaveAdditionalInfo(string AddInfo, int Isactive) 
    {
        string Result = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int maxId=0;
        maxId = GetInfoMaxId();
        maxId = maxId + 1;

        using (MySqlTransaction tr = con.BeginTransaction()) 
        {
            try
            {
                DateTime dt = Util.GetDateTime(DateTime.Now);
                string query = "INSERT INTO ass_additional_info(`InfoID`,`NAME`,`IsActive`,`CreatedBy`,`CreatedDateTime`)"+
                    "VALUES('" + maxId + "','" + AddInfo + "','" + Isactive + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE())";
                using (MySqlCommand cmd = new MySqlCommand(query, con,tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    con.Close();
                   
                    Result = "1";
                    
                }
            }
            catch
            {
                tr.Rollback();
                Result = "0";
            }
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(Result);
    }

    public static int GetInfoMaxId() 
    {
        int Id = 0;
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string query = "SELECT IFNULL(MAX(InfoID),0) FROM ass_additional_info";
        using (MySqlCommand cmd = new MySqlCommand(query, cn))
        {
            cmd.CommandType = CommandType.Text;
            Id = Convert.ToInt32(cmd.ExecuteScalar());
            cn.Close();
        }

        return Id;
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetInfoNameById(int InID)
    {
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();
        string nam = "";

        string query = "SELECT Name FROM ass_additional_info WHERE InfoID='" + InID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, cn))
        {
            cmd.CommandType = CommandType.Text;
            nam = cmd.ExecuteScalar().ToString();
            cn.Close();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(nam);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string DropDownCheckBoxCheck(int errorid)
    {

        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();
        string AddID = "";

        string query = "SELECT AdditionalInfoID FROM ticket_error_type WHERE Error_id='" + errorid + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, cn))
        {
            cmd.CommandType = CommandType.Text;
            AddID = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(AddID);
    }
    protected void btnBind_Click(object sender, EventArgs e)
    {
        string query = "SELECT * FROM ass_additional_info WHERE IsActive=1";

        DataTable dt = StockReports.GetDataTable(query);

        if (dt.Rows.Count > 0)
        {
            ddlAditionalInfo.DataSource = dt;
            ddlAditionalInfo.DataTextField = "NAME";
            ddlAditionalInfo.DataValueField = "InfoID";
            ddlAditionalInfo.DataBind();

            //ddlAditionalInfo.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlAditionalInfo.Items.Clear();
            ddlAditionalInfo.DataSource = null;
            ddlAditionalInfo.DataBind();
        }
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetEmployeename(string EmployeeID)
    {
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();
        string empname = "";

        if (EmployeeID != "0")
        {
            string query = "SELECT CONCAT(em.Title,em.Name)EmployeeName FROM employee_master em WHERE EmployeeID='" + EmployeeID + "'";
            using (MySqlCommand cmd = new MySqlCommand(query, cn))
            {
                cmd.CommandType = CommandType.Text;
                empname = cmd.ExecuteScalar().ToString();
                cn.Close();
            }
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(empname);
    }
}