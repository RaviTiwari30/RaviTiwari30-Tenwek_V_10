using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for MaintenanceMaster
/// </summary>
public class MaintenanceMaster
{
    public MaintenanceMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public MaintenanceMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _MaintenanceID;
    private string _MaintenanceName;
    private string _MaintenanceCode;
    private int _IsActive;
    private string _CreatedBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int MaintenanceID { get { return _MaintenanceID; } set { _MaintenanceID = value; } }
    public virtual string MaintenanceName { get { return _MaintenanceName; } set { _MaintenanceName = value; } }
    public virtual string MaintenanceCode { get { return _MaintenanceCode; } set { _MaintenanceCode = value; } }
    public virtual int IsActive { get { return _IsActive; } set { _IsActive = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_maintenancemaster_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vMaintenanceName", Util.GetString(MaintenanceName)));
            cmd.Parameters.Add(new MySqlParameter("@vMaintenanceCode", Util.GetString(MaintenanceCode)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));

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

            objSQL.Append("ass_maintenancemaster_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_MaintenanceID", MaintenanceID));
            cmd.Parameters.Add(new MySqlParameter("@_MaintenanceName", MaintenanceName));
            cmd.Parameters.Add(new MySqlParameter("@_MaintenanceCode", MaintenanceCode));
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