using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Email_Email_id : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindEmailID();  
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsUniversal =0;
            if (chkuniversal.Checked)
            {
                IsUniversal = 1;
                StockReports.ExecuteScalar("UPDATE Emailid_master SET UniversalEmail=0,UpdatedBy='"+ Session["ID"].ToString() +"',UpdatedDate=NOW() WHERE UniversalEmail=1");
            }
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(EmailID) from Emailid_master Where EmailID='" + txtFromEmail.Text.Trim() + "'"));
            if (count == 0)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT Emailid_master (EmailID,PASSWORD,CreatedBy,UniversalEmail,smtp_host,email_port) VALUES ('" + txtFromEmail.Text.Trim() + "','" + txtPassword.Text.Trim() + "','" + Session["ID"].ToString() + "','" + IsUniversal + "','"+ txtsmtphost.Text.Trim() +"','"+ txtemailport.Text.Trim() +"')");
                Tranx.Commit();
                BindEmailID();
                lblMsg.Text = "Record Saved Successsfully";
                Clear();
            }
            else
            {
                Tranx.Rollback();
                lblMsg.Text = "Email ID Already Exist !!";
                return;
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally 
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void BindEmailID()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT id.UniversalEmail,id.ID,id.EmailID,id.PASSWORD,CONCAT(em.Title,' ',em.Name)EmName,DATE_FORMAT(IF(IFNULL(id.UpdatedBy,'')='',id.CreatedDate,id.UpdatedDate),'%d-%b-%Y %l:%i %p')UpdatedDate,smtp_host,email_port FROM Emailid_master id ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=IF(IFNULL(id.UpdatedBy,'')='',id.CreatedBy,id.UpdatedBy) ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdEmail.DataSource = dt;
            grdEmail.DataBind();
        }
        else
        {
            grdEmail.DataSource = null;
            grdEmail.DataBind();
        }
    }
    protected void grdEmail_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            txtFromEmail.Text = ((Label)grdEmail.Rows[id].FindControl("lblEmailID")).Text;
            txtPassword.Text = ((Label)grdEmail.Rows[id].FindControl("lblPassword")).Text;
            lblUpdatedID.Text = ((Label)grdEmail.Rows[id].FindControl("lblID")).Text;
            txtemailport.Text = ((Label)grdEmail.Rows[id].FindControl("lblemailport")).Text;
            txtsmtphost.Text = ((Label)grdEmail.Rows[id].FindControl("lblsmtphost")).Text;
            string isuni = ((Label)grdEmail.Rows[id].FindControl("lblUniversal")).Text;
            if (isuni == "1")
                chkuniversal.Checked = true;
            else
                chkuniversal.Checked = false;
            btnCancel.Visible = true;
            btnUpdate.Visible = true;
            btnSave.Visible = false;
        }   
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsUniversal = 0;
            if (chkuniversal.Checked)
            {
                IsUniversal = 1;
                StockReports.ExecuteScalar("UPDATE Emailid_master SET UniversalEmail=0 WHERE UniversalEmail=1");
            }
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(EmailID) from Emailid_master Where EmailID='" + txtFromEmail.Text.Trim() + "' AND ID<> '" + lblUpdatedID.Text.Trim() + "'"));
            if (count == 0)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE Emailid_master SET EmailID = '" + txtFromEmail.Text.Trim() + "',PASSWORD = '" + txtPassword.Text.Trim() + "',UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDate=NOW(),UniversalEmail='" + IsUniversal + "',smtp_host='" + txtsmtphost.Text.Trim() + "',email_port='"+ txtemailport.Text.Trim() +"' WHERE ID='" + lblUpdatedID.Text.Trim() + "' ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE email_master e SET e.FromEmailID='"+ txtFromEmail.Text.Trim() +"' , e.FromEmailPassword='"+ txtPassword.Text.Trim() +"',e.FromEmailPort='"+ txtemailport.Text.Trim() +"',e.FromEmailSmtp='"+ txtsmtphost.Text.Trim() +"' WHERE e.emailmaster_id='" + lblUpdatedID.Text.Trim() + "' ");
                Tranx.Commit();
                BindEmailID();
                lblMsg.Text = "Record Updated Successsfully";
                btnCancel.Visible = false;
                btnUpdate.Visible = false;
                btnSave.Visible = true;
                Clear();
            }
            else
            {
                Tranx.Rollback();
                lblMsg.Text = "Email ID Already Exist !!";
                return;
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void Clear()
    {
        txtFromEmail.Text = "";
        txtPassword.Text = "";
        lblUpdatedID.Text = "";
        txtsmtphost.Text = "";
        txtemailport.Text = "";
        chkuniversal.Checked = false;
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
        btnCancel.Visible = false;
        btnUpdate.Visible = false;
        btnSave.Visible = true;
    }
    protected void grdEmail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if ((((Label)e.Row.FindControl("lblUniversal")).Text) == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
        }
    }
}