using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for AssetStock
/// </summary>
public class AssetStock
{
    public AssetStock()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public AssetStock(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _AssetID;
    private string _AssetName;
    private string _AssetPurchaseDate;
    private string _AMCStartDate;
    private string _AMCEndDate;
    private decimal _Quantity;
    private string _Batch_Serial_Con;
    private string _BatchNo;
    private string _SerialNo;
    private string _BarCode;
    private string _Asset_Con;
    private decimal _AssetValue;
    private string _Remarks;
    private string _GRNNo;
    private string _GRNDate;
    private string _InvoiceNo;
    private string _InvoiceDate;
    private string _WarrantyNo;
    private string _WarrantyDate;
    private string _LeaseNo;
    private string _LeaseDate;
    private string _DisposalDate;
    private string _DisposalMethod;
    private int _DisposalMethodID;
    private string _DepreciationMethod;
    private decimal _Salvage;
    private string _DepreciationLife;
    private decimal _DepreciationRate;
    private string _CreatedBy;
    private int _IsActive;
    private int _AMCTypeID;
    private string _DeptLedgerNo;

    //Asset Start
    private DateTime _AssetPurDate;
    private string _ModelNo;
    private string _AssetTagNo;
    private DateTime _InstDate;
    private DateTime _ServiceFrom; 
    private DateTime _ServiceTo;
    private DateTime _WarrantyFrom;
    private DateTime _WarrantyTo;
    private int _GRNStockID;        
    // Asset End

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int AssetID { get { return _AssetID; } set { _AssetID = value; } }
    public virtual string AssetName { get { return _AssetName; } set { _AssetName = value; } }
    public virtual string AssetPurchaseDate { get { return _AssetPurchaseDate; } set { _AssetPurchaseDate = value; } }
    public virtual string AMCStartDate { get { return _AMCStartDate; } set { _AMCStartDate = value; } }
    public virtual string AMCEndDate { get { return _AMCEndDate; } set { _AMCEndDate = value; } }
    public virtual decimal Quantity { get { return _Quantity; } set { _Quantity = value; } }
    public virtual string Batch_Serial_Con { get { return _Batch_Serial_Con; } set { _Batch_Serial_Con = value; } }
    public virtual string BatchNo { get { return _BatchNo; } set { _BatchNo = value; } }
    public virtual string SerialNo { get { return _SerialNo; } set { _SerialNo = value; } }
    public virtual string BarCode { get { return _BarCode; } set { _BarCode = value; } }
    public virtual string Asset_Con { get { return _Asset_Con; } set { _Asset_Con = value; } }
    public virtual decimal AssetValue { get { return _AssetValue; } set { _AssetValue = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual string GRNNo { get { return _GRNNo; } set { _GRNNo = value; } }
    public virtual string GRNDate { get { return _GRNDate; } set { _GRNDate = value; } }
    public virtual string InvoiceNo { get { return _InvoiceNo; } set { _InvoiceNo = value; } }
    public virtual string InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
    public virtual string WarrantyNo { get { return _WarrantyNo; } set { _WarrantyNo = value; } }
    public virtual string WarrantyDate { get { return _WarrantyDate; } set { _WarrantyDate = value; } }
    public virtual string LeaseNo { get { return _LeaseNo; } set { _LeaseNo = value; } }
    public virtual string LeaseDate { get { return _LeaseDate; } set { _LeaseDate = value; } }
    public virtual string DisposalDate { get { return _DisposalDate; } set { _DisposalDate = value; } }
    public virtual string DisposalMethod { get { return _DisposalMethod; } set { _DisposalMethod = value; } }
    public virtual int DisposalMethodID { get { return _DisposalMethodID; } set { _DisposalMethodID = value; } }
    public virtual string DepreciationMethod { get { return _DepreciationMethod; } set { _DepreciationMethod = value; } }
    public virtual decimal Salvage { get { return _Salvage; } set { _Salvage = value; } }
    public virtual string DepreciationLife { get { return _DepreciationLife; } set { _DepreciationLife = value; } }
    public virtual decimal DepreciationRate { get { return _DepreciationRate; } set { _DepreciationRate = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual int IsActive { get { return _IsActive; } set { _IsActive = value; } }
    public virtual int AMCTypeID { get { return _AMCTypeID; } set { _AMCTypeID = value; } }
    public virtual string DeptLedgerNo { get { return _DeptLedgerNo; } set { _DeptLedgerNo = value; } }

    // Asset 17-07
    public virtual DateTime AssetPurDate { get { return _AssetPurDate; } set { _AssetPurDate = value; } }
    public virtual string ModelNo { get { return _ModelNo; } set { _ModelNo = value; } }
    public virtual string AssetTagNo { get { return _AssetTagNo; } set { _AssetTagNo = value; } }
    public virtual DateTime InstDate { get { return _InstDate; } set { _InstDate = value; } }
    public virtual DateTime ServiceFrom { get { return _ServiceFrom; } set { _ServiceFrom = value; } }
    public virtual DateTime ServiceTo { get { return _ServiceTo; } set { _ServiceTo = value; } }
    public virtual DateTime WarrantyFrom { get { return _WarrantyFrom; } set { _WarrantyFrom = value; } }
    public virtual DateTime WarrantyTo { get { return _WarrantyTo; } set { _WarrantyTo = value; } }
    public virtual int GRNStockID { get { return _GRNStockID; } set { _GRNStockID = value; } }
    // End

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_assetstock_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vAssetID", Util.GetInt(AssetID)));
            cmd.Parameters.Add(new MySqlParameter("@vAssetName", Util.GetString(AssetName)));
            cmd.Parameters.Add(new MySqlParameter("@vAssetPurchaseDate", Util.GetString(AssetPurchaseDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAMCStartDate", Util.GetString(AMCStartDate)));
            cmd.Parameters.Add(new MySqlParameter("@vAMCEndDate", Util.GetString(AMCEndDate)));
            cmd.Parameters.Add(new MySqlParameter("@vQuantity", Util.GetDecimal(Quantity)));
            cmd.Parameters.Add(new MySqlParameter("@vBatch_Serial_Con", Util.GetString(Batch_Serial_Con)));
            cmd.Parameters.Add(new MySqlParameter("@vBatchNo", Util.GetString(BatchNo)));
            cmd.Parameters.Add(new MySqlParameter("@vSerialNo", Util.GetString(SerialNo)));
            cmd.Parameters.Add(new MySqlParameter("@vBarCode", Util.GetString(BarCode)));
            cmd.Parameters.Add(new MySqlParameter("@vAsset_Con", Util.GetString(Asset_Con)));
            cmd.Parameters.Add(new MySqlParameter("@vAssetValue", Util.GetDecimal(AssetValue)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vGRNNo", Util.GetString(GRNNo)));
            cmd.Parameters.Add(new MySqlParameter("@vGRNDate", Util.GetString(GRNDate)));
            cmd.Parameters.Add(new MySqlParameter("@vInvoiceNo", Util.GetString(InvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@vInvoiceDate", Util.GetString(InvoiceDate)));
            cmd.Parameters.Add(new MySqlParameter("@vWarrantyNo", Util.GetString(WarrantyNo)));
            cmd.Parameters.Add(new MySqlParameter("@vWarrantyDate", Util.GetString(WarrantyDate)));
            cmd.Parameters.Add(new MySqlParameter("@vLeaseNo", Util.GetString(LeaseNo)));
            cmd.Parameters.Add(new MySqlParameter("@vLeaseDate", Util.GetString(LeaseDate)));
            cmd.Parameters.Add(new MySqlParameter("@vDisposalDate", Util.GetString(DisposalDate)));
            cmd.Parameters.Add(new MySqlParameter("@vDisposalMethod", Util.GetString(DisposalMethod)));
            cmd.Parameters.Add(new MySqlParameter("@vDisposalMethodID", Util.GetInt(DisposalMethodID)));
            cmd.Parameters.Add(new MySqlParameter("@vDepreciationMethod", Util.GetString(DepreciationMethod)));
            cmd.Parameters.Add(new MySqlParameter("@vSalvage", Util.GetDecimal(Salvage)));
            cmd.Parameters.Add(new MySqlParameter("@vDepreciationLife", Util.GetString(DepreciationLife)));
            cmd.Parameters.Add(new MySqlParameter("@vDepreciationRate", Util.GetDecimal(DepreciationRate)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", Util.GetString(IsActive)));
            cmd.Parameters.Add(new MySqlParameter("@vAMCTypeID", Util.GetString(AMCTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@vDeptLedgerNo", Util.GetString(DeptLedgerNo)));
            cmd.Parameters.Add(new MySqlParameter("@vGRNStockID",Util.GetInt(GRNStockID)));

            Output = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output.ToString();
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