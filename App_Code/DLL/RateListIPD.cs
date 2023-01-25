using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for RateListIPD
/// </summary>
public class RateListIPD
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _RateListID;
    private string _Hospital_ID;
    private string _StockID;
    private decimal _Rate;
    private decimal _ERate;
    private int _IsTaxable;
    private System.DateTime _FromDate;
    private System.DateTime _ToDate;
    private int _IsCurrent;
    private string _ItemID;
    private string _IsService;
    private decimal _Commission;
    private string _PanelID;
    private string _IPDCaseType_ID;
    private string _ItemDisplayName;
    private string _ItemCode;
    private int _ScheduleChargeID;
    private string _UserID;
    private string _IPAddress;
    private int _RateCurrencyCountryID;
    private int _CentreID;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public RateListIPD()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public RateListIPD(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Location
    {
        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }

    public virtual string HospCode
    {
        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
        }
    }

    public virtual int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }

    public virtual string RateListID
    {
        get
        {
            return _RateListID;
        }
        set
        {
            _RateListID = value;
        }
    }

    public virtual string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
        }
    }

    public virtual string StockID
    {
        get
        {
            return _StockID;
        }
        set
        {
            _StockID = value;
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

    public virtual decimal ERate
    {
        get
        {
            return _ERate;
        }
        set
        {
            _ERate = value;
        }
    }

    public virtual int IsTaxable
    {
        get
        {
            return _IsTaxable;
        }
        set
        {
            _IsTaxable = value;
        }
    }

    public virtual DateTime FromDate
    {
        get
        {
            return _FromDate;
        }
        set
        {
            _FromDate = value;
        }
    }

    public virtual DateTime ToDate
    {
        get
        {
            return _ToDate;
        }
        set
        {
            _ToDate = value;
        }
    }

    public virtual int IsCurrent
    {
        get
        {
            return _IsCurrent;
        }
        set
        {
            _IsCurrent = value;
        }
    }

    public virtual string ItemID
    {
        get
        {
            return _ItemID;
        }
        set
        {
            _ItemID = value;
        }
    }

    public virtual string IsService
    {
        get
        {
            return _IsService;
        }
        set
        {
            _IsService = value;
        }
    }

    public virtual decimal Commission
    {
        get
        {
            return _Commission;
        }
        set
        {
            _Commission = value;
        }
    }

    public virtual string PanelID
    {
        get
        {
            return _PanelID;
        }
        set
        {
            _PanelID = value;
        }
    }

    public virtual string IPDCaseTypeID
    {
        get
        {
            return _IPDCaseType_ID;
        }
        set
        {
            _IPDCaseType_ID = value;
        }
    }

    public virtual string ItemDisplayName
    {
        get
        {
            return _ItemDisplayName;
        }
        set
        {
            _ItemDisplayName = value;
        }
    }

    public virtual string ItemCode
    {
        get
        {
            return _ItemCode;
        }
        set
        {
            _ItemCode = value;
        }
    }

    public virtual int ScheduleChargeID
    {
        get
        {
            return _ScheduleChargeID;
        }
        set
        {
            _ScheduleChargeID = value;
        }
    }


    public virtual int RateCurrencyCountryID
    {
        get
        {
            return _RateCurrencyCountryID;
        }
        set
        {
            _RateCurrencyCountryID = value;
        }
    }

    public virtual string UserID
    {
        get
        {
            return _UserID;
        }
        set
        {
            _UserID = value;
        }
    }

    public virtual string IPAddress
    {
        get
        {
            return _IPAddress;
        }
        set
        {
            _IPAddress = value;
        }
    }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }


    #endregion Set All Property

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_RateListIPD");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@RateListID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.StockID = Util.GetString(StockID);
            this.Rate = Util.GetDecimal(Rate);
            this.ERate = Util.GetDecimal(ERate);
            this.IsTaxable = Util.GetInt(IsTaxable);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.IsCurrent = Util.GetInt(IsCurrent);
            this.ItemID = Util.GetString(ItemID);
            this.IsService = Util.GetString(IsService);
            this.Commission = Util.GetDecimal(Commission);
            this.PanelID = Util.GetString(PanelID);
            this.IPDCaseTypeID = Util.GetString(IPDCaseTypeID);
            this.ItemDisplayName = Util.GetString(ItemDisplayName);
            this.ItemCode = Util.GetString(ItemCode);
            this.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
            this.UserID = Util.GetString(UserID);
            this.IPAddress = Util.GetString(IPAddress);
            this.CentreID = Util.GetInt(CentreID);
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@ERate", ERate));
            cmd.Parameters.Add(new MySqlParameter("@IsTaxable", IsTaxable));
            cmd.Parameters.Add(new MySqlParameter("@FromDate", FromDate));
            cmd.Parameters.Add(new MySqlParameter("@ToDate", ToDate));
            cmd.Parameters.Add(new MySqlParameter("@IsCurrent", IsCurrent));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@IsService", IsService));
            cmd.Parameters.Add(new MySqlParameter("@Commission", Commission));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
            cmd.Parameters.Add(new MySqlParameter("@IPDCaseTypeID", IPDCaseTypeID));
            cmd.Parameters.Add(new MySqlParameter("@ItemDisplayName", ItemDisplayName));
            cmd.Parameters.Add(new MySqlParameter("@ItemCode", ItemCode));
            cmd.Parameters.Add(new MySqlParameter("@ScheduleChargeID", ScheduleChargeID));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@RateCurrencyCountryID", RateCurrencyCountryID));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));

            cmd.Parameters.Add(paramTnxID);

            RateListID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return RateListID;
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
}