using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_spine_analysis
{
    public cpoe_spine_analysis()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_spine_analysis(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _CheifComplaint;
    private string _IsWorkStatus;
    private string _ReviewOfSystem;
    private string _PreviousSurgery;
    private int _IsAPXR1;
    private int _IsAPXR2;
    private int _IsAPXR3;
    private int _IsAPXR4;
    private int _IsAPXL1;
    private int _IsAPXL2;
    private int _IsAPXL3;
    private int _IsAPXL4;
    private string _APXLevelR1;
    private string _APXLevelR2;
    private string _APXLevelR3;
    private string _APXLevelR4;
    private string _APXLevelL1;
    private string _APXLevelL2;
    private string _APXLevelL3;
    private string _APXLevelL4;
    private string _APXDegree1;
    private string _APXDegree2;
    private string _APXDegree3;
    private string _APXDegree4;
    private string _APXBand1;
    private string _APXBand2;
    private string _APXBand3;
    private string _APXBand4;
    private string _LatXRayDegree1;
    private string _LatXRayDegree2;
    private string _LatXRayDegree3;
    private string _LatXRayDegree4;
    private string _LatXRayDegree5;
    private string _LatXRayFlex1;
    private string _LatXRayFlex2;
    private string _LatXRayFlex3;
    private string _LatXRayFlex4;
    private string _LatXRayFlex5;
    private string _LatXRayLocKyphosis;
    private string _IsLanke;
    private string _IsSRSCurveRiser;
    private string _IsSRSCurveTRC;
    private string _T1TiltAngle;
    private string _ClavicleAngle;
    private string _ShoulderHeight;
    private string _TrunkShift;
    private string _UIVAngulation;
    private string _EIVAngulation;
    private string _CoronalBalance;
    private string _DiscAngulation;
    private string _PelvicObliquity;
    private string _SacralObliquity;
    private string _SVA;
    private string _SacralSlope;
    private string _PelvicTilt;
    private string _PelvicIncidence;
    private string _PJKAbove1;
    private string _PJKAbove2;
    private string _DJKAbove1;
    private string _DJKAbove2;
    private int _IsFamilyHistoryYes;
    private int _IsFamilyHistoryNo;
    private int _IsPaternal;
    private int _IsMaternal;
    private int _IsGrandParents;
    private int _IsAuntUncle;
    private int _IsBrotherSister;
    private int _IsParents;
    private int _IsCousin;
    private string _LevPhyLabor;
    private string _IsSmoke;
    private string _SmokeTimes;
    private int _IsCurrent;
    private int _IsComplete;
    private string _IsCurrentType;
    private string _IsCompletePurpose;
    private int _IsSRS22r;
    private int _IsVASNeck;
    private int _IsVASBack;
    private int _IsVASLeg;
    private int _IsSF36;
    private string _Function;
    private string _Pain;
    private string _SelfImage;
    private string _MentalHealth;
    private string _Satisfaction;
    private string _Physical;
    private string _Mental;
    private string _Total;
    private int _IsODI;
    private int _IsNDI;
    private int _IsSAQPat;
    private int _IsSAQPar;
    private int _IsLumberIndex;
    private string _Score0;
    private string _Score1;
    private string _Score2;
    private string _Score3;
    private string _Score4;
    private string _StandingHeight;
    private string _SittingHeight;
    private string _Weight;
    private string _ArmSpan;
    private string _General;
    private int _IsATRThoracicNone;
    private int _IsATRThoracicR;
    private int _IsATRThoracicL;
    private string _ATRThoracicR;
    private string _ATRThoracicL;
    private int _IsATRThoracolumbarNone;
    private int _IsATRThoracolumbarR;
    private int _IsATRThoracolumbarL;
    private string _ATRThoracolumbarR;
    private string _ATRThoracolumbarL;
    private int _IsPlumbLineNone;
    private int _IsPlumbLineR;
    private int _IsPlumbLineL;
    private string _PlumbLineR;
    private string _PlumbLineL;
    private int _IsLegLengthNone;
    private int _IsLegLengthR;
    private int _IsLegLengthL;
    private string _LegLengthR;
    private string _LegLengthL;
    private int _IsShoulderNone;
    private int _IsShoulderR;
    private int _IsShoulderL;
    private string _ShoulderR;
    private string _ShoulderL;
    private string _IsBracing;
    private string _IsChiropractor;
    private string _IsInjections;
    private string _IsNSAIDS;
    private string _IsNarcotics;
    private string _IsPainProgram;
    private string _IsPhysicalTherapy;
    private string _IsOther;
    private string _UserID;
    private DateTime _EntryDate;
    private string _UpdateBy;
    private DateTime _UpdateDate;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string CheifComplaint { get { return _CheifComplaint; } set { _CheifComplaint = value; } }
    public virtual string IsWorkStatus { get { return _IsWorkStatus; } set { _IsWorkStatus = value; } }
    public virtual string ReviewOfSystem { get { return _ReviewOfSystem; } set { _ReviewOfSystem = value; } }
    public virtual string PreviousSurgery { get { return _PreviousSurgery; } set { _PreviousSurgery = value; } }
    public virtual int IsAPXR1 { get { return _IsAPXR1; } set { _IsAPXR1 = value; } }
    public virtual int IsAPXR2 { get { return _IsAPXR2; } set { _IsAPXR2 = value; } }
    public virtual int IsAPXR3 { get { return _IsAPXR3; } set { _IsAPXR3 = value; } }
    public virtual int IsAPXR4 { get { return _IsAPXR4; } set { _IsAPXR4 = value; } }
    public virtual int IsAPXL1 { get { return _IsAPXL1; } set { _IsAPXL1 = value; } }
    public virtual int IsAPXL2 { get { return _IsAPXL2; } set { _IsAPXL2 = value; } }
    public virtual int IsAPXL3 { get { return _IsAPXL3; } set { _IsAPXL3 = value; } }
    public virtual int IsAPXL4 { get { return _IsAPXL4; } set { _IsAPXL4 = value; } }
    public virtual string APXLevelR1 { get { return _APXLevelR1; } set { _APXLevelR1 = value; } }
    public virtual string APXLevelR2 { get { return _APXLevelR2; } set { _APXLevelR2 = value; } }
    public virtual string APXLevelR3 { get { return _APXLevelR3; } set { _APXLevelR3 = value; } }
    public virtual string APXLevelR4 { get { return _APXLevelR4; } set { _APXLevelR4 = value; } }
    public virtual string APXLevelL1 { get { return _APXLevelL1; } set { _APXLevelL1 = value; } }
    public virtual string APXLevelL2 { get { return _APXLevelL2; } set { _APXLevelL2 = value; } }
    public virtual string APXLevelL3 { get { return _APXLevelL3; } set { _APXLevelL3 = value; } }
    public virtual string APXLevelL4 { get { return _APXLevelL4; } set { _APXLevelL4 = value; } }
    public virtual string APXDegree1 { get { return _APXDegree1; } set { _APXDegree1 = value; } }
    public virtual string APXDegree2 { get { return _APXDegree2; } set { _APXDegree2 = value; } }
    public virtual string APXDegree3 { get { return _APXDegree3; } set { _APXDegree3 = value; } }
    public virtual string APXDegree4 { get { return _APXDegree4; } set { _APXDegree4 = value; } }
    public virtual string APXBand1 { get { return _APXBand1; } set { _APXBand1 = value; } }
    public virtual string APXBand2 { get { return _APXBand2; } set { _APXBand2 = value; } }
    public virtual string APXBand3 { get { return _APXBand3; } set { _APXBand3 = value; } }
    public virtual string APXBand4 { get { return _APXBand4; } set { _APXBand4 = value; } }
    public virtual string LatXRayDegree1 { get { return _LatXRayDegree1; } set { _LatXRayDegree1 = value; } }
    public virtual string LatXRayDegree2 { get { return _LatXRayDegree2; } set { _LatXRayDegree2 = value; } }
    public virtual string LatXRayDegree3 { get { return _LatXRayDegree3; } set { _LatXRayDegree3 = value; } }
    public virtual string LatXRayDegree4 { get { return _LatXRayDegree4; } set { _LatXRayDegree4 = value; } }
    public virtual string LatXRayDegree5 { get { return _LatXRayDegree5; } set { _LatXRayDegree5 = value; } }
    public virtual string LatXRayFlex1 { get { return _LatXRayFlex1; } set { _LatXRayFlex1 = value; } }
    public virtual string LatXRayFlex2 { get { return _LatXRayFlex2; } set { _LatXRayFlex2 = value; } }
    public virtual string LatXRayFlex3 { get { return _LatXRayFlex3; } set { _LatXRayFlex3 = value; } }
    public virtual string LatXRayFlex4 { get { return _LatXRayFlex4; } set { _LatXRayFlex4 = value; } }
    public virtual string LatXRayFlex5 { get { return _LatXRayFlex5; } set { _LatXRayFlex5 = value; } }
    public virtual string LatXRayLocKyphosis { get { return _LatXRayLocKyphosis; } set { _LatXRayLocKyphosis = value; } }
    public virtual string IsLanke { get { return _IsLanke; } set { _IsLanke = value; } }
    public virtual string IsSRSCurveRiser { get { return _IsSRSCurveRiser; } set { _IsSRSCurveRiser = value; } }
    public virtual string IsSRSCurveTRC { get { return _IsSRSCurveTRC; } set { _IsSRSCurveTRC = value; } }
    public virtual string T1TiltAngle { get { return _T1TiltAngle; } set { _T1TiltAngle = value; } }
    public virtual string ClavicleAngle { get { return _ClavicleAngle; } set { _ClavicleAngle = value; } }
    public virtual string ShoulderHeight { get { return _ShoulderHeight; } set { _ShoulderHeight = value; } }
    public virtual string TrunkShift { get { return _TrunkShift; } set { _TrunkShift = value; } }
    public virtual string UIVAngulation { get { return _UIVAngulation; } set { _UIVAngulation = value; } }
    public virtual string EIVAngulation { get { return _EIVAngulation; } set { _EIVAngulation = value; } }
    public virtual string CoronalBalance { get { return _CoronalBalance; } set { _CoronalBalance = value; } }
    public virtual string DiscAngulation { get { return _DiscAngulation; } set { _DiscAngulation = value; } }
    public virtual string PelvicObliquity { get { return _PelvicObliquity; } set { _PelvicObliquity = value; } }
    public virtual string SacralObliquity { get { return _SacralObliquity; } set { _SacralObliquity = value; } }
    public virtual string SVA { get { return _SVA; } set { _SVA = value; } }
    public virtual string SacralSlope { get { return _SacralSlope; } set { _SacralSlope = value; } }
    public virtual string PelvicTilt { get { return _PelvicTilt; } set { _PelvicTilt = value; } }
    public virtual string PelvicIncidence { get { return _PelvicIncidence; } set { _PelvicIncidence = value; } }
    public virtual string PJKAbove1 { get { return _PJKAbove1; } set { _PJKAbove1 = value; } }
    public virtual string PJKAbove2 { get { return _PJKAbove2; } set { _PJKAbove2 = value; } }
    public virtual string DJKAbove1 { get { return _DJKAbove1; } set { _DJKAbove1 = value; } }
    public virtual string DJKAbove2 { get { return _DJKAbove2; } set { _DJKAbove2 = value; } }
    public virtual int IsFamilyHistoryYes { get { return _IsFamilyHistoryYes; } set { _IsFamilyHistoryYes = value; } }
    public virtual int IsFamilyHistoryNo { get { return _IsFamilyHistoryNo; } set { _IsFamilyHistoryNo = value; } }
    public virtual int IsPaternal { get { return _IsPaternal; } set { _IsPaternal = value; } }
    public virtual int IsMaternal { get { return _IsMaternal; } set { _IsMaternal = value; } }
    public virtual int IsGrandParents { get { return _IsGrandParents; } set { _IsGrandParents = value; } }
    public virtual int IsAuntUncle { get { return _IsAuntUncle; } set { _IsAuntUncle = value; } }
    public virtual int IsBrotherSister { get { return _IsBrotherSister; } set { _IsBrotherSister = value; } }
    public virtual int IsParents { get { return _IsParents; } set { _IsParents = value; } }
    public virtual int IsCousin { get { return _IsCousin; } set { _IsCousin = value; } }
    public virtual string LevPhyLabor { get { return _LevPhyLabor; } set { _LevPhyLabor = value; } }
    public virtual string IsSmoke { get { return _IsSmoke; } set { _IsSmoke = value; } }
    public virtual string SmokeTimes { get { return _SmokeTimes; } set { _SmokeTimes = value; } }
    public virtual int IsCurrent { get { return _IsCurrent; } set { _IsCurrent = value; } }
    public virtual int IsComplete { get { return _IsComplete; } set { _IsComplete = value; } }
    public virtual string IsCurrentType { get { return _IsCurrentType; } set { _IsCurrentType = value; } }
    public virtual string IsCompletePurpose { get { return _IsCompletePurpose; } set { _IsCompletePurpose = value; } }
    public virtual int IsSRS22r { get { return _IsSRS22r; } set { _IsSRS22r = value; } }
    public virtual int IsVASNeck { get { return _IsVASNeck; } set { _IsVASNeck = value; } }
    public virtual int IsVASBack { get { return _IsVASBack; } set { _IsVASBack = value; } }
    public virtual int IsVASLeg { get { return _IsVASLeg; } set { _IsVASLeg = value; } }
    public virtual int IsSF36 { get { return _IsSF36; } set { _IsSF36 = value; } }
    public virtual string Function { get { return _Function; } set { _Function = value; } }
    public virtual string Pain { get { return _Pain; } set { _Pain = value; } }
    public virtual string SelfImage { get { return _SelfImage; } set { _SelfImage = value; } }
    public virtual string MentalHealth { get { return _MentalHealth; } set { _MentalHealth = value; } }
    public virtual string Satisfaction { get { return _Satisfaction; } set { _Satisfaction = value; } }
    public virtual string Physical { get { return _Physical; } set { _Physical = value; } }
    public virtual string Mental { get { return _Mental; } set { _Mental = value; } }
    public virtual string Total { get { return _Total; } set { _Total = value; } }
    public virtual int IsODI { get { return _IsODI; } set { _IsODI = value; } }
    public virtual int IsNDI { get { return _IsNDI; } set { _IsNDI = value; } }
    public virtual int IsSAQPat { get { return _IsSAQPat; } set { _IsSAQPat = value; } }
    public virtual int IsSAQPar { get { return _IsSAQPar; } set { _IsSAQPar = value; } }
    public virtual int IsLumberIndex { get { return _IsLumberIndex; } set { _IsLumberIndex = value; } }
    public virtual string Score0 { get { return _Score0; } set { _Score0 = value; } }
    public virtual string Score1 { get { return _Score1; } set { _Score1 = value; } }
    public virtual string Score2 { get { return _Score2; } set { _Score2 = value; } }
    public virtual string Score3 { get { return _Score3; } set { _Score3 = value; } }
    public virtual string Score4 { get { return _Score4; } set { _Score4 = value; } }
    public virtual string StandingHeight { get { return _StandingHeight; } set { _StandingHeight = value; } }
    public virtual string SittingHeight { get { return _SittingHeight; } set { _SittingHeight = value; } }
    public virtual string Weight { get { return _Weight; } set { _Weight = value; } }
    public virtual string ArmSpan { get { return _ArmSpan; } set { _ArmSpan = value; } }
    public virtual string General { get { return _General; } set { _General = value; } }
    public virtual int IsATRThoracicNone { get { return _IsATRThoracicNone; } set { _IsATRThoracicNone = value; } }
    public virtual int IsATRThoracicR { get { return _IsATRThoracicR; } set { _IsATRThoracicR = value; } }
    public virtual int IsATRThoracicL { get { return _IsATRThoracicL; } set { _IsATRThoracicL = value; } }
    public virtual string ATRThoracicR { get { return _ATRThoracicR; } set { _ATRThoracicR = value; } }
    public virtual string ATRThoracicL { get { return _ATRThoracicL; } set { _ATRThoracicL = value; } }
    public virtual int IsATRThoracolumbarNone { get { return _IsATRThoracolumbarNone; } set { _IsATRThoracolumbarNone = value; } }
    public virtual int IsATRThoracolumbarR { get { return _IsATRThoracolumbarR; } set { _IsATRThoracolumbarR = value; } }
    public virtual int IsATRThoracolumbarL { get { return _IsATRThoracolumbarL; } set { _IsATRThoracolumbarL = value; } }
    public virtual string ATRThoracolumbarR { get { return _ATRThoracolumbarR; } set { _ATRThoracolumbarR = value; } }
    public virtual string ATRThoracolumbarL { get { return _ATRThoracolumbarL; } set { _ATRThoracolumbarL = value; } }
    public virtual int IsPlumbLineNone { get { return _IsPlumbLineNone; } set { _IsPlumbLineNone = value; } }
    public virtual int IsPlumbLineR { get { return _IsPlumbLineR; } set { _IsPlumbLineR = value; } }
    public virtual int IsPlumbLineL { get { return _IsPlumbLineL; } set { _IsPlumbLineL = value; } }
    public virtual string PlumbLineR { get { return _PlumbLineR; } set { _PlumbLineR = value; } }
    public virtual string PlumbLineL { get { return _PlumbLineL; } set { _PlumbLineL = value; } }
    public virtual int IsLegLengthNone { get { return _IsLegLengthNone; } set { _IsLegLengthNone = value; } }
    public virtual int IsLegLengthR { get { return _IsLegLengthR; } set { _IsLegLengthR = value; } }
    public virtual int IsLegLengthL { get { return _IsLegLengthL; } set { _IsLegLengthL = value; } }
    public virtual string LegLengthR { get { return _LegLengthR; } set { _LegLengthR = value; } }
    public virtual string LegLengthL { get { return _LegLengthL; } set { _LegLengthL = value; } }
    public virtual int IsShoulderNone { get { return _IsShoulderNone; } set { _IsShoulderNone = value; } }
    public virtual int IsShoulderR { get { return _IsShoulderR; } set { _IsShoulderR = value; } }
    public virtual int IsShoulderL { get { return _IsShoulderL; } set { _IsShoulderL = value; } }
    public virtual string ShoulderR { get { return _ShoulderR; } set { _ShoulderR = value; } }
    public virtual string ShoulderL { get { return _ShoulderL; } set { _ShoulderL = value; } }
    public virtual string IsBracing { get { return _IsBracing; } set { _IsBracing = value; } }
    public virtual string IsChiropractor { get { return _IsChiropractor; } set { _IsChiropractor = value; } }
    public virtual string IsInjections { get { return _IsInjections; } set { _IsInjections = value; } }
    public virtual string IsNSAIDS { get { return _IsNSAIDS; } set { _IsNSAIDS = value; } }
    public virtual string IsNarcotics { get { return _IsNarcotics; } set { _IsNarcotics = value; } }
    public virtual string IsPainProgram { get { return _IsPainProgram; } set { _IsPainProgram = value; } }
    public virtual string IsPhysicalTherapy { get { return _IsPhysicalTherapy; } set { _IsPhysicalTherapy = value; } }
    public virtual string IsOther { get { return _IsOther; } set { _IsOther = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_spine_analysis_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vCheifComplaint", Util.GetString(CheifComplaint)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWorkStatus", Util.GetString(IsWorkStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vReviewOfSystem", Util.GetString(ReviewOfSystem)));
            cmd.Parameters.Add(new MySqlParameter("@vPreviousSurgery", Util.GetString(PreviousSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR1", Util.GetInt(IsAPXR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR2", Util.GetInt(IsAPXR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR3", Util.GetInt(IsAPXR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR4", Util.GetInt(IsAPXR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL1", Util.GetInt(IsAPXL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL2", Util.GetInt(IsAPXL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL3", Util.GetInt(IsAPXL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL4", Util.GetInt(IsAPXL4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR1", Util.GetString(APXLevelR1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR2", Util.GetString(APXLevelR2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR3", Util.GetString(APXLevelR3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR4", Util.GetString(APXLevelR4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL1", Util.GetString(APXLevelL1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL2", Util.GetString(APXLevelL2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL3", Util.GetString(APXLevelL3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL4", Util.GetString(APXLevelL4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree1", Util.GetString(APXDegree1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree2", Util.GetString(APXDegree2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree3", Util.GetString(APXDegree3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree4", Util.GetString(APXDegree4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand1", Util.GetString(APXBand1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand2", Util.GetString(APXBand2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand3", Util.GetString(APXBand3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand4", Util.GetString(APXBand4)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree1", Util.GetString(LatXRayDegree1)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree2", Util.GetString(LatXRayDegree2)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree3", Util.GetString(LatXRayDegree3)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree4", Util.GetString(LatXRayDegree4)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree5", Util.GetString(LatXRayDegree5)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex1", Util.GetString(LatXRayFlex1)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex2", Util.GetString(LatXRayFlex2)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex3", Util.GetString(LatXRayFlex3)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex4", Util.GetString(LatXRayFlex4)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex5", Util.GetString(LatXRayFlex5)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayLocKyphosis", Util.GetString(LatXRayLocKyphosis)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLanke", Util.GetString(IsLanke)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSRSCurveRiser", Util.GetString(IsSRSCurveRiser)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSRSCurveTRC", Util.GetString(IsSRSCurveTRC)));
            cmd.Parameters.Add(new MySqlParameter("@vT1TiltAngle", Util.GetString(T1TiltAngle)));
            cmd.Parameters.Add(new MySqlParameter("@vClavicleAngle", Util.GetString(ClavicleAngle)));
            cmd.Parameters.Add(new MySqlParameter("@vShoulderHeight", Util.GetString(ShoulderHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vTrunkShift", Util.GetString(TrunkShift)));
            cmd.Parameters.Add(new MySqlParameter("@vUIVAngulation", Util.GetString(UIVAngulation)));
            cmd.Parameters.Add(new MySqlParameter("@vEIVAngulation", Util.GetString(EIVAngulation)));
            cmd.Parameters.Add(new MySqlParameter("@vCoronalBalance", Util.GetString(CoronalBalance)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscAngulation", Util.GetString(DiscAngulation)));
            cmd.Parameters.Add(new MySqlParameter("@vPelvicObliquity", Util.GetString(PelvicObliquity)));
            cmd.Parameters.Add(new MySqlParameter("@vSacralObliquity", Util.GetString(SacralObliquity)));
            cmd.Parameters.Add(new MySqlParameter("@vSVA", Util.GetString(SVA)));
            cmd.Parameters.Add(new MySqlParameter("@vSacralSlope", Util.GetString(SacralSlope)));
            cmd.Parameters.Add(new MySqlParameter("@vPelvicTilt", Util.GetString(PelvicTilt)));
            cmd.Parameters.Add(new MySqlParameter("@vPelvicIncidence", Util.GetString(PelvicIncidence)));
            cmd.Parameters.Add(new MySqlParameter("@vPJKAbove1", Util.GetString(PJKAbove1)));
            cmd.Parameters.Add(new MySqlParameter("@vPJKAbove2", Util.GetString(PJKAbove2)));
            cmd.Parameters.Add(new MySqlParameter("@vDJKAbove1", Util.GetString(DJKAbove1)));
            cmd.Parameters.Add(new MySqlParameter("@vDJKAbove2", Util.GetString(DJKAbove2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFamilyHistoryYes", Util.GetInt(IsFamilyHistoryYes)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFamilyHistoryNo", Util.GetInt(IsFamilyHistoryNo)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPaternal", Util.GetInt(IsPaternal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMaternal", Util.GetInt(IsMaternal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGrandParents", Util.GetInt(IsGrandParents)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAuntUncle", Util.GetInt(IsAuntUncle)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrotherSister", Util.GetInt(IsBrotherSister)));
            cmd.Parameters.Add(new MySqlParameter("@vIsParents", Util.GetInt(IsParents)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCousin", Util.GetInt(IsCousin)));
            cmd.Parameters.Add(new MySqlParameter("@vLevPhyLabor", Util.GetString(LevPhyLabor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSmoke", Util.GetString(IsSmoke)));
            cmd.Parameters.Add(new MySqlParameter("@vSmokeTimes", Util.GetString(SmokeTimes)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCurrent", Util.GetInt(IsCurrent)));
            cmd.Parameters.Add(new MySqlParameter("@vIsComplete", Util.GetInt(IsComplete)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCurrentType", Util.GetString(IsCurrentType)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletePurpose", Util.GetString(IsCompletePurpose)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSRS22r", Util.GetInt(IsSRS22r)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVASNeck", Util.GetInt(IsVASNeck)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVASBack", Util.GetInt(IsVASBack)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVASLeg", Util.GetInt(IsVASLeg)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSF36", Util.GetInt(IsSF36)));
            cmd.Parameters.Add(new MySqlParameter("@vFunction", Util.GetString(Function)));
            cmd.Parameters.Add(new MySqlParameter("@vPain", Util.GetString(Pain)));
            cmd.Parameters.Add(new MySqlParameter("@vSelfImage", Util.GetString(SelfImage)));
            cmd.Parameters.Add(new MySqlParameter("@vMentalHealth", Util.GetString(MentalHealth)));
            cmd.Parameters.Add(new MySqlParameter("@vSatisfaction", Util.GetString(Satisfaction)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysical", Util.GetString(Physical)));
            cmd.Parameters.Add(new MySqlParameter("@vMental", Util.GetString(Mental)));
            cmd.Parameters.Add(new MySqlParameter("@vTotal", Util.GetString(Total)));
            cmd.Parameters.Add(new MySqlParameter("@vIsODI", Util.GetInt(IsODI)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNDI", Util.GetInt(IsNDI)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSAQPat", Util.GetInt(IsSAQPat)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSAQPar", Util.GetInt(IsSAQPar)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLumberIndex", Util.GetInt(IsLumberIndex)));
            cmd.Parameters.Add(new MySqlParameter("@vScore0", Util.GetString(Score0)));
            cmd.Parameters.Add(new MySqlParameter("@vScore1", Util.GetString(Score1)));
            cmd.Parameters.Add(new MySqlParameter("@vScore2", Util.GetString(Score2)));
            cmd.Parameters.Add(new MySqlParameter("@vScore3", Util.GetString(Score3)));
            cmd.Parameters.Add(new MySqlParameter("@vScore4", Util.GetString(Score4)));
            cmd.Parameters.Add(new MySqlParameter("@vStandingHeight", Util.GetString(StandingHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vSittingHeight", Util.GetString(SittingHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Util.GetString(Weight)));
            cmd.Parameters.Add(new MySqlParameter("@vArmSpan", Util.GetString(ArmSpan)));
            cmd.Parameters.Add(new MySqlParameter("@vGeneral", Util.GetString(General)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracicNone", Util.GetInt(IsATRThoracicNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracicR", Util.GetInt(IsATRThoracicR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracicL", Util.GetInt(IsATRThoracicL)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracicR", Util.GetString(ATRThoracicR)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracicL", Util.GetString(ATRThoracicL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracolumbarNone", Util.GetInt(IsATRThoracolumbarNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracolumbarR", Util.GetInt(IsATRThoracolumbarR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracolumbarL", Util.GetInt(IsATRThoracolumbarL)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracolumbarR", Util.GetString(ATRThoracolumbarR)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracolumbarL", Util.GetString(ATRThoracolumbarL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlumbLineNone", Util.GetInt(IsPlumbLineNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlumbLineR", Util.GetInt(IsPlumbLineR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlumbLineL", Util.GetInt(IsPlumbLineL)));
            cmd.Parameters.Add(new MySqlParameter("@vPlumbLineR", Util.GetString(PlumbLineR)));
            cmd.Parameters.Add(new MySqlParameter("@vPlumbLineL", Util.GetString(PlumbLineL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthNone", Util.GetInt(IsLegLengthNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthR", Util.GetInt(IsLegLengthR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthL", Util.GetInt(IsLegLengthL)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthR", Util.GetString(LegLengthR)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthL", Util.GetString(LegLengthL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoulderNone", Util.GetInt(IsShoulderNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoulderR", Util.GetInt(IsShoulderR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoulderL", Util.GetInt(IsShoulderL)));
            cmd.Parameters.Add(new MySqlParameter("@vShoulderR", Util.GetString(ShoulderR)));
            cmd.Parameters.Add(new MySqlParameter("@vShoulderL", Util.GetString(ShoulderL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBracing", Util.GetString(IsBracing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsChiropractor", Util.GetString(IsChiropractor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsInjections", Util.GetString(IsInjections)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNSAIDS", Util.GetString(IsNSAIDS)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNarcotics", Util.GetString(IsNarcotics)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPainProgram", Util.GetString(IsPainProgram)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPhysicalTherapy", Util.GetString(IsPhysicalTherapy)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOther", Util.GetString(IsOther)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

            Output = cmd.ExecuteScalar().ToString();

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


    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_spine_analysis_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vCheifComplaint", Util.GetString(CheifComplaint)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWorkStatus", Util.GetString(IsWorkStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vReviewOfSystem", Util.GetString(ReviewOfSystem)));
            cmd.Parameters.Add(new MySqlParameter("@vPreviousSurgery", Util.GetString(PreviousSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR1", Util.GetInt(IsAPXR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR2", Util.GetInt(IsAPXR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR3", Util.GetInt(IsAPXR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXR4", Util.GetInt(IsAPXR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL1", Util.GetInt(IsAPXL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL2", Util.GetInt(IsAPXL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL3", Util.GetInt(IsAPXL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAPXL4", Util.GetInt(IsAPXL4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR1", Util.GetString(APXLevelR1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR2", Util.GetString(APXLevelR2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR3", Util.GetString(APXLevelR3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelR4", Util.GetString(APXLevelR4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL1", Util.GetString(APXLevelL1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL2", Util.GetString(APXLevelL2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL3", Util.GetString(APXLevelL3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXLevelL4", Util.GetString(APXLevelL4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree1", Util.GetString(APXDegree1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree2", Util.GetString(APXDegree2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree3", Util.GetString(APXDegree3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXDegree4", Util.GetString(APXDegree4)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand1", Util.GetString(APXBand1)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand2", Util.GetString(APXBand2)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand3", Util.GetString(APXBand3)));
            cmd.Parameters.Add(new MySqlParameter("@vAPXBand4", Util.GetString(APXBand4)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree1", Util.GetString(LatXRayDegree1)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree2", Util.GetString(LatXRayDegree2)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree3", Util.GetString(LatXRayDegree3)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree4", Util.GetString(LatXRayDegree4)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayDegree5", Util.GetString(LatXRayDegree5)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex1", Util.GetString(LatXRayFlex1)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex2", Util.GetString(LatXRayFlex2)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex3", Util.GetString(LatXRayFlex3)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex4", Util.GetString(LatXRayFlex4)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayFlex5", Util.GetString(LatXRayFlex5)));
            cmd.Parameters.Add(new MySqlParameter("@vLatXRayLocKyphosis", Util.GetString(LatXRayLocKyphosis)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLanke", Util.GetString(IsLanke)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSRSCurveRiser", Util.GetString(IsSRSCurveRiser)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSRSCurveTRC", Util.GetString(IsSRSCurveTRC)));
            cmd.Parameters.Add(new MySqlParameter("@vT1TiltAngle", Util.GetString(T1TiltAngle)));
            cmd.Parameters.Add(new MySqlParameter("@vClavicleAngle", Util.GetString(ClavicleAngle)));
            cmd.Parameters.Add(new MySqlParameter("@vShoulderHeight", Util.GetString(ShoulderHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vTrunkShift", Util.GetString(TrunkShift)));
            cmd.Parameters.Add(new MySqlParameter("@vUIVAngulation", Util.GetString(UIVAngulation)));
            cmd.Parameters.Add(new MySqlParameter("@vEIVAngulation", Util.GetString(EIVAngulation)));
            cmd.Parameters.Add(new MySqlParameter("@vCoronalBalance", Util.GetString(CoronalBalance)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscAngulation", Util.GetString(DiscAngulation)));
            cmd.Parameters.Add(new MySqlParameter("@vPelvicObliquity", Util.GetString(PelvicObliquity)));
            cmd.Parameters.Add(new MySqlParameter("@vSacralObliquity", Util.GetString(SacralObliquity)));
            cmd.Parameters.Add(new MySqlParameter("@vSVA", Util.GetString(SVA)));
            cmd.Parameters.Add(new MySqlParameter("@vSacralSlope", Util.GetString(SacralSlope)));
            cmd.Parameters.Add(new MySqlParameter("@vPelvicTilt", Util.GetString(PelvicTilt)));
            cmd.Parameters.Add(new MySqlParameter("@vPelvicIncidence", Util.GetString(PelvicIncidence)));
            cmd.Parameters.Add(new MySqlParameter("@vPJKAbove1", Util.GetString(PJKAbove1)));
            cmd.Parameters.Add(new MySqlParameter("@vPJKAbove2", Util.GetString(PJKAbove2)));
            cmd.Parameters.Add(new MySqlParameter("@vDJKAbove1", Util.GetString(DJKAbove1)));
            cmd.Parameters.Add(new MySqlParameter("@vDJKAbove2", Util.GetString(DJKAbove2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFamilyHistoryYes", Util.GetInt(IsFamilyHistoryYes)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFamilyHistoryNo", Util.GetInt(IsFamilyHistoryNo)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPaternal", Util.GetInt(IsPaternal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMaternal", Util.GetInt(IsMaternal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGrandParents", Util.GetInt(IsGrandParents)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAuntUncle", Util.GetInt(IsAuntUncle)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrotherSister", Util.GetInt(IsBrotherSister)));
            cmd.Parameters.Add(new MySqlParameter("@vIsParents", Util.GetInt(IsParents)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCousin", Util.GetInt(IsCousin)));
            cmd.Parameters.Add(new MySqlParameter("@vLevPhyLabor", Util.GetString(LevPhyLabor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSmoke", Util.GetString(IsSmoke)));
            cmd.Parameters.Add(new MySqlParameter("@vSmokeTimes", Util.GetString(SmokeTimes)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCurrent", Util.GetInt(IsCurrent)));
            cmd.Parameters.Add(new MySqlParameter("@vIsComplete", Util.GetInt(IsComplete)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCurrentType", Util.GetString(IsCurrentType)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletePurpose", Util.GetString(IsCompletePurpose)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSRS22r", Util.GetInt(IsSRS22r)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVASNeck", Util.GetInt(IsVASNeck)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVASBack", Util.GetInt(IsVASBack)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVASLeg", Util.GetInt(IsVASLeg)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSF36", Util.GetInt(IsSF36)));
            cmd.Parameters.Add(new MySqlParameter("@vFunction", Util.GetString(Function)));
            cmd.Parameters.Add(new MySqlParameter("@vPain", Util.GetString(Pain)));
            cmd.Parameters.Add(new MySqlParameter("@vSelfImage", Util.GetString(SelfImage)));
            cmd.Parameters.Add(new MySqlParameter("@vMentalHealth", Util.GetString(MentalHealth)));
            cmd.Parameters.Add(new MySqlParameter("@vSatisfaction", Util.GetString(Satisfaction)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysical", Util.GetString(Physical)));
            cmd.Parameters.Add(new MySqlParameter("@vMental", Util.GetString(Mental)));
            cmd.Parameters.Add(new MySqlParameter("@vTotal", Util.GetString(Total)));
            cmd.Parameters.Add(new MySqlParameter("@vIsODI", Util.GetInt(IsODI)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNDI", Util.GetInt(IsNDI)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSAQPat", Util.GetInt(IsSAQPat)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSAQPar", Util.GetInt(IsSAQPar)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLumberIndex", Util.GetInt(IsLumberIndex)));
            cmd.Parameters.Add(new MySqlParameter("@vScore0", Util.GetString(Score0)));
            cmd.Parameters.Add(new MySqlParameter("@vScore1", Util.GetString(Score1)));
            cmd.Parameters.Add(new MySqlParameter("@vScore2", Util.GetString(Score2)));
            cmd.Parameters.Add(new MySqlParameter("@vScore3", Util.GetString(Score3)));
            cmd.Parameters.Add(new MySqlParameter("@vScore4", Util.GetString(Score4)));
            cmd.Parameters.Add(new MySqlParameter("@vStandingHeight", Util.GetString(StandingHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vSittingHeight", Util.GetString(SittingHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Util.GetString(Weight)));
            cmd.Parameters.Add(new MySqlParameter("@vArmSpan", Util.GetString(ArmSpan)));
            cmd.Parameters.Add(new MySqlParameter("@vGeneral", Util.GetString(General)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracicNone", Util.GetInt(IsATRThoracicNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracicR", Util.GetInt(IsATRThoracicR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracicL", Util.GetInt(IsATRThoracicL)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracicR", Util.GetString(ATRThoracicR)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracicL", Util.GetString(ATRThoracicL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracolumbarNone", Util.GetInt(IsATRThoracolumbarNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracolumbarR", Util.GetInt(IsATRThoracolumbarR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsATRThoracolumbarL", Util.GetInt(IsATRThoracolumbarL)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracolumbarR", Util.GetString(ATRThoracolumbarR)));
            cmd.Parameters.Add(new MySqlParameter("@vATRThoracolumbarL", Util.GetString(ATRThoracolumbarL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlumbLineNone", Util.GetInt(IsPlumbLineNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlumbLineR", Util.GetInt(IsPlumbLineR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlumbLineL", Util.GetInt(IsPlumbLineL)));
            cmd.Parameters.Add(new MySqlParameter("@vPlumbLineR", Util.GetString(PlumbLineR)));
            cmd.Parameters.Add(new MySqlParameter("@vPlumbLineL", Util.GetString(PlumbLineL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthNone", Util.GetInt(IsLegLengthNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthR", Util.GetInt(IsLegLengthR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthL", Util.GetInt(IsLegLengthL)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthR", Util.GetString(LegLengthR)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthL", Util.GetString(LegLengthL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoulderNone", Util.GetInt(IsShoulderNone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoulderR", Util.GetInt(IsShoulderR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoulderL", Util.GetInt(IsShoulderL)));
            cmd.Parameters.Add(new MySqlParameter("@vShoulderR", Util.GetString(ShoulderR)));
            cmd.Parameters.Add(new MySqlParameter("@vShoulderL", Util.GetString(ShoulderL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBracing", Util.GetString(IsBracing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsChiropractor", Util.GetString(IsChiropractor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsInjections", Util.GetString(IsInjections)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNSAIDS", Util.GetString(IsNSAIDS)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNarcotics", Util.GetString(IsNarcotics)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPainProgram", Util.GetString(IsPainProgram)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPhysicalTherapy", Util.GetString(IsPhysicalTherapy)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOther", Util.GetString(IsOther)));
            //cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

            //Output = cmd.ExecuteScalar().ToString();
            Output = cmd.ExecuteNonQuery().ToString();

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
