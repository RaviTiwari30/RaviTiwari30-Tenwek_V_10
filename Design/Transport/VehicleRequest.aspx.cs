using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Transport_VehicleRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblLoginType.Text = Session["DeptLedgerNo"].ToString();
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calDate.StartDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readonly", "readonly");
    }

    [WebMethod(EnableSession = true)]
    public static string SaveRequest(string FromDept, string ToDept, string Type, string Date, string Time, string Purpose, string PurposeName, string Comment)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try 
        {
            VehicleRequest vehicle = new VehicleRequest();
            vehicle.DeptFrom = Util.GetString(FromDept);
            vehicle.DeptTo = Util.GetString(ToDept);
            vehicle.VehicleType = Util.GetString(Type);
            vehicle.TravelDate = Util.GetDateTime(Date);
            vehicle.TravelTime = Util.GetDateTime(Time);
            vehicle.Purpose = Util.GetString(Purpose);
            vehicle.EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());
            vehicle.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            vehicle.HospCentreID = Util.GetInt(1);
            vehicle.Insert();
            // Department Requisition New
            string BookingDateTime = Date + " " + Time;
            string DeptName = StockReports.ExecuteScalar("SELECT LedgerName FROM f_ledgermaster WHERE groupId='DPT' AND LedgerNumber='" + Util.GetString(FromDept) + "'");
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Get_ID_YearWise('Transport Requisition No','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')");
            string RequisitionNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString()));
            sb.Clear();

            sb.Append("INSERT INTO t_transport_request(TokenNo,IsDept,DeptLedgerNo,DeptName,CreatedBy,BookingDate,CentreID,PurposeName,PurposeID,Comment) ");
            sb.Append(" VALUES('" + RequisitionNo + "',1,'" + Util.GetString(FromDept) + "','" + Util.GetString(DeptName) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(BookingDateTime).ToString("yyyy-MM-dd HH:mm:ss") + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",'"+Util.GetString(PurposeName)+"','"+Util.GetString(Purpose)+"','"+Comment+"')");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
            // End
            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        
        return result;
    }
}