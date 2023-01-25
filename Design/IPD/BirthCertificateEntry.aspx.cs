using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;
using System.Text;

public partial class Design_IPD_BirthCertificateEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["PID"] = Request.QueryString["PatientId"].ToString();
            ViewState["ID"] = Session["ID"].ToString();

            //txtIssueDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txtDeliveryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDeliveryTime.Text = DateTime.Now.ToString("hh:mm tt");

            AllLoadData_IPD.fromDatetoDate(Util.GetString(ViewState["TID"]), txtIssueDate, txtDeliveryDate, calIssueDate, calDeliveryDate);

            BindDeliveryType();
            CheckPatientGender();
           // BindCertificateDetail();
            bindBirthCertificates();
            bindConsultantDoctor();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string query = " SELECT CONCAT(YEAR(CURDATE()),'/BR',LPAD(IFNULL(MAX(ID),0)+1,6,0)) FROM birth_certificate_entry ";
            
            string number=Util.GetString(MySqlHelper.ExecuteScalar(tranx,CommandType.Text,query));

            query = " INSERT INTO birth_certificate_entry(Number,PatientID,TransactionID,DeliveryDate,DeliveryTime,DeliveryType,BabyName,Gender,Weight,WeightUnit,Height,HeightUnit,Guardian,Address,IssueDate,EntryDate,EntryBy,ConsultantDoctorId,IsActive) " +
                    " VALUES('" + number + "','" + Util.GetString(ViewState["PID"]) + "','" + Util.GetString(ViewState["TID"]) + "','" + Util.GetDateTime(txtDeliveryDate.Text.Trim()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtDeliveryTime.Text.Trim()).ToString("HH:mm:ss") + "', " +
                    " '" + Util.GetString(ddlDeliveryType.SelectedItem.Value) + "','" + Util.GetString(txtBabyName.Text.Trim()) + "','" + Util.GetString(rblGender.SelectedItem.Text) + "','" + Util.GetDecimal(txtWeight.Text.Trim()) + "','" + Util.GetString((ddlWeight.SelectedItem.Text != "SELECT" ? ddlWeight.SelectedItem.Text : "")) + "', " +
                    " '" + Util.GetDecimal(txtHeight.Text.Trim()) + "','" + Util.GetString((ddlHeight.SelectedItem.Text != "SELECT" ? ddlHeight.SelectedItem.Text : "")) + "','" + Util.GetString(txtGuardian.Text.Trim()) + "','" + Util.GetString(txtAddress.Text.Trim()) + "','" + Util.GetDateTime(txtIssueDate.Text.Trim()).ToString("yyyy-MM-dd") + "',NOW(),'" + Util.GetString(ViewState["ID"]) + "','"+ddlConsultantDoctor.SelectedValue.Trim()+"',1) ";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            //lblNumberValue.Text = number;
            //lblNumberHeader.Visible = true;
            //lblNumberValue.Visible = true;
            //btnSave.Visible = false;
            //btnUpdate.Visible = true;
            bindBirthCertificates();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Baby Birth Number : "+number+"');", true);
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string birthNumber = Util.GetString(lblNumberValue.Text);

            string query = " UPDATE birth_certificate_entry SET DeliveryDate='" + Util.GetDateTime(txtDeliveryDate.Text.Trim()).ToString("yyyy-MM-dd") + "',DeliveryTime='" + Util.GetDateTime(txtDeliveryTime.Text.Trim()).ToString("HH:mm:ss") + "',DeliveryType='" + Util.GetString(ddlDeliveryType.SelectedItem.Value) + "',BabyName='" + Util.GetString(txtBabyName.Text.Trim()) + "', " +
                " Gender='" + Util.GetString(rblGender.SelectedItem.Text) + "',Weight='" + Util.GetDecimal(txtWeight.Text.Trim()) + "',WeightUnit='" + Util.GetString((ddlWeight.SelectedItem.Text != "SELECT" ? ddlWeight.SelectedItem.Text : "")) + "',Guardian='" + Util.GetString(txtGuardian.Text.Trim()) + "',Address='" + Util.GetString(txtAddress.Text.Trim()) + "', " +
                " Height='" + Util.GetDecimal(txtHeight.Text.Trim()) + "',HeightUnit='" + Util.GetString((ddlHeight.SelectedItem.Text != "SELECT" ? ddlHeight.SelectedItem.Text : "")) + "',IssueDate='" + Util.GetDateTime(txtIssueDate.Text.Trim()).ToString("yyyy-MM-dd") + "',LastUpdateDate=NOW(),LastUpdateBy='" + Util.GetString(ViewState["ID"]) + "',ConsultantDoctorId='" + ddlConsultantDoctor.SelectedValue.Trim() + "' WHERE Number='" + Util.GetString(lblNumberValue.Text) + "' ";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            bindBirthCertificates();
            btnCancel.Visible = true;
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void BindDeliveryType()
    {
        string[] DeliveryType = AllGlobalFunction.DeliveryType;
        ddlDeliveryType.DataSource = DeliveryType;
        ddlDeliveryType.DataBind();
    }

    private void CheckPatientGender()
    {
        string patient = StockReports.ExecuteScalar(" SELECT CONCAT(Gender,'#',PName,'#',CONCAT(House_No,' ',IFNULL(Street_Name,''),' ',City),'#',RelationName) FROM patient_master WHERE PatientID='" + Util.GetString(ViewState["PID"]) + "' ");

        if (Util.GetString(patient.Split('#')[0]) == "Male")
        {
            txtDeliveryDate.Enabled = false;
            txtDeliveryTime.Enabled = false;
            ddlDeliveryType.Enabled = false;
            txtBabyName.Enabled = false;
            rblGender.Enabled = false;
            txtWeight.Enabled = false;
            ddlWeight.Enabled = false;
            txtHeight.Enabled = false;
            ddlHeight.Enabled = false;
            txtGuardian.Enabled = false;
            txtAddress.Enabled = false;
            txtIssueDate.Enabled = false;

            btnSave.Visible = false;
            btnUpdate.Visible = false;

            lblMsg.Text = "Birth Certificate Entry is not allowed for this Patient";
        }
        else
        {
            DataTable dt = StockReports.GetDataTable("SELECT  Weight,Height FROM patient_medical_history  WHERE   Transaction_ID='" + Util.GetString (ViewState["TID"]) + "'");
            if (dt.Rows.Count > 0)
            {
                string Weight = dt.Rows[0]["Weight"].ToString();
                string Height = dt.Rows[0]["Height"].ToString();
                txtHeight.Text = Height.Split('#')[0];
                txtWeight.Text = Weight.Split('#')[0];
                ddlWeight.SelectedValue = Weight.Split('#')[1];
            }
            txtBabyName.Text = "B/O " + Util.GetString(patient.Split('#')[1]);
            txtAddress.Text = Util.GetString(patient.Split('#')[2]);
            txtGuardian.Text = Util.GetString(patient.Split('#')[3]);
        }
    }

    private void BindCertificateDetail(string birthNumber)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT a.Number,CONCAT(pm.Title,' ',pm.PFirstName)PName,a.ConsultantDoctorId,a.Guardian AS Father,DATE_FORMAT(a.DeliveryDate,'%d-%b-%Y')DeliveryDate,TIME_FORMAT(a.DeliveryTime,'%h:%i %p')DeliveryTime,a.DeliveryType,a.BabyName,a.Gender,a.Weight,a.WeightUnit,a.Height,a.HeightUnit,a.Address,DATE_FORMAT(a.IssueDate,'%d-%b-%Y')IssueDate ");
        sb.Append(" FROM birth_certificate_entry a ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON a.Patient_Id=pmh.Patient_Id AND a.Transaction_id=pmh.Transaction_id ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.patient_id=pm.Patient_ID ");
        sb.Append(" WHERE a.Number='" + Util.GetString(birthNumber) + "' AND a.IsActive=1 LIMIT 1 ");


        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());

        if (dtDetails.Rows.Count > 0)
        {
            lblNumberValue.Text = Util.GetString(dtDetails.Rows[0]["Number"]);
            txtDeliveryDate.Text = Util.GetString(dtDetails.Rows[0]["DeliveryDate"]);
            txtDeliveryTime.Text = Util.GetString(dtDetails.Rows[0]["DeliveryTime"]);
            ddlDeliveryType.SelectedIndex = ddlDeliveryType.Items.IndexOf(ddlDeliveryType.Items.FindByText(Util.GetString(dtDetails.Rows[0]["DeliveryType"])));
            txtBabyName.Text = dtDetails.Rows[0]["BabyName"].ToString();
            rblGender.SelectedIndex = rblGender.Items.IndexOf(rblGender.Items.FindByText(Util.GetString(dtDetails.Rows[0]["Gender"])));
            txtWeight.Text = (Util.GetDecimal(dtDetails.Rows[0]["Weight"]) > 0 ? Util.GetString(dtDetails.Rows[0]["Weight"]) : "");
            ddlWeight.SelectedIndex = ddlWeight.Items.IndexOf(ddlWeight.Items.FindByText(Util.GetString(dtDetails.Rows[0]["WeightUnit"])));
            txtHeight.Text = (Util.GetDecimal(dtDetails.Rows[0]["Height"]) > 0 ? Util.GetString(dtDetails.Rows[0]["Height"]) : "");
            ddlHeight.SelectedIndex = ddlHeight.Items.IndexOf(ddlHeight.Items.FindByText(Util.GetString(dtDetails.Rows[0]["HeightUnit"])));
            txtGuardian.Text = Util.GetString(dtDetails.Rows[0]["Father"]);
            txtAddress.Text = Util.GetString(dtDetails.Rows[0]["Address"]);
            txtIssueDate.Text = Util.GetString(dtDetails.Rows[0]["IssueDate"]);

            lblNumberHeader.Visible = true;
            lblNumberValue.Visible = true;
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            btnCancel.Visible = true;
        }
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataSet ds = new DataSet();
        

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT a.Number,CONCAT(pm.Title,' ',pm.PFirstName) PName,a.ConsultantDoctorId,'' ConsultantDoctor,a.Guardian AS Father,DATE_FORMAT(a.DeliveryDate,'%d-%b-%Y')DeliveryDate,TIME_FORMAT(a.DeliveryTime,'%h:%i %p')DeliveryTime,a.DeliveryType,a.BabyName,a.Gender,a.Weight,a.WeightUnit,a.Height,a.HeightUnit,a.Address,DATE_FORMAT(a.IssueDate,'%d-%b-%Y')IssueDate ");
        sb.Append(" FROM birth_certificate_entry a ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON a.PatientId=pmh.PatientId AND a.Transactionid=pmh.Transactionid ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.patientid=pm.PatientID ");
        sb.Append(" WHERE a.Transaction_ID='" + Util.GetString(ViewState["TID"]) + "' AND a.IsActive=1 LIMIT 1 ");



        DataTable dt1 = StockReports.GetDataTable(sb.ToString());
        ds.Tables.Add(dt1.Copy());
        ds.Tables[0].TableName = "BabyDetail";

        DataColumn dc1 = new DataColumn("PrintUser");
        dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0].ToString();
        ds.Tables[0].Columns.Add(dc1);

        DataTable dtImg = new DataTable();
        dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "BirthCertificatePrint";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "window.open('../../Design/common/CommonReport.aspx');", true);

    }


    public void bindBirthCertificates()
    {

        string query = " SELECT Number,DATE_FORMAT(DeliveryDate,'%d-%b-%Y')DeliveryDate,TIME_FORMAT(DeliveryTime,'%h:%i %p')DeliveryTime,DeliveryType,BabyName,Gender,Weight,WeightUnit,Height,HeightUnit,Guardian,Address,DATE_FORMAT(IssueDate,'%d-%b-%Y')IssueDate " +
               " FROM birth_certificate_entry WHERE TransactionID='" + Util.GetString(ViewState["TID"]) + "' AND IsActive=1  ";


        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();
        btnCancel.Visible = false;

    }


    public void bindConsultantDoctor()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlConsultantDoctor.DataSource = dt;
        ddlConsultantDoctor.DataBind();

        ddlConsultantDoctor.DataTextField = "Name";
        ddlConsultantDoctor.DataValueField = "DoctorID";
        ddlConsultantDoctor.DataBind();
        ddlConsultantDoctor.Items.Insert(0, new ListItem("Select", " "));

    }



    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbEdit")
        {
            string birthNumber = Util.GetString(e.CommandArgument);
            BindCertificateDetail(birthNumber);


        }
        else
        {

            string birthNumber = Util.GetString(e.CommandArgument);

            DataSet ds = new DataSet();
           

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT a.Number,CONCAT(pm.Title,' ',pm.PFirstName) PName,a.ConsultantDoctorId,'' ConsultantDoctor,a.Guardian AS Father,DATE_FORMAT(a.DeliveryDate,'%d-%b-%Y')DeliveryDate,TIME_FORMAT(a.DeliveryTime,'%h:%i %p')DeliveryTime,a.DeliveryType,a.BabyName,a.Gender,a.Weight,a.WeightUnit,a.Height,a.HeightUnit,a.Address,DATE_FORMAT(a.IssueDate,'%d-%b-%Y')IssueDate ");
            sb.Append(" FROM birth_certificate_entry a ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON a.PatientId=pmh.PatientId AND a.Transactionid=pmh.Transactionid ");
            sb.Append(" INNER JOIN patient_master pm ON pmh.patientid=pm.PatientID ");
            sb.Append(" WHERE a.Number='" + Util.GetString(birthNumber) + "' AND a.IsActive=1 LIMIT 1 ");



            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            ds.Tables.Add(dt1.Copy());
            ds.Tables[0].TableName = "BabyDetail";

            DataColumn dc1 = new DataColumn("PrintUser");
            dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0].ToString();
            ds.Tables[0].Columns.Add(dc1);

            DataTable dtImg = new DataTable();
            dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());

            // ds.WriteXmlSchema("F:\\BirthCertificatePrint.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "BirthCertificatePrint";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "window.open('../../Design/common/CommonReport.aspx');", true);
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.RawUrl);
    }
}