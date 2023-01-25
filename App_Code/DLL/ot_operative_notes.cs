using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_operative_notes
{
    public ot_operative_notes()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_operative_notes(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private DateTime _SurgeryBegan;
    private DateTime _SurgeryEnd;
    private string _SDSAMS;
    private string _Location;
    private string _PreOpDiagnosis;
    private string _PostOperativeDiagnosis;
    private string _OperativeProcedure;
    private string _WoundClosures;
    private string _Anesthesia;
    private string _Anesthesiologist;
    private string _Implants;
    private string _Pathlogy;
    private string _PathlogyIssueType;
    private string _Culture;
    private string _LocationText;
    private DateTime _OperativeTime;
    private string _SpinalCordMonitoring;
    private string _EBL;
    private string _Drains;
    private string _DrainsType;
    private string _Complication;
    private string _ComplicationDetail;
    private string _IsApproved;
    private string _EntryBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime SurgeryBegan { get { return _SurgeryBegan; } set { _SurgeryBegan = value; } }
    public virtual DateTime SurgeryEnd { get { return _SurgeryEnd; } set { _SurgeryEnd = value; } }
    public virtual string SDSAMS { get { return _SDSAMS; } set { _SDSAMS = value; } }
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string PreOpDiagnosis { get { return _PreOpDiagnosis; } set { _PreOpDiagnosis = value; } }
    public virtual string PostOperativeDiagnosis { get { return _PostOperativeDiagnosis; } set { _PostOperativeDiagnosis = value; } }
    public virtual string OperativeProcedure { get { return _OperativeProcedure; } set { _OperativeProcedure = value; } }
    public virtual string WoundClosures { get { return _WoundClosures; } set { _WoundClosures = value; } }
    public virtual string Anesthesia { get { return _Anesthesia; } set { _Anesthesia = value; } }
    public virtual string Anesthesiologist { get { return _Anesthesiologist; } set { _Anesthesiologist = value; } }
    public virtual string Implants { get { return _Implants; } set { _Implants = value; } }
    public virtual string Pathlogy { get { return _Pathlogy; } set { _Pathlogy = value; } }
    public virtual string PathlogyIssueType { get { return _PathlogyIssueType; } set { _PathlogyIssueType = value; } }
    public virtual string Culture { get { return _Culture; } set { _Culture = value; } }
    public virtual string LocationText { get { return _LocationText; } set { _LocationText = value; } }
    public virtual DateTime OperativeTime { get { return _OperativeTime; } set { _OperativeTime = value; } }
    public virtual string SpinalCordMonitoring { get { return _SpinalCordMonitoring; } set { _SpinalCordMonitoring = value; } }
    public virtual string EBL { get { return _EBL; } set { _EBL = value; } }
    public virtual string Drains { get { return _Drains; } set { _Drains = value; } }
    public virtual string DrainsType { get { return _DrainsType; } set { _DrainsType = value; } }
    public virtual string Complication { get { return _Complication; } set { _Complication = value; } }
    public virtual string ComplicationDetail { get { return _ComplicationDetail; } set { _ComplicationDetail = value; } }
    public virtual string IsApproved { get { return _IsApproved; } set { _IsApproved = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_operative_notes_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryBegan", Util.GetDateTime(SurgeryBegan)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryEnd", Util.GetDateTime(SurgeryEnd)));
            cmd.Parameters.Add(new MySqlParameter("@vSDSAMS", Util.GetString(SDSAMS)));
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vPreOpDiagnosis", Util.GetString(PreOpDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vPostOperativeDiagnosis", Util.GetString(PostOperativeDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vOperativeProcedure", Util.GetString(OperativeProcedure)));
            cmd.Parameters.Add(new MySqlParameter("@vWoundClosures", Util.GetString(WoundClosures)));
            cmd.Parameters.Add(new MySqlParameter("@vAnesthesia", Util.GetString(Anesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vAnesthesiologist", Util.GetString(Anesthesiologist)));
            cmd.Parameters.Add(new MySqlParameter("@vImplants", Util.GetString(Implants)));
            cmd.Parameters.Add(new MySqlParameter("@vPathlogy", Util.GetString(Pathlogy)));
            cmd.Parameters.Add(new MySqlParameter("@vPathlogyIssueType", Util.GetString(PathlogyIssueType)));
            cmd.Parameters.Add(new MySqlParameter("@vCulture", Util.GetString(Culture)));
            cmd.Parameters.Add(new MySqlParameter("@vLocationText", Util.GetString(LocationText)));
            cmd.Parameters.Add(new MySqlParameter("@vOperativeTime", Util.GetDateTime(OperativeTime)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinalCordMonitoring", Util.GetString(SpinalCordMonitoring)));
            cmd.Parameters.Add(new MySqlParameter("@vEBL", Util.GetString(EBL)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vDrainsType", Util.GetString(DrainsType)));
            cmd.Parameters.Add(new MySqlParameter("@vComplication", Util.GetString(Complication)));
            cmd.Parameters.Add(new MySqlParameter("@vComplicationDetail", Util.GetString(ComplicationDetail)));
            cmd.Parameters.Add(new MySqlParameter("@vIsApproved", Util.GetString(IsApproved)));
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

    #endregion All Public Member Function
}