using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_patient_medicine
{
    public ot_patient_medicine()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_patient_medicine(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _PatientID;
    private string _TransactionID;
    private string _MedicineID;
    private string _NoOfDays;
    private string _NoTimesDay;
    private string _Dose;
    private string _Remarks;
    private string _DoctorID;
    private string _EnterBy;
    private string _Type;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string MedicineID { get { return _MedicineID; } set { _MedicineID = value; } }
    public virtual string NoOfDays { get { return _NoOfDays; } set { _NoOfDays = value; } }
    public virtual string NoTimesDay { get { return _NoTimesDay; } set { _NoTimesDay = value; } }
    public virtual string Dose { get { return _Dose; } set { _Dose = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }
    public virtual string Type { get { return _Type; } set { _Type = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_patient_medicine_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vMedicineID", Util.GetString(MedicineID)));
            cmd.Parameters.Add(new MySqlParameter("@vNoOfDays", Util.GetString(NoOfDays)));
            cmd.Parameters.Add(new MySqlParameter("@vNoTimesDay", Util.GetString(NoTimesDay)));
            cmd.Parameters.Add(new MySqlParameter("@vDose", Util.GetString(Dose)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));

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

    #endregion All Public Member Function
}