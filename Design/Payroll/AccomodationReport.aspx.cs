using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_AccomodationReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (RadioButtonList2.SelectedItem.Text == "Excel")
        {
            Session["PrintType"] = "ExpToExcel";
        }
        else if (RadioButtonList2.SelectedItem.Text == "PDF")
        {
            Session["PrintType"] = "ExpToPDF";
        }

        AccomodationReport();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSalaryMonth.Text = System.DateTime.Now.ToString("MMM-yyyy");
        }
        txtSalaryMonth.Attributes.Add("readonly", "true");
    }

    private void AccomodationReport()
    {
        string str = " select mst.EmployeeID,mst.Name EmployeeName,DATE_FORMAT(SalaryMonth,'%b-%Y')SalaryMonth,Dept_name DepartmentName,Amount  from pay_empsalary_master mst " +
       " inner join pay_empsalary_detail det on mst.ID=det.MasterID and Amount>0 and det.TypeID=44 and Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(txtSalaryMonth.Text).ToString("yyyy-MM-dd") + "') and year(mst.SalaryMonth)=Year('" + Util.GetDateTime(txtSalaryMonth.Text).ToString("yyyy-MM-dd") + "') order by mst.EmployeeID ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "Accomodation Report";
                Session["CustomData"] = dt;
                Session["Period"] = "Salary Month " + Util.GetDateTime(txtSalaryMonth.Text).ToString("MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                // ds.WriteXmlSchema("E:/AccomodationReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "AccomodationReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
}