using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Web.UI.HtmlControls;
public partial class Design_Store_ItemMaster : System.Web.UI.Page
{
    public static string BtnID;
    private static string ItemID;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategory();
            rdoUsabletype.Attributes.Add("OnClick", " return txtvisble()");
            btnSave.Attributes.Add("OnClick", "return valdte()");

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            if (Session["IsStore"] != null && Session["IsStore"].ToString() == "1")
            {
                if (ddlCategory.SelectedIndex > 0)
                {
                    if (Util.GetInt(ddlCategory.SelectedValue.Split('#')[1]) == 11)
                    {
                        chkIsExpirable.Checked = true;
                    }
                }
                else
                {
                    chkIsExpirable.Checked = false;
                }
            }

            BindManufacture();
            BindVatType();
            BindVatLine();
            BindSaleVatType();
            BindSaleVatLine();
            //BindCategory();
            if (ddlCategory.SelectedIndex != 0)
            {
                ddlSubCategory.Items.AddRange(LoadItems(CreateStockMaster.LoadSubCategoryByCategory(ddlCategory.SelectedItem.Value.Split('#')[0].ToString())));
                ddlSubCategory.DataBind();

                lnkView.Text = "View Editable Data of " + ddlSubCategory.SelectedItem.Text;
                lnkReport.Text = "Report of " + ddlSubCategory.SelectedItem.Text;
            }
            ddlSubCategory.Items.Insert(0, new ListItem("ALL", "0"));
            ddlSubCategory.Enabled = false;
            btnSave.Enabled = false;
            ddlGroup.Enabled = false;
            chkIsTrigger.Visible = false;
            chkIsAsset.Visible = false;
            divisAsset.Visible = false;

            ddl_salt.Visible = false;
            spnStrength.Visible = false;
            txtstrength.Visible = false;
            bind_salt();
            BindDrugCategoryMaster();
            BindMajorUnit();
            BindMinorUnit();
            BindGroup();
            BindServiceItems();
            ddlMedicineType.DataSource = AllGlobalFunction.MedicineType;
            ddlMedicineType.DataBind();
            ddlRoute.DataSource = AllGlobalFunction.Route;
            ddlRoute.DataBind();

            BindGSTType();

