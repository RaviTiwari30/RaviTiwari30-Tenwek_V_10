using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Patient_Complains
/// </summary>
public class Patient_Observation
{
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Patient_Observation()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Patient_Observation(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
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
    private DateTime _Date;

    public DateTime Date
    {
        get { return _Date; }
        set { _Date = value; }
    }
private string _DoctorID;

	public string DoctorID
	{
		get { return _DoctorID;}
		set { _DoctorID = value;}
	}
private string _Exam_ID;

	public string Exam_ID
	{
		get { return _Exam_ID;}
		set { _Exam_ID = value;}
	}
private string _Remarks;

	public string Remarks
	{
		get { return _Remarks;}
		set { _Remarks = value;}
	}

private string _LedgerTransactionNo;
    public string LedgerTransactionNo
    {
        get { return _LedgerTransactionNo; }
        set { _LedgerTransactionNo = value; }
    }

    #endregion

    public int Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            
            objSQL.Append("Insert_patient_observation");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";

            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Direction = ParameterDirection.Output;


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.DoctorID = Util.GetString(DoctorID);
            this.Exam_ID = Util.GetString(Exam_ID);
            this.Date = Util.GetDateTime(Date);
            this.Remarks = Util.GetString(Remarks);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vExam_ID", Exam_ID));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Date));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
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
