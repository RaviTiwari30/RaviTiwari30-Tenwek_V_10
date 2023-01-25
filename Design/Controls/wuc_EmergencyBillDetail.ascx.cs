using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Controls_wuc_EmergencyBillDetail : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Label lblLedgerTransactionNo = ((Label)Parent.FindControl("lblLedgerTransactionNo"));
            BindPatientDetails(lblLedgerTransactionNo.Text);
        }
    }

    private void BindPatientDetails(string LedgerTransactionNo)
    {
        string sql = "SELECT l.GrossAmount,(l.GrossAmount-l.DiscountOnTotal)NetAmt, l.NetAmount,l.DiscountOnTotal,l.Adjustment,l.CreditNoteAmt,l.DebitNoteAmt,(l.NetAmount-l.Adjustment)Remaining FROM f_ledgerTransaction l  WHERE l.LedgertransactionNo=" + LedgerTransactionNo + "";
        DataTable dt = StockReports.GetDataTable(sql);

        lblAdvanceAmt.Text = dt.Rows[0]["Adjustment"].ToString();
        lblGrossBillAmt.Text = dt.Rows[0]["GrossAmount"].ToString();
        lblBillDiscount.Text = dt.Rows[0]["DiscountOnTotal"].ToString();
        lblNetAmount.Text = dt.Rows[0]["NetAmt"].ToString();
        lblBalanceAmt.Text = dt.Rows[0]["Remaining"].ToString();
        lblCrNote.Text = dt.Rows[0]["CreditNoteAmt"].ToString();
        lblDrNote.Text = dt.Rows[0]["DebitNoteAmt"].ToString();
        lblNetBillAmt.Text = dt.Rows[0]["NetAmount"].ToString();
    }
}