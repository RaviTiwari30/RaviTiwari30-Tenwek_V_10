using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class Receipt
{
    public Receipt()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Receipt(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

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
    private DateTime _Date;
    private DateTime _Time;
    private string _Reciever;
    private string _Depositor;
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
    private string _EditUserID;
    private DateTime _EditDateTime;
    private string _EditReason;
    private string _EditType;
    private string _UniqueHash;
    private string _ReceivedFrom;
    private string _IpAddress;
    private decimal _RoundOff;
    private string _PaidBy;
    private string _panelInvoiceNo;
    private decimal _deductions;
    private decimal _TDS;
    private decimal _WriteOff;
    private string _deptLedgerNo;
    private int _CentreID;
    private int _isOPDAdvance;
    private string _isBloodBankItem;
    private int _isOTCollection;

    private string _Source;
    private string _PaymentRefNo;
    private string _TransactionRefNo;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string HospCode { get { return _HospCode; } set { _HospCode = value; } }
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string ReceiptNo { get { return _ReceiptNo; } set { _ReceiptNo = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual string LedgerNoCr { get { return _LedgerNoCr; } set { _LedgerNoCr = value; } }
    public virtual string LedgerNoDr { get { return _LedgerNoDr; } set { _LedgerNoDr = value; } }
    public virtual string AsainstLedgerTnxNo { get { return _AsainstLedgerTnxNo; } set { _AsainstLedgerTnxNo = value; } }
    public virtual decimal AmountPaid { get { return _AmountPaid; } set { _AmountPaid = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual DateTime Time { get { return _Time; } set { _Time = value; } }
    public virtual string Reciever { get { return _Reciever; } set { _Reciever = value; } }
    public virtual string Depositor { get { return _Depositor; } set { _Depositor = value; } }

    public virtual string IsPayementByInsurance { get { return _IsPayementByInsurance; } set { _IsPayementByInsurance = value; } }
    public virtual DateTime Cheque_DDdate { get { return _Cheque_DDdate; } set { _Cheque_DDdate = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string Cancel_UserID { get { return _Cancel_UserID; } set { _Cancel_UserID = value; } }
    public virtual DateTime CancelDate { get { return _CancelDate; } set { _CancelDate = value; } }
    public virtual string CancelReason { get { return _CancelReason; } set { _CancelReason = value; } }
    public virtual int IsCancel { get { return _IsCancel; } set { _IsCancel = value; } }
    public virtual decimal Discount { get { return _Discount; } set { _Discount = value; } }
    public virtual string Naration { get { return _Naration; } set { _Naration = value; } }
    public virtual string EditUserID { get { return _EditUserID; } set { _EditUserID = value; } }
    public virtual DateTime EditDateTime { get { return _EditDateTime; } set { _EditDateTime = value; } }
    public virtual string EditReason { get { return _EditReason; } set { _EditReason = value; } }
    public virtual string EditType { get { return _EditType; } set { _EditType = value; } }
    public virtual string UniqueHash { get { return _UniqueHash; } set { _UniqueHash = value; } }
    public virtual string ReceivedFrom { get { return _ReceivedFrom; } set { _ReceivedFrom = value; } }
    public virtual string IpAddress { get { return _IpAddress; } set { _IpAddress = value; } }
    public virtual decimal RoundOff { get { return _RoundOff; } set { _RoundOff = value; } }
    public virtual string PaidBy { get { return _PaidBy; } set { _PaidBy = value; } }
    public virtual string panelInvoiceNo { get { return _panelInvoiceNo; } set { _panelInvoiceNo = value; } }
    public virtual decimal deductions { get { return _deductions; } set { _deductions = value; } }
    public virtual decimal TDS { get { return _TDS; } set { _TDS = value; } }
    public virtual decimal WriteOff { get { return _WriteOff; } set { _WriteOff = value; } }
    public virtual string deptLedgerNo { get { return _deptLedgerNo; } set { _deptLedgerNo = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual int isOPDAdvance { get { return _isOPDAdvance; } set { _isOPDAdvance = value; } }
    public virtual string isBloodBankItem { get { return _isBloodBankItem; } set { _isBloodBankItem = value; } }
    public virtual int isOTCollection { get { return _isOTCollection; } set { _isOTCollection = value; } }

    public virtual string Source { get { return _Source; } set { _Source = value; } }
    public virtual string PaymentRefNo { get { return _PaymentRefNo; } set { _PaymentRefNo = value; } }
    public virtual string TransactionRefNo { get { return _TransactionRefNo; } set { _TransactionRefNo = value; } }
    
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("f_reciept_insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            if ((UniqueHash == null) || (UniqueHash == ""))
                UniqueHash = Util.getHash();

            MySqlParameter RepNo = new MySqlParameter();
            RepNo.ParameterName = "@vReceiptNo";

            RepNo.MySqlDbType = MySqlDbType.VarChar;
            RepNo.Size = 50;
            RepNo.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", Util.GetString(HospCode)));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerNoCr", Util.GetString(LedgerNoCr)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerNoDr", Util.GetString(LedgerNoDr)));
            cmd.Parameters.Add(new MySqlParameter("@vAsainstLedgerTnxNo", Util.GetString(AsainstLedgerTnxNo)));
            cmd.Parameters.Add(new MySqlParameter("@vAmountPaid", Util.GetDouble(AmountPaid)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetDateTime(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vReciever", Util.GetString(Reciever)));
            cmd.Parameters.Add(new MySqlParameter("@vDepositor", Util.GetString(Depositor)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPayementByInsurance", Util.GetString(IsPayementByInsurance)));
            cmd.Parameters.Add(new MySqlParameter("@vCheque_DDdate", Util.GetDateTime(Cheque_DDdate)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetInt(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vCancel_UserID", Util.GetString(Cancel_UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelDate", Util.GetDateTime(CancelDate)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelReason", Util.GetString(CancelReason)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCancel", Util.GetInt(IsCancel)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscount", Util.GetDecimal(Discount)));
            cmd.Parameters.Add(new MySqlParameter("@vNaration", Util.GetString(Naration)));
            cmd.Parameters.Add(new MySqlParameter("@vEditUserID", Util.GetString(EditUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEditDateTime", Util.GetDateTime(EditDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vEditReason", Util.GetString(EditReason)));
            cmd.Parameters.Add(new MySqlParameter("@vEditType", Util.GetString(EditType)));
            cmd.Parameters.Add(new MySqlParameter("@vUniqueHash", Util.GetString(UniqueHash)));
            cmd.Parameters.Add(new MySqlParameter("@vReceivedFrom", Util.GetString(ReceivedFrom)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vRoundOff", Util.GetDecimal(RoundOff)));
            cmd.Parameters.Add(new MySqlParameter("@vPaidBy", Util.GetString(PaidBy)));
            cmd.Parameters.Add(new MySqlParameter("@vpanelInvoiceNo", Util.GetString(panelInvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@vdeductions", Util.GetDecimal(deductions)));
            cmd.Parameters.Add(new MySqlParameter("@vTDS", Util.GetDecimal(TDS)));
            cmd.Parameters.Add(new MySqlParameter("@vWriteOff", Util.GetDecimal(WriteOff)));
            cmd.Parameters.Add(new MySqlParameter("@vdeptLedgerNo", Util.GetString(deptLedgerNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@visOPDAdvance", Util.GetInt(isOPDAdvance)));
            if (isBloodBankItem == "")
                //1 for BloodBank 
                isBloodBankItem = "0";
            cmd.Parameters.Add(new MySqlParameter("@visBloodBankItem", isBloodBankItem));
            cmd.Parameters.Add(new MySqlParameter("@visOTCollection", Util.GetInt(isOTCollection)));

            cmd.Parameters.Add(new MySqlParameter("@Source", "WA"));
            cmd.Parameters.Add(new MySqlParameter("@PaymentRefNo", PaymentRefNo));
            cmd.Parameters.Add(new MySqlParameter("@TransactionRefNo", TransactionRefNo));

            cmd.Parameters.Add(RepNo);

            ReceiptNo = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ReceiptNo.ToString();
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