using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodTest_Master
/// </summary>
public class BloodTest_Master
{
    #region All Memory Variables

    private string _TestName;
    private int _Value;
    private int _Method;
    private int _Result;
    private int _IsActive;
    private string _CreatedBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public BloodTest_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodTest_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string TestName
    {
        get
        {
            return _TestName;
        }
        set
        {
            _TestName = value;
        }
    }

    public virtual int Value
    {
        get
        {
            return _Value;
        }
        set
        {
            _Value = value;
        }
    }

    public virtual int Method
    {
        get
        {
            return _Method;
        }
        set
        {
            _Method = value;
        }
    }

    public virtual int Result
    {
        get
        {
            return _Result;
        }
        set
        {
            _Result = value;
        }
    }

    public virtual int IsActive
    {
        get
        {
            return _IsActive;
        }
        set
        {
            _IsActive = value;
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

            objSQL.Append("bb_BloodTest_Master");
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
            this.TestName = Util.GetString(TestName);
            this.Value = Util.GetInt(Value);
            this.Method = Util.GetInt(Method);
            this.Result = Util.GetInt(Result);
            this.IsActive = Util.GetInt(IsActive);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@_TestName", TestName));
            cmd.Parameters.Add(new MySqlParameter("@_Value", Value));
            cmd.Parameters.Add(new MySqlParameter("@_Method", Method));
            cmd.Parameters.Add(new MySqlParameter("@_Result", Result));
            cmd.Parameters.Add(new MySqlParameter("@_IsActive", IsActive));
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