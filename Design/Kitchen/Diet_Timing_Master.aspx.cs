using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Kitchen_Diet_Timing_Master : System.Web.UI.Page
{
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
        lblmsg.Text = "";
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (txtTimingName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Enter Timing Name";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Timing Name');", true);
            txtTimingName.Focus();
            return;
        }
        if (ddlOrderBefore.SelectedIndex <= 0)
        {
            lblmsg.Text = "Please Provide Order Before Hours";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Provide Order Before Hours');", true);
            ddlOrderBefore.Focus();
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        try
            {
            con.Open();
            string str = "Insert into diet_timing (NAME,Description,FromTime,ToTime,OrderBefore,IsActive,CreatedBy) VALUES ('" + txtTimingName.Text.ToString() + "','" + txtDesc.Text.ToString() + "','" + Util.GetDateTime(FromTime.Text).ToString("H:mm") + "','" + Util.GetDateTime(ToTime.Text.ToString()).ToString("H:mm") + "','" + ddlOrderBefore.SelectedValue + "','" + Util.GetInt(rblActive.SelectedValue) + "','" + Session["ID"].ToString() + "') ";
            int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
            if (result > 0)
                {
                lblmsg.Text = "Record Saved Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
                Clear();
                BindTimingGrid();
                }
            }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
            }
        finally
            {
            con.Close();
            con.Dispose();
            }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (txtTimingName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Enter Timing Name";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Timing Name');", true);
            txtTimingName.Focus();
            return;
        }
        if (ddlOrderBefore.SelectedIndex <= 0)
        {
            lblmsg.Text = "Please Provide Order Before Hours";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Provide Order Before Hours');", true);
            ddlOrderBefore.Focus();
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        try
        {
            con.Open();
            string str = "update diet_timing set NAME='" + txtTimingName.Text.ToString() + "',Description='" + txtDesc.Text.ToString() + "',FromTime='" + Util.GetDateTime(FromTime.Text).ToString("H:mm") + "',ToTime='" + Util.GetDateTime(ToTime.Text).ToString("H:mm") + "',OrderBefore='" + ddlOrderBefore.SelectedValue + "',IsActive='" + Util.GetInt(rblActive.SelectedValue) + "'  where id='" + lblId.Text.ToString() + "'";
            int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
            if (result > 0)
            {
                lblmsg.Text = "Record Updated Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
                Clear();
                BindTimingGrid();
            }
        }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
            }
        finally
            {
            con.Close();
            con.Dispose();
            }
    }

    protected void grdDetail_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnsave.Visible = false;
        btnUpdate.Visible = true;
        string[] s = ((Label)grdDetail.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        string str = "SELECT id,NAME TimeName,Description,TIME_FORMAT(fromtime,'%h:%i %p')FromTime,TIME_FORMAT(totime,'%h:%i %p')ToTime,OrderBefore,IsActive FROM diet_timing where  id='" + s[0].ToString() + "' and isActive=1";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            txtTimingName.Text = Util.GetString(dt.Rows[0]["TimeName"].ToString());
            txtDesc.Text = Util.GetString(dt.Rows[0]["Description"].ToString());
            rblActive.SelectedIndex = rblActive.Items.IndexOf(rblActive.Items.FindByValue(Util.GetString(dt.Rows[0]["IsActive"])));
            ddlOrderBefore.SelectedValue = dt.Rows[0]["OrderBefore"].ToString();
            lblId.Text = Util.GetString(dt.Rows[0]["id"].ToString());
            FromTime.Text = Util.GetString(dt.Rows[0]["FromTime"].ToString());
            ToTime.Text = Util.GetString(dt.Rows[0]["ToTime"].ToString());
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            FromTime.Text = DateTime.Now.ToString("hh:mm tt");
            ToTime.Text = DateTime.Now.ToString("hh:mm tt");
            BindTimingGrid();
        }
    }

    private void BindTimingGrid()
    {
    string str = "SELECT id,NAME TimeName,Description,TIME_FORMAT(fromTime,'%h:%i %p')FromTime,TIME_FORMAT(toTime,'%h:%i %p')ToTime,OrderBefore,IF(IsActive=1,'Yes','No')IsActive FROM diet_timing where isActive=1";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdDetail.DataSource = dt;
            grdDetail.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdDetail.DataSource = null;
            grdDetail.DataBind();
            pnlHide.Visible = false;

        }
    }

    private void Clear()
    {
        txtDesc.Text = "";
        txtTimingName.Text = "";
        ddlOrderBefore.SelectedIndex = 0;
        btnsave.Visible = true;
        btnUpdate.Visible = false;
    }
}