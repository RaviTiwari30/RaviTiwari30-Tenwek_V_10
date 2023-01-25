using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_RequestBloodTransfertoCentre : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }

    [WebMethod(EnableSession = true)]
    public static string LoadCentre()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE isactive=1 and CentreID<>'" + HttpContext.Current.Session["CentreID"].ToString() + "' order by CentreName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string LoadComponent()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT ComponentName ,ID FROM bb_component_master  WHERE active='1' order by ComponentName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
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
    public static string SearchStock(string CentreID, string Component, string BloodGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,bdr.ComponentName,bdr.BloodGroup,IFNULL(sm.BBTubeNo,'')Batchno,IFNULL(sm.ExpiryDate,'')ExpiryDate,bdr.EntryReason,IF(bdr.Status=1,'Pending',IF(bdr.Status=2,'Issue','Reject'))STATUS,bdr.Quantity,IFNULL(bdr.IssueQuantity,0)IssueQuantity,IFNULL(bdr.RejectQty,0)RejectQty,( bdr.Quantity-IFNULL(bdr.IssueQuantity,0)-IFNULL(bdr.RejectQty,0))PendingQty FROM bb_Department_BloodRequest bdr ");
        sb.Append(" INNER JOIN center_master cm ON cm.CentreID=bdr.ToCentreID LEFT JOIN bb_stock_master sm ON bdr.id=sm.DeptRequestID WHERE bdr.FromCentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " and bdr.ToCentreID=" + CentreID + "");
        if (Component != "0")
        {
            sb.Append(" and bdr.ComponentID='" + Component + "'");
        }
        if (BloodGroup != "Select")
        {
            sb.Append(" AND bdr.BloodGroup='" + BloodGroup + "'");
        }
        sb.Append(" ORDER BY bdr.Id ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }


    [WebMethod(EnableSession = true, Description = "Save Request")]
    public static string SaveRequest(List<StockData> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    string str = "INSERT INTO bb_department_bloodrequest (ComponentID, ComponentName, BloodGroup, FromCentreID, ToCentreID, EntryBy, EntryReason,Quantity) " +
                               " VALUES ('" + Data[i].ComponentID + "','" + Data[i].ComponentName + "','" + Data[i].BloodGroup + "'," + HttpContext.Current.Session["CentreID"].ToString() + "," + Data[i].CentreID + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[i].Reason + "'," + Data[i].Quantity + ")";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                }
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

    public class StockData
    {
        public string CentreID { get; set; }
        public string ComponentID { get; set; }
        public string ComponentName { get; set; }
        public string BloodGroup { get; set; }
        public string Reason { get; set; }
        public string Quantity { get; set; }
    }

}