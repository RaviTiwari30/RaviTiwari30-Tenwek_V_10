using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StockExpiry
/// </summary>
public class StockExpiry
{
    #region All Memory Variables

    private string _StockID;
    private string _ItemID;
    private DateTime _OldExpiryDate;
    private DateTime _NewExpiryDate;
    private string _UserID;
    private DateTime _UpdateDate;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public StockExpiry()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public StockExpiry(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    public virtual DateTime OldExpiryDate
    {
        get
        {
            return _OldExpiryDate;
        }
        set
        {
            _OldExpiryDate = value;
        }
    }

    public virtual DateTime NewExpiryDate
    {
        get
        {
            return _NewExpiryDate;
        }
        set
        {
            _NewExpiryDate = value;
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

    public virtual DateTime UpdateDate
    {
        get
        {
            return _UpdateDate;
        }
        set
        {
            _UpdateDate = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_stockexpiry(StockID,ItemID,OldExpDate,NewExpDate,UserID,UpdateDate)");
            objSQL.Append("VALUES (@StockID, @ItemID, @OldExpiryDate, @NewExpiryDate, @UserID, @UpdateDate )");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.StockID = Util.GetString(StockID);
            this.ItemID = Util.GetString(ItemID);
            this.OldExpiryDate = Util.GetDateTime(OldExpiryDate);
            this.NewExpiryDate = Util.GetDateTime(NewExpiryDate);
            this.UserID = Util.GetString(UserID);
            this.UpdateDate = Util.GetDateTime(UpdateDate);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                 new MySqlParameter("@StockID", StockID),
                 new MySqlParameter("@ItemID", ItemID),
                 new MySqlParameter("@OldExpiryDate", OldExpiryDate),
                 new MySqlParameter("@NewExpiryDate", NewExpiryDate),
                 new MySqlParameter("@UserID", UserID),
                 new MySqlParameter("@UpdateDate", UpdateDate));

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

    #endregion All Public Member Function
}