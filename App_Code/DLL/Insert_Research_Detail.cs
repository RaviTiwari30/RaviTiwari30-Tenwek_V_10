using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Insert_Research_Detail
/// </summary>
public class Insert_Research_Detail
{
	public Insert_Research_Detail()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}
    public Insert_Research_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
     #region All Memory Variables
     private int _ReferenceID;
     private string _TransactionID;
     private string _Questions;
     private string _Answer;
     private decimal _Score;
     private string _SubTotal;
     private string _CreatedBy;
     #endregion

     #region All Global Variables

     MySqlConnection objCon;
     MySqlTransaction objTrans;
     bool IsLocalConn;

     #endregion
     #region Set All Property
     public virtual int ReferenceID { get { return _ReferenceID; } set { _ReferenceID = value; } }
     public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
     public virtual string Questions { get { return _Questions; } set { _Questions = value; } }
     public virtual string Answer { get { return _Answer; } set { _Answer = value; } }
     public virtual decimal Score { get { return _Score; } set { _Score = value; } }
     public virtual string SubTotal { get { return _SubTotal; } set { _SubTotal = value; } }
     public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
     #endregion

     #region All Public Member Function
     public string Insert()
     {
         string Output = "";
         try
         {
             StringBuilder objSQL = new StringBuilder();

             objSQL.Append("research_Detail_insert");

             if (IsLocalConn)
             {
                 this.objCon.Open();
                 this.objTrans = this.objCon.BeginTransaction();
             }


             MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
             cmd.CommandType = CommandType.StoredProcedure;

             cmd.Parameters.Add(new MySqlParameter("@vReferenceID", Util.GetInt(ReferenceID)));
             cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
             cmd.Parameters.Add(new MySqlParameter("@vQuestions", Util.GetString(Questions)));
             cmd.Parameters.Add(new MySqlParameter("@vAnswer", Util.GetString(Answer)));
             cmd.Parameters.Add(new MySqlParameter("@vScore", Util.GetDecimal(Score)));
             cmd.Parameters.Add(new MySqlParameter("@vSubTotal", Util.GetString(SubTotal)));
             cmd.Parameters.Add(new MySqlParameter("@vcreatedBy", Util.GetString(CreatedBy)));
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