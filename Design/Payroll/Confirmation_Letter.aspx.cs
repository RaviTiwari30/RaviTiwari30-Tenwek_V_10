using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Confirmation_Letter : System.Web.UI.Page
{
    protected void btmSubmit_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string query = "  SELECT EmployeeID,emp.NAME,Desi_Name,Dept_Name,DATE_FORMAT(DOJ,'%d %b %Y')DOJ,emp.ProbationPeriod,ProbationPeriodComplete,ProbationPeriodCompleteDate,IF(IFNULL(cl.EmployeeID,'')='','false','true')Print FROM pay_employee_master emp LEFT JOIN pay_confirmatinletter cl ON emp.EmployeeID=cl.EmployeeID where Month(ProbationPeriodCompleteDate)=Month('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "') and Year(ProbationPeriodCompleteDate)=Year('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "')";
        DataTable dt = StockReports.GetDataTable(query);
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            StockReports.ExecuteDML("delete from Pay_confirmatinletter where EmployeeID='" + lblEmployeeid.Text + "'");

            string query = "Insert Into Pay_confirmatinletter(employeeid,name,designation,issuedate,Confirmationdate,grasssalary,hospitalname,authorityname,authoritydesignation,authoritydepartment,ProbationPeriod,UserID) values('" + lblEmployeeid.Text + "','" + lblName.Text + "','" + lblDesigantion.Text + "','" + Util.GetDateTime(txtissuedate.Text).ToString("yyyy-MM-dd") + "','" + ViewState["Confirmationdate"].ToString() + "','" + Util.GetString(txtgrossslry.Text) + "','" + txtHospitalname.Text + "','" + txtAuthorityname.Text + "','" + txtauthoritydesig.Text + "','" + txtAuthorityDepartment.Text + "','" + lblProbation.Text + "','" + ViewState["ID"].ToString() + "')";
            StockReports.ExecuteDML(query);
            string FetchForReport = StockReports.ExecuteScalar("select Max(ID) from  Pay_confirmatinletter");
            query = "select * from  Pay_confirmatinletter where id='" + FetchForReport + "'";
            DataTable DTR = new DataTable();
            DTR = StockReports.GetDataTable(query);
            DataSet DS = new DataSet();
            Session["ReportName"] = "ConfirmationLetter";
            DS.Tables.Add(DTR.Copy());
            Session["ds"] = DS;
            // DS.WriteXmlSchema("C:/ConfirmationLetter.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Record Saved";
            Clear();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = ex.Message;
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }

    protected void Clear()
    {
        lblDesigantion.Text = "";
        lblEmployeeid.Text = "";
        lblProbation.Text = "";
        lblName.Text = "";
        txtissuedate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtHospitalname.Text = "";
        txtgrossslry.Text = "";
        txtAuthorityname.Text = "";
        txtauthoritydesig.Text = "";
        txtAuthorityDepartment.Text = "";
    }

    protected void EmpGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            DateTime ProbDate = Util.GetDateTime(((Label)e.Row.FindControl("lblDOJ")).Text);
            int addmonth = Util.GetInt(((Label)e.Row.FindControl("lblprobationperiod")).Text);
            ProbDate = ProbDate.AddMonths(addmonth);
            ((Label)e.Row.FindControl("lblConfirmDate")).Text = ProbDate.ToString("dd-MMM-yyyy");
            ViewState["Confirmationdate"] = ProbDate.ToString("dd-MMM-yyyy");
        }
    }

    protected void grirecord_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Select")
        {
            Clear();
            String Query = string.Empty;
            if (Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_confirmatinletter where EmployeeID='" + e.CommandArgument.ToString() + "'")) > 0)
            {
                Query = "SELECT * FROM Pay_confirmatinletter WHERE EmployeeID='" + e.CommandArgument.ToString() + "'";
                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(Query);
                lblEmployeeid.Text = dt.Rows[0]["EmployeeID"].ToString();
                lblName.Text = dt.Rows[0]["NAME"].ToString();
                lblDesigantion.Text = dt.Rows[0]["Designation"].ToString();
                lblProbation.Text = dt.Rows[0]["ProbationPeriod"].ToString();
                txtAuthorityname.Text = dt.Rows[0]["AuthorityName"].ToString();
                txtauthoritydesig.Text = dt.Rows[0]["AuthorityDesignation"].ToString();
                txtAuthorityDepartment.Text = dt.Rows[0]["AuthorityDepartment"].ToString();
                txtgrossslry.Text = dt.Rows[0]["GrassSalary"].ToString();
                txtissuedate.Text = Util.GetDateTime(dt.Rows[0]["IssueDate"]).ToString("dd-MMM-yyyy");
                //txtissuedate.SetDate(Util.GetDateTime(dt.Rows[0]["IssueDate"]).Day.ToString(), Util.GetDateTime(dt.Rows[0]["IssueDate"]).Month.ToString(), Util.GetDateTime(dt.Rows[0]["IssueDate"]).Year.ToString());
                txtHospitalname.Text = dt.Rows[0]["HospitalName"].ToString();
            }
            else
            {
                Query = "select EmployeeID,CONCAT(title,' ',NAME)NAME,Desi_Name,Dept_Name,ProbationPeriod from  pay_employee_master where EmployeeID='" + e.CommandArgument.ToString() + "' ";
                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(Query);
                lblEmployeeid.Text = dt.Rows[0]["EmployeeID"].ToString();
                lblName.Text = dt.Rows[0]["NAME"].ToString();
                lblDesigantion.Text = dt.Rows[0]["Desi_Name"].ToString();
                lblProbation.Text = dt.Rows[0]["ProbationPeriod"].ToString();
                //txtAuthorityname.Text = "Swapna Banerjee";
                //txtAuthorityDepartment.Text = "HR Dept";
                //txtauthoritydesig.Text = "Assistant Manager-HR";
                //txtHospitalname.Text = "Ace Healthways, Ludhiyana";
            }
            mpeCreateGroup.Show();
           
        }
        if (e.CommandName == "Print")
        {
            string query = "select * from  Pay_confirmatinletter where EmployeeID='" + e.CommandArgument.ToString() + "'";
            DataTable DTR = new DataTable();
            DTR = StockReports.GetDataTable(query);
            DataSet DS = new DataSet();
            Session["ReportName"] = "ConfirmationLetter";
            DS.Tables.Add(DTR.Copy());
            Session["ds"] = DS;
            //DS.WriteXmlSchema("C:/ConfirmationLetter.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtissuedate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
        }
    }
}