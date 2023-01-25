using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class EDP_RateListReport : System.Web.UI.Page
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM185','" + lblMsg.ClientID + "');", true);
                return;
            }
        }

        //string Centre = All_LoadData.SelectCentre(chkCentre);
        //if (Centre == string.Empty)
        //{
        //    lblMsg.Text = "Please Select Centre";
        //    return;
        //}  

        string Centre = ddlCentre.SelectedValue.ToString();
        StringBuilder sb = new StringBuilder();

        if (rbtnType.SelectedItem.Text != "IPD" && rbtnType.SelectedItem.Text != "All")
        {
            if (ddlCategory.SelectedValue != "All" && ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
            {
                sb.Append(" SELECT MainGroup Category,GroupName SubCategory,ItemName,ItemCode,ItemDisplayName,SUM(OPD)OPD,ItemID,PanelID,CentreID,CentreName ");
                sb.Append(" FROM ( SELECT cm.CentreID, cm.CentreName,MainGroup,t.GroupName,t.ItemName,IFNULL(t.ItemCode,'')ItemCode,ifnull(rt.ItemDisplayName,'')ItemDisplayName,IFNULL(rt.Rate,0)OPD,0 GenW,0 SemiPvt,0 Delux,0 SuperDelux,0 Suite,");
                sb.Append(" 0 Micu,0 CCU,0 NICU,0 Labour,0 DayCare,0 Dialysis,0 SICU,0 CTVS,0 HeartCmd,0 Triage,0 MotherSide,t.itemID,rt.PanelID FROM (");
                sb.Append(" SELECT t.*,'opd' RoomType FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup,im.ItemCode");
                sb.Append(" FROM  f_itemmaster im INNER JOIN f_subcategorymaster sc ");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive IN (1,3) ");

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
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);
                    sb.Append(" AND sc.SubCategoryID IN(" + SubCategoryID + ") ");
                }
                sb.Append(" )t");
                sb.Append(" )t LEFT JOIN f_ratelist rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 AND rt.PanelID=" + ddlPanel.SelectedValue + " and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "' and CentreID in (" + Centre + ") ");
            //    sb.Append(" LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID ) t GROUP BY ItemID,CentreID ORDER BY MainGroup,GroupName,ItemName,CentreName");
                sb.Append(" LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName,CentreName");
            }
        }
        else if (rbtnType.SelectedItem.Text != "OPD" && rbtnType.SelectedItem.Text != "All")
        {
            if (ddlCategory.SelectedValue != "All" && ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
            {
                sb.Append(" SELECT MainGroup Category,GroupName SubCategory,ItemName,ItemCode,ItemDisplayName, ");
                string strSelectedRooms = "";
                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        if (strSelectedRooms == "")
                            strSelectedRooms += " SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                        else
                            strSelectedRooms += ",SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID,CentreID,CentreName FROM ( ");
                sb.Append("  SELECT cm.CentreID, cm.CentreName,MainGroup,t.GroupName,t.ItemName,IFNULL(rt.ItemCode,'')ItemCode,IFNULL(rt.ItemDisplayName,'')ItemDisplayName,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseTypeID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)`" + li.Value.Split('#')[1].ToString() + "`,");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append(" SELECT t.*,icm.Name RoomType,icm.IPDCaseTypeID FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive IN (1,3) ");
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
                sb.Append(" )t,(SELECT NAME ,IPDCaseTypeID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append(" )t LEFT JOIN f_ratelist_ipd rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 ");
                sb.Append(" AND rt.PanelID=" + ddlPanel.SelectedValue + "");
                sb.Append(" AND rt.IPDCaseTypeID = t.IPDCaseTypeID and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "' AND CentreID IN ("+Centre+") LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID ");
            //    sb.Append(" ) t GROUP BY ItemID,CentreID ORDER BY MainGroup,GroupName,ItemName ,CentreName");
                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName ,CentreName");
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
                            strSelectedRooms += " SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                        else
                            strSelectedRooms += ",SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID,CentreID,CentreName FROM ( ");
                sb.Append("  SELECT cm.CentreID, cm.CentreName,MainGroup,t.GroupName,t.ItemName,IFNULL(rt.PanelCode,'')ItemCode,IFNULL(rt.PanelDisplayName,'')ItemDisplayName,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseTypeID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)`" + li.Value.Split('#')[1].ToString() + "`,");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append("     SELECT t.*,icm.Name RoomType,icm.IPDCaseTypeID FROM (");
                sb.Append("         SELECT im.Surgery_ID itemID,im.Name itemName,sdm.Name GroupName,im.Department MainGroup");
                sb.Append("         FROM f_surgery_master im  inner join surdept_master sdm on sdm.DeptID = im.Department    ");
                sb.Append("         WHERE  im.IsActive IN (1,3) ");
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

                    sb.Append(" AND im.Department IN(" + SubCategoryID + ") ");
                }
                sb.Append("         )t,(SELECT NAME ,IPDCaseTypeID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append("     )t LEFT JOIN f_surgery_rate_list rt ON t.ItemID =rt.Surgery_ID AND rt.IsCurrent=1 ");
                sb.Append("     AND rt.PanelID=" + ddlPanel.SelectedValue + "");
                sb.Append("     AND rt.IPDCaseTypeID = t.IPDCaseTypeID and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "' AND CentreID IN ("+Centre+") LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID");
          //      sb.Append(" ) t  GROUP BY ItemID,CentreID ORDER BY MainGroup,GroupName,ItemName ,CentreName");
                sb.Append(" ) t  GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName ,CentreName");
                sb.Append(" ");
            }
        }

        else
        {
            if (ddlCategory.SelectedValue.Split('#')[1].ToString() != "22")
            {
                sb.Append(" SELECT MainGroup Category,GroupName SubCategory,ItemName,ItemCode,ItemDisplayName,SUM(OPD)OPD  ");

                string strSelectedRooms = "";
                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        strSelectedRooms += ", SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID,CentreID,CentreName FROM ( SELECT cm.CentreID, cm.CentreName,MainGroup,t.GroupName,t.ItemName,IFNULL(rt.ItemCode,'')ItemCode,IFNULL(rt.ItemDisplayName,'')ItemDisplayName,IFNULL(rt.Rate,0)OPD,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" 0 `" + li.Value.Split('#')[1].ToString() + "`,");
                    }
                }

                sb.Append(" t.itemID,rt.PanelID FROM (");

                sb.Append(" SELECT t.*,'opd' RoomType FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM  f_itemmaster im INNER JOIN f_subcategorymaster sc ");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive IN (1,3) ");
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
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
                        return;
                    }
                    SubCategoryID = SubCategoryID.Substring(0, index);
                    sb.Append(" AND sc.SubCategoryID IN(" + SubCategoryID + ") ");
                }
                sb.Append(" )t");
                sb.Append(" )t LEFT JOIN f_ratelist rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 AND rt.PanelID=" + ddlPanel.SelectedValue + " and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "' and CentreID in (" + Centre + ") LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID");
                sb.Append(" 	UNION ALL");
                sb.Append("  SELECT  cm.CentreID, cm.CentreName,MainGroup,t.GroupName,t.ItemName,IFNULL(rt.ItemCode,'')ItemCode,IFNULL(rt.ItemDisplayName,'')ItemDisplayName,0 OPD,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseTypeID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)`" + li.Value.Split('#')[1].ToString() + "`,");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append(" SELECT t.*,icm.Name RoomType,icm.IPDCaseTypeID FROM (");
                sb.Append(" SELECT im.itemID,im.TypeName itemName,sc.Name GroupName,cf.Name MainGroup");
                sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc");
                sb.Append(" ON im.SubCategoryID = sc.SubCategoryID INNER JOIN ");
                sb.Append(" f_configrelation cf ON sc.CategoryID = cf.CategoryID");
                sb.Append(" WHERE  im.IsActive IN (1,3) ");
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
                sb.Append(" )t,(SELECT NAME ,IPDCaseTypeID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append(" )t LEFT JOIN f_ratelist_ipd rt ON t.ItemID =rt.ItemID AND rt.IsCurrent=1 AND rt.PanelID=" + ddlPanel.SelectedValue + " and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "'");
                sb.Append(" AND rt.IPDCaseTypeID = t.IPDCaseTypeID and rt.CentreID in (" + Centre + ") LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID ");
           //     sb.Append(" ) t GROUP BY ItemID,CentreID ORDER BY MainGroup,GroupName,ItemName,CentreName");
                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName,CentreName");
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
                            strSelectedRooms += " SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                        else
                            strSelectedRooms += ",SUM(`" + li.Value.Split('#')[1].ToString() + "`) `" + li.Value.Split('#')[1].ToString() + "` ";
                    }
                    else
                    {
                    }
                }
                sb.Append(strSelectedRooms);

                sb.Append(",t.ItemID,t.PanelID,CentreID,CentreName FROM ( ");
                sb.Append("  SELECT  cm.CentreID, cm.CentreName,MainGroup,t.GroupName,t.ItemName,IFNULL(rt.PanelCode,'')ItemCode,IFNULL(rt.PanelDisplayName,'')ItemDisplayName,");

                foreach (ListItem li in chkCaseType.Items)
                {
                    if (li.Selected == true)
                    {
                        sb.Append(" IF(t.IPDCaseTypeID='" + li.Value.Split('#')[0].ToString() + "',IFNULL(rt.Rate,0),0)`" + li.Value.Split('#')[1].ToString() + "`,");
                    }
                }

                sb.Append(" t.ItemID,rt.PanelID ");
                sb.Append(" FROM (");
                sb.Append("     SELECT t.*,icm.Name RoomType,icm.IPDCaseTypeID FROM (");
                sb.Append("         SELECT im.Surgery_ID itemID,im.Name itemName,im.SubDepartment GroupName,im.Department MainGroup");
                sb.Append("         FROM f_surgery_master im ");
                sb.Append("         WHERE  im.IsActive IN (1,3) ");
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

                    sb.Append(" AND im.Department IN(" + SubCategoryID + ") ");
                }
                sb.Append("         )t,(SELECT NAME ,IPDCaseTypeID FROM ipd_case_type_master WHERE isactive=1 )icm");
                sb.Append("     )t LEFT JOIN f_surgery_rate_list rt ON t.ItemID =rt.Surgery_ID AND rt.IsCurrent=1 ");
                sb.Append("     AND rt.PanelID=" + ddlPanel.SelectedValue + "");
                sb.Append("     AND rt.IPDCaseTypeID = t.IPDCaseTypeID and schedulechargeID='" + ddlScheduleCharges.SelectedValue + "' and CentreID in (" + Centre + ") LEFT JOIN center_master cm ON rt.CentreID=cm.CentreID");
           //     sb.Append(" ) t GROUP BY ItemID,CentreID ORDER BY MainGroup,GroupName,ItemName,CentreName");

                sb.Append(" ) t GROUP BY ItemID ORDER BY MainGroup,GroupName,ItemName,CentreName");
                sb.Append(" ");
            }
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            if (dt.Columns.Contains("CategoryID") == true)
                dt.Columns.Remove("CategoryID");

            if (dt.Columns.Contains("PanelID") == true)
                dt.Columns.Remove("PanelID");
            if (dt.Columns.Contains("CentreID") == true)
                dt.Columns.Remove("CentreID");

            if (rbtnType.SelectedValue == "IPD")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "RateList-Report (" + ddlPanel.SelectedItem.Text.Trim() + ")";
                Session["Period"] = "As on :     " + DateTime.Now.ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else if (rbtnType.SelectedValue == "OPD")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "RateList-Report (" + ddlPanel.SelectedItem.Text.Trim() + ")";
                Session["Period"] = "As on :    " + DateTime.Now.ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "RateList Report (" + ddlPanel.SelectedItem.Text.Trim() + ")";
                Session["Period"] = "As on :    " + DateTime.Now.ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
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

        if (ddlCategory.SelectedItem.Text.Trim() != "All" && (ddlCategory.SelectedValue.Split('#')[1].ToString() != "22" && ddlCategory.SelectedValue.Split('#')[1].ToString() != "2"))
        {
            sb.Append("SELECT SubCategoryID,NAME FROM f_subcategorymaster WHERE CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0].ToString() + "' and active IN (1,0) ");
        }
        else if (ddlCategory.SelectedItem.Text.Trim() != "All" && ddlCategory.SelectedValue.Split('#')[1].ToString() == "2") {
            sb.Append("SELECT scm.SubCategoryID,scm.NAME FROM f_subcategorymaster scm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=scm.Description WHERE icm.CentreID="+ ddlCentre.SelectedValue +" AND icm.IsActive=1");
        }
        else if (ddlCategory.SelectedItem.Text.Trim() != "All" && ddlCategory.SelectedValue.Split('#')[1].ToString() == "22")
        {
            sb.Append(" SELECT Department SubCategoryID ,sdm.NAME AS   NAME FROM f_surgery_master fsm inner join  surdept_master sdm on sdm.DeptID = fsm.Department GROUP BY fsm.Department ORDER BY sdm.NAME ");
        }
        else
        {
            sb.Append("Select * from (");
            sb.Append("SELECT SubCategoryID,sc.NAME FROM f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID where sc.active=1 ");
            if (rbtnType.SelectedItem.Text == "IPD")
            {
                sb.Append("and cf.ConfigID in (1,2,3,6,8,20,7,14,15,24,22,25,10) ");
            }
            else if (rbtnType.SelectedItem.Text == "OPD")
            {
                sb.Append("and cf.ConfigID in (3,6,5,7,8,26,23,25) ");
            }
            else
            {
                sb.Append("and cf.ConfigID in (1,2,3,5,6,8,20,7,14,15,24,22,25,23,10) ");
            }

            sb.Append(" Union All ");
            sb.Append(" SELECT Department SubCategoryID ,sdm.NAME AS   NAME FROM f_surgery_master fsm inner join  surdept_master sdm on sdm.DeptID = fsm.Department WHERE fsm.IsActive=1 GROUP BY DeptID  ");
            sb.Append(")t order by Name");
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString()).Copy();

        chkDepartment.DataSource = dt;
        chkDepartment.DataTextField = "Name";
        chkDepartment.DataValueField = "SubCategoryID";
        chkDepartment.DataBind();
        ListItem li = new ListItem();
        li.Text = "All";
        li.Value = "All";

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
       // LoadCentre();
        BindCentre();
    }
    //private void LoadCentre()
    //{
    //    string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE fcp.isActive=1  AND fcp.PanelID='" + ddlPanel.SelectedValue.ToString() + "' ";
    //    DataTable dt = StockReports.GetDataTable(str);
    //    chkCentre.DataSource = dt;
    //    chkCentre.DataTextField = "CentreName";
    //    chkCentre.DataValueField = "CentreID";
    //    chkCentre.DataBind();
    //}
    protected void LoadCaseType()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(IPDCaseTypeID,'#',IF(Abbreviation IS NULL,REPLACE(NAME,' ',''),Abbreviation)) IPDCaseTypeID, NAME FROM ipd_case_type_master WHERE IsActive=1 AND CentreID='" + ddlCentre.SelectedValue + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString()).Copy();
        if (dt != null && dt.Rows.Count > 0)
        {
            chkCaseType.DataSource = dt;
            chkCaseType.DataTextField = "Name";
            chkCaseType.DataValueField = "IPDCaseTypeID";
            chkCaseType.DataBind();
            lblCaseType.Visible = true;
            ChkAllRoomType.Visible = true;
        }
        else
            lblCaseType.Visible = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategory();
            ddlCategory_SelectedIndexChanged(sender, e);
            LoadScheduleCharges();
            chkCaseType.Visible = true;
            LoadCaseType();
            rbtnType_SelectedIndexChanged(sender, e);
        }
    }

    protected void rbtnType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadCategory();

        if (rbtnType.SelectedValue == "IPD" || rbtnType.SelectedValue == "All")
        {
            LoadCaseType();
            ddlCategory_SelectedIndexChanged(sender, e);
        }
        else
        {
            chkCaseType.Items.Clear();
            lblCaseType.Visible = false;
            ChkAllRoomType.Visible = false;
            ddlCategory_SelectedIndexChanged(sender, e);
        }
    }

    private void LoadCategory()
    {
        StringBuilder sb = new StringBuilder();
        if (rbtnType.SelectedItem.Text == "IPD")
        {
            sb.Append("Select CONCAT(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation cf on  ");
            sb.Append("cf.CategoryID = cm.CategoryID where cf.ConfigID in (1,2,3,6,8,20,7,14,15,24,22,25,10,29) group by cm.categoryID order by Name");
        }
        else if (rbtnType.SelectedItem.Text == "OPD")
        {
            sb.Append("Select CONCAT(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation cf on  ");
            sb.Append("cf.CategoryID = cm.CategoryID where cf.ConfigID in (3,6,5,7,8,20,26,23,25,29) group by cm.categoryID order by Name");
        }
        else
        {
            sb.Append("Select CONCAT(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation cf on  ");
            sb.Append("cf.CategoryID = cm.CategoryID where cf.ConfigID in (1,2,3,5,6,8,20,7,14,15,24,22,23,25,10,29) group by cm.categoryID order by Name");
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString()).Copy();

        ddlCategory.DataSource = dt;
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new ListItem("All", "All#0"));

        dt = StockReports.GetDataTable("select Company_Name,PanelID from f_panel_master where PanelID = ReferenceCode");
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
       // LoadCentre();
        BindCentre();
        chkDepartment.Items.Clear();
        chkAll.Checked = false;
    }

    private void LoadScheduleCharges()
    {
        DataTable dtCharges = StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE panelID=" + ddlPanel.SelectedValue + " ");
        ddlScheduleCharges.DataSource = dtCharges;
        ddlScheduleCharges.DataTextField = "NAME";
        ddlScheduleCharges.DataValueField = "ScheduleChargeID";
        ddlScheduleCharges.DataBind();
    }

    private void BindCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE fcp.isActive=1  AND fcp.PanelID='" + ddlPanel.SelectedValue.ToString() + "' ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        ddlCentre.DataSource = dtCentre;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Util.GetString(dtCentre.Select("IsDefault=1")[0]["CentreID"])));
    }

    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlCategory_SelectedIndexChanged(sender, e);
        LoadCaseType();

    }
}