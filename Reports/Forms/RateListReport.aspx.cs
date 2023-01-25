using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Reports_Forms_RateListReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        int IsSelected = 0;
        if (rbtnType.SelectedValue == "OPD")
        {
            for (int i = 0; i < chkDepartment.Items.Count; i++)
            {
                if (chkDepartment.Items[i].Selected)
                {
                    IsSelected += 1;
                }
            }

            if (IsSelected == 0)
            {
                lblMsg.Text = "Select Department";
                return;
            }
        }

        IsSelected = 0;
        if (rbtnType.SelectedValue != "OPD")
        {
            for (int i = 0; i < chkDepartment.Items.Count; i++)
            {
                if (chkDepartment.Items[i].Selected)
                {
                    IsSelected += 1;
                }
            }

            if (IsSelected == 0)
            {
                lblMsg.Text = "Select Department";
                return;
            }

            IsSelected = 0;
            for (int j = 0; j < chkCaseType.Items.Count; j++)
            {
                if (chkCaseType.Items[j].Selected)
                {
                    IsSelected += 1;
                }
            }

            if (IsSelected == 0)
            {
                lblMsg.Text = "Select RoomType";
                return;
            }
        }

        StringBuilder sb = new StringBuilder();

        if (rbtnType.SelectedItem.Text != "IPD" && rbtnType.SelectedItem.Text != "ALL")
        {
            if (ddlCategory.SelectedValue != "ALL" && ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
            {
                sb.Append(" SELECT MainGroup,GroupName SubGroup,ItemName,ItemCode,ItemDisplayName,SUM(OPD)OPD,ItemID,PanelID ");
                sb.Append(" FROM ( SELECT MainGroup,t.GroupName,t.ItemName,ifnull(rt.ItemCode,'')ItemCode,ifnull(rt.ItemDisplayName,'')ItemDisplayName,IFNULL(rt.Rate,0)OPD,0 GenW,0 SemiPvt,0 Delux,0 SuperDelux,0 Suite,");
                sb.Append(" 0 Micu,0 CCU,0 NICU,0 Labour,0 DayCare,0 Dialysis,0 SICU,0 CTVS,0 HeartCmd,0 Triage,0 MotherSide,t.itemID,rt.PanelID FROM (");
                sb.Append(" SELECT t.*,'opd' RoomType FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM  f_itemmaster im INNER JOIN f_subcategorymaster sc ");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive=1 ");

                if (ddlCategory.SelectedValue != "All")
                {
                    string SubCategoryID = string.Empty;
                    for (int i = 0; i < chkDepartment.Items.Count; i++)
                    {
                        if (chkDepartment.Items[i].Selected)
                        {
                            SubCategoryID += "'" + chkDepartment.Items[i].Value.ToString() + "',";
                        }
                    }
                    int index = SubCategoryID.Length - 1;
                    if (index == -1)
                    {
                        lblMsg.Text = "Select Department";
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);
                    sb.Append(" AND sc.SubCategoryID IN(" + SubCategoryID + ") ");
                }
                sb.Append(" )t");
                sb.Append(" )t LEFT JOIN f_ratelist rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 AND rt.PanelID=" + ddlPanel.SelectedValue + " and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "' ");
                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName");
            }
        }
        else if (rbtnType.SelectedItem.Text != "OPD" && rbtnType.SelectedItem.Text != "ALL")
        {
            if (ddlCategory.SelectedValue != "ALL" && ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
            {
                sb.Append(" SELECT MainGroup,GroupName SubGroup,ItemName,ItemCode,ItemDisplayName, ");
                string strSelectedRooms = "";
                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        if (strSelectedRooms == "")
                            strSelectedRooms += " SUM(" + li.Value.Split('#')[1].ToString() + ") " + li.Value.Split('#')[1].ToString() + " ";
                        else
                            strSelectedRooms += ",SUM(" + li.Value.Split('#')[1].ToString() + ") " + li.Value.Split('#')[1].ToString() + " ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID FROM ( ");
                sb.Append("  SELECT MainGroup,t.GroupName,t.ItemName,ifnull(rt.ItemCode,'')ItemCode,ifnull(rt.ItemDisplayName,'')ItemDisplayName,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseType_ID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)" + li.Value.Split('#')[1].ToString() + ",");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append(" SELECT t.*,icm.Name RoomType,icm.IPDCaseType_ID FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive=1 ");
                if (ddlCategory.SelectedValue != "ALL")
                {
                    string SubCategoryID = string.Empty;
                    for (int i = 0; i < chkDepartment.Items.Count; i++)
                    {
                        if (chkDepartment.Items[i].Selected)
                        {
                            SubCategoryID += "'" + chkDepartment.Items[i].Value.ToString() + "',";
                        }
                    }
                    int index = SubCategoryID.Length - 1;
                    if (index == -1)
                    {
                        lblMsg.Text = "Select Department";
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);

                    sb.Append(" AND sc.SubCategoryID IN(" + SubCategoryID + ") ");
                }
                sb.Append(" )t,(SELECT NAME ,IPDCaseType_ID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append(" )t LEFT JOIN f_ratelist_ipd rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 ");
                sb.Append(" AND rt.PanelID=" + ddlPanel.SelectedValue + "");
                sb.Append(" AND rt.IPDCaseType_ID = t.IPDCaseType_ID and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "'");
                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName");
                sb.Append(" ");
            }
            else if (ddlCategory.SelectedValue.Split('#')[1].ToString() == "22")
            {
                sb.Append(" SELECT MainGroup,GroupName SubGroup,ItemName,ItemCode,ItemDisplayName, ");
                string strSelectedRooms = "";
                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        if (strSelectedRooms == "")
                            strSelectedRooms += " SUM(" + li.Value.Split('#')[1].ToString() + ") " + li.Value.Split('#')[1].ToString() + " ";
                        else
                            strSelectedRooms += ",SUM(" + li.Value.Split('#')[1].ToString() + ") " + li.Value.Split('#')[1].ToString() + " ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID FROM ( ");
                sb.Append("  SELECT MainGroup,t.GroupName,t.ItemName,ifnull(rt.PanelCode,'')ItemCode,ifnull(rt.PanelDisplayName,'')ItemDisplayName,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseType_ID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)" + li.Value.Split('#')[1].ToString() + ",");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append("     SELECT t.*,icm.Name RoomType,icm.IPDCaseType_ID FROM (");
                sb.Append("         SELECT im.Surgery_ID itemID,im.Name itemName,im.SubDepartment GroupName,im.Department MainGroup");
                sb.Append("         FROM f_surgery_master im ");
                sb.Append("         WHERE  im.IsActive=1 ");
                if (ddlCategory.SelectedValue != "ALL")
                {
                    string SubCategoryID = string.Empty;
                    for (int i = 0; i < chkDepartment.Items.Count; i++)
                    {
                        if (chkDepartment.Items[i].Selected)
                        {
                            SubCategoryID += "'" + chkDepartment.Items[i].Value.ToString() + "',";
                        }
                    }
                    int index = SubCategoryID.Length - 1;
                    if (index == -1)
                    {
                        lblMsg.Text = "Select Department";
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);

                    sb.Append(" AND im.Department IN(" + SubCategoryID + ") ");
                }
                sb.Append("         )t,(SELECT NAME ,IPDCaseType_ID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append("     )t LEFT JOIN f_surgery_rate_list rt ON t.ItemID =rt.Surgery_ID AND rt.IsCurrent=1 ");
                sb.Append("     AND rt.PanelID=" + ddlPanel.SelectedValue + "");
                sb.Append("     AND rt.IPDCaseType_ID = t.IPDCaseType_ID and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "'");
                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName");
                sb.Append(" ");
            }
        }
        else
        {
            if (ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
            {
                sb.Append(" SELECT MainGroup,GroupName SubGroup,ItemName,ItemCode,ItemDisplayName,SUM(OPD)OPD  ");

                string strSelectedRooms = "";
                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        strSelectedRooms += ", SUM(" + li.Value.Split('#')[1].ToString() + ") " + li.Value.Split('#')[1].ToString() + " ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID FROM ( SELECT MainGroup,t.GroupName,t.ItemName,ifnull(rt.ItemCode,'')ItemCode,ifnull(rt.ItemDisplayName,'')ItemDisplayName,IFNULL(rt.Rate,0)OPD,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" 0 " + li.Value.Split('#')[1].ToString() + ",");
                    }
                }

                sb.Append(" t.itemID,rt.PanelID FROM (");

                sb.Append(" SELECT t.*,'opd' RoomType FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM  f_itemmaster im INNER JOIN f_subcategorymaster sc ");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive=1 ");
                if (ddlCategory.SelectedValue != "ALL")
                {
                    string SubCategoryID = string.Empty;
                    for (int i = 0; i < chkDepartment.Items.Count; i++)
                    {
                        if (chkDepartment.Items[i].Selected)
                        {
                            SubCategoryID += "'" + chkDepartment.Items[i].Value.ToString() + "',";
                        }
                    }
                    int index = SubCategoryID.Length - 1;
                    if (index == -1)
                    {
                        lblMsg.Text = "Select Department";
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);
                    sb.Append(" AND sc.SubCategoryID IN(" + SubCategoryID + ") ");
                }
                sb.Append(" )t");
                sb.Append(" )t LEFT JOIN f_ratelist rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 AND rt.PanelID=" + ddlPanel.SelectedValue + " and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "'");
                sb.Append(" 	UNION ALL");
                sb.Append("  SELECT MainGroup,t.GroupName,t.ItemName,ifnull(rt.ItemCode,'')ItemCode,ifnull(rt.ItemDisplayName,'')ItemDisplayName,0 OPD,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseType_ID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)" + li.Value.Split('#')[1].ToString() + ",");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append(" SELECT t.*,icm.Name RoomType,icm.IPDCaseType_ID FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive=1 ");
                if (ddlCategory.SelectedValue != "ALL")
                {
                    string SubCategoryID = string.Empty;
                    for (int i = 0; i < chkDepartment.Items.Count; i++)
                    {
                        if (chkDepartment.Items[i].Selected)
                        {
                            SubCategoryID += "'" + chkDepartment.Items[i].Value.ToString() + "',";
                        }
                    }
                    int index = SubCategoryID.Length - 1;
                    if (index == -1)
                    {
                        lblMsg.Text = "Select Department";
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);
                    sb.Append(" AND sc.SubCategoryID IN(" + SubCategoryID + ") ");
                }
                sb.Append(" )t,(SELECT NAME ,IPDCaseType_ID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append(" )t LEFT JOIN f_ratelist_ipd rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 AND rt.PanelID=" + ddlPanel.SelectedValue + " and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "'");
                sb.Append(" AND rt.IPDCaseType_ID = t.IPDCaseType_ID ");
                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName");
                sb.Append(" ");
            }
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";

            if (dt.Columns.Contains("CategoryID") == true)
                dt.Columns.Remove("CategoryID");

            if (rbtnType.SelectedValue == "IPD")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "RateList-IPD (" + ddlPanel.SelectedItem.Text.Trim() + ")";
                Session["Period"] = "As on : " + DateTime.Now.ToString("dd-MM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            else if (rbtnType.SelectedValue == "OPD")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "RateList-OPD (" + ddlPanel.SelectedItem.Text.Trim() + ")";
                Session["Period"] = "As on : " + DateTime.Now.ToString("dd-MM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            else
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "RateList (" + ddlPanel.SelectedItem.Text.Trim() + ")";
                Session["Period"] = "As on : " + DateTime.Now.ToString("dd-MM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }

    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkAll.Checked)
        {
            for (int i = 0; i < chkDepartment.Items.Count; i++)
            {
                chkDepartment.Items[i].Selected = true;
            }
        }
        else
        {
            for (int i = 0; i < chkDepartment.Items.Count; i++)
            {
                chkDepartment.Items[i].Selected = false;
            }
        }
    }

    protected void ChkAllRoomType_CheckedChanged(object sender, EventArgs e)
    {
        if (ChkAllRoomType.Checked)
        {
            for (int i = 0; i < chkCaseType.Items.Count; i++)
            {
                chkCaseType.Items[i].Selected = true;
            }
        }
        else
        {
            for (int i = 0; i < chkCaseType.Items.Count; i++)
            {
                chkCaseType.Items[i].Selected = false;
            }
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        if (ddlCategory.SelectedItem.Text.Trim() != "ALL" && ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
        {
            // sb.Append("SELECT SubCategoryID,NAME FROM f_subcategorymaster WHERE CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0].ToString() + "' and active=1");
            sb.Append("SELECT SubCategoryID,NAME FROM f_subcategorymaster WHERE CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0].ToString() + "' and active=1");
        }
        else if (ddlCategory.SelectedItem.Text.Trim() != "ALL" && ddlCategory.SelectedValue.Split('#')[1].ToString() == "22")
        {
            //sb.Append("SELECT Department Name,Department SubCategoryID FROM f_surgery_master WHERE IsActive=1 GROUP BY Department ORDER BY Department ");
            sb.Append("SELECT Department Name,Department SubCategoryID FROM f_surgery_master WHERE IsActive=1 GROUP BY Department ORDER BY Department ");
        }
        else
        {
            sb.Append("Select * from (");
            sb.Append("SELECT SubCategoryID,sc.NAME FROM f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID where sc.active=1 ");
            if (rbtnType.SelectedItem.Text == "IPD")
            {
                sb.Append("and cf.ConfigID in (1,2,3,6,8,20,7,14,15,24,22,25) ");
            }
            else if (rbtnType.SelectedItem.Text == "OPD")
            {
                sb.Append("and cf.ConfigID in (3,6,5,7,8,26,23,25) ");
            }
            else
            {
                sb.Append("and cf.ConfigID in (1,2,3,5,6,8,20,7,14,15,24,22,25,23) ");
            }

            sb.Append(" Union All ");
            sb.Append("SELECT Department Name,Department SubCategoryID FROM f_surgery_master WHERE IsActive=1 GROUP BY Department ");
            sb.Append(")t order by Name");
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString()).Copy();

        chkDepartment.DataSource = dt;
        chkDepartment.DataTextField = "Name";
        chkDepartment.DataValueField = "SubCategoryID";
        chkDepartment.DataBind();
        ListItem li = new ListItem();
        li.Text = "ALL";
        li.Value = "ALL";

        if (chkAll.Checked)
        {
            for (int i = 0; i < chkDepartment.Items.Count; i++)
            {
                chkDepartment.Items[i].Selected = true;
            }
        }

        if (ChkAllRoomType.Checked == true && chkCaseType.Items != null && chkCaseType.Items.Count > 0)
        {
            for (int i = 0; i < chkCaseType.Items.Count; i++)
            {
                chkCaseType.Items[i].Selected = true;
            }
        }
    }

    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadScheduleCharges();
    }

    protected void LoadCaseType()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(IPDCaseType_ID,'#',Abbreviation) IPDCaseType_ID, NAME FROM ipd_case_type_master WHERE IsActive=1");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString()).Copy();
        if (dt != null && dt.Rows.Count > 0)
        {
            chkCaseType.DataSource = dt;
            chkCaseType.DataTextField = "Name";
            chkCaseType.DataValueField = "IPDCaseType_ID";
            chkCaseType.DataBind();
            lblCaseType.Visible = true;
            ChkAllRoomType.Visible = true;
        }
        else
            lblCaseType.Visible = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }

        if (!IsPostBack)
        {
            LoadCategory();
            ddlCategory_SelectedIndexChanged(sender, e);
            LoadScheduleCharges();
        }
    }

    protected void rbtnType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadCategory();

        if (rbtnType.SelectedValue == "IPD" || rbtnType.SelectedValue == "ALL")
        {
            LoadCaseType();
            ddlCategory_SelectedIndexChanged(sender, e);
        }
        else
        {
            chkCaseType.Items.Clear();
            lblCaseType.Visible = false;
            ChkAllRoomType.Visible = false;
        }
    }

    private void LoadCategory()
    {
        StringBuilder sb = new StringBuilder();
        if (rbtnType.SelectedItem.Text == "IPD")
        {
            sb.Append("Select concat(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation cf on  ");
            sb.Append("cf.CategoryID = cm.CategoryID where cf.ConfigID in (1,2,3,6,8,20,7,14,15,24,22,25) group by cm.categoryID order by Name");
        }
        else if (rbtnType.SelectedItem.Text == "OPD")
        {
            sb.Append("Select concat(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation cf on  ");
            sb.Append("cf.CategoryID = cm.CategoryID where cf.ConfigID in (3,6,5,7,8,26,23,25) group by cm.categoryID order by Name");
        }
        else
        {
            sb.Append("Select concat(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation cf on  ");
            sb.Append("cf.CategoryID = cm.CategoryID where cf.ConfigID in (1,2,3,5,6,8,20,7,14,15,24,22,23,25) group by cm.categoryID order by Name");
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString()).Copy();

        ddlCategory.DataSource = dt;
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new ListItem("ALL", "ALL#0"));

        //ListItem li = new ListItem();
        //li.Text = "All";
        //li.Value = "All";
        //ddlCategory.Items.Add(li);
        //ddlCategory.SelectedIndex = ddlCategory.Items.IndexOf(ddlCategory.Items.FindByValue("All"));

        dt = StockReports.GetDataTable("select Company_Name,PanelID from f_panel_master where PanelID = ReferenceCode");
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();

        chkDepartment.Items.Clear();
        chkAll.Checked = false;
    }

    private void LoadScheduleCharges()
    {
        DataTable dtCharges = StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE panelID= " + ddlPanel.SelectedValue + " ");
        ddlScheduleCharges.DataSource = dtCharges;
        ddlScheduleCharges.DataTextField = "NAME";
        ddlScheduleCharges.DataValueField = "ScheduleChargeID";
        ddlScheduleCharges.DataBind();
    }
}