using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for ipd_ecg_examination
/// </summary>
public class ipd_ecg_examination
{
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public ipd_ecg_examination()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public ipd_ecg_examination(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region All Memory Variables
    private string _PatientID;
    private string _TransactionID;
    private string _CardiomegalyofUCouse;
    private string _HeartfailureofUCause;
    private string _SystolicmurmurState;
    private string _DiastolicmurmurState;
    private string _RCarditisFeverHeDisease;
    private string _Fever;
    private string _Clubblingoffing;
    private string _Splenmegaly;
    private string _MicroHeamaturia;
    private string _PoBloodCulture;
    private string _RaisedEsr;
    private string _Anaemia;
    private string _PeriEffCardTampPeri;
    private string _HyperHeartDis;
    private string _AngPectMyoCardinf;
    private string _CongHeartDis;
    private string _OtherRes;
    private string _Dyspnoea;
    private string _EasyFatig;
    private string _Palpitation;
    private string _Orthopoea;
    private string _NoctDypWheeCough;
    private string _FrothySputum;
    private string _Heamoptysis;
    private string _AnkleAbdoGenSwel;
    private string _NYHeartAssFuncClass;
    private string _NYHeartAssFuncClass_1;
    private string _NYHeartAssFuncClass_2;
    private string _NYHeartAssFuncClass_3;
    private string _NYHeartAssFuncClass_4;
    private string _lastUpdatedBy;
    private DateTime _lastUpdateDate;
    #endregion

    #region Set All Property
    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }
    public string TransactionID
    {
        get { return _TransactionID; }
        set { _TransactionID = value; }
    }
    public string CardiomegalyofUCouse
    {
        get { return _CardiomegalyofUCouse; }
        set { _CardiomegalyofUCouse = value; }
    }
    public string HeartfailureofUCause
    {
        get { return _HeartfailureofUCause; }
        set { _HeartfailureofUCause = value; }
    }

    public string SystolicmurmurState
    {
        get { return _SystolicmurmurState; }
        set { _SystolicmurmurState = value; }
    }
    public string DiastolicmurmurState
    {
        get { return _DiastolicmurmurState; }
        set { _DiastolicmurmurState = value; }
    }
    public string RCarditisFeverHeDisease
    {
        get { return _RCarditisFeverHeDisease; }
        set { _RCarditisFeverHeDisease = value; }
    }
    public string Fever
    {
        get { return _Fever; }
        set { _Fever = value; }
    }


    public string Clubblingoffing
    {
        get { return _Clubblingoffing; }
        set { _Clubblingoffing = value; }
    }
    public string Splenmegaly
    {
        get { return _Splenmegaly; }
        set { _Splenmegaly = value; }
    }
    public string MicroHeamaturia
    {
        get { return _MicroHeamaturia; }
        set { _MicroHeamaturia = value; }
    }
    public string PoBloodCulture
    {
        get { return _PoBloodCulture; }
        set { _PoBloodCulture = value; }
    }

    public string RaisedEsr
    {
        get { return _RaisedEsr; }
        set { _RaisedEsr = value; }
    }
    public string Anaemia
    {
        get { return _Anaemia; }
        set { _Anaemia = value; }
    }
    public string PeriEffCardTampPeri
    {
        get { return _PeriEffCardTampPeri; }
        set { _PeriEffCardTampPeri = value; }
    }
    public string HyperHeartDis
    {
        get { return _HyperHeartDis; }
        set { _HyperHeartDis = value; }
    }


    public string AngPectMyoCardinf
    {
        get { return _AngPectMyoCardinf; }
        set { _AngPectMyoCardinf = value; }
    }
    public string CongHeartDis
    {
        get { return _CongHeartDis; }
        set { _CongHeartDis = value; }
    }
    public string OtherRes
    {
        get { return _OtherRes; }
        set { _OtherRes = value; }
    }
    public string Dyspnoea
    {
        get { return _Dyspnoea; }
        set { _Dyspnoea = value; }
    }


