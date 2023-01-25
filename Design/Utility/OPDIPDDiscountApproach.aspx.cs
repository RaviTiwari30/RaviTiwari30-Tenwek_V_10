using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_Utility_OPDIPDDiscountApproach : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            cdFrom.EndDate = System.DateTime.Now;
            cdTo.EndDate = System.DateTime.Now;
            BindCategoryCheck();
        }

    }

    private void BindCategoryCheck()
    {
        string str = "";
        str = "Select cm.Name,QUOTE(cm.CategoryID)CategoryID from f_categorymaster cm inner join f_configrelation cf on cm.categoryid = cf.categoryid where cf.ConfigID in ";
        str = str + "(3,7,6,25,20,5)";
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
    [WebMethod(EnableSession = true)]
    public static string SaveData(string FromDate, string ToDate, string Remarks, string OpdCriteria)
    {
        string SqlQuery = string.Empty;
        int count = 0;
        DataTable ModifyData = new DataTable();
        if (HttpContext.Current.Session["ReducedRatedata"] != null)
        {
            ModifyData = (DataTable)HttpContext.Current.Session["ReducedRatedata"];
        }
        else
        {
            return "0";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (ModifyData.Rows.Count > 0)
            {
                int m = 0;
               
                DataTable dtReceipt;
                string OldLedgerTransactionNo = string.Empty, NewLedgerTransactionNo = string.Empty;
                decimal Adjustment = 0, NewNetAmt = 0, PaidAmt = 0, ReceiptUpdateAmt = 0, OldReceiptAmt = 0, NewReceiptAmt = 0, ReceiptModifyPer = 0, RtDiscAmt=0;
                OldLedgerTransactionNo = ModifyData.Rows[0]["LedgerTransactionNo"].ToString();
                for (int k = 0; k < ModifyData.Rows.Count; k++)
                {
                    NewLedgerTransactionNo = Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString());

                    if (OldLedgerTransactionNo != NewLedgerTransactionNo && m > 0)
                    {
                        OldLedgerTransactionNo = NewLedgerTransactionNo;
                        m = 0;
                    }

                    if (ModifyData.Rows[k]["IsUpdate"].ToString() == "Yes")
                    {
                        NewNetAmt = Util.GetDecimal(ModifyData.Rows[k]["LtdNetAmount"].ToString());
                        RtDiscAmt = Util.GetDecimal(ModifyData.Rows[k]["RtDiscAmt"].ToString());
                       // SqlQuery = " SELECT SUM(rtd.Amount) FROM f_reciept rt INNER JOIN f_receipt_paymentdetail rtd ON rtd.ReceiptNo=rt.ReceiptNo WHERE rt.IsCancel=0 AND rtd.PaymentModeID=1 AND rt.AsainstLedgerTnxNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and rt.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "";
                     //   PaidAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, SqlQuery));
                        //   if (PaidAmt > RtDiscAmt)
                        // {  
                           
                        count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_Ledgertransaction_log where LedgerTransactionNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' "));
                        if (count == 0)
                        {
                            SqlQuery = "INSERT INTO `f_Ledgertransaction_log`(LedgerTransactionNo,TypeOfTnx ,DATE,TIME ,BillNo ,BillDate ,NetAmount ,GrossAmount ,DiscountOnTotal ,DiscountReason ,CancelReason ,CancelDate ,Cancel_UserID ,IsCancel ,IsPaid ,PatientID ,PaymentModeID ,Remarks ,PanelID ,UserID ,TransactionID ,PatientType_ID ,RoundOff ,DeptLedgerNo ,EditUserID ,EditDateTime ,EditReason ,EditType ,UniqueHash ,IpAddress ,DiscountApproveBy ,Adjustment ,AdjustmentDate ,BillType ,GovTaxPer ,GovTaxAmount ,FinanceTransfer ,AsainstLedgerTnxNo,IPNo ,PaymentMode ,CentreID ,patientType ,CurrentAge) SELECT LedgerTransactionNo,TypeOfTnx ,DATE,TIME ,BillNo ,BillDate ,NetAmount ,GrossAmount ,DiscountOnTotal ,DiscountReason ,CancelReason ,CancelDate ,Cancel_UserID ,IsCancel ,IsPaid ,PatientID ,PaymentModeID ,Remarks ,PanelID ,UserID ,TransactionID ,PatientType_ID ,RoundOff ,DeptLedgerNo ,EditUserID ,EditDateTime ,EditReason ,EditType ,UniqueHash ,IpAddress ,DiscountApproveBy ,Adjustment ,AdjustmentDate ,BillType ,GovTaxPer ,GovTaxAmount ,FinanceTransfer ,AsainstLedgerTnxNo,IPNo ,PaymentMode ,CentreID ,patientType ,CurrentAge FROM f_Ledgertransaction WHERE LedgerTransactionNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                            SqlQuery = "INSERT INTO `f_ledgertnxdetail_log`(LedgerTnxID,LedgerTransactionNo,Rate,Amount,Quantity,DiscountPercentage,DiscAmt,DiscUserID,TransactionID,DiscountReason,NetItemAmt,ItemID,SubCategoryID,ItemName,configId) SELECT LedgerTnxID,LedgerTransactionNo,Rate,Amount,Quantity,DiscountPercentage,DiscAmt,DiscUserID,TransactionID,DiscountReason,NetItemAmt,ItemID,SubCategoryID,ItemName,configId FROM f_ledgertnxdetail WHERE LedgerTransactionNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                            SqlQuery = "INSERT INTO `f_ledgertransaction_paymentdetail_log`(PaymentModeID,PaymentMode,Amount,LedgerTransactionNo,S_Amount) SELECT PaymentModeID,PaymentMode,Amount,LedgerTransactionNo,S_Amount FROM f_ledgertransaction_paymentdetail WHERE LedgerTransactionNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);
                        }
                        else
                        {
                            SqlQuery = "UPDATE f_Ledgertransaction_log SET LastRateUpdatedDate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE LedgerTransactionNo='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);
                        }
                       
                        if (m == 0)
                        {
                            SqlQuery = "SELECT Adjustment FROM f_Ledgertransaction WHERE LedgerTransactionNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                            Adjustment = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, SqlQuery));
                            if (Adjustment > NewNetAmt)
                                Adjustment = NewNetAmt;

                            SqlQuery = "UPDATE f_Ledgertransaction SET GrossAmount=" + Util.GetDecimal(ModifyData.Rows[k]["LtdGrossAmt"].ToString()) + " ,NetAmount=" + Util.GetDecimal(ModifyData.Rows[k]["LtdNetAmount"].ToString()) + ",DiscountOnTotal=" + Util.GetDecimal(ModifyData.Rows[k]["LtTotalDisc"].ToString()) + ",Adjustment=" + Adjustment + ",RoundOff=" + Util.GetDecimal(ModifyData.Rows[k]["LtRoundOff"].ToString()) + " WHERE LedgerTransactionNo='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                            SqlQuery = "update f_ledgertransaction_paymentdetail set Amount=Amount -" + Util.GetDecimal(ModifyData.Rows[k]["RtDiscAmt"].ToString()) + ",S_Amount=S_Amount -" + Util.GetDecimal(ModifyData.Rows[k]["RtDiscAmt"].ToString()) + "  WHERE PaymentModeID=1 and LedgerTransactionNo ='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                            ReceiptUpdateAmt = RtDiscAmt;

                            SqlQuery = " SELECT rtp.`Amount` AS AmountPaid,rt.ReceiptNo FROM f_reciept rt INNER JOIN f_receipt_paymentdetail rtp ON rtp.`ReceiptNo`=rt.`ReceiptNo` WHERE  rtp.`PaymentModeID`=1 and rt.Iscancel=0 AND  rt.`AsainstLedgerTnxNo`='" + Util.GetString(ModifyData.Rows[k]["LedgerTransactionNo"].ToString()) + "' and rt.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " GROUP BY rt.`ReceiptNo` ORDER BY rt.`ReceiptNo` DESC ";
                            dtReceipt = StockReports.GetDataTable(SqlQuery);
                            if (dtReceipt.Rows.Count > 0)
                            {
                                foreach (DataRow dr in dtReceipt.Rows)
                                {
                                    if (ReceiptUpdateAmt > 0)
                                    {
                                        if (Util.GetDecimal(dr["AmountPaid"].ToString()) >= ReceiptUpdateAmt)
                                        {
                                            OldReceiptAmt = Util.GetDecimal(dr["AmountPaid"].ToString());
                                            NewReceiptAmt = OldReceiptAmt - ReceiptUpdateAmt;
                                            //ReceiptModifyPer = ((OldReceiptAmt - NewReceiptAmt) * 100) / OldReceiptAmt;
                                            count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_reciept_log where  ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' "));
                                            if (count == 0)
                                            {
                                                SqlQuery = "INSERT INTO f_reciept_log(Location ,HospCode ,ID ,ReceiptNo ,Hospital_ID ,LedgerNoCr ,LedgerNoDr ,AsainstLedgerTnxNo ,AmountPaid ,DATE  ,TIME  ,Reciever ,Depositor ,IsPayementByInsurance ,TransactionID ,PanelID ,Cancel_UserID ,CancelDate  ,CancelReason  ,IsCancel ,Discount ,Naration ,EditUserID  ,EditDateTime  ,EditReason ,EditType ,UniqueHash ,ReceivedFrom ,Deductions ,IpAddress  ,Cheque_DDdate  ,RoundOff ,FinanceTransfer ,PaidBy ,SurgeryGroupID ,CreatedBy ,panelInvoiceNo  ,TDS ,WriteOff,CentreID ) SELECT Location ,HospCode ,ID ,ReceiptNo ,Hospital_ID ,LedgerNoCr ,LedgerNoDr ,AsainstLedgerTnxNo ,AmountPaid ,DATE  ,TIME  ,Reciever ,Depositor ,IsPayementByInsurance ,TransactionID ,PanelID ,Cancel_UserID ,CancelDate  ,CancelReason  ,IsCancel ,Discount ,Naration ,EditUserID  ,EditDateTime  ,EditReason ,EditType ,UniqueHash ,ReceivedFrom ,Deductions ,IpAddress  ,Cheque_DDdate  ,RoundOff ,FinanceTransfer ,PaidBy ,SurgeryGroupID ,CreatedBy ,panelInvoiceNo  ,TDS ,WriteOff,CentreID FROM f_reciept WHERE ReceiptNo ='" + dr["ReceiptNo"].ToString() + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "  ";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                                SqlQuery = "INSERT INTO f_receipt_paymentdetail_log (ID ,ReceiptNo,PaymentModeID ,PaymentMode ,Amount,BankName ,RefNo ,RefDate ,PaymentRemarks ,S_Amount ,S_CountryID,S_Currency,S_Notation,C_factor,deductions,TDS,WriteOff,CentreID,Hospital_ID,isOPDAdvance) SELECT ID ,ReceiptNo,PaymentModeID ,PaymentMode ,Amount,BankName ,RefNo ,RefDate ,PaymentRemarks ,S_Amount ,S_CountryID,S_Currency,S_Notation,C_factor,deductions,TDS,WriteOff,CentreID,Hospital_ID,isOPDAdvance FROM f_receipt_paymentdetail WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                                SqlQuery = "INSERT INTO f_patientaccount_log (id ,TransactionId ,PatientId ,Amount ,TYPE ,dtEntry,UserId ,ReceiptNo ,LedgerTransactionNo ,Active ,isClose,DoctorID ,DoctorName ,Narration,IsAdvanceAmt ,ReceiptNoAgeinst ,CentreID ,Hospital_ID ,DeptLedgerNo,PageURL) SELECT id ,TransactionId ,PatientId ,Amount ,TYPE ,dtEntry,UserId ,ReceiptNo ,LedgerTransactionNo ,Active ,isClose,DoctorID ,DoctorName ,Narration,IsAdvanceAmt ,ReceiptNoAgeinst ,CentreID ,Hospital_ID ,DeptLedgerNo,PageURL FROM  f_patientaccount WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);
                                            }

                                            SqlQuery = "update  f_reciept set IsEdit=1 ,AmountPaid = AmountPaid - " + ReceiptUpdateAmt + " where receiptNo ='" + dr["ReceiptNo"].ToString() + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            SqlQuery = "update f_receipt_paymentdetail set Amount=Amount - " + ReceiptUpdateAmt + ",S_Amount=S_Amount - " + ReceiptUpdateAmt + " WHERE PaymentModeID=1 and ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            SqlQuery = "update f_patientaccount set Amount=(-1)*" + NewReceiptAmt + " WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and Type='CREDIT' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            SqlQuery = "update f_patientaccount set Amount=" + NewReceiptAmt + " WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and Type='DEBIT' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            ReceiptUpdateAmt = 0;
                                        }
                                        else
                                        {
                                            count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_reciept_log where  ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " "));
                                            if (count == 0)
                                            {
                                                SqlQuery = "INSERT INTO f_reciept_log(Location ,HospCode ,ID ,ReceiptNo ,Hospital_ID ,LedgerNoCr ,LedgerNoDr ,AsainstLedgerTnxNo ,AmountPaid ,DATE  ,TIME  ,Reciever ,Depositor ,IsPayementByInsurance ,TransactionID ,PanelID ,Cancel_UserID ,CancelDate  ,CancelReason  ,IsCancel ,Discount ,Naration ,EditUserID  ,EditDateTime  ,EditReason ,EditType ,UniqueHash ,ReceivedFrom ,Deductions ,IpAddress  ,Cheque_DDdate  ,RoundOff ,FinanceTransfer ,PaidBy ,SurgeryGroupID ,CreatedBy ,panelInvoiceNo  ,TDS ,WriteOff,CentreID ) SELECT Location ,HospCode ,ID ,ReceiptNo ,Hospital_ID ,LedgerNoCr ,LedgerNoDr ,AsainstLedgerTnxNo ,AmountPaid ,DATE  ,TIME  ,Reciever ,Depositor ,IsPayementByInsurance ,TransactionID ,PanelID ,Cancel_UserID ,CancelDate  ,CancelReason  ,IsCancel ,Discount ,Naration ,EditUserID  ,EditDateTime  ,EditReason ,EditType ,UniqueHash ,ReceivedFrom ,Deductions ,IpAddress  ,Cheque_DDdate  ,RoundOff ,FinanceTransfer ,PaidBy ,SurgeryGroupID ,CreatedBy ,panelInvoiceNo  ,TDS ,WriteOff,CentreID FROM f_reciept WHERE ReceiptNo ='" + dr["ReceiptNo"].ToString() + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                                SqlQuery = "INSERT INTO f_receipt_paymentdetail_log (ID ,ReceiptNo,PaymentModeID ,PaymentMode ,Amount,BankName ,RefNo ,RefDate ,PaymentRemarks ,S_Amount ,S_CountryID,S_Currency,S_Notation,C_factor,deductions,TDS,WriteOff,CentreID,Hospital_ID,isOPDAdvance) SELECT ID ,ReceiptNo,PaymentModeID ,PaymentMode ,Amount,BankName ,RefNo ,RefDate ,PaymentRemarks ,S_Amount ,S_CountryID,S_Currency,S_Notation,C_factor,deductions,TDS,WriteOff,CentreID,Hospital_ID,isOPDAdvance FROM f_receipt_paymentdetail WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                                SqlQuery = "INSERT INTO f_patientaccount_log (id ,TransactionId ,PatientId ,Amount ,TYPE ,dtEntry,UserId ,ReceiptNo ,LedgerTransactionNo ,Active ,isClose,DoctorID ,DoctorName ,Narration,IsAdvanceAmt ,ReceiptNoAgeinst ,CentreID ,Hospital_ID ,DeptLedgerNo,PageURL) SELECT id ,TransactionId ,PatientId ,Amount ,TYPE ,dtEntry,UserId ,ReceiptNo ,LedgerTransactionNo ,Active ,isClose,DoctorID ,DoctorName ,Narration,IsAdvanceAmt ,ReceiptNoAgeinst ,CentreID ,Hospital_ID ,DeptLedgerNo,PageURL FROM  f_patientaccount WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);
                                            }

                                            SqlQuery = "update  f_reciept set IsEdit=1 ,AmountPaid=0 where receiptNo ='" + dr["ReceiptNo"].ToString() + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            SqlQuery = "update f_receipt_paymentdetail set Amount=0,S_Amount=0  WHERE PaymentModeID=1 and ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            SqlQuery = "update f_patientaccount set Amount=0 WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and Type='CREDIT' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            SqlQuery = "update f_patientaccount set Amount=0 WHERE ReceiptNo ='" + Util.GetString(dr["ReceiptNo"].ToString()) + "' and Type='DEBIT' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);

                                            ReceiptUpdateAmt = ReceiptUpdateAmt - Util.GetDecimal(dr["AmountPaid"].ToString());
                                        }
                                    }
                                }
                            }
                            m = m + 1;
                        }
                        //     }
                        SqlQuery = "UPDATE f_ledgertnxdetail SET Rate=" + Util.GetDecimal(ModifyData.Rows[k]["Rate"].ToString()) + ", Amount=" + Util.GetDecimal(ModifyData.Rows[k]["Amount"].ToString()) + ",DiscAmt=" + Util.GetDecimal(ModifyData.Rows[k]["DiscAmt"].ToString()) + ",NetItemAmt=" + (Util.GetDecimal(ModifyData.Rows[k]["Amount"].ToString()) / Util.GetDecimal(ModifyData.Rows[k]["Quantity"].ToString())) + ",LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now() WHERE LedgerTnxID='" + ModifyData.Rows[k]["LedgerTnxID"].ToString() + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);    
                    }
                }
            }

            SqlQuery = " INSERT INTO f_utility_log(CategoryForApply,FromDate,ToDate,Remarks,CreatedBy) values('" + OpdCriteria.Replace("'","$") + "','" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Remarks + "','" + HttpContext.Current.Session["ID"].ToString() + "') ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            HttpContext.Current.Session.Remove("ReducedRatedata");

        }
    }
    [WebMethod(EnableSession = true)]
    public static string CalculateOPDData(string FromDate, string ToDate, string OpdCriteria, string ReduceType, string RateReduce, string MinimumRate, string ReceiptNo, string BillNo)
    {

        string LedgerTransactionNo = string.Empty, LedgerTnxID = string.Empty;
        float LtdNetAmount = 0.00f, LtdGrossAmt = 0.00f, LtTotalDisc = 0.00f, LtRoundOff = 0.00f, LTOldNetAmt = 0.00F, RtDiscAmt = 0.00f, RtDiscPer = 0.00f, NetAmt = 0.00f, NewNetAmt = 0.00f, DifferenceAmt = 0.00f;

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 0 LtdNetAmount,0 LtdGrossAmt,0 LtTotalDisc,0 LtRoundOff,0 RtDiscAmt,0 RtDiscPer, ltd.Rate OldRate, ROUND((ltd.Rate*ltd.Quantity*ltd.DiscountPercentage*0.01),3) OldDiscAmt,IFNULL((SELECT SUM(rtd.Amount) FROM f_reciept rt INNER JOIN f_receipt_paymentdetail rtd ON rtd.ReceiptNo=rt.ReceiptNo WHERE rt.IsCancel=0 AND rtd.PaymentModeID=1 AND rt.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)PaidInCash,ltd.LedgerTnxID,ltd.Amount as OldAmt,if((ltd.Rate<=" + Util.GetFloat(MinimumRate) + " OR ltd.Rate<" + Util.GetFloat(RateReduce) + "),'No','Yes')IsUpdate, ");
        if (ReduceType == "Amt")
        {
            sb.Append(" round((ltd.Rate-" + Util.GetFloat(RateReduce) + "),2)Rate,round((((ltd.Rate-" + Util.GetFloat(RateReduce) + ")*ltd.Quantity)-(((ltd.Rate-" + Util.GetFloat(RateReduce) + ")*ltd.DiscountPercentage*ltd.Quantity)/100)),2)Amount,round((((ltd.Rate-" + Util.GetFloat(RateReduce) + ")*ltd.DiscountPercentage*ltd.Quantity)/100),2)DiscAmt ");
        }
        else
        {
            sb.Append(" round((ltd.Rate-((ltd.Rate*" + RateReduce + ")/100)),2)Rate,round((((ltd.Rate-((ltd.Rate*" + Util.GetFloat(RateReduce) + ")/100))*ltd.Quantity)-(((ltd.Rate-((ltd.Rate*" + Util.GetFloat(RateReduce) + ")/100))*ltd.DiscountPercentage*ltd.Quantity)/100)),2)Amount,round((((ltd.Rate-((ltd.Rate*" + Util.GetFloat(RateReduce) + ")/100))*ltd.DiscountPercentage*ltd.Quantity)/100),2)DiscAmt ");
        }
        sb.Append(" ,ltd.DiscountPercentage,ltd.Quantity,LT.LedgerTransactionNo,LT.PatientID,LT.PaymentModeID,LT.NetAmount LTOldNetAmt,DATE_FORMAT(LT.Date,'%d-%b-%y')DATE,Lt.TransactionID,LT.TypeOfTnx AS TnxType, ");
        sb.Append(" CONCAT(PM.title,'',PM.PName)PName ");
        sb.Append(" FROM f_ledgertransaction LT  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  ");
        sb.Append(" INNER JOIN Patient_Medical_History PMH ON LT.TransactionID=PMH.TransactionID  ");
        sb.Append(" INNER JOIN patient_master PM ON PMH.PatientID=PM.PatientID  ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID  ");
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = scm.CategoryID ");
        sb.Append(" INNER JOIN f_reciept  RC ON LT.LedgerTransactionNo=RC.AsainstLedgerTnxNo  ");
        sb.Append(" WHERE LT.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " and LT.`IsCancel`=0 and rc.ISCancel=0 and cm.categoryID  IN (" + OpdCriteria + ") ");
        sb.Append(" AND Lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-BILLING','OPD-APPOINTMENT')  ");
        //if (OpdCriteria == "Lab")
        //{
        //    sb.Append(" AND Lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-BILLING')  ");
        //}
        //else
        //{
        //    sb.Append(" AND Lt.TypeOfTnx='OPD-APPOINTMENT' ");
        //}
        if (ReceiptNo != "")
            sb.Append(" AND rc.ReceiptNo='" + ReceiptNo + "'  ");
        if (BillNo != "")
            sb.Append(" AND lt.BillNo='" + BillNo + "'  ");
        sb.Append(" AND lt.Date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
        sb.Append("  AND lt.NetAmount>0 GROUP BY LT.LedgerTransactionNo,ltd.LedgerTnxID ORDER BY  lt.date,lt.LedgerTransactionNo,LTD.Rate  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                NetAmt = NetAmt + Util.GetFloat(dr["OldAmt"].ToString());
               if (dr["IsUpdate"].ToString() == "Yes")
                { 
                    DifferenceAmt = DifferenceAmt + (Util.GetFloat(dr["OldAmt"].ToString()) - Util.GetFloat(dr["Amount"].ToString()));
                }
                    DataRow[] RowSub = dt.Select("LedgerTransactionNo ='" + dr["LedgerTransactionNo"] + "'");
                    if (RowSub.Length > 0)
                    {
                        LtdNetAmount = 0.00f;
                        LtdGrossAmt = 0.00f;
                        LtTotalDisc = 0.00f;
                        LtRoundOff = 0.00f;
                        NewNetAmt = 0.00f;
                        foreach (DataRow NewRowSub in RowSub)
                        {
                            if (NewRowSub["IsUpdate"].ToString() == "Yes")
                            {
                                NewNetAmt= NewNetAmt +  (Util.GetFloat(dr["OldAmt"].ToString()) - Util.GetFloat(dr["Amount"].ToString()));
                                if (Util.GetFloat(NewRowSub["PaidInCash"].ToString()) >= NewNetAmt)
                                {
                                    LtdNetAmount = LtdNetAmount + Util.GetFloat(NewRowSub["Amount"].ToString());
                                    LtdGrossAmt = LtdGrossAmt + (Util.GetFloat(NewRowSub["Rate"].ToString()) * Util.GetFloat(NewRowSub["Quantity"].ToString()));
                                    LtTotalDisc = LtTotalDisc + Util.GetFloat(NewRowSub["DiscAmt"].ToString());
                                }
                                else
                                {
                                    NewRowSub["IsUpdate"] = "No";
                                    LtdNetAmount = LtdNetAmount + Util.GetFloat(NewRowSub["OldAmt"].ToString());
                                    LtdGrossAmt = LtdGrossAmt + (Util.GetFloat(NewRowSub["OldRate"].ToString()) * Util.GetFloat(NewRowSub["Quantity"].ToString()));
                                    LtTotalDisc = LtTotalDisc + Util.GetFloat(NewRowSub["OldDiscAmt"].ToString());
                                    NewNetAmt = NewNetAmt - (Util.GetFloat(dr["OldAmt"].ToString()) - Util.GetFloat(dr["Amount"].ToString()));
                                }
                            }
                            else
                            {
                                LtdNetAmount = LtdNetAmount + Util.GetFloat(NewRowSub["OldAmt"].ToString());
                                LtdGrossAmt = LtdGrossAmt + (Util.GetFloat(NewRowSub["OldRate"].ToString()) * Util.GetFloat(NewRowSub["Quantity"].ToString()));
                                LtTotalDisc = LtTotalDisc + Util.GetFloat(NewRowSub["OldDiscAmt"].ToString());
                            }
                           
                        }
                        LtRoundOff = Util.GetFloat(Math.Round(LtdNetAmount, 2) - Math.Round(LtdNetAmount));
                        LtdNetAmount = Util.GetFloat(Math.Round(LtdNetAmount));
                        LTOldNetAmt = Util.GetFloat(dr["LTOldNetAmt"].ToString());
                        RtDiscAmt = LTOldNetAmt - LtdNetAmount;
                        RtDiscPer = ((LTOldNetAmt - LtdNetAmount) * 100) / LTOldNetAmt;
                        foreach (DataRow NewRowAdd in RowSub)
                        {
                            NewRowAdd["LtdNetAmount"] = LtdNetAmount;
                            NewRowAdd["LtdGrossAmt"] = LtdGrossAmt;
                            NewRowAdd["LtTotalDisc"] = LtTotalDisc;
                            NewRowAdd["LtRoundOff"] = LtRoundOff;
                            NewRowAdd["RtDiscPer"] = RtDiscPer;
                            NewRowAdd["RtDiscAmt"] = RtDiscAmt; 
                        }
                    
                }
            }
            dt.AcceptChanges();
            HttpContext.Current.Session["ReducedRatedata"] = dt;
            return Newtonsoft.Json.JsonConvert.SerializeObject("Previous Net Amount :Rs." + NetAmt.ToString() + " , New Net Amount :Rs." + (NetAmt - DifferenceAmt).ToString() + " and Difference :Rs. " + (DifferenceAmt).ToString());

        }
        else
        {
            return "0";
        }

    }
     [WebMethod]
    public static string BindOPDData(string FromDate, string ToDate, string OpdCriteria, string ReceiptNo,string BillNo)
    { 
          StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT LT.LedgerTransactionNo,(RC.AmountPaid) PaidAmount,RC.ReceiptNo,LT.PatientID,LT.NetAmount,LT.PaymentModeID, ");
            sb.Append(" DATE_FORMAT(LT.Date,'%d-%b-%y')DATE,Lt.TransactionID,LT.TypeOfTnx AS TnxType,lt.RoundOff, ");
            sb.Append(" CONCAT(PM.title,'',PM.PName)PName ");
            sb.Append(" FROM f_ledgertransaction LT    ");
            sb.Append(" INNER JOIN  f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo= lt.LedgerTransactionNo ");
            sb.Append(" INNER JOIN f_ledgertransaction_paymentdetail LTP ON lt.LedgerTransactionNo=ltp.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN f_reciept RC ON LT.LedgerTransactionNo=RC.AsainstLedgerTnxNo  ");
            sb.Append(" INNER JOIN Patient_Medical_History PMH ON LT.TransactionID=PMH.TransactionID  ");
            sb.Append(" INNER JOIN patient_master PM ON PMH.PatientID=PM.PatientID  ");
            sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID  ");
            sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = scm.CategoryID ");
            sb.Append(" WHERE LT.`IsCancel`=0 and rc.ISCancel=0 and cm.categoryID  IN (" + OpdCriteria + ") ");
            sb.Append(" AND Lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-BILLING','OPD-APPOINTMENT')  ");
         if(ReceiptNo !="")
             sb.Append(" AND rc.ReceiptNo='" + ReceiptNo + "'  ");
         if (BillNo != "")
             sb.Append(" AND lt.BillNo='" + BillNo + "'  ");

            sb.Append(" AND lt.Date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
         //   sb.Append(" AND IFNULL(LT.`IPNo`,'')=''  ");
            sb.Append(" AND lt.NetAmount>0 AND LT.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " GROUP BY LT.LedgerTransactionNo  ORDER BY  lt.date,lt.LedgerTransactionNo ");

        DataTable dtOPD = StockReports.GetDataTable(sb.ToString());
        if (dtOPD != null && dtOPD.Rows.Count > 0)
        {
          
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtOPD);
        }
        else
        {
            return "0";
        }
    }
  [WebMethod]
     public static string LastUpdatedData()
    { 
          StringBuilder sb = new StringBuilder();
          sb.Append("SELECT CONCAT('Last Time Rate Reduced on Date : ',DATE_FORMAT(MAX(LastRateUpdatedDate),'%d-%b-%Y %I:%i %p'))Msg FROM f_Ledgertransaction_log Lt WHERE LT.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND Lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-BILLING','OPD-APPOINTMENT') ");
          string LastUpdated = StockReports.ExecuteScalar(sb.ToString());
          if (LastUpdated != null && LastUpdated !="")
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(LastUpdated);
        }
        else
        {
            return "0";
        }
    }
 [WebMethod]
  public static string BindUtilityData()
    { 
          StringBuilder sb = new StringBuilder();
          sb.Append("SELECT DATE_FORMAT(L.FromDate,'%d-%b-%y')FromDate,DATE_FORMAT(L.ToDate,'%d-%b-%y')ToDate,L.Remarks,DATE_FORMAT(L.CreatedDate,'%d-%b-%y')CreatedDate,IF(IsRevert=1,'Yes','No')IsRevert FROM f_utility_log L order by ID DESC LIMIT 100 ");
          DataTable UtilityData = StockReports.GetDataTable(sb.ToString());
          if (UtilityData != null && UtilityData.Rows.Count>0)
             {
                return Newtonsoft.Json.JsonConvert.SerializeObject(UtilityData);
             }
           else
             {
                return "0";
             }
    }
[WebMethod(EnableSession = true)]
 public static string RevertData(string FromDate, string ToDate,string OpdCriteriaText, string OpdCriteria, string ReceiptNo)
    {
        string SqlQuery = string.Empty;

        StringBuilder sb = new StringBuilder();
         sb.Append("  SELECT DISTINCT ltl.LedgerTransactionNo  ");
         sb.Append("  FROM f_ledgertransaction LT   ");
         sb.Append("  INNER JOIN f_ledgertransaction_log ltl ON ltl.LedgerTransactionNo=lt.LedgerTransactionNo  ");
         sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo   ");  
         sb.Append("  INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID    ");
         sb.Append("  INNER JOIN f_categorymaster cm ON cm.CategoryID = scm.CategoryID   ");
         sb.Append("  INNER JOIN f_reciept  RC ON LT.LedgerTransactionNo=RC.AsainstLedgerTnxNo    ");
         sb.Append(" WHERE LT.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " and LT.`IsCancel`=0 ");
         sb.Append(" AND Lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-BILLING','OPD-APPOINTMENT')  ");
         if (OpdCriteria != "")
         sb.Append(" and cm.categoryID  IN (" + OpdCriteria + ") ");

         if (ReceiptNo != "")
             sb.Append(" AND rc.ReceiptNo='" + ReceiptNo + "'  ");
  
         sb.Append("  AND lt.Date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
       //  sb.Append("  AND IFNULL(LT.`IPNo`,'')=''  ");
         sb.Append("  GROUP BY LT.LedgerTransactionNo ");

         string Remarks="";
         if(ReceiptNo != "")
            Remarks ="Receipt "+ ReceiptNo + "  Reverted Successfully.";
          else
             Remarks = "Revert Data for Category : " + OpdCriteriaText.Replace("'", "");

        DataTable RevertData = StockReports.GetDataTable(sb.ToString());
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if ( RevertData.Rows.Count > 0 && RevertData != null)
            {
               
                for (int k = 0; k < RevertData.Rows.Count; k++)
                {
                    SqlQuery = "  UPDATE f_Ledgertransaction lt INNER JOIN f_Ledgertransaction_log ltl ON lt.LedgerTransactionNo=ltl.LedgerTransactionNo SET lt.GrossAmount=ltl.GrossAmount ,lt.NetAmount=ltl.NetAmount,lt.DiscountOnTotal=ltl.DiscountOnTotal,lt.Adjustment=ltl.Adjustment,lt.RoundOff=ltl.RoundOff,lt.Remarks=ltl.Remarks,ltl.LastRateUpdatedDate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE lt.LedgerTransactionNo='" + RevertData.Rows[k]["LedgerTransactionNo"].ToString() + "' AND lt.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery);
                    SqlQuery = "  UPDATE f_ledgertransaction_paymentdetail ltp INNER JOIN f_ledgertransaction_paymentdetail_log ltpl ON ltp.LedgerTransactionNo=ltpl.LedgerTransactionNo AND ltpl.PaymentModeID=ltp.PaymentModeID SET ltp.Amount=ltpl.Amount,ltp.S_Amount=ltpl.S_Amount WHERE ltp.PaymentModeID=1 AND ltp.LedgerTransactionNo ='" + RevertData.Rows[k]["LedgerTransactionNo"].ToString() + "' AND ltp.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 
                    SqlQuery = "  UPDATE f_ledgertnxdetail ltd INNER JOIN f_ledgertnxdetail_log ltdl ON ltd.LedgerTnxID=ltdl.LedgerTnxID SET ltd.Rate=ltdl.Rate, ltd.Amount=ltdl.Amount,ltd.DiscAmt=ltdl.DiscAmt,ltd.NetItemAmt=ltdl.NetItemAmt WHERE ltd.LedgerTransactionNo='" + RevertData.Rows[k]["LedgerTransactionNo"].ToString() + "' AND ltd.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 
                    SqlQuery = "  UPDATE  f_reciept r INNER JOIN f_reciept_log rl ON rl.ReceiptNo=r.ReceiptNo SET r.IsEdit=0 ,r.AmountPaid = rl.AmountPaid WHERE r.AsainstLedgerTnxNo='" + RevertData.Rows[k]["LedgerTransactionNo"].ToString() + "' AND r.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 
                    SqlQuery = "  UPDATE f_receipt_paymentdetail rp INNER JOIN f_receipt_paymentdetail_log rpl ON rpl.ID=rp.ID AND rp.ReceiptNo=rpl.ReceiptNo AND rp.PaymentModeID=rpl.PaymentModeID INNER JOIN f_reciept r ON r.ReceiptNo=rp.ReceiptNo SET rp.Amount=rpl.Amount,rp.S_Amount=rpl.S_Amount WHERE rp.PaymentModeID=1 AND r.AsainstLedgerTnxNo='" + RevertData.Rows[k]["LedgerTransactionNo"].ToString() + "' AND r.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 
                    SqlQuery = "  UPDATE f_patientaccount pa INNER JOIN f_patientaccount_log pal ON pal.id=pa.id AND pa.Type=pal.Type INNER JOIN  f_reciept r ON r.ReceiptNo=pa.ReceiptNo SET pa.Amount=pal.Amount WHERE r.AsainstLedgerTnxNo='" + RevertData.Rows[k]["LedgerTransactionNo"].ToString() + "' AND r.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 
                }
            }

            SqlQuery = " INSERT INTO f_utility_log(CategoryForApply,FromDate,ToDate,Remarks,CreatedBy,IsRevert,RevertBy,RevertDateTime) values('" + OpdCriteria.Replace("'", "$") + "','" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Remarks + "','" + HttpContext.Current.Session["ID"].ToString() + "',1,'" + HttpContext.Current.Session["ID"].ToString() + "',now()) ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlQuery); 

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();

        }
    }
}
