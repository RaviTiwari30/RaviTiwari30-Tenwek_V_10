using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Mortuary_Mortuary_CorpseDischarge : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblCorpseID.Text = Request.QueryString["CorpseID"].ToString();
            lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();

            AllQuery AQ = new AllQuery();
            DataTable dtRelease = AQ.GetCorpseReleasedStatus(lblTransactionID.Text);
            if (dtRelease != null && dtRelease.Rows.Count > 0)
            {
                if (dtRelease.Rows[0]["IsReleased"].ToString() == "1")
                {
                    string Msg = "Corpse is Already Released on " + dtRelease.Rows[0]["ReleasedDateTime"].ToString() + " ";
                    Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
                }
            }


            if (btnRelease.Text != "Edit Discharge")
            {
                ((TextBox)txtDate.FindControl("txtStartDate")).Text = System.DateTime.Today.ToString("dd-MMM-yyyy");
                ((TextBox)StartTime.FindControl("txtTime")).Text = System.DateTime.Now.ToString("hh:mm tt");
            }

            string str = StockReports.ExecuteScalar("SELECT IsRelIntimated FROM mortuary_corpse_deposite WHERE TransactionID='" + lblTransactionID.Text + "' and isCancel=0");
            string permitno = StockReports.ExecuteScalar("SELECT PermitNo FROM mortuary_corpse_master WHERE Corpse_ID='" + lblCorpseID.Text + "' ");
            string nationalid = StockReports.ExecuteScalar("SELECT NationalID FROM mortuary_corpse_master WHERE Corpse_ID='" + lblCorpseID.Text + "' ");
            lblPermitNo.Text = permitno;
            lblNationalID.Text = nationalid;
            if (str == "1")
            {
                btnRelIntimate.Visible = false;
                btnRelease.Visible = true;
                pnlReceiver.Visible = true;
            }
            else
            {
                btnRelIntimate.Visible = true;
                btnRelease.Visible = false;
                pnlReceiver.Visible = false;
            }

            GetBillDetails();
        }
        ((TextBox)txtDate.FindControl("txtStartDate")).Attributes.Add("readOnly", "true");
    }

    private void GetBillDetails()
    {
        if (lblTransactionID.Text != "")
        {
            string TransID = lblTransactionID.Text;
            StringBuilder sbBill = new StringBuilder();
            sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round((t2.GrossAmt-t2.TotalDiscount),2)NetAmt,");
            sbBill.Append("Round(t2.TotalDiscount,2)TotalDiscount,ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt,t2.TotalItemWiseDiscount FROM ( ");
            sbBill.Append("     select ltd.TransactionID,sum(ltd.Rate*ltd.Quantity)GrossAmt,");
            sbBill.Append("     IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100)");
            sbBill.Append("     +IFNULL(ipd.DiscountOnBill,0),2),0)TotalDiscount,IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2),0)TotalItemWiseDiscount,im.Type_ID,im.ServiceItemID From mortuary_ledgertnxdetail ltd ");
            sbBill.Append("     inner join mortuary_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo");
            sbBill.Append("     INNER JOIN mortuary_corpse_deposite ipd ON ipd.TransactionID=lt.TransactionID ");
            sbBill.Append("     INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID ");
            sbBill.Append("     WHERE Lt.IsCancel = 0 and ltd.IsFree = 0 and ltd.IsVerified = 1 ");
            sbBill.Append("     and ltd.IsPackage = 0");
            sbBill.Append("     and lt.TransactionID = '" + TransID + "' ");
            sbBill.Append("     group by lt.TransactionID ");
            sbBill.Append(")T2  Left join (");
            sbBill.Append("     select TransactionID Transaction_ID,sum(AmountPaid)RecAmt from mortuary_receipt where IsCancel = 0 ");
            sbBill.Append("     and TransactionID = '" + TransID + "' ");
            sbBill.Append("     group by Transaction_ID ");
            sbBill.Append(")T3 on T2.TransactionID = T3.Transaction_ID"); 

            DataTable dtBill = new DataTable();
            dtBill = StockReports.GetDataTable(sbBill.ToString());

            if (dtBill.Rows.Count > 0)
            {
                lblGrossBillAmt.Text = Util.GetString(dtBill.Rows[0]["GrossAmt"]);
                lblBillDiscount.Text = Util.GetString(dtBill.Rows[0]["TotalDiscount"]);
                lblNetAmount.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblAdvanceAmt.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                lblBalanceAmt.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["NetAmt"]) - Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                //lblApprovalAmt.Text = Util.GetString(dtBill.Rows[0]["PanelApprovedAmt"]);
                // lblTaxAppliedOn.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
                decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
                lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 2, MidpointRounding.AwayFromZero)).ToString();
                decimal RoundOff = Math.Round((TotalAmt), 0, MidpointRounding.AwayFromZero);
                lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff - TotalAmt), 2, MidpointRounding.AwayFromZero)).ToString();
                decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblAdvanceAmt.Text) + Util.GetDecimal(lblRoundOff.Text);
                lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
            }
            else
                lblMsg.Text = "No Billing Information Found";
        }
    }

    protected void btnRelease_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction();
        try
        {
            string Query = "UPDATE mortuary_corpse_deposite SET OutDate='" + Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("hh:mm:ss") + "',"
                +" IsReleased=1,ReleasedBy='" + Util.GetString(Session["ID"].ToString()) + "',CorpseCollectedBy='" + txtName.Text + "',AddressCollected='" + txtAddress.Text + "',ContactNoCollected='" + txtContactNo.Text + "', "+
                "  Days=Datediff(date(OutDate),date(InDate)) WHERE TransactionID='" + lblTransactionID.Text + "' ";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            Query = "UPDATE mortuary_freezer_master SET IsVacant=0 WHERE RackID=(SELECT FreezerID FROM mortuary_corpse_deposite WHERE TransactionID='" + lblTransactionID.Text + "')";
            
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            objtnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='CorpseBillMsg.aspx?Msg=Corpse Released successfully';", true);            
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            lblMsg.Text = "Patient Not Discharged";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnNarSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction();

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE mortuary_corpse_deposite SET IsRelIntimated=1,RelIntimatedDate='" + Util.GetDateTime(((TextBox)EntryDate1.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)EntryTime1.FindControl("txtTime")).Text).ToString("hh:mm:ss") + "',RelIntimatedBy='" + Session["ID"].ToString() + "' WHERE TransactionID='" + lblTransactionID.Text + "'");
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, sb.ToString());

            objtnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.location='Mortuary_CorpseDischarge.aspx?CorpseID=" + lblCorpseID.Text + "&TransactionID=" + lblTransactionID.Text + "';", true);
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
