using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.Services;

public partial class Design_Purchase_StoreItemsRate : System.Web.UI.Page
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
                BindTax();
                lblMsg.Text = "";
                Session.Remove("dtItems");
            }
        }
        ucToDate.Attributes.Add("readOnly", "true");
        ucFromDate.Attributes.Add("readOnly", "true");
        calEntryDate1.EndDate = DateTime.Now;
        calEntryDate2.StartDate = DateTime.Now;
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

    protected void btnReload_Click(object sender, EventArgs e)
    {

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
        //  GetItem();
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
        //  gvRequestItems.DataSource = null;
        // gvRequestItems.DataBind();
        ViewState.Clear();
    }

    [WebMethod]
    public static DataTable GetItemDataTable()
    {
        if (HttpContext.Current.Session["dtItems"] != null)
        {
            return (DataTable)HttpContext.Current.Session["dtItems"];
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
            dtItem.Columns.Add("GSTType", typeof(string));
            dtItem.Columns.Add("HSNCode", typeof(string));
            dtItem.Columns.Add("IGSTPercent", typeof(decimal));
            dtItem.Columns.Add("CGSTPercent", typeof(decimal));
            dtItem.Columns.Add("SGSTPercent", typeof(decimal));
            dtItem.Columns.Add("Profit");
            dtItem.Columns.Add("CategoryId");
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

    [WebMethod(EnableSession = true)]
    public static string BindCategoryDropDown()
    {
        string RoleId = HttpContext.Current.Session["RoleID"].ToString();
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
                //string Msg = "You do not have rights to Create Items ";
                // Response.Redirect("MsgPage.aspx?msg=" + Msg);
                return "1";
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
        }
        else
        {
            //string Msg = "You do not have rights to Create Items ";
            //Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            return "2";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindAllVendor()
    {
        DataTable dtVendor = AllLoadData_Store.bindVendor();
        if (dtVendor.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtVendor);
        }
        else
            return "";

    }

    [WebMethod]
    public static string BindItemList(string CategoryId, string SubCategory, string PreFix)
    {
        if (CategoryId != "0")
        {
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
            DataTable dtItem = StockReports.GetDataTable(str);
            if (dtItem.Rows.Count > 0)
            {
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
                return "No Item Found";
            }
        }
        else
        {
            return "1";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchSupplierQuotation(string Category, string SubCategory, string Vendor, string ItemGroup)
    {
        string str = " SELECT im.ItemID,im.TypeName ItemName,im.ManuFacturer,im.SubCategoryID, ";
        //GST Changes
        str += " IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent ";

        str += "  FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_storeitem_rate sir ON im.ItemID=sir.ItemID WHERE im.IsActive=1";
        str += " and sc.CategoryID='" + Category.Split('#').GetValue(0).ToString() + "'";

        if (SubCategory != "ALL")
            str += " AND im.subcategoryid='" + SubCategory.Split('#').GetValue(0).ToString() + "'";
        if (Vendor != "ALL")
            str += " AND sir.Vendor_ID='" + Vendor.Split('#')[0].ToString() + "'";
        if (ItemGroup != "0")
            str += " AND im.ItemID='" + ItemGroup.Split('#')[0].ToString() + "'";
        str += " AND DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' GROUP BY im.ItemID ORDER BY im.TypeName";
        DataTable dtItem = new DataTable();
        dtItem = StockReports.GetDataTable(str.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtItem);
    }

    [WebMethod(EnableSession = true)]
    public static string addItem(string Vendor, string ItemGroup)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT sir.`Vendor_ID` VendorLedgerNo,sir.ID AS StoreRateID ,sir.Profit, lm.LedgerName VendorName,sir.ItemID,im.TypeName AS ItemName,IF(sir.IsActive=1,'True','False')AppStatus,sir.GrossAmt  Rate,sir.DiscAmt,sir.TaxAmt,sir.NetAmt,sir.ID StoreRateID,  DATE_FORMAT(sir.FromDate,'%d-%b-%y')FromDate,DATE_FORMAT(sir.ToDate,'%d-%b-%y')ToDate,DATE_FORMAT( sir.`EntryDate`,'%d-%b-%y')EntryDate, ");
        sb.Append(" MRP,IsDeal,fmm.Name, ");

        // GST Changes
        sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent ");

        sb.Append(" FROM f_storeitem_rate sir  ");
        sb.Append(" INNER JOIN f_itemmaster im  ON im.ItemID=sir.ItemID  ");
        sb.Append(" left JOIN f_manufacture_master fmm  ON sir.Manufacturer_ID=fmm.ManufactureID  ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID  WHERE  DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
        if (Vendor != "Select" && Vendor != "0")
            sb.Append(" and sir.Vendor_ID='" + Vendor.Split('#')[0].ToString() + "' ");
        if (ItemGroup != "0")
            sb.Append(" AND im.ItemID='" + ItemGroup.Split('#')[0].ToString() + "'  ");
        sb.Append("     ORDER BY sir.id DESC ");
        dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static bool Setvendor(string VendorLedNo, string ItemID, string StoreRateID)
    {
        StockReports.ExecuteDML(" UPDATE f_storeitem_rate SET IsActive=0 WHERE ItemID='" + ItemID + "' AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  AND isActive =1  ");
        StockReports.ExecuteDML(" UPDATE f_storeitem_rate sir SET IsActive=1 WHERE sir.Vendor_ID='" + VendorLedNo + "' AND sir.ItemID='" + ItemID + "' AND sir.ID='" + StoreRateID + "' AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  ");
        return true;
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

    [WebMethod(EnableSession = true)]
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

    [WebMethod(EnableSession = true)]
    public static string AddItems(string ItemId, string UcFromDate, string UcTodate, string Subcategory, string VendorId, string VendorName, string ItemName, string rate, string Tax, string IGST, string CGST, string SGST, string DiscountPercent, string DiscAmt, string Deal1, string Deal2, string rblTaxCal, string chkIsActive, string MRP, string txtHSNCode, string txtRemarks, string Manufacturer_ID, string Manufacturer, string CategoryId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LedgerName VendorName,lm.LedgerNumber VendorID,sir.ItemID,sir.ID,im.`TypeName` AS ItemName,IF(sir.IsActive=1,'True','False')IsActive, ");
        sb.Append(" sir.`GrossAmt`AS Rate,sir.`DiscAmt`,sir.`NetAmt`,DATE_FORMAT(sir.`FromDate`, '%d-%b-%y')FromDate,DATE_FORMAT(sir.`ToDate`,'%d-%b-%y')ToDate,");
        sb.Append(" sir.`TaxAmt`,DATE_FORMAT( sir.`EntryDate`,'%d-%b-%y')EntryDate,sir.UserName, fmm.name,sir.Manufacturer_ID, ");
        // GST Changes
        sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent ");
        sb.Append(" FROM f_storeitem_rate sir INNER JOIN f_itemmaster im  ON im.ItemID=sir.ItemID INNER JOIN f_manufacture_master fmm  ON sir.Manufacturer_ID=fmm.ManufactureID  INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID ");
        sb.Append(" WHERE  sir.`ItemID`='" + ItemId.Split('#')[0].ToString() + "' AND DATE(ToDate)>= CURRENT_DATE AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND sir.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        DataTable dtItemRate = new DataTable();
        dtItemRate = StockReports.GetDataTable(sb.ToString());
        if (dtItemRate.Rows.Count > 0)
        {
            for (int i = 0; i < dtItemRate.Rows.Count; i++)
            {
                string status = dtItemRate.Rows[i]["IsActive"].ToString();
                if (status == "True")
                {
                    DateTime toDate = Util.GetDateTime(dtItemRate.Rows[i]["ToDate"].ToString());
                    DateTime entDate = Util.GetDateTime(UcFromDate.ToString());
                    string OldVendorID = Util.GetString(dtItemRate.Rows[i]["VendorID"].ToString());
                    string ddlVendorID = Util.GetString(VendorId.Split('#')[0].ToString());
                    string ManufacturerID_Old = Util.GetString(dtItemRate.Rows[i]["Manufacturer_ID"].ToString());
                    string ddlManufacturerID = Util.GetString(Manufacturer_ID.Split('#')[0].ToString());
                    if (OldVendorID == ddlVendorID && ManufacturerID_Old == ddlManufacturerID)
                    {
                        string Msg = "1";
                        return Msg;
                    }
                }
                else
                {
                    string Msg = "2";
                    return Msg;
                }
            }
        }

        DataTable dtItems = new DataTable();
        if (HttpContext.Current.Session["dtItems"] == null)
        {
            dtItems = GetItemDataTable();
        }
        else
        {
            dtItems = (DataTable)HttpContext.Current.Session["dtItems"];
        }

        //string TaxID = "";
        //string TaxPer = "";
        string TotalTax = "";
        decimal GrossAmt = Util.GetDecimal(rate.ToString());
        decimal StrRate = GrossAmt;
        decimal ExcisePer = 0, VATPer = 0;
        string TaxID1 = "", TaxPer1 = "";
        //foreach (GridViewRow gr in grdTax.Rows)
        //{
        string taxID = Util.GetString(Tax.ToString());

        decimal taxper = Util.GetDecimal(IGST.ToString()) + Util.GetDecimal(CGST.ToString()) + Util.GetDecimal(SGST.ToString());

        TaxID1 = taxID;
        TaxPer1 = taxper.ToString();
        VATPer = Util.GetDecimal(IGST.ToString()) + Util.GetDecimal(CGST.ToString()) + Util.GetDecimal(SGST.ToString());

        // GST Changes
        decimal IGSTPer = Util.GetDecimal(IGST.ToString());
        decimal CGSTPer = Util.GetDecimal(CGST.ToString());
        decimal SGSTPer = Util.GetDecimal(SGST.ToString());
        //----
        decimal UnitPrice = 0;
        decimal RE = 0; // Rate + Excise Amt
        decimal RED = 0; // Rate + Excise - Discount
        decimal VatAMt = 0;
        decimal ExciseAmt = 0;
        decimal Disc = 0, DiscAmt1 = 0;
        decimal Rate = Util.GetDecimal(rate.ToString());
        Disc = Util.GetDecimal(DiscountPercent.ToString());
        DiscAmt1 = Util.GetDecimal(DiscAmt.ToString());
        ExciseAmt = (Rate * ExcisePer) / 100;
        decimal Deal = Util.GetDecimal(Deal1.ToString());
        decimal TotalDeal = Util.GetDecimal(Deal1.ToString()) + Util.GetDecimal(Deal2.ToString());
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
            // UnitPrice = (Rate - ((Rate * Disc) / 100)) + ((Rate - ((Rate * Disc) / 100)) * VATPer / 100);
        }
        decimal taxAmt = Util.GetDecimal(VatAMt + ExciseAmt);
        decimal NetAmt = Util.GetDecimal(UnitPrice);
        TotalTax = Util.GetString(VATPer);
        int Active = 0;
        if (chkIsActive.ToString() == "true")
            Active = 1;
        DataRow row = dtItems.NewRow();
        row["VendorID"] = VendorId.Split('#')[0].ToString();
        row["VendorName"] = VendorName;
        row["ItemID"] = ItemId.Split('#')[0].ToString();
        row["ItemName"] = ItemName;
        row["SubCategory"] = Subcategory;
        row["FromDate"] = UcFromDate.ToString();
        row["ToDate"] = UcTodate.ToString();
        row["MRP"] = Math.Round(Util.GetDecimal(MRP.ToString()), 2, MidpointRounding.AwayFromZero);

        row["Rate"] = Math.Round(Util.GetDecimal(rate.ToString()), 2, MidpointRounding.AwayFromZero);
        row["DiscAmt"] = Math.Round(Util.GetDecimal(DiscAmt1), 2, MidpointRounding.AwayFromZero);
        row["DiscPer"] = Math.Round(Util.GetDecimal(Disc), 2, MidpointRounding.AwayFromZero);
        row["TaxID"] = TaxID1;
        row["TaxPer"] = TaxPer1;
        // GST Changes
        row["IGSTPercent"] = IGSTPer;
        row["CGSTPercent"] = CGSTPer;
        row["SGSTPercent"] = SGSTPer;
        row["GSTType"] = Util.GetString(Tax.ToString());
        row["HSNCode"] = Util.GetString(txtHSNCode.ToString());
        //----
        row["TotalTaxPer"] = TotalTax;
        row["NetAmt"] = Math.Round(Util.GetDecimal(NetAmt), 2, MidpointRounding.AwayFromZero);
        row["Remark"] = txtRemarks.ToString();
        row["TaxAmt"] = Math.Round(Util.GetDecimal(taxAmt), 2, MidpointRounding.AwayFromZero);
        row["IsActive"] = Active;
        row["TaxCalulatedOn"] = rblTaxCal.ToString();
        row["Unit"] = StockReports.ExecuteScalar("SELECT IF(IFNULL(fid.majorUnit,'')='',im.majorUnit,fid.majorUnit)majorUnit  from f_itemmaster im LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' WHERE im.ItemID='" + ItemId.Split('#')[0].ToString() + "'");
        row["Manufacturer_ID"] = Manufacturer_ID.Split('#')[0].ToString();
        row["Manufacturer"] = Manufacturer.ToString();
        if (Deal1.ToString() != string.Empty)
            row["Deal"] = Deal1.ToString() + "+" + Deal2.ToString();
        else
            row["Deal"] = "";
        decimal Mrp = Math.Round(Util.GetDecimal(MRP.ToString()), 2, MidpointRounding.AwayFromZero);
        row["Profit"] = ((Mrp - ((Mrp * VATPer) / (100 + VATPer))) - Util.GetDecimal(UnitPrice));
        row["CategoryId"] = CategoryId.ToString();
        dtItems.Rows.Add(row);
        HttpContext.Current.Session["dtItems"] = dtItems;
        if (dtItems != null)
        {
            HttpContext.Current.Session["dtItems"] = dtItems;
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtItems);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string DeleteRow(string RowId)
    {
        int args = Util.GetInt(RowId.ToString());
        DataTable dtItem = GetItemDataTable();
        dtItem.Rows[args].Delete();
        if (dtItem.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtItems"] = dtItem;
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtItem);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static bool SaveAllItems(string Category)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if (HttpContext.Current.Session["dtItems"] != null)
        {
            DataTable dtItems = (DataTable)HttpContext.Current.Session["dtItems"];
            string StoreType = "";
            if (dtItems.Rows.Count > 0)
            {
                try
                {
                    foreach (DataRow dr in dtItems.Rows)
                    {
                        if (Util.GetString(dr["CategoryId"]) == "LSHHI5")
                            StoreType = "STO00001";
                        else
                            StoreType = "STO00002";

                        string strquery = " INSERT INTO `f_storeitem_rate`(`ItemID`,`Vendor_ID`,`GrossAmt`,`DiscAmt`,`TaxAmt`,`NetAmt`,`FromDate`,`ToDate`,`Remarks`,`EntryDate`,`UserID`,`UserName`,IsActive,StoreType,TaxCalulatedOn,DeptLedgerNo,CentreID,Hospital_ID,Manufacturer_ID,MRP,IsDeal,GSTType,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,UpdatedBy,UpdatedDate,IPAddress,Profit)" +
                        " VALUES('" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["VendorID"]) + "','" + Util.GetDecimal(dr["Rate"]) + "','" + Util.GetDecimal(dr["DiscAmt"]) + "','" + Util.GetDecimal(dr["TaxAmt"]) + "','" + Util.GetDecimal(dr["NetAmt"]) + "','" + Util.GetDateTime(dr["FromDate"]).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dr["ToDate"]).ToString("yyyy-MM-dd") + "','" + Util.GetString(dr["Remark"]) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["UserName"]) + "','" + Util.GetString(dr["IsActive"]) + "','" + StoreType + "','" + Util.GetString(dr["TaxCalulatedOn"]) + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + dr["Manufacturer_ID"].ToString() + "','" + dr["MRP"].ToString() + "','" + dr["Deal"].ToString() + "','" + Util.GetString(dr["GSTType"]) + "','" + Util.GetString(dr["HSNCode"]) + "','" + Util.GetDecimal(dr["IGSTPercent"]) + "','" + Util.GetDecimal(dr["CGSTPercent"]) + "','" + Util.GetDecimal(dr["SGSTPercent"]) + "','','0001-01-01 00:00:00','" + All_LoadData.IpAddress() + "','" + Util.GetDecimal(dr["Profit"]) + "' )";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strquery);

                        string query = " SELECT MAX(id) FROM f_storeitem_rate ";
                        string StoreId = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, query).ToString();
                        string taxid = Util.GetString(dr["TaxID"]);

                        strquery = " INSERT INTO f_storeitem_Tax(`StoreRateID`,`ITemID`,`TaxID`,`TaxPer`,`TaxAmt`,DeptLedgerNo,CentreID,Hospital_ID,GSTType,IGSTPercent,CGSTPercent,SGSTPercent,UpdatedBy,UpdatedDate,IPAddress)" +
                               " VALUES('" + StoreId + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["TaxID"]) + "','" + Util.GetDecimal(dr["TaxPer"]) + "','" + Util.GetDecimal(dr["TaxAmt"]) + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Util.GetString(dr["GSTType"]) + "','" + Util.GetDecimal(dr["IGSTPercent"]) + "','" + Util.GetDecimal(dr["CGSTPercent"]) + "','" + Util.GetDecimal(dr["SGSTPercent"]) + "','','0001-01-01 00:00:00','" + All_LoadData.IpAddress() + "')";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strquery);
                        if (Util.GetString(dr["IsActive"]) == "1")
                        {
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + Util.GetString(dr["ItemID"]) + "' AND isActive =1 and ID<>'" + StoreId + "' AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
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
                    //lblMsg.Text = "Error...";
                }
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                HttpContext.Current.Session.Remove("dtItems");
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Save successfully ');", true);
                //gvRequestItems.DataSource = null;
                //gvRequestItems.DataBind();

                //ddlVendor.SelectedIndex = 0;
                //ddlCategory.SelectedIndex = 0;
                //ddlManufacturer.SelectedIndex = 0;
                //ddlCategory.Enabled = true;
                //ddlSubCategory.Items.Clear();
                //lstItem.Items.Clear();
                //btnSave.Enabled = false;
                //if (lstItem.SelectedIndex > -1)
                //{
                //    // GetItem();
                //}
                return true;
            }
            else
            {
                return false;
            }
        }
        HttpContext.Current.Session["dtItems"] = null;
        return false;
    }

    [WebMethod(EnableSession = true)]
    public static bool UpdateItem(string ItemId, string UcFromDate, string UcTodate, string VendorId, string VendorName, string ItemName, string rate, string Tax, string IGST, string CGST, string SGST, string DiscountPercent, string DiscAmt, string Deal1, string Deal2, string rblTaxCal, string chkIsActive, string MRP, string txtHSNCode, string txtRemarks, string Manufacturer_ID, string Manufacturer, string StoreRateId)
    {
        string Subcategory = "";
        string CategoryId = "";
        HttpContext.Current.Session.Remove("dtItems");
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fcm.CategoryID,fsm.Name FROM f_categorymaster fcm INNER JOIN f_subcategorymaster fsm ON fcm.CategoryID=fsm.CategoryID ");
        sb.Append(" INNER JOIN f_itemmaster IM  ON IM.SubCategoryID = fsm.SubCategoryID WHERE IM.ItemID='" + ItemId + "'  AND im.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            CategoryId = dt.Rows[0]["CategoryID"].ToString();
            Subcategory = dt.Rows[0]["Name"].ToString();
        }
        sb.Clear();
        DataTable dtItems = new DataTable();
        if (HttpContext.Current.Session["dtItems"] == null)
        {
            dtItems = GetItemDataTable();
        }
        else
        {
            dtItems = (DataTable)HttpContext.Current.Session["dtItems"];
        }
        string TotalTax = "";
        decimal GrossAmt = Util.GetDecimal(rate.ToString());
        decimal StrRate = GrossAmt;
        decimal ExcisePer = 0, VATPer = 0;
        string TaxID1 = "", TaxPer1 = "";
        string taxID = Util.GetString(Tax.ToString());
        decimal taxper = Util.GetDecimal(IGST.ToString()) + Util.GetDecimal(CGST.ToString()) + Util.GetDecimal(SGST.ToString());
        TaxID1 = taxID;
        TaxPer1 = taxper.ToString();
        VATPer = Util.GetDecimal(IGST.ToString()) + Util.GetDecimal(CGST.ToString()) + Util.GetDecimal(SGST.ToString());
        decimal IGSTPer = Util.GetDecimal(IGST.ToString());
        decimal CGSTPer = Util.GetDecimal(CGST.ToString());
        decimal SGSTPer = Util.GetDecimal(SGST.ToString());
        decimal UnitPrice = 0;
        decimal RE = 0; // Rate + Excise Amt
        decimal RED = 0; // Rate + Excise - Discount
        decimal VatAMt = 0;
        decimal ExciseAmt = 0;
        decimal Disc = 0, DiscAmt1 = 0;
        decimal Rate = Util.GetDecimal(rate.ToString());
        Disc = Util.GetDecimal(DiscountPercent.ToString());
        DiscAmt1 = Util.GetDecimal(DiscAmt.ToString());
        ExciseAmt = (Rate * ExcisePer) / 100;
        decimal Deal = Util.GetDecimal(Deal1.ToString());
        decimal TotalDeal = Util.GetDecimal(Deal1.ToString()) + Util.GetDecimal(Deal2.ToString());
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
            // UnitPrice = (Rate - ((Rate * Disc) / 100)) + ((Rate - ((Rate * Disc) / 100)) * VATPer / 100);
            UnitPrice = RED + VatAMt;
        }
        decimal taxAmt = Util.GetDecimal(VatAMt + ExciseAmt);
        decimal NetAmt = Util.GetDecimal(UnitPrice);
        TotalTax = Util.GetString(VATPer);
        int Active = 0;
        if (chkIsActive.ToString() == "true")
            Active = 1;
        DataRow row = dtItems.NewRow();
        row["VendorID"] = VendorId.Split('#')[0].ToString();
        row["VendorName"] = VendorName;
        row["ItemID"] = ItemId;
        row["ItemName"] = ItemName;
        row["SubCategory"] = Subcategory;
        row["FromDate"] = UcFromDate.ToString();
        row["ToDate"] = UcTodate.ToString();
        row["MRP"] = Math.Round(Util.GetDecimal(MRP.ToString()), 2, MidpointRounding.AwayFromZero);
        row["Rate"] = Math.Round(Util.GetDecimal(rate.ToString()), 2, MidpointRounding.AwayFromZero);
        row["DiscAmt"] = Math.Round(Util.GetDecimal(DiscAmt1), 2, MidpointRounding.AwayFromZero);
        row["DiscPer"] = Math.Round(Util.GetDecimal(Disc), 2, MidpointRounding.AwayFromZero);
        row["TaxID"] = TaxID1;
        row["TaxPer"] = TaxPer1;
        // GST Changes
        row["IGSTPercent"] = IGSTPer;
        row["CGSTPercent"] = CGSTPer;
        row["SGSTPercent"] = SGSTPer;
        row["GSTType"] = Util.GetString(Tax.ToString());
        row["HSNCode"] = Util.GetString(txtHSNCode.ToString());
        //----
        row["TotalTaxPer"] = TotalTax;
        row["NetAmt"] = Math.Round(Util.GetDecimal(NetAmt), 2, MidpointRounding.AwayFromZero);
        row["Remark"] = txtRemarks.ToString();
        row["TaxAmt"] = Math.Round(Util.GetDecimal(taxAmt), 2, MidpointRounding.AwayFromZero);
        row["IsActive"] = Active;
        row["TaxCalulatedOn"] = rblTaxCal.ToString();
        row["Unit"] = StockReports.ExecuteScalar("SELECT IF(IFNULL(fid.majorUnit,'')='',im.majorUnit,fid.majorUnit)majorUnit  from f_itemmaster im LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' WHERE im.ItemID='" + ItemId.Split('#')[0].ToString() + "'");
        if (Manufacturer == "")
            row["Manufacturer_ID"] = Manufacturer_ID.ToString();
        else
            row["Manufacturer_ID"] = Manufacturer_ID;
        row["Manufacturer"] = Manufacturer.ToString();
        if (Deal1.ToString() != string.Empty)
            row["Deal"] = Deal1.ToString() + "+" + Deal2.ToString();
        else
            row["Deal"] = "";
        decimal Mrp = Math.Round(Util.GetDecimal(MRP.ToString()), 2, MidpointRounding.AwayFromZero);
        row["Profit"] = ((Mrp - ((Mrp * VATPer) / (100 + VATPer))) - Util.GetDecimal(UnitPrice));
        dtItems.Rows.Add(row);
        HttpContext.Current.Session["dtItems"] = dtItems;
        if (dtItems != null)
        {
            HttpContext.Current.Session["dtItems"] = dtItems;
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            if (HttpContext.Current.Session["dtItems"] != null)
            {
                dtItems = (DataTable)HttpContext.Current.Session["dtItems"];
                string StoreType = "";
                if (CategoryId.ToString() == "LSHHI5")
                    StoreType = "STO00001";
                else
                    StoreType = "STO00002";
                if (dtItems.Rows.Count > 0)
                {
                    try
                    {
                        foreach (DataRow dr in dtItems.Rows)
                        {
                            sb.Clear();
                            sb.Append(" update f_storeitem_rate set ItemID='" + Util.GetString(dr["ItemID"]) + "', Vendor_ID='" + Util.GetString(dr["VendorID"]) + "',");
                            sb.Append("GrossAmt='" + Util.GetDecimal(dr["Rate"]) + "',DiscAmt='" + Util.GetDecimal(dr["DiscAmt"]) + "',TaxAmt='" + Util.GetDecimal(dr["TaxAmt"]) + "',");
                            sb.Append(" NetAmt='" + Util.GetDecimal(dr["NetAmt"]) + "',FromDate='" + Util.GetDateTime(dr["FromDate"]).ToString("yyyy-MM-dd") + "',");
                            sb.Append(" ToDate='" + Util.GetDateTime(dr["ToDate"]).ToString("yyyy-MM-dd") + "',Remarks='" + Util.GetString(dr["Remark"]) + "',");
                            sb.Append(" IsActive='" + Util.GetString(dr["IsActive"]) + "',StoreType='" + StoreType + "',TaxCalulatedOn='" + Util.GetString(dr["TaxCalulatedOn"]) + "', ");
                            sb.Append(" DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "',Manufacturer_ID='" + dr["Manufacturer_ID"].ToString() + "',");
                            sb.Append(" MRP='" + dr["MRP"].ToString() + "',IsDeal='" + dr["Deal"].ToString() + "',GSTType='" + Util.GetString(dr["GSTType"]) + "',");
                            sb.Append(" HSNCode='" + Util.GetString(dr["HSNCode"]) + "',IGSTPercent='" + Util.GetDecimal(dr["IGSTPercent"]) + "',");
                            sb.Append(" CGSTPercent='" + Util.GetDecimal(dr["CGSTPercent"]) + "',SGSTPercent='" + Util.GetDecimal(dr["SGSTPercent"]) + "'");
                            sb.Append(",UpdatedBy='" + HttpContext.Current.Session["Id"].ToString() + "',UpdatedDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "'");
                            sb.Append(" ,IPAddress='" + All_LoadData.IpAddress() + "' ,Profit='" + Util.GetDecimal(dr["Profit"]) + "' ");
                            sb.Append(" where Id='" + StoreRateId + "'");
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                            //strquery = " INSERT INTO f_storeitem_Tax(`StoreRateID`,`ITemID`,`TaxID`,`TaxPer`,`TaxAmt`,DeptLedgerNo,CentreID,Hospital_ID,GSTType,IGSTPercent,CGSTPercent,SGSTPercent)" +
                            //       " VALUES('" + StoreId + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["TaxID"]) + "','" + Util.GetDecimal(dr["TaxPer"]) + "','" + Util.GetDecimal(dr["TaxAmt"]) + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Util.GetString(dr["GSTType"]) + "','" + Util.GetDecimal(dr["IGSTPercent"]) + "','" + Util.GetDecimal(dr["CGSTPercent"]) + "','" + Util.GetDecimal(dr["SGSTPercent"]) + "')";
                            sb.Clear();
                            sb.Append(" UPDATE f_storeitem_Tax SET TaxID='" + Util.GetString(dr["TaxID"]) + "',TaxPer='" + Util.GetDecimal(dr["TaxPer"]) + "',TaxAmt='" + Util.GetDecimal(dr["TaxAmt"]) + "',DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "',GSTType='" + Util.GetString(dr["GSTType"]) + "',IGSTPercent='" + Util.GetString(dr["IGSTPercent"]) + "',CGSTPercent='" + Util.GetString(dr["CGSTPercent"]) + "',SGSTPercent='" + Util.GetString(dr["SGSTPercent"]) + "' ");
                            sb.Append(",UpdatedBy='" + HttpContext.Current.Session["Id"].ToString() + "',UpdatedDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "'");
                            sb.Append(" ,IPAddress='" + All_LoadData.IpAddress() + "'");
                            sb.Append(" where StoreRateID='" + StoreRateId + "'");
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                            //if (Util.GetString(dr["IsActive"]) == "1")
                            //{
                            //   MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + Util.GetString(dr["ItemID"]) + "' AND isActive =1 and ID<>'" + StoreId + "' AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
                            // }
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
                        //lblMsg.Text = "Error...";
                    }
                    Tranx.Commit();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    HttpContext.Current.Session.Remove("dtItems");
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Save successfully ');", true);
                    //gvRequestItems.DataSource = null;
                    //gvRequestItems.DataBind();

                    //ddlVendor.SelectedIndex = 0;
                    //ddlCategory.SelectedIndex = 0;
                    //ddlManufacturer.SelectedIndex = 0;
                    //ddlCategory.Enabled = true;
                    //ddlSubCategory.Items.Clear();
                    //lstItem.Items.Clear();
                    //btnSave.Enabled = false;
                    //if (lstItem.SelectedIndex > -1)
                    //{
                    //    // GetItem();
                    //}
                    return true;
                }
                else
                {
                    return false;
                }
            }
            HttpContext.Current.Session["dtItems"] = null;
            return false;
        }
        else
        {
            return true;
        }
    }
  
}