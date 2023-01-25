#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class MSTEmployee
{

    #region All Memory Variables
    
    private string          _Location;
    private string          _HospCode;
    private int             _ID;    
    private string          _EmployeeID;
    private string          _Title;
    private string          _Name;
    private string          _Designation;
    private string          _House_No;
    private string          _Street_Name;
    private string          _Locality;
    private string           _City;
    private int             _PinCode;
    private string          _PHouse_No;
    private string          _PStreet_Name;
    private string          _PLocality;
    private string          _PCity;
    private int             _PPinCode;
    private System.DateTime _DOB;
    private string          _Qualification;
    private string          _Blood_Group;
    private string          _FatherName;
    private string          _MotherName;
 private string _HusbandName;
    private string          _ESI_No;
    private string          _EPF_No;
    private string          _PAN_No;
    private string          _Passport_No;
    
    private string          _Email;
    private string           _Phone;
    private string          _Mobile;
    private decimal          _DiscountPercent;
    private System.DateTime _StartDate;
 private System.DateTime _DOJ;
    private string _Gender;
    private string _Dept_ID;
    private string _Dept_Name;
    private string _Desi_ID;
    private string _Desi_Name;
    private string _GR_ID_NO;
    private string _LIC_ID_NO;
    private string _EDLI_NO_REG_NO;
    private string _PF_No;
    private string _PF_NOMINEE1;
    private string _PF_NOMINEE2;
    private string _BankAccountNo;
    private string _L_No;
    private int _Category;
    private string _QyaliDate;
    private string _Institute;
    private string _Resume;
    private string _Employer1;
    private DateTime _Durationfrom1;
    private DateTime _Durationto1;
    private string _Designation1;
    private string _JobProfile1;
    private string _Employer2;
    private DateTime _Durationfrom2;
    private DateTime _Durationto2;
    private string _Designation2;
    private string _JobProfile2;
    private string _Employer3;
    private DateTime _Durationfrom3;
    private DateTime _Durationto3;
    private string _Designation3;
    private string _JobProfile3;
    private System.DateTime _DOL;
    private int _LetterNo;
    private string _UserType_ID;
 private String _UserID;
    private float _FPS;
    private string _DisNo;
    private string _RegNo;
    private int _IsAccomodation;
    private string _Branch;
    private string _Responsibility;
    private float _Experience;
    private string _BankID;
    private string _BranchID;
    private string _KinName;
    private string _KinAddress;
    private string _kinPhoneNo;
    private string _No_Name;
    private string _No_Relation;
    private string _No_Address;
    private string  _No_ContactNo;
    private string _No_AddharCard;
    private string _UpdatedBy;
    private string _Emr_Relation;
    private string _Emr_Name;
    private string _Emr_Contact;
    private string _IFSCCode;
    private string _ACC_HolderName;
    private string _UANNO;
    private string _NO_ofDepdent;
    private string _MonthlySal;
    private string _AnnualCTC;
    private string _MedFitness;
    private string _Emp_AdharCard;
    private string _Emp_InsuranceNo;
    private string _CreatedBy;
    private DateTime _PassportExpiryDate;
    private string _DLNo;
    private int _DrivingLiscenceTypeID;
    private DateTime _DLExpiry;
    private int _Employee_Group_ID;
    private int _IsInvolveinInterViewProcess;
	private string _Emp_Category;
	private string _VoterCardNo;
    private int _Allowpartialpayment;
    private int _Cadreid;
    private int _TierID; 
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public MSTEmployee()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }
    public MSTEmployee(MySqlTransaction objTrans)
    {

        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
   
    public virtual String UserID
    {
        get { return _UserID; }
        set { _UserID = value; }
    }
    public virtual float FPS
    {
        get { return _FPS; }
        set { _FPS = value; }
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

    public virtual string  EmployeeID
    {
        get
        {
            return _EmployeeID;
        }
        set
        {
            _EmployeeID = value;
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
    public virtual string Name
    {
        get
        {
            return _Name;
        }
        set
        {
            _Name = value;
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
    public virtual int PinCode
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
    public virtual string PHouse_No
    {
        get
        {
            return _PHouse_No;
        }
        set
        {
            _PHouse_No = value;
        }
    }
    public virtual string PStreet_Name
    {
        get
        {
            return _PStreet_Name;
        }
        set
        {
            _PStreet_Name = value;
        }
    }
    public virtual string PLocality
    {
        get
        {
            return _PLocality;
        }
        set
        {
            _PLocality = value;
        }
    }
    public virtual string PCity
    {
        get
        {
            return _PCity;
        }
        set
        {
            _PCity = value;
        }
    }
    public virtual int PPinCode
    {
        get
        {
            return _PPinCode;
        }
        set
        {
            _PPinCode = value;
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
    public virtual string Qualification
    {
        get
        {
            return _Qualification;
        }
        set
        {
            _Qualification = value;
        }
    }
    public virtual string Blood_Group
    {
        get
        {
            return _Blood_Group;
        }
        set
        {
            _Blood_Group = value;
        }
    }
    public virtual string FatherName
    {
        get
        {
            return _FatherName;
        }
        set
        {
            _FatherName = value;
        }
    }
    public virtual string MotherName
    {
        get
        {
            return _MotherName;
        }
        set
        {
            _MotherName = value;
        }
    }
    public virtual string HusbandName
    {
        get
        {
            return _HusbandName;
        }
        set
        {
            _HusbandName = value;
        }
    }
    public virtual string ESI_No
    {
        get
        {
            return _ESI_No;
        }
        set
        {
            _ESI_No = value;
        }
    }
    public virtual string EPF_No
    {
        get
        {
            return _EPF_No;
        }
        set
        {
            _EPF_No = value;
        }
    }
    public virtual string PAN_No
    {
        get
        {
            return _PAN_No;
        }
        set
        {
            _PAN_No = value;
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
    public virtual string Designation
    {
        get
        {
            return _Designation;
        }
        set
        {
            _Designation = value;
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
    public virtual System.DateTime StartDate
    {
        get
        {
            return _StartDate;
        }
        set
        {
            _StartDate   = value;
        }
    }
 public virtual System.DateTime DOJ
    {
        get
        {
            return _DOJ;
        }
        set
        {
            _DOJ = value;
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
    public virtual string Dept_ID
    {
        get
        {
            return _Dept_ID;
        }
        set
        {
            _Dept_ID = value;
        }
    }
    public virtual string UserType_ID
    {
        get
        {
            return _UserType_ID;
        }
        set
        {
            _UserType_ID = value;
        }
    }
    public virtual string Dept_Name
    {
        get
        {
            return _Dept_Name;
        }
        set
        {
            _Dept_Name = value;
        }
    }
    public virtual int LetterNo
    {
        get { return _LetterNo; }
        set { _LetterNo = value; }
    }
    public virtual string Desi_ID
    {
        get
        {
            return _Desi_ID;
        }
        set
        {
            _Desi_ID = value;
        }
    }
    public virtual string Desi_Name
    {
        get
        {
            return _Desi_Name;
        }
        set
        {
            _Desi_Name = value;
        }
    }
    public virtual string GR_ID_NO
    {
        get
        {
            return _GR_ID_NO;
        }
        set
        {
            _GR_ID_NO = value;
        }
    }
    public virtual string LIC_ID_NO
    {
        get
        {
            return _LIC_ID_NO;
        }
        set
        {
            _LIC_ID_NO = value;
        }
    }
    public virtual string EDLI_NO_REG_NO
    {
        get
        {
            return _EDLI_NO_REG_NO;
        }
        set
        {
            _EDLI_NO_REG_NO = value;
        }
    }
    public virtual string PF_No
    {
        get
        {
            return _PF_No;
        }
        set
        {
            _PF_No = value;
        }
    }
    public virtual string PF_NOMINEE1
    {
        get
        {
            return _PF_NOMINEE1;
        }
        set
        {
            _PF_NOMINEE1 = value;
        }
    }
    public virtual string PF_NOMINEE2
    {
        get
        {
            return _PF_NOMINEE2;
        }
        set
        {
            _PF_NOMINEE2 = value;
        }
    }
    public virtual string BankAccountNo
    {
        get
        {
            return _BankAccountNo;
        }
        set
        {
            _BankAccountNo = value;
        }
    }
    public virtual string L_No
    {
        get
        {
            return _L_No;
        }
        set
        {
            _L_No = value;
        }
    }
    public virtual int Category
    {
        get
        {
            return _Category;
        }
        set
        {
            _Category = value;
        }
    }
    public virtual string QyaliDate
    {
        get
        {
            return _QyaliDate;
        }
        set
        {
            _QyaliDate = value;
        }
    }
    public virtual string Institute
    {
        get
        {
            return _Institute;
        }
        set
        {
            _Institute = value;
        }
    }
    public virtual string Resume
    {
        get
        {
            return _Resume;
        }
        set
        {
            _Resume = value;
        }
    }
    public virtual string Employer1
    {
        get
        {
            return _Employer1;
        }
        set
        {
            _Employer1 = value;
        }
    }
    public virtual DateTime Durationfrom1
    {
        get
        {
            return _Durationfrom1;
        }
        set
        {
            _Durationfrom1 = value;
        }
    }
    public virtual DateTime Durationto1
    {
        get
        {
            return _Durationto1;
        }
        set
        {
            _Durationto1 = value;
        }
    }
    public virtual string Designation1
    {
        get
        {
            return _Designation1;
        }
        set
        {
            _Designation1 = value;
        }
    }
    public virtual string JobProfile1
    {
        get
        {
            return _JobProfile1;
        }
        set
        {
            _JobProfile1 = value;
        }
    }
    public virtual string Employer2
    {
        get
        {
            return _Employer2;
        }
        set
        {
            _Employer2 = value;
        }
    }
    public virtual DateTime Durationfrom2
    {
        get
        {
            return _Durationfrom2;
        }
        set
        {
            _Durationfrom2 = value;
        }
    }
    public virtual DateTime Durationto2
    {
        get
        {
            return _Durationto2;
        }
        set
        {
            _Durationto2 = value;
        }
    }
    public virtual string Designation2
    {
        get
        {
            return _Designation2;
        }
        set
        {
            _Designation2 = value;
        }
    }
    public virtual string JobProfile2
    {
        get
        {
            return _JobProfile2;
        }
        set
        {
            _JobProfile2 = value;
        }
    }
    public virtual string Employer3
    {
        get
        {
            return _Employer3;
        }
        set
        {
            _Employer3 = value;
        }
    }
    public virtual DateTime Durationfrom3
    {
        get
        {
            return _Durationfrom3;
        }
        set
        {
            _Durationfrom3 = value;
        }
    }
    public virtual DateTime Durationto3
    {
        get
        {
            return _Durationto3;
        }
        set
        {
            _Durationto3 = value;
        }
    }
    public virtual string Designation3
    {
        get
        {
            return _Designation3;
        }
        set
        {
            _Designation3 = value;
        }
    }
    public virtual string JobProfile3
    {
        get
        {
            return _JobProfile3;
        }
        set
        {
            _JobProfile3 = value;
        }
    }
    public virtual System.DateTime DOL
    {
        get
        {
            return _DOL;
        }
        set
        {
            _DOL = value;
        }
    }
    public virtual string RegNo
    {
        get
        {
            return _RegNo;
        }
        set
        {
            _RegNo = value;
        }
    }
    public virtual string DisNo
    {
        get
        {
            return _DisNo;
        }
        set
        {
            _DisNo = value;
        }
    }
    public virtual int IsAccomodation
    {
        get
        {
            return _IsAccomodation;
        }
        set
        {
            _IsAccomodation = value;
        }
    }
    public virtual string Branch
    {
        get
        {
            return _Branch;
        }
        set
        {
            _Branch = value;
        }
    }
    public virtual string Responsibility
    {
        get
        {
            return _Responsibility;
        }
        set
        {
            _Responsibility = value;
        }
    }
    public virtual float Experience
    {
        get
        {
            return _Experience;
        }
        set
        {
            _Experience = value;
        }
    }
    public virtual string BankID
    {
        get
        {
            return _BankID;
        }
        set
        {
            _BankID = value;
        }
    }
    public virtual string BranchID
    {
        get
        {
            return _BranchID;
        }
        set
        {
            _BranchID = value;
        }
    }
    public virtual string KinName
    {
        get
        {
            return _KinName;
        }
        set
        {
            _KinName = value;
        }
    }
    public virtual string KinAddress
    {
        get
        {
            return _KinAddress;
        }
        set
        {
            _KinAddress = value;
        }
    }
    public virtual string kinPhoneNo
    {
        get
        {
            return _kinPhoneNo;
        }
        set
        {
            _kinPhoneNo = value;
        }
    }
    public virtual string No_Name
    {
        get { return _No_Name; }
        set { _No_Name = value; }
    }
    public virtual string No_Relation
    {
        get { return _No_Relation; }
        set { _No_Relation = value; }
    }
    public virtual string No_Address
    {
        get { return _No_Address; }
        set { _No_Address = value; }
    }
    public virtual string  No_ContactNo
    {
        get { return _No_ContactNo; }
        set { _No_ContactNo = value; }
    }
    public virtual string No_AddharCard
    {
        get { return _No_Address; }
        set { _No_Address = value; }
    }
    public virtual string Emp_Category
    {
        get { return _Emp_Category; }
        set { _Emp_Category = value; }
    }
    public virtual string Emr_Relation 
    {
        get { return _Emr_Relation; }
        set { _Emr_Relation = value; }
    }
    public virtual string Emr_Name
    {
        get { return _Emr_Name; }
        set { _Emr_Name = value; }
    }
    public virtual string Emr_Contact
    {
        get { return _Emr_Contact; }
        set { _Emr_Contact = value; }
    }
    public virtual string IFSCCode
    {
        get { return _IFSCCode; }
        set { _IFSCCode = value; }
    }
    public virtual string ACC_HolderName
    {
        get { return _ACC_HolderName; }
        set { _ACC_HolderName = value; }
    }
    public virtual string UANNO
    {
        get { return _UANNO; }
        set { _UANNO = value; }
    }
    public virtual string NO_ofDepdent
    {
        get { return _NO_ofDepdent; }
        set { _NO_ofDepdent = value; }
    }
    public virtual string MonthlySal
    {
        get { return _MonthlySal; }
        set { _MonthlySal = value; }
    }
    public virtual string AnnualCTC
    {
        get { return _AnnualCTC; }
        set { _AnnualCTC = value; }
    }
    
    public virtual string MedFitness
    {
        get { return _MedFitness; }
        set { _MedFitness = value; }
    }
    public virtual string Emp_AdharCard
    {
        get { return _Emp_AdharCard; }
        set { _Emp_AdharCard = value; }
    }
    public virtual string Emp_InsuranceNo
    {
        get { return _Emp_InsuranceNo; }
        set { _Emp_InsuranceNo = value; }
    }
    public virtual string VoterCardNo
    {
        get { return _VoterCardNo; }
        set { _VoterCardNo = value; }
    }
    public virtual DateTime PassportExpiryDate
    {
        get { return _PassportExpiryDate; }
        set { _PassportExpiryDate = value; }
    }
    public virtual string DLNo
    {
        get { return _DLNo; }
        set { _DLNo = value; }
    }
    public virtual int DrivingLiscenceTypeID
    {
        get { return _DrivingLiscenceTypeID; }
        set { _DrivingLiscenceTypeID = value; }
    }
    public virtual DateTime DLExpiry
    {
        get { return _DLExpiry; }
        set { _DLExpiry = value; }
    }
    public virtual int Employee_Group_ID
    {
        get { return _Employee_Group_ID; }
        set { _Employee_Group_ID = value; }
    }
    public virtual int IsInvolveinInterViewProcess
    {
        get { return _IsInvolveinInterViewProcess; }
        set { _IsInvolveinInterViewProcess = value; }
    }
    public virtual decimal DiscountPercent
    {
        get
        {
            return _DiscountPercent;
        }
        set
        {
            _DiscountPercent = value;
        }
    }
public virtual string UpdatedBy
    {
        get
        {
            return _UpdatedBy;
        }
        set
        {
            _UpdatedBy = value;
        }
    }
    public virtual string CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }
    public virtual int Allowpartialpayment
    {
        get
        {
            return _Allowpartialpayment;
        }
        set
        {
            _Allowpartialpayment = value;
        }
    }

    public virtual int Cadreid
    {
        get
        {
            return _Cadreid;
        }
        set
        {
            _Cadreid = value;
        }
    }
    public virtual int TierID
    {
        get
        {
            return _TierID;
        }
        set
        {
            _TierID = value;
        }
    }
    
    #endregion Set All Property

    #region All Public Member Function
    public string Insert()
    {
        try
        {

            //int iPkValue;
            StringBuilder objSQL = new StringBuilder(); 
            //objSQL.Append("INSERT INTO employee_master (EmployeeID ,Name, Designation, Address, Email,  Phone, Mobile, StartDate)");
            //objSQL.Append("VALUES (?,?,?,?,?,?,?,?)");
            objSQL.Append("insert_employee");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@EmployeeID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.City = Util.GetString(City);
            this.PinCode = Util.GetInt(PinCode);
            this.PHouse_No = Util.GetString(PHouse_No);
            this.PStreet_Name = Util.GetString(PStreet_Name);
            this.PLocality = Util.GetString(PLocality);
            this.PCity = Util.GetString(PCity);
            this.PPinCode = Util.GetInt(PPinCode);
            this.DOB = Util.GetDateTime(DOB);
            this.Qualification = Util.GetString(Qualification);
            this.Blood_Group = Util.GetString(Blood_Group);
            this.FatherName = Util.GetString(FatherName);
            this.MotherName = Util.GetString(MotherName);
            this.HusbandName = Util.GetString(HusbandName);
            this.ESI_No = Util.GetString(ESI_No);
            this.EPF_No = Util.GetString(EPF_No);
            this.PAN_No = Util.GetString(PAN_No);
            this.Passport_No = Util.GetString(Passport_No);
            this.Email = Util.GetString(Email);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.StartDate = Util.GetDateTime(StartDate);
            this.UserType_ID = Util.GetString(UserType_ID);
            this.DOJ = Util.GetDateTime(DOJ);
            this.Gender = Util.GetString(Gender);
            this.Dept_ID = Util.GetString(Dept_ID);
            this.Dept_Name = Util.GetString(Dept_Name);
            this.Desi_ID = Util.GetString(Desi_ID);
            this.Desi_Name = Util.GetString(Desi_Name);
            this.PF_No = Util.GetString(PF_No);
            this.PF_NOMINEE1 = Util.GetString(PF_NOMINEE1);
            this.BankAccountNo = Util.GetString(BankAccountNo);
            this.LetterNo = Util.GetInt(LetterNo);
            this.QyaliDate = Util.GetString(QyaliDate);
            this.Institute = Util.GetString(Institute);
            this.Resume = Util.GetString(Resume);

            this.RegNo = Util.GetString(RegNo);
            this.IsAccomodation = Util.GetInt(IsAccomodation);
            this.Branch = Util.GetString(Branch);
            this.Responsibility = Util.GetString(Responsibility);
            this.Experience = Util.GetFloat(Experience);
            this.BankID = Util.GetString(BankID);
            this.BranchID = Util.GetString(BranchID);
            this.KinName = Util.GetString(KinName);
            this.KinAddress = Util.GetString(KinAddress);
            this.kinPhoneNo = Util.GetString(kinPhoneNo);
            this.No_Name = Util.GetString(No_Name);
            this.No_Address = Util.GetString(No_Address);
            this.No_Relation = Util.GetString(No_Relation);
            this.No_ContactNo = Util.GetString(No_ContactNo);
            this.No_AddharCard = Util.GetString(No_AddharCard);
            this.Emp_Category = Util.GetString(Emp_Category);
            this.Emr_Relation = Util.GetString(Emr_Relation);
            this.Emr_Name = Util.GetString(Emr_Name);
            this.Emr_Contact = Util.GetString(Emr_Contact);
            this.IFSCCode = Util.GetString(IFSCCode);
            this.ACC_HolderName = Util.GetString(ACC_HolderName);
            this.UANNO = Util.GetString(UANNO);
            this.NO_ofDepdent = Util.GetString(NO_ofDepdent);
            this.MonthlySal = Util.GetString(MonthlySal);
            this.AnnualCTC = Util.GetString(AnnualCTC);
            this.MedFitness = Util.GetString(MedFitness);
            this.Emp_AdharCard = Util.GetString(Emp_AdharCard);
            this.Emp_InsuranceNo = Util.GetString(Emp_InsuranceNo);
            this.VoterCardNo = Util.GetString(VoterCardNo);
            this.PassportExpiryDate = Util.GetDateTime(PassportExpiryDate);
            this.DLNo = Util.GetString(DLNo);
            this.DrivingLiscenceTypeID = Util.GetInt(DrivingLiscenceTypeID);
            this.DLExpiry = Util.GetDateTime(DLExpiry);
            this.Employee_Group_ID = Util.GetInt(Employee_Group_ID);
            this.IsInvolveinInterViewProcess = Util.GetInt(IsInvolveinInterViewProcess);
            this.DiscountPercent = Util.GetDecimal(DiscountPercent);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.Allowpartialpayment = Util.GetInt(Allowpartialpayment);
            this.Cadreid = Util.GetInt(Cadreid);
            this.TierID = Util.GetInt(TierID);
            

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@Ename", Name));
            cmd.Parameters.Add(new MySqlParameter("@House_No", House_No));
            cmd.Parameters.Add(new MySqlParameter("@Street_Name", Street_Name));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Locality));
            cmd.Parameters.Add(new MySqlParameter("@City", City));
            cmd.Parameters.Add(new MySqlParameter("@Pincode", PinCode));
            cmd.Parameters.Add(new MySqlParameter("@PHouse_No", PHouse_No));
            cmd.Parameters.Add(new MySqlParameter("@PStreet_Name", PStreet_Name));
            cmd.Parameters.Add(new MySqlParameter("@PLocality", PLocality));
            cmd.Parameters.Add(new MySqlParameter("@PCity", PCity));
            cmd.Parameters.Add(new MySqlParameter("@PPincode", PPinCode));
            cmd.Parameters.Add(new MySqlParameter("@DOB", DOB));
            cmd.Parameters.Add(new MySqlParameter("@Qualification", Qualification));
            cmd.Parameters.Add(new MySqlParameter("@BloodGroup", Blood_Group));
            cmd.Parameters.Add(new MySqlParameter("@FatherName", FatherName));
            cmd.Parameters.Add(new MySqlParameter("@MotherName", MotherName));
            cmd.Parameters.Add(new MySqlParameter("@HusbandName", HusbandName));
            cmd.Parameters.Add(new MySqlParameter("@ESI_No", ESI_No));
            cmd.Parameters.Add(new MySqlParameter("@EPF_No", EPF_No));
            cmd.Parameters.Add(new MySqlParameter("@PAN_No", PAN_No));
            cmd.Parameters.Add(new MySqlParameter("@PassportNo", Passport_No));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Phone));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@StartDate", StartDate));
            cmd.Parameters.Add(new MySqlParameter("@UserType_ID", UserType_ID));
            cmd.Parameters.Add(new MySqlParameter("@DOJ", DOJ));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@Dept_ID", Dept_ID));
            cmd.Parameters.Add(new MySqlParameter("@Dept_Name", Dept_Name));
            cmd.Parameters.Add(new MySqlParameter("@Desi_ID", Desi_ID));
            cmd.Parameters.Add(new MySqlParameter("@Desi_Name", Desi_Name));
            cmd.Parameters.Add(new MySqlParameter("@PF_No", PF_No));
            cmd.Parameters.Add(new MySqlParameter("@PF_NOMINEE1", PF_NOMINEE1));
            cmd.Parameters.Add(new MySqlParameter("@BankAccountNo", BankAccountNo));
            cmd.Parameters.Add(new MySqlParameter("@LetterNo", LetterNo));
            cmd.Parameters.Add(new MySqlParameter("@QualiYear", QyaliDate));
            cmd.Parameters.Add(new MySqlParameter("@Institute", Institute));
            cmd.Parameters.Add(new MySqlParameter("@ResumeUrl", Resume));
            cmd.Parameters.Add(new MySqlParameter("@RegNo", RegNo));
            cmd.Parameters.Add(new MySqlParameter("@IsAccomodation", IsAccomodation));
            cmd.Parameters.Add(new MySqlParameter("@Branch", Branch));
            cmd.Parameters.Add(new MySqlParameter("@Responsibility", Responsibility));
            cmd.Parameters.Add(new MySqlParameter("@Experience", Experience));
            cmd.Parameters.Add(new MySqlParameter("@BankID", BankID));
            cmd.Parameters.Add(new MySqlParameter("@BranchID", BranchID));
            cmd.Parameters.Add(new MySqlParameter("@KinName", KinName));
            cmd.Parameters.Add(new MySqlParameter("@KinAddress", KinAddress));
            cmd.Parameters.Add(new MySqlParameter("@kinPhoneNo", kinPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@No_Name", No_Name));
            cmd.Parameters.Add(new MySqlParameter("@No_Relation", No_Relation));
            cmd.Parameters.Add(new MySqlParameter("@No_Address", No_Address));
            cmd.Parameters.Add(new MySqlParameter("@No_ContactNo", No_ContactNo));
            cmd.Parameters.Add(new MySqlParameter("@No_AddharCard", No_AddharCard));
            cmd.Parameters.Add(new MySqlParameter("@Emp_Category", Emp_Category));
            cmd.Parameters.Add(new MySqlParameter("@Emr_Relation", Emr_Relation));
            cmd.Parameters.Add(new MySqlParameter("@Emr_Name", Emr_Name));
            cmd.Parameters.Add(new MySqlParameter("@Emr_Contact", Emr_Contact));
            cmd.Parameters.Add(new MySqlParameter("@IFSCCode", IFSCCode));
            cmd.Parameters.Add(new MySqlParameter("@ACC_HolderName", ACC_HolderName));
            cmd.Parameters.Add(new MySqlParameter("@UANNO", UANNO));
            cmd.Parameters.Add(new MySqlParameter("@NO_ofDepdent", NO_ofDepdent));
            cmd.Parameters.Add(new MySqlParameter("@MonthlySal", MonthlySal));
            cmd.Parameters.Add(new MySqlParameter("@AnnualCTC", AnnualCTC));
            cmd.Parameters.Add(new MySqlParameter("@MedFitness", MedFitness));
            cmd.Parameters.Add(new MySqlParameter("@Emp_AdharCard", Emp_AdharCard));
            cmd.Parameters.Add(new MySqlParameter("@Emp_InsuranceNo", Emp_InsuranceNo));
            cmd.Parameters.Add(new MySqlParameter("@VoterCardNo", VoterCardNo));
            cmd.Parameters.Add(new MySqlParameter("@PassportExpiryDate", PassportExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@DLNo", DLNo));
            cmd.Parameters.Add(new MySqlParameter("@DrivingLiscenceTypeID", DrivingLiscenceTypeID));
            cmd.Parameters.Add(new MySqlParameter("@DLExpiry", DLExpiry));
            cmd.Parameters.Add(new MySqlParameter("@Employee_Group_ID", Employee_Group_ID));
            cmd.Parameters.Add(new MySqlParameter("@IsInvolveinInterViewProcess", IsInvolveinInterViewProcess));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountPercent", DiscountPercent));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCadreid", Cadreid));
            cmd.Parameters.Add(new MySqlParameter("@vTierID", TierID));
            cmd.Parameters.Add(new MySqlParameter("@vAllowpartialpayment", Allowpartialpayment));

            cmd.Parameters.Add(paramTnxID);
            EmployeeID = cmd.ExecuteScalar().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return EmployeeID;
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
    public bool Load()
    {
        DataTable dtTemp;
        try
        {
            string sSQL = "SELECT * FROM employee_master WHERE EmployeeID = ?";
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@EmployeeID", EmployeeID)).Tables[0];
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
            string sParams = "EmployeeID=" + this.EmployeeID.ToString();
            throw (ex);
        }
    }
    public bool Load(int iPkValue)
    {
        this.EmployeeID = iPkValue.ToString();
        return this.Load();
    }
    public int Update(int iPkValue)
    {
        this.EmployeeID = iPkValue.ToString();
        return this.Update();
    }
    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE employee_master SET Title=@Title, Name =@Name, House_No=@House_No, Street_Name=@Street_Name, Locality=@Locality, City=@City, PinCode=@PinCode, PHouse_No=@PHouse_No, PStreet_Name=@PStreet_Name, PLocality=@PLocality, PCity=@PCity, PPinCode=@PPinCode, DOB=@DOB, Qualification=@Qualification, BloodGroup=@Blood_Group, FatherName=@FatherName, MotherName=@MotherName, ESI_No=@ESI_No, EPF_No=@EPF_No, PAN_No=@PAN_No, PassportNo=@Passport_No, Email = @Email,");
            objSQL.Append("Phone = @Phone, Mobile = @Mobile, StartDate= @StartDate,UserType_ID=@UserType_ID,Gender=@Gender,Dept_ID=@Dept_ID,Dept_Name=@Dept_Name,Desi_ID=@Desi_ID,Desi_Name=@Desi_Name,Employee_Group_ID=@Employee_Group_ID,IsInvolveinInterViewProcess=@IsInvolveinInterViewProcess,Eligible_DiscountPercent=@Eligible_DiscountPercent,UpdatedBy=@UpdatedBy,Allowpartialpayment=@Allowpartialpayment,Cadreid=@Cadreid,TierID=@TierID WHERE EmployeeID = @EmployeeID");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.EmployeeID = Util.GetString(EmployeeID);
            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.City = Util.GetString(City);
            this.PinCode = Util.GetInt(PinCode);
            this.PHouse_No = Util.GetString(PHouse_No);
            this.PStreet_Name = Util.GetString(PStreet_Name);
            this.PLocality = Util.GetString(PLocality);
            this.PCity = Util.GetString(PCity);
            this.PPinCode = Util.GetInt(PPinCode);
            this.DOB = Util.GetDateTime(DOB);
            this.Qualification = Util.GetString(Qualification);
            this.Blood_Group = Util.GetString(Blood_Group);
            this.FatherName = Util.GetString(FatherName);
            this.MotherName = Util.GetString(MotherName);
            this.ESI_No = Util.GetString(ESI_No);
            this.EPF_No = Util.GetString(EPF_No);
            this.PAN_No = Util.GetString(PAN_No);
            this.Passport_No = Util.GetString(Passport_No);
            this.Email = Util.GetString(Email);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.StartDate = Util.GetDateTime(StartDate);
            this.UserType_ID = Util.GetString(UserType_ID);
            this.Gender = Util.GetString(Gender);
            this.Dept_ID = Util.GetString(Dept_ID);
            this.Dept_Name = Util.GetString(Dept_Name);
            this.Desi_Name = Util.GetString(Desi_Name);
            this.Employee_Group_ID = Util.GetInt(Employee_Group_ID);
            this.IsInvolveinInterViewProcess = Util.GetInt(IsInvolveinInterViewProcess);
            this.DiscountPercent = Util.GetDecimal(DiscountPercent);
            this.UpdatedBy = Util.GetString(UpdatedBy);
            this.Allowpartialpayment = Util.GetInt(Allowpartialpayment);
            this.Cadreid = Util.GetInt(Cadreid);
            this.TierID = Util.GetInt(TierID);
            //MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
               // new MySqlParameter("@EmployeeID", EmployeeID),
               // new MySqlParameter("@Designation", Designation),

                //cmd.ExecuteNonQuery();



            //iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));


            // Util.WriteLog(ex);









            // Util.WriteLog(ex);
            // Util.WriteLog(sParams);


    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>




            //this.Blood_Group = Util.GetString(Blood_Group);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                 new MySqlParameter("@Title",               Title),
                new MySqlParameter("@Name",                 Name ),
                new MySqlParameter("@House_No",             House_No),
                new MySqlParameter("@Street_Name",          Street_Name),
                new MySqlParameter("@Locality",             Locality),
                new MySqlParameter("@City",                 City),
                new MySqlParameter("@PinCode",              PinCode),
                new MySqlParameter("@PHouse_No",          PHouse_No),
                new MySqlParameter("@PStreet_Name",       PStreet_Name),
                new MySqlParameter("@PLocality",          PLocality),
                new MySqlParameter("@PCity",              PCity),
                new MySqlParameter("@PPinCode",           PPinCode),
                new MySqlParameter("@DOB",                  DOB),
                new MySqlParameter("@Qualification",        Qualification),
                new MySqlParameter("@Blood_Group",          Blood_Group),
                new MySqlParameter("@FatherName",           FatherName),
                new MySqlParameter("@MotherName",           MotherName),
                new MySqlParameter("@ESI_No",              ESI_No),
                new MySqlParameter("@EPF_No",              EPF_No),
                new MySqlParameter("@PAN_No",              PAN_No),
                new MySqlParameter("@Passport_No",         Passport_No),
                new MySqlParameter("@Email",                Email),
                new MySqlParameter("@Phone",               Phone),
                new MySqlParameter("@Mobile",             Mobile),
                new MySqlParameter("@StartDate",         StartDate),
                new MySqlParameter("@UserType_ID", UserType_ID),
                new MySqlParameter("@Gender", Gender),
                new MySqlParameter("@Dept_ID", Dept_ID),
                new MySqlParameter("@Dept_Name", Dept_Name),
                new MySqlParameter("@Desi_ID", Desi_ID),
                new MySqlParameter("@Desi_Name", Desi_Name),
                new MySqlParameter("@Employee_Group_ID", Employee_Group_ID),
                new MySqlParameter("@EmployeeID",      EmployeeID),
                new MySqlParameter("@IsInvolveinInterViewProcess", IsInvolveinInterViewProcess),
               new MySqlParameter("@Eligible_DiscountPercent", DiscountPercent),
               new MySqlParameter("@UpdatedBy", UpdatedBy),
                new MySqlParameter("@Allowpartialpayment", Allowpartialpayment),
                new MySqlParameter("@Cadreid", Cadreid),
                new MySqlParameter("@TierID", TierID));

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
            //Util.WriteLog(ex);
            throw (ex);
        }

    }

    public int Delete(int iPkValue)
    {
        this.EmployeeID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM employee_master WHERE EmployeeID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("EmployeeID", EmployeeID));
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

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.EmployeeID = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.EmployeeID]);
        this.Title = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Title]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Name]);
        this.Designation = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Designation]);
        this.House_No = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.House_No]);
        this.Street_Name= Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Street_Name]);
        this.Locality = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Locality]);
        this.City = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.City]);
        this.PinCode = Util.GetInt(dtTemp.Rows[0][AllTables.employee_master.PinCode]);
        this.PHouse_No = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.PHouse_No]);
        this.PStreet_Name = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.PStreet_Name]);
        this.PLocality = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.PLocality]);
        this.PCity = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.PCity]);
        this.PPinCode = Util.GetInt(dtTemp.Rows[0][AllTables.employee_master.PPinCode]);
        this.DOB = Util.GetDateTime(dtTemp.Rows[0][AllTables.employee_master.DOB]);
        this.Qualification = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Qualification]);
        this.Blood_Group = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Blood_Group]);
        this.FatherName= Util.GetString(dtTemp.Rows[0][AllTables.employee_master.FatherName]);
        this.MotherName= Util.GetString(dtTemp.Rows[0][AllTables.employee_master.MotherName]);
        this.ESI_No = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.ESI_No]);
        this.EPF_No = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.EPF_No]);
        this.PAN_No = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.PAN_No]);
        this.Passport_No = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Passport_No]);
        this.Email = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Email]);
        this.Phone = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Phone]);
        this.Mobile = Util.GetString(dtTemp.Rows[0][AllTables.employee_master.Mobile]);
        this.StartDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.employee_master.StartDate]);

    }
    #endregion
}
