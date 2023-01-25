using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_Purchase_PurchaseOrder : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindVendor();
            AllLoadData_Store.bindTypeMaster(ddlPOType);
            ddlVendor_SelectedIndexChanged(sender, e);
            pnlItems.Visible = false;
            ScriptManager1.SetFocus(ddlVendor);
            txtInvoiceAmount.Attributes.Add("readOnly", "readOnly");

            txtFreight.Attributes.Add("onkeyup", "sum();");
            txtScheme.Attributes.Add("onkeyup", "sum();");
            txtRoundOff.Attributes.Add("onkeyup", "sum();");
            txtExciseOnBill.Attributes.Add("onkeyup", "sum();");
            ucPODate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            DateTime dt = DateTime.Now;
            dt = dt.AddMonths(3);
            ucValidDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            bydate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindTerms();
            LoadCurrencyDetail();
        }
        ucPODate.Attributes.Add("readOnly", "true");
        ucValidDate.Attributes.Add("readOnly", "true");
        Calendarextender1.StartDate = DateTime.Now;

    }
    protected void LoadCurrencyDetail()
    {
        DataTable dtDetail = All_LoadData.LoadCurrencyFactor("");
        ddlCurrency.DataSource = dtDetail;
        ddlCurrency.DataTextField = "Currency";
        ddlCurrency.DataValueField = "CountryID";
        ddlCurrency.DataBind();

        DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");
        ddlCurrency.SelectedIndex = ddlCurrency.Items.IndexOf(ddlCurrency.Items.FindByValue(dr[0]["CountryID"].ToString()));
        lblCurrencyNotation.Text = dr[0]["Notation"].ToString();
    }
    private void BindTerms()
    {
        string str = "select PoTermsSetID,TermSetName from f_purchaseordertermsSets where IsActive=1 group by PoTermsSetID ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlTermsSet.DataSource = dt;
            ddlTermsSet.DataTextField = "TermSetName";
            ddlTermsSet.DataValueField = "PoTermsSetID";
            ddlTermsSet.DataBind();
        }

        ddlTermsSet.Items.Insert(0, new ListItem("Select Terms", ""));
    }
    protected void ddlVendor_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ViewState["dtVendor"] != null)
        {
            DataTable dtVendor = (DataTable)ViewState["dtVendor"];
            DataRow[] dr = dtVendor.Select("LedgerNumber = '" + ddlVendor.SelectedValue + "'");

            if (dr.Length > 0)
            {
                string vendor = "<b><font color='maroon'>" + Util.GetString(dr[0]["Name"]) + @"</font></b><br/>"
                    + Util.GetString(dr[0]["Address1"]) + "<br/>" + Util.GetString(dr[0]["Address2"]);
                lblVendorDetails.Text = vendor;
            }
        }
    }
    protected void chkItems_CheckedChanged(object sender, EventArgs e)
    {
        if (gvItems.Rows.Count > 0)
        {
            for (int i = 0; i < gvItems.Rows.Count; i++)
                ((CheckBox)gvItems.Rows[i].FindControl("chkSelect")).Checked = chkItems.Checked;


            UpdatePOAmount();
        }
    }
    protected void gvItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row != null)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string PrDetailID = ((Label)e.Row.FindControl("lblPrDetailID")).Text.Trim();

                DataTable dtTax = new DataTable();
                dtTax = BindTax(PrDetailID);

                if ((dtTax != null) && (dtTax.Rows.Count > 0))
                {
                    Repeater rpTax = (Repeater)e.Row.FindControl("rpTax");
                    rpTax.DataSource = dtTax;
                    rpTax.DataBind();
                }
            }
        }
    }
    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {
        UpdatePOAmount();
    }
    protected void btnGetRequestItem_Click1(object sender, EventArgs e)
    {
        GetVendorItems();

    }
    protected void btnAddTerms_Click(object sender, EventArgs e)
    {
        if (ddlTermsSet.SelectedItem.Value == "")
        {
            lblMsg.Text = "Select Term";
            return;
        }

        DataTable dtTerms;

        if (ViewState["dtTerms"] != null)
            dtTerms = (DataTable)ViewState["dtTerms"];
        else
        {
            dtTerms = new DataTable();
            dtTerms.Columns.Add("Terms");
        }
        string strset = "select Details from f_purchaseordertermsSets where IsActive=1 and PoTermsSetID='" + ddlTermsSet.SelectedItem.Value.ToString() + "' ";
        DataTable dtsetTerm = StockReports.GetDataTable(strset);
        if (dtsetTerm.Rows.Count > 0)
        {
            foreach (DataRow dr in dtsetTerm.Rows)
            {
                string Term = dr["Details"].ToString();
                DataRow[] drnew = dtTerms.Select("Terms='" + Term + "'");
                if (drnew.Length > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM035','" + lblMsg.ClientID + "');", true);
                    return;
                }
                else
                {
                    DataRow row = dtTerms.NewRow();
                    row["Terms"] = Util.GetString(dr["Details"]);
                    dtTerms.Rows.Add(row);
                    dtTerms.AcceptChanges();
                }
            }
            gvTerms.DataSource = dtTerms;
            gvTerms.DataBind();
            lblMsg.Text = "";
            ViewState["dtTerms"] = dtTerms;
            ddlTermsSet.Focus();
        }
    }
    protected void gvTerms_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtTerms = (DataTable)ViewState["dtTerms"];
            dtTerms.Rows[args].Delete();
            dtTerms.AcceptChanges();
            gvTerms.DataSource = dtTerms;
            gvTerms.DataBind();
            ViewState["dtTerms"] = dtTerms;
            lblMsg.Text = "";
            if (gvTerms.Rows.Count == 0)
            {
                ViewState["dtTerms"] = null;
            }
        }
    }
    protected void gvItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbModify")
        {
            string PDID = Util.GetString(e.CommandArgument);

            if (ViewState["dsItems"] != null)
            {
                DataSet ds = (DataSet)ViewState["dsItems"];
                if (ds.Tables.Contains("ItemsDetail"))
                {
                    DataRow[] row = ds.Tables["ItemsDetail"].Select("PuschaseRequistionDetailID = '" + PDID + "'");
                    if (row.Length > 0)
                    {
                        lblItemID.Text = Util.GetString(row[0]["ItemID"]);
                        lblPDID.Text = Util.GetString(row[0]["PuschaseRequistionDetailID"]);
                        lblPRNo.Text = Util.GetString(row[0]["PurchaseRequisitionNo"]);
                        lblItemName.Text = Util.GetString(row[0]["ItemName"]);
                        lblSpecification.Text = Util.GetString(row[0]["Specification"]);
                        lblInHandQty.Text = Util.GetString(row[0]["InHandQty"]);
                        lblOrderQty.Text = Util.GetString(row[0]["PendingQty"]);
                        lblRate.Text = Util.GetString(row[0]["ApproxRate"]);

                        txtDiscount.Text = Util.GetString(row[0]["Discount"]);
                        txtOrderQty.Text = Util.GetString(row[0]["OrderQty"]);
                        txtRate.Text = Util.GetString(row[0]["ApproxRate"]);

                        DataTable dtTax = GetPRDetailTax(PDID);
                        if ((dtTax != null) && (dtTax.Rows.Count > 0))
                        {
                            gvTax.DataSource = dtTax;
                            gvTax.DataBind();
                            chkTax.Checked = true;
                        }
                        else
                        {
                            gvTax.DataSource = null;
                            gvTax.DataBind();
                            chkTax.Checked = false;
                        }


                        if (Session["ID"] != null && Session["ID"].ToString() != "LSHHI309")
                        {
                            if (Util.GetDecimal(txtRate.Text.Trim()) > 0)
                            {
                                txtRate.Attributes.Add("readonly", "readonly");
                                txtDiscount.Attributes.Add("readonly", "readonly");
                            }
                        }
                        //chkTax.Checked = false;                        
                        mpUpdate.Show();
                    }
                }
            }
        }
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataSet ds = (DataSet)ViewState["dsItems"];
            DataTable dtItems = ds.Tables["ItemsDetail"];
            dtItems.Rows[args].Delete();
            dtItems.AcceptChanges();
            ViewState["dsItems"] = ds;
            BindItemsDetail();
        }
    }
    protected void btnPdUpdate_Click(object sender, EventArgs e)
    {
        if (ValidateUpdate())
        {
            string PDID = lblPDID.Text.Trim();
            decimal AmtAfterExcise = Util.GetDecimal(txtRate.Text);
            if ((PDID != string.Empty) && (ViewState["dsItems"] != null))
            {
                DataSet ds = (DataSet)ViewState["dsItems"];
                DataTable dtItem = ds.Tables["ItemsDetail"];

                for (int i = 0; i < gvItems.Rows.Count; i++)
                    dtItem.Rows[i]["Save"] = ((CheckBox)gvItems.Rows[i].FindControl("chkSelect")).Checked;



                DataTable dtTax = ds.Tables["TaxDetail"];
                for (int j = 0; j < dtTax.Rows.Count; j++)
                {
                    if (Util.GetString(dtTax.Rows[j]["PRDetailID"]) == PDID)
                        dtTax.Rows[j].Delete();
                }


                foreach (GridViewRow row in gvTax.Rows)
                {
                    decimal TaxPer = Util.GetDecimal(((TextBox)row.FindControl("txtTaxPer")).Text.Trim());
                    decimal TaxAmt = Util.GetDecimal(((TextBox)row.FindControl("txtTaxAmt")).Text.Trim());
                    string TaxId = ((Label)row.FindControl("lblTaxID")).Text.Trim();
                    if (TaxId == "T5")
                    {
                        if (TaxPer > 0)
                        {
                            TaxAmt = Util.GetDecimal(txtRate.Text) * TaxPer / 100;
                        }
                        else if (TaxAmt > 0)
                        {
                            TaxPer = (TaxAmt * 100) / Util.GetDecimal(txtRate.Text);
                        }

                        if (TaxPer > 0)
                        {
                            DataRow dr = dtTax.NewRow();
                            dr["TaxID"] = TaxId;
                            dr["TaxPer"] = TaxPer;
                            dr["TaxAmt"] = TaxAmt;
                            dr["TaxName"] = ((Label)row.FindControl("lblTaxName")).Text.Trim();
                            dr["TaxDisplay"] = "Rs." + TaxAmt.ToString();
                            dr["PRDetailID"] = PDID;
                            dr["PurchaseRequisitionNo"] = lblPRNo.Text.Trim();
                            dtTax.Rows.Add(dr);
                        }



                    }
                    else if (TaxId != "T5")
                    {
                        if (TaxPer > 0)
                        {
                            TaxAmt = AmtAfterExcise * TaxPer / 100;
                        }
                        else if (TaxAmt > 0)
                        {
                            TaxPer = (TaxAmt * 100) / AmtAfterExcise;
                        }

                        if (TaxPer > 0)
                        {
                            DataRow dr = dtTax.NewRow();
                            dr["TaxID"] = TaxId;
                            dr["TaxPer"] = TaxPer;
                            dr["TaxAmt"] = TaxAmt;
                            dr["TaxDisplay"] = TaxPer.ToString() + "%";
                            dr["TaxName"] = ((Label)row.FindControl("lblTaxName")).Text.Trim();
                            dr["PRDetailID"] = PDID;
                            dr["PurchaseRequisitionNo"] = lblPRNo.Text.Trim();
                            dtTax.Rows.Add(dr);
                        }

                    }
                }



                dtTax.AcceptChanges();



                for (int i = 0; i < dtItem.Rows.Count; i++)
                    if (Util.GetString(dtItem.Rows[i]["PuschaseRequistionDetailID"]) == PDID)
                    {

                        dtItem.Rows[i]["OrderQty"] = Util.GetDecimal(txtOrderQty.Text.Trim());
                        dtItem.Rows[i]["Discount"] = Util.GetDecimal(txtDiscount.Text.Trim());
                        dtItem.Rows[i]["ApproxRate"] = Util.GetDecimal(txtRate.Text.Trim());
                        dtItem.Rows[i]["Specification"] = lblSpecification.Text.Trim();
                        dtItem.Rows[i]["BuyPrice"] = AmtAfterExcise;
                    }

                dtItem.AcceptChanges();


                ViewState["dsItems"] = ds;
                BindItemsDetail();

            }
            BindAmount();
        }
    }
    protected void btnAddFree_Click(object sender, EventArgs e)
    {
        if (ddlItems.SelectedIndex < 0 || ddlItems.SelectedItem.Value == "")
        {
            lblFree.Visible = true;
            lblFree.Text = "Select Item";
            mpeCreateGroup.Show();
            return;
        }


        if ((ViewState["dsItems"] != null) && (ddlVendor.SelectedValue != "0"))
        {
            DataSet ds = (DataSet)ViewState["dsItems"];
            DataTable dtItems = ds.Tables["ItemsDetail"];

            DataRow[] drow = dtItems.Select("ItemID = '" + ddlItems.SelectedValue.Split('#')[0] + "' AND IsFree = 'true'");
            if (drow.Length < 1)
            {
                if (dtItems.Rows.Count > 0)
                {
                    for (int i = 0; i < gvItems.Rows.Count; i++)
                        dtItems.Rows[i]["Save"] = ((CheckBox)gvItems.Rows[i].FindControl("chkSelect")).Checked;

                    DataRow dr = dtItems.NewRow();
                    Random rdm = new Random();
                    dr["Unit"] = "";
                    dr["PuschaseRequistionDetailID"] = Util.GetInt(rdm.Next());
                    dr["PendingQty"] = 0;
                    dr["PurchaseRequisitionNo"] = "Free";
                    dr["ProbableVendorID"] = ddlVendor.SelectedValue;
                    dr["Save"] = "true";
                    dr["ItemID"] = ddlItems.SelectedValue.Split('#')[0];
                    dr["ItemName"] = ddlItems.SelectedItem.Text;
                    dr["SubCategoryID"] = ddlItems.SelectedItem.Value.Split('#')[1];
                    dr["RequestedQty"] = 0;
                    dr["ApprovedQty"] = 0;
                    dr["OrderedQty"] = 0;
                    dr["IsFree"] = "true";
                    dr["Specification"] = txtSpecification.Text.Trim();
                    dr["Purpose"] = string.Empty;
                    dr["OrderQty"] = Util.GetDecimal(txtFreeQty.Text.Trim());
                    dr["ApproxRate"] = 0;
                    dr["InHandQty"] = GetInHandQty(ddlItems.SelectedValue.Split('#')[0]);
                    dr["Discount"] = 0;
                    dr["Type_ID"] = ddlItems.SelectedItem.Value.Split('#')[2];
                    dr["BuyPrice"] = 0;
                    dr["NetAmount"] = 0;
                    dr["MRP"] = 0;
                    dtItems.Rows.Add(dr);

                    dtItems.AcceptChanges();
                    txtFreeQty.Text = string.Empty;
                    txtSpecification.Text = string.Empty;
                    ViewState["dsItems"] = ds;
                    BindItemsDetail();
                    ddlItems.DataSource = null;
                    ddlItems.DataBind();
                    txtItemName.Text = "";
                }
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM031','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        Clear();
        ddlVendor_SelectedIndexChanged(sender, e);
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (validateGrid())
        {
            string HSPoNumber = "";
            lblMsg.Text = "";
            lblMsg2.Text = "";
            DataSet ds1 = (DataSet)ViewState["dsItems"];
            DataTable dtitem = ds1.Tables["ItemsDetail"];
            DataTable dttax = ds1.Tables["TaxDetail"];
            DataTable dttaxName = ds1.Tables["TaxName"];
            DataTable dtHS = new DataTable();
            if (dtitem.Rows.Count > 0)
            {
                dtHS = dtitem.Clone();
                for (int m = 0; m < dtitem.Rows.Count; m++)
                {

                    if (((CheckBox)gvItems.Rows[m].FindControl("chkSelect")).Checked)
                    {
                        
                        if (dtitem.Rows[m]["Type_id"].ToString() == "HS")
                        {
                            DataRow dr = dtHS.NewRow();
                            dr["Unit"] = dtitem.Rows[m]["Unit"].ToString();
                            dr["PuschaseRequistionDetailID"] = dtitem.Rows[m]["PuschaseRequistionDetailID"].ToString();
                            dr["PendingQty"] = dtitem.Rows[m]["PendingQty"].ToString();
                            dr["PurchaseRequisitionNo"] = dtitem.Rows[m]["PurchaseRequisitionNo"].ToString();
                            dr["ProbableVendorID"] = dtitem.Rows[m]["ProbableVendorID"].ToString();
                            dr["Save"] = dtitem.Rows[m]["Save"].ToString();
                            dr["itemID"] = dtitem.Rows[m]["itemID"].ToString();
                            dr["Type_id"] = dtitem.Rows[m]["Type_id"].ToString();
                            dr["ItemName"] = dtitem.Rows[m]["itemName"].ToString();
                            dr["SubCategoryID"] = dtitem.Rows[m]["SubCategoryID"].ToString();
                            dr["RequestedQty"] = dtitem.Rows[m]["RequestedQty"].ToString();
                            dr["ApprovedQty"] = dtitem.Rows[m]["ApprovedQty"].ToString();
                            dr["OrderedQty"] = dtitem.Rows[m]["OrderedQty"].ToString();
                            dr["IsFree"] = dtitem.Rows[m]["IsFree"].ToString();
                            dr["Specification"] = dtitem.Rows[m]["Specification"].ToString();
                            dr["Purpose"] = dtitem.Rows[m]["Purpose"].ToString();
                            dr["OrderQty"] = dtitem.Rows[m]["OrderQty"].ToString();
                            dr["ApproxRate"] = dtitem.Rows[m]["ApproxRate"].ToString();
                            dr["MRP"] = dtitem.Rows[m]["MRP"].ToString();
                            dr["InHandQty"] = Util.GetDecimal(dtitem.Rows[m]["InhandQty"].ToString());
                            dr["Discount"] = Util.GetDecimal(dtitem.Rows[m]["Discount"].ToString());
                            dr["BuyPrice"] = dtitem.Rows[m]["BuyPrice"].ToString();
                            dr["NetAmount"] = dtitem.Rows[m]["NetAmount"].ToString();
                            dtHS.Rows.Add(dr);
                            dtHS.AcceptChanges();
                            
                        }
                        else if (dtitem.Rows[m]["Type_id"].ToString() == "IMP")
                        {
                            string name = dtitem.Rows[m]["ItemName"].ToString().Split('#')[0];
                            lblMsg.Text = "{ " + name + " }" + " Is Implant Type";
                            return;
                        }

                    }
                }
                ViewState["dtHS"] = dtHS;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);              
            }
            if (dtHS.Rows.Count > 0)
            {
                string type_id = dtHS.Rows[0]["Type_ID"].ToString();
                HSPoNumber = SaveHSData(type_id);
            }
            string ImagesToprint = string.Empty;
            if (chkPrintImg.Checked == true)
            {
                ImagesToprint = "1";
            }
            else
            {
                ImagesToprint = "0";
            }
            if (HSPoNumber != string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Purchase Order No. : " + HSPoNumber + "');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('POReport.aspx?PONumber=" + HSPoNumber + "&ImageToPrint=" + ImagesToprint + "');location.href='PurchaseOrder.aspx';", true);
                Clear();
                ScriptManager1.SetFocus(ddlVendor);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);          
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
        }
    }

    #endregion

    #region Data Binding
    private void BindVendor()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT distinct(if(pd.ProbableVendorID is null,'0',pd.ProbableVendorID)) LedgerNumber,");
        sb.Append(" if(t1.LedgerName is null,'No-Vendor',t1.LedgerName)Name ,if(t1.Address1 is null,' ',t1.Address1)Address1");
        sb.Append(" ,if(t1.Address2 is null,' ',t1.Address2)Address2 from f_purchaserequestdetails pd LEFT JOIN ");
        sb.Append(" (SELECT lm.LedgerNumber,lm.LedgerName,vm.Address1,vm.Address2 from f_ledgermaster lm INNER JOIN f_vendormaster vm");
        sb.Append(" on lm.LedgerUserID = vm.Vendor_ID where lm.GroupID = 'Ven')T1 on pd.ProbableVendorID = t1.LedgerNumber");
        sb.Append(" where pd.Status = 0 and pd.Approved = 1 and pd.ApprovedQty > pd.OrderedQty  AND pd.CentreID='" + Session["CentreID"].ToString() + "' order by t1.LedgerName");

        DataTable dtVendor = new DataTable();
        dtVendor = StockReports.GetDataTable(sb.ToString());

        if (dtVendor.Rows.Count > 0)
        {
            ddlVendor.DataSource = dtVendor;
            ddlVendor.DataTextField = "Name";
            ddlVendor.DataValueField = "LedgerNumber";
            ddlVendor.DataBind();
            ViewState["dtVendor"] = dtVendor;
        }
        else
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            ddlVendor.Items.Clear();
            ddlVendor.Items.Add(new ListItem("No-Vendor", "0"));
        }

    }
    
    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT concat(IM.Typename,' # ','(',SM.name,')')ItemName,concat(IM.ItemID,'#',IM.SubCategoryID,'#',IM.Type_ID)ItemID");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
        sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID ");
        sb.Append(" WHERE CR.ConfigID in (11,28) AND im.IsActive=1 ");

        sb.Append(" and IM.Typename like '" + txtItemName.Text.Trim() + "%' ");

        sb.Append(" order by IM.Typename ");
        DataTable dtItem = new DataTable();
        dtItem = StockReports.GetDataTable(sb.ToString());

        if (dtItem.Rows.Count > 0)
        {
            ddlItems.DataSource = dtItem;
            ddlItems.DataTextField = "ItemName";
            ddlItems.DataValueField = "ItemID";
            ddlItems.DataBind();

        }
        else
        {
            ddlItems.Items.Clear();
            ddlItems.Items.Add(new ListItem("No Item Found", ""));

        }
        lblFree.Text = "";
    }
    private void GetVendorItems()
    {
        string vendorID = ddlVendor.SelectedValue;
        if (vendorID != "0")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select pd.unit,pd.PuschaseRequistionDetailID,(pd.ApprovedQty-IF(pd.OrderedQty >0,pd.OrderedQty,0)) PendingQty,pd.PurchaseRequisitionNo,pd.ProbableVendorID,'true' as Save,");
            sb.Append(" pd.ItemID,im.Type_id,pd.ItemName,pd.SubCategoryID,pd.RequestedQty,pd.ApprovedQty,pd.OrderedQty,'false' as IsFree,");
            sb.Append(" pd.Specification,pd.Purpose,(pd.ApprovedQty-IF(pd.OrderedQty <=0,0,pd.OrderedQty)) OrderQty,pd.ApproxRate,pd.InHandQty,pd.Discount AS Discount,0.0 AS BuyPrice,pd.MRP from f_purchaserequestdetails pd ");
            sb.Append(" inner join f_itemmaster im on im.itemID=pd.ItemID");
            sb.Append(" Inner join f_subcategorymaster sc on im.SubCategoryID=sc.SubCategoryID inner join f_categorymaster cm ON cm.CategoryID=sc.CategoryID INNER JOIN f_configrelation c ON c.CategoryID=cm.CategoryID");
            sb.Append(" where pd.Status = 0 and pd.Approved = 1 and ProbableVendorID = '" + vendorID + "' and pd.ApprovedQty > pd.OrderedQty and c.ConfigID=" + Util.GetInt(rdoItemType.SelectedValue) + " AND pd.CentreID='" + Session["CentreID"].ToString() + "' ORDER BY pd.ItemName ");


            DataTable dtItems = new DataTable();
            dtItems = StockReports.GetDataTable(sb.ToString());


            if (dtItems.Rows.Count > 0)
            {
               
                StringBuilder sbTax = new StringBuilder();
                sbTax.Append("select pr.TaxID,pr.TaxPer,pr.TaxAmt,CONCAT(pr.TaxPer,'%')TaxDisplay,tm.TaxName,pr.PRDetailID,pd.PurchaseRequisitionNo ");
                sbTax.Append(" from f_prtax pr inner join f_taxmaster tm on pr.TaxID = tm.TaxID inner join f_purchaserequestdetails pd");
                sbTax.Append(" on pr.PRDetailID = pd.PuschaseRequistionDetailID where pd.Status = 0 and pd.Approved = 1 and pd.ProbableVendorID = '" + vendorID + "' AND pd.CentreID='" + Session["CentreID"].ToString() + "' ");
                sbTax.Append(" union ");
                sbTax.Append("select pr.TaxID,pr.TaxPer,pr.TaxAmt,CONCAT('Rs.',pr.TaxAmt)TaxDisplay,tm.TaxName,pr.PRDetailID,pd.PurchaseRequisitionNo ");
                sbTax.Append(" from f_prtaxexcise pr inner join f_taxmaster tm on pr.TaxID = tm.TaxID inner join f_purchaserequestdetails pd");
                sbTax.Append(" on pr.PRDetailID = pd.PuschaseRequistionDetailID where pd.Status = 0 and pd.Approved = 1 and pd.ProbableVendorID = '" + vendorID + "' AND pd.CentreID='" + Session["CentreID"].ToString() + "'");

                DataTable dtTax = new DataTable();
                dtTax = StockReports.GetDataTable(sbTax.ToString());

                string str = "SELECT TaxName,TaxID,'' TaxPer,'' TaxAmt,IF(isPer=1,'true','false') AS isPer,IF(isAmt=1,'true','false') AS isAmt FROM f_taxmaster ORDER BY TaxName";
                DataTable dtAllTax = new DataTable();
                dtAllTax = StockReports.GetDataTable(str);

                DataSet ds = new DataSet();
                ds.Tables.Add(dtItems.Copy());
                ds.Tables[0].TableName = "ItemsDetail";

                ds.Tables.Add(dtTax.Copy());
                ds.Tables[1].TableName = "TaxDetail";

                ds.Tables.Add(dtAllTax.Copy());
                ds.Tables[2].TableName = "TaxName";

                ds.Tables["ItemsDetail"].Columns.Add("NetAmount");

                ViewState["dsItems"] = ds;
                BindAmount();
            }
            else
            {
                if (ViewState["dsItems"] != null)
                    ViewState.Remove("dsItems");
                Clear();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            if (ViewState["dsItems"] != null)
                ViewState.Remove("dsItems");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblMsg.ClientID + "');", true);
        }
    }

    private void BindItemsDetail()
    {
        if (ViewState["dsItems"] != null)
        {
            DataSet dsItems = (DataSet)ViewState["dsItems"];
            if (dsItems.Tables.Contains("ItemsDetail"))
            {
                gvItems.DataSource = dsItems.Tables["ItemsDetail"];
                gvItems.DataBind();
                lblMsg.Text = "";
                pnlItems.Visible = true;
            }
            else
            {
                gvItems.DataSource = null;
                gvItems.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            gvItems.DataSource = null;
            gvItems.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }

        UpdatePOAmount();
    }
    private DataTable BindTax(string PRDetailID)
    {
        if (ViewState["dsItems"] != null)
        {
            DataSet ds = (DataSet)ViewState["dsItems"];
            if (ds.Tables.Contains("TaxDetail"))
            {
                DataTable dtTax = ds.Tables["TaxDetail"].Clone();
                DataRow[] row = ds.Tables["TaxDetail"].Select("PRDetailID = '" + PRDetailID + "'");
                if (row.Length > 0)
                    foreach (DataRow dr in row)
                        dtTax.LoadDataRow(dr.ItemArray, true);
                return dtTax;
            }
            return null;
        }
        return null;
    }

    private decimal GetInHandQty(string ItemID)
    {
        string str = "select sum(InitialCount-ReleasedCount)InHandQty from f_stock where ItemID = '" + ItemID + "' group by ItemID";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
            return Util.GetDecimal(dt.Rows[0][0]);
        else
            return 0;

    }

    private DataTable GetPRDetailTax(string PDID)
    {
        if (ViewState["dsItems"] != null)
        {
            DataSet ds = (DataSet)ViewState["dsItems"];
            if (ds.Tables.Contains("TaxDetail"))
            {
                DataTable dtTaxName = ds.Tables["TaxName"];
                DataRow[] row = ds.Tables["TaxDetail"].Select("PRDetailID = '" + PDID + "'");

                if (row.Length > 0)
                {
                    for (int i = 0; i < dtTaxName.Rows.Count; i++)
                    {
                        foreach (DataRow dr in row)
                        {
                            dtTaxName.Rows[i]["TaxPer"] = "";
                            dtTaxName.Rows[i]["TaxAmt"] = "";
                        }
                        bool stat = true;
                        foreach (DataRow dr in row)
                            if (Util.GetString(dtTaxName.Rows[i]["TaxID"]) == Util.GetString(dr["TaxID"]))
                            {
                                if (Util.GetString(dtTaxName.Rows[i]["TaxID"]) != "T5")
                                {
                                    dtTaxName.Rows[i]["TaxPer"] = Util.GetDecimal(dr["TaxPer"]);
                                    dtTaxName.Rows[i]["TaxAmt"] = "";
                                }
                                else if (Util.GetString(dtTaxName.Rows[i]["TaxID"]) == "T5")
                                {
                                    dtTaxName.Rows[i]["TaxPer"] = "";
                                    dtTaxName.Rows[i]["TaxAmt"] = Util.GetDecimal(dr["TaxAmt"]);
                                }
                                stat = false;
                            }

                        if (stat)
                            dtTaxName.Rows[i]["TaxPer"] = string.Empty;
                    }
                }
                else
                {
                    for (int i = 0; i < dtTaxName.Rows.Count; i++)
                        dtTaxName.Rows[i]["TaxPer"] = string.Empty;
                }
                return dtTaxName;
            }
            else
                return null;
        }
        else
            return null;
    }

    private void UpdatePOAmount()
    {
        double NetAmount = 0f;
        foreach (GridViewRow gr in gvItems.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelect")).Checked)
            {
                string str = ((Label)gr.FindControl("lblNetAmount")).Text;
                double amt = Util.GetDouble(((Label)gr.FindControl("lblNetAmount")).Text);
                NetAmount += Util.GetDouble(((Label)gr.FindControl("lblNetAmount")).Text);
            }
        }
        lbl.Text = NetAmount.ToString();
        NetAmount = NetAmount + Util.GetDouble(txtFreight.Text) + Util.GetDouble(txtRoundOff.Text) - Util.GetDouble(txtScheme.Text);
        txtInvoiceAmount.Text = Math.Round(Util.GetDecimal(NetAmount), 2).ToString();
        lblCurreny_Amount.Text = txtInvoiceAmount.Text;
        txtCurreny_Amount.Text = txtInvoiceAmount.Text;
    }

    #endregion

    #region Data Validation
    private bool ValidateUpdate()
    {
        if (Util.GetDecimal(txtDiscount.Text.Trim()) > 100)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM039','" + lblMsg.ClientID + "');", true);
            return false;
        }
        if (Util.GetDecimal(txtOrderQty.Text.Trim()) > Util.GetDecimal(lblOrderQty.Text.Trim()))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM040','" + lblMsg.ClientID + "');", true);
            return false;
        }
        if (Util.GetDecimal(txtRate.Text.Trim()) < 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM041','" + lblMsg.ClientID + "');", true);
            return false;
        }
        return true;
    }
    private bool ValidateSaveData()
    {
        int itemcount = 0;

        if (ucValidDate.Text.ToString() != string.Empty)
            if (Util.GetDateTime(ucValidDate.Text) < Util.GetDateTime(DateTime.Now.Date))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM042','" + lblMsg.ClientID + "');", true);
                return false;
            }
        if (Util.GetDateTime(ucPODate.Text).ToString("yyyy-MM-dd") != string.Empty)
            if (Util.GetDateTime(ucPODate.Text) > DateTime.Now.Date)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM043','" + lblMsg.ClientID + "');", true);
                return false;
            }

        if ((ViewState["dsItems"] != null) && (ddlVendor.SelectedValue != "0"))
        {
            DataSet ds = (DataSet)ViewState["dsItems"];
            DataTable dtItems = ds.Tables["ItemsDetail"];

            DataTable dtTax = new DataTable();
            if (ds.Tables.Contains("TaxDetail"))
                dtTax = ds.Tables["TaxDetail"];

            if (dtItems.Rows.Count > 0)
            {
                for (int i = 0; i < gvItems.Rows.Count; i++)
                {

                    bool status = ((CheckBox)gvItems.Rows[i].FindControl("chkSelect")).Checked;
                    dtItems.Rows[i]["Save"] = status;
                    if (status)
                        itemcount += 1;
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
                return false;
            }
        }
        else
            return false;


        if (itemcount == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return false;
        }
        return true;
    }
    #endregion   

    private string SaveHSData(string type_id)
    {
        if (ValidateSaveData())
        {
            decimal NetAmount = 0;
            int IsAllRowsInserted = 0;
            DataTable dtHS = (DataTable)ViewState["dtHS"];
            if (dtHS.Rows.Count > 0)
            {
                for (int i = 0; i < dtHS.Rows.Count; i++)
                {
                    NetAmount = NetAmount + Util.GetDecimal(dtHS.Rows[i]["NetAmount"]);
                    IsAllRowsInserted += 1;
                }
            }

            string HSPoNumber = string.Empty;

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

            try
            {
            HSPoNumber = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "Select get_po_number('" + type_id + "','" + ViewState["DeptLedgerNo"].ToString() + "')"));
                DateTime ByDate = Util.GetDateTime("01-Jan-0001");
                if (bydate.Visible == true)
                    ByDate = Convert.ToDateTime(Util.GetDateTime(bydate.Text).ToString("yyyy-MM-dd"));

                //Insert into Purchase Request Master  (1 rows effect)
                PurchaseOrderMaster iMst = new PurchaseOrderMaster(Tnx);
                iMst.Subject = txtNarration.Text.Trim();
                iMst.Remarks = txtRemarks.Text.Trim();
                iMst.VendorID = ddlVendor.SelectedValue;
                iMst.VendorName = ddlVendor.SelectedItem.Text;
                if (ucPODate.Text != string.Empty)
                    iMst.RaisedDate = Convert.ToDateTime(Util.GetDateTime((ucPODate.Text)).ToString("yyyy-MM-dd"));
                else
                    iMst.RaisedDate = DateTime.Now;
                iMst.RaisedUserID = Convert.ToString(Session["ID"]);
                iMst.RaisedUserName = Convert.ToString(Session["UserName"]);
                iMst.ValidDate = Convert.ToDateTime(Util.GetDateTime((ucValidDate.Text)).ToString("yyyy-MM-dd"));
                iMst.NetTotal = NetAmount + Util.GetDecimal(txtFreight.Text.Trim()) + Util.GetDecimal(txtRoundOff.Text.Trim()) - Util.GetDecimal(txtScheme.Text.Trim()) + Util.GetDecimal(txtExciseOnBill.Text);
                iMst.GrossTotal = NetAmount;
                iMst.Freight = Util.GetDecimal(txtFreight.Text.Trim());
                iMst.RoundOff = Util.GetDecimal(txtRoundOff.Text.Trim());
                iMst.Scheme = Util.GetDecimal(txtScheme.Text.Trim());
                iMst.Type = ddlPOType.SelectedItem.Text;
                iMst.ByDate = ByDate;
                iMst.ExciseOnBill = Util.GetDecimal(txtExciseOnBill.Text);
                //For Other Currency
                iMst.S_Amount = Util.GetDecimal(txtCurreny_Amount.Text);

                iMst.S_CountryID = Util.GetInt(ddlCurrency.SelectedItem.Value);
                iMst.S_Currency = Util.GetString(ddlCurrency.SelectedItem.Text);
                AllSelectQuery ASQ = new AllSelectQuery();
                iMst.C_Factor = ASQ.GetConversionFactor(Util.GetInt(ddlCurrency.SelectedItem.Value));
                iMst.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                if (rdoItemType.SelectedValue == "11")
                    iMst.StoreLedgerNo = "STO00001";
                else
                    iMst.StoreLedgerNo = "STO00002";
                
                iMst.PoNumber = HSPoNumber;
                iMst.Hospital_ID = Session["HOSPID"].ToString();
                iMst.CentreID = Util.GetInt(Session["CentreID"].ToString());
                iMst.IPAddress = HttpContext.Current.Request.UserHostAddress;
                HSPoNumber = iMst.Insert();
                if (HSPoNumber == string.Empty)
                {
                    Tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }
                if (ViewState["dtTerms"] != null)
                {

                    DataTable dtCondition = (DataTable)ViewState["dtTerms"];
                    for (int i = 0; i < dtCondition.Rows.Count; i++)
                    {
                        PurchaseOrderTerms POM = new PurchaseOrderTerms(Tnx);
                        POM.PONumber = HSPoNumber;
                        POM.Details = Util.GetString(dtCondition.Rows[i]["Terms"]);
                        POM.InsertTerms();
                    }
                }
                DataSet ds = (DataSet)ViewState["dsItems"];

                DataTable dtItem = ds.Tables["ItemsDetail"];
                DataTable dtTax = ds.Tables["TaxDetail"];

                foreach (DataRow row in dtHS.Rows)
                {
                    if (Util.GetBoolean(row["Save"]))
                    {

                        //-------------------------
                        if (Util.GetString(row["IsFree"]) != "true")
                        {
                            string sql = " SELECT a.ApprovedQty-ifnull(b.OrderedQty,0) PendingQty  FROM " +
                                            " (SELECT ITemID,ApprovedQty FROM  f_purchaserequestdetails  " +
                                            " WHERE PurchaseRequisitionNo='" + Util.GetString(row["PurchaseRequisitionNo"]) + "' AND ITemID='" + Util.GetString(row["ItemID"]) + "' )a " +
                                            " LEFT OUTER JOIN  " +
                                            " ( SELECT ITemID,SUM(OrderedQty)OrderedQty FROM  f_purchaseorderpurchaserequest  " +
                                            " WHERE PRNumber='" + Util.GetString(row["PurchaseRequisitionNo"]) + "' AND ITemID='" + Util.GetString(row["ItemID"]) + "' GROUP BY ITemID )b " +
                                            " ON a.ITemID = b.ITemID  ";

                            //------------------------

                            double PendingQty = Util.GetDouble(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, sql));
                            if (PendingQty < Util.GetDouble(row["OrderQty"]))
                            {
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM033','" + lblMsg.ClientID + "');", true);
                                Tnx.Rollback();
                                con.Close();
                                con.Dispose();
                                return string.Empty;
                            }

                        }
                        int PODDetail = 0;
                        string PRID = Util.GetString(row["PuschaseRequistionDetailID"]);
                        //PurchaseOrderDetail POD = new PurchaseOrderDetail(Tnx);
                        PurchaseOrderDetail POD = new PurchaseOrderDetail(Tnx);
                        POD.ItemID = Util.GetString(row["ItemID"]);
                        POD.ItemName = Util.GetString(row["ItemName"]);
                        POD.PurchaseOrderNo = HSPoNumber;
                        POD.OrderedQty = Util.GetDecimal(row["OrderQty"]);
                        POD.Rate = Util.GetDecimal(row["ApproxRate"]);
                        POD.MRP = Util.GetDecimal(row["MRP"]);
                        POD.QoutationNo = string.Empty;
                        POD.SubCategoryID = Util.GetString(row["SubCategoryID"]);
                        POD.Status = 0;
                        POD.Unit = Util.GetString(row["Unit"]);
                        if (Util.GetBoolean(row["IsFree"]))
                            POD.IsFree = 1;
                        else
                            POD.IsFree = 0;
                        POD.ApprovedQty = Util.GetDecimal(row["OrderQty"]);
                        POD.BuyPrice = Util.GetDecimal(row["BuyPrice"]);
                        POD.Amount = POD.ApprovedQty * POD.BuyPrice;
                        POD.Discount_p = Util.GetDecimal(row["Discount"]);
                        POD.RecievedQty = 0;
                        POD.Status = 0;
                        POD.Specification = Util.GetString(row["Specification"]);
                        POD.Hospital_ID = Session["HOSPID"].ToString();
                        POD.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        PODDetail = POD.Insert();
                        IsAllRowsInserted -= 1;
                        if (PODDetail == 0)
                        {
                            Tnx.Rollback();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        if (!Util.GetBoolean(row["IsFree"]))
                        {
                            int result = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "call PR_Status('" + Util.GetString(row["PurchaseRequisitionNo"]) + "','" + Util.GetString(row["PuschaseRequistionDetailID"]) + "'," + Util.GetDecimal(row["OrderQty"]) + ");");

                            PurchaseOrderPurchaseRequest POP = new PurchaseOrderPurchaseRequest(Tnx);
                            POP.PONumber = HSPoNumber;
                            POP.PRNumber = Util.GetString(row["PurchaseRequisitionNo"]);
                            POP.ITemID = Util.GetString(row["ItemID"]);
                            POP.OrderedQty = Util.GetDecimal(row["OrderQty"]);
                            POP.PODetailID = PODDetail;
                            POD.Hospital_ID = Session["HOSPID"].ToString();
                            POD.CentreID = Util.GetInt(Session["CentreID"].ToString());
                            POP.InsertPoPr();
                        }
                        DataRow[] drTax = dtTax.Select("PRDetailID = '" + PRID + "'");
                        if (drTax.Length > 0)
                        {
                            foreach (DataRow drow in drTax)
                            {
                                PurchaseOrderTax poTax = new PurchaseOrderTax(Tnx);
                                poTax.PODetailID = PODDetail;
                                poTax.PONumber = HSPoNumber;
                                poTax.ITemID = Util.GetString(row["ItemID"]);
                                poTax.TaxID = Util.GetString(drow["TaxID"]);
                                poTax.TaxPer = (decimal)Math.Round(Util.GetDouble(drow["TaxPer"]), 2);
                                poTax.TaxAmt = (decimal)Math.Round(Util.GetDouble(drow["TaxAmt"]), 2);
                                int Tax = poTax.InsertTax();
                                if (Tax == 0)
                                {
                                    Tnx.Rollback();
                                    con.Close();
                                    con.Dispose();
                                    return string.Empty;
                                }
                            }
                        }
                    }
                }

                if (IsAllRowsInserted == 0)
                {
                    Tnx.Commit();
                    Tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return HSPoNumber;
                }
                else
                {
                    Tnx.Rollback();
                    Tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM045','" + lblMsg2.ClientID + "');", true);
                    return string.Empty;
                }
            }
            catch (Exception ex)
            {
                Tnx.Rollback();
                Tnx.Dispose();
                con.Close();
                con.Dispose();
                lblMsg2.Text = ex.Message;
                return string.Empty;
            }

        }
        return string.Empty;
    }

    public void BindAmount()
    {
        
        DataSet ds = new DataSet();
        ds = (DataSet)ViewState["dsItems"];
        if (ds == null)
            return;

        for (int i = 0; i < ds.Tables["ItemsDetail"].Rows.Count; i++)
        {
            decimal rate = Util.GetDecimal(ds.Tables["ItemsDetail"].Rows[i]["ApproxRate"]);
            decimal disc = Util.GetDecimal(ds.Tables["ItemsDetail"].Rows[i]["Discount"]);
            decimal qty = Util.GetDecimal(ds.Tables["ItemsDetail"].Rows[i]["OrderQty"]);

            DataRow[] dr = ds.Tables["TaxDetail"].Select("PRDetailID='" + ds.Tables["ItemsDetail"].Rows[i]["PuschaseRequistionDetailID"].ToString() + "'");

            DataTable dtNew = new DataTable();
            dtNew = ds.Tables["TaxDetail"].Clone();


            foreach (DataRow dr1 in dr)
            {
                dtNew.ImportRow(dr1);
            }
            dtNew.AcceptChanges();           
            AmountCalculation objAmountCalculation = new AmountCalculation();
            rate = objAmountCalculation.getAmount(rate, disc, dtNew);          
            ds.Tables["ItemsDetail"].Rows[i]["NetAmount"] = Util.GetDouble(rate * qty) + "";
            ds.Tables["ItemsDetail"].Rows[i]["BuyPrice"] = Util.GetDouble(rate) + "";
        }
        BindItemsDetail();
    }

    #region Clear Screen
    private void Clear()
    {
        gvItems.DataSource = null;
        gvItems.DataBind();
        gvTerms.DataSource = null;
        gvTerms.DataBind();
        txtFreight.Text = string.Empty;
        txtNarration.Text = string.Empty;
        txtRemarks.Text = string.Empty;
        lblVendorDetails.Text = string.Empty;
        ViewState.Clear();
        BindVendor();
        pnlItems.Visible = false;
    }
    #endregion

    protected void ddlPOType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPOType.SelectedIndex == 3)
        {
            bydate.Visible = true;
            bydate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        }
        else
        { bydate.Visible = false; }
    }
    protected void btnLoadItem_Click(object sender, EventArgs e)
    {
        BindItem();
    }
    protected void btnSaveSet_Click(object sender, EventArgs e)
    {
        DataTable dtTerms = (DataTable)ViewState["dtTermsSet"];

        if (dtTerms != null && dtTerms.Rows.Count > 0)
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);


            try
            {
                MySqlParameter CDNo = new MySqlParameter();
                CDNo.ParameterName = "@TermID";
                CDNo.MySqlDbType = MySqlDbType.String;
                CDNo.Size = 11;
                CDNo.Direction = ParameterDirection.Output;
                MySqlCommand cmd = new MySqlCommand("PoTerm", con, Tnx);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(CDNo);
                string TermID = Util.GetString(cmd.ExecuteScalar());


                foreach (DataRow dr in dtTerms.Rows)
                {
                    string str = "insert into f_purchaseordertermsSets (PoTermsSetID,TermSetName,Details) values ('" + TermID + "','" + dr["SetName"].ToString() + "','" + dr["Terms"].ToString() + "') ";
                    int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                }

                Tnx.Commit();
               
                txtsetTerms.Enabled = true;
                txtDetailTerms.Text = "";
                grdSetterm.DataSource = null;
                grdSetterm.DataBind();
                BindTerms();
                lblTermsErr.Text = "";
                ViewState["dtTermsSet"] = null;

            }
            catch (Exception ex)
            {
                Tnx.Rollback();
                
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
            finally
            {
                Tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            lblTermsErr.Text = "Enter Term Set";
            mpEnterSet.Show();
            return;
        }
    }

    protected void btnAddSet_Click(object sender, EventArgs e)
    {
        txtsetTerms.Text = "";
        txtDetailTerms.Text = "";
        grdSetterm.DataSource = null;
        grdSetterm.DataBind();
        mpEnterSet.Show();
    }
    protected void grdSetterm_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtTerms = (DataTable)ViewState["dtTermsSet"];
            dtTerms.Rows[args].Delete();
            grdSetterm.DataSource = dtTerms;
            grdSetterm.DataBind();
            ViewState["dtTermsSet"] = dtTerms;
        }
    }

    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (txtsetTerms.Text == "")
        {
            lblTermsErr.Text = "Enter Term Set Name";
            mpEnterSet.Show();
            return;
        }
        if (txtDetailTerms.Text == "")
        {
            lblTermsErr.Text = "Enter Term Set Detail";
            mpEnterSet.Show();
            return;
        }
        DataTable dtTerms;

        if (ViewState["dtTermsSet"] != null)
            dtTerms = (DataTable)ViewState["dtTermsSet"];
        else
        {
            dtTerms = new DataTable();
            dtTerms.Columns.Add("SetName");
            dtTerms.Columns.Add("Terms");
        }

        DataRow row = dtTerms.NewRow();
        row["SetName"] = Util.GetString(txtsetTerms.Text.ToString());
        row["Terms"] = Util.GetString(txtDetailTerms.Text.ToString());
        dtTerms.Rows.Add(row);
        grdSetterm.DataSource = dtTerms;
        grdSetterm.DataBind();
        ViewState["dtTermsSet"] = dtTerms;
        txtsetTerms.Enabled = false;
        txtDetailTerms.Text = "";
        lblTermsErr.Text = "";
        mpEnterSet.Show();

    }
    private bool validateGrid()
    {
        int status = 0;
        foreach (GridViewRow gr in gvItems.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelect")).Checked)
            {
                status = 1;
                break;
            }
        }
        if (status == 1)
            return true;
        else
            return false;
    }
}
