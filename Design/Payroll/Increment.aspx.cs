using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_Increment : System.Web.UI.Page
{
    

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Util.GetFloat(txtIncrementAmount.Text) < 1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM190','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Amount Greater then 0";
            return;
        }

        lblmsg.Text = "";
        Save();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" select Employee_ID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  where IsActive=1 ");
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
            string str = " select Employee_ID,(select Amount from pay_employeeremuneration where TypeID=1 and Employee_ID=emp.Employee_ID)Basic,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name,IncrementAmount,Date_format(IncrementDate,'%d-%b-%Y')IncrementDate from pay_employee_master emp where Employee_ID='" + e.CommandArgument.ToString() + "' ";
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
                lblIncrement.Text = dt.Rows[0]["IncrementAmount"].ToString();
                lblIncrementDate.Text = dt.Rows[0]["IncrementDate"].ToString();
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
            txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtEmpName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            // txtDate.SetCurrentDate();
            txtIncrementAmount.Attributes.Add("onkeyup", "NewBasic();");
            txtEmpID.Focus();
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
        txtIncrementAmount.Text = "";
    }

    private void Save()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = String.Empty;
            float NewBasic = Util.GetFloat(lblBasic.Text) + Util.GetFloat(txtIncrementAmount.Text.Trim());

            str = "update pay_employeeremuneration set Amount=" + NewBasic + " where TypeID=1 and TypeName='BASIC' and Employee_ID='" + lblEmpID.Text.Trim() + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            str = "insert into pay_incrementdetail (EmployeeID,LastBasic,CurrentBasic,IncrementDate,IncrementAmt,UserID)values('" + lblEmpID.Text.Trim() + "','" + lblBasic.Text.Trim() + "','" + NewBasic + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + txtIncrementAmount.Text.Trim() + "','" + Session["ID"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            str = "SELECT ROUND(IFNULL(SUM(Amount),0)+(SELECT (Amount*(SELECT IFNULL(SUM(Amount),0) FROM pay_employeeremuneration WHERE Employee_ID='" + lblEmpID.Text.Trim() + "' AND RemunerationType='E' AND CalType='PER'))/100 FROM pay_employeeremuneration WHERE TypeID=1 AND Employee_ID='" + lblEmpID.Text.Trim() + "'),2)Amount FROM pay_employeeremuneration WHERE Employee_ID='" + lblEmpID.Text.Trim() + "' AND RemunerationType='E' AND CalType='AMT'";
            decimal TotalEarning = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));
            str = "SELECT ROUND(IFNULL(SUM(Amount),0)+(SELECT (Amount*(SELECT IFNULL(SUM(Amount),0) FROM pay_employeeremuneration WHERE Employee_ID='" + lblEmpID.Text.Trim() + "' AND RemunerationType='D' AND CalType='PER'  AND TypeID<>15))/100 FROM pay_employeeremuneration WHERE TypeID=1 AND Employee_ID='" + lblEmpID.Text.Trim() + "'),2)Amount FROM pay_employeeremuneration WHERE Employee_ID='" + lblEmpID.Text.Trim() + "' AND RemunerationType='D' AND CalType='AMT'";
            decimal TotalDeduction = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));
            str = "SELECT Amount FROM pay_employeeremuneration WHERE TypeID=15 AND Employee_ID='" + lblEmpID.Text.Trim() + "'";
            decimal ESI = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));
            TotalDeduction += (TotalEarning * ESI) / 100;
            str = "update pay_employee_master set TotalEarning=" + TotalEarning.ToString() + ", TotalDeduction=" + TotalDeduction.ToString() + ", IncrementAmount=" + txtIncrementAmount.Text.Trim() + ",IncrementDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "',LastBasic=" + lblBasic.Text.Trim() + " where Employee_ID='" + lblEmpID.Text + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            Tranx.Commit();
            //  lblmsg.Text = "Record Save Successfully ....";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();

            Clear();
        }
    }
}