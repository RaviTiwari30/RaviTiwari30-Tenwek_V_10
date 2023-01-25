using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_DamageDeptTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UID"] = Session["ID"].ToString();
            ViewState["DeptLedNo"] = Session["DeptLedgerNo"].ToString();
            btnSave.Enabled = false;
            txtSearch.Focus();
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
            txtSearch.Focus();
            return;
        }
        if (Util.GetDecimal(txtTransferQty.Text.Trim()) <= 0)
        {
            lblMsg.Text = "Please Enter Quantity";
            txtTransferQty.Focus();
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty, ");
        sb.Append(" IM.SubCategoryID,date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,st.MajorUnit,st.MinorUnit,st.ConversionFactor,st.MajorMRP,st.TaxCalculateOn,  ");
        sb.Append(" st.IsBilled,st.Reusable,st.DiscPer,st.discAmt,st.PurTaxAmt,st.PurTaxPer,st.SaleTaxPer,st.SaleTaxAmt,st.Type,st.StoreLedgerNo,st.Rate,st.IsExpirable ");
        sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster  IM on ST.ItemID=IM.ItemID WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 AND ");
        sb.Append(" IM.ItemID ='" + ListBox1.SelectedItem.Value.Split('#')[0] + "' AND st.DeptLedgerNo='" + ViewState["DeptLedNo"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            float TranferQty = Util.GetFloat(txtTransferQty.Text.Trim());
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (TranferQty > Util.GetFloat(dt.Rows[i]["AvlQty"]))
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = Util.GetString(dt.Rows[i]["AvlQty"]);
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    TranferQty = TranferQty - Util.GetFloat(dt.Rows[i]["AvlQty"]);
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
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtSearch.Text = "";
            ScriptManager1.SetFocus(txtSearch);
        }
    }

    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,CONCAT(im.typename,' # (',sm.name,')')itemName FROM (SELECT ItemID FROM f_stock WHERE ");
        sb.Append(" (InitialCount - ReleasedCount) > 0 AND IsPost = 1 AND  DeptLedgerNo='" + ViewState["DeptLedNo"].ToString() + "'  ");
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
            txtSearch.Focus();
            return;
        }
        if (txtTransferQty.Text.Trim() == "" || Util.GetFloat(txtTransferQty.Text.Trim()) <= 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
            txtTransferQty.Focus();
            return;
        }
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
                    float UnitPrice = Util.GetFloat(((Label)row.FindControl("lblUnitPrice")).Text);
                    dr["UnitPrice"] = UnitPrice;
                    dr["SubCategory"] = ((Label)row.FindControl("lblSubCategory")).Text;
                    float Qty = Util.GetFloat(((TextBox)row.FindControl("txtIssueQty")).Text);
                    dr["IssueQty"] = Qty;
                    dr["Qty"] = Util.GetFloat(((Label)row.FindControl("lblAvailQty")).Text);
                    dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                    float Amount = Qty * UnitPrice;
                    dr["Amount"] = Amount;


                    dr["StoreLedgerNo"] = ((Label)row.FindControl("lblStoreLedgerNo")).Text;
                    dr["Rate"] = ((Label)row.FindControl("lblRate")).Text;
                    dr["MajorUnit"] = ((Label)row.FindControl("lblMajorUnit")).Text;
                    dr["MinorUnit"] = ((Label)row.FindControl("lblMinorUnit")).Text;
                    dr["ConversionFactor"] = ((Label)row.FindControl("lblConversionFactor")).Text;
                    dr["MajorMRP"] = ((Label)row.FindControl("lblMajorMRP")).Text;
                    dr["TaxCalculateOn"] = ((Label)row.FindControl("lblTaxCalculateOn")).Text;
                    dr["IsBilled"] = ((Label)row.FindControl("lblIsBilled")).Text;
                    dr["Reusable"] = ((Label)row.FindControl("lblReusable")).Text;
                    dr["DiscPer"] = ((Label)row.FindControl("lblDiscPer")).Text;
                    dr["discAmt"] = ((Label)row.FindControl("lbldiscAmt")).Text;
                    dr["PurTaxAmt"] = ((Label)row.FindControl("lblPurTaxAmt")).Text;
                    dr["PurTaxPer"] = ((Label)row.FindControl("lblPurTaxPer")).Text;
                    dr["SaleTaxPer"] = ((Label)row.FindControl("lblSaleTaxPer")).Text;
                    dr["SaleTaxAmt"] = ((Label)row.FindControl("lblSaleTaxAmt")).Text;
                    dr["Type"] = ((Label)row.FindControl("lblType")).Text;
                    dr["IsExpirable"] = Util.GetInt(((Label)row.FindControl("lblisExpirable")).Text);

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
            txtSearch.Text = "";
            txtTransferQty.Text = "";
            ScriptManager1.SetFocus(txtSearch);
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
            }
            else
            {
                rblStoreType.Enabled = true;
            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        DataTable dt = (DataTable)ViewState["StockTransfer"];
        for (int j = 0; j < dt.Rows.Count; j++)
        {
            if (((TextBox)gvIssueItem.Rows[j].FindControl("txtNarration")).Text.Trim() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM250','" + lblMsg.ClientID + "');", true);
                ((TextBox)gvIssueItem.Rows[j].FindControl("txtNarration")).Focus();
                return;
            }
        }
        int SalesNo = SaveData();
        if (SalesNo != 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM251','" + lblMsg.ClientID + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='DamageDeptTransfer.aspx';", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    }
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
        DataTable dt = StockReports.GetDataTable("SELECT ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate from f_stock ST inner join f_itemmaster IM on ST.ItemID=IM.ItemID where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 and IM.ItemID ='" + ListBox1.SelectedItem.Value.Split('#')[0] + "'");
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

        dt.Columns.Add("StoreLedgerNo");
        dt.Columns.Add("Rate");
        dt.Columns.Add("Type");
        dt.Columns.Add("IsBilled");
        dt.Columns.Add("Reusable");
        dt.Columns.Add("SaleTaxPer");
        dt.Columns.Add("SaleTaxAmt");
        dt.Columns.Add("PurTaxPer");
        dt.Columns.Add("PurTaxAmt");
        dt.Columns.Add("DiscPer");
        dt.Columns.Add("discAmt");
        dt.Columns.Add("MajorUnit");
        dt.Columns.Add("MinorUnit");
        dt.Columns.Add("ConversionFactor");
        dt.Columns.Add("MajorMRP");
        dt.Columns.Add("TaxCalculateOn");
        dt.Columns.Add("IsExpirable", typeof(int));
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
                        txtSearch.Focus();
                        return false;
                    }
                }

                float TransferQty = 0, AvailQty = 0;
                if (((TextBox)row.FindControl("txtIssueQty")).Text.Trim() != string.Empty && Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text.Trim()) > 0)
                    TransferQty = Util.GetFloat(((TextBox)row.FindControl("txtIssueQty")).Text);
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                    txtTransferQty.Focus();
                    return false;
                }

                AvailQty = Util.GetFloat(((Label)row.FindControl("lblAvailQty")).Text);
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
            string DepartmentID = "";
            if (rblStoreType.SelectedValue == "11")
                DepartmentID = "STO00001";
            else
                DepartmentID = "STO00002";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('1','" + DepartmentID + "','" + Session["CentreID"].ToString() + "')"));
                DataTable dtItem = (DataTable)ViewState["StockTransfer"];
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    Stock objStock = new Stock(Tranx);
                    objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objStock.InitialCount = Util.GetDecimal(dtItem.Rows[i]["IssueQty"]);
                    objStock.BatchNumber = Util.GetString(dtItem.Rows[i]["BatchNumber"]);
                    objStock.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    objStock.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]);
                    objStock.DeptLedgerNo = Util.GetString(Resources.Resource.StoreDamageDepartment);
                    objStock.IsFree = 0;
                    objStock.IsPost = 1;
                    objStock.PostDate = DateTime.Now;
                    objStock.MRP = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                    objStock.StockDate = DateTime.Now;
                    objStock.UnitPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                    objStock.IsCountable = 1;
                    objStock.IsReturn = 0;
                    objStock.FromDept = ViewState["DeptLedNo"].ToString();
                    objStock.IndentNo = Util.GetString("");
                    objStock.UserID = ViewState["UID"].ToString();
                    objStock.PostUserID = ViewState["UID"].ToString();
                    objStock.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategory"]);
                    objStock.RejectQty = Util.GetDouble(0);
                    objStock.Unit = Util.GetString(dtItem.Rows[i]["UnitType"].ToString());
                    objStock.FromStockID = Util.GetString(dtItem.Rows[i]["StockID"].ToString());
                    objStock.MedExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"].ToString());
                    objStock.StoreLedgerNo = Util.GetString(dtItem.Rows[i]["StoreLedgerNo"].ToString());
                    objStock.Rate = Util.GetDecimal(dtItem.Rows[i]["Rate"].ToString());
                    objStock.TYPE = Util.GetString(dtItem.Rows[i]["Type"].ToString());
                    objStock.IsBilled = Util.GetInt(dtItem.Rows[i]["IsBilled"].ToString());
                    objStock.Reusable = Util.GetInt(dtItem.Rows[i]["Reusable"].ToString());
                    objStock.SaleTaxPer = Util.GetDecimal(dtItem.Rows[i]["SaleTaxPer"].ToString());
                    objStock.SaleTaxAmt = Util.GetDecimal(dtItem.Rows[i]["SaleTaxAmt"].ToString());
                    objStock.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"].ToString());
                    objStock.PurTaxAmt = Util.GetDecimal(dtItem.Rows[i]["PurTaxAmt"].ToString());
                    objStock.DiscPer = Util.GetDecimal(dtItem.Rows[i]["DiscPer"].ToString());
                    objStock.DiscAmt = Util.GetDecimal(dtItem.Rows[i]["discAmt"].ToString());
                    objStock.MajorUnit = Util.GetString(dtItem.Rows[i]["MajorUnit"].ToString());
                    objStock.MinorUnit = Util.GetString(dtItem.Rows[i]["MinorUnit"].ToString());
                    objStock.ConversionFactor = Util.GetDecimal(dtItem.Rows[0]["ConversionFactor"].ToString());
                    objStock.MajorMRP = Util.GetDecimal(dtItem.Rows[i]["MajorMRP"].ToString());
                    objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objStock.taxCalculateOn = Util.GetString(dtItem.Rows[i]["TaxCalculateOn"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IsExpirable = Util.GetInt(dtItem.Rows[i]["IsExpirable"].ToString());
                    string stokID = objStock.Insert();
                    if (stokID == string.Empty)
                    {
                        Tranx.Rollback();
                        return 0;
                    }
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
                    ObjSales.TrasactionTypeID = 1;
                    ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    ObjSales.IsService = "NO";
                    ObjSales.IndentNo = "";
                    ObjSales.Naration = ((TextBox)gvIssueItem.Rows[i].FindControl("txtNarration")).Text;
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.UserID = ViewState["UID"].ToString();
                    ObjSales.DeptLedgerNo = ViewState["DeptLedNo"].ToString();
                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"].ToString());
                    ObjSales.TaxPercent = Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"].ToString());
                    ObjSales.TaxAmt = Util.GetDecimal(dtItem.Rows[i]["PurTaxAmt"].ToString());
                    ObjSales.DisPercent = Util.GetDecimal(dtItem.Rows[i]["DiscPer"].ToString());
                    ObjSales.DiscAmt = Util.GetDecimal(dtItem.Rows[i]["discAmt"].ToString());
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
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
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
}