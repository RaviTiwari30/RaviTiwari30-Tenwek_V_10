using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Collections.Generic;
using System.Web.Services;
public partial class Design_Purchase_DirectPO_ItemWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                BindCategoryNew();
                AllLoadData_Store.bindTypeMaster(ddlPOType);
                BindSubcategory();
                BindItemNew();

                ScriptManager1.SetFocus(ddlVendor);
                txtDeliveryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtValidDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtPODate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtInvoiceAmount.Attributes.Add("readonly", "readonly");
                txtFreight.Attributes.Add("onkeyup", "sum();");
                txtScheme.Attributes.Add("onkeyup", "sum();");
                txtRoundOff.Attributes.Add("onkeyup", "sum();");
                txtExciseOnBill.Attributes.Add("onkeyup", "sum();");
                cePODate.StartDate = System.DateTime.Now;
                ceDeliveryDate.StartDate = System.DateTime.Now;
                ceValidDate.StartDate = System.DateTime.Now;
                BindGST();
            }
        }
        txtDeliveryDate.Attributes.Add("readOnly", "true");
        txtValidDate.Attributes.Add("readOnly", "true");
        txtPODate.Attributes.Add("readOnly", "true");
        lblMsg.Text = "";
    }
    public void BindCategoryNew()
    {
        try
        {
            string RoleId = Session["RoleID"].ToString();
            string EmpID = Session["ID"].ToString();
           // DataTable dtp = StockReports.GetPurchaseApproval("PO", EmpID);
           // if (dtp.Rows.Count > 0 && dtp != null)
           // {
                string str = "SELECT IsGeneral,IsMedical FROM f_rolemaster WHERE id='" + RoleId + "' and active=1 and IsStore=1 ";
                DataTable dt = StockReports.GetDataTable(str.ToString());
                if (dt != null && dt.Rows.Count > 0)
                {
                    DataView dv = LoadCacheQuery.loadCategory().DefaultView;
                    if (dt.Rows[0]["IsMedical"].ToString() == "1" && dt.Rows[0]["IsGeneral"].ToString() == "1")
                        dv.RowFilter = "ConfigID IN (11,28)";
                    else if (dt.Rows[0]["IsMedical"].ToString() == "1" || dt.Rows[0]["IsGeneral"].ToString() == "1")
                    {
                        if (dt.Rows[0]["IsMedical"].ToString() == "1")
                            dv.RowFilter = "ConfigID=11";
                        else if (dt.Rows[0]["IsGeneral"].ToString() == "1")
                            dv.RowFilter = "ConfigID=28";
                    }
                    else if (dt.Rows[0]["IsMedical"].ToString() == "0" && dt.Rows[0]["IsGeneral"].ToString() == "0")
                    {
                        string Msg = "You do not have rights to Generate PO ";
                        Response.Redirect("MsgPage.aspx?msg=" + Msg);
                    }

                    ddlCategory.DataSource = dv.ToTable();
                    ddlCategory.DataValueField = "CategoryID";
                    ddlCategory.DataTextField = "Name";
                    ddlCategory.DataBind();
                }
                else
                {
                    string Msg = "You do not have rights to Generate PO ";
                    Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
                }
            //}
           // else
          //  {
           //     string Msg = "You do not have rights to Generate PO ";
          //      Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
           // }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public void BindGrid()
    {
        DataTable dtItem = (DataTable)ViewState["ITEM"];
        gvPODetails.DataSource = dtItem;
        gvPODetails.DataBind();
        UpdatePOAmount();
    }

    public DataTable getItemDT()
    {
        if (ViewState["ITEM"] != null)
        {
            return (DataTable)ViewState["ITEM"];
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

            dtItem.Columns.Add("Order Qty");
            dtItem.Columns.Add("DiscPer");
            dtItem.Columns.Add("InHand Qty");
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
            //
            //Deal Work
            dtItem.Columns.Add("IsDeal");
            //

            return dtItem;
        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Clear();
    }

    protected void btnSaveItems_Click(object sender, EventArgs e)
    {
        if (lblItemID.Value == "")
        {
            lblMsg.Text = "Please Select the Item";
            txtSearch.Focus();
            return;
        }
        if (lblMajorUnit.Text.Trim() == "")  // testing
        {
            lblMsg.Text = "Please Specify Unit";
            txtRate1.Focus();
            return;
        }
        if (txtRate1.Text.Trim() == "")
        {
            lblMsg.Text = "Please Specify Rate";
            txtRate1.Focus();
            return;
        }
        if (txtVendorID.Text.Trim() == "")
        {
            lblMsg.Text = "Please set the Item Rate from Quotation";
            return;
        }
        if (txtVendorName.Text.Trim() == "")
        {
            lblMsg.Text = "Please set the Item Rate from Quotation";
            return;
        }

        DataTable dtItem = getItemDT();
        DataRow[] dr1 = dtItem.Select("ItemID = '" + lblItemID.Value.Split('#')[0] + "' ");

        string strItemInfo = " SELECT im.ItemID,im.MajorUnit,im.ManuFacturer,im.ManufactureID   FROM f_itemmaster im  WHERE im.ItemID='" + lblItemID.Value.Split('#')[0] + "' ";
        DataTable dtItemInfo = StockReports.GetDataTable(strItemInfo);
        decimal NetAmount = 0;
        decimal perUnitPrice = 0;
        decimal GSTAmt = 0;
        string Amt = "";
        decimal rate1 = Util.GetDecimal(txtRate1.Text);
        if (txtDeal1.Text != string.Empty)
        {
            int deal = Util.GetInt(txtDeal1.Text) + Util.GetInt(txtDeal2.Text);
            rate1 = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(txtQuantity1.Text.Trim()) * Util.GetDecimal(txtRate1.Text.Trim())) / Util.GetDouble(deal));
        }

        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
         {
             //Deal Work
           new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer=Util.GetDecimal(txtDiscount1.Text), MRP=Util.GetDecimal(0),Quantity = Util.GetDecimal(txtQuantity1.Text),Rate=rate1,TaxPer =Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text),Type = Util.GetString(lblTaxCalculatedOn.Text.Trim()),IGSTPrecent=Util.GetDecimal(txtIGSTPer.Text.Trim()),CGSTPercent=Util.GetDecimal(txtCGSTPer.Text.Trim()),SGSTPercent=Util.GetDecimal(txtSGSTPer.Text.Trim()),deal =Util.GetDecimal(txtDeal1.Text.Trim()),deal2= Util.GetDecimal(txtDeal2.Text.Trim()),ActualRate=Util.GetDecimal(txtRate1.Text.Trim())}
            //
         };
       
        Amt = AllLoadData_Store.taxCalulation(taxCalculate);

        perUnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString());
        NetAmount = Util.GetDecimal(Amt.Split('#')[0].ToString());
        string a = lblConFactor.Text;
        GSTAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
        DataRow row = dtItem.NewRow();
        row["VendorID"] = txtVendorID.Text.Trim();
        row["VendorName"] = txtVendorName.Text.Trim();
        row["ItemID"] = lblItemID.Value.Split('#')[0];
        row["ItemName"] = hdnItemText.Value.Split('#')[0];
        row["SubCategoryID"] = lblItemID.Value.Split('#')[1];
        row["TaxCalulatedOn"] = lblTaxCalculatedOn.Text.Trim();

        row["Unit"] = dtItemInfo.Rows[0]["MajorUnit"];

        row["InHand Qty"] = GetInHandQty(lblItemID.Value.Split('#')[0]);

        row["NetAmt"] = NetAmount;
        row["GSTPer"] = Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text);
        row["GSTAmt"] = GSTAmt;
        row["DiscPer"] = txtDiscount1.Text;
        // row["TaxPer"] = txtVATPer.Text;


        row["Free"] = rbtnFree.SelectedItem.Value;
        //  row["TaxPer"] = txtVATPer.Text;
        if (rbtnFree.SelectedItem.Value == "0")
        {
            row["Rate"] = txtRate1.Text;
            row["BuyPrice"] = perUnitPrice;
            row["Order Qty"] = txtQuantity1.Text;
            row["NetAmt"] = NetAmount;
            row["GSTPer"] = Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text);
            row["GSTAmt"] = GSTAmt;
            row["DiscPer"] = txtDiscount1.Text;
            row["IGSTAmt"] = Util.GetDecimal(Amt.Split('#')[8].ToString());
            row["CGSTAmt"] = Util.GetDecimal(Amt.Split('#')[9].ToString());
            row["SGSTAmt"] = Util.GetDecimal(Amt.Split('#')[10].ToString());
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
            row["IGSTAmt"] = 0;
            row["CGSTAmt"] = 0;
            row["SGSTAmt"] = 0;
        }

        row["SaleTaxPer"] = ddlTax1.SelectedItem.Text;
        row["Manufacturer"] = dtItemInfo.Rows[0]["ManuFacturer"];
        row["ManufactureID"] = dtItemInfo.Rows[0]["ManufactureID"];
        row["Type_ID"] = "HS";

        // GST Changes
        row["GSTType"] = Util.GetString(ddlGST.SelectedItem.Text);
        row["HSNCode"] = Util.GetString(txtHSNCode.Text);
        row["IGSTPercent"] = Util.GetDecimal(txtIGSTPer.Text);
        row["CGSTPercent"] = Util.GetDecimal(txtCGSTPer.Text);
        row["SGSTPercent"] = Util.GetDecimal(txtSGSTPer.Text);
       
        //----
        //Deal Work
        if (txtDeal1.Text != "")
        {
            row["IsDeal"] = txtDeal1.Text.Trim() + "+" + txtDeal2.Text.Trim();
        }
        else
        {
            row["IsDeal"] = "";
        }
        //

        dtItem.Rows.Add(row);

        ViewState["ITEM"] = dtItem;
        if (dtItem != null)
        {
            gvPODetails.DataSource = dtItem;
            gvPODetails.DataBind();
            pnlOrderDetail.Visible = true;
            txtRate1.Text = string.Empty;
            txtVATPer.Text = string.Empty;
            txtExcisePer.Text = string.Empty;
            txtQuantity1.Text = string.Empty;
            txtDiscount1.Text = string.Empty;
            // GST Changes
            txtIGSTPer.Text = txtCGSTPer.Text = txtSGSTPer.Text = "0";
            txtHSNCode.Text = "";
            ddlGST.SelectedIndex = 0;
            lblGSTType.Text = ddlGST.SelectedItem.Text;
            //---

            //  lblTaxID.Text = string.Empty;
            txtVendorName.Text = "";
            txtVendorID.Text = "";
            rbtnFree.SelectedIndex = 1;
            lblItemID.Value = "";
            lblItemName.Text = "";
            //ListBox1.SelectedIndex = -1;
            lblTaxCalculatedOn.Text = "";
            txtDeal1.Text = "";
            txtDeal2.Text = "";
            lblConFactor.Text = "";
            lblMajorUnit.Text = "";
            txtSearch.Focus();
        }

        UpdatePOAmount();
        ddlCategory.Enabled = false;
    }

    protected void btnSavePO_Click(object sender, EventArgs e)
    {
        try
        {
            string HSPoNumber = "";
            string PONumber = "";
            lblMsg.Text = "";
            string VID = "";
            if (ViewState["ITEM"] != null)
            {
                DataTable dtItemsNew = ((DataTable)ViewState["ITEM"]).Clone();
                DataTable dtItems = (DataTable)ViewState["ITEM"];
                DataView view = new DataView(dtItems);
                view.Sort = "VendorID ASC";
                DataTable newTable = view.ToTable();
                for (int i = 0; i < gvPODetails.Rows.Count; i++)
                {
                    if (newTable.Rows.Count == 1)
                    {
                        ViewState["ITEM"] = newTable;
                        if (newTable.Rows.Count > 0)
                        {
                            string type_id = "HS";
                            PONumber = SaveHSData(type_id);
                        }
                    }
                    else if ((string.IsNullOrEmpty(VID)) || (VID == newTable.Rows[i]["VendorID"].ToString()))
                    {
                        if (string.IsNullOrEmpty(VID))
                        {
                            VID = newTable.Rows[i]["VendorID"].ToString();
                        }
                        dtItemsNew.Rows.Add(newTable.Rows[i].ItemArray);
                        dtItemsNew.AcceptChanges();
                        if (gvPODetails.Rows.Count - 1 == i)
                        {
                            VID = "Unknown";
                            if (i != 0)
                                i--;
                        }
                    }
                    else
                    {
                        ViewState["ITEM"] = dtItemsNew;
                        if (ViewState["ITEM"] != null)
                        {
                            if (dtItemsNew.Rows.Count > 0)
                            {
                                string type_id = "HS";
                                HSPoNumber = SaveHSData(type_id);
                                if (PONumber == "" || PONumber == null)
                                    PONumber = HSPoNumber;
                                else
                                    PONumber = PONumber + "#" + HSPoNumber;
                            }
                        }
                        if (VID != "Unknown")
                        {
                            VID = newTable.Rows[i]["VendorID"].ToString();
                            if (i != 0)
                                i--;
                        }
                        else
                            break;
                        dtItemsNew.Rows.Clear();
                    }
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

                int poLength = PONumber.Split('#').Length;
                string[] PO = PONumber.Split('#');
                for (int n = 0; n < poLength; n++)
                {
                    if (PONumber != string.Empty)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1" + n, "alert('Purchase Order No. : " + PO[n] + "');", true);
                        if (chkPrintImg.Checked == true)
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2" + n, "window.open('POReport.aspx?PONumber=" + PO[n] + "&ImageToPrint=" + ImagesToprint + "');location.href='DirectPO_Itemwise.aspx';", true);
                        }
                        ViewState["ITEM"] = null;
                        gvPODetails.DataSource = null;
                        gvPODetails.DataBind();
                    }
                    else
                        lblMsg.Text = "Error....";
                }

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Select Items');", true);
                return;
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubcategory();
        BindItemNew();
        ddlSubCategory.Focus();
    }
    protected void ddlPOType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPOType.SelectedItem.Text.ToString() == "Urgent")
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(3).ToString("dd-MMM-yyyy");
        else
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(7).ToString("dd-MMM-yyyy");
    }

    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItemNew();
        if (ddlSubCategory.SelectedItem.Value != "ALL")
        {
            ListBox1.Focus();
        }
    }

    protected void ddlVendor_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void gvPODetails_RowDeleting1(object sender, GridViewDeleteEventArgs e)
    {
        DataTable dtt = ((DataTable)ViewState["ITEM"]);
        dtt.Rows[e.RowIndex].Delete();
        ViewState["ITEM"] = dtt;
        gvPODetails.DataSource = dtt;
        gvPODetails.DataBind();
        if (dtt.Rows.Count == 0)
        {
            pnlOrderDetail.Visible = true;
            ddlCategory.Enabled = true;
        }
        else
        {
            pnlOrderDetail.Visible = false;
            ddlCategory.Enabled = false;
        }
        UpdatePOAmount();
    }

    private void BindItemNew()
    {
        ListBox1.DataSource = null;
        ListBox1.DataBind();
        string str = "select TypeName ,CONCAT(IM.ItemId,'#',IM.SubCategoryID,'#')ItemId from f_itemmaster IM  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE im.IsActive=1 ";
        if (ddlCategory.SelectedItem.Value == "LSHHI8")
            str += " AND CR.ConfigID IN (28)   ";
        else
            str += " AND CR.ConfigID IN (11)   ";
        if (ddlSubCategory.SelectedIndex != -1)
        {
            if (ddlSubCategory.SelectedItem.Value != "ALL")
            {
                str = str + " AND IM.subcategoryid='" + ddlSubCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "' ";
            }
            str = str + " AND SM.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "' ";
            str = str + "  order by typename ";

            DataTable dt = StockReports.GetDataTable(str);
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "TypeName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
        else
        {
            lblMsg.Text = "Select SubCategory First";
            return;
        }
    }

    private void BindSubcategory()
    {
        ddlSubCategory.DataSource = null;
        ddlSubCategory.DataBind();
        if (ddlCategory.SelectedItem.Value != "0")
        {
            string str = "select name,Concat(Subcategoryid,'#','N')Subcategoryid from f_subcategorymaster where categoryid='" + ddlCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "'  AND active=1 order by name ";
            DataTable dt = StockReports.GetDataTable(str);
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "name";
            ddlSubCategory.DataValueField = "SubCategoryid";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("All", "ALL"));
        }
        else
        {
            ddlSubCategory.Items.Clear();
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("All", "ALL"));
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
        txtQuantity1.Text = string.Empty;
        ViewState.Clear();
        ListBox1.Items.Clear();
    }

    private decimal GetInHandQty(string ItemID)
    {
        string str = "";
        if (Session["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            str = " Select sum(InitialCount-ReleasedCount)InHandQty from f_stock where ItemID = '" + ItemID + "' group by ItemID ";
        else
            str = " Select sum(InitialCount-ReleasedCount)InHandQty from f_stock where ItemID = '" + ItemID + "' group by ItemID ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
            return Util.GetDecimal(dt.Rows[0][0]);
        else
            return 0;
    }

    private string SaveHSData(string type_id)
    {
        decimal NetAmount = 0;
        DataTable dtHS = (DataTable)ViewState["ITEM"];

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
            HSPoNumber = StockReports.ExecuteScalar("Select get_po_number('" + type_id + "','" + Session["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "')");
            DateTime ByDate = Util.GetDateTime("01-Jan-0001");

            PurchaseOrderMaster iMst = new PurchaseOrderMaster(Tnx);
            iMst.Subject = txtNarration.Text.Trim();
            iMst.Remarks = txtRemarks.Text.Trim();
            iMst.VendorID = dtHS.Rows[0]["VendorID"].ToString();
            iMst.VendorName = dtHS.Rows[0]["VendorName"].ToString();
            if (txtPODate.Text != string.Empty)
                iMst.RaisedDate = Util.GetDateTime(txtPODate.Text);
            else
                iMst.RaisedDate = DateTime.Now;
            iMst.RaisedUserID = Convert.ToString(Session["ID"]);
            iMst.RaisedUserName = Convert.ToString(Session["UserName"]);
            iMst.ValidDate = Util.GetDateTime(txtValidDate.Text);
            iMst.DeliveryDate = Util.GetDateTime(txtDeliveryDate.Text);
            iMst.NetTotal = Util.GetDecimal(NetAmount) - Util.GetDecimal(txtFreight.Text.Trim()) - Util.GetDecimal(txtRoundOff.Text.Trim()) + Util.GetDecimal(txtScheme.Text.Trim()) - Util.GetDecimal(txtExciseOnBill.Text);
            iMst.GrossTotal = Util.GetDecimal(NetAmount);
            iMst.Freight = Util.GetDecimal(txtFreight.Text.Trim());
            iMst.RoundOff = Util.GetDecimal(txtRoundOff.Text.Trim());
            iMst.Scheme = Util.GetDecimal(txtScheme.Text.Trim());
            iMst.Type = ddlPOType.SelectedItem.Text;
            iMst.ByDate = ByDate;
            iMst.ExciseOnBill = Util.GetDecimal(txtExciseOnBill.Text);
            iMst.S_Amount = Util.GetDecimal(iMst.NetTotal);
            if (ddlCategory.SelectedValue == "LSHHI5")
                iMst.StoreLedgerNo = "STO00001";
            else
                iMst.StoreLedgerNo = "STO00002";

            iMst.DeptLedgerNo = Util.GetString(ViewState["DeptLedgerNo"]);

            iMst.S_CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
            iMst.S_Currency = Util.GetString(Resources.Resource.BaseCurrencyNotation);
            AllSelectQuery ASQ = new AllSelectQuery();
            iMst.C_Factor = ASQ.GetConversionFactor(Util.GetInt(Resources.Resource.BaseCurrencyID));
            iMst.PoNumber = HSPoNumber;
            iMst.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            iMst.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
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
                POD.OrderedQty = Util.GetDecimal(row["Order Qty"]);
                POD.Rate = Util.GetDecimal(row["Rate"]);
                POD.QoutationNo = string.Empty;
                POD.SubCategoryID = Util.GetString(row["SubCategoryID"]);
                POD.Status = 0;
                POD.ApprovedQty = Util.GetDecimal(row["Order Qty"]);
                POD.BuyPrice = Util.GetDecimal(row["BuyPrice"]);
                POD.Amount = POD.ApprovedQty * POD.BuyPrice;
                POD.Discount_p = Util.GetDecimal(row["DiscPer"]);
                POD.RecievedQty = 0;
                POD.Status = 0;
                POD.Specification = txtNarration.Text;
                POD.Unit = Util.GetString(row["Unit"]);
                POD.IsFree = Util.GetInt(row["Free"]);
                POD.DeptLedgerNo = Util.GetString(ViewState["DeptLedgerNo"]);
                // POD.PurchaseRequestNo = Util.GetString(row["PurchaseRequisitionNo"]);  
                POD.ExcisePercent = Util.GetDecimal(0);
                POD.ExciseAmt = Util.GetDecimal(0);
                POD.VATPercent = Util.GetDecimal(row["GSTPer"]);
                POD.VATAmt = Util.GetDecimal(row["GSTAmt"]);
                if (ddlCategory.SelectedValue == "LSHHI5")
                    POD.StoreLedgerNo = "STO00001";
                else
                    POD.StoreLedgerNo = "STO00002";
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
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Util.GetString(ViewState["DeptLedgerNo"]) + "'"));
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
            Tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
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

    [WebMethod(EnableSession = true)]
    public static string BindItem(string ddlSubCategory, string ddlCategory, string PreFix)
    {
        string str = "select TypeName ,CONCAT(IM.ItemId,'#',IM.SubCategoryID,'#')ItemId from f_itemmaster IM  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 ";
        if (ddlSubCategory != "ALL")
        {
            str = str + " AND IM.subcategoryid='" + ddlSubCategory.Split('#').GetValue(0).ToString() + "' ";
        }
        str = str + " AND SM.CategoryID='" + ddlCategory.Split('#').GetValue(0).ToString() + "' ";
        str = str + "  order by typename ";
        DataTable dtItem = StockReports.GetDataTable(str);
        if (dtItem.Rows.Count > 0)
        {
            var dt = dtItem;
            DataView DvInvestigation = dt.AsDataView();
            string filter = string.Empty;
            if (!string.IsNullOrEmpty(PreFix))
            {
                filter = "TypeName LIKE '%" + PreFix + "%'";
                DvInvestigation.RowFilter = filter;
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
        }
        else
        {
            return "";
        }
    }
}