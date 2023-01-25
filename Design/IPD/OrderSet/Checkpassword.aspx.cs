using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_IPD_OrderSet_Checkpassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
         
        if (!IsPostBack)
        {
             MySqlConnection con = Util.GetMySqlCon();
                con.Open();
            try
            {
                string Condition = Request.QueryString["Condition"].ToString();
                ViewState["Condition"] = Condition;
                string value = Request.QueryString["value"].ToString();
                ViewState["value"] = value;
                txtPassword.Focus();
                ViewState["UserID"] = Session["ID"].ToString();
               
                StringBuilder sb1 = new StringBuilder();
                string Username = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Username from f_login where employeeid='" + ViewState["UserID"] + "'GROUP BY employeeid"));
                lblUsername.Text = Username;
                //Btnsave.Focus();

            }
            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
            finally {
                con.Close();
                con.Dispose();
            }
        }
        if (txtPassword.Text != "")
        {
            Login();
        }
    }
    protected void Btnsave_Click(object sender, EventArgs e)
    {
        Login();
    }
    private void Login()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
          

            StringBuilder sb = new StringBuilder();
            sb.Append("select fl.EmployeeID,  fl.UserName,  CONCAT(em.title,' ',em.name)    EmpName");
            sb.Append("   FROM f_login fl   INNER JOIN employee_master em     ON fl.EmployeeID = em.Employee_ID");
            sb.Append("  WHERE fl.Active = 1  AND em.IsActive = 1    AND PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER('" + lblUsername.Text + "'))    AND PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER('" + txtPassword.Text.Trim() + "')) ORDER BY fl.isDefault desc");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                string str = ViewState["Condition"].ToString();
                if (str.ToUpper() == "SAVE")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "clickBTNADD();", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "clickBTNADDUpdate();", true);
                }
                lblMsg.Text = " ";
                con.Close();
                con.Dispose();

            }
            else
            {
                lblMsg.Visible = true;
                lblMsg.Text = "You have Enter Wrong Password";
                txtPassword.Focus();
            }


        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally {
            con.Close();
            con.Dispose();
        }
    }
}