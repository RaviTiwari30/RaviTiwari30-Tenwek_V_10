using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class f_receiptdetail
{
    public f_receiptdetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public f_receiptdetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _ID;
    private string _ReceiptNo;
    private string _AsainstLedgerTnxNo;
    private decimal _S_Amount;
    private int _S_CountryID;
    private string _S_Currency;
    private string _S_Notation;
    private decimal _C_Factor;
    private decimal _B_Amount;
    private int _B_CountryID;
    private string _B_Currency;
    private string _B_Notation;
    private string _PaymentMode;
    private string _CreditCardNo;
    private string _Check_DDNo;
    private string _BankName;
    private DateTime _EntryDateTime;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string ID_int { get { return _ID; } set { _ID = value; } }
    public virtual string ReceiptNo_varchar { get { return _ReceiptNo; } set { _ReceiptNo = value; } }
    public virtual string AsainstLedgerTnxNo_varchar { get { return _AsainstLedgerTnxNo; } set { _AsainstLedgerTnxNo = value; } }
    public virtual decimal S_Amount_decimal { get { return _S_Amount; } set { _S_Amount = value; } }
    public virtual int S_CountryID_int { get { return _S_CountryID; } set { _S_CountryID = value; } }
    public virtual string S_Currency_varchar { get { return _S_Currency; } set { _S_Currency = value; } }
    public virtual string S_Notation_varchar { get { return _S_Notation; } set { _S_Notation = value; } }
    public virtual decimal C_Factor_decimal { get { return _C_Factor; } set { _C_Factor = value; } }
    public virtual decimal B_Amount_decimal { get { return _B_Amount; } set { _B_Amount = value; } }
    public virtual int B_CountryID_int { get { return _B_CountryID; } set { _B_CountryID = value; } }
    public virtual string B_Currency_varchar { get { return _B_Currency; } set { _B_Currency = value; } }
    public virtual string B_Notation_varchar { get { return _B_Notation; } set { _B_Notation = value; } }
    public virtual string PaymentMode_varchar { get { return _PaymentMode; } set { _PaymentMode = value; } }
    public virtual string CreditCardNo_varchar { get { return _CreditCardNo; } set { _CreditCardNo = value; } }
    public virtual string Check_DDNo_varchar { get { return _Check_DDNo; } set { _Check_DDNo = value; } }
    public virtual string BankName_varchar { get { return _BankName; } set { _BankName = value; } }
    public virtual DateTime EntryDateTime_timestamp { get { return _EntryDateTime; } set { _EntryDateTime = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("f_receiptdetail_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_ReceiptNo", _ReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@_AsainstLedgerTnxNo", _AsainstLedgerTnxNo));
            cmd.Parameters.Add(new MySqlParameter("@_S_Amount", _S_Amount));
            cmd.Parameters.Add(new MySqlParameter("@_S_CountryID", _S_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@_S_Currency", _S_Currency));
            cmd.Parameters.Add(new MySqlParameter("@_S_Notation", _S_Notation));
            cmd.Parameters.Add(new MySqlParameter("@_C_Factor", _C_Factor));
            cmd.Parameters.Add(new MySqlParameter("@_B_Amount", _B_Amount));
            cmd.Parameters.Add(new MySqlParameter("@_B_CountryID", _B_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@_B_Currency", _B_Currency));
            cmd.Parameters.Add(new MySqlParameter("@_B_Notation", _B_Notation));
            cmd.Parameters.Add(new MySqlParameter("@_PaymentMode", _PaymentMode));
            cmd.Parameters.Add(new MySqlParameter("@_CreditCardNo", _CreditCardNo));
            cmd.Parameters.Add(new MySqlParameter("@_Check_DDNo", _Check_DDNo));
            cmd.Parameters.Add(new MySqlParameter("@_BankName", _BankName));
            cmd.Parameters.Add(new MySqlParameter("@_EntryDateTime", _EntryDateTime));

            Output = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output.ToString();
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