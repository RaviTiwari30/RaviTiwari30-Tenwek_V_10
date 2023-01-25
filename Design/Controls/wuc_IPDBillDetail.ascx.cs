using System;
using System.Web.UI.WebControls;

public partial class Design_Controls_wuc_IPDBillDetail : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
              Label lblTID = ((Label)Parent.FindControl("lblTID"));
              BindPatientDetails(lblTID.Text);
        }
    }

    private void BindPatientDetails(string TransactionID)
    {
        AllQuery AQ = new AllQuery();
        lblTaxPer.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
        lblAdvanceAmt.Text = Util.GetString(AQ.GetPaidAmount(TransactionID));
        lblGrossBillAmt.Text = Util.GetString(AQ.GetBillAmount(TransactionID,null));
        decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select IFNULL(SUM(TotalDiscAmt) + (SELECT IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + TransactionID + "'),0) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "'   and isverified=1 and ispackage=0"));//f_ipdadjustment
        lblBillDiscount.Text = Util.GetDecimal(Util.round((TotalDisc))).ToString();
        decimal AmountBilled = Util.GetDecimal(lblGrossBillAmt.Text) - Util.GetDecimal(TotalDisc);
        lblNetAmount.Text = Util.GetDecimal(Util.round((AmountBilled))).ToString();
        lblTotalTax.Text = Util.GetDecimal(Util.round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100))).ToString();
        decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
        lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 0, MidpointRounding.AwayFromZero)).ToString();
        decimal RoundOff = Util.round((Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblNetAmount.Text)));
        lblRoundOff.Text = Util.GetDecimal(Util.round((RoundOff))).ToString();
        decimal TotalDeduction = Util.GetDecimal(AQ.GetTDS(TransactionID)) + Util.GetDecimal(AQ.GetTotalDedutions(TransactionID) + Util.GetDecimal(AQ.GetWriteoff(TransactionID)));
        decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - (Util.GetDecimal(lblAdvanceAmt.Text) + TotalDeduction + RoundOff);
        lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
    }
}