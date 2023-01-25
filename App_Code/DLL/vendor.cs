using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for vendor
/// </summary>
public class vendor
{
    #region All Memory Variables

    private string _Vendor_ID;
    private string _VendorName;
    private string _VendorCode;
    private string _VendorType;
    private string _VendorCategory;
    private string _Bank;
    private string _AccountNo;
    private string _PaymentMode;
    private string _ShipmentDetail;
    private string _VATNo;

    private string _StoreID;
    private string _ContactPerson;
    private string _Address1;
    private string _Address2;
    private string _Address3;
    private string _Country;
    private string _City;
    private string _Area;
    private string _Pin;
    private string _Telephone;
    private string _Fax;
    private string _Mobile;
    private string _DrugLicence;
    private string _Email;
    private string _CreditDays;
    private string _TinNo;
    private string _SupplierTypeID;
    private string _IsActive;
    //gst
    private string _GSTINNo;
    private string _DeptLedgerNo;
    private int _StateID;
    private int _CountryID;
    private int _isAsset;
    private string _COA_ID;
    private string _VATType;
    private string _Currency;
	 private int _IsInsuranceProvider; 
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public vendor()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.Location = AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
    }

    public vendor(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Vendor_ID
    {
        get
        {
            return _Vendor_ID;
        }
        set
        {
            _Vendor_ID = value;
        }
    }

    public virtual string COA_ID
    {
        get
        {
            return _COA_ID;
        }
        set
        {
            _COA_ID = value;
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

    public virtual string VendorCode
    {
        get
        {
            return _VendorCode;
        }
        set
        {
            _VendorCode = value;
        }
    }

    public virtual string VendorType
    {
        get
        {
            return _VendorType;
        }
        set
        {
            _VendorType = value;
        }
    }

    public virtual string VendorCategory
    {
        get
        {
            return _VendorCategory;
        }
        set
        {
            _VendorCategory = value;
        }
    }

    public virtual string Bank
    {
        get
        {
            return _Bank;
        }
        set
        {
            _Bank = value;
        }
    }

    public virtual string AccountNo
    {
        get
        {
            return _AccountNo;
        }
        set
        {
            _AccountNo = value;
        }
    }

    public virtual string PaymentMode
    {
        get
        {
            return _PaymentMode;
        }
        set
        {
            _PaymentMode = value;
        }
    }

    public virtual string ShipmentDetail
    {
        get
        {
            return _ShipmentDetail;
        }
        set
        {
            _ShipmentDetail = value;
        }
    }

    public virtual string VATNo
    {
        get
        {
            return _VATNo;
        }
        set
        {
            _VATNo = value;
        }
    }

    public virtual string Email
    {
        get
        {
            return _Email;
        }
        set
        {
            _Email = value;
        }
    }

    public virtual string StoreID
    {
        get
        {
            return _StoreID;
        }
        set
        {
            _StoreID = value;
        }
    }

    public virtual string ContactPerson
    {
        get
        {
            return _ContactPerson;
        }
        set
        {
            _ContactPerson = value;
        }
    }

    public virtual string Address1
    {
        get
        {
            return _Address1;
        }
        set
        {
            _Address1 = value;
        }
    }

    public virtual string Address2
    {
        get
        {
            return _Address2;
        }
        set
        {
            _Address2 = value;
        }
    }

    public virtual string Address3
    {
        get
        {
            return _Address3;
        }
        set
        {
            _Address3 = value;
        }
    }

    public virtual string Country
    {
        get
        {
            return _Country;
        }
        set
        {
            _Country = value;
        }
    }

    public virtual string City
    {
        get
        {
            return _City;
        }
        set
        {
            _City = value;
        }
    }

    public virtual string Area
    {
        get
        {
            return _Area;
        }
        set
        {
            _Area = value;
        }
    }

    public virtual string Pin
    {
        get
        {
            return _Pin;
        }
        set
        {
            _Pin = value;
        }
    }

    public virtual string Telephone
    {
        get
        {
            return _Telephone;
        }
        set
        {
            _Telephone = value;
        }
    }

    public virtual string Fax
    {
        get
        {
            return _Fax;
        }
        set
        {
            _Fax = value;
        }
    }

    public virtual string Mobile
    {
        get
        {
            return _Mobile;
        }
        set
        {
            _Mobile = value;
        }
    }

    public virtual string DrugLicence
    {
        get
        {
            return _DrugLicence;
        }
        set
        {
            _DrugLicence = value;
        }
    }

    public virtual string CreditDays
    {
        get
        {
            return _CreditDays;
        }
        set
        {
            _CreditDays = value;
        }
    }

    public virtual string TinNo
    { get { return _TinNo; } set { _TinNo = value; } }

    public virtual string SupplierTypeID
    { get { return _SupplierTypeID; } set { _SupplierTypeID = value; } }

    public virtual string IsActive
    { get { return _IsActive; } set { _IsActive = value; } }
    public virtual string GSTINNo
    {
        get { return _GSTINNo; }
        set { _GSTINNo = value; }
    }
    public virtual string DeptLedgerNo
    {
        get { return _DeptLedgerNo; }
        set { _DeptLedgerNo = value; }
    }
    public virtual int StateID
    {
        get { return _StateID; }
        set { _StateID = value; }
    }
    public virtual int CountryID
    {
        get { return _CountryID; }
        set { _CountryID = value; }
    }

    public virtual int IsAsset
    {
        get { return _isAsset; }
        set { _isAsset = value; }
    }

    public virtual string VATType
    {
        get { return _VATType; }
        set { _VATType = value; }
    }

    

    public string Currency
    {
        get { return _Currency; }
        set { _Currency = value; }
    }
    public virtual int IsInsuranceProvider
    {
        get { return _IsInsuranceProvider; }
        set { _IsInsuranceProvider =value; }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("Insert_Vendor");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@Vendor_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.VendorName = Util.GetString(VendorName);
            this.VendorCode = Util.GetString(VendorCode);
            this.VendorType = Util.GetString(VendorType);
            this.VendorCategory = Util.GetString(VendorCategory);
            this.Bank = Util.GetString(Bank);
            this.AccountNo = Util.GetString(AccountNo);
            this.PaymentMode = Util.GetString(PaymentMode);
            this.ShipmentDetail = Util.GetString(ShipmentDetail);
            this.VATNo = Util.GetString(VATNo);
            this.StoreID = Util.GetString(StoreID);
            this.ContactPerson = Util.GetString(ContactPerson);
            this.Address1 = Util.GetString(Address1);
            this.Address2 = Util.GetString(Address2);
            this.Address3 = Util.GetString(Address3);
            this.Country = Util.GetString(Country);
            this.City = Util.GetString(City);
            this.Area = Util.GetString(Area);
            this.Pin = Util.GetString(Pin);
            this.Telephone = Util.GetString(Telephone);
            this.Fax = Util.GetString(Fax);
            this.Mobile = Util.GetString(Mobile);
            this.DrugLicence = Util.GetString(DrugLicence);
            this.Email = Util.GetString(Email);
            this.CreditDays = Util.GetString(CreditDays);
            this.TinNo = Util.GetString(TinNo);
            this.SupplierTypeID = Util.GetString(SupplierTypeID);
            this.IsActive = Util.GetString(IsActive);
            this.GSTINNo = Util.GetString(GSTINNo);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.StateID = Util.GetInt(StateID);
            this.CountryID = Util.GetInt(CountryID);
            this.IsAsset = IsAsset;
            this.COA_ID = Util.GetString(COA_ID);
            this.VATType = Util.GetString(VATType);
            this.Currency = Util.GetString(Currency);
			this.IsInsuranceProvider = IsInsuranceProvider;
            cmd.Parameters.Add(new MySqlParameter("@VendorName", VendorName));
            cmd.Parameters.Add(new MySqlParameter("@VendorCode", VendorCode));
            cmd.Parameters.Add(new MySqlParameter("@VendorType", VendorType));
            cmd.Parameters.Add(new MySqlParameter("@VendorCategory", VendorCategory));
            cmd.Parameters.Add(new MySqlParameter("@Bank", Bank));
            cmd.Parameters.Add(new MySqlParameter("@AccountNo", AccountNo));
            cmd.Parameters.Add(new MySqlParameter("@PaymentMode", PaymentMode));
            cmd.Parameters.Add(new MySqlParameter("@ShipmentDetail", ShipmentDetail));
            cmd.Parameters.Add(new MySqlParameter("@VATNo", VATNo));
            cmd.Parameters.Add(new MySqlParameter("@StoreID", StoreID));
            cmd.Parameters.Add(new MySqlParameter("@ContactPerson", ContactPerson));
            cmd.Parameters.Add(new MySqlParameter("@Address1", Address1));
            cmd.Parameters.Add(new MySqlParameter("@Address2", Address2));
            cmd.Parameters.Add(new MySqlParameter("@Address3", Address3));
            cmd.Parameters.Add(new MySqlParameter("@Country", Country));
            cmd.Parameters.Add(new MySqlParameter("@City", City));
            cmd.Parameters.Add(new MySqlParameter("@AREA", Area));
            cmd.Parameters.Add(new MySqlParameter("@Pin", Pin));
            cmd.Parameters.Add(new MySqlParameter("@Telephone", Telephone));
            cmd.Parameters.Add(new MySqlParameter("@Fax", Fax));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@DrugLicence", DrugLicence));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@CreditDays", CreditDays));
            cmd.Parameters.Add(new MySqlParameter("@TinNo", TinNo));
            cmd.Parameters.Add(new MySqlParameter("@SupplierTypeID", SupplierTypeID));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@GSTINNo", GSTINNo));
            cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@StateID", StateID));
            cmd.Parameters.Add(new MySqlParameter("@CountryID", CountryID));
            cmd.Parameters.Add(new MySqlParameter("@IsAsset", IsAsset));
            cmd.Parameters.Add(new MySqlParameter("@vCOA_ID", COA_ID));
            cmd.Parameters.Add(new MySqlParameter("@vVATType", VATType));
            cmd.Parameters.Add(new MySqlParameter("@vCurrency", Currency));
            cmd.Parameters.Add(new MySqlParameter("@IsInsuranceProvider", IsInsuranceProvider));


            cmd.Parameters.Add(paramTnxID);
            //cmd.ExecuteNonQuery();

            Vendor_ID = cmd.ExecuteScalar().ToString();

            //iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Vendor_ID;
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
            string sSQL = "SELECT * FROM f_vendormaster WHERE Vendor_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@Vendor_ID", Vendor_ID)).Tables[0];

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
            string sParams = "Vendor_ID=" + this.Vendor_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.Vendor_ID = iPkValue.ToString();
        return this.Load();
    }

    public int Update(int iPkValue)
    {
        this.Vendor_ID = iPkValue.ToString();
        return this.Update();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_vendormaster SET VendorName=?,VendorCode=?,VendorType=?,VendorCategory=?,Bank=?,AccountNo=?,PaymentMode=?,ShipmentDetail=?,VATNo=?, StoreID = ?,ContactPerson=?,Address1=?,Address2=?,Address3=?,Country=?,City=?,Area=?,Pin=?,Telephone=?,Fax=?,Mobile=?,DrugLicence=?,Creditdays=?,TinNo=?,SupplierTypeID=?,IsActive=?,Ven_GSTINNo=?,DeptLedgerNo=? WHERE Vendor_ID = ?");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.VendorName = Util.GetString(VendorName);
            this.VendorCode = Util.GetString(VendorCode);
            this.VendorType = Util.GetString(VendorType);
            this.VendorCategory = Util.GetString(VendorCategory);
            this.Bank = Util.GetString(Bank);
            this.AccountNo = Util.GetString(AccountNo);
            this.PaymentMode = Util.GetString(PaymentMode);
            this.ShipmentDetail = Util.GetString(ShipmentDetail);
            this.VATNo = Util.GetString(VATNo);
            this.StoreID = Util.GetString(StoreID);
            this.ContactPerson = Util.GetString(ContactPerson);
            this.Address1 = Util.GetString(Address1);
            this.Address2 = Util.GetString(Address2);
            this.Address3 = Util.GetString(Address3);
            this.Country = Util.GetString(Country);
            this.City = Util.GetString(City);
            this.Area = Util.GetString(Area);
            this.Pin = Util.GetString(Pin);
            this.Telephone = Util.GetString(Telephone);
            this.Fax = Util.GetString(Fax);
            this.Mobile = Util.GetString(Mobile);
            this.DrugLicence = Util.GetString(DrugLicence);
            this.Vendor_ID = Util.GetString(Vendor_ID);
            this.CreditDays = Util.GetString(CreditDays);
            this.TinNo = Util.GetString(TinNo);
            this.SupplierTypeID = Util.GetString(SupplierTypeID);
            this.IsActive = Util.GetString(IsActive);
            this.GSTINNo = Util.GetString(GSTINNo);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);


            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

               new MySqlParameter("VendorName", VendorName),
               new MySqlParameter("VendorCode", VendorCode),
               new MySqlParameter("VendorType", VendorType),
               new MySqlParameter("VendorCategory", VendorCategory),
               new MySqlParameter("Bank", Bank),
               new MySqlParameter("AccountNo", AccountNo),
               new MySqlParameter("PaymentMode", PaymentMode),
               new MySqlParameter("ShipmentDetail", ShipmentDetail),
               new MySqlParameter("VATNo", VATNo),
               new MySqlParameter("StoreID", StoreID),
               new MySqlParameter("ContactPerson", ContactPerson),
               new MySqlParameter("Address1", Address1),
               new MySqlParameter("Address2", Address2),
               new MySqlParameter("Address3", Address3),
               new MySqlParameter("Country", Country),
               new MySqlParameter("City", City),
               new MySqlParameter("Area", Area),
               new MySqlParameter("Pin", Pin),
               new MySqlParameter("Telephone", Telephone),
               new MySqlParameter("Fax", Fax),
               new MySqlParameter("Mobile", Mobile),
               new MySqlParameter("DrugLicence", DrugLicence),
               new MySqlParameter("Vendor_ID", Vendor_ID),
               new MySqlParameter("CreditDays", CreditDays),
               new MySqlParameter("@GSTINNo", GSTINNo),
               new MySqlParameter("DeptLedgerNo", DeptLedgerNo));

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

    public int Delete(int iPkValue)
    {
        this.Vendor_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_vendor_master WHERE Vendor_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Vendor_ID", Vendor_ID));
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

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Vendor_ID = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Vendor_ID]);
        this.VendorName = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.VendorName]);
        this.VATNo = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.VATNo]);
        this.Address1 = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Address1]);
        this.Address2 = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Address2]);
        this.Address3 = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Address3]);
        this.StoreID = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.StoreID]);
        this.ContactPerson = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.ContactPerson]);
        this.Country = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Country]);
        this.City = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.City]);
        this.Area = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Area]);
        this.Pin = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Pin]);
        this.Telephone = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Telephone]);
        this.Fax = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Fax]);
        this.Mobile = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.Mobile]);
        this.DrugLicence = Util.GetString(dtTemp.Rows[0][AllTables.VendorMaster.DrugLicence]);
    }

    #endregion Helper Private Function
}