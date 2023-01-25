using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class PanelLedgerAccount
{
    public PanelLedgerAccount()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PanelLedgerAccount(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }



    #region All Memory Variables
    private int _ID;
    private string _LedgerReceiptNo;
    private decimal _LedgerReceivedAmt;
    private string _LedgerNoCr;
    private int _PaymentModeID;
    private string _PaymentMode;
    private string _BankName;
    private string _ReferenceNo;
    private DateTime _ReferenceDate;
    private string _Remarks;
    private string _PanelID;
    private string _TYPE;
    private DateTime _AdvanceAmtRecievedDate;
    private decimal _AdjustmentAmount;
    private string _TnxType;
    private int _CentreID;
    private string _EntryBy;
    private string _EntryUserName;
    private int _IsClear;
    private string _ClearUserID;
    private string _ClearUserName;
    private DateTime _ClearDateTime;
    private string _ClearReason;
    private int _IsChequeBounce;
    private string _ChequeBounceUserID;
    private string _ChequeBounceUserName;
    private DateTime _ChequeBounceDateTime;
    private string _ChequeBounceReason;
    private int _IsCancel;
    private string _CancelUserID;
    private string _CancelUserName;
    private DateTime _CancelDateTime;
    private string _CancelReason;
    private DateTime _UpdateDate;
    private string _UpdateUserID;
    private string _UpdateUserName;
    private string _AdjustPatientReceiptNo;
    private string _AdjustLedgerReceiptNo;
    private string _Hospital_ID;
    private decimal _S_Amount;
    private int _S_CountryID;
    private string _S_Currency;
    private string _S_Notation;
    private decimal _C_factor;
    private decimal _Currency_RoundOff;
    private string _UpdateType;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string LedgerReceiptNo { get { return _LedgerReceiptNo; } set { _LedgerReceiptNo = value; } }
    public virtual decimal LedgerReceivedAmt { get { return _LedgerReceivedAmt; } set { _LedgerReceivedAmt = value; } }
    public virtual string LedgerNoCr { get { return _LedgerNoCr; } set { _LedgerNoCr = value; } }
    public virtual int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }
    public virtual string PaymentMode { get { return _PaymentMode; } set { _PaymentMode = value; } }
    public virtual string BankName { get { return _BankName; } set { _BankName = value; } }
    public virtual string ReferenceNo { get { return _ReferenceNo; } set { _ReferenceNo = value; } }
    public virtual DateTime ReferenceDate { get { return _ReferenceDate; } set { _ReferenceDate = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual string PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string TYPE { get { return _TYPE; } set { _TYPE = value; } }
    public virtual DateTime AdvanceAmtRecievedDate { get { return _AdvanceAmtRecievedDate; } set { _AdvanceAmtRecievedDate = value; } }
    public virtual decimal AdjustmentAmount { get { return _AdjustmentAmount; } set { _AdjustmentAmount = value; } }
    public virtual string TnxType { get { return _TnxType; } set { _TnxType = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
    public virtual string EntryUserName { get { return _EntryUserName; } set { _EntryUserName = value; } }
    public virtual int IsClear { get { return _IsClear; } set { _IsClear = value; } }
    public virtual string ClearUserID { get { return _ClearUserID; } set { _ClearUserID = value; } }
    public virtual DateTime ClearDateTime { get { return _ClearDateTime; } set { _ClearDateTime = value; } }
    public virtual string ClearUserName { get { return _ClearUserName; } set { _ClearUserName = value; } }
    public virtual string ClearReason { get { return _ClearReason; } set { _ClearReason = value; } }
    public virtual int IsChequeBounce { get { return _IsChequeBounce; } set { _IsChequeBounce = value; } }
    public virtual string ChequeBounceUserID { get { return _ChequeBounceUserID; } set { _ChequeBounceUserID = value; } }
    public virtual DateTime ChequeBounceDateTime { get { return _ChequeBounceDateTime; } set { _ChequeBounceDateTime = value; } }
    public virtual string ChequeBounceUserName { get { return _ChequeBounceUserName; } set { _ChequeBounceUserName = value; } }
    public virtual string ChequeBounceReason { get { return _ChequeBounceReason; } set { _ChequeBounceReason = value; } }
    public virtual int IsCancel { get { return _IsCancel; } set { _IsCancel = value; } }
    public virtual string CancelUserID { get { return _CancelUserID; } set { _CancelUserID = value; } }
    public virtual DateTime CancelDateTime { get { return _CancelDateTime; } set { _CancelDateTime = value; } }
    public virtual string CancelUserName { get { return _CancelUserName; } set { _CancelUserName = value; } }
    public virtual string CancelReason { get { return _CancelReason; } set { _CancelReason = value; } }
    public virtual string UpdateUserID { get { return _UpdateUserID; } set { _UpdateUserID = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }
    public virtual string UpdateUserName { get { return _UpdateUserName; } set { _UpdateUserName = value; } }
    public virtual string AdjustPatientReceiptNo { get { return _AdjustPatientReceiptNo; } set { _AdjustPatientReceiptNo = value; } }
    public virtual string AdjustLedgerReceiptNo { get { return _AdjustLedgerReceiptNo; } set { _AdjustLedgerReceiptNo = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual int S_CountryID { get { return _S_CountryID; } set { _S_CountryID = value; } }
    public virtual decimal S_Amount { get { return _S_Amount; } set { _S_Amount = value; } }
    public virtual string S_Currency { get { return _S_Currency; } set { _S_Currency = value; } }
    public virtual string S_Notation { get { return _S_Notation; } set { _S_Notation = value; } }
    public virtual decimal C_factor { get { return _C_factor; } set { _C_factor = value; } }
    public virtual decimal Currency_RoundOff { get { return _Currency_RoundOff; } set { _Currency_RoundOff = value; } }
    public virtual string UpdateType { get { return _UpdateType; } set { _UpdateType = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_panel_ledgeraccount");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlParameter LedgerRecptID = new MySqlParameter();
            LedgerRecptID.ParameterName = "@ID";
            LedgerRecptID.MySqlDbType = MySqlDbType.VarChar;
            LedgerRecptID.Size = 50;
            LedgerRecptID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@LedgerReceipt_No", Util.GetString(LedgerReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerReceivedAmt", Util.GetDecimal(LedgerReceivedAmt)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerNoCr", Util.GetString(LedgerNoCr)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentModeID", Util.GetInt(PaymentModeID)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentMode", Util.GetString(PaymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@BankName", Util.GetString(BankName)));
            cmd.Parameters.Add(new MySqlParameter("@ReferenceNo", Util.GetString(ReferenceNo)));
            cmd.Parameters.Add(new MySqlParameter("@ReferenceDate", Util.GetDateTime(ReferenceDate)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", Util.GetString(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@TYPE", Util.GetString(TYPE)));
            cmd.Parameters.Add(new MySqlParameter("@AdvanceAmtRecievedDate", Util.GetDateTime(AdvanceAmtRecievedDate)));
            cmd.Parameters.Add(new MySqlParameter("@TnxType", Util.GetString(TnxType)));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@EntryBy", Util.GetString(EntryBy)));
            cmd.Parameters.Add(new MySqlParameter("@EntryUserName", Util.GetString(EntryUserName)));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@S_Amount", Util.GetDecimal(S_Amount)));
            cmd.Parameters.Add(new MySqlParameter("@S_CountryID", Util.GetInt(S_CountryID)));
            cmd.Parameters.Add(new MySqlParameter("@S_Currency", Util.GetString(S_Currency)));
            cmd.Parameters.Add(new MySqlParameter("@S_Notation", Util.GetString(S_Notation)));
            cmd.Parameters.Add(new MySqlParameter("@C_factor", Util.GetDecimal(C_factor)));
            cmd.Parameters.Add(new MySqlParameter("@Currency_RoundOff", Util.GetDecimal(Currency_RoundOff)));
            cmd.Parameters.Add(new MySqlParameter("@AdjustmentAmount", Util.GetDecimal(AdjustmentAmount)));
            cmd.Parameters.Add(new MySqlParameter("@AdjustLedgerReceiptNo", Util.GetString(AdjustLedgerReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@AdjustPatientReceiptNo", Util.GetString(AdjustPatientReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@vIsClear", Util.GetInt(IsClear)));
            cmd.Parameters.Add(new MySqlParameter("@vClearUserID", Util.GetString(ClearUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vClearUserName", Util.GetString(ClearUserName)));
            cmd.Parameters.Add(new MySqlParameter("@vClearDateTime", Util.GetDateTime(ClearDateTime)));
            cmd.Parameters.Add(LedgerRecptID);

            ID = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Util.GetString(ID);
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

    public string Update()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Update_panel_ledgeraccount");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vLedgerReceiptNo", Util.GetString(LedgerReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@vAdjustmentAmount", Util.GetDecimal(AdjustmentAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vIsClear", Util.GetInt(IsClear)));
            cmd.Parameters.Add(new MySqlParameter("@vClearUserID", Util.GetString(ClearUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vClearUserName", Util.GetString(ClearUserName)));
            cmd.Parameters.Add(new MySqlParameter("@vClearDateTime", Util.GetDateTime(ClearDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vClearReason", Util.GetString(ClearReason)));
            cmd.Parameters.Add(new MySqlParameter("@vIsChequeBounce", Util.GetInt(IsChequeBounce)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeBounceUserID", Util.GetString(ChequeBounceUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeBounceUserName", Util.GetString(ChequeBounceUserName)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeBounceDateTime", Util.GetDateTime(ChequeBounceDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vChequeBounceReason", Util.GetString(ChequeBounceReason)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCancel", Util.GetInt(IsCancel)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelUserID", Util.GetString(CancelUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelUserName", Util.GetString(CancelUserName)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelDateTime", Util.GetDateTime(CancelDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelReason", Util.GetString(CancelReason)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateUserID", Util.GetString(UpdateUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateUserName", Util.GetString(UpdateUserName)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateType", Util.GetString(UpdateType)));

            cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return "1";
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