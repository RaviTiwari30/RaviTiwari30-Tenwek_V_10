using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for physio_history
/// </summary>
public class physio_history
{
    public physio_history()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_history(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

   
    private string _TransactionID;
    private string _PatientID;
    private string _Reff_therapy;
    private string _Ever_seen;
    private string _ever_seen_Who;
    private string _other_therapy;
    private string _Goal_therapy;
    private string _current_activities;
    private string _ever_had_surgery;
    private string _ever_had_surgery_dis;
    private string _Medications;
    private string _Medications_other;
    private string _prescription_medications;
    private string _prescription_medications_list;
    private string _General_Health;
    private string _life_changes;
    private string _Past_Year;
    private string _Past_Year_other;
    private string _latex;
    private string _adhesive_tape;
    private string _significant_allergies;
    private string _significant_allergies_list;
    private string _THERAPY_PRECAUTIONS;
    private string _THERAPY_PRECAUTIONS_other;
    private string _physical_problem;
    private string _Difficulty_with;
    private string _Difficulty_with_walking;
    private string _self_care;
    private string _home_management;
    private string _play_activities;
    private string _need_to_use;
    private string _live;
    private string _live_Other;
    private string _home_situation;
    private string _SAFETY_ISSUES;
    private string _SAFETY_ISSUES_Other;
    private string _Pre_Post_Treatment;
    private string _CreatedBy;
    private string _ChkOtherTherapy;


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string Reff_therapy { get { return _Reff_therapy; } set { _Reff_therapy = value; } }
    public virtual string Ever_seen { get { return _Ever_seen; } set { _Ever_seen = value; } }
    public virtual string ever_seen_Who { get { return _ever_seen_Who; } set { _ever_seen_Who = value; } }
    public virtual string other_therapy { get { return _other_therapy; } set { _other_therapy = value; } }
    public virtual string Goal_therapy { get { return _Goal_therapy; } set { _Goal_therapy = value; } }
    public virtual string current_activities { get { return _current_activities; } set { _current_activities = value; } }
    public virtual string ever_had_surgery { get { return _ever_had_surgery; } set { _ever_had_surgery = value; } }
    public virtual string ever_had_surgery_dis { get { return _ever_had_surgery_dis; } set { _ever_had_surgery_dis = value; } }
    public virtual string Medications { get { return _Medications; } set { _Medications = value; } }
    public virtual string Medications_other { get { return _Medications_other; } set { _Medications_other = value; } }
    public virtual string prescription_medications { get { return _prescription_medications; } set { _prescription_medications = value; } }
    public virtual string prescription_medications_list { get { return _prescription_medications_list; } set { _prescription_medications_list = value; } }
    public virtual string General_Health { get { return _General_Health; } set { _General_Health = value; } }
    public virtual string life_changes { get { return _life_changes; } set { _life_changes = value; } }
    public virtual string Past_Year { get { return _Past_Year; } set { _Past_Year = value; } }
    public virtual string Past_Year_other { get { return _Past_Year_other; } set { _Past_Year_other = value; } }
    public virtual string latex { get { return _latex; } set { _latex = value; } }
    public virtual string adhesive_tape { get { return _adhesive_tape; } set { _adhesive_tape = value; } }
    public virtual string significant_allergies { get { return _significant_allergies; } set { _significant_allergies = value; } }
    public virtual string significant_allergies_list { get { return _significant_allergies_list; } set { _significant_allergies_list = value; } }
    public virtual string THERAPY_PRECAUTIONS { get { return _THERAPY_PRECAUTIONS; } set { _THERAPY_PRECAUTIONS = value; } }
    public virtual string THERAPY_PRECAUTIONS_other { get { return _THERAPY_PRECAUTIONS_other; } set { _THERAPY_PRECAUTIONS_other = value; } }
    public virtual string physical_problem { get { return _physical_problem; } set { _physical_problem = value; } }
    public virtual string Difficulty_with { get { return _Difficulty_with; } set { _Difficulty_with = value; } }
    public virtual string Difficulty_with_walking { get { return _Difficulty_with_walking; } set { _Difficulty_with_walking = value; } }
    public virtual string self_care { get { return _self_care; } set { _self_care = value; } }
    public virtual string home_management { get { return _home_management; } set { _home_management = value; } }
    public virtual string play_activities { get { return _play_activities; } set { _play_activities = value; } }
    public virtual string need_to_use { get { return _need_to_use; } set { _need_to_use = value; } }
    public virtual string live { get { return _live; } set { _live = value; } }
    public virtual string live_Other { get { return _live_Other; } set { _live_Other = value; } }
    public virtual string home_situation { get { return _home_situation; } set { _home_situation = value; } }
    public virtual string SAFETY_ISSUES { get { return _SAFETY_ISSUES; } set { _SAFETY_ISSUES = value; } }
    public virtual string SAFETY_ISSUES_Other { get { return _SAFETY_ISSUES_Other; } set { _SAFETY_ISSUES_Other = value; } }
    public virtual string Pre_Post_Treatment { get { return _Pre_Post_Treatment; } set { _Pre_Post_Treatment = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string ChkOtherTherapy { get { return _ChkOtherTherapy; } set { _ChkOtherTherapy = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_history_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vReff_therapy", Util.GetString(Reff_therapy)));
            cmd.Parameters.Add(new MySqlParameter("@vEver_seen", Util.GetString(Ever_seen)));
            cmd.Parameters.Add(new MySqlParameter("@vever_seen_Who", Util.GetString(ever_seen_Who)));
            cmd.Parameters.Add(new MySqlParameter("@vother_therapy", Util.GetString(other_therapy)));
            cmd.Parameters.Add(new MySqlParameter("@vGoal_therapy", Util.GetString(Goal_therapy)));
            cmd.Parameters.Add(new MySqlParameter("@vcurrent_activities", Util.GetString(current_activities)));
            cmd.Parameters.Add(new MySqlParameter("@vever_had_surgery", Util.GetString(ever_had_surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vever_had_surgery_dis", Util.GetString(ever_had_surgery_dis)));
            cmd.Parameters.Add(new MySqlParameter("@vMedications", Util.GetString(Medications)));
            cmd.Parameters.Add(new MySqlParameter("@vMedications_other", Util.GetString(Medications_other)));
            cmd.Parameters.Add(new MySqlParameter("@vprescription_medications", Util.GetString(prescription_medications)));
            cmd.Parameters.Add(new MySqlParameter("@vprescription_medications_list", Util.GetString(prescription_medications_list)));
            cmd.Parameters.Add(new MySqlParameter("@vGeneral_Health", Util.GetString(General_Health)));
            cmd.Parameters.Add(new MySqlParameter("@vlife_changes", Util.GetString(life_changes)));
            cmd.Parameters.Add(new MySqlParameter("@vPast_Year", Util.GetString(Past_Year)));
            cmd.Parameters.Add(new MySqlParameter("@vPast_Year_other", Util.GetString(Past_Year_other)));
            cmd.Parameters.Add(new MySqlParameter("@vlatex", Util.GetString(latex)));
            cmd.Parameters.Add(new MySqlParameter("@vadhesive_tape", Util.GetString(adhesive_tape)));
            cmd.Parameters.Add(new MySqlParameter("@vsignificant_allergies", Util.GetString(significant_allergies)));
            cmd.Parameters.Add(new MySqlParameter("@vsignificant_allergies_list", Util.GetString(significant_allergies_list)));
            cmd.Parameters.Add(new MySqlParameter("@vTHERAPY_PRECAUTIONS", Util.GetString(THERAPY_PRECAUTIONS)));
            cmd.Parameters.Add(new MySqlParameter("@vTHERAPY_PRECAUTIONS_other", Util.GetString(THERAPY_PRECAUTIONS_other)));
            cmd.Parameters.Add(new MySqlParameter("@vphysical_problem", Util.GetString(physical_problem)));
            cmd.Parameters.Add(new MySqlParameter("@vDifficulty_with", Util.GetString(Difficulty_with)));
            cmd.Parameters.Add(new MySqlParameter("@vDifficulty_with_walking", Util.GetString(Difficulty_with_walking)));
            cmd.Parameters.Add(new MySqlParameter("@vself_care", Util.GetString(self_care)));
            cmd.Parameters.Add(new MySqlParameter("@vhome_management", Util.GetString(home_management)));
            cmd.Parameters.Add(new MySqlParameter("@vplay_activities", Util.GetString(play_activities)));
            cmd.Parameters.Add(new MySqlParameter("@vneed_to_use", Util.GetString(need_to_use)));
            cmd.Parameters.Add(new MySqlParameter("@vlive", Util.GetString(live)));
            cmd.Parameters.Add(new MySqlParameter("@vlive_Other", Util.GetString(live_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vhome_situation", Util.GetString(home_situation)));
            cmd.Parameters.Add(new MySqlParameter("@vSAFETY_ISSUES", Util.GetString(SAFETY_ISSUES)));
            cmd.Parameters.Add(new MySqlParameter("@vSAFETY_ISSUES_Other", Util.GetString(SAFETY_ISSUES_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vPre_Post_Treatment", Util.GetString(Pre_Post_Treatment)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vChkOtherTherapy", Util.GetString(ChkOtherTherapy))); 
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