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
using System.Data.SqlClient;

public partial class Design_EDP_MastersInsert : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string UpdateState(int StateID, int CountryID, string StateName, int active)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {
            if (StateName != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE master_State SET StateName='" + StateName + "',IsActive='" + active + "' WHERE CountryID='" + CountryID + "' AND StateID='" + StateID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }

            if (res == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("OK");
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);            
            return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string DeleteCity(int CityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {
            if (CityID != null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("DELETE FROM city_master WHERE ID='" + CityID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }

            if (res == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("OK");
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public static string DeleteDistrict(int DistrictID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {
            if (DistrictID != null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("DELETE FROM Master_District WHERE DistrictID='" + DistrictID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }

            if (res == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("OK");
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string DeleteState(int StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {
            if (StateID != null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("DELETE FROM master_State WHERE StateID='" + StateID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }

            if (res == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("OK");
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string UpdateDistrict(int StateID, int CountryID, string DistrictName, int active, int DistrictID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {
            if (DistrictName != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE Master_District SET District='" + DistrictName + "', IsActive='" + active + "', CountryID='" + CountryID + "', StateID='" + StateID + "' WHERE DistrictID='" + DistrictID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }

            if (res == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("OK");
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string UpdateCity(int StateID, int CountryID, int DistrictID, int active, string CityName, int CityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {

            if (CityName != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE city_master SET City='" + CityName + "',Country='" + CountryID + "',districtID='" + DistrictID + "',stateID='" + StateID + "',IsActive='" + active + "' WHERE ID='" + CityID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }

            if (res == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("OK");
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject("NO");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string getVillagelist()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT TalukaID AS VillageID,Taluka AS VillageName,IF(IsActive=0,'No','Yes')IsActive,IFNULL(EntryBy,'') AS CreatedBy FROM Master_Taluka ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string UpdateVillageMaster(string villageID, string villageName, string Active)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var message = "";
        try
        {
            if (villageID != "")
            {

                string sqlCMD = "UPDATE Master_Taluka SET Taluka=@Taluka,Isactive=@Isactive,UpdateBy=@UpdateBy,UpdateDate=NOW() WHERE TalukaID=@TalukaID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Taluka = villageName,
                    Isactive = Util.GetInt(Active),
                    UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                    TalukaID = Util.GetInt(villageID),
                });

                message = "Village Name Update Sucessfully";
            }
            else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" }); }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}