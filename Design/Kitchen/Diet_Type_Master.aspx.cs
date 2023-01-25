using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_Kitchen_Diet_Type_Master : System.Web.UI.Page
    {
    protected void BindDetail()
        {
        lblmsg.Text = "";
        DataTable dtDetail = StockReports.GetDataTable(" Select DietID,Name,Description,IF(IsPanelApproved=1,'Private','Normal')IsPanelApproved,IF(IsActive=1,'Yes','No')IsActive,Min,Max FROM diet_DietType_master ORDER BY Name");
        if (dtDetail.Rows.Count > 0)
            {
            grdDetail.DataSource = dtDetail;
            grdDetail.DataBind();
            pnlHide.Visible = true;
            }
        else
            {
            grdDetail.DataSource = "";
            grdDetail.DataBind();
            pnlHide.Visible = false;
            }
        }

    protected void btnCancel_Click(object sender, EventArgs e)
        {
        Clear();
        lblmsg.Text = "";
        }

    protected void btnSave_Click(object sender, EventArgs e)
        {
        try
            {
            lblmsg.Text = "";
            if (!Validation())
                {
                return;
                }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert Into diet_DietType_master(Name,Description,IsActive,Min,Max,CreatedBy,IsPanelApproved)");
            sb.Append(" Values('" + txtTypeName.Text.Trim() + "','" + txtDescription.Text.Trim() + "'," + rblActive.SelectedItem.Value + "," + txtMin.Text.Trim() + "," + txtMax.Text + ",'" + Session["ID"].ToString() + "'," + rblIsPanelApproved.SelectedItem.Value + ")");
            bool IsInsert = StockReports.ExecuteDML(sb.ToString());

            if (!IsInsert)
                {
                lblmsg.Text = "Error occurred, Please contact administrator";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
                return;
                }
            else
                {
                BindDetail();
                lblmsg.Text = "Record Saved Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
                Clear();
                }
            }

        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);

            }
        }

    protected void btnUpdate_Click(object sender, EventArgs e)
        {
        try
            {
            lblmsg.Text = "";
            if (txtTypeName.Text.Trim() == "")
                {
                lblmsg.Text = "Enter Diet Type Name";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Enter Diet Type Name');", true);
                return;
                }
            else if (txtMin.Text == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Enter Min Value');", true);
                lblmsg.Text = "Enter Min Value";
                return;
                }
            else if (txtMax.Text == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Enter Max Value');", true);
                lblmsg.Text = "Enter Max Value";
                return;
                }
            int ChkNameforUpdate = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From diet_DietType_master where name='" + txtTypeName.Text.Trim() + "' AND DietID !='" + lblID.Text + "' "));
            if (ChkNameforUpdate > 0)
                {
                lblmsg.Text = "Diet Type Already Exists";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Type Already Exists');", true);
                return;
                }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update diet_DietType_master Set");
            sb.Append(" name='" + txtTypeName.Text.Trim() + "',Description='" + txtDescription.Text.Trim() + "',IsPanelApproved=" + rblIsPanelApproved.SelectedItem.Value + ",IsActive=" + rblActive.SelectedItem.Value + ",Min=" + txtMin.Text.Trim() + ",Max=" + txtMax.Text + " where DietID=" + lblID.Text + "");
            bool IsUpdate = StockReports.ExecuteDML(sb.ToString());

            if (!IsUpdate)
                {
                lblmsg.Text = "Error occurred, Please contact administrator";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
                return;
                }
            else
                {
                BindDetail();
                lblmsg.Text = "Record Updated Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
                Clear();
                }
            }

        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);

            }
        }

    protected void Clear()
        {
        txtTypeName.Text = "";
        txtDescription.Text = "";
        lblID.Text = "";
        rblActive.SelectedValue = "1";
        txtMax.Text = "0";
        txtMin.Text = "0";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        }

    protected void grdDetail_SelectedIndexChanged(object sender, EventArgs e)
        {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        string[] s = ((Label)grdDetail.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        lblID.Text = s[0].ToString();
        txtTypeName.Text = s[1].ToString();
        txtDescription.Text = s[2].ToString();
        if (s[3].ToString() == "Yes")
            rblActive.SelectedIndex = 0;
        else
            rblActive.SelectedIndex = 1;
        txtMin.Text = s[4].ToString();
        txtMax.Text = s[5].ToString();
        if (s[6].ToString() == "Normal")
            rblIsPanelApproved.SelectedIndex = 0;
        else
            rblIsPanelApproved.SelectedIndex = 1;
        }

    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            BindDetail();
            btnUpdate.Visible = false;
            btnSave.Visible = true;
            }
        }

    protected bool Validation()
        {
        if (txtTypeName.Text.Trim() == "")
            {
            lblmsg.Text = "Please Enter Diet Type Name";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Diet Type Name');", true);

            return false;
            }
        else if (txtMin.Text == "")
            {
            lblmsg.Text = "Please Enter Min Value";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Min Value');", true);
            return false;
            }
        else if (txtMax.Text == "")
            {
            lblmsg.Text = "Please Enter Max Value";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Max Value');", true);
            return false;
            }
        int ChkNameforUpdate = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM diet_DietType_master WHERE name='" + txtTypeName.Text.Trim() + "'"));
        if (ChkNameforUpdate > 0)
            {
            lblmsg.Text = "Diet Type Already Exists";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Type Already Exists');", true);
            return false;
            }
        else
            return true;
        }
    }