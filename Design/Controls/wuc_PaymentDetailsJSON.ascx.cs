using System;
using System.Data;

public partial class Design_Controls_wuc_PaymentDetailsJSON : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCurrencyDetail();
            All_LoadData.BindBank(ddlBank);
            All_LoadData.bindApprovalType(ddlApproveBy);
        }
        txtBillAmount.Attributes.Add("readOnly", "true");
        txtNetAmount.Attributes.Add("readOnly", "true");
        txtTotalPaidAmount.Attributes.Add("readOnly", "true");
        txtGovTaxAmt.Attributes.Add("readOnly", "true");
      //  txtPaidAmount.Attributes.Add("readOnly", "true");
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
        ddlCurrency.DataSource = dtDetail;
        ddlCurrency.DataTextField = "Currency";
        ddlCurrency.DataValueField = "CountryID";
        ddlCurrency.DataBind();

        DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");
        ddlCurrency.SelectedIndex = ddlCurrency.Items.IndexOf(ddlCurrency.Items.FindByValue(dr[0]["CountryID"].ToString()));
        txtCurrencyNotation.Text = dr[0]["Notation"].ToString();
        lblBaseCurrencyID.Text = dr[0]["B_CountryID"].ToString();
        lblBaseCurrency.Text = dr[0]["B_Currency"].ToString();
    }
}