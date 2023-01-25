<%@ WebService Language="C#" Class="Payment_Confirmation" %>

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
public class Payment_Confirmation  : System.Web.Services.WebService {
   

    [WebMethod]
    public string SearchPaymentProcessRecoveryBill(string InvoiceNo, string IPNo, string PanelGroup, string PanelID, string DispatchDate, string DocketNo, string FromDate, string ToDate, string chkDisp)
    {
        string result = "0";

        StringBuilder Query = new StringBuilder();
        Query.Append("  SELECT REPLACE(tid.PatientID,'LSHHI','') AS MRNo,REPLACE(tid.TransactionID,'ISHHI','') AS IPNo, ");
        Query.Append("  tid.PName,tid.TPA AS Panel,tid.BillNo,tid.BillAmt,tid.TPAInvNo,DATE_FORMAT(tid.TPAInvoiceDate,'%d-%b-%Y')TPAInvoiceDate,rad.UserRemark ");
        Query.Append("  FROM tpa_invoice_detail tid  ");
        Query.Append("  INNER JOIN f_ipdadjustment adj ON tid.TransactionID=adj.TransactionID  ");
        Query.Append("  INNER JOIN recovery_action_detail rad ON tid.TPAInvNo=rad.TPAInvNo AND tid.TransactionID=rad.TransactionID ");
        Query.Append("  INNER JOIN process_master prm ON rad.ProcessID=prm.ProcessID ");
        Query.Append("  WHERE adj.IsTPAInvActive=1 AND rad.ProcessID=55 ");        
        
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
        if (InvoiceNo == "" && IPNo == "" && DocketNo == "")
        {
            if (chkDisp == "1")
            {
                Query.Append("And  STR_TO_DATE(tid.DispatchDate, '%d-%b-%Y')='" + Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd") + "'");
            }
            else if (chkDisp == "0")
            {
                if (PanelID != "")
                {
                    Query.Append("AND tid.PanelID=" + PanelID + " ");
                }

                Query.Append("And tid.TPAInvoiceDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND tid.TPAInvoiceDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
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

    [WebMethod(EnableSession = true)]
    public string SavePaymentDetail(object Data)
    {
        string result = "0";
        List<PaymentConfirmation> dataItem = new JavaScriptSerializer().ConvertToType<List<PaymentConfirmation>>(Data);
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
                    if (dataItem[i].Type == "Close")
                    {
                        str = "UPDATE f_ipdadjustment set IsTPAInvClosed=1,TPAInvPaymentRemark ='" + dataItem[i].PaymentRemark + "',TPAInvClosedBy='" + HttpContext.Current.Session["ID"].ToString() + "',TPAInvClosedDate=now(),TPAInvChequeDate='" + Util.GetDateTime(dataItem[i].ChequeDate).ToString("yyyy-MM-dd HH:mm:ss") + "',TPAInvChequeReceiveDate='" + Util.GetDateTime(dataItem[i].ChequeReceiveDate).ToString("yyyy-MM-dd HH:mm:ss") + "',TPAInvChequeAmount='" + dataItem[i].ChequeAmount  + "' " +
                        "Where TPAInvNo='" + dataItem[i].TPAInvNo + "' AND TransactionID='ISHHI" + dataItem[i].IPNo + "' ";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                        result = "1";
                    }
                    else if (dataItem[i].Type == "Deduction")
                    {
                        str = "UPDATE f_ipdadjustment set IsTPAInvClosed=2,TPAInvPaymentRemark ='" + dataItem[i].PaymentRemark + "',TPAInvClosedBy='" + HttpContext.Current.Session["ID"].ToString() + "',TPAInvClosedDate=now(),TPAInvChequeDate='" + Util.GetDateTime(dataItem[i].ChequeDate).ToString("yyyy-MM-dd HH:mm:ss") + "',TPAInvChequeReceiveDate='" + Util.GetDateTime(dataItem[i].ChequeReceiveDate).ToString("yyyy-MM-dd HH:mm:ss") + "',TPAInvChequeAmount='" + dataItem[i].ChequeAmount + "' " +
                        "Where TPAInvNo='" + dataItem[i].TPAInvNo + "' AND TransactionID='ISHHI" + dataItem[i].IPNo + "' ";
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

