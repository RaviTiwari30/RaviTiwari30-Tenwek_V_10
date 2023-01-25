using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

/// <summary>
/// Summary description for Receipt
/// </summary>
public class ExpenceReceipt
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _ReceiptNo;
    private string _Hospital_ID;
    private string _LedgerNoCr;
    private string _LedgerNoDr;
    private string _AsainstLedgerTnxNo;
    private decimal _AmountPaid;
    private System.DateTime _Date;
    private System.DateTime _Time;
    private string _Reciever;
    private string _Depositor;
    private string _IsCheque_Draft;
    private string _ChequeNo_DraftNo;
    private string _StatusCheque;
    private string _IsPayementByInsurance;
    private DateTime _Cheque_DDdate;
    private string _TransactionID;
    private int _PanelID;
    private string _Cancel_UserID;
    private DateTime _CancelDate;
    private string _CancelReason;
    private int _IsCancel;
    private decimal _Discount;
    private string _Naration;
    private string _ExpenceTypeId;
    private string _ExpenceType;
    private string _ExpenceTo;
    private string _ExpenceToId;
    private string _EmployeeID;
    private int _RoleID;
    private decimal _AmtCash;
    private decimal _AmtCreditCard;
    private decimal _AmtCheque;
    private decimal _AmtCredit;
    private string _CreditCardNo;
    private string _ChequeNo;
    private string _CreditCardBankName;
    private string _ChequeBankName;
    private int _CentreID;
    private string _Remark;
    private string _ApprovedBy;
    [DefaultValue("")]
    private string _ReceivedAgainstReceiptNo;
    private string _EmployeeName;
    private int _EmployeeType;


    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public ExpenceReceipt()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public ExpenceReceipt(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual decimal AmtCash
    {
        get
        {
            return _AmtCash;
        }
        set
        {
            _AmtCash = value;
        }
    }

    public virtual decimal AmtCreditCard
    {
        get
        {
            return _AmtCreditCard;
        }
        set
        {
            _AmtCreditCard = value;
        }
    }

    public virtual decimal AmtCheque
    {
        get
        {
            return _AmtCheque;
        }
        set
        {
            _AmtCheque = value;
        }
    }

    public virtual decimal AmtCredit
    {
        get
        {
            return _AmtCredit;
        }
        set
        {
            _AmtCredit = value;
        }
    }

    public virtual string CreditCardNo
    {
        get
        {
            return _CreditCardNo;
        }
        set
        {
            _CreditCardNo = value;
        }
    }

    public virtual string ChequeNo
    {
        get
        {
            return _ChequeNo;
        }
        set
        {
            _ChequeNo = value;
        }
    }

    public virtual string CreditCardBankName
    {
        get
        {
            return _CreditCardBankName;
        }
        set
        {
            _CreditCardBankName = value;
        }
    }

    public virtual string ChequeBankName
    {
        get
        {
            return _ChequeBankName;
        }
        set
        {
            _ChequeBankName = value;
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

    public virtual string ReceiptNo
    {
        get
        {
            return _ReceiptNo;
        }
        set
        {
            _ReceiptNo = value;
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

    public virtual string LedgerNoCr
    {
        get
        {
            return _LedgerNoCr;
        }
        set
        {
            _LedgerNoCr = value;
        }
    }

    public virtual string LedgerNoDr
    {
        get
        {
            return _LedgerNoDr;
        }
        set
        {
            _LedgerNoDr = value;
        }
    }

    public virtual string AsainstLedgerTnxNo
    {
        get
        {
            return _AsainstLedgerTnxNo;
        }
        set
        {
            _AsainstLedgerTnxNo = value;
        }
    }

    public virtual decimal AmountPaid
    {
        get
        {
            return _AmountPaid;
        }
        set
        {
            _AmountPaid = value;
        }
    }

    public virtual DateTime Date
    {
        get
        {
            return _Date;
        }
        set
        {
            _Date = value;
        }
    }

    public virtual DateTime Time
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

    public virtual string Reciever
    {
        get
        {
            return _Reciever;
        }
        set
        {
            _Reciever = value;
        }
    }

    public virtual string Depositor
    {
        get
        {
            return _Depositor;
        }
        set
        {
            _Depositor = value;
        }
    }

    public virtual string IsCheque_Draft
    {
        get
        {
            return _IsCheque_Draft;
        }
        set
        {
            _IsCheque_Draft = value;
        }
    }

    public virtual string ChequeNo_DraftNo
    {
        get
        {
            return _ChequeNo_DraftNo;
        }
        set
        {
            _ChequeNo_DraftNo = value;
        }
    }

    public virtual string StatusCheque
    {
        get
        {
            return _StatusCheque;
        }
        set
        {
            _StatusCheque = value;
        }
    }

    public virtual string IsPayementByInsurance
    {
        get
        {
            return _IsPayementByInsurance;
        }
        set
        {
            _IsPayementByInsurance = value;
        }
    }

    public virtual DateTime Cheque_DDdate
    {
        get
        {
            return _Cheque_DDdate;
        }
        set
        {
            _Cheque_DDdate = value;
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

    public virtual string Cancel_UserID
    {
        get
        {
            return _Cancel_UserID;
        }
        set
        {
            _Cancel_UserID = value;
        }
    }

    public virtual DateTime CancelDate
    {
        get
        {
            return _CancelDate;
        }
        set
        {
            _CancelDate = value;
        }
    }

    public virtual string CancelReason
    {
        get
        {
            return _CancelReason;
        }
        set
        {
            _CancelReason = value;
        }
    }

    public virtual int IsCancel
    {
        get
        {
            return _IsCancel;
        }
        set
        {
            _IsCancel = value;
        }
    }

    public virtual decimal Discount
    {
        get
        {
            return _Discount;
        }
        set
        {
            _Discount = value;
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

    public virtual string ExpenceTypeId
    {
        get
        {
            return _ExpenceTypeId;
        }
        set
        {
            _ExpenceTypeId = value;
        }
    }

    public virtual string ExpenceType
    {
        get
        {
            return _ExpenceType;
        }
        set
        {
            _ExpenceType = value;
        }
    }

    public virtual string ExpenceTo
    {
        get
        {
            return _ExpenceTo;
        }
        set
        {
            _ExpenceTo = value;
        }
    }

    public virtual string ExpenceToId
    {
        get
        {
            return _ExpenceToId;
        }
        set
        {
            _ExpenceToId = value;
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
    public virtual string Remarks
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

    public virtual string EmployeeID
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



    public virtual string ApprovedBy
    {
        get
        {
            return _ApprovedBy;
        }
        set
        {
            _ApprovedBy = value;
        }
    }

    public virtual string ReceivedAgainstReceiptNo
    {
        get
        {
            return _ReceivedAgainstReceiptNo;
        }
        set
        {
            _ReceivedAgainstReceiptNo = value;
        }
    }

    
    public virtual int RoleID
    {
        get
        {
            return _RoleID;
        }
        set
        {
            _RoleID = value;
        }
    }

    public virtual string EmployeeName
    {
        get
        {
            return _EmployeeName;
        }
        set
        {
            _EmployeeName = value;
        }
    }

    public virtual int EmployeeType
    {
        get
        {
            return _EmployeeType;
        }
        set
        {
            _EmployeeType = value;
        }
    }



    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_ExpenceReceipt");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter RepNo = new MySqlParameter();
            RepNo.ParameterName = "@Receipt_No";
            RepNo.MySqlDbType = MySqlDbType.VarChar;
            RepNo.Size = 50;
            RepNo.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.ReceiptNo = Util.GetString(ReceiptNo);
            this.LedgerNoCr = Util.GetString(LedgerNoCr);
            this.LedgerNoDr = Util.GetString(LedgerNoDr);
            this.AsainstLedgerTnxNo = Util.GetString(AsainstLedgerTnxNo);
            this.AmountPaid = Util.GetDecimal(AmountPaid);
            this.Date = Util.GetDateTime(Date);
            this.Time = Util.GetDateTime(Time);
            this.Reciever = Util.GetString(Reciever);
            this.Depositor = Util.GetString(Depositor);
            this.IsCheque_Draft = Util.GetString(IsCheque_Draft);
            this.ChequeNo_DraftNo = Util.GetString(ChequeNo_DraftNo);
            this.StatusCheque = Util.GetString(StatusCheque);
            this.IsPayementByInsurance = Util.GetString(IsPayementByInsurance);
            this.Cheque_DDdate = Util.GetDateTime(Cheque_DDdate);
            this.TransactionID = Util.GetString(TransactionID);
            this.PanelID = Util.GetInt(PanelID);
            this.Cancel_UserID = Util.GetString(Cancel_UserID);
            this.CancelDate = Util.GetDateTime(CancelDate);
            this.CancelReason = Util.GetString(CancelReason);
            this.IsCancel = Util.GetInt(IsCancel);
            this.Discount = Util.GetDecimal(Discount);
            this.Naration = Util.GetString(Naration);
            this.AmtCash = Util.GetDecimal(AmtCash);
            this.AmtCreditCard = Util.GetDecimal(AmtCreditCard);
            this.AmtCheque = Util.GetDecimal(AmtCheque);
            this.AmtCredit = Util.GetDecimal(AmtCredit);
            this.CreditCardNo = Util.GetString(CreditCardNo);
            this.ChequeNo = Util.GetString(ChequeNo);
            this.CreditCardBankName = Util.GetString(CreditCardBankName);
            this.ChequeBankName = Util.GetString(ChequeBankName);
            this.ExpenceTypeId = Util.GetString(ExpenceTypeId);
            this.ExpenceType = Util.GetString(ExpenceType);
            this.ExpenceTo = Util.GetString(ExpenceTo);
            this.ExpenceToId = Util.GetString(ExpenceToId);
            this.CentreID = Util.GetInt(CentreID);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerNoCr", LedgerNoCr));
            cmd.Parameters.Add(new MySqlParameter("@LedgerNoDr", LedgerNoDr));
            cmd.Parameters.Add(new MySqlParameter("@AsainstLedgerTnxNo", AsainstLedgerTnxNo));
            cmd.Parameters.Add(new MySqlParameter("@AmountPaid", AmountPaid));
            cmd.Parameters.Add(new MySqlParameter("@DATE", Date));
            cmd.Parameters.Add(new MySqlParameter("@TIME", Time));
            cmd.Parameters.Add(new MySqlParameter("@Reciever", Reciever));
            cmd.Parameters.Add(new MySqlParameter("@Depositor", Depositor));
            cmd.Parameters.Add(new MySqlParameter("@IsCheque_Draft", IsCheque_Draft));
            cmd.Parameters.Add(new MySqlParameter("@ChequeNo_DraftNo", ChequeNo_DraftNo));
            cmd.Parameters.Add(new MySqlParameter("@StatusCheque", StatusCheque));
            cmd.Parameters.Add(new MySqlParameter("@IsPayementByInsurance", IsPayementByInsurance));
            cmd.Parameters.Add(new MySqlParameter("@Cheque_DDdate", Cheque_DDdate));
            cmd.Parameters.Add(new MySqlParameter("@TransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
            cmd.Parameters.Add(new MySqlParameter("@Cancel_UserID", Cancel_UserID));
            cmd.Parameters.Add(new MySqlParameter("@CancelDate", CancelDate));
            cmd.Parameters.Add(new MySqlParameter("@CancelReasonn", CancelReason));
            cmd.Parameters.Add(new MySqlParameter("@IsCancel", IsCancel));
            cmd.Parameters.Add(new MySqlParameter("@Discount", Discount));
            cmd.Parameters.Add(new MySqlParameter("@Naration", Naration));
            cmd.Parameters.Add(new MySqlParameter("@AmtCash", AmtCash));
            cmd.Parameters.Add(new MySqlParameter("@AmtCreditCard", AmtCreditCard));
            cmd.Parameters.Add(new MySqlParameter("@AmtCheque", AmtCheque));
            cmd.Parameters.Add(new MySqlParameter("@AmtCredit", AmtCredit));
            cmd.Parameters.Add(new MySqlParameter("@CreditCardNo", CreditCardNo));
            cmd.Parameters.Add(new MySqlParameter("@ChequeNo", ChequeNo));
            cmd.Parameters.Add(new MySqlParameter("@CreditCardBankName", CreditCardBankName));
            cmd.Parameters.Add(new MySqlParameter("@ChequeBankName", ChequeBankName));
            cmd.Parameters.Add(new MySqlParameter("@ExpenceTypeId", ExpenceTypeId));
            cmd.Parameters.Add(new MySqlParameter("@ExpenceType", ExpenceType));
            cmd.Parameters.Add(new MySqlParameter("@ExpenceTo", ExpenceTo));
            cmd.Parameters.Add(new MySqlParameter("@ExpenceToId", ExpenceToId));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@EmployeeID", EmployeeID));
            cmd.Parameters.Add(new MySqlParameter("@RoleID", RoleID));
            cmd.Parameters.Add(new MySqlParameter("@ApprovedBy", ApprovedBy));
            cmd.Parameters.Add(new MySqlParameter("@ReceivedAgainstReceiptNo", ReceivedAgainstReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@EmployeeName", EmployeeName));
            cmd.Parameters.Add(new MySqlParameter("@EmployeeType", EmployeeType));
            cmd.Parameters.Add(RepNo);
            ReceiptNo = cmd.ExecuteScalar().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ReceiptNo;
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

}