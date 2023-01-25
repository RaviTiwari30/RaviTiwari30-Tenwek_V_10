#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class Ledger_Master
{
    
   #region All Memory Variables

    private string _HospCode;
    private string _Location;
    private int _ID;
    private string _GroupID;
    private string  _Hospital_ID ;
    private string _LegderName;
    private string _LedgerNumber;
    private string _LedgerUserID;
    private string _IncomeTaxNumber;
    private string _SalesTaxNumber;
    private string _InterStateSTNumber;
    private string _VATTINNumber;
    private decimal _OpeningBalance;
    private decimal _ClosingBalance;
    private string _RoundingMethod;
    private string _NotificationNumber;
    private string _RegistrationNumber;
    private string _ServiceCategory;
    private string _ExciseLedgerClassification;
    private string _ExciseRegistrationNumber;
    private string _ExciseAccountHead;
    private string _ExciseDutyType;
    private string _TraderExciseRegNo;
    private string _TraderExciseRange;
    private string _TraderExciseDivision;
    private string _TraderExciseCommissionerate;
    private string _TraderLedNatureofPurchase;
    private string _TDSDeducteeType;
    private string _TDSRateName;
    private string _TDSDeducteeSectionNumber;
    private string _LedgerFBTCategory;
    private string _IsTCSApplicable;
    private string _IsTDSApplicable;
    private string _IsFBTApplicable;
    private string _IsGSTApplicable;
    private string _CreditLimit;
    private string _Parent;
    private decimal _CurrentBalance;
    private int _BalanaceType;
    private int _PendingCheques;

    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    #endregion
    #region Overloaded Constructor
	public Ledger_Master()
	{
		objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;       
	}
    
    public Ledger_Master(MySqlTransaction objTrans)
	{
		this.objTrans = objTrans;
		this.IsLocalConn = false;
	}
   
     #endregion
     #region Set All Property

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
        public virtual string LegderName
        {
            get
            {
                return _LegderName;
            }
            set
            {
                _LegderName = value;
            }
        }
    public virtual string LedgerNumber

    {
        get
        {
            return _LedgerNumber;
;
        }
        set
        {
            _LedgerNumber = value;
        }
    }
    public virtual string LedgerUserID
    {
        get
        {
            return _LedgerUserID;
        }
        set
        {
            _LedgerUserID = value;
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
    
        public virtual string IncomeTaxNumber
        {
            get
            {
                return _IncomeTaxNumber;
            }
            set
            {
                _IncomeTaxNumber = value;
            }
        }
     public virtual string SalesTaxNumber
        {
            get
            {
                return _SalesTaxNumber;
            }
            set
            {
                _SalesTaxNumber = value;
            }
        }
     public virtual string InterStateSTNumber
        {
            get
            {
                return _InterStateSTNumber;
            }
            set
            {
                _InterStateSTNumber = value;
            }
        }
     public virtual string VATTINNumber
        {
            get
            {
                return _VATTINNumber;
            }
            set
            {
                _VATTINNumber = value;
            }
        }
     public virtual decimal OpeningBalance
        {
            get
            {
                return _OpeningBalance;
            }
            set
            {
                _OpeningBalance = value;
            }
        }
     public virtual decimal ClosingBalance
        {
            get
            {
                return _ClosingBalance;
            }
            set
            {
                _ClosingBalance = value;
            }
        }
     public virtual string RoundingMethod
        {
            get
            {
                return _RoundingMethod;
            }
            set
            {
                _RoundingMethod = value;
            }
        }
     public virtual string NotificationNumber
        {
            get
            {
                return _NotificationNumber;
            }
            set
            {
                _NotificationNumber = value;
            }
        }
     public virtual string RegistrationNumber
        {
            get
            {
                return _RegistrationNumber;
            }
            set
            {
                _RegistrationNumber = value;
            }
        }
     public virtual string ServiceCategory
        {
            get
            {
                return _ServiceCategory;
            }
            set
            {
                _ServiceCategory = value;
            }
        }
     public virtual string ExciseLedgerClassification
        {
            get
            {
                return _ExciseLedgerClassification;
            }
            set
            {
                _ExciseLedgerClassification = value;
            }
        }
     public virtual string ExciseRegistrationNumber
        {
            get
            {
                return _ExciseRegistrationNumber;
            }
            set
            {
                _ExciseRegistrationNumber = value;
            }
        }
     public virtual string ExciseAccountHead
        {
            get
            {
                return _ExciseAccountHead;
            }
            set
            {
                _ExciseAccountHead = value;
            }
        }
     public virtual string ExciseDutyType
        {
            get
            {
                return _ExciseDutyType;
            }
            set
            {
                _ExciseDutyType = value;
            }
        }
     public virtual string TraderExciseRegNo
        {
            get
            {
                return _TraderExciseRegNo;
            }
            set
            {
                _TraderExciseRegNo = value;
            }
        }
     public virtual string TraderExciseRange
        {
            get
            {
                return _TraderExciseRange;
            }
            set
            {
                _TraderExciseRange = value;
            }
        }
     public virtual string TraderExciseDivision
        {
            get
            {
                return _TraderExciseDivision;
            }
            set
            {
                _TraderExciseDivision = value;
            }
        }
     public virtual string TraderExciseCommissionerate
        {
            get
            {
                return _TraderExciseCommissionerate;
            }
            set
            {
                _TraderExciseCommissionerate = value;
            }
        }
     public virtual string TraderLedNatureofPurchase
        {
            get
            {
                return _TraderLedNatureofPurchase;
            }
            set
            {
                _TraderLedNatureofPurchase = value;
            }
        }
     public virtual string TDSDeducteeType
        {
            get
            {
                return _TDSDeducteeType;
            }
            set
            {
                _TDSDeducteeType = value;
            }
        }
     public virtual string TDSRateName
        {
            get
            {
                return _TDSRateName;
            }
            set
            {
                _TDSRateName = value;
            }
        }
     public virtual string TDSDeducteeSectionNumber
        {
            get
            {
                return _TDSDeducteeSectionNumber;
            }
            set
            {
                _TDSDeducteeSectionNumber = value;
            }
        }
     public virtual string LedgerFBTCategory
        {
            get
            {
                return _LedgerFBTCategory;
            }
            set
            {
                _LedgerFBTCategory = value;
            }
        }
     public virtual string IsTCSApplicable
        {
            get
            {
                return _IsTCSApplicable;
            }
            set
            {
                _IsTCSApplicable = value;
            }
        }
     public virtual string IsTDSApplicable
        {
            get
            {
                return _IsTDSApplicable;
            }
            set
            {
                _IsTDSApplicable = value;
            }
        }
     public virtual string IsFBTApplicable
        {
            get
            {
                return _IsFBTApplicable;
            }
            set
            {
                _IsFBTApplicable = value;
            }
        }
     public virtual string IsGSTApplicable
        {
            get
            {
                return _IsGSTApplicable;
            }
            set
            {
                _IsGSTApplicable = value;
            }
        }
     public virtual string CreditLimit
        {
            get
            {
                return _CreditLimit;
            }
            set
            {
                _CreditLimit = value;
            }
        }
     public virtual string Parent
        {
            get
            {
                return _Parent;
            }
            set
            {
                _Parent = value;
            }
        }

    public virtual decimal CurrentBalance
    {
        get
        {
            return _CurrentBalance;
        }
        set
        {
            _CurrentBalance = value;
        }
    }

    public virtual int BalanaceType
    {
        get
        {
            return _BalanaceType;
        }
        set
        {
            _BalanaceType = value;
        }
    }

    public virtual int PendingCheques
    {
        get
        {
            return _PendingCheques;
        }
        set
        {
            _PendingCheques = value;
        }
    }

     #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {
            string iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("CALL Insert_ledgermaster (@Loc,@Hosp,@GroupID,@Hospital_ID,@LegderName,@LegderUserID,@IncomeTaxNumber,@SalesTaxNumber,@InterStateSTNumber,");
            objSQL.Append("@VATTINNumber,@OpeningBalance,@ClosingBalance,@RoundingMethod,@NotificationNumber,@RegistrationNumber,@ServiceCategory,");
            objSQL.Append("@ExciseLedgerClassification,@ExciseRegistrationNumber,@ExciseAccountHead,@ExciseDutyType,@TraderExciseRegNo,@TraderExciseRange,@TraderExciseDivision");
            objSQL.Append(",@TraderExciseCommissionerate,@TraderLedNatureofPurchase,@TDSDeducteeType,@TDSRateName,@TDSDeducteeSectionNumber,@LedgerFBTCategory,@IsTCSApplicable,");
            objSQL.Append("@IsTDSApplicable,@IsFBTApplicable,@IsGSTApplicable,@CreditLimit,@Parent,@CurrentBalance,@BalanaceType,@PendingCheques)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);          
            this.GroupID = Util.GetString(GroupID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.LegderName = Util.GetString(LegderName);
            this.LedgerUserID = Util.GetString(LedgerUserID);
            this.IncomeTaxNumber = Util.GetString(IncomeTaxNumber);
            this.SalesTaxNumber = Util.GetString(SalesTaxNumber);
             this.InterStateSTNumber = Util.GetString(InterStateSTNumber);
            this.VATTINNumber = Util.GetString(VATTINNumber);
            this.OpeningBalance = Util.GetDecimal(OpeningBalance);
            this.ClosingBalance = Util.GetDecimal(ClosingBalance);
            this.RoundingMethod = Util.GetString(RoundingMethod);
            this.NotificationNumber = Util.GetString(NotificationNumber);
            this.RegistrationNumber = Util.GetString(RegistrationNumber);
            this.ServiceCategory = Util.GetString(ServiceCategory);
            this.ExciseLedgerClassification = Util.GetString(ExciseLedgerClassification);
            this.ExciseRegistrationNumber = Util.GetString(ExciseRegistrationNumber);
            this.ExciseAccountHead = Util.GetString(ExciseAccountHead);
            this.ExciseDutyType = Util.GetString(ExciseDutyType);
            this.TraderExciseRegNo = Util.GetString(TraderExciseRegNo);
            this.TraderExciseRange = Util.GetString(TraderExciseRange);
            this.TraderExciseDivision = Util.GetString(TraderExciseDivision);
            this.TraderExciseCommissionerate = Util.GetString(TraderExciseCommissionerate);
            this.TraderLedNatureofPurchase = Util.GetString(TraderLedNatureofPurchase);
            this.TDSDeducteeType = Util.GetString(TDSDeducteeType);
            this.TDSRateName = Util.GetString(TDSRateName);
            this.TDSDeducteeSectionNumber = Util.GetString(TDSDeducteeSectionNumber);
            this.LedgerFBTCategory = Util.GetString(LedgerFBTCategory);
            this.IsTCSApplicable = Util.GetString(IsTCSApplicable);
            this.IsTDSApplicable = Util.GetString(IsTDSApplicable);
            this.IsFBTApplicable = Util.GetString(IsFBTApplicable);
            this.IsGSTApplicable = Util.GetString(IsGSTApplicable);

            this.CreditLimit = Util.GetString(CreditLimit);
            this.Parent = Util.GetString(Parent);
            this.CurrentBalance = Util.GetDecimal(CurrentBalance);
            this.BalanaceType = Util.GetInt(BalanaceType);
            this.PendingCheques = Util.GetInt(PendingCheques);

           iPkValue=Util.GetString(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, objSQL.ToString(),
                         new MySqlParameter("@Loc", Location),
                         new MySqlParameter("@Hosp", HospCode),
                         new MySqlParameter("@GroupID", GroupID),
                         new MySqlParameter("@Hospital_ID", Hospital_ID),
                         new MySqlParameter("@LegderName", LegderName),
                         new MySqlParameter("@LegderUserID", LedgerUserID),
                         new MySqlParameter("@IncomeTaxNumber", IncomeTaxNumber),
                         new MySqlParameter("@SalesTaxNumber", SalesTaxNumber),
                         new MySqlParameter("@InterStateSTNumber", InterStateSTNumber),
                         new MySqlParameter("@VATTINNumber", VATTINNumber),
                         new MySqlParameter("@OpeningBalance", OpeningBalance),
                         new MySqlParameter("@ClosingBalance", ClosingBalance),
                         new MySqlParameter("@RoundingMethod", RoundingMethod),
                         new MySqlParameter("@NotificationNumber", NotificationNumber),
                         new MySqlParameter("@RegistrationNumber", RegistrationNumber),
                         new MySqlParameter("@ServiceCategory", ServiceCategory),
                         new MySqlParameter("@ExciseLedgerClassification", ExciseLedgerClassification),
                         new MySqlParameter("@ExciseRegistrationNumber", ExciseRegistrationNumber),
                         new MySqlParameter("@ExciseAccountHead", ExciseAccountHead),
                         new MySqlParameter("@ExciseDutyType", ExciseDutyType),
                         new MySqlParameter("@TraderExciseRegNo", TraderExciseRegNo),
                         new MySqlParameter("@TraderExciseRange", TraderExciseRange),
                         new MySqlParameter("@TraderExciseDivision", TraderExciseDivision),
                         new MySqlParameter("@TraderExciseCommissionerate", TraderExciseCommissionerate),
                         new MySqlParameter("@TraderLedNatureofPurchase", TraderLedNatureofPurchase),
                         new MySqlParameter("@TDSDeducteeType", TDSDeducteeType),
                         new MySqlParameter("@TDSRateName", TDSRateName),
                         new MySqlParameter("@TDSDeducteeSectionNumber", TDSDeducteeSectionNumber),
                         new MySqlParameter("@LedgerFBTCategory", LedgerFBTCategory),
                         new MySqlParameter("@IsTCSApplicable", IsTCSApplicable),
                         new MySqlParameter("@IsTDSApplicable", IsTDSApplicable),
                         new MySqlParameter("@IsFBTApplicable", IsFBTApplicable),
                         new MySqlParameter("@IsGSTApplicable", IsGSTApplicable),
                         new MySqlParameter("@CreditLimit", CreditLimit),
                         new MySqlParameter("@Parent", Parent),
                         new MySqlParameter("@CurrentBalance", CurrentBalance),
                         new MySqlParameter("@BalanaceType", BalanaceType),
                         new MySqlParameter("@PendingCheques", PendingCheques)));

               // iPkValue = Util.GetInt(cmd.ExecuteScalar().ToString());

            //iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("UPDATE f_ledgermaster SET Hospital_ID=?,LegderName = ?,LedgerUserID = ?, IncomeTaxNumber = ?,SalesTaxNumber = ?");
            objSQL.Append("InterStateSTNumber = ?,VATTINNumber=?,OpeningBalance = ?,ClosingBalance = ?" );
            objSQL.Append("RoundingMethod = ?,NotificationNumber=?,RegistrationNumber=?," );
            objSQL.Append("ServiceCategory = ?,ExciseLedgerClassification = ?,ExciseRegistrationNumber = ?," );
            objSQL.Append("ExciseAccountHead = ?,ExciseDutyType = ?,TraderExciseRegNo = ?," );
            objSQL.Append("TraderExciseRange = ?,TraderExciseDivision = ?,TraderExciseCommissionerate=?,TraderLedNatureofPurchase = ?," );
            objSQL.Append("TDSDeducteeType = ?,TDSRateName = ?,TDSDeducteeSectionNumber=?,LedgerFBTCategory = ?," );
            objSQL.Append("IsTCSApplicable = ?,IsTDSApplicable = ?,IsFBTApplicable=?,IsGSTApplicable = ?,CreditLimit=?,Parent=?,CurrentBalance = ?,BalanaceType=?,PendingCheques=?  WHERE LedgerNumber = ? ");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.LedgerNumber = Util.GetString(LedgerNumber);
            this.LegderName = Util.GetString(LegderName);
            this.LedgerUserID = Util.GetString(LedgerUserID);
            this.IncomeTaxNumber = Util.GetString(IncomeTaxNumber);
            this.SalesTaxNumber = Util.GetString(SalesTaxNumber);
             this.InterStateSTNumber = Util.GetString(InterStateSTNumber);
            this.VATTINNumber = Util.GetString(VATTINNumber);
            this.OpeningBalance = Util.GetDecimal(OpeningBalance);
            this.ClosingBalance = Util.GetDecimal(ClosingBalance);
            this.RoundingMethod = Util.GetString(RoundingMethod);
            this.NotificationNumber = Util.GetString(NotificationNumber);
            this.RegistrationNumber = Util.GetString(RegistrationNumber);
            this.ServiceCategory = Util.GetString(ServiceCategory);
            this.ExciseLedgerClassification = Util.GetString(ExciseLedgerClassification);
            this.ExciseRegistrationNumber = Util.GetString(ExciseRegistrationNumber);
            this.ExciseAccountHead = Util.GetString(ExciseAccountHead);
            this.ExciseDutyType = Util.GetString(ExciseDutyType);
            this.TraderExciseRegNo = Util.GetString(TraderExciseRegNo);
            this.TraderExciseRange = Util.GetString(TraderExciseRange);
            this.TraderExciseDivision = Util.GetString(TraderExciseDivision);
            this.TraderExciseCommissionerate = Util.GetString(TraderExciseCommissionerate);
            this.TraderLedNatureofPurchase = Util.GetString(TraderLedNatureofPurchase);
            this.TDSDeducteeType = Util.GetString(TDSDeducteeType);
            this.TDSRateName = Util.GetString(TDSRateName);
            this.TDSDeducteeSectionNumber = Util.GetString(TDSDeducteeSectionNumber);
            this.LedgerFBTCategory = Util.GetString(LedgerFBTCategory);
            this.IsTCSApplicable = Util.GetString(IsTCSApplicable);
            this.IsTDSApplicable = Util.GetString(IsTDSApplicable);
            this.IsFBTApplicable = Util.GetString(IsFBTApplicable);
            this.IsGSTApplicable = Util.GetString(IsGSTApplicable);
            this.CreditLimit = Util.GetString(CreditLimit);
            this.Parent = Util.GetString(Parent);
            this.CurrentBalance = Util.GetDecimal(CurrentBalance);
            this.BalanaceType = Util.GetInt(BalanaceType);
            this.PendingCheques = Util.GetInt(PendingCheques);
            
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@LegderName", LegderName),
                new MySqlParameter("@LedgerUserID", LedgerUserID),
                new MySqlParameter("@IncomeTaxNumber", IncomeTaxNumber),
                new MySqlParameter("@SalesTaxNumber", SalesTaxNumber),
                new MySqlParameter("@InterStateSTNumber", InterStateSTNumber),
                new MySqlParameter("@VATTINNumber", VATTINNumber),
                new MySqlParameter("@OpeningBalance", OpeningBalance),
                new MySqlParameter("@ClosingBalance", ClosingBalance),
                new MySqlParameter("@RoundingMethod", RoundingMethod),
                new MySqlParameter("@NotificationNumber", NotificationNumber),
                new MySqlParameter("@RegistrationNumber", RegistrationNumber),
                new MySqlParameter("@ServiceCategory", ServiceCategory),
                new MySqlParameter("@ExciseLedgerClassification", ExciseLedgerClassification),
                new MySqlParameter("@ExciseRegistrationNumber", ExciseRegistrationNumber),
                new MySqlParameter("@ExciseAccountHead", ExciseAccountHead),
                new MySqlParameter("@ExciseDutyType", ExciseDutyType),
                new MySqlParameter("@TraderExciseRegNo", TraderExciseRegNo),
                new MySqlParameter("@TraderExciseRange", TraderExciseRange),
                new MySqlParameter("@TraderExciseDivision", TraderExciseDivision),
                new MySqlParameter("@TraderExciseCommissionerate", TraderExciseCommissionerate),
                new MySqlParameter("@TraderLedNatureofPurchase", TraderLedNatureofPurchase),
                new MySqlParameter("@TDSDeducteeType", TDSDeducteeType),
                new MySqlParameter("@TDSRateName", TDSRateName),
                new MySqlParameter("@TDSDeducteeSectionNumber", TDSDeducteeSectionNumber),
                new MySqlParameter("@LedgerFBTCategory", LedgerFBTCategory),
                new MySqlParameter("@IsTCSApplicable", IsTCSApplicable),
                new MySqlParameter("@IsTDSApplicable", IsTDSApplicable),
                new MySqlParameter("@IsFBTApplicable", IsFBTApplicable),
                new MySqlParameter("@IsGSTApplicable", IsGSTApplicable),
                new MySqlParameter("@CreditLimit", CreditLimit),
                new MySqlParameter("@Parent", Parent),
                new MySqlParameter("@CurrentBalance", CurrentBalance),
                new MySqlParameter("@BalanaceType", BalanaceType),
                new MySqlParameter("@PendingCheques", PendingCheques));

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
        this.LedgerNumber = iPkValue.ToString();
        return this.Delete();
    }
    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_ledgermaster WHERE LedgerNumber = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("LedgerNumber", LedgerNumber));
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
            string sSQL = "SELECT * FROM f_ledgermaster WHERE LedgerNumber = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@LedgerNumber", LedgerNumber)).Tables[0];

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
            string sParams = "LedgerNumber=" + this.LedgerNumber.ToString();
            throw (ex);
        }

    }
    public bool Load(int iPkValue)
    {
        this.LedgerNumber = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
       
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.HospCode]);
        this.LedgerNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.LedgerNumber]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.Hospital_ID]);
        this.GroupID = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.GroupID]);
        this.LegderName = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.LegderName]);
        this.LedgerUserID = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.LedgerUserID]);
        this.IncomeTaxNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.IncomeTaxNumber]);
        this.SalesTaxNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.SalesTaxNumber]);
        this.InterStateSTNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.InterStateSTNumber]);
        this.VATTINNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.VATTINNumber]);
        this.OpeningBalance = Util.GetDecimal(dtTemp.Rows[0][AllTables.ledgermaster.OpeningBalance]);
        this.ClosingBalance = Util.GetDecimal(dtTemp.Rows[0][AllTables.ledgermaster.ClosingBalance]);
        this.RoundingMethod = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.RoundingMethod]);
        this.NotificationNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.NotificationNumber]);
        this.RegistrationNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.RegistrationNumber]);
        this.ServiceCategory = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.ServiceCategory]);
        this.ExciseLedgerClassification = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.ExciseLedgerClassification]);
        this.ExciseRegistrationNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.ExciseRegistrationNumber]);
        this.ExciseAccountHead = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.ExciseAccountHead]);
        this.ExciseDutyType = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.ExciseDutyType]);
        this.TraderExciseRegNo = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TraderExciseRegNo]);
        this.TraderExciseRange = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TraderExciseRange]);
        this.TraderExciseDivision = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TraderExciseDivision]);
        this.TraderExciseCommissionerate = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TraderExciseCommissionerate]);
        this.TraderLedNatureofPurchase = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TraderLedNatureofPurchase]);
        this.TDSDeducteeType = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TDSDeducteeType]);
        this.TDSRateName = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TDSRateName]);
        this.TDSDeducteeSectionNumber = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.TDSDeducteeSectionNumber]);
        this.LedgerFBTCategory = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.LedgerFBTCategory]);
        this.IsTCSApplicable = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.IsTCSApplicable]);
        this.IsTDSApplicable = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.IsTDSApplicable]);
        this.IsFBTApplicable = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.IsFBTApplicable]);
        this.IsGSTApplicable = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.IsGSTApplicable]);
         this.CreditLimit = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.CreditLimit]);
         this.Parent = Util.GetString(dtTemp.Rows[0][AllTables.ledgermaster.Parent]);
         this.CurrentBalance = Util.GetDecimal(dtTemp.Rows[0][AllTables.ledgermaster.CurrentBalance]);
         this.BalanaceType = Util.GetInt(dtTemp.Rows[0][AllTables.ledgermaster.BalanaceType]);
         this.PendingCheques = Util.GetInt(dtTemp.Rows[0][AllTables.ledgermaster.PendingCheques]);
         
    }
    #endregion


}