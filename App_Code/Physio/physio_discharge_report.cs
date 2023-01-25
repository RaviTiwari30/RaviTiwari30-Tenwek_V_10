using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

public class physio_discharge_report
{
    public physio_discharge_report()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_discharge_report(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _PatientID;
    private string _Session_Attended;
    private string _Session_Missed;
    private string _Diagnosis;
    private string _Symptomatology;
    private string _Treatment;
    private string _Pain_Rate;
    private string _Strength;
    private string _ROM;
    private string _Gait;
    private string _Balance;
    private string _Achievement;
    private string _Recommended_Home;
    private string _EntryBy;


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string Session_Attended { get { return _Session_Attended; } set { _Session_Attended = value; } }
    public virtual string Session_Missed { get { return _Session_Missed; } set { _Session_Missed = value; } }
    public virtual string Diagnosis { get { return _Diagnosis; } set { _Diagnosis = value; } }
    public virtual string Symptomatology { get { return _Symptomatology; } set { _Symptomatology = value; } }
    public virtual string Treatment { get { return _Treatment; } set { _Treatment = value; } }
    public virtual string Pain_Rate { get { return _Pain_Rate; } set { _Pain_Rate = value; } }
    public virtual string Strength { get { return _Strength; } set { _Strength = value; } }
    public virtual string ROM { get { return _ROM; } set { _ROM = value; } }
    public virtual string Gait { get { return _Gait; } set { _Gait = value; } }
    public virtual string Balance { get { return _Balance; } set { _Balance = value; } }
    public virtual string Achievement { get { return _Achievement; } set { _Achievement = value; } }
    public virtual string Recommended_Home { get { return _Recommended_Home; } set { _Recommended_Home = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }


    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_discharge_report_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vSession_Attended", Util.GetString(Session_Attended)));
            cmd.Parameters.Add(new MySqlParameter("@vSession_Missed", Util.GetString(Session_Missed)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosis", Util.GetString(Diagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vSymptomatology", Util.GetString(Symptomatology)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatment", Util.GetString(Treatment)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Rate", Util.GetString(Pain_Rate)));
            cmd.Parameters.Add(new MySqlParameter("@vStrength", Util.GetString(Strength)));
            cmd.Parameters.Add(new MySqlParameter("@vROM", Util.GetString(ROM)));
            cmd.Parameters.Add(new MySqlParameter("@vGait", Util.GetString(Gait)));
            cmd.Parameters.Add(new MySqlParameter("@vBalance", Util.GetString(Balance)));
            cmd.Parameters.Add(new MySqlParameter("@vAchievement", Util.GetString(Achievement)));
            cmd.Parameters.Add(new MySqlParameter("@vRecommended_Home", Util.GetString(Recommended_Home)));
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





    #endregion

}
