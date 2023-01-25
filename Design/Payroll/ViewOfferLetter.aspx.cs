using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Transport_ViewOfferLetter : System.Web.UI.Page
{
    protected void btnReport_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string sql = "SELECT  NAME,Designation,OfferDate,TotalEarning,JoinDate,JoinTime,Timing,OtherBenefits FROM pay_offerletter ";
        if (chkDate.Checked)
        {
            if (txtOfferDateFrom.Text != "")
            {
                sql += " where date(offerdate)>='" + Util.GetDateTime(txtOfferDateFrom.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (txtOfferDateTo.Text != "")
            {
                if (txtOfferDateFrom.Text != "")
                {
                    sql += " and date(offerdate)<='" + Util.GetDateTime(txtOfferDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
                else
                {
                    sql += " where date(offerdate)<='" + Util.GetDateTime(txtOfferDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
            }
        }

        if (chkJoinDate.Checked)
        {
            if (txtJoinDateFrom.Text != "")
            {
                sql += " where date(JoinDate)>='" + Util.GetDateTime(txtJoinDateFrom.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (txtJoinDateTo.Text != "")
            {
                if (txtJoinDateFrom.Text != "")
                {
                    sql += " and date(JoinDate)<='" + Util.GetDateTime(txtJoinDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
                else
                {
                    sql += " where date(JoinDate)<='" + Util.GetDateTime(txtJoinDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
            }
        }
        // sql += " order by JoinDate";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("C:/OfferletterReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OfferletterReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

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
            BindRecord();
        }
    }

    protected void chkJoinDate_CheckedChanged(object sender, EventArgs e)
    {
        if (chkJoinDate.Checked)
        {
            chkDate.Checked = false;
            BindRecord();
        }
    }

    protected void grirecord_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
       Session["PrintType"] = "ExpToPDF";
        if (e.CommandName == "AEdit")
        {
            string id = Util.GetString(e.CommandArgument);
            Response.Redirect("offerletter.aspx?id=" + id + "");
        }
        if (e.CommandName == "RCancel")
        {
            string id = Util.GetString(e.CommandArgument);
        }
        if (e.CommandName == "RPrint")
        {
            string id = Util.GetString(e.CommandArgument);
            string sql = "select ID,Name,Designation, date_format(OfferDate,'%d-%b-%Y') as OfferDate ,date_format(JoinDate,'%d-%b-%Y') as JoinDate,LOWER(TIME_FORMAT(JoinTime,'%h:%i %p')) JoinTime,TotalEarning,if(Timing='','',concat('( ',Timing,' )'))Timing,AuthorityName,AuthorityDesignation,AuthorityDepartment,DocumentNo,OtherBenefits from pay_offerletter where ID=" + id + "";
            DataTable dt = StockReports.GetDataTable(sql);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("D:/Offerletter.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OfferLetter";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["Update"] == "1")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
            }
            txtJoinDateFrom.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtJoinDateTo.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtOfferDateFrom.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtOfferDateTo.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtName.Focus();
        }
        txtJoinDateFrom.Attributes.Add("readonly", "true");
        txtJoinDateTo.Attributes.Add("readonly", "true");
        txtOfferDateFrom.Attributes.Add("readonly", "true");
        txtOfferDateTo.Attributes.Add("readonly", "true");
    }

    private void BindRecord()
    {
        try
        {
            string sql = "select ID,Name,Designation,DocumentNo, date_format(OfferDate,'%d-%b-%Y') as OfferDate ,DATE_FORMAT(JoinDate,'%d-%b-%Y') as JoinDate,TIME_FORMAT(JoinTime,'%h:%i %p') JoinTime,TotalEarning,AuthorityName,AuthorityDesignation,OtherBenefits from pay_offerletter where name <>'' ";
            if (txtName.Text.Trim() != "")
            {
                sql += " and Name like '" + txtName.Text.Trim() + "%'";
            }
            if (txtDesignation.Text.Trim() != "")
            {
                sql += " and Designation like '" + txtDesignation.Text.Trim() + "%'";
            }
            if (chkDate.Checked)
            {
                if (txtOfferDateFrom.Text != "")
                {
                    sql += " and date(offerdate)>='" + Util.GetDateTime(txtOfferDateFrom.Text).ToString("yyyy-MM-dd") + "'";
                }
                if (txtOfferDateTo.Text != "")
                {
                    sql += " and date(offerdate)<='" + Util.GetDateTime(txtOfferDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
            }

            if (chkJoinDate.Checked)
            {
                if (txtJoinDateFrom.Text != "")
                {
                    sql += " and date(JoinDate)>='" + Util.GetDateTime(txtJoinDateFrom.Text).ToString("yyyy-MM-dd") + "'";
                }
                if (txtJoinDateTo.Text != "")
                {
                    sql += " and date(JoinDate)<='" + Util.GetDateTime(txtJoinDateTo.Text).ToString("yyyy-MM-dd") + "'";
                }
            }
            sql += " order by date(offerdate),DocumentNo";
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
}
