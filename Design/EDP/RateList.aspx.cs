using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_RateList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanelOPD();
            LoadCategory();
            CaseTypeBind();
            ViewState["UserID"] = Session["ID"].ToString();
            chkRoomType.Visible = false;
            cmbCaseType.Visible = false;
            DataTable dt = StockReports.GetDataTable("SELECT CountryID,Currency CurrencyName,IsBaseCurrency ,(SELECT  COUNT(*) FROM  converson_master c WHERE c.S_CountryID=CountryID) ConversonFactorCount FROM Country_master WHERE IsActive=1 AND Currency IS NOT NULL  HAVING  ConversonFactorCount>0 ORDER BY IsBaseCurrency DESC");
            ViewState["currencyDataTable"] = dt;
            BindModelCentre();
        }
    }

    protected void btnLoadItem_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (chkCat.Checked == false && chkSubCat.Checked == false && chkItemSearch.Checked == false && chkCodeSearch.Checked == false)
        {
            lblMsg.Text = "Please Specify Any Search Criteria";
            return;
        }

        LoadItems();
    }

    protected void btnRate_Click(object sender, EventArgs e)
    {
        ShowRates();
    }

    protected void btnSave1_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string PanelID = ddlPanelCompany.SelectedItem.Value;
            int ScheduleChargeID = Util.GetInt(ddlScheduleCharge.SelectedItem.Value);
           // string Centre = All_LoadData.SelectCentre(chkCentre);
            string Centre = "";
            Centre = ddlCentre.SelectedValue.ToString() ;
            foreach (ListItem li in chkCentre.Items)
            {
                if (li.Selected)
                {
                    if (Centre != string.Empty)
                        Centre += "," + li.Value + "";
                    else
                        Centre = "" + li.Value + "";
                }
            }

            if (Centre == string.Empty)
            {
                lblMsg.Text = "Please Select Centre";
                return;
            }
            string[] strCentre = Centre.Split(',');
            //**************************SAVING OPD RATES***************************
             
            if (rdbDept.SelectedValue == "0")
            {
                StringBuilder sb = new StringBuilder();
                StringBuilder sb1 = new StringBuilder();
                RateList objRateList = new RateList(Tnx);
                foreach (GridViewRow gRow in grdItemOPD.Rows)
                {
                    foreach (string CentreID in strCentre)
                    {
                        //if (((Label)gRow.FindControl("lblID")).Text != "")
                        //{
                        //    string strQuery = "update  f_ratelist set IsCurrent='0' where ID = " + ((Label)gRow.FindControl("lblID")).Text;
                        //    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);
                        //}
                        StringBuilder sbr = new StringBuilder();
                        sbr.Append("Update f_ratelist Set IsCurrent=0 Where ItemID = '" + ((Label)gRow.FindControl("lblItemID")).Text + "' ");
                        sbr.Append("and PanelID = " + PanelID + " and CentreID=" + Util.GetInt(CentreID) + " ");
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbr.ToString());

                        int rateCurrencyCountryID = Util.GetInt(((DropDownList)gRow.FindControl("ddlRateCurrency")).SelectedItem.Value);


                        objRateList.PanelID = PanelID;
                        objRateList.ItemID = ((Label)gRow.FindControl("lblItemID")).Text;
                        objRateList.Rate = Util.GetDecimal(((TextBox)gRow.FindControl("txtRate")).Text.Trim());
                        objRateList.RateCurrencyCountryID = rateCurrencyCountryID;


                        objRateList.IsTaxable = Util.GetInt("0");
                        objRateList.FromDate = DateTime.Now;
                        objRateList.ToDate = DateTime.Now;
                        objRateList.IsCurrent = Util.GetInt("1");
                        objRateList.IsService = "YES";
                        if (((TextBox)gRow.FindControl("txtItemDisplay")).Text.Trim() != "")
                            objRateList.ItemDisplayName = ((TextBox)gRow.FindControl("txtItemDisplay")).Text.Trim();
                        else
                            objRateList.ItemDisplayName = ((Label)gRow.FindControl("lblItemNameOPD")).Text.Trim();
                        objRateList.ItemCode = ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim();
                        objRateList.ScheduleChargeID = ScheduleChargeID;
                        objRateList.UserID = ViewState["UserID"].ToString();
                        objRateList.IPAddress = All_LoadData.IpAddress();
                        objRateList.CentreID = Util.GetInt(CentreID);
                        objRateList.Insert();

                        if (((CheckBox)gRow.FindControl("chkApplyIPD")).Checked && ((TextBox)gRow.FindControl("txtRate")).Text.Trim() != "")
                        {
                            string ItemID = "";
                            if (((Label)gRow.FindControl("lblItemID")).Text != ItemID)
                            {
                                ItemID = ((Label)gRow.FindControl("lblItemID")).Text;

                                string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                                if (Rate == "") Rate = "0";
                                sb = new StringBuilder();
                                sb.Append("Update f_ratelist_ipd Set IsCurrent=0 Where ItemID = '" + ((Label)gRow.FindControl("lblItemID")).Text + "' ");
                                sb.Append(" and PanelID = " + PanelID + " and CentreID=" + Util.GetInt(CentreID) + "");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                                sb1 = new StringBuilder();
                                sb1.Append("Insert into f_ratelist_ipd(Location,HospCode,Rate,IsCurrent,ItemID,PanelID,IPDCaseTypeID,ItemDisplayName,ItemCode,ScheduleChargeID,UserID,IPAddress,RateCurrencyCountryID,CentreID)");
                                sb1.Append(" Select 'L','SHHI'," + Rate + ",'" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "',");
                                sb1.Append(" '" + ((Label)gRow.FindControl("lblItemID")).Text + "'," + PanelID + ",icm.Description,");
                                sb1.Append(" '" + ((TextBox)gRow.FindControl("txtItemDisplay")).Text.Trim() + "',");
                                sb1.Append(" '" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',");
                                sb1.Append(" '" + ScheduleChargeID + "','" + ViewState["UserID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + rateCurrencyCountryID + "," + Util.GetInt(CentreID) + " from (Select (REPLACE(Description,'LSHHI','')+0)Description from f_subcategorymaster ");//Description
                                sb1.Append(" sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID Where cf.ConfigID=2 and sc.Active=1) icm  ");

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb1.ToString());
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "update f_ratelist_ipd set RatelistID = CONCAT(location,HospCode,id) where RatelistID is null or RatelistID=''");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");

                            }
                        }
                    }
                }
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist) WHERE groupname='f_ratelist' ");

            }
            //**************************SAVING IPD RATES***************************
            else
            {
                StringBuilder sb = new StringBuilder();
                StringBuilder sb1 = new StringBuilder();
                if (chkToAllRooms.Checked)
                {
                    string ItemID = "";
                    foreach (GridViewRow gRow in grdItemIPD.Rows)
                    {
                        foreach (string CentreID in strCentre)
                        {
                            if (((Label)gRow.FindControl("lblItemID")).Text != ItemID)
                            {
                                ItemID = ((Label)gRow.FindControl("lblItemID")).Text;

                                string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                                int rateCurrencyCountryID = Util.GetInt(((DropDownList)gRow.FindControl("ddlRateCurrency")).SelectedItem.Value);
                                if (Rate == "") Rate = "0";

                                sb = new StringBuilder();
                                sb.Append("Update f_ratelist_ipd Set IsCurrent=0 Where ItemID = '" + ((Label)gRow.FindControl("lblItemID")).Text + "' ");
                                sb.Append("and PanelID = " + PanelID + " and CentreID=" + Util.GetInt(CentreID) + " ");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                                sb1 = new StringBuilder();
                                sb1.Append("Insert into f_ratelist_ipd(Location,HospCode,Rate,IsCurrent,ItemID,PanelID,IPDCaseTypeID,ItemDisplayName,ItemCode,ScheduleChargeID,UserID,IpAddress,RateCurrencyCountryID,CentreID)");
                                sb1.Append("Select 'L','SHHI'," + Rate + ",'" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "',");
                                sb1.Append("'" + ((Label)gRow.FindControl("lblItemID")).Text + "'," + PanelID + ",icm.Description,");
                                sb1.Append("'" + ((TextBox)gRow.FindControl("txtItemDisplay")).Text.Trim() + "',");
                                sb1.Append("'" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',");
                                sb1.Append("'" + ScheduleChargeID + "','" + ViewState["UserID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + rateCurrencyCountryID + "," + Util.GetInt(CentreID) + " from (Select (REPLACE(Description,'LSHHI','')+0)Description from f_subcategorymaster ");//Description
                                sb1.Append(" sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID Where cf.ConfigID=2 and sc.Active=1) icm  ");

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb1.ToString());
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "update f_ratelist_ipd set RatelistID = CONCAT(location,HospCode,id) where RatelistID is null or RatelistID=''");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");

                            }
                        }
                    }
                }
                else
                {
                    foreach (GridViewRow gRow in grdItemIPD.Rows)
                    {
                        foreach (string CentreID in strCentre)
                        {
                            string IPDCaseTypeID = ((Label)gRow.FindControl("lblCaseTypeID")).Text.ToString();
                            int rateCurrencyCountryID = Util.GetInt(((DropDownList)gRow.FindControl("ddlRateCurrency")).SelectedItem.Value);

                            if (IPDCaseTypeID == "")
                                IPDCaseTypeID = cmbCaseType.SelectedItem.Value;

                            sb = new StringBuilder();
                            sb.Append("Update f_ratelist_ipd Set IsCurrent=0 Where ItemID = '" + ((Label)gRow.FindControl("lblItemID")).Text + "' ");
                            sb.Append("and PanelID = " + PanelID + " and IPDCaseTypeID='" + IPDCaseTypeID + "' ");
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                            RateListIPD objRateList = new RateListIPD(Tnx);
                            objRateList.PanelID = PanelID;
                            objRateList.ItemID = ((Label)gRow.FindControl("lblItemID")).Text;
                            objRateList.Rate = Util.GetDecimal(((TextBox)gRow.FindControl("txtRate")).Text.Trim());
                            objRateList.IsTaxable = Util.GetInt("0");
                            objRateList.FromDate = DateTime.Now;
                            objRateList.ToDate = DateTime.Now;
                            objRateList.IsCurrent = Util.GetInt(((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue);
                            objRateList.IsService = "YES";
                            if (((TextBox)gRow.FindControl("txtItemDisplay")).Text.Trim() != "")
                                objRateList.ItemDisplayName = ((TextBox)gRow.FindControl("txtItemDisplay")).Text.Trim();
                            else
                                objRateList.ItemDisplayName = ((Label)gRow.FindControl("lblItemNameIPD")).Text.Trim();
                            objRateList.ItemCode = ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim();
                            objRateList.IPDCaseTypeID = IPDCaseTypeID;
                            objRateList.ScheduleChargeID = ScheduleChargeID;
                            objRateList.UserID = ViewState["UserID"].ToString();
                            objRateList.IPAddress = All_LoadData.IpAddress();
                            objRateList.Insert();
                        }
                    }
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");

                }
            }

            Tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();
            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            ddlCategory.SelectedIndex = 0;
            LoadSubCategory(ddlCategory.SelectedValue);
            LoadItems();
            txtCodeSearch.Text = "";
            txtSearchName.Text = "";
            pnlHide.Visible = false;
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            pnlHide.Visible = true;
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadSubCategory(ddlCategory.SelectedValue);
    }

    protected void ddlPanelCompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindScheduleChage();
        BindCentre();
        grdItemIPD.DataSource = null;
        grdItemIPD.DataBind();
        grdItemOPD.DataSource = null;
        grdItemOPD.DataBind();
        ShowRates();
    }

    protected void ddlScheduleCharge_SelectedIndexChanged(object sender, EventArgs e)
    {
        grdItemIPD.DataSource = null;
        grdItemIPD.DataBind();
        grdItemOPD.DataSource = null;
        grdItemOPD.DataBind();
        ShowRates();
    }

    protected void rbtActive_SelectedIndexChanged(object sender, EventArgs e)
    {
        grdItemIPD.DataSource = null;
        grdItemIPD.DataBind();
        grdItemOPD.DataSource = null;
        grdItemOPD.DataBind();
        ShowRates();
    }

    protected void rdbDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadCategory();
        ClearFields();

        if (rdbDept.SelectedValue == "0")
        {
            chkRoomType.Visible = false;
            cmbCaseType.Visible = false;
            LoadPanelOPD();
            grdItemIPD.Visible = false;
            grdItemOPD.Visible = true;
            chkToAllRooms.Visible = false;
        }
        else
        {
            chkRoomType.Visible = true;
            cmbCaseType.Visible = true;
            LoadPanelIPD();
            grdItemIPD.Visible = true;
            grdItemOPD.Visible = false;
            chkToAllRooms.Visible = true;
        }
    }

    private void BindScheduleChage()
    {
        string str = "SELECT * FROM f_rate_schedulecharges where PanelID= " + ddlPanelCompany.SelectedItem.Value + " AND isdefault=1";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlScheduleCharge.DataSource = dt;
            ddlScheduleCharge.DataTextField = "NAME";
            ddlScheduleCharge.DataValueField = "ScheduleChargeID";
            ddlScheduleCharge.DataBind();
            ddlScheduleCharge.SelectedIndex = ddlScheduleCharge.Items.IndexOf(ddlScheduleCharge.Items.FindByValue(Util.GetString(dt.Select("IsDefault=1")[0]["ScheduleChargeID"])));
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Schedule Of Charges not found. </br> Set schedule of charges of selected panel');", true);
            btnSave.Enabled = false;
        }
    }

    private void CaseTypeBind()
    {
        try
        {
            cmbCaseType.DataSource = AllLoadData_IPD.LoadCaseType();
            cmbCaseType.DataTextField = "Name";
            cmbCaseType.DataValueField = "IPDCaseTypeID";
            cmbCaseType.DataBind();
            cmbCaseType.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void ClearFields()
    {
        txtSearchName.Text = "";
        txtCodeSearch.Text = "";
        lstItem.Items.Clear();
        grdItemOPD.DataSource = null;
        grdItemOPD.DataBind();
        grdItemIPD.DataSource = null;
        grdItemIPD.DataBind();
        pnlHide.Visible = false;
    }

    private void LoadCategory()
    {
        string str = "";
        str = "Select cm.Name,cm.CategoryID from f_categorymaster cm inner join f_configrelation cf on cm.categoryid = cf.categoryid where cf.ConfigID in ";

        if (rdbDept.SelectedValue == "0")
        {
            str = str + "(3,5,7,25,23,20)";
            chkToAllRooms.Visible = false;
        }
        else
        {
            str = str + "(1,2,3,6,7,8,9,10,20,14,15,24,25,27,29,30)";
            chkToAllRooms.Visible = true;
        }

        str = str + " group by cm.CategoryID order by cm.Name";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.SelectedIndex = 0;

            LoadSubCategory(ddlCategory.SelectedValue);
        }
    }

    private void LoadItems()
    {
        lblMsg.Text = "";
        lstItem.Items.Clear();

        StringBuilder str = new StringBuilder();
        str.Append("Select   CONCAT(IFNULL(im.ItemCode,''),'#',im.TypeName)TypeName,im.ItemID ");
        str.Append("from f_categorymaster cm inner join  f_subcategorymaster sc on cm.CategoryID = sc.CategoryID ");
        str.Append("inner join f_itemmaster im on im.SubCategoryID = sc.SubCategoryID Where im.IsActive=1 ");

        if (chkCat.Checked)
            str.Append("and cm.CategoryID ='" + ddlCategory.SelectedValue + "' ");
        if (chkSubCat.Checked)
            str.Append("and sc.SubCategoryID ='" + ddlSubCategory.SelectedValue + "' ");
        if (chkItemSearch.Checked)
        {
            if (rbtItemChar.SelectedValue == "0")
                str.Append("and im.TypeName like '%" + txtSearchName.Text.Trim() + "%' ");
            else
                str.Append("and im.TypeName like '%" + txtSearchName.Text.Trim() + "%' ");
        }
        if (chkCodeSearch.Checked == true)
        {
            if (txtCodeSearch.Text != "")
            {
                str.Append("and im.ItemCode like '%" + txtCodeSearch.Text.Trim() + "' ");
            }
        }

        str.Append("order by sc.Name,im.TypeName");
        DataTable dt = StockReports.GetDataTable(str.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lstItem.DataSource = dt;
            lstItem.DataTextField = "TypeName";
            lstItem.DataValueField = "ItemID";
            lstItem.DataBind();
            lstItem.SelectedIndex = 0;
        }
        else
        {
            lblMsg.Text = "No Item Found";
        }
    }

    private void LoadPanelIPD()
    {
        ddlPanelCompany.DataSource = CreateStockMaster.LoadPanelCompanyRef();
        ddlPanelCompany.DataTextField = "Company_Name";
        ddlPanelCompany.DataValueField = "PanelID";
        ddlPanelCompany.DataBind();
        ddlPanelCompany.SelectedIndex = 1;//ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByText(AllGlobalFunction.Panel.ToString()));
        BindScheduleChage();
        BindCentre();
    }

    private void LoadPanelOPD()
    {
        ddlPanelCompany.DataSource = CreateStockMaster.LoadPanelCompanyRefOPD();
        ddlPanelCompany.DataTextField = "Company_Name";
        ddlPanelCompany.DataValueField = "PanelID";
        ddlPanelCompany.DataBind();
        ddlPanelCompany.SelectedIndex = 1;//ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(Resources.Resource.DefaultPanelGroupID.ToString()));
        BindScheduleChage();
        BindCentre();
    }

    private void LoadRates(string ItemIDs)
    {
        string PanelID = ddlPanelCompany.SelectedValue;

        int ActiveRate = 0;

        if (rbtActive.SelectedValue == "1")
            ActiveRate = 1;

        string RoomType = "";

        StringBuilder sb = new StringBuilder();

        // OPDs..............
        if (rdbDept.SelectedValue == "0")
        {
            sb.Append("Select CatName,SubCatName,ItemName,CategoryId,SubcategoryId,ItemID, ");
            sb.Append("if(ID is null,'',ID)ID,if(ID is null,'',Rate)Rate,if(ID is null,'',PanelID)PanelID,if(ID is null,'',ItemDisplayName)ItemDisplayName, ");
            sb.Append("if(ID is null,'',ItemCode)ItemCode,IFNULL(IsCurrent,1)IsCurrent,IF(RateCurrencyCountryID IS NULL,PanelRateCurrencyCountryID,RateCurrencyCountryID)  RateCurrencyCountryID from ");
            sb.Append("(Select t.*,rl.ID,rl.Rate,rl.PanelID,rl.ItemDisplayName,rl.ItemCode,rl.IsCurrent,  pm.RateCurrencyCountryID PanelRateCurrencyCountryID,rl.RateCurrencyCountryID from  ");
            sb.Append("(Select sc.Name SubCatName,sc.SubcategoryId,cm.Name CatName,cm.CategoryId,im.ItemID,im.ItemName from  ");
            sb.Append("(Select ItemID,TypeName ItemName,subcategoryid from f_itemmaster  ");
            sb.Append("where ItemId in (" + ItemIDs + ")) im inner join f_subcategorymaster sc on ");
            sb.Append("sc.subCategoryID = im.subcategoryid inner join f_categorymaster cm on ");
            sb.Append("sc.CategoryID = cm.CategoryID) t   ");
            sb.Append("INNER JOIN f_panel_master pm ON pm.PanelID=" + PanelID + " ");
            sb.Append("left join f_ratelist rl on t.ItemId = rl.ItemId  ");
            sb.Append("and rl.PanelID=" + PanelID + " and rl.IsCurrent = " + ActiveRate + " ");
            sb.Append(" and rl.ScheduleChargeID='" + ddlScheduleCharge.SelectedItem.Value + "' and rl.CentreID="+Util.GetInt(ddlCentre.SelectedValue)+"");

            sb.Append(" ) t2 ");

            sb.Append("order by CatName,SubCatName,ItemName");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                grdItemOPD.DataSource = dt;
                grdItemOPD.DataBind();
                pnlHide.Visible = true;
            }
            else
            {
                grdItemOPD.DataSource = null;
                grdItemOPD.DataBind();
                pnlHide.Visible = false;
            }
        }
        else
        {
            if (chkRoomType.Checked)
            {
                foreach (ListItem li in cmbCaseType.Items)
                {
                    if (RoomType == "")
                        RoomType = "'" + li.Value.ToString() + "'";
                    else
                        RoomType = RoomType + ",'" + li.Value.ToString() + "'";
                }
            }

            sb.Append("Select CatName,SubCatName,ItemName,CategoryId,SubcategoryId,ItemID, ");
            sb.Append("if(t2.ID is null,'',t2.ID)ID,if(t2.ID is null,'',Rate)Rate,if(t2.ID is null,'',PanelID)PanelID,if(t2.ID is null,'',ItemDisplayName)ItemDisplayName, ");
            sb.Append("if(t2.ID is null,'',ItemCode)ItemCode,IFNULL(IsCurrent,1)IsCurrent ");
            sb.Append(",if(t2.ID is null,icm.IPDCaseTypeID,t2.IPDCaseTypeID)IPDCaseTypeID,icm.Name RoomType ,IF(RateCurrencyCountryID IS NULL,PanelRateCurrencyCountryID,RateCurrencyCountryID)  RateCurrencyCountryID from");
            sb.Append("(Select t.*,rl.ID,rl.Rate,rl.PanelID,rl.ItemDisplayName,rl.ItemCode,rl.IsCurrent,rl.IPDCaseTypeID, pm.RateCurrencyCountryID PanelRateCurrencyCountryID,rl.RateCurrencyCountryID from ");
            sb.Append("(Select sc.Name SubCatName,sc.SubcategoryId,cm.Name CatName,cm.CategoryId,im.ItemID,im.ItemName from  ");
            sb.Append("(Select ItemID,TypeName ItemName,subcategoryid from f_itemmaster  ");
            sb.Append("where ItemId in (" + ItemIDs + ")) im inner join f_subcategorymaster sc on ");
            sb.Append("sc.subCategoryID = im.subcategoryid inner join f_categorymaster cm on ");
            sb.Append("sc.CategoryID = cm.CategoryID) t   ");
            sb.Append("INNER JOIN f_panel_master pm ON pm.PanelID=" + PanelID + " ");
            sb.Append("left join f_ratelist_IPD rl on t.ItemId = rl.ItemId  ");
            sb.Append("and rl.PanelID=" + PanelID + " and rl.IsCurrent = " + ActiveRate + " ");
            sb.Append("and rl.ScheduleChargeID='" + ddlScheduleCharge.SelectedItem.Value + "' ");

            if (RoomType != "")
                sb.Append(" and IPDCaseTypeID in (" + RoomType + ")");
            else
                sb.Append(" and IPDCaseTypeID in ('" + cmbCaseType.SelectedValue + "')");
            sb.Append("  and centreid='"+ddlCentre.SelectedValue.ToString()+"') t2 ");
            sb.Append(" left join ipd_case_type_master icm on icm.IPDCaseTypeID = t2.IPDCaseTypeID order by CatName,SubCatName,ItemName");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                grdItemIPD.DataSource = dt;
                grdItemIPD.DataBind();
                pnlHide.Visible = true;
            }
            else
            {
                grdItemIPD.DataSource = null;
                grdItemIPD.DataBind();
                pnlHide.Visible = false;
            }
        }
    }

    private void LoadSubCategory(string CategoryID)
    {
        string str = "Select Name,SubCategoryID from f_Subcategorymaster where CategoryID ='" + CategoryID + "' and Active=1 order by Name";

        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "SubCategoryID";
            ddlSubCategory.DataBind();
            ddlSubCategory.SelectedIndex = 0;
        }
        else
        {
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "SubCategoryID";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Clear();
        }
    }

    private void ShowRates()
    {
        string ItemIDs = "";
        foreach (ListItem li in lstItem.Items)
        {
            if (li.Selected)
            {
                if (ItemIDs == "")
                    ItemIDs = "'" + li.Value + "'";
                else
                    ItemIDs = ItemIDs + ",'" + li.Value + "'";
            }
        }

        if (ItemIDs != "")
            LoadRates(ItemIDs);
        else
            lblMsg.Text = "Please Select Item to Show Rates";
    }
    
    private void BindPanelCurrency(DropDownList ddlCurrency, string rateCurrencyCountryID)
    {

        DataTable dt = ViewState["currencyDataTable"] as DataTable;
        ddlCurrency.DataSource = dt;
        ddlCurrency.DataTextField = "CurrencyName";
        ddlCurrency.DataValueField = "CountryID";
        ddlCurrency.DataBind();
        ddlCurrency.SelectedIndex = 0;
        //DataView dv = dt.AsDataView();
        //dv.RowFilter = "IsBaseCurrency=1";
        //DataTable _temp = dv.ToTable();
        ////if (_temp.Rows.Count > 0)
        ddlCurrency.SelectedIndex = ddlCurrency.Items.IndexOf(ddlCurrency.Items.FindByValue(rateCurrencyCountryID));


    }
    protected void grdItemIPD_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddlCurrency = (DropDownList)e.Row.FindControl("ddlRateCurrency");
            string rateCurrencyCountryID = Util.GetString(DataBinder.Eval(e.Row.DataItem, "RateCurrencyCountryID"));
            BindPanelCurrency(ddlCurrency, rateCurrencyCountryID);
        }
    }
    protected void grdItemOPD_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddlCurrency = (DropDownList)e.Row.FindControl("ddlRateCurrency");
            string rateCurrencyCountryID =Util.GetString(DataBinder.Eval(e.Row.DataItem, "RateCurrencyCountryID"));
            BindPanelCurrency(ddlCurrency, rateCurrencyCountryID);
        }
    }


    private void BindCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE fcp.isActive=1  AND fcp.PanelID='" + ddlPanelCompany.SelectedValue.ToString() + "' ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        ddlCentre.DataSource = dtCentre;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Util.GetString(dtCentre.Select("IsDefault=1")[0]["CentreID"])));
    }

    private void BindModelCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE fcp.isActive=1  AND fcp.PanelID='" + ddlPanelCompany.SelectedValue.ToString() + "' ";
        DataTable dt = StockReports.GetDataTable(str);
        chkCentre.DataSource = dt;
        chkCentre.DataTextField = "CentreName";
        chkCentre.DataValueField = "CentreID";
        chkCentre.DataBind();
    }
    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        ShowRates();
    }
}