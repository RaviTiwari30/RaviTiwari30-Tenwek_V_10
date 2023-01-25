using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class Ledger_Transaction_PaymentDetail
{
    public Ledger_Transaction_PaymentDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Ledger_Transaction_PaymentDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private int _PaymentModeID;
    private string _PaymentMode;
    private decimal _Amount;
    private string _LedgerTransactionNo;
    private string _BankName;
    private string _RefNo;
    private DateTime _RefDate;
    private string _PaymentRemarks;
    private decimal _S_Amount;
    private int _S_CountryID;
    private string _S_Currency;
    private string _S_Notation;
    private decimal _C_Factor;
    private int _CentreID;
    private string _Hospital_ID;
    private decimal _currencyRoundOff;
    private string _swipeMachine;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }
    public virtual string PaymentMode { get { return _PaymentMode; } set { _PaymentMode = value; } }
    public virtual decimal Amount { get { return _Amount; } set { _Amount = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual string BankName { get { return _BankName; } set { _BankName = value; } }
    public virtual string RefNo { get { return _RefNo; } set { _RefNo = value; } }
    public virtual DateTime RefDate { get { return _RefDate; } set { _RefDate = value; } }
    public virtual string PaymentRemarks { get { return _PaymentRemarks; } set { _PaymentRemarks = value; } }
    public virtual decimal S_Amount { get { return _S_Amount; } set { _S_Amount = value; } }
    [System.ComponentModel.DefaultValue(0.00)]
    public virtual decimal currencyRoundOff { get { return _currencyRoundOff; } set { _currencyRoundOff = value; } }
    public virtual int S_CountryID { get { return _S_CountryID; } set { _S_CountryID = value; } }
    public virtual string S_Currency { get { return _S_Currency; } set { _S_Currency = value; } }
    public virtual string S_Notation { get { return _S_Notation; } set { _S_Notation = value; } }
    public virtual decimal C_Factor { get { return _C_Factor; } set { _C_Factor = value; } }

    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    [System.ComponentModel.DefaultValue("")]
    public virtual string swipeMachine { get { return _swipeMachine; } set { _swipeMachine = value; } }

    #endregion

    #region All Public Member Function
    //public string Insert()
    //{
    //    string Output = "";
    //    try
    //    {
    //        StringBuilder objSQL = new StringBuilder();

    //        objSQL.Append("f_ledgertransaction_paymentdetail_insert");

    //        if (IsLocalConn)
    //        {
    //            this.objCon.Open();
    //            this.objTrans = this.objCon.BeginTransaction();
    //        }
    //        MySqlParameter paramTnxID = new MySqlParameter();
    //        paramTnxID.ParameterName = "@ID";
    //        paramTnxID.MySqlDbType = MySqlDbType.Int32;
    //        paramTnxID.Size = 10;
    //        paramTnxID.Direction = ParameterDirection.Output;

    //        MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
    //        cmd.CommandType = CommandType.StoredProcedure;

    //        cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", Util.GetInt(PaymentModeID)));
    //        cmd.Parameters.Add(new MySqlParameter("@vPaymentMode", Util.GetString(PaymentMode)));
    //        cmd.Parameters.Add(new MySqlParameter("@vAmount", Util.GetString(Amount)));
    //        cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
    //        cmd.Parameters.Add(new MySqlParameter("@vBankName", Util.GetString(BankName)));
    //        cmd.Parameters.Add(new MySqlParameter("@vRefNo", Util.GetString(RefNo)));
    //        cmd.Parameters.Add(new MySqlParameter("@vRefDate", Util.GetDateTime(RefDate)));
    //        cmd.Parameters.Add(new MySqlParameter("@vPaymentRemarks", Util.GetString(PaymentRemarks)));
    //        cmd.Parameters.Add(new MySqlParameter("@vS_Amount", Util.GetDecimal(S_Amount)));
    //        cmd.Parameters.Add(new MySqlParameter("@vS_CountryID", Util.GetInt(S_CountryID)));
    //        cmd.Parameters.Add(new MySqlParameter("@vS_Currency", Util.GetString(S_Currency)));
    //        cmd.Parameters.Add(new MySqlParameter("@vS_Notation", Util.GetString(S_Notation)));
    //        cmd.Parameters.Add(new MySqlParameter("@vC_Factor", Util.GetDecimal(C_Factor)));

    //        cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
    //        cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Util.GetString(Hospital_ID)));
    //        cmd.Parameters.Add(new MySqlParameter("@vCurrency_RoundOff", Util.GetDecimal(currencyRoundOff)));
    //        cmd.Parameters.Add(new MySqlParameter("@vSwipeMachine", Util.GetString(swipeMachine)));
    //        Output = cmd.ExecuteScalar().ToString();

    //        if (IsLocalConn)
    //        {
    //            this.objTrans.Commit();
    //            this.objCon.Close();
    //        }

    //        return Output.ToString();
    //    }
    //    catch (Exception ex)
    //    {
    //        if (IsLocalConn)
    //        {
    //            if (objTrans != null) this.objTrans.Rollback();
    //            if (objCon.State == ConnectionState.Open) objCon.Close();
    //        }
    //        // Util.WriteLog(ex);   
    //        throw (ex);
    //    }
    //}





    #endregion

}
