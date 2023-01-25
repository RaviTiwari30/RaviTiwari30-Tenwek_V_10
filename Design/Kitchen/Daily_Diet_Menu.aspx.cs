using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Kitchen_Daily_Diet_Menu : System.Web.UI.Page
{
    protected void BindGrid()
    {
    DataTable dtdetail = StockReports.GetDataTable("Select DietMenuID,Name,Description,IF(IsActive=1,'Yes','No')IsActive,IFNULL(Days,'')Days from diet_Menu_master order by Name");
        if (dtdetail.Rows.Count > 0)
        {
            grdDetail.DataSource = dtdetail;
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
        string chkDays = "";
        if (chkDay.SelectedIndex >= 0)
            {
            foreach (ListItem li in chkDay.Items)
                {
                if (li.Selected == true)
                    {
                    if (chkDays != string.Empty)
                        {
                        chkDays += "," + li.Text + "";
                        }
                    else
                        {
                        chkDays = "" + li.Text + "";
                        }
                    }
                }
            }
        if (chkDays != "")
            {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert Into diet_Menu_master(Name,Description,IsActive,CreatedBy,Days)");
            sb.Append(" Values('" + txtTypeName.Text.Trim() + "','" + txtDescription.Text.Trim() + "'," + rblActive.SelectedItem.Value + ",'" + Session["ID"].ToString() + "','" + chkDays + "') ");
            bool IsInsert = StockReports.ExecuteDML(sb.ToString());

            if (!IsInsert)
                {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                return;
                }
            else
                {
                BindGrid();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                Clear();
                }
            }
        else
            {
            lblmsg.Text = "Please select atleast one Days";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please select atleast one Days');", true);
            return;
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
        lblmsg.Text = "";
        if (txtTypeName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Enter Component Name";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Component Name');", true);
            txtTypeName.Focus();
            return;
        }
        string chkDays = "";
        if (chkDay.SelectedIndex >= 0)
        {
            foreach (ListItem li in chkDay.Items)
            {
                if (li.Selected == true)
                {
                    if (chkDays != string.Empty)
                    {
                        chkDays += "," + li.Text + "";
                    }
                    else
                    {
                        chkDays = "" + li.Text + "";
                    }
                }
            }
        }
        if (chkDays != "")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Update diet_Menu_master Set");
                sb.Append(" name='" + txtTypeName.Text.Trim() + "',Description='" + txtDescription.Text.Trim() + "',IsActive=" + rblActive.SelectedItem.Value + ",Days='" + chkDays.ToString() + "'  where DietMenuID=" + lblID.Text + "");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                Tranx.Commit();

                BindGrid();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                Clear();
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            lblmsg.Text = "Please select atleast one Days";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please select atleast one Days');", true);
            return;
        }
    }

    protected void Clear()
    {
        txtTypeName.Text = "";
        txtDescription.Text = "";
        lblID.Text = "";
        rblActive.SelectedValue = "1";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
      /*  foreach (ListItem li in chkDay.Items)
        {
            li.Selected = false;
        }*/ 
    }

    protected void grdDetail_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        string[] s = ((Label)grdDetail.SelectedRow.FindControl("lblRecord")).Text.Split('#');
        lblID.Text = s[0].ToString();
        txtTypeName.Text = s[1].ToString();
        txtDescription.Text = s[2].ToString();
        if (s[3].ToString() == "Yes")
            rblActive.SelectedIndex = 0;
        else
            rblActive.SelectedIndex = 1;
        if (s[4].ToString() != "")
        {
            int len = Util.GetInt(s[4].ToString().Split(',').Length);
            string[] Item = new string[len];
            Item = s[4].ToString().Split(',');

            for (int i = 0; i < len; i++)
            {
                for (int k = 0; k <= chkDay.Items.Count - 1; k++)
                {
                    if (Item[i] == chkDay.Items[k].Text)
                    {
                        chkDay.Items[k].Selected = true;
                    }
                }
            }
        }
        else
        {
            foreach (ListItem li in chkDay.Items)
            {
                li.Selected = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
            btnUpdate.Visible = false;
            btnSave.Visible = true;
        }
    }

    protected bool Validation()
    {
        if (txtTypeName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Enter Diet Menu Name";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Diet Menu Name');", true);
            txtTypeName.Focus();
            return false;
        }

        int ChkNameforUpdate =Util.GetInt( StockReports.ExecuteScalar("Select COUNT(*) From diet_Menu_master where name='" + txtTypeName.Text.Trim() + "'"));
        if (ChkNameforUpdate >0)
        {
            lblmsg.Text = "Diet Menu Name Already Exists";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Menu Name Already Exists');", true);
            return false;
        }
        bool isChecked = false;
        foreach (ListItem item in chkDay.Items)
        {
            if (item.Selected)
            {
                isChecked = true;
                break;
            }
        }
        if (!isChecked)
        {
            lblmsg.Text = "Please select atleast one Days";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please select atleast one Days');", true);
            return false;
        }
        else
        {
            return true;
        }
    }
}