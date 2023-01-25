using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;


public class Payment
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _PaymentNo;
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
    private string _PaymentAgainstInvoice;
    private string _InvoiceNo;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    public Payment()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public Payment(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

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

    public virtual string PaymentNo
    {
        get
        {
            return _PaymentNo;
        }
        set
        {
            _PaymentNo = value;
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

    public virtual string PaymentAgainstInvoice
    {
        get
        {
            return _PaymentAgainstInvoice;
        }
        set
        {
            _PaymentAgainstInvoice = value;
        }
    }

    public virtual string InvoiceNo
    {
        get
        {
            return _InvoiceNo;
        }
        set
        {
            _InvoiceNo = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_payment");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Hospital_ID = Util.GetString(Hospital_ID);
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
            this.PaymentAgainstInvoice = Util.GetString(PaymentAgainstInvoice);
            this.InvoiceNo = Util.GetString(InvoiceNo);

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
            cmd.Parameters.Add(new MySqlParameter("@PaymentAgainstInvoice", PaymentAgainstInvoice));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceNo", InvoiceNo));

            iPkValue = Util.GetInt(cmd.ExecuteScalar());

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
            objSQL.Append("UPDATE f_payment SET Hospital_ID=?,LedgerNoCr=?,LedgerNoDr=?,AsainstLedgerTnxNo=?,AmountPaid=?,Date=?,Time=?,Reciever=?,Depositor=?,IsCheque_Draft=?,ChequeNo_DraftNo=?,StatusCheque=?,IsPayementByInsurance=?,Cheque_DDdate=?,PaymentAgainstInvoice=?,InvoiceNo=? WHERE PaymentNo = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.PaymentNo = Util.GetString(PaymentNo);
            this.Hospital_ID = Util.GetString(Hospital_ID);
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
            this.StatusCheque = Util.GetString(PaymentAgainstInvoice);
            this.InvoiceNo = Util.GetString(InvoiceNo);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@LedgerNoCr", LedgerNoCr),
                new MySqlParameter("@LedgerNoDr", LedgerNoDr),
                new MySqlParameter("@AsainstLedgerTnxNo", AsainstLedgerTnxNo),
                new MySqlParameter("@AmountPaid", AmountPaid),
                new MySqlParameter("@Date", Date),
                new MySqlParameter("@Time", Time),
                new MySqlParameter("@Reciever", Reciever),
                new MySqlParameter("@Depositor", Depositor),
                new MySqlParameter("@IsCheque_Draft", IsCheque_Draft),
                new MySqlParameter("@ChequeNo_DraftNo", ChequeNo_DraftNo),
                new MySqlParameter("@StatusCheque", StatusCheque),
                new MySqlParameter("@IsPayementByInsurance", IsPayementByInsurance),
                new MySqlParameter("@PaymentNo", PaymentNo),
               new MySqlParameter("@Cheque_DDdate", Cheque_DDdate),
            new MySqlParameter("@PaymentAgainstInvoice", PaymentAgainstInvoice),
            new MySqlParameter("@InvoiceNo", InvoiceNo));

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
        this.PaymentNo = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_payment WHERE PaymentNo = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("PaymentNo", PaymentNo));
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
            string sSQL = "SELECT * FROM f_payment WHERE PaymentNo = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@PaymentNo", PaymentNo)).Tables[0];

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
            string sParams = "PaymentNo=" + this.PaymentNo.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.PaymentNo = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Payment.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Payment.HospCode]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.Payment.Hospital_ID]);
        this.PaymentNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment.PaymentNo]);
        this.LedgerNoCr = Util.GetString(dtTemp.Rows[0][AllTables.Payment.LedgerNoCr]);
        this.LedgerNoDr = Util.GetString(dtTemp.Rows[0][AllTables.Payment.LedgerNoDr]);
        this.AsainstLedgerTnxNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment.AsainstLedgerTnxNo]);
        this.AmountPaid = Util.GetDecimal(dtTemp.Rows[0][AllTables.Payment.AmountPaid]);
        this.Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.Payment.Date]);
        this.Time = Util.GetDateTime(dtTemp.Rows[0][AllTables.Payment.Time]);
        this.Reciever = Util.GetString(dtTemp.Rows[0][AllTables.Payment.Reciever]);
        this.Depositor = Util.GetString(dtTemp.Rows[0][AllTables.Payment.Depositor]);
        this.IsCheque_Draft = Util.GetString(dtTemp.Rows[0][AllTables.Payment.IsCheque_Draft]);
        this.ChequeNo_DraftNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment.ChequeNo_DraftNo]);
        this.StatusCheque = Util.GetString(dtTemp.Rows[0][AllTables.Payment.StatusCheque]);
        this.IsPayementByInsurance = Util.GetString(dtTemp.Rows[0][AllTables.Payment.IsPayementByInsurance]);
        this.Cheque_DDdate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Payment.Cheque_DDdate]);
        this.PaymentAgainstInvoice = Util.GetString(dtTemp.Rows[0][AllTables.Payment.PaymentAgainstInvoice]);
        this.InvoiceNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment.InvoiceNo]);
    }

    #endregion Helper Private Function
}