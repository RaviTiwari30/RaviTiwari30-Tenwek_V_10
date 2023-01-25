using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mortuary_Mortuary_Medicine : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["CorpseID"] = Request.QueryString["CorpseID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["UID"] = Session["ID"].ToString();
            ViewState["DeptLedNo"] = Session["DeptLedgerNo"].ToString();

            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetCorpseReleasedStatus(ViewState["TransactionID"].ToString());
            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["IsReleased"].ToString() == "1")
                {
                    string Msg = "Corpse is Already Released on " + dtDischarge.Rows[0]["ReleasedDateTime"].ToString() + " . No Medicines can be possible...";
                    Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
                }
            }

            BindItem();
            btnSave.Enabled = false;
            txtSearch.Focus();
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
        string str = "select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType from f_stock ST inner join f_itemmaster IM on ST.ItemID=IM.ItemID where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 and IM.ItemID ='" + ListBox1.SelectedItem.Value.Split('#')[0] + "' and st.DeptLedgerNo='" + ViewState["DeptLedNo"].ToString() + "'";
        DataTable dt = StockReports.GetDataTable(str);
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
        string str = " select im.ItemID,CONCAT(im.typename,' # (',sm.name,')')itemname from (select ItemID from f_stock where (InitialCount - ReleasedCount) > 0 and IsPost = 1 and  DeptLedgerNo='" + ViewState["DeptLedNo"].ToString() + "' AND CentreID='" + Session["CentreID"].ToString() + "' group by ItemID)t1 inner join f_itemmaster im on t1.itemid = im.ItemID inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID inner join f_categorymaster cm on cm.categoryID=sm.categoryid inner join f_configrelation cf on cf.CategoryID=cm.CategoryID where cf.ConfigID='11' order by ItemName";
        DataTable dt = StockReports.GetDataTable(str);
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
            gvIssueItem.DataSource = null;
            gvIssueItem.DataBind();
            btnSave.Enabled = false;
            ViewState["StockTransfer"] = null;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    }
    #endregion

    private DataTable PrintItemIssueReport(string saleno)
    {
        string str = " select IndentNo,(select TypeName from f_itemmaster where ItemID=sale.ItemID)as ItemName, " +
        "    (select LedgerName from f_ledgermaster where LedgerNumber=sale.LedgerNumber)issueDepart, " +
        "    (select LedgerName from f_ledgermaster where LedgerNumber=sale.DepartmentID)Store, " +
        "    (select UnitType from f_itemmaster where ItemID=sale.ItemID)as UnitType," +
        "    SalesID,SoldUnits,Date_format(Date(Date),'%d %b %y')Date,TIME_FORMAT(Time(Date),'%r')Time,Naration,salesno from f_NMsalesdetails sale where salesno=" + saleno + " ";
        return StockReports.GetDataTable(str);
    }

    #region Data Binding

    private void BindStock()
    {
        string str = "select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,date_format(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate from f_nmstock ST inner join f_itemmaster IM on ST.ItemID=IM.ItemID where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 and IM.ItemID ='" + ListBox1.SelectedItem.Value.Split('#')[0] + "' AND st.CentreID='" + Session["CentreID"].ToString() + "'";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

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
            string[] SalesIDs;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('13','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "')"));

            try
            {
                DataTable dtItem = (DataTable)ViewState["StockTransfer"];
                Sales_Details ObjSales = null;

                SalesIDs = new string[dtItem.Rows.Count];

                for (int i = 0; i < dtItem.Rows.Count; i++)
                {

                    //---------------- Insert into Sales Details Table-----------

                    ObjSales = new Sales_Details(Tranx);
                    ObjSales.LedgerNumber = ViewState["DeptLedNo"].ToString();
                    ObjSales.DepartmentID = "STO00001";
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
                    ObjSales.Naration = ((TextBox)gvIssueItem.Rows[i].FindControl("txtNarration")).Text;
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.UserID = ViewState["UID"].ToString();
                    ObjSales.DeptLedgerNo = ViewState["DeptLedNo"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //ObjSales.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                    SalesIDs[i] = ObjSales.Insert();

                    if (SalesIDs[i] == "")
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return 0;
                    }

                    //---- Update Release Count in Stock Table---------------------



                    string strStock = "update f_stock set ReleasedCount = ReleasedCount +" + ObjSales.SoldUnits + " where StockID = '" + ObjSales.StockID + "' and ReleasedCount + " + ObjSales.SoldUnits + "<=InitialCount";


                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock) == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return 0;
                    }
                }


                //--Insert data in mortuary_ledgertransaction and mortuary_ledgertnxdetail---------
                AllQuery AQ = new AllQuery();
                DataTable dtAdjust = StockReports.GetDataTable("SELECT Transaction_ID,CorpseID,DoctorID,Panel_ID,BillNo,BillDate,TotalBilledAmt,TDS,ServiceTaxAmt,ServiceTaxPer,ServiceTaxSurChgAmt,SerTaxSurChgPer,SerTaxBillAmount,S_CountryID,S_Amount,S_Notation,C_Factor,RoundOff,DiscountOnBill,IsReleased,IsBillClosed,FileClose_flag FROM mortuary_corpse_deposite WHERE IsCancel=0 AND Transaction_ID='" + ViewState["TransactionID"].ToString() + "'");

                float TotalRate = 0F;
                string PanelId = dtAdjust.Rows[0]["Panel_ID"].ToString();


                for (int j = 0; j < dtItem.Rows.Count; j++)
                {
                    TotalRate = TotalRate + (Util.GetFloat(dtItem.Rows[j]["MRP"]) * Util.GetFloat(dtItem.Rows[j]["IssueQty"]));
                }

                string HospitalLedgerNo = AllQuery.GetLedgerNoByLedgerUserID(ObjSales.Hospital_ID, con);

                string LedTxnID = "";
                Mortuary_Ledger_Transaction objLedTran = new Mortuary_Ledger_Transaction(Tranx);
                objLedTran.LedgerNoCr = AQ.GetCorpseLedgerNo(ViewState["TransactionID"].ToString());
                objLedTran.LedgerNoDr = HospitalLedgerNo;  //HospLedger;
                objLedTran.Hospital_ID = ObjSales.Hospital_ID;// LedgerNo.Rows[0]["Hospital_ID"].ToString(); //Hospital ID;
                objLedTran.TypeOfTnx = "Mortuary-Sales";
                objLedTran.Date = DateTime.Now;
                objLedTran.Time = DateTime.Now;
                objLedTran.AgainstPONo = "";
                objLedTran.BillNo = "";
                objLedTran.DiscountOnTotal = Util.GetDecimal("0.0");
                objLedTran.GrossAmount = Util.GetDecimal(TotalRate);
                objLedTran.NetAmount = Util.GetDecimal(TotalRate);
                objLedTran.IsCancel = 0;
                objLedTran.CancelReason = "";
                objLedTran.CancelAgainstLedgerNo = "";
                objLedTran.CancelDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
                objLedTran.UserID = ViewState["UID"].ToString();
                objLedTran.CorpseID = ViewState["CorpseID"].ToString();
                objLedTran.TransactionID = ViewState["TransactionID"].ToString();
                objLedTran.Panel_ID = PanelId;
                objLedTran.UniqueHash = Util.getHash();
                objLedTran.IpAddress = Request.UserHostAddress;
                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                //objLedTran.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                LedTxnID = objLedTran.Insert().ToString();

                //***************** insert into Ledger transaction details and Sales Details *************  

                for (int j = 0; j < dtItem.Rows.Count; j++)
                {
                    DataTable dtItemDet = StockReports.GetDataTable("Select ToBeBilled,IsUsable from f_itemmaster where ItemID ='" + dtItem.Rows[j]["ItemID"] + "'");

                    Mortuary_LedgerTnxDetail objLTDetail = new Mortuary_LedgerTnxDetail(Tranx);
                    objLTDetail.Hospital_Id = Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = LedTxnID;
                    objLTDetail.ItemID = Util.GetString(dtItem.Rows[j]["ItemID"]);
                    objLTDetail.StockID = Util.GetString(ObjSales.StockID);
                    objLTDetail.SubCategoryID = Util.GetString(dtItem.Rows[j]["SubCategory"]);
                    objLTDetail.TransactionID = ViewState["TransactionID"].ToString();
                    objLTDetail.Rate = Util.GetDecimal(dtItem.Rows[j]["MRP"]);
                    objLTDetail.Quantity = Util.GetDecimal(dtItem.Rows[j]["IssueQty"]);
                    objLTDetail.IsVerified = 1;
                    objLTDetail.ItemName = Util.GetString(dtItem.Rows[j]["ItemName"]);
                    objLTDetail.EntryDate = DateTime.Now;
                    objLTDetail.Doctor_Id = "";
                    objLTDetail.Amount = Util.GetDecimal(Util.GetDecimal(dtItem.Rows[j]["IssueQty"]) * Util.GetDecimal(dtItem.Rows[j]["MRP"]));
                    objLTDetail.DiscAmt = Util.GetDecimal(0);
                    objLTDetail.DiscountPercentage = Util.GetDecimal(0);
                    objLTDetail.DiscountReason = "";
                    objLTDetail.UserID = Session["ID"].ToString();
                    objLTDetail.TnxTypeID = Util.GetInt("21");
                    objLTDetail.ToBeBilled = Util.GetInt(dtItemDet.Rows[0]["ToBeBilled"]);
                    objLTDetail.IsReusable = Util.GetString(dtItemDet.Rows[0]["IsUsable"]);
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[j]["SubCategory"]), con));
                    objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //objLTDetail.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                    objLTDetail.Hospital_Id = Session["HOSPID"].ToString();
                    objLTDetail.SalesID = SalesIDs[j];
                    objLTDetail.Insert();
                }

                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return SalesNo;
            }
            catch
            {
                Tranx.Rollback();
                con.Close();
                con.Dispose();
                return 0;
            }
        }
        else
            return 0;
    }
    #endregion
}