using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_LeaveMaster : System.Web.UI.Page
{
    protected void BindLeaves()
    {
        DataTable dt = StockReports.GetDataTable("select * FROM Pay_LeaveMaster order by SerialNo");
        if (dt.Rows.Count > 0)
        {
            grdLeave.DataSource = dt;
            grdLeave.DataBind();
            ViewState["LeaveName"] = dt;
        }
        else
        {
            grdLeave.DataSource = null;
            grdLeave.DataBind();

            ViewState["LeaveName"] = null;
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='LeaveMaster.aspx';", true);
    }

    protected void btnLeaveSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        int Count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from pay_leavenamemaster where LeaveName='" + txtLeaveName.Text.Trim() + "'"));
        if (Count > 0)
        {
            lblMsg.Text = "Leave Name Already Exist";
            txtLeaveName.Text = "";
            txtLeaveDescription.Text = "";
        }
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string Leave = "Insert INTO pay_leavenamemaster (LeaveName,LeaveDescription,CreatedBy)VALUES('" + txtLeaveName.Text.Trim() + "','" + txtLeaveDescription.Text.Trim() + "','" + Session["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, Leave);
                tranX.Commit();
                BindLeaveMaster();
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void btnSaveRecord_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        try
        {
            string sql = "INSERT INTO pay_leavemaster(NAME,Employee_Group_ID,Grade,NoOfLeave,LeaveFrom,LeaveTo,MinLimit,MaxContinuoslyLimit,MaxContinuoslyLimit2,Accumulated,encashed,PaidLeave,UserID,SerialNo,IsActive,ApplicableAfter,ApplicableAfterType,Gape,Experience_From,Experience_To)	VALUES('" + ddlLeaveName.SelectedItem.Text + "','" + ddlUserGroup.SelectedItem.Value + "',0,'" + txtNoOfLeave.Text + "','" + "2001-" + Util.GetDateTime(Request.Form[txtDateMonthFrom.UniqueID]).ToString("MM-dd") + "','2020-" + Util.GetDateTime(Request.Form[txtDateMonthTo.UniqueID]).ToString("MM-dd") + "','" + txtMinLimit.Text + "','" + txtMaxContinuoslyLimit.Text + "','" + txtMaxContinuoslyLimit2.Text + "','" + ddlAccumulated.SelectedValue + "','" + ddlEncashed.SelectedValue + "','" + ddlPaidLeave.SelectedValue + "','" + Session["ID"].ToString() + "','" + txtSrNo.Text + "','" + rbtnActive.SelectedValue + "','" + txtLeaveApplicable.Text + "','" + ddlApplicableType.SelectedItem.Value + "','" + txtGape.Text + "','" + txtFromExperience.Text.Trim() + "','" + txtToExperience.Text.Trim() + "');";
            StockReports.ExecuteDML(sql);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            BindLeaves();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='LeaveMaster.aspx';", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnUpdate_Click1(object sender, EventArgs e)
    {
        try
        {
            if (CheckFromDate("2001-" + Util.GetDateTime(txtDateMonthFrom.Text).ToString("MM-dd")) == false)
            {
                lblMsg.Text = "Please Select Valid Leave From";
                txtDateMonthFrom.Focus();
                return;
            }
            if (CheckToDate("2050-" + Util.GetDateTime(txtDateMonthTo.Text).ToString("MM-dd")) == false)
            {
                lblMsg.Text = "Please Select Valid Leave To";
                calDateMonthTo.Focus();
                return;
            }
        }
        catch
        {
        }
        if (ViewState["LeaveName"] != null)
        {
            try
            {
                DataTable dt = (DataTable)ViewState["LeaveName"];
                int args = (int)ViewState["selectedrow"];

                string str = "UPDATE pay_leavemaster SET NAME = '" + ddlLeaveName.SelectedItem.Text + "' ,Employee_Group_ID='" + ddlUserGroup.SelectedItem.Value + "' ,NoOfLeave = '" + txtNoOfLeave.Text + "' ,LeaveFrom = DATE('2001-" + Util.GetDateTime(txtDateMonthFrom.Text).ToString("MM-dd") + "') ,LeaveTo =  DATE('2050-" + Util.GetDateTime(txtDateMonthTo.Text).ToString("MM-dd") + "') ,	MinLimit = '" + txtMinLimit.Text + "' ,	MaxContinuoslyLimit = '" + txtMaxContinuoslyLimit.Text + "',MaxContinuoslyLimit2='" + txtMaxContinuoslyLimit2.Text + "' ,Accumulated = '" + ddlAccumulated.SelectedValue + "' , encashed = '" + ddlEncashed.SelectedValue + "' ,PaidLeave = '" + ddlPaidLeave.SelectedValue + "' ,UserID = '" + Session["ID"].ToString() + "' ,SerialNo = '" + txtSrNo.Text + "' , IsActive = '" + rbtnActive.SelectedValue + "',ApplicableAfter='" + txtLeaveApplicable.Text + "',ApplicableAfterType='" + ddlApplicableType.SelectedItem.Value + "',Gape='" + txtGape.Text.Trim() + "' WHERE	ID = '" + dt.Rows[args]["ID"].ToString() + "'";
                bool result = StockReports.ExecuteDML(str);
                if (result)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

                    BindLeaves();
                    btnSave.Visible = false;
                    btnUpdate.Visible = true;
                    btnCancel.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='LeaveMaster.aspx';", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }

    protected bool CheckFromDate(String date)
    {
        try
        {
            DateTime dateTime;
            if (DateTime.TryParse(date, out dateTime))
                return true;
            else
                return false;
        }
        catch
        {
            lblMsg.Text = "Please Select Valid Leave From";
            txtDateMonthFrom.Focus();
            return false;
        }
    }

    protected bool CheckToDate(String date)
    {
        try
        {
            DateTime dateTime;
            if (DateTime.TryParse(date, out dateTime))
                return true;
            else
                return false;
        }
        catch
        {
            lblMsg.Text = "Please Select Valid Leave From";
            txtDateMonthFrom.Focus();
            return false;
        }
    }

    protected void grdLedgerName_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        btnSave.Visible = false;

        if (ViewState["LeaveName"] != null)
        {
            DataTable dt = (DataTable)ViewState["LeaveName"];

            int args = Util.GetInt(e.CommandArgument);
            ViewState["selectedrow"] = args;
            ddlLeaveName.SelectedIndex = ddlLeaveName.Items.IndexOf(ddlLeaveName.Items.FindByText(dt.Rows[args]["Name"].ToString()));
            txtNoOfLeave.Text = dt.Rows[args]["NoOfLeave"].ToString();
            ddlUserGroup.SelectedIndex = ddlUserGroup.Items.IndexOf(ddlUserGroup.Items.FindByValue(dt.Rows[args]["Employee_Group_ID"].ToString()));
            txtMaxContinuoslyLimit.Text = dt.Rows[args]["MaxContinuoslyLimit"].ToString();
            ddlAccumulated.SelectedIndex = ddlAccumulated.Items.IndexOf(ddlAccumulated.Items.FindByValue(dt.Rows[args]["Accumulated"].ToString()));
            ddlEncashed.SelectedIndex = ddlEncashed.Items.IndexOf(ddlEncashed.Items.FindByValue(dt.Rows[args]["encashed"].ToString()));
            ddlPaidLeave.SelectedIndex = ddlPaidLeave.Items.IndexOf(ddlPaidLeave.Items.FindByValue(dt.Rows[args]["PaidLeave"].ToString()));
            // ddlDateFrom.SelectedIndex = ddlDateFrom.Items.IndexOf(ddlDateFrom.Items.FindByValue(Util.GetInt(Util.GetDateTime(dt.Rows[args]["LeaveFrom"]).Day).ToString()));
            //  ddlMonthFrom.SelectedIndex = ddlMonthFrom.Items.IndexOf(ddlMonthFrom.Items.FindByValue(Util.GetString(Util.GetDateTime(dt.Rows[args]["LeaveFrom"]).Month)));
            //  ddlDateTo.SelectedIndex = ddlDateTo.Items.IndexOf(ddlDateTo.Items.FindByValue(Util.GetInt(Util.GetDateTime(dt.Rows[args]["LeaveTo"]).Day).ToString()));
            //   ddlMonthTo.SelectedIndex = ddlMonthTo.Items.IndexOf(ddlMonthTo.Items.FindByValue(Util.GetString(Util.GetDateTime(dt.Rows[args]["LeaveTo"]).Month)));
            //  int LeaveTo= Util.GetDateTime(dt.Rows[args]["LeaveTo"]).Day;
            ddlApplicableType.SelectedIndex = ddlApplicableType.Items.IndexOf(ddlApplicableType.Items.FindByValue(Util.GetString(dt.Rows[args]["ApplicableAfterType"])));
            txtLeaveApplicable.Text = dt.Rows[args]["ApplicableAfter"].ToString();
            txtMinLimit.Text = dt.Rows[args]["MinLimit"].ToString();
            txtSrNo.Text = dt.Rows[args]["SerialNo"].ToString();
            txtMaxContinuoslyLimit2.Text = dt.Rows[args]["MaxContinuoslyLimit2"].ToString();
            rbtnActive.SelectedIndex = rbtnActive.Items.IndexOf(rbtnActive.Items.FindByValue(dt.Rows[args]["IsActive"].ToString()));
            txtGape.Text = dt.Rows[args]["Gape"].ToString();
            txtFromExperience.Text = dt.Rows[args]["Experience_From"].ToString();
            txtToExperience.Text = dt.Rows[args]["Experience_To"].ToString();
            txtDateMonthFrom.Text = Util.GetDateTime(dt.Rows[args]["LeaveFrom"]).ToString("dd-MMM");
            txtDateMonthTo.Text = Util.GetDateTime(dt.Rows[args]["LeaveTo"]).ToString("dd-MMM");
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLeaves();
         //   AllLoadDate_Payroll.BindGradePay(ddlGrade);
            BindUserGroup();
            BindLeaveMaster();
            txtDateMonthFrom.Text = "01-Jan";
            txtDateMonthTo.Text = "31-Dec";
        }
        txtDateMonthFrom.Attributes.Add("readonly", "readonly");
        txtDateMonthTo.Attributes.Add("readonly", "readonly");
    }

    private void BindUserGroup()
    {
        DataTable dt = StockReports.GetDataTable("  select Name,ID,if(IsActive=1,'Yes','No')IsActive,NoticeDays,ProbationDays from Employee_Group_master order by Name");
        ddlUserGroup.DataSource = dt;
        ddlUserGroup.DataTextField = "Name";
        ddlUserGroup.DataValueField = "ID";
        ddlUserGroup.DataBind();
        ddlUserGroup.Items.Insert(0, new ListItem("Select"));
    }

    private void BindLeaveMaster()
    {
        DataTable Leave = StockReports.GetDataTable("Select ID,LeaveName from pay_leavenamemaster where IsActive=1");
        if (Leave.Rows.Count > 0)
        {
            ddlLeaveName.DataTextField = "LeaveName";
            ddlLeaveName.DataValueField = "ID";
            ddlLeaveName.DataSource = Leave;
            ddlLeaveName.DataBind();
            ddlLeaveName.Items.Insert(0, "Select");
        }
    }
}