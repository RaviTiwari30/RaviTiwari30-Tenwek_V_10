using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for DispatchBlood
/// </summary>
public class DispatchBlood
{
    #region All Memory Variables

    private decimal _IssueVolumn;

    private int _componentid;
    private string _DispatchBy;
    private string _PatientID;
    private int _CentreId;
    private string _TransactionID;
    private string _LedgerTransactionNo;
    private string _Stock_ID;
    private string _BBTubeNo;
    private string _BagType;
    private DateTime _Expiry;
    private string _ComponentName;
    private string _vTYPE;
    private int _IsDispatch;
    private string _DispatchTo;

    public string vTYPE
    {
        get { return _vTYPE; }
        set { _vTYPE = value; }
    }

    public string DispatchTo
    {
        get { return _DispatchTo; }
        set { _DispatchTo = value; }
    }

    public int IsDispatch
    {
        get { return _IsDispatch; }
        set { _IsDispatch = value; }
    }

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DispatchBlood()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DispatchBlood(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual decimal IssueVolumn
    {
        get
        {
            return _IssueVolumn;
        }
        set
        {
            _IssueVolumn = value;
        }
    }

    public virtual int componentid
    {
        get
        {
            return _componentid;
        }
        set
        {
            _componentid = value;
        }
    }

    public virtual string DispatchBy
    {
        get
        {
            return _DispatchBy;
        }
        set
        {
            _DispatchBy = value;
        }
    }

    public virtual string PatientID
    {
        get
        {
            return _PatientID;
        }
        set
        {
            _PatientID = value;
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

    public virtual int CentreId
    {
        get
        {
            return _CentreId;
        }
        set
        {
            _CentreId = value;
        }
    }

    public virtual string Stock_ID
    {
        get
        {
            return _Stock_ID;
        }
        set
        {
            _Stock_ID = value;
        }
    }

    public virtual string BBTubeNo
    {
        get
        {
            return _BBTubeNo;
        }
        set
        {
            _BBTubeNo = value;
        }
    }

    public virtual string BagType
    {
        get
        {
            return _BagType;
        }
        set
        {
            _BagType = value;
        }
    }

    public virtual DateTime Expiry
    {
        get
        {
            return _Expiry;
        }
        set
        {
            _Expiry = value;
        }
    }

    public virtual string ComponentName
    {
        get
        {
            return _ComponentName;
        }
        set
        {
            _ComponentName = value;
        }
    }

    #endregion Set All Property

    private string _ItemID;

    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }

    private string _LedgerTnxID;

    public string LedgerTnxID
    {
        get { return _LedgerTnxID; }
        set { _LedgerTnxID = value; }
    }

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_dispatchblood");
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
            this.IssueVolumn = Util.GetDecimal(IssueVolumn);
            this.componentid = Util.GetInt(componentid);
            this.DispatchBy = Util.GetString(DispatchBy);
            this.DispatchTo = Util.GetString(DispatchTo);
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.CentreId = Util.GetInt(CentreId);
            this.Stock_ID = Util.GetString(Stock_ID);
            this.BBTubeNo = Util.GetString(BBTubeNo);
            this.BagType = Util.GetString(BagType);
            this.Expiry = Util.GetDateTime(Expiry);
            this.ComponentName = Util.GetString(ComponentName);
            this.vTYPE = Util.GetString(vTYPE);
            this.IsDispatch = Util.GetInt(IsDispatch);
            this.ItemID = Util.GetString(ItemID);
            this.LedgerTnxID = Util.GetString(LedgerTnxID);
            //this.IsProcess = Util.GetInt(IsProcess);

            cmd.Parameters.Add(new MySqlParameter("@_IssueVolumn", IssueVolumn));
            cmd.Parameters.Add(new MySqlParameter("@_componentid", componentid));
            cmd.Parameters.Add(new MySqlParameter("@_DispatchBy", DispatchBy));
            cmd.Parameters.Add(new MySqlParameter("@_DispatchTo", DispatchTo));
            cmd.Parameters.Add(new MySqlParameter("@_PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@_TransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreId));
            cmd.Parameters.Add(new MySqlParameter("@_Stock_ID", Stock_ID));
            cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            cmd.Parameters.Add(new MySqlParameter("@_Expiry", Expiry));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentName", ComponentName));
            cmd.Parameters.Add(new MySqlParameter("@_TYPE", vTYPE));
            cmd.Parameters.Add(new MySqlParameter("@_IsDispatch", IsDispatch));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTnxID", LedgerTnxID));
            cmd.Parameters.Add(paramTnxID);
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
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    #endregion All Public Member Function
}