using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Set_master
/// </summary>
public class Set_master
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Set_master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Set_master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Properties

    private string _SetName;

    public string SetName
    {
        get { return _SetName; }
        set { _SetName = value; }
    }

    private string _Description;

    public string Description
    {
        get { return _Description; }
        set { _Description = value; }
    }

    private string _UserID;

    public string UserID
    {
        get { return _UserID; }
        set { _UserID = value; }
    }

    private int _IsActive;

    public int IsActive
    {
        get { return _IsActive; }
        set { _IsActive = value; }
    }

    private string _ID;

    public string ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    private int _validityDays;
    public int validityDays { get { return _validityDays; } set { _validityDays = value; } }

    private int _setDeptId;
    public int setDeptId { get { return _setDeptId; } set { _setDeptId = value; } }

    private string _setDept;
    public string setDept { get { return _setDept; } set { _setDept = value; } }


    #endregion Properties

    #region methods

    public string Insert()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Insert_SetMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter param = new MySqlParameter("vSetID", MySqlDbType.String, 50);
            param.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.SetName = Util.GetString(SetName);
            this.Description = Util.GetString(Description);
            this.UserID = Util.GetString(UserID);
            this.IsActive = Util.GetInt(IsActive);
            this.validityDays = Util.GetInt(validityDays);

            cmd.Parameters.Add(new MySqlParameter("@vSetName", SetName));
            cmd.Parameters.Add(new MySqlParameter("@vDescription", Description));
            cmd.Parameters.Add(new MySqlParameter("@vCreator_ID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@vValidityDays", validityDays));
            cmd.Parameters.Add(new MySqlParameter("@vSetDeptId", setDeptId));
            cmd.Parameters.Add(new MySqlParameter("@vSetDept", setDept));
            cmd.Parameters.Add(param);
            ID = Util.GetString(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open)
                {
                    objTrans.Commit();
                    objCon.Close();
                }
            }
            return ID.ToString();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                objTrans.Rollback();
                objCon.Close();
            }
            throw (ex);
        }
    }

    #endregion methods
}