using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_BloodGroupCompatiblity : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    public static string LoadBloodGroup()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT ID,BloodGroup FROM bb_BloodGroup_master WHERE IsActive=1 AND bloodgroup<>' NA'  order by bloodgroup ");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string SaveMapBloodGroup(string FromBG,string ToBG)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            int IsExists = Util.GetInt(StockReports.ExecuteScalar(" Select Count(*) from bb_grouping_compatible where FromaBG ='" + FromBG + "' and TOBG='" + ToBG + "' "));
            if (IsExists > 0)
                return "2";
            string str = "Insert into bb_grouping_compatible(FromaBG,TOBG,EntryBy) values ('" + FromBG + "','" + ToBG + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
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
    public static string DeleteMapBloodGroup(string ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            string str = "DELETE FROM bb_grouping_compatible WHERE ID=" + Util.GetInt(ID) + " ";
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
    public static string BindMappedBloodGroup(string FromBG)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,FromaBG,ToBG FROM bb_grouping_compatible WHERE FromaBG='" + FromBG + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}