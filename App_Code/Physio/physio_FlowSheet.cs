using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web;
/// <summary>
/// Summary description for physio_FlowSheet
/// </summary>
public class physio_FlowSheet
{
	public physio_FlowSheet()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_FlowSheet(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

   
    private string _TransactionID;
    private string _PatientID;
    private string _Physio_ID;
    private DateTime _TreatmentDate;
    private string _TYPE;
    private string _Intervention;
    private string _VALUE;
    private string _CreatedBy;


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string Physio_ID { get { return _Physio_ID; } set { _Physio_ID = value; } }
    public virtual DateTime TreatmentDate { get { return _TreatmentDate; } set { _TreatmentDate = value; } }
    public virtual string TYPE { get { return _TYPE; } set { _TYPE = value; } }
    public virtual string Intervention { get { return _Intervention; } set { _Intervention = value; } }
    public virtual string VALUE { get { return _VALUE; } set { _VALUE = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("Physio_FlowSheet_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysio_ID", Util.GetString(Physio_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatmentDate", Util.GetDateTime(TreatmentDate)));
            cmd.Parameters.Add(new MySqlParameter("@vTYPE", Util.GetString(TYPE)));
            cmd.Parameters.Add(new MySqlParameter("@vIntervention", Util.GetString(Intervention)));
            cmd.Parameters.Add(new MySqlParameter("@vVALUE", Util.GetString(VALUE)));
            
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
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