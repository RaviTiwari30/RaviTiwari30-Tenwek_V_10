using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>  
/// Summary description for f_ledgertnxdetail  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:              PANKAJRAWAT 
/// Create date:	4/24/2013 6:11:40 PM 
/// Description:	This class is intended for inserting, updating, deleting values for f_ledgertnxdetail table 
/// ========================================================================================== 
/// </summary>  

public class Mortuary_LedgerTnxDetail
{
    public Mortuary_LedgerTnxDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Mortuary_LedgerTnxDetail(MySqlTransaction objTrans)
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
    private string _Doctor_Id;
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

    private string _Investigation_ID; //for PLO
    private string _IsSampleCollected; //for PLO
    private int _IsLabItem; //for PLO

    private int _CentreID;
    private int _HospCentreID;
    private string _SalesID;
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
    public virtual string Surgery_ID { get { return _Surgery_ID; } set { _Surgery_ID = value; } }
    public virtual string SurgeryName { get { return _SurgeryName; } set { _SurgeryName = value; } }
    public virtual string DiscountReason { get { return _DiscountReason; } set { _DiscountReason = value; } }
    public virtual string Doctor_Id { get { return _Doctor_Id; } set { _Doctor_Id = value; } }
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
    public virtual string Type { get { return _Type; } set { _Type= value; } }
    public virtual string Investigation_ID { get { return _Investigation_ID; } set { _Investigation_ID = value; } }
    public virtual string IsSampleCollected { get { return _IsSampleCollected; } set { _IsSampleCollected = value; } }
    public virtual int IsLabItem { get { return _IsLabItem; } set { _IsLabItem = value; } }
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
    public virtual int HospCentreID
    {
        get
        {
            return _HospCentreID;
        }
        set
        {
            _HospCentreID = value;
        }
    }
    public string SalesID
    {
        get { return _SalesID; }
        set { _SalesID = value; }
    }
    #endregion

    #region All Public Member Function
    public int Insert()
    {
        
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("mortuary_ledgertnxdetail_insert");
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
            cmd.Parameters.Add(new MySqlParameter("@vSurgery_ID", Util.GetString(Surgery_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryName", Util.GetString(SurgeryName)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountReason", Util.GetString(DiscountReason)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctor_Id", Util.GetString(Doctor_Id)));
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
          
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));
            cmd.Parameters.Add(new MySqlParameter("@vSalesID", Util.GetString(SalesID)));
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
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }
    #endregion

}
