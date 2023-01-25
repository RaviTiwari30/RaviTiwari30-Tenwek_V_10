using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_sms_smsmaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binTemplate();
            ViewState["smscontent"] = "";
            ViewState["columnInfo"] = "";
            bindSms();
        }
    }

    private void binTemplate()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,SetName,PatientInfo,ColumnInfo FROM sms_Setmaster WHERE IsActive=1  ");
        if (dt.Rows.Count > 0)
        {
            ddlTemplateName.DataSource = dt;
            ddlTemplateName.DataTextField = "SetName";
            ddlTemplateName.DataValueField = "ID";
            ddlTemplateName.DataBind();
            ddlTemplateName.Items.Insert(0, new ListItem("Select", "0"));
            ViewState["TemplateName"] = dt;
        }
        else
        {
            ViewState["TemplateName"] = "";
        }
    }

    private void bindPatientInfo()
    {
        ddlPatientInfo.Items.Clear();
        if (ddlTemplateName.SelectedIndex > 0)
        {
            DataTable TemplateName = (DataTable)ViewState["TemplateName"];
            DataTable dt = new DataTable();
            dt = TemplateName.AsEnumerable().Where(r => r.Field<int>("ID") == Util.GetInt(ddlTemplateName.SelectedValue)).CopyToDataTable();

            int len = Util.GetInt(dt.Rows[0]["PatientInfo"].ToString().Split('#').Length);
            string[] PatientInfo = new string[len];
            PatientInfo = dt.Rows[0]["PatientInfo"].ToString().Split('#');

            string[] ColumnInfo = new string[len];
            ColumnInfo = dt.Rows[0]["ColumnInfo"].ToString().Split('#');
            for (int i = 0; i < len; i++)
            {
                ddlPatientInfo.Items.Insert(i, new ListItem(PatientInfo[i].ToString(), ColumnInfo[i].ToString()));
            }
            ddlPatientInfo.Items.Insert(0, new ListItem("", "0"));
            ddlPatientInfo.SelectedIndex = 0;
        }
    }

    protected void ddlTemplateName_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPatientInfo();
    }

    protected void bindSms()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id ,templatename,sms,recipient,extrarecipient,active,templateID FROM sms_master WHERE active=1");

        if (dt.Rows.Count > 0)
        {
            grdsms.DataSource = dt;
            grdsms.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            pnlHide.Visible = false;
        }
    }

    protected void grdsms_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int tempid = Util.GetInt(e.CommandArgument);
        DataTable dt = StockReports.GetDataTable("SELECT id ,templatename,sms,recipient,extrarecipient,active,templateID FROM sms_master WHERE  id='" + tempid + "' AND  active=1");

        if (dt.Rows.Count > 0)
        {
        }
        else
        {
            lblMsg.Text = "Something Wrong Happen Please Contact EDP";
            return;
        }

        if (e.CommandName == "AEdit")
        {
            ddlTemplateName.SelectedIndex = ddlTemplateName.Items.IndexOf(ddlTemplateName.Items.FindByValue(dt.Rows[0]["templateID"].ToString()));
            bindPatientInfo();
            //   txtTemplateName.Text = dt.Rows[0]["templatename"].ToString();
            txtContentSMS.Text = dt.Rows[0]["sms"].ToString();
            ddlReceipient.SelectedIndex = ddlReceipient.Items.IndexOf(ddlReceipient.Items.FindByText(dt.Rows[0]["recipient"].ToString()));
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            lblSMSId.Text = Util.GetString(tempid);
            txtContentSMS.ReadOnly = false;
        }

        if (e.CommandName == "Acancel")
        {
            StockReports.ExecuteDML("UPDATE sms_master SET active=0 WHERE id='" + tempid + "' ");
            bindSms();
            lblMsg.Text = "Template Cancel Sucessfully";
        }
    }

    protected void btnAppend_Click(object sender, EventArgs e)
    {
        StringBuilder strcontent = new StringBuilder();
        StringBuilder smscontent = new StringBuilder();
        if (ddlPatientInfo.SelectedItem.Text != "")
            strcontent.Append(txtContent.Text + " " + "<" + ddlPatientInfo.SelectedItem.Text + ">" + " ");
        else
            strcontent.Append(txtContent.Text);
        if (ViewState["smscontent"].ToString() != "")
        {
            smscontent.Append(ViewState["smscontent"]);
            ViewState["smscontent"] = smscontent + strcontent.ToString();
        }
        else
        {
            ViewState["smscontent"] = strcontent;
            txtContentSMS.Text = strcontent.ToString();
        }
        if (ViewState["smscontent"].ToString() != "")
        {
            StringBuilder strnew = new StringBuilder();
            strnew.Append(ViewState["smscontent"]);
            txtContentSMS.Text = strnew.ToString();
            ddlTemplateName.Enabled = false;
        }

        if (ddlPatientInfo.SelectedItem.Text != "")
        {
            if (ViewState["columnInfo"].ToString() == "")
                ViewState["columnInfo"] = ddlPatientInfo.SelectedValue;
            else
                ViewState["columnInfo"] = "#" + ViewState["columnInfo"].ToString();
        }
        txtContent.Text = "";
    }

    protected void btnRemove_Click(object sender, EventArgs e)
    {
        txtContentSMS.Text = "";
        ViewState["smscontent"] = "";
    }

    protected void clear()
    {
        txtExtraReciepient.Text = "";
       // ddlTemplateName.SelectedIndex = 0;
        txtContent.Text = "";
        ViewState.Clear();
       // lblMsg.Text = "";
        txtContentSMS.Text = "";
        ddlPatientInfo.Items.Clear();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlTemplateName.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Enter Template Name ";
                return;
            }
            StringBuilder sms = new StringBuilder();
            sms.Append(txtContentSMS.Text);
            StringBuilder sb = new StringBuilder();


            ViewState["columnInfo"] = StockReports.ExecuteScalar("SELECT s.ColumnInfo FROM sms_setmaster s WHERE s.ID=" + ddlTemplateName.SelectedItem.Value);


            sb.Append("insert into sms_master(templatename,sms,recipient,extrarecipient,CreatedBy,IPAddress,templateID,columnInfo)values('" + ddlTemplateName.SelectedItem.Text + "','" + sms.ToString() + "','" + ddlReceipient.SelectedItem.Text + "','" + txtExtraReciepient.Text + "','" + Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "','" + ddlTemplateName.SelectedItem.Value + "','" + ViewState["columnInfo"].ToString() + "') ");

            StockReports.ExecuteDML(sb.ToString());
            lblMsg.Text = "Record Saved Successfully";
            bindSms();
            clear();
            btnUpdate.Visible = false;
            btnSave.Visible = true;
        }
        catch { }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        ViewState["columnInfo"] = StockReports.ExecuteScalar("SELECT s.ColumnInfo FROM sms_setmaster s WHERE s.ID=" + ddlTemplateName.SelectedItem.Value);

        sb.Append(" UPDATE sms_master SET templatename='" + ddlTemplateName.SelectedItem.Text + "' ,recipient='" + ddlReceipient.SelectedItem.Text + "',UpdatedBy='" + Session["ID"].ToString() + "', ");
        sb.Append(" sms='" + txtContentSMS.Text + "',extrarecipient='" + txtExtraReciepient.Text + "',columnInfo='" + ViewState["columnInfo"].ToString() + "' WHERE ID=" + lblSMSId.Text + "");

        StockReports.ExecuteDML(sb.ToString());
        lblMsg.Text = "Record Updated Successfully";
        bindSms();
        clear();
        btnUpdate.Visible = false;
        btnSave.Visible = true;
    }
}