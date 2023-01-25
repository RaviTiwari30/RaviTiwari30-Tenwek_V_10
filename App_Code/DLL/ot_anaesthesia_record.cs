using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_anaesthesia_record
{
    public ot_anaesthesia_record()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_anaesthesia_record(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _AnaesthesiaRecord;
    private DateTime _AnaesthesiaDate;
    private string _Anaesthetist;
    private string _Surgeon;
    private string _AnaesthesiaTime;
    private string _Theatre;
    private string _ASA;
    private DateTime _AssessmentDate;
    private string _AssessmentPlace;
    private string _AssessmentBy;
    private string _PresentingComplaints;
    private string _Smoking;
    private string _Cigs_day;
    private string _Alcohol;
    private string _Asthma;
    private string _HighBP;
    private string _HeartDisease;
    private string _KidneyDisease;
    private string _Diabetes;
    private string _LiverDisease;
    private string _Convulsionsorfits;
    private string _Any_Other;
    private string _Allergies;
    private string _PreviousGA;
    private string _Drugs;
    private string _Cardiovascular;
    private string _Respiratory;
    private string _Nervous;
    private string _Wt;
    private string _Ht;
    private string _Hr;
    private string _Temp;
    private string _BP;
    private string _Pluse;
    private string _Spo2;
    private string _Npo_Status;
    private string _Intubation;
    private string _Teeth;
    private string _IntubationComments;
    private string _Premedication;
    private string _Plan_Consent;
    private string _EntryBy;
    private string _UpdateBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string AnaesthesiaRecord { get { return _AnaesthesiaRecord; } set { _AnaesthesiaRecord = value; } }
    public virtual DateTime AnaesthesiaDate { get { return _AnaesthesiaDate; } set { _AnaesthesiaDate = value; } }
    public virtual string Anaesthetist { get { return _Anaesthetist; } set { _Anaesthetist = value; } }
    public virtual string Surgeon { get { return _Surgeon; } set { _Surgeon = value; } }
    public virtual string AnaesthesiaTime { get { return _AnaesthesiaTime; } set { _AnaesthesiaTime = value; } }
    public virtual string Theatre { get { return _Theatre; } set { _Theatre = value; } }
    public virtual string ASA { get { return _ASA; } set { _ASA = value; } }
    public virtual DateTime AssessmentDate { get { return _AssessmentDate; } set { _AssessmentDate = value; } }
    public virtual string AssessmentPlace { get { return _AssessmentPlace; } set { _AssessmentPlace = value; } }
    public virtual string AssessmentBy { get { return _AssessmentBy; } set { _AssessmentBy = value; } }
    public virtual string PresentingComplaints { get { return _PresentingComplaints; } set { _PresentingComplaints = value; } }
    public virtual string Smoking { get { return _Smoking; } set { _Smoking = value; } }
    public virtual string Cigs_day { get { return _Cigs_day; } set { _Cigs_day = value; } }
    public virtual string Alcohol { get { return _Alcohol; } set { _Alcohol = value; } }
    public virtual string Asthma { get { return _Asthma; } set { _Asthma = value; } }
    public virtual string HighBP { get { return _HighBP; } set { _HighBP = value; } }
    public virtual string HeartDisease { get { return _HeartDisease; } set { _HeartDisease = value; } }
    public virtual string KidneyDisease { get { return _KidneyDisease; } set { _KidneyDisease = value; } }
    public virtual string Diabetes { get { return _Diabetes; } set { _Diabetes = value; } }
    public virtual string LiverDisease { get { return _LiverDisease; } set { _LiverDisease = value; } }
    public virtual string Convulsionsorfits { get { return _Convulsionsorfits; } set { _Convulsionsorfits = value; } }
    public virtual string Any_Other { get { return _Any_Other; } set { _Any_Other = value; } }
    public virtual string Allergies { get { return _Allergies; } set { _Allergies = value; } }
    public virtual string PreviousGA { get { return _PreviousGA; } set { _PreviousGA = value; } }
    public virtual string Drugs { get { return _Drugs; } set { _Drugs = value; } }
    public virtual string Cardiovascular { get { return _Cardiovascular; } set { _Cardiovascular = value; } }
    public virtual string Respiratory { get { return _Respiratory; } set { _Respiratory = value; } }
    public virtual string Nervous { get { return _Nervous; } set { _Nervous = value; } }
    public virtual string Wt { get { return _Wt; } set { _Wt = value; } }
    public virtual string Ht { get { return _Ht; } set { _Ht = value; } }
    public virtual string Hr { get { return _Hr; } set { _Hr = value; } }
    public virtual string Temp { get { return _Temp; } set { _Temp = value; } }
    public virtual string BP { get { return _BP; } set { _BP = value; } }
    public virtual string Pluse { get { return _Pluse; } set { _Pluse = value; } }
    public virtual string Spo2 { get { return _Spo2; } set { _Spo2 = value; } }
    public virtual string Npo_Status { get { return _Npo_Status; } set { _Npo_Status = value; } }
    public virtual string Intubation { get { return _Intubation; } set { _Intubation = value; } }
    public virtual string Teeth { get { return _Teeth; } set { _Teeth = value; } }
    public virtual string IntubationComments { get { return _IntubationComments; } set { _IntubationComments = value; } }
    public virtual string Premedication { get { return _Premedication; } set { _Premedication = value; } }
    public virtual string Plan_Consent { get { return _Plan_Consent; } set { _Plan_Consent = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_anaesthesia_record_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaRecord", Util.GetString(AnaesthesiaRecord)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaDate", Util.GetDateTime(AnaesthesiaDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetist", Util.GetString(Anaesthetist)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeon", Util.GetString(Surgeon)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaTime", Util.GetString(AnaesthesiaTime)));
            cmd.Parameters.Add(new MySqlParameter("@vTheatre", Util.GetString(Theatre)));
            cmd.Parameters.Add(new MySqlParameter("@vASA", Util.GetString(ASA)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessmentDate", Util.GetDateTime(AssessmentDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessmentPlace", Util.GetString(AssessmentPlace)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessmentBy", Util.GetString(AssessmentBy)));
            cmd.Parameters.Add(new MySqlParameter("@vPresentingComplaints", Util.GetString(PresentingComplaints)));
            cmd.Parameters.Add(new MySqlParameter("@vSmoking", Util.GetString(Smoking)));
            cmd.Parameters.Add(new MySqlParameter("@vCigs_day", Util.GetString(Cigs_day)));
            cmd.Parameters.Add(new MySqlParameter("@vAlcohol", Util.GetString(Alcohol)));
            cmd.Parameters.Add(new MySqlParameter("@vAsthma", Util.GetString(Asthma)));
            cmd.Parameters.Add(new MySqlParameter("@vHighBP", Util.GetString(HighBP)));
            cmd.Parameters.Add(new MySqlParameter("@vHeartDisease", Util.GetString(HeartDisease)));
            cmd.Parameters.Add(new MySqlParameter("@vKidneyDisease", Util.GetString(KidneyDisease)));
            cmd.Parameters.Add(new MySqlParameter("@vDiabetes", Util.GetString(Diabetes)));
            cmd.Parameters.Add(new MySqlParameter("@vLiverDisease", Util.GetString(LiverDisease)));
            cmd.Parameters.Add(new MySqlParameter("@vConvulsionsorfits", Util.GetString(Convulsionsorfits)));
            cmd.Parameters.Add(new MySqlParameter("@vAny_Other", Util.GetString(Any_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vAllergies", Util.GetString(Allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vPreviousGA", Util.GetString(PreviousGA)));
            cmd.Parameters.Add(new MySqlParameter("@vDrugs", Util.GetString(Drugs)));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascular", Util.GetString(Cardiovascular)));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratory", Util.GetString(Respiratory)));
            cmd.Parameters.Add(new MySqlParameter("@vNervous", Util.GetString(Nervous)));
            cmd.Parameters.Add(new MySqlParameter("@vWt", Util.GetString(Wt)));
            cmd.Parameters.Add(new MySqlParameter("@vHt", Util.GetString(Ht)));
            cmd.Parameters.Add(new MySqlParameter("@vHr", Util.GetString(Hr)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp", Util.GetString(Temp)));
            cmd.Parameters.Add(new MySqlParameter("@vBP", Util.GetString(BP)));
            cmd.Parameters.Add(new MySqlParameter("@vPluse", Util.GetString(Pluse)));
            cmd.Parameters.Add(new MySqlParameter("@vSpo2", Util.GetString(Spo2)));
            cmd.Parameters.Add(new MySqlParameter("@vNpo_Status", Util.GetString(Npo_Status)));
            cmd.Parameters.Add(new MySqlParameter("@vIntubation", Util.GetString(Intubation)));
            cmd.Parameters.Add(new MySqlParameter("@vTeeth", Util.GetString(Teeth)));
            cmd.Parameters.Add(new MySqlParameter("@vIntubationComments", Util.GetString(IntubationComments)));
            cmd.Parameters.Add(new MySqlParameter("@vPremedication", Util.GetString(Premedication)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan_Consent", Util.GetString(Plan_Consent)));
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

            objSQL.Append("ot_anaesthesia_record_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaRecord", Util.GetString(AnaesthesiaRecord)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaDate", Util.GetDateTime(AnaesthesiaDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetist", Util.GetString(Anaesthetist)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeon", Util.GetString(Surgeon)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaTime", Util.GetString(AnaesthesiaTime)));
            cmd.Parameters.Add(new MySqlParameter("@vTheatre", Util.GetString(Theatre)));
            cmd.Parameters.Add(new MySqlParameter("@vASA", Util.GetString(ASA)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessmentDate", Util.GetDateTime(AssessmentDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessmentPlace", Util.GetString(AssessmentPlace)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessmentBy", Util.GetString(AssessmentBy)));
            cmd.Parameters.Add(new MySqlParameter("@vPresentingComplaints", Util.GetString(PresentingComplaints)));
            cmd.Parameters.Add(new MySqlParameter("@vSmoking", Util.GetString(Smoking)));
            cmd.Parameters.Add(new MySqlParameter("@vCigs_day", Util.GetString(Cigs_day)));
            cmd.Parameters.Add(new MySqlParameter("@vAlcohol", Util.GetString(Alcohol)));
            cmd.Parameters.Add(new MySqlParameter("@vAsthma", Util.GetString(Asthma)));
            cmd.Parameters.Add(new MySqlParameter("@vHighBP", Util.GetString(HighBP)));
            cmd.Parameters.Add(new MySqlParameter("@vHeartDisease", Util.GetString(HeartDisease)));
            cmd.Parameters.Add(new MySqlParameter("@vKidneyDisease", Util.GetString(KidneyDisease)));
            cmd.Parameters.Add(new MySqlParameter("@vDiabetes", Util.GetString(Diabetes)));
            cmd.Parameters.Add(new MySqlParameter("@vLiverDisease", Util.GetString(LiverDisease)));
            cmd.Parameters.Add(new MySqlParameter("@vConvulsionsorfits", Util.GetString(Convulsionsorfits)));
            cmd.Parameters.Add(new MySqlParameter("@vAny_Other", Util.GetString(Any_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vAllergies", Util.GetString(Allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vPreviousGA", Util.GetString(PreviousGA)));
            cmd.Parameters.Add(new MySqlParameter("@vDrugs", Util.GetString(Drugs)));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascular", Util.GetString(Cardiovascular)));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratory", Util.GetString(Respiratory)));
            cmd.Parameters.Add(new MySqlParameter("@vNervous", Util.GetString(Nervous)));
            cmd.Parameters.Add(new MySqlParameter("@vWt", Util.GetString(Wt)));
            cmd.Parameters.Add(new MySqlParameter("@vHt", Util.GetString(Ht)));
            cmd.Parameters.Add(new MySqlParameter("@vHr", Util.GetString(Hr)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp", Util.GetString(Temp)));
            cmd.Parameters.Add(new MySqlParameter("@vBP", Util.GetString(BP)));
            cmd.Parameters.Add(new MySqlParameter("@vPluse", Util.GetString(Pluse)));
            cmd.Parameters.Add(new MySqlParameter("@vSpo2", Util.GetString(Spo2)));
            cmd.Parameters.Add(new MySqlParameter("@vNpo_Status", Util.GetString(Npo_Status)));
            cmd.Parameters.Add(new MySqlParameter("@vIntubation", Util.GetString(Intubation)));
            cmd.Parameters.Add(new MySqlParameter("@vTeeth", Util.GetString(Teeth)));
            cmd.Parameters.Add(new MySqlParameter("@vIntubationComments", Util.GetString(IntubationComments)));
            cmd.Parameters.Add(new MySqlParameter("@vPremedication", Util.GetString(Premedication)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan_Consent", Util.GetString(Plan_Consent)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));

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