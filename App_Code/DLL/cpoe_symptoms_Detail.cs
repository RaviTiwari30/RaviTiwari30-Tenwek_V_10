using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_symptoms_detail
{
    public cpoe_symptoms_detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_symptoms_detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private int _AppID;
    private string _PatientID;
    private int _SymptomsID;
    private string _SymptomsName;
    private string _EntryBy;
    private DateTime _EntryDate;
    private string _UpdateBy;
    private DateTime _UpdateDate;
    private string _LedgerTnxNo;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual int AppID { get { return _AppID; } set { _AppID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual int SymptomsID { get { return _SymptomsID; } set { _SymptomsID = value; } }
    public virtual string SymptomsName { get { return _SymptomsName; } set { _SymptomsName = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }
    public virtual string LedgerTnxNo { get { return _LedgerTnxNo; } set { _LedgerTnxNo = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_symptoms_detail_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAppID", Util.GetInt(AppID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vSymptomsID", Util.GetInt(SymptomsID)));
            cmd.Parameters.Add(new MySqlParameter("@vSymptomsName", Util.GetString(SymptomsName)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            //cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            //cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTnxNo", Util.GetString(LedgerTnxNo)));

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
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }


    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_symptoms_detail_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAppID", Util.GetInt(AppID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vSymptomsID", Util.GetInt(SymptomsID)));
            cmd.Parameters.Add(new MySqlParameter("@vSymptomsName", Util.GetString(SymptomsName)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryDate", Util.GetDateTime(EntryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

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
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }


    public string Delete()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_symptoms_detail_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vID", ID));

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
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }

    #endregion

}