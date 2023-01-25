using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
/// <summary>
/// Summary description for physio_dis_PhyTherapy
/// </summary>
public class physio_dis_PhyTherapy
{
	public physio_dis_PhyTherapy()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_dis_PhyTherapy(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

   
    private string _TransactionID;
    private DateTime _DATE;
    private DateTime _TIME;
    private string _Therapist;
    private string _pt_Age;
    private string _pt_Sex;
    private DateTime _Hospital_on;
    private string _diagnosis_of;
    private string _Pt_underwent;
    private string _DoctorID;
    private DateTime _performed_on;
    private string _referred_pt;
    private string _PMH;
    private string _PSH;
    private string _Pain_Scale;
    private string _UELE;
    private string _RangeOfMotion;
    private string _MuscleStrength;
    private string _Transfers;
    private string _Ambulation;
    private string _Stairs;
    private string _Therex;
    private string _Patientinstructed;
    private string _Patienteducated;
    private string _PTGoals;
    private string _Patientgoals;
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
    public virtual DateTime DATE { get { return _DATE; } set { _DATE = value; } }
    public virtual DateTime TIME { get { return _TIME; } set { _TIME = value; } }
    public virtual string Therapist { get { return _Therapist; } set { _Therapist = value; } }
    public virtual string pt_Age { get { return _pt_Age; } set { _pt_Age = value; } }
    public virtual string pt_Sex { get { return _pt_Sex; } set { _pt_Sex = value; } }
    public virtual DateTime Hospital_on { get { return _Hospital_on; } set { _Hospital_on = value; } }
    public virtual string diagnosis_of { get { return _diagnosis_of; } set { _diagnosis_of = value; } }
    public virtual string Pt_underwent { get { return _Pt_underwent; } set { _Pt_underwent = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual DateTime performed_on { get { return _performed_on; } set { _performed_on = value; } }
    public virtual string referred_pt { get { return _referred_pt; } set { _referred_pt = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual string UELE { get { return _UELE; } set { _UELE = value; } }
    public virtual string RangeOfMotion { get { return _RangeOfMotion; } set { _RangeOfMotion = value; } }
    public virtual string MuscleStrength { get { return _MuscleStrength; } set { _MuscleStrength = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Ambulation { get { return _Ambulation; } set { _Ambulation = value; } }
    public virtual string Stairs { get { return _Stairs; } set { _Stairs = value; } }
    public virtual string Therex { get { return _Therex; } set { _Therex = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Patienteducated { get { return _Patienteducated; } set { _Patienteducated = value; } }
    public virtual string PTGoals { get { return _PTGoals; } set { _PTGoals = value; } }
    public virtual string Patientgoals { get { return _Patientgoals; } set { _Patientgoals = value; } }
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

            objSQL.Append("physio_dis_PhyTherapy_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vpt_Age", Util.GetString(pt_Age)));
            cmd.Parameters.Add(new MySqlParameter("@vpt_Sex", Util.GetString(pt_Sex)));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_on", Util.GetDateTime(Hospital_on)));
            cmd.Parameters.Add(new MySqlParameter("@vdiagnosis_of", Util.GetString(diagnosis_of)));
            cmd.Parameters.Add(new MySqlParameter("@vPt_underwent", Util.GetString(Pt_underwent)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vperformed_on", Util.GetDateTime(performed_on)));
            cmd.Parameters.Add(new MySqlParameter("@vreferred_pt", Util.GetString(referred_pt)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vUELE", Util.GetString(UELE)));
            cmd.Parameters.Add(new MySqlParameter("@vRangeOfMotion", Util.GetString(RangeOfMotion)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleStrength", Util.GetString(MuscleStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulation", Util.GetString(Ambulation)));
            cmd.Parameters.Add(new MySqlParameter("@vStairs", Util.GetString(Stairs)));
            cmd.Parameters.Add(new MySqlParameter("@vTherex", Util.GetString(Therex)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vPatienteducated", Util.GetString(Patienteducated)));
            cmd.Parameters.Add(new MySqlParameter("@vPTGoals", Util.GetString(PTGoals)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientgoals", Util.GetString(Patientgoals)));
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