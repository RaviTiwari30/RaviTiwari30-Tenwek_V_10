z<%@ WebService Language="C#" Class="Recovery_Action" %>

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
public class Recovery_Action  : System.Web.Services.WebService {


    [WebMethod]
    public string SearchRecoveryBill(string InvoiceNo, string IPNo, string PanelGroup, string PanelID, string DispatchDate, string DocketNo, string FromDate, string ToDate, string chkDisp)
    {
        string result = "0";

        StringBuilder Query = new StringBuilder();       
        
        Query.Append(" SELECT tid.PanelID,REPLACE(tid.PatientID,'LSHHI','') AS MRNo,tid.TPAInvNo,REPLACE(tid.TransactionID,'ISHHI','') AS IPNo,tid.PName,tid.TPA AS Panel,tid.BillNo, ");
        Query.Append(" tid.ClaimNo,tid.BillAmt,DATE_FORMAT(tid.TPAInvoiceDate,'%d-%b-%Y %h:%i %p')TPAInvoiceDate,tid.DocketNo,DATE_FORMAT( STR_TO_DATE(tid.DispatchDate, '%d-%b-%Y'),'%d-%b-%Y')DispatchDate,tid.DispatchedBy,  ");
        Query.Append(" IFNULL((SELECT ID FROM recovery_action_detail WHERE TPAInvNo=tid.TPAInvNo AND TransactionID=tid.TransactionID AND IsTPAQuery=1  ");
        Query.Append(" AND IsQueryResolved=0 ORDER BY id DESC LIMIT 1),'')RAID, ");
        Query.Append(" IFNULL((SELECT NAME FROM TPA_Query_Master WHERE QueryID=(SELECT QueryID FROM recovery_action_detail WHERE TPAInvNo=tid.TPAInvNo AND TransactionID=tid.TransactionID AND IsTPAQuery=1  ");
        Query.Append(" AND IsQueryResolved=0 ORDER BY id DESC LIMIT 1)),'')Query, ");        
        Query.Append(" IFNULL((SELECT DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p') FROM recovery_action_detail WHERE TPAInvNo=tid.TPAInvNo AND TransactionID=tid.TransactionID AND IsTPAQuery=1  ");
        Query.Append(" AND IsQueryResolved=0 ORDER BY id DESC LIMIT 1),'')QueryDate, ");
        Query.Append(" IFNULL((SELECT CONCAT(Title,' ',NAME) FROM Employee_Master WHERE Employee_ID=(SELECT CreatedBy FROM recovery_action_detail WHERE TPAInvNo=tid.TPAInvNo AND TransactionID=tid.TransactionID AND IsTPAQuery=1  ");
        Query.Append(" AND IsQueryResolved=0 ORDER BY id DESC LIMIT 1)),'')QueryUser, ");
        Query.Append(" IFNULL((SELECT UserRemark FROM recovery_action_detail WHERE TPAInvNo=tid.TPAInvNo AND TransactionID=tid.TransactionID AND IsTPAQuery=1 ");
        Query.Append(" AND IsQueryResolved=0 ORDER BY id DESC LIMIT 1),'')QueryRemark ");        
        Query.Append(" FROM tpa_invoice_detail tid ");
        Query.Append(" INNER JOIN f_ipdadjustment adj ON tid.TransactionID=adj.TransactionID ");
        Query.Append(" WHERE adj.IsTPAInvActive=1 ");
       
        if (InvoiceNo != "")
        {
            Query.Append("AND tid.TPAInvNo='" + InvoiceNo + "' ");
        }
        if (IPNo != "")
        {
            Query.Append("AND tid.TransactionID='ISHHI" + IPNo + "' ");
        }
        if (DocketNo != "")
        {
            Query.Append("AND tid.DocketNo='" + DocketNo + "' ");
        }     
        if (InvoiceNo == "" && IPNo == "" && DocketNo == "" )
        {          
            if (chkDisp == "1")
            {
                Query.Append("And  STR_TO_DATE(tid.DispatchDate, '%d-%b-%Y')='" + Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd") + "'");
            }
            else if (chkDisp == "0")
            {
                if (PanelID != "0")
                {
                    Query.Append("AND tid.PanelID=" + PanelID + " ");
                }

                Query.Append("And DATE(tid.TPAInvoiceDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(tid.TPAInvoiceDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
            }           
        }

        Query.Append("order by tid.TPAInvNo,tid.TransactionID");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;

    }

    [WebMethod]
    public string GetPreviousComment(string InvoiceNo, string IPNo)
    {
        string result = "0";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT rad.ID,rad.UserRemark,IFNULL(IF(IsTPAQuery=0,(SELECT NAME FROM process_master WHERE ProcessID=rad.ProcessID),(SELECT NAME FROM tpa_query_master WHERE QueryID=rad.QueryID)),'')GroupRemark,IFNULL(DATE_FORMAT(rad.ExpectedDate,'%d-%b-%Y'),'')ExpectedDate, ");
        sb.Append(" CONCAT(em.Title,' ',em.Name)CreatedBy,DATE_FORMAT(rad.CreatedDate,'%d-%b-%y %I:%i %p')CreatedDate,IF(IsTPAQuery=0,'No','Yes')IsTPAQuery  ");
        sb.Append(" FROM recovery_action_detail rad ");
        sb.Append(" INNER JOIN Employee_Master em ON rad.CreatedBy=em.Employee_ID ");
        sb.Append(" WHERE rad.IsReject=0 AND rad.TPAInvNo='" + InvoiceNo + "' AND rad.TransactionID='ISHHI" + IPNo + "' ORDER BY rad.ID DESC");                    
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getInvoiceProcess(string TPAInvNo, string IPNo)
    {
        string result = "0";
        StringBuilder sb = new StringBuilder();              
        sb.Append("  SELECT pm.ProcessID,pm.Name FROM tpa_process_close pc ");
        sb.Append("  INNER JOIN Process_Master pm ON pc.ProcessID=pm.ProcessID ");
        sb.Append("  WHERE pc.IsClosed=0 AND pc.TPAInvNo='" + TPAInvNo + "' AND pc.TransactionID='ISHHI" + IPNo + "' ");
        
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getQuery()
    {
        string result = "0";
        string strQ = "Select QueryID,Name from TPA_Query_Master where IsActive=1 order by Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result; 
    }
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTargetDate(string ProcessID, string TPAInvNo, string IPNo,string Type)
    {
        string result = "0";
        string LastProc_ExpDate = string.Empty;
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        if (Type == "Process")
        {
            if (Util.GetInt(ProcessID) > 0)
            {
                if (Util.GetInt(StockReports.ExecuteScalar("select * from recovery_action_detail where TPAInvNo='" + TPAInvNo + "' AND TransactionID='ISHHI" + IPNo + "' AND IsTPAQuery=0 AND IsReject=0")) <= 0)
                {
                    sb.Append("SELECT DATE_FORMAT(DATE_ADD(ip.CreatedDate, INTERVAL ip.Validity DAY),'%d-%b-%Y %h:%i %p')TargetDate FROM tpa_invoiceprocess ip WHERE ProcessID='" + ProcessID + "' AND TPAInvNo='" + TPAInvNo + "' AND IsActive=1");
                    dt = StockReports.GetDataTable(sb.ToString());
                }
                else
                {
                    LastProc_ExpDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT ExpectedDate FROM recovery_action_detail WHERE TPAInvNo='" + TPAInvNo + "' AND TransactionID='ISHHI" + IPNo + "' AND IsTPAQuery=0 AND IsReject=0 ORDER BY ID DESC LIMIT 1")).ToString("yyyy-MM-dd");
                    sb.Append("SELECT DATE_FORMAT(DATE_ADD('" + LastProc_ExpDate + " " + DateTime.Now.ToString("hh:mm:ss") + "', INTERVAL ip.Validity DAY),'%d-%b-%Y %h:%i %p')TargetDate FROM tpa_invoiceprocess ip WHERE ProcessID='" + ProcessID + "' AND TPAInvNo='" + TPAInvNo + "' AND IsActive=1");
                    dt = StockReports.GetDataTable(sb.ToString());
                }
            }
        }
        else if (Type == "Query")
        {
                sb.Append("SELECT DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 5 DAY),'%d-%b-%Y %h:%i %p')TargetDate");
                dt = StockReports.GetDataTable(sb.ToString());          
        }
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }


    [WebMethod(EnableSession = true)]
    public string SaveActionPlan(object Data)
    {
        string result = "0";
        List<RecoveryAction> dataItem = new JavaScriptSerializer().ConvertToType<List<RecoveryAction>>(Data);
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
                            if (Util.GetInt(dataItem[i].IsTPAQuery) == 0)
                            {
                                if (Util.GetInt(dataItem[i].IsClose) == 1)
                                {
                                    str = "UPDATE tpa_process_close set IsClosed=1,ClosedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ClosedDate=now() Where TPAInvNo='" + dataItem[i].TPAInvNo + "' AND TransactionID='ISHHI" + dataItem[i].IPNo + "' AND ProcessID='" + Util.GetInt(dataItem[i].ProcessID) + "'";
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                                }
                                str = "Insert into recovery_action_detail(TPAInvNo,TransactionID,BillNo,ProcessID,QueryID,TargetDate,ExpectedDate,CreatedBy,IsTPAQuery,UserRemark) values ('" + dataItem[i].TPAInvNo + "','ISHHI" + dataItem[i].IPNo + "','" + dataItem[i].BillNo + "','" + Util.GetInt(dataItem[i].ProcessID) + "','0','" + Util.GetDateTime(dataItem[i].TargetDate).ToString("yyyy-MM-dd HH:mm:ss") + "','" + Util.GetDateTime(dataItem[i].ExpectedDate).ToString("yyyy-MM-dd hh:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetInt(dataItem[i].IsTPAQuery) + "','" + dataItem[i].UserRemark + "')";
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                                result = "1";
                            }
                            else
                            {
                                str = "Insert into recovery_action_detail(TPAInvNo,TransactionID,BillNo,ProcessID,QueryID,TargetDate,ExpectedDate,CreatedBy,IsTPAQuery,UserRemark) values ('" + dataItem[i].TPAInvNo + "','ISHHI" + dataItem[i].IPNo + "','" + dataItem[i].BillNo + "','0','" + Util.GetInt(dataItem[i].QueryID) + "','" + Util.GetDateTime(dataItem[i].TargetDate).ToString("yyyy-MM-dd HH:mm:ss") + "','" + Util.GetDateTime(dataItem[i].ExpectedDate).ToString("yyyy-MM-dd hh:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetInt(dataItem[i].IsTPAQuery) + "','" + dataItem[i].UserRemark + "')";
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                                //str = "UPDATE recovery_action_detail set IsReject=1 " +
                                //"Where TPAInvNo='" + dataItem[i].TPAInvNo + "' AND TransactionID='ISHHI" + dataItem[i].IPNo + "' AND IsTPAQuery=0";
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                                result = "1";
                            }                                                                          
                    }

                      
                tnx.Commit();
                return result;                           
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
    
      [WebMethod(EnableSession = true)]
    public string SaveQueryRemark(object Data)
    {
        string result = "0";
        List<RecoveryAction> dataItem = new JavaScriptSerializer().ConvertToType<List<RecoveryAction>>(Data);
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
                        if (dataItem[i].Type == "Res")
                        {
                            str = "UPDATE recovery_action_detail set IsQueryResolved=1,ResolvedRemark='" + dataItem[i].UserRemark + "',ResolvedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ResolvedDate=now() " +
                            "Where TPAInvNo='" + dataItem[i].TPAInvNo + "' AND TransactionID='ISHHI" + dataItem[i].IPNo + "' AND ID='" + dataItem[i].RAID + "' AND IsTPAQuery=1 ";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                            result = "1";
                        }
                        else if (dataItem[i].Type == "Pen")
                        {
                            str = "UPDATE recovery_action_detail set UserRemark='" + dataItem[i].UserRemark + "',ExpectedDate='" + Util.GetDateTime(dataItem[i].ExpectedDate).ToString("yyyy-MM-dd HH:mm:ss") + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now() " +
                                  "Where TPAInvNo='" + dataItem[i].TPAInvNo + "' AND TransactionID='ISHHI" + dataItem[i].IPNo + "' AND ID='" + dataItem[i].RAID + "' AND IsTPAQuery=1 ";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                            result = "1";
                        }                                                                  
                    }

                      
                tnx.Commit();
                return result;                           
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

