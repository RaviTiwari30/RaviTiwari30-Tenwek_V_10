using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_offerletter : System.Web.UI.Page
{
    protected void BindRecord()
    {
        string select = " select ID,Name,Designation, OfferDate as OfferDate ,JoinDate as JoinDate,JoinTime,TotalEarning,Timing,AuthorityName,AuthorityDesignation,AuthorityDepartment,DocumentNo,Location,OtherBenefits,POBoxAddress from pay_offerletter Where ID='" + Request.QueryString["id"] + "'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(select);
        ViewState["id"] = dt.Rows[0]["ID"];

        txtName.Text = dt.Rows[0]["Name"].ToString();

        txtDesignation.Text = dt.Rows[0]["Designation"].ToString();
        txtPOBoxAddress.Text = dt.Rows[0]["POBoxAddress"].ToString();

        txtEarning.Text = dt.Rows[0]["TotalEarning"].ToString();

        //string[] deptdate = dt.Rows[0]["OfferDate"].ToString().Split(':');

        // txtOfferDate.SetDate(Util.GetString(Convert.ToDateTime(dt.Rows[0]["OfferDate"]).Day), Util.GetString(Convert.ToDateTime(dt.Rows[0]["OfferDate"]).Month), Util.GetString(Convert.ToDateTime(dt.Rows[0]["OfferDate"]).Year));
        txtOfferDate.Text = Util.GetString(Convert.ToDateTime(dt.Rows[0]["OfferDate"]).ToString("dd-MMM-yyyy"));
        //string[] deptdate1 = dt.Rows[0]["JoinDate"].ToString().Split(':');
        //txtJoinDate.SetDate(deptdate1[0].ToString(), deptdate1[1].ToString().ToUpper(), deptdate1[2].ToString());
        //txtJoinDate.SetDate(Util.GetString(Convert.ToDateTime(dt.Rows[0]["JoinDate"]).Day), Util.GetString(Convert.ToDateTime(dt.Rows[0]["JoinDate"]).Month), Util.GetString(Convert.ToDateTime(dt.Rows[0]["JoinDate"]).Year));
        txtJoinDate.Text = Util.GetString(Convert.ToDateTime(dt.Rows[0]["JoinDate"]).ToString("dd-MMM-yyyy"));
        txtJoinTime.Text = Util.GetDateTime(dt.Rows[0]["JoinTime"]).ToString("hh:mm tt");
        txtTiming.Text = dt.Rows[0]["Timing"].ToString();
        txtAuthorityDesignation.Text = dt.Rows[0]["AuthorityDesignation"].ToString();
        txtAuthorityName.Text = dt.Rows[0]["AuthorityName"].ToString();
        txtAuthorityDepartment.Text = dt.Rows[0]["AuthorityDepartment"].ToString();
        txtLocation.Text = dt.Rows[0]["Location"].ToString();
        txtOthBenefits.Text = dt.Rows[0]["OtherBenefits"].ToString();
    }

    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("ViewOfferLetter.aspx");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            if (((Button)sender).Text == "Add New")
            //if(((Button)e).Text=="Add New")
            {
                ClearControls();
                return;
            }
            if (txtJoinDate.Text == "" || txtJoinTime.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM104','" + lblmsg.ClientID + "');", true);
                return;
            }
            if (txtOfferDate.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM106','" + lblmsg.ClientID + "');", true);
                return;
            }

            if (Util.GetDateTime(txtOfferDate.Text) > Util.GetDateTime(txtJoinDate.Text + " " + txtJoinTime.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM107','" + lblmsg.ClientID + "');", true);
                return;
            }

            string insert = "insert into pay_offerletter(Name ,Designation ,OfferDate ,TotalEarning, JoinDate,JoinTime,Timing, UserID,AuthorityName,AuthorityDesignation,AuthorityDepartment,Location,OtherBenefits,POBoxAddress)";
            insert += " Values('" + txtName.Text + "','" + txtDesignation.Text + "','" + Util.GetDateTime(txtOfferDate.Text).ToString("yyyy-MM-dd") + "'," + Util.GetFloat(txtEarning.Text) + ",'" + Util.GetDateTime(txtJoinDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtJoinTime.Text).ToString("hh:mm:ss") + "','" + txtTiming.Text + "','" + Session["ID"].ToString().Trim() + "','" + txtAuthorityName.Text.Trim() + "','" + txtAuthorityDesignation.Text.Trim() + "','" + txtAuthorityDepartment.Text.Trim() + "','" + txtLocation.Text + "','" + Util.GetDecimal(txtOthBenefits.Text.Trim()) + "','" + Util.GetString(txtPOBoxAddress.Text.Trim()) + "' )";
            StockReports.ExecuteDML(insert);
            btnSave.Text = "Add New";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            string id = StockReports.ExecuteScalar("SELECT MAX(ID) FROM pay_offerletter").ToString();
            string sql = "select ID,Name,Designation, date_format(OfferDate,'%d %b %Y') as OfferDate ,date_format(JoinDate,'%d %b %Y') as JoinDate,LOWER(TIME_FORMAT(JoinTime,'%h:%i %p')) JoinTime,TotalEarning,if(Timing='','',concat('( ',Timing,' )'))Timing,AuthorityName,AuthorityDesignation,AuthorityDepartment,DocumentNo,Location,POBoxAddress from pay_offerletter where ID=" + id + "";
            DataTable dt = StockReports.GetDataTable(sql);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //  ds.WriteXmlSchema("C:/Offerletter.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OfferLetter";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../Payroll/Report/Commonreport.aspx');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='offerletter.aspx');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (txtJoinDate.Text == "" || txtJoinTime.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM105','" + lblmsg.ClientID + "');", true);
            return;
        }
        if (txtOfferDate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM106','" + lblmsg.ClientID + "');", true);
            return;
        }

        if (Util.GetDateTime(txtOfferDate.Text) > Util.GetDateTime(txtJoinDate.Text + " " + txtJoinTime.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM107','" + lblmsg.ClientID + "');", true);
            return;
        }

        string update = "update pay_offerletter set Name='" + txtName.Text + "', Designation = '" + txtDesignation.Text + "' , OfferDate ='" + Util.GetDateTime(txtOfferDate.Text).ToString("yyyy-MM-dd") + "',AuthorityName='" + txtAuthorityName.Text.Trim() + "',AuthorityDesignation='" + txtAuthorityDesignation.Text.Trim() + "', ";
        update += " TotalEarning = '" + Util.GetFloat(txtEarning.Text) + "' ,Timing='" + txtTiming.Text.Trim() + "', JoinDate = '" + Util.GetDateTime(txtJoinDate.Text).ToString("yyyy-MM-dd") + "', JoinTime = '" + Util.GetDateTime(txtJoinTime.Text).ToString("hh:mm:ss") + "',AuthorityDepartment='" + txtAuthorityDepartment.Text.Trim() + "',Location='" + txtLocation.Text + "',OtherBenefits='" + Util.GetDecimal(txtOthBenefits.Text.Trim()) + "',POBoxAddress='" + Util.GetString(txtPOBoxAddress.Text.Trim()) + "'  where ID='" + Request.QueryString["id"] + "'";
        StockReports.ExecuteDML(update);
        int id = 1;
        Response.Redirect("ViewOfferLetter.aspx?update=" + id + "");
    }
    protected void ClearControls() {
        txtDesignation.Text = "";
        txtName.Text = "";
        txtJoinTime.Text = "";
        txtJoinDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        txtOfferDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        txtEarning.Text = "";
        txtTiming.Text = "";
        btnSave.Text = "Save";
        txtAuthorityName.Text = "";
        txtAuthorityDesignation.Text = "";
        txtAuthorityDepartment.Text = "";
        txtLocation.Text = "";
        txtOthBenefits.Text = "";
        txtPOBoxAddress.Text = "";
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            btncancel.Visible = false;
            btnUpdate.Visible = false;
            btnSave.Visible = true;
            txtJoinDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtOfferDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            if (Request.QueryString["id"] != null)
            {
                btncancel.Visible = true;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                BindRecord();
                txtLocation.Text = Resources.Resource.ClientName;
            }
            txtName.Focus();
        }
        txtJoinDate.Attributes.Add("readOnly", "true");
        txtOfferDate.Attributes.Add("readOnly", "true");
    }
}