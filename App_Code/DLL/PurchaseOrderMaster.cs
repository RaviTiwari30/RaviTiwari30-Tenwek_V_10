#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class PurchaseOrderMaster
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _PurchaseOrderNo;
    private string _Subject;
    private string _VendorID;
    private string _VendorName;
    private DateTime _RaisedDate;
    private string _RaisedUserID;
    private string _RaisedUserName;
    private string _ApprovalTypeID;
    private int _Approved;
    private DateTime _ApprovedDate;
    private DateTime _ValidDate;
    private decimal _GrossTotal;
    private decimal _NetTotal;
    private decimal _AmountAdvance;
    private int _Status;
    private string _ReasonOfCancelation;
    private DateTime _LastUpdatedDate;
    private string _LastUpdatedUserID;
    private string _LastUpdatedUserName;
    private decimal _Freight;
    private decimal _RoundOff;
    private decimal _Scheme;
    private string _Type;
    private decimal _ExciseOnBill;
    private string _PoNumber;
    private decimal _S_Amount;
    private int _S_CountryID;
    private string _S_Currency;
    private decimal _C_Factor;
    private DateTime _DeliveryDate;
    private string _DeptLedgerNo;
    private string _StoreLedgerNo;
    private int _CentreID;
    private string _Hospital_ID;
    private string _IPAddress;
    private int _isAsset;
    private int _paymentModeID;



    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PurchaseOrderMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PurchaseOrderMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Location
    {
        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }

    public virtual string HospCode
    {
        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
        }
    }

    public virtual int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }

    public virtual string PurchaseOrderNo
    {
        get
        {
            return _PurchaseOrderNo;
        }
        set
        {
            _PurchaseOrderNo = value;
        }
    }

    public virtual string Subject
    {
        get
        {
            return _Subject;
        }
        set
        {
            _Subject = value;
        }
    }

    public virtual string VendorID
    {
        get
        {
            return _VendorID;
        }
        set
        {
            _VendorID = value;
        }
    }

    public virtual string VendorName
    {
        get
        {
            return _VendorName;
        }
        set
        {
            _VendorName = value;
        }
    }

    public virtual DateTime RaisedDate
    {
        get
        {
            return _RaisedDate;
        }
        set
        {
            _RaisedDate = value;
        }
    }

    public virtual string RaisedUserID
    {
        get
        {
            return _RaisedUserID;
        }
        set
        {
            _RaisedUserID = value;
        }
    }

    public virtual string RaisedUserName
    {
        get
        {
            return _RaisedUserName;
        }
        set
        {
            _RaisedUserName = value;
        }
    }

    public virtual string ApprovalTypeID
    {
        get
        {
            return _ApprovalTypeID;
        }
        set
        {
            _ApprovalTypeID = value;
        }
    }

    public virtual int Approved
    {
        get
        {
            return _Approved;
        }
        set
        {
            _Approved = value;
        }
    }

    public virtual DateTime ApprovedDate
    {
        get
        {
            return _ApprovedDate;
        }
        set
        {
            _ApprovedDate = value;
        }
    }

    public virtual DateTime ValidDate
    {
        get
        {
            return _ValidDate;
        }
        set
        {
            _ValidDate = value;
        }
    }

    public virtual decimal GrossTotal
    {
        get
        {
            return _GrossTotal;
        }
        set
        {
            _GrossTotal = value;
        }
    }

    public virtual decimal NetTotal
    {
        get
        {
            return _NetTotal;
        }
        set
        {
            _NetTotal = value;
        }
    }

    public virtual decimal AmountAdvance
    {
        get
        {
            return _AmountAdvance;
        }
        set
        {
            _AmountAdvance = value;
        }
    }

    public virtual int Status
    {
        get
        {
            return _Status;
        }
        set
        {
            _Status = value;
        }
    }

    public virtual string ReasonOfCancelation
    {
        get
        {
            return _ReasonOfCancelation;
        }
        set
        {
            _ReasonOfCancelation = value;
        }
    }

    public virtual DateTime LastUpdatedDate
    {
        get
        {
            return _LastUpdatedDate;
        }
        set
        {
            _LastUpdatedDate = value;
        }
    }

    public virtual string LastUpdatedUserID
    {
        get
        {
            return _LastUpdatedUserID;
        }
        set
        {
            _LastUpdatedUserID = value;
        }
    }

    public virtual string LastUpdatedUserName
    {
        get
        {
            return _LastUpdatedUserName;
        }
        set
        {
            _LastUpdatedUserName = value;
        }
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

    private DateTime _ByDate;

    public virtual DateTime ByDate
    {
        get { return _ByDate; }
        set { _ByDate = value; }
    }

    private string _Remarks;

    public virtual string Remarks
    {
        get { return _Remarks; }
        set { _Remarks = value; }
    }

    public virtual decimal RoundOff
    {
        get
        {
            return _RoundOff;
        }
        set
        {
            _RoundOff = value;
        }
    }

    public virtual decimal Scheme
    {
        get
        {
            return _Scheme;
        }
        set
        {
            _Scheme = value;
        }
    }

    public virtual string Type
    {
        get
        {
            return _Type;
        }
        set
        {
            _Type = value;
        }
    }

    public virtual decimal ExciseOnBill
    {
        get
        {
            return _ExciseOnBill;
        }
        set
        {
            _ExciseOnBill = value;
        }
    }

    public virtual string PoNumber
    {
        get
        {
            return _PoNumber;
        }
        set
        {
            _PoNumber = value;
        }
    }

    public virtual decimal S_Amount
    {
        get
        {
            return _S_Amount;
        }
        set
        {
            _S_Amount = value;
        }
    }

    public virtual int S_CountryID
    {
        get
        {
            return _S_CountryID;
        }
        set
        {
            _S_CountryID = value;
        }
    }

    public virtual string S_Currency
    {
        get
        {
            return _S_Currency;
        }
        set
        {
            _S_Currency = value;
        }
    }

    public virtual decimal C_Factor
    {
        get
        {
            return _C_Factor;
        }
        set
        {
            _C_Factor = value;
        }
    }

    public virtual DateTime DeliveryDate
    {
        get
        {
            return _DeliveryDate;
        }
        set
        {
            _DeliveryDate = value;
        }
    }

    public virtual string DeptLedgerNo
    {
        get
        {
            return _DeptLedgerNo;
        }
        set
        {
            _DeptLedgerNo = value;
        }
    }

    public virtual string StoreLedgerNo
    {
        get
        {
            return _StoreLedgerNo;
        }
        set
        {
            _StoreLedgerNo = value;
        }
    }

    public virtual int CentreID
    {
        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
        }
    }

    public virtual string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
        }
    }

    public virtual string IPAddress
    {
        get
        {
            return _IPAddress;
        }
        set
        {
            _IPAddress = value;
        }
    }

    public virtual int IsAsset
    {
        get { return _isAsset; }
        set { _isAsset = value; }
    }



    private decimal _OtherCharges;

    public decimal OtherCharges
    {
        get { return _OtherCharges; }
        set { _OtherCharges = value; }
    }


    private string _DocumentPath;

    public string DocumentPath
    {
        get { return _DocumentPath; }
        set { _DocumentPath = value; }
    }


    private int _IsService;

    public int IsService
    {
        get { return _IsService; }
        set { _IsService = value; }
    }


    //private decimal _advanceAmount;
    //public decimal advanceAmount
    //{
    //    get { return _advanceAmount; }
    //    set { _advanceAmount = value; }
    //}


    public int paymentModeID
    {
        get { return _paymentModeID; }
        set { _paymentModeID = value; }
    }




    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PurchaseOrder");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PoNumber";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.InputOutput;
            paramTnxID.Value = PoNumber;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Subject = Util.GetString(Subject);
            this.VendorID = Util.GetString(VendorID);
            this.VendorName = Util.GetString(VendorName);
            this.RaisedDate = Util.GetDateTime(RaisedDate);
            this.RaisedUserID = Util.GetString(RaisedUserID);
            this.RaisedUserName = Util.GetString(RaisedUserName);
            this.ApprovalTypeID = Util.GetString(ApprovalTypeID);
            this.Approved = Util.GetInt(Approved);
            this.ApprovedDate = Util.GetDateTime(ApprovedDate);
            this.ValidDate = Util.GetDateTime(ValidDate);
            this.GrossTotal = Util.GetDecimal(GrossTotal);
            this.NetTotal = Util.GetDecimal(NetTotal);
            this.AmountAdvance = Util.GetDecimal(AmountAdvance);
            this.Status = Util.GetInt(Status);
            this.ReasonOfCancelation = Util.GetString(ReasonOfCancelation);
            this.LastUpdatedDate = Util.GetDateTime(LastUpdatedDate);
            this.LastUpdatedUserID = Util.GetString(LastUpdatedUserID);
            this.LastUpdatedUserName = Util.GetString(LastUpdatedUserName);
            this.Freight = Util.GetDecimal(Freight);
            this.Remarks = Util.GetString(Remarks);
            this.ByDate = Util.GetDateTime(ByDate);
            this.RoundOff = Util.GetDecimal(RoundOff);
            this.Scheme = Util.GetDecimal(Scheme);
            this.Type = Util.GetString(Type);
            this.ExciseOnBill = Util.GetDecimal(ExciseOnBill);
            this.S_Amount = Util.GetDecimal(S_Amount);
            this.S_CountryID = Util.GetInt(S_CountryID);
            this.S_Currency = Util.GetString(S_Currency);
            this.C_Factor = Util.GetDecimal(C_Factor);
            this.DeliveryDate = Util.GetDateTime(DeliveryDate);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.StoreLedgerNo = Util.GetString(StoreLedgerNo);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.IPAddress = Util.GetString(IPAddress);
            this.IsAsset = _isAsset;
            this.OtherCharges = Util.GetDecimal(OtherCharges);
            this.DocumentPath = Util.GetString(DocumentPath);
            this.IsService = Util.GetInt(IsService);
            this.paymentModeID = Util.GetInt(paymentModeID);


            cmd.Parameters.Add(new MySqlParameter("@vLoc", Location));
            cmd.Parameters.Add(new MySqlParameter("@vHosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@vSubject", Subject));
            cmd.Parameters.Add(new MySqlParameter("@vVendorID", VendorID));
            cmd.Parameters.Add(new MySqlParameter("@vVendorName", VendorName));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedDate", RaisedDate));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedUserID", RaisedUserID));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedUserName", RaisedUserName));
            cmd.Parameters.Add(new MySqlParameter("@vApprovalTypeID", ApprovalTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vApproved", Approved));
            cmd.Parameters.Add(new MySqlParameter("@vApprovedDate", ApprovedDate));
            cmd.Parameters.Add(new MySqlParameter("@vValidDate", ValidDate));
            cmd.Parameters.Add(new MySqlParameter("@vGrossTotal", GrossTotal));
            cmd.Parameters.Add(new MySqlParameter("@vNetTotal", NetTotal));
            cmd.Parameters.Add(new MySqlParameter("@vAmountAdvance", AmountAdvance));
            cmd.Parameters.Add(new MySqlParameter("@vStatus", Status));
            cmd.Parameters.Add(new MySqlParameter("@vReasonOfCancelation", ReasonOfCancelation));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedDate", LastUpdatedDate));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedUserID", LastUpdatedUserID));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedUserName", LastUpdatedUserName));
            cmd.Parameters.Add(new MySqlParameter("@vFreight", Freight));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vByDate", ByDate));
            cmd.Parameters.Add(new MySqlParameter("@RoundOff", RoundOff));
            cmd.Parameters.Add(new MySqlParameter("@Scheme", Scheme));
            cmd.Parameters.Add(new MySqlParameter("@vType", Type));
            cmd.Parameters.Add(new MySqlParameter("@ExciseOnBill", ExciseOnBill));
            cmd.Parameters.Add(new MySqlParameter("@S_Amount", S_Amount));
            cmd.Parameters.Add(new MySqlParameter("@S_CountryID", S_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@S_Currency", S_Currency));
            cmd.Parameters.Add(new MySqlParameter("@C_Factor", C_Factor));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryDate", DeliveryDate));
            cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@vStoreLedgerNo", StoreLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@vIPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@IsAsset", IsAsset));
            cmd.Parameters.Add(new MySqlParameter("@vOtherCharges", OtherCharges));
            cmd.Parameters.Add(new MySqlParameter("@vDocumentPath", DocumentPath));
            cmd.Parameters.Add(new MySqlParameter("@vIsService", IsService));
            cmd.Parameters.Add(new MySqlParameter("@vpaymentModeID", paymentModeID));

            cmd.Parameters.Add(paramTnxID);
            PurchaseOrderNo = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseOrderNo.ToString();
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

    public void UpdateApproval(string PONumber)
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append(" Update f_purchaseorder set ApprovedDate = (SELECT CURDATE()),Approved = 1 where PurchaseOrderNo = '" + PONumber + "'");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
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