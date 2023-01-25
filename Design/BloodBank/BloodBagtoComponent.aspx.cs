using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_BloodBagtoComponent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    public static string LoadBloodBag()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,BagType FROM bb_BagType_master WHERE IsActive=1 ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string LoadBloodComponent()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ComponentName ComponentName,ID FROM bb_component_master  WHERE active='1' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string SaveMapBloodBagType(string BloodBagID, string BloodBagName, string ComponentID, string ComponentName)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            int IsExists = Util.GetInt(StockReports.ExecuteScalar(" Select Count(*) from bb_BagType_Component_Mapping where BagTypeID ='" + BloodBagID + "' and ComponentID='" + ComponentID + "' "));
            if (IsExists > 0)
                return "2";
            string str = "Insert into bb_BagType_Component_Mapping(BagTypeID,BagTypeName,ComponentID,ComponentName,CreateBy) values ('" + BloodBagID + "','" + BloodBagName + "','" + ComponentID + "','" + ComponentName + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string DeleteMapBloodBag(string ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            string str = "DELETE FROM bb_BagType_Component_Mapping WHERE ID=" + Util.GetInt(ID) + " ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindMappedBloodBag(string BagTypeID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,BagTypeID  ,BagTypeName  ,ComponentID  ,ComponentName FROM bb_BagType_Component_Mapping WHERE BagTypeID='" + BagTypeID + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}