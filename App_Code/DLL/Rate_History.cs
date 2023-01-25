using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Rate_History
/// </summary>
public class Rate_History
{
    #region All Memory Variables

    private int _ID;
    private string _LedgerTnxNo;
    private string _Item_ID;
    private string _ItemName;
    private string _BatchNo;
    private decimal _Rate;
    private decimal _MRP;
    private decimal _DiscAmt;
    private decimal _DiscPer;
    private decimal _PurTaxPer;
    private decimal _PurTaxAmt;
    private decimal _UnitPrice;
    private DateTime _ExpiryDate;
    private string _LastUpdatedBy;
    private DateTime _LastUpdatedDate;
    private string _CreatedBy;
    private DateTime _CreatedDate;
    private string _Centre_ID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Rate_History()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Rate_History(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public string LedgerTnxNo
    {
        get { return _LedgerTnxNo; }
        set { _LedgerTnxNo = value; }
    }

    public string Item_ID
    {
        get { return _Item_ID; }
        set { _Item_ID = value; }
    }

    public string ItemName
    {
        get { return _ItemName; }
        set { _ItemName = value; }
    }

    public string BatchNo
    {
        get { return _BatchNo; }
        set { _BatchNo = value; }
    }

    public decimal Rate
    {
        get { return _Rate; }
        set { _Rate = value; }
    }

    public decimal MRP
    {
        get { return _MRP; }
        set { _MRP = value; }
    }

    public decimal DiscAmt
    {
        get { return _DiscAmt; }
        set { _DiscAmt = value; }
    }

    public decimal DiscPer
    {
        get { return _DiscPer; }
        set { _DiscPer = value; }
    }

    public decimal PurTaxPer
    {
        get { return _PurTaxPer; }
        set { _PurTaxPer = value; }
    }

    public decimal PurTaxAmt
    {
        get { return _PurTaxAmt; }
        set { _PurTaxAmt = value; }
    }

    public decimal UnitPrice
    {
        get { return _UnitPrice; }
        set { _UnitPrice = value; }
    }

    public DateTime ExpiryDate
    {
        get { return _ExpiryDate; }
        set { _ExpiryDate = value; }
    }

    public string LastUpdatedBy
    {
        get { return _LastUpdatedBy; }
        set { _LastUpdatedBy = value; }
    }

    public DateTime LastUpdatedDate
    {
        get { return _LastUpdatedDate; }
        set { _LastUpdatedDate = value; }
    }

    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }

    public DateTime CreatedDate
    {
        get { return _CreatedDate; }
        set { _CreatedDate = value; }
    }

    public string Centre_ID
    {
        get { return _Centre_ID; }
        set { _Centre_ID = value; }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        int ID = 0;
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_f_rate_history");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vLedgerTnxNo", LedgerTnxNo));
            cmd.Parameters.Add(new MySqlParameter("@vItem_ID", Item_ID));
            cmd.Parameters.Add(new MySqlParameter("@vItemName", ItemName));
            cmd.Parameters.Add(new MySqlParameter("@vBatchNo", BatchNo));
            cmd.Parameters.Add(new MySqlParameter("@vRate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@vMRP", MRP));
            cmd.Parameters.Add(new MySqlParameter("@vDiscAmt", DiscAmt));
            cmd.Parameters.Add(new MySqlParameter("@vDiscPer", DiscPer));
            cmd.Parameters.Add(new MySqlParameter("@vPurTaxPer", PurTaxPer));
            cmd.Parameters.Add(new MySqlParameter("@vPurTaxAmt", PurTaxAmt));
            cmd.Parameters.Add(new MySqlParameter("@vUnitPrice", UnitPrice));
            cmd.Parameters.Add(new MySqlParameter("@vExpiryDate", ExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentre_ID", Centre_ID));

            ID = Convert.ToInt32(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ID;
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