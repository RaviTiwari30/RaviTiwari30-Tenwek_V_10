using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.IO;
public partial class Design_Email_EmailTo_Employee : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindEmployee();
        }
    }
    private void BindEmployee()
    {
        DataTable dt = StockReports.GetDataTable("SELECT EmployeeID, NAME,IFNULL(Email,'')Email FROM Employee_master WHERE IsActive=1 order by Name ");
        if (dt.Rows.Count > 0)
        {
            grdEMPEmail.DataSource = dt;
            grdEMPEmail.DataBind();
        }
        else
        {
            grdEMPEmail.DataSource = null;
            grdEMPEmail.DataBind();
            lblMsg.Text = "No Record Found";
        }
    }
    private void BindDoctor()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DoctorID EmployeeID,NAME,IFNULL(Email,'')Email FROM doctor_master WHERE IsActive=1 order by Name ");
        if (dt.Rows.Count > 0)
        {
            grdEMPEmail.DataSource = dt;
            grdEMPEmail.DataBind();
        }
        else
        {
            grdEMPEmail.DataSource = null;
            grdEMPEmail.DataBind();
            lblMsg.Text = "No Record Found";
        }
    }
    protected void grdEMPEmail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if ((((Label)e.Row.FindControl("lblEmailID")).Text) == "")
            {
                ((CheckBox)e.Row.FindControl("chkbox")).Checked = false;
                ((CheckBox)e.Row.FindControl("chkbox")).Enabled = false;
            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtEmailBody.Text == "")
        {
            lblMsg.Text = "Please Enter the Email Body";
            return;
        }
        int issend = 0;
        string attachementpath = string.Empty;
        try
        {
            DataTable dtEmail = StockReports.GetDataTable("SELECT EmailID,PASSWORD,smtp_host,email_port FROM Emailid_master WHERE UniversalEmail=1");
             List<string> ToEmailID = new List<string>();
            if (dtEmail.Rows.Count > 0)
            {
                if (fluemail.HasFile)
                {
                    string attachementpathv = Email_Master.EmailFileUpload(fluemail, "EmailAttachemet", DateTime.Now.ToString("yyyy-MM-dd"));
                    attachementpath = Resources.Resource.DocumentDriveName + ":\\" + Resources.Resource.DocumentFolderName + "\\EmailAttachemet" + "\\" + DateTime.Now.ToString("yyyy-MM-dd") + "\\" + attachementpathv;
                }
                foreach (GridViewRow gvr in grdEMPEmail.Rows)
                {
                    if (((CheckBox)gvr.FindControl("chkbox")).Checked == true)
                    {
                        ToEmailID.Add(((Label)gvr.FindControl("lblEmailID")).Text);
                    }
                }
                        Email_Host objEmail = new Email_Host();
                        objEmail._FromEamilID = dtEmail.Rows[0]["EmailID"].ToString();
                objEmail._FromEmailPassword = dtEmail.Rows[0]["PASSWORD"].ToString();
                objEmail._emailport = Util.GetInt(dtEmail.Rows[0]["email_port"].ToString());
                objEmail._smtp_host = dtEmail.Rows[0]["smtp_host"].ToString();
                objEmail._ToEmailID = string.Join(";",ToEmailID);
                        objEmail._EmailSubject = Util.GetString(txtEmailSubject.Text.Trim());
                        objEmail._EmailBody = txtEmailBody.Text.ToString();
                        objEmail._StoreProcedureName = "";
                        objEmail._TemplateID = 0;
                        objEmail._RoleID = Util.GetInt(Session["RoleID"].ToString());
                        objEmail._AttachementType = "";
                        objEmail._AttachementPath = attachementpath;
                        objEmail._PageCallPath = "";
                        objEmail._EmailSendDate = "0001-01-01 00:00:00";
                        objEmail._EntryBy = HttpContext.Current.Session["ID"].ToString();
                objEmail._CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objEmail._ErrorNotifyEmail = dtEmail.Rows[0]["EmailID"].ToString();
                        issend = objEmail.sendEmail();
            }
            else
            {
                lblMsg.Text = "Please Make a Universal Mail ID";
                return;
            }
            if (issend > 0)
            {
                lblMsg.Text = "Mail Send Successfully";
                txtEmailBody.Text = "";
                txtEmailSubject.Text = "";
                rdbemailType.SelectedIndex = 0;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "";
        }
    }
    protected void rdbemailType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdbemailType.SelectedValue == "E")
            BindEmployee();
        else
            BindDoctor();
    }
}