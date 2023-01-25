using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_SalaryProcessEmployeeWise : System.Web.UI.Page
{
    private int a = 0;
    private float AttendancePercent = 0;
    private float Basic = 0, ActualBasic = 0, Req_Days = 0, Present_Days = 0, Req_Hours = 0, Present_Hours = 0, OneDayBasic = 0, OneHrBasic = 0;
    private MySqlConnection con;
    private string EmpID = string.Empty;
    private float OneDaysHr = 0;
    private string Query = string.Empty;
    private string Str = string.Empty;

    protected void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnSave.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Please Post Attendance";
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string Query = string.Empty;
        string EmployeeID = string.Empty;
        int acount = 0;
        foreach (GridViewRow row in GridView1.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                acount += 1;
                EmployeeID = ((Label)row.FindControl("lblEmployeeID")).Text;
                Query = "SELECT COUNT(*) FROM pay_empsalary_master WHERE EmployeeID='' AND SalaryType='S'";
                int count = Util.GetInt(StockReports.ExecuteScalar(Query));
                if (count > 0)
                {
                    lblmsg.Text = "Employee ID : " + EmployeeID + " Salary Already Exist.";
                    return;
                }
            }
        }
        if (acount <= 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM073','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Select Employee";
            return;
        }

        lblmsg.Text = "";

        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionType = "1";

            foreach (GridViewRow row in GridView1.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");

                    EmployeeID = ((Label)row.FindControl("lblEmployeeID")).Text;
                    Query = "select emp.Employee_ID,emp.Name,Emp.BankAccountNo from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on att.EmployeeID=emp.Employee_ID and DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))   and emp.Employee_ID='" + EmployeeID + "'";
                    DataTable EmpDetail = StockReports.GetDataTable(Query);

                    Query = " select emp.Employee_ID,Emp.Name,Remun.TypeID,Remun.TypeName,Remun.Amount,Remun.CalType,Remun.RemunerationType, " +
                    " Remun.Per_Cal_Amt,Remun.Per_Cal_On,Remun.IsFix,rm.IsPF from pay_employeeRemuneration Remun inner join " +
                    "  pay_remuneration_master rem on rem.ID=Remun.TypeID and rem.isActive=1 inner join" +
                    "   (select Employee_ID,Name,ISACTIVE from pay_employee_master emp where DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "')) )emp on emp.Employee_ID=Remun.Employee_ID left join pay_remuneration_master rm on rm.ID=Remun.TypeID where emp.Employee_ID='" + EmployeeID + "' order by emp.Employee_ID ";

                    DataTable EmpSalaryDetail = StockReports.GetDataTable(Query);

                    Query = "select ID,EmployeeID,Name,WorkDays,WorkHours,PayableDays,PayableHours from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and  Year(Attendance_To)=Year('" + txtDate.Text + "') and EmployeeID='" + EmployeeID + "'";
                    DataTable dtAttendance = StockReports.GetDataTable(Query);
                    if (dtAttendance.Rows.Count == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM071','" + lblmsg.ClientID + "');", true);
                        //lblmsg.Text = "Attendance Not available";
                        return;
                    }

                    if (EmpDetail.Rows.Count > 0)
                    {
                        /////////////////Save Salary Master
                        int count = Util.GetInt(StockReports.ExecuteScalar(" select count(*) from pay_empsalary_master where SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') AND EmployeeID='" + EmployeeID + "'"));
                        if (count == 0)
                        {
                            Query = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID,Dept_ID,Dept_Name,Desi_ID,Desi_Name) select Employee_ID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "',Dept_ID,Dept_Name,Desi_ID,Desi_Name from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on emp.Employee_ID=att.EmployeeID and DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))  AND EmployeeID='" + EmployeeID + "'   ";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                            if (a == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                //lblmsg.Text = "Error";
                                return;
                            }

                            Query = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')  AND EmployeeID='" + EmployeeID + "'";

                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                            if (a == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                //lblmsg.Text = "Error";
                                return;
                            }
                            a = 0;
                            Query = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')  AND EmployeeID='" + EmployeeID + "'";

                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                            if (a == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                //lblmsg.Text = "Error";
                                return;
                            }
                            a = 0;
                        }
                        Query = "update pay_empsalary_master mst inner join (select PayableDays,EmployeeID from pay_attendance  " +
                           " where   Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on att.EmployeeID=mst.EmployeeID set mst.PayableDays=att.PayableDays  where  mst.SalaryType='S' and Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') and mst.EmployeeID='" + EmployeeID + "'";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);

                        for (int i = 0; i < EmpDetail.Rows.Count; i++)
                        {
                            EmpID = EmpDetail.Rows[i]["Employee_ID"].ToString();
                            DataRow[] RowBasic = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "' AND CalType='AMT' AND TypeName='BASIC' And TypeID=1");
                            if (RowBasic.Length != 1)
                            {
                                DataRow dr = EmpSalaryDetail.NewRow();
                                dr["Employee_ID"] = EmpID;
                                dr["CalType"] = "AMT";
                                dr["TypeName"] = "BASIC";
                                dr["RemunerationType"] = "E";
                                dr["TypeID"] = "1";
                                EmpSalaryDetail.Rows.Add(dr);
                                RowBasic = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "' AND CalType='AMT' AND TypeName='BASIC' And TypeID=1");
                            }
                            //Basic = Util.GetFloat(StockReports.ExecuteScalar("select Remun.Amount from pay_employee_master emp inner join pay_employeeRemuneration Remun on emp.Employee_ID=Remun.Employee_ID where DOL='0001-01-01 00:00:00' and TypeName='BASIC' AND EMP.Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"] + "'"));
                            Basic = Util.GetFloat(RowBasic[0]["Amount"]);
                            DataRow[] Att_row = dtAttendance.Select("EmployeeID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "'");
                            if (Att_row.Length != 1)
                            {
                                //Tranx.Rollback();
                                //Tranx.Dispose();
                                //con.Close();//con.Dispose();
                                //lblmsg.Text = "Error";
                                //return;
                                Present_Days = 0;
                                Present_Hours = 0;
                                Req_Days = 0;
                                Req_Hours = 0;
                                ///one day working hr.
                                OneDaysHr = 8;
                            }
                            else
                            {
                                Present_Days = Util.GetFloat(Att_row[0]["PayableDays"].ToString());
                                Present_Hours = Util.GetFloat(Att_row[0]["PayableHours"].ToString());/////////////////////////
                                Req_Days = Util.GetFloat(Att_row[0]["WorkDays"].ToString());///////////////////////////
                                Req_Hours = Util.GetFloat(Att_row[0]["WorkHours"].ToString());/////////////////////////////
                                ///one day working hr.
                                OneDaysHr = 8;
                            }
                            if (rbtnCalOn.SelectedItem.Text == "Days")
                            {
                                /////////////////////Find Payable Basic

                                OneDayBasic = Basic / Req_Days;
                                OneHrBasic = OneDayBasic / OneDaysHr;

                                Present_Hours = OneDaysHr * Present_Days;
                                ActualBasic = Present_Hours * OneHrBasic;

                                ////////////////Find Attendance Percentage
                                AttendancePercent = Present_Days * 100 / Req_Days;
                            }
                            else if (rbtnCalOn.SelectedItem.Text == "Hours")
                            {
                                /////////////////////Find Payable Basic

                                OneDayBasic = Basic / Req_Days;
                                OneHrBasic = OneDayBasic / OneDaysHr;
                                Present_Hours = 240;////////
                                ActualBasic = Present_Hours * OneHrBasic;

                                ////////////////Find Attendance Percentage
                                AttendancePercent = Present_Hours * 100 / Req_Hours;
                            }

                            string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where EmployeeID='" + EmpID + "' and SalaryType='S' and Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')  order by SalaryMonth desc").ToString();
                            ////////////////////Save Detail of Salary
                            Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType,ActualAmount)values('" + MasterID + "','" + EmpID + "','" + RowBasic[0]["TypeID"].ToString() + "','" + RowBasic[0]["TypeName"].ToString() + "'," + ActualBasic + ",'" + RowBasic[0]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "','" + TransactionType + "','" + Basic + "')";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                            if (a == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                //lblmsg.Text = "Error";
                                return;
                            }
                            a = 0;
                            ///////////Calculate Other Allowance(Depend on AttendancePercent)

                            DataRow[] RowAmt = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "' AND RemunerationType='E' AND CalType='AMT' AND TypeName<>'BASIC'");
                            if (RowAmt.Length > 0)
                            {
                                for (int j = 0; j < RowAmt.Length; j++)
                                {
                                    float NetAmount = Util.GetFloat(RowAmt[j]["Amount"].ToString()) * AttendancePercent / 100;
                                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType,ActualAmount)values('" + MasterID + "','" + EmpID + "','" + RowAmt[j]["TypeID"].ToString() + "','" + RowAmt[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowAmt[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ",'" + Util.GetFloat(RowAmt[j]["Amount"].ToString()) + "')";
                                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                                    if (a == 0)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                        //lblmsg.Text = "Error";
                                        return;
                                    }
                                    a = 0;
                                }
                            }
                            DataRow[] RowAmtD = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"].ToString() + "' AND RemunerationType='D' AND CalType='AMT' AND TypeName<>'BASIC'");
                            if (RowAmtD.Length > 0)
                            {
                                for (int j = 0; j < RowAmtD.Length; j++)
                                {
                                    float NetAmount = Util.GetFloat(RowAmtD[j]["Amount"].ToString());
                                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType,ActualAmount)values('" + MasterID + "','" + EmpID + "','" + RowAmtD[j]["TypeID"].ToString() + "','" + RowAmtD[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowAmtD[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ",'" + NetAmount + "')";
                                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                                    if (a == 0)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                        //lblmsg.Text = "Error";
                                        return;
                                    }
                                    a = 0;
                                }
                            }
                            ///////////Calculate Other Allowance(Depend on Basic)
                            DataRow[] RowPer = EmpSalaryDetail.Select("Employee_ID='" + EmpDetail.Rows[i]["Employee_ID"] + "' AND CalType='PER' and IsFix=0");
                            if (RowPer.Length > 0)
                            {
                                for (int j = 0; j < RowPer.Length; j++)
                                {
                                    float NetAmount = Util.GetFloat(RowPer[j]["Amount"].ToString()) * ActualBasic / 100;
                                    float ActualAmount = Util.GetFloat(RowPer[j]["Amount"].ToString()) * Basic / 100;
                                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType,ActualAmount)values('" + MasterID + "','" + EmpID + "','" + RowPer[j]["TypeID"].ToString() + "','" + RowPer[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowPer[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ",'" + ActualAmount + "')";
                                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                                    if (a == 0)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                        //lblmsg.Text = "Error";
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
                                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType,ActualAmount)values('" + MasterID + "','" + EmpID + "','" + RowFix[j]["TypeID"].ToString() + "','" + RowFix[j]["TypeName"].ToString() + "'," + NetAmount + ",'" + RowFix[j]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "'," + TransactionType + ",'" + NetAmount + "')";
                                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                                    if (a == 0)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                        //lblmsg.Text = "Error";
                                        return;
                                    }
                                    a = 0;
                                }
                            }
                        }
                        //for earning
                        Query = " update pay_empsalary_master mas inner join (select MasterID,round(sum(Amount))Amount from pay_empsalary_detail d inner join pay_empsalary_master mst on mst.ID=d.MasterID " +
                        " where RemunerationType='E' and Month(mst.SalaryMonth)=month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') group by MasterID )det on mas.ID=det.MasterID set mas.TotalEarning=Round(det.Amount+0.1) where IsPost=0 and mas.EmployeeID='" + EmployeeID + "'";

                        a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);

                        ///////calculate Total Earning Round Off
                        Query = " update pay_empsalary_master mas inner join (select MasterID,round(sum(Amount),2)Amount from pay_empsalary_detail d inner join pay_empsalary_master mst on mst.ID=d.MasterID " +
                        " where RemunerationType='E' and Month(mst.SalaryMonth)=month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') group by MasterID )det on mas.ID=det.MasterID set ERound=Round(TotalEarning-Amount,2) where IsPost=0 and mas.EmployeeID='" + EmployeeID + "'";
                        //Comment for ghana
                        //a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);

                        //for deduction
                        Query = " update pay_empsalary_master mas inner join (select MasterID,round(sum(Amount),2)Amount from pay_empsalary_detail d inner join pay_empsalary_master mst on mst.ID=d.MasterID " +
                        " where RemunerationType='D' and Month(mst.SalaryMonth)=month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') group by MasterID )det on mas.ID=det.MasterID set mas.TotalDeduction=det.Amount  where IsPost=0 and mas.EmployeeID='" + EmployeeID + "'";

                        a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);

                        //Net Payable
                        Query = "update pay_empsalary_master set NetPayable=Round(TotalEarning-TotalDeduction) where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') and EmployeeID='" + EmployeeID + "'";

                        a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                        a = 0;
                    }
                }
            }
            ///Transaction Commit
            Tranx.Commit();
            btnSave.Enabled = false;
            SearchData();
            //SearchSalaryData();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = ex.Message;
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                ((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked = CheckBox1.Checked;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            BindDate();
            SearchData();
            //SearchSalaryData();
        }
    }

    protected void SearchData()
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");

        sb.Append(" SELECT Employee_ID,NAME,Dept_Name,Desi_Name,PayableDays FROM pay_employee_master emp INNER JOIN  ");
        sb.Append(" (SELECT EmployeeID,PayableDays FROM pay_attendance WHERE MONTH(Attendance_To)=MONTH('" + txtDate.Text + "') AND YEAR(Attendance_To)=YEAR('" + txtDate.Text + "')) att ");
        sb.Append(" ON emp.Employee_ID=att.EmployeeID AND DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))   AND EmployeeID NOT IN (SELECT EmployeeID FROM pay_empsalary_master WHERE SalaryType='S' AND MONTH(SalaryMonth)=MONTH('" + txtDate.Text + "') AND YEAR(SalaryMonth)=YEAR('" + txtDate.Text + "'))");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            GridView1.DataSource = dt;
            GridView1.DataBind();
            btnSave.Enabled = true;
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            // lblmsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            btnSave.Enabled = false;
        }
    }

    protected void SearchSalaryData()
    {
        lblmsg.Text = "";
        DataTable DtItems = StockReports.GetDataTable("select det.MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "')  group by TypeID,EmployeeID,SalaryType,MasterID order by det.EmployeeID,det.TypeID");
        DataTable DtNetPayable = StockReports.GetDataTable("select EmployeeID,TotalEarning,TotalDeduction,NetPayable,SalaryType,ID from pay_empsalary_master where Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') order by EmployeeID");
        DataTable Employee = StockReports.GetDataTable("select distinct mst.EmployeeID,mst.ID,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') order by EmployeeID,TypeID");
        DataTable dt = StockReports.GetDataTable("select Name from pay_remuneration_master where IsActive=1 order by ID");
        //DataTable dtOther = StockReports.GetDataTable("select Name from pay_remuneration_master where isloan=1 order by ID");
        DataTable CrossTab = new DataTable();
        if (dt.Rows.Count == 0 || DtItems.Rows.Count == 0 || Employee.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "No Record Found";
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            return;
        }
        CrossTab.Columns.Add(new DataColumn("EmployeeID"));
        CrossTab.Columns.Add(new DataColumn("SalaryType"));
        CrossTab.Columns.Add(new DataColumn("ID"));
        foreach (DataRow row in dt.Rows)
        {
            CrossTab.Columns.Add(new DataColumn(row["Name"].ToString()));
        }

        for (int i = 0; i < Employee.Rows.Count; i++)
        {
            DataRow newrow = CrossTab.NewRow();
            newrow["EmployeeID"] = Employee.Rows[i]["EmployeeID"].ToString();
            DataRow[] row = DtItems.Select("EmployeeID='" + Employee.Rows[i]["EmployeeID"].ToString() + "' and MasterID='" + Employee.Rows[i]["ID"].ToString() + "' and SalaryType='" + Employee.Rows[i]["SalaryType"].ToString() + "'");
            for (int j = 0; j < row.Length; j++)
            {
                //string ColumnName = CrossTab.Columns[j+1].ColumnName;
                string ColumnName = row[j]["TypeName"].ToString();
                newrow[ColumnName] = row[j]["Amount"].ToString();
            }
            newrow["SalaryType"] = Employee.Rows[i]["SalaryType"].ToString();
            newrow["ID"] = Employee.Rows[i]["ID"].ToString();
            CrossTab.Rows.Add(newrow);
        }

        CrossTab.Columns.Add(new DataColumn("TotalEarning"));
        CrossTab.Columns.Add(new DataColumn("TotalDeduction"));
        CrossTab.Columns.Add(new DataColumn("NetPayable"));
        for (int i = 0; i < CrossTab.Rows.Count; i++)
        {
            DataRow[] row = DtNetPayable.Select("EmployeeID='" + CrossTab.Rows[i]["EmployeeID"].ToString() + "' and ID='" + CrossTab.Rows[i]["ID"].ToString() + "' and SalaryType='" + CrossTab.Rows[i]["SalaryType"].ToString() + "'");
            if (row.Length > 0)
            {
                CrossTab.Rows[i]["TotalEarning"] = row[0]["TotalEarning"].ToString();
                CrossTab.Rows[i]["TotalDeduction"] = row[0]["TotalDeduction"].ToString();
                CrossTab.Rows[i]["NetPayable"] = row[0]["NetPayable"].ToString();
            }
        }

        CrossTab.Columns.Remove("ID");
        // CrossTab.Columns["ID"].
        // CrossTab.Columns["ID"].Dispose();
        if (CrossTab.Rows.Count > 0)
        {
            EmpGrid.DataSource = CrossTab;
            EmpGrid.DataBind();
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
        }
    }
}