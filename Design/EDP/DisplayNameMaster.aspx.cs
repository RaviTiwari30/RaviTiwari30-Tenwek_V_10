using System;
using System.Web.Services;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_EDP_DisplayNameMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string bindDisplayName()
    {
        DataTable dt = StockReports.GetDataTable("select DisplayName AS Name,ID from f_displaynamemaster Where DisplayName<>'' order by DisplayName");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Display Name")]
    public static string saveDisplayName(string DisplayName)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_displaynamemaster WHERE DisplayName='" + DisplayName.Trim() + "' "));
        if (count > 0)
            return "2";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_displaynamemaster(DisplayName,CreatedBy) VALUES('" + DisplayName + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
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

    [WebMethod(EnableSession = true, Description = "Update Display Name")]
    public static string UpdateDisplayName(string DisplayName, string ID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_displaynamemaster WHERE DisplayName='" + DisplayName + "' AND ID != '" + ID + "' "));
        if (count > 0)
            return "2";
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_displaynamemaster Set DisplayName='" + DisplayName.Trim() + "',CreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',CreatedDateTime=NOW() where ID ='" + ID + "' ");
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