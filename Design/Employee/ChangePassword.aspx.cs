using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Security.Cryptography;

public partial class Design_Employee_ChangePassword : System.Web.UI.Page
{
    string pwd="";
    protected void Page_Load(object sender, EventArgs e)
    {        
        if (!IsPostBack)
        {            
            txtOldPassword.Focus();
            Login();
        }
        lblMsg.Text = "";
    }
    
    private void checkRights()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string CountStr = "";
        if (Session["LoginType"].ToString() == "Employee")
        {
            CountStr = " SELECT count(*) from employee_usertype EU, usertype_right UR, right_master RM where  EU.UserType_ID = UR.User_Type_ID and UR.Right_Master_ID = RM.Right_Master_ID and  EU.Employee_ID='" + Session["ID"].ToString() + "' and RM.FormName = 'ChangePassword'";
        }
        else if (Session["LoginType"].ToString() == "Doctor")
        {
            CountStr = "SELECT count(*) from doctor_usertype DU, usertype_right UR, right_master RM where UR.Right_Master_ID = RM.Right_Master_ID and   UR.User_Type_ID = DU.UserType_ID  and  DU.DoctorID='" + Session["ID"].ToString() + "' and RM.FormName = 'ChangePassword'";
        }

        string Count = MySqlHelper.ExecuteScalar(con, CommandType.Text, CountStr).ToString();

        int CountNo = Int32.Parse(Count);
        con.Close();
        con.Dispose();
        if (CountNo == 0)
        {
            //Enablefalse();
            Response.Redirect("../../NotAuthorized.aspx");
        }
    }
    private void ChangePassword()
    {
        MySqlConnection con = new MySqlConnection();
        try
        {

            //string password = EncryptPassword(txtNewPassword.Text);
            con = Util.GetMySqlCon();
            con.Open();
            string str;
            str = "update f_login set password=MD5('" + txtNewPassword.Text.Trim() + "'),UserName='" + txtUserName.Text.Trim() + "' where  EmployeeID='" + Session["ID"].ToString() + "'";
            int A = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

            if (A > 0)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Password Changed Successfully";
            }
            else
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Password Not Changed..";
            }
            

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
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


    private void Validation()
    {

        btnSave.Attributes.Add("OnClick", "ChangePassword('" + txtOldPassword.ClientID + "','" + txtNewPassword.ClientID + "','" + txtConfirmPassword.ClientID + "','" + btnSave.ClientID + "','Old Password',' New Password','Confirm Password');return false;");
       
    }
    private void Login()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("Select rl.RoleName,rl.ID RoleID,fl.EmployeeID,fl.UserName,fl.Password ");
        sb.Append("from f_login fl inner join f_rolemaster rl on fl.RoleID = rl.ID ");
        sb.Append("Where rl.Active=1 and fl.EmployeeID = '" + Session["ID"].ToString() + "' and fl.RoleID = '" + Session["RoleID"].ToString() + "' and fl.UserName ='" + Session["UserName"].ToString() + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            if (Util.GetString(dt.Rows[0]["UserName"]) == "ITDOSE")
                Session["Ownership"] = "Public";
            else
                Session["Ownership"] = "Private";

            lblUserType.Text = Util.GetString(dt.Rows[0]["RoleName"]);
            txtUserName.Text = Util.GetString(dt.Rows[0]["UserName"]); 
            ViewState.Add("UserName", dt.Rows[0]["UserName"]);
            ViewState.Add("pwd", dt.Rows[0]["Password"]);
            txtOldPassCheck.Text=dt.Rows[0]["Password"].ToString();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //return;
        
        if (ViewState["pwd"] != null)
        {
            pwd = ViewState["pwd"].ToString();
        }        

        if (txtOldPassword.Text == "")
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter Password";
            txtOldPassword.Focus();
            return;
        }
        if (txtNewPassword.Text == "")
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter  New Password";
            txtNewPassword.Focus();
            return;
        }
        if (txtConfirmPassword.Text == "")
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter Confirm Password";
            txtConfirmPassword.Focus();
            return;
        }
        if (EncryptPassword(txtOldPassword.Text) != pwd)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Your Old Password Does Not Match. Please Specify Correct Old Password.";
            txtOldPassword.Focus();
            return;
        }
        if (txtNewPassword.Text.Length < 6)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Password can't be less than 12 characters";
            txtNewPassword.Focus();
            return;
        }
        if (txtConfirmPassword.Text.Length < 6)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Password can't be less than 12 characters";
            txtConfirmPassword.Focus();
            return;
        }

        if (txtNewPassword.Text.Trim() != txtConfirmPassword.Text.Trim())
        {
            lblMsg.Visible = true;
            lblMsg.Text = "New Password does not match with the confirmed Password.";
            txtNewPassword.Focus();
            return;
        }
        else
        {
            Validation();
            ChangePassword();
            if (Session["LoginType"].ToString() != "EDP")
            {
                txtUserName.Enabled = false;
                txtConfirmPassword.Enabled = false;
                txtNewPassword.Enabled = false;
                txtOldPassword.Enabled = false;
                btnSave.Enabled = false;
            }
            else
            {
                txtUserName.Text = "";
                txtConfirmPassword.Text = "";
                txtNewPassword.Text = "";
                txtOldPassword.Text = "";                    
            }
        }

        
    }
   
        
}
