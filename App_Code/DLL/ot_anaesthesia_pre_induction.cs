using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_anaesthesia_pre_induction
{
    public ot_anaesthesia_pre_induction()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_anaesthesia_pre_induction(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _ClinicalStatus;
    private string _Wnl;
    private string _WnlNo;
    private string _Induction_Time;
    private string _StartSurgery;
    private string _FinishSurgery;
    private string _Anaesthetic_Machine;
    private string _line1;
    private string _line2;
    private string _Arterial;
    private string _Cvp;
    private string _GaugeOther;
    private string _IV;
    private string _Rsi;
    private string _Inhalation;
    private string _Air;
    private string _Agent;
    private string _Ett;
    private string _Lma;
    private string _Laryngoscopy;
    private string _Aids;
    private string _AirwayComments;
    private string _ThroatPack;
    private string _Circuit;
    private string _Respiration;
    private string _Mode;
    private string _Vt;
    private string _Vm;
    private string _Pmax;
    private string _F;
    private string _Position;
    private string _EyesProtected;
    private string _IVWarmer;
    private string _Pressure;
    private string _Hme;
    private string _Convecting;
    private string _Tourniquet_TimeOn;
    private string _Tourniquet_TimeOff;
    private string _Spinal;
    private string _Epidural;
    private string _Caudal;
    private string _Plexus;
    private string _RegionalOther;
    private string _RegionalAgent;
    private string _Concentration;
    private string _Apiates;
    private string _Adrenaline;
    private string _Nerve_Stimulator;
    private string _Crystalloid;
    private string _Colloid;
    private string _BloodIn;
    private string _FFp;
    private string _Plats;
    private string _In_Other;
    private string _Blood_Loss;
    private string _Urine_Output;
    private string _Out_Other_Losses;
    private string _Total_In;
    private string _Total_Out;
    private string _Balance;
    private string _Post_Operative_Instructions;
    private string _Critical_Incident;
    private string _EntryBy;
    private string _UpdateBy;
    private DateTime _UpdatedDate;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string ClinicalStatus { get { return _ClinicalStatus; } set { _ClinicalStatus = value; } }
    public virtual string Wnl { get { return _Wnl; } set { _Wnl = value; } }
    public virtual string WnlNo { get { return _WnlNo; } set { _WnlNo = value; } }
    public virtual string Induction_Time { get { return _Induction_Time; } set { _Induction_Time = value; } }
    public virtual string StartSurgery { get { return _StartSurgery; } set { _StartSurgery = value; } }
    public virtual string FinishSurgery { get { return _FinishSurgery; } set { _FinishSurgery = value; } }
    public virtual string Anaesthetic_Machine { get { return _Anaesthetic_Machine; } set { _Anaesthetic_Machine = value; } }
    public virtual string line1 { get { return _line1; } set { _line1 = value; } }
    public virtual string line2 { get { return _line2; } set { _line2 = value; } }
    public virtual string Arterial { get { return _Arterial; } set { _Arterial = value; } }
    public virtual string Cvp { get { return _Cvp; } set { _Cvp = value; } }
    public virtual string GaugeOther { get { return _GaugeOther; } set { _GaugeOther = value; } }
    public virtual string IV { get { return _IV; } set { _IV = value; } }
    public virtual string Rsi { get { return _Rsi; } set { _Rsi = value; } }
    public virtual string Inhalation { get { return _Inhalation; } set { _Inhalation = value; } }
    public virtual string Air { get { return _Air; } set { _Air = value; } }
    public virtual string Agent { get { return _Agent; } set { _Agent = value; } }
    public virtual string Ett { get { return _Ett; } set { _Ett = value; } }
    public virtual string Lma { get { return _Lma; } set { _Lma = value; } }
    public virtual string Laryngoscopy { get { return _Laryngoscopy; } set { _Laryngoscopy = value; } }
    public virtual string Aids { get { return _Aids; } set { _Aids = value; } }
    public virtual string AirwayComments { get { return _AirwayComments; } set { _AirwayComments = value; } }
    public virtual string ThroatPack { get { return _ThroatPack; } set { _ThroatPack = value; } }
    public virtual string Circuit { get { return _Circuit; } set { _Circuit = value; } }
    public virtual string Respiration { get { return _Respiration; } set { _Respiration = value; } }
    public virtual string Mode { get { return _Mode; } set { _Mode = value; } }
    public virtual string Vt { get { return _Vt; } set { _Vt = value; } }
    public virtual string Vm { get { return _Vm; } set { _Vm = value; } }
    public virtual string Pmax { get { return _Pmax; } set { _Pmax = value; } }
    public virtual string F { get { return _F; } set { _F = value; } }
    public virtual string Position { get { return _Position; } set { _Position = value; } }
    public virtual string EyesProtected { get { return _EyesProtected; } set { _EyesProtected = value; } }
    public virtual string IVWarmer { get { return _IVWarmer; } set { _IVWarmer = value; } }
    public virtual string Pressure { get { return _Pressure; } set { _Pressure = value; } }
    public virtual string Hme { get { return _Hme; } set { _Hme = value; } }
    public virtual string Convecting { get { return _Convecting; } set { _Convecting = value; } }
    public virtual string Tourniquet_TimeOn { get { return _Tourniquet_TimeOn; } set { _Tourniquet_TimeOn = value; } }
    public virtual string Tourniquet_TimeOff { get { return _Tourniquet_TimeOff; } set { _Tourniquet_TimeOff = value; } }
    public virtual string Spinal { get { return _Spinal; } set { _Spinal = value; } }
    public virtual string Epidural { get { return _Epidural; } set { _Epidural = value; } }
    public virtual string Caudal { get { return _Caudal; } set { _Caudal = value; } }
    public virtual string Plexus { get { return _Plexus; } set { _Plexus = value; } }
    public virtual string RegionalOther { get { return _RegionalOther; } set { _RegionalOther = value; } }
    public virtual string RegionalAgent { get { return _RegionalAgent; } set { _RegionalAgent = value; } }
    public virtual string Concentration { get { return _Concentration; } set { _Concentration = value; } }
    public virtual string Apiates { get { return _Apiates; } set { _Apiates = value; } }
    public virtual string Adrenaline { get { return _Adrenaline; } set { _Adrenaline = value; } }
    public virtual string Nerve_Stimulator { get { return _Nerve_Stimulator; } set { _Nerve_Stimulator = value; } }
    public virtual string Crystalloid { get { return _Crystalloid; } set { _Crystalloid = value; } }
    public virtual string Colloid { get { return _Colloid; } set { _Colloid = value; } }
    public virtual string BloodIn { get { return _BloodIn; } set { _BloodIn = value; } }
    public virtual string FFp { get { return _FFp; } set { _FFp = value; } }
    public virtual string Plats { get { return _Plats; } set { _Plats = value; } }
    public virtual string In_Other { get { return _In_Other; } set { _In_Other = value; } }
    public virtual string Blood_Loss { get { return _Blood_Loss; } set { _Blood_Loss = value; } }
    public virtual string Urine_Output { get { return _Urine_Output; } set { _Urine_Output = value; } }
    public virtual string Out_Other_Losses { get { return _Out_Other_Losses; } set { _Out_Other_Losses = value; } }
    public virtual string Total_In { get { return _Total_In; } set { _Total_In = value; } }
    public virtual string Total_Out { get { return _Total_Out; } set { _Total_Out = value; } }
    public virtual string Balance { get { return _Balance; } set { _Balance = value; } }
    public virtual string Post_Operative_Instructions { get { return _Post_Operative_Instructions; } set { _Post_Operative_Instructions = value; } }
    public virtual string Critical_Incident { get { return _Critical_Incident; } set { _Critical_Incident = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_anaesthesia_pre_induction_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vClinicalStatus", Util.GetString(ClinicalStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vWnl", Util.GetString(Wnl)));
            cmd.Parameters.Add(new MySqlParameter("@vWnlNo", Util.GetString(WnlNo)));
            cmd.Parameters.Add(new MySqlParameter("@vInduction_Time", Util.GetString(Induction_Time)));
            cmd.Parameters.Add(new MySqlParameter("@vStartSurgery", Util.GetString(StartSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vFinishSurgery", Util.GetString(FinishSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetic_Machine", Util.GetString(Anaesthetic_Machine)));
            cmd.Parameters.Add(new MySqlParameter("@vline1", Util.GetString(line1)));
            cmd.Parameters.Add(new MySqlParameter("@vline2", Util.GetString(line2)));
            cmd.Parameters.Add(new MySqlParameter("@vArterial", Util.GetString(Arterial)));
            cmd.Parameters.Add(new MySqlParameter("@vCvp", Util.GetString(Cvp)));
            cmd.Parameters.Add(new MySqlParameter("@vGaugeOther", Util.GetString(GaugeOther)));
            cmd.Parameters.Add(new MySqlParameter("@vIV", Util.GetString(IV)));
            cmd.Parameters.Add(new MySqlParameter("@vRsi", Util.GetString(Rsi)));
            cmd.Parameters.Add(new MySqlParameter("@vInhalation", Util.GetString(Inhalation)));
            cmd.Parameters.Add(new MySqlParameter("@vAir", Util.GetString(Air)));
            cmd.Parameters.Add(new MySqlParameter("@vAgent", Util.GetString(Agent)));
            cmd.Parameters.Add(new MySqlParameter("@vEtt", Util.GetString(Ett)));
            cmd.Parameters.Add(new MySqlParameter("@vLma", Util.GetString(Lma)));
            cmd.Parameters.Add(new MySqlParameter("@vLaryngoscopy", Util.GetString(Laryngoscopy)));
            cmd.Parameters.Add(new MySqlParameter("@vAids", Util.GetString(Aids)));
            cmd.Parameters.Add(new MySqlParameter("@vAirwayComments", Util.GetString(AirwayComments)));
            cmd.Parameters.Add(new MySqlParameter("@vThroatPack", Util.GetString(ThroatPack)));
            cmd.Parameters.Add(new MySqlParameter("@vCircuit", Util.GetString(Circuit)));
            cmd.Parameters.Add(new MySqlParameter("@vRespiration", Util.GetString(Respiration)));
            cmd.Parameters.Add(new MySqlParameter("@vMode", Util.GetString(Mode)));
            cmd.Parameters.Add(new MySqlParameter("@vVt", Util.GetString(Vt)));
            cmd.Parameters.Add(new MySqlParameter("@vVm", Util.GetString(Vm)));
            cmd.Parameters.Add(new MySqlParameter("@vPmax", Util.GetString(Pmax)));
            cmd.Parameters.Add(new MySqlParameter("@vF", Util.GetString(F)));
            cmd.Parameters.Add(new MySqlParameter("@vPosition", Util.GetString(Position)));
            cmd.Parameters.Add(new MySqlParameter("@vEyesProtected", Util.GetString(EyesProtected)));
            cmd.Parameters.Add(new MySqlParameter("@vIVWarmer", Util.GetString(IVWarmer)));
            cmd.Parameters.Add(new MySqlParameter("@vPressure", Util.GetString(Pressure)));
            cmd.Parameters.Add(new MySqlParameter("@vHme", Util.GetString(Hme)));
            cmd.Parameters.Add(new MySqlParameter("@vConvecting", Util.GetString(Convecting)));
            cmd.Parameters.Add(new MySqlParameter("@vTourniquet_TimeOn", Util.GetString(Tourniquet_TimeOn)));
            cmd.Parameters.Add(new MySqlParameter("@vTourniquet_TimeOff", Util.GetString(Tourniquet_TimeOff)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinal", Util.GetString(Spinal)));
            cmd.Parameters.Add(new MySqlParameter("@vEpidural", Util.GetString(Epidural)));
            cmd.Parameters.Add(new MySqlParameter("@vCaudal", Util.GetString(Caudal)));
            cmd.Parameters.Add(new MySqlParameter("@vPlexus", Util.GetString(Plexus)));
            cmd.Parameters.Add(new MySqlParameter("@vRegionalOther", Util.GetString(RegionalOther)));
            cmd.Parameters.Add(new MySqlParameter("@vRegionalAgent", Util.GetString(RegionalAgent)));
            cmd.Parameters.Add(new MySqlParameter("@vConcentration", Util.GetString(Concentration)));
            cmd.Parameters.Add(new MySqlParameter("@vApiates", Util.GetString(Apiates)));
            cmd.Parameters.Add(new MySqlParameter("@vAdrenaline", Util.GetString(Adrenaline)));
            cmd.Parameters.Add(new MySqlParameter("@vNerve_Stimulator", Util.GetString(Nerve_Stimulator)));
            cmd.Parameters.Add(new MySqlParameter("@vCrystalloid", Util.GetString(Crystalloid)));
            cmd.Parameters.Add(new MySqlParameter("@vColloid", Util.GetString(Colloid)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodIn", Util.GetString(BloodIn)));
            cmd.Parameters.Add(new MySqlParameter("@vFFp", Util.GetString(FFp)));
            cmd.Parameters.Add(new MySqlParameter("@vPlats", Util.GetString(Plats)));
            cmd.Parameters.Add(new MySqlParameter("@vIn_Other", Util.GetString(In_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vBlood_Loss", Util.GetString(Blood_Loss)));
            cmd.Parameters.Add(new MySqlParameter("@vUrine_Output", Util.GetString(Urine_Output)));
            cmd.Parameters.Add(new MySqlParameter("@vOut_Other_Losses", Util.GetString(Out_Other_Losses)));
            cmd.Parameters.Add(new MySqlParameter("@vTotal_In", Util.GetString(Total_In)));
            cmd.Parameters.Add(new MySqlParameter("@vTotal_Out", Util.GetString(Total_Out)));
            cmd.Parameters.Add(new MySqlParameter("@vBalance", Util.GetString(Balance)));
            cmd.Parameters.Add(new MySqlParameter("@vPost_Operative_Instructions", Util.GetString(Post_Operative_Instructions)));
            cmd.Parameters.Add(new MySqlParameter("@vCritical_Incident", Util.GetString(Critical_Incident)));
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

            objSQL.Append("ot_anaesthesia_pre_induction_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vClinicalStatus", Util.GetString(ClinicalStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vWnl", Util.GetString(Wnl)));
            cmd.Parameters.Add(new MySqlParameter("@vWnlNo", Util.GetString(WnlNo)));
            cmd.Parameters.Add(new MySqlParameter("@vInduction_Time", Util.GetString(Induction_Time)));
            cmd.Parameters.Add(new MySqlParameter("@vStartSurgery", Util.GetString(StartSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vFinishSurgery", Util.GetString(FinishSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vAnaesthetic_Machine", Util.GetString(Anaesthetic_Machine)));
            cmd.Parameters.Add(new MySqlParameter("@vline1", Util.GetString(line1)));
            cmd.Parameters.Add(new MySqlParameter("@vline2", Util.GetString(line2)));
            cmd.Parameters.Add(new MySqlParameter("@vArterial", Util.GetString(Arterial)));
            cmd.Parameters.Add(new MySqlParameter("@vCvp", Util.GetString(Cvp)));
            cmd.Parameters.Add(new MySqlParameter("@vGaugeOther", Util.GetString(GaugeOther)));
            cmd.Parameters.Add(new MySqlParameter("@vIV", Util.GetString(IV)));
            cmd.Parameters.Add(new MySqlParameter("@vRsi", Util.GetString(Rsi)));
            cmd.Parameters.Add(new MySqlParameter("@vInhalation", Util.GetString(Inhalation)));
            cmd.Parameters.Add(new MySqlParameter("@vAir", Util.GetString(Air)));
            cmd.Parameters.Add(new MySqlParameter("@vAgent", Util.GetString(Agent)));
            cmd.Parameters.Add(new MySqlParameter("@vEtt", Util.GetString(Ett)));
            cmd.Parameters.Add(new MySqlParameter("@vLma", Util.GetString(Lma)));
            cmd.Parameters.Add(new MySqlParameter("@vLaryngoscopy", Util.GetString(Laryngoscopy)));
            cmd.Parameters.Add(new MySqlParameter("@vAids", Util.GetString(Aids)));
            cmd.Parameters.Add(new MySqlParameter("@vAirwayComments", Util.GetString(AirwayComments)));
            cmd.Parameters.Add(new MySqlParameter("@vThroatPack", Util.GetString(ThroatPack)));
            cmd.Parameters.Add(new MySqlParameter("@vCircuit", Util.GetString(Circuit)));
            cmd.Parameters.Add(new MySqlParameter("@vRespiration", Util.GetString(Respiration)));
            cmd.Parameters.Add(new MySqlParameter("@vMode", Util.GetString(Mode)));
            cmd.Parameters.Add(new MySqlParameter("@vVt", Util.GetString(Vt)));
            cmd.Parameters.Add(new MySqlParameter("@vVm", Util.GetString(Vm)));
            cmd.Parameters.Add(new MySqlParameter("@vPmax", Util.GetString(Pmax)));
            cmd.Parameters.Add(new MySqlParameter("@vF", Util.GetString(F)));
            cmd.Parameters.Add(new MySqlParameter("@vPosition", Util.GetString(Position)));
            cmd.Parameters.Add(new MySqlParameter("@vEyesProtected", Util.GetString(EyesProtected)));
            cmd.Parameters.Add(new MySqlParameter("@vIVWarmer", Util.GetString(IVWarmer)));
            cmd.Parameters.Add(new MySqlParameter("@vPressure", Util.GetString(Pressure)));
            cmd.Parameters.Add(new MySqlParameter("@vHme", Util.GetString(Hme)));
            cmd.Parameters.Add(new MySqlParameter("@vConvecting", Util.GetString(Convecting)));
            cmd.Parameters.Add(new MySqlParameter("@vTourniquet_TimeOn", Util.GetString(Tourniquet_TimeOn)));
            cmd.Parameters.Add(new MySqlParameter("@vTourniquet_TimeOff", Util.GetString(Tourniquet_TimeOff)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinal", Util.GetString(Spinal)));
            cmd.Parameters.Add(new MySqlParameter("@vEpidural", Util.GetString(Epidural)));
            cmd.Parameters.Add(new MySqlParameter("@vCaudal", Util.GetString(Caudal)));
            cmd.Parameters.Add(new MySqlParameter("@vPlexus", Util.GetString(Plexus)));
            cmd.Parameters.Add(new MySqlParameter("@vRegionalOther", Util.GetString(RegionalOther)));
            cmd.Parameters.Add(new MySqlParameter("@vRegionalAgent", Util.GetString(RegionalAgent)));
            cmd.Parameters.Add(new MySqlParameter("@vConcentration", Util.GetString(Concentration)));
            cmd.Parameters.Add(new MySqlParameter("@vApiates", Util.GetString(Apiates)));
            cmd.Parameters.Add(new MySqlParameter("@vAdrenaline", Util.GetString(Adrenaline)));
            cmd.Parameters.Add(new MySqlParameter("@vNerve_Stimulator", Util.GetString(Nerve_Stimulator)));
            cmd.Parameters.Add(new MySqlParameter("@vCrystalloid", Util.GetString(Crystalloid)));
            cmd.Parameters.Add(new MySqlParameter("@vColloid", Util.GetString(Colloid)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodIn", Util.GetString(BloodIn)));
            cmd.Parameters.Add(new MySqlParameter("@vFFp", Util.GetString(FFp)));
            cmd.Parameters.Add(new MySqlParameter("@vPlats", Util.GetString(Plats)));
            cmd.Parameters.Add(new MySqlParameter("@vIn_Other", Util.GetString(In_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vBlood_Loss", Util.GetString(Blood_Loss)));
            cmd.Parameters.Add(new MySqlParameter("@vUrine_Output", Util.GetString(Urine_Output)));
            cmd.Parameters.Add(new MySqlParameter("@vOut_Other_Losses", Util.GetString(Out_Other_Losses)));
            cmd.Parameters.Add(new MySqlParameter("@vTotal_In", Util.GetString(Total_In)));
            cmd.Parameters.Add(new MySqlParameter("@vTotal_Out", Util.GetString(Total_Out)));
            cmd.Parameters.Add(new MySqlParameter("@vBalance", Util.GetString(Balance)));
            cmd.Parameters.Add(new MySqlParameter("@vPost_Operative_Instructions", Util.GetString(Post_Operative_Instructions)));
            cmd.Parameters.Add(new MySqlParameter("@vCritical_Incident", Util.GetString(Critical_Incident)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));

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