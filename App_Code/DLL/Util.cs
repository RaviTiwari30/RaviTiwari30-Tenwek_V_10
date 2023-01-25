using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Linq;
using cfg = System.Configuration.ConfigurationManager;

public sealed class Util
{
    public Util()
    {
    }


    public static string IsAfterGSTApply(string date) {
        if (Convert.ToDateTime(date) >= Convert.ToDateTime("01-Jul-2017"))
            return "1";
        else
            return "0";
    }
    public static string GetConString()
    {
        return cfg.AppSettings["ConnectionString"];
    }

    public static string SiteId()
    {
        return cfg.AppSettings["SiteId"];
    }

    public static string getHash()
    {
        string hash = Util.GetString(System.Guid.NewGuid()) + "" + DateTime.Now.ToString("MMddyyyyHHmmssffff");
        return hash;
    }

    public static MySqlConnection GetMySqlCon()
    {
        MySqlConnection objCon = new MySqlConnection(GetConString());
        return objCon;
    }

    public static string GetParamaterString(params string[] strParam)
    {
        #region GetParamaterString

        try
        {
            string strParamValue = "";

            for (int i = strParam.GetLowerBound(0); i <= strParam.GetUpperBound(0); i++)
            {
                if (i % 2 == 0)
                {
                    strParamValue = strParamValue + strParam.GetValue(i).ToString() + "=";
                }
                else
                {
                    strParamValue = strParamValue + strParam.GetValue(i).ToString() + ",";
                }
            }

            if (strParamValue.Length > 0)
            {
                strParamValue = strParamValue.Substring(0, strParamValue.Length - 1);
            }
            return strParamValue;
        }
        catch
        {
            return "";
        }

        #endregion GetParamaterString
    }

    #region Handle Is DbNull

    public static int GetInt(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return int.Parse(obj.ToString());
    }

    public static Int16 GetShortInt(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return Int16.Parse(obj.ToString());
    }

    public static long GetLong(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return long.Parse(obj.ToString());
    }

    public static decimal GetDecimal(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return Decimal.Parse(obj.ToString());
    }

    public static float GetFloat(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0F;
        else
            return float.Parse(obj.ToString());
    }

    public static double GetDouble(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return double.Parse(obj.ToString());
    }

    public static DateTime GetDateTime(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return Util.GetMinDateTime();
        else
            return DateTime.Parse(obj.ToString());
    }

    public static string GetString(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return "";
        else
            return obj.ToString();
    }

    public static bool GetBoolean(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return false;
        else
            return bool.Parse(obj.ToString());
    }

    public static bool getbooleanTrueFalse(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return false;
        else
            return true;
    }

    public static string getbooleanTypeOfTnx(object Amount, object Typeoftnx)
    {
        if (Typeoftnx == null || Convert.IsDBNull(Typeoftnx) || Typeoftnx.ToString().Trim() == string.Empty)
        {
            return Amount.ToString();
        }
        else
        {
            return "0";
        }
    }

    public static int getbooleanInt(bool obj)
    {
        if (obj == true)
            return 1;
        else
            return 0;
    }

    #endregion Handle Is DbNull

    public static DateTime GetMinDateTime()
    {
        return DateTime.Parse("01/jan/0001");
    }

