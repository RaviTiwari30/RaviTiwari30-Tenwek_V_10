using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for cpoe_deathnotification  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	10/25/2014 2:50:23 PM 
/// Description:	This class is intended for inserting, updating, deleting values for cpoe_deathnotification table 
/// ========================================================================================== 
/// </summary>  

public class cpoe_deathnotification
{
    public cpoe_deathnotification()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_deathnotification(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Religion;
    private string _Occupation;
    private string _Country_Death;
    private string _City_Death;
    private string _Admission_Reason;
    private string _illness_History;
    private DateTime _Death_Date;
    private string _Time_Death;
    private string _Immediate_Death;
    private string _Intermediate_Death;
    private string _Other_Significant;
    private string _Underlying_Death;
    private string _Interval_Death;
    private string _Manner_death;
    private string _Manner_Death_Other;
    private string _Doctor_Remarks;
    private string _Name_Notifier;
    private string _Nationality_Notifier;
    private string _Relationship_Deceased;
    private string _Address_Notifier;
    private string _Emirate;
    private DateTime _date_notifier;
    private string _Contact_no;
    private string _Diagnosis;
    private string _Relevant;
    private string _Outcome;
    private string _Outcome_Text;
    private string _Management;
    private string _Management_Text;
    private string _Recomendation;
    private string _Entry_By;
    private string _Update_By;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Religion { get { return _Religion; } set { _Religion = value; } }
    public virtual string Occupation { get { return _Occupation; } set { _Occupation = value; } }
    public virtual string Country_Death { get { return _Country_Death; } set { _Country_Death = value; } }
    public virtual string City_Death { get { return _City_Death; } set { _City_Death = value; } }
    public virtual string Admission_Reason { get { return _Admission_Reason; } set { _Admission_Reason = value; } }
    public virtual string illness_History { get { return _illness_History; } set { _illness_History = value; } }
    public virtual DateTime Death_Date { get { return _Death_Date; } set { _Death_Date = value; } }
    public virtual string Time_Death { get { return _Time_Death; } set { _Time_Death = value; } }
    public virtual string Immediate_Death { get { return _Immediate_Death; } set { _Immediate_Death = value; } }
    public virtual string Intermediate_Death { get { return _Intermediate_Death; } set { _Intermediate_Death = value; } }
    public virtual string Other_Significant { get { return _Other_Significant; } set { _Other_Significant = value; } }
    public virtual string Underlying_Death { get { return _Underlying_Death; } set { _Underlying_Death = value; } }
    public virtual string Interval_Death { get { return _Interval_Death; } set { _Interval_Death = value; } }
    public virtual string Manner_death { get { return _Manner_death; } set { _Manner_death = value; } }
    public virtual string Manner_Death_Other { get { return _Manner_Death_Other; } set { _Manner_Death_Other = value; } }
    public virtual string Doctor_Remarks { get { return _Doctor_Remarks; } set { _Doctor_Remarks = value; } }
    public virtual string Name_Notifier { get { return _Name_Notifier; } set { _Name_Notifier = value; } }
    public virtual string Nationality_Notifier { get { return _Nationality_Notifier; } set { _Nationality_Notifier = value; } }
    public virtual string Relationship_Deceased { get { return _Relationship_Deceased; } set { _Relationship_Deceased = value; } }
    public virtual string Address_Notifier { get { return _Address_Notifier; } set { _Address_Notifier = value; } }
    public virtual string Emirate { get { return _Emirate; } set { _Emirate = value; } }
    public virtual DateTime date_notifier { get { return _date_notifier; } set { _date_notifier = value; } }
    public virtual string Contact_no { get { return _Contact_no; } set { _Contact_no = value; } }
    public virtual string Diagnosis { get { return _Diagnosis; } set { _Diagnosis = value; } }
    public virtual string Relevant { get { return _Relevant; } set { _Relevant = value; } }
    public virtual string Outcome { get { return _Outcome; } set { _Outcome = value; } }
    public virtual string Outcome_Text { get { return _Outcome_Text; } set { _Outcome_Text = value; } }
    public virtual string Management { get { return _Management; } set { _Management = value; } }
    public virtual string Management_Text { get { return _Management_Text; } set { _Management_Text = value; } }
    public virtual string Recomendation { get { return _Recomendation; } set { _Recomendation = value; } }
    public virtual string Entry_By { get { return _Entry_By; } set { _Entry_By = value; } }
    public virtual string Update_By { get { return _Update_By; } set { _Update_By = value;  } }
 

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_deathnotification_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vReligion", Util.GetString(Religion)));
            cmd.Parameters.Add(new MySqlParameter("@vOccupation", Util.GetString(Occupation)));
            cmd.Parameters.Add(new MySqlParameter("@vCountry_Death", Util.GetString(Country_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vCity_Death", Util.GetString(City_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vAdmission_Reason", Util.GetString(Admission_Reason)));
            cmd.Parameters.Add(new MySqlParameter("@villness_History", Util.GetString(illness_History)));
            cmd.Parameters.Add(new MySqlParameter("@vDeath_Date", Util.GetDateTime(Death_Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_Death", Util.GetString(Time_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vImmediate_Death", Util.GetString(Immediate_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vIntermediate_Death", Util.GetString(Intermediate_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vOther_Significant", Util.GetString(Other_Significant)));
            cmd.Parameters.Add(new MySqlParameter("@vUnderlying_Death", Util.GetString(Underlying_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vInterval_Death", Util.GetString(Interval_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vManner_death", Util.GetString(Manner_death)));
            cmd.Parameters.Add(new MySqlParameter("@vManner_Death_Other", Util.GetString(Manner_Death_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctor_Remarks", Util.GetString(Doctor_Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vName_Notifier", Util.GetString(Name_Notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vNationality_Notifier", Util.GetString(Nationality_Notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vRelationship_Deceased", Util.GetString(Relationship_Deceased)));
            cmd.Parameters.Add(new MySqlParameter("@vAddress_Notifier", Util.GetString(Address_Notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vEmirate", Util.GetString(Emirate)));
            cmd.Parameters.Add(new MySqlParameter("@vdate_notifier", Util.GetDateTime(date_notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vContact_no", Util.GetString(Contact_no)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosis", Util.GetString(Diagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vRelevant", Util.GetString(Relevant)));
            cmd.Parameters.Add(new MySqlParameter("@vOutcome", Util.GetString(Outcome)));
            cmd.Parameters.Add(new MySqlParameter("@vOutcome_Text", Util.GetString(Outcome_Text)));
            cmd.Parameters.Add(new MySqlParameter("@vManagement", Util.GetString(Management)));
            cmd.Parameters.Add(new MySqlParameter("@vManagement_Text", Util.GetString(Management_Text)));
            cmd.Parameters.Add(new MySqlParameter("@vRecomendation", Util.GetString(Recomendation)));
            cmd.Parameters.Add(new MySqlParameter("@vEntry_By", Util.GetString(Entry_By)));

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

            objSQL.Append("cpoe_deathnotification_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vReligion", Util.GetString(Religion)));
            cmd.Parameters.Add(new MySqlParameter("@vOccupation", Util.GetString(Occupation)));
            cmd.Parameters.Add(new MySqlParameter("@vCountry_Death", Util.GetString(Country_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vCity_Death", Util.GetString(City_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vAdmission_Reason", Util.GetString(Admission_Reason)));
            cmd.Parameters.Add(new MySqlParameter("@villness_History", Util.GetString(illness_History)));
            cmd.Parameters.Add(new MySqlParameter("@vDeath_Date", Util.GetDateTime(Death_Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime_Death", Util.GetString(Time_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vImmediate_Death", Util.GetString(Immediate_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vIntermediate_Death", Util.GetString(Intermediate_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vOther_Significant", Util.GetString(Other_Significant)));
            cmd.Parameters.Add(new MySqlParameter("@vUnderlying_Death", Util.GetString(Underlying_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vInterval_Death", Util.GetString(Interval_Death)));
            cmd.Parameters.Add(new MySqlParameter("@vManner_death", Util.GetString(Manner_death)));
            cmd.Parameters.Add(new MySqlParameter("@vManner_Death_Other", Util.GetString(Manner_Death_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctor_Remarks", Util.GetString(Doctor_Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vName_Notifier", Util.GetString(Name_Notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vNationality_Notifier", Util.GetString(Nationality_Notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vRelationship_Deceased", Util.GetString(Relationship_Deceased)));
            cmd.Parameters.Add(new MySqlParameter("@vAddress_Notifier", Util.GetString(Address_Notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vEmirate", Util.GetString(Emirate)));
            cmd.Parameters.Add(new MySqlParameter("@vdate_notifier", Util.GetDateTime(date_notifier)));
            cmd.Parameters.Add(new MySqlParameter("@vContact_no", Util.GetString(Contact_no)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosis", Util.GetString(Diagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vRelevant", Util.GetString(Relevant)));
            cmd.Parameters.Add(new MySqlParameter("@vOutcome", Util.GetString(Outcome)));
            cmd.Parameters.Add(new MySqlParameter("@vOutcome_Text", Util.GetString(Outcome_Text)));
            cmd.Parameters.Add(new MySqlParameter("@vManagement", Util.GetString(Management)));
            cmd.Parameters.Add(new MySqlParameter("@vManagement_Text", Util.GetString(Management_Text)));
            cmd.Parameters.Add(new MySqlParameter("@vRecomendation", Util.GetString(Recomendation)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdate_By", Util.GetString(Update_By)));

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
