#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces

/// <summary>
/// Summary description for Patient_Medical_History
/// </summary>
public class Patient_Medical_History
{
    #region All Memory Variables
    private string _AdmissionReason;
    private string _Location;
    private string _HospCode;
    private double _ID;
    private string _TransactionID;
    private string _PatientID;
    private string _DoctorID;
    private string _IssuedVisitorCardNo;

    [System.ComponentModel.DefaultValue("")]
    private string _DoctorID1;
    private string _Hospital_ID;
    private System.DateTime _Time;
    private System.DateTime _DateOfVisit;
    private string _Purpose;
    private System.DateTime _NextVisitDate;
    private decimal _FeesPaid;
    private string _Remarks;
    private string _VerificationStatus;
    private string _Type;
    private string _Canceled;
    private string _Ownership;
    private string _GroupID;
    private string _ReferedTransactionID;
    private string _EntryType;
    private string _UserID;
    private System.DateTime _EntryDate;
    private System.DateTime _ExtractDate;
    private int _PanelID;
    private string _Source;
    private string _ReferedBy;
    private string _KinRelation;
    private string _KinName;
    private string _KinPhone;
    private string _KinAddress;
    private string _DischargeType;
    private DateTime _Acc_date;
    private DateTime _Acc_time;
    private string _Acc_location;
    private string _Acc_MLCNO;
    private string _Acc_PCNo;
    private string _Cas_reason;
    private string _Visa_No;
    private DateTime _Visa_ExpiryDate;
    private int _IsMultipleDoctor;
    private int _ParentID;
    private string _patient_type;
    private string _Admission_Type;
    private string _MLC_NO;
    private string _VulnerableType;
    private string _Employee_id;
    private string _EmployeeDependentName;
    private string _DependentRelation;
    private string _PolicyNo;
    private string _CardNo;
    private DateTime _ExpiryDate;
    private DateTime _ReportingDateTime;
    private int _ScheduleChargeID;
    private int _DiagnosisID;
    private string _TypeOfDelivery;
    private string _DeliveryWeeks;
    private bool _DeliveryType;
    private DateTime _TimeOfDeath;
    private int _TypeOfDeathID;
    private string _CauseOfDeath;
    private int _IsDeathOver48HRS;
    private string _BroughtBy;
    private string _MotherTID;
    private string _MLC_Type;
    private string _BirthIgnoreReason;
    private string _PanelIgnoreReason;
    private string _CardHolderName;
    private string _RelationWith_holder;
    private string _FileNo;
    private decimal _Extra_AmtReceive;
    private decimal _Balance_Amt;
    private int _workrelatedinjury;
    private DateTime _Dateworkrelatedinjury;
    private int _autorelatedinjury;
    private DateTime _Dateautorelatedinjury;
    private int _MedicalInsuranceCoveredEmployer;
    private string _companyMedicalRepresentive;
    private string _LegalRepresenativeSignature;
    private DateTime _DateLegalRepresenativeSignature;
    private string _HashCode;
    private string _ProblemType;
    private string _Weight;
    private string _Height;
    private string _Allergies;
    private int _isAdvance;
    private int _isBirthDetail;
    private string _ReferenceCode;
    private int _CentreID;
    private int _IsNewPatient;
    private int _ProId;
    private int _PatientTypeID;
    private decimal _PatientPaybleAmt;
    private decimal _PanelPaybleAmt;
    private decimal _PatientPaidAmt;
    private decimal _PanelPaidAmt;
    private int _Co_PaymentOn;
    private int _CorporatePanelID;//
    private int _PatientSourceID;//

    private int _BookingCenterID;
    private string _TypeOfReference;

    /******************New column start for PMH table*******************************/

    private string _TransNo;
    private string _PatientLedgerNo;
    private int _BookingCentreID;
    private string _CurrentAge;
    private string _Consultant_Name;
    private DateTime _DateOfAdmit;
    private DateTime _TimeOfAdmit;
    private DateTime _DateOfDischarge;
    private DateTime _TimeOfDischarge;
    private string _DischargedBy;
    private string _STATUS;
    private string _EmployeeID;
    private string _ClaimNo;
    private string _CreditLimitType;
    private decimal _PanelApprovedAmt;
    private DateTime _PanelApprovalDate;
    private string _PanelAppRemarks;
    private int _PanelAppUserID;
    private string _BillNo;
    private DateTime _BillDate;
    private decimal _TotalBilledAmt;
    private decimal _DiscountOnBill;
    private decimal _TotalBillDiscPer;
    private string _DiscountOnBillReason;
    private string _DiscUserID;
    private int _BillingType;
    private string _ApprovalBy;
    private string _TempBillNo;
    private string _Narration;
    private decimal _ServiceTaxAmt;
    private decimal _ServiceTaxPer;
    private decimal _ServiceTaxSurChgAmt;
    private decimal _SerTaxSurChgPer;
    private decimal _SerTaxBillAmount;
    private int _S_CountryID;
    private decimal _S_Amount;
    private string _S_Notation;
    private decimal _C_Factor;
    private decimal _RoundOff;
    private string _panelInvoiceNo;
    private string _AdmissionCancelledBy;
    private string _AdmissionCancelReason;
    private DateTime _AdmissionCancelDate;
    private string _DischargedCancelledBy;
    private string _DischargeCancelReason;
    private DateTime _DischargeCancelDate;
    private int _MRD_IsFile;
    private string _ReceiveFile_By;
    private DateTime _ReceiveFile_Date;
    private int _IsBilledClosed;
    private string _BillClosedUserID;
    private DateTime _BillCloseddate;
    private string _BillingRemarks;
    private int _Bill_CountryID;
    private string _Bill_Notation;
    private decimal _Bill_Factor;
    private int _IsMail_1hrs;
    private int _IsMail_72hrs;
    private int _IsTPAInvActive;
    private string _TPAInvNo;
    private DateTime _TPAInvDate;
    private string _TPAInvCreatedBy;
    private DateTime _TPAInvChequeDate;
    private DateTime _TPAInvChequeReceiveDate;
    private decimal _TPAInvChequeAmount;
    private int _IsTPAInvClosed;
    private DateTime _TPAInvClosedDate;
    private string _TPAInvClosedBy;
    private string _TPAInvPaymentRemark;
    private string _finalDiscountApproval;
    private string _finalDiscReason;
    private string _discountApprovalRemarks;
    private int _discountApprovalStatus;
    private string _discountApprovalStatusUpdatedBy;
    private int _isopeningBalance;
    private DateTime _OpeningBalanceDate;
    private int _IsRoomRequest;
    private string _RequestedRoomType;
    private decimal _CreditLimitPanel;
    private DateTime _DateofAdjustment;
    private decimal _AdjustmentAmt;
    private string _AdjustmentReason;
    private int _FileClose_flag;
    private decimal _PatientCashAmt;
    private int _ReferralTypeID;//
    private string _BillGeneratedBy;
    private int _AdmittedIPDCaseTypeID;
    private int _CurrentIPDCaseTypeID;
    private int _AdmittedRoomID;
    private int _CurrentRoomID;
    private int _BillingIPDCaseTypeID;
    private decimal _NetBillAmount;
    private decimal _ItemDiscount;
    private int _PatientCodeType;

    [System.ComponentModel.DefaultValue("")]
    private string _EmergencyTransactionId;



    /*****************************************************************/

    [System.ComponentModel.DefaultValue("1")]
    private int _IsVisitClose;

