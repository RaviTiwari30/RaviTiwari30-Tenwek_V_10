<%@ WebService Language="C#" Class="Process_Master" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class Process_Master  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string LoadProcesses(string Process, string Type)
    {
        string result = "0";
        string strQ = "";
        strQ += " Select Name As Process,ProcessID,IsActive from Process_Master Where ProcessID >0 ";

        if (Process != "")
            strQ += "  AND Name LIKE '" + Process + "%' ";
        if (Type != "2")
            strQ += "  AND IsActive ='" + Type + "' ";
        strQ += " order by Name ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ);

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;

    }

    [WebMethod(EnableSession = true)]
    public string SaveProcess(string Process)
    {
        string result = "0"; int Count = 0;
        if (Process != "")
        {
            Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from Process_Master where Name='" + Process + "'"));
            if (Count >0)
            {
                result = "2";
                return result;
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string str = "insert into Process_Master(Name,CreatedBy) values('" + Process + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                tnx.Commit();
                result = "1";
                return result;
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return result;
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return result;
        }
    }

    [WebMethod(EnableSession = true)]
    public string UpdateProcess(object Data)
    {
        List<ProcessMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<ProcessMaster>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {
            string str = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {
                    
                    str = "UPDATE Process_Master set Name='" + HttpUtility.UrlDecode(dataItem[i].Process) + "',IsActive='" + dataItem[i].IsActive + "', " +
                        " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' Where ProcessID = '" + dataItem[i].ProcessID + "'";

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                }
                tnx.Commit();
                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
            return "";
    }
    
}

