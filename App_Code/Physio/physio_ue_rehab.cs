using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_ue_rehab  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/5/2014 1:30:40 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_ue_rehab table 
/// ========================================================================================== 
/// </summary>  

public class physio_ue_rehab
{
    public physio_ue_rehab()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_ue_rehab(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private DateTime _Date;
    private string _Time;
    private string _Therapist;
    private string _Underwent;
    private DateTime _OnDate;
    private string _For;
    private string _Referred_Dr;
    private string _PMH;
    private string _PSH;
    private string _Meds;
    private string _Drains;
    private string _Mental;
    private string _Patent;
    private string _Barriers;
    private string _Barrierscomments;
    private string _lncision;
    private string _Pain_Scale;
    private string _UESensation;
    private string _UEStrength;
    private string _Elbow;
    private string _Wrist;
    private string _LEStrength;
    private string _Prior_Level;
    private string _Other;
    private string _Transfers;
    private string _Don;
    private string _Patientinstructed;
    private string _Reps;
    private string _Frequency;
    private string _Surgery;
    private string _Assessment;
    private string _Patient_goals;
    private string _Assist;
    private string _Indepenendent;
    private string _Achieved;
    private string _Plan;
    private string _CreatedBy;
    
    private string _UpdatedBy;
    private DateTime _UpdatedDate;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual string Time { get { return _Time; } set { _Time = value; } }
    public virtual string Therapist { get { return _Therapist; } set { _Therapist = value; } }
    public virtual string Underwent { get { return _Underwent; } set { _Underwent = value; } }
    public virtual DateTime OnDate { get { return _OnDate; } set { _OnDate = value; } }
    public virtual string For { get { return _For; } set { _For = value; } }
    public virtual string Referred_Dr { get { return _Referred_Dr; } set { _Referred_Dr = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string Meds { get { return _Meds; } set { _Meds = value; } }
    public virtual string Drains { get { return _Drains; } set { _Drains = value; } }
    public virtual string Mental { get { return _Mental; } set { _Mental = value; } }
    public virtual string Patent { get { return _Patent; } set { _Patent = value; } }
    public virtual string Barriers { get { return _Barriers; } set { _Barriers = value; } }
    public virtual string Barrierscomments { get { return _Barrierscomments; } set { _Barrierscomments = value; } }
    public virtual string lncision { get { return _lncision; } set { _lncision = value; } }
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual string UESensation { get { return _UESensation; } set { _UESensation = value; } }
    public virtual string UEStrength { get { return _UEStrength; } set { _UEStrength = value; } }
    public virtual string Elbow { get { return _Elbow; } set { _Elbow = value; } }
    public virtual string Wrist { get { return _Wrist; } set { _Wrist = value; } }
    public virtual string LEStrength { get { return _LEStrength; } set { _LEStrength = value; } }
    public virtual string Prior_Level { get { return _Prior_Level; } set { _Prior_Level = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Don { get { return _Don; } set { _Don = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Reps { get { return _Reps; } set { _Reps = value; } }
    public virtual string Frequency { get { return _Frequency; } set { _Frequency = value; } }
    public virtual string Surgery { get { return _Surgery; } set { _Surgery = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Patient_goals { get { return _Patient_goals; } set { _Patient_goals = value; } }
    public virtual string Assist { get { return _Assist; } set { _Assist = value; } }
    public virtual string Indepenendent { get { return _Indepenendent; } set { _Indepenendent = value; } }
    public virtual string Achieved { get { return _Achieved; } set { _Achieved = value; } }
    public virtual string Plan { get { return _Plan; } set { _Plan = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }

    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_ue_rehab_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetString(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapist", Util.GetString(Therapist)));
            cmd.Parameters.Add(new MySqlParameter("@vUnderwent", Util.GetString(Underwent)));
            cmd.Parameters.Add(new MySqlParameter("@vOnDate", Util.GetDateTime(OnDate)));
            cmd.Parameters.Add(new MySqlParameter("@vFor", Util.GetString(For)));
            cmd.Parameters.Add(new MySqlParameter("@vReferred_Dr", Util.GetString(Referred_Dr)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vMeds", Util.GetString(Meds)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vMental", Util.GetString(Mental)));
            cmd.Parameters.Add(new MySqlParameter("@vPatent", Util.GetString(Patent)));
            cmd.Parameters.Add(new MySqlParameter("@vBarriers", Util.GetString(Barriers)));
            cmd.Parameters.Add(new MySqlParameter("@vBarrierscomments", Util.GetString(Barrierscomments)));
            cmd.Parameters.Add(new MySqlParameter("@vlncision", Util.GetString(lncision)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vUESensation", Util.GetString(UESensation)));
            cmd.Parameters.Add(new MySqlParameter("@vUEStrength", Util.GetString(UEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vElbow", Util.GetString(Elbow)));
            cmd.Parameters.Add(new MySqlParameter("@vWrist", Util.GetString(Wrist)));
            cmd.Parameters.Add(new MySqlParameter("@vLEStrength", Util.GetString(LEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vPrior_Level", Util.GetString(Prior_Level)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vDon", Util.GetString(Don)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vReps", Util.GetString(Reps)));
            cmd.Parameters.Add(new MySqlParameter("@vFrequency", Util.GetString(Frequency)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vPatient_goals", Util.GetString(Patient_goals)));
            cmd.Parameters.Add(new MySqlParameter("@vAssist", Util.GetString(Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vIndepenendent", Util.GetString(Indepenendent)));
            cmd.Parameters.Add(new MySqlParameter("@vAchieved", Util.GetString(Achieved)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan", Util.GetString(Plan)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
  
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));

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
