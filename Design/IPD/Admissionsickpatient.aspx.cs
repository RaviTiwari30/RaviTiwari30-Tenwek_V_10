using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
public partial class Design_IPD_Admissionsickpatient : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        caldate.EndDate = DateTime.Now;
       
        if (!IsPostBack)
        {
            grdSickPatientsbind();
            txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            //txtTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
        }

        txtDate.Attributes.Add("readOnly", "true");
    }

    protected void grdSickPatientsDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void grdSickPatientsDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblPID.Text = ((Label)grdSickPatientsDetails.Rows[id].FindControl("lblID")).Text;

            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + lblPID.Text + "'");
            if (rows.Length > 0)
            {
                txtService.Text = rows[0]["Service"].ToString();
                txtHistory.Text = rows[0]["History"].ToString();
                txtChiefComplaints.Text = rows[0]["ChiefComplaints"].ToString();
                txtAllergies.Text = rows[0]["Allergies"].ToString();
                txtMeds.Text = rows[0]["Meds"].ToString();
                txtPMH.Text = rows[0]["PMH"].ToString();
                txtPSH.Text = rows[0]["PSH"].ToString();
                txtSocialHX.Text = rows[0]["SocialHX"].ToString();
                txtFamilyHX.Text = rows[0]["FamilyHX"].ToString();
                txtPhysicalExam.Text = rows[0]["PhysicalExam"].ToString();
                txtVitalSigns.Text = rows[0]["VitalSigns"].ToString();
                txtGeneral.Text = rows[0]["SocialHX"].ToString();
                txtHEENT.Text = rows[0]["HEENT"].ToString();
                txtNeck.Text = rows[0]["Neck"].ToString();
                txtChestRespiratory.Text = rows[0]["ChestRespiratory"].ToString();
                txtCardiovascular.Text = rows[0]["Cardiovascular"].ToString();
                txtAbdomen.Text = rows[0]["Abdomen"].ToString();
                txtGURectalPelvic.Text = rows[0]["GURectalPelvic"].ToString();
                txtBlackJoints.Text = rows[0]["BlackJoints"].ToString();
                txtExtermities.Text = rows[0]["Extermities"].ToString();
                txtCNS.Text = rows[0]["CNS"].ToString();
                txtSkin.Text = rows[0]["Skin"].ToString();
                txtDiagnosticResult.Text = rows[0]["DiagnosticResult"].ToString();
                txtLaboratory.Text = rows[0]["SocialHX"].ToString();
                txtImaging.Text = rows[0]["Imaging"].ToString();
                txtAssessmentPlan.Text = rows[0]["AssessmentPlan"].ToString();
                txtImpression.Text = rows[0]["Impression"].ToString();
                txtRecommendations.Text = rows[0]["Recommendations"].ToString();
                txtStudentName.Text = rows[0]["StudentName"].ToString();
                txtDoctorName.Text = rows[0]["DoctorName"].ToString();
                txtSupervisingConsultant.Text = rows[0]["SupervisingConsultant"].ToString();

                txtDate.Text = rows[0]["Date1"].ToString();
                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time"].ToString()).ToString("hh:mm tt");

            }
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = true;
        }
    }
    public void grdSickPatientsbind()
    {
        DataTable dt = GetSickPatients();
        ViewState["dt"] = dt;
        grdSickPatientsDetails.DataSource = dt;
        grdSickPatientsDetails.DataBind();


    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
    }
    private DataTable GetSickPatients()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%M-%Y') AS Date1,FirstDegreeTear,SecondDegreeTear,ThirdDegreeTear,FourthDegreeTear,Episiotomy,NewBornResuscitated,PatientID,TransactionID  FROM delivery_master where TransactionID='" + Util.GetString(ViewState["TID"]) + "'");

            sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Time,'%h:%m %r') AS Time1,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1 FROM sickpatientmaster ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());


            return dt;
        }
        catch (Exception exc)
        {
            return null;
        }


    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if(DateTime.Parse(txtDate.Text.Trim())>(DateTime.Now))
        {
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('only past dates allowed');", true);
            return;
        }
        try
        {

            string query = "INSERT INTO `sickpatientmaster` (    `Service`,  `Date`,  `Time`,  `History`,  `ChiefComplaints`,  `Allergies`,  `Meds`,  `PMH`,  `PSH` , `SocialHX`," +
  "`FamilyHX`,  `PhysicalExam`,  `VitalSigns`,  `General`,  `HEENT`,  `Neck`,  `ChestRespiratory`,  `Cardiovascular`,  `Abdomen`,  `GURectalPelvic`,  `BlackJoints`,  `Extermities`,  `CNS`," +
 " `Skin`,  `DiagnosticResult`,  `Laboratory`,  `Imaging`,  `AssessmentPlan`,  `Impression`,  `Recommendations`,  `StudentName`,  `DoctorName`,  `SupervisingConsultant`,`EntryBy`)" +
" VALUES  (  '" + txtService.Text + "',    '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',    '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("H:mm:ss") + "',    '" + txtHistory.Text + "',    '" + txtChiefComplaints.Text + "',    '" + txtAllergies.Text + "',    '" + txtMeds.Text + "',    '" + txtPMH.Text + "',    '" + txtPSH.Text + "',    '" + txtSocialHX.Text + "',    '" + txtFamilyHX.Text + "',    '" + txtPhysicalExam.Text + "',    '" + txtVitalSigns.Text + "'," +
   " '"+txtGeneral.Text+"',    '"+txtHEENT.Text+"',    '"+txtNeck.Text+"',    '"+txtChestRespiratory.Text+"',    '"+txtCardiovascular.Text+"',    '"+txtAbdomen.Text+"',    '"+txtGURectalPelvic.Text+"',    '"+txtBlackJoints.Text+"',    '"+txtExtermities.Text+"',    '"+txtCNS.Text+"',    '"+txtSkin.Text+"',    '"+txtDiagnosticResult.Text+"'," +
   " '" + txtLaboratory.Text + "',    '" + txtImaging.Text + "',    '" + txtAssessmentPlan.Text + "',    '" + txtImpression.Text + "',    '" + txtRecommendations.Text + "',    '" + txtStudentName.Text + "',    '" + txtDoctorName.Text + "',    '" + txtSupervisingConsultant.Text + "',    '" + HttpContext.Current.Session["ID"].ToString() + "'  );";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            Clear();
            grdSickPatientsbind();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('saved successfully');", true);
            
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not saved');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    private void Clear()
    {

        txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        //txtTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
        ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
        txtService.Text = "";
        txtHistory.Text = "";
        txtChiefComplaints.Text = "";
        txtAllergies.Text = "";
        txtMeds.Text = "";
        txtPMH.Text = "";
        txtPSH.Text = "";
        txtSocialHX.Text = "";
        txtFamilyHX.Text = "";
        txtPhysicalExam.Text = "";
        txtVitalSigns.Text = "";
        txtGeneral.Text = "";
        txtHEENT.Text = "";
        txtNeck.Text = "";
        txtChestRespiratory.Text = "";
        txtCardiovascular.Text = "";
        txtAbdomen.Text = "";
        txtGURectalPelvic.Text = "";
        txtBlackJoints.Text = "";
        txtExtermities.Text = "";
        txtCNS.Text = "";
        txtSkin.Text = "";
        txtDiagnosticResult.Text = "";
        txtLaboratory.Text = "";
        txtImaging.Text = "";
        txtAssessmentPlan.Text = "";
        txtImpression.Text = "";
        txtRecommendations.Text = "";
        txtStudentName.Text = "";
        txtDoctorName.Text = "";
        txtSupervisingConsultant.Text = "";

               
        btnUpdate.Visible = false;
        btnSave.Visible = true;
        btnCancel.Visible = false;
        
        
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('only past dates allowed');", true);
            return;
        }
        try
        {
            string time = Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss"); 
            string query = "UPDATE  sickpatientmaster SET    `Service` = '" + txtService.Text + "',  `Date` = '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',  `Time` = '" +time+ "',  `History` = '" + txtHistory.Text + "',  `ChiefComplaints` = '" + txtChiefComplaints.Text + "'," +
                "`Allergies` = '" + txtAllergies.Text + "',  `Meds` = '" + txtMeds.Text + "',  `PMH` = '" + txtPMH.Text + "',  `PSH` = '" + txtPSH.Text +
                "',  `SocialHX` = '"+txtSocialHX.Text+"',  `FamilyHX` = '"+txtFamilyHX.Text+
                "',  `PhysicalExam` = '"+txtPhysicalExam.Text+"',  `VitalSigns` = '"+txtVitalSigns.Text+"',  `General` = '"+txtGeneral.Text+"',  `HEENT` = '"+txtHEENT.Text+"',"+

  "`Neck` = '"+txtNeck.Text+"',  `ChestRespiratory` = '"+txtChestRespiratory.Text+"',  `Cardiovascular` = '"+txtCardiovascular.Text+"',  `Abdomen` = '"+txtAbdomen.Text+"',  `GURectalPelvic` = '"+
  txtGURectalPelvic.Text+"',  `BlackJoints` = '"+txtBlackJoints.Text+"',"+
 " `Extermities` = '"+txtExtermities.Text+"',  `CNS` = '"+txtCNS.Text+"',  `Skin` = '"+txtSkin.Text+"',  `DiagnosticResult` = '"+txtDiagnosticResult.Text+"',  `Laboratory` = '"+
 txtLaboratory.Text+"',  `Imaging` = '"+txtImaging.Text+"',  `AssessmentPlan` = '"+txtAssessmentPlan.Text+"',"+
"  `Impression` = '"+txtImpression.Text+"',  `Recommendations` = '"+txtRecommendations.Text+"',  `StudentName` = '"+txtStudentName.Text+"',  `DoctorName` = '"+txtDoctorName.Text+
"',  `SupervisingConsultant` = '"+txtSupervisingConsultant.Text+"' WHERE ID=" + lblPID.Text + " ";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            Clear();
            grdSickPatientsbind();

            btnSave.Visible = true;
            btnUpdate.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('updated successfully');", true);
            
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not updated');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    


}