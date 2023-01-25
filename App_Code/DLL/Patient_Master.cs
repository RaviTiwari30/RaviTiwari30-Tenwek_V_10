#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
#endregion All Namespaces


public class Patient_Master
{
    #region All Memory Variables
    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _PatientID;
    private string _Title;
    private string _PName;
    private string _PFirstName;
    private string _PLastName;
    private string _House_No;
    private string _Street_Name;
    private string _Locality;
    private string _City;
    private string _PinCode;
    private string _Phone;
    private string _Mobile;
    private string _Email;
    private System.DateTime _DOB;
    private string _Age;
    private string _Relation;
    private string _RelationName;
    private System.DateTime _TimeOfBirth;
    private string _PlaceOfBirth;
    private string _IdentificationMark;
    private string _BloodGroup;
    private string _EmergencyPhone;
    private string _Gender;
    private string _MaritalStatus;
    private System.DateTime _DateEnrolled;
    private decimal _FeesPaid;
    private string _HospitalOfEnroll_ID;
    private System.DateTime _ExtractDate;
    private int _Active;
    private string _UserName;
    private string _Password;
    private string _CardPaid;
    private string _Weight;
    private string _State;
    private string _Country;
    private string _Passport_No;
    private System.DateTime _Passport_IssueDate;
    private string _Patient_Category;
    private string _Remark;


    private string _ResidentialAddress;
    private string _ReligiousAffiliation;
    private string _LanguageSpoken;
    private string _Occupation;
    private string _Employer;
    private string _EmergencyNotify;
    private string _EmergencyRelationShip;
    private string _EmergencyAddress;
    private string _EmergencyPhoneNo;
    private string _registerBy;
    private string _PatientType;
    private string _Ethnicity;
    private int _Card_ID;
    private string _App_ID;
    private string _Taluka;
    private string _LandMark;
    private string _Place;
    private string _District;
    private int _PanelID;
    private string _LastUpdatedBy;
    private System.DateTime _Updatedate;
    private string _AdharCardNo;

    private int _CentreID;
    private string _Hospital_ID;
    private string _IPAddress;
    private int _CountryID;
    private int _DistrictID;
    private int _CityID;
    private int _TalukaID;
    private string _HospPatientType;
    private int _IsNewPatient;
    private string _OldPatientID;
    private int _StateID;
    private string _base64PatientProfilePic;
    private string _isCapTure;
    [System.ComponentModel.DefaultValue(0)]
    private int _IsRegistrationApply;
    private int _PatientType_ID;
    private string _Source;
    private List<IDProof> _PatientIDProofs;
    private string _Religion;

    private int _IsInternational;
    private string _OverSeaNumber;
    private int _IsTranslatorRequired;
    private string _FacialStatus;
    private string _Race;
    private string _Employement;
    private string _ParmanentAddress;
    private string _IdentificationMarkSecond;
    private decimal _MonthlyIncome;
    private string _EthenicGroup;
    private string _EmergencyRelationOf;
    private string _EmergencyRelationName;
    private string _StaffDependantID;//
    private string _PMiddleName;
    private string _PurposeOfVisit;
    private int _PurposeOfVisitID;
    private int _PRequestDept;
    private string _SecondMobileNo;
	private string _LastFamilyUHIDNumber;
    
    
    [System.ComponentModel.DefaultValue(0)]
    private int _IsUpdate;


    private string _PhoneSTDCODE;

    public string PhoneSTDCODE
    {
        get { return _PhoneSTDCODE; }
        set { _PhoneSTDCODE = value; }
    }

    private string  _ResidentialNumber;

    public string  ResidentialNumber
    {
        get { return _ResidentialNumber; }
        set { _ResidentialNumber = value; }
    }

    private string  _ResidentialNumberSTDCODE;

    public string  ResidentialNumberSTDCODE
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




    

    public int IsUpdate
    {
        get { return _IsUpdate; }
        set { _IsUpdate = value; }
    }



   


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Patient_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Patient_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property

