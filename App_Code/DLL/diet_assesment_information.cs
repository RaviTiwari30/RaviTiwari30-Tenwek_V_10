using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

 

public class diet_assesment_information
{
    public diet_assesment_information()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public diet_assesment_information(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _DietPriorToAdmission;
    private string _PhysicalAppearance;
    private string _NutritionRiskLevel;
    private string _NutritionRx;
    private string _NutritionDiagnosis;
    private string _NutritionalIntervention;
    private string _MonitorEvaluation;
    private string _Anorexia;
    private string _ChewingProblem;
    private string _SwallowingProblem;
    private string _PoorDenition;
    private string _Nauses;
    private string _Vomition;
    private string _Constipation;
    private string _Diarrhea;
    private string _FoodIntolerance;
    private string _PostSurgery;
    private string _Fever;
    private string _Wounds;
    private string _Trauma;
    private string _Sepsis;
    private string _Other;
    private string _EnterBy;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string DietPriorToAdmission { get { return _DietPriorToAdmission; } set { _DietPriorToAdmission = value; } }
    public virtual string PhysicalAppearance { get { return _PhysicalAppearance; } set { _PhysicalAppearance = value; } }
    public virtual string NutritionRiskLevel { get { return _NutritionRiskLevel; } set { _NutritionRiskLevel = value; } }
    public virtual string NutritionRx { get { return _NutritionRx; } set { _NutritionRx = value; } }
    public virtual string NutritionDiagnosis { get { return _NutritionDiagnosis; } set { _NutritionDiagnosis = value; } }
    public virtual string NutritionalIntervention { get { return _NutritionalIntervention; } set { _NutritionalIntervention = value; } }
    public virtual string MonitorEvaluation { get { return _MonitorEvaluation; } set { _MonitorEvaluation = value; } }
    public virtual string Anorexia { get { return _Anorexia; } set { _Anorexia = value; } }
    public virtual string ChewingProblem { get { return _ChewingProblem; } set { _ChewingProblem = value; } }
    public virtual string SwallowingProblem { get { return _SwallowingProblem; } set { _SwallowingProblem = value; } }
    public virtual string PoorDenition { get { return _PoorDenition; } set { _PoorDenition = value; } }
    public virtual string Nauses { get { return _Nauses; } set { _Nauses = value; } }
    public virtual string Vomition { get { return _Vomition; } set { _Vomition = value; } }
    public virtual string Constipation { get { return _Constipation; } set { _Constipation = value; } }
    public virtual string Diarrhea { get { return _Diarrhea; } set { _Diarrhea = value; } }
    public virtual string FoodIntolerance { get { return _FoodIntolerance; } set { _FoodIntolerance = value; } }
    public virtual string PostSurgery { get { return _PostSurgery; } set { _PostSurgery = value; } }
    public virtual string Fever { get { return _Fever; } set { _Fever = value; } }
    public virtual string Wounds { get { return _Wounds; } set { _Wounds = value; } }
    public virtual string Trauma { get { return _Trauma; } set { _Trauma = value; } }
    public virtual string Sepsis { get { return _Sepsis; } set { _Sepsis = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("diet_assesment_information_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vDietPriorToAdmission", Util.GetString(DietPriorToAdmission)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalAppearance", Util.GetString(PhysicalAppearance)));
            cmd.Parameters.Add(new MySqlParameter("@vNutritionRiskLevel", Util.GetString(NutritionRiskLevel)));
            cmd.Parameters.Add(new MySqlParameter("@vNutritionRx", Util.GetString(NutritionRx)));
            cmd.Parameters.Add(new MySqlParameter("@vNutritionDiagnosis", Util.GetString(NutritionDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vNutritionalIntervention", Util.GetString(NutritionalIntervention)));
            cmd.Parameters.Add(new MySqlParameter("@vMonitorEvaluation", Util.GetString(MonitorEvaluation)));
            cmd.Parameters.Add(new MySqlParameter("@vAnorexia", Util.GetString(Anorexia)));
            cmd.Parameters.Add(new MySqlParameter("@vChewingProblem", Util.GetString(ChewingProblem)));
            cmd.Parameters.Add(new MySqlParameter("@vSwallowingProblem", Util.GetString(SwallowingProblem)));
            cmd.Parameters.Add(new MySqlParameter("@vPoorDenition", Util.GetString(PoorDenition)));
            cmd.Parameters.Add(new MySqlParameter("@vNauses", Util.GetString(Nauses)));
            cmd.Parameters.Add(new MySqlParameter("@vVomition", Util.GetString(Vomition)));
            cmd.Parameters.Add(new MySqlParameter("@vConstipation", Util.GetString(Constipation)));
            cmd.Parameters.Add(new MySqlParameter("@vDiarrhea", Util.GetString(Diarrhea)));
            cmd.Parameters.Add(new MySqlParameter("@vFoodIntolerance", Util.GetString(FoodIntolerance)));
            cmd.Parameters.Add(new MySqlParameter("@vPostSurgery", Util.GetString(PostSurgery)));
            cmd.Parameters.Add(new MySqlParameter("@vFever", Util.GetString(Fever)));
            cmd.Parameters.Add(new MySqlParameter("@vWounds", Util.GetString(Wounds)));
            cmd.Parameters.Add(new MySqlParameter("@vTrauma", Util.GetString(Trauma)));
            cmd.Parameters.Add(new MySqlParameter("@vSepsis", Util.GetString(Sepsis)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));

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
