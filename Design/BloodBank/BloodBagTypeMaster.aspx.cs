using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_BloodBagTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod (EnableSession=true)]
    public static string SaveBagType(string BagTypeName) 
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
          
            int IsExists = Util.GetInt(StockReports.ExecuteScalar(" SELECT * FROM bb_BagType_master where IsActive=1 and BagType='" + BagTypeName + "'"));
            if (IsExists > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Bag Type Already Exists"});

            string str = "Insert into bb_BagType_master(BagType,CreatedBy) values ('" + BagTypeName + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Bag Type Saved Successfully" });
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

    [WebMethod]
    public static string LoadBagType() 
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,BagType,IsActive FROM bb_BagType_master  ORDER By id");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod (EnableSession=true)]
    public static string UpdateBagType(string BagTypeName, string ID, string ActiveStatus) 
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            int IsExists = Util.GetInt(StockReports.ExecuteScalar(" SELECT * FROM bb_BagType_master where IsActive='" + ActiveStatus + "' and BagType='" + BagTypeName + "'"));
            if (IsExists > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Bag Type Already Exists"});

            string str = "Update bb_BagType_master set BagType= '" + BagTypeName + "' , IsActive= '" + ActiveStatus + "' where ID='" + ID + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Bag Type Update Successfully" });
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
   
}