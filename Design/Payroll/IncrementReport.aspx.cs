using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_IncrementReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (RadioButtonList2.SelectedItem.Text == "Word")
        {
            Session["PrintType"] = "ExpToWord";
        }
        else
        {
            Session["PrintType"] = "ExpToPDF";
        }

        string query = "select emp.Employee_ID,emp.Name,DOJ,Desi_Name,Dept_Name,DATE_FORMAT(FROM_DAYS(TO_DAYS('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " 00:00:00')-TO_DAYS(DOJ)), '%Y')+0  as ExpYr,IncrementAmount,Amount Basic from pay_employee_master emp " +
        "inner join pay_employeeremuneration rem on emp.Employee_ID=rem.Employee_ID  and IsActive=1 and TypeID=1 and Month(DOJ)=Month('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') order by emp.Employee_ID";
        DataTable dt = StockReports.GetDataTable(query).Copy();
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("Date");
            dc.DefaultValue = Util.GetDateTime(txtDate.Text).ToString("MM-yyyy");

            //dt.Columns.Add(new DataColumn("Date"));
            //dt.Columns["Date"].DefaultValue = Util.GetDateTime(txtDate.Text).ToString("MM-yyyy");
            //dt.Rows[0]["Date"] = Util.GetDateTime(txtDate.Text).ToString("MM-yyyy");
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt);

            //ds.WriteXmlSchema("C:/IncrementReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IncrementReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("MMM-yyyy");
        }
        txtDate.Attributes.Add("readonly", "true");
    }
}