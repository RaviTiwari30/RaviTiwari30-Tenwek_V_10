using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class GRNDetail
{
    public GRNDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public GRNDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables
    private string _LedgerTnxNo;
    private string _VenLedgerNo;
    private string _InvoiceNo;
    private DateTime _InvoiceDate;
    private string _StoreLedgerNo;
    private string _ItemID;
    private string _SubCategoryID; 
    private string _ItemName;
    private decimal _Rate;
    private decimal _MRP;   
    private decimal _Quantity;     
    private decimal _DiscPer;       
    private decimal _DiscAmt;   
    private string  _BatchNumber;   
    private int _ConversionFactor;
    private int _IsUsable; 
    private string _IsFree;        
    private string _IsExpirable;  
    private DateTime _ExpiryDate;   
    private decimal _Deal1;         
    private decimal _Deal2;        
    private string _PurchaseUnit;  
    private string _SaleUnit;       
    private string _TaxCalOn;      
    private string _Type_ID;       
    private string _GST_Type;      
    private string _HSNCode;       
    private decimal _IGSTPer;      
    private decimal _CGSTPer;
    private decimal _SGSTPer;    

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Set All Property
    public virtual string LedgerTnxNo { get { return _LedgerTnxNo; } set { _LedgerTnxNo = value; } }
    public virtual string VenLedgerNo { get { return _VenLedgerNo; } set { _VenLedgerNo = value; } }
    public virtual string InvoiceNo { get { return _InvoiceNo; } set { _InvoiceNo = value; } }
    public virtual DateTime InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
    public virtual string StoreLedgerNo { get { return _StoreLedgerNo; } set { _StoreLedgerNo = value; } }
    public virtual string ItemID { get { return _ItemID; } set { _ItemID = value; } }
    public virtual string SubCategoryID { get { return _SubCategoryID; } set { _SubCategoryID = value; } }
    public virtual string ItemName { get { return _ItemName; } set { _ItemName = value; } }
    public virtual decimal Rate { get { return _Rate; } set { _Rate = value; } }
    public virtual decimal MRP { get { return _MRP; } set { _MRP = value; } }
    public virtual decimal Quantity { get { return _Quantity; } set { _Quantity = value; } }
    public virtual decimal DiscPer { get { return _DiscPer; } set { _DiscPer = value; } }
    public virtual decimal DiscAmt { get { return _DiscAmt; } set { _DiscAmt = value; } }
    public virtual string BatchNumber { get { return _BatchNumber; } set { _BatchNumber = value; } }
    public virtual int ConversionFactor { get { return _ConversionFactor; } set { _ConversionFactor = value; } }
    public virtual int IsUsable { get { return _IsUsable; } set { _IsUsable = value; } }
    public virtual string IsFree { get { return _IsFree; } set { _IsFree = value; } }
    public virtual string IsExpirable { get { return _IsExpirable; } set { _IsExpirable = value; } }
    public virtual DateTime ExpiryDate { get { return _ExpiryDate; } set { _ExpiryDate = value; } }
    public virtual decimal Deal1 { get { return _Deal1; } set { _Deal1 = value; } }
    public virtual decimal Deal2 { get { return _Deal2; } set { _Deal2 = value; } }
    public virtual string PurchaseUnit { get { return _PurchaseUnit; } set { _PurchaseUnit = value; } }
    public virtual string SaleUnit { get { return _SaleUnit; } set { _SaleUnit = value; } }
    public virtual string TaxCalOn { get { return _TaxCalOn; } set { _TaxCalOn = value; } }
    public virtual string Type_ID { get { return _Type_ID; } set { _Type_ID = value; } }
    public virtual string GST_Type { get { return _GST_Type; } set { _GST_Type = value; } }
    public virtual string HSNCode { get { return _HSNCode; } set { _HSNCode = value; } }
    public virtual decimal IGSTPer { get { return _IGSTPer; } set { _IGSTPer = value; } }
    public virtual decimal CGSTPer { get { return _CGSTPer; } set { _CGSTPer = value; } }
    public virtual decimal SGSTPer { get { return _SGSTPer; } set { _SGSTPer = value; } }
    #endregion

  


}
