<%@ WebService Language="C#" Class="LaundryService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class LaundryService : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public string updateMachineMaster(string ID,string MachineName, string MachineType, string MachineTypeID, string Capacity, string RunningTime, string RunningTimePerBatch, string PurchaseDate, string MaintenancePerMonth)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "update  laundry_machineMaster set MachineName='" + MachineName + "',MachineType='" + MachineType + "',MachineTypeID='" + MachineTypeID + "'"+
            ",Capacity='" + Capacity + "',RunningTime='" + Util.GetDateTime(RunningTime).ToString("HH:mm:ss") + "',RunningTimePerBatch='" + RunningTimePerBatch + "',PurchaseDate='" + Util.GetDateTime(PurchaseDate).ToString("yyyy-MM-dd") + "',MaintenancePerMonth='" + MaintenancePerMonth + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' " +
                " where ID='"+ID+"'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string machineMaster(string MachineName, string MachineType,string MachineTypeID, string Capacity, string RunningTime, string RunningTimePerBatch, string PurchaseDate, string MaintenancePerMonth)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "INSERT INTO laundry_machineMaster(MachineName,MachineType,MachineTypeID,Capacity,RunningTime,RunningTimePerBatch,PurchaseDate,MaintenancePerMonth,CreatedBy,CentreID)VALUES('" + MachineName + "','" + MachineType + "','" + MachineTypeID + "','" + Capacity + "','" + Util.GetDateTime(RunningTime).ToString("HH:mm:ss") + "','" + RunningTimePerBatch + "','" + Util.GetDateTime(PurchaseDate).ToString("yyyy-MM-dd") + "','" + MaintenancePerMonth + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string bindMachineMaster()
    {
        DataTable dt = StockReports.GetDataTable("SELECT MachineTypeID,MachineName,MachineType,Capacity,IF(RunningTime='00:00:00','',RunningTime)RunningTime,RunningTimePerBatch PerBatchTime,IF(PurchaseDate='0001-01-01','',DATE_FORMAT(PurchaseDate,'%d-%b-%Y'))PurchaseDate,MaintenancePerMonth,IF(IsActive=1,'Yes','No')Active,ID FROM laundry_machineMaster");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string laundryPost()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,processID,StockID,ItemID,ItemName,SUM(ReturnQty)ReturnQty,IsProcess,IF(IsProcess<>1,'Yes','No')IsWashing,IF(IsProcess NOT IN (1,2),'Yes','No')IsDryer,IF(IsProcess NOT IN (1,2,3),'Yes','No')IsIroning FROM laundry_recieve_stock_detail WHERE IsComplete=0 AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' GROUP BY ProcessID,IsProcess ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
   [WebMethod(EnableSession = true)]
    public string PostLaundryData(object postLaundry)
    {
        List<postLaundry> dataItem = new JavaScriptSerializer().ConvertToType<List<postLaundry>>(postLaundry);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < dataItem.Count; i++)
            {
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_nmstock SET IsPost=1,PostDate=NOW(),StockDate=CURDATE(),PostUserID='" + HttpContext.Current.Session["ID"].ToString() + "',laundryDirty=2 WHERE StockID='" + Util.GetInt(dataItem[i].StockID) + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE laundry_recieve_stock SET IsComplete=1,CompletedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID=" + Util.GetInt(dataItem[i].ID) + "");
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class postLaundry
    {
        public int ID { get; set; }
        public int StockID { get; set; }
    }
}