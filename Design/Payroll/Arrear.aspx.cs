using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_Arrear : System.Web.UI.Page
{
    private int a = 0;

    private float AttendancePercent = 0;

    private float Basic = 0, ActualBasic = 0, Req_Days = 0, Present_Days = 0, Req_Hours = 0, Present_Hours = 0, OneDayBasic = 0, OneHrBasic = 0;

    private MySqlConnection con;

    private string EmpID = string.Empty;

    private float OneDaysHr = 0;

    //MySqlConnection con;
    private string Query = string.Empty;

    private string Str = string.Empty;

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

    protected void btnHidden_Click(object sender, EventArgs e)
    {
    }

    protected void btnSaveInc_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionType = "1";

            Query = "select emp.Employee_ID,Emp.Name,Remun.TypeID,Remun.TypeName,Remun.Amount,Remun.CalType,Remun.RemunerationType," +
         " Remun.Per_Cal_Amt,Remun.Per_Cal_On,Remun.IsFix from pay_employee_master emp inner join pay_employeeRemuneration " +
         " Remun on emp.Employee_ID=Remun.Employee_ID where ISACTIVE=1 and emp.Employee_ID='" + lblEmpID.Text + "'";

            DataTable EmpSalaryDetail = StockReports.GetDataTable(Query);

            float PayableAmount = 0;

            int DayInMonth = DateTime.DaysInMonth(Util.GetDateTime(txtIncArrear.Text).Year, Util.GetDateTime(txtIncArrear.Text).Month);
            PayableAmount = (Util.GetFloat(txtIncrementAmount.Text) / DayInMonth) * Util.GetFloat(txtpayableDays.Text.Trim());

            /// insert into Arrear Detail
            ///
            Query = "insert into pay_arreardetail (EmployeeID,ArrearType,ArrearMonth,Narration,PayableDays,UserID)values('" + lblEmpID.Text + "','Incremental Arrear','" + Util.GetDateTime(txtIncArrear.Text).ToString("yyyy-MM-dd") + "','" + txtNarration.Text + "'," + txtpayableDays.Text + ",'" + ViewState["UserID"].ToString() + "')";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            if (a == 0)
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                return;
            }
            /////////////////Save Salary Master
            Query = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,ArrearMonth,IsPost,UserID,PayableDays,Dept_ID,Dept_Name,Desi_ID,Desi_Name) values('" + lblEmpID.Text + "','" + lblEmpName.Text + "','" + lblAccNo.Text + "','A','" + txtDate.Text + "','" + Util.GetDateTime(txtIncArrear.Text).ToString("yyyy-MM-dd") + "',0,'" + ViewState["UserID"].ToString() + "'," + txtpayableDays.Text.Trim() + "," + lblDeptID.Text.Trim() + ",'" + lblDept.Text.Trim() + "'," + lblDesiID.Text.Trim() + ",'" + lblDesi.Text.Trim() + "')";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            if (a == 0)
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                return;
            }
            string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where  SalaryType='A' and EmployeeID='" + lblEmpID.Text + "'  order by EntDate desc").ToString();
            if (MasterID == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                return;
            }

            Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text + "','1','BASIC'," + PayableAmount + ",'E','" + ViewState["UserID"].ToString() + "','" + TransactionType + "')";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            if (a == 0)
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true); return;
            }
            a = 0;
            /// insert into ESI detail
            Query = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)values(" + MasterID + ",'" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text.Trim() + "','" + txtDate.Text + "')";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
            //insert into pf detail
            Query = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) values(" + MasterID + ",'" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text.Trim() + "','" + txtDate.Text + "')";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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

            ///////////Calculate Other Allowance(Depend on Basic)
            DataRow[] RowPer = EmpSalaryDetail.Select("Employee_ID='" + lblEmpID.Text.Trim() + "' AND CalType='PER' and IsFix=0");
            if (RowPer.Length > 0)
            {
                for (int j = 0; j < RowPer.Length; j++)
                {
                    float NetAmount = Util.GetFloat(RowPer[j]["Amount"].ToString()) * Util.GetFloat(PayableAmount) / 100;

                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','" + RowPer[j]["TypeID"].ToString() + "','" + RowPer[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowPer[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ")";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
            }
            ////Stamp Charges Only
            DataRow[] RowStamp = EmpSalaryDetail.Select("Employee_ID='" + lblEmpID.Text.Trim() + "' AND CalType='AMT' and TypeID=23 and TypeName='STAMP'");
            if (RowStamp.Length > 0)
            {
                for (int j = 0; j < RowStamp.Length; j++)
                {
                    Query = "insert into pay_empsalary_detail(MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','" + RowStamp[j]["TypeID"].ToString() + "','" + RowStamp[j]["TypeName"].ToString() + "'," + RowStamp[j]["Amount"].ToString() + ",'" + RowStamp[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ")";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
            }

            ///////////////////////////////Transaction Commit
            Tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            // lblmsg.Text = ex.Message;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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

    protected void btnSaveSalaryArrear_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string MasterID = string.Empty;
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionType = "1";
            Query = " select distinct emp.Employee_ID,emp.Name,Emp.BankAccountNo from pay_employee_master emp inner join pay_employeeRemuneration Remun on emp.Employee_ID=Remun.Employee_ID where ISACTIVE=1 and emp.Employee_ID='" + lblEmpID.Text + "' order by emp.Employee_ID";

            DataTable EmpDetail = StockReports.GetDataTable(Query);

            Query = "select emp.Employee_ID,Emp.Name,Remun.TypeID,Remun.TypeName,Remun.Amount,Remun.CalType,Remun.RemunerationType," +
            " Remun.Per_Cal_Amt,Remun.Per_Cal_On,Remun.IsFix from pay_employee_master emp inner join pay_employeeRemuneration " +
            " Remun on emp.Employee_ID=Remun.Employee_ID where ISACTIVE=1 and emp.Employee_ID='" + lblEmpID.Text.Trim() + "' order by emp.Employee_ID ";

            DataTable EmpSalaryDetail = StockReports.GetDataTable(Query);

            if (EmpDetail.Rows.Count > 0)
            {
                /// insert into Arrear Detail

                Query = "insert into pay_arreardetail(EmployeeID,ArrearType,ArrearMonth,Narration,PayableDays,UserID)values('" + lblEmpID.Text + "','Salary Arrear','" + Util.GetDateTime(txtSalArrar.Text).ToString("yyyy-MM-dd") + "','" + txtSalnarration.Text.Replace("'", "''") + "'," + txtSalPayableDays.Text + ",'" + ViewState["UserID"].ToString() + "')";
                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                    return;
                }

                /////////////////Save Salary Master
                Query = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,ArrearMonth,IsPost,UserID,PayableDays,Dept_ID,Dept_Name,Desi_ID,Desi_Name) values('" + lblEmpID.Text + "','" + lblEmpName.Text + "','" + lblAccNo.Text + "','A','" + txtDate.Text + "','" + Util.GetDateTime(txtSalArrar.Text).ToString("yyyy-MM-dd") + "',0,'" + ViewState["UserID"].ToString() + "'," + txtSalPayableDays.Text + "," + lblDeptID.Text.Trim() + ",'" + lblDept.Text.Trim() + "'," + lblDesiID.Text.Trim() + ",'" + lblDesi.Text.Trim() + "')";
                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }
                MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where  SalaryType='A' and EmployeeID='" + lblEmpID.Text + "'  order by EntDate desc").ToString();
                if (MasterID == string.Empty)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }
                /// insert into ESI detail
                Query = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)values(" + MasterID + ",'" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text.Trim() + "','" + txtDate.Text + "')";

                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
                //insert into pf detail
                Query = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) values(" + MasterID + ",'" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text.Trim() + "','" + txtDate.Text + "')";

                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }

                for (int i = 0; i < EmpDetail.Rows.Count; i++)
                {
                    EmpID = EmpDetail.Rows[i]["Employee_ID"].ToString();
                    DataRow[] RowBasic = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "' AND CalType='AMT' AND TypeName='BASIC' And TypeID=1");
                    if (RowBasic.Length != 1)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                        return;
                    }
                    //Basic = Util.GetFloat(StockReports.ExecuteScalar("select Remun.Amount from pay_employee_master emp inner join pay_employeeRemuneration Remun on emp.Employee_ID=Remun.Employee_ID where DOL='0001-01-01 00:00:00' and TypeName='BASIC' AND EMP.Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"] + "'"));
                    Basic = Util.GetFloat(RowBasic[0]["Amount"]);
                    DateTime ArrearSalaryDate = Util.GetDateTime(txtSalArrar.Text);

                    Present_Days = Util.GetFloat(txtSalPayableDays.Text);
                    Present_Hours = Present_Days * 8;
                    Req_Days = DateTime.DaysInMonth(Util.GetInt(ArrearSalaryDate.Year), Util.GetInt(ArrearSalaryDate.Month));
                    Req_Hours = Util.GetFloat(Present_Days * 8);/////////////////////////////
                    ///one day working hr.
                    OneDaysHr = 8;

                    /////////////////////Find Payable Basic

                    OneDayBasic = Basic / Req_Days;
                    OneHrBasic = OneDayBasic / OneDaysHr;

                    Present_Hours = OneDaysHr * Present_Days;
                    ActualBasic = Present_Hours * OneHrBasic;

                    ////////////////Find Attendance Percentage
                    AttendancePercent = Present_Days * 100 / Req_Days;

                    ////////////////////Save Detail of Salary
                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + EmpID + "','" + RowBasic[0]["TypeID"].ToString() + "','" + RowBasic[0]["TypeName"].ToString() + "'," + ActualBasic + ",'" + RowBasic[0]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "','" + TransactionType + "')";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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

                    ///////////Calculate Other Allowance(Depend on AttendancePercent) // Earning

                    DataRow[] RowAmt = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "' AND CalType='AMT'  AND RemunerationType='E' AND TypeName<>'BASIC'");
                    if (RowAmt.Length > 0)
                    {
                        for (int j = 0; j < RowAmt.Length; j++)
                        {
                            float NetAmount = Util.GetFloat(RowAmt[j]["Amount"].ToString()) * AttendancePercent / 100;
                            Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + EmpID + "','" + RowAmt[j]["TypeID"].ToString() + "','" + RowAmt[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowAmt[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ")";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
                    }
                    ///////////Calculate Other Allowance(Depend on AttendancePercent) //Deduction
                    //In Arrear PF & ESI only deducte

                    ///////////Calculate Other Allowance(Depend on Basic)
                    DataRow[] RowPer = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"] + "'  AND CalType='PER' and IsFix=0");
                    if (RowPer.Length > 0)
                    {
                        for (int j = 0; j < RowPer.Length; j++)
                        {
                            float NetAmount = Util.GetFloat(RowPer[j]["Amount"].ToString()) * ActualBasic / 100;

                            Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + EmpID + "','" + RowPer[j]["TypeID"].ToString() + "','" + RowPer[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowPer[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ")";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
                    }

                    ///////////Calculate Other Allowance(Depend on Fix Amount)
                    DataRow[] RowFix = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"] + "' AND CalType='PER' and IsFix=1");
                    if (RowFix.Length > 0)
                    {
                        for (int j = 0; j < RowFix.Length; j++)
                        {
                            float FixAmount = Util.GetFloat(RowFix[j]["Per_Cal_Amt"]);
                            if (ActualBasic < FixAmount)
                            {
                                FixAmount = ActualBasic;
                            }
                            float NetAmount = Util.GetFloat(RowFix[j]["Amount"].ToString()) * FixAmount / 100;
                            Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + EmpID + "','" + RowFix[j]["TypeID"].ToString() + "','" + RowFix[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowFix[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ")";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
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
                    }
                    ////Stamp Charges Only
                    DataRow[] RowStamp = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"] + "' AND CalType='AMT' and TypeID=23 and TypeName='STAMP'");
                    if (RowStamp.Length > 0)
                    {
                        for (int j = 0; j < RowStamp.Length; j++)
                        {
                            Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + EmpID + "','" + RowStamp[j]["TypeID"].ToString() + "','" + RowStamp[j]["TypeName"].ToString() + "'," + RowStamp[j]["Amount"].ToString() + ",'" + RowStamp[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ")";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                            if (a == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                // lblmsg.Text = "Error";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                                return;
                            }
                            a = 0;
                        }
                    }
                }

                Tranx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            }
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
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
        sb.Append(" select Employee_ID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  WHERE DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "')) ");
        if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append("and Employee_ID='" + txtEmpID.Text.Trim() + "' and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() == "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like '" + txtEmpName.Text.Trim() + "%' ");
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
            string str = " select Employee_ID,(select Amount from pay_employeeremuneration where TypeID=1 and Employee_ID=emp.Employee_ID)Basic,BankAccountNo,LetterNo,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_ID,dept_Name,desi_ID,desi_Name from pay_employee_master emp where Employee_ID='" + e.CommandArgument.ToString() + "' ";
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

                lblDeptID.Text = dt.Rows[0]["Dept_ID"].ToString();
                lblDesiID.Text = dt.Rows[0]["Desi_ID"].ToString();
                lblAccNo.Text = dt.Rows[0]["BankAccountNo"].ToString();
                lblLetter.Text = dt.Rows[0]["LetterNO"].ToString();
                txtIncrementAmount.Text = StockReports.ExecuteScalar("select IncrementAmount from pay_employee_master where Employee_ID='" + lblEmpID.Text + "'");
                AllLoadDate_Payroll pal = new AllLoadDate_Payroll();
                DateTime DOLDate = Util.GetDateTime(pal.getDateOfJoining(lblEmpID.Text));
                calucDate.StartDate = Util.GetDateTime(DOLDate.ToString("dd-MMM-yyyy"));
                calMonth.StartDate = Util.GetDateTime(DOLDate.ToString("dd-MMM-yyyy"));
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
            BindDate();
            txtIncArrear.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtSalArrar.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();
        }
        txtIncArrear.Attributes.Add("readonly", "readonly");
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
        lblLetter.Text = "";
        lblAccNo.Text = "";
        lblDesiID.Text = "";
        lblDesiID.Text = "";
        txtSalArrar.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtIncArrear.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtSalnarration.Text = "";
        txtSalPayableDays.Text = "";
        txtIncrementAmount.Text = "";
        txtpayableDays.Text = "";
        txtSalnarration.Text = "";
        txtSalPayableDays.Text = "";
        txtNarration.Text = "";
    }
}