    public string EasyFatig
    {
        get { return _EasyFatig; }
        set { _EasyFatig = value; }
    }
    public string Palpitation
    {
        get { return _Palpitation; }
        set { _Palpitation = value; }
    }
    public string Orthopoea
    {
        get { return _Orthopoea; }
        set { _Orthopoea = value; }
    }
    public string NoctDypWheeCough
    {
        get { return _NoctDypWheeCough; }
        set { _NoctDypWheeCough = value; }
    }


    public string FrothySputum
    {
        get { return _FrothySputum; }
        set { _FrothySputum = value; }
    }
    public string Heamoptysis
    {
        get { return _Heamoptysis; }
        set { _Heamoptysis = value; }
    }
    public string AnkleAbdoGenSwel
    {
        get { return _AnkleAbdoGenSwel; }
        set { _AnkleAbdoGenSwel = value; }
    }
    public string NYHeartAssFuncClass
    {
        get { return _NYHeartAssFuncClass; }
        set { _NYHeartAssFuncClass = value; }
    }


    public string NYHeartAssFuncClass_1
    {
        get { return _NYHeartAssFuncClass_1; }
        set { _NYHeartAssFuncClass_1 = value; }
    }
    public string NYHeartAssFuncClass_2
    {
        get { return _NYHeartAssFuncClass_2; }
        set { _NYHeartAssFuncClass_2 = value; }
    }
    public string NYHeartAssFuncClass_3
    {
        get { return _NYHeartAssFuncClass_3; }
        set { _NYHeartAssFuncClass_3 = value; }
    }
    public string NYHeartAssFuncClass_4
    {
        get { return _NYHeartAssFuncClass_4; }
        set { _NYHeartAssFuncClass_4 = value; }
    }

    public string lastUpdatedBy
    {
        get { return _lastUpdatedBy; }
        set { _lastUpdatedBy = value; }
    }
    public DateTime lastUpdateDate
    {
        get { return _lastUpdateDate; }
        set { _lastUpdateDate = value; }
    }
    #endregion

    #region All Public Member Function
    public void Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_ipd_ecg_examination");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.CardiomegalyofUCouse = Util.GetString(CardiomegalyofUCouse);
            this.HeartfailureofUCause = Util.GetString(HeartfailureofUCause);
            this.SystolicmurmurState = Util.GetString(SystolicmurmurState);
            this.DiastolicmurmurState = Util.GetString(DiastolicmurmurState);
            this.RCarditisFeverHeDisease = Util.GetString(RCarditisFeverHeDisease);
            this.Fever = Util.GetString(Fever);
            this.Clubblingoffing = Util.GetString(Clubblingoffing);
            this.Splenmegaly = Util.GetString(Splenmegaly);
            this.MicroHeamaturia = Util.GetString(MicroHeamaturia);
            this.PoBloodCulture = Util.GetString(PoBloodCulture);
            this.RaisedEsr = Util.GetString(RaisedEsr);
            this.Anaemia = Util.GetString(Anaemia);
            this.PeriEffCardTampPeri = Util.GetString(PeriEffCardTampPeri);
            this.HyperHeartDis = Util.GetString(HyperHeartDis);
            this.AngPectMyoCardinf = Util.GetString(AngPectMyoCardinf);
            this.CongHeartDis = Util.GetString(CongHeartDis);
            this.OtherRes = Util.GetString(OtherRes);
            this.Dyspnoea = Util.GetString(Dyspnoea);
            this.EasyFatig = Util.GetString(EasyFatig);
            this.Palpitation = Util.GetString(Palpitation);
            this.Orthopoea = Util.GetString(Orthopoea);
            this.NoctDypWheeCough = Util.GetString(NoctDypWheeCough);
            this.FrothySputum = Util.GetString(FrothySputum);
            this.Heamoptysis = Util.GetString(Heamoptysis);
            this.AnkleAbdoGenSwel = Util.GetString(AnkleAbdoGenSwel);
            this.NYHeartAssFuncClass = Util.GetString(NYHeartAssFuncClass);
            this.NYHeartAssFuncClass_1 = Util.GetString(NYHeartAssFuncClass_1);
            this.NYHeartAssFuncClass_2 = Util.GetString(NYHeartAssFuncClass_2);
            this.NYHeartAssFuncClass_3 = Util.GetString(NYHeartAssFuncClass_3);
            this.NYHeartAssFuncClass_4 = Util.GetString(NYHeartAssFuncClass_4);
            this.lastUpdatedBy = Util.GetString(lastUpdatedBy);
            this.lastUpdateDate = Util.GetDateTime(lastUpdateDate);

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vCardiomegalyofUCouse", CardiomegalyofUCouse));
            cmd.Parameters.Add(new MySqlParameter("@vHeartfailureofUCause", HeartfailureofUCause));
            cmd.Parameters.Add(new MySqlParameter("@vSystolicmurmurState", SystolicmurmurState));
            cmd.Parameters.Add(new MySqlParameter("@vDiastolicmurmurState", DiastolicmurmurState));
            cmd.Parameters.Add(new MySqlParameter("@vRCarditisFeverHeDisease", RCarditisFeverHeDisease));
            cmd.Parameters.Add(new MySqlParameter("@vFever", Fever));
            cmd.Parameters.Add(new MySqlParameter("@vClubblingoffing", Clubblingoffing));
            cmd.Parameters.Add(new MySqlParameter("@vSplenmegaly", Splenmegaly));
            cmd.Parameters.Add(new MySqlParameter("@vMicroHeamaturia", MicroHeamaturia));
            cmd.Parameters.Add(new MySqlParameter("@vPoBloodCulture", PoBloodCulture));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedEsr", RaisedEsr));
            cmd.Parameters.Add(new MySqlParameter("@vAnaemia", Anaemia));
            cmd.Parameters.Add(new MySqlParameter("@vPeriEffCardTampPeri", PeriEffCardTampPeri));
            cmd.Parameters.Add(new MySqlParameter("@vHyperHeartDis", HyperHeartDis));
            cmd.Parameters.Add(new MySqlParameter("@vAngPectMyoCardinf", AngPectMyoCardinf));
            cmd.Parameters.Add(new MySqlParameter("@vCongHeartDis", CongHeartDis));
            cmd.Parameters.Add(new MySqlParameter("@vOtherRes", OtherRes));
            cmd.Parameters.Add(new MySqlParameter("@vDyspnoea", Dyspnoea));
            cmd.Parameters.Add(new MySqlParameter("@vEasyFatig", EasyFatig));
            cmd.Parameters.Add(new MySqlParameter("@vPalpitation", Palpitation));
            cmd.Parameters.Add(new MySqlParameter("@vOrthopoea", Orthopoea));
            cmd.Parameters.Add(new MySqlParameter("@vNoctDypWheeCough", NoctDypWheeCough));
            cmd.Parameters.Add(new MySqlParameter("@vFrothySputum", FrothySputum));
            cmd.Parameters.Add(new MySqlParameter("@vHeamoptysis", Heamoptysis));
            cmd.Parameters.Add(new MySqlParameter("@vAnkleAbdoGenSwel", AnkleAbdoGenSwel));
            cmd.Parameters.Add(new MySqlParameter("@vNYHeartAssFuncClass", NYHeartAssFuncClass));
            cmd.Parameters.Add(new MySqlParameter("@vNYHeartAssFuncClass_1", NYHeartAssFuncClass_1));
            cmd.Parameters.Add(new MySqlParameter("@vNYHeartAssFuncClass_2", NYHeartAssFuncClass_2));
            cmd.Parameters.Add(new MySqlParameter("@vNYHeartAssFuncClass_3", NYHeartAssFuncClass_3));
            cmd.Parameters.Add(new MySqlParameter("@vNYHeartAssFuncClass_4", NYHeartAssFuncClass_4));
            cmd.Parameters.Add(new MySqlParameter("@vlastUpdatedBy", lastUpdatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vlastUpdateDate", lastUpdateDate));

            cmd.ExecuteNonQuery();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            throw (ex);
        }


    }
    #endregion
}