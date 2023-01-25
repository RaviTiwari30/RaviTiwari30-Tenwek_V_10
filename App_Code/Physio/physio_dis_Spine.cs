using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for physio_dis_Spine
/// </summary>
public class physio_dis_Spine
{
	public physio_dis_Spine()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_dis_Spine(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

   
    private string _TransactionID;
    private string _PtUnderwent;
    private DateTime _DATE;
    private DateTime _TIME;
    private string _Therapist;
    private DateTime _Patienton;
    private DateTime _Patientreferred;
    private string _forSpine;
    private string _PMH;
    private string _PSH;
    private string _lncision;
    private string _PainScale;
    private string _Patientwilling;
    private string _Transfers;
    private string _Gait;
    private string _Stairs;
    private string _Patientinstructed;
    private string _Patienteducated;
    private string _DonDoff;
    private string _assist;
    private string _Assessment;
    private string _Independent;
    private string _Ascend;
    private string _Steps;
    private string _Stepswith;
    private string _spineprecautions;
    private string _brace;
    private string _Patientgoalsfor;
    private string _Recommendations;
    private string _Equipmentissued;
    private string _DischargePlan;
    private string _CreatedBy;
    


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PtUnderwent { get { return _PtUnderwent; } set { _PtUnderwent = value; } }
    public virtual DateTime DATE { get { return _DATE; } set { _DATE = value; } }
    public virtual DateTime TIME { get { return _TIME; } set { _TIME = value; } }
    public virtual string Therapist { get { return _Therapist; } set { _Therapist = value; } }
    public virtual DateTime Patienton { get { return _Patienton; } set { _Patienton = value; } }
    public virtual DateTime Patientreferred { get { return _Patientreferred; } set { _Patientreferred = value; } }
    public virtual string forSpine { get { return _forSpine; } set { _forSpine = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string lncision { get { return _lncision; } set { _lncision = value; } }
    public virtual string PainScale { get { return _PainScale; } set { _PainScale = value; } }
    public virtual string Patientwilling { get { return _Patientwilling; } set { _Patientwilling = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Gait { get { return _Gait; } set { _Gait = value; } }
    public virtual string Stairs { get { return _Stairs; } set { _Stairs = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Patienteducated { get { return _Patienteducated; } set { _Patienteducated = value; } }
    public virtual string DonDoff { get { return _DonDoff; } set { _DonDoff = value; } }
    public virtual string assist { get { return _assist; } set { _assist = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Independent { get { return _Independent; } set { _Independent = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual string Steps { get { return _Steps; } set { _Steps = value; } }
    public virtual string Stepswith { get { return _Stepswith; } set { _Stepswith = value; } }
    public virtual string spineprecautions { get { return _spineprecautions; } set { _spineprecautions = value; } }
    public virtual string brace { get { return _brace; } set { _brace = value; } }
    public virtual string Patientgoalsfor { get { return _Patientgoalsfor; } set { _Patientgoalsfor = value; } }
    public virtual string Recommendations { get { return _Recommendations; } set { _Recommendations = value; } }
    public virtual string Equipmentissued { get { return _Equipmentissued; } set { _Equipmentissued = value; } }
    public virtual string DischargePlan { get { return _DischargePlan; } set { _DischargePlan = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_dis_spine_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPtUnderwent", Util.GetString(PtUnderwent)));
            cmd.Parameters.Add(new MySqlParameter("@vDATE", Util.GetDateTime(DATE)));
            cmd.Parameters.Add(new MySqlParameter("@vTIME", Util.GetDateTime(TIME)));
            cmd.Parameters.Add(new MySqlParameter("@vTherapist", Util.GetString(Therapist)));
            cmd.Parameters.Add(new MySqlParameter("@vPatienton", Util.GetDateTime(Patienton)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientreferred", Util.GetDateTime(Patientreferred)));
            cmd.Parameters.Add(new MySqlParameter("@vforSpine", Util.GetString(forSpine)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vlncision", Util.GetString(lncision)));
            cmd.Parameters.Add(new MySqlParameter("@vPainScale", Util.GetString(PainScale)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientwilling", Util.GetString(Patientwilling)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vGait", Util.GetString(Gait)));
            cmd.Parameters.Add(new MySqlParameter("@vStairs", Util.GetString(Stairs)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vPatienteducated", Util.GetString(Patienteducated)));
            cmd.Parameters.Add(new MySqlParameter("@vDonDoff", Util.GetString(DonDoff)));
            cmd.Parameters.Add(new MySqlParameter("@vassist", Util.GetString(assist)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vIndependent", Util.GetString(Independent)));
            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vSteps", Util.GetString(Steps)));
            cmd.Parameters.Add(new MySqlParameter("@vStepswith", Util.GetString(Stepswith)));
            cmd.Parameters.Add(new MySqlParameter("@vspineprecautions", Util.GetString(spineprecautions)));
            cmd.Parameters.Add(new MySqlParameter("@vbrace", Util.GetString(brace)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientgoalsfor", Util.GetString(Patientgoalsfor)));
            cmd.Parameters.Add(new MySqlParameter("@vRecommendations", Util.GetString(Recommendations)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipmentissued", Util.GetString(Equipmentissued)));
            cmd.Parameters.Add(new MySqlParameter("@vDischargePlan", Util.GetString(DischargePlan)));
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