            if (Request.QueryString["Mode"] != null)
            {
                string mode = Request.QueryString["Mode"].ToString();
                if (mode == "1")
                {
                    //Master.FindControl("mnuHIS").Visible = false;
                    //Master.FindControl("ddlUserName").Visible = false;
                    // Master.FindControl("lnkSignOut").Visible = false;
                    var divNav = (HtmlControl)Master.FindControl("divMasterNav");
                    divNav.Attributes.CssStyle.Add("display", "none");
                }
            }
            ddlCategory.Focus();
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
            {
                ChkIsCSSD.Enabled = true;
                ChkIsLaundry.Enabled = true;
            }
            else
            {
                ChkIsCSSD.Enabled = false;
                ChkIsLaundry.Enabled = false;               
            }
        }
    }



    public void bindInventoryGrid()
    {
        StringBuilder sb = new StringBuilder();
        if (Resources.Resource.IsGSTApplicable == "0")
        {
            sb.Append("Select im.ItemDose, im.IsStockable,IFNULL(im.`ItemType`,'') AS ItemType,im.MinorUnit,im.TypeName,im.IsExpirable,im.ItemCode,im.ItemCatalog,im.SaleTaxPer,(fsm.Name)SubcategoryName,(fsm.SubCategoryID)SubID,Route, ");
            sb.Append(" ( SELECT NAME FROM f_manufacture_master MM WHERE MM.ManufactureID=im.ManufactureID )  ManuFacturer,em.Name, ");
            sb.Append(" Date_Format(im.CreaterDateTime,'%d-%b-%Y')CreaterDateTime,im.ItemID,im.Type_id,im.tobebilled,im.Description, ");
            sb.Append(" im.SubCategoryID,im.IsTrigger,TIME_FORMAT(im.StartTime,'%H:%I:%S')StartTime,TIME_FORMAT(im.EndTime,'%H:%I:%S')EndTime, ");
            sb.Append(" TIME_FORMAT(im.BufferTime,'%H:%I:%S')BufferTime,im.IsActive,im.BillingUnit,im.Pulse,im.rack,im.shelf, ");

            sb.Append(" IF(IFNULL(fid.ConversionFactor,'')='',im.ConversionFactor,fid.ConversionFactor)ConversionFactor, ");
            sb.Append(" IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)MajorUnit,IF(IFNULL(fid.minorUnit,'')='',im.UnitType,fid.minorUnit)UnitType, ");
            sb.Append(" IF(IFNULL(fid.maxlevel,'')='',im.maxlevel,fid.maxlevel)maxLevel,IF(IFNULL(fid.minlevel,'')='',im.minlevel,fid.minlevel)minlevel,");
            sb.Append(" IF(IFNULL(fid.reorderlevel,'')='',im.reorderlevel,fid.reorderlevel)reorderLevel,IF(IFNULL(fid.reorderqty,'')='',im.reorderqty,fid.reorderqty)reorderqty,");
            sb.Append(" IF(IFNULL(fid.maxreorderqty,'')='',im.maxreorderqty,fid.maxreorderqty)maxreorderqty,IF(IFNULL(fid.minreorderqty,'')='',im.minreorderqty,fid.minreorderqty)minreorderqty,");

            sb.Append(" im.packing,im.ManufactureID,im.PurchaseQty,im.SaleQty, ");
            sb.Append(" im.SaleUnitType,im.IsUsable,im.ServiceItemID,im.ScheduleType,(SELECT typeName FROM f_itemmaster WHERE itemID=im.ServiceItemID)ServicetypeName,im.CommodityCode ");
            sb.Append(" ,im.HSNCode,im.IGSTPercent,im.SGSTPercent,im.CGSTPercent,im.GSTType,im.IsStent,IFNULL(im.DrugCategoryMasterID,'0') DrugCategoryMasterID,im.SellingMargin ,im.IsOnSellingPrice,IFNULL(im.IsStockable,'0') IsStockable,im.VatType,im.VatLine,im.SaleVatLine,im.SaleVatType,im.DefaultSaleVatPercentage,im.DefaultPurchaseVatPercentage,im.isLaundry,im.isCSSDItem ");
            sb.Append(" from f_itemmaster im inner join employee_master em on em.EmployeeID=im.CreaterID inner join f_subcategorymaster fsm on im.SubCategoryID=fsm.SubCategoryID ");
            sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID and fid.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");

            sb.Append(" where im.itemid <>'' and fsm.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "' ");
        }
        else
        {
            sb.Append("Select im.ItemDose,im.IsStockable,im.MinorUnit,im.TypeName,im.IsExpirable,im.ItemCode,im.ItemCatalog,im.SaleTaxPer,(fsm.Name)SubcategoryName,(fsm.SubCategoryID)SubID,Route, ");
            sb.Append(" ( SELECT NAME FROM f_manufacture_master MM WHERE MM.ManufactureID=im.ManufactureID )  ManuFacturer,em.Name, ");
            sb.Append(" Date_Format(im.CreaterDateTime,'%d-%b-%Y')CreaterDateTime,im.ItemID,im.Type_id,im.tobebilled,im.Description, ");
            sb.Append(" im.SubCategoryID,im.IsTrigger,TIME_FORMAT(im.StartTime,'%H:%I:%S')StartTime,TIME_FORMAT(im.EndTime,'%H:%I:%S')EndTime, ");
            sb.Append(" TIME_FORMAT(im.BufferTime,'%H:%I:%S')BufferTime,im.IsActive,im.BillingUnit,im.Pulse,im.rack,im.shelf, ");

            sb.Append(" IF(IFNULL(fid.ConversionFactor,'')='',im.ConversionFactor,fid.ConversionFactor)ConversionFactor, ");
            sb.Append(" IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)MajorUnit,IF(IFNULL(fid.minorUnit,'')='',im.UnitType,fid.minorUnit)UnitType, ");
            sb.Append(" IF(IFNULL(fid.maxlevel,'')='',im.maxlevel,fid.maxlevel)maxLevel,IF(IFNULL(fid.minlevel,'')='',im.minlevel,fid.minlevel)minlevel,");
            sb.Append(" IF(IFNULL(fid.reorderlevel,'')='',im.reorderlevel,fid.reorderlevel)reorderLevel,IF(IFNULL(fid.reorderqty,'')='',im.reorderqty,fid.reorderqty)reorderqty,");
            sb.Append(" IF(IFNULL(fid.maxreorderqty,'')='',im.maxreorderqty,fid.maxreorderqty)maxreorderqty,IF(IFNULL(fid.minreorderqty,'')='',im.minreorderqty,fid.minreorderqty)minreorderqty,");

            sb.Append(" im.packing,im.ManufactureID,im.PurchaseQty,im.SaleQty, ");
            sb.Append(" im.SaleUnitType,im.IsUsable,im.ServiceItemID,im.ScheduleType,(SELECT typeName FROM f_itemmaster WHERE itemID=im.ServiceItemID)ServicetypeName,im.CommodityCode ");
            sb.Append(" ,im.HSNCode,ROUND(im.IGSTPercent,2)IGSTPercent,ROUND(im.SGSTPercent,2)SGSTPercent,ROUND(im.CGSTPercent,2)CGSTPercent,im.GSTType,im.IsStent,im.SellingMargin ,im.IsOnSellingPrice,im.isLaundry,im.isCSSDItem ");//im.isCSSDItem,im.isLaundry
            sb.Append(" from f_itemmaster im inner join employee_master em on em.EmployeeID=im.CreaterID inner join f_subcategorymaster fsm on im.SubCategoryID=fsm.SubCategoryID ");
            sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");

            sb.Append(" where im.itemid <>'' and fsm.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "' ");
        }
        if (ViewState["lnk"].ToString() == lnkView.Text)
        {
            if (txtSearch.Text.Trim() != string.Empty)
            {
                sb.Append(" and im.TypeName like '" + txtSearch.Text.Trim() + "%'");
            }
        }
        else
        {
            if (txtSearch.Text.Trim() != string.Empty)
                if (txtSearch.Text.Trim() != string.Empty)
                {
                    sb.Append(" and im.TypeName like '%" + txtSearch.Text.Trim() + "%'");
                }
        }
        if (ddlSubCategory.SelectedIndex != 0)
        {
            sb.Append(" and  im.SubCategoryID = '" + ddlSubCategory.SelectedValue + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ViewState["dt"] = dt;
        if (dt.Rows.Count > 0)
        {
            if (Resources.Resource.IsGSTApplicable == "0")
            {
                grdServiceItems.DataSource = ViewState["dt"];
                grdServiceItems.DataBind();
            }
            else
            {
                grdServiceItemsGST.DataSource = ViewState["dt"];
                grdServiceItemsGST.DataBind();
            }
        }
        else
        {
            if (Resources.Resource.IsGSTApplicable == "0")
            {
                grdServiceItems.DataSource = null;
                grdServiceItems.DataBind();
                lblMessage.Visible = true;
                lblMessage.Text = "No Record Found";
            }
            else
            {
                grdServiceItemsGST.DataSource = null;
                grdServiceItemsGST.DataBind();
                lblMessage.Visible = true;
                lblMessage.Text = "No Record Found";
            }
        }
        ClearFields();
    }

    #region All Drop Down Bind

    public void BindManufacture()
    {
        int chk = 0;
        if (chkIsAsset.Checked == true)
        {
            chk = 1;
        }
        else { chk = 0; }
        string str1 = "select Name,ManufactureID from f_manufacture_master where IsActive = 1 AND IsAsset='" + chk + "' order by Name";

        DataTable dt1 = new DataTable();
        dt1 = StockReports.GetDataTable(str1);

        if (dt1.Rows.Count > 0)
        {
            ddlmanufacture.DataSource = dt1;
            ddlmanufacture.DataTextField = "Name";
            ddlmanufacture.DataValueField = "ManufactureID";
            ddlmanufacture.DataBind();

            ddlmanufacture.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlmanufacture.Items.Clear();
        }
    }

    public void BindVatType()
    {

        string str1 = "select Id,VatType from f_purchase_item_vat_type_master where IsActive = 1";

        DataTable dt2 = new DataTable();
        dt2 = StockReports.GetDataTable(str1);

        if (dt2.Rows.Count > 0)
        {
            ddlVATType.DataSource = dt2;
            ddlVATType.DataTextField = "VatType";
            ddlVATType.DataValueField = "Id";
            ddlVATType.DataBind();

        }
        else
        {
            ddlVATType.Items.Clear();
        }


        ddlVATType.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BindVatLine()
    {

        string str1 = "select Id,VatLine from f_purchase_vat_line_master where IsActive = 1";

        DataTable dt3 = new DataTable();
        dt3 = StockReports.GetDataTable(str1);

        if (dt3.Rows.Count > 0)
        {
            ddlVATLine.DataSource = dt3;
            ddlVATLine.DataTextField = "VatLine";
            ddlVATLine.DataValueField = "Id";
            ddlVATLine.DataBind();
        }
        else
        {
            ddlVATLine.Items.Clear();
        }
        ddlVATLine.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BindSaleVatType()
    {

        string str1 = "select concat(Id,'#',ifnull(VATPer,0))Id,concat(VatType,'(',Description,')')VatType from f_sale_item_vat_type_master where IsActive = 1 ";

        DataTable dt2 = new DataTable();
        dt2 = StockReports.GetDataTable(str1);

        if (dt2.Rows.Count > 0)
        {
            ddlSaleVatType.DataSource = dt2;
            ddlSaleVatType.DataTextField = "VatType";
            ddlSaleVatType.DataValueField = "Id";
            ddlSaleVatType.DataBind();

        }
        else
        {
            ddlSaleVatType.Items.Clear();
        }


        ddlSaleVatType.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BindGSTType()
    {

        string str1 = "SELECT cc.ID,CONCAT(cc.`TaxGroup`, '(',ROUND((IFNULL(cc.`CGSTPer`,0)+IFNULL(cc.`SGSTPer`,0)+IFNULL(cc.`IGSTPer`,0)),2),')') AS TaxGroup FROM store_taxgroup_category cc WHERE cc.IsActive=1  ";

        DataTable dt2 = new DataTable();
        dt2 = StockReports.GetDataTable(str1);

        if (dt2.Rows.Count > 0)
        {

            ddlGSTType.DataSource = dt2;
            ddlGSTType.DataTextField = "TaxGroup";
            ddlGSTType.DataValueField = "ID";
            ddlGSTType.DataBind();

        }
        else
        {
            ddlGSTType.Items.Clear();
        }


        ddlGSTType.Items.Insert(0, new ListItem("Select", "0"));
    }


    public void BindSaleVatLine()
    {

        string str1 = "select Id,VatLine from f_sale_vat_line_master where IsActive = 1";

        DataTable dt3 = new DataTable();
        dt3 = StockReports.GetDataTable(str1);

        if (dt3.Rows.Count > 0)
        {
            ddlSaleVatLine.DataSource = dt3;
            ddlSaleVatLine.DataTextField = "VatLine";
            ddlSaleVatLine.DataValueField = "Id";
            ddlSaleVatLine.DataBind();
        }
        else
        {
            ddlSaleVatLine.Items.Clear();
        }

        ddlSaleVatLine.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BindDrugCategoryMaster()
    {
        DataTable dataTable = StockReports.GetDataTable("SELECT id,drugcategoryName FROM DrugCategoryMaster where isactive=1");
        ddlDrugCategory.DataSource = dataTable;
        ddlDrugCategory.DataValueField = "id";
        ddlDrugCategory.DataTextField = "drugcategoryName";
        ddlDrugCategory.DataBind();
        ddlDrugCategory.Items.Insert(0, new ListItem("Select", "0"));



    }

    protected void BindMajorUnit()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("select UnitName from f_purchase_unit_master ORDER BY unitname");

        ddl_MajorUnit.DataSource = dt;
        ddl_MajorUnit.DataTextField = "UnitName";
        ddl_MajorUnit.DataValueField = "UnitName";
        ddl_MajorUnit.DataBind();
        ddl_MajorUnit.Items.Insert(0, "Select");
    }

    protected void BindMinorUnit()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("select UnitName from f_unit_master ORDER BY unitname");

        ddl_minor.DataSource = dt;
        ddl_minor.DataTextField = "UnitName";
        ddl_minor.DataValueField = "UnitName";
        ddl_minor.DataBind();
        ddl_minor.Items.Insert(0, "Select");
    }

    private void BindCategory()
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
                Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            }
            DataTable cat = dv.ToTable();
            cat.Columns.Add("CategoryWithConfig", typeof(String));
            for (int i = 0; i < cat.Rows.Count; i++)
            {
                cat.Rows[i]["CategoryWithConfig"] = cat.Rows[i]["CategoryID"].ToString() + "#" + cat.Rows[i]["ConfigID"].ToString();
            }
            cat.AcceptChanges();




            ddlCategory.DataSource = cat;
            ddlCategory.DataValueField = "CategoryWithConfig";
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

    private void BindGroup()
    {
        string strQuery = "";
        int chkasset = 0;
        if (chkIsAsset.Checked == true)
        {
            chkasset = 1;
        }
        else
        {
            chkasset = 0;
        }
        if (ddlCategory.SelectedIndex > 0)
        {
            if (Util.GetInt(ddlCategory.SelectedValue.Split('#')[1]) == 11)
            {
                strQuery = "Select CONCAT(sc.Name,' ( ',cm.Name,' )')Name,sc.SubCategoryID " +
            "from f_subcategorymaster sc inner join f_configrelation cf on " +
            "sc.CategoryID = cf.CategoryID inner join f_categorymaster cm on cm.CategoryID = cf.CategoryID " +
            "where cf.ConfigID=11  AND sc.Active=1 AND sc.IsAsset='" + chkasset + "'";
            }
            else if (Util.GetInt(ddlCategory.SelectedValue.Split('#')[1]) == 28)
            {
                strQuery = "Select CONCAT(sc.Name,' ( ',cm.Name,' )')Name,sc.SubCategoryID " +
            "from f_subcategorymaster sc inner join f_configrelation cf on " +
            "sc.CategoryID = cf.CategoryID inner join f_categorymaster cm on cm.CategoryID = cf.CategoryID " +
            "where cf.ConfigID=28  AND sc.Active=1 AND sc.IsAsset='" + chkasset + "'";
            }
        }
        else
        {
            strQuery = "Select CONCAT(sc.Name,' ( ',cm.Name,' )')Name,sc.SubCategoryID " +
        "from f_subcategorymaster sc inner join f_configrelation cf on " +
        "sc.CategoryID = cf.CategoryID inner join f_categorymaster cm on cm.CategoryID = cf.CategoryID " +
        "where cf.ConfigID IN (11,28) AND sc.Active=1 AND sc.IsAsset='" + chkasset + "'";
        }
        if (ddlCategory.SelectedIndex == 1 || ddlCategory.SelectedIndex == 2 || ddlCategory.SelectedIndex == 3)
        {
            strQuery = strQuery + " AND cm.Name='" + ddlCategory.SelectedItem.Text + "' ";
        }
        strQuery = strQuery + " order by cm.Name,sc.Name ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQuery);
        ddlGroup.DataSource = dt;
        ddlGroup.DataTextField = "Name";
        ddlGroup.DataValueField = "SubCategoryID";
        ddlGroup.DataBind();
        ddlGroup.Items.Insert(0, "Select");
    }

    private void BindServiceItems()
    {
        string str = " select im.ItemID,im.TypeName from f_configrelation con inner join f_subcategorymaster sc on con.CategoryID=sc.CategoryID " +
                   " inner join f_itemmaster im on sc.SubCategoryID=im.SubCategoryID " +
                   " where con.ConfigID in (2,6,7,8,9,10,25,20,14,26,27) and im.Isactive=1 order by im.TypeName ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlServiceItems.DataSource = dt;
            ddlServiceItems.DataTextField = "TypeName";
            ddlServiceItems.DataValueField = "ItemID";
            ddlServiceItems.DataBind();
            ddlServiceItems.Items.Insert(0, new ListItem("Select", ""));
        }
    }

    private void bind_salt()
    {
        string str = " SELECT SaltID as VALUE ,NAME as Name FROM  f_salt_master WHERE IsActive=1 ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {

            ddl_salt.DataSource = dt;

            ddl_salt.DataTextField = "Name";
            ddl_salt.DataValueField = "Value";
            ddl_salt.DataBind();

            ddl_salt.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddl_salt.SelectedValue = null;

        }

    }

    #endregion All Drop Down Bind

    #region All On Click Function

    protected void btn_Add_Click(object sender, EventArgs e)
    {
    }

    protected void btn_addunit_Click(object sender, EventArgs e)
    {
        if (txt_AddUnit.Text.Trim() == "")
        {
            txt_AddUnit.Focus();
            lblErroeFormula.Text = "Please Enter Sale Unit";
            ModalPopupExtender1.Show();
            return;
        }

        int countSaleUnit = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_unit_master where UnitName='" + txt_AddUnit.Text.Trim() + "' "));

        if (countSaleUnit > 0)
        {
            lblErroeFormula.Text = "Sale Unit Already Exist";
            ModalPopupExtender1.Show();
            return;
        }
        else
        {
            StockReports.ExecuteDML("insert into f_unit_master (UnitName,CreatedBy) values('" + txt_AddUnit.Text.Trim() + "','" + ViewState["ID"].ToString() + "')");
            lblMessage.Text = "Record Saved Successfully";
            ModalPopupExtender1.Hide();
            txt_AddUnit.Text = "";

            lblErroeFormula.Text = "";
            BindMinorUnit();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearFields();
        btnSave.Text = "Save";
    }

    protected void btnPurchaseUnitSave_Click(object sender, EventArgs e)
    {
        if (txtPurchaseUnit.Text.Trim() == "")
        {
            txtPurchaseUnit.Focus();
            lblPurchaseUnit.Text = "Please Enter Purchase Unit";
            ModalPopupExtender2.Show();
            return;
        }
        string StrUnit = string.Empty;
        int countPurchaseUnit = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_purchase_unit_master where UnitName='" + txtPurchaseUnit.Text.Trim() + "' "));

        if (countPurchaseUnit > 0)
        {
            lblPurchaseUnit.Text = "Purchase Unit Already Exist";
            ModalPopupExtender2.Show();
            return;
        }
        else
        {
            StockReports.ExecuteDML("insert into f_purchase_unit_master (UnitName,CreatedBy) values('" + txtPurchaseUnit.Text.Trim() + "','" + ViewState["ID"].ToString() + "')");
            lblMessage.Text = "Record Saved Successfully";
            ModalPopupExtender2.Hide();
            txtPurchaseUnit.Text = "";
            lblPurchaseUnit.Text = "";
            BindMajorUnit();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //btnSave.Attributes.CssStyle.Add("disabled", "disable");
        btnSave.Enabled = false;
        string ScheduleType = string.Empty;
        string MedicineType = string.Empty;
        string IsGenericExist = string.Empty;
        string Route = string.Empty;
        if (txtName.Text.Trim().Length <= 1)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Item Name Required";
            txtName.Focus();
            return;
        }
        //if (txtDesc.Text.Trim() == "")
        //{
        //    lblMessage.Visible = true;
        //    lblMessage.Text = "Description Required";
        //    txtDesc.Focus();
        //    return;
        //}
        if (ddlGroup.SelectedIndex == 0)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Please Select Group";
            ddlGroup.Focus();
            btnSave.Enabled = true;
            return;
        }
        if (ddlmanufacture.SelectedIndex == 0 && ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Please Select Manufacturer";
            ddlmanufacture.Focus();
            btnSave.Enabled = true;
            return;
        }

        if (chkGenric.Checked)
        {
            IsGenericExist = "Yes";
            if (ddl_salt.SelectedIndex == 0)
            {
                lblMessage.Visible = true;
                lblMessage.Text = "Please Select Generic Item";
                ddl_salt.Focus();
                btnSave.Enabled = true;
                return;
            }
            if (txtstrength.Text.Trim() == "")
            {
                lblMessage.Visible = true;
                lblMessage.Text = "Please Enter Strength";
                txtstrength.Focus();
                btnSave.Enabled = true;
                return;
            }
            IsGenericExist = "Yes";
        }

        if (rdoItemType.SelectedIndex != 0 && rdoItemType.SelectedIndex != 1 && rdoItemType.SelectedIndex != 2)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Select For Which Department You Are Creating Item ";
            ListItem li = rdoItemType.Items.FindByText("SHRI GOPAL");
            li.Selected = true;
            btnSave.Enabled = true;
            return;
        }
        if (chkBilled.Checked == true && rdoItemType.SelectedItem.Value == "HS" && ddlServiceItems.SelectedItem.Value == "0")
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Please Select Service Item";
            ddlServiceItems.Focus();
            btnSave.Enabled = true;
            return;
        }
        if (ddl_MajorUnit.SelectedIndex == 0)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Select Purchase Unit";
            ddl_MajorUnit.Focus();
            btnSave.Enabled = true;
            return;
        }
        if (ddl_minor.SelectedIndex == 0)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Select Sale Unit";
            ddl_minor.Focus();
            btnSave.Enabled = true;
            return;
        }
        if (txtCFactor.Text.Trim() == string.Empty || txtCFactor.Text.Trim() == "0")
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Enter Conversion Factor";
            txtCFactor.Focus();
            btnSave.Enabled = true;
            return;
        }
        if (btnSave.Text == "ADD NEW")
        {
            ClearFields();
            btnSave.Text = "SAVE";
            btnSave.Enabled = true;
            return;
        }
        //GST Check

        if (Resources.Resource.IsGSTApplicable == "1")
        {
            if (rbtnGst.SelectedValue == "IGST")
            {
                if (txtIGst.Text == string.Empty || Util.GetDecimal(txtIGst.Text) < 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Enter IGST Tax %";
                    txtIGst.Focus();
                    return;
                }

            }
            else if (rbtnGst.SelectedValue == "CGST&UTGST")
            {
                if (txtCGst.Text == string.Empty || Util.GetDecimal(txtCGst.Text) < 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Enter CGST Tax %";
                    txtCGst.Focus();
                    return;
                }
                if (txtUTGST.Text == string.Empty || Util.GetDecimal(txtUTGST.Text) < 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Enter UTGST Tax %";
                    txtSGst.Focus();
                    return;
                }
            }
            else
            {
                if (txtCGst.Text == string.Empty || Util.GetDecimal(txtCGst.Text) < 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Enter CGST Tax %";
                    txtCGst.Focus();
                    return;
                }
                if (txtSGst.Text == string.Empty || Util.GetDecimal(txtSGst.Text) < 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Enter SGST Tax %";
                    txtSGst.Focus();
                    return;
                }
            }
        }
        //close
        if (ddlDrugCategory.SelectedItem.Value != "0")
        {
            ScheduleType = ddlDrugCategory.SelectedItem.Text;
        }
        if (ddlMedicineType.SelectedItem.Value != "0")
        {
            MedicineType = ddlMedicineType.SelectedItem.Text;
        }

        string ItemType = "";
        if (ddlItemType.SelectedItem.Value != "0")
        {
            ItemType = ddlItemType.SelectedItem.Text;
        }


        if (ddlRoute.SelectedIndex != 0)
        {
            Route = ddlRoute.SelectedItem.Text;
        }

        int IsOnSellingPrice = Util.GetInt(ddlIsOnSellingPrice.SelectedItem.Value);
        decimal SellingMargin = 0;

        if (!String.IsNullOrEmpty(txtSellingMarginPer.Text))
            SellingMargin = Util.GetDecimal(txtSellingMarginPer.Text);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            string IsEffectingInventory = "NO";
            string IsExpirable = "NO";
            string IsTrigger = "NO";
            string IsActive = "0";
            int TobeBilled = 1;
            int GSTApplicable = 0;
            decimal igstPercent = 0, cgstPercent = 0, sgstPercent = 0, utgstPercent = 0;
            string hsnCode = string.Empty, gstType = string.Empty;

            if (chkIsEffectingInventory.Checked) { IsEffectingInventory = "YES"; }
            if (chkIsExpirable.Checked) { IsExpirable = "YES"; }
            if (chkIsTrigger.Checked) { IsTrigger = "YES"; }
            if (chkIsActive.Checked) { IsActive = "1"; }

            if (txtStartTime.Text.Trim() == "") txtStartTime.Text = "00:00";
            if (txtEndTime.Text.Trim() == "") txtEndTime.Text = "00:00";
            if (txtBufferTime.Text.Trim() == "") txtBufferTime.Text = "00:00";

            bool Saved = false;

            string ItemName = "";
            if (ddlmanufacture.SelectedItem.Value == "0")
                ItemName = txtName.Text.Trim();
            else
                ItemName = txtName.Text.Trim();


            if (ItemName.Contains("'") || ItemName.Contains("`"))
            {
                ItemName = (ItemName.Replace("'", "")).Replace("`", "");
            }


            string ItemForDept = rdoItemType.SelectedItem.Value;

            string ServiceItemId = "0";
            if (chkIsService.Checked == true)
            {
                ServiceItemId = ddlServiceItems.SelectedValue;
            }
            else
            {
                ServiceItemId = "0";
            }

            if (rbtnGst.SelectedItem.Value == "IGST")
            {
                igstPercent = Util.GetDecimal(txtIGst.Text.Trim());
                cgstPercent = 0;
                sgstPercent = 0;
            }
            else if (rbtnGst.SelectedValue == "CGST&UTGST")
            {
                igstPercent = 0;
                cgstPercent = Util.GetDecimal(txtCGst.Text.Trim());
                sgstPercent = Util.GetDecimal(txtUTGST.Text.Trim());// this is UTGST
            }
            else
            {
                igstPercent = 0;
                cgstPercent = Util.GetDecimal(txtCGst.Text.Trim());
                sgstPercent = Util.GetDecimal(txtSGst.Text.Trim());
                
            
            }

            if (txtPurchase.Text.ToString() == "" || txtPurchase.Text.ToString() == "0")
            {
                gstType = Util.GetString(rbtnGst.SelectedItem.Value.Trim());
            }
            else
            {
                gstType = "";
            }



            hsnCode = Util.GetString(txtHSNcode.Text.Trim());
            //Consignment Work
            int isStent = 0;
            if (cbIsStent.Checked)
            {
                isStent = 1;
                TobeBilled = 1;
            }

            int chkAsset = 0;
            if (chkIsAsset.Checked == false)
            {
                chkAsset = 0;
            }
            else { chkAsset = 1; }

            int IsCSSD = 0, IsLaundry=0;
            if (ChkIsCSSD.Checked)
            {
                IsCSSD = 1;
            }
            if (ChkIsLaundry.Checked)
            {
                IsLaundry = 1;
            }
            
            //
            if (btnSave.Text == "Update")
            {
                if (Resources.Resource.IsGSTApplicable == "0")
                {
                    Saved = UpdateItemUpdateInventoryItems(ViewState["ItemID"].ToString(), IsEffectingInventory, txtDesc.Text.Trim(), IsExpirable, IsTrigger, txtStartTime.Text.Trim(), txtEndTime.Text.Trim(), txtBufferTime.Text.Trim(), IsActive, txtPulse.Text.Trim(), txtBilling.Text.Trim(), ddlGroup.SelectedValue, ItemName, txtRack.Text.Trim(), txtShelf.Text.Trim(), Util.GetDouble(txtMaxLevel.Text.Trim()), Util.GetDouble(txtMinLevel.Text.Trim()), Util.GetDouble(txtReorderLevel.Text.Trim()), Util.GetDouble(txtReorderQty.Text.Trim()), Util.GetDouble(txtMaxReorderQty.Text.Trim()), Util.GetDouble(txtMinReorderQty.Text.Trim()), txtPacking.Text.Trim(), ddlmanufacture.SelectedItem.Value, objTran, ItemForDept, ServiceItemId, TobeBilled, Util.GetString(rdoUsabletype.SelectedItem.Value), Util.GetString(txtRusable.Text), Util.GetString(ddl_MajorUnit.SelectedItem.Text), Util.GetString(Session["ID"].ToString()), Util.GetFloat(0), Util.GetString(txtItemCode.Text.Trim()), txtItemCatalog.Text.Trim(), Util.GetString(ddl_minor.SelectedItem.Text), Util.GetDecimal(txtCFactor.Text), ScheduleType, ViewState["DeptLedgerNo"].ToString(), txtCommodityCode.Text.Trim(), txtDose.Text.Trim(), MedicineType, Route, IsGenericExist, ddl_salt.SelectedItem.Value, txtstrength.Text.Trim(), hsnCode, igstPercent, sgstPercent, cgstPercent, gstType, isStent, ddlmanufacture.SelectedItem.Text.Trim(), IsOnSellingPrice, SellingMargin, chkAsset, Util.GetInt(ddlDrugCategory.SelectedItem.Value), Util.GetInt(ddlIsStockAble.SelectedItem.Value), ddlVATType.SelectedItem.Text, ddlVATLine.SelectedItem.Text, ddlSaleVatType.SelectedItem.Text, ddlSaleVatLine.SelectedItem.Text, txtSale.Text.Trim(), txtPurchase.Text.Trim(), ItemType, IsCSSD, IsLaundry, Util.GetDecimal(txtItemDose.Text), con);
                }
                else
                {
                    Saved = UpdateItemUpdateInventoryItemsGST(ItemID, IsEffectingInventory, txtDesc.Text.Trim(), IsExpirable, IsTrigger, txtStartTime.Text.Trim(), txtEndTime.Text.Trim(), txtBufferTime.Text.Trim(), IsActive, txtPulse.Text.Trim(), txtBilling.Text.Trim(), ddlGroup.SelectedValue, ItemName, txtRack.Text.Trim(), txtShelf.Text.Trim(), Util.GetDouble(txtMaxLevel.Text.Trim()), Util.GetDouble(txtMinLevel.Text.Trim()), Util.GetDouble(txtReorderLevel.Text.Trim()), Util.GetDouble(txtReorderQty.Text.Trim()), Util.GetDouble(txtMaxReorderQty.Text.Trim()), Util.GetDouble(txtMinReorderQty.Text.Trim()), txtPacking.Text.Trim(), ddlmanufacture.SelectedItem.Value, objTran, ItemForDept, ServiceItemId, TobeBilled, Util.GetString(rdoUsabletype.SelectedItem.Value), Util.GetString(txtRusable.Text), Util.GetString(ddl_MajorUnit.SelectedItem.Text), Util.GetString(Session["ID"].ToString()), Util.GetFloat(0), Util.GetString(txtItemCode.Text.Trim()), txtItemCatalog.Text.Trim(), Util.GetString(ddl_minor.SelectedItem.Text), Util.GetDecimal(txtCFactor.Text), ScheduleType, ViewState["DeptLedgerNo"].ToString(), txtCommodityCode.Text.Trim(), txtDose.Text.Trim(), MedicineType, Route, IsGenericExist, ddl_salt.SelectedItem.Value, txtstrength.Text.Trim(), hsnCode, igstPercent, sgstPercent, cgstPercent, gstType, isStent, ddlmanufacture.SelectedItem.Text.Trim(), IsOnSellingPrice, SellingMargin, chkAsset, IsCSSD, IsLaundry, Util.GetDecimal(txtItemDose.Text), con);
                }
                if (Saved)
                {
                    objTran.Commit();
                    con.Close();
                    con.Dispose();
                    btnSave.Enabled = true;
                    clearControls();
                    ClearFields();
                    lblMessage.Visible = true;
                    lblMessage.Text = "Record Updated Successfully";
                    btnSave.Text = "Save";
                    if (BtnID == "lnkView")
                    {
                        lnkView_Click((LinkButton)lnkView as object, new EventArgs());
                    }
                    if (BtnID == "lnkwrd")
                    {
                        lnkwrd_Click((LinkButton)lnkwrd as object, new EventArgs());
                    }
                }
            }
            else
            {
                int ItemCount = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_itemmaster WHERE TypeName='" + ItemName.Trim() + "' and IsActive=1"));
                if (ItemCount > 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Item Name Already Exist";
                    txtName.Focus();
                    btnSave.Enabled = true;
                    return;
                }
                Saved = SaveItemDetailsModified(ddlGroup.SelectedValue, ItemForDept, ItemName, IsEffectingInventory, txtDesc.Text.Trim(), IsExpirable, txtBilling.Text.Trim(), txtPulse.Text.Trim(), IsTrigger, txtStartTime.Text.Trim(), txtEndTime.Text.Trim(), txtBufferTime.Text.Trim(), IsActive, "0.0", "0", txtRack.Text.Trim(), txtShelf.Text.Trim(), Util.GetDouble(txtMaxLevel.Text.Trim()), Util.GetDouble(txtMinLevel.Text.Trim()), Util.GetDouble(txtReorderLevel.Text.Trim()), Util.GetDouble(txtReorderQty.Text.Trim()), Util.GetDouble(txtMaxReorderQty.Text.Trim()), Util.GetDouble(txtMinReorderQty.Text.Trim()), txtPacking.Text.Trim(), ddlmanufacture.SelectedItem.Value, objTran, ServiceItemId, Util.GetString(txtRusable.Text), Util.GetString(rdoUsabletype.SelectedItem.Value), TobeBilled, Util.GetString(ddl_MajorUnit.SelectedItem.Text), Util.GetString(Session["ID"].ToString()), Util.GetFloat(0), Util.GetString(txtItemCode.Text.Trim()), txtItemCatalog.Text.Trim(), GSTApplicable, Util.GetString(ddl_minor.SelectedItem.Text), Util.GetDecimal(txtCFactor.Text), ScheduleType, ViewState["DeptLedgerNo"].ToString(), txtCommodityCode.Text.Trim(), txtDose.Text.Trim(), MedicineType, IsGenericExist, ddl_salt.SelectedItem.Value, txtstrength.Text.Trim(), hsnCode, igstPercent, sgstPercent, cgstPercent, gstType, isStent, ddlmanufacture.SelectedItem.Text.Trim(), IsOnSellingPrice, SellingMargin, chkAsset, Util.GetInt(ddlDrugCategory.SelectedItem.Value), Util.GetInt(ddlIsStockAble.SelectedItem.Value), ddlVATType.SelectedItem.Text, ddlVATLine.SelectedItem.Text, ddlSaleVatType.SelectedItem.Text, ddlSaleVatLine.SelectedItem.Text, txtSale.Text.Trim(), txtPurchase.Text.Trim(), ItemType, IsCSSD, IsLaundry,Util.GetDecimal(txtItemDose.Text),con);
                if (Saved)
                {
                    objTran.Commit();
                    con.Close();
                    con.Dispose();
                    ClearFields();
                    lblMessage.Visible = true;
                    clearControls();
                    lblMessage.Text = "Record Saved Successfully";
                    btnSave.Enabled = true;
                }
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
            objTran.Rollback();
            con.Close();
            con.Dispose();
            ClearFields();
            btnSave.Enabled = true;
        }

    }

    protected void btnsaveDummy_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (grdItemDummy.Rows.Count > 0)
            {
                foreach (GridViewRow gr in grdItemDummy.Rows)
                {
                    string strsearch = "";

                    if (((CheckBox)gr.FindControl("chkSelect")).Checked == true)
                    {
                        if (chkvendormaster.Checked == true)
                        {
                            strsearch = " SELECT DISTINCT dven.Vendor_ID FROM d_f_purchaserequestquotation dquto INNER JOIN d_f_vendormaster dven ON dquto.VendorID=dven.Vendor_ID where dquto.Itemid='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' AND Quote_idMain='' ";
                            DataTable dtVendorId = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, strsearch).Tables[0];
                            foreach (DataRow dr in dtVendorId.Rows)
                            {
                                string id = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(id)+1)Id FROM  f_vendormaster"));
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" INSERT INTO f_vendormaster (Id,Vendor_ID,VendorName,StoreID,ContactPerson,Address1,Address2,Address3,Country,City,AREA,Pin,Telephone,Fax,Mobile,DrugLicence, ");
                                sb.Append(" VATNo,TinNo,Email,LastUpdatedBy,Updatedate,IpAddress)  ");
                                sb.Append(" SELECT " + id + ",'LSHHI" + id + "',VendorName,StoreID,ContactPerson,Address1,Address2,Address3,Country,City,AREA,Pin,Telephone,Fax,Mobile,DrugLicence, ");
                                sb.Append(" VATNo,TinNo,Email,LastUpdatedBy,Updatedate,IpAddress FROM d_f_vendormaster WHERE vendor_id='" + dr["Vendor_ID"].ToString() + "' ");
                                string result = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString()));

                                sb = new StringBuilder();
                                sb.Append(" update d_f_vendormaster set Vendor_IDMain='LSHHI" + id + "',TypeDummy='NONDUMMY' where  vendor_id='" + dr["Vendor_ID"].ToString() + "' ");
                                string updateven = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString()));
                                lblMsgDummy.Text = "Record Saved Successfully";
                            }
                        }
                        if (chkitemmaster.Checked == true)
                        {
                            string categoryId = "", SubCategoryId = "";

                            string strsearchcat = " SELECT categoryId FROM f_categorymaster where Name='" + ((Label)gr.FindControl("lblCategory")).Text.ToString() + "' ";
                            DataTable dtcategoryId = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, strsearchcat).Tables[0];
                            if (dtcategoryId.Rows.Count <= 0)
                            {
                                string idCat = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(id)+1)Id FROM  f_categorymaster"));
                                StringBuilder sbcat = new StringBuilder();
                                sbcat.Append(" INSERT INTO f_categorymaster (Location,Hospcode,ID,CategoryID,Hospital_ID,NAME,Description,TableReference,IsEffectiveEventory,Active,Abbreviation, ");
                                sbcat.Append(" EntDate,UserID,LastUpdatedBy,Updatedate,IpAddress) ");
                                sbcat.Append(" SELECT 'L','SHHI','" + idCat + "','LSHHI" + idCat + "',Hospital_ID,NAME,Description,TableReference,IsEffectiveEventory,Active,Abbreviation,");
                                sbcat.Append(" EntDate,UserID,LastUpdatedBy,Updatedate,IpAddress FROM d_f_categorymaster WHERE categoryid='" + ((Label)gr.FindControl("lblCategoryID")).Text.ToString() + "' ");

                                int resultcat = Util.GetInt(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbcat.ToString()));

                                sbcat = new StringBuilder();
                                sbcat.Append(" update d_f_categorymaster set CategoryIDMain='LSHHI" + idCat + "',TypeDummy='NONDUMMY' where  categoryid='" + ((Label)gr.FindControl("lblCategoryID")).Text.ToString() + "' ");
                                string updatecat = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbcat.ToString()));

                                categoryId = "LSHHI" + idCat;

                                string idcon = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(ID)+1)Id FROM  f_configrelation"));
                                StringBuilder sbcon = new StringBuilder();
                                sbcon.Append("insert into f_configrelation (ID,ConfigID,NAME,CategoryID,IsActive) select '" + idcon + "',ConfigID,NAME,'LSHHI" + idCat + "',IsActive from d_f_configrelation where  id ='" + ((Label)gr.FindControl("lblID")).Text.ToString() + "' ");
                                int resultcon = Util.GetInt(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbcon.ToString()));
                                if (resultcon > 0)
                                {
                                    lblMsgDummy.Text = "Record Saved Successfully";
                                }
                                else
                                {
                                    tnx.Rollback();
                                    tnx.Dispose();

                                    con.Close();
                                    con.Dispose();
                                    return;
                                }
                            }
                            else
                            {
                                categoryId = dtcategoryId.Rows[0]["categoryId"].ToString();
                            }
                            string strsearchSubcat = " SELECT subcategoryId FROM f_subcategorymaster where Name='" + ((Label)gr.FindControl("lblSubCategory")).Text.ToString() + "' ";
                            DataTable dtSubcategoryId = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, strsearchSubcat).Tables[0];
                            if (dtSubcategoryId.Rows.Count <= 0)
                            {
                                string idsub = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(id)+1)Id FROM  f_subcategorymaster"));
                                StringBuilder sbsub = new StringBuilder();
                                sbsub.Append("  INSERT INTO f_subcategorymaster (Location,Hospcode,ID,SubCategoryID,CategoryID,Hospital_ID,NAME,Description,DisplayName,DisplayPriority, ");
                                sbsub.Append("  Active,abbreviation,IsDiscountable) SELECT 'L','SHHI','" + idsub + "','LSHHI" + idsub + "','" + categoryId + "',Hospital_ID,NAME,Description,DisplayName,DisplayPriority, ");
                                sbsub.Append("  Active,abbreviation,IsDiscountable FROM d_f_subcategorymaster WHERE SubCategoryID='" + ((Label)gr.FindControl("lblSubCatID")).Text.ToString() + "' ");

                                int resultSub = Util.GetInt(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbsub.ToString()));
                                sbsub = new StringBuilder();
                                sbsub.Append(" update d_f_subcategorymaster set SubCategoryIDMain='LSHHI" + idsub + "',TypeDummy='NONDUMMY' where  SubCategoryID='" + ((Label)gr.FindControl("lblSubCatID")).Text.ToString() + "' ");
                                string updateSub = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbsub.ToString()));
                                SubCategoryId = "LSHHI" + idsub;
                                if (resultSub > 0)
                                {
                                    lblMsgDummy.Text = "Record Saved Successfully";
                                }
                                else
                                {
                                    tnx.Rollback();
                                    tnx.Dispose();
                                    con.Close();
                                    con.Dispose();
                                    return;
                                }
                            }
                            else
                            {
                                SubCategoryId = dtSubcategoryId.Rows[0]["subcategoryId"].ToString();
                            }

                            string iditem = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(id)+1)Id FROM  f_itemmaster "));
                            StringBuilder sbitem = new StringBuilder();
                            sbitem.Append("   INSERT INTO f_itemmaster (Location,Hospcode,ID,ItemID,Hospital_ID,SubCategoryID,Type_ID,TypeName,IsEffectingInventory,Description,IsExpirable,BillingUnit, ");
                            sbitem.Append("   Pulse,IsTrigger,StartTime,EndTime,BufferTime,IsActive,QtyInHand,IsAuthorised,ValidityPeriod,ManuFacturer,MinLimit,IsSurgery,Old_itemcode,ShowFlag, ");
                            sbitem.Append("   PurchaseQty,UnitType,SaleQty,SaleUnitType,ItemType,Rack,Shelf,MaxLevel,MinLevel,ReorderLevel,ReorderQty,MaxReorderQty,MinReorderQty,Packing,ManufactureID, ");
                            sbitem.Append("   RefShare,InHouseShare,ServiceItemID,IsUsable,ToBeBilled,SaleTaxPer,MajorUnit,Re_Usable_Service_Name,CreaterID,CreaterDateTime, ");
                            sbitem.Append("   LastUpdatedBy,Updatedate,IpAddress) SELECT 'L','SHHI','" + iditem + "','LSHHI" + iditem + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + SubCategoryId + "',Type_ID,TypeName,IsEffectingInventory,Description,IsExpirable,BillingUnit, ");
                            sbitem.Append("   Pulse,IsTrigger,StartTime,EndTime,BufferTime,IsActive,QtyInHand,IsAuthorised,ValidityPeriod,ManuFacturer,MinLimit,IsSurgery,Old_itemcode,ShowFlag, ");
                            sbitem.Append("   PurchaseQty,UnitType,SaleQty,SaleUnitType,ItemType,Rack,Shelf,MaxLevel,MinLevel,ReorderLevel,ReorderQty,MaxReorderQty,MinReorderQty,Packing,ManufactureID, ");
                            sbitem.Append("   RefShare,InHouseShare,ServiceItemID,IsUsable,ToBeBilled,SaleTaxPer,MajorUnit,Re_Usable_Service_Name,CreaterID,CreaterDateTime, ");
                            sbitem.Append("   LastUpdatedBy,Updatedate,IpAddress from  d_f_itemmaster WHERE itemid='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' ");
                            int resultitem = Util.GetInt(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbitem.ToString()));

                            sbitem = new StringBuilder();
                            sbitem.Append(" update d_f_itemmaster set ItemIDMain='LSHHI" + iditem + "',TypeDummy='NONDUMMY' where  itemid='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' ");
                            string updateItem = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbitem.ToString()));
                            if (resultitem > 0)
                            {
                                lblMsgDummy.Text = "Record Saved Successfully";
                            }
                            else
                            {
                                tnx.Rollback();
                                tnx.Dispose();
                                con.Close();
                                con.Dispose();
                                return;
                            }
                        }
                        if (chSalt.Checked == true)
                        {
                            strsearch = " SELECT  fis.ID ItemsaltID,fis.ItemID,sm.SaltID FROM d_f_item_salt fis INNER JOIN d_f_salt_master sm ON fis.saltID=sm.SaltID WHERE fis.ItemID='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' ";
                            DataTable dtsalt = StockReports.GetDataTable(strsearch);
                            if (dtsalt.Rows.Count > 0)
                            {
                                foreach (DataRow dr in dtsalt.Rows)
                                {
                                    string SaltID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(SaltID)+1)Id FROM  f_salt_master"));
                                    StringBuilder sbsalt = new StringBuilder();
                                    sbsalt.Append(" INSERT INTO f_salt_master (NAME,SaltID,IsActive,EntDate,UserID,Unit) SELECT NAME,'" + SaltID + "',IsActive,EntDate,UserID,Unit FROM d_f_salt_master WHERE SaltID='" + dr["SaltID"].ToString() + "' ");
                                    string resultsalt = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbsalt.ToString()));

                                    sbsalt = new StringBuilder();
                                    sbsalt.Append(" update d_f_salt_master set SaltIDMain='" + SaltID + "',TypeDummy='NONDUMMY'   WHERE SaltID='" + dr["SaltID"].ToString() + "' ");
                                    string updateSalt = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbsalt.ToString()));

                                    string ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(ID)+1)Id FROM  f_item_salt"));
                                    StringBuilder sbItemSalt = new StringBuilder();
                                    sbItemSalt.Append(" INSERT INTO f_item_salt (ID,ItemID,saltID,Quantity,Unit,UserID,EntDate) SELECT '" + ID + "',ItemID,'" + SaltID + "',Quantity,Unit,UserID,EntDate  from d_f_item_salt WHERE ItemID='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' and SaltID='" + dr["SaltID"].ToString() + "' ");

                                    string resultsaltitem = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbItemSalt.ToString()));

                                    sbItemSalt = new StringBuilder();
                                    sbItemSalt.Append(" update d_f_item_salt set IDMain='" + ID + "',TypeDummy='NONDUMMY'   WHERE ItemID='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' and SaltID='" + dr["SaltID"].ToString() + "' ");
                                    string updateItemSalt = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbItemSalt.ToString()));
                                }
                            }
                            else
                            {
                                string strsearchnew = " SELECT  fis.ID ItemsaltID,fis.ItemID,sm.SaltID FROM d_f_item_salt fis INNER JOIN f_salt_master sm ON fis.saltID=sm.SaltID WHERE fis.ItemID='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' ";
                                DataTable dtsaltnew = StockReports.GetDataTable(strsearchnew);
                                if (dtsaltnew.Rows.Count > 0)
                                {
                                    foreach (DataRow dr in dtsaltnew.Rows)
                                    {
                                        string ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(ID)+1)Id FROM  f_item_salt"));
                                        StringBuilder sbItemSalt = new StringBuilder();
                                        sbItemSalt.Append(" INSERT INTO f_item_salt (ID,ItemID,saltID,Quantity,Unit,UserID,EntDate) SELECT '" + ID + "',ItemID,'" + dr["SaltID"].ToString() + "',Quantity,Unit,UserID,EntDate  from d_f_item_salt WHERE ItemID='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' and SaltID='" + dr["SaltID"].ToString() + "' ");

                                        string resultsaltitem = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbItemSalt.ToString()));

                                        sbItemSalt = new StringBuilder();
                                        sbItemSalt.Append(" update d_f_item_salt set IDMain='" + ID + "',TypeDummy='NONDUMMY'   WHERE ItemID='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' and SaltID='" + dr["SaltID"].ToString() + "' ");
                                        string updateItemSalt = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbItemSalt.ToString()));
                                    }
                                }
                            }
                        }
                        if (chkManu.Checked == true)
                        {
                            strsearch = "SELECT ManufactureID FROM d_f_itemmaster where Itemid='" + ((Label)gr.FindControl("lblItemId")).Text.ToString() + "' ";
                            string ManufactureID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, strsearch));
                            if (ManufactureID == "")
                            {
                                string id = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MAX(MAnufactureID)+1)Id FROM  f_manufacture_master"));
                                StringBuilder sb = new StringBuilder();
                                sb.Append("  INSERT INTO f_manufacture_master (MAnufactureID,NAME,Contact_Person,ADDRESS,Address2,Address3,PHONE,Mobile,FAX,EMAIL,Country,City,PinCode, ");
                                sb.Append("   DLNO,TINNO,IsActive,UserID,EntryDate) SELECT '" + id + "',NAME,Contact_Person,ADDRESS,Address2,Address3,PHONE,Mobile,FAX,EMAIL,Country,City,PinCode, ");
                                sb.Append("     DLNO,TINNO,IsActive,UserID,EntryDate FROM d_f_manufacture_master where MAnufactureID='" + ManufactureID + "' ");
                                string result = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString()));
                                lblMsgDummy.Text = "Record Saved Successfully";

                                sb = new StringBuilder();
                                sb.Append(" update d_f_manufacture_master set MAnufactureIDMain='" + id + "',TypeDummy='NONDUMMY'   WHERE MAnufactureID='" + ManufactureID + "' ");
                                string updateManu = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString()));
                            }
                        }
                    }
                }
            }
            else
            {
                lblMsgDummy.Text = "No Items Are Their To get From Dummy";
                mpedummy.Show();
            }
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            lblMessage.Text = "Record Saved Successfully";
            lblMessage.Visible = true;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            con.Close();
            con.Dispose();
            lblMessage.Text = "Error.....";
            lblMessage.Visible = true;
        }
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        string str = " SELECT im.ItemDose,cm.Name Category,cm.Categoryid,sc.Name Subcategory,sc.subcategoryid,im.TypeName ItemName,im.ItemId,con.ConfigID,con.ID,con.name ConfigName FROM d_f_categorymaster cm inner join d_f_configrelation con on cm.categoryid=con.categoryid INNER JOIN d_f_subcategorymaster sc ON cm.CategoryID=sc.CategoryID " +
                     " INNER JOIN d_f_itemmaster im ON sc.SubCategoryID=im.SubCategoryID WHERE im.ItemIDMain=''  AND im.TypeName LIKE '" + txtSearchItem.Text.ToString() + "%' " +
                     "  UNION ALL  SELECT cm.Name Category,cm.Categoryid,sc.Name Subcategory,sc.subcategoryid,im.TypeName ItemName,im.ItemId,con.ConfigID,con.ID,con.name ConfigName  " +
                     " FROM f_categorymaster cm INNER JOIN f_configrelation con ON cm.categoryid=con.categoryid INNER JOIN f_subcategorymaster sc ON cm.CategoryID=sc.CategoryID  INNER JOIN  " +
                     "   d_f_itemmaster im ON sc.SubCategoryID=im.SubCategoryID WHERE im.ItemIDMain=''  AND im.TypeName LIKE '" + txtSearchItem.Text.ToString() + "%' ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdItemDummy.DataSource = StockReports.GetDataTable(str);
            grdItemDummy.DataBind();
        }
        else
        {
            grdItemDummy.DataSource = null;
            grdItemDummy.DataBind();
            lblMsgQuot.Text = "No record Found";
        }

        mpedummy.Show();
    }

    protected void lnkbtnUnit_Click(object sender, EventArgs e)
    {
        BindMinorUnit();
    }

    protected void lnkNewItems_Click(object sender, EventArgs e)
    {
        BindManufacture();
    }

    protected void lnkReport_Click(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedIndex == 0)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Select Category";
            ddlCategory.Focus();
            return;
        }
        if (txtSearch.Text != "")
        {
            if (txtSearch.Text.Length <= 2)
            {
                lblMessage.Visible = true;
                lblMessage.Text = "Please Enter Atleast 3 Characters";
                txtSearch.Focus();
                return;
            }
        }
        lblMessage.Visible = false;
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT im.ItemID,im.ItemCode 'Item Code',im.TypeName AS 'Item Name',(fsm.Name)'Subcategory Name',( SELECT NAME FROM f_manufacture_master MM WHERE MM.ManufactureID=im.ManufactureID )'Manufacturer',im.Description,im.Rack,im.Shelf,");
        sb.Append(" IF(IFNULL(fid.ConversionFactor,'')='',im.ConversionFactor,fid.ConversionFactor)ConversionFactor, ");
        sb.Append(" IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)MajorUnit,IF(IFNULL(fid.minorUnit,'')='',im.UnitType,fid.minorUnit)UnitType, ");
        sb.Append(" IF(IFNULL(fid.maxlevel,'')='',im.maxlevel,fid.maxlevel)'Max Level',IF(IFNULL(fid.minlevel,'')='',im.minlevel,fid.minlevel)'Min Level',");
        sb.Append(" IF(IFNULL(fid.reorderlevel,'')='',im.reorderlevel,fid.reorderlevel)'Reorder Level',IF(IFNULL(fid.reorderqty,'')='',im.reorderqty,fid.reorderqty)'Reorder Qty',");
        sb.Append(" IF(IFNULL(fid.maxreorderqty,'')='',im.maxreorderqty,fid.maxreorderqty)'Max Reorder Qty',IF(IFNULL(fid.minreorderqty,'')='',im.minreorderqty,fid.minreorderqty)'Min Reorder Qty',");


        sb.Append(" im.Packing,im.isExpirable 'Expirable',(em.Name)'Creater Name',DATE_FORMAT(im.CreaterDateTime,'%d-%b-%Y')'Created Date',if(im.IsActive='1','Active','InActive')Status ");
        sb.Append(" FROM f_itemmaster im INNER JOIN employee_master em ON em.EmployeeID=im.CreaterID INNER JOIN f_subcategorymaster fsm ON im.SubCategoryID=fsm.SubCategoryID  ");
        sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append(" WHERE im.itemid <>''  and fsm.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "'  ");

        if (txtSearch.Text.Trim() != string.Empty)
        {
            sb.Append(" and im.TypeName like '" + txtSearch.Text.Trim() + "%'");
        }

        if (ddlSubCategory.SelectedIndex != 0)
        {
            sb.Append(" and  im.SubCategoryID = '" + ddlSubCategory.SelectedValue + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string StrQuery = "Select im.TypeName,im.ItemCode,im.IsExpirable,im.SaleTaxPer,(fsm.Name)SubcategoryName,( SELECT NAME FROM f_manufacture_master MM WHERE MM.ManufactureID=im.ManufactureID )  ManuFacturer,em.Name,Date_Format(im.CreaterDateTime,'%d-%b-%y')CreaterDateTime,im.ItemID,im.Type_id,im.tobebilled,im.Description,im.SubCategoryID,im.MajorUnit,im.IsTrigger,TIME_FORMAT(im.StartTime,'%H:%I:%S')StartTime,TIME_FORMAT(im.EndTime,'%H:%I:%S')EndTime,TIME_FORMAT(im.BufferTime,'%H:%I:%S')BufferTime,im.IsActive,im.BillingUnit,im.UnitType,im.Pulse,im.rack,im.shelf,im.maxlevel,im.minlevel,im.reorderlevel,im.reorderqty,im.maxreorderqty,im.minreorderqty,im.packing,im.ManufactureID,im.PurchaseQty,im.UnitType,im.SaleQty,im.SaleUnitType,im.IsUsable,im.ServiceItemID,(SELECT typename FROM f_itemmaster WHERE itemid=im.ServiceItemID)Servicetypename from f_itemmaster im inner join employee_master em on em.EmployeeID=im.CreaterID inner join f_subcategorymaster fsm on im.SubCategoryID=fsm.SubCategoryID WHERE im.itemid <>''  and fsm.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "'  ";

        if (txtSearch.Text.Trim() != string.Empty)
        {
            StrQuery = StrQuery + " and im.TypeName like '" + txtSearch.Text.Trim() + "%'";
        }

        if (ddlSubCategory.SelectedIndex != 0)
        {
            StrQuery = StrQuery + " and  im.SubCategoryID = '" + ddlSubCategory.SelectedValue + "'";
        }
        ViewState["dt"] = StockReports.GetDataTable(StrQuery);

        if (dt.Rows.Count > 0)
        {
            // Session["dtExport2Excel"] = dt;
            // Session["ReportName"] = " Item Master Listing( " + ddlSubCategory.SelectedItem.Text + ")";

            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt);
            string ReportName = " Item Master Listing( " + ddlSubCategory.SelectedItem.Text + ")";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
            //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
        }
        else
        {
            lblMessage.Visible = true;
            lblMessage.Text = "No record Found";
        }
    }

    protected void lnkView_Click(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedIndex == 0)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Select Category";
            ddlCategory.Focus();
            return;
        }
        if (txtSearch.Text.Length <= 2)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Please enter atleast 3 characters ";
            txtSearch.Focus();
            return;
        }
        LinkButton lnk = sender as LinkButton;
        ViewState["lnk"] = lnk.Text;
        bindInventoryGrid();
        BtnID = lnkView.ID;
    }

    protected void lnkwrd_Click(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedIndex == 0)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Select Category";
            ddlCategory.Focus();
            return;
        }

        if (txtSearch.Text.Length <= 2)
        {
            lblMessage.Visible = true;
            lblMessage.Text = "Please Enter Atleast 3 Characters";
            txtSearch.Focus();
            return;
        }
        LinkButton lnkwrd = sender as LinkButton;
        ViewState["lnk"] = lnkwrd.Text;
        bindInventoryGrid();
        BtnID = lnkwrd.ID;
    }

    #endregion All On Click Function

    #region All On Chenge
    //This Is Using For Check Box

    protected void chkBilled_CheckedChanged(object sender, EventArgs e)
    {
        //if (chkBilled.Checked)
        //{
        //    chkIsService.Checked = true;
        //    chkIsService.Enabled = false;
        //    ddlServiceItems.Enabled = true;
        //}
        //else
        //{
        //    chkIsService.Checked = false;
        //    chkIsService.Enabled = false;
        //    ddlServiceItems.Enabled = false;
        //}
    }

    protected void chkDummyItem_CheckedChanged(object sender, EventArgs e)
    {
        mpedummy.Show();
    }

    protected void chkIsEffectingInventory_CheckedChanged(object sender, EventArgs e)
    {
        if (chkIsEffectingInventory.Checked)
        {
            chkIsActive.Checked = true;
        }
        else
        {
            chkIsTrigger.Checked = false;
            chkIsActive.Checked = false;
        }
    }

    protected void chkIsService_CheckedChanged(object sender, EventArgs e)
    {
        if (chkIsService.Checked == true)
        {
            ddlServiceItems.Enabled = true;
            chkBilled.Checked = true;
        }
        else
        {
            ddlServiceItems.Enabled = false;
            chkBilled.Checked = false;
        }
    }

    protected void chkGenric_CheckedChanged(object sender, EventArgs e)
    {
        if (chkGenric.Checked)
        {
            ddl_salt.Visible = true;
            spnStrength.Visible = true;
            txtstrength.Visible = true;
        }
        else
        {
            ddl_salt.Visible = false;
            spnStrength.Visible = false;
            txtstrength.Visible = false;
        }
    }

    protected void chkIsAsset_CheckedChanged(object sender, EventArgs e)
    {
        BindGroup();
        BindManufacture();
    }

    //This Is Using For Drop Down

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedIndex != 0)
        {
            rbtnGst.Items.FindByValue("CGST&SGST").Selected = true;
            ddlSubCategory.Items.Clear();
            ddlSubCategory.Items.AddRange(LoadItems(CreateStockMaster.LoadSubCategoryByCategory(ddlCategory.SelectedValue.Split('#')[0])));
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("ALL", "0"));
            if (ddlSubCategory.Items != null)
            {
                ddlSubCategory.SelectedIndex = 0;
                lnkView.Text = "Search Data by First Name of " + ddlSubCategory.SelectedItem.Text;
                lnkwrd.Text = "Search Data by Word of " + ddlSubCategory.SelectedItem.Text;
                lnkReport.Text = "View Reports of " + ddlSubCategory.SelectedItem.Text;
            }
            ddlSubCategory.Enabled = true;
            btnSave.Enabled = true;
            ddlGroup.Enabled = true;
            lnkReport.Visible = true;
            lnkView.Visible = true;
            lnkwrd.Visible = true;
            chkGenric.Checked = false;

            if (Util.GetInt(ddlCategory.SelectedValue.Split('#')[1]) == 28)
            {
                chkIsAsset.Visible = true;
                divisAsset.Visible = true;
            }

            chkIsExpirable.Checked = false;
            if (Util.GetInt(ddlCategory.SelectedValue.Split('#')[1]) == 11)
            {
                chkIsExpirable.Checked = true;
                chkGenric.Checked = false;
            }
            chkGenric_CheckedChanged(sender, e);

        }
        else { ddlSubCategory.Enabled = false; lnkReport.Visible = false; lnkView.Visible = false; btnSave.Enabled = false; ddlGroup.Enabled = false; lnkwrd.Visible = false; chkIsAsset.Visible = false; divisAsset.Visible = false; }
        BindGroup();
    }

    protected void ddlGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSubCategory.SelectedItem.Text != "ALL")
        {
            lnkView.Text = "Search Data of " + ddlSubCategory.SelectedItem.Text;
            lnkReport.Text = "Report of " + ddlSubCategory.SelectedItem.Text;
        }
        else
        {
            lnkView.Text = "Search Data by First Name of " + ddlSubCategory.SelectedItem.Text;
            lnkReport.Text = "View Reports of " + ddlSubCategory.SelectedItem.Text;
        }
    }

    protected void grdServiceItems_SelectedIndexChanged(object sender, EventArgs e)
    {
        SubCategoryMaster _modal = new SubCategoryMaster();
        ClearFields();

        string Active = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblActive")).Text).Replace("&nbsp;", "");
        if (Active == "3")
        {
            lblMessage.Text = "Kindly map the item with the finance account.";
            return;
        }
        string Catid = ((Label)grdServiceItems.SelectedRow.FindControl("lblSubCatID")).Text;
        int asset = _modal.GetIsAssetBySubCategoryId(Catid);
        if (asset == 1)
        {
            chkIsAsset.Checked = true;
        }
        else
        { chkIsAsset.Checked = false; }


        BindGroup();
        BindManufacture();

        int s = Util.GetInt(((Label)grdServiceItems.SelectedRow.FindControl("lblIsStockAble")).Text);
        txtName.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblItemName")).Text.Split('$')[0];
        //txtItemCatalog.Text = Util.GetString(grdServiceItems.SelectedRow.Cells[2].Text).Replace("&nbsp;", "");
        txtDesc.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblDesc")).Text; // Replace("&nbsp;", "");
        ViewState["ItemID"] = ((Label)grdServiceItems.SelectedRow.FindControl("lblItemID")).Text.Replace("&nbsp;", "");
        txtRack.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblRack")).Text).Replace("&nbsp;", "");
        txtShelf.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblShelf")).Text).Replace("&nbsp;", "");
        txtMaxLevel.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblMaxLevel")).Text).Replace("&nbsp;", "");
        txtMinLevel.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblMinLevel")).Text).Replace("&nbsp;", "");
        txtReorderLevel.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblReorderLevel")).Text).Replace("&nbsp;", "");
        txtReorderQty.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblReorderQty")).Text).Replace("&nbsp;", "");
        txtMaxReorderQty.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblMaxReorderQty")).Text).Replace("&nbsp;", "");
        txtMinReorderQty.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblMinReorderQty")).Text).Replace("&nbsp;", "");
        txtPacking.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblPacking")).Text).Replace("&nbsp;", "");
        txtItemCode.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblItemCode")).Text).Replace("&nbsp;", "");
        rdoUsabletype.SelectedIndex = rdoUsabletype.Items.IndexOf(rdoUsabletype.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblIsUsable")).Text));
        ddlmanufacture.SelectedIndex = ddlmanufacture.Items.IndexOf(ddlmanufacture.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblServiceItemID")).Text));
        ddlDrugCategory.SelectedIndex = ddlDrugCategory.Items.IndexOf(ddlDrugCategory.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblDrugCategoryID")).Text));
        ddlIsStockAble.SelectedIndex = ddlIsStockAble.Items.IndexOf(ddlIsStockAble.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblIsStockAble")).Text));

        ddlGroup.SelectedIndex = ddlGroup.Items.IndexOf(ddlGroup.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblsubcategoryID")).Text));
        ddlServiceItems.SelectedIndex = ddlServiceItems.Items.IndexOf(ddlServiceItems.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblServiceItemID")).Text));

        txt_Rusable.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblIsUsable")).Text;

        ddl_MajorUnit.SelectedIndex = ddl_MajorUnit.Items.IndexOf(ddl_MajorUnit.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblMajorUnit")).Text));
        ddl_minor.SelectedIndex = ddl_minor.Items.IndexOf(ddl_minor.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblMinorUnit")).Text));
        ddlScheduleType.SelectedIndex = ddlScheduleType.Items.IndexOf(ddlScheduleType.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblScheduleType")).Text));
        ddlRoute.SelectedIndex = ddlRoute.Items.IndexOf(ddlRoute.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblRoute")).Text));
        txtCFactor.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblCFactor")).Text;
        BindVatType();
        ddlVATType.SelectedIndex = ddlVATType.Items.IndexOf(ddlVATType.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblVatType")).Text));
        BindVatLine();
        ddlVATLine.SelectedIndex = ddlVATLine.Items.IndexOf(ddlVATLine.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblVatLine")).Text));

        ddlSaleVatType.SelectedIndex = ddlSaleVatType.Items.IndexOf(ddlSaleVatType.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblSaleVatType")).Text));

        ddlSaleVatLine.SelectedIndex = ddlSaleVatLine.Items.IndexOf(ddlSaleVatLine.Items.FindByText(((Label)grdServiceItems.SelectedRow.FindControl("lblSaleVatLine")).Text));
        txtSale.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lbSaleVat")).Text;
        txtPurchase.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblPurchase")).Text;
        txtItemDose.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblItemDose")).Text;


        ddlItemType.SelectedIndex = ddlItemType.Items.IndexOf(ddlItemType.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblItemType")).Text));

        if (int.Parse(((Label)grdServiceItems.SelectedRow.FindControl("lblistobill")).Text) == 0)
        {
            chkBilled.Checked = false;
        }
        else if (int.Parse(((Label)grdServiceItems.SelectedRow.FindControl("lblistobill")).Text) == 1)
        {
            chkBilled.Checked = true;
        }

        if ((((Label)grdServiceItems.SelectedRow.FindControl("lblTypeID")).Text) == "HS")
        {
            rdoItemType.SelectedIndex = 0;
        }
        if (Active == "1")
        {
            chkIsActive.Checked = true;
        }
        else
        {
            chkIsActive.Checked = false;
        }
        if ((((Label)grdServiceItems.SelectedRow.FindControl("lblcheckisexpirable")).Text) == "YES")
        {
            chkIsExpirable.Checked = true;
        }
        else
        {
            chkIsExpirable.Checked = false;
        }
        if (((Label)grdServiceItems.SelectedRow.FindControl("lblIsUsable")).Text == "R")
        {
            rdoUsabletype.SelectedIndex = 1;
            txtRusable.Visible = true;
            lbl_ServiceName.Visible = true;
        }
        else if (((Label)grdServiceItems.SelectedRow.FindControl("lblIsUsable")).Text == "NR")
        {
            rdoUsabletype.SelectedIndex = 0;
            txtRusable.Visible = false;
            lbl_ServiceName.Visible = false;
        }
        ddlmanufacture.SelectedIndex = ddlmanufacture.Items.IndexOf(ddlmanufacture.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblManufactureID")).Text));

        if (((Label)grdServiceItems.SelectedRow.FindControl("lblServiceItemID")).Text != "" && ((Label)grdServiceItems.SelectedRow.FindControl("lblServiceItemID")).Text != "0")
        {
            ddlServiceItems.Enabled = true;
            chkIsService.Checked = true;
        }
        else
        {
            ddlServiceItems.Enabled = false;
            chkIsService.Checked = false;
        }
        txtSellingMarginPer.Text = ((Label)grdServiceItems.SelectedRow.FindControl("lblSellingMargin")).Text;
        ddlIsOnSellingPrice.SelectedIndex = ddlIsOnSellingPrice.Items.IndexOf(ddlIsOnSellingPrice.Items.FindByValue(((Label)grdServiceItems.SelectedRow.FindControl("lblIsOnSellingPrice")).Text));
        string sql = "select * from f_item_salt where itemid='" + ViewState["ItemID"].ToString() + "' order by id desc limit 1";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            chkGenric.Checked = true;
            ddl_salt.SelectedIndex = ddl_salt.Items.IndexOf(ddl_salt.Items.FindByValue(dt.Rows[0]["SaltID"].ToString()));
            txtstrength.Text = dt.Rows[0]["Quantity"].ToString();
            ddl_salt.Visible = true;
            spnStrength.Visible = true;
            txtstrength.Visible = true;
        }

        txtCommodityCode.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblCommodityCode")).Text).Replace("&nbsp;", "");
        txtHSNcode.Text = Util.GetString(grdServiceItems.SelectedRow.Cells[2].Text).Replace("&nbsp;", "");
        txtIGst.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblIGstTax")).Text);
        // txtSGst.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblSGSTTax")).Text);
        // txtCGst.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblCGSTTax")).Text);
        // txtSGst.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblSGSTTax")).Text);
        //if (Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblGSTType")).Text) == "IGST")
        //{
        //    rbtnGst.SelectedIndex = 0;
        //}
        //else { rbtnGst.SelectedIndex = 1; }

        string TotalGST = Math.Round((Util.GetDecimal(txtIGst.Text) + Util.GetDecimal(txtCGst.Text) + Util.GetDecimal(txtSGst.Text) + Util.GetDecimal(txtUTGST.Text)), 2).ToString();
        string GSTType = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() + "(" + TotalGST + ")";
        //  rbtnGst.SelectedIndex = rbtnGst.Items.IndexOf(rbtnGst.Items.FindByValue(Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblGSTType")).Text).ToUpper()));
        // ddlGSTType.SelectedIndex = ddlGSTType.Items.IndexOf(ddlGSTType.Items.FindByText(GSTType));


        if (Util.GetInt(((Label)grdServiceItems.SelectedRow.FindControl("lblIsStent")).Text) == 1)
        {
            cbIsStent.Checked = true;
        }
        else
        {
            cbIsStent.Checked = false;
        }
        if (Util.GetInt(((Label)grdServiceItems.SelectedRow.FindControl("lblIsCSSD")).Text) == 1)
        {
            ChkIsCSSD.Checked = true;
        }
        else
        {
            ChkIsCSSD.Checked = false;
        }
        if (Util.GetInt(((Label)grdServiceItems.SelectedRow.FindControl("lblIsLaundry")).Text) == 1)
        {
            ChkIsLaundry.Checked = true;
        }
        else
        {
            ChkIsLaundry.Checked = false;
        }
        // txtCommodityCode.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblCommodityCode")).Text).Replace("&nbsp;", "");
        txtCommodityCode.Text = Util.GetString(((Label)grdServiceItems.SelectedRow.FindControl("lblCommodityCode")).Text).Replace("&nbsp;", "");

        // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "checkGstType();", true);

///        txtName.Enabled = false;

        btnSave.Text = "Update";
        chkIsActive.Visible = true;


    }

    protected void grdServiceItemsGST_SelectedIndexChanged(object sender, EventArgs e)
    {
        SubCategoryMaster _modal = new SubCategoryMaster();
        ClearFields();
        string Catid = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblSubCatID")).Text;
        int asset = _modal.GetIsAssetBySubCategoryId(Catid);
        if (asset == 1)
        {
            chkIsAsset.Checked = true;
        }
        else
        { chkIsAsset.Checked = false; }
        BindGroup();
        BindManufacture();
        txtName.Text = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblItemName")).Text.Split('$')[0];
        //txtItemCatalog.Text = Util.GetString(grdServiceItems.SelectedRow.Cells[2].Text).Replace("&nbsp;", "");
        txtDesc.Text = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblDesc")).Text; // Replace("&nbsp;", "");
        ItemID = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblItemID")).Text.Replace("&nbsp;", "");
        txtRack.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblRack")).Text).Replace("&nbsp;", "");
        txtShelf.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblShelf")).Text).Replace("&nbsp;", "");
        txtMaxLevel.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblMaxLevel")).Text).Replace("&nbsp;", "");
        txtMinLevel.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblMinLevel")).Text).Replace("&nbsp;", "");
        txtReorderLevel.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblReorderLevel")).Text).Replace("&nbsp;", "");
        txtReorderQty.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblReorderQty")).Text).Replace("&nbsp;", "");
        txtMaxReorderQty.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblMaxReorderQty")).Text).Replace("&nbsp;", "");
        txtMinReorderQty.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblMinReorderQty")).Text).Replace("&nbsp;", "");
        txtPacking.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblPacking")).Text).Replace("&nbsp;", "");
        txtItemCode.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblItemCode")).Text).Replace("&nbsp;", "");
        rdoUsabletype.SelectedIndex = rdoUsabletype.Items.IndexOf(rdoUsabletype.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsUsable")).Text));
        ddlmanufacture.SelectedIndex = ddlmanufacture.Items.IndexOf(ddlmanufacture.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblServiceItemID")).Text));
        ddlIsStockAble.SelectedIndex = ddlIsStockAble.Items.IndexOf(ddlIsStockAble.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsStockable")).Text));

        ddlGroup.SelectedIndex = ddlGroup.Items.IndexOf(ddlGroup.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblsubcategoryID")).Text));
        ddlServiceItems.SelectedIndex = ddlServiceItems.Items.IndexOf(ddlServiceItems.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblServiceItemID")).Text));
        string Active = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblActive")).Text).Replace("&nbsp;", "");
        txt_Rusable.Text = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsUsable")).Text;

        ddl_MajorUnit.SelectedIndex = ddl_MajorUnit.Items.IndexOf(ddl_MajorUnit.Items.FindByText(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblMajorUnit")).Text));
        ddl_minor.SelectedIndex = ddl_minor.Items.IndexOf(ddl_minor.Items.FindByText(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblMinorUnit")).Text));
        ddlScheduleType.SelectedIndex = ddlScheduleType.Items.IndexOf(ddlScheduleType.Items.FindByText(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblScheduleType")).Text));
        ddlRoute.SelectedIndex = ddlRoute.Items.IndexOf(ddlRoute.Items.FindByText(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblRoute")).Text));
        txtCFactor.Text = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblCFactor")).Text;
        txtItemDose.Text = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblItemDose")).Text;


        if (int.Parse(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblistobill")).Text) == 0)
        {
            chkBilled.Checked = false;
        }
        else if (int.Parse(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblistobill")).Text) == 1)
        {
            chkBilled.Checked = true;
        }

        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblTypeID")).Text) == "HS")
        {
            rdoItemType.SelectedIndex = 0;
        }
        if (Active == "1")
        {
            // chkIsActive.Checked = true;
        }
        else
        {
            // chkIsActive.Checked = false;
        }
        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblcheckisexpirable")).Text) == "YES")
        {
            chkIsExpirable.Checked = true;
        }
        else
        {
            chkIsExpirable.Checked = false;
        }
        if (((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsUsable")).Text == "R")
        {
            rdoUsabletype.SelectedIndex = 1;
            txtRusable.Visible = true;
            lbl_ServiceName.Visible = true;
        }
        else if (((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsUsable")).Text == "NR")
        {
            rdoUsabletype.SelectedIndex = 0;
            txtRusable.Visible = false;
            lbl_ServiceName.Visible = false;
        }
        ddlmanufacture.SelectedIndex = ddlmanufacture.Items.IndexOf(ddlmanufacture.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblManufactureID")).Text));

        //if (((Label)grdServiceItemsGST.SelectedRow.FindControl("lblServiceItemID")).Text != "" && ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblServiceItemID")).Text != "0")
        //{
        //    ddlServiceItems.Enabled = true;
        //    chkIsService.Checked = true;
        //}
        //else
        //{
        //    ddlServiceItems.Enabled = false;
        //    chkIsService.Checked = false;
        //}
        txtSellingMarginPer.Text = ((Label)grdServiceItemsGST.SelectedRow.FindControl("lblSellingMargin")).Text;
        ddlIsOnSellingPrice.SelectedIndex = ddlIsOnSellingPrice.Items.IndexOf(ddlIsOnSellingPrice.Items.FindByValue(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsOnSellingPrice")).Text));
        string sql = "select ID,ItemID,saltID,ROUND(Quantity,2)Quantity,Unit,userID,EntDate from f_item_salt where itemid='" + ItemID + "' order by id desc limit 1";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            chkGenric.Checked = true;
            ddl_salt.SelectedIndex = ddl_salt.Items.IndexOf(ddl_salt.Items.FindByValue(dt.Rows[0]["SaltID"].ToString()));
            txtstrength.Text = dt.Rows[0]["Quantity"].ToString();
            ddl_salt.Visible = true;
            spnStrength.Visible = true;
            txtstrength.Visible = true;
        }

        txtCommodityCode.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblCommodityCode")).Text).Replace("&nbsp;", "");
        txtHSNcode.Text = Util.GetString(grdServiceItemsGST.SelectedRow.Cells[2].Text).Replace("&nbsp;", "");



        txtIGst.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIGstTax")).Text);
        txtCGst.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblCGSTTax")).Text);

        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() == "CGST&SGST")
            txtSGst.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblSGSTTax")).Text);
        else
            txtSGst.Text = "0.00";

        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() == "CGST&UTGST")
            txtUTGST.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblSGSTTax")).Text);
        else
            txtUTGST.Text = "0.00";

        //if (Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text) == "CGST&UTGST")
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "HideDisplay('" + 0 + "');", true);
        //    txtUTGST.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblSGSTTax")).Text);
        //    //txtSGst.Text = "0.00";
        //}
        //else if (Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text) == "CGST&SGST")
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "HideDisplay('" + 1 + "');", true);
        //    txtSGst.Text = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblSGSTTax")).Text);
        //   // txtUTGST.Text = "0.00";
        //}
        //if (Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text) == "IGST")
        //{
        //    rbtnGst.SelectedIndex = 0;
        //}
        //else if (Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text) == "CGST&UTGST")
        //{
        //    rbtnGst.SelectedIndex = 2;
        //}
        //else { rbtnGst.SelectedIndex = 1; }


        string TotalGST = Math.Round((Util.GetDecimal(txtIGst.Text) + Util.GetDecimal(txtCGst.Text) + Util.GetDecimal(txtSGst.Text) + Util.GetDecimal(txtUTGST.Text)), 2).ToString();
        string GSTType = Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() + "(" + TotalGST + ")";
        rbtnGst.SelectedIndex = rbtnGst.Items.IndexOf(rbtnGst.Items.FindByValue(Util.GetString(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper()));
        ddlGSTType.SelectedIndex = ddlGSTType.Items.IndexOf(ddlGSTType.Items.FindByText(GSTType));

        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() == "IGST")
        {
            trIGstTax.Visible = true;
            trPartialCgstTax.Visible = trPartialSgstTax.Visible = trPartialUTGSUTax.Visible = false;
        }
        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() == "CGST&SGST")
        {
            trIGstTax.Visible = trPartialUTGSUTax.Visible = false;
            trPartialCgstTax.Visible = trPartialSgstTax.Visible = true;
           // txtUTGST.Text = "0.00";
        }
        if ((((Label)grdServiceItemsGST.SelectedRow.FindControl("lblGSTType")).Text).ToUpper() == "CGST&UTGST")
        {
            trIGstTax.Visible = trPartialSgstTax.Visible = false;
            trPartialCgstTax.Visible = trPartialUTGSUTax.Visible = true;
          //  txtSGst.Text = "0.00";
        }


        if (Util.GetInt(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsStent")).Text) == 1)
        {
            cbIsStent.Checked = true;
        }
        else
        {
            cbIsStent.Checked = false;
        }
        if (Util.GetInt(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsCSSD")).Text) == 1)
        {
            ChkIsCSSD.Checked = true;
        }
        else
        {
            ChkIsCSSD.Checked = false;
        }
        if (Util.GetInt(((Label)grdServiceItemsGST.SelectedRow.FindControl("lblIsLaundry")).Text) == 1)
        {
            ChkIsLaundry.Checked = true;
        }
        else
        {
            ChkIsLaundry.Checked = false;
        }
        //if (Util.GetInt(((Label)grdServiceItems.SelectedRow.FindControl("lblIsCSSDItem")).Text) == 1)
        //{
        //    //cbIsCSSD.Checked = true;
        //}
        //else
        //{
        //   // cbIsCSSD.Checked = false;
        //}
        //if (Util.GetInt(((Label)grdServiceItems.SelectedRow.FindControl("lblIsLaundryItem")).Text) == 1)
        //{
        //    //chkIsLaundry.Checked = true;
        //}
        //else
        //{
        //   // chkIsLaundry.Checked = false;
        //}


        //   ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "checkGstType();", true);
       // txtName.Enabled = false;
        btnSave.Text = "Update";
        // chkIsActive.Visible = true;
    }

    //This Is Using For Redio Button

    protected void rdoItemType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoItemType.SelectedIndex == 0)
        {
            chkBilled.Checked = true;
            //  chkIsService.Checked = false;
            //  ddlServiceItems.Enabled = false;
        }
        else if (rdoItemType.SelectedIndex == 1)
        {
            chkBilled.Checked = true;
            //   chkIsService.Checked = true;
            //  ddlServiceItems.Enabled = true;
        }
        else if (rdoItemType.SelectedIndex == 3)
        {
            chkBilled.Checked = true;
            //  chkIsService.Checked = false;
            //   ddlServiceItems.Enabled = false;
        }
    }

    protected void rdoItemType_SelectedIndexChanged1(object sender, EventArgs e)
    {
        if (rdoItemType.SelectedItem.Value == "GP")
        {
            chkBilled.Checked = true;
            chkBilled.Enabled = false;
            // chkIsService.Checked = false;
            //  chkIsService.Enabled = false;
            // ddlServiceItems.Enabled = false;
        }
        else if (rdoItemType.SelectedItem.Value == "HS")
        {
            chkBilled.Checked = false;
            chkBilled.Enabled = true;
            // chkIsService.Checked = false;
            // ddlServiceItems.Enabled = false;
        }
        else if (rdoItemType.SelectedItem.Value == "IMP")
        {
            chkBilled.Checked = true;
            chkBilled.Enabled = false;
            // chkIsService.Checked = false;
            //  chkIsService.Enabled = false;
            //  ddlServiceItems.Enabled = false;
        }
    }

    #endregion All On Checkbox Chenge

    private static Boolean SaveItemDetailsModified(string SubCategoryID, string TypeID, string Name, string IsEffectingInventory, string Description, string IsExpirable, string BillingUnit, string Pulse, string IsTrigger, string StartTime, string EndTime, string BufferTime, string IsActive, string QtyInHand, string IsAuthorised, string Rack, string Shelf, double MaxLevel, double MinLevel, double ReorderLevel, double ReorderQty, double MaxReorderQty, double MinReorderQty, string Packing, string ManufactureID, MySqlTransaction txn, string ServiceItemId, string ServiceName, string IsUsable, int TobeBilled, string majorUnit, string USrID, float SaleTaxPer, string ItemCode, string ItemCatalog, int GSTApplicable, string MinorUnit, decimal CFactor, string ScheduleType, string DeptLedgerNo, string CommodityCode, string Dose, string MedicineType, string IsGenericExist, string SaltID, string Strength, string HSNCode, decimal IGST, decimal SGST, decimal CGST, string GSTType, int IsStent, string ManufactureName, int IsOnSellingPrice, decimal SellingMargin, int chkIsAsset, int drugCategoryMasterID, int IsStockAble, string VatType, string VatLine, string SaleVatType, string SaleVatLine, string SaleVat, string PurchaseVat, string ItemType, int IsCSSD, int IsLaundry,decimal ItemDose, MySqlConnection con)
    {

        try
        {
            ItemMaster objIMaster = new ItemMaster(txn);
            objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objIMaster.Type_ID = 0; //Util.GetString(TypeID);
            objIMaster.TypeName = Util.GetString(Name);
            objIMaster.Description = Util.GetString(Description);
            objIMaster.SubCategoryID = Util.GetString(SubCategoryID);
            objIMaster.IsEffectingInventory = Util.GetString(IsEffectingInventory);
            objIMaster.IsExpirable = Util.GetString(IsExpirable);
            objIMaster.BillingUnit = Util.GetString(BillingUnit);
            objIMaster.Pulse = Util.GetString(Pulse);
            objIMaster.IsTrigger = Util.GetString(IsTrigger);
            objIMaster.StartTime = Util.GetDateTime(StartTime);
            objIMaster.EndTime = Util.GetDateTime(EndTime);
            objIMaster.BufferTime = Util.GetString(BufferTime);
            objIMaster.IsActive = Util.GetInt(IsActive);
            objIMaster.QtyInHand = Util.GetDecimal(QtyInHand);
            objIMaster.IsAuthorised = Util.GetInt(IsAuthorised);
            objIMaster.ItemCatalog = Util.GetString(ItemCatalog);
            objIMaster.Rack = Util.GetString(Rack);
            objIMaster.Shelf = Util.GetString(Shelf);

            objIMaster.MaxLevel = Util.GetDouble(MaxLevel);
            objIMaster.MinLevel = Util.GetDouble(MinLevel);
            objIMaster.ReorderLevel = Util.GetDouble(ReorderLevel);
            objIMaster.ReorderQty = Util.GetDouble(ReorderQty);
            objIMaster.MaxReorderQty = Util.GetDouble(MaxReorderQty);
            objIMaster.MinReorderQty = Util.GetDouble(MinReorderQty);

            objIMaster.Packing = Util.GetString(Packing);
            objIMaster.ManufactureID = Util.GetInt(ManufactureID);
            objIMaster.ServiceItemId = Util.GetInt(ServiceItemId);
            objIMaster.IsUsable = Util.GetString(IsUsable);
            objIMaster.ToBeBilled = Util.GetInt(TobeBilled);
            objIMaster.UnitType = Util.GetString(MinorUnit);
            objIMaster.majorUnit = Util.GetString(majorUnit);
            objIMaster.minorUnit = Util.GetString(MinorUnit);
            objIMaster.converter = Util.GetDecimal(CFactor);
            objIMaster.serviceName = Util.GetString(ServiceName);
            objIMaster.CreaterID = Util.GetString(USrID);
            objIMaster.SaleTaxPer = Util.GetDecimal(SaleTaxPer);
            objIMaster.ItemCode = Util.GetString(ItemCode);
            objIMaster.ScheduleType = Util.GetString(ScheduleType);
            objIMaster.CommodityCode = Util.GetString(CommodityCode);
            objIMaster.Dose = Util.GetString(Dose);
            objIMaster.MedicineType = Util.GetString(MedicineType);
            objIMaster.IPAddress = All_LoadData.IpAddress();
            //Gst
            objIMaster.SGSTPercent = SGST;
            objIMaster.CGSTPercent = CGST;
            objIMaster.IGSTPercent = IGST;
            objIMaster.GSTType = Util.GetString(GSTType);
            objIMaster.HSNCode = Util.GetString(HSNCode);
            objIMaster.VatType = Util.GetString(VatType);
            objIMaster.VatLine = Util.GetString(VatLine);
            objIMaster.SaleVatType = Util.GetString(SaleVatType);
            objIMaster.SaleVatLine = Util.GetString(SaleVatLine);
            objIMaster.SaleVat = Util.GetDecimal(SaleVat);
            objIMaster.PurchaseVat = Util.GetDecimal(PurchaseVat);

            //
            //Consignment Work
            objIMaster.IsStent = IsStent;
            //
            //ManufactureName
            objIMaster.ManufactureName = ManufactureName;
            //
            objIMaster.IsOnSellingPrice = IsOnSellingPrice;
            objIMaster.SellingMargin = SellingMargin;
            objIMaster.DrugCategoryMasterID = Util.GetInt(drugCategoryMasterID);
            objIMaster.IsAsset = chkIsAsset;
            objIMaster.IsStockAble = IsStockAble;
            objIMaster.ItemType = ItemType;

            objIMaster.IsCSSD = IsCSSD;
            objIMaster.IsLaundry = IsLaundry;
            objIMaster.ItemDose = ItemDose;
            string ItemID = objIMaster.Insert().ToString();

            if (IsGenericExist == "Yes")
            {
                int salt_id = Convert.ToInt32(SaltID);
                string sql = "select * from f_item_salt where itemid='" + ItemID + "' and SaltID =" + salt_id + "";
                DataTable dt = StockReports.GetDataTable(sql);
                if (dt.Rows.Count == 0)
                {
                    StringBuilder objSQL = new StringBuilder();
                    objSQL.Append("INSERT INTO f_item_salt(ItemID,SaltID,Quantity,Unit,UserID)");
                    objSQL.Append("VALUES('" + ItemID + "'," + salt_id + ",'" + Strength + "','" + Util.GetString(MinorUnit) + "','" + Util.GetString(USrID) + "')");
                    MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, txn);
                    cmd.CommandType = CommandType.Text;
                    int res = cmd.ExecuteNonQuery();

                }
            }


            itemmaster_deptWise imd = new itemmaster_deptWise(txn);
            imd.ItemID = ItemID;
            imd.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            imd.MaxLevel = Util.GetDecimal(MaxLevel);
            imd.MinLevel = Util.GetDecimal(MinLevel);
            imd.ReorderLevel = Util.GetDecimal(ReorderLevel);
            imd.ReorderQty = Util.GetDecimal(ReorderQty);
            imd.MaxReorderQty = Util.GetDecimal(MaxReorderQty);
            imd.MinReorderQty = Util.GetDecimal(MinReorderQty);
            imd.majorUnit = Util.GetString(majorUnit);
            imd.minorUnit = Util.GetString(MinorUnit);
            imd.ConversionFactor = Util.GetDecimal(CFactor);
            imd.SubCategoryID = Util.GetString(SubCategoryID); ;
            imd.CreatedBy = Util.GetString(USrID);
            imd.ipAddress = HttpContext.Current.Request.UserHostAddress;
            imd.Rack = Util.GetString(Rack);
            imd.Shelf = Util.GetString(Shelf);
            imd.Insert();
            return true;


        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return false;
        }
    }

    private bool UpdateItemUpdateInventoryItemsGST(string ItemID, string IsEffectingInventory, string Description, string IsExpirable,
        string IsTrigger, string StartTime, string EndTime, string BufferTime, string IsActive,
        string pulse, string Bunit, string SubcategoryID, string TypeName, string Rack, string Shelf,
        double MaxLevel, double MinLevel, double ReorderLevel, double ReorderQty, double MaxReorderQty,
        double MinReorderQty, string Packing, string ManufactureID, MySqlTransaction txn, string ItemForDept,
        string ServiceItemId, int ToBeBilled, string IsUsable, string ServiceName, string majorUnit,
        string UsrID, float SaleTaxPer, string ItemCode, string ItemCatalog, string MinorUnit, decimal CFactor, string ScheduleType, string DeptLedgerNo, string CommodityCode, string Dose, string MedicineType, string Route, string IsGenericExist, string SaltID, string Strength, string HSNCode, decimal IGST, decimal SGST, decimal CGST, string GSTType, int IsStent, string ManufactureName, int IsOnSellingPrice, decimal SellingMargin, int isAsset, int IsCSSD, int IsLaundry, decimal ItemDose, MySqlConnection con)
    {

        StringBuilder strQuery = new StringBuilder();
        try
        {
            if ((DeptLedgerNo == "LSHHI17") || (DeptLedgerNo == "LSHHI18") || (DeptLedgerNo == "LSHHI57") || (DeptLedgerNo == "LSHHI142"))
            {
                if (!string.IsNullOrEmpty(ServiceName))
                {
                    strQuery.Append("Update f_itemmaster Set ");
                    strQuery.Append("ItemDose=" + ItemDose + ",Description ='" + Description + "',ToBeBilled=" + ToBeBilled + " ,IsEffectingInventory ='" + IsEffectingInventory + "',");
                    strQuery.Append("IsExpirable ='" + IsExpirable + "', IsTrigger ='" + IsTrigger + "',");
                    strQuery.Append("StartTime ='" + StartTime + "', EndTime ='" + EndTime + "',");
                    strQuery.Append("BufferTime ='" + BufferTime + "', ");// IsActive =" + IsActive + ",
                    strQuery.Append("pulse ='" + pulse + "',BillingUnit='" + Bunit + "',");
                    strQuery.Append("SubCategoryID ='" + SubcategoryID + "',TypeName='" + TypeName + "',Rack='" + Rack + "',Shelf='" + Shelf + "',");
                    strQuery.Append("MaxLevel='" + MaxLevel + "',MinLevel='" + MinLevel + "',ReorderLevel='" + ReorderLevel + "', ReorderQty='" + ReorderQty + "',");
                    strQuery.Append("MaxReorderQty='" + MaxReorderQty + "',MinReorderQty='" + MinReorderQty + "',Packing='" + Packing + "',");
                    strQuery.Append("ManufactureID='" + ManufactureID + "',Type_ID='" + ItemForDept + "',");
                    strQuery.Append("IsUsable='" + IsUsable + "',ServiceItemID='" + ServiceItemId + "',ToBeBilled=" + ToBeBilled + ",Re_Usable_Service_Name='" + ServiceName.Trim() + "', ");
                    strQuery.Append("UnitType='" + ddl_MajorUnit.SelectedItem.Text + "',MajorUnit='" + ddl_MajorUnit.SelectedItem.Text + "',SaleTaxPer=" + SaleTaxPer + ", ");
                    strQuery.Append("ItemCode='" + ItemCode + "',ItemCatalog='" + ItemCatalog + "',ScheduleType='" + ScheduleType + "',LastUpdatedBy='" + Session["ID"].ToString() + "', ");
                    strQuery.Append("Updatedate=now(),CommodityCode='" + CommodityCode + "', ");
                    strQuery.Append("Dose='" + Dose + "',MedicineType='" + MedicineType + "',Route='" + Route + "' ");
                    strQuery.Append(", HSNCode='" + HSNCode + "',IGST='" + IGST + "',CGST='" + CGST + "',SGST='" + SGST + "',GSTType='" + GSTType + "', IsStent='" + IsStent + "',ManuFacturer='" + ManufactureName + "', SellingMargin =" + SellingMargin + ",IsOnSellingPrice =" + IsOnSellingPrice + ", IsAsset=" + isAsset + ",IsStockable=" + Util.GetInt(ddlIsStockAble.SelectedItem.Value) + ",isCSSDItem=" + IsCSSD + ",isLaundry=" + IsLaundry + " ");
                    strQuery.Append(" Where ItemID = '" + ItemID + "'");
                }
                else
                {
                    strQuery.Append("Update f_itemmaster Set ");
                    strQuery.Append("ItemDose=" + ItemDose + ",Description ='" + Description + "',ToBeBilled=" + ToBeBilled + ", IsEffectingInventory ='" + IsEffectingInventory + "',");
                    strQuery.Append("IsExpirable ='" + IsExpirable + "', IsTrigger ='" + IsTrigger + "',");
                    strQuery.Append("StartTime ='" + StartTime + "', EndTime ='" + EndTime + "',");
                    strQuery.Append("BufferTime ='" + BufferTime + "', ");//IsActive =" + IsActive + ",
                    strQuery.Append("pulse ='" + pulse + "',BillingUnit='" + Bunit + "',");
                    strQuery.Append("SubCategoryID ='" + SubcategoryID + "',TypeName='" + TypeName + "',Rack='" + Rack + "',Shelf='" + Shelf + "',");
                    strQuery.Append("MaxLevel='" + MaxLevel + "',MinLevel='" + MinLevel + "',ReorderLevel='" + ReorderLevel + "', ReorderQty='" + ReorderQty + "',");
                    strQuery.Append("MaxReorderQty='" + MaxReorderQty + "',MinReorderQty='" + MinReorderQty + "',Packing='" + Packing + "',");
                    strQuery.Append("ManufactureID='" + ManufactureID + "',Type_ID='" + ItemForDept + "',");
                    strQuery.Append("IsUsable='" + IsUsable + "',ServiceItemID='" + ServiceItemId + "',");
                    strQuery.Append("MinorUnit='" + MinorUnit + "',");
                    strQuery.Append("UnitType='" + MinorUnit + "',");
                    strQuery.Append("MajorUnit='" + ddl_MajorUnit.SelectedItem.Text + "',");
                    strQuery.Append("ConversionFactor=" + CFactor + ",");
                    strQuery.Append("Type_ID='" + ItemForDept + "', SaleTaxPer=" + SaleTaxPer + ", ItemCode='" + ItemCode + "',ItemCatalog='" + ItemCatalog + "',ScheduleType='" + ScheduleType + "',LastUpdatedBy='" + Session["ID"].ToString() + "' ,Updatedate=now(),CommodityCode='" + CommodityCode + "', "); ;
                    strQuery.Append("Dose='" + Dose + "',MedicineType='" + MedicineType + "',Route='" + Route + "' ");
                    strQuery.Append(", HSNCode='" + HSNCode + "',IGSTPercent='" + IGST + "',CGSTPercent='" + CGST + "',SGSTPercent='" + SGST + "',GSTType='" + GSTType + "',IsStent='" + IsStent + "',ManuFacturer='" + ManufactureName + "', SellingMargin =" + SellingMargin + ",IsOnSellingPrice =" + IsOnSellingPrice + ", IsAsset=" + isAsset + ",IsStockable=" + Util.GetInt(ddlIsStockAble.SelectedItem.Value) + ",isCSSDItem=" + IsCSSD + ",isLaundry=" + IsLaundry + " ");
                    strQuery.Append(" Where ItemID = '" + ItemID + "'");
                }
                MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, strQuery.ToString());


                if (IsGenericExist == "Yes")
                {
                    StringBuilder objSQL = new StringBuilder();
                    int salt_id = Convert.ToInt32(SaltID);
                    string sql = "select * from f_item_salt where itemid='" + ItemID + "' and SaltID =" + salt_id + "";
                    DataTable dt = StockReports.GetDataTable(sql);
                    if (dt.Rows.Count == 0)
                    {

                        objSQL.Append("INSERT INTO f_item_salt(ItemID,SaltID,Quantity,Unit,UserID)");
                        objSQL.Append("VALUES('" + ItemID + "'," + salt_id + ",'" + Strength + "','" + Util.GetString(MinorUnit) + "','" + Session["ID"].ToString() + "')");
                        MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, txn);
                        cmd.CommandType = CommandType.Text;
                        int res = cmd.ExecuteNonQuery();

                    }
                    else
                    {
                        objSQL.Append("UPDATE f_item_salt set Quantity='" + Strength + "',Unit='" + Util.GetString(MinorUnit) + "' where itemid='" + ItemID + "' and SaltID ='" + salt_id + "'");
                        MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, txn);
                        cmd.CommandType = CommandType.Text;
                        int res = cmd.ExecuteNonQuery();
                    }
                }

            }


            MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_purchaseorderdetails ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");
            MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_purchaserequestdetails ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");
            MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_stock ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");
            //  MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_stock ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");

            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_itemmaster_deptWise Where ItemID = '" + ItemID + "' AND DeptLedgerNo='" + DeptLedgerNo + "'"));
            if (count > 0)
            {
                MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_itemmaster_deptWise SET MaxLevel='" + MaxLevel + "',MinLevel='" + MinLevel + "',ReorderLevel='" + ReorderLevel + "', ReorderQty='" + ReorderQty + "', " +
                    " MaxReorderQty='" + MaxReorderQty + "',MinReorderQty='" + MinReorderQty + "',majorUnit='" + majorUnit + "',minorUnit='" + MinorUnit + "',ConversionFactor=" + CFactor + ",SubCategoryID ='" + SubcategoryID + "',UpdatedBy='" + UsrID + "',UpdatedDate=NOW(),Rack='" + Rack + "',Shelf='" + Shelf + "'  " +
                    " Where ItemID = '" + ItemID + "' AND DeptLedgerNo='" + DeptLedgerNo + "'");
            }

            else
            {
                itemmaster_deptWise imd = new itemmaster_deptWise(txn);
                imd.ItemID = ItemID;
                imd.DeptLedgerNo = Util.GetString(DeptLedgerNo);
                imd.MaxLevel = Util.GetDecimal(MaxLevel);
                imd.MinLevel = Util.GetDecimal(MinLevel);
                imd.ReorderLevel = Util.GetDecimal(ReorderLevel);
                imd.ReorderQty = Util.GetDecimal(ReorderQty);
                imd.MaxReorderQty = Util.GetDecimal(MaxReorderQty);
                imd.MinReorderQty = Util.GetDecimal(MinReorderQty);
                imd.majorUnit = Util.GetString(majorUnit);
                imd.minorUnit = Util.GetString(MinorUnit);
                imd.ConversionFactor = Util.GetDecimal(CFactor);
                imd.SubCategoryID = Util.GetString(SubcategoryID); ;
                imd.CreatedBy = Util.GetString(UsrID);
                imd.ipAddress = HttpContext.Current.Request.UserHostAddress;
                imd.Rack = Util.GetString(Rack);
                imd.Shelf = Util.GetString(Shelf);
                imd.Insert();
            }
            grdServiceItemsGST.DataSource = ViewState["dt"];
            grdServiceItemsGST.DataBind();

            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }

    private bool UpdateItemUpdateInventoryItems(string ItemID, string IsEffectingInventory, string Description, string IsExpirable,
      string IsTrigger, string StartTime, string EndTime, string BufferTime, string IsActive,
      string pulse, string Bunit, string SubcategoryID, string TypeName, string Rack, string Shelf,
      double MaxLevel, double MinLevel, double ReorderLevel, double ReorderQty, double MaxReorderQty,
      double MinReorderQty, string Packing, string ManufactureID, MySqlTransaction txn, string ItemForDept,
      string ServiceItemId, int ToBeBilled, string IsUsable, string ServiceName, string majorUnit,
      string UsrID, float SaleTaxPer, string ItemCode, string ItemCatalog, string MinorUnit, decimal CFactor, string ScheduleType, string DeptLedgerNo, string CommodityCode, string Dose, string MedicineType, string Route, string IsGenericExist, string SaltID, string Strength, string HSNCode, decimal IGST, decimal SGST, decimal CGST, string GSTType, int IsStent, string ManufactureName, int IsOnSellingPrice, decimal SellingMargin, int isAsset, int DrugCategoryMasterID, int IsStockAble, string VatType, string VatLine, string SaleVatType, string SaleVatLine, string SaleVat, string PurchaseVat, string ItemType,int IsCSSD, int IsLaundry,decimal ItemDose, MySqlConnection con)
    {

        StringBuilder strQuery = new StringBuilder();
        try
        {
            //(DeptLedgerNo == "LSHHI17") || (DeptLedgerNo == "LSHHI18") || (DeptLedgerNo == "LSHHI57")
            if (true)
            {
                if (!string.IsNullOrEmpty(ServiceName))
                {
                    strQuery.Append("Update f_itemmaster Set ");
                    strQuery.Append(" ItemDose=" + ItemDose + ", Description ='" + Description + "',ToBeBilled=" + ToBeBilled + " ,IsEffectingInventory ='" + IsEffectingInventory + "',");
                    strQuery.Append("IsExpirable ='" + IsExpirable + "', IsTrigger ='" + IsTrigger + "',");
                    strQuery.Append("StartTime ='" + StartTime + "', EndTime ='" + EndTime + "',");
                    strQuery.Append("BufferTime ='" + BufferTime + "', IsActive =" + IsActive + ",");
                    strQuery.Append("pulse ='" + pulse + "',BillingUnit='" + Bunit + "',");
                    strQuery.Append("SubCategoryID ='" + SubcategoryID + "',TypeName='" + TypeName + "',Rack='" + Rack + "',Shelf='" + Shelf + "',");
                    strQuery.Append("MaxLevel='" + MaxLevel + "',MinLevel='" + MinLevel + "',ReorderLevel='" + ReorderLevel + "', ReorderQty='" + ReorderQty + "',");
                    strQuery.Append("MaxReorderQty='" + MaxReorderQty + "',MinReorderQty='" + MinReorderQty + "',Packing='" + Packing + "',");
                    strQuery.Append("ManufactureID='" + ManufactureID + "',Type_ID='" + ItemForDept + "',");
                    strQuery.Append("IsUsable='" + IsUsable + "',ServiceItemID='" + ServiceItemId + "',ToBeBilled=" + ToBeBilled + ",Re_Usable_Service_Name='" + ServiceName.Trim() + "', ");
                    strQuery.Append("UnitType='" + ddl_MajorUnit.SelectedItem.Text + "',MajorUnit='" + ddl_MajorUnit.SelectedItem.Text + "',SaleTaxPer=" + SaleTaxPer + ", ");
                    strQuery.Append("VatType='" + ddlVATType.SelectedItem.Text + "',VatLine='" + ddlVATLine.SelectedItem.Text + "',");
                    strQuery.Append("SaleVatType='" + ddlSaleVatType.SelectedItem.Text + "',SaleVatLine='" + ddlSaleVatLine.SelectedItem.Text + "',DefaultSaleVatPercentage='" + Util.GetDecimal(SaleVat) + "',DefaultPurchaseVatPercentage='" + Util.GetDecimal(PurchaseVat) + "', ");
                    strQuery.Append("ItemCode='" + ItemCode + "',ItemCatalog='" + ItemCatalog + "',ScheduleType='" + ScheduleType + "',LastUpdatedBy='" + Session["ID"].ToString() + "', ");
                    strQuery.Append("Updatedate=now(),CommodityCode='" + CommodityCode + "', ");
                    strQuery.Append("Dose='" + Dose + "',MedicineType='" + MedicineType + "',Route='" + Route + "' ");
                    strQuery.Append(", HSNCode='" + HSNCode + "',IGST='" + IGST + "',CGST='" + CGST + "',SGST='" + SGST + "',GSTType='" + GSTType + "', IsStent='" + IsStent + "',ManuFacturer='" + ManufactureName + "',DrugCategoryMasterID=" + DrugCategoryMasterID + ", SellingMargin =" + SellingMargin + ",IsOnSellingPrice =" + IsOnSellingPrice + ", IsAsset=" + isAsset + ",IsStockAble= " + IsStockAble);
                    strQuery.Append(" , ItemType='" + ItemType + "',isCSSDItem=" + IsCSSD + ",isLaundry=" + IsLaundry + "  ");
                    strQuery.Append(" Where ItemID = '" + ItemID + "'");
                }
                else
                {
                    strQuery.Append("Update f_itemmaster Set ");
                    strQuery.Append(" ItemDose=" + ItemDose + ",Description ='" + Description + "',ToBeBilled=" + ToBeBilled + ", IsEffectingInventory ='" + IsEffectingInventory + "',");
                    strQuery.Append("IsExpirable ='" + IsExpirable + "', IsTrigger ='" + IsTrigger + "',");
                    strQuery.Append("StartTime ='" + StartTime + "', EndTime ='" + EndTime + "',");
                    strQuery.Append("BufferTime ='" + BufferTime + "', IsActive =" + IsActive + ",");
                    strQuery.Append("pulse ='" + pulse + "',BillingUnit='" + Bunit + "',");
                    strQuery.Append("SubCategoryID ='" + SubcategoryID + "',TypeName='" + TypeName + "',Rack='" + Rack + "',Shelf='" + Shelf + "',");
                    strQuery.Append("MaxLevel='" + MaxLevel + "',MinLevel='" + MinLevel + "',ReorderLevel='" + ReorderLevel + "', ReorderQty='" + ReorderQty + "',");
                    strQuery.Append("MaxReorderQty='" + MaxReorderQty + "',MinReorderQty='" + MinReorderQty + "',Packing='" + Packing + "',");
                    strQuery.Append("ManufactureID='" + ManufactureID + "',Type_ID='" + ItemForDept + "',");
                    strQuery.Append("IsUsable='" + IsUsable + "',ServiceItemID='" + ServiceItemId + "',");
                    strQuery.Append("MinorUnit='" + MinorUnit + "',");
                    strQuery.Append("UnitType='" + MinorUnit + "',");
                    strQuery.Append("MajorUnit='" + ddl_MajorUnit.SelectedItem.Text + "',");
                    strQuery.Append("VatType='" + ddlVATType.SelectedItem.Text + "',");
                    strQuery.Append("VatLine='" + ddlVATLine.SelectedItem.Text + "',");
                    strQuery.Append("SaleVatType='" + ddlSaleVatType.SelectedItem.Text + "',SaleVatLine='" + ddlSaleVatLine.SelectedItem.Text + "', DefaultSaleVatPercentage='" + Util.GetDecimal(SaleVat) + "', DefaultPurchaseVatPercentage='" + Util.GetDecimal(PurchaseVat) + "',");
                    strQuery.Append("ConversionFactor=" + CFactor + ",");
                    strQuery.Append("Type_ID='" + ItemForDept + "', SaleTaxPer=" + SaleTaxPer + ", ItemCode='" + ItemCode + "',ItemCatalog='" + ItemCatalog + "',ScheduleType='" + ScheduleType + "',LastUpdatedBy='" + Session["ID"].ToString() + "' ,Updatedate=now(),CommodityCode='" + CommodityCode + "', "); ;
                    strQuery.Append("Dose='" + Dose + "',MedicineType='" + MedicineType + "',Route='" + Route + "' ");
                    strQuery.Append(", HSNCode='" + HSNCode + "',IGSTPercent='" + IGST + "',CGSTPercent='" + CGST + "',SGSTPercent='" + SGST + "',GSTType='" + GSTType + "',IsStent='" + IsStent + "',ManuFacturer='" + ManufactureName + "', SellingMargin =" + SellingMargin + ",DrugCategoryMasterID=" + DrugCategoryMasterID + ",IsOnSellingPrice =" + IsOnSellingPrice + ", IsAsset=" + isAsset + ",IsStockAble= " + IsStockAble);
                    strQuery.Append(" , ItemType='" + ItemType + "',isCSSDItem=" + IsCSSD + ",isLaundry=" + IsLaundry + "  ");
                    strQuery.Append(" Where ItemID = '" + ItemID + "'");
                }
                MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, strQuery.ToString());


                if (IsGenericExist == "Yes")
                {
                    StringBuilder objSQL = new StringBuilder();
                    int salt_id = Convert.ToInt32(SaltID);
                    string sql = "select * from f_item_salt where itemid='" + ItemID + "' and SaltID =" + salt_id + "";
                    DataTable dt = StockReports.GetDataTable(sql);
                    if (dt.Rows.Count == 0)
                    {

                        objSQL.Append("INSERT INTO f_item_salt(ItemID,SaltID,Quantity,Unit,UserID)");
                        objSQL.Append("VALUES('" + ItemID + "'," + salt_id + ",'" + Strength + "','" + Util.GetString(MinorUnit) + "','" + Session["ID"].ToString() + "')");
                        MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, txn);
                        cmd.CommandType = CommandType.Text;
                        int res = cmd.ExecuteNonQuery();

                    }
                    else
                    {
                        objSQL.Append("UPDATE f_item_salt set Quantity='" + Strength + "',Unit='" + Util.GetString(MinorUnit) + "' where itemid='" + ItemID + "' and SaltID ='" + salt_id + "'");
                        MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, txn);
                        cmd.CommandType = CommandType.Text;
                        int res = cmd.ExecuteNonQuery();
                    }
                }

            }


            MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_purchaseorderdetails ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");
            MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_purchaserequestdetails ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");
            MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_stock ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");
            //  MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_stock ll SET ll.ItemName='" + TypeName + "' WHERE ll.ItemID='" + ItemID + "'");

            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_itemmaster_deptWise Where ItemID = '" + ItemID + "' AND DeptLedgerNo='" + DeptLedgerNo + "'"));
            if (count > 0)
            {
                MySqlHelper.ExecuteNonQuery(txn, CommandType.Text, "UPDATE f_itemmaster_deptWise SET MaxLevel='" + MaxLevel + "',MinLevel='" + MinLevel + "',ReorderLevel='" + ReorderLevel + "', ReorderQty='" + ReorderQty + "', " +
                    " MaxReorderQty='" + MaxReorderQty + "',MinReorderQty='" + MinReorderQty + "',majorUnit='" + majorUnit + "',minorUnit='" + MinorUnit + "',ConversionFactor=" + CFactor + ",SubCategoryID ='" + SubcategoryID + "',UpdatedBy='" + UsrID + "',UpdatedDate=NOW(),Rack='" + Rack + "',Shelf='" + Shelf + "'  " +
                    " Where ItemID = '" + ItemID + "' AND DeptLedgerNo='" + DeptLedgerNo + "'");
            }

            else
            {
                itemmaster_deptWise imd = new itemmaster_deptWise(txn);
                imd.ItemID = ItemID;
                imd.DeptLedgerNo = Util.GetString(DeptLedgerNo);
                imd.MaxLevel = Util.GetDecimal(MaxLevel);
                imd.MinLevel = Util.GetDecimal(MinLevel);
                imd.ReorderLevel = Util.GetDecimal(ReorderLevel);
                imd.ReorderQty = Util.GetDecimal(ReorderQty);
                imd.MaxReorderQty = Util.GetDecimal(MaxReorderQty);
                imd.MinReorderQty = Util.GetDecimal(MinReorderQty);
                imd.majorUnit = Util.GetString(majorUnit);
                imd.minorUnit = Util.GetString(MinorUnit);
                imd.ConversionFactor = Util.GetDecimal(CFactor);
                imd.SubCategoryID = Util.GetString(SubcategoryID); ;
                imd.CreatedBy = Util.GetString(UsrID);
                imd.ipAddress = HttpContext.Current.Request.UserHostAddress;
                imd.Rack = Util.GetString(Rack);
                imd.Shelf = Util.GetString(Shelf);
                imd.Insert();
            }

            if (Resources.Resource.IsGSTApplicable == "0")
            {
                grdServiceItems.DataSource = ViewState["dt"];
                grdServiceItems.DataBind();
            }
            else
            {
                grdServiceItemsGST.DataSource = ViewState["dt"];
                grdServiceItemsGST.DataBind();
            }

            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }

    public void clearControls()
    {
        ddl_MajorUnit.SelectedIndex = 0;
        ddlVATType.SelectedIndex = 0;
        ddlVATLine.SelectedIndex = 0;
        ddlSaleVatType.SelectedIndex = 0;
        ddlSaleVatLine.SelectedIndex = 0;
        txtSale.Text = "";
        txtPurchase.Text = "";
        ddl_minor.SelectedIndex = 0;
        txtRusable.Text = "";
        ddlGroup.SelectedIndex = 0;
        ddlmanufacture.SelectedIndex = 0;
        ddlScheduleType.SelectedIndex = 0;
        ddlDrugCategory.SelectedIndex = 0;
       

    }

    public ListItem[] LoadItems(string[,] str)
    {
        try
        {
            if (str == null)
            {
                ListItem[] item = new ListItem[1];
                item[0] = new ListItem("", "");
                return item;
            }

            ListItem[] Items = new ListItem[str.Length / 2];

            for (int i = 0; i < str.Length / 2; i++)
            {
                Items[i] = new ListItem(str[i, 0].ToString(), str[i, 1].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    public ListItem[] LoadItems(DataTable str)
    {
        try
        {
            ListItem[] Items = new ListItem[str.Rows.Count];

            for (int i = 0; i < str.Rows.Count; i++)
            {
                Items[i] = new ListItem(str.Rows[i]["Name"].ToString(), str.Rows[i]["SubCategoryID"].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    private void ClearFields()
    {
        txtPacking.Text = "";
        txtMinLevel.Text = "";
        txtMaxLevel.Text = "";
        txtReorderLevel.Text = "";
        txtReorderQty.Text = "";
        txtMaxReorderQty.Text = "";
        txtMinReorderQty.Text = "";
        txtRack.Text = "";
        txtShelf.Text = "";
        txtName.Text = "";
        txtDesc.Text = "";
        txtBilling.Text = "";
        txtBufferTime.Text = "";
        txtEndTime.Text = "";
        txtStartTime.Text = "";
        txtPulse.Text = "";
        txtItemCode.Text = "";
        txtItemCatalog.Text = "";
        txtHSNcode.Text = "";
        txtIGst.Text = "0.00";
        txtSGst.Text = "0.00";
        txtCGst.Text = "0.00";
        txtUTGST.Text = "0.00";
        ddlGSTType.SelectedIndex=1;
        rbtnGst.SelectedIndex = 1;
        trIGstTax.Visible = trPartialUTGSUTax.Visible = false;
        trPartialCgstTax.Visible = trPartialSgstTax.Visible = true;

        chkIsEffectingInventory.Checked = false;
        chkIsTrigger.Checked = false;

        txtName.Enabled = true;
        txtDesc.Enabled = true;
        txtBilling.Enabled = true;
        txtBufferTime.Enabled = true;
        txtEndTime.Enabled = true;
        txtStartTime.Enabled = true;
        txtPulse.Enabled = true;
        chkIsActive.Enabled = true;
        chkIsEffectingInventory.Enabled = true;
        chkIsTrigger.Enabled = true;
        chkIsService.Checked = false;
        ddlServiceItems.Enabled = false;
        rdoUsabletype.SelectedIndex = 0;
        // ddlServiceItems.SelectedIndex = 0;
        ddlGroup.SelectedIndex = 0;
        ddlmanufacture.SelectedIndex = 0;
        ddl_MajorUnit.SelectedIndex = 0;
        ddlVATType.SelectedIndex = 0;
        ddlVATLine.SelectedIndex = 0;
        ddlSaleVatType.SelectedIndex = 0;
        ddlSaleVatLine.SelectedIndex = 0;
        txtSale.Text = "";
        txtPurchase.Text = "";
        ddl_minor.SelectedIndex = 0;
        txtCFactor.Text = "";
        chkIsActive.Visible = false;
        chkIsActive.Checked = true;
        txtDose.Text = "";
        ddlMedicineType.SelectedIndex = 0;
        ddlItemType.SelectedIndex = 0;

        chkGenric.Checked = false;
        ddl_salt.SelectedIndex = 0;
        txtstrength.Text = "";
        cbIsStent.Checked = false;
        ddlIsOnSellingPrice.SelectedIndex = 0;
        txtSellingMarginPer.Text = "0.00";
        ViewState["ItemID"] = "";
    }

    private void EnableTrue(string Category)
    {
        if (Category == "0")
        {
            txtName.Enabled = true;
            txtDesc.Enabled = true;
            txtBilling.Enabled = false;
            txtBufferTime.Enabled = false;
            txtEndTime.Enabled = false;
            txtStartTime.Enabled = false;
            txtPulse.Enabled = false;
            chkIsActive.Enabled = true;
            chkIsEffectingInventory.Enabled = false;
            chkIsTrigger.Enabled = false;
            chkIsExpirable.Checked = false;
            ddlmanufacture.SelectedIndex = 0;
        }
        else if (Category == "1")
        {
            txtName.Enabled = true;
            txtDesc.Enabled = true;
            txtBilling.Enabled = false;
            txtBufferTime.Enabled = true;
            txtEndTime.Enabled = true;
            txtStartTime.Enabled = true;
            txtPulse.Enabled = false;
            chkIsActive.Enabled = true;
            chkIsEffectingInventory.Enabled = false;
            chkIsTrigger.Enabled = true;
            chkIsExpirable.Checked = false;
        }
    }

    private void HideColumns(DataTable dtMain)
    {
        if (dtMain == null) return;

        for (int i = 0; i < dtMain.Rows.Count; i++)
        {
            if (dtMain.Rows[i]["IsTrigger"].ToString() == "NO")
            {
                grdServiceItems.Columns[11].Visible = false;
                grdServiceItems.Columns[12].Visible = false;
                grdServiceItems.Columns[13].Visible = false;
                grdServiceItems.Columns[14].Visible = false;
                grdServiceItems.Columns[17].Visible = false;
                grdServiceItems.Columns[18].Visible = false;
                grdServiceItems.Columns[19].Visible = false;
            }
            else if (dtMain.Rows[i]["IsTrigger"].ToString() == "YES")
            {
                grdServiceItems.Columns[11].Visible = true;
                grdServiceItems.Columns[12].Visible = true;
                grdServiceItems.Columns[13].Visible = true;
                grdServiceItems.Columns[14].Visible = true;
                grdServiceItems.Columns[16].Visible = true;
                grdServiceItems.Columns[18].Visible = true;
                grdServiceItems.Columns[19].Visible = true;
            }
        }
    }

    private bool UserValidation()
    {
        try
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

            if (dtAuthority != null && dtAuthority.Rows.Count > 0)
            {
                if (dtAuthority.Rows[0]["IsEdit"].ToString() == "1")
                    return true;
                else
                    return false;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return false;
        }
    }

    protected void ddlGSTType_SelectedIndexChanged(object sender, EventArgs e)
    {

        string GSTType = Util.GetString(ddlGSTType.SelectedItem.Value);


        DataTable dt = StockReports.GetDataTable("SELECT CC.`ID`, cc.`TaxGroup`,cc.`IGSTPer`,cc.`CGSTPer`, IF(cc.`TaxGroup` LIKE '%UTGST%',cc.`SGSTPer`,0.00) AS UTGSTPer , IF(cc.`TaxGroup` LIKE '%SGST%',cc.`SGSTPer`,0.00) AS SGSTPer  FROM `store_taxgroup_category` cc WHERE cc.`id`='" + GSTType + "';");
        if (dt.Rows.Count > 0 && dt != null)
        {
            rbtnGst.SelectedIndex = rbtnGst.Items.IndexOf(rbtnGst.Items.FindByValue(dt.Rows[0]["TaxGroup"].ToString()));
            txtIGst.Text = dt.Rows[0]["IGSTPer"].ToString();
            txtSGst.Text = dt.Rows[0]["SGSTPer"].ToString();
            txtCGst.Text = dt.Rows[0]["CGSTPer"].ToString();
            txtUTGST.Text = dt.Rows[0]["UTGSTPer"].ToString();

            if (dt.Rows[0]["TaxGroup"].ToString() == "IGST")
            {
                trIGstTax.Visible = true;
                trPartialCgstTax.Visible = trPartialSgstTax.Visible = trPartialUTGSUTax.Visible = false;
            }
            if (dt.Rows[0]["TaxGroup"].ToString() == "CGST&SGST")
            {
                trIGstTax.Visible = trPartialUTGSUTax.Visible = false;
                trPartialCgstTax.Visible = trPartialSgstTax.Visible = true;
            }
            if (dt.Rows[0]["TaxGroup"].ToString() == "CGST&UTGST")
            {
                trIGstTax.Visible = trPartialSgstTax.Visible = false;
                trPartialCgstTax.Visible = trPartialUTGSUTax.Visible = true;
            }
        }
        else
        {
            rbtnGst.SelectedIndex = rbtnGst.Items.IndexOf(rbtnGst.Items.FindByValue("CGST&SGST"));
            txtIGst.Text = txtSGst.Text = txtCGst.Text = txtUTGST.Text = "0.00";
        }
    }
}