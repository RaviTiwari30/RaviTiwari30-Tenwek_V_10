using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_RenewExpiryItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            lblMsg.Text = "";
            ddlStoreLoc.Items.AddRange(LoadItems(CreateStockMaster.LoadStoreName()));
            ddlStoreLoc.DataBind();
            if (Session["DeptLedgerNo"] != null)
                ViewState["CurDeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            else
                ViewState["CurDeptLedgerNo"] = "";
            if (Session["IsStore"] != null)
                ViewState["IsStore"] = Session["IsStore"].ToString();
            else
                ViewState["IsStore"] = "0";
            AllLoadData_Store.checkStoreRight(rblStoreType);
            rblStoreType_SelectedIndexChanged(this, new EventArgs());

            BindDepartment();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    public ListItem[] LoadItems(string[,] str)
    {
        try
        {
            ListItem[] Items = new ListItem[str.Length / 2];

            for (int i = 0; i < str.Length / 2; i++)
            {
                Items[i] = new ListItem(str[i, 0].ToString(), str[i, 1].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    protected void grdItems_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            DateTime oldExpDate = new DateTime();
            string ItemId = "", str = "";
            string stockID = ((Label)grdItems.Rows[e.RowIndex].FindControl("lblStockID")).Text;
            DateTime ExpDate = Util.GetDateTime(((TextBox)grdItems.Rows[e.RowIndex].FindControl("txtExpDate")).Text);
            DataTable dtExpDate = CreateStockMaster.GetMedExpDate(stockID);
            if (dtExpDate != null && dtExpDate.Rows.Count > 0)
            {
                oldExpDate = Util.GetDateTime(dtExpDate.Rows[0][0]);
                ItemId = dtExpDate.Rows[0][1].ToString();
            }
            string UserID = Session["ID"].ToString();
            DateTime ChangeDate = Util.GetDateTime(DateTime.Now);

            int Insert = CreateStockMaster.InsertIntoStockExpiry(stockID, ItemId, oldExpDate, ExpDate, UserID, ChangeDate, Tranx);
            if (Insert != 0)
                Tranx.Commit();
            else
                Tranx.Rollback();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

        grdItems.EditIndex = -1;
        BindItems();
    }

    protected void grdItems_RowEditing(object sender, GridViewEditEventArgs e)
    {
        grdItems.EditIndex = e.NewEditIndex;

        BindItems();
        ((TextBox)grdItems.Rows[e.NewEditIndex].FindControl("txtExpDate")).Attributes.Add("ReadOnly", "true");
        ((AjaxControlToolkit.CalendarExtender)grdItems.Rows[e.NewEditIndex].FindControl("ccExp")).StartDate = DateTime.Now;
    }

    protected void grdItems_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        grdItems.EditIndex = -1;
        BindItems();
    }

    private void BindItems()
    {
        DataTable dt = new DataTable();
        dt = GetExpiryItems(ddlStoreLoc.SelectedValue, Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd"), txtItemName.Text.Trim(), rbtnMedNonMed.SelectedValue, rbtType.SelectedValue, ViewState["CurDeptLedgerNo"].ToString());
        if (dt.Rows.Count > 0)
        {
            grdItems.DataSource = dt;
            grdItems.DataBind();
            if (chkisexpirable.Checked == false)
            {
                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            }
            lblMsg.Text = "";
        }
        else
        {
            if (chkisexpirable.Checked == false)
            {
                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            }
            grdItems.DataSource = null;
            grdItems.DataBind();
            lblMsg.Text = "No Item Found";
        }
    }

    protected void grdItems_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdItems.EditIndex = -1;

        grdItems.PageIndex = e.NewPageIndex;
        BindItems();
    }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        grdItems.EditIndex = -1;
        BindItems();
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = GetExpiryItemsReport(ddlStoreLoc.SelectedValue, Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd"), txtItemName.Text.Trim(), rbtnMedNonMed.SelectedValue, rbtType.SelectedValue, ViewState["CurDeptLedgerNo"].ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Item Expiry Report";
            Session["Period"] = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
            lblMsg.Text = "No Item Found";
    }

    private void BindDepartment()
    {
        DataTable dt = LoadCacheQuery.bindStoreDepartment();
        if (dt.Rows.Count > 0)
        {
            ddldepartment.DataSource = dt;
            ddldepartment.DataTextField = "ledgerName";
            ddldepartment.DataValueField = "ledgerNumber";
            ddldepartment.DataBind();
        }
    }

    public DataTable GetExpiryItems(string StoreLedNo, string DateFrom, string DateTo, string ItemName, string ItemType, string Filter, string department)
    {
        DataTable Items = new DataTable();

        StringBuilder sb = new StringBuilder();
        sb.Append(" Select st.StockID,st.ItemName,st.BatchNumber,date_format(st.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,");
        sb.Append(" st.InitialCount,(st.InitialCount-st.ReleasedCount)InHandQty,st.UnitPrice,lt.LedgerTransactionNo,(select LedgerName from f_ledgermaster where LedgerNumber = lt.LedgerNoCr)VendorName, ");
        sb.Append(" (select LedgerName from f_ledgermaster where LedgerNumber = st.DeptLedgerNo AND GroupID='DPT')DepartmentName   ");
        sb.Append(" from f_stock st INNER JOIN f_itemmaster im ON st.ItemID=im.ItemID INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=im.SubCategoryID ");
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID=scm.CategoryID INNER JOIN f_configrelation fcr ON fcr.CategoryID=cm.CategoryID left outer join f_ledgertransaction lt on st.LedgerTransactionNo = lt.LedgerTransactionNo");
        sb.Append(" where (st.InitialCount-st.ReleasedCount)>0 and St.IsPost = 1 AND st.StoreLedgerNo='" + rblStoreType.SelectedValue + "' And st.CentreID='" + Session["CentreID"].ToString() + "' ");
        if (chkisexpirable.Checked == true)
        {
            if (DateFrom != string.Empty)
                sb.Append(" and st.MedExpiryDate >= '" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "'");

            if (DateTo != string.Empty)
                sb.Append(" and st.MedExpiryDate <= '" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "'");
        }
        else
        {
            if (DateTo != string.Empty)
                sb.Append(" and st.MedExpiryDate <= '" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "'");
        }
        if (ItemName != string.Empty)
            sb.Append(" and st.ItemName like '" + ItemName + "%'");
        if (Filter != "ALL")
            sb.Append(" and st.TYPE ='" + Filter + "' ");
        if (department != "ALL")
        {
            sb.Append(" AND st.DeptLedgerNo='" + department + "'  ");
        }
        //sb.Append(" AND fcr.ConfigID= '" + ItemType + "' ");

        sb.Append("AND im.`IsExpirable`='YES' order by st.MedExpiryDate,st.ItemName");
        Items = StockReports.GetDataTable(sb.ToString());

        return Items;
    }

    public DataTable GetExpiryItemsReport(string StoreLedNo, string DateFrom, string DateTo, string ItemName, string ItemType, string Filter, string department)
    {
        DataTable Items = new DataTable();

        StringBuilder sb = new StringBuilder();
        sb.Append(" Select st.ItemName 'Item Name',st.BatchNumber 'Batch Number',date_format(st.MedExpiryDate,'%d-%b-%Y') 'Expiry Date',");
        sb.Append(" lt.LedgerTransactionNo 'GRN No',st.InitialCount 'Purchase Quantity',(st.InitialCount-st.ReleasedCount) 'Available Quantity',st.UnitPrice 'Unit Price',(select LedgerName from f_ledgermaster where LedgerNumber = lt.LedgerNoCr)'Supplier Name', ");
        sb.Append(" (select LedgerName from f_ledgermaster where LedgerNumber = st.DeptLedgerNo AND GroupID='DPT')'Department Name'   ");
        sb.Append(" from f_stock st INNER JOIN f_itemmaster im ON st.ItemID=im.ItemID INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=im.SubCategoryID INNER JOIN f_categorymaster cm ON cm.CategoryID=scm.CategoryID INNER JOIN f_configrelation fcr ON fcr.CategoryID=cm.CategoryID left outer join f_ledgertransaction lt on st.LedgerTransactionNo = lt.LedgerTransactionNo");
        sb.Append(" where (st.InitialCount-st.ReleasedCount)>0 and St.IsPost = 1 AND im.IsExpirable='YES' and st.StoreLedgerNo = '" + StoreLedNo + "' AND st.StoreLedgerNo='" + rblStoreType.SelectedValue + "' And st.CentreID='" + Session["CentreID"].ToString() + "' ");

        if (DateFrom != string.Empty)
            sb.Append(" and st.MedExpiryDate >= '" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "'");

        if (DateTo != string.Empty)
            sb.Append(" and st.MedExpiryDate <= '" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "'");

        if (ItemName != string.Empty)
            sb.Append(" and st.ItemName like '" + ItemName + "%'");
        if (Filter != "ALL")
            sb.Append(" and st.TYPE ='" + Filter + "' ");
        if (department != "ALL")
        {
            sb.Append(" AND st.DeptLedgerNo='" + department + "'  ");
        }
        sb.Append(" AND fcr.ConfigID= '" + ItemType + "' ");

        sb.Append(" order by st.MedExpiryDate,st.ItemName");
        Items = StockReports.GetDataTable(sb.ToString());

        return Items;
    }

    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnSelect.Enabled = true;
        btnReport.Enabled = true;
    }
}