using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_RelievingLetterSearch : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        BindRecord();
    }

    protected void grirecord_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            string eid = Util.GetString(e.CommandArgument);
            ViewState["EID"] = eid.ToString();
            //Response.Redirect("RelievingLetter.aspx?id=" + ViewState["EID"]+ "");
            Response.Redirect("RelievingLetter.aspx?id=" + eid + "");
        }
        else if (e.CommandName == "RPrint")
        {
            string eid = Util.GetString(e.CommandArgument);
            //string sql = "SELECT rel.UserId,DocumentNo,rel.Name,emp.Desi_Name,EmployeeID,ResignationDate,DATE_FORMAT(rel.DOL,'%d %b %Y') DateofLeaving,AuthorityName,AuthorityDesignation,AuthorityDepartment,DATE_FORMAT(Issuedate,'%d %b %Y') Issuedate FROM pay_Relieving REL INNER JOIN pay_employee_master emp ON rel.EmployeeID=emp.Employee_ID WHERE rel.ID=" + ViewState["ID"] + "";
            string sql = "SELECT rel.UserId,DocumentNo,rel.Name,emp.Desi_Name,EmployeeID,ResignationDate,DATE_FORMAT(rel.DOL,'%d %b %Y') DateofLeaving,AuthorityName,AuthorityDesignation,AuthorityDepartment,DATE_FORMAT(Issuedate,'%d %b %Y') Issuedate FROM pay_Relieving REL INNER JOIN pay_employee_master emp ON rel.EmployeeID=emp.Employee_ID WHERE emp.Employee_ID='" + eid + "'";
            DataTable dt = StockReports.GetDataTable(sql);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("C:/Relieving.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "RelievingLetter";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtIssuedatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtIssueDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtEmployeeid.Focus();
        }
    }

    private void BindRecord()
    {
        string sql = "select ID,EmployeeID,Name,DocumentNo, date_format(Issuedate,'%d %b %Y') as IssueDate ,AuthorityName,date_format(DOL,'%d %b %y')Dateofleaving from pay_relieving where employeeid <>'' ";
        if (txtName.Text.Trim() != "")
        {
            sql += " and Name like '" + txtName.Text.Trim() + "%'";
        }
        if (txtEmployeeid.Text.Trim() != "")
        {
            sql += " and EMPLOYEEID like '" + txtEmployeeid.Text.Trim() + "%'";
        }
        if (chkDate.Checked == true)
        {
            if (txtIssuedatefrom.Text != "")
            {
                sql += " and date(issuedate)>='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (txtIssueDateTo.Text != "")
            {
                sql += " and date(issuedate)<='" + Util.GetDateTime(txtIssueDateTo.Text).ToString("yyyy-MM-dd") + "'";
            }
        }
        sql += " order by date(issuedate),DocumentNo";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "No Record Found";
            grirecord.DataSource = null;
            grirecord.DataBind();
            ViewState["dt"] = null;
        }
        else
        {
            grirecord.DataSource = dt;
            grirecord.DataBind();
            //ViewState["ID"] = dt.Rows[0]["ID"].ToString();
            ViewState["dt"] = dt;
        }
    }
}