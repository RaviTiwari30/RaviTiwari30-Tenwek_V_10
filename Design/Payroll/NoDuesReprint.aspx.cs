using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using MySql.Data.MySqlClient;

public partial class Design_NoDuesReprint : System.Web.UI.Page
{
    protected void btncancel_Click1(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        lbl_name.Visible = false;
        lbl_name1.Visible = false;
        lbl_empid.Visible = false;
        lbl_empid1.Visible = false;
        lbl_dept.Visible = false;
        lbl_dept1.Visible = false;
        lbl_doj.Visible = false;
        lbl_doj1.Visible = false;
        btnupdate.Visible = false;
        btncancel.Visible = false;
        btnupdate.Visible = false;
        btncancel.Visible = false;
        pnlHide.Visible = false;
        txtDOL.Visible = false;
        lblDOL.Visible = false;
        txtIssueDate.Visible = false;
        lblIssueDate.Visible = false;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        bindEmployee();
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string s = " update pay_nodues set IssueDate='" + Util.GetDateTime(txtIssueDate.Text).ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:ss") + "',DOL='" + Util.GetDateTime(txtDOL.Text).ToString("yyyy-MM-dd") + "' where ID='" + lblID.Text + "' ";
        int i = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, s);
        if (i > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "Record Update";
        }
        con.Close();
        bindEmployee();
        lbl_name.Visible = false;
        lbl_name1.Visible = false;
        lbl_empid.Visible = false;
        lbl_empid1.Visible = false;
        lbl_dept.Visible = false;
        lbl_dept1.Visible = false;
        lbl_doj.Visible = false;
        lbl_doj1.Visible = false;
        btnupdate.Visible = false;
        btncancel.Visible = false;
        btnupdate.Visible = false;
        btncancel.Visible = false;

