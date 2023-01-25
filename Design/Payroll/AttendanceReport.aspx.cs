using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_AttendanceReport : System.Web.UI.Page
{
    protected void BindDate()
    {
        DataTable dt = StockReports.GetDataTable(" select * from pay_attendance where Month(Attendance_To)=Month('" + Util.GetDateTime(txtSalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(Attendance_To)=Year('" + Util.GetDateTime(txtSalaryMonth.Text).ToString("yyyy-MM-dd") + "') and PayableDays" + ddlFormula.SelectedItem.Value + " " + ddlDays.SelectedItem.Value + " order by EmployeeID").Copy();
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            // ds.WriteXmlSchema("C:/Attendanc.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "Attendanc";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindDate();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSalaryMonth.Text = DateTime.Now.ToString("MMM-yyyy");
            BindDays();
        }
        txtSalaryMonth.Attributes.Add("readonly", "true");
    }

    private void BindDays()
    {
        for (int i = 0; i < 32; i++)
        {
            ListItem list = new ListItem(i.ToString(), i.ToString());
            ddlDays.Items.Add(list);
        }
    }
}