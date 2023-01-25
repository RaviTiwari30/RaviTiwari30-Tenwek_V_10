using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
public partial class Design_Store_StockUpdate : System.Web.UI.Page
{
    public void BindTAX()
    {
        string sql = "";
        if (Resources.Resource.IsGSTApplicable == "0")
        {
            sql = "select TaxName,TaxID from f_taxmaster where TaxID In ('T3') order by TaxName ";
        }
        else if (Resources.Resource.IsGSTApplicable == "1")
        {
            sql = "select TaxName,TaxID from f_taxmaster where TaxID In ('T4','T6','T7') order by TaxName ";
        }
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            ddlPurTax.DataSource = dt;
            ddlPurTax.DataTextField = "TaxName";
            ddlPurTax.DataValueField = "TaxID";
            ddlPurTax.DataBind();
            ddlPurTax.SelectedIndex = ddlPurTax.Items.IndexOf(ddlPurTax.Items.FindByValue("T3"));
        }
        else
        {
            ddlPurTax.Items.Clear();
            ddlPurTax.Items.Add("No Item Found");
        }
    }

    public DataTable LoadAllStoreItems()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            if (Resources.Resource.IsGSTApplicable == "0")
            {
                // Connversion Factor = 1;
                // sb.Append("SELECT CONCAT(IFNULL(IM.ItemCode,''),'#',IM.Typename,'#','(',SM.name,')','#',IF(IFNULL(fid.MinorUnit,'')='',im.MinorUnit,fid.MinorUnit),'#',IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit),'#',IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor),'#',IFNULL(im.HSNCode,''))ItemName, ");
                sb.Append("SELECT CONCAT(IFNULL(IM.ItemCode,''),'#',IM.Typename,'#','(',SM.name,')','#',IF(IFNULL(fid.MinorUnit,'')='',ifnull(im.MinorUnit,''),IFNULL(fid.MinorUnit,'')),'#',IF(IFNULL(fid.MajorUnit,'')='',IFnull(im.MajorUnit,''),IFNULL(fid.MajorUnit,'')),'#',1,'#',IFNULL(im.HSNCode,''))ItemName, ");
                // sb.Append(" CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.Type_ID,''),'#',IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit),'#',IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''),fid.MinorUnit),'#',IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor),'#',IFNULL(im.IsExpirable,''),'#',IFNULL(im.IGSTPercent,0),'#',IFNULL(im.SGSTPercent,0),'#',IFNULL(im.CGSTPercent,0),'#',IFNULL(im.GSTType,''),'#',IFNULL(im.HSNCode,''),'#',IFNULL(im.VatType,''),'#',IFNULL(im.DefaultSaleVatPercentage,0),'#',IFNULL(im.DefaultPurchaseVatPercentage,0))ItemID");
                sb.Append(" CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.Type_ID,''),'#',IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit),'#',IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''),fid.MinorUnit),'#',1,'#',IFNULL(im.IsExpirable,''),'#',IFNULL(im.IGSTPercent,0),'#',IFNULL(im.SGSTPercent,0),'#',IFNULL(im.CGSTPercent,0),'#',IFNULL(im.GSTType,''),'#',IFNULL(im.HSNCode,''),'#',IFNULL(im.VatType,''),'#',IFNULL(im.DefaultSaleVatPercentage,0),'#',IFNULL(im.DefaultPurchaseVatPercentage,0))ItemID");
                sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
                sb.Append(" INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
                sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
                sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID WHERE  im.IsActive=1 AND itc.`IsActive`=1 and im.Typename<>'' AND itc.`CentreID`= '" + Session["CentreID"].ToString() + "'");
                if (rblStoreType.SelectedValue == "STO00001")
                    sb.Append(" AND CR.ConfigID ='11' ");
                else if (rblStoreType.SelectedValue == "STO00002")
                    sb.Append(" AND CR.ConfigID ='28' ");

                sb.Append(" order by IM.Typename ");
            }
            else if (Resources.Resource.IsGSTApplicable == "1")
            {
                sb.Append("SELECT CONCAT(IFNULL(IM.ItemCode,''),'#',IM.Typename,'#','(',SM.name,')','#',IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''),IFNULL(fid.MinorUnit,'')),'#',IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),IFNULL(fid.MajorUnit,'')),'#',IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),IFNULL(fid.ConversionFactor,'1')),'#',IFNULL(im.HSNCode,''))ItemName, ");
                sb.Append(" CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.Type_ID,''),'#',IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit),'#',IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''),fid.MinorUnit),'#',IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor),'#',IFNULL(im.IsExpirable,''),'#',IFNULL(im.IGSTPercent,0),'#',IFNULL(im.SGSTPercent,0),'#',IFNULL(im.CGSTPercent,0),'#',IFNULL(im.GSTType,''),'#',IFNULL(im.HSNCode,''))ItemID");
                sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
                sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
                sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID WHERE  im.IsActive=1 and im.Typename<>'' ");
                if (rblStoreType.SelectedValue == "STO00001")
                    sb.Append(" AND CR.ConfigID ='11' ");
                else if (rblStoreType.SelectedValue == "STO00002")
                    sb.Append(" AND CR.ConfigID ='28' ");

                sb.Append(" order by IM.Typename ");
            }
            DataTable dtItems = StockReports.GetDataTable(sb.ToString());

            return dtItems;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        DateTime expDate;
        //if (!DateTime.TryParse(txtExpiryDate.Text.Trim(), out expDate))
        //{
        //    lblMsg.Text = "Invalid Expiry Date Format";
        //    txtExpiryDate.Focus();
        //    return;
        //}
        float tRate = Util.GetFloat(txtPrice.Text.Trim());
        float tMrp = Util.GetFloat(txtMRP.Text.Trim());
        if (lstItem.SelectedIndex < 0)
        {
            lblMsg.Text = "Please Select Item";
            txtFirstNameSearch.Focus();
            return;
        }
        if (lstItem.SelectedValue == string.Empty)
        {
            lblMsg.Text = "No Item Found";
            lstItem.Focus();
            return;
        }
        if (Util.GetFloat(txtQty.Text) <= 0)
        {
            lblMsg.Text = "Please Enter Quantity";
            txtQty.Focus();
            return;
        }

        if (Resources.Resource.IsGSTApplicable == "1")
        {
            if (tRate > tMrp)
            {
                lblMsg.Text = "MRP Can't be less Than Rate";
                return;
            }
        }
        if (cmbAprroved.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Approved By";
            cmbAprroved.Focus();
            return;
        }
        if (txtNarration.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Narration";
            return;
        }
        else
        {
            lblMsg.Text = string.Empty;
            DataTable dtItemDetails = null;
            if (ViewState["ItemDetails"] != null)
            {
                dtItemDetails = (DataTable)ViewState["ItemDetails"];
            }
            float price = 0, MRP = 0;
            string quantity = string.Empty;
            string expiryDate = string.Empty, narration = string.Empty, batchNo = string.Empty;
            string itemID = lstItem.SelectedValue.Split('#')[0].ToString();
            string type = lstItem.SelectedValue.Split('#')[2].ToString();
            string itemName = lstItem.SelectedItem.Text.Trim().Split('#')[1].ToString();
            string subCategory = lstItem.SelectedItem.Value.Split('#')[1].ToString();
            float saleTax = 0;
            if (Resources.Resource.IsGSTApplicable == "1")
            {
                saleTax = Util.GetFloat(ddlSaleTax.SelectedItem.Value);
            }
            else if (Resources.Resource.IsGSTApplicable == "0")
            {
                saleTax = Util.GetFloat(lstItem.SelectedItem.Value.Split('#')[13].ToString());
            }
            string purTax = Util.GetString(ddlPurTax.SelectedItem.Text);
            float disc = Util.GetFloat(txtDisc.Text.Trim());
            string unitType = lstItem.SelectedItem.Text.Split('#')[2].ToString();
            string majorUnit = lstItem.SelectedValue.Split('#')[3].ToString();
            string minorUnit = lstItem.SelectedValue.Split('#')[4].ToString();
            string conversionFactor = lstItem.SelectedValue.Split('#')[5].ToString();

            string taxID = ddlPurTax.SelectedItem.Value;
            decimal taxPer = 0;
            if (Resources.Resource.IsGSTApplicable == "0")
            {
                taxPer = Util.GetDecimal(txtTAX1.Text.Trim());
            }
            //GST Changes
            if (Resources.Resource.IsGSTApplicable == "1")
            {
                taxPer = Math.Round(Util.GetDecimal(txtIGST.Text) + Util.GetDecimal(txtCGST.Text) + Util.GetDecimal(txtSGST.Text), 4);
            }

            if (txtPrice.Text.Trim() != string.Empty)
            {
                price = Util.GetFloat(txtPrice.Text.Trim());
            }
            if (txtExpiryDate.Text.Trim() != string.Empty)
            {
                expiryDate = Util.GetDateTime(txtExpiryDate.Text).ToString("dd-MMM-yyyy");
            }
            if (txtNarration.Text.Trim() != string.Empty)
            {
                narration = txtNarration.Text.Trim();
            }
            if (txtQty.Text.Trim() != string.Empty)
            {
                quantity = txtQty.Text.Trim();
            }
            if (txtBatchNo.Text.Trim() != string.Empty)
            {
                batchNo = txtBatchNo.Text.Trim();
            }
            if (txtMRP.Text.Trim() != string.Empty)
            {
                MRP = Util.GetFloat(txtMRP.Text.Trim());
            }
           // decimal taxAmount = 0; decimal MRPValue = 0; decimal NetAmount = 0;
            // if (rblTaxCal.SelectedItem.Text == "MRP")
            // {
            // decimal cc = Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(txtMRP.Text) * Util.GetDecimal(txtQty.Text)) - Util.GetDecimal(txtDisc.Text.Trim()) / 100);

            // taxAmount = Math.Round((Util.GetDecimal(txtMRP.Text) * Util.GetDecimal(txtQty.Text)) - (Util.GetDecimal(txtMRP.Text) * Util.GetDecimal(txtQty.Text) * 100) / (100 + Util.GetDecimal(txtTAX1.Text)), 2, MidpointRounding.AwayFromZero);

            // decimal discount = Math.Round(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(txtPrice.Text.Trim()) * Util.GetDecimal(txtQty.Text) * Util.GetDecimal(txtDisc.Text)) / 100), 2, MidpointRounding.AwayFromZero);
            // decimal ss = Math.Round(Util.GetDecimal(((Util.GetDecimal(cc) * 100) / (100 + Util.GetDecimal(txtTAX1.Text)))), 2, MidpointRounding.AwayFromZero);

            // MRPValue = Math.Round(Util.GetDecimal(ss), 2, MidpointRounding.AwayFromZero);
            // NetAmount = Math.Round((Util.GetDecimal(Util.GetDecimal(txtPrice.Text.Trim()) * Util.GetDecimal(txtQty.Text)) + Util.GetDecimal(taxAmount) - Util.GetDecimal(discount)), 2, MidpointRounding.AwayFromZero);
            // }
            // else
            // {
            // decimal aa = Util.GetDecimal(Util.GetDecimal(txtPrice.Text.Trim()) * Util.GetDecimal(txtQty.Text.Trim()));
            // aa = aa * (100 - Util.GetDecimal(txtDisc.Text.Trim())) * Util.GetDecimal(0.01);
            // decimal bb = (aa * (100 + Util.GetDecimal(txtTAX1.Text)) * Util.GetDecimal(0.01));

            // MRPValue = Math.Round(Util.GetDecimal(Util.GetDecimal(txtPrice.Text.Trim()) * Util.GetDecimal(txtQty.Text.Trim())), 2, MidpointRounding.AwayFromZero);
            // NetAmount = Math.Round(bb, 2, MidpointRounding.AwayFromZero);
            // taxAmount = Math.Round(Util.GetDecimal(Util.GetDecimal(bb) - Util.GetDecimal(aa)), 2, MidpointRounding.AwayFromZero);
            // }

             decimal tax = taxPer;
            
            List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
         {
           new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer=Util.GetDecimal(txtDisc.Text.Trim()), MRP=Util.GetDecimal(txtMRP.Text.Trim()),Quantity=Util.GetDecimal(txtQty.Text.Trim()),Rate=Util.GetDecimal(txtPrice.Text.Trim()),TaxPer=Util.GetDecimal(tax),Type=Util.GetString(rblTaxCal.SelectedItem.Value),
          //GST Changes
               IGSTPrecent=Util.GetDecimal(txtIGST.Text),CGSTPercent=Util.GetDecimal(txtCGST.Text),SGSTPercent=Util.GetDecimal(txtSGST.Text)
           }
         };

            string taxCalculation = AllLoadData_Store.taxCalulation(taxCalculate);

            dtItemDetails = CreateStockMaster.AddItemDetails(dtItemDetails, itemID, itemName, batchNo, quantity, price, MRP, expiryDate, subCategory, narration, saleTax, purTax, disc, type, unitType, majorUnit, minorUnit, conversionFactor, taxID, taxPer, Util.GetDecimal(taxCalculation.Split('#')[5]), Util.GetDecimal(taxCalculation.Split('#')[0]), Util.GetDecimal(taxCalculation.Split('#')[1]), Util.GetDecimal(taxCalculation.Split('#')[2]), Util.GetDecimal(taxCalculation.Split('#')[3]), Util.GetDecimal(taxCalculation.Split('#')[4]),Util.GetDecimal(txtIGST.Text),Util.GetDecimal(taxCalculation.Split('#')[8]),Util.GetDecimal(txtCGST.Text),Util.GetDecimal(taxCalculation.Split('#')[9]),Util.GetDecimal(txtSGST.Text),Util.GetDecimal(taxCalculation.Split('#')[10]),Util.GetString(txtHSNCode.Text.Trim()),Util.GetString(ddlPurTax.SelectedItem.Text));
            GridView1.DataSource = dtItemDetails;
            GridView1.DataBind();
            ViewState["ItemDetails"] = dtItemDetails as DataTable;
            txtCPTCodeSearch.Text = string.Empty;
            this.clear();
            btnSave.Visible = true;
            ToolkitScriptManager1.SetFocus(txtFirstNameSearch);
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        DataTable dtitem = ViewState["ItemDetails"] as DataTable;
        string LedgerTran = string.Empty;
        string LedgerNumber = "LSHHI54";
        string UserID = Session["ID"].ToString();
        string ApprovedBy = cmbAprroved.SelectedItem.Text;

        LedgerTran = CreateStockMaster.SaveStockAdjustment(dtitem, string.Empty, UserID, "StockUpdate", LedgerNumber, ApprovedBy, ViewState["DeptLedgerNo"].ToString(), rblStoreType.SelectedValue, rblTaxCal.SelectedItem.Text);
        if (LedgerTran != string.Empty)
        {
            lblMsg.Text = "Record Saved Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Entry No.:'+'" + LedgerTran + "');", true);
            GridView1.DataSource = null;
            GridView1.DataBind();
            if (ViewState["ItemDetails"] != null)
            {
                ViewState.Remove("ItemDetails");
            }
            lblMsg.Text = string.Empty;
            btnSave.Visible = false;
        }
        else
        {
            lblMsg.Text = "Record Not Saved";
        }
    }
    protected void btnView_Click(object sender, EventArgs e)
    {
        if (lstItem.SelectedIndex > 0)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT st.InitialCount Qty,st.BatchNumber,st.UnitPrice,st.MajorMRP,st.Rate,st.PurTaxPer,st.DiscPer,st.SaleTaxPer,  ");
            sb.Append("  DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,St.ItemName  FROM f_stock st INNER JOIN f_ledgertransaction lt     ");
            sb.Append(" ON st.LedgerTransactionNo=lt.LedgerTransactionNo  WHERE  st.ItemID='" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "' ");
            sb.Append(" AND st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' AND st.CentreID='" + Session["CentreID"].ToString() + "' ");
            if (rblStoreType.SelectedValue == "STO00001")
                sb.Append(" AND lt.TypeOfTnx='StockUpdate' ");
            else
                sb.Append(" AND lt.TypeOfTnx='NONMEDICALADJUSTMENT' ");
            sb.Append(" ORDER BY lt.DATE DESC LIMIT 1");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                txtPrice.Text = dt.Rows[0]["Rate"].ToString();
                txtMRP.Text = dt.Rows[0]["MajorMRP"].ToString();
                txtExpiryDate.Text = dt.Rows[0]["MedExpiryDate"].ToString();
            }
            else
            {
                txtPrice.Text = "0.00";
                txtMRP.Text = "0.00";
                txtExpiryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            }
        }
        else
        {
            lblMsg.Text = "Select item";
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument.ToString());
            DataTable dt = (DataTable)ViewState["ItemDetails"];
            dt.Rows[args].Delete();
            dt.AcceptChanges();
            GridView1.DataSource = dt;
            GridView1.DataBind();
            ViewState["ItemDetails"] = dt;
            if (dt.Rows.Count > 0)
            {
              //  rblTaxCal.Enabled = false;
                btnSave.Visible = true;
                rblStoreType.Enabled = false;
            }
            else
            {
             //   rblTaxCal.Enabled = true;
                btnSave.Visible = false;
                rblStoreType.Enabled = true;
            }
        }
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

                if (this.ChkRights())
                {
                    string Msg = "You do not have rights to Update Stock ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg, false);
                    Context.ApplicationInstance.CompleteRequest();
                }

                All_LoadData.bindApprovalType(this.cmbAprroved);
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                this.BindTAX();
                this.BindSaleTax();
                // txtExpiryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                clcExp.StartDate = System.DateTime.Now;
               // txtMRP.Attributes.Add("ReadOnly", "true");
                
            }
        }
        // txtExpiryDate.Attributes.Add("ReadOnly", "true");
    }

   

    private void BindItem()
    {
        try
        {
            DataTable dtItem = LoadAllStoreItems();
            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                lstItem.DataSource = dtItem;
                lstItem.DataTextField = "ItemName";
                lstItem.DataValueField = "ItemID";
                lstItem.DataBind();
            }
            else
            {
                lstItem.Items.Clear();
                lstItem.Items.Add(new ListItem("No Item Found", string.Empty));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void BindSaleTax()
    {
        AllLoadData_Store.bindSalesTax(this.ddlSaleTax);
    }

   
    private void clear()
    {
        txtBatchNo.Text = string.Empty;
        txtExpiryDate.Text = string.Empty;
        // txtExpMonth.Text = string.Empty;
        txtFirstNameSearch.Text = string.Empty;
        txtMRP.Text = string.Empty;
        txtQty.Text = string.Empty;
        txtQty.Text = string.Empty;
        txtPrice.Text = string.Empty;
        txtCPTCodeSearch.Text = string.Empty;
        txtNarration.Text = string.Empty;
        ddlSaleTax.SelectedIndex = ddlSaleTax.Items.IndexOf(ddlSaleTax.Items.FindByValue("0.00"));
        txtTAX1.Text = string.Empty;
        txtDisc.Text = string.Empty;
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
            lblMsg.Text = string.Empty;
            this.BindItem();
        }
        txtFirstNameSearch.Focus();
    }
    protected bool ChkRights()
    {
        
        rblStoreType.Items[0].Enabled = false;
        rblStoreType.Items[1].Enabled = false;      
        DataTable dt = StockReports.GetRights(Session["RoleID"].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
            {
                string Msg = "You do not have rights to generate purchase Order ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else
            {
                rblStoreType.Items[0].Enabled = Util.GetBoolean(dt.Rows[0]["IsMedical"]);
                rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);

                //if (rblStoreType.SelectedIndex > -1)
                //    BindItem();
            }
            return false;
        }
        else { return true; }
    }
}