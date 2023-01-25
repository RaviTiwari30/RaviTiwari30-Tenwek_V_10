using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Store_StockAdjustment : System.Web.UI.Page
{
    public DataTable GetAdjustmentItem(string ItemName, string BatchNo)
    {
        try
        {
            string strSelect = "select ItemID,StockID,ItemName,BatchNumber,SubCategoryID,UnitPrice,MRP,Rate,MajorMRP,DiscPer,MajorUnit,PurTaxPer,date_format(StockDate,'%d-%b-%y')StockDate,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,IsExpirable ,(InitialCount-ReleasedCount)As QOH,HSNCode,IGSTPercent,SGSTPercent,CGSTPercent,GSTType,SaleTaxPer from f_stock where (InitialCount-ReleasedCount)>0 and IsPost=1 and DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ";
            if (ItemName != "")
            {
                strSelect = strSelect + " and ItemID='" + ItemName + "'";
            }
            if (ChkIsExpirable.Checked == true)
            {
                if (Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") != string.Empty)
                    strSelect = strSelect + "  AND DATE(MedExpiryDate) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'";
                if (Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") != string.Empty)
                    strSelect = strSelect + " AND  DATE(MedExpiryDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (BatchNo != "")
            {
                strSelect = strSelect + " and BatchNumber like '" + BatchNo + "' ";
            }

            strSelect = strSelect + " order by ItemID,StockID";

            DataTable dt = StockReports.GetDataTable(strSelect);

            return dt;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    public string SaveAdjustmentStock(DataTable dt, string HospID, string UserID, string TranType, string LedgerNumber,string ApprovedBy, string Narration, string DeptLedgerNo, string DepartmentID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        string SalesID = string.Empty;
        try
        {
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "select Get_SalesNo('8','" + rblStoreType.SelectedValue + "','" + Session["CentreID"].ToString() + "') "));
            if (SalesNo == 0)
            {
                lblMsg.Text = "Please Generate Store Sales No.";
                tranX.Rollback();
                return string.Empty;
            }
           
            for (int i = 0; i < dt.Rows.Count; i++)
            {

                decimal TaxablePurVATAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["PurTaxPer"])));
                decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dt.Rows[i]["PurTaxPer"]) / 100;

                decimal TaxableSaleVATAmt = Util.GetDecimal(dt.Rows[i]["MRP"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["SaleTaxPer"])));
                decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]) / 100;
                //---------------- Insert into Sales Details Table-----------

                Sales_Details ObjSales = new Sales_Details(tranX);
                ObjSales.Hospital_ID = HospID;
                ObjSales.LedgerNumber = LedgerNumber;
                ObjSales.LedgerTransactionNo = "0";
                ObjSales.DepartmentID = DepartmentID;
                ObjSales.StockID = Util.GetString(dt.Rows[i]["StockID"]);
                ObjSales.SoldUnits = Util.GetDecimal(dt.Rows[i]["Quantity"]);
                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dt.Rows[i]["UnitPrice"]);
                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dt.Rows[i]["MRP"]);
                ObjSales.Date = Util.GetDateTime(dt.Rows[i]["EntryDate"]);
                ObjSales.Time = DateTime.Now;
                ObjSales.IsReturn = 0;
                ObjSales.TrasactionTypeID = 8;
                ObjSales.ItemID = Util.GetString(dt.Rows[i]["ItemID"]);
                ObjSales.Naration = Narration;
                ObjSales.SalesNo = SalesNo;
                ObjSales.DeptLedgerNo = DeptLedgerNo;
                ObjSales.UserID = ViewState["ID"].ToString();
                ObjSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjSales.IpAddress = All_LoadData.IpAddress();
                ObjSales.LedgerTnxNo = 0;
                ObjSales.medExpiryDate = Util.GetDateTime(dt.Rows[i]["MedExpiryDate"]);
                ObjSales.PurTaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"]);
                ObjSales.PurTaxAmt = vatPuramt;
                ObjSales.TaxPercent = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]);
                ObjSales.TaxAmt = vatSaleamt;
                ObjSales.HSNCode = Util.GetString(dt.Rows[i]["HSNCode"]);
                ObjSales.IGSTPercent = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]);
                ObjSales.IGSTAmt = Util.GetDecimal(dt.Rows[i]["IGSTAmt"]);
                ObjSales.CGSTPercent = Util.GetDecimal(dt.Rows[i]["CGSTPercent"]);
                ObjSales.CGSTAmt = Util.GetDecimal(dt.Rows[i]["CGSTAmt"]);
                ObjSales.SGSTPercent = Util.GetDecimal(dt.Rows[i]["SGSTPercent"]);
                ObjSales.SGSTAmt = Util.GetDecimal(dt.Rows[i]["SGSTAmt"]);
                ObjSales.GSTType = Util.GetString(dt.Rows[i]["GSTType"]);
                ObjSales.ServiceItemID = "0";
                ObjSales.TransactionID = "0";
                SalesID = ObjSales.Insert();
                if (SalesID.Length == 0)
                {
                    tranX.Rollback();
                    return string.Empty;
                }
                string strStock = "update f_stock set ReleasedCount = ReleasedCount +" + Util.GetDecimal(dt.Rows[i]["Quantity"]) + " where StockID = '" + Util.GetString(dt.Rows[i]["StockID"]) + "' and ReleasedCount + " + Util.GetDecimal(dt.Rows[i]["Quantity"]) + "<=InitialCount";
                if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strStock) == 0)
                {
                    return string.Empty;
                }
            }
            tranX.Commit();
            return Util.GetString(SalesNo);
        }
        catch (Exception ex)
        {
            tranX.Rollback();         
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnAdjustment_Click(object sender, EventArgs e)
    {
        if (cmbAprroved.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Approved By";
            cmbAprroved.Focus();
            return;
        }
        DataTable dtItem = ViewState["dtItems"] as DataTable;
        string LedgerNumber = "LSHHI53";
        string Saved = "", Narration = "";
        string HospID = Session["HOSPID"].ToString();
        string UserID = Session["ID"].ToString();
        string ApprovedBy = cmbAprroved.SelectedItem.Text;
        Narration = txtNarration.Text.Trim();

        Saved = SaveAdjustmentStock(dtItem, HospID, UserID, "StockAdjustment", LedgerNumber, ApprovedBy, Narration, ViewState["DeptLedgerNo"].ToString(), rblStoreType.SelectedValue);
        if (Saved != string.Empty)
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "alert('Entry No.:'+'" + Saved + "');location.href='stockAdjustment.aspx';", true);
        else
            lblMsg.Text = "Error....";
    }

    protected void btnBar_Click(object sender, EventArgs e)
    {
        string str = "select SaleTaxPer,ItemID,StockID,ItemName,BatchNumber,SubCategoryID,UnitPrice,MRP,date_format(StockDate,'%d-%b-%y')StockDate,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,IsExpirable ,(InitialCount-ReleasedCount)As QOH from f_stock where stockID='LSHHI" + txtBar.Text.Trim() + "' and (InitialCount-ReleasedCount)>0 and IsPost=1";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ViewState["dtItem"] = dt;
            GridView1.DataSource = dt;
            GridView1.DataBind();
            txtBar.Text = string.Empty;
            txtBar.Focus();
            lblMsg.Text = dt.Rows.Count + "Item Found";
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            lblMsg.Text = "No Item Found";
        }
    }

    protected void btnReturn_Click(object sender, EventArgs e)
    {
        if (txtQty.Text == "" || Util.GetDecimal(txtQty.Text.Trim()) == 0)
        {
            lblMsg.Text = "Enter Adjustment Quantity";
            txtQty.Focus();
            return;
        }
        //if (txtNarration.Text == "")
        //{
        //    lblMsg.Text = "Enter Narration";
        //    txtNarration.Focus();
        //    return;
        //}

        string StockID = ViewState["StockID"].ToString();
        decimal qty = Util.GetDecimal(ViewState["inHandQty"].ToString());

        if ((txtQty.Text.Trim() != string.Empty) && (Util.GetDecimal(txtQty.Text.Trim()) > qty))
        {
            lblMsg.Text = "Adjustment Quantity is greater than inHand Quantity";
            txtQty.Focus();
        }
        else
        {
            DataTable dtItemDetails = (DataTable)ViewState["dtItem"];

            DataRow[] dr = dtItemDetails.Select("StockID = '" + StockID + "'");

            DataTable dtItem;

            if (ViewState["dtItems"] != null)
            {
                dtItem = (DataTable)ViewState["dtItems"];

                if (dtItem.Select("StockID = '" + StockID + "'").Length > 0)
                {
                    lblMsg.Text = "Item Already Selected";
                    return;
                }
            }
            else
                dtItem = dtItemDetails.Clone();

            if (dtItem.Columns.Contains("Quantity") == false) dtItem.Columns.Add("Quantity", typeof(decimal));
            if (dtItem.Columns.Contains("EntryDate") == false) dtItem.Columns.Add("EntryDate");
            if (dtItem.Columns.Contains("Amount") == false) dtItem.Columns.Add("Amount", typeof(decimal));
            if (dtItem.Columns.Contains("Discount") == false) dtItem.Columns.Add("Discount", typeof(decimal));
            if (dtItem.Columns.Contains("PurTaxPer") == false) dtItem.Columns.Add("PurTaxPer", typeof(decimal));
            if (dtItem.Columns.Contains("MRPValue") == false) dtItem.Columns.Add("MRPValue", typeof(decimal));
            if (dtItem.Columns.Contains("NetAmount") == false) dtItem.Columns.Add("NetAmount", typeof(decimal));
            if (dtItem.Columns.Contains("taxAmount") == false) dtItem.Columns.Add("taxAmount", typeof(decimal));
            //GST Changes
            if(dtItem.Columns.Contains("IGSTAmt")==false) dtItem.Columns.Add("IGSTAmt",typeof(decimal));
            if (dtItem.Columns.Contains("CGSTAmt") == false) dtItem.Columns.Add("CGSTAmt", typeof(decimal));
            if (dtItem.Columns.Contains("SGSTAmt") == false) dtItem.Columns.Add("SGSTAmt", typeof(decimal));
            foreach (DataRow row in dr)
            {
                DataRow NewRow = dtItem.NewRow();
                NewRow["ItemName"] = row["ItemName"].ToString();
                NewRow["StockID"] = row["StockID"].ToString();
                NewRow["EntryDate"] = DateTime.Now;
                NewRow["MedExpiryDate"] = row["MedExpiryDate"].ToString();
                NewRow["IsExpirable"] = row["IsExpirable"].ToString();                
                NewRow["UnitPrice"] = row["UnitPrice"].ToString();
                NewRow["MRP"] = row["MRP"].ToString();
                NewRow["MajorMRP"] = row["MajorMRP"].ToString();
                NewRow["ItemID"] = row["ItemID"].ToString();
                NewRow["BatchNumber"] = row["BatchNumber"].ToString();
                NewRow["SubCategoryID"] = row["SubCategoryID"].ToString();
                NewRow["Quantity"] = txtQty.Text.Trim();
                //23.12.2017   According to Ashish Sir Tax calculations should be on Purchase Rate
                decimal CF = Math.Round(Util.GetDecimal(row["MajorMRP"]) / Util.GetDecimal(row["MRP"]), 2, MidpointRounding.AwayFromZero);
                decimal Quantity = Util.GetDecimal(txtQty.Text.Trim());
                decimal rate = Util.GetDecimal(row["Rate"].ToString()) / CF;
                NewRow["Rate"] = rate;
                NewRow["Amount"] = rate * Quantity;
                NewRow["Discount"] = row["DiscPer"].ToString();
                NewRow["PurTaxPer"] = row["PurTaxPer"].ToString();
                NewRow["SaleTaxPer"] = row["SaleTaxPer"].ToString();

                decimal igstPercent = Util.GetDecimal(row["IGSTPercent"].ToString());
                decimal csgtPercent = Util.GetDecimal(row["CGSTPercent"].ToString());
                decimal sgstPercent = Util.GetDecimal(row["SGSTPercent"].ToString());
                decimal discount= Math.Round(Util.GetDecimal(NewRow["Amount"]) * Util.GetDecimal(row["DiscPer"]) / 100,2,MidpointRounding.AwayFromZero);
                decimal taxableAmt = Math.Round(Util.GetDecimal(NewRow["Amount"]) - discount, 2, MidpointRounding.AwayFromZero);
                decimal taxAmount=Math.Round(taxableAmt*Util.GetDecimal(igstPercent+csgtPercent+sgstPercent)/100,2,MidpointRounding.AwayFromZero);
                //decimal cc = Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(row["MajorMRP"]) * Util.GetDecimal(txtQty.Text)) - Util.GetDecimal(row["DiscPer"]) / 100);

                //decimal taxAmount = Math.Round((Util.GetDecimal(row["MajorMRP"]) * Util.GetDecimal(txtQty.Text)) - (Util.GetDecimal(row["MajorMRP"]) * Util.GetDecimal(txtQty.Text) * 100) / (100 + Util.GetDecimal(row["PurTaxPer"])), 2, MidpointRounding.AwayFromZero);

                //decimal discount = Math.Round(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(rate) * Util.GetDecimal(txtQty.Text) * Util.GetDecimal(row["DiscPer"])) / 100), 2, MidpointRounding.AwayFromZero);
                //decimal ss = Math.Round(Util.GetDecimal(((Util.GetDecimal(cc) * 100) / (100 + Util.GetDecimal(row["PurTaxPer"])))), 2, MidpointRounding.AwayFromZero);
               
                NewRow["MRPValue"] = Math.Round(Util.GetDecimal(row["MRP"]) * Quantity, 2, MidpointRounding.AwayFromZero);
                NewRow["NetAmount"] = Math.Round((Util.GetDecimal(Util.GetDecimal(rate) * Util.GetDecimal(txtQty.Text)) + Util.GetDecimal(taxAmount) - Util.GetDecimal(discount)), 2, MidpointRounding.AwayFromZero);
                NewRow["taxAmount"] = Math.Round(Util.GetDecimal(taxAmount), 2, MidpointRounding.AwayFromZero);

                //GST Changes
                NewRow["HSNCode"] = row["HSNCode"].ToString();
                NewRow["GSTType"] = row["GSTType"].ToString();

                
                NewRow["IGSTPercent"] = igstPercent;
                NewRow["CGSTPercent"] = csgtPercent;
                NewRow["SGSTPercent"] = sgstPercent;

               // decimal taxableAmt = ((Util.GetDecimal(row["MajorMRP"])) * 100 * Util.GetDecimal(txtQty.Text)) / (100 + igstPercent + csgtPercent + sgstPercent);
                NewRow["IGSTAmt"] = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                NewRow["CGSTAmt"] = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                NewRow["SGSTAmt"] = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
                dtItem.Rows.Add(NewRow);
            }
            txtQty.Text = "";
            ViewState["dtItems"] = dtItem;
            grdReturnItems.DataSource = dtItem;
            grdReturnItems.DataBind();
            if (dtItem.Rows.Count == 0)
            {
                btnAdjustment.Enabled = false;
                rblStoreType.Enabled = true;
                btnAdjustment.Visible = false;
            }
            else
            {
                btnAdjustment.Enabled = true;
                rblStoreType.Enabled = false;
                btnAdjustment.Visible = true;
            }
            lblMsg.Text = "";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    protected void btnSearchItemCode_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(im.ItemID,'#',im.SubCategoryID)ItemId,(im.typename)itemname FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON  ");
        sb.Append(" cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im ON sc.SubCategoryID = im.SubCategoryID  ");
        sb.Append(" INNER JOIN f_stock s ON s.ItemID = im.ItemID AND s.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append(" WHERE  s.InitialCount-s.ReleasedCount > 0  and s.IsPost=1 and s.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ");
        if (rblStoreType.SelectedValue == "STO00001")
            sb.Append(" AND cf.ConfigID ='11' ");
        else if (rblStoreType.SelectedValue == "STO00002")
            sb.Append("AND cf.ConfigID ='28'");

      
        if (ddlCategory.SelectedValue != "ALL")
            sb.Append(" and sc.CategoryID='" + ddlCategory.SelectedValue + "'");
        if (ddlSubcategory.SelectedValue != "ALL")
            sb.Append(" and sc.SubCategoryID='" + ddlSubcategory.SelectedValue + "'");
        if (txtCPTCodeSearch.Text.Trim() != "")
            sb.Append(" AND im.ItemCode='" + txtCPTCodeSearch.Text.Trim() + "'");
        sb.Append(" GROUP BY im.ItemID order by itemname ");
        DataTable dtItem = StockReports.GetDataTable(sb.ToString());

        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            lstItem.DataSource = dtItem;
            lstItem.DataTextField = "itemname";
            lstItem.DataValueField = "ItemId";
            lstItem.DataBind();
        }
        else
        {
            lstItem.Items.Clear();
            lblMsg.Text = "No Item Found";
        }
    }

    protected void grdReturnItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtItems"];
            dtItem.Rows[args].Delete();
            grdReturnItems.DataSource = dtItem;
            grdReturnItems.DataBind();
            ViewState["dtItems"] = dtItem;
            txtQty.Focus();
            if (dtItem.Rows.Count == 0)
            {
                btnAdjustment.Enabled = false;
                rblStoreType.Enabled = true;
                btnAdjustment.Visible = false;
            }
            else
            {
                btnAdjustment.Enabled = true;
                rblStoreType.Enabled = false;
                btnAdjustment.Visible = true;

            }
        }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataTable dt;
        GridView1.PageIndex = e.NewPageIndex;
        if (ViewState["dtItem"] != null)
        {
            dt = ViewState["dtItem"] as DataTable;
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string StockID = ((Label)GridView1.SelectedRow.FindControl("lblStockID")).Text;
        ViewState.Add("StockID", StockID);
        lblItemName.Text = ((Label)GridView1.SelectedRow.FindControl("lblItemName")).Text;
        lblQOH.Text = ((Label)GridView1.SelectedRow.FindControl("lblQOH")).Text;
        lblExpDate.Text = Util.GetDateTime(((Label)GridView1.SelectedRow.FindControl("lblMedicalExpiryDate")).Text).ToString("dd-MMM-yyyy");
        decimal QOH = Util.GetDecimal(((Label)GridView1.SelectedRow.FindControl("lblQOH")).Text);
        ViewState["inHandQty"] = QOH;
        txtQty.Focus();
        btnReturn.Visible = true;
        pnlInfo.Visible = true;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString()); if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();


                All_LoadData.bindApprovalType(cmbAprroved);
                cmbAprroved.SelectedIndex = 1;

                txtBar.Attributes.Add("onKeyPress", "doClick('" + btnBar.ClientID + "',event)");
               
                //txtCPTCodeSearch.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");

                btnAdjustment.Enabled = false;
                cmbAprroved.Focus();
                pnlInfo.Visible = false;
                if (ChkRights())
                {
                    string Msg = "You do not have rights to Process Stock ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                BindCategory();
                BindSubCategory();
            }
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    private void BindCategory()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CategoryID,cm.Name FROM f_categorymaster cm INNER JOIN ");
        sb.Append(" f_ConfigRelation cr ON cm.CategoryID = cr.CategoryID WHERE  Isactive=1 ");
        if (rblStoreType.SelectedValue == "STO00001")
            sb.Append(" AND cr.ConfigID ='11' ");
        else if (rblStoreType.SelectedValue == "STO00002")
            sb.Append("AND cr.ConfigID ='28'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataSource = dt;
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("ALL", "ALL"));
            ddlCategory.SelectedIndex = 0;
        }
        else
        {
            ddlCategory.DataSource = null;
            ddlCategory.DataBind();
        }
    }

    private void BindItem()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT CONCAT(im.ItemID,'#',im.SubCategoryID)ItemId,CONCAT(IFNULL(IM.ItemCode,''),' # ',im.typename)itemname FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON  ");
            sb.Append(" cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im ON sc.SubCategoryID = im.SubCategoryID  ");
            sb.Append(" INNER JOIN f_stock s ON s.ItemID = im.ItemID AND s.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
            sb.Append(" WHERE  s.InitialCount-s.ReleasedCount > 0  and s.IsPost=1 and s.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " ");
             if (rblStoreType.SelectedValue == "STO00001")
                 sb.Append(" AND cf.ConfigID ='11' ");
            else if (rblStoreType.SelectedValue == "STO00002")
                 sb.Append(" AND cf.ConfigID ='28' ");
            
            sb.Append(" GROUP BY im.ItemID order by itemname ");

            DataTable dtItem = StockReports.GetDataTable(sb.ToString());

            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                lstItem.DataSource = dtItem;
                lstItem.DataTextField = "itemname";
                lstItem.DataValueField = "ItemId";
                lstItem.DataBind();
            }
            else
            {
                lstItem.Items.Clear();
                lstItem.Items.Add(new ListItem("No Item Found", ""));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void BindSubCategory()
    {
        string strQuery = "";
        strQuery = " SELECT sc.Name GroupHead,sc.SubCategoryID FROM f_subcategorymaster sc ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " WHERE sc.Active=1 ";
         if (rblStoreType.SelectedValue == "STO00001")
             strQuery += " AND cf.ConfigID ='11' ";
            else if (rblStoreType.SelectedValue == "STO00002")
             strQuery += " AND cf.ConfigID ='28' ";
        
        strQuery += " ORDER BY sc.Name";

        ddlSubcategory.DataSource = StockReports.GetDataTable(strQuery);
        ddlSubcategory.DataTextField = "GroupHead";
        ddlSubcategory.DataValueField = "SubCategoryID";
        ddlSubcategory.DataBind();

        ddlSubcategory.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlSubcategory.SelectedIndex = 0;
    }

    private void Search()
    {
        string ItemName = "", BatchNo = "";
        if (lstItem.SelectedIndex != -1)
        {
            ItemName = lstItem.SelectedItem.Value.Split('#')[0].ToString();
        }
        else
        {
            lblMsg.Text = "Select Item";
            return;
        }
        if (txtBatchNo.Text.Trim() != "")
        {
            BatchNo = txtBatchNo.Text.Trim();
        }

        DataTable dtItem = GetAdjustmentItem(ItemName, BatchNo);
        ViewState["dtItem"] = dtItem;
        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            if (Resources.Resource.IsGSTApplicable == "0")
            {
                GridView1.Visible = true;
                DGGrid.Visible = false;
                GridView1.DataSource = dtItem;
                GridView1.DataBind();
            }
            else
            {
                GridView1.Visible = false;
                DGGrid.Visible = true;
                DGGrid.DataSource = dtItem;
                DGGrid.DataBind();
            }
            txtCPTCodeSearch.Text = "";
            btnSearchItemCode_Click(this, new EventArgs());
            txtQty.Focus();
        }
        else
        {
            lblMsg.Text = "No Record Found";
            lstItem.SelectedIndex = -1;
            GridView1.DataSource = null;
            GridView1.DataBind();
        }
        lstItem.SelectedIndex = -1;
    }
    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblStoreType.SelectedIndex < 0)
        {
            lblMsg.Text = "Please select Store Type";
            return;
        }
        else
        {
            lblMsg.Text = "";
            BindItem();
        }
    }
    protected bool ChkRights()
    {

        string EmpId = Session["ID"].ToString();
        rblStoreType.Items[0].Enabled = false;
        rblStoreType.Items[1].Enabled = false;
        DataTable dt = StockReports.GetRights(Session["RoleID"].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
            {
                string Msg = "You do not have rights to generate purchase Order ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg);
            }
            else
            {
                rblStoreType.Items[0].Enabled = Util.GetBoolean(dt.Rows[0]["IsMedical"]);
                if (rblStoreType.Items[0].Enabled == true)
                    rblStoreType.Items[0].Selected = Util.GetBoolean(dt.Rows[0]["IsMedical"]);

                rblStoreType.Items[1].Selected = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
                if (rblStoreType.Items[1].Enabled == true)
                    rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);

                if (rblStoreType.SelectedIndex > -1)
                    BindItem();

            }
            return false;
        }
        else { return true; }
    }

    protected void DGGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        string StockID = ((Label)DGGrid.SelectedRow.FindControl("lblStockID")).Text;
        ViewState.Add("StockID", StockID);
        lblItemName.Text = ((Label)DGGrid.SelectedRow.FindControl("lblItemName")).Text;
        lblQOH.Text = ((Label)DGGrid.SelectedRow.FindControl("lblQOH")).Text;
        lblExpDate.Text = Util.GetDateTime(((Label)DGGrid.SelectedRow.FindControl("lblMedicalExpiryDate")).Text).ToString("dd-MMM-yyyy");
        decimal QOH = Util.GetDecimal(((Label)DGGrid.SelectedRow.FindControl("lblQOH")).Text);
        ViewState["inHandQty"] = QOH;
        txtQty.Focus();
        btnReturn.Visible = true;
        pnlInfo.Visible = true;
    }
}