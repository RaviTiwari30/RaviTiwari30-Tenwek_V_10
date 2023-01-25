using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_surgery_estimate
{
    public cpoe_surgery_estimate()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_surgery_estimate(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _Patient_surgery_ID;
    private string _TransactionID;
    private string _Notes;
    private string _Length_Procedures;
    private int _IsPulmonaryEKG;
    private int _IsEcho;
    private int _IsCVT;
    private int _IsNeurology;
    private int _IsPediatric;
    private int _IsPulmonary;
    private int _IsOtherOrders;
    private int _IsNursing;
    private int _IsPatient;
    private int _IsBone;
    private int _IsNutrition;
    private int _IsRehab;
    private string _PatientID;
    private string _LedgerTransactionNo;
  
    private DateTime _Admitdate;
    private string _Time;
    private string _Primaryphy;
    private string _Assistingphy;
    private string _Otherphy;
    private DateTime _Predate;
    private string _Pretime;
    private string _PreSurgery;

    private string _Bloodunits;
    private string _Bloodfrozen;
    private string _Bloodffp;
    private string _Bloodplts;
    private string _Bloodauto;
    private string _Brace;
    private string _Bracetype;
    private string _Opnursing;
    private string _Oppatient;
    private string _Opbone;
    private string _Opnutrition;
    private string _Oprehab;
    private string _Photos;
    private DateTime _Photosdate;
    private string _Opresearch;
    private string _Opcompleted;
    private string _Fiberop;
    private string _Wakeup1;
    private string _Wakeup2;
    private string _Spinal;
    private string _Allograft;
    private string _Crouton;
    private string _Tricortocal;
    private string _Vitoss;
    private string _Crushed;
    private string _Allograftother;
    private string _Cell;
    private int _IsOR1;
    private int _IsOR2;
    private int _IsLocal;
    private int _IsRegional;
    private int _IsSpinal;
    private int _IsGeneral;
    private string _PulmonaryFunction;
    private string _Echocardiogram;
    private string _PrediatricSurgeon;
    private string _NeurologyConsult;
    private string _PediatricMedical;
    private string _Pulmonary;
    private string _Otherorders;
    private string _Instruments;
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
    public virtual int Patient_surgery_ID { get { return _Patient_surgery_ID; } set { _Patient_surgery_ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Notes { get { return _Notes; } set { _Notes = value; } }
    public virtual string Length_Procedures { get { return _Length_Procedures; } set { _Length_Procedures = value; } }
    public virtual int IsPulmonaryEKG { get { return _IsPulmonaryEKG; } set { _IsPulmonaryEKG = value; } }
    public virtual int IsEcho { get { return _IsEcho; } set { _IsEcho = value; } }
    public virtual int IsCVT { get { return _IsCVT; } set { _IsCVT = value; } }
    public virtual int IsNeurology { get { return _IsNeurology; } set { _IsNeurology = value; } }
    public virtual int IsPediatric { get { return _IsPediatric; } set { _IsPediatric = value; } }
    public virtual int IsPulmonary { get { return _IsPulmonary; } set { _IsPulmonary = value; } }
    public virtual int IsOtherOrders { get { return _IsOtherOrders; } set { _IsOtherOrders = value; } }
    public virtual int IsNursing { get { return _IsNursing; } set { _IsNursing = value; } }
    public virtual int IsPatient { get { return _IsPatient; } set { _IsPatient = value; } }
    public virtual int IsBone { get { return _IsBone; } set { _IsBone = value; } }
    public virtual int IsNutrition { get { return _IsNutrition; } set { _IsNutrition = value; } }
    public virtual int IsRehab { get { return _IsRehab; } set { _IsRehab = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual DateTime Admitdate { get { return _Admitdate; } set { _Admitdate = value; } }
    public virtual string Time { get { return _Time; } set { _Time = value; } }
    public virtual string Primaryphy { get { return _Primaryphy; } set { _Primaryphy = value; } }
    public virtual string Assistingphy { get { return _Assistingphy; } set { _Assistingphy = value; } }
    public virtual string Otherphy { get { return _Otherphy; } set { _Otherphy = value; } }
    public virtual DateTime Predate { get { return _Predate; } set { _Predate = value; } }
    public virtual string Pretime { get { return _Pretime; } set { _Pretime = value; } }
    public virtual string PreSurgery { get { return _PreSurgery; } set { _PreSurgery = value; } }
    public virtual string Bloodunits { get { return _Bloodunits; } set { _Bloodunits = value; } }
    public virtual string Bloodfrozen { get { return _Bloodfrozen; } set { _Bloodfrozen = value; } }
    public virtual string Bloodffp { get { return _Bloodffp; } set { _Bloodffp = value; } }
    public virtual string Bloodplts { get { return _Bloodplts; } set { _Bloodplts = value; } }
    public virtual string Bloodauto { get { return _Bloodauto; } set { _Bloodauto = value; } }
    public virtual string Brace { get { return _Brace; } set { _Brace = value; } }
    public virtual string Bracetype { get { return _Bracetype; } set { _Bracetype = value; } }
    public virtual string Opnursing { get { return _Opnursing; } set { _Opnursing = value; } }
    public virtual string Oppatient { get { return _Oppatient; } set { _Oppatient = value; } }
    public virtual string Opbone { get { return _Opbone; } set { _Opbone = value; } }
    public virtual string Opnutrition { get { return _Opnutrition; } set { _Opnutrition = value; } }
    public virtual string Oprehab { get { return _Oprehab; } set { _Oprehab = value; } }
    public virtual string Photos { get { return _Photos; } set { _Photos = value; } }
    public virtual DateTime Photosdate { get { return _Photosdate; } set { _Photosdate = value; } }
    public virtual string Opresearch { get { return _Opresearch; } set { _Opresearch = value; } }
    public virtual string Opcompleted { get { return _Opcompleted; } set { _Opcompleted = value; } }
    public virtual string Fiberop { get { return _Fiberop; } set { _Fiberop = value; } }
    public virtual string Wakeup1 { get { return _Wakeup1; } set { _Wakeup1 = value; } }
    public virtual string Wakeup2 { get { return _Wakeup2; } set { _Wakeup2 = value; } }
    public virtual string Spinal { get { return _Spinal; } set { _Spinal = value; } }
    public virtual string Allograft { get { return _Allograft; } set { _Allograft = value; } }
    public virtual string Crouton { get { return _Crouton; } set { _Crouton = value; } }
    public virtual string Tricortocal { get { return _Tricortocal; } set { _Tricortocal = value; } }
    public virtual string Vitoss { get { return _Vitoss; } set { _Vitoss = value; } }
    public virtual string Crushed { get { return _Crushed; } set { _Crushed = value; } }
    public virtual string Allograftother { get { return _Allograftother; } set { _Allograftother = value; } }
    public virtual string Cell { get { return _Cell; } set { _Cell = value; } }
    public virtual int IsOR1 { get { return _IsOR1; } set { _IsOR1 = value; } }
    public virtual int IsOR2 { get { return _IsOR2; } set { _IsOR2 = value; } }
    public virtual int IsLocal { get { return _IsLocal; } set { _IsLocal = value; } }
    public virtual int IsRegional { get { return _IsRegional; } set { _IsRegional = value; } }
    public virtual int IsSpinal { get { return _IsSpinal; } set { _IsSpinal = value; } }
    public virtual int IsGeneral { get { return _IsGeneral; } set { _IsGeneral = value; } }
    public virtual string PulmonaryFunction { get { return _PulmonaryFunction; } set { _PulmonaryFunction = value; } }
    public virtual string Echocardiogram { get { return _Echocardiogram; } set { _Echocardiogram = value; } }
    public virtual string PrediatricSurgeon { get { return _PrediatricSurgeon; } set { _PrediatricSurgeon = value; } }
    public virtual string NeurologyConsult { get { return _NeurologyConsult; } set { _NeurologyConsult = value; } }
    public virtual string PediatricMedical { get { return _PediatricMedical; } set { _PediatricMedical = value; } }
    public virtual string Pulmonary { get { return _Pulmonary; } set { _Pulmonary = value; } }
    public virtual string Otherorders { get { return _Otherorders; } set { _Otherorders = value; } }
    public virtual string Instruments { get { return _Instruments; } set { _Instruments = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_surgery_estimate_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vLength_Procedures", Util.GetString(Length_Procedures)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPulmonaryEKG", Util.GetInt(IsPulmonaryEKG)));
            cmd.Parameters.Add(new MySqlParameter("@vIsEcho", Util.GetInt(IsEcho)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCVT", Util.GetInt(IsCVT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNeurology", Util.GetInt(IsNeurology)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPediatric", Util.GetInt(IsPediatric)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPulmonary", Util.GetInt(IsPulmonary)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherOrders", Util.GetInt(IsOtherOrders)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNursing", Util.GetInt(IsNursing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPatient", Util.GetInt(IsPatient)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBone", Util.GetInt(IsBone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNutrition", Util.GetInt(IsNutrition)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRehab", Util.GetInt(IsRehab)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));

            cmd.Parameters.Add(new MySqlParameter("@vAdmitdate", Util.GetDateTime(Admitdate)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vPrimaryphy", Util.GetString(Primaryphy)));
            cmd.Parameters.Add(new MySqlParameter("@vAssistingphy", Util.GetString(Assistingphy)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherphy", Util.GetString(Otherphy)));
            cmd.Parameters.Add(new MySqlParameter("@vPredate", Util.GetDateTime(Predate)));
            cmd.Parameters.Add(new MySqlParameter("@vPretime", Util.GetString(Pretime)));
            cmd.Parameters.Add(new MySqlParameter("@vPreSurgery", Util.GetString(PreSurgery)));

            cmd.Parameters.Add(new MySqlParameter("@vBloodunits", Util.GetString(Bloodunits)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodfrozen", Util.GetString(Bloodfrozen)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodffp", Util.GetString(Bloodffp)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodplts", Util.GetString(Bloodplts)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodauto", Util.GetString(Bloodauto)));
            cmd.Parameters.Add(new MySqlParameter("@vBrace", Util.GetString(Brace)));
            cmd.Parameters.Add(new MySqlParameter("@vBracetype", Util.GetString(Bracetype)));
            cmd.Parameters.Add(new MySqlParameter("@vOpnursing", Util.GetString(Opnursing)));
            cmd.Parameters.Add(new MySqlParameter("@vOppatient", Util.GetString(Oppatient)));
            cmd.Parameters.Add(new MySqlParameter("@vOpbone", Util.GetString(Opbone)));
            cmd.Parameters.Add(new MySqlParameter("@vOpnutrition", Util.GetString(Opnutrition)));
            cmd.Parameters.Add(new MySqlParameter("@vOprehab", Util.GetString(Oprehab)));
            cmd.Parameters.Add(new MySqlParameter("@vPhotos", Util.GetString(Photos)));
            cmd.Parameters.Add(new MySqlParameter("@vPhotosdate", Util.GetDateTime(Photosdate)));
            cmd.Parameters.Add(new MySqlParameter("@vOpresearch", Util.GetString(Opresearch)));
            cmd.Parameters.Add(new MySqlParameter("@vOpcompleted", Util.GetString(Opcompleted)));
            cmd.Parameters.Add(new MySqlParameter("@vFiberop", Util.GetString(Fiberop)));
            cmd.Parameters.Add(new MySqlParameter("@vWakeup1", Util.GetString(Wakeup1)));
            cmd.Parameters.Add(new MySqlParameter("@vWakeup2", Util.GetString(Wakeup2)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinal", Util.GetString(Spinal)));
            cmd.Parameters.Add(new MySqlParameter("@vAllograft", Util.GetString(Allograft)));
            cmd.Parameters.Add(new MySqlParameter("@vCrouton", Util.GetString(Crouton)));
            cmd.Parameters.Add(new MySqlParameter("@vTricortocal", Util.GetString(Tricortocal)));
            cmd.Parameters.Add(new MySqlParameter("@vVitoss", Util.GetString(Vitoss)));
            cmd.Parameters.Add(new MySqlParameter("@vCrushed", Util.GetString(Crushed)));
            cmd.Parameters.Add(new MySqlParameter("@vAllograftother", Util.GetString(Allograftother)));
            cmd.Parameters.Add(new MySqlParameter("@vCell", Util.GetString(Cell)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOR1", Util.GetInt(IsOR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOR2", Util.GetInt(IsOR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLocal", Util.GetInt(IsLocal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRegional", Util.GetInt(IsRegional)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSpinal", Util.GetInt(IsSpinal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGeneral", Util.GetInt(IsGeneral)));
            cmd.Parameters.Add(new MySqlParameter("@vPulmonaryFunction", Util.GetString(PulmonaryFunction)));
            cmd.Parameters.Add(new MySqlParameter("@vEchocardiogram", Util.GetString(Echocardiogram)));
            cmd.Parameters.Add(new MySqlParameter("@vPrediatricSurgeon", Util.GetString(PrediatricSurgeon)));
            cmd.Parameters.Add(new MySqlParameter("@vNeurologyConsult", Util.GetString(NeurologyConsult)));
            cmd.Parameters.Add(new MySqlParameter("@vPediatricMedical", Util.GetString(PediatricMedical)));
            cmd.Parameters.Add(new MySqlParameter("@vPulmonary", Util.GetString(Pulmonary)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherorders", Util.GetString(Otherorders)));
            cmd.Parameters.Add(new MySqlParameter("@vInstruments", Util.GetString(Instruments)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
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


    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_surgery_estimate_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vPatient_surgery_ID", Util.GetInt(Patient_surgery_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vLength_Procedures", Util.GetString(Length_Procedures)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPulmonaryEKG", Util.GetInt(IsPulmonaryEKG)));
            cmd.Parameters.Add(new MySqlParameter("@vIsEcho", Util.GetInt(IsEcho)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCVT", Util.GetInt(IsCVT)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNeurology", Util.GetInt(IsNeurology)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPediatric", Util.GetInt(IsPediatric)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPulmonary", Util.GetInt(IsPulmonary)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherOrders", Util.GetInt(IsOtherOrders)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNursing", Util.GetInt(IsNursing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPatient", Util.GetInt(IsPatient)));
            cmd.Parameters.Add(new MySqlParameter("@vIsBone", Util.GetInt(IsBone)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNutrition", Util.GetInt(IsNutrition)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRehab", Util.GetInt(IsRehab)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));

            cmd.Parameters.Add(new MySqlParameter("@vAdmitdate", Util.GetDateTime(Admitdate)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vPrimaryphy", Util.GetString(Primaryphy)));
            cmd.Parameters.Add(new MySqlParameter("@vAssistingphy", Util.GetString(Assistingphy)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherphy", Util.GetString(Otherphy)));
            cmd.Parameters.Add(new MySqlParameter("@vPredate", Util.GetDateTime(Predate)));
            cmd.Parameters.Add(new MySqlParameter("@vPretime", Util.GetString(Pretime)));
            cmd.Parameters.Add(new MySqlParameter("@vPreSurgery", Util.GetString(PreSurgery)));

            cmd.Parameters.Add(new MySqlParameter("@vBloodunits", Util.GetString(Bloodunits)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodfrozen", Util.GetString(Bloodfrozen)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodffp", Util.GetString(Bloodffp)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodplts", Util.GetString(Bloodplts)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodauto", Util.GetString(Bloodauto)));
            cmd.Parameters.Add(new MySqlParameter("@vBrace", Util.GetString(Brace)));
            cmd.Parameters.Add(new MySqlParameter("@vBracetype", Util.GetString(Bracetype)));
            cmd.Parameters.Add(new MySqlParameter("@vOpnursing", Util.GetString(Opnursing)));
            cmd.Parameters.Add(new MySqlParameter("@vOppatient", Util.GetString(Oppatient)));
            cmd.Parameters.Add(new MySqlParameter("@vOpbone", Util.GetString(Opbone)));
            cmd.Parameters.Add(new MySqlParameter("@vOpnutrition", Util.GetString(Opnutrition)));
            cmd.Parameters.Add(new MySqlParameter("@vOprehab", Util.GetString(Oprehab)));
            cmd.Parameters.Add(new MySqlParameter("@vPhotos", Util.GetString(Photos)));
            cmd.Parameters.Add(new MySqlParameter("@vPhotosdate", Util.GetDateTime(Photosdate)));
            cmd.Parameters.Add(new MySqlParameter("@vOpresearch", Util.GetString(Opresearch)));
            cmd.Parameters.Add(new MySqlParameter("@vOpcompleted", Util.GetString(Opcompleted)));
            cmd.Parameters.Add(new MySqlParameter("@vFiberop", Util.GetString(Fiberop)));
            cmd.Parameters.Add(new MySqlParameter("@vWakeup1", Util.GetString(Wakeup1)));
            cmd.Parameters.Add(new MySqlParameter("@vWakeup2", Util.GetString(Wakeup2)));
            cmd.Parameters.Add(new MySqlParameter("@vSpinal", Util.GetString(Spinal)));
            cmd.Parameters.Add(new MySqlParameter("@vAllograft", Util.GetString(Allograft)));
            cmd.Parameters.Add(new MySqlParameter("@vCrouton", Util.GetString(Crouton)));
            cmd.Parameters.Add(new MySqlParameter("@vTricortocal", Util.GetString(Tricortocal)));
            cmd.Parameters.Add(new MySqlParameter("@vVitoss", Util.GetString(Vitoss)));
            cmd.Parameters.Add(new MySqlParameter("@vCrushed", Util.GetString(Crushed)));
            cmd.Parameters.Add(new MySqlParameter("@vAllograftother", Util.GetString(Allograftother)));
            cmd.Parameters.Add(new MySqlParameter("@vCell", Util.GetString(Cell)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOR1", Util.GetInt(IsOR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOR2", Util.GetInt(IsOR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsLocal", Util.GetInt(IsLocal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRegional", Util.GetInt(IsRegional)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSpinal", Util.GetInt(IsSpinal)));
            cmd.Parameters.Add(new MySqlParameter("@vIsGeneral", Util.GetInt(IsGeneral)));
            cmd.Parameters.Add(new MySqlParameter("@vPulmonaryFunction", Util.GetString(PulmonaryFunction)));
            cmd.Parameters.Add(new MySqlParameter("@vEchocardiogram", Util.GetString(Echocardiogram)));
            cmd.Parameters.Add(new MySqlParameter("@vPrediatricSurgeon", Util.GetString(PrediatricSurgeon)));
            cmd.Parameters.Add(new MySqlParameter("@vNeurologyConsult", Util.GetString(NeurologyConsult)));
            cmd.Parameters.Add(new MySqlParameter("@vPediatricMedical", Util.GetString(PediatricMedical)));
            cmd.Parameters.Add(new MySqlParameter("@vPulmonary", Util.GetString(Pulmonary)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherorders", Util.GetString(Otherorders)));
            cmd.Parameters.Add(new MySqlParameter("@vInstruments", Util.GetString(Instruments)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
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


    public string Delete()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_surgery_estimate_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vPatient_surgery_ID", Patient_surgery_ID));

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
