using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for AssetSubGroup
/// </summary>
public class AssetSubGroup
{
    public AssetSubGroup()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public AssetSubGroup(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _SubGroupID;
    private int _GroupID;
    private string _SubGroupName;
    private string _SubGroupCode;
    private string _CreatedBy;
    private int _IsActive;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int SubGroupID { get { return _SubGroupID; } set { _SubGroupID = value; } }
    public virtual int GroupID { get { return _GroupID; } set { _GroupID = value; } }
    public virtual string SubGroupName { get { return _SubGroupName; } set { _SubGroupName = value; } }
    public virtual string SubGroupCode { get { return _SubGroupCode; } set { _SubGroupCode = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual int IsActive { get { return _IsActive; } set { _IsActive = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_subgroupmaster_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vGroupID", Util.GetInt(GroupID)));
            cmd.Parameters.Add(new MySqlParameter("@vSubGroupName", Util.GetString(SubGroupName)));
            cmd.Parameters.Add(new MySqlParameter("@vSubGroupCode", Util.GetString(SubGroupCode)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", Util.GetInt(IsActive)));

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

    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_subgroupmaster_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_SubGroupID", SubGroupID));
            cmd.Parameters.Add(new MySqlParameter("@_GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@_SubGroupName", SubGroupName));
            cmd.Parameters.Add(new MySqlParameter("@_SubGroupCode", SubGroupCode));
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
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    #endregion All Public Member Function
}