using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for DiscardBlood
/// </summary>
public class DiscardBlood
{
    #region All Memory Variables

    private string _Stock_ID;
    private string _BloodCollection_ID;
    private string _BagType;
    private string _BBTubeNo;
    private string _BloodGroup;
    private string _ComponentName;
    private string _Reason;
    private string _Remarks;
    private string _EntryBy;
    private int _IsDiscarded;
    private int _CentreID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DiscardBlood()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DiscardBlood(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Stock_ID
    {
        get
        {
            return _Stock_ID;
        }
        set
        {
            _Stock_ID = value;
        }
    }

    public virtual string BloodCollection_ID
    {
        get
        {
            return _BloodCollection_ID;
        }
        set
        {
            _BloodCollection_ID = value;
        }
    }

    public virtual string BagType
    {
        get
        {
            return _BagType;
        }
        set
        {
            _BagType = value;
        }
    }

    public virtual string BBTubeNo
    {
        get
        {
            return _BBTubeNo;
        }
        set
        {
            _BBTubeNo = value;
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

    public virtual string EntryBy
    {
        get
        {
            return _EntryBy;
        }
        set
        {
            _EntryBy = value;
        }
    }

    public virtual string BloodGroup
    {
        get
        {
            return _BloodGroup;
        }
        set
        {
            _BloodGroup = value;
        }
    }

    public virtual string ComponentName
    {
        get
        {
            return _ComponentName;
        }
        set
        {
            _ComponentName = value;
        }
    }

    public virtual int IsDiscarded
    {
        get
        {
            return _IsDiscarded;
        }

        set
        {
            _IsDiscarded = value;
        }
    }

    public virtual int CentreID
    {
        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string DiscardID = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_DiscardBloodStock");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_DiscardId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Stock_ID = Util.GetString(Stock_ID);
            this.BBTubeNo = Util.GetString(BBTubeNo);
            this._BloodCollection_ID = Util.GetString(BloodCollection_ID);
            this.Reason = Util.GetString(Reason);
            this.Remarks = Util.GetString(Remarks);
            this.BloodGroup = Util.GetString(BloodGroup);
            this.EntryBy = Util.GetString(EntryBy);
            this.CentreID = Util.GetInt(CentreID);
            this.ComponentName = Util.GetString(ComponentName);
            this.BagType = Util.GetString(BagType);
            this.IsDiscarded = Util.GetInt(IsDiscarded);
            cmd.Parameters.Add(new MySqlParameter("@_Stock_ID", Stock_ID));
            cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_ID", BloodCollection_ID));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@_Reason", Reason));
            cmd.Parameters.Add(new MySqlParameter("@_BloodGroup", BloodGroup));
            cmd.Parameters.Add(new MySqlParameter("@_EntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentName", ComponentName));
            cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            cmd.Parameters.Add(new MySqlParameter("@_IsDiscarded", IsDiscarded));
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            DiscardID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return DiscardID.ToString();
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