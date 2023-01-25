using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Email_EmailBodyMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                All_LoadData.bindRole(ddlDepartment, "Select");
                BindTemplate();
                BindEmailID();
                All_LoadData.bindPanel(ddlPanel, "Select");
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    protected void ddlTemplatetype_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            var isPanelWise = StockReports.ExecuteScalar("SELECT em.IsPanelWise FROM email_templatemaster em WHERE em.ID=" + ddlTemplatetype.SelectedItem.Value);
            if (Util.GetInt(isPanelWise) == 1)
                ddlPanel.Enabled = true;
            else
            {
                ddlPanel.SelectedValue = "0";
                ddlPanel.Enabled = false;
            }


            BindEmailDetails();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += "#'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }
        return str;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlEmailID.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select The Email ID";
            ddlEmailID.Focus();
            return;
        }
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) from email_master WHere RoleID ='" + ddlDepartment.SelectedValue + "' AND TemplateID='" + ddlTemplatetype.SelectedValue + "'"));
            if (count == 0)
            {
                if (txtStoreProcedureName.Text != "")
                {
                    StringBuilder sbStr = new StringBuilder();
                    sbStr.Append("DROP PROCEDURE IF EXISTS " + txtStoreProcedureName.Text.Trim() + " ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbStr.ToString());
                    sbStr = new StringBuilder();
                    sbStr.Append("CREATE ");
                    sbStr.Append("PROCEDURE " + txtStoreProcedureName.Text.Trim() + "() ");
                    sbStr.Append("BEGIN ");
                    sbStr.Append("" + txtStoreProcedure.Text.Trim() + "; ");
                    sbStr.Append("END; ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbStr.ToString());
                }
                if (lblTemplatetype.Text.Trim() == "1" || lblTemplatetype.Text.Trim() == "2")
                {
                    DateTime Eventdatetime = new DateTime();
                    if (lblEventDate.Text != "01-01-0001")
                    {
                        Eventdatetime = Util.GetDateTime(lblEventDate.Text + " " + lblEventTime.Text);
                    }
                    else
                    {
                        Eventdatetime = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd") + " " + lblEventTime.Text);
                    }
                    string eventschedule = string.Empty;
                    if (lblTemplatetype.Text.Trim() == "1")
                    {
                        eventschedule = lblEmail_repeat.Text;
                    }
                    if (lblTemplatetype.Text.Trim() == "2")
                    {
                        eventschedule = lblEmail_repeat.Text;
                    }
                    StringBuilder sbevt = new StringBuilder();
                    sbevt.Append("DROP Event IF EXISTS " + ddlDepartment.SelectedItem.Text + "_" + ddlTemplatetype.SelectedItem.Text.Replace(" ","_") + "");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbevt.ToString());
                    sbevt = new StringBuilder();
                    sbevt.Append("CREATE EVENT " + ddlDepartment.SelectedItem.Text + "_" + ddlTemplatetype.SelectedItem.Text.Replace(" ", "_") + " ON SCHEDULE " + eventschedule + " ");
                    sbevt.Append(" '" + Util.GetDateTime(Eventdatetime).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                    sbevt.Append(" ON COMPLETION NOT PRESERVE ENABLE DO BEGIN ");
                    sbevt.Append(" INSERT INTO Email_log (FromEamilID,FromEmailPassword,smtp_host,email_port,ToEmailID,EmailSubject,EmailBody,StoreProcedureName,TemplateID,RoleID,AttachementType, ");
                    sbevt.Append(" EmailSendDate,EntryBy,ReportPath,IncludeCentreLogo,ErrorNotifyEmail) ");
                    sbevt.Append(" ( ");
                    sbevt.Append(" SELECT emm.FromEmailID,emm.FromEmailPassword,emm.FromEmailSmtp,emm.FromEmailPort, ");
                    sbevt.Append(" IF(etm.EmailTO=3,etm.Email,(SELECT Email FROM employee_master WHERE Employee_ID=etm.Email))ToEmailID,emm.EmailSubject,emm.EmailBody, ");
                    sbevt.Append(" emm.StoreProcedureName,emm.TemplateID,emm.RoleID,emm.AttachementType,NOW(),'EMP002',emm.ReportPath,emm.IncludeCentreLogo,emm.ErrorNotifyEmail FROM email_templatemaster et  ");
                    sbevt.Append(" INNER JOIN email_master emm  ON emm.TemplateID=et.ID ");
                    sbevt.Append(" INNER JOIN email_typemaster etm ON etm.TemplateName=et.ID ");
                    sbevt.Append(" WHERE et.ID='" + ddlTemplatetype.SelectedValue + "' AND RoleID='" + ddlDepartment.SelectedValue + "' ");
                    sbevt.Append(" ); ");
                    sbevt.Append(" END");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbevt.ToString());
                }
                int IncludeCentreLogo = 0;
                if(chkcentreheader.Checked)
                    IncludeCentreLogo = 1;
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO email_master (RoleID,TemplateID,FromEmailID,FromEmailPassword,FromEmailPort,FromEmailSmtp,EmailSubject, ");
                sb.Append("EmailBody,StoreProcedureName,EntryBy,AttachementType,ReportPath,PanelID,emailmaster_id,IncludeCentreLogo,ErrorNotifyEmail) ");
                sb.Append("VALUES ('" + ddlDepartment.SelectedValue + "','" + ddlTemplatetype.SelectedValue + "','" + ddlEmailID.SelectedItem.Text + "','" + ddlEmailID.SelectedValue.Split('#')[0] + "', ");
                sb.Append("'" + ddlEmailID.SelectedValue.Split('#')[2] + "','" + ddlEmailID.SelectedValue.Split('#')[1] + "','" + txtEmailSubject.Text.Trim() + "','" + txtEmailBody.Text.Trim() + "','" + txtStoreProcedureName.Text.Trim() + "','" + Session["ID"].ToString() + "','" + ddlAttachementtype.SelectedValue + "','" + txtReportPath.Text.Trim() + "'," + ddlPanel.SelectedItem.Value + ",'" + ddlEmailID.SelectedValue.Split('#')[3] + "'," + IncludeCentreLogo + ",'"+ txtErrorEmail.Text.Trim() +"') ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                Tranx.Commit();
                lblMsg.Text = "Record Saved Successfully";
            }
            else
            {
                if (txtStoreProcedureName.Text != "")
                {
                    StringBuilder sbStr = new StringBuilder();
                    sbStr.Append("DROP PROCEDURE IF EXISTS " + txtStoreProcedureName.Text.Trim() + " ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbStr.ToString());
                    sbStr = new StringBuilder();
                    sbStr.Append("CREATE ");
                    sbStr.Append("PROCEDURE " + txtStoreProcedureName.Text.Trim() + "() ");
                    sbStr.Append("BEGIN ");
                    sbStr.Append("" + txtStoreProcedure.Text.Trim() + "; "); ;
                    sbStr.Append("END; ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbStr.ToString());
                }
                if (lblTemplatetype.Text.Trim() == "1" || lblTemplatetype.Text.Trim() == "2")
                {
                    DateTime Eventdatetime = new DateTime();
                    if (lblEventDate.Text != "01-01-0001 00:00:00")
                    {
                        Eventdatetime = Util.GetDateTime(lblEventDate.Text + " " + lblEventTime.Text);
                    }
                    else
                    {
                        Eventdatetime = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd") + " " + lblEventTime.Text);
                    }
                    string eventschedule = string.Empty;
                    if (lblTemplatetype.Text.Trim() == "1")
                    {
                        eventschedule = lblEmail_repeat.Text;
                    }
                    if (lblTemplatetype.Text.Trim() == "2")
                    {
                        eventschedule = "EVERY 1 MONTH STARTS";
                    }
                    StringBuilder sbevt = new StringBuilder();
                    sbevt.Append("DROP Event IF EXISTS " + ddlDepartment.SelectedItem.Text + "_" + ddlTemplatetype.SelectedItem.Text + "");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbevt.ToString());
                    sbevt = new StringBuilder();
                    sbevt.Append("CREATE EVENT " + ddlDepartment.SelectedItem.Text + "_" + ddlTemplatetype.SelectedItem.Text + " ON SCHEDULE " + eventschedule + " ");
                    sbevt.Append(" '" + Util.GetDateTime(Eventdatetime).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                    sbevt.Append(" ON COMPLETION NOT PRESERVE ENABLE DO BEGIN ");
                    sbevt.Append(" INSERT INTO Email_log (FromEamilID,FromEmailPassword,smtp_host,email_port,ToEmailID,EmailSubject,EmailBody,StoreProcedureName,TemplateID,RoleID,AttachementType, ");
                    sbevt.Append(" EmailSendDate,EntryBy,ReportPath,IncludeCentreLogo,ErrorNotifyEmail) ");
                    sbevt.Append(" ( ");
                    sbevt.Append(" SELECT emm.FromEmailID,emm.FromEmailPassword,emm.FromEmailSmtp,emm.FromEmailPort, ");
                    sbevt.Append(" IF(etm.EmailTO=3,etm.Email,(SELECT Email FROM employee_master WHERE Employee_ID=etm.Email))ToEmailID,emm.EmailSubject,emm.EmailBody, ");
                    sbevt.Append(" emm.StoreProcedureName,emm.TemplateID,emm.RoleID,emm.AttachementType,NOW(),'EMP002',emm.ReportPath,emm.IncludeCentreLogo,emm.ErrorNotifyEmail FROM email_templatemaster et  ");
                    sbevt.Append(" INNER JOIN email_master emm  ON emm.TemplateID=et.ID ");
                    sbevt.Append(" INNER JOIN email_typemaster etm ON etm.TemplateName=et.ID ");
                    sbevt.Append(" WHERE et.ID='" + ddlTemplatetype.SelectedValue + "' AND RoleID='" + ddlDepartment.SelectedValue + "' ");
                    sbevt.Append(" ); ");
                    sbevt.Append(" END");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbevt.ToString());
                }
                int IncludeCentreLogo = 0;
                if (chkcentreheader.Checked)
                    IncludeCentreLogo = 1;
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE email_master SET FromEmailID ='" + ddlEmailID.SelectedItem.Text + "',FromEmailPassword='" + ddlEmailID.SelectedValue.Split('#')[0] + "',FromEmailPort='" + ddlEmailID.SelectedValue.Split('#')[2] + "',FromEmailSmtp='" + ddlEmailID.SelectedValue.Split('#')[1] + "',EmailSubject='" + txtEmailSubject.Text.Trim() + "',EmailBody='" + txtEmailBody.Text.Trim() + "',StoreProcedureName='" + txtStoreProcedureName.Text.Trim() + "', ");
                sb.Append("AttachementType='" + ddlAttachementtype.SelectedValue + "',ReportPath='" + txtReportPath.Text.Trim() + "',EntryBy='" + Session["ID"].ToString() + "',EntryDate=NOW(),emailmaster_id='" + ddlEmailID.SelectedValue.Split('#')[3] + "',IncludeCentreLogo=" + IncludeCentreLogo + ",ErrorNotifyEmail='"+ txtErrorEmail.Text.Trim() +"' WHERE ID='" + lblID.Text.Trim() + "' ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                Tranx.Commit();
                lblMsg.Text = "Record Update Successfully";
            }
            Clear();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void chkCloumnField_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            string text = txtEmailBody.Text;
            string selectedvalue = string.Empty;
            foreach (ListItem item in chkCloumnField.Items)
            {
                if (item.Selected)
                {
                    selectedvalue = item.Value;
                    txtEmailBody.Text = text + "&nbsp;{" + selectedvalue + "}&nbsp;";
                    item.Selected = false;
                    return;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    private void BindEmailDetails()
    {
        try
        {
            DataTable dtTemplate = StockReports.GetDataTable("SELECT STATUS,ScheduleType,scheduleTime,scheduleDate,Email_repeat FROM email_templatemaster WHERE ID='" + ddlTemplatetype.SelectedValue + "'");
            if (dtTemplate.Rows.Count > 0)
            {
                if (dtTemplate.Rows[0]["ScheduleType"].ToString() == "2" || dtTemplate.Rows[0]["ScheduleType"].ToString() == "3")
                {
                    txtStoreProcedureName.Enabled = false;
                    txtStoreProcedure.Enabled = false;
                    txtStoreProcedureName.Text = "";
                    txtStoreProcedure.Text = "";
                    lblTemplatetype.Text = "";
                    lblEventDate.Text = "";
                    lblEventTime.Text = "";
                    lblEmail_repeat.Text = "";
                }
                else
                {
                    txtStoreProcedureName.Enabled = true;
                    txtStoreProcedure.Enabled = true;
                    txtStoreProcedureName.Text = "";
                    txtStoreProcedure.Text = "";
                    lblTemplatetype.Text = dtTemplate.Rows[0]["ScheduleType"].ToString();
                    lblEventDate.Text = Util.GetDateTime(dtTemplate.Rows[0]["scheduleDate"]).ToString("dd-MM-yyyy");
                    lblEventTime.Text = Util.GetDateTime(dtTemplate.Rows[0]["scheduleTime"]).ToString("HH:mm:ss");
                    lblEmail_repeat.Text = Util.GetString(dtTemplate.Rows[0]["Email_repeat"]);
                }

            }
            else
            {
                txtStoreProcedureName.Enabled = true;
                txtStoreProcedure.Enabled = true;
                txtStoreProcedureName.Text = "";
                txtStoreProcedure.Text = "";
                lblTemplatetype.Text = "";
                lblEventDate.Text = "";
                lblEventTime.Text = "";
                lblEmail_repeat.Text = "";
            }
            DataTable dt = StockReports.GetDataTable("SELECT ID,FromEmailID,FromEmailPassword,EmailSubject,EmailBody,StoreProcedureName, AttachementType,IncludeCentreLogo FROM email_master WHERE TemplateID='" + ddlTemplatetype.SelectedValue + "' AND RoleID='" + ddlDepartment.SelectedValue + "'");
            if (dt.Rows.Count > 0)
            {
                ddlEmailID.SelectedIndex = ddlEmailID.Items.IndexOf(ddlEmailID.Items.FindByText(dt.Rows[0]["FromEmailID"].ToString()));
                txtPassword.Text = dt.Rows[0]["FromEmailPassword"].ToString();
                txtEmailSubject.Text = dt.Rows[0]["EmailSubject"].ToString();
                txtEmailBody.Text = dt.Rows[0]["EmailBody"].ToString();
                txtStoreProcedureName.Text = dt.Rows[0]["StoreProcedureName"].ToString();
                if (txtStoreProcedureName.Text != "")
                    txtStoreProcedureName.Enabled = false;
                ddlAttachementtype.SelectedIndex = ddlAttachementtype.Items.IndexOf(ddlAttachementtype.Items.FindByValue(dt.Rows[0]["AttachementType"].ToString()));
                lblID.Text = dt.Rows[0]["ID"].ToString();
                if (dt.Rows[0]["IncludeCentreLogo"].ToString() == "1")
                {
                    chkcentreheader.Checked = true;
                }
                else
                {
                    chkcentreheader.Checked = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    private void Clear()
    {
        ddlDepartment.SelectedIndex = 0;
        ddlTemplatetype.SelectedIndex = 0;
        ddlEmailID.SelectedIndex = 0;
        txtPassword.Text = "";
        txtEmailSubject.Text = "";
        txtEmailBody.Text = "";
        txtStoreProcedureName.Text = "";
        txtStoreProcedure.Text = "";
        ddlAttachementtype.SelectedIndex = 0;
        txtStoreProcedureName.Enabled = true;
        lblID.Text = "";
        txtReportPath.Text = "";
    }
    private void BindTemplate()
    {
        try
        {
            DataTable dt = Email_Master.BindTemplate();
            if (dt.Rows.Count > 0)
            {
                ddlTemplatetype.DataSource = dt;
                ddlTemplatetype.DataTextField = "TemplateName";
                ddlTemplatetype.DataValueField = "ID";
                ddlTemplatetype.DataBind();
                ddlTemplatetype.Items.Insert(0, new ListItem("Select", "0"));
            }
            else
            {
                lblMsg.Text = "Please create template";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
    }

    private void BindEmailID()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id.EmailID,CONCAT(id.PASSWORD,'#',id.smtp_host,'#',id.email_port,'#',id.id)PASSWORD FROM Emailid_master id;");
        if (dt.Rows.Count > 0)
        {
            ddlEmailID.DataSource = dt;
            ddlEmailID.DataTextField = "EmailID";
            ddlEmailID.DataValueField = "PASSWORD";
            ddlEmailID.DataBind();
            ddlEmailID.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlEmailID.DataSource = null;
            ddlEmailID.DataTextField = "";
            ddlEmailID.DataValueField = "";
            ddlEmailID.DataBind();
            ddlEmailID.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
}