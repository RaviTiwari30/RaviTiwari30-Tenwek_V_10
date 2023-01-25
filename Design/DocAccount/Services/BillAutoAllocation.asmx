<%@ WebService Language="C#" Class="BillAutoAllocation" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Linq;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class BillAutoAllocation : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    private static DataTable GetItemWiseDetails(string transactionID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sqlCMD = new StringBuilder();

        sqlCMD.Append("SELECT transactionID,ledgerTnxID,itemName,itemID,SUM(quantity)quantity,SUM(amount)amount,SUM(doctorShareAmount)doctorShareAmount ");
        sqlCMD.Append("FROM  ");
        sqlCMD.Append("(SELECT ltd.TransactionID transactionID, ltd.ID ledgerTnxID ,IF((c.ConfigID=1),CONCAT(ltd.ItemName,'(',sc.Name,')'),ltd.ItemName)itemName,ltd.ItemID,SUM(ltd.Quantity) quantity,SUM(ltd.Amount)amount,  ");
        sqlCMD.Append("IFNULL(SUM(s.DoctorShareAmt + ");
        sqlCMD.Append("IFNULL(((SELECT SUM(dst.DoctorShareAmt) FROM f_DocShare_TransactionDetail dst  ");
        sqlCMD.Append("INNER JOIN f_ledgertnxdetail ltdt ON ltdt.ID=dst.LedgerTnxID WHERE ltdt.TypeOfTnx IN ('CR','DR') ");
        sqlCMD.Append("AND dst.DoctorShareAmt<>0 AND ltdt.LedgerTnxRefID<>-1 ");
        sqlCMD.Append("AND ltdt.LedgerTnxRefID=ltd.ID)),0) ");
        sqlCMD.Append("),0)doctorShareAmount ");
        sqlCMD.Append("FROM  f_DocShare_TransactionDetail s   ");
        sqlCMD.Append("INNER JOIN  f_ledgertnxdetail ltd ON ltd.ID=s.LedgerTnxID  ");
        sqlCMD.Append("INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID  ");
        sqlCMD.Append("INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID  ");
        sqlCMD.Append("WHERE s.TransactionID=@transactionID  ");
        sqlCMD.Append("AND ltd.TypeOfTnx NOT IN ('CR','DR') AND s.ShareCalculatedOn<>1  ");
        sqlCMD.Append("AND s.IsActive=1 AND s.DoctorShareAmt <> 0 GROUP BY ltd.ID ");
        sqlCMD.Append(")t WHERE t.doctorShareAmount>0 GROUP BY t.ledgerTnxID ");

        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID,
        });
        return dt;
    }
    [WebMethod(EnableSession=true)]
    public string AutoAllocation(List<string> transactionIDs)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int n = 0; n < transactionIDs.Count; n++)
            {
                string transactionID = transactionIDs[n];
                DataTable dt = GetItemWiseDetails(transactionID);
                if (dt.Rows.Count > 0)
                {
                    for (int j = 0; j < dt.Rows.Count; j++)
                    {
                        string str = "SELECT COUNT(*) FROM f_reciept r INNER JOIN f_receipt_paymentdetail pay ON pay.ReceiptNo=r.ReceiptNo WHERE r.TransactionID='" + dt.Rows[j]["transactionID"].ToString() + "' AND r.IsCancel=0 AND pay.PaymentModeID=3";
                        int isBankCut = Util.GetInt(StockReports.ExecuteScalar(str.ToString()));
                        decimal Bankcut = 0;
                        if (isBankCut > 0)
                            Bankcut = Util.GetDecimal(2.3);
                        var sqlCMD = "INSERT INTO f_paymentallocation (IsVerified,VerifiedOn,VerifiedBy,TransactionID, LedgerTnxId, ServiceType, ItemId, SubCategoryId, AllocatedAmt, AgainstReceiptNo, EntryBy,WriteOff, TYPE,BankCut,Hosp_AllocatedAmt,Hosp_WriteOff,Hosp_BankCut,WriteOff_Reason,Hosp_WriteOff_Reason,PaymentModeID)VALUES (1,NOW(),@VerifiedBy,@TransactionID,@ledgerTnxId,@serviceType,@itemId,@subCategoryId,@allocatedAmt,@againstReceiptNo,@entryBy,@doc_writeOff,@type,@bankCut,@hosp_AllocatedAmt,@hosp_WriteOff,@hosp_BankCut,@writeOffReason,@hospWriteOffReason,@paymentModeID)";
                        var data = new
                        {
                            VerifiedBy = HttpContext.Current.Session["ID"].ToString(),
                            TransactionID = dt.Rows[j]["transactionID"].ToString(),
                            ledgerTnxId = dt.Rows[j]["ledgerTnxID"].ToString(),
                            serviceType = 0,
                            itemId = dt.Rows[j]["itemID"].ToString(),
                            subCategoryId = string.Empty,
                            allocatedAmt = dt.Rows[j]["doctorShareAmount"].ToString(),
                            againstReceiptNo = "",
                            entryBy = HttpContext.Current.Session["ID"].ToString(),
                            doc_writeOff = 0,
                            type = "0",
                            bankCut = Bankcut,
                            hosp_AllocatedAmt = 0,
                            hosp_WriteOff = 0,
                            hosp_BankCut = 0,
                            writeOffReason = string.Empty,
                            hospWriteOffReason = string.Empty,
                            paymentModeID = 0,
                        };
                        string aa = excuteCMD.GetRowQuery(sqlCMD.ToString(), data);
                        excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, data);
                    }
                }
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }
        finally {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}