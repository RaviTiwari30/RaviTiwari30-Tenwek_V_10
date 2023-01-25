using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for OPD_Advance_Detail
/// </summary>
public class OPD_Advance_Detail
{
    #region All Memory Variables

    private int _ID;
    private string _PatientID;
    private string _TransactionID;
    private string _LedgerTransactionNo;
    private decimal _PaidAmount;
    private string _CreatedBy;
    private int _CentreID;
    private string _Hospital_ID;
    private string _ReceiptNo;
    private int _AdvanceID;
    private string _ReceiptNoAgainst;
    private string _advanceReason;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public OPD_Advance_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public OPD_Advance_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual decimal PaidAmount { get { return _PaidAmount; } set { _PaidAmount = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual string ReceiptNo { get { return _ReceiptNo; } set { _ReceiptNo = value; } }
    public virtual int AdvanceID { get { return _AdvanceID; } set { _AdvanceID = value; } }
    public virtual string ReceiptNoAgainst { get { return _ReceiptNoAgainst; } set { _ReceiptNoAgainst = value; } }

    public virtual string advanceReason { get { return _advanceReason; } set { _advanceReason = value; } }
    
    


    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("OPD_Advance_Detail");
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
            this.PaidAmount = Util.GetDecimal(PaidAmount);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.ReceiptNo = Util.GetString(ReceiptNo);
            this.AdvanceID = Util.GetInt(AdvanceID);
            this.advanceReason = Util.GetString(advanceReason);

            this.ReceiptNoAgainst = Util.GetString(ReceiptNoAgainst);
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@vPaidAmount", PaidAmount));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", ReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceID", AdvanceID));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNoAgainst", ReceiptNoAgainst));
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