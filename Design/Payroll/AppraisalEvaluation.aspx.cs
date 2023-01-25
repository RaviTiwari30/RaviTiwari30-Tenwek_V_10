using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_AppraisalEvaluation : System.Web.UI.Page
{
    protected void btnGraph_Click(object sender, EventArgs e)
    {

        try
        {
            string grpgquery = " SELECT EmployeeID,COUNT(DISTINCT EmployeeID) Scores,(SELECT Grade FROM pay_Appraisal_Greading WHERE ROUND((SUM(Answer)*100)/(COUNT(Answer)*" + ViewState["MaxRate"].ToString() + ")) >=MinValue AND ROUND((SUM(Answer)*100)/(COUNT(Answer)*4)) <=MaxValue)Grade FROM pay_appraisal_answer WHERE AppraisalID=" + ddlAppraisal.SelectedValue + " AND AppraisalType<>'SELF' GROUP BY EmployeeID  ";
            DataTable dt = StockReports.GetDataTable(grpgquery);

            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;
                Session["ReportName"] = "AppraisalGraph";
                // ds.WriteXmlSchema("C:/AppraisalGraph.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM076','" + lblmsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        int MaxRate = Util.GetInt(StockReports.ExecuteScalar(" SELECT MAX(Rating_Points)MaxRate FROM pay_appraisal_ratingmaster "));
        ViewState["MaxRate"] = MaxRate;

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(" SELECT a.*,NAME,Desi_Name,Dept_Name,DATE_FORMAT(DOJ,'%d %b %Y')DOJ FROM ( SELECT EmployeeID,ROUND((SUM(Answer)*100)/(COUNT(Answer)*" + MaxRate + ")) Scores ,(SELECT Grade FROM pay_Appraisal_Greading WHERE ROUND((SUM(Answer)*100)/(COUNT(Answer)*" + ViewState["MaxRate"].ToString() + ")) >=MinValue AND ROUND((SUM(Answer)*100)/(COUNT(Answer)*" + ViewState["MaxRate"].ToString() + ")) <=MaxValue)Grade FROM pay_appraisal_answer WHERE AppraisalID=" + ddlAppraisal.SelectedValue + " AND AppraisalType<>'SELF' GROUP BY EmployeeID ");
        sb.Append("   )a INNER JOIN pay_employee_master emp ON emp.EmployeeID=a.EmployeeID where EmployeeID<>'' ");
        if (txtEmp_ID.Text != "")
        {
            sb.Append(" and EmployeeID='" + txtEmp_ID.Text + "' ");
        }
        if (txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like'" + txtEmpName.Text.Trim() + "%'");
        }
        if (ddlDepartment.SelectedIndex != 0)
        {
            sb.Append(" and Dept_ID='" + ddlDepartment.SelectedItem.Value + "'");
        }
        if (ddlDesignation.SelectedIndex != 0)
        {
            sb.Append(" and Desi_ID='" + ddlDesignation.SelectedItem.Value + "'");
        }
        if (ddlGrade.SelectedIndex > 0)
        {
            sb.Append(" AND Grade='" + ddlGrade.SelectedItem.Text + "' ");
        }
        sb.Append(" order by EmployeeID");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

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
        }
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string Query = " SELECT a.*,emp.Name,Emp.Dept_Name,emp.Desi_Name,DATE_FORMAT(emp.DOJ,'%d %b %Y')DOJ FROM ( " +
        "   SELECT EmployeeID,AppraisalType,COUNT(Answer)*" + ViewState["MaxRate"].ToString() + " MaxRating,sum(Answer) Scores,ROUND((SUM(Answer)*100)/(COUNT(Answer)*" + ViewState["MaxRate"].ToString() + ")) ScorePercentage,DATE_FORMAT(EntDate,'%d %b %Y') EntDate FROM pay_appraisal_answer WHERE EmployeeID='" + e.CommandArgument.ToString() + "'  AND AppraisalID=" + ddlAppraisal.SelectedValue + " AND AppraisalType<>'SELF' GROUP BY AppraisalEntryEmployeeID " +
        "    )a INNER JOIN pay_employee_master emp ON a.EmployeeID=emp.EmployeeID ORDER BY AppraisalType";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("Grade");
            decimal TotalScore = Util.GetDecimal(dt.Compute("sum(ScorePercentage)", ""));
            decimal Score = TotalScore / dt.Rows.Count;
            dc.DefaultValue = StockReports.ExecuteScalar(" SELECT Grade FROM pay_Appraisal_Greading WHERE  " + Score + ">=MinValue AND " + Score + "<=MaxValue ");
            dt.Columns.Add(dc);
            DataColumn dc1 = new DataColumn("StartDate");
            dc1.DefaultValue = StockReports.ExecuteScalar(" SELECT DATE_FORMAT(AppraisalStartDate,'%d-%b-%Y')DATE FROM pay_appraisal WHERE  ID=" + ddlAppraisal.SelectedValue + " ");
            dt.Columns.Add(dc1);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            Session["ReportName"] = "AppraisalEvaluation";
            // ds.WriteXmlSchema("E:/AppraisalEvaluation.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadDate_Payroll.BindDepartmentPayroll(ddlDepartment);
            AllLoadDate_Payroll.BindDesignationPayroll(ddlDesignation);
            AllLoadDate_Payroll.BindGradePayroll(ddlGrade);
            ddlGrade.Items.Insert(0, new ListItem("Select", "0"));
            AllLoadDate_Payroll.BindAppraisal(ddlAppraisal);
        }
    }

   }