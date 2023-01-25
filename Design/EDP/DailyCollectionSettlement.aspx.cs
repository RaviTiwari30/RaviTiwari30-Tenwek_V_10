using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_DailyCollectionSettlement : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
            BindUser();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtFromTime.Text = "00:00 AM";
        txtToTime.Text = "11:59 PM";
    }
    private void BindUser()
    {
        string IsCanSettleBatch = "0";
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(em.Title,' ',Name)As Name,em.EmployeeID, ");

        if(dtAuthority.Rows.Count>0 && dtAuthority !=null)
            if (dtAuthority.Rows[0]["IsCanSettleBatch"].ToString() == "1")
                IsCanSettleBatch="1";

        sb.Append("" + IsCanSettleBatch + " IsCanSettleBatch "); 
        sb.Append(" from employee_master em  WHERE IsActive=1 ORDER BY NAME  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddluser.DataSource = dt;
            ddluser.DataTextField = "Name";
            ddluser.DataValueField = "EmployeeID";
            ddluser.DataBind();
            ddluser.SelectedValue = Session["Id"].ToString();
            ddluser.Items.Insert(0, "All");

            if (dt.Rows[0]["IsCanSettleBatch"].ToString() == "1")
            {
                ddluser.Enabled = true;
            }
            else
                ddluser.Enabled = false;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SearchDailyCollection(string BatchNumber, string UserId, string fromDate, string toDate, string FromTime, string Totime, string Status)
    {
        string startDate = string.Empty, Todate = string.Empty; string IsCanSettleBatch = "0";
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()),HttpContext.Current.Session["ID"].ToString());
        if (dtAuthority.Rows.Count > 0 && dtAuthority != null)
            if (dtAuthority.Rows[0]["IsCanSettleBatch"].ToString() == "1")
                IsCanSettleBatch = "1";

        if (UserId == "All")
        {
            UserId = "";
        }
        if (Util.GetDateTime(fromDate).ToString() != "")
            if (FromTime.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(fromDate)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(FromTime).ToString("HH:mm:ss");
            else
                startDate = Util.GetDateTime(Util.GetDateTime(fromDate)).ToString("yyyy-MM-dd");
        if (Util.GetDateTime(toDate).ToString() != string.Empty)
            if (Totime.Trim() != string.Empty)
                Todate = Util.GetDateTime(Util.GetDateTime(toDate)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(Totime.Trim()).ToString("HH:mm:ss");
            else
                Todate = Util.GetDateTime(Util.GetDateTime(toDate)).ToString("yyyy-MM-dd");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT EBM.BatchNumber,em.Name,CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),'  ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),'  ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))EndDate,  ");
        sb.Append(" " + IsCanSettleBatch + " IsCanSettleBatch, ");
        sb.Append(" EBM.Settled,EBM.Status,IFNULL(( SELECT SUM(rec_pay.S_Amount) FROM  f_reciept Rec    ");
        sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo  WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr<>'HOSP0005'  AND rec_pay.isopdadvance=0   ");
        sb.Append("   AND  rec.Iscancel=0 AND lt.IsCancel=0   AND Rec.BatchNumber=EBM.BatchNumber ");
        sb.Append(" AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' ");
         if(UserId!="")
             sb.Append(" AND rec.Reciever='" + UserId + "' ");
        sb.Append("    ),0)NetAmount_1, ");

        sb.Append("  IFNULL(( SELECT SUM(fre.AmountPaid*-1)  FROM f_reciept_expence fre  INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0 ");
        sb.Append("  INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID    AND  (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "' )   AND (CONCAT(fre.Date,' ',fre.Time) <= '" + Todate + "' ) ");

        if (UserId != "")
            sb.Append(" AND fre.Depositor='" + UserId + "' ");


        sb.Append("   WHERE fre.BatchNumber=EBM.BatchNumber ),0)NetAmount_2,");

        sb.Append("   IFNULL((SELECT  SUM(NetAmount) FROM f_reciept Rec ");
        sb.Append("  INNER JOIN f_receipt_paymentdetail rec_pay  ON rec_pay.ReceiptNo=rec.ReceiptNo INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
        sb.Append("     WHERE rec_pay.isopdadvance=1 AND  rec.Iscancel=0 AND Rec.BatchNumber=EBM.BatchNumber AND lt.IsCancel=0 ");
        sb.Append(" AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' ");
       
        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");

        sb.Append("  ),0)NetAmount_3,");

        sb.Append("    IFNULL(( SELECT  SUM(NetAmount) FROM f_ledgertransaction lt     INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo   WHERE lt_pay.PaymentModeID=4 AND lt.NetAmount<>lt.Adjustment AND lt.BatchNumber=EBM.BatchNumber");
        sb.Append("   AND lt.IsCancel=0 AND CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + Todate + "' ");


        if (UserId != "")
            sb.Append(" AND lt.userID='" + UserId + "' ");

        sb.Append("  ),0)NetAmount_4, ");

        sb.Append(" IFNULL((  SELECT  SUM(AmountPaid)   FROM f_patientaccount acc  INNER JOIN f_reciept rec ON acc.ReceiptNo=rec.ReceiptNo    INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo   ");
        sb.Append("   WHERE  IsAdvanceAmt=1 AND rec.IsCancel=0 AND rec.BatchNumber=EBM.BatchNumber AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND ");
        sb.Append("   CONCAT(rec.Date,' ',rec.time)<='" + Todate + "' ");

        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");

        sb.Append("   ),0)NetAmount_5,");

        sb.Append("  IFNULL(( SELECT SUM(AmountPaid)   FROM f_reciept rec   INNER JOIN Patient_Medical_History adj ON adj.TransactionID=rec.TransactionID  and adj.Type='IPD' ");
        sb.Append("   INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo  ");
        sb.Append("  WHERE rec.IsCancel=0 AND rec.BatchNumber=EBM.BatchNumber AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + Todate + "'  ");


        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");

        sb.Append("  ),0)NetAmount_6, ");
    
        sb.Append("  IFNULL(( SELECT SUM(IF(rec_pay.PaymentMode='Cash',rec_pay.S_Amount,'')) FROM f_reciept Rec ");
        sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo  ");
        sb.Append("  WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr<>'HOSP0005'  AND rec_pay.isopdadvance=0  ");
        sb.Append("  AND  rec.Iscancel=0 AND lt.IsCancel=0  AND Rec.BatchNumber=EBM.BatchNumber  AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND  ");
        sb.Append("   CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' ");


        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");

        sb.Append("  ),0)CashAmount_6, ");

        sb.Append("  IFNULL(( SELECT SUM((fre.AmountPaid*-1))  FROM f_reciept_expence fre  ");
        sb.Append("  INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID    AND  ");
        sb.Append("  (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "' )   AND (CONCAT(fre.Date,' ',fre.Time) <= '" + Todate + "' )   ");

        if (UserId != "")
            sb.Append(" AND fre.Depositor='" + UserId + "' ");

        sb.Append("   WHERE fre.BatchNumber=EBM.BatchNumber ),0)CashAmount_5, ");

        sb.Append("  IFNULL(( SELECT SUM(IF(rec_pay.PaymentMode='Cash',rec_pay.S_Amount,'')) FROM f_reciept Rec  ");
        sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay  ON rec_pay.ReceiptNo=rec.ReceiptNo   INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo    ");
        sb.Append("  WHERE rec_pay.isopdadvance=1 AND  rec.Iscancel=0  AND Rec.BatchNumber=EBM.BatchNumber AND lt.IsCancel=0 ");
        sb.Append(" AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND      CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' ");

        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");

        sb.Append("  ),0)CashAmount_4, ");

        sb.Append("  IFNULL(( SELECT  SUM(IF(lt_pay.PaymentMode='Cash',lt_pay.S_Amount,''))    FROM f_ledgertransaction lt   ");
        sb.Append("  INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo    WHERE lt_pay.PaymentModeID=4 AND lt.NetAmount<>lt.Adjustment AND lt.BatchNumber=EBM.BatchNumber");
        sb.Append("  AND lt.IsCancel=0 AND CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND  CONCAT(lt.Date,' ',lt.Time)<='" + Todate + "' ");

        if (UserId != "")
            sb.Append(" AND lt.userID='" + UserId + "' ");

        sb.Append("  ),0)CashAmount_3,");

        sb.Append("  IFNULL((  SELECT  SUM(IF(rec_pay.PaymentMode='Cash',rec_pay.S_Amount,'')) FROM f_patientaccount acc ");
        sb.Append(" INNER JOIN f_reciept rec ON acc.ReceiptNo=rec.ReceiptNo   INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
        sb.Append("  WHERE  IsAdvanceAmt=1 AND rec.IsCancel=0  AND rec.BatchNumber=EBM.BatchNumber AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND ");
        sb.Append("  CONCAT(rec.Date,' ',rec.time)<='" + Todate + "' ");

        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");


        sb.Append("  ),0)CashAmount_2,  ");

        sb.Append("   IFNULL((  SELECT SUM(IF(rec_pay.PaymentMode='Cash',rec_pay.S_Amount,''))  FROM f_reciept rec  ");
        sb.Append("  INNER JOIN Patient_Medical_History adj ON adj.TransactionID=rec.TransactionID and adj.Type='IPD' INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo  ");
        sb.Append("  WHERE rec.IsCancel=0  AND rec.BatchNumber=EBM.BatchNumber  AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' ");
        sb.Append(" AND CONCAT(rec.Date,' ',rec.time)<='" + Todate + "'  ");

        if (UserId != "")
            sb.Append(" AND rec.Reciever='" + UserId + "' ");

        sb.Append("   ),0)CashAmount_1,");
     
        sb.Append("  IFNULL((SELECT SUM(ReceivedAmount) FROM Employee_Batch_Payment_Details   WHERE BatchNumber=EBM.BatchNumber),0)ReceivedAmount, ");
        sb.Append("  IFNULL((SELECT SUM(OutstandingAmount) FROM Employee_Batch_Payment_Details  WHERE BatchNumber=EBM.BatchNumber),0)OutstandingAmount ");
        sb.Append(" FROM employee_batch_details EBM  ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID=EBM.Employe_Id  ");
        if (startDate != "" && Todate != "")
        {
            sb.Append(" where CONCAT(EBM.StartDate,' ',EBM.StartTime)>='" + startDate + "' AND CONCAT(EBM.StartDate,' ',EBM.StartTime)<='" + Todate + "' ");
        }
        if (UserId != "" && UserId != null)
        {
            sb.Append(" and EBM.Employe_Id='" + UserId.ToString() + "' ");
        }
        if (BatchNumber != "" && BatchNumber != null)
        {
            sb.Append(" and EBM.BatchNumber='" + BatchNumber.ToString() + "' ");
        }
        if (Status != "All" && Status != "" && Status != null)
        {
            if (Status == "0")
            {
                //sb.Append(" AND EBM.Status=" + Status.ToString() + " AND EBM.Settled=0  ");
                sb.Append("  AND EBM.Settled=0  ");
            }
            if (Status == "1")
            {
                sb.Append(" AND EBM.Status=" + Status.ToString() + " AND EBM.Settled=0 ");
            }
            if (Status == "2")
            {
                sb.Append(" AND EBM.Settled=1  ");
            }
            if (Status == "3")
            {
                sb.Append(" AND EBM.Settled=2 ");
            }
        }
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
     
            if (dtSearch.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
            else
                return "";
    }

    [WebMethod(EnableSession = true)]
    public static string BindBatchCollection(string BatchNumber)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT EBM.BatchNumber, EBM.PaidAmount,em.Name,EBM.Remarks,DATE_FORMAT(EBM.PaidAmountDateTime,'%d-%b-%y %h:%i %p')PaidAmountDateTime  ");
        sb.Append(" FROM Employee_Batch_Payment_Details EBM INNER JOIN employee_master em ON em.EmployeeID=EBM.PaidAmountBy  ");
        sb.Append(" WHERE BatchNumber='" + BatchNumber + "'");
        
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
       
        if (dtSearch.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCollectionDetails(object data)
    {
        List<DailyCollectionSettlement> CollectionData = new JavaScriptSerializer().ConvertToType<List<DailyCollectionSettlement>>(data);
        DailyCollectionSettlement ObjDailyCollection = new DailyCollectionSettlement();
        bool checkdis = false;
        int Settled = 0;
        for (int i = 0; i < CollectionData.Count; i++)
        {
            ObjDailyCollection.BatchNumber = Util.GetLong(CollectionData[i].BatchNumber);
            ObjDailyCollection.Remarks = Util.GetString(CollectionData[i].Remarks);
            ObjDailyCollection.Amount = Util.GetInt(CollectionData[i].Amount);
            ObjDailyCollection.OutstandingAmount = Util.GetInt(CollectionData[i].OutstandingAmount);
            ObjDailyCollection.ReceivedAmount = Util.GetInt(CollectionData[i].ReceivedAmount);
            ObjDailyCollection.CashAmount = Util.GetInt(CollectionData[i].CashAmount);
            string IpAddress = HttpContext.Current.Request.UserHostAddress;
            StringBuilder sb = new StringBuilder();
            sb.Append("insert into  Employee_Batch_Payment_Details(BatchNumber,ReceivedAmount,IpAddress,OutstandingAmount,PaidAmount, ");
            sb.Append(" PaidAmountDateTime,PaidAmountBy,Remarks,RemarksDateTime,RemarksGivenBy,TotalCashAmount ) VALUES ( ");
            sb.Append(" '" + ObjDailyCollection.BatchNumber + "'," + ObjDailyCollection.Amount + ",'" + IpAddress + "'," + ObjDailyCollection.OutstandingAmount + "," + ObjDailyCollection.Amount + ", ");
            sb.Append(" NOW(),'" + HttpContext.Current.Session["ID"].ToString() + "','" + ObjDailyCollection.Remarks + "',NOW(),'" + HttpContext.Current.Session["ID"].ToString() + "'," + ObjDailyCollection.CashAmount + " ) ");
            checkdis = StockReports.ExecuteDML(sb.ToString());
            sb.Clear();
            if ((ObjDailyCollection.CashAmount) == (ObjDailyCollection.Amount + ObjDailyCollection.ReceivedAmount))
            {
                Settled = 2;
            }
            else if ((ObjDailyCollection.CashAmount) - (ObjDailyCollection.Amount + ObjDailyCollection.ReceivedAmount) > 0)
            {
                Settled = 1;
            }
            else
            {
                Settled = 0;
            }
            sb.Append(" update Employee_Batch_details set Settled=" + Settled + " where BatchNumber='" + ObjDailyCollection.BatchNumber + "' ");
            checkdis = StockReports.ExecuteDML(sb.ToString());
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(checkdis);
    }
    [WebMethod(EnableSession = true)]
    public static string ShowReport(string BatchNumber, string ReportType, string fromDate, string toDate, string Totime, string FromTime)
    {
        string startDate = string.Empty, Todate = string.Empty;
        if (Util.GetDateTime(fromDate).ToString() != "")
            if (FromTime.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(fromDate)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(FromTime).ToString("HH:mm:ss");
            else
                startDate = Util.GetDateTime(Util.GetDateTime(fromDate)).ToString("yyyy-MM-dd");
        if (Util.GetDateTime(toDate).ToString() != string.Empty)
            if (Totime.Trim() != string.Empty)
                Todate = Util.GetDateTime(Util.GetDateTime(toDate)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(Totime.Trim()).ToString("HH:mm:ss");
            else
                Todate = Util.GetDateTime(Util.GetDateTime(toDate)).ToString("yyyy-MM-dd");
        if (ReportType == "0")
        {
            var sb = new StringBuilder();

            sb.Append(" SELECT DATE,SUM(PaidAmount),PaymentMode,UserName,UserID,CentreName,CentreID,BatchNumber  FROM (");
            sb.Append("SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,Rec.BatchNumber FROM f_reciept Rec ");
            sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
            sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
            sb.Append(" WHERE lt.PaymentModeID<>4 and  TypeOfTnx<>'OPD Advance/Settlements'  AND rec.Iscancel=0 AND lt.IsCancel=0  and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "'  ");
            if (BatchNumber != null && BatchNumber != "")
            {
                sb.Append(" and Rec.BatchNumber='" + BatchNumber + "' ");
            }
            sb.Append(" GROUP BY rec.Date,rec.CentreID,rec.Reciever,Rec.BatchNumber,rec_pay.PaymentMode,rec_pay.S_Notation");
            sb.Append(" UNION ALL");
            sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d %b %Y')DATE,SUM(lt_pay.S_Amount)PaidAmount,CONCAT(lt_pay.PaymentMode,' ',lt_pay.S_Notation)PaymentMode,em.Name UserName,lt.UserID,cm.CentreName,cm.CentreID,lt.BatchNumber  FROM f_ledgertransaction lt");
            sb.Append(" INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo");
            sb.Append(" INNER JOIN employee_master em ON lt.UserID=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID ");
            sb.Append(" WHERE lt_pay.PaymentModeID=4  AND lt.IsCancel=0 and CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + Todate + "'  ");
            if (BatchNumber != null && BatchNumber != "")
            {
                sb.Append(" and lt.BatchNumber='" + BatchNumber + "' ");
            }
            sb.Append(" GROUP BY lt.Date,lt.CentreID,lt.UserID,lt.BatchNumber ,lt_pay.PaymentMode,S_Notation");

            sb.Append("  UNION ALL");
            sb.Append("  SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,rec.BatchNumber   ");
            sb.Append("  FROM f_patientaccount acc inner join f_reciept rec on acc.ReceiptNo=rec.ReceiptNo ");
            sb.Append("  inner join patient_master pm on pm.PatientID=rec.Depositor ");
            sb.Append("  inner join f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
            sb.Append("  inner join employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb.Append("  where  IsAdvanceAmt=1 AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "'  ");
            if (BatchNumber != null && BatchNumber != "")
            {
                sb.Append(" and rec.BatchNumber='" + BatchNumber + "'  ");
            }
            sb.Append("  GROUP BY rec.Date,rec.CentreID,rec.Reciever,rec.BatchNumber,rec_pay.PaymentMode,S_Notation ");



            sb.Append(" UNION ALL");
            sb.Append(" SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,Rec.BatchNumber  FROM f_reciept Rec");
            sb.Append(" INNER JOIN Patient_Medical_History adj ON adj.TransactionID=rec.TransactionID and adj.Type='IPD' ");
            sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID");
            sb.Append(" WHERE rec.Iscancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' ");
            if (BatchNumber != null && BatchNumber != "")
            {
                sb.Append(" and Rec.BatchNumber='" + BatchNumber + "' ");
            }
            sb.Append("GROUP BY rec.Date,rec.CentreID,rec.Reciever,Rec.BatchNumber,rec_pay.PaymentMode,rec_pay.S_Notation");

            sb.Append(" )a GROUP BY Date,CentreID,UserID,BatchNumber,PaymentMode ");
            var dt1 = new DataTable();
            dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(startDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(Todate).ToString("dd-MMM-yyyy");
                dt1.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                //ds.Tables.Add(dtSum.Copy());
                // ds.WriteXmlSchema(@"E:\\CollectionReportSummary.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "CollectionReportSummary";
                return "1";
            }
            else
            {
                return "0";
            }

        }
        else if (ReportType == "1")
        {
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" Select * from ( ");
            sb1.Append("  SELECT (select CONCAT(Title,' ',Name) from doctor_master where DoctorID=pmh.DoctorID)Doctor, lt.TransactionID,lt.BillNo,rec.ReceiptNo,lt.PatientID MRNo, IF(pm.PatientID='CASH002',(SELECT  NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),(SELECT Pname FROM patient_master WHERE PatientID=pm.PatientID))Pname,pm.Age,IF(TypeOfTnx='OPD-LAB','DIAGNOSIS',TypeOfTnx)TypeOfTnx, ");
            sb1.Append("  CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,NetAmount,SUM(IF(rec_pay.PaymentModeID=5,0,rec_pay.S_Amount))PaidAmount,lt.RoundOff, ");
            sb1.Append("  CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment,em.Name UserName,cm.CentreName,cm.CentreID,rec.BatchNumber,CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))CloseOn,CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,IF(EBM.Status=0,'Open','Closed')STATUS,rec_pay.PaymentMode,rec_pay.RefNo,DATE_FORMAT(rec_pay.RefDate,'%d-%b-%y')RefDate,rec_pay.BankName ");
            sb1.Append("  FROM f_reciept Rec ");
            sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb1.Append("  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
            sb1.Append("  INNER join `patient_medical_history` pmh on rec.TransactionID=pmh.TransactionID ");
            sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
            sb1.Append("  INNER JOIN employee_batch_details EBM ON EBM.BatchNumber=rec.BatchNumber ");
            sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append("  WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr<>'HOSP0005'  AND rec_pay.isopdadvance=0   AND  rec.Iscancel=0 AND lt.IsCancel=0  and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' AND rec.BatchNumber='" + BatchNumber + "'  ");
            sb1.Append("  GROUP BY rec.Reciever,rec_pay.ReceiptNo,rec_pay.`PaymentModeID`  ");

            sb1.Append("  UNION ALL");
            sb1.Append("  SELECT '' Doctor,'' TransactionID,'' BillNo,fre.ReceiptNo,'' AS MRNo,fre.EmployeeName Pname,'' Age,'Payment' AS  TypeOfTnx,CONCAT(DATE_FORMAT(fre.Date,'%d %b %Y'),' ',(TIME_FORMAT(fre.Time,'%H:%i')))DATE, ");
            sb1.Append("  fre.AmountPaid*-1 NetAmount,fre.AmountPaid*-1 PaidAmount,'' RoundOff,CONCAT(fre.AmountPaid*-1,' " + Resources.Resource.BaseCurrencyNotation + "',' Cash')Payment ,Em.Name UserName,cm.CentreName,cm.CentreID,EBM.BatchNumber,CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))CloseOn,CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,IF(EBM.Status=0,'Open','Closed')STATUS,'Cash(Expense)' PaymentMode, '' RefNo,'' RefDate,'' BankName ");
            sb1.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0  INNER JOIN employee_batch_details EBM ON EBM.BatchNumber=fre.BatchNumber  INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID  ");
            sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "' ) ");
            sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + Todate + "' )  AND fre.BatchNumber='" + BatchNumber + "'  ");

            sb1.Append("  UNION ALL");

            sb1.Append(" SELECT (select CONCAT(Title,' ',Name) from doctor_master where DoctorID=pmh.DoctorID)Doctor, rec.TransactionID,'' BillNo,rec.ReceiptNo,pm.PatientID MRNo,pm.Pname,pm.Age,'OPD-Advance' TypeOfTnx, ");
            sb1.Append(" CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,NetAmount,SUM(rec_pay.S_Amount)PaidAmount,lt.RoundOff,");
            sb1.Append(" CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment , ");
            sb1.Append(" em.Name UserName,cm.CentreName,cm.CentreID,rec.BatchNumber,CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))CloseOn, CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,IF(EBM.Status=0,'Open','Closed')STATUS,rec_pay.PaymentMode,rec_pay.RefNo,DATE_FORMAT(rec_pay.RefDate,'%d-%b-%y')RefDate,rec_pay.BankName ");
            sb1.Append(" FROM f_reciept Rec ");
            sb1.Append(" INNER JOIN f_receipt_paymentdetail rec_pay  ON rec_pay.ReceiptNo=rec.ReceiptNo ");
            sb1.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
            sb1.Append("  INNER join `patient_medical_history` pmh on rec.TransactionID=pmh.TransactionID ");
            sb1.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID");
            sb1.Append("  INNER JOIN employee_batch_details EBM ON EBM.BatchNumber=rec.BatchNumber ");
            sb1.Append(" INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  WHERE rec_pay.isopdadvance=1 AND TypeOfTnx='OPD-Advance' AND  rec.Iscancel=0 AND lt.IsCancel=0 ");
            sb1.Append(" AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Todate + "' AND rec.BatchNumber='" + BatchNumber + "' ");
            sb1.Append("   GROUP BY rec.Reciever,rec_pay.ReceiptNo,rec_pay.`PaymentModeID`   ");

            //sb1.Append("  UNION ALL");
            //sb1.Append("  SELECT lt.TransactionID,lt.BillNo,'' ReceiptNo,lt.PatientID MRNo, IF(pm.PatientID='CASH002',(SELECT  NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),(SELECT Pname FROM patient_master WHERE PatientID=pm.PatientID))Pname,pm.Age,IF(TypeOfTnx='OPD-LAB','DIAGNOSIS',TypeOfTnx)TypeOfTnx,CONCAT(DATE_FORMAT(lt.date,'%d %b %Y'),' ',DATE_FORMAT(lt.time,'%H:%i'))DATE,NetAmount,0 PaidAmount,lt.RoundOff,CONVERT(GROUP_CONCAT(lt_pay.S_Amount,' ',' " + Resources.Resource.BaseCurrencyNotation + "' ,lt_pay.PaymentMode,' ',lt_pay.BankName,' ',lt_pay.refNo),CHAR)Payment ,em.Name UserName,cm.CentreName,cm.CentreID,lt.BatchNumber, CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))CloseOn,  CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,IF(EBM.Status=0,'Open','Closed')STATUS FROM f_ledgertransaction lt ");
            //sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
            //sb1.Append("  INNER JOIN employee_master em ON lt.UserID=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID");
            //sb1.Append("  INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo ");
            //sb1.Append("  INNER JOIN employee_batch_details EBM ON EBM.BatchNumber=lt.BatchNumber ");
            //sb1.Append("  WHERE lt_pay.PaymentModeID=4 AND lt.NetAmount<>lt.Adjustment  AND lt.IsCancel=0 and CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + Todate + "'  ");
            //sb1.Append(" and lt.BatchNumber='" + BatchNumber + "'  GROUP BY lt_pay.LedgerTransactionNo");

            sb1.Append("  UNION ALL");
            sb1.Append("  SELECT (select CONCAT(Title,' ',Name) from doctor_master where DoctorID=pmh.DoctorID)Doctor,rec.TransactionID,''BillNo,rec.ReceiptNo,rec.Depositor MR_NO,CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,'OPD Settlement' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount,SUM(IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount))PaidAmount,rec.RoundOff,CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment ,em.Name UserName,cm.CentreName,cm.CentreID,rec.BatchNumber, CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))CloseOn,CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,IF(EBM.Status=0,'Open','Closed')STATUS,rec_pay.PaymentMode,rec_pay.RefNo,DATE_FORMAT(rec_pay.RefDate,'%d-%b-%y')RefDate,rec_pay.BankName    ");
            sb1.Append("  FROM f_patientaccount acc inner join f_reciept rec on acc.ReceiptNo=rec.ReceiptNo ");
            sb1.Append("  inner join patient_master pm on pm.PatientID=rec.Depositor ");
            sb1.Append("  inner join f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
            sb1.Append("  INNER join `patient_medical_history` pmh on rec.TransactionID=pmh.TransactionID ");
            sb1.Append("  INNER JOIN employee_batch_details EBM ON EBM.BatchNumber=rec.BatchNumber  ");
            sb1.Append("  inner join employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append("  where  IsAdvanceAmt=1 AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + Todate + "' and rec.BatchNumber='" + BatchNumber + "'  GROUP BY rec.ReceiptNo,rec_pay.`PaymentModeID`   ");

            sb1.Append("  UNION ALL");
            sb1.Append("  SELECT (select CONCAT(Title,' ',Name) from doctor_master where DoctorID=pmh.DoctorID)Doctor,rec.TransactionID,''BillNo,rec.ReceiptNo,rec.Depositor MR_NO,CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,'IPD-Advance' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount,SUM(rec_pay.S_Amount)PaidAmount,rec.RoundOff,CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment ,em.Name UserName,cm.CentreName,cm.CentreID,rec.BatchNumber,   CONCAT((DATE_FORMAT(EBM.EndDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.EndTime,'%h:%i %p')))CloseOn,     CONCAT((DATE_FORMAT(EBM.StartDate,'%d-%b-%y')),' ',(TIME_FORMAT(EBM.StartTime,'%h:%i %p')))StartDate,IF(EBM.Status=0,'Open','Closed')STATUS,rec_pay.PaymentMode,rec_pay.RefNo,DATE_FORMAT(rec_pay.RefDate,'%d-%b-%y')RefDate,rec_pay.BankName  ");
            sb1.Append("  FROM f_reciept rec ");
            sb1.Append("  INNER JOIN Patient_Medical_History adj ON adj.TransactionID=rec.TransactionID and adj.Type='IPD' ");
            sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
            sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append("  INNER join `patient_medical_history` pmh on rec.TransactionID=pmh.TransactionID ");
            sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
            sb1.Append("  INNER JOIN employee_batch_details EBM ON EBM.BatchNumber=rec.BatchNumber ");
            sb1.Append("  WHERE rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + Todate + "'   ");
            sb1.Append("   AND rec.BatchNumber='" + BatchNumber + "'  GROUP BY rec.ReceiptNo,rec_pay.`PaymentModeID`  ");
            sb1.Append(" )t ORDER BY ReceiptNo ");
            var dt1 = new DataTable();
            if (sb1.ToString() != null && sb1.ToString() != "")
            {
                dt1 = StockReports.GetDataTable(sb1.ToString());
            }

            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                dt1.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());

                sb1.Clear();
                sb1.Append(" select rt.ReceiptNo,rt.AmountPaid,DATE_FORMAT(rt.Date,'%d-%b-%Y')Date,rt.Depositor,IF(rt.TransactionID Like 'ISHHI%',REPLACE(rt.TransactionID,'ISHHI',''),'')IPNo,CONCAT(pm.Title,' ',pm.PName)PName,IF(rt.TransactionID Like 'ISHHI%','IPD','OPD')Type,CONCAT(em.Title,' ',em.`Name`)UserName, ");
                sb1.Append(" CONCAT(em2.Title,' ',em2.`Name`)CancelledBy,rt.CancelReason ");
                sb1.Append(" from f_reciept rt ");
                sb1.Append(" INNER JOIN center_master cm ON cm.CentreID=rt.CentreID ");
                sb1.Append(" INNER JOIN patient_master pm on rt.Depositor=pm.PatientID  ");
                sb1.Append(" INNER JOIN employee_master em on em.EmployeeID=rt.Reciever ");
                sb1.Append(" INNER JOIN employee_master em2 on em2.EmployeeID=rt.`Cancel_UserID`");
                sb1.Append(" where rt.IsCancel=1 and CONCAT(rt.Date,' ',rt.time)>='" + startDate + "' and CONCAT(rt.Date,' ',rt.time)<='" + Todate + "' AND rt.BatchNumber='" + BatchNumber + "' ");
                DataTable dtCancel = StockReports.GetDataTable(sb1.ToString());
                dtCancel.TableName = "CancelReceipt";
                ds.Tables.Add(dtCancel.Copy());

               // ds.WriteXmlSchema(@"D:\\CollectionReportDetailNew.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "DailyCollectionSettlement";
                return "1";
            }
            else
            {
                return "0";
            }
        }
        else
            return "0";
    }
}