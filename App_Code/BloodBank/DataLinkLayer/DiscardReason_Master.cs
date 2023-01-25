using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for DiscardReason_Master
/// </summary>
public class DiscardReason_Master
{
    #region All Memory Variables

    private string _Reason;
    private int _ReasonID;
    private int _IsActive;
    private string _CreatedBy;
    private int _CreatedCentreID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DiscardReason_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DiscardReason_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Reason
    {
        get
        {
            return _Reason;
        }
        set
        {
            _Reason = value;
        }
    }

    public virtual int ReasonID
    {
        get
        {
            return _ReasonID;
        }
        set
        {
            _ReasonID = value;
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

    public virtual int CreatedCentreID
    {
        get
        {
            return _CreatedCentreID;
        }
        set
        {
            _CreatedCentreID = value;
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

            objSQL.Append("bb_DiscardReason_Master");
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
            this.Reason = Util.GetString(Reason);
            this.ReasonID = Util.GetInt(ReasonID);
            this.IsActive = Util.GetInt(IsActive);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CreatedCentreID = Util.GetInt(CreatedCentreID);

            cmd.Parameters.Add(new MySqlParameter("@_Reason", Reason));
            cmd.Parameters.Add(new MySqlParameter("@_ReasonID", ReasonID));
            cmd.Parameters.Add(new MySqlParameter("@_IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedCentreID", CreatedCentreID));

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