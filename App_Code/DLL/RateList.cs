using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class RateList
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _RateListID;
    private string _Hospital_ID;
    private string _StockID;
    private decimal _Rate;
    private int _IsTaxable;
    private System.DateTime _FromDate;
    private System.DateTime _ToDate;
    private int _IsCurrent;
    private string _ItemID;
    private string _IsService;
    private decimal _Commission;
    private string _PanelID;
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

    public RateList()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public RateList(MySqlTransaction objTrans)
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

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_RateList");
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
            this.IsTaxable = Util.GetInt(IsTaxable);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.IsCurrent = Util.GetInt(IsCurrent);
            this.ItemID = Util.GetString(ItemID);
            this.IsService = Util.GetString(IsService);
            this.Commission = Util.GetDecimal(Commission);
            this.PanelID = Util.GetString(PanelID);
            this.ItemDisplayName = Util.GetString(ItemDisplayName);
            this.ItemCode = Util.GetString(ItemCode);
            this.UserID = Util.GetString(UserID);
            this.IPAddress = Util.GetString(IPAddress);
            this.CentreID = Util.GetInt(CentreID);
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@IsTaxable", IsTaxable));
            cmd.Parameters.Add(new MySqlParameter("@FromDate", FromDate));
            cmd.Parameters.Add(new MySqlParameter("@ToDate", ToDate));
            cmd.Parameters.Add(new MySqlParameter("@IsCurrent", IsCurrent));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@IsService", IsService));
            cmd.Parameters.Add(new MySqlParameter("@Commission", Commission));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
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
            throw (ex);
        }
    }

    public int UpdateRate()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_ratelist SET ToDate=? WHERE StockID = ? and ToDate='' ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.ToDate = Util.GetDateTime(ToDate);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@ToDate", ToDate));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_ratelist SET Hospital_ID=?,StockID=?,Rate=?,IsTaxable=?,FromDate=?,ToDate=?,IsCurrent=?,ItemID=?,IsService=?,Commission=?,PanelID=?,UserID=?,CentreID=? WHERE RateListID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.StockID = Util.GetString(StockID);
            this.Rate = Util.GetDecimal(Rate);
            this.IsTaxable = Util.GetInt(IsTaxable);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.IsCurrent = Util.GetInt(IsCurrent);
            this.RateListID = Util.GetString(RateListID);
            this.ItemID = Util.GetString(ItemID);
            this.IsService = Util.GetString(IsService);
            this.Commission = Util.GetDecimal(Commission);
            this.PanelID = Util.GetString(PanelID);
            this.UserID = Util.GetString(UserID);
            this.CentreID = Util.GetInt(CentreID);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@StockID", StockID),
                new MySqlParameter("@Rate", Rate),
                new MySqlParameter("@IsTaxable", IsTaxable),
                new MySqlParameter("@FromDate", FromDate),
                new MySqlParameter("@ToDate", ToDate),
                new MySqlParameter("@RateListID", RateListID),
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@IsService", IsService),
                new MySqlParameter("@Commission", Commission),
                new MySqlParameter("@PanelID", PanelID),
                new MySqlParameter("@UserID", UserID),
                new MySqlParameter("@CentreID", CentreID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }
    }

    public int Delete(int iPkValue)
    {
        this.RateListID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_ratelist WHERE RateListID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("RateListID", RateListID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
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

    public bool Load()
    {
        DataTable dtTemp;

        try
        {
            string sSQL = "SELECT * FROM f_ratelist WHERE RateListID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@RateListID", RateListID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);
            string sParams = "RateListID=" + this.RateListID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.RateListID = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.RateList.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.RateList.HospCode]);
        this.RateListID = Util.GetString(dtTemp.Rows[0][AllTables.RateList.RateListID]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.RateList.Hospital_ID]);
        this.StockID = Util.GetString(dtTemp.Rows[0][AllTables.RateList.StockID]);
        this.Rate = Util.GetDecimal(dtTemp.Rows[0][AllTables.RateList.Rate]);
        this.IsTaxable = Util.GetInt(dtTemp.Rows[0][AllTables.RateList.IsTaxable]);
        this.FromDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.RateList.FromDate]);
        this.ToDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.RateList.ToDate]);
        this.IsCurrent = Util.GetInt(dtTemp.Rows[0][AllTables.RateList.IsCurrent]);
        this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.RateList.ItemID]);
        this.IsService = Util.GetString(dtTemp.Rows[0][AllTables.RateList.IsService]);
        this.Commission = Util.GetDecimal(dtTemp.Rows[0][AllTables.RateList.Commission]);
        this.Commission = Util.GetDecimal(dtTemp.Rows[0][AllTables.RateList.Commission]);
        this.PanelID = Util.GetString(dtTemp.Rows[0][AllTables.RateList.PanelID]);
        this.ItemDisplayName = Util.GetString(dtTemp.Rows[0][AllTables.RateList.ItemDisplayName]);
        this.ItemCode = Util.GetString(dtTemp.Rows[0][AllTables.RateList.ItemCode]);
    }

    #endregion Helper Private Function
}