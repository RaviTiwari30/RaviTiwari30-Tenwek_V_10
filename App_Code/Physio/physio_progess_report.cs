using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_progess_report  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	1/30/2014 4:47:46 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_progess_report table 
/// ========================================================================================== 
/// </summary>  

public class physio_progess_report
{
    public physio_progess_report()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_progess_report(MySqlTransaction objTrans)
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
    private string _Level;
    private string _Nature;
    private string _Objective;
    private string _GoalsSet;
    private string _Treatment_Program;
    private string _FunctionalLimitation;
    private string _PainLevel;
    private string _Strength;
    private string _ROM;
    private int _Continue;
    private string _Weeks;
    private string _Weeks_for;
    private int _Discontinue;     
    private string _Recommendation;
    private string _EntryBy;
    private string _InitialFunctionalTools;
    private string _LastFunctionalTools;
    private string _StartDate;
    private string _EndDate;

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
    public virtual string Level { get { return _Level; } set { _Level = value; } }
    public virtual string Nature { get { return _Nature; } set { _Nature = value; } }
    public virtual string Objective { get { return _Objective; } set { _Objective = value; } }
    public virtual string GoalsSet { get { return _GoalsSet; } set { _GoalsSet = value; } }
    public virtual string Treatment_Program { get { return _Treatment_Program; } set { _Treatment_Program = value; } }
    public virtual string FunctionalLimitation { get { return _FunctionalLimitation; } set { _FunctionalLimitation = value; } }
    public virtual string PainLevel { get { return _PainLevel; } set { _PainLevel = value; } }
    public virtual string Strength { get { return _Strength; } set { _Strength = value; } }
    public virtual string ROM { get { return _ROM; } set { _ROM = value; } }
    public virtual int Continue { get { return _Continue; } set { _Continue = value; } }
    public virtual string Weeks { get { return _Weeks; } set { _Weeks = value; } }
    public virtual string Weeks_for { get { return _Weeks_for; } set { _Weeks_for = value; } }
    public virtual int Discontinue { get { return _Discontinue; } set { _Discontinue = value; } }
    public virtual string Recommendation { get { return _Recommendation; } set { _Recommendation = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
    public virtual string InitialFunctionalTools { get { return _InitialFunctionalTools; } set { _InitialFunctionalTools = value; } }
    public virtual string LastFunctionalTools { get { return _LastFunctionalTools; } set { _LastFunctionalTools = value; } }
    public virtual string Startdate { get { return _StartDate; } set { _StartDate = value; } }
    public virtual string EndDate { get { return _EndDate; } set { _EndDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_progess_report_insert");

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

            cmd.Parameters.Add(new MySqlParameter("@vLevel", Util.GetString(Level)));
            cmd.Parameters.Add(new MySqlParameter("@vNature", Util.GetString(Nature)));
            cmd.Parameters.Add(new MySqlParameter("@vObjective", Util.GetString(Objective)));
            cmd.Parameters.Add(new MySqlParameter("@vGoalsSet", Util.GetString(GoalsSet)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatment_Program", Util.GetString(Treatment_Program)));
            cmd.Parameters.Add(new MySqlParameter("@vFunctionalLimitation", Util.GetString(FunctionalLimitation)));
            cmd.Parameters.Add(new MySqlParameter("@vPainLevel", Util.GetString(PainLevel)));
            cmd.Parameters.Add(new MySqlParameter("@vStrength", Util.GetString(Strength)));
            cmd.Parameters.Add(new MySqlParameter("@vROM", Util.GetString(ROM)));
            cmd.Parameters.Add(new MySqlParameter("@vContinue", Util.GetInt(Continue)));
            cmd.Parameters.Add(new MySqlParameter("@vWeeks", Util.GetString(Weeks)));
            cmd.Parameters.Add(new MySqlParameter("@vWeeks_for", Util.GetString(Weeks_for)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscontinue", Util.GetInt(Discontinue)));
            cmd.Parameters.Add(new MySqlParameter("@vRecommendation", Util.GetString(Recommendation)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));
            cmd.Parameters.Add(new MySqlParameter("@vInitialFunctionalTools", Util.GetString(InitialFunctionalTools)));
            cmd.Parameters.Add(new MySqlParameter("@vLastFunctionalTools", Util.GetString(LastFunctionalTools)));
            cmd.Parameters.Add(new MySqlParameter("@vStartdate", Util.GetString(Startdate)));
            cmd.Parameters.Add(new MySqlParameter("@vEndDate", Util.GetString(EndDate)));

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
