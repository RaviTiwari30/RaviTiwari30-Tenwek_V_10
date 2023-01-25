using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_Employee_Appraisal : System.Web.UI.Page
{
    protected void BindAnswer()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Question_ID,Answer_Type,Answer,AppraisalNO FROM pay_appraisal_answer WHERE EmployeeID='" + lblEmployeeID.Text + "' AND AppraisalEntryEmployeeID='" + lblAppraisalEntryEmployeeID.Text + "' AND AppraisalType='" + ddlAppraisalType.SelectedItem.Text + "' and  AppraisalID=" + lblAppraisalID.Text + "");
        if (dt.Rows.Count > 0)
        {
            txtComment.Text = StockReports.ExecuteScalar("select Comment from pay_appraisalcomment where AppraisalNO=" + dt.Rows[0]["AppraisalNO"].ToString() + "  and  AppraisalID=" + lblAppraisalID.Text + "");
            foreach (GridViewRow row in GvQuestion.Rows)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (((Label)row.FindControl("lblQuestion_ID")).Text == dt.Rows[i]["Question_ID"].ToString())
                    {
                        if (((Label)row.FindControl("lblAnswer_Type")).Text == "O")
                        {
                            ((RadioButtonList)row.FindControl("rbtnAnswer")).SelectedIndex = ((RadioButtonList)row.FindControl("rbtnAnswer")).Items.IndexOf(((RadioButtonList)row.FindControl("rbtnAnswer")).Items.FindByValue(dt.Rows[i]["Answer"].ToString()));
                        }
                        else if (((Label)row.FindControl("lblAnswer_Type")).Text == "S")
                        {
                            ((TextBox)row.FindControl("txtAnswer")).Text = dt.Rows[i]["Answer"].ToString();
                        }
                    }
                }
            }
        }
        else
        {
            txtComment.Text = "";
        }
    }

    protected void BindAppraisalID()
    {
        lblAppraisalID.Text = StockReports.ExecuteScalar(" select ID from pay_appraisal where isPost=0 ");
        if (lblAppraisalID.Text.Trim() == "")
        {
            btnSave.Enabled = false;
            btnSearch.Enabled = false;
        }
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        lblEmployeeID.Text = ddlEmployeeName.SelectedValue;

        BindQuestion(ddlAppraisalType.SelectedItem.Text);
        BindAnswer();
        mpAppraisalQ.Show();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query1 = "DELETE FROM pay_appraisal_answer WHERE EmployeeID='" + lblEmployeeID.Text + "' AND AppraisalEntryEmployeeID='" + lblAppraisalEntryEmployeeID.Text + "' AND AppraisalType='" + ddlAppraisalType.SelectedItem.Text + "' and AppraisalID=" + lblAppraisalID.Text.Trim() + " ";
            StockReports.ExecuteDML(Query1);
            Query1 = "DELETE FROM pay_AppraisalComment WHERE EmployeeID='" + lblEmployeeID.Text + "' AND AppraisalEntryEmployeeID='" + lblAppraisalEntryEmployeeID.Text + "' AND AppraisalType='" + ddlAppraisalType.SelectedItem.Text + "'  and AppraisalID=" + lblAppraisalID.Text.Trim() + " ";
            StockReports.ExecuteDML(Query1);

            string AppraisalNo = StockReports.ExecuteScalar(" SELECT IFNULL(MAX(AppraisalNO),0)+1 FROM  pay_appraisal_answer ");

            foreach (GridViewRow row in GvQuestion.Rows)
            {
                string Answer = string.Empty;
                if (((Label)row.FindControl("lblAnswer_Type")).Text == "O")
                {
                    Answer = ((RadioButtonList)row.FindControl("rbtnAnswer")).SelectedItem.Value;
                }
                else
                { Answer = ((TextBox)row.FindControl("txtAnswer")).Text; }

                string Query = "INSERT INTO pay_appraisal_answer(EmployeeID,Question_ID,Answer_Type,Answer,UserID,AppraisalEntryEmployeeID,AppraisalType,AppraisalNO,AppraisalID)VALUES ('" + lblEmployeeID.Text + "','" + ((Label)row.FindControl("lblQuestion_ID")).Text + "','" + ((Label)row.FindControl("lblAnswer_Type")).Text + "','" + Answer + "','" + ViewState["ID"].ToString() + "','" + lblAppraisalEntryEmployeeID.Text + "','" + ddlAppraisalType.SelectedItem.Text + "','" + AppraisalNo + "','" + lblAppraisalID.Text.Trim() + "')";
                StockReports.ExecuteDML(Query);
            }
            Query1 = "INSERT INTO pay_AppraisalComment(EmployeeID,AppraisalNO,COMMENT,AppraisalEntryEmployeeID,AppraisalType,AppraisalID)VALUES('" + lblEmployeeID.Text + "'," + AppraisalNo + ",'" + txtComment.Text.Trim() + "','" + lblAppraisalEntryEmployeeID.Text + "','" + ddlAppraisalType.SelectedItem.Text + "'," + lblAppraisalID.Text + ") ";
            StockReports.ExecuteDML(Query1);
            txtComment.Text = "";
            MySqltrans.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "Record Save";
            Print(StockReports.ExecuteScalar("select max(AppraisalNo) from pay_appraisal_answer"));
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
            MySqltrans.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        lblEmployeeID.Text = "";
        //lblName.Text = "";
        //lblDOJ.Text = dt.Rows[0]["DOJ"].ToString();

        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();

        sb.Append(" select Employee_ID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  WHERE IsActive=1 ");
        if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() != "")
        {
            sb.Append(" and Employee_ID='" + txtEmployeeID.Text.Trim() + "' and Name like '" + txtEmployeeName.Text.Trim() + "%' ");
        }
        else if (txtEmployeeID.Text.Trim() == "" && txtEmployeeName.Text.Trim() != "")
        {
            sb.Append(" and Name like '" + txtEmployeeName.Text.Trim() + "%' ");
        }
        else if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() == "")
        {
            sb.Append(" and Employee_ID='" + txtEmployeeID.Text.Trim() + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
        }
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            string Query = "Select Employee_ID,Name,Date_Format(DOJ,'%d %b %Y')DOJ,Desi_Name,Dept_Name from pay_Employee_master where Employee_ID='" + e.CommandArgument.ToString() + "'";
            DataTable dt = StockReports.GetDataTable(Query);
            if (dt.Rows.Count > 0)
            {
                lblAppraisalEntryEmployeeID.Text = dt.Rows[0]["Employee_ID"].ToString();

                //                lblName.Text = dt.Rows[0]["Name"].ToString();
                mpEmployeeSelection.Show();
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = ex.Message;
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void GvQuestion_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            if (e.Row.RowIndex != 0)
            {
                if (((Label)e.Row.FindControl("lblGroupHeader")).Text.Trim() == ((Label)GvQuestion.Rows[e.Row.RowIndex - 1].FindControl("lblGroupHeader")).Text.Trim())
                {
                    ((Label)e.Row.FindControl("lblGroupHeader")).Visible = false;
                }
            }
            if (((Label)e.Row.FindControl("lblAnswer_Type")).Text == "O")
            {
                DataTable dtRating = ViewState["Rating"] as DataTable;
                ((RadioButtonList)e.Row.FindControl("rbtnAnswer")).DataSource = dtRating;
                ((RadioButtonList)e.Row.FindControl("rbtnAnswer")).DataTextField = "Rating_Name";
                ((RadioButtonList)e.Row.FindControl("rbtnAnswer")).DataValueField = "Rating_ID";
                ((RadioButtonList)e.Row.FindControl("rbtnAnswer")).DataBind();
                ((RadioButtonList)e.Row.FindControl("rbtnAnswer")).Visible = true;
                ((TextBox)e.Row.FindControl("txtAnswer")).Visible = false;
                ((RequiredFieldValidator)e.Row.FindControl("AnswerText")).Enabled = false;
                ((RequiredFieldValidator)e.Row.FindControl("Answerrbtn")).Enabled = true;
            }
            else
            {
                ((RadioButtonList)e.Row.FindControl("rbtnAnswer")).Visible = false;
                ((TextBox)e.Row.FindControl("txtAnswer")).Visible = true;
                ((RequiredFieldValidator)e.Row.FindControl("AnswerText")).Enabled = true;
                ((RequiredFieldValidator)e.Row.FindControl("Answerrbtn")).Enabled = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmployeeID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtEmployeeName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");

            DataTable dtRating = StockReports.GetDataTable("SELECT * FROM pay_appraisal_RatingMaster");
            ViewState["Rating"] = dtRating;
            ViewState["ID"] = Session["ID"].ToString();
            AllLoadDate_Payroll.BindAppraisalType(ddlAppraisalType);
            AllLoadDate_Payroll.BindEmployeePayroll(ddlEmployeeName);
            BindAppraisalID();
        }
    }

    protected void Print(string AppraisalNo)
    {
        string str = " SELECT EmployeeID,emp.Name,Desi_Name,Dept_Name,DATE_FORMAT(DOJ,'%d %b %Y')DOJ,qm.Question_ID,Question,GroupHeader,Answer,AppraisalEntryEmployeeID,ans.AppraisalType,(SELECT NAME FROM pay_employee_master WHERE Employee_ID=AppraisalEntryEmployeeID)EntryUserName,(SELECT COMMENT FROM pay_appraisalcomment WHERE AppraisalNo=" + AppraisalNo + "  LIMIT 1)Comments FROM pay_appraisal_answer ans INNER JOIN pay_appraisal_questionmaster qm ON ans.Question_ID=qm.Question_ID " +
           " INNER JOIN pay_employee_master emp ON ans.EmployeeID=emp.Employee_ID " +
           "   WHERE AppraisalNO=" + AppraisalNo + " ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            Session["ReportName"] = "Appraisal";
            //   ds.WriteXmlSchema("C:/Appraisal.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void rb_AppType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindQuestion(ddlAppraisalType.SelectedItem.Text);
    }

    private void BindQuestion(string QuestionFor)
    {
        string query = "SELECT Question_ID,Question,Question_Type,Answer_Type,GroupHeader FROM pay_appraisal_QuestionMaster WHERE Question_type='" + QuestionFor + "' and IsActive=1 ";
        DataTable dt_SQ = StockReports.GetDataTable(query);
        GvQuestion.DataSource = dt_SQ;
        GvQuestion.DataBind();

        mpAppraisalQ.Show();
    }
}