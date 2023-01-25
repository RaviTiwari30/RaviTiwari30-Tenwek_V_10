using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_AccomodationMaster : System.Web.UI.Page
{
    private int a = 0;

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

    protected void btnAccomodation_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        decimal AccomodationAmt = Util.GetDecimal(txtAccomodationAmt.Text);
        decimal AccomodationTaxAmt = 0;
        decimal AccomodationNetAmt = 0;
        if (AccomodationAmt > 0)
        {
            AccomodationTaxAmt = Util.GetDecimal((AccomodationAmt * 10) / 100);
            AccomodationNetAmt = Util.GetDecimal(AccomodationAmt - AccomodationTaxAmt);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = string.Empty;
            int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_empsalary_master where  SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and year(SalaryMonth)=year('" + txtDate.Text + "')"));
            if (count == 0)
            {
                string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
                str = " insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID,Dept_ID,Dept_Name,Desi_ID,Desi_Name) select EmployeeID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "',Dept_ID,Dept_Name,Desi_ID,Desi_Name from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on emp.EmployeeID=att.EmployeeID and  DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))  ";
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

            str = "delete from pay_empsalary_detail where MasterID=" + MasterID + " and TypeID IN(44,49)";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            //str = "delete from Pay_Accomodation where MasterID=" + MasterID + "";
            //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            string Amount = Util.GetString(Math.Round(AccomodationAmt, 2));
            if (Amount == "")
            {
                Amount = "0";
            }
            if (Util.GetDecimal(Amount) > 0)
            {
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','44','" + lblTypeName.Text.Trim() + "'," + AccomodationAmt + ",'E','" + ViewState["UserID"].ToString() + "','7')";
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
                //For Accomodation Tax Shatrughan 16.12.13
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','49','ACCOMMODATION TAX'," + AccomodationTaxAmt + ",'D','" + ViewState["UserID"].ToString() + "','7')";
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
                //str = "INSERT INTO Pay_Accomodation(EmployeeID,NAME,MasterID,SalaryMonth,AccomodationAmount,AccomodationTax,AccomodationNetPay,UserID)VALUES('" + lblEmpID.Text.Trim() + "','" + lblEmpName.Text + "','" + MasterID + "','" + txtDate.Text + "','" + AccomodationAmt + "','" + AccomodationTaxAmt + "','" + AccomodationNetAmt + "','" + ViewState["UserID"].ToString() + "');";
                //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
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
        sb.Append(" select EmployeeID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  WHERE DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "')) ");
        if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and EmployeeID='" + txtEmpID.Text.Trim() + "' and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() == "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like '%" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() == "")
        {
            sb.Append(" and EmployeeID='" + txtEmpID.Text.Trim() + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
            lblTypeName.Text = StockReports.ExecuteScalar("select Name from pay_remuneration_master where ID=44").ToString();
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
            string str = " select EmployeeID,(select Amount from pay_employeeremuneration where TypeID=1 and EmployeeID=emp.EmployeeID)Basic,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master emp where EmployeeID='" + e.CommandArgument.ToString() + "' ";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                Clear();
                lblEmpID.Text = dt.Rows[0]["EmployeeID"].ToString();
                lblEmpName.Text = dt.Rows[0]["Name"].ToString();
                lblFatherName.Text = dt.Rows[0]["FatherName"].ToString();
                lblDOJ.Text = dt.Rows[0]["DOJ"].ToString();
                lblDept.Text = dt.Rows[0]["dept_Name"].ToString();
                lblDesi.Text = dt.Rows[0]["desi_Name"].ToString();
                lblBasic.Text = dt.Rows[0]["Basic"].ToString();

                lblWorkedDays.Text = StockReports.ExecuteScalar("select WorkDaysInMonth from pay_attendance where EmployeeID='" + lblEmpID.Text.Trim() + "' AND MONTH(Attendance_From)=Month('" + txtDate.Text.Trim() + "') AND YEAR(Attendance_From)=YEAR('" + txtDate.Text.Trim() + "')");
                if (lblWorkedDays.Text == "0")
                {
                    lblmsg.Text = "Please First Set Attendance";
                    return;
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT mst.EmployeeID,Amount FROM pay_empsalary_master mst ");
                sb.Append("  INNER JOIN pay_empsalary_detail det ON mst.ID=det.MasterID AND Amount>0 AND det.TypeID IN(44,49) AND ");
                sb.Append("  MONTH(mst.SalaryMonth)=Month('" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=YEAR('" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "') ");
                sb.Append("  AND  mst.EmployeeID='" + lblEmpID.Text.Trim() + "' ");
                DataTable Accomodation = StockReports.GetDataTable(sb.ToString());
                if (Accomodation.Rows.Count > 0)
                {
                    txtAccomodationAmt.Text = Accomodation.Rows[0]["Amount"].ToString();
                    txtAccomodationTaxAmt.Text = Accomodation.Rows[1]["Amount"].ToString();
                }
                else
                {
                    txtAccomodationAmt.Text = "0";
                    txtAccomodationTaxAmt.Text = "0";
                }
                //StringBuilder sb1 = new StringBuilder();
                //sb1.Append("   SELECT Amount FROM pay_empsalary_master mst ");
                //sb1.Append("  INNER JOIN pay_empsalary_detail det ON mst.ID=det.MasterID AND Amount>0 AND det.TypeID IN(49) AND ");
                //sb1.Append("  MONTH(mst.SalaryMonth)=Month('" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=YEAR('" + Util.GetDateTime( txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "') ");
                //sb1.Append("  AND  mst.EmployeeID='" + lblEmpID.Text + "' ");
                //DataTable AccomodationTax = StockReports.GetDataTable(sb1.ToString());
                //if (AccomodationTax.Rows.Count > 0)
                //{
                //    txtAccomodationTaxAmt.Text = AccomodationTax.Rows[0]["Amount"].ToString();

                //}
                //else
                //{
                //    txtAccomodationTaxAmt.Text = "0";
                //}
                if (dt.Rows[0]["Basic"].ToString() != "")
                {
                    mpeCreateGroup.Show();
                    //  ScriptManager.GetCurrent(this).SetFocus(this.txtAccomodationAmt);
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
            txtAccomodationAmt.Attributes.Add("onKeyUp", "CalAccomodation()");
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