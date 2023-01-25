using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Payroll_SSNITReport : System.Web.UI.Page
{
    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (radSelect.SelectedItem.Value == "1")
        {
            BindForExportEmployee();
        }
        else
        {
            BindForExportEmployer();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Bind();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "true");
    }

    private void Bind()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pf.EmployeeID ,pf.Name,PF_NO SSNIT_Number,Basic,PayableDays No_Of_Days,PF_Amount Employee_SSNIT,Emp_PF Employer_PF,PF_Amount+Emp_PF Total FROM pay_pf_detail pf ");
        sb.Append("INNER JOIN pay_empsalary_master mst ON mst.ID=pf.MasterID ");
        sb.Append("WHERE PF_Amount>0 AND MONTH(mst.SalaryMonth)=month('" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=year('" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "')");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            DataSet ds = new DataSet();
            DataColumn dc = new DataColumn("Salary Month");
            dc.DefaultValue = Util.GetDateTime(txtFromDate.Text).ToString("MMMM yyyy");
            dt.Columns.Add(dc);

            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            if (radSelect.SelectedItem.Value == "1")
            {
                //  ds.WriteXmlSchema("E:/SSNIT.xml");

                Session["ReportName"] = "SSNITEmployee";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
            else
            {
                //  ds.WriteXmlSchema("E:/SSNITEmployer.xml");
                Session["ReportName"] = "SSNITEmployer";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    private void BindForExportEmployee()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pf.EmployeeID 'Employee ID',pf.Name 'Employee Name',PF_NO 'SSNIT No.',Basic,PF_Amount 'Employee SSNIT',PF_Amount+Emp_PF Total FROM pay_pf_detail pf ");
        sb.Append("INNER JOIN pay_empsalary_master mst ON mst.ID=pf.MasterID ");
        sb.Append("WHERE PF_Amount>0 AND MONTH(mst.SalaryMonth)=month('" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=year('" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "')");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "SSNIT REPORT";
            Session["Period"] = "Salary Month :" + Util.GetDateTime(txtFromDate.Text).ToString("MMMM yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    private void BindForExportEmployer()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pf.EmployeeID 'Employee ID',pf.Name 'Employee Name',PF_NO 'SSNIT No.',Basic,Emp_PF 'Employer SSNIT' FROM pay_pf_detail pf ");
        sb.Append("INNER JOIN pay_empsalary_master mst ON mst.ID=pf.MasterID ");
        sb.Append("WHERE PF_Amount>0 AND MONTH(mst.SalaryMonth)=month('" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=year('" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "')");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "SSNIT REPORT";
            Session["Period"] = "Salary Month :" + Util.GetDateTime(txtFromDate.Text).ToString("MMMM yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
}