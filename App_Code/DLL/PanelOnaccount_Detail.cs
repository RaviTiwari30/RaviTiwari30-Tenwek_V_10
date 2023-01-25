using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Invoice_Detail
/// </summary>
public class PanelOnaccount_Detail
{
    public PanelOnaccount_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PanelOnaccount_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _PanelAccountID;

    private decimal _ReceivedAmount;
    private decimal _TDSAmount;
    private decimal _WriteOff;
    private decimal _DeducationAmt;
    private int _PanelID;
    private string _InvoiceNo;
    private string _PatientType;
    private decimal _balanceAmount;
    private string _CreatedBy;
    private string _Type;
    private int _paymentModeID;
    private string _ChequeNo;
    private string _LedgertransactionNo;
    private string _ReceiptNo;
    private string _TransactionID;
    private string _PatientID;

    private string _bankName;
    private DateTime _ChequeDate;
    private string _paymentMode;
    private string _IpAddress;
    private int _CentreID;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int PanelAccountID { get { return _PanelAccountID; } set { _PanelAccountID = value; } }
    public virtual decimal ReceivedAmount { get { return _ReceivedAmount; } set { _ReceivedAmount = value; } }
    public virtual decimal TDSAmount { get { return _TDSAmount; } set { _TDSAmount = value; } }
    public virtual decimal WriteOff { get { return _WriteOff; } set { _WriteOff = value; } }
    public virtual decimal DeducationAmt { get { return _DeducationAmt; } set { _DeducationAmt = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string InvoiceNo { get { return _InvoiceNo; } set { _InvoiceNo = value; } }
    public virtual string PatientType { get { return _PatientType; } set { _PatientType = value; } }
    public virtual decimal balanceAmount { get { return _balanceAmount; } set { _balanceAmount = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string Type { get { return _Type; } set { _Type = value; } }
    public virtual int paymentModeID { get { return _paymentModeID; } set { _paymentModeID = value; } }
    public virtual string ChequeNo { get { return _ChequeNo; } set { _ChequeNo = value; } }
    public virtual string LedgertransactionNo { get { return _LedgertransactionNo; } set { _LedgertransactionNo = value; } }
    public virtual string ReceiptNo { get { return _ReceiptNo; } set { _ReceiptNo = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }

    public virtual string bankName { get { return _bankName; } set { _bankName = value; } }
    public virtual DateTime ChequeDate { get { return _ChequeDate; } set { _ChequeDate = value; } }
    public virtual string paymentMode { get { return _paymentMode; } set { _paymentMode = value; } }
    public virtual string IpAddress { get { return _IpAddress; } set { _IpAddress = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("f_panelonaccount_Detail");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vPanelAccountID", Util.GetInt(PanelAccountID)));
            cmd.Parameters.Add(new MySqlParameter("@vReceivedAmount", Util.GetDecimal(ReceivedAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vTDSAmount", Util.GetDecimal(TDSAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vWriteOff", Util.GetDecimal(WriteOff)));
            cmd.Parameters.Add(new MySqlParameter("@vDeducationAmt", Util.GetDecimal(DeducationAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetInt(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vInvoiceNo", Util.GetString(InvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@vbalanceAmount", Util.GetDecimal(balanceAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientType", Util.GetString(PatientType)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", Util.GetInt(paymentModeID)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeNo", Util.GetString(ChequeNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));

            cmd.Parameters.Add(new MySqlParameter("@vLedgertransactionNo", Util.GetString(LedgertransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", Util.GetString(ReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));

            cmd.Parameters.Add(new MySqlParameter("@vbankName", Util.GetString(bankName)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeDate", Util.GetDateTime(ChequeDate)));
            cmd.Parameters.Add(new MySqlParameter("@vpaymentMode", Util.GetString(paymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
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
            throw (ex);
        }
    }

    #endregion All Public Member Function
}