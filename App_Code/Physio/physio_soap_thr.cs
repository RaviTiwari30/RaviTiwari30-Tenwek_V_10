using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_soap_thr  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	3/6/2014 3:03:44 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_soap_thr table 
/// ========================================================================================== 
/// </summary>  

public class physio_soap_thr
{
    public physio_soap_thr()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_soap_thr(MySqlTransaction objTrans)
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
    private string _Lines;
    private string _Other;
    private string _Patient_verbalizes;
    private string _Prevention;
    private string _Ascend;
    private string _Steps;
    private string _StepsAssist;
    private string _PatientUnable;
    private string _Supine;
    private string _Sit;
    private string _Amb_with;
    private string _Assist;
    private string _Home;
    private string _Patientdemonstrates;
    private string _Rep;
    private string _Freq;
    private string _Assessment;
    private string _Addendum;
    private string _Plan;
    private string _CreatedBy;
    private int _Patient;
    private int _ADLvideo;

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
    public virtual string Lines { get { return _Lines; } set { _Lines = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string Patient_verbalizes { get { return _Patient_verbalizes; } set { _Patient_verbalizes = value; } }
    public virtual string Prevention { get { return _Prevention; } set { _Prevention = value; } }
    public virtual string Ascend { get { return _Ascend; } set { _Ascend = value; } }
    public virtual string Steps { get { return _Steps; } set { _Steps = value; } }
    public virtual string StepsAssist { get { return _StepsAssist; } set { _StepsAssist = value; } }
    public virtual string PatientUnable { get { return _PatientUnable; } set { _PatientUnable = value; } }
    public virtual string Supine { get { return _Supine; } set { _Supine = value; } }
    public virtual string Sit { get { return _Sit; } set { _Sit = value; } }
    public virtual string Amb_with { get { return _Amb_with; } set { _Amb_with = value; } }
    public virtual string Assist { get { return _Assist; } set { _Assist = value; } }
    public virtual string Home { get { return _Home; } set { _Home = value; } }
    public virtual string Patientdemonstrates { get { return _Patientdemonstrates; } set { _Patientdemonstrates = value; } }
    public virtual string Rep { get { return _Rep; } set { _Rep = value; } }
    public virtual string Freq { get { return _Freq; } set { _Freq = value; } }
    public virtual string Assessment { get { return _Assessment; } set { _Assessment = value; } }
    public virtual string Addendum { get { return _Addendum; } set { _Addendum = value; } }
    public virtual string Plan { get { return _Plan; } set { _Plan = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual int Patient { get { return _Patient; } set { _Patient = value; } }
    public virtual int ADLvideo { get { return _ADLvideo; } set { _ADLvideo = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_soap_thr_insert");

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
            cmd.Parameters.Add(new MySqlParameter("@vLines", Util.GetString(Lines)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vPatient_verbalizes", Util.GetString(Patient_verbalizes)));
            cmd.Parameters.Add(new MySqlParameter("@vPrevention", Util.GetString(Prevention)));

            cmd.Parameters.Add(new MySqlParameter("@vAscend", Util.GetString(Ascend)));
            cmd.Parameters.Add(new MySqlParameter("@vSteps", Util.GetString(Steps)));
            cmd.Parameters.Add(new MySqlParameter("@vStepsAssist", Util.GetString(StepsAssist)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientUnable", Util.GetString(PatientUnable)));

            cmd.Parameters.Add(new MySqlParameter("@vSupine", Util.GetString(Supine)));
            cmd.Parameters.Add(new MySqlParameter("@vSit", Util.GetString(Sit)));
            cmd.Parameters.Add(new MySqlParameter("@vAmb_with", Util.GetString(Amb_with)));
            cmd.Parameters.Add(new MySqlParameter("@vAssist", Util.GetString(Assist)));
            cmd.Parameters.Add(new MySqlParameter("@vHome", Util.GetString(Home)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientdemonstrates", Util.GetString(Patientdemonstrates)));
            cmd.Parameters.Add(new MySqlParameter("@vRep", Util.GetString(Rep)));
            cmd.Parameters.Add(new MySqlParameter("@vFreq", Util.GetString(Freq)));
            cmd.Parameters.Add(new MySqlParameter("@vAssessment", Util.GetString(Assessment)));
            cmd.Parameters.Add(new MySqlParameter("@vAddendum", Util.GetString(Addendum)));
            cmd.Parameters.Add(new MySqlParameter("@vPlan", Util.GetString(Plan)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vPatient", Util.GetInt(Patient)));
            cmd.Parameters.Add(new MySqlParameter("@vADLvideo", Util.GetInt(ADLvideo)));

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
