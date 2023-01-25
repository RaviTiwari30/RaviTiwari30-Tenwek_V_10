using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using MySql.Data.MySqlClient;
public partial class Design_Laundry_DirectIssueLaundaryItem : System.Web.UI.Page
{
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
            LoadStock();
            ScriptManager1.SetFocus(ddlDept);
            txtSearch.Focus();

        }
    }
    #region LoadItems and Stock

    public void LoadStock()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(im.ItemID,'#',IFNULL(im.UnitType,''))ItemId,CONCAT(im.typename,' # (',im.TypeName,') # ', ");
        sb.Append("  SUM(s.InitialCount-s.ReleasedCount))itemname   FROM f_configrelation cf  ");
        sb.Append("   INNER JOIN f_subcategorymaster sc ON   cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im  ");
        sb.Append("   ON sc.SubCategoryID = im.SubCategoryID     INNER JOIN f_stock s ON s.ItemID = im.ItemID AND s.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "'  ");
        sb.Append("    WHERE cf.ConfigID=28 AND  s.InitialCount-s.ReleasedCount > 0 and s.ispost=1 GROUP BY im.ItemID    ");
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




    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(im.ItemID,'#',im.UnitType,'#',IFNULL(s.MajorUnit,''),'#',IFNULL(s.MinorUnit,''),'#',IFNULL(s.ConversionFactor,'1'))ItemId,CONCAT(im.typename,' # (',im.TypeName,') # ',SUM(s.InitialCount-s.ReleasedCount))itemname FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON  ");
        sb.Append(" cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im ON sc.SubCategoryID = im.SubCategoryID  ");
        sb.Append(" INNER JOIN f_stock s ON s.ItemID = im.ItemID AND s.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append(" WHERE cf.ConfigID=28 AND im.isLaundry=1 AND s.ispst=1 and s.InitialCount-s.ReleasedCount > 0  ");
        sb.Append(" GROUP BY im.ItemID ");
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
    private void BindDepartments()
    {

        DataView dv = LoadCacheQuery.bindStoreDepartment().DefaultView;
        dv.RowFilter = " LedgerNumber <> '" + ViewState["DeptLedgerNo"].ToString() + "' ";
        DataTable dt = dv.ToTable();
        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            lblMsg.Text = string.Empty;
            ddlDept.Items.Insert(0, "Select");


        }
        else
        {
            ddlDept.Items.Clear();
            //lblMsg.Text = "No Department Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM254','" + lblMsg.ClientID + "');", true);
        }
        string login = ViewState["LoginType"].ToString();
        int index = ddlDept.Items.IndexOf(ddlDept.Items.FindByText(ViewState["LoginType"].ToString()));
        if (index != -1)
        {
            ddlDept.Items[index].Selected = true;
            ddlDept.Items[index].Enabled = true;
        }
    }

    #endregion
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
                    DataRow[] drow = dt.Select("StockID = '" + stockID + "'  ");
                    if (drow.Length > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM035','" + lblMsg.ClientID + "');", true);
                        return false;
                    }
                }

                decimal TransferQty = 0, AvailQty = 0;
                if (((TextBox)row.FindControl("txtIssueQty")).Text.Trim() != string.Empty)
                    TransferQty = Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text);
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return false;
        }
        return true;
    }


    protected void btnAddItem_Click(object sender, EventArgs e)
    {

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
                    dr["UnitPrice"] = Util.GetDecimal(((Label)row.FindControl("lblUnitPrice")).Text);
                    dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;
                    decimal Qty = Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text);
                    dr["IssueQty"] = Qty;
                    dr["Qty"] = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
                    dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                    dr["Unit"] = ((Label)row.FindControl("lblUnitType")).Text;
                    dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;

                    //for MRP and Tax Calculation
                    decimal MRP = Util.GetDecimal(((Label)row.FindControl("lblMRP")).Text);
                    dr["TaxableMRP"] = MRP;
                    decimal TaxPer = Util.GetDecimal(((Label)row.FindControl("lblTax")).Text);
                    dr["Tax"] = TaxPer;
                    //decimal NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                    decimal NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                    decimal Discount = 0;
                    decimal DiscountedRate = NonTaxableRate;
                    decimal NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                    decimal Amount = NetRate * Qty;

                    dr["MRP"] = NonTaxableRate;
                    dr["Discount"] = 0;
                    dr["DiscountAmt"] = Discount * Qty;
                    dr["GrossAmount"] = Amount;
                    dr["MajorUnit"] = ((Label)row.FindControl("lblMajorUnit")).Text;
                    dr["MinorUnit"] = ((Label)row.FindControl("lblMinorUnit")).Text;
                    dr["ConversionFactor"] = ((Label)row.FindControl("lblConversionFactor")).Text;
                    dt.Rows.Add(dr);
                }
            }
            dt.AcceptChanges();
            ViewState["StockTransfer"] = dt;
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtSearch.Text = "";
            txtSearch.Focus();
            btnSave.Enabled = true;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlDept.SelectedIndex == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
            return;
        }
        DataTable dtItem = null;

        if (ViewState["StockTransfer"] != null)
        {
            dtItem = (DataTable)ViewState["StockTransfer"];
            if (dtItem.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                return;
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "')"));


            for (int i = 0; i < dtItem.Rows.Count; i++)
            {
                string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'";
                DataTable dtResult = MySqlHelper.ExecuteDataset(tranx, CommandType.Text, stt).Tables[0];

                Stock objStock = new Stock(tranx);
                objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objStock.InitialCount = Util.GetDecimal(dtItem.Rows[i]["IssueQty"]);
                objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                objStock.DeptLedgerNo = Util.GetString(ddlDept.SelectedValue);
                objStock.IsFree = 0;
                objStock.IsPost = 1;
                objStock.PostDate = DateTime.Now;
                objStock.MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                objStock.StockDate = DateTime.Now;
                objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                objStock.SubCategoryID = Util.GetString(dtResult.Rows[i]["SubCategoryID"]);
                objStock.UnitPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                objStock.IsCountable = 1;
                objStock.IsReturn = 0;
                objStock.FromDept = ViewState["DeptLedgerNo"].ToString();
                objStock.FromStockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                objStock.IndentNo = Util.GetString(txtIndent.Text.Trim());
                objStock.MedExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                objStock.StoreLedgerNo = "STO00001";
                objStock.UserID = ViewState["ID"].ToString();
                objStock.PostUserID = ViewState["ID"].ToString();
                objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                objStock.PurTaxAmt = Util.GetDecimal(dtResult.Rows[i]["PurTaxAmt"]);
                objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]);
                objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objStock.IpAddress = All_LoadData.IpAddress();

                string stokID = objStock.Insert();
                if (stokID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }
                Sales_Details ObjSales = new Sales_Details(tranx);
                ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjSales.LedgerNumber = Util.GetString(ddlDept.SelectedValue);
                ObjSales.DepartmentID = "STO00001";
                ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                ObjSales.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["IssueQty"]);
                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                ObjSales.Date = DateTime.Now;
                ObjSales.Time = DateTime.Now;
                ObjSales.IsReturn = 0;
                ObjSales.LedgerTransactionNo = "";
                ObjSales.TrasactionTypeID = 1;
                ObjSales.IsService = "NO";
                ObjSales.IndentNo = Util.GetString(txtIndent.Text.Trim());
                ObjSales.SalesNo = SalesNo;
                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                ObjSales.UserID = ViewState["ID"].ToString();
                ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                ObjSales.IpAddress = All_LoadData.IpAddress();
                string SalesID = ObjSales.Insert();
                if (SalesID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }
                //----Check Release Count in Stock Table---------------------
                string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetDecimal(dtItem.Rows[i]["IssueQty"]) + "),0,1)CHK from f_stock where stockID=" + Util.GetString(dtItem.Rows[i]["StockID"]);
                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(tranx, CommandType.Text, sql)) <= 0)
                {
                    tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }

                //---- Update Release Count in Stock Table---------------------
                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetDecimal(dtItem.Rows[i]["IssueQty"]) + " where StockID = " + Util.GetString(dtItem.Rows[i]["StockID"]) + "";

                int flag = Util.GetInt(MySqlHelperNEw.ExecuteNonQuery(tranx, CommandType.Text, strStock));

                if (flag == 0)
                {
                    tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }
            }
            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            if (chkPrint.Checked)
            {
                printIssueReport(Util.GetString(SalesNo));
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Save Successfully, Entry No. : " + SalesNo + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='DirectIssueLaundaryItem.aspx';", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }

    }
    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("SubCategoryID");
        dt.Columns.Add("MRP", typeof(decimal));
        dt.Columns.Add("TaxableMRP", typeof(decimal));
        dt.Columns.Add("Tax", typeof(decimal));
        dt.Columns.Add("UnitPrice", typeof(decimal));
        dt.Columns.Add("Qty", typeof(decimal));
        dt.Columns.Add("IssueQty", typeof(decimal));
        dt.Columns.Add("Discount", typeof(decimal));
        dt.Columns.Add("DiscountAmt", typeof(decimal));
        dt.Columns.Add("GrossAmount", typeof(decimal));
        dt.Columns.Add("Unit");
        dt.Columns.Add("MedExpiryDate");
        dt.Columns.Add("MajorUnit");
        dt.Columns.Add("MinorUnit");
        dt.Columns.Add("ConversionFactor");
        return dt;
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchItem();
        txtTransferQty.Text = "";
    }

    private void SearchItem()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("select t1.*,t2.tax from(select StockID,ItemID,ItemName,BatchNumber,SubCategoryID,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,");
        sb.Append(" round((InitialCount-ReleasedCount))AvailQty,UnitType,IFNULL(MajorUnit,'')MajorUnit,IFNULL(MinorUnit,'')MinorUnit,IFNULL(ConversionFactor,'1')ConversionFactor from f_stock where ItemID='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' and (InitialCount-ReleasedCount)>0 and");
        sb.Append(" Ispost=1  and DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "'  order by stockid)t1 left join (select sum(tc.perCentage)Tax,tc.StockID");
        sb.Append(" from f_taxchargedlist tc where tc.ItemID = '" + ListBox1.SelectedValue.Split('#').GetValue(0) + "'  group by tc.stockid)T2");
        sb.Append(" on t1.stockid = t2.stockid");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            decimal TranferQty = Util.GetInt(txtTransferQty.Text.Trim());
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                decimal availQty = Util.GetDecimal(dt.Rows[i]["AvailQty"]);
                if (TranferQty > availQty)
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = Util.GetString(dt.Rows[i]["AvailQty"]);
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    TranferQty = TranferQty - Util.GetDecimal(dt.Rows[i]["AvailQty"]);
                }
                else
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = TranferQty.ToString();
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    break;
                }
            }
            btnAddItem.Focus();
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
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
            //lblTotalAmount.Text = Util.GetString(dtItem.Compute("sum(Grossamount)", ""));
            ViewState["StockTransfer"] = dtItem;
        }
    }


    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //if (((Label)e.Row.FindControl("lblissterlize")).Text == "1")
            //{
            //    e.Row.BackColor = System.Drawing.Color.LightPink;
            //}
        }
    }
    [WebMethod]
    public static string showReturnQty(string ItemID, string DeptLedNo)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DATE_FORMAT(ReturnDate,'%d-%b-%Y')ReturnDate,SUM(ReturnQty)ReturnQty FROM laundry_recieve_stock WHERE itemID='" + ItemID + "' AND FromDept='" + DeptLedNo + "' " +
                      " AND TIMESTAMPDIFF(HOUR, ReturnDate,NOW())>=24 AND TIMESTAMPDIFF(HOUR, ReturnDate,NOW())<=90 "+
                      " AND Isreturn=1 GROUP BY DATE(ReturnDate)");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return null;
        }
    }
    protected void btnReprint_Click(object sender, EventArgs e)
    {
        if (txtIssueNo.Text == "")
        {
            lblMsg.Text = "Please Enter Issue No.";
            txtIssueNo.Focus();
            return;
        }
        printIssueReport(txtIssueNo.Text.Trim());

    }
    private void printIssueReport(string salesNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT (SELECT im.typename FROM f_itemmaster im WHERE im.itemid=sd.`ItemID`)ItemName,sd.`BatchNo`,sd.`SoldUnits` IssuedQty,sd.`PerUnitSellingPrice` MRP, ");
        sb.Append("  IFNULL(DATE_FORMAT(sd.`MedExpiryDate`,'%d-%b-%Y'),'')ExpiryDate,(SELECT lm.LedgerName FROM f_ledgermaster lm WHERE lm.LedgerNumber=sd.`LedgerNumber`)Issuedto, ");
        sb.Append("  (SELECT lm.LedgerName FROM f_ledgermaster lm WHERE lm.LedgerNumber=sd.`DeptLedgerNo`)IssuedFrom,DATE_FORMAT(sd.`Date`,'%d-%b-%Y')IssueDate, ");
        sb.Append("  (SELECT CONCAT(em.`Title`,' ',em.`Name`) FROM employee_master em WHERE em.`EmployeeID`=sd.`UserID`)IssuedBy ");
        sb.Append("  FROM f_salesdetails sd  WHERE `salesno`='" + salesNo + "' AND sd.`TrasactionTypeID`='1' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        if (dt.Rows.Count > 0)
        {
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"F:\DirectDepartmentIssue.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "DirectDepartmentIssue";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }
}