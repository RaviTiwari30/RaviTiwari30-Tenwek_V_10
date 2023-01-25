using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class cpoe_hip_analysis
{
    public cpoe_hip_analysis()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_hip_analysis(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _IsHip;
    private string _IsClinicVisit;
    private int _IsPlainR0;
    private int _IsPlainR1;
    private int _IsPlainR2;
    private int _IsPlainR3;
    private int _IsPlainR4;
    private int _IsPlainR5;
    private int _IsPlainL0;
    private int _IsPlainL1;
    private int _IsPlainL2;
    private int _IsPlainL3;
    private int _IsPlainL4;
    private int _IsPlainL5;
    private int _IsLimpR0;
    private int _IsLimpR1;
    private int _IsLimpR2;
    private int _IsLimpR3;
    private int _IsLimpL0;
    private int _IsLimpL1;
    private int _IsLimpL2;
    private int _IsLimpL3;
    private int _IsSupportR0;
    private int _IsSupportR1;
    private int _IsSupportR2;
    private int _IsSupportR3;
    private int _IsSupportR4;
    private int _IsSupportR5;
    private int _IsSupportL0;
    private int _IsSupportL1;
    private int _IsSupportL2;
    private int _IsSupportL3;
    private int _IsSupportL4;
    private int _IsSupportL5;
    private int _IsDistanceR0;
    private int _IsDistanceR1;
    private int _IsDistanceR2;
    private int _IsDistanceR3;
    private int _IsDistanceR4;
    private int _IsDistanceL0;
    private int _IsDistanceL1;
    private int _IsDistanceL2;
    private int _IsDistanceL3;
    private int _IsDistanceL4;
    private int _IsStairsR0;
    private int _IsStairsR1;
    private int _IsStairsR2;
    private int _IsStairsR3;
    private int _IsStairsL0;
    private int _IsStairsL1;
    private int _IsStairsL2;
    private int _IsStairsL3;
    private int _IsShoesR0;
    private int _IsShoesR1;
    private int _IsShoesR2;
    private int _IsShoesL0;
    private int _IsShoesL1;
    private int _IsShoesL2;
    private int _IsSittingR0;
    private int _IsSittingR1;
    private int _IsSittingR2;
    private int _IsSittingL0;
    private int _IsSittingL1;
    private int _IsSittingL2;
    private int _IsTransportationR0;
    private int _IsTransportationR1;
    private int _IsTransportationL0;
    private int _IsTransportationL1;
    private string _ROMFlexlonR1;
    private string _ROMFlexlonR2;
    private string _ROMFlexlonR3;
    private string _ROMFlexlonL1;
    private string _ROMFlexlonL2;
    private string _ROMFlexlonL3;
    private string _ROMFlexlonContR1;
    private string _ROMFlexlonContR2;
    private string _ROMFlexlonContL1;
    private string _ROMFlexlonContL2;
    private string _ROMExternalR1;
    private string _RomExternalR2;
    private string _RomExternalL1;
    private string _RomExternalL2;
    private string _ROMInternalR1;
    private string _ROMInternalR2;
    private string _ROMInternalL1;
    private string _ROMInternalL2;
    private string _ROMAbductionR1;
    private string _ROMAbductionR2;
    private string _ROMAbductionL1;
    private string _ROMAbductionL2;
    private string _ROMAdductionR1;
    private string _ROMAdductionR2;
    private string _ROMAdductionL1;
    private string _ROMAdductionL2;
    private string _IsROMRight;
    private string _IsROMLeft;
    private string _InclusionLengthR1;
    private string _InclusionLengthR2;
    private string _InclusionLengthR3;
    private string _InclusionLengthL1;
    private string _InclusionLengthL2;
    private string _InclusionLengthL3;
    private string _IsLegLengthDiscrepancy;
    private string _LegLengthDiscrepancy1;
    private string _LegLengthDiscrepancy2;
    private string _LegLengthDiscrepancy3;
    private string _IsThighPainRight;
    private string _IsThighPainLeft;
    private string _IsGroinPainRight;
    private string _IsGroinPainLeft;
    private string _IsCharnleyClassification;
    private string _IsRadioGraphicAnalysis;
    private string _FIlmAnalysisR;
    private string _FilmAnalysisL;
    private string _IsBrookerClassificationR;
    private string _IsBrookerClassificationL;
    private string _IsCementClassificationR;
    private string _IsCementClassificationL;
    private string _IsRLAceR;
    private string _IsRLAceL;
    private string _IsRLAceScrewR;
    private string _IsRLAceScrewL;
    private string _IsRLFemoralR;
    private string _IsRLFemoralL;
    private string _IsLooseAceR;
    private string _IsLooseAceL;
    private string _IsLooseFemoralR;
    private string _IsLooseFemoralL;
    private string _UserID;
    private DateTime _EntryDate;
    private string _UpdateBy;
    private DateTime _UpdateDate;
    private int _IsFilmAnalysisNoneR;
    private int _IsFilmAnalysisNoneL;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string IsHip { get { return _IsHip; } set { _IsHip = value; } }
    public virtual string IsClinicVisit { get { return _IsClinicVisit; } set { _IsClinicVisit = value; } }
    public virtual int IsPlainR0 { get { return _IsPlainR0; } set { _IsPlainR0 = value; } }
    public virtual int IsPlainR1 { get { return _IsPlainR1; } set { _IsPlainR1 = value; } }
    public virtual int IsPlainR2 { get { return _IsPlainR2; } set { _IsPlainR2 = value; } }
    public virtual int IsPlainR3 { get { return _IsPlainR3; } set { _IsPlainR3 = value; } }
    public virtual int IsPlainR4 { get { return _IsPlainR4; } set { _IsPlainR4 = value; } }
    public virtual int IsPlainR5 { get { return _IsPlainR5; } set { _IsPlainR5 = value; } }
    public virtual int IsPlainL0 { get { return _IsPlainL0; } set { _IsPlainL0 = value; } }
    public virtual int IsPlainL1 { get { return _IsPlainL1; } set { _IsPlainL1 = value; } }
    public virtual int IsPlainL2 { get { return _IsPlainL2; } set { _IsPlainL2 = value; } }
    public virtual int IsPlainL3 { get { return _IsPlainL3; } set { _IsPlainL3 = value; } }
    public virtual int IsPlainL4 { get { return _IsPlainL4; } set { _IsPlainL4 = value; } }
    public virtual int IsPlainL5 { get { return _IsPlainL5; } set { _IsPlainL5 = value; } }
    public virtual int IsLimpR0 { get { return _IsLimpR0; } set { _IsLimpR0 = value; } }
    public virtual int IsLimpR1 { get { return _IsLimpR1; } set { _IsLimpR1 = value; } }
    public virtual int IsLimpR2 { get { return _IsLimpR2; } set { _IsLimpR2 = value; } }
    public virtual int IsLimpR3 { get { return _IsLimpR3; } set { _IsLimpR3 = value; } }
    public virtual int IsLimpL0 { get { return _IsLimpL0; } set { _IsLimpL0 = value; } }
    public virtual int IsLimpL1 { get { return _IsLimpL1; } set { _IsLimpL1 = value; } }
    public virtual int IsLimpL2 { get { return _IsLimpL2; } set { _IsLimpL2 = value; } }
    public virtual int IsLimpL3 { get { return _IsLimpL3; } set { _IsLimpL3 = value; } }
    public virtual int IsSupportR0 { get { return _IsSupportR0; } set { _IsSupportR0 = value; } }
    public virtual int IsSupportR1 { get { return _IsSupportR1; } set { _IsSupportR1 = value; } }
    public virtual int IsSupportR2 { get { return _IsSupportR2; } set { _IsSupportR2 = value; } }
    public virtual int IsSupportR3 { get { return _IsSupportR3; } set { _IsSupportR3 = value; } }
    public virtual int IsSupportR4 { get { return _IsSupportR4; } set { _IsSupportR4 = value; } }
    public virtual int IsSupportR5 { get { return _IsSupportR5; } set { _IsSupportR5 = value; } }
    public virtual int IsSupportL0 { get { return _IsSupportL0; } set { _IsSupportL0 = value; } }
    public virtual int IsSupportL1 { get { return _IsSupportL1; } set { _IsSupportL1 = value; } }
    public virtual int IsSupportL2 { get { return _IsSupportL2; } set { _IsSupportL2 = value; } }
    public virtual int IsSupportL3 { get { return _IsSupportL3; } set { _IsSupportL3 = value; } }
    public virtual int IsSupportL4 { get { return _IsSupportL4; } set { _IsSupportL4 = value; } }
    public virtual int IsSupportL5 { get { return _IsSupportL5; } set { _IsSupportL5 = value; } }
    public virtual int IsDistanceR0 { get { return _IsDistanceR0; } set { _IsDistanceR0 = value; } }
    public virtual int IsDistanceR1 { get { return _IsDistanceR1; } set { _IsDistanceR1 = value; } }
    public virtual int IsDistanceR2 { get { return _IsDistanceR2; } set { _IsDistanceR2 = value; } }
    public virtual int IsDistanceR3 { get { return _IsDistanceR3; } set { _IsDistanceR3 = value; } }
    public virtual int IsDistanceR4 { get { return _IsDistanceR4; } set { _IsDistanceR4 = value; } }
    public virtual int IsDistanceL0 { get { return _IsDistanceL0; } set { _IsDistanceL0 = value; } }
    public virtual int IsDistanceL1 { get { return _IsDistanceL1; } set { _IsDistanceL1 = value; } }
    public virtual int IsDistanceL2 { get { return _IsDistanceL2; } set { _IsDistanceL2 = value; } }
    public virtual int IsDistanceL3 { get { return _IsDistanceL3; } set { _IsDistanceL3 = value; } }
    public virtual int IsDistanceL4 { get { return _IsDistanceL4; } set { _IsDistanceL4 = value; } }
    public virtual int IsStairsR0 { get { return _IsStairsR0; } set { _IsStairsR0 = value; } }
    public virtual int IsStairsR1 { get { return _IsStairsR1; } set { _IsStairsR1 = value; } }
    public virtual int IsStairsR2 { get { return _IsStairsR2; } set { _IsStairsR2 = value; } }
    public virtual int IsStairsR3 { get { return _IsStairsR3; } set { _IsStairsR3 = value; } }
    public virtual int IsStairsL0 { get { return _IsStairsL0; } set { _IsStairsL0 = value; } }
    public virtual int IsStairsL1 { get { return _IsStairsL1; } set { _IsStairsL1 = value; } }
    public virtual int IsStairsL2 { get { return _IsStairsL2; } set { _IsStairsL2 = value; } }
    public virtual int IsStairsL3 { get { return _IsStairsL3; } set { _IsStairsL3 = value; } }
    public virtual int IsShoesR0 { get { return _IsShoesR0; } set { _IsShoesR0 = value; } }
    public virtual int IsShoesR1 { get { return _IsShoesR1; } set { _IsShoesR1 = value; } }
    public virtual int IsShoesR2 { get { return _IsShoesR2; } set { _IsShoesR2 = value; } }
    public virtual int IsShoesL0 { get { return _IsShoesL0; } set { _IsShoesL0 = value; } }
    public virtual int IsShoesL1 { get { return _IsShoesL1; } set { _IsShoesL1 = value; } }
    public virtual int IsShoesL2 { get { return _IsShoesL2; } set { _IsShoesL2 = value; } }
    public virtual int IsSittingR0 { get { return _IsSittingR0; } set { _IsSittingR0 = value; } }
    public virtual int IsSittingR1 { get { return _IsSittingR1; } set { _IsSittingR1 = value; } }
    public virtual int IsSittingR2 { get { return _IsSittingR2; } set { _IsSittingR2 = value; } }
    public virtual int IsSittingL0 { get { return _IsSittingL0; } set { _IsSittingL0 = value; } }
    public virtual int IsSittingL1 { get { return _IsSittingL1; } set { _IsSittingL1 = value; } }
    public virtual int IsSittingL2 { get { return _IsSittingL2; } set { _IsSittingL2 = value; } }
    public virtual int IsTransportationR0 { get { return _IsTransportationR0; } set { _IsTransportationR0 = value; } }
    public virtual int IsTransportationR1 { get { return _IsTransportationR1; } set { _IsTransportationR1 = value; } }
    public virtual int IsTransportationL0 { get { return _IsTransportationL0; } set { _IsTransportationL0 = value; } }
    public virtual int IsTransportationL1 { get { return _IsTransportationL1; } set { _IsTransportationL1 = value; } }
    public virtual string ROMFlexlonR1 { get { return _ROMFlexlonR1; } set { _ROMFlexlonR1 = value; } }
    public virtual string ROMFlexlonR2 { get { return _ROMFlexlonR2; } set { _ROMFlexlonR2 = value; } }
    public virtual string ROMFlexlonR3 { get { return _ROMFlexlonR3; } set { _ROMFlexlonR3 = value; } }
    public virtual string ROMFlexlonL1 { get { return _ROMFlexlonL1; } set { _ROMFlexlonL1 = value; } }
    public virtual string ROMFlexlonL2 { get { return _ROMFlexlonL2; } set { _ROMFlexlonL2 = value; } }
    public virtual string ROMFlexlonL3 { get { return _ROMFlexlonL3; } set { _ROMFlexlonL3 = value; } }
    public virtual string ROMFlexlonContR1 { get { return _ROMFlexlonContR1; } set { _ROMFlexlonContR1 = value; } }
    public virtual string ROMFlexlonContR2 { get { return _ROMFlexlonContR2; } set { _ROMFlexlonContR2 = value; } }
    public virtual string ROMFlexlonContL1 { get { return _ROMFlexlonContL1; } set { _ROMFlexlonContL1 = value; } }
    public virtual string ROMFlexlonContL2 { get { return _ROMFlexlonContL2; } set { _ROMFlexlonContL2 = value; } }
    public virtual string ROMExternalR1 { get { return _ROMExternalR1; } set { _ROMExternalR1 = value; } }
    public virtual string RomExternalR2 { get { return _RomExternalR2; } set { _RomExternalR2 = value; } }
    public virtual string RomExternalL1 { get { return _RomExternalL1; } set { _RomExternalL1 = value; } }
    public virtual string RomExternalL2 { get { return _RomExternalL2; } set { _RomExternalL2 = value; } }
    public virtual string ROMInternalR1 { get { return _ROMInternalR1; } set { _ROMInternalR1 = value; } }
    public virtual string ROMInternalR2 { get { return _ROMInternalR2; } set { _ROMInternalR2 = value; } }
    public virtual string ROMInternalL1 { get { return _ROMInternalL1; } set { _ROMInternalL1 = value; } }
    public virtual string ROMInternalL2 { get { return _ROMInternalL2; } set { _ROMInternalL2 = value; } }
    public virtual string ROMAbductionR1 { get { return _ROMAbductionR1; } set { _ROMAbductionR1 = value; } }
    public virtual string ROMAbductionR2 { get { return _ROMAbductionR2; } set { _ROMAbductionR2 = value; } }
    public virtual string ROMAbductionL1 { get { return _ROMAbductionL1; } set { _ROMAbductionL1 = value; } }
    public virtual string ROMAbductionL2 { get { return _ROMAbductionL2; } set { _ROMAbductionL2 = value; } }
    public virtual string ROMAdductionR1 { get { return _ROMAdductionR1; } set { _ROMAdductionR1 = value; } }
    public virtual string ROMAdductionR2 { get { return _ROMAdductionR2; } set { _ROMAdductionR2 = value; } }
    public virtual string ROMAdductionL1 { get { return _ROMAdductionL1; } set { _ROMAdductionL1 = value; } }
    public virtual string ROMAdductionL2 { get { return _ROMAdductionL2; } set { _ROMAdductionL2 = value; } }
    public virtual string IsROMRight { get { return _IsROMRight; } set { _IsROMRight = value; } }
    public virtual string IsROMLeft { get { return _IsROMLeft; } set { _IsROMLeft = value; } }
    public virtual string InclusionLengthR1 { get { return _InclusionLengthR1; } set { _InclusionLengthR1 = value; } }
    public virtual string InclusionLengthR2 { get { return _InclusionLengthR2; } set { _InclusionLengthR2 = value; } }
    public virtual string InclusionLengthR3 { get { return _InclusionLengthR3; } set { _InclusionLengthR3 = value; } }
    public virtual string InclusionLengthL1 { get { return _InclusionLengthL1; } set { _InclusionLengthL1 = value; } }
    public virtual string InclusionLengthL2 { get { return _InclusionLengthL2; } set { _InclusionLengthL2 = value; } }
    public virtual string InclusionLengthL3 { get { return _InclusionLengthL3; } set { _InclusionLengthL3 = value; } }
    public virtual string IsLegLengthDiscrepancy { get { return _IsLegLengthDiscrepancy; } set { _IsLegLengthDiscrepancy = value; } }
    public virtual string LegLengthDiscrepancy1 { get { return _LegLengthDiscrepancy1; } set { _LegLengthDiscrepancy1 = value; } }
    public virtual string LegLengthDiscrepancy2 { get { return _LegLengthDiscrepancy2; } set { _LegLengthDiscrepancy2 = value; } }
    public virtual string LegLengthDiscrepancy3 { get { return _LegLengthDiscrepancy3; } set { _LegLengthDiscrepancy3 = value; } }
    public virtual string IsThighPainRight { get { return _IsThighPainRight; } set { _IsThighPainRight = value; } }
    public virtual string IsThighPainLeft { get { return _IsThighPainLeft; } set { _IsThighPainLeft = value; } }
    public virtual string IsGroinPainRight { get { return _IsGroinPainRight; } set { _IsGroinPainRight = value; } }
    public virtual string IsGroinPainLeft { get { return _IsGroinPainLeft; } set { _IsGroinPainLeft = value; } }
    public virtual string IsCharnleyClassification { get { return _IsCharnleyClassification; } set { _IsCharnleyClassification = value; } }
    public virtual string IsRadioGraphicAnalysis { get { return _IsRadioGraphicAnalysis; } set { _IsRadioGraphicAnalysis = value; } }
    public virtual string FIlmAnalysisR { get { return _FIlmAnalysisR; } set { _FIlmAnalysisR = value; } }
    public virtual string FilmAnalysisL { get { return _FilmAnalysisL; } set { _FilmAnalysisL = value; } }
    public virtual string IsBrookerClassificationR { get { return _IsBrookerClassificationR; } set { _IsBrookerClassificationR = value; } }
    public virtual string IsBrookerClassificationL { get { return _IsBrookerClassificationL; } set { _IsBrookerClassificationL = value; } }
    public virtual string IsCementClassificationR { get { return _IsCementClassificationR; } set { _IsCementClassificationR = value; } }
    public virtual string IsCementClassificationL { get { return _IsCementClassificationL; } set { _IsCementClassificationL = value; } }
    public virtual string IsRLAceR { get { return _IsRLAceR; } set { _IsRLAceR = value; } }
    public virtual string IsRLAceL { get { return _IsRLAceL; } set { _IsRLAceL = value; } }
    public virtual string IsRLAceScrewR { get { return _IsRLAceScrewR; } set { _IsRLAceScrewR = value; } }
    public virtual string IsRLAceScrewL { get { return _IsRLAceScrewL; } set { _IsRLAceScrewL = value; } }
    public virtual string IsRLFemoralR { get { return _IsRLFemoralR; } set { _IsRLFemoralR = value; } }
    public virtual string IsRLFemoralL { get { return _IsRLFemoralL; } set { _IsRLFemoralL = value; } }
    public virtual string IsLooseAceR { get { return _IsLooseAceR; } set { _IsLooseAceR = value; } }
    public virtual string IsLooseAceL { get { return _IsLooseAceL; } set { _IsLooseAceL = value; } }
    public virtual string IsLooseFemoralR { get { return _IsLooseFemoralR; } set { _IsLooseFemoralR = value; } }
    public virtual string IsLooseFemoralL { get { return _IsLooseFemoralL; } set { _IsLooseFemoralL = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }
    public virtual int IsFilmAnalysisNoneR { get { return _IsFilmAnalysisNoneR; } set { _IsFilmAnalysisNoneR = value; } }
    public virtual int IsFilmAnalysisNoneL { get { return _IsFilmAnalysisNoneL; } set { _IsFilmAnalysisNoneL = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_hip_analysis_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsHip", Util.GetString(IsHip)));
            cmd.Parameters.Add(new MySqlParameter("@vIsClinicVisit", Util.GetString(IsClinicVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR0", Util.GetInt(IsPlainR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR1", Util.GetInt(IsPlainR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR2", Util.GetInt(IsPlainR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR3", Util.GetInt(IsPlainR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR4", Util.GetInt(IsPlainR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR5", Util.GetInt(IsPlainR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL0", Util.GetInt(IsPlainL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL1", Util.GetInt(IsPlainL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL2", Util.GetInt(IsPlainL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL3", Util.GetInt(IsPlainL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL4", Util.GetInt(IsPlainL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL5", Util.GetInt(IsPlainL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR0", Util.GetInt(IsLimpR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR1", Util.GetInt(IsLimpR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR2", Util.GetInt(IsLimpR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR3", Util.GetInt(IsLimpR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL0", Util.GetInt(IsLimpL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL1", Util.GetInt(IsLimpL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL2", Util.GetInt(IsLimpL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL3", Util.GetInt(IsLimpL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR0", Util.GetInt(IsSupportR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR1", Util.GetInt(IsSupportR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR2", Util.GetInt(IsSupportR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR3", Util.GetInt(IsSupportR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR4", Util.GetInt(IsSupportR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR5", Util.GetInt(IsSupportR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL0", Util.GetInt(IsSupportL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL1", Util.GetInt(IsSupportL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL2", Util.GetInt(IsSupportL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL3", Util.GetInt(IsSupportL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL4", Util.GetInt(IsSupportL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL5", Util.GetInt(IsSupportL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR0", Util.GetInt(IsDistanceR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR1", Util.GetInt(IsDistanceR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR2", Util.GetInt(IsDistanceR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR3", Util.GetInt(IsDistanceR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR4", Util.GetInt(IsDistanceR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL0", Util.GetInt(IsDistanceL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL1", Util.GetInt(IsDistanceL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL2", Util.GetInt(IsDistanceL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL3", Util.GetInt(IsDistanceL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL4", Util.GetInt(IsDistanceL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR0", Util.GetInt(IsStairsR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR1", Util.GetInt(IsStairsR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR2", Util.GetInt(IsStairsR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR3", Util.GetInt(IsStairsR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL0", Util.GetInt(IsStairsL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL1", Util.GetInt(IsStairsL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL2", Util.GetInt(IsStairsL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL3", Util.GetInt(IsStairsL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesR0", Util.GetInt(IsShoesR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesR1", Util.GetInt(IsShoesR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesR2", Util.GetInt(IsShoesR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesL0", Util.GetInt(IsShoesL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesL1", Util.GetInt(IsShoesL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesL2", Util.GetInt(IsShoesL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingR0", Util.GetInt(IsSittingR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingR1", Util.GetInt(IsSittingR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingR2", Util.GetInt(IsSittingR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingL0", Util.GetInt(IsSittingL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingL1", Util.GetInt(IsSittingL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingL2", Util.GetInt(IsSittingL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationR0", Util.GetInt(IsTransportationR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationR1", Util.GetInt(IsTransportationR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationL0", Util.GetInt(IsTransportationL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationL1", Util.GetInt(IsTransportationL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonR1", Util.GetString(ROMFlexlonR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonR2", Util.GetString(ROMFlexlonR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonR3", Util.GetString(ROMFlexlonR3)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonL1", Util.GetString(ROMFlexlonL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonL2", Util.GetString(ROMFlexlonL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonL3", Util.GetString(ROMFlexlonL3)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContR1", Util.GetString(ROMFlexlonContR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContR2", Util.GetString(ROMFlexlonContR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContL1", Util.GetString(ROMFlexlonContL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContL2", Util.GetString(ROMFlexlonContL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMExternalR1", Util.GetString(ROMExternalR1)));
            cmd.Parameters.Add(new MySqlParameter("@vRomExternalR2", Util.GetString(RomExternalR2)));
            cmd.Parameters.Add(new MySqlParameter("@vRomExternalL1", Util.GetString(RomExternalL1)));
            cmd.Parameters.Add(new MySqlParameter("@vRomExternalL2", Util.GetString(RomExternalL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalR1", Util.GetString(ROMInternalR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalR2", Util.GetString(ROMInternalR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalL1", Util.GetString(ROMInternalL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalL2", Util.GetString(ROMInternalL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionR1", Util.GetString(ROMAbductionR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionR2", Util.GetString(ROMAbductionR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionL1", Util.GetString(ROMAbductionL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionL2", Util.GetString(ROMAbductionL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionR1", Util.GetString(ROMAdductionR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionR2", Util.GetString(ROMAdductionR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionL1", Util.GetString(ROMAdductionL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionL2", Util.GetString(ROMAdductionL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsROMRight", Util.GetString(IsROMRight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsROMLeft", Util.GetString(IsROMLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthR1", Util.GetString(InclusionLengthR1)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthR2", Util.GetString(InclusionLengthR2)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthR3", Util.GetString(InclusionLengthR3)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthL1", Util.GetString(InclusionLengthL1)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthL2", Util.GetString(InclusionLengthL2)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthL3", Util.GetString(InclusionLengthL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthDiscrepancy", Util.GetString(IsLegLengthDiscrepancy)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthDiscrepancy1", Util.GetString(LegLengthDiscrepancy1)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthDiscrepancy2", Util.GetString(LegLengthDiscrepancy2)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthDiscrepancy3", Util.GetString(LegLengthDiscrepancy3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsThighPainRight", Util.GetString(IsThighPainRight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsThighPainLeft", Util.GetString(IsThighPainLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGroinPainRight", Util.GetString(IsGroinPainRight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGroinPainLeft", Util.GetString(IsGroinPainLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCharnleyClassification", Util.GetString(IsCharnleyClassification)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRadioGraphicAnalysis", Util.GetString(IsRadioGraphicAnalysis)));
            cmd.Parameters.Add(new MySqlParameter("@vFIlmAnalysisR", Util.GetString(FIlmAnalysisR)));
            cmd.Parameters.Add(new MySqlParameter("@vFilmAnalysisL", Util.GetString(FilmAnalysisL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrookerClassificationR", Util.GetString(IsBrookerClassificationR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrookerClassificationL", Util.GetString(IsBrookerClassificationL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCementClassificationR", Util.GetString(IsCementClassificationR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCementClassificationL", Util.GetString(IsCementClassificationL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceR", Util.GetString(IsRLAceR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceL", Util.GetString(IsRLAceL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceScrewR", Util.GetString(IsRLAceScrewR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceScrewL", Util.GetString(IsRLAceScrewL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLFemoralR", Util.GetString(IsRLFemoralR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLFemoralL", Util.GetString(IsRLFemoralL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseAceR", Util.GetString(IsLooseAceR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseAceL", Util.GetString(IsLooseAceL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseFemoralR", Util.GetString(IsLooseFemoralR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseFemoralL", Util.GetString(IsLooseFemoralL)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFilmAnalysisNoneR", Util.GetInt(IsFilmAnalysisNoneR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFilmAnalysisNoneL", Util.GetInt(IsFilmAnalysisNoneL)));

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

            objSQL.Append("cpoe_hip_analysis_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsHip", Util.GetString(IsHip)));
            cmd.Parameters.Add(new MySqlParameter("@vIsClinicVisit", Util.GetString(IsClinicVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR0", Util.GetInt(IsPlainR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR1", Util.GetInt(IsPlainR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR2", Util.GetInt(IsPlainR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR3", Util.GetInt(IsPlainR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR4", Util.GetInt(IsPlainR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainR5", Util.GetInt(IsPlainR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL0", Util.GetInt(IsPlainL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL1", Util.GetInt(IsPlainL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL2", Util.GetInt(IsPlainL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL3", Util.GetInt(IsPlainL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL4", Util.GetInt(IsPlainL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPlainL5", Util.GetInt(IsPlainL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR0", Util.GetInt(IsLimpR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR1", Util.GetInt(IsLimpR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR2", Util.GetInt(IsLimpR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpR3", Util.GetInt(IsLimpR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL0", Util.GetInt(IsLimpL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL1", Util.GetInt(IsLimpL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL2", Util.GetInt(IsLimpL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLimpL3", Util.GetInt(IsLimpL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR0", Util.GetInt(IsSupportR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR1", Util.GetInt(IsSupportR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR2", Util.GetInt(IsSupportR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR3", Util.GetInt(IsSupportR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR4", Util.GetInt(IsSupportR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR5", Util.GetInt(IsSupportR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL0", Util.GetInt(IsSupportL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL1", Util.GetInt(IsSupportL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL2", Util.GetInt(IsSupportL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL3", Util.GetInt(IsSupportL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL4", Util.GetInt(IsSupportL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL5", Util.GetInt(IsSupportL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR0", Util.GetInt(IsDistanceR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR1", Util.GetInt(IsDistanceR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR2", Util.GetInt(IsDistanceR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR3", Util.GetInt(IsDistanceR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceR4", Util.GetInt(IsDistanceR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL0", Util.GetInt(IsDistanceL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL1", Util.GetInt(IsDistanceL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL2", Util.GetInt(IsDistanceL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL3", Util.GetInt(IsDistanceL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDistanceL4", Util.GetInt(IsDistanceL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR0", Util.GetInt(IsStairsR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR1", Util.GetInt(IsStairsR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR2", Util.GetInt(IsStairsR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR3", Util.GetInt(IsStairsR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL0", Util.GetInt(IsStairsL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL1", Util.GetInt(IsStairsL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL2", Util.GetInt(IsStairsL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL3", Util.GetInt(IsStairsL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesR0", Util.GetInt(IsShoesR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesR1", Util.GetInt(IsShoesR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesR2", Util.GetInt(IsShoesR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesL0", Util.GetInt(IsShoesL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesL1", Util.GetInt(IsShoesL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsShoesL2", Util.GetInt(IsShoesL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingR0", Util.GetInt(IsSittingR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingR1", Util.GetInt(IsSittingR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingR2", Util.GetInt(IsSittingR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingL0", Util.GetInt(IsSittingL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingL1", Util.GetInt(IsSittingL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSittingL2", Util.GetInt(IsSittingL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationR0", Util.GetInt(IsTransportationR0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationR1", Util.GetInt(IsTransportationR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationL0", Util.GetInt(IsTransportationL0)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransportationL1", Util.GetInt(IsTransportationL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonR1", Util.GetString(ROMFlexlonR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonR2", Util.GetString(ROMFlexlonR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonR3", Util.GetString(ROMFlexlonR3)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonL1", Util.GetString(ROMFlexlonL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonL2", Util.GetString(ROMFlexlonL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonL3", Util.GetString(ROMFlexlonL3)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContR1", Util.GetString(ROMFlexlonContR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContR2", Util.GetString(ROMFlexlonContR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContL1", Util.GetString(ROMFlexlonContL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMFlexlonContL2", Util.GetString(ROMFlexlonContL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMExternalR1", Util.GetString(ROMExternalR1)));
            cmd.Parameters.Add(new MySqlParameter("@vRomExternalR2", Util.GetString(RomExternalR2)));
            cmd.Parameters.Add(new MySqlParameter("@vRomExternalL1", Util.GetString(RomExternalL1)));
            cmd.Parameters.Add(new MySqlParameter("@vRomExternalL2", Util.GetString(RomExternalL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalR1", Util.GetString(ROMInternalR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalR2", Util.GetString(ROMInternalR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalL1", Util.GetString(ROMInternalL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMInternalL2", Util.GetString(ROMInternalL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionR1", Util.GetString(ROMAbductionR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionR2", Util.GetString(ROMAbductionR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionL1", Util.GetString(ROMAbductionL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAbductionL2", Util.GetString(ROMAbductionL2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionR1", Util.GetString(ROMAdductionR1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionR2", Util.GetString(ROMAdductionR2)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionL1", Util.GetString(ROMAdductionL1)));
            cmd.Parameters.Add(new MySqlParameter("@vROMAdductionL2", Util.GetString(ROMAdductionL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsROMRight", Util.GetString(IsROMRight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsROMLeft", Util.GetString(IsROMLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthR1", Util.GetString(InclusionLengthR1)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthR2", Util.GetString(InclusionLengthR2)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthR3", Util.GetString(InclusionLengthR3)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthL1", Util.GetString(InclusionLengthL1)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthL2", Util.GetString(InclusionLengthL2)));
            cmd.Parameters.Add(new MySqlParameter("@vInclusionLengthL3", Util.GetString(InclusionLengthL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLegLengthDiscrepancy", Util.GetString(IsLegLengthDiscrepancy)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthDiscrepancy1", Util.GetString(LegLengthDiscrepancy1)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthDiscrepancy2", Util.GetString(LegLengthDiscrepancy2)));
            cmd.Parameters.Add(new MySqlParameter("@vLegLengthDiscrepancy3", Util.GetString(LegLengthDiscrepancy3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsThighPainRight", Util.GetString(IsThighPainRight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsThighPainLeft", Util.GetString(IsThighPainLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGroinPainRight", Util.GetString(IsGroinPainRight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGroinPainLeft", Util.GetString(IsGroinPainLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCharnleyClassification", Util.GetString(IsCharnleyClassification)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRadioGraphicAnalysis", Util.GetString(IsRadioGraphicAnalysis)));
            cmd.Parameters.Add(new MySqlParameter("@vFIlmAnalysisR", Util.GetString(FIlmAnalysisR)));
            cmd.Parameters.Add(new MySqlParameter("@vFilmAnalysisL", Util.GetString(FilmAnalysisL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrookerClassificationR", Util.GetString(IsBrookerClassificationR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrookerClassificationL", Util.GetString(IsBrookerClassificationL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCementClassificationR", Util.GetString(IsCementClassificationR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCementClassificationL", Util.GetString(IsCementClassificationL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceR", Util.GetString(IsRLAceR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceL", Util.GetString(IsRLAceL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceScrewR", Util.GetString(IsRLAceScrewR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLAceScrewL", Util.GetString(IsRLAceScrewL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLFemoralR", Util.GetString(IsRLFemoralR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLFemoralL", Util.GetString(IsRLFemoralL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseAceR", Util.GetString(IsLooseAceR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseAceL", Util.GetString(IsLooseAceL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseFemoralR", Util.GetString(IsLooseFemoralR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLooseFemoralL", Util.GetString(IsLooseFemoralL)));
            //cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFilmAnalysisNoneR", Util.GetInt(IsFilmAnalysisNoneR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFilmAnalysisNoneL", Util.GetInt(IsFilmAnalysisNoneL)));

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
