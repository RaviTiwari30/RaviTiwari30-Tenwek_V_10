using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_OPD_MemberShipCard_Membership_Card_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCard();
            BindConfig();            
          //  BindData();
        }

    }
    protected void BindConfig()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT id,NAME FROM f_configrelation_master  WHERE isactive=1 order by name ");
        //add for made configrable opd packages.
       var result=from a in  dt.AsEnumerable() where a.Field<int>("ID")!=23 select a;
       DataTable dtnew = dt.Clone();
       dtnew = result.CopyToDataTable();
        if (dt.Rows.Count > 0)
        {
            ddlConfig.DataSource = dtnew;
            ddlConfig.DataValueField = "id";
            ddlConfig.DataTextField = "NAME";
            ddlConfig.DataBind();            
        }
        ddlConfig.Items.Insert(0, "Select");
    }
    protected void BindCard()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT id,NAME FROM membership_card_master WHERE isactive=1 order by name ");

        if (dt.Rows.Count > 0)
        {
            ddlCard.DataSource = dt;
            ddlCard.DataValueField = "id";
            ddlCard.DataTextField = "NAME";
            ddlCard.DataBind();
        }      
            ddlCard.Items.Insert(0, "Select");        
    }
    protected void BindData()
    {
        lblmsg.Text = "";
        BindOPdPackage();
        if (ddlCard.SelectedIndex == 0)
        {
            lblmsg.Text = "Please select Card Name";
            return;
        }
        //if (ddlConfig.SelectedIndex == 0)
        //{
        //    lblmsg.Text = "Please select Category Name";
        //    return;
        //}
       
        if (ddlCard.SelectedIndex > 0 && ddlConfig.SelectedIndex > 0)
        {
            string str = "SELECT sc.SubCategoryID,sc.Name,md.CardID,md.OPD,md.IPD,ifnull(IsOPDPer,1)IsOPDPer,ifnull(IsIPDPer,1)IsIPDPer,IF(md.CardID IS NULL,'false','true')isChecked FROM f_configrelation fc INNER JOIN f_subcategorymaster sc ON sc.CategoryID=fc.CategoryID " +
            " LEFT JOIN membership_Discount_SubcategoryWise md ON md.SubcategoryID=sc.SubCategoryID AND md.CardID=" + ddlCard.SelectedValue + " WHERE ConfigID=" + ddlConfig.SelectedValue + " AND sc.Active=1 AND fc.IsActive=1";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                grdSetDiscount.DataSource = dt;
                grdSetDiscount.DataBind();
                btnSave.Enabled = true;
                divgrd.Visible = true;
                
            }
            else
            {
                grdSetDiscount.DataSource = null;
                btnSave.Enabled = false;
                divgrd.Visible = false;
                lblmsg.Text = "No record found";
            }
        }
        else {
            grdSetDiscount.DataSource = null;
            //btnSave.Enabled = false;
            divgrd.Visible = false;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {          
            if (ddlCard.SelectedIndex == 0)
            {
                lblmsg.Text = "Please select Card Name";
                return;
            }
            string SubCatId = "", SubCatName = "", str = "", strchk = "", Bckup="",ItemId="",PackageId="",PackageName="";;
            int IsOPDPer = 0, IsIPDPer=0,CardId=Util.GetInt(ddlCard.SelectedValue),ValidityDays=0;
            decimal OPD = 0, IPD = 0;

            foreach (GridViewRow gv in grdSetDiscount.Rows)
            {
                if (((CheckBox)gv.FindControl("chkSelect")).Checked)
                {
                        SubCatId = ((Label)gv.FindControl("lblSubCatID")).Text;
                        SubCatName = ((Label)gv.FindControl("lblSubCatName")).Text;
                        OPD =Util.GetDecimal(((TextBox)gv.FindControl("txtOPDPer")).Text);
                        IPD = Util.GetDecimal(((TextBox)gv.FindControl("txtIPDPer")).Text);
                        if (((RadioButtonList)gv.FindControl("rbtnIsPerOPD")).SelectedValue == "OP")
                            IsOPDPer = 1;
                        if (((RadioButtonList)gv.FindControl("rbtnIsPerIPD")).SelectedValue == "IP")
                            IsIPDPer = 1;

//                        Bckup = @"INSERT INTO membership_discount_subcategorywise_bckup(CardID,SubcategoryID,SubCategoryName,OPD,IsOPDPer,IPD,IsIPDPer,date,UserID,CreatedBy)
//                                  SELECT CardID,SubcategoryID,SubCategoryName,OPD,IsOPDPer,IPD,IsIPDPer,date,UserID,'"+Session["ID"].ToString()+"' FROM membership_Discount_SubcategoryWise WHERE  cardid=" + CardId + " AND  SubcategoryID='" + SubCatId + "'";
//                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Bckup);
                    
                    strchk = "delete from membership_Discount_SubcategoryWise where cardid=" + CardId + " and  SubcategoryID='" + SubCatId + "'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strchk);

                            str = "INSERT INTO membership_Discount_SubcategoryWise(CardID,SubcategoryID,SubCategoryName,OPD,IsOPDPer,IPD,IsIPDPer,UserID)VALUES( " +
                                    " " + CardId + ",'" + SubCatId + "','" + SubCatName + "'," + OPD + "," + IsOPDPer + "," + IPD + "," + IsIPDPer + ",'0' )";                      
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                }
            }
            if (rblIsOPDPackage.SelectedValue.Trim() == "Yes")
            {
                foreach (GridViewRow gvOpd in gvOpdPackage.Rows)
                {
                    if (((CheckBox)gvOpd.FindControl("chkOPDPackageSelect")).Checked)
                    {
                        ItemId = Util.GetString(((Label)gvOpd.FindControl("lblItemID")).Text.Split('#')[0]);
                        PackageId = ((Label)gvOpd.FindControl("lblItemID")).Text.Split('#')[1];
                        PackageName = ((Label)gvOpd.FindControl("lblPackageName")).Text;
                        ValidityDays = Util.GetInt(((TextBox)gvOpd.FindControl("txtOPDPackageDays")).Text);

                        strchk = "delete from membership_discount_opdpackage where CardId=" + CardId + " and  PackageId='" + PackageId + "'";
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strchk);

                        str = " INSERT INTO `membership_discount_opdpackage`(`CardId`,`CategoryId`,`PackageId`, `ItemId`, `Package_Name`, `validityDays`,`AssignDate`,`EntryDate`,`UserId`)" +
                                                                                     " VALUES ('" + CardId + "','17', '" + PackageId + "','" + ItemId + "','" + PackageName + "','" + ValidityDays + "',Now(),CURRENT_DATE,'" + Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                    }
                }
            }
            lblmsg.Text = "Record Saved";
            grdSetDiscount.DataSource = null;
            divgrd.Visible = false;
            btnSave.Enabled = false;
            ddlCard.SelectedIndex = 0;
            ddlConfig.SelectedIndex = 0;
            gvOpdPackage.Attributes["Style"]="display:none";
            Tnx.Commit();
            con.Close();
            con.Dispose();            
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);            
        }
    }

    protected void BindItem()
    {
        lstInv.DataSource = null;
        lstInv.DataBind();
        DataTable dt = new DataTable();
        string str = @"SELECT CONCAT(im.ItemID,'#',IFNULL(md.OPD,''),'#',IFNULL(md.IPD,''),'#',IFNULL(IsOPDPer,1),'#',IFNULL(IsIPDPer,1),'#',IF(md.CardID IS NULL,'false','true'))ItemID,im.TypeName ItemName FROM f_subcategorymaster sc 
                    INNER JOIN f_itemmaster im ON im.SubCategoryID=sc.SubCategoryID 
                    LEFT JOIN membership_discount_Itemwise md ON md.ItemID=im.ItemID
                    AND md.CardID=" + ddlCard.SelectedValue + " WHERE sc.SubCategoryID='" + ViewState["SubCategoryID"].ToString() + "' AND sc.Active=1 AND im.IsActive=1 AND im.TypeName LIKE '" + txtWord.Text.Trim() + "%'";
        dt = StockReports.GetDataTable(str);
      //  dt = StockReports.GetDataTable(" SELECT itemid,typename itemname FROM f_itemmaster WHERE SubCategoryID='" + ViewState["SubCategoryID"].ToString() + "' AND isactive=1 ");

        if (dt.Rows.Count > 0)
        {
            lstInv.DataSource = dt;
            lstInv.DataValueField = "itemid";
            lstInv.DataTextField = "itemname";
            lstInv.DataBind();
            lstInv.Items.Insert(0, "Select");
        }
        else
        {
            lstInv.DataSource = null;
            lstInv.DataBind();
        }
    }

    private DataTable GetItem()
    {

        if (ViewState["dtItems"] != null)
        {
            return (DataTable)ViewState["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();

            dtItem = new DataTable();            
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("OPD");
            dtItem.Columns.Add("IPD");
            dtItem.Columns.Add("IsOPDPer");
            dtItem.Columns.Add("IsIPDPer");
            dtItem.Columns.Add("isChecked");            
            return dtItem;
        }
    }

    private void BindGridItem()
    {
        mpeItem.Show();
        lblmsg1.Text = "";
        if (lstInv.SelectedItem == null)
        {
            return;
        }
        string ItemID = "";
        DataTable dtItem = new DataTable();
        if (ViewState["dtItems"] != null)
        {
            dtItem = (DataTable)ViewState["dtItems"];
            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                foreach (ListItem li in lstInv.Items)
                {
                    if (li.Selected == true)
                    {
                        ItemID = li.Value.Split('#')[0].ToString();
                        foreach (DataRow drItem in dtItem.Rows)
                        {
                            if (ItemID == drItem["ItemID"].ToString())
                            {
                                lblmsg1.Text = "Item Already Selected...";
                                txtSearch.Focus();
                                mpeItem.Show();
                                return;
                            }
                        }
                    }
                }
            }
        }
        else
            dtItem = GetItem();

        //if (lstInv.SelectedValue == string.Empty)
        //    return;

        foreach (ListItem li in lstInv.Items)
        {
            if (li.Selected == true)
            {
                DataRow dr = dtItem.NewRow();
                dr["ItemID"] = li.Value.Split('#')[0].ToString();
                dr["ItemName"] = li.Text;
                dr["OPD"] = li.Value.Split('#')[1].ToString();
                dr["IPD"] = li.Value.Split('#')[2].ToString();
                dr["IsOPDPer"] = li.Value.Split('#')[3].ToString();
                dr["IsIPDPer"] = li.Value.Split('#')[4].ToString();
                dr["isChecked"] = li.Value.Split('#')[5].ToString();
                dtItem.Rows.Add(dr);
            }
        }
        dtItem.AcceptChanges();
        ViewState["dtItems"] = dtItem;
        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            divItem.Visible = true;
            grdItems.DataSource = dtItem;
            grdItems.DataBind();
            btnSaveItem.Enabled = true;
        }
        else
        {
            divItem.Visible = false;
            grdItems.DataSource = null;
            btnSaveItem.Enabled = false;
        }
        mpeItem.Show();
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        btnSaveItem.Enabled = false;
        ViewState["SubCategoryID"] = null;
        ViewState["dtItems"] = null;
        grdItems.DataSource = null;
        grdItems.DataBind();
        ViewState["SubCategoryID"] = e.CommandArgument.ToString();
        BindItem();
        mpeItem.Show();
        //DataTable dt = StockReports.GetDataTable("SELECT ID,NAME,Description,No_of_dependant,CardValid,Amount FROM membership_card_master  WHERE IsActive=1 and ID=" + e.CommandArgument.ToString() + "");
        //if (dt.Rows.Count > 0)
        //{
        //    txtCardAmount.Text = dt.Rows[0]["Amount"].ToString();
        //    txtCardName.Text = dt.Rows[0]["Name"].ToString();
        //    txtDescription.Text = dt.Rows[0]["Description"].ToString();
        //    ddlDependant.SelectedIndex = ddlDependant.Items.IndexOf(ddlDependant.Items.FindByValue(dt.Rows[0]["No_of_dependant"].ToString()));
        //    ddlValidYrs.SelectedIndex = ddlValidYrs.Items.IndexOf(ddlValidYrs.Items.FindByValue(dt.Rows[0]["CardValid"].ToString()));
        //    ViewState["ID"] = e.CommandArgument.ToString();
        //    btnSave.Visible = false;
        //    btnUpdate.Visible = true;
        //    btnCancel.Visible = true;
        //}
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        //txtDescription.Text = "";
        //txtCardName.Text = "";
        //txtCardAmount.Text = "";
        //ddlDependant.SelectedIndex = 0;
        //ddlValidYrs.SelectedIndex = 0;
        //btnSave.Visible = true;
        //btnUpdate.Visible = false;
        //btnCancel.Visible = false;
        //ViewState["ID"] = "";
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        
        //string Query = "UPDATE membership_card_master SET NAME='" + txtCardName.Text.Trim() + "',Description='" + txtDescription.Text.Trim() + "',No_of_dependant='" + ddlDependant.SelectedItem.Value + "',CardValid=" + ddlValidYrs.SelectedValue + ",Amount=" + txtCardAmount.Text + " WHERE ID=" + ViewState["ID"].ToString() + "";
        //StockReports.ExecuteDML(Query);
        //BindData();
        //btnCancel_Click(sender, e);
        //lblmsg.Text = "Record Save";
    }
    protected void ddlConfig_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindData();
    }
    protected void grdSetDiscount_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            if (ddlConfig.SelectedItem.Value == "11")
            {
                ((CheckBox)e.Row.FindControl("chkSelectIsPerOPD")).Enabled = false;
            }
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (ddlConfig.SelectedItem.Value == "11")
            { 
               ((Label)e.Row.FindControl("lblIsOPDPer")).Text = "1";
               ((RadioButtonList)e.Row.FindControl("rbtnIsPerOPD")).Enabled = false;
            }

            if (Util.GetInt(((Label)e.Row.FindControl("lblIsOPDPer")).Text) == 1)
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerOPD")).SelectedIndex = 0;
            else
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerOPD")).SelectedIndex = 1;

            if (Util.GetInt(((Label)e.Row.FindControl("lblIsIPDPer")).Text) == 1)
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerIPD")).SelectedIndex = 0;
            else
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerIPD")).SelectedIndex = 1;

        }
    }
    protected void ddlCard_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindData();
    }

    protected void btnWord_Click(object sender, EventArgs e)
    {
        //if (txtWord.Text.Trim() != string.Empty)
        //{
        //    if (Util.GetInt(ViewState["IsSelected"]) == 0)
        //        BindInvestigation();
        //    else
        //    {
                BindItem();
                mpeItem.Show();
              //  txtWord.Focus();
               // BindInvestigation();
           // }
        }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        BindGridItem();
    }

    protected void grdItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
         if (e.Row.RowType == DataControlRowType.Header)
        {
            if (ddlConfig.SelectedItem.Value == "11")
            {
                ((CheckBox)e.Row.FindControl("chkSelectIsPerOPD")).Enabled = false;
            }
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (ddlConfig.SelectedItem.Value == "11")
            { 
               ((Label)e.Row.FindControl("lblIsOPDPer")).Text = "1";
               ((RadioButtonList)e.Row.FindControl("rbtnIsPerOPD")).Enabled = false;
            }

            if (Util.GetInt(((Label)e.Row.FindControl("lblIsOPDPer")).Text) == 1)
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerOPD")).SelectedIndex = 0;
            else
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerOPD")).SelectedIndex = 1;

            if (Util.GetInt(((Label)e.Row.FindControl("lblIsIPDPer")).Text) == 1)
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerIPD")).SelectedIndex = 0;
            else
                ((RadioButtonList)e.Row.FindControl("rbtnIsPerIPD")).SelectedIndex = 1;
        }
    }

    protected void btnSaveItem_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {           
            string ItemId = "", ItemName = "", str = "", strchk = "", Bckup = "";
            int IsOPDPer = 0, IsIPDPer = 0, CardId = Util.GetInt(ddlCard.SelectedValue);
            decimal OPD = 0, IPD = 0;

            foreach (GridViewRow gv in grdItems.Rows)
            {
                if (((CheckBox)gv.FindControl("chkSelect")).Checked)
                {
                    ItemId = ((Label)gv.FindControl("lblItemID")).Text;
                    ItemName = ((Label)gv.FindControl("lblItemName")).Text;
                    OPD = Util.GetDecimal(((TextBox)gv.FindControl("txtOPDPer")).Text);
                    IPD = Util.GetDecimal(((TextBox)gv.FindControl("txtIPDPer")).Text);
                    if (((RadioButtonList)gv.FindControl("rbtnIsPerOPD")).SelectedValue == "OP")
                        IsOPDPer = 1;
                    if (((RadioButtonList)gv.FindControl("rbtnIsPerIPD")).SelectedValue == "IP")
                        IsIPDPer = 1;

//                    Bckup = @"INSERT INTO membership_discount_itemwise_bckup(CardID,ItemID,ItemName,OPD,IsOPDPer,IPD,IsIPDPer,date,UserID,CreatedBy)
//                                  SELECT CardID,ItemID,ItemName,OPD,IsOPDPer,IPD,IsIPDPer,date,UserID,'0' FROM membership_discount_Itemwise WHERE  cardid=" + CardId + " AND  ItemID='" + ItemId + "'";
//                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Bckup);

                    strchk = "delete from membership_discount_Itemwise where cardid=" + CardId + " and  ItemID='" + ItemId + "'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strchk);

                    str = "INSERT INTO membership_discount_Itemwise(CardID,ItemID,ItemName,OPD,IsOPDPer,IPD,IsIPDPer,UserID)VALUES( " +
                            " " + CardId + ",'" + ItemId + "','" + ItemName + "'," + OPD + "," + IsOPDPer + "," + IPD + "," + IsIPDPer + ",'0' )";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                }
            }
            lblmsg.Text = "Record Saved";
            grdItems.DataSource = null;
            grdItems.DataBind();
            divItem.Visible = false;
            btnSaveItem.Enabled = false;
            //ddlCard.SelectedIndex = 0;
            //ddlConfig.SelectedIndex = 0;
            Tnx.Commit();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            lblmsg1.Text = ex.Message;
            mpeItem.Show();
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    public void BindOPdPackage()
    {
        if (ddlCard.SelectedIndex > 0)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.`TypeName`,CONCAT( im.`ItemID`,'#',im.Type_ID)Id, IFNULL(mdo.validityDays,'')validityDays,IF(mdo.Id IS NULL,'false','true')Checked FROM f_itemmaster im ");
            sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID`");
            sb.Append(" INNER JOIN  `f_categorymaster` cm ON cm.`CategoryID`=scm.`CategoryID`");
            sb.Append(" LEFT OUTER JOIN membership_discount_opdpackage mdo ON cm.CategoryID=mdo.CategoryID AND mdo.ItemID= im.ItemID  AND mdo.cardId=" + ddlCard.SelectedValue + "");
            sb.Append(" WHERE  cm.categoryID='17';");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                cblOPDPackageList.DataSource = dt;
                cblOPDPackageList.DataTextField = "TypeName";
                cblOPDPackageList.DataValueField = "Id";
                cblOPDPackageList.DataBind();
                gvOpdPackage.DataSource = dt;
                gvOpdPackage.DataBind();
                btnSave.Enabled = true;
                gvOpdPackage.Attributes["Style"] = "display:block;width:100%";
            }
            else {
                gvOpdPackage.DataSource = null;
                gvOpdPackage.DataBind();
                btnSave.Enabled = false;
                lblmsg.Text = "OPD Packages not found";
            }
        }
        else
        {
            gvOpdPackage.DataSource = null;
            gvOpdPackage.DataBind();
            btnSave.Enabled = false;
        }


    }
}
