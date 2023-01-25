using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Cssd_setstock
/// </summary>
public class Cssd_setstock
{
    #region All Properties

    private string _SetID;

    public string SetID
    {
        get { return _SetID; }
        set { _SetID = value; }
    }

    private string _StockID;

    public string StockID
    {
        get { return _StockID; }
        set { _StockID = value; }
    }

    private string _SetStockID;

    public string SetStockID
    {
        get { return _SetStockID; }
        set { _SetStockID = value; }
    }

    private string _CreatedBy;

    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }

    private int _ID;

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    #endregion All Properties

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Cssd_setstock()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Cssd_setstock(MySqlTransaction objTrans)
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
            objSQL.Append("cssd_stock_setstock");
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
            this.StockID = Util.GetString(StockID);
            this.SetStockID = Util.GetString(SetStockID);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@vSetID", SetID));
            cmd.Parameters.Add(new MySqlParameter("@vStockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@vSetStockID", SetStockID));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));

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