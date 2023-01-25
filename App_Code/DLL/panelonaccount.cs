using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for panelonaccount
/// </summary>
public class panelonaccount
{
    public panelonaccount()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public panelonaccount(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _InvoiceNo;
    private DateTime _InvoiceDate;
    private decimal _ReceivedAmount;
    private decimal _TDSAmount;
    private decimal _WriteOff;
    private decimal _DeducationAmt;
    private int _PaymentModeID;
    private string _PaymentMode;
    private string _Type;
    private string _Bank;
    private string _ChequeNo;
    private DateTime _ChequeDate;
    private string _CreditCardNo;
    private string _CreatedBy;
    private string _IPAddress;
    private int _PanelID;
    private string _PatientType;
    private decimal _balanceAmount;
    private decimal _InvoiceAmount;
    private int _CentreID;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual string InvoiceNo { get { return _InvoiceNo; } set { _InvoiceNo = value; } }
    public virtual DateTime InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
    public virtual decimal ReceivedAmount { get { return _ReceivedAmount; } set { _ReceivedAmount = value; } }
    public virtual decimal TDSAmount { get { return _TDSAmount; } set { _TDSAmount = value; } }
    public virtual decimal WriteOff { get { return _WriteOff; } set { _WriteOff = value; } }
    public virtual decimal DeducationAmt { get { return _DeducationAmt; } set { _DeducationAmt = value; } }
    public virtual int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }
    public virtual string PaymentMode { get { return _PaymentMode; } set { _PaymentMode = value; } }
    public virtual string Type { get { return _Type; } set { _Type = value; } }
    public virtual string Bank { get { return _Bank; } set { _Bank = value; } }
    public virtual string ChequeNo { get { return _ChequeNo; } set { _ChequeNo = value; } }
    public virtual DateTime ChequeDate { get { return _ChequeDate; } set { _ChequeDate = value; } }
    public virtual string CreditCardNo { get { return _CreditCardNo; } set { _CreditCardNo = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string IPAddress { get { return _IPAddress; } set { _IPAddress = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string PatientType { get { return _PatientType; } set { _PatientType = value; } }
    public virtual decimal balanceAmount { get { return _balanceAmount; } set { _balanceAmount = value; } }
    public virtual decimal InvoiceAmount { get { return _InvoiceAmount; } set { _InvoiceAmount = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("f_panelonaccount");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vInvoiceNo", Util.GetString(InvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@vInvoiceDate", Util.GetDateTime(InvoiceDate)));
            cmd.Parameters.Add(new MySqlParameter("@vReceivedAmount", Util.GetDecimal(ReceivedAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vTDSAmount", Util.GetDecimal(TDSAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vWriteOff", Util.GetDecimal(WriteOff)));
            cmd.Parameters.Add(new MySqlParameter("@vDeducationAmt", Util.GetDecimal(DeducationAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", Util.GetInt(PaymentModeID)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentMode", Util.GetString(PaymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vBank", Util.GetString(Bank)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeNo", Util.GetString(ChequeNo)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeDate", Util.GetDateTime(ChequeDate)));
            cmd.Parameters.Add(new MySqlParameter("@vCreditCardNo", Util.GetString(CreditCardNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vIPAddress", Util.GetString(IPAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetInt(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientType", Util.GetString(PatientType)));
            cmd.Parameters.Add(new MySqlParameter("@vbalanceAmount", Util.GetDecimal(balanceAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vInvoiceAmount", Util.GetDecimal(InvoiceAmount)));
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