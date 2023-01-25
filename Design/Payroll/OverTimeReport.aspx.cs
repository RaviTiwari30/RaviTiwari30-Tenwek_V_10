using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_OverTimeReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (RadioButtonList2.SelectedItem.Text == "Word")
        {
            Session["PrintType"] = "ExpToWord";
        }
        else if (RadioButtonList2.SelectedItem.Text == "PDF")
        {
            Session["PrintType"] = "ExpToPDF";
        }

        OverTimeReport();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.Date.ToString("MMM-yyyy");
        }
        txtDate.Attributes.Add("readonly", "true");
    }

    private void OverTimeReport()
    {
        string str = "SELECT EmployeeID,NAME,SalaryMonth,GrossSalary,WorkingHrs,OverTimeDays,OverTimeHours,OverTimeAmount,OverTimeTax,OverTimeNetPay FROM pay_overtime WHERE MONTH(SalaryMonth)=MONTH('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') AND YEAR(SalaryMonth)=YEAR('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') order by EmployeeID";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "OverTime Report";
                Session["CustomData"] = dt;
                Session["Period"] = "Salary Month " + Util.GetDateTime(txtDate.Text).ToString("MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                //  ds.WriteXmlSchema("E:/OverTime.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "OverTime";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
}