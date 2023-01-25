using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;



public class cpoe_history_physical
{
    public cpoe_history_physical()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_history_physical(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _LedgerTnxNo;
    private int _AppID;
    private string _PatientID;
    private string _ChiefComplaint;
    private string _HistoryOfPresentIlliness;
    private int _IsPMH;
    private string _PMH;
    private int _IsPSH;
    private string _PSH;
    private int _IsFamilyHistor;
    private string _FamilyHistory;
    private int _IsSocialHistory;
    private string _Tobacoo;
    private string _Alcohal;
    private string _Drugs;
    private string _BP;
    private string _P;
    private string _R;
    private string _T;
    private string _HT;
    private string _WT;
    private int _IsHistory_PhysicalReview;
    private int _IsPECU;
    private string _Heent;
    private string _Heart;
    private string _Lungs;
    private string _Abdomen;
    private string _Rectal;
    private string _Other;
    private int _IsNormalSkin;
    private int _IsPUR_OnAdmission;
    private decimal _Size;
    private decimal _Depth;
    private string _Stage;
    private string _Location;
    private int _IsDrainage;
    private int _IsErythema;
    private int _IsOdor;
    private int _IsOther;
    private string _Comment;
    private string _PerformedBreast;
    private string _PMDBreast;
    private string _RefusedBreast;
    private int _IsRefusedBreast;
    private int _IsPerformedPAP;
    private int _IsPMDPAP;
    private int _IsRefusedPAP;
    private System.DateTime _PerformedPAP;
    private System.DateTime _PMDPAP;
    private System.DateTime _RefusedPAP;
    private string _RangeR;
    private string _RangeL;
    private string _MotorR;
    private string _MotorL;
    private string _MotorRR;
    private string _MotorLL;
    private string _ReflexR;
    private string _ReflexL;
    private string _SensatationR;
    private string _SensatationL;
    private string _NeuroR;
    private string _NeuroL;
    private string _PulesR;
    private string _PulesL;
    private string _OtherR;
    private string _OtherL;
    private string _Labs;
    private int _IsEKG;
    private int _IsLab;
    private int _IsCXR;
    private string _Surgery;
    private string _Diagnosis_Problems;
    private int _IsPT;
    private int _IsAT;
    private int _IsTraction;
    private int _IsWC;
    private int _IsAC;
    private int _IsConsults;
    private int _IsDP;
    private string _Remark;
    private string _UserID;
    private DateTime _EntryDate;
    private string _UpdateBy;
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
    public virtual string LedgerTnxNo { get { return _LedgerTnxNo; } set { _LedgerTnxNo = value; } }
    public virtual int AppID { get { return _AppID; } set { _AppID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string ChiefComplaint { get { return _ChiefComplaint; } set { _ChiefComplaint = value; } }
    public virtual string HistoryOfPresentIlliness { get { return _HistoryOfPresentIlliness; } set { _HistoryOfPresentIlliness = value; } }
    public virtual int IsPMH { get { return _IsPMH; } set { _IsPMH = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual int IsPSH { get { return _IsPSH; } set { _IsPSH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual int IsFamilyHistor { get { return _IsFamilyHistor; } set { _IsFamilyHistor = value; } }
    public virtual string FamilyHistory { get { return _FamilyHistory; } set { _FamilyHistory = value; } }
    public virtual int IsSocialHistory { get { return _IsSocialHistory; } set { _IsSocialHistory = value; } }
    public virtual string Tobacoo { get { return _Tobacoo; } set { _Tobacoo = value; } }
    public virtual string Alcohal { get { return _Alcohal; } set { _Alcohal = value; } }
    public virtual string Drugs { get { return _Drugs; } set { _Drugs = value; } }
    public virtual string BP { get { return _BP; } set { _BP = value; } }
    public virtual string P { get { return _P; } set { _P = value; } }
    public virtual string R { get { return _R; } set { _R = value; } }
    public virtual string T { get { return _T; } set { _T = value; } }
    public virtual string HT { get { return _HT; } set { _HT = value; } }
    public virtual string WT { get { return _WT; } set { _WT = value; } }
    public virtual int IsHistory_PhysicalReview { get { return _IsHistory_PhysicalReview; } set { _IsHistory_PhysicalReview = value; } }
    public virtual int IsPECU { get { return _IsPECU; } set { _IsPECU = value; } }
    public virtual string Heent { get { return _Heent; } set { _Heent = value; } }
    public virtual string Heart { get { return _Heart; } set { _Heart = value; } }
    public virtual string Lungs { get { return _Lungs; } set { _Lungs = value; } }
    public virtual string Abdomen { get { return _Abdomen; } set { _Abdomen = value; } }
    public virtual string Rectal { get { return _Rectal; } set { _Rectal = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual int IsNormalSkin { get { return _IsNormalSkin; } set { _IsNormalSkin = value; } }
    public virtual int IsPUR_OnAdmission { get { return _IsPUR_OnAdmission; } set { _IsPUR_OnAdmission = value; } }
    public virtual decimal Size { get { return _Size; } set { _Size = value; } }
    public virtual decimal Depth { get { return _Depth; } set { _Depth = value; } }
    public virtual string Stage { get { return _Stage; } set { _Stage = value; } }
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual int IsDrainage { get { return _IsDrainage; } set { _IsDrainage = value; } }
    public virtual int IsErythema { get { return _IsErythema; } set { _IsErythema = value; } }
    public virtual int IsOdor { get { return _IsOdor; } set { _IsOdor = value; } }
    public virtual int IsOther { get { return _IsOther; } set { _IsOther = value; } }
    public virtual string Comment { get { return _Comment; } set { _Comment = value; } }
    public virtual string PerformedBreast { get { return _PerformedBreast; } set { _PerformedBreast = value; } }
    public virtual string PMDBreast { get { return _PMDBreast; } set { _PMDBreast = value; } }
    public virtual string RefusedBreast { get { return _RefusedBreast; } set { _RefusedBreast = value; } }
    public virtual int IsRefusedBreast { get { return _IsRefusedBreast; } set { _IsRefusedBreast = value; } }
    public virtual int IsPerformedPAP { get { return _IsPerformedPAP; } set { _IsPerformedPAP = value; } }
    public virtual int IsPMDPAP { get { return _IsPMDPAP; } set { _IsPMDPAP = value; } }
    public virtual int IsRefusedPAP { get { return _IsRefusedPAP; } set { _IsRefusedPAP = value; } }
    public virtual System.DateTime PerformedPAP { get { return _PerformedPAP; } set { _PerformedPAP = value; } }
    public virtual System.DateTime PMDPAP { get { return _PMDPAP; } set { _PMDPAP = value; } }
    public virtual System.DateTime RefusedPAP { get { return _RefusedPAP; } set { _RefusedPAP = value; } }
    public virtual string RangeR { get { return _RangeR; } set { _RangeR = value; } }
    public virtual string RangeL { get { return _RangeL; } set { _RangeL = value; } }
    public virtual string MotorR { get { return _MotorR; } set { _MotorR = value; } }
    public virtual string MotorL { get { return _MotorL; } set { _MotorL = value; } }
    public virtual string MotorRR { get { return _MotorRR; } set { _MotorRR = value; } }
    public virtual string MotorLL { get { return _MotorLL; } set { _MotorLL = value; } }
    public virtual string ReflexR { get { return _ReflexR; } set { _ReflexR = value; } }
    public virtual string ReflexL { get { return _ReflexL; } set { _ReflexL = value; } }
    public virtual string SensatationR { get { return _SensatationR; } set { _SensatationR = value; } }
    public virtual string SensatationL { get { return _SensatationL; } set { _SensatationL = value; } }
    public virtual string NeuroR { get { return _NeuroR; } set { _NeuroR = value; } }
    public virtual string NeuroL { get { return _NeuroL; } set { _NeuroL = value; } }
    public virtual string PulesR { get { return _PulesR; } set { _PulesR = value; } }
    public virtual string PulesL { get { return _PulesL; } set { _PulesL = value; } }
    public virtual string OtherR { get { return _OtherR; } set { _OtherR = value; } }
    public virtual string OtherL { get { return _OtherL; } set { _OtherL = value; } }
    public virtual string Labs { get { return _Labs; } set { _Labs = value; } }
    public virtual int IsEKG { get { return _IsEKG; } set { _IsEKG = value; } }
    public virtual int IsLab { get { return _IsLab; } set { _IsLab = value; } }
    public virtual int IsCXR { get { return _IsCXR; } set { _IsCXR = value; } }
    public virtual string Surgery { get { return _Surgery; } set { _Surgery = value; } }
    public virtual string Diagnosis_Problems { get { return _Diagnosis_Problems; } set { _Diagnosis_Problems = value; } }
    public virtual int IsPT { get { return _IsPT; } set { _IsPT = value; } }
    public virtual int IsAT { get { return _IsAT; } set { _IsAT = value; } }
    public virtual int IsTraction { get { return _IsTraction; } set { _IsTraction = value; } }
    public virtual int IsWC { get { return _IsWC; } set { _IsWC = value; } }
    public virtual int IsAC { get { return _IsAC; } set { _IsAC = value; } }
    public virtual int IsConsults { get { return _IsConsults; } set { _IsConsults = value; } }
    public virtual int IsDP { get { return _IsDP; } set { _IsDP = value; } }
    public virtual string Remark { get { return _Remark; } set { _Remark = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {  
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_history_physical_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTnxNo", Util.GetString(LedgerTnxNo)));
            cmd.Parameters.Add(new MySqlParameter("@vAppID", Util.GetInt(AppID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vChiefComplaint", Util.GetString(ChiefComplaint)));
            cmd.Parameters.Add(new MySqlParameter("@vHistoryOfPresentIlliness", Util.GetString(HistoryOfPresentIlliness)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPMH", Util.GetInt(IsPMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSH", Util.GetInt(IsPSH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFamilyHistor", Util.GetInt(IsFamilyHistor)));
            cmd.Parameters.Add(new MySqlParameter("@vFamilyHistory", Util.GetString(FamilyHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSocialHistory", Util.GetInt(IsSocialHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vTobacoo", Util.GetString(Tobacoo)));
            cmd.Parameters.Add(new MySqlParameter("@vAlcohal", Util.GetString(Alcohal)));
            cmd.Parameters.Add(new MySqlParameter("@vDrugs", Util.GetString(Drugs)));
            cmd.Parameters.Add(new MySqlParameter("@vBP", Util.GetString(BP)));
            cmd.Parameters.Add(new MySqlParameter("@vP", Util.GetString(P)));
            cmd.Parameters.Add(new MySqlParameter("@vR", Util.GetString(R)));
            cmd.Parameters.Add(new MySqlParameter("@vT", Util.GetString(T)));
            cmd.Parameters.Add(new MySqlParameter("@vHT", Util.GetString(HT)));
            cmd.Parameters.Add(new MySqlParameter("@vWT", Util.GetString(WT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsHistory_PhysicalReview", Util.GetInt(IsHistory_PhysicalReview)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPECU", Util.GetInt(IsPECU)));
            cmd.Parameters.Add(new MySqlParameter("@vHeent", Util.GetString(Heent)));
            cmd.Parameters.Add(new MySqlParameter("@vHeart", Util.GetString(Heart)));
            cmd.Parameters.Add(new MySqlParameter("@vLungs", Util.GetString(Lungs)));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomen", Util.GetString(Abdomen)));
            cmd.Parameters.Add(new MySqlParameter("@vRectal", Util.GetString(Rectal)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNormalSkin", Util.GetInt(IsNormalSkin)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPUR_OnAdmission", Util.GetInt(IsPUR_OnAdmission)));
            cmd.Parameters.Add(new MySqlParameter("@vSize", Util.GetDecimal(Size)));
            cmd.Parameters.Add(new MySqlParameter("@vDepth", Util.GetDecimal(Depth)));
            cmd.Parameters.Add(new MySqlParameter("@vStage", Util.GetString(Stage)));
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDrainage", Util.GetInt(IsDrainage)));
            cmd.Parameters.Add(new MySqlParameter("@vIsErythema", Util.GetInt(IsErythema)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOdor", Util.GetInt(IsOdor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOther", Util.GetInt(IsOther)));
            cmd.Parameters.Add(new MySqlParameter("@vComment", Util.GetString(Comment)));
            cmd.Parameters.Add(new MySqlParameter("@vPerformedBreast", Util.GetString(PerformedBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vPMDBreast", Util.GetString(PMDBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vRefusedBreast", Util.GetString(RefusedBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRefusedBreast", Util.GetInt(IsRefusedBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPerformedPAP", Util.GetInt(IsPerformedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPMDPAP", Util.GetInt(IsPMDPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRefusedPAP", Util.GetInt(IsRefusedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vPerformedPAP", Util.GetDateTime(PerformedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vPMDPAP", Util.GetDateTime(PMDPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vRefusedPAP", Util.GetDateTime(RefusedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vRangeR", Util.GetString(RangeR)));
            cmd.Parameters.Add(new MySqlParameter("@vRangeL", Util.GetString(RangeL)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorR", Util.GetString(MotorR)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorL", Util.GetString(MotorL)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorRR", Util.GetString(MotorRR)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorLL", Util.GetString(MotorLL)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexR", Util.GetString(ReflexR)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexL", Util.GetString(ReflexL)));
            cmd.Parameters.Add(new MySqlParameter("@vSensatationR", Util.GetString(SensatationR)));
            cmd.Parameters.Add(new MySqlParameter("@vSensatationL", Util.GetString(SensatationL)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroR", Util.GetString(NeuroR)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroL", Util.GetString(NeuroL)));
            cmd.Parameters.Add(new MySqlParameter("@vPulesR", Util.GetString(PulesR)));
            cmd.Parameters.Add(new MySqlParameter("@vPulesL", Util.GetString(PulesL)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherR", Util.GetString(OtherR)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherL", Util.GetString(OtherL)));
            cmd.Parameters.Add(new MySqlParameter("@vLabs", Util.GetString(Labs)));
            cmd.Parameters.Add(new MySqlParameter("@vIsEKG", Util.GetInt(IsEKG)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLab", Util.GetInt(IsLab)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCXR", Util.GetInt(IsCXR)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosis_Problems", Util.GetString(Diagnosis_Problems)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPT", Util.GetInt(IsPT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAT", Util.GetInt(IsAT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTraction", Util.GetInt(IsTraction)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWC", Util.GetInt(IsWC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAC", Util.GetInt(IsAC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsConsults", Util.GetInt(IsConsults)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDP", Util.GetInt(IsDP)));
            cmd.Parameters.Add(new MySqlParameter("@vRemark", Util.GetString(Remark)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

            TransactionID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return TransactionID;
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

            objSQL.Append("cpoe_history_physical_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            //cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTnxNo", Util.GetString(LedgerTnxNo)));
            //cmd.Parameters.Add(new MySqlParameter("@vAppID", Util.GetInt(AppID)));
            //cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vChiefComplaint", Util.GetString(ChiefComplaint)));
            cmd.Parameters.Add(new MySqlParameter("@vHistoryOfPresentIlliness", Util.GetString(HistoryOfPresentIlliness)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPMH", Util.GetInt(IsPMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPSH", Util.GetInt(IsPSH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFamilyHistor", Util.GetInt(IsFamilyHistor)));
            cmd.Parameters.Add(new MySqlParameter("@vFamilyHistory", Util.GetString(FamilyHistory)));
           
            cmd.Parameters.Add(new MySqlParameter("@vIsSocialHistory", Util.GetInt(IsSocialHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vTobacoo", Util.GetString(Tobacoo)));
            cmd.Parameters.Add(new MySqlParameter("@vAlcohal", Util.GetString(Alcohal)));
            cmd.Parameters.Add(new MySqlParameter("@vDrugs", Util.GetString(Drugs)));
            cmd.Parameters.Add(new MySqlParameter("@vBP", Util.GetString(BP)));
            cmd.Parameters.Add(new MySqlParameter("@vP", Util.GetString(P)));
            cmd.Parameters.Add(new MySqlParameter("@vR", Util.GetString(R)));
            cmd.Parameters.Add(new MySqlParameter("@vT", Util.GetString(T)));
            cmd.Parameters.Add(new MySqlParameter("@vHT", Util.GetString(HT)));
            cmd.Parameters.Add(new MySqlParameter("@vWT", Util.GetString(WT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsHistory_PhysicalReview", Util.GetInt(IsHistory_PhysicalReview)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPECU", Util.GetInt(IsPECU)));
            cmd.Parameters.Add(new MySqlParameter("@vHeent", Util.GetString(Heent)));
            cmd.Parameters.Add(new MySqlParameter("@vHeart", Util.GetString(Heart)));
            cmd.Parameters.Add(new MySqlParameter("@vLungs", Util.GetString(Lungs)));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomen", Util.GetString(Abdomen)));
            cmd.Parameters.Add(new MySqlParameter("@vRectal", Util.GetString(Rectal)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNormalSkin", Util.GetInt(IsNormalSkin)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPUR_OnAdmission", Util.GetInt(IsPUR_OnAdmission)));
            cmd.Parameters.Add(new MySqlParameter("@vSize", Util.GetDecimal(Size)));
            cmd.Parameters.Add(new MySqlParameter("@vDepth", Util.GetDecimal(Depth)));
            cmd.Parameters.Add(new MySqlParameter("@vStage", Util.GetString(Stage)));
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDrainage", Util.GetInt(IsDrainage)));
            cmd.Parameters.Add(new MySqlParameter("@vIsErythema", Util.GetInt(IsErythema)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOdor", Util.GetInt(IsOdor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOther", Util.GetInt(IsOther)));
            cmd.Parameters.Add(new MySqlParameter("@vComment", Util.GetString(Comment)));
            cmd.Parameters.Add(new MySqlParameter("@vPerformedBreast", Util.GetString(PerformedBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vPMDBreast", Util.GetString(PMDBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vRefusedBreast", Util.GetString(RefusedBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRefusedBreast", Util.GetInt(IsRefusedBreast)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPerformedPAP", Util.GetInt(IsPerformedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPMDPAP", Util.GetInt(IsPMDPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRefusedPAP", Util.GetInt(IsRefusedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vPerformedPAP", Util.GetDateTime(PerformedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vPMDPAP", Util.GetDateTime(PMDPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vRefusedPAP", Util.GetDateTime(RefusedPAP)));
            cmd.Parameters.Add(new MySqlParameter("@vRangeR", Util.GetString(RangeR)));
            cmd.Parameters.Add(new MySqlParameter("@vRangeL", Util.GetString(RangeL)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorR", Util.GetString(MotorR)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorL", Util.GetString(MotorL)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorRR", Util.GetString(MotorRR)));
            cmd.Parameters.Add(new MySqlParameter("@vMotorLL", Util.GetString(MotorLL)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexR", Util.GetString(ReflexR)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexL", Util.GetString(ReflexL)));
            cmd.Parameters.Add(new MySqlParameter("@vSensatationR", Util.GetString(SensatationR)));
            cmd.Parameters.Add(new MySqlParameter("@vSensatationL", Util.GetString(SensatationL)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroR", Util.GetString(NeuroR)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuroL", Util.GetString(NeuroL)));
            cmd.Parameters.Add(new MySqlParameter("@vPulesR", Util.GetString(PulesR)));
            cmd.Parameters.Add(new MySqlParameter("@vPulesL", Util.GetString(PulesL)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherR", Util.GetString(OtherR)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherL", Util.GetString(OtherL)));
            cmd.Parameters.Add(new MySqlParameter("@vLabs", Util.GetString(Labs)));
            cmd.Parameters.Add(new MySqlParameter("@vIsEKG", Util.GetInt(IsEKG)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLab", Util.GetInt(IsLab)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCXR", Util.GetInt(IsCXR)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosis_Problems", Util.GetString(Diagnosis_Problems)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPT", Util.GetInt(IsPT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAT", Util.GetInt(IsAT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTraction", Util.GetInt(IsTraction)));
            cmd.Parameters.Add(new MySqlParameter("@vIsWC", Util.GetInt(IsWC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAC", Util.GetInt(IsAC)));
            cmd.Parameters.Add(new MySqlParameter("@vIsConsults", Util.GetInt(IsConsults)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDP", Util.GetInt(IsDP)));
            cmd.Parameters.Add(new MySqlParameter("@vRemark", Util.GetString(Remark)));
            //cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetString(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
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


    public string Delete()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_history_physical_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vID", ID));

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

    #endregion

}