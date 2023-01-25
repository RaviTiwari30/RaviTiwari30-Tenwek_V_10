using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for cssd_f_batch_tnxdetails
/// </summary>
public class cssd_f_batch_tnxdetails
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public cssd_f_batch_tnxdetails()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public cssd_f_batch_tnxdetails(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Properties

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

    private string _ItemName;

    public string ItemName
    {
        get { return _ItemName; }
        set { _ItemName = value; }
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

    private int _IsSet;

    public int IsSet
    {
        get { return _IsSet; }
        set { _IsSet = value; }
    }

    private int _SetTnxID;

    public int SetTnxID
    {
        get { return _SetTnxID; }
        set { _SetTnxID = value; }
    }

    private string _SetStockID;

    public string SetStockID
    {
        get { return _SetStockID; }
        set { _SetStockID = value; }
    }

    private string _processType;
    public string processType { get { return _processType; } set { _processType = value; } }
    private string _requestReturnId;
    public string requestReturnId { get { return _requestReturnId; } set { _requestReturnId = value; } }

    #endregion Properties

    #region functions

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_cssd_f_batch_tnxdetails");
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

            //`Insert_cssd_f_batch_tnxdetails`(IN _SetID VARCHAR(50),
            //IN _SetName VARCHAR(200),
            //IN _StockID VARCHAR(50),IN _BatchNo VARCHAR(50),IN _BatchName  VARCHAR(200),
            //IN _ItemID  VARCHAR(50), IN _ItemName VARCHAR(200),
            //IN _Quantity INT(10),IN _BoilerType VARCHAR(50),IN _BoilerName VARCHAR(100),IN _startDate DATETIME,IN _EndDate DATETIME,
            //IN _UserID VARCHAR(50),
            //IN _Remark VARCHAR(50),IN _IsProcess VARCHAR(20)
            //,OUT _ID INT(10))

            this.SetID = Util.GetString(SetID);
            this.SetName = Util.GetString(SetName);
            this.StockID = Util.GetString(StockID);
            this.BatchName = Util.GetString(BatchName); ;
            this.BatchNo = Util.GetString(BatchNo);
            this.ItemID = Util.GetString(ItemID);
            this.ItemName = Util.GetString(ItemName);
            this.Quantity = Util.GetInt(Quantity);
            this.BoilerType = Util.GetString(BoilerType);
            this.BoilerName = Util.GetString(BoilerName);
            this.startDate = Util.GetDateTime(startDate);
            this.EndDate = Util.GetDateTime(EndDate);
            //this.EntryDate = Util.GetDateTime(EntryDate);
            this.UserID = Util.GetString(UserID);
            this.Remark = Util.GetString(Remark);
            this.IsProcess = Util.GetInt(IsProcess);
            this.SetStockID = Util.GetString(SetStockID);
            this.IsSet = Util.GetInt(IsSet);
            this.SetTnxID = Util.GetInt(SetTnxID);
            this.processType = Util.GetString(processType);
            this.requestReturnId = Util.GetString(requestReturnId);

            cmd.Parameters.Add(new MySqlParameter("@_SetID", SetID));
            cmd.Parameters.Add(new MySqlParameter("@_SetName", SetName));
            cmd.Parameters.Add(new MySqlParameter("@_StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@_BatchName", BatchName));
            cmd.Parameters.Add(new MySqlParameter("@_BatchNo", BatchNo));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@_ItemName", ItemName));
            cmd.Parameters.Add(new MySqlParameter("@_Quantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@_BoilerType", BoilerType));
            cmd.Parameters.Add(new MySqlParameter("@_BoilerName", BoilerName));
            cmd.Parameters.Add(new MySqlParameter("@_startDate", startDate));
            cmd.Parameters.Add(new MySqlParameter("@_EndDate", EndDate));
            //cmd.Parameters.Add(new MySqlParameter("@_EntryDate", EntryDate));
            cmd.Parameters.Add(new MySqlParameter("@_UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@_Remark", Remark));
            cmd.Parameters.Add(new MySqlParameter("@_IsProcess", IsProcess));
            cmd.Parameters.Add(new MySqlParameter("@_SetStockID", SetStockID));
            cmd.Parameters.Add(new MySqlParameter("@_IsSet", IsSet));
            cmd.Parameters.Add(new MySqlParameter("@_SetTnxID", SetTnxID));
            cmd.Parameters.Add(new MySqlParameter("@_processType", processType));
            cmd.Parameters.Add(new MySqlParameter("@_requestReturnId", requestReturnId));

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