    public virtual string StaffDependantID
    {
        get { return _StaffDependantID; }
        set { _StaffDependantID = value; }
    }
    public virtual string Location
    {

        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }
    public virtual string HospCode
    {

        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
        }
    }


    public virtual int ID
    {

        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }



    public virtual string PatientID
    {
        get
        {
            return _PatientID;
        }
        set
        {
            _PatientID = value;
        }
    }
    public virtual string Title
    {
        get
        {
            return _Title;
        }
        set
        {
            _Title = value;
        }
    }

    public virtual string PName
    {
        get
        {
            return _PName;
        }
        set
        {
            _PName = value;
        }
    }
    public virtual string PFirstName
    {
        get
        {
            return _PFirstName;
        }
        set
        {
            _PFirstName = value;
        }
    }
    public virtual string PLastName
    {
        get
        {
            return _PLastName;
        }
        set
        {
            _PLastName = value;
        }
    }
    public virtual string House_No
    {
        get
        {
            return _House_No;
        }
        set
        {
            _House_No = value;
        }
    }
    public virtual string Street_Name
    {
        get
        {
            return _Street_Name;
        }
        set
        {
            _Street_Name = value;
        }
    }
    public virtual string Locality
    {
        get
        {
            return _Locality;
        }
        set
        {
            _Locality = value;
        }
    }
    public virtual string City
    {
        get
        {
            return _City;
        }
        set
        {
            _City = value;
        }
    }
    public virtual string PinCode
    {
        get
        {
            return _PinCode;
        }
        set
        {
            _PinCode = value;
        }
    }

    public virtual string Phone
    {
        get
        {
            return _Phone;
        }
        set
        {
            _Phone = value;
        }
    }
    public virtual string Mobile
    {
        get
        {
            return _Mobile;
        }
        set
        {
            _Mobile = value;
        }
    }
    public virtual string Email
    {
        get
        {
            return _Email;
        }
        set
        {
            _Email = value;
        }
    }
    public virtual System.DateTime DOB
    {
        get
        {
            return _DOB;
        }
        set
        {
            _DOB = value;
        }
    }
    public virtual string Age
    {
        get
        {
            return _Age;
        }
        set
        {
            _Age = value;
        }
    }
    public virtual string Relation
    {
        get
        {
            return _Relation;
        }
        set
        {
            _Relation = value;
        }
    }
    public virtual string RelationName
    {
        get
        {
            return _RelationName;
        }
        set
        {
            _RelationName = value;
        }
    }
    public virtual System.DateTime TimeOfBirth
    {
        get
        {
            return _TimeOfBirth;
        }
        set
        {
            _TimeOfBirth = value;
        }
    }
    public virtual string PlaceOfBirth
    {
        get
        {
            return _PlaceOfBirth;
        }
        set
        {
            _PlaceOfBirth = value;
        }
    }
    public virtual string IdentificationMark
    {
        get
        {
            return _IdentificationMark;
        }
        set
        {
            _IdentificationMark = value;
        }
    }
    public virtual string BloodGroup
    {
        get
        {
            return _BloodGroup;
        }
        set
        {
            _BloodGroup = value;
        }
    }
    public virtual string EmergencyPhone
    {
        get
        {
            return _EmergencyPhone;
        }
        set
        {
            _EmergencyPhone = value;
        }
    }
    public virtual string Gender
    {
        get
        {
            return _Gender;
        }
        set
        {
            _Gender = value;
        }
    }
    public virtual string MaritalStatus
    {
        get
        {
            return _MaritalStatus;
        }
        set
        {
            _MaritalStatus = value;
        }
    }

    public virtual System.DateTime DateEnrolled
    {
        get
        {
            return _DateEnrolled;
        }
        set
        {
            _DateEnrolled = value;
        }
    }
    public virtual decimal FeesPaid
    {
        get
        {
            return _FeesPaid;
        }
        set
        {
            _FeesPaid = value;
        }
    }
    public virtual string HospitalOfEnroll_ID
    {
        get
        {
            return _HospitalOfEnroll_ID;
        }
        set
        {
            _HospitalOfEnroll_ID = value;
        }
    }
    public virtual System.DateTime ExtractDate
    {
        get
        {
            return _ExtractDate;
        }
        set
        {
            _ExtractDate = value;
        }
    }


    public virtual int Active
    {
        get
        {
            return _Active;
        }
        set
        {
            _Active = value;
        }
    }
    public virtual string UserName
    {
        get
        {
            return _UserName;
        }
        set
        {
            _UserName = value;
        }
    }
    public virtual string Password
    {
        get
        {
            return _Password;
        }
        set
        {
            _Password = value;
        }
    }

    public virtual string CardPaid
    {
        get
        {
            return _CardPaid;
        }
        set
        {
            _CardPaid = value;
        }
    }
    public virtual string State
    {
        get
        {
            return _State;
        }
        set
        {
            _State = value;
        }
    }
    public virtual string Country
    {
        get
        {
            return _Country;
        }
        set
        {
            _Country = value;
        }
    }
    public virtual string Passport_No
    {
        get
        {
            return _Passport_No;
        }
        set
        {
            _Passport_No = value;
        }
    }
    public virtual System.DateTime Passport_IssueDate
    {
        get
        {
            return _Passport_IssueDate;
        }
        set
        {
            _Passport_IssueDate = value;
        }
    }
    public virtual string Patient_Category
    {
        get
        {
            return _Patient_Category;
        }
        set
        {
            _Patient_Category = value;
        }
    }
    public virtual string Remark
    {
        get
        {
            return _Remark;
        }
        set
        {
            _Remark = value;
        }
    }


    public virtual string Weight
    {

        get
        {
            return _Weight;
        }
        set
        {
            _Weight = value;
        }
    }


    public virtual string ResidentialAddress
    {
        get
        {
            return _ResidentialAddress;
        }
        set
        {
            _ResidentialAddress = value;
        }
    }
    public virtual string ReligiousAffiliation
    {
        get
        {
            return _ReligiousAffiliation;
        }
        set
        {
            _ReligiousAffiliation = value;
        }
    }
    public virtual string LanguageSpoken
    {
        get
        {
            return _LanguageSpoken;
        }
        set
        {
            _LanguageSpoken = value;
        }
    }
    public virtual string Occupation
    {
        get
        {
            return _Occupation;
        }
        set
        {
            _Occupation = value;
        }
    }
    public virtual string Employer
    {
        get
        {
            return _Employer;
        }
        set
        {
            _Employer = value;
        }
    }
    public virtual string EmergencyNotify
    {
        get
        {
            return _EmergencyNotify;
        }
        set
        {
            _EmergencyNotify = value;
        }
    }
    public virtual string EmergencyRelationShip
    {
        get
        {
            return _EmergencyRelationShip;
        }
        set
        {
            _EmergencyRelationShip = value;
        }
    }
    public virtual string EmergencyAddress
    {
        get
        {
            return _EmergencyAddress;
        }
        set
        {
            _EmergencyAddress = value;
        }
    }
    public virtual string EmergencyRelationOf
    {
        get
        {
            return _EmergencyRelationOf;
        }
        set
        {
            _EmergencyRelationOf = value;
        }
    }
    public virtual string EmergencyRelationName
    {
        get
        {
            return _EmergencyRelationName;
        }
        set
        {
            _EmergencyRelationName = value;
        }
    }
    public virtual string EmergencyPhoneNo
    {
        get
        {
            return _EmergencyPhoneNo;
        }
        set
        {
            _EmergencyPhoneNo = value;
        }
    }
    public virtual string RegisterBy
    {
        get
        {
            return _registerBy;
        }
        set
        {
            _registerBy = value;
        }
    }

    public virtual string PatientType
    {
        get
        {
            return _PatientType;
        }
        set
        {
            _PatientType = value;
        }
    }
    public virtual string Ethnicity
    {
        get
        {
            return _Ethnicity;
        }
        set
        {
            _Ethnicity = value;
        }
    }
    public virtual int Card_ID
    {
        get
        {
            return _Card_ID;
        }
        set
        {
            _Card_ID = value;
        }
    }
    public virtual string App_ID
    {
        get
        {
            return _App_ID;
        }
        set
        {
            _App_ID = value;
        }

    }
    public virtual string Taluka
    {
        get
        {
            return _Taluka;
        }
        set
        {
            _Taluka = value;
        }
    }
    public virtual string LandMark
    {
        get { return _LandMark; }
        set { _LandMark = value; }
    }
    public virtual string Place
    {
        get { return _Place; }
        set { _Place = value; }

    }
    public virtual string District
    {
        get { return _District; }
        set { _District = value; }
    }
    public virtual int PanelID
    {
        get { return _PanelID; }
        set { _PanelID = value; }
    }
    public virtual string LastUpdatedBy
    {
        get { return _LastUpdatedBy; }
        set { _LastUpdatedBy = value; }
    }
    public virtual System.DateTime Updatedate
    {
        get
        {
            return _Updatedate;
        }
        set
        {
            _Updatedate = value;
        }
    }
    public virtual string AdharCardNo
    {
        get
        {
            return _AdharCardNo;
        }
        set
        {
            _AdharCardNo = value;
        }
    }
    public virtual int CentreID
    {
        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
        }
    }
    public virtual string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
        }
    }
    public virtual string IPAddress
    {
        get
        {
            return _IPAddress;
        }
        set
        {
            _IPAddress = value;
        }
    }
    public virtual int CountryID { get { return _CountryID; } set { _CountryID = value; } }
    public virtual int DistrictID { get { return _DistrictID; } set { _DistrictID = value; } }
    public virtual int CityID { get { return _CityID; } set { _CityID = value; } }
    public virtual int TalukaID { get { return _TalukaID; } set { _TalukaID = value; } }
    public virtual string HospPatientType { get { return _HospPatientType; } set { _HospPatientType = value; } }
    public virtual int IsNewPatient { get { return _IsNewPatient; } set { _IsNewPatient = value; } }
    public virtual string OldPatientID { get { return _OldPatientID; } set { _OldPatientID = value; } }
    public virtual int StateID { get { return _StateID; } set { _StateID = value; } }
    public virtual string base64PatientProfilePic { get { return _base64PatientProfilePic; } set { _base64PatientProfilePic = value; } }
    public virtual string isCapTure { get { return _isCapTure; } set { _isCapTure = value; } }
    public virtual int IsRegistrationApply { get { return _IsRegistrationApply; } set { _IsRegistrationApply = value; } }
    public virtual int PatientType_ID { get { return _PatientType_ID; } set { _PatientType_ID = value; } }
    public virtual string Source { get { return _Source; } set { _Source = value; } }
    public virtual List<IDProof> PatientIDProofs { get { return _PatientIDProofs; } set { _PatientIDProofs = value; } }
    public virtual string Religion { get { return _Religion; } set { _Religion = value; } }




    public string EthenicGroup
    {
        get { return _EthenicGroup; }
        set { _EthenicGroup = value; }
    }


    public virtual int IsInternational { get { return _IsInternational; } set { _IsInternational = value; } }
    public virtual string OverSeaNumber { get { return _OverSeaNumber; } set { _OverSeaNumber = value; } }
    public virtual int IsTranslatorRequired { get { return _IsTranslatorRequired; } set { _IsTranslatorRequired = value; } }
    public virtual string FacialStatus { get { return _FacialStatus; } set { _FacialStatus = value; } }
    public virtual string Race { get { return _Race; } set { _Race = value; } }
    public virtual string Employement { get { return _Employement; } set { _Employement = value; } }
    public virtual string ParmanentAddress { get { return _ParmanentAddress; } set { _ParmanentAddress = value; } }
    public virtual string IdentificationMarkSecond { get { return _IdentificationMarkSecond; } set { _IdentificationMarkSecond = value; } }
    public virtual decimal MonthlyIncome { get { return _MonthlyIncome; } set { _MonthlyIncome = value; } }
    public virtual string PMiddleName { get { return _PMiddleName; } set { _PMiddleName = value; } }
    public virtual string PurposeOfVisit { get { return _PurposeOfVisit; } set { _PurposeOfVisit = value; } }
    public virtual int PurposeOfVisitID { get { return _PurposeOfVisitID; } set { _PurposeOfVisitID = value; } }
    public virtual int PRequestDept { get { return _PRequestDept; } set { _PRequestDept = value; } }
    public virtual string SecondMobileNo { get { return _SecondMobileNo; } set { _SecondMobileNo = value; } }

	public virtual string LastFamilyUHIDNumber
    {
        get { return _LastFamilyUHIDNumber; }
        set { _LastFamilyUHIDNumber = value; }
    }

  




    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_patient");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PatientID";
            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.Location = AllGlobalFunction.Location;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString("SHHI");
            this.ID = Util.GetInt(ID);
            this.Title = Util.GetString(Title);
            this.PName = Util.GetString(PName);
            this.PFirstName = Util.GetString(PFirstName);
            this.PLastName = Util.GetString(PLastName);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.City = Util.GetString(City);
            this.PinCode = Util.GetString(PinCode);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.Email = Util.GetString(Email);
            this.DOB = Util.GetDateTime(DOB.ToString("yyyy-MM-dd"));
            this.Age = Util.GetString(Age);
            this.Relation = Util.GetString(Relation);
            this.RelationName = Util.GetString(RelationName);
            this.TimeOfBirth = Util.GetDateTime(TimeOfBirth);
            this.PlaceOfBirth = Util.GetString(PlaceOfBirth);
            this.IdentificationMark = Util.GetString(IdentificationMark);
            this.BloodGroup = Util.GetString(BloodGroup);
            this.EmergencyPhone = Util.GetString(EmergencyPhone);
            this.Gender = Util.GetString(Gender);
            this.MaritalStatus = Util.GetString(MaritalStatus);
            this.DateEnrolled = Util.GetDateTime(DateEnrolled);
            this.FeesPaid = Util.GetLong(FeesPaid);
            this.HospitalOfEnroll_ID = Util.GetString(HospitalOfEnroll_ID);
            this.ExtractDate = Util.GetDateTime(ExtractDate);
            this.Active = Util.GetInt(Active);
            this.UserName = Util.GetString(UserName);
            this.Password = Util.GetString(Password);
            this.CardPaid = Util.GetString(CardPaid);
            this.State = Util.GetString(State);
            this.Country = Util.GetString(Country);
            this.Passport_No = Util.GetString(Passport_No);
            this.Passport_IssueDate = Util.GetDateTime(Passport_IssueDate);
            this.Patient_Category = Util.GetString(Patient_Category);
            this.Remark = Util.GetString(Remark);
            this.Weight = Util.GetString(Weight);
            this.ResidentialAddress = Util.GetString(ResidentialAddress);
            this.ReligiousAffiliation = Util.GetString(ReligiousAffiliation);
            this.LanguageSpoken = Util.GetString(LanguageSpoken);
            this.Occupation = Util.GetString(Occupation);
            this.Employer = Util.GetString(Employer);
            this.EmergencyNotify = Util.GetString(EmergencyNotify);
            this.EmergencyRelationShip = Util.GetString(EmergencyRelationShip);
            this.EmergencyAddress = Util.GetString(EmergencyAddress);
            this.EmergencyPhoneNo = Util.GetString(EmergencyPhoneNo);
            this.RegisterBy = Util.GetString(RegisterBy);
            this.PatientType = Util.GetString(PatientType);
            this.Ethnicity = Util.GetString(Ethnicity);
            this.Card_ID = Util.GetInt(Card_ID);
            this.Place = Util.GetString(Place);
            this.Taluka = Util.GetString(Taluka);
            this.LandMark = Util.GetString(LandMark);
            this.District = Util.GetString(District);
            this.PanelID = Util.GetInt(PanelID);
            this.AdharCardNo = Util.GetString(AdharCardNo);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.IPAddress = Util.GetString(IPAddress);
            this.CountryID = Util.GetInt(CountryID);
            this.DistrictID = Util.GetInt(DistrictID);
            this.CityID = Util.GetInt(CityID);
            this.TalukaID = Util.GetInt(TalukaID);
            this.HospPatientType = Util.GetString(HospPatientType);
            this.OldPatientID = Util.GetString(OldPatientID);
            this.StateID = Util.GetInt(StateID);
            this.IsRegistrationApply = Util.GetInt(IsRegistrationApply);
            this.Source = Util.GetString(Source);
            this.Religion = Util.GetString(Religion);
            this.IsInternational = Util.GetInt(IsInternational);
            this.OverSeaNumber = Util.GetString(OverSeaNumber);
            this.IsTranslatorRequired = Util.GetInt(IsTranslatorRequired);
            this.FacialStatus = Util.GetString(FacialStatus);
            this.Race = Util.GetString(Race);
            this.Employement = Util.GetString(Employement);
            this.ParmanentAddress = Util.GetString(ParmanentAddress);
            this.IdentificationMarkSecond = Util.GetString(IdentificationMarkSecond);
            this.MonthlyIncome = Util.GetDecimal(MonthlyIncome);
            this.EmergencyRelationOf = Util.GetString(EmergencyRelationOf);
            this.EmergencyRelationShip = Util.GetString(EmergencyRelationName);
            this.EthenicGroup = Util.GetString(EthenicGroup);
            this.StaffDependantID = Util.GetString(StaffDependantID);
            this.PMiddleName = Util.GetString(PMiddleName);
            this.PurposeOfVisit = Util.GetString(PurposeOfVisit);
            this.PurposeOfVisitID = Util.GetInt(PurposeOfVisitID);
            this.PRequestDept = Util.GetInt(PRequestDept);
            this.SecondMobileNo = Util.GetString(SecondMobileNo);
			 this.LastFamilyUHIDNumber = Util.GetString(LastFamilyUHIDNumber);
             

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@Pname", PName));
            cmd.Parameters.Add(new MySqlParameter("@PFirstName", PFirstName));
            cmd.Parameters.Add(new MySqlParameter("@PLastName", PLastName));
            cmd.Parameters.Add(new MySqlParameter("@House_No", House_No));
            cmd.Parameters.Add(new MySqlParameter("@Street_Name", Street_Name));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Locality));
            cmd.Parameters.Add(new MySqlParameter("@City", City));
            cmd.Parameters.Add(new MySqlParameter("@Pincode", PinCode));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Phone));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@DOB", DOB));
            cmd.Parameters.Add(new MySqlParameter("@Age", Age));
            cmd.Parameters.Add(new MySqlParameter("@Relation", Relation));
            cmd.Parameters.Add(new MySqlParameter("@RelationName", RelationName));
            cmd.Parameters.Add(new MySqlParameter("@TimeOfBirth", TimeOfBirth));
            cmd.Parameters.Add(new MySqlParameter("@PlaceOfBirth", PlaceOfBirth));
            cmd.Parameters.Add(new MySqlParameter("@IdentificationMark", IdentificationMark));
            cmd.Parameters.Add(new MySqlParameter("@BloodGroup", BloodGroup));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyPhone", EmergencyPhone));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@MaritalStatus", MaritalStatus));
            cmd.Parameters.Add(new MySqlParameter("@DateEnrolled", DateEnrolled));
            cmd.Parameters.Add(new MySqlParameter("@FeesPaid", FeesPaid));
            cmd.Parameters.Add(new MySqlParameter("@HospitalOfEnroll_ID", HospitalOfEnroll_ID));
            cmd.Parameters.Add(new MySqlParameter("@ExtractDate", ExtractDate));
            cmd.Parameters.Add(new MySqlParameter("@Active", Active));
            cmd.Parameters.Add(new MySqlParameter("@UserName", UserName));
            cmd.Parameters.Add(new MySqlParameter("@PASSWORD", Password));
            cmd.Parameters.Add(new MySqlParameter("@CardPaid", CardPaid));
            cmd.Parameters.Add(new MySqlParameter("@State", State));
            cmd.Parameters.Add(new MySqlParameter("@Country", Country));
            cmd.Parameters.Add(new MySqlParameter("@Passport_No", Passport_No));
            cmd.Parameters.Add(new MySqlParameter("@Passport_IssueDate", Passport_IssueDate));
            cmd.Parameters.Add(new MySqlParameter("@Patient_Category", Patient_Category));
            cmd.Parameters.Add(new MySqlParameter("@Remark", Remark));
            cmd.Parameters.Add(new MySqlParameter("@Weight", Weight));
            cmd.Parameters.Add(new MySqlParameter("@ResidentialAddress", ResidentialAddress));
            cmd.Parameters.Add(new MySqlParameter("@ReligiousAffiliation", ReligiousAffiliation));
            cmd.Parameters.Add(new MySqlParameter("@LanguageSpoken", LanguageSpoken));
            cmd.Parameters.Add(new MySqlParameter("@Occupation", Occupation));
            cmd.Parameters.Add(new MySqlParameter("@Employer", Employer));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyNotify", EmergencyNotify));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyRelationOf", EmergencyRelationOf));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyRelationShip", EmergencyRelationShip));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyAddress", EmergencyAddress));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyPhoneNo", EmergencyPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@RegisterBy", RegisterBy));
            if (PatientType == "")
                //1 for General Patient 2 for walk-in patient
                PatientType = "1";
            cmd.Parameters.Add(new MySqlParameter("@PatientType", PatientType));

            cmd.Parameters.Add(new MySqlParameter("@Ethnicity", Ethnicity));
            cmd.Parameters.Add(new MySqlParameter("@Card_ID", Card_ID));
            cmd.Parameters.Add(new MySqlParameter("@Place", Place));
            cmd.Parameters.Add(new MySqlParameter("@Taluka", Taluka));
            cmd.Parameters.Add(new MySqlParameter("@LandMark", LandMark));
            cmd.Parameters.Add(new MySqlParameter("@District", District));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
            cmd.Parameters.Add(new MySqlParameter("@AdharCardNo", AdharCardNo));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));

            cmd.Parameters.Add(new MySqlParameter("@CountryID", CountryID));
            cmd.Parameters.Add(new MySqlParameter("@DistrictID", DistrictID));
            cmd.Parameters.Add(new MySqlParameter("@CityID", CityID));
            cmd.Parameters.Add(new MySqlParameter("@TalukaID", TalukaID));
            cmd.Parameters.Add(new MySqlParameter("@HospPatientType", HospPatientType));
            cmd.Parameters.Add(new MySqlParameter("@OldPatientID", OldPatientID));
            cmd.Parameters.Add(new MySqlParameter("@StateID", StateID));
            cmd.Parameters.Add(new MySqlParameter("@IsRegistrationApply", IsRegistrationApply));
            cmd.Parameters.Add(new MySqlParameter("@Source", Source));
            cmd.Parameters.Add(new MySqlParameter("@Religion", Religion));
            cmd.Parameters.Add(new MySqlParameter("@IsInternational", IsInternational));
            cmd.Parameters.Add(new MySqlParameter("@OverSeaNumber", OverSeaNumber));
            cmd.Parameters.Add(new MySqlParameter("@IsTranslatorRequired", IsTranslatorRequired));
            cmd.Parameters.Add(new MySqlParameter("@FacialStatus", FacialStatus));
            cmd.Parameters.Add(new MySqlParameter("@Race", Race));
            cmd.Parameters.Add(new MySqlParameter("@Employement", Employement));
            cmd.Parameters.Add(new MySqlParameter("@ParmanentAddress", ParmanentAddress));
            cmd.Parameters.Add(new MySqlParameter("@IdentificationMarkSecond", IdentificationMarkSecond));
            cmd.Parameters.Add(new MySqlParameter("@MonthlyIncome", MonthlyIncome));
            cmd.Parameters.Add(new MySqlParameter("@EthenicGroup", EthenicGroup));


            cmd.Parameters.Add(new MySqlParameter("@Phone_STDCODE", PhoneSTDCODE));
            cmd.Parameters.Add(new MySqlParameter("@ResidentialNumber", ResidentialNumber));
            cmd.Parameters.Add(new MySqlParameter("@ResidentialNumber_STDCODE", ResidentialNumberSTDCODE));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyFirstName", EmergencyFirstName));
            cmd.Parameters.Add(new MySqlParameter("@EmergencySecondName", EmergencySecondName));
            cmd.Parameters.Add(new MySqlParameter("@InternationalCountryID", InternationalCountryID));
            cmd.Parameters.Add(new MySqlParameter("@InternationalCountry", InternationalCountry));
            cmd.Parameters.Add(new MySqlParameter("@InternationalNumber", InternationalNumber));
            cmd.Parameters.Add(new MySqlParameter("@StaffDependantID", StaffDependantID));
            cmd.Parameters.Add(new MySqlParameter("@PMiddleName", PMiddleName));
            cmd.Parameters.Add(new MySqlParameter("@PurposeOfVisit", PurposeOfVisit));
            cmd.Parameters.Add(new MySqlParameter("@PurposeOfVisitID", PurposeOfVisitID));
            cmd.Parameters.Add(new MySqlParameter("@PRequestDept", PRequestDept));
            cmd.Parameters.Add(new MySqlParameter("@SecondMobileNo", SecondMobileNo));
			cmd.Parameters.Add(new MySqlParameter("@vLastFamilyUHIDNumber", LastFamilyUHIDNumber));
            


            cmd.Parameters.Add(paramTnxID);


            PatientID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PatientID.ToString();
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


    public int Update()
    {
        try
        {

            this.Title = Util.GetString(Title);

            this.PFirstName = Util.GetString(PFirstName);
            this.PLastName = Util.GetString(PLastName);
            this.PName = Util.GetString(PName);
            this.Age = Util.GetString(Age);
            this.DOB = Util.GetDateTime(DOB);
            this.Gender = Util.GetString(Gender);
            this.Mobile = Util.GetString(Mobile);
            this.Email = Util.GetString(Email);
            this.Relation = Util.GetString(Relation);
            this.RelationName = Util.GetString(RelationName);
            this.House_No = Util.GetString(House_No);
            this.Country = Util.GetString(Country);
            this.City = Util.GetString(City);
            this.HospPatientType = Util.GetString(HospPatientType);
            this.Taluka = Util.GetString(Taluka);
            this.LandMark = Util.GetString(LandMark);
            this.Place = Util.GetString(Place);
            this.District = Util.GetString(District);
            this.Locality = Util.GetString(Locality);
            this.PinCode = Util.GetString(PinCode);
            this.Occupation = Util.GetString(Occupation);
            this.MaritalStatus = Util.GetString(MaritalStatus);
            this.AdharCardNo = Util.GetString(AdharCardNo);
            this.CountryID = Util.GetInt(CountryID);
            this.DistrictID = Util.GetInt(DistrictID);
            this.CityID = Util.GetInt(CityID);
            this.TalukaID = Util.GetInt(TalukaID);
            this.PatientType = Util.GetString(PatientType);
            this.LastUpdatedBy = Util.GetString(LastUpdatedBy);
            this.Updatedate = Util.GetDateTime(Updatedate);
            this.EmergencyNotify = Util.GetString(EmergencyNotify);
            this.EmergencyAddress = Util.GetString(EmergencyAddress);
            this.EmergencyRelationShip = Util.GetString(EmergencyRelationShip);
            this.Ethnicity = Util.GetString(Ethnicity);
            this.EmergencyPhone = Util.GetString(EmergencyPhone);
            this.Remark = Util.GetString(Remark);
            this.PlaceOfBirth = Util.GetString(PlaceOfBirth);
            this.StateID = Util.GetInt(StateID);
            this.State = Util.GetString(State);
            this.Source = Util.GetString(Source);
            this.IdentificationMark = Util.GetString(IdentificationMark);

            this.IsInternational = Util.GetInt(IsInternational);
            this.OverSeaNumber = Util.GetString(OverSeaNumber);
            this.IsTranslatorRequired = Util.GetInt(IsTranslatorRequired);
            this.FacialStatus = Util.GetString(FacialStatus);
            this.Race = Util.GetString(Race);
            this.Employement = Util.GetString(Employement);
            this.ParmanentAddress = Util.GetString(ParmanentAddress);
            this.IdentificationMarkSecond = Util.GetString(IdentificationMarkSecond);
            this.MonthlyIncome = Util.GetDecimal(MonthlyIncome);
            this.EmergencyRelationOf = Util.GetString(EmergencyRelationOf);
            this.EmergencyRelationShip = Util.GetString(EmergencyRelationName);
            this.EthenicGroup = Util.GetString(EthenicGroup);
            this.Phone = Util.GetString(Phone);
            this.IsUpdate = Util.GetInt(3);
            //
			this.PanelID = PanelID;
            this.PhoneSTDCODE = PhoneSTDCODE;
            this.ResidentialNumber = ResidentialNumber;
            this.ResidentialNumberSTDCODE = ResidentialNumberSTDCODE;
            this.EmergencyFirstName = EmergencyFirstName;
            this.EmergencySecondName = EmergencySecondName;
            this.InternationalCountryID = InternationalCountryID;
            this.InternationalCountry = InternationalCountry;
            this.InternationalNumber = InternationalNumber;
            this.EmergencyPhoneNo = Util.GetString(EmergencyPhoneNo);
            this.EmergencyAddress = EmergencyAddress;
            this.PMiddleName = PMiddleName;
            this.PurposeOfVisit = PurposeOfVisit;
            this.PurposeOfVisitID = Util.GetInt(PurposeOfVisitID);
            this.PRequestDept = Util.GetInt(PRequestDept);
            this.SecondMobileNo = Util.GetString(SecondMobileNo);
            this.StaffDependantID = Util.GetString(StaffDependantID);
			this.LastFamilyUHIDNumber = Util.GetString(LastFamilyUHIDNumber);
            this.LanguageSpoken = Util.GetString(LanguageSpoken);
            
            //
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            if (this.CardPaid == "1")
            {
                this.HospCode = AllGlobalFunction.HospCode;
                objSQL.Append("call Update_patient( @Title, @PFirstName, @PLastName, @Pname,@age,@DOB, @Gender,@Mobile, @Email, @FatherName, @MotherName, @House_No, ");
                objSQL.Append(" @Country,@City,@HospPatientType,@Taluka,@LandMark,@Place,@District,@Locality,  @Pincode,@Occupation,@MaritalStatus,@AdharCardNo, ");
                objSQL.Append(" @CountryID,@DistrictID,@CityID,@TalukaID,@PatientType,@LastUpdatedBy,@Updatedate,  ");
                objSQL.Append(" @EmergencyNotify,@EmergencyAddress,@EmergencyRelationShip,@Ethnicity,@EmergencyPhone,@Remark,@PlaceOfBirth,@StateID,@State,@Source,@vIsInternational,@vOverSeaNumber,@vIsTranslatorRequired,@vFacialStatus,@vRace,@vEmployement,@vParmanentAddress,@vIdentificationMarkSecond,@vMonthlyIncome,@vEthenicGroup,@vIsUpdate");
                objSQL.Append("  @PID)");
            }
            else
            {
                this.HospCode = AllGlobalFunction.THospCode;
                objSQL.Append("UPDATE patient_master SET phone=@phone,Title=@Title,PFirstName = @PFirstName, PLastName = @PlastName, PName = @Pname,Age=@age,DOB = @DOB,Gender = @Gender,Mobile = @Mobile, Email = @Email,Relation = @FatherName, RelationName = @MotherName,  House_No=@House_No, ");
                objSQL.Append("  Country=@Country,City=@City,HospPatientType=@HospPatientType,Taluka=@Taluka,LandMark=@LandMark,Place=@Place,District=@District,Locality=@Locality, Pincode=@Pincode,Occupation=@Occupation,MaritalStatus = @MaritalStatus,");
                objSQL.Append("  AdharCardNo=@AdharCardNo,CountryID=@CountryID,DistrictID=@DistrictID,CityID=@CityID,TalukaID=@TalukaID,PatientType=@PatientType, ");
                objSQL.Append(" LastUpdatedBy=@LastUpdatedBy,Updatedate=@Updatedate, ");
                objSQL.Append(" EmergencyNotify=@EmergencyNotify,EmergencyAddress=@EmergencyAddress,EmergencyRelationShip=@EmergencyRelationShip,Ethnicity=@Ethnicity,EmergencyPhone=@EmergencyPhone,Remark=@Remark,PlaceOfBirth=@PlaceOfBirth,StateID=@StateID,State=@State,Source=@Source, ");
                objSQL.Append(" IdentificationMark=@vIdentificationMark,IsInternational= @vIsInternational,OverSeaNumber=@vOverSeaNumber,IsTranslatorRequired=@vIsTranslatorRequired,FacialStatus=@vFacialStatus,Race=@vRace,Employement=@vEmployement,ParmanentAddress=@vParmanentAddress,IdentificationMarkSecond=@vIdentificationMarkSecond,MonthlyIncome=@vMonthlyIncome,EthenicGroup=@vEthenicGroup,IsUpdate=@vIsUpdate, ");
                objSQL.Append(" Phone_STDCODE=@PhoneSTDCODE,ResidentialNumber=@ResidentialNumber,ResidentialNumber_STDCODE=@ResidentialNumber_STDCODE,EmergencyFirstName=@EmergencyFirstName,EmergencySecondName=@EmergencySecondName,InternationalCountryID=@InternationalCountryID, ");
                objSQL.Append(" InternationalCountry=@InternationalCountry,InternationalNumber=@InternationalNumber,EmergencyPhoneNo=@EmergencyPhoneNo,EmergencyRelationOf=@EmergencyRelationOf,PanelID=@PanelID,PMiddleName=@PMiddleName,PurposeOfVisit=@PurposeOfVisit,PurposeOfVisitID=@PurposeOfVisitID,PRequestDept=@PRequestDept,SecondMobileNo=@SecondMobileNo,StaffDependantID=@StaffDependantID,LastFamilyUHIDNumber=@vLastFamilyUHIDNumber,LanguageSpoken=@LanguageSpoken ");
                objSQL.Append(" WHERE PatientID = @PID ");
            }

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


                new MySqlParameter("@Title", Title),
                new MySqlParameter("@PFirstName", PFirstName.ToUpper()),
                new MySqlParameter("@PLastName", PLastName.ToUpper()),
                new MySqlParameter("@Pname", PName.ToUpper()),
                new MySqlParameter("@age", Age),
                new MySqlParameter("@DOB", DOB),
                new MySqlParameter("@Gender", Gender),
                new MySqlParameter("@Mobile", Mobile),
                new MySqlParameter("@Email", Email),
                new MySqlParameter("@FatherName", Relation),
                new MySqlParameter("@MotherName", RelationName),
                new MySqlParameter("@House_No", House_No),
                new MySqlParameter("@Country", Country),
                new MySqlParameter("@City", City),
                new MySqlParameter("@HospPatientType", HospPatientType),
                new MySqlParameter("@Taluka", Taluka),
                new MySqlParameter("@LandMark", LandMark),
                new MySqlParameter("@Place", Place),
                new MySqlParameter("@District", District),
                new MySqlParameter("@Locality", Locality),
                new MySqlParameter("@Pincode", PinCode),
                new MySqlParameter("@Occupation", Occupation),
                new MySqlParameter("@MaritalStatus", MaritalStatus),
                new MySqlParameter("@AdharCardNo", AdharCardNo),
                new MySqlParameter("@CountryID", CountryID),
                new MySqlParameter("@DistrictID", DistrictID),
                new MySqlParameter("@CityID", CityID),
                new MySqlParameter("@TalukaID", TalukaID),
                new MySqlParameter("@PatientType", PatientType),
                new MySqlParameter("@LastUpdatedBy", LastUpdatedBy),
                new MySqlParameter("@Updatedate", Updatedate),
                new MySqlParameter("@EmergencyNotify", EmergencyNotify),
                new MySqlParameter("@EmergencyAddress", EmergencyAddress),
                new MySqlParameter("@EmergencyRelationShip", EmergencyRelationShip),
                new MySqlParameter("@Ethnicity", Ethnicity),
                new MySqlParameter("@EmergencyPhone", EmergencyPhone),
                new MySqlParameter("@Remark", Remark),
                new MySqlParameter("@PlaceOfBirth", PlaceOfBirth),
                new MySqlParameter("@State", State),
                new MySqlParameter("@StateID", StateID),
                new MySqlParameter("@Source", Source),
                new MySqlParameter("@vIdentificationMark", IdentificationMark),

                new MySqlParameter("@vIsInternational", IsInternational),
                new MySqlParameter("@vOverSeaNumber", OverSeaNumber),
                new MySqlParameter("@vIsTranslatorRequired", IsTranslatorRequired),
                new MySqlParameter("@vFacialStatus", FacialStatus),
                new MySqlParameter("@vRace", Race),
                new MySqlParameter("@vEmployement", Employement),
                new MySqlParameter("@vParmanentAddress", ParmanentAddress),
                new MySqlParameter("@vIdentificationMarkSecond", IdentificationMarkSecond),
                new MySqlParameter("@vMonthlyIncome", MonthlyIncome),
                new MySqlParameter("@vEthenicGroup", EthenicGroup),
                new MySqlParameter("@phone", Phone),
                new MySqlParameter("@vIsUpdate", IsUpdate),
                new MySqlParameter("@PhoneSTDCODE", PhoneSTDCODE),
                new MySqlParameter("@ResidentialNumber", ResidentialNumber),
                new MySqlParameter("@ResidentialNumber_STDCODE", ResidentialNumberSTDCODE),
                new MySqlParameter("@EmergencyFirstName", EmergencyFirstName),
                new MySqlParameter("@EmergencySecondName", EmergencySecondName),
                new MySqlParameter("@InternationalCountryID", InternationalCountryID),
                new MySqlParameter("@InternationalCountry", InternationalCountry),
                new MySqlParameter("@InternationalNumber", InternationalNumber),
                new MySqlParameter("@EmergencyPhoneNo", EmergencyPhoneNo),
                new MySqlParameter("@EmergencyRelationOf", EmergencyRelationOf),
                new MySqlParameter("@PanelID", PanelID),
                new MySqlParameter("@PMiddleName", PMiddleName.ToUpper()),
                new MySqlParameter("@PurposeOfVisit", PurposeOfVisit.ToUpper()),
                new MySqlParameter("@PurposeOfVisitID", PurposeOfVisitID),
                new MySqlParameter("@PRequestDept", PRequestDept),
                new MySqlParameter("@SecondMobileNo",SecondMobileNo),
                new MySqlParameter("@StaffDependantID",StaffDependantID),
				new MySqlParameter("@vLastFamilyUHIDNumber", LastFamilyUHIDNumber),
                new MySqlParameter("@LanguageSpoken",LanguageSpoken),
                
                new MySqlParameter("@PID", PatientID));


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;

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



    public int Update(string PatientID)
    {
        this.PatientID = Util.GetString(PatientID);
        return this.Update();
    }

    public int Delete(string PatientID)
    {
        this.PatientID = Util.GetString(PatientID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_master WHERE PatientID = PatientID");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("PatientID", PatientID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
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
    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM patient_master WHERE PatientID = ? ";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@PatientID", PatientID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            string sParams = "PatientID=" + this.PatientID.ToString();
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string PatientID)
    {
        this.PatientID = Util.GetString(PatientID);
        return this.Load();
    }
    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {

        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMaster.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMaster.HospCode]);
        this.ID = Util.GetInt(dtTemp.Rows[0][AllTables.DoctorMaster.ID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.PatientID]);
        this.Title = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Title]);
        this.PName = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.PName]);
        this.PFirstName = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.PFirstName]);
        this.PLastName = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.PLastName]);
        this.House_No = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.House_No]);
        this.Street_Name = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Street_Name]);
        this.Locality = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Locality]);
        this.City = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.City]);
        this.PinCode = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.PinCode]);
        this.Phone = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Phone]);
        this.Mobile = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Mobile]);
        this.Email = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Email]);
        this.DOB = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Master.DOB]);
        this.Age = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Age]);
        this.Relation = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Relation]);
        this.RelationName = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.RelationName]);
        this.TimeOfBirth = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Master.TimeOfBirth]);
        this.PlaceOfBirth = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.PlaceOfBirth]);
        this.IdentificationMark = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.IdentificationMark]);
        this.BloodGroup = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.BloodGroup]);
        this.EmergencyPhone = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.EmergencyPhone]);
        this.Gender = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Gender]);
        this.MaritalStatus = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.MaritalStatus]);
        this.DateEnrolled = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Master.DateEnrolled]);
        this.HospitalOfEnroll_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.HospitalOfEnroll_ID]);
        this.ExtractDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Master.ExtractDate]);
        this.Active = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Master.Active]);
        this.CardPaid = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.CardPaid]);
        this.State = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.State]);
        this.Country = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Country]);
        this.Passport_No = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Passport_No]);
        this.Passport_IssueDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Master.Passport_IssueDate]);
        this.Patient_Category = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Patient_Category]);
        this.Remark = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Remark]);
        this.Ethnicity = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Master.Ethnicity]);

    }
    #endregion

}


public class PatientDocuments
{
    public string documentId { get; set; }
    public string name { get; set; }
    public string data { get; set; }
}
