#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Sales_Details
{
	#region All Memory Variables

	private string _HospCode;
	private string _Location;
	private int _ID;
	private string _SalesID;
	private string _Hospital_ID;
	private string _LedgerNumber;
	private string _DepartmentID;
	private string _StockID;
	private decimal _SoldUnits;
	private decimal _PerUnitBuyPrice;
	private decimal _PerUnitSellingPrice;
	private int _IsReturn;
	private System.DateTime _Date;
	private System.DateTime _Time;
	private int _TrasactionTypeID;
	private string _ItemID;
	private string _IsService;
	private string _IndentNo;
	private string _Naration;
	private int _SalesNo;
    [System.ComponentModel.DefaultValue("0")]
	private string _LedgerTransactionNo;
	private string _DeptLedgerNo;
	private string _BillNoforGP;
	private string _PatientID;
	private int _ToBeBilled;
	private string _Type_ID;
	private string _IsReusable;
    [System.ComponentModel.DefaultValue("0")]
	private string _ServiceItemID;
	private string _AgainstLedgerTnxNo;
	private string _Refund_Against_BillNo;
	private int _CentreID;
	private string _IpAddress;
	private DateTime _medExpiryDate;
	private int _LedgerTnxNo;
	private string _BillNo;
	private string _BatchNo;
	private decimal _TaxPercent;
	private decimal _TaxAmt;
    [System.ComponentModel.DefaultValue("0")]
	private string _TransactionID;
	private decimal _DiscAmt;
	private decimal _DisPercent;
	//GST Changes
	private string _HSNCode;
	private decimal _IGSTPercent;
	private decimal _IGSTAmt;
	private decimal _SGSTPercent;
	private decimal _SGSTAmt;
	private decimal _CGSTPercent;
	private decimal _CGSTAmt;
	private string _GSTType;
    private int _IsAsset;

    private decimal _PurTaxPer;
    private decimal _PurTaxAmt;
    private string _draftDetailID;

    private int _ToCentreID;
    private string _pageurl;
      [System.ComponentModel.DefaultValue(1)]
    private int _SupOrDeptSaleType;

      [System.ComponentModel.DefaultValue(0.0000)]
    private decimal _SupOrDeptSaleTypePer;

	//
	#endregion All Memory Variables


	#region All Global Variables

	private MySqlConnection objCon;
	private MySqlTransaction objTrans;
	private bool IsLocalConn;

	#endregion All Global Variables

	#region Overloaded Constructor

	public Sales_Details()
	{
		objCon = Util.GetMySqlCon();
		this.IsLocalConn = true;
		this.Location = AllGlobalFunction.Location;
		this.HospCode = AllGlobalFunction.HospCode;
	}

	public Sales_Details(MySqlTransaction objTrans)
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

	public virtual string SalesID
	{
		get
		{
			return _SalesID;
		}
		set
		{
			_SalesID = value;
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

	public virtual string LedgerNumber
	{
		get
		{
			return _LedgerNumber;
		}
		set
		{
			_LedgerNumber = value;
		}
	}

	public virtual string DepartmentID
	{
		get
		{
			return _DepartmentID;
		}
		set
		{
			_DepartmentID = value;
		}
	}

	public virtual string StockID
	{
		get
		{
			return _StockID;
		}
		set
		{
			_StockID = value;
		}
	}

	public virtual decimal SoldUnits
	{
		get
		{
			return _SoldUnits;
		}
		set
		{
			_SoldUnits = value;
		}
	}

	public virtual decimal PerUnitBuyPrice
	{
		get
		{
			return _PerUnitBuyPrice;
		}
		set
		{
			_PerUnitBuyPrice = value;
		}
	}

	public virtual decimal PerUnitSellingPrice
	{
		get
		{
			return _PerUnitSellingPrice;
		}
		set
		{
			_PerUnitSellingPrice = value;
		}
	}

	public virtual int IsReturn
	{
		get
		{
			return _IsReturn;
		}
		set
		{
			_IsReturn = value;
		}
	}

	public virtual System.DateTime Date
	{
		get
		{
			return _Date;
		}
		set
		{
			_Date = value;
		}
	}

	public virtual System.DateTime Time
	{
		get
		{
			return _Time;
		}
		set
		{
			_Time = value;
		}
	}

	public virtual int TrasactionTypeID
	{
		get
		{
			return _TrasactionTypeID;
		}
		set
		{
			_TrasactionTypeID = value;
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

	public virtual string IsService
	{
		get
		{
			return _IsService;
		}
		set
		{
			_IsService = value;
		}
	}

	public virtual string IndentNo
	{
		get
		{
			return _IndentNo;
		}
		set
		{
			_IndentNo = value;
		}
	}

	public virtual string Naration
	{
		get
		{
			return _Naration;
		}
		set
		{
			_Naration = value;
		}
	}

	public virtual int SalesNo
	{
		get
		{
			return _SalesNo;
		}
		set
		{
			_SalesNo = value;
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

	private string _UserID;

	public string UserID
	{
		get { return _UserID; }
		set { _UserID = value; }
	}

	public string DeptLedgerNo
	{
		get { return _DeptLedgerNo; }
		set { _DeptLedgerNo = value; }
	}

	public string BillNoforGP
	{
		get
		{
			return _BillNoforGP;
		}
		set
		{
			_BillNoforGP = value;
		}
	}

	public string PatientID
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

	public int ToBeBilled
	{
		get
		{
			return _ToBeBilled;
		}
		set
		{
			_ToBeBilled = value;
		}
	}

	public string Type_ID
	{
		get { return _Type_ID; }
		set { _Type_ID = value; }
	}

	public string IsReusable
	{
		get { return _IsReusable; }
		set { _IsReusable = value; }
	}

	public string ServiceItemID
	{
		get { return _ServiceItemID; }
		set { _ServiceItemID = value; }
	}

	public string AgainstLedgerTnxNo
	{
		get { return _AgainstLedgerTnxNo; }
		set { _AgainstLedgerTnxNo = value; }
	}

	public string Refund_Against_BillNo
	{
		get { return _Refund_Against_BillNo; }
		set { _Refund_Against_BillNo = value; }
	}

	public int CentreID
	{
		get { return _CentreID; }
		set { _CentreID = value; }
	}

	public string IpAddress
	{
		get { return _IpAddress; }
		set { _IpAddress = value; }
	}

	public virtual DateTime medExpiryDate { get { return _medExpiryDate; } set { _medExpiryDate = value; } }

	public virtual int LedgerTnxNo { get { return _LedgerTnxNo; } set { _LedgerTnxNo = value; } }

	public string BillNo
	{
		get { return _BillNo; }
		set { _BillNo = value; }
	}
	public string BatchNo
	{
		get { return _BatchNo; }
		set { _BatchNo = value; }
	}
	public virtual decimal TaxPercent { get { return _TaxPercent; } set { _TaxPercent = value; } }
	public virtual decimal TaxAmt { get { return _TaxAmt; } set { _TaxAmt = value; } }
	public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
	public virtual decimal DiscAmt { get { return _DiscAmt; } set { _DiscAmt = value; } }
	public virtual decimal DisPercent { get { return _DisPercent; } set { _DisPercent = value; } }
	public virtual string HSNCode { get { return _HSNCode; } set { _HSNCode = value; } }
	public virtual decimal IGSTPercent { get { return _IGSTPercent; } set { _IGSTPercent = value; } }
	public virtual decimal IGSTAmt { get { return _IGSTAmt; } set { _IGSTAmt = value; } }
	public virtual decimal SGSTPercent { get { return _SGSTPercent; } set { _SGSTPercent = value; } }
	public virtual decimal SGSTAmt { get { return _SGSTAmt; } set { _SGSTAmt = value; } }
	public virtual decimal CGSTPercent { get { return _CGSTPercent; } set { _CGSTPercent = value; } }
	public virtual decimal CGSTAmt { get { return _CGSTAmt; } set { _CGSTAmt = value; } }
	public virtual string GSTType
	{
		get { return _GSTType; }
		set { _GSTType = value; }
	}
    public virtual int IsAsset { get { return _IsAsset; } set { _IsAsset = value; } }

     public virtual decimal PurTaxPer { get { return _PurTaxPer; } set { _PurTaxPer = value; } }
     public virtual decimal PurTaxAmt { get { return _PurTaxAmt; } set { _PurTaxAmt = value; } }
     public virtual string draftDetailID { get { return _draftDetailID; } set { _draftDetailID = value; } }
     public virtual int ToCentreID { get { return _ToCentreID; } set { _ToCentreID = value; } }


     public virtual int SupOrDeptSaleType { get { return _SupOrDeptSaleType; } set { _SupOrDeptSaleType = value; } }
     public virtual decimal SupOrDeptSaleTypePer { get { return _SupOrDeptSaleTypePer; } set { _SupOrDeptSaleTypePer = value; } }

     public virtual string pageurl { get { return _pageurl; } set { _pageurl = value; } }
	#endregion Set All Property

	#region All Public Member Function

	public string Insert()
	{
		try
		{
			StringBuilder objSQL = new StringBuilder();
			objSQL.Append("Insert_salesdetails");

			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}

			MySqlParameter Sales_ID = new MySqlParameter();
			Sales_ID.ParameterName = "@Sales_ID";

			Sales_ID.MySqlDbType = MySqlDbType.VarChar;
			Sales_ID.Size = 50;
			Sales_ID.Direction = ParameterDirection.Output;
			MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
			cmd.CommandType = CommandType.StoredProcedure;

			this.Location = AllGlobalFunction.Location;
			this.HospCode = AllGlobalFunction.HospCode;
			this.Location = Util.GetString(Location);
			this.HospCode = Util.GetString(HospCode);
			this.Hospital_ID = Util.GetString(Hospital_ID);
			this.LedgerNumber = Util.GetString(LedgerNumber);
			this.DepartmentID = Util.GetString(DepartmentID);
			this.StockID = Util.GetString(StockID);
			this.SoldUnits = Util.GetDecimal(SoldUnits);
			this.PerUnitBuyPrice = Util.GetDecimal(PerUnitBuyPrice);
			this.PerUnitSellingPrice = Util.GetDecimal(PerUnitSellingPrice);
			this.IsReturn = Util.GetInt(IsReturn);
			this.Date = Util.GetDateTime(Date);
			this.Time = Util.GetDateTime(Time);
			this.TrasactionTypeID = Util.GetInt(TrasactionTypeID);
			this.ItemID = Util.GetString(ItemID);
			this.IsService = Util.GetString(IsService);
			this.IndentNo = Util.GetString(IndentNo);
			this.Naration = Util.GetString(Naration);
			this.SalesNo = Util.GetInt(SalesNo);
			this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
			this.UserID = Util.GetString(UserID);
			this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
			this._BillNoforGP = Util.GetString(BillNoforGP);
			this.PatientID = Util.GetString(PatientID);
			this.ToBeBilled = Util.GetInt(ToBeBilled);
			this.Type_ID = Util.GetString(Type_ID);
			this.IsReusable = Util.GetString(IsReusable);
			this._ServiceItemID = Util.GetString(ServiceItemID);
			this.AgainstLedgerTnxNo = Util.GetString(AgainstLedgerTnxNo);
			this.Refund_Against_BillNo = Util.GetString(Refund_Against_BillNo);
			this.CentreID = Util.GetInt(CentreID);
			this.IpAddress = Util.GetString(IpAddress);
			this.medExpiryDate = Util.GetDateTime(medExpiryDate);
			this.LedgerTnxNo = Util.GetInt(LedgerTnxNo);
			this.BillNo = Util.GetString(BillNo);
			this.BatchNo = Util.GetString(BatchNo);
			this.TaxPercent = Util.GetDecimal(TaxPercent);
			this.TaxAmt = Util.GetDecimal(TaxAmt);
			this.TransactionID = Util.GetString(TransactionID);
			this.DiscAmt = Util.GetDecimal(DiscAmt);
			this.DisPercent = Util.GetDecimal(DisPercent);
			// Add new 29-06-2017 - For GST
			this.GSTType = Util.GetString(GSTType);
			this.HSNCode = Util.GetString(HSNCode);
			this.IGSTPercent=Util.GetDecimal(IGSTPercent);
			this.IGSTAmt=Util.GetDecimal(IGSTAmt);
			this.SGSTPercent=Util.GetDecimal(SGSTPercent);
			this.SGSTAmt=Util.GetDecimal(SGSTAmt);
			this.CGSTPercent=Util.GetDecimal(CGSTPercent);
			this.CGSTAmt=Util.GetDecimal(CGSTAmt);
            this.IsAsset = Util.GetInt(IsAsset);
            this.PurTaxPer = Util.GetDecimal(PurTaxPer);
            this.PurTaxAmt = Util.GetDecimal(PurTaxAmt);
            this.draftDetailID = Util.GetInt(draftDetailID).ToString();

            this.SupOrDeptSaleType = Util.GetInt(SupOrDeptSaleType);
            this.SupOrDeptSaleTypePer = Util.GetDecimal(SupOrDeptSaleTypePer);
            this.pageurl = All_LoadData.getCurrentPageName();
			//
			cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
			cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
			cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
			cmd.Parameters.Add(new MySqlParameter("@LedgerNumber", LedgerNumber));
			cmd.Parameters.Add(new MySqlParameter("@DepartmentID", DepartmentID));
			cmd.Parameters.Add(new MySqlParameter("@StockID", StockID));
			cmd.Parameters.Add(new MySqlParameter("@SoldUnits", SoldUnits));
			cmd.Parameters.Add(new MySqlParameter("@PerUnitBuyPrice", PerUnitBuyPrice));
			cmd.Parameters.Add(new MySqlParameter("@PerUnitSellingPrice", PerUnitSellingPrice));
			cmd.Parameters.Add(new MySqlParameter("@DATE", Date));
			cmd.Parameters.Add(new MySqlParameter("@TIME", Time));
			cmd.Parameters.Add(new MySqlParameter("@IsReturn", IsReturn));
			cmd.Parameters.Add(new MySqlParameter("@TrasactionTypeID", TrasactionTypeID));
			cmd.Parameters.Add(new MySqlParameter("@ITemID", ItemID));
			cmd.Parameters.Add(new MySqlParameter("@IsService", IsService));
			cmd.Parameters.Add(new MySqlParameter("@IndentNo", IndentNo));
			cmd.Parameters.Add(new MySqlParameter("@Naration", Naration));
			cmd.Parameters.Add(new MySqlParameter("@SalesNo", SalesNo));
			cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
			cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
			cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
			cmd.Parameters.Add(new MySqlParameter("@BillNoforGP", BillNoforGP));
			cmd.Parameters.Add(new MySqlParameter("@PatientID", PatientID));
			cmd.Parameters.Add(new MySqlParameter("@ToBeBilled", ToBeBilled));
			cmd.Parameters.Add(new MySqlParameter("@Type_ID", Type_ID));
			cmd.Parameters.Add(new MySqlParameter("@IsReusable", IsReusable));
			cmd.Parameters.Add(new MySqlParameter("@ServiceItemID", ServiceItemID));
			cmd.Parameters.Add(new MySqlParameter("@AgainstLedgerTnxNo", AgainstLedgerTnxNo));
			cmd.Parameters.Add(new MySqlParameter("@Refund_Against_BillNo", Refund_Against_BillNo));
			cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
			cmd.Parameters.Add(new MySqlParameter("@IpAddress", IpAddress));
			cmd.Parameters.Add(new MySqlParameter("@medExpiryDate", medExpiryDate));
			cmd.Parameters.Add(new MySqlParameter("@LedgerTnxNo", LedgerTnxNo));
			cmd.Parameters.Add(new MySqlParameter("@BillNo", BillNo));
			cmd.Parameters.Add(new MySqlParameter("@BatchNo", BatchNo));
			cmd.Parameters.Add(new MySqlParameter("@TaxPercent", TaxPercent));
			cmd.Parameters.Add(new MySqlParameter("@TaxAmt", TaxAmt));
			cmd.Parameters.Add(new MySqlParameter("@TransactionID", TransactionID));
			cmd.Parameters.Add(new MySqlParameter("@DiscAmt", DiscAmt));
			cmd.Parameters.Add(new MySqlParameter("@DisPercent", DisPercent));
			//GST Changes
			cmd.Parameters.Add(new MySqlParameter("@HSNCode", HSNCode));
			cmd.Parameters.Add(new MySqlParameter("@IGSTPercent",IGSTPercent ));
			cmd.Parameters.Add(new MySqlParameter("@IGSTAmt",IGSTAmt ));
			cmd.Parameters.Add(new MySqlParameter("@SGSTPercent", SGSTPercent));
			cmd.Parameters.Add(new MySqlParameter("@SGSTAmt", SGSTAmt));
			cmd.Parameters.Add(new MySqlParameter("@CGSTPercent", CGSTPercent));
			cmd.Parameters.Add(new MySqlParameter("@CGSTAmt", CGSTAmt));
			cmd.Parameters.Add(new MySqlParameter("@GSTType", GSTType));
            cmd.Parameters.Add(new MySqlParameter("@vIsAsset", IsAsset));
            cmd.Parameters.Add(new MySqlParameter("@vPurTaxPer", PurTaxPer));
            cmd.Parameters.Add(new MySqlParameter("@vPurTaxAmt",PurTaxAmt));
            cmd.Parameters.Add(new MySqlParameter("@vdraftDetailID", draftDetailID));

            if(ToCentreID ==0 || ToCentreID== null)
                cmd.Parameters.Add(new MySqlParameter("@vToCentreID", CentreID));
            else
                cmd.Parameters.Add(new MySqlParameter("@vToCentreID", ToCentreID));
			//

            cmd.Parameters.Add(new MySqlParameter("@vSupOrDeptSaleType", SupOrDeptSaleType));
            cmd.Parameters.Add(new MySqlParameter("@vSupOrDeptSaleTypePer", SupOrDeptSaleTypePer));
            cmd.Parameters.Add(new MySqlParameter("@vpageurl", pageurl));
			cmd.Parameters.Add(Sales_ID);
			SalesID = cmd.ExecuteScalar().ToString();

			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}

			return SalesID.ToString();
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

	public int Update()
	{
		try
		{
			int RowAffected;
			StringBuilder objSQL = new StringBuilder();
			objSQL.Append("UPDATE salesdetails SET LedgerTnxNumber = ?,Hospital_ID=?, DepartmentID = ?, StockID = ?,SoldUnits = ?, CreatedDate= ?,SoldUnits = ?,PerUnitBuyPrice = ?,PerUnitSellingPrice = ?,IsReturn = ?,Date = ?,Time=?,SalesNo=?  WHERE SalesID =? ");

			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}
			this.Location = Util.GetString(Location);
			this.HospCode = Util.GetString(HospCode);
			// this.SalesID = Util.GetString(SalesID);
			this.LedgerNumber = Util.GetString(LedgerNumber);
			this.Hospital_ID = Util.GetString(Hospital_ID);
			this.DepartmentID = Util.GetString(DepartmentID);
			this.StockID = Util.GetString(StockID);
			this.SoldUnits = Util.GetDecimal(SoldUnits);
			this.PerUnitBuyPrice = Util.GetDecimal(PerUnitBuyPrice);
			this.PerUnitSellingPrice = Util.GetDecimal(PerUnitSellingPrice);
			this.IsReturn = Util.GetInt(IsReturn);
			this.Date = Util.GetDateTime(Date);
			this.Time = Util.GetDateTime(Time);
			this.SalesNo = Util.GetInt(SalesNo);

			RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

				new MySqlParameter("@LedgerNumber", LedgerNumber),
				 new MySqlParameter("@Hospital_ID", Hospital_ID),
				new MySqlParameter("@DepartmentID", DepartmentID),
				new MySqlParameter("@StockID", StockID),
				new MySqlParameter("@SoldUnits", SoldUnits),
				new MySqlParameter("@PerUnitBuyPrice", PerUnitBuyPrice),
				new MySqlParameter("@PerUnitSellingPrice", PerUnitSellingPrice),
				new MySqlParameter("@IsReturn", IsReturn),
				new MySqlParameter("@Date", Date),
				new MySqlParameter("@Time", Time),
				new MySqlParameter("@SalesNo", SalesNo),

				new MySqlParameter("@SalesID", SalesID));
			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}
			return RowAffected;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objTrans != null) this.objTrans.Rollback();
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			//Util.WriteLog(ex);
			throw (ex);
		}
	}

	public int Delete(string iPkValue)
	{
		this.SalesID = iPkValue;
		return this.Delete();
	}

	public int Delete()
	{
		try
		{
			int iRetValue;
			StringBuilder objSQL = new StringBuilder();
			objSQL.Append("DELETE FROM salesdetails WHERE SalesID = ?");

			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}

			iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

				new MySqlParameter("SalesID", SalesID));
			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}
			return iRetValue;
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

	public bool Load()
	{
		DataTable dtTemp;

		try
		{
			string sSQL = "SELECT * FROM salesdetails WHERE SalesID = ?";

			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}

			dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@SalesID", SalesID)).Tables[0];

			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}

			if (dtTemp.Rows.Count > 0)
			{
				this.SetProperties(dtTemp);
				return true;
			}
			else
				return false;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objTrans != null) this.objTrans.Rollback();
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}

			// Util.WriteLog(ex);
			string sParams = "SalesID=" + this.SalesID.ToString();
			// Util.WriteLog(sParams);
			throw (ex);
		}
	}

	/// <summary>
	/// Loads the specified i pk value.
	/// </summary>
	/// <param name="iPkValue">The i pk value.</param>
	/// <returns></returns>
	public bool Load(string iPkValue)
	{
		this.SalesID = iPkValue;
		return this.Load();
	}

	#endregion All Public Member Function

	#region Helper Private Function

	private void SetProperties(DataTable dtTemp)
	{
		this.SalesID = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.SalesID]);
		this.LedgerNumber = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.LedgerNumber]);
		this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.Hospital_ID]);
		this.DepartmentID = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.DepartmentID]);
		this.StockID = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.StockID]);
		this.SoldUnits = Util.GetDecimal(dtTemp.Rows[0][AllTables.Sales_Details.SoldUnits]);
		this.PerUnitBuyPrice = Util.GetDecimal(dtTemp.Rows[0][AllTables.Sales_Details.PerUnitBuyPrice]);
		this.PerUnitSellingPrice = Util.GetDecimal(dtTemp.Rows[0][AllTables.Sales_Details.PerUnitSellingPrice]);
		this.IsReturn = Util.GetInt(dtTemp.Rows[0][AllTables.Sales_Details.IsReturn]);
		this.Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.Sales_Details.Date]);
		this.Time = Util.GetDateTime(dtTemp.Rows[0][AllTables.Sales_Details.Time]);
		this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.ItemID]);
		this.IsService = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.IsService]);
		this.IndentNo = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.IndentNo]);
		this.Naration = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.Naration]);
		this.SalesNo = Util.GetInt(dtTemp.Rows[0][AllTables.Sales_Details.SalesNo]);
		this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.Sales_Details.LedgerTransactionNo]);
	}

	#endregion Helper Private Function
}