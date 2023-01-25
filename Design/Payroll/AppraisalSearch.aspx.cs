using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_AppraisalSearch : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string Query = "SELECT AppraisalNo,EmployeeID,emp.Name,Dept_Name,Desi_Name,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,DATE_FORMAT(ans.EntDate,'%d-%b-%Y')DATE,AppraisalType FROM pay_appraisal_answer ans INNER JOIN pay_employee_master emp ON ans.EmployeeID=emp.EmployeeID   ";
        if (chkDate.Checked)
        {
            Query += " where Date(ans.EntDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and Date(ans.EntDate)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'";
            Query += " and ";
        }
        else
        {
            Query += " where  ";
        }
        Query += " AppraisalID=" + ddlAppraisal.SelectedValue + " ";

        Query += " GROUP BY AppraisalNo ";
        DataTable dt = StockReports.GetDataTable(Query);

        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "No Record Found";
        }
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string str = " SELECT EmployeeID,emp.Name,Desi_Name,Dept_Name,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,qm.Question_ID,Question,GroupHeader,Answer,AppraisalEntryEmployeeID,ans.AppraisalType,(SELECT NAME FROM pay_employee_master WHERE EmployeeID=AppraisalEntryEmployeeID)EntryUserName,(SELECT COMMENT FROM pay_appraisalcomment WHERE AppraisalNo=" + e.CommandArgument.ToString() + "  LIMIT 1)Comments FROM pay_appraisal_answer ans INNER JOIN pay_appraisal_questionmaster qm ON ans.Question_ID=qm.Question_ID " +
        " INNER JOIN pay_employee_master emp ON ans.EmployeeID=emp.EmployeeID " +
        "   WHERE AppraisalNO=" + e.CommandArgument.ToString() + " ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            Session["ReportName"] = "Appraisal";
            //ds.WriteXmlSchema("C:/Appraisal.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoadDate_Payroll.BindAppraisalStartDate(ddlAppraisal);
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }
}