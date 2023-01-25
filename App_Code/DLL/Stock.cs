using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class Stock
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _StockID;
    private string _Hospital_ID;
    private string _ItemID;
    private string _ItemName;
    private string _LedgerTransactionNo;
    private string _BatchNumber;
    private decimal _UnitPrice;
    private decimal _MRP;
    private int _IsCountable;
    private decimal _InitialCount;
    private decimal _ReleasedCount;
    private int _IsReturn;
    private string _LedgerNo;
    private DateTime _MedExpiryDate;
    private DateTime _StockDate;
    private string _StoreLedgerNo;
    private int _IsPost;
    private string _Naration;
    private DateTime _PostDate;
    private int _IsFree;
    private string _SubCategoryID;
    private string _DeptLedgerNo;
    private string _FromDept;
    private string _FromStockID;
    private decimal _PendingQty;
    private string _IndentNo;
    private double _RejectQty;
    private string _UserID;
    private string _PostUserID;

    private decimal _Rate;
    private decimal _DiscPer;
    private decimal _DiscAmt;
    private decimal _PurTaxPer;
    private decimal _PurTaxAmt;
    private decimal _SaleTaxPer;
    private decimal _SaleTaxAmt;
    private string _TYPE;
    private int _Reusable;
    private int _IsBilled;
    private int _ConsignmentID;

    private string _MajorUnit;
    private string _MinorUnit;
    private decimal _ConversionFactor;
    private decimal _MajorMRP;
    private string _taxCalculateOn;
    private string _TypeOfTnx;
    private string _InvoiceNo;
    private string _ChalanNo;
    private DateTime _InvoiceDate;
    private string _IsCompleteInvoice;
    private DateTime _ChalanDate;
    private string _PONumber;
    private DateTime _PODate;
    private string _VenLedgerNo;
    private string _LedgerTnxNo;
    private decimal _InvoiceAmount;
    private decimal _DiffBillAmt;
    private decimal _ExcisePer;
    private decimal _ExciseAmt;
    private int _CentreID;
    private string _IpAddress;
    private int _IsExpirable;
    private int _LaundryDirty;
    private int _isOTReturn;
    private string _isdeal;

    // GST Work
    private string _HSNCode;
    private string _GSTType;
    private decimal _IGSTPercent;
    private decimal _IGSTAmtPerUnit;
    private decimal _SGSTPercent;
    private decimal _SGSTAmtPerUnit;
    private decimal _CGSTPercent;
    private decimal _CGSTAmtPerUnit;
    //
    //Special Discount 
    private decimal _SpecialDiscPer;
    private decimal _SpecialDiscAmt;
    private int _salesno;
    private int _IsAsset;
    private int _CurrencyCountryID;
    private string _Currency;
    private decimal _CurrencyFactor;

    [System.ComponentModel.DefaultValue("0.0000")]
    private decimal _OtherCharges;

    [System.ComponentModel.DefaultValue("0.0000")]
    private decimal _MarkUpPercent;

    [System.ComponentModel.DefaultValue("0.0000")]
    private decimal _LandingCost;

    private string _ReferenceNo;

    private int _BarCodeID;
    [System.ComponentModel.DefaultValue("0")]
    private int _FromCentreID;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Stock()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public Stock(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property
    public virtual string ReferenceNo { get { return _ReferenceNo;  } set { _ReferenceNo = value; } }
    public virtual string IndentNo
    {
        get
        {
            return _IndentNo;
        }
        set
        {
            _IndentNo = value;
        }
    }

    public virtual decimal PendingQty
    {
        get
        {
            return _PendingQty;
        }
        set
        {
            _PendingQty = value;
        }
    }

    public virtual string FromStockID
    {
        get
        {
            return _FromStockID;
        }
        set
        {
            _FromStockID = value;
        }
    }

    public virtual string FromDept
    {
        get
        {
            return _FromDept;
        }
        set
        {
            _FromDept = value;
        }
    }

    public virtual string DeptLedgerNo
    {
        get
        {
            return _DeptLedgerNo;
        }
        set
        {
            _DeptLedgerNo = value;
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

    public virtual string StockID
    {
        get
        {
            return _StockID;
        }
        set
        {
            _StockID = value;
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

    public virtual string ItemID
    {
        get
        {
            return _ItemID;
        }
        set
        {
            _ItemID = value;
        }
    }

    public virtual string ItemName
    {
        get
        {
            return _ItemName;
        }
        set
        {
            _ItemName = value;
        }
    }

    public virtual string LedgerTransactionNo
    {
        get
        {
            return _LedgerTransactionNo;
        }
        set
        {
            _LedgerTransactionNo = value;
        }
    }

    public virtual string BatchNumber
    {
        get
        {
            return _BatchNumber;
        }
        set
        {
            _BatchNumber = value;
        }
    }

    public virtual decimal UnitPrice
    {
        get
        {
            return _UnitPrice;
        }
        set
        {
            _UnitPrice = value;
        }
    }

    public virtual decimal MRP
    {
        get
        {
            return _MRP;
        }
        set
        {
            _MRP = value;
        }
    }

    public virtual int IsCountable
    {
        get
        {
            return _IsCountable;
        }
        set
        {
            _IsCountable = value;
        }
    }

    public virtual decimal InitialCount
    {
        get
        {
            return _InitialCount;
        }
        set
        {
            _InitialCount = value;
        }
    }

    public virtual decimal ReleasedCount
    {
        get
        {
            return _ReleasedCount;
        }
        set
        {
            _ReleasedCount = value;
        }
    }

    public virtual int IsReturn
    {
        get
        {
            return _IsReturn;
        }
        set
        {
            _IsReturn = value;
        }
    }

    public virtual string LedgerNo
    {
        get
        {
            return _LedgerNo;
        }
        set
        {
            _LedgerNo = value;
        }
    }

    public virtual DateTime MedExpiryDate
    {
        get
        {
            return _MedExpiryDate;
        }
        set
        {
            _MedExpiryDate = value;
        }
    }

    public virtual DateTime StockDate
    {
        get
        {
            return _StockDate;
        }
        set
        {
            _StockDate = value;
        }
    }

    public virtual string StoreLedgerNo
    {
        get
        {
            return _StoreLedgerNo;
        }
        set
        {
            _StoreLedgerNo = value;
        }
    }

    public virtual int IsPost
    {
        get
        {
            return _IsPost;
        }
        set
        {
            _IsPost = value;
        }
    }

    public virtual string Naration
    {
        get
        {
            return _Naration;
        }
        set
        {
            _Naration = value;
        }
    }

    public virtual DateTime PostDate
    {
        get
        {
            return _PostDate;
        }
        set
        {
            _PostDate = value;
        }
    }

    public virtual int IsFree
    {
        get
        {
            return _IsFree;
        }
        set
        {
            _IsFree = value;
        }
    }

    private string _Unit;

    public virtual string Unit
    {
        get
        {
            return _Unit;
        }
        set
        {
            _Unit = value;
        }
    }

    public virtual string SubCategoryID
    {
        get
        {
            return _SubCategoryID;
        }
        set
        {
            _SubCategoryID = value;
        }
    }

    public virtual double RejectQty
    {
        get
        {
            return _RejectQty;
        }
        set
        {
            _RejectQty = value;
        }
    }

    public virtual decimal Rate
    {
        get { return _Rate; }
        set { _Rate = value; }
    }

    public virtual decimal DiscPer
    {
        get { return _DiscPer; }
        set { _DiscPer = value; }
    }

    public virtual decimal DiscAmt
    {
        get { return _DiscAmt; }
        set { _DiscAmt = value; }
    }

    public virtual decimal PurTaxPer
    {
        get { return _PurTaxPer; }
        set { _PurTaxPer = value; }
    }

    public virtual decimal PurTaxAmt
    {
        get { return _PurTaxAmt; }
        set { _PurTaxAmt = value; }
    }

    public virtual decimal SaleTaxPer
    {
        get { return _SaleTaxPer; }
        set { _SaleTaxPer = value; }
    }

    public virtual decimal SaleTaxAmt
    {
        get { return _SaleTaxAmt; }
        set { _SaleTaxAmt = value; }
    }

    public virtual string TYPE
    {
        get { return _TYPE; }
        set { _TYPE = value; }
    }

    public virtual int Reusable
    {
        get { return _Reusable; }
        set { _Reusable = value; }
    }

    public virtual int IsBilled
    {
        get { return _IsBilled; }
        set { _IsBilled = value; }
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

    public virtual string PostUserID
    {
        get
        {
            return _PostUserID;
        }
        set
        {
            _PostUserID = value;
        }
    }

    public virtual int ConsignmentID
    {
        get
        {
            return _ConsignmentID;
        }
        set
        {
            _ConsignmentID = value;
        }
    }

    private int _IsSet;

    public int IsSet
    {
        get { return _IsSet; }
        set { _IsSet = value; }
    }

    private int _SetID;

    public int SetID
    {
        get { return _SetID; }
        set { _SetID = value; }
    }

    private string _SetStockID;

    public string SetStockID
    {
        get { return _SetStockID; }
        set { _SetStockID = value; }
    }

    private int _IsSterlize;

    public int IsSterlize
    {
        get { return _IsSterlize; }
        set { _IsSterlize = value; }
    }

    private int _SetStockQty;

    public int SetStockQty
    {
        get { return _SetStockQty; }
        set { _SetStockQty = value; }
    }

    public string MajorUnit
    {
        get { return _MajorUnit; }
        set { _MajorUnit = value; }
    }

    public string MinorUnit
    {
        get { return _MinorUnit; }
        set { _MinorUnit = value; }
    }

    public decimal ConversionFactor
    {
        get { return _ConversionFactor; }
        set { _ConversionFactor = value; }
    }

    public decimal MajorMRP
    {
        get { return _MajorMRP; }
        set { _MajorMRP = value; }
    }

    public string taxCalculateOn
    {
        get { return _taxCalculateOn; }
        set { _taxCalculateOn = value; }
    }

    public string TypeOfTnx
    {
        get { return _TypeOfTnx; }
        set { _TypeOfTnx = value; }
    }

    public string InvoiceNo
    {
        get { return _InvoiceNo; }
        set { _InvoiceNo = value; }
    }

    public string ChalanNo
    {
        get { return _ChalanNo; }
        set { _ChalanNo = value; }
    }

    public DateTime InvoiceDate
    {
        get { return _InvoiceDate; }
        set { _InvoiceDate = value; }
    }

    public string IsCompleteInvoice
    {
        get { return _IsCompleteInvoice; }
        set { _IsCompleteInvoice = value; }
    }

    public DateTime ChalanDate
    {
        get { return _ChalanDate; }
        set { _ChalanDate = value; }
    }

    public string PONumber
    {
        get { return _PONumber; }
        set { _PONumber = value; }
    }

    public DateTime PODate
    {
        get { return _PODate; }
        set { _PODate = value; }
    }

    public string VenLedgerNo
    {
        get { return _VenLedgerNo; }
        set { _VenLedgerNo = value; }
    }

    public string LedgerTnxNo
    {
        get { return _LedgerTnxNo; }
        set { _LedgerTnxNo = value; }
    }

    public decimal InvoiceAmount
    {
        get { return _InvoiceAmount; }
        set { _InvoiceAmount = value; }
    }

    public decimal DiffBillAmt
    {
        get { return _DiffBillAmt; }
        set { _DiffBillAmt = value; }
    }

    public decimal ExcisePer
    {
        get { return _ExcisePer; }
        set { _ExcisePer = value; }
    }

    public decimal ExciseAmt
    {
        get { return _ExciseAmt; }
        set { _ExciseAmt = value; }
    }

    public int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }

    public string IpAddress
    {
        get { return _IpAddress; }
        set { _IpAddress = value; }
    }

    public int IsExpirable
    {
        get { return _IsExpirable; }
        set { _IsExpirable = value; }
    }
    public virtual int LaundryDirty
    {
        get
        {
            return _LaundryDirty;
        }
        set
        {
            _LaundryDirty = value;
        }
    }
    public virtual int isOTReturn
    {
        get
        {
            return _isOTReturn;
        }
        set
        {
            _isOTReturn = value;
        }
    }
    public virtual string isDeal
    {
        get
        {
            return _isdeal;
        }
        set
        {
            _isdeal = value;
        }
    }

    // GST Work
    public virtual string HSNCode { get { return _HSNCode; } set { _HSNCode = value; } }
    public virtual string GSTType { get { return _GSTType; } set { _GSTType = value; } }
    public virtual decimal IGSTPercent { get { return _IGSTPercent; } set { _IGSTPercent = value; } }
    public virtual decimal IGSTAmtPerUnit { get { return _IGSTAmtPerUnit; } set { _IGSTAmtPerUnit = value; } }
    public virtual decimal SGSTPercent { get { return _SGSTPercent; } set { _SGSTPercent = value; } }
    public virtual decimal SGSTAmtPerUnit { get { return _SGSTAmtPerUnit; } set { _SGSTAmtPerUnit = value; } }
    public virtual decimal CGSTPercent { get { return _CGSTPercent; } set { _CGSTPercent = value; } }
    public virtual decimal CGSTAmtPerUnit { get { return _CGSTAmtPerUnit; } set { _CGSTAmtPerUnit = value; } }
    //
    //Special Discount
    public virtual decimal SpecialDiscPer { get { return _SpecialDiscPer; } set { _SpecialDiscPer = value; } }
    public virtual decimal SpecialDiscAmt { get { return _SpecialDiscAmt; } set { _SpecialDiscAmt = value; } }
    public virtual int salesno { get { return _salesno; } set { _salesno = value; } }
    public virtual int IsAsset { get { return _IsAsset; } set { _IsAsset = value; } }


    public virtual decimal OtherCharges { get { return _OtherCharges; } set { _OtherCharges = value; } }
    public virtual decimal MarkUpPercent { get { return _MarkUpPercent; } set { _MarkUpPercent = value; } }
    public virtual decimal LandingCost { get { return _LandingCost; } set { _LandingCost = value; } }

    public virtual int CurrencyCountryID { get { return _CurrencyCountryID; } set { _CurrencyCountryID = value; } }
    public virtual string Currency { get { return _Currency; } set { _Currency = value; } }
    public virtual decimal CurrencyFactor { get { return _CurrencyFactor; } set { _CurrencyFactor = value; } }

    public virtual int BarCodeID { get { return _BarCodeID; } set { _BarCodeID = value; } }
    public virtual int FromCentreID { get { return _FromCentreID; } set { _FromCentreID = value; } }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Stock");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter Stock_ID = new MySqlParameter();
            Stock_ID.ParameterName = "@StockID";

            Stock_ID.MySqlDbType = MySqlDbType.VarChar;
            Stock_ID.Size = 50;
            Stock_ID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.ItemID = Util.GetString(ItemID);
            this.ItemName = Util.GetString(ItemName);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.BatchNumber = Util.GetString(BatchNumber);
            this.UnitPrice = Util.GetDecimal(UnitPrice);
            this.MRP = Util.GetDecimal(MRP);
            this.IsCountable = Util.GetInt(IsCountable);
            this.InitialCount = Util.GetDecimal(InitialCount);
            this.ReleasedCount = Util.GetInt(ReleasedCount);
            this.IsReturn = Util.GetInt(IsReturn);
            this.LedgerNo = Util.GetString(LedgerNo);
            this.MedExpiryDate = Util.GetDateTime(MedExpiryDate);
            this.StockDate = Util.GetDateTime(StockDate);
            this.StoreLedgerNo = Util.GetString(StoreLedgerNo);
            this.IsPost = Util.GetInt(IsPost);
            this.Naration = Util.GetString(Naration);
            this.PostDate = Util.GetDateTime(PostDate);
            this.IsFree = Util.GetInt(IsFree);
            this.SubCategoryID = Util.GetString(SubCategoryID);
            this.Unit = Util.GetString(Unit);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.FromDept = Util.GetString(FromDept);
            this.FromStockID = Util.GetString(FromStockID);
            this.PendingQty = Util.GetDecimal(PendingQty);
            this.IndentNo = Util.GetString(IndentNo);
            this.RejectQty = Util.GetDouble(RejectQty);
            this.UserID = Util.GetString(UserID);
            this.PostUserID = Util.GetString(PostUserID);
            this.Rate = Util.GetDecimal(Rate);
            this.DiscPer = Util.GetDecimal(DiscPer);
            this.DiscAmt = Util.GetDecimal(DiscAmt);
            this.PurTaxPer = Util.GetDecimal(PurTaxPer);
            this.PurTaxAmt = Util.GetDecimal(PurTaxAmt);
            this.SaleTaxPer = Util.GetDecimal(SaleTaxPer);
            this.SaleTaxAmt = Util.GetDecimal(SaleTaxAmt);
            this.TYPE = Util.GetString(TYPE);
            this.Reusable = Util.GetInt(Reusable);
            this.IsBilled = Util.GetInt(IsBilled);
            this.ConsignmentID = Util.GetInt(ConsignmentID);
            this.IsSet = Util.GetInt(IsSet);
            this.SetID = Util.GetInt(SetID);
            this.SetStockID = Util.GetString(SetStockID);
            this.IsSterlize = Util.GetInt(IsSterlize);
            this.SetStockQty = Util.GetInt(SetStockQty);
            this.MajorUnit = Util.GetString(MajorUnit);
            this.MinorUnit = Util.GetString(MinorUnit);
            this.ConversionFactor = Util.GetDecimal(ConversionFactor);
            this.MajorMRP = Util.GetDecimal(MajorMRP);
            this.taxCalculateOn = Util.GetString(taxCalculateOn);
            this.TypeOfTnx = Util.GetString(TypeOfTnx);
            this.InvoiceNo = Util.GetString(InvoiceNo);
            this.ChalanNo = Util.GetString(ChalanNo);
            this.InvoiceDate = Util.GetDateTime(InvoiceDate);
            this.IsCompleteInvoice = Util.GetString(IsCompleteInvoice);
            this.ChalanDate = Util.GetDateTime(ChalanDate);
            this.PONumber = Util.GetString(PONumber);
            this.PODate = Util.GetDateTime(PODate);
            this.VenLedgerNo = Util.GetString(VenLedgerNo);
            this.LedgerTnxNo = Util.GetString(LedgerTnxNo);
            this.InvoiceAmount = Util.GetDecimal(InvoiceAmount);
            this.DiffBillAmt = Util.GetDecimal(DiffBillAmt);
            this.ExcisePer = Util.GetDecimal(_ExcisePer);
            this.ExciseAmt = Util.GetDecimal(ExciseAmt);
            this.CentreID = Util.GetInt(CentreID);
            this.IpAddress = Util.GetString(IpAddress);
            this.IsExpirable = Util.GetInt(IsExpirable);
            this.LaundryDirty = Util.GetInt(LaundryDirty);
            this.isOTReturn = Util.GetInt(isOTReturn);
            this.isDeal = Util.GetString(isDeal);

            // GST Work
            this.HSNCode = Util.GetString(HSNCode);
            this.GSTType = Util.GetString(GSTType);
            this.IGSTPercent = Util.GetDecimal(IGSTPercent);
            this.IGSTAmtPerUnit = Util.GetDecimal(IGSTAmtPerUnit);
            this.SGSTPercent = Util.GetDecimal(SGSTPercent);
            this.SGSTAmtPerUnit = Util.GetDecimal(SGSTAmtPerUnit);
            this.CGSTPercent = Util.GetDecimal(CGSTPercent);
            this.CGSTAmtPerUnit = Util.GetDecimal(CGSTAmtPerUnit);
            //
            //Special Discount
            this.SpecialDiscPer = Util.GetDecimal(SpecialDiscPer);
            this.SpecialDiscAmt = Util.GetDecimal(SpecialDiscAmt);
            this.IsAsset = Util.GetInt(IsAsset);
            this.salesno = Util.GetInt(salesno);
            this.OtherCharges = Util.GetDecimal(OtherCharges);
            this.MarkUpPercent = Util.GetDecimal(MarkUpPercent);
            this.LandingCost = Util.GetDecimal(LandingCost);
            this.CurrencyCountryID = Util.GetInt(CurrencyCountryID);
            this.Currency = Util.GetString(Currency);
            this.CurrencyFactor = Util.GetDecimal(CurrencyFactor);
            this.ReferenceNo = Util.GetString(ReferenceNo);
            this.BarCodeID = Util.GetInt(BarCodeID);
            this.FromCentreID = Util.GetInt(FromCentreID);
            //
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", ItemName));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTnxNumber", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@BatchNumber", BatchNumber));
            cmd.Parameters.Add(new MySqlParameter("@UnitPrice", UnitPrice));
            cmd.Parameters.Add(new MySqlParameter("@MRP", MRP));
            cmd.Parameters.Add(new MySqlParameter("@IsCountable", IsCountable));
            cmd.Parameters.Add(new MySqlParameter("@InitialCount", InitialCount));
            cmd.Parameters.Add(new MySqlParameter("@ReleasedCount", ReleasedCount));
            cmd.Parameters.Add(new MySqlParameter("@IsReturn", IsReturn));
            cmd.Parameters.Add(new MySqlParameter("@LedgerNo", LedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@MedExpiryDate", MedExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@StockDate", StockDate));
            cmd.Parameters.Add(new MySqlParameter("@StoreLedgerNo", StoreLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@IsPost", IsPost));
            cmd.Parameters.Add(new MySqlParameter("@Naration", Naration));
            cmd.Parameters.Add(new MySqlParameter("@PostDate", PostDate));
            cmd.Parameters.Add(new MySqlParameter("@IsFree", IsFree));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryId", SubCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@Unit", Unit));
            cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@FromDept", FromDept));
            cmd.Parameters.Add(new MySqlParameter("@FromStockID", FromStockID));
            cmd.Parameters.Add(new MySqlParameter("@PendingQty", PendingQty));
            cmd.Parameters.Add(new MySqlParameter("@IndentNo", IndentNo));
            cmd.Parameters.Add(new MySqlParameter("@RejectQty", RejectQty));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@PostUserID", PostUserID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@DiscPer", DiscPer));
            cmd.Parameters.Add(new MySqlParameter("@DiscAmt", DiscAmt));
            cmd.Parameters.Add(new MySqlParameter("@PurTaxPer", PurTaxPer));
            cmd.Parameters.Add(new MySqlParameter("@PurTaxAmt", PurTaxAmt));
            cmd.Parameters.Add(new MySqlParameter("@SaleTaxPer", SaleTaxPer));
            cmd.Parameters.Add(new MySqlParameter("@SaleTaxAmt", SaleTaxAmt));
            cmd.Parameters.Add(new MySqlParameter("@_TYPE", TYPE));
            cmd.Parameters.Add(new MySqlParameter("@Reusable", Reusable));
            cmd.Parameters.Add(new MySqlParameter("@IsBilled", IsBilled));
            cmd.Parameters.Add(new MySqlParameter("@ConsignmentID", ConsignmentID));
            cmd.Parameters.Add(new MySqlParameter("@IsSet", IsSet));
            cmd.Parameters.Add(new MySqlParameter("@SetID", SetID));
            cmd.Parameters.Add(new MySqlParameter("@SetStockID", SetStockID));
            cmd.Parameters.Add(new MySqlParameter("@IsSterlize", IsSterlize));
            cmd.Parameters.Add(new MySqlParameter("@SetStockQty", SetStockQty));
            cmd.Parameters.Add(new MySqlParameter("@MajorUnit", MajorUnit));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnit", MinorUnit));
            cmd.Parameters.Add(new MySqlParameter("@ConversionFactor", ConversionFactor));
            cmd.Parameters.Add(new MySqlParameter("@MajorMRP", MajorMRP));
            cmd.Parameters.Add(new MySqlParameter("@taxCalculateOn", taxCalculateOn));
            cmd.Parameters.Add(new MySqlParameter("@TypeOfTnx", TypeOfTnx));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceNo", InvoiceNo));
            cmd.Parameters.Add(new MySqlParameter("@ChalanNo", ChalanNo));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceDate", InvoiceDate));
            cmd.Parameters.Add(new MySqlParameter("@IsCompleteInvoice", IsCompleteInvoice));
            cmd.Parameters.Add(new MySqlParameter("@ChalanDate", ChalanDate));
            cmd.Parameters.Add(new MySqlParameter("@PONumber", PONumber));
            cmd.Parameters.Add(new MySqlParameter("@PODate", PODate));
            cmd.Parameters.Add(new MySqlParameter("@VenLedgerNo", VenLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTnxNo", LedgerTnxNo));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceAmount", InvoiceAmount));
            cmd.Parameters.Add(new MySqlParameter("@DiffBillAmt", DiffBillAmt));
            cmd.Parameters.Add(new MySqlParameter("@ExcisePer", ExcisePer));
            cmd.Parameters.Add(new MySqlParameter("@ExciseAmt", ExciseAmt));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@IpAddress", IpAddress));
            cmd.Parameters.Add(new MySqlParameter("@IsExpirable", IsExpirable));
            cmd.Parameters.Add(new MySqlParameter("@LaundryDirty", LaundryDirty));
            cmd.Parameters.Add(new MySqlParameter("@isOTReturn", isOTReturn));
            cmd.Parameters.Add(new MySqlParameter("@isDeal", isDeal));

            // GST Work
            cmd.Parameters.Add(new MySqlParameter("@HSNCode", HSNCode));
            cmd.Parameters.Add(new MySqlParameter("@GSTType", GSTType));
            cmd.Parameters.Add(new MySqlParameter("@IGSTPercent", IGSTPercent));
            cmd.Parameters.Add(new MySqlParameter("@IGSTAmtPerUnit", IGSTAmtPerUnit));
            cmd.Parameters.Add(new MySqlParameter("@SGSTPercent", SGSTPercent));
            cmd.Parameters.Add(new MySqlParameter("@SGSTAmtPerUnit", SGSTAmtPerUnit));
            cmd.Parameters.Add(new MySqlParameter("@CGSTPercent", CGSTPercent));
            cmd.Parameters.Add(new MySqlParameter("@CGSTAmtPerUnit", CGSTAmtPerUnit));
            //
            //Special Discount 
            cmd.Parameters.Add(new MySqlParameter("@vSpecialDiscPer", SpecialDiscPer));
            cmd.Parameters.Add(new MySqlParameter("@vSpecialDiscAmt", SpecialDiscAmt));
            cmd.Parameters.Add(new MySqlParameter("@vIsAsset", IsAsset));
            cmd.Parameters.Add(new MySqlParameter("@vsalesno", salesno));

            cmd.Parameters.Add(new MySqlParameter("@vOtherCharges", OtherCharges));
            cmd.Parameters.Add(new MySqlParameter("@vMarkUpPercent", MarkUpPercent));
            cmd.Parameters.Add(new MySqlParameter("@vLandingCost", LandingCost));

            cmd.Parameters.Add(new MySqlParameter("@vCurrencyCountryID", CurrencyCountryID));
            cmd.Parameters.Add(new MySqlParameter("@vCurrency", Currency));
            cmd.Parameters.Add(new MySqlParameter("@vCurrencyFactor", CurrencyFactor));

            cmd.Parameters.Add(new MySqlParameter("@vReferenceNo", ReferenceNo));
            cmd.Parameters.Add(new MySqlParameter("@vBarCodeID", BarCodeID));
            cmd.Parameters.Add(new MySqlParameter("@vFromCentreID", FromCentreID));
            cmd.Parameters.Add(Stock_ID);

            StockID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return StockID.ToString();
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

    public int GetInitialCount(string StockID)
    {
        this.objCon.Open();
        string sql = "select InitialCount from stock where StockID = ? ";
        return Util.GetInt(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql, new MySqlParameter("@StockID", StockID)));
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE stock SET Hospital_ID=?,ItemID=?,LedgerTransactionNo=?,BatchNumber=?,UnitPrice=?,IsCountable=?,InitialCount=?,ReleasedCount=?,IsReturn=?,LedgerNo=?,MedExpiryDate=?,StockDate=?,PostDate=?,StoreLedgerNo=?,SubCategoryID=?,DeptLedgerNo=?,FromDept=?,FromStockID=?,PendingQty=?,IndentNo=? WHERE StockID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.ItemID = Util.GetString(ItemID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.BatchNumber = Util.GetString(BatchNumber);
            this.UnitPrice = Util.GetDecimal(UnitPrice);
            this.IsCountable = Util.GetInt(IsCountable);
            this.InitialCount = Util.GetDecimal(InitialCount);
            this.ReleasedCount = Util.GetInt(ReleasedCount);
            this.IsReturn = Util.GetInt(IsReturn);
            this.LedgerNo = Util.GetString(LedgerNo);
            this.MedExpiryDate = Util.GetDateTime(MedExpiryDate);
            this.StockDate = Util.GetDateTime(StockDate);
            this.PostDate = Util.GetDateTime(PostDate);
            this.StoreLedgerNo = Util.GetString(StoreLedgerNo);
            this.SubCategoryID = Util.GetString(SubCategoryID);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.FromDept = Util.GetString(FromDept);
            this.FromStockID = Util.GetString(FromStockID);
            this.PendingQty = Util.GetDecimal(PendingQty);
            this.IndentNo = Util.GetString(IndentNo);
            this.UserID = Util.GetString(UserID);
            this.PostUserID = Util.GetString(PostUserID);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                new MySqlParameter("@BatchNumber", BatchNumber),
                new MySqlParameter("@UnitPrice", UnitPrice),
                new MySqlParameter("@IsCountable", IsCountable),
                new MySqlParameter("@InitialCount", InitialCount),
                new MySqlParameter("@ReleasedCount", ReleasedCount),
                new MySqlParameter("@IsReturn", IsReturn),
                new MySqlParameter("@LedgerNo", LedgerNo),
                new MySqlParameter("@MedExpiryDate", MedExpiryDate),
                new MySqlParameter("@StockDate", StockDate),
                new MySqlParameter("@PostDate", PostDate),
                new MySqlParameter("@StockID", StockID),
                new MySqlParameter("@StoreLedgerNo", StoreLedgerNo),
                new MySqlParameter("@SubCategoryID", SubCategoryID),
                new MySqlParameter("@DeptLedgerNo", DeptLedgerNo),
                new MySqlParameter("@FromDept", FromDept),
                new MySqlParameter("@FromStockID", FromStockID),
                new MySqlParameter("@PendingQty", PendingQty),
                new MySqlParameter("@IndentNo", IndentNo),
                new MySqlParameter("@UserID", UserID),
                new MySqlParameter("@PostUserID", PostUserID));

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
        this.StockID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM stock WHERE StockID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("StockID", StockID));
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
            string sSQL = "SELECT * FROM stock WHERE StockID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@StockID", StockID)).Tables[0];

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
            string sParams = "StockID=" + this.StockID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(string iPkValue)
    {
        this.StockID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Stock.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Stock.HospCode]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.Stock.Hospital_ID]);
        this.StockID = Util.GetString(dtTemp.Rows[0][AllTables.Stock.StockID]);
        this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.Stock.ItemID]);
        this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.Stock.LedgerTransactionNo]);
        this.BatchNumber = Util.GetString(dtTemp.Rows[0][AllTables.Stock.BatchNumber]);
        this.UnitPrice = Util.GetDecimal(dtTemp.Rows[0][AllTables.Stock.UnitPrice]);
        this.IsCountable = Util.GetInt(dtTemp.Rows[0][AllTables.Stock.IsCountable]);
        this.InitialCount = Util.GetDecimal(dtTemp.Rows[0][AllTables.Stock.InitialCount]);
        this.ReleasedCount = Util.GetInt(dtTemp.Rows[0][AllTables.Stock.ReleasedCount]);
        this.IsReturn = Util.GetInt(dtTemp.Rows[0][AllTables.Stock.IsReturn]);
        this.LedgerNo = Util.GetString(dtTemp.Rows[0][AllTables.Stock.LedgerNo]);
        this.StockDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Stock.StockDate]);
        this.PostDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Stock.PostDate]);
        this.StoreLedgerNo = Util.GetString(dtTemp.Rows[0][AllTables.Stock.StoreLedgerNo]);
        this.IsFree = Util.GetInt(dtTemp.Rows[0][AllTables.Stock.IsFree]);
        this.SubCategoryID = Util.GetString(dtTemp.Rows[0][AllTables.Stock.SubCategoryID]);
    }

    #endregion Helper Private Function
}