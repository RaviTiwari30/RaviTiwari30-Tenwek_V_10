using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_rehab  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/25/2014 2:25:50 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_rehab table 
/// ========================================================================================== 
/// </summary>  

public class physio_rehab
{
    public physio_rehab()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_rehab(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _FormName;
    private DateTime _ReportDate;
    private DateTime _ReportTime;
    private DateTime _OnsetDateCondition;
    private string _DoctorID;
    private string _TreatmentDiagnosis;
    private string _PrimaryDiagnosis;
    private string _MedicalHistory;
    private string _DiagnosticTests;
    private string _Medications;
    private string _Precautions;
    private string _PresentInjuryHistory;
    private string _ChiefComplaints;
    private int _PainScale;
    private string _Nature;
    private string _PriorLevelFunction;
    private string _CurrentFunctionalLimitation;
    private string _SleepingPosition;
    private string _Pillows;
    private string _NightPain;
    private string _DisturbedSleep;
    private string _PosturalAssessment;
    private string _Skin;
    private string _Postural;
    private string _Ambulation;
    private string _SpineROM;
    private string _Sensation;
    private string _Flexibility;
    private string _Palpation;
    private string _Biceps;
    private string _Brachioradialis;
    private string _Triceps;
    private string _ScapularStability;
    private string _ScapuloHumeralRhythm;
    private string _SpecialTests;
    private string _MMT;
    private string _Treatment;
    private string _OtherTreatment;
    private string _Assessment;
    private string _Summary;
    private string _ShortTermGoal;
    private string _ShortTermTime;
    private string _LongTermGoal;
    private string _LongTermTime;
    private int _VisitsPerWeek;
    private int _Weeks;
    private int _VisitsRequested;
    private string _Modalties;
    private string _NeuroBalance;
    private string _NeuroProprioception;
    private string _TherapeuticHEP;
    private string _TherapeuticROM;
    private string _TherapeuticFlexibility;
    private string _ActivityModification;
    private string _Posture;
    private string _BodyMechanics;
    private string _PREs;
    private string _ManualTherapy;
    private string _FunctActivities;
    private string _Other;
    private string _Splinting;
    private int _GaitTraining;
    private string _EnterBy;
    private string _Rytham;
    private string _DominantRight;
    private string _DominantLeft;
    private string _ThighInv;
    private string _ThichNonInv;
    private string _KneeInv;
    private string _KneeNonInv;
    private string _CalfInv;
    private string _CalNonInv;
    private string _AnkleInv;
    private string _AnkleNonInv;
    private string _LumboPalvicStability;
    private string _LiftingMachine;
    private string _Patell;
    private string _Achilles;
    
    private string _SLRRight;
    private string _SLRLeft;
    private string _PKFRight;
    private string _PKFLeft;
    private string _HFRight;
    private string _HFLeft;
    private string _QuadRight;
    private string _QuadLeft;
    private string _IntactLightTouch;



    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string FormName { get { return _FormName; } set { _FormName = value; } }
    public virtual DateTime ReportDate { get { return _ReportDate; } set { _ReportDate = value; } }
    public virtual DateTime ReportTime { get { return _ReportTime; } set { _ReportTime = value; } }
    public virtual DateTime OnsetDateCondition { get { return _OnsetDateCondition; } set { _OnsetDateCondition = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string TreatmentDiagnosis { get { return _TreatmentDiagnosis; } set { _TreatmentDiagnosis = value; } }
    public virtual string PrimaryDiagnosis { get { return _PrimaryDiagnosis; } set { _PrimaryDiagnosis = value; } }
    public virtual string MedicalHistory { get { return _MedicalHistory; } set { _MedicalHistory = value; } }
    public virtual string DiagnosticTests { get { return _DiagnosticTests; } set { _DiagnosticTests = value; } }
    public virtual string Medications { get { return _Medications; } set { _Medications = value; } }
    public virtual string Precautions { get { return _Precautions; } set { _Precautions = value; } }
    public virtual string PresentInjuryHistory { get { return _PresentInjuryHistory; } set { _PresentInjuryHistory = value; } }
    public virtual string ChiefComplaints { get { return _ChiefComplaints; } set { _ChiefComplaints = value; } }
    public virtual int PainScale { get { return _PainScale; } set { _PainScale = value; } }
    public virtual string Nature { get { return _Nature; } set { _Nature = value; } }
    public virtual string PriorLevelFunction { get { return _PriorLevelFunction; } set { _PriorLevelFunction = value; } }
    public virtual string CurrentFunctionalLimitation { get { return _CurrentFunctionalLimitation; } set { _CurrentFunctionalLimitation = value; } }
    public virtual string SleepingPosition { get { return _SleepingPosition; } set { _SleepingPosition = value; } }
    public virtual string Pillows { get { return _Pillows; } set { _Pillows = value; } }
    public virtual string NightPain { get { return _NightPain; } set { _NightPain = value; } }
    public virtual string DisturbedSleep { get { return _DisturbedSleep; } set { _DisturbedSleep = value; } }
    public virtual string PosturalAssessment { get { return _PosturalAssessment; } set { _PosturalAssessment = value; } }
    public virtual string Skin { get { return _Skin; } set { _Skin = value; } }
    public virtual string Postural { get { return _Postural; } set { _Postural = value; } }
    public virtual string Ambulation { get { return _Ambulation; } set { _Ambulation = value; } }
    public virtual string SpineROM { get { return _SpineROM; } set { _SpineROM = value; } }
    public virtual string Sensation { get { return _Sensation; } set { _Sensation = value; } }
    public virtual string Flexibility { get { return _Flexibility; } set { _Flexibility = value; } }
    public virtual string Palpation { get { return _Palpation; } set { _Palpation = value; } }
    public virtual string Biceps { get { return _Biceps; } set { _Biceps = value; } }
    public virtual string Brachioradialis { get { return _Brachioradialis; } set { _Brachioradialis = value; } }
    public virtual string Triceps { get { return _Triceps; } set { _Triceps = value; } }
    public virtual string ScapularStability { get { return _ScapularStability; } set { _ScapularStability = value; } }
    public virtual string ScapuloHumeralRhythm { get { return _ScapuloHumeralRhythm; } set { _ScapuloHumeralRhythm = value; } }
    public virtual string SpecialTests { get { return _SpecialTests; } set { _SpecialTests = value; } }
    public virtual string MMT { get { return _MMT; } set { _MMT = value; } }
    public virtual string Treatment { get { return _Treatment; } set { _Treatment = value; } }
    public virtual string OtherTreatment { get { return _OtherTreatment; } set { _OtherTreatment = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Summary { get { return _Summary; } set { _Summary = value; } }
    public virtual string ShortTermGoal { get { return _ShortTermGoal; } set { _ShortTermGoal = value; } }
    public virtual string ShortTermTime { get { return _ShortTermTime; } set { _ShortTermTime = value; } }
    public virtual string LongTermGoal { get { return _LongTermGoal; } set { _LongTermGoal = value; } }
    public virtual string LongTermTime { get { return _LongTermTime; } set { _LongTermTime = value; } }
    public virtual int VisitsPerWeek { get { return _VisitsPerWeek; } set { _VisitsPerWeek = value; } }
    public virtual int Weeks { get { return _Weeks; } set { _Weeks = value; } }
    public virtual int VisitsRequested { get { return _VisitsRequested; } set { _VisitsRequested = value; } }
    public virtual string Modalties { get { return _Modalties; } set { _Modalties = value; } }
    public virtual string NeuroBalance { get { return _NeuroBalance; } set { _NeuroBalance = value; } }
    public virtual string NeuroProprioception { get { return _NeuroProprioception; } set { _NeuroProprioception = value; } }
    public virtual string TherapeuticHEP { get { return _TherapeuticHEP; } set { _TherapeuticHEP = value; } }
    public virtual string TherapeuticROM { get { return _TherapeuticROM; } set { _TherapeuticROM = value; } }
    public virtual string TherapeuticFlexibility { get { return _TherapeuticFlexibility; } set { _TherapeuticFlexibility = value; } }
    public virtual string ActivityModification { get { return _ActivityModification; } set { _ActivityModification = value; } }
    public virtual string Posture { get { return _Posture; } set { _Posture = value; } }
    public virtual string BodyMechanics { get { return _BodyMechanics; } set { _BodyMechanics = value; } }
    public virtual string PREs { get { return _PREs; } set { _PREs = value; } }
    public virtual string ManualTherapy { get { return _ManualTherapy; } set { _ManualTherapy = value; } }
    public virtual string FunctActivities { get { return _FunctActivities; } set { _FunctActivities = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string Splinting { get { return _Splinting; } set { _Splinting = value; } }
    public virtual int GaitTraining { get { return _GaitTraining; } set { _GaitTraining = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }

    public virtual string Rytham { get { return _Rytham; } set { _Rytham = value; } }
    public virtual string DominantRight { get { return _DominantRight; } set { _DominantRight = value; } }
    public virtual string DominantLeft { get { return _DominantLeft; } set { _DominantLeft = value; } }
    public virtual string ThighInv { get { return _ThighInv; } set { _ThighInv = value; } }
    public virtual string ThichNonInv { get { return _ThichNonInv; } set { _ThichNonInv = value; } }
    public virtual string KneeInv { get { return _KneeInv; } set { _KneeInv = value; } }
    public virtual string KneeNonInv { get { return _KneeNonInv; } set { _KneeNonInv = value; } }
    public virtual string CalfInv { get { return _CalfInv; } set { _CalfInv = value; } }
    public virtual string CalNonInv { get { return _CalNonInv; } set { _CalNonInv = value; } }
    public virtual string AnkleInv { get { return _AnkleInv; } set { _AnkleInv = value; } }
    public virtual string AnkleNonInv { get { return _AnkleNonInv; } set { _AnkleNonInv = value; } }
    public virtual string LumboPalvicStability { get { return _LumboPalvicStability; } set { _LumboPalvicStability = value; } }
    public virtual string LiftingMachine { get { return _LiftingMachine; } set { _LiftingMachine = value; } }
    public virtual string Patell { get { return _Patell; } set { _Patell = value; } }
    public virtual string Achilles { get { return _Achilles; } set { _Achilles = value; } }

    public virtual string SLRRight { get { return _SLRRight; } set { _SLRRight = value; } }
    public virtual string SLRLeft { get { return _SLRLeft; } set { _SLRLeft = value; } }
    public virtual string PKFRight { get { return _PKFRight; } set { _PKFRight = value; } }
    public virtual string PKFLeft { get { return _PKFLeft; } set { _PKFLeft = value; } }
    public virtual string HFRight { get { return _HFRight; } set { _HFRight = value; } }
    public virtual string HFLeft { get { return _HFLeft; } set { _HFLeft = value; } }
    public virtual string QuadRight { get { return _QuadRight; } set { _QuadRight = value; } }
    public virtual string QuadLeft { get { return _QuadLeft; } set { _QuadLeft = value; } }

    public virtual string IntactLightTouch { get { return _IntactLightTouch; } set { _IntactLightTouch = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_rehab_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vFormName", Util.GetString(FormName)));
            cmd.Parameters.Add(new MySqlParameter("@vReportDate", Util.GetDateTime(ReportDate)));
            cmd.Parameters.Add(new MySqlParameter("@vReportTime", Util.GetDateTime(ReportTime)));
            cmd.Parameters.Add(new MySqlParameter("@vOnsetDateCondition", Util.GetDateTime(OnsetDateCondition)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatmentDiagnosis", Util.GetString(TreatmentDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vPrimaryDiagnosis", Util.GetString(PrimaryDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vMedicalHistory", Util.GetString(MedicalHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosticTests", Util.GetString(DiagnosticTests)));
            cmd.Parameters.Add(new MySqlParameter("@vMedications", Util.GetString(Medications)));
            cmd.Parameters.Add(new MySqlParameter("@vPrecautions", Util.GetString(Precautions)));
            cmd.Parameters.Add(new MySqlParameter("@vPresentInjuryHistory", Util.GetString(PresentInjuryHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vChiefComplaints", Util.GetString(ChiefComplaints)));
            cmd.Parameters.Add(new MySqlParameter("@vPainScale", Util.GetInt(PainScale)));
            cmd.Parameters.Add(new MySqlParameter("@vNature", Util.GetString(Nature)));
            cmd.Parameters.Add(new MySqlParameter("@vPriorLevelFunction", Util.GetString(PriorLevelFunction)));
            cmd.Parameters.Add(new MySqlParameter("@vCurrentFunctionalLimitation", Util.GetString(CurrentFunctionalLimitation)));
            cmd.Parameters.Add(new MySqlParameter("@vSleepingPosition", Util.GetString(SleepingPosition)));
            cmd.Parameters.Add(new MySqlParameter("@vPillows", Util.GetString(Pillows)));
            cmd.Parameters.Add(new MySqlParameter("@vNightPain", Util.GetString(NightPain)));
            cmd.Parameters.Add(new MySqlParameter("@vDisturbedSleep", Util.GetString(DisturbedSleep)));
            cmd.Parameters.Add(new MySqlParameter("@vPosturalAssessment", Util.GetString(PosturalAssessment)));
            cmd.Parameters.Add(new MySqlParameter("@vSkin", Util.GetString(Skin)));
            cmd.Parameters.Add(new MySqlParameter("@vPostural", Util.GetString(Postural)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulation", Util.GetString(Ambulation)));
            cmd.Parameters.Add(new MySqlParameter("@vSpineROM", Util.GetString(SpineROM)));
            cmd.Parameters.Add(new MySqlParameter("@vSensation", Util.GetString(Sensation)));
            cmd.Parameters.Add(new MySqlParameter("@vPalpation", Util.GetString(Palpation)));
            cmd.Parameters.Add(new MySqlParameter("@vBiceps", Util.GetString(Biceps)));
            cmd.Parameters.Add(new MySqlParameter("@vBrachioradialis", Util.GetString(Brachioradialis)));
            cmd.Parameters.Add(new MySqlParameter("@vTriceps", Util.GetString(Triceps)));
            cmd.Parameters.Add(new MySqlParameter("@vScapularStability", Util.GetString(ScapularStability)));
            cmd.Parameters.Add(new MySqlParameter("@vScapuloHumeralRhythm", Util.GetString(ScapuloHumeralRhythm)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecialTests", Util.GetString(SpecialTests)));
            cmd.Parameters.Add(new MySqlParameter("@vMMT", Util.GetString(MMT)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatment", Util.GetString(Treatment)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherTreatment", Util.GetString(OtherTreatment)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vSummary", Util.GetString(Summary)));
            cmd.Parameters.Add(new MySqlParameter("@vFlexibility", Util.GetString(Flexibility)));
            cmd.Parameters.Add(new MySqlParameter("@vShortTermGoal", Util.GetString(ShortTermGoal)));
            cmd.Parameters.Add(new MySqlParameter("@vShortTermTime", Util.GetString(ShortTermTime)));
            cmd.Parameters.Add(new MySqlParameter("@vLongTermGoal", Util.GetString(LongTermGoal)));
            cmd.Parameters.Add(new MySqlParameter("@vLongTermTime", Util.GetString(LongTermTime)));
            cmd.Parameters.Add(new MySqlParameter("@vVisitsPerWeek", Util.GetInt(VisitsPerWeek)));
            cmd.Parameters.Add(new MySqlParameter("@vWeeks", Util.GetInt(Weeks)));
            cmd.Parameters.Add(new MySqlParameter("@vVisitsRequested", Util.GetInt(VisitsRequested)));
            cmd.Parameters.Add(new MySqlParameter("@vModalties", Util.GetString(Modalties)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroBalance", Util.GetString(NeuroBalance)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroProprioception", Util.GetString(NeuroProprioception)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapeuticHEP", Util.GetString(TherapeuticHEP)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapeuticROM", Util.GetString(TherapeuticROM)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapeuticFlexibility", Util.GetString(TherapeuticFlexibility)));
            cmd.Parameters.Add(new MySqlParameter("@vActivityModification", Util.GetString(ActivityModification)));
            cmd.Parameters.Add(new MySqlParameter("@vPosture", Util.GetString(Posture)));
            cmd.Parameters.Add(new MySqlParameter("@vBodyMechanics", Util.GetString(BodyMechanics)));
            cmd.Parameters.Add(new MySqlParameter("@vPREs", Util.GetString(PREs)));
            cmd.Parameters.Add(new MySqlParameter("@vManualTherapy", Util.GetString(ManualTherapy)));
            cmd.Parameters.Add(new MySqlParameter("@vFunctActivities", Util.GetString(FunctActivities)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vSplinting", Util.GetString(Splinting)));
            cmd.Parameters.Add(new MySqlParameter("@vGaitTraining", Util.GetInt(GaitTraining)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));

            cmd.Parameters.Add(new MySqlParameter("@vRytham", Util.GetString(Rytham)));
            cmd.Parameters.Add(new MySqlParameter("@vDominantRight", Util.GetString(DominantRight)));
            cmd.Parameters.Add(new MySqlParameter("@vDominantLeft", Util.GetString(DominantLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vThighInv", Util.GetString(ThighInv)));
            cmd.Parameters.Add(new MySqlParameter("@vThichNonInv", Util.GetString(ThichNonInv)));
            cmd.Parameters.Add(new MySqlParameter("@vKneeInv", Util.GetString(KneeNonInv)));
            cmd.Parameters.Add(new MySqlParameter("@vKneeNonInv", Util.GetString(Rytham)));
            cmd.Parameters.Add(new MySqlParameter("@vCalfInv", Util.GetString(CalfInv)));
            cmd.Parameters.Add(new MySqlParameter("@vCalNonInv", Util.GetString(CalNonInv)));
            cmd.Parameters.Add(new MySqlParameter("@vAnkleInv", Util.GetString(AnkleInv)));
            cmd.Parameters.Add(new MySqlParameter("@vAnkleNonInv", Util.GetString(AnkleNonInv)));
            cmd.Parameters.Add(new MySqlParameter("@vLumboPalvicStability", Util.GetString(LumboPalvicStability)));
            cmd.Parameters.Add(new MySqlParameter("@vLiftingMachine", Util.GetString(LiftingMachine)));
            cmd.Parameters.Add(new MySqlParameter("@vPatell", Util.GetString(Patell)));
            cmd.Parameters.Add(new MySqlParameter("@vAchilles", Util.GetString(Achilles)));

            cmd.Parameters.Add(new MySqlParameter("@vSLRRight", Util.GetString(SLRRight)));
            cmd.Parameters.Add(new MySqlParameter("@vSLRLeft", Util.GetString(SLRLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vPKFRight", Util.GetString(PKFRight)));
            cmd.Parameters.Add(new MySqlParameter("@vPKFLeft", Util.GetString(PKFLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vHFRight", Util.GetString(HFRight)));
            cmd.Parameters.Add(new MySqlParameter("@vHFLeft", Util.GetString(HFLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vQuadRight", Util.GetString(QuadRight)));
            cmd.Parameters.Add(new MySqlParameter("@vQuadLeft", Util.GetString(QuadLeft)));

            cmd.Parameters.Add(new MySqlParameter("@vIntactLightTouch", Util.GetString(IntactLightTouch)));

            cmd.ExecuteNonQuery();
            //Output = cmd.ExecuteNonQuery().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output.ToString();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }





    #endregion

}
