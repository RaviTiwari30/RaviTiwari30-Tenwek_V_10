using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System.Text;
using System.Data.OleDb;

public class EbizFrame
{

    public EbizFrame()
    {
    }

    public static OracleConnection GetOracleCon()
    {


        OracleConnection objCon = new OracleConnection(System.Configuration.ConfigurationManager.AppSettings["OracleConnectionFinance"]);
        return objCon;
    }

    #region GetDataTable
    public static DataTable GetDataTable(string strQuery)
    {
        string myConnString = System.Configuration.ConfigurationManager.AppSettings["OracleConnectionFinance"];
        OracleConnection myConnection = new OracleConnection(myConnString);

        myConnection.Open();
        DataTable dt = new DataTable();

        DataSet dataSet = new DataSet();

        OracleCommand cmd = new OracleCommand(strQuery);

        cmd.CommandType = CommandType.Text;

        cmd.Connection = myConnection;

        using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
        {
            dataAdapter.SelectCommand = cmd;
            dataAdapter.Fill(dataSet);
            dt = dataSet.Tables[0];
        }

        if (myConnection.State == ConnectionState.Open)
            myConnection.Close();
        if (myConnection != null)
        {
            myConnection.Dispose();
            myConnection = null;
        }
        return dt;
    }
    #endregion
    public static string InsertOPDTransaction(int LedgerTransactionNo, string ReceiptNo, string TransType, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = " CALL ess_InsertOPDRevenueANDCollection(" + LedgerTransactionNo + ",'" + ReceiptNo + "','" + TransType + "') ";
        try
        {
           // MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }


    public static string InsertEmergencyTransaction(int LedgerTransactionNo, string ReceiptNo, string TransType,string LedgerTnxID, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = " CALL ess_InsertEmergencyRevenueANDCollection(" + LedgerTransactionNo + ",'" + ReceiptNo + "','" + TransType + "','" + LedgerTnxID + "') ";
        try
        {
         // var res=  MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }






    public static string InsertIPDTransaction(int LedgerTransactionNo, string ReceiptNo, string TransType, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = " CALL ess_InsertIPDRevenueANDCollection(" + LedgerTransactionNo + ",'" + ReceiptNo + "','" + TransType + "') ";
        try
        {
           // MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
    public static string InsertIPDRevenue(string TransactionID,string TransType, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = " CALL ess_InsertIPDRevenue('" + TransactionID + "','" + TransType + "') ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
    public static string InsertIPDTransaction(int LedgerTransactionNo, string ReceiptNo, string TransType)
    {
        string sql = string.Empty;
        sql = " CALL ess_InsertIPDRevenueANDCollection(" + LedgerTransactionNo + ",'" + ReceiptNo + "','" + TransType + "') ";
        try
        {
           // StockReports.ExecuteDML(sql);
            return "1";
        }
        catch (Exception ex)
        {
            return "0";
        }

    }
    //public static string UpdateIPDRevenue(int LedgerTransactionNo, string TransType, MySqlTransaction Trans)
    //{
    //    string sql = string.Empty;
    //    sql = " CALL UpdateIPDRevenue(" + LedgerTransactionNo + ",'" + TransType + "') ";
    //    try
    //    {
    //        MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
    //        return "1";
    //    }
    //    catch (Exception ex)
    //    {
    //        return "0";
    //    }
    //}

    public static string TransferToEss_DebitCreditNote(string TID, string CrDrNoteNum, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = " CALL ess_drcr_note_Transfer('" + TID + "','" + CrDrNoteNum + "') ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public static string InsertBloodBankPurchase(string GRNNo,int IsPurchase, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = "CALL ess_BB_Transfer('"+GRNNo+"',"+IsPurchase+") ";
        try
        {
           // MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public static string InsertIPDFinalBillDisc(string TransactionID, string TransType, MySqlTransaction Tran)
    {
        string sql = string.Empty;
        sql = "CALL ess_InsertIPDFinalBillDisc('" + TransactionID + "','" + TransType + "') ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public static string InsertPanelAdvanceCollection(string ReceiptNo, string TransType, MySqlTransaction Tran)
    {
        string sql = string.Empty;
        sql = "CALL ess_PanelAdvanceCollection('" + ReceiptNo + "','" + TransType + "') ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    public static string InsertBillGenerate(string vTRANS_NO, string vModule, MySqlTransaction Tran)
    {
        string sql = string.Empty;
        sql = "CALL ess_InsertBillGenerate('" + vTRANS_NO + "','" + vModule + "') ";
        try
        {
           // MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    public static decimal GetItemBudget(string centerID, string itemID)
    {

        var dataTable = GetDataTable("select  FN_GET_BUDGET_AMT_HIMS('" + itemID + "'," + centerID + ") from dual");
        return Util.GetDecimal(dataTable.Rows[0][0]);
    }

    public static String InsertPurchaseOrderAdvance(string supplierID, decimal amount, string purchaseOrderNumber, string remark, string currency, decimal currencyFactor, DateTime createdBy, MySqlTransaction Tran)
    {

        string sql = string.Empty;
        sql = "CALL ess_InsertPurchaseOrderAdvance('" + supplierID + "'," + amount + ",'" + purchaseOrderNumber + "','" + remark + "','" + currency + "'," + currencyFactor + ",'" + (createdBy).ToString("yyyy-MM-dd") + "') ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public static string InsertInventoryTransaction(int LedgerTransactionNo, int vIsGRNEntry, int TransactionTypeID, int SalesNo, MySqlTransaction Tran)
    {
        string sql = string.Empty;
        sql = "CALL ess_InsertInventoryTransaction(" + LedgerTransactionNo + "," + vIsGRNEntry + "," + TransactionTypeID + "," + SalesNo + ") ";
        try
        {
           // MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public static string InsertIPDRevenueAtTimeAdmission(string TransactionID, string TransType, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = " CALL ess_InsertIPDRevenueAtTimeAdmission('" + TransactionID + "','" + TransType + "') ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
    public static string InsertDoctorShareOnTestApproval(string PatientType, int PLOID, int IsApproved, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = "CALL ess_InsertDoctorShareOnTestApproval('" + PatientType + "'," + PLOID + "," + IsApproved + ") ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }



    public static string InsertPaymentAllocation(string transactionID,string receiptNo,int paymentModeID, MySqlTransaction Trans)
    {
        string sql = string.Empty;
        sql = "CALL ess_InsertPaymentAllocation('" + transactionID + "','" + receiptNo + "'," + paymentModeID + ")";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
  
 public static string InsertServicePOClose(string POCloseNumber, string vAgainstPO, int TransactionTypeID, MySqlTransaction Tran)
    {
        string sql = string.Empty;
        sql = "CALL ess_InsertServicePOClose('" + POCloseNumber + "','" + vAgainstPO + "'," + TransactionTypeID + ") ";
        try
        {
            //MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

}
