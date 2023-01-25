using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for LaundrySet_master
/// </summary>
public class LaundrySet_master
{
    
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    
    #region Overloaded Constructor
    public LaundrySet_master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public LaundrySet_master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion


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



    private string _DeptLedgerNo;

    public string DeptLedgerNo
    {
        get { return _DeptLedgerNo; }
        set { _DeptLedgerNo = value; }
    }
    private string _ID;

    public string ID
    {
        get { return _ID; }
        set { _ID = value; }
    }
    #endregion

    #region methods
    public string Insert()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Laundry_SetMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter param = new MySqlParameter("vSetID", MySqlDbType.Int32, 10);
            param.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.SetName = Util.GetString(SetName);
            this.Description = Util.GetString(Description);
            this.UserID = Util.GetString(UserID);
            

            cmd.Parameters.Add(new MySqlParameter("@vSetName", SetName));
            cmd.Parameters.Add(new MySqlParameter("@vDescription", Description));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", UserID));
            cmd.Parameters.Add(new MySqlParameter("@vDeptLedgerNo", DeptLedgerNo));
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

    #endregion
}


