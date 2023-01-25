using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Relievingletter : System.Web.UI.Page
{
    public void BINDINFO()
    {
        string StrQry = "select Name,EmployeeId,Date_format(DOL,'%d %b %y')Dateofleaving,issuedate,resignationdate,authoritydepartment,authoritydesignation,authorityname,documentno from Pay_Relieving where employeeId='" + Request.QueryString["id"] + "'";
        DataTable dt = StockReports.GetDataTable(StrQry);
        ViewState["EID"] = dt.Rows[0]["EmployeeID"].ToString();
        lblEmployeeID.Text = ViewState["EID"].ToString();
        LblName.Text = dt.Rows[0]["Name"].ToString();
        LblDol.Text = dt.Rows[0]["Dateofleaving"].ToString();
        txtAuthorityDepartment.Text = dt.Rows[0]["AuthorityDepartment"].ToString();
        txtAuthorityDesignation.Text = dt.Rows[0]["AuthorityDesignation"].ToString();
        txtAuthorityName.Text = dt.Rows[0]["AuthorityName"].ToString();
        pnlHide.Visible = true;
    }

    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("RelievingLetterSearch.aspx");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            AllLoadDate_Payroll.disableSubmitButton(btnSave);
            if (((Button)sender).Text == "Add New")
            {
                lblEmployeeID.Text = "";
                btnSave.Text = "Save";
                txtresignationdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtAuthorityName.Text = "";
                txtAuthorityDesignation.Text = "";
                txtAuthorityDepartment.Text = "";
                LblName.Text = "";
                LblDol.Text = "";
                lblEmployeeID.Text = "";
                txtissue.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                return;
            }
            if (txtissue.Text.Trim() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM110','" + lblmsg.ClientID + "');", true);
                return;
            }

            if (ViewState["relievinginfo"].ToString() == "Null")
            {
                string insert = "INSERT INTO pay_Relieving (UserId,Name,EmployeeID,ResignationDate,DOL,AuthorityName,AuthorityDesignation,AuthorityDepartment,Issuedate)";
                insert += " VALUES ('" + ViewState["ID"].ToString() + "','" + LblName.Text + "','" + lblEmployeeID.Text + "','" + Util.GetDateTime(txtresignationdate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(LblDol.Text).ToString("yyyy-MM-dd") + "','" + txtAuthorityName.Text + "','" + txtAuthorityDesignation.Text + "','" + txtAuthorityDepartment.Text + "','" + Util.GetDateTime(txtissue.Text).ToString("yyyy-MM-dd") + "') ";
                StockReports.ExecuteDML(insert);
                btnSave.Text = "Add New";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                string eid = StockReports.ExecuteScalar("SELECT MAX(ID) FROM pay_Relieving").ToString();
                string sql = "SELECT rel.UserId,DocumentNo,rel.Name,emp.Desi_Name,EmployeeID,ResignationDate,DATE_FORMAT(rel.DOL,'%d %b %Y') DateofLeaving,AuthorityName,AuthorityDesignation,AuthorityDepartment,DATE_FORMAT(Issuedate,'%d %b %Y') Issuedate FROM pay_Relieving REL INNER JOIN pay_employee_master emp ON rel.EmployeeID=emp.Employee_ID WHERE rel.ID=" + eid + "";
                DataTable dt = StockReports.GetDataTable(sql);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                //ds.WriteXmlSchema("C:/Relieving.xml");
                Session["ds"] = ds;
                Session["Reportname"] = "RelievingLetter";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../Payroll/Report/Commonreport.aspx');", true);
                pnlHide.Visible = false;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM100','" + lblmsg.ClientID + "');", true);
                return;
            }
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            StringBuilder sb = new StringBuilder();

            sb.Append(" select EMPLOYEEID, Name,DocumentNo,Userid,Date_Format(DOL,'%d-%b-%Y')DateOFLeaving from pay_fnf  ");
            if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() != "")
            {
                sb.Append(" where EmployeeID='" + txtEmployeeID.Text.Trim() + "'  Name like '" + txtEmployeeName.Text.Trim() + "%' ");
            }
            else if (txtEmployeeID.Text.Trim() == "" && txtEmployeeName.Text.Trim() != "")
            {
                sb.Append(" where  Name like '" + txtEmployeeName.Text.Trim() + "%' ");
            }
            else if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() == "")
            {
                sb.Append(" where EmployeeID='" + txtEmployeeID.Text.Trim() + "'");
            }

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
            }
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            return;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (txtresignationdate.Text == "" || txtresignationdate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM101','" + lblmsg.ClientID + "');", true);
            return;
        }

        string update = "update pay_relieving set  Issuedate = '" + Util.GetDateTime(txtissue.Text).ToString("yyyy-MM-dd") + "' , resignationdate ='" + Util.GetDateTime(txtresignationdate.Text).ToString("yyyy-MM-dd") + "',AuthorityName='" + txtAuthorityName.Text.Trim() + "',AuthorityDesignation='" + txtAuthorityDesignation.Text.Trim() + "', ";
        update += " Authoritydepartment = '" + txtAuthorityDepartment.Text.Trim() + "' WHERE  employeeID='" + Request.QueryString["id"] + "'";
        StockReports.ExecuteDML(update);
        Response.Redirect("RelievingLetterSearch.aspx");
    }

    protected void EmpGrid_RowCommand1(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            string test = "select * From pay_relieving where EmployeeID='" + e.CommandArgument.ToString() + "'";
            DataTable dtt = StockReports.GetDataTable(test);

            if (dtt.Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM100','" + lblmsg.ClientID + "');", true);
                lblEmployeeID.Text = "";
                txtresignationdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtAuthorityName.Text = "";
                txtAuthorityDesignation.Text = "";
                txtAuthorityDepartment.Text = "";
                LblName.Text = "";
                LblDol.Text = "";
                lblEmployeeID.Text = "";
                txtissue.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                pnlHide.Visible = false;
                return;
            }
            else
            {
                ViewState["relievinginfo"] = "Null";
                string Query = "Select Name, EmployeeID,Date_Format(DOL,'%d-%b-%Y')DateOfLeaving  from Pay_FNF where EmployeeID='" + e.CommandArgument.ToString() + "'";
                DataTable dt = StockReports.GetDataTable(Query);
                if (dt.Rows.Count > 0)
                {
                    LblName.Text = dt.Rows[0]["Name"].ToString();
                    lblEmployeeID.Text = dt.Rows[0]["EmployeeID"].ToString();
                    LblDol.Text = dt.Rows[0]["DateOfLeaving"].ToString();
                    pnlHide.Visible = true;
                }
                else
                {
                    pnlHide.Visible = false;
                }
            }
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmployeeID.Focus();
            txtissue.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtresignationdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            btncancel.Visible = false;
            btnUpdate.Visible = false;
            btnSave.Visible = true;

            if (Request.QueryString["id"] != null)
            {
                txtissue.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtresignationdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                btncancel.Visible = true;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                tbl1.Visible = false;
                BINDINFO();
            }
        }
        txtissue.Attributes.Add("readonly", "readonly");
        txtresignationdate.Attributes.Add("readonly", "readonly");
    }
}