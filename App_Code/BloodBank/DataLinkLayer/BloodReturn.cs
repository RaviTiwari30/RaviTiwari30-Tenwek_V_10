using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodReturn
/// </summary>
public class BloodReturn
{
    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;
    private string _IssueId;

    public string IssueId
    {
        get { return _IssueId; }
        set { _IssueId = value; }
    }

    private int _ComponentID;

    public int ComponentID
    {
        get { return _ComponentID; }
        set { _ComponentID = value; }
    }

    private string _ComponentName;

    public string ComponentName
    {
        get { return _ComponentName; }
        set { _ComponentName = value; }
    }

    private string _Stock_ID;

    public string Stock_ID
    {
        get { return _Stock_ID; }
        set { _Stock_ID = value; }
    }

    private string _PatientID;

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }

    private string _TransactionID;

    public string TransactionID
    {
        get { return _TransactionID; }
        set { _TransactionID = value; }
    }

    private int _CentreId;

    public int CentreId
    {
        get { return _CentreId; }
        set { _CentreId = value; }
    }

    private string _ItemID;

    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }

    private string _BBTubeNo;

    public string BBTubeNo
    {
        get { return _BBTubeNo; }
        set { _BBTubeNo = value; }
    }

    private decimal _ReturnVolumn;

    public decimal ReturnVolumn
    {
        get { return _ReturnVolumn; }
        set { _ReturnVolumn = value; }
    }

    private string _ReturnBy;

    public string ReturnBy
    {
        get { return _ReturnBy; }
        set { _ReturnBy = value; }
    }

    private string _LedgerTransactionNo;

    public string LedgerTransactionNo
    {
        get { return _LedgerTransactionNo; }
        set { _LedgerTransactionNo = value; }
    }

    private string _LedgerTnxID;

    public string LedgerTnxID
    {
        get { return _LedgerTnxID; }
        set { _LedgerTnxID = value; }
    }

    public BloodReturn()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodReturn(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Return_blood");
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
            this.IssueId = Util.GetString(IssueId);
            this.ComponentID = Util.GetInt(ComponentID);
            this.ComponentName = Util.GetString(ComponentName);
            this.Stock_ID = Util.GetString(Stock_ID);
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);

            this.CentreId = Util.GetInt(CentreId);
            this.ItemID = Util.GetString(ItemID);

            this.BBTubeNo = Util.GetString(BBTubeNo);

            this.ReturnVolumn = Util.GetDecimal(ReturnVolumn);
            this.ReturnBy = Util.GetString(ReturnBy);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.LedgerTnxID = Util.GetString(LedgerTnxID);
            cmd.Parameters.Add(new MySqlParameter("@_IssueId", IssueId));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentID", ComponentID));
            cmd.Parameters.Add(new MySqlParameter("@_ComponentName", ComponentName));
            cmd.Parameters.Add(new MySqlParameter("@_Stock_ID", Stock_ID));
            cmd.Parameters.Add(new MySqlParameter("@_PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@_TransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreId));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            cmd.Parameters.Add(new MySqlParameter("@_ReturnVolumn", ReturnVolumn));
            cmd.Parameters.Add(new MySqlParameter("@_ReturnBy", ReturnBy));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTnxID", LedgerTnxID));
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
}