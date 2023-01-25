using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_SurgeryRates : System.Web.UI.Page
{
    protected void btnLoadItem_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (chkSubCat.Checked == false && chkItemSearch.Checked == false)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM181','" + lblMsg.ClientID + "');", true);
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
            string ItemID = "";
            string Centre = "";
            Centre = ddlCentre.SelectedValue.ToString();
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

            if (rdbDept.SelectedValue == "0")
            {
                foreach (GridViewRow gRow in grdItemOPD.Rows)
                {
                    foreach (string CentreID in strCentre)
                    {
                        if (((Label)gRow.FindControl("lblID")).Text == "")
                        {
                            ItemID = ((Label)gRow.FindControl("lblSurgery_ID")).Text;
                            string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                            if (Rate == "")
                                Rate = "0";

                            decimal SurgeonRate = Util.GetDecimal(((TextBox)gRow.FindControl("txtSurgeonRate")).Text);
                            StringBuilder sb = new StringBuilder();
                            sb.Append("INSERT INTO f_surgery_rate_list_OPD(Surgery_ID,PanelID,Rate,SurgeonRate,PanelCode,IsCurrent,DateFrom,UserID,IPAddress,CentreID)");
                            sb.Append("VALUES('" + ItemID + "'," + PanelID + "," + Rate + "," + SurgeonRate + ",'" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "','" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + Util.GetInt(CentreID) + ")");

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                        }
                        else  // Update Old Rates
                        {
                            string strQuery = "update  f_surgery_rate_list_OPD set Rate = " + ((TextBox)gRow.FindControl("txtRate")).Text.Trim() + ",SurgeonRate = " + ((TextBox)gRow.FindControl("txtSurgeonRate")).Text + ",PanelCode='" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',IsCurrent='" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "' where ID = " + ((Label)gRow.FindControl("lblID")).Text;
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);
                        }
                    }
                }
            }
            else
            {
                StringBuilder sb = new StringBuilder();

                if (chkToAllRooms.Checked)
                {
                    if (rbtRateType.SelectedValue == "1") // Insert New Rates
                    {
                        foreach (GridViewRow gRow in grdItemIPD.Rows)
                        {
                            foreach (string CentreID in strCentre)
                            {
                                if (((Label)gRow.FindControl("lblSurgery_ID")).Text != ItemID)
                                {
                                    ItemID = ((Label)gRow.FindControl("lblSurgery_ID")).Text;
                                    string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                                    if (Rate == "") Rate = "0";
                                    decimal SurgeonRate = Util.GetDecimal(((TextBox)gRow.FindControl("txtSurgeonRate")).Text);
                                    sb = new StringBuilder();
                                    sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,SurgeonRate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,UserID,ScheduleChargeID,IPAddress,CentreID)");
                                    sb.Append("Select '" + ItemID + "'," + Rate + "," + SurgeonRate + ",");
                                    sb.Append(" " + PanelID + ",icm.IPDCaseType_ID,'" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',");
                                    sb.Append("'" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "',");
                                    sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "'," + ScheduleChargeID + ",'" + All_LoadData.IpAddress() + "'," + Util.GetInt(CentreID) + " from (Select IPDCaseType_ID from ipd_case_type_master Where IsActive=1) icm ");

                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
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
                                if (((Label)gRow.FindControl("lblSurgery_ID")).Text != ItemID)
                                {
                                    ItemID = ((Label)gRow.FindControl("lblSurgery_ID")).Text;

                                    string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                                    if (Rate == "") Rate = "0";
                                    decimal SurgeonRate = Util.GetDecimal(((TextBox)gRow.FindControl("txtSurgeonRate")).Text);
                                    sb = new StringBuilder();
                                    sb.Append("Delete from f_surgery_rate_list Where Surgery_ID = '" + ((Label)gRow.FindControl("lblSurgery_ID")).Text + "' ");
                                    sb.Append("and PanelID = " + PanelID + " and CentreID=" + Util.GetInt(CentreID) + "");
                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                                    sb = new StringBuilder();

                                    sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,SurgeonRate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,UserID,ScheduleChargeID,IPAddress,CentreID)");
                                    sb.Append("Select '" + ItemID + "'," + Rate + "," + SurgeonRate + ",");
                                    sb.Append(" " + PanelID + ",icm.IPDCaseType_ID,'" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',");
                                    sb.Append("'" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "',");
                                    sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "'," + ScheduleChargeID + ",'" + All_LoadData.IpAddress() + "'," + Util.GetInt(CentreID) + " from (Select IPDCaseType_ID from ipd_case_type_master Where IsActive=1) icm ");

                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (rbtRateType.SelectedValue != "0")
                    {
                        foreach (GridViewRow gRow in grdItemIPD.Rows)
                        {
                            foreach (string CentreID in strCentre)
                            {
                                if (((Label)gRow.FindControl("lblSurgery_ID")).Text != ItemID)
                                {
                                    ItemID = ((Label)gRow.FindControl("lblSurgery_ID")).Text;
                                    string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                                    if (Rate == "") Rate = "0";
                                    decimal SurgeonRate = Util.GetDecimal(((TextBox)gRow.FindControl("txtSurgeonRate")).Text);
                                    sb = new StringBuilder();
                                    sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,SurgeonRate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,ScheduleChargeID,UserID,IpAddress,CentreId)");
                                    sb.Append("Values( '" + ItemID + "'," + Util.GetDouble(((TextBox)gRow.FindControl("txtRate")).Text.Trim()) + "," + SurgeonRate + ",");
                                    sb.Append(" " + PanelID + ",'" + ((Label)gRow.FindControl("lblCaseTypeID")).Text + "','" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',");
                                    sb.Append("'" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "',");
                                    sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + ScheduleChargeID + "','" + Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + Util.GetInt(CentreID) + ")");

                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
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
                                // Deleting OLD rates for updating/inserting rates
                                if (((Label)gRow.FindControl("lblSurgery_ID")).Text != ItemID)
                                {
                                    ItemID = ((Label)gRow.FindControl("lblSurgery_ID")).Text;

                                    string Rate = ((TextBox)gRow.FindControl("txtRate")).Text.Trim();
                                    if (Rate == "") Rate = "0";
                                    decimal SurgeonRate = Util.GetDecimal(((TextBox)gRow.FindControl("txtSurgeonRate")).Text);
                                    sb = new StringBuilder();
                                    sb.Append("Delete from f_surgery_rate_list Where Surgery_ID = '" + ((Label)gRow.FindControl("lblSurgery_ID")).Text + "' ");
                                    sb.Append("and PanelID = " + PanelID + " and IPDCaseType_ID='" + ((Label)gRow.FindControl("lblCaseTypeID")).Text + "' and CentreID=" + Util.GetInt(CentreID) + "");
                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                                    sb = new StringBuilder();

                                    sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,SurgeonRate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,UserID,IPAddress,CentreID)");
                                    sb.Append("Values( '" + ItemID + "'," + Util.GetDouble(((TextBox)gRow.FindControl("txtRate")).Text.Trim()) + "," + SurgeonRate + ",");
                                    sb.Append(" " + PanelID + ",'" + ((Label)gRow.FindControl("lblCaseTypeID")).Text + "','" + ((TextBox)gRow.FindControl("txtItemCode")).Text.Trim() + "',");
                                    sb.Append("'" + ((RadioButtonList)gRow.FindControl("rbtActive")).SelectedValue + "',");
                                    sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + Util.GetInt(CentreID) + ")");

                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                                }
                            }
                        }
                    }
                }
            }

            Tnx.Commit();
          
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();
            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
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
        // LoadCategory();
    }

    protected void ddlPanelCompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindScheduleChage();
        BindCentre();
        if (rbtRateType.SelectedValue == "0")
        {
            rbtActive.Visible = true;

            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
        else
        {
            rbtActive.Visible = false;

            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
    }

    protected void ddlScheduleCharge_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtRateType.SelectedValue == "0")
        {
            rbtActive.Visible = true;

            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
        else
        {
            rbtActive.Visible = false;

            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanelIPD();
            BindScheduleChage();
            LoadsubCategory();
            CaseTypeBind();
            BindModelCentre();
            ViewState["UserID"] = Session["ID"].ToString();
        }
        rdbDept.Items[0].Attributes.Add("style", "display:none");
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
    protected void rbtActive_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtActive.SelectedValue == "0")
        {
            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
        else
        {
            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
    }

    protected void rbtRateType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtRateType.SelectedValue == "0")
        {
            rbtActive.Visible = true;

            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
        else
        {
            rbtActive.Visible = false;

            grdItemIPD.DataSource = null;
            grdItemIPD.DataBind();
            grdItemOPD.DataSource = null;
            grdItemOPD.DataBind();

            ShowRates();
        }
    }

    protected void rdbDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        //LoadCategory();
        ClearFields();

        if (rdbDept.SelectedValue == "0")
        {
            LoadPanelOPD();
            grdItemIPD.Visible = false;
            grdItemOPD.Visible = true;
        }
        else
        {
            LoadPanelIPD();
            grdItemIPD.Visible = true;
            grdItemOPD.Visible = false;
        }
    }

    private void BindScheduleChage()
    {
        string str = "SELECT * FROM f_rate_schedulecharges where PanelID=" + ddlPanelCompany.SelectedItem.Value + " AND isdefault=1";
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
            string sql = "select Name,IPDCaseType_ID from ipd_case_type_master ";
            cmbCaseType.DataSource = StockReports.GetDataTable(sql);
            cmbCaseType.DataTextField = "Name";
            cmbCaseType.DataValueField = "IPDCaseType_ID";
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
        lstItem.Items.Clear();
        grdItemOPD.DataSource = null;
        grdItemOPD.DataBind();
    }

    private void LoadItems()
    {
        lstItem.Items.Clear();
        StringBuilder str = new StringBuilder();
        str.Append("Select Concat(Name,' # ',ifnull(SurgeryCode,''))Name ,Surgery_ID from f_surgery_master where Surgery_ID <>'' ");

        if (chkSubCat.Checked)
            str.Append("and Department ='" + ddlSubCategory.SelectedItem.Text.Trim() + "' ");

        if (chkItemSearch.Checked)
        {
            if (rbtItemChar.SelectedValue == "0")
                str.Append("and Name like '" + txtSearchName.Text.Trim() + "%' ");
            else
                str.Append("and Name like '%" + txtSearchName.Text.Trim() + "%' ");
        }

        str.Append("order by Name ");
        DataTable dt = StockReports.GetDataTable(str.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lstItem.DataSource = dt;
            lstItem.DataTextField = "Name";
            lstItem.DataValueField = "Surgery_ID";
            lstItem.DataBind();
            lstItem.SelectedIndex = 0;
        }
    }

    private void LoadPanelIPD()
    {
        ddlPanelCompany.DataSource = CreateStockMaster.LoadPanelCompanyRef();
        //ddlPanelCompany.DataSource = CreateStockMaster.LoadPanelCompany();
        ddlPanelCompany.DataTextField = "Company_Name";
        ddlPanelCompany.DataValueField = "PanelID";
        ddlPanelCompany.DataBind();
        ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByText(AllGlobalFunction.Panel.ToString()));
        BindCentre();
    }

    private void LoadPanelOPD()
    {
        ddlPanelCompany.DataSource = CreateStockMaster.LoadPanelCompanyRefOPD();
        ddlPanelCompany.DataTextField = "Company_Name";
        ddlPanelCompany.DataValueField = "PanelID";
        ddlPanelCompany.DataBind();
        ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByText(AllGlobalFunction.Panel.ToString()));
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
            sb.Append("Select Surgery_ID,Department,IsActive,SurgeryName,SurgeryCode, ");
            sb.Append("if(ID is null,'',ID)ID,if(ID is null,'',Rate)Rate,IF(ID IS NULL,'',surgeonRate)surgeonRate,if(ID is null,'',PanelID)PanelID,ifnull(IsCurrent,1)IsCurrent from  ");
            sb.Append("(Select t.*,rl.ID,rl.Rate,rl.surgeonRate,rl.PanelID,rl.IsCurrent from  ");
            sb.Append("(SELECT Surgery_ID,Department,IsActive,Name SurgeryName,SurgeryCode ");
            sb.Append("FROM f_surgery_master ");
            sb.Append("where Surgery_ID in (" + ItemIDs + "))t ");

            if (rbtRateType.SelectedValue == "1")
            {
                sb.Append("left join f_surgery_rate_list_OPD rl on t.Surgery_ID = rl.Surgery_ID ");
                sb.Append("and rl.PanelID=" + PanelID + " and rl.IsCurrent = " + ActiveRate+" and rl.CentreID="+Util.GetInt(ddlCentre.SelectedValue)+" ");
                //sb.Append("and rl.ScheduleChargeID='" + ddlScheduleCharge.SelectedItem.Value + "' ");
                sb.Append(" Where rl.ID is null) t2 ");
            }
            else
            {
                sb.Append("inner join f_surgery_rate_list_OPD rl on t.Surgery_ID = rl.Surgery_ID  ");
                //sb.Append("and rl.ScheduleChargeID='" + ddlScheduleCharge.SelectedItem.Value + "' ");
                sb.Append("and rl.PanelID=" + PanelID + " and rl.IsCurrent = " + ActiveRate + " and rl.CentreID=" + Util.GetInt(ddlCentre.SelectedValue) + ") t2 ");
            }
            sb.Append("order by Department,SurgeryName");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                grdItemOPD.DataSource = dt;
                grdItemOPD.DataBind();
            }
            else
            {
                grdItemOPD.DataSource = null;
                grdItemOPD.DataBind();
            }
        }
        else
        {
            if (chkRoomType.Checked)
            {
                foreach (ListItem li in cmbCaseType.Items)
                {
                    if (li.Selected)
                    {
                        if (RoomType == "")
                            RoomType = "'" + li.Value + "'";
                        else
                            RoomType = RoomType + ",'" + li.Value + "'";
                    }
                }
            }

           
            sb.Append("SELECT Surgery_ID,Department,SurgeryName,SurgeryCode,IF(ID IS NULL,'',ID)ID, ");
            sb.Append(" IF(ID IS NULL,'',Rate)Rate,IF(ID IS NULL,'',surgeonRate)surgeonRate,IF(ID IS NULL,'',PanelID)PanelID,IFNULL(IsCurrent,1)IsCurrent ,");
            sb.Append(" IF(t2.IPDCaseType_ID IS NULL,icm.IPDCaseType_ID,t2.IPDCaseType_ID)IPDCaseType_ID,icm.Name RoomType ");
            sb.Append(" FROM(SELECT t.*,rl.Rate,rl.surgeonRate,rl.PanelID,rl.IsCurrent,rl.IPDCaseType_ID FROM ");
            sb.Append(" (SELECT Surgery_ID,Department,NAME SurgeryName,SurgeryCode FROM f_surgery_master ");
            sb.Append(" WHERE Surgery_ID IN (" + ItemIDs + ")) t");

            if (rbtRateType.SelectedValue == "1")
            {
                sb.Append(" LEFT JOIN f_surgery_rate_list rl ON t.Surgery_ID = rl.Surgery_ID ");
                sb.Append(" AND rl.PanelID=" + PanelID + " AND rl.IsCurrent = " + ActiveRate + " ");
                sb.Append("and rl.ScheduleChargeID='" + ddlScheduleCharge.SelectedItem.Value + "' and rl.CentreID=" + Util.GetInt(ddlCentre.SelectedValue) + " ");

                if (RoomType != "")
                    sb.Append(" AND IPDCaseType_ID IN (" + RoomType + ") ");

                sb.Append(" WHERE rl.ID IS NULL ) t2 ");
                if (RoomType != "")
                    sb.Append(" ,(SELECT * FROM ipd_case_type_master WHERE IPDCaseType_ID IN (" + RoomType + ")) icm ORDER BY Department,SurgeryName ");
                else
                    sb.Append(" ,(SELECT * FROM ipd_case_type_master WHERE isActive=1)icm ORDER BY Department,SurgeryName ");
            }
            else
            {
                sb.Append(" inner join f_surgery_rate_list rl on t.Surgery_ID = rl.Surgery_ID  ");
                sb.Append(" and rl.PanelID=" + PanelID + " and rl.IsCurrent = " + ActiveRate + "  ");
                sb.Append("and rl.ScheduleChargeID='" + ddlScheduleCharge.SelectedItem.Value + "' and rl.CentreID=" + Util.GetInt(ddlCentre.SelectedValue) + " ");

                if (RoomType != "")
                    sb.Append(" and IPDCaseType_ID in (" + RoomType + ")");

                sb.Append(")t2 ");
                sb.Append(" inner join ipd_case_type_master icm on icm.IPDCaseType_ID = t2.IPDCaseType_ID order by Department,SurgeryName ");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                grdItemIPD.DataSource = dt;
                grdItemIPD.DataBind();
            }
            else
            {
                grdItemIPD.DataSource = null;
                grdItemIPD.DataBind();
            }
        }
    }

   

    private void LoadsubCategory()
    {
        string str = "SELECT distinct Department from f_surgery_master where isactive=1 order by Name";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataValueField = "Department";
            ddlSubCategory.DataTextField = "Department";
            ddlSubCategory.DataBind();
            ddlSubCategory.SelectedIndex = 0;
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
            lblMsg.Text = "Select Item..";
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
    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        ShowRates();
    }
}