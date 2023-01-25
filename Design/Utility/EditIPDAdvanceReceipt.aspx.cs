using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Utility_EditIPDAdvanceReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            cdFrom.EndDate = System.DateTime.Now;
            cdTo.EndDate = System.DateTime.Now;
            lblMsg.Text = "";
            btnSearch.Visible = true;
        }

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {     
        bindGV("All"); 
    }

    public void bindGV(string Filter)
    {
      
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT IF(rl.ReceiptNo IS NULL,'transparent','green')IsRevert,DATE_FORMAT(rt.Date,'%d-%b-%y')Date,pm.`PatientID`,CONCAT(pm.`Title`,' ',pm.`PName`)PName, pm.`Mobile`,(SELECT company_name FROM f_panel_master WHERE PanelID=adj.`PanelID`)Panel,replace(adj.`TransactionID`,'ISHHI','')TransactionID,IFNULL(rt.`ReceiptNo`,'')ReceiptNo,IFNULL(adj.BillNo,'')BillNo,rtp.Amount as AmountPaidInCash,rt.AmountPaid,IF(rl.ReceiptNo IS NULL,rt.AmountPaid,rl.AmountPaid) ActualAmountPaid");
        sb.Append(" FROM f_ipdadjustment adj INNER JOIN f_reciept rt ON rt.`TransactionID`=adj.`TransactionID` INNER JOIN f_receipt_paymentdetail rtp ON rtp.ReceiptNo=rt.ReceiptNo AND rtp.PaymentModeID=1  INNER JOIN patient_master pm ON pm.`PatientID`=adj.`PatientID` LEFT JOIN f_reciept_log rl ON rl.ReceiptNo=rt.ReceiptNo WHERE rt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " and RT.`IsCancel`=0 AND adj.PanelID=1 ");
        if (txtIPNo.Text.Trim() != "")
            sb.Append(" and rt.TransactionID='ISHHI" + txtIPNo.Text.Trim() + "' ");
        else
            sb.Append(" and rt.Date >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and rt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
       
        if(Filter != "All")
            sb.Append(" having IsRevert='" + Filter + "' ");
        sb.Append(" order by rt.date,rt.TransactionID ");
       DataTable dtgb = StockReports.GetDataTable(sb.ToString());
        if (dtgb != null && dtgb.Rows.Count > 0)
        {
            divDetail.Visible = true;
            lblMsg.Text = "Total " + dtgb.Rows.Count + " Records Found..";
            lblTotal.Text = "Current Total Received Amount is Rs. " + Util.GetString(dtgb.Compute("sum(AmountPaid)", "")) + " , New Total Received Amount is Rs. " + Util.GetString(dtgb.Compute("sum(AmountPaid)", "")) + " and Difference is Rs. 0 ";
            btnUpdate.Visible = true;
            btnUpdate.Enabled = true;
            btnRevert.Visible = true;
            btnRevert.Enabled = true;
            btnRevert.Text = "Revert";
            btnUpdate.Text = "Update"; 
            grvdetail.DataSource = dtgb;
            grvdetail.DataBind();
            
        }
        else
        {
            divDetail.Visible = false;
            grvdetail.DataSource = null;
            grvdetail.DataBind();
            lblMsg.Text = "No Record Found..";

        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        //if (txtReason.Text.Trim() == string.Empty)
        //{
        //    lblMsg.Text = "Please Enter Reason..";
        //    txtReason.Focus();
        //    return;
        //}
        int count = 0;
        btnUpdate.Enabled = false;
        string ReceiptNo = string.Empty,Sql= string.Empty;
        float AmountPaidTotal = 0.00f, DeductAmt = 0.00f;
        btnUpdate.Text = "Submitting....";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow gvr in grvdetail.Rows)
            {
                if (((CheckBox)gvr.FindControl("chkSelect")).Checked == true)
                {
                   ReceiptNo = Util.GetString(((Label)gvr.FindControl("lblReceiptNo")).Text);
                   AmountPaidTotal = Util.GetFloat(((Label)gvr.FindControl("lblAmountPaidTotal")).Text);
                   DeductAmt = Util.GetFloat(((TextBox)gvr.FindControl("txtDeductAmt")).Text);

                   if (((CheckBox)grvdetail.HeaderRow.FindControl("chkDeductInAmt")).Checked == false)
                       DeductAmt = AmountPaidTotal * DeductAmt * Util.GetFloat(0.01);
                  
                   if (DeductAmt > 0)
                   {
                       count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_reciept_log where  ReceiptNo ='" + ReceiptNo + "' "));
                       if (count == 0)
                       {
                           Sql = "INSERT INTO f_reciept_log(Location ,HospCode ,ID ,ReceiptNo ,Hospital_ID ,LedgerNoCr ,LedgerNoDr ,AsainstLedgerTnxNo ,AmountPaid ,DATE  ,TIME  ,Reciever ,Depositor ,IsPayementByInsurance ,TransactionID ,PanelID ,Cancel_UserID ,CancelDate  ,CancelReason  ,IsCancel ,Discount ,Naration ,EditUserID  ,EditDateTime  ,EditReason ,EditType ,UniqueHash ,ReceivedFrom ,Deductions ,IpAddress  ,Cheque_DDdate  ,RoundOff ,FinanceTransfer ,PaidBy ,SurgeryGroupID ,CreatedBy ,panelInvoiceNo  ,TDS ,WriteOff,CentreID ) SELECT Location ,HospCode ,ID ,ReceiptNo ,Hospital_ID ,LedgerNoCr ,LedgerNoDr ,AsainstLedgerTnxNo ,AmountPaid ,DATE  ,TIME  ,Reciever ,Depositor ,IsPayementByInsurance ,TransactionID ,PanelID ,Cancel_UserID ,CancelDate  ,CancelReason  ,IsCancel ,Discount ,Naration ,EditUserID  ,EditDateTime  ,EditReason ,EditType ,UniqueHash ,ReceivedFrom ,Deductions ,IpAddress  ,Cheque_DDdate  ,RoundOff ,FinanceTransfer ,PaidBy ,SurgeryGroupID ,CreatedBy ,panelInvoiceNo  ,TDS ,WriteOff,CentreID FROM f_reciept WHERE ReceiptNo ='" + ReceiptNo + "' AND CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ";
                           MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                           Sql = "INSERT INTO f_receipt_paymentdetail_log (ID ,ReceiptNo,PaymentModeID ,PaymentMode ,Amount,BankName ,RefNo ,RefDate ,PaymentRemarks ,S_Amount ,S_CountryID,S_Currency,S_Notation,C_factor,deductions,TDS,WriteOff,CentreID,Hospital_ID,isOPDAdvance) SELECT ID ,ReceiptNo,PaymentModeID ,PaymentMode ,Amount,BankName ,RefNo ,RefDate ,PaymentRemarks ,S_Amount ,S_CountryID,S_Currency,S_Notation,C_factor,deductions,TDS,WriteOff,CentreID,Hospital_ID,isOPDAdvance FROM f_receipt_paymentdetail  WHERE ReceiptNo ='" + Util.GetString(ReceiptNo) + "'  and PaymentModeID=1 AND CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "";
                           MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                       }

                       Sql = "update f_reciept set AmountPaid=(AmountPaid-" + DeductAmt + "),IsEdit=1  where receiptNo ='" + ReceiptNo + "' AND CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ";
                       MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                       Sql = "update f_receipt_paymentdetail set Amount=(Amount-" + DeductAmt + "),S_Amount=(S_Amount-" + DeductAmt + ")  WHERE ReceiptNo ='" + Util.GetString(ReceiptNo) + "' and PaymentModeID=1 AND CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ";
                       MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);
                   }
                }
            }

            Tranx.Commit();
            con.Close();
            con.Dispose();
            btnUpdate.Text = "Update";
            btnUpdate.Enabled = true;
            grvdetail.DataSource = null;
            grvdetail.DataBind();
            btnUpdate.Visible = false;
            txtReason.Text = "";
            bindGV("All"); 
            lblMsg.Text = "Receipt Amount updated successfully..";

        }
        catch (Exception ex)
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = ex.Message;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            btnUpdate.Text = "Update";
            btnUpdate.Enabled = true;
        }

    }

    protected void btnRevert_Click(object sender, EventArgs e)
    {
        int ActualRevert = 0;
        //if (txtReason.Text.Trim() == string.Empty)
        //{
        //    lblMsg.Text = "Please Enter Reason..";
        //    txtReason.Focus();
        //    return;
        //}
        btnRevert.Enabled = false;
        string ReceiptNo = string.Empty, Sql = string.Empty,IsRevert="";
        btnRevert.Text = "Reverting....";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow gvr in grvdetail.Rows)
            {
                if (((CheckBox)gvr.FindControl("chkSelect")).Checked == true)
                {
                    ReceiptNo = Util.GetString(((Label)gvr.FindControl("lblReceiptNo")).Text);
                    IsRevert=  Util.GetString(((Label)gvr.FindControl("lblIsRevert")).Text);
                    if(IsRevert == "green")
                    {
                        Sql = "update  f_reciept rt inner join f_reciept_log rl on rt.ReceiptNo=rl.ReceiptNo set rt.AmountPaid=rl.AmountPaid  where rt.receiptNo ='" + ReceiptNo + "' AND rt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                        Sql = "update f_receipt_paymentdetail rtd INNER JOIN f_receipt_paymentdetail_log rtl on rtd.ReceiptNo=rtl.ReceiptNo and rtd.PaymentModeID=rtl.PaymentModeID inner join f_reciept r on r.ReceiptNo=rtd.ReceiptNo set rtd.Amount=rtl.Amount,rtd.S_Amount=rtl.S_Amount  WHERE rtd.ReceiptNo ='" + Util.GetString(ReceiptNo) + "' and rtd.PaymentModeID=1 AND r.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                        Sql = "delete from f_reciept_log WHERE ReceiptNo ='" + Util.GetString(ReceiptNo) + "' and CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                        Sql = "delete rpl.* from f_receipt_paymentdetail_log rpl inner join f_reciept r on r.ReceiptNo=rpl.ReceiptNo WHERE rpl.ReceiptNo ='" + Util.GetString(ReceiptNo) + "' and rpl.PaymentModeID=1 and r.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Sql);

                        ActualRevert = 1;

                    }
                }
             }

            Tranx.Commit();
            con.Close();
            con.Dispose();
            btnRevert.Text = "Revert";
            btnRevert.Enabled = true;
            grvdetail.DataSource = null;
            grvdetail.DataBind();
            btnRevert.Visible = false;
            txtReason.Text = "";
            bindGV("All"); 
            if(ActualRevert==1)
             lblMsg.Text = "Receipt Revert successfully..";
            else
                lblMsg.Text = "No Receipt For Revert..";

        }
        catch (Exception ex)
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = ex.Message;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            btnRevert.Text = "Revert";
            btnRevert.Enabled = true;
        }
    }
    protected void grvdetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
         if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsRevert")).Text == "green")
                e.Row.BackColor = System.Drawing.Color.LightGreen;

        }
        
    }
    protected void btnGreen_Click(object sender, EventArgs e)
    {
        bindGV("green");
    }
    protected void btnActual_Click(object sender, EventArgs e)
    {
        bindGV("transparent");
    }
}
