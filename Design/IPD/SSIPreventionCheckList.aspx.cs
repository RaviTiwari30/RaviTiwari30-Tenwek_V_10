using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_IPD_SSIPreventionCheckList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindCheckList(string TID, string PID)
    {
        string retn = "";
        string count = StockReports.ExecuteScalar("SELECT count(*) FROM  patient_ssipreventionchecklist sc WHERE  sc.PatientID='" + PID + "' AND sc.TransactionID='" + TID + "' and sc.IsActive='1'");

        StringBuilder sb = new StringBuilder();
        if (Int32.Parse(count) == 0)
        {
            sb.Append(" SELECT '' CID,sm.ID AS MID,sm.TheBundle,sm.Criteria, 0 CheckListItemValue FROM ssipreventionchecklistmaster sm WHERE sm.IsActive=1 ORDER BY ID ");            
        }
        else
        {
            sb.Append(" SELECT *,sm.ID as MID,sc.ID as CID FROM ssipreventionchecklistmaster sm INNER JOIN patient_ssipreventionchecklist sc ON sm.ID=sc.CheckListItemID ");
            sb.Append(" WHERE sc.IsActive=1 and sc.PatientID='" + PID + "' AND sc.TransactionID='" + TID + "' ");
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retn;
        }
        else
        {
            return retn;
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveCheckList(string TID, string PID, object Data)
    {
        List<CheckList> dataTP = new JavaScriptSerializer().ConvertToType<List<CheckList>>(Data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            if (dataTP.Count > 0)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE patient_ssipreventionchecklist set IsActive='0',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() +
   "', UpdatedDate = '" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss") + "',  IPAddress = '" + All_LoadData.IpAddress() + " '  where TransactionID='" + TID + "'");

                for (int i = 0; i < dataTP.Count; i++)
                {

                    if (dataTP[i].CID != "null" && dataTP[i].CID != "" )
                    {
                       
                    }
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO `patient_ssipreventionchecklist` (" +
    " `CheckListItemID`,  `CheckListItemValue`,  `PatientID`,  `TransactionID`,  `EntryBy`,  `EntryDate`,  `IPAddress`,  `CentreID`,  `IsActive`)" +
    " VALUES  (      '" + dataTP[i].CheckListItemID + "',    '" + dataTP[i].CheckListItemValue + "',    '" + PID + "',    '" + TID + "',    '" + HttpContext.Current.Session["ID"].ToString() +
    "',    '" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss") + "',  '" + All_LoadData.IpAddress() + " ' ,  '" + HttpContext.Current.Session["CentreID"].ToString()
    + "',    '1' );");

                }
                tranX.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Success", message = "Record Saved Successfully" });
            }
            else
            {
                tranX.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Failure", message = "Error occurred, Please contact Administrator" });

            }
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public class CheckList
    {
        public string MID { get; set; }
        public string CID { get; set; }

        public string CheckListItemID { get; set; }
        public string CheckListItemValue { get; set; }

    }
}