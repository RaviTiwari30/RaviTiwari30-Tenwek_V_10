using System;
using System.Data;
using System.Drawing;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_CSSD_ReturnToDepatment : System.Web.UI.Page
{
    public void LoadStock()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT set_id AS ItemID,CONCAT(NAME,' # (','It Is A Set',') # ',1) itemname FROM cssd_f_set_master cfsm INNER JOIN f_stock fs ON cfsm.set_id =fs.SetID WHERE fs.IsSet=1 AND fs.DeptLedgerNo = '" + ViewState["DeptLedgerNo"] + "' AND fs.fromdept = 'lshhi116' AND (InitialCount - (PendingQty+ReleasedCount)) > 0 AND fs.FromStockID <> '' AND fs.ispost = 1");
        sb.Append("  UNION  SELECT   itemid,CONCAT(CAST(itemname AS CHAR),' # (',CAST(itemname AS CHAR),') #',0)    itemname  FROM f_stock st  WHERE DeptLedgerNo = '" + ViewState["DeptLedgerNo"] + "'  AND fromdept='lshhi116'  AND (InitialCount - (PendingQty+ReleasedCount)) > 0 AND st.FromStockID <> '' AND st.ispost = 1  GROUP BY itemname   ");

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
        lblMsg.Text = "";

        if (ValidateItems())
        {
            DataTable dt;
            if (ViewState["StockTransfer"] != null)
                dt = (DataTable)ViewState["StockTransfer"];
            else
                dt = GetItemDataTable();
            if (ViewState["SetItem"].ToString() == "0")
            {
                foreach (GridViewRow row in grdItem.Rows)
                {
                    if (((CheckBox)row.FindControl("chkSelect")).Checked)
                    {
                        DateTime expirydate = Util.GetDateTime(((Label)row.FindControl("lblExpiryDate")).Text);
                        DateTime currentdate = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"));
                        if (currentdate <= expirydate)
                        {
                        }
                        else
                        {
                            lblMsg.Text = "Medicine Expired";
                            return;
                        }
                        if (((Label)row.FindControl("lblIsSet")).Text == "0")
                        {
                            if (Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text).ToString() == "" || Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text).ToString() == "0")
                            {
                                lblMsg.Text = "Please Specify Quantity";
                                return;
                            }
                            DataRow dr = dt.NewRow();
                            dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                            dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                            dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                            dr["UnitPrice"] = Util.GetFloat(((Label)row.FindControl("lblUnitPrice")).Text);
                            float Qty = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);
                            dr["ReturnQty"] = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);

                            dr["Qty"] = ((Label)row.FindControl("lblAvailQty")).Text;

                            dr["Unit"] = ((Label)row.FindControl("lblUnitType")).Text;
                            dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                            dr["StockID"] = ((Label)row.FindControl("lblStockId")).Text;
                            dr["IsSet"] = 0;
                            dr["FromStockID"] = ((Label)row.FindControl("lblFromStockID")).Text;
                            dr["SetStockID"] = ((Label)row.FindControl("lblSetStockID")).Text;
                            dr["SetID"] = "";
                            dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;

                            //for MRP and Tax Calculation
                            float MRP = Util.GetFloat(((Label)row.FindControl("lblMRP")).Text);
                            dr["TaxableMRP"] = MRP;
                            float TaxPer = 0.00f;
                            dr["Tax"] = TaxPer;
                            //float NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                            float NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                            float Discount = 0;
                            float DiscountedRate = NonTaxableRate;
                            float NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                            float Amount = NetRate * Qty;

                            dr["MRP"] = NonTaxableRate;
                            dr["Discount"] = 0;
                            dr["DiscountAmt"] = Discount * Qty;
                            dr["GrossAmount"] = Amount;

                            dt.Rows.Add(dr);
                        }
                        else
                        {
                            DataRow dr = dt.NewRow();
                            dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                            dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                            dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                            dr["UnitPrice"] = Util.GetFloat(((Label)row.FindControl("lblUnitPrice")).Text);

                            dr["ReturnQty"] = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);
                            dr["Qty"] = ((Label)row.FindControl("lblAvailQty")).Text;

                            dr["Unit"] = ((Label)row.FindControl("lblUnitType")).Text;
                            dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                            dr["StockID"] = ((Label)row.FindControl("lblStockId")).Text;
                            dr["IsSet"] = 0;
                            dr["FromStockID"] = ((Label)row.FindControl("lblFromStockID")).Text;
                            dr["SetStockID"] = ((Label)row.FindControl("lblSetStockID")).Text;
                            float Qty = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);
                            dr["SetID"] = "";
                            dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;

                            //for MRP and Tax Calculation
                            float MRP = Util.GetFloat(((Label)row.FindControl("lblMRP")).Text);
                            dr["TaxableMRP"] = MRP;
                            float TaxPer = 0.00f;
                            dr["Tax"] = TaxPer;
                            //float NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                            float NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                            float Discount = 0;
                            float DiscountedRate = NonTaxableRate;
                            float NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                            float Amount = NetRate * Qty;

                            dr["MRP"] = NonTaxableRate;
                            dr["Discount"] = 0;
                            dr["DiscountAmt"] = Discount * Qty;
                            dr["GrossAmount"] = Amount;
                            dt.Rows.Add(dr);
                        }
                    }
                }
            }
            else
            {
                foreach (GridViewRow row in grdSetItems.Rows)
                {
                    if (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text) > 0)
                    {
                        if (Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text.Split('$')[0]) >= Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text))
                        {
                            DataRow dr = dt.NewRow();
                            dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                            dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                            dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                            dr["UnitPrice"] = Util.GetFloat(((Label)row.FindControl("lblUnitPrice")).Text);
                            dr["ReturnQty"] = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);

                            dr["Qty"] = ((Label)row.FindControl("lblAvailQty")).Text.Split('$')[0];
                            dr["Unit"] = ((Label)row.FindControl("lblUnitType")).Text;
                            dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                            dr["StockID"] = ((Label)row.FindControl("lblStockId")).Text.Split('$')[0];
                            dr["IsSet"] = 0;
                            dr["FromStockID"] = ((Label)row.FindControl("lblFromStockID")).Text;
                            dr["SetStockID"] = ((Label)row.FindControl("lblSetStockID")).Text;
                            float Qty = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);
                            dr["SetID"] = "";
                            dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;

                            //for MRP and Tax Calculation
                            float MRP = Util.GetFloat(((Label)row.FindControl("lblMRP")).Text);
                            dr["TaxableMRP"] = MRP;
                            float TaxPer = 0.00f;
                            dr["Tax"] = TaxPer;
                            //float NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                            float NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                            float Discount = 0;
                            float DiscountedRate = NonTaxableRate;
                            float NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                            float Amount = NetRate * Qty;

                            dr["MRP"] = NonTaxableRate;
                            dr["Discount"] = 0;
                            dr["DiscountAmt"] = Discount * Qty;
                            dr["GrossAmount"] = Amount;
                            dt.Rows.Add(dr);
                        }
                        else
                        {
                            decimal AvQty = 0;
                            int StockIDLength = Util.GetInt((((Label)row.FindControl("lblStockId")).Text).ToString().Split('$').Length);
                            int AvQtyLength = Util.GetInt((((Label)row.FindControl("lblAvailQty")).Text).ToString().Split('$').Length);
                            decimal ReturnQty = 0; decimal TotalAvQty = 0; decimal RemainingQty = 0;
                            decimal StQty = Util.GetDecimal(((Label)row.FindControl("lblStockQty")).Text);

                            for (int i = 0; i < AvQtyLength; i++)
                            {
                                AvQty = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text.Split('$')[i]);
                                TotalAvQty += AvQty;
                                decimal RemainQty = (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text)) - (Util.GetDecimal(TotalAvQty));
                                if (RemainQty > 0)
                                {
                                    ReturnQty = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text.Split('$')[i]);
                                }
                                else
                                {
                                    ReturnQty = TotalAvQty - (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text));
                                    if (RemainingQty < ReturnQty)
                                    {
                                        ReturnQty = RemainingQty;
                                    }
                                    else if (RemainingQty > ReturnQty)
                                    {
                                        ReturnQty = RemainingQty;
                                    }
                                }
                                RemainingQty = (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text)) - TotalAvQty;

                                DataRow dr = dt.NewRow();
                                dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                                dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                                dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                                dr["UnitPrice"] = Util.GetFloat(((Label)row.FindControl("lblUnitPrice")).Text);
                                dr["ReturnQty"] = ReturnQty;
                                dr["Qty"] = ReturnQty;

                                dr["Unit"] = ((Label)row.FindControl("lblUnitType")).Text;
                                dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                                dr["StockID"] = ((Label)row.FindControl("lblStockId")).Text.Split('$')[i];
                                dr["IsSet"] = 0;
                                dr["FromStockID"] = ((Label)row.FindControl("lblFromStockID")).Text;
                                dr["SetStockID"] = ((Label)row.FindControl("lblSetStockID")).Text;
                                float Qty = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);
                                dr["SetID"] = "";
                                dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;

                                //for MRP and Tax Calculation
                                float MRP = Util.GetFloat(((Label)row.FindControl("lblMRP")).Text);
                                dr["TaxableMRP"] = MRP;
                                float TaxPer = 0.00f;
                                dr["Tax"] = TaxPer;
                                //float NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                                float NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                                float Discount = 0;
                                float DiscountedRate = NonTaxableRate;
                                float NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                                float Amount = NetRate * Qty;

                                dr["MRP"] = NonTaxableRate;
                                dr["Discount"] = 0;
                                dr["DiscountAmt"] = Discount * Qty;
                                dr["GrossAmount"] = Amount;
                                dt.Rows.Add(dr);

                                if (RemainQty <= 0)
                                {
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            grdSetItems.DataSource = null;
            grdSetItems.DataBind();

            dt.AcceptChanges();
            ViewState["StockTransfer"] = dt;
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            //lblTotalAmount.Text = Util.GetString(dt.Compute("sum(GrossAmount)", ""));
            txtSearch.Text = "";
            btnAddItem.Visible = false;
            txtSearch.Focus();
            if (dt.Rows.Count > 0)
                btnSave.Visible = true;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        SaveData();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (ListBox1.SelectedValue != "")
        {
            lblMsg.Text = "";
            if (ListBox1.SelectedItem.Text.Trim().Split('#')[2].ToString().Trim() == "0")
            {
                SearchItem();
            }
            else
            {
                SearchSetItems();
            }
        }
        else
        {
            lblMsg.Text = "Please Select Item";
            return;
        }
    }

    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblAvailQty")).Text == "0")
            {
                ((CheckBox)e.Row.FindControl("chkSelect")).Visible = false;
            }
            else
            {
                ((CheckBox)e.Row.FindControl("chkSelect")).Visible = true;
            }
        }
    }

    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["StockTransfer"];
            dtItem.Rows[args].Delete();
            grdItemDetails.DataSource = dtItem;
            grdItemDetails.DataBind();
            dtItem.AcceptChanges();
            ViewState["StockTransfer"] = dtItem;
            if (dtItem.Rows.Count == 0)
            {
                btnSave.Visible = false;
            }
        }
    }

    protected void grdSetItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Add")
        {
            GridViewRow row = (GridViewRow)(((Control)e.CommandSource).NamingContainer);
            foreach (GridViewRow row1 in grdSetItems.Rows)
            {
                row1.BackColor = ColorTranslator.FromHtml("#F5F5F5");
            }
            row.BackColor = ColorTranslator.FromHtml("#A1DCF2");
            string Setid = e.CommandArgument.ToString().Split('#')[0];
            string ItemId = e.CommandArgument.ToString().Split('#')[1];
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DATE_FORMAT(st.MedExpiryDate, '%d-%b-%Y')ExpiryDate,st.ItemName,st.BatchNumber,st.itemid, IFNULL(st.UnitType, '0') UnitType,1 IsSet,IFNULL(st.MRP, '0') Mrp,st.SubCategoryID,IFNULL(st.MedExpiryDate, '') MedExpiryDate, IFNULL(CAST((st.InitialCount - st.ReleasedCount - st.PendingQty) AS DECIMAL(10,2)),'0') AvailQty,IFNULL(st.UnitPrice, '') UnitPrice,IFNULL(st.StockID, '') StockID, IFNULL(st.FromStockID, '') FromStockID  ");
            sb.Append("    FROM cssd_f_set_master cfsm  INNER JOIN cssd_set_itemdetail csid ON csid.SetID = cfsm.Set_ID  LEFT JOIN f_stock st ON st.ItemID = csid.ItemID");
            sb.Append("    AND st.DeptLedgerNo = '" + ViewState["DeptLedgerNo"] + "'  AND ( st.InitialCount - st.ReleasedCount - st.PendingQty ) > 0 WHERE cfsm.set_id = '" + Setid + "'     AND csid.IsActive=1 AND st.ItemID='" + ItemId + " '");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                grdItem.DataSource = dt;
                grdItem.DataBind();
                btnAddItem.Focus();
            }
            else
            {
                lblMsg.Text = "Item Quantity Not Available";
                grdItem.DataSource = null;
                grdItem.DataBind();
            }
        }
    }

    protected void grdSetItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            dynamic StockQty = ((Label)e.Row.FindControl("lblStockQty")).Text;
            if (StockQty == "0")
            {
                ((TextBox)e.Row.FindControl("txtReturnQty")).Enabled = false;
            }
        }
    }

    protected void grdSetItems_SelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (GridViewRow row in grdSetItems.Rows)
        {
            if (row.RowIndex == grdSetItems.SelectedIndex)
            {
                row.BackColor = ColorTranslator.FromHtml("#A1DCF2");
            }
            else
            {
                row.BackColor = ColorTranslator.FromHtml("#FFFFFF");
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            ViewState["LoginType"] = Session["LoginType"].ToString();

            ScriptManager1.SetFocus(ddlDept);
            BindDepartments();
            //BindItem();
            //new changes vipin
            LoadStock();
            ScriptManager1.SetFocus(ddlDept);
            txtSearch.Focus();
        }
    }

    private void BindDepartments()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' and LedgerNumber != '" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            lblMsg.Text = string.Empty;
            ddlDept.Items.Insert(0, "Select");
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue("LSHHI116"));
            ddlDept.Enabled = false;
            //ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue("LSHHI457"));
            //  ddlDept.Enabled = false;
        }
        else
        {
            ddlDept.Items.Clear();
            lblMsg.Text = "No Department Found";
        }

        int index = ddlDept.Items.IndexOf(ddlDept.Items.FindByText(ViewState["LoginType"].ToString()));
        if (index != -1)
        {
            ddlDept.Items[index].Selected = true;
            ddlDept.Items[index].Enabled = false;
        }
    }

    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");

        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("TaxableMRP", typeof(float));
        dt.Columns.Add("Tax", typeof(float));
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("ReturnQty", typeof(float));
        dt.Columns.Add("Discount", typeof(float));
        dt.Columns.Add("DiscountAmt", typeof(float));
        dt.Columns.Add("GrossAmount", typeof(float));
        dt.Columns.Add("Unit");
        dt.Columns.Add("MedExpiryDate");
        dt.Columns.Add("IsSet");
        dt.Columns.Add("SetStockID");
        dt.Columns.Add("SetID");
        dt.Columns.Add("StockID");
        dt.Columns.Add("FromStockID");
        dt.Columns.Add("SubCategoryID");

        return dt;
    }

    private void SaveData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if (ViewState["StockTransfer"] != null)
        {
            try
            {
                DataTable dtItem = (DataTable)ViewState["StockTransfer"];


                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.MedicalStoreID + "'," + Util.GetInt(Session["CentreID"].ToString()) + ")"));

                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    Sales_Details ObjSales = new Sales_Details(Tranx);
                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjSales.LedgerNumber = ddlDept.SelectedItem.Value;
                    ObjSales.DepartmentID = "STO00001";
                    ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    ObjSales.SoldUnits = Util.GetFloat(dtItem.Rows[i]["ReturnQty"]);
                    ObjSales.PerUnitBuyPrice = Util.GetFloat(dtItem.Rows[i]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetFloat(dtItem.Rows[i]["MRP"]);
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.IsReturn = 0;
                    ObjSales.LedgerTransactionNo = "";
                    ObjSales.TrasactionTypeID = 1;
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    ObjSales.UserID = ViewState["ID"].ToString();
                    ObjSales.CentreID = Util.GetInt( Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    string SalesID = ObjSales.Insert();
                    if (SalesID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";

                        return;
                    }

                    Stock objStock = new Stock(Tranx);
                    objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objStock.InitialCount = Util.GetFloat(dtItem.Rows[i]["ReturnQty"]);
                    objStock.BatchNumber = Util.GetString(dtItem.Rows[i]["BatchNumber"]);
                    objStock.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    objStock.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]);
                    objStock.DeptLedgerNo = ddlDept.SelectedItem.Value;
                    objStock.IsFree = 0;
                    objStock.IsPost = 1;
                    objStock.MRP = Util.GetFloat(dtItem.Rows[i]["MRP"]);
                    objStock.StockDate = DateTime.Now;
                    objStock.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);

                    objStock.UnitPrice = Util.GetFloat(dtItem.Rows[i]["UnitPrice"]);
                    objStock.IsCountable = 1;
                    objStock.IsReturn = 0;
                    objStock.FromDept = ViewState["DeptLedgerNo"].ToString();
                    objStock.FromStockID = Util.GetString(dtItem.Rows[i]["StockID"]);

                    objStock.MedExpiryDate = Util.GetDateTime(dtItem.Rows[i]["MedExpiryDate"]);
                    objStock.RejectQty = 0;
                    objStock.StoreLedgerNo = "STO00001";
                    objStock.UserID = ViewState["ID"].ToString();
                    objStock.SetStockID = Util.GetString(dtItem.Rows[i]["SetStockID"]);
                    objStock.IsSet = Util.GetInt(dtItem.Rows[i]["IsSet"]);
                    objStock.SetID = Util.GetInt(dtItem.Rows[i]["SetID"]);
                    objStock.IsSterlize = 0;
                    objStock.PostDate = DateTime.Now;
                    objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    string stokID = objStock.Insert();

                    if (stokID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";
                        return;
                    }
                    //----Check Release Count in Stock Table---------------------
                    string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(dtItem.Rows[i]["ReturnQty"]) + "),0,1)CHK from f_stock where stockID=" + Util.GetString(dtItem.Rows[i]["StockID"]);
                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";
                        return;
                    }

                    //---- Update Release Count in Stock Table---------------------
                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(dtItem.Rows[i]["ReturnQty"]) + " where StockID = " + Util.GetString(dtItem.Rows[i]["StockID"]) + "";

                    int flag = Util.GetInt(MySqlHelperNEw.ExecuteNonQuery(Tranx, CommandType.Text, strStock));

                    if (flag == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";
                        return;
                    }
                }
                Tranx.Commit();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Save Successfully, Entry No. : " + SalesNo + "');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='ReturnToDepatment.aspx';", true);
            }
            catch (Exception ex)
            {
                Tranx.Rollback();

                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                lblMsg.Text = "Error ..";
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    private void SearchItem()
    {
        if (ListBox1.SelectedIndex != -1)
        {
            string value = ListBox1.SelectedItem.Text.Split('#')[2].ToString().Trim();
            lblMsg.Text = "";
            StringBuilder sb = new StringBuilder();
            if (ListBox1.SelectedItem.Text.Trim().Split('#')[2].ToString().Trim() == "0")
            {
                sb.Append("SELECT  t1.* FROM (SELECT ''  SetStockID, DATE_FORMAT(s.MedExpiryDate, '%d-%b-%Y')ExpiryDate,s.FromStockID,s.StockID,s.ItemID,s.ItemName,s.BatchNumber,s.SubCategoryID,s.UnitPrice,s.MRP,CAST((s.InitialCount-s.ReleasedCount-s.PendingQty)AS DECIMAL(10,2)) AvailQty,DATE_FORMAT(s.MedExpiryDate,'%d-%b-%Y')    MedExpiryDate,s.UnitType,0  IsSet,");
                sb.Append("    (SELECT LedgerName   FROM f_ledgermaster  WHERE LedgerNumber = s.fromdept AND GroupId = 'DPT')    FromDept FROM f_stock s");
                sb.Append("  WHERE s.ItemID = '" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' AND (s.InitialCount-s.ReleasedCount)>0  AND Ispost = 1   AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"] + "'   AND fromdept='lshhi116'");
                sb.Append("ORDER BY s.stockid) t1 ");
                grdSetItems.DataSource = null;
                grdSetItems.DataBind();
            }
            // final chaka chak query
            else
            {
                sb.Append("SELECT DATE_FORMAT(st.MedExpiryDate, '%d-%b-%Y')ExpiryDate,st.ItemName,st.BatchNumber,st.itemid, IFNULL(st.UnitType, '0') UnitType,1 IsSet,IFNULL(st.MRP, '0') Mrp,st.SubCategoryID,IFNULL(st.MedExpiryDate, '') MedExpiryDate, IFNULL(CAST((st.InitialCount - st.ReleasedCount - st.PendingQty) AS DECIMAL(10,2)),'0') AvailQty,IFNULL(st.UnitPrice, '') UnitPrice,IFNULL(st.StockID, '') StockID, IFNULL(st.FromStockID, '') FromStockID  ");
                sb.Append("    FROM cssd_f_set_master cfsm  INNER JOIN cssd_set_itemdetail csid ON csid.SetID = cfsm.Set_ID  LEFT JOIN f_stock st ON st.ItemID = csid.ItemID");
                sb.Append("    AND st.DeptLedgerNo = '" + ViewState["DeptLedgerNo"] + "'  AND ( st.InitialCount - st.ReleasedCount - st.PendingQty ) > 0 WHERE cfsm.set_id = '" + ListBox1.SelectedValue + "'     AND csid.IsActive=1");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                grdItem.DataSource = dt;
                grdItem.DataBind();
                btnAddItem.Focus();
                ViewState["SetItem"] = 0;
                btnAddItem.Visible = true;
                btnSave.Visible = false;
            }
            else
            {
                lblMsg.Text = "Item Quantity Not Available";
                grdItem.DataSource = null;
                grdItem.DataBind();
                btnAddItem.Visible = false;
            }
        }
    }

    private void SearchSetItems()
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT csid.SetName,csid.SetID,csid.ItemID,csid.Quantity,csid.ItemName,IFNULL(st.Qty,'0')StockQty,StockID, ");
        sb1.Append(" SubCategoryID,BatchNumber,IFNULL(UnitType, '0') UnitType,1 IsSet,IFNULL(st.MRP, '0')MRP,IFNULL(MedExpiryDate, '') MedExpiryDate, ");
        sb1.Append(" IFNULL(st.UnitPrice, '0')UnitPrice,IFNULL(st.FromStockID, '') FromStockID, IFNULL(AvailQty,0)AvailQty,IF(IFNULL(csid.Quantity,0)>IFNULL(st.Qty,0),IFNULL(st.Qty,0),IFNULL(csid.Quantity,0))ReturnQty ");
        sb1.Append(" FROM cssd_f_set_master cfsm ");
        sb1.Append("   INNER JOIN cssd_set_itemdetail csid ON csid.SetID=cfsm.Set_ID ");
        sb1.Append(" LEFT JOIN (SELECT SUM(InitialCount-ReleasedCount) ");
        sb1.Append(" Qty,ItemID,CAST(GROUP_CONCAT(StockID ORDER BY StockID SEPARATOR '$') AS CHAR)StockID,SubCategoryID,BatchNumber, ");
        sb1.Append(" MRP,MedExpiryDate,UnitPrice,FromStockID,InitialCount,ReleasedCount,PendingQty,UnitType, ");
        sb1.Append(" CAST(GROUP_CONCAT((InitialCount - ReleasedCount) ORDER BY StockID SEPARATOR '$') AS CHAR)AvailQty ");
        sb1.Append("   FROM f_stock WHERE IsPost=1 AND (InitialCount-ReleasedCount)>0  AND DeptLedgerNo = '" + ViewState["DeptLedgerNo"] + "' ");
        sb1.Append(" GROUP BY ItemID)st ON st.itemID = csid.ItemID  ");
        sb1.Append("   WHERE cfsm.set_id='" + ListBox1.SelectedValue + "'   AND csid.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb1.ToString());
        if (dt.Rows.Count > 0)
        {
            grdSetItems.DataSource = dt;
            grdSetItems.DataBind();
            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
            ViewState["SetItem"] = 1;
            ViewState["StockTransfer"] = null;
            btnAddItem.Visible = true;
            btnSave.Visible = false;
        }
    }

    private bool ValidateItems()
    {
        DataTable dt = null;
        if (ViewState["StockTransfer"] != null)
            dt = (DataTable)ViewState["StockTransfer"];
        if (ViewState["SetItem"].ToString() == "1")
        {
            if (dt != null)
            {
                lblMsg.Text = "Please Search Items";
                return false;
            }
            foreach (GridViewRow gr in grdSetItems.Rows)
            {
                if (Util.GetInt(((TextBox)gr.FindControl("txtReturnQty")).Text) > 0)
                {
                    decimal ReturnQty = Util.GetDecimal(((Label)gr.FindControl("lblReturnQty")).Text);
                    decimal Qty = Util.GetDecimal(((TextBox)gr.FindControl("txtReturnQty")).Text);
                    if (ReturnQty < Qty)
                    {
                        lblMsg.Text = "Please Return Valid Return Qty.";
                        return false;
                    }
                }
            }
            lblMsg.Text = "";
            return true;
        }

        bool status = true;
        int chkvalue = 0;

        foreach (GridViewRow row in grdItem.Rows)
        {
            if (ddlDept.SelectedItem.Text != "Select")
            {
                status = false;
            }
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    string stockID = ((Label)row.FindControl("lblStockId")).Text;
                    string IsSet = ((Label)row.FindControl("lblIsSet")).Text;

                    DataRow[] drow = dt.Select("StockID = '" + stockID + "' ");
                    if (drow.Length > 0)
                    {
                        lblMsg.Text = "Item Already Selected";
                        return false;
                    }
                }

                float TransferQty = 0, AvailQty = 0;
                string value = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text).ToString();
                if (value != string.Empty)
                    TransferQty = Util.GetFloat(((TextBox)row.FindControl("txtReturnQty")).Text);
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM34','" + lblMsg.ClientID + "');", true);
                    return false;
                }
                if (TransferQty == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM249','" + lblMsg.ClientID + "');", true);
                    ((TextBox)row.FindControl("txtIssueQty")).Focus();
                    return false;
                }
                AvailQty = Util.GetFloat(((Label)row.FindControl("lblAvailQty")).Text);
                if (TransferQty > AvailQty)
                {
                    lblMsg.Text = "Requested Quantity is not Available";
                    return false;
                }
            }
        }

        if (status)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
            return false;
        }
        foreach (GridViewRow row in grdItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                chkvalue = chkvalue + 1;
            }
        }
        if (chkvalue == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return false;
        }
        lblMsg.Text = "";
        return true;
        
    }
}