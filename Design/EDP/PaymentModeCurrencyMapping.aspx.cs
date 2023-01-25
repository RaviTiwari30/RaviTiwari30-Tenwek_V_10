using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;
using Oracle.ManagedDataAccess.Client;
using System.Web.Script.Serialization;

public partial class Design_EDP_PaymentModeCurrencyMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    public static string LoadRole()
    {
        DataTable dt = StockReports.GetDataTable("select ID,RoleName from f_rolemaster where active=1 order by RoleName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string LoadEmployee(string RoleID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT em.Name,em.Employee_ID FROM employee_master em INNER JOIN f_login fl ON em.Employee_ID=fl.EmployeeID WHERE fl.RoleID='" + RoleID + "'  AND fl.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " GROUP BY em.Employee_ID");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string BindPaymentMatrix()
    {
        DataTable dt = StockReports.GetDataTable("CALL ess_UserPaymentMatrix();");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string BindGLCode()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT coa_id, coa_nm FROM fin.fin$coa WHERE COA_COG_ID = '1003'");
        dt = GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindEmployeeDetail(string EmployeeID) 
    {
        DataTable dt = StockReports.GetDataTable(" SELECT em.Name,em.Employee_ID,rm.RoleName FROM employee_master em INNER JOIN f_login fl ON em.Employee_ID=fl.EmployeeID INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID WHERE em.Employee_ID='" + EmployeeID + "' LIMIT 1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true, Description = "Save Request")]
    public static string SaveMappping(List<PaymentModeWiseGlobalCodeDetail> paymentModeWiseGlobalCodeDetails, string EmpID)
    {
        if (paymentModeWiseGlobalCodeDetails.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                foreach (var item in paymentModeWiseGlobalCodeDetails)
                {
                    foreach (var s in item.globalCodeDetail)
                    {

                        string PayModeID = StockReports.ExecuteScalar("Select PaymentModeID from paymentmode_master where PaymentMode='" + s.paymentMode + "' ");

                        int MappID = Util.GetInt(StockReports.ExecuteScalar("Select id from usercurrencypaymodemapping where Employee_ID='" + EmpID + "' and Currency='" + item.currency + "' and PaymentModeID=" + PayModeID + ""));
                        if (MappID > 0)
                        {
                            string str = "Delete From usercurrencypaymodemapping where id=" + MappID + "";
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                        }
                        if (s.value != "0")
                        {
                            sb.Append(" INSERT INTO usercurrencypaymodemapping (Employee_ID,Currency,PaymentModeID,PaymentMode,GLCODE_Value,GLCODE_Name) ");
                            sb.Append(" VALUES('" + EmpID + "','" + item.currency + "'," + PayModeID + ",'" + s.paymentMode + "'," + s.value + ",'" + s.text + "');");
                        }
                    }
                }
                if(sb.ToString()!="")
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
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

    public class GlobalCodeDetail
    {
        public string value { get; set; }
        public string text { get; set; }
        public string paymentMode { get; set; }
        public string paymentModeID { get; set; }
    }


    public class PaymentModeWiseGlobalCodeDetail
    {
        public string currency { get; set; }
        public List<GlobalCodeDetail> globalCodeDetail { get; set; }
    }




    #region GetDataTable
    public static DataTable GetDataTable(string strQuery)
    {
        OracleConnection conn = new OracleConnection(System.Configuration.ConfigurationManager.AppSettings["OracleConnectionFinance"]);

        if (conn.State == ConnectionState.Closed)
            conn.Open();

        DataTable dt = new DataTable();

        OracleCommand cmd = new OracleCommand(strQuery, conn);
        cmd.CommandTimeout = 180;
        DataSet ds = new DataSet();
        OracleDataAdapter da = new OracleDataAdapter();

        da.SelectCommand = cmd;
        da.Fill(ds);
        dt = ds.Tables[0];
        if (conn.State == ConnectionState.Open)
            conn.Close();
        if (conn != null)
        {
            conn.Dispose();
            conn = null;
        }
        return dt;
    }
    #endregion

}
