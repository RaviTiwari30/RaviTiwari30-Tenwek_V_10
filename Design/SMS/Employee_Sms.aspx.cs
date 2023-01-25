using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_SMS_Employee_Sms : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            All_LoadData.bindEmployee(ddlEmployee, "All");
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            foreach (GridViewRow gvr in grdEMPSms.Rows)
            {
                if (((CheckBox)gvr.FindControl("chkbox")).Checked == true)
                {
                    string mobile = ((Label)gvr.FindControl("lblMobile")).Text;
                    if (mobile.Length < 10)
                    {
                        lblMsg.Text = "Invalid Contact No.";
                        return;
                    }
                    Sms_Host objSms = new Sms_Host(con);
                    objSms._Msg = txtSMSText.Text.ToString();
                    objSms._SmsTo = mobile;
                    objSms._PatientID = "";
                    objSms._DoctorID = "";
                    objSms._EmployeeID = ((Label)gvr.FindControl("lblEmployeeID")).Text;
                    objSms._TemplateID = 0;
                    objSms._UserID = ViewState["ID"].ToString();
                    objSms._smsType = 3;
                    int smsCon = objSms.sendSms();
                }
            }
            lblMsg.Text = "SMS Send Successfully";
            txtSMSText.Text = "";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        
    }

    protected void grdEMPSms_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if ((((Label)e.Row.FindControl("lblMobile")).Text) == "")
            {
                ((CheckBox)e.Row.FindControl("chkbox")).Checked = false;
                ((CheckBox)e.Row.FindControl("chkbox")).Enabled = false;
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.EmployeeID,em.Name,em.Mobile FROM employee_master em where em.IsActive=1  ");
        if (ddlEmployee.SelectedIndex > 0)
            sb.Append(" AND em.EmployeeID='" + ddlEmployee.SelectedValue + "' ");       
        sb.Append("  order by em.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdEMPSms.DataSource = dt;
            grdEMPSms.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdEMPSms.DataSource = null;
            grdEMPSms.DataBind();
            pnlHide.Visible = false;
        }
    }
}