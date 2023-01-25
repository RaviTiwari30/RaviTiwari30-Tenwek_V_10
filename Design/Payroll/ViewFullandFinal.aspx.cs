using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Transport_ViewFullandFinal : System.Web.UI.Page
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
            string id = Util.GetString(e.CommandArgument);
            Response.Redirect("FullandFinal.aspx?id=" + id + "");
        }

        if (e.CommandName == "RPrint")
        {
            string id = Util.GetString(e.CommandArgument);
            string Query = "SELECT EmployeeID,NAME,DOL,DocumentNo,FnFAmount,FnFAmountInWord,UserID,DATE_FORMAT(Date,'%d %b %Y')Date FROM pay_FNF where ID=" + id + "";
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
    }

    protected void grirecord_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmployeeID.Focus();
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }

    private void BindRecord()
    {
        string sql = "SELECT ID,NoDuseID,EmployeeID,NAME,Date_Format(DOL,'%d-%b-%Y')DOL,DocumentNo,Date_Format(IssueDate,'%d-%b-%Y')IssueDate,FnFAmount,FnFAmountInWord,EntDate,UserID FROM pay_fnf where Status=1 ";
        if (txtName.Text.Trim() != "")
        {
            sql += " and Name like '" + txtName.Text.Trim() + "%'";
        }
        if (txtEmployeeID.Text.Trim() != "")
        {
            sql += " and EmployeeID='" + txtEmployeeID.Text.Trim() + "'";
        }
        if (chkDate.Checked)
        {
            if (txtFromDate.Text != "")
            {
                sql += " and date(Date)>='" + txtFromDate.Text + "'";
            }
            if (txtToDate.Text != "")
            {
                sql += " and date(Date)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'";
            }
        }

        sql += " order by date(DOL),DocumentNo";
        //if (txtJoinDateFrom.GetDateForDataBase() != "")
        //{
        //    sql += " and date(joindate)>='" + txtJoinDateFrom.GetDateForDataBase() + "'";

        //}
        //if (txtJoinDateTo.GetDateForDataBase() != "")
        //{
        //    sql += " and date(joindate)<='" + txtJoinDateTo.GetDateForDataBase() + "'";

        //}

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "No Record Found";
            grirecord.DataSource = null;
            grirecord.DataBind();
            ViewState["dt"] = null;
        }
        else
        {
            grirecord.DataSource = dt;
            grirecord.DataBind();
            ViewState["dt"] = dt;
        }
    }
}