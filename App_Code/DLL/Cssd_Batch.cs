using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Cssd_Batch
/// </summary>
public class Cssd_Batch
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Cssd_Batch()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Cssd_Batch(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Properties

    private int _ID;

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    private string _StockID;

    public string StockID
    {
        get { return _StockID; }
        set { _StockID = value; }
    }

    private string _BatchNo;

    public string BatchNo
    {
        get { return _BatchNo; }
        set { _BatchNo = value; }
    }

    private string _BatchName;

    public string BatchName
    {
        get { return _BatchName; }
        set { _BatchName = value; }
    }

    private string _ItemID;

    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }

    private string _Item_Name;

    public string Item_Name
    {
        get { return _Item_Name; }
        set { _Item_Name = value; }
    }

    private int _Quantity;

    public int Quantity
    {
        get { return _Quantity; }
        set { _Quantity = value; }
    }

    private string _BoilerType;

    public string BoilerType
    {
        get { return _BoilerType; }
        set { _BoilerType = value; }
    }

    private string _BoilerName;

    public string BoilerName
    {
        get { return _BoilerName; }
        set { _BoilerName = value; }
    }

    private DateTime _startDate;

    public DateTime startDate
    {
        get { return _startDate; }
        set { _startDate = value; }
    }

    private DateTime _EndDate;

    public DateTime EndDate
    {
        get { return _EndDate; }
        set { _EndDate = value; }
    }

    private DateTime _AstartDate;

    public DateTime AstartDate
    {
        get { return _AstartDate; }
        set { _AstartDate = value; }
    }

    private DateTime _AEndDate;

    public DateTime AEndDate
    {
        get { return _AEndDate; }
        set { _AEndDate = value; }
    }

    private DateTime _EntryDate;

    public DateTime EntryDate
    {
        get { return _EntryDate; }
        set { _EntryDate = value; }
    }

    private string _UserID;

    public string UserID
    {
        get { return _UserID; }
        set { _UserID = value; }
    }

    private int _IsFinished;

    public int IsFinished
    {
        get { return _IsFinished; }
        set { _IsFinished = value; }
    }

    private string _Remark;

    public string Remark
    {
        get { return _Remark; }
        set { _Remark = value; }
    }

    private int _IsProcess;

    public int IsProcess
    {
        get { return _IsProcess; }
        set { _IsProcess = value; }
    }

    #endregion Properties

    #region functions

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("cssd_f_batch_tnxdetails");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@_ID";

            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 10;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.StockID = Util.GetString(StockID);
            this.BatchName = Util.GetString(BatchName);

            this.ItemID = Util.GetString(ItemID);
            this.Item_Name = Util.GetString(Item_Name);
            this.Quantity = Util.GetInt(Quantity);
            this.BoilerType = Util.GetString(BoilerType);
            this.BoilerName = Util.GetString(BoilerName);
            this.startDate = Util.GetDateTime(startDate);
            this.EndDate = Util.GetDateTime(EndDate);
            this.AstartDate = Util.GetDateTime(AstartDate);
            this.AEndDate = Util.GetDateTime(AEndDate);
            this.EntryDate = Util.GetDateTime(EntryDate);
            this.UserID = Util.GetString(UserID);
            this.IsFinished = Util.GetInt(IsFinished);
            this.Remark = Util.GetString(Remark);
            this.IsProcess = Util.GetInt(IsProcess);
            this.BatchNo = Util.GetString(BatchNo);

            cmd.Parameters.Add(new MySqlParameter("@_StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@_BatchName", BatchName));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@_Item_Name", Item_Name));
            cmd.Parameters.Add(new MySqlParameter("@_Quantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@_BoilerType", BoilerType));
            cmd.Parameters.Add(new MySqlParameter("@_BoilerName", BoilerName));
            cmd.Parameters.Add(new MySqlParameter("@_startDate", startDate));
            cmd.Parameters.Add(new MySqlParameter("@_EndDate", EndDate));
            cmd.Parameters.Add(new MySqlParameter("@_AstartDate", AstartDate));
            cmd.Parameters.Add(new MySqlParameter("@_AEndDate", AEndDate));
            cmd.Parameters.Add(new MySqlParameter("@_EntryDate", EntryDate));
            cmd.Parameters.Add(new MySqlParameter("@_UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@_IsFinished", IsFinished));
            cmd.Parameters.Add(new MySqlParameter("@_Remark", Remark));
            cmd.Parameters.Add(new MySqlParameter("@_IsProcess", IsProcess));
            cmd.Parameters.Add(new MySqlParameter("@_BatchNo", BatchNo));

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

    #endregion functions
}
