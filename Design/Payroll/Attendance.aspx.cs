using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_Attendance : System.Web.UI.Page
{
    private MySqlConnection con;
    private string Query = string.Empty;

    protected void BindData()
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
        sb.Append(" select * from (select EmployeeID,Name from pay_employee_master  WHERE DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "')) ");
        //sb.Append("select ID,Date_format(Attendance_From,'%d %b %y')FromDate,DATE_FORMAT(Attendance_To,'%d %b %y')ToDate,EmployeeID,Name,WorkDays,WorkHours,PresentDays,PresentHours,PayableDays,PayableHours,CL,EL,MedicalLeave from pay_attendance  where Month(Attendance_To)=Month('" + DateTime.Now.ToString("yyyy-MM-dd") + "')");
        if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and EmployeeID='" + txtEmpID.Text.Trim() + "' and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() == "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() == "")
        {
            sb.Append(" and EmployeeID='" + txtEmpID.Text.Trim() + "'");
        }
        sb.Append(" )emp left join (select ID,Date_format(Attendance_From,'%d-%b-%Y')FromDate,DATE_FORMAT(Attendance_To,'%d-%b-%Y')ToDate,EmployeeID,WorkDays,WorkHours,PresentDays,PresentHours,PayableDays,PayableHours,CL,EL,MedicalLeave,WorkingDays,WeekOff ");
        sb.Append(" from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "'))Att on emp.EmployeeID=att.EmployeeID order by EmployeeID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            //  lblmsg.Text = dt.Rows.Count + " Record Found";
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
            ViewState["Data"] = dt;
            pnlHide.Visible = true;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "Calpayday(this);", true);
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            ViewState["Data"] = null;
            pnlHide.Visible = false;
            //lblmsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        con = Util.GetMySqlCon();
        con.Open();
        int a = 0;
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < EmpGrid.Rows.Count; i++)
            {
                if (((Label)EmpGrid.Rows[i].FindControl("lblID")).Text != "")
                {
                    Query = "update pay_attendance set PayableDays='" + ((TextBox)EmpGrid.Rows[i].FindControl("txtPayabledays")).Text.Trim() + "', PayableHours=" + ((TextBox)EmpGrid.Rows[i].FindControl("txtpayableHours")).Text.Trim() + " " +
                            ",WorkingDays=" + ((TextBox)EmpGrid.Rows[i].FindControl("txtwdays")).Text.Trim() + ",CL=" + ((TextBox)EmpGrid.Rows[i].FindControl("txtcl")).Text.Trim() + ", EL=" + ((TextBox)EmpGrid.Rows[i].FindControl("txtel")).Text.Trim() + ", MedicalLeave=" + ((TextBox)EmpGrid.Rows[i].FindControl("txtother")).Text.Trim() + "," +
                            " WeekOff=" + ((TextBox)EmpGrid.Rows[i].FindControl("txtWeeklyOff")).Text.Trim() + " where EmployeeID='" + ((Label)EmpGrid.Rows[i].FindControl("lblEmployeeID")).Text.Trim() + "' and ID=" + ((Label)EmpGrid.Rows[i].FindControl("lblID")).Text.Trim() + "";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                }
            }

            Tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }

    protected void EmpGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblID")).Text == "")
            {
                e.Row.BackColor = System.Drawing.Color.DarkGray;
                e.Row.ToolTip = "Attendance Not Available";
            }

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "Calpayday(this);", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmpID.Focus();
            BindDate();
            txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtEmpName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
        }
    }

    private void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date  where SalaryPost=0 order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date  where SalaryPost=0 order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Please Post Attendance";
            btnSave.Enabled = false;
        }
    }
}