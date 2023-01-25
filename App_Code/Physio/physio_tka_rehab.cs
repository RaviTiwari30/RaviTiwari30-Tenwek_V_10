using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_tka_rehab  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/5/2014 4:56:11 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_tka_rehab table 
/// ========================================================================================== 
/// </summary>  

public class physio_tka_rehab
{
    public physio_tka_rehab()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_tka_rehab(MySqlTransaction objTrans)
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
    private DateTime _TKROn;
    private DateTime _Referred_Date;
    private string _Referred_Dr;
    private string _TKRProtocol;
    private string _PMH;
    private string _PSH;
    private string _Prior_Level_Other;
    private string _Meds;
    private string _Drains;
    private string _INR;
    private string _lncision;
    private string _Pain_Scale;
    private string _Patientwilling;
    private string _Mental;
    private string _Barriers;
    private string _Barrierscomments;
    private string _UEStrength;
    private string _LEStrength;
    private string _LESensation;
    private string _FNB;
    private string _Patientinstructed;
    private string _Reps;
    private string _Freq;
    private string _Patientdemonstrates;
    private string _Surgery;
    private string _Supine;
    private string _Dangled;
    private string _Sit;
    private string _Ambwith;
    private string _Ftwith;
    private string _AAROM;
    private string _Right_Ext;
    private string _Right_Flexion;
    private string _Left_Ext;
    private string _Left_Flexion;
    private string _CPM;
    private string _Knee;
    private string _Rate;
    private string _Assessment;
    private string _independent;
    private string _Transfers;
    private string _Independentambulation;
    private string _Ascend;
    private string _Plan_Other;
    private string _CreatedBy;

