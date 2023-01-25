using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_PublicLeave : System.Web.UI.Page
{
    protected void BindHolidays()
    {
        lblMsg.Text = "";
        DataTable dt = StockReports.GetDataTable("SELECT IFNULL(IsTime,0)IsTime,FromTime,ToTime,lm.DoctorID,lm.ID,dm.Name DocName,lm.LeaveReason,DATE_FORMAT(lm.Date,'%d-%b-%Y')DATE,IF(lm.IsActive=1,'Yes','No')IsActive FROM Pay_Leave_Master lm INNER JOIN doctor_master dm  ON dm.DoctorID=lm.DoctorID WHERE lm.`DoctorID`='" + ddldoclist.SelectedItem.Value + "' ORDER BY lm.`Date` DESC LIMIT 100");
        if (dt.Rows.Count > 0)
        {
            grdLeave.DataSource = dt;
            grdLeave.DataBind();
            divList.Visible = true;
        }
        else
        {
            grdLeave.DataSource = null;
            grdLeave.DataBind();
            divList.Visible = false;
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
        //  txtFromDate, txtToDate, txtfromtime, txttotime, txtReason
        lblMsg.Text = "";
        if (txtReason.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Reason');", true);
            txtReason.Focus();
            return;
        }
         if (txtFromDate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select From Date');", true);
            txtFromDate.Focus();
            return;
        }
         if (txtToDate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select To Date');", true);
            txtToDate.Focus();
            return;
        }

        int datediff = TotalDays();

        for (int i = 0; i < datediff; i++)
        {
            DateTime fromdate = Util.GetDateTime(txtFromDate.Text);
            fromdate = fromdate.AddDays(i);
            var date = Util.GetDateTime(fromdate).ToString("yyyy-MM-dd");
            if (ValidateHolidayName(ddldoclist.SelectedItem.Value.ToString(), date))
            {

                string str = "";
                if (txtfromtime.Text != "" && txttotime.Text != "")
                {
                    str = "INSERT INTO Pay_Leave_Master(DoctorID,LeaveReason,DATE,UserID,IsActive,IsTime,FromTime,ToTime)VALUES('" + ddldoclist.SelectedValue.ToString() + "', '" + txtReason.Text + "', '" + date + "','" + Session["ID"].ToString() + "','" + rbtnActive.SelectedValue + "','1','" + txtfromtime.Text + "','" + txttotime.Text + "')";
                }
                else
                {
                    str = "INSERT INTO Pay_Leave_Master(DoctorID,LeaveReason,DATE,UserID,IsActive)VALUES('" + ddldoclist.SelectedValue.ToString() + "', '" + txtReason.Text + "', '" + date + "','" + Session["ID"].ToString() + "','" + rbtnActive.SelectedValue + "')";
                }
                StockReports.ExecuteDML(str);


            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Leave Date " + Util.GetDateTime(fromdate).ToString("dd-MMM-yyyy") + " Already Exists')", true);
                //  lblMsg.Text = "Leave Date Already Exists";
            }

            BindHolidays();
        }

        clear();
    }

    public int TotalDays()
    {
        DateTime StartMonth = Util.GetDateTime(txtFromDate.Text);
        DateTime EndMonth = Util.GetDateTime(txtToDate.Text);
        var Datediff = (EndMonth - StartMonth).ToString("dd");
        return Util.GetInt(Datediff) + 1;

    }

    protected void btnUpdate_Click1(object sender, EventArgs e)
    {
        try
        {
            if (txtReason.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Reason');", true);
                txtReason.Focus();
                return;
            }
            if (txtFromDate.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select From Date');", true);
                txtFromDate.Focus();
                return;
            }
            if (txtToDate.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select To Date');", true);
                txtToDate.Focus();
                return;
            }
            string str = "";
            if (txtfromtime.Text != "" && txttotime.Text != "")
            {
                str = "UPDATE Pay_Leave_Master SET  IsTime=1,FromTime='" + txtfromtime.Text + "',ToTime='" + txttotime.Text + "',LeaveReason = '" + txtReason.Text + "',Date='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "',IsActive='" + rbtnActive.SelectedItem.Value + "' WHERE	ID = '" + ViewState["Id"].ToString() + "'";
            }
            else
            {
                str = "UPDATE Pay_Leave_Master SET LeaveReason = '" + txtReason.Text + "',Date='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "',IsActive='" + rbtnActive.SelectedItem.Value + "' WHERE	ID = '" + ViewState["Id"].ToString() + "'";
            }
            bool result = StockReports.ExecuteDML(str);
            if (result)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Leave Updated Successfully');", true);

                BindHolidays();
                btnSave.Visible = true;
                btnUpdate.Visible = false;
                btnCancel.Visible = false;
                clear();
               
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occurred.Please Contact To Administrator');", true);
            }


        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occurred.Please Contact To Administrator');", true);
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
        ViewState["LeaveReason"] = s[1].ToString();
        txtReason.Text = s[1].ToString();
        txtFromDate.Text = s[2].ToString();
        txtToDate.Text = s[2].ToString();
        ddldoclist.SelectedIndex = (ddldoclist.Items.IndexOf(ddldoclist.Items.FindByValue(s[4].ToString())));

        if (s[5].ToString() == "1")
        {
            txtfromtime.Text = s[6].ToString();
            txttotime.Text = s[7].ToString();
        }
        if (Util.GetString(s[3].ToString()) == "Yes")
        {
            rbtnActive.SelectedIndex = 0;
        }
        else
        {
            rbtnActive.SelectedIndex = 1;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            calucDate.StartDate = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));
            caltodate.StartDate = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));

            txtReason.Focus();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
            BindDoc();
            BindHolidays();
           
        }
    }

    protected bool ValidateHolidayName(string DocID, string date)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_Leave_Master where DoctorID='" + DocID + "' and date='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' "));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public void BindDoc()
    {

        string sql = "SELECT DoctorID,CONCAT(Title,' ',Name)Name,Designation Department,DocDepartmentID FROM doctor_master WHERE IsActive = 1 ORDER BY NAME";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {

            ddldoclist.DataTextField = "Name";

            ddldoclist.DataValueField = "DoctorID";
            ddldoclist.DataSource = dt;
            ddldoclist.DataBind();
        }
    }



    private void clear()
    {

        //  txtFromDate, txtToDate, txtfromtime, txttotime, txtReason
        txtReason.Text = "";
        txtFromDate.Text = "";
        rbtnActive.SelectedIndex = 0;
    }
    protected void ddldoclist_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindHolidays();
    }
}