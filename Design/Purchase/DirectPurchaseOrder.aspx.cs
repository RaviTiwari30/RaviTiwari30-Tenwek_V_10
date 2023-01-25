using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Collections.Generic;
using System.Web.Services;
public partial class Design_Purchase_DirectPurchaseOrder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            int CentreID = Util.GetInt(Session["CentreID"].ToString());

            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
               // if (ChkRights())
              //  {
               //     string Msg = "You do not have rights to generate purchase Order ";
               //     Response.Redirect("MsgPage.aspx?msg=" + Msg);
              //  }

                BindVendor(0);


                AllLoadData_Store.bindTypeMaster(ddlPOType);
                ScriptManager1.SetFocus(ddlVendor);
                txtPODate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtValidDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDeliveryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtInvoiceAmount.Attributes.Add("readonly", "readonly");
                txtFreight.Attributes.Add("onkeyup", "sum();");
                txtScheme.Attributes.Add("onkeyup", "sum();");
                txtRoundOff.Attributes.Add("onkeyup", "sum();");
                txtExciseOnBill.Attributes.Add("onkeyup", "sum();");
                LoadCurrencyDetail();
                CalendarExtender1.StartDate = DateTime.Now;
                CalendarExtender2.StartDate = DateTime.Now;
                CalendarExtender3.StartDate = DateTime.Now;
                BindGST();
                Session.Remove("ITEM");
            }
        }
        txtPODate.Attributes.Add("readOnly", "readOnly");
        txtValidDate.Attributes.Add("readOnly", "readOnly");
        txtDeliveryDate.Attributes.Add("readOnly", "readOnly");
    }
    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rblStoreType.Items[0].Enabled = false;
        rblStoreType.Items[1].Enabled = false;

        DataTable dt1 = StockReports.GetPurchaseApproval("PO", EmpId);
        if (dt1 != null && dt1.Rows.Count > 0)
        {
            DataTable dt = StockReports.GetRights(RoleId);
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
                    rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
                }
                return false;
            }
            else { return true; }
        }
        else { return true; }
    }

    public void BindGrid()
    {
        DataTable dtItem = (DataTable)ViewState["ITEM"];
        gvPODetails.DataSource = dtItem;
        gvPODetails.DataBind();
        UpdatePOAmount();
    }

    public void BindVendor(int isAsset)
    {
        //string sql = "select CONCAT(LedgerNumber,'#',LedgerUserID)ID,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName";
        string sql = "SELECT CONCAT(LedgerNumber,'#',LedgerUserID)ID,LedgerName FROM f_ledgermaster INNER JOIN f_vendormaster ON f_vendormaster.`Vendor_ID`=f_ledgermaster.`LedgerUserID` WHERE groupID='VEN' AND IsCurrent=1 AND IsAsset='" + isAsset + "' ORDER BY LedgerName";

        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "ID";
            ddlVendor.DataBind();

            ddlVendor.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
        }
    }

    public static DataTable getItemDT()
    {
        if (HttpContext.Current.Session["ITEM"] != null)
        {
            return (DataTable)HttpContext.Current.Session["ITEM"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("VendorID");
            dtItem.Columns.Add("VendorName");
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("SubCategoryID");
            dtItem.Columns.Add("Rate");
            dtItem.Columns.Add("BuyPrice");
            dtItem.Columns.Add("Unit");
            dtItem.Columns.Add("OrderQty");
            dtItem.Columns.Add("DiscPer");
            dtItem.Columns.Add("InHandQty");
            dtItem.Columns.Add("TaxPer");
            // dtItem.Columns.Add("TaxAmt");
            // dtItem.Columns.Add("TaxID");
            dtItem.Columns.Add("SaleTaxPer");
            dtItem.Columns.Add("NetAmt");
            dtItem.Columns.Add("Manufacturer");
            dtItem.Columns.Add("ManufactureID");
            dtItem.Columns.Add("Type_ID");
            dtItem.Columns.Add("Free");
            dtItem.Columns.Add("GSTPer");
            dtItem.Columns.Add("GSTAmt");
            dtItem.Columns.Add("TaxCalulatedOn");
            // GST Changes
            dtItem.Columns.Add("GSTType", typeof(string));
            dtItem.Columns.Add("HSNCode", typeof(string));
            dtItem.Columns.Add("IGSTPercent", typeof(decimal));
            dtItem.Columns.Add("IGSTAmt", typeof(decimal));
            dtItem.Columns.Add("CGSTPercent", typeof(decimal));
            dtItem.Columns.Add("CGSTAmt", typeof(decimal));
            dtItem.Columns.Add("SGSTPercent", typeof(decimal));
            dtItem.Columns.Add("SGSTAmt", typeof(decimal));
            dtItem.Columns.Add("ConFact");
            //
            //Deal Work
            dtItem.Columns.Add("IsDeal");
            //
            return dtItem;
        }
    }

    protected void btnSaveItems_Click(object sender, EventArgs e)
    {
        if (txtRate1.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Rate";
            txtRate1.Focus();
            return;
        }
        if (ddlVendor.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Vendor";
            ddlVendor.Focus();
            return;
        }
        if (ListBox1.SelectedIndex == -1)
        {
            lblMsg.Text = "Please Select the Item";
            txtSearch.Focus();
            return;
        }
        if (Util.GetDecimal(txtQuantity1.Text) == 0)
        {
            lblMsg.Text = "Please Enter quantity greater than Zero";
            txtSearch.Focus();
            return;
        }
        lblMsg.Text = "";
        DataTable dtItem = getItemDT();
        DataRow[] dr1 = dtItem.Select("ItemID = '" + ListBox1.SelectedItem.Value.Split('#')[0] + "' ");
        string strItemInfo = " SELECT im.ItemID,im.MajorUnit,im.ManuFacturer,im.ManufactureID   FROM f_itemmaster im  WHERE im.ItemID='" + ListBox1.SelectedItem.Value.Split('#')[0] + "' ";
        DataTable dtItemInfo = StockReports.GetDataTable(strItemInfo);
        decimal NetAmount = 0;
        //decimal BuyPrice = 0;
        decimal perUnitPrice = 0;
        decimal GSTAmt = 0;
        string Amt = "";
        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
         {
           new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer=Util.GetDecimal(txtDiscount1.Text), MRP=Util.GetDecimal(0),Quantity = Util.GetDecimal(txtQuantity1.Text),Rate=Util.GetDecimal(txtRate1.Text),TaxPer =Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text),Type = Util.GetString(lblTaxCalculatedOn.Text.Trim()),IGSTPrecent=Util.GetDecimal(txtIGSTPer.Text.Trim()),CGSTPercent=Util.GetDecimal(txtCGSTPer.Text.Trim()),SGSTPercent=Util.GetDecimal(txtSGSTPer.Text.Trim())}
         };
        Amt = AllLoadData_Store.taxCalulation(taxCalculate);
        perUnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString());
        NetAmount = Util.GetDecimal(Amt.Split('#')[0].ToString());
        string a = lblConFactor.Text;
        GSTAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
        DataRow row = dtItem.NewRow();
        row["VendorID"] = ddlVendor.SelectedValue.Split('#')[0];
        row["VendorName"] = ddlVendor.SelectedItem.Text;
        row["ItemID"] = ListBox1.SelectedItem.Value.Split('#')[0];
        row["ItemName"] = ListBox1.SelectedItem.Text.Split('#')[0];
        row["SubCategoryID"] = ListBox1.SelectedValue.Split('#')[1];
        row["TaxCalulatedOn"] = lblTaxCalculatedOn.Text.Trim();
        row["Unit"] = dtItemInfo.Rows[0]["MajorUnit"];
        row["InHand Qty"] = GetInHandQty(ListBox1.SelectedItem.Value.Split('#')[0]);
        row["Free"] = rbtnFree.SelectedItem.Value;
        if (rbtnFree.SelectedItem.Value == "0")
        {
            row["Rate"] = txtRate1.Text;
            row["BuyPrice"] = perUnitPrice;
            row["Order Qty"] = txtQuantity1.Text;
            row["NetAmt"] = NetAmount;
            row["GSTPer"] = Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text);
            row["GSTAmt"] = GSTAmt;
            row["DiscPer"] = txtDiscount1.Text;
        }
        else
        {
            row["Rate"] = 0;
            row["BuyPrice"] = 0;
            row["Order Qty"] = txtQuantity1.Text;
            row["NetAmt"] = 0;
            row["GSTPer"] = 0;
            row["GSTAmt"] = 0;
            row["DiscPer"] = 0;
        }
        row["SaleTaxPer"] = ddlTax1.SelectedItem.Text;
        row["Manufacturer"] = dtItemInfo.Rows[0]["ManuFacturer"];
        row["ManufactureID"] = dtItemInfo.Rows[0]["ManufactureID"];
        row["Type_ID"] = "HS";
        // GST Changes
        row["GSTType"] = Util.GetString(ddlGST.SelectedItem.Text);
        row["HSNCode"] = Util.GetString(txtHSNCode.Text);
        row["IGSTPercent"] = Util.GetDecimal(txtIGSTPer.Text);
        row["IGSTAmt"] = Util.GetDecimal(Amt.Split('#')[8].ToString());
        row["CGSTPercent"] = Util.GetDecimal(txtCGSTPer.Text);
        row["CGSTAmt"] = Util.GetDecimal(Amt.Split('#')[9].ToString());
        row["SGSTPercent"] = Util.GetDecimal(txtSGSTPer.Text);
        row["SGSTAmt"] = Util.GetDecimal(Amt.Split('#')[10].ToString());

        dtItem.Rows.Add(row);
        ViewState["ITEM"] = dtItem;
        if (dtItem != null)
        {
            gvPODetails.DataSource = dtItem;
            gvPODetails.DataBind();
            txtRate1.Text = string.Empty;
            txtVATPer.Text = string.Empty;
            txtExcisePer.Text = string.Empty;
            txtQuantity1.Text = string.Empty;
            txtDiscount1.Text = string.Empty;
            lblTaxID.Text = string.Empty;
            lblTaxCalculatedOn.Text = string.Empty;
            ddlVendor.Enabled = false;
            rblStoreType.Enabled = false;
            txtVATPer.Text = string.Empty;
            lblConFactor.Text = string.Empty;
            lblMajorUnit.Text = string.Empty;
            lblMinorUnit.Text = string.Empty;
            txtExcisePer.Text = string.Empty;
            rbtnFree.SelectedIndex = 1;
            ListBox1.SelectedIndex = -1;
            txtSearch.Focus();
        }
        UpdatePOAmount();
    }
    protected void btnSavePO_Click(object sender, EventArgs e)
    {
        string HSPoNumber = "";
        lblMsg.Text = "";
        if (ViewState["ITEM"] != null)
        {
            DataTable dtItems = (DataTable)ViewState["ITEM"];
            if (dtItems.Rows.Count > 0)
            {
                string type_id = "HS";
                //HSPoNumber = SaveHSData(type_id);
            }
            else
            {
                lblMsg.Text = "Please Add Item";
                return;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM018','" + lblMsg.ClientID + "')", true);
            ddlVendor.Focus();
            return;
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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('PurchaseOrder No. : " + HSPoNumber + "');", true);
            if (chkPrintImg.Checked == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('POReport.aspx?PONumber=" + HSPoNumber + "&ImageToPrint=" + ImagesToprint + "');location.href='DirectPurchaseOrder.aspx';", true);
            }
            //Clear();
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    }
    protected void ddlPOType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPOType.SelectedItem.Text.ToString() == "Urgent")
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(3).ToString("dd-MMM-yyyy");
        else
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(7).ToString("dd-MMM-yyyy");
    }
    protected void gvPODetails_RowDeleting1(object sender, GridViewDeleteEventArgs e)
    {
        DataTable dtt = ((DataTable)ViewState["ITEM"]);
        dtt.Rows[e.RowIndex].Delete();
        ViewState["ITEM"] = dtt;
        gvPODetails.DataSource = dtt;
        gvPODetails.DataBind();
        if (gvPODetails.Rows.Count == 0)
        {
            ddlVendor.Enabled = true;
            ListBox1.SelectedIndex = -1;
        }
        UpdatePOAmount();
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
    private void BindItem()
    {
        DataTable dtItem = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(IM.Typename,' # ','(',SM.name,')')ItemName,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.UnitType,''))ItemID ");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID ");
        sb.Append(" INNER JOIN f_storeitem_rate sir ON sir.ItemID=im.itemID ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID ");
        sb.Append(" WHERE c.ConfigID IN (28,11) AND IM.IsActive=1 and Typename<>'' ");
        sb.Append(" AND sir.IsActive=1 AND sir.Vendor_ID='" + ddlVendor.SelectedValue.Split('#')[0] + "' and StoreType='" + rblStoreType.SelectedItem.Value + "'");
        sb.Append(" order by IM.Typename ");
        dtItem = StockReports.GetDataTable(sb.ToString());
        ViewState["dtItem"] = dtItem;
        if (dtItem.Rows.Count > 0)
        {
            ListBox1.DataSource = dtItem;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            ListBox1.Items.Clear();
            lblMsg.Text = "No Record Found";
        }
    }
    private void Clear()
    {
        gvPODetails.DataSource = null;
        gvPODetails.DataBind();
        txtFreight.Text = string.Empty;
        txtNarration.Text = string.Empty;
        txtRemarks.Text = string.Empty;
        txtDiscount1.Text = string.Empty;
        txtRate1.Text = string.Empty;
        txtVATPer.Text = string.Empty;
        txtExcisePer.Text = string.Empty;
        ddlVendor.Enabled = true;
        ddlVendor.SelectedIndex = 0;
        txtQuantity1.Text = string.Empty;
        ViewState.Clear();
        ListBox1.Items.Clear();
    }
    private void BindGST()
    {
        string sql = "SELECT TaxName,TaxID FROM f_taxmaster WHERE TaxID IN ('T4','T6','T7') ORDER BY TaxName";

        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            ddlGST.DataSource = dt;
            ddlGST.DataTextField = "TaxName";
            ddlGST.DataValueField = "TaxID";
            ddlGST.DataBind();
            ddlGST.SelectedIndex = ddlGST.Items.IndexOf(ddlGST.Items.FindByValue("T4"));
        }
        else
        {
            ddlGST.Items.Clear();
            ddlGST.Items.Add("No Item Found");

        }
    }

    private void UpdatePOAmount()
    {
        double NetAmount = 0f;
        foreach (GridViewRow gr in gvPODetails.Rows)
        {
            string str = ((Label)gr.FindControl("lblNetAmt")).Text;
            double amt = Util.GetDouble(((Label)gr.FindControl("lblNetAmt")).Text);
            NetAmount += Util.GetDouble(((Label)gr.FindControl("lblNetAmt")).Text);
        }
        lbl.Text = NetAmount.ToString();
        NetAmount = NetAmount + Util.GetDouble(txtFreight.Text) + Util.GetDouble(txtRoundOff.Text) - Util.GetDouble(txtScheme.Text);
        txtInvoiceAmount.Text = Math.Round(Util.GetDecimal(NetAmount), 2).ToString();
        lblCurreny_Amount.Text = NetAmount.ToString();
        txtCurreny_Amount.Text = Math.Round(Util.GetDecimal(NetAmount), 2).ToString();
    }

    [WebMethod(EnableSession = true)]
    public static string BindSearchItem(string VendorType, string StoreType, string PreFix, int chkAsset)
    {
        DataTable dtItem = new DataTable();
        StringBuilder sb = new StringBuilder();
   
            sb.Append(" SELECT Typename,CONCAT(IM.Typename,' # ','(',SM.name,')')ItemName,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.UnitType,''))ItemID ");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
            sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID ");
            sb.Append(" LEFT JOIN f_storeitem_rate sir ON sir.ItemID=im.itemID AND sir.IsActive=1 AND sir.Vendor_ID='" + VendorType.ToString() + "'");
            sb.Append(" left JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID ");
            sb.Append(" WHERE c.ConfigID IN (28,11) AND IM.IsActive=1 and Typename<>'' ");
            if (StoreType.ToString() == "STO00001")
            {
                sb.Append("  and  C.`ConfigID`=11 ");
            }
            else
            {
                sb.Append("  and  C.`ConfigID`=28 ");
            }
           
            sb.Append("  and IM.IsAsset='" + chkAsset + "'");
            sb.Append(" order by IM.Typename ");
       
        dtItem = StockReports.GetDataTable(sb.ToString());

        if (dtItem.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtItem"] = dtItem;
            var dt = dtItem;
            DataView DvInvestigation = dt.AsDataView();
            string filter = string.Empty;
            if (!string.IsNullOrEmpty(PreFix))
            {
                filter = "Typename LIKE '%" + PreFix + "%'";
                DvInvestigation.RowFilter = filter;
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
        }
        else
        {
            return "1";
        }

    }

    [WebMethod(EnableSession = true)]
    public static string BindItem(string VendorType, string StoreType, string PreFix)
    {
        DataTable dtItem = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Typename,CONCAT(IM.Typename,' # ','(',SM.name,')')ItemName,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.UnitType,''))ItemID ");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID ");
        sb.Append(" INNER JOIN f_storeitem_rate sir ON sir.ItemID=im.itemID ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID ");
        sb.Append(" WHERE c.ConfigID IN (28,11) AND IM.IsActive=1 and Typename<>'' ");
        sb.Append(" AND sir.IsActive=1 AND sir.Vendor_ID='" + VendorType.ToString() + "' and StoreType='" + StoreType.ToString() + "'");
        sb.Append(" order by IM.Typename ");
        dtItem = StockReports.GetDataTable(sb.ToString());

        if (dtItem.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtItem"] = dtItem;
            var dt = dtItem;
            DataView DvInvestigation = dt.AsDataView();
            string filter = string.Empty;
            if (!string.IsNullOrEmpty(PreFix))
            {
                filter = "Typename LIKE '%" + PreFix + "%'";
                DvInvestigation.RowFilter = filter;
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
        }
        else
        {
            return "1";
        }

    }

    [WebMethod(EnableSession = true)]
    public static string SaveItems(string ItemId, string SubCategoryID, string ItemName, string VendorId, string VendorName, string GstType, string TaxCalOn, string Free, string Quantity, string Discount, string Rate1, string Igst, string Cgst, string Sgst, string HsnCode, string Tax, string Confactor, string Deal1, string Deal2)
    {
        DataTable dtItem = getItemDT();
        DataRow[] dr1 = dtItem.Select("ItemID = '" + ItemId + "' ");
        string strItemInfo = " SELECT im.ItemID,im.MajorUnit,im.ManuFacturer,im.ManufactureID   FROM f_itemmaster im  WHERE im.ItemID='" + ItemId + "' ";
        DataTable dtItemInfo = StockReports.GetDataTable(strItemInfo);
        decimal NetAmount = 0;
        decimal perUnitPrice = 0;
        decimal GSTAmt = 0;
        string Amt = "";
        decimal rate = Util.GetDecimal(Rate1);
        if (Deal1 != string.Empty)
        {
            int deal = Util.GetInt(Deal1) + Util.GetInt(Deal2);
            rate = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(Quantity) * Util.GetDecimal(rate)) / Util.GetDouble(deal));
        }

        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
         {
           new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer=Util.GetDecimal(Discount.ToString()), MRP=Util.GetDecimal(0),Quantity = Util.GetDecimal(Quantity.ToString()),Rate=Util.GetDecimal(rate),TaxPer =Util.GetDecimal(Igst.ToString()) + Util.GetDecimal(Cgst.ToString()) + Util.GetDecimal(Sgst.ToString()),Type = Util.GetString(TaxCalOn.Trim().ToString()),IGSTPrecent=Util.GetDecimal(Igst.Trim().ToString()),CGSTPercent=Util.GetDecimal(Cgst.Trim()),SGSTPercent=Util.GetDecimal(Sgst.Trim()),deal =Util.GetDecimal(Deal1),deal2= Util.GetDecimal(Deal2),ActualRate=Util.GetDecimal(Rate1)}
         };
        Amt = AllLoadData_Store.taxCalulation(taxCalculate);
        perUnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString());
        NetAmount = Util.GetDecimal(Amt.Split('#')[0].ToString());
        string a = Confactor.ToString();
        GSTAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
        DataRow row = dtItem.NewRow();
        row["VendorID"] = VendorId.Split('#')[0];
        row["VendorName"] = VendorName;
        row["ItemID"] = ItemId;
        row["ItemName"] = ItemName;
        row["SubCategoryID"] = SubCategoryID;
        row["TaxCalulatedOn"] = TaxCalOn.Trim();
        row["Unit"] = dtItemInfo.Rows[0]["MajorUnit"];
        row["InHandQty"] = GetInHandQty(ItemId);
        row["Free"] = Free;
        if (Free == "0")
        {
            row["Rate"] = Rate1.ToString();
            row["BuyPrice"] = perUnitPrice;
            row["OrderQty"] = Quantity;
            row["NetAmt"] = NetAmount;
            row["GSTPer"] = Util.GetDecimal(Igst) + Util.GetDecimal(Cgst) + Util.GetDecimal(Sgst);
            row["GSTAmt"] = GSTAmt;
            row["DiscPer"] = Discount;
            row["IGSTAmt"] = Util.GetDecimal(Amt.Split('#')[8].ToString());
            row["CGSTAmt"] = Util.GetDecimal(Amt.Split('#')[9].ToString());
            row["SGSTAmt"] = Util.GetDecimal(Amt.Split('#')[10].ToString());
        }
        else
        {
            row["Rate"] = 0;
            row["BuyPrice"] = 0;
            row["OrderQty"] = Quantity;
            row["NetAmt"] = 0;
            row["GSTPer"] = 0;
            row["GSTAmt"] = 0;
            row["DiscPer"] = 0;
            row["IGSTAmt"] = 0;
            row["CGSTAmt"] = 0;
            row["SGSTAmt"] = 0;
        }
        row["SaleTaxPer"] = Tax;
        row["Manufacturer"] = dtItemInfo.Rows[0]["ManuFacturer"];
        row["ManufactureID"] = dtItemInfo.Rows[0]["ManufactureID"];
        row["Type_ID"] = "HS";
        // GST Changes
        row["GSTType"] = Util.GetString(GstType);
        row["HSNCode"] = Util.GetString(HsnCode.ToString());
        row["IGSTPercent"] = Util.GetDecimal(Igst);

        row["CGSTPercent"] = Util.GetDecimal(Cgst);

        row["SGSTPercent"] = Util.GetDecimal(Sgst);

        row["ConFact"] = Util.GetString(Confactor);
        if (Deal1 != "")
        {
            row["IsDeal"] = Deal1 + "+" + Deal2;
        }
        else
        {
            row["IsDeal"] = "";
        }
        dtItem.Rows.Add(row);
        HttpContext.Current.Session["ITEM"] = dtItem;
        if (dtItem != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtItem);
            //gvPODetails.DataSource = dtItem;
            //gvPODetails.DataBind();

        }
        else
        {
            return "";
        }
        //UpdatePOAmount();
    }

    [WebMethod(EnableSession = true)]
    public static string DeleteRow(string RowId)
    {
        int args = Util.GetInt(RowId.ToString());
        DataTable dtt = ((DataTable)HttpContext.Current.Session["ITEM"]);
        dtt.Rows[args].Delete();
        if (dtt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtItems"] = dtt;
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtt);
        }
        else
        {
            return "";
        }
        //gvPODetails.DataSource = dtt;
        //gvPODetails.DataBind();
        //if (gvPODetails.Rows.Count == 0)
        //{
        //    ddlVendor.Enabled = true;
        //    ListBox1.SelectedIndex = -1;
        //}
        //UpdatePOAmount();
    }

    public static decimal GetInHandQty(string ItemID)
    {
        string str = "";
        if (HttpContext.Current.Session["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            str = " Select sum(InitialCount-ReleasedCount)InHandQty from f_stock where ItemID = '" + ItemID + "'  ";
        else
            str = " Select sum(InitialCount-ReleasedCount)InHandQty from f_stock where ItemID = '" + ItemID + "'  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Util.GetDecimal(dt.Rows[0][0]);
        else
            return 0;
    }

    public static string SaveHSData(string type_id, string txtNarration, string txtRemarks, string txtPODate, string txtValidDate, string txtDeliveryDate, string txtFreight, string txtRoundOff, string txtScheme, string txtExciseOnBill, string ddlPOType, string rblStoreType, int chkasset)
    {
        decimal NetAmount = 0;
        DataTable dtHS = (DataTable)HttpContext.Current.Session["ITEM"];
        if (dtHS.Rows.Count > 0)
        {
            for (int i = 0; i < dtHS.Rows.Count; i++)
            {
                NetAmount = NetAmount + Util.GetDecimal(dtHS.Rows[i]["NetAmt"]);
            }
        }
        string HSPoNumber = string.Empty;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            HSPoNumber = StockReports.ExecuteScalar("Select get_po_number('" + type_id + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')");
            DateTime ByDate = Util.GetDateTime("01-Jan-0001");
            PurchaseOrderMaster iMst = new PurchaseOrderMaster(Tnx);
            iMst.Subject = txtNarration;
            iMst.Remarks = txtRemarks;
            iMst.VendorID = dtHS.Rows[0]["VendorID"].ToString();
            iMst.VendorName = dtHS.Rows[0]["VendorName"].ToString();
            if (txtPODate != string.Empty)
                iMst.RaisedDate = Util.GetDateTime(txtPODate);
            else
                iMst.RaisedDate = DateTime.Now;
            iMst.RaisedUserID = Convert.ToString(HttpContext.Current.Session["ID"]);
            iMst.RaisedUserName = Convert.ToString(HttpContext.Current.Session["UserName"]);
            iMst.ValidDate = Util.GetDateTime(txtValidDate);
            iMst.DeliveryDate = Util.GetDateTime(txtDeliveryDate);
            iMst.NetTotal = Util.GetDecimal(NetAmount) - Util.GetDecimal(txtFreight.Trim()) - Util.GetDecimal(txtRoundOff.Trim()) + Util.GetDecimal(txtScheme.Trim()) - Util.GetDecimal(txtExciseOnBill);
            iMst.GrossTotal = Util.GetDecimal(NetAmount);
            iMst.Freight = Util.GetDecimal(txtFreight.Trim());
            iMst.RoundOff = Util.GetDecimal(txtRoundOff.Trim());
            iMst.Scheme = Util.GetDecimal(txtScheme.Trim());
            iMst.Type = ddlPOType;
            iMst.ByDate = ByDate;
            iMst.ExciseOnBill = Util.GetDecimal(txtExciseOnBill);
            iMst.S_Amount = Util.GetDecimal(iMst.NetTotal);
            iMst.S_Amount = Util.GetDecimal(iMst.NetTotal);
            iMst.StoreLedgerNo = rblStoreType;
            iMst.DeptLedgerNo = Util.GetString(HttpContext.Current.Session["DeptLedgerNo"]);
            iMst.S_CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
            iMst.S_Currency = Util.GetString(Resources.Resource.BaseCurrencyNotation);
            AllSelectQuery ASQ = new AllSelectQuery();
            iMst.C_Factor = ASQ.GetConversionFactor(Util.GetInt(Resources.Resource.BaseCurrencyID));
            iMst.PoNumber = HSPoNumber;
            iMst.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            iMst.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            iMst.IsAsset = chkasset;
            HSPoNumber = iMst.Insert();
            if (HSPoNumber == string.Empty)
            {
                Tnx.Rollback();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            foreach (DataRow row in dtHS.Rows)
            {
                int PODDetail = 0;
                PurchaseOrderDetail POD = new PurchaseOrderDetail(Tnx);
                POD.ItemID = Util.GetString(row["ItemID"]);
                POD.ItemName = Util.GetString(row["ItemName"]);
                POD.PurchaseOrderNo = HSPoNumber;
                POD.OrderedQty = Util.GetDecimal(row["OrderQty"]);
                POD.Rate = Util.GetDecimal(row["Rate"]);
                POD.QoutationNo = string.Empty;
                POD.SubCategoryID = Util.GetString(row["SubCategoryID"]);
                POD.Status = 0;
                POD.ApprovedQty = Util.GetDecimal(row["OrderQty"]);
                POD.BuyPrice = Util.GetDecimal(row["BuyPrice"]);
                POD.Amount = POD.ApprovedQty * POD.BuyPrice;
                POD.Discount_p = Util.GetDecimal(row["DiscPer"]);
                POD.RecievedQty = 0;
                POD.Status = 0;
                POD.Specification = txtNarration;
                POD.Unit = Util.GetString(row["Unit"]);
                POD.IsFree = Util.GetInt(row["Free"]);
                POD.DeptLedgerNo = Util.GetString(HttpContext.Current.Session["DeptLedgerNo"]);
                POD.ExcisePercent = Util.GetDecimal(0);
                POD.ExciseAmt = Util.GetDecimal(0);
                POD.VATPercent = (decimal)Math.Round(Util.GetDecimal(row["GSTPer"]), 2);
                POD.VATAmt = (decimal)Math.Round(Util.GetDecimal(row["GSTAmt"]), 2);
                POD.StoreLedgerNo = rblStoreType;
                POD.TaxCalulatedOn = Util.GetString(row["TaxCalulatedOn"]);
                POD.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                POD.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                // GST Changes
                POD.GSTType = Util.GetString(row["GSTType"]);
                POD.HSNCode = Util.GetString(row["HSNCode"]);
                POD.IGSTPercent = Util.GetDecimal(row["IGSTPercent"]);
                POD.IGSTAmt = Util.GetDecimal(row["IGSTAmt"]);
                POD.CGSTPercent = Util.GetDecimal(row["CGSTPercent"]);
                POD.CGSTAmt = Util.GetDecimal(row["CGSTAmt"]);
                POD.SGSTPercent = Util.GetDecimal(row["SGSTPercent"]);
                POD.SGSTAmt = Util.GetDecimal(row["SGSTAmt"]);
                // ----
                //Deal Work
                POD.isDeal = Util.GetString(row["IsDeal"]);
                //
                PODDetail = POD.Insert();
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Util.GetString(HttpContext.Current.Session["DeptLedgerNo"]) + "'"));
                string notification = Notification_Insert.notificationInsert(31, PODDetail.ToString(), Tnx, "", "", roleID);
                if (PODDetail == 0)
                {
                    Tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }
            }
            Tnx.Commit();
            con.Close();
            con.Dispose();
            return HSPoNumber;
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog obj = new ClassLog();
            obj.errLog(ex);
            return string.Empty;
        }
    }

    [WebMethod]
    public static string SaveAllItems(string txtNarration, string txtRemarks, string txtPODate, string txtValidDate, string txtDeliveryDate, string txtFreight, string txtRoundOff, string txtScheme, string txtExciseOnBill, string ddlPOType, string rblStoreType, int ChkAsset)
    {
        string HSPoNumber = "";
        if (HttpContext.Current.Session["ITEM"] != null)
        {
            DataTable dtItems = (DataTable)HttpContext.Current.Session["ITEM"];
            if (dtItems.Rows.Count > 0)
            {
                string type_id = "HS";
                HSPoNumber = SaveHSData(type_id, txtNarration, txtRemarks, txtPODate, txtValidDate, txtDeliveryDate, txtFreight, txtRoundOff, txtScheme, txtExciseOnBill, ddlPOType, rblStoreType, ChkAsset);
            }
            else
            {
                return "1";
            }
        }
        else
        {
            return "2";
        }
        if (HSPoNumber != string.Empty)
        {
            HttpContext.Current.Session.Remove("ITEM");
            return HSPoNumber;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('PurchaseOrder No. : " + HSPoNumber + "');", true);
            //if (chkPrintImg.Checked == true)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('POReport.aspx?PONumber=" + HSPoNumber + "&ImageToPrint=" + ImagesToprint + "');location.href='DirectPurchaseOrder.aspx';", true);
            //}
        }
        else
        {
            return "3";
        }
    }
    protected void chkIsAsset_CheckedChanged(object sender, EventArgs e)
    {
        if (chkIsAsset.Checked == false)
        {
            BindVendor(0);
        }
        else { BindVendor(1); }
    }

    [WebMethod]
    public static string BindManufacturer()
    {
        string str1 = "select Name,ManufactureID from f_manufacture_master where IsActive = 1 order by Name";

        DataTable dt1 = new DataTable();
        dt1 = StockReports.GetDataTable(str1);

        if (dt1.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
        }
        else
            return "";

    }

    [WebMethod(EnableSession = true)]
    public static string BindAllSubcategory(string Category)
    {
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        dv.RowFilter = "categoryid='" + Category.ToString() + "'";
        if (dv.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string SaveProduct(string ItemId, string UcFromDate, string UcTodate, string Subcategory, string VendorId, string VendorName, string ItemName, string rate, string Tax, string IGST, string CGST, string SGST, string DiscountPercent, string DiscAmt, string Deal1, string Deal2, string rblTaxCal, string chkIsActive, string MRP, string txtHSNCode, string txtRemarks, string Manufacturer_ID, string CategoryId)    // string Manufacturer
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            DateTime frmdate = Convert.ToDateTime(UcFromDate);
            DateTime todate = Convert.ToDateTime(UcTodate);

            int active = 0;
            if (chkIsActive == "true")
            {
                active = 1;
            }
            else { active = 0; }

            Manufacturer_ID = Manufacturer_ID.Split('#')[0].ToString();

            decimal ExcisePer = 0, VATPer = 0;
            decimal ExciseAmt = 0;
            decimal UnitPrice = 0;
            decimal RE = 0; // Rate + Excise Amt
            decimal RED = 0; // Rate + Excise - Discount
            decimal Disc = 0, DiscAmt1 = 0, igst = 0, cgst = 0, sgst = 0, sumOfAlltax = 0;
            decimal VatAMt = 0;
            decimal NetAmt = 0;
            decimal taxAmt = 0;

            Disc = Util.GetDecimal(DiscountPercent.ToString());
            DiscAmt1 = Util.GetDecimal(DiscAmt.ToString());
            igst = Util.GetDecimal(IGST.ToString());
            cgst = Util.GetDecimal(CGST.ToString());
            sgst = Util.GetDecimal(SGST.ToString());
            sumOfAlltax = igst + cgst + sgst;
            VATPer = igst + cgst + sgst;
            decimal Deal = Util.GetDecimal(Deal1.ToString());
            decimal Rate = Util.GetDecimal(rate.ToString());
            decimal profit = 0;
            ExciseAmt = (Rate * ExcisePer) / 100;
            decimal TotalDeal = Util.GetDecimal(Deal1.ToString()) + Util.GetDecimal(Deal2.ToString());
            string deel = Deal1 + "+" + Deal2;
            if (Deal1 != string.Empty)
            {
                Rate = Rate / TotalDeal;
            }
            if (rblTaxCal == "RateAD")
            {
                if (Deal != 0)
                {
                    Rate = Rate * Deal;
                }
                RE = Rate + (Rate * ExcisePer) / 100;
                if (Disc != 0)
                    DiscAmt1 = (RE * Disc) / 100;
                RED = RE - DiscAmt1;
                VatAMt = (RED * VATPer) / 100;
                UnitPrice = RED + VatAMt;

                decimal Mrp = Math.Round(Util.GetDecimal(MRP.ToString()), 2, MidpointRounding.AwayFromZero);
                profit = ((Mrp - ((Mrp * VATPer) / (100 + VATPer))) - Util.GetDecimal(UnitPrice));

                taxAmt = Util.GetDecimal(VatAMt + ExciseAmt);

                NetAmt = Util.GetDecimal(UnitPrice);
            }
            else if (rblTaxCal == "Rate")
            {
                if (Deal != 0)
                {
                    Rate = Rate * Deal;
                }
                if (Disc != 0)
                {
                    DiscAmt1 = (Rate * Disc) / 100;
                }
                RED = Rate - DiscAmt1;
                VatAMt = (Rate * sumOfAlltax) / 100;
                UnitPrice = RED + VatAMt;
                NetAmt = Util.GetDecimal(UnitPrice);
                taxAmt = Util.GetDecimal(VatAMt);
               // VatAMt = (RED * VATPer) / 100;
            }
            else if (rblTaxCal == "RateInclusive")
            {
                if (Deal != 0)
                {
                    Rate = Rate * Deal;
                }
                if (Disc != 0)
                {
                    DiscAmt1 = (Rate * Disc) / 100;
                }
                RED = Rate - DiscAmt1;

                decimal n = 0;
                n = Math.Round((Rate * 100) / (100 + sumOfAlltax), 2, MidpointRounding.AwayFromZero);

                decimal rem = 0;
                rem = Rate - n;

                UnitPrice = (RED + rem);
                NetAmt = Util.GetDecimal(UnitPrice);
                
                taxAmt = Util.GetDecimal(sumOfAlltax);
            }

            string query = "INSERT INTO `f_storeitem_rate`(`ItemID`,`Vendor_ID`,`GrossAmt`,`DiscAmt`,`TaxAmt`,`NetAmt`,`FromDate`,`ToDate`,`Remarks`,`EntryDate`,`UserID`,`UserName`,IsActive,StoreType,TaxCalulatedOn,DeptLedgerNo,CentreID,Hospital_ID,Manufacturer_ID,MRP,IsDeal,GSTType,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,UpdatedBy,UpdatedDate,IPAddress,Profit)" +
                "Values('" + ItemId + "','" + VendorId + "','" + rate + "','" + DiscAmt1 + "','" + taxAmt + "','" + NetAmt + "','" + frmdate.ToString("yyyy-MM-dd") + "','" + todate.ToString("yyyy-MM-dd") + "','" + txtRemarks + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["UserName"]) + "','" + active + "','" + CategoryId + "','" + rblTaxCal + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Manufacturer_ID + "','" + MRP + "','" + deel + "','" + Tax + "','" + txtHSNCode + "','" + IGST + "','" + CGST + "','" + SGST + "','','0001-01-01 00:00:00','" + All_LoadData.IpAddress() + "','" + profit + "')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);

            string TaxID1 = "", TaxPer1 = "";
            string taxID = Util.GetString(Tax.ToString());
            TaxID1 = taxID;

            string queryy = " SELECT MAX(id) FROM f_storeitem_rate ";
            string StoreId = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, queryy).ToString();
            string taxid = TaxID1;

            decimal taxper = Util.GetDecimal(IGST.ToString()) + Util.GetDecimal(CGST.ToString()) + Util.GetDecimal(SGST.ToString());
            TaxPer1 = taxper.ToString();

            query = " INSERT INTO f_storeitem_Tax(`StoreRateID`,`ITemID`,`TaxID`,`TaxPer`,`TaxAmt`,DeptLedgerNo,CentreID,Hospital_ID,GSTType,IGSTPercent,CGSTPercent,SGSTPercent,UpdatedBy,UpdatedDate,IPAddress)" +
            " VALUES('" + StoreId + "','" + ItemId + "','" + TaxID1 + "','" + TaxPer1 + "','" + taxAmt + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Tax + "','" + IGST + "','" + CGST + "','" + SGST + "','','0001-01-01 00:00:00','" + All_LoadData.IpAddress() + "')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);

            if (chkIsActive == "1")
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + ItemId + "' AND isActive =1 and ID<>'" + StoreId + "' AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        Tranx.Commit();
        Tranx.Dispose();
        con.Close();
        con.Dispose();

        return "OK";
    }

    [WebMethod]
    public static string[] SearchBindItems(string CategoryId, string SubCategory, string PreFix)
    {
        List<string> items = new List<string>();

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string str = "select TypeName ,Concat(IM.ItemId,'#','N','#')ItemId from f_itemmaster IM  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 ";
        if (SubCategory != "0" && SubCategory != "All")
        {
            str = str + " AND IM.subcategoryid='" + SubCategory.ToString() + "' ";
        }
        if (CategoryId != "0")
        {
            str = str + " AND SM.CategoryID='" + CategoryId.ToString() + "' ";
        }
        str = str + "   order by typename ";

        MySqlCommand cmd = new MySqlCommand(str, con);
        cmd.CommandType = CommandType.Text;

        using (MySqlDataReader dr = cmd.ExecuteReader())
        {
            while (dr.Read())
            {
                items.Add(string.Format("{0}-{1}", dr["TypeName"], dr["ItemId"]));
            }
        }
        con.Close();

        return items.ToArray();
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string BindPurchaseUnit(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IF(IFNULL(fid.majorUnit,'')='',im.majorUnit,fid.majorUnit)majorUnit from f_itemmaster im LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' WHERE im.ItemID='" + ItemId.Split('#').GetValue(0).ToString() + "'");
        DataTable dtItemRate = new DataTable();
        dtItemRate = StockReports.GetDataTable(sb.ToString());
        if (dtItemRate.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtItemRate);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]  // developed by Ankit
    public static string GetItemIDByItemName(string itemname)
    {
        string Itemid = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT ItemID FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            Itemid = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(Itemid);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetLastNetAmt()
    {
        string netAmt = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT NetAmt FROM f_storeitem_rate ORDER BY ID DESC LIMIT 1";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            netAmt = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(netAmt);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetConverFactor()
    {
        string cf = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT conversionFactor FROM f_itemmaster_deptWise ORDER BY ID DESC LIMIT 1";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            cf = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(cf);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetSubCategory(string itemname)
    {
        string cat = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT SubCategoryID FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            cat = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(cat);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetManufactureID(string itemname)
    {
        string man = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT ManufactureID FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            man = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(man);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetHSNCode(string itemname)
    {
        string code = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT HSNCode FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            code = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(code);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetGSTType(string itemname)
    {
        string code = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT GSTType FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            code = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(code);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetCGST(string itemname)
    {
        string code = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT CGSTPercent FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            code = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(code);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetIGST(string itemname)
    {
        string code = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT IGSTPercent FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            code = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(code);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetSGST(string itemname)
    {
        string code = "";
        MySqlConnection cn = new MySqlConnection();
        cn = Util.GetMySqlCon();
        cn.Open();

        string str = "SELECT SGSTPercent FROM f_itemmaster WHERE TypeName='" + itemname + "'";
        using (MySqlCommand cmd = new MySqlCommand(str, cn))
        {
            cmd.CommandType = CommandType.Text;
            code = cmd.ExecuteScalar().ToString();
            cn.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(code);
    }

    //protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    if (rblStoreType.SelectedItem.Text == "Gen.")
    //    {
    //        chkIsAsset.Visible = true;
    //        lblasset.Visible = true;
    //    }
    //    else 
    //    {
    //        chkIsAsset.Visible = false;
    //        lblasset.Visible = false;
    //    }
       
    //}
}