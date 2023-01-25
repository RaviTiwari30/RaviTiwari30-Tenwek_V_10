using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_PublicHolidays : System.Web.UI.Page
{
    protected void BindHolidays()
    {
        lblMsg.Text = "";
        DataTable dt = StockReports.GetDataTable("select ID,Name,Date_Format(Date,'%d-%b-%Y')Date,if(IsActive=1,'Yes','No')IsActive,if(IsOptionalHoliday=1,'Optional','National')HolidayType,IsOptionalHoliday FROM pay_publicholidays");
        if (dt.Rows.Count > 0)
        {
            grdLeave.DataSource = dt;
            grdLeave.DataBind();
        }
        else
        {
            grdLeave.DataSource = null;
            grdLeave.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        btnSave.Visible = true; ;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        clear();
    }

    protected void btnSaveRecord_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtDate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM059','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "Please Select Date";
            return;
        }
        if (ValidateHolidayName(txtName.Text.Trim()))
        {
            string str = "INSERT INTO pay_publicholidays(NAME,DATE,UserID,IsActive,IsOptionalHoliday)VALUES('" + txtName.Text + "', '" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "','" + rbtnActive.SelectedValue + "','" + Util.GetInt(rdbHolidayType.SelectedItem.Value) + "')";
            StockReports.ExecuteDML(str);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            clear();
            BindHolidays();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM178','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "Holiday Name Already Exists";
        }
    }

    protected void btnUpdate_Click1(object sender, EventArgs e)
    {
        try
        {
            if (txtDate.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM59','" + lblMsg.ClientID + "');", true);
                //lblMsg.Text = "Please Select Date";
                return;
            }

            if (ValidateHolidayNameUpdate(txtName.Text.Trim()))
            {
                string str = "UPDATE pay_publicholidays SET NAME = '" + txtName.Text + "',Date='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',IsActive='" + rbtnActive.SelectedItem.Value + "',IsOptionalHoliday='"+ Util.GetInt(rdbHolidayType.SelectedItem.Value) +"' WHERE	ID = '" + ViewState["Id"].ToString() + "'";
                bool result = StockReports.ExecuteDML(str);
                if (result)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
                    //lblMsg.Text = "Updated Successfully..";
                    BindHolidays();
                    btnSave.Visible = true;
                    btnUpdate.Visible = false;
                    btnCancel.Visible = false;
                    clear();
                    //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='PublicHolidays.aspx';", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM178','" + lblMsg.ClientID + "');", true);
                //lblMsg.Text = "Holiday Name Already Exists";
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdLeave_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        string[] s = ((Label)grdLeave.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Id"] = s[0].ToString();
        ViewState["Name"] = s[1].ToString();
        txtName.Text = s[1].ToString();
        txtDate.Text = s[2].ToString();
        if (Util.GetString(s[3].ToString()) == "Yes")
        {
            rbtnActive.SelectedIndex = 0;
        }
        else
        {
            rbtnActive.SelectedIndex = 1;
        }
        if (Util.GetString(s[4]) == "1") 
        {
            rdbHolidayType.SelectedIndex = 1;
        }
        else
            rdbHolidayType.SelectedIndex = 0;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtName.Focus();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
            BindHolidays();
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtDate.Attributes.Add("readonly", "readonly");
    }

    protected bool ValidateHolidayName(string Name)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_publicholidays where NAME='" + Name + "' "));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected bool ValidateHolidayNameUpdate(string Name)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_publicholidays where  Name !='" + ViewState["Name"].ToString() + "' AND Name='" + Name + "' "));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    private void clear()
    {
        txtName.Text = "";
        txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        rbtnActive.SelectedIndex = 0;
        rdbHolidayType.SelectedIndex = 0;
    }
}