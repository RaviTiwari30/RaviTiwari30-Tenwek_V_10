using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_patient_general_notes
{
    public cpoe_patient_general_notes()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_patient_general_notes(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _Id;
    private string _TransactionId;
    private string _PatientId;
    private string _Genral;
    private string _Notes;
    private string _LedgerTranxno;
    private string _EntryBy;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int Id { get { return _Id; } set { _Id = value; } }
    public virtual string TransactionId { get { return _TransactionId; } set { _TransactionId = value; } }
    public virtual string PatientId { get { return _PatientId; } set { _PatientId = value; } }
    public virtual string Genral { get { return _Genral; } set { _Genral = value; } }
    public virtual string Notes { get { return _Notes; } set { _Notes = value; } }
    public virtual string LedgerTranxno { get { return _LedgerTranxno; } set { _LedgerTranxno = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_patient_general_notes_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionId", Util.GetString(TransactionId)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientId", Util.GetString(PatientId)));
            cmd.Parameters.Add(new MySqlParameter("@vGenral", Util.GetString(Genral)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTranxno", Util.GetString(LedgerTranxno)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));

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

            objSQL.Append("cpoe_patient_general_notes_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vId", Util.GetInt(Id)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionId", Util.GetString(TransactionId)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientId", Util.GetString(PatientId)));
            cmd.Parameters.Add(new MySqlParameter("@vGenral", Util.GetString(Genral)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTranxno", Util.GetString(LedgerTranxno)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));
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

            objSQL.Append("cpoe_patient_general_notes_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vId", Id));

            Output = cmd.ExecuteNonQuery().ToString();

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
