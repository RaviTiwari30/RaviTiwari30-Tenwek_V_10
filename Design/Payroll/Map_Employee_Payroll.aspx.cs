using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Map_Employee_Payroll : System.Web.UI.Page
{
    protected void btnMapEmployee_Click(object sender, EventArgs e)
    {
        string ListValue = "";
        string ListValue_payroll = "";
        foreach (ListItem li in lstAvailAbleRight.Items)
        {
            if (li.Selected)
            {
                ListValue = li.Value;
            }
        }
        foreach (ListItem li_pay in lstRight.Items)
        {
            if (li_pay.Selected)
            {
                ListValue_payroll = li_pay.Value;
            }
        }
        if (ListValue == "" && ListValue_payroll == "")
        {
            lblMsg.Text = "Select Both Side Item";
            return;
        }
        bool IsUpdate = StockReports.ExecuteDML("Update Employee_master Set PayrollEmployeeID='" + ListValue_payroll + "' where Employee_ID='" + ListValue + "'");
        if (!IsUpdate)
        {
            lblMsg.Text = "Record Not Save";
            return;
        }
        else
            lblMsg.Text = "Record Save";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadHIS_Employee();
            LoadPayroll_Employee();
        }
    }

    private void LoadHIS_Employee()
    {
        DataTable dtEmployee = StockReports.GetDataTable("Select Employee_ID,Name from Employee_master where IsActive=1 order by Name");
        if (dtEmployee.Rows.Count > 0)
        {
            lstAvailAbleRight.DataSource = dtEmployee;
            lstAvailAbleRight.DataTextField = "Name";
            lstAvailAbleRight.DataValueField = "Employee_ID";
            lstAvailAbleRight.DataBind();
        }
        else
        {
            lstAvailAbleRight.Items.Clear();
        }
    }

    private void LoadPayroll_Employee()
    {
        DataTable dtEmployee = StockReports.GetDataTable("SELECT Employee_ID,CONCAT(NAME,' /',Employee_ID,' /',Dept_Name)EmpName FROM pay_employee_master order by Name");
        if (dtEmployee.Rows.Count > 0)
        {
            lstRight.DataSource = dtEmployee;
            lstRight.DataTextField = "EmpName";
            lstRight.DataValueField = "Employee_ID";
            lstRight.DataBind();
        }
        else
        {
            lstRight.Items.Clear();
        }
    }
}