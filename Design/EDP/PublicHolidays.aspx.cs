using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_EDP_PublicHolidays : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            DataTable dt = StockReports.GetDataTable("SELECT DATE_FORMAT(CURDATE(),'01-%b-%Y') AS FirstDayOfCurrentMonth, DATE_FORMAT(LAST_DAY(CURDATE()),'%d-%b-%Y') AS LastDayOfCurrentMonth");
            txtFromDate.Text = dt.Rows[0]["FirstDayOfCurrentMonth"].ToString();
            txtToDate.Text = dt.Rows[0]["LastDayOfCurrentMonth"].ToString();
        }
        txtDate.Attributes.Add("readOnly", "true");
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
        caltxtDate.StartDate = System.DateTime.Now;
    }

    [WebMethod]
    public static string bindHolidayName()
    {
        string sql = "SELECT e.`ID`,e.`HolidaysName` FROM `Holidays_Master` e WHERE e.`IsActive`=1 ORDER BY e.`HolidaysName` ";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindHolidaysSearch(string fromDate, string toDate)
    {
        StringBuilder sqlCmd = new StringBuilder("SELECT IF(d.`HolidaysDate`>=CURDATE(),1,0)IsDeactiveHolidays,d.`ID`,d.`HolidaysName`,DATE_FORMAT(d.`HolidaysDate`,'%d-%b-%Y') AS HolidaysDate,CONCAT(em.`Title`,' ',em.`Name`) AS EmployeeName,DATE_FORMAT(d.EntryDate,'%d-%b-%Y %I:%i %p') AS EntryDate FROM Holidays_details d INNER JOIN employee_master em ON em.`Employee_ID`=d.`EntryBy` WHERE d.`IsActive`=1 and d.HolidaysDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' and d.HolidaysDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ORDER BY d.`HolidaysDate`");
        DataTable dt = StockReports.GetDataTable(sqlCmd.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string saveHolidaysDetails(int type, int id, string holidaysId, string holidaysName, string HolidayDate, int isSkipValidation)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();

            if (type == 1)
            {
                if (isSkipValidation == 0)
                {
                    string IsExist = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT DATE_FORMAT(HolidaysDate,'%d-%b-%Y') FROM holidays_details s WHERE s.`HolidaysID`='" + holidaysId + "' AND s.`IsActive`=1 AND YEAR(HolidaysDate)='" + Util.GetDateTime(HolidayDate).ToString("yyyy") + "' LIMIT 1 "));

                    if (IsExist != "")
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Same Public Holiday already Exist on Date : <span class='patientInfo'>" + IsExist + "</span> in Same Year ", IsConfirm = 1 });
                    }
                }

                sqlQuery = "INSERT INTO holidays_details(HolidaysID,HolidaysDate,HolidaysName,EntryBy,EntryDate) VALUES(@HolidaysID,@HolidaysDate,@HolidaysName,@EntryBy,now())";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    HolidaysID = holidaysId,
                    HolidaysDate = Util.GetDateTime(HolidayDate).ToString("yyyy-MM-dd"),
                    HolidaysName = holidaysName,
                    EntryBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            if (type == 2)
            {
                sqlQuery = "UPDATE holidays_details SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDate=now() WHERE ID=@id";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    id = id,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", IsConfirm = 0 });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully", IsConfirm = 0 });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message, IsConfirm = 0 });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveHolidays(int type, string holidaysId, string holidaysName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            int IsExist = 0;
            if (type == 1)
                IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM Holidays_Master s WHERE s.`HolidaysName`='" + holidaysName + "' AND s.`IsActive`=1 "));

            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Holidays Name already Exist." });
            }

            if (type == 1)
            {
                sqlQuery = "INSERT INTO Holidays_Master(HolidaysName,EntryBy,EntryDate) VALUES(@HolidaysName,@EntryBy,now())";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    HolidaysName = holidaysName,
                    EntryBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            if (type == 2)
            {
                sqlQuery = "UPDATE Holidays_Master SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDate=now() WHERE ID=@HolidaysId";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    HolidaysId = holidaysId,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Holidays Created Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Holidays De-Activated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}