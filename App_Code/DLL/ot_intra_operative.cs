using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_intra_operative
{
    public ot_intra_operative()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_intra_operative(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _AdmittedTo;
    private string _IDBand;
    private string _Consent;
    private string _Prophylactic;
    private string _Medication;
    private string _Time;
    private string _AdministeredBy;
    private string _HairRemoval;
    private string _Color;
    private string _Integrity;
    private string _Temp;
    private string _SupineAssisted;
    private string _Prone;
    private string _LateralAssisted;
    private string _Other;
    private string _Oral;
    private string _Nasal;
    private string _SupineSurgery;
    private string _LateralSurgery;
    private string _RtArmAtSide;
    private string _RtArmArmBoard;
    private string _RtArmDblarmBoard;
    private string _LtArmAtSide;
    private string _LtArmArmBoard;
    private string _LtArmDblarmBoard;
    private string _RtAces;
    private string _RtKneeHi;
    private string _RtThighHi;
    private string _RtSequential;
    private string _LtAces;
    private string _LtKneeHi;
    private string _LtThighHi;
    private string _LtSequential;
    private string _AppliedBy;
    private string _Serial;
    private string _Size;
    private string _Comment;
    private string _AnyDeviation;
    private string _HyperUnit;
    private string _Site1;
    private string _AppliedBy1;
    private string _Remarks1;
    private string _Site2;
    private string _AppliedBy2;
    private string _Remarks2;
    private string _Bipolar;
    private string _SerialBipolar;
    private string _SerialPressure;
    private string _RtArmOnTime;
    private string _RtArmOffTime;
    private string _RtLegOnTime;
    private string _RtLegOffTime;
    private string _LtArmOnTime;
    private string _LtArmOffTime;
    private string _LtLegOnTime;
    private string _LtLegOffTime;
    private string _AppliedByPressure;
    private string _DressingAppliedSite;
    private string _DressingAbducation;
    private string _DressingMammary;
    private string _DressingOther;
    private string _AdditionalComment;
    private string _EnterBy;

    private string _OtherAdmittedBY;
    private string _IntegritySite;
    private string _OtherAssisetd;
    private string _SpineAP;
    private string _LateralAP;
    private string _ProneAP;
    private string _OtherAP;
    private string _OtherAPName;
    private string _ProneSP;
    private string _otherSP;
    private string _OtherSPName;
    private string _PositioningTools;
    private string _PresentOnAdmission;
    private string _InsertedORBy;
    private string _Sterile;
    private string _TemperatureSupport;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string AdmittedTo { get { return _AdmittedTo; } set { _AdmittedTo = value; } }
    public virtual string IDBand { get { return _IDBand; } set { _IDBand = value; } }
    public virtual string Consent { get { return _Consent; } set { _Consent = value; } }
    public virtual string Prophylactic { get { return _Prophylactic; } set { _Prophylactic = value; } }
    public virtual string Medication { get { return _Medication; } set { _Medication = value; } }
    public virtual string Time { get { return _Time; } set { _Time = value; } }
    public virtual string AdministeredBy { get { return _AdministeredBy; } set { _AdministeredBy = value; } }
    public virtual string HairRemoval { get { return _HairRemoval; } set { _HairRemoval = value; } }
    public virtual string Color { get { return _Color; } set { _Color = value; } }
    public virtual string Integrity { get { return _Integrity; } set { _Integrity = value; } }
    public virtual string Temp { get { return _Temp; } set { _Temp = value; } }
    public virtual string SupineAssisted { get { return _SupineAssisted; } set { _SupineAssisted = value; } }
    public virtual string Prone { get { return _Prone; } set { _Prone = value; } }
    public virtual string LateralAssisted { get { return _LateralAssisted; } set { _LateralAssisted = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string Oral { get { return _Oral; } set { _Oral = value; } }
    public virtual string Nasal { get { return _Nasal; } set { _Nasal = value; } }
    public virtual string SupineSurgery { get { return _SupineSurgery; } set { _SupineSurgery = value; } }
    public virtual string LateralSurgery { get { return _LateralSurgery; } set { _LateralSurgery = value; } }
    public virtual string RtArmAtSide { get { return _RtArmAtSide; } set { _RtArmAtSide = value; } }
    public virtual string RtArmArmBoard { get { return _RtArmArmBoard; } set { _RtArmArmBoard = value; } }
    public virtual string RtArmDblarmBoard { get { return _RtArmDblarmBoard; } set { _RtArmDblarmBoard = value; } }
    public virtual string LtArmAtSide { get { return _LtArmAtSide; } set { _LtArmAtSide = value; } }
    public virtual string LtArmArmBoard { get { return _LtArmArmBoard; } set { _LtArmArmBoard = value; } }
    public virtual string LtArmDblarmBoard { get { return _LtArmDblarmBoard; } set { _LtArmDblarmBoard = value; } }
    public virtual string RtAces { get { return _RtAces; } set { _RtAces = value; } }
    public virtual string RtKneeHi { get { return _RtKneeHi; } set { _RtKneeHi = value; } }
    public virtual string RtThighHi { get { return _RtThighHi; } set { _RtThighHi = value; } }
    public virtual string RtSequential { get { return _RtSequential; } set { _RtSequential = value; } }
    public virtual string LtAces { get { return _LtAces; } set { _LtAces = value; } }
    public virtual string LtKneeHi { get { return _LtKneeHi; } set { _LtKneeHi = value; } }
    public virtual string LtThighHi { get { return _LtThighHi; } set { _LtThighHi = value; } }
    public virtual string LtSequential { get { return _LtSequential; } set { _LtSequential = value; } }
    public virtual string AppliedBy { get { return _AppliedBy; } set { _AppliedBy = value; } }
    public virtual string Serial { get { return _Serial; } set { _Serial = value; } }
    public virtual string Size { get { return _Size; } set { _Size = value; } }
    public virtual string Comment { get { return _Comment; } set { _Comment = value; } }
    public virtual string AnyDeviation { get { return _AnyDeviation; } set { _AnyDeviation = value; } }
    public virtual string HyperUnit { get { return _HyperUnit; } set { _HyperUnit = value; } }
    public virtual string Site1 { get { return _Site1; } set { _Site1 = value; } }
    public virtual string AppliedBy1 { get { return _AppliedBy1; } set { _AppliedBy1 = value; } }
    public virtual string Remarks1 { get { return _Remarks1; } set { _Remarks1 = value; } }
    public virtual string Site2 { get { return _Site2; } set { _Site2 = value; } }
    public virtual string AppliedBy2 { get { return _AppliedBy2; } set { _AppliedBy2 = value; } }
    public virtual string Remarks2 { get { return _Remarks2; } set { _Remarks2 = value; } }
    public virtual string Bipolar { get { return _Bipolar; } set { _Bipolar = value; } }
    public virtual string SerialBipolar { get { return _SerialBipolar; } set { _SerialBipolar = value; } }
    public virtual string SerialPressure { get { return _SerialPressure; } set { _SerialPressure = value; } }
    public virtual string RtArmOnTime { get { return _RtArmOnTime; } set { _RtArmOnTime = value; } }
    public virtual string RtArmOffTime { get { return _RtArmOffTime; } set { _RtArmOffTime = value; } }
    public virtual string RtLegOnTime { get { return _RtLegOnTime; } set { _RtLegOnTime = value; } }
    public virtual string RtLegOffTime { get { return _RtLegOffTime; } set { _RtLegOffTime = value; } }
    public virtual string LtArmOnTime { get { return _LtArmOnTime; } set { _LtArmOnTime = value; } }
    public virtual string LtArmOffTime { get { return _LtArmOffTime; } set { _LtArmOffTime = value; } }
    public virtual string LtLegOnTime { get { return _LtLegOnTime; } set { _LtLegOnTime = value; } }
    public virtual string LtLegOffTime { get { return _LtLegOffTime; } set { _LtLegOffTime = value; } }
    public virtual string AppliedByPressure { get { return _AppliedByPressure; } set { _AppliedByPressure = value; } }
    public virtual string DressingAppliedSite { get { return _DressingAppliedSite; } set { _DressingAppliedSite = value; } }
    public virtual string DressingAbducation { get { return _DressingAbducation; } set { _DressingAbducation = value; } }
    public virtual string DressingMammary { get { return _DressingMammary; } set { _DressingMammary = value; } }
    public virtual string DressingOther { get { return _DressingOther; } set { _DressingOther = value; } }
    public virtual string AdditionalComment { get { return _AdditionalComment; } set { _AdditionalComment = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }
    public virtual string OtherAdmittedBy { get { return _OtherAdmittedBY; } set { _OtherAdmittedBY = value; } }

    public virtual string IntegritySite { get { return _IntegritySite; } set { _IntegritySite = value; } }
    public virtual string OtherAssisetd { get { return _OtherAssisetd; } set { _OtherAssisetd = value; } }
    public virtual string SpineAP { get { return _SpineAP; } set { _SpineAP = value; } }
    public virtual string LateralAP { get { return _LateralAP; } set { _LateralAP = value; } }
    public virtual string ProneAP { get { return _ProneAP; } set { _ProneAP = value; } }
    public virtual string OtherAP { get { return _OtherAP; } set { _OtherAP = value; } }
    public virtual string OtherAPName { get { return _OtherAPName; } set { _OtherAPName = value; } }
    public virtual string ProneSP { get { return _ProneSP; } set { _ProneSP = value; } }
    public virtual string OtherSP { get { return _otherSP; } set { _otherSP = value; } }
    public virtual string OtherSPName { get { return _OtherSPName; } set { _OtherSPName = value; } }
    public virtual string PositioningTools { get { return _PositioningTools; } set { _PositioningTools = value; } }
    public virtual string PresentOnAdmission { get { return _PresentOnAdmission; } set { _PresentOnAdmission = value; } }
    public virtual string InsertedORBy { get { return _InsertedORBy; } set { _InsertedORBy = value; } }
    public virtual string Sterile { get { return _Sterile; } set { _Sterile = value; } }
    public virtual string TemperatureSupport { get { return _TemperatureSupport; } set { _TemperatureSupport = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_intra_operative_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAdmittedTo", Util.GetString(AdmittedTo)));
            cmd.Parameters.Add(new MySqlParameter("@vIDBand", Util.GetString(IDBand)));
            cmd.Parameters.Add(new MySqlParameter("@vConsent", Util.GetString(Consent)));
            cmd.Parameters.Add(new MySqlParameter("@vProphylactic", Util.GetString(Prophylactic)));
            cmd.Parameters.Add(new MySqlParameter("@vMedication", Util.GetString(Medication)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vAdministeredBy", Util.GetString(AdministeredBy)));
            cmd.Parameters.Add(new MySqlParameter("@vHairRemoval", Util.GetString(HairRemoval)));
            cmd.Parameters.Add(new MySqlParameter("@vColor", Util.GetString(Color)));
            cmd.Parameters.Add(new MySqlParameter("@vIntegrity", Util.GetString(Integrity)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp", Util.GetString(Temp)));
            cmd.Parameters.Add(new MySqlParameter("@vSupineAssisted", Util.GetString(SupineAssisted)));
            cmd.Parameters.Add(new MySqlParameter("@vProne", Util.GetString(Prone)));
            cmd.Parameters.Add(new MySqlParameter("@vLateralAssisted", Util.GetString(LateralAssisted)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vOral", Util.GetString(Oral)));
            cmd.Parameters.Add(new MySqlParameter("@vNasal", Util.GetString(Nasal)));
            cmd.Parameters.Add(new MySqlParameter("@vSupineSurgery", Util.GetString(SupineSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vLateralSurgery", Util.GetString(LateralSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vRtArmAtSide", Util.GetString(RtArmAtSide)));
            cmd.Parameters.Add(new MySqlParameter("@vRtArmArmBoard", Util.GetString(RtArmArmBoard)));
            cmd.Parameters.Add(new MySqlParameter("@vRtArmDblarmBoard", Util.GetString(RtArmDblarmBoard)));
            cmd.Parameters.Add(new MySqlParameter("@vLtArmAtSide", Util.GetString(LtArmAtSide)));
            cmd.Parameters.Add(new MySqlParameter("@vLtArmArmBoard", Util.GetString(LtArmArmBoard)));
            cmd.Parameters.Add(new MySqlParameter("@vLtArmDblarmBoard", Util.GetString(LtArmDblarmBoard)));
            cmd.Parameters.Add(new MySqlParameter("@vRtAces", Util.GetString(RtAces)));
            cmd.Parameters.Add(new MySqlParameter("@vRtKneeHi", Util.GetString(RtKneeHi)));
            cmd.Parameters.Add(new MySqlParameter("@vRtThighHi", Util.GetString(RtThighHi)));
            cmd.Parameters.Add(new MySqlParameter("@vRtSequential", Util.GetString(RtSequential)));
            cmd.Parameters.Add(new MySqlParameter("@vLtAces", Util.GetString(LtAces)));
            cmd.Parameters.Add(new MySqlParameter("@vLtKneeHi", Util.GetString(LtKneeHi)));
            cmd.Parameters.Add(new MySqlParameter("@vLtThighHi", Util.GetString(LtThighHi)));
            cmd.Parameters.Add(new MySqlParameter("@vLtSequential", Util.GetString(LtSequential)));
            cmd.Parameters.Add(new MySqlParameter("@vAppliedBy", Util.GetString(AppliedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vSerial", Util.GetString(Serial)));
            cmd.Parameters.Add(new MySqlParameter("@vSize", Util.GetString(Size)));
            cmd.Parameters.Add(new MySqlParameter("@vComment", Util.GetString(Comment)));
            cmd.Parameters.Add(new MySqlParameter("@vAnyDeviation", Util.GetString(AnyDeviation)));
            cmd.Parameters.Add(new MySqlParameter("@vHyperUnit", Util.GetString(HyperUnit)));
            cmd.Parameters.Add(new MySqlParameter("@vSite1", Util.GetString(Site1)));
            cmd.Parameters.Add(new MySqlParameter("@vAppliedBy1", Util.GetString(AppliedBy1)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks1", Util.GetString(Remarks1)));
            cmd.Parameters.Add(new MySqlParameter("@vSite2", Util.GetString(Site2)));
            cmd.Parameters.Add(new MySqlParameter("@vAppliedBy2", Util.GetString(AppliedBy2)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks2", Util.GetString(Remarks2)));
            cmd.Parameters.Add(new MySqlParameter("@vBipolar", Util.GetString(Bipolar)));
            cmd.Parameters.Add(new MySqlParameter("@vSerialBipolar", Util.GetString(SerialBipolar)));
            cmd.Parameters.Add(new MySqlParameter("@vSerialPressure", Util.GetString(SerialPressure)));
            cmd.Parameters.Add(new MySqlParameter("@vRtArmOnTime", Util.GetString(RtArmOnTime)));
            cmd.Parameters.Add(new MySqlParameter("@vRtArmOffTime", Util.GetString(RtArmOffTime)));
            cmd.Parameters.Add(new MySqlParameter("@vRtLegOnTime", Util.GetString(RtLegOnTime)));
            cmd.Parameters.Add(new MySqlParameter("@vRtLegOffTime", Util.GetString(RtLegOffTime)));
            cmd.Parameters.Add(new MySqlParameter("@vLtArmOnTime", Util.GetString(LtArmOnTime)));
            cmd.Parameters.Add(new MySqlParameter("@vLtArmOffTime", Util.GetString(LtArmOffTime)));
            cmd.Parameters.Add(new MySqlParameter("@vLtLegOnTime", Util.GetString(LtLegOnTime)));
            cmd.Parameters.Add(new MySqlParameter("@vLtLegOffTime", Util.GetString(LtLegOffTime)));
            cmd.Parameters.Add(new MySqlParameter("@vAppliedByPressure", Util.GetString(AppliedByPressure)));
            cmd.Parameters.Add(new MySqlParameter("@vDressingAppliedSite", Util.GetString(DressingAppliedSite)));
            cmd.Parameters.Add(new MySqlParameter("@vDressingAbducation", Util.GetString(DressingAbducation)));
            cmd.Parameters.Add(new MySqlParameter("@vDressingMammary", Util.GetString(DressingMammary)));
            cmd.Parameters.Add(new MySqlParameter("@vDressingOther", Util.GetString(DressingOther)));
            cmd.Parameters.Add(new MySqlParameter("@vAdditionalComment", Util.GetString(AdditionalComment)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));

            cmd.Parameters.Add(new MySqlParameter("@vOtherAdmittedBY", Util.GetString(OtherAdmittedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vIntegritySite", Util.GetString(IntegritySite)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherAssisetd", Util.GetString(OtherAssisetd)));
            cmd.Parameters.Add(new MySqlParameter("@vSpineAP", Util.GetString(SpineAP)));
            cmd.Parameters.Add(new MySqlParameter("@vLateralAP", Util.GetString(LateralAP)));
            cmd.Parameters.Add(new MySqlParameter("@vProneAP", Util.GetString(ProneAP)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherAP", Util.GetString(OtherAP)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherAPName", Util.GetString(OtherAP)));
            cmd.Parameters.Add(new MySqlParameter("@vProneSP", Util.GetString(ProneSP)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherSP", Util.GetString(OtherSP)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherSPName", Util.GetString(OtherSPName)));
            cmd.Parameters.Add(new MySqlParameter("@vPositioningTools", Util.GetString(PositioningTools)));
            cmd.Parameters.Add(new MySqlParameter("@vPresentOnAdmission", Util.GetString(PresentOnAdmission)));
            cmd.Parameters.Add(new MySqlParameter("@vInsertedORBy", Util.GetString(InsertedORBy)));
            cmd.Parameters.Add(new MySqlParameter("@vSterile", Util.GetString(Sterile)));
            cmd.Parameters.Add(new MySqlParameter("@vTemperatureSupport", Util.GetString(TemperatureSupport)));

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