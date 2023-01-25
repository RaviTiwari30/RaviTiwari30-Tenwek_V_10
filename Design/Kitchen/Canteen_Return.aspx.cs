using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_Kitchen_Canteen_Return : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            txtHash.Text = Util.getHash();
            txtHash.Attributes.Add("style", "display:none");

            pnlInfo.Visible = false;
            pnlOpdReturn.Visible = false;
            btnGen.Visible = false;

           // ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Enabled = false;
            ((TextBox)PaymentControl.FindControl("txtNetAmount")).Attributes.Add("readonly", "readonly");
            txtReceiptNo.Focus();
        }
        if (((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count <= 0)
        {
            PaymentEnableFalse();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        if (rdoReturn.SelectedItem.Value == "OPD")
        {
            if (txtReceiptNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "")
            {
                //lblMsg.Text = "Please Enter Receipt or Bill Number";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Please Enter Receipt or Bill Number');", true);
                return;
            }
            sb.Append("SELECT tt.* FROM ");
            sb.Append("(SELECT t.LedgerTransactionNo,t.TransactionID,t.ReceiptNo,t.Netamount,t.DiscountOnTotal,t.GrossAmount,t.Adjustment,t.DATE, ");
            sb.Append("t.TypeOfTnx,t.CustomerID,t.Pname,t.Age,t.contactno,t.Address,t.Patient_ID,t.PanelID,t.Doctor_ID,t.Type_ID,t.IsUsable,t.ServiceItemID,t.ToBeBilled,t.BillNo, ");
            sb.Append("t.BatchNumber,t.MedExpiryDate,(t.AvlQty-IFNULL(rt.ReturnQty,0))AvlQty,t.UnitType,t.StockID,t.ItemID,t.ItemName,t.SubCategoryID,t.PerUnitBuyPrice,t.MRP,t.DiscountApproveBy,t.DiscountReason,t.GovTaxPer,t.GovTaxAmount,t.PaymentMode,IPNo,PatientType,t.IsExpirable,  ");
            // Add new on 29-06-2017 - For GST
            sb.Append(" t.HSNCode,t.IGSTPercent,t.CGSTPercent,t.SGSTPercent,t.GSTType ");

            sb.Append("FROM (SELECT DISTINCT(LT.LedgerTransactionNo),LT.TransactionID,r.ReceiptNo, ROUND(LT.NetAmount,2)NetAmount,ROUND(LT.DiscountOnTotal,2)DiscountOnTotal,ROUND(LT.GrossAmount,2)GrossAmount,Round(LT.Adjustment,2)Adjustment,DATE_FORMAT(LT.Date,'%d-%b-%y %T')DATE,   ");
            sb.Append("LT.TypeOfTnx,'' CustomerID,CONCAT(PM.Title,' ',PM.Pname)PName,PM.Age,IF(IFNULL(pm.Mobile,'')='',pm.Phone,pm.Mobile)ContactNo,CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(PM.Street_Name,''),' ',IFNULL(PM.Locality,''),' ',    ");
            sb.Append("IFNULL(PM.City,''))Address,pm.Patient_ID,pmh.PanelID,pmh.Doctor_ID,im.Type_ID,im.IsUsable,im.ServiceItemID,im.ToBeBilled,   ");
            sb.Append("LT.BillNo,st.BatchNumber, DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') AS MedExpiryDate,st.IsExpirable,   ");
            sb.Append("sd.SoldUnits AS AvlQty,st.UnitType,st.StockID,st.ItemID,st.ItemName,st.SubCategoryID,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice AS MRP,lt.DiscountApproveBy,lt.DiscountReason,lt.GovTaxPer,lt.GovTaxAmount,IF(LT.PaymentModeID=4,'Credit','Cash')PaymentMode,IFNULL(LT.IPNo,'')IPNo,lt.PatientType, ");
            // Add new on 29-06-2017 - For GST
            sb.Append(" ltd.HSNCode,ltd.IGSTPercent,ltd.CGSTPercent,ltd.SGSTPercent,ltd.GSTType ");

            sb.Append("FROM f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo    ");
            sb.Append("left JOIN f_reciept r ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo   ");
            sb.Append("INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID   ");
            sb.Append("INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo=lt.LedgerTransactionNo  AND st.StockID=sd.StockID   ");
            sb.Append("INNER JOIN  patient_master PM ON LT.Patient_ID=PM.Patient_ID    ");
            sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID    ");
            sb.Append("WHERE LT.TypeOfTnx ='Canteen-Issue'    ");
            if (txtReceiptNo.Text.Trim() != "")
            {
                sb.Append("AND r.ReceiptNo='" + txtReceiptNo.Text.Trim() + "'  ");
            }
            if (txtBillNo.Text.Trim() != "")
            {
                sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
            }
            sb.Append(" AND lt.Patient_ID<>'CASH003' ) t ");
            sb.Append("LEFT OUTER JOIN (SELECT LedgerTransactionNo,AgainstLedgerTnxNo,StockID,ItemID,SUM(SoldUnits) ReturnQty,SUM(PerUnitSellingPrice) AS MRP FROM f_salesdetails WHERE ");
            if (txtReceiptNo.Text.Trim() != "")
                sb.Append(" AgainstLedgerTnxNo=(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo='" + txtReceiptNo.Text.Trim() + "')   ");
            else
                sb.Append(" AgainstLedgerTnxNo=(SELECT LedgerTransactionNo FROM f_ledgertransaction WHERE BillNo='" + txtBillNo.Text.Trim() + "') ");
            sb.Append("AND IsReturn=1 GROUP BY StockID) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");
            sb.Append(")tt WHERE tt.AvlQty>0  ");
        }
        else
        {
            if (txtReceiptNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "")
            {
                //  lblMsg.Text = "Please Enter Receipt or Bill Number";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Please Enter Receipt or Bill Number');", true);
                return;
            }
            sb.Append("SELECT tt.* FROM ");
            sb.Append("(SELECT t.LedgerTransactionNo,t.TransactionID,t.Netamount,t.ReceiptNo,t.DiscountOnTotal,t.GrossAmount,t.Adjustment,t.DATE, ");
            sb.Append("t.TypeOfTnx,t.CustomerID,t.Pname,t.Age,t.contactno,t.Address,t.Patient_ID,t.PanelID,t.Doctor_ID,t.Type_ID,t.IsUsable,t.ServiceItemID,t.ToBeBilled,t.BillNo, ");
            sb.Append("t.BatchNumber,t.MedExpiryDate,(t.AvlQty-IFNULL(rt.ReturnQty,0))AvlQty,t.UnitType,t.StockID,t.ItemID,t.ItemName,t.SubCategoryID,t.PerUnitBuyPrice,t.MRP,t.DiscountApproveBy,t.DiscountReason,t.GovTaxPer,t.GovTaxAmount,t.PaymentMode,IPNo,PatientType,t.IsExpirable, ");
            // Add new on 29-06-2017 - For GST
            sb.Append(" t.HSNCode,t.IGSTPercent,t.CGSTPercent,t.SGSTPercent,t.GSTType ");

            sb.Append("FROM (SELECT DISTINCT(LT.LedgerTransactionNo),LT.TransactionID, r.ReceiptNo,ROUND(LT.NetAmount,2)NetAmount,ROUND(LT.DiscountOnTotal,2)DiscountOnTotal,ROUND(LT.GrossAmount,2)GrossAmount,Round(LT.Adjustment,2)Adjustment,DATE_FORMAT(LT.Date,'%d-%b-%y %T')DATE,   ");
            sb.Append("LT.TypeOfTnx,pm.CustomerID,CONCAT(PM.Title,' ',PM.Name)PName,PM.Age,IFNULL(pm.ContactNo,'')ContactNo,pm.Address,    ");
            sb.Append("'' Patient_ID,lt.PanelID,'' Doctor_ID,im.Type_ID,im.IsUsable,im.ServiceItemID,im.ToBeBilled,   ");
            sb.Append("LT.BillNo,st.BatchNumber, DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') AS MedExpiryDate,st.IsExpirable,   ");
            sb.Append("sd.SoldUnits AS AvlQty,st.UnitType,st.StockID,st.ItemID,st.ItemName,st.SubCategoryID,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice AS MRP,lt.DiscountApproveBy,lt.DiscountReason,lt.GovTaxPer,lt.GovTaxAmount,IF(LT.Adjustment=0,'Credit','Cash')PaymentMode,IFNULL(LT.IPNo,'')IPNo,lt.PatientType, ");
            // Add new on 29-06-2017 - For GST
            sb.Append(" ltd.HSNCode,ltd.IGSTPercent,ltd.CGSTPercent,ltd.SGSTPercent,ltd.GSTType ");

            sb.Append("FROM f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo    ");
            sb.Append("Left JOIN f_reciept r ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo   ");
            sb.Append("INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID   ");
            sb.Append("INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo=lt.LedgerTransactionNo  AND st.StockID=sd.StockID   ");
            sb.Append("INNER JOIN  patient_general_master PM ON lt.LedgerTransactionNo = pm.AgainstLedgerTnxNo    ");
            sb.Append("WHERE LT.TypeOfTnx ='Canteen-Issue'    ");
            if (txtReceiptNo.Text.Trim() != "")
            {
                sb.Append("AND r.ReceiptNo='" + txtReceiptNo.Text.Trim() + "'  ");
            }
            if (txtBillNo.Text.Trim() != "")
            {
                sb.Append("AND LT.BillNo='" + txtBillNo.Text.Trim() + "' ");
            }
            sb.Append("  ) t  ");
            sb.Append("LEFT OUTER JOIN (SELECT LedgerTransactionNo,AgainstLedgerTnxNo,StockID,ItemID,SUM(SoldUnits) ReturnQty,SUM(PerUnitSellingPrice) AS MRP FROM f_salesdetails WHERE ");
            if (txtReceiptNo.Text.Trim() != "")
                sb.Append(" AgainstLedgerTnxNo=(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo='" + txtReceiptNo.Text.Trim() + "')   ");
            else
                sb.Append(" AgainstLedgerTnxNo=(SELECT LedgerTransactionNo FROM f_ledgertransaction WHERE BillNo='" + txtBillNo.Text.Trim() + "') ");
            sb.Append("AND IsReturn=1 GROUP BY StockID) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");
            sb.Append(")tt WHERE tt.AvlQty>0  ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            if (rdoReturn.SelectedItem.Value == "OPD")
                lblMRNo.Text = dt.Rows[0]["Patient_ID"].ToString();
            else
                lblMRNo.Text = dt.Rows[0]["CustomerID"].ToString();
            if (dt.Rows[0]["IPNo"].ToString() != "")
                lblIPDNo.Text = dt.Rows[0]["IPNo"].ToString().Replace("ISHHI", "");
            else
                lblIPDNo.Text = "";
            lblPatientName.Text = dt.Rows[0]["PName"].ToString();
            lblAddress.Text = dt.Rows[0]["Address"].ToString();
            lblContactNo.Text = dt.Rows[0]["ContactNo"].ToString();
            lblAge.Text = dt.Rows[0]["Age"].ToString();
            lblDoctor_ID.Text = dt.Rows[0]["Doctor_ID"].ToString();
            lblPanel_ID.Text = dt.Rows[0]["PanelID"].ToString();
            lblDiscReason.Text = dt.Rows[0]["DiscountReason"].ToString();
            ((Label)PaymentControl.FindControl("lblGovTaxPer")).Text = "Gov. Tax (" + (dt.Rows[0]["GovTaxPer"].ToString()).TrimStart('0').TrimEnd('0', '.') + " %) :&nbsp; ";
            lblGovTaxPer.Text = dt.Rows[0]["GovTaxPer"].ToString();
            lblGovTaxAmt.Text = dt.Rows[0]["GovTaxAmount"].ToString();
            lblAppBy.Text = dt.Rows[0]["DiscountApproveBy"].ToString();
            lblCustomerId.Text = dt.Rows[0]["CustomerID"].ToString();
            lblAmtPaid.Text = dt.Rows[0]["Adjustment"].ToString();
            lblNetAmt.Text = dt.Rows[0]["NetAmount"].ToString();
            lblreceiptno.Text = dt.Rows[0]["ReceiptNo"].ToString();
            lblRefund_Against_BillNo.Text = dt.Rows[0]["BillNo"].ToString();
            lblPatientType.Text = dt.Rows[0]["PatientType"].ToString();
            lblBalAmt.Text = Util.GetString(Math.Round(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text), MidpointRounding.AwayFromZero));
            //lblBalAmt.Text = Util.GetString(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text));

            if (Math.Round(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text), 2, MidpointRounding.AwayFromZero) < 1)
                lblBalAmt.Text = "0";
            lblPaymentStatus.Text = dt.Rows[0]["PaymentMode"].ToString();
            if ((Math.Round(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text), 2, MidpointRounding.AwayFromZero) > 0) && (lblPaymentStatus.Text) != "Credit")
            {
                //  lblMsg.Text = "Please Settle Previous Amount";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Please Settle Previous Amount');", true);
                pnlInfo.Visible = false;
                return;
            }

            lblLedgerno.Text = Util.GetString(dt.Rows[0]["LedgerTransactionNo"].ToString());

            pnlInfo.Visible = true;
            grdItem.DataSource = dt;
            grdItem.DataBind();
            //  lblMsg.Text = "";

        }
        else
        {
            lblMsg.Text = "No Record found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('No Record found');", true);
            pnlInfo.Visible = false;
            pnlOpdReturn.Visible = false;
            grdItem.DataSource = null;
            grdItem.DataBind();
            ViewState["DataItem"] = null;
            return;
        }
    }

    protected void gvIssueItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["DataItem"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            if (dtItem.Rows.Count > 0)
            {
                gvIssueItem.DataSource = dtItem;
                gvIssueItem.DataBind();
                getReturnPayment();
                ViewState["DataItem"] = dtItem;
            }
            else
            {
                gvIssueItem.DataSource = null;
                gvIssueItem.DataBind();
                ViewState["DataItem"] = null;
                pnlOpdReturn.Visible = false;
                EnableFalse();
            }
        }
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ValidateItems())
        {
            int flag = 0;
            DataTable dt = null;
            if (ViewState["DataItem"] != null)
            {
                dt = (DataTable)ViewState["DataItem"];
            }
            else
            {
                dt = GetItemDataTable();
            }

            foreach (GridViewRow row in grdItem.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    DataRow dr = dt.NewRow();
                    dr["AgainstLedgerTnxNo"] = ((Label)row.FindControl("lblTnxNo")).Text;
                    dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                    dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                    dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                    dr["Expiry"] = ((Label)row.FindControl("lblExpiry")).Text;
                    dr["MRP"] = ((Label)row.FindControl("lblMRP")).Text;
                    decimal mrp = Util.GetDecimal(((Label)row.FindControl("lblMRP")).Text);
                    dr["UnitType"] = ((Label)row.FindControl("lblUnitType")).Text;
                    dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategory")).Text;
                    decimal qty = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
                    dr["ReturnQty"] = qty;
                    dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                    decimal amount = qty * mrp;
                    dr["Amount"] = amount;
                    decimal grossAmt = Util.GetDecimal(((Label)row.FindControl("lblGrossAmt")).Text);
                    decimal discountOnTotal = Util.GetDecimal(((Label)row.FindControl("lblDiscAmtonTotal")).Text);
                    decimal discPer = (discountOnTotal * 100) / grossAmt;
                    dr["DiscAmt"] = (amount * discPer) / 100;
                    dr["UnitPrice"] = Util.GetDecimal(((Label)row.FindControl("lblPerUnitBuyPrice")).Text);
                    dr["IsUsable"] = Util.GetString(((Label)row.FindControl("lblIsUsable")).Text);
                    dr["ToBeBilled"] = Util.GetInt(((Label)row.FindControl("lblToBeBilled")).Text);
                    decimal govTax = (Util.GetDecimal(lblGovTaxPer.Text) / 100) * (amount - (amount * discPer) / 100);
                    dr["TaxAmt"] = govTax;
                    ((TextBox)PaymentControl.FindControl("txtDiscReason")).Text = "Hospital Discount";
                    dr["IsExpirable"] = ((Label)row.FindControl("lblIsExpirable")).Text; ;

                    // Add new on 29-06-2017 - For GST
                    dr["HSNCode"] = ((Label)row.FindControl("lblHSNCode")).Text;
                    dr["IGSTPercent"] = ((Label)row.FindControl("lblIGSTPercent")).Text;
                    dr["CGSTPercent"] = ((Label)row.FindControl("lblCGSTPercent")).Text;
                    dr["SGSTPercent"] = ((Label)row.FindControl("lblSGSTPercent")).Text;
                    dr["GSTType"] = ((Label)row.FindControl("lblGSTType")).Text;
                    dr["BillDate"] = ((Label)row.FindControl("lblBillDate")).Text;
                    //

                    dt.Rows.Add(dr);
                    flag = 1;
                }

            }
            if (flag == 1)
            {
                gvIssueItem.DataSource = dt;
                gvIssueItem.DataBind();
                ViewState["DataItem"] = dt;
                pnlOpdReturn.Visible = true;
                getReturnPayment();
                PaymentEnableFalse();
                lblMsg.Text = "";
            }
            else
            {
                //  lblMsg.Text = "Kindly Select Item";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Kindly Select Item');", true);

                return;
            }

        }

    }
    private void getReturnPayment()
    {
        DataTable dtNew = null;
        if (ViewState["DataItem"] != null)
        {
            dtNew = (DataTable)ViewState["DataItem"];
        }
        ((TextBox)PaymentControl.FindControl("txtDiscReason")).Text = lblDiscReason.Text;
        ((DropDownList)PaymentControl.FindControl("ddlApproveBy")).SelectedIndex = ((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Items.IndexOf(((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Items.FindByText(lblAppBy.Text));

        decimal amount = Math.Round(Util.GetDecimal(dtNew.Compute("sum(Amount)", "")), 2);
        decimal discount = Math.Round(Util.GetDecimal(dtNew.Compute("sum(DiscAmt)", "")), 2);
        decimal taxAmt = Math.Round(Util.GetDecimal(dtNew.Compute("sum(TaxAmt)", "")), 2);

        ((TextBox)PaymentControl.FindControl("txtBillAmount")).Text = Util.GetString(amount);
        if (discount > 0)
            ((TextBox)PaymentControl.FindControl("txtDisAmount")).Text = Util.GetString(discount);
        else
            ((TextBox)PaymentControl.FindControl("txtDisAmount")).Text = "";
        ((TextBox)PaymentControl.FindControl("txtGovTaxAmt")).Text = Util.GetString(taxAmt);
        ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text = Util.GetString(Math.Round(amount - discount, 2, MidpointRounding.AwayFromZero));

        decimal totalPaidAmt = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtNetAmount")).Text) + Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtGovTaxAmt")).Text);

        ((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text = Util.GetString(Math.Round(amount - discount + taxAmt));
        ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = ((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text;

        ((Label)PaymentControl.FindControl("lblRoundVal")).Text = Math.Round((Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text) - Util.GetDecimal(totalPaidAmt)), 2, System.MidpointRounding.AwayFromZero).ToString();
        ((TextBox)PaymentControl.FindControl("txtCurrencyBase")).Text = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text).ToString();
        ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Text = ((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text;
        AllSelectQuery asq = new AllSelectQuery();
        decimal rate = asq.ConvertCurrencyBase(Util.GetInt(((DropDownList)PaymentControl.FindControl("ddlCountry")).SelectedValue), Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text));

        ((Label)PaymentControl.FindControl("lblCurrencyBase")).Text = Util.GetString(rate) + " " + ((TextBox)PaymentControl.FindControl("lblCurrencyNotation")).Text;
        if (lblPaymentStatus.Text == "Credit")
        {
            ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).SelectedItem.Text = "Credit";
            ((Button)PaymentControl.FindControl("btnAdd")).Enabled = false;
            ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Enabled = false;
        }
        else
        {
            ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).SelectedIndex = 0;
            ((Button)PaymentControl.FindControl("btnAdd")).Enabled = true;
            ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Enabled = true;
        }
    }

    private void PaymentEnableFalse()
    {
        ((TextBox)PaymentControl.FindControl("txtBillAmount")).Enabled = false;
        ((TextBox)PaymentControl.FindControl("txtNetAmount")).Enabled = false;
        ((TextBox)PaymentControl.FindControl("txtDisAmount")).Enabled = false;
        ((TextBox)PaymentControl.FindControl("txtDisPercent")).Enabled = false;
        ((TextBox)PaymentControl.FindControl("txtDiscReason")).Enabled = false;
        //((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Enabled = false;
        ((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Enabled = false;
    }
    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("AgainstLedgerTnxNo");
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("Expiry");
        dt.Columns.Add("SubCategoryID");
        dt.Columns.Add("UnitType");
        dt.Columns.Add("MRP", typeof(decimal));
        dt.Columns.Add("ReturnQty", typeof(decimal));
        dt.Columns.Add("Amount", typeof(decimal));
        dt.Columns.Add("DiscAmt", typeof(decimal));
        dt.Columns.Add("TaxAmt", typeof(decimal));
        dt.Columns.Add("UnitPrice", typeof(decimal));
        dt.Columns.Add("IsUsable");
        dt.Columns.Add("ToBeBilled");
        dt.Columns.Add("IsExpirable");

        // Add new on 29-06-2017 - For GST
        dt.Columns.Add("HSNCode");
        dt.Columns.Add("IGSTPercent");
        dt.Columns.Add("CGSTPercent");
        dt.Columns.Add("SGSTPercent");
        dt.Columns.Add("GSTType");
        dt.Columns.Add("BillDate");
        //

        return dt;
    }
    #region Validation
    private bool ValidateItems()
    {
        DataTable dt = null;
        if (ViewState["DataItem"] != null)
            dt = (DataTable)ViewState["DataItem"];
        bool status = true;
        foreach (GridViewRow row in grdItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                status = false;
                if (dt != null && dt.Rows.Count > 0)
                {
                    string stockID = ((Label)row.FindControl("lblStockID")).Text;
                    DataRow[] drow = dt.Select("StockID = '" + stockID + "'");
                    if (drow.Length > 0)
                    {
                        //   lblMsg.Text = "Item Already Selected";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Item Already Selected');", true);

                        return false;
                    }
                }
                if (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text) <= 0)
                {
                    //  lblMsg.Text = "Kindly Enter Return Quantity";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Kindly Enter Return Quantity');", true);
                    return false;
                }

                decimal returnQty = 0; decimal availQty = 0;
                returnQty = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
                availQty = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
                if (returnQty > availQty)
                {
                    //   lblMsg.Text = "Return Quantity is not Available";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Return Quantity is not Available');", true);
                    return false;
                }
            }
        }
        if (status)
        {
            lblMsg.Text = "Please Select Items";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Please Select Items');", true);
            return false;
        }
        lblMsg.Text = string.Empty;
        return true;
    }
    #endregion

    private void dtPaymentDetails()
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
        ViewState["dtPaymentDetail"] = dt;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Util.GetDecimal(((Label)PaymentControl.FindControl("lblBalanceAmount")).Text) > 0)
        {
            lblMsg.Text = "Please Return Total Amount";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Please Return Total Amount');", true);
            ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Focus();
            return;
        }

        int salesNo = SaveData();
        if (salesNo != 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "", true);
        }
        else
        {
            lblMsg.Text = "Error...";
        }
    }
    private int SaveData()
    {
        if (ViewState["DataItem"] != null)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select Get_SalesNo('17','" + AllGlobalFunction.GeneralStoreID + "','" + Session["CentreID"].ToString() + "') "));

                DataTable dtItem = new DataTable();
                dtItem = (DataTable)ViewState["DataItem"];

                string tID = "", ledTxnID = "";
                decimal discAmt = 0, discPer = 0;

                decimal totalGrossAmt = 0;
                totalGrossAmt = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtBillAmount")).Text);



                if (((TextBox)PaymentControl.FindControl("txtDisPercent")).Text != string.Empty)
                {
                    discAmt = (Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisPercent")).Text.Trim()) * totalGrossAmt) / 100;
                    discPer = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisPercent")).Text.Trim());
                }
                else
                {
                    discAmt = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisAmount")).Text.Trim());
                    discPer = (discAmt * 100) / totalGrossAmt;
                }

                DataTable dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
                if (dtPaymentDetail == null)
                {
                    dtPaymentDetails();
                    dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
                }
                if ((((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count == 0) && lblPaymentStatus.Text == "Cash")
                {
                    if (discAmt == totalGrossAmt)
                    {
                        DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
                        if (dt.Rows.Count > 0)
                        {
                            AllSelectQuery aSQ = new AllSelectQuery();
                            DataRow drRow = dtPaymentDetail.NewRow();
                            drRow["PaymentMode"] = "Cash";
                            drRow["PaymentModeID"] = "1";
                            drRow["PaidAmount"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
                            drRow["Currency"] = dt.Rows[0]["S_Currency"].ToString();
                            drRow["CountryID"] = dt.Rows[0]["S_CountryID"].ToString();
                            drRow["BankName"] = "";
                            drRow["RefNo"] = "";
                            drRow["BaceCurrency"] = dt.Rows[0]["B_Currency"].ToString();
                            drRow["C_Factor"] = aSQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"])).ToString();
                            drRow["BaseCurrency"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
                            drRow["Notation"] = dt.Rows[0]["S_Notation"].ToString();
                            drRow["PaymentRemarks"] = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
                            drRow["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                            dtPaymentDetail.Rows.Add(drRow);
                        }
                    }
                }
                else if ((((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count == 0) && lblPaymentStatus.Text == "Credit")
                {
                    DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
                    if (dt.Rows.Count > 0)
                    {
                        AllSelectQuery aSQ = new AllSelectQuery();
                        DataRow drRow = dtPaymentDetail.NewRow();
                        drRow["PaymentMode"] = "Credit";
                        drRow["PaymentModeID"] = "4";
                        drRow["PaidAmount"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
                        drRow["Currency"] = dt.Rows[0]["S_Currency"].ToString();
                        drRow["CountryID"] = dt.Rows[0]["S_CountryID"].ToString();
                        drRow["BankName"] = "";
                        drRow["RefNo"] = "";
                        drRow["BaceCurrency"] = dt.Rows[0]["B_Currency"].ToString();
                        drRow["C_Factor"] = aSQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"])).ToString();
                        drRow["BaseCurrency"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
                        drRow["Notation"] = dt.Rows[0]["S_Notation"].ToString();
                        drRow["PaymentRemarks"] = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
                        drRow["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        dtPaymentDetail.Rows.Add(drRow);
                    }
                }
                else if ((((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count > 0))
                {
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
                        dr["PaymentRemarks"] = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
                        dr["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        dtPaymentDetail.Rows.Add(dr);
                    }
                }
                else
                {
                    //  lblMsg.Text = "Please Enter Amount";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Please Enter Amount');", true);
                    ViewState["dtPaymentDetail"] = null;
                    return 0;
                }
                decimal netAmount = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
                decimal amountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);
                decimal roundOff = Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text);
                string discountReason = Util.GetString(((TextBox)PaymentControl.FindControl("txtDiscReason")).Text);
                string discountApproveBy = Util.GetString(((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Text);

                string ledgerNumber = "";

                if (rdoReturn.SelectedItem.Value == "OPD")
                {
                    ledgerNumber = "CASH003";
                }
                else
                {
                    ledgerNumber = "CASH003";
                }

                Patient_Medical_History objPmh = new Patient_Medical_History(tranx);
                if (rdoReturn.SelectedItem.Value == "OPD")
                    objPmh.PatientID = lblMRNo.Text.ToString();
                else
                    objPmh.PatientID = "CASH003";
                objPmh.DoctorID = Resources.Resource.DoctorID_Self;//lblDoctor_ID.Text.ToString();
                objPmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPmh.Time = Util.GetDateTime(DateTime.Now);
                objPmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
                objPmh.Type = "OPD";
                objPmh.PanelID = Util.GetInt(lblPanel_ID.Text.ToString());
                objPmh.ReferedBy = lblDoctor_ID.Text.ToString();
                objPmh.patient_type = "1";
                objPmh.Source = "Canteen";
                objPmh.EntryDate = Util.GetDateTime(DateTime.Now);
                objPmh.HashCode = txtHash.Text.Trim();
                objPmh.UserID = ViewState["UserID"].ToString();
                objPmh.ScheduleChargeID = Util.GetInt(StockReports.GetCurrentRateScheduleID(Util.GetInt(lblPanel_ID.Text.ToString())));
                objPmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                tID = objPmh.Insert();
                if (tID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Error...";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                    return 0;
                }

                //Insert into f_LedgerTransaction Single row effect
                Ledger_Transaction objLedTran = new Ledger_Transaction(tranx);
                objLedTran.LedgerNoCr = ledgerNumber;
                objLedTran.LedgerNoDr = "STO00002";
                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objLedTran.TransactionID = tID;
                objLedTran.TypeOfTnx = "Canteen-Return";
                objLedTran.PanelID = Util.GetInt(lblPanel_ID.Text.ToString());
                if (rdoReturn.SelectedItem.Value == "OPD")
                    objLedTran.PatientID = lblMRNo.Text.ToString();
                else
                    objLedTran.PatientID = "CASH003";
                objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                objLedTran.NetAmount = -netAmount;
                objLedTran.GrossAmount = -totalGrossAmt;
                objLedTran.DiscountOnTotal = -discAmt;
                objLedTran.DiscountReason = discountReason;
                objLedTran.DiscountApproveBy = discountApproveBy;
                objLedTran.Adjustment = -amountPaid;
                objLedTran.TransactionType_ID = 17;
                objLedTran.IndentNo = "";
                objLedTran.IsPaid = 1;
                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                //decimal Round = AmountPaid - netAmount;
                if (Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text) > 0)
                    objLedTran.RoundOff = -Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text);
                else
                    objLedTran.RoundOff = Math.Abs(Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text));
                //  objLedTran.RoundOff = Round;
                objLedTran.PaymentModeID = Util.GetInt(dtPaymentDetail.Rows[0]["PaymentModeID"]);
                objLedTran.IsCancel = Util.GetInt(rdbpaid.SelectedItem.Value);
                objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                objLedTran.UserID = ViewState["UserID"].ToString();
                objLedTran.UniqueHash = txtHash.Text.Trim();
                objLedTran.Remarks = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text.Trim();

                objLedTran.GovTaxAmount = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtGovTaxAmt")).Text.Trim());
                objLedTran.GovTaxPer = Util.GetDecimal(lblGovTaxPer.Text.Trim());
                objLedTran.Refund_Against_BillNo = lblRefund_Against_BillNo.Text.Trim();
                objLedTran.IPNo = "ISHHI" + lblIPDNo.Text;
                objLedTran.PatientType = lblPatientType.Text.Trim();
                objLedTran.IpAddress = All_LoadData.IpAddress();
                string creditBillNO = Util.GetString(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select Get_Canteen_BillNo('" + HttpContext.Current.Session["CentreID"].ToString() + "')"));
                if (creditBillNO == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Error...";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                    return 0;
                }

                objLedTran.BillNo = creditBillNO;
                ledTxnID = objLedTran.Insert();

                if (ledTxnID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Error...";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                    return 0;
                }

                decimal NetAmt = 0;

                // Add new on 29-06-2017 - For GST
                decimal igstTaxPercent = 0, cgstTaxPercent = 0, sgstTaxPercent = 0;
                decimal igstTaxAmt = 0, cgstTaxAmt = 0, sgstTaxAmt = 0;
                //

                for (int i = 0; i < dtItem.Rows.Count; i++)
                {


                    //---------------- Insert into Ledger Trans Details Table Multiple Row Effect-----------
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tranx);
                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = ledTxnID;
                    objLTDetail.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    objLTDetail.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    objLTDetail.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);
                    objLTDetail.TransactionID = tID;
                    objLTDetail.Rate = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                    objLTDetail.Quantity = -Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]);
                    objLTDetail.IsVerified = 1;
                    objLTDetail.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]) + " (Batch : " + Util.GetString(dtItem.Rows[i]["BatchNumber"]) + ")";
                    objLTDetail.EntryDate = DateTime.Now;
                    decimal discAmtPerItem = ((objLTDetail.Rate * Util.GetDecimal(dtItem.Rows[i]["ReturnQty"])) * discPer) / 100;
                    objLTDetail.Amount = -Util.GetDecimal((objLTDetail.Rate * Util.GetDecimal(dtItem.Rows[i]["ReturnQty"])) - discAmtPerItem);
                    objLTDetail.DiscAmt = -discAmtPerItem;
                    objLTDetail.DiscountPercentage = discPer;
                    objLTDetail.DiscountReason = discountReason;
                    objLTDetail.NetItemAmt = -Util.GetDecimal((objLTDetail.Rate * Util.GetDecimal(dtItem.Rows[i]["ReturnQty"])) - discAmtPerItem);
                    objLTDetail.TotalDiscAmt = -discAmtPerItem;
                    objLTDetail.UserID = ViewState["UserID"].ToString();
                    objLTDetail.TransactionID = tID;
                    objLTDetail.TnxTypeID = Util.GetInt("17");
                    objLTDetail.IsReusable = Util.GetString(dtItem.Rows[i]["IsUsable"]);
                    objLTDetail.ToBeBilled = Util.GetInt(dtItem.Rows[i]["ToBeBilled"]);
                    objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    objLTDetail.Type = "O";
                    objLTDetail.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"]);
                    objLTDetail.IsExpirable = Util.GetInt(dtItem.Rows[i]["IsExpirable"]);
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[i]["SubCategoryID"]), con));
                    objLTDetail.TransactionType_ID = 17;

                    // Add new on 29-06-2017 - For GST
                    igstTaxPercent = Util.GetDecimal(dtItem.Rows[i]["IGSTPercent"]);
                    cgstTaxPercent = Util.GetDecimal(dtItem.Rows[i]["CGSTPercent"]);
                    sgstTaxPercent = Util.GetDecimal(dtItem.Rows[i]["SGSTPercent"]);

                    All_LoadData.CalculateGSTTax(objLTDetail.Rate, objLTDetail.Quantity, objLTDetail.DiscountPercentage, objLTDetail.DiscAmt, igstTaxPercent, cgstTaxPercent, sgstTaxPercent, out igstTaxAmt, out cgstTaxAmt, out sgstTaxAmt);

                    objLTDetail.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
                    objLTDetail.IGSTPercent = igstTaxPercent;
                    objLTDetail.CGSTPercent = cgstTaxPercent;
                    objLTDetail.SGSTPercent = sgstTaxPercent;
                    objLTDetail.IGSTAmt = igstTaxAmt;
                    objLTDetail.CGSTAmt = cgstTaxAmt;
                    objLTDetail.SGSTAmt = sgstTaxAmt;
                    objLTDetail.GSTType = Util.GetString(dtItem.Rows[i]["GSTType"]);
                    //                    

                    int iD = objLTDetail.Insert();

                    NetAmt = NetAmt + Util.GetDecimal(objLTDetail.Amount);
                    if (iD == 0)
                    {
                        tranx.Rollback();
                        tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error...";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                        return 0;
                    }


                    //---------------- Insert into Sales Details Table-----------

                    Sales_Details objSales = new Sales_Details(tranx);
                    objSales.LedgerNumber = ledgerNumber;
                    objSales.DepartmentID = "STO00002";
                    objSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    objSales.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]);
                    objSales.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                    objSales.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                    objSales.Date = System.DateTime.Now;
                    objSales.Time = System.DateTime.Now;
                    objSales.IsReturn = 1;
                    objSales.TrasactionTypeID = 17;
                    objSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    objSales.IsService = "NO";
                    objSales.IndentNo = "";
                    objSales.Naration = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
                    objSales.SalesNo = SalesNo;
                    objSales.UserID = ViewState["UserID"].ToString();
                    objSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    objSales.PatientID = lblMRNo.Text.ToString();
                    objSales.LedgerTransactionNo = ledTxnID;
                    objSales.AgainstLedgerTnxNo = Util.GetString(dtItem.Rows[i]["AgainstLedgerTnxNo"]);
                    objSales.BillNoforGP = creditBillNO;
                    objSales.IsReusable = Util.GetString(dtItem.Rows[i]["IsUsable"]);
                    objSales.ToBeBilled = Util.GetInt(dtItem.Rows[i]["ToBeBilled"]);
                    objSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objSales.Hospital_ID = Session["HOSPID"].ToString();
                    objSales.Type_ID = StockReports.ExecuteScalar("Select Type_ID from f_itemmaster where itemID='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "'");
                    objSales.Refund_Against_BillNo = lblRefund_Against_BillNo.Text.Trim();
                    objSales.IpAddress = All_LoadData.IpAddress();
                    objSales.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"]);
                    objSales.LedgerTnxNo = iD;

                    // Add new on 29-06-2017 - For GST
                    objSales.IGSTPercent = igstTaxPercent;
                    objSales.CGSTPercent = cgstTaxPercent;
                    objSales.SGSTPercent = sgstTaxPercent;
                    objSales.IGSTAmt = igstTaxAmt * (-1);
                    objSales.CGSTAmt = cgstTaxAmt * (-1);
                    objSales.SGSTAmt = sgstTaxAmt * (-1);
                    //

                    string salesID = objSales.Insert();
                    if (salesID == "")
                    {
                        tranx.Rollback();
                        tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error...";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                        return 0;
                    }

                    //---- Update Release Count in Stock Table---------------------

                    string strStock = "";
                    if (dtItem.Rows[i]["IsUsable"].ToString() == "0" || dtItem.Rows[i]["IsUsable"].ToString() == "NR")
                    {


                        float soldstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.LedgerTransactionNo='" + lblLedgerno.Text.Trim() + "' AND  StockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "' AND patientid='" + lblMRNo.Text.Trim() + "'"));
                        float returnstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.AgainstLedgerTnxNo='" + lblLedgerno.Text.Trim() + "' AND  StockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "' AND patientid='" + lblMRNo.Text.Trim() + "'"));
                        if (soldstock <= returnstock && soldstock != 0.00 && returnstock != 0.00)
                        {
                            tranx.Rollback();
                            tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            lblMsg.Text = "Stock already returned please reopen the page";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Stock already returned please reopen the page');", true);
                            return 0;
                        }

                        strStock = "update f_stock set ReleasedCount = ReleasedCount -" + objSales.SoldUnits + " where StockID = '" + objSales.StockID + "' and ReleasedCount - " + objSales.SoldUnits + "<=InitialCount";

                        if (MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strStock) == 0)
                        {
                            tranx.Rollback();
                            tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Stock already returned please reopen the page');", true);
                            lblMsg.Text = "Stock already returned please reopen the page";
                            return 0;
                        }
                    }
                }

                ////////////////////////////// Insert in Receipt ///////////////////
                if (lblreceiptno.Text != "")
                {
                    if (dtPaymentDetail.Rows[0]["PaymentMode"].ToString() != "Credit")
                    {
                        Receipt objReceipt = new Receipt(tranx);
                        objReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objReceipt.AmountPaid = -amountPaid;
                        objReceipt.AsainstLedgerTnxNo = ledTxnID;
                        objReceipt.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                        objReceipt.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                        objReceipt.Discount = 0;
                        objReceipt.PanelID = Util.GetInt(lblPanel_ID.Text.ToString());
                        objReceipt.IsCancel = Util.GetInt(rdbpaid.SelectedItem.Value);
                        objReceipt.Reciever = ViewState["UserID"].ToString();
                        if (rdoReturn.SelectedItem.Value == "OPD")
                            objReceipt.Depositor = lblMRNo.Text.ToString();
                        else
                            objReceipt.Depositor = "CASH003";
                        objReceipt.TransactionID = tID;
                        objReceipt.LedgerNoDr = "STO00002";
                        if (rdoReturn.SelectedItem.Value == "OPD")
                            objReceipt.LedgerNoCr = "CASH003";
                        else
                            objReceipt.LedgerNoCr = "CASH003";
                        objReceipt.RoundOff = roundOff;
                        objReceipt.deptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                        objReceipt.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        objReceipt.IpAddress = All_LoadData.IpAddress();

                        string receiptNo = objReceipt.Insert();

                        if (receiptNo == string.Empty)
                        {
                            tranx.Rollback();
                            tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            lblMsg.Text = "Error...";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                            return 0;
                        }

                        Receipt_PaymentDetail objReceiptPayment = new Receipt_PaymentDetail(tranx);
                        foreach (DataRow row in dtPaymentDetail.Rows)
                        {
                            objReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                            objReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                            objReceiptPayment.Amount = -Util.GetDecimal(row["BaseCurrency"]);
                            objReceiptPayment.ReceiptNo = receiptNo;
                            objReceiptPayment.PaymentRemarks = Util.GetString(row["PaymentRemarks"]);
                            objReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                            objReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                            objReceiptPayment.BankName = Util.GetString(row["BankName"]);
                            objReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                            objReceiptPayment.S_Amount = -Util.GetDecimal(row["PaidAmount"]);
                            objReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                            objReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                            objReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                            objReceiptPayment.CentreID = Util.GetInt(Session["CentreID"].ToString());
                            objReceiptPayment.Hospital_ID = Session["HOSPID"].ToString();
                            string paymentID = objReceiptPayment.Insert().ToString();

                            if (paymentID == string.Empty)
                            {
                                tranx.Rollback();
                                tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                lblMsg.Text = "Error...";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Error...');", true);
                                return 0;
                            }
                        }

                        if (receiptNo == "")
                        {

                            return 0;
                        }

                        
                    }
                }
                tranx.Commit();
                tranx.Dispose();
                con.Close();
                con.Dispose();
                ViewState["dtPaymentDetail"] = null;
                lblMsg.Text = "Item Returned successfully.";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('Item Returned successfully.');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='Canteen_Return.aspx';", true);
                if (Util.IsAfterGSTApply(dtItem.Rows[0]["BillDate"].ToString()) == "1")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/GSTCanteenReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&OutID=" + lblCustomerId.Text + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Dublicate=0');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/CanteenReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&OutID=" + lblCustomerId.Text + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Dublicate=0');", true);
                }

                return SalesNo;


            }
            catch (Exception ex)
            {
                // lblMsg.Text = ex.Message;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert(" + ex.Message + ");", true);
                tranx.Rollback();
                tranx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                ViewState["dtPaymentDetail"] = null;
                return 0;
            }
        }
        else
            return 0;
    }

    protected void rdoReturn_SelectedIndexChanged(object sender, EventArgs e)
    {

        pnlInfo.Visible = false;
        pnlOpdReturn.Visible = false;


        EnableFalse();
        lblMsg.Text = "";
        txtReceiptNo.Text = "";
        txtBillNo.Text = "";
        grdItem.DataSource = null;
        grdItem.DataBind();
    }
    protected void EnableFalse()
    {

        gvIssueItem.DataSource = null;
        gvIssueItem.DataBind();
        ViewState["DataItem"] = null;
        ((TextBox)PaymentControl.FindControl("txtDisAmount")).Text = "";
        ((TextBox)PaymentControl.FindControl("txtDisPercent")).Text = "";
        ((TextBox)PaymentControl.FindControl("txtBillAmount")).Text = "0";
        ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text = "0";
        ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = "0";
        ((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text = "0";
        ((Label)PaymentControl.FindControl("lblRoundVal")).Text = "0";
        ((TextBox)PaymentControl.FindControl("txtRemarks")).Text = "";

        AllSelectQuery asq = new AllSelectQuery();
        decimal rate = asq.ConvertCurrencyBase(Util.GetInt(((DropDownList)PaymentControl.FindControl("ddlCountry")).SelectedValue), Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtNetAmount")).Text));

        ((Label)PaymentControl.FindControl("lblCurrencyBase")).Text = Util.GetString(rate) + " " + ((TextBox)PaymentControl.FindControl("lblCurrencyNotation")).Text;
        ((GridView)PaymentControl.FindControl("grdPaymentMode")).DataSource = null;
        ((GridView)PaymentControl.FindControl("grdPaymentMode")).DataBind();

    }
    protected void btnGen_Click(object sender, EventArgs e)
    {
        btnSearch_Click(this, new EventArgs());
    }
}