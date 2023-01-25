using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
public partial class Design_Store_ConsumeItem : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UID"] = Session["ID"].ToString();
            ViewState["DeptLedNo"] = Session["DeptLedgerNo"].ToString();
            btnSave.Enabled = false;
            txtFirstNameSearch.Focus();
            BindItem();
        }
    }
    protected void btnGetStock_Click(object sender, EventArgs e)
    {
        BindStock();
        ScriptManager1.SetFocus(grdItem);
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (ListBox1.SelectedIndex < 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            txtFirstNameSearch.Focus();
            return;
        }
        if (Util.GetDecimal(txtTransferQty.Text.Trim()) <= 0)
        {
            lblMsg.Text = "Please Enter Quantity";
            txtTransferQty.Focus();
            return;
        }
        string str = "select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,st.IsExpirable,st.PurTaxPer,st.SaleTaxPer from f_stock ST inner join f_itemmaster IM on ST.ItemID=IM.ItemID where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 and IM.ItemID ='" + ListBox1.SelectedItem.Value.Split('#')[0] + "' and st.DeptLedgerNo='" + ViewState["DeptLedNo"].ToString() + "' AND st.CentreID="+ Session["CentreID"].ToString() +" ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            decimal TranferQty = Util.GetDecimal(txtTransferQty.Text.Trim());
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (TranferQty > Util.GetDecimal(dt.Rows[i]["AvlQty"]))
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = Util.GetString(dt.Rows[i]["AvlQty"]);
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    TranferQty = TranferQty - Util.GetDecimal(dt.Rows[i]["AvlQty"]);
                }
                else
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = TranferQty.ToString();
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    break;
                }
            }
            ListBox1.SelectedIndex = 0;
            lblMsg.Text = "";
            ScriptManager1.SetFocus(grdItem);
            rblStoreType.Enabled = false;
            txtFirstNameSearch.Text = "";
            txtInBetweenSearch.Text = "";
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtFirstNameSearch.Text = "";
            txtInBetweenSearch.Text = "";
            ScriptManager1.SetFocus(txtFirstNameSearch);
        }
    }

    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,CONCAT(IFNULL(ItemCode,''),' # ',im.typename,' # (',sm.name,')')itemName FROM (SELECT ItemID FROM f_stock WHERE ");
        sb.Append(" (InitialCount - ReleasedCount) > 0 AND IsPost = 1 AND  DeptLedgerNo='" + ViewState["DeptLedNo"].ToString() + "' AND CentreID='"+ Session["CentreID"].ToString() +"'  ");
        sb.Append(" GROUP BY ItemID)t1 INNER JOIN f_itemmaster im on t1.itemid = im.ItemID ");
        sb.Append(" INNER JOIN f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID INNER JOIN f_categorymaster ");
        sb.Append(" cm on cm.categoryID=sm.categoryid inner join f_configrelation cf on cf.CategoryID=cm.CategoryID ");
        sb.Append(" WHERE cf.ConfigID='" + rblStoreType.SelectedValue + "' ORDER BY ItemName ");
        sb.Append(" ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
        else
        {
            ListBox1.Items.Clear();

        }
    }

    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ListBox1.SelectedIndex < 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            txtFirstNameSearch.Focus();
            return;
        }
        if (txtTransferQty.Text.Trim() == "" || Util.GetDecimal(txtTransferQty.Text.Trim()) <= 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
            txtTransferQty.Focus();
            return;
        }
        btnAdd_Click(sender, e);
        if (ValidateItems())
        {
            DataTable dt;
            if (ViewState["StockTransfer"] != null)
                dt = (DataTable)ViewState["StockTransfer"];
            else
                dt = GetItemDataTable();

            foreach (GridViewRow row in grdItem.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    DataRow dr = dt.NewRow();
                    dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                    dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                    dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                    dr["Expiry"] = ((Label)row.FindControl("lblExpiry")).Text;
                    dr["MRP"] = ((Label)row.FindControl("lblMRP")).Text;
                    dr["UnitType"] = ((Label)row.FindControl("lblUnitType")).Text;
                    decimal UnitPrice = Util.GetDecimal(((Label)row.FindControl("lblUnitPrice")).Text);
                    dr["UnitPrice"] = UnitPrice;
                    dr["SubCategory"] = ((Label)row.FindControl("lblSubCategory")).Text;
                    decimal Qty = Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text);
                    dr["IssueQty"] = Qty;
                    dr["Qty"] = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
                    dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                    decimal Amount = Qty * UnitPrice;
                    dr["Amount"] = Amount;
                    dr["IsExpirable"] = Util.GetInt(((Label)row.FindControl("lblIsExpirable")).Text);
                    dr["PurTaxPer"] = Util.GetDecimal(((Label)row.FindControl("lblPurTaxPer")).Text);
                    dr["SaleTaxPer"] = Util.GetDecimal(((Label)row.FindControl("lblSaleTaxPer")).Text);
                    

                    dt.Rows.Add(dr);
                }
            }
            dt.AcceptChanges();
            lblAmount.Text = Util.GetString(dt.Compute("sum(Amount)", ""));
            ViewState["StockTransfer"] = dt;
            gvIssueItem.DataSource = dt;
            gvIssueItem.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            btnSave.Enabled = true;
            txtFirstNameSearch.Text = "";
            txtTransferQty.Text = "";
            ScriptManager1.SetFocus(txtFirstNameSearch);
            pnlStock.Visible = true;
        }
    }
    protected void gvIssueItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["StockTransfer"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            lblAmount.Text = Util.GetString(dtItem.Compute("sum(Amount)", ""));
            gvIssueItem.DataSource = dtItem;
            gvIssueItem.DataBind();
            ViewState["StockTransfer"] = dtItem;
            if (dtItem.Rows.Count == 0)
            {
                btnSave.Enabled = false;
                rblStoreType.Enabled = false;
                pnlStock.Visible = false;
            }
            else
            {
                rblStoreType.Enabled = true;
                pnlStock.Visible = true;
            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        DataTable dt = (DataTable)ViewState["StockTransfer"];
        if (txtRemarks.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Remarks";
            txtRemarks.Focus();
            return;
        }
        //for (int j = 0; j < dt.Rows.Count; j++)
        //{
        //    if (((TextBox)gvIssueItem.Rows[j].FindControl("txtNarration")).Text.Trim() == "")
        //    {
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM250','" + lblMsg.ClientID + "');", true);
        //        ((TextBox)gvIssueItem.Rows[j].FindControl("txtNarration")).Focus();
        //        return;
        //    }
        //}

        int SalesNo = SaveData();
        if (SalesNo != 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM251','" + lblMsg.ClientID + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='ConsumeItem.aspx';", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    }
    #endregion
    private DataTable PrintItemIssueReport(string saleno)
    {
        string str = " SELECT IndentNo,(SELECT TypeName from f_itemmaster where ItemID=sale.ItemID)as ItemName, " +
        "    (SELECT LedgerName from f_ledgermaster where LedgerNumber=sale.LedgerNumber)issueDepart, " +
        "    (SELECT LedgerName from f_ledgermaster where LedgerNumber=sale.DepartmentID)Store, " +
        "    (SELECT UnitType from f_itemmaster where ItemID=sale.ItemID)as UnitType," +
        "    SalesID,SoldUnits,Date_format(Date(Date),'%d %b %y')Date,TIME_FORMAT(Time(Date),'%r')Time,Naration,salesNo FROM f_salesdetails sale where salesNo=" + saleno + " ";
        return StockReports.GetDataTable(str);
    }
    #region Data Binding

    private void BindStock()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate from f_stock ST inner join f_itemmaster IM on ST.ItemID=IM.ItemID where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 and IM.ItemID ='" + ListBox1.SelectedItem.Value.Split('#')[0] + "' AND ST.DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + " AND ST.CentreID='" + Session["CentreID"].ToString() + "' ");
        if (dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            lblMsg.Text = string.Empty;
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM053','" + lblMsg.ClientID + "');", true);
        }
    }

    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("Expiry");
        dt.Columns.Add("SubCategory");
        dt.Columns.Add("UnitType");
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("IssueQty", typeof(float));
        dt.Columns.Add("Amount", typeof(float));
        dt.Columns.Add("IsExpirable", typeof(int));
        dt.Columns.Add("PurTaxPer");
        dt.Columns.Add("SaleTaxPer");
        return dt;
    }
    #endregion

    #region Validation
    private bool ValidateItems()
    {
        DataTable dt = null;
        if (ViewState["StockTransfer"] != null)
            dt = (DataTable)ViewState["StockTransfer"];
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
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM035','" + lblMsg.ClientID + "');", true);
                        txtFirstNameSearch.Focus();
                        return false;
                    }
                }

                decimal TransferQty = 0, AvailQty = 0;
                if (((TextBox)row.FindControl("txtIssueQty")).Text.Trim() != string.Empty && Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text.Trim()) > 0)
                    TransferQty = Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text);
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                    txtTransferQty.Focus();
                    return false;
                }

                AvailQty = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
                if (TransferQty > AvailQty)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM252','" + lblMsg.ClientID + "');", true);
                    return false;
                }
            }
        }
        if (status)
        {
            lblMsg.Text = "Please Get Stock Item";
            btnAdd.Focus();
            return false;
        }
        lblMsg.Text = string.Empty;
        return true;
    }
    #endregion


    #region Issue Medicine
    private int SaveData()
    {
        if (ViewState["StockTransfer"] != null)
        {

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('13','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "')"));

                DataTable dtItem = (DataTable)ViewState["StockTransfer"];
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {

                    decimal TaxablePurVATAmt = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]) * Util.GetDecimal(dtItem.Rows[i]["IssueQty"]) * (100 / (100 + Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"])));
                    decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]) / 100;

                    decimal TaxableSaleVATAmt = Util.GetDecimal(dtItem.Rows[i]["MRP"]) * Util.GetDecimal(dtItem.Rows[i]["IssueQty"]) * (100 / (100 + Util.GetDecimal(dtItem.Rows[i]["SaleTaxPer"])));
                    decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dtItem.Rows[i]["SaleTaxPer"]) / 100;

                    Sales_Details ObjSales = new Sales_Details(Tranx);
                    ObjSales.LedgerNumber = ViewState["DeptLedNo"].ToString();

                    if (rblStoreType.SelectedValue == "11")
                        ObjSales.DepartmentID = "STO00001";
                    else
                        ObjSales.DepartmentID = "STO00002";

                    ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["IssueQty"]);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                    ObjSales.Date = System.DateTime.Now;
                    ObjSales.Time = System.DateTime.Now;
                    ObjSales.IsReturn = 0;
                    ObjSales.TrasactionTypeID = 13;
                    ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    ObjSales.IsService = "NO";
                    ObjSales.IndentNo = "";
                    ObjSales.Naration = txtRemarks.Text.Trim();
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.UserID = ViewState["UID"].ToString();
                    ObjSales.DeptLedgerNo = ViewState["DeptLedNo"].ToString();
                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"]);

                    ObjSales.TaxPercent = Util.GetDecimal(dtItem.Rows[i]["SaleTaxPer"]);
                    ObjSales.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]);
                    ObjSales.TaxAmt = vatSaleamt;
                    ObjSales.PurTaxAmt = vatPuramt;

                    ObjSales.LedgerTransactionNo = "0";
                    ObjSales.TransactionID = "0";
                    ObjSales.ServiceItemID = "0";
                    string SalesID = ObjSales.Insert();
                    if (SalesID == "")
                    {
                        Tranx.Rollback();
                        return 0;
                    }

                    string strStock = "update f_stock set ReleasedCount = ReleasedCount +" + ObjSales.SoldUnits + " where StockID = '" + ObjSales.StockID + "' and ReleasedCount + " + ObjSales.SoldUnits + "<=InitialCount";
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock) == 0)
                    {
                        Tranx.Rollback();
                        return 0;
                    }


                }
                
                Tranx.Commit();
                return SalesNo;
            }
            catch(Exception ex)
            {
                Tranx.Rollback();
                return 0;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
            return 0;
    }
    #endregion

    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }

    [WebMethod(EnableSession=true)]
    public static string showStock(string ItemID, string DeptLedNo)
    {
        DataTable dt = StockReports.GetDataTable("select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,st.IsExpirable from f_stock ST inner join f_itemmaster IM on ST.ItemID=IM.ItemID where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 and IM.ItemID ='" + ItemID + "' and st.DeptLedgerNo='" + DeptLedNo + "' AND st.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return null;
        }
    }
}
