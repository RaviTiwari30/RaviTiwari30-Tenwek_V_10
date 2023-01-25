using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for patient_notes
/// Generated using MySqlManager
/// ==========================================================================================
/// Author:
/// Create date:	5/14/2013 10:57:28 AM
/// Description:	This class is intended for inserting, updating, deleting values for patient_notes table
/// ==========================================================================================
/// </summary>

public class patient_notes
{
    public patient_notes()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public patient_notes(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _Id;
    private string _Transactionid;
    private string _Patientid;
    private string _Remarks;
    private string _Notes;
    private string _Ledgertrnxno;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int Id { get { return _Id; } set { _Id = value; } }
    public virtual string Transactionid { get { return _Transactionid; } set { _Transactionid = value; } }
    public virtual string Patientid { get { return _Patientid; } set { _Patientid = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual string Notes { get { return _Notes; } set { _Notes = value; } }
    public virtual string Ledgertrnxno { get { return _Ledgertrnxno; } set { _Ledgertrnxno = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_patient_notes_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionid", Util.GetString(Transactionid)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientid", Util.GetString(Patientid)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgertrnxno", Util.GetString(Ledgertrnxno)));

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

            objSQL.Append("cpoe_patient_notes_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vId", Util.GetInt(Id)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionid", Util.GetString(Transactionid)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientid", Util.GetString(Patientid)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vNotes", Util.GetString(Notes)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgertrnxno", Util.GetString(Ledgertrnxno)));

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

            objSQL.Append("cpoe_patient_notes_delete");

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
