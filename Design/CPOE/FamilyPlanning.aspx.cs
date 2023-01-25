
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;

using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;

public partial class Design_CPOE_FamilyPlanning : System.Web.UI.Page
{
    public void BindDetails(string PID,string TID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master em where em.EmployeeID=fp.CreatedBy)EmpName,DATE_FORMAT(DateOfLastDelivery, '%d %b %Y') as DateOfLastDelivery1,DATE_FORMAT(IUCDExpiryDate, '%d %b %Y') as IUCDExpiryDate1"+
                ",DATE_FORMAT(ImplantExpiryDate, '%d %b %Y') as ImplantExpiryDate1,DATE_FORMAT(ImplantExpiryDate, '%d %b %Y') as ImplantExpiryDate1,DATE_FORMAT(InjectionExpiryDate, '%d %b %Y') as InjectionExpiryDate1" +
            ",DATE_FORMAT(ECPsExpiryDate, '%d %b %Y') as ECPsExpiryDate1,DATE_FORMAT(PillExpiryDate, '%d %b %Y') as PillExpiryDate1,DATE_FORMAT(CondomsExpiryDate, '%d %b %Y') as CondomsExpiryDate1" +
            ",DATE_FORMAT(ReturnDate, '%d %b %Y') as ReturnDate1" +
            ",DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff  from familyplanning fp where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            string date1 = Util.GetDateTime(txtDateOfLastDelivery.Text).ToString("yyyy-MM-dd");
            string IUCDExpiryDate = Util.GetDateTime(txtIUCDExpiryDate.Text).ToString("yyyy-MM-dd");
            string ImplantExpiryDate = Util.GetDateTime(txtImplantExpiryDate.Text).ToString("yyyy-MM-dd");
            string InjectionExpiryDate = Util.GetDateTime(txtInjectionExpiryDate.Text).ToString("yyyy-MM-dd");
            string PillExpiryDate = Util.GetDateTime(txtPillExpiryDate.Text).ToString("yyyy-MM-dd");
            string CondomsExpiryDate = Util.GetDateTime(txtCondomsExpiryDate.Text).ToString("yyyy-MM-dd");
            string ECPsExpiryDate = Util.GetDateTime(txtECPsExpiryDate.Text).ToString("yyyy-MM-dd");
            string ReturnDate = Util.GetDateTime(txtReturnDate.Text).ToString("yyyy-MM-dd");
            
            
            
