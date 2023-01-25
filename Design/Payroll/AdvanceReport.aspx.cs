using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_AdvanceReport : System.Web.UI.Page
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
        if (rbtnReportType.SelectedIndex == 0)
        { AdvanceOS(); }
        else if (rbtnReportType.SelectedIndex == 1)
        {
            AdvanceEmi();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtDate.Attributes.Add("readonly", "readonly");
    }

    protected void rbtnReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnReportType.SelectedIndex == 1)
        {
            lblmsg.Text = "";
            txtDate.Visible = true;
            lbldate.Visible = true;
        }
        else
        {
            lblmsg.Text = "";
            txtDate.Visible = false;
        }
    }

    private void AdvanceEmi()
    {
        lblmsg.Text = "";
        string str = "select Emp.EmployeeID,emp.Name,Adv_ID,Amount,adv.EntDate,EMIMonth from pay_advancedetail adv inner join pay_employee_master emp on adv.EmployeeID=emp.EmployeeID where Month(EMIMonth)=Month('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') and Year(EMIMonth)=Year('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') and ifnull(IsCancel,0)=0  order by Emp.EmployeeID";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "Month Wise Loan Report";
                Session["CustomData"] = dt;
                Session["Period"] = "Salary Month " + Util.GetDateTime(txtDate.Text).ToString("MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                // ds.WriteXmlSchema("C:/AdvanceEmi.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "AdvanceEmi";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
                //  lblmsg.Text = dt.Rows.Count +" Record Found";
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            //  lblmsg.Text = "No Record Found";
        }
    }

    private void AdvanceOS()
    {
        string str = "select Emp.EmployeeID,emp.Name,Adv_ID,Amount,ReceiveAmount,(Amount-ReceiveAmount)Balance,adv.EntDate from pay_advancemaster adv inner join pay_employee_master emp on adv.EmployeeID=emp.EmployeeID  where Amount>ReceiveAmount  and STATUS<>2 order by Emp.EmployeeID";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "Loan O.S. Report";
                Session["CustomData"] = dt;
                //Session["Period"] = "Salary Month " + Util.GetDateTime(txtDate.Text).ToString("MMM-yyyy");
                Session["Period"] = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                //ds.WriteXmlSchema("C:/AdvanceOS.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "AdvanceOS";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
                //  lblmsg.Text = dt.Rows.Count + " Record Found";
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
}