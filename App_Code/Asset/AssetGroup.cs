using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for AssetGroup
/// </summary>
public class AssetGroup
{
    #region All Memory Variables

    private int vGroupID;
    private string vGroupName;
    private string vGroupCode;
    private string vCreatedBy;
    private int vIsActive;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public AssetGroup()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public AssetGroup(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int GroupID
    {
        get
        {
            return vGroupID;
        }
        set
        {
            vGroupID = value;
        }
    }

    public virtual string GroupName
    {
        get
        {
            return vGroupName;
        }
        set
        {
            vGroupName = value;
        }
    }

    public virtual string GroupCode
    {
        get
        {
            return vGroupCode;
        }
        set
        {
            vGroupCode = value;
        }
    }

    public virtual string CreatedBy
    {
        get
        {
            return vCreatedBy;
        }
        set
        {
            vCreatedBy = value;
        }
    }

    public virtual int IsActive
    {
        get
        {
            return vIsActive;
        }
        set
        {
            vIsActive = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_groupmaster_insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.GroupName = Util.GetString(GroupName);
            this.GroupCode = Util.GetString(GroupCode);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@vGroupName", GroupName));
            cmd.Parameters.Add(new MySqlParameter("@vGroupCode", GroupCode));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));

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
            throw (ex);
        }
    }

    #endregion All Public Member Function

    #region All Public Member Function

    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_groupmaster_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@_GroupName", GroupName));
            cmd.Parameters.Add(new MySqlParameter("@_GroupCode", GroupCode));
            cmd.Parameters.Add(new MySqlParameter("@_IsActive", IsActive));

            Output = cmd.ExecuteNonQuery().ToString();

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
            throw (ex);
        }
    }

    #endregion All Public Member Function
}