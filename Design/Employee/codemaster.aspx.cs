using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Employee_CodeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod(EnableSession = true)]
    public static string Savedata(string Code, string Description)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            int IsExists = Util.GetInt(StockReports.ExecuteScalar(" SELECT * FROM tenwek_Code where Code='" + Code + "' and CodeOfEmp='" + HttpContext.Current.Session["ID"].ToString() + "'  "));
            if (IsExists > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Code+" Code Already Exists" });

            string str = "Insert into tenwek_Code(Code,Description,CodeOfEmp,EntryBy,CentreId) values ('" + Code + "','" + Description + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["ID"].ToString() + "'," + Util.GetInt(HttpContext.Current.Session["CentreId"].ToString()) + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }

    }


    [WebMethod(EnableSession = true)]
    public static string Activate(string Id)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            string str = "UPDATE  tenwek_Code SET  IsActive=1,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW() WHERE Id=" + Util.GetInt(Id) + "";
                
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Activate Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }

    }


    [WebMethod(EnableSession = true)]
    public static string DeActivate(string Id)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            string str = "UPDATE  tenwek_Code SET  IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW() WHERE Id=" + Util.GetInt(Id) + "";
                
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "DeActivate Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }

    }



    [WebMethod(EnableSession = true)]
    public static string Update(string Id, string Description)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            string str = "UPDATE  tenwek_Code SET  Description='" + Description + "',UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW() WHERE Id=" + Util.GetInt(Id) + "";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }

    }





    
    [WebMethod(EnableSession = true)]
    public static string GetCodeData()
    {

        string ID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT IF(tc.IsActive=1,'Active','DeActive')STATUS,tc.* FROM tenwek_code tc WHERE tc.CodeOfEmp='"+ID+"'");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetActiveCodeData()
    {

        string ID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT IF(tc.IsActive=1,'Active','DeActive')STATUS,tc.* FROM tenwek_code tc WHERE tc.IsActive=1 and  tc.CodeOfEmp='" + ID + "'");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }




}