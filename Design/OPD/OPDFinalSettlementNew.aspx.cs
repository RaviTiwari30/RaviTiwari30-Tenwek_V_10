using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Linq;
public partial class Design_OPD_OPDFinalSettlementNew : System.Web.UI.Page
{


    [WebMethod(EnableSession = true)]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Centre(HttpContext.Current.Session["ID"].ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string CheckBillAlreadySave(string LedgerTransactionNo)
    {
        return StockReports.ExecuteScalar(" SELECT CONCAT(IsPaid,'#',IsCancel)checkCon FROM `f_ledgertransaction` WHERE `LedgerTransactionNo`='" + LedgerTransactionNo + "' ");

    }

    [WebMethod]
    public static string chkRefundCase(string BillNo)
    {
        string Refund_Against_BillNo = Util.GetString(StockReports.ExecuteScalar("SELECT IFNULL(Refund_Against_BillNo,'')Refund_Against_BillNo  FROM f_ledgertransaction Where BillNo='" + BillNo + "'"));
        if (Refund_Against_BillNo != "")
            return Refund_Against_BillNo;
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string saveOPDSettlement(object PaymentDetail, object OPDDiscount, string hashCode, string AmountPaid, string PatientID, string TransactionID, string LedgerTranNo, string Naration, int PanelID, string IsRefund, string netAmount, decimal advanceAmt, string TypeOfTnx, string feePaid, int IsNewPatient, int centreId)
    {
        string Receipt_No = "";
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        List<OpdDiscount> dataOPDDiscount = new JavaScriptSerializer().ConvertToType<List<OpdDiscount>>(OPDDiscount);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {

            var isInCredit = dataPaymentDetail.Where(i => i.PaymentModeID == 4).ToList();
            if(isInCredit.Count >0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Settlement Not Possiable In Credit Mode", message = "Error In Receipt" });
                   


            decimal refund = 1;
            if (IsRefund == "1")
                refund = -1;
            Receipt objRecipt = new Receipt(tnx);
           
            objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objRecipt.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);

           
            objRecipt.AmountPaid = Util.GetDecimal(Util.GetDecimal(AmountPaid) * refund);
            objRecipt.AsainstLedgerTnxNo = LedgerTranNo;
            objRecipt.PanelID = PanelID;
            objRecipt.Date = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"));
            objRecipt.Time = Util.GetDateTime(System.DateTime.Now.ToString("HH:mm:ss"));
            objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objRecipt.Reciever = HttpContext.Current.Session["ID"].ToString();
            objRecipt.Depositor = PatientID;
            objRecipt.TransactionID = TransactionID;
            objRecipt.Naration = Naration;
            if (IsRefund == "0")
                objRecipt.RoundOff = Util.GetDecimal(dataOPDDiscount[0].RoundOff);
            objRecipt.PaidBy = "PAT";
            objRecipt.UniqueHash = hashCode;
            objRecipt.IpAddress = All_LoadData.IpAddress();
            objRecipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
           // objRecipt.CentreID = Util.GetInt(centreId);
            if (TypeOfTnx == "Pharmacy-Issue" || TypeOfTnx == "Pharmacy-Return")
            {
                objRecipt.LedgerNoDr = "STO00001";
               
            }
            else
            {
                objRecipt.LedgerNoDr = "HOSP0005";
               
            }
            Receipt_No = objRecipt.Insert();
            if (string.IsNullOrEmpty(Receipt_No))
                {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt" });
                }
            int isAdvance = 0;
            Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
            for (int i = 0; i < dataPaymentDetail.Count; i++)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                ObjReceiptPayment.Amount = Util.GetDecimal(Util.GetDecimal(dataPaymentDetail[i].Amount) * refund);
                ObjReceiptPayment.ReceiptNo = Receipt_No;
                ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(Util.GetDecimal(dataPaymentDetail[i].S_Amount) * refund);
                ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);
                ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(dataPaymentDetail[i].currencyRoundOff);
                ObjReceiptPayment.swipeMachine = Util.GetString(dataPaymentDetail[i].swipeMachine);
                ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
             //   ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceiptPayment.CentreID = Util.GetInt(centreId);
                string PaymentID = ObjReceiptPayment.Insert().ToString();
                if (string.IsNullOrEmpty(PaymentID))
                    {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt Payment" });
                    }
                if ((dataPaymentDetail[i].PaymentModeID == 7) && (Util.GetDecimal(advanceAmt) > 0))
                {
                    isAdvance += 1;
                    DataTable dt = MySqlHelper.ExecuteDataset(con,CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmt,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE PatientID ='" + PatientID + "'  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmt,0))>0 ORDER BY ID+0").Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        decimal advanceAmount = dataPaymentDetail[i].Amount;
                        for (int s = 0; s < dt.Rows.Count; s++)
                        {
                            decimal paidAmt = 0;

                            if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(advanceAmount) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");
                                paidAmt = advanceAmount;
                               
                                advanceAmount = 0;
                            }
                            else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");
                                
                                advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                            }

                            OPD_Advance_Detail advd = new OPD_Advance_Detail(tnx);
                            advd.PaidAmount = Util.GetDecimal(paidAmt);
                            advd.PatientID = PatientID;
                            advd.TransactionID = TransactionID;
                            advd.LedgerTransactionNo = LedgerTranNo;
                            advd.ReceiptNo = Receipt_No;
                           
                           // advd.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            advd.CentreID = Util.GetInt(centreId);

                            advd.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            advd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                            advd.AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString());
                            advd.ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString();
                            advd.Insert();

                            if (advanceAmount == 0)
                                break;
                        }
                    }


                }
            }
           
            if (IsRefund == "0")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_ledgertransaction SET IsPaid=1,Adjustment=Adjustment+" + Util.GetDecimal(dataOPDDiscount[0].Adjustment) * Util.GetDecimal(refund) + ",AdjustmentDate=now()");
                if ((Util.GetDecimal(dataOPDDiscount[0].DiscAmt) > 0) || (Util.GetDecimal(dataOPDDiscount[0].DiscountPercentage) > 0))
                {
                    sb.Append(" ,NetAmount='" + Util.GetDecimal(dataOPDDiscount[0].netAmount) + "' ");
                    sb.Append(" ,DiscountReason='" + dataOPDDiscount[0].DiscountReason + "'");
                    sb.Append(" ,DiscountOnTotal='" + dataOPDDiscount[0].DiscountOnTotal + "' ");
                    sb.Append(" ,DiscountApproveBy='" + dataOPDDiscount[0].DiscountApproveBy + "' ");
                }
                sb.Append(" ,PaymentModeID=" + Util.GetInt(dataPaymentDetail[0].PaymentModeID) + "");
                sb.Append(" ,RoundOff='" + Util.GetDecimal(dataOPDDiscount[0].RoundOff) + "' ");
                sb.Append(" WHERE LedgerTransactionNo='" + LedgerTranNo + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" UPDATE f_ledgertnxdetail SET DiscountReason='" + dataOPDDiscount[0].DiscountReason + "' ");
                if ((Util.GetDecimal(dataOPDDiscount[0].DiscAmt) > 0) || (Util.GetDecimal(dataOPDDiscount[0].DiscountPercentage) > 0))
                {
                    sb1.Append(" ,DiscAmt=(Rate*Quantity)*" + Util.GetDecimal(dataOPDDiscount[0].DiscountPercentage) + "/100 ");
                    sb1.Append(" ,TotalDiscAmt=(Rate*Quantity)*" + Util.GetDecimal(dataOPDDiscount[0].DiscountPercentage) + "/100 ");
                    sb1.Append(" ,DiscountPercentage='" + Util.GetDecimal(dataOPDDiscount[0].DiscountPercentage) + "' ");
                    sb1.Append(" ,Amount=(Rate*Quantity)-((Rate*Quantity*" + dataOPDDiscount[0].DiscountPercentage + ")/100) ");
                    sb1.Append(" ,NetItemAmt=(Rate*Quantity)-((Rate*Quantity*" + dataOPDDiscount[0].DiscountPercentage + ")/100) ");
                    sb1.Append(" ,DiscUserID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
                }
                sb1.Append(" WHERE LedgerTransactionNo='" + LedgerTranNo + "'");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());

                string UpdatePMH = "UPDATE f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID SET PatientPaidAmt= IFNULL(PatientPaidAmt,0) +" + Util.GetDecimal(dataOPDDiscount[0].Adjustment) * Util.GetDecimal(refund) + " WHERE lt.LedgerTransactionNo='" + LedgerTranNo + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdatePMH);
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_ledgertransaction SET IsPaid=1,Adjustment=Adjustment+" + Util.GetDecimal(dataOPDDiscount[0].Adjustment) * Util.GetDecimal(refund) + ",AdjustmentDate=now()");
                sb.Append(" ,PaymentModeID=" + Util.GetInt(dataPaymentDetail[0].PaymentModeID) + "");
                sb.Append(" ,RoundOff='" + Util.GetDecimal(dataOPDDiscount[0].RoundOff) + "' ");
                sb.Append(" WHERE LedgerTransactionNo='" + LedgerTranNo + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                string UpdatePMH = "UPDATE f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID SET PatientPaidAmt= IFNULL(PatientPaidAmt,0) +" + Util.GetDecimal(dataOPDDiscount[0].Adjustment) * Util.GetDecimal(refund) + " WHERE lt.LedgerTransactionNo='" + LedgerTranNo + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdatePMH);

            }


            //////////Update Patient Master//////////////////
           // string FeePaid = StockReports.ExecuteScalar("Select FeesPaid from patient_master where PatientID ='" + PatientID + "' And  PatientType='1' ");

            if (feePaid == Util.GetString("0") && (PatientID !="CASH002") && (IsNewPatient==1))
            {
                string itemID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT ltd.ItemID FROM  f_ledgertnxdetail ltd WHERE  ltd.LedgerTransactionNo='" + LedgerTranNo + "'  "));                     
                if (itemID == Resources.Resource.RegistrationItemID)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update Patient_Master set FeesPaid='1' where PatientID='" + PatientID + "' ");
                }
            }
            //////////End Patient Master//////////////////

            //Devendra Singh 2018-10-10 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = string.Empty;
                if (TypeOfTnx.ToUpper() == "EMERGENCY")
                    IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(0, Receipt_No, "S","", tnx));
                else
                    IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(0, Receipt_No, "S", tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }


            if (TypeOfTnx == "Pharmacy-Return")
            {

                decimal DebitAmount = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT IFNULL(SUM(pa.`Amount`),0) FROM panel_amountallocation  pa WHERE pa.`TransactionID`='"+TransactionID+"' AND pa.`PanelID`='"+PanelID+"'  "));

                if (DebitAmount<0)
                {

                    StringBuilder sqlcm = new StringBuilder("INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@ApprovalAmount,@EntryBy,'CR') ");

                    int res = excuteCMD.DML(tnx, sqlcm.ToString(), CommandType.Text, new
                    {
                        transactionID = TransactionID,
                        ApprovalAmount = DebitAmount*refund,
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        panelID = Util.GetInt(PanelID),
                    });



                    StringBuilder sqlledgUpdateNew = new StringBuilder("UPDATE f_ledgertransaction lt SET lt.AsainstLedgerTnxNo=@AsainstLedgerTnxNo  WHERE lt.`LedgertransactionNo`=@LedgertransactionNo ");

                    int resUpdateNew = excuteCMD.DML(tnx, sqlledgUpdateNew.ToString(), CommandType.Text, new
                    {
                        AsainstLedgerTnxNo = LedgerTranNo,
                        LedgertransactionNo = LedgerTranNo,
                    });



                }


            }





            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", LedgerTranNo = LedgerTranNo, Receipt_No = Receipt_No });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchOPDBills(string MRNo, string panelID, string fromDate, string toDate, string centreId, string billNo,string encounterno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.* FROM (");
        sb.Append(" SELECT fpm.Company_Name,lt.id,lt.EncounterNo,cm.CentreName,lt.CentreID,lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') BillDate,lt.PatientID PatientID,lt.TransactionID TransactionID, ROUND(lt.NetAmount,2) NetAmount,  ");
        // sb.Append(" lt.Adjustment PaidAmt,(pmh.PatientPaybleAmt-pmh.PatientPaidAmt)  PendingAmt,if((lt.NetAmount-lt.Adjustment)<0,'Refund','Settlement')SettlementType,lt.GrossAmount,IFNULL(pm.FeesPaid,0)FeesPaid,pmh.IsNewPatient,  ");

        //  sb.Append(" lt.Adjustment PaidAmt,(lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' ");
        //  sb.Append("AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa ");
        //  sb.Append("WHERE pa.TransactionID=pmh.TransactionID),0)) PendingAmt,if((lt.NetAmount-lt.Adjustment)<0,'Refund','Settlement')SettlementType,lt.GrossAmount,IFNULL(pm.FeesPaid,0)FeesPaid,pmh.IsNewPatient,  ");

        sb.Append("  IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0) PaidAmt, ");
        //sb.Append("  IF(pmh.type='EMG',ROUND(lt.NetAmount,2)-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0),IFNULL((pmh.PatientPaybleAmt-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT'  ");
        //sb.Append("  AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)- IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa WHERE pa.TransactionID=pmh.TransactionID),0)),0)) PendingAmt, ");
        //sb.Append("  IF(IFNULL((pmh.PatientPaybleAmt-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT'  ");
        //sb.Append(" AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa WHERE pa.TransactionID=pmh.TransactionID),0)),0)<0,'Refund','Settlement')SettlementType,
        
        sb.Append("IFNULL((ROUND(lt.NetAmount,2)-IFNULL(ROUND((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT'    ");
	    sb.Append("AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),2),0)- IFNULL(ROUND((SELECT SUM(Amount) FROM panel_amountallocation pa   ");
	    sb.Append("WHERE pa.TransactionID=pmh.TransactionID),2),0)),0) PendingAmt,     ");
	    sb.Append("IF(IFNULL((ROUND(lt.NetAmount,2)-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT'     ");
	    sb.Append("AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa   ");
        sb.Append("WHERE pa.TransactionID=pmh.TransactionID),0)),0)<0,'Refund','Settlement')SettlementType,  ");
        
        sb.Append("lt.GrossAmount,IFNULL(pm.FeesPaid,0)FeesPaid,pmh.IsNewPatient,  ");

        sb.Append(" IF(pm.PatientID<>'CASH002',CONCAT(pm.title,' ',pm.Pname),(SELECT  CONCAT(title,' ',NAME)  FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))PatientName, ");
        sb.Append(" IF(pm.PatientID<>'CASH002','',(SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))CustomerID, ");
        sb.Append(" lt.LedgerTransactionNo,fpm.Company_Name CompanyName,lt.PanelID,ROUND(lt.NetAmount,2) Amount , ");
        sb.Append(" lt.Roundoff,lt.GovtaxAmount,ROUND((lt.NetAmount-lt.GovtaxAmount-lt.roundoff),2)NetAmtBeforeTax,lt.TypeOfTnx,lt.DeptLedgerNo ,");
        sb.Append(" IFNULL((SELECT IFNULL(SUM(IFNULL(AdvanceAmount,0)-IFNULL(BalanceAmt,0)),0)AdvanceAmount FROM OPD_Advance WHERE PatientID=lt.PatientID AND IsCancel=0 GROUP BY PatientID),0)AdvanceAmount ");
        sb.Append(" FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN Center_master cm ON lt.CentreID=cm.CentreID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID   ");
       // sb.Append("   where lt.IsCancel=0 AND pmh.Type='OPD' AND lt.PaymentModeID NOT IN(4,5) ");
        sb.Append("   where lt.IsCancel=0 AND pmh.Type IN('OPD','EMG') AND lt.PaymentModeID NOT IN (8) ");
      //  sb.Append(" and lt.TypeOfTnx not in ('Pharmacy-Issue','Pharmacy-Return')");
        if (encounterno != string.Empty)
            sb.Append("     AND lt.EncounterNo='" + encounterno + "' ");
        if (MRNo != string.Empty)
            sb.Append("     AND lt.PatientID='" + MRNo + "' ");
        if (billNo != string.Empty)
            sb.Append("     AND lt.BillNo='" + billNo + "' ");
        if (panelID != string.Empty)
            sb.Append("and pmh.PanelID=" + panelID + " ");
        if (MRNo == string.Empty && billNo == string.Empty)
        {
            if (fromDate != string.Empty)
                sb.Append(" AND lt.Date >='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'");

            if (toDate != string.Empty)
                sb.Append(" AND lt.Date <='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'   ");
        }
        sb.Append("  AND  lt.CentreID IN (" + centreId + ") AND lt.Adjustment <> lt.NetAmount AND ifnull(lt.BillNo,'')<>''  AND IFNULL(lt.`AsainstLedgerTnxNo`,'')=''  GROUP BY lt.LedgerTransactionNo)t where t.PendingAmt <>0  ");
        sb.Append(" Order by t.id desc ");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
        if (dtSearch.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
        else
            return "";

    }

    [WebMethod(EnableSession = true)]
    public static string GetPanels()
    {
        DataTable dtPanel = All_LoadData.LoadPanelOPD();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSearchFromDate.Text = txtSearchToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExdSearchToDate.EndDate = System.DateTime.Now;
            calExdTxtSearchFromDate.EndDate = System.DateTime.Now;
        }
    }

    private void bindPanel()
    {
        //DataTable dtPanel = All_LoadData.LoadPanelOPD();
        //ddlRegPanel.DataSource = dtPanel;
        //ddlRegPanel.DataTextField = "Company_Name";
        //ddlRegPanel.DataValueField = "PanelID";
        //ddlRegPanel.DataBind();
        //ddlRegPanel.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    public static string bindIsallowpartilpayment()
    {
        string Allowpartialpayment = Util.GetString(StockReports.ExecuteScalar("SELECT Allowpartialpayment FROM employee_master WHERE employeeid='" + HttpContext.Current.Session["ID"] + "'"));
        if (Allowpartialpayment != "")
            return Allowpartialpayment;
        else
            return "";
    }
   

}