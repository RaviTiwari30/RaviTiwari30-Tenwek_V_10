using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class appointment
{
    public appointment()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public appointment(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables
                private string _EmergencyPhoneNo;
                private string _PlaceOfBirth;
                private string _IdentificationMark;
                private string _IsInternational;
                private string _OverSeaNumber;
                private string _EthenicGroup;
                private string _IsTranslatorRequired;
                private string _FacialStatus;
                private string _Race;
                private string _Employement;
                private string _MonthlyIncome;
                private string _ParmanentAddress;
                private string _IdentificationMarkSecond;
                private string _LanguageSpoken;
                private string _EmergencyRelationOf;
                private string _EmergencyRelationName;

    private int _App_ID;
    private string _Hospital_ID;
    private string _DoctorID;
    private string _PatientID;
    private string _Title;
    private string _Pname;
    private string _PfirstName;
    private string _PlastName;
    private DateTime _DOB;
    private string _Age;
    private int _Temp_Patient_Flag;
    private int _AppNo;
    private DateTime _Time;
    private DateTime _Date;
    private string _TransactionID;

    [System.ComponentModel.DefaultValue("0")]
    private string _LedgerTransactionNo;
    private string _LastUpdatedBy;
    private DateTime _Updatedate;
    private string _IpAddress;
    private string _Sex;
    private string _ContactNo;
    private string _Email;
    private string _VisitType;
    private string _TypeOfApp;
    private string _PatientType;
    private string _Nationality;
    private string _RefDocID;
    private string _PurposeOfVisit;
    private int _PurposeOfVisitID;
    private string _OrderForVisit;
    private string _Notes;
    private string _EntryUserID;
    private DateTime _EntryDate;
    private int _IsConform;
    private int _IsReschedule;
    private int _IsCancel;
    private string _CancelReason;
    private int _PanelID;
    private string _ItemID;
    private decimal _Amount;
    private string _SubCategoryID;
    private string _MaritalStatus;
    private string _City;
    private string _hashCode;
    private DateTime _EndTime;
    private string _Address;
    private string _SelectTime;
    private bool _chkApp;
    private string _Taluka;
    private string _LandMark;
    private string _Place;
    private string _District;
    private string _Locality;
    private string _PinCode;
    private string _Occupation;
    private string _Relation;
    private string _RelationName;
    private DateTime _ConformDate;
    private string _AdharCardNo;
    private int _CentreID;
    private int _CountryID;
    private int _DistrictID;
    private int _CityID;
    private int _TalukaID;
    private int _RateListID;
    private string _ConformBy;
    private int _isNewPatient;

    private string _NextSubcategoryID;
    private DateTime _nextVisitDateMin;
    private DateTime _nextVisitDateMax;
    private int _DocValidityPeriod;
    private DateTime _lastVisitDateMax;
    private int _StateID;
    private string _State;
    private string _RelationContactNo;

    private int _flag;
    private DateTime _AptTime;
    private string _P_Type;
    private string _TokenNo;
    private int _doc_App_ID;
    private int _IsVitalSignOnApp;
    private string _Doctor_Name;
    private int _BookingCentreID;
    private int _ReferenceCodeOPD;
    private int _ScheduleChargeID;


    private string _PhoneSTDCODE;

    public string PhoneSTDCODE
    {
        get { return _PhoneSTDCODE; }
        set { _PhoneSTDCODE = value; }
    }

    private string _ResidentialNumber;

    public string ResidentialNumber
    {
        get { return _ResidentialNumber; }
        set { _ResidentialNumber = value; }
    }

    private string _ResidentialNumberSTDCODE;

    public string ResidentialNumberSTDCODE
    {
        get { return _ResidentialNumberSTDCODE; }
        set { _ResidentialNumberSTDCODE = value; }
    }

    private string _EmergencyFirstName;

    public string EmergencyFirstName
    {
        get { return _EmergencyFirstName; }
        set { _EmergencyFirstName = value; }
    }


    private string _EmergencySecondName;

    public string EmergencySecondName
    {
        get { return _EmergencySecondName; }
        set { _EmergencySecondName = value; }
    }

    private int _InternationalCountryID;

    public int InternationalCountryID
    {
        get { return _InternationalCountryID; }
        set { _InternationalCountryID = value; }
    }

    private string _InternationalCountry;

    public string InternationalCountry
    {
        get { return _InternationalCountry; }
        set { _InternationalCountry = value; }
    }


    private string _InternationalNumber;

    public string InternationalNumber
    {
        get { return _InternationalNumber; }
        set { _InternationalNumber = value; }
    }


    private string _Phone;

    public string Phone
    {
        get { return _Phone; }
        set { _Phone = value; }
    }

    private string _EmergencyAddress;

    public string EmergencyAddress
    {
        get { return _EmergencyAddress; }
        set { _EmergencyAddress = value; }
    }
    


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Set All Property
    public virtual string EmergencyPhoneNo { get { return _EmergencyPhoneNo; } set { _EmergencyPhoneNo = value; } }
    public virtual string PlaceOfBirth { get { return _PlaceOfBirth; } set { _PlaceOfBirth = value; } }
    public virtual string EmergencyRelationName { get { return _EmergencyRelationName; } set { _EmergencyRelationName = value; } }
    public virtual string EmergencyRelationOf { get { return _EmergencyRelationOf; } set { _EmergencyRelationOf = value; } }
    public virtual string LanguageSpoken { get { return _LanguageSpoken; } set { _LanguageSpoken = value; } }
    public virtual string IdentificationMarkSecond { get { return _IdentificationMarkSecond; } set { _IdentificationMarkSecond = value; } }
    public virtual string ParmanentAddress { get { return _ParmanentAddress; } set { _ParmanentAddress = value; } }
    public virtual string MonthlyIncome { get { return _MonthlyIncome; } set { _MonthlyIncome = value; } }
    public virtual string Employement { get { return _Employement; } set { _Employement = value; } }
    public virtual string Race { get { return _Race; } set { _Race = value; } }
    public virtual string FacialStatus { get { return _FacialStatus; } set { _FacialStatus = value; } }
    public virtual string IsTranslatorRequired { get { return _IsTranslatorRequired; } set { _IsTranslatorRequired = value; } }
    public virtual string EthenicGroup { get { return _EthenicGroup; } set { _EthenicGroup = value; } }
    public virtual string OverSeaNumber { get { return _OverSeaNumber; } set { _OverSeaNumber = value; } }
    public virtual string IsInternational { get { return _IsInternational; } set { _IsInternational = value; } }
    public virtual string IdentificationMark { get { return _IdentificationMark; } set { _IdentificationMark = value; } }
    public virtual int App_ID { get { return _App_ID; } set { _App_ID = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string Title { get { return _Title; } set { _Title = value; } }
    public virtual string Pname { get { return _Pname; } set { _Pname = value; } }
    public virtual string PfirstName { get { return _PfirstName; } set { _PfirstName = value; } }
    public virtual string plastName { get { return _PlastName; } set { _PlastName = value; } }
    public virtual DateTime DOB { get { return _DOB; } set { _DOB = value; } }
    public virtual string Age { get { return _Age; } set { _Age = value; } }
    public virtual int Temp_Patient_Flag { get { return _Temp_Patient_Flag; } set { _Temp_Patient_Flag = value; } }
    public virtual int AppNo { get { return _AppNo; } set { _AppNo = value; } }
    public virtual DateTime Time { get { return _Time; } set { _Time = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }

    
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual string LastUpdatedBy { get { return _LastUpdatedBy; } set { _LastUpdatedBy = value; } }
    public virtual DateTime Updatedate { get { return _Updatedate; } set { _Updatedate = value; } }
    public virtual string IpAddress { get { return _IpAddress; } set { _IpAddress = value; } }
    public virtual string Sex { get { return _Sex; } set { _Sex = value; } }
    public virtual string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
    public virtual string Email { get { return _Email; } set { _Email = value; } }
    public virtual string VisitType { get { return _VisitType; } set { _VisitType = value; } }
    public virtual string TypeOfApp { get { return _TypeOfApp; } set { _TypeOfApp = value; } }
    public virtual string PatientType { get { return _PatientType; } set { _PatientType = value; } }
    public virtual string Nationality { get { return _Nationality; } set { _Nationality = value; } }
    public virtual string RefDocID { get { return _RefDocID; } set { _RefDocID = value; } }
    public virtual string PurposeOfVisit { get { return _PurposeOfVisit; } set { _PurposeOfVisit = value; } }
    public virtual int PurposeOfVisitID { get { return _PurposeOfVisitID; } set { _PurposeOfVisitID = value; } }
    public virtual string OrderForVisit { get { return _OrderForVisit; } set { _OrderForVisit = value; } }
    public virtual string Notes { get { return _Notes; } set { _Notes = value; } }
    public virtual string EntryUserID { get { return _EntryUserID; } set { _EntryUserID = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual int IsConform { get { return _IsConform; } set { _IsConform = value; } }
    public virtual int IsReschedule { get { return _IsReschedule; } set { _IsReschedule = value; } }
    public virtual int IsCancel { get { return _IsCancel; } set { _IsCancel = value; } }
    public virtual string CancelReason { get { return _CancelReason; } set { _CancelReason = value; } }
    public virtual decimal Amount { get { return _Amount; } set { _Amount = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string ItemID { get { return _ItemID; } set { _ItemID = value; } }
    public virtual string SubCategoryID { get { return _SubCategoryID; } set { _SubCategoryID = value; } }
    public virtual string MaritalStatus { get { return _MaritalStatus; } set { _MaritalStatus = value; } }
    public virtual string City { get { return _City; } set { _City = value; } }
    public virtual string hashCode { get { return _hashCode; } set { _hashCode = value; } }
    public virtual DateTime EndTime { get { return _EndTime; } set { _EndTime = value; } }
    public virtual string Address { get { return _Address; } set { _Address = value; } }
    public virtual string SelectTime { get { return _SelectTime; } set { _SelectTime = value; } }
    public virtual bool chkApp { get { return _chkApp; } set { _chkApp = value; } }
    public virtual string Taluka { get { return _Taluka; } set { _Taluka = value; } }
    public virtual string LandMark { get { return _LandMark; } set { _LandMark = value; } }
    public virtual string Place { get { return _Place; } set { _Place = value; } }
    public virtual string District { get { return _District; } set { _District = value; } }
    public virtual string Locality { get { return _Locality; } set { _Locality = value; } }
    public virtual string PinCode { get { return _PinCode; } set { _PinCode = value; } }
    public virtual string Occupation { get { return _Occupation; } set { _Occupation = value; } }
    public virtual string Relation { get { return _Relation; } set { _Relation = value; } }
    public virtual string RelationName { get { return _RelationName; } set { _RelationName = value; } }
    public virtual DateTime ConformDate { get { return _ConformDate; } set { _ConformDate = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string AdharCardNo { get { return _AdharCardNo; } set { _AdharCardNo = value; } }
    public virtual int CountryID { get { return _CountryID; } set { _CountryID = value; } }
    public virtual int DistrictID { get { return _DistrictID; } set { _DistrictID = value; } }
    public virtual int CityID { get { return _CityID; } set { _CityID = value; } }
    public virtual int TalukaID { get { return _TalukaID; } set { _TalukaID = value; } }
    public virtual int RateListID { get { return _RateListID; } set { _RateListID = value; } }
    public virtual string ConformBy { get { return _ConformBy; } set { _ConformBy = value; } }
    public virtual int isNewPatient { get { return _isNewPatient; } set { _isNewPatient = value; } }
    public virtual string NextSubcategoryID { get { return _NextSubcategoryID; } set { _NextSubcategoryID = value; } }
    public virtual DateTime nextVisitDateMin { get { return _nextVisitDateMin; } set { _nextVisitDateMin = value; } }
    public virtual DateTime nextVisitDateMax { get { return _nextVisitDateMax; } set { _nextVisitDateMax = value; } }
    public virtual int DocValidityPeriod { get { return _DocValidityPeriod; } set { _DocValidityPeriod = value; } }
    public virtual DateTime lastVisitDateMax { get { return _lastVisitDateMax; } set { _lastVisitDateMax = value; } }
    public virtual int StateID { get { return _StateID; } set { _StateID = value; } }
    public virtual string State { get { return _State; } set { _State = value; } }
    public virtual string RelationContactNo { get { return _RelationContactNo; } set { _RelationContactNo = value; } }
    public virtual int flag { get { return _flag; } set { _flag = value; } }
    public virtual DateTime AptTime { get { return _AptTime; } set { _AptTime = value; } }
    public virtual string P_Type { get { return _P_Type; } set { _P_Type = value; } }
    public virtual string TokenNo { get { return _TokenNo; } set { _TokenNo = value; } }
    public virtual int doc_App_ID { get { return _doc_App_ID; } set { _doc_App_ID = value; } }
    public virtual int IsVitalSignOnApp { get { return _IsVitalSignOnApp; } set { _IsVitalSignOnApp = value; } }
    public virtual string Doctor_Name { get { return _Doctor_Name; } set { _Doctor_Name = value; } }

    public virtual int ReferenceCodeOPD { get { return _ReferenceCodeOPD; } set { _ReferenceCodeOPD = value; } }
    public virtual int ScheduleChargeID { get { return _ScheduleChargeID; } set { _ScheduleChargeID = value; } }
    public virtual int BookingCentreID
    {
        get { return _BookingCentreID; }
        set { _BookingCentreID = value; }
    }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("appointment_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.BookingCentreID = Util.GetInt(System.Web.HttpContext.Current.Session["CentreID"].ToString());
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vTitle", Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@vPname", Util.GetString(Pname)));
            cmd.Parameters.Add(new MySqlParameter("@vPfirstName", Util.GetString(PfirstName)));
            cmd.Parameters.Add(new MySqlParameter("@vPlastName", Util.GetString(plastName)));
            cmd.Parameters.Add(new MySqlParameter("@vDOB", Util.GetDateTime(DOB)));
            cmd.Parameters.Add(new MySqlParameter("@vAge", Util.GetString(Age)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp_Patient_Flag", Util.GetInt(Temp_Patient_Flag)));
            cmd.Parameters.Add(new MySqlParameter("@vAppNo", Util.GetInt(AppNo)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetDateTime(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedBy", Util.GetString(LastUpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedate", Util.GetDateTime(Updatedate)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vSex", Util.GetString(Sex)));
            cmd.Parameters.Add(new MySqlParameter("@vContactNo", Util.GetString(ContactNo)));
            cmd.Parameters.Add(new MySqlParameter("@vEmail", Util.GetString(Email)));
            cmd.Parameters.Add(new MySqlParameter("@vVisitType", Util.GetString(VisitType)));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfApp", Util.GetString(TypeOfApp)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientType", Util.GetString(PatientType)));
            cmd.Parameters.Add(new MySqlParameter("@vNationality", Util.GetString(Nationality)));
            cmd.Parameters.Add(new MySqlParameter("@vRefDocID", Util.GetString(RefDocID)));
            cmd.Parameters.Add(new MySqlParameter("@vPurposeOfVisit", Util.GetString(PurposeOfVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vPurposeOfVisitID", Util.GetInt(PurposeOfVisitID)));
            cmd.Parameters.Add(new MySqlParameter("@vOrderForVisit", Util.GetString(OrderForVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryUserID", Util.GetString(EntryUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsConform", Util.GetInt(IsConform)));
            cmd.Parameters.Add(new MySqlParameter("@vIsReschedule", Util.GetInt(IsReschedule)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCancel", Util.GetInt(IsCancel)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelReason", Util.GetString(CancelReason)));
            cmd.Parameters.Add(new MySqlParameter("@vAmount", Util.GetString(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetString(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", Util.GetString(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@vSubCategoryID", Util.GetString(SubCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@vMaritalStatus", Util.GetString(MaritalStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vCity", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@vhashCode", Util.GetString(_hashCode)));
            cmd.Parameters.Add(new MySqlParameter("@vEndTime", Util.GetDateTime(_EndTime)));
            cmd.Parameters.Add(new MySqlParameter("@vAddress", Util.GetString(_Address)));
            cmd.Parameters.Add(new MySqlParameter("@vPlace", Place));
            cmd.Parameters.Add(new MySqlParameter("@vTaluka", Taluka));
            cmd.Parameters.Add(new MySqlParameter("@vLandMark", LandMark));
            cmd.Parameters.Add(new MySqlParameter("@vDistrict", District));
            cmd.Parameters.Add(new MySqlParameter("@vPinCode", PinCode));
            cmd.Parameters.Add(new MySqlParameter("@vOccupation", Occupation));
            cmd.Parameters.Add(new MySqlParameter("@vRelation", Relation));
            cmd.Parameters.Add(new MySqlParameter("@vRelationName", RelationName));
            cmd.Parameters.Add(new MySqlParameter("@vConformDate", _ConformDate));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vAdharCardNo", AdharCardNo));
            cmd.Parameters.Add(new MySqlParameter("@vCountryID", CountryID));
            cmd.Parameters.Add(new MySqlParameter("@vDistrictID", DistrictID));
            cmd.Parameters.Add(new MySqlParameter("@vCityID", CityID));
            cmd.Parameters.Add(new MySqlParameter("@vTalukaID", TalukaID));
            cmd.Parameters.Add(new MySqlParameter("@vRateListID", RateListID));
            cmd.Parameters.Add(new MySqlParameter("@vConformBy", ConformBy));
            cmd.Parameters.Add(new MySqlParameter("@visNewPatient", isNewPatient));

            cmd.Parameters.Add(new MySqlParameter("@vNextSubcategoryID", NextSubcategoryID));
            cmd.Parameters.Add(new MySqlParameter("@vnextVisitDateMin", nextVisitDateMin));
            cmd.Parameters.Add(new MySqlParameter("@vnextVisitDateMax", nextVisitDateMax));
            cmd.Parameters.Add(new MySqlParameter("@vDocValidityPeriod", DocValidityPeriod));
            cmd.Parameters.Add(new MySqlParameter("@vlastVisitDateMax", lastVisitDateMax));
            cmd.Parameters.Add(new MySqlParameter("@vState", State));
            cmd.Parameters.Add(new MySqlParameter("@vStateID", StateID));
            cmd.Parameters.Add(new MySqlParameter("@vRelationContactNo", RelationContactNo));

            cmd.Parameters.Add(new MySqlParameter("@vflag", flag));
            cmd.Parameters.Add(new MySqlParameter("@vAptTime", AptTime));
            cmd.Parameters.Add(new MySqlParameter("@vP_Type", P_Type));
            cmd.Parameters.Add(new MySqlParameter("@vTokenNo", TokenNo));
            cmd.Parameters.Add(new MySqlParameter("@vdoc_App_ID", doc_App_ID));
            cmd.Parameters.Add(new MySqlParameter("@vIsVitalSignOnApp", IsVitalSignOnApp));
            cmd.Parameters.Add(new MySqlParameter("@vBookingCentreID", BookingCentreID));

            cmd.Parameters.Add(new MySqlParameter("@vEmergencyPhoneNo", EmergencyPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@vIsInternational", IsInternational));
            cmd.Parameters.Add(new MySqlParameter("@vOverSeaNumber", OverSeaNumber));
            cmd.Parameters.Add(new MySqlParameter("@vIsTranslatorRequired", IsTranslatorRequired));
            cmd.Parameters.Add(new MySqlParameter("@vFacialStatus", FacialStatus));
            cmd.Parameters.Add(new MySqlParameter("@vRace", Race));
            cmd.Parameters.Add(new MySqlParameter("@vEmployement", Employement));
            cmd.Parameters.Add(new MySqlParameter("@vParmanentAddress", ParmanentAddress));
            cmd.Parameters.Add(new MySqlParameter("@vIdentificationMarkSecond", IdentificationMarkSecond));
            cmd.Parameters.Add(new MySqlParameter("@vMonthlyIncome", MonthlyIncome));
            cmd.Parameters.Add(new MySqlParameter("@vEthenicGroup", EthenicGroup));
            cmd.Parameters.Add(new MySqlParameter("@vPlaceOfBirth", PlaceOfBirth));
            cmd.Parameters.Add(new MySqlParameter("@vIdentificationMark", IdentificationMark));
            cmd.Parameters.Add(new MySqlParameter("@vLanguageSpoken", LanguageSpoken));
            cmd.Parameters.Add(new MySqlParameter("@vEmergencyRelationOf", EmergencyRelationOf));
            cmd.Parameters.Add(new MySqlParameter("@vEmergencyRelationShip", EmergencyRelationName));


            cmd.Parameters.Add(new MySqlParameter("@Phone_STDCODE", PhoneSTDCODE));
            cmd.Parameters.Add(new MySqlParameter("@ResidentialNumber", ResidentialNumber));
            cmd.Parameters.Add(new MySqlParameter("@ResidentialNumber_STDCODE", ResidentialNumberSTDCODE));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyFirstName", EmergencyFirstName));
            cmd.Parameters.Add(new MySqlParameter("@EmergencySecondName", EmergencySecondName));
            cmd.Parameters.Add(new MySqlParameter("@InternationalCountryID", InternationalCountryID));
            cmd.Parameters.Add(new MySqlParameter("@InternationalCountry", InternationalCountry));
            cmd.Parameters.Add(new MySqlParameter("@InternationalNumber", InternationalNumber));

            cmd.Parameters.Add(new MySqlParameter("@EmergencyAddress", EmergencyAddress));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Phone));

            cmd.Parameters.Add(new MySqlParameter("@vReferenceCodeOPD", ReferenceCodeOPD));
            cmd.Parameters.Add(new MySqlParameter("@vScheduleChargeID", ScheduleChargeID));
            
           
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
            throw (ex);
        }
    }


    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("appointment_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vApp_ID", Util.GetInt(App_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vTitle", Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@vPname", Util.GetString(Pname)));
            cmd.Parameters.Add(new MySqlParameter("@vPfirstName", Util.GetString(PfirstName)));
            cmd.Parameters.Add(new MySqlParameter("@vPlastName", Util.GetString(plastName)));
            cmd.Parameters.Add(new MySqlParameter("@vDOB", Util.GetString(DOB)));
            cmd.Parameters.Add(new MySqlParameter("@vAge", Util.GetString(Age)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp_Patient_Flag", Util.GetInt(Temp_Patient_Flag)));
            cmd.Parameters.Add(new MySqlParameter("@vAppNo", Util.GetInt(AppNo)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetDateTime(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedBy", Util.GetString(LastUpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedate", Util.GetDateTime(Updatedate)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vSex", Util.GetString(Sex)));
            cmd.Parameters.Add(new MySqlParameter("@vContactNo", Util.GetString(ContactNo)));
            cmd.Parameters.Add(new MySqlParameter("@vEmail", Util.GetString(Email)));
            cmd.Parameters.Add(new MySqlParameter("@vVisitType", Util.GetString(VisitType)));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfApp", Util.GetString(TypeOfApp)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientType", Util.GetString(PatientType)));
            cmd.Parameters.Add(new MySqlParameter("@vNationality", Util.GetString(Nationality)));
            cmd.Parameters.Add(new MySqlParameter("@vRefDocID", Util.GetString(RefDocID)));
            cmd.Parameters.Add(new MySqlParameter("@vPurposeOfVisit", Util.GetString(PurposeOfVisit)));

            cmd.Parameters.Add(new MySqlParameter("@vOrderForVisit", Util.GetString(OrderForVisit)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryUserID", Util.GetString(EntryUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsConform", Util.GetInt(IsConform)));
            cmd.Parameters.Add(new MySqlParameter("@vIsReschedule", Util.GetInt(IsReschedule)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCancel", Util.GetInt(IsCancel)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelReason", Util.GetString(CancelReason)));
            cmd.Parameters.Add(new MySqlParameter("@vAmount", Util.GetString(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetString(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", Util.GetString(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@vSubCategoryID", Util.GetString(SubCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@vMaritalStatus", Util.GetString(MaritalStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vCity", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@vhashCode", Util.GetString(_hashCode)));
            cmd.Parameters.Add(new MySqlParameter("@vEndTime", Util.GetDateTime(_EndTime)));
            cmd.Parameters.Add(new MySqlParameter("@vAddress", Util.GetString(_Address)));

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
            throw (ex);
        }
    }


    public string Delete()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("appointment_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vApp_ID", App_ID));

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

    public void UpdateType(string query)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        if (IsLocalConn)
        {
            this.objCon.Open();
            this.objTrans = this.objCon.BeginTransaction();
        }

        using (MySqlCommand cmd = new MySqlCommand(query, con, objTrans))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
            con.Close();
        }
    }

    #endregion

}