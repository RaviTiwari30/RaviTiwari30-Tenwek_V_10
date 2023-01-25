using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;
using System.Web;
public partial class Design_Doctor_ViewDoctorDetail : System.Web.UI.Page
{
    private DataTable dt = new DataTable();
    protected void btnSave1_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            string IsUpdate = "", Panel = "", IsInsert = "", ItemId;
            if (ddlScheduleCharge.Text == string.Empty)
            {
                lblMsg.Text = "Please First Create scheduleCharge";
                return;
            }
            string Centre = "";
            Centre = ddlCentre.SelectedValue.ToString();
            foreach (ListItem li in chkCentre.Items)
            {
                if (li.Selected)
                {
                    if (Centre != string.Empty)
                        Centre += "," + li.Value + "";
                    else
                        Centre = "," + li.Value + "";
                }
            }
            if (Centre == string.Empty)
            {
                lblMsg.Text = "Please Select Centre";
                return;
            }
            string[] strCentre = Centre.Split(',');
            if (rdbOPD.Checked == true)
            {
                //Type = "OPD";

                for (int i = 0; i < GridView2.Rows.Count; i++)
                {
                    foreach (string CentreID in strCentre)
                    {
                        string ScheduleChargeID = Util.GetString(((Label)GridView2.Rows[i].FindControl("lblSchedulecharge")).Text.Trim());
                        string RateId = ((Label)GridView2.Rows[i].FindControl("lblRateID")).Text.Trim();
                        decimal Rate = Util.GetDecimal(((TextBox)GridView2.Rows[i].FindControl("txtRate")).Text);
                        ItemId = ((Label)GridView2.Rows[i].FindControl("lblItemID")).Text;
                        bool IsCheck = ((CheckBox)GridView2.Rows[i].FindControl("chkSelect")).Checked;
                        bool IsKiosk = ((CheckBox)GridView2.Rows[i].FindControl("chkKiosk")).Checked;
                        bool IsGeneral = ((CheckBox)GridView2.Rows[i].FindControl("chkGeneral")).Checked;
                        //string ItemCode = ((TextBox)GridView2.Rows[i].FindControl("txtItemCode")).Text.Trim();

                        if (ScheduleChargeID == "0")
                            ScheduleChargeID = ddlScheduleCharge.SelectedItem.Value;

                        Panel = cmbPanel.SelectedItem.Value.Split('#')[1].ToString();
                        if (IsKiosk == true && IsGeneral == false)
                        {
                            AllUpdate AU = new AllUpdate();
                            AU.UpdateItemMaster(ItemId, 1);
                        }
                        else if (IsKiosk == false && IsGeneral == true)
                        {
                            AllUpdate AU = new AllUpdate();
                            AU.UpdateItemMaster(ItemId, 2);
                        }
                        else if (IsKiosk == true && IsGeneral == true)
                        {
                            AllUpdate AU = new AllUpdate();
                            AU.UpdateItemMaster(ItemId, 3);
                        }
                        else
                        {
                            AllUpdate AU = new AllUpdate();
                            AU.UpdateItemMaster(ItemId, 0);
                        }

                        if (RateId != string.Empty)
                        {
                            if (IsCheck)
                            {
                                StockReports.ExecuteDML("Update f_ratelist set isCurrent=0 where ItemID='" + ItemId + "' and PanelID=" + Panel + " and ScheduleChargeID='" + ScheduleChargeID + "'  and CentreID=" + Util.GetInt(CentreID) + " ");
                                IsInsert = CreateStockMaster.UpdateRatelist("INSERT", Rate, RateId, ItemId, Panel, ScheduleChargeID,CentreID);
                            }
                            else
                            {
                                IsUpdate = CreateStockMaster.UpdateRatelist("Delete", Rate, RateId, ItemId, Panel, ScheduleChargeID,CentreID);
                            }
                        }

                        if (RateId == "")
                        {
                            ScheduleChargeID = Util.GetString(ddlScheduleCharge.SelectedValue);
                            if (IsCheck)
                            {
                                StockReports.ExecuteDML("Update f_ratelist set iscurrent=0 where ItemID='" + ItemId + "' and PanelID=" + Panel + " and ScheduleChargeID='" + ScheduleChargeID + "' and CentreID=" + Util.GetInt(CentreID) + "");
                                IsUpdate = CreateStockMaster.UpdateRatelist("Insert", Rate, "", ItemId, Panel, ScheduleChargeID,CentreID);
                            }
                        }
                    }
                }
                if (IsUpdate == "1" || IsInsert == "1")
                {
                    lblMsg.Text = "Record Saved Successfully";
                    GridView2.DataSource = null;
                    GridView2.DataBind();
                    Panel1.Visible = false;
                    btnSave.Visible = false;
                }
                else
                {
                    lblMsg.Text = "Record Not Saved";
                    Panel1.Visible = false;
                    btnSave.Visible = false;
                }
            }
            if (rdbIPD.Checked == true)
            {
                string Case = ViewState["CaseType"].ToString();
                for (int i = 0; i < GridView2.Rows.Count; i++)
                {
                    foreach (string CentreID in strCentre)
                    {
                        string ScheduleChargeID = Util.GetString(((Label)GridView2.Rows[i].FindControl("lblSchedulecharge")).Text.Trim());
                        string RateId = ((Label)GridView2.Rows[i].FindControl("lblRateID")).Text.Trim();
                        decimal Rate = Util.GetDecimal(((TextBox)GridView2.Rows[i].FindControl("txtRate")).Text);
                        string Displayname = lblDName.Text;
                        bool IsCheck = ((CheckBox)GridView2.Rows[i].FindControl("chkSelect")).Checked;
                        Panel = cmbPanel.SelectedItem.Value.Split('#')[1].ToString();
                        ItemId = ((Label)GridView2.Rows[i].FindControl("lblItemID")).Text;
                        //string ItemCode = ((TextBox)GridView2.Rows[i].FindControl("txtItemCode")).Text.Trim();

                        if (ScheduleChargeID == "0")
                            ScheduleChargeID = ddlScheduleCharge.SelectedItem.Value;

                        //Putting Rate for All RoomTypes

                        if (ChkAllRoom.Checked == true)
                        {
                            string SubCategoryID = ((Label)GridView2.Rows[i].FindControl("lblSubCategoryID")).Text.Trim();
                            string DoctorID = ((Label)GridView2.Rows[i].FindControl("lblDoctorID")).Text.Trim();
                            string isChecked = "0";

                            if (((CheckBox)GridView2.Rows[i].FindControl("chkIsScheduled")).Checked)
                                isChecked = "1";

                            IsInsert = InsertRateForMultipleRooms(Panel, ItemId, Rate, Displayname, "", ScheduleChargeID, SubCategoryID, DoctorID, isChecked,CentreID);
                        }
                        else
                        {
                            if (RateId == "")
                            {
                                ScheduleChargeID = Util.GetString(ddlScheduleCharge.SelectedValue);
                                if (IsCheck)
                                {
                                    IsInsert = CreateStockMaster.InsertIntoRateList(Case, Panel, ItemId, Rate, "Insert", RateId, Displayname, "", ScheduleChargeID,CentreID);
                                }

                                if (IsInsert == "1")
                                {
                                    string SubCategoryID = ((Label)GridView2.Rows[i].FindControl("lblSubCategoryID")).Text.Trim();
                                    string DoctorID = ((Label)GridView2.Rows[i].FindControl("lblDoctorID")).Text.Trim();
                                    string isChecked = "0";

                                    if (((CheckBox)GridView2.Rows[i].FindControl("chkIsScheduled")).Checked)
                                        isChecked = "1";

                                    string strSchd = "Select DoctorID from f_scheduledconsultant Where SubCategoryID='" + SubCategoryID + "' and DoctorID='" + DoctorID + "' and IsActive=1";
                                    strSchd = StockReports.ExecuteScalar(strSchd);

                                    if (strSchd == "")
                                    {
                                        if (isChecked == "1")
                                        {
                                            strSchd = "Insert into f_scheduledconsultant(SubCategoryID,DoctorID)";
                                            strSchd += "values('" + SubCategoryID + "','" + DoctorID + "')";
                                            StockReports.ExecuteDML(strSchd);
                                        }
                                    }
                                    else
                                    {
                                        strSchd = "Update f_scheduledconsultant Set IsActive=" + isChecked + " Where SubCategoryID='" + SubCategoryID + "' and DoctorID='" + DoctorID + "'  and IsActive=1";
                                        StockReports.ExecuteDML(strSchd);
                                    }
                                }
                            }
                            if (RateId != "")
                            {
                                if (IsCheck)
                                {
                                    IsInsert = CreateStockMaster.InsertIntoRateList(Case, Panel, ItemId, Rate, "Update", RateId, "", "", ScheduleChargeID, CentreID);
                                }

                                if (IsInsert == "1")
                                {
                                    string SubCategoryID = ((Label)GridView2.Rows[i].FindControl("lblSubCategoryID")).Text.Trim();
                                    string DoctorID = ((Label)GridView2.Rows[i].FindControl("lblDoctorID")).Text.Trim();
                                    string isChecked = "0";

                                    if (((CheckBox)GridView2.Rows[i].FindControl("chkIsScheduled")).Checked)
                                        isChecked = "1";

                                    string strSchd = "Select DoctorID from f_scheduledconsultant Where SubCategoryID='" + SubCategoryID + "' and DoctorID='" + DoctorID + "' and IsActive=1";
                                    strSchd = StockReports.ExecuteScalar(strSchd);

                                    if (strSchd == "")
                                    {
                                        if (isChecked == "1")
                                        {
                                            strSchd = "Insert into f_scheduledconsultant(SubCategoryID,DoctorID)";
                                            strSchd += "values('" + SubCategoryID + "','" + DoctorID + "')";
                                            StockReports.ExecuteDML(strSchd);
                                        }
                                    }
                                    else
                                    {
                                        strSchd = "Update f_scheduledconsultant Set IsActive=" + isChecked + " Where SubCategoryID='" + SubCategoryID + "' and DoctorID='" + DoctorID + "'  and IsActive=1";
                                        StockReports.ExecuteDML(strSchd);
                                    }
                                }
                            }
                        }
                    }
                }
                if (IsInsert == "1")
                {
                    lblMsg.Text = "Record Saved Successfully";
                    GridView2.DataSource = null;
                    GridView2.DataBind();
                    Panel1.Visible = false;
                    btnSave.Visible = false;
                    if (ChkAllRoom.Checked)
                        ChkAllRoom.Checked = false;
                }
                else
                {
                    lblMsg.Text = "Record Not Saved";
                    Panel1.Visible = false;
                    btnSave.Visible = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.Equals(ex);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            GridView1.DataSource = null;
            GridView1.DataBind();
            string DName = "", Specialization = "", Deptartment = "";
            if (txtName.Text != "")
            {
                DName = txtName.Text.Trim();
            }
            if (ddlSpecialization.SelectedIndex > 0)
            {
                Specialization = ddlSpecialization.SelectedItem.Text;
            }
            if (ddlDept.SelectedIndex != 0)
            {
                Deptartment = ddlDept.SelectedItem.Value;
            }

            dt = CreateStockMaster.GetDoctorDetail(DName, Specialization, Deptartment);
            if (dt != null && dt.Rows.Count > 0)
            {
                dt.Columns.Add("updateFlag");
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["updateFlag"] = "1";
                }
            }
            if (dt != null && dt.Rows.Count > 0)
            {

                DataView dv = dt.AsDataView();

                if (rdodoctorType.SelectedItem.Value == "0")
                    dv.RowFilter = "IsUnit='" + rdodoctorType.SelectedItem.Value + "'";
                else
                    dv.RowFilter = "IsUnit='" + rdodoctorType.SelectedItem.Value + "'";
                
                GridView1.DataSource = dv.ToTable();
                GridView1.DataBind();

                if (ViewState["dt"] == null)
                {
                    ViewState.Add("dt", dv.ToTable());
                }
                else
                {
                    ViewState["dt"] = dv.ToTable(); ;
                }
                pnlHide.Visible = true;
                Panel1.Visible = false;
            }
            else
            {
                lblMsg.Text = "No Record Found";
                pnlHide.Visible = false;
                Panel1.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            string Type = "", Reference = "", CaseType = "", SubCategory = "";
            string DID = ViewState["DID"] as string;
            string ScheduleChargeID = Util.GetString(ddlScheduleCharge.SelectedValue);

            if (rdbIPD.Checked == true)
            {
                if (cmbCaseType.SelectedIndex != -1)
                {
                    CaseType = cmbCaseType.SelectedItem.Value;
                    ViewState["CaseType"] = CaseType;
                }

                SubCategory = cmbSubCategory.SelectedItem.Value;
            }

            if (rdbOPD.Checked == true)
            {
                Type = "OPD";
                Reference = cmbPanel.SelectedItem.Value.Split('#')[2].ToString();
                GridView2.Columns[3].Visible = false;
            }
            else
            {
                Type = "IPD";
                Reference = cmbPanel.SelectedItem.Value.Split('#')[1].ToString();
                GridView2.Columns[3].Visible = true;
            }
            string CentreID = ddlCentre.SelectedValue.ToString();
            DataTable dt = CreateStockMaster.GetRateList(Type, DID, Reference, SubCategory, CaseType, ScheduleChargeID,CentreID);
            if (dt != null && dt.Rows.Count > 0)
            {
                btnSave.Visible = true;
                GridView2.DataSource = dt;
                GridView2.DataBind();

                for (int i = 0; i < GridView2.Rows.Count; i++)
                {
                    if (((Label)GridView2.Rows[i].FindControl("lblRateID")).Text != "")
                    {
                        ((CheckBox)GridView2.Rows[i].FindControl("chkSelect")).Checked = true;
                    }

                    if (((CheckBox)GridView2.Rows[i].FindControl("chkKiosk")).Text == "1" || ((CheckBox)GridView2.Rows[i].FindControl("chkKiosk")).Text == "3")
                    {
                        ((CheckBox)GridView2.Rows[i].FindControl("chkKiosk")).Checked = true;
                    }

                    if (((CheckBox)GridView2.Rows[i].FindControl("chkGeneral")).Text == "3" || ((CheckBox)GridView2.Rows[i].FindControl("chkGeneral")).Text == "2")
                    {
                        ((CheckBox)GridView2.Rows[i].FindControl("chkGeneral")).Checked = true;
                    }
                }
            }
            else
            {
                lblMsg.Text = "No Record Found";
                GridView2.DataSource = null;
                GridView2.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void cmbPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlScheduleCharge.DataSource = null;
        ddlScheduleCharge.DataBind();
        BindScheduleChage();
        BindCentre();
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;

        if (ViewState["dt"] != null)
        {
            dt = ((DataTable)ViewState["dt"]);
            GridView1.DataSource = dt;
            GridView1.DataBind();
            ViewState["dt"] = dt;
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Panel1.Visible = true;
        GridView2.DataSource = null;
        GridView2.DataBind();     
        lblMsg.Text = "";
        string DoctorID = ((Label)GridView1.SelectedRow.FindControl("lblDID")).Text;      
        lblDName.Text = ((Label)GridView1.SelectedRow.FindControl("lblDoctorName")).Text;
        
        ViewState["DID"] = DoctorID;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                Panel1.Visible = false;
                All_LoadData.bindDocTypeList(cmbDept, 5, "Select");
                All_LoadData.bindDocTypeList(ddlDept, 5, "All");
                All_LoadData.bindDocTypeList(ddlSpecialization, 3, "All");
                BindSubCategory();
                BindCaseType();
                if (rdbIPD.Checked == true)
                    BindPanel();
                else
                    BindPanelOPD();
                BindScheduleChage();
                BindModelCentre();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }

    protected void rdbIPD_CheckedChanged(object sender, EventArgs e)
    {
        GridView2.DataSource = null;
        GridView2.DataBind();
        lblCaseType.Visible = true;
        lblcolan.Visible = true;
        lblSubCat.Visible = false;
        cmbCaseType.Visible = true;
        cmbSubCategory.Visible = false;
        ChkAllRoom.Visible = true;
        BindSubCategory();
        BindCaseType();
        BindPanel();
        BindScheduleChage();
        btnSave.Visible = false;
    }

    protected void rdbOPD_CheckedChanged(object sender, EventArgs e)
    {
        GridView2.DataSource = null;
        GridView2.DataBind();
        lblCaseType.Visible = false;
        lblcolan.Visible = false;
        lblSubCat.Visible = false;
        cmbCaseType.Visible = false;
        ChkAllRoom.Visible = false;
        cmbSubCategory.Visible = false;
        BindPanelOPD();
        BindScheduleChage();
        btnSave.Visible = false;
    }

    private void BindCaseType()
    {
        try
        {
            string sql = "select icm.Name,icm.IPDCaseTypeID from ipd_case_type_master icm inner join ipd_case_type_master bc on icm.IPDCaseTypeID = bc.BillingCategoryID where icm.IsActive=1 group by icm.IPDCaseTypeID order by icm.name";
            cmbCaseType.DataSource = StockReports.GetDataTable(sql);
            cmbCaseType.DataTextField = "Name";
            cmbCaseType.DataValueField = "IPDCaseTypeID";
            cmbCaseType.DataBind();
            if (cmbCaseType.Items.Count > 0) cmbCaseType.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindPanel()
    {
        try
        {
            cmbPanel.Items.Clear();
            DataTable dt = CreateStockMaster.LoadPanelCompanyRef();
            foreach (DataRow dr in dt.Rows)
            {
                ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[2].ToString() + "#" + dr[3].ToString());
                li1.Attributes["REFID"] = dr[2].ToString();
                li1.Attributes["REFIDOPD"] = dr[3].ToString();
                cmbPanel.Items.Add(li1);
                cmbPanel.Attributes.Add("REFID", dr[2].ToString());
                cmbPanel.Attributes["REFIDOPD"] = dr[3].ToString();
            }

            cmbPanel.SelectedIndex = cmbPanel.Items.IndexOf(cmbPanel.Items.FindByText(AllGlobalFunction.Panel));
            BindCentre();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindPanelOPD()
    {
        try
        {
            cmbPanel.Items.Clear();
            DataTable dt = CreateStockMaster.LoadPanelCompanyRefOPD();
            foreach (DataRow dr in dt.Rows)
            {
                ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[2].ToString() + "#" + dr[3].ToString());
                li1.Attributes["REFID"] = dr[2].ToString();
                li1.Attributes["REFIDOPD"] = dr[3].ToString();
                cmbPanel.Items.Add(li1);
                cmbPanel.Attributes.Add("REFID", dr[2].ToString());
                cmbPanel.Attributes["REFIDOPD"] = dr[3].ToString();
            }

            cmbPanel.SelectedIndex = cmbPanel.Items.IndexOf(cmbPanel.Items.FindByText(AllGlobalFunction.Panel));
            BindCentre();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindScheduleChage()
    {
        lblMsg.Text = "";
        ddlScheduleCharge.Items.Clear();

        string str = "SELECT NAME,ScheduleChargeID,IsDefault FROM f_rate_schedulecharges rs INNER JOIN f_panel_master pm ";
        str += " ON pm.PanelID = rs.PanelID WHERE ";

        if (rdbIPD.Checked)
            str += "rs.PanelID=" + cmbPanel.SelectedItem.Value.Split('#')[2].ToString() + " ";
        else
            str += "rs.PanelID=" + cmbPanel.SelectedItem.Value.Split('#')[1].ToString() + " ";

        DataTable dtFrm = StockReports.GetDataTable(str);
        ddlScheduleCharge.DataSource = dtFrm;
        ddlScheduleCharge.DataTextField = "NAME";
        ddlScheduleCharge.DataValueField = "ScheduleChargeID";
        ddlScheduleCharge.DataBind();

        if (dtFrm != null && dtFrm.Rows.Count > 0)
        {
            string Selected = dtFrm.Select("IsDefault=1")[0]["ScheduleChargeID"].ToString();
            ddlScheduleCharge.SelectedIndex = ddlScheduleCharge.Items.IndexOf(ddlScheduleCharge.Items.FindByValue(Selected));
        }
    }

    private void BindSubCategory()
    {
        DataTable dt = CreateStockMaster.LoadSubCategoryType();
        cmbSubCategory.DataSource = dt;
        cmbSubCategory.DataTextField = "Name";
        cmbSubCategory.DataValueField = "SubCategoryID";
        cmbSubCategory.DataBind();
    }

    private string InsertRateForMultipleRooms(string Panel, string ItemId, decimal Rate, string displayname, string ItemCode, string ScheduleChargeID, string SubCategoryID, string DoctorID, string IsScheduled, string CentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string sql = "update f_ratelist_ipd set IsCurrent=0,LastUpdatedBy='" + Session["ID"].ToString() + "',UpdateDate=Now(),IpAddress='" + All_LoadData.IpAddress() + "' where ItemID='" + ItemId + "' and PanelID=" + Panel + " and IsCurrent=1 and CentreID=" + Util.GetInt(CentreID) + "";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sql);

            sql = " INSERT INTO f_ratelist_ipd(Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,ItemDisplayName,";
            sql += " ItemCode,ScheduleChargeID,UserID,IPDCaseTypeID,CentreID)";
            sql += " SELECT 'L','SHHI'," + Rate + ",1,'" + ItemId + "','" + Panel + "','" + displayname + "',";
            sql += " '" + ItemCode + "','" + ScheduleChargeID + "','" + Session["ID"].ToString() + "',IPDCaseTypeID," + Util.GetInt(CentreID) + " ";
            sql += " FROM ipd_case_type_master WHERE IsActive=1";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sql);

            sql = "update f_ratelist_ipd set RateListID=concat('LSHHI',ID) where RateListID is null or RateListID=''";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sql);

            sql = "Select DoctorID from f_scheduledconsultant Where SubCategoryID='" + SubCategoryID + "' and DoctorID='" + DoctorID + "' and IsActive=1";
            sql = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, sql));

            if (sql == "")
            {
                if (IsScheduled == "1")
                {
                    sql = "Insert into f_scheduledconsultant(SubCategoryID,DoctorID)";
                    sql += "values('" + SubCategoryID + "','" + DoctorID + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sql);
                }
            }
            else
            {
                sql = "Update f_scheduledconsultant Set IsActive=" + IsScheduled + " Where SubCategoryID='" + SubCategoryID + "' and DoctorID='" + DoctorID + "'  and IsActive=1";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sql);
            }

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE id_master SET MaxId=(Select max(ID) FROM  f_ratelist_ipd ) WHERE groupName='f_ratelist_ipd' ");

            tranX.Commit();
           

            lblMsg.Text = "Record Updated Successfully";
            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
   
    private void BindCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE fcp.isActive=1  AND fcp.PanelID='" + cmbPanel.SelectedValue.ToString() + "' ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        ddlCentre.DataSource = dtCentre;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Util.GetString(dtCentre.Select("IsDefault=1")[0]["CentreID"])));
    }

    private void BindModelCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE fcp.isActive=1  AND fcp.PanelID='" + cmbPanel.SelectedValue.ToString() + "' ";
        DataTable dt = StockReports.GetDataTable(str);
        chkCentre.DataSource = dt;
        chkCentre.DataTextField = "CentreName";
        chkCentre.DataValueField = "CentreID";
        chkCentre.DataBind();
    }


    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID,dm.Name,dm.Designation,dm.Specialization,g.Doctype DoctorType,dm.Mobile `Mobile No` FROM doctor_master dm INNER JOIN DoctorGroup g ON g.ID=dm.DocGroupId ");
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Doctor Report";
            Session["Period"] = "As On " + DateTime.Now.ToString("dd-MM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindTierDoctor(int Id)
    {
        try
        {
            if (Id == 1)
            {
                 
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT de.DoctorID ID,CONCAT(em.title,' ', em.NAME) Name  ");
                sb.Append(" FROM employee_master em ");
                sb.Append(" INNER JOIN doctor_employee de ON de.EmployeeID=em.EmployeeID  ");
                sb.Append(" WHERE em.IsActive=1 AND em.TierID=1  ");
                DataTable dt = StockReports.GetDataTable(sb.ToString());
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                DataTable dt = StockReports.GetDataTable("SELECT em.EmployeeID ID,concat(em.title,' ', em.NAME) Name FROM employee_master em WHERE em.IsActive=1 AND em.TierID=" + Util.GetInt(Id) + " ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }


        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCadreDoctor(int Id)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT em.EmployeeID ID, concat(em.title,' ', em.NAME) Name FROM employee_master em WHERE em.IsActive=1 AND em.Cadreid=" + Util.GetInt(Id) + "  ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true, Description = "Map Team")]
    public static string MapTeam(List<insert> Data)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            StringBuilder sbup = new StringBuilder();
            sbup.Append(" update unit_doctorlist set IsActive=0,UpdatedBy='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "',UpdatedDateTime=NOW() where UnitDoctorID=" + Util.GetInt(Data[0].TeamId) + " ");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbup.ToString());


            for (int i = 0; i < Data.Count; i++)
            {




                StringBuilder sb = new StringBuilder();
                sb.Append(" insert  into unit_doctorlist ");
                sb.Append(" ( DoctorListId,UnitDoctorID, ");
                sb.Append(" CreatedBy,IsActive,Position,Type,CadreId,CadreName,");
                sb.Append(" TeirId,TeirName,EmpName,UnitName,CreatedDateTime )");
                sb.Append(" values('" + Data[i].docID + "','" + Data[i].TeamId + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' , ");
                sb.Append(" 1,'" + Data[i].docPosition + "'," + Util.GetInt(Data[i].Type) + "," + Util.GetInt(Data[i].CadreId) + ",'" + Util.GetString(Data[i].CadreNames) + "',");
                sb.Append(" " + Util.GetInt(Data[i].TierId) + ",'" + Util.GetString(Data[i].TierName) + "','" + Util.GetString(Data[i].docName) + "', '" + Util.GetString(Data[i].TeamName) + "' ");
                sb.Append(" ,NOW() )");
                 
                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                {
                    Tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    return "0";
                }


            }


            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }


        return "0";
    }


    [WebMethod(EnableSession = true)]
    public static string getMappedDoctor(string TeamId)
    {

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM unit_doctorlist  ud WHERE ud.UnitDoctorID='" + TeamId + "' AND ud.IsActive=1 ");
             
             
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dt, Message = "No Data Found ,Select Order" });

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }



    
    
    
    
    
    
    
    public class insert
    {

        public string docID { get; set; }
        public string docName { get; set; }
        public string docPosition { get; set; }
        public string TierId { get; set; }
        public string TierName { get; set; }
        public string CadreId { get; set; }
        public string CadreNames { get; set; }
        public string TeamId { get; set; }
        public string TeamName { get; set; }
        public string Type { get; set; }
    }


}