        txtDOL.Visible = false;
        lblDOL.Visible = false;
        txtIssueDate.Visible = false;
        lblIssueDate.Visible = false;
    }

    protected void grdEmployee_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        if (e.CommandName == "print")
        {
            string id = Util.GetString(e.CommandArgument);
            makepreview(id);
        }
        if (e.CommandName == "editemp")
        {
            string id = Util.GetString(e.CommandArgument);

            BindemployeeUpdate(id);
        }

        if (e.CommandName == "reject")
        {
            string id = Util.GetString(e.CommandArgument);
            rejectNodues(id);
        }
        if (e.CommandName == "post")
        {
            string id = Util.GetString(e.CommandArgument);
            postNodues(id);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEid.Focus();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            if (Request.QueryString.Count > 0)
            {
                try
                {
                    string str = "SELECT ID,emp_id,doc_no,emp_name,dept_name,dt_entry,DATE_FORMAT(IssueDate,'%d-%b-%Y')IssueDate,Issuedby,CASE WHEN STATUS=3 THEN 'false' ELSE 'true' END STATUS FROM pay_nodues where status<>2 and ID=" + Request.QueryString["ID"] + "";
                    DataTable dt = StockReports.GetDataTable(str);
                    if (dt.Rows.Count > 0)
                    {
                        grdEmployee.DataSource = dt;
                        grdEmployee.DataBind();
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                        grdEmployee.DataSource = null;
                        grdEmployee.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                }
            }
        }
        txtDOL.Attributes.Add("readonly", "readonly");
        txtIssueDate.Attributes.Add("readonly", "readonly");
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }

    //private void bind_dept()
    //{
    //    try
    //    {
    //        string s = " select Dept_ID,Dept_Name from pay_deptartment_master where IsActive =1 ";
    //        DataTable dt = StockReports.GetDataTable(s);
    //        ddl_dept.DataSource = dt;
    //        ddl_dept.DataValueField = "Dept_ID";
    //        ddl_dept.DataTextField = "Dept_Name";
    //        ddl_dept.DataBind();
    //        ddl_dept.Items.Insert(0, "No Department");

    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //    }
    //}

    private void bindEmployee()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ID,emp_id,doc_no,emp_name,dept_name,dt_entry,DATE_FORMAT(IssueDate,'%d-%b-%Y')IssueDate,Issuedby,CASE WHEN STATUS=3 THEN 'false' ELSE 'true' END STATUS FROM pay_nodues where status<>2 ");

            if (txtName.Text.Trim() != "")
                sb.Append(" and emp_name like '" + txtName.Text + "%'");

            if (txtEid.Text.Trim() != "")
                sb.Append(" and  emp_id='" + txtEid.Text + "' ");
            sb.Append(" and date(dt_entry)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and date(dt_entry)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

            sb.Append(" order by Date(DOL)");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdEmployee.DataSource = dt;
                grdEmployee.DataBind();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                grdEmployee.DataSource = null;
                grdEmployee.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindemployeeUpdate(string ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pn.ID,pn.emp_id,pn.doc_no,pn.emp_name,pn.dept_name,DATE_FORMAT(pn.dt_entry,'%d-%b-%Y')dt_entry, ");
        sb.Append(" DATE_FORMAT(pm.DOJ,'%d-%b-%Y')DOJ,pn.DOL,pn.IssueDate  FROM pay_nodues pn INNER JOIN pay_employee_master pm ");
        sb.Append(" ON pn.emp_id=pm.Employee_ID WHERE pn.ID='" + ID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lbl_name1.Text = dt.Rows[0]["emp_name"].ToString();
            lbl_empid1.Text = dt.Rows[0]["emp_id"].ToString();
            lbl_dept1.Text = dt.Rows[0]["dept_name"].ToString();
            lbl_doj1.Text = dt.Rows[0]["DOJ"].ToString();
            lblID.Text = dt.Rows[0]["ID"].ToString();
            txtDOL.Text = Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"]).ToString("dd-MMM-yyyy"));
            txtIssueDate.Text = Util.GetString(Util.GetDateTime(dt.Rows[0]["IssueDate"]).ToString("dd-MMM-yyyy"));
            // txtDOL.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).Year));
            // txtIssueDate.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["IssueDate"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["IssueDate"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["IssueDate"].ToString()).Year));
            lbl_name.Visible = true;
            lbl_name1.Visible = true;
            lbl_empid.Visible = true;
            lbl_empid1.Visible = true;
            lbl_dept.Visible = true;
            lbl_dept1.Visible = true;
            lbl_doj.Visible = true;
            lbl_doj1.Visible = true;
            btnupdate.Visible = true;
            btncancel.Visible = true;
            txtDOL.Visible = true;
            lblDOL.Visible = true;
            txtIssueDate.Visible = true;
            lblIssueDate.Visible = true;
            calDOL.StartDate = Util.GetDateTime(dt.Rows[0]["DOJ"].ToString());
            calIssueDate.StartDate = Util.GetDateTime(dt.Rows[0]["DOJ"].ToString());
            pnlHide.Visible = true;
        }
        else
        {
            pnlHide.Visible = false;
        }
    }

    private void makepreview(string ID)
    {
        ReportDocument obj1 = new ReportDocument();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.ID,pn.emp_id,pn.doc_no,pn.emp_name,pn.dept_name,DATE_FORMAT(pn.dt_entry,'%d-%b-%Y')dt_entry, ");
        sb.Append(" DATE_FORMAT(pm.DOJ,'%d-%b-%Y')DOJ,DATE_FORMAT(pn.DOL,'%d-%b-%Y')DOL FROM pay_nodues pn INNER JOIN pay_employee_master pm ON pn.emp_id=pm.Employee_ID ");
        sb.Append("  AND pn.id=" + ID + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        Session["ds"] = ds;
        Session["ReportName"] = "NoDuesForm";
        //ds.WriteXml(@"c:\noduesReprint.xml");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        //obj1.Load(Server.MapPath(@"~\Reports\Reports\NoDuesReprint.rpt"));
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

    private void postNodues(string ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string s = " update pay_nodues set  status = 3,ApprovedBy='" + ViewState["ID"].ToString() + "' where ID='" + ID + "' ";
        int i = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, s);
        if (i > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM115','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "No Dues Approve successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='FullandFinal.aspx?NoDuseID=" + ID + "';", true);
            char[] a = lblMsg.Text.ToCharArray();
        }
        con.Close();
        bindEmployee();
    }

    private void rejectNodues(string ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string s = " update pay_nodues set  status = 2 where ID='" + ID + "' ";
        int i = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, s);
        if (i > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM114','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "Application Rejected successfully";
        }
        con.Close();
        bindEmployee();
    }
}