using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_IPD_DeathCertificate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }
        lblMsg.Text = "";
        if (!IsPostBack)
        {

            ViewState["ID"] = Session["ID"].ToString();

            DateTime admitDate;
            if (Request.QueryString["TransactionID"] != null)
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            if (Request.QueryString["TID"] != null)
            {
                ViewState["TID"] = Request.QueryString["TID"].ToString();
                admitDate =Util.GetDateTime( StockReports.ExecuteScalar("SELECT DATE(EnteredOn) FROM emergency_patient_details WHERE TransactionID=" + Util.GetInt(ViewState["TID"]) + " "));
                calDOB.StartDate = admitDate;
                CalendarExtender1.StartDate = admitDate;
            }


            if (Request.QueryString["PatientId"] != null)
                ViewState["PID"] = Request.QueryString["PatientId"].ToString();
            if (Request.QueryString["PID"] != null)
                ViewState["PID"] = Request.QueryString["PID"].ToString();


            ViewState["CertificateNo"] = null;
            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetPatientDischargetype(ViewState["TID"].ToString());
            //if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            //{
            //    if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
            //    {
            //        if (dtDischarge.Rows[0]["DischargeType"].ToString().Trim() != "Death")
            //        {
            //            string Msg = "Patient is Dischagre Type " + dtDischarge.Rows[0]["DischargeType"].ToString() + " . Cant fill Death Notification";
            //            Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
            //        }
            //    }
            //    else if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "IN")
            //    {
            //        string Msg = "Patient is not Discharged yet Death Certificate Cannot be Generated";
            //        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
            //    }
            //}

            txtPronounceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDeathDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtPronounceTime.Text = txtDeathTime.Text = DateTime.Now.ToString("hh:mm tt");
            AllLoadData_IPD.BindDoctorIPD(ddlCertifiedDoctor);
            ddlCertifiedDoctor.Items.Insert(0, new ListItem("---Select---", "0"));
            loadDetails();
        }
        txtDeathDate.Attributes.Add("ReadOnly", "true");
        txtPronounceDate.Attributes.Add("ReadOnly", "true");
    }
    private void loadDetails()
    {
        DataTable dt = StockReports.GetDataTable("SELECT dc.`CertificateNo`,DATE_FORMAT(dc.`PronounceDate`,'%d-%b-%Y')PronounceDate,TIME_FORMAT(dc.`PronounceTime`,'%h:%i %p')PronounceTime,DATE_FORMAT(dc.`DeathDate`,'%d-%b-%Y')DeathDate,TIME_FORMAT(dc.`DeathTime`,'%h:%i %p')DeathTime,dc.`DeathNature`,dc.`DeathCause`,dc.`CertifiedDoctorId`,dc.`BodyHandOveredTo` FROM DeathCertificate dc WHERE dc.`TransactionID`='" + ViewState["TID"].ToString() + "' AND dc.`PatientID`='" + ViewState["PID"].ToString() + "'");
        if (dt.Rows.Count > 0)
        {
            ViewState["CertificateNo"] = dt.Rows[0]["CertificateNo"].ToString();
            txtDeathNature.Text = dt.Rows[0]["DeathNature"].ToString();
            txtDeathCause.Text = dt.Rows[0]["DeathCause"].ToString();
            txtPronounceDate.Text = dt.Rows[0]["PronounceDate"].ToString();
            txtPronounceTime.Text = dt.Rows[0]["PronounceTime"].ToString();
            txtDeathDate.Text = dt.Rows[0]["DeathDate"].ToString();
            txtDeathTime.Text = dt.Rows[0]["DeathTime"].ToString();
            txtBodyHandOvered.Text = dt.Rows[0]["BodyHandOveredTo"].ToString();
            ddlCertifiedDoctor.SelectedIndex = ddlCertifiedDoctor.Items.IndexOf(ddlCertifiedDoctor.Items.FindByValue(dt.Rows[0]["CertifiedDoctorId"].ToString()));
            btnSave.Text = "Update";
            //btnPrintPatient.Visible = btnPrint.Visible = true;
        }
        else
        {
            btnSave.Text = "Save";
            //btnPrintPatient.Visible = btnPrint.Visible = false;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(pm.`Title`,' ',pm.`PName`)NAME,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City,' ',IF(pm.Pincode='','',pm.Pincode))Address, ");
            sb.Append(" CONCAT(pm.`Relation`,' ',pm.`RelationName`)Relation,pm.`Gender`,pm.`Age`,PMH.DoctorID DoctorId,DM.Name Doctor ");
            sb.Append(" FROM patient_master pm  INNER JOIN patient_medical_history pmh ON pm.`PatientID`=pmh.`PatientID` inner join doctor_master dm on dm.DoctorID=pmh.DoctorID ");
           // sb.Append(" left JOIN ipd_case_history ich ON pmh.`TransactionID`=ich.`TransactionID` ");
            sb.Append(" WHERE pmh.`TransactionID`='" + ViewState["TID"].ToString() + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (ViewState["CertificateNo"] == null && btnSave.Text == "Save")
            {
                string Id = AllInsert.InsertDeathCertificate(ViewState["PID"].ToString(), ViewState["TID"].ToString(), Util.GetString(dt.Rows[0]["NAME"]), Util.GetString(dt.Rows[0]["Relation"]), Util.GetString(dt.Rows[0]["Gender"]), Util.GetString(dt.Rows[0]["Age"]), Util.GetString(dt.Rows[0]["Address"]), Util.GetDateTime(txtPronounceDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtPronounceTime.Text).ToString("HH:mm:ss"), Util.GetDateTime(txtDeathDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtDeathTime.Text).ToString("HH:mm:ss"), Util.GetString(txtDeathNature.Text), Util.GetString(txtDeathCause.Text), Util.GetString(dt.Rows[0]["DoctorId"]), Util.GetString(dt.Rows[0]["Doctor"]), Util.GetString(ddlCertifiedDoctor.SelectedItem.Value), Util.GetString(ddlCertifiedDoctor.SelectedItem.Text), Util.GetString(txtBodyHandOvered.Text));
                if (Id != "0")
                {
                    StockReports.ExecuteDML("UPDATE DeathCertificate SET CertificateNo=CONCAT('DC/',LPAD(id,6,'0')) WHERE id='" + Id + "'");
                    lblMsg.Text = "Record Save Successfully";

                }
                else
                {
                    lblMsg.Text = "Record Not Saved";
                }


            }
            if (ViewState["CertificateNo"] != null && btnSave.Text == "Update")
            {
                AllUpdate AU = new AllUpdate();
                bool Updated = AU.UpdateDeathCertificate(Util.GetString(dt.Rows[0]["NAME"]), Util.GetString(dt.Rows[0]["Relation"]), Util.GetString(dt.Rows[0]["Gender"]), Util.GetString(dt.Rows[0]["Age"]), Util.GetString(dt.Rows[0]["Address"]), Util.GetDateTime(txtPronounceDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtPronounceTime.Text).ToString("HH:mm:ss"), Util.GetDateTime(txtDeathDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtDeathTime.Text).ToString("HH:mm:ss"), Util.GetString(txtDeathNature.Text), Util.GetString(txtDeathCause.Text), Util.GetString(dt.Rows[0]["DoctorId"]), Util.GetString(dt.Rows[0]["Doctor"]), Util.GetString(ddlCertifiedDoctor.SelectedItem.Value), Util.GetString(ddlCertifiedDoctor.SelectedItem.Text), Util.GetString(txtBodyHandOvered.Text), ViewState["CertificateNo"].ToString());
                if (Updated == true)
                {
                    lblMsg.Text = "Record Updated Successfully";
                }
                else
                {
                    lblMsg.Text = "Record Not Updated";
                }
            }
            loadDetails();

        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error...";
        }
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 'Hospital Copy' Copy, dc.`CertificateNo`,dc.`PatientID` AS Patient_ID,REPLACE(dc.`TransactionID`,'ISHHI','')IDPNo,dc.`Name`,dc.`RelationName`,dc.`Gender`,dc.`Age`,dc.`Address`, ");
        sb.Append(" DATE_FORMAT(dc.`EntryDate`,'%d-%b-%Y')EntryDate, DATE_FORMAT(dc.`PronounceDate`,'%d-%b-%Y')PronounceDate,TIME_FORMAT(dc.`PronounceTime`,'%h:%i %p')PronounceTime, ");
        sb.Append(" DATE_FORMAT(dc.`DeathDate`,'%d-%b-%Y')DeathDate,TIME_FORMAT(dc.`DeathTime`,'%h:%i %p')DeathTime,dc.`DeathNature`,dc.`DeathCause`,dc.`DoctorName`,dc.`CertifiedDoctorName`,dc.`BodyHandOveredTo`  ");
        sb.Append(" FROM DeathCertificate dc WHERE dc.`CertificateNo`='" + ViewState["CertificateNo"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
          //  ds.WriteXmlSchema("E:\\DeathCertificate.xml");
            Session["ReportName"] = "DeathCertificate";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }
    protected void btnPrintPatient_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 'Patient Copy' Copy, dc.`CertificateNo`,dc.`PatientID`,REPLACE(dc.`TransactionID`,'ISHHI','')IDPNo,dc.`Name`,dc.`RelationName`,dc.`Gender`,dc.`Age`,dc.`Address`, ");
        sb.Append(" DATE_FORMAT(dc.`EntryDate`,'%d-%b-%Y')EntryDate, DATE_FORMAT(dc.`PronounceDate`,'%d-%b-%Y')PronounceDate,TIME_FORMAT(dc.`PronounceTime`,'%h:%i %p')PronounceTime, ");
        sb.Append(" DATE_FORMAT(dc.`DeathDate`,'%d-%b-%Y')DeathDate,TIME_FORMAT(dc.`DeathTime`,'%h:%i %p')DeathTime,dc.`DeathNature`,dc.`DeathCause`,dc.`DoctorName`,dc.`CertifiedDoctorName`,dc.`BodyHandOveredTo`  ");
        sb.Append(" FROM DeathCertificate dc WHERE dc.`CertificateNo`='" + ViewState["CertificateNo"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            //ds.WriteXmlSchema("E:\\DeathCertificate.xml");
            Session["ReportName"] = "DeathCertificate";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "window.open('../../Design/common/CommonReport.aspx');", true);
        }
    }
}