using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StockInsert
/// </summary>
public class StockInsert
{
    #region All Memory Variables

    private string _BloodCollection_Id;
    private string _BagType;
    private string _BBTubeNo;
    private string _BloodGroup;
    private int _ComponentID;
    private int _IsComponent;
    private DateTime _EntryDate;
    private DateTime _ExpiryDate;
    private decimal _InitialCount;

    private string _CreatedBy;
    private int _status;
    private int _IsDiscarded;
    private int _CentreId;
    private string _ComponentName;
    private int _DeptRequestID;
    private int _FromCentreID;
    private string _FromStockID;
    private string _FromBloodCollection_Id;
    private decimal _Rate;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public StockInsert()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public StockInsert(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string BloodCollection_Id
    {
        get
        {
            return _BloodCollection_Id;
        }
        set
        {
            _BloodCollection_Id = value;
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

    public virtual int ComponentID
    {
        get
        {
            return _ComponentID;
        }
        set
        {
            _ComponentID = value;
        }
    }

    public virtual int IsComponent
    {
        get
        {
            return _IsComponent;
        }
        set
        {
            _IsComponent = value;
        }
    }

    public virtual DateTime EntryDate
    {
        get
        {
            return _EntryDate;
        }
        set
        {
            _EntryDate = value;
        }
    }

    public virtual DateTime ExpiryDate
    {
        get
        {
            return _ExpiryDate;
        }
        set
        {
            _ExpiryDate = value;
        }
    }

    public virtual decimal InitialCount
    {
        get
        {
            return _InitialCount;
        }
        set
        {
            _InitialCount = value;
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

    public virtual int status
    {
        get
        {
            return _status;
        }
        set
        {
            _status = value;
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

    public virtual int CentreId
    {
        get
        {
            return _CentreId;
        }
        set
        {
            _CentreId = value;
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
    public virtual int DeptRequestID
    { 
        get
        {
            return _DeptRequestID;
        }
        set
        {
            _DeptRequestID = value;
        }
    }
    public virtual int FromCentreID
    {
        get
        {
            return _FromCentreID;
        }
        set
        {
            _FromCentreID = value;
        }
    }
    public virtual string FromStockID
    {
        get
        {
            return _FromStockID;
        }
        set
        {
            _FromStockID = value;
        }
    }
    public virtual string FromBloodCollection_Id
    {
        get
        {
            return _FromBloodCollection_Id;
        }
        set
        {
            _FromBloodCollection_Id = value;
        }
    }
    public virtual decimal Rate
    {
        get
        {
            return _Rate;
        }
        set
        {
            _Rate = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string StockId = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_stockInsert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_StockId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.BloodCollection_Id = Util.GetString(BloodCollection_Id);
            this.BagType = Util.GetString(BagType);
            this.BBTubeNo = Util.GetString(BBTubeNo);
            this.BloodGroup = Util.GetString(BloodGroup);
            this.ComponentID = Util.GetInt(ComponentID);
            this.IsComponent = Util.GetInt(IsComponent);
            this.EntryDate = Util.GetDateTime(EntryDate);
            this.ExpiryDate = Util.GetDateTime(ExpiryDate);
            this.InitialCount = Util.GetDecimal(InitialCount);

            this.CreatedBy = Util.GetString(CreatedBy);
            this.status = Util.GetInt(status);
            this.IsDiscarded = Util.GetInt(IsDiscarded);
            this.CentreId = Util.GetInt(CentreId);
            this.ComponentName = Util.GetString(ComponentName);

            //cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            //cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            //cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            //cmd.Parameters.Add(new MySqlParameter("@_BloodGroup", BloodGroup));
            //cmd.Parameters.Add(new MySqlParameter("@_ComponentID", ComponentID));
            //cmd.Parameters.Add(new MySqlParameter("@_IsComponent", IsComponent));
            //cmd.Parameters.Add(new MySqlParameter("@_EntryDate", EntryDate));
            //cmd.Parameters.Add(new MySqlParameter("@_ExpiryDate", ExpiryDate));
            //cmd.Parameters.Add(new MySqlParameter("@_InitialCount", InitialCount));

            //cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            //cmd.Parameters.Add(new MySqlParameter("@_status", status));
            //cmd.Parameters.Add(new MySqlParameter("@_IsDiscarded", IsDiscarded));
            //cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreId));

            //cmd.Parameters.Add(new MySqlParameter("@_ComponentName", ComponentName));
            //cmd.Parameters.Add(new MySqlParameter("@_DeptRequestID", DeptRequestID));
            //cmd.Parameters.Add(new MySqlParameter("@_FromCentreID", FromCentreID));
            //cmd.Parameters.Add(new MySqlParameter("@_FromStockID", FromStockID));
            //cmd.Parameters.Add(new MySqlParameter("@_FromBloodCollection_Id", FromBloodCollection_Id));
            //cmd.Parameters.Add(new MySqlParameter("@_Rate", Rate));

            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            cmd.Parameters.Add(new MySqlParameter("@_BloodGroup", BloodGroup));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentID", ComponentID));
            cmd.Parameters.Add(new MySqlParameter("@_IsComponent", IsComponent));
            cmd.Parameters.Add(new MySqlParameter("@_EntryDate", EntryDate));
            cmd.Parameters.Add(new MySqlParameter("@_ExpiryDate", ExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@_InitialCount", InitialCount));

            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@_status", status));
            cmd.Parameters.Add(new MySqlParameter("@_IsDiscarded", IsDiscarded));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreId));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentName", ComponentName));
            cmd.Parameters.Add(paramTnxID);
            StockId = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return StockId.ToString();
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