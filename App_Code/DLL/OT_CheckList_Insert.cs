using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for OT_CheckList_Insert
/// </summary>
public class OT_CheckList_Insert
{
    #region All Memory Variables

    private string _Transcation_ID;
    private string _LedgerTransactionNO;
    private int _CheckListID;
    private string _CheckListName;
    private string _CheckListAnswer;
    private string _Remarks;
    private string _UserID;
    private string _AnsType;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public OT_CheckList_Insert()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public OT_CheckList_Insert(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Transcation_ID
    {
        get
        {
            return _Transcation_ID;
        }

        set
        {
            _Transcation_ID = value;
        }
    }

    public virtual string LedgerTransactionNO
    {
        get
        {
            return _LedgerTransactionNO;
        }

        set
        {
            _LedgerTransactionNO = value;
        }
    }

    public virtual int CheckListID
    {
        get
        {
            return _CheckListID;
        }

        set
        {
            _CheckListID = value;
        }
    }

    public virtual string CheckListName
    {
        get
        {
            return _CheckListName;
        }

        set
        {
            _CheckListName = value;
        }
    }

    public virtual string CheckListAnswer
    {
        get
        {
            return _CheckListAnswer;
        }

        set
        {
            _CheckListAnswer = value;
        }
    }

    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }

        set
        {
            _Remarks = value;
        }
    }

    public virtual string UserID
    {
        get
        {
            return _UserID;
        }

        set
        {
            _UserID = value;
        }
    }

    public virtual string AnsType
    {
        get
        {
            return _AnsType;
        }

        set
        {
            _AnsType = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string iPkValue;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_CheckList_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;

            this.Transcation_ID = Util.GetString(Transcation_ID);
            this.LedgerTransactionNO = Util.GetString(LedgerTransactionNO);
            this.CheckListID = Util.GetInt(CheckListID);
            this.CheckListName = Util.GetString(CheckListName);
            this.CheckListAnswer = Util.GetString(CheckListAnswer);
            this.Remarks = Util.GetString(Remarks);
            this.UserID = Util.GetString(UserID);
            this.AnsType = Util.GetString(AnsType);
            cmd.Parameters.Add(new MySqlParameter("@_Transcation_ID", Transcation_ID));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTransactionNO", LedgerTransactionNO));
            cmd.Parameters.Add(new MySqlParameter("@_CheckListID", CheckListID));
            cmd.Parameters.Add(new MySqlParameter("@_CheckListName", CheckListName));
            cmd.Parameters.Add(new MySqlParameter("@_CheckListAnswer", CheckListAnswer));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@_UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@_AnsType", AnsType));
            iPkValue = cmd.ExecuteScalar().ToString();

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
            throw (ex);
        }
    }

    #endregion All Public Member Function
}