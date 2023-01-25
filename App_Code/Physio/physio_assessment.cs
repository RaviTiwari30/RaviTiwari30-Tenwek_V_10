using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_assessment  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/1/2014 12:54:03 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_assessment table 
/// ========================================================================================== 
/// </summary>  

public class physio_assessment
{
    public physio_assessment()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_assessment(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Days1;
    private string _Days2;
    private string _Days3;
    private string _ReferToDr;
    private string _Speech;
    private string _Vision;
    private string _Hearing;
    private string _Drain;
    private string _Rom_Rt;
    private string _Rom_Lt;
    private string _Strength_Rt;
    private string _Strength_Lt;
    private string _Transfer_Min;
    private string _Bed;
    private string _Sitting;
    private string _Standing;
    private string _Gait;
    private string _Sensation;
    private string _Factors;
    private string _Learning;
    private string _Potential;
    private string _Assessment;
    private string _Goals;
    private string _Program;
    private string _Assist;

    private string _Transfers;
    private string _Transfers_Assist;
    private string _Transfers_Days;
    private string _Ambulate;
    private string _Device;
    private string _Ambulate_Assist;
    private string _Ambulate_Days;
    private string _Additional_Goals;
    private string _Treatment_Plan;
    private string _Duration;
    private string _EntryBy;

    private string _Physician;
    private string _Underwent;
    private DateTime _OnDate;
    private DateTime _EvalDate;
    private string _Precautions;
    private string _Orders;
    private string _PMH;
    private string _Previous;
    private string _Treatment;
    private string _HomeExercise;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Speech { get { return _Speech; } set { _Speech = value; } }
    public virtual string days1 { get { return _Days1; } set { _Days1 = value; } }
    public virtual string days2 { get { return _Days2; } set { _Days2 = value; } }
    public virtual string days3 { get { return _Days3; } set { _Days3 = value; } }
    public virtual string ReferToDr { get { return _ReferToDr; } set { _ReferToDr = value; } }
    public virtual string Vision { get { return _Vision; } set { _Vision = value; } }
    public virtual string Hearing { get { return _Hearing; } set { _Hearing = value; } }
    public virtual string Drain { get { return _Drain; } set { _Drain = value; } }
    public virtual string Rom_Rt { get { return _Rom_Rt; } set { _Rom_Rt = value; } }
    public virtual string Rom_Lt { get { return _Rom_Lt; } set { _Rom_Lt = value; } }
    public virtual string Strength_Rt { get { return _Strength_Rt; } set { _Strength_Rt = value; } }
    public virtual string Strength_Lt { get { return _Strength_Lt; } set { _Strength_Lt = value; } }
    public virtual string Transfer_Min { get { return _Transfer_Min; } set { _Transfer_Min = value; } }
    public virtual string Bed { get { return _Bed; } set { _Bed = value; } }
    public virtual string Sitting { get { return _Sitting; } set { _Sitting = value; } }
    public virtual string Standing { get { return _Standing; } set { _Standing = value; } }
    public virtual string Gait { get { return _Gait; } set { _Gait = value; } }
    public virtual string Sensation { get { return _Sensation; } set { _Sensation = value; } }
    public virtual string Factors { get { return _Factors; } set { _Factors = value; } }
    public virtual string Learning { get { return _Learning; } set { _Learning = value; } }
    public virtual string Potential { get { return _Potential; } set { _Potential = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Goals { get { return _Goals; } set { _Goals = value; } }
    public virtual string Program { get { return _Program; } set { _Program = value; } }
    public virtual string Assist { get { return _Assist; } set { _Assist = value; } }

    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Transfers_Assist { get { return _Transfers_Assist; } set { _Transfers_Assist = value; } }
    public virtual string Transfers_Days { get { return _Transfers_Days; } set { _Transfers_Days = value; } }
    public virtual string Ambulate { get { return _Ambulate; } set { _Ambulate = value; } }
    public virtual string Device { get { return _Device; } set { _Device = value; } }
    public virtual string Ambulate_Assist { get { return _Ambulate_Assist; } set { _Ambulate_Assist = value; } }
    public virtual string Ambulate_Days { get { return _Ambulate_Days; } set { _Ambulate_Days = value; } }
    public virtual string Additional_Goals { get { return _Additional_Goals; } set { _Additional_Goals = value; } }
    public virtual string Treatment_Plan { get { return _Treatment_Plan; } set { _Treatment_Plan = value; } }
    public virtual string Duration { get { return _Duration; } set { _Duration = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }


    public virtual string Physician { get { return _Physician; } set { _Physician = value; } }
    public virtual string Underwent { get { return _Underwent; } set { _Underwent = value; } }
    public virtual DateTime OnDate { get { return _OnDate; } set { _OnDate = value; } }
    public virtual DateTime EvalDate { get { return _EvalDate; } set { _EvalDate = value; } }
    public virtual string Precautions { get { return _Precautions; } set { _Precautions = value; } }
    public virtual string Orders { get { return _Orders; } set { _Orders = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string Previous { get { return _Previous; } set { _Previous = value; } }
    public virtual string Treatment { get { return _Treatment; } set { _Treatment = value; } }

    public virtual string HomeExercise { get { return _HomeExercise; } set { _HomeExercise = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_assessment_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vSpeech", Util.GetString(Speech)));
            cmd.Parameters.Add(new MySqlParameter("@vDays1", Util.GetString(days1)));
            cmd.Parameters.Add(new MySqlParameter("@vDays2", Util.GetString(days2)));
            cmd.Parameters.Add(new MySqlParameter("@vDays3", Util.GetString(days3)));
            cmd.Parameters.Add(new MySqlParameter("@vReferToDr", Util.GetString(ReferToDr)));
            cmd.Parameters.Add(new MySqlParameter("@vVision", Util.GetString(Vision)));
            cmd.Parameters.Add(new MySqlParameter("@vHearing", Util.GetString(Hearing)));
            cmd.Parameters.Add(new MySqlParameter("@vDrain", Util.GetString(Drain)));
            cmd.Parameters.Add(new MySqlParameter("@vRom_Rt", Util.GetString(Rom_Rt)));
            cmd.Parameters.Add(new MySqlParameter("@vRom_Lt", Util.GetString(Rom_Lt)));
            cmd.Parameters.Add(new MySqlParameter("@vStrength_Rt", Util.GetString(Strength_Rt)));
            cmd.Parameters.Add(new MySqlParameter("@vStrength_Lt", Util.GetString(Strength_Lt)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfer_Min", Util.GetString(Transfer_Min)));
            cmd.Parameters.Add(new MySqlParameter("@vBed", Util.GetString(Bed)));
            cmd.Parameters.Add(new MySqlParameter("@vSitting", Util.GetString(Sitting)));
            cmd.Parameters.Add(new MySqlParameter("@vStanding", Util.GetString(Standing)));
            cmd.Parameters.Add(new MySqlParameter("@vGait", Util.GetString(Gait)));
            cmd.Parameters.Add(new MySqlParameter("@vSensation", Util.GetString(Sensation)));
            cmd.Parameters.Add(new MySqlParameter("@vFactors", Util.GetString(Factors)));
            cmd.Parameters.Add(new MySqlParameter("@vLearning", Util.GetString(Learning)));
            cmd.Parameters.Add(new MySqlParameter("@vPotential", Util.GetString(Potential)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vGoals", Util.GetString(Goals)));
            cmd.Parameters.Add(new MySqlParameter("@vProgram", Util.GetString(Program)));
            cmd.Parameters.Add(new MySqlParameter("@vAssist", Util.GetString(Assist)));

            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers_Assist", Util.GetString(Transfers_Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers_Days", Util.GetString(Transfers_Days)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulate", Util.GetString(Ambulate)));
            cmd.Parameters.Add(new MySqlParameter("@vDevice", Util.GetString(Device)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulate_Assist", Util.GetString(Ambulate_Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulate_Days", Util.GetString(Ambulate_Days)));
            cmd.Parameters.Add(new MySqlParameter("@vAdditional_Goals", Util.GetString(Additional_Goals)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatment_Plan", Util.GetString(Treatment_Plan)));
            cmd.Parameters.Add(new MySqlParameter("@vDuration", Util.GetString(Duration)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));


            cmd.Parameters.Add(new MySqlParameter("@vPhysician", Util.GetString(Physician)));
            cmd.Parameters.Add(new MySqlParameter("@vUnderwent", Util.GetString(Underwent)));
            cmd.Parameters.Add(new MySqlParameter("@vOnDate", Util.GetDateTime(OnDate)));
            cmd.Parameters.Add(new MySqlParameter("@vEvalDate", Util.GetDateTime(EvalDate)));
            cmd.Parameters.Add(new MySqlParameter("@vPrecautions", Util.GetString(Precautions)));
            cmd.Parameters.Add(new MySqlParameter("@vOrders", Util.GetString(Orders)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPrevious", Util.GetString(Previous)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatment", Util.GetString(Treatment)));

            cmd.Parameters.Add(new MySqlParameter("@vHomeExercise", Util.GetString(HomeExercise)));


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
