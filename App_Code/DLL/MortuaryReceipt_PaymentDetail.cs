using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>  
/// Summary description for f_receipt_paymentdetail  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:              PANKAJRAWAT 
/// Create date:	4/25/2013 5:34:09 PM 
/// Description:	This class is intended for inserting, updating, deleting values for f_receipt_paymentdetail table 
/// ========================================================================================== 
/// </summary>  

public class MortuaryReceipt_PaymentDetail
{
    public MortuaryReceipt_PaymentDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public MortuaryReceipt_PaymentDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _ReceiptNo;
    private int _PaymentModeID;
    private string _PaymentMode;
    private decimal _Amount;
    private string _RefNo;
    private string _BankName;
    private DateTime _RefDate;
    private string _PaymentRemarks;
    private decimal _S_Amount;
    private int _S_CountryID;
    private string _S_Currency;
    private string _S_Notation;
    private decimal _C_Factor;
    private decimal _deductions;
    private decimal _TDS;
    private decimal _WriteOff;
   
    private int _CentreID;
    private int _HospCentreID;

    private decimal _ReceivedAmt;
    private decimal _ChangeAmt;
    private string _C_ChangeAmt;


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string ReceiptNo { get { return _ReceiptNo; } set { _ReceiptNo = value; } }
    public virtual int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }
    public virtual string PaymentMode { get { return _PaymentMode; } set { _PaymentMode = value; } }
    public virtual decimal Amount { get { return _Amount; } set { _Amount = value; } }
    public virtual string BankName { get { return _BankName; } set { _BankName = value; } }
    public virtual string RefNo { get { return _RefNo; } set { _RefNo = value; } }
    public virtual DateTime RefDate { get { return _RefDate; } set { _RefDate = value; } }
    public virtual string PaymentRemarks { get { return _PaymentRemarks; } set { _PaymentRemarks = value; } }
    public virtual decimal S_Amount { get { return _S_Amount; } set { _S_Amount = value; } }
    public virtual int S_CountryID { get { return _S_CountryID; } set { _S_CountryID = value; } }
    public virtual string S_Currency { get { return _S_Currency; } set { _S_Currency = value; } }
    public virtual string S_Notation { get { return _S_Notation; } set { _S_Notation = value; } }
    public virtual decimal C_Factor { get { return _C_Factor; } set { _C_Factor = value; } }
    public virtual decimal deductions { get { return _deductions; } set { _deductions = value; } }
    public virtual decimal TDS { get { return _TDS; } set { _TDS = value; } }
    public virtual decimal WriteOff { get { return _WriteOff; } set { _WriteOff = value; } }
   
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

    public virtual decimal ReceivedAmt { get { return _ReceivedAmt; } set { _ReceivedAmt = value; } }
    public virtual decimal ChangeAmt { get { return _ChangeAmt; } set { _ChangeAmt = value; } }
    public virtual string C_ChangeAmt { get { return _C_ChangeAmt; } set { _C_ChangeAmt = value; } }
    #endregion

    #region All Public Member Function
    public int Insert()
    {
        int Output=0;
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("insert_mortuary_receipt_paymentdetail");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", Util.GetString(ReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", Util.GetInt(PaymentModeID)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentMode", Util.GetString(PaymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@vAmount", Util.GetDecimal(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@vBankName", Util.GetString(BankName)));
            cmd.Parameters.Add(new MySqlParameter("@vRefNo", Util.GetString(RefNo)));
            cmd.Parameters.Add(new MySqlParameter("@vRefDate", Util.GetDateTime(RefDate)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentRemarks", Util.GetString(PaymentRemarks)));
            cmd.Parameters.Add(new MySqlParameter("@vS_Amount", Util.GetDecimal(S_Amount)));
            cmd.Parameters.Add(new MySqlParameter("@vS_CountryID", Util.GetInt(S_CountryID)));
            cmd.Parameters.Add(new MySqlParameter("@vS_Currency", Util.GetString(S_Currency)));
            cmd.Parameters.Add(new MySqlParameter("@vS_Notation", Util.GetString(S_Notation)));
            cmd.Parameters.Add(new MySqlParameter("@vC_Factor", Util.GetDecimal(C_Factor)));
            cmd.Parameters.Add(new MySqlParameter("@vdeductions", Util.GetDecimal(deductions)));
            cmd.Parameters.Add(new MySqlParameter("@vTDS", Util.GetDecimal(TDS)));
            cmd.Parameters.Add(new MySqlParameter("@vWriteOff", Util.GetDecimal(WriteOff)));
         
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));

            cmd.Parameters.Add(new MySqlParameter("@vReceivedAmt", ReceivedAmt));
            cmd.Parameters.Add(new MySqlParameter("@vChangeAmt", ChangeAmt));
            cmd.Parameters.Add(new MySqlParameter("@vC_ChangeAmt", C_ChangeAmt));            


            Output =Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output;
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