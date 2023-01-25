#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces



public class DepartmentWiseStock
{
#region All Memory Variables
    private int       _DeptStockID;
    private string      _DeptID;
    private string      _ItemID;
    private decimal     _InitialCount;
    private decimal        _RealeasedCount;
    private int        _SaleOrConsumed;
    private string      _StockID;
    private string      _LedgerTransactionNo;
    private DateTime    _Date;
    private string      _BatchNumber;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
		public DepartmentWiseStock()
		{
			objCon = Util.GetMySqlCon();
			this.IsLocalConn = true;
            //21-03
            //this.InitialCount = "Private";
            //this.RealeasedCount = 1;
            //this.SaleOrConsumed = '1'.ToString();
		}
        public DepartmentWiseStock(MySqlTransaction objTrans)
		{
			this.objTrans = objTrans;
			this.IsLocalConn = false;
		}
	#endregion

    #region Set All Property
    public virtual int DeptStockID
    {
        get
        {
            return _DeptStockID;
        }
        set
        {
            _DeptStockID = value;
        }
    }
    public virtual string DeptID
    {
        get
        {
            return _DeptID;
        }
        set
        {
            _DeptID = value;
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
    public virtual decimal RealeasedCount
    {
        get
        {
            return _RealeasedCount;
        }
        set
        {
            _RealeasedCount = value;
        }
    }
    public virtual int SaleOrConsumed
    {
        get
        {
            return _SaleOrConsumed;
        }
        set
        {
            _SaleOrConsumed = value;
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
    public virtual string LedgerTransactionNo
    {
        get
        {
            return _LedgerTransactionNo;
        }
        set
        {
            _LedgerTransactionNo = value;
        }
    }
    public virtual DateTime Date
    {
        get
        {
            return _Date;
        }
        set
        {
            _Date = value;
        }
    }
    public virtual string BatchNumber
    {
        get
        {
            return _BatchNumber;
        }
        set
        {
            _BatchNumber = value;
        }
    }

    
    #endregion
        
    #region All Public Member Function
    public int Insert()
    {
        try
        {
           int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_departmentwisestock(DeptStockID,DeptID,ItemID,InitialCount,RealeasedCount,SaleOrConsumed,StockID,LedgerTransactionNo,Date,BatchNumber)");
            objSQL.Append("VALUES (@DeptStockID, @DeptID, @ItemID, @InitialCount, @RealeasedCount, @SaleOrConsumed, @StockID, @LedgerTransactionNo, @Date,@BatchNumber)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.DeptStockID = Util.GetInt(DeptStockID);
            this.DeptID = Util.GetString(DeptID);
            this.ItemID = Util.GetString(ItemID);
            this.InitialCount = Util.GetDecimal(InitialCount);
            this.RealeasedCount = Util.GetDecimal(RealeasedCount);
            this.SaleOrConsumed = Util.GetInt(SaleOrConsumed);
            this.StockID = Util.GetString(StockID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.Date = Util.GetDateTime(Date);
            this.BatchNumber = Util.GetString(BatchNumber);
           

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@DeptStockID", DeptStockID),
                new MySqlParameter("@DeptID", DeptID),
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@InitialCount", InitialCount),
                new MySqlParameter("@RealeasedCount", RealeasedCount),
                new MySqlParameter("@SaleOrConsumed", SaleOrConsumed),
                new MySqlParameter("@StockID", StockID),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                new MySqlParameter("@Date", Date),
                new MySqlParameter("@BatchNumber", BatchNumber));
               
                
           iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;	
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_departmentwisestock SET DeptID=?,ItemID=?,InitialCount=?,RealeasedCount=?,SaleOrConsumed=?,StockID=?,LedgerTransactionNo=?,Date=? where BatchNumber=? and DeptStockID=?");
                       
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.DeptStockID = Util.GetInt(DeptStockID);
            this.DeptID = Util.GetString(DeptID);
            this.ItemID = Util.GetString(ItemID);
            this.InitialCount = Util.GetDecimal(InitialCount);
            this.RealeasedCount = Util.GetDecimal(RealeasedCount);
            this.SaleOrConsumed = Util.GetInt(SaleOrConsumed);
            this.StockID = Util.GetString(StockID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.Date = Util.GetDateTime(Date);
            this.BatchNumber = Util.GetString(BatchNumber);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@DeptID", DeptID),
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@InitialCount", InitialCount),
                new MySqlParameter("@RealeasedCount", RealeasedCount),
                new MySqlParameter("@SaleOrConsumed", SaleOrConsumed),
                new MySqlParameter("@StockID", StockID),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                new MySqlParameter("@Date", Date),
                new MySqlParameter("@BatchNumber", BatchNumber),
                new MySqlParameter("@DeptStockID", DeptStockID));
 
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

    //public string Delete(int iPkValue)
    //{
    //    this.DeptStockID = iPkValue;
    //    return this.Delete();
    //}

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_departmentwisestock WHERE DeptStockID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("DeptStockID", DeptStockID));
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

            string sSQL = "SELECT * FROM f_departmentwisestock WHERE DeptStockID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@SaltItemID", DeptStockID)).Tables[0];

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
            string sParams = "DeptStockID=" + this.DeptStockID.ToString();
           // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(int iPkValue)
    {
        this.DeptStockID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.DeptStockID = Util.GetInt(dtTemp.Rows[0][AllTables.departmentwisestock.DeptStockID]);
        this.DeptID = Util.GetString(dtTemp.Rows[0][AllTables.departmentwisestock.DeptID]);
        this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.departmentwisestock.ItemID]);
        this.InitialCount = Util.GetDecimal(dtTemp.Rows[0][AllTables.departmentwisestock.InitialCount]);
        this.RealeasedCount = Util.GetDecimal(dtTemp.Rows[0][AllTables.departmentwisestock.RealeasedCount]);
        this.SaleOrConsumed = Util.GetInt(dtTemp.Rows[0][AllTables.departmentwisestock.SaleOrConsumed]);
        this.StockID = Util.GetString(dtTemp.Rows[0][AllTables.departmentwisestock.StockID]);
        this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.departmentwisestock.LedgerTransactionNo]);
        this.Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.departmentwisestock.Date]);
        this.BatchNumber = Util.GetString(dtTemp.Rows[0][AllTables.departmentwisestock.BatchNumber]);
        
    }
    #endregion
}
