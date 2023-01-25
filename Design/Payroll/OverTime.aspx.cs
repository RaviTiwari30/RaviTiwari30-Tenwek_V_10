using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_OverTime : System.Web.UI.Page
{
    private int a = 0;
    private MySqlConnection con;

    protected void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnSearch.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Please Post Attendance";
        }
    }

    protected void btnDaysOverTime_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        //if (Util.GetDecimal(txtOverTime.Text) <= 0)
        //{
        //    lblmsg.Text = "Error : Over Time Days 0";
        //    return;
        //}
        //gross salary Mean basic
        decimal GrossSalary = Util.GetDecimal(lblBasic.Text);
        decimal MonthDays = Util.GetDecimal(LblMonthInDaysD.Text);
        decimal OverTimeDays = Util.GetDecimal(txtOverTime.Text);
        decimal OverTimeAmount = ((GrossSalary / MonthDays) * OverTimeDays);
        decimal OverTimeTax = Util.GetDecimal(0.00);
        //  decimal WorkingHours = Util.GetDecimal(lblWorkingHours.Text);
        decimal WorkedDays = Util.GetDecimal(lblWorkedDays.Text);
        decimal DailyBasicSalary = (GrossSalary) / (WorkedDays);
        // decimal CalBasicSalary = (OverTimeDays) * (DailyBasicSalary);
        //  decimal OverTimeAmountD = Util.GetDecimal(CalBasicSalary);

        decimal OverTimeAmountHNew = Util.GetDecimal(txtOverTime.Text) * (DailyBasicSalary);
        decimal OverTimeTaxD = 0;
        decimal NetPayD = 0;
        decimal ActualOverTimeHrD = Util.GetDecimal(txtActualOverTimeHrsD.Text);
        if (OverTimeAmountHNew > (GrossSalary / 2))
        {
            OverTimeTaxD = Util.GetDecimal((OverTimeAmountHNew * 10) / 100);
            NetPayD = Util.GetDecimal(OverTimeAmountHNew - OverTimeTaxD);
        }
        else
        {
            OverTimeTaxD = Util.GetDecimal((OverTimeAmountHNew * 5) / 100);
            NetPayD = Util.GetDecimal(OverTimeAmountHNew - OverTimeTaxD);
        }
        //if (Util.GetDecimal(GrossSalary) <= 0)
        //{
        //    lblmsg.Text = " Over Time Amount 0";
        //    return;
        //}

        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = string.Empty;

            int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_empsalary_master where  SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and year(SalaryMonth)=year('" + txtDate.Text + "')"));
            if (count == 0)
            {
                string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
                //str = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID) select Employee_ID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "' from pay_employee_master where IsActive=1";
                str = " insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID,Dept_ID,Dept_Name,Desi_ID,Desi_Name) select Employee_ID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "',Dept_ID,Dept_Name,Desi_ID,Desi_Name from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on emp.Employee_ID=att.EmployeeID and  DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))  ";
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
                str = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')";

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
                str = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')";

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

            string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where IsPost=0 and EmployeeID='" + lblEmpID.Text.Trim() + "' and SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') order by EntDate desc").ToString();
            if (MasterID == "")
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                return;
            }

            str = "delete from pay_empsalary_detail where MasterID=" + MasterID + " and TypeID IN (33,46)";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            str = "delete from pay_overtime where MasterID=" + MasterID + "";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            string Amount = Util.GetString(Math.Round(OverTimeAmount, 2));
            if (Amount == "")
            { Amount = "0"; }
            if (Util.GetDecimal(Amount) > 0)
            {
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','33','" + lblTypeName.Text.Trim() + "'," + OverTimeAmountHNew + ",'E','" + ViewState["UserID"].ToString() + "','7')";
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
                //For OverTime Tax Shatrughan 03.10.13
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','46','Overtime Tax'," + OverTimeTaxD + ",'D','" + ViewState["UserID"].ToString() + "','7')";
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

                //
                str = "INSERT INTO pay_overtime(EmployeeID,NAME,MasterID,SalaryMonth,GrossSalary,DayInMonth,WorkingHrs,OverTimeDays,OverTimeHours,OverTimeAmount,UserID,OverTimeTax,OverTimeNetPay,ActualOverTimeHours)VALUES('" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text + "','" + MasterID + "','" + txtDate.Text + "','" + lblBasic.Text + "','" + LblMonthInDaysD.Text + "','" + lblWorkingHours.Text.Trim() + "','" + txtOverTime.Text + "','0','" + OverTimeAmountHNew + "','" + ViewState["UserID"].ToString() + "','" + OverTimeTaxD + "','" + NetPayD + "','" + ActualOverTimeHrD + "');";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);

            Tranx.Commit();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnHoursOverTime_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        //if (Util.GetDecimal(txtOverTimeHours.Text) <= 0)
        //{
        //    lblmsg.Text = "Error : Over Time 0";
        //    return;
        //}
        //GrossSalary Mean Basic
        decimal GrossSalary = Util.GetDecimal(lblBasic.Text);
        decimal MonthDays = Util.GetDecimal(lblDayInMonthH.Text);
        decimal WorkingHrs = Util.GetDecimal(lblWorkingHours.Text);
        decimal OverTimeDays = Util.GetDecimal(txtOverTimeHours.Text);
        decimal OverTimeAmount = ((GrossSalary / MonthDays) / WorkingHrs) * OverTimeDays;
        decimal WorkingHours = Util.GetDecimal(lblWorkingHours.Text);
        decimal WorkedDays = Util.GetDecimal(lblWorkedDays.Text);
        decimal DailyBasicSalary = (GrossSalary) / (WorkedDays);
        decimal HourlySalary = (DailyBasicSalary) / (WorkingHours);
        decimal OverTimeAmountH = Util.GetDecimal(txtOverTimeHours.Text) * (HourlySalary);

        decimal OverTimeAmountHNew = Util.GetDecimal(txtOverTimeHours.Text) * (HourlySalary);
        decimal OverTimeTaxH = 0;
        decimal NetPayH = 0;
        decimal ActualOverTimeHrH = Util.GetDecimal(txtActualOverTimeHrsH.Text);
        if (OverTimeAmountHNew > (GrossSalary / 2))
        {
            OverTimeTaxH = Util.GetDecimal((OverTimeAmountHNew * 10) / 100);
            NetPayH = Util.GetDecimal(OverTimeAmountHNew - OverTimeTaxH);
        }
        else
        {
            OverTimeTaxH = Util.GetDecimal((OverTimeAmountHNew * 5) / 100);
            NetPayH = Util.GetDecimal(OverTimeAmountHNew - OverTimeTaxH);
        }
        //if (Util.GetDecimal(GrossSalary) <= 0)
        //{
        //    lblmsg.Text = " Over Time Amount 0";
        //    return;
        //}
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = string.Empty;

            int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_empsalary_master where  SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and year(SalaryMonth)=year('" + txtDate.Text + "')"));
            if (count == 0)
            {
                string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
                //str = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID) select Employee_ID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "' from pay_employee_master where IsActive=1";
                str = " insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID,Dept_ID,Dept_Name,Desi_ID,Desi_Name) select Employee_ID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "',Dept_ID,Dept_Name,Desi_ID,Desi_Name from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on emp.Employee_ID=att.EmployeeID and  DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))  ";
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
                str = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')";

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
                str = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')";

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
            string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where IsPost=0 and EmployeeID='" + lblEmpID.Text.Trim() + "' and SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') order by EntDate desc").ToString();
            if (MasterID == "")
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                return;
            }

            str = "delete from pay_empsalary_detail where MasterID=" + MasterID + " and TypeID IN(33,46)";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            str = "delete from pay_overtime where MasterID=" + MasterID + "";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            string Amount = Util.GetString(Math.Round(OverTimeAmount, 2));
            if (Amount == "")
            { Amount = "0"; }
            if (Util.GetDecimal(Amount) > 0)
            {
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','33','" + lblTypeName.Text.Trim() + "'," + OverTimeAmountHNew + ",'E','" + ViewState["UserID"].ToString() + "','7')";
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
                //For OverTime Tax Shatrughan 03.10.13
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','46','OVERTIME TAX'," + OverTimeTaxH + ",'D','" + ViewState["UserID"].ToString() + "','7')";
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
                str = "INSERT INTO pay_overtime(EmployeeID,NAME,MasterID,SalaryMonth,GrossSalary,DayInMonth,WorkingHrs,OverTimeDays,OverTimeHours,OverTimeAmount,UserID,OverTimeTax,OverTimeNetPay,ActualOverTimeHours)VALUES('" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text + "','" + MasterID + "','" + txtDate.Text + "','" + lblBasic.Text + "','" + lblDayInMonthH.Text + "','" + lblWorkingHours.Text.Trim() + "','0','" + txtOverTimeHours.Text + "','" + OverTimeAmountHNew + "','" + ViewState["UserID"].ToString() + "','" + OverTimeTaxH + "','" + NetPayH + "','" + ActualOverTimeHrH + "');";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            Tranx.Commit();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
        sb.Append(" select Employee_ID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  WHERE DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "')) ");
        if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Employee_ID='" + txtEmpID.Text.Trim() + "' and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() == "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like '%" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() == "")
        {
            sb.Append(" and Employee_ID='" + txtEmpID.Text.Trim() + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
            lblTypeName.Text = StockReports.ExecuteScalar("select Name from pay_remuneration_master where ID=33").ToString();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
        }
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Select")
        {
            lblmsg.Text = "";
            string str = " select Employee_ID,(select Amount from pay_employeeremuneration where TypeID=1 and Employee_ID=emp.Employee_ID)Basic,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master emp where Employee_ID='" + e.CommandArgument.ToString() + "' ";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                Clear();
                lblEmpID.Text = dt.Rows[0]["Employee_ID"].ToString();
                lblEmpName.Text = dt.Rows[0]["Name"].ToString();
                lblFatherName.Text = dt.Rows[0]["FatherName"].ToString();
                lblDOJ.Text = dt.Rows[0]["DOJ"].ToString();
                lblDept.Text = dt.Rows[0]["dept_Name"].ToString();
                lblDesi.Text = dt.Rows[0]["desi_Name"].ToString();
                lblBasic.Text = dt.Rows[0]["Basic"].ToString();
                lblDayInMonthH.Text = Util.GetDateTime(txtDate.Text).Day.ToString();
                LblMonthInDaysD.Text = Util.GetDateTime(txtDate.Text).Day.ToString();
                //lblGrossSalaryD.Text = StockReports.ExecuteScalar("SELECT ROUND(IFNULL(SUM(Amount),0)+(SELECT (Amount*(SELECT IFNULL(SUM(Amount),0) FROM pay_employeeremuneration WHERE Employee_ID='"+lblEmpID.Text.Trim()+"' AND RemunerationType='E' AND CalType='PER'))/100 FROM pay_employeeremuneration WHERE TypeID=1 AND Employee_ID='"+lblEmpID.Text.Trim()+"'),2)Amount FROM pay_employeeremuneration WHERE Employee_ID='"+lblEmpID.Text.Trim()+"' AND RemunerationType='E' AND CalType='AMT'");
                //lblGrossSalaryH.Text = lblGrossSalaryD.Text.Trim();
                lblWorkingHours.Text = StockReports.ExecuteScalar("select (WorkingHrs-1)WorkingHrs from pay_employee_master where Employee_ID='" + lblEmpID.Text.Trim() + "'");
                //lblWorkedDays.Text = StockReports.ExecuteScalar("select workingDays from pay_attendance where EmployeeID='" + lblEmpID.Text.Trim() + "' AND MONTH(Attendance_From)=Month('" + txtDate.Text.Trim() + "') AND YEAR(Attendance_From)=YEAR('" + txtDate.Text.Trim() + "')");
                lblWorkedDays.Text = StockReports.ExecuteScalar("select WorkDaysInMonth from pay_attendance where EmployeeID='" + lblEmpID.Text.Trim() + "' AND MONTH(Attendance_To)=Month('" + txtDate.Text.Trim() + "') AND YEAR(Attendance_To)=YEAR('" + txtDate.Text.Trim() + "')");
                if (lblWorkedDays.Text == "")
                {
                    lblmsg.Text = "Please First Set Attendance";
                    return;
                }
                DataTable overtimedt = StockReports.GetDataTable("SELECT * FROM pay_overtime WHERE EmployeeID='" + lblEmpID.Text.Trim() + "' AND MONTH(SalaryMonth)=Month('" + txtDate.Text.Trim() + "') AND YEAR(SalaryMonth)=YEAR('" + txtDate.Text.Trim() + "')");
                if (overtimedt.Rows.Count > 0)
                {
                    txtOverTimeHours.Text = overtimedt.Rows[0]["OverTimeHours"].ToString();

                    txtOverTime.Text = overtimedt.Rows[0]["OverTimeDays"].ToString();

                    if (Util.GetDecimal(overtimedt.Rows[0]["OverTimeDays"].ToString()) > 0)
                    {
                        txtOverTimeAmountD.Text = Util.GetString(overtimedt.Rows[0]["OverTimeAmount"].ToString());
                        txtOverTaxD.Text = overtimedt.Rows[0]["OverTimeTax"].ToString();
                        txtNetPayD.Text = overtimedt.Rows[0]["OverTimeNetPay"].ToString();
                        txtOverTimeAmountH.Text = "";
                        txtOverTimeTaxH.Text = "";
                        txtNetPayH.Text = "";
                        TabContainer1.ActiveTabIndex = 0;
                        txtActualOverTimeHrsD.Text = overtimedt.Rows[0]["ActualOverTimeHours"].ToString();
                    }
                    if (Util.GetDecimal(overtimedt.Rows[0]["OverTimeHours"].ToString()) > 0)
                    {
                        txtOverTimeAmountH.Text = overtimedt.Rows[0]["OverTimeAmount"].ToString();
                        txtOverTimeTaxH.Text = overtimedt.Rows[0]["OverTimeTax"].ToString();
                        txtNetPayH.Text = overtimedt.Rows[0]["OverTimeNetPay"].ToString();
                        txtOverTimeAmountD.Text = "";
                        txtOverTaxD.Text = "";
                        txtNetPayD.Text = "";
                        TabContainer1.ActiveTabIndex = 1;
                        txtActualOverTimeHrsH.Text = overtimedt.Rows[0]["ActualOverTimeHours"].ToString();
                    }
                }
                else
                {
                    txtOverTimeHours.Text = "";
                    txtOverTimeAmountD.Text = "";
                    txtOverTimeAmountH.Text = "";
                    txtOverTime.Text = "";
                    txtOverTaxD.Text = "";
                    txtNetPayD.Text = "";
                    txtOverTimeTaxH.Text = "";
                    txtNetPayH.Text = "";
                }
                if (dt.Rows[0]["Basic"].ToString() != "")
                {
                    mpeCreateGroup.Show();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM201','" + lblmsg.ClientID + "');", true);
                    return;
                }
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmpID.Focus();
            ViewState["UserID"] = Session["ID"].ToString();
            txtOverTime.Attributes.Add("onKeyUp", "CalOverTime_Days()");
            txtOverTimeHours.Attributes.Add("onKeyUp", "CalOverTime_Hours()");
            BindDate();
            txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtEmpName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
        }
    }

    private void Clear()
    {
        lblEmpID.Text = "";
        lblEmpName.Text = "";
        lblFatherName.Text = "";
        lblDOJ.Text = "";
        lblDept.Text = "";
        lblDesi.Text = "";
        lblBasic.Text = "";
        lblmsg.Text = "";
    }
}