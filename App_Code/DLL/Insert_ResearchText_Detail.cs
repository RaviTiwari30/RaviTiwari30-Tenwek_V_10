using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Insert_ResearchText_Detail
/// </summary>
public class Insert_ResearchText_Detail
{
    public Insert_ResearchText_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Insert_ResearchText_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #region All Memory Variables
    private int _ResearchID;
    private int _ReferenceID;
    private string _TransactionID;
    private string _Score;
    private string _TextName;
    private string _TextValue;
    private string _CreatedBy;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ResearchID { get { return _ResearchID; } set { _ResearchID = value; } }
    public virtual int ReferenceID { get { return _ReferenceID; } set { _ReferenceID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Score { get { return _Score; } set { _Score = value; } }
    public virtual string TextName { get { return _TextName; } set { _TextName = value; } }
    public virtual string TextValue { get { return _TextValue; } set { _TextValue = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("research_DetailText_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vResearchID", Util.GetInt(ResearchID)));
            cmd.Parameters.Add(new MySqlParameter("@vReferenceID", Util.GetInt(ReferenceID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vScore", Util.GetString(Score)));
            cmd.Parameters.Add(new MySqlParameter("@vTextName", Util.GetString(TextName)));
            cmd.Parameters.Add(new MySqlParameter("@vTextValue", Util.GetString(TextValue)));
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