            var sqlCMD = "INSERT INTO familyplanning ("+
  
"  `Date`,  `Time`,  `ServiceArea`,  `Highest`,  `MaritalStatus`,  `LMP`,  `Regular`,  `BleedingDays`,  `IsCurrent`,  `Current`,  `IsPregnant`,  `Pregnant`,  `IsBreastFeeding`,  `NoOfDesiredChildren`,"+
"  `Parity`,  `NoLiving`,  `NoDead`,  `DateOfLastDelivery`,  `Mode`,  `IsCurrentMedication`,  `CurrentMedication`,  `IsOperations`,  `Operations`,  `Smoking1`,  `Smoking2`,  `Hypertension1`,"+
"  `Hypertension2`,  `Alcohol1`,  `Alcohol2`,  `Dibetes1`,  `Dibetes2`,  `Jaundice1`,  `Jaundice2`,  `Cardiac1`,  `Cardiac2`,  `HIV1`,  `HIV2`,  `Goitre1`,  `Goitre2`,  `Cancer1`,  `Cancer2`,"+
"  `Tuberculosis1`,  `Tuberculosis2`,  `Varicos1`,  `Varicos2`,  `DVT1`,  `DVT2`,  `STI1`,  `STI2`,  `Epilepsy1`,  `Epilepsy2`,  `PID1`,  `PID2`,  `Uterine1`,  `Uterine2`,  `Other1`,  `Other2`,"+
"  `Migraine1`,  `Migraine2`,  `Issurgery`,  `Surgery`,  `CreatedBy`,  `CreatedDate`,  `PatientID`,  `TransactionID`,  IUCDType,  IUCDBatch,  IUCDExpiryDate,  ImplantType,  ImplantBatch,"+
"  ImplantExpiryDate,  PermanentType,  PermanentLAM,  InjectionType,  InjectionBatch,  InjectionExpiryDate,  PillType,  PillNoOfCycles,  PillBatch,  PillExpiryDate,  CondomsType,  CondomsNoIssued,"+
"  CondomsBatch,  CondomsExpiryDate,  ECPsBatch,  ECPsExpiryDate,  ECPsDual,  OthersSpecify,  None,  Reason,  HTC,  HTCResults,  CA, MethodUsed,  Results,  STI,  STIResults,  STIProstat,"+
"  STI3,  Referral,  ReferralReason,  Summary,  ServiceProvider, ReturnDate,  Breast,  Breast1,  Abdomen,  Abdomen1,  External,  External1,  Veginal,  Veginal1,  Cervix,  Cervix1,  Uterus,"+
"  Uterus1,  Adnexae,  Adnexae1,  OtherSpecify,  OtherSpecify1, Disability, Disability1,Dual1)"+

" VALUES  (       @Date,    @Time,    @ServiceArea,    @Highest,    @MaritalStatus,    @LMP,    @Regular,    @BleedingDays,    @IsCurrent,    @Current,    @IsPregnant,    @Pregnant,"+
"    @IsBreastFeeding,    @NoOfDesiredChildren,    @Parity,    @NoLiving,    @NoDead,    @DateOfLastDelivery,    @Mode,    @IsCurrentMedication,    @CurrentMedication,    @IsOperations,"+
"    @Operations,    @Smoking1,    @Smoking2,    @Hypertension1,   @Hypertension2,    @Alcohol1,    @Alcohol2,    @Dibetes1,    @Dibetes2,    @Jaundice1,    @Jaundice2,    @Cardiac1,"+
"@Cardiac2,    @HIV1,    @HIV2,    @Goitre1,    @Goitre2,    @Cancer1,    @Cancer2,    @Tuberculosis1,    @Tuberculosis2,    @Varicos1,    @Varicos2,    @DVT1,    @DVT2,    @STI1,"+
"    @STI2,    @Epilepsy1,    @Epilepsy2,    @PID1,    @PID2,    @Uterine1,    @Uterine2,   @Other1,    @Other2,    @Migraine1,    @Migraine2,    @Issurgery,    @Surgery,    @CreatedBy,"+
"    NOW(),    @PatientID,    @TransactionID,    @IUCDType,    @IUCDBatch,    @IUCDExpiryDate,    @ImplantType,    @ImplantBatch,    @ImplantExpiryDate,    @PermanentType,    @PermanentLAM,"+
"    @InjectionType,    @InjectionBatch,    @InjectionExpiryDate,    @PillType,    @PillNoOfCycles,    @PillBatch,    @PillExpiryDate,    @CondomsType,    @CondomsNoIssued,    @CondomsBatch,"+
"    @CondomsExpiryDate,    @ECPsBatch,    @ECPsExpiryDate,    @ECPsDual,    @OthersSpecify,    @None,    @Reason,    @HTC,    @HTCResults,    @CA,    @MethodUsed,    @Results,    @STI,"+
"    @STIResults,    @STIProstat,   @STI3,    @Referral,    @ReferralReason,    @Summary,    @ServiceProvider,    @ReturnDate,    @Breast,    @Breast1,    @Abdomen,    @Abdomen1,    @External,"+
"    @External1,    @Veginal,    @Veginal1,    @Cervix,    @Cervix1,    @Uterus,    @Uterus1,    @Adnexae,    @Adnexae1,    @OtherSpecify,    @OtherSpecify1,    @Disability,    @Disability1 ,@Dual1 );";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Date = date,
                Time = time,
                ServiceArea = txtServiceArea.Text,
                Highest = txtHighestEducationLevel.Text,
                MaritalStatus = "",
                LMP = txtLMP.Text,
                Regular = txtRegular.Text,
                BleedingDays = txtNoOfBleedingDays.Text,
                IsCurrent = rdbCurrentFPMethod.SelectedValue,
                Current = txtCurrentFPMethod.Text,
                IsPregnant = rdbPregnant.SelectedValue,
                Pregnant = txtPregnant.Text,
                IsBreastFeeding = rdbIsBreastFeeding.SelectedValue,
                NoOfDesiredChildren = txtNoOfDesiredChildren.Text,
                Parity = txtParity.Text,
                NoLiving = txtNoLiving.Text,
                NoDead = txtNoDead.Text,
                DateOfLastDelivery = date1,
                Mode = txtMode.Text,
                IsCurrentMedication = rdbCurrentMedication.SelectedValue,
                CurrentMedication = txtCurrentMedicationSpecify.Text,
                IsOperations = rdbSurgicalHistory.SelectedValue,
                Operations = txtSurgicalHistory.Text,
                Smoking1 = rdbSmoking1.SelectedValue,
                Smoking2 = rdbSmoking2.SelectedValue,
                Hypertension1 = rdbHypertension1.SelectedValue,
                Hypertension2 = rdbHypertension2.SelectedValue,
                Alcohol1 = rdbAlcohol1.SelectedValue,
                Alcohol2 = rdbAlcohol1.SelectedValue,
                Dibetes1 = rdbDibetes1.SelectedValue,
                Dibetes2 = rdbDibetes2.SelectedValue,
                Jaundice1 = rdbJaundice1.SelectedValue,
                Jaundice2 = rdbJaundice2.SelectedValue,
                Cardiac1 = rdbCardiac1.SelectedValue,
                Cardiac2 = rdbCardiac2.SelectedValue,

