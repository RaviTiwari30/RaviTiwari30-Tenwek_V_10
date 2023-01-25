using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_EmployeeReport : System.Web.UI.Page
{
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (RadioButtonList2.SelectedItem.Text == "Word")
        {
            Session["PrintType"] = "ExpToWord";
        }
        else
        {
            Session["PrintType"] = "ExpToPDF";
        }
        if (RadioButtonList1.SelectedIndex == 0)
        {
            DepartmentWise();
        }
        else if (RadioButtonList1.SelectedIndex == 1)
        {
            DesignationWise();
        }
        else if (RadioButtonList1.SelectedIndex == 2)
        {
            EmployeeSignList();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadDate_Payroll.BindDepartmentPayroll(ddlDepartment);
            AllLoadDate_Payroll.BindDesignationPayroll(ddlDesignation);
        }
    }

    private void DepartmentWise()
    {
        string str = " select EmployeeID,Name,Desi_Name,Dept_ID,Dept_Name,DOJ,RegNo from pay_employee_master where IsActive=1 ";
        if (ddlDepartment.SelectedIndex > 0)
        {
            str += " and Dept_ID=" + ddlDepartment.SelectedItem.Value + "";
        }
        if (ddlDesignation.SelectedIndex > 0)
        {
            str += " and Desi_ID=" + ddlDesignation.SelectedItem.Value + "";
        }
        str += " order by Dept_ID,EmployeeID";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("C:/EmployeeReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "EmployeeReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    private void DesignationWise()
    {
        string str = " select EmployeeID,Name,Desi_Name,Desi_ID,Dept_Name,DOJ from pay_employee_master where IsActive=1 ";
        if (ddlDesignation.SelectedIndex > 0)
        {
            str += " and Desi_ID=" + ddlDesignation.SelectedItem.Value + "";
        }
        if (ddlDepartment.SelectedIndex > 0)
        {
            str += " and Dept_ID=" + ddlDepartment.SelectedItem.Value + "";
        }
        str += " order by Desi_ID,EmployeeID";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("C:/EmployeeReportDesi.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "EmployeeReportDesi";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    private void EmployeeSignList()
    {
        string str = " select EmployeeID,Name,Desi_Name,Dept_ID,Dept_Name,DOJ from pay_employee_master where IsActive=1 ";
        if (ddlDepartment.SelectedIndex > 0)
        {
            str += " and Dept_ID=" + ddlDepartment.SelectedItem.Value + "";
        }
        if (ddlDesignation.SelectedIndex > 0)
        {
            str += " and Desi_ID=" + ddlDesignation.SelectedItem.Value + "";
        }
        str += " order by EmployeeID";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("C:/EmployeeSignList.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "EmployeeSignList";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
}