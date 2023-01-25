using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Security.Cryptography;
using System.Text;

public partial class Default : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
       string status = Util.checkDB_Conn();
        if (status.Split('#')[0] == "0")
        {
            lblError.Visible = true;
            lblError.Text = status.Split('#')[1];
            lblClientFullName.Text = GetGlobalResourceObject("Resource", "ClientFullName").ToString().ToUpper();
            imgClientLogo.ImageUrl = GetGlobalResourceObject("Resource", "ClientLogo").ToString();
            txtUserName.Focus();
            form1.Visible = false;
        }
        else
        {
            form1.Visible = true;
            lblError.Visible = false;
            if (!Page.IsPostBack)
            {
                lblClientFullName.Text = GetGlobalResourceObject("Resource", "ClientFullName").ToString().ToUpper();
                imgClientLogo.ImageUrl = GetGlobalResourceObject("Resource", "ClientLogo").ToString();
                if (Session["ID"] != null)
                {
                    Response.Redirect("~/Welcome.aspx");
                }
                All_LoadData.bindCenterDropDownList(ddlCenterMaster, Resources.Resource.DefaultCentreID, "");
                txtUserName.Focus();
            }
            //WelcomeMessage();
        }
    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        UserLogin();
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtUserName.Text = string.Empty;
        txtPassword.Text = string.Empty;
    }
    private void UserLogin()
    {
        try
        {
            string Password = EncryptPassword(txtPassword.Text.Trim());
            DataTable dt = StockReports.GetDataTable("CALL f_login('" + ddlCenterMaster.SelectedValue + "','" + txtUserName.Text.Trim() + "','" + Password + "')");
            if (dt.Rows.Count > 0)
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE online_employee set isActive=0 where EmployeeID='" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "' and isActive=1");
                string GlobalId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MD5(CONCAT('" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "',NOW(),RAND(25000))) AS GlobalId"));
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT into online_employee(SessionId,EmployeeID) values('" + GlobalId + "','" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "') ");
                con.Close();
                con.Dispose();

                if (Util.GetString(dt.Rows[0]["UserName"]) == "ITDOSE")
                    Session["Ownership"] = "Public";
                else
                    Session["Ownership"] = "Private";

                Session["GlobalId"] = GlobalId;
                Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                Session["UserName"] = txtUserName.Text.Trim();
                Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                Session["HOSPID"] = Util.GetString(dt.Rows[0]["Hospital_ID"]);
                Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                Session["Centre"] = "10";
                Session["CentreID"] = Util.GetString(dt.Rows[0]["CentreID"]);
                Session["BookingCentreID"] = Util.GetString(dt.Rows[0]["CentreID"]);

                Session["CentreName"] = Util.GetString(dt.Rows[0]["CentreName"]);
                Session["EmployeeName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                Session["DeptLedgerNo"] = Util.GetString(dt.Rows[0]["DeptLedgerNo"].ToString());
                Session["IsStore"] = Util.GetString(dt.Rows[0]["IsStore"].ToString());
                UpdateLoginDetails(dt.Rows[0]["RoleID"].ToString(), Util.GetString(dt.Rows[0]["EmployeeID"]));
                Response.Redirect("~/Welcome.aspx");
            }
            else
            {
                lblError.Visible = true;
                lblError.Text = "You have Entered Wrong Information";
                txtUserName.Focus();
            }
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
        }
    }
    private void UpdateLoginDetails(string RoleID, string EmployeeID)
    {
        try
        {
            string str = "Update f_login Set CurLoginTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',NoOfLogins=ifNull(NoOfLogins,0)+1 where EmployeeID='" + EmployeeID + "' and RoleID='" + RoleID + "' AND CentreID='" + ddlCenterMaster.SelectedValue + "' AND Last_IPAddress='" + All_LoadData.IpAddress() + "'";
            StockReports.ExecuteDML(str);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2"));
        }
        return strBuilder.ToString();
    }

}