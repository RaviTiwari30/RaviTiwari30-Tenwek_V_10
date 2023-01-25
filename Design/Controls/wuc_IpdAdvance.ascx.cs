using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Controls_wuc_IpdAdvance : System.Web.UI.UserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCurrencyDetail();
            BindPaymentMode();
            All_LoadData.BindBank(ddlBank);
        }
        txtNetAmount.Attributes.Add("readOnly", "true");
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
        lblBaseCurrencyID.Text = dr[0]["B_CountryID"].ToString();
        lblBaseCurrency.Text = dr[0]["B_Currency"].ToString();
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        AllSelectQuery asq = new AllSelectQuery();
        Label lblMsg = ((Label)Parent.FindControl("lblMsg"));
        if (txtPaidAmount.Text == "")
        {
            txtPaidAmount.Focus();
            if (lblMsg != null)
                lblMsg.Text = "Please enter amount.";
            return;
        }
        if (ddlPaymentMode.SelectedValue == "5")
        {
            decimal OPDAdvance = Util.GetDecimal(((Label)Parent.FindControl("lblOPDAdvance")).Text);
            if ((OPDAdvance > 0) && (Util.GetDecimal(txtPaidAmount.Text)> OPDAdvance))
            {
                txtPaidAmount.Focus();
                if (lblMsg != null)
                    lblMsg.Text = "Please Pay valid Amount";
                return;
            }
        }
        if ((((RadioButtonList)Parent.FindControl("chkHospLedger")) != null))
        {
            if ((((RadioButtonList)Parent.FindControl("chkHospLedger")).SelectedItem.Text == "ADVANCE-COL"))
            {
                
                decimal rate = asq.ConvertCurrencyBase(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtNetAmount.Text));
            }
            else if ((((RadioButtonList)Parent.FindControl("chkHospLedger")).SelectedItem.Text == "FINAL BILL SETTLEMENT") && (((CheckBox)Parent.FindControl("chkRefund")).Checked == true))
            {
               
               
                decimal rate = asq.ConvertCurrencyBase(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtNetAmount.Text));
                if (rate + 1 < Util.GetDecimal(txtPaidAmount.Text))
                {
                    lblMsg.Text = "Paid amount cannot greater than Balance amount.";
                    return;
                }
                if (Util.GetDecimal(txtPaidAmount.Text) > Util.GetDecimal(txtNetAmount.Text) - Util.GetDecimal(lblTotalPaidAmount.Text))
                {
                    if (lblMsg != null)
                        lblMsg.Text = "Paid amount cannot greater than Balance amount.";
                    txtPaidAmount.Text = "";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                    return;
                }
            }
            else if ((((RadioButtonList)Parent.FindControl("chkHospLedger")).SelectedItem.Text == "FINAL BILL SETTLEMENT") && (((CheckBox)Parent.FindControl("chkRefund")).Checked == false))
            {
               
                
                decimal rate = asq.ConvertCurrencyBase(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtNetAmount.Text));
                if (rate + 1 < Util.GetDecimal(txtPaidAmount.Text))
                {
                    lblMsg.Text = "Paid amount cannot greater than Balance amount.";
                    return;
                }
                if (Util.GetDecimal(txtPaidAmount.Text) > Util.GetDecimal(txtNetAmount.Text) - Util.GetDecimal(lblTotalPaidAmount.Text))
                {

                    if (lblMsg != null)
                        lblMsg.Text = "Paid amount cannot greater than Balance amount.";

                    txtPaidAmount.Text = "";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                    return;

                }
            }
        }
        else
        {
           
            decimal rate = asq.ConvertCurrencyBase(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtNetAmount.Text));
            decimal newRate = Util.GetDecimal(rate) + Util.GetDecimal(txtCurrencyRoffAmt.Text);

            if (newRate < Util.GetDecimal(txtPaidAmount.Text))
            {
                lblMsg.Text = "Paid amount cannot greater than Balance amount.";
                txtPaidAmount.Focus();
                return;
            }
            
            if (Util.GetDecimal(txtPaidAmount.Text) > Util.GetDecimal(txtCurrencyBase.Text) )
            {

                if (lblMsg != null)
                    lblMsg.Text = "Paid amount cannot greater than Balance amount.";
                txtPaidAmount.Focus();

                txtPaidAmount.Text = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                return;

            }
            decimal amt = asq.ConvertCurrencyBase(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(lblBalanceAmount.Text));
            decimal newamt = Util.GetDecimal(amt) + Util.GetDecimal(txtCurrencyRoffAmt.Text);

            if (newamt < Util.GetDecimal(txtPaidAmount.Text))
            {
                lblMsg.Text = "Paid amount cannot greater than Balance amount.";
                txtPaidAmount.Focus();
                return;
            }
        }
        BindPaymentDetail();
        txtPaidAmount.Text = "";
        CalculateAmt();
        blockOtherControl();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
        lblMsg.Text = "";
        ddlBank.SelectedIndex = 0;
        ddlPaymentMode.SelectedIndex = 0;
        txtrefNo.Text = "";

 
    }
    private void blockOtherControl()
    {
        //if ((((RadioButtonList)Parent.FindControl("chkHospLedger")) != null))
        //{
        //    if ((((RadioButtonList)Parent.FindControl("chkHospLedger")).SelectedItem.Text != null))
        //    {
        //        if (grdPaymentMode.Rows.Count > 0)
        //        {
        //            ((RadioButtonList)Parent.FindControl("chkHospLedger")).Enabled = false;
        //            ((CheckBox)Parent.FindControl("chkRefund")).Enabled = false;
        //        }
        //        else
        //        {
        //            ((RadioButtonList)Parent.FindControl("chkHospLedger")).Enabled = false;
        //            ((CheckBox)Parent.FindControl("chkRefund")).Enabled = true;
        //        }
        //    }
        //}
        if (((Panel)Parent.FindControl("pnlRecord")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((Panel)Parent.FindControl("pnlRecord")).Enabled = false;
                ((Button)Parent.FindControl("btnView")).Enabled = false;
              ((RadioButton)Parent.FindControl("rdbAdmitted")).Enabled = false;
              ((RadioButton)Parent.FindControl("rdbDischarged")).Enabled = false;  
                    
            }
            else
            {
                ((Panel)Parent.FindControl("pnlRecord")).Enabled = true;
                ((Button)Parent.FindControl("btnView")).Enabled = true;
                ((RadioButton)Parent.FindControl("rdbAdmitted")).Enabled = true;
                ((RadioButton)Parent.FindControl("rdbDischarged")).Enabled = true; 
            }
        }
        if (((Panel)Parent.FindControl("pnlHideSettlement")) != null)
        {
            if (grdPaymentMode.Rows.Count > 0)
            {
                ((Panel)Parent.FindControl("pnlHideSettlement")).Enabled = false;
                ((Button)Parent.FindControl("btnView")).Enabled = false;               
            }
            else
            {
                ((Panel)Parent.FindControl("pnlHideSettlement")).Enabled = true;
                ((Button)Parent.FindControl("btnView")).Enabled = true;              
            }
        }

    }
   
    public void BindPaymentDetail()
    {
        DataTable dtPaymentDetail = ViewState["dtPaymentDetails"] as DataTable;
        if (dtPaymentDetail == null)
        {
            GetDatatable();
            dtPaymentDetail = ViewState["dtPaymentDetails"] as DataTable;
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
        decimal amt = 0;
        foreach (GridViewRow row in grdPaymentMode.Rows)
        {
            amt += Util.GetDecimal(((Label)row.FindControl("lblBaseCurrencyAmount")).Text);

        }
        
        decimal netval = amt;
     
        lblTotalPaidAmount.Text = amt.ToString();
        if ((((RadioButtonList)Parent.FindControl("chkHospLedger")) != null))
        {
            if ((((RadioButtonList)Parent.FindControl("chkHospLedger")).SelectedItem.Text == "FINAL BILL SETTLEMENT") && (((CheckBox)Parent.FindControl("chkRefund")).Checked == true))
            {
                decimal netAmount = Math.Abs((Util.GetDecimal(txtNetAmount.Text)));
                lblBalanceAmount.Text = Util.GetString(Util.GetDecimal(netAmount) - amt);
            }
            else
            {
                lblBalanceAmount.Text = Util.GetString(Util.GetDecimal(txtNetAmount.Text) - amt);
            }
            lblRoundVal.Text = Util.GetString(amt - netval);
        }
        else
        {
            
                    
            decimal currencyRoffAmt = 0;
            if ((GetGlobalResourceObject("Resource", "BaseCurrencyID").ToString()) != ddlCountry.SelectedValue)
            {
                AllSelectQuery asq = new AllSelectQuery();
                decimal roundVal = asq.ConvertCurrency(Util.GetInt(ddlCountry.SelectedValue), Util.GetDecimal(txtCurrencyRoffAmt.Text));
                decimal newRoundVal = Util.GetDecimal(lblRoundVal.Text);
                lblRoundVal.Text = Util.GetDecimal(Util.GetDecimal(roundVal) + Util.GetDecimal(newRoundVal)).ToString();
                lblBalanceAmount.Text = Math.Round(((Util.GetDecimal(txtNetAmount.Text)) + (Util.GetDecimal(lblRoundVal.Text)) + Util.GetDecimal(currencyRoffAmt) - (Util.GetDecimal(lblTotalPaidAmount.Text))), 2, System.MidpointRounding.AwayFromZero).ToString();

            }
            else
            {
                lblRoundVal.Text = "0";
                lblBalanceAmount.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text) + Util.GetDecimal(lblRoundVal.Text) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();

            }
            txtCurrencyRoffAmt.Text = "0";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "changeBaseAmtRoundoff(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);

           // txtCurrencyBase.Text = lblBalanceAmount.Text;
        }
        if (grdPaymentMode.Rows.Count >= 1)
        {
            foreach (GridViewRow row in grdPaymentMode.Rows)
            {
                if (Util.GetDecimal(((Label)row.FindControl("lblCurrencyRoundOff")).Text) > 0)
                {
                    lblCurrencyRoffAmt.Text = "0";
                }
            }

        }
       
    }
    public void GetDatatable()
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
        ViewState["dtPaymentDetails"] = dtPaymentDetail;
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
        return true;
    }
   

    protected void grdPaymentMode_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int index = Util.GetInt(e.CommandArgument);
        ddlPaymentMode.SelectedIndex = 0;
        ddlCountry.SelectedValue = Util.GetString(((Label)grdPaymentMode.Rows[index].FindControl("lblCountryID")).Text);

        DataTable dtPaymentDetail = ViewState["dtPaymentDetails"] as DataTable;
        if (dtPaymentDetail.Rows.Count > 0)
        {
            ViewState["currencyRoundOff"] = Util.GetDecimal(((Label)grdPaymentMode.Rows[index].FindControl("lblCurrencyRoundOff")).Text);
            int countryID = Util.GetInt(((Label)grdPaymentMode.Rows[index].FindControl("lblCountryID")).Text);
            decimal baseCurrency = Util.GetDecimal((((Label)grdPaymentMode.Rows[index].FindControl("lblBaseCurrencyAmount")).Text));
            dtPaymentDetail.Rows[index].Delete();
            dtPaymentDetail.AcceptChanges();
            ViewState["dtPaymentDetails"] = dtPaymentDetail;
            grdPaymentMode.DataSource = dtPaymentDetail;
            grdPaymentMode.DataBind();
            if (((decimal)ViewState["currencyRoundOff"]) ==0 )
            CalculateAmt();
            else
                RecalculateAmt(countryID, (decimal)ViewState["currencyRoundOff"], baseCurrency);

            if ((((RadioButtonList)Parent.FindControl("chkHospLedger")) != null))
            {
                
                decimal totalPaidAmt = 0;
                if(((RadioButtonList)Parent.FindControl("chkHospLedger")).SelectedValue=="LSHHI12")
                {
                    totalPaidAmt = Util.GetDecimal(Util.GetDecimal(((Label)Parent.FindControl("lblTotalBill_Amt")).Text) + Util.GetDecimal(((Label)Parent.FindControl("lblRoundOff")).Text)) - Util.GetDecimal(Util.GetDecimal( ((Label)Parent.FindControl("lblPanelApp_Amt")).Text) + Util.GetDecimal(((Label)Parent.FindControl("lblPaidAmt")).Text));

                    if (totalPaidAmt < 0)
                        ((CheckBox)Parent.FindControl("chkRefund")).Checked = true;
                    else
                        ((CheckBox)Parent.FindControl("chkRefund")).Checked = false;

                }
                ((RadioButtonList)Parent.FindControl("chkHospLedger")).Enabled = false;
            }

        }
        if (((decimal)ViewState["currencyRoundOff"]) == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);          
        }
        else
        {
          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "getMinCurrency(" + ddlCountry.SelectedValue + ");", true);
          //  txtCurrencyRoffAmt.Text = Util.GetDecimal((decimal)ViewState["currencyRoundOff"]).ToString();
            lblCurrencyRoffAmt.Text = Util.GetDecimal((decimal)ViewState["currencyRoundOff"]).ToString();
        }

           blockOtherControl();        
    }
    private void RecalculateAmt(int countryID, decimal currencyRoundOff, decimal baseCurrency)
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
                    if (baseCurrency != Util.GetDecimal(null))
                    {
                       // decimal currencyRound = Util.GetDecimal(txtPaidAmount.Text) + Util.GetDecimal(currencyRoundOff);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "changeBaseAmtRoundoff(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                    }
                    decimal currencyRoffAmt = Util.GetDecimal(roundVal);
                    lblRoundVal.Text = Util.GetString(Util.GetDecimal(lblRoundVal.Text) - currencyRoffAmt);
                    lblBalanceAmount.Text = Math.Round(((Util.GetDecimal(txtNetAmount.Text)) - (Util.GetDecimal(amt))), 2, System.MidpointRounding.AwayFromZero).ToString();
                    lblTotalPaidAmount.Text = amt.ToString();                  
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "changeBaseAmt(" + Util.GetDecimal(txtPaidAmount.Text) + ");", true);
                    lblBalanceAmount.Text = Math.Round((Util.GetDecimal(txtNetAmount.Text) + Util.GetDecimal(lblRoundVal.Text) - amt), 2, System.MidpointRounding.AwayFromZero).ToString();
                    lblTotalPaidAmount.Text = amt.ToString();
                }

                if (grdPaymentMode.Rows.Count == 0)
                {
                    lblRoundVal.Text = "0";
                    txtCurrencyRoffAmt.Text = "0";
                }
            

       
    }

}