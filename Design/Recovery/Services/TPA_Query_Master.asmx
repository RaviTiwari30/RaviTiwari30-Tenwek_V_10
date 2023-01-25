<%@ WebService Language="C#" Class="TPA_Query_Master" %>

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
public class TPA_Query_Master : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string LoadQueries(string Query, string Type)
    {
        string result = "0";
        string strQ = "";
        strQ += " Select Name As Query,QueryID,IsActive from TPA_Query_Master Where QueryID >0 ";

        if (Query != "")
            strQ += "  AND Name LIKE '" + Query + "%' ";
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
    public string SaveQuery(string Query)
    {
        string result = "0";
        if (Query != "")
        {
            string ChkQuery = StockReports.ExecuteScalar("Select QueryID from TPA_Query_Master where Name='" + Query + "'");
            if (ChkQuery != "")
            {
                result = "2";
                return result;
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string str = "insert into TPA_Query_Master(Name,CreatedBy) values('" + Query + "','" + Session["ID"].ToString() + "')";
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
    public string UpdateQueries(object Data)
    {
        List<QueryMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<QueryMaster>>(Data);
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

                    str = "UPDATE TPA_Query_Master set Name='" + HttpUtility.UrlDecode(dataItem[i].Query) + "',IsActive='" + dataItem[i].IsActive + "', " +
                        " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' Where QueryID = '" + dataItem[i].QueryID + "'";

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

