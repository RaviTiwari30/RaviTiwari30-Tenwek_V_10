using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Design_Controls_wuc_PaymentDetails : System.Web.UI.UserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCurrencyDetail();
            if (((Label)Parent.FindControl("lblAppGetPayment")) != null)
                bindPaymentModePanelWise(((Label)Parent.FindControl("lblPanelIDOPDPayment")).Text);
            else if (((Label)Parent.FindControl("lblBookDirectAppointment")) != null)
                bindPaymentModePanelWise(((DropDownList)Parent.FindControl("ddlPanel")).SelectedItem.Value);
            else
                BindPaymentMode();
            All_LoadData.BindBank(ddlBank);
            All_LoadData.bindApprovalType(ddlApproveBy);
            lblGovTaxPercentage.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
            // lblGovTaxPer.Text = "Gov. Tax (" + (lblGovTaxPercentage.Text).TrimStart('0').TrimEnd('0', '.') + " %) :&nbsp; ";
        }
        txtBillAmount.Attributes.Add("readOnly", "true");
        txtNetAmount.Attributes.Add("readOnly", "true");
        txtTotalPaidAmount.Attributes.Add("readOnly", "true");
        txtGovTaxAmt.Attributes.Add("readOnly", "true");
        txtCurrencyRoffAmt.Attributes.Add("readOnly", "true");
      //  txtPaidAmount.Attributes.Add("readOnly", "false");
    }
    private void bindPaymentModePanelWise(string PanelID)
    {
        ddlPaymentMode.DataSource = All_LoadData.BindPaymentModePanelWise(PanelID);
        ddlPaymentMode.DataTextField = "PaymentMode";
        ddlPaymentMode.DataValueField = "PaymentModeID";
        ddlPaymentMode.DataBind();
    }
    private void BindPaymentMode()
    {
        ddlPaymentMode.DataSource = All_LoadData.BindPaymentMode();
        ddlPaymentMode.DataTextField = "PaymentMode";
        ddlPaymentMode.DataValueField = "PaymentModeID";
        ddlPaymentMode.DataBind();
    }
    protected void LoadCurrencyDetail()
    {
        DataTable dtDetail = All_LoadData.LoadCurrencyFactor("");
        ddlCountry.DataSource = dtDetail;
        ddlCountry.DataTextField = "Currency";
        ddlCountry.DataValueField = "CountryID";
        ddlCountry.DataBind();

        DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");
        ddlCountry.SelectedIndex = ddlCountry.Items.IndexOf(ddlCountry.Items.FindByValue(dr[0]["CountryID"].ToString()));
        lblCurrencyNotation.Text = dr[0]["Notation"].ToString();
        //lblFactor.Text = dr[0]["Selling_Specific"].ToString();
        lblBaseCurrencyID.Text = dr[0]["B_CountryID"].ToString();
        lblBaseCurrency.Text = dr[0]["B_Currency"].ToString();

    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        Label lblMsg = ((Label)Parent.FindControl("lblMsg"));
        if (ddlPaymentMode.SelectedItem.Value != "4")
        {
            if (txtPaidAmount.Text == "" || Util.GetDecimal(txtPaidAmount.Text) <= 0)
            {
                txtPaidAmount.Focus();
                if (lblMsg != null)
                    lblMsg.Text = "Please Enter Amount";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                return;
            }
        }

        if (ddlPaymentMode.SelectedItem.Value == "4")
        {
            
            ddlPaymentMode.Enabled = false;
        }
        else
        {
            ddlPaymentMode.Enabled = true;
        }
        //txtNetAmount.Text
        AllSelectQuery Asq = new AllSelectQuery();
        decimal rate = Asq.ConvertCurrencyBase(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtTotalPaidAmount.Text));
        decimal newRate = Util.GetDecimal(rate) + Util.GetDecimal(txtCurrencyRoffAmt.Text);
        if (newRate + 1 < Util.GetDecimal(txtPaidAmount.Text))
        {
            lblMsg.Text = "Paid amount cannot greater than Balance amount.";
            txtPaidAmount.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
            return;
        }
       
        if (Util.GetDecimal(txtPaidAmount.Text) > Util.GetDecimal(txtCurrencyBase.Text))
        {
            if (lblMsg != null)
                lblMsg.Text = "Paid Amount Exceeding Net Amount";
            txtPaidAmount.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
            return;
        }
       

        if (((RadioButtonList)Parent.FindControl("rdoReturn")) != null)
        {
            string receiptno = ((Label)Parent.FindControl("lblreceiptno")).Text;
            if (receiptno != "")
            {
                if (Math.Round(Util.GetDecimal(((Label)Parent.FindControl("lblBalAmt")).Text)) > 0)
                {
                    lblMsg.Text = "Please Settle Previous Amount";
                    txtPaidAmount.Text = "";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                    return;
                }
            }
        }
        BindPaymentDetail();
        txtPaidAmount.Text = "";
        CalculateAmt();
        blockOtherControl();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
        lblMsg.Text = "";
        ddlBank.SelectedIndex = 0;
        ddlPaymentMode.SelectedIndex = 0;
        txtrefNo.Text = "";
    }

    private void blockOtherControl()
    {
        if (((Panel)Parent.FindControl("pnlTransaction")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((Panel)Parent.FindControl("pnlTransaction")).Enabled = false;
                //  ((DropDownList)Parent.FindControl("ddlPanelCompany")).Enabled = false;
                ((Button)Parent.FindControl("Wuc_Patient1").FindControl("btnNewCity")).Enabled = false;
                ((Button)Parent.FindControl("btnRefferBy")).Enabled = false;
                ((HtmlInputButton)Parent.FindControl("Wuc_Patient1").FindControl("pop1")).Visible = false;
                ((Button)Parent.FindControl("btnSelect")).Enabled = false;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                ((Panel)Parent.FindControl("pnlTransaction")).Enabled = true;
                // ((DropDownList)Parent.FindControl("ddlPanelCompany")).Enabled = true;
                ((Button)Parent.FindControl("Wuc_Patient1").FindControl("btnNewCity")).Enabled = true;
                ((Button)Parent.FindControl("btnRefferBy")).Enabled = true;
                ((HtmlInputButton)Parent.FindControl("Wuc_Patient1").FindControl("pop1")).Visible = true;
                ((Button)Parent.FindControl("btnSelect")).Enabled = true;
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }
        }
        else if (((Panel)Parent.FindControl("pnlPayment")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((Button)Parent.FindControl("btnAddItem")).Enabled = false;
                ((GridView)Parent.FindControl("gvIssueItem")).Enabled = false;
                ((GridView)Parent.FindControl("grdItem")).Enabled = false;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                ((Button)Parent.FindControl("btnAddItem")).Enabled = true;
                ((GridView)Parent.FindControl("gvIssueItem")).Enabled = true;
                ((GridView)Parent.FindControl("grdItem")).Enabled = true;
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }
            ((Label)Parent.FindControl("lblMsg")).Text = "";
        }
       
        else if (((Panel)Parent.FindControl("pnlDirectApp")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((DropDownList)Parent.FindControl("ddlPanel")).Enabled = false;
                ((DropDownList)Parent.FindControl("ddlDoctorList")).Enabled = false;
                ((DropDownList)Parent.FindControl("ddlAppointmentType")).Enabled = false;
                ((HtmlInputButton)Parent.FindControl("pop1")).Visible = false;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                ((DropDownList)Parent.FindControl("ddlPanel")).Enabled = true;
                ((DropDownList)Parent.FindControl("ddlDoctorList")).Enabled = true;
                ((DropDownList)Parent.FindControl("ddlAppointmentType")).Enabled = true;
                ((HtmlInputButton)Parent.FindControl("pop1")).Visible = true;
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }

        }
        else if (((Label)Parent.FindControl("lblCardReg")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((DropDownList)Parent.FindControl("ddlCardTypeReg")).Enabled = false;

                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                ((DropDownList)Parent.FindControl("ddlCardTypeReg")).Enabled = true;

                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }
        }
        else if (((Label)Parent.FindControl("lblOPDPackage")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((DropDownList)Parent.FindControl("ddlPackage")).Enabled = false;
                ((DropDownList)Parent.FindControl("ddlPanelCompany")).Enabled = false;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                ((DropDownList)Parent.FindControl("ddlPackage")).Enabled = true;
                ((DropDownList)Parent.FindControl("ddlPanelCompany")).Enabled = true;
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }
            ((Label)Parent.FindControl("lblMsg")).Text = "";
        }
        else if (((Label)Parent.FindControl("lblOPDRefund")) != null)
        {
            txtDisAmount.Enabled = false;
            txtDisPercent.Enabled = false;
            ddlApproveBy.Enabled = false;
            txtDiscReason.Enabled = false;
            if (grdPaymentMode.Rows.Count > 0)
            {
                for (int i = 0; i < ((GridView)Parent.FindControl("grdItemRate")).Rows.Count; i++)
                {
                    ((CheckBox)(((GridView)Parent.FindControl("grdItemRate")).Rows[i].FindControl("chkItem"))).Enabled = false;
                }
            }
            else
            {
                for (int i = 0; i < ((GridView)Parent.FindControl("grdItemRate")).Rows.Count; i++)
                {
                    ((CheckBox)(((GridView)Parent.FindControl("grdItemRate")).Rows[i].FindControl("chkItem"))).Enabled = true;
                }
            }
            ((Label)Parent.FindControl("lblMsg")).Text = "";
        }
        else   if ((((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null))
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((Button)Parent.FindControl("btnSearchNew")).Enabled = false;
                ((RadioButtonList)Parent.FindControl("rdoType")).Enabled = false;
                ((Button)Parent.FindControl("btnIPDSerch")).Enabled = false; 
                ((Button)Parent.FindControl("btnSearch")).Enabled = false;
                ((RadioButtonList)Parent.FindControl("rdoIssue")).Enabled = false;
                ((Button)Parent.FindControl("btnAdd")).Enabled = false;
                ((Button)Parent.FindControl("btnAddItem")).Enabled = false;
                ((GridView)Parent.FindControl("gvIssueItem")).Enabled = false;
                ((GridView)Parent.FindControl("grdItem")).Enabled = false;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }

            else
            {
                ((Button)Parent.FindControl("btnSearchNew")).Enabled = true;
                ((RadioButtonList)Parent.FindControl("rdoType")).Enabled = true;
                ((Button)Parent.FindControl("btnIPDSerch")).Enabled = true; 
                ((Button)Parent.FindControl("btnSearch")).Enabled = true;
                ((RadioButtonList)Parent.FindControl("rdoIssue")).Enabled = true;
                ((Button)Parent.FindControl("btnAdd")).Enabled = true;
                ((Button)Parent.FindControl("btnAddItem")).Enabled = true;
                ((GridView)Parent.FindControl("gvIssueItem")).Enabled = true;
                ((GridView)Parent.FindControl("grdItem")).Enabled = true;
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }
        }
        else if ((((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null))
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((RadioButtonList)Parent.FindControl("rdoReturn")).Enabled = false;
                ((Button)Parent.FindControl("btnSearch")).Enabled = false;
                ((Button)Parent.FindControl("btnAddItem")).Enabled = false;
                ((GridView)Parent.FindControl("gvIssueItem")).Enabled = false;
                ((GridView)Parent.FindControl("grdItem")).Enabled = false;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                ((RadioButtonList)Parent.FindControl("rdoReturn")).Enabled = true;
                ((Button)Parent.FindControl("btnSearch")).Enabled = true;
                ((Button)Parent.FindControl("btnAddItem")).Enabled = true;
                ((GridView)Parent.FindControl("gvIssueItem")).Enabled = true;
                ((GridView)Parent.FindControl("grdItem")).Enabled = true;
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
        }
        else if ((((Label)Parent.FindControl("lblIPDPharmacyReturn")) != null))
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((Button)Parent.FindControl("btnSearchItem")).Enabled = false;
                for (int i = 0; i < ((GridView)Parent.FindControl("grdReturnItem")).Rows.Count; i++)
                {
                    ((ImageButton)(((GridView)Parent.FindControl("grdReturnItem")).Rows[i].FindControl("imbRemove"))).Enabled = false;
                }
            }
            else
            {
                ((Button)Parent.FindControl("btnSearchItem")).Enabled = true;
                for (int i = 0; i < ((GridView)Parent.FindControl("grdReturnItem")).Rows.Count; i++)
                {
                    ((ImageButton)(((GridView)Parent.FindControl("grdReturnItem")).Rows[i].FindControl("imbRemove"))).Enabled = true;
                }
            }

        }
        else
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                txtDisAmount.Enabled = false;
                txtDisPercent.Enabled = false;
                ddlApproveBy.Enabled = false;
                txtDiscReason.Enabled = false;
            }
            else
            {
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                ddlApproveBy.Enabled = true;
                txtDiscReason.Enabled = true;
            }
        }
        if (((RadioButtonList)Parent.FindControl("rdoPatient")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((RadioButtonList)Parent.FindControl("rdoPatient")).Enabled = false;
            }
            else
            {
                ((RadioButtonList)Parent.FindControl("rdoPatient")).Enabled = true;
            }
        }
        
       
    }
    protected void BindPaymentDetail()
    {
        DataTable dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
        if (dtPaymentDetail == null)
        {
            GetDatatable();
            dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
        }
        AllSelectQuery ASQ = new AllSelectQuery();
        DataRow row = dtPaymentDetail.NewRow();
        row["PaymentModeID"] = ddlPaymentMode.SelectedItem.Value;
        row["PaymentMode"] = ddlPaymentMode.SelectedItem.Text;
        row["Currency"] = ddlCountry.SelectedItem.Text;
        row["CountryID"] = ddlCountry.SelectedItem.Value;
        row["CFactor"] = ASQ.GetConversionFactor(Util.GetInt(ddlCountry.SelectedItem.Value)).ToString();
        row["Amount"] = txtPaidAmount.Text.Trim();
        row["BankName"] = ddlBank.SelectedItem.Text;
        row["RefNo"] = txtrefNo.Text.Trim();
        row["BaseCurrency"] = lblBaseCurrency.Text;
        row["BaseCurrencyAmount"] = ASQ.ConvertCurrency(Util.GetInt(ddlCountry.SelectedItem.Value), Util.GetDecimal(txtPaidAmount.Text)).ToString();
        row["Notation"] = lblCurrencyNotation.Text;
        row["CurrencyRoundOff"] = txtCurrencyRoffAmt.Text.Trim();
        dtPaymentDetail.Rows.Add(row);
        grdPaymentMode.DataSource = dtPaymentDetail;
        grdPaymentMode.DataBind();

    }
    private void CalculateAmt()
    {
        decimal TotalPaidAmt = 0;
        if ((Util.GetDecimal(txtDisAmount.Text) > 0))
        {
            txtNetAmount.Text = (Util.GetDecimal(txtBillAmount.Text) - Util.GetDecimal(txtDisAmount.Text)).ToString();
            txtDisPercent.Text = "";
            if ((((Label)Parent.FindControl("lblCardRegistration")) != null) || (((Label)Parent.FindControl("lblAppGetPayment")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null) || (((Label)Parent.FindControl("lblBookDirectAppointment")) != null))
            {
                txtGovTaxAmt.Text = "0";
            }
            else
            {
                txtGovTaxAmt.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text) * Util.GetDecimal(lblGovTaxPercentage.Text) / 100), 2, System.MidpointRounding.AwayFromZero).ToString();
            }
            TotalPaidAmt = Util.GetDecimal(txtNetAmount.Text) + Util.GetDecimal(txtGovTaxAmt.Text);          
            txtTotalPaidAmount.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text)) + (Util.GetDecimal(txtGovTaxAmt.Text))).ToString();
            
        }
        else if (Util.GetDecimal(txtDisPercent.Text) > 0)
        {
            txtNetAmount.Text = Util.GetString(Util.GetDecimal(txtBillAmount.Text) - Math.Round((Util.GetDecimal(txtBillAmount.Text) * Util.GetDecimal(txtDisPercent.Text) / 100), 2, MidpointRounding.AwayFromZero));
            txtDisAmount.Text = "";
            if ((((Label)Parent.FindControl("lblCardRegistration")) != null) || (((Label)Parent.FindControl("lblAppGetPayment")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null) || (((Label)Parent.FindControl("lblBookDirectAppointment")) != null))
            {
                txtGovTaxAmt.Text = "0";
            }
            else
            {
                txtGovTaxAmt.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text) * Util.GetDecimal(lblGovTaxPercentage.Text) / 100), 2, System.MidpointRounding.AwayFromZero).ToString();
            }
            TotalPaidAmt = Util.GetDecimal(txtNetAmount.Text) + Util.GetDecimal(txtGovTaxAmt.Text);
            txtTotalPaidAmount.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text)) + (Util.GetDecimal(txtGovTaxAmt.Text))).ToString();

        }
        else
        {
            txtDisPercent.Text = "";
            txtDisAmount.Text = "";
            txtNetAmount.Text = txtBillAmount.Text;
            if ((((Label)Parent.FindControl("lblCardRegistration")) != null) || (((Label)Parent.FindControl("lblAppGetPayment")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null) || (((Label)Parent.FindControl("lblBookDirectAppointment")) != null))
            {
                txtGovTaxAmt.Text = "0";
            }
            else
            {
                txtGovTaxAmt.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text) * Util.GetDecimal(lblGovTaxPercentage.Text) / 100), 2, System.MidpointRounding.AwayFromZero).ToString();
            }
            TotalPaidAmt = Util.GetDecimal(txtNetAmount.Text) + Util.GetDecimal(txtGovTaxAmt.Text);          
            txtTotalPaidAmount.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text)) + (Util.GetDecimal(txtGovTaxAmt.Text))).ToString();

        }
        decimal amt = 0;
        foreach (GridViewRow row in grdPaymentMode.Rows)
        {
            amt += Util.GetDecimal(((Label)row.FindControl("lblBaseCurrencyAmount")).Text);

        }

        
        amt = Math.Round(amt, 2,MidpointRounding.AwayFromZero);
        lblTotalPaidAmount.Text = amt.ToString();

        //if ((((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null))
        //{
        //    decimal currencyRoffAmt = 0;

        //    if ((GetGlobalResourceObject("Resource", "BaseCurrencyID").ToString()) != ddlCountry.SelectedValue)
        //    {
        //        AllSelectQuery ASQ = new AllSelectQuery();
        //        decimal roundVal = ASQ.ConvertCurrency(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtCurrencyRoffAmt.Text));

        //        lblRoundVal.Text = Util.GetDecimal(roundVal).ToString();
        //        txtConvertCurrency.Text = Util.GetDecimal(roundVal).ToString();
        //        lblBalanceAmount.Text = Math.Round(((Util.GetDecimal(txtTotalPaidAmount.Text)) + (Util.GetDecimal(lblRoundVal.Text)) + Util.GetDecimal(currencyRoffAmt) - (Util.GetDecimal(lblTotalPaidAmount.Text))), 2, System.MidpointRounding.AwayFromZero).ToString();
        //    }
        //    else
        //    {
        //        lblRoundVal.Text = txtConvertCurrency.Text;
        //        lblBalanceAmount.Text = Math.Round((Util.GetDecimal(txtTotalPaidAmount.Text) + Util.GetDecimal(lblRoundVal.Text) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();

                
        //    }
        //}
        //else
        //{
            lblBalanceAmount.Text = Math.Round((Util.GetDecimal(txtTotalPaidAmount.Text) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();
            lblRoundVal.Text = Math.Round((Util.GetDecimal(txtTotalPaidAmount.Text) - Util.GetDecimal(TotalPaidAmt)), 2, System.MidpointRounding.AwayFromZero).ToString();
        //}
    }
    private void GetDatatable()
    {
        DataTable dtPaymentDetail = new DataTable();
        dtPaymentDetail.Columns.Add(new DataColumn("PaymentModeID"));
        dtPaymentDetail.Columns.Add(new DataColumn("PaymentMode"));
        dtPaymentDetail.Columns.Add(new DataColumn("Currency"));
        dtPaymentDetail.Columns.Add(new DataColumn("CountryID"));
        dtPaymentDetail.Columns.Add(new DataColumn("CFactor"));
        dtPaymentDetail.Columns.Add(new DataColumn("Amount"));
        dtPaymentDetail.Columns.Add(new DataColumn("BankName"));
        dtPaymentDetail.Columns.Add(new DataColumn("RefNo"));
        dtPaymentDetail.Columns.Add(new DataColumn("BaseCurrency"));
        dtPaymentDetail.Columns.Add(new DataColumn("BaseCurrencyAmount"));
        dtPaymentDetail.Columns.Add(new DataColumn("Notation"));
        dtPaymentDetail.Columns.Add(new DataColumn("CurrencyRoundOff"));
        ViewState["dtPaymentDetail"] = dtPaymentDetail;
    }
    protected bool validateItem()
    {
        foreach (GridViewRow row in grdPaymentMode.Rows)
        {
            string itemId = ((Label)row.FindControl("lblCountryID")).Text;
            if (ddlCountry.SelectedValue == itemId)
            {
                return false;
            }
        }
        if (ddlPaymentMode.SelectedValue != "1" || ddlPaymentMode.SelectedValue != "4")
        {
            if (ddlBank.SelectedIndex == 0 || txtrefNo.Text.Trim() == "")
                return false;
        }
        return true;
    }
    protected void grdPaymentMode_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int index = Util.GetInt(e.CommandArgument);
        ddlPaymentMode.Enabled = true;
        ddlPaymentMode.SelectedIndex = 0;
        txtPaidAmount.Text = "";
        ddlCountry.SelectedValue = Util.GetString(((Label)grdPaymentMode.Rows[index].FindControl("lblCountryID")).Text);
        
        DataTable dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
       string preAmt  = Util.GetString(((Label)grdPaymentMode.Rows[index].FindControl("lblAmount")).Text);
        
        if (dtPaymentDetail.Rows.Count > 0)
        {
            ViewState["currencyRoundOff"] = Util.GetDecimal(((Label)grdPaymentMode.Rows[index].FindControl("lblCurrencyRoundOff")).Text);
            int countryID = Util.GetInt(((Label)grdPaymentMode.Rows[index].FindControl("lblCountryID")).Text);
            decimal baseCurrency = Util.GetDecimal((((Label)grdPaymentMode.Rows[index].FindControl("lblBaseCurrencyAmount")).Text));
            dtPaymentDetail.Rows[index].Delete();
            dtPaymentDetail.AcceptChanges();
            ViewState["dtPaymentDetail"] = dtPaymentDetail;
            grdPaymentMode.DataSource = dtPaymentDetail;
            grdPaymentMode.DataBind();
            //if ((((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null))
            //{

            //    RecalculateAmt(countryID, (decimal)ViewState["currencyRoundOff"], baseCurrency);
            //}

            //else
            //{
                CalculateAmt();
           // }

        }

        //if ((((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null))
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "getMinCurrency(" + ddlCountry.SelectedValue + ");", true);

        //    txtCurrencyRoffAmt.Text = Util.GetDecimal((decimal)ViewState["currencyRoundOff"]).ToString();
        //}
        //else
        //{
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);

       // }
            txtPaidAmount.Text = preAmt;
        blockOtherControl();

    }

    private void RecalculateAmt(int countryID, decimal currencyRoundOff, decimal baseCurrency)
    {
        if ((((Label)Parent.FindControl("lblOPDPharmacyIssue")) != null) || (((Label)Parent.FindControl("lblOPDPharmacyReturn")) != null))
        {


            
            
                decimal amt = 0;
                AllSelectQuery aSQ = new AllSelectQuery();
                decimal roundVal = aSQ.ConvertCurrency(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(currencyRoundOff));
                foreach (GridViewRow row in grdPaymentMode.Rows)
                {
                    amt += Util.GetDecimal(((Label)row.FindControl("lblBaseCurrencyAmount")).Text);

                }

                amt = Math.Round((amt), 2, MidpointRounding.AwayFromZero);

                if ((GetGlobalResourceObject("Resource", "BaseCurrencyID").ToString()) != Util.GetString(countryID))
                {
                    //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "getConvertCurrency(" + ddlCountry.SelectedValue + "," + Util.GetDecimal(txtCurrencyRoffAmt.Text) + ");", true);

                   
                        //  decimal baseAmt = Util.GetDecimal((decimal)ViewState["BaseCurrency"]) - Util.GetDecimal(roundVal);
                        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "getCurrencyBase(" + currencyID + "," + Util.GetDecimal(baseAmt) + ");", true);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "changeBaseAmtPharmacy(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);

                  

                    decimal currencyRoffAmt = Util.GetDecimal(roundVal);
                    lblRoundVal.Text = Util.GetString(currencyRoffAmt - Util.GetDecimal(lblRoundVal.Text));


                    lblBalanceAmount.Text = Math.Round(((Util.GetDecimal(txtTotalPaidAmount.Text)) - (Util.GetDecimal(amt))), 2, System.MidpointRounding.AwayFromZero).ToString();
                    lblTotalPaidAmount.Text = amt.ToString();

                    // txtConvertCurrency.Text = Util.GetDecimal(roundVal).ToString();
                    // lblBalanceAmount.Text = "0"; txtCurrencyRoffAmt.Text = "0";
                    // lblBalanceAmount.Text = Math.Round((Util.GetDecimal(txtTotalPaidAmount.Text) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();

                }

                else
                {
                    //  if ((GetGlobalResourceObject("Resource", "BaseCurrencyID").ToString()) != Util.GetString(currencyID))
                    //  {
                    //      amt = amt + roundVal;
                    //  }
                    //  lblRoundVal.Text = Util.GetDecimal(roundVal).ToString();
                  //  decimal baseAmt = Util.GetDecimal(baseCurrency) - Util.GetDecimal(lblRoundVal.Text);
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "changeBaseAmt(" + Util.GetDecimal(baseAmt) + ");", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);

                    lblBalanceAmount.Text = Math.Round((Util.GetDecimal(txtTotalPaidAmount.Text) + Util.GetDecimal(lblRoundVal.Text) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();

                    lblTotalPaidAmount.Text = amt.ToString();
                }
                //   else
                //   {
                //        currencyRoffAmt = Util.GetDecimal(txtCurrencyRoffAmt.Text);
                //       lblBalanceAmount.Text = Math.Round(((Util.GetDecimal(txtTotalPaidAmount.Text) + Util.GetDecimal(currencyRoffAmt)) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();
                //       lblRoundVal.Text = Math.Round((Util.GetDecimal(txtTotalPaidAmount.Text) + Util.GetDecimal(currencyRoffAmt) - Util.GetDecimal(TotalPaidAmt)), 2, System.MidpointRounding.AwayFromZero).ToString();

                //  }
                if (grdPaymentMode.Rows.Count == 0)
                {
                    lblRoundVal.Text = "0";
                    txtConvertCurrency.Text = "0";
                }
            }

        
    }

}
