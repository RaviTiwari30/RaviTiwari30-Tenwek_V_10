using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class LedgerTnxDetail
{
    public LedgerTnxDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public LedgerTnxDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _LedgerTnxID;
    private string _Hospital_Id;
    private string _LedgerTransactionNo;
    private string _ItemID;
    private decimal _Rate;
    private decimal _Amount;
    private decimal _Quantity;
    private string _StockID;
    private string _IsTaxable;
    private decimal _DiscountPercentage;
    private decimal _DiscAmt;
    private string _DiscUserID;
    private int _IsPackage;
    private string _PackageID;
    private int _IsVerified;
    private string _SubCategoryID;
    private string _VarifiedUserID;
    private string _ItemName;
    private string _TransactionID;
    private DateTime _VerifiedDate;
    private string _UserID;
    private DateTime _EntryDate;
    private int _IsFree;
    private int _IsSurgery;
    private string _Surgery_ID;
    private string _SurgeryName;
    private string _DiscountReason;
    private string _DoctorID;
    private decimal _DoctorCharges;
    private int _IsRefund;
    private string _DiscShareOn;
    private string _CancelReason;
    private string _CancelUserId;
    private DateTime _Canceldatetime;
    private int _TnxTypeID;
    private int _IsMedService;
    private string _LastUpdatedBy;
    private DateTime _UpdatedDate;
    private int _ToBeBilled;
    private string _IsReusable;
    private string _Type_ID;
    private string _ServiceItemID;
    private int _ConfigID;
    private int _IsPayable;
    private decimal _TotalDiscAmt;
    private decimal _NetItemAmt;
    private string _Type;
    private int _AfterBill;
    private string _IsAdvance;
    private string _sampleType;
    private string _pageURL;
    private string _IPDCaseType_ID;
    private int _RateListID;
    private int _CentreID;
    private int _IsOutSource;
    private string _OutSourceName;
    private int _PackageType;
    private string _Investigation_ID;
    private string _IsSampleCollected;
    private DateTime _medExpiryDate;
    private int _RoleID;
    private int _IsExpirable;
    private string _IpAddress;

    private int _TransactionType_ID;
    private string _BatchNumber;
    private string _DeptLedgerNo;
    private string _StoreLedgerNo;
    private decimal _PurTaxAmt;
    private decimal _PurTaxPer;
    private decimal _unitPrice;
    private string _rateItemCode;
    private string _MACAddress;
    private int _isEdit;
    private string _Room_ID;
    private int _isPanelWiseDisc;

    [System.ComponentModel.DefaultValue(0.0000)]
    private decimal _CoPayPercent;
    //GST Work
    private string _HSNCode;
    private decimal _IGSTPercent;
    private decimal _IGSTAmt;
    private decimal _SGSTPercent;
    private decimal _SGSTAmt;
    private decimal _CGSTPercent;
    private decimal _CGSTAmt;
    private string _GSTType;
    private string _typeOfTnx;

    //Special Discount 

    private decimal _SpecialDiscPer;
    private decimal _SpecialDiscAmt;


    private decimal _roundOff;

    private int _PanelCurrencyCountryID;
    private decimal _PanelCurrencyFactor;
    private int _isMobileBooking;
    private string categoryid;
    private string tokenno;
    private string _salesID;
    private string _Remark;
    private int _isDocCollect;
    private decimal _docCollectAmt;

    [System.ComponentModel.DefaultValue("1.0000")]
    private decimal _scaleOfCost;

    [System.ComponentModel.DefaultValue("0.0000")]
    private decimal _OtherCharges;

    [System.ComponentModel.DefaultValue("0.0000")]
    private decimal _MarkUpPercent;



    private decimal _TaxPercent;
    private decimal _TaxAmt;

    private string _DoctorNotes;
    private string _typeOfApp;
    private string _appointmentDateTime;
	private string _SCRequestdatetime;
    private string _BookingDate;
    private string _BookingTime;
    private int _BookinginModality;
    private int _pkgValiditydays;
    private int _IsSlotWiseToken;
    private int _appointmentID;


    [System.ComponentModel.DefaultValue(1)]
    private int _SupOrDeptSaleType;

    [System.ComponentModel.DefaultValue(0.0000)]
    private decimal _SupOrDeptSaleTypePer;

    private int _AppointmentNo;
    private string _Refund_Against_BillNo;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string HospCode { get { return _HospCode; } set { _HospCode = value; } }
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string LedgerTnxID { get { return _LedgerTnxID; } set { _LedgerTnxID = value; } }
    public virtual string Hospital_Id { get { return _Hospital_Id; } set { _Hospital_Id = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual string ItemID { get { return _ItemID; } set { _ItemID = value; } }
    public virtual decimal Rate { get { return _Rate; } set { _Rate = value; } }
    public virtual decimal Amount { get { return _Amount; } set { _Amount = value; } }
    public virtual decimal Quantity { get { return _Quantity; } set { _Quantity = value; } }
    public virtual string StockID { get { return _StockID; } set { _StockID = value; } }
    public virtual string IsTaxable { get { return _IsTaxable; } set { _IsTaxable = value; } }
    public virtual decimal DiscountPercentage { get { return _DiscountPercentage; } set { _DiscountPercentage = value; } }
    public virtual decimal DiscAmt { get { return _DiscAmt; } set { _DiscAmt = value; } }
    public virtual string DiscUserID { get { return _DiscUserID; } set { _DiscUserID = value; } }
    public virtual int IsPackage { get { return _IsPackage; } set { _IsPackage = value; } }
    public virtual string PackageID { get { return _PackageID; } set { _PackageID = value; } }
    public virtual int IsVerified { get { return _IsVerified; } set { _IsVerified = value; } }
    public virtual string SubCategoryID { get { return _SubCategoryID; } set { _SubCategoryID = value; } }
    public virtual string VarifiedUserID { get { return _VarifiedUserID; } set { _VarifiedUserID = value; } }
    public virtual string ItemName { get { return _ItemName; } set { _ItemName = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime VerifiedDate { get { return _VerifiedDate; } set { _VerifiedDate = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual int IsFree { get { return _IsFree; } set { _IsFree = value; } }
    public virtual int IsSurgery { get { return _IsSurgery; } set { _IsSurgery = value; } }
    public virtual string SurgeryID { get { return _Surgery_ID; } set { _Surgery_ID = value; } }
    public virtual string SurgeryName { get { return _SurgeryName; } set { _SurgeryName = value; } }
    public virtual string DiscountReason { get { return _DiscountReason; } set { _DiscountReason = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual decimal DoctorCharges { get { return _DoctorCharges; } set { _DoctorCharges = value; } }
    public virtual int IsRefund { get { return _IsRefund; } set { _IsRefund = value; } }
    public virtual string DiscShareOn { get { return _DiscShareOn; } set { _DiscShareOn = value; } }
    public virtual string CancelReason { get { return _CancelReason; } set { _CancelReason = value; } }
    public virtual string CancelUserId { get { return _CancelUserId; } set { _CancelUserId = value; } }
    public virtual DateTime Canceldatetime { get { return _Canceldatetime; } set { _Canceldatetime = value; } }
    public virtual int TnxTypeID { get { return _TnxTypeID; } set { _TnxTypeID = value; } }
    public virtual int IsMedService { get { return _IsMedService; } set { _IsMedService = value; } }
    public virtual string LastUpdatedBy { get { return _LastUpdatedBy; } set { _LastUpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }
    public virtual int ToBeBilled { get { return _ToBeBilled; } set { _ToBeBilled = value; } }
    public virtual string IsReusable { get { return _IsReusable; } set { _IsReusable = value; } }
    public virtual string Type_ID { get { return _Type_ID; } set { _Type_ID = value; } }
    public virtual string ServiceItemID { get { return _ServiceItemID; } set { _ServiceItemID = value; } }
    public virtual decimal TotalDiscAmt { get { return _TotalDiscAmt; } set { _TotalDiscAmt = value; } }
    public virtual decimal NetItemAmt { get { return _NetItemAmt; } set { _NetItemAmt = value; } }
    public virtual string Type { get { return _Type; } set { _Type = value; } }
    public virtual string IsAdvance { get { return _IsAdvance; } set { _IsAdvance = value; } }
    public virtual int IsOutSource { get { return _IsOutSource; } set { _IsOutSource = value; } }
    public virtual int IsDischargeMedicine { get { return _IsOutSource; } set { _IsOutSource = value; } }
    public virtual string Remark { get { return _Remark; } set { _Remark = value; } }
    [System.ComponentModel.DefaultValue(0.00)]
    public virtual decimal roundOff { get { return _roundOff; } set { _roundOff = value; } }


    [System.ComponentModel.DefaultValue(0)]
    public virtual int panelCurrencyCountryID { get { return _PanelCurrencyCountryID; } set { _PanelCurrencyCountryID = value; } }

    [System.ComponentModel.DefaultValue(1.00)]
    public virtual decimal panelCurrencyFactor { get { return _PanelCurrencyFactor; } set { _PanelCurrencyFactor = value; } }

    public int ConfigID
    {
        get { return _ConfigID; }
        set { _ConfigID = value; }
    }
    public virtual int IsPayable
    {
        get
        { return _IsPayable; }
        set
        { _IsPayable = value; }
    }
    public virtual int AfterBill { get { return _AfterBill; } set { _AfterBill = value; } }
    public virtual string sampleType { get { return _sampleType; } set { _sampleType = value; } }
    public virtual string pageURL { get { return _pageURL; } set { _pageURL = value; } }
    public virtual string IPDCaseTypeID { get { return _IPDCaseType_ID; } set { _IPDCaseType_ID = value; } }
    public virtual int RateListID { get { return _RateListID; } set { _RateListID = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual int isEdit { get { return _isEdit; } set { _isEdit = value; } }
    public virtual string OutSourceName
    {
        get
        {
            return _OutSourceName;
        }
        set
        {
            _OutSourceName = value;
        }
    }
    public virtual int PackageType { get { return _PackageType; } set { _PackageType = value; } }
    public virtual string Investigation_ID { get { return _Investigation_ID; } set { _Investigation_ID = value; } }
    public virtual string IsSampleCollected { get { return _IsSampleCollected; } set { _IsSampleCollected = value; } }
    public virtual DateTime medExpiryDate { get { return _medExpiryDate; } set { _medExpiryDate = value; } }
    public virtual int RoleID { get { return _RoleID; } set { _RoleID = value; } }
    public virtual int IsExpirable { get { return _IsExpirable; } set { _IsExpirable = value; } }
    public virtual string IpAddress { get { return _IpAddress; } set { _IpAddress = value; } }

    public virtual int TransactionType_ID { get { return _TransactionType_ID; } set { _TransactionType_ID = value; } }
    public virtual string BatchNumber { get { return _BatchNumber; } set { _BatchNumber = value; } }
    public virtual string DeptLedgerNo { get { return _DeptLedgerNo; } set { _DeptLedgerNo = value; } }
    public virtual string StoreLedgerNo { get { return _StoreLedgerNo; } set { _StoreLedgerNo = value; } }
    public virtual decimal PurTaxAmt { get { return _PurTaxAmt; } set { _PurTaxAmt = value; } }
    public virtual decimal PurTaxPer { get { return _PurTaxPer; } set { _PurTaxPer = value; } }
    public virtual decimal unitPrice { get { return _unitPrice; } set { _unitPrice = value; } }
    public virtual string rateItemCode { get { return _rateItemCode; } set { _rateItemCode = value; } }
    public virtual string MACAddress { get { return _MACAddress; } set { _MACAddress = value; } }
    public virtual string RoomID { get { return _Room_ID; } set { _Room_ID = value; } }
    public virtual int isPanelWiseDisc { get { return _isPanelWiseDisc; } set { _isPanelWiseDisc = value; } }
    //GST Work
    public virtual string HSNCode { get { return _HSNCode; } set { _HSNCode = value; } }
    public virtual decimal IGSTPercent { get { return _IGSTPercent; } set { _IGSTPercent = value; } }
    public virtual decimal IGSTAmt { get { return _IGSTAmt; } set { _IGSTAmt = value; } }
    public virtual decimal SGSTPercent { get { return _SGSTPercent; } set { _SGSTPercent = value; } }
    public virtual decimal SGSTAmt { get { return _SGSTAmt; } set { _SGSTAmt = value; } }
    public virtual decimal CGSTPercent { get { return _CGSTPercent; } set { _CGSTPercent = value; } }
    public virtual decimal CGSTAmt { get { return _CGSTAmt; } set { _CGSTAmt = value; } }
    public virtual string GSTType { get { return _GSTType; } set { _GSTType = value; } }

    public virtual string typeOfTnx { get { return _typeOfTnx; } set { _typeOfTnx = value; } }
    public virtual decimal CoPayPercent { get { return _CoPayPercent; } set { _CoPayPercent = value; } }

    // Special Discount
    public virtual decimal SpecialDiscPer { get { return _SpecialDiscPer; } set { _SpecialDiscPer = value; } }
    public virtual decimal SpecialDiscAmt { get { return _SpecialDiscAmt; } set { _SpecialDiscAmt = value; } }
    public virtual int isMobileBooking { get { return _isMobileBooking; } set { _isMobileBooking = value; } }

    public virtual string CategoryID
    {
        get { return categoryid; }
        set { categoryid = value; }
    }

    public virtual string TokenNo
    {
        get { return tokenno; }
        set { tokenno = value; }
    }




    public string salesID
    {
        get { return _salesID; }
        set { _salesID = value; }
    }


    public decimal scaleOfCost
    {
        get { return _scaleOfCost; }
        set { _scaleOfCost = value; }
    }


    public decimal OtherCharges
    {
        get { return _OtherCharges; }
        set { _OtherCharges = value; }
    }
    public decimal MarkUpPercent
    {
        get { return _MarkUpPercent; }
        set { _MarkUpPercent = value; }
    }


    public decimal TaxPercent
    {
        get { return _TaxPercent; }
        set { _TaxPercent = value; }
    }

    public decimal TaxAmt
    {
        get { return _TaxAmt; }
        set { _TaxAmt = value; }
    }

    public int isDocCollect
    {
        get { return _isDocCollect; }
        set { _isDocCollect = value; }
    }
    public decimal docCollectAmt
    {
        get { return _docCollectAmt; }
        set { _docCollectAmt = value; }
    }
    public string DoctorNotes
    {
        get { return _DoctorNotes; }
        set { _DoctorNotes = value; }
    }

    public string typeOfApp
    {
        get { return _typeOfApp; }
        set { _typeOfApp = value; }
    }

    public string appointmentDateTime
    {
        get { return _appointmentDateTime; }
        set { _appointmentDateTime = value; }
    }
	public string SCRequestdatetime
    {
        get { return _SCRequestdatetime; }
        set { _SCRequestdatetime = value; }
    
    }
    public virtual string BookingDate { get { return _BookingDate; } set { _BookingDate = value; } }
    public virtual string BookingTime { get { return _BookingTime; } set { _BookingTime = value; } }
    public virtual int BookinginModality { get { return _BookinginModality; } set { _BookinginModality = value; } }
    public virtual int PkgValiditydays { get { return _pkgValiditydays; } set { _pkgValiditydays = value; } }
    public virtual int IsSlotWiseToken { get { return _IsSlotWiseToken; } set { _IsSlotWiseToken = value; } }
    public virtual int appointmentID { get { return _appointmentID; } set { _appointmentID = value; } }


    public virtual int SupOrDeptSaleType { get { return _SupOrDeptSaleType; } set { _SupOrDeptSaleType = value; } }
    public virtual decimal SupOrDeptSaleTypePer { get { return _SupOrDeptSaleTypePer; } set { _SupOrDeptSaleTypePer = value; } }

    public virtual int AppointmentNo { get { return _AppointmentNo; } set { _AppointmentNo = value; } }

    public virtual string Refund_Against_BillNo { get { return _Refund_Against_BillNo; } set { _Refund_Against_BillNo = value; } }
    
    #endregion

    #region All Public Member Function
    public int Insert()
    {

        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("f_ledgertnxdetail_insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";
            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 10;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", Util.GetString(HospCode)));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_Id", Util.GetString(Hospital_Id)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", Util.GetString(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@vRate", Util.GetDecimal(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@vAmount", Util.GetDecimal(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@vQuantity", Util.GetDecimal(Quantity)));
            cmd.Parameters.Add(new MySqlParameter("@vStockID", Util.GetString(StockID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsTaxable", Util.GetString(IsTaxable)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountPercentage", Util.GetDecimal(DiscountPercentage)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscAmt", Util.GetDecimal(DiscAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscUserID", Util.GetString(DiscUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPackage", Util.GetInt(IsPackage)));
            cmd.Parameters.Add(new MySqlParameter("@vPackageID", Util.GetString(PackageID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVerified", Util.GetInt(IsVerified)));
            cmd.Parameters.Add(new MySqlParameter("@vSubCategoryID", Util.GetString(SubCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@vVarifiedUserID", Util.GetString(VarifiedUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vVerifiedDate", Util.GetDateTime(VerifiedDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFree", Util.GetInt(IsFree)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSurgery", Util.GetInt(IsSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryID", Util.GetString(SurgeryID)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryName", Util.GetString(SurgeryName)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountReason", Util.GetString(DiscountReason)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorCharges", Util.GetDecimal(DoctorCharges)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRefund", Util.GetInt(IsRefund)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscShareOn", Util.GetString(DiscShareOn)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelReason", Util.GetString(CancelReason)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelUserId", Util.GetString(CancelUserId)));
            cmd.Parameters.Add(new MySqlParameter("@vCanceldatetime", Util.GetDateTime(Canceldatetime)));
            cmd.Parameters.Add(new MySqlParameter("@vTnxTypeID", Util.GetInt(TnxTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsMedService", Util.GetInt(IsMedService)));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedBy", Util.GetString(LastUpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));
            cmd.Parameters.Add(new MySqlParameter("@vToBeBilled", Util.GetInt(ToBeBilled)));
            cmd.Parameters.Add(new MySqlParameter("@vIsReusable", Util.GetString(IsReusable)));
            cmd.Parameters.Add(new MySqlParameter("@vType_ID", Util.GetString(Type_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vServiceItemID", Util.GetString(ServiceItemID)));
            cmd.Parameters.Add(new MySqlParameter("@vConfigID", Util.GetInt(ConfigID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPayable", Util.GetInt(IsPayable)));
            cmd.Parameters.Add(new MySqlParameter("@vTotalDiscAmt", Util.GetDecimal(TotalDiscAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vNetItemAmt", Util.GetDecimal(NetItemAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vAfterBill", Util.GetInt(AfterBill)));
            cmd.Parameters.Add(new MySqlParameter("@vpageURL", Util.GetString(pageURL)));
            cmd.Parameters.Add(new MySqlParameter("@vIPDCaseTypeID", Util.GetString(IPDCaseTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@vRateListID", Util.GetInt(RateListID)));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vmedExpiryDate", Util.GetDateTime(medExpiryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vRoleID", Util.GetInt(RoleID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsExpirable", Util.GetInt(IsExpirable)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));

            cmd.Parameters.Add(new MySqlParameter("@vTransactionType_ID", Util.GetInt(TransactionType_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vBatchNumber", Util.GetString(BatchNumber)));
            cmd.Parameters.Add(new MySqlParameter("@vDeptLedgerNo", Util.GetString(DeptLedgerNo)));
            cmd.Parameters.Add(new MySqlParameter("@vStoreLedgerNo", Util.GetString(StoreLedgerNo)));
            cmd.Parameters.Add(new MySqlParameter("@vPurTaxAmt", Util.GetDecimal(PurTaxAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vPurTaxPer", Util.GetDecimal(PurTaxPer)));
            cmd.Parameters.Add(new MySqlParameter("@vunitPrice", Util.GetDecimal(unitPrice)));
            cmd.Parameters.Add(new MySqlParameter("@vrateItemCode", Util.GetString(rateItemCode)));
            cmd.Parameters.Add(new MySqlParameter("@vMACAddress", Util.GetString(MACAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vRoomID", Util.GetString(RoomID)));
            cmd.Parameters.Add(new MySqlParameter("@visPanelWiseDisc", Util.GetInt(isPanelWiseDisc)));
            //GST Work
            cmd.Parameters.Add(new MySqlParameter("@vHSNCode", Util.GetString(HSNCode)));
            cmd.Parameters.Add(new MySqlParameter("@vIGSTPer", Util.GetString(IGSTPercent)));
            cmd.Parameters.Add(new MySqlParameter("@vIGSTAmt", Util.GetString(IGSTAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vSGSTPer", Util.GetString(SGSTPercent)));
            cmd.Parameters.Add(new MySqlParameter("@vSGSTAmt", Util.GetString(SGSTAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vCGSTPer", Util.GetString(CGSTPercent)));
            cmd.Parameters.Add(new MySqlParameter("@vCGSTAmt", Util.GetString(CGSTAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vGSTType", Util.GetString(GSTType)));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfTnx", Util.GetString(typeOfTnx)));

            //Special Discount

            cmd.Parameters.Add(new MySqlParameter("@vSpecialDiscPer", Util.GetString(SpecialDiscPer)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecialDiscAmt", Util.GetString(SpecialDiscAmt)));

            cmd.Parameters.Add(new MySqlParameter("@vRoundOff", Util.GetString(roundOff)));
            cmd.Parameters.Add(new MySqlParameter("@vCoPayPercent", Util.GetString(CoPayPercent)));

            cmd.Parameters.Add(new MySqlParameter("@vPanelCurrencyCountryID", Util.GetInt(panelCurrencyCountryID)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelCurrencyFactor", Util.GetDecimal(panelCurrencyFactor)));
            cmd.Parameters.Add(new MySqlParameter("@vTokenNo", Util.GetString(TokenNo)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDischargeMedicine", Util.GetInt(IsDischargeMedicine)));
            cmd.Parameters.Add(new MySqlParameter("@vScaleOfCost", Util.GetDecimal(scaleOfCost)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherCharges", Util.GetDecimal(OtherCharges)));
            cmd.Parameters.Add(new MySqlParameter("@vMarkUpPercent", Util.GetDecimal(MarkUpPercent)));
            cmd.Parameters.Add(new MySqlParameter("@vremarks", Util.GetString(Remark)));
            cmd.Parameters.Add(paramTnxID);
            ID = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ID;
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