    [System.ComponentModel.DefaultValue("0")]
    private int _TriagingCode;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Patient_Medical_History()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
        this.IsVisitClose = 1;
    }
    public Patient_Medical_History(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
        this.IsVisitClose = 1;
    }
    #endregion

    #region Set All Property

    public virtual string AdmissionReason
    {
        get
        {
            return _AdmissionReason;
        }
        set
        {
            _AdmissionReason = value;
        }
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
    public virtual double ID
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
    public virtual string TransactionID
    {
        get
        {
            return _TransactionID;
        }
        set
        {
            _TransactionID = value;
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
    public virtual string DoctorID
    {
        get
        {
            return _DoctorID;
        }
        set
        {
            _DoctorID = value;
        }
    }
    public virtual string DoctorID1
    {
        get
        {
            return _DoctorID1;
        }
        set
        {
            _DoctorID1 = value;
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
    public virtual System.DateTime Time
    {
        get
        {
            return _Time;
        }
        set
        {
            _Time = value;
        }
    }
    public virtual System.DateTime DateOfVisit
    {
        get
        {
            return _DateOfVisit;
        }
        set
        {
            _DateOfVisit = value;
        }
    }
    public virtual string Purpose
    {
        get
        {
            return _Purpose;
        }
        set
        {
            _Purpose = value;
        }
    }
    public virtual System.DateTime NextVisitDate
    {
        get
        {
            return _NextVisitDate;
        }
        set
        {
            _NextVisitDate = value;
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
    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }
        set
        {
            _Remarks = value;
        }
    }
    public virtual string VerificationStatus
    {
        get
        {
            return _VerificationStatus;
        }
        set
        {
            _VerificationStatus = value;
        }
    }
    public virtual string Type
    {
        get
        {
            return _Type;
        }
        set
        {
            _Type = value;
        }
    }
    public virtual string Canceled
    {
        get
        {
            return _Canceled;
        }
        set
        {
            _Canceled = value;
        }
    }
    public virtual string Ownership
    {
        get
        {
            return _Ownership;
        }
        set
        {
            _Ownership = value;
        }
    }
    public virtual string GroupID
    {
        get
        {
            return _GroupID;
        }
        set
        {
            _GroupID = value;
        }
    }
    public virtual string ReferedTransactionID
    {
        get
        {
            return _ReferedTransactionID;
        }
        set
        {
            _ReferedTransactionID = value;
        }
    }
    public virtual string EntryType
    {
        get
        {
            return _EntryType;
        }
        set
        {
            _EntryType = value;
        }
    }
    public virtual string UserID
    {
        get
        {
            return _UserID;
        }
        set
        {
            _UserID = value;
        }
    }
    public virtual System.DateTime EntryDate
    {
        get
        {
            return _EntryDate;
        }
        set
        {
            _EntryDate = value;
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

    public virtual int PanelID
    {
        get
        {
            return _PanelID;
        }
        set
        {
            _PanelID = value;
        }
    }
    public virtual string Source
    {
        get
        {
            return _Source;
        }
        set
        {
            _Source = value;
        }
    }
    public virtual string ReferedBy
    {
        get
        {
            return _ReferedBy;
        }
        set
        {
            _ReferedBy = value;
        }
    }

    public virtual string KinRelation
    {
        get
        {
            return _KinRelation;
        }
        set
        {
            _KinRelation = value;
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
    public virtual string KinPhone
    {
        get
        {
            return _KinPhone;
        }
        set
        {
            _KinPhone = value;
        }
    }
    public virtual string DischargeType
    {
        get
        {
            return _DischargeType;
        }
        set
        {
            _DischargeType = value;
        }
    }
    public virtual string Cas_reason
    {
        get { return _Cas_reason; }
        set { _Cas_reason = value; }
    }
    public virtual string Acc_PCNo
    {
        get { return _Acc_PCNo; }
        set { _Acc_PCNo = value; }
    }
    public virtual string Acc_MLCNO
    {
        get { return _Acc_MLCNO; }
        set { _Acc_MLCNO = value; }
    }

    public virtual string Acc_location
    {
        get { return _Acc_location; }
        set { _Acc_location = value; }
    }
    public virtual DateTime Acc_time
    {
        get { return _Acc_time; }
        set { _Acc_time = value; }
    }
    public virtual DateTime Acc_date
    {
        get { return _Acc_date; }
        set { _Acc_date = value; }
    }

    public virtual string Visa_No
    {
        get { return _Visa_No; }
        set { _Visa_No = value; }
    }
    public virtual DateTime Visa_ExpiryDate
    {
        get { return _Visa_ExpiryDate; }
        set { _Visa_ExpiryDate = value; }
    }
    public virtual int ScheduleChargeID
    {
        get { return _ScheduleChargeID; }
        set { _ScheduleChargeID = value; }
    }

    public virtual int IsMultipleDoctor
    {
        get
        {
            return _IsMultipleDoctor;
        }
        set
        {
            _IsMultipleDoctor = value;
        }

    }

    public virtual int ParentID
    {
        get
        {
            return _ParentID;
        }
        set
        {
            _ParentID = value;
        }
    }
    public virtual string MLC_NO
    {
        get
        {
            return _MLC_NO;
        }
        set
        {
            _MLC_NO = value;
        }
    }
    public virtual string patient_type
    {
        get
        {
            return _patient_type;

        }
        set
        {
            _patient_type = value;
        }
    }
    public virtual string Admission_Type
    {
        get
        {
            return _Admission_Type;
        }
        set
        {
            _Admission_Type = value;
        }
    }

    public virtual string VulnerableType
    {
        get
        {

            return _VulnerableType;
        }
        set
        {
            _VulnerableType = value;
        }

    }
    //public virtual string Employeeid
    //{
    //    get
    //    {

    //        return _Employee_id;
    //    }
    //    set
    //    {
    //        _Employee_id = value;
    //    }

    //}
    public virtual string EmployeeDependentName
    {
        get
        {

            return _EmployeeDependentName;
        }
        set
        {
            _EmployeeDependentName = value;
        }

    }
    public virtual string DependentRelation
    {
        get
        {

            return _DependentRelation;
        }
        set
        {
            _DependentRelation = value;
        }

    }
    public virtual string PolicyNo
    {
        get
        {

            return _PolicyNo;
        }
        set
        {
            _PolicyNo = value;
        }

    }
    public virtual string CardNo
    {
        get
        {

            return _CardNo;
        }
        set
        {
            _CardNo = value;
        }

    }
    public virtual DateTime ExpiryDate
    {
        get
        {

            return _ExpiryDate;
        }
        set
        {
            _ExpiryDate = value;
        }

    }

    public virtual DateTime ReportingDateTime
    {
        get
        {
            return _ReportingDateTime;
        }
        set
        {
            _ReportingDateTime = value;
        }
    }

    public virtual int DiagnosisID
    {
        get
        {
            return _DiagnosisID;
        }
        set
        {
            _DiagnosisID = value;
        }
    }





    public virtual string TypeOfDelivery
    {
        get
        {
            return _TypeOfDelivery;
        }
        set
        {
            _TypeOfDelivery = value;
        }

    }

    public virtual string DeliveryWeeks
    {
        get
        {
            return _DeliveryWeeks;
        }
        set
        {
            _DeliveryWeeks = value;
        }
    }

    public virtual bool DeliveryType
    {
        get
        {
            return _DeliveryType;
        }
        set
        {
            _DeliveryType = value;
        }

    }



    public virtual DateTime TimeOfDeath
    {
        get
        {
            return _TimeOfDeath;
        }
        set
        {
            _TimeOfDeath = value;
        }
    }

    public virtual int TypeOfDeathID
    {
        get
        {
            return _TypeOfDeathID;
        }
        set
        {
            _TypeOfDeathID = value;
        }
    }


    public virtual string CauseOfDeath
    {
        get
        {
            return _CauseOfDeath;
        }
        set
        {
            _CauseOfDeath = value;
        }
    }


    public virtual int IsDeathOver48HRS
    {
        get
        {
            return _IsDeathOver48HRS;
        }
        set
        {
            _IsDeathOver48HRS = value;
        }
    }

    public virtual string BroughtBy
    {
        get
        {
            return _BroughtBy;
        }
        set
        {
            _BroughtBy = value;
        }
    }
    public virtual string MotherTID
    {
        get
        {
            return _MotherTID;
        }
        set
        {
            _MotherTID = value;
        }
    }

    public virtual string MLC_Type
    {
        get
        {
            return _MLC_Type;
        }
        set
        {
            _MLC_Type = value;
        }
    }

    public virtual string BirthIgnoreReason
    {
        get
        {
            return _BirthIgnoreReason;
        }
        set
        {
            _BirthIgnoreReason = value;
        }
    }

    public virtual string PanelIgnoreReason
    {
        get
        {
            return _PanelIgnoreReason;
        }
        set
        {
            _PanelIgnoreReason = value;
        }
    }
    public virtual string CardHolderName
    {
        get
        {
            return _CardHolderName;
        }
        set
        {
            _CardHolderName = value;
        }
    }
    public virtual string RelationWith_holder
    {
        get
        {
            return _RelationWith_holder;
        }
        set
        {
            _RelationWith_holder = value;
        }
    }
    public virtual string FileNo
    {
        get
        {
            return _FileNo;
        }
        set
        {
            _FileNo = value;
        }
    }
    public virtual decimal Extra_AmtReceive
    {
        get
        {
            return _Extra_AmtReceive;
        }
        set
        {
            _Extra_AmtReceive = value;
        }
    }
    public virtual decimal Balance_Amt
    {
        get
        {
            return _Balance_Amt;
        }
        set
        {
            _Balance_Amt = value;
        }
    }

    public virtual int workrelatedinjury
    {
        get { return _workrelatedinjury; }
        set { _workrelatedinjury = value; }
    }
    public virtual DateTime Dateworkrelatedinjury
    {
        get { return _Dateworkrelatedinjury; }
        set { _Dateworkrelatedinjury = value; }
    }
    public virtual int autorelatedinjury
    {
        get { return _autorelatedinjury; }
        set { _autorelatedinjury = value; }
    }
    public virtual DateTime Dateautorelatedinjury
    {
        get { return _Dateautorelatedinjury; }
        set { _Dateautorelatedinjury = value; }
    }
    public virtual int MedicalInsuranceCoveredEmployer
    {
        get { return _MedicalInsuranceCoveredEmployer; }
        set { _MedicalInsuranceCoveredEmployer = value; }
    }
    public virtual string companyMedicalRepresentive
    {
        get { return _companyMedicalRepresentive; }
        set { _companyMedicalRepresentive = value; }
    }
    public virtual string LegalRepresenativeSignature
    {
        get { return _LegalRepresenativeSignature; }
        set { _LegalRepresenativeSignature = value; }
    }
    public virtual DateTime DateLegalRepresenativeSignature
    {
        get { return _DateLegalRepresenativeSignature; }
        set { _DateLegalRepresenativeSignature = value; }
    }
    public virtual string HashCode
    {
        get { return _HashCode; }
        set { _HashCode = value; }
    }
    public virtual string ProblemType
    {
        get { return _ProblemType; }
        set { _ProblemType = value; }
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
    public virtual string Height
    {
        get
        {
            return _Height;
        }
        set
        {
            _Height = value;
        }
    }
    public virtual string Allergies
    {
        get
        {
            return _Allergies;
        }
        set
        {
            _Allergies = value;
        }
    }
    public virtual int isAdvance
    {
        get { return _isAdvance; }
        set { _isAdvance = value; }
    }
    public virtual int isBirthDetail
    {
        get { return _isBirthDetail; }
        set { _isBirthDetail = value; }
    }
    public virtual string ReferenceCode
    {
        get
        {
            return _ReferenceCode;
        }
        set
        {
            _ReferenceCode = value;
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
    public virtual int IsNewPatient
    {
        get
        {
            return _IsNewPatient;
        }
        set
        {
            _IsNewPatient = value;
        }
    }
    public virtual int ProId
    {
        get
        {
            return _ProId;
        }
        set
        {
            _ProId = value;
        }
    }

    public virtual int patientTypeID
    {
        get
        {
            return _PatientTypeID;
        }
        set
        {
            _PatientTypeID = value;
        }
    }
    //dev
    public virtual decimal PatientPaybleAmt
    {
        get
        {
            return _PatientPaybleAmt;
        }
        set
        {
            _PatientPaybleAmt = value;
        }
    }
    public virtual decimal PanelPaybleAmt
    {
        get
        {
            return _PanelPaybleAmt;
        }
        set
        {
            _PanelPaybleAmt = value;
        }
    }
    public virtual decimal PatientPaidAmt
    {
        get
        {
            return _PatientPaidAmt;
        }
        set
        {
            _PatientPaidAmt = value;
        }
    }
    public virtual decimal PanelPaidAmt
    {
        get
        {
            return _PanelPaidAmt;
        }
        set
        {
            _PanelPaidAmt = value;
        }
    }
    public virtual int Co_PaymentOn
    {
        get
        {
            return _Co_PaymentOn;
        }
        set
        {
            _Co_PaymentOn = value;
        }
    }
    public virtual string IssuedVisitorCardNo
    {
        get { return _IssuedVisitorCardNo; }
        set { _IssuedVisitorCardNo = value; }
    }



    public int BookingCenterID
    {
        get { return _BookingCenterID; }
        set { _BookingCenterID = value; }
    }

    public int IsVisitClose
    {
        get { return _IsVisitClose; }
        set { _IsVisitClose = value; }
    }
    public string TypeOfReference
    {
        get { return _TypeOfReference; }
        set { _TypeOfReference = value; }
    }


    public int TriagingCode
    {
        get { return _TriagingCode; }
        set { _TriagingCode = value; }
    }

    public int CorporatePanelID //
    {
        get { return _CorporatePanelID; }
        set { _CorporatePanelID = value; }
    }

    public int PatientSourceID
    {
        get { return _PatientSourceID; }
        set { _PatientSourceID = value; }
    }

    /*******************Set All new columns of PMH************************************/

    public string TransNo
    {
        get { return _TransNo; }
        set { _TransNo = value; }
    }

    public string PatientLedgerNo
    {
        get { return _PatientLedgerNo; }
        set { _PatientLedgerNo = value; }
    }

    public int BookingCentreID
    {
        get { return _BookingCentreID; }
        set { _BookingCentreID = value; }
    }

    public string CurrentAge
    {
        get { return _CurrentAge; }
        set { _CurrentAge = value; }
    }

    public string Consultant_Name
    {
        get { return _Consultant_Name; }
        set { _Consultant_Name = value; }
    }

    public DateTime DateOfAdmit
    {
        get { return _DateOfAdmit; }
        set { _DateOfAdmit = value; }
    }

    public DateTime TimeOfAdmit
    {
        get { return _TimeOfAdmit; }
        set { _TimeOfAdmit = value; }
    }

    public DateTime DateOfDischarge
    {
        get { return _DateOfDischarge; }
        set { _DateOfDischarge = value; }
    }

    public DateTime TimeOfDischarge
    {
        get { return _TimeOfDischarge; }
        set { _TimeOfDischarge = value; }
    }

    public string DischargedBy
    {
        get { return _DischargedBy; }
        set { _DischargedBy = value; }
    }

    public string STATUS
    {
        get { return _STATUS; }
        set { _STATUS = value; }
    }

    public string EmployeeID
    {
        get { return _EmployeeID; }
        set { _EmployeeID = value; }
    }

    public string ClaimNo
    {
        get { return _ClaimNo; }
        set { _ClaimNo = value; }
    }

    public string CreditLimitType
    {
        get { return _CreditLimitType; }
        set { _CreditLimitType = value; }
    }

    public decimal PanelApprovedAmt
    {
        get { return _PanelApprovedAmt; }
        set { _PanelApprovedAmt = value; }
    }

    public DateTime PanelApprovalDate
    {
        get { return _PanelApprovalDate; }
        set { _PanelApprovalDate = value; }
    }

    public string PanelAppRemarks
    {
        get { return _PanelAppRemarks; }
        set { _PanelAppRemarks = value; }
    }

    public int PanelAppUserID
    {
        get { return _PanelAppUserID; }
        set { _PanelAppUserID = value; }
    }

    public string BillNo
    {
        get { return _BillNo; }
        set { _BillNo = value; }
    }

    public DateTime BillDate
    {
        get { return _BillDate; }
        set { _BillDate = value; }
    }

    public decimal TotalBilledAmt
    {
        get { return _TotalBilledAmt; }
        set { _TotalBilledAmt = value; }
    }

    public decimal DiscountOnBill
    {
        get { return _DiscountOnBill; }
        set { _DiscountOnBill = value; }
    }

    public decimal TotalBillDiscPer
    {
        get { return _TotalBillDiscPer; }
        set { _TotalBillDiscPer = value; }
    }

    public string DiscountOnBillReason
    {
        get { return _DiscountOnBillReason; }
        set { _DiscountOnBillReason = value; }
    }

    public string DiscUserID
    {
        get { return _DiscUserID; }
        set { _DiscUserID = value; }
    }

    public int BillingType
    {
        get { return _BillingType; }
        set { _BillingType = value; }
    }

    public string ApprovalBy
    {
        get { return _ApprovalBy; }
        set { _ApprovalBy = value; }
    }

    public string TempBillNo
    {
        get { return _TempBillNo; }
        set { _TempBillNo = value; }
    }

    public string Narration
    {
        get { return _Narration; }
        set { _Narration = value; }
    }

    public decimal ServiceTaxAmt
    {
        get { return _ServiceTaxAmt; }
        set { _ServiceTaxAmt = value; }
    }

    public decimal ServiceTaxPer
    {
        get { return _ServiceTaxPer; }
        set { _ServiceTaxPer = value; }
    }

    public decimal ServiceTaxSurChgAmt
    {
        get { return _ServiceTaxSurChgAmt; }
        set { _ServiceTaxSurChgAmt = value; }
    }

    public decimal SerTaxSurChgPer
    {
        get { return _SerTaxSurChgPer; }
        set { _SerTaxSurChgPer = value; }
    }

    public decimal SerTaxBillAmount
    {
        get { return _SerTaxBillAmount; }
        set { _SerTaxBillAmount = value; }
    }

    public int S_CountryID
    {
        get { return _S_CountryID; }
        set { _S_CountryID = value; }
    }

    public decimal S_Amount
    {
        get { return _S_Amount; }
        set { _S_Amount = value; }
    }

    public string S_Notation
    {
        get { return _S_Notation; }
        set { _S_Notation = value; }
    }

    public decimal C_Factor
    {
        get { return _C_Factor; }
        set { _C_Factor = value; }
    }

    public decimal RoundOff
    {
        get { return _RoundOff; }
        set { _RoundOff = value; }
    }

    public string panelInvoiceNo
    {
        get { return _panelInvoiceNo; }
        set { _panelInvoiceNo = value; }
    }

    public string AdmissionCancelledBy
    {
        get { return _AdmissionCancelledBy; }
        set { _AdmissionCancelledBy = value; }
    }

    public string AdmissionCancelReason
    {
        get { return _AdmissionCancelReason; }
        set { _AdmissionCancelReason = value; }
    }

    public DateTime AdmissionCancelDate
    {
        get { return _AdmissionCancelDate; }
        set { _AdmissionCancelDate = value; }
    }

    public string DischargedCancelledBy
    {
        get { return _DischargedCancelledBy; }
        set { _DischargedCancelledBy = value; }
    }

    public string DischargeCancelReason
    {
        get { return _DischargeCancelReason; }
        set { _DischargeCancelReason = value; }
    }

    public DateTime DischargeCancelDate
    {
        get { return _DischargeCancelDate; }
        set { _DischargeCancelDate = value; }
    }

    public int MRD_IsFile
    {
        get { return _MRD_IsFile; }
        set { _MRD_IsFile = value; }
    }

    public string ReceiveFile_By
    {
        get { return _ReceiveFile_By; }
        set { _ReceiveFile_By = value; }
    }

    public DateTime ReceiveFile_Date
    {
        get { return _ReceiveFile_Date; }
        set { _ReceiveFile_Date = value; }
    }

    public int IsBilledClosed
    {
        get { return _IsBilledClosed; }
        set { _IsBilledClosed = value; }
    }

    public string BillClosedUserID
    {
        get { return _BillClosedUserID; }
        set { _BillClosedUserID = value; }
    }

    public DateTime BillCloseddate
    {
        get { return _BillCloseddate; }
        set { _BillCloseddate = value; }
    }

    public string BillingRemarks
    {
        get { return _BillingRemarks; }
        set { _BillingRemarks = value; }
    }

    public int Bill_CountryID
    {
        get { return _Bill_CountryID; }
        set { _Bill_CountryID = value; }
    }

    public string Bill_Notation
    {
        get { return _Bill_Notation; }
        set { _Bill_Notation = value; }
    }

    public decimal Bill_Factor
    {
        get { return _Bill_Factor; }
        set { _Bill_Factor = value; }
    }

    public int IsMail_1hrs
    {
        get { return _IsMail_1hrs; }
        set { _IsMail_1hrs = value; }
    }

    public int IsMail_72hrs
    {
        get { return _IsMail_72hrs; }
        set { _IsMail_72hrs = value; }
    }

    public int IsTPAInvActive
    {
        get { return _IsTPAInvActive; }
        set { _IsTPAInvActive = value; }
    }

    public string TPAInvNo
    {
        get { return _TPAInvNo; }
        set { _TPAInvNo = value; }
    }

    public DateTime TPAInvDate
    {
        get { return _TPAInvDate; }
        set { _TPAInvDate = value; }
    }

    public string TPAInvCreatedBy
    {
        get { return _TPAInvCreatedBy; }
        set { _TPAInvCreatedBy = value; }
    }

    public DateTime TPAInvChequeDate
    {
        get { return _TPAInvChequeDate; }
        set { _TPAInvChequeDate = value; }
    }

    public DateTime TPAInvChequeReceiveDate
    {
        get { return _TPAInvChequeReceiveDate; }
        set { _TPAInvChequeReceiveDate = value; }
    }

    public decimal TPAInvChequeAmount
    {
        get { return _TPAInvChequeAmount; }
        set { _TPAInvChequeAmount = value; }
    }

    public int IsTPAInvClosed
    {
        get { return _IsTPAInvClosed; }
        set { _IsTPAInvClosed = value; }
    }

    public DateTime TPAInvClosedDate
    {
        get { return _TPAInvClosedDate; }
        set { _TPAInvClosedDate = value; }
    }

    public string TPAInvClosedBy
    {
        get { return _TPAInvClosedBy; }
        set { _TPAInvClosedBy = value; }
    }

    public string TPAInvPaymentRemark
    {
        get { return _TPAInvPaymentRemark; }
        set { _TPAInvPaymentRemark = value; }
    }

    public string finalDiscountApproval
    {
        get { return _finalDiscountApproval; }
        set { _finalDiscountApproval = value; }
    }

    public string finalDiscReason
    {
        get { return _finalDiscReason; }
        set { _finalDiscReason = value; }
    }

    public string discountApprovalRemarks
    {
        get { return _discountApprovalRemarks; }
        set { _discountApprovalRemarks = value; }
    }

    public int discountApprovalStatus
    {
        get { return _discountApprovalStatus; }
        set { _discountApprovalStatus = value; }
    }

    public string discountApprovalStatusUpdatedBy
    {
        get { return _discountApprovalStatusUpdatedBy; }
        set { _discountApprovalStatusUpdatedBy = value; }
    }

    public int isopeningBalance
    {
        get { return _isopeningBalance; }
        set { _isopeningBalance = value; }
    }

    public DateTime OpeningBalanceDate
    {
        get { return _OpeningBalanceDate; }
        set { _OpeningBalanceDate = value; }
    }

    public int IsRoomRequest
    {
        get { return _IsRoomRequest; }
        set { _IsRoomRequest = value; }
    }

    public string RequestedRoomType
    {
        get { return _RequestedRoomType; }
        set { _RequestedRoomType = value; }
    }

    public decimal CreditLimitPanel
    {
        get { return _CreditLimitPanel; }
        set { _CreditLimitPanel = value; }
    }

    public int ReferralTypeID
    {
        get { return _ReferralTypeID; }
        set { _ReferralTypeID = value; }
    }

    public string BillGeneratedBy {
        get { return _BillGeneratedBy; }
        set { _BillGeneratedBy = value; }
    }

    public int AdmittedIPDCaseTypeID
    {
        get { return _AdmittedIPDCaseTypeID; }
        set { _AdmittedIPDCaseTypeID = value; }
    }
    public int CurrentIPDCaseTypeID
    {
        get { return _CurrentIPDCaseTypeID; }
        set { _CurrentIPDCaseTypeID = value; }
    }
    public int AdmittedRoomID
    {
        get { return _AdmittedRoomID; }
        set { _AdmittedRoomID = value; }
    }
    public int CurrentRoomID
    {
        get { return _CurrentRoomID; }
        set { _CurrentRoomID = value; }
    }
    public int BillingIPDCaseTypeID
    {
        get { return _BillingIPDCaseTypeID; }
        set { _BillingIPDCaseTypeID = value; }
    }

    public decimal NetBillAmount
    {
        get { return _NetBillAmount; }
        set { _NetBillAmount = value; }
    }
    public decimal ItemDiscount
    {
        get { return _ItemDiscount; }
        set { _ItemDiscount = value; }
    }

    public int PatientCodeType
    {
        get { return _PatientCodeType; }
        set { _PatientCodeType = value; }
    }

    public string EmergencyTransactionId
    {
        get { return _EmergencyTransactionId; }
        set { _EmergencyTransactionId = value; }
    }


    /**********************************************************************/

    #endregion

    #region All Public Member Function


    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();

            if (this.Type == "IPD")
            {
                this.Location = AllGlobalFunction.LocationIPD;
            }
            else
            {
                this.Location = AllGlobalFunction.Location;
            }


            if (this.Type == "GEN-OPD" || this.Type == "OPD")
            {
                this.HospCode = AllGlobalFunction.LHospCode;
            }
            else if (this.Type == "CASUALTY-APPOINTMENT" || this.Type == "CASUALITY")
            {
                this.HospCode = AllGlobalFunction.CHospCode;
            }
            else
            {
                this.HospCode = AllGlobalFunction.HospCode;
            }

            objSQL.Append("insert_pmhistory");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@TransactionID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Canceled = Util.GetString(Canceled);
            this.DateOfVisit = Util.GetDateTime(DateOfVisit);
            this.DoctorID = Util.GetString(DoctorID);
            this.DoctorID1 = Util.GetString(DoctorID1);
            this.EntryDate = Util.GetDateTime(EntryDate);
            this.EntryType = Util.GetString(EntryType);
            this.ExtractDate = Util.GetDateTime(ExtractDate);
            this.FeesPaid = Util.GetDecimal(FeesPaid);
            this.GroupID = Util.GetString(GroupID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.NextVisitDate = Util.GetDateTime(NextVisitDate);
            this.Ownership = Util.GetString(Ownership);
            this.PatientID = Util.GetString(PatientID);
            this.Purpose = Util.GetString(Purpose);
            this.ReferedTransactionID = Util.GetString(ReferedTransactionID);
            this.Remarks = Util.GetString(Remarks);
            this.Time = Util.GetDateTime(Time);
            this.Type = Util.GetString(Type);
            this.UserID = Util.GetString(UserID);
            this.VerificationStatus = Util.GetString(VerificationStatus);
            this.PanelID = Util.GetInt(PanelID);
            this.Source = Util.GetString(Source);
            this.ReferedBy = Util.GetString(ReferedBy);
            this.KinRelation = Util.GetString(KinRelation);
            this.KinName = Util.GetString(KinName);
            this.KinPhone = Util.GetString(KinPhone);
            this.KinAddress = Util.GetString(KinAddress);
            this.DischargeType = Util.GetString(DischargeType);
            this.Acc_date = Util.GetDateTime(Acc_date);
            this.Acc_time = Util.GetDateTime(Acc_time);
            this.Acc_location = Util.GetString(Acc_location);
            this.Acc_MLCNO = Util.GetString(Acc_MLCNO);
            this.Acc_PCNo = Util.GetString(Acc_PCNo);
            this.Cas_reason = Util.GetString(Cas_reason);
            this.Visa_No = Util.GetString(Visa_No);
            this.Visa_ExpiryDate = Util.GetDateTime(Visa_ExpiryDate);
            this.IsMultipleDoctor = Util.GetInt(IsMultipleDoctor);
            this.ParentID = Util.GetInt(ParentID);
            this.MLC_NO = Util.GetString(MLC_NO);
            this.patient_type = Util.GetString(patient_type);
            this.Admission_Type = Util.GetString(Admission_Type);
            this.VulnerableType = Util.GetString(VulnerableType);
            //this.Employeeid = Util.GetString(Employeeid);
            this.EmployeeDependentName = Util.GetString(EmployeeDependentName);
            this.DependentRelation = Util.GetString(DependentRelation);
            this.PolicyNo = Util.GetString(PolicyNo);
            this.CardNo = Util.GetString(CardNo);
            this.EntryDate = Util.GetDateTime(EntryDate);
            this.ReportingDateTime = Util.GetDateTime(ReportingDateTime);
            this.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
            this.DiagnosisID = Util.GetInt(DiagnosisID);
            this.DeliveryWeeks = Util.GetString(DeliveryWeeks);
            this.TypeOfDelivery = Util.GetString(TypeOfDelivery);
            this.DeliveryType = Util.GetBoolean(DeliveryType);
            this.TimeOfDeath = Util.GetDateTime(TimeOfDeath);
            this.TypeOfDeathID = Util.GetInt(TypeOfDeathID);
            this.CauseOfDeath = Util.GetString(CauseOfDeath);
            this.IsDeathOver48HRS = Util.GetInt(IsDeathOver48HRS);
            this.BroughtBy = Util.GetString(BroughtBy);
            this.MotherTID = Util.GetString(MotherTID);
            this.MLC_Type = Util.GetString(MLC_Type);
            this.BirthIgnoreReason = Util.GetString(BirthIgnoreReason);
            this.PanelIgnoreReason = Util.GetString(PanelIgnoreReason);
            this.CardHolderName = Util.GetString(CardHolderName);
            this.RelationWith_holder = Util.GetString(RelationWith_holder);
            this.FileNo = Util.GetString(FileNo);
            this.Extra_AmtReceive = Util.GetDecimal(Extra_AmtReceive);
            this.Balance_Amt = Util.GetDecimal(Balance_Amt);
            this.workrelatedinjury = Util.GetInt(_workrelatedinjury);
            this.Dateworkrelatedinjury = Util.GetDateTime(_Dateworkrelatedinjury);
            this.autorelatedinjury = Util.GetInt(_autorelatedinjury);
            this.Dateautorelatedinjury = Util.GetDateTime(_Dateautorelatedinjury);
            this.MedicalInsuranceCoveredEmployer = Util.GetInt(_MedicalInsuranceCoveredEmployer);
            this.companyMedicalRepresentive = Util.GetString(_companyMedicalRepresentive);
            this.LegalRepresenativeSignature = Util.GetString(_LegalRepresenativeSignature);
            this.DateLegalRepresenativeSignature = Util.GetDateTime(_DateLegalRepresenativeSignature);
            this.HashCode = Util.GetString(HashCode);
            //this.patient_type = Util.GetString(ProblemType);
            this.patientTypeID = Util.GetInt(patientTypeID);
            this.Weight = Util.GetString(Weight);
            this.Height = Util.GetString(Height);
            this.Allergies = Util.GetString(Allergies);
            this.isAdvance = Util.GetInt(isAdvance);
            this.CentreID = Util.GetInt(CentreID);
            this.IsNewPatient = Util.GetInt(IsNewPatient);
            this.ProId = Util.GetInt(ProId);
            this.PatientPaybleAmt = Util.GetDecimal(PatientPaybleAmt);
            this.PanelPaybleAmt = Util.GetDecimal(PanelPaybleAmt);
            this.PatientPaidAmt = Util.GetDecimal(PatientPaidAmt);
            this.PanelPaidAmt = Util.GetDecimal(PanelPaidAmt);
            this.Co_PaymentOn = Util.GetInt(Co_PaymentOn);
            this.IssuedVisitorCardNo = Util.GetString(IssuedVisitorCardNo);
            this.BookingCenterID = Util.GetInt(BookingCenterID);
            this.IsVisitClose = Util.GetInt(IsVisitClose);
            this.AdmissionReason = Util.GetString(AdmissionReason);
            this.TypeOfReference = Util.GetString(TypeOfReference);
            this.TriagingCode = Util.GetInt(TriagingCode);
            this.CorporatePanelID = Util.GetInt(CorporatePanelID);//
            this.PatientSourceID = Util.GetInt(PatientSourceID);//

            /*********************new column start****************************/

            //this.TransNo = Util.GetString(TransNo);
            this.PatientLedgerNo = Util.GetString(PatientLedgerNo);
            this.BookingCentreID = Util.GetInt(BookingCentreID);
            this.CurrentAge = Util.GetString(CurrentAge);
            this.Consultant_Name = Util.GetString(Consultant_Name);
            this.DateOfAdmit = Util.GetDateTime(DateOfAdmit);
            this.TimeOfAdmit = Util.GetDateTime(TimeOfAdmit);
            this.DateOfDischarge = Util.GetDateTime(DateOfDischarge);
            this.TimeOfDischarge = Util.GetDateTime(TimeOfDischarge);
            this.DischargedBy = Util.GetString(DischargedBy);
            this.STATUS = Util.GetString(STATUS);
            this.EmployeeID = Util.GetString(EmployeeID);
            this.ClaimNo = Util.GetString(ClaimNo);
            this.CreditLimitType = Util.GetString(CreditLimitType);
            this.PanelApprovedAmt = Util.GetDecimal(PanelApprovedAmt);
            this.PanelApprovalDate = Util.GetDateTime(PanelApprovalDate);
            this.PanelAppRemarks = Util.GetString(PanelAppRemarks);
            this.PanelAppUserID = Util.GetInt(PanelAppUserID);
            this.BillNo = Util.GetString(BillNo);
            this.BillDate = Util.GetDateTime(BillDate);
            this.TotalBilledAmt = Util.GetDecimal(TotalBilledAmt);
            this.DiscountOnBill = Util.GetDecimal(DiscountOnBill);
            this.TotalBillDiscPer = Util.GetDecimal(TotalBillDiscPer);
            this.DiscountOnBillReason = Util.GetString(DiscountOnBillReason);
            this.DiscUserID = Util.GetString(DiscUserID);
            this.BillingType = Util.GetInt(BillingType);
            this.ApprovalBy = Util.GetString(ApprovalBy);
            this.TempBillNo = Util.GetString(TempBillNo);
            this.Narration = Util.GetString(Narration);
            this.ServiceTaxAmt = Util.GetDecimal(ServiceTaxAmt);
            this.ServiceTaxPer = Util.GetDecimal(ServiceTaxPer);
            this.ServiceTaxSurChgAmt = Util.GetDecimal(ServiceTaxSurChgAmt);
            this.SerTaxSurChgPer = Util.GetDecimal(SerTaxSurChgPer);
            this.SerTaxBillAmount = Util.GetDecimal(SerTaxBillAmount);
            this.S_CountryID = Util.GetInt(S_CountryID);
            this.S_Amount = Util.GetDecimal(S_Amount);
            this.S_Notation = Util.GetString(S_Notation);
            this.C_Factor = Util.GetDecimal(C_Factor);
            this.RoundOff = Util.GetDecimal(RoundOff);
            this.panelInvoiceNo = Util.GetString(panelInvoiceNo);
            this.AdmissionCancelledBy = Util.GetString(AdmissionCancelledBy);
            this.AdmissionCancelReason = Util.GetString(AdmissionCancelReason);
            this.AdmissionCancelDate = Util.GetDateTime(AdmissionCancelDate);
            this.DischargedCancelledBy = Util.GetString(DischargedCancelledBy);
            this.DischargeCancelReason = Util.GetString(DischargeCancelReason);
            this.DischargeCancelDate = Util.GetDateTime(DischargeCancelDate);
            this.MRD_IsFile = Util.GetInt(MRD_IsFile);
            this.ReceiveFile_By = Util.GetString(ReceiveFile_By);
            this.ReceiveFile_Date = Util.GetDateTime(ReceiveFile_Date);
            this.IsBilledClosed = Util.GetInt(IsBilledClosed);
            this.BillClosedUserID = Util.GetString(BillClosedUserID);
            this.BillCloseddate = Util.GetDateTime(BillCloseddate);
            this.BillingRemarks = Util.GetString(BillingRemarks);
            this.Bill_CountryID = Util.GetInt(Bill_CountryID);
            this.Bill_Notation = Util.GetString(Bill_Notation);
            this.Bill_Factor = Util.GetDecimal(Bill_Factor);
            this.IsMail_1hrs = Util.GetInt(IsMail_1hrs);
            this.IsMail_72hrs = Util.GetInt(IsMail_72hrs);
            this.IsTPAInvActive = Util.GetInt(IsTPAInvActive);
            this.TPAInvNo = Util.GetString(TPAInvNo);
            this.TPAInvDate = Util.GetDateTime(TPAInvDate);
            this.TPAInvCreatedBy = Util.GetString(TPAInvCreatedBy);
            this.TPAInvChequeDate = Util.GetDateTime(TPAInvChequeDate);
            this.TPAInvChequeReceiveDate = Util.GetDateTime(TPAInvChequeReceiveDate);
            this.TPAInvChequeAmount = Util.GetDecimal(TPAInvChequeAmount);
            this.IsTPAInvClosed = Util.GetInt(IsTPAInvClosed);
            this.TPAInvClosedDate = Util.GetDateTime(TPAInvClosedDate);
            this.TPAInvClosedBy = Util.GetString(TPAInvClosedBy);
            this.TPAInvPaymentRemark = Util.GetString(TPAInvPaymentRemark);
            this.finalDiscountApproval = Util.GetString(finalDiscountApproval);
            this.finalDiscReason = Util.GetString(finalDiscReason);
            this.discountApprovalRemarks = Util.GetString(discountApprovalRemarks);
            this.discountApprovalStatus = Util.GetInt(discountApprovalStatus);
            this.discountApprovalStatusUpdatedBy = Util.GetString(discountApprovalStatusUpdatedBy);
            this.isopeningBalance = Util.GetInt(isopeningBalance);
            this.OpeningBalanceDate = Util.GetDateTime(OpeningBalanceDate);
            this.IsRoomRequest = Util.GetInt(IsRoomRequest);
            this.RequestedRoomType = Util.GetString(RequestedRoomType);
            this.CreditLimitPanel = Util.GetDecimal(CreditLimitPanel);
            this.ReferralTypeID = Util.GetInt(ReferralTypeID);
            this.BillGeneratedBy = Util.GetString(BillGeneratedBy);
            this.AdmittedIPDCaseTypeID = AdmittedIPDCaseTypeID;
            this.CurrentIPDCaseTypeID = CurrentIPDCaseTypeID;
            this.AdmittedRoomID = AdmittedRoomID;
            this.CurrentRoomID = CurrentRoomID;
            this.BillingIPDCaseTypeID = BillingIPDCaseTypeID;
            this.NetBillAmount = Util.GetDecimal(NetBillAmount);
            this.ItemDiscount = Util.GetDecimal(ItemDiscount);
            this.PatientCodeType = Util.GetInt(PatientCodeType);
            this.EmergencyTransactionId = Util.GetString(EmergencyTransactionId);

            /**************************************************************/

            //,PatientPaybleAmt,PanelPaybleAmt,PatientPaidAmt,PanelPaidAmt,Co_PaymentOn
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@DoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@DoctorID1", DoctorID1));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@TIME", Time));
            cmd.Parameters.Add(new MySqlParameter("@DateOfVisit", DateOfVisit));
            cmd.Parameters.Add(new MySqlParameter("@Purpose", Purpose));
            cmd.Parameters.Add(new MySqlParameter("@NextVisitDate", NextVisitDate));
            cmd.Parameters.Add(new MySqlParameter("@FeesPaid", FeesPaid));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@VerificationStatus", VerificationStatus));
            cmd.Parameters.Add(new MySqlParameter("@TYPE", Type));
            cmd.Parameters.Add(new MySqlParameter("@Canceled", Canceled));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@ReferedTransactionID", ReferedTransactionID));
            cmd.Parameters.Add(new MySqlParameter("@EntryType", EntryType));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@EntryDate", EntryDate));
            cmd.Parameters.Add(new MySqlParameter("@ExtractDate", ExtractDate));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
            cmd.Parameters.Add(new MySqlParameter("@Source", Source));
            cmd.Parameters.Add(new MySqlParameter("@ReferedBy", ReferedBy));
            cmd.Parameters.Add(new MySqlParameter("@KinRelation", KinRelation));
            cmd.Parameters.Add(new MySqlParameter("@KinName", KinName));
            cmd.Parameters.Add(new MySqlParameter("@KinPhone", KinPhone));
            cmd.Parameters.Add(new MySqlParameter("@KinAddress", KinAddress));
            cmd.Parameters.Add(new MySqlParameter("@DischargeType", DischargeType));
            cmd.Parameters.Add(new MySqlParameter("@Acc_date", Acc_date));
            cmd.Parameters.Add(new MySqlParameter("@Acc_time", Acc_time));
            cmd.Parameters.Add(new MySqlParameter("@Acc_location", Acc_location));
            cmd.Parameters.Add(new MySqlParameter("@Acc_MLCNO", Acc_MLCNO));
            cmd.Parameters.Add(new MySqlParameter("@Acc_PCNo", Acc_PCNo));
            cmd.Parameters.Add(new MySqlParameter("@Cas_reason", Cas_reason));
            cmd.Parameters.Add(new MySqlParameter("@Visa_No", Visa_No));
            cmd.Parameters.Add(new MySqlParameter("@Visa_ExpiryDate", Visa_ExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@IsMultipleDoctor", IsMultipleDoctor));
            cmd.Parameters.Add(new MySqlParameter("@ParentID", ParentID));
            cmd.Parameters.Add(new MySqlParameter("@Admission_Type", Admission_Type));
            cmd.Parameters.Add(new MySqlParameter("@MLC_NO", MLC_NO));
            cmd.Parameters.Add(new MySqlParameter("@patient_type", patient_type));
            cmd.Parameters.Add(new MySqlParameter("@VulnerableType", VulnerableType));
            //cmd.Parameters.Add(new MySqlParameter("@Employee_id", Employeeid));
            cmd.Parameters.Add(new MySqlParameter("@EmployeeDependentName", EmployeeDependentName));
            cmd.Parameters.Add(new MySqlParameter("@DependentRelation", DependentRelation));
            cmd.Parameters.Add(new MySqlParameter("@PolicyNo", PolicyNo));
            cmd.Parameters.Add(new MySqlParameter("@CardNo", CardNo));
            cmd.Parameters.Add(new MySqlParameter("@ExpiryDate", ExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@ReportingDateTime", ReportingDateTime));
            cmd.Parameters.Add(new MySqlParameter("@ScheduleChargeID", ScheduleChargeID));
            cmd.Parameters.Add(new MySqlParameter("@DiagnosisID", DiagnosisID));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryWeeks", DeliveryWeeks));
            cmd.Parameters.Add(new MySqlParameter("@TypeOfDelivery", TypeOfDelivery));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryType", DeliveryType));
            cmd.Parameters.Add(new MySqlParameter("@TimeOfDeath", TimeOfDeath));
            cmd.Parameters.Add(new MySqlParameter("@TypeOfDeathID", TypeOfDeathID));
            cmd.Parameters.Add(new MySqlParameter("@CauseOfDeath", CauseOfDeath));
            cmd.Parameters.Add(new MySqlParameter("@IsDeathOver48HRS", IsDeathOver48HRS));
            cmd.Parameters.Add(new MySqlParameter("@BroughtBy", BroughtBy));
            cmd.Parameters.Add(new MySqlParameter("@MotherTID", MotherTID));
            cmd.Parameters.Add(new MySqlParameter("@MLC_Type", MLC_Type));
            cmd.Parameters.Add(new MySqlParameter("@BirthIgnoreReason", BirthIgnoreReason));
            cmd.Parameters.Add(new MySqlParameter("@PanelIgnoreReason", PanelIgnoreReason));
            cmd.Parameters.Add(new MySqlParameter("@CardHolderName", CardHolderName));
            cmd.Parameters.Add(new MySqlParameter("@RelationWith_holder", RelationWith_holder));
            cmd.Parameters.Add(new MySqlParameter("@FileNo", FileNo));
            cmd.Parameters.Add(new MySqlParameter("@Extra_AmtReceive", Extra_AmtReceive));
            cmd.Parameters.Add(new MySqlParameter("@Balance_Amt", Balance_Amt));
            cmd.Parameters.Add(new MySqlParameter("@workrelatedinjury", workrelatedinjury));
            cmd.Parameters.Add(new MySqlParameter("@Dateworkrelatedinjury", Dateworkrelatedinjury));
            cmd.Parameters.Add(new MySqlParameter("@autorelatedinjury", autorelatedinjury));
            cmd.Parameters.Add(new MySqlParameter("@Dateautorelatedinjury", Dateautorelatedinjury));
            cmd.Parameters.Add(new MySqlParameter("@MedicalInsuranceCoveredEmployer", MedicalInsuranceCoveredEmployer));
            cmd.Parameters.Add(new MySqlParameter("@companyMedicalRepresentive", companyMedicalRepresentive));
            cmd.Parameters.Add(new MySqlParameter("@LegalRepresenativeSignature", LegalRepresenativeSignature));
            cmd.Parameters.Add(new MySqlParameter("@DateLegalRepresenativeSignature", DateLegalRepresenativeSignature));
            cmd.Parameters.Add(new MySqlParameter("@HashCode", HashCode));
            cmd.Parameters.Add(new MySqlParameter("@ProblemType", ProblemType));
            cmd.Parameters.Add(new MySqlParameter("@Weight", Weight));
            cmd.Parameters.Add(new MySqlParameter("@Height", Height));
            cmd.Parameters.Add(new MySqlParameter("@Allergies", Allergies));
            cmd.Parameters.Add(new MySqlParameter("@isAdvance", isAdvance));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@IsNewPatient", IsNewPatient));
            cmd.Parameters.Add(new MySqlParameter("@ProId", ProId));
            cmd.Parameters.Add(new MySqlParameter("@patientTypeID", patientTypeID));

            cmd.Parameters.Add(new MySqlParameter("@PatientPaybleAmt", PatientPaybleAmt));
            cmd.Parameters.Add(new MySqlParameter("@PanelPaybleAmt", PanelPaybleAmt));
            cmd.Parameters.Add(new MySqlParameter("@PatientPaidAmt", PatientPaidAmt));
            cmd.Parameters.Add(new MySqlParameter("@PanelPaidAmt", PanelPaidAmt));
            cmd.Parameters.Add(new MySqlParameter("@Co_PaymentOn", Co_PaymentOn));
            cmd.Parameters.Add(new MySqlParameter("@IssuedVisitorCardNo", IssuedVisitorCardNo));
            cmd.Parameters.Add(new MySqlParameter("@BookingCenterID", BookingCenterID));
            cmd.Parameters.Add(new MySqlParameter("@IsVisitClose", IsVisitClose));
            cmd.Parameters.Add(new MySqlParameter("@AdmissionReason", AdmissionReason));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfReference", TypeOfReference));
            cmd.Parameters.Add(new MySqlParameter("@vTriagingCode", TriagingCode));
            cmd.Parameters.Add(new MySqlParameter("@vCorporatePanelID", CorporatePanelID));//
            cmd.Parameters.Add(new MySqlParameter("@vPatientSourceID", PatientSourceID));//

            /***********************************new column start*********************************************************/

            //cmd.Parameters.Add(new MySqlParameter("@vTransNo", TransNo));
            cmd.Parameters.Add(new MySqlParameter("@vPatientLedgerNo", PatientLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@vBookingCentreID", BookingCentreID));
            cmd.Parameters.Add(new MySqlParameter("@vCurrentAge", CurrentAge));
            cmd.Parameters.Add(new MySqlParameter("@vConsultant_Name", Consultant_Name));
            cmd.Parameters.Add(new MySqlParameter("@vDateOfAdmit", DateOfAdmit));
            cmd.Parameters.Add(new MySqlParameter("@vTimeOfAdmit", TimeOfAdmit));
            cmd.Parameters.Add(new MySqlParameter("@vDateOfDischarge", DateOfDischarge));
            cmd.Parameters.Add(new MySqlParameter("@vTimeOfDischarge", TimeOfDischarge));
            cmd.Parameters.Add(new MySqlParameter("@vDischargedBy", DischargedBy));
            cmd.Parameters.Add(new MySqlParameter("@vSTATUS", STATUS));
            cmd.Parameters.Add(new MySqlParameter("@vEmployeeID", EmployeeID));
            cmd.Parameters.Add(new MySqlParameter("@vClaimNo", ClaimNo));
            cmd.Parameters.Add(new MySqlParameter("@vCreditLimitType", CreditLimitType));
            cmd.Parameters.Add(new MySqlParameter("@vPanelApprovedAmt", PanelApprovedAmt));
            cmd.Parameters.Add(new MySqlParameter("@vPanelApprovalDate", PanelApprovalDate));
            cmd.Parameters.Add(new MySqlParameter("@vPanelAppRemarks", PanelAppRemarks));
            cmd.Parameters.Add(new MySqlParameter("@vPanelAppUserID", PanelAppUserID));
            cmd.Parameters.Add(new MySqlParameter("@vBillNo", BillNo));
            cmd.Parameters.Add(new MySqlParameter("@vBillDate", BillDate));
            cmd.Parameters.Add(new MySqlParameter("@vTotalBilledAmt", TotalBilledAmt));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountOnBill", DiscountOnBill));
            cmd.Parameters.Add(new MySqlParameter("@vTotalBillDiscPer", TotalBillDiscPer));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountOnBillReason", DiscountOnBillReason));
            cmd.Parameters.Add(new MySqlParameter("@vDiscUserID", DiscUserID));
            cmd.Parameters.Add(new MySqlParameter("@vBillingType", BillingType));
            cmd.Parameters.Add(new MySqlParameter("@vApprovalBy", ApprovalBy));
            cmd.Parameters.Add(new MySqlParameter("@vTempBillNo", TempBillNo));
            cmd.Parameters.Add(new MySqlParameter("@vNarration", Narration));
            cmd.Parameters.Add(new MySqlParameter("@vServiceTaxAmt", ServiceTaxAmt));
            cmd.Parameters.Add(new MySqlParameter("@vServiceTaxPer", ServiceTaxPer));
            cmd.Parameters.Add(new MySqlParameter("@vServiceTaxSurChgAmt", ServiceTaxSurChgAmt));
            cmd.Parameters.Add(new MySqlParameter("@vSerTaxSurChgPer", SerTaxSurChgPer));
            cmd.Parameters.Add(new MySqlParameter("@vSerTaxBillAmount", SerTaxBillAmount));
            cmd.Parameters.Add(new MySqlParameter("@vS_CountryID", S_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@vS_Amount", S_Amount));
            cmd.Parameters.Add(new MySqlParameter("@vS_Notation", S_Notation));
            cmd.Parameters.Add(new MySqlParameter("@vC_Factor", C_Factor));
            cmd.Parameters.Add(new MySqlParameter("@vRoundOff", RoundOff));
            cmd.Parameters.Add(new MySqlParameter("@vpanelInvoiceNo", panelInvoiceNo));
            cmd.Parameters.Add(new MySqlParameter("@vAdmissionCancelledBy", AdmissionCancelledBy));
            cmd.Parameters.Add(new MySqlParameter("@vAdmissionCancelReason", AdmissionCancelReason));
            cmd.Parameters.Add(new MySqlParameter("@vAdmissionCancelDate", AdmissionCancelDate));
            cmd.Parameters.Add(new MySqlParameter("@vDischargedCancelledBy", DischargedCancelledBy));
            cmd.Parameters.Add(new MySqlParameter("@vDischargeCancelReason", DischargeCancelReason));
            cmd.Parameters.Add(new MySqlParameter("@vDischargeCancelDate", DischargeCancelDate));
            cmd.Parameters.Add(new MySqlParameter("@vMRD_IsFile", MRD_IsFile));
            cmd.Parameters.Add(new MySqlParameter("@vReceiveFile_By", ReceiveFile_By));
            cmd.Parameters.Add(new MySqlParameter("@vReceiveFile_Date", ReceiveFile_Date));
            cmd.Parameters.Add(new MySqlParameter("@vIsBilledClosed", IsBilledClosed));
            cmd.Parameters.Add(new MySqlParameter("@vBillClosedUserID", BillClosedUserID));
            cmd.Parameters.Add(new MySqlParameter("@vBillCloseddate", BillCloseddate));
            cmd.Parameters.Add(new MySqlParameter("@vBillingRemarks", BillingRemarks));
            cmd.Parameters.Add(new MySqlParameter("@vBill_CountryID", Bill_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@vBill_Notation", Bill_Notation));
            cmd.Parameters.Add(new MySqlParameter("@vBill_Factor", Bill_Factor));
            cmd.Parameters.Add(new MySqlParameter("@vIsMail_1hrs", IsMail_1hrs));
            cmd.Parameters.Add(new MySqlParameter("@vIsMail_72hrs", IsMail_72hrs));
            cmd.Parameters.Add(new MySqlParameter("@vIsTPAInvActive", IsTPAInvActive));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvNo", TPAInvNo));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvDate", TPAInvDate));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvCreatedBy", TPAInvCreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvChequeDate", TPAInvChequeDate));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvChequeReceiveDate", TPAInvChequeReceiveDate));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvChequeAmount", TPAInvChequeAmount));
            cmd.Parameters.Add(new MySqlParameter("@vIsTPAInvClosed", IsTPAInvClosed));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvClosedDate", TPAInvClosedDate));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvClosedBy", TPAInvClosedBy));
            cmd.Parameters.Add(new MySqlParameter("@vTPAInvPaymentRemark", TPAInvPaymentRemark));
            cmd.Parameters.Add(new MySqlParameter("@vfinalDiscountApproval", finalDiscountApproval));
            cmd.Parameters.Add(new MySqlParameter("@vfinalDiscReason", finalDiscReason));
            cmd.Parameters.Add(new MySqlParameter("@vdiscountApprovalRemarks", discountApprovalRemarks));
            cmd.Parameters.Add(new MySqlParameter("@vdiscountApprovalStatus", discountApprovalStatus));
            cmd.Parameters.Add(new MySqlParameter("@vdiscountApprovalStatusUpdatedBy", discountApprovalStatusUpdatedBy));
            cmd.Parameters.Add(new MySqlParameter("@visopeningBalance", isopeningBalance));
            cmd.Parameters.Add(new MySqlParameter("@vOpeningBalanceDate", OpeningBalanceDate));
            cmd.Parameters.Add(new MySqlParameter("@vIsRoomRequest", IsRoomRequest));
            cmd.Parameters.Add(new MySqlParameter("@vRequestedRoomType", RequestedRoomType));
            cmd.Parameters.Add(new MySqlParameter("@vCreditLimitPanel", CreditLimitPanel));
            cmd.Parameters.Add(new MySqlParameter("@vReferralTypeID", ReferralTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vBillGeneratedBy", BillGeneratedBy));

            cmd.Parameters.Add(new MySqlParameter("@vAdmittedIPDCaseTypeID", AdmittedIPDCaseTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vCurrentIPDCaseTypeID", CurrentIPDCaseTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vAdmittedRoomID", AdmittedRoomID));
            cmd.Parameters.Add(new MySqlParameter("@vCurrentRoomID", CurrentRoomID));
            cmd.Parameters.Add(new MySqlParameter("@vBillingIPDCaseTypeID", BillingIPDCaseTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vNetBillAmount", NetBillAmount));
            cmd.Parameters.Add(new MySqlParameter("@vItemDiscount", ItemDiscount));
            cmd.Parameters.Add(new MySqlParameter("@vPatientCodeType", PatientCodeType));
            cmd.Parameters.Add(new MySqlParameter("@EmergencyTransactionId", EmergencyTransactionId));


            /**************************************************************************************/

            cmd.Parameters.Add(paramTnxID);
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
            throw (ex);
        }

    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE patient_medical_history SET  PatientID = @PatientID,");
            objSQL.Append("DoctorID = @DoctorID,DoctorID1=@DoctorID1 Hospital_ID = @Hospital_ID, Time = @Time, DateOfVisit = @DateOfVisit, Purpose = @Purpose, NextVisitDate = @NextVisitDate, FeesPaid = @FeesPaid,");
            objSQL.Append("Remarks =@Remarks, VerificationStatus = @VerificationStatus, Type = @Type, Canceled = @Canceled, Ownership = @Canceled, GroupID = @GroupID,");
            objSQL.Append("ReferedTransactionID = @ReferedTransactionID,");
            objSQL.Append("EntryType = @EntryType, UserID = @UserID, EntryDate = @EntryDate, ExtractDate = @ExtractDate,PanelID = @PanelID, Source=@Source, ReferedBy=@ReferedBy,KinRelation = @KinRelation, KinName = @KinName, KinPhone = @KinPhone, KinAddress = @KinPhone,");
            objSQL.Append("DischargeType=@DischargeType,Acc_date=@Acc_date,Acc_time=@Acc_time,Acc_location=@Acc_location,Acc_MLCNO=@Acc_MLCNO,Acc_PCNo=@Acc_PCNo,");
            objSQL.Append("Cas_reason=@Cas_reason ,Visa_No=@Visa_No,Visa_ExpiryDate=@Visa_ExpiryDate,ParentID=@ParentID,ScheduleChargeID=@ScheduleChargeID,DiagnosisID=@DiagnosisID, ");
            objSQL.Append("Admission_Type=@Admission_Type,isAdvance=@isAdvance,ProId=@ProId,@PatientPaybleAmt=PatientPaybleAmt,@PanelPaybleAmt=PanelPaybleAmt,@PatientPaidAmt=PatientPaidAmt,@PanelPaidAmt=PanelPaidAmt,@Co_PaymentOn=Co_PaymentOn, ");
            objSQL.Append(" PatientLedgerNo=@PatientLedgerNo,BookingCentreID=@BookingCentreID,CurrentAge=@CurrentAge,Consultant_Name=@Consultant_Name,DateOfAdmit=@DateOfAdmit,TimeOfAdmit=@TimeOfAdmit,DateOfDischarge=@DateOfDischarge, ");//new column start from here
            objSQL.Append(" TimeOfDischarge=@TimeOfDischarge,DischargedBy=@DischargedBy,STATUS=@STATUS,EmployeeID=@EmployeeID,ClaimNo=@ClaimNo,CreditLimitType=@CreditLimitType,PanelApprovedAmt=@PanelApprovedAmt,PanelApprovalDate=@PanelApprovalDate, ");
            objSQL.Append(" PanelAppRemarks=@PanelAppRemarks,PanelAppUserID=@PanelAppUserID,BillNo=@BillNo,BillDate=@BillDate,TotalBilledAmt=@TotalBilledAmt,DiscountOnBill=@DiscountOnBill,TotalBillDiscPer=@TotalBillDiscPer,DiscountOnBillReason=@DiscountOnBillReason,DiscUserID=@DiscUserID,BillingType=@BillingType, ");
            objSQL.Append(" ApprovalBy=@ApprovalBy,TempBillNo=@TempBillNo,Narration=@Narration,ServiceTaxAmt=@ServiceTaxAmt,ServiceTaxPer=@ServiceTaxPer,ServiceTaxSurChgAmt=@ServiceTaxSurChgAmt,SerTaxSurChgPer=@SerTaxSurChgPer,SerTaxBillAmount=@SerTaxBillAmount,S_CountryID=@S_CountryID,S_Amount=@S_Amount,S_Notation=@S_Notation, ");
            objSQL.Append(" C_Factor=@C_Factor,RoundOff=@RoundOff,panelInvoiceNo=@panelInvoiceNo,AdmissionCancelledBy=@AdmissionCancelledBy,AdmissionCancelReason=@AdmissionCancelReason,AdmissionCancelDate=@AdmissionCancelDate,DischargedCancelledBy=@DischargedCancelledBy,DischargeCancelReason=@DischargeCancelReason, ");
            objSQL.Append(" DischargeCancelDate=@DischargeCancelDate,MRD_IsFile=@MRD_IsFile,ReceiveFile_By=@ReceiveFile_By,ReceiveFile_Date=@ReceiveFile_Date,IsBilledClosed=@IsBilledClosed,BillClosedUserID=@BillClosedUserID,BillCloseddate=@BillCloseddate,BillingRemarks=@BillingRemarks,Bill_CountryID=@Bill_CountryID,Bill_Notation=@Bill_Notation, ");
            objSQL.Append(" Bill_Factor=@Bill_Factor,IsMail_1hrs=@IsMail_1hrs,IsMail_72hrs=@IsMail_72hrs,IsTPAInvActive=@IsTPAInvActive,TPAInvNo=@TPAInvNo,TPAInvDate=@TPAInvDate,TPAInvCreatedBy=@TPAInvCreatedBy,TPAInvChequeDate=@TPAInvChequeDate,TPAInvChequeReceiveDate=@TPAInvChequeReceiveDate,TPAInvChequeAmount=@TPAInvChequeAmount,IsTPAInvClosed=@IsTPAInvClosed, ");
            objSQL.Append(" TPAInvClosedDate=@TPAInvClosedDate,TPAInvClosedBy=@TPAInvClosedBy,TPAInvPaymentRemark=@TPAInvPaymentRemark,finalDiscountApproval=@finalDiscountApproval,finalDiscReason=@finalDiscReason,discountApprovalRemarks=@discountApprovalRemarks,discountApprovalStatus=@discountApprovalStatus,discountApprovalStatusUpdatedBy=@discountApprovalStatusUpdatedBy,isopeningBalance=@isopeningBalance,OpeningBalanceDate=@OpeningBalanceDate ");//end
            objSQL.Append(" WHERE TransactionID=@TransactionID ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Canceled = Util.GetString(Canceled);
            this.DateOfVisit = Util.GetDateTime(DateOfVisit);
            this.DoctorID = Util.GetString(DoctorID);
            this.DoctorID1 = Util.GetString(DoctorID1);
            this.EntryDate = Util.GetDateTime(EntryDate);
            this.EntryType = Util.GetString(EntryType);
            this.ExtractDate = Util.GetDateTime(ExtractDate);
            this.FeesPaid = Util.GetInt(FeesPaid);
            this.GroupID = Util.GetString(GroupID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.NextVisitDate = Util.GetDateTime(NextVisitDate);
            this.Ownership = Util.GetString(Ownership);
            this.PatientID = Util.GetString(PatientID);
            this.Purpose = Util.GetString(Purpose);
            this.ReferedTransactionID = Util.GetString(ReferedTransactionID);
            this.Remarks = Util.GetString(Remarks);
            this.Time = Util.GetDateTime(Time);
            this.Type = Util.GetString(Type);
            this.UserID = Util.GetString(UserID);
            this.VerificationStatus = Util.GetString(VerificationStatus);
            this.PanelID = PanelID;
            this.Source = Util.GetString(Source);
            this.ReferedBy = Util.GetString(ReferedBy);
            this.KinRelation = Util.GetString(KinRelation);
            this.KinName = Util.GetString(KinName);
            this.KinPhone = Util.GetString(KinPhone);
            this.KinAddress = Util.GetString(KinAddress);
            this.DischargeType = Util.GetString(DischargeType);
            this.TransactionID = Util.GetString(TransactionID);

            this.Acc_date = Util.GetDateTime(Acc_date);
            this.Acc_time = Util.GetDateTime(Acc_time);
            this.Acc_location = Util.GetString(Acc_location);
            this.Acc_MLCNO = Util.GetString(Acc_MLCNO);
            this.Acc_PCNo = Util.GetString(Acc_PCNo);
            this.Cas_reason = Util.GetString(Cas_reason);
            this.Visa_No = Util.GetString(Visa_No);
            this.Visa_ExpiryDate = Util.GetDateTime(Visa_ExpiryDate);
            this.ParentID = ParentID;
            this.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
            this.DiagnosisID = Util.GetInt(DiagnosisID);
            this.Weight = Util.GetString(Weight);
            this.Height = Util.GetString(Height);
            this.Allergies = Util.GetString(Allergies);
            this.Admission_Type = Util.GetString(Admission_Type);
            this.isAdvance = Util.GetInt(isAdvance);
            this.ProId = Util.GetInt(ProId);
            this.PatientPaybleAmt = Util.GetDecimal(PatientPaybleAmt);
            this.PanelPaybleAmt = Util.GetDecimal(PanelPaybleAmt);
            this.PatientPaidAmt = Util.GetDecimal(PatientPaidAmt);
            this.PanelPaidAmt = Util.GetDecimal(PanelPaidAmt);
            this.Co_PaymentOn = Util.GetInt(Co_PaymentOn);

            /**************new column start*********************/
          //  this.TransNo = Util.GetString(TransNo);
            this.PatientLedgerNo = Util.GetString(PatientLedgerNo);
            this.BookingCentreID = Util.GetInt(BookingCentreID);
            this.CurrentAge = Util.GetString(CurrentAge);
            this.Consultant_Name = Util.GetString(Consultant_Name);
            this.DateOfAdmit = Util.GetDateTime(DateOfAdmit);
            this.TimeOfAdmit = Util.GetDateTime(TimeOfAdmit);
            this.DateOfDischarge = Util.GetDateTime(DateOfDischarge);
            this.TimeOfDischarge = Util.GetDateTime(TimeOfDischarge);
            this.DischargedBy = Util.GetString(DischargedBy);
            this.STATUS = Util.GetString(STATUS);
            this.EmployeeID = Util.GetString(EmployeeID);
            this.ClaimNo = Util.GetString(ClaimNo);
            this.CreditLimitType = Util.GetString(CreditLimitType);
            this.PanelApprovedAmt = Util.GetDecimal(PanelApprovedAmt);
            this.PanelApprovalDate = Util.GetDateTime(PanelApprovalDate);
            this.PanelAppRemarks = Util.GetString(PanelAppRemarks);
            this.PanelAppUserID = Util.GetInt(PanelAppUserID);
            this.BillNo = Util.GetString(BillNo);
            this.BillDate = Util.GetDateTime(BillDate);
            this.TotalBilledAmt = Util.GetDecimal(TotalBilledAmt);
            this.DiscountOnBill = Util.GetDecimal(DiscountOnBill);
            this.TotalBillDiscPer = Util.GetDecimal(TotalBillDiscPer);
            this.DiscountOnBillReason = Util.GetString(DiscountOnBillReason);
            this.DiscUserID = Util.GetString(DiscUserID);
            this.BillingType = Util.GetInt(BillingType);
            this.ApprovalBy = Util.GetString(ApprovalBy);
            this.TempBillNo = Util.GetString(TempBillNo);
            this.Narration = Util.GetString(Narration);
            this.ServiceTaxAmt = Util.GetDecimal(ServiceTaxAmt);
            this.ServiceTaxPer = Util.GetDecimal(ServiceTaxPer);
            this.ServiceTaxSurChgAmt = Util.GetDecimal(ServiceTaxSurChgAmt);
            this.SerTaxSurChgPer = Util.GetDecimal(SerTaxSurChgPer);
            this.SerTaxBillAmount = Util.GetDecimal(SerTaxBillAmount);
            this.S_CountryID = Util.GetInt(S_CountryID);
            this.S_Amount = Util.GetDecimal(S_Amount);
            this.S_Notation = Util.GetString(S_Notation);
            this.C_Factor = Util.GetDecimal(C_Factor);
            this.RoundOff = Util.GetDecimal(RoundOff);
            this.panelInvoiceNo = Util.GetString(panelInvoiceNo);
            this.AdmissionCancelledBy = Util.GetString(AdmissionCancelledBy);
            this.AdmissionCancelReason = Util.GetString(AdmissionCancelReason);
            this.AdmissionCancelDate = Util.GetDateTime(AdmissionCancelDate);
            this.DischargedCancelledBy = Util.GetString(DischargedCancelledBy);
            this.DischargeCancelReason = Util.GetString(DischargeCancelReason);
            this.DischargeCancelDate = Util.GetDateTime(DischargeCancelDate);
            this.MRD_IsFile = Util.GetInt(MRD_IsFile);
            this.ReceiveFile_By = Util.GetString(ReceiveFile_By);
            this.ReceiveFile_Date = Util.GetDateTime(ReceiveFile_Date);
            this.IsBilledClosed = Util.GetInt(IsBilledClosed);
            this.BillClosedUserID = Util.GetString(BillClosedUserID);
            this.BillCloseddate = Util.GetDateTime(BillCloseddate);
            this.BillingRemarks = Util.GetString(BillingRemarks);
            this.Bill_CountryID = Util.GetInt(Bill_CountryID);
            this.Bill_Notation = Util.GetString(Bill_Notation);
            this.Bill_Factor = Util.GetDecimal(Bill_Factor);
            this.IsMail_1hrs = Util.GetInt(IsMail_1hrs);
            this.IsMail_72hrs = Util.GetInt(IsMail_72hrs);
            this.IsTPAInvActive = Util.GetInt(IsTPAInvActive);
            this.TPAInvNo = Util.GetString(TPAInvNo);
            this.TPAInvDate = Util.GetDateTime(TPAInvDate);
            this.TPAInvCreatedBy = Util.GetString(TPAInvCreatedBy);
            this.TPAInvChequeDate = Util.GetDateTime(TPAInvChequeDate);
            this.TPAInvChequeReceiveDate = Util.GetDateTime(TPAInvChequeReceiveDate);
            this.TPAInvChequeAmount = Util.GetDecimal(TPAInvChequeAmount);
            this.IsTPAInvClosed = Util.GetInt(IsTPAInvClosed);
            this.TPAInvClosedDate = Util.GetDateTime(TPAInvClosedDate);
            this.TPAInvClosedBy = Util.GetString(TPAInvClosedBy);
            this.TPAInvPaymentRemark = Util.GetString(TPAInvPaymentRemark);
            this.finalDiscountApproval = Util.GetString(finalDiscountApproval);
            this.finalDiscReason = Util.GetString(finalDiscReason);
            this.discountApprovalRemarks = Util.GetString(discountApprovalRemarks);
            this.discountApprovalStatus = Util.GetInt(discountApprovalStatus);
            this.discountApprovalStatusUpdatedBy = Util.GetString(discountApprovalStatusUpdatedBy);
            this.isopeningBalance = Util.GetInt(isopeningBalance);
            this.OpeningBalanceDate = Util.GetDateTime(OpeningBalanceDate);
            /*****************************************/
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


                new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@DoctorID1", DoctorID1),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@Time", Time),
                new MySqlParameter("@DateOfVisit", DateOfVisit),
                new MySqlParameter("@Purpose", Purpose),
                new MySqlParameter("@NextVisitDate", NextVisitDate),
                new MySqlParameter("@FeesPaid", FeesPaid),
                new MySqlParameter("@Remarks", Remarks),
                new MySqlParameter("@VerificationStatus", VerificationStatus),
                new MySqlParameter("@Type", Type),
                new MySqlParameter("@Canceled", Canceled),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@ReferedTransactionID", ReferedTransactionID),
                new MySqlParameter("@EntryType", EntryType),
                new MySqlParameter("@UserID", UserID),
                new MySqlParameter("@EntryDate", EntryDate),
                new MySqlParameter("@ExtractDate", ExtractDate),
                new MySqlParameter("@PanelID", PanelID),
                new MySqlParameter("@Source", Source),
                new MySqlParameter("@ReferedBy", ReferedBy),
                new MySqlParameter("@KinRelation", KinRelation),
                new MySqlParameter("@KinName", KinName),
                new MySqlParameter("@KinPhone", KinPhone),
                new MySqlParameter("@KinAddress", KinAddress),
                new MySqlParameter("@DischargeType", DischargeType),
                new MySqlParameter("@Acc_date", Acc_date),
                new MySqlParameter("@Acc_time", Acc_time),
                new MySqlParameter("@Acc_location", Acc_location),
                new MySqlParameter("@Acc_MLCNO", Acc_MLCNO),
                new MySqlParameter("@Acc_PCNo", Acc_PCNo),
                new MySqlParameter("@Cas_reason", Cas_reason),
                new MySqlParameter("@Visa_No", Visa_No),
                new MySqlParameter("@Visa_ExpiryDate", Visa_ExpiryDate),
                new MySqlParameter("@ParentID", ParentID),
                new MySqlParameter("@ScheduleChargeID", ScheduleChargeID),
                new MySqlParameter("@DiagnosisID", DiagnosisID),
                new MySqlParameter("@Weight", Weight),
                new MySqlParameter("@Height", Height),
                new MySqlParameter("@Allergies", Allergies),
                new MySqlParameter("@Admission_Type", Admission_Type),
                new MySqlParameter("@isAdvance", isAdvance),
                new MySqlParameter("@TransactionID", TransactionID),
                new MySqlParameter("@ProId", ProId),
                new MySqlParameter("@PatientPaybleAmt", PatientPaybleAmt),
                new MySqlParameter("@PanelPaybleAmt", PanelPaybleAmt),
                new MySqlParameter("@PatientPaidAmt", PatientPaidAmt),
                new MySqlParameter("@PanelPaidAmt", PanelPaidAmt),
                new MySqlParameter("@Co_PaymentOn", Co_PaymentOn),

            /***********************************new column start*********************************************************/

           // new MySqlParameter("@TransNo", TransNo),
            new MySqlParameter("@PatientLedgerNo", PatientLedgerNo),
            new MySqlParameter("@BookingCentreID", BookingCentreID),
            new MySqlParameter("@CurrentAge", CurrentAge),
            new MySqlParameter("@Consultant_Name", Consultant_Name),
            new MySqlParameter("@DateOfAdmit", DateOfAdmit),
            new MySqlParameter("@TimeOfAdmit", TimeOfAdmit),
            new MySqlParameter("@DateOfDischarge", DateOfDischarge),
            new MySqlParameter("@TimeOfDischarge", TimeOfDischarge),
            new MySqlParameter("@DischargedBy", DischargedBy),
            new MySqlParameter("@STATUS", STATUS),
            new MySqlParameter("@EmployeeID", EmployeeID),
            new MySqlParameter("@ClaimNo", ClaimNo),
            new MySqlParameter("@CreditLimitType", CreditLimitType),
            new MySqlParameter("@PanelApprovedAmt", PanelApprovedAmt),
            new MySqlParameter("@PanelApprovalDate", PanelApprovalDate),
            new MySqlParameter("@PanelAppRemarks", PanelAppRemarks),
            new MySqlParameter("@PanelAppUserID", PanelAppUserID),
            new MySqlParameter("@BillNo", BillNo),
            new MySqlParameter("@BillDate", BillDate),
            new MySqlParameter("@TotalBilledAmt", TotalBilledAmt),
            new MySqlParameter("@DiscountOnBill", DiscountOnBill),
            new MySqlParameter("@TotalBillDiscPer", TotalBillDiscPer),
            new MySqlParameter("@DiscountOnBillReason", DiscountOnBillReason),
            new MySqlParameter("@DiscUserID", DiscUserID),
            new MySqlParameter("@BillingType", BillingType),
            new MySqlParameter("@ApprovalBy", ApprovalBy),
            new MySqlParameter("@TempBillNo", TempBillNo),
            new MySqlParameter("@Narration", Narration),
            new MySqlParameter("@ServiceTaxAmt", ServiceTaxAmt),
            new MySqlParameter("@ServiceTaxPer", ServiceTaxPer),
            new MySqlParameter("@ServiceTaxSurChgAmt", ServiceTaxSurChgAmt),
            new MySqlParameter("@SerTaxSurChgPer", SerTaxSurChgPer),
            new MySqlParameter("@SerTaxBillAmount", SerTaxBillAmount),
            new MySqlParameter("@S_CountryID", S_CountryID),
            new MySqlParameter("@S_Amount", S_Amount),
            new MySqlParameter("@S_Notation", S_Notation),
            new MySqlParameter("@C_Factor", C_Factor),
            new MySqlParameter("@RoundOff", RoundOff),
            new MySqlParameter("@panelInvoiceNo", panelInvoiceNo),
            new MySqlParameter("@AdmissionCancelledBy", AdmissionCancelledBy),
            new MySqlParameter("@AdmissionCancelReason", AdmissionCancelReason),
            new MySqlParameter("@AdmissionCancelDate", AdmissionCancelDate),
            new MySqlParameter("@DischargedCancelledBy", DischargedCancelledBy),
            new MySqlParameter("@DischargeCancelReason", DischargeCancelReason),
            new MySqlParameter("@DischargeCancelDate", DischargeCancelDate),
            new MySqlParameter("@MRD_IsFile", MRD_IsFile),
            new MySqlParameter("@ReceiveFile_By", ReceiveFile_By),
            new MySqlParameter("@ReceiveFile_Date", ReceiveFile_Date),
            new MySqlParameter("@IsBilledClosed", IsBilledClosed),
            new MySqlParameter("@BillClosedUserID", BillClosedUserID),
            new MySqlParameter("@BillCloseddate", BillCloseddate),
            new MySqlParameter("@BillingRemarks", BillingRemarks),
            new MySqlParameter("@Bill_CountryID", Bill_CountryID),
            new MySqlParameter("@Bill_Notation", Bill_Notation),
            new MySqlParameter("@Bill_Factor", Bill_Factor),
            new MySqlParameter("@IsMail_1hrs", IsMail_1hrs),
            new MySqlParameter("@IsMail_72hrs", IsMail_72hrs),
            new MySqlParameter("@IsTPAInvActive", IsTPAInvActive),
            new MySqlParameter("@TPAInvNo", TPAInvNo),
            new MySqlParameter("@TPAInvDate", TPAInvDate),
            new MySqlParameter("@TPAInvCreatedBy", TPAInvCreatedBy),
            new MySqlParameter("@TPAInvChequeDate", TPAInvChequeDate),
            new MySqlParameter("@TPAInvChequeReceiveDate", TPAInvChequeReceiveDate),
            new MySqlParameter("@TPAInvChequeAmount", TPAInvChequeAmount),
            new MySqlParameter("@IsTPAInvClosed", IsTPAInvClosed),
            new MySqlParameter("@TPAInvClosedDate", TPAInvClosedDate),
            new MySqlParameter("@TPAInvClosedBy", TPAInvClosedBy),
            new MySqlParameter("@TPAInvPaymentRemark", TPAInvPaymentRemark),
            new MySqlParameter("@finalDiscountApproval", finalDiscountApproval),
            new MySqlParameter("@finalDiscReason", finalDiscReason),
            new MySqlParameter("@discountApprovalRemarks", discountApprovalRemarks),
            new MySqlParameter("@discountApprovalStatus", discountApprovalStatus),
            new MySqlParameter("@discountApprovalStatusUpdatedBy", discountApprovalStatusUpdatedBy),
            new MySqlParameter("@isopeningBalance", isopeningBalance),
            new MySqlParameter("@OpeningBalanceDate", OpeningBalanceDate));

            /**************************************************************************************/

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

    public int Delete(string iPkValue)
    {
        this.TransactionID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_medical_history WHERE TransactionID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("TransactionID", TransactionID));

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

            string sSQL = "SELECT * FROM patient_medical_history WHERE TransactionID = ? ";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@TransactionID", TransactionID)).Tables[0];

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

            // Util.WriteLog(ex);
            string sParams = "TransactionID=" + this.TransactionID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string iPkValue)
    {
        this.TransactionID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.HospCode]);
        this.ID = Util.GetLong(dtTemp.Rows[0][AllTables.Patient_Medical_History.ID]);
        this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.TransactionID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.PatientID]);
        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.DoctorID]);
        //this.DoctorID1 = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.DoctorID1]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Hospital_ID]);
        this.Time = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.Time]);
        this.DateOfVisit = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.DateOfVisit]);
        this.Purpose = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Purpose]);
        this.NextVisitDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.NextVisitDate]);
        this.FeesPaid = Util.GetLong(dtTemp.Rows[0][AllTables.Patient_Medical_History.FeesPaid]);
        this.Remarks = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Remarks]);
        this.VerificationStatus = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.VerificationStatus]);
        this.Type = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Type]);
        this.Canceled = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Canceled]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Ownership]);
        this.GroupID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.GroupID]);
        this.ReferedTransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.ReferedTransactionID]);
        this.EntryType = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.EntryType]);
        this.UserID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.UserID]);
        this.EntryDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.EntryDate]);
        this.ExtractDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.ExtractDate]);
        this.Remarks = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Remarks]);
        this.PanelID = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Medical_History.PanelID]);

        this.KinRelation = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.KinRelation]);
        this.KinName = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.KinName]);
        this.KinPhone = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.KinPhone]);
        this.KinAddress = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.KinAddress]);
        this.DischargeType = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.DischargeType]);
        this.Acc_date = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.Acc_date]);
        this.Acc_time = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.Acc_time]);
        this.Acc_location = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Acc_location]);
        this.Acc_MLCNO = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Acc_MLCNO]);
        this.Acc_PCNo = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Acc_PCNo]);
        this.Cas_reason = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Cas_reason]);
        this.Visa_No = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Visa_No]);
        this.Visa_ExpiryDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Medical_History.Visa_ExpiryDate]);
        this.ParentID = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Medical_History.ParentID]);
        this.Weight = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Weight]);
        this.Height = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Height]);
        this.Allergies = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Medical_History.Allergies]);
    }
    #endregion
}