    private string _UpdatedBy;
    private DateTime _UpdatedDate;
    private string _STG1;
    private string _STG2;
    private string _STG3;
    private string _LTG1;
    private string _LTG2;
    private string _LTG3;
    private string _LTG4;
    private string _LTG5;
    private string _Plan1;
    private string _Plan2;
    private string _Plan3;
    private string _Plan4;
    private string _Plan5;







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
    public virtual DateTime TKROn { get { return _TKROn; } set { _TKROn = value; } }
    public virtual DateTime Referred_Date { get { return _Referred_Date; } set { _Referred_Date = value; } }
    public virtual string Referred_Dr { get { return _Referred_Dr; } set { _Referred_Dr = value; } }
    public virtual string TKRProtocol { get { return _TKRProtocol; } set { _TKRProtocol = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string Prior_Level_Other { get { return _Prior_Level_Other; } set { _Prior_Level_Other = value; } }
    public virtual string Meds { get { return _Meds; } set { _Meds = value; } }
    public virtual string Drains { get { return _Drains; } set { _Drains = value; } }
    public virtual string INR { get { return _INR; } set { _INR = value; } }
    public virtual string lncision { get { return _lncision; } set { _lncision = value; } }
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual string Patientwilling { get { return _Patientwilling; } set { _Patientwilling = value; } }
    public virtual string Mental { get { return _Mental; } set { _Mental = value; } }
    public virtual string Barriers { get { return _Barriers; } set { _Barriers = value; } }
    public virtual string Barrierscomments { get { return _Barrierscomments; } set { _Barrierscomments = value; } }
    public virtual string UEStrength { get { return _UEStrength; } set { _UEStrength = value; } }
    public virtual string LEStrength { get { return _LEStrength; } set { _LEStrength = value; } }
    public virtual string LESensation { get { return _LESensation; } set { _LESensation = value; } }
    public virtual string FNB { get { return _FNB; } set { _FNB = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Reps { get { return _Reps; } set { _Reps = value; } }
    public virtual string Freq { get { return _Freq; } set { _Freq = value; } }
    public virtual string Patientdemonstrates { get { return _Patientdemonstrates; } set { _Patientdemonstrates = value; } }
    public virtual string Surgery { get { return _Surgery; } set { _Surgery = value; } }
    public virtual string Supine { get { return _Supine; } set { _Supine = value; } }
    public virtual string Dangled { get { return _Dangled; } set { _Dangled = value; } }
    public virtual string Sit { get { return _Sit; } set { _Sit = value; } }
    public virtual string Ambwith { get { return _Ambwith; } set { _Ambwith = value; } }
    public virtual string Ftwith { get { return _Ftwith; } set { _Ftwith = value; } }
    public virtual string AAROM { get { return _AAROM; } set { _AAROM = value; } }
    public virtual string Right_Ext { get { return _Right_Ext; } set { _Right_Ext = value; } }
    public virtual string Right_Flexion { get { return _Right_Flexion; } set { _Right_Flexion = value; } }
    public virtual string Left_Ext { get { return _Left_Ext; } set { _Left_Ext = value; } }
    public virtual string Left_Flexion { get { return _Left_Flexion; } set { _Left_Flexion = value; } }
    public virtual string CPM { get { return _CPM; } set { _CPM = value; } }
    public virtual string Knee { get { return _Knee; } set { _Knee = value; } }
    public virtual string Rate { get { return _Rate; } set { _Rate = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string independent { get { return _independent; } set { _independent = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Independentambulation { get { return _Independentambulation; } set { _Independentambulation = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual string Plan_Other { get { return _Plan_Other; } set { _Plan_Other = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }

    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

    public virtual string STG1 { get { return _STG1; } set { _STG1 = value; } }
    public virtual string STG2 { get { return _STG2; } set { _STG2 = value; } }
    public virtual string STG3 { get { return _STG3; } set { _STG3 = value; } }
    public virtual string LTG1 { get { return _LTG1; } set { _LTG1 = value; } }
    public virtual string LTG2 { get { return _LTG2; } set { _LTG2 = value; } }
    public virtual string LTG3 { get { return _LTG3; } set { _LTG3 = value; } }
    public virtual string LTG4 { get { return _LTG4; } set { _LTG4 = value; } }
    public virtual string LTG5 { get { return _LTG5; } set { _LTG5 = value; } }
    public virtual string Plan1 { get { return _Plan1; } set { _Plan1 = value; } }
    public virtual string Plan2 { get { return _Plan2; } set { _Plan2 = value; } }
    public virtual string Plan3 { get { return _Plan3; } set { _Plan3 = value; } }
    public virtual string Plan4 { get { return _Plan4; } set { _Plan4 = value; } }
    public virtual string Plan5 { get { return _Plan5; } set { _Plan5 = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_tka_rehab_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vTKROn", Util.GetDateTime(TKROn)));
            cmd.Parameters.Add(new MySqlParameter("@vReferred_Date", Util.GetDateTime(Referred_Date)));
            cmd.Parameters.Add(new MySqlParameter("@vReferred_Dr", Util.GetString(Referred_Dr)));
            cmd.Parameters.Add(new MySqlParameter("@vTKRProtocol", Util.GetString(TKRProtocol)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vPrior_Level_Other", Util.GetString(Prior_Level_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vMeds", Util.GetString(Meds)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vINR", Util.GetString(INR)));
            cmd.Parameters.Add(new MySqlParameter("@vlncision", Util.GetString(lncision)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientwilling", Util.GetString(Patientwilling)));
            cmd.Parameters.Add(new MySqlParameter("@vMental", Util.GetString(Mental)));
            cmd.Parameters.Add(new MySqlParameter("@vBarriers", Util.GetString(Barriers)));
            cmd.Parameters.Add(new MySqlParameter("@vBarrierscomments", Util.GetString(Barrierscomments)));
            cmd.Parameters.Add(new MySqlParameter("@vUEStrength", Util.GetString(UEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vLEStrength", Util.GetString(LEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vLESensation", Util.GetString(LESensation)));
            cmd.Parameters.Add(new MySqlParameter("@vFNB", Util.GetString(FNB)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vReps", Util.GetString(Reps)));
            cmd.Parameters.Add(new MySqlParameter("@vFreq", Util.GetString(Freq)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientdemonstrates", Util.GetString(Patientdemonstrates)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vSupine", Util.GetString(Supine)));
            cmd.Parameters.Add(new MySqlParameter("@vDangled", Util.GetString(Dangled)));
            cmd.Parameters.Add(new MySqlParameter("@vSit", Util.GetString(Sit)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbwith", Util.GetString(Ambwith)));
            cmd.Parameters.Add(new MySqlParameter("@vFtwith", Util.GetString(Ftwith)));
            cmd.Parameters.Add(new MySqlParameter("@vAAROM", Util.GetString(AAROM)));
            cmd.Parameters.Add(new MySqlParameter("@vRight_Ext", Util.GetString(Right_Ext)));
            cmd.Parameters.Add(new MySqlParameter("@vRight_Flexion", Util.GetString(Right_Flexion)));
            cmd.Parameters.Add(new MySqlParameter("@vLeft_Ext", Util.GetString(Left_Ext)));
            cmd.Parameters.Add(new MySqlParameter("@vLeft_Flexion", Util.GetString(Left_Flexion)));
            cmd.Parameters.Add(new MySqlParameter("@vCPM", Util.GetString(CPM)));
            cmd.Parameters.Add(new MySqlParameter("@vKnee", Util.GetString(Knee)));
            cmd.Parameters.Add(new MySqlParameter("@vRate", Util.GetString(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vindependent", Util.GetString(independent)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vIndependentambulation", Util.GetString(Independentambulation)));
            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan_Other", Util.GetString(Plan_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));

            cmd.Parameters.Add(new MySqlParameter("@vSTG1", Util.GetString(STG1)));
            cmd.Parameters.Add(new MySqlParameter("@vSTG2", Util.GetString(STG2)));
            cmd.Parameters.Add(new MySqlParameter("@vSTG3", Util.GetString(STG3)));
            cmd.Parameters.Add(new MySqlParameter("@vLTG1", Util.GetString(LTG1)));
            cmd.Parameters.Add(new MySqlParameter("@vLTG2", Util.GetString(LTG2)));
            cmd.Parameters.Add(new MySqlParameter("@vLTG3", Util.GetString(LTG3)));
            cmd.Parameters.Add(new MySqlParameter("@vLTG4", Util.GetString(LTG4)));
            cmd.Parameters.Add(new MySqlParameter("@vLTG5", Util.GetString(LTG5)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan1", Util.GetString(Plan1)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan2", Util.GetString(Plan2)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan3", Util.GetString(Plan3)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan4", Util.GetString(Plan4)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan5", Util.GetString(Plan5)));


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
