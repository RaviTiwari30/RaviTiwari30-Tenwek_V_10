using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for CountryMaster
/// </summary>
public class CountryMaster
{
    #region All Memory Variables

    private string _NAME;
    private string _Currency;
    private string _Notation;
    private string _Address;
    private string  _PhoneNo;
    private string _FaxNo;
    private string _EmbassyAddress;
    private string _EmbassyPhoneNo;
    private string _EmbessyFaxNo;
    private string _EntryUserID;
    private DateTime _Updatedate;
    private string _UpdateByID;
    private int _Isactive;
    private string _CountryID;
    private int _IsBaseCurrency;

    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public CountryMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public CountryMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion 
    #region Set All Property

    public virtual int IsBaseCurrency
    {
        get
        {
            return _IsBaseCurrency;
        }
        set
        {
            _IsBaseCurrency = value;
        }
    }

    public virtual string NAME
    {
        get
        {
            return _NAME;
        }
        set
        {
            _NAME = value;
        }
    }
    public virtual string Currency
    {
        get
        {
            return _Currency;
        }
        set
        {
            _Currency = value;
        }
    }
    public virtual string Notation
    {
        get
        {
            return _Notation;
        }
        set
        {
            _Notation = value;
        }
    }
    public virtual string Address
    {
        get
        {
            return _Address;
        }
        set
        {
            _Address = value;
        }
    }
    public virtual string PhoneNo
    {
        get
        {
            return _PhoneNo;
        }
        set
        {
            _PhoneNo = value;
        }
    }
    public virtual string FaxNo
    {
        get
        {
            return _FaxNo;
        }
        set
        {
            _FaxNo = value;
        }
    }
    public virtual string EmbassyAddress
    {
        get
        {
            return _EmbassyAddress;
        }
        set
        {
            _EmbassyAddress = value;
        }
    }
    public virtual string EmbassyPhoneNo
    {
        get
        {
            return _EmbassyPhoneNo;
        }
        set
        {
            _EmbassyPhoneNo = value;
        }
    }
    public virtual string EmbessyFaxNo
    {
        get
        {
            return _EmbessyFaxNo;
        }
        set
        {
            _EmbessyFaxNo = value;
        }
    }
    public virtual int Isactive
    {
        get
        {
            return _Isactive;
        }
        set
        {
            _Isactive = value;
        }
    }
    public virtual string EntryUserID
    {
        get
        {
            return _EntryUserID;
        }
        set
        {
            _EntryUserID = value;
        }
    }
    public virtual DateTime Updatedate
    {
        get
        {
            return _Updatedate;
        }
        set
        {
            _Updatedate = value;
        }
    }
    public virtual string UpdateByID
    {
        get
        {
            return _UpdateByID;
        }
        set
        {
            _UpdateByID = value;
        }
    }
    public virtual string CountryID
    {
        get
        {
            return _CountryID;
        }
        set
        {
            _CountryID = value;
        }
    }
    #endregion
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Country");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@CountryID";

            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.NAME = Util.GetString(NAME);
            this.Notation = Util.GetString(Notation);
            this.Address = Util.GetString(Address);
            this.Currency = Util.GetString(Currency);
            this.PhoneNo = Util.GetString(PhoneNo);
            this.FaxNo = Util.GetString(FaxNo);
            this.EmbassyAddress = Util.GetString(EmbassyAddress);
            this.EmbassyPhoneNo = Util.GetString(EmbassyPhoneNo);
            this.EmbessyFaxNo = Util.GetString(EmbessyFaxNo);
            this.EntryUserID = Util.GetString(EntryUserID);
            this.IsBaseCurrency = Util.GetInt(IsBaseCurrency);

            cmd.Parameters.Add(new MySqlParameter("@Name", NAME));
            cmd.Parameters.Add(new MySqlParameter("@Notation", Notation));
            cmd.Parameters.Add(new MySqlParameter("@Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@Currency", Currency));
            cmd.Parameters.Add(new MySqlParameter("@PhoneNo", PhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@FaxNo", FaxNo));
            cmd.Parameters.Add(new MySqlParameter("@EmbassyAddress", EmbassyAddress));
            cmd.Parameters.Add(new MySqlParameter("@EmbassyPhoneNo", EmbassyPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@EmbessyFaxNo", EmbessyFaxNo));
            cmd.Parameters.Add(new MySqlParameter("@EntryUserID", EntryUserID));
            cmd.Parameters.Add(new MySqlParameter("@IsBaseCurrency", IsBaseCurrency));

            cmd.Parameters.Add(paramTnxID);

            CountryID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return CountryID;
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
            objSQL.Append("UPDATE country_master SET Name = @Name, Currency = @Currency, Notation = @Notation, Address=@Address,PhoneNo=@PhoneNo,FaxNo=@FaxNo,EmbassyAddress=@EmbassyAddress,EmbassyPhoneNo=@EmbassyPhoneNo,EmbessyFaxNo=@EmbessyFaxNo,Isactive=@Isactive,Updatedate=@Updatedate,UpdateByID=@UpdateByID,IsBaseCurrency=@IsBaseCurrency WHERE CountryID = @CountryID ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.NAME = Util.GetString(NAME);
            this.Notation = Util.GetString(Notation);
            this.Address = Util.GetString(Address);
            this.Currency = Util.GetString(Currency);
            this.PhoneNo = Util.GetString(PhoneNo);
            this.FaxNo = Util.GetString(FaxNo);
            this.EmbassyAddress = Util.GetString(EmbassyAddress);
            this.EmbassyPhoneNo = Util.GetString(EmbassyPhoneNo);
            this.EmbessyFaxNo = Util.GetString(EmbessyFaxNo);
            this.Isactive = Util.GetInt(Isactive);
            //this.EntryUserID = Util.GetString(EntryUserID);
            this.Updatedate = Util.GetDateTime(Updatedate);
            this.UpdateByID = Util.GetString(UpdateByID);
            this.CountryID = Util.GetString(CountryID);
            this.IsBaseCurrency = Util.GetInt(IsBaseCurrency);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

              new  MySqlParameter("@Name", NAME),
            new MySqlParameter("@Notation", Notation),
            new MySqlParameter("@Address", Address),
            new MySqlParameter("@Currency", Currency),
            new MySqlParameter("@PhoneNo", PhoneNo),
            new MySqlParameter("@FaxNo", FaxNo),
            new MySqlParameter("@EmbassyAddress", EmbassyAddress),
            new MySqlParameter("@EmbassyPhoneNo", EmbassyPhoneNo),
            new MySqlParameter("@EmbessyFaxNo", EmbessyFaxNo),
            new MySqlParameter("@Isactive", Isactive),
            //new MySqlParameter("@EntryUserID", EntryUserID),
            new MySqlParameter("@Updatedate", Updatedate),
            new MySqlParameter("@UpdateByID", UpdateByID),
            new MySqlParameter("@CountryID", CountryID),
            new MySqlParameter("@IsBaseCurrency", IsBaseCurrency));

              


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
            throw (ex);
        }

    }
}