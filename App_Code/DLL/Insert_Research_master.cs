using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Research_master
/// </summary>
public class Insert_Research_master
{
	public Insert_Research_master()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}
    public Insert_Research_master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
     #region All Memory Variables

     private string _PatientID;
     private string _TransactionID;
     private string _DoctorID;
     private string _ResearchName;
     private string _TotalScore;
     private string _CreatedBy;
     private int _ResearchID;
     private string _Remarks;
     #endregion

     #region All Global Variables

     MySqlConnection objCon;
     MySqlTransaction objTrans;
     bool IsLocalConn;

     #endregion
     #region Set All Property
     public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
     public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
     public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
     public virtual string TotalScore { get { return _TotalScore; } set { _TotalScore = value; } }
     public virtual string ResearchName { get { return _ResearchName; } set { _ResearchName = value; } }
     public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
     public virtual int ResearchID { get { return _ResearchID; } set { _ResearchID = value; } }
     public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
     #endregion

     #region All Public Member Function
     public string Insert()
     {
         string Output = "";
         try
         {
             StringBuilder objSQL = new StringBuilder();

             objSQL.Append("Researche_master_insert");

             if (IsLocalConn)
             {
                 this.objCon.Open();
                 this.objTrans = this.objCon.BeginTransaction();
             }


             MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
             cmd.CommandType = CommandType.StoredProcedure;

             cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
             cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
             cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
             cmd.Parameters.Add(new MySqlParameter("@vTotalScore", Util.GetString(TotalScore)));
             cmd.Parameters.Add(new MySqlParameter("@vResearchName", Util.GetString(ResearchName)));
             cmd.Parameters.Add(new MySqlParameter("@vcreatedBy", Util.GetString(CreatedBy)));
             cmd.Parameters.Add(new MySqlParameter("@vResearchID", Util.GetInt(ResearchID)));
             cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
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