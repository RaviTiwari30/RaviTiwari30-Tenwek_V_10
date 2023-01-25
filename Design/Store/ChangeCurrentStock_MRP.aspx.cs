using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Store_ChangeCurrentStock_MRP : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["DeptLedgerNo"] != null)
                ViewState["CurDeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            else
                ViewState["CurDeptLedgerNo"] = "";
            ViewState["UserID"] = Session["ID"].ToString();
            BindDepartment();
            BindGroup();
            BindItem(ddlGroup.SelectedItem.Value);
            CheckAuthorization();
            rbtnMedNonMed.Enabled = false;
        }
    }

    protected void CheckAuthorization()
    {
          DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
          if (dtAuthority != null && dtAuthority.Rows.Count > 0 && dtAuthority.Rows[0]["ChangeSellingPrice"].ToString() == "1")

            btnSearch.Visible = true;
        else
        {
            btnSearch.Visible = false;
            lblMsg.Text = "You are not Authorized to change the selling price of item";
        }
    }

    private void BindDepartment()
    {
      //  DataTable dt = LoadCacheQuery.loadStoreDepartment();
   //     DataTable dt = LoadCacheQuery.bindStoreDepartment();

        DataTable dt = StockReports.GetDataTable("SELECT ledgerNumber,ledgerName,rm.IsStore,rm.IsGeneral,rm.IsMedical,rm.IsIndent,rm.ID RoleID FROM f_ledgermaster lm INNER JOIN f_rolemaster rm ON lm.ledgerNumber=rm.DeptLedgerNo WHERE lm.GroupID = 'DPT' AND lm.IsCurrent=1 AND rm.Active=1  order by ledgerName ");
   
      
        if (dt.Rows.Count > 0)
        {
            ddlDpt.DataSource = dt;
            ddlDpt.DataTextField = "ledgerName";
            ddlDpt.DataValueField = "ledgerNumber";
            ddlDpt.DataBind();

            ddlDpt.SelectedIndex = ddlDpt.Items.IndexOf(ddlDpt.Items.FindByValue(ViewState["CurDeptLedgerNo"].ToString()));
            ddlDpt.Enabled = false;
        }
    }
    private void BindGroup()
    {
        string strQuery = "";
        strQuery = " SELECT sc.Name GroupHead,sc.SubCategoryID FROM f_subcategorymaster sc ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";

        strQuery += " INNER JOIN f_itemmaster im on im.SubCategoryID = sc.SubCategoryID ";

        strQuery += " WHERE sc.Active=1 ";

        if (rbtnMedNonMed.SelectedValue == "1")
            strQuery += " AND cf.ConfigID ='11' ";
        else if (rbtnMedNonMed.SelectedValue == "2")
            strQuery += " AND cf.ConfigID ='28' ";
        else
            strQuery += " AND cf.ConfigID in ('11','28') ";

        strQuery += " Group by sc.SubCategoryID ORDER BY sc.Name";

        ddlGroup.DataSource = StockReports.GetDataTable(strQuery);
        ddlGroup.DataTextField = "GroupHead";
        ddlGroup.DataValueField = "SubCategoryID";
        ddlGroup.DataBind();

        ddlGroup.Items.Insert(0, new ListItem("All", "ALL"));
        ddlGroup.SelectedIndex = 0;
    }

    protected void rbtnMedNonMed_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroup();
        BindItem(ddlGroup.SelectedValue);
        grdSellingPrice.DataSource = "";
        grdSellingPrice.DataBind();
        btnSave.Visible = false;
    }

    protected void ddlGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem(ddlGroup.SelectedValue);
    }

    private void BindItem(string SubCategoryID)
    {
        string strQuery = "";
        strQuery = " SELECT im.TypeName,im.ItemID FROM f_subcategorymaster sc ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " INNER JOIN f_itemmaster im on im.SubCategoryID = sc.SubCategoryID ";
        strQuery += " WHERE im.IsActive=1 ";

        if (rbtnMedNonMed.SelectedValue == "1")
            strQuery += " AND cf.ConfigID ='11' ";
        else if (rbtnMedNonMed.SelectedValue == "2")
            strQuery += " AND cf.ConfigID ='28' ";
        else
            strQuery += " AND cf.ConfigID in ('11','28') ";

        if (ddlGroup.SelectedValue != "ALL")
            strQuery += " AND im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "' ";

        strQuery += " ORDER BY im.TypeName";

        ddlItem.DataSource = StockReports.GetDataTable(strQuery);
        ddlItem.DataTextField = "TypeName";
        ddlItem.DataValueField = "ItemID";
        ddlItem.DataBind();
        ddlItem.Items.Insert(0, new ListItem("All", "ALL"));
    }

    protected void grdSellingPrice_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM (SELECT StockID,im.ItemCode,SubCatName SubGroup,temp5.ItemID,ItemName,BatchNumber,Rate,DiscPer,PurTaxPer, ");
        sb.Append(" UnitPrice,unitPrice SellingPrice,InitialCount InitialQty,AvailableQty,DATE_FORMAT(StockDate,'%d-%b-%Y')StockDate, DATE_FORMAT(MedExpiryDate,'%d-%b-%Y')ExpiryDate,im.SubCategoryID,DeptName FROM ( ");
        sb.Append(" SELECT ST.DeptLedgerNo,ST.StockID,ST.ItemID,ST.ItemName, ST.BatchNumber,  ST.Rate,ST.DiscPer,ST.PurTaxPer,ST.UnitPrice,ST.MRP, ");
        sb.Append(" ST.InitialCount,(InitialCount-ReleasedCount)AvailableQty,ST.StockDate,ST.MedExpiryDate,SM.Name AS SubCatName, ");
        sb.Append(" LG.LedgerName DeptName ");

        if (rbtnMedNonMed.SelectedItem.Value == "1")
            sb.Append(" FROM f_stock ST  ");
        else
            sb.Append(" FROM f_nmstock ST ");

        sb.Append("INNER JOIN (SELECT * FROM f_ledgermaster  WHERE groupid='DPT' ) LG ON LG.LedgerNumber=ST.DeptLedgerNo INNER JOIN ");
        sb.Append(" f_subcategorymaster sm ON sm.SubCategoryID = st.SubCategoryID WHERE  ST.IsPost = 1   ");

        if (ddlDpt.SelectedItem.Text != "ALL")
            sb.Append("  and ST.DeptLedgerNo='" + ddlDpt.SelectedItem.Value + "' ");

        if (ddlGroup.SelectedItem.Value.ToUpper() != "ALL")
            sb.Append("  and st.SubCategoryID='" + ddlGroup.SelectedItem.Value + "' ");

        if (ddlItem.SelectedItem.Value.ToUpper() != "ALL")
            sb.Append("  and st.ItemID='" + ddlItem.SelectedItem.Value + "' ");

        sb.Append(" ORDER BY ST.SubCategoryID,ST.StockID     ");
        sb.Append(" )temp5 INNER JOIN f_ItemMaster im ON Temp5.ItemID = im.ItemID ");
        sb.Append(" )temp6 WHERE AvailableQty > 0 ");

        if (chkSellingPrice_Zero.Checked == true)
            sb.Append(" and SellingPrice=0");

        sb.Append(" ORDER BY ItemName");

        DataTable dtStock = StockReports.GetDataTable(sb.ToString());

        if (dtStock.Rows.Count > 0)
        {
            grdSellingPrice.DataSource = dtStock;
            grdSellingPrice.DataBind();
            btnSave.Visible = true;
        }
        else
        {
            grdSellingPrice.DataSource = "";
            grdSellingPrice.DataBind();
            btnSave.Visible = false;
        }
    }

    protected void ddlDpt_SelectedIndexChanged(object sender, EventArgs e)
    {
        grdSellingPrice.DataSource = "";
        grdSellingPrice.DataBind();
        btnSave.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (grdSellingPrice.Rows.Count > 0)
            {
                foreach (GridViewRow grItemNew in grdSellingPrice.Rows)
                {
                    if (Util.GetDecimal(((TextBox)grItemNew.FindControl("txtNewSellingPrice")).Text) > 0)
                    {
                        StringBuilder sb = new StringBuilder();
                        if (rbtnMedNonMed.SelectedItem.Value == "1")
                        {
                            sb.Append("insert into temp_stock_change(ItemID,StockID,SellingPrice,NewSellingPrice,UpdatedBy,UpdatedDate)  ");
                            sb.Append("values('" + Util.GetString(((Label)grItemNew.FindControl("lblItemID")).Text) + "','" + Util.GetInt(((Label)grItemNew.FindControl("lblStockID")).Text) + "'," + Util.GetDouble(((Label)grItemNew.FindControl("lblSellingPrice")).Text) + "," + Util.GetDouble(((TextBox)grItemNew.FindControl("txtNewSellingPrice")).Text) + "");
                            sb.Append(",'" + Util.GetString(ViewState["UserID"]) + "',NOW())");

                            if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                            {
                                Tranx.Rollback();
                                con.Close();
                                con.Dispose();
                                return;
                            }
                            string strStock = "update f_stock set unitPrice =  " + Util.GetDouble(((TextBox)grItemNew.FindControl("txtNewSellingPrice")).Text) + " where StockID = '" + Util.GetInt(((Label)grItemNew.FindControl("lblStockID")).Text) + "'";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);
                        }
                        if (rbtnMedNonMed.SelectedItem.Value == "2")
                        {
                            sb.Append("insert into temp_nmstock_change(ItemID,StockID,SellingPrice,NewSellingPrice,UpdatedBy,UpdatedDate)  ");
                            sb.Append("values('" + Util.GetString(((Label)grItemNew.FindControl("lblItemID")).Text) + "','" + Util.GetInt(((Label)grItemNew.FindControl("lblStockID")).Text) + "'," + Util.GetDouble(((Label)grItemNew.FindControl("lblSellingPrice")).Text) + "," + Util.GetDouble(((TextBox)grItemNew.FindControl("txtNewSellingPrice")).Text) + "");
                            sb.Append(",'" + Util.GetString(ViewState["UserID"]) + "',NOW())");

                            if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                            {
                                Tranx.Rollback();
                                con.Close();
                                con.Dispose();
                                return;
                            }
                            string strNMStock = "update f_nmstock set unitPrice =  " + Util.GetDouble(((TextBox)grItemNew.FindControl("txtNewSellingPrice")).Text) + " where StockID = '" + Util.GetInt(((Label)grItemNew.FindControl("lblStockID")).Text) + "'";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strNMStock);
                        }
                    }
                }
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            grdSellingPrice.DataSource = "";
            grdSellingPrice.DataBind();
            btnSave.Visible = false;
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
}