using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.UI.HtmlControls;
public partial class Design_Purchase_StoreItemRate : System.Web.UI.Page
{
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
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                BindCategoryNew();
                BindVendor();
                BindManufacturer();
                BindTax();
                lblMsg.Text = "";
            }
        }
        ucToDate.Attributes.Add("readOnly", "true");
        ucFromDate.Attributes.Add("readOnly", "true");
        calEntryDate1.EndDate = DateTime.Now;
        calEntryDate2.StartDate = DateTime.Now;
    }
    
    private void BindCategoryNew()
    {
        string RoleId = Session["RoleID"].ToString();

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
                string Msg = "You do not have rights to Create Items ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg);
            }
            ddlCategory.DataSource = dv.ToTable();
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            string Msg = "You do not have rights to Create Items ";
            Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
        }
    }

    public void BindVendor()
    {
        try
        {
            DataTable dtVendor = AllLoadData_Store.bindVendor();
            if (dtVendor.Rows.Count > 0)
            {
                ddlVendor.DataSource = dtVendor;
                ddlVendor.DataTextField = "LedgerName";
                ddlVendor.DataValueField = "ID";
                ddlVendor.DataBind();
            }
            ddlVendor.Items.Insert(0, "Select");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key105", "$('.searchable').chosen('destroy').chosen({ width: '100%' });", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    public void BindManufacturer()
    {
        string str1 = "select Name,ManufactureID from f_manufacture_master where IsActive = 1 order by Name";

        DataTable dt1 = new DataTable();
        dt1 = StockReports.GetDataTable(str1);

        if (dt1.Rows.Count > 0)
        {
            ddlManufacturer.DataSource = dt1;
            ddlManufacturer.DataTextField = "Name";
            ddlManufacturer.DataValueField = "ManufactureID";
            ddlManufacturer.DataBind();

            ddlManufacturer.Items.Insert(0, new ListItem("Select", "0"));

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key105", "$('.searchable').chosen('destroy').chosen({ width: '100%' });", true);
        }

    }

    protected void btnAddItems_Click(object sender, EventArgs e)
    {
        if (ddlVendor.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Vendor ";
            ddlVendor.Focus();
            return;
        }
        if (lstItem.SelectedIndex < 0)
        {
            lblMsg.Text = "Please Select Item";
            lstItem.Focus();
            return;
        }

        if (GrdRateDetail.Rows.Count > 0)
        {
            for (int i = 0; i < GrdRateDetail.Rows.Count; i++)
            {
                string status = Util.GetString(((Label)GrdRateDetail.Rows[i].FindControl("lblActive")).Text);

                if (status == "True")
                {
                    DateTime toDate = Util.GetDateTime(((Label)GrdRateDetail.Rows[i].FindControl("lblToDate")).Text);
                    DateTime entDate = Util.GetDateTime(ucFromDate.Text);
                    string VendorID = Util.GetString(((Label)GrdRateDetail.Rows[i].FindControl("lblVendorID")).Text);
                    string ddlVendorID = Util.GetString(ddlVendor.SelectedValue.Split('#')[0]);
                    string ManufacturerID = Util.GetString(((Label)GrdRateDetail.Rows[i].FindControl("lblManID")).Text);
                    string ddlManufacturerID = Util.GetString(ddlManufacturer.SelectedValue.Split('#')[0]);
                    if (VendorID == ddlVendorID && ManufacturerID==ddlManufacturerID)
                    {
                        lblMsg.Text = "Vendor is Already Active for this Item";
                        return;
                    }
                }
                else
                    lblMsg.Text = " Please De-Activate the Vendor Item Quotation  ";
            }
        }
        DataTable dtItems = new DataTable();

        if (ViewState["dtItems"] == null)
        {
            dtItems = GetItemDataTable();
        }
        else
        {
            dtItems = (DataTable)ViewState["dtItems"];
        }       

        //string TaxID = "";
        //string TaxPer = "";
        string TotalTax = "";      
        decimal GrossAmt = Util.GetDecimal(txtRate.Text.Trim());       
        decimal StrRate = GrossAmt;
        
        decimal ExcisePer = 0, VATPer = 0;
        string TaxID1="",TaxPer1="";
        //foreach (GridViewRow gr in grdTax.Rows)
        //{
          string taxID = Util.GetString(ddlTAX1.SelectedValue.ToString());

          decimal taxper = Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text);

        TaxID1 = taxID;
        TaxPer1 =  taxper.ToString();
        VATPer = Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text);

        // GST Changes
        decimal IGSTPer = Util.GetDecimal(txtIGSTPer.Text);
        decimal CGSTPer = Util.GetDecimal(txtCGSTPer.Text);
        decimal SGSTPer = Util.GetDecimal(txtSGSTPer.Text);
        //----

        decimal UnitPrice = 0;
        decimal RE = 0; // Rate + Excise Amt
        decimal RED = 0; // Rate + Excise - Discount
        decimal VatAMt = 0;
        decimal ExciseAmt = 0;        
        decimal Disc = 0,DiscAmt1=0;
        decimal Rate = Util.GetDecimal(txtRate.Text);
        Disc = Util.GetDecimal(txtDiscPer.Text);
        DiscAmt1 = Util.GetDecimal(txtDiscAmt.Text);
        ExciseAmt = (Rate * ExcisePer) / 100;
        decimal Deal = Util.GetDecimal(txtDeal1.Text);
        decimal TotalDeal = Util.GetDecimal(txtDeal1.Text) + Util.GetDecimal(txtDeal2.Text);
        if (txtDeal1.Text != string.Empty)
        {
            Rate = Rate / TotalDeal;
        }
        if (rblTaxCal.SelectedItem.Value == "Rate")
        {
            RE = Rate + (Rate * ExcisePer) / 100;
            if(Disc!=0)
                DiscAmt1 = (RE * Disc) / 100;
            RED = RE - DiscAmt1;
            VatAMt = (RE * VATPer) / 100;
            UnitPrice = RED + VatAMt;
        }
        else if (rblTaxCal.SelectedItem.Value == "RateInclusive")
        {
            RE = Rate + (Rate * ExcisePer) / 100;
            if (Disc != 0)
                DiscAmt1 = (RE * Disc) / 100;
            RED = RE - DiscAmt1;
            VatAMt = (RED * 100) / 100 + VATPer;
            UnitPrice = RED + VatAMt;
        }
        else if (rblTaxCal.SelectedItem.Value == "RateAD")
        {
            
            if (Deal != 0)
            {
                Rate = Rate * Deal;
            }
            RE = Rate + (Rate * ExcisePer) / 100;
            if (Disc != 0)
                DiscAmt1 = (RE * Disc) / 100;
            RED = RE - DiscAmt1;
            VatAMt = (RED*VATPer)/100;
            UnitPrice = (Rate - ((Rate * Disc) / 100)) + ((Rate - ((Rate * Disc) / 100)) * VATPer / 100);
        }       
        
        decimal taxAmt =Util.GetDecimal(VatAMt + ExciseAmt);
        decimal NetAmt =Util.GetDecimal(UnitPrice);
        TotalTax = Util.GetString(VATPer);
        int Active = 0;
        if (chkIsActive.Checked == true)
            Active = 1;

        DataRow row = dtItems.NewRow();
        row["VendorID"] = ddlVendor.SelectedValue.Split('#')[0];
        row["VendorName"] = ddlVendor.SelectedItem.Text;
        row["ItemID"] = lstItem.SelectedItem.Value.Split('#').GetValue(0).ToString();
        row["ItemName"] = lstItem.SelectedItem.Text.ToString().Split('#')[0];
        row["SubCategory"] = ddlSubCategory.SelectedItem.Text;
        row["FromDate"] = ucFromDate.Text;
        row["ToDate"] = ucToDate.Text;
        row["MRP"] = Math.Round(Util.GetDecimal(txtMRP.Text), 2, MidpointRounding.AwayFromZero); 
        row["Rate"] = Math.Round(Util.GetDecimal(txtRate.Text),2,MidpointRounding.AwayFromZero);
        row["DiscAmt"] = Math.Round(Util.GetDecimal(DiscAmt1), 2, MidpointRounding.AwayFromZero);
        row["DiscPer"] = Math.Round(Util.GetDecimal(Disc), 2, MidpointRounding.AwayFromZero);
        
        row["TaxID"] = TaxID1;
        row["TaxPer"] = TaxPer1;      
 
        // GST Changes
        row["IGSTPercent"] = IGSTPer;
        row["CGSTPercent"] = CGSTPer;
        row["SGSTPercent"] = SGSTPer;
        row["GSTType"] = Util.GetString(ddlTAX1.SelectedItem.Text);
        row["HSNCode"] = Util.GetString(txtHSNCode.Text); 
        //----

        row["TotalTaxPer"] = TotalTax;
        row["NetAmt"] = Math.Round(Util.GetDecimal(NetAmt), 2, MidpointRounding.AwayFromZero);
        row["Remark"] = txtRemarks.Text;
        row["TaxAmt"] = Math.Round(Util.GetDecimal(taxAmt), 2, MidpointRounding.AwayFromZero); 
        row["IsActive"] = Active;
        row["TaxCalulatedOn"] = rblTaxCal.SelectedValue;
        row["Unit"] = StockReports.ExecuteScalar("SELECT IF(IFNULL(fid.majorUnit,'')='',im.majorUnit,fid.majorUnit)majorUnit  from f_itemmaster im LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' WHERE im.ItemID='" + lstItem.SelectedItem.Value.Split('#').GetValue(0).ToString() + "'");
        row["Manufacturer_ID"] = ddlManufacturer.SelectedValue.Split('#')[0];
        row["Manufacturer"] = ddlManufacturer.SelectedItem.Text;
        if(txtDeal1.Text!=string.Empty)
            row["Deal"] = txtDeal1.Text + "+" + txtDeal2.Text;
        else
            row["Deal"] = "";
        dtItems.Rows.Add(row);

        ViewState["dtItems"] = dtItems;
        if (dtItems != null)
        {
            gvRequestItems.DataSource = dtItems;
            gvRequestItems.DataBind();
            ViewState["dtItems"] = dtItems;

            ViewState["dtItems"] = dtItems;
            txtRate.Text = string.Empty;
            txtRemarks.Text = string.Empty;
            txtDiscAmt.Text = string.Empty;
            txtDiscPer.Text = string.Empty;
            txtMRP.Text = string.Empty;
            txtDeal1.Text = string.Empty;
            txtDeal2.Text = string.Empty;

            // GST Changes
            ddlTAX1.SelectedIndex = ddlTAX1.Items.IndexOf(ddlTAX1.Items.FindByValue("T4"));
            txtIGSTPer.Text = txtCGSTPer.Text = txtSGSTPer.Text = "0";
            txtHSNCode.Text = "";
            //---

            //for (int i = 0; i < grdTax.Rows.Count; i++)
            //{
            //    GridViewRow gvRow = grdTax.Rows[i];
            //    TextBox txtname = gvRow.FindControl("txtPer") as TextBox;
            //    txtname.Text = "";
            //}
        }
        lblMsg.Text = "";
        if (gvRequestItems.Rows.Count > 0)
        {
            btnSave.Enabled = true;
            ddlCategory.Enabled = false;
        }
    }

    protected void btnAddNewCat_Click(object sender, EventArgs e)
    {
        bindCategoryType();
        mpeCat.Show();
    }


    protected void btnRefershItem_Click(object sender, EventArgs e)
    {
        BindItemNew();
        if (ddlSubCategory.SelectedIndex != -1)
        {
            lstItem.Focus();
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key105", "$('.searchable').chosen('destroy').chosen({ width: '100%' });", true);
    }

    protected void btnReload_Click(object sender, EventArgs e)
    {
        BindVendor();
    }
    protected void BtnReloadMan_Click(object sender, EventArgs e)
    {
        BindManufacturer();
    }
    
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        if (ViewState["dtItems"] != null)
        {
            DataTable dtItems = (DataTable)ViewState["dtItems"];
            string StoreType = "";
            if (ddlCategory.SelectedItem.Value.Split('#')[0].ToString() == "LSHHI5")
                StoreType = "STO00001";
            else
                StoreType = "STO00002";

            if (dtItems.Rows.Count > 0)
            {
                try
                {
                    foreach (DataRow dr in dtItems.Rows)
                    {
                        string strquery = " INSERT INTO `f_storeitem_rate`(`ItemID`,`Vendor_ID`,`GrossAmt`,`DiscAmt`,`TaxAmt`,`NetAmt`,`FromDate`,`ToDate`,`Remarks`,`EntryDate`,`UserID`,`UserName`,IsActive,StoreType,TaxCalulatedOn,DeptLedgerNo,CentreID,Hospital_ID,Manufacturer_ID,MRP,IsDeal,GSTType,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent)" +
                        " VALUES('" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["VendorID"]) + "','" + Util.GetDecimal(dr["Rate"]) + "','" + Util.GetDecimal(dr["DiscAmt"]) + "','" + Util.GetDecimal(dr["TaxAmt"]) + "','" + Util.GetDecimal(dr["NetAmt"]) + "','" + Util.GetDateTime(dr["FromDate"]).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dr["ToDate"]).ToString("yyyy-MM-dd") + "','" + Util.GetString(dr["Remark"]) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetString(Session["ID"]) + "','" + Util.GetString(Session["UserName"]) + "','" + Util.GetString(dr["IsActive"]) + "','" + StoreType + "','" + Util.GetString(dr["TaxCalulatedOn"]) + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "','" + Session["HOSPID"].ToString() + "','" + dr["Manufacturer_ID"].ToString() + "','" + dr["MRP"].ToString() + "','" + dr["Deal"].ToString() + "','" + Util.GetString(dr["GSTType"]) + "','" + Util.GetString(dr["HSNCode"]) + "','" + Util.GetDecimal(dr["IGSTPercent"]) + "','" + Util.GetDecimal(dr["CGSTPercent"]) + "','" + Util.GetDecimal(dr["SGSTPercent"]) + "')";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strquery);

                        string query = " SELECT MAX(id) FROM f_storeitem_rate ";
                        string StoreId = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, query).ToString();                  
                        string taxid = Util.GetString(dr["TaxID"]);

                        strquery = " INSERT INTO f_storeitem_Tax(`StoreRateID`,`ITemID`,`TaxID`,`TaxPer`,`TaxAmt`,DeptLedgerNo,CentreID,Hospital_ID,GSTType,IGSTPercent,CGSTPercent,SGSTPercent)" +
                               " VALUES('" + StoreId + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["TaxID"]) + "','" + Util.GetDecimal(dr["TaxPer"]) + "','" + Util.GetDecimal(dr["TaxAmt"]) + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "','" + Session["HOSPID"].ToString() + "','" + Util.GetString(dr["GSTType"]) + "','" + Util.GetDecimal(dr["IGSTPercent"]) + "','" + Util.GetDecimal(dr["CGSTPercent"]) + "','" + Util.GetDecimal(dr["SGSTPercent"]) + "')";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strquery);
                    

                        if (Util.GetString(dr["IsActive"]) == "1")
                        {
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + Util.GetString(dr["ItemID"]) + "' AND isActive =1 and ID<>'" + StoreId + "' AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "' ");
                        }

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
                    lblMsg.Text = "Error...";
                }
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Save successfully ');", true);
                gvRequestItems.DataSource = null;
                gvRequestItems.DataBind();

                ddlVendor.SelectedIndex = 0;
                ddlCategory.SelectedIndex = 0;
                ddlManufacturer.SelectedIndex = 0;
                ddlCategory.Enabled = true;
                ddlSubCategory.Items.Clear();
                lstItem.Items.Clear();
                btnSave.Enabled = false;
                if (lstItem.SelectedIndex > -1)
                {
                   // GetItem();
                }
            }
        }
        ViewState["dtItems"] = null;
    }

    protected void btnSaveSub_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            d_SubcategoryMaster objSubCategoryMaster = new d_SubcategoryMaster(Tranx);
            objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0].ToString();
            objSubCategoryMaster.Name = txtSubCatName.Text.Trim();
            objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
            objSubCategoryMaster.DisplayPriority = Util.GetInt(txtSubPrintOrder.Text.Trim());
            objSubCategoryMaster.Abbreviation = txtSubAbb.Text.Trim();
            if (rdblstSubActive.SelectedItem.Value == "YES")
            {
                objSubCategoryMaster.Active = 1;
            }
            else if (rdblstSubActive.SelectedItem.Value == "NO")
            {
                objSubCategoryMaster.Active = 0;
            }
            objSubCategoryMaster.TypeDummy = "Dummy";

            string SubCategoryId = objSubCategoryMaster.Insert();

            if (SubCategoryId != "")
            {
                Tranx.Commit();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                BindSubcategory();
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubcategory();
        BindItemNew();
        ddlSubCategory.Focus();
    }

    protected void ddlCategoryName_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "1")
                chkScheduler.Visible = true;
            else
                chkScheduler.Visible = false;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void ddlCategoryType_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblRemarks.Text = ddlCategoryType.SelectedItem.Value.Split('#')[1];
    }

    protected void ddlItemGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstItem.SelectedIndex > -1)
        {
            GetItem();
        }
    }

    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItemNew();
        if (ddlSubCategory.SelectedItem.Value != "0")
        {
            lstItem.Focus();
        }
    }

    protected void GrdRateDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string ItemID = e.CommandArgument.ToString().Split('#')[0];
        int ID = Util.GetInt(e.CommandArgument.ToString().Split('#')[1]);
        string vendorID = Util.GetString(e.CommandArgument.ToString().Split('#')[2]);
        if (e.CommandName == "Active")
        {
            StockReports.ExecuteDML(" UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + ItemID + "' AND isActive =1 ");
            StockReports.ExecuteDML(" UPDATE  f_storeitem_rate SET IsActive=1 WHERE ItemID='" + ItemID + "' AND ID=" + ID + "  AND vendor_ID= '" + vendorID + "' ");
        }
        else
        {
            StockReports.ExecuteDML(" UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + ItemID + "' AND ID=" + ID + " ");
        }
        GetItem();
    }

    protected void gvRequestItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = GetItemDataTable();
            dtItem.Rows[args].Delete();
            gvRequestItems.DataSource = dtItem;
            gvRequestItems.DataBind();
            ViewState["dtItems"] = dtItem;
        }
        if (gvRequestItems.Rows.Count == 0)
            btnSave.Enabled = false;
    }
    private void BindItemNew()
    {
        lstItem.DataSource = null;
        lstItem.DataBind();
        string str = "select TypeName ,Concat(IM.ItemId,'#','N','#')ItemId from f_itemmaster IM  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 ";

        if (ddlSubCategory.SelectedIndex != -1)
        {
            if (ddlSubCategory.SelectedItem.Value != "ALL")
            {
                str = str + " AND IM.subcategoryid='" + ddlSubCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "' ";
            }
            if (ddlCategory.SelectedItem.Value.Split('#')[0].ToString() != "0")
            {
                str = str + " AND SM.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0].ToString() + "' ";
            }
            str = str + "   order by typename ";

            DataTable dt = StockReports.GetDataTable(str);
            lstItem.DataSource = dt;
            lstItem.DataTextField = "TypeName";
            lstItem.DataValueField = "ItemID";
            lstItem.DataBind();
            if (lstItem.SelectedIndex > -1)
            {
                GetItem();
            }
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
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        dv.RowFilter = "categoryid='" + ddlCategory.SelectedItem.Value.Split('#')[0].ToString() + "'";
        if (dv.Count > 0)
        {
            ddlSubCategory.DataSource = dv.ToTable();
            ddlSubCategory.DataTextField = "name";
            ddlSubCategory.DataValueField = "SubCategoryid";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("All", "ALL"));
        }
        else
        {
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataBind();
        }
    }

    private void BindTax()
    {
        string sql = "SELECT TaxName,TaxID FROM f_taxmaster WHERE TaxID IN ('T4','T6','T7') ORDER BY TaxName";

        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            ddlTAX1.DataSource = dt;
            ddlTAX1.DataTextField = "TaxName";
            ddlTAX1.DataValueField = "TaxID";
            ddlTAX1.DataBind();
            ddlTAX1.SelectedIndex = ddlTAX1.Items.IndexOf(ddlTAX1.Items.FindByValue("T4"));
        }
        else
        {
            ddlTAX1.Items.Clear();
            ddlTAX1.Items.Add("No Item Found");

        }
    }

    private void Clear()
    {
        txtDiscAmt.Text = string.Empty;
        txtRate.Text = string.Empty;
        txtRemarks.Text = string.Empty;
        txtDiscPer.Text = string.Empty;
        // ddlItemGroup.SelectedIndex = 0;
        ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        gvRequestItems.DataSource = null;
        gvRequestItems.DataBind();
        ViewState.Clear();
    }

    private void GetItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LedgerName VendorName,lm.LedgerNumber VendorID,sir.ItemID,sir.ID,im.`TypeName` AS ItemName,IF(sir.IsActive=1,'True','False')IsActive, ");
        sb.Append(" sir.`GrossAmt`AS Rate,sir.`DiscAmt`,sir.`NetAmt`,DATE_FORMAT(sir.`FromDate`, '%d-%b-%y')FromDate,DATE_FORMAT(sir.`ToDate`,'%d-%b-%y')ToDate,");
        sb.Append(" sir.`TaxAmt`,DATE_FORMAT( sir.`EntryDate`,'%d-%b-%y')EntryDate,sir.UserName, fmm.name,sir.Manufacturer_ID, ");

        // GST Changes
        sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent ");

        sb.Append(" FROM f_storeitem_rate sir INNER JOIN f_itemmaster im  ON im.ItemID=sir.ItemID INNER JOIN f_manufacture_master fmm  ON sir.Manufacturer_ID=fmm.ManufactureID  INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID ");
        sb.Append(" WHERE  sir.`ItemID`='" + lstItem.SelectedValue.Split('#')[0].ToString() + "' AND DATE(ToDate)>= CURRENT_DATE AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "' AND sir.CentreID='" + Session["CentreID"].ToString() + "' ");
        DataTable dtItemRate = new DataTable();
        dtItemRate = StockReports.GetDataTable(sb.ToString());
        if (dtItemRate != null && dtItemRate.Rows.Count > 0)
        {
            GrdRateDetail.DataSource = dtItemRate;
            GrdRateDetail.DataBind();
        }
        else
        {
            GrdRateDetail.DataSource = null;
            GrdRateDetail.DataBind();
        }
        if (lstItem.SelectedItem.Text != "")
            lblPerchaseUnit.Text = StockReports.ExecuteScalar("SELECT IF(IFNULL(fid.majorUnit,'')='',im.majorUnit,fid.majorUnit)majorUnit from f_itemmaster im LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' WHERE im.ItemID='" + lstItem.SelectedItem.Value.Split('#').GetValue(0).ToString() + "'");

    }

    private DataTable GetItemDataTable()
    {
        if (ViewState["dtItems"] != null)
        {
            return (DataTable)ViewState["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("VendorID");
            dtItem.Columns.Add("VendorName");
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("SubCategory");
            dtItem.Columns.Add("FromDate");
            dtItem.Columns.Add("ToDate");
            dtItem.Columns.Add("MRP");
            dtItem.Columns.Add("Rate");
            dtItem.Columns.Add("DiscAmt");
            dtItem.Columns.Add("DiscPer");
            dtItem.Columns.Add("TaxID");
            dtItem.Columns.Add("TaxPer");
            dtItem.Columns.Add("TotalTaxPer");
            dtItem.Columns.Add("NetAmt");
            dtItem.Columns.Add("Remark");
            dtItem.Columns.Add("TaxAmt");
            dtItem.Columns.Add("IsActive");
            dtItem.Columns.Add("Unit");
            dtItem.Columns.Add("TaxCalulatedOn");
            dtItem.Columns.Add("Manufacturer");
            dtItem.Columns.Add("Manufacturer_ID");
            dtItem.Columns.Add("Deal");


            // GST Changes
            dtItem.Columns.Add("GSTType",typeof(string));
            dtItem.Columns.Add("HSNCode", typeof(string));
            dtItem.Columns.Add("IGSTPercent", typeof(decimal));
            dtItem.Columns.Add("CGSTPercent", typeof(decimal));
            dtItem.Columns.Add("SGSTPercent", typeof(decimal));
            //----

            return dtItem;
        }
    }

    #region function called from PopUpCategory

    public void bindCategoryType()
    {
        DataTable dt = new DataTable();
        string str = "SELECT CONCAT(ID, '#', ConfigHelp)AS id, NAME	 FROM f_configrelation_master WHERE IsActive='1' and Id IN (28,11) order by NAME";
        dt = StockReports.GetDataTable(str);
        ddlCategoryType.DataSource = dt;
        ddlCategoryType.DataValueField = "id";
        ddlCategoryType.DataTextField = "Name";
        ddlCategoryType.DataBind();
        lblRemarks.Text = ddlCategoryType.SelectedItem.Value;
    }

    #endregion function called from PopUpCategory

    #region function called from PopUp SubCategory

    public void BindCategory()
    {
        try
        {
            string str = "select CONCAT(cm.CategoryID,'#',ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation c on cm.CategoryID =c.CategoryID where cm.active=1 AND c.ConfigID IN (11,28) union all select CONCAT(cm1.CategoryID,'#',ConfigID,'#','Y')CategoryID,cm1.Name from d_f_categorymaster cm1 inner join d_f_configrelation c1 on cm1.CategoryID =c1.CategoryID where cm1.active=1 and cm1.CategoryIDMain='' order by Name";
            DataTable dt = StockReports.GetDataTable(str);
            ddlCategoryName.DataSource = dt;
            ddlCategoryName.DataValueField = "CategoryID";
            ddlCategoryName.DataTextField = "Name";
            ddlCategoryName.DataBind();
            ddlCategoryName.Items.Insert(0, new ListItem("Select", "0"));

            if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "1")
                chkScheduler.Visible = true;
            else
                chkScheduler.Visible = false;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public void BindDisplayName()
    {
        string str = "select DisplayName from f_displaynamemaster where IsActive=1 AND DisplayName='MEDICINE & CONSUMABLES' order by DisplayName ";
        DataTable dt1 = StockReports.GetDataTable(str);
        ddlDisplayName.DataSource = dt1;
        ddlDisplayName.DataValueField = "DisplayName";
        ddlDisplayName.DataTextField = "DisplayName";
        ddlDisplayName.DataBind();
        ViewState["DisplayName"] = dt1;
    }

    protected void btnSaveCat_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            d_Category_Master objCategoryMaster = new d_Category_Master(Tranx);

            objCategoryMaster.Name = txtCatName.Text.Trim();
            if (rbtnCatActive.SelectedItem.Value == "1")
            {
                objCategoryMaster.Active = 1;
            }
            else if (rbtnCatActive.SelectedItem.Value == "0")
            {
                objCategoryMaster.Active = 0;
            }
            objCategoryMaster.Abbreviation = txtCatAbbreviation.Text.Trim();
            objCategoryMaster.UserID = "";
            string CategoryID = objCategoryMaster.Insert();

            D_Configrelation objconfigRelation = new D_Configrelation(Tranx);
            objconfigRelation.ConfigID = Util.GetInt(ddlCategoryType.SelectedItem.Value);
            objconfigRelation.CategoryID = CategoryID;
            objconfigRelation.ConfigIDMain = "";
            objconfigRelation.Name = txtCatName.Text.Trim();
            objconfigRelation.TypeDummy = "";
            int result = objconfigRelation.Insert();
            if (result > 0)
            {
                Tranx.Commit();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                BindCategoryNew();
            }
            else
            {
                Tranx.Rollback();
                con.Close();
                con.Dispose();
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    #endregion function called from PopUp SubCategory

}