using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_ViewAppointmentLetter : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        BindRecord();
    }

    protected void chkDate_CheckedChanged(object sender, EventArgs e)
    {
        if (chkDate.Checked)
        {
            chkJoinDate.Checked = false;
        }
    }
    protected void chkJoinDate_CheckedChanged(object sender, EventArgs e)
    {
        if (chkJoinDate.Checked)
        {
            chkDate.Checked = false;
        }
    }

    protected void grirecord_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
        Session["PrintType"] = "ExpToPDF";
         if (e.CommandName == "AEdit")
        {
            string id = Util.GetString(e.CommandArgument);
            Response.Redirect("Appointmentletter.aspx?id=" + id + "");
        }
        if (e.CommandName == "RCancel")
        {
            string id = Util.GetString(e.CommandArgument);
        }
        if (e.CommandName == "RPrint")
        {
            StringBuilder sb = new StringBuilder();
            string id = Util.GetString(e.CommandArgument);
            sb.Append(" select app.ID,app.NAME,app.EmployeeID,app.Designation,app.AppointmentLetterType,app.JobTiming, DATE_FORMAT(app.DOJ,'%d-%b-%Y') AS DOJ , " );
            sb.Append(" app.JoiningLocation,app.DocumentNo,Date_Format(app.AppointmentDate,'%d-%b-%Y')AppointmentDate,app.Basic,app.HRA,app.ConvenenceAllowence, " );
            sb.Append(" app.TotalRemuneration,app.Amountinwords,app.AuthorityName,app.AuthorityDesignation ");
            sb.Append(" ,app.AuthorityDepartment,app.UserID,app.AppointmentLetterType,pem.PHouse_No,app.Grade,ifnull(app.JobExpectations,'')JobExpectations,pem.Mobile,pem.Email, ");
            sb.Append(" ifnull(app.InstructionfromDept,'')InstructionfromDept,app.workingHrs,app.ProbationPeriod,app.TerminateApp,pem.LIC_NO from pay_appointmentletter app ");
            sb.Append(" left join pay_employee_master pem on app.EmployeeID=pem.employee_ID where app.ID=" + id + " ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                DataTable img = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(img.Copy());
                //ds.WriteXmlSchema("E:/Appointmentletter.xml");
                Session["ds"] = ds;
                if (ds.Tables[0].Rows[0]["AppointmentLetterType"].ToString() == "Staff")
                {
                    Session["ReportName"] = "AppointmentLetter";
                }
                else if (ds.Tables[0].Rows[0]["AppointmentLetterType"].ToString() == "Doctor")
                {
                    Session["ReportName"] = "AppointmentLetter2";
                }
                //else if (ds.Tables[0].Rows[0]["AppointmentLetterType"].ToString() == "New Nursing")
                //{
                //    Session["ReportName"] = "AppointmentLetter4";
                //}
                //else if (ds.Tables[0].Rows[0]["AppointmentLetterType"].ToString() == "Others")
                //{
                //    Session["ReportName"] = "AppointmentLetter3";
                //}
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
            }
        }
        if (e.CommandName == "RPrintAcc")
        {
            StringBuilder sb = new StringBuilder();
            string id = Util.GetString(e.CommandArgument);
            sb.Append(" select ID,NAME,EmployeeID,Designation, DATE_FORMAT(DOJ,'%d-%b-%Y') AS DOJ ,Date_Format(AppointmentDate,'%d-%b-%Y')AppointmentDate ");
            sb.Append(" ,UserID from pay_appointmentletter   where ID=" + id + " ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                //  ds.WriteXmlSchema("E:/AppointmentAcceptanceLetter.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "AppointmentAcceptanceLetter";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtName.Focus();
            txtJoinDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtJoinDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtAppointmentDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtAppointmentDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtJoinDateFrom.Attributes.Add("readonly", "readonly");
        txtJoinDateTo.Attributes.Add("readonly", "readonly");
        txtAppointmentDateFrom.Attributes.Add("readonly", "readonly");
        txtAppointmentDateTo.Attributes.Add("readonly", "readonly");
    }

    private void BindRecord()
    {
        try
        {
            string sql = "select ID,Name,Designation,DocumentNo,AppointmentLetterType, date_format(AppointmentDate,'%d-%b-%Y') as AppointmentDate ,DATE_FORMAT(DOJ,'%d-%b-%Y') as JoinDate,TotalRemuneration,AuthorityName,AuthorityDesignation from pay_appointmentletter where name <>'' ";
            if (txtName.Text.Trim() != "")
            {
                sql += " and Name like '%" + txtName.Text.Trim() + "%'";
            }
            if (txtDesignation.Text.Trim() != "")
            {
                sql += " and Designation like '" + txtDesignation.Text.Trim() + "%'";
            }
            if (chkDate.Checked)
            {
                if (txtAppointmentDateFrom.Text != "")
                {
                    sql += " and date(AppointmentDate)>='" + Util.GetDateTime(txtAppointmentDateFrom.Text).ToString("yyyy-MM-dd") + "'";
                }
                if (txtAppointmentDateTo.Text != "")
                {
                    sql += " and date(AppointmentDate)<='" + Util.GetDateTime(txtAppointmentDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
            }

            if (chkJoinDate.Checked)
            {
                if (txtJoinDateFrom.Text != "")
                {
                    sql += " and date(DOJ)>='" + Util.GetDateTime(txtJoinDateFrom.Text).ToString("yyyy-MM-dd") + "'";
                }
                if (txtJoinDateTo.Text != "")
                {
                    sql += " and date(DOJ)<='" + Util.GetDateTime(txtJoinDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
            }
            sql += " order by date(DOJ),DocumentNo";
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
                //lblmsg.Text = "No Record Found";
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
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    //protected void btnReport_Click(object sender, EventArgs e)
    //{
    //    lblmsg.Text = "";
    //    string sql = "SELECT  NAME,Designation,OfferDate,TotalEarning,JoinDate,JoinTime,Timing FROM pay_offerletter ";
    //    if (chkDate.Checked)
    //    {
    //        if (txtOfferDateFrom.GetDateForDataBase() != "")
    //        {
    //            sql += " where date(offerdate)>='" + txtOfferDateFrom.GetDateForDataBase() + "'";

    //        }
    //        if (txtOfferDateTo.GetDateForDataBase() != "")
    //        {
    //            if (txtOfferDateFrom.GetDateForDataBase() != "")
    //            {
    //                sql += " and date(offerdate)<='" + txtOfferDateTo.GetDateForDataBase() + "'";
    //            }
    //            else
    //            {
    //                sql += " where date(offerdate)<='" + txtOfferDateTo.GetDateForDataBase() + "'";
    //            }
    //        }
    //    }
}