using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_AdvanceAnainstSalary : System.Web.UI.Page
{
    private MySqlConnection objCon;

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";

        if (Util.GetFloat(txtAdvance.Text) < 1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM057','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Advance Amount Greater then 0";
            return;
        }
        if (Util.GetFloat(txtEMINO.Text) < 1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM058','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Every Month Installment Always Greater then 0";
            return;
        }
        //if (Util.GetFloat(txtAdvance.Text) > Util.GetFloat(lblBasic.Text))
        //{
        //    lblmsg.Text = "Advance Amount Greater then Basic";
        //    return;
        //}
        string AdvanceNO = Save();
        if (AdvanceNO == string.Empty)
        {
            //  lblmsg.Text = "Error";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Loan No : " + AdvanceNO + "');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" select EmployeeID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  where Isactive=1 ");
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
                txtAdvance.Focus();
                if (dt.Rows[0]["Basic"].ToString() != "")
                {
                    mpeCreateGroup.Show();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM201','" + lblmsg.ClientID + "');", true);
                    return;
                }
                AdvanceGrid.DataSource = StockReports.GetDataTable(" select Adv_ID,adv.EmployeeID,Name,amount,Date_format(adv.EntDate,'%d-%b-%Y')Date from pay_advancemaster adv inner join pay_employee_master emp on emp.EmployeeID=adv.EmployeeID  where Status=0 and adv.EmployeeID='" + dt.Rows[0]["EmployeeID"].ToString() + "'");
                AdvanceGrid.DataBind();
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmpID.Focus();
            //txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            // txtEmpName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
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
        txtAdvance.Text = "";
    }

    private String Save()
    {
        string AdvanceNO = string.Empty;
        objCon = Util.GetMySqlCon();
        try
        {
            string ADVID = StockReports.ExecuteScalar("select ID from pay_remuneration_master where Name='STAFF LOAN' and IsActive=1 and IsLoan=1");
            if (ADVID == "" || ADVID == string.Empty)
            {
                //lblmsg.Text = "Error";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                return string.Empty;
            }
            //string str = "Call Insert_Advance(?, ?, ?, ?,?,?, @ADV_Number)";
            string str = "Insert_Advance";
            MySqlParameter[] parm = new MySqlParameter[6];
            parm[0] = new MySqlParameter("@Emp_ID", lblEmpID.Text.Trim());
            parm[1] = new MySqlParameter("@Advance", Util.GetFloat(txtAdvance.Text.Trim()));
            parm[2] = new MySqlParameter("@UserID", Session["ID"].ToString());
            parm[3] = new MySqlParameter("@InstallmentNo", txtEMINO.Text);
            parm[4] = new MySqlParameter("@InstallmentAmount", Util.GetFloat(txtAdvance.Text) / Util.GetFloat(txtEMINO.Text));
            parm[5] = new MySqlParameter("@ADVID", ADVID);
            MySqlParameter parm1 = new MySqlParameter("@ADV_Number", "");
            parm1.Direction = ParameterDirection.Output;

            parm1.MySqlDbType = MySqlDbType.VarChar;
            parm1.Size = 50;

            MySqlCommand cmd = new MySqlCommand(str, objCon);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddRange(parm);
            cmd.Parameters.Add(parm1);
            objCon.Open();
            // LoanNo = Util.GetString(cmd.ExecuteNonQuery());
            //cmd.ExecuteNonQuery();
            //cmd.CommandText = "select @ADV_Number";
            AdvanceNO = cmd.ExecuteScalar().ToString();
            objCon.Close();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Record Save.";
        }
        catch (Exception ex)
        {
            //lblmsg.Text = "Error..";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            objCon.Close();
            objCon.Dispose();
            Clear();
        }
        return AdvanceNO;
    }

    //protected void CustValidator_ServerValidate(object source, ServerValidateEventArgs args)
    //{
    //    if (string.IsNullOrWhiteSpace(args.Value))
    //    {
    //        lblmsg.Text = CustValidator.ErrorMessage;
    //        args.IsValid = false;
    //    }
    //    else
    //    {
    //        lblmsg.Text = "Enter Advance Amount";
    //        args.IsValid = true;
    //    }
    //}
}