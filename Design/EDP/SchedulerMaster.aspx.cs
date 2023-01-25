using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_EDP_SchedulerMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPanelGroup();
            bindSc();
        }
    }

    private void bindPanelGroup()
    {
        DataTable dt = StockReports.GetDataTable("Select PanelGroup,PanelGroupID from f_panelgroup where active=1 order by PanelGroup");

        chklPanelGroup.DataSource = dt;
        chklPanelGroup.DataTextField = "PanelGroup";
        chklPanelGroup.DataValueField = "PanelGroupID";
        chklPanelGroup.DataBind();
    }

    private void bindSc()
    {
       // DataTable con = StockReports.GetDataTable("SELECT CAST(ConfigRelationID AS CHAR(20)) ID,'1' IsConfig,Name FROM f_configrelation WHERE ConfigRelationID IN (1,2,24,27,9,10,29)");
        DataTable con = StockReports.GetDataTable("SELECT CAST(ConfigID AS CHAR(20)) ID,'1' IsConfig,NAME FROM f_configrelation WHERE ConfigID IN (1,2,29)");
        grdSc.DataSource = con;
        grdSc.DataBind();
        grdSc.HeaderRow.Visible = true;
        ViewState["Scheduler"] = con;
    }

    protected void grdSc_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[2].Visible = false;
            e.Row.Cells[3].Visible = false;
            e.Row.CssClass = "GridViewHeaderStyle";
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView row = (DataRowView)e.Row.DataItem;
            e.Row.Cells[2].Visible = false;
            e.Row.Cells[3].Visible = false;
            e.Row.Cells[4].Visible = false;
        }
    }

    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public static string[] getOtherItems(string prefixText, int count)
    {
        string sql = "SELECT ItemID,TypeName `Name` FROM f_itemmaster WHERE  SubCategoryID='LSHHI49' AND IsActive=1 AND TypeName like '" + prefixText + "%'";
        DataTable otherItem = StockReports.GetDataTable(sql);
        string[] items = new string[otherItem.Rows.Count];
        int i = 0;
        foreach (DataRow dr in otherItem.Rows)
        {
            items.SetValue(dr["ItemID"].ToString(), i);
            items.SetValue(dr["Name"].ToString(), i);
            i++;
        }
        return items;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        int chkPanelGroup = 0;
        try
        {
            // Truncate Table

            //  MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Truncate table master_scheduler");

            for (int k = 0; k < chklPanelGroup.Items.Count; k++)
            {
                if (chklPanelGroup.Items[k].Selected == true)
                {
                    chkPanelGroup += 1;
                    for (int i = 0; i < grdSc.Rows.Count; i++)
                    {
                        int Addmession = 0;
                        int scheduler = 0;
                        int s = Util.GetInt(grdSc.Rows[i].Cells.Count - 5);
                        CheckBox add = (CheckBox)grdSc.Rows[i].Cells[i].FindControl("chk_" + (s - 1));
                        CheckBox sch = (CheckBox)grdSc.Rows[i].Cells[i].FindControl("chk_" + (s));
                        if (add != null && add.Checked)
                        {
                            Addmession = 1;
                        }
                        if (sch != null && sch.Checked)
                        {
                            scheduler = 1;
                        }
                        for (int count = 5; count < grdSc.Rows[i].Cells.Count - 1; count++)
                        {
                            CheckBox cb = (CheckBox)grdSc.Rows[i].Cells[i].FindControl("chk_" + (count - 4));
                            string chkID = cb.ID;

                            if (cb != null && cb.Checked)
                            {
                                if (chkID != add.ID && chkID != sch.ID)
                                {
                                    Label lblCaseType = grdSc.HeaderRow.Cells[count].Controls[0] as Label;
                                    String header = lblCaseType.ID;
                                    StringBuilder sb = new StringBuilder();
                                    sb.Append("insert into master_scheduler(centreID,Name,PanelGroup,CreatedBy,IPDCaseTypeID,IsConfig, ");
                                    if (((Label)grdSc.Rows[i].FindControl("lblIsConfig")).Text == "1")
                                        sb.Append(" ConfigID, ");
                                    else
                                        sb.Append(" ItemID, ");
                                    sb.Append(" OnAdmission,OnScheduler, ");
                                    if (rblRunSche.SelectedValue == "1")
                                        sb.Append(" IsRoomCheckInTime,SpecificTime,BufferTime,Typeoftnx,TnxtypeID )  ");
                                    else
                                        sb.Append(" IsRoomCheckInTime,SpecificTime,BufferTime,Typeoftnx,TnxtypeID )  ");

                                    sb.Append("values('" + Session["CentreID"].ToString() + "','" + ((Label)grdSc.Rows[i].FindControl("lblName")).Text + "','" + chklPanelGroup.Items[k].Text + "','" + Session["ID"].ToString() + "','" + header + "', ");
                                    if (((Label)grdSc.Rows[i].FindControl("lblIsConfig")).Text == "1")
                                        sb.Append(" 1,'" + ((Label)grdSc.Rows[i].FindControl("lblID")).Text + "', ");
                                    else
                                        sb.Append(" 0,'" + ((Label)grdSc.Rows[i].FindControl("lblID")).Text + "', ");

                                    sb.Append(" '" + Addmession + "','" + scheduler + "', ");

                                    if (rblRunSche.SelectedValue == "1")
                                        sb.Append(" 1,'',24, ");
                                    else
                                        sb.Append("0,'" + txtSpecificTime.Text + "','" + string.Concat(txtRateHr.Text, ":", txtRateMin.Text) + "', ");

                                    if (((Label)grdSc.Rows[i].FindControl("lblIsConfig")).Text == "1")
                                    {
                                        if (((Label)grdSc.Rows[i].FindControl("lblID")).Text == "1")
                                            sb.Append(" 'IPD-CONSULTANTVISIT','16') ");
                                        else if (((Label)grdSc.Rows[i].FindControl("lblID")).Text == "2")
                                            sb.Append(" 'IPD-ROOMBILLING','8') ");
                                        else if (((Label)grdSc.Rows[i].FindControl("lblID")).Text == "24")
                                            sb.Append(" 'IPD-NURSHINGBILLING','0') ");
                                        else if (((Label)grdSc.Rows[i].FindControl("lblID")).Text == "27")
                                            sb.Append(" 'IPD-RMOBILLING','10') ");
                                        else
                                            sb.Append(" 'IPD-BILLING','7') ");
                                    }
                                    else
                                        sb.Append(" 'IPD-BILLING','7') ");

                                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                    {
                                        Tranx.Rollback();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (chkPanelGroup > 0)
            {
                StringBuilder sbSch = new StringBuilder();

                //Create Event for Auto Scheduler

                if (rblRunSche.SelectedValue == "1")
                {
                    sbSch.Append("DROP Event IF EXISTS `AutoScheduler_24Hour_Basis`");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbSch.ToString());

                    sbSch = new StringBuilder();
                    sbSch.Append("CREATE EVENT `AutoScheduler_24Hour_Basis` ON SCHEDULE EVERY 10 MINUTE STARTS ");
                    sbSch.Append(" '" + DateTime.Now.ToString("yyyy-MM-dd") + "' ");
                    sbSch.Append(" ON COMPLETION NOT PRESERVE ENABLE DO BEGIN ");
                    sbSch.Append(" CALL sp_Run_Scheduler(); ");
                    sbSch.Append(" END");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbSch.ToString());
                }
                else
                {
                    sbSch.Append("DROP Event IF EXISTS `AutoScheduler_SpecificTime_Basis`");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbSch.ToString());

                    sbSch = new StringBuilder();
                    sbSch.Append("CREATE EVENT `AutoScheduler_SpecificTime_Basis` ON SCHEDULE EVERY 1 Day STARTS ");
                    sbSch.Append(" '" + Util.GetDateTime(txtSpecificTime.Text).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                    sbSch.Append(" ON COMPLETION NOT PRESERVE ENABLE DO BEGIN ");
                    sbSch.Append(" CALL sp_Run_Scheduler(); ");
                    sbSch.Append(" END");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbSch.ToString());
                }

                Tranx.Commit();
                lblMsg.Text = "Record Saved Successfully";
            }
            else
            {
                lblMsg.Text = "Please Select Panel Group";
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtItem.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Item";
            txtItem.Focus();
            return;
        }
        DataTable dt = (DataTable)ViewState["Scheduler"];
        DataTable item = StockReports.GetDataTable("SELECT ItemID ID,'0' IsConfig,TypeName Name FROM F_ItemMaster WHERE TypeName='" + txtItem.Text.Trim() + "' AND SubCategoryID='81' AND IsActive=1 ");
        if (item.Rows.Count == 0)
        {
            lblMsg.Text = "Please Add Valid Item";
            txtItem.Focus();
            return;
        }
        string ItemID = item.Rows[0]["ID"].ToString();
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow drItem in dt.Rows)
            {
                if ((ItemID == drItem["ID"].ToString()) && (drItem["IsConfig"].ToString() == "0"))
                {
                    lblMsg.Text = "Item Already Selected";
                    return;
                }
            }
        }
        DataRow dr = dt.NewRow();
        dr["ID"] = item.Rows[0]["ID"].ToString();
        dr["IsConfig"] = item.Rows[0]["IsConfig"].ToString();
        dr["Name"] = item.Rows[0]["Name"].ToString();
        dt.Rows.Add(dr);
        dt.AcceptChanges();
        grdSc.DataSource = dt;
        grdSc.DataBind();
        ViewState["Scheduler"] = dt;
        txtItem.Text = "";
    }

    private DataTable bindHeader()
    {
        DataTable inputTable = StockReports.GetDataTable("SELECT Name,IPDCaseTypeID FROM ipd_case_type_master WHERE IsActive=1");
        DataRow dr = inputTable.NewRow();
        dr["Name"] = "Admission";
        dr["IPDCaseTypeID"] = "0";
        inputTable.Rows.Add(dr);
        DataRow dr1 = inputTable.NewRow();
        dr1["Name"] = "Scheduler";
        dr1["IPDCaseTypeID"] = "0";
        inputTable.Rows.Add(dr1);
        return inputTable;
    }

    protected void grdSc_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[2].Visible = false;
            e.Row.Cells[3].Visible = false;
            e.Row.Cells[4].Visible = false;
            DataTable dt = bindHeader();
            ViewState["SchedulerHeader"] = dt;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Label lbl = new Label();
                TableCell headerCell = new TableCell();
                lbl.Text = dt.Rows[i]["Name"].ToString();
                lbl.ID = dt.Rows[i]["IPDCaseTypeID"].ToString();
                headerCell.Font.Bold = true;
                headerCell.Controls.Add(lbl);
                e.Row.Cells.Add(headerCell);
            }
        }
        else if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataTable dt = (DataTable)ViewState["SchedulerHeader"];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CheckBox chk = new CheckBox();
                TableCell dataCell = new TableCell();
                chk.EnableViewState = true;
                chk.ID = "chk_" + (Convert.ToInt32(i + 1)).ToString();
                dataCell.Controls.Add(chk);
                e.Row.Cells.Add(dataCell);
            }
        }
    }
}