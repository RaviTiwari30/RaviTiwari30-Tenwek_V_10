using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_soap_tkr  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/6/2014 2:59:55 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_soap_tkr table 
/// ========================================================================================== 
/// </summary>  

public class physio_soap_tkr
{
    public physio_soap_tkr()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_soap_tkr(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private DateTime _Date;
    private string _Time;
    private string _Pain_Scale;
    private int _ChkNo;
    private string _TxtCo;
    private string _Incision;
    private string _INR;
    private string _INRRadio;
    private string _Lines;
    private string _Other;
    private string _LeStrength;
    private string _Prevention;
    private string _Patient_completes;
    private string _Rep;
    private string _Freq;
    private string _Knee_Flexion;
    private string _Knee_Extension;
    private string _Knee_ROM_Right;
    private string _degrees_Left;
    private string _Supine;
    private string _Sit;
    private string _Ambulates_with;
    private string _Assist;
    private string _Unassisted;
    private string _ExerciseProgram;
    private string _PatientPrevention;
    private string _SLR;
    private string _Reps;
    private string _Assessment;
    private string _Addendum;
    private string _Plan;
    private string _CreatedBy;


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
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual int ChkNo { get { return _ChkNo; } set { _ChkNo = value; } }
    public virtual string TxtCo { get { return _TxtCo; } set { _TxtCo = value; } }
    public virtual string Incision { get { return _Incision; } set { _Incision = value; } }
    public virtual string INR { get { return _INR; } set { _INR = value; } }
    public virtual string INRRadio { get { return _INRRadio; } set { _INRRadio = value; } }
    public virtual string Lines { get { return _Lines; } set { _Lines = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string LeStrength { get { return _LeStrength; } set { _LeStrength = value; } }
    public virtual string Prevention { get { return _Prevention; } set { _Prevention = value; } }
    public virtual string Patient_completes { get { return _Patient_completes; } set { _Patient_completes = value; } }
    public virtual string Rep { get { return _Rep; } set { _Rep = value; } }
    public virtual string Freq { get { return _Freq; } set { _Freq = value; } }
    public virtual string Knee_Flexion { get { return _Knee_Flexion; } set { _Knee_Flexion = value; } }
    public virtual string Knee_Extension { get { return _Knee_Extension; } set { _Knee_Extension = value; } }
    public virtual string Knee_ROM_Right { get { return _Knee_ROM_Right; } set { _Knee_ROM_Right = value; } }
    public virtual string degrees_Left { get { return _degrees_Left; } set { _degrees_Left = value; } }
    public virtual string Supine { get { return _Supine; } set { _Supine = value; } }
    public virtual string Sit { get { return _Sit; } set { _Sit = value; } }
    public virtual string Ambulates_with { get { return _Ambulates_with; } set { _Ambulates_with = value; } }
    public virtual string Assist { get { return _Assist; } set { _Assist = value; } }
    public virtual string Unassisted { get { return _Unassisted; } set { _Unassisted = value; } }
    public virtual string ExerciseProgram { get { return _ExerciseProgram; } set { _ExerciseProgram = value; } }
    public virtual string PatientPrevention { get { return _PatientPrevention; } set { _PatientPrevention = value; } }
    public virtual string SLR { get { return _SLR; } set { _SLR = value; } }
    public virtual string Reps { get { return _Reps; } set { _Reps = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Addendum { get { return _Addendum; } set { _Addendum = value; } }
    public virtual string Plan { get { return _Plan; } set { _Plan = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }


    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_soap_tkr_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vChkNo", Util.GetInt(ChkNo)));
            cmd.Parameters.Add(new MySqlParameter("@vTxtCo", Util.GetString(TxtCo)));
            cmd.Parameters.Add(new MySqlParameter("@vIncision", Util.GetString(Incision)));
            cmd.Parameters.Add(new MySqlParameter("@vINR", Util.GetString(INR)));
            cmd.Parameters.Add(new MySqlParameter("@vINRRadio", Util.GetString(INRRadio)));
            cmd.Parameters.Add(new MySqlParameter("@vLines", Util.GetString(Lines)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vLeStrength", Util.GetString(LeStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vPrevention", Util.GetString(Prevention)));
            cmd.Parameters.Add(new MySqlParameter("@vPatient_completes", Util.GetString(Patient_completes)));
            cmd.Parameters.Add(new MySqlParameter("@vRep", Util.GetString(Rep)));
            cmd.Parameters.Add(new MySqlParameter("@vFreq", Util.GetString(Freq)));
            cmd.Parameters.Add(new MySqlParameter("@vKnee_Flexion", Util.GetString(Knee_Flexion)));
            cmd.Parameters.Add(new MySqlParameter("@vKnee_Extension", Util.GetString(Knee_Extension)));
            cmd.Parameters.Add(new MySqlParameter("@vKnee_ROM_Right", Util.GetString(Knee_ROM_Right)));
            cmd.Parameters.Add(new MySqlParameter("@vdegrees_Left", Util.GetString(degrees_Left)));
            cmd.Parameters.Add(new MySqlParameter("@vSupine", Util.GetString(Supine)));
            cmd.Parameters.Add(new MySqlParameter("@vSit", Util.GetString(Sit)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbulates_with", Util.GetString(Ambulates_with)));
            cmd.Parameters.Add(new MySqlParameter("@vAssist", Util.GetString(Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vUnassisted", Util.GetString(Unassisted)));
            cmd.Parameters.Add(new MySqlParameter("@vExerciseProgram", Util.GetString(ExerciseProgram)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientPrevention", Util.GetString(PatientPrevention)));
            cmd.Parameters.Add(new MySqlParameter("@vSLR", Util.GetString(SLR)));
            cmd.Parameters.Add(new MySqlParameter("@vReps", Util.GetString(Reps)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vAddendum", Util.GetString(Addendum)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan", Util.GetString(Plan)));
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
