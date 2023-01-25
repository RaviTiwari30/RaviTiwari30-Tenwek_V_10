using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_le_rehab  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/5/2014 6:13:08 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_le_rehab table 
/// ========================================================================================== 
/// </summary>  

public class physio_le_rehab
{
    public physio_le_rehab()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_le_rehab(MySqlTransaction objTrans)
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
    private DateTime _On;
    private string _Referred_Dr;
    private string _For;
    private string _PMH;
    private string _PSH;
    private string _Meds;
    private string _Drains;
    private string _Mental;
    private string _Patientwilling;
    private string _Barriers;
    private string _Barrierscomments;
    private string _lncision;
    private string _Pain_Scale;
    private string _UEStrength;
    private string _LEStrength;
    private string _Transfers;
    private string _Gait;
    private string _ft_unassisted;
    private string _Ascend;
    private int _Therapeutic;
    private string _Instructed;
    private string _Reps;
    private string _Freq;
    private string _Written;
    private string _Surgery;
    private string _Assessment;
    private string _Ambulation;
    private string _Descend;
    private string _RblAscend;
    private string _TherapyGoals;
    private string _Patientgoals;
    private string _Plan;
    private string _CreatedBy;

    private string _UpdatedBy;
    private DateTime _UpdatedDate;
    private string _Assisted;
    private string _txtPatientgoals;
    private string _Surface;

    private string _WBAT;
    private string _PWB;
    private string _TTWB;
    private string _NWB;


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
    public virtual DateTime On { get { return _On; } set { _On = value; } }
    public virtual string Referred_Dr { get { return _Referred_Dr; } set { _Referred_Dr = value; } }
    public virtual string For { get { return _For; } set { _For = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string Meds { get { return _Meds; } set { _Meds = value; } }
    public virtual string Drains { get { return _Drains; } set { _Drains = value; } }
    public virtual string Mental { get { return _Mental; } set { _Mental = value; } }
    public virtual string Patientwilling { get { return _Patientwilling; } set { _Patientwilling = value; } }
    public virtual string Barriers { get { return _Barriers; } set { _Barriers = value; } }
    public virtual string Barrierscomments { get { return _Barrierscomments; } set { _Barrierscomments = value; } }
    public virtual string lncision { get { return _lncision; } set { _lncision = value; } }
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual string UEStrength { get { return _UEStrength; } set { _UEStrength = value; } }
    public virtual string LEStrength { get { return _LEStrength; } set { _LEStrength = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Gait { get { return _Gait; } set { _Gait = value; } }
    public virtual string ft_unassisted { get { return _ft_unassisted; } set { _ft_unassisted = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual int Therapeutic { get { return _Therapeutic; } set { _Therapeutic = value; } }
    public virtual string Instructed { get { return _Instructed; } set { _Instructed = value; } }
    public virtual string Reps { get { return _Reps; } set { _Reps = value; } }
    public virtual string Freq { get { return _Freq; } set { _Freq = value; } }
    public virtual string Written { get { return _Written; } set { _Written = value; } }
    public virtual string Surgery { get { return _Surgery; } set { _Surgery = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Ambulation { get { return _Ambulation; } set { _Ambulation = value; } }
    public virtual string Descend { get { return _Descend; } set { _Descend = value; } }
    public virtual string RblAscend { get { return _RblAscend; } set { _RblAscend = value; } }
    public virtual string TherapyGoals { get { return _TherapyGoals; } set { _TherapyGoals = value; } }
    public virtual string Patientgoals { get { return _Patientgoals; } set { _Patientgoals = value; } }
    public virtual string Plan { get { return _Plan; } set { _Plan = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }

    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }
    public virtual string Assisted { get { return _Assisted; } set { _Assisted = value; } }
    public virtual string txtPatientgoals { get { return _txtPatientgoals; } set { _txtPatientgoals = value; } }
    public virtual string Surface { get { return _Surface; } set { _Surface = value; } }

    public virtual string WBAT { get { return _WBAT; } set { _WBAT = value; } }
    public virtual string PWB { get { return _PWB; } set { _PWB = value; } }
    public virtual string TTWB { get { return _TTWB; } set { _TTWB = value; } }
    public virtual string NWB { get { return _NWB; } set { _NWB = value; } }


    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_le_rehab_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vOn", Util.GetDateTime(On)));
            cmd.Parameters.Add(new MySqlParameter("@vReferred_Dr", Util.GetString(Referred_Dr)));
            cmd.Parameters.Add(new MySqlParameter("@vFor", Util.GetString(For)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vMeds", Util.GetString(Meds)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vMental", Util.GetString(Mental)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientwilling", Util.GetString(Patientwilling)));
            cmd.Parameters.Add(new MySqlParameter("@vBarriers", Util.GetString(Barriers)));
            cmd.Parameters.Add(new MySqlParameter("@vBarrierscomments", Util.GetString(Barrierscomments)));
            cmd.Parameters.Add(new MySqlParameter("@vlncision", Util.GetString(lncision)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vUEStrength", Util.GetString(UEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vLEStrength", Util.GetString(LEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vGait", Util.GetString(Gait)));
            cmd.Parameters.Add(new MySqlParameter("@vft_unassisted", Util.GetString(ft_unassisted)));
            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapeutic", Util.GetInt(Therapeutic)));
            cmd.Parameters.Add(new MySqlParameter("@vInstructed", Util.GetString(Instructed)));
            cmd.Parameters.Add(new MySqlParameter("@vReps", Util.GetString(Reps)));
            cmd.Parameters.Add(new MySqlParameter("@vFreq", Util.GetString(Freq)));
            cmd.Parameters.Add(new MySqlParameter("@vWritten", Util.GetString(Written)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulation", Util.GetString(Ambulation)));
            cmd.Parameters.Add(new MySqlParameter("@vDescend", Util.GetString(Descend)));
            cmd.Parameters.Add(new MySqlParameter("@vRblAscend", Util.GetString(RblAscend)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapyGoals", Util.GetString(TherapyGoals)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientgoals", Util.GetString(Patientgoals)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan", Util.GetString(Plan)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));

            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAssisted", Util.GetString(Assisted)));
            cmd.Parameters.Add(new MySqlParameter("@vtxtPatientgoals", Util.GetString(txtPatientgoals)));
            cmd.Parameters.Add(new MySqlParameter("@vSurface", Util.GetString(Surface)));


            cmd.Parameters.Add(new MySqlParameter("@vWBAT", Util.GetString(WBAT)));
            cmd.Parameters.Add(new MySqlParameter("@vPWB", Util.GetString(PWB)));
            cmd.Parameters.Add(new MySqlParameter("@vTTWB", Util.GetString(TTWB)));
            cmd.Parameters.Add(new MySqlParameter("@vNWB", Util.GetString(NWB)));
            
            

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
