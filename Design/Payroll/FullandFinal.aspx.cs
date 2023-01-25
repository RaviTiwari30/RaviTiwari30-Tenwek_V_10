using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_FullandFinal : System.Web.UI.Page
{
    protected void BindRecord()
    {
        string Query = "SELECT EmployeeID,NAME,DOL,DocumentNo,FnFAmount,FnFAmountInWord,UserID,Date,IssueDate FROM pay_FNF where ID=" + Request.QueryString["id"] + "";

        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            lblEmployeeID.Text = dt.Rows[0]["EmployeeID"].ToString();
            lblName.Text = dt.Rows[0]["NAME"].ToString();
            txtDOL.Text = Util.GetDateTime(dt.Rows[0]["DOL"]).ToString("dd-MMM-yyyy");
            txtIssueDate.Text = Util.GetDateTime(dt.Rows[0]["IssueDate"]).ToString("dd-MMM-yyyy");
            // txtDOL.SetDate(Util.GetString(Convert.ToDateTime(dt.Rows[0]["DOL"]).Day), Util.GetString(Convert.ToDateTime(dt.Rows[0]["DOL"]).Month), Util.GetString(Convert.ToDateTime(dt.Rows[0]["DOL"]).Year));
            //  txtIssueDate.SetDate(Util.GetString(Convert.ToDateTime(dt.Rows[0]["IssueDate"]).Day), Util.GetString(Convert.ToDateTime(dt.Rows[0]["IssueDate"]).Month), Util.GetString(Convert.ToDateTime(dt.Rows[0]["IssueDate"]).Year));

            txtAmount.Text = dt.Rows[0]["FnFAmount"].ToString();
            tbl1.Visible = false;
            pnlHide.Visible = true;
        }
    }

    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("ViewFullandFinal.aspx");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (((Button)sender).Text == "Add New")
        //if(((Button)e).Text=="Add New")
        {
            lblEmployeeID.Text = "";
            lblmsg.Text = "";
            lblName.Text = "";
            txtDOL.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtAmount.Text = string.Empty;
            lblID.Text = string.Empty;
            btnSave.Text = "Save";
            pnlHide.Visible = false;
            return;
        }
        if (txtDOL.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM081','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Select Date Of Leaving";
            return;
        }
        if (lblEmployeeID.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM073','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Select Employee";
            return;
        }
        if (txtAmount.Text == "")
        {
            txtAmount.Text = "0";
        }
        //int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM pay_fnf WHERE EmployeeID="+lblEmployeeID.Text.Trim()+""));
        //if (count > 0)
        //{
        //    lblmsg.Text = "Full & Final Settlement Clear";
        //    return;
        //}
        string Query = string.Empty;
        Query = " SELECT * FROM pay_FNF WHERE employeeid='" + lblEmployeeID.Text.Trim() + "'";
        DataTable dt1 = StockReports.GetDataTable(Query);
        if (dt1.Rows.Count > 0)
        {
            lblmsg.Text = "Financial Set Off Of This Employee is Generated Can Only Be Updated";
            return;
        }
        Query = "update employee_master set DOL='" + Util.GetDateTime(txtDOL.Text).ToString("yyyy-MM-dd") + "',IsActive=0 where EmployeeID='" + lblEmployeeID.Text.Trim() + "'";
        StockReports.ExecuteDML(Query);
        Query = "INSERT INTO pay_fnf (EmployeeID,NAME,DOL,FnFAmount,UserID,NoDuseID,Date,IssueDate)VALUES	('" + lblEmployeeID.Text.Trim() + "','" + lblName.Text.Trim() + "','" + Util.GetDateTime(txtDOL.Text).ToString("yyyy-MM-dd") + "','" + txtAmount.Text.Trim() + "','" + ViewState["ID"].ToString() + "','" + lblID.Text.Trim() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtIssueDate.Text).ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("hh:mm:dd") + "');";
        StockReports.ExecuteDML(Query);
        btnSave.Text = "Add New";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
        // lblmsg.Text = "Record save";
        pnlHide.Visible = false;
        int ID = Util.GetInt(StockReports.ExecuteScalar("SELECT MAX(ID) FROM pay_fnf"));
        Query = "SELECT EmployeeID,NAME,DOL,DocumentNo,FnFAmount,FnFAmountInWord,UserID,DATE_FORMAT(EntDate,'%d %b %Y')Date FROM pay_FNF where ID=" + ID + "";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"C:\FNF.xml");
            Session["ReportName"] = "FnF";
            Session["ds"] = ds;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string Query = "SELECT ID,EmployeeId Emp_ID,emp_name,Dept_Name,DATE_FORMAT(Dt_entry,'%d-%b-%Y')NoDuseDate FROM pay_nodues WHERE STATUS=3 ";
        if (txtEmployeeID.Text.Trim() != "")
        {
            Query += " and EmployeeId='" + txtEmployeeID.Text.Trim() + "'";
        }

        if (txtEmployeeName.Text.Trim() != "")
        {
            Query += " and emp_name like '" + txtEmployeeName.Text.Trim() + "%'";
        }
        Query += " order by Dt_entry,EmployeeId";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
            pnlHide.Visible = false;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "No Record Found";
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            pnlHide.Visible = false;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            string Query = "update pay_fnf set DOL='" + Util.GetDateTime(txtDOL.Text).ToString("yyyy-MM-dd") + "',FnFAmount='" + txtAmount.Text.Trim() + "',UserID='" + ViewState["ID"].ToString() + "',IssueDate='" + Util.GetDateTime(txtIssueDate.Text).ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:dd") + "' where ID='" + Request.QueryString["ID"] + "'";
            StockReports.ExecuteDML(Query);
            Query = "update employee_master set DOL='" + Util.GetDateTime(txtDOL.Text).ToString("yyyy-MM-dd") + "' where EmployeeID='" + lblEmployeeID.Text.Trim() + "'";
            Response.Redirect("ViewFullandFinal.aspx");
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = ex.Message;
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblmsg.Text = "";
        lblEmployeeID.Text = e.CommandArgument.ToString().Split('#')[0];
        lblName.Text = e.CommandArgument.ToString().Split('#')[1];
        lblID.Text = e.CommandArgument.ToString().Split('#')[2];

        string DOL = StockReports.ExecuteScalar("select DOL from pay_nodues where ID='" + e.CommandArgument.ToString().Split('#')[2] + "'");
        if (DOL != "")
        {
            txtDOL.Text = Util.GetDateTime(DOL).ToString("dd-MMM-yyyy");
            // txtDOL.SetDate(Util.GetString(Util.GetDateTime(DOL).Day), Util.GetString(Util.GetDateTime(DOL).Month), Util.GetString(Util.GetDateTime(DOL).Year));
        }
        txtIssueDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        pnlHide.Visible = true;
        btnSave.Text = "Save";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmployeeID.Focus();
            txtDOL.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtIssueDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            btncancel.Visible = false;
            btnUpdate.Visible = false;
            if (Request.QueryString["id"] != null)
            {
                btncancel.Visible = true;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                BindRecord();
            }
            if (Request.QueryString["NoDuseID"] != null)
            {
                try
                {
                    string str = "SELECT ID,EmployeeId Emp_ID,emp_name,Dept_Name,DATE_FORMAT(Dt_entry,'%d-%b-%Y')NoDuseDate FROM pay_nodues WHERE STATUS=3  and ID=" + Request.QueryString["NoDuseID"] + "";
                    DataTable dt = StockReports.GetDataTable(str);
                    if (dt.Rows.Count > 0)
                    {
                        EmpGrid.DataSource = dt;
                        EmpGrid.DataBind();
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);

                        //  lblmsg.Text = "Record Not Found";
                        EmpGrid.DataSource = null;
                        EmpGrid.DataBind();
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
            btnSave.OnClientClick = "return DisableButton('" + btnSave.ClientID + "');";
        }
        txtDOL.Attributes.Add("readonly", "readonly");
        txtIssueDate.Attributes.Add("readonly", "readonly");
    }
}