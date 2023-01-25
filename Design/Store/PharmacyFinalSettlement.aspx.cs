using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;


public partial class Design_Store_OPDFinalSettlement : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        //DataTable dtChkRight = StockReports.GetDataTable("SELECT OPDSettlement FROM userauthorization WHERE OPDSettlement=1 AND EmpID='" + Session["ID"].ToString() + "' AND RoleID='" + Session["RoleID"].ToString() + "'");
        //if (dtChkRight == null || dtChkRight.Rows.Count <= 0)
        //{
        //    btnSave.Visible = false;
        //    lblMsg.Text = "You don't have rights of Settlement Please Contact to IT Department";
        //}
        ((TextBox)PaymentControl.FindControl("txtNetAmount")).Attributes.Add("readonly", "readonly");
        txtPatientID.Focus();
        string receiptno = "";
        if (Request.QueryString["receiptno"] != null)
            receiptno = Request.QueryString["receiptno"].ToString();

        if (!IsPostBack)
        {
            btnSave.Enabled = false;
            chkRefund.Checked = false;


            txtHash.Attributes.Add("style", "display:none");
            txtHash.Text = Util.getHash();

            BindPanel();
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           ViewState["DeptLedgerNo"]= Session["DeptLedgerNo"].ToString();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void BindPanel()
    {
        DataTable dtPanel = LoadCacheQuery.loadAllPanel();
        foreach (DataRow dr in dtPanel.Rows)
        {
            ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[3].ToString());
            ddlPanelCompany.Items.Add(li1);
        }
        ddlPanelCompany.Items.Insert(0,  new ListItem("Select","0"));
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        

        lblMsg.Text = "";
        parentClear();
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT t.* FROM (");
        sb.Append(" SELECT lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') BillDate,lt.PatientID PatientID,lt.TransactionID TransactionID, ROUND(lt.NetAmount,2) NetAmount,  ");
        sb.Append(" lt.Adjustment PaidAmt,lt.NetAmount-lt.Adjustment PendingAmt,lt.GrossAmount,  ");
        sb.Append(" UPPER(pm.PName) PatientName,lt.LedgerTransactionNo,fpm.Company_Name CompanyName,lt.PanelID, ");
        sb.Append(" ROUND(lt.NetAmount,2) Amount ,if((lt.NetAmount-lt.Adjustment)!=0,'#FFC0CB','#90EE90')rowColor,lt.paymentmodeid,   ");
        sb.Append(" IF(lt.paymentmodeid<>4,'Partial','Credit')PaidType,lt.Roundoff,lt.GovtaxAmount,ROUND((lt.NetAmount-lt.GovtaxAmount-lt.roundoff),2)NetAmtBeforeTax,lt.TypeOfTnx,IF(LT.`TypeOfTnx` IN ('Pharmacy-Issue','Pharmacy-Return'),lt.DeptLedgerNo,'')DeptLedgerNo,isOTCollection ");
        sb.Append(" FROM f_ledgertransaction lt   ");
        sb.Append("  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID   ");
        sb.Append("   where lt.IsCancel=0 AND lt.CentreID='" + Util.GetInt(Session["CentreID"].ToString()) + "'");
        if (txtPatientID.Text.Trim() != "")
            sb.Append("     AND lt.PatientID='" + txtPatientID.Text.Trim() + "' ");
        if (ddlPanelCompany.SelectedItem.Value.Split('#')[0] != "0")
            sb.Append(" AND pmh.PanelID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + " ");
        if (txtFromDate.Text != string.Empty)
            sb.Append(" AND date(lt.Date) >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'");
        
        if (txtToDate.Text != string.Empty)
            sb.Append(" AND date(lt.Date) <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND lt.NetAmount<>lt.Adjustment   ");


        sb.Append(" AND LT.`TypeOfTnx` IN ('Pharmacy-Issue','Pharmacy-Return') AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");

        sb.Append(" GROUP BY lt.LedgerTransactionNo )t where t.PendingAmt >0 ");
        sb.Append(" Order by t.PatientID");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());


        //  DataTable dtSearch = OPD.SearchOPDFinalSettlement(txtPatientID.Text.Trim(), ddlPanelCompany.SelectedItem.Value.Split('#')[0], txtFromDate.Text, txtToDate.Text, dptlno);
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            pnlHideSettlement.Visible = true;
            pnlOPDFinalSettlement.Visible = false;
            ViewState["BillDetail"] = dtSearch;

            grdBill.DataSource = dtSearch;
            grdBill.DataBind();
            lblMsg.Text = "";
        }

        else
        {
            pnlHideSettlement.Visible = false;
            pnlOPDFinalSettlement.Visible = false;
            lblMsg.Text = "Record Not Found";
            grdBill.DataSource = null;
            grdBill.DataBind();
            parentClear();
            ViewState["BillDetail"] = null;
        }
    }


    protected bool ValidateValues()
    {
        if (((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count == 0)
        {

            lblMsg.Text = "Please Add Amount";
            return false;
        }
        return true;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidateValues())
        {
            string hashCode = txtHash.Text;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                if (Util.GetFloat(txtAmount.Text.Trim()) == 0)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Please Specify Amount";
                    txtAmount.Focus();
                    return;
                }
                if (chkRefund.Checked)
                {
                    if (Util.GetFloat(txtAmount.Text.Trim()) > Util.GetFloat(lblAmtSum.Text.Trim()))
                    {
                        lblMsg.Visible = true;
                        lblMsg.Text = "Refund Amount cannot be greater than advance amount";
                        txtAmount.Focus();
                        return;
                    }
                }

                string receiptNo = "";
                string type = "DEBIT";
                if (Util.GetFloat(txtAmount.Text.Trim()) < 0)
                    type = "CREDIT";

                string paidBy = "";
                decimal amount = 0;
                amount = Util.GetDecimal(txtAmount.Text);
                DataTable dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
                if (dtPaymentDetail == null)
                {
                    dtPaymentDetails();
                    dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
                }
                for (int i = 0; i < ((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count; i++)
                {
                    DataRow dr = dtPaymentDetail.NewRow();
                    dr["PaymentMode"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblPaymentMode")).Text;
                    dr["PaymentModeID"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblPaymentModeID")).Text;
                    dr["PaidAmount"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblAmount")).Text;
                    dr["Currency"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblCurrency")).Text;
                    dr["CountryID"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblCountryID")).Text;
                    dr["BankName"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblBankName")).Text;
                    dr["RefNo"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblRefNo")).Text;
                    dr["BaceCurrency"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblBaseCurrency")).Text;
                    dr["C_Factor"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblConversionFactor")).Text;
                    dr["BaseCurrency"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblBaseCurrencyAmount")).Text;
                    dr["Notation"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblNotation")).Text;
                    dr["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    dtPaymentDetail.Rows.Add(dr);
                    dtPaymentDetail.AcceptChanges();
                    // totalAmt = Util.GetDecimal(dtPaymentDetail.Compute("sum(Amount)", ""));
                }
                DataTable payment = dtPaymentDetail;
                decimal roundOff = 0; decimal amountPaid = 0;

                if (ViewState["PaidType"].ToString() == "Credit") // CREDIT  CASES
                {
                    if (((lblTypeOfTnx.Text != "Pharmacy-Issue") || (lblTypeOfTnx.Text != "Pharmacy-Return")) && ((ViewState["PaidType"].ToString() == "Credit")))
                    {
                        roundOff = Util.GetDecimal(lblRoundOff.Text);
                        amountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);
                    }
                    else
                    {
                        roundOff = Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text);
                        amountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);
                    }
                    OPD opd = new OPD();
                    receiptNo = opd.SaveCreditReceipt(payment, Util.GetInt(lblPanelID1.Text), amount, lblLedgertransactionNo.Text, lblMRNo.Text, lblTransactionID.Text, paidBy, hashCode, amountPaid, roundOff, tnx, lblPaidBy.Text, con, Util.GetDecimal(lblOPDAdvance.Text), lblDeptLedgerNo.Text.Trim(),Util.GetInt(lblIsOTCollection.Text.Trim()));

                    if (receiptNo != "")
                    {
                        tnx.Commit();
                        DataTable dt = CreateStockMaster.GetItemByBillNo(((DataTable)ViewState["BillDetail"]).Rows[0]["BillNo"].ToString()); ;

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            if (dt.Columns.Contains("SubCategory") == false) dt.Columns.Add("SubCategory");
                            if (dt.Columns.Contains("ReceiptNo") == false) dt.Columns.Add("ReceiptNo");
                            if (dt.Columns.Contains("Date") == false) dt.Columns.Add("Date");
                            if (dt.Columns.Contains("Time") == false) dt.Columns.Add("Time");
                            if (dt.Columns.Contains("PaymentModeID") == false) dt.Columns.Add("PaymentModeID");
                            if (dt.Columns.Contains("PreparedBy") == false) dt.Columns.Add("PreparedBy");

                        }

                        for (int i = 0; i < dt.Rows.Count; i++)
                        {

                            dt.Rows[i]["ReceiptNo"] = receiptNo;
                            dt.Rows[i]["Date"] = Util.GetDateTime(System.DateTime.Now.ToString("yyyy-MM-dd"));
                            dt.Rows[i]["Time"] = Util.GetDateTime(System.DateTime.Now.ToString("HH:mm:ss"));
                            dt.Rows[i]["PaymentModeID"] = "1";
                            dt.Rows[i]["PreparedBy"] = Session["UserName"].ToString();

                        }
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/common/CreditBillReceipt.aspx?LedgerTransactionNo=" + lblLedgertransactionNo.Text + "&receiptNo=" + receiptNo + "&Duplicate=0');", true);

                        Clear();

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='PharmacyFinalSettlement.aspx';", true);

                    }
                }
                //Partial Type
                else
                {
                    //if (Util.GetFloat(amount) < 0)
                    //{
                    //    ViewState["balance"] = 1;
                    //}
                    //else
                    //{
                    //    ViewState["balance"] = 0;
                    //}


                    roundOff = Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text);
                    amountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);

                    OPD opd = new OPD();
                    receiptNo = opd.SavePendingReceipt(payment, Util.GetInt(lblPanelID1.Text), amount, lblLedgertransactionNo.Text, lblMRNo.Text, lblTransactionID.Text, paidBy, txtNarration.Text.Trim(), type, hashCode, amountPaid, roundOff, tnx, lblPaidBy.Text, con, Util.GetDecimal(lblOPDAdvance.Text), lblDeptLedgerNo.Text.Trim(),Util.GetInt(lblIsOTCollection.Text.Trim()));
                    if (receiptNo != "")
                    {
                        tnx.Commit();
                        Clear();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Receipt Saved Successfully');window.open('../../Design/common/ReceiptOPD.aspx?ReceiptNo=" + receiptNo + "&TransactionID=" + lblTransactionID.Text + "&Duplicate=0&DeptLedgerNo=" + lblDeptLedgerNo.Text.Trim() + "');", true);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='PharmacyFinalSettlement.aspx';", true);

                    }
                    else
                    {
                        lblMsg.Text = "Receipt Not Saved";
                    }

                }
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }
    private void parentClear()
    {
        ViewState["dtPaymentDetail"] = null;
        ((GridView)PaymentControl.FindControl("grdPaymentMode")).DataSource = null;
        ((GridView)PaymentControl.FindControl("grdPaymentMode")).DataBind();
        ((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text = "0";
        ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = "0";
        ((Label)PaymentControl.FindControl("lblRoundVal")).Text = "0";
    }

    private void Clear()
    {
        lblMsg.Text = "";
        lblMRNo.Text = "";
        lblPatientName.Text = "";
        lblAmtSum.Text = "";
        lblAmtType.Text = "";
        txtAmount.Text = "";
        lblRoundOff.Text = "";

        btnSave.Enabled = false;
        pnlOPDFinalSettlement.Visible = false;
        grdBill.DataSource = null;
        grdBill.DataBind();
    }
    private void dtPaymentDetails()
    {
        DataTable dt1 = new DataTable();
        dt1.Columns.Add(new DataColumn("PaymentMode"));
        dt1.Columns.Add(new DataColumn("PaymentModeID"));
        dt1.Columns.Add(new DataColumn("PaidAmount"));
        dt1.Columns.Add(new DataColumn("Currency"));
        dt1.Columns.Add(new DataColumn("CountryID"));
        dt1.Columns.Add(new DataColumn("BankName"));
        dt1.Columns.Add(new DataColumn("RefNo"));
        dt1.Columns.Add(new DataColumn("BaceCurrency"));
        dt1.Columns.Add(new DataColumn("C_Factor"));
        dt1.Columns.Add(new DataColumn("BaseCurrency"));
        dt1.Columns.Add(new DataColumn("Notation"));
        dt1.Columns.Add(new DataColumn("PaymentRemarks"));
        dt1.Columns.Add(new DataColumn("RefDate"));
        ViewState["dtPaymentDetail"] = dt1;
    }
    protected void grdBill_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        //ViewState.Clear();// Remove("dtPaymentDetail");
        //DataTable dt = ViewState["dtPaymentDetail"] as DataTable;
        ViewState["dtPaymentDetail"] = null;
        parentClear();
        pnlOPDFinalSettlement.Visible = true;
        lblMRNo.Text = ((Label)grdBill.SelectedRow.FindControl("lblMRNo")).Text;
        lblRoundOff.Text = ((Label)grdBill.SelectedRow.FindControl("lblRoundOff")).Text;
        lblNetAmtBeforeTax.Text = ((Label)grdBill.SelectedRow.FindControl("lblNetAmtBeforeTax")).Text;
        lblPatientName.Text = grdBill.SelectedRow.Cells[1].Text;
        lblGovTax.Text = ((Label)grdBill.SelectedRow.FindControl("lblGovtaxAmount")).Text;
        lblAmtType.Visible = true;
        lblAmtSum.Visible = true;
        lblAmtSum.Text = ((Label)grdBill.SelectedRow.FindControl("lblPendingAmt")).Text;
        txtAmount.Text = ((Label)grdBill.SelectedRow.FindControl("lblPendingAmt")).Text;
        lblPaidBy.Text = "Patient";
        ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = txtAmount.Text;
        ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text = txtAmount.Text.Trim();
        ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Text = "";

        lblTransactionID.Text = ((Label)grdBill.SelectedRow.FindControl("lblTransactionID")).Text;

        lblPanelID1.Text = ((Label)grdBill.SelectedRow.FindControl("lblPanelID")).Text;

        lblLedgertransactionNo.Text = ((Label)grdBill.SelectedRow.FindControl("lblLedTnxNo")).Text;
        ViewState["PaidType"] = ((Label)grdBill.SelectedRow.FindControl("lblPaidType")).Text;
        lblTypeOfTnx.Text = ((Label)grdBill.SelectedRow.FindControl("lblTypeOfTnx")).Text;
        lblDeptLedgerNo.Text = ((Label)grdBill.SelectedRow.FindControl("lblDeptLedgerNo")).Text;
        lblIsOTCollection.Text = ((Label)grdBill.SelectedRow.FindControl("lblOTCollection")).Text;
        btnSave.Enabled = true;
        //  DataTable dtSearch = OPD.SearchOPDFinalSettlement(txtPatientID.Text.Trim(), ddlPanelCompany.SelectedItem.Value.Split('#')[0], txtFromDate.Text, txtToDate.Text);

        // DataTable dt1= ViewState["BillDetail"] as DataTable;
        decimal pendingAmt = Util.GetDecimal(((Label)grdBill.SelectedRow.FindControl("lblPendingAmt")).Text);
        if (pendingAmt <= 0)
        {
            chkRefund.Visible = true;
            chkRefund.Checked = true;
            chkRefund.Enabled = false;
            lblAmtType.Text = "Refund :";
        }
        else
        {
            chkRefund.Visible = false;
            lblAmtType.Text = "Balance :";
        }
        ((DropDownList)PaymentControl.FindControl("ddlCountry")).SelectedValue = GetGlobalResourceObject("Resource", "BaseCurrencyID").ToString();
        AllSelectQuery asq = new AllSelectQuery();
        decimal rate = asq.ConvertCurrencyBase(Util.GetInt(((DropDownList)PaymentControl.FindControl("ddlCountry")).SelectedValue), Util.GetDecimal(txtAmount.Text.Trim()));
        ((Label)PaymentControl.FindControl("lblCurrencyBase")).Text = Util.GetDecimal(rate) + " " + GetGlobalResourceObject("Resource", "BaseCurrencyNotation").ToString();
        ((TextBox)PaymentControl.FindControl("txtCurrencyBase")).Text = Util.GetDecimal(rate).ToString();
        ((TextBox)PaymentControl.FindControl("txtCurrencyRoffAmt")).Text = "0";
        ((Label)PaymentControl.FindControl("lblCurrencyRoffAmt")).Text = "0";


        decimal OPDAdvance = AllLoadData_OPD.patientOPDAdv(lblMRNo.Text);
        lblOPDAdvance.Text = OPDAdvance.ToString();

        if (OPDAdvance > 0)
        {
            ListItem item = ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Items.FindByValue("5");
            if (item == null)
                ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Items.Insert((((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Items.Count - 1), new ListItem("OPD-Advance", "5"));
        }
        else
        {
            lblOPDAdvance.Text = "0";
            ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Items.Remove(((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Items.FindByValue("5"));
        }
    }
    [WebMethod]
    public static string getItemDetail(string ledgerTransactionNo)
    {

        DataTable dt = StockReports.GetDataTable("SELECT split_str(LTD.ItemName,'(Batch : ',1) AS Item,Rate,Quantity,BatchNumber,Date_FORMAT(medExpiryDate,'%d-%b-%y')MedExpiryDate FROM f_ledgertnxdetail ltd WHERE LedgerTransactionNO='" + ledgerTransactionNo + "' ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
}
