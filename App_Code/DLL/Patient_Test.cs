using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Patient_Complains
/// </summary>
public class Patient_Test
{
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Patient_Test()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Patient_Test(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Properties
    private int _PatientTest_ID;

    public int PatientTest_ID
    {
        get { return _PatientTest_ID; }
        set { _PatientTest_ID = value; }
    }
    private string _PatientID;

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }
    private string _App_ID;

    public string App_ID
    {
        get { return _App_ID; }
        set { _App_ID = value; }
    }

    private string _TransactionID;

    public string TransactionID
    {
        get { return _TransactionID; }
        set { _TransactionID = value; }
    }
    private DateTime _PrescribeDate;

    public DateTime PrescribeDate
    {
        get { return _PrescribeDate; }
        set { _PrescribeDate = value; }
    }

    private string _Test_ID;
    private string _name;


    public string Test_ID
    {
        get { return _Test_ID; }
        set { _Test_ID = value; }
    }

    public string name
    {
        get { return _name; }
        set { _name = value; }
    }

   
    private string _Remarks;

    public string Remarks
    {
        get { return _Remarks; }
        set { _Remarks = value; }
    }
    private string _DoctorID;

    public string DoctorID
    {
        get { return _DoctorID; }
        set { _DoctorID = value; }
    }

    private string _LedgerTransactionNo;
    public string LedgerTransactionNo
    {
        get { return _LedgerTransactionNo; }
        set { _LedgerTransactionNo = value; }
    }
    private int _Outsource;
    public int Outsource
    {
        get { return _Outsource; }
        set { _Outsource = value; }
    }
    private int _Quantity;
    public int Quantity
    {
        get { return _Quantity; }
        set { _Quantity = value; }
    }
    private int _ConfigID;
    public int ConfigID
    {
        get { return _ConfigID; }
        set { _ConfigID = value; }
    }
    private string _CreatedBy;
    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }
  
    private int _IsUrgent;
    public int IsUrgent
    {
        get { return _IsUrgent; }
        set { _IsUrgent = value; }
    }



    private int _IsPackage;
    public int IsPackage
    {
        get { return _IsPackage; }
        set { _IsPackage = value; }
    }


    private int _IsEmergencyData;

    public int IsEmergencyData
    {
        get { return _IsEmergencyData; }
        set { _IsEmergencyData = value; }
    }
    private int _IsIPDData;

    public int IsIPDData
    {
        get { return _IsIPDData; }
        set { _IsIPDData = value; }
    }

    
    private int _IsIssue;
    public int IsIssue
    {
        get { return _IsIssue; }
        set { _IsIssue = value; }
    }
    #endregion

    public int Insert()
    {
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append("patient_test");            

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(str.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Test_ID = Util.GetString(Test_ID);
            this.TransactionID = Util.GetString(TransactionID);
            this.App_ID = Util.GetString(App_ID);
            this.PatientID = Util.GetString(PatientID);            
            this.DoctorID = Util.GetString(DoctorID);
            this.Remarks = Util.GetString(Remarks);
            this.PrescribeDate = Util.GetDateTime(PrescribeDate);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.Outsource = Util.GetInt(Outsource);
            this.Quantity = Util.GetInt(Quantity);
            this.ConfigID = Util.GetInt(ConfigID);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.IsUrgent = Util.GetInt(IsUrgent);
            this.IsEmergencyData = Util.GetInt(IsEmergencyData);
            this.IsIPDData = Util.GetInt(IsIPDData);
            


            cmd.Parameters.Add(new MySqlParameter("@vTest_ID", Test_ID));
            cmd.Parameters.Add(new MySqlParameter("@vName", name));
            cmd.Parameters.Add(new MySqlParameter("@vApp_ID", App_ID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vPrescribeDate", PrescribeDate));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@vOutsource", Outsource));
            cmd.Parameters.Add(new MySqlParameter("@vQuantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@vConfigID", ConfigID));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vIsUrgent", IsUrgent));
            cmd.Parameters.Add(new MySqlParameter("@vIsPackage", IsPackage));
            cmd.Parameters.Add(new MySqlParameter("@vIsEmergencyData", IsEmergencyData));
            cmd.Parameters.Add(new MySqlParameter("@vIsIPDData", IsIPDData));
            

            PatientTest_ID = Convert.ToInt32(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PatientTest_ID;
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
