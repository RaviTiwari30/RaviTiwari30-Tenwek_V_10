using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class Design_Finance_PatientBillPrint : System.Web.UI.Page
{
    DataSet ds;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] != null)
            {
                string TransactionID = Request.QueryString["TransactionID"].ToString();
                ds = new DataSet();
                ds.Tables.Add(IPDBilling.GetBilledPatientDetail(TransactionID).Copy());
                ds.Tables[0].TableName = "dtBilled";
                ds.Tables.Add(IPDBilling.GetBilledPatientItemDetail(TransactionID).Copy());
                ds.Tables[1].TableName = "dtBilledDetail";
                ds.Tables.Add(IPDBilling.GetPatientPackageDetail(TransactionID).Copy());
                ds.Tables[2].TableName = "dtPackageDetail";
                DataTable dt = LoadPackage(ds.Tables[1]).Copy();
                dt.TableName = "dtPackage";
                ds.Tables.Add(dt);
                if (dt.Rows.Count == 0)
                {
                    //btnPkgBreakup.Enabled = false;
                }
                else
                {
                    //btnPkgBreakup.Enabled = true;
                }
            All_LoadData al=new All_LoadData();
            int i= al.findSurgery(TransactionID);
            if (i == 0)
            {
               // btnSurgeryBreakUp.Enabled = false;
            }
            else
            {
                //btnSurgeryBreakUp.Enabled = true;
            }
                ViewState.Add("ds", ds);


            if(!IsPostBack)
                LoadReceipt();                           
            }
        }
    private DataTable Findsurgery(string TransID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select sd.TransactionID,sd.Patient_ID,");
        sb.Append(" from f_surgery_discription sd INNER JOIN f_ledgertnxdetail ltd ON ");
        sb.Append(" sd.LedgerTransactionNo = ltd.LedgerTransactionNo WHERE ltd.IsSurgery=1 AND ltd.Transaction_ID='" + TransID + "' ");
        sb.Append(" AND sd.ItemID = ltd.ItemID AND ltd.IsVerified=1");     
        DataTable dt = new DataTable();     
        return dt;
    }
    protected void  btnSummaryBill_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = (DataSet)ViewState["ds"];
            DataTable Table = new DataTable();
            Table = ds.Tables["dtBilledDetail"].Copy();
            Table.TableName = "Table";
            Session["Table"] = Table;

            DataTable dtBilled = new DataTable();
            dtBilled = ds.Tables["dtBilled"].Copy();
            Table.TableName = "dtBilled";
            Session["dtBilled"] = dtBilled;

            DataTable dtNetAmtWord = new DataTable();
            dtNetAmtWord.TableName = "dtNetAmtWord";
            dtNetAmtWord.Columns.Add("BilledAmt");
            dtNetAmtWord.Columns.Add("ReceivedAmt");
            dtNetAmtWord.Columns.Add("ReceivedAmtBeforeBill");
            dtNetAmtWord.Columns.Add("ReceivedAmtAfterBill");
            dtNetAmtWord.Columns.Add("NetAmount");
            dtNetAmtWord.Columns.Add("NetAmountWord");
            dtNetAmtWord.Columns.Add("DiscountReason");
            dtNetAmtWord.Columns.Add("ShowReceipt");
            dtNetAmtWord.Columns.Add("Narration");
            dtNetAmtWord.Columns.Add("ServiceTaxAmt");
            dtNetAmtWord.Columns.Add("ServiceTaxPer");
            dtNetAmtWord.Columns.Add("ServiceTaxSurChgAmt");
            dtNetAmtWord.Columns.Add("SerTaxSurChgPer");
            dtNetAmtWord.Columns.Add("SerTaxBillAmt");
            dtNetAmtWord.Columns.Add("IsBilledClosed");
            dtNetAmtWord.Columns.Add("Dedutions");
            dtNetAmtWord.Columns.Add("TDS");
            dtNetAmtWord.Columns.Add("WriteOff");
            dtNetAmtWord.Columns.Add("S_Amount");
            dtNetAmtWord.Columns.Add("S_Notation");
            dtNetAmtWord.Columns.Add("C_Factor");
            dtNetAmtWord.Columns.Add("RoundOff");
            dtNetAmtWord.Columns.Add("CreditLimit");
            dtNetAmtWord.Columns.Add("CreditLimitType");
            AllQuery AQ = new AllQuery();
            decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(Request.QueryString["Transaction_ID"].ToString()));
            
            float Dedutions =  Util.GetFloat(AQ.GetTotalDedutions(Request.QueryString["Transaction_ID"].ToString()));
            float TDS = Util.GetFloat(AQ.GetTDS(Request.QueryString["Transaction_ID"].ToString()));
            float WriteOff = Util.GetFloat(StockReports.ExecuteScalar("Select WriteOff from Patient_Medical_History where Transaction_ID='" + Request.QueryString["Transaction_ID"].ToString() + "'"));

            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(Request.QueryString["Transaction_ID"].ToString()));
            float DiscountOnItem = 0f;
            string NetAmount = "";

            DataRow[] DisRow = Table.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

            if (DisRow.Length > 0)
            {
                foreach (DataRow drDis in DisRow)
                {
                    DiscountOnItem = DiscountOnItem + (Util.GetFloat(drDis["Rate"].ToString()) * Util.GetFloat(drDis["Quantity"].ToString())) - Util.GetFloat(drDis["Amount"].ToString());
                }
            }

            if (chkSuppressReceipt.Checked == false)
            {
                NetAmount = Util.GetString(AmountBilled);
            }
            else
            {
                NetAmount = Util.GetString(AmountBilled - AmountReceived);
            }

            string DiscountReason = "", TransactionID="",Narration="";
            string ServiceTaxPer = "", ServiceTaxAmt = "", ServiceTaxSurChgAmt = "", SerTaxSurChgPer = "",SerTaxBillAmt="";
            string SAmount = "", SNotation = "", CFactor = "",CreditLimitType=""; decimal CreditLimit = 0; 
            decimal RoundOff = 0;
            //Checking if final discount is allowed

            if (Request.QueryString["Transaction_ID"] != null)
            {
                TransactionID = Request.QueryString["Transaction_ID"].ToString();
            }
            
            DataTable dt = AQ.GetPatientAdjustmentDetails(TransactionID);

           if (dt != null && dt.Rows.Count > 0)
            {
                NetAmount = Util.GetString((Util.GetDecimal(NetAmount)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
                DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
                Narration = Util.GetString(dt.Rows[0]["Narration"].ToString());
                SAmount = Util.GetString(dt.Rows[0]["S_Amount"].ToString());
                SNotation = Util.GetString(dt.Rows[0]["S_Notation"].ToString());
                CFactor = Util.GetString(dt.Rows[0]["C_Factor"].ToString());
                CreditLimit = Util.GetDecimal(dt.Rows[0]["CreditLimitPanel"].ToString());
                CreditLimitType = Util.GetString(dt.Rows[0]["CreditLimitType"].ToString());
               // string IsServiceTax = StockReports.ExecuteScalar("Select IsServiceTax from f_panel_master where Panel_ID =(Select Panel_ID from patient_medical_history where Transaction_ID ='" + dtBilled.Rows[0]["Transaction_ID"].ToString().Trim() + "')");

                if (dtBilled.Rows[0]["BillNo"].ToString().Trim() == string.Empty )
                {

                    ServiceTaxPer = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
                    SerTaxSurChgPer = "0";
                    
                    ServiceTaxAmt = "";
                    ServiceTaxSurChgAmt = "";
                    
                    AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
                    ServiceTaxAmt = Util.GetString(Math.Round((Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100), 2, MidpointRounding.AwayFromZero));

                    decimal SurchargeTaxAmt = Util.GetDecimal(Math.Round((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)), 2, MidpointRounding.AwayFromZero));
                    NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
                    ServiceTaxSurChgAmt = SurchargeTaxAmt.ToString();
                    SerTaxBillAmt = AmountBilled.ToString();
                    decimal Round = Math.Round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)), MidpointRounding.AwayFromZero);
                    RoundOff = Util.GetDecimal(Round) - Util.GetDecimal(AmountBilled) - Util.GetDecimal(ServiceTaxAmt);
                   
                }
                else
                {
                    ServiceTaxAmt = Util.GetString(dt.Rows[0]["ServiceTaxAmt"]);
                    ServiceTaxPer = Util.GetString(dt.Rows[0]["ServiceTaxPer"]);
                    ServiceTaxSurChgAmt = Util.GetString(dt.Rows[0]["ServiceTaxSurChgAmt"]);
                    SerTaxSurChgPer = Util.GetString(dt.Rows[0]["SerTaxSurChgPer"]);
                    SerTaxBillAmt = Util.GetString(dt.Rows[0]["SerTaxBillAmount"]);

                    NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(dt.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dt.Rows[0]["ServiceTaxSurChgAmt"]));
                    RoundOff = Util.GetDecimal(dt.Rows[0]["RoundOff"]);
                }                              
            }

            float ReceivedAmtBeforeBill = 0f, ReceivedAmtAfterBill = 0f;

            if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
                ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY Transaction_ID "));
            else
                ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 GROUP BY Transaction_ID "));

            if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
                ReceivedAmtAfterBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 and Date(Date) >'" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY Transaction_ID "));
            
            DataRow row = dtNetAmtWord.NewRow();
            row["BilledAmt"] = AmountBilled.ToString();
            row["ReceivedAmt"] = AmountReceived.ToString();
            row["NetAmount"] = NetAmount;
            row["DiscountReason"] = DiscountReason;
            row["Narration"] = Narration;
            row["ServiceTaxAmt"] = ServiceTaxAmt;
            row["ServiceTaxPer"] = ServiceTaxPer;
            row["ServiceTaxSurChgAmt"] = ServiceTaxSurChgAmt;
            row["SerTaxSurChgPer"] = SerTaxSurChgPer;
            row["SerTaxBillAmt"] = SerTaxBillAmt;
            row["Dedutions"] = Dedutions;
            row["TDS"] = TDS;
            row["WriteOff"] = WriteOff;
            row["S_Amount"] = SAmount;
            row["S_Notation"] = SNotation;
            row["C_Factor"] = CFactor;
            row["RoundOff"] = RoundOff;
            row["CreditLimit"] = CreditLimit;
            row["CreditLimitType"] = CreditLimitType;
            if (chkSuppressReceipt.Checked == true)
            {
                row["ShowReceipt"] = "1";
            }
            else
            {
                row["ShowReceipt"] = "0";
            }
            row["IsBilledClosed"] = Util.GetString(dt.Rows[0]["IsBilledClosed"]);
            
	    if (chkSuppressReceipt.Checked)
            {
                row["ReceivedAmtBeforeBill"] = Util.GetString(ReceivedAmtBeforeBill);
                row["ReceivedAmtAfterBill"] = Util.GetString(ReceivedAmtAfterBill);
            }
            else
            {
                row["ReceivedAmtBeforeBill"] = Util.GetString("0");
                row["ReceivedAmtAfterBill"] = Util.GetString("0");
            }


            dtNetAmtWord.Rows.Add(row);
            Session["dtNetAmtWord"] = dtNetAmtWord;

            DataTable dtReceipt = new DataTable();
            dtReceipt = ((DataTable)ViewState["dtReceipt"]).Clone();
            foreach (GridViewRow gr in grdReceipt.Rows)
            {
                if (((CheckBox)gr.FindControl("chkSelect")).Checked)
                {
                    DataRow dr = dtReceipt.NewRow();
                    dr["ReceiptNo"] = ((Label)gr.FindControl("lblReceipt")).Text;
                    dr["AmountPaid"] = ((Label)gr.FindControl("lblAmountPaid")).Text;
                    dr["Date"] = ((Label)gr.FindControl("lblDate")).Text;
                    dr["Type"] = ((Label)gr.FindControl("lblType")).Text;
                    dr["Transaction_ID"] = ((Label)gr.FindControl("lblTID")).Text;
                    dtReceipt.Rows.Add(dr);
                }
            }

            if (dtReceipt != null && dtReceipt.Rows.Count == 0)
            {
                DataRow dr = dtReceipt.NewRow();
                dr["ReceiptNo"] = "";
                dr["AmountPaid"] = "0";
                dr["Date"] = "";
                dr["Type"] = "";
                dr["Transaction_ID"] = TransactionID;
                dtReceipt.Rows.Add(dr);
            }

           
            Session["dtReceipt"] = dtReceipt;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/BillReport.aspx?ReportType=1');", true);
            ViewState.Add("ds", ds);
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
    }
    protected void  btnDetailBill_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = (DataSet)ViewState["ds"];
            DataTable Table = new DataTable();
            Table = ds.Tables["dtBilledDetail"].Copy();
            Table.TableName = "Table";
            Session["Table"] = Table;

            DataTable dtBilled = new DataTable();
            dtBilled = ds.Tables["dtBilled"].Copy();
            Table.TableName = "dtBilled";
            Session["dtBilled"] = dtBilled;
            DataTable dtNetAmtWord = new DataTable();
            dtNetAmtWord.TableName = "dtNetAmtWord";
            dtNetAmtWord.Columns.Add("BilledAmt");
            dtNetAmtWord.Columns.Add("ReceivedAmt");
            dtNetAmtWord.Columns.Add("ReceivedAmtBeforeBill");
            dtNetAmtWord.Columns.Add("ReceivedAmtAfterBill");
            dtNetAmtWord.Columns.Add("NetAmount");
            dtNetAmtWord.Columns.Add("NetAmountWord");
            dtNetAmtWord.Columns.Add("DiscountReason");
            dtNetAmtWord.Columns.Add("ShowReceipt");
            dtNetAmtWord.Columns.Add("Narration");
            dtNetAmtWord.Columns.Add("ServiceTaxAmt");
            dtNetAmtWord.Columns.Add("ServiceTaxPer");
            dtNetAmtWord.Columns.Add("ServiceTaxSurChgAmt");
            dtNetAmtWord.Columns.Add("SerTaxSurChgPer");
            dtNetAmtWord.Columns.Add("SerTaxBillAmt");
            dtNetAmtWord.Columns.Add("IsBilledClosed");
            dtNetAmtWord.Columns.Add("Dedutions");
            dtNetAmtWord.Columns.Add("TDS");
            dtNetAmtWord.Columns.Add("WriteOff");
            dtNetAmtWord.Columns.Add("S_Amount");
            dtNetAmtWord.Columns.Add("S_Notation");
            dtNetAmtWord.Columns.Add("C_Factor");
            dtNetAmtWord.Columns.Add("RoundOff");
            dtNetAmtWord.Columns.Add("CreditLimit");
            dtNetAmtWord.Columns.Add("CreditLimitType");
            AllQuery AQ = new AllQuery();
            decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(Request.QueryString["Transaction_ID"].ToString()));
            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(Request.QueryString["Transaction_ID"].ToString()));
            float Dedutions = Util.GetFloat(AQ.GetTotalDedutions(Request.QueryString["Transaction_ID"].ToString()));
            float TDS = Util.GetFloat(AQ.GetTDS(Request.QueryString["Transaction_ID"].ToString()));
            float WriteOff = Util.GetFloat(StockReports.ExecuteScalar("Select WriteOff from Patient_Medical_History where Transaction_ID='" + Request.QueryString["Transaction_ID"].ToString() + "'"));

            float DiscountOnItem = 0f;
            string NetAmount = "";

            DataRow[] DisRow = Table.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

            if (DisRow.Length > 0)
            {
                foreach (DataRow drDis in DisRow)
                {
                    DiscountOnItem = DiscountOnItem + (Util.GetFloat(drDis["Rate"].ToString()) * Util.GetFloat(drDis["Quantity"].ToString())) - Util.GetFloat(drDis["Amount"].ToString());
                }
            }

            if (chkSuppressReceipt.Checked == false)
            {
                NetAmount = Util.GetString(AmountBilled);
            }
            else
            {
                NetAmount = Util.GetString(AmountBilled - AmountReceived);
            }

            string DiscountReason = "", TransactionID = "", Narration = "";
            string ServiceTaxPer = "", ServiceTaxAmt = "", ServiceTaxSurChgAmt = "", SerTaxSurChgPer = "", SerTaxBillAmt = "";
            string SAmount = "", SNotation = "", CFactor="";
            decimal RoundOff=0;decimal CreditLimit=0;string CreditLimitType=""; 
            //Checking if final discount is allowed

            if (Request.QueryString["Transaction_ID"] != null)
            {
                TransactionID = Request.QueryString["Transaction_ID"].ToString();
            }

            DataTable dt = AQ.GetPatientAdjustmentDetails(TransactionID);

            if (dt != null && dt.Rows.Count > 0)
            {
                NetAmount = Util.GetString((Util.GetDecimal(NetAmount)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
                DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
                Narration = Util.GetString(dt.Rows[0]["Narration"].ToString());
                SAmount = Util.GetString(dt.Rows[0]["S_Amount"].ToString());
                SNotation = Util.GetString(dt.Rows[0]["S_Notation"].ToString());
                CFactor = Util.GetString(dt.Rows[0]["C_Factor"].ToString());
                CreditLimit=Util.GetDecimal(dt.Rows[0]["CreditLimitPanel"].ToString());
                CreditLimitType=Util.GetString(dt.Rows[0]["CreditLimitType"].ToString());
             //   string IsServiceTax = StockReports.ExecuteScalar("Select IsServiceTax from f_panel_master where Panel_ID =(Select Panel_ID from patient_medical_history where Transaction_ID ='" + dtBilled.Rows[0]["Transaction_ID"].ToString().Trim() + "')");

                if (dtBilled.Rows[0]["BillNo"].ToString().Trim() == string.Empty )
                {

                    ServiceTaxPer = Util.GetString(All_LoadData.GovTaxPer()).ToString();
                    SerTaxSurChgPer = "0";

                    ServiceTaxAmt = "";
                    ServiceTaxSurChgAmt = "";

                    AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) +(Util.GetDecimal(DiscountOnItem))));
                    ServiceTaxAmt = Util.GetString(Math.Round( (Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100),2,MidpointRounding.AwayFromZero));
                    decimal SurchargeTaxAmt = Util.GetDecimal(Math.Round((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)),2,MidpointRounding.AwayFromZero));
                    NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
                    ServiceTaxSurChgAmt = SurchargeTaxAmt.ToString();
                    SerTaxBillAmt = AmountBilled.ToString();
                    decimal Round = Math.Round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)), MidpointRounding.AwayFromZero);
                    RoundOff =Util.GetDecimal(Round)- (Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(ServiceTaxAmt)) ;
                }
                else
                {
                    ServiceTaxAmt = Util.GetString(dt.Rows[0]["ServiceTaxAmt"]);
                    ServiceTaxPer = Util.GetString(dt.Rows[0]["ServiceTaxPer"]);
                    ServiceTaxSurChgAmt = Util.GetString(dt.Rows[0]["ServiceTaxSurChgAmt"]);
                    SerTaxSurChgPer = Util.GetString(dt.Rows[0]["SerTaxSurChgPer"]);
                    SerTaxBillAmt = Util.GetString(dt.Rows[0]["SerTaxBillAmount"]);

                    NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(dt.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dt.Rows[0]["ServiceTaxSurChgAmt"]));
                    RoundOff = Util.GetDecimal(dt.Rows[0]["RoundOff"]);
                }
              
            }
            float ReceivedAmtBeforeBill = 0f, ReceivedAmtAfterBill = 0f;

            if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
            {
                string st="SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY Transaction_ID ";
                ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY Transaction_ID "));
            }
            else
            {
                ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 GROUP BY Transaction_ID "));

            }
            //if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
            //    ReceivedAmtAfterBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE Transaction_ID ='" + Request.QueryString["Transaction_ID"].ToString() + "' AND IsCancel = 0 and Date(Date) >'" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY Transaction_ID "));
            

            DataRow row = dtNetAmtWord.NewRow();
            row["BilledAmt"] = AmountBilled.ToString();
            row["ReceivedAmt"] = AmountReceived.ToString();
            row["NetAmount"] = NetAmount;
            row["DiscountReason"] = DiscountReason;
            row["Narration"] = Narration;
            row["ServiceTaxAmt"] = ServiceTaxAmt;
            row["ServiceTaxPer"] = ServiceTaxPer;
            row["ServiceTaxSurChgAmt"] = ServiceTaxSurChgAmt;
            row["SerTaxSurChgPer"] = SerTaxSurChgPer;
            row["SerTaxBillAmt"] = SerTaxBillAmt;
            row["Dedutions"] = Dedutions;
            row["TDS"] = TDS;
            row["WriteOff"] = WriteOff;
            row["S_Amount"] = SAmount;
            row["S_Notation"] = SNotation;
            row["C_Factor"] = CFactor;
            row["RoundOff"] = RoundOff;
            row["CreditLimit"]=CreditLimit;
            row["CreditLimitType"] = CreditLimitType;
            if (chkSuppressReceipt.Checked == true)
            {
                row["ShowReceipt"] = "1";
            }
            else
            {
                row["ShowReceipt"] = "0";
            }

            row["IsBilledClosed"] = Util.GetString(dt.Rows[0]["IsBilledClosed"]);

            if (chkSuppressReceipt.Checked)
            {
                row["ReceivedAmtBeforeBill"] = Util.GetString(ReceivedAmtBeforeBill);
                row["ReceivedAmtAfterBill"] = Util.GetString(ReceivedAmtAfterBill);
            }
            else
            {
                row["ReceivedAmtBeforeBill"] = Util.GetString("0");
                row["ReceivedAmtAfterBill"] = Util.GetString("0");
            }
            dtNetAmtWord.Rows.Add(row);
            Session["dtNetAmtWord"] = dtNetAmtWord;
            DataTable dtReceipt = new DataTable();
            dtReceipt = ((DataTable)ViewState["dtReceipt"]).Clone();
            foreach (GridViewRow gr in grdReceipt.Rows)
            {
                if (((CheckBox)gr.FindControl("chkSelect")).Checked)
                {
                    DataRow dr = dtReceipt.NewRow();
                    dr["ReceiptNo"] = ((Label)gr.FindControl("lblReceipt")).Text;
                    dr["AmountPaid"] = ((Label)gr.FindControl("lblAmountPaid")).Text;
                    dr["Date"] = ((Label)gr.FindControl("lblDate")).Text;
                    dr["Type"] = ((Label)gr.FindControl("lblType")).Text;
                    dr["Transaction_ID"] = ((Label)gr.FindControl("lblTID")).Text;

                    dtReceipt.Rows.Add(dr);
                }
            }
            if (dtReceipt != null && dtReceipt.Rows.Count == 0)
            {
                DataRow dr = dtReceipt.NewRow();
                dr["ReceiptNo"] = "";
                dr["AmountPaid"] = "0";
                dr["Date"] = "";
                dr["Type"] = "";
                dr["Transaction_ID"] = TransactionID;
                dtReceipt.Rows.Add(dr);
            }
            Session["dtReceipt"] = dtReceipt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/BillReport.aspx?ReportType=2');", true);
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
    }
    private DataTable LoadPackage(DataTable dtLoacal)
    {
        DataTable dt = new DataTable();
        dt = dtLoacal.Clone();

        if (dtLoacal != null && dtLoacal.Rows.Count > 0)
        {
            DataRow[] dr = dtLoacal.Select("IsPackage = 1 and IsVerified  = 1");

            if (dr.Length > 0)
            {
                foreach (DataRow row in dr)
                {
                    DataRow nRow = dt.NewRow();
                    nRow.ItemArray = row.ItemArray;
                    dt.Rows.Add(nRow);
                }
            }
        }
        return dt;
    }
    protected void btnPkgBreakup_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = (DataSet)ViewState["ds"];
            
            DataTable dtBilled = new DataTable();
            dtBilled = ds.Tables["dtBilled"].Copy();
            dtBilled.TableName = "dtBilled";
            Session["dtBilled"] = dtBilled;

            DataTable dtPackageDetail = new DataTable();
            dtPackageDetail = ds.Tables["dtPackageDetail"].Copy();
            dtPackageDetail.TableName = "dtPackageDetail";
            Session["dtPackageDetail"] = dtPackageDetail;

            DataTable dtPackage = new DataTable();
            dtPackage = ds.Tables["dtPackage"].Copy();
            dtPackage.TableName = "dtPackage";
            Session["dtPackage"] = dtPackage;

            DataTable dtNetAmtWord = new DataTable();
            dtNetAmtWord.TableName = "dtNetAmtWord";
            dtNetAmtWord.Columns.Add("BilledAmt");
            dtNetAmtWord.Columns.Add("ReceivedAmt");
            dtNetAmtWord.Columns.Add("NetAmount");
            dtNetAmtWord.Columns.Add("NetAmountWord");
            dtNetAmtWord.Columns.Add("DiscountReason");
            dtNetAmtWord.Columns.Add("ShowReceipt");
            dtNetAmtWord.Columns.Add("Narration");
            dtNetAmtWord.Columns.Add("ServiceTaxAmt");
            dtNetAmtWord.Columns.Add("ServiceTaxPer");
            dtNetAmtWord.Columns.Add("ServiceTaxSurChgAmt");
            dtNetAmtWord.Columns.Add("SerTaxSurChgPer");
            dtNetAmtWord.Columns.Add("SerTaxBillAmt");
            dtNetAmtWord.Columns.Add("IsBilledClosed");
            dtNetAmtWord.Columns.Add("RoundOff");
            DataRow row = dtNetAmtWord.NewRow();
            
            if (chkSuppressReceipt.Checked == true)
            {
                row["ShowReceipt"] = "1";
            }
            else
            {
                row["ShowReceipt"] = "0";
            }

            row["IsBilledClosed"] = StockReports.ExecuteScalar("Select IsBilledClosed from f_ipdAdjustment where Transaction_ID='" + dtBilled.Rows[0]["Transaction_ID"].ToString() + "' ");

            dtNetAmtWord.Rows.Add(row);

            Session["dtNetAmtWord"] = dtNetAmtWord;


            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/BillReport.aspx?ReportType=3');", true);
            ViewState.Add("ds", ds);
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
    }
    protected void btnSurgeryBreakUp_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/IPD/SurgeryBilling.aspx?TransID=" + Request.QueryString["Transaction_ID"].ToString() + "');", true);
    }
    private void LoadReceipt()
    {
        DataTable dtReceipt = new DataTable();
        AllQuery AQ = new AllQuery();
        dtReceipt = AQ.GetPatientReceipt(Request.QueryString["Transaction_ID"].ToString()).Copy();

        if (dtReceipt != null && dtReceipt.Rows.Count > 0)
        {
            grdReceipt.DataSource = dtReceipt;
            grdReceipt.DataBind();

        }
        else if (dtReceipt != null && dtReceipt.Rows.Count == 0)
        {
            DataRow dr1 = dtReceipt.NewRow();
            dr1[0] = "";
            dr1[1] = "0";
            dr1[2] = "";
            dr1[3] = "";
            dr1[4] = "";
            dr1[5] = "";
            dtReceipt.Rows.Add(dr1);

            grdReceipt.DataSource = dtReceipt;
            grdReceipt.DataBind();

        }
        ViewState["dtReceipt"] = dtReceipt;

    }
    protected void chkSuppressReceipt_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSuppressReceipt.Checked)
        {
            foreach (GridViewRow gr in grdReceipt.Rows)
            {
                ((CheckBox)gr.FindControl("chkSelect")).Checked = true;
            }
        }
        else
        {
            foreach (GridViewRow gr in grdReceipt.Rows)
            {
                ((CheckBox)gr.FindControl("chkSelect")).Checked = false;
            }
        }
    }
  
}
