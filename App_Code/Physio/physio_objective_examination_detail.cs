using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_objective_examination_detail  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:              RAHUL 
/// Create date:	3/29/2014 6:31:00 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_objective_examination_detail table 
/// ========================================================================================== 
/// </summary>  

public class physio_objective_examination_detail
{
    public physio_objective_examination_detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_objective_examination_detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _AttitudeLimbs;
    private string _InLying;
    private string _InSitting;
    private string _InStanding;
    private string _DeepTendonReflexes;
    private string _PlantarResp;
    private string _Pattern;
    private string _Speen;
    private string _Orthosis;
    private string _Distance;
    private string _UseWalkingAids;
    private string _AssistanceFromOther;
    private string _Tenderness;
    private string _SwellingOedema;
    private string _SkinTemp;
    private string _Clubbing;
    private string _BloodPressure;
    private string _Memory;
    private string _Orientation;
    private string _Speech;
    private string _ToneUpperLimbs;
    private string _MuscleMassUpperLimbs;
    private string _JointUpperLimbs;
    private string _MusclePowerUpperLimbs;
    private string _ToneLowerLimbs;
    private string _MuscleMassLowerLimbs;
    private string _JointLowerLimbs;
    private string _MusclePowerLowerLimbs;
    private string _LightTouch;
    private string _Pain;
    private string _PinPick;
    private string _Temperature;
    private string _Vibrations;
    private string _JointPositionSense;
    private string _BalanceStatic;
    private string _CoordinationFingerNose;
    private string _BalanceDynamic;
    private string _CoordinationHeelShin;
    private string _BedMobility;
    private string _UpperLimbFunction;
    private string _Stairs;
    private string _SittingBalance;
    private string _Mobility;
    private string _EnterBy;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string AttitudeLimbs { get { return _AttitudeLimbs; } set { _AttitudeLimbs = value; } }
    public virtual string InLying { get { return _InLying; } set { _InLying = value; } }
    public virtual string InSitting { get { return _InSitting; } set { _InSitting = value; } }
    public virtual string InStanding { get { return _InStanding; } set { _InStanding = value; } }
    public virtual string DeepTendonReflexes { get { return _DeepTendonReflexes; } set { _DeepTendonReflexes = value; } }
    public virtual string PlantarResp { get { return _PlantarResp; } set { _PlantarResp = value; } }
    public virtual string Pattern { get { return _Pattern; } set { _Pattern = value; } }
    public virtual string Speen { get { return _Speen; } set { _Speen = value; } }
    public virtual string Orthosis { get { return _Orthosis; } set { _Orthosis = value; } }
    public virtual string Distance { get { return _Distance; } set { _Distance = value; } }
    public virtual string UseWalkingAids { get { return _UseWalkingAids; } set { _UseWalkingAids = value; } }
    public virtual string AssistanceFromOther { get { return _AssistanceFromOther; } set { _AssistanceFromOther = value; } }
    public virtual string Tenderness { get { return _Tenderness; } set { _Tenderness = value; } }
    public virtual string SwellingOedema { get { return _SwellingOedema; } set { _SwellingOedema = value; } }
    public virtual string SkinTemp { get { return _SkinTemp; } set { _SkinTemp = value; } }
    public virtual string Clubbing { get { return _Clubbing; } set { _Clubbing = value; } }
    public virtual string BloodPressure { get { return _BloodPressure; } set { _BloodPressure = value; } }
    public virtual string Memory { get { return _Memory; } set { _Memory = value; } }
    public virtual string Orientation { get { return _Orientation; } set { _Orientation = value; } }
    public virtual string Speech { get { return _Speech; } set { _Speech = value; } }
    public virtual string ToneUpperLimbs { get { return _ToneUpperLimbs; } set { _ToneUpperLimbs = value; } }
    public virtual string MuscleMassUpperLimbs { get { return _MuscleMassUpperLimbs; } set { _MuscleMassUpperLimbs = value; } }
    public virtual string JointUpperLimbs { get { return _JointUpperLimbs; } set { _JointUpperLimbs = value; } }
    public virtual string MusclePowerUpperLimbs { get { return _MusclePowerUpperLimbs; } set { _MusclePowerUpperLimbs = value; } }
    public virtual string ToneLowerLimbs { get { return _ToneLowerLimbs; } set { _ToneLowerLimbs = value; } }
    public virtual string MuscleMassLowerLimbs { get { return _MuscleMassLowerLimbs; } set { _MuscleMassLowerLimbs = value; } }
    public virtual string JointLowerLimbs { get { return _JointLowerLimbs; } set { _JointLowerLimbs = value; } }
    public virtual string MusclePowerLowerLimbs { get { return _MusclePowerLowerLimbs; } set { _MusclePowerLowerLimbs = value; } }
    public virtual string LightTouch { get { return _LightTouch; } set { _LightTouch = value; } }
    public virtual string Pain { get { return _Pain; } set { _Pain = value; } }
    public virtual string PinPick { get { return _PinPick; } set { _PinPick = value; } }
    public virtual string Temperature { get { return _Temperature; } set { _Temperature = value; } }
    public virtual string Vibrations { get { return _Vibrations; } set { _Vibrations = value; } }
    public virtual string JointPositionSense { get { return _JointPositionSense; } set { _JointPositionSense = value; } }
    public virtual string BalanceStatic { get { return _BalanceStatic; } set { _BalanceStatic = value; } }
    public virtual string CoordinationFingerNose { get { return _CoordinationFingerNose; } set { _CoordinationFingerNose = value; } }
    public virtual string BalanceDynamic { get { return _BalanceDynamic; } set { _BalanceDynamic = value; } }
    public virtual string CoordinationHeelShin { get { return _CoordinationHeelShin; } set { _CoordinationHeelShin = value; } }
    public virtual string BedMobility { get { return _BedMobility; } set { _BedMobility = value; } }
    public virtual string UpperLimbFunction { get { return _UpperLimbFunction; } set { _UpperLimbFunction = value; } }
    public virtual string Stairs { get { return _Stairs; } set { _Stairs = value; } }
    public virtual string SittingBalance { get { return _SittingBalance; } set { _SittingBalance = value; } }
    public virtual string Mobility { get { return _Mobility; } set { _Mobility = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_objective_examination_detail_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAttitudeLimbs", Util.GetString(AttitudeLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vInLying", Util.GetString(InLying)));
            cmd.Parameters.Add(new MySqlParameter("@vInSitting", Util.GetString(InSitting)));
            cmd.Parameters.Add(new MySqlParameter("@vInStanding", Util.GetString(InStanding)));
            cmd.Parameters.Add(new MySqlParameter("@vDeepTendonReflexes", Util.GetString(DeepTendonReflexes)));
            cmd.Parameters.Add(new MySqlParameter("@vPlantarResp", Util.GetString(PlantarResp)));
            cmd.Parameters.Add(new MySqlParameter("@vPattern", Util.GetString(Pattern)));
            cmd.Parameters.Add(new MySqlParameter("@vSpeen", Util.GetString(Speen)));
            cmd.Parameters.Add(new MySqlParameter("@vOrthosis", Util.GetString(Orthosis)));
            cmd.Parameters.Add(new MySqlParameter("@vDistance", Util.GetString(Distance)));
            cmd.Parameters.Add(new MySqlParameter("@vUseWalkingAids", Util.GetString(UseWalkingAids)));
            cmd.Parameters.Add(new MySqlParameter("@vAssistanceFromOther", Util.GetString(AssistanceFromOther)));
            cmd.Parameters.Add(new MySqlParameter("@vTenderness", Util.GetString(Tenderness)));
            cmd.Parameters.Add(new MySqlParameter("@vSwellingOedema", Util.GetString(SwellingOedema)));
            cmd.Parameters.Add(new MySqlParameter("@vSkinTemp", Util.GetString(SkinTemp)));
            cmd.Parameters.Add(new MySqlParameter("@vClubbing", Util.GetString(Clubbing)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodPressure", Util.GetString(BloodPressure)));
            cmd.Parameters.Add(new MySqlParameter("@vMemory", Util.GetString(Memory)));
            cmd.Parameters.Add(new MySqlParameter("@vOrientation", Util.GetString(Orientation)));
            cmd.Parameters.Add(new MySqlParameter("@vSpeech", Util.GetString(Speech)));
            cmd.Parameters.Add(new MySqlParameter("@vToneUpperLimbs", Util.GetString(ToneUpperLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleMassUpperLimbs", Util.GetString(MuscleMassUpperLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vJointUpperLimbs", Util.GetString(JointUpperLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vMusclePowerUpperLimbs", Util.GetString(MusclePowerUpperLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vToneLowerLimbs", Util.GetString(ToneLowerLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleMassLowerLimbs", Util.GetString(MuscleMassLowerLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vJointLowerLimbs", Util.GetString(JointLowerLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vMusclePowerLowerLimbs", Util.GetString(MusclePowerLowerLimbs)));
            cmd.Parameters.Add(new MySqlParameter("@vLightTouch", Util.GetString(LightTouch)));
            cmd.Parameters.Add(new MySqlParameter("@vPain", Util.GetString(Pain)));
            cmd.Parameters.Add(new MySqlParameter("@vPinPick", Util.GetString(PinPick)));
            cmd.Parameters.Add(new MySqlParameter("@vTemperature", Util.GetString(Temperature)));
            cmd.Parameters.Add(new MySqlParameter("@vVibrations", Util.GetString(Vibrations)));
            cmd.Parameters.Add(new MySqlParameter("@vJointPositionSense", Util.GetString(JointPositionSense)));
            cmd.Parameters.Add(new MySqlParameter("@vBalanceStatic", Util.GetString(BalanceStatic)));
            cmd.Parameters.Add(new MySqlParameter("@vCoordinationFingerNose", Util.GetString(CoordinationFingerNose)));
            cmd.Parameters.Add(new MySqlParameter("@vBalanceDynamic", Util.GetString(BalanceDynamic)));
            cmd.Parameters.Add(new MySqlParameter("@vCoordinationHeelShin", Util.GetString(CoordinationHeelShin)));
            cmd.Parameters.Add(new MySqlParameter("@vBedMobility", Util.GetString(BedMobility)));
            cmd.Parameters.Add(new MySqlParameter("@vUpperLimbFunction", Util.GetString(UpperLimbFunction)));
            cmd.Parameters.Add(new MySqlParameter("@vStairs", Util.GetString(Stairs)));
            cmd.Parameters.Add(new MySqlParameter("@vSittingBalance", Util.GetString(SittingBalance)));
            cmd.Parameters.Add(new MySqlParameter("@vMobility", Util.GetString(Mobility)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));

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





    #endregion

}
