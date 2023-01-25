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
public partial class Design_IPD_Preoprative : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["PID"] = Request.QueryString["PatientID"].ToString();
            grdPreoprativebind();
            //Clear();
        }
          //ViewState["PID"] = Request.QueryString["PatientID"].ToString();
           //grdPreoprativebind();
        btnCancel.Visible = false;
    }

    protected void grdPreoprativeDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void grdPreoprativeDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
           // lblPID.Text = ((Label)grdPreoprativeDetails.Rows[id].FindControl("lblID")).Text;
           
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = false;
        }
    }
    public void grdPreoprativebind()
    {
        DataTable dt = GetPreoprativeDetails();
        ViewState["dt"] = dt;
        //DataTable dt = (DataTable)ViewState["dt"];
        DataRow[] rows = dt.Select("1=1");
        if (rows.Length > 0)
        {

            btnUpdate.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = false;
            lblPID.Text = rows[0]["ID"].ToString();
            lblLastUpdatedBy.Text = rows[0]["EntryBy1"].ToString();
            lblLastUpdatedDate.Text = rows[0]["Date1"].ToString();
            lblLastUpdatedTime.Text = rows[0]["Time1"].ToString();
                txtNPOSlice.Text = rows[0]["NPOSlice"].ToString();
                string NPOSliceYesNoNurse = rows[0]["NPOSliceYesNoNurse"].ToString();
                switch (NPOSliceYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbNPOSliceYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbNPOSliceYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtNPOSliceNurseComment.Text = rows[0]["NPOSliceNurseComment"].ToString();
                string NPOSliceYesNo = rows[0]["NPOSliceYesNo"].ToString();
                switch (NPOSliceYesNo.Trim())
                {
                    case "Yes":
                        rdbNPOSliceYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbNPOSliceYesNo.SelectedIndex = 1;
                        break;
                }
                txtNPOSliceComment.Text = rows[0]["NPOSliceComment"].ToString();
                txtIndificationBrand.Text = rows[0]["IndificationBrand"].ToString();
                string IndificationBrandYesNoNurse = rows[0]["IndificationBrandYesNoNurse"].ToString();
                switch (IndificationBrandYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbIndificationBrandYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbIndificationBrandYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtIndificationBrandNurseComment.Text = rows[0]["IndificationBrandNurseComment"].ToString();
                string IndificationBrandYesNo = rows[0]["IndificationBrandYesNo"].ToString();
                switch (IndificationBrandYesNo.Trim())
                {
                    case "Yes":
                        rdbIndificationBrandYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbIndificationBrandYesNo.SelectedIndex = 1;
                        break;
                }
                txtIndificationBrandComment.Text = rows[0]["IndificationBrandComment"].ToString();
                
                txtTheatreGown.Text = rows[0]["TheatreGown"].ToString();
                string TheatreGownYesNoNurse = rows[0]["TheatreGownYesNoNurse"].ToString();
                switch (TheatreGownYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbTheatreGownYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbTheatreGownYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtTheatreGownNurseComment.Text = rows[0]["TheatreGownNurseComment"].ToString();
                string TheatreGownYesNo = rows[0]["TheatreGownYesNo"].ToString();
                switch (TheatreGownYesNo.Trim())
                {
                    case "Yes":
                        rdbTheatreGownYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbTheatreGownYesNo.SelectedIndex = 1;
                        break;
                }
                txtTheatreGownComment.Text = rows[0]["TheatreGownComment"].ToString();
                
                txtKnownAllergies.Text = rows[0]["KnownAllergies"].ToString();

                string KnownAllergiesYesNoNurse = rows[0]["KnownAllergiesYesNoNurse"].ToString();
                switch (KnownAllergiesYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbKnownAllergiesYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbKnownAllergiesYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtKnownAllergiesNurseComment.Text = rows[0]["KnownAllergiesNurseComment"].ToString();
                string KnownAllergiesYesNo = rows[0]["KnownAllergiesYesNo"].ToString();
                switch (KnownAllergiesYesNo.Trim())
                {
                    case "Yes":
                        rdbKnownAllergiesYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbKnownAllergiesYesNo.SelectedIndex = 1;
                        break;
                }
                txtKnownAllergiesComment.Text = rows[0]["KnownAllergiesComment"].ToString();

                txtPersonalEffects.Text = rows[0]["PersonalEffects"].ToString();

                string PersonalEffectsYesNoNurse = rows[0]["PersonalEffectsYesNoNurse"].ToString();
                switch (PersonalEffectsYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbPersonalEffectsYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPersonalEffectsYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtPersonalEffectsNurseComment.Text = rows[0]["PersonalEffectsNurseComment"].ToString();
                string PersonalEffectsYesNo = rows[0]["PersonalEffectsYesNo"].ToString();
                switch (PersonalEffectsYesNo.Trim())
                {
                    case "Yes":
                        rdbPersonalEffectsYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPersonalEffectsYesNo.SelectedIndex = 1;
                        break;
                }
                txtPersonalEffectsComment.Text = rows[0]["PersonalEffectsComment"].ToString();
                txtDentures.Text = rows[0]["Dentures"].ToString();

                string DenturesYesNoNurse = rows[0]["DenturesYesNoNurse"].ToString();
                switch (DenturesYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbDenturesYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbDenturesYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtDenturesNurseComment.Text = rows[0]["DenturesNurseComment"].ToString();
                string DenturesYesNo = rows[0]["DenturesYesNo"].ToString();
                switch (DenturesYesNo.Trim())
                {
                    case "Yes":
                        rdbDenturesYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbDenturesYesNo.SelectedIndex = 1;
                        break;
                }
                txtDenturesComment.Text = rows[0]["DenturesComment"].ToString();
                txtIntravenousDrip.Text = rows[0]["IntravenousDrip"].ToString();

                string IntravenousDripYesNoNurse = rows[0]["IntravenousDripYesNoNurse"].ToString();
                switch (IntravenousDripYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbIntravenousDripYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbIntravenousDripYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtIntravenousDripNurseComment.Text = rows[0]["IntravenousDripNurseComment"].ToString();
                string IntravenousDripYesNo = rows[0]["IntravenousDripYesNo"].ToString();
                switch (IntravenousDripYesNo.Trim())
                {
                    case "Yes":
                        rdbIntravenousDripYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbIntravenousDripYesNo.SelectedIndex = 1;
                        break;
                }
                txtIntravenousDripComment.Text = rows[0]["IntravenousDripComment"].ToString();

                txtSkinPreparation.Text = rows[0]["SkinPreparation"].ToString();

                string SkinPreparationYesNoNurse = rows[0]["SkinPreparationYesNoNurse"].ToString();
                switch (SkinPreparationYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbSkinPreparationYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbSkinPreparationYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtSkinPreparationNurseComment.Text = rows[0]["SkinPreparationNurseComment"].ToString();
                string SkinPreparationYesNo = rows[0]["SkinPreparationYesNo"].ToString();
                switch (SkinPreparationYesNo.Trim())
                {
                    case "Yes":
                        rdbSkinPreparationYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbSkinPreparationYesNo.SelectedIndex = 1;
                        break;
                }
                txtSkinPreparationComment.Text = rows[0]["SkinPreparationComment"].ToString();

                txtNasogaticTube.Text = rows[0]["NasogaticTube"].ToString();

                string NasogaticTubeYesNoNurse = rows[0]["NasogaticTubeYesNoNurse"].ToString();
                switch (NasogaticTubeYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbNasogaticTubeYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbNasogaticTubeYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtNasogaticTubeNurseComment.Text = rows[0]["NasogaticTubeNurseComment"].ToString();
                string NasogaticTubeYesNo = rows[0]["NasogaticTubeYesNo"].ToString();
                switch (NasogaticTubeYesNo.Trim())
                {
                    case "Yes":
                        rdbNasogaticTubeYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbNasogaticTubeYesNo.SelectedIndex = 1;
                        break;
                }
                txtNasogaticTubeComment.Text = rows[0]["NasogaticTubeComment"].ToString();

                txtBowelPrep.Text = rows[0]["BowelPrep"].ToString();

                string BowelPrepYesNoNurse = rows[0]["BowelPrepYesNoNurse"].ToString();
                switch (BowelPrepYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbBowelPrepYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBowelPrepYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtBowelPrepNurseComment.Text = rows[0]["BowelPrepNurseComment"].ToString();
                string BowelPrepYesNo = rows[0]["BowelPrepYesNo"].ToString();
                switch (BowelPrepYesNo.Trim())
                {
                    case "Yes":
                        rdbBowelPrepYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBowelPrepYesNo.SelectedIndex = 1;
                        break;
                }
                txtBowelPrepComment.Text = rows[0]["BowelPrepComment"].ToString();


                txtUrinaryCatheter.Text = rows[0]["UrinaryCatheter"].ToString();

                string UrinaryCatheterYesNoNurse = rows[0]["UrinaryCatheterYesNoNurse"].ToString();
                switch (UrinaryCatheterYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbUrinaryCatheterYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbUrinaryCatheterYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtUrinaryCatheterNurseComment.Text = rows[0]["UrinaryCatheterNurseComment"].ToString();
                string UrinaryCatheterYesNo = rows[0]["UrinaryCatheterYesNo"].ToString();
                switch (UrinaryCatheterYesNo.Trim())
                {
                    case "Yes":
                        rdbUrinaryCatheterYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbUrinaryCatheterYesNo.SelectedIndex = 1;
                        break;
                }
                txtUrinaryCatheterComment.Text = rows[0]["UrinaryCatheterComment"].ToString();


                txtBladderemptied.Text = rows[0]["Bladderemptied"].ToString();

                string BladderemptiedYesNoNurse = rows[0]["BladderemptiedYesNoNurse"].ToString();
                switch (BladderemptiedYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbBladderemptiedYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBladderemptiedYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtBladderemptiedNurseComment.Text = rows[0]["BladderemptiedNurseComment"].ToString();
                string BladderemptiedYesNo = rows[0]["BladderemptiedYesNo"].ToString();
                switch (BladderemptiedYesNo.Trim())
                {
                    case "Yes":
                        rdbBladderemptiedYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBladderemptiedYesNo.SelectedIndex = 1;
                        break;
                }
                txtBladderemptiedComment.Text = rows[0]["BladderemptiedComment"].ToString();


                txtPremedicationOrdered.Text = rows[0]["PremedicationOrdered"].ToString();

                string PremedicationOrderedYesNoNurse = rows[0]["PremedicationOrderedYesNoNurse"].ToString();
                switch (PremedicationOrderedYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbPremedicationOrderedYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPremedicationOrderedYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtPremedicationOrderedNurseComment.Text = rows[0]["PremedicationOrderedNurseComment"].ToString();
                string PremedicationOrderedYesNo = rows[0]["PremedicationOrderedYesNo"].ToString();
                switch (PremedicationOrderedYesNo.Trim())
                {
                    case "Yes":
                        rdbPremedicationOrderedYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPremedicationOrderedYesNo.SelectedIndex = 1;
                        break;
                }
                txtPremedicationOrderedComment.Text = rows[0]["PremedicationOrderedComment"].ToString();


                txtPatientRecord.Text = rows[0]["PatientRecord"].ToString();

                string PatientRecordYesNoNurse = rows[0]["PatientRecordYesNoNurse"].ToString();
                switch (PatientRecordYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbPatientRecordYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPatientRecordYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtPatientRecordNurseComment.Text = rows[0]["PatientRecordNurseComment"].ToString();
                string PatientRecordYesNo = rows[0]["PatientRecordYesNo"].ToString();
                switch (PatientRecordYesNo.Trim())
                {
                    case "Yes":
                        rdbPatientRecordYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPatientRecordYesNo.SelectedIndex = 1;
                        break;
                }
                txtPatientRecordComment.Text = rows[0]["PatientRecordComment"].ToString();


                txtConsentForm.Text = rows[0]["ConsentForm"].ToString();

                string ConsentFormYesNoNurse = rows[0]["ConsentFormYesNoNurse"].ToString();
                switch (ConsentFormYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbConsentFormYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbConsentFormYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtConsentFormNurseComment.Text = rows[0]["ConsentFormNurseComment"].ToString();
                string ConsentFormYesNo = rows[0]["ConsentFormYesNo"].ToString();
                switch (ConsentFormYesNo.Trim())
                {
                    case "Yes":
                        rdbConsentFormYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbConsentFormYesNo.SelectedIndex = 1;
                        break;
                }
                txtConsentFormComment.Text = rows[0]["ConsentFormComment"].ToString();


                txtChartsavailable.Text = rows[0]["Chartsavailable"].ToString();

                string ChartsavailableYesNoNurse = rows[0]["ChartsavailableYesNoNurse"].ToString();
                switch (ChartsavailableYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbChartsavailableYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbChartsavailableYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtChartsavailableNurseComment.Text = rows[0]["ChartsavailableNurseComment"].ToString();
                string ChartsavailableYesNo = rows[0]["ChartsavailableYesNo"].ToString();
                switch (ChartsavailableYesNo.Trim())
                {
                    case "Yes":
                        rdbChartsavailableYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbChartsavailableYesNo.SelectedIndex = 1;
                        break;
                }
                txtChartsavailableComment.Text = rows[0]["ChartsavailableComment"].ToString();


                txtPatientadmitted.Text = rows[0]["Patientadmitted"].ToString();

                string PatientadmittedYesNoNurse = rows[0]["PatientadmittedYesNoNurse"].ToString();
                switch (PatientadmittedYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbPatientadmittedYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPatientadmittedYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtPatientadmittedNurseComment.Text = rows[0]["PatientadmittedNurseComment"].ToString();
                string PatientadmittedYesNo = rows[0]["PatientadmittedYesNo"].ToString();
                switch (PatientadmittedYesNo.Trim())
                {
                    case "Yes":
                        rdbPatientadmittedYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPatientadmittedYesNo.SelectedIndex = 1;
                        break;
                }
                txtPatientadmittedComment.Text = rows[0]["PatientadmittedComment"].ToString();

                txtLatestVitalSign.Text = rows[0]["LatestVitalSign"].ToString();

                string LatestVitalSignYesNoNurse = rows[0]["LatestVitalSignYesNoNurse"].ToString();
                switch (LatestVitalSignYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbLatestVitalSignYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbLatestVitalSignYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtLatestVitalSignNurseComment.Text = rows[0]["LatestVitalSignNurseComment"].ToString();
                string LatestVitalSignYesNo = rows[0]["LatestVitalSignYesNo"].ToString();
                switch (LatestVitalSignYesNo.Trim())
                {
                    case "Yes":
                        rdbLatestVitalSignYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbLatestVitalSignYesNo.SelectedIndex = 1;
                        break;
                }
                txtLatestVitalSignComment.Text = rows[0]["LatestVitalSignComment"].ToString();

                txtBPPR.Text = rows[0]["BPPR"].ToString();

                string BPPRYesNoNurse = rows[0]["BPPRYesNoNurse"].ToString();
                switch (BPPRYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbBPPRYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBPPRYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtBPPRNurseComment.Text = rows[0]["BPPRNurseComment"].ToString();
                string BPPRYesNo = rows[0]["BPPRYesNo"].ToString();
                switch (BPPRYesNo.Trim())
                {
                    case "Yes":
                        rdbBPPRYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBPPRYesNo.SelectedIndex = 1;
                        break;
                }
                txtBPPRComment.Text = rows[0]["BPPRComment"].ToString();

                txtPR1.Text = rows[0]["PR"].ToString();

                string PRYesNoNurse = rows[0]["PRYesNoNurse"].ToString();
                switch (PRYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbPR1.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPR1.SelectedIndex = 1;
                        break;
                }
                txtPRComment1.Text = rows[0]["PRComment"].ToString();
                string PRYesNo = rows[0]["PRYesNoNurse"].ToString();
                switch (PRYesNo.Trim())
                {
                    case "Yes":
                        rdbPR2.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbPR2.SelectedIndex = 1;
                        break;
                }
                txtPRComment2.Text = rows[0]["PRNurseComment"].ToString();
                
                
                txtTempSAT.Text = rows[0]["TempSAT"].ToString();

                string TempSATYesNoNurse = rows[0]["TempSATYesNoNurse"].ToString();
                switch (TempSATYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbTempSATYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbTempSATYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtTempSATNurseComment.Text = rows[0]["TempSATNurseComment"].ToString();
                string TempSATYesNo = rows[0]["TempSATYesNo"].ToString();
                switch (TempSATYesNo.Trim())
                {
                    case "Yes":
                        rdbTempSATYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbTempSATYesNo.SelectedIndex = 1;
                        break;
                }
                txtTempSATComment.Text = rows[0]["TempSATComment"].ToString();

                txtSAT.Text = rows[0]["SAT"].ToString();

                string SATYesNoNurse = rows[0]["SATYesNoNurse"].ToString();
                switch (SATYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbSAT1.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbSAT1.SelectedIndex = 1;
                        break;
                }
                txtSATComment1.Text = rows[0]["SATNurseComment"].ToString();
                string SATYesNo = rows[0]["SATYesNo"].ToString();
                switch (SATYesNo.Trim())
                {
                    case "Yes":
                        rdbSAT2.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbSAT2.SelectedIndex = 1;
                        break;
                }
                txtSATComment2.Text = rows[0]["SATComment"].ToString();
                
                
                txtResp.Text = rows[0]["Resp"].ToString();

                string RespYesNoNurse = rows[0]["RespYesNoNurse"].ToString();
                switch (RespYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbRespYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbRespYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtRespNurseComment.Text = rows[0]["RespNurseComment"].ToString();
                string RespYesNo = rows[0]["RespYesNo"].ToString();
                switch (RespYesNo.Trim())
                {
                    case "Yes":
                        rdbRespYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbRespYesNo.SelectedIndex = 1;
                        break;
                }
                txtRespComment.Text = rows[0]["RespComment"].ToString();
                txtWeightinKg.Text = rows[0]["WeightinKg"].ToString();

                string WeightinKgYesNoNurse = rows[0]["WeightinKgYesNoNurse"].ToString();
                switch (WeightinKgYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbWeightinKgYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbWeightinKgYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtWeightinKgNurseComment.Text = rows[0]["WeightinKgNurseComment"].ToString();
                string WeightinKgYesNo = rows[0]["WeightinKgYesNo"].ToString();
                switch (WeightinKgYesNo.Trim())
                {
                    case "Yes":
                        rdbWeightinKgYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbWeightinKgYesNo.SelectedIndex = 1;
                        break;
                }
                txtWeightinKgComment.Text = rows[0]["WeightinKgComment"].ToString();
                txtLMPforfemalePatient.Text = rows[0]["LMPforfemalePatient"].ToString();

                string LMPforfemalePatientYesNoNurse = rows[0]["LMPforfemalePatientYesNoNurse"].ToString();
                switch (LMPforfemalePatientYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbLMPforfemalePatientYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbLMPforfemalePatientYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtLMPforfemalePatientNurseComment.Text = rows[0]["LMPforfemalePatientNurseComment"].ToString();
                string LMPforfemalePatientYesNo = rows[0]["LMPforfemalePatientYesNo"].ToString();
                switch (LMPforfemalePatientYesNo.Trim())
                {
                    case "Yes":
                        rdbLMPforfemalePatientYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbLMPforfemalePatientYesNo.SelectedIndex = 1;
                        break;
                }
                txtLMPforfemalePatientComment.Text = rows[0]["LMPforfemalePatientComment"].ToString();
                txtLastHb.Text = rows[0]["LastHb"].ToString();

                string LastHbYesNoNurse = rows[0]["LastHbYesNoNurse"].ToString();
                switch (LastHbYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbLastHbYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbLastHbYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtLastHbNurseComment.Text = rows[0]["LastHbNurseComment"].ToString();
                string LastHbYesNo = rows[0]["LastHbYesNo"].ToString();
                switch (LastHbYesNo.Trim())
                {
                    case "Yes":
                        rdbLastHbYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbLastHbYesNo.SelectedIndex = 1;
                        break;
                }
                txtLastHbComment.Text = rows[0]["LastHbComment"].ToString();
                txtBloodOrdered.Text = rows[0]["BloodOrdered"].ToString();

                string BloodOrderedYesNoNurse = rows[0]["BloodOrderedYesNoNurse"].ToString();
                switch (BloodOrderedYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbBloodOrderedYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBloodOrderedYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtBloodOrderedNurseComment.Text = rows[0]["BloodOrderedNurseComment"].ToString();
                string BloodOrderedYesNo = rows[0]["BloodOrderedYesNo"].ToString();
                switch (BloodOrderedYesNo.Trim())
                {
                    case "Yes":
                        rdbBloodOrderedYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbBloodOrderedYesNo.SelectedIndex = 1;
                        break;
                }
                txtBloodOrderedComment.Text = rows[0]["BloodOrderedComment"].ToString();
                txtOtherLabTest.Text = rows[0]["OtherLabTest"].ToString();

                string OtherLabTestYesNoNurse = rows[0]["OtherLabTestYesNoNurse"].ToString();
                switch (OtherLabTestYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbOtherLabTestYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbOtherLabTestYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtOtherLabTestNurseComment.Text = rows[0]["OtherLabTestNurseComment"].ToString();
                string OtherLabTestYesNo = rows[0]["OtherLabTestYesNo"].ToString();
                switch (OtherLabTestYesNo.Trim())
                {
                    case "Yes":
                        rdbOtherLabTestYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbOtherLabTestYesNo.SelectedIndex = 1;
                        break;
                }
                txtOtherLabTestComment.Text = rows[0]["OtherLabTestComment"].ToString();
                txtNaPlus.Text = rows[0]["NaPlus"].ToString();

                string NaPlusYesNoNurse = rows[0]["NaPlusYesNoNurse"].ToString();
                switch (NaPlusYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbNaPlusYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbNaPlusYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtNaPlusNurseComment.Text = rows[0]["NaPlusNurseComment"].ToString();
                string NaPlusYesNo = rows[0]["NaPlusYesNo"].ToString();
                switch (NaPlusYesNo.Trim())
                {
                    case "Yes":
                        rdbNaPlusYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbNaPlusYesNo.SelectedIndex = 1;
                        break;
                }
                txtNaPlusComment.Text = rows[0]["NaPlusComment"].ToString();
                txtKPlus.Text = rows[0]["KPlus"].ToString();

                string KPlusYesNoNurse = rows[0]["KPlusYesNoNurse"].ToString();
                switch (KPlusYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbKPlusYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbKPlusYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtKPlusNurseComment.Text = rows[0]["KPlusNurseComment"].ToString();
                string KPlusYesNo = rows[0]["KPlusYesNo"].ToString();
                switch (KPlusYesNo.Trim())
                {
                    case "Yes":
                        rdbKPlusYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbKPlusYesNo.SelectedIndex = 1;
                        break;
                }
                txtKPlusComment.Text = rows[0]["KPlusComment"].ToString();
                txtCreatine.Text = rows[0]["Creatine"].ToString();

                string CreatineYesNoNurse = rows[0]["CreatineYesNoNurse"].ToString();
                switch (CreatineYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbCreatineYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbCreatineYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtCreatineNurseComment.Text = rows[0]["CreatineNurseComment"].ToString();
                string CreatineYesNo = rows[0]["CreatineYesNo"].ToString();
                switch (CreatineYesNo.Trim())
                {
                    case "Yes":
                        rdbCreatineYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbCreatineYesNo.SelectedIndex = 1;
                        break;
                }
                txtCreatineComment.Text = rows[0]["CreatineComment"].ToString();
                txtChronicalcoholintake.Text = rows[0]["Chronicalcoholintake"].ToString();

                string ChronicalcoholintakeYesNoNurse = rows[0]["ChronicalcoholintakeYesNoNurse"].ToString();
                switch (ChronicalcoholintakeYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbChronicalcoholintakeYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbChronicalcoholintakeYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtChronicalcoholintakeNurseComment.Text = rows[0]["ChronicalcoholintakeNurseComment"].ToString();
                string ChronicalcoholintakeYesNo = rows[0]["ChronicalcoholintakeYesNo"].ToString();
                switch (ChronicalcoholintakeYesNo.Trim())
                {
                    case "Yes":
                        rdbChronicalcoholintakeYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbChronicalcoholintakeYesNo.SelectedIndex = 1;
                        break;
                }
                txtChronicalcoholintakeComment.Text = rows[0]["ChronicalcoholintakeComment"].ToString();
                txtChronicSmoker.Text = rows[0]["ChronicSmoker"].ToString();

                string ChronicSmokerYesNoNurse = rows[0]["ChronicSmokerYesNoNurse"].ToString();
                switch (ChronicSmokerYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbChronicSmokerYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbChronicSmokerYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtChronicSmokerNurseComment.Text = rows[0]["ChronicSmokerNurseComment"].ToString();
                string ChronicSmokerYesNo = rows[0]["ChronicSmokerYesNo"].ToString();
                switch (ChronicSmokerYesNo.Trim())
                {
                    case "Yes":
                        rdbChronicSmokerYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbChronicSmokerYesNo.SelectedIndex = 1;
                        break;
                }
                txtChronicSmokerComment.Text = rows[0]["ChronicSmokerComment"].ToString();
                txtMedication.Text = rows[0]["Medication"].ToString();

                string MedicationYesNoNurse = rows[0]["MedicationYesNoNurse"].ToString();
                switch (MedicationYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbMedicationYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbMedicationYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtMedicationNurseComment.Text = rows[0]["MedicationNurseComment"].ToString();
                string MedicationYesNo = rows[0]["MedicationYesNo"].ToString();
                switch (MedicationYesNo.Trim())
                {
                    case "Yes":
                        rdbMedicationYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbMedicationYesNo.SelectedIndex = 1;
                        break;
                }
                txtMedicationComment.Text = rows[0]["MedicationComment"].ToString();
                string AntibioticsYesNo = rows[0]["AntibioticsYesNo"].ToString();
                switch (AntibioticsYesNo.Trim())
                {
                    case "Yes":
                        rdbAntibioticsYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbAntibioticsYesNo.SelectedIndex = 1;
                        break;
                }
                string AntipertensivetherapyYesNo = rows[0]["AntipertensivetherapyYesNo"].ToString();
                switch (AntipertensivetherapyYesNo.Trim())
                {
                    case "Yes":
                        rdbAntipertensivetherapyYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbAntipertensivetherapyYesNo.SelectedIndex = 1;
                        break;
                }

                string AnticoagulantTherapyYesNo = rows[0]["AnticoagulantTherapyYesNo"].ToString();
                switch (AnticoagulantTherapyYesNo.Trim())
                {
                    case "Yes":
                        rdbAnticoagulantTherapyYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbAnticoagulantTherapyYesNo.SelectedIndex = 1;
                        break;
                }

                string InsulinOralhypoglycemicYesNo = rows[0]["InsulinOralhypoglycemicYesNo"].ToString();
                switch (InsulinOralhypoglycemicYesNo.Trim())
                {
                    case "Yes":
                        rdbInsulinOralhypoglycemicYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbInsulinOralhypoglycemicYesNo.SelectedIndex = 1;
                        break;
                }
                txtTimeRecievedintheOR.Text = rows[0]["TimeRecievedintheOR"].ToString();

                string TimeRecievedintheORYesNoNurse = rows[0]["TimeRecievedintheORYesNoNurse"].ToString();
                switch (TimeRecievedintheORYesNoNurse.Trim())
                {
                    case "Yes":
                        rdbTimeRecievedintheORYesNoNurse.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbTimeRecievedintheORYesNoNurse.SelectedIndex = 1;
                        break;
                }
                txtTimeRecievedintheORNurseComment.Text = rows[0]["TimeRecievedintheORNurseComment"].ToString();
                string TimeRecievedintheORYesNo = rows[0]["TimeRecievedintheORYesNo"].ToString();
                switch (TimeRecievedintheORYesNo.Trim())
                {
                    case "Yes":
                        rdbTimeRecievedintheORYesNo.SelectedIndex = 0;
                        break;
                    case "No":
                        rdbTimeRecievedintheORYesNo.SelectedIndex = 1;
                        break;
                }
                txtTimeRecievedintheORComment.Text = rows[0]["TimeRecievedintheORComment"].ToString();
               


        }

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
       // Clear();
    }
    private DataTable GetPreoprativeDetails()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT *,(SELECT Concat(Title,' ',Name)Name FROM employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1,DATE_FORMAT(Date, '%d-%b-%Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1 FROM preoprativechecklist where PatientId='" + ViewState["PID"] + "'");


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
        string date = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        string time = Util.GetDateTime(DateTime.Now).ToString("HH:mm");
           
        try
        {

            string query = "INSERT INTO `preoprativechecklist` ("+
  "`NPOSlice`,  `NPOSliceYesNoNurse`,  `NPOSliceNurseComment`,  `NPOSliceYesNo`,  `NPOSliceComment`,  `IndificationBrand`,  `IndificationBrandYesNoNurse`,  `IndificationBrandNurseComment`,"+
  "`IndificationBrandYesNo`,  `IndificationBrandComment`,  `TheatreGown`,  `TheatreGownYesNoNurse`,  `TheatreGownNurseComment`,  `TheatreGownYesNo`,  `TheatreGownComment`,  `KnownAllergies`,"+
  "`KnownAllergiesYesNoNurse`,  `KnownAllergiesNurseComment`,  `KnownAllergiesYesNo`,  `KnownAllergiesComment`,  `PersonalEffects`,  `PersonalEffectsYesNoNurse`,  `PersonalEffectsNurseComment`,"+
 " `PersonalEffectsYesNo`,  `PersonalEffectsComment`,  `Dentures`,  `DenturesYesNoNurse`,  `DenturesNurseComment`,  `DenturesYesNo`,  `DenturesComment`,  `IntravenousDrip`,  `IntravenousDripYesNoNurse`,"+
 " `IntravenousDripNurseComment`,  `IntravenousDripYesNo`,  `IntravenousDripComment`,  `SkinPreparation`,  `SkinPreparationYesNoNurse`,  `SkinPreparationNurseComment`,  `SkinPreparationYesNo`,"+
 " `SkinPreparationComment`,  `NasogaticTube`,  `NasogaticTubeYesNoNurse`,  `NasogaticTubeNurseComment`,  `NasogaticTubeYesNo`,  `NasogaticTubeComment`,  `BowelPrep`,  `BowelPrepYesNoNurse`,"+
 " `BowelPrepNurseComment`,  `BowelPrepYesNo`,  `BowelPrepComment`,  `UrinaryCatheter`,  `UrinaryCatheterYesNoNurse`,  `UrinaryCatheterNurseComment`,  `UrinaryCatheterYesNo`,  `UrinaryCatheterComment`,"+
"  `Bladderemptied`,  `BladderemptiedYesNoNurse`,  `BladderemptiedNurseComment`,  `BladderemptiedYesNo`,  `BladderemptiedComment`,  `PremedicationOrdered`,  `PremedicationOrderedYesNoNurse`,  `PremedicationOrderedNurseComment`,"+
"  `PremedicationOrderedYesNo`,  `PremedicationOrderedComment`,  `PatientRecord`,  `PatientRecordYesNoNurse`,  `PatientRecordNurseComment`,  `PatientRecordYesNo`,  `PatientRecordComment`,"+
"  `ConsentForm`,  `ConsentFormYesNoNurse`,  `ConsentFormNurseComment`, `ConsentFormYesNo`,  `ConsentFormComment`,  `Chartsavailable`,  `ChartsavailableYesNoNurse`,  `ChartsavailableNurseComment`,"+
"  `ChartsavailableYesNo`,  `ChartsavailableComment`,  `Patientadmitted`,  `PatientadmittedYesNoNurse`,  `PatientadmittedNurseComment`,  `PatientadmittedYesNo`,  `PatientadmittedComment`,"+
"  `LatestVitalSign`,  `LatestVitalSignYesNoNurse`,  `LatestVitalSignNurseComment`,  `LatestVitalSignYesNo`,  `LatestVitalSignComment`,  `BPPR`,  `BPPRYesNoNurse`,  `BPPRNurseComment`,  `BPPRYesNo`,"+
 " `BPPRComment`,  `TempSAT`,  `TempSATYesNoNurse`,  `TempSATNurseComment`,  `TempSATYesNo`,  `TempSATComment`,  `Resp`,  `RespYesNoNurse`,  `RespNurseComment`,  `RespYesNo`,  `RespComment`,"+
"  `WeightinKg`,  `WeightinKgYesNoNurse`,  `WeightinKgNurseComment`,  `WeightinKgYesNo`,  `WeightinKgComment`,  `LMPforfemalePatient`,  `LMPforfemalePatientYesNoNurse`,  `LMPforfemalePatientNurseComment`,"+
"  `LMPforfemalePatientYesNo`,  `LMPforfemalePatientComment`,  `LastHb`,  `LastHbYesNoNurse`,  `LastHbNurseComment`,  `LastHbYesNo`,  `LastHbComment`,  `BloodOrdered`,  `BloodOrderedYesNoNurse`,"+
"  `BloodOrderedNurseComment`,  `BloodOrderedYesNo`,  `BloodOrderedComment`,  `OtherLabTest`,  `OtherLabTestYesNoNurse`,  `OtherLabTestNurseComment`,  `OtherLabTestYesNo`,  `OtherLabTestComment`,"+
"  `NaPlus`,  `NaPlusYesNoNurse`,  `NaPlusNurseComment`,  `NaPlusYesNo`,  `NaPlusComment`,  `KPlus`,  `KPlusYesNoNurse`,  `KPlusNurseComment`,  `KPlusYesNo`,  `KPlusComment`,  `Creatine`,"+
"  `CreatineYesNoNurse`,  `CreatineNurseComment`,  `CreatineYesNo`,  `CreatineComment`,  `Chronicalcoholintake`,  `ChronicalcoholintakeYesNoNurse`,  `ChronicalcoholintakeNurseComment`,  `ChronicalcoholintakeYesNo`,"+
"  `ChronicalcoholintakeComment`,  `ChronicSmoker`,  `ChronicSmokerYesNoNurse`,  `ChronicSmokerNurseComment`,  `ChronicSmokerYesNo`,  `ChronicSmokerComment`,  `Medication`,  `MedicationYesNoNurse`,"+
"  `MedicationNurseComment`,  `MedicationYesNo`,  `MedicationComment`,  `AntibioticsYesNo`,  `AntipertensivetherapyYesNo`,  `AnticoagulantTherapyYesNo`,  `InsulinOralhypoglycemicYesNo`,"+
"  `TimeRecievedintheOR`,  `TimeRecievedintheORYesNoNurse`,  `TimeRecievedintheORNurseComment`,  `TimeRecievedintheORYesNo`,  `TimeRecievedintheORComment`,`EntryBy`,`PatientId`,"+
"PR,PRYesNo,PRComment,PRNurseComment,PRYesNoNurse,SAT,SATYesNo,SATComment,SATNurseComment,SATYesNoNurse,Date,Time) " +
" VALUES  (  '" + txtNPOSlice.Text + "',    '" + rdbNPOSliceYesNoNurse.SelectedValue + "',    '" + txtNPOSliceNurseComment.Text + "',    '" + rdbNPOSliceYesNo.SelectedValue + "',    '"+
txtNPOSliceComment.Text + "',    '" + txtIndificationBrand.Text + "',    '" + rdbIndificationBrandYesNoNurse.SelectedValue + "',    '"+txtIndificationBrandNurseComment.Text+"'," +
"    '" + rdbIndificationBrandYesNo.SelectedValue + "',    '"+txtIndificationBrandComment.Text+"',    '"+txtTheatreGown.Text+"',    '"+rdbTheatreGownYesNoNurse.SelectedValue+"',    '"+
    txtTheatreGownNurseComment.Text+"',    '"+rdbTheatreGownYesNo.SelectedValue+"',    '"+txtTheatreGownComment.Text+"'," +
"    '" + txtKnownAllergies.Text + "',    '" + rdbKnownAllergiesYesNoNurse.SelectedValue + "',    '"+txtKnownAllergiesNurseComment.Text+"',    '"+rdbKnownAllergiesYesNo.SelectedValue+
"',   '" + txtKnownAllergiesComment.Text + "',    '" + txtPersonalEffects.Text + "',    '" + rdbPersonalEffectsYesNoNurse.SelectedValue + "'," +
 "   '" + txtPersonalEffectsNurseComment.Text + "',    '" + rdbPersonalEffectsYesNo.SelectedValue + "',    '"+txtPersonalEffectsComment.Text+"',    '"+txtDentures.Text+"',    '"+
 rdbDenturesYesNoNurse.SelectedValue + "',    '" + txtDenturesNurseComment.Text + "',    '" + rdbDenturesYesNo.SelectedValue + "',    '"+txtDenturesComment.Text+"'," +
"    '" + txtIntravenousDrip.Text + "',    '" + rdbIntravenousDripYesNoNurse.SelectedValue + "',    '"+txtIntravenousDripNurseComment.Text+"',    '"+
rdbIntravenousDripYesNo.SelectedValue + "',    '" + txtIntravenousDripComment.Text + "',    '" + txtSkinPreparation.Text + "',    '" + rdbSkinPreparationYesNoNurse.SelectedValue + "'," +

"    '" + txtSkinPreparationNurseComment.Text + "',    '" + rdbSkinPreparationYesNo.SelectedValue + "',    '"+txtSkinPreparationComment.Text+"',    '"+txtNasogaticTube.Text+"',    '"+
rdbNasogaticTubeYesNoNurse.SelectedValue + "',    '" + txtNasogaticTubeNurseComment.Text + "',    '" + rdbNasogaticTubeYesNo.SelectedValue + "'," +
"    '" + txtNasogaticTubeComment.Text + "',    '" + txtBowelPrep.Text + "',    '" + rdbBowelPrepYesNoNurse.SelectedValue + "',    '"+txtBowelPrepNurseComment.Text+"',    '"+
rdbBowelPrepYesNo.SelectedValue + "',    '" + txtBowelPrepComment.Text + "',    '" + txtUrinaryCatheter.Text + "',    '" + rdbUrinaryCatheterYesNoNurse.SelectedValue + "'," +
"    '" + txtUrinaryCatheterNurseComment.Text + "',    '" + rdbUrinaryCatheterYesNo.SelectedValue + "',    '"+txtUrinaryCatheterComment.Text+"',    '"+txtBladderemptied.Text+"',   '"+
rdbBladderemptiedYesNoNurse.SelectedValue + "',    '" + txtBladderemptiedNurseComment.Text + "',    '" + rdbBladderemptiedYesNo.SelectedValue + "'," +
"    '" + txtBladderemptiedComment.Text + "',    '" + txtPremedicationOrdered.Text + "',    '" + rdbPremedicationOrderedYesNoNurse.SelectedValue + "',    '"+
txtPremedicationOrderedNurseComment.Text + "',    '" + rdbPremedicationOrderedYesNo.SelectedValue + "',    '"+txtPremedicationOrderedComment.Text+"'," +
"    '" + txtPatientRecord.Text + "',    '" + rdbPatientRecordYesNoNurse.SelectedValue + "',    '" + txtPatientRecordNurseComment.Text + "',    '" + rdbPatientRecordYesNo.SelectedValue +
"',    '" + txtPatientRecordComment.Text + "',    '" + txtConsentForm.Text + "',    '" + rdbConsentFormYesNoNurse.SelectedValue + "',    '"+txtConsentFormNurseComment.Text+"'," +
"    '" + rdbConsentFormYesNo.SelectedValue + "',    '" + txtConsentFormComment.Text + "',    '" + txtChartsavailable.Text + "',    '" + rdbChartsavailableYesNoNurse.SelectedValue + "',    '"+
txtChartsavailableNurseComment.Text + "',    '" + rdbChartsavailableYesNo.SelectedValue + "',    '"+txtChartsavailableComment.Text+"'," +
"    '" + txtPatientadmitted.Text + "',    '" + rdbPatientadmittedYesNoNurse.SelectedValue + "',    '"+txtPatientadmittedNurseComment.Text+"',    '"+
rdbPatientadmittedYesNo.SelectedValue + "',    '" + txtPatientadmittedComment.Text + "',    '" + txtLatestVitalSign.Text + "',    '" + rdbLatestVitalSignYesNoNurse.SelectedValue + "'," +

"    '" + txtLatestVitalSignNurseComment.Text + "',    '" + rdbLatestVitalSignYesNo.SelectedValue + "',    '"+txtLatestVitalSignComment.Text+"',    '"+txtBPPR.Text+"',    '"+
rdbBPPRYesNoNurse.SelectedValue + "',    '" + txtBPPRNurseComment.Text + "',    '" + rdbBPPRYesNo.SelectedValue + "',    '"+txtBPPRComment.Text+"',    '"+txtTempSAT.Text+"'," +
"    '" + rdbTempSATYesNoNurse.SelectedValue + "',    '" + txtTempSATNurseComment.Text + "',    '" + rdbTempSATYesNo.SelectedValue + "',    '"+txtTempSATComment.Text+"',    '"+
txtResp.Text + "',    '" + rdbRespYesNoNurse.SelectedValue + "',    '" + txtRespNurseComment.Text + "',    '" + rdbRespYesNo.SelectedValue + "',    '"+txtRespComment.Text+"',    '"+
txtWeightinKg.Text+"'," +
"    '" + rdbWeightinKgYesNoNurse.SelectedValue + "',    '" + txtWeightinKgNurseComment.Text + "',    '" + rdbWeightinKgYesNo.SelectedValue + "',    '"+txtWeightinKgComment.Text+"',    '"+
txtLMPforfemalePatient.Text + "',    '" + rdbLMPforfemalePatientYesNoNurse.SelectedValue + "',    '"+txtLMPforfemalePatientNurseComment.Text+"'," +
"    '" + rdbLMPforfemalePatientYesNo.SelectedValue + "',    '" + txtLMPforfemalePatientComment.Text + "',    '" + txtLastHb.Text + "',    '" + rdbLastHbYesNoNurse.SelectedValue + "',    '"+
txtLastHbNurseComment.Text + "',    '" + rdbLastHbYesNo.SelectedValue + "',    '" + txtLastHbComment.Text + "',    '" + txtBloodOrdered.Text + "',    '" + rdbBloodOrderedYesNoNurse.SelectedValue + "'," +
"    '" + txtBloodOrderedNurseComment.Text + "',    '" + rdbBloodOrderedYesNo.SelectedValue + "',    '"+txtBloodOrderedComment.Text+"',    '"+txtOtherLabTest.Text+"',    '"+
rdbOtherLabTestYesNoNurse.SelectedValue + "',    '" + txtOtherLabTestNurseComment.Text + "',    '" + rdbOtherLabTestYesNo.SelectedValue + "',    '"+txtOtherLabTestComment.Text+"'," +
"    '" + txtNaPlus.Text + "',    '" + rdbNaPlusYesNoNurse.SelectedValue + "',    '" + txtNaPlusNurseComment.Text + "',    '" + rdbNaPlusYesNo.SelectedValue + "',    '"+
txtNaPlusComment.Text + "',    '" + txtKPlus.Text + "',    '" + rdbKPlusYesNoNurse.SelectedValue + "',    '" + txtKPlusNurseComment.Text + "',    '" + rdbKPlusYesNo.SelectedValue + "',    '"+
txtKPlusComment.Text+"'," +
"    '" + txtCreatine.Text + "',    '" + rdbCreatineYesNoNurse.SelectedValue + "',    '" + txtCreatineNurseComment.Text + "',    '" + rdbCreatineYesNo.SelectedValue + "',    '"+
txtCreatineComment.Text + "',    '" + txtChronicalcoholintake.Text + "',    '" + rdbChronicalcoholintakeYesNoNurse.SelectedValue + "',    '"+txtChronicalcoholintakeNurseComment.Text+"'," +
"    '" + rdbChronicalcoholintakeYesNo.SelectedValue + "',    '" + txtChronicalcoholintakeComment.Text + "',    '" + txtChronicSmoker.Text + "',    '" + rdbChronicSmokerYesNoNurse.SelectedValue +
"',    '" + txtChronicSmokerNurseComment.Text + "',    '" + rdbChronicSmokerYesNo.SelectedValue + "',    '"+txtChronicSmokerComment.Text+"'," +
"    '" + txtMedication.Text + "',    '" + rdbMedicationYesNoNurse.SelectedValue + "',    '" + txtMedicationNurseComment.Text + "',    '" + rdbMedicationYesNo.SelectedValue + "',    '"+
txtMedicationComment.Text + "',    '" + rdbAntibioticsYesNo.SelectedValue + "',    '" + rdbAntipertensivetherapyYesNo.SelectedValue + "',    '" + rdbAnticoagulantTherapyYesNo.SelectedValue + "'," +
"    '" + rdbInsulinOralhypoglycemicYesNo.SelectedValue + "',    '" + txtTimeRecievedintheOR.Text + "',    '" + rdbTimeRecievedintheORYesNoNurse.SelectedValue + "',    '"+
txtTimeRecievedintheORNurseComment.Text + "',    '" + rdbTimeRecievedintheORYesNo.SelectedValue + "',    '"+txtTimeRecievedintheORComment.Text+"'" +
" ,'" + Session["ID"].ToString() + "' ,'" + ViewState["PID"] + "','"+txtPR1.Text+"','"+rdbPR1.SelectedValue+"','"+txtPRComment1.Text+"','"+txtPRComment2.Text+"','"+
rdbPR2.SelectedValue+"','"+txtSAT.Text+"','"+rdbSAT1.SelectedValue+"','"+txtSATComment1.Text+"','"+txtSATComment2.Text+"','"+rdbSAT2.SelectedValue+"','"+date+"','"+time+"');";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            
            grdPreoprativebind();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('saved successfully');$(':text').val('');$(':radio'). prop('checked', false);", true);
           
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
        txtNPOSlice.Text = "";
        txtIndificationBrand.Text = "";
        txtTheatreGown.Text = "";
        txtKnownAllergies.Text = "";
        txtPersonalEffects.Text = "";
        txtDentures.Text = "";
        txtIntravenousDrip.Text ="";


        btnUpdate.Visible = false;
        btnSave.Visible = true;
        btnCancel.Visible = false;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "$(':text').val('');", true);

    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string date = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        string time = Util.GetDateTime(DateTime.Now).ToString("HH:mm");
       
        try
        {
            string query = "UPDATE  preoprativechecklist SET   NPOSlice = '" + txtNPOSlice.Text + "',   `NPOSliceYesNoNurse` = '" + rdbNPOSliceYesNoNurse.SelectedValue + "',  `NPOSliceNurseComment` = '" + txtNPOSliceNurseComment.Text + "',  `NPOSliceYesNo` = '" + rdbNPOSliceYesNo.SelectedValue + "'," +
"  `NPOSliceComment` = '" + txtNPOSliceComment.Text + "',   IndificationBrand = '" + txtIndificationBrand.Text + "',  `IndificationBrandYesNoNurse` = '" + rdbIndificationBrandYesNoNurse.SelectedValue + "',  `IndificationBrandNurseComment` = '"+txtIndificationBrandNurseComment.Text+"'," +
 " `IndificationBrandYesNo` = '" + rdbIndificationBrandYesNo.SelectedValue + "',  `IndificationBrandComment` = '" + txtIndificationBrandComment.Text + "',   TheatreGown = '" + txtTheatreGown.Text + "',  `TheatreGownYesNoNurse` = '" + rdbTheatreGownYesNoNurse.SelectedValue + "'," +
 " `TheatreGownNurseComment` = '" + txtTheatreGownNurseComment.Text + "',  `TheatreGownYesNo` = '" + rdbTheatreGownYesNo.SelectedValue + "',  `TheatreGownComment` = '"+txtTheatreGownComment.Text+"',  KnownAllergies = '" +
                txtKnownAllergies.Text + "'," +
"  `KnownAllergiesYesNoNurse` = '" + rdbKnownAllergiesYesNoNurse.SelectedValue + "',  `KnownAllergiesNurseComment` = '" + txtKnownAllergiesNurseComment.Text + "',  `KnownAllergiesYesNo` = '" + rdbKnownAllergiesYesNo.SelectedValue + "'," +
"  `KnownAllergiesComment` = '" + txtKnownAllergiesComment.Text + "',   PersonalEffects = '" + txtPersonalEffects.Text + "',   `PersonalEffectsYesNoNurse` = '" + rdbPersonalEffectsYesNoNurse.SelectedValue + "'," +
"  `PersonalEffectsNurseComment` = '" + txtPersonalEffectsNurseComment.Text + "',  `PersonalEffectsYesNo` = '" + rdbPersonalEffectsYesNo.SelectedValue + "',  `PersonalEffectsComment` = '"+txtPersonalEffectsComment.Text+"'," +
"   Dentures = '" + txtDentures.Text + "',   `DenturesYesNoNurse` = '" + rdbDenturesYesNoNurse.SelectedValue + "',  `DenturesNurseComment` = '" + txtDenturesNurseComment.Text + "',  `DenturesYesNo` = '" + rdbDenturesYesNo.SelectedValue + "'," +
"  `DenturesComment` = '" + txtDenturesComment.Text + "',    IntravenousDrip = '" + txtIntravenousDrip.Text + "',  `IntravenousDripYesNoNurse` = '" + rdbIntravenousDripYesNoNurse.SelectedValue + "'," +
"  `IntravenousDripNurseComment` = '" + txtIntravenousDripNurseComment.Text + "',  `IntravenousDripYesNo` = '" + rdbIntravenousDripYesNo.SelectedValue + "',  `IntravenousDripComment` = '"+txtIntravenousDripComment.Text+"'" +
  
",  `SkinPreparation` = '" + txtSkinPreparation.Text + "',  `SkinPreparationYesNoNurse` = '" + rdbSkinPreparationYesNoNurse.SelectedValue + "',  `SkinPreparationNurseComment` = '"+txtSkinPreparationNurseComment.Text+"'," +
"  `SkinPreparationYesNo` = '" + rdbSkinPreparationYesNo.SelectedValue + "',  `SkinPreparationComment` = '" + txtSkinPreparationComment.Text + "',  `NasogaticTube` = '" + txtNasogaticTube.Text + "',  `NasogaticTubeYesNoNurse` = '" + rdbNasogaticTubeYesNoNurse.SelectedValue + "'," +
"  `NasogaticTubeNurseComment` = '" + txtNasogaticTubeNurseComment.Text + "',  `NasogaticTubeYesNo` = '" + rdbNasogaticTubeYesNo.SelectedValue + "',  `NasogaticTubeComment` = '"+txtNasogaticTubeComment.Text+"',  `BowelPrep` = '"+txtBowelPrep.Text+"'," +
 " `BowelPrepYesNoNurse` = '" + rdbBowelPrepYesNoNurse.SelectedValue + "',  `BowelPrepNurseComment` = '" + txtBowelPrepNurseComment.Text + "',  `BowelPrepYesNo` = '" + rdbBowelPrepYesNo.SelectedValue + "',  `BowelPrepComment` = '"+txtBowelPrepComment.Text+"'," +
 " `UrinaryCatheter` = '" + txtUrinaryCatheter.Text + "',  `UrinaryCatheterYesNoNurse` = '" + rdbUrinaryCatheterYesNoNurse.SelectedValue + "',  `UrinaryCatheterNurseComment` = '" + txtUrinaryCatheterNurseComment.Text + "',  `UrinaryCatheterYesNo` = '" + rdbUrinaryCatheterYesNo.SelectedValue + "'," +
"  `UrinaryCatheterComment` = '" + txtUrinaryCatheterComment.Text + "',  `Bladderemptied` = '" + txtBladderemptied.Text + "',  `BladderemptiedYesNoNurse` = '" + rdbBladderemptiedYesNoNurse.SelectedValue + "',  `BladderemptiedNurseComment` = '"+txtBladderemptiedNurseComment.Text+"'," +
"  `BladderemptiedYesNo` = '" + rdbBladderemptiedYesNo.SelectedValue + "',  `BladderemptiedComment` = '" + txtBladderemptiedComment.Text + "',  `PremedicationOrdered` = '" + txtPremedicationOrdered.Text + "',  `PremedicationOrderedYesNoNurse` = '" + rdbPremedicationOrderedYesNoNurse.SelectedValue + "'," +
 " `PremedicationOrderedNurseComment` = '" + txtPremedicationOrderedNurseComment.Text + "',  `PremedicationOrderedYesNo` = '" + rdbPremedicationOrderedYesNo.SelectedValue + "',  `PremedicationOrderedComment` = '"+txtPremedicationOrderedComment.Text+"'," +
 " `PatientRecord` = '" + txtPatientRecord.Text + "',  `PatientRecordYesNoNurse` = '" + rdbPatientRecordYesNoNurse.SelectedValue + "',  `PatientRecordNurseComment` = '" + txtPatientRecordNurseComment.Text + "',  `PatientRecordYesNo` = '" + rdbPatientRecordYesNo.SelectedValue + "'," +
"  `PatientRecordComment` = '" + txtPatientRecordComment.Text + "',  `ConsentForm` = '" + txtConsentForm.Text + "',  `ConsentFormYesNoNurse` = '" + rdbConsentFormYesNoNurse.SelectedValue + "',  `ConsentFormNurseComment` = '"+txtConsentFormNurseComment.Text+"'," +
"  `ConsentFormYesNo` = '" + rdbConsentFormYesNo.SelectedValue + "',  `ConsentFormComment` = '" + txtConsentFormComment.Text + "',  `Chartsavailable` = '" + txtChartsavailable.Text + "',  `ChartsavailableYesNoNurse` = '" + rdbChartsavailableYesNoNurse.SelectedValue + "'," +
"  `ChartsavailableNurseComment` = '" + txtChartsavailableNurseComment.Text + "',  `ChartsavailableYesNo` = '" + rdbChartsavailableYesNo.SelectedValue + "',  `ChartsavailableComment` = '"+txtChartsavailableComment.Text+"',  `Patientadmitted` = '"+txtPatientadmitted.Text+"'," +
"  `PatientadmittedYesNoNurse` = '" + rdbPatientadmittedYesNoNurse.SelectedValue + "',  `PatientadmittedNurseComment` = '" + txtPatientadmittedNurseComment.Text + "',  `PatientadmittedYesNo` = '" + rdbPatientadmittedYesNo.SelectedValue + "',  `PatientadmittedComment` = '"+txtPatientadmittedComment.Text+"'," +
"  `LatestVitalSign` = '" + txtLatestVitalSign.Text + "',  `LatestVitalSignYesNoNurse` = '" + rdbLatestVitalSignYesNoNurse.SelectedValue + "',  `LatestVitalSignNurseComment` = '" + txtLatestVitalSignNurseComment.Text + "',  `LatestVitalSignYesNo` = '" + rdbLatestVitalSignYesNo.SelectedValue + "'," +
"  `LatestVitalSignComment` = '" + txtLatestVitalSignComment.Text + "',  `BPPR` = '" + txtBPPR.Text + "',  `BPPRYesNoNurse` = '" + rdbBPPRYesNoNurse.SelectedValue + "',  `BPPRNurseComment` = '" + txtBPPRNurseComment.Text + "',  `BPPRYesNo` = '" + rdbBPPRYesNo.SelectedValue + "'," +
 " `BPPRComment` = '" + txtBPPRComment.Text + "',  `TempSAT` = '" + txtTempSAT.Text + "',  `TempSATYesNoNurse` = '" + rdbTempSATYesNoNurse.SelectedValue + "',  `TempSATNurseComment` = '" + txtTempSATNurseComment.Text + "',  `TempSATYesNo` = '" + rdbTempSATYesNo.SelectedValue + "'," +
"  `TempSATComment` = '" + txtTempSATComment.Text + "',  `Resp` = '" + txtResp.Text + "',  `RespYesNoNurse` = '" + rdbRespYesNoNurse.SelectedValue + "',  `RespNurseComment` = '" + txtRespNurseComment.Text + "',  `RespYesNo` = '" + rdbRespYesNo.SelectedValue + "',  `RespComment` = '"+txtRespComment.Text+"'," +
"  `WeightinKg` = '" + txtWeightinKg.Text + "',  `WeightinKgYesNoNurse` = '" + rdbWeightinKgYesNoNurse.SelectedValue + "',  `WeightinKgNurseComment` = '" + txtWeightinKgNurseComment.Text + "',  `WeightinKgYesNo` = '" + rdbWeightinKgYesNo.SelectedValue + "',  `WeightinKgComment` = '"+txtWeightinKgComment.Text+"'," +
"  `LMPforfemalePatient` = '" + txtLMPforfemalePatient.Text + "',  `LMPforfemalePatientYesNoNurse` = '" + rdbLMPforfemalePatientYesNoNurse.SelectedValue + "',  `LMPforfemalePatientNurseComment` = '"+txtLMPforfemalePatientNurseComment.Text+"'," +
"  `LMPforfemalePatientYesNo` = '" + rdbLMPforfemalePatientYesNo.SelectedValue + "',  `LMPforfemalePatientComment` = '" + txtLMPforfemalePatientComment.Text + "',  `LastHb` = '" + txtLastHb.Text + "',  `LastHbYesNoNurse` = '" + rdbLastHbYesNoNurse.SelectedValue + "'," +
"  `LastHbNurseComment` = '" + txtLastHbNurseComment.Text + "',  `LastHbYesNo` = '" + rdbLastHbYesNo.SelectedValue + "',  `LastHbComment` = '" + txtLastHbComment.Text + "',  `BloodOrdered` = '" + txtBloodOrdered.Text + "',  `BloodOrderedYesNoNurse` = '" + rdbBloodOrderedYesNoNurse.SelectedValue + "'," +
"  `BloodOrderedNurseComment` = '" + txtBloodOrderedNurseComment.Text + "',  `BloodOrderedYesNo` = '" + rdbBloodOrderedYesNo.SelectedValue + "',  `BloodOrderedComment` = '"+txtBloodOrderedComment.Text+"',  `OtherLabTest` = '"+txtOtherLabTest.Text+"'," +
"  `OtherLabTestYesNoNurse` = '" + rdbOtherLabTestYesNoNurse.SelectedValue + "',  `OtherLabTestNurseComment` = '" + txtOtherLabTestNurseComment.Text + "',  `OtherLabTestYesNo` = '" + rdbOtherLabTestYesNo.SelectedValue + "',  `OtherLabTestComment` = '"+txtOtherLabTestComment.Text+"'," +
"  `NaPlus` = '" + txtNaPlus.Text + "',  `NaPlusYesNoNurse` = '" + rdbNaPlusYesNoNurse.SelectedValue + "',  `NaPlusNurseComment` = '" + txtNaPlusNurseComment.Text + "',  `NaPlusYesNo` = '" + rdbNaPlusYesNo.SelectedValue + "',  `NaPlusComment` = '"+txtNaPlusComment.Text+"',  `KPlus` = '"+txtKPlus.Text+"'," +
"  `KPlusYesNoNurse` = '" + rdbKPlusYesNoNurse.SelectedValue + "',  `KPlusNurseComment` = '" + txtKPlusNurseComment.Text + "',  `KPlusYesNo` = '" + rdbKPlusYesNo.SelectedValue + "',  `KPlusComment` = '" + txtKPlusComment.Text + "',  `Creatine` = '" + txtCreatine.Text + "',  `CreatineYesNoNurse` = '" + rdbCreatineYesNoNurse.SelectedValue + "'," +
"  `CreatineNurseComment` = '" + txtCreatineNurseComment.Text + "',  `CreatineYesNo` = '" + rdbCreatineYesNo.SelectedValue + "',  `CreatineComment` = '" + txtCreatineComment.Text + "',  `Chronicalcoholintake` = '" + txtChronicalcoholintake.Text + "',  `ChronicalcoholintakeYesNoNurse` = '" + rdbChronicalcoholintakeYesNoNurse.SelectedValue + "'," +
"  `ChronicalcoholintakeNurseComment` = '" + txtChronicalcoholintakeNurseComment.Text + "',  `ChronicalcoholintakeYesNo` = '" + rdbChronicalcoholintakeYesNo.SelectedValue + "',  `ChronicalcoholintakeComment` = '"+txtChronicalcoholintakeComment.Text+"'," +
"  `ChronicSmoker` = '" + txtChronicSmoker.Text + "',  `ChronicSmokerYesNoNurse` = '" + rdbChronicSmokerYesNoNurse.SelectedValue + "',  `ChronicSmokerNurseComment` = '" + txtChronicSmokerNurseComment.Text + "',  `ChronicSmokerYesNo` = '" + rdbChronicSmokerYesNo.SelectedValue + "'," +
"  `ChronicSmokerComment` = '" + txtChronicSmokerComment.Text + "',  `Medication` = '" + txtMedication.Text + "',  `MedicationYesNoNurse` = '" + rdbMedicationYesNoNurse.SelectedValue + "',  `MedicationNurseComment` = '"+txtMedicationNurseComment.Text+"'," +
"  `MedicationYesNo` = '" + rdbMedicationYesNo.SelectedValue + "',  `MedicationComment` = '" + txtMedicationComment.Text + "',  `AntibioticsYesNo` = '" + rdbAntibioticsYesNo.SelectedValue + "',  `AntipertensivetherapyYesNo` = '" + rdbAntipertensivetherapyYesNo.SelectedValue + "'," +
"  `AnticoagulantTherapyYesNo` = '" + rdbAnticoagulantTherapyYesNo.SelectedValue + "',  `InsulinOralhypoglycemicYesNo` = '" + rdbInsulinOralhypoglycemicYesNo.SelectedValue + "',  `TimeRecievedintheOR` = '"+txtTimeRecievedintheOR.Text+"'," +
"  `TimeRecievedintheORYesNoNurse` = '" + rdbTimeRecievedintheORYesNoNurse.SelectedValue + "',  `TimeRecievedintheORNurseComment` = '" + txtTimeRecievedintheORNurseComment.Text + "',  `TimeRecievedintheORYesNo` = '" + rdbTimeRecievedintheORYesNo.SelectedValue + "'," +
"  `TimeRecievedintheORComment` = '"+txtTimeRecievedintheORComment.Text+"',"+
"PR='"+txtPR1.Text+"',PRYesNo='"+rdbPR1.SelectedValue+"',PRComment='"+txtPRComment1.Text+"',PRNurseComment='"+txtPRComment2.Text+"',PRYesNoNurse='"+rdbPR2.SelectedValue+"',"+
"SAT='"+txtSAT.Text+"',SATYesNo='"+rdbSAT1.SelectedValue+"',SATComment='"+txtSATComment1.Text+"',SATNurseComment='"+txtSATComment2.Text+"',SATYesNoNurse='"+rdbSAT2.SelectedValue+"',Date='" + date + "',Time='" + time + "',EntryBy='" + Session["ID"].ToString() + "'"+

           " WHERE Id = '"+lblPID.Text+"';";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            //Clear();
            grdPreoprativebind();

            btnSave.Visible = true;
            btnUpdate.Visible = false;

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('updated successfully');$(':text').val('');$(':radio'). prop('checked', false);", true);
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