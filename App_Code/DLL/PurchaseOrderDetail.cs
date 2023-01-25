using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class PurchaseOrderDetail
{
    #region All Memory Variables

    private int _PurchaseOrderDetailID;
    private string _PurchaseOrderNo;
    private string _ItemID;
    private string _ItemName;
    private string _SubCategoryID;
    private decimal _RecievedQty;
    private decimal _ApprovedQty;
    private decimal _OrderedQty;
    private string _QoutationNo;
    private decimal _Rate;
    private decimal _Discount_a;
    private decimal _Discount_p;
    private decimal _BuyPrice;
    private decimal _Amount;
    private int _Status;
    private int _IsFree;
    private string _Specification;
    private decimal _MRP;
    private string _DeptLedgerNo;
    private string _PurchaseRequestNo;
    private decimal _ExciseAmt;
    private decimal _ExcisePercent;
    private decimal _VATAmt;
    private decimal _VATPercent;
    private string _StoreLedgerNo;
    private string _TaxCalulatedOn;
    private int _CentreID;
    private string _Hospital_ID;

    // GST Changes
    private string _HSNCode;
    private string _GSTType;
    private decimal _IGSTPercent;
    private decimal _IGSTAmt;
    private decimal _SGSTPercent;
    private decimal _SGSTAmt;
    private decimal _CGSTPercent;
    private decimal _CGSTAmt;
    //-----
    //Deal Work
    private string _isDeal;

    private string _LastUpdatedBy;



    private int _S_CountryID;
    private string _S_Currency;
    private decimal _C_Factor;
    private decimal _Minimum_Tolerance_Qty;
    private decimal _Maximum_Tolerance_Qty;
    private decimal _Minimum_Tolerance_Rate;
    private decimal _Maximum_Tolerance_Rate;




    public decimal Minimum_Tolerance_Qty
    {
        get { return _Minimum_Tolerance_Qty; }
        set { _Minimum_Tolerance_Qty = value; }
    }

    public decimal Maximum_Tolerance_Qty
    {
        get { return _Maximum_Tolerance_Qty; }
        set { _Maximum_Tolerance_Qty = value; }
    }

    public decimal Minimum_Tolerance_Rate
    {
        get { return _Minimum_Tolerance_Rate; }
        set { _Minimum_Tolerance_Rate = value; }
    }

    public decimal Maximum_Tolerance_Rate
    {
        get { return _Maximum_Tolerance_Rate; }
        set { _Maximum_Tolerance_Rate = value; }
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

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PurchaseOrderDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PurchaseOrderDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int PurchaseOrderDetailID
    {
        get
        {
            return _PurchaseOrderDetailID;
        }
        set
        {
            _PurchaseOrderDetailID = value;
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

    public virtual string SubCategoryID
    {
        get
        {
            return _SubCategoryID;
        }
        set
        {
            _SubCategoryID = value;
        }
    }

    public virtual decimal RecievedQty
    {
        get
        {
            return _RecievedQty;
        }
        set
        {
            _RecievedQty = value;
        }
    }

    public virtual decimal ApprovedQty
    {
        get
        {
            return _ApprovedQty;
        }
        set
        {
            _ApprovedQty = value;
        }
    }

    public virtual decimal OrderedQty
    {
        get
        {
            return _OrderedQty;
        }
        set
        {
            _OrderedQty = value;
        }
    }

    public virtual string QoutationNo
    {
        get
        {
            return _QoutationNo;
        }
        set
        {
            _QoutationNo = value;
        }
    }

    public virtual decimal Rate
    {
        get
        {
            return _Rate;
        }
        set
        {
            _Rate = value;
        }
    }

    public virtual decimal Discount_a
    {
        get
        {
            return _Discount_a;
        }
        set
        {
            _Discount_a = value;
        }
    }

    public virtual decimal Discount_p
    {
        get
        {
            return _Discount_p;
        }
        set
        {
            _Discount_p = value;
        }
    }

    public virtual decimal BuyPrice
    {
        get
        {
            return _BuyPrice;
        }
        set
        {
            _BuyPrice = value;
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

    public virtual int IsFree
    {
        get
        {
            return _IsFree;
        }
        set
        {
            _IsFree = value;
        }
    }

    public string _Unit;

    public virtual string Unit
    {
        get
        {
            return _Unit;
        }
        set
        {
            _Unit = value;
        }
    }

    public virtual string Specification
    {
        get
        {
            return _Specification;
        }
        set
        {
            _Specification = value;
        }
    }

    public virtual decimal MRP
    {
        get
        {
            return _MRP;
        }
        set
        {
            _MRP = value;
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

    public virtual string PurchaseRequestNo
    {
        get
        {
            return _PurchaseRequestNo;
        }
        set
        {
            _PurchaseRequestNo = value;
        }
    }

    public virtual decimal ExciseAmt
    {
        get
        {
            return _ExciseAmt;
        }
        set
        {
            _ExciseAmt = value;
        }
    }

    public virtual decimal ExcisePercent
    {
        get
        {
            return _ExcisePercent;
        }
        set
        {
            _ExcisePercent = value;
        }
    }

    public virtual decimal VATAmt
    {
        get
        {
            return _VATAmt;
        }
        set
        {
            _VATAmt = value;
        }
    }

    public virtual decimal VATPercent
    {
        get
        {
            return _VATPercent;
        }
        set
        {
            _VATPercent = value;
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

    public virtual string TaxCalulatedOn
    {
        get
        {
            return _TaxCalulatedOn;
        }
        set
        {
            _TaxCalulatedOn = value;
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

    // GST Changes
    public virtual string HSNCode { get { return _HSNCode; } set { _HSNCode = value; } }
    public virtual string GSTType { get { return _GSTType; } set { _GSTType = value; } }
    public virtual decimal IGSTPercent { get { return _IGSTPercent; } set { _IGSTPercent = value; } }
    public virtual decimal IGSTAmt { get { return _IGSTAmt; } set { _IGSTAmt = value; } }
    public virtual decimal SGSTPercent { get { return _SGSTPercent; } set { _SGSTPercent = value; } }
    public virtual decimal SGSTAmt { get { return _SGSTAmt; } set { _SGSTAmt = value; } }
    public virtual decimal CGSTPercent { get { return _CGSTPercent; } set { _CGSTPercent = value; } }
    public virtual decimal CGSTAmt { get { return _CGSTAmt; } set { _CGSTAmt = value; } }
    //
    //Deal Work
    public virtual string isDeal { get { return _isDeal; } set { _isDeal = value; } }


    public virtual string LastUpdatedBy { get { return _LastUpdatedBy; } set { _LastUpdatedBy = value; } } 
    //
    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_PurchaseOrderDetails(PurchaseOrderNo,ItemId,ItemName,SubCategoryId,OrderedQty,ApprovedQty,RecievedQty,QoutationNo,Rate,Discount_a,Discount_p,BuyPrice,Amount,Status,IsFree,Specification,Unit,MRP,DeptLedgerNo,PurchaseRequestNo,VATPer,VATAmt,ExcisePer,ExciseAmt,StoreLedgerNo,TaxCalulatedOn,CentreID,Hospital_ID,GSTType,HSNCode,IGSTPercent,IGSTAmt,CGSTPercent,CGSTAmt,SGSTPercent,SGSTAmt,IsDeal,C_Factor,S_CountryID,S_Currency,Minimum_Tolerance_Qty,Maximum_Tolerance_Qty,Minimum_Tolerance_Rate,Maximum_Tolerance_Rate)");
            objSQL.Append("VALUES (@PurchaseOrderNo, @ItemId, @ItemName, @SubCategoryId, @OrderedQty, @ApprovedQty, @RecievedQty, @QoutationNo,@Rate, @Discount_a, @Discount_p, @BuyPrice, @Amount, @Status,@IsFree,@Specification,@Unit,@MRP,@DeptLedgerNo,@PurchaseRequestNo,@VATPer,@VATAmt,@ExcisePer,@ExciseAmt,@StoreLedgerNo,@TaxCalulatedOn,@CentreID,@Hospital_ID, @GSTType, @HSNCode, @IGSTPercent, @IGSTAmt, @CGSTPercent, @CGSTAmt, @SGSTPercent, @SGSTAmt,@IsDeal,@C_Factor,@S_CountryID,@S_Currency,@Minimum_Tolerance_Qty,@Maximum_Tolerance_Qty,@Minimum_Tolerance_Rate,@Maximum_Tolerance_Rate)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PurchaseOrderNo = Util.GetString(PurchaseOrderNo);
            this.ItemID = Util.GetString(ItemID);
            this.ItemName = Util.GetString(ItemName);
            this.SubCategoryID = Util.GetString(SubCategoryID);
            this.OrderedQty = Util.GetDecimal(OrderedQty);
            this.ApprovedQty = Util.GetDecimal(ApprovedQty);
            this.RecievedQty = Util.GetDecimal(RecievedQty);
            this.QoutationNo = Util.GetString(QoutationNo);
            this.Rate = Util.GetDecimal(Rate);
            this.Discount_a = Util.GetDecimal(Discount_a);
            this.Discount_p = Util.GetDecimal(Discount_p);
            this.BuyPrice = Util.GetDecimal(BuyPrice);
            this.Amount = Util.GetDecimal(Amount);
            this.Status = Util.GetInt(Status);
            this.IsFree = Util.GetInt(IsFree);
            this.Specification = Util.GetString(Specification);
            this.Unit = Util.GetString(Unit);
            this.MRP = Util.GetDecimal(MRP);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.PurchaseRequestNo = Util.GetString(PurchaseRequestNo);
            this.ExcisePercent = Util.GetDecimal(ExcisePercent);
            this.ExciseAmt = Util.GetDecimal(ExciseAmt);
            this.VATPercent = Util.GetDecimal(VATPercent);
            this.VATAmt = Util.GetDecimal(VATAmt);
            this.StoreLedgerNo = Util.GetString(StoreLedgerNo);
            this.TaxCalulatedOn = Util.GetString(TaxCalulatedOn);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);

            // GST Changes
            this.HSNCode = Util.GetString(HSNCode);
            this.GSTType = Util.GetString(GSTType);
            this.IGSTPercent = Util.GetDecimal(IGSTPercent);
            this.IGSTAmt = Util.GetDecimal(IGSTAmt);
            this.SGSTPercent = Util.GetDecimal(SGSTPercent);
            this.SGSTAmt = Util.GetDecimal(SGSTAmt);
            this.CGSTPercent = Util.GetDecimal(CGSTPercent);
            this.CGSTAmt = Util.GetDecimal(CGSTAmt);
            //
            //Deal Work
            this.isDeal = Util.GetString(isDeal);
            //
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PurchaseOrderNo", PurchaseOrderNo),
                new MySqlParameter("@ItemId", ItemID),
                new MySqlParameter("@ItemName", ItemName),
                new MySqlParameter("@SubCategoryId", SubCategoryID),
                new MySqlParameter("@OrderedQty", OrderedQty),
                new MySqlParameter("@ApprovedQty", ApprovedQty),
                new MySqlParameter("@RecievedQty", RecievedQty),
                new MySqlParameter("@QoutationNo", QoutationNo),
                new MySqlParameter("@Rate", Rate),
                new MySqlParameter("@Discount_a", Discount_a),
                new MySqlParameter("@Discount_p", Discount_p),
                new MySqlParameter("@BuyPrice", BuyPrice),
                new MySqlParameter("@Amount", Amount),
                new MySqlParameter("@Status", Status),
                new MySqlParameter("@IsFree", IsFree),
                new MySqlParameter("@Specification", Specification),
                new MySqlParameter("@Unit", Unit),
                new MySqlParameter("@MRP", MRP),
                new MySqlParameter("@DeptLedgerNo", DeptLedgerNo),
                new MySqlParameter("@PurchaseRequestNo", PurchaseRequestNo),
                new MySqlParameter("@VATPer", VATPercent),
                new MySqlParameter("@VATAmt", VATAmt),
                new MySqlParameter("@ExcisePer", ExcisePercent),
                new MySqlParameter("@ExciseAmt", ExciseAmt),
                new MySqlParameter("@StoreLedgerNo", StoreLedgerNo),
                new MySqlParameter("@TaxCalulatedOn", TaxCalulatedOn),
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@Hospital_ID", Hospital_ID),

                // GST Changes
                new MySqlParameter("@HSNCode", HSNCode),
                new MySqlParameter("@GSTType", GSTType),
                new MySqlParameter("@IGSTPercent",IGSTPercent),
                new MySqlParameter("@IGSTAmt", IGSTAmt),
                new MySqlParameter("@SGSTPercent", SGSTPercent),
                new MySqlParameter("@SGSTAmt", SGSTAmt),
                new MySqlParameter("@CGSTPercent", CGSTPercent),
                new MySqlParameter("@CGSTAmt", CGSTAmt),
                //---
                //Deal Work
                new MySqlParameter("@IsDeal", isDeal),

                
                new MySqlParameter("@C_Factor", C_Factor),
                new MySqlParameter("@S_CountryID", S_CountryID),
                new MySqlParameter("@S_Currency", S_Currency),
                new MySqlParameter("@Minimum_Tolerance_Qty",Minimum_Tolerance_Qty),
                new MySqlParameter("@Maximum_Tolerance_Qty",Maximum_Tolerance_Qty),
                new MySqlParameter("@Minimum_Tolerance_Rate",Minimum_Tolerance_Rate),
                new MySqlParameter("@Maximum_Tolerance_Rate",Maximum_Tolerance_Rate)

                );

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
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

    public DataTable GetPODetails(string PONumber)
    {
        StringBuilder objSQL = new StringBuilder();
        objSQL.Append("select PurchaseOrderDetailID As DetailNo,ItemName As ItemName,OrderedQty As RQty,ApprovedQty As AQty,Rate,Specification ");
        objSQL.Append(" from f_purchaseorderdetails where PurchaseOrderNo = '" + PONumber + "'");

        string str = objSQL.ToString();

        DataTable ds = new DataTable();
        if (IsLocalConn)
        {
            this.objCon.Open();

            ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
            this.objCon.Close();
            return ds;
        }
        else
        {
            ds = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
            return ds;
        }
    }

    public void UpdateDetails(string detailID, string AQty)
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("UPDATE f_purchaseorderdetails SET ApprovedQty = " + AQty + " where PurchaseOrderDetailID = " + detailID);

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
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    #endregion All Public Member Function

    #region Helper Private Function

    //private void SetProperties(DataTable dtTemp)
    //{
    //    this.PurchaseOrderDetailID = Util.GetInt(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.PurchaseOrderDetailID]);
    //    this.PurchaseOrderNo = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.PurchaseOrderNo]);
    //    this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.ItemID]);
    //    this.ItemName = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.ItemName]);
    //    this.SubCategoryID = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.SubCategoryID]);
    //    this.OrderedQty = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.OrderedQty]);
    //    this.ApprovedQty = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.ApprovedQty]);
    //    this.RecievedQty = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.RecievedQty]);
    //    this.QoutationNo = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.QoutationNo]);
    //    this.Rate = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.Rate]);
    //    this.Discount_a = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.Discount_a]);
    //    this.Discount_p = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.Discount_p]);
    //    this.BuyPrice = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.BuyPrice]);
    //    this.Amount = Util.GetDecimal(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.Amount]);
    //    this.Status = Util.GetInt(dtTemp.Rows[0][AllTables.PurchaseOrderDetail.Status]);
    //}

    #endregion Helper Private Function
}