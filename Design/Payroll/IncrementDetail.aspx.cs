using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_IncrementDetail : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        sb.Append(" select Employee_ID,Name,Dept_Name,Desi_Name,inc.LastBasic,Date_Format(inc.IncrementDate,'%d-%b-%Y')IncrementDate,inc.IncrementAmt,CurrentBasic NewBasic from pay_employee_master emp inner join");
        sb.Append(" pay_incrementdetail inc on inc.EmployeeID=emp.EMployee_ID where inc.IncrementDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and inc.IncrementDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Employee_ID='" + txtEmpID.Text.Trim() + "' and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() == "" && txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like '" + txtEmpName.Text.Trim() + "%' ");
        }
        else if (txtEmpID.Text.Trim() != "" && txtEmpName.Text.Trim() == "")
        {
            sb.Append(" and Employee_ID='" + txtEmpID.Text.Trim() + "'");
        }
        sb.Append(" order by Employee_ID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            // lblmsg.Text = dt.Rows.Count + " Record Find";
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
        }
        else
        {
            // lblmsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmpID.Focus();
            txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtEmpName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            // txtDate.SetCurrentDate();
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
}