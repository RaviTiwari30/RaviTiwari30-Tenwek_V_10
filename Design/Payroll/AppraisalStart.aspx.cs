using System;
using System.Web.UI;

public partial class Design_Payroll_AppraisalStart : System.Web.UI.Page
{
    protected void Bind()
    {
        if (Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Pay_Appraisal WHERE IsPost=0 ")) > 0)
        {
            BindEndDate();
            lblDate.Text = "End Date :";
            lblStartAppraisal.Text = "End Appraisal";
            lblStartDate.Text = "End Appraisal";
            DateTime App = Util.GetDateTime(StockReports.ExecuteScalar("SELECT  MAX(AppraisalStartDate) FROM Pay_Appraisal WHERE IsPost=0 "));
            calucToDate.StartDate = App.AddDays(1);
            txtDate.Text = Util.GetDateTime(App).ToString("dd-MMM-yyyy");
        }
        else
        {
            BindStartDate();
            lblDate.Text = "Start Date :";
            lblStartAppraisal.Text = "Start Appraisal";
            lblStartDate.Text = "Start Appraisal";
            //DateTime App = Util.GetDateTime(StockReports.ExecuteScalar("SELECT  MAX(AppraisalEndDate) FROM Pay_Appraisal WHERE IsPost=1 "));
            //calucToDate.StartDate = App.AddDays(1);
            //txtDate.Text = Util.GetDateTime(App).ToString("dd-MMM-yyyy");
        }
    }

    protected void BindEndDate()
    {
        txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy"); ;
    }

    protected void BindStartDate()
    {
        DateTime StartDate = Util.GetDateTime(StockReports.ExecuteScalar(" SELECT MAX(AppraisalEndDate) FROM Pay_Appraisal WHERE IsPost=1 "));
        if (Util.GetString(StartDate) != "1/1/0001 12:00:00 AM")
        {
            StartDate = StartDate.AddYears(1);
            // txtDate.SetDate(StartDate.Day.ToString(), StartDate.Month.ToString(), StartDate.Year.ToString());
            txtDate.Text = Util.GetDateTime(StartDate).ToString("dd-MMM-yyyy");
            calucToDate.StartDate = StartDate;
        }
        else
        {
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calucToDate.StartDate = DateTime.Now;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (lblDate.Text == "Start Date :")
        {
            if (Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM Pay_Appraisal WHERE DATE(AppraisalEndDate)>'" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "' ")) > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM196','" + lblmsg.ClientID + "');", true);
                //  lblmsg.Text = "Date is less then last Appraisal Date";
                return;
            }

            StockReports.ExecuteDML(" INSERT INTO Pay_Appraisal(AppraisalStartDate,UserID) VALUES('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "') ");
        }
        else
        {
            if (Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Pay_Appraisal WHERE IsPost=0 AND DATE(AppraisalStartDate)>'" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "' ")) > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM197','" + lblmsg.ClientID + "');", true);
                // lblmsg.Text = "Date is Greater then Appraisal Start Date";
                return;
            }
            string ID = StockReports.ExecuteScalar("select ID from Pay_Appraisal where IsPost=0 ");
            StockReports.ExecuteDML(" UPDATE Pay_Appraisal SET AppraisalEndDate='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',IsPost=1 WHERE ID='" + ID + "'");
            btnSave.Enabled = false;
        }
        Bind();
        // lblmsg.Text = "Record Save";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Bind();
        }
        txtDate.Attributes.Add("readonly", "readonly");
    }
}