using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_postanesthesiaunit
{
    public ot_postanesthesiaunit()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_postanesthesiaunit(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private DateTime _UnitDate;
    private string _UnitTimein;
    private string _UnitTimeOut;
    private string _Operation;
    private string _OperationGeneral;
    private string _Spinal;
    private string _TimeMovement;
    private string _Surgeon;
    private string _Anaesthetist;
    private string _ORNurse;
    private string _Airway;
    private string _AirwayOther;
    private string _Dressing;
    private string _DressingOther;
    private string _Drains;
    private string _DrainsOther;
    private string _Monitors;
    private string _MonitorsOthers;
    private string _Pre_Op;
    private string _Temp;
    private string _Pulse;
    private string _BP;
    private string _Allergies;
    private string _HX;
    private string _PainScore;
    private string _Activity;
    private string _Respiration;
    private string _Circulation;
    private string _Consciousness;
    private string _Oxygen;
    private string _Modified;
    private string _Sensory;
    private string _TotalAldrere;
    private string _EntryBy;
    private string _UpdatedBy;
    private DateTime _UpdateDate;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime UnitDate { get { return _UnitDate; } set { _UnitDate = value; } }
    public virtual string UnitTimein { get { return _UnitTimein; } set { _UnitTimein = value; } }
    public virtual string UnitTimeOut { get { return _UnitTimeOut; } set { _UnitTimeOut = value; } }
    public virtual string Operation { get { return _Operation; } set { _Operation = value; } }
    public virtual string OperationGeneral { get { return _OperationGeneral; } set { _OperationGeneral = value; } }
    public virtual string Spinal { get { return _Spinal; } set { _Spinal = value; } }
    public virtual string TimeMovement { get { return _TimeMovement; } set { _TimeMovement = value; } }
    public virtual string Surgeon { get { return _Surgeon; } set { _Surgeon = value; } }
    public virtual string Anaesthetist { get { return _Anaesthetist; } set { _Anaesthetist = value; } }
    public virtual string ORNurse { get { return _ORNurse; } set { _ORNurse = value; } }
    public virtual string Airway { get { return _Airway; } set { _Airway = value; } }
    public virtual string AirwayOther { get { return _AirwayOther; } set { _AirwayOther = value; } }
    public virtual string Dressing { get { return _Dressing; } set { _Dressing = value; } }
    public virtual string DressingOther { get { return _DressingOther; } set { _DressingOther = value; } }
    public virtual string Drains { get { return _Drains; } set { _Drains = value; } }
    public virtual string DrainsOther { get { return _DrainsOther; } set { _DrainsOther = value; } }
    public virtual string Monitors { get { return _Monitors; } set { _Monitors = value; } }
    public virtual string MonitorsOthers { get { return _MonitorsOthers; } set { _MonitorsOthers = value; } }
    public virtual string Pre_Op { get { return _Pre_Op; } set { _Pre_Op = value; } }
    public virtual string Temp { get { return _Temp; } set { _Temp = value; } }
    public virtual string Pulse { get { return _Pulse; } set { _Pulse = value; } }
    public virtual string BP { get { return _BP; } set { _BP = value; } }
    public virtual string Allergies { get { return _Allergies; } set { _Allergies = value; } }
    public virtual string HX { get { return _HX; } set { _HX = value; } }
    public virtual string PainScore { get { return _PainScore; } set { _PainScore = value; } }
    public virtual string Activity { get { return _Activity; } set { _Activity = value; } }
    public virtual string Respiration { get { return _Respiration; } set { _Respiration = value; } }
    public virtual string Circulation { get { return _Circulation; } set { _Circulation = value; } }
    public virtual string Consciousness { get { return _Consciousness; } set { _Consciousness = value; } }
    public virtual string Oxygen { get { return _Oxygen; } set { _Oxygen = value; } }
    public virtual string Modified { get { return _Modified; } set { _Modified = value; } }
    public virtual string Sensory { get { return _Sensory; } set { _Sensory = value; } }
    public virtual string TotalAldrere { get { return _TotalAldrere; } set { _TotalAldrere = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_postanesthesiaunit_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vUnitDate", Util.GetDateTime(UnitDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUnitTimein", Util.GetString(UnitTimein)));
            cmd.Parameters.Add(new MySqlParameter("@vUnitTimeOut", Util.GetString(UnitTimeOut)));
            cmd.Parameters.Add(new MySqlParameter("@vOperation", Util.GetString(Operation)));
            cmd.Parameters.Add(new MySqlParameter("@vOperationGeneral", Util.GetString(OperationGeneral)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinal", Util.GetString(Spinal)));
            cmd.Parameters.Add(new MySqlParameter("@vTimeMovement", Util.GetString(TimeMovement)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeon", Util.GetString(Surgeon)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetist", Util.GetString(Anaesthetist)));
            cmd.Parameters.Add(new MySqlParameter("@vORNurse", Util.GetString(ORNurse)));
            cmd.Parameters.Add(new MySqlParameter("@vAirway", Util.GetString(Airway)));
            cmd.Parameters.Add(new MySqlParameter("@vAirwayOther", Util.GetString(AirwayOther)));
            cmd.Parameters.Add(new MySqlParameter("@vDressing", Util.GetString(Dressing)));
            cmd.Parameters.Add(new MySqlParameter("@vDressingOther", Util.GetString(DressingOther)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vDrainsOther", Util.GetString(DrainsOther)));
            cmd.Parameters.Add(new MySqlParameter("@vMonitors", Util.GetString(Monitors)));
            cmd.Parameters.Add(new MySqlParameter("@vMonitorsOthers", Util.GetString(MonitorsOthers)));
            cmd.Parameters.Add(new MySqlParameter("@vPre_Op", Util.GetString(Pre_Op)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp", Util.GetString(Temp)));
            cmd.Parameters.Add(new MySqlParameter("@vPulse", Util.GetString(Pulse)));
            cmd.Parameters.Add(new MySqlParameter("@vBP", Util.GetString(BP)));
            cmd.Parameters.Add(new MySqlParameter("@vAllergies", Util.GetString(Allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vHX", Util.GetString(HX)));
            cmd.Parameters.Add(new MySqlParameter("@vPainScore", Util.GetString(PainScore)));
            cmd.Parameters.Add(new MySqlParameter("@vActivity", Util.GetString(Activity)));
            cmd.Parameters.Add(new MySqlParameter("@vRespiration", Util.GetString(Respiration)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculation", Util.GetString(Circulation)));
            cmd.Parameters.Add(new MySqlParameter("@vConsciousness", Util.GetString(Consciousness)));
            cmd.Parameters.Add(new MySqlParameter("@vOxygen", Util.GetString(Oxygen)));
            cmd.Parameters.Add(new MySqlParameter("@vModified", Util.GetString(Modified)));
            cmd.Parameters.Add(new MySqlParameter("@vSensory", Util.GetString(Sensory)));
            cmd.Parameters.Add(new MySqlParameter("@vTotalAldrere", Util.GetString(TotalAldrere)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));

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

            objSQL.Append("ot_postanesthesiaunit_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vUnitDate", Util.GetDateTime(UnitDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUnitTimein", Util.GetString(UnitTimein)));
            cmd.Parameters.Add(new MySqlParameter("@vUnitTimeOut", Util.GetString(UnitTimeOut)));
            cmd.Parameters.Add(new MySqlParameter("@vOperation", Util.GetString(Operation)));
            cmd.Parameters.Add(new MySqlParameter("@vOperationGeneral", Util.GetString(OperationGeneral)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinal", Util.GetString(Spinal)));
            cmd.Parameters.Add(new MySqlParameter("@vTimeMovement", Util.GetString(TimeMovement)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeon", Util.GetString(Surgeon)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetist", Util.GetString(Anaesthetist)));
            cmd.Parameters.Add(new MySqlParameter("@vORNurse", Util.GetString(ORNurse)));
            cmd.Parameters.Add(new MySqlParameter("@vAirway", Util.GetString(Airway)));
            cmd.Parameters.Add(new MySqlParameter("@vAirwayOther", Util.GetString(AirwayOther)));
            cmd.Parameters.Add(new MySqlParameter("@vDressing", Util.GetString(Dressing)));
            cmd.Parameters.Add(new MySqlParameter("@vDressingOther", Util.GetString(DressingOther)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vDrainsOther", Util.GetString(DrainsOther)));
            cmd.Parameters.Add(new MySqlParameter("@vMonitors", Util.GetString(Monitors)));
            cmd.Parameters.Add(new MySqlParameter("@vMonitorsOthers", Util.GetString(MonitorsOthers)));
            cmd.Parameters.Add(new MySqlParameter("@vPre_Op", Util.GetString(Pre_Op)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp", Util.GetString(Temp)));
            cmd.Parameters.Add(new MySqlParameter("@vPulse", Util.GetString(Pulse)));
            cmd.Parameters.Add(new MySqlParameter("@vBP", Util.GetString(BP)));
            cmd.Parameters.Add(new MySqlParameter("@vAllergies", Util.GetString(Allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vHX", Util.GetString(HX)));
            cmd.Parameters.Add(new MySqlParameter("@vPainScore", Util.GetString(PainScore)));
            cmd.Parameters.Add(new MySqlParameter("@vActivity", Util.GetString(Activity)));
            cmd.Parameters.Add(new MySqlParameter("@vRespiration", Util.GetString(Respiration)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculation", Util.GetString(Circulation)));
            cmd.Parameters.Add(new MySqlParameter("@vConsciousness", Util.GetString(Consciousness)));
            cmd.Parameters.Add(new MySqlParameter("@vOxygen", Util.GetString(Oxygen)));
            cmd.Parameters.Add(new MySqlParameter("@vModified", Util.GetString(Modified)));
            cmd.Parameters.Add(new MySqlParameter("@vSensory", Util.GetString(Sensory)));
            cmd.Parameters.Add(new MySqlParameter("@vTotalAldrere", Util.GetString(TotalAldrere)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

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

    #endregion All Public Member Function
}