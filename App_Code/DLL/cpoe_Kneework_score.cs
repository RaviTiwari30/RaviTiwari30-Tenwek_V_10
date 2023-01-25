using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;



public class cpoe_kneework_score
{
    public cpoe_kneework_score()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_kneework_score(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionId;
    private string _IsKneee;
    private string _IsClinicVisit;
    private int _IsWSR1;
    private int _IsWSR2;
    private int _IsWSR3;
    private int _IsWSR4;
    private int _IsWSR5;
    private int _IsWSR6;
    private int _IsWSL1;
    private int _IsWSL2;
    private int _IsWSL3;
    private int _IsWSL4;
    private int _IsWSL5;
    private int _IsWSL6;
    private int _IsPSR1;
    private int _IsPSR2;
    private int _IsPSR3;
    private int _IsPSR4;
    private int _IsPSR5;
    private int _IsPSR6;
    private int _IsPSR7;
    private int _IsPSL1;
    private int _IsPSL2;
    private int _IsPSL3;
    private int _IsPSL4;
    private int _IsPSL5;
    private int _IsPSL6;
    private int _IsPSL7;
    private int _IsStairsR1;
    private int _IsStairsR2;
    private int _IsStairsR3;
    private int _IsStairsR4;
    private int _IsStairsR5;
    private int _IsStairsL1;
    private int _IsStairsL2;
    private int _IsStairsL3;
    private int _IsStairsL4;
    private int _IsstairsL5;
    private int _IsPC1;
    private int _IsPC2;
    private int _IsPC3;
    private int _IsPC4;
    private int _IsPC5;
    private int _IsPC6;
    private int _IsSupportR1;
    private int _IsSupportR2;
    private int _IsSupportR3;
    private int _IsSupportR4;
    private int _IsSupportR5;
    private int _IsSupportL1;
    private int _IsSupportL2;
    private int _IsSupportL3;
    private int _IsSupportL4;
    private int _IsSupportL5;
    private int _IsFCR1;
    private int _IsFCR2;
    private int _IsFCR3;
    private int _IsFCR4;
    private int _IsFCR5;
    private int _IsFCL1;
    private int _IsFCL2;
    private int _IsFCL3;
    private int _IsFCL4;
    private int _IsFCL5;
    private int _IsELR1;
    private int _IsELR2;
    private int _IsELR3;
    private int _IsELR4;
    private int _IsELL1;
    private int _IsELL2;
    private int _IsELL3;
    private int _IsELL4;
    private int _IsMSR1;
    private int _IsMSR2;
    private int _IsMSR3;
    private int _IsMSR4;
    private int _IsMSL1;
    private int _IsMSL2;
    private int _IsMSL3;
    private int _IsMSL4;
    private int _IsASR1;
    private int _IsASR2;
    private int _IsASR3;
    private int _IsASL1;
    private int _IsASL2;
    private int _IsASL3;
    private string _MotionExtR1;
    private string _MotionExtR2;
    private string _MotionExtR3;
    private string _MotionExtL1;
    private string _MotionExtL2;
    private string _MotionExtL3;
    private string _MotionFlexR1;
    private string _MotionFlexR2;
    private string _MotionFlexR3;
    private string _MotionFlexL1;
    private string _MotionflexL2;
    private string _MotionFlexL3;
    private string _MotionRomR1;
    private string _MotionRomR2;
    private string _MotionRomR3;
    private string _MotionRomL1;
    private string _MotionRomL2;
    private string _MotionromL3;
    private int _IsAlignmentR1;
    private int _IsAlignmentR2;
    private int _IsAlignmentR3;
    private int _IsAlignmentR4;
    private int _IsAlignmentR5;
    private int _IsAlignmentR6;
    private int _IsAlignmentR7;
    private int _IsAlignmentR8;
    private int _IsAlignmentR9;
    private int _IsAlignmentR10;
    private int _IsAlignmentR11;
    private int _IsAlignmentR12;
    private int _IsAlignmentR13;
    private int _IsAlignmentR14;
    private int _IsAlignmentL1;
    private int _IsAlignmentL2;
    private int _IsAlignmentL3;
    private int _IsAlignmentL4;
    private int _IsAlignmentL5;
    private int _IsAlignmentL6;
    private int _IsAlignmentL7;
    private int _IsAlignmentL8;
    private int _IsAlignmentL9;
    private int _IsAlignmentL10;
    private int _IsAlignmentL11;
    private int _IsAlignmentL12;
    private int _IsAlignmentL13;
    private int _IsAlignmentL14;
    private string _IsRadioGRPAnalysis;
    private string _IsAAlignmentR;
    private string _IsAAlignmentL;
    private int _IsFemurR;
    private int _IsFemurL;
    private int _IsTiblaAPR;
    private int _IsTiblaAPL;
    private int _IsTiblaLATR;
    private int _IsTiblaLATL;
    private int _IsTiblaSCRR;
    private int _IsTiblaSCRL;
    private int _IsPatellaR;
    private int _IsPatellaL;
    private int _IsRLCFemurR;
    private int _IsRLCFemurL;
    private int _IsRLCTiblaAPR;
    private int _IsRLCTiblaAPL;
    private int _IsRLCTiblaLATR;
    private int _IsRLCTiblaLATL;
    private int _IsRLCPatellaR;
    private int _IsRLCPatellaL;
    private string _IsLoosingFemurR;
    private string _IsLoosingFemurL;
    private string _IsLoosingTiblaR;
    private string _IsLoosingTiblaL;
    private string _IsLoosingPatellaR;
    private string _IsLoosingPatellaL;
    private string _IsPRR;
    private string _IsPRL;
    private string _IsIPR;
    private string _IsIPL;
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
    public virtual string TransactionId { get { return _TransactionId; } set { _TransactionId = value; } }
    public virtual string IsKneee { get { return _IsKneee; } set { _IsKneee = value; } }
    public virtual string IsClinicVisit { get { return _IsClinicVisit; } set { _IsClinicVisit = value; } }
    public virtual int IsWSR1 { get { return _IsWSR1; } set { _IsWSR1 = value; } }
    public virtual int IsWSR2 { get { return _IsWSR2; } set { _IsWSR2 = value; } }
    public virtual int IsWSR3 { get { return _IsWSR3; } set { _IsWSR3 = value; } }
    public virtual int IsWSR4 { get { return _IsWSR4; } set { _IsWSR4 = value; } }
    public virtual int IsWSR5 { get { return _IsWSR5; } set { _IsWSR5 = value; } }
    public virtual int IsWSR6 { get { return _IsWSR6; } set { _IsWSR6 = value; } }
    public virtual int IsWSL1 { get { return _IsWSL1; } set { _IsWSL1 = value; } }
    public virtual int IsWSL2 { get { return _IsWSL2; } set { _IsWSL2 = value; } }
    public virtual int IsWSL3 { get { return _IsWSL3; } set { _IsWSL3 = value; } }
    public virtual int IsWSL4 { get { return _IsWSL4; } set { _IsWSL4 = value; } }
    public virtual int IsWSL5 { get { return _IsWSL5; } set { _IsWSL5 = value; } }
    public virtual int IsWSL6 { get { return _IsWSL6; } set { _IsWSL6 = value; } }
    public virtual int IsPSR1 { get { return _IsPSR1; } set { _IsPSR1 = value; } }
    public virtual int IsPSR2 { get { return _IsPSR2; } set { _IsPSR2 = value; } }
    public virtual int IsPSR3 { get { return _IsPSR3; } set { _IsPSR3 = value; } }
    public virtual int IsPSR4 { get { return _IsPSR4; } set { _IsPSR4 = value; } }
    public virtual int IsPSR5 { get { return _IsPSR5; } set { _IsPSR5 = value; } }
    public virtual int IsPSR6 { get { return _IsPSR6; } set { _IsPSR6 = value; } }
    public virtual int IsPSR7 { get { return _IsPSR7; } set { _IsPSR7 = value; } }
    public virtual int IsPSL1 { get { return _IsPSL1; } set { _IsPSL1 = value; } }
    public virtual int IsPSL2 { get { return _IsPSL2; } set { _IsPSL2 = value; } }
    public virtual int IsPSL3 { get { return _IsPSL3; } set { _IsPSL3 = value; } }
    public virtual int IsPSL4 { get { return _IsPSL4; } set { _IsPSL4 = value; } }
    public virtual int IsPSL5 { get { return _IsPSL5; } set { _IsPSL5 = value; } }
    public virtual int IsPSL6 { get { return _IsPSL6; } set { _IsPSL6 = value; } }
    public virtual int IsPSL7 { get { return _IsPSL7; } set { _IsPSL7 = value; } }
    public virtual int IsStairsR1 { get { return _IsStairsR1; } set { _IsStairsR1 = value; } }
    public virtual int IsStairsR2 { get { return _IsStairsR2; } set { _IsStairsR2 = value; } }
    public virtual int IsStairsR3 { get { return _IsStairsR3; } set { _IsStairsR3 = value; } }
    public virtual int IsStairsR4 { get { return _IsStairsR4; } set { _IsStairsR4 = value; } }
    public virtual int IsStairsR5 { get { return _IsStairsR5; } set { _IsStairsR5 = value; } }
    public virtual int IsStairsL1 { get { return _IsStairsL1; } set { _IsStairsL1 = value; } }
    public virtual int IsStairsL2 { get { return _IsStairsL2; } set { _IsStairsL2 = value; } }
    public virtual int IsStairsL3 { get { return _IsStairsL3; } set { _IsStairsL3 = value; } }
    public virtual int IsStairsL4 { get { return _IsStairsL4; } set { _IsStairsL4 = value; } }
    public virtual int IsstairsL5 { get { return _IsstairsL5; } set { _IsstairsL5 = value; } }
    public virtual int IsPC1 { get { return _IsPC1; } set { _IsPC1 = value; } }
    public virtual int IsPC2 { get { return _IsPC2; } set { _IsPC2 = value; } }
    public virtual int IsPC3 { get { return _IsPC3; } set { _IsPC3 = value; } }
    public virtual int IsPC4 { get { return _IsPC4; } set { _IsPC4 = value; } }
    public virtual int IsPC5 { get { return _IsPC5; } set { _IsPC5 = value; } }
    public virtual int IsPC6 { get { return _IsPC6; } set { _IsPC6 = value; } }
    public virtual int IsSupportR1 { get { return _IsSupportR1; } set { _IsSupportR1 = value; } }
    public virtual int IsSupportR2 { get { return _IsSupportR2; } set { _IsSupportR2 = value; } }
    public virtual int IsSupportR3 { get { return _IsSupportR3; } set { _IsSupportR3 = value; } }
    public virtual int IsSupportR4 { get { return _IsSupportR4; } set { _IsSupportR4 = value; } }
    public virtual int IsSupportR5 { get { return _IsSupportR5; } set { _IsSupportR5 = value; } }
    public virtual int IsSupportL1 { get { return _IsSupportL1; } set { _IsSupportL1 = value; } }
    public virtual int IsSupportL2 { get { return _IsSupportL2; } set { _IsSupportL2 = value; } }
    public virtual int IsSupportL3 { get { return _IsSupportL3; } set { _IsSupportL3 = value; } }
    public virtual int IsSupportL4 { get { return _IsSupportL4; } set { _IsSupportL4 = value; } }
    public virtual int IsSupportL5 { get { return _IsSupportL5; } set { _IsSupportL5 = value; } }
    public virtual int IsFCR1 { get { return _IsFCR1; } set { _IsFCR1 = value; } }
    public virtual int IsFCR2 { get { return _IsFCR2; } set { _IsFCR2 = value; } }
    public virtual int IsFCR3 { get { return _IsFCR3; } set { _IsFCR3 = value; } }
    public virtual int IsFCR4 { get { return _IsFCR4; } set { _IsFCR4 = value; } }
    public virtual int IsFCR5 { get { return _IsFCR5; } set { _IsFCR5 = value; } }
    public virtual int IsFCL1 { get { return _IsFCL1; } set { _IsFCL1 = value; } }
    public virtual int IsFCL2 { get { return _IsFCL2; } set { _IsFCL2 = value; } }
    public virtual int IsFCL3 { get { return _IsFCL3; } set { _IsFCL3 = value; } }
    public virtual int IsFCL4 { get { return _IsFCL4; } set { _IsFCL4 = value; } }
    public virtual int IsFCL5 { get { return _IsFCL5; } set { _IsFCL5 = value; } }
    public virtual int IsELR1 { get { return _IsELR1; } set { _IsELR1 = value; } }
    public virtual int IsELR2 { get { return _IsELR2; } set { _IsELR2 = value; } }
    public virtual int IsELR3 { get { return _IsELR3; } set { _IsELR3 = value; } }
    public virtual int IsELR4 { get { return _IsELR4; } set { _IsELR4 = value; } }
    public virtual int IsELL1 { get { return _IsELL1; } set { _IsELL1 = value; } }
    public virtual int IsELL2 { get { return _IsELL2; } set { _IsELL2 = value; } }
    public virtual int IsELL3 { get { return _IsELL3; } set { _IsELL3 = value; } }
    public virtual int IsELL4 { get { return _IsELL4; } set { _IsELL4 = value; } }
    public virtual int IsMSR1 { get { return _IsMSR1; } set { _IsMSR1 = value; } }
    public virtual int IsMSR2 { get { return _IsMSR2; } set { _IsMSR2 = value; } }
    public virtual int IsMSR3 { get { return _IsMSR3; } set { _IsMSR3 = value; } }
    public virtual int IsMSR4 { get { return _IsMSR4; } set { _IsMSR4 = value; } }
    public virtual int IsMSL1 { get { return _IsMSL1; } set { _IsMSL1 = value; } }
    public virtual int IsMSL2 { get { return _IsMSL2; } set { _IsMSL2 = value; } }
    public virtual int IsMSL3 { get { return _IsMSL3; } set { _IsMSL3 = value; } }
    public virtual int IsMSL4 { get { return _IsMSL4; } set { _IsMSL4 = value; } }
    public virtual int IsASR1 { get { return _IsASR1; } set { _IsASR1 = value; } }
    public virtual int IsASR2 { get { return _IsASR2; } set { _IsASR2 = value; } }
    public virtual int IsASR3 { get { return _IsASR3; } set { _IsASR3 = value; } }
    public virtual int IsASL1 { get { return _IsASL1; } set { _IsASL1 = value; } }
    public virtual int IsASL2 { get { return _IsASL2; } set { _IsASL2 = value; } }
    public virtual int IsASL3 { get { return _IsASL3; } set { _IsASL3 = value; } }
    public virtual string MotionExtR1 { get { return _MotionExtR1; } set { _MotionExtR1 = value; } }
    public virtual string MotionExtR2 { get { return _MotionExtR2; } set { _MotionExtR2 = value; } }
    public virtual string MotionExtR3 { get { return _MotionExtR3; } set { _MotionExtR3 = value; } }
    public virtual string MotionExtL1 { get { return _MotionExtL1; } set { _MotionExtL1 = value; } }
    public virtual string MotionExtL2 { get { return _MotionExtL2; } set { _MotionExtL2 = value; } }
    public virtual string MotionExtL3 { get { return _MotionExtL3; } set { _MotionExtL3 = value; } }
    public virtual string MotionFlexR1 { get { return _MotionFlexR1; } set { _MotionFlexR1 = value; } }
    public virtual string MotionFlexR2 { get { return _MotionFlexR2; } set { _MotionFlexR2 = value; } }
    public virtual string MotionFlexR3 { get { return _MotionFlexR3; } set { _MotionFlexR3 = value; } }
    public virtual string MotionFlexL1 { get { return _MotionFlexL1; } set { _MotionFlexL1 = value; } }
    public virtual string MotionflexL2 { get { return _MotionflexL2; } set { _MotionflexL2 = value; } }
    public virtual string MotionFlexL3 { get { return _MotionFlexL3; } set { _MotionFlexL3 = value; } }
    public virtual string MotionRomR1 { get { return _MotionRomR1; } set { _MotionRomR1 = value; } }
    public virtual string MotionRomR2 { get { return _MotionRomR2; } set { _MotionRomR2 = value; } }
    public virtual string MotionRomR3 { get { return _MotionRomR3; } set { _MotionRomR3 = value; } }
    public virtual string MotionRomL1 { get { return _MotionRomL1; } set { _MotionRomL1 = value; } }
    public virtual string MotionRomL2 { get { return _MotionRomL2; } set { _MotionRomL2 = value; } }
    public virtual string MotionromL3 { get { return _MotionromL3; } set { _MotionromL3 = value; } }
    public virtual int IsAlignmentR1 { get { return _IsAlignmentR1; } set { _IsAlignmentR1 = value; } }
    public virtual int IsAlignmentR2 { get { return _IsAlignmentR2; } set { _IsAlignmentR2 = value; } }
    public virtual int IsAlignmentR3 { get { return _IsAlignmentR3; } set { _IsAlignmentR3 = value; } }
    public virtual int IsAlignmentR4 { get { return _IsAlignmentR4; } set { _IsAlignmentR4 = value; } }
    public virtual int IsAlignmentR5 { get { return _IsAlignmentR5; } set { _IsAlignmentR5 = value; } }
    public virtual int IsAlignmentR6 { get { return _IsAlignmentR6; } set { _IsAlignmentR6 = value; } }
    public virtual int IsAlignmentR7 { get { return _IsAlignmentR7; } set { _IsAlignmentR7 = value; } }
    public virtual int IsAlignmentR8 { get { return _IsAlignmentR8; } set { _IsAlignmentR8 = value; } }
    public virtual int IsAlignmentR9 { get { return _IsAlignmentR9; } set { _IsAlignmentR9 = value; } }
    public virtual int IsAlignmentR10 { get { return _IsAlignmentR10; } set { _IsAlignmentR10 = value; } }
    public virtual int IsAlignmentR11 { get { return _IsAlignmentR11; } set { _IsAlignmentR11 = value; } }
    public virtual int IsAlignmentR12 { get { return _IsAlignmentR12; } set { _IsAlignmentR12 = value; } }
    public virtual int IsAlignmentR13 { get { return _IsAlignmentR13; } set { _IsAlignmentR13 = value; } }
    public virtual int IsAlignmentR14 { get { return _IsAlignmentR14; } set { _IsAlignmentR14 = value; } }
    public virtual int IsAlignmentL1 { get { return _IsAlignmentL1; } set { _IsAlignmentL1 = value; } }
    public virtual int IsAlignmentL2 { get { return _IsAlignmentL2; } set { _IsAlignmentL2 = value; } }
    public virtual int IsAlignmentL3 { get { return _IsAlignmentL3; } set { _IsAlignmentL3 = value; } }
    public virtual int IsAlignmentL4 { get { return _IsAlignmentL4; } set { _IsAlignmentL4 = value; } }
    public virtual int IsAlignmentL5 { get { return _IsAlignmentL5; } set { _IsAlignmentL5 = value; } }
    public virtual int IsAlignmentL6 { get { return _IsAlignmentL6; } set { _IsAlignmentL6 = value; } }
    public virtual int IsAlignmentL7 { get { return _IsAlignmentL7; } set { _IsAlignmentL7 = value; } }
    public virtual int IsAlignmentL8 { get { return _IsAlignmentL8; } set { _IsAlignmentL8 = value; } }
    public virtual int IsAlignmentL9 { get { return _IsAlignmentL9; } set { _IsAlignmentL9 = value; } }
    public virtual int IsAlignmentL10 { get { return _IsAlignmentL10; } set { _IsAlignmentL10 = value; } }
    public virtual int IsAlignmentL11 { get { return _IsAlignmentL11; } set { _IsAlignmentL11 = value; } }
    public virtual int IsAlignmentL12 { get { return _IsAlignmentL12; } set { _IsAlignmentL12 = value; } }
    public virtual int IsAlignmentL13 { get { return _IsAlignmentL13; } set { _IsAlignmentL13 = value; } }
    public virtual int IsAlignmentL14 { get { return _IsAlignmentL14; } set { _IsAlignmentL14 = value; } }
    public virtual string IsRadioGRPAnalysis { get { return _IsRadioGRPAnalysis; } set { _IsRadioGRPAnalysis = value; } }
    public virtual string IsAAlignmentR { get { return _IsAAlignmentR; } set { _IsAAlignmentR = value; } }
    public virtual string IsAAlignmentL { get { return _IsAAlignmentL; } set { _IsAAlignmentL = value; } }
    public virtual int IsFemurR { get { return _IsFemurR; } set { _IsFemurR = value; } }
    public virtual int IsFemurL { get { return _IsFemurL; } set { _IsFemurL = value; } }
    public virtual int IsTiblaAPR { get { return _IsTiblaAPR; } set { _IsTiblaAPR = value; } }
    public virtual int IsTiblaAPL { get { return _IsTiblaAPL; } set { _IsTiblaAPL = value; } }
    public virtual int IsTiblaLATR { get { return _IsTiblaLATR; } set { _IsTiblaLATR = value; } }
    public virtual int IsTiblaLATL { get { return _IsTiblaLATL; } set { _IsTiblaLATL = value; } }
    public virtual int IsTiblaSCRR { get { return _IsTiblaSCRR; } set { _IsTiblaSCRR = value; } }
    public virtual int IsTiblaSCRL { get { return _IsTiblaSCRL; } set { _IsTiblaSCRL = value; } }
    public virtual int IsPatellaR { get { return _IsPatellaR; } set { _IsPatellaR = value; } }
    public virtual int IsPatellaL { get { return _IsPatellaL; } set { _IsPatellaL = value; } }
    public virtual int IsRLCFemurR { get { return _IsRLCFemurR; } set { _IsRLCFemurR = value; } }
    public virtual int IsRLCFemurL { get { return _IsRLCFemurL; } set { _IsRLCFemurL = value; } }
    public virtual int IsRLCTiblaAPR { get { return _IsRLCTiblaAPR; } set { _IsRLCTiblaAPR = value; } }
    public virtual int IsRLCTiblaAPL { get { return _IsRLCTiblaAPL; } set { _IsRLCTiblaAPL = value; } }
    public virtual int IsRLCTiblaLATR { get { return _IsRLCTiblaLATR; } set { _IsRLCTiblaLATR = value; } }
    public virtual int IsRLCTiblaLATL { get { return _IsRLCTiblaLATL; } set { _IsRLCTiblaLATL = value; } }
    public virtual int IsRLCPatellaR { get { return _IsRLCPatellaR; } set { _IsRLCPatellaR = value; } }
    public virtual int IsRLCPatellaL { get { return _IsRLCPatellaL; } set { _IsRLCPatellaL = value; } }
    public virtual string IsLoosingFemurR { get { return _IsLoosingFemurR; } set { _IsLoosingFemurR = value; } }
    public virtual string IsLoosingFemurL { get { return _IsLoosingFemurL; } set { _IsLoosingFemurL = value; } }
    public virtual string IsLoosingTiblaR { get { return _IsLoosingTiblaR; } set { _IsLoosingTiblaR = value; } }
    public virtual string IsLoosingTiblaL { get { return _IsLoosingTiblaL; } set { _IsLoosingTiblaL = value; } }
    public virtual string IsLoosingPatellaR { get { return _IsLoosingPatellaR; } set { _IsLoosingPatellaR = value; } }
    public virtual string IsLoosingPatellaL { get { return _IsLoosingPatellaL; } set { _IsLoosingPatellaL = value; } }
    public virtual string IsPRR { get { return _IsPRR; } set { _IsPRR = value; } }
    public virtual string IsPRL { get { return _IsPRL; } set { _IsPRL = value; } }
    public virtual string IsIPR { get { return _IsIPR; } set { _IsIPR = value; } }
    public virtual string IsIPL { get { return _IsIPL; } set { _IsIPL = value; } }
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

            objSQL.Append("cpoe_kneework_score_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionId", Util.GetString(TransactionId)));
            cmd.Parameters.Add(new MySqlParameter("@vIsKneee", Util.GetString(IsKneee)));
            cmd.Parameters.Add(new MySqlParameter("@vIsClinicVisit", Util.GetString(IsClinicVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR1", Util.GetInt(IsWSR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR2", Util.GetInt(IsWSR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR3", Util.GetInt(IsWSR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR4", Util.GetInt(IsWSR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR5", Util.GetInt(IsWSR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR6", Util.GetInt(IsWSR6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL1", Util.GetInt(IsWSL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL2", Util.GetInt(IsWSL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL3", Util.GetInt(IsWSL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL4", Util.GetInt(IsWSL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL5", Util.GetInt(IsWSL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL6", Util.GetInt(IsWSL6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR1", Util.GetInt(IsPSR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR2", Util.GetInt(IsPSR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR3", Util.GetInt(IsPSR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR4", Util.GetInt(IsPSR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR5", Util.GetInt(IsPSR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR6", Util.GetInt(IsPSR6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR7", Util.GetInt(IsPSR7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL1", Util.GetInt(IsPSL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL2", Util.GetInt(IsPSL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL3", Util.GetInt(IsPSL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL4", Util.GetInt(IsPSL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL5", Util.GetInt(IsPSL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL6", Util.GetInt(IsPSL6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL7", Util.GetInt(IsPSL7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR1", Util.GetInt(IsStairsR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR2", Util.GetInt(IsStairsR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR3", Util.GetInt(IsStairsR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR4", Util.GetInt(IsStairsR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR5", Util.GetInt(IsStairsR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL1", Util.GetInt(IsStairsL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL2", Util.GetInt(IsStairsL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL3", Util.GetInt(IsStairsL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL4", Util.GetInt(IsStairsL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsstairsL5", Util.GetInt(IsstairsL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC1", Util.GetInt(IsPC1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC2", Util.GetInt(IsPC2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC3", Util.GetInt(IsPC3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC4", Util.GetInt(IsPC4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC5", Util.GetInt(IsPC5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC6", Util.GetInt(IsPC6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR1", Util.GetInt(IsSupportR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR2", Util.GetInt(IsSupportR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR3", Util.GetInt(IsSupportR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR4", Util.GetInt(IsSupportR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR5", Util.GetInt(IsSupportR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL1", Util.GetInt(IsSupportL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL2", Util.GetInt(IsSupportL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL3", Util.GetInt(IsSupportL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL4", Util.GetInt(IsSupportL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL5", Util.GetInt(IsSupportL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR1", Util.GetInt(IsFCR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR2", Util.GetInt(IsFCR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR3", Util.GetInt(IsFCR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR4", Util.GetInt(IsFCR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR5", Util.GetInt(IsFCR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL1", Util.GetInt(IsFCL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL2", Util.GetInt(IsFCL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL3", Util.GetInt(IsFCL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL4", Util.GetInt(IsFCL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL5", Util.GetInt(IsFCL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR1", Util.GetInt(IsELR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR2", Util.GetInt(IsELR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR3", Util.GetInt(IsELR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR4", Util.GetInt(IsELR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL1", Util.GetInt(IsELL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL2", Util.GetInt(IsELL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL3", Util.GetInt(IsELL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL4", Util.GetInt(IsELL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR1", Util.GetInt(IsMSR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR2", Util.GetInt(IsMSR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR3", Util.GetInt(IsMSR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR4", Util.GetInt(IsMSR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL1", Util.GetInt(IsMSL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL2", Util.GetInt(IsMSL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL3", Util.GetInt(IsMSL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL4", Util.GetInt(IsMSL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASR1", Util.GetInt(IsASR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASR2", Util.GetInt(IsASR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASR3", Util.GetInt(IsASR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASL1", Util.GetInt(IsASL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASL2", Util.GetInt(IsASL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASL3", Util.GetInt(IsASL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtR1", Util.GetString(MotionExtR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtR2", Util.GetString(MotionExtR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtR3", Util.GetString(MotionExtR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtL1", Util.GetString(MotionExtL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtL2", Util.GetString(MotionExtL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtL3", Util.GetString(MotionExtL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexR1", Util.GetString(MotionFlexR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexR2", Util.GetString(MotionFlexR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexR3", Util.GetString(MotionFlexR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexL1", Util.GetString(MotionFlexL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionflexL2", Util.GetString(MotionflexL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexL3", Util.GetString(MotionFlexL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomR1", Util.GetString(MotionRomR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomR2", Util.GetString(MotionRomR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomR3", Util.GetString(MotionRomR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomL1", Util.GetString(MotionRomL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomL2", Util.GetString(MotionRomL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionromL3", Util.GetString(MotionromL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR1", Util.GetInt(IsAlignmentR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR2", Util.GetInt(IsAlignmentR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR3", Util.GetInt(IsAlignmentR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR4", Util.GetInt(IsAlignmentR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR5", Util.GetInt(IsAlignmentR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR6", Util.GetInt(IsAlignmentR6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR7", Util.GetInt(IsAlignmentR7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR8", Util.GetInt(IsAlignmentR8)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR9", Util.GetInt(IsAlignmentR9)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR10", Util.GetInt(IsAlignmentR10)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR11", Util.GetInt(IsAlignmentR11)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR12", Util.GetInt(IsAlignmentR12)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR13", Util.GetInt(IsAlignmentR13)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR14", Util.GetInt(IsAlignmentR14)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL1", Util.GetInt(IsAlignmentL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL2", Util.GetInt(IsAlignmentL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL3", Util.GetInt(IsAlignmentL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL4", Util.GetInt(IsAlignmentL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL5", Util.GetInt(IsAlignmentL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL6", Util.GetInt(IsAlignmentL6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL7", Util.GetInt(IsAlignmentL7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL8", Util.GetInt(IsAlignmentL8)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL9", Util.GetInt(IsAlignmentL9)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL10", Util.GetInt(IsAlignmentL10)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL11", Util.GetInt(IsAlignmentL11)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL12", Util.GetInt(IsAlignmentL12)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL13", Util.GetInt(IsAlignmentL13)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL14", Util.GetInt(IsAlignmentL14)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRadioGRPAnalysis", Util.GetString(IsRadioGRPAnalysis)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAAlignmentR", Util.GetString(IsAAlignmentR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAAlignmentL", Util.GetString(IsAAlignmentL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFemurR", Util.GetInt(IsFemurR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFemurL", Util.GetInt(IsFemurL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaAPR", Util.GetInt(IsTiblaAPR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaAPL", Util.GetInt(IsTiblaAPL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaLATR", Util.GetInt(IsTiblaLATR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaLATL", Util.GetInt(IsTiblaLATL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaSCRR", Util.GetInt(IsTiblaSCRR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaSCRL", Util.GetInt(IsTiblaSCRL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPatellaR", Util.GetInt(IsPatellaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPatellaL", Util.GetInt(IsPatellaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCFemurR", Util.GetInt(IsRLCFemurR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCFemurL", Util.GetInt(IsRLCFemurL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaAPR", Util.GetInt(IsRLCTiblaAPR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaAPL", Util.GetInt(IsRLCTiblaAPL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaLATR", Util.GetInt(IsRLCTiblaLATR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaLATL", Util.GetInt(IsRLCTiblaLATL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCPatellaR", Util.GetInt(IsRLCPatellaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCPatellaL", Util.GetInt(IsRLCPatellaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingFemurR", Util.GetString(IsLoosingFemurR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingFemurL", Util.GetString(IsLoosingFemurL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingTiblaR", Util.GetString(IsLoosingTiblaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingTiblaL", Util.GetString(IsLoosingTiblaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingPatellaR", Util.GetString(IsLoosingPatellaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingPatellaL", Util.GetString(IsLoosingPatellaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPRR", Util.GetString(IsPRR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPRL", Util.GetString(IsPRL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIPR", Util.GetString(IsIPR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIPL", Util.GetString(IsIPL)));
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

            objSQL.Append("cpoe_kneework_score_update");
            //objSQL.Append("sp_cpoe_kneework_score_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionId", Util.GetString(TransactionId)));
            cmd.Parameters.Add(new MySqlParameter("@vIsKneee", Util.GetString(IsKneee)));
            cmd.Parameters.Add(new MySqlParameter("@vIsClinicVisit", Util.GetString(IsClinicVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR1", Util.GetInt(IsWSR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR2", Util.GetInt(IsWSR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR3", Util.GetInt(IsWSR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR4", Util.GetInt(IsWSR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR5", Util.GetInt(IsWSR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSR6", Util.GetInt(IsWSR6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL1", Util.GetInt(IsWSL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL2", Util.GetInt(IsWSL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL3", Util.GetInt(IsWSL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL4", Util.GetInt(IsWSL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL5", Util.GetInt(IsWSL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWSL6", Util.GetInt(IsWSL6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR1", Util.GetInt(IsPSR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR2", Util.GetInt(IsPSR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR3", Util.GetInt(IsPSR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR4", Util.GetInt(IsPSR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR5", Util.GetInt(IsPSR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR6", Util.GetInt(IsPSR6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSR7", Util.GetInt(IsPSR7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL1", Util.GetInt(IsPSL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL2", Util.GetInt(IsPSL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL3", Util.GetInt(IsPSL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL4", Util.GetInt(IsPSL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL5", Util.GetInt(IsPSL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL6", Util.GetInt(IsPSL6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSL7", Util.GetInt(IsPSL7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR1", Util.GetInt(IsStairsR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR2", Util.GetInt(IsStairsR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR3", Util.GetInt(IsStairsR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR4", Util.GetInt(IsStairsR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsR5", Util.GetInt(IsStairsR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL1", Util.GetInt(IsStairsL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL2", Util.GetInt(IsStairsL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL3", Util.GetInt(IsStairsL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStairsL4", Util.GetInt(IsStairsL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsstairsL5", Util.GetInt(IsstairsL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC1", Util.GetInt(IsPC1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC2", Util.GetInt(IsPC2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC3", Util.GetInt(IsPC3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC4", Util.GetInt(IsPC4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC5", Util.GetInt(IsPC5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPC6", Util.GetInt(IsPC6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR1", Util.GetInt(IsSupportR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR2", Util.GetInt(IsSupportR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR3", Util.GetInt(IsSupportR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR4", Util.GetInt(IsSupportR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportR5", Util.GetInt(IsSupportR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL1", Util.GetInt(IsSupportL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL2", Util.GetInt(IsSupportL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL3", Util.GetInt(IsSupportL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL4", Util.GetInt(IsSupportL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSupportL5", Util.GetInt(IsSupportL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR1", Util.GetInt(IsFCR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR2", Util.GetInt(IsFCR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR3", Util.GetInt(IsFCR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR4", Util.GetInt(IsFCR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCR5", Util.GetInt(IsFCR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL1", Util.GetInt(IsFCL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL2", Util.GetInt(IsFCL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL3", Util.GetInt(IsFCL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL4", Util.GetInt(IsFCL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFCL5", Util.GetInt(IsFCL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR1", Util.GetInt(IsELR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR2", Util.GetInt(IsELR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR3", Util.GetInt(IsELR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELR4", Util.GetInt(IsELR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL1", Util.GetInt(IsELL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL2", Util.GetInt(IsELL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL3", Util.GetInt(IsELL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsELL4", Util.GetInt(IsELL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR1", Util.GetInt(IsMSR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR2", Util.GetInt(IsMSR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR3", Util.GetInt(IsMSR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSR4", Util.GetInt(IsMSR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL1", Util.GetInt(IsMSL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL2", Util.GetInt(IsMSL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL3", Util.GetInt(IsMSL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMSL4", Util.GetInt(IsMSL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASR1", Util.GetInt(IsASR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASR2", Util.GetInt(IsASR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASR3", Util.GetInt(IsASR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASL1", Util.GetInt(IsASL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASL2", Util.GetInt(IsASL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsASL3", Util.GetInt(IsASL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtR1", Util.GetString(MotionExtR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtR2", Util.GetString(MotionExtR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtR3", Util.GetString(MotionExtR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtL1", Util.GetString(MotionExtL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtL2", Util.GetString(MotionExtL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionExtL3", Util.GetString(MotionExtL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexR1", Util.GetString(MotionFlexR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexR2", Util.GetString(MotionFlexR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexR3", Util.GetString(MotionFlexR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexL1", Util.GetString(MotionFlexL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionflexL2", Util.GetString(MotionflexL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionFlexL3", Util.GetString(MotionFlexL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomR1", Util.GetString(MotionRomR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomR2", Util.GetString(MotionRomR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomR3", Util.GetString(MotionRomR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomL1", Util.GetString(MotionRomL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionRomL2", Util.GetString(MotionRomL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMotionromL3", Util.GetString(MotionromL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR1", Util.GetInt(IsAlignmentR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR2", Util.GetInt(IsAlignmentR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR3", Util.GetInt(IsAlignmentR3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR4", Util.GetInt(IsAlignmentR4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR5", Util.GetInt(IsAlignmentR5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR6", Util.GetInt(IsAlignmentR6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR7", Util.GetInt(IsAlignmentR7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR8", Util.GetInt(IsAlignmentR8)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR9", Util.GetInt(IsAlignmentR9)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR10", Util.GetInt(IsAlignmentR10)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR11", Util.GetInt(IsAlignmentR11)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR12", Util.GetInt(IsAlignmentR12)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR13", Util.GetInt(IsAlignmentR13)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentR14", Util.GetInt(IsAlignmentR14)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL1", Util.GetInt(IsAlignmentL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL2", Util.GetInt(IsAlignmentL2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL3", Util.GetInt(IsAlignmentL3)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL4", Util.GetInt(IsAlignmentL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL5", Util.GetInt(IsAlignmentL5)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL6", Util.GetInt(IsAlignmentL6)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL7", Util.GetInt(IsAlignmentL7)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL8", Util.GetInt(IsAlignmentL8)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL9", Util.GetInt(IsAlignmentL9)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL10", Util.GetInt(IsAlignmentL10)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL11", Util.GetInt(IsAlignmentL11)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL12", Util.GetInt(IsAlignmentL12)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL13", Util.GetInt(IsAlignmentL13)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAlignmentL14", Util.GetInt(IsAlignmentL14)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRadioGRPAnalysis", Util.GetString(IsRadioGRPAnalysis)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAAlignmentR", Util.GetString(IsAAlignmentR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAAlignmentL", Util.GetString(IsAAlignmentL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFemurR", Util.GetInt(IsFemurR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFemurL", Util.GetInt(IsFemurL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaAPR", Util.GetInt(IsTiblaAPR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaAPL", Util.GetInt(IsTiblaAPL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaLATR", Util.GetInt(IsTiblaLATR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaLATL", Util.GetInt(IsTiblaLATL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaSCRR", Util.GetInt(IsTiblaSCRR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTiblaSCRL", Util.GetInt(IsTiblaSCRL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPatellaR", Util.GetInt(IsPatellaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPatellaL", Util.GetInt(IsPatellaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCFemurR", Util.GetInt(IsRLCFemurR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCFemurL", Util.GetInt(IsRLCFemurL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaAPR", Util.GetInt(IsRLCTiblaAPR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaAPL", Util.GetInt(IsRLCTiblaAPL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaLATR", Util.GetInt(IsRLCTiblaLATR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCTiblaLATL", Util.GetInt(IsRLCTiblaLATL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCPatellaR", Util.GetInt(IsRLCPatellaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRLCPatellaL", Util.GetInt(IsRLCPatellaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingFemurR", Util.GetString(IsLoosingFemurR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingFemurL", Util.GetString(IsLoosingFemurL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingTiblaR", Util.GetString(IsLoosingTiblaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingTiblaL", Util.GetString(IsLoosingTiblaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingPatellaR", Util.GetString(IsLoosingPatellaR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLoosingPatellaL", Util.GetString(IsLoosingPatellaL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPRR", Util.GetString(IsPRR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPRL", Util.GetString(IsPRL)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIPR", Util.GetString(IsIPR)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIPL", Util.GetString(IsIPL)));
            //cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

            Output = cmd.ExecuteNonQuery().ToString();

            //Output = cmd.ExecuteScalar().ToString();
            
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
