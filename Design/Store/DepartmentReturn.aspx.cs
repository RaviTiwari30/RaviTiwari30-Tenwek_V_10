using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_Store_DepartmentReturn : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            AllLoadData_Store.checkStoreRight(rblStoreType);
            rblStoreType_SelectedIndexChanged(this, new EventArgs());
            txtBarCode.Attributes.Add("onKeyPress", "doClick('" + btnBar.ClientID + "',event)");
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
        }
    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
        ScriptManager1.SetFocus(txtBarCode);      
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string SalesNo = SaveData();
        if (SalesNo != string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Department Return No.:'+'" + SalesNo + "');location.href='DepartmentReturn.aspx';", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ValidateItem())
        {
            DataTable dt = new DataTable();
            if (ViewState["ReturnItem"] != null)
            {
                dt = (DataTable)ViewState["ReturnItem"];
            }
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
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM240','" + lblMsg.ClientID + "');", true);
                        txtBarCode.Focus();
                        return;
                    }
                    else
                    {

                        DataRow dr = dt.NewRow();
                        //dr["DeptStockID"] = ((Label)row.FindControl("lblDeptStock")).Text;
                        dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                        dr["fromStockID"] = ((Label)row.FindControl("lblfromStockID")).Text;
                        dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                        dr["BatchNo"] = ((Label)row.FindControl("lblBatch")).Text;
                        dr["UnitPrice"] = ((Label)row.FindControl("lblPrice")).Text;
                        dr["SellingPrice"] = ((Label)row.FindControl("lblSellPrice")).Text;
                        dr["RetQty"] = ((TextBox)row.FindControl("txtReturn")).Text;
                        dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                        dr["MedExpiry"] = ((Label)row.FindControl("lblMedExpiry")).Text;
                        //GST Changes
                        dr["IGSTPercent"] = ((Label)row.FindControl("lblIGSTPercent")).Text;
                        dr["CGSTPercent"] = ((Label)row.FindControl("lblCGSTPercent")).Text;
                        dr["SGSTPercent"] = ((Label)row.FindControl("lblSGSTPercent")).Text;
                        dr["HSNCode"] = ((Label)row.FindControl("lblHSNCode")).Text;
                        dr["GSTType"] = ((Label)row.FindControl("lblGSTType")).Text;
                        dr["SaleTaxPer"] = ((Label)row.FindControl("lblSaleTaxPer")).Text;
                        dr["PurTaxPer"] = ((Label)row.FindControl("lblPurTaxPer")).Text;
                        
                        dt.Rows.Add(dr);
                    }
                }
            }
            dt.AcceptChanges();
            ViewState["ReturnItem"] = dt;
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            pnlSave.Visible = true; 
            txtBarCode.Text = string.Empty;
            txtBarCode.Focus();
            pnlInfo.Visible = false;
            ddlDept.Enabled = false;
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
                ViewState["ReturnItem"] = null;
                ddlDept.Enabled = true;
            }
        }
    }
    #endregion
    
    #region Data Binding
    private void BindDepartments()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' AND LedgerNumber IN (select DeptLedgerNo from f_stock WHERE fromDept = '" + ViewState["DeptLedgerNo"].ToString() + "' AND StoreLedgerNo='" + rblStoreType.SelectedValue + "' and CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " )";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            ddlDept.Items.Insert(0, new ListItem("Select","0"));
        }
        else
        {
            ddlDept.Items.Clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM254','" + lblMsg.ClientID + "');", true);
        }
    }
    private void BindItem()
    {
        string str = "SELECT distinct(st.ItemID),st.itemname FROM  f_stock st  WHERE (st.InitialCount - st.ReleasedCount)>0 AND st.DeptLedgerNo = '" + ddlDept.SelectedValue + "' AND fromDept='" + ViewState["DeptLedgerNo"].ToString() + "' AND StoreLedgerNo='" + rblStoreType.SelectedValue + "' and st.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  order by st.itemname ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlItem.DataSource = dt;
            ddlItem.DataTextField = "itemName";
            ddlItem.DataValueField = "ItemId";
            ddlItem.DataBind();
        }
        else
        {
            ddlItem.Items.Clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM249','" + lblMsg.ClientID + "');", true);
        }
    }
    private void Search()
    {
       
        if (rblStoreType.SelectedIndex < 0)
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            lblMsg.Text = "Please Select Store Type";
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
            return;
        }
        if (ddlDept.SelectedValue == "0")
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
            return;
        }
        if (ddlItem.SelectedItem == null)
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
            return;
        }
    
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT st.itemid,st.fromStockID,StockID,(st.InitialCount-st.ReleasedCount-st.PendingQty)AvailQty, ");
        sb.Append(" ST.ItemName,ST.BatchNumber,ST.UnitPrice,ST.MRP,DATE_FORMAT(st.PostDate,'%d-%b-%y') as Date,MedExpiryDate,st.IGSTPercent,st.CGSTPercent,st.SGSTPercent,IFNULL(st.HSNCode,'')HSNCode,IFNULL(st.GSTType,'')GSTType,SaleTaxPer,PurTaxPer ");
        sb.Append(" FROM f_stock st WHERE DeptLedgerNo = '" + ddlDept.SelectedValue + "' ");
        sb.Append(" AND itemId = '" + ddlItem.SelectedItem.Value + "' AND st.fromDept = '" + ViewState["DeptLedgerNo"].ToString() + "' and (st.InitialCount-st.ReleasedCount-st.PendingQty)>0 AND st.StoreLedgerNo='" + rblStoreType.SelectedValue + "' and st.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            lblMsg.Text = "";
            pnlInfo.Visible = true;
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM249','" + lblMsg.ClientID + "');", true);
            pnlInfo.Visible = false;
            pnlSave.Visible = false;
        }
    }
    private DataTable GetItem()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("DeptStockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("fromStockID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNo");
        dt.Columns.Add("UnitPrice");
        dt.Columns.Add("SellingPrice");
        dt.Columns.Add("RetQty");
        dt.Columns.Add("StockID");
        dt.Columns.Add("MedExpiry");
        dt.Columns.Add("IGSTPercent");
        dt.Columns.Add("CGSTPercent");
        dt.Columns.Add("SGSTPercent");
        dt.Columns.Add("HSNCode");
        dt.Columns.Add("GSTType");
        dt.Columns.Add("SaleTaxPer");
        dt.Columns.Add("PurTaxPer");
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
                float AvailQty = 0, RetQty = 0;

                AvailQty = Util.GetFloat(((Label)row.FindControl("lblAqty")).Text);
                if (((TextBox)row.FindControl("txtReturn")).Text.Trim() != string.Empty)
                    RetQty = Util.GetFloat(((TextBox)row.FindControl("txtReturn")).Text);
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                    return false;
                }
                if (AvailQty < RetQty)
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
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (ViewState["ReturnItem"] != null)
            {
                DataTable dtItem = (DataTable)ViewState["ReturnItem"];
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('2','" + rblStoreType.SelectedValue + "','" + Util.GetInt(Session["CentreID"].ToString()) + "')"));
                int SubStoreSalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('15','" + rblStoreType.SelectedValue + "','" + Util.GetInt(Session["CentreID"].ToString()) + "')"));

                for (int i = 0; i < dtItem.Rows.Count; i++)
                {


                    decimal MRP = Util.GetDecimal(dtItem.Rows[i]["SellingPrice"]);
                    decimal SaleTaxPer = Util.GetDecimal(dtItem.Rows[i]["SaleTaxPer"]);
                    decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);

                    decimal TaxablePurVATAmt = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]) * Util.GetDecimal(dtItem.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"])));
                    decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]) / 100;

                    Sales_Details ObjSales = new Sales_Details(Tranx);
                    ObjSales.LedgerNumber = ddlDept.SelectedValue;
                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjSales.DepartmentID = rblStoreType.SelectedValue;
                    ObjSales.StockID = Util.GetString(dtItem.Rows[i]["fromStockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["RetQty"]);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["SellingPrice"]);
                    ObjSales.TrasactionTypeID = 2;
                    ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    ObjSales.Naration = txtNarration.Text.Trim();
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.UserID = Session["ID"].ToString();
                    ObjSales.IsReturn = 1;
                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime((dtItem.Rows[i]["MedExpiry"]));
                    //GST Changes
                    decimal igstPercent = Util.GetDecimal(dtItem.Rows[i]["IGSTPercent"]);
                    decimal csgtPercent = Util.GetDecimal(dtItem.Rows[i]["CGSTPercent"]);
                    decimal sgstPercent = Util.GetDecimal(dtItem.Rows[i]["SGSTPercent"]);

                    decimal taxableAmt = (Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]) * 100 * Util.GetDecimal(dtItem.Rows[i]["RetQty"])) / (100 + igstPercent + csgtPercent + sgstPercent);
                    decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

                    ObjSales.IGSTPercent = igstPercent;
                    ObjSales.IGSTAmt = Util.GetDecimal(IGSTTaxAmount * (-1));
                    ObjSales.CGSTPercent = csgtPercent;
                    ObjSales.CGSTAmt = Util.GetDecimal(CGSTTaxAmount * (-1));
                    ObjSales.SGSTPercent = sgstPercent;
                    ObjSales.SGSTAmt = Util.GetDecimal(SGSTTaxAmount * (-1));
                    ObjSales.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
                    ObjSales.GSTType = Util.GetString(dtItem.Rows[i]["GSTType"]);
                    ObjSales.TaxPercent = SaleTaxPer;
                    ObjSales.TaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(dtItem.Rows[i]["RetQty"]);

                    ObjSales.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]);
                    ObjSales.PurTaxAmt = vatPuramt;

                    ObjSales.LedgerTransactionNo = "0";
                    ObjSales.ServiceItemID = "0";
                    ObjSales.TransactionID = "0";
                    string SalesID = ObjSales.Insert();
                    if (SalesID == string.Empty)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }

                    ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    ObjSales.SalesNo = SubStoreSalesNo;
                    ObjSales.LedgerNumber = ViewState["DeptLedgerNo"].ToString();
                    ObjSales.DeptLedgerNo = ddlDept.SelectedValue;
                    ObjSales.TrasactionTypeID = 15;
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime((dtItem.Rows[i]["MedExpiry"]));


                    ObjSales.IGSTPercent = igstPercent;
                    ObjSales.IGSTAmt = Util.GetDecimal(IGSTTaxAmount * (-1));
                    ObjSales.CGSTPercent = csgtPercent;
                    ObjSales.CGSTAmt = Util.GetDecimal(CGSTTaxAmount * (-1));
                    ObjSales.SGSTPercent = sgstPercent;
                    ObjSales.SGSTAmt = Util.GetDecimal(SGSTTaxAmount * (-1));
                    ObjSales.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
                    ObjSales.GSTType = Util.GetString(dtItem.Rows[i]["GSTType"]);
                    //
                    ObjSales.TaxPercent = SaleTaxPer;
                    ObjSales.TaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(dtItem.Rows[i]["RetQty"]);

                    ObjSales.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]);
                    ObjSales.PurTaxAmt = vatPuramt;

                    ObjSales.LedgerTransactionNo = "0";
                    ObjSales.ServiceItemID = "0";
                    ObjSales.TransactionID = "0";
                    string SubStoreSalesID = ObjSales.Insert();
                    if (SubStoreSalesID == string.Empty)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }


                    //string str = "SELECT if(InitialCount < (ReleasedCount+" + Util.GetFloat(dtItem.Rows[i]["RetQty"]) +
                    //    "),0,1)CHK FROM f_stock WHERE stockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'";
                    //if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                    //{
                    //    Tranx.Rollback();
                    //    return string.Empty;
                    //}
                    //str = "select if(0 > (ReleasedCount-" + Util.GetFloat(dtItem.Rows[i]["RetQty"]) +
                    //    "),0,1)CHK from f_stock where stockID='" + Util.GetString(dtItem.Rows[i]["fromStockID"]) + "'";
                    //if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                    //{
                    //    Tranx.Rollback();
                    //    return string.Empty;
                    //}

                    string strStock = "update f_stock set ReleasedCount=ReleasedCount - '" + Util.GetFloat(dtItem.Rows[i]["RetQty"]) + "' WHERE StockID = '" + Util.GetString(dtItem.Rows[i]["fromStockID"]) + "'";
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock) == 0)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }

                    string strStock1 = "update f_stock set ReleasedCount=ReleasedCount + '" + Util.GetFloat(dtItem.Rows[i]["RetQty"]) + "' WHERE StockID = '" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'  ";
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock1) == 0)
                    {
                        Tranx.Rollback();
                        return string.Empty;
                    }

                }
              
                Tranx.Commit();
                

                if (chkPrint.Checked)
                {
                    PrintReturn(SubStoreSalesNo.ToString());
                    chkPrint.Checked = false;

                }
                return SalesNo.ToString();

            }
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
        finally {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void PrintReturn(string SalesNo)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT st.ItemId,st.ItemName,st.BatchNumber,st.MedExpiryDate,sd.SoldUnits,sd.PerUnitBuyPrice,sd.salesno,sd.Date,sd.Time,");
        sb.Append(" (SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber='"+ ddlDept.SelectedValue +"')ReturnFrom, ");
        sb.Append(" (SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber='" + ViewState["DeptLedgerNo"].ToString() + "')ReturnTo,(SELECT NAME FROM employee_master WHERE EmployeeID='" + Session["ID"].ToString() + "')ReturnBy FROM"); 
        sb.Append(" f_salesdetails sd INNER JOIN f_stock st ON st.stockId = sd.stockId ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = sd.LedgerNumber WHERE sd.CentreID="+ Session["CentreID"].ToString() +" AND sd.salesno='" + SalesNo + "' and TrasactionTypeID=15 AND sd.IsReturn=1  ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        //ds.WriteXmlSchema(@"C:\DeptReturn.xml");

        Session["ds"] = ds;
        Session["ReportName"] = "DepartmentReturn";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
     }

     #endregion

    #region BarCode
    protected void btnBar_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select dm.ItemID,dm.DeptStockID,(dm.InitialCount-dm.RealeasedCount)AvailQty,st.stockID,");
        sb.Append(" ST.ItemName,ST.BatchNumber,ST.UnitPrice,ST.MRP,date_format(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate,st.SaleTaxPer,st.PurTaxPer");
        sb.Append(" from f_departmentwisestock dm inner join f_stock ST on dm.StockID=ST.StockID where st.StockID='LSHHI" + txtBarCode.Text.Trim() + "' ");
        sb.Append(" and dm.DeptID='" + ddlDept.SelectedValue + "' and (dm.InitialCount-dm.RealeasedCount)>0");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdItem.DataSource = dt;
            grdItem.DataBind();
            for (int i = 0; i < grdItem.Rows.Count; i++)
                ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
            grdItem.Focus();
            txtBarCode.Text = string.Empty;
            lblMsg.Text = string.Empty;
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtBarCode.Text = string.Empty;
            txtBarCode.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM249','" + lblMsg.ClientID + "');", true);
        }
    }
    #endregion
    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDepartments();

    }
}
