using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for ItemMaster
/// </summary>
public class ItemMaster
{
    #region All Memory Variables

    private int _isasset;
    private string _Location;
    private string _HospCode;
    private int _ID;
    private int _ItemID;
    private string _Hospital_ID;
    private string _SubCategoryID;
    private int _Type_ID;
    //private int _Type_ID;
    private string _TypeName;
    private string _IsEffectingInventory;
    private string _Description;
    private string _IsExpirable;
    private string _BillingUnit;
    private string _Pulse;
    private string _IsTrigger;
    private System.DateTime _StartTime;
    private System.DateTime _EndTime;
    private string _BufferTime;
    private int _IsActive;
    private decimal _QtyInHand;
    private int _IsAuthorised;
    private int _ValidityPeriod;
    private string _Rack;
    private string _Shelf;
    private double _MaxLevel;
    private double _MinLevel;
    private double _ReorderLevel;
    private double _ReorderQty;
    private double _MaxReorderQty;
    private double _MinReorderQty;
    private string _Packing;
    private int _ManufactureID;
    private int _MinLimit;
    private int _IsSurgery;
    private string _UnitType;
    private int _ServiceItemId;
    //private int _ServiceItemId;
    private int _PurchaseQty;
    private int _SaleQty;
    private string _SaleUnitType;
    private string _IsUsable;
    private int _ToBeBilled;
    private string _serviceName;
    private string _MajorUnit;
    private string _MinorUnit;
    private decimal _converter;
    private string _CreaterID;
    private decimal _SaleTaxPer;
    private string _ItemCode;
    private string _ItemCatalog;
    private string _ScheduleType;
    private string _CommodityCode;
    private string _Dose;
    private string _MedicineType;
    private string _IPAddress;
    private int _RateEditable;
    private string _HSNCode;
    private decimal _IGSTPercent;
    private decimal _SGSTPercent;
    private decimal _CGSTPercent;
    private string _GSTType;
    private int _DepartmentID;
    private int _IsDiscountable;
    private string _vattype;
    private string _vatline;
    private string _Salevattype;
    private string _Salevatline;
    private decimal _Salevat;
    private decimal _purchasevat;
    private string _ItemType;
    private decimal _Isshareward;

    [System.ComponentModel.DefaultValue(1)]
    private int _DrugCategoryMasterID;
    //Consignment Work
    private int _IsStent;
    //
    private decimal _SellingMargin;
    private int _IsOnSellingPrice;
    public string _ManufactureName;

    private int _IsCSSD;
    private int _IsLaundry;
    [System.ComponentModel.DefaultValue(1)]
    private int _IsStockAble;

    [System.ComponentModel.DefaultValue(0.00)]
    private decimal _TypeofmeasurmentQty;
    private string _TypeofmeasurmentUnit;