                HIV1 = rdbHIV1.SelectedValue,
                HIV2 = rdbHIV2.SelectedValue,
                Goitre1 = rdbGoitre1.SelectedValue,
                Goitre2 = rdbGoitre2.SelectedValue,
                Cancer1 = rdbRTCancer1.SelectedValue,
                Cancer2 = rdbRTCancer2.SelectedValue,
                Tuberculosis1 = rdbTuberculosis1.SelectedValue,
                Tuberculosis2 = rdbTuberculosis2.SelectedValue,
                Varicos1 = rdbVaricos1.SelectedValue,
                Varicos2 = rdbVaricos1.SelectedValue,
                DVT1 = rdbDVT1.SelectedValue,
                DVT2 = rdbDVT2.SelectedValue,
                STI1 = rdbSTI1.SelectedValue,
                STI2 = rdbSTI2.SelectedValue,
                Epilepsy1 = rdbEpilepsi1.SelectedValue,
                Epilepsy2 = rdbEpilepsi2.SelectedValue,
                PID1 = rdbPID1.SelectedValue,
                PID2 = rdbPID2.SelectedValue,
                Uterine1 = rdbUterine1.SelectedValue,
                Uterine2 = rdbUterine2.SelectedValue,
                Other1 = rdbOther1.SelectedValue,
                Other2 = rdbOther2.SelectedValue,
                Migraine1 = rdbMigraine1.SelectedValue,
                Migraine2 = rdbMigraine2.SelectedValue,
                Issurgery = rdbSurgery.SelectedValue,
                Surgery = txtSuergerySpecify.Text,
                CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                PatientID = ViewState["PID"].ToString(),
                TransactionID = ViewState["TID"].ToString(),
                IUCDType=txtIUCDType.Text,
                IUCDBatch=txtIUCDBatch.Text,
                IUCDExpiryDate=IUCDExpiryDate,
                ImplantType=txtImplantType.Text,
                ImplantBatch=txtImplantBatch.Text,
                ImplantExpiryDate=ImplantExpiryDate,
                PermanentType=txtPermanentType.Text,
                PermanentLAM=txtPermanentLAM.Text,
                InjectionType=txtInjectionType.Text,
                InjectionBatch=txtInjectionBatch.Text,
                InjectionExpiryDate=InjectionExpiryDate,
                PillType=txtPillType.Text,
                PillNoOfCycles=txtPillNoOfCycles.Text,
                PillBatch=txtPillBatch.Text,
                PillExpiryDate=PillExpiryDate,
                CondomsType=txtCondomsType.Text,
                CondomsNoIssued=txtCondomsNoIssued.Text,
                CondomsBatch=txtCondomsBatch.Text,
                CondomsExpiryDate=CondomsExpiryDate,
                ECPsBatch=txtECPsBatch.Text,
                ECPsExpiryDate=ECPsExpiryDate,
                ECPsDual = rdbDual.SelectedValue,
                OthersSpecify=txtOthersSpecify.Text,
                None=txtNone.Text,
                Reason=txtReason.Text,
                HTC=rdbHTC.SelectedValue,
                HTCResults=txtHTCResults.Text,
                CA=rdbCA.SelectedValue,
                MethodUsed=txtMethodUsed.Text,
                Results=txtResults.Text,
                STI=rdbSTI.SelectedValue,
                STIResults=txtSTIResults.Text,
                STIProstat=rdbSTIProstat.SelectedValue,
                STI3=txtSTI.Text,
                Referral=rdbReferral.SelectedValue,
                ReferralReason=txtReferralReason.Text,
                Summary=txtSummary.Text,
                ServiceProvider=txtServiceProvider.Text,
                ReturnDate=ReturnDate,
                Breast=rdbBreast.SelectedValue,
                Breast1=txtBreast1.Text,
                Abdomen=rdbAbdomen.SelectedValue,
                Abdomen1=txtAbdomen1.Text,
                External=rdbExternal.SelectedValue,
                External1=txtExternal1.Text,
                Veginal = rdbVeginal.SelectedValue,
                Veginal1 = txtVeginal1.Text,
                Cervix = rdbCervix.SelectedValue,
                Cervix1 = txtCervix1.Text,
                Uterus = rdbUterus.SelectedValue,
                Uterus1 = txtUterus1.Text,
                Adnexae = rdbAdnexae.SelectedValue,
                Adnexae1 = txtAdnexae1.Text,
                OtherSpecify = rdbOtherSystems.SelectedValue,
                OtherSpecify1 = txtOtherSystems1.Text,
                Disability = rdbDisability.SelectedValue,
                Disability1 = txtDisability1.Text,
                Dual1=txtDual1.Text

                
            });
            message = "Record Save Sucessfully";
            Clear();

            tnx.Commit();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " modelAlert('"+message+"',function(){});", true);

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact Administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    private void FillClientDetails(string PID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select *,DATE_FORMAT(DOB, '%d %b %Y') as DOB1 from patient_master where PatientID='" + PID + "' order by DateEnrolled desc");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["PName"].ToString() != "")
            {
                lblFacilityName.Text = dt.Rows[0]["PName"].ToString();
                lblClientFullName.Text = dt.Rows[0]["PName"].ToString();
            }

            if (dt.Rows[0]["DOB"].ToString() != "")
            {
                lblDOB.Text = dt.Rows[0]["DOB1"].ToString();
            }
            if (dt.Rows[0]["Age"].ToString() != "")
            {
                lblAge.Text = dt.Rows[0]["Age"].ToString();
            }
            if (dt.Rows[0]["Gender"].ToString() != "")
            {
                lblSex.Text = dt.Rows[0]["Gender"].ToString();
            }
            if (dt.Rows[0]["MaritalStatus"].ToString() != "")
            {
                lblMaritalStatus.Text = dt.Rows[0]["MaritalStatus"].ToString();
            }
            if(dt.Rows[0]["State"].ToString() != "")
            {
                lblCounty.Text = dt.Rows[0]["State"].ToString();
            }

            if (dt.Rows[0]["District"].ToString() != "")
            {
                lblSubCounty.Text = dt.Rows[0]["District"].ToString();
            }
            if (dt.Rows[0]["Mobile"].ToString() != "")
            {
                lblClientContactNo.Text = dt.Rows[0]["Mobile"].ToString();
            }
            if (dt.Rows[0]["Email"].ToString() != "")
            {
               lblEmail.Text = dt.Rows[0]["Email"].ToString();
            }
            if (dt.Rows[0]["Pincode"].ToString() != "")
            {
                lblPhysicalAddress.Text = dt.Rows[0]["House_No"].ToString() + " " + dt.Rows[0]["Street_Name"].ToString() + " " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
        }
        string encounterno = StockReports.ExecuteScalar(" SELECT EncounterNo FROM `f_ledgertransaction` WHERE LedgertransactionNo='"+TID+"' ");
        lblEncounterNo.Text = encounterno;
                   

    
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";

            string DateOfLastDelivery = Util.GetDateTime(txtDateOfLastDelivery.Text).ToString("yyyy-MM-dd");
            string IUCDExpiryDate = Util.GetDateTime(txtIUCDExpiryDate.Text).ToString("yyyy-MM-dd");
            string ImplantExpiryDate = Util.GetDateTime(txtImplantExpiryDate.Text).ToString("yyyy-MM-dd");
            string InjectionExpiryDate = Util.GetDateTime(txtInjectionExpiryDate.Text).ToString("yyyy-MM-dd");
            string PillExpiryDate = Util.GetDateTime(txtPillExpiryDate.Text).ToString("yyyy-MM-dd");
            string CondomsExpiryDate = Util.GetDateTime(txtCondomsExpiryDate.Text).ToString("yyyy-MM-dd");
            string ECPsExpiryDate = Util.GetDateTime(txtECPsExpiryDate.Text).ToString("yyyy-MM-dd");
            string ReturnDate = Util.GetDateTime(txtReturnDate.Text).ToString("yyyy-MM-dd");
            
            
            
            //string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");

            var sqlCMD = "UPDATE familyplanning SET UpdateDate=NOW(),UpdatedBy=@UpdatedBy," +
                "ServiceArea=@ServiceArea,Highest=@Highest,LMP=@LMP,Regular=@Regular,BleedingDays=@BleedingDays,IsCurrent=@IsCurrent,Current=@Current," +
                "IsPregnant=@IsPregnant,Pregnant=@Pregnant,IsBreastFeeding=@IsBreastFeeding,NoOfDesiredChildren=@NoOfDesiredChildren,Parity=@Parity,NoLiving=@NoLiving,NoDead=@NoDead,DateOfLastDelivery=@DateOfLastDelivery," +
                
                     "Mode=@Mode,IsCurrentMedication=@IsCurrentMedication,CurrentMedication=@CurrentMedication,IsOperations=@IsOperations,Operations=@Operations,Smoking1=@Smoking1,Smoking2=@Smoking2,Hypertension1=@Hypertension1," +
               "Hypertension2=@Hypertension2,Alcohol1=@Alcohol1,Alcohol2=@Alcohol2,Dibetes1=@Dibetes1,Dibetes2=@Dibetes2,Jaundice1=@Jaundice1,Jaundice2=@Jaundice2,Cardiac1=@Cardiac1," +
               "Cardiac2=@Cardiac2,HIV1=@HIV1,HIV2=@HIV2,Goitre1=@Goitre1,Goitre2=@Goitre2,Cancer1=@Cancer1,Cancer2=@Cancer2,Tuberculosis1=@Tuberculosis1,Tuberculosis2=@Tuberculosis2," +
               "Varicos1=@Varicos1,Varicos2=@Varicos2,DVT1=@DVT1,DVT2=@DVT2,Epilepsy1=@Epilepsy1,Epilepsy2=@Epilepsy2,PID1=@PID1,PID2=@PID2,Uterine1=@Uterine1,Uterine2=@Uterine2," +
               "Other1=@Other1,Other2=@Other2,Migraine1=@Migraine1,Migraine2=@Migraine2,Issurgery=@Issurgery,Surgery=@Surgery," +
               " IUCDType=@IUCDType,  IUCDBatch=@IUCDBatch,  IUCDExpiryDate=@IUCDExpiryDate,  ImplantType=@ImplantType,  ImplantBatch=@ImplantBatch," +
"  ImplantExpiryDate=@ImplantExpiryDate,  PermanentType=@PermanentType,  PermanentLAM=@PermanentLAM,  InjectionType=@InjectionType,  InjectionBatch=@InjectionBatch, "+
"InjectionExpiryDate=@InjectionExpiryDate,  PillType=@PillType,  PillNoOfCycles=@PillNoOfCycles,  PillBatch=@PillBatch,  PillExpiryDate=@PillExpiryDate,  CondomsType=@CondomsType,  CondomsNoIssued=@CondomsNoIssued," +
"  CondomsBatch=@CondomsBatch,  CondomsExpiryDate=@CondomsExpiryDate,  ECPsBatch=@ECPsBatch,  ECPsExpiryDate=@ECPsExpiryDate,  ECPsDual=@ECPsDual,  OthersSpecify=@OthersSpecify,  None=@None"+
",  Reason=@Reason,  HTC=@HTC,  HTCResults=@HTCResults,  CA=@CA, MethodUsed=@MethodUsed,  Results=@Results,  STI=@STI,  STIResults=@STIResults,  STIProstat=@STIProstat," +
"  STI3=@STI3,  Referral=@Referral,  ReferralReason=@ReferralReason,  Summary=@Summary,  ServiceProvider=@ServiceProvider, ReturnDate=@ReturnDate,  Breast=@Breast,  Breast1=@Breast1,"+
"Abdomen=@Abdomen,  Abdomen1=@Abdomen1,  External=@External,  External1=@External1,  Veginal=@Veginal,  Veginal1=@Veginal1,  Cervix=@Cervix,  Cervix1=@Cervix1,  Uterus=@Uterus," +
"  Uterus1=@Uterus1,  Adnexae=@Adnexae,  Adnexae1=@Adnexae1,  OtherSpecify=@OtherSpecify,  OtherSpecify1=@OtherSpecify1, Disability=@Disability, Disability1=@Disability1,Dual1=@Dual1" +
               
                " WHERE ID=@ID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {


                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),

                ServiceArea = txtServiceArea.Text,
                Highest = txtHighestEducationLevel.Text,
                
                LMP = txtLMP.Text,
                Regular = txtRegular.Text,
                BleedingDays = txtNoOfBleedingDays.Text,
                IsCurrent = rdbCurrentFPMethod.SelectedValue,
                Current = txtCurrentFPMethod.Text,
                IsPregnant = rdbPregnant.SelectedValue,
                Pregnant = txtPregnant.Text,
                IsBreastFeeding = rdbIsBreastFeeding.SelectedValue,
                NoOfDesiredChildren = txtNoOfDesiredChildren.Text,
                Parity = txtParity.Text,
                NoLiving = txtNoLiving.Text,
                NoDead = txtNoDead.Text,
                DateOfLastDelivery = DateOfLastDelivery,
                Mode = txtMode.Text,
                IsCurrentMedication = rdbCurrentMedication.SelectedValue,
                CurrentMedication = txtCurrentMedicationSpecify.Text,
                IsOperations = rdbSurgicalHistory.SelectedValue,
                Operations = txtSurgicalHistory.Text,
                Smoking1 = rdbSmoking1.SelectedValue,
                Smoking2 = rdbSmoking2.SelectedValue,
                Hypertension1 = rdbHypertension1.SelectedValue,
                Hypertension2 = rdbHypertension2.SelectedValue,
                Alcohol1 = rdbAlcohol1.SelectedValue,
                Alcohol2 = rdbAlcohol1.SelectedValue,
                Dibetes1 = rdbDibetes1.SelectedValue,
                Dibetes2 = rdbDibetes2.SelectedValue,
                Jaundice1 = rdbJaundice1.SelectedValue,
                Jaundice2 = rdbJaundice2.SelectedValue,
                Cardiac1 = rdbCardiac1.SelectedValue,
                Cardiac2 = rdbCardiac2.SelectedValue,

                HIV1 = rdbHIV1.SelectedValue,
                HIV2 = rdbHIV2.SelectedValue,
                Goitre1 = rdbGoitre1.SelectedValue,
                Goitre2 = rdbGoitre2.SelectedValue,
                Cancer1 = rdbRTCancer1.SelectedValue,
                Cancer2 = rdbRTCancer2.SelectedValue,
                Tuberculosis1 = rdbTuberculosis1.SelectedValue,
                Tuberculosis2 = rdbTuberculosis2.SelectedValue,
               
                Varicos1 = rdbVaricos1.SelectedValue,
                Varicos2 = rdbVaricos1.SelectedValue,
                DVT1 = rdbDVT1.SelectedValue,
                DVT2 = rdbDVT2.SelectedValue,
                STI1 = rdbSTI1.SelectedValue,
                STI2 = rdbSTI2.SelectedValue,
                Epilepsy1 = rdbEpilepsi1.SelectedValue,
                Epilepsy2 = rdbEpilepsi2.SelectedValue,
                PID1 = rdbPID1.SelectedValue,
                PID2 = rdbPID2.SelectedValue,
                Uterine1 = rdbUterine1.SelectedValue,
                Uterine2 = rdbUterine2.SelectedValue,
               
              
                Other1 = rdbOther1.SelectedValue,
                Other2 = rdbOther2.SelectedValue,
                Migraine1 = rdbMigraine1.SelectedValue,
                Migraine2 = rdbMigraine2.SelectedValue,
                Issurgery = rdbSurgery.SelectedValue,
                Surgery = txtSuergerySpecify.Text,
                ID = Util.GetString(lblID.Text),
                IUCDType = txtIUCDType.Text,
                IUCDBatch = txtIUCDBatch.Text,
                IUCDExpiryDate = IUCDExpiryDate,
                ImplantType = txtImplantType.Text,
                ImplantBatch = txtImplantBatch.Text,
                ImplantExpiryDate = ImplantExpiryDate,
                PermanentType = txtPermanentType.Text,
                PermanentLAM = txtPermanentLAM.Text,
                InjectionType = txtInjectionType.Text,
                InjectionBatch = txtInjectionBatch.Text,
                InjectionExpiryDate = InjectionExpiryDate,
                PillType = txtPillType.Text,
                PillNoOfCycles = txtPillNoOfCycles.Text,
                PillBatch = txtPillBatch.Text,
                PillExpiryDate = PillExpiryDate,
                CondomsType = txtCondomsType.Text,
                CondomsNoIssued = txtCondomsNoIssued.Text,
                CondomsBatch = txtCondomsBatch.Text,
                CondomsExpiryDate = CondomsExpiryDate,
                ECPsBatch = txtECPsBatch.Text,
                ECPsExpiryDate = ECPsExpiryDate,
                ECPsDual = rdbDual.SelectedValue,
                OthersSpecify = txtOthersSpecify.Text,
                None = txtNone.Text,
                Reason = txtReason.Text,
                HTC = rdbHTC.SelectedValue,
                HTCResults = txtHTCResults.Text,
                CA = rdbCA.SelectedValue,
                MethodUsed = txtMethodUsed.Text,
                Results = txtResults.Text,
                STI = rdbSTI.SelectedValue,
                STIResults = txtSTIResults.Text,
                STIProstat = rdbSTIProstat.SelectedValue,
                STI3 = txtSTI.Text,
                Referral = rdbReferral.SelectedValue,
                ReferralReason = txtReferralReason.Text,
                Summary = txtSummary.Text,
                ServiceProvider = txtServiceProvider.Text,
                ReturnDate = ReturnDate,
                Breast = rdbBreast.SelectedValue,
                Breast1 = txtBreast1.Text,
                Abdomen = rdbAbdomen.SelectedValue,
                Abdomen1 = txtAbdomen1.Text,
                External = rdbExternal.SelectedValue,
                External1 = txtExternal1.Text,
                Veginal = rdbVeginal.SelectedValue,
                Veginal1 = txtVeginal1.Text,
                Cervix = rdbCervix.SelectedValue,
                Cervix1 = txtCervix1.Text,
                Uterus = rdbUterus.SelectedValue,
                Uterus1 = txtUterus1.Text,
                Adnexae = rdbAdnexae.SelectedValue,
                Adnexae1 = txtAdnexae1.Text,
                OtherSpecify = rdbOtherSystems.SelectedValue,
                OtherSpecify1 = txtOtherSystems1.Text,
                Disability = rdbDisability.SelectedValue,
                Disability1 = txtDisability1.Text,
                Dual1 = txtDual1.Text

            });
            message = "Record Update Successfully";
            Clear();
            btnUpdate.Visible = false;
            btnSave.Visible = true;
            tnx.Commit();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact Administrator";
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
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./FamilyPlanning_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);


        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text;
                txtServiceArea.Text = ((Label)grdPhysical.Rows[id].FindControl("lblServiceArea")).Text;
                txtHighestEducationLevel.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHighest")).Text;
                txtLMP.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLMP")).Text;
                txtRegular.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRegular")).Text;
                txtNoOfBleedingDays.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBleedingDays")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblIsCurrent")).Text != "")
                {
                    rdbCurrentFPMethod.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblIsCurrent")).Text;
                }
                txtCurrentFPMethod.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCurrent")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblIsPregnant")).Text != "")
                {
                    rdbPregnant.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblIsPregnant")).Text;
                }
                txtPregnant.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPregnant")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblIsBreastFeeding")).Text != "")
                {
                    rdbIsBreastFeeding.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblIsBreastFeeding")).Text;
                }
                txtNoOfDesiredChildren.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNoOfDesiredChildren")).Text;
                txtParity.Text = ((Label)grdPhysical.Rows[id].FindControl("lblParity")).Text;
                txtNoLiving.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNoLiving")).Text;
                txtNoDead.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNoDead")).Text;
                txtDateOfLastDelivery.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDateOfLastDelivery")).Text;
                txtMode.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMode")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblIsCurrentMedication")).Text != "")
                {
                    rdbCurrentMedication.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblIsCurrentMedication")).Text;
                }
                txtCurrentMedicationSpecify.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCurrentMedication")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblIsOperations")).Text != "")
                {
                    rdbSurgicalHistory.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblIsOperations")).Text;
                }
                txtSurgicalHistory.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOperations")).Text;
                rdbSmoking1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSmoking1")).Text;

                rdbSmoking1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSmoking1")).Text;
                rdbSmoking2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSmoking2")).Text;
                rdbHypertension1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHypertension1")).Text;
                rdbHypertension2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHypertension2")).Text;
                rdbAlcohol1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAlcohol1")).Text;
                rdbAlcohol2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAlcohol2")).Text;
                rdbDibetes1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDibetes1")).Text;
                rdbDibetes2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDibetes2")).Text;
                rdbJaundice1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblJaundice1")).Text;
                rdbJaundice2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblJaundice2")).Text;
                rdbCardiac1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblCardiac1")).Text;
                rdbCardiac2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblCardiac2")).Text;
                rdbHIV1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHIV1")).Text;
                rdbHIV2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHIV2")).Text;
                rdbGoitre1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblGoitre1")).Text;
                rdbGoitre2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblGoitre2")).Text;
                rdbRTCancer1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblCancer1")).Text;
                rdbRTCancer2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblCancer2")).Text;
                rdbTuberculosis1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblTuberculosis1")).Text;
                rdbTuberculosis2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblTuberculosis2")).Text;
                rdbVaricos1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVaricos1")).Text;
                rdbVaricos2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVaricos2")).Text;
                rdbDVT1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDVT1")).Text;
                rdbDVT2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDVT2")).Text;
                rdbSTI1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSTI1")).Text;
                rdbSTI2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSTI2")).Text;
                rdbEpilepsi1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblEpilepsy1")).Text;
                rdbEpilepsi2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblEpilepsy2")).Text;
                rdbPID1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPID1")).Text;
                rdbPID2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPID2")).Text;
                rdbUterine1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblUterine1")).Text;
                rdbUterine2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblUterine2")).Text;
                rdbOther1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOther1")).Text;
                rdbOther2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOther2")).Text;
                rdbMigraine1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblMigraine1")).Text;
                rdbMigraine2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblMigraine2")).Text;
                txtIUCDType.Text = ((Label)grdPhysical.Rows[id].FindControl("lblIUCDType")).Text;
                txtIUCDBatch.Text = ((Label)grdPhysical.Rows[id].FindControl("lblIUCDBatch")).Text;
                txtIUCDExpiryDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblIUCDExpiryDate")).Text;
                txtImplantType.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImplantType")).Text;
                txtImplantBatch.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImplantBatch")).Text;
                txtImplantExpiryDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImplantExpiryDate")).Text;
                txtPermanentType.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPermanentType")).Text;
                txtPermanentLAM.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPermanentLAM")).Text;
                txtInjectionType.Text = ((Label)grdPhysical.Rows[id].FindControl("lblInjectionType")).Text;
                txtInjectionBatch.Text = ((Label)grdPhysical.Rows[id].FindControl("lblInjectionBatch")).Text;
                txtInjectionExpiryDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblInjectionExpiryDate")).Text;
                txtPillType.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPillType")).Text;
                txtPillNoOfCycles.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPillNoOfCycles")).Text;
                txtPillBatch.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPillBatch")).Text;
                txtPillExpiryDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPillExpiryDate")).Text;
                txtCondomsType.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCondomsType")).Text;
                txtCondomsNoIssued.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCondomsNoIssued")).Text;
                txtCondomsBatch.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCondomsBatch")).Text;
                txtCondomsExpiryDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCondomsExpiryDate")).Text;
                txtECPsBatch.Text = ((Label)grdPhysical.Rows[id].FindControl("lblECPsBatch")).Text;
                txtECPsExpiryDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblECPsExpiryDate")).Text;
                rdbDual.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblECPsDual")).Text;
                txtOtherSystems1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOthersSpecify")).Text;
                txtNone.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNone")).Text;
                txtReason.Text = ((Label)grdPhysical.Rows[id].FindControl("lblReason")).Text;
                rdbHTC.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHTC")).Text;
                txtHTCResults.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHTCResults")).Text;
                rdbCA.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblCA")).Text;
                //rdbMethodUsed.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMethodUsed")).Text;
                txtResults.Text = ((Label)grdPhysical.Rows[id].FindControl("lblResults")).Text;
                rdbSTI.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSTI")).Text;
                txtSTIResults.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSTIResults")).Text;
                rdbSTIProstat.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSTIProstat")).Text;
                txtSTI.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSTI3")).Text;
                rdbReferral.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblReferral")).Text;
                txtReferralReason.Text = ((Label)grdPhysical.Rows[id].FindControl("lblReferralReason")).Text;
                txtSummary.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSummary")).Text;
                txtServiceProvider.Text = ((Label)grdPhysical.Rows[id].FindControl("lblServiceProvider")).Text;
                txtReturnDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblReturnDate")).Text;
                rdbBreast.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblBreast")).Text;
                txtBreast1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBreast1")).Text;
                rdbAbdomen.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAbdomen")).Text;
                txtAbdomen1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAbdomen1")).Text;
                rdbExternal.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblExternal")).Text;
                txtExternal1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblExternal1")).Text;
                rdbVeginal.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVeginal")).Text;
                txtVeginal1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVeginal1")).Text;
                rdbCervix.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblCervix")).Text;
                txtCervix1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCervix1")).Text;
                rdbUterus.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblUterus")).Text;
                txtUterus1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblUterus1")).Text;
                rdbAdnexae.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAdnexae")).Text;
                txtAdnexae1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAdnexae1")).Text;
                rdbOtherSystems.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOtherSpecify")).Text;
                txtOtherSystems1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOtherSpecify1")).Text;
                rdbDisability.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDisability")).Text;
                txtDisability1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDisability1")).Text;
                txtDual1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDual1")).Text;
               
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
            
        }
       
    }

    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (((Label)e.Row.FindControl("lblUserID")).Text != Session["ID"].ToString() || Util.GetDateTime(((Label)e.Row.FindControl("lblEntryDate")).Text).ToString("dd-MMM-yyyy") != Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy"))
                {
                    ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void Radio1_Changed(object sender, EventArgs e)
    {
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {

                txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            
                if (Request.QueryString["App_ID"] != null)
                {
                    ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
                }
                else
                {
                    ViewState["appointmentID"] = "0";
                }
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
                ViewState["UserID"] = Session["ID"].ToString();
                if (Request.QueryString["IsViewable"] == null)
                {
                    //bool IsDone = Util.GetBoolean(Request.QueryString["IsEdit"]);
                    string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
                    string msg = "File Has Been Closed...";
                    if (IsDone == "1")
                    {
                        Response.Redirect("NotAuthorized.aspx?msg=" + msg, false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                }
                rdbSmoking1.SelectedIndex = 1;
                rdbSmoking2.SelectedIndex = 1;
                rdbHypertension1.SelectedIndex = 1;
                rdbHypertension2.SelectedIndex = 1;
                rdbAlcohol1.SelectedIndex = 1;
                rdbAlcohol2.SelectedIndex = 1;
                rdbDibetes1.SelectedIndex = 1;
                rdbDibetes2.SelectedIndex = 1;
                rdbJaundice1.SelectedIndex = 1;
                rdbJaundice2.SelectedIndex = 1;
                rdbCardiac1.SelectedIndex = 1;
                rdbCardiac2.SelectedIndex = 1;
                rdbHIV1.SelectedIndex = 1;
                rdbHIV2.SelectedIndex = 1;
                rdbGoitre1.SelectedIndex = 1;
                rdbGoitre2.SelectedIndex = 1;
                rdbRTCancer1.SelectedIndex = 1;
                rdbRTCancer2.SelectedIndex = 1;
                rdbTuberculosis1.SelectedIndex = 1;
                rdbTuberculosis2.SelectedIndex = 1;
                rdbVaricos1.SelectedIndex = 1;
                rdbDVT1.SelectedIndex = 1;
                rdbDVT2.SelectedIndex = 1;
                rdbSTI1.SelectedIndex = 1;
                rdbSTI2.SelectedIndex = 1;
                rdbEpilepsi1.SelectedIndex = 1;
                rdbEpilepsi2.SelectedIndex = 1;
                rdbPID1.SelectedIndex = 1;
                rdbPID2.SelectedIndex = 1;
                rdbUterine1.SelectedIndex = 1;
                rdbUterine2.SelectedIndex = 1;
                rdbOther1.SelectedIndex = 1;
                rdbOther2.SelectedIndex = 1;
                rdbMigraine1.SelectedIndex = 1;
                rdbMigraine2.SelectedIndex = 1;
                BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
                Clear();
            }
            FillClientDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
               
            txtDate.Enabled = false;
            txtTime.Enabled = false;
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
            if ((txtBp.Text.Trim() == "") && (txtP.Text.Trim() == "") && (txtR.Text.Trim() == "") && (txtT.Text.Trim() == "") && (txtHt.Text.Trim() == "") && (txtWt.Text.Trim() == "") && (txtArmSpan.Text.Trim() == "") && (txtSittingHeight.Text.Trim() == "") && (txtIBW.Text.Trim() == ""))
            {
                lblMsg.Text = "Please Enter Pulse";
                txtP.Focus();
                return false;
            }
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

        txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.ToString("hh:mm tt");

        txtServiceArea.Text = "";
        txtHighestEducationLevel.Text = "";
        txtLMP.Text = "";
        txtRegular.Text ="";
        txtNoOfBleedingDays.Text = "";
        rdbCurrentFPMethod.SelectedIndex = -1;
        txtCurrentFPMethod.Text = "";
        rdbPregnant.SelectedIndex = -1;
        txtPregnant.Text = "";
        rdbIsBreastFeeding.SelectedIndex = -1;
        txtNoOfDesiredChildren.Text = "";
        txtParity.Text = "";
        txtNoLiving.Text = "";
        txtNoDead.Text = "";
        txtDateOfLastDelivery.Text ="";
        txtMode.Text = "";
        rdbCurrentMedication.SelectedIndex = -1;
        txtCurrentMedicationSpecify.Text = "";
        rdbSurgicalHistory.SelectedIndex = -1;
        txtSurgicalHistory.Text = "";

        rdbSmoking1.SelectedIndex = 1;
        rdbSmoking2.SelectedIndex = 1;
        rdbHypertension1.SelectedIndex = 1;
        rdbHypertension2.SelectedIndex = 1;
        rdbAlcohol1.SelectedIndex = 1;
        rdbAlcohol2.SelectedIndex = 1;
        rdbDibetes1.SelectedIndex = 1;
        rdbDibetes2.SelectedIndex = 1;
        rdbJaundice1.SelectedIndex = 1;
        rdbJaundice2.SelectedIndex = 1;
        rdbCardiac1.SelectedIndex = 1;
        rdbHIV1.SelectedIndex = 1;
        rdbHIV2.SelectedIndex = 1;
        rdbGoitre1.SelectedIndex = 1;
        rdbGoitre2.SelectedIndex = 1;
        rdbRTCancer1.SelectedIndex = 1;
        rdbRTCancer2.SelectedIndex = 1;
        rdbTuberculosis1.SelectedIndex = 1;
        rdbTuberculosis2.SelectedIndex = 1;
        rdbVaricos1.SelectedIndex = 1;
        rdbDVT1.SelectedIndex = 1;
        rdbDVT2.SelectedIndex = 1;
        rdbSTI1.SelectedIndex = 1;
        rdbSTI2.SelectedIndex = 1;
        rdbEpilepsi1.SelectedIndex = 1;
        rdbEpilepsi2.SelectedIndex = 1;
        rdbPID1.SelectedIndex = 1;
        rdbPID2.SelectedIndex = 1;
        rdbUterine1.SelectedIndex = 1;
        rdbUterine2.SelectedIndex = 1;
        rdbOther1.SelectedIndex = 1;
        rdbOther2.SelectedIndex = 1;
        rdbMigraine1.SelectedIndex = 1;
        rdbMigraine2.SelectedIndex = 1;
        txtIUCDType.Text = "";
        txtIUCDBatch.Text = "";
        txtIUCDExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtImplantType.Text = "";
        txtImplantBatch.Text ="";
        txtImplantExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtPermanentType.Text ="";
        txtPermanentLAM.Text = "";
        txtInjectionType.Text = "";
        txtInjectionBatch.Text = "";
        txtInjectionExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtPillType.Text = "";
        txtPillNoOfCycles.Text ="";
        txtPillBatch.Text = "";
        txtPillExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtCondomsType.Text = "";
        txtCondomsNoIssued.Text = "";
        txtCondomsBatch.Text = "";
        txtCondomsExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtECPsBatch.Text ="";
        txtECPsExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        rdbDual.SelectedIndex = -1;
        txtOtherSystems1.Text = "";
        txtNone.Text = "";
        txtReason.Text = "";
        rdbHTC.SelectedIndex = -1;
        txtHTCResults.Text = "";
        rdbCA.SelectedIndex = -1;
        //rdbMethodUsed.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMethodUsed")).Text;
        txtResults.Text = "";
        rdbSTI.SelectedIndex =-1;
        txtSTIResults.Text = "";
        rdbSTIProstat.SelectedIndex =-1;
        txtSTI.Text = "";
        rdbReferral.SelectedIndex =-1;
        txtReferralReason.Text = "";
        txtSummary.Text = "";
        txtServiceProvider.Text = "";
        txtReturnDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        rdbBreast.SelectedIndex = -1;
        txtBreast1.Text ="";
        rdbAbdomen.SelectedIndex = -1;
        txtAbdomen1.Text = "";
        rdbExternal.SelectedIndex = -1;
        txtExternal1.Text = "";
        rdbVeginal.SelectedIndex = -1;
        txtVeginal1.Text = "";
        rdbCervix.SelectedIndex = -1;
        txtCervix1.Text ="";
        rdbUterus.SelectedIndex = -1;
        txtUterus1.Text = "";
        rdbAdnexae.SelectedIndex = -1;
        txtAdnexae1.Text ="";
        rdbOtherSystems.SelectedIndex = -1;
        txtOtherSystems1.Text = "";
        rdbDisability.SelectedIndex =-1;
        txtDisability1.Text = "";
               
               
    }
    
    private string SaveData()
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
             if (Request.QueryString["App_ID"]==null)
             {
              Request.QueryString["App_ID"]="0";
             }
            
            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert into cpoe_vital (TransactionID,PatientID,BP,P,R,T,HT,WT,ArmSpan,SHight,BMI,IBWKg,SPO2, ");
            sb.Append(" BF,MUAC,FBS,EntryBy,tw,vf,muscle,rm,WFA,BMIFA,CentreID,Hospital_ID,App_ID,CBG,PainScore,Remarks,WTType,HTType,TType) values ('" + ViewState["TID"] + "', ");
            sb.Append(" '" + ViewState["PID"] + "','" + txtBp.Text.Trim().ToString() + "','" + txtP.Text.Trim().ToString() + "','" + txtR.Text.Trim().ToString() + "','" + txtT.Text.Trim().ToString() + "','" + txtHt.Text.Trim().ToString() + "','" + txtWt.Text.Trim().ToString() + "','" + txtArmSpan.Text.Trim() + "','" + txtSittingHeight.Text.Trim() + "','" + Util.GetDecimal(txtBMI.Text) + "','" + Util.GetDecimal(txtIBW.Text) + "','" + Util.GetDecimal(txtSPO2.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtBF.Text) + "','" + Util.GetDecimal(txtMuac.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtFBS.Text) + "','" + ViewState["UserID"] + "', '" + Util.GetDecimal(txtTw.Text) + "','" + Util.GetDecimal(txtVf.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtMuscle.Text) + "','" + Util.GetDecimal(txtRm.Text) + "','" + Util.GetDecimal(txtWFA.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtBMIFA.Text) + "','" + Util.GetInt(Session["centreID"].ToString()) + "','" + Session["HOSPID"].ToString() + "'," + Util.GetInt(Request.QueryString["App_ID"]) + ",'" + txtCBG.Text.Trim() + "','" + txtPainScore.Text.Trim() + "','" + txtRemark.Text.Trim() + "','" + ddlWeightType.SelectedItem.Value + "','" + ddlHeightType.SelectedItem.Value + "','" + ddltemperature.SelectedItem.Value + "' )");

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            //Insert Viewed Tab Info
            AllQuery.UpdateDoctorTab_Information(ViewState["TID"].ToString(), Util.GetInt(Request.QueryString["MenuID"]));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindMandtoryVitial(string deptid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT c.VitialSiginTextID,IF(IFNULL(d.IsMandtory,0)=0,'0','1')isRequired,IFNULL(c.ErrorMessage,'')ErrorMessage ");
        sb.Append(" FROM cpoe_VitalExaminationMandtoryMaster c ");
        sb.Append(" LEFT JOIN DoctorDepartmentwiseVitialSign d ON c.VitialID=d.VitialID AND d.IsMandtory=1 AND  d.DepartmentID='"+deptid+"'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
        
    }
}