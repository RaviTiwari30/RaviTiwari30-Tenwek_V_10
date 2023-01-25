using MySql.Data.MySqlClient;
using System;
using System.Data;

/// <summary>
/// Summary description for Patient_Complains
/// </summary>
public class Patient_Complains
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Patient_Complains()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Patient_Complains(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Properties

    private int _ID;

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    private string _PatientID;

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }

    private string _TransactionID;

    public string TransactionID
    {
        get { return _TransactionID; }
        set { _TransactionID = value; }
    }

    private string _Complain;

    public string Complain
    {
        get { return _Complain; }
        set { _Complain = value; }
    }

    private DateTime _Date;

    public DateTime Date
    {
        get { return _Date; }
        set { _Date = value; }
    }

    private int _Complain_ID;

    public int Complain_ID
    {
        get { return _Complain_ID; }
        set { _Complain_ID = value; }
    }

    private string _Comp_Duration;

    public string Comp_Duration
    {
        get { return _Comp_Duration; }
        set { _Comp_Duration = value; }
    }

    private string _LedgerTransactionNo;

    public string LedgerTransactionNo
    {
        get { return _LedgerTransactionNo; }
        set { _LedgerTransactionNo = value; }
    }

    #endregion Properties

    public int Insert()
    {
        try
        {
            string str = "Insert_patient_complains";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(str, objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.Complain = Util.GetString(Complain);
            this.Complain_ID = Util.GetInt(Complain_ID);
            this.Comp_Duration = Util.GetString(Comp_Duration);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vComplain", Complain));
            cmd.Parameters.Add(new MySqlParameter("@vComplain_ID", Complain_ID));
            cmd.Parameters.Add(new MySqlParameter("@vComp_Duration", Comp_Duration));
            cmd.Parameters.Add(new MySqlParameter("@vLnxNo", LedgerTransactionNo));

            ID = Convert.ToInt32(cmd.ExecuteScalar());

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
            // Util.WriteLog(ex);
            throw (ex);
        }
    }
}