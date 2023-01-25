using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Web.Script.Serialization;
using System.Collections.Generic;

public partial class Design_IPD_ReceiptBill : System.Web.UI.Page
{
    string PatientLedgerNo = "";
    string HospitalLedgerNo = "";
    DataTable dt;
    string BiilNo = "";
    decimal Amount = 0;

    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Panel1.Visible = false;
            txtDepositeNo.Focus();
            // txtDepositeNo.Attributes.Add("onKeyPress", "doClick('" + btnView.ClientID + "',event)");
            // txtCorpseNo.Attributes.Add("onKeyPress", "doClick('" + btnView.ClientID + "',event)");
            // txtCorpseName.Attributes.Add("onKeyPress", "doClick('" + btnView.ClientID + "',event)");
            ViewState["LoginType"] = Session["LoginType"].ToString();
            BindHospLedgerAccount();
            txtHash.Text = Util.getHash();
            chkHospLedger.SelectedIndex = 0;
        }
        lblMsg.Text = "";
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        Panel1.Visible = false;
        GridView1.DataSource = null;
        GridView1.DataBind();
        grdReceipt.DataSource = null;
        grdReceipt.DataBind();

        if (txtDepositeNo.Text == "" && txtCorpseNo.Text == "" && txtCorpseName.Text == "")
        {
            lblMsg.Text = "Please Enter any one Search Criteria..";
            txtDepositeNo.Focus();
            return;
        }

        if (txtCorpseName.Text.Trim() != "" && txtCorpseName.Text.Trim().Length < 3)
        {
            lblMsg.Text = "Please enter atleast three characters to search";
            txtCorpseName.Focus();
            return;
        }

        string CorpseStatus = "";

        if (rdbAdmitted.Checked)
        {
            CorpseStatus = "0";
        }
        else
        {
            CorpseStatus = "1";
        }

        BindPatientDetails(txtCorpseNo.Text.Trim(), txtDepositeNo.Text.Trim(), txtCorpseName.Text.Trim(), CorpseStatus);

        if (GridView1.Rows.Count > 0)
        {
            //Panel1.Visible = true;
            GridView1.Focus();
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }

    private void BindPatientDetails(string CorpseNo, string DepositeNo, string CorpseName, string CorpseStatus)
    {
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append("SELECT CM.Corpse_ID,CM.CName,REPLACE(CD.TransactionID,'CRSHHI','')DepositeNo,CD.IsReleased,CONCAT(MFM.RackName,'-',MFM.Rack_No,'/',MFM.ShelfNo)FreezerName,(SELECT PatientType FROM patient_type WHERE id=CM.Type)PatientType,CONCAT(CM.Address,' ',CM.Locality,' ',CM.City)Address,CD.PanelID Panel_ID,rtrim(ltrim(pnl.Company_Name))company_name   ");
            str.Append("FROM mortuary_corpse_master CM INNER JOIN mortuary_corpse_deposite CD ON CM.Corpse_ID=CD.CorpseID INNER JOIN mortuary_freezer_master MFM ON CD.FreezerID=MFM.RackID  ");
            str.Append("inner join f_panel_master pnl on pnl.PanelID  = CD.PanelID ");
            str.Append("WHERE CD.isCancel='0' AND CD.IsReleased='" + CorpseStatus + "'  ");

            if (CorpseNo != "")
            {
                str.Append("AND CM.Corpse_ID='" + CorpseNo + "' ");
            }

            if (DepositeNo != "")
            {
                str.Append("AND CD.TransactionID='" + string.Concat("CRSHHI", DepositeNo) + "'  ");
            }

            if (CorpseName != "")
            {
                str.Append("AND CM.CName LIKE '%" + CorpseName + "%'  ");
            }

            str.Append("ORDER BY Date(CD.InDate) ");


            dt = StockReports.GetDataTable(str.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
                pnlRecord.Visible = true;
                pnlAdvHide.Visible = false;
                pnlDetails.Visible = false;
            }
            else
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
                lblMsg.Text = "Record Not Found ";
                pnlRecord.Visible = false;
                pnlAdvHide.Visible = false;
                pnlDetails.Visible = false;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }

    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        chkHospLedger.SelectedIndex = 0;
        chkHospLedger.Enabled = true;
        chkRefund.Enabled = true;
        //btnSave.Attributes.Add("disabled", "true");
        //((Button)PaymentControl.FindControl("btnAdd")).Attributes.Add("disabled", "true");
        //((TextBox)PaymentControl.FindControl("txtPaidAmount")).Text = "";
        parentClear();
        //btnSave.Enabled = true;
        lblCorpseNo.Text = GridView1.SelectedRow.Cells[1].Text;
        lblTransaction_ID.Text = "CRSHHI" + GridView1.SelectedRow.Cells[2].Text;
        lblDepositeNo.Text = GridView1.SelectedRow.Cells[2].Text.Replace("ISHHI", "");
        lblCorpseName.Text = GridView1.SelectedRow.Cells[3].Text;
        lblFreezer.Text = GridView1.SelectedRow.Cells[5].Text;
        lblPanelComp.Text = GridView1.SelectedRow.Cells[6].Text;
        lblCAddress.Text = ((Label)GridView1.SelectedRow.FindControl("lblAddress")).Text;

        AllQuery AQ = new AllQuery();
        AllSelectQuery ASQ = new AllSelectQuery();

        decimal ServiceTaxPer = 0, ServiceTaxAmt = 0, ServiceTaxSurChgAmt = 0, SerTaxSurChgPer = 0, SerTaxBillAmt = 0;

        decimal RoundOff = 0, TotalPaidAmt = 0;
        DataTable dtAdjust = StockReports.GetDataTable("SELECT TransactionID Transaction_ID,CorpseID,DoctorID,PanelID Panel_ID,BillNo,BillDate,TotalBilledAmt,TDS,ServiceTaxAmt,ServiceTaxPer,ServiceTaxSurChgAmt,SerTaxSurChgPer,SerTaxBillAmount,S_CountryID,S_Amount,S_Notation,C_Factor,RoundOff,DiscountOnBill,IsReleased,IsBillClosed,FileClose_flag FROM mortuary_corpse_deposite WHERE IsCancel=0 AND TransactionID='" + lblTransaction_ID.Text + "'");
        decimal AmountBilled = Util.GetDecimal(AQ.GetMortuaryBillAmount(lblTransaction_ID.Text));
        decimal AmountReceived = Util.GetDecimal(AQ.GetMortuaryPaidAmount(lblTransaction_ID.Text));
        decimal NetAmount = Util.GetDecimal(AmountBilled - AmountReceived);
        decimal DiscountOnItem = 0;

        DataTable Disc = ASQ.GetBilledCorpseItemDetail(lblTransaction_ID.Text);
        DataRow[] DisRow = Disc.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

       // DiscountOnItem = Util.GetDecimal(StockReports.ExecuteScalar("SELECT Sum(DiscAmt) FROM mortuary_ledgertnxdetail WHERE TransactionID='" + lblTransaction_ID.Text + "' AND IsVerified = 1 and IsPackage = 0 "));

        if (DisRow.Length > 0)
        {
            foreach (DataRow drDis in DisRow)
            {
                DiscountOnItem = DiscountOnItem + (Util.GetDecimal(drDis["DiscountAmount"].ToString())); // (Util.GetDecimal(drDis["Rate"].ToString()) * Util.GetDecimal(drDis["Quantity"].ToString())) - Util.GetDecimal(drDis["Amount"].ToString());
            }
        }
        if (dtAdjust != null && dtAdjust.Rows.Count > 0)
        {
            //if (dtAdjust.Rows[0]["FileClose_flag"].ToString().Trim() == "1")
            //{
            //    lblMsg.Text = "Corpse File has been Closed";
            //    Panel1.Visible = false;
            //    btnSave.Enabled = false;
            //    txtCorpseName.Focus();
            //    pnlDetails.Visible = false;
            //    return;
            //}
        }
        //decimal TotalBillAmount = TotalPaidAmt;
        //  decimal Total_PanelApprovalAmt = Util.GetDecimal(StockReports.ExecuteScalar("Select round(PanelApprovedAmt,2) from f_ipdAdjustment where Transaction_ID='" + lblTransactionNo.Text.Trim() + "'"));
        //decimal Total_PanelApprovalAmt = Util.GetDecimal(dtAdjust.Rows[0]["PanelApprovedAmt"]);
        //lblPanelApp_Amt.Text = Total_PanelApprovalAmt.ToString();
        //if ((Util.GetDecimal(AllLoadData_IPD.getIPDNonPayableAmt(lblTransaction_ID.Text.Trim()))) > 0)
        //{
        //    lblNonPayableAmt.Text = Util.GetString(Util.GetDecimal(AllLoadData_IPD.getIPDNonPayableAmt(lblTransaction_ID.Text.Trim())) - Util.GetDecimal(dtAdjust.Rows[0]["DiscountOnBill"])).ToString();
        //}
        //else
        //    lblNonPayableAmt.Text = "0";

        if (dtAdjust.Rows[0]["BillNo"].ToString().Trim() == string.Empty)
        {
            ServiceTaxAmt = Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxAmt"]);
            ServiceTaxPer = Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxPer"]);
            ServiceTaxSurChgAmt = Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxSurChgAmt"]);
            SerTaxSurChgPer = Util.GetDecimal(dtAdjust.Rows[0]["SerTaxSurChgPer"]);
            SerTaxBillAmt = Util.GetDecimal(dtAdjust.Rows[0]["SerTaxBillAmount"]);

            NetAmount = Util.GetDecimal(Util.GetDecimal(NetAmount) + Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxSurChgAmt"]));
            RoundOff = Util.GetDecimal(dtAdjust.Rows[0]["RoundOff"]);
        }
        else
        {
            ServiceTaxPer = Util.GetDecimal(All_LoadData.GovTaxPer());
            SerTaxSurChgPer = 0;
            ServiceTaxAmt = 0;
            ServiceTaxSurChgAmt = 0;

            AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dtAdjust.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
            ServiceTaxAmt = Util.GetDecimal(Math.Round((Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100), 2, MidpointRounding.AwayFromZero));
            decimal SurchargeTaxAmt = Util.GetDecimal((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)));
            NetAmount = Util.GetDecimal(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
            ServiceTaxSurChgAmt = Util.GetDecimal(SurchargeTaxAmt);
            SerTaxBillAmt = Util.GetDecimal(AmountBilled);
            decimal Round = Math.Round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)), MidpointRounding.AwayFromZero);
            RoundOff = Util.GetDecimal(Round) - (Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(ServiceTaxAmt));
            TotalPaidAmt = Util.GetDecimal(Round);
        }
        ///////
        decimal TotalBillAmount = TotalPaidAmt;
      
        lblTotalBill_Amt.Text = (Math.Round( AmountBilled,2)).ToString();

        pnlDetails.Visible = true;
        Panel1.Visible = true;
        //pnlSave.Visible = true;
        if (ViewState["Panel_ID"] != null)
        {
            ViewState["Panel_ID"] = ((Label)GridView1.SelectedRow.FindControl("lblPanelID")).Text;
        }
        else
        {
            ViewState.Add("Panel_ID", ((Label)GridView1.SelectedRow.FindControl("lblPanelID")).Text);
        }
        decimal PaidAmt = Util.GetDecimal(AQ.GetMortuaryPaidAmount(lblTransaction_ID.Text));
        if (PaidAmt > 0)
        {
            lblPaidAmt.Text = PaidAmt.ToString();
        }
        else
        {
            lblPaidAmt.Text = "0.00";
        }

        //((TextBox)PaymentControl.FindControl("txtNetAmount")).Text = Util.GetString(AmountBilled - (Util.GetDecimal(lblPaidAmt.Text)));

        //if (((TextBox)PaymentControl.FindControl("txtNetAmount")).Text.Contains("-"))
        //    ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text = ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text.Replace("-", "");

        //((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = Util.GetString(AmountBilled - (Util.GetDecimal(lblPaidAmt.Text)));
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "CallUserControlFn(" + ((DropDownList)PaymentControl.FindControl("ddlCountry")).SelectedValue + "," + ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text + ");", true);

        //if (((Label)PaymentControl.FindControl("lblBalanceAmount")).Text.Contains("-"))
        //    ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text.Replace("-", "");

        decimal chkIsRefund = 0;
        if (dtAdjust.Rows[0]["BillNo"].ToString().Trim() != "")
        {
            chkIsRefund = Util.GetDecimal(lblTotalBill_Amt.Text) - Util.GetDecimal(lblPaidAmt.Text);
        }
        if (chkIsRefund < 0)
        {
            chkRefund.Checked = true; lblIsRefund.Text = "1";
        }
        else
        {
            lblIsRefund.Text = "0"; chkRefund.Checked = false;
        }

        DataTable dt = AQ.GetCorpseInformation(lblTransaction_ID.Text.Trim());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblDoctor.Text = dt.Rows[0]["DName"].ToString();
            lblDepositeDate.Text = Util.GetDateTime(dt.Rows[0]["DepositeDateTime"].ToString()).ToString("dd-MMM-yyyy");
        }
        //  UpdateBilling(lblTransactionNo.Text);
        // txtAmount.Focus();
        //if (TotalPaidAmt - (AmountReceived) > 0)
        //{
        //    chkRefund.Checked = false; lblIsRefund.Text = "0";
        //}
        //else
        //{
        //    if (TotalPaidAmt - (AmountReceived) != 0)
        //    {
        //        if (dtAdjust.Rows[0]["BillNo"].ToString().Trim() == "")
        //        {
        //            chkRefund.Checked = true; lblIsRefund.Text = "1";
        //        }
        //    }
        //    else
        //        lblIsRefund.Text = "0";
        //}
        DataTable dtAdvance_Detail = new DataTable();
        dtAdvance_Detail = AQ.GetMortuaryReceipt(lblTransaction_ID.Text);
        if (dtAdvance_Detail != null && dtAdvance_Detail.Rows.Count > 0)
        {
            grdReceipt.DataSource = dtAdvance_Detail;
            grdReceipt.DataBind();
            pnlAdvHide.Visible = true;
        }
        else if (dtAdvance_Detail != null && dtAdvance_Detail.Rows.Count == 0)
        {

            DataRow dr = dtAdvance_Detail.NewRow();
            dr[0] = "";
            dr[1] = "0";
            dr[2] = "";
            dr[3] = "";
            dr[4] = "";
            dr[5] = 1;
            dr[6] = "";
            dtAdvance_Detail.Rows.Add(dr);

            grdReceipt.DataSource = dtAdvance_Detail;
            grdReceipt.DataBind();
            pnlAdvHide.Visible = true;
        }
        if (rdbDischarged.Checked)
        {
            chkHospLedger.SelectedIndex = 1;
            chkHospLedger.Enabled = false;
        }
        else if (rdbAdmitted.Checked)
        {
            chkHospLedger.SelectedIndex = 0;
            chkHospLedger.Enabled = false;
        }

        //Check Payment is advance or not //Rahul 
        if (chkHospLedger.SelectedItem.Text == "ADVANCE-COL")
        {
            ViewState["IsAdvance"] = "1";
            HttpContext.Current.Session["IsAdvance"] = "1";
        }
        else
        {
            ViewState["IsAdvance"] = "0";
            HttpContext.Current.Session["IsAdvance"] = "0";
        }

    }





    private void parentClear()
    {
        ViewState["dtPaymentDetail"] = string.Empty;
        //((GridView)PaymentControl.FindControl("grdPaymentMode")).DataSource = null;
        //((GridView)PaymentControl.FindControl("grdPaymentMode")).DataBind();
        //((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text = "0";
        //((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = "0";
        //((Label)PaymentControl.FindControl("lblRoundVal")).Text = "0";
    }

    #endregion

    #region DataLoad



    private void BindHospLedgerAccount()
    {
        try
        {
            chkHospLedger.Items.AddRange(LoadItems(CreateStockMaster.LoadLedgerAccount("HOSP")));
            chkHospLedger.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }

    }

    public ListItem[] LoadItems(string[,] str)
    {
        try
        {
            ListItem[] Items = new ListItem[str.Length / 2];

            for (int i = 0; i < str.Length / 2; i++)
            {
                Items[i] = new ListItem(str[i, 0].ToString(), str[i, 1].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    public static void Clear()
    {
        ////lblMsg.Text = "";
        //lblDepositeDate.Text = "";
        //lblDoctor.Text = "";
        //lblPaidAmt.Text = "";
        ////lblPanelComp.Text = "";
        ////lblPanelComp.Text = "";
        //lblCorpseNo.Text = "";
        //lblCorpseName.Text = "";
        //lblFreezer.Text = "";
        //lblDepositeNo.Text = "";

        ////txtAmount.Text = "";
        //txtCorpseName.Text = "";
        //txtDepositeNo.Text = "";
        //// txtcreditcardNo.Text = "";
        //txtCorpseNo.Text = "";

        //btnSave.Enabled = false;
        //Panel1.Visible = false;
        //GridView1.DataSource = null;
        //GridView1.DataBind();

        //grdReceipt.DataSource = null;
        //grdReceipt.DataBind();

        //txtCorpseName.Focus();
    }

    public static DataTable Receipt(string BiilNo, decimal Amount, string CorpseNo, string transactionNo, string FreezerNo, string doctorName, string CorpseName, string panelName)
    {
        DataTable dt = null;
        if (dt == null)
        {
            dt = new DataTable();
            dt.Columns.Add("Corpse_ID");
            dt.Columns.Add("Corpse_Name");
            dt.Columns.Add("Transaction_ID");
            dt.Columns.Add("Freezer_No");
            dt.Columns.Add("Consultant Name");
            dt.Columns.Add("ReceiptNo");
            dt.Columns.Add("Amount");
            dt.Columns.Add("CompanyName");
            // dt.Columns.Add("PaymentMode");
            dt.Columns.Add("PreparedBy");
            dt.Columns.Add("PanelCompany");
        }
        DataRow dr = dt.NewRow();
        dr["PreparedBy"] = HttpContext.Current.Session["LoginName"].ToString();
        dr["Corpse_ID"] = CorpseNo;
        dr["Corpse_Name"] = CorpseName;
        dr["Transaction_ID"] = transactionNo;
        dr["Freezer_No"] = FreezerNo;
        dr["Consultant Name"] = doctorName;
        dr["ReceiptNo"] = BiilNo;
        dr["Amount"] = Amount;
        //if (cmbPaid.SelectedItem.Text == "COMPANY")
        //{
        //    dr["CompanyName"] = lblPanelComp.Text;
        //}
        //else
        //{
        //    dr["CompanyName"] = "";
        //}
        //dr["PaymentMode"] = ddlPaymentMode.SelectedItem.Value;

        if (panelName.Trim() != AllGlobalFunction.Panel.ToString())
        {
            dr["PanelCompany"] = panelName.Trim();
        }
        dt.Rows.Add(dr);

        return dt;
    }

    public static void UpdateFileClose(string Transaction_ID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update mortuary_corpse_deposite adj inner join (Select TransactionID,TotalBilledAmt,");
            sb.Append(" (ItemDisc + DiscountOnBill) TotalDisc,");
            sb.Append(" (TotalBilledAmt - (ItemDisc + DiscountOnBill))NetAmount,AmountPaid from");
            sb.Append(" (select ltd.TransactionID,Round(sum(((ltd.Rate * ltd.Quantity)*ltd.DiscountPercentage)/100))ItemDisc,");
            sb.Append(" IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.TotalBilledAmt,");
            sb.Append(" (Select sum(AmountPaid) from f_reciept where IsCancel=0 and transactionID=adj.TransactionID)AmountPaid");
            sb.Append(" from mortuary_ledgertnxdetail ltd inner join");
            sb.Append(" mortuary_corpse_deposite adj on adj.TransactionID = ltd.TransactionID");
            sb.Append(" where (BillNo <>'' or BillNo <>null) and FileClose_flag=0 and IsVerified = 1");
            sb.Append(" and IsPAckage=0 and adj.TransactionID ='" + Transaction_ID + "' group by ltd.TransactionID)t");
            sb.Append(" Where Round((TotalBilledAmt - (ItemDisc + DiscountOnBill))) = Round(AmountPaid)) t1 on");
            sb.Append(" adj.TransactionID = t1.TransactionID set FileClose_flag=1 ");

            StockReports.ExecuteDML(sb.ToString());

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public static void UpdateRemarks(string ReceiptNo, string txtRemarks, string txtReceivedFrom)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update mortuary_receipt Set Naration='" + txtRemarks.Trim() + "',ReceivedFrom='" + txtReceivedFrom.Trim() + "'");
            sb.Append(" Where ReceiptNo ='" + ReceiptNo + "'");

            StockReports.ExecuteDML(sb.ToString());

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public static DataTable dtPaymentDetails()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("PaymentMode"));
        dt.Columns.Add(new DataColumn("PaymentModeID"));
        dt.Columns.Add(new DataColumn("PaidAmount"));
        dt.Columns.Add(new DataColumn("Currency"));
        dt.Columns.Add(new DataColumn("CountryID"));
        dt.Columns.Add(new DataColumn("BankName"));
        dt.Columns.Add(new DataColumn("RefNo"));
        dt.Columns.Add(new DataColumn("BaceCurrency"));
        dt.Columns.Add(new DataColumn("C_Factor"));
        dt.Columns.Add(new DataColumn("BaseCurrency"));
        dt.Columns.Add(new DataColumn("Notation"));
        dt.Columns.Add(new DataColumn("PaymentRemarks"));
        dt.Columns.Add(new DataColumn("RefDate"));
        dt.Columns.Add(new DataColumn("ReceivedAmt"));
        dt.Columns.Add(new DataColumn("ChangeAmt"));
        dt.Columns.Add(new DataColumn("CurrencyRoundOff"));
        return dt;
    }

    #endregion

    [WebMethod(EnableSession = true)]
    public static string SaveMortuaryDetail(string hashCodes, string IsRefund, string transactionNo, bool isAdmitted, decimal totalPaidAmount, string hospLedger, string CorpseNo, string FreezerNo, string doctorName, string CorpseName, string panelName, string paymentRemarks, string paymentReceivedFrom, object paymentDetail)
    {
        string PatientLedgerNo = "";
        string HospitalLedgerNo = "";
        string BiilNo = "";
        decimal Amount = 0;
        if (IsRefund == "1" && totalPaidAmount == 0)
        {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Enter Amount');", true);
            //((TextBox)PaymentControl.FindControl("txtPaidAmount")).Focus();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Enter Amount." });
        }
        if (paymentReceivedFrom.Trim() == string.Empty)
        {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Enter Name of Depositor');", true);
            //txtReceivedFrom.Focus();
            //return;
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Enter Name of Depositor." });
        }
        string hashCode = hashCodes;
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(paymentDetail);
        AllQuery AQ = new AllQuery();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            decimal AmountReceived = Util.GetDecimal(AQ.GetMortuaryPaidAmount(transactionNo.Trim()));
            //if (Util.GetFloat(txtAmount.Text.Trim()) <= 0)
            //{
            //    lblMsg.Visible = true;
            //    lblMsg.Text = "Please Specify Amount ...";
            //    txtAmount.Focus();
            //    return;
            //}            
            //shatrughan 29.07.13
            if (isAdmitted == true && IsRefund == "1")
            {
                //lblMsg.Visible = true;
                //lblMsg.Text = "Refund Should be given to Discharged Patietns only";
                //rdbAdmitted.Focus();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Refund Should be given to Discharged Patietns only" });
            }
            //shatrughan
            if ((IsRefund == "1") && dataPaymentDetail[0].PaymentMode.ToUpper() != "CASH")
            {
                //lblMsg.Visible = true;
                //lblMsg.Text = "Refund Can Only be Made in CASH";
                //((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Focus();
                //return;
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Refund Can Only be Made in CASH" });
            }

            if (IsRefund == "1" && isAdmitted == false)
            {
                if (Util.GetDecimal(totalPaidAmount) > AmountReceived)
                {
                    //lblMsg.Visible = true;
                    //lblMsg.Text = "The Refunding Amount is greater then the Amount collected from patient till date.Please Re-Check the amount.";
                    ////chkRefund.Checked = false;
                    //chkRefund.Focus();
                    //return;
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "The Refunding Amount is greater then the Amount collected from patient till date.Please Re-Check the amount." });
                }
            }
            string BillNo = "";
            BillNo = StockReports.ExecuteScalar("Select BillNo from mortuary_Ledgertransaction where TransactionID='" + transactionNo.Trim() + "' and (BillNo is not null or BillNo <>'') Limit 1");
            if (IsRefund == "1" && BillNo == "")
            {
                //lblMsg.Visible = true;
                //lblMsg.Text = "The Bill is Not Generated. Refund cannot be Possible";
                //chkRefund.Focus();
                //return;
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "The Bill is Not Generated. Refund cannot be Possible" });
            }
            if (IsRefund == "1")
            {
                bool IsRefundAllowed = false;
                IsRefundAllowed = Util.GetBoolean(StockReports.ExecuteScalar("Select if(CURDATE()>Date(ADDDATE(BillDate,1)),'true','false')IsRefundAllowed from mortuary_Ledgertransaction where TransactionID='" + transactionNo.Trim() + "' and BillNo <> '' limit 1 "));
                if (IsRefundAllowed == true)
                {
                    if (IsRefund == "1" && HttpContext.Current.Session["LoginType"] != null && HttpContext.Current.Session["LoginType"].ToString().ToUpper() != "MORTUARY")
                    {
                        //lblMsg.Text = "Refund Can Only Be Made From EDP Department";
                        //return;
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Refund Can Only Be Made From MORTUARY Department" });
                    }
                }
            }
            if (BillNo != "")
            {
                decimal DiscountOnItem = 0;
                AllSelectQuery ASQ = new AllSelectQuery();
                DataTable Disc = ASQ.GetBilledCorpseItemDetail(transactionNo.Trim());
                DataRow[] DisRow = Disc.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

                // DiscountOnItem = Util.GetDecimal(StockReports.ExecuteScalar("SELECT Sum(DiscAmt) FROM mortuary_ledgertnxdetail WHERE TransactionID='" + lblTransaction_ID.Text + "' AND IsVerified = 1 and IsPackage = 0 "));

                if (DisRow.Length > 0)
                {
                    foreach (DataRow drDis in DisRow)
                    {
                        DiscountOnItem = DiscountOnItem + (Util.GetDecimal(drDis["DiscountAmount"].ToString())); // (Util.GetDecimal(drDis["Rate"].ToString()) * Util.GetDecimal(drDis["Quantity"].ToString())) - Util.GetDecimal(drDis["Amount"].ToString());
                    }
                } 

                decimal BillAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(amount) FROM mortuary_ledgertnxdetail WHERE TransactionID='" + transactionNo.Trim() + "' AND IsVerified=1 AND IsPackage=0 group by TransactionID"));
                //decimal PanelApprovalAmt = Util.GetDecimal(StockReports.ExecuteScalar("Select PanelApprovedAmt from f_ipdAdjustment where Transaction_ID='" + lblTransactionNo.Text.Trim() + "'"));
                //if (chkHospLedger.SelectedItem.Text.ToUpper() == "REFUND")
                //{
                if (IsRefund == "1")
                {
                    decimal ActualRefundAmt = (BillAmount - DiscountOnItem) - AmountReceived;
                    if (ActualRefundAmt.ToString().Contains("-"))
                        ActualRefundAmt = Util.GetDecimal(ActualRefundAmt.ToString().Replace("-", ""));

                    if (ActualRefundAmt < Util.GetDecimal(totalPaidAmount))
                    {
                        //lblMsg.Visible = true;
                        //lblMsg.Text = "Your Refunding Amount is going below Total Collected Amount then Net Bill Amount.Refund Can Be Possible Upto : " + ActualRefundAmt;
                        ////chkRefund.Checked = false;
                        //chkRefund.Focus();
                        //return;
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Your Refunding Amount is going below Total Collected Amount then Net Bill Amount.Refund Can Be Possible Upto : " + ActualRefundAmt });
                    }
                    if (Util.GetDecimal(totalPaidAmount) > AmountReceived)
                    {
                        //lblMsg.Visible = true;
                        //lblMsg.Text = "The Refunding Amount is greater then the Amount collected from patient till date.Please Re-Check the amount.";
                        ////chkRefund.Checked = false;
                        //chkRefund.Focus();
                        //return;
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "The Refunding Amount is greater then the Amount collected from patient till date.Please Re-Check the amount." });
                    }
                }
            }
            string Panel = "";
            PatientLedgerNo = AQ.GetCorpseLedgerNo(transactionNo);
            HospitalLedgerNo = hospLedger;
            string Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            DateTime Paiddate = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"));
            DateTime PaidTime = Util.GetDateTime(System.DateTime.Now.ToString("HH:mm:ss"));
            string Depositor = CorpseNo;
            string Receiver = HttpContext.Current.Session["ID"].ToString();
            Amount = 0;
            string refund = "";
            if (IsRefund == "1")
            {
                Amount = Util.GetDecimal(totalPaidAmount);
                Amount = -Amount;
                refund = "1";
            }
            else
            {
                Amount = Util.GetDecimal(totalPaidAmount);
                refund = "0";
            }
            DataTable dtPaymentDetail = dtPaymentDetails();
           // DataTable dtPaymentDetail = HttpContext.Current.Session["dtPaymentDetail"] as DataTable;
            //if (dtPaymentDetail == null)
            //{
            //    HttpContext.Current.Session["dtPaymentDetail"] = string.Empty;
            //    dtPaymentDetails();
            //    dtPaymentDetail = HttpContext.Current.Session["dtPaymentDetail"] as DataTable;
            //}

            if (dataPaymentDetail.Count > 0 && dataPaymentDetail != null)
            {
                foreach (var payment in dataPaymentDetail)
                {
                    DataRow dr = dtPaymentDetail.NewRow();
                    dr["PaymentMode"] = payment.PaymentMode;
                    dr["PaymentModeID"] = payment.PaymentModeID;
                    if (IsRefund == "1")
                    {
                        dr["PaidAmount"] = "-" + payment.S_Amount;
                        dr["BaseCurrency"] = "-" + payment.Amount;
                    }
                    else
                    {
                        dr["PaidAmount"] = payment.S_Amount;
                        dr["BaseCurrency"] = payment.Amount;
                    }
                    dr["Currency"] = payment.S_Currency;
                    dr["CountryID"] = payment.S_CountryID;
                    dr["BankName"] = payment.BankName;
                    dr["RefNo"] = payment.RefNo;
                    dr["C_Factor"] = payment.C_Factor;
                    dr["BaceCurrency"] = payment.S_Currency;
                    dr["Notation"] = payment.S_Notation;
                    //dr["CurrencyRoundOff"] = payment.currencyRoundOff;
                    dr["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    dtPaymentDetail.Rows.Add(dr);
                    //dtPaymentDetail.AcceptChanges();
                }
                DataTable dt1 = dtPaymentDetail;
                // decimal AmountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);
                decimal AmountPaid = Amount;
                //CreateStockMaster Csm = new CreateStockMaster();
                // BiilNo = Csm.SaveReceiptBillNew(PatientLedgerNo, HospitalLedgerNo, Amount, PaidDate, Panel, lblTransactionNo.Text.Trim(), Hospital_ID, PaidTime, "", "", Receiver, Depositor, Bank, ChequeDate, "0", "", hashCode);
                //BiilNo = Csm.SaveReceiptBillNew(dt1, PatientLedgerNo, HospitalLedgerNo, Session["HOSPID"].ToString(), Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")), Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss")), Receiver, Depositor, Panel, lblTransaction_ID.Text.Trim(), "0", hashCode, AmountPaid, tnx, ReceivedAmt, ChangeAmt);
                BiilNo = SaveReceiptBillNew(dt1, PatientLedgerNo, HospitalLedgerNo, HttpContext.Current.Session["HOSPID"].ToString(), Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")), Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss")), Receiver, Depositor, Panel, transactionNo.Trim(), "0", hashCode, AmountPaid, tnx);
                if (BiilNo != null && BiilNo != "")
                {
                    tnx.Commit();
                    UpdateRemarks(BiilNo, paymentRemarks, paymentReceivedFrom);
                    UpdateFileClose(transactionNo.Trim());
                    HttpContext.Current.Session["DataTableReceipt"] = Receipt(BiilNo, Amount, CorpseNo, transactionNo, FreezerNo, doctorName, CorpseName, panelName);
                    //Clear();
                    // Panel1.Visible = false;
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Receipt Saved Successfully');window.open('../../Design/Mortuary/MortuaryReceipt.aspx?Corpse_ID=" + Depositor + "&Refund=" + refund + "&IsAdvance=" + HttpContext.Current.Session["IsAdvance"].ToString() + "');", true);
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='MortuaryReceiptBill.aspx';", true);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/Mortuary/CommonPrinterOPDThermal.aspx?ReceiptNo=" + BiilNo + "&LedgerTransactionNo=" + CorpseNo + "&Refund=" + refund + "&Type=MOR&Duplicate=0&IsAdvance=" + HttpContext.Current.Session["IsAdvance"].ToString() });
                }
                else
                {
                    HttpContext.Current.Session["dtPaymentDetail"] = null;
                    //lblMsg.Text = "Record Not Saved";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });
                }
            }
            else
            {
                DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
                if (dt.Rows.Count > 0)
                {
                    AllSelectQuery ASQ = new AllSelectQuery();
                    DataRow drRow = dtPaymentDetail.NewRow();
                    drRow["PaymentMode"] = "Cash";
                    drRow["PaymentModeID"] = "1";
                    drRow["PaidAmount"] = Util.GetDecimal(totalPaidAmount);
                    drRow["Currency"] = dt.Rows[0]["S_Currency"].ToString();
                    drRow["CountryID"] = dt.Rows[0]["S_CountryID"].ToString();
                    drRow["BankName"] = "";
                    drRow["RefNo"] = "";
                    drRow["BaceCurrency"] = dt.Rows[0]["B_Currency"].ToString();
                    drRow["C_Factor"] = ASQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"])).ToString();
                    drRow["BaseCurrency"] = "0";
                    drRow["Notation"] = dt.Rows[0]["S_Notation"].ToString();
                    drRow["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    dtPaymentDetail.Rows.Add(drRow);
                }
                DataTable dt1 = dtPaymentDetail;
                //CreateStockMaster Csm = new CreateStockMaster();
                //string RefundBiilNo = Csm.SaveReceiptBillNewRefund(dt1, PatientLedgerNo, HospitalLedgerNo, Session["HOSPID"].ToString(), Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")), Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss")), Receiver, Depositor, Panel, lblTransaction_ID.Text.Trim(), "0", hashCode, Amount, tnx);
                string RefundBiilNo = SaveReceiptBillNewRefund(dt1, PatientLedgerNo, HospitalLedgerNo, HttpContext.Current.Session["HOSPID"].ToString(), Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")), Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss")), Receiver, Depositor, Panel, transactionNo.Trim(), "0", hashCode, Amount, tnx);
                if (RefundBiilNo != null && RefundBiilNo != "")
                {
                    tnx.Commit();
                    UpdateRemarks(RefundBiilNo, paymentRemarks, paymentReceivedFrom);
                    UpdateFileClose(transactionNo.Trim());
                    HttpContext.Current.Session["DataTableReceipt"] = Receipt(RefundBiilNo, Amount, CorpseNo, transactionNo, FreezerNo, doctorName, CorpseName, panelName);
                    // Clear();
                    //Panel1.Visible = false;
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Reciept Save Successfully');window.open('../../Design/Mortuary/MortuaryReceipt.aspx?Corpse_ID=" + Depositor + "&Refund=" + refund + "');", true);
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='MortuaryReceiptBill.aspx';", true);

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/Mortuary/CommonPrinterOPDThermal.aspx?ReceiptNo=" + RefundBiilNo + "&LedgerTransactionNo=" + CorpseNo + "&Refund=" + refund + "&Type=MOR&Duplicate=0&IsAdvance=" + HttpContext.Current.Session["IsAdvance"].ToString() });
               
                    
                   // return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/Mortuary/MortuaryReceipt.aspx?Corpse_ID=" + Depositor + "&Refund=" + refund });
                }
                else
                {
                    //lblMsg.Text = "Record Not Saved";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });
                }
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //lblMsg.Text = ex.Message;
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static string SaveReceiptBillNew(DataTable dtPaymentDetail, string PatientLedger, string HospitalLedger, string Hospital_ID, DateTime Date, DateTime Time, string Receiver, string Depositor, string Panel, string Transaction_ID, string TDS, string hashCode, decimal AmountPaid, MySqlTransaction tnx)
    {
        try
        {
            if (PatientLedger != "")
            {
                AllUpdate Au = new AllUpdate(tnx);
                string UpdateLedgerMaster = Au.UpdateLedgerMsWithLedgerNumber(AmountPaid, PatientLedger, HospitalLedger, tnx);
                //UpdateLedgerMaster = Au.UpdateIPDAdjustment(Util.GetFloat(TDS), Transaction_ID, tnx);
            }
            MortuaryReceipt ObjReceipt = new MortuaryReceipt(tnx);
            ObjReceipt.LedgerNoCr = PatientLedger;
            ObjReceipt.LedgerNoDr = HospitalLedger;
            ObjReceipt.AmountPaid = AmountPaid;
            ObjReceipt.Panel_ID = Panel;
            ObjReceipt.Transaction_ID = Transaction_ID;
            ObjReceipt.Date = Date;
            ObjReceipt.Time = Time;
            ObjReceipt.Hospital_ID = Hospital_ID;
            ObjReceipt.Depositor = Depositor;
            ObjReceipt.Reciever = Receiver;
            ObjReceipt.Discount = 0;
            ObjReceipt.UniqueHash = hashCode;
            ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            string ReceiptNo = ObjReceipt.Insert();

            MortuaryReceipt_PaymentDetail ObjReceiptPayment = new MortuaryReceipt_PaymentDetail(tnx);
            foreach (DataRow row in dtPaymentDetail.Rows)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                ObjReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                ObjReceiptPayment.Amount = Util.GetDecimal(row["BaseCurrency"]);
                ObjReceiptPayment.ReceiptNo = ReceiptNo;
                ObjReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                ObjReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                ObjReceiptPayment.BankName = Util.GetString(row["BankName"]);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(row["PaidAmount"]);
                ObjReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                ObjReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                ObjReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceiptPayment.C_ChangeAmt = Util.GetString("1");
                string PaymentID = ObjReceiptPayment.Insert().ToString();
            }
            if (ReceiptNo == "")
            {

                return "";
            }
            else
            {
                return ReceiptNo;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    public static string SaveReceiptBillNewRefund(DataTable dtPaymentDetail, string PatientLedger, string HospitalLedger, string Hospital_ID, DateTime Date, DateTime Time, string Receiver, string Depositor, string Panel, string Transaction_ID, string TDS, string hashCode, decimal Amount, MySqlTransaction tnx)
    {

        try
        {
            if (PatientLedger != "")
            {
                AllUpdate Au = new AllUpdate(tnx);
                string UpdateLedgerMaster = Au.UpdateLedgerMsWithLedgerNumber(Amount, PatientLedger, HospitalLedger, tnx);
                //UpdateLedgerMaster = Au.UpdateIPDAdjustment(Util.GetFloat(TDS), Transaction_ID, tnx);
            }
            MortuaryReceipt ObjReceipt = new MortuaryReceipt(tnx);
            ObjReceipt.LedgerNoCr = HospitalLedger;
            ObjReceipt.LedgerNoDr = PatientLedger;
            ObjReceipt.Panel_ID = Panel;
            ObjReceipt.Transaction_ID = Transaction_ID;
            ObjReceipt.AmountPaid = Amount;
            ObjReceipt.Date = Date;
            ObjReceipt.Time = Time;
            ObjReceipt.Hospital_ID = Hospital_ID;
            ObjReceipt.Depositor = Depositor;
            ObjReceipt.Discount = 0;
            ObjReceipt.Reciever = Receiver;
            ObjReceipt.UniqueHash = hashCode;
            ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjReceipt.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
            string ReceiptNo = ObjReceipt.Insert();

            MortuaryReceipt_PaymentDetail ObjReceiptPayment = new MortuaryReceipt_PaymentDetail(tnx);
            foreach (DataRow row in dtPaymentDetail.Rows)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                ObjReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                ObjReceiptPayment.Amount = Util.GetDecimal(row["BaseCurrency"]);
                ObjReceiptPayment.ReceiptNo = ReceiptNo;
                ObjReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                ObjReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                ObjReceiptPayment.BankName = Util.GetString(row["BankName"]);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(row["PaidAmount"]);
                ObjReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                ObjReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                ObjReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceiptPayment.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
                string PaymentID = ObjReceiptPayment.Insert().ToString();
            }
            if (ReceiptNo == "")
            {
                return "";
            }
            else
            {
                return ReceiptNo;

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}
