using System;
using System.Text;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Emergency_MedicalCertificate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            if (Request.QueryString["TID"] != null)
            ViewState["TID"] = Convert.ToString(Request.QueryString["TID"]);
            else
                ViewState["TID"] = Convert.ToString(Request.QueryString["TransactionID"]);

            ViewState["PID"] = Convert.ToString(Request.QueryString["PID"]);

            txtfrmdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindMedicalCertificates();
            BindPatientDetails();
            bindDoctor();

            if (Session["RoleID"].ToString() != "52" && Session["RoleID"].ToString() != "323")
            {
                divptdetail.Visible = false;
            }
        }
        cc3.StartDate = DateTime.Now;
        txtfrmdate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void bindDoctor()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlDoctor.DataSource = dt;
        ddlDoctor.DataTextField = "Name";
        ddlDoctor.DataValueField = "DoctorID";
        ddlDoctor.Items.Insert(0,"Select");
        ddlDoctor.DataBind();
    }

    private void BindPatientDetails()
    {
        //int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) From medicalcertificate where TransactionID='" + ViewState["TID"].ToString() + "'"));
        //if (count > 0)
        //{
        //    lblMsg.Text = "Certificate already created as per Patient's Last OPD Bill / IP No.";
        //    return;
        //}
        //else
        //{
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)Pname,pm.Age,pm.Gender FROM patient_master pm ");
            sb.Append("INNER JOIN patient_medical_history pmh ON pmh.PatientID=pm.PatientID WHERE pmh.TransactionID='" + ViewState["TID"].ToString() + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                txtage.Text = dt.Rows[0]["Age"].ToString();
                txtgender.Text = dt.Rows[0]["Gender"].ToString();
                txtptname.Text = dt.Rows[0]["Pname"].ToString();
                txtmr.Text = dt.Rows[0]["PatientID"].ToString();
               // txtdoctorname.Text = StockReports.ExecuteScalar("SELECT CONCAT(dm.Title,' ',dm.Name) FROM doctor_master dm WHERE dm.DoctorID='" + GetDoctor(Session["ID"].ToString(), ViewState["TID"].ToString()) + "'");

                ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(GetDoctor(Session["ID"].ToString(), ViewState["TID"].ToString())));
            }
        //}
    }
    protected void txtsave_Click(object sender, EventArgs e)
    {
        try
        {
            var PNmae = txtptname.Text.Trim();
            AllInsert al = new AllInsert();
           // string id = al.InsertMedicalCertificate(txtmr.Text.Trim(), txtptname.Text.Trim(), txtAddress.Text.Trim(), txtrelation.Text.Trim(), txtgender.Text.Trim(), txtage.Text.Trim(), txtdiagnosis.Text.Trim(), Util.GetDateTime(txtfrmdate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), txtRemarks.Text.Trim(), txtdoctorname.Text.Trim(), txtdrsign.Text.Trim(), txtdocdept.Text.Trim(), ViewState["TID"].ToString(), Session["ID"].ToString());
            string id = al.InsertMedicalCertificate(txtmr.Text.Trim(), txtptname.Text.Trim(), txtAddress.Text.Trim(), txtrelation.Text.Trim(), txtgender.Text.Trim(), txtage.Text.Trim(), txtdiagnosis.Text.Trim(), Util.GetDateTime(txtfrmdate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), txtRemarks.Text.Trim(), ddlDoctor.SelectedItem.Text, txtdrsign.Text.Trim(), txtdocdept.Text.Trim(), ViewState["TID"].ToString(), Session["ID"].ToString());
          
            lblMsg.Text = "Record Saved Successfully";
            clear();
            bindMedicalCertificates();
            print(Util.GetInt(id));
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
        }  
    }

    public void bindMedicalCertificates()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT mc.`ID`,mc.`PName`,mc.`RelationName`,mc.`MRNO`,mc.`Address`,mc.`Gender`,mc.`Age`,mc.`Diagnosis`,DATE_FORMAT(mc.`FDate`,'%d-%b-%Y') AS FromDate ");
        sb.Append(",DATE_FORMAT(mc.`TDate`,'%d-%b-%Y') AS ToDate,mc.`Remarks`,mc.`DoctorName`,DATE_FORMAT(mc.`EntDate`,'%d-%b-%Y %I:%i %p') AS EntryDate ");
        sb.Append(",CONCAT(em.`Title`,' ',em.`Name`) AS EntryBy ");
        sb.Append("FROM medicalcertificate mc  ");
        sb.Append("INNER JOIN employee_master em ON em.`EmployeeID`=mc.`UserID` ");
        sb.Append("WHERE mc.`IsActive`=1 AND mc.`MRNO`='" + ViewState["PID"].ToString() + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdDetails.DataSource = dt;
        grdDetails.DataBind();
    }

    //private void print()
    //{
    //    string sql = " SELECT  mc.ID,mc.PName,mc.Address,mc.MRNO,mc.RelationName,mc.DoctorName,mc.Gender,mc.Age,mc.Diagnosis,mc.DSignature,DATE_FORMAT(mc.FDate,'%d-%b-%y')FDate,DATE_FORMAT(mc.TDate,'%d-%b-%y')TDate,DATE_FORMAT(mc.EntDate,'%d-%b-%y')CurrentDate,";
    //    sql += " REPLACE(pmh.TransactionID,'ISHHI','')TransactionID,mc.DSignature,mc.docdept FROM  patient_medical_history pmh INNER JOIN ";
    //    sql += "medicalcertificate mc ON pmh.PatientID =mc.MRNO where mc.TransactionID='" + ViewState["TID"].ToString() + "' order by mc.id desc  ";
    //    DataTable dt = StockReports.GetDataTable(sql);

    //    DataSet ds = new DataSet();
    //    ds.Tables.Add(dt.Copy());
    //    Session["ds"] = ds;
    //    Session["ReportName"] = "MedicalCertificate";
    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);
    //}
    private void print(int id)
    {
        string sql = " SELECT  mc.ID,mc.PName,mc.Address,mc.MRNO,mc.RelationName,mc.DoctorName,mc.Gender,mc.Age,mc.Diagnosis,mc.DSignature,DATE_FORMAT(mc.FDate,'%d-%b-%y')FDate,DATE_FORMAT(mc.TDate,'%d-%b-%y')TDate,DATE_FORMAT(mc.EntDate,'%d-%b-%y')CurrentDate,";
       // sql += " REPLACE(pmh.TransactionID,'ISHHI','')TransactionID,mc.DSignature,mc.docdept FROM  patient_medical_history pmh INNER JOIN ";
     //   sql += "medicalcertificate mc ON pmh.PatientID =mc.MRNO where mc.ID="+ id +" order by mc.id desc  ";

         sql += " REPLACE(mc.TransactionID,'ISHHI','')TransactionID,mc.DSignature,mc.docdept FROM medicalcertificate mc where mc.ID="+ id +" order by mc.id desc  ";

        DataTable dt = StockReports.GetDataTable(sql);

        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        Session["ds"] = ds;
        Session["ReportName"] = "MedicalCertificate";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);
    }
    private void clear()
    {
        txtptname.Text = "";
        txtmr.Text = "";
        txtAddress.Text = "";
        txtage.Text = "";
        txtdiagnosis.Text = "";
        //txtfrmdate.Text = "";
        //txtToDate.Text = "";
        txtgender.Text = "";
        // txtjoining.Text = "";
        txtRemarks.Text = "";
        txtrelation.Text = "";
    }
    private string GetDoctor(string userID, string transactionID)
    {
        if (Session["RoleID"].ToString() == "52")
        {
            string str = "select DoctorID from doctor_employee where Employeeid='" + userID + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                return Util.GetString(dt.Rows[0][0]);
            }
            else
            {
                string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");
                return DocID;
            }
        }
        else
        {
            string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");
            return "";
        }
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
      //  print();
    }
    protected void grdDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            print(id);
        }
        if (e.CommandName == "Remove")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            StockReports.ExecuteDML("UPDATE medicalcertificate mc  SET mc.`IsActive`=0 ,mc.`updatedBy`='"+ Session["ID"].ToString() +"',mc.`UpdatedDateTime`=NOW() WHERE mc.id="+ id +" ");
            bindMedicalCertificates();
            lblMsg.Text = "Record Removed Successfully..";
        }
    }
}