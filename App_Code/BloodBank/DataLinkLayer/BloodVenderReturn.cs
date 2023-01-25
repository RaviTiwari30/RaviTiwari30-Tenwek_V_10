using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for VenderReturn
/// </summary>
public class BloodVenderReturn
{
    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    private string _StockID;

    public string StockID
    {
        get { return _StockID; }
        set { _StockID = value; }
    }

    private string _BloodCollection_ID;

    public string BloodCollection_ID
    {
        get { return _BloodCollection_ID; }
        set { _BloodCollection_ID = value; }
    }

    private string _ComponentName;

    public string ComponentName
    {
        get { return _ComponentName; }
        set { _ComponentName = value; }
    }

    private int _ComponentID;

    public int ComponentID
    {
        get { return _ComponentID; }
        set { _ComponentID = value; }
    }

    private string _EntryBy;

    public string EntryBy
    {
        get { return _EntryBy; }
        set { _EntryBy = value; }
    }

    private string _BBTubeNo;

    public string BBTubeNo
    {
        get { return _BBTubeNo; }
        set { _BBTubeNo = value; }
    }

    private string _Reason;

    public string Reason
    {
        get { return _Reason; }
        set { _Reason = value; }
    }
    public int _CentreID;
    public int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }

    public BloodVenderReturn()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodVenderReturn(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_VenderReturn");
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
            this.StockID = Util.GetString(StockID);
            this.BloodCollection_ID = Util.GetString(BloodCollection_ID);
            this.ComponentName = Util.GetString(ComponentName);
            this.ComponentID = Util.GetInt(ComponentID);
            this.BBTubeNo = Util.GetString(BBTubeNo);
            this.EntryBy = Util.GetString(EntryBy);
            this.Reason = Util.GetString(Reason);
            this.CentreID = Util.GetInt(CentreID);
            cmd.Parameters.Add(new MySqlParameter("@_StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_ID", BloodCollection_ID));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentName", ComponentName));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentID", ComponentID));
            cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            cmd.Parameters.Add(new MySqlParameter("@_EntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@_Reason", Reason));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

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
            throw (ex);
        }
    }
}