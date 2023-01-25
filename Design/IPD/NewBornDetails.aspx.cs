using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web;
using System.Web.Services;

public partial class Design_ip_NewBornDetails : System.Web.UI.Page
{
    public NewBornDetails nbd = new NewBornDetails();
    protected string hc = "";
    [WebMethod]
    
    public void BindDetails()
    {
        try
        {
            //caldate.EndDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT *,DATE_FORMAT(IfDeathDate,'%d-%b-%Y') AS IfDeathDate1,DATE_FORMAT(ReturnToMCHDate,'%d-%b-%Y') AS ReturnToMCHDate1,DATE_FORMAT(PolioDate,'%d-%b-%Y') AS PolioDate1,DATE_FORMAT(BCGDate,'%d-%b-%Y') AS BCGDate1,DATE_FORMAT(DischargeDate1,'%d-%b-%Y') AS DischargeDate11,DATE_FORMAT(RupturedMembranesDate,'%d-%b-%Y') AS RupturedMembranesDate1,DATE_FORMAT(Date4,'%d-%b-%Y') AS Date41,DATE_FORMAT(GestationByDate,'%d-%b-%Y') AS GestationByDate1," +
                "DATE_FORMAT(DischargeDate,'%d-%b-%Y') AS DischargeDate12,DATE_FORMAT(DischargeDate,'%d-%b-%Y') AS DischargeDate11,DATE_FORMAT(Date3,'%d-%b-%Y') AS Date31,DATE_FORMAT(Date2,'%d-%b-%Y') AS Date21," +
                "DATE_FORMAT(Date1,'%d-%b-%Y') AS Date12,DATE_FORMAT(Date,'%d-%b-%Y') AS Date11,DATE_FORMAT(Time3,'%h:%m') AS Time31,DATE_FORMAT(DeathTime,'%h:%m') AS DeathTime1,DATE_FORMAT(Time1,'%h:%m') AS Time14,DATE_FORMAT(Date,'%d-%b-%Y') AS Date11,DATE_FORMAT(Time,'%h:%m') AS Time11,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CVE.EntryBy LIMIT 0, 1) AS EntryBy1  FROM newborndetails CVE where cve.TransactionID='" + ViewState["TID"]+"' ");
            //sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
            //sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
            //sb.Append("    WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                ViewState["dt"] = dt;
                grdPhysical.DataSource = dt;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    [WebMethod]
    public void GetRow(string id)
    {
        try
        {
            //caldate.EndDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT *,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CVE.EntryBy LIMIT 0, 1) AS EntryBy1  FROM newborndetails CVE where CVE.Id='"+id+"'");
            //sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
            //sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
            //sb.Append("    WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPhysical.DataSource = dt;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Clear();
            lblMsg.Text = "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnCancel_Click1(object sender, EventArgs e)
    { }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (!Validation())
            {
                return;
            }
            //string result = SaveData();
            //if (result != string.Empty)
            //{
            //    if (result == "0")
            //    {
            //        return;
            //    }

            //    lblMsg.Text = "Record Saved Successfully";
            //    BindDetails();
            //    Clear();
            //}
            //else
            //{
            //    lblMsg.Text = "Record not Saved";
            //}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (!Validation())
        {
            return;
        }

        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {
            lblMsg.Text = "Only Past  dates alllowed";
            return;
        }

        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" ");
            sb.Append("  WHERE ID = '" + lblPID.Text + "' ");


            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 1)
                lblMsg.Text = "Record Updated Successfully";
            tnx.Commit();
            BindDetails();
            Clear();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                lblMsg.Text = "";

                int id = Convert.ToInt16(e.CommandArgument.ToString());
                txtPID.Value = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                
            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + txtPID.Value + "'");
            if (rows.Length > 0)
            {
                txtDate.Text = rows[0]["Date11"].ToString();

                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time11"].ToString()).ToString("hh:mm tt");
                string Alive = rows[0]["Alive"].ToString();
                if (Alive.Trim() == "1")
                {
                    chkAlive.Checked = true;
                }
                else
                {

                    chkAlive.Checked = false;
                }
                string FreshStillBirth = rows[0]["FreshStillBirth"].ToString();
                if (FreshStillBirth.Trim() == "1")
                {
                    chkFreshStillBirth.Checked = true;
                }
                else
                {

                    chkFreshStillBirth.Checked = false;
                }
                string MaceratedStillBirth = rows[0]["MaceratedStillBirth"].ToString();
                if (MaceratedStillBirth.Trim() == "1")
                {
                    chkMaceratedStillBirth.Checked = true;
                }
                else
                {

                    chkMaceratedStillBirth.Checked = false;
                }
                string Single = rows[0]["Single"].ToString();
                if (Single.Trim() == "1")
                {
                    chkSingle.Checked = true;
                }
                else
                {

                    chkSingle.Checked = false;
                }

                string Twin = rows[0]["Twin"].ToString();
                if (Twin.Trim() == "1")
                {
                    chkTwin.Checked = true;
                }
                else
                {

                    chkTwin.Checked = false;
                }
                string Triplet = rows[0]["Triplet"].ToString();
                if (Triplet.Trim() == "1")
                {
                    chkTriplet.Checked = true;
                }
                else
                {

                    chkTriplet.Checked = false;
                }

                txtBirthWeight.Text = rows[0]["BirthWeight"].ToString();
                txtHC.Text = rows[0]["HC"].ToString();
                txtLength.Text = rows[0]["Length"].ToString();
                txtApgarScore3.Text = rows[0]["ApgarScore3"].ToString();
                txtHeart1.Text = rows[0]["Heart1"].ToString();
                txtHeart2.Text = rows[0]["Heart2"].ToString();
                txtHeart3.Text = rows[0]["Heart3"].ToString();
                txtRespiratoryEffort1.Text = rows[0]["RespiratoryEffort1"].ToString();
                txtRespiratoryEffort2.Text = rows[0]["RespiratoryEffort2"].ToString();
                txtRespiratoryEffort3.Text = rows[0]["RespiratoryEffort3"].ToString();
                txtMuscletone1.Text = rows[0]["Muscletone1"].ToString();
                txtMuscletone2.Text = rows[0]["Muscletone2"].ToString();
                txtMuscletone3.Text = rows[0]["Muscletone3"].ToString();
                txtRefluxResponseToStimulus1.Text = rows[0]["RefluxResponseToStimulus1"].ToString();
                txtRefluxResponseToStimulus2.Text = rows[0]["RefluxResponseToStimulus2"].ToString();
                txtRefluxResponseToStimulus3.Text = rows[0]["RefluxResponseToStimulus3"].ToString();
                txtColour1.Text = rows[0]["Colour1"].ToString();
                txtColour2.Text = rows[0]["Colour2"].ToString();
                txtColour3.Text = rows[0]["Colour3"].ToString();
                txtTotalScore1.Text = rows[0]["TotalScore1"].ToString();
                txtTotalScore2.Text = rows[0]["TotalScore2"].ToString();
                txtTotalScore3.Text = rows[0]["TotalScore3"].ToString();

                string MicroniumAspiration = rows[0]["MicroniumAspiration"].ToString();
                if (MicroniumAspiration.Trim() == "1")
                {
                    chkMicroniumAspiration.Checked = true;
                }
                else
                {

                    chkMicroniumAspiration.Checked = false;
                }
                string CordAroundNeckx = rows[0]["CordAroundNeckx"].ToString();
                if (CordAroundNeckx.Trim() == "1")
                {
                    chkCordAroundNeckx.Checked = true;
                }
                else
                {

                    chkCordAroundNeckx.Checked = false;
                }
                string Other = rows[0]["Other"].ToString();
                if (Other.Trim() == "1")
                {
                    chkOther.Checked = true;
                }
                else
                {

                    chkOther.Checked = false;
                }
                txtOtherComment.Text = rows[0]["OtherComment"].ToString();
                string Tetracycline = rows[0]["Tetracycline"].ToString();
                if (Other.Trim() == "1")
                {
                    chkTetracycline.Checked = true;
                }
                else
                {

                    chkTetracycline.Checked = false;
                }
                string VitK = rows[0]["VitK"].ToString();
                if (VitK.Trim() == "1")
                {
                    chkVitK.Checked = true;
                }
                else
                {

                    chkVitK.Checked = false;
                }
                string Resuscitation = rows[0]["Resuscitation"].ToString();
                if (Resuscitation.Trim() == "1")
                {
                    chkResuscitation.Checked = true;
                }
                else
                {

                    chkResuscitation.Checked = false;
                }
                string O2 = rows[0]["O2"].ToString();
                if (O2.Trim() == "1")
                {
                    chkO2.Checked = true;
                }
                else
                {

                    chkO2.Checked = false;
                }
                string Ambu = rows[0]["Ambu"].ToString();
                if (Ambu.Trim() == "1")
                {
                    chkAmbu.Checked = true;
                }
                else
                {

                    chkAmbu.Checked = false;
                }
                string Intubation = rows[0]["Intubation"].ToString();
                if (Intubation.Trim() == "1")
                {
                    chkIntubation.Checked = true;
                }
                else
                {

                    chkIntubation.Checked = false;
                }
                string CardiacCompression = rows[0]["CardiacCompression"].ToString();
                if (CardiacCompression.Trim() == "1")
                {
                    chkCardiacCompression.Checked = true;
                }
                else
                {

                    chkCardiacCompression.Checked = false;
                }
                string Injury = rows[0]["Injury"].ToString();
                if (Injury.Trim() == "1")
                {
                    chkInjury.Checked = true;
                }
                else
                {

                    chkInjury.Checked = false;
                }
                txtInjurySpecify.Value = rows[0]["InjurySpecify"].ToString();
                string CongenitalAbnormalities = rows[0]["CongenitalAbnormalities"].ToString();
                if (CongenitalAbnormalities.Trim() == "1")
                {
                    chkCongenitalAbnormalities.Checked = true;
                }
                else
                {

                    chkCongenitalAbnormalities.Checked = false;
                }

                txtCongenitalAbnormalitiesSpecify.Value = rows[0]["CongenitalAbnormalitiesSpecify"].ToString();
                string RespiratoryDistress = rows[0]["RespiratoryDistress"].ToString();
                if (RespiratoryDistress.Trim() == "1")
                {
                    chkRespiratoryDistress.Checked = true;
                }
                else
                {

                    chkRespiratoryDistress.Checked = false;
                }
                string Other1 = rows[0]["Other1"].ToString();
                if (Other1.Trim() == "1")
                {
                    chkOther1.Checked = true;
                }
                else
                {

                    chkOther1.Checked = false;
                }

                txtOther1Specify.Value = rows[0]["Other1Specify"].ToString();

                txtDate1.Text = rows[0]["Date12"].ToString();
                string ToMotherCare = rows[0]["ToMotherCare"].ToString();
                if (ToMotherCare.Trim() == "1")
                {
                    chkToMotherCare.Checked = true;
                }
                else
                {

                    chkToMotherCare.Checked = false;
                }

                txtDate2.Text = rows[0]["Date21"].ToString();
                string ToNursary = rows[0]["ToNursary"].ToString();
                if (ToNursary.Trim() == "1")
                {
                    chkToNursary.Checked = true;
                }
                else
                {

                    chkToNursary.Checked = false;
                }

                txtDate3.Text = rows[0]["Date31"].ToString();
                txtReason.Text = rows[0]["Reason"].ToString();
                txtDischargeDate.Text = rows[0]["DischargeDate12"].ToString();
                txtDays.Text = rows[0]["Days"].ToString();
                txtMotherAge.Text = rows[0]["MotherAge"].ToString();
                txtG.Text = rows[0]["G"].ToString();
                txtP.Text = rows[0]["P"].ToString();
                txtPlus.Text = rows[0]["Plus"].ToString();
                txtLMP.Text = rows[0]["LMP"].ToString();
                txtGestationByDate.Text = rows[0]["GestationByDate1"].ToString();
                txtGestationByUIS.Text = rows[0]["GestationByUIS"].ToString();
                txtNoOfPrenatal.Text = rows[0]["NoOfPrenatal"].ToString();
                txtWhere.Text = rows[0]["Where"].ToString();
                txtBloodTypeRhesus.Text = rows[0]["BloodTypeRhesus"].ToString();
                txtHgb.Text = rows[0]["Hgb"].ToString();
                txtVRDL.Text = rows[0]["VRDL"].ToString();
                txtPMCTSerology.Text = rows[0]["PMCTSerology"].ToString();
                string pos = rows[0]["pos"].ToString();
                if (pos.Trim() == "1")
                {
                    chkpos.Checked = true;
                }
                else
                {

                    chkpos.Checked = false;
                }
                string neg = rows[0]["neg"].ToString();
                if (neg.Trim() == "1")
                {
                    chkneg.Checked = true;
                }
                else
                {

                    chkneg.Checked = false;
                }
                string refused = rows[0]["refused"].ToString();
                if (refused.Trim() == "1")
                {
                    chkrefused.Checked = true;
                }
                else
                {

                    chkrefused.Checked = false;
                }

                txtPrenatalComplications.Text = rows[0]["PrenatalComplications"].ToString();
                string preeclampsia1 = rows[0]["preeclampsia1"].ToString();
                if (preeclampsia1.Trim() == "1")
                {
                    chkpreeclampsia1.Checked = true;
                }
                else
                {

                    chkpreeclampsia1.Checked = false;
                }
                txtPrenatalComplications.Text = rows[0]["PrenatalComplications"].ToString();
                string Eclampsia = rows[0]["Eclampsia"].ToString();
                if (Eclampsia.Trim() == "1")
                {
                    chkEclampsia.Checked = true;
                }
                else
                {

                    chkEclampsia.Checked = false;
                }
                string OligoHydramnios = rows[0]["OligoHydramnios"].ToString();
                if (OligoHydramnios.Trim() == "1")
                {
                    chkOligoHydramnios.Checked = true;
                }
                else
                {

                    chkOligoHydramnios.Checked = false;
                }
                string PolyHydramnios = rows[0]["PolyHydramnios"].ToString();
                if (PolyHydramnios.Trim() == "1")
                {
                    chkPolyHydramnios.Checked = true;
                }
                else
                {

                    chkPolyHydramnios.Checked = false;
                }
                string APH1 = rows[0]["APH1"].ToString();
                if (APH1.Trim() == "1")
                {
                    chkAPH1.Checked = true;
                }
                else
                {

                    chkAPH1.Checked = false;
                }
                string GestDiabetes = rows[0]["GestDiabetes"].ToString();
                if (GestDiabetes.Trim() == "1")
                {
                    chkGestDiabetes.Checked = true;
                }
                else
                {

                    chkGestDiabetes.Checked = false;
                }
                string Twins1 = rows[0]["Twins1"].ToString();
                if (Twins1.Trim() == "1")
                {
                    chkTwins1.Checked = true;
                }
                else
                {

                    chkTwins1.Checked = false;
                }
                string Other2 = rows[0]["Other2"].ToString();
                if (Other2.Trim() == "1")
                {
                    chkOther2.Checked = true;
                }
                else
                {

                    chkOther2.Checked = false;
                }
                txtOther2Comment.Value = rows[0]["Other2Comment"].ToString();
                string AbnormalDeliveries = rows[0]["AbnormalDeliveries"].ToString();
                if (AbnormalDeliveries.Trim() == "1")
                {
                    chkAbnormalDeliveries.Checked = true;
                }
                else
                {

                    chkAbnormalDeliveries.Checked = false;
                }
                string CS = rows[0]["CS"].ToString();
                if (CS.Trim() == "1")
                {
                    chkCS.Checked = true;
                }
                else
                {

                    chkCS.Checked = false;
                }

                string VacuumForceps = rows[0]["VacuumForceps"].ToString();
                if (VacuumForceps.Trim() == "1")
                {
                    chkVacuumForceps.Checked = true;
                }
                else
                {

                    chkVacuumForceps.Checked = false;
                }
                string Twins = rows[0]["Twins"].ToString();
                if (Twins.Trim() == "1")
                {
                    chkTwins.Checked = true;
                }
                else
                {

                    chkTwins.Checked = false;
                }
                string APH = rows[0]["APH"].ToString();
                if (APH.Trim() == "1")
                {
                    chkAPH.Checked = true;
                }
                else
                {

                    chkAPH.Checked = false;
                }
                string PPH = rows[0]["PPH"].ToString();
                if (PPH.Trim() == "1")
                {
                    chkPPH.Checked = true;
                }
                else
                {

                    chkPPH.Checked = false;
                }
                string preeclampsia = rows[0]["preeclampsia"].ToString();
                if (preeclampsia.Trim() == "1")
                {
                    chkpreeclampsia.Checked = true;
                }
                else
                {

                    chkpreeclampsia.Checked = false;
                }
                string stillbirth = rows[0]["stillbirth"].ToString();
                if (stillbirth.Trim() == "1")
                {
                    chkstillbirth.Checked = true;
                }
                else
                {

                    chkstillbirth.Checked = false;
                }
                string preterm = rows[0]["preterm"].ToString();
                if (preterm.Trim() == "1")
                {
                    chkpreterm.Checked = true;
                }
                else
                {

                    chkpreterm.Checked = false;
                }
                string FirstWeekMortality = rows[0]["FirstWeekMortality"].ToString();
                if (FirstWeekMortality.Trim() == "1")
                {
                    chkFirstWeekMortality.Checked = true;
                }
                else
                {

                    chkFirstWeekMortality.Checked = false;
                }
                string NeonatalJaundice = rows[0]["NeonatalJaundice"].ToString();
                if (NeonatalJaundice.Trim() == "1")
                {
                    chkNeonatalJaundice.Checked = true;
                }
                else
                {

                    chkNeonatalJaundice.Checked = false;
                }
                string CongeriltalAbnorm = rows[0]["CongeriltalAbnorm"].ToString();
                if (CongeriltalAbnorm.Trim() == "1")
                {
                    chkCongeriltalAbnorm.Checked = true;
                }
                else
                {

                    chkCongeriltalAbnorm.Checked = false;
                }
                string Other3 = rows[0]["Other3"].ToString();
                if (Other3.Trim() == "1")
                {
                    chkOther3.Checked = true;
                }
                else
                {

                    chkOther3.Checked = false;
                }

                txtOther3Comment.Value = rows[0]["Other3Comment"].ToString();

                string Hx = rows[0]["Hx"].ToString();
                if (Hx.Trim() == "1")
                {
                    chkHx.Checked = true;
                }
                else
                {

                    chkHx.Checked = false;
                }
                string Th = rows[0]["Th"].ToString();
                if (Th.Trim() == "1")
                {
                    chkTh.Checked = true;
                }
                else
                {

                    chkTh.Checked = false;
                }
                string Kidney = rows[0]["Kidney"].ToString();
                if (Kidney.Trim() == "1")
                {
                    chkKidney.Checked = true;
                }
                else
                {

                    chkKidney.Checked = false;
                }
                string HeartDisease = rows[0]["HeartDisease"].ToString();
                if (HeartDisease.Trim() == "1")
                {
                    chkHeartDisease.Checked = true;
                }
                else
                {

                    chkHeartDisease.Checked = false;
                }
                string Hypertension = rows[0]["Hypertension"].ToString();
                if (Hypertension.Trim() == "1")
                {
                    chkHypertension.Checked = true;
                }
                else
                {

                    chkHypertension.Checked = false;
                }
                string Diabetes = rows[0]["Diabetes"].ToString();
                if (Diabetes.Trim() == "1")
                {
                    chkDiabetes.Checked = true;
                }
                else
                {

                    chkDiabetes.Checked = false;
                }
                string Convulsions = rows[0]["Convulsions"].ToString();
                if (Convulsions.Trim() == "1")
                {
                    chkConvulsions.Checked = true;
                }
                else
                {

                    chkConvulsions.Checked = false;
                }
                txtOther4.Value = rows[0]["Other4"].ToString();
                txtPresentingHxonAdmissionMother.Text = rows[0]["PresentingHxonAdmissionMother"].ToString();
                txtDate4.Text = rows[0]["Date41"].ToString();

                ((TextBox)txtTime1.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time14"].ToString()).ToString("hh:mm tt");
                txtRupturedMembranesDate.Text = rows[0]["RupturedMembranesDate1"].ToString();

                ((TextBox)txtTime3.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time31"].ToString()).ToString("hh:mm tt");
                txtColour.Text = rows[0]["Colour"].ToString();
                txtComment.Text = rows[0]["Comment"].ToString();
                string NST = rows[0]["NST"].ToString();
                if (NST.Trim() == "1")
                {
                    chkNST.Checked = true;
                }
                else
                {

                    chkNST.Checked = false;
                }
                string Reactive = rows[0]["Reactive"].ToString();
                if (Reactive.Trim() == "1")
                {
                    chkReactive.Checked = true;
                }
                else
                {

                    chkReactive.Checked = false;
                }
                string NonReactive = rows[0]["NonReactive"].ToString();
                if (NonReactive.Trim() == "1")
                {
                    chkNonReactive.Checked = true;
                }
                else
                {

                    chkNonReactive.Checked = false;
                }
                txtComment1.Text = rows[0]["Comment1"].ToString();
                txtUS.Text = rows[0]["US"].ToString();
                txtOneStage.Text = rows[0]["OneStage"].ToString();
                txtTwoStage.Text = rows[0]["TwoStage"].ToString();
                txtThreeStage.Text = rows[0]["ThreeStage"].ToString();
                txtTotalHoursOfLabour.Text = rows[0]["TotalHoursOfLabour"].ToString();

                string VagVtx = rows[0]["VagVtx"].ToString();
                if (VagVtx.Trim() == "1")
                {
                    chkVagVtx.Checked = true;
                }
                else
                {

                    chkVagVtx.Checked = false;
                }
                string AssistedBreech = rows[0]["AssistedBreech"].ToString();
                if (AssistedBreech.Trim() == "1")
                {
                    chkAssistedBreech.Checked = true;
                }
                else
                {

                    chkAssistedBreech.Checked = false;
                }
                string PitocinCytotec = rows[0]["PitocinCytotec"].ToString();
                if (PitocinCytotec.Trim() == "1")
                {
                    chkPitocinCytotec.Checked = true;
                }
                else
                {

                    chkPitocinCytotec.Checked = false;
                }
                string Vacuum2 = rows[0]["Vacuum2"].ToString();
                if (Vacuum2.Trim() == "1")
                {
                    chkVacuum2.Checked = true;
                }
                else
                {

                    chkVacuum2.Checked = false;
                }
                string Forceps2 = rows[0]["Forceps2"].ToString();
                if (Forceps2.Trim() == "1")
                {
                    chkForceps2.Checked = true;
                }
                else
                {

                    chkForceps2.Checked = false;
                }
                string CSElectiveEmergency = rows[0]["CSElectiveEmergency"].ToString();
                if (CSElectiveEmergency.Trim() == "1")
                {
                    chkCSElectiveEmergency.Checked = true;
                }
                else
                {

                    chkCSElectiveEmergency.Checked = false;
                }

                txtReason1.Value = rows[0]["Reason1"].ToString();

                string Dexamethasone = rows[0]["Dexamethasone"].ToString();
                if (Dexamethasone.Trim() == "1")
                {
                    chkDexamethasone.Checked = true;
                }
                else
                {

                    chkDexamethasone.Checked = false;
                }
                string Antibiotics = rows[0]["Antibiotics"].ToString();
                if (Antibiotics.Trim() == "1")
                {
                    chkAntibiotics.Checked = true;
                }
                else
                {

                    chkAntibiotics.Checked = false;
                }
                string MagSO4 = rows[0]["MagSO4"].ToString();
                if (MagSO4.Trim() == "1")
                {
                    chkMagSO4.Checked = true;
                }
                else
                {

                    chkMagSO4.Checked = false;
                }
                string Other5 = rows[0]["Other5"].ToString();
                if (Other5.Trim() == "1")
                {
                    chkOther5.Checked = true;
                }
                else
                {

                    chkOther5.Checked = false;
                }

                txtOther5Comment.Value = rows[0]["Other5Comment"].ToString();

                string RecordedOnRegistrationBook = rows[0]["RecordedOnRegistrationBook"].ToString();
                if (RecordedOnRegistrationBook.Trim() == "1")
                {
                    chkRecordedOnRegistrationBook.Checked = true;
                }
                else
                {

                    chkRecordedOnRegistrationBook.Checked = false;
                }
                string NoAckOfBirthNotCompleted = rows[0]["NoAckOfBirthNotCompleted"].ToString();
                if (NoAckOfBirthNotCompleted.Trim() == "1")
                {
                    chkNoAckOfBirthNotCompleted.Checked = true;
                }
                else
                {

                    chkNoAckOfBirthNotCompleted.Checked = false;
                }
                txtDischargeDate1.Text = rows[0]["DischargeDate11"].ToString();
                txtDischargeCondition.Value = rows[0]["DischargeCondition"].ToString();
                txtDischargeWeight.Value = rows[0]["DischargeWeight"].ToString();
                txtHeadCircumtrence.Value = rows[0]["HeadCircumtrence"].ToString();
                string ChildHealthCardMade = rows[0]["ChildHealthCardMade"].ToString();
                if (ChildHealthCardMade.Trim() == "1")
                {
                    chkChildHealthCardMade.Checked = true;
                }
                else
                {

                    chkChildHealthCardMade.Checked = false;
                }
                txtBCGDate.Text = rows[0]["BCGDate1"].ToString();
                txtPolioDate.Text = rows[0]["PolioDate1"].ToString();
                txtReturnToMCHDate.Text = rows[0]["ReturnToMCHDate1"].ToString();
                txtIfDeathDate.Text = rows[0]["IfDeathDate1"].ToString();
                txtPolioDate.Text = rows[0]["PolioDate1"].ToString();

                ((TextBox)txtDeathTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["DeathTime1"].ToString()).ToString("hh:mm tt");
                txtCauseOfDeath.Value = rows[0]["CauseOfDeath"].ToString();
                txtAgeAtDeath.Value = rows[0]["AgeAtDeath"].ToString();
                txtParentGuardian.Value = rows[0]["ParentGuardian"].ToString();
                txtWitness.Value = rows[0]["Witness"].ToString();
                txtHusbandGuardian1.Value = rows[0]["HusbandGuardian1"].ToString();
                txtWitness1.Value = rows[0]["Witness1"].ToString();

               // txtDate.Text = rows[0]["Date1"].ToString();
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "$('#btnSave').hide();$('#btnUpdate').show();", true);
            }
                
                
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    if (((Label)e.Row.FindControl("lblUserID")).Text != Session["ID"].ToString() || Util.GetDateTime(((Label)e.Row.FindControl("lblEntryDate")).Text).ToString("dd-MMM-yyyy") != Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy"))
            //    {
            //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            //    }
            //}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    public string CreatedBy = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        caldate.EndDate = DateTime.Now;
        CalendarExtender12.EndDate = DateTime.Now;
        CalendarExtender1.EndDate = DateTime.Now;
        CalendarExtender2.EndDate = DateTime.Now;
        CalendarExtender3.EndDate = DateTime.Now;
        CalendarExtender4.EndDate = DateTime.Now;
        CalendarExtender5.EndDate = DateTime.Now;
        CalendarExtender6.EndDate = DateTime.Now;
        CalendarExtender7.EndDate = DateTime.Now;
        CalendarExtender10.EndDate = DateTime.Now;
        CalendarExtender11.EndDate = DateTime.Now;
        CalendarExtender8.EndDate = DateTime.Now;
        CalendarExtender9.EndDate = DateTime.Now;
        CalendarExtender8.EndDate = DateTime.Now;


        txtDate.Attributes.Add("readOnly", "true");
        txtDate1.Attributes.Add("readOnly", "true");
        txtDate2.Attributes.Add("readOnly", "true");
        txtDate3.Attributes.Add("readOnly", "true");
        txtDischargeDate.Attributes.Add("readOnly", "true");
        txtGestationByDate.Attributes.Add("readOnly", "true");
        txtDate4.Attributes.Add("readOnly", "true");
        txtRupturedMembranesDate.Attributes.Add("readOnly", "true");
        txtDischargeDate1.Attributes.Add("readOnly", "true");
        txtBCGDate.Attributes.Add("readOnly", "true");
        txtPolioDate.Attributes.Add("readOnly", "true");
        txtReturnToMCHDate.Attributes.Add("readOnly", "true");
        txtIfDeathDate.Attributes.Add("readOnly", "true");
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        CreatedBy = Session["ID"].ToString();
        try
        {
            if (!IsPostBack)
            {
                txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDate2.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDate3.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDischargeDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtGestationByDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDate4.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtRupturedMembranesDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtDischargeDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtBCGDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtPolioDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtReturnToMCHDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtIfDeathDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        
                //txtTime.Text = DateTime.Now.ToString("hh:mm tt"); 

                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
               // ViewState["PID"] = Request.QueryString["PatientID"].ToString();

                //if (Request.QueryString["App_ID"] != null)
                //{
                //    ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
                //}
                //else
                //{
                //    ViewState["appointmentID"] = "0";
                //}
                if (Request.QueryString["TransactionID"] == null)
                {
                    ViewState["TID"] = Request.QueryString["TID"].ToString();
                    ViewState["PID"] = Request.QueryString["PID"].ToString();
                }
                else
                {
                    ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                    ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                }
                //ViewState["UserID"] = Session["ID"].ToString();
                //if (Request.QueryString["IsViewable"] == null)
                //{
                //    //bool IsDone = Util.GetBoolean(Request.QueryString["IsEdit"]);
                //    string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
                //    string msg = "File Has Been Closed...";
                //    if (IsDone == "1")
                //    {
                //        Response.Redirect("NotAuthorized.aspx?msg=" + msg, false);
                //        Context.ApplicationInstance.CompleteRequest();
                //    }
                //}
                //caldate.EndDate = DateTime.Now;

                BindDetails();
            }

            txtDate.Attributes.Add("readOnly", "true");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected bool Validation()
    {
        try
        {
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }

    private void Clear()
    {
        try
        {
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

            btnUpdate.Visible = false;
            //btnSave.Visible = true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    [WebMethod(EnableSession = true, Description = "Save Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveIntake(object intake, string PID, string TID)
    {
        //string date=intake.Date;
        List<NewBornDetails> adata = new JavaScriptSerializer().ConvertToType<List<NewBornDetails>>(intake);
        //NewBornDetails adata[0] = (NewBornDetails)data;
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string insqry = "INSERT INTO `newborndetails` ("+
  
 " `Date`,  `Time`,  `Alive`,  `FreshStillBirth`,  `MaceratedStillBirth`,  `Single`,  `Twin`, `Triplet`,  `BirthWeight`,  `HC`,  `Length`,  `ApgarScore3`,  `Heart1`,  `Heart2`,  `Heart3`,"+

 " `RespiratoryEffort1`,  `RespiratoryEffort2`,  `RespiratoryEffort3`,  `Muscletone1`,  `Muscletone2`,  `Muscletone3`,  `RefluxResponseToStimulus1`,  `RefluxResponseToStimulus2`,"+
"  `RefluxResponseToStimulus3`,  `Colour1`,  `Colour2`,  `Colour3`,  `TotalScore1`,  `TotalScore2`,  `TotalScore3`,  `MicroniumAspiration`,  `CordAroundNeckx`,  `Other`,  `OtherComment`,"+
"  `Tetracycline`,  `VitK`,  `Resuscitation`,  `O2`,  `Ambu`,  `Intubation`,  `CardiacCompression`,  `Injury`,  `InjurySpecify`,  `CongenitalAbnormalities`,  `CongenitalAbnormalitiesSpecify`,  `RespiratoryDistress`,"+
"  `Other1`,  `Other1Specify`,  `Date1`,  `ToMotherCare`,  `Date2`,  `ToNursary`,  `Date3`,  `Reason`,  `DischargeDate`,  `Days`,  `MotherAge`,  `G`,  `P`,  `Plus`,  `LMP`,  `GestationByDate`,"+
"  `GestationByUIS`,  `NoOfPrenatal`,  `Where`,  `BloodTypeRhesus`,  `Hgb`,  `VRDL`,  `PMCTSerology`,  `pos`,  `neg`,  `refused`,  `PrenatalComplications`,  `preeclampsia1`,  `Eclampsia`,  `OligoHydramnios`,"+
"  `PolyHydramnios`,  `APH1`,  `GestDiabetes`,  `Twins1`,  `Other2`,  `Other2Comment`,  `AbnormalDeliveries`,  `CS`,  `VacuumForceps`,  `Twins`,  `APH`,  `PPH`,  `preeclampsia`,  `stillbirth`,  `preterm`,"+
"  `FirstWeekMortality`,  `NeonatalJaundice`,  `CongeriltalAbnorm`,  `Other3`,  `Other3Comment`,  `Hx`,  `Th`,  `Kidney`,  `HeartDisease`, `Hypertension`,  `Diabetes`,  `Convulsions`,  `Other4`,  `PresentingHxonAdmissionMother`,  `Date4`,"+
"  `Time1`,  `RupturedMembranesDate`,  `Time3`,  `Colour`,  `Comment`,  `NST`,  `Reactive`,  `NonReactive`,  `Comment1`,  `US`,  `OneStage`,  `TwoStage`,  `ThreeStage`,  `TotalHoursOfLabour`,  `VagVtx`,"+
"  `AssistedBreech`,  `PitocinCytotec`,  `Vacuum2`,  `Forceps2`,  `CSElectiveEmergency`,  `Reason1`,  `Dexamethasone`,  `Antibiotics`, `MagSO4`,  `Other5`,  `Other5Comment`,  `RecordedOnRegistrationBook`,"+
"  `NoAckOfBirthNotCompleted`,  `DischargeDate1`,  `DischargeCondition`,  `DischargeWeight`,  `HeadCircumtrence`,  `ChildHealthCardMade`,  `BCGDate`,  `PolioDate`,  `ReturnToMCHDate`,  `IfDeathDate`,"+
"  `DeathTime`,  `CauseOfDeath`,  `AgeAtDeath`,  `ParentGuardian`,  `Witness`,  `HusbandGuardian1`,  `Witness1`,`EntryBy`,TransactionID,PatientID) " + " VALUES  (    '" + Util.GetDateTime(adata[0].Date.Trim()).ToString("yyyy-MM-dd") + "',   '" +
Util.GetDateTime(adata[0].Time).ToString("HH:mm:ss") + "',  '" + adata[0].Alive + "'," +
   "'"+adata[0].FreshStillBirth+"',   '"+adata[0].MaceratedStillBirth+"',   '"+adata[0].Single+"',   '"+adata[0].Twin+"',   '"+adata[0].Triplet+"',   '"+adata[0].BirthWeight+"',   '"+adata[0].HC+"',"+
   "'"+adata[0].Length+"',   '"+adata[0].ApgarScore3+"',   '"+adata[0].Heart1+"',   '"+adata[0].Heart2+"',   '"+adata[0].Heart3+"',   '"+adata[0].RespiratoryEffort1+"',   '"+adata[0].RespiratoryEffort2+"',"+
   "'"+adata[0].RespiratoryEffort3+"',   '"+adata[0].Muscletone1+"',   '"+adata[0].Muscletone2+"',   '"+adata[0].Muscletone3+"',   '"+adata[0].RefluxResponseToStimulus1+"',   '"+adata[0].RefluxResponseToStimulus2+"',"+
   "'"+adata[0].RefluxResponseToStimulus3+"',   '"+adata[0].Colour1+"',   '"+adata[0].Colour2+"',   '"+adata[0].Colour3+"',  '"+adata[0].TotalScore1+"',   '"+adata[0].TotalScore2+"',   '"+adata[0].TotalScore3+"',"+
"   '"+adata[0].MicroniumAspiration+"',   '"+adata[0].CordAroundNeckx+"',   '"+adata[0].Other+"',   '"+adata[0].OtherComment+"',   '"+adata[0].Tetracycline+"',   '"+adata[0].VitK+"',   '"+adata[0].Resuscitation+"',"+
"'"+adata[0].O2+"',   '"+adata[0].Ambu+"',   '"+adata[0].Intubation+"',   '"+adata[0].CardiacCompression+"',   '"+adata[0].Injury+"',   '"+adata[0].InjurySpecify+"',   '"+adata[0].CongenitalAbnormalities+"',"+
"   '" + adata[0].CongenitalAbnormalitiesSpecify + "',   '" + adata[0].RespiratoryDistress + "',   '" + adata[0].Other1 + "',   '" + adata[0].Other1Specify + "',   '" + Util.GetDateTime(adata[0].Date1.Trim()).ToString("yyyy-MM-dd") + "',   '" + adata[0].ToMotherCare + "'," +
"   '" + Util.GetDateTime(adata[0].Date2.Trim()).ToString("yyyy-MM-dd") + "',   '" + adata[0].ToNursary + "',   '" + Util.GetDateTime(adata[0].Date3.Trim()).ToString("yyyy-MM-dd") + "',   '" + adata[0].Reason + "',  '" + Util.GetDateTime(adata[0].DischargeDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + adata[0].Days + "',   '" + adata[0].MotherAge + "',   '" + adata[0].G + "'," +
"   '" + adata[0].P + "',   '" + adata[0].Plus + "',   '" + adata[0].LMP + "',   '" + Util.GetDateTime(adata[0].GestationByDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + adata[0].GestationByUIS + "',   '" + adata[0].NoOfPrenatal + "',   '" + adata[0].Where + "',   '" + adata[0].BloodTypeRhesus + "'," +
"   '"+adata[0].Hgb+"',   '"+adata[0].VRDL+"',   '"+adata[0].PMCTSerology+"',   '"+adata[0].pos+"',   '"+adata[0].neg+"',   '"+adata[0].refused+"',   '"+adata[0].PrenatalComplications+"',   '"+adata[0].preeclampsia1+"',"+
"   '"+adata[0].Eclampsia+"',   '"+adata[0].OligoHydramnios+"',   '"+adata[0].PolyHydramnios+"',  '"+adata[0].APH1+"',   '"+adata[0].GestDiabetes+"',   '"+adata[0].Twins1+"',   '"+adata[0].Other2+"',"+
"   '"+adata[0].Other2Comment+"',   '"+adata[0].AbnormalDeliveries+"',   '"+adata[0].CS+"',   '"+adata[0].VacuumForceps+"',   '"+adata[0].Twins+"',   '"+adata[0].APH+"',   '"+adata[0].PPH+"',   '"+adata[0].preeclampsia+"',"+
"   '"+adata[0].stillbirth+"',   '"+adata[0].preterm+"',   '"+adata[0].FirstWeekMortality+"',   '"+adata[0].NeonatalJaundice+"',   '"+adata[0].CongeriltalAbnorm+"',   '"+adata[0].Other3+"',   '"+adata[0].Other3Comment+"',"+
"   '"+adata[0].Hx+"',   '"+adata[0].Th+"',   '"+adata[0].Kidney+"',   '"+adata[0].HeartDisease+"',   '"+adata[0].Hypertension+"',   '"+adata[0].Diabetes+"',   '"+adata[0].Convulsions+"',   '"+adata[0].Other4+"',"+
"   '" + adata[0].PresentingHxonAdmissionMother + "',   '" + Util.GetDateTime(adata[0].Date4.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(adata[0].Time1).ToString("HH:mm:ss") + "',   '" + Util.GetDateTime(adata[0].RupturedMembranesDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + 
Util.GetDateTime(adata[0].Time3).ToString("HH:mm:ss") + "',   '" + adata[0].Colour + "',   '" + adata[0].Comment + "'," +
"   '"+adata[0].NST+"',   '"+adata[0].Reactive+"',   '"+adata[0].NonReactive+"',   '"+adata[0].Comment1+"',   '"+adata[0].US+"',   '"+adata[0].OneStage+"',   '"+adata[0].TwoStage+"',   '"+adata[0].ThreeStage+"',"+
"   '"+adata[0].TotalHoursOfLabour+"',   '"+adata[0].VagVtx+"',   '"+adata[0].AssistedBreech+"',   '"+adata[0].PitocinCytotec+"',   '"+adata[0].Vacuum2+"',   '"+adata[0].Forceps2+"',   '"+adata[0].CSElectiveEmergency+"',"+
"'"+adata[0].Reason1+"',   '"+adata[0].Dexamethasone+"',   '"+adata[0].Antibiotics+"',   '"+adata[0].MagSO4+"',   '"+adata[0].Other5+"',   '"+adata[0].Other5Comment+"',   '"+adata[0].RecordedOnRegistrationBook+"',"+
"   '" + adata[0].NoAckOfBirthNotCompleted + "',   '" + Util.GetDateTime(adata[0].DischargeDate1.Trim()).ToString("yyyy-MM-dd") + "',   '" + adata[0].DischargeCondition + "',   '" + adata[0].DischargeWeight + "',   '" + adata[0].HeadCircumtrence + "',   '" + adata[0].ChildHealthCardMade + "'," +
"   '" + Util.GetDateTime(adata[0].BCGDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(adata[0].PolioDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(adata[0].ReturnToMCHDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(adata[0].IfDeathDate.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(adata[0].Time1).ToString("HH:mm:ss") + "',   '" + adata[0].CauseOfDeath + "',   '" + adata[0].AgeAtDeath + "'," +
"'" + adata[0].ParentGuardian + "',   '" + adata[0].Witness + "',   '" + adata[0].HusbandGuardian1 + "',   '" + adata[0].Witness1 + "',    '" + HttpContext.Current.Session["ID"].ToString() + "' ,'" + TID + "' ,'" + PID + "' );";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, insqry);
                    
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
          }
    [WebMethod(EnableSession = true, Description = "Update Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string updateIntake(object intake, string PID, string TID)
    {
        //string date=intake.Date;
        List<NewBornDetails> adata = new JavaScriptSerializer().ConvertToType<List<NewBornDetails>>(intake);
        //NewBornDetails adata[0] = (NewBornDetails)data;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string insqry = "update `newborndetails` set " +

"  `Date`= '" + Util.GetDateTime(adata[0].Date.Trim()).ToString("yyyy-MM-dd") + "',  `Time`=   '" +
Util.GetDateTime(adata[0].Time).ToString("HH:mm:ss") + "', `Alive`= '" + adata[0].Alive + "',`FreshStillBirth`=" +
"'" + adata[0].FreshStillBirth + "', `MaceratedStillBirth`=  '" + adata[0].MaceratedStillBirth + "',  `Single`=  '" + adata[0].Single + "',  `Twin`= '" + adata[0].Twin + "',`Triplet`=   '" + adata[0].Triplet + "', `BirthWeight`=  '" +
adata[0].BirthWeight + "',  `HC`=  '" + adata[0].HC + "',`Length`=" +
"'" + adata[0].Length + "',  `ApgarScore3`= '" + adata[0].ApgarScore3 + "', `Heart1`=  '" + adata[0].Heart1 + "',`Heart2`=   '" + adata[0].Heart2 + "',  `Heart3`= '" + adata[0].Heart3 +
"',  `RespiratoryEffort1`= '" + adata[0].RespiratoryEffort1 + "',`RespiratoryEffort2`=   '" + adata[0].RespiratoryEffort2 + "', `RespiratoryEffort3`=" +
"'" + adata[0].RespiratoryEffort3 + "', `Muscletone1`=  '" + adata[0].Muscletone1 + "',  `Muscletone2`=  '" + adata[0].Muscletone2 + "', `Muscletone3`=  '" + adata[0].Muscletone3 +
"',   `RefluxResponseToStimulus1`= '" + adata[0].RefluxResponseToStimulus1 + "',  `RefluxResponseToStimulus2`=  '" + adata[0].RefluxResponseToStimulus2 + "',`RefluxResponseToStimulus3`=" +
"'" + adata[0].RefluxResponseToStimulus3 + "', `Colour1`=  '" + adata[0].Colour1 + "', `Colour2`=  '" + adata[0].Colour2 + "',  `Colour3`=  '" + adata[0].Colour3 + "', `TotalScore2`= '" + adata[0].TotalScore1 +
"', `TotalScore2`=  '" + adata[0].TotalScore2 + "', `TotalScore3`=  '" + adata[0].TotalScore3 + "'," +
"  `MicroniumAspiration`=  '" + adata[0].MicroniumAspiration + "',  `CordAroundNeckx`=  '" + adata[0].CordAroundNeckx + "', `Other`=  '" + adata[0].Other + "', `OtherComment`=  '" +
adata[0].OtherComment + "', `Tetracycline`=  '" + adata[0].Tetracycline + "', `VitK`=  '" + adata[0].VitK + "', `Resuscitation`=  '" + adata[0].Resuscitation + "',`O2`=" +
"'" + adata[0].O2 + "',  `Ambu`= '" + adata[0].Ambu + "', `Intubation`=  '" + adata[0].Intubation + "',`CardiacCompression`=   '" + adata[0].CardiacCompression + "',  `Injury`=  '" +
adata[0].Injury + "', `InjurySpecify`=  '" + adata[0].InjurySpecify + "',  `CongenitalAbnormalities`=  '" + adata[0].CongenitalAbnormalities + "',`CongenitalAbnormalitiesSpecify`=" +
"   '" + adata[0].CongenitalAbnormalitiesSpecify + "', `RespiratoryDistress`=  '" + adata[0].RespiratoryDistress + "', `Other1`=  '" + adata[0].Other1 + "',  `Other1Specify`= '" + adata[0].Other1Specify +
"',  `Date1`=  '" + Util.GetDateTime(adata[0].Date1.Trim()).ToString("yyyy-MM-dd") + "', `ToMotherCare`=  '" + adata[0].ToMotherCare + "', `Date2`=" +
"   '" + Util.GetDateTime(adata[0].Date2.Trim()).ToString("yyyy-MM-dd") + "',  `ToNursary`= '" + adata[0].ToNursary + "',   `Date3`= '" +
Util.GetDateTime(adata[0].Date3.Trim()).ToString("yyyy-MM-dd") + "',  `Reason`= '" + adata[0].Reason + "', `DischargeDate`= '" + Util.GetDateTime(adata[0].DischargeDate.Trim()).ToString("yyyy-MM-dd") +
"',   `Days`= '" + adata[0].Days + "', `MotherAge`=  '" + adata[0].MotherAge + "', `G`=  '" + adata[0].G + "'," +
" `P`=  '" + adata[0].P + "', `Plus`=  '" + adata[0].Plus + "', `LMP`=  '" + adata[0].LMP + "', `GestationByDate`=  '" + Util.GetDateTime(adata[0].GestationByDate.Trim()).ToString("yyyy-MM-dd") +
"', `GestationByUIS`=  '" + adata[0].GestationByUIS + "',  `NoOfPrenatal`=  '" + adata[0].NoOfPrenatal + "',  `Where`=  '" + adata[0].Where + "',  `BloodTypeRhesus`=  '" + adata[0].BloodTypeRhesus + "'," +
" `Hgb`=  '" + adata[0].Hgb + "', `VRDL`=  '" + adata[0].VRDL + "', `PMCTSerology`=  '" + adata[0].PMCTSerology + "', `pos`=  '" + adata[0].pos + "',`neg`=   '" + adata[0].neg + "', `refused`=  '" +
adata[0].refused + "', `PrenatalComplications`=  '" + adata[0].PrenatalComplications + "', `preeclampsia1`=  '" + adata[0].preeclampsia1 + "'," +
"  `Eclampsia`=  '" + adata[0].Eclampsia + "',  `OligoHydramnios`=  '" + adata[0].OligoHydramnios + "',`PolyHydramnios`=   '" + adata[0].PolyHydramnios + "', `APH1`=  '" +
adata[0].APH1 + "', `GestDiabetes`=  '" + adata[0].GestDiabetes + "', `Twins1`=  '" + adata[0].Twins1 + "',  `Other2`=  '" + adata[0].Other2 + "'," +
"  `Other2Comment`= '" + adata[0].Other2Comment + "', `AbnormalDeliveries`=  '" + adata[0].AbnormalDeliveries + "',`CS`=   '" + adata[0].CS + "', `VacuumForceps`=  '" + adata[0].VacuumForceps +
"',   `Twins`= '" + adata[0].Twins + "',  `APH`= '" + adata[0].APH + "',  `PPH`= '" + adata[0].PPH + "', `preeclampsia`=  '" + adata[0].preeclampsia + "'," +
"   `stillbirth`= '" + adata[0].stillbirth + "',  `preterm`=  '" + adata[0].preterm + "', `FirstWeekMortality`=  '" + adata[0].FirstWeekMortality + "', `NeonatalJaundice`=  '" +
adata[0].NeonatalJaundice + "',   `CongeriltalAbnorm`= '" + adata[0].CongeriltalAbnorm + "',  `Other3`= '" + adata[0].Other3 + "', `Other3Comment`=  '" + adata[0].Other3Comment + "'," +
" `Hx`=  '" + adata[0].Hx + "', `Th`=  '" + adata[0].Th + "',  `Kidney`=  '" + adata[0].Kidney + "', `HeartDisease`=  '" + adata[0].HeartDisease + "', `Hypertension`=  '" +
adata[0].Hypertension + "',  `Diabetes`= '" + adata[0].Diabetes + "',  `Convulsions`= '" + adata[0].Convulsions + "', `Other4`=  '" + adata[0].Other4 + "'," +
" `PresentingHxonAdmissionMother`=  '" + adata[0].PresentingHxonAdmissionMother + "', `Date4`=  '" + Util.GetDateTime(adata[0].Date4.Trim()).ToString("yyyy-MM-dd") +
"', `Time1`=  '" + Util.GetDateTime(adata[0].Time1).ToString("HH:mm:ss") + "', `RupturedMembranesDate`=  '" + Util.GetDateTime(adata[0].RupturedMembranesDate.Trim()).ToString("yyyy-MM-dd") + "', `Time3`=  '" +
Util.GetDateTime(adata[0].Time3).ToString("HH:mm:ss") + "', `Colour`=  '" + adata[0].Colour + "', `Comment`=  '" + adata[0].Comment + "'," +
"  `NST`= '" + adata[0].NST + "',  `Reactive`=  '" + adata[0].Reactive + "', `NonReactive`=  '" + adata[0].NonReactive + "',  `Comment1`=   '" + adata[0].Comment1 + "',  `US`=   '" + adata[0].US + "', `OneStage`=  '" +
adata[0].OneStage + "',   `TwoStage`=  '" + adata[0].TwoStage + "',  `ThreeStage`=   '" + adata[0].ThreeStage + "'," +
"  `TotalHoursOfLabour`= '" + adata[0].TotalHoursOfLabour + "', `VagVtx`=  '" + adata[0].VagVtx + "',  `AssistedBreech`=  '" + adata[0].AssistedBreech + "', `PitocinCytotec`=   '" +
adata[0].PitocinCytotec + "',  `Vacuum2`=   '" + adata[0].Vacuum2 + "',  `Forceps2`=   '" + adata[0].Forceps2 + "',  `CSElectiveEmergency`=   '" + adata[0].CSElectiveEmergency + "'," +
"  `Reason1`='" + adata[0].Reason1 + "',  `Dexamethasone`=   '" + adata[0].Dexamethasone + "',    `Antibiotics`=  '" + adata[0].Antibiotics + "', `MagSO4`=   '" + adata[0].MagSO4 + "',    `Other5`= '" +
adata[0].Other5 + "',`Other5Comment`=   '" + adata[0].Other5Comment + "',  `RecordedOnRegistrationBook`= '" + adata[0].RecordedOnRegistrationBook + "'," +
" `NoAckOfBirthNotCompleted`=  '" + adata[0].NoAckOfBirthNotCompleted + "', `DischargeDate1`=  '" + Util.GetDateTime(adata[0].DischargeDate1.Trim()).ToString("yyyy-MM-dd") +
"',`DischargeCondition`=   '" + adata[0].DischargeCondition + "', `DischargeWeight`=   '" + adata[0].DischargeWeight + "',`HeadCircumtrence`=   '" + adata[0].HeadCircumtrence +
"', `ChildHealthCardMade`=  '" + adata[0].ChildHealthCardMade + "'," +
"`BCGDate`=   '" + Util.GetDateTime(adata[0].BCGDate.Trim()).ToString("yyyy-MM-dd") + "', `PolioDate`=  '" + Util.GetDateTime(adata[0].PolioDate.Trim()).ToString("yyyy-MM-dd") +
"',`ReturnToMCHDate`=   '" + Util.GetDateTime(adata[0].ReturnToMCHDate.Trim()).ToString("yyyy-MM-dd") + "', `IfDeathDate`=  '" + Util.GetDateTime(adata[0].IfDeathDate.Trim()).ToString("yyyy-MM-dd") +
"',`DeathTime`=   '" + Util.GetDateTime(adata[0].Time1).ToString("HH:mm:ss") + "',  `CauseOfDeath`= '" + adata[0].CauseOfDeath + "', `AgeAtDeath`=  '" + adata[0].AgeAtDeath + "'," +
"`ParentGuardian`='" + adata[0].ParentGuardian + "', `Witness`=  '" + adata[0].Witness + "',`HusbandGuardian1`=   '" + adata[0].HusbandGuardian1 + "',`Witness1`=   '" + adata[0].Witness1 + "'"+
" where Id='" + PID+ "'";
         int result=   MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, insqry);

            tranX.Commit();
           
            return result+"";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}
public class NewBornDetails
{
    public string CreatedBy { get; set; }
    public string Id { get; set; }
    public string Date { get; set; }
    public string Time { get; set; }
    public string Alive { get; set; }
    public string FreshStillBirth { get; set; }
    public string MaceratedStillBirth { get; set; }
    public string Single { get; set; }
    public string Twin { get; set; }
    public string Triplet { get; set; }
    public string BirthWeight { get; set; }
    public string HC { get; set; }
    public string Length { get; set; }
    public string ApgarScore3 { get; set; }
    public string Heart1 { get; set; }
    public string Heart2 { get; set; }
    public string Heart3 { get; set; }
    public string RespiratoryEffort1 { get; set; }
    public string RespiratoryEffort2 { get; set; }
    public string RespiratoryEffort3 { get; set; }
    public string Muscletone1 { get; set; }
    public string Muscletone2 { get; set; }
    public string Muscletone3 { get; set; }
    public string RefluxResponseToStimulus1 { get; set; }
    public string RefluxResponseToStimulus2 { get; set; }
    public string RefluxResponseToStimulus3 { get; set; }
    public string Colour1 { get; set; }
    public string Colour2 { get; set; }
    public string Colour3 { get; set; }
    public string TotalScore1 { get; set; }
    public string TotalScore2 { get; set; }
    public string TotalScore3 { get; set; }
    public string MicroniumAspiration { get; set; }
    public string CordAroundNeckx { get; set; }
    public string Other { get; set; }
    public string OtherComment { get; set; }
    public string Tetracycline { get; set; }
    public string VitK { get; set; }
    public string Resuscitation { get; set; }
    public string O2 { get; set; }
    public string Ambu { get; set; }
    public string Intubation { get; set; }
    public string CardiacCompression { get; set; }
    public string Injury { get; set; }
    public string InjurySpecify { get; set; }
    public string CongenitalAbnormalities { get; set; }
    public string CongenitalAbnormalitiesSpecify { get; set; }
    public string RespiratoryDistress { get; set; }
    public string Other1 { get; set; }
    public string Other1Specify { get; set; }
    public string Date1 { get; set; }
    public string ToMotherCare { get; set; }
    public string Date2 { get; set; }
    public string ToNursary { get; set; }
    public string Date3 { get; set; }
    public string Reason { get; set; }
    public string DischargeDate { get; set; }
    public string Days { get; set; }
    public string MotherAge { get; set; }
    public string G { get; set; }
    public string P { get; set; }
    public string Plus { get; set; }
    public string LMP { get; set; }
    public string GestationByDate { get; set; }
    public string GestationByUIS { get; set; }
    public string NoOfPrenatal { get; set; }
    public string Where { get; set; }
    public string BloodTypeRhesus { get; set; }
    public string Hgb { get; set; }
    public string VRDL { get; set; }
    public string PMCTSerology { get; set; }
    public string pos { get; set; }
    public string neg { get; set; }
    public string refused { get; set; }
    public string PrenatalComplications { get; set; }
    public string preeclampsia1 { get; set; }
    public string Eclampsia { get; set; }
    public string OligoHydramnios { get; set; }
    public string PolyHydramnios { get; set; }
    public string APH1 { get; set; }
    public string GestDiabetes { get; set; }
    public string Twins1 { get; set; }
    public string Other2 { get; set; }
    public string Other2Comment { get; set; }
    public string AbnormalDeliveries { get; set; }
    public string CS { get; set; }
    public string VacuumForceps { get; set; }
    public string Twins { get; set; }
    public string APH { get; set; }
    public string PPH { get; set; }
    public string preeclampsia { get; set; }
    public string stillbirth { get; set; }
    public string preterm { get; set; }
    public string FirstWeekMortality { get; set; }
    public string NeonatalJaundice { get; set; }
    public string CongeriltalAbnorm { get; set; }
    public string Other3 { get; set; }
    public string Other3Comment { get; set; }
    public string Hx { get; set; }
    public string Th { get; set; }
    public string Kidney { get; set; }
    public string HeartDisease { get; set; }
    public string Hypertension { get; set; }
    public string Diabetes { get; set; }
    public string Convulsions { get; set; }
    public string Other4 { get; set; }
    public string PresentingHxonAdmissionMother { get; set; }
    public string Date4 { get; set; }
    public string Time1 { get; set; }
    public string RupturedMembranesDate { get; set; }
    public string Time3 { get; set; }
    public string Colour { get; set; }
    public string Comment { get; set; }
    public string NST { get; set; }
    public string Reactive { get; set; }
    public string NonReactive { get; set; }
    public string Comment1 { get; set; }
    public string US { get; set; }
    public string OneStage { get; set; }
    public string TwoStage { get; set; }
    public string ThreeStage { get; set; }
    public string TotalHoursOfLabour { get; set; }
    public string VagVtx { get; set; }
    public string AssistedBreech { get; set; }
    public string PitocinCytotec { get; set; }
    public string Vacuum2 { get; set; }
    public string Forceps2 { get; set; }
    public string CSElectiveEmergency { get; set; }
    public string Reason1 { get; set; }
    public string Dexamethasone { get; set; }
    public string Antibiotics { get; set; }
    public string MagSO4 { get; set; }
    public string Other5 { get; set; }
    public string Other5Comment { get; set; }
    public string RecordedOnRegistrationBook { get; set; }
    public string NoAckOfBirthNotCompleted { get; set; }
    public string DischargeDate1 { get; set; }
    public string DischargeCondition { get; set; }
    public string DischargeWeight { get; set; }
    public string HeadCircumtrence { get; set; }
    public string ChildHealthCardMade { get; set; }
    public string BCGDate { get; set; }
    public string PolioDate { get; set; }
    public string ReturnToMCHDate { get; set; }
    public string IfDeathDate { get; set; }
    public string DeathTime { get; set; }
    public string CauseOfDeath { get; set; }
    public string AgeAtDeath { get; set; }
    public string ParentGuardian { get; set; }
    public string Witness { get; set; }
    public string HusbandGuardian1 { get; set; }
    public string Witness1 { get; set; }
}