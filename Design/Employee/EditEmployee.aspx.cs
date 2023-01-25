using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Employee_EditEmployee : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindRole(cmbDept, "All");
            txtName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
        }
    }
   
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindEmployee();
    }
    protected void BindEmployee()
    {
        string Query = " SELECT DISTINCT emp.EmployeeID EmployeeID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active FROM employee_master emp Left Outer JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID ";

        if (cmbDept.SelectedIndex > 0 && txtName.Text.Length<=0)
        {
            Query += " where RoleID="+cmbDept.SelectedItem.Value+" ";
        }
        if (txtName.Text.Length > 0 && cmbDept.SelectedIndex <= 0)
        {
            Query += " where Name like '%" + txtName.Text + "%' ";
        }
        if (txtName.Text.Length > 0 && cmbDept.SelectedIndex > 0)
        {
            Query += " where Name like '" + txtName.Text + "%' and RoleID=" + cmbDept.SelectedItem.Value + "";
        }
      
        
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
        }
    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        BindEmployee();
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Query = " SELECT NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,emp.Email,GROUP_CONCAT(rm.RoleName)RoleName FROM employee_master emp LEFT OUTER JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID LEFT JOIN f_rolemaster rm ON rm.ID=fl.RoleID ";

        if (cmbDept.SelectedIndex > 0 && txtName.Text.Length <= 0)
        {
            Query += " where RoleID=" + cmbDept.SelectedItem.Value + " ";
        }
        if (txtName.Text.Length > 0 && cmbDept.SelectedIndex <= 0)
        {
            Query += " where Name like '%" + txtName.Text + "%' ";
        }
        if (txtName.Text.Length > 0 && cmbDept.SelectedIndex > 0)
        {
            Query += " where Name like '" + txtName.Text + "%' and RoleID=" + cmbDept.SelectedItem.Value + "";
        }

        Query += "  GROUP BY emp.EmployeeID";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            Session["ReportName"] = "Employee Dept Report";
            Session["dtExport2Excel"] = dt;
            Session["Period"] = "As On Date : " + DateTime.Now.ToString("dd-MM-yyyy hh:mm:ss tt");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
    }
}
