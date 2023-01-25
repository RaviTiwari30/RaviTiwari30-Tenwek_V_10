using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;
using System.Web.Services;

public partial class Design_OPD_IntercomMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string bindIntercom()
    {
        DataTable dt = StockReports.GetDataTable("select Name,ID,Number,if(IsActive=1,'Yes','No')IsActive from InterComList where CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " order by Name");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Intercom")]
    public static string save(string Name, string Number, string Status)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM InterComList WHERE Name='" + Name.Trim() + "' AND Number='" + Number + "' AND CentreID="+ HttpContext.Current.Session["CentreID"].ToString() +" "));
        if (count > 0)
            return "2";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO InterComList(Name,Number,EntryBy,IsActive,CentreID) VALUES('" + Name + "','" + Number + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Status + "',"+ HttpContext.Current.Session["CentreID"].ToString() +")");
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

    [WebMethod(EnableSession = true, Description = "Update Intercom")]
    public static string Update(string Name, string Number, string ID, string Status)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM InterComList WHERE Name='" + Name.Trim() + "' AND Number='" + Number + "' AND ID != '" + ID + "' "));
        if (count > 0)
            return "2";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update InterComList Set Name='" + Name.Trim() + "' , Number='" + Number + "',UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW(),IsActive='" + Status + "' where ID ='" + ID + "' ");
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