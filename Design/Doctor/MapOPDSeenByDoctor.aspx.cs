using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Doctor_MapOPDSeenByDoctor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text =  System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtCurrDate.Text = System.DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveMapOPDSeenByDoctor(string Date, string ActualDoctorID, string SeenByDoctorID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            //var Updated = HttpContext.Current.Session["ID"].ToString();
            var message = "";

            string str = " SELECT COUNT(*) FROM App_Doctor_seenby_Doctor WHERE ActualDoctorID = '" + ActualDoctorID + "' And Date = '" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' and IsActive=1 ";
            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Doctor Already Mapped" });
            }
            if (ActualDoctorID == SeenByDoctorID)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = " Don't Save Same Name Doctor!" });
            }
            string sqlCMD = "INSERT INTO App_Doctor_seenby_Doctor (Date,ActualDoctorID,SeenByDoctorID,EntryBy,EntryByDateTime) VALUES(@Date,@ActualDoctorID,@SeenByDoctorID,@EntryBy,Now());";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Date = Util.GetDateTime(Date).ToString("yyyy-MM-dd"),
                ActualDoctorID = ActualDoctorID,
                SeenByDoctorID = SeenByDoctorID,
                EntryBy = UserID,

            });
            message = "Record Save Successfully";


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
    [WebMethod(EnableSession = true)]
    public static string UpdateMapOPDSeenByDoctor(string ID, string selectedDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var Updatedby = HttpContext.Current.Session["ID"].ToString();
            var message = "";
            DateTime seDate= Util.GetDateTime(Util.GetDateTime(selectedDate).ToString("yyyy-MM-dd"));
            DateTime CurrentDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));

            if (seDate >= CurrentDate)
            {
                string sqlCMD = "UPDATE App_Doctor_seenby_Doctor SET UpdatedBy =@UpdatedBy,UpdatedByDateTime=now(), IsActive = 0 WHERE ID = @ID ";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    ID = ID,
                    UpdatedBy = Updatedby,
                });
                message = "Record Delete Successfully";

                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Can not Delete back date Data" });
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

    [WebMethod(EnableSession = true)]
    public static string BindMapOPDSeenByDoctor()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ds.ID, DATE_FORMAT(ds.`Date`,'%d-%b-%Y')Date ,DATE_FORMAT(ds.`EntryByDateTime`,'%d-%b-%Y')EntryByDateTime, ");
        sb.Append("  CONCAT(dm.`Title`,'' ,dm.`NAME`)DName, CONCAT(em.`Title`,'',em.`NAME`)EName, ");
        sb.Append(" CONCAT(dms.`Title`,'' ,dms.`NAME`)SeenByName  FROM App_Doctor_seenby_Doctor ds ");
        sb.Append(" INNER JOIN Doctor_master dm ON dm.`DoctorID` = ds.`ActualDoctorID` INNER JOIN Doctor_master dms ON dms.`DoctorID` = ds.`SeenByDoctorID` ");
        sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID` = ds.`EntryBy` WHERE ds.`IsActive` = 1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    public static object UpdatedByDateTime { get; set; }
}