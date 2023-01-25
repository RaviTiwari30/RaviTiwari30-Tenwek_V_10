<%@ WebService Language="C#" Class="Panel_Process_Master" %>

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
public class Panel_Process_Master  : System.Web.Services.WebService {

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getPanel()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.LoadPanelIPD());
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getValidity()
    {
        string[] myString = AllGlobalFunction.Validity;
        DataTable dtValidity = new DataTable();
        dtValidity.Columns.Add("Validity");
        foreach (string value in myString)
        {
            dtValidity.Rows.Add(value);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dtValidity);
    }
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getProcess()
    {
        string strQ = "Select ProcessID,Name from Process_Master where IsActive=1 order by Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);   
    }

    [WebMethod]
    public string LoadPanelProcessList(string PanelID)
    {
        string result = "0";
        string strQ = "";
        
        strQ += "     SELECT pnl.Company_Name As Panel,pnl.PanelID,proc.Name AS Process,proc.ProcessID,tpm.Validity,tpm.Priority,tpm.IsActive FROM tpa_process_master tpm ";
        strQ += "     INNER JOIN f_panel_master pnl ON tpm.PanelID=pnl.PanelID ";
        strQ += "     INNER JOIN Process_Master proc ON tpm.ProcessID=proc.ProcessID ";
           
        if (PanelID != "")
            strQ += "  WHERE tpm.PanelID = " + PanelID + " ";
        strQ += " order by tpm.Priority ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ);

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;

    }

    
    [WebMethod(EnableSession = true)]
    public string SavePanelProcess(string PanelID,string ProcessID,string Validity)
    {
        string result = "0";
        if (ProcessID != "")
        {
            string ChkProcess = StockReports.ExecuteScalar("Select ProcessID from TPA_Process_Master where PanelID=" + PanelID + " AND ProcessID='" + ProcessID + "'");
            if (ChkProcess != "")
            {
                result = "2";
                return result;
            }

            string Priority = StockReports.ExecuteScalar("SELECT IFNULL((MAX(Priority)+1),0)Priority FROM TPA_Process_Master WHERE PanelID=" + PanelID + " ");
            if (Priority == "0")
                    Priority = "1";

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string str = "insert into TPA_Process_Master(PanelID,ProcessID,Validity,Priority,CreatedBy) values(" + PanelID + ",'" + ProcessID + "','" + Validity + "','" + Priority + "','" + Session["ID"].ToString() + "')";
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
    public string UpdatePanelProcessList(object Data)
    {
        List<PanelProcessMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<PanelProcessMaster>>(Data);
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
                    str = "UPDATE TPA_Process_Master set IsActive='" + dataItem[i].IsActive + "',Validity='" + dataItem[i].Validity + "',Priority='" + dataItem[i].Priority + "', " +
                        " UpdatedDate =now(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' Where ProcessID = '" + dataItem[i].ProcessID + "' AND PanelID=" + dataItem[i].PanelID + " ";

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

