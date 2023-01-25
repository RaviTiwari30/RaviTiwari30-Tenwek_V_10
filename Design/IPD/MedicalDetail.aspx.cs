using System;
using System.Data;
using System.Web.UI;
using System.Text;
public partial class Design_EMR_MedicalDetail : System.Web.UI.Page
{
    DataSet ds;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] != null)
        {
            string TransactionID = Request.QueryString["TransactionID"].ToString();


            AllQuery AQ = new AllQuery();
            DataTable dtpt = AQ.GetPatientDischargeStatus(TransactionID);
            

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
            
           
            ViewState.Add("ds", ds);


            if (!IsPostBack)
                LoadReceipt();
                

            //==================================================================

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
    private DataTable Findsurgery(string TransID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" select sd.TransactionID,sd.PatientID,");
        sb.Append(" from f_surgery_discription sd INNER JOIN f_ledgertnxdetail ltd ON ");
        sb.Append(" sd.LedgerTransactionNo = ltd.LedgerTransactionNo WHERE ltd.IsSurgery=1 AND ltd.TransactionID='" + TransID + "' ");
        sb.Append(" AND sd.ItemID = ltd.ItemID AND ltd.IsVerified=1");



        DataTable dt = new DataTable();

        return dt;
    }
    protected void btnDetailBill_Click(object sender, EventArgs e)
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


            AllQuery AQ = new AllQuery();
            decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(Request.QueryString["TransactionID"].ToString()));
            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(Request.QueryString["TransactionID"].ToString(),null));
            decimal Dedutions = Util.GetDecimal(AQ.GetTotalDedutions(Request.QueryString["TransactionID"].ToString()));
            decimal TDS = Util.GetDecimal(AQ.GetTDS(Request.QueryString["TransactionID"].ToString()));
            decimal WriteOff = Util.GetDecimal(StockReports.ExecuteScalar("Select WriteOff from Patient_Medical_History where TransactionID='" + Request.QueryString["TransactionID"].ToString() + "'"));

            decimal DiscountOnItem = 0;
            string NetAmount = "";

            DataRow[] DisRow = Table.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

            if (DisRow.Length > 0)
            {
                foreach (DataRow drDis in DisRow)
                {
                    DiscountOnItem = DiscountOnItem + (Util.GetDecimal(drDis["Rate"].ToString()) * Util.GetDecimal(drDis["Quantity"].ToString())) - Util.GetDecimal(drDis["Amount"].ToString());
                }
            }

            //if (chkSuppressReceipt.Checked == false)
            //{
            //    NetAmount = Util.GetString(AmountBilled);
            //}
            //else
            //{
                NetAmount = Util.GetString(AmountBilled - AmountReceived);
           // }

            string DiscountReason = "", TransactionID = "", Narration = "";
            string ServiceTaxPer = "", ServiceTaxAmt = "", ServiceTaxSurChgAmt = "", SerTaxSurChgPer = "", SerTaxBillAmt = "";
            string SAmount = "", SNotation = "", CFactor = "";
            //Checking if final discount is allowed

            if (Request.QueryString["TransactionID"] != null)
            {
                TransactionID = Request.QueryString["TransactionID"].ToString();
            }

            DataTable dt = AQ.GetPatientAdjustmentDetails(TransactionID);

            if (dt != null && dt.Rows.Count > 0)
            {
                NetAmount = Util.GetString(Math.Round(Util.GetDecimal(NetAmount)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + Math.Round(Util.GetDecimal(DiscountOnItem))));
                DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
                Narration = Util.GetString(dt.Rows[0]["Narration"].ToString());
                SAmount = Util.GetString(dt.Rows[0]["S_Amount"].ToString());
                SNotation = Util.GetString(dt.Rows[0]["S_Notation"].ToString());
                CFactor = Util.GetString(dt.Rows[0]["C_Factor"].ToString());

                string IsServiceTax = StockReports.ExecuteScalar("Select IsServiceTax from f_panel_master where PanelID =(Select PanelID from patient_medical_history where TransactionID ='" + dtBilled.Rows[0]["TransactionID"].ToString().Trim() + "')");

                if (dtBilled.Rows[0]["BillNo"].ToString().Trim() == string.Empty && IsServiceTax == "1")
                {

                    ServiceTaxPer = "10";
                    SerTaxSurChgPer = "3";

                    ServiceTaxAmt = "";
                    ServiceTaxSurChgAmt = "";

                    AmountBilled = Util.GetDecimal(Math.Round(Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + Math.Round(Util.GetDecimal(DiscountOnItem))));
                    ServiceTaxAmt = Util.GetString(Math.Round(Util.GetDecimal(AmountBilled * Util.GetDecimal(ServiceTaxPer)) / 100));
                    float SurchargeTaxAmt = Util.GetFloat(Math.Round(Util.GetDouble((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)));
                    NetAmount = Util.GetString(Util.GetFloat(NetAmount) + Util.GetFloat(ServiceTaxAmt) + SurchargeTaxAmt);
                    ServiceTaxSurChgAmt = SurchargeTaxAmt.ToString();
                    SerTaxBillAmt = AmountBilled.ToString();
                }
                else
                {
                    ServiceTaxAmt = Util.GetString(dt.Rows[0]["ServiceTaxAmt"]);
                    ServiceTaxPer = Util.GetString(dt.Rows[0]["ServiceTaxPer"]);
                    ServiceTaxSurChgAmt = Util.GetString(dt.Rows[0]["ServiceTaxSurChgAmt"]);
                    SerTaxSurChgPer = Util.GetString(dt.Rows[0]["SerTaxSurChgPer"]);
                    SerTaxBillAmt = Util.GetString(dt.Rows[0]["SerTaxBillAmount"]);

                    NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(dt.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dt.Rows[0]["ServiceTaxSurChgAmt"]));
                }


            }


            float ReceivedAmtBeforeBill = 0f;

            if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
            {
                ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID ='" + Request.QueryString["TransactionID"].ToString() + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID "));
            }
            else
            {
                ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID ='" + Request.QueryString["TransactionID"].ToString() + "' AND IsCancel = 0 GROUP BY TransactionID "));

            }
           

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
            //if (chkSuppressReceipt.Checked == true)
            //{
            //    row["ShowReceipt"] = "1";
            //}
            //else
            //{
                row["ShowReceipt"] = "0";
            //}

            row["IsBilledClosed"] = Util.GetString(dt.Rows[0]["IsBilledClosed"]);

            //if (chkSuppressReceipt.Checked)
            //{
            //    row["ReceivedAmtBeforeBill"] = Util.GetString(ReceivedAmtBeforeBill);
            //    row["ReceivedAmtAfterBill"] = Util.GetString(ReceivedAmtAfterBill);
            //}
            //else
            //{
                row["ReceivedAmtBeforeBill"] = Util.GetString("0");
                row["ReceivedAmtAfterBill"] = Util.GetString("0");
           // }


            dtNetAmtWord.Rows.Add(row);
            Session["dtNetAmtWord"] = dtNetAmtWord;

            DataTable dtReceipt = new DataTable();
            dtReceipt = ((DataTable)ViewState["dtReceipt"]).Clone();
            //foreach (GridViewRow gr in grdReceipt.Rows)
            //{
            //    if (((CheckBox)gr.FindControl("chkSelect")).Checked)
            //    {
            //        DataRow dr = dtReceipt.NewRow();
            //        dr["ReceiptNo"] = ((Label)gr.FindControl("lblReceipt")).Text;
            //        dr["AmountPaid"] = ((Label)gr.FindControl("lblAmountPaid")).Text;
            //        dr["Date"] = ((Label)gr.FindControl("lblDate")).Text;
            //        dr["Type"] = ((Label)gr.FindControl("lblType")).Text;
            //        //dr["IsCheque_Draft"] = ((Label)gr.FindControl("lblPayMode")).Text;
            //        dr["TransactionID"] = ((Label)gr.FindControl("lblTransactionID")).Text;

            //        dtReceipt.Rows.Add(dr);
            //    }
            //}

            if (dtReceipt != null && dtReceipt.Rows.Count == 0)
            {
                DataRow dr = dtReceipt.NewRow();
                dr["ReceiptNo"] = "";
                dr["AmountPaid"] = "0";
                dr["Date"] = "";
                dr["Type"] = "";
                //dr["IsCheque_Draft"] = "";
                dr["TransactionID"] = TransactionID;
                dtReceipt.Rows.Add(dr);
            }

            Session["dtReceipt"] = dtReceipt;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/MedicalReport.aspx?ReportType=2');", true);
            //  ViewState.Add("ds", ds);
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
    }
    private void LoadReceipt()
    {
        DataTable dtReceipt = new DataTable();
        AllQuery AQ = new AllQuery();
        dtReceipt = AQ.GetPatientReceipt(Request.QueryString["TransactionID"].ToString()).Copy();

        
         if (dtReceipt != null && dtReceipt.Rows.Count == 0)
        {
            DataRow dr1 = dtReceipt.NewRow();
            dr1[0] = "";
            dr1[1] = "0";
            dr1[2] = "";
            dr1[3] = "";
            dr1[4] = "";
            dr1[5] = "";
            dtReceipt.Rows.Add(dr1);

           

        }
        ViewState["dtReceipt"] = dtReceipt;

    }
}