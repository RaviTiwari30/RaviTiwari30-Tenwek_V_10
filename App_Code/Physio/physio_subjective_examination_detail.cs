using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_subjective_examination_detail  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:              RAHUL 
/// Create date:	3/29/2014 6:27:13 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_subjective_examination_detail table 
/// ========================================================================================== 
/// </summary>  

public class physio_subjective_examination_detail
{
    public physio_subjective_examination_detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_subjective_examination_detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Handedness;
    private string _Occupation;
    private string _ChiefComplaints;
    private string _ReferedBy;
    private string _OtherDoctor;
    private string _PastMedicalHistory;
    private string _OtherOngoingTreatment;
    private string _PastPhysioTreatment;
    private string _BowelControl;
    private string _SocialSituation;
    private string _Investigations;
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
    public virtual string Handedness { get { return _Handedness; } set { _Handedness = value; } }
    public virtual string Occupation { get { return _Occupation; } set { _Occupation = value; } }
    public virtual string ChiefComplaints { get { return _ChiefComplaints; } set { _ChiefComplaints = value; } }
    public virtual string ReferedBy { get { return _ReferedBy; } set { _ReferedBy = value; } }
    public virtual string OtherDoctor { get { return _OtherDoctor; } set { _OtherDoctor = value; } }
    public virtual string PastMedicalHistory { get { return _PastMedicalHistory; } set { _PastMedicalHistory = value; } }
    public virtual string OtherOngoingTreatment { get { return _OtherOngoingTreatment; } set { _OtherOngoingTreatment = value; } }
    public virtual string PastPhysioTreatment { get { return _PastPhysioTreatment; } set { _PastPhysioTreatment = value; } }
    public virtual string BowelControl { get { return _BowelControl; } set { _BowelControl = value; } }
    public virtual string SocialSituation { get { return _SocialSituation; } set { _SocialSituation = value; } }
    public virtual string Investigations { get { return _Investigations; } set { _Investigations = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_subjective_examination_detail_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vHandedness", Util.GetString(Handedness)));
            cmd.Parameters.Add(new MySqlParameter("@vOccupation", Util.GetString(Occupation)));
            cmd.Parameters.Add(new MySqlParameter("@vChiefComplaints", Util.GetString(ChiefComplaints)));
            cmd.Parameters.Add(new MySqlParameter("@vReferedBy", Util.GetString(ReferedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherDoctor", Util.GetString(OtherDoctor)));
            cmd.Parameters.Add(new MySqlParameter("@vPastMedicalHistory", Util.GetString(PastMedicalHistory)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherOngoingTreatment", Util.GetString(OtherOngoingTreatment)));
            cmd.Parameters.Add(new MySqlParameter("@vPastPhysioTreatment", Util.GetString(PastPhysioTreatment)));
            cmd.Parameters.Add(new MySqlParameter("@vBowelControl", Util.GetString(BowelControl)));
            cmd.Parameters.Add(new MySqlParameter("@vSocialSituation", Util.GetString(SocialSituation)));
            cmd.Parameters.Add(new MySqlParameter("@vInvestigations", Util.GetString(Investigations)));
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
