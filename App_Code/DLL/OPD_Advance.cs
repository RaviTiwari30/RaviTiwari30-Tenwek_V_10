using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for OPD_Advance
/// </summary>
public class OPD_Advance
{

    #region All Memory Variables
    private int _ID;
    private string _PatientID;
    private string _TransactionID;
    private string _LedgerTransactionNo;
    private decimal _AdvanceAmount;
    private string _ReceiptNo;
    private string _CreatedBy;
    private int _CentreID;
    private string _Hospital_ID;
    private int _PaymentModeID;
    private string _PaymentMode;
    private string _BankName;
    private string _RefNo;
    private string _advanceReason;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public OPD_Advance()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public OPD_Advance(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property


    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual decimal AdvanceAmount { get { return _AdvanceAmount; } set { _AdvanceAmount = value; } }
    public virtual string ReceiptNo { get { return _ReceiptNo; } set { _ReceiptNo = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }
    public virtual string PaymentMode { get { return _PaymentMode; } set { _PaymentMode = value; } }
    public virtual string BankName { get { return _BankName; } set { _BankName = value; } }
    public virtual string RefNo { get { return _RefNo; } set { _RefNo = value; } }
    public virtual string advanceReason { get { return _advanceReason; } set { _advanceReason = value; } }

    #endregion

    #region All Public Member Function
    public int Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("OPD_Advance");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";
            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.AdvanceAmount = Util.GetDecimal(AdvanceAmount);
            this.ReceiptNo = Util.GetString(ReceiptNo);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);

            this.PaymentModeID = Util.GetInt(PaymentModeID);
            this.PaymentMode = Util.GetString(PaymentMode);
            this.BankName = Util.GetString(BankName);
            this.RefNo = Util.GetString(RefNo);
            this.advanceReason= Util.GetString(advanceReason);

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceAmount", AdvanceAmount));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", ReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));

            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", PaymentModeID));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentMode", PaymentMode));
            cmd.Parameters.Add(new MySqlParameter("@vBankName", BankName));
            cmd.Parameters.Add(new MySqlParameter("@vRefNo", RefNo));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceReason", advanceReason));



            cmd.Parameters.Add(paramTnxID);


            ID = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ID;
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