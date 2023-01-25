using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

public partial class Design_Payroll_ProbationPeriod : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow row in EmpGrid.Rows)
        {
            if (((CheckBox)row.FindControl("chkselect")).Checked == true)
            {
                string query = "UPDATE pay_employee_master SET ProbationPeriodComplete=1,ProbationPeriodCompleteDate='" + Util.GetDateTime(((TextBox)row.FindControl("txtDate")).Text).ToString("yyyy-MM-dd") + "' WHERE Employee_ID='" + ((Label)row.FindControl("lblEmployeeID")).Text + "'";
                //string query = "UPDATE pay_employee_master SET ProbationPeriod='" + ((TextBox)row.FindControl("txtProbationPeriod")).Text + "',ProbationPeriodComplete=1,ProbationPeriodCompleteDate='" + Util.GetDateTime(((TextBox)row.FindControl("txtDate")).Text).ToString("yyyy-MM-dd") + "' WHERE Employee_ID='" + ((Label)row.FindControl("lblEmployeeID")).Text + "'";
                StockReports.ExecuteDML(query);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                // lblmsg.Text = "Record Save";
            }
            else
            {
                if (Util.GetInt(((TextBox)row.FindControl("txtProbationPeriod")).Text) > 6)
                {
                    string query = "UPDATE pay_employee_master SET ProbationPeriod='" + ((TextBox)row.FindControl("txtProbationPeriod")).Text + "',ProbationPeriodComplete=2,ProbationPeriodCompleteDate=Null WHERE Employee_ID='" + ((Label)row.FindControl("lblEmployeeID")).Text + "'";
                    StockReports.ExecuteDML(query);
                }
                else
                {
                    string query = "UPDATE pay_employee_master SET ProbationPeriod='" + ((TextBox)row.FindControl("txtProbationPeriod")).Text + "',ProbationPeriodComplete=0,ProbationPeriodCompleteDate=Null WHERE Employee_ID='" + ((Label)row.FindControl("lblEmployeeID")).Text + "'";
                    StockReports.ExecuteDML(query);
                }
                //lblmsg.Text = "Record Save";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string query = "SELECT Employee_ID,NAME,Desi_Name,Dept_Name,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,ProbationPeriod,ProbationPeriodComplete,ProbationPeriodCompleteDate FROM pay_employee_master WHERE IsActive=1 and  MONTH(DATE(ADDDATE(DOJ,INTERVAL ProbationPeriod MONTH)))=MONTH(DATE('" + txtDate.GetDateForDataBase() + "')) AND YEAR(DATE(ADDDATE(DOJ,INTERVAL ProbationPeriod MONTH)))=YEAR(DATE('" + txtDate.GetDateForDataBase() + "')) ";
        if (ddlStatus.SelectedIndex > 0)
        {
            //if (ddlStatus.SelectedItem.Value == "0")
            //{
            //    query += " and ProbationPeriodComplete in (0,2)";
            //    //query += " and ProbationPeriodComplete=1";

            //}
            //else
            //{
            query += " and ProbationPeriodComplete='" + ddlStatus.SelectedItem.Value + "'";

            // }
        }
        query += "order by Date(DOJ),Employee_ID";
        DataTable dt = StockReports.GetDataTable(query);
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
            btnSave.Visible = true;
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            btnSave.Visible = false;
        }
    }

    protected void chkselect_CheckedChanged(object sender, EventArgs e)
    {
        foreach (GridViewRow row in EmpGrid.Rows)
        {
            CheckBox chkadd = (CheckBox)row.FindControl("chkselect");

            TextBox txtf = (TextBox)row.FindControl("txtProbationPeriod");
            TextBox txtdate = (TextBox)row.FindControl("txtDate");
            if (chkadd.Checked == true)
            {
                txtf.ReadOnly = true;
                txtdate.Enabled = true;
                //txtdate.ReadOnly = false;
                //txtf.visible = true;
            }
            if (chkadd.Checked == false)
            {
                //txtf.Visible = false;
                txtf.ReadOnly = false;
                //txtdate.ReadOnly = true;
                txtdate.Enabled = false;
            }
            //if (((CheckBox)EmpGrid.FindControl("chkselect")).Checked == true)
            //{
            //    ((TextBox)EmpGrid.FindControl("txtProbationPeriod")).ReadOnly = true;
            //}
        }
    }

    protected void EmpGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            DateTime ProbDate = Util.GetDateTime(((Label)e.Row.FindControl("lblDOJ")).Text);
            int addmonth = Util.GetInt(((TextBox)e.Row.FindControl("txtProbationPeriod")).Text);
            ProbDate = ProbDate.AddMonths(addmonth);
            // ((Design_Purchase_EntryDate)e.Row.FindControl("txtDate")).SetDate(ProbDate.Day.ToString(), ProbDate.Month.ToString(), ProbDate.Year.ToString());
            ((TextBox)e.Row.FindControl("txtDate")).Text = ProbDate.ToString("dd-MMM-yyyy");

            if (((Label)e.Row.FindControl("lblProbationPeriodComplet")).Text != "")
            {
                ProbDate = Util.GetDateTime(((Label)e.Row.FindControl("lblProbationPeriodComplet")).Text);
                ((CheckBox)e.Row.FindControl("chkselect")).Checked = true;
                //  ((Design_Purchase_EntryDate)e.Row.FindControl("txtDate")).SetDate(ProbDate.Day.ToString(), ProbDate.Month.ToString(), ProbDate.Year.ToString());
                ((TextBox)e.Row.FindControl("txtDate")).Text = ProbDate.ToString("dd-MMM-yyyy");
            }
            ((TextBox)e.Row.FindControl("txtDate")).Attributes.Add("readonly", "readonly");
            ((CalendarExtender)e.Row.FindControl("calDate")).StartDate = Util.GetDateTime(((Label)e.Row.FindControl("lblDOJ")).Text);
        }
    }

    protected void grirecord_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //foreach (GridViewRow row in EmpGrid.Rows)
        //{
        //    CheckBox chkadd = (CheckBox)row.FindControl("chkselect");

        //    TextBox txtf = (TextBox)row.FindControl("txtProbationPeriod");
        //    if (chkadd.Checked == true)
        //    {
        //        txtf.ReadOnly = true;
        //        //txtf.visible = true;
        //    }
        //    if (chkadd.Checked == false)
        //    {
        //        //txtf.Visible = false;
        //        txtf.ReadOnly = false;
        //    }
        //}
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // txtDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtDate.SetCurrentDate();
        }
    }
}