    [System.ComponentModel.DefaultValue(0.00000)]
    private decimal _ItemDose;

    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public ItemMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }
    public ItemMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property



    public virtual string TypeofmeasurmentUnit
    {
        get
        {
            return _TypeofmeasurmentUnit;
        }
        set
        {
            _TypeofmeasurmentUnit = value;
        }
    }
    public virtual decimal TypeofmeasurmentQty
    {
        get
        {
            return _TypeofmeasurmentQty;
        }
        set
        {
            _TypeofmeasurmentQty = value;
        }
    }






    public virtual string Packing
    {
        get
        {
            return _Packing;
        }
        set
        {
            _Packing = value;
        }
    }
    public virtual double MaxLevel
    {
        get
        {
            return _MaxLevel;
        }
        set
        {
            _MaxLevel = value;
        }
    }
    public virtual double MinLevel
    {
        get
        {
            return _MinLevel;
        }
        set
        {
            _MinLevel = value;
        }
    }
    public virtual double ReorderLevel
    {
        get
        {
            return _ReorderLevel;
        }
        set
        {
            _ReorderLevel = value;
        }
    }
    public virtual double ReorderQty
    {
        get
        {
            return _ReorderQty;
        }
        set
        {
            _ReorderQty = value;
        }
    }
    public virtual double MaxReorderQty
    {
        get
        {
            return _MaxReorderQty;
        }
        set
        {
            _MaxReorderQty = value;
        }
    }
    public virtual double MinReorderQty
    {
        get
        {
            return _MinReorderQty;
        }
        set
        {
            _MinReorderQty = value;
        }
    }
    public virtual string Rack
    {
        get
        {
            return _Rack;
        }
        set
        {
            _Rack = value;
        }
    }
    public virtual string Shelf
    {
        get
        {
            return _Shelf;
        }
        set
        {
            _Shelf = value;
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
    public virtual int ItemID
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
    public virtual int Type_ID
    {
        get
        {
            return _Type_ID;
        }
        set
        {
            _Type_ID = value;
        }
    }
    public virtual string TypeName
    {
        get
        {
            return _TypeName;
        }
        set
        {
            _TypeName = value;
        }
    }
    public virtual string IsEffectingInventory
    {
        get
        {
            return _IsEffectingInventory;
        }
        set
        {
            _IsEffectingInventory = value;
        }
    }
    public virtual string Description
    {
        get
        {
            return _Description;
        }
        set
        {
            _Description = value;
        }
    }
    public virtual string IsExpirable
    {
        get
        {
            return _IsExpirable;
        }
        set
        {
            _IsExpirable = value;
        }
    }
    public virtual string BillingUnit
    {
        get
        {
            return _BillingUnit;
        }
        set
        {
            _BillingUnit = value;
        }
    }
    public virtual string Pulse
    {
        get
        {
            return _Pulse;
        }
        set
        {
            _Pulse = value;
        }
    }
    public virtual string IsTrigger
    {
        get
        {
            return _IsTrigger;
        }
        set
        {
            _IsTrigger = value;
        }
    }
    public virtual DateTime StartTime
    {
        get
        {
            return _StartTime;
        }
        set
        {
            _StartTime = value;
        }
    }
    public virtual DateTime EndTime
    {
        get
        {
            return _EndTime;
        }
        set
        {
            _EndTime = value;
        }
    }
    public virtual string BufferTime
    {
        get
        {
            return _BufferTime;
        }
        set
        {
            _BufferTime = value;
        }
    }
    public virtual int IsActive
    {
        get
        {
            return _IsActive;
        }
        set
        {
            _IsActive = value;
        }
    }
    public virtual decimal QtyInHand
    {
        get
        {
            return _QtyInHand;
        }
        set
        {
            _QtyInHand = value;
        }
    }
    public virtual int IsAuthorised
    {
        get
        {
            return _IsAuthorised;
        }
        set
        {
            _IsAuthorised = value;
        }
    }
    public virtual string UnitType
    {
        get { return _UnitType; }
        set { _UnitType = value; }
    }
    public virtual int ValidityPeriod
    {
        get
        {
            return _ValidityPeriod;
        }
        set
        {
            _ValidityPeriod = value;
        }
    }
    public virtual int ManufactureID
    {
        get
        {
            return _ManufactureID;
        }
        set
        {
            _ManufactureID = value;
        }
    }
    public virtual int MinLimit
    {
        get
        {
            return _MinLimit;
        }
        set
        {
            _MinLimit = value;
        }
    }
    public virtual int IsSurgery
    {
        get
        {
            return _IsSurgery;
        }
        set
        {
            _IsSurgery = value;
        }
    }
    public virtual int ServiceItemId
    {
        get
        {
            return _ServiceItemId;
        }
        set
        {
            _ServiceItemId = value;
        }
    }
    public virtual int PurchaseQty
    {
        get
        {
            return _PurchaseQty;
        }
        set
        {
            _PurchaseQty = value;
        }
    }
    public virtual int SaleQty
    {
        get
        {
            return _SaleQty;
        }
        set
        {
            _SaleQty = value;
        }
    }
    public virtual string SaleUnitType
    {
        get
        {
            return _SaleUnitType;
        }
        set
        {
            _SaleUnitType = value;
        }
    }
    public virtual string IsUsable
    {
        get
        {
            return _IsUsable;
        }
        set
        {
            _IsUsable = value;
        }
    }
    public virtual int ToBeBilled
    {
        get
        {
            return _ToBeBilled;
        }
        set
        {
            _ToBeBilled = value;
        }
    }
    public virtual string serviceName
    {

        get
        {
            return _serviceName;
        }

        set
        {
            _serviceName = value;
        }
    }
    public virtual string majorUnit
    {

        get
        {
            return _MajorUnit;
        }

        set
        {
            _MajorUnit = value;

        }

    }
    public virtual string minorUnit
    {

        get
        {
            return _MinorUnit;

        }
        set
        {
            _MinorUnit = value;
        }
    }
    public virtual decimal converter
    {

        get
        {
            return _converter;

        }
        set
        {
            _converter = value;
        }

    }
    public virtual string CreaterID
    {

        get
        {
            return _CreaterID;
        }
        set
        {
            _CreaterID = value;
        }
    }
    public virtual decimal SaleTaxPer
    {
        get { return _SaleTaxPer; }
        set { _SaleTaxPer = value; }
    }
    public virtual string ItemCode
    {
        get { return _ItemCode; }
        set { _ItemCode = value; }
    }
    public virtual string ItemCatalog
    {
        get { return _ItemCatalog; }
        set { _ItemCatalog = value; }
    }
    public virtual string ScheduleType
    {
        get { return _ScheduleType; }
        set { _ScheduleType = value; }
    }
    public virtual string CommodityCode
    {
        get { return _CommodityCode; }
        set { _CommodityCode = value; }
    }
    public virtual string Dose
    {
        get { return _Dose; }
        set { _Dose = value; }
    }
    public virtual string MedicineType
    {
        get { return _MedicineType; }
        set { _MedicineType = value; }
    }
    public virtual string IPAddress
    {
        get { return _IPAddress; }
        set { _IPAddress = value; }
    }
    public virtual int RateEditable
    {
        get { return _RateEditable; }
        set { _RateEditable = value; }
    }
    public virtual string HSNCode
    {
        get { return _HSNCode; }
        set { _HSNCode = value; }

    }
    public virtual decimal IGSTPercent
    {
        get { return _IGSTPercent; }
        set { _IGSTPercent = value; }
    }
    public virtual decimal SGSTPercent
    {
        get { return _SGSTPercent; }
        set { _SGSTPercent = value; }
    }
    public virtual decimal CGSTPercent
    {
        get { return _CGSTPercent; }
        set { _CGSTPercent = value; }
    }
    public virtual string GSTType
    {
        get { return _GSTType; }
        set { _GSTType = value; }
    }
    public virtual int DepartmentID
    {
        get { return _DepartmentID; }
        set { _DepartmentID = value; }
    }
    public virtual int IsDiscountable
    {
        get { return _IsDiscountable; }
        set { _IsDiscountable = value; }
    }
    //Consignment Work
    public virtual int IsStent { get { return _IsStent; } set { _IsStent = value; } }
    //

    public virtual string ManufactureName
    {
        get { return _ManufactureName; }
        set { _ManufactureName = value; }
    }
    public virtual int IsOnSellingPrice { get { return _IsOnSellingPrice; } set { _IsOnSellingPrice = value; } }
    public virtual decimal SellingMargin { get { return _SellingMargin; } set { _SellingMargin = value; } }
    public virtual int DrugCategoryMasterID
    {
        get { return _DrugCategoryMasterID; }
        set { _DrugCategoryMasterID = value; }
    }
    public virtual int IsAsset
    {
        get { return _isasset; }
        set { _isasset = value; }
    }

    public virtual int IsStockAble
    {
        get { return _IsStockAble; }
        set { _IsStockAble = value; }
    }

    public virtual string VatType
    {
        get { return _vattype; }
        set { _vattype = value; }
    }
    public virtual string VatLine
    {
        get { return _vatline; }
        set { _vatline = value; }
    }
    public virtual string SaleVatType
    {
        get { return _Salevattype; }
        set { _Salevattype = value; }
    }
    public virtual string SaleVatLine
    {
        get { return _Salevatline; }
        set { _Salevatline = value; }
    }
    public virtual decimal SaleVat
    {
        get { return _Salevat; }
        set { _Salevat = value; }
    }
    public virtual decimal PurchaseVat
    {
        get { return _purchasevat; }
        set { _purchasevat = value; }
    }
    public virtual string ItemType
    {
        get { return _ItemType; }
        set { _ItemType = value; }
    }
    public virtual int IsCSSD
    {
        get { return _IsCSSD; }
        set { _IsCSSD = value; }
    }
    public virtual int IsLaundry
    {
        get { return _IsLaundry; }
        set { _IsLaundry = value; }
    }
    public virtual decimal Isshareward
    {
        get { return _Isshareward; }
        set { _Isshareward = value; }
    }

    public virtual decimal ItemDose
    {
        get { return _ItemDose; }
        set { _ItemDose = value; }
    }
    #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_ItemMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ItemID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.SubCategoryID = Util.GetString(SubCategoryID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Type_ID = Util.GetInt(Type_ID);
            this.TypeName = Util.GetString(TypeName);
            this.IsEffectingInventory = Util.GetString(IsEffectingInventory);
            this.Description = Util.GetString(Description);
            this.IsExpirable = Util.GetString(IsExpirable);
            this.BillingUnit = Util.GetString(BillingUnit);
            this.Pulse = Util.GetString(Pulse);
            this.IsTrigger = Util.GetString(IsTrigger);
            this.StartTime = Util.GetDateTime(StartTime);
            this.EndTime = Util.GetDateTime(EndTime);
            this.BufferTime = Util.GetString(BufferTime);
            this.IsActive = Util.GetInt(IsActive);
            this.QtyInHand = Util.GetDecimal(QtyInHand);
            this.IsAuthorised = Util.GetInt(IsAuthorised);
            this.ValidityPeriod = Util.GetInt(ValidityPeriod);
            this.UnitType = Util.GetString(UnitType);
            this.Rack = Util.GetString(Rack);
            this.Shelf = Util.GetString(Shelf);
            this.MaxLevel = Util.GetDouble(MaxLevel);
            this.MinLevel = Util.GetDouble(MinLevel);
            this.ReorderLevel = Util.GetDouble(ReorderLevel);
            this.ReorderQty = Util.GetDouble(ReorderQty);
            this.MaxReorderQty = Util.GetDouble(MaxReorderQty);
            this.MinReorderQty = Util.GetDouble(MinReorderQty);
            this.Packing = Util.GetString(Packing);
            this.ManufactureID = Util.GetInt(ManufactureID);
            this.MinLimit = Util.GetInt(MinLimit);
            this.IsSurgery = Util.GetInt(IsSurgery);
            this.ServiceItemId = Util.GetInt(ServiceItemId);
            this.PurchaseQty = Util.GetInt(PurchaseQty);
            this.SaleQty = Util.GetInt(SaleQty);
            this.SaleUnitType = Util.GetString(SaleUnitType);
            this.IsUsable = Util.GetString(IsUsable);
            this.ToBeBilled = Util.GetInt(ToBeBilled);
            this.serviceName = Util.GetString(serviceName);
            this.majorUnit = Util.GetString(majorUnit);
            this.minorUnit = Util.GetString(minorUnit);
            this.converter = Util.GetDecimal(converter);
            this.CreaterID = Util.GetString(CreaterID);
            this.SaleTaxPer = Util.GetDecimal(SaleTaxPer);
            this.ItemCode = Util.GetString(ItemCode);
            this.ItemCatalog = Util.GetString(ItemCatalog);
            this.ScheduleType = Util.GetString(ScheduleType);
            this.CommodityCode = Util.GetString(CommodityCode);
            this.Dose = Util.GetString(Dose);
            this.MedicineType = Util.GetString(MedicineType);
            this.IPAddress = Util.GetString(IPAddress);
            this.GSTType = Util.GetString(GSTType);
            this.HSNCode = Util.GetString(HSNCode);
            this.IGSTPercent = Util.GetDecimal(IGSTPercent);
            this.CGSTPercent = Util.GetDecimal(CGSTPercent);
            this.SGSTPercent = Util.GetDecimal(SGSTPercent);
            this.RateEditable = Util.GetInt(RateEditable);
            this.DepartmentID = Util.GetInt(DepartmentID);
            this.IsDiscountable = Util.GetInt(IsDiscountable);
            this.VatType = Util.GetString(VatType);
            this.VatLine = Util.GetString(VatLine);
            this.SaleVatType = Util.GetString(SaleVatType);
            this.SaleVatLine = Util.GetString(SaleVatLine);
            this.SaleVat = Util.GetDecimal(SaleVat);
            this.PurchaseVat = Util.GetDecimal(PurchaseVat);
            //Consignment Work
            this.IsStent = Util.GetInt(IsStent);
            //
            this.ManufactureName = Util.GetString(ManufactureName);
            this.IsOnSellingPrice = Util.GetInt(IsOnSellingPrice);
            this.SellingMargin = Util.GetDecimal(SellingMargin);
            this.IsAsset = IsAsset;
            this.DrugCategoryMasterID = Util.GetInt(DrugCategoryMasterID);
            this.IsStockAble = Util.GetInt(IsStockAble);
            this.ItemType = Util.GetString(ItemType);
            this.IsCSSD = Util.GetInt(IsCSSD);
            this.IsLaundry = Util.GetInt(IsLaundry);
            this.TypeofmeasurmentQty = Util.GetDecimal(TypeofmeasurmentQty);
            this.TypeofmeasurmentUnit = TypeofmeasurmentUnit;
            this.Isshareward = Util.GetInt(Isshareward);
            this.ItemDose = Util.GetDecimal(ItemDose);
            



            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryID", SubCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@Type_ID", Type_ID));
            cmd.Parameters.Add(new MySqlParameter("@TypeName", TypeName));
            cmd.Parameters.Add(new MySqlParameter("@IsEffectingInventory", IsEffectingInventory));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@IsExpirable", IsExpirable));
            cmd.Parameters.Add(new MySqlParameter("@BillingUnit", BillingUnit));
            cmd.Parameters.Add(new MySqlParameter("@Pulse", Pulse));
            cmd.Parameters.Add(new MySqlParameter("@IsTrigger", IsTrigger));
            cmd.Parameters.Add(new MySqlParameter("@StartTime", StartTime));
            cmd.Parameters.Add(new MySqlParameter("@EndTime", EndTime));
            cmd.Parameters.Add(new MySqlParameter("@BufferTime", BufferTime));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@QtyInHand", QtyInHand));
            cmd.Parameters.Add(new MySqlParameter("@IsAuthorised", IsAuthorised));
            cmd.Parameters.Add(new MySqlParameter("@ValidityPeriod", ValidityPeriod));
            cmd.Parameters.Add(new MySqlParameter("@PurchaseQty", PurchaseQty));
            cmd.Parameters.Add(new MySqlParameter("@vUnitType", UnitType));
            cmd.Parameters.Add(new MySqlParameter("@SaleQty", SaleQty));
            cmd.Parameters.Add(new MySqlParameter("@SaleUnitType", SaleUnitType));
            cmd.Parameters.Add(new MySqlParameter("@Rack", Rack));
            cmd.Parameters.Add(new MySqlParameter("@Shelf", Shelf));
            cmd.Parameters.Add(new MySqlParameter("@MaxLevel", MaxLevel));
            cmd.Parameters.Add(new MySqlParameter("@MinLevel", MinLevel));
            cmd.Parameters.Add(new MySqlParameter("@ReorderLevel", ReorderLevel));
            cmd.Parameters.Add(new MySqlParameter("@ReorderQty", ReorderQty));
            cmd.Parameters.Add(new MySqlParameter("@MaxReorderQty", MaxReorderQty));
            cmd.Parameters.Add(new MySqlParameter("@MinReorderQty", MinReorderQty));
            cmd.Parameters.Add(new MySqlParameter("@Packing", Packing));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureID", ManufactureID));
            cmd.Parameters.Add(new MySqlParameter("@MinLimit", MinLimit));
            cmd.Parameters.Add(new MySqlParameter("@IsSurgery", IsSurgery));
            cmd.Parameters.Add(new MySqlParameter("@ServiceItemId", ServiceItemId));
            cmd.Parameters.Add(new MySqlParameter("@IsUsable", IsUsable));
            cmd.Parameters.Add(new MySqlParameter("@ToBeBilled", ToBeBilled));
            cmd.Parameters.Add(new MySqlParameter("SaleTaxPer", SaleTaxPer));
            cmd.Parameters.Add(new MySqlParameter("@converter", converter));
            cmd.Parameters.Add(new MySqlParameter("@majorUnit", majorUnit));
            cmd.Parameters.Add(new MySqlParameter("@minorUnit", minorUnit));
            cmd.Parameters.Add(new MySqlParameter("@servicename", serviceName));
            cmd.Parameters.Add(new MySqlParameter("@CreaterID", CreaterID));
            cmd.Parameters.Add(new MySqlParameter("@ItemCode", ItemCode));
            cmd.Parameters.Add(new MySqlParameter("@ItemCatalog", ItemCatalog));
            cmd.Parameters.Add(new MySqlParameter("@ScheduleType", ScheduleType));
            cmd.Parameters.Add(new MySqlParameter("@CommodityCode", CommodityCode));
            cmd.Parameters.Add(new MySqlParameter("@Dose", Dose));
            cmd.Parameters.Add(new MySqlParameter("@MedicineType", MedicineType));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@RateEditable", RateEditable));
            cmd.Parameters.Add(new MySqlParameter("@HSNCode", HSNCode));
            cmd.Parameters.Add(new MySqlParameter("@IGSTPercent", IGSTPercent));
            cmd.Parameters.Add(new MySqlParameter("@CGSTPercent", CGSTPercent));
            cmd.Parameters.Add(new MySqlParameter("@SGSTPercent", SGSTPercent));
            cmd.Parameters.Add(new MySqlParameter("@GSTType", GSTType));
            cmd.Parameters.Add(new MySqlParameter("@DeptID", DepartmentID));
            cmd.Parameters.Add(new MySqlParameter("@IsDiscountable", IsDiscountable));
            //Consignment Work
            cmd.Parameters.Add(new MySqlParameter("@IsStent", IsStent));
            //
            cmd.Parameters.Add(new MySqlParameter("@ManufactureName", ManufactureName));
            cmd.Parameters.Add(new MySqlParameter("@SellingMargin", SellingMargin));
            cmd.Parameters.Add(new MySqlParameter("@IsOnSellingPrice", IsOnSellingPrice));
            cmd.Parameters.Add(new MySqlParameter("@IsAsset", IsAsset));
            cmd.Parameters.Add(new MySqlParameter("@vDrugCategoryMasterID", DrugCategoryMasterID));
            cmd.Parameters.Add(new MySqlParameter("@vIsStockAble", IsStockAble));
            cmd.Parameters.Add(new MySqlParameter("@VatType", VatType));
            cmd.Parameters.Add(new MySqlParameter("@VatLine", VatLine));
            cmd.Parameters.Add(new MySqlParameter("@SaleVatType", SaleVatType));
            cmd.Parameters.Add(new MySqlParameter("@SaleVatLine", SaleVatLine));
            cmd.Parameters.Add(new MySqlParameter("@DefaultSaleVatPercentage", SaleVat));
            cmd.Parameters.Add(new MySqlParameter("@DefaultPurchaseVatPercentage", PurchaseVat));
            cmd.Parameters.Add(new MySqlParameter("@vItemType", ItemType));

            cmd.Parameters.Add(new MySqlParameter("@IsCSSD", IsCSSD));
            cmd.Parameters.Add(new MySqlParameter("@IsLaundry", IsLaundry));

            cmd.Parameters.Add(new MySqlParameter("@TypeofmeasurmentUnit", TypeofmeasurmentUnit));
            cmd.Parameters.Add(new MySqlParameter("@TypeofmeasurmentQty", TypeofmeasurmentQty));
            cmd.Parameters.Add(new MySqlParameter("@Isshareward", Isshareward));
            cmd.Parameters.Add(new MySqlParameter("@ItemDose", ItemDose));
            cmd.Parameters.Add(paramTnxID);

            ItemID = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ItemID.ToString();
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
            objSQL.Append("UPDATE f_itemmaster SET Hospital_ID=?,SubCategoryID=?,Type_ID=?,TypeName=?,IsEffectingInventory=?,Description=?,IsExpirable=?,BillingUnit=?,Pulse=?,IsTrigger=?,StartTime=?,EndTime=?,BufferTime=?,IsActive=?,QtyInHand=?,IsAuthorised=?,ValidityPeriod=?,ItemCode=?,CommodityCode=? WHERE ItemID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);

            this.ItemID = Util.GetInt(ItemID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.SubCategoryID = Util.GetString(SubCategoryID);
            this.Type_ID = Util.GetInt(Type_ID);
            this.TypeName = Util.GetString(TypeName);
            this.IsEffectingInventory = Util.GetString(IsEffectingInventory);
            this.Description = Util.GetString(Description);
            this.IsExpirable = Util.GetString(IsExpirable);
            this.BillingUnit = Util.GetString(BillingUnit);
            this.Pulse = Util.GetString(Pulse);
            this.IsTrigger = Util.GetString(IsTrigger);
            this.StartTime = Util.GetDateTime(StartTime);
            this.EndTime = Util.GetDateTime(EndTime);
            this.BufferTime = Util.GetString(BufferTime);
            this.IsActive = Util.GetInt(IsActive);
            this.QtyInHand = Util.GetInt(QtyInHand);
            this.IsAuthorised = Util.GetInt(IsAuthorised);
            this.ValidityPeriod = Util.GetInt(ValidityPeriod);
            this.ItemCode = Util.GetString(ItemCode);
            this.CommodityCode = Util.GetString(CommodityCode);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@SubCategoryID", SubCategoryID),
                new MySqlParameter("@Type_ID", Type_ID),
                new MySqlParameter("@TypeName", TypeName),
                new MySqlParameter("@IsEffectingInventory", IsEffectingInventory),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@IsExpirable", IsExpirable),
                new MySqlParameter("@BillingUnit", BillingUnit),
                new MySqlParameter("@Pulse", Pulse),
                new MySqlParameter("@IsTrigger", IsTrigger),
                new MySqlParameter("@StartTime", StartTime),
                new MySqlParameter("@EndTime", EndTime),
                new MySqlParameter("@BufferTime", BufferTime),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@QtyInHand", QtyInHand),
                new MySqlParameter("@IsAuthorised", IsAuthorised),
                new MySqlParameter("@ValidityPeriod", ValidityPeriod),
                new MySqlParameter("@ItemCode", ItemCode),
                 new MySqlParameter("@CommodityCode", CommodityCode),
                new MySqlParameter("@ItemID", ItemID));

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
        this.ItemID = iPkValue;
        return this.Delete();
    }
    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_itemmaster WHERE ItemID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("ItemID", ItemID));
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
            throw (ex);
        }
    }
    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM f_itemmaster WHERE ItemID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@ItemID", ItemID)).Tables[0];

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
            string sParams = "ItemID=" + this.ItemID.ToString();
            throw (ex);
        }

    }
    public bool Load(int iPkValue)
    {
        this.ItemID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function
    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.HospCode]);
        this.ItemID = Util.GetInt(dtTemp.Rows[0][AllTables.ItemMaster.ItemID]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.Hospital_ID]);
        this.SubCategoryID = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.SubCategoryID]);
        this.Type_ID = Util.GetInt(dtTemp.Rows[0][AllTables.ItemMaster.Type_ID]);
        this.TypeName = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.TypeName]);
        this.IsEffectingInventory = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.IsEffectingInventory]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.Description]);
        this.IsExpirable = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.IsExpirable]);
        this.BillingUnit = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.BillingUnit]);
        this.Pulse = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.Pulse]);
        this.IsTrigger = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.IsTrigger]);
        this.StartTime = Util.GetDateTime(dtTemp.Rows[0][AllTables.ItemMaster.StartTime]);
        this.EndTime = Util.GetDateTime(dtTemp.Rows[0][AllTables.ItemMaster.EndTime]);
        this.BufferTime = Util.GetString(dtTemp.Rows[0][AllTables.ItemMaster.BufferTime]);
        this.IsActive = Util.GetInt(dtTemp.Rows[0][AllTables.ItemMaster.IsActive]);
        this.QtyInHand = Util.GetDecimal(dtTemp.Rows[0][AllTables.ItemMaster.QtyInHand]);
        this.IsAuthorised = Util.GetInt(dtTemp.Rows[0][AllTables.ItemMaster.IsAuthorised]);
        this.ValidityPeriod = Util.GetInt(dtTemp.Rows[0][AllTables.ItemMaster.ValidityPeriod]);
    }
    #endregion
}
