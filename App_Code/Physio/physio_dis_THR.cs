using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for physio_dis_THR
/// </summary>
public class physio_dis_THR
{
	public physio_dis_THR()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_dis_THR(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

   
    private string _TransactionID;
    private DateTime _DATE;
    private DateTime _TIME;
    private string _Therapist;
    private string _Patientunderwent;
    private DateTime _TKROn;
    private DateTime _Referred;
    private string _DoctorID;
    private string _THRprotocolFor;
    private string _PMH;
    private string _PSH;
    private string _lncision;
    private string _Pain_Scale;
    private string _Transfers;
    private string _Gait;
    private string _Stairs;
    private string _Precautions;
    private string _verbalize;
    private string _Patientviewed;
    private string _Surgery;
    private string _Patientinstructed;
    private string _Repetitions;
    private string _Frequency;
    private string _Patientdemonstrate;
    private string _Provided;
    private string _Patientwilling;
    private string _Barriers;
    private string _Barrierscomments;
    private string _Assessment;
    private string _Equipment;
    private string _Unassisted;
    private string _ft;
    private string _WBAT;
    private string _Ascend;
    private string _Ascendsteps;
    private string _PtGoals;
    private string _Patientgoals;
    private string _Recommendations;
    private string _CreatedBy;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime DATE { get { return _DATE; } set { _DATE = value; } }
    public virtual DateTime TIME { get { return _TIME; } set { _TIME = value; } }
    public virtual string Therapist { get { return _Therapist; } set { _Therapist = value; } }
    public virtual string Patientunderwent { get { return _Patientunderwent; } set { _Patientunderwent = value; } }
    public virtual DateTime TKROn { get { return _TKROn; } set { _TKROn = value; } }
    public virtual DateTime Referred { get { return _Referred; } set { _Referred = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string THRprotocolFor { get { return _THRprotocolFor; } set { _THRprotocolFor = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string lncision { get { return _lncision; } set { _lncision = value; } }
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Gait { get { return _Gait; } set { _Gait = value; } }
    public virtual string Stairs { get { return _Stairs; } set { _Stairs = value; } }
    public virtual string Precautions { get { return _Precautions; } set { _Precautions = value; } }
    public virtual string verbalize { get { return _verbalize; } set { _verbalize = value; } }
    public virtual string Patientviewed { get { return _Patientviewed; } set { _Patientviewed = value; } }
    public virtual string Surgery { get { return _Surgery; } set { _Surgery = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Repetitions { get { return _Repetitions; } set { _Repetitions = value; } }
    public virtual string Frequency { get { return _Frequency; } set { _Frequency = value; } }
    public virtual string Patientdemonstrate { get { return _Patientdemonstrate; } set { _Patientdemonstrate = value; } }
    public virtual string Provided { get { return _Provided; } set { _Provided = value; } }
    public virtual string Patientwilling { get { return _Patientwilling; } set { _Patientwilling = value; } }
    public virtual string Barriers { get { return _Barriers; } set { _Barriers = value; } }
    public virtual string Barrierscomments { get { return _Barrierscomments; } set { _Barrierscomments = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Equipment { get { return _Equipment; } set { _Equipment = value; } }
    public virtual string Unassisted { get { return _Unassisted; } set { _Unassisted = value; } }
    public virtual string ft { get { return _ft; } set { _ft = value; } }
    public virtual string WBAT { get { return _WBAT; } set { _WBAT = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual string Ascendsteps { get { return _Ascendsteps; } set { _Ascendsteps = value; } }
    public virtual string PtGoals { get { return _PtGoals; } set { _PtGoals = value; } }
    public virtual string Patientgoals { get { return _Patientgoals; } set { _Patientgoals = value; } }
    public virtual string Recommendations { get { return _Recommendations; } set { _Recommendations = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_dis_THR_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vDATE", Util.GetDateTime(DATE)));
            cmd.Parameters.Add(new MySqlParameter("@vTIME", Util.GetDateTime(TIME)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapist", Util.GetString(Therapist)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientunderwent", Util.GetString(Patientunderwent)));
            cmd.Parameters.Add(new MySqlParameter("@vTKROn", Util.GetDateTime(TKROn)));
            cmd.Parameters.Add(new MySqlParameter("@vReferred", Util.GetDateTime(Referred)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vTHRprotocolFor", Util.GetString(THRprotocolFor)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vlncision", Util.GetString(lncision)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vGait", Util.GetString(Gait)));
            cmd.Parameters.Add(new MySqlParameter("@vStairs", Util.GetString(Stairs)));
            cmd.Parameters.Add(new MySqlParameter("@vPrecautions", Util.GetString(Precautions)));
            cmd.Parameters.Add(new MySqlParameter("@vverbalize", Util.GetString(verbalize)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientviewed", Util.GetString(Patientviewed)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vRepetitions", Util.GetString(Repetitions)));
            cmd.Parameters.Add(new MySqlParameter("@vFrequency", Util.GetString(Frequency)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientdemonstrate", Util.GetString(Patientdemonstrate)));
            cmd.Parameters.Add(new MySqlParameter("@vProvided", Util.GetString(Provided)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientwilling", Util.GetString(Patientwilling)));
            cmd.Parameters.Add(new MySqlParameter("@vBarriers", Util.GetString(Barriers)));
            cmd.Parameters.Add(new MySqlParameter("@vBarrierscomments", Util.GetString(Barrierscomments)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipment", Util.GetString(Equipment)));
            cmd.Parameters.Add(new MySqlParameter("@vUnassisted", Util.GetString(Unassisted)));
            cmd.Parameters.Add(new MySqlParameter("@vft", Util.GetString(ft)));
            cmd.Parameters.Add(new MySqlParameter("@vWBAT", Util.GetString(WBAT)));
            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vAscendsteps", Util.GetString(Ascendsteps)));
            cmd.Parameters.Add(new MySqlParameter("@vPtGoals", Util.GetString(PtGoals)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientgoals", Util.GetString(Patientgoals)));
            cmd.Parameters.Add(new MySqlParameter("@vRecommendations", Util.GetString(Recommendations)));
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