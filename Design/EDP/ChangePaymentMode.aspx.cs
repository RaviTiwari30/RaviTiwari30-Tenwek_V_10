using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_ChangePaymentMode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            All_LoadData.BindBank(ddlBankName);

        }
    }
    
    
    [WebMethod]
    public static string PaymentSearch(string ReceiptNo)
    {
        DataTable dt = StockReports.GetDataTable("Select rec_pay.ID ReceiptID,rec.ReceiptNo,rec.AsainstLedgerTnxNo,rec.AmountPaid,rec_pay.PaymentModeID,rec_pay.PaymentMode,rec_pay.S_Amount,rec_pay.BankName,rec_pay.RefNo,concat(DATE_FORMAT(rec.Date,'%d-%b-%Y'),' ',DATE_FORMAT(rec.Time,'%h:%i %p'))RecDateTime,Rec.LedgerNoDr FROM f_reciept Rec " +
            " INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo WHERE rec.ReceiptNo='" + ReceiptNo.Trim() + "' AND rec.IsCancel=0");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }
    [WebMethod]
    public static string bindPaymentMode(int PaymentModeID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT PaymentModeID,PaymentMode FROM paymentmode_master WHERE Active=1 AND PaymentModeID NOT IN (4," + PaymentModeID + ")"));
    }
    [WebMethod(EnableSession = true)]
    public static string SavePaymentMode(int ReceiptID, string ReceiptNo, int newPaymentModeID, string newPaymentMode, string newBankName, string newRefNo, int oldPaymentModeID, string oldPaymentMode, string oldBankName, string oldRefNo, string LedgerTransactionNo, string LedgerNoDr,decimal Amount)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_receipt_paymentModeChange(ReceiptID,ReceiptNo,newPaymentModeID,newPaymentMode,newBankName,newRefNo,oldPaymentModeID,oldPaymentMode,oldBankName,oldRefNo,LedgerTransactionNo,S_Amount,CreatedBy) " +
                " VALUES('" + ReceiptID + "','" + ReceiptNo + "','" + newPaymentModeID + "','" + newPaymentMode + "','" + newBankName + "','" + newRefNo + "','" + oldPaymentModeID + "','" + oldPaymentMode + "','" + oldBankName + "','" + oldRefNo + "','" + LedgerTransactionNo + "','"+Util.GetDecimal(Amount)+"','" + HttpContext.Current.Session["ID"].ToString() + "')");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_receipt_paymentdetail SET PaymentModeID=" + newPaymentModeID + " ,PaymentMode='" + newPaymentMode + "',BankName='" + newBankName + "',RefNo='" + newRefNo + "' WHERE ID=" + ReceiptID + "  ");
            if (LedgerNoDr != "HOSP0005")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction SET PaymentModeID=" + newPaymentModeID + " WHERE LedgerTransactionNo='" + LedgerTransactionNo + "' AND PaymentModeID=" + oldPaymentModeID + " ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction_paymentdetail SET PaymentModeID=" + newPaymentModeID + " WHERE LedgerTransactionNo='" + LedgerTransactionNo + "' AND PaymentModeID=" + oldPaymentModeID + " ");


            }
            tnx.Commit();
            return "1";

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}