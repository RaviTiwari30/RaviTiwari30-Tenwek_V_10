using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_operation_room_record_detail
{
    public ot_operation_room_record_detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_operation_room_record_detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _SurgeonID;
    private string _AnaesthetistID;
    private string _SecondSurgeonID;
    private string _SecondAnaesthesia;
    private string _PreDiagnosis;
    private string _PostDiagnosis;
    private string _SurgeryID;
    private string _OperationDetail;
    private string _Implants;
    private string _Findings;
    private string _Culture;
    private string _EBL;
    private string _Drains;
    private string _CellSaver;
    private string _Transfusion;
    private DateTime _OperatingTime;
    private string _SpinalCordMonitoring;
    private string _Complication;
    private string _ComplicationDetail;
    private string _EnterBy;
    private int _IsApproved;
    private string _ApprovedBy;
    private DateTime _SurgeryBegan;
    private DateTime _SurgeryEnd;
    private string _SDSAMS;
    private string _Location;
    private string _WoundClosures;
    private string _Anesthesia;
    private string _Pathlogy;
    private string _PathlogyIssueType;
    private string _OtherCulture;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string SurgeonID { get { return _SurgeonID; } set { _SurgeonID = value; } }
    public virtual string AnaesthetistID { get { return _AnaesthetistID; } set { _AnaesthetistID = value; } }

    public virtual string SecondSurgeonID { get { return _SecondSurgeonID; } set { _SecondSurgeonID = value; } }
    public virtual string SecondAnaesthesia { get { return _SecondAnaesthesia; } set { _SecondAnaesthesia = value; } }

    public virtual string PreDiagnosis { get { return _PreDiagnosis; } set { _PreDiagnosis = value; } }
    public virtual string PostDiagnosis { get { return _PostDiagnosis; } set { _PostDiagnosis = value; } }
    public virtual string SurgeryID { get { return _SurgeryID; } set { _SurgeryID = value; } }
    public virtual string OperationDetail { get { return _OperationDetail; } set { _OperationDetail = value; } }
    public virtual string Implants { get { return _Implants; } set { _Implants = value; } }
    public virtual string Findings { get { return _Findings; } set { _Findings = value; } }
    public virtual string Culture { get { return _Culture; } set { _Culture = value; } }
    public virtual string EBL { get { return _EBL; } set { _EBL = value; } }
    public virtual string Drains { get { return _Drains; } set { _Drains = value; } }
    public virtual string CellSaver { get { return _CellSaver; } set { _CellSaver = value; } }
    public virtual string Transfusion { get { return _Transfusion; } set { _Transfusion = value; } }
    public virtual DateTime OperatingTime { get { return _OperatingTime; } set { _OperatingTime = value; } }
    public virtual string SpinalCordMonitoring { get { return _SpinalCordMonitoring; } set { _SpinalCordMonitoring = value; } }
    public virtual string Complication { get { return _Complication; } set { _Complication = value; } }
    public virtual string ComplicationDetail { get { return _ComplicationDetail; } set { _ComplicationDetail = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }
    public virtual int IsApproved { get { return _IsApproved; } set { _IsApproved = value; } }
    public virtual string ApprovedBy { get { return _ApprovedBy; } set { _ApprovedBy = value; } }
    public virtual DateTime SurgeryBegan { get { return _SurgeryBegan; } set { _SurgeryBegan = value; } }
    public virtual DateTime SurgeryEnd { get { return _SurgeryEnd; } set { _SurgeryEnd = value; } }
    public virtual string SDSAMS { get { return _SDSAMS; } set { _SDSAMS = value; } }
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string WoundClosures { get { return _WoundClosures; } set { _WoundClosures = value; } }
    public virtual string Anesthesia { get { return _Anesthesia; } set { _Anesthesia = value; } }
    public virtual string Pathlogy { get { return _Pathlogy; } set { _Pathlogy = value; } }
    public virtual string PathlogyIssueType { get { return _PathlogyIssueType; } set { _PathlogyIssueType = value; } }
    public virtual string OtherCulture { get { return _OtherCulture; } set { _OtherCulture = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_operation_room_record_detail_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeonID", Util.GetString(SurgeonID)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetistID", Util.GetString(AnaesthetistID)));

            cmd.Parameters.Add(new MySqlParameter("@vSecondSurgeonID", Util.GetString(SecondSurgeonID)));
            cmd.Parameters.Add(new MySqlParameter("@vSecondAnaesthesia", Util.GetString(SecondAnaesthesia)));

            cmd.Parameters.Add(new MySqlParameter("@vPreDiagnosis", Util.GetString(PreDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vPostDiagnosis", Util.GetString(PostDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryID", Util.GetString(SurgeryID)));
            cmd.Parameters.Add(new MySqlParameter("@vOperationDetail", Util.GetString(OperationDetail)));
            cmd.Parameters.Add(new MySqlParameter("@vImplants", Util.GetString(Implants)));
            cmd.Parameters.Add(new MySqlParameter("@vFindings", Util.GetString(Findings)));
            cmd.Parameters.Add(new MySqlParameter("@vCulture", Util.GetString(Culture)));
            cmd.Parameters.Add(new MySqlParameter("@vEBL", Util.GetString(EBL)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vCellSaver", Util.GetString(CellSaver)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfusion", Util.GetString(Transfusion)));
            cmd.Parameters.Add(new MySqlParameter("@vOperatingTime", Util.GetDateTime(OperatingTime).ToString("HH:mm:ss")));
            cmd.Parameters.Add(new MySqlParameter("@vSpinalCordMonitoring", Util.GetString(SpinalCordMonitoring)));
            cmd.Parameters.Add(new MySqlParameter("@vComplication", Util.GetString(Complication)));
            cmd.Parameters.Add(new MySqlParameter("@vComplicationDetail", Util.GetString(ComplicationDetail)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));
            cmd.Parameters.Add(new MySqlParameter("@vIsApproved", Util.GetInt(IsApproved)));
            cmd.Parameters.Add(new MySqlParameter("@vApprovedBy", Util.GetString(ApprovedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryBegan", Util.GetDateTime(SurgeryBegan).ToString("HH:mm:ss")));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryEnd", Util.GetDateTime(SurgeryEnd).ToString("HH:mm:ss")));
            cmd.Parameters.Add(new MySqlParameter("@vSDSAMS", Util.GetString(SDSAMS)));
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vWoundClosures", Util.GetString(WoundClosures)));
            cmd.Parameters.Add(new MySqlParameter("@vAnesthesia", Util.GetString(Anesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vPathlogy", Util.GetString(Pathlogy)));
            cmd.Parameters.Add(new MySqlParameter("@vPathlogyIssueType", Util.GetString(PathlogyIssueType)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherCulture", Util.GetString(OtherCulture)));

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