    public static int DateDiff(DateTime MaxDate, DateTime MinDate)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string sql = "select DATEDIFF('" + MaxDate.ToString("yyyy-MM-dd") + "','" + MinDate.ToString("yyyy-MM-dd") + "') day ";
        string day = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql));

        con.Close();
        con.Dispose();

        if (day != "")
        {
            return int.Parse(day);
        }
        else
        {
            return 0;
        }
    }

    public static string GetTimeForDataBase(string ddlHr, string ddlMin, string cmbAMPM2)
    {
        if ((ddlHr != "-") && (ddlMin != "-") && (cmbAMPM2 != "-"))
        {
            if (cmbAMPM2 == "AM")
                return (ddlHr + ":" + ddlMin + ":00");
            else
            {
                if (Util.GetInt(ddlHr) == 12)
                {
                    return ((Util.GetInt(ddlHr)) + ":" + ddlMin + ":00");
                }
                else
                {
                    return ((Util.GetInt(ddlHr) + 12) + ":" + ddlMin + ":00");
                }
            }
        }
        else
            return string.Empty;
    }

    public static int TimeDiffInMin(DateTime StartTime, DateTime EndTime)
    {
        TimeSpan ts = EndTime.Subtract(StartTime);
        int hours = ts.Hours;
        int TotalMin = (hours * 60) + ts.Minutes;
        return TotalMin;
    }

    public static bool CompareDate(string FromDate, string ToDate)
    {
        if (Convert.ToDateTime(FromDate) > Convert.ToDateTime(ToDate))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static string getDate()
    {
        return System.DateTime.Now.ToString("dd-MMM-yyyy");
    }

    public static string getFormatedDate()
    {
        return System.DateTime.Now.ToString("M/d/yyyy h:mm tt");
    }

    public static string getTomorrow()
    {
        return System.DateTime.Now.AddDays(1).ToString();
    }

    public static string getHours()
    {
        return DateTime.Now.ToString("hh");
    }

    public static string getMintus()
    {
        return DateTime.Now.ToString("mm");
    }

    public static string getYear()
    {
        return System.DateTime.Now.ToString("yyyy");
    }

    public static string getTime()
    {
        return System.DateTime.Now.ToString("hh mm ss");
    }

    public static bool CompareYear(string FromDate, string ToDate)
    {
        if (Convert.ToInt32(FromDate) > Convert.ToInt32(ToDate))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static decimal round(decimal value)
    {
        return Math.Round(value, Util.GetInt(Resources.Resource.RoundOffDigit), MidpointRounding.AwayFromZero);
    }

    public static void do_not_cache(HttpResponse Response)
    {
        Response.CacheControl = "no-cache";
        Response.AddHeader("Pragma", "no-cache");
        Response.Expires = -1;
    }


    public static List<T> GetListFromDataTable<T>(DataTable dt)
    {
        List<T> data = new List<T>();
        foreach (DataRow row in dt.Rows)
        {
            T item = GetItem<T>(row);
            data.Add(item);
        }
        return data;
    }

    private static T GetItem<T>(DataRow dr)
    {
        try
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();
            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (System.Reflection.PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }
        catch (Exception ex)
        {
            
            throw;
        }
      
    }
    public static string ToTitleCase(string input)
    {
        if (input == null || Convert.IsDBNull(input) || input.ToString().Trim() == string.Empty)
            return "";
        else
        {
            return System.Globalization.CultureInfo.InvariantCulture.TextInfo.ToTitleCase(input.ToLower());
        }
    }
    public static string GetFullPatientID(string PatientID)
    {
        int n;
        bool isNumeric = int.TryParse(PatientID, out n);
        if (isNumeric)
        {
            PatientID = //PatientID.PadLeft(7, '0');
            PatientID = PatientID;//PatientID.PadLeft(8, 'C');
            return PatientID;
        }
        else
        {
            return PatientID;
        }
    }
    
    public static string checkDB_Conn()
    {
        string status = "0";
        string Message = "";
        string conn_info = Util.GetConString();
        bool isConn = false;
        MySqlConnection conn = null;
        try
        {
            conn = new MySqlConnection(conn_info);
            conn.Open();
            isConn = true;
        }
        catch (ArgumentException a_ex)
        {
            ClassLog dl = new ClassLog();
            dl.errLog(a_ex);
        }
        catch (MySqlException ex)
        {
            ClassLog dl = new ClassLog();
            isConn = false;
            switch (ex.Number)
            {
                case 1042:// Unable to connect to any of the specified MySQL hosts (Check Server,Port)
                    Message = "Unable to connect to any of the specified MySQL hosts (Check Server,Port)";
                    break;
                case 0: // Access denied (Check DB name,username,password)
                    Message = "Access denied (Check DB name,username,password)";
                    break;
                default:
                    Message = Util.GetString(ex.Number);
                    break;
            }
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
        if (isConn)
            status = "1";
        return status + "#" + Message;
    }
    public static DataTable GetDataTableRowSum(DataTable dt)
    {
        DataRow dr = dt.NewRow();
        //dr[0] = "Total : ";
        int total = 0;
        string[] stringList = "DECIMAL,DOUBLE,INT16,INT32,INT64,UINT16,UINT32,UINT64,FLOAT".ToUpper().Split(",".ToCharArray());
        for (int i = 0; i < dt.Columns.Count; i++)
        {        
            //if (dt.Columns[i].DataType.Name.ToString().ToUpper() == "DECIMAL" || dt.Columns[i].DataType.Name.ToString().ToUpper() == "INT64")
            if (stringList.Contains(dt.Columns[i].DataType.Name.ToString().ToUpper()))
            {
                if (total == 0)
                {
                    total = 1;
                    dr[i - 1] = "Total : ";
                }
                dr[dt.Columns[i].Caption] = Util.round(Util.GetDecimal(dt.Compute("sum([" + dt.Columns[i].Caption + "])", "")));
            }
        }
        if (total == 0)
            dr[0] = "Total : ";
        dt.Rows.InsertAt(dr, dt.Rows.Count + 1);
        return dt;
    }
    public static DataTable GetDataTableRowSumOnColumn(DataTable dt,string columnposition = "")
    {
        dt.Columns.Add("Total", typeof(decimal));
        foreach (DataRow row in dt.Rows)
        {
            decimal rowSum = 0;
            foreach (DataColumn col in dt.Columns)
            {
                if (!row.IsNull(col))
                {
                    string stringValue = row[col].ToString();
                    decimal d;
                    if (decimal.TryParse(stringValue, out d))
                        rowSum += d;
                }
            }
            row.SetField("Total", rowSum);
        }
        if (columnposition != "")
        {
            dt.Columns["Total"].SetOrdinal(Util.GetInt(columnposition));
        }
        return dt;
    }
    public static string GetStringWithoutReplace(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return "";
        else
        {
            return obj.ToString();
        }
    }
}