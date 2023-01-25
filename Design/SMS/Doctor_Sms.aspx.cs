using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

public partial class Design_SMS_Doctor_Sms : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            ViewState["ID"] = Session["ID"].ToString();
            All_LoadData.bindDocGroup(ddlDoctorGroup, "All");
            All_LoadData.bindDoctor(ddlDoctor,"All");
            All_LoadData.bindDocTypeList(ddlSpecialization, 3, "All");
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "All");
            
        }
    }        
    protected void btnSave_Click(object sender, EventArgs e)
    {     
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            foreach (GridViewRow gvr in grdDocsms.Rows)
            {
                if (((CheckBox)gvr.FindControl("chkbox")).Checked == true)
                {
                    string mobile = ((Label)gvr.FindControl("lblMobile")).Text;
                    if (mobile.Length < 10)
                    {
                        lblMsg.Text = "Invalid Contact No.";
                        return;
                    }
                    Sms_Host objSms = new Sms_Host();
                    objSms._Msg = txtSMSText.Text.ToString();
                    objSms._SmsTo = mobile;
                    objSms._PatientID = "";
                    objSms._DoctorID = ((Label)gvr.FindControl("lblDoctorID")).Text;
                    objSms._TemplateID = 0;
                    objSms._UserID = ViewState["ID"].ToString();
                    objSms._smsType = 2;
                    objSms._CentreID = Util.GetInt(Session["CentreID"].ToString());
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
    protected void grdDocsms_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex !=-1)
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
        sb.Append(" SELECT dm.Name,dm.Mobile,dm.DoctorID from doctor_master dm where dm.IsActive=1  ");
        if(ddlDoctor.SelectedIndex>0)
            sb.Append(" AND dm.DoctorID='"+ddlDoctor.SelectedValue+"' ");
        if(ddlDoctorGroup.SelectedIndex>0)
            sb.Append(" AND dm.DocGroupID='" +ddlDoctorGroup.SelectedValue + "' ");
        if (ddlDepartment.SelectedIndex > 0)
            sb.Append(" AND dm.DocDepartmentID='" + ddlDepartment.SelectedValue + "' ");
        if (ddlSpecialization.SelectedIndex > 0)
            sb.Append(" AND dm.Specialization='" + ddlSpecialization.SelectedItem.Text + "' ");
       
        sb.Append("  order by Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdDocsms.DataSource = dt;
            grdDocsms.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdDocsms.DataSource = null;
            grdDocsms.DataBind();
            pnlHide.Visible = false;
        }
    }
}