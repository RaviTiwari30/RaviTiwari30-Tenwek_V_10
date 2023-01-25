using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_UnPost : System.Web.UI.Page
{
    protected void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnUnPostSalary.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM069','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Salary Post";
        }
    }

    protected void btnUnPostSalary_Click(object sender, EventArgs e)
    {
        string str = string.Empty;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        int a = 0;
        try
        {
            str = "UPDATE pay_empsalary_master SET IsPost=0 WHERE MONTH(SalaryMonth)=MONTH('" + txtDate.Text + "') AND YEAR(SalaryMonth)=YEAR('" + txtDate.Text + "')";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            str = "UPDATE pay_attendance_date SET SalaryPost=0 WHERE MONTH(Att_To)=MONTH('" + txtDate.Text + "') AND  YEAR(Att_To)=YEAR('" + txtDate.Text + "')";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM074','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Salary Un-Post";
          
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            // lblmsg.Text = ex.Message;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Util.GetString(Session["ID"]);
            bool IsValid = CheckRights(ViewState["UserID"].ToString(), Request.FilePath);

            if (IsValid == false)
            {
                //Response.Redirect("../NotAuthorized.aspx");
            }
            BindDate();
        }
    }

    private bool CheckRights(string UserID, string Path)
    {
        bool Status = Util.GetBoolean(StockReports.ExecuteScalar("Select if(ifnull(ID,0)>0,'True','False')Status from user_pageauthorise where UserID='" + UserID + "' and urlPath ='" + Path + "'"));
        return Status;
    }
}