#region All NameSpace

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All NameSpace


public class ipdadjustment
{   
    #region All Memory Variables
    private int SNo;
    private string _PatientID;
    private string _TransactionID;
    private DateTime _DateofAdjustment;
    private decimal _TotalBilledAmt;
    private decimal _AdjustmentAmt;
    private string _AdjustmentReason;
    private string _PatientLedgerNo;
    private string _BillNo;
    private decimal _DiscountOnBill;
    private string _DiscountOnBillReason;
    private string _UserID;
    private int _FileClose_flag;
    private decimal _CreditLimitPanel;
    private decimal _PatientCashAmt;
    private decimal _PanelApprovedAmt;
    private DateTime _PanelApprovalDate;
    private string _PanelAppRemarks;
    private string _PanelAppUserID;
    private int _IsBilledClosed;
    private string _PanelAppRemarksHistory;
    private string _ClaimNo;
    private string _BillingRemarks;
    private DateTime _BillDate;
    private string _DoctorID;
    private int _PanelID;
    private string _CreditLimitType;
    private string _Hospital_ID;
    private int _CentreID;
    private string _Patient_Type;
    private string _CurrentAge;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    #endregion
    #region Overloaded Constructor
    public ipdadjustment()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}
    public ipdadjustment(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    
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
    public virtual string AdjustmentReason
    {
        get
        {
            return _AdjustmentReason;
        }
        set
        {
            _AdjustmentReason = value;
        }
    }
   
    public virtual DateTime DateofAdjustment
    {
        get
        {
            return _DateofAdjustment;
        }
        set
        {
            _DateofAdjustment = value;
        }
    }
    public virtual decimal TotalBilledAmt
    {
        get
        {
            return _TotalBilledAmt;
        }
        set
        {
            _TotalBilledAmt = value;
        }

    }
 
    public virtual decimal AdjustmentAmt
    {
        get
        {
            return _AdjustmentAmt;
        }
        set
        {
            _AdjustmentAmt = value;
        }
    }

	public string PatientLedgerNo
	{
		get { return _PatientLedgerNo;}
		set { _PatientLedgerNo = value;}
	}

	public string BillNo
	{
		get { return _BillNo;}
		set { _BillNo = value;}
	}

	public decimal DiscountOnBill
	{
		get { return _DiscountOnBill;}
		set { _DiscountOnBill = value;}
	}

	public string DiscountOnBillReason
	{
		get { return _DiscountOnBillReason;}
		set { _DiscountOnBillReason = value;}
	}

	public string UserID
	{
		get { return _UserID;}
		set { _UserID = value;}
	}


	public int FileClose_flag
	{
		get { return _FileClose_flag;}
		set { _FileClose_flag = value;}
	}

    public virtual decimal CreditLimitPanel
    {
        get
        { return _CreditLimitPanel; }
        set
        { _CreditLimitPanel = value;}
    }

    public virtual decimal PatientCashAmt
    {
        get
        { return _PatientCashAmt; }
        set
        { _PatientCashAmt = value; }
    }
    public virtual decimal PanelApprovedAmt
    {
        get
        { return _PanelApprovedAmt; }
        set
        { _PanelApprovedAmt = value; }
    }
    public virtual DateTime PanelApprovalDate
    {
        get
        { return _PanelApprovalDate; }
        set
        { _PanelApprovalDate = value; }
    }
    public virtual string PanelAppRemarks
    {
        get
        { return _PanelAppRemarks; }
        set
        { _PanelAppRemarks = value; }
    }
    public virtual string PanelAppUserID
    {
        get
        { return _PanelAppUserID; }
        set
        { _PanelAppUserID = value; }
    }
    public virtual int IsBilledClosed
    {
        get
        { return _IsBilledClosed; }
        set
        { _IsBilledClosed = value; }
    }

    public virtual string PanelAppRemarksHistory
    {
        get
        { return _PanelAppRemarksHistory; }
        set
        { _PanelAppRemarksHistory = value; }
    }

    public virtual string ClaimNo
    {
        get
        { return _ClaimNo; }
        set
        { _ClaimNo = value; }
    }


    public virtual string BillingRemarks
    {
        get
        { return _BillingRemarks; }
        set
        { _BillingRemarks = value; }
    }

    public virtual DateTime BillDate
    {
        get
        { return _BillDate; }
        set
        { _BillDate = value; }
    }


    public virtual string DoctorID
    {
        get
        { return _DoctorID; }
        set
        { _DoctorID = value; }
    }

    public virtual int PanelID
    {
        get
        { return _PanelID; }
        set
        { _PanelID = value; }
    }
    public virtual string CreditLimitType
    {
        get { return _CreditLimitType; }
        set { _CreditLimitType = value; }
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
    public virtual string Patient_Type
        {
        get
            {
            return _Patient_Type;
            }
        set
            {
            _Patient_Type = value;
            }
        }
    public virtual string CurrentAge
        {
        get
            {
            return _CurrentAge;
            }
        set
            {
            _CurrentAge = value;
            }
        }
    
#endregion
    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_ipdadjustment(PatientID,TransactionID,PatientLedgerNo,FileClose_flag,CreditLimitPanel,PatientCashAmt,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppUserID,IsBilledClosed,PanelAppRemarksHistory,ClaimNo,BillingRemarks,BillDate,DoctorID,PanelID,CreditLimitType,Hospital_ID,CentreID,Patient_Type,CurrentAge)");
            objSQL.Append("VALUES (@PatientID, @TransactionID, @PatientLedgerNo, @FileClose_flag,@CreditLimitPanel,@PatientCashAmt,@PanelApprovedAmt,@PanelApprovalDate,@PanelAppRemarks,@PanelAppUserID,@IsBilledClosed,@PanelAppRemarksHistory,@ClaimNo,@BillingRemarks,@BillDate,@DoctorID,@PanelID,@CreditLimitType,@Hospital_ID,@CentreID,@Patient_Type,@CurrentAge)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.PatientLedgerNo = Util.GetString(PatientLedgerNo);
            this.FileClose_flag = 0;
            this.CreditLimitPanel = Util.GetDecimal(CreditLimitPanel);
            this.PatientCashAmt = Util.GetDecimal(PatientCashAmt);
            this.PanelApprovedAmt = Util.GetDecimal(PanelApprovedAmt);
            this.PanelApprovalDate = Util.GetDateTime(PanelApprovalDate);
            this.PanelAppRemarks = Util.GetString(PanelAppRemarks);
            this.PanelAppUserID = Util.GetString(PanelAppUserID);
            this.IsBilledClosed = Util.GetInt(IsBilledClosed);
            this.PanelAppRemarksHistory = Util.GetString(PanelAppRemarksHistory);
            this.ClaimNo = Util.GetString(ClaimNo);
            this.BillingRemarks = Util.GetString(BillingRemarks);
            this.BillDate = Util.GetDateTime(BillDate);
            this.DoctorID = Util.GetString(DoctorID);
            this.PanelID = Util.GetInt(PanelID);
            this.CreditLimitType = Util.GetString(CreditLimitType);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.CentreID = Util.GetInt(CentreID);
            this.Patient_Type = Util.GetString(Patient_Type);
            this.CurrentAge = Util.GetString(CurrentAge);
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@TransactionID", TransactionID),
                new MySqlParameter("@PatientLedgerNo", PatientLedgerNo),
                new MySqlParameter("@FileClose_flag", FileClose_flag),
                new MySqlParameter("@CreditLimitPanel", CreditLimitPanel),
                new MySqlParameter("@PatientCashAmt", PatientCashAmt),
                new MySqlParameter("@PanelApprovedAmt", PanelApprovedAmt),
                new MySqlParameter("@PanelApprovalDate", PanelApprovalDate),
                new MySqlParameter("@PanelAppRemarks", PanelAppRemarks),
                new MySqlParameter("@PanelAppUserID", PanelAppUserID),
                new MySqlParameter("@IsBilledClosed", IsBilledClosed),
                new MySqlParameter("@PanelAppRemarksHistory", PanelAppRemarksHistory),
                new MySqlParameter("@ClaimNo", ClaimNo),
                new MySqlParameter("@BillingRemarks", BillingRemarks),
                new MySqlParameter("@BillDate", BillDate),
                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@PanelID", PanelID), 
                new MySqlParameter("@CreditLimitType", CreditLimitType),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@Patient_Type", Patient_Type),
                 new MySqlParameter("@CurrentAge", CurrentAge));          

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

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
            throw (ex);
        }

    }
   
    public void UpdateBillingInfo(string BillNo,decimal BilledAmt,string PTransID,string UserID)
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update f_ipdadjustment set BillNo = '" + BillNo + "',TotalBilledAmt=" + BilledAmt + ",UserID ='" + UserID + "',TempBillNo = '' where TransactionID = '" + PTransID + "'");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();                
            }            

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
        }
    }

    public int UpdateBillingInfo(string BillNo, string PTransID, string UserID,decimal BillTotal)
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update f_ipdadjustment set BillNo = '" + BillNo + "',UserID ='" + UserID + "',TotalBilledAmt="+BillTotal+" where TransactionID = '" + PTransID + "'");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

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
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }

    public int UpdateBillingInfo(string BillNo, string BillDate, string PTransID, string UserID, decimal BillTotal, decimal ServiceTaxAmt, decimal ServiceTaxPer, decimal ServiceTaxSurChgAmt, decimal SerTaxSurChgPer, decimal SerTaxBillAmt, int BillingType, string Narration, int S_CountryID, decimal S_Amount, string S_Notation, decimal C_Factor, decimal RoundOff, int PanelID, MySqlTransaction tnx, int BillCountryID, string BillNotation, decimal BillFactor)
        {
        try
            {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append(" update patient_medical_history set BillNo = '" + BillNo + "',BillDate='" + BillDate + "',");//f_ipdadjustment
            objSQL.Append(" BillGeneratedBy ='" + UserID + "',TotalBilledAmt=" + BillTotal + ",");
            objSQL.Append(" ServiceTaxAmt = " + ServiceTaxAmt + ",ServiceTaxPer =" + ServiceTaxPer + ",");
            objSQL.Append(" ServiceTaxSurChgAmt=" + ServiceTaxSurChgAmt + ",SerTaxSurChgPer=" + SerTaxSurChgPer + ",");
            objSQL.Append(" SerTaxBillAmount = " + SerTaxBillAmt + ",BillingType=" + BillingType + ",");
            objSQL.Append(" PanelID=" + PanelID + ",");
            objSQL.Append(" Narration='" + Narration + "',S_Amount='" + S_Amount + "',S_CountryID='" + S_CountryID + "',S_Notation='" + S_Notation + "',C_Factor='" + C_Factor + "' , ");

            objSQL.Append(" Bill_CountryID=" + BillCountryID + ",Bill_Notation='" + BillNotation + "', Bill_Factor=" + BillFactor + ", ");

            if (Resources.Resource.IsBilledFinalised == "1")
                objSQL.Append(" IsBilledClosed = 0, ");
            else
                objSQL.Append(" IsBilledClosed = 1,BillClosedUserId='" + UserID + "',BillCloseddate=NOW(),  ");


            objSQL.Append(" RoundOff='" + RoundOff + "' where TransactionID = '" + PTransID + "'");
          
            RowAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, objSQL.ToString());
           // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL UpdateLTD('" + PTransID + "')");
            
            return RowAffected;
        }
        catch (Exception ex)
        {
            
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }



    public bool updateAdjustment(decimal Discount, string DiscountReason, decimal Adjustment, string AdjusReason, string PTransID, string ApprovalBy, string BillAmount)
    {
        try
        {
            int RowAffected;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update f_ipdadjustment set DateofAdjustment = CURDATE(),");
            objSQL.Append("DiscountOnBill = " + Discount + ",DiscountOnBillReason = '" + DiscountReason + "',AdjustmentAmt = " + Adjustment + ",");
            objSQL.Append("AdjustmentReason = '" + AdjusReason + "',ApprovalBy = '" + ApprovalBy + "',TotalBilledAmt = " + BillAmount + " where TransactionID='" + PTransID + "'");


            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return true;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();

            }
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }


    public bool updateAdjustmentDisc(decimal Discount, string DiscountReason, decimal Adjustment, string AdjusReason, string PTransID, string ApprovalBy, string BillAmount, string DiscUserID, decimal DiscPer)
    {
        try
        {
            int RowAffected;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update patient_medical_history set DateofAdjustment = CURDATE(),");
            objSQL.Append("DiscountOnBill = " + Discount + ",DiscountOnBillReason = '" + DiscountReason + "',AdjustmentAmt = " + Adjustment + ",");
            objSQL.Append("AdjustmentReason = '" + AdjusReason + "',ApprovalBy = '" + ApprovalBy + "',TotalBilledAmt = " + BillAmount + ",DiscUserID='" + DiscUserID + "',TotalBillDiscPer = " + DiscPer + " where TransactionID='" + PTransID + "'");


            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            

            //Devendra Singh 2018-11-12 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertIPDFinalBillDisc(PTransID, "D", objTrans));
                if (IsIntegrated == "0")
                {
                    objTrans.Rollback();
                    objTrans.Dispose();
                    objCon.Close();
                    objCon.Dispose();
                }
            }

            //MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, "CALL UpdateLTD('" + PTransID + "')");
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return true;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();

            }
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }

    public bool d_updateAdjustment(decimal Discount, string DiscountReason, decimal Adjustment, string AdjusReason, string PTransID, string ApprovalBy, string BillAmount)
    {
        try
        {
            int RowAffected;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update d_f_ipdadjustment set DateofAdjustment = curdate(),");
            objSQL.Append("DiscountOnBill = " + Discount + ",DiscountOnBillReason = '" + DiscountReason + "',AdjustmentAmt = " + Adjustment + ",");
            objSQL.Append("AdjustmentReason = '" + AdjusReason + "',ApprovalBy = '" + ApprovalBy + "',TotalBilledAmt = " + BillAmount + " where TransactionID='" + PTransID + "'");


            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return true;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();

            }
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }

    public bool updateAdjustment(decimal Discount, string DiscountReason, string PTransID)
    {
        try
        {
            int RowAffected;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update f_ipdadjustment set DiscountOnBill = " + Discount + ",DiscountOnBillReason = '" + DiscountReason + "' where TransactionID='" + PTransID + "'");
           

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return true;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();

            }
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }
   
    public bool ClosePatientFile(string PTransID)
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("update f_ipdadjustment set FileClose_flag = 1 where TransactionID='"+PTransID+"'");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            if (RowAffected > 0)
                return true;
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
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }
   
    public DataTable GetIPDAdjustment(string PTransID)
    {
        try
        {
            string str = "select * from patient_medical_history where TransactionID = '" + PTransID + "'";

            DataTable ds = new DataTable();
            if (IsLocalConn)
            {
                this.objCon.Open();
                ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
                this.objCon.Close();
                return ds;
            }
            else
            {
                ds = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
                return ds;
            }
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

    public DataTable d_GetIPDAdjustment(string PTransID)
    {

        try
        {
            string str = "select * from d_f_ipdadjustment where TransactionID = '" + PTransID + "'";

            DataTable ds = new DataTable();
            if (IsLocalConn)
            {
                this.objCon.Open();

                ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
                this.objCon.Close();
                return ds;
            }
            else
            {
                ds = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
                return ds;
            }
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

    public int UpDateofAdjustment()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_ipdadjustment SET PatientID=?,TransactionID = ?,DateofAdjustment=?,");
            objSQL.Append("TotalBilledAmt = ?,TotalPaidAmt=?,AdjustmentAmt=?,AdjustmentReason=? WHERE SNo = ? ");
            
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.AdjustmentReason = Util.GetString(AdjustmentReason);
            this.DateofAdjustment = Util.GetDateTime(DateofAdjustment);
            this.TotalBilledAmt = Util.GetDecimal(TotalBilledAmt);
           // this.TotalPaidAmt = Util.GetDecimal(TotalPaidAmt);
            this.AdjustmentAmt = Util.GetDecimal(AdjustmentAmt);
            this.SNo = Util.GetInt(SNo);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@TransactionID", TransactionID),
                new MySqlParameter("@DateofAdjustment", DateofAdjustment),
                new MySqlParameter("@TotalBilledAmt", TotalBilledAmt),
                new MySqlParameter("@AdjustmentAmt", AdjustmentAmt),
                new MySqlParameter("@AdjustmentReason", AdjustmentReason),
                new MySqlParameter("@SNo", SNo));

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

    public int Delete(int iPkValue)
    {
        this.SNo = iPkValue;
        return this.Delete();
    }


    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_ipdadjustment WHERE SNo = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("SNo", SNo));
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

            string sSQL = "SELECT * FROM f_ipdadjustment WHERE SNo = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@SNo", SNo)).Tables[0];

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

            string sParams = "SNo=" + this.SNo.ToString();
            throw (ex);
        }

    }

   
    public bool Load(int iPkValue)
    {
        this.SNo = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.PatientID]);
        this.TransactionID= Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.TransactionID]);
        this.AdjustmentReason= Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.AdjustmentReason]);
        this.TotalBilledAmt = Util.GetDecimal(dtTemp.Rows[0][AllTables.f_ipdadjustment.TotalBilledAmt]);
        this.AdjustmentAmt = Util.GetDecimal(dtTemp.Rows[0][AllTables.f_ipdadjustment.AdjustmentAmt]);
        this.DateofAdjustment = Util.GetDateTime(dtTemp.Rows[0][AllTables.f_ipdadjustment.DateofAdjustment]);

        this.PatientLedgerNo = Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.PatientLedgerNo]);
        this.BillNo = Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.BillNo]);
        this.DiscountOnBill = Util.GetDecimal(dtTemp.Rows[0][AllTables.f_ipdadjustment.DiscountOnBill]);
        this.DiscountOnBillReason = Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.DiscountOnBillReason]);
        this.UserID = Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.UserID]);
        this.FileClose_flag = Int16.Parse(Util.GetString(dtTemp.Rows[0][AllTables.f_ipdadjustment.FileClose_flag]));
        this.CreditLimitPanel = Util.GetDecimal(dtTemp.Rows[0][AllTables.f_ipdadjustment.CreditLimitPanel]);
      ////PatientID,TransactionID,DateofAdjustment,TotalBilledAmt,TotalPaidAmt,AdjustmentAmt,AdjustmentReason f_ipdadjustment
    }
    #endregion

}
