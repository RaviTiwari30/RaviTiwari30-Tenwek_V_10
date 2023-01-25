using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_operationrecord
{
    public ot_operationrecord()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_operationrecord(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _surgery_schedule_ID;
    private string _TransactionID;
    private string _PatientID;
    private string _LedgerTransactionNo;
    private string _DoctorID;
    private string _DoctorID2;
    private string _OT;
    private DateTime _Start_DateTime;
    private DateTime _End_Datetime;
    private string _Surgery_ID;
    private string _OtherSurgery;
    private string _Ass_Doc1;
    private string _Ass_Doc2;
    private string _Ass_Doc3;
    private string _Anaesthetist1;
    private string _Anaesthetist2;
    private string _CoAnaesthesia;
    private string _technician;
    private string _ScNurse;
    private string _Nurse1;
    private string _Nurse2;
    private string _FloorSuprevisior;
    private string _CirculatingNurse;
    private string _PadiatriciansRecort;
    private string _ApgarScore;

    private string _UserID;
    private string _pre_diagnosis;
    private string _post_diagnosis;
    private string _TimeEnterOR;
    private string _TimeExitRR;
    private string _OperationSlated;
    private string _OperationPerformed;
    private string _Position;
    private string _PositionAID;
    private string _AnaesthesiaStart;
    private string _AnesthesiaStop;
    private string _SurgicalPrep;
    private string _BairHugger;
    private string _Specimens;
    private string _Cautery_ESU;
    private string _Catheter_Size;
    private string _Implants;
    private string _Sponges;
    private string _Sharps;
    private string _Instruments;
    private string _Time_On1;
    private string _Time_off1;
    private string _Pressure_Set1;
    private string _Time_On2;
    private string _Time_Off2;
    private string _Pressure_Set2;
    private string _Time_On3;
    private string _Time_Off3;
    private string _Pressure_Set3;
    private string _Nursing_Notes;
    private string _Patient_trasfered;
    private string _Report_Given;

    //Devendra Singh 2016.03.03

    private string _Technician1;
    private string _IvSolution;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int surgery_schedule_ID { get { return _surgery_schedule_ID; } set { _surgery_schedule_ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string DoctorID2 { get { return _DoctorID2; } set { _DoctorID2 = value; } }
    public virtual string OT { get { return _OT; } set { _OT = value; } }
    public virtual DateTime Start_DateTime { get { return _Start_DateTime; } set { _Start_DateTime = value; } }
    public virtual DateTime End_Datetime { get { return _End_Datetime; } set { _End_Datetime = value; } }
    public virtual string Surgery_ID { get { return _Surgery_ID; } set { _Surgery_ID = value; } }
    public virtual string OtherSurgery { get { return _OtherSurgery; } set { _OtherSurgery = value; } }
    public virtual string Ass_Doc1 { get { return _Ass_Doc1; } set { _Ass_Doc1 = value; } }
    public virtual string Ass_Doc2 { get { return _Ass_Doc2; } set { _Ass_Doc2 = value; } }
    public virtual string Ass_Doc3 { get { return _Ass_Doc3; } set { _Ass_Doc3 = value; } }
    public virtual string Anaesthetist1 { get { return _Anaesthetist1; } set { _Anaesthetist1 = value; } }
    public virtual string Anaesthetist2 { get { return _Anaesthetist2; } set { _Anaesthetist2 = value; } }
    public virtual string CoAnaesthesia { get { return _CoAnaesthesia; } set { _CoAnaesthesia = value; } }
    public virtual string technician { get { return _technician; } set { _technician = value; } }
    public virtual string ScNurse { get { return _ScNurse; } set { _ScNurse = value; } }
    public virtual string Nurse1 { get { return _Nurse1; } set { _Nurse1 = value; } }
    public virtual string Nurse2 { get { return _Nurse2; } set { _Nurse2 = value; } }
    public virtual string FloorSuprevisior { get { return _FloorSuprevisior; } set { _FloorSuprevisior = value; } }
    public virtual string CirculatingNurse { get { return _CirculatingNurse; } set { _CirculatingNurse = value; } }
    public virtual string PadiatriciansRecort { get { return _PadiatriciansRecort; } set { _PadiatriciansRecort = value; } }
    public virtual string ApgarScore { get { return _ApgarScore; } set { _ApgarScore = value; } }

    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual string pre_diagnosis { get { return _pre_diagnosis; } set { _pre_diagnosis = value; } }
    public virtual string post_diagnosis { get { return _post_diagnosis; } set { _post_diagnosis = value; } }
    public virtual string TimeEnterOR { get { return _TimeEnterOR; } set { _TimeEnterOR = value; } }
    public virtual string TimeExitRR { get { return _TimeExitRR; } set { _TimeExitRR = value; } }
    public virtual string OperationSlated { get { return _OperationSlated; } set { _OperationSlated = value; } }
    public virtual string OperationPerformed { get { return _OperationPerformed; } set { _OperationPerformed = value; } }
    public virtual string Position { get { return _Position; } set { _Position = value; } }
    public virtual string PositionAID { get { return _PositionAID; } set { _PositionAID = value; } }
    public virtual string AnaesthesiaStart { get { return _AnaesthesiaStart; } set { _AnaesthesiaStart = value; } }
    public virtual string AnesthesiaStop { get { return _AnesthesiaStop; } set { _AnesthesiaStop = value; } }
    public virtual string SurgicalPrep { get { return _SurgicalPrep; } set { _SurgicalPrep = value; } }
    public virtual string BairHugger { get { return _BairHugger; } set { _BairHugger = value; } }
    public virtual string Specimens { get { return _Specimens; } set { _Specimens = value; } }
    public virtual string Cautery_ESU { get { return _Cautery_ESU; } set { _Cautery_ESU = value; } }
    public virtual string Catheter_Size { get { return _Catheter_Size; } set { _Catheter_Size = value; } }
    public virtual string Implants { get { return _Implants; } set { _Implants = value; } }
    public virtual string Sponges { get { return _Sponges; } set { _Sponges = value; } }
    public virtual string Sharps { get { return _Sharps; } set { _Sharps = value; } }
    public virtual string Instruments { get { return _Instruments; } set { _Instruments = value; } }
    public virtual string Time_On1 { get { return _Time_On1; } set { _Time_On1 = value; } }
    public virtual string Time_off1 { get { return _Time_off1; } set { _Time_off1 = value; } }
    public virtual string Pressure_Set1 { get { return _Pressure_Set1; } set { _Pressure_Set1 = value; } }
    public virtual string Time_On2 { get { return _Time_On2; } set { _Time_On2 = value; } }
    public virtual string Time_Off2 { get { return _Time_Off2; } set { _Time_Off2 = value; } }
    public virtual string Pressure_Set2 { get { return _Pressure_Set2; } set { _Pressure_Set2 = value; } }
    public virtual string Time_On3 { get { return _Time_On3; } set { _Time_On3 = value; } }
    public virtual string Time_Off3 { get { return _Time_Off3; } set { _Time_Off3 = value; } }
    public virtual string Pressure_Set3 { get { return _Pressure_Set3; } set { _Pressure_Set3 = value; } }
    public virtual string Nursing_Notes { get { return _Nursing_Notes; } set { _Nursing_Notes = value; } }
    public virtual string Patient_trasfered { get { return _Patient_trasfered; } set { _Patient_trasfered = value; } }
    public virtual string Report_Given { get { return _Report_Given; } set { _Report_Given = value; } }

    //Devendra Singh 2016.03.03

    public virtual string IvSolution { get { return _IvSolution; } set { _IvSolution = value; } }
    public virtual string Technician1 { get { return _Technician1; } set { _Technician1 = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_operationrecord");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID2", Util.GetString(DoctorID2)));
            cmd.Parameters.Add(new MySqlParameter("@vOT", Util.GetString(OT)));
            cmd.Parameters.Add(new MySqlParameter("@vStart_DateTime", Util.GetDateTime(Start_DateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vEnd_Datetime", Util.GetDateTime(End_Datetime)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery_ID", Util.GetString(Surgery_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherSurgery", Util.GetString(OtherSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vAss_Doc1", Util.GetString(Ass_Doc1)));
            cmd.Parameters.Add(new MySqlParameter("@vAss_Doc2", Util.GetString(Ass_Doc2)));
            cmd.Parameters.Add(new MySqlParameter("@vAss_Doc3", Util.GetString(Ass_Doc3)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetist1", Util.GetString(Anaesthetist1)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetist2", Util.GetString(Anaesthetist2)));
            cmd.Parameters.Add(new MySqlParameter("@vCoAnaesthesia", Util.GetString(CoAnaesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vtechnician", Util.GetString(technician)));
            cmd.Parameters.Add(new MySqlParameter("@vScNurse", Util.GetString(ScNurse)));
            cmd.Parameters.Add(new MySqlParameter("@vNurse1", Util.GetString(Nurse1)));
            cmd.Parameters.Add(new MySqlParameter("@vNurse2", Util.GetString(Nurse2)));
            cmd.Parameters.Add(new MySqlParameter("@vFloorSuprevisior", Util.GetString(FloorSuprevisior)));
            cmd.Parameters.Add(new MySqlParameter("@vCirculatingNurse", Util.GetString(CirculatingNurse)));
            cmd.Parameters.Add(new MySqlParameter("@vPadiatriciansRecort", Util.GetString(PadiatriciansRecort)));
            cmd.Parameters.Add(new MySqlParameter("@vApgarScore", Util.GetString(ApgarScore)));

            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vpre_diagnosis", Util.GetString(pre_diagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vpost_diagnosis", Util.GetString(post_diagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vTimeEnterOR", Util.GetString(TimeEnterOR)));
            cmd.Parameters.Add(new MySqlParameter("@vTimeExitRR", Util.GetString(TimeExitRR)));
            cmd.Parameters.Add(new MySqlParameter("@vOperationSlated", Util.GetString(OperationSlated)));
            cmd.Parameters.Add(new MySqlParameter("@vOperationPerformed", Util.GetString(OperationPerformed)));
            cmd.Parameters.Add(new MySqlParameter("@vPosition", Util.GetString(Position)));
            cmd.Parameters.Add(new MySqlParameter("@vPositionAID", Util.GetString(PositionAID)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthesiaStart", Util.GetString(AnaesthesiaStart)));
            cmd.Parameters.Add(new MySqlParameter("@vAnesthesiaStop", Util.GetString(AnesthesiaStop)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgicalPrep", Util.GetString(SurgicalPrep)));
            cmd.Parameters.Add(new MySqlParameter("@vBairHugger", Util.GetString(BairHugger)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecimens", Util.GetString(Specimens)));
            cmd.Parameters.Add(new MySqlParameter("@vCautery_ESU", Util.GetString(Cautery_ESU)));
            cmd.Parameters.Add(new MySqlParameter("@vCatheter_Size", Util.GetString(Catheter_Size)));
            cmd.Parameters.Add(new MySqlParameter("@vImplants", Util.GetString(Implants)));
            cmd.Parameters.Add(new MySqlParameter("@vSponges", Util.GetString(Sponges)));
            cmd.Parameters.Add(new MySqlParameter("@vSharps", Util.GetString(Sharps)));
            cmd.Parameters.Add(new MySqlParameter("@vInstruments", Util.GetString(Instruments)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_On1", Util.GetString(Time_On1)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_off1", Util.GetString(Time_off1)));
            cmd.Parameters.Add(new MySqlParameter("@vPressure_Set1", Util.GetString(Pressure_Set1)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_On2", Util.GetString(Time_On2)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_Off2", Util.GetString(Time_Off2)));
            cmd.Parameters.Add(new MySqlParameter("@vPressure_Set2", Util.GetString(Pressure_Set2)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_On3", Util.GetString(Time_On3)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_Off3", Util.GetString(Time_Off3)));
            cmd.Parameters.Add(new MySqlParameter("@vPressure_Set3", Util.GetString(Pressure_Set3)));
            cmd.Parameters.Add(new MySqlParameter("@vNursing_Notes", Util.GetString(Nursing_Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vPatient_trasfered", Util.GetString(Patient_trasfered)));
            cmd.Parameters.Add(new MySqlParameter("@vReport_Given", Util.GetString(Report_Given)));
            cmd.Parameters.Add(new MySqlParameter("@vIvSolution", Util.GetString(IvSolution)));
            cmd.Parameters.Add(new MySqlParameter("@vTechnician1", Util.GetString(Technician1)));
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