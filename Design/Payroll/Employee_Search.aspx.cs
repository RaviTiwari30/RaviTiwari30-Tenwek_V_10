using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Employee_Search : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        EmployeeSearch();
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "Personal")
        {
            Response.Redirect("~/Design/Payroll/Employee_Registration.aspx?EmpID=" + e.CommandArgument.ToString());
        }
        else if (e.CommandName.ToString() == "Professional")
        { Response.Redirect("~/Design/Payroll/Employee_ProfessionalDetail_New.aspx?EmpID=" + e.CommandArgument.ToString()); }
        else if (e.CommandName.ToString() == "Finance")
        { Response.Redirect("~/Design/Payroll/FinanceSalary.aspx?EmpID=" + e.CommandArgument.ToString()); }
    }

    protected void EmployeeSearch()
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" select RegNo, em.EmployeeID,Name,FatherName,Gender,Date_format(DOL,'%d %b %y')DOL,Round(TotalEarning,0)TotalEarning,DATE_FORMAT(DOL,'%d %b %Y')DOL,DATE_FORMAT(DOB,'%d %b %y')DOB,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,concat(House_No,' ',Street_Name,' ',Locality,' ',City)Address,Dept_Name,Desi_Name from employee_master em INNER JOIN centre_Access ca ON ca.EmployeeID= em.EmployeeID WHERE ca.IsActive=1 AND ca.CentreAccess=" + Util.GetInt(Session["CentreID"]) + "  and em.IsActive in(" + DropDownList1.SelectedItem.Value + ")");
        if (txtEmp_ID.Text != "")
        {
            sb.Append(" and RegNo='" + txtEmp_ID.Text + "' ");
        }
        if (txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like'%" + txtEmpName.Text.Trim() + "%'");
        }
        if (ddlDepartment.SelectedIndex != 0)
        {
            sb.Append(" and Dept_ID='" + ddlDepartment.SelectedItem.Value + "'");
        }
        if (ddlDesignation.SelectedIndex != 0)
        {
            sb.Append(" and Desi_ID='" + ddlDesignation.SelectedItem.Value + "'");
        }
        sb.Append(" order by em.EmployeeID");

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
        //EmpGrid.Columns[6].Visible = false;
        //EmpGrid.Columns[7].Visible = false;
        if (ViewState["RoleID"].ToString() == "60")
        {
            EmpGrid.Columns[6].Visible = false;
        }
        else
        {
            if (DropDownList1.SelectedItem.Text == "Deactive")
            {
                EmpGrid.Columns[7].Visible = false;
            }
            else
            {
                EmpGrid.Columns[7].Visible = false;
            }
            EmpGrid.Columns[6].Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadDate_Payroll.BindDepartmentPayroll(ddlDepartment);
            AllLoadDate_Payroll.BindDesignationPayroll(ddlDesignation);
            ViewState["RoleID"] = Session["RoleID"].ToString();
            btnSearch.Attributes.Add("onclick", "this.disabled=true;" + GetPostBackEventReference(btnSearch).ToString());
        }
    }

    private void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("select Dept_ID,Dept_Name from Pay_deptartment_master where IsActive=1");
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataValueField = "Dept_ID";
        ddlDepartment.DataTextField = "Dept_Name";

        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, "--------------------------");
    }

    private void BindDesignation()
    {
        DataTable dt = StockReports.GetDataTable("select Des_ID,Designation_Name from Pay_designation_master order by Designation_Name");
        ddlDesignation.DataSource = dt;
        ddlDesignation.DataValueField = "Des_ID";
        ddlDesignation.DataTextField = "Designation_Name";
        ddlDesignation.DataBind();
        ddlDesignation.Items.Insert(0, "--------------------------");
    }
}