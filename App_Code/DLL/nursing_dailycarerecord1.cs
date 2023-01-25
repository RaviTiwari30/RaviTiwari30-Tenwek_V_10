using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class nursing_dailycarerecord1
{
    public nursing_dailycarerecord1()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public nursing_dailycarerecord1(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private int _IsSelfBath;
    private int _IsBathes;
    private int _IsCompletebath;
    private int _IsOral;
    private int _IsFoley;
    private int _IsTedsbid;
    private int _IsBnutrition100T;
    private int _IsBnutrition50T;
    private int _IsBNPOT;
    private int _IsBDietT;
    private string _BDietT;
    private int _IsLnutrition100T;
    private int _IsLnutrition50T;
    private int _IsLNPOT;
    private int _IsLDietT;
    private string _LDietT;
    private int _IsDnutrition100T;
    private int _IsDnutrition50T;
    private int _IsDNPOT;
    private int _IsDDietT;
    private string _DDietT;
    private int _IsSelfFeed;
    private int _IsAssistfeed;
    private int _IsCompletefeed;
    private int _IsCompletebed;
    private int _IsDangle;
    private int _IsOOBChair;
    private int _IsBRP;
    private int _IsAmbIndependently;
    private int _IsTransfers;
    private int _IsAmbAssist;
    private int _IsWalker;
    private int _IsCane;
    private int _IsCrutches;
    private int _IsTurnReposition;
    private int _IsTractionAA;
    private int _IsTractionBB;
    private int _IsTractionCC;
    private int _IsTractionDD;
    private int _IsTractionEE;
    private string _Traction;
    private string _Weight;
    private int _IsImmoblizer;
    private int _IsBrace;
    private int _IsCPM;
    private int _IsCPMsetting;
    private int _CPMSetting;
    private int _IsMobilityOther;
    private int _IsTedsdvt;
    private int _IsFoot;
    private int _IsCalf;
    private int _IsOtherdvt;
    private int _Dvtother;
    private string _OtherDvt;
    private int _IsCryocuff;
    private int _IsMechanical;
    private int _IsIcePack;
    private string _Icepack;
    private int _IsCallLight;
    private int _IsSiderails;
    private int _IsPartial;
    private int _IsInstruction;
    private string _Comment;
    private DateTime _EntryDate;
    private string _Time;
    private string _UserId;
    private string _UpdatedBy;
    private DateTime _UpdateDate;
    private DateTime _Date;
    private string _UpdatedTime;
    private string _Type;
    private string _PatientHeight;
    private string _PatientWeight;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual int IsSelfBath { get { return _IsSelfBath; } set { _IsSelfBath = value; } }
    public virtual int IsBathes { get { return _IsBathes; } set { _IsBathes = value; } }
    public virtual int IsCompletebath { get { return _IsCompletebath; } set { _IsCompletebath = value; } }
    public virtual int IsOral { get { return _IsOral; } set { _IsOral = value; } }
    public virtual int IsFoley { get { return _IsFoley; } set { _IsFoley = value; } }
    public virtual int IsTedsbid { get { return _IsTedsbid; } set { _IsTedsbid = value; } }
    public virtual int IsBnutrition100T { get { return _IsBnutrition100T; } set { _IsBnutrition100T = value; } }
    public virtual int IsBnutrition50T { get { return _IsBnutrition50T; } set { _IsBnutrition50T = value; } }
    public virtual int IsBNPOT { get { return _IsBNPOT; } set { _IsBNPOT = value; } }
    public virtual int IsBDietT { get { return _IsBDietT; } set { _IsBDietT = value; } }
    public virtual string BDietT { get { return _BDietT; } set { _BDietT = value; } }
    public virtual int IsLnutrition100T { get { return _IsLnutrition100T; } set { _IsLnutrition100T = value; } }
    public virtual int IsLnutrition50T { get { return _IsLnutrition50T; } set { _IsLnutrition50T = value; } }
    public virtual int IsLNPOT { get { return _IsLNPOT; } set { _IsLNPOT = value; } }
    public virtual int IsLDietT { get { return _IsLDietT; } set { _IsLDietT = value; } }
    public virtual string LDietT { get { return _LDietT; } set { _LDietT = value; } }
    public virtual int IsDnutrition100T { get { return _IsDnutrition100T; } set { _IsDnutrition100T = value; } }
    public virtual int IsDnutrition50T { get { return _IsDnutrition50T; } set { _IsDnutrition50T = value; } }
    public virtual int IsDNPOT { get { return _IsDNPOT; } set { _IsDNPOT = value; } }
    public virtual int IsDDietT { get { return _IsDDietT; } set { _IsDDietT = value; } }
    public virtual string DDietT { get { return _DDietT; } set { _DDietT = value; } }
    public virtual int IsSelfFeed { get { return _IsSelfFeed; } set { _IsSelfFeed = value; } }
    public virtual int IsAssistfeed { get { return _IsAssistfeed; } set { _IsAssistfeed = value; } }
    public virtual int IsCompletefeed { get { return _IsCompletefeed; } set { _IsCompletefeed = value; } }
    public virtual int IsCompletebed { get { return _IsCompletebed; } set { _IsCompletebed = value; } }
    public virtual int IsDangle { get { return _IsDangle; } set { _IsDangle = value; } }
    public virtual int IsOOBChair { get { return _IsOOBChair; } set { _IsOOBChair = value; } }
    public virtual int IsBRP { get { return _IsBRP; } set { _IsBRP = value; } }
    public virtual int IsAmbIndependently { get { return _IsAmbIndependently; } set { _IsAmbIndependently = value; } }
    public virtual int IsTransfers { get { return _IsTransfers; } set { _IsTransfers = value; } }
    public virtual int IsAmbAssist { get { return _IsAmbAssist; } set { _IsAmbAssist = value; } }
    public virtual int IsWalker { get { return _IsWalker; } set { _IsWalker = value; } }
    public virtual int IsCane { get { return _IsCane; } set { _IsCane = value; } }
    public virtual int IsCrutches { get { return _IsCrutches; } set { _IsCrutches = value; } }
    public virtual int IsTurnReposition { get { return _IsTurnReposition; } set { _IsTurnReposition = value; } }
    public virtual int IsTractionAA { get { return _IsTractionAA; } set { _IsTractionAA = value; } }
    public virtual int IsTractionBB { get { return _IsTractionBB; } set { _IsTractionBB = value; } }
    public virtual int IsTractionCC { get { return _IsTractionCC; } set { _IsTractionCC = value; } }
    public virtual int IsTractionDD { get { return _IsTractionDD; } set { _IsTractionDD = value; } }
    public virtual int IsTractionEE { get { return _IsTractionEE; } set { _IsTractionEE = value; } }
    public virtual string Traction { get { return _Traction; } set { _Traction = value; } }
    public virtual string Weight { get { return _Weight; } set { _Weight = value; } }
    public virtual int IsImmoblizer { get { return _IsImmoblizer; } set { _IsImmoblizer = value; } }
    public virtual int IsBrace { get { return _IsBrace; } set { _IsBrace = value; } }
    public virtual int IsCPM { get { return _IsCPM; } set { _IsCPM = value; } }
    public virtual int IsCPMsetting { get { return _IsCPMsetting; } set { _IsCPMsetting = value; } }
    public virtual int CPMSetting { get { return _CPMSetting;} set  { _CPMSetting = value; }  }
    public virtual int IsMobilityOther { get { return _IsMobilityOther; } set { _IsMobilityOther = value; } }
    public virtual int IsTedsdvt { get { return _IsTedsdvt; } set { _IsTedsdvt = value; } }
    public virtual int IsFoot { get { return _IsFoot; } set { _IsFoot = value; } }
    public virtual int IsCalf { get { return _IsCalf; } set { _IsCalf = value; } }
    public virtual int IsOtherdvt { get { return _IsOtherdvt; } set { _IsOtherdvt = value; } }
    public virtual int Dvtother { get { return _Dvtother; } set { _Dvtother = value; } }
    public virtual string OtherDvt { get { return _OtherDvt; } set { _OtherDvt = value; } }
    public virtual int IsCryocuff { get { return _IsCryocuff; } set { _IsCryocuff = value; } }
    public virtual int IsMechanical { get { return _IsMechanical; } set { _IsMechanical = value; } }
    public virtual int IsIcePack { get { return _IsIcePack; } set { _IsIcePack = value; } }
    public virtual string Icepack { get { return _Icepack; } set { _Icepack = value; } }
    public virtual int IsCallLight { get { return _IsCallLight; } set { _IsCallLight = value; } }
    public virtual int IsSiderails { get { return _IsSiderails; } set { _IsSiderails = value; } }
    public virtual int IsPartial { get { return _IsPartial; } set { _IsPartial = value; } }
    public virtual int IsInstruction { get { return _IsInstruction; } set { _IsInstruction = value; } }
    public virtual string Comment { get { return _Comment; } set { _Comment = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string Time { get { return _Time; } set { _Time = value; } }
    public virtual string UserId { get { return _UserId; } set { _UserId = value; } }
    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual string UpdatedTime { get { return _UpdatedTime; } set { _UpdatedTime = value; } }
    public virtual string Type { get { return _Type; } set { _Type = value; } }
    public virtual string PatientHeight { get { return _PatientHeight; } set { _PatientHeight = value; } }
    public virtual string PatientWeight { get { return _PatientWeight; } set { _PatientWeight = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("spnursing_dailycarerecord1_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSelfBath", Util.GetInt(IsSelfBath)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBathes", Util.GetInt(IsBathes)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletebath", Util.GetInt(IsCompletebath)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOral", Util.GetInt(IsOral)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFoley", Util.GetInt(IsFoley)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTedsbid", Util.GetInt(IsTedsbid)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBnutrition100T", Util.GetInt(IsBnutrition100T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBnutrition50T", Util.GetInt(IsBnutrition50T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBNPOT", Util.GetInt(IsBNPOT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBDietT", Util.GetInt(IsBDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vBDietT", Util.GetString(BDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLnutrition100T", Util.GetInt(IsLnutrition100T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLnutrition50T", Util.GetInt(IsLnutrition50T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLNPOT", Util.GetInt(IsLNPOT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLDietT", Util.GetInt(IsLDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vLDietT", Util.GetString(LDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDnutrition100T", Util.GetInt(IsDnutrition100T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDnutrition50T", Util.GetInt(IsDnutrition50T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDNPOT", Util.GetInt(IsDNPOT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDDietT", Util.GetInt(IsDDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vDDietT", Util.GetString(DDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSelfFeed", Util.GetInt(IsSelfFeed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAssistfeed", Util.GetInt(IsAssistfeed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletefeed", Util.GetInt(IsCompletefeed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletebed", Util.GetInt(IsCompletebed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDangle", Util.GetInt(IsDangle)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOOBChair", Util.GetInt(IsOOBChair)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBRP", Util.GetInt(IsBRP)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAmbIndependently", Util.GetInt(IsAmbIndependently)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransfers", Util.GetInt(IsTransfers)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAmbAssist", Util.GetInt(IsAmbAssist)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWalker", Util.GetInt(IsWalker)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCane", Util.GetInt(IsCane)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCrutches", Util.GetInt(IsCrutches)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTurnReposition", Util.GetInt(IsTurnReposition)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionAA", Util.GetInt(IsTractionAA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionBB", Util.GetInt(IsTractionBB)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionCC", Util.GetInt(IsTractionCC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionDD", Util.GetInt(IsTractionDD)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionEE", Util.GetInt(IsTractionEE)));
            cmd.Parameters.Add(new MySqlParameter("@vTraction", Util.GetString(Traction)));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Util.GetString(Weight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsImmoblizer", Util.GetInt(IsImmoblizer)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrace", Util.GetInt(IsBrace)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCPM", Util.GetInt(IsCPM)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCPMsetting", Util.GetInt(IsCPMsetting)));
            cmd.Parameters.Add(new MySqlParameter("@vCPMSetting",Util.GetString(CPMSetting)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMobilityOther", Util.GetInt(IsMobilityOther)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTedsdvt", Util.GetInt(IsTedsdvt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFoot", Util.GetInt(IsFoot)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCalf", Util.GetInt(IsCalf)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherdvt", Util.GetInt(IsOtherdvt)));
            cmd.Parameters.Add(new MySqlParameter("@vDvtother", Util.GetInt(Dvtother)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherDvt", Util.GetString(OtherDvt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCryocuff", Util.GetInt(IsCryocuff)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMechanical", Util.GetInt(IsMechanical)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIcePack", Util.GetInt(IsIcePack)));
            cmd.Parameters.Add(new MySqlParameter("@vIcepack", Util.GetString(Icepack)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCallLight", Util.GetInt(IsCallLight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSiderails", Util.GetInt(IsSiderails)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPartial", Util.GetInt(IsPartial)));
            cmd.Parameters.Add(new MySqlParameter("@vIsInstruction", Util.GetInt(IsInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vComment", Util.GetString(Comment)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            //cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vUserId", Util.GetString(UserId)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            //cmd.Parameters.Add(new MySqlParameter("@vUpdatedTime", Util.GetString(UpdatedTime)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientHeight", Util.GetString(PatientHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientWeight", Util.GetString(PatientWeight)));

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

            objSQL.Append("spnursing_dailycarerecord1_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSelfBath", Util.GetInt(IsSelfBath)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBathes", Util.GetInt(IsBathes)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletebath", Util.GetInt(IsCompletebath)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOral", Util.GetInt(IsOral)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFoley", Util.GetInt(IsFoley)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTedsbid", Util.GetInt(IsTedsbid)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBnutrition100T", Util.GetInt(IsBnutrition100T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBnutrition50T", Util.GetInt(IsBnutrition50T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBNPOT", Util.GetInt(IsBNPOT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBDietT", Util.GetInt(IsBDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vBDietT", Util.GetString(BDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLnutrition100T", Util.GetInt(IsLnutrition100T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLnutrition50T", Util.GetInt(IsLnutrition50T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLNPOT", Util.GetInt(IsLNPOT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLDietT", Util.GetInt(IsLDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vLDietT", Util.GetString(LDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDnutrition100T", Util.GetInt(IsDnutrition100T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDnutrition50T", Util.GetInt(IsDnutrition50T)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDNPOT", Util.GetInt(IsDNPOT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDDietT", Util.GetInt(IsDDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vDDietT", Util.GetString(DDietT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSelfFeed", Util.GetInt(IsSelfFeed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAssistfeed", Util.GetInt(IsAssistfeed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletefeed", Util.GetInt(IsCompletefeed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCompletebed", Util.GetInt(IsCompletebed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDangle", Util.GetInt(IsDangle)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOOBChair", Util.GetInt(IsOOBChair)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBRP", Util.GetInt(IsBRP)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAmbIndependently", Util.GetInt(IsAmbIndependently)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTransfers", Util.GetInt(IsTransfers)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAmbAssist", Util.GetInt(IsAmbAssist)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWalker", Util.GetInt(IsWalker)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCane", Util.GetInt(IsCane)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCrutches", Util.GetInt(IsCrutches)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTurnReposition", Util.GetInt(IsTurnReposition)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionAA", Util.GetInt(IsTractionAA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionBB", Util.GetInt(IsTractionBB)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionCC", Util.GetInt(IsTractionCC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionDD", Util.GetInt(IsTractionDD)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTractionEE", Util.GetInt(IsTractionEE)));
            cmd.Parameters.Add(new MySqlParameter("@vTraction", Util.GetString(Traction)));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Util.GetString(Weight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsImmoblizer", Util.GetInt(IsImmoblizer)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBrace", Util.GetInt(IsBrace)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCPM", Util.GetInt(IsCPM)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCPMsetting", Util.GetInt(IsCPMsetting)));
            cmd.Parameters.Add(new MySqlParameter("@vCPMSetting",Util.GetString(CPMSetting)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMobilityOther", Util.GetInt(IsMobilityOther)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTedsdvt", Util.GetInt(IsTedsdvt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFoot", Util.GetInt(IsFoot)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCalf", Util.GetInt(IsCalf)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherdvt", Util.GetInt(IsOtherdvt)));
            cmd.Parameters.Add(new MySqlParameter("@vDvtother", Util.GetInt(Dvtother)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherDvt", Util.GetString(OtherDvt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCryocuff", Util.GetInt(IsCryocuff)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMechanical", Util.GetInt(IsMechanical)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIcePack", Util.GetInt(IsIcePack)));
            cmd.Parameters.Add(new MySqlParameter("@vIcepack", Util.GetString(Icepack)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCallLight", Util.GetInt(IsCallLight)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSiderails", Util.GetInt(IsSiderails)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPartial", Util.GetInt(IsPartial)));
            cmd.Parameters.Add(new MySqlParameter("@vIsInstruction", Util.GetInt(IsInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vComment", Util.GetString(Comment)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            //cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            //cmd.Parameters.Add(new MySqlParameter("@vUserId", Util.GetString(UserId)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            //cmd.Parameters.Add(new MySqlParameter("@vUpdatedTime", Util.GetString(UpdatedTime)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientHeight", Util.GetString(PatientHeight)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientWeight", Util.GetString(PatientWeight)));
            //Output = cmd.ExecuteScalar().ToString();
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



    #endregion

}
