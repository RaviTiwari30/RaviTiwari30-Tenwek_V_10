<%@ WebService Language="C#" Class="PanelAdvance" %>
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
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class PanelAdvance : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPaymentDetail(string PanelID, string SearchType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT (pl.`LedgerReceivedAmt`-pl.`AdjustmentAmount`)AdvanceAmt,pl.`AdjustmentAmount`,pnl.`Company_Name`, pl.`LedgerReceiptNo` ,pl.`PaymentMode`,pl.`LedgerReceivedAmt`,IF(pl.`PaymentModeID`<>1,CONCAT('BankName:',pl.`BankName`,' ,Ref. No.:',pl.`ReferenceNo`),'')BankDetails,DATE_FORMAT(pl.`EntryDate`,'%d-%b-%y')EntryDate,DATE_FORMAT(pl.`AdvanceAmtRecievedDate`,'%d-%b-%y')AdvanceAmtRecievedDate ,pl.`EntryUserName`,if(pl.`PaymentModeID`=2,IF(pl.`IsClear`=1,'Yes','No'),'')IsClear,if(pl.`PaymentModeID`=2,IF(pl.`IsChequeBounce`=1,'Yes','No'),'')IsChequeBounce,pl.`IsCancel` FROM `panel_ledgeraccount` pl INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pl.`PanelID` WHERE pl.PanelID=" + PanelID + " ");
        if (SearchType == "1")
            sb.Append(" and  pl.`IsCancel`=0 ");
        if (SearchType == "2")
            sb.Append(" and  pl.`IsCancel`=0 and pl.`IsClear`=0 and pl.`PaymentModeID`=2 ");
        if (SearchType == "3")
            sb.Append(" and  pl.`IsCancel`=0 and  pl.`IsChequeBounce`=1 and pl.`PaymentModeID`=2 ");
        if (SearchType == "4")
            sb.Append(" and  pl.`IsCancel`=1 ");

        if (SearchType == "5")
            sb.Append(" and  pl.`IsCancel`=0 and if(pl.`PaymentModeID`=2,pl.`IsClear`=1,pl.`IsClear` in (0,1)) and pl.`IsChequeBounce`=0 and (pl.`LedgerReceivedAmt`-pl.`AdjustmentAmount`)>0 ");
        
        sb.Append(" order by pl.ID DESC ");
        string rtrn = "";

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveAdvance(string RecievedDate, string PanelID, decimal totalPaidAmount, string paymentRemarks, object paymentDetail)
    {

        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(paymentDetail);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string LedgerReceiptNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_panelLedgerReceipt_No('Panel Ledger Receipt No.') "));
            PanelLedgerAccount PLA = new PanelLedgerAccount(tnx);

            if (dataPaymentDetail.Count > 0 && dataPaymentDetail != null)
            {

                foreach (var payment in dataPaymentDetail)
                {
                    PLA.LedgerReceiptNo = LedgerReceiptNo;
                    PLA.LedgerReceivedAmt = Util.GetDecimal(payment.Amount);
                    PLA.LedgerNoCr = Resources.Resource.PanelLedgerNoCr;
                    PLA.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    PLA.PanelID = PanelID;
                    PLA.TYPE = "CREDIT";
                    PLA.PaymentMode = payment.PaymentMode;
                    PLA.PaymentModeID = payment.PaymentModeID;
                    PLA.Remarks = paymentRemarks;
                    PLA.AdvanceAmtRecievedDate = Util.GetDateTime(RecievedDate);
                    PLA.TnxType = "Panel-Advance";
                    PLA.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
                    PLA.EntryBy = HttpContext.Current.Session["ID"].ToString();
                    PLA.EntryUserName = HttpContext.Current.Session["EmployeeName"].ToString();
                    PLA.S_Amount = payment.S_Amount;
                    PLA.S_Currency = payment.S_Currency;
                    PLA.S_CountryID = payment.S_CountryID;
                    PLA.BankName = payment.BankName;
                    PLA.ReferenceNo = payment.RefNo;
                    PLA.C_factor = payment.C_Factor;
                    PLA.S_Notation = payment.S_Notation;
                    PLA.Currency_RoundOff = payment.currencyRoundOff;
                    PLA.ReferenceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    PLA.IsClear = 0;
                    PLA.ClearUserID = HttpContext.Current.Session["ID"].ToString();
                    PLA.ClearUserName = HttpContext.Current.Session["EmployeeName"].ToString();
                    PLA.ClearDateTime = Util.GetDateTime(DateTime.Now);
                    
                    string ID = PLA.Insert().ToString();
                    if (ID == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });
                    }
                    
                }
            }

            
                
          //Devendra Singh 2018-12-07 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertPanelAdvanceCollection(LedgerReceiptNo,"A",tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }
            
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });

        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public decimal GetPanelAdvanceAmt(string PanelID)
    {
        string PanelAdvanceAmt = StockReports.ExecuteScalar(" SELECT SUM((pla.`LedgerReceivedAmt`-pla.`AdjustmentAmount`))AdvanceAmt FROM panel_ledgeraccount pla WHERE pla.`IsCancel`=0 AND pla.`LedgerReceivedAmt`>pla.`AdjustmentAmount` AND IF(pla.`PaymentModeID`=2,pla.`IsClear`=1,pla.`IsClear` IN(0,1)) AND pla.`PanelID`=" + PanelID + " ");
        if (!string.IsNullOrEmpty(PanelAdvanceAmt))
            return Util.GetDecimal(PanelAdvanceAmt);
        else
            return 0;

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateLedgerReceipt(string LedgerReceiptNo, string TypeForUpdate)
    {
        string Msg = "";
        PanelLedgerAccount PLA = new PanelLedgerAccount();
        if (TypeForUpdate == "Clear")
        {

            Msg = "Cheque Cleared Successfully";
        }
        if (TypeForUpdate == "ChequeBounce")
        {


            Msg = "Cheque status updated Successfully";
        }

        if (TypeForUpdate == "CancelReceipt")
        {

            Msg = "Receipt Cancelled Successfully";
        }
        
        PLA.IsClear = 1;
        PLA.ClearUserID = HttpContext.Current.Session["ID"].ToString();
        PLA.ClearUserName = HttpContext.Current.Session["EmployeeName"].ToString();
        PLA.ClearDateTime = Util.GetDateTime(DateTime.Now);
        PLA.IsChequeBounce = 1;
        PLA.ChequeBounceUserID = HttpContext.Current.Session["ID"].ToString();
        PLA.ChequeBounceUserName = HttpContext.Current.Session["EmployeeName"].ToString();
        PLA.ChequeBounceDateTime = Util.GetDateTime(DateTime.Now);
        PLA.IsCancel = 1;
        PLA.CancelUserID = HttpContext.Current.Session["ID"].ToString();
        PLA.CancelUserName = HttpContext.Current.Session["EmployeeName"].ToString();
        PLA.CancelDateTime = Util.GetDateTime(DateTime.Now);
        PLA.UpdateType = TypeForUpdate;
        PLA.UpdateDate = Util.GetDateTime(DateTime.Now);
        PLA.UpdateUserID = HttpContext.Current.Session["ID"].ToString();
        PLA.UpdateUserName = HttpContext.Current.Session["EmployeeName"].ToString();
        PLA.LedgerReceiptNo = LedgerReceiptNo;
        string ID = PLA.Update().ToString();
        if (ID == "1")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Msg });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Update" });

    }

}