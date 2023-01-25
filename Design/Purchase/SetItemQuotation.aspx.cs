using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Purchase_SetItemQuotation : System.Web.UI.Page
{
    public void BindCategoryNew()
    {
        try
        {
            DataView dv = LoadCacheQuery.loadCategory().DefaultView;
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
                dv.RowFilter = "ConfigID=11";
            else if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
                dv.RowFilter = "ConfigID=28";
            else
                dv.RowFilter = "ConfigID IN (11,28)";
            if (dv.Count > 0)
            {
                ddlCategory.DataSource = dv.ToTable();
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataTextField = "Name";
                ddlCategory.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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
            ddlVendor.Items.Insert(0, "ALL");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnRefershItem_Click(object sender, EventArgs e)
    {
        BindItemNew();
        if (ddlSubCategory.SelectedIndex > -1)
        {
            ddlItemGroup.Focus();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dtItems = new DataTable();
        dtItems = (DataTable)GetDepartmentItem();
        if (dtItems.Rows.Count > 0)
        {
            rptitems.DataSource = dtItems;
            rptitems.DataBind();
            lblmsg.Text = "";
        }
        else
        {
            rptitems.DataSource = null;
            rptitems.DataBind();
            lblmsg.Visible = true;
            lblmsg.Text = "No Item Record Found";
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        rptitems.DataSource = null;
        rptitems.DataBind();

        BindSubcategory();
        BindItemNew();
        ddlSubCategory.Focus();
    }

    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItemNew();
        ddlItemGroup.Focus();
    }

    protected DataTable GetDepartmentItem()
    {
        string str = " SELECT im.ItemID,im.TypeName ItemName,im.ManuFacturer,im.SubCategoryID, ";
        //GST Changes
        str += " IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent ";

        str +="  FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_storeitem_rate sir ON im.ItemID=sir.ItemID WHERE im.IsActive=1";
        str += " and sc.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "'";

        if (ddlSubCategory.SelectedIndex > 0)
            str += " AND im.subcategoryid='" + ddlSubCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "'";
        if (ddlVendor.SelectedIndex > 0)
            str += " AND sir.Vendor_ID='" + ddlVendor.SelectedItem.Value.Split('#')[0].ToString() + "'";
        if (ddlItemGroup.SelectedItem.Text != "ALL")
            str += " AND im.ItemID='" + ddlItemGroup.SelectedItem.Value.Split('#')[0].ToString() + "'";
        str += " AND DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' GROUP BY im.ItemID ORDER BY im.TypeName";
        DataTable dtItem = new DataTable();
        dtItem = StockReports.GetDataTable(str.ToString());
        return dtItem;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString()); 
            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

                BindVendor();
                BindCategoryNew();
                BindSubcategory();
                BindItemNew();
            }
        }
    }

    protected void rpt_setvender(object sender, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "set")
        {
            string VendorLedNo = e.CommandArgument.ToString().Split('#')[0];
            string ItemID = e.CommandArgument.ToString().Split('#')[1];
            string StoreRateID = e.CommandArgument.ToString().Split('#')[2];
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                StockReports.ExecuteDML(" UPDATE f_storeitem_rate SET IsActive=0 WHERE ItemID='" + ItemID + "' AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "'  AND isActive =1  ");

                StockReports.ExecuteDML(" UPDATE f_storeitem_rate sir SET IsActive=1 WHERE sir.Vendor_ID='" + VendorLedNo + "' AND sir.ItemID='" + ItemID + "' AND sir.ID='" + StoreRateID + "' AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "'  ");
                DataTable dt = LoadQuotations(ItemID);

                Repeater rptven = (Repeater)e.Item.Parent.Parent.FindControl("rptvender");
                rptven.DataSource = dt;
                rptven.DataBind();
                ((LinkButton)e.Item.FindControl("btnset")).Visible = true;

                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblmsg.Text = "Error.";
            }
        }
    }

    protected void rptitems_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        Repeater rpt = (Repeater)e.Item.FindControl("rptvender");
        if (opType == "SHOW")
        {
            string ItemID = e.CommandArgument.ToString();
            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";
            DataTable dt = LoadQuotations(ItemID);

            if (dt.Rows.Count > 0)
            {
                rpt.DataSource = dt;
                rpt.DataBind();
                lblmsg.Text = string.Empty;
            }
            else
            {
                rpt.DataSource = null;
                rpt.DataBind();
                lblmsg.Text = "No Details Found";
            }
        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "Show";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus.png";

            rpt.DataSource = null;
            rpt.DataBind();
            lblmsg.Text = string.Empty;
        }
    }

    protected void rptitems_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            Repeater rptVendor = (Repeater)e.Item.FindControl("rptvender");
            Label ItemID = ((Label)e.Item.FindControl("lblItemID"));
            rptVendor.DataSource = LoadQuotations(ItemID.Text);
            rptVendor.DataBind();
        }
    }

    protected void rptvender_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex >= 0)
        {
            ((LinkButton)e.Item.FindControl("btnset")).Visible = true;

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string str = "SELECT COUNT(*) FROM f_storeitem_rate WHERE Vendor_ID='" + ((Label)e.Item.FindControl("lblVendorLedgerNo")).Text + "' AND ItemID='" + ((Label)e.Item.Parent.Parent.FindControl("lblItemID")).Text + "'  AND    isactive=1 AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "'";
                int Count = Util.GetInt(StockReports.ExecuteScalar(str));
                if (Count > 0)
                {
                    ((HtmlTableRow)e.Item.FindControl("Tr1")).BgColor = "burlywood";
                }
                else
                {
                    ((HtmlTableRow)e.Item.FindControl("Tr1")).BgColor = "Pink";
                }
                if (((Label)e.Item.FindControl("lblAppStatus")).Text == "True")
                {
                    ((LinkButton)e.Item.FindControl("btnset")).Visible = false;
                }
                else
                {
                    ((LinkButton)e.Item.FindControl("btnset")).Visible = true;
                }
            }
        }
    }

    private DataTable BindItemNew()
    {
        ddlItemGroup.DataSource = null;
        ddlItemGroup.DataBind();

        string str = "select TypeName ,ItemId from f_itemmaster IM  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 ";

        if (ddlSubCategory.SelectedIndex > -1)
        {
            if (ddlSubCategory.SelectedItem.Value != "ALL")
                str = str + " AND IM.subcategoryid='" + ddlSubCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "' ";
            if (ddlCategory.SelectedIndex > -1)
                str = str + " AND SM.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#').GetValue(0).ToString() + "' ";
            str = str + " order by typename ";

            DataTable dt = StockReports.GetDataTable(str);
            ddlItemGroup.DataSource = dt;
            ddlItemGroup.DataTextField = "TypeName";
            ddlItemGroup.DataValueField = "ItemID";
            ddlItemGroup.DataBind();
            ddlItemGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
            return dt;
        }
        else
        {
            lblmsg.Text = "Select SubCategory First";
            DataTable dtItem = new DataTable();
            return dtItem;
        }
    }

    private void BindSubcategory()
    {
        ddlSubCategory.DataSource = null;
        ddlSubCategory.DataBind();
        if (ddlCategory.SelectedItem.Value != "0")
        {
            DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
            dv.RowFilter = "Categoryid='" + ddlCategory.SelectedItem.Value + "'";
            if (dv.Count > 0)
            {
                ddlSubCategory.DataSource = dv.ToTable();
                ddlSubCategory.DataTextField = "name";
                ddlSubCategory.DataValueField = "SubCategoryid";
                ddlSubCategory.DataBind();
            }
        }
        else
        {
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataBind();
        }
        ddlSubCategory.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    private DataTable LoadQuotations(string ItemID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT sir.`Vendor_ID` VendorLedgerNo,sir.ID AS StoreRateID , lm.LedgerName VendorName,sir.ItemID,im.TypeName AS ItemName,IF(sir.IsActive=1,'True','False')AppStatus,sir.GrossAmt  Rate,sir.DiscAmt,sir.TaxAmt,sir.NetAmt,sir.ID StoreRateID,  DATE_FORMAT(sir.FromDate,'%d-%b-%y')FromDate,DATE_FORMAT(sir.ToDate,'%d-%b-%y')ToDate,DATE_FORMAT( sir.`EntryDate`,'%d-%b-%y')EntryDate, ");
        sb.Append(" MRP,IsDeal,fmm.Name, ");

        // GST Changes
        sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent ");

        sb.Append(" FROM f_storeitem_rate sir  ");
        sb.Append(" INNER JOIN f_itemmaster im  ON im.ItemID=sir.ItemID  ");
        sb.Append(" left JOIN f_manufacture_master fmm  ON sir.Manufacturer_ID=fmm.ManufactureID  ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID  ");
        sb.Append(" WHERE  sir.ItemID='" + ItemID + "' AND DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "'   ORDER BY sir.id DESC ");
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

}