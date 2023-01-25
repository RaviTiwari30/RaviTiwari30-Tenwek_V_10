using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for drcrnote
/// </summary>
public class drcrnote
{



    #region All Memory Variables
    private string _CRDR;
    private string _TransactionID;
    private string _ItemID;
    private string _ItemName;
    private decimal _Amount;
    private System.DateTime _EntryDateTime;
    private string _UserID;
    private string _PtTYPE;
    private string _BillNo;
    private string _LedgerName;
    private string _Narration;
    private string _UniqueHash;
    private string _CrDrNo;
    private int _LedgerTnxID;
    private int _LedgerTransactionNo;
    private int _CentreID;
    private int _PanelID;
    private string _Type;
    private decimal _Rate;
    private int _CRDRNoteType;
    private int _isDocCollect;
    private decimal _docCollectAmt;
    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
   public drcrnote()
	{
		  objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       // this.Location = AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
	}
     public drcrnote(MySqlTransaction objTrans)
	{
		 
        this.objTrans = objTrans;
        this.IsLocalConn = false;
	}
    
    #endregion
    #region Set All Property

    public virtual string CrDrNo
    {
        get
        {
            return _CrDrNo;
        }
        set
        {
            _CrDrNo = value;
        }
    }
    public virtual string CRDR
    {
        get
        {
            return _CRDR;
        }
        set
        {
            _CRDR = value;
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
    public virtual decimal Amount
    {
        get
        {
            return _Amount;
        }
        set
        {
            _Amount = value;
        }
    }
    public virtual DateTime EntryDateTime
    {
        get
        {
            return _EntryDateTime;
        }
        set
        {
            _EntryDateTime = value;
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
    public virtual string PtTYPE
    {
        get
        {
            return _PtTYPE;
        }
        set
        {
            _PtTYPE = value;
        }
    }
    public virtual string BillNo
    {
        get
        {
            return _BillNo;
        }
        set
        {
            _BillNo = value;
        }
    }
    public virtual string LedgerName
    {
        get
        {
            return _LedgerName;
        }
        set
        {
            _LedgerName = value;
        }
    }
    public virtual string Narration
    {
        get
        {
            return _Narration;
        }
        set
        {
            _Narration = value;
        }
    }
    public virtual string UniqueHash
    {
        get
        {
            return _UniqueHash;
        }
        set
        {
            _UniqueHash = value;
        }
    }
    public virtual int LedgerTnxID
    {
        get { return _LedgerTnxID; }
        set { _LedgerTnxID = value; }
    }
    public virtual int LedgerTransactionNo
    {
        get { return _LedgerTransactionNo; }
        set { _LedgerTransactionNo = value; }
    }
    public virtual int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }
    public virtual int PanelID
    {
        get { return _PanelID; }
        set { _PanelID = value; }
    }
    public virtual string Type
    {
        get { return _Type; }
        set { _Type = value; }
    }
    public virtual int CRDRNoteType { get { return _CRDRNoteType; } set { _CRDRNoteType = value; } }
    public virtual decimal Rate { get { return _Rate; } set { _Rate = value; } }

    public int isDocCollect
    {
        get { return _isDocCollect; }
        set { _isDocCollect = value; }
    }
    public decimal docCollectAmt
    {
        get { return _docCollectAmt; }
        set { _docCollectAmt = value; }
    }

    #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {            
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_drcrnote");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            if ((UniqueHash == null) || (UniqueHash == ""))
                UniqueHash = Util.getHash();

            MySqlParameter CDNo = new MySqlParameter();
            CDNo.ParameterName = "@CrDrNo";

            CDNo.MySqlDbType = MySqlDbType.Int32;
            CDNo.Size = 11;
            CDNo.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.CRDR = Util.GetString(CRDR);
             this.TransactionID = Util.GetString(TransactionID);
             this.Amount = Util.GetDecimal(Amount);
             this.EntryDateTime = Util.GetDateTime(EntryDateTime);
             this.UserID = Util.GetString(UserID);
             this.PtTYPE = Util.GetString(PtTYPE);
             this.BillNo = Util.GetString(BillNo);
             this.LedgerName = Util.GetString(LedgerName);
             this.Narration = Util.GetString(Narration);
             this.UniqueHash = Util.GetString(UniqueHash);
             this.ItemID = Util.GetString(ItemID);
             this.ItemName = Util.GetString(ItemName);
             this.CrDrNo = CrDrNo;
             this.LedgerTnxID = Util.GetInt(LedgerTnxID);
             this.LedgerTransactionNo = Util.GetInt(LedgerTransactionNo);
             this.CentreID = Util.GetInt(CentreID);
             this.PanelID = PanelID;
             this.CRDRNoteType = CRDRNoteType;

             cmd.Parameters.Add(new MySqlParameter("@CRDR", CRDR));
             cmd.Parameters.Add(new MySqlParameter("@TransactionID", TransactionID));
             cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
             cmd.Parameters.Add(new MySqlParameter("@ItemName", ItemName));
             cmd.Parameters.Add(new MySqlParameter("@Amount", Amount));
             cmd.Parameters.Add(new MySqlParameter("@EntryDateTime", EntryDateTime));
             cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
             cmd.Parameters.Add(new MySqlParameter("@PtTYPE", PtTYPE));
             cmd.Parameters.Add(new MySqlParameter("@BillNo", BillNo));
             cmd.Parameters.Add(new MySqlParameter("@LedgerName", LedgerName));
             cmd.Parameters.Add(new MySqlParameter("@Narration", Narration));
             cmd.Parameters.Add(new MySqlParameter("@UniqueHash", UniqueHash));
             cmd.Parameters.Add(new MySqlParameter("@creditDebitNumber", CrDrNo));
             cmd.Parameters.Add(new MySqlParameter("@LedgerTnxID", LedgerTnxID));
             cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
             cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
             cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
             cmd.Parameters.Add(new MySqlParameter("@CRDRNoteType", CRDRNoteType));
             cmd.Parameters.Add(CDNo);
             string str = "";
             foreach (MySqlParameter pr in cmd.Parameters)
             {
                 str = str+pr.ParameterName + "," + pr.Value;
             }
          //  cmd.Parameters.Add(new MySqlParameter("@UniqueHash", UniqueHash));
          CrDrNo = Util.GetString(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return CrDrNo;
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
    #endregion
}
