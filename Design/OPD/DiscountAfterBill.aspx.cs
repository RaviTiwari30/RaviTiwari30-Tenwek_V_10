using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_OPD_DiscountAfterBill : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if ((Util.GetDecimal(lblPaidAmt.Text) + Util.GetDecimal(txtDiscount.Text)) > (Util.GetDecimal(lblNetAmount.Text)))
        {
            lblMsg.Text = "Please Enter Valid Additional Discount";
            txtDiscount.Focus();
            return;
        }
        string LedgerTransactionNo = string.Empty;
        LedgerTransactionNo = SaveData();
        if (LedgerTransactionNo != string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            if (Resources.Resource.ReceiptPrintFormat == "0")
            {
                if (lblTypeofTranx.Text == "OPD-LAB" || lblTypeofTranx.Text == "OPD-PROCEDURE" || lblTypeofTranx.Text == "OPD-OTHERS" || lblTypeofTranx.Text == "OPD-BILLING" || lblTypeofTranx.Text == "OPD-APPOINTMENT")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/CommonReceipt.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&IsBill=1&Duplicate=0');", true);
                else if (lblTypeofTranx.Text == "OPD-Package")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/OPDPackageReceipt.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&IsBill=1&Duplicate=0');", true);
                else if (lblTypeofTranx.Text == "Pharmacy-Issue")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/PharmacyReceipt.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&IsBill=1&Duplicate=0');", true);
                else if (lblTypeofTranx.Text == "Pharmacy-Return")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/PharmacyReturnReceipt.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&IsBill=1&Duplicate=0');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/CommonReceipt_pdf.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&IsBill=1&Duplicate=0');", true);
            }
          
            pnlHide.Visible = false;
            clear();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        string _TypeOfTnx = StockReports.ExecuteScalar("SELECT GetTypeOfTnx('OPD')");
        sb.Append(" SELECT TypeOfTnx,LD.BillNo,LD.NetAmount AS BillAmount,DATE_FORMAT(LD.Date,'%d-%b-%y')BillDate,LD.TransactionID,LD.PatientID,");
        sb.Append(" ld.LedgerTransactionNo,ld.UserID,ld.RoundOff,ld.GovTaxAmount,ld.GovTaxPer, ld.GrossAmount,ld.DiscountOnTotal,ld.NetAmount,ld.Adjustment,Rt.AmountPaid AS ReceiptAmount,DATE_FORMAT(Rt.Date,'%d-%b-%y')ReceiptDate,");
        sb.Append(" Rt.ReceiptNo,IFNULL(CONCAT(dm.title,' ',dm.name),'')Doctor, pm.PName,if(pm.DOB='0001-01-01', pm.Age,date_format(pm.DOB,'%d-%b-%Y'))DOB,pm.Gender, pm.PatientID,pmh.Source,pmh.ReferedBy,pmh.DoctorID,pmh.PanelID ");
        sb.Append(" FROM f_ledgertransaction ld  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=ld.PatientID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON ld.TransactionID=pmh.TransactionID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append(" LEFT JOIN f_reciept rt ON ld.ledgertransactionno = rt.AsainstLedgerTnxNo and rt.IsCancel=0 ");
        sb.Append(" WHERE ld.IsCancel=0 AND ld.CentreID='" + Session["CentreID"].ToString() + "'");
        sb.Append(" and TypeOfTnx IN (" + _TypeOfTnx + ") ");
        if (txtReceiptNo.Text.Trim() != "")
            sb.Append(" and rt.ReceiptNo='" + txtReceiptNo.Text.Trim() + "' ");
        if (txtBillNo.Text.Trim() != "")
            sb.Append(" and ld.BillNo='" + txtBillNo.Text.Trim() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            pnlHide.Visible = true;
            lblGrossAmt.Text = Util.GetString(dt.Rows[0]["GrossAmount"]);
            lblDiscount.Text = Util.GetString(dt.Rows[0]["DiscountOnTotal"]);
            lblNetAmount.Text = Util.GetString(dt.Rows[0]["NetAmount"]);
            lblPaidAmt.Text = Util.GetString(dt.Rows[0]["Adjustment"]);

            lblLedgerTransactionNo.Text = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
            lblGovTaxPer.Text = Util.GetString(dt.Rows[0]["GovTaxPer"]);
            if (Util.GetDecimal(dt.Rows[0]["NetAmount"]) - Util.GetDecimal(dt.Rows[0]["Adjustment"]) > 0)
            {
                txtDiscount.Text = Util.GetString(Util.GetDecimal(dt.Rows[0]["NetAmount"]) - Util.GetDecimal(dt.Rows[0]["Adjustment"]));
            }
            lblGender.Text = Util.GetString(dt.Rows[0]["Gender"]);
            lblAmount.Text = Util.GetString(dt.Rows[0]["ReceiptAmount"]);
            lblPatientID.Text = Util.GetString(dt.Rows[0]["PatientID"]);
            lblPatientID.Attributes["TransactionID"] = Util.GetString(dt.Rows[0]["TransactionID"]);
            lblPatientID.Attributes["Receipt_No."] = Util.GetString(dt.Rows[0]["ReceiptNo"]);
            lblPatientID.Attributes["User_ID"] = Util.GetString(dt.Rows[0]["UserID"]);
            lblPatientID.Attributes["Date"] = Util.GetString(dt.Rows[0]["BillDate"]);
            lblRoundOff.Text = Util.GetString(dt.Rows[0]["RoundOff"]);
            lblGovTaxAmount.Text = Util.GetString(dt.Rows[0]["GovTaxAmount"]);

            lblDOB.Text = Util.GetString(dt.Rows[0]["DOB"]);
            lblPatientName.Text = Util.GetString(dt.Rows[0]["PName"]);
            lblDoctor.Text = Util.GetString(dt.Rows[0]["Doctor"]);
            lblDoctor.Attributes["DoctorID"] = Util.GetString(dt.Rows[0]["DoctorID"]);
            lblDoctor.Attributes["PanelID"] = Util.GetString(dt.Rows[0]["PanelID"]);
            lblDoctor.Attributes["ReferedBy"] = Util.GetString(dt.Rows[0]["ReferedBy"]);
            lblDoctor.Attributes["Source"] = Util.GetString(dt.Rows[0]["Source"]);
            // lblDoctor.Attributes["OtherDr"] = Util.GetString(dt.Rows[0]["OtherDr"]);

            lblPatientID.Attributes["LedgerTransactionNo"] = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
            lblTypeofTranx.Text = Util.GetString(dt.Rows[0]["TypeOfTnx"]);
            string sql = "select date_format(lt.Date,'%d-%b-%Y')Date,ItemName,ItemID,ltd.SubCategoryID,lt.TypeOfTnx,ltd.Quantity,ltd.Amount,ltd.Rate ,   " +
                " lt.NetAmount,lt.GrossAmount,lt.LedgerTransactionNo, if(ltd.IsRefund=0,'true','false')IsRefund, ltd.LedgerTnxID,lt.TransactionTypeID " +
                " from  f_ledgertransaction lt  " +
                " inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo = ltd.LedgerTransactionNo " +
                " where  " +
                " lt.LedgerTransactionNo = '" + lblLedgerTransactionNo.Text.Trim() + "' ";

            dt = StockReports.GetDataTable(sql);
            grdItemRate.DataSource = dt;
            grdItemRate.DataBind();
        }
        else
        {
            pnlHide.Visible = true;
            lblAmount.Text = "";
            lblPatientID.Text = "";
            lblDOB.Text = "";
            lblPatientName.Text = "";
            lblMsg.Text = "Record Not Found";
            grdItemRate.DataSource = null;
            grdItemRate.DataBind();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";

        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString()); if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                All_LoadData.bindApprovalType(ddlApproveBy);
                if (Request.QueryString["LabNo"] != null)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch", "document.getElementById('ctl00_ContentPlaceHolder1_txtRecipt').value='" + Request.QueryString["LabNo"].ToString() + "';document.getElementById('ctl00_ContentPlaceHolder1_btnSearch').click();", true);
            }
        }
    }

    private void clear()
    {
        txtBillNo.Text = "";
        txtReason.Text = "";
        txtDiscount.Text = "";
        txtReceiptNo.Text = "";
        lblLedgerTransactionNo.Text = "";
        lblNetAmount.Text = "";
        ddlApproveBy.SelectedIndex = 0;
        lblPaidAmt.Text = "";
        lblPatientID.Text = "";
        lblPatientName.Text = "";
        lblDOB.Text = "";
        lblAmount.Text = "";
        lblFileType.Text = "";
        lblDoctor.Text = "";
        lblGender.Text = "";
        lblGrossAmt.Text = "";
        lblDiscount.Text = "";
        lblRoundOff.Text = "";
        lblGovTaxAmount.Text = "";
        grdItemRate.DataSource = null;
        grdItemRate.DataBind();
    }

    private string SaveData()
    {
        try
        {
            if (Session["ID"] != null)
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    MySqlCommand cmd;

                    decimal PreviousDiscount = Util.GetDecimal(lblDiscount.Text);
                    decimal GrossAmt = Util.GetDecimal(lblGrossAmt.Text);
                    decimal NetAmt = Util.GetDecimal(lblNetAmount.Text);

                    string LedgerTransactionNo = lblLedgerTransactionNo.Text.Trim();

                    if (GrossAmt < (PreviousDiscount + Util.GetDecimal(txtDiscount.Text)))
                        return "";
                    if (ddlApproveBy.SelectedItem.Text == "")
                    {
                        lblMsg.Text = "Please Select Approved by ";
                        return "";
                    }
                    //grossAmt=netAmt+dis+roundoff-govTax
                    //netAmt=grossAmt-dis-roundOff+govTax;
                    decimal DiscPer = (((PreviousDiscount + Util.GetDecimal(txtDiscount.Text)) * 100) / GrossAmt);
                    decimal newNetAmt = (GrossAmt - (PreviousDiscount + Util.GetDecimal(txtDiscount.Text)));

                    decimal newGovTax = (newNetAmt * Util.GetDecimal(lblGovTaxPer.Text)) / 100;
                    newNetAmt += newGovTax;
                    decimal newNetAmt1 = Math.Round(newNetAmt);
                    decimal newRoundOff = newNetAmt1 - newNetAmt;
                    newNetAmt += newRoundOff;

                    StringBuilder sb = new StringBuilder();
                    sb.Append(" update f_ledgertnxdetail set  ");
                    sb.Append(" DiscountPercentage = " + DiscPer + ",");
                    sb.Append(" amount = ((Rate * (100-" + DiscPer + "))/100)*Quantity ");
                    sb.Append(" where LedgerTransactionNo='" + LedgerTransactionNo + "' ");
                    cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                    cmd.ExecuteNonQuery();

                    sb.Remove(0, sb.ToString().Length);
                    sb.Append(" update f_ledgertransaction set  ");
                    sb.Append(" DiscountOnTotal = " + (PreviousDiscount + Util.GetDecimal(txtDiscount.Text)) + ", ");
                    sb.Append(" NetAmount = " + newNetAmt + ",RoundOff=" + newRoundOff + ", ");

                    sb.Append(" DiscountReason='" + txtReason.Text.Trim() + "', DiscountApproveBy ='" + ddlApproveBy.SelectedItem.Text + "' ");

                    sb.Append(" where LedgerTransactionNo='" + LedgerTransactionNo + "' ");
                    cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                    cmd.ExecuteNonQuery();

                    sb.Remove(0, sb.ToString().Length);
                   
                   
                    string instDAB = "insert into f_discountafterbill(LedgertransactionNo,GrossAmount,DiscAmt,ApprovedBy,DiscReason,UserName) " +
                                    " values ('" + Util.GetString(lblLedgerTransactionNo.Text) + "','" + Util.GetDecimal(lblGrossAmt.Text) + "','" + Util.GetDecimal(txtDiscount.Text) + "','" + ddlApproveBy.SelectedItem.Text + "','" + txtReason.Text.Trim() + "','" + Session["ID"].ToString() + "') ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, instDAB);

                    tnx.Commit();

                    return LedgerTransactionNo;
                }
                catch (Exception ex)
                {
                    tnx.Rollback();

                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

                    return string.Empty;
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
                return string.Empty;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
    }

    private bool ValidateRefundItem(string ItemID, double Qty, string LdtNo, MySqlTransaction tnx)
    {
        int IsLabItem = 0;
        IsLabItem = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(*) from f_configrelation cr inner join f_subcategorymaster sc on cr.CategoryID = sc.CategoryID and cr.ConfigID=3 inner join f_ledgertnxdetail ltd on ltd.SubCategoryID = sc.SubCategoryID and ltd.ItemID='" + ItemID + "' and ltd.LedgerTransactionNo ='" + LdtNo + "'"));

        if (IsLabItem > 0)
        {
            DataTable dt = new DataTable();

            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.ItemID='" + ItemID + "' and ltd.LedgerTransactionNo ='" + LdtNo + "' inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag=0 ;").Tables[0];

            if (dt.Rows.Count < Qty)
                return false;
            else
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set LedgerTransactionNo='', LedgerTransactionNoOLD ='" + LdtNo + "' where ID='" + dt.Rows[i]["ID"].ToString() + "' ");
                }
                return true;
            }
        }
        return true;
    }
}