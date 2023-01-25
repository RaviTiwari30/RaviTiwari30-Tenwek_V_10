using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for CampAnswer
/// </summary>
public class CampAnswer
{
    #region All Memory Variables

    private int _Camp_Id;
    private int _Q_ID;
    private string _Answer;
    private string _CreatedBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public CampAnswer()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public CampAnswer(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int Camp_Id
    {
        get
        {
            return _Camp_Id;
        }
        set
        {
            _Camp_Id = value;
        }
    }

    public virtual int Q_ID
    {
        get
        {
            return _Q_ID;
        }
        set
        {
            _Q_ID = value;
        }
    }

    public virtual string Answer
    {
        get
        {
            return _Answer;
        }
        set
        {
            _Answer = value;
        }
    }

    public virtual string CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_CampAnswer_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@@Identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Camp_Id = Util.GetInt(Camp_Id);
            this.Q_ID = Util.GetInt(Q_ID);
            this.Answer = Util.GetString(Answer);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@_Camp_Id", Camp_Id));
            cmd.Parameters.Add(new MySqlParameter("@_Q_ID", Q_ID));
            cmd.Parameters.Add(new MySqlParameter("@_Answer", Answer));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(paramTnxID);
            iPkValue = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue.ToString();
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

    #endregion All Public Member Function
}