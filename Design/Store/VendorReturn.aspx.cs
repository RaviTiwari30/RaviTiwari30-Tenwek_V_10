using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Linq;
public partial class Design_Store_VendorReturn : System.Web.UI.Page
{
    #region Even Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            AllLoadData_Store.checkStoreRight(rblStoreType);
            rblStoreType_SelectedIndexChanged(this, new EventArgs());
            txtBar.Attributes.Add("onKeyPress", "doClick('" + btnBar.ClientID + "',event)");
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
            btnSaveAsDraft.Enabled =false;
            btnPendingDrafts.Visible = false;
            txtSearchModelFromDate.Text = txtSerachModelToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExdTxtSerachModelToDate.EndDate = calExdTxtSearchModelFromDate.EndDate = calExdTxtSerachModelToDate.EndDate = System.DateTime.Now;
        }
        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");
    }
    protected void ddlVendor_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindItem();
        //grdItem.DataSource = null;
        //grdItem.DataBind();
        //ScriptManager1.SetFocus(txtBar);

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchItem();
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ValidateItem())
        {
            DataTable dt = new DataTable();
            if (ViewState["ReturnItem"] != null)
                dt = (DataTable)ViewState["ReturnItem"];
            else
                dt = GetItem();

            foreach (GridViewRow row in grdItem.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    string StockId = ((Label)row.FindControl("lblStockID")).Text;
                    DataRow[] dr1 = dt.Select("StockID='" + StockId + "'");
                    if (dr1.Length > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM035','" + lblMsg.ClientID + "');", true);
                        txtBar.Focus();
                        return;
                    }
                    else
                    {
                        DataRow dr = dt.NewRow();
                        dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                        dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                        dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                        dr["BatchNo"] = ((Label)row.FindControl("lblBatch")).Text;
                        dr["NewBatchNo"] = ((TextBox)row.FindControl("txtNewBatchNo")).Text;
                        dr["SubCategory"] = ((Label)row.FindControl("lblSubCategory")).Text;
                        dr["UnitPrice"] = ((Label)row.FindControl("lblPrice")).Text;
                        dr["MRP"] = ((Label)row.FindControl("lblMRP")).Text;
                        dr["RetQty"] = ((TextBox)row.FindControl("txtReturn")).Text;
                        dr["Amount"] = Util.GetFloat(dr["UnitPrice"]) * (100 - Util.GetFloat(((TextBox)row.FindControl("txtDis")).Text)) / 100 * Util.GetFloat(dr["RetQty"]);
                        dr["DiscountPer"] = Util.GetFloat(((TextBox)row.FindControl("txtDis")).Text);
                        dr["DiscountAmt"] = (Util.GetFloat(((Label)row.FindControl("lblPrice")).Text) * Util.GetFloat(((TextBox)row.FindControl("txtDis")).Text) / 100) * Util.GetFloat(dr["RetQty"]);
                        
                        dr["ExpDate"] = ((Label)row.FindControl("lblMedExp")).Text;
                        dr["IsExpirable"] = ((Label)row.FindControl("lblisExpirable")).Text;
                        dr["PurTaxPer"] = ((Label)row.FindControl("lblPurTaxPer")).Text;
                        dr["SaleTaxPer"] = ((Label)row.FindControl("lblSaleTaxPer")).Text;
                        //GST Changes
                        dr["IGSTPercent"] = ((Label)row.FindControl("lblIGSTPercent")).Text;
                        dr["CGSTPercent"] = ((Label)row.FindControl("lblCGSTPercent")).Text;
                        dr["SGSTPercent"] = ((Label)row.FindControl("lblSGSTPercent")).Text;
                        dr["GSTType"] = ((Label)row.FindControl("lblGSTType")).Text;
                        dr["HSNCode"] = ((Label)row.FindControl("lblHSNCode")).Text;
                        dr["GRN_No"] = ((Label)row.FindControl("lblGRN_NO")).Text;
                        dr["InvoiceNo"] = ((Label)row.FindControl("lblInvoice_NO")).Text;

                     
                        dt.Rows.Add(dr);
                    }
                }
            }
            dt.AcceptChanges();
            ViewState["ReturnItem"] = dt;
            lblTotal.Text = dt.Compute("sum(Amount)", "").ToString();
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            pnlSave.Visible = true;
            txtBar.Text = string.Empty;
            txtBar.Focus();
            ddlVendor.Enabled = false;
            pnlInfo.Visible = false;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string LedTnxNo = SaveData();
        if (LedTnxNo != string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Return No.:'+'" + LedTnxNo + "');location.href='VendorReturn.aspx';", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('VendorReturnReport.aspx?NRGP=" + LedTnxNo + "');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["ReturnItem"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grdItemDetails.DataSource = dtItem;
            grdItemDetails.DataBind();
            ViewState["ReturnItem"] = dtItem;
            if (grdItemDetails.Rows.Count == 0)
            {
                pnlInfo.Visible = false;
                pnlSave.Visible = false;
                ddlVendor.Enabled = true;
            }
        }

    }
    #endregion

    #region Data Binding
    private void BindVendor()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT LM.LedgerName,LM.LedgerNumber FROM f_ledgermaster LM  ");
        sb.Append(" INNER JOIN f_stock ST ON st.VenLedgerNo = lm.LedgerNumber WHERE LM.GroupID='ven' and ");
        if (rblStoreType.SelectedIndex == 0) // Medical Store
            sb.Append(" st.TypeOfTnx='PURCHASE' AND  ");
        else if (rblStoreType.SelectedIndex == 1)  // General Store
            sb.Append(" st.TypeOfTnx='NMPURCHASE' AND  ");
        sb.Append(" (ST.InitialCount-st.ReleasedCount)>0  AND ST.IsPost=1 AND st.StoreLedgerNo='" + rblStoreType.SelectedValue + "' AND st.CentreID="+ Util.GetInt(Session["CentreID"].ToString())+" group by LM.LedgerName");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "LedgerNumber";
            ddlVendor.DataBind();
            ddlVendor.Items.Insert(0, new ListItem("Select Vendor", "0"));
        }
        else
        {
            ddlVendor.Items.Clear();
			ddlVendor.Items.Insert(0, new ListItem("Select Vendor", "0"));
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM270','" + lblMsg.ClientID + "');", true);
        }
    }
    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ST.itemID,ST.ItemName,st.IsExpirable FROM f_stock  ST ");
        sb.Append(" WHERE ST.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' AND  ");
        
        if(rblStoreType.SelectedIndex==0) // Medical Store
            sb.Append(" st.TypeOfTnx='PURCHASE' AND  ");
        else if (rblStoreType.SelectedIndex == 1)  // General Store
            sb.Append(" st.TypeOfTnx='NMPURCHASE' AND  ");

        sb.Append(" (ST.InitialCount-st.ReleasedCount )>0 and ST.IsPost=1 ");
        if (rbSupplier.SelectedIndex == 0)
            sb.Append(" and st.VenLedgerNo='" + ddlVendor.SelectedValue + "' ");
        sb.Append(" AND st.StoreLedgerNo='" + rblStoreType.SelectedValue + "'  and st.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " group by ST.itemID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlItem.DataSource = dt;
            ddlItem.DataTextField = "ItemName";
            ddlItem.DataValueField = "itemID";
            ddlItem.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM249','" + lblMsg.ClientID + "');", true);
            ddlItem.Items.Clear();
        }
    }
    private void SearchItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("     select SaleTaxPer,BatchNumber,StockID,st.ReferenceNo LedgerTransactionNo,ItemName, ");
        if (rblReturnOn.SelectedValue.ToString() == "0")
            sb.Append(" UnitPrice, ");
        else
            sb.Append(" MRP UnitPrice, ");
        sb.Append("  MRP,IF(IsExpirable=1,DATE_FORMAT(MedExpiryDate,'%d-%b-%y'),'') MedExpiryDate,IsExpirable,");
        sb.Append("     (InitialCount-ReleasedCount)as AvailQty,ItemID,SubCategoryID,PurTaxPer, ");

        //GST Changes
        sb.Append("     IGSTPercent,CGSTPercent,SGSTPercent,GSTType,HSNCode,InvoiceNo, ");

        sb.Append("  st.ReferenceNo BillNo FROM f_stock st where  (InitialCount-ReleasedCount) > 0");
        sb.Append("     AND itemid=" + ddlItem.SelectedValue + " and IsPost=1  and CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ");
        if (rbExpired.SelectedValue.ToString() == "0")
            sb.Append(" And IsExpirable=1 AND MedExpiryDate<CURDATE() ");
        
       
        if (rblStoreType.SelectedIndex == 0) // Medical Store
            sb.Append(" AND st.TypeOfTnx='PURCHASE'  ");
        else if (rblStoreType.SelectedIndex == 1)  // General Store
            sb.Append(" AND st.TypeOfTnx='NMPURCHASE'  ");
        if (rbSupplier.SelectedValue.ToString() == "0")
            sb.Append(" AND st.VenLedgerNo='" + ddlVendor.SelectedValue + "' ");
        sb.Append(" AND st.CentreID =" + Util.GetInt(Session["CentreID"].ToString()) + "  ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            pnlInfo.Visible = true;
            lblMsg.Text = string.Empty;
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            pnlInfo.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private DataTable GetItem()
    {
        DataTable dt = new DataTable();

        dt.Columns.Add("ItemID");
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNo");
        dt.Columns.Add("NewBatchNo");
        dt.Columns.Add("SubCategory");
        dt.Columns.Add("UnitPrice", typeof(decimal));
        dt.Columns.Add("MRP", typeof(decimal));
        dt.Columns.Add("RetQty", typeof(decimal));
        dt.Columns.Add("Amount", typeof(decimal));
        dt.Columns.Add("DiscountPer", typeof(decimal));
        dt.Columns.Add("DiscountAmt", typeof(decimal));
        dt.Columns.Add("ExpDate");
        dt.Columns.Add("IsExpirable");
        dt.Columns.Add("PurTaxPer");
        dt.Columns.Add("SaleTaxPer");
        //GST Changes
        dt.Columns.Add("IGSTPercent", typeof(decimal));
        dt.Columns.Add("CGSTPercent", typeof(decimal));
        dt.Columns.Add("SGSTPercent", typeof(decimal));
        dt.Columns.Add("GSTType", typeof(string));
        dt.Columns.Add("HSNCode", typeof(string));
        dt.Columns.Add("GRN_NO");
        dt.Columns.Add("InvoiceNo");
        return dt;
    }
    #endregion

    #region Validation
    private bool ValidateItem()
    {
        bool status = true;
        foreach (GridViewRow row in grdItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                status = false;
                decimal AvailQty = 0, RetQty = 0;
                AvailQty = Util.GetDecimal(((Label)row.FindControl("lblAqty")).Text);
                if (((TextBox)row.FindControl("txtReturn")).Text == string.Empty || Util.GetDecimal(((TextBox)row.FindControl("txtReturn")).Text) == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                    return false;
                }
                else
                    RetQty = Util.GetDecimal(((TextBox)row.FindControl("txtReturn")).Text);
                if (RetQty > AvailQty)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM252','" + lblMsg.ClientID + "');", true);
                    return false;
                }
            }
        }
        if (status)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return false;
        }
        return true;
    }
    #endregion

    #region Save Data
    private string SaveData()
    {
        if (ViewState["ReturnItem"] != null)
        {
            string LedgerTnxNo = string.Empty;
            DataTable dt = (DataTable)ViewState["ReturnItem"];

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
              
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('7','" + rblStoreType.SelectedValue + "','" + Util.GetInt(Session["CentreID"].ToString()) + "') "));


                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    decimal IGSTAmt = 0, CGSTAmt = 0, SGSTAmt = 0, TaxableAmt = 0;
                    decimal TaxableVATAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["PurTaxPer"])));
                    decimal vatamt = TaxableVATAmt * Util.GetDecimal(dt.Rows[i]["PurTaxPer"]) / 100;

                    decimal TaxableSaleVATAmt = Util.GetDecimal(dt.Rows[i]["MRP"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["SaleTaxPer"])));
                    decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]) / 100;


                    TaxableAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["IGSTPercent"]) + Util.GetDecimal(dt.Rows[i]["CGSTPercent"]) + Util.GetDecimal(dt.Rows[i]["SGSTPercent"])));
                    IGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(dt.Rows[i]["IGSTPercent"]) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
                    CGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(dt.Rows[i]["CGSTPercent"]) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
                    SGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(dt.Rows[i]["SGSTPercent"]) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);

                    Sales_Details ObjSales = new Sales_Details(Tranx);
                    ObjSales.LedgerTransactionNo = "0";
                    ObjSales.LedgerNumber = ddlVendor.SelectedValue;
                    ObjSales.DepartmentID = rblStoreType.SelectedValue;
                    ObjSales.StockID = Util.GetString(dt.Rows[i]["StockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(dt.Rows[i]["RetQty"]);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dt.Rows[i]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dt.Rows[i]["MRP"]);
                    ObjSales.TrasactionTypeID = 7;
                    ObjSales.ItemID = Util.GetString(dt.Rows[i]["ItemID"]);
                    ObjSales.Naration = txtNarration.Text.Trim();
                    ObjSales.IndentNo = txtIndentNo.Text.Trim();
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    ObjSales.UserID = Session["ID"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime(dt.Rows[i]["ExpDate"]);
                    ObjSales.LedgerTnxNo = 0; // LedTnxID;
                    ObjSales.PurTaxAmt = vatamt;
                    ObjSales.PurTaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"]);

                    ObjSales.TaxPercent = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]);
                    ObjSales.TaxAmt = vatSaleamt;

                    //GST Changes
                    ObjSales.IGSTPercent = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]);
                    ObjSales.IGSTAmt = IGSTAmt;
                    ObjSales.CGSTPercent = Util.GetDecimal(dt.Rows[i]["CGSTPercent"]);
                    ObjSales.CGSTAmt = CGSTAmt;
                    ObjSales.SGSTPercent = Util.GetDecimal(dt.Rows[i]["SGSTPercent"]);
                    ObjSales.SGSTAmt = SGSTAmt;
                    ObjSales.GSTType = Util.GetString(dt.Rows[i]["GSTType"]);
                    ObjSales.HSNCode = Util.GetString(dt.Rows[i]["HSNCode"]);
                    ObjSales.DisPercent = Util.GetDecimal(dt.Rows[i]["DiscountPer"]);
                    ObjSales.DiscAmt = Util.GetDecimal(dt.Rows[i]["DiscountAmt"]);
                    ObjSales.ServiceItemID = "0";
                    ObjSales.TransactionID = "0";
                    //----

                    string SalesID = ObjSales.Insert();
                    if (SalesID == string.Empty)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }
                    string str = "update f_stock set ReleasedCount = ReleasedCount + " + dt.Rows[i]["RetQty"] + " where StockID = '" + dt.Rows[i]["StockID"] + "'";
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str) == 0)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }
                    string BarcodeID = StockReports.ExecuteScalar("SELECT s.BarCodeID FROM f_stock s WHERE s.StockID='" + dt.Rows[i]["StockID"] + "'");
                    if (string.IsNullOrEmpty(BarcodeID)) {
                        Tranx.Rollback();
                        return string.Empty;
                    }
                    str = "insert Into f_vendor_return (Vender_ID,LedgerTransactionNo,ItemID,QTY,Rate,Amount,AgainstLedgerTransactionNo,DeptID,EditedBy,EditedDate,statusType,SalesID,NewBatchNo,BarcodeID) ";
                    str = str + ("values ('" + ddlVendor.SelectedValue.Trim() + "','0','" + Util.GetString(dt.Rows[i]["ItemID"]) + "','" + Util.GetDecimal(dt.Rows[i]["RetQty"]) + "','" + Util.GetDecimal(dt.Rows[i]["UnitPrice"]) + "','" + Util.GetDecimal(dt.Rows[i]["Amount"]) + "','" + Util.GetString(dt.Rows[i]["GRN_No"]) + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["ID"].ToString() + "',CURRENT_DATE,0,'" + SalesID + "','" + Util.GetString(dt.Rows[i]["NewBatchNo"]) + "','" + BarcodeID + "')");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str) == 0)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }
                }
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedgerTnxNo), 0, 7, SalesNo, Tranx));
                    if (IsIntegrated == "0")
                    {
                        Tranx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                    }
                }
                Tranx.Commit();
                return SalesNo.ToString();
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        return string.Empty;

    }
    #endregion
    protected void btnBar_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select t1.* from (select BatchNumber,StockID,LedgerTransactionNo,ItemName,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,st.IsExpirable,");
        sb.Append(" ,(InitialCount-ReleasedCount)as AvailQty,ItemID,SubCategoryID, ");
        //GST Changes
        sb.Append(" IGSTPercent,CGSTPercent,SGSTPercent,GSTType,HSNCode,SaleTaxPer,PurTaxPer ");
        sb.Append(" from f_stock where  (InitialCount-ReleasedCount) > 0");
        sb.Append(" and StockID='LSHHI" + txtBar.Text.Trim() + "' and IsPost=1  and s.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " )t1 inner join f_ledgertransaction Lt on t1.LedgerTransactionNo=LT.LedgerTransactionNo");
        sb.Append("  and LT.typeoftnx='purchase' and Lt.LedgerNoCr='" + ddlVendor.SelectedValue + "' AND lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            lblMsg.Text = string.Empty;
            for (int i = 0; i < grdItem.Rows.Count; i++)
                ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
            grdItem.Focus();
            lblMsg.Text = string.Empty;
            txtBar.Text = string.Empty;
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtBar.Text = string.Empty;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            txtBar.Focus();
        }
    }
    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindVendor();
        BindItem();
    }
    protected void rbSupplier_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }
    protected void rblReturnOn_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblReturnOn.SelectedValue == "2")
        {
            rblReturnOn.Enabled = false;
            btnSave.Enabled = false;
            btnSaveAsDraft.Enabled=true;
            btnPendingDrafts.Visible = true;
            grdItem.DataSource = null;
            grdItem.DataBind();
            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
        }
    }
    protected void btnSaveAsDraft_Click(object sender, EventArgs e)
    {
        string RequestNo = SaveAsDraft();
        if (RequestNo != "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Record Save As Draft'); window.open('VendorDraftReturnReport.aspx?RequestNo=" + RequestNo + "'); location.href='VendorReturn.aspx';", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }
    private string SaveAsDraft()
    {
        if (ViewState["ReturnItem"] != null)
        {
            string LedgerTnxNo = string.Empty;
            DataTable dt = (DataTable)ViewState["ReturnItem"];
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD = new ExcuteCMD();
            StringBuilder sb = new StringBuilder();
            try
            {
                int result = 0;
                string str = " SELECT IFNULL(MAX(id),0)+1 FROM f_vendor_return_saveasdraft  ";
                int RequestNo = Util.GetInt(excuteCMD.ExecuteScalar(Tranx, str, CommandType.Text, new { }));
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    excuteCMD.DML(Tranx, " insert Into f_vendor_return_saveasdraft (RequestNo,StockId,Vender_ID,ItemID,ItemName,BatchNo,NewBatchNo,SubCategory,UnitPrice,MRP,RetQty,Amount,DiscountPer,DiscountAmt,PurTaxPer,SaleTaxPer,IGSTPercent,CGSTPercent,SGSTPercent,GSTType,HSNCode,GRN_NO,InvoiceNo,DeptID,EntryBy,EntryDate,IsExpirable,medExpiryDate,StoreType) values(@RequestNo,@StockId,@Vender_ID,@ItemID,@ItemName,@BatchNo,@NewBatchNo,@SubCategory,@UnitPrice,@MRP,@RetQty,@Amount,@DiscountPer,@DiscountAmt,@PurTaxPer,@SaleTaxPer,@IGSTPercent,@CGSTPercent,@SGSTPercent,@GSTType,@HSNCode,@GRN_NO,@InvoiceNo,@DeptID,@EntryBy,@EntryDate,@IsExpirable,@medExpiryDate,@StoreType)", CommandType.Text, new
                    {
                        RequestNo = RequestNo,
                        StoreType=rblStoreType.SelectedValue,
                        Vender_ID = ddlVendor.SelectedValue.Trim(),
                        StockId = Util.GetString(dt.Rows[i]["StockID"]),
                        ItemID = Util.GetString(dt.Rows[i]["ItemID"]),
                        ItemName = Util.GetString(dt.Rows[i]["ItemName"]),
                        BatchNo = Util.GetString(dt.Rows[i]["BatchNo"]),
                        NewBatchNo = Util.GetString(dt.Rows[i]["NewBatchNo"]),
                        SubCategory = Util.GetString(dt.Rows[i]["SubCategory"]),
                        UnitPrice = Util.GetDecimal(dt.Rows[i]["UnitPrice"]),
                        MRP = Util.GetDecimal(dt.Rows[i]["MRP"]),
                        RetQty = Util.GetDecimal(dt.Rows[i]["RetQty"]),
                        Amount = Util.GetDecimal(dt.Rows[i]["Amount"]),
                        DiscountPer = Util.GetDecimal(dt.Rows[i]["DiscountPer"]),
                        DiscountAmt = Util.GetDecimal(dt.Rows[i]["DiscountAmt"]),
                        PurTaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"]),
                        SaleTaxPer = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]),
                        IGSTPercent = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]),
                        CGSTPercent = Util.GetDecimal(dt.Rows[i]["CGSTPercent"]),
                        SGSTPercent = Util.GetDecimal(dt.Rows[i]["SGSTPercent"]),
                        GSTType = Util.GetString(dt.Rows[i]["GSTType"]),
                        HSNCode = Util.GetString(dt.Rows[i]["HSNCode"]),
                        GRN_NO = Util.GetString(dt.Rows[i]["GRN_NO"]),
                        InvoiceNo = Util.GetString(dt.Rows[i]["InvoiceNo"]),
                        DeptID = ViewState["DeptLedgerNo"].ToString(),
                        EntryBy = Session["ID"].ToString(),
                        EntryDate = DateTime.Now.ToString("yyyy-MM-dd"),
                        IsExpirable = Util.GetInt(dt.Rows[i]["IsExpirable"]),
                        medExpiryDate = Util.GetDateTime(dt.Rows[i]["ExpDate"]).ToString("yyyy-MM-dd")
                    });
                    result = 1;
                }
                Tranx.Commit();
                if (result==1)
                    return RequestNo.ToString();
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        return string.Empty;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getDrafts(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT vrsd.RequestNo,lm.LedgerName,GROUP_CONCAT( DISTINCT im.`TypeName` ORDER BY im.`TypeName`  SEPARATOR', ') ItemName,SUM(vrsd.RetQty)QTY,SUM(vrsd.Amount)Amount,  ");
        sb.Append(" DATE_FORMAT(EntryDate,'%d-%b-%Y') EntryDate ");
        sb.Append(" FROM f_vendor_return_saveasdraft vrsd ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON vrsd.Vender_ID=lm.LedgerNumber ");
        sb.Append(" INNER JOIN f_itemmaster im ON vrsd.ItemID=im.ItemID ");
        sb.Append(" where DATE(vrsd.EntryDate)>= '" + Util.GetDateTime(FromDate.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(vrsd.EntryDate)<='" + Util.GetDateTime(ToDate.Trim()).ToString("yyyy-MM-dd") + "'  and vrsd.DeptID='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' and vrsd.RequestType=0  and vrsd.IsActive=1 ");
        sb.Append(" GROUP BY vrsd.RequestNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string getDraftsDetail(string RequestNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT vrsd.Id,vrsd.StoreType,vrsd.StockID ,vrsd.RequestNo,vrsd.Vender_ID,lm.LedgerName,vrsd.ItemID,vrsd.ItemName,vrsd.BatchNo,vrsd.NewBatchNo,vrsd.SubCategory,vrsd.UnitPrice,vrsd.MRP,vrsd.RetQty,vrsd.Amount,vrsd.DiscountPer,vrsd.DiscountAmt,vrsd.PurTaxPer,vrsd.SaleTaxPer,vrsd.IGSTPercent,vrsd.CGSTPercent,vrsd.SGSTPercent,vrsd.GSTType,vrsd.HSNCode,vrsd.GRN_NO,vrsd.InvoiceNo,vrsd.DeptID,vrsd.EntryBy,  ");
        sb.Append(" DATE_FORMAT(EntryDate,'%d-%b-%Y') EntryDate,vrsd.medExpiryDate,vrsd.IsExpirable ");
        sb.Append(" FROM f_vendor_return_saveasdraft vrsd ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON vrsd.Vender_ID=lm.LedgerNumber ");
        sb.Append(" INNER JOIN f_itemmaster im ON vrsd.ItemID=im.ItemID ");
        sb.Append(" where  vrsd.RequestNo='" + RequestNo + "' and vrsd.RequestType=0 and vrsd.IsActive=1  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string SaveDraftsData(List<details> Details)
    {
        string LedgerTnxNo = string.Empty;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string CentreID = HttpContext.Current.Session["CentreID"].ToString();
            string CurrentDeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            string UserID = HttpContext.Current.Session["ID"].ToString();
            string HOSPID = HttpContext.Current.Session["HOSPID"].ToString();
            //Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
            //objLedTran.LedgerNoCr = Util.GetString(Details[0].LedgerNumber);
            //objLedTran.Date = DateTime.Now;
            //objLedTran.Time = DateTime.Now;
            //objLedTran.GrossAmount = Util.GetDecimal(Details.Sum(item => item.NewAmount)) + Util.GetDecimal(Details.Sum(item => item.DiscountAmt));
            //objLedTran.NetAmount = Util.GetDecimal(Details.Sum(item => item.NewAmount));
            //objLedTran.TypeOfTnx = "Vendor-Return";
            //objLedTran.Remarks = Details[0].Narration; //
            //objLedTran.DeptLedgerNo = Details[0].DepartmentID;
            //objLedTran.LedgerNoDr = Details[0].StoreType;
            //objLedTran.CentreID = Util.GetInt(CentreID);
            //objLedTran.Hospital_ID = HOSPID;
            //objLedTran.IpAddress = All_LoadData.IpAddress();
            //objLedTran.UserID = Convert.ToString(UserID);
            //objLedTran.TransactionType_ID = 7;
            //objLedTran.DiscountOnTotal = Util.GetDecimal(Details.Sum(item => item.DiscountAmt));
            //objLedTran.TransactionID = "0";
            //LedgerTnxNo = objLedTran.Insert().ToString();
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('7','" + Details[0].StoreType + "','" + Util.GetInt(CentreID) + "') "));
            Details.ForEach(i =>
         {
             decimal IGSTAmt = 0, CGSTAmt = 0, SGSTAmt = 0, TaxableAmt = 0;
             decimal TaxableVATAmt = Util.GetDecimal(i.UnitPrice) * Util.GetDecimal(i.RetQty) * (100 / (100 + Util.GetDecimal(i.PurTaxPer)));
             decimal vatamt = TaxableVATAmt * Util.GetDecimal( i.PurTaxPer) / 100;
             decimal TaxableSaleVATAmt = Util.GetDecimal(i.MRP) * Util.GetDecimal(i.RetQty) * (100 / (100 + Util.GetDecimal(i.SaleTaxPer)));
             decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(i.SaleTaxPer) / 100;
             TaxableAmt = Util.GetDecimal(i.UnitPrice) * Util.GetDecimal(i.RetQty) * (100 / (100 + Util.GetDecimal(i.IGSTPercent) + Util.GetDecimal(i.CGSTPercent) + Util.GetDecimal(i.SGSTPercent)));
             IGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(i.IGSTPercent) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
             CGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(i.CGSTPercent) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
             SGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(i.SGSTPercent) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
             //LedgerTnxDetail objLedDet = new LedgerTnxDetail(Tranx);
             //objLedDet.ItemID = Util.GetString(i.ItemID);
             //objLedDet.StockID = Util.GetString(i.StockID);
             //objLedDet.SubCategoryID = Util.GetString(i.SubCategory);
             //objLedDet.Rate = Util.GetDecimal(i.UnitPrice);
             //objLedDet.Quantity = Util.GetDecimal(i.RetQty);
             //objLedDet.Amount = Util.GetDecimal(i.NewAmount);
             //objLedDet.NetItemAmt = Util.GetDecimal(i.NewAmount);
             //objLedDet.EntryDate = DateTime.Now;
             //objLedDet.UserID = Convert.ToString(UserID);
             //objLedDet.LedgerTransactionNo = LedgerTnxNo;
             //objLedDet.CentreID = Util.GetInt(CentreID);
             //objLedDet.Hospital_Id = HOSPID;
             //objLedDet.pageURL = All_LoadData.getCurrentPageName();
             //objLedDet.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
             //objLedDet.IsExpirable = Util.GetInt(i.IsExpirable);
             //objLedDet.medExpiryDate = Util.GetDateTime(i.medExpiryDate);
             //objLedDet.IpAddress = All_LoadData.IpAddress();
             //objLedDet.TransactionType_ID = 7;
             //objLedDet.PurTaxPer = Util.GetDecimal(i.PurTaxPer);
             //objLedDet.PurTaxAmt = vatamt;
             //objLedDet.IGSTPercent = Util.GetDecimal(i.IGSTPercent);
             //objLedDet.IGSTAmt = IGSTAmt;
             //objLedDet.CGSTPercent = Util.GetDecimal(i.CGSTPercent);
             //objLedDet.CGSTAmt = CGSTAmt;
             //objLedDet.SGSTPercent = Util.GetDecimal(i.SGSTPercent);
             //objLedDet.SGSTAmt = SGSTAmt;
             //objLedDet.GSTType = Util.GetString(i.GSTType);
             //objLedDet.HSNCode = Util.GetString(i.HSNCode);
             //objLedDet.DiscountPercentage = Util.GetDecimal(i.DiscountPer);
             //objLedDet.DiscAmt = Util.GetDecimal(i.DiscountAmt);
             //int LedTnxID = objLedDet.Insert();
             Sales_Details ObjSales = new Sales_Details(Tranx);
             ObjSales.LedgerTransactionNo = LedgerTnxNo;
             ObjSales.LedgerNumber =i.LedgerNumber;
             ObjSales.DepartmentID = i.StoreType; //rblStoreType.SelectedValue
             ObjSales.StockID = Util.GetString(i.StockID);
             ObjSales.SoldUnits = Util.GetDecimal(i.RetQty);
             ObjSales.PerUnitBuyPrice = Util.GetDecimal(i.UnitPrice);
             ObjSales.PerUnitSellingPrice = Util.GetDecimal(i.MRP);
             ObjSales.TrasactionTypeID = 7;
             ObjSales.ItemID = Util.GetString(i.ItemID);
             ObjSales.Naration =i.Narration;// txtNarration.Text.Trim();
             ObjSales.IndentNo = i.IndentNo; //txtIndentNo.Text.Trim();
             ObjSales.SalesNo = SalesNo;
             ObjSales.Date = DateTime.Now;
             ObjSales.Time = DateTime.Now;
             ObjSales.DeptLedgerNo = Util.GetString(i.DepartmentID); ;
             ObjSales.UserID = UserID;
             ObjSales.CentreID = Util.GetInt(CentreID);
             ObjSales.Hospital_ID = HOSPID;
             ObjSales.IpAddress = All_LoadData.IpAddress();
             ObjSales.medExpiryDate = Util.GetDateTime(i.medExpiryDate);
             ObjSales.LedgerTnxNo = 0;
             ObjSales.PurTaxAmt = vatamt;
             ObjSales.PurTaxPer = Util.GetDecimal(i.PurTaxPer);
             ObjSales.TaxPercent = Util.GetDecimal( i.SaleTaxPer);
             ObjSales.TaxAmt = vatSaleamt;
             ObjSales.IGSTPercent = Util.GetDecimal(i.IGSTPercent);
             ObjSales.IGSTAmt = IGSTAmt;
             ObjSales.CGSTPercent = Util.GetDecimal(i.CGSTPercent);
             ObjSales.CGSTAmt = CGSTAmt;
             ObjSales.SGSTPercent = Util.GetDecimal(i.SGSTPercent);
             ObjSales.SGSTAmt = SGSTAmt;
             ObjSales.GSTType = Util.GetString(i.GSTType);
             ObjSales.HSNCode = Util.GetString(i.HSNCode);
             ObjSales.DisPercent = Util.GetDecimal(i.DiscountPer);
             ObjSales.DiscAmt = Util.GetDecimal(i.DiscountAmt);
             string SalesID = ObjSales.Insert();
             string str = "update f_stock set ReleasedCount = ReleasedCount + " + i.RetQty + " where StockID = '" + i.StockID + "'";
             if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str) == 0)
             {
                 Tranx.Rollback();
               
             }
             string BarcodeID = StockReports.ExecuteScalar("SELECT s.BarCodeID FROM f_stock s WHERE s.StockID='" + i.StockID + "'");
             if (string.IsNullOrEmpty(BarcodeID))
             {
                 Tranx.Rollback();
          
             }
             str = "insert Into f_vendor_return (Vender_ID,LedgerTransactionNo,ItemID,QTY,Rate,Amount,AgainstLedgerTransactionNo,DeptID,EditedBy,EditedDate,statusType,SalesID,NewBatchNo,RequestNo,BarcodeID ) ";
             str = str + ("values ('" + i.LedgerNumber + "','" + 0 + "','" + Util.GetString(i.ItemID) + "','" + Util.GetDecimal(i.RetQty) + "','" + Util.GetDecimal(i.UnitPrice) + "','" + Util.GetDecimal(i.NewAmount) + "','" + Util.GetString(i.GRN_NO) + "','" + i.DepartmentID + "','" + UserID + "',CURRENT_DATE,0,'" + SalesID + "','" + Util.GetString(i.NewBatchNo) + "','" + Util.GetString(i.RequestNo) + "','"+BarcodeID+"')");
             MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

         });
            string str1 = "update f_vendor_return_saveasdraft set RequestType = 1  where RequestNo = '" + Details[0].RequestNo + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str1); 
            Tranx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Drafts Record Return Successfully.", SalesNo = SalesNo.ToString() });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Contact to Administrator", message = ex.Message });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class details
    {
        public string StoreType { get; set; }
        public string InvoiceNo { get; set; }
        public string GRN_NO { get; set; }
        public string RequestNo { get; set; }
        public string LedgerNumber { get; set; }
        public string StockID { get; set; }
        public string DepartmentID { get; set; }
        public string ItemID { get; set; }
        public string NewBatchNo { get; set; }
        public string BatchNo { get; set; }
        public string SubCategory { get; set; }
        public int IsExpirable { get; set; }
        public DateTime medExpiryDate { get; set; }
        public string GSTType { get; set; }
        public string HSNCode { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal RetQty { get; set; }
        public decimal PurTaxPer { get; set; }
        public decimal MRP { get; set; }
        public decimal SaleTaxPer { get; set; }
        public decimal IGSTPercent { get; set; }
        public decimal CGSTPercent { get; set; }
        public decimal SGSTPercent { get; set; }
        public decimal DiscountPer { get; set; }
        public decimal DiscountAmt { get; set; }
        public decimal NewAmount { get; set; }
        public string IndentNo { get; set; }
        public string Narration { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string cancelRecord(string pid, string RequestNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            if (!string.IsNullOrEmpty(pid))
            {
                excuteCMD.DML(tnx, "UPDATE f_vendor_return_saveasdraft sd SET sd.IsActive=0 WHERE sd.id=@pid and sd.RequestNo=@RequestNo ", CommandType.Text, new
                {
                    RequestNo = RequestNo,
                    pid = pid
                });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Record Deleted." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string cancelPendingDrafts(string RequestNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
                excuteCMD.DML(tnx, "UPDATE f_vendor_return_saveasdraft sd SET sd.IsActive=0 WHERE sd.RequestNo=@RequestNo ", CommandType.Text, new
                {
                    RequestNo = RequestNo
                });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Record Deleted." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
