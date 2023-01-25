using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using MySql.Data.MySqlClient;

public partial class Design_NoDuesSearch : System.Web.UI.Page
{
    protected void btn_save_Click(object sender, EventArgs e)
    {
        try
        {
            if (lbl_name.Text != "" && lbl_empid.Text != "" && lbl_dept.Text != "")
            {
                int isNodues = checkNodues(lbl_empid.Text);

                if (isNodues > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM108','" + lblMsg.ClientID + "');", true);
                    return;
                }
                if (txtDOL.Text == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM109','" + lblMsg.ClientID + "');", true);
                    return;
                }
                if (txtIssueDate.Text == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM110','" + lblMsg.ClientID + "');", true);
                    return;
                }
                else
                {
                    MySqlConnection con = new MySqlConnection();
                    con = Util.GetMySqlCon();
                    con.Open();
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO pay_nodues(emp_id,emp_name,dept_name,STATUS,Issuedby,IssueDate,DOL ) ");

                    sb.Append(" VALUES('" + lbl_empid.Text + "','" + lbl_name.Text + "','" + lbl_dept.Text + "',1,'" + Session["ID"].ToString() + "', ");
                    sb.Append("'" + Util.GetDateTime(txtIssueDate.Text).ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("hh:mm:ss") + "','" + Util.GetDateTime(txtDOL.Text).ToString("yyyy-MM-dd") + "')");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                    string maxID = StockReports.ExecuteScalar("select max(ID) from pay_nodues");
                    con.Close();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                    makepreview(maxID);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='NoDuesReprint.aspx?ID=" + maxID + "';", true);
                    lbl_name.Text = "";
                    lbl_empid.Text = "";
                    lbl_dept.Text = "";
                    lbl_doj.Text = "";
                }
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM111','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT NAME,EmployeeID Employee_ID,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,Dept_Name FROM employee_master WHERE  isactive=1 and name<>'' ");

            if (txtName.Text != "")
                sb.Append(" and Name like '" + txtName.Text + "%'");

            if (txtEid.Text != "")
                sb.Append(" and  EmployeeID='" + txtEid.Text + "' ");

            if (ddl_dept.SelectedIndex != 0)
                sb.Append(" and Dept_Name = '" + ddl_dept.SelectedItem.Text + "'");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdEmployee.DataSource = dt;
                grdEmployee.DataBind();
                lbl_name.Text = "";
                lbl_empid.Text = "";
                lbl_dept.Text = "";
                lbl_doj.Text = "";
                pnlhide.Visible = false;
            }
            else
            {
                grdEmployee.DataSource = null;
                grdEmployee.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                pnlhide.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdEmployee_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "select")
        {
            lblMsg.Text = "";
            string empid = Util.GetString(e.CommandArgument);
            bind_emp(empid);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEid.Focus();
            txtIssueDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDOL.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoadDate_Payroll.BindDepartmentPayroll(ddl_dept);
        }
        txtDOL.Attributes.Add("readonly", "readonly");
        txtIssueDate.Attributes.Add("readonly", "readonly");
    }

    private void bind_emp(string empid)
    {
        string s = " SELECT NAME,EmployeeID Employee_ID,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,Dept_Name FROM pay_employee_master WHERE EmployeeID='" + empid + "' ";
        DataTable dt = StockReports.GetDataTable(s);
        if (dt.Rows.Count > 0)
        {
            pnlhide.Visible = true;
            lbl_name.Text = dt.Rows[0]["NAME"].ToString();
            lbl_empid.Text = dt.Rows[0]["Employee_ID"].ToString();
            lbl_dept.Text = dt.Rows[0]["Dept_Name"].ToString();
            lbl_doj.Text = dt.Rows[0]["DOJ"].ToString();
            calDOL.StartDate = Util.GetDateTime(dt.Rows[0]["DOJ"].ToString());
            calIssueDate.StartDate = Util.GetDateTime(dt.Rows[0]["DOJ"].ToString());
            int isNodues = checkNodues(lbl_empid.Text);

            if (isNodues > 0)
            {
                lblMsg.Text = "Clearance Form Already Exists";
                pnlhide.Visible = false;
                return;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            pnlhide.Visible = false;
        }
    }

    private int checkNodues(string empid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string s = "SELECT COUNT(id) FROM pay_nodues WHERE emp_id='" + empid + "' and  STATUS<>2";
        int a = Convert.ToInt32(MySqlHelper.ExecuteScalar(con, CommandType.Text, s));
        con.Close();
        return a;
    }

    private void makepreview(string id)
    {
        ReportDocument obj1 = new ReportDocument();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.ID,pn.emp_id,pn.doc_no,pn.emp_name,pn.dept_name,DATE_FORMAT(pn.dt_entry,'%d-%b-%Y')dt_entry, ");
        sb.Append(" DATE_FORMAT(pm.DOJ,'%d-%b-%Y')DOJ,DATE_FORMAT(pn.DOL,'%d-%b-%Y')DOL FROM pay_nodues pn INNER JoIN employee_master pm ON pn.emp_id=pm.EmployeeID ");
        sb.Append(" AND STATUS=1 AND pn.id=" + id + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        Session["ds"] = ds;
        Session["ReportName"] = "NoDuesForm";
        // ds.WriteXml(@"c:\nodues.xml");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        //obj1.Load(Server.MapPath(@"~\Reports\Reports\NoDuesForm.rpt"));
        //obj1.SetDataSource(ds);
        //System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
        //obj1.Close();
        //obj1.Dispose();
        //Response.ClearContent();
        //Response.ClearHeaders();
        //Response.Buffer = true;
        //Response.ContentType = "application/pdf";
        //Response.BinaryWrite(m.ToArray());
        //m.Flush();
        //m.Close();
        //m.Dispose();
    }
}