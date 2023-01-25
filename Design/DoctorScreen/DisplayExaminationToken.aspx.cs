using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Text;

public partial class DisplayExaminationToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    [WebMethod(EnableSession = false)] // developed by Ankit
    public static string BindDisplayToken() 
    {
        DataTable dt = new DataTable();
        DataSet ds = new DataSet();
        MySqlDataReader dr;
        String daresult = null;
        MySqlDataAdapter Adp = new MySqlDataAdapter();

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string query = "SELECT emt.ExaminationTokenNo,tc.CounterName,CONCAT(pm.`Title`,'',pm.`PName`)PatientName FROM f_ExaminationToken emt INNER JOIN Temp_Counter tc ON tc.Id=emt.CounterID INNER JOIN Patient_Master pm ON pm.PatientID=emt.PatientID AND  emt.TodaysDate=CURDATE() WHERE CallStatus=1 ORDER BY tc.Id";
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                cmd.CommandType = CommandType.Text;
                Adp.SelectCommand = cmd;
                Adp.Fill(ds);

                daresult = DataSetToJson(ds);
            }
            int rowcount = ds.Tables[0].Rows.Count;
            string[] all = new string[rowcount];

            //string[] a = all.Split(',');

            return daresult;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    public static string DataSetToJson(DataSet ds)
    {
        Dictionary<string, object> dict = new Dictionary<string, object>();
        foreach (DataTable dt in ds.Tables)
        {
            object[] arr = new object[dt.Rows.Count + 1];

            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                arr[i] = dt.Rows[i].ItemArray;
            }

            dict.Add(dt.TableName, arr);
        }

        JavaScriptSerializer json = new JavaScriptSerializer();
        return json.Serialize(dict);
    }

    [WebMethod(EnableSession = false)] // developed by Ankit
    public static string GetTime()
    {
        DateTime d = DateTime.Now;
        //string res = d.ToString("hh:mm tt");
        int res = d.Day;
        //if (res == "12:00 AM") 
        //{ 
            
        //}
        
        return "";
    }

    [WebMethod]
    public static string bindPendingToken()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT emt.ExaminationTokenNo,CONCAT(pm.`Title`,'',pm.`PName`)PatientName,IFNULL(emt.`IsAbsent`,0)IsAbsent FROM f_ExaminationToken emt  ");
        sb.Append(" INNER JOIN Patient_Master pm ON pm.PatientID=emt.PatientID AND  emt.TodaysDate=CURDATE()  ");
        sb.Append(" INNER JOIN `appointment` app ON app.`TransactionID`=emt.`TransactionID` AND app.`PatientID`=emt.`PatientID` AND app.`TemperatureRoom`=0 ");
        sb.Append(" WHERE CallStatus=0 ORDER BY emt.ExaminationTokenNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }
}