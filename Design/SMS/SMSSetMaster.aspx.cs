using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_SMS_SMSSetMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPatientInfo();
            bindSMSSetMaster();
        }
    }

    private void bindSMSSetMaster()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,SetName,PatientInfo,IF(IsActive=1,'Yes','No')IsActive,ColumnInfo FROM sms_setmaster ");
        if (dt.Rows.Count > 0)
        {
            grdSMSSet.DataSource = dt;
            grdSMSSet.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdSMSSet.DataSource = null;
            grdSMSSet.DataBind();
            pnlHide.Visible = false;
        }
    }

    private void bindPatientInfo()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(ID,'#',ColumnName)ID,ContentInfoName FROM sms_contentinfomaster WHERE IsActive=1");
        if (dt.Rows.Count > 0)
        {
            chklInfo.DataSource = dt;
            chklInfo.DataTextField = "ContentInfoName";
            chklInfo.DataValueField = "ID";
            chklInfo.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string chk = ""; string chkID = "";
        if (chklInfo.SelectedIndex >= 0)
        {
            foreach (ListItem li in chklInfo.Items)
            {
                if (li.Selected == true)
                {
                    if (chk != string.Empty)
                    {
                        chk += "#" + li.Text + "";
                        chkID += "#" + li.Value.Split('#')[1] + "";
                    }
                    else
                    {
                        chk = "" + li.Text + "";
                        chkID += "" + li.Value.Split('#')[1] + "";
                    }
                }
            }
        }
        if (chk == "")
        {
            lblMsg.Text = "Please Check Patient Info";
            return;
        }
        if (btnSave.Text == "Save")
        {
            StockReports.ExecuteDML("insert into sms_Setmaster(SetName,CreatedBy,PatientInfo,ColumnInfo)VALUES('" + txtSetName.Text.Trim() + "','" + Session["ID"].ToString() + "','" + chk + "','" + chkID + "') ");
            lblMsg.Text = "Record Saved Successfully";
        }
        else if (btnSave.Text == "Update")
        {
            StockReports.ExecuteDML("UPDATE sms_Setmaster SET SetName='" + txtSetName.Text.Trim() + "',PatientInfo='" + chk + "',IsActive='" + rdoActive.SelectedItem.Value + "',ColumnInfo='" + chkID + "' WHERE ID=" + lblSetID.Text.Trim() + " ");
            lblMsg.Text = "Record Updated Successfully";
        }

        bindSMSSetMaster();
        clear();
    }

    protected void grdSMSSet_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtSetName.Text = ((Label)grdSMSSet.SelectedRow.FindControl("lblSetName")).Text;
        string patientInfo = ((Label)grdSMSSet.SelectedRow.FindControl("lblPatientInfo")).Text;
        trActive.Visible = true;

        rdoActive.SelectedIndex = rdoActive.Items.IndexOf(rdoActive.Items.FindByText(((Label)grdSMSSet.SelectedRow.FindControl("lblIsActive")).Text));

        int len = Util.GetInt(patientInfo.ToString().Split('#').Length);
        string[] Item = new string[len];
        Item = patientInfo.ToString().Split('#');

        for (int i = 0; i < len; i++)
        {
            for (int k = 0; k <= chklInfo.Items.Count - 1; k++)
            {
                if (Item[i] == chklInfo.Items[k].Text)
                {
                    chklInfo.Items[k].Selected = true;
                }
            }
        }
        lblSetID.Text = ((Label)grdSMSSet.SelectedRow.FindControl("lblSetID")).Text;
        btnSave.Text = "Update";
        btnCancel.Visible = true;
        lblMsg.Text = "";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clear();
        lblMsg.Text = "";
    }

    private void clear()
    {
        txtSetName.Text = "";
        btnCancel.Visible = false;
        btnSave.Text = "Save";
        trActive.Visible = false;
        foreach (ListItem li in chklInfo.Items)
        {
            li.Selected = false;
        }
    }
}