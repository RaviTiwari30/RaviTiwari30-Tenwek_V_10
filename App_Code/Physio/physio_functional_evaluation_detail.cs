using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for physio_functional_evaluation_detail  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:              RAHUL 
/// Create date:	3/29/2014 6:32:11 PM 
/// Description:	This class is intended for inserting, updating, deleting values for physio_functional_evaluation_detail table 
/// ========================================================================================== 
/// </summary>  

public class physio_functional_evaluation_detail
{
    public physio_functional_evaluation_detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public physio_functional_evaluation_detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Feeding;
    private string _Toileting;
    private string _Combing;
    private string _TreatmentPlan;
    private string _ProblemListing;
    private string _Drinking;
    private string _Bathing;
    private string _Diagnosis;
    private string _Goals;
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
    public virtual string Feeding { get { return _Feeding; } set { _Feeding = value; } }
    public virtual string Toileting { get { return _Toileting; } set { _Toileting = value; } }
    public virtual string Combing { get { return _Combing; } set { _Combing = value; } }
    public virtual string TreatmentPlan { get { return _TreatmentPlan; } set { _TreatmentPlan = value; } }
    public virtual string ProblemListing { get { return _ProblemListing; } set { _ProblemListing = value; } }
    public virtual string Drinking { get { return _Drinking; } set { _Drinking = value; } }
    public virtual string Bathing { get { return _Bathing; } set { _Bathing = value; } }
    public virtual string Diagnosis { get { return _Diagnosis; } set { _Diagnosis = value; } }
    public virtual string Goals { get { return _Goals; } set { _Goals = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("physio_functional_evaluation_detail_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vFeeding", Util.GetString(Feeding)));
            cmd.Parameters.Add(new MySqlParameter("@vToileting", Util.GetString(Toileting)));
            cmd.Parameters.Add(new MySqlParameter("@vCombing", Util.GetString(Combing)));
            cmd.Parameters.Add(new MySqlParameter("@vTreatmentPlan", Util.GetString(TreatmentPlan)));
            cmd.Parameters.Add(new MySqlParameter("@vProblemListing", Util.GetString(ProblemListing)));
            cmd.Parameters.Add(new MySqlParameter("@vDrinking", Util.GetString(Drinking)));
            cmd.Parameters.Add(new MySqlParameter("@vBathing", Util.GetString(Bathing)));
            cmd.Parameters.Add(new MySqlParameter("@vDiagnosis", Util.GetString(Diagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vGoals", Util.GetString(Goals)));
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
