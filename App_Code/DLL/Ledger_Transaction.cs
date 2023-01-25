using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class Ledger_Transaction
{
    public Ledger_Transaction()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Ledger_Transaction(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _LedgerTransactionNo;
    private string _Hospital_ID;
    private string _LedgerNoCr;
    private string _LedgerNoDr;
    private string _TypeOfTnx;
    private DateTime _Date;
    private DateTime _Time;
    private string _AgainstPONo;
    private string _BillNo;
    private DateTime _BillDate;
    private string _IndentNo;
    private decimal _NetAmount;
    private int  _TransactionType_ID;
    private decimal _GrossAmount;
    private decimal _DiscountOnTotal;
    private string _DiscountReason;
    private string _InvoiceNo;
    private string _ChalanNo;
    private string _CancelReason;
    private DateTime _CancelDate;
    private string _Cancel_UserID;
    private string _CancelAgainstLedgerNo;
    private int _IsCancel;
    private int _IsPaid;
    private string _PatientID;
    private int _PaymentModeID;
    private string _Remarks;
    private int _PanelID;
    private string _UserID;
    private string _TransactionID;
    private int _PatientType_ID;
    private decimal _RoundOff;
    private string _DeptLedgerNo;
    private string _EditUserID;
    private DateTime _EditDateTime;
    private string _EditReason;
    private string _EditType;
    private string _UniqueHash;
    private string _IpAddress;
    private string _DiscountApproveBy;   
    private string _GatePassInvoice;
    private decimal _Freight;
    private decimal _Octori;
    private decimal _Adjustment;
    private decimal _GovTaxPer;
    private decimal _GovTaxAmount;
    private string _Refund_Against_BillNo;
    private string _IPNo;
    private int _CentreID;
    private string _PatientType;
    private string _CurrentAge;
    private int _isOTCollection;
    private int _isOTReturn;
    private int _FieldBoyID;
    private int _EncounterNo;
    private string _SessionId;

    private int _PoolNr;
    private string _PoolDesc;


    //Challan Work 
    private string _WayBillNo;
    private DateTime _WayBillDate;

    [System.ComponentModel.DefaultValue(0)]
    private decimal _OtherCharges;
    //
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string HospCode { get { return _HospCode; } set { _HospCode = value; } }
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string LedgerTransactionNo { get { return _LedgerTransactionNo; } set { _LedgerTransactionNo = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual string LedgerNoCr { get { return _LedgerNoCr; } set { _LedgerNoCr = value; } }
    public virtual string LedgerNoDr { get { return _LedgerNoDr; } set { _LedgerNoDr = value; } }
    public virtual string TypeOfTnx { get { return _TypeOfTnx; } set { _TypeOfTnx = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual DateTime Time { get { return _Time; } set { _Time = value; } }
    public virtual string AgainstPONo { get { return _AgainstPONo; } set { _AgainstPONo = value; } }
    public virtual string BillNo { get { return _BillNo; } set { _BillNo = value; } }
    public virtual DateTime BillDate { get { return _BillDate; } set { _BillDate = value; } }
    public virtual string IndentNo { get { return _IndentNo; } set { _IndentNo = value; } }
    public virtual decimal NetAmount { get { return _NetAmount; } set { _NetAmount = value; } }
    public virtual int TransactionType_ID { get { return _TransactionType_ID; } set { _TransactionType_ID = value; } }
    public virtual decimal GrossAmount { get { return _GrossAmount; } set { _GrossAmount = value; } }
    public virtual decimal DiscountOnTotal { get { return _DiscountOnTotal; } set { _DiscountOnTotal = value; } }
    public virtual string DiscountReason { get { return _DiscountReason; } set { _DiscountReason = value; } }
    public virtual string InvoiceNo { get { return _InvoiceNo; } set { _InvoiceNo = value; } }
    public virtual string ChalanNo { get { return _ChalanNo; } set { _ChalanNo = value; } }
    public virtual string CancelReason { get { return _CancelReason; } set { _CancelReason = value; } }
    public virtual DateTime CancelDate { get { return _CancelDate; } set { _CancelDate = value; } }
    public virtual string Cancel_UserID { get { return _Cancel_UserID; } set { _Cancel_UserID = value; } }
    public virtual string CancelAgainstLedgerNo { get { return _CancelAgainstLedgerNo; } set { _CancelAgainstLedgerNo = value; } }
    public virtual int IsCancel { get { return _IsCancel; } set { _IsCancel = value; } }
    public virtual int IsPaid { get { return _IsPaid; } set { _IsPaid = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual int PatientType_ID { get { return _PatientType_ID; } set { _PatientType_ID = value; } }
    public virtual decimal RoundOff { get { return _RoundOff; } set { _RoundOff = value; } }
    public virtual string DeptLedgerNo { get { return _DeptLedgerNo; } set { _DeptLedgerNo = value; } }
    public virtual string EditUserID { get { return _EditUserID; } set { _EditUserID = value; } }
    public virtual DateTime EditDateTime { get { return _EditDateTime; } set { _EditDateTime = value; } }
    public virtual string EditReason { get { return _EditReason; } set { _EditReason = value; } }
    public virtual string EditType { get { return _EditType; } set { _EditType = value; } }
    public virtual string UniqueHash { get { return _UniqueHash; } set { _UniqueHash = value; } }
    public virtual string IpAddress { get { return _IpAddress; } set { _IpAddress = value; } }
    public virtual string DiscountApproveBy { get { return _DiscountApproveBy; } set { _DiscountApproveBy = value; } }
    
    public virtual string GatePassInWard { get { return _GatePassInvoice; } set { _GatePassInvoice = value; } }
    public virtual string Refund_Against_BillNo { get { return _Refund_Against_BillNo; } set { _Refund_Against_BillNo = value; } }
    public virtual decimal Octori
    {
        get { return _Octori; }
        set { _Octori = value; }
    }

    public virtual decimal Freight
    {
        get
        {
            return _Freight;
        }
        set
        {
            _Freight = value;
        }
    }
    public virtual decimal Adjustment { get { return _Adjustment; } set { _Adjustment = value; } }
    public virtual decimal GovTaxPer { get { return _GovTaxPer; } set { _GovTaxPer = value; } }
    public virtual decimal GovTaxAmount { get { return _GovTaxAmount; } set { _GovTaxAmount = value; } }
    public virtual string IPNo { get { return _IPNo; } set { _IPNo = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string PatientType { get { return _PatientType; } set { _PatientType = value; } }
    public virtual string CurrentAge { get { return _CurrentAge; } set { _CurrentAge = value; } }
    public virtual int isOTCollection { get { return _isOTCollection; } set { _isOTCollection = value; } }
    public virtual int isOTReturn { get { return _isOTReturn; } set { _isOTReturn = value; } }
    public virtual int FieldBoyID { get { return _FieldBoyID; } set { _FieldBoyID = value; } }
    public virtual int EncounterNo { get { return _EncounterNo; } set { _EncounterNo = value; } }
    public virtual string SessionID { get { return _SessionId; } set { _SessionId = value; } }



    public virtual int PoolNr { get { return _PoolNr; } set { _PoolNr = value; } }
    public virtual string PoolDesc { get { return _PoolDesc; } set { _PoolDesc = value; } }


    //Challan Work
    public virtual string WayBillNo { get { return _WayBillNo; } set { _WayBillNo = value; } }
    public virtual DateTime WayBillDate { get { return _WayBillDate; } set { _WayBillDate = value; } }
    public virtual decimal OtherCharges { get { return _OtherCharges; } set { _OtherCharges = value; } }


    //
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        
        try
        {
            string LedgerTransactionNo = "";
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("f_ledgertransaction_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            if ((UniqueHash == null) || (UniqueHash == ""))
                UniqueHash = Util.getHash();
            MySqlParameter LedTxnID = new MySqlParameter();
            LedTxnID.ParameterName = "@vLedgerTransactionNo";

            LedTxnID.MySqlDbType = MySqlDbType.VarChar;
            LedTxnID.Size = 50;
            LedTxnID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "PURCHASE")
            {

                    this.Location = AllGlobalFunction.LocationPur;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "IPD-LAB")
            {
                this.Location = AllGlobalFunction.LabIPD;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "OPD-LAB")
            {
                this.Location = AllGlobalFunction.LabOPD;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "PATIENT-RETURN")
            {
                this.Location = AllGlobalFunction.LocationPatReturn;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "STOCKADJUSTMENT")
            {
                this.Location = AllGlobalFunction.LocationAdjust;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "STOCKUPDATE")
            {
                this.Location = AllGlobalFunction.LocationUpdate;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "NMPURCHASE")
            {

                    this.Location = AllGlobalFunction.LocationNMPurchase;
            }

            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "NONMEDICALADJUSTMENT")
            {
                this.Location = AllGlobalFunction.NonMedicalAdjust;
            }

            else
            {
                this.Location = AllGlobalFunction.Location;
            }
            if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "NMPURCHASE")
            {
                this.HospCode = AllGlobalFunction.StroeHospCode;
            }
            else if (this.TypeOfTnx != null && this.TypeOfTnx.ToUpper() == "PURCHASE")
            {
                this.HospCode = AllGlobalFunction.StroeHospCode;
            }
            else
            {
                this.HospCode = AllGlobalFunction.HospCode;
            }

            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", Util.GetString(HospCode)));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerNoCr", Util.GetString(LedgerNoCr)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerNoDr", Util.GetString(LedgerNoDr)));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfTnx", Util.GetString(TypeOfTnx)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vTime", Util.GetDateTime(Time)));
            cmd.Parameters.Add(new MySqlParameter("@vAgainstPONo", Util.GetString(AgainstPONo)));
            cmd.Parameters.Add(new MySqlParameter("@vBillNo", Util.GetString(BillNo)));
            cmd.Parameters.Add(new MySqlParameter("@vBillDate", Util.GetDateTime(BillDate)));
            cmd.Parameters.Add(new MySqlParameter("@vIndentNo", Util.GetString(IndentNo)));
            cmd.Parameters.Add(new MySqlParameter("@vNetAmount", Util.GetDecimal(NetAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionType_ID", Util.GetInt(TransactionType_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vGrossAmount", Util.GetDecimal(GrossAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountOnTotal", Util.GetDecimal(DiscountOnTotal)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountReason", Util.GetString(DiscountReason)));
            cmd.Parameters.Add(new MySqlParameter("@vInvoiceNo", Util.GetString(InvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@vChalanNo", Util.GetString(ChalanNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelReason", Util.GetString(CancelReason)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelDate", Util.GetDateTime(CancelDate)));
            cmd.Parameters.Add(new MySqlParameter("@vCancel_UserID", Util.GetString(Cancel_UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vCancelAgainstLedgerNo", Util.GetString(CancelAgainstLedgerNo)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCancel", Util.GetInt(IsCancel)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPaid", Util.GetInt(IsPaid)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", Util.GetInt(PaymentModeID)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetInt(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientType_ID", Util.GetInt(PatientType_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vRoundOff", Util.GetDecimal(RoundOff)));
            cmd.Parameters.Add(new MySqlParameter("@vDeptLedgerNo", Util.GetString(DeptLedgerNo)));
            cmd.Parameters.Add(new MySqlParameter("@vEditUserID", Util.GetString(EditUserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEditDateTime", Util.GetDateTime(EditDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vEditReason", Util.GetString(EditReason)));
            cmd.Parameters.Add(new MySqlParameter("@vEditType", Util.GetString(EditType)));
            cmd.Parameters.Add(new MySqlParameter("@vUniqueHash", Util.GetString(UniqueHash)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountApproveBy", Util.GetString(DiscountApproveBy)));            
            cmd.Parameters.Add(new MySqlParameter("@vGatePassIn", Util.GetString(GatePassInWard)));
            cmd.Parameters.Add(new MySqlParameter("@vFreight", Util.GetDecimal(Freight)));
            cmd.Parameters.Add(new MySqlParameter("@vOctori", Util.GetDecimal(Octori)));
            cmd.Parameters.Add(new MySqlParameter("@vAdjustment", Util.GetDecimal(Adjustment)));
            cmd.Parameters.Add(new MySqlParameter("@vGovTaxPer", Util.GetDecimal(GovTaxPer)));
            cmd.Parameters.Add(new MySqlParameter("@vGovTaxAmount", Util.GetDecimal(GovTaxAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vRefund_Against_BillNo", Util.GetString(Refund_Against_BillNo)));
            cmd.Parameters.Add(new MySqlParameter("@vIPNo", Util.GetString(IPNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientType", Util.GetString(PatientType)));
            cmd.Parameters.Add(new MySqlParameter("@vCurrentAge", Util.GetString(CurrentAge)));
            cmd.Parameters.Add(new MySqlParameter("@visOTCollection", Util.GetInt(isOTCollection)));
            cmd.Parameters.Add(new MySqlParameter("@visOTReturn", Util.GetInt(isOTReturn)));
            cmd.Parameters.Add(new MySqlParameter("@vFieldBoyID", Util.GetInt(FieldBoyID)));
            cmd.Parameters.Add(new MySqlParameter("@vWayBillNo",Util.GetString(WayBillNo)));
            cmd.Parameters.Add(new MySqlParameter("@vWayBillDate",Util.GetDateTime(WayBillDate)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherCharges", Util.GetDecimal(OtherCharges)));

            cmd.Parameters.Add(new MySqlParameter("@EncounterNo", Util.GetInt(EncounterNo)));
            cmd.Parameters.Add(new MySqlParameter("@SessionID", Util.GetString(SessionID)));


            cmd.Parameters.Add(new MySqlParameter("@PoolNr", Util.GetInt(PoolNr)));
            cmd.Parameters.Add(new MySqlParameter("@PoolDesc", Util.GetString(PoolDesc)));



            cmd.Parameters.Add(LedTxnID);
            LedgerTransactionNo = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return LedgerTransactionNo;
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



    #endregion

}
