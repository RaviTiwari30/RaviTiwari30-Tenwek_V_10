using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_operating_room_record
{
    public ot_operating_room_record()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_operating_room_record(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Enter;
    private DateTime _ProcedureDate;
    private string _ProcedureStartTime;
    private string _ProcedureEndTime;
    private string _SurgeonID;
    private string _Assistants;
    private string _Emergency;
    private string _Scrub1;
    private string _Scrub1In;
    private string _Scrub1Out;
    private string _Scrub2;
    private string _Scrub2In;
    private string _Scrub2Out;
    private string _Circulator1;
    private string _Circulator1In;
    private string _Circulator1Out;
    private string _Circulator2;
    private string _Circulator2In;
    private string _Circulator2Out;
    private string _PreOpDiagnosis;
    private string _PostOpDiagnosis;
    private string _Operation;
    private string _Implants;
    private string _ScrubNurse;
    private string _CirculatorNurse;
    private string _XRayRoadBy;
    private string _XRayRoadResult;
    private string _Complication;
    private string _EnterBy;
    private DateTime _ProcedureStop;
    private string _ASA;
    private string _SCM;
    private string _NeuroMonitor;
    private string _DrainType;
    private string _DrainSite;
    private string _FinalCount;
    private string _FinalCountComment;
    private string _SpecimenDesc;
    private string _SpecimenType;
    private string _SpecimenSite;
    private string _Anaesthesiologist;
    private string _Anaesthesia;
    private string _ResearchOfficer;
    private DateTime _AnaesthesiaIn;
    private DateTime _AnaesthesiaOut;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Enter { get { return _Enter; } set { _Enter = value; } }
    public virtual DateTime ProcedureDate { get { return _ProcedureDate; } set { _ProcedureDate = value; } }
    public virtual string ProcedureStartTime { get { return _ProcedureStartTime; } set { _ProcedureStartTime = value; } }
    public virtual string ProcedureEndTime { get { return _ProcedureEndTime; } set { _ProcedureEndTime = value; } }
    public virtual string SurgeonID { get { return _SurgeonID; } set { _SurgeonID = value; } }
    public virtual string Assistants { get { return _Assistants; } set { _Assistants = value; } }
    public virtual string Emergency { get { return _Emergency; } set { _Emergency = value; } }
    public virtual string Scrub1 { get { return _Scrub1; } set { _Scrub1 = value; } }
    public virtual string Scrub1In { get { return _Scrub1In; } set { _Scrub1In = value; } }
    public virtual string Scrub1Out { get { return _Scrub1Out; } set { _Scrub1Out = value; } }
    public virtual string Scrub2 { get { return _Scrub2; } set { _Scrub2 = value; } }
    public virtual string Scrub2In { get { return _Scrub2In; } set { _Scrub2In = value; } }
    public virtual string Scrub2Out { get { return _Scrub2Out; } set { _Scrub2Out = value; } }
    public virtual string Circulator1 { get { return _Circulator1; } set { _Circulator1 = value; } }
    public virtual string Circulator1In { get { return _Circulator1In; } set { _Circulator1In = value; } }
    public virtual string Circulator1Out { get { return _Circulator1Out; } set { _Circulator1Out = value; } }
    public virtual string Circulator2 { get { return _Circulator2; } set { _Circulator2 = value; } }
    public virtual string Circulator2In { get { return _Circulator2In; } set { _Circulator2In = value; } }
    public virtual string Circulator2Out { get { return _Circulator2Out; } set { _Circulator2Out = value; } }
    public virtual string PreOpDiagnosis { get { return _PreOpDiagnosis; } set { _PreOpDiagnosis = value; } }
    public virtual string PostOpDiagnosis { get { return _PostOpDiagnosis; } set { _PostOpDiagnosis = value; } }
    public virtual string Operation { get { return _Operation; } set { _Operation = value; } }
    public virtual string Implants { get { return _Implants; } set { _Implants = value; } }
    public virtual string ScrubNurse { get { return _ScrubNurse; } set { _ScrubNurse = value; } }
    public virtual string CirculatorNurse { get { return _CirculatorNurse; } set { _CirculatorNurse = value; } }
    public virtual string XRayRoadBy { get { return _XRayRoadBy; } set { _XRayRoadBy = value; } }
    public virtual string XRayRoadResult { get { return _XRayRoadResult; } set { _XRayRoadResult = value; } }
    public virtual string Complication { get { return _Complication; } set { _Complication = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }
    public virtual DateTime ProcedureStop { get { return _ProcedureStop; } set { _ProcedureStop = value; } }
    public virtual string ASA { get { return _ASA; } set { _ASA = value; } }
    public virtual string SCM { get { return _SCM; } set { _SCM = value; } }
    public virtual string NeuroMonitor { get { return _NeuroMonitor; } set { _NeuroMonitor = value; } }
    public virtual string DrainType { get { return _DrainType; } set { _DrainType = value; } }
    public virtual string DrainSite { get { return _DrainSite; } set { _DrainSite = value; } }
    public virtual string FinalCount { get { return _FinalCount; } set { _FinalCount = value; } }
    public virtual string FinalCountComment { get { return _FinalCountComment; } set { _FinalCountComment = value; } }
    public virtual string SpecimenDesc { get { return _SpecimenDesc; } set { _SpecimenDesc = value; } }
    public virtual string SpecimenType { get { return _SpecimenType; } set { _SpecimenType = value; } }
    public virtual string SpecimenSite { get { return _SpecimenSite; } set { _SpecimenSite = value; } }
    public virtual string Anaesthesiologist { get { return _Anaesthesiologist; } set { _Anaesthesiologist = value; } }
    public virtual string Anaesthesia { get { return _Anaesthesia; } set { _Anaesthesia = value; } }
    public virtual string ResearchOfficer { get { return _ResearchOfficer; } set { _ResearchOfficer = value; } }
    public virtual DateTime AnaesthesiaIn { get { return _AnaesthesiaIn; } set { _AnaesthesiaIn = value; } }
    public virtual DateTime AnaesthesiaOut { get { return _AnaesthesiaOut; } set { _AnaesthesiaOut = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_operating_room_record_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vEnter", Util.GetString(Enter)));
            cmd.Parameters.Add(new MySqlParameter("@vProcedureDate", Util.GetDateTime(ProcedureDate)));
            cmd.Parameters.Add(new MySqlParameter("@vProcedureStartTime", Util.GetString(ProcedureStartTime)));
            cmd.Parameters.Add(new MySqlParameter("@vProcedureEndTime", Util.GetString(ProcedureEndTime)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeonID", Util.GetString(SurgeonID)));
            cmd.Parameters.Add(new MySqlParameter("@vAssistants", Util.GetString(Assistants)));
            cmd.Parameters.Add(new MySqlParameter("@vEmergency", Util.GetString(Emergency)));
            cmd.Parameters.Add(new MySqlParameter("@vScrub1", Util.GetString(Scrub1)));
            cmd.Parameters.Add(new MySqlParameter("@vScrub1In", Util.GetString(Scrub1In)));
            cmd.Parameters.Add(new MySqlParameter("@vScrub1Out", Util.GetString(Scrub1Out)));
            cmd.Parameters.Add(new MySqlParameter("@vScrub2", Util.GetString(Scrub2)));
            cmd.Parameters.Add(new MySqlParameter("@vScrub2In", Util.GetString(Scrub2In)));
            cmd.Parameters.Add(new MySqlParameter("@vScrub2Out", Util.GetString(Scrub2Out)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculator1", Util.GetString(Circulator1)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculator1In", Util.GetString(Circulator1In)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculator1Out", Util.GetString(Circulator1Out)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculator2", Util.GetString(Circulator2)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculator2In", Util.GetString(Circulator2In)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculator2Out", Util.GetString(Circulator2Out)));
            cmd.Parameters.Add(new MySqlParameter("@vPreOpDiagnosis", Util.GetString(PreOpDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vPostOpDiagnosis", Util.GetString(PostOpDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vOperation", Util.GetString(Operation)));
            cmd.Parameters.Add(new MySqlParameter("@vImplants", Util.GetString(Implants)));
            cmd.Parameters.Add(new MySqlParameter("@vScrubNurse", Util.GetString(ScrubNurse)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculatorNurse", Util.GetString(CirculatorNurse)));
            cmd.Parameters.Add(new MySqlParameter("@vXRayRoadBy", Util.GetString(XRayRoadBy)));
            cmd.Parameters.Add(new MySqlParameter("@vXRayRoadResult", Util.GetString(XRayRoadResult)));
            cmd.Parameters.Add(new MySqlParameter("@vComplication", Util.GetString(Complication)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));
            cmd.Parameters.Add(new MySqlParameter("@vProcedureStop1", Util.GetDateTime(ProcedureStop)));
            cmd.Parameters.Add(new MySqlParameter("@vASA1", Util.GetString(ASA)));
            cmd.Parameters.Add(new MySqlParameter("@vSCM1", Util.GetString(SCM)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroMonitor1", Util.GetString(NeuroMonitor)));
            cmd.Parameters.Add(new MySqlParameter("@vDrainType1", Util.GetString(DrainType)));
            cmd.Parameters.Add(new MySqlParameter("@vDrainSite1", Util.GetString(DrainSite)));
            cmd.Parameters.Add(new MySqlParameter("@vFinalCount1", Util.GetString(FinalCount)));
            cmd.Parameters.Add(new MySqlParameter("@vFinalCountComment1", Util.GetString(FinalCountComment)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecimenDesc1", Util.GetString(SpecimenDesc)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecimenType1", Util.GetString(SpecimenType)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecimenSite1", Util.GetString(SpecimenSite)));

            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiologist", Util.GetString(Anaesthesiologist)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesia", Util.GetString(Anaesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vResearchOfficer", Util.GetString(ResearchOfficer)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaIn", Util.GetDateTime(AnaesthesiaIn)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaOut", Util.GetDateTime(AnaesthesiaOut)));

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