using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for CssdReciveSet
/// </summary>
public class CssdReciveSet
{
    #region All Properties

    private string _SetID;

    public string SetID
    {
        get { return _SetID; }
        set { _SetID = value; }
    }

    private string _SetName;

    public string SetName
    {
        get { return _SetName; }
        set { _SetName = value; }
    }

    private string _ItemID;

    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }

    private string _ItemName;

    public string ItemName
    {
        get { return _ItemName; }
        set { _ItemName = value; }
    }

    private string _UserID;

    public string UserID
    {
        get { return _UserID; }
        set { _UserID = value; }
    }

    private int _ID;

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    private int _IsActive;

    public int IsActive
    {
        get { return _IsActive; }
        set { _IsActive = value; }
    }

    private int _SetQuantity;

    public int SetQuantity
    {
        get { return _SetQuantity; }
        set { _SetQuantity = value; }
    }

    private string _StockID;

    public string StockID
    {
        get { return _StockID; }
        set { _StockID = value; }
    }

    private float _ReceivedQty;

    public float ReceivedQty
    {
        get { return _ReceivedQty; }
        set { _ReceivedQty = value; }
    }

    private int _ReturnedQty;

    public int ReturnedQty
    {
        get { return _ReturnedQty; }
        set { _ReturnedQty = value; }
    }

    private int _IsReturned;

    public int IsReturned
    {
        get { return _IsReturned; }
        set { _IsReturned = value; }
    }

    private string _SetStockID;

    public string SetStockID
    {
        get { return _SetStockID; }
        set { _SetStockID = value; }
    }

    private int _IsSetMaster;

    public int IsSetMaster
    {
        get { return _IsSetMaster; }
        set { _IsSetMaster = value; }
    }

    private int _IsProcessBatch;

    public int IsProcessBatch
    {
        get { return _IsProcessBatch; }
        set { _IsProcessBatch = value; }
    }

    private int _IsUpdateBatch;

    public int IsUpdateBatch
    {
        get { return _IsUpdateBatch; }
        set { _IsUpdateBatch = value; }
    }

    #endregion All Properties

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public CssdReciveSet()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public CssdReciveSet(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_cssd_recieve_stock");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vID";

            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 10;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.SetID = Util.GetString(SetID);
            this.SetName = Util.GetString(SetName);
            this.ItemID = Util.GetString(ItemID);
            this.ItemName = Util.GetString(ItemName);
            this.UserID = Util.GetString(UserID);
            // this.Entrydate = Util.GetDateTime(Entrydate);
            this.IsActive = Util.GetInt(IsActive);
            this.StockID = Util.GetString(StockID);
            this.SetQuantity = Util.GetInt(SetQuantity);
            this.ReceivedQty = Util.GetFloat(ReceivedQty);

            this.SetStockID = Util.GetString(SetStockID);
            this.IsSetMaster = Util.GetInt(IsSetMaster);
            this.IsProcessBatch = Util.GetInt(IsProcessBatch);
            this.IsUpdateBatch = Util.GetInt(IsUpdateBatch);

            cmd.Parameters.Add(new MySqlParameter("@vSetID", SetID));
            cmd.Parameters.Add(new MySqlParameter("@vSetName", SetName));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@vItemName", ItemName));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@vSetQuantity", SetQuantity));
            cmd.Parameters.Add(new MySqlParameter("@vStockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@vReceivedQty", ReceivedQty));
            // cmd.Parameters.Add(new MySqlParameter("@vEntrydate", Entrydate));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@vSetStockID", SetStockID));
            cmd.Parameters.Add(new MySqlParameter("@vIsSetMaster", IsSetMaster));
            cmd.Parameters.Add(new MySqlParameter("@vIsProcessBatch", IsProcessBatch));
            cmd.Parameters.Add(new MySqlParameter("@vIsUpdateBatch", IsUpdateBatch));
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            ID = Util.GetInt(cmd.ExecuteScalar().ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ID.ToString();
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
