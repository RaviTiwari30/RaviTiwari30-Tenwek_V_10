using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_thr_rehab  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/5/2014 3:19:57 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_thr_rehab table 
/// ========================================================================================== 
/// </summary>  

public class physio_thr_rehab
{
    public physio_thr_rehab()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_thr_rehab(MySqlTransaction objTrans)
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
    private DateTime _Referred_Date;
    private string _Referred_Dr;
    private string _For_THR;
    private string _PMH;
    private string _PSH;
    private string _Meds;
    private string _Prior_Level;
    private string _Other;
    private string _Lines;
    private string _LinesOther;
    private string _Pain_Scale;
    private string _Mental;
    private string _Patientwilling;
    private string _Barriers;
    private string _Barrierscomments;
    private string _UEStrength;
    private string _LEStrengthR;
    private string _LEStrengthL;
    private string _LESensation;
    private string _Patientinstructed;
    private string _Surgery;
    private string _Patientinstructedin;
    private string _Demonstrates;
    private string _Supine;
    private string _Dangled;
    private string _Sit;
    private string _Ambwith;
    private string _WBAT;
    private string _With_assist;
    private string _Assessment;
    private string _Transfers;
    private string _Assist;
    private string _UnAssist;
    private string _Amb;
    private string _Ftwith;
    private string _levelsurfaces;
    private string _Amb_Assist;
    private string _Amb_UnAssist;
    private string _Ascend;
    private string _Plan_Other;
    private string _CreatedBy;
    private string _UpdatedBy;
    private DateTime _UpdatedDate;
    private string _Plan1;
    private string _Plan2;
    private string _Plan3;
    private string _Plan4;



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
    public virtual DateTime Referred_Date { get { return _Referred_Date; } set { _Referred_Date = value; } }
    public virtual string Referred_Dr { get { return _Referred_Dr; } set { _Referred_Dr = value; } }
    public virtual string For_THR { get { return _For_THR; } set { _For_THR = value; } }
    public virtual string PMH { get { return _PMH; } set { _PMH = value; } }
    public virtual string PSH { get { return _PSH; } set { _PSH = value; } }
    public virtual string Meds { get { return _Meds; } set { _Meds = value; } }
    public virtual string Prior_Level { get { return _Prior_Level; } set { _Prior_Level = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string Lines { get { return _Lines; } set { _Lines = value; } }
    public virtual string LinesOther { get { return _LinesOther; } set { _LinesOther = value; } }
    public virtual string Pain_Scale { get { return _Pain_Scale; } set { _Pain_Scale = value; } }
    public virtual string Mental { get { return _Mental; } set { _Mental = value; } }
    public virtual string Patientwilling { get { return _Patientwilling; } set { _Patientwilling = value; } }
    public virtual string Barriers { get { return _Barriers; } set { _Barriers = value; } }
    public virtual string Barrierscomments { get { return _Barrierscomments; } set { _Barrierscomments = value; } }
    public virtual string UEStrength { get { return _UEStrength; } set { _UEStrength = value; } }
    public virtual string LEStrengthR { get { return _LEStrengthR; } set { _LEStrengthR = value; } }
    public virtual string LEStrengthL { get { return _LEStrengthL; } set { _LEStrengthL = value; } }
    public virtual string LESensation { get { return _LESensation; } set { _LESensation = value; } }
    public virtual string Patientinstructed { get { return _Patientinstructed; } set { _Patientinstructed = value; } }
    public virtual string Surgery { get { return _Surgery; } set { _Surgery = value; } }
    public virtual string Patientinstructedin { get { return _Patientinstructedin; } set { _Patientinstructedin = value; } }
    public virtual string Demonstrates { get { return _Demonstrates; } set { _Demonstrates = value; } }
    public virtual string Supine { get { return _Supine; } set { _Supine = value; } }
    public virtual string Dangled { get { return _Dangled; } set { _Dangled = value; } }
    public virtual string Sit { get { return _Sit; } set { _Sit = value; } }
    public virtual string Ambwith { get { return _Ambwith; } set { _Ambwith = value; } }
    public virtual string WBAT { get { return _WBAT; } set { _WBAT = value; } }
    public virtual string With_assist { get { return _With_assist; } set { _With_assist = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Transfers { get { return _Transfers; } set { _Transfers = value; } }
    public virtual string Assist { get { return _Assist; } set { _Assist = value; } }
    public virtual string UnAssist { get { return _UnAssist; } set { _UnAssist = value; } }
    public virtual string Amb { get { return _Amb; } set { _Amb = value; } }
    public virtual string Ftwith { get { return _Ftwith; } set { _Ftwith = value; } }
    public virtual string levelsurfaces { get { return _levelsurfaces; } set { _levelsurfaces = value; } }
    public virtual string Amb_Assist { get { return _Amb_Assist; } set { _Amb_Assist = value; } }
    public virtual string Amb_UnAssist { get { return _Amb_UnAssist; } set { _Amb_UnAssist = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual string Plan_Other { get { return _Plan_Other; } set { _Plan_Other = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

    public virtual string Plan1 { get { return _Plan1; } set { _Plan1 = value; } }
    public virtual string Plan2 { get { return _Plan2; } set { _Plan2 = value; } }
    public virtual string Plan3 { get { return _Plan3; } set { _Plan3 = value; } }
    public virtual string Plan4 { get { return _Plan4; } set { _Plan4 = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_thr_rehab_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vReferred_Date", Util.GetDateTime(Referred_Date)));
            cmd.Parameters.Add(new MySqlParameter("@vReferred_Dr", Util.GetString(Referred_Dr)));
            cmd.Parameters.Add(new MySqlParameter("@vFor_THR", Util.GetString(For_THR)));
            cmd.Parameters.Add(new MySqlParameter("@vPMH", Util.GetString(PMH)));
            cmd.Parameters.Add(new MySqlParameter("@vPSH", Util.GetString(PSH)));
            cmd.Parameters.Add(new MySqlParameter("@vMeds", Util.GetString(Meds)));
            cmd.Parameters.Add(new MySqlParameter("@vPrior_Level", Util.GetString(Prior_Level)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vLines", Util.GetString(Lines)));
            cmd.Parameters.Add(new MySqlParameter("@vLinesOther", Util.GetString(LinesOther)));
            cmd.Parameters.Add(new MySqlParameter("@vPain_Scale", Util.GetString(Pain_Scale)));
            cmd.Parameters.Add(new MySqlParameter("@vMental", Util.GetString(Mental)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientwilling", Util.GetString(Patientwilling)));
            cmd.Parameters.Add(new MySqlParameter("@vBarriers", Util.GetString(Barriers)));
            cmd.Parameters.Add(new MySqlParameter("@vBarrierscomments", Util.GetString(Barrierscomments)));
            cmd.Parameters.Add(new MySqlParameter("@vUEStrength", Util.GetString(UEStrength)));
            cmd.Parameters.Add(new MySqlParameter("@vLEStrengthR", Util.GetString(LEStrengthR)));
            cmd.Parameters.Add(new MySqlParameter("@vLEStrengthL", Util.GetString(LEStrengthL)));
            cmd.Parameters.Add(new MySqlParameter("@vLESensation", Util.GetString(LESensation)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructed", Util.GetString(Patientinstructed)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgery", Util.GetString(Surgery)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientinstructedin", Util.GetString(Patientinstructedin)));
            cmd.Parameters.Add(new MySqlParameter("@vDemonstrates", Util.GetString(Demonstrates)));
            cmd.Parameters.Add(new MySqlParameter("@vSupine", Util.GetString(Supine)));
            cmd.Parameters.Add(new MySqlParameter("@vDangled", Util.GetString(Dangled)));
            cmd.Parameters.Add(new MySqlParameter("@vSit", Util.GetString(Sit)));
            cmd.Parameters.Add(new MySqlParameter("@vAmbwith", Util.GetString(Ambwith)));
            cmd.Parameters.Add(new MySqlParameter("@vWBAT", Util.GetString(WBAT)));
            cmd.Parameters.Add(new MySqlParameter("@vWith_assist", Util.GetString(With_assist)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vTransfers", Util.GetString(Transfers)));
            cmd.Parameters.Add(new MySqlParameter("@vAssist", Util.GetString(Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vUnAssist", Util.GetString(UnAssist)));
            cmd.Parameters.Add(new MySqlParameter("@vAmb", Util.GetString(Amb)));
            cmd.Parameters.Add(new MySqlParameter("@vFtwith", Util.GetString(Ftwith)));
            cmd.Parameters.Add(new MySqlParameter("@vlevelsurfaces", Util.GetString(levelsurfaces)));
            cmd.Parameters.Add(new MySqlParameter("@vAmb_Assist", Util.GetString(Amb_Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vAmb_UnAssist", Util.GetString(Amb_UnAssist)));
            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan_Other", Util.GetString(Plan_Other)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));

            cmd.Parameters.Add(new MySqlParameter("@vPlan1", Util.GetString(Plan1)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan2", Util.GetString(Plan2)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan3", Util.GetString(Plan3)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan4", Util.GetString(Plan4)));


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
