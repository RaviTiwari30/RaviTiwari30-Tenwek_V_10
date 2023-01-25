using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_Miscellaneous : System.Web.UI.Page
{
    private MySqlConnection con;

    protected void AddAmount(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            string TypeID = ((Label)e.Row.FindControl("lblTypeID")).Text;

            ((TextBox)e.Row.FindControl("txtAmount")).Text = StockReports.ExecuteScalar("select Amount from pay_empsalary_detail det inner join pay_empsalary_master mst on det.MasterID=mst.ID and TypeID=" + TypeID + " and mst.EmployeeID='" + lblEmpID.Text + "' and Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') and SalaryType='S'");
        }
    }

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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "'");
        lblmsg.Text = "";

        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = string.Empty;

            int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_empsalary_master where  SalaryType='S' and month(SalaryMonth)=month('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') and year(SalaryMonth)=year('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "')"));
            if (count == 0)
            {
                //str = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID) select Employee_ID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "' from pay_employee_master where IsActive=1";
                str = " insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID,Dept_ID,Dept_Name,Desi_ID,Desi_Name) select Employee_ID,Name,BankAccountNo,'S','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',0,'" + ViewState["UserID"].ToString() + "',Dept_ID,Dept_Name,Desi_ID,Desi_Name from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on emp.Employee_ID=att.EmployeeID and DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "'))  ";
                int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    //lblmsg.Text = "Error";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }
                a = 0;
                str = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "')";

                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    //lblmsg.Text = "Error";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }
                a = 0;
                str = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where SalaryType='S' and Date(SalaryMonth)=Date('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "')";

                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                if (a == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    //  lblmsg.Text = "Error";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                    return;
                }
                a = 0;
            }
            string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where IsPost=0 and EmployeeID='" + lblEmpID.Text.Trim() + "' and SalaryType='S' and month(SalaryMonth)=month('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') order by EntDate desc").ToString();
            if (MasterID == "")
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                lblmsg.Text = "Salary already deleted or attendance not generated.";
                //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                return;
            }
            for (int i = 0; i < MiscellanousGrid.Rows.Count; i++)
            {
                str = "delete from pay_empsalary_detail where MasterID=" + MasterID + " and TypeID=" + ((Label)MiscellanousGrid.Rows[i].FindControl("lblTypeID")).Text.Trim() + "";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                string Amount = ((TextBox)MiscellanousGrid.Rows[i].FindControl("txtAmount")).Text.Trim();
                if (Amount == "")
                { Amount = "0"; }
                str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values('" + MasterID + "','" + lblEmpID.Text.Trim() + "','" + ((Label)MiscellanousGrid.Rows[i].FindControl("lblTypeID")).Text.Trim() + "','" + ((Label)MiscellanousGrid.Rows[i].FindControl("lblName")).Text.Trim() + "'," + Amount + ",'" + ((Label)MiscellanousGrid.Rows[i].FindControl("lblRemunerationTypeID")).Text.Trim() + "','" + ViewState["UserID"].ToString() + "','" + ((Label)MiscellanousGrid.Rows[i].FindControl("lblTrantypeID")).Text.Trim() + "')";
                int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
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
            }
            // lblmsg.Text = "Record Save";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);

            Tranx.Commit();
        }
        catch (Exception ex)
        {
            // lblmsg.Text = ex.Message;
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
                if (dt.Rows[0]["Basic"].ToString() != "")
                {
                    mpeCreateGroup.Show();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM201','" + lblmsg.ClientID + "');", true);
                    return;
                }
                BindData();
            }
        }
    }

    protected void EmpGrid_Sorting(object sender, GridViewSortEventArgs e)
    {
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmpID.Focus();
            ViewState["UserID"] = Session["ID"].ToString();
            BindDate();
            txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtEmpName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
        }
    }

    private void BindData()
    {
        string query = " select ID,Name,CalType,if(RemunerationType='E','Earning','Deduction')RemunerationType,tran.TransactionTypeID,RemunerationType as RemunerationTypeID from pay_remuneration_master remu inner join pay_transactiontype tran on tran.TypeID=remu.ID where remu.IsActive=1 and remu.IsInitial=1 AND remu.ID<>33";
        MiscellanousGrid.DataSource = StockReports.GetDataTable(query);
        MiscellanousGrid.DataBind();
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