using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for AssetMaster
/// </summary>
public class AssetMaster
{
    public AssetMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public AssetMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _AssetID;
    private string _AssetName;
    private string _AssetCode;
    private int _GroupID;
    private int _SubGroupID;
    private string _CreatedBy;
    private int _IsActive;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int AssetID { get { return _AssetID; } set { _AssetID = value; } }
    public virtual string AssetName { get { return _AssetName; } set { _AssetName = value; } }
    public virtual string AssetCode { get { return _AssetCode; } set { _AssetCode = value; } }
    public virtual int GroupID { get { return _GroupID; } set { _GroupID = value; } }
    public virtual int SubGroupID { get { return _SubGroupID; } set { _SubGroupID = value; } }
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

            objSQL.Append("ass_assetmaster_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vAssetName", Util.GetString(AssetName)));
            cmd.Parameters.Add(new MySqlParameter("@vAssetCode", Util.GetString(AssetCode)));
            cmd.Parameters.Add(new MySqlParameter("@vGroupID", Util.GetInt(GroupID)));
            cmd.Parameters.Add(new MySqlParameter("@vSubGroupID", Util.GetInt(SubGroupID)));
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

    #endregion All Public Member Function

    #region All Public Member Function

    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_assetmaster_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_AssetID", AssetID));
            cmd.Parameters.Add(new MySqlParameter("@_AssetName", AssetName));
            cmd.Parameters.Add(new MySqlParameter("@_AssetCode", AssetCode));
            cmd.Parameters.Add(new MySqlParameter("@_GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@_SubGroupID", SubGroupID));
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