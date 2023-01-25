using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_AttendnessInsert : System.Web.UI.Page
{
    protected void BindDate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Pay_Attendance_Date"));
        if (count > 0)
        {
            lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(adddate(Att_To,1),'%d-%b-%Y')FromDateDisplay from Pay_Attendance_Date   order by ID DESC");
            DateFrom.Text = StockReports.ExecuteScalar("select DATE_FORMAT(adddate(Att_To,1),'%Y-%m-%d')FromDate from Pay_Attendance_Date  order by ID DESC");
            DateTime date = Util.GetDateTime(StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date  order by ID DESC"));
            date = Util.GetDateTime(date).AddMonths(1);
            if (date.Month == 3)
            {
                date = Util.GetDateTime(date.Month + "-31-" + date.Year);
            }
            DateTo.Text = date.ToString("dd-MMM-yyyy");
            DateTime FromDate = Util.GetDateTime(lblFromDate.Text);
            calucDate.StartDate = Util.GetDateTime(FromDate.ToString("dd-MMM-yyyy"));
            txtFromDate.Visible = false;
        }

        else
        {
            txtFromDate.Visible = true;
            txtFromDate.Text = System.DateTime.Now.AddDays(-30).ToString("dd-MMM-yyyy");
            DateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
             DateFrom.Attributes.Add("style", "display:none");
        }
    }

    protected void btnInsert_Click(object sender, EventArgs e)
    {
        if (ValidateDate())
        {
            //count sat & sun day for weekoff
            int Weekoff = 0;
            DateTime FromDate = Util.GetDateTime(Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd"));
            DateTime ToDate = Util.GetDateTime(DateTo.Text);
            while (FromDate <= ToDate)
            {
                if (FromDate.DayOfWeek.ToString() == "Saturday" || FromDate.DayOfWeek.ToString() == "Sunday")
                {
                    Weekoff += 1;
                }
                FromDate = FromDate.AddDays(1);
            }

            lblmsg.Text = "";
            string str = string.Empty;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            int a = 0;
            try
            {
               
                str = "INSERT INTO pay_attendance(Attendance_From,Attendance_To,WorkDays,WorkHours,WeekOff,WorkingDays,WorkDaysInMonth,PresentDays,PresentHours,PayableDays,PayableHours,EmployeeID,NAME,PaidLeave) " +
                    " select '" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "',(DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1), " +
                    " ((DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1))*8," + Weekoff + ",(DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1)-" + Weekoff + "-IFNULL(PaidLeave,0)PaidLeave ," +
                    " (DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1)-" + Weekoff + ",DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1, " +
                    " (DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1)*8,DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1,(DATEDIFF('" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "'," +
                    " '" +Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "')+1)*8,emp.EmployeeID,emp.NAME,IFNULL(PaidLeave,0)PaidLeave FROM PAY_EMPLOYEE_MASTER emp " +
                    " LEFT JOIN ( SELECT EmployeeID,SUM(PaidLeave)PaidLeave,SUM(UnPaidLeave)UnPaidLeave FROM ( " +
                    " SELECT EmployeeID,emp.Name,COUNT(ld.Date)Days,IF(lm.PaidLeave=1,COUNT(ld.Date),0)PaidLeave," +
                    " IF(lm.PaidLeave=0,COUNT(ld.Date),0)UnPaidLeave   FROM pay_employeeleavemaster lea " +
                    " INNER JOIN pay_employeeleave_days ld ON lea.RequestID=ld.RequestID INNER JOIN pay_employee_master emp " +
                  " ON emp.EmployeeID=lea.EmployeeID INNER JOIN pay_leavemaster lm ON lm.ID=lea.LeaveID     WHERE Approved=1 AND " +
                  " ld.date>='" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "' AND ld.date<='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' " +
                  " GROUP BY lea.RequestID)le GROUP BY EmployeeID)lea ON emp.EmployeeID=lea.EmployeeID " +
                    " WHERE DATE(DOJ)<'" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(DOL)<='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "'))";

                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                    return;
                }
                a = 0;
                str = "insert into pay_attendance_date(UserID,Att_From,Att_To,SalaryPost)values('" + Session["ID"].ToString() + "','" + Util.GetDateTime(DateFrom.Text.Trim()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "',0)";
                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }
                a = 0;
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                return;
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            BindDate();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDate();
        }
        DateFrom.Attributes.Add("style", "display:none");
        DateTo.Attributes.Add("readonly", "readonly");
        txtFromDate.Attributes.Add("readonly", "readonly");
    }

    protected Boolean ValidateDate()
    {
        if (DateTo.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM059','" + lblmsg.ClientID + "');", true);
          
            return false;
        }
        string Att_To = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')Att_To from pay_attendance_date where SalaryPost=0");
        if (Att_To.Length > 0)
        {
            lblmsg.Text = "Salary Already Processed in the Month of " + Att_To;
            return false;
        }
        return true;
    }
}