using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_EDP_UtilityMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindCategoryCheck();
        }
        ucFromDate.Attributes.Add("readOnly", "readOnly");
        ucToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string BindCategory(string Type)
    {
        string str = "";
        str = "Select cm.Name,cm.CategoryID from f_categorymaster cm inner join f_configrelation cf on cm.categoryid = cf.categoryid where cf.ConfigID in ";
        if (Type == "0")
            str = str + "(3,7,25,23,20)";
        else
            str = str + "(2,3,6,7,8,9,10,20,14,15,24,25,27,29)";
        str = str + " AND isActive=1 group by cm.CategoryID order by cm.Name";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string bindData(string Category, string Panel, string FromDate, string ToDate, string Type, string BillNo, string ReceiptNo, string IPDNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Type == "0")
            {
                if (ReceiptNo != "")
                {
                    sb.Append("Set group_concat_max_len=1024*4*1024*8; SELECT NAME,Round(SUM(GAmount))GrossAmount,Round(SUM(Amount))NetAmt,Round(SUM(PaidAmount))PaidAmt,GROUP_CONCAT(DISTINCT '''',LedgerTnxID,'''')LedgerTnxID,GROUP_CONCAT(DISTINCT '''',LedgerTransactionNo,'''')LedgerTransactionNo,COUNT(LedgerTnxID)CountLedgerTnxID,COUNT(DISTINCT LedgerTransactionNo)CountLedgerTransactionNo FROM ");
                    sb.Append("(SELECT ");
                    sb.Append("((ltd.Amount *rec_pay.s_Amount)/lt.netamount)PaidAmount,(ltd.Rate*ltd.Quantity)GAmount,ltd.DiscAmt,ltd.DiscountPercentage,ltd.Amount, ");
                    sb.Append("rec.ReceiptNo,TypeOfTnx,ltd.ItemName,cm.Name,lt.DiscountOnTotal,ltd.LedgerTnxID,lt.LedgerTransactionNo ");
                    sb.Append("FROM f_reciept Rec  ");
                    sb.Append("INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo   ");
                    sb.Append("INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo ");
                    sb.Append("INNER JOIN  f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo= lt.LedgerTransactionNo ");
                    sb.Append("INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID  ");
                    sb.Append("INNER JOIN f_categorymaster cm ON cm.CategoryID = scm.CategoryID ");
                    sb.Append("WHERE rec_pay.PaymentModeID<>4  AND rec.Iscancel=0 AND lt.IsCancel=0 AND LT.Adjustment=Lt.NetAmount And Ltd.DiscAmt='0.00' And ltd.DiscountPercentage='0.00' And lt.DiscountOnTotal='0.00' ");
                    sb.Append("AND cm.CategoryID IN(" + Category + ") AND lt.PaymentModeID<>4 AND LTD.IsPackage=0 And lt.PanelID=" + Panel.Split('#')[0] + " ");
                    if (BillNo != "")
                        sb.Append(" AND lt.BillNo = '" + BillNo + "' ");
                    else if (ReceiptNo != "")
                        sb.Append(" AND rec.ReceiptNo='" + ReceiptNo + "' ");
                    else
                        sb.Append("AND rec.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND rec.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("ORDER BY rec.date)t");
                }
            }
            else
            {
                sb.Append("Set group_concat_max_len=1024*4*1024*8; SELECT GROUP_CONCAT('''',TransactionID,'''') AS LedgerTransactionNo,SUM(GrossAmount)GrossAmount,SUM(BillDisc)BillDisc,SUM(NetAmt)NetAmt,SUM(AmtPaid)PaidAmt FROM  ");
                sb.Append("(SELECT adj.TransactionID, ");
                sb.Append("ROUND(SUM(ltd.Rate*ltd.Quantity)+IFNULL(ServiceTaxAmt,0)+IFNULL(adj.RoundOff,0)-(SUM(((Rate*Quantity)*DiscountPercentage)/100)+IFNULL(DiscountOnBill,0)))GrossAmount,  ");
                sb.Append("(IFNULL(DiscountOnBill,0)+SUM(ltd.DiscAmt))BillDisc, ");
                sb.Append("ROUND((IFNULL(SUM(ltd.Rate*ltd.Quantity),0)+IFNULL(ServiceTaxAmt,0)+IFNULL(adj.RoundOff,0))-(SUM(((Rate*Quantity)*DiscountPercentage)/100)+IFNULL(DiscountOnBill,0)))NetAmt,  ");
                sb.Append("IFNULL((SELECT ROUND(SUM(AmountPaid)) FROM f_reciept WHERE TransactionID=adj.TransactionID  AND isCancel=0 ");
                //  sb.Append("AND DATE(DATE)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(DATE)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
                sb.Append("),0)AmtPaid ");
                sb.Append("FROM f_ipdadjustment adj  INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=adj.TransactionID  ");
                sb.Append("WHERE PanelID= " + Panel.Split('#')[0] + " AND IsVerified = 1 AND IsPackage = 0  ");
                if (IPDNo != "")
                    sb.Append(" AND adj.TransactionID ='ISHHI" + IPDNo + "'");
                else
                    sb.Append("AND DATE(BillDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(BillDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
                sb.Append(" AND adj.BillNo IS NOT NULL GROUP BY ltd.TransactionID Having NetAmt=AmtPaid )t ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0 && dt != null)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch { return ""; }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateDisc(string DiscPer, string LedgerTnxID, string LedgerTransactionNo, string CountLedgerTnxID, string CountLedgerTransactionNo, string Pre_GrossAmt, string Pre_NetAmt, string Pre_Adjustment, string DiscAmt, string NewNetAmt, string Type)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
      
            if (Type == "0")
            {
                if (Util.GetInt(CountLedgerTnxID) > 0)
                {
                    string LTDBackup = "INSERT INTO f_ledgertnxdetail_BulkDisc (SELECT * FROM f_ledgertnxdetail WHERE LedgertnxID IN (" + LedgerTnxID + "))";
                    int ResultLTDBac = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, LTDBackup);
                    if (ResultLTDBac == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    string LTBackup = "INSERT INTO f_ledgertransaction_BulkDisc (SELECT * FROM f_ledgertransaction WHERE LedgerTransactionNO IN (" + LedgerTransactionNo + "))";
                    int ResultLTBac = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, LTBackup);
                    if (ResultLTBac == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    string RecBackup = "INSERT INTO f_reciept_BulkDisc (SELECT * FROM f_reciept WHERE AsainstLedgerTnxNo IN (" + LedgerTransactionNo + "))";
                    int ResulRecBac = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, RecBackup);
                    if (ResultLTBac == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    string LTDStr = " UPDATE f_ledgertnxdetail ltd SET " +
                                " ltd.DiscountPercentage=DiscountPercentage +'" + DiscPer + "',ltd.DiscAmt=DiscAmt+(((ltd.Rate*ltd.Quantity)*'" + DiscPer + "')/100),ltd.Amount =(ltd.Rate*ltd.Quantity)-ltd.DiscAmt,DiscountReason='Poor Patient' " +
                                " where ltd.LedgerTnxID IN (" + LedgerTnxID + ") ";
                    int ResultLTD = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, LTDStr);
                    if (ResultLTD == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    int ResultLT = MySqlHelperNEw.ExecuteNonQuery(tranX, CommandType.Text, "CALL UpdateBulkDisc_Utility(" + LedgerTransactionNo + ")");
                    if (ResultLT == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    string ReceiptNo = StockReports.ExecuteScalar("Set group_concat_max_len=1024*4*1024*8; Select GROUP_CONCAT(QUOTE(ReceiptNo)) from f_reciept  WHERE AsainstLedgerTnxNo IN (" + LedgerTransactionNo + ")");
                    int ResultRec = MySqlHelperNEw.ExecuteNonQuery(tranX, CommandType.Text, "CALL UpdateBulkDiscRec_Utility(" + LedgerTransactionNo + "," + ReceiptNo + ")");
                    if (ResultRec == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    string BulkStr = " insert into f_BulkDiscount (LedgerTransactionNo,Pre_GrossAmt,Pre_NetAmt,Pre_Adjustment,DiscountPer,DiscAmt,NewNetAmt,DiscGivenBy,Type) " +
                        " values('" + LedgerTransactionNo.Replace("'", "") + "','" + Pre_GrossAmt + "','" + Pre_NetAmt + "','" + Pre_Adjustment + "','" + DiscPer + "','" + DiscAmt + "','" + NewNetAmt + "','" + HttpContext.Current.Session["ID"].ToString() + "','OPD') ";
                    int ResultBulk = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, BulkStr);
                    if (ResultBulk == 0)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                }
            }
            else
            {
                string TransactionID = LedgerTransactionNo;
                string AdjBackup = "INSERT INTO f_ipdadjustment_BulkDisc (SELECT * FROM f_ipdadjustment WHERE TransactionID IN (" + TransactionID + "))";
                int ResultAdjBac = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, AdjBackup);
                if (ResultAdjBac == 0)
                {
                    tranX.Rollback();
                    tranX.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                string RecIPDBackup = "INSERT INTO f_reciept_BulkDisc (SELECT * FROM f_reciept WHERE TransactionID IN (" + TransactionID + "))";
                int ResulRecIPDBac = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, RecIPDBackup);
                if (ResulRecIPDBac == 0)
                {
                    tranX.Rollback();
                    tranX.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                string AdjStr = "UPDATE f_ipdadjustment SET DiscountOnBill =Round(IFNULL(DiscountOnBill,0)+((TotalBilledAmt*'" + DiscPer + "')/100)), " +
                                " TotalBillDiscPer='" + DiscPer + "' WHERE TransactionID IN (" + TransactionID + ") ";
                int ResultAdj = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, AdjStr);
                if (ResultAdj == 0)
                {
                    tranX.Rollback();
                    tranX.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                string RecIPDStr = "UPDATE f_reciept rec  " +
                                  "SET rec.AmountPaid = Round(AmountPaid - ((AmountPaid*'" + DiscPer + "')/100)) " +
                                  "WHERE rec.TransactionID IN (" + TransactionID + ") ";
                int ResultIPDRec = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, RecIPDStr);
                if (ResultIPDRec == 0)
                {
                    tranX.Rollback();
                    tranX.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                string ReceiptNo = StockReports.ExecuteScalar("Set group_concat_max_len=1024*4*1024*8; Select GROUP_CONCAT(QUOTE(ReceiptNo)) from f_reciept  WHERE TransactionID IN (" + TransactionID + ")");
                string RecIPDPayDetail = "UPDATE f_receipt_paymentdetail rec_paydet  " +
                                    "SET rec_paydet.S_Amount=Round(S_Amount - ((S_Amount*'" + DiscPer + "')/100)),rec_paydet.Amount=Round(Amount - ((Amount*'" + DiscPer + "')/100)) " +
                                    "WHERE rec_paydet.ReceiptNo IN (" + ReceiptNo + ") ";
                int ResultIPDPayDetail = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, RecIPDPayDetail);
                if (ResultIPDPayDetail == 0)
                {
                    tranX.Rollback();
                    tranX.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                string BulkStr = " insert into f_BulkDiscount (TransactionID,Pre_GrossAmt,Pre_NetAmt,Pre_Adjustment,DiscountPer,DiscAmt,NewNetAmt,DiscGivenBy,Type) " +
                   " values('" + TransactionID.Replace("'", "") + "','" + Pre_GrossAmt + "','" + Pre_NetAmt + "','" + Pre_Adjustment + "','" + DiscPer + "','" + DiscAmt + "','" + NewNetAmt + "','" + HttpContext.Current.Session["ID"].ToString() + "','IPD') ";
                int ResultBulk = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, BulkStr);
                if (ResultBulk == 0)
                {
                    tranX.Rollback();
                    tranX.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void BindCategoryCheck()
    {
        string str = "";
        str = "Select cm.Name,QUOTE(cm.CategoryID)CategoryID from f_categorymaster cm inner join f_configrelation cf on cm.categoryid = cf.categoryid where cf.ConfigID in ";
        if (rdoOPDIPDList.SelectedIndex == 0)
            str = str + "(3,7,25,23,20,5)";
        else
            str = str + "(2,3,6,7,8,9,10,20,14,15,24,25,27,29,1)";
        str = str + " AND isActive=1 group by cm.CategoryID order by cm.Name";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            chkCategory.DataSource = dt;
            chkCategory.DataTextField = "Name";
            chkCategory.DataValueField = "CategoryID";
            chkCategory.DataBind();
        }
    }

    protected void rdoOPDIPDList_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindCategoryCheck();
    }
}