using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for cpoe_anestheisa
/// Generated using MySqlManager
/// ==========================================================================================
/// Author:              ANKIT
/// Create date:	11/14/2013 4:21:08 PM
/// Description:	This class is intended for inserting, updating, deleting values for cpoe_anestheisa table
/// ==========================================================================================
/// </summary>

public class cpoe_anestheisa
{
    public cpoe_anestheisa()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_anestheisa(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private DateTime _Date;
    private string _Time;
    private int _IsNPOStatus;
    private string _DiagnosisProcedure;
    private string _PastMSHistory;
    private string _Medications;
    private int _IsNKDA;
    private string _Allergies;
    private int _IsPAC;
    private int _IsFHAC;
    private string _IsyesExplain;
    private string _Tobacco;
    private string _Alcohol;
    private string _Other;
    private string _height;
    private string _Weight;
    private string _Teeth;
    private string _Airway;
    private string _MentalStatus;
    private string _Heart;
    private string _Lung;
    private string _OtherPhysicalExam;
    private int _IsNA;
    private string _HCT;
    private string _PT;
    private string _PTT;
    private string _EKG;
    private string _CXR;
    private string _OtherLabStudies;
    private string _ASA;
    private int _IsOvernightPacu;
    private string _OvernightExplain;
    private int _IsAnalgesia;
    private int _IsPostopAnalgesia;
    private string _PostopAnalgesia;
    private string _Doctor;
    private int _IsIVPCA;
    private int _IsEpiduralPCA;
    private int _IsPeripheralNerveBlock;
    private int _IsPeripheralInfusion;
    private int _Isfollowing;
    private int _IsNoApparent;
    private string _Comments;
    private DateTime _EntryDate;
    private string _UserId;
    private string _UpdatedBy;
    private DateTime _UpdateDate;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual string Time { get { return _Time; } set { _Time = value; } }
    public virtual int IsNPOStatus { get { return _IsNPOStatus; } set { _IsNPOStatus = value; } }
    public virtual string DiagnosisProcedure { get { return _DiagnosisProcedure; } set { _DiagnosisProcedure = value; } }
    public virtual string PastMSHistory { get { return _PastMSHistory; } set { _PastMSHistory = value; } }
    public virtual string Medications { get { return _Medications; } set { _Medications = value; } }
    public virtual int IsNKDA { get { return _IsNKDA; } set { _IsNKDA = value; } }
    public virtual string Allergies { get { return _Allergies; } set { _Allergies = value; } }
    public virtual int IsPAC { get { return _IsPAC; } set { _IsPAC = value; } }
    public virtual int IsFHAC { get { return _IsFHAC; } set { _IsFHAC = value; } }
    public virtual string IsyesExplain { get { return _IsyesExplain; } set { _IsyesExplain = value; } }
    public virtual string Tobacco { get { return _Tobacco; } set { _Tobacco = value; } }
    public virtual string Alcohol { get { return _Alcohol; } set { _Alcohol = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string height { get { return _height; } set { _height = value; } }
    public virtual string Weight { get { return _Weight; } set { _Weight = value; } }
    public virtual string Teeth { get { return _Teeth; } set { _Teeth = value; } }
    public virtual string Airway { get { return _Airway; } set { _Airway = value; } }
    public virtual string MentalStatus { get { return _MentalStatus; } set { _MentalStatus = value; } }
    public virtual string Heart { get { return _Heart; } set { _Heart = value; } }
    public virtual string Lung { get { return _Lung; } set { _Lung = value; } }
    public virtual string OtherPhysicalExam { get { return _OtherPhysicalExam; } set { _OtherPhysicalExam = value; } }
    public virtual int IsNA { get { return _IsNA; } set { _IsNA = value; } }
    public virtual string HCT { get { return _HCT; } set { _HCT = value; } }
    public virtual string PT { get { return _PT; } set { _PT = value; } }
    public virtual string PTT { get { return _PTT; } set { _PTT = value; } }
    public virtual string EKG { get { return _EKG; } set { _EKG = value; } }
    public virtual string CXR { get { return _CXR; } set { _CXR = value; } }
    public virtual string OtherLabStudies { get { return _OtherLabStudies; } set { _OtherLabStudies = value; } }
    public virtual string ASA { get { return _ASA; } set { _ASA = value; } }
    public virtual int IsOvernightPacu { get { return _IsOvernightPacu; } set { _IsOvernightPacu = value; } }
    public virtual string OvernightExplain { get { return _OvernightExplain; } set { _OvernightExplain = value; } }
    public virtual int IsAnalgesia { get { return _IsAnalgesia; } set { _IsAnalgesia = value; } }
    public virtual int IsPostopAnalgesia { get { return _IsPostopAnalgesia; } set { _IsPostopAnalgesia = value; } }
    public virtual string PostopAnalgesia { get { return _PostopAnalgesia; } set { _PostopAnalgesia = value; } }
    public virtual string Doctor { get { return _Doctor; } set { _Doctor = value; } }
    public virtual int IsIVPCA { get { return _IsIVPCA; } set { _IsIVPCA = value; } }
    public virtual int IsEpiduralPCA { get { return _IsEpiduralPCA; } set { _IsEpiduralPCA = value; } }
    public virtual int IsPeripheralNerveBlock { get { return _IsPeripheralNerveBlock; } set { _IsPeripheralNerveBlock = value; } }
    public virtual int IsPeripheralInfusion { get { return _IsPeripheralInfusion; } set { _IsPeripheralInfusion = value; } }
    public virtual int Isfollowing { get { return _Isfollowing; } set { _Isfollowing = value; } }
    public virtual int IsNoApparent { get { return _IsNoApparent; } set { _IsNoApparent = value; } }
    public virtual string Comments { get { return _Comments; } set { _Comments = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UserId { get { return _UserId; } set { _UserId = value; } }
    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("sp_cpoe_anestheisa_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNPOStatus", Util.GetInt(IsNPOStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosisProcedure", Util.GetString(DiagnosisProcedure)));
            cmd.Parameters.Add(new MySqlParameter("@vPastMSHistory", Util.GetString(PastMSHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vMedications", Util.GetString(Medications)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNKDA", Util.GetInt(IsNKDA)));
            cmd.Parameters.Add(new MySqlParameter("@vAllergies", Util.GetString(Allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPAC", Util.GetInt(IsPAC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFHAC", Util.GetInt(IsFHAC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsyesExplain", Util.GetString(IsyesExplain)));
            cmd.Parameters.Add(new MySqlParameter("@vTobacco", Util.GetString(Tobacco)));
            cmd.Parameters.Add(new MySqlParameter("@vAlcohol", Util.GetString(Alcohol)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vheight", Util.GetString(height)));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Util.GetString(Weight)));
            cmd.Parameters.Add(new MySqlParameter("@vTeeth", Util.GetString(Teeth)));
            cmd.Parameters.Add(new MySqlParameter("@vAirway", Util.GetString(Airway)));
            cmd.Parameters.Add(new MySqlParameter("@vMentalStatus", Util.GetString(MentalStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vHeart", Util.GetString(Heart)));
            cmd.Parameters.Add(new MySqlParameter("@vLung", Util.GetString(Lung)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherPhysicalExam", Util.GetString(OtherPhysicalExam)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNA", Util.GetInt(IsNA)));
            cmd.Parameters.Add(new MySqlParameter("@vHCT", Util.GetString(HCT)));
            cmd.Parameters.Add(new MySqlParameter("@vPT", Util.GetString(PT)));
            cmd.Parameters.Add(new MySqlParameter("@vPTT", Util.GetString(PTT)));
            cmd.Parameters.Add(new MySqlParameter("@vEKG", Util.GetString(EKG)));
            cmd.Parameters.Add(new MySqlParameter("@vCXR", Util.GetString(CXR)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherLabStudies", Util.GetString(OtherLabStudies)));
            cmd.Parameters.Add(new MySqlParameter("@vASA", Util.GetString(ASA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOvernightPacu", Util.GetInt(IsOvernightPacu)));
            cmd.Parameters.Add(new MySqlParameter("@vOvernightExplain", Util.GetString(OvernightExplain)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnalgesia", Util.GetInt(IsAnalgesia)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPostopAnalgesia", Util.GetInt(IsPostopAnalgesia)));
            cmd.Parameters.Add(new MySqlParameter("@vPostopAnalgesia", Util.GetString(PostopAnalgesia)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctor", Util.GetString(Doctor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIVPCA", Util.GetInt(IsIVPCA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsEpiduralPCA", Util.GetInt(IsEpiduralPCA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPeripheralNerveBlock", Util.GetInt(IsPeripheralNerveBlock)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPeripheralInfusion", Util.GetInt(IsPeripheralInfusion)));
            cmd.Parameters.Add(new MySqlParameter("@vIsfollowing", Util.GetInt(Isfollowing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNoApparent", Util.GetInt(IsNoApparent)));
            cmd.Parameters.Add(new MySqlParameter("@vComments", Util.GetString(Comments)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUserId", Util.GetString(UserId)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

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

            objSQL.Append("sp_cpoe_anestheisa_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNPOStatus", Util.GetInt(IsNPOStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosisProcedure", Util.GetString(DiagnosisProcedure)));
            cmd.Parameters.Add(new MySqlParameter("@vPastMSHistory", Util.GetString(PastMSHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vMedications", Util.GetString(Medications)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNKDA", Util.GetInt(IsNKDA)));
            cmd.Parameters.Add(new MySqlParameter("@vAllergies", Util.GetString(Allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPAC", Util.GetInt(IsPAC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFHAC", Util.GetInt(IsFHAC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsyesExplain", Util.GetString(IsyesExplain)));
            cmd.Parameters.Add(new MySqlParameter("@vTobacco", Util.GetString(Tobacco)));
            cmd.Parameters.Add(new MySqlParameter("@vAlcohol", Util.GetString(Alcohol)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vheight", Util.GetString(height)));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Util.GetString(Weight)));
            cmd.Parameters.Add(new MySqlParameter("@vTeeth", Util.GetString(Teeth)));
            cmd.Parameters.Add(new MySqlParameter("@vAirway", Util.GetString(Airway)));
            cmd.Parameters.Add(new MySqlParameter("@vMentalStatus", Util.GetString(MentalStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vHeart", Util.GetString(Heart)));
            cmd.Parameters.Add(new MySqlParameter("@vLung", Util.GetString(Lung)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherPhysicalExam", Util.GetString(OtherPhysicalExam)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNA", Util.GetInt(IsNA)));
            cmd.Parameters.Add(new MySqlParameter("@vHCT", Util.GetString(HCT)));
            cmd.Parameters.Add(new MySqlParameter("@vPT", Util.GetString(PT)));
            cmd.Parameters.Add(new MySqlParameter("@vPTT", Util.GetString(PTT)));
            cmd.Parameters.Add(new MySqlParameter("@vEKG", Util.GetString(EKG)));
            cmd.Parameters.Add(new MySqlParameter("@vCXR", Util.GetString(CXR)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherLabStudies", Util.GetString(OtherLabStudies)));
            cmd.Parameters.Add(new MySqlParameter("@vASA", Util.GetString(ASA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOvernightPacu", Util.GetInt(IsOvernightPacu)));
            cmd.Parameters.Add(new MySqlParameter("@vOvernightExplain", Util.GetString(OvernightExplain)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnalgesia", Util.GetInt(IsAnalgesia)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPostopAnalgesia", Util.GetInt(IsPostopAnalgesia)));
            cmd.Parameters.Add(new MySqlParameter("@vPostopAnalgesia", Util.GetString(PostopAnalgesia)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctor", Util.GetString(Doctor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsIVPCA", Util.GetInt(IsIVPCA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsEpiduralPCA", Util.GetInt(IsEpiduralPCA)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPeripheralNerveBlock", Util.GetInt(IsPeripheralNerveBlock)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPeripheralInfusion", Util.GetInt(IsPeripheralInfusion)));
            cmd.Parameters.Add(new MySqlParameter("@vIsfollowing", Util.GetInt(Isfollowing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNoApparent", Util.GetInt(IsNoApparent)));
            cmd.Parameters.Add(new MySqlParameter("@vComments", Util.GetString(Comments)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            //cmd.Parameters.Add(new MySqlParameter("@vUserId", Util.GetString(UserId)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

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
