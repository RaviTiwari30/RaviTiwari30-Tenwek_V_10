using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
/// <summary>
/// Summary description for physio_dis_TKR
/// </summary>
public class physio_dis_TKR
{
	public physio_dis_TKR()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_dis_TKR(MySqlTransaction objTrans)
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
    private string _ForPt;
    private string _PMH;
    private string _PSH;
    private string _lncision;
    private string _INR;
    private string _PainScale;
    private string _Transfers;
    private string _Gait;
    private string _Stairs;
    private string _KneeROMRight;
    private string _KneeROMLeft;
    private string _CPM;
    private string _Patientinstructed;
    private string _Patientdemonstrate;
    private string _Repetitions;
    private string _Frequency;
    private string _Patient;
    private string _surgery;
    private string _Independentamb;
    private string _RW;
    private string _Ascend;
    private string _Steps;
    private string _Kneeflexion;
    private string _Patientwilling;
    private string _Barriers;
    private string _Barrierscomments;
    private string _CPMsent;
    private string _Equipmentissued;
    private string _DischargePlan;
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
    public virtual string ForPt { get { return _ForPt; } set { _ForPt = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string lncision { get { return _lncision; } set { _lncision = value; } }
    public virtual string INR { get { return _INR; } set { _INR = value; } }
    public virtual string PainScale { get { return _PainScale; } set { _PainScale = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Gait { get { return _Gait; } set { _Gait = value; } }
    public virtual string Stairs { get { return _Stairs; } set { _Stairs = value; } }
    public virtual string KneeROMRight { get { return _KneeROMRight; } set { _KneeROMRight = value; } }
    public virtual string KneeROMLeft { get { return _KneeROMLeft; } set { _KneeROMLeft = value; } }
    public virtual string CPM { get { return _CPM; } set { _CPM = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Patientdemonstrate { get { return _Patientdemonstrate; } set { _Patientdemonstrate = value; } }
    public virtual string Repetitions { get { return _Repetitions; } set { _Repetitions = value; } }
    public virtual string Frequency { get { return _Frequency; } set { _Frequency = value; } }
    public virtual string Patient { get { return _Patient; } set { _Patient = value; } }
    public virtual string surgery { get { return _surgery; } set { _surgery = value; } }
    public virtual string Independentamb { get { return _Independentamb; } set { _Independentamb = value; } }
    public virtual string RW { get { return _RW; } set { _RW = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual string Steps { get { return _Steps; } set { _Steps = value; } }
    public virtual string Kneeflexion { get { return _Kneeflexion; } set { _Kneeflexion = value; } }
    public virtual string Patientwilling { get { return _Patientwilling; } set { _Patientwilling = value; } }
    public virtual string Barriers { get { return _Barriers; } set { _Barriers = value; } }
    public virtual string Barrierscomments { get { return _Barrierscomments; } set { _Barrierscomments = value; } }
    public virtual string CPMsent { get { return _CPMsent; } set { _CPMsent = value; } }
    public virtual string Equipmentissued { get { return _Equipmentissued; } set { _Equipmentissued = value; } }
    public virtual string DischargePlan { get { return _DischargePlan; } set { _DischargePlan = value; } }
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

            objSQL.Append("physio_dis_TKR_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vForPt", Util.GetString(ForPt)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
         
            cmd.Parameters.Add(new MySqlParameter("@vlncision", Util.GetString(lncision)));
            cmd.Parameters.Add(new MySqlParameter("@vINR", Util.GetString(INR)));
            cmd.Parameters.Add(new MySqlParameter("@vPainScale", Util.GetString(PainScale)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vGait", Util.GetString(Gait)));
            cmd.Parameters.Add(new MySqlParameter("@vStairs", Util.GetString(Stairs)));
            cmd.Parameters.Add(new MySqlParameter("@vKneeROMRight", Util.GetString(KneeROMRight)));
            cmd.Parameters.Add(new MySqlParameter("@vKneeROMLeft", Util.GetString(KneeROMLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCPM", Util.GetString(CPM)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientdemonstrate", Util.GetString(Patientdemonstrate)));
            cmd.Parameters.Add(new MySqlParameter("@vRepetitions", Util.GetString(Repetitions)));
            cmd.Parameters.Add(new MySqlParameter("@vFrequency", Util.GetString(Frequency)));
            cmd.Parameters.Add(new MySqlParameter("@vPatient", Util.GetString(Patient)));
            cmd.Parameters.Add(new MySqlParameter("@vsurgery", Util.GetString(surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vIndependentamb", Util.GetString(Independentamb)));
            cmd.Parameters.Add(new MySqlParameter("@vRW", Util.GetString(RW)));
            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vSteps", Util.GetString(Steps)));
            cmd.Parameters.Add(new MySqlParameter("@vKneeflexion", Util.GetString(Kneeflexion)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientwilling", Util.GetString(Patientwilling)));
            cmd.Parameters.Add(new MySqlParameter("@vBarriers", Util.GetString(Barriers)));
            cmd.Parameters.Add(new MySqlParameter("@vBarrierscomments", Util.GetString(Barrierscomments)));
            cmd.Parameters.Add(new MySqlParameter("@vCPMsent", Util.GetString(CPMsent)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipmentissued", Util.GetString(Equipmentissued)));
            cmd.Parameters.Add(new MySqlParameter("@vDischargePlan", Util.GetString(DischargePlan)));
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