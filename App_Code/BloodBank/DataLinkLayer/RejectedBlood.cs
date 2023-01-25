using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for RejectedBlood
/// </summary>
public class RejectedBlood
{
    #region All Memory Variables

    private string _LedgerTransactionNo;
    private decimal _Quantity;
    private string _StockID;
    private string _ItemName;
    private string _TransactionID;
    private string _ItemID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public RejectedBlood()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public RejectedBlood(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    public virtual decimal Quantity
    {
        get
        {
            return _Quantity;
        }
        set
        {
            _Quantity = value;
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

    public virtual string ItemName
    {
        get
        {
            return _ItemName;
        }
        set
        {
            _ItemName = value;
        }
    }

    public virtual string TransactionID
    {
        get
        {
            return _TransactionID;
        }
        set
        {
            _TransactionID = value;
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

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Rejected_blood");
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
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.StockID = Util.GetString(StockID);
            this.ItemID = Util.GetString(ItemID);
            this.TransactionID = Util.GetString(TransactionID);
            this.Quantity = Util.GetDecimal(Quantity);
            this.ItemName = Util.GetString(ItemName);

            cmd.Parameters.Add(new MySqlParameter("@_LedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@_StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@_TransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@_Quantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@_ItemName", ItemName));

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

    #endregion All Public Member Function
}