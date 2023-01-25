using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


/// <summary>
/// Summary description for IPD_Turning
/// </summary>
public class IPD_Consent
{
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public IPD_Consent()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public IPD_Consent(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }    
    #endregion

    #region All Memory Variables
    private string _PatientID;
    private string _TransactionID;
    private string _Surgery_ID;    
    private DateTime _ConsentDate;
    private string _WitnessName;    
    private string _RelName;
    private DateTime _RelConsentDate;    
    private string _RelWitnessName;    
    private string _CreatedBy;
    #endregion

    #region Set All Property

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }

    public string TransactionID
    {
        get { return _TransactionID; }
        set { _TransactionID = value; }
    }

    public string Surgery_ID
    {
        get { return _Surgery_ID; }
        set { _Surgery_ID = value; }
    }

    public DateTime ConsentDate
    {
        get { return _ConsentDate; }
        set { _ConsentDate = value; }
    }

    public string WitnessName
    {
        get { return _WitnessName; }
        set { _WitnessName = value; }
    }

    public string RelName
    {
        get { return _RelName; }
        set { _RelName = value; }
    }

    public DateTime RelConsentDate
    {
        get { return _RelConsentDate; }
        set { _RelConsentDate = value; }
    }

    public string RelWitnessName
    {
        get { return _RelWitnessName; }
        set { _RelWitnessName = value; }
    }

    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }

    #endregion

    #region All Public Member Function
    public void Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_ipd_consentform");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.Surgery_ID = Util.GetString(Surgery_ID);
            this.ConsentDate = Util.GetDateTime(ConsentDate);
            this.WitnessName = Util.GetString(WitnessName);
            this.RelName = Util.GetString(RelName);
            this.RelConsentDate = Util.GetDateTime(RelConsentDate);
            this.RelWitnessName = Util.GetString(RelWitnessName);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery_ID", Surgery_ID));
            cmd.Parameters.Add(new MySqlParameter("@vConsentDate", ConsentDate));
            cmd.Parameters.Add(new MySqlParameter("@vWitnessName", WitnessName));
            cmd.Parameters.Add(new MySqlParameter("@vRelName", RelName));
            cmd.Parameters.Add(new MySqlParameter("@vRelConsentDate", RelConsentDate));
            cmd.Parameters.Add(new MySqlParameter("@vRelWitnessName", RelWitnessName));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));

            cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }            
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
    #endregion
	
}