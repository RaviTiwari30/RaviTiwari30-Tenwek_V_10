using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_Rate_scheduleCharges : System.Web.UI.Page
{
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            foreach (GridViewRow gr in grdSchedule.Rows)
            {
                int i = 0;
                if (((CheckBox)gr.FindControl("chkDefault")).Checked)
                    i = 1;
                else
                    i = 0;

                string upd = " UPDATE f_rate_schedulecharges SET IsDefault=" + i + ",EditUserID='" + Session["ID"].ToString() + "' " +
                             " ,EditDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "',History=Concat(History,' Updated By ','" + Session["ID"].ToString() + "',' on ','" + DateTime.Now.ToString("yyyy-MM-dd") + "')" +
                             " WHERE ScheduleChargeID= " + ((Label)gr.FindControl("lblScheduleID")).Text + "";
                StockReports.ExecuteDML(upd);
            }

            lblMsg.Text = "Record Updated Successfully";
            loaddata();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    //==================================changes 7-10-11 ======================================
    protected void chkDefault_CheckedChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        for (int i = 0; i < grdSchedule.Rows.Count; i++)
        {
            if (((CheckBox)grdSchedule.Rows[i].FindControl("chkDefault")).Checked)
            {
                for (int j = i + 1; j < grdSchedule.Rows.Count; j++)
                {
                    if (((CheckBox)grdSchedule.Rows[j].FindControl("chkDefault")).Checked)
                    {
                        if (((Label)grdSchedule.Rows[i].FindControl("lblPanelID")).Text == ((Label)grdSchedule.Rows[j].FindControl("lblPanelID")).Text)
                        {
                            for (int x = 0; x < grdSchedule.Rows.Count; x++)
                            {
                                for (int y = x + 1; y < grdSchedule.Rows.Count; y++)
                                {
                                    if (((Label)grdSchedule.Rows[x].FindControl("lblPanelID")).Text == ((Label)grdSchedule.Rows[y].FindControl("lblPanelID")).Text)
                                    {
                                        ((CheckBox)grdSchedule.Rows[x].FindControl("chkDefault")).Checked = false;
                                        ((CheckBox)grdSchedule.Rows[y].FindControl("chkDefault")).Checked = false;
                                    }
                                }
                            }

                            lblMsg.Text = "No Two Schedule Charges can be set as default";
                            return;
                        }
                    }
                }
            }
        }
    }

    protected void ddlpanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlpanel.SelectedItem.Text.ToUpper() == "ALL")
        {
            loaddata();
        }
        else
        {
            string str = "SELECT tr.ScheduleChargeID,tr.NAME,DATE_FORMAT(tr.DateFrom,'%d-%b-%y')DateFrom,DATE_FORMAT(tr.DateTo,'%d-%b-%y')DateTo,tr.IsDefault,(tp.Company_Name)Pname,tp.PanelID  FROM f_rate_schedulecharges tr INNER JOIN f_Panel_master tp ON tr.PanelID=tp.PanelID WHERE tp.Company_Name='" + ddlpanel.SelectedItem.Text + "'";
            DataTable dtScheduleRate = StockReports.GetDataTable(str);
            grdSchedule.DataSource = dtScheduleRate;
            grdSchedule.DataBind();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            LoadPanel();
            loaddata();
            if (grdSchedule.Rows.Count == 0)
                btnUpdate.Visible = false;
            else
                btnUpdate.Visible = true;
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }

    protected void SaveRateSchedule_Click(object sender, EventArgs e)
    {
        if (ddlpanel.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }
        if (rateName.Text == "")
        {
            lblMsg.Text = "Enter Schedule Name";
            return;
        }

        int IsDefault = 0;
        if (CBCur.Checked)
        {
            foreach (GridViewRow gr in grdSchedule.Rows)
            {
                if (ddlpanel.SelectedItem.Value == ((Label)gr.FindControl("lblPanelID")).Text)
                {
                    if (((CheckBox)gr.FindControl("chkDefault")).Checked)
                    {
                        lblMsg.Text = "Please update previous default Schedule charges for the panel";
                        return;
                    }
                }
            }
            IsDefault = 1;
        }

        string save = "insert into f_rate_schedulecharges(Name,PanelID,DateFrom,DateTo,IsDefault,UserID) values('" + rateName.Text + "'," + ddlpanel.SelectedValue.ToString() + ",'" + Convert.ToDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "','" + Convert.ToDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "', " + IsDefault + ",'" + Session["ID"].ToString() + "')";
        StockReports.ExecuteDML(save);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record saved successfully.');", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='Rate_ScheduleCharges.aspx';", true);
    }

    private void loaddata()
    {
        string data = "SELECT tr.ScheduleChargeID,tr.NAME,DATE_FORMAT(tr.DateFrom,'%d-%b-%Y')DateFrom,DATE_FORMAT(tr.DateTo,'%d-%b-%Y')DateTo,tr.IsDefault,(tp.Company_Name)Pname,tp.PanelID  FROM f_rate_schedulecharges tr INNER JOIN f_Panel_master tp ON tr.PanelID=tp.PanelID";
        DataTable dtScheduleRate = StockReports.GetDataTable(data);
        grdSchedule.DataSource = dtScheduleRate;
        grdSchedule.DataBind();
    }

    private void LoadPanel()
    {
        string panelName = "SELECT Trim(Company_Name) AS Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD FROM f_panel_master WHERE PanelID IN (SELECT DISTINCT PanelID FROM (SELECT DISTINCT(ReferenceCodeOPD)PanelID FROM f_panel_master UNION ALL SELECT DISTINCT(ReferenceCode)PanelID FROM f_panel_master)t) ORDER BY Company_Name";
        DataTable dt = StockReports.GetDataTable(panelName);
        ddlpanel.DataSource = dt;
        ddlpanel.DataTextField = dt.Columns["Company_Name"].ToString();
        ddlpanel.DataValueField = dt.Columns["PanelID"].ToString();
        ddlpanel.DataBind();
        ddlpanel.Items.Insert(0, new ListItem("Select", "0"));
    }
}