using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
public partial class Design_OPD_PendingAmountApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calEntryDate1.EndDate = System.DateTime.Now;
            CalendarExtender1.EndDate = System.DateTime.Now;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SearchOPDBills(string searchtype, string searchvalue, string fromDate, string toDate, int filterType, int serviceType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT fpm.Company_Name,IF(LT.TypeOfTnx='OPD-BILLING','OPD','PHY')BillType,cm.CentreName,DATE_FORMAT(pmh.BillDate,'%d-%b-%Y')BillDate,pmh.BillNo,fpm.Company_Name,CONCAT(pm.Title,'',pm.PName)PatientName, ");
        sb.Append("pmh.PatientID,IFNULL(lt.EncounterNo,'')EncounterNo, ");
        sb.Append("ROUND(lt.NetAmount,2)NetBillAmount,ROUND(lt.Adjustment,2)PaidAmount, ");
        sb.Append("(lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' ");
        sb.Append("AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa ");
        sb.Append("WHERE pa.TransactionID=pmh.TransactionID),0))PendingAmt, IF(COUNT(ltd.ID)>0,0,1)IsPaymentApproval,lt.LedgerTransactionNo,pmh.TransactionID  ");
        sb.Append("FROM patient_medical_history pmh  ");
        sb.Append("INNER JOIN f_ledgertransaction lt ON lt.TransactionID = pmh.TransactionID AND IFNULL(lt.`AsainstLedgerTnxNo`,'')='' ");
        sb.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo AND ltd.`IsVerified`<>2 AND IF(lt.`PanelID`<>1,ltd.`IsPayable`,1)=" + serviceType + " ");

        if (filterType != 2)
            sb.Append(" AND ltd.IsPaymentApproval=" + filterType + " ");

        sb.Append("INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID = pmh.CentreID ");
        sb.Append("INNER JOIN f_panel_master fpm ON fpm.PanelID = pmh.PanelID ");
        sb.Append("WHERE pmh.TYPE='OPD'  AND (lt.NetAmount-lt.Adjustment)> 0 AND pmh.CentreID = " + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (!string.IsNullOrEmpty(searchvalue) && searchtype != "PName")
            sb.Append(" AND " + searchtype + " = '" + searchvalue.Trim() + "' ");
        else if (!string.IsNullOrEmpty(searchvalue) && searchtype == "PName")
            sb.Append(" AND " + searchtype + " LIKE '%" + searchvalue.Trim() + "%' ");
        sb.Append("AND pmh.BillDate >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pmh.BillDate <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" group by lt.LedgerTransactionNo ");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
        if (dtSearch.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string exportToExcelOPDBills(string searchtype, string searchvalue, string fromDate, string toDate, int filterType, int serviceType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,fpm.Company_Name AS PanelName,DATE_FORMAT(pmh.BillDate,'%d-%b-%Y')BillDate, ");
        sb.Append(" pmh.BillNo,CONCAT(pm.Title,'',pm.PName)PatientName, pmh.PatientID AS UHID, ");
        sb.Append(" IFNULL(lt.EncounterNo,'')EncounterNo, ROUND(lt.NetAmount,2) BillAmount,ROUND(lt.Adjustment,2)PaidAmount, ");
        sb.Append(" (lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid)  ");
        sb.Append(" FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount)  ");
        sb.Append(" FROM panel_amountallocation pa WHERE pa.TransactionID=pmh.TransactionID),0))PendingAmt,  ");
        sb.Append(" ltd.ItemName, ltd.`Amount` AS ItemAmount, IF(IFNULL(ltd.IsPaymentApproval,0)=0,'Not Aproved','Approved')IsPaymentApproval, ");
        sb.Append(" IFNULL(CONCAT(em.`Title`,' ',em.`NAME`),'') AS PaymentApprovedBy,  ");
        sb.Append(" IF(ltd.`IsPaymentApproval`=1,DATE_FORMAT(ltd.`PaymentApprovedDate`,'%d-%b-%Y %I:%i %p'),'') AS PaymentApprovedDateTime  ");
        sb.Append("FROM patient_medical_history pmh  ");
        sb.Append("INNER JOIN f_ledgertransaction lt ON lt.TransactionID = pmh.TransactionID AND IFNULL(lt.`AsainstLedgerTnxNo`,'')='' ");
        sb.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo AND ltd.`IsVerified`<>2 AND IF(lt.`PanelID`<>1,ltd.`IsPayable`,1)=" + serviceType + "  ");

        if (filterType != 2)
            sb.Append(" AND ltd.IsPaymentApproval=" + filterType + " ");

        sb.Append(" LEFT JOIN employee_master em ON em.`EmployeeID`=ltd.`PaymentApprovedBy` ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID = pmh.CentreID ");
        sb.Append("INNER JOIN f_panel_master fpm ON fpm.PanelID = pmh.PanelID ");
        sb.Append("WHERE pmh.TYPE='OPD'  AND (lt.NetAmount-lt.Adjustment)> 0 AND pmh.CentreID = " + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (!string.IsNullOrEmpty(searchvalue) && searchtype != "PName")
            sb.Append(" AND " + searchtype + " = '" + searchvalue.Trim() + "' ");
        else if (!string.IsNullOrEmpty(searchvalue) && searchtype == "PName")
            sb.Append(" AND " + searchtype + " LIKE '%" + searchvalue.Trim() + "%' ");
        sb.Append("AND pmh.BillDate >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pmh.BillDate <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" Order by lt.LedgerTransactionNo ");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
        if (dtSearch.Rows.Count > 0)
        {
            //HttpContext.Current.Session["dtExport2Excel"] = dtSearch;
            //HttpContext.Current.Session["Period"] = "Period From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
            //HttpContext.Current.Session["ReportName"] = filterTypeName+" Amount Approval Report";

            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dtSearch);
            
            return "1";
        }
        else
            return "";
    }


    [WebMethod(EnableSession = true)]
    public static string UpdatePaymentApproval(string LedgerTransactionNo)
    {
        if (string.IsNullOrEmpty(LedgerTransactionNo))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error In LardgerTransactionNo.", message = "Error In LardgerTransactionNo." });
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string str = "UPDATE f_ledgertransaction lt SET lt.IsPaymentApproval=1, lt.PaymentApprovedBy=@vPaymentApprovedBy,lt.PaymentApprovedDate=NOW() WHERE lt.LedgertransactionNo=@vLedgertransactionNo ";
            int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
            new MySqlParameter("@vPaymentApprovedBy", HttpContext.Current.Session["ID"].ToString()),
            new MySqlParameter("@vLedgertransactionNo", LedgerTransactionNo));
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Payment Approved Successfully.", message = "Payment Approved Successfully." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }




    [WebMethod(EnableSession = true)]
    public static string GetItemToApproved(string LedgerTransactionNo, int filterType, int serviceType)
    {
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            int CanApprovePendingAmount = 0;

            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"]), Util.GetString(HttpContext.Current.Session["ID"]));
            if (dtAuthority.Rows.Count > 0)
            {
                if (Util.GetInt(dtAuthority.Rows[0]["CanApprovePendingAmount"]) == 1)
                {
                    CanApprovePendingAmount = 1;
                }

            }

            sb.Append(" SELECT  ifnull(ltd.PaymentApprovalRemark,'')PaymentApprovalRemark,IF(IF(lt.`PanelID`<>1,ltd.`IsPayable`,1)=1,'Paid Service','Panel Service') as ServiceType, lt.LedgerTransactionNo,IF(LT.TypeOfTnx='OPD-BILLING','OPD','PHY')BillType,IFNULL(ltd.IsPayable,0)IsPayable, IF(IFNULL(ltd.IsPaymentApproval,0)=0,'Not Aproved','Approved')IsPaymentApproval," + CanApprovePendingAmount + " CanApprovePendingAmount,ltd.IsPaymentApproval Status,ltd.ItemName, ");
            sb.Append(" ltd.ItemID,ltd.ID,ltd.LedgerTnxID,ltd.LedgerTransactionNo ");
            sb.Append(" ,IFNULL(CONCAT(em.`Title`,' ',em.`NAME`),'') AS PaymentApprovedBy, IF(ltd.`IsPaymentApproval`=1,DATE_FORMAT(ltd.`PaymentApprovedDate`,'%d-%b-%Y %I:%i %p'),'') AS PaymentApprovedDateTime,ltd.`Amount`, ");

            sb.Append("  IF(lt.`PanelID`<>1,(lt.`NetAmount`-(SELECT SUM(pa.`Amount`) FROM panel_amountallocation pa WHERE pa.`PanelID`=lt.`PanelID` AND pa.`TransactionID`=lt.`TransactionID`)),lt.`NetAmount`)PatientPayable, ");
            sb.Append("  IF(lt.`PanelID`<>1,(SELECT SUM(pa.`Amount`) FROM panel_amountallocation pa WHERE pa.`PanelID`=lt.`PanelID` AND pa.`TransactionID`=lt.`TransactionID`),0)PanelPayable, ");
            sb.Append(" lt.`NetAmount` TotalBillAmount, ");
            sb.Append(" round((lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid)  ");
            sb.Append(" FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount)  ");
            sb.Append(" FROM panel_amountallocation pa WHERE pa.TransactionID=lt.TransactionID),0)),2)PendingAmt,  ");
            sb.Append(" round(IFNULL((SELECT SUM(r.AmountPaid)   ");
            sb.Append(" FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0),2)AmountPaidByPatient  ");
            sb.Append(" FROM f_ledgertnxdetail ltd inner join f_ledgertransaction lt on lt.LedgerTransactionNo=ltd.LedgerTransactionNo ");
            sb.Append(" LEFT JOIN employee_master em ON em.`EmployeeID`=ltd.`PaymentApprovedBy` ");
            sb.Append(" WHERE ltd.`IsVerified`<>2  AND IFNULL(lt.`AsainstLedgerTnxNo`,'')='' AND ltd.LedgerTransactionNo='" + LedgerTransactionNo + "' AND IF(lt.`PanelID`<>1,ltd.`IsPayable`,1)=" + serviceType + "  ");

            if (filterType != 2)
                sb.Append(" AND ltd.IsPaymentApproval=" + filterType + " ");

            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dt });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "No data Available." });
        }
    }


    [WebMethod(EnableSession = true)]
    public static string ApprovedPaymentItemWise(string Id,string Remark)
    {
        if (string.IsNullOrEmpty(Id))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Select Item To Approved.", message = "Select Item To Approved." });
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string str = "UPDATE f_ledgertnxdetail lt SET lt.IsPaymentApproval=1,PaymentApprovalRemark='" + Remark + "', lt.PaymentApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "',lt.PaymentApprovedDate=NOW(),lt.ServiceItemID='"+Util.GetString('0')+"' WHERE lt.ID in(" + Id + ")";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Payment Approved Successfully.", message = "Payment Approved Successfully." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }


}