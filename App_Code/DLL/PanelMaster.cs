#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class PanelMaster
{
    #region All Memory Variables

    private string _Company_Name;
    private string _Add1;
    private string _Add2;
    private string _PanelID;
    private string _Hospital_ID;
    private string _Panel_Code;
    private string _ReferenceCode;
    private string _IsTPA;
    private string _EmailID;
    private string _Phone;
    private string _Mobile;
    private string _Contact_Person;
    private string _Fax_No;
    private string _ReferenceCodeOPD;
    private string _isServiceTax;
    private string _Agreement;
    private string _DateFrom;
    private string _DateTo;
    private string _CreditLimit;
    private string _PaymentMode;
    private string _PanelGroup;
    private string _IPAddress;
    private int _PanelGroupID;
    private string _CreatedBy;
    private int _ShowPrintOut;
    private int _HideRate;
    private int _co_PaymentOn;
    private double _co_PaymentPercent;
    private int _rateCurrencyCountryID;
    private int _BillCurrencyCountryID;
    private string _BillCurrencyCountryName;
    private decimal _BillCurrencyConversion;
    private int _IsCash;
    private int _CoverNote;
    private int _IsSmartCard;

    private decimal _PanelAmountLimit;
    private int _IsPrivateDiet;


    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PanelMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.Location=AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
    }

    public PanelMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Company_Name
    {
        get
        {
            return _Company_Name;
        }
        set
        {
            _Company_Name = value;
        }
    }

    public virtual string Add1
    {
        get
        {
            return _Add1;
        }
        set
        {
            _Add1 = value;
        }
    }

    public virtual string Add2
    {
        get
        {
            return _Add2;
        }
        set
        {
            _Add2 = value;
        }
    }

    public virtual string PanelID
    {
        get
        {
            return _PanelID;
        }
        set
        {
            _PanelID = value;
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

    public virtual string Panel_Code
    {
        get
        {
            return _Panel_Code;
        }
        set
        {
            _Panel_Code = value;
        }
    }

    public virtual string ReferenceCode
    {
        get
        {
            return _ReferenceCode;
        }
        set
        {
            _ReferenceCode = value;
        }
    }

    public virtual string IsTPA
    {
        get
        {
            return _IsTPA;
        }
        set
        {
            _IsTPA = value;
        }
    }

    public virtual string EmailID
    {
        get
        {
            return _EmailID;
        }
        set
        {
            _EmailID = value;
        }
    }

    public virtual string Phone
    {
        get
        {
            return _Phone;
        }
        set
        {
            _Phone = value;
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

    public virtual string Contact_Person
    {
        get
        {
            return _Contact_Person;
        }
        set
        {
            _Contact_Person = value;
        }
    }

    public virtual string Fax_No
    {
        get
        {
            return _Fax_No;
        }
        set
        {
            _Fax_No = value;
        }
    }

    public virtual string ReferenceCodeOPD
    {
        get
        {
            return _ReferenceCodeOPD;
        }
        set
        {
            _ReferenceCodeOPD = value;
        }
    }

    public virtual string isServiceTax
    {
        get
        {
            return _isServiceTax;
        }
        set
        {
            _isServiceTax = value;
        }
    }

    public virtual string Agreement
    {
        get
        {
            return _Agreement;
        }
        set
        {
            _Agreement = value;
        }
    }

    public virtual string DateFrom
    {
        get
        {
            return _DateFrom;
        }
        set
        {
            _DateFrom = value;
        }
    }

    public virtual string DateTo
    {
        get
        {
            return _DateTo;
        }
        set
        {
            _DateTo = value;
        }
    }

    public virtual string CreditLimit
    {
        get
        {
            return _CreditLimit;
        }
        set
        {
            _CreditLimit = value;
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

    public virtual string PanelGroup
    {
        get
        {
            return _PanelGroup;
        }
        set
        {
            _PanelGroup = value;
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
    public virtual int PanelGroupID
    {
        get
        {
            return _PanelGroupID;
        }
        set
        {
            _PanelGroupID = value;
        }
    }
    public virtual string CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }
    public virtual int HideRate
    {
        get
        {
            return _HideRate;
        }
        set
        {
            _HideRate = value;
        }
    }
    public virtual int ShowPrintOut
    {
        get
        {
            return _ShowPrintOut;
        }
        set
        {
            _ShowPrintOut = value;
        }
    }
    public virtual int co_PaymentOn
    {
        get
        {
            return _co_PaymentOn;
        }
        set
        {
            _co_PaymentOn = value;
        }
    }
    public virtual double co_PaymentPercent
    {
        get
        {
            return _co_PaymentPercent;
        }
        set
        {
            _co_PaymentPercent = value;
        }
    }

    public virtual int rateCurrencyCountryID
    {
        get
        {
            return _rateCurrencyCountryID;
        }
        set
        {
            _rateCurrencyCountryID = value;
        }
    }
    public virtual int BillCurrencyCountryID
    {
        get
        {
            return _BillCurrencyCountryID;
        }
        set
        {
            _BillCurrencyCountryID = value;
        }
    }
    public virtual string  BillCurrencyCountryName
    {
        get
        {
            return _BillCurrencyCountryName;
        }
        set
        {
            _BillCurrencyCountryName = value;
        }
    }
    public virtual decimal BillCurrencyConversion
    {
        get
        {
            return _BillCurrencyConversion;
        }
        set
        {
            _BillCurrencyConversion = value;
        }
    }
    public virtual int IsCash
    {
        get
        {
            return _IsCash;
        }
        set
        {
            _IsCash = value;
        }
    }
    public virtual int CoverNote
    {
        get
        {
            return _CoverNote;
        }
        set
        {
            _CoverNote = value;
        }
    }
    public virtual int IsSmartCard
    {
        get
        {
            return _IsSmartCard;
        }
        set
        {
            _IsSmartCard = value;
        }
    }
    public virtual decimal PanelAmountLimit
    {
        get
        {
            return _PanelAmountLimit;
        }
        set
        {
            _PanelAmountLimit = value;
        }
    }

    public virtual int IsPrivateDiet
    {
        get
        {
            return _IsPrivateDiet;
        }
        set
        {
            _IsPrivateDiet = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT_Panel");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vPanelID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Company_Name = Util.GetString(Company_Name);
            this.Add1 = Util.GetString(Add1);
            this.Add2 = Util.GetString(Add2);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Panel_Code = Util.GetString(Panel_Code);
            this.ReferenceCode = Util.GetString(ReferenceCode);
            this.IsTPA = Util.GetString(IsTPA);
            this.EmailID = Util.GetString(EmailID);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.Contact_Person = Util.GetString(Contact_Person);
            this.Fax_No = Util.GetString(Fax_No);
            this.ReferenceCodeOPD = Util.GetString(ReferenceCodeOPD);
            this.isServiceTax = Util.GetString(isServiceTax);
            this.Agreement = Util.GetString(Agreement);
            this.DateFrom = Util.GetString(DateFrom);
            this.DateTo = Util.GetString(DateTo);
            this.CreditLimit = Util.GetString(CreditLimit);
            this.PaymentMode = Util.GetString(PaymentMode);
            this.PanelGroup = Util.GetString(PanelGroup);
            this.PanelGroupID = Util.GetInt(PanelGroupID);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.IPAddress = Util.GetString(IPAddress);
            this.HideRate = Util.GetInt(HideRate);
            this.ShowPrintOut = Util.GetInt(ShowPrintOut);
            this.co_PaymentOn = Util.GetInt(co_PaymentOn);
            this.co_PaymentPercent = Util.GetDouble(co_PaymentPercent);
            this.BillCurrencyCountryName = Util.GetString(BillCurrencyCountryName);
            this.BillCurrencyConversion = Util.GetDecimal(BillCurrencyConversion);
            this.IsCash = Util.GetInt(IsCash);
            this.CoverNote = Util.GetInt(CoverNote);
            this.IsSmartCard = Util.GetInt(IsSmartCard);           
            this.PanelAmountLimit = Util.GetDecimal(PanelAmountLimit);
            this.IsPrivateDiet = Util.GetInt(IsPrivateDiet);


            cmd.Parameters.Add(new MySqlParameter("@Company_Name", Company_Name));
            cmd.Parameters.Add(new MySqlParameter("@Add1", Add1));
            cmd.Parameters.Add(new MySqlParameter("@Add2", Add2));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@Panel_Code", Panel_Code));
            cmd.Parameters.Add(new MySqlParameter("@ReferenceCode", ReferenceCode));
            cmd.Parameters.Add(new MySqlParameter("@IsTPA", IsTPA));
            cmd.Parameters.Add(new MySqlParameter("@EmailID", EmailID));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Phone));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@Contact_Person", Contact_Person));
            cmd.Parameters.Add(new MySqlParameter("@Fax_No", Fax_No));
            cmd.Parameters.Add(new MySqlParameter("@ReferenceCodeOPD", ReferenceCodeOPD));
            cmd.Parameters.Add(new MySqlParameter("@Agreement", Agreement));
            cmd.Parameters.Add(new MySqlParameter("@isServiceTax", isServiceTax));
            cmd.Parameters.Add(new MySqlParameter("@DateFrom", DateFrom));
            cmd.Parameters.Add(new MySqlParameter("@DateTo", DateTo));
            cmd.Parameters.Add(new MySqlParameter("@CreditLimit", CreditLimit));
            cmd.Parameters.Add(new MySqlParameter("@PaymentMode", PaymentMode));
            cmd.Parameters.Add(new MySqlParameter("@PanelGroup", PanelGroup));           
            cmd.Parameters.Add(new MySqlParameter("@PanelGroupID", PanelGroupID));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@HideRate", HideRate));
            cmd.Parameters.Add(new MySqlParameter("@ShowPrintOut", ShowPrintOut));
            cmd.Parameters.Add(new MySqlParameter("@vCo_PaymentOn",co_PaymentOn));
            cmd.Parameters.Add(new MySqlParameter("@vCo_PaymentPercent", co_PaymentPercent));
            cmd.Parameters.Add(new MySqlParameter("@vRateCurrencyCountryID", rateCurrencyCountryID));
            cmd.Parameters.Add(new MySqlParameter("@vBillCurrencyCountryID", BillCurrencyCountryID));
            cmd.Parameters.Add(new MySqlParameter("@vBillCurrencyCountryName", BillCurrencyCountryName));
            cmd.Parameters.Add(new MySqlParameter("@vBillCurrencyConversion", BillCurrencyConversion));
            cmd.Parameters.Add(new MySqlParameter("@vIsCash", IsCash));
            cmd.Parameters.Add(new MySqlParameter("@vCoverNote", CoverNote));
            cmd.Parameters.Add(new MySqlParameter("@vIsSmartCard", IsSmartCard));
            cmd.Parameters.Add(new MySqlParameter("@PanelAmountLimit", PanelAmountLimit));
            cmd.Parameters.Add(new MySqlParameter("@vIsPrivateDiet", IsPrivateDiet));


            cmd.Parameters.Add(paramTnxID);

            PanelID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PanelID.ToString();
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

    //created update /delete/load function by sonika dt 3 oct 2007

    public int Update()
    {
        try
        {
            this.Company_Name = Util.GetString(Company_Name);
            this.Add1 = Util.GetString(Add1);
            this.Add2 = Util.GetString(Add2);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Panel_Code = Util.GetString(Panel_Code);
            this.ReferenceCode = Util.GetString(ReferenceCode);
            this.IsTPA = Util.GetString(IsTPA);
            this.EmailID = Util.GetString(EmailID);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.Contact_Person = Util.GetString(Contact_Person);
            this.Fax_No = Util.GetString(Fax_No);
            this.ReferenceCodeOPD = Util.GetString(ReferenceCodeOPD);
            this.co_PaymentOn = Util.GetInt(co_PaymentOn);
            this.co_PaymentPercent = Util.GetDouble(co_PaymentPercent);
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_panel_master SET  Company_Name=?, Add1=?, ID=?,Add2=?,Hospital_ID=?,Panel_Code = ?,ReferenceCode=? ,IsTPA=?, EmailID=?, Phone=?, Mobile=?, Contact_Person=?, Fax_No = ?,ReferenceCodeOPD=?,Co_PaymentOn=?,Co_PaymentPercent=? WHERE PanelID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Company_Name", Company_Name),
                new MySqlParameter("@Add1", Add1),
                new MySqlParameter("@Add2", Add2),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@Panel_Code", Panel_Code),
                new MySqlParameter("@ReferenceCode", ReferenceCode),
                new MySqlParameter("@IsTPA", IsTPA),
                new MySqlParameter("@EmailID", EmailID),
                new MySqlParameter("@Phone", Phone),
                new MySqlParameter("@Mobile", Mobile),
                new MySqlParameter("@Phone", Phone),
                new MySqlParameter("@Mobile", Mobile),
                new MySqlParameter("@Contact_Person", Contact_Person),
                new MySqlParameter("@Fax_No", Fax_No),
                new MySqlParameter("@ReferenceCodeOPD", ReferenceCodeOPD),
                new MySqlParameter("@PanelID", PanelID),
                new MySqlParameter("@Co_PaymentOn", co_PaymentOn),
                new MySqlParameter("@Co_PaymentPercent", co_PaymentPercent));

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

    public int Update(string PanelID)
    {
        this.PanelID = Util.GetString(PanelID);
        return this.Update();
    }

    public int Delete(string PanelID)
    {
        this.PanelID = Util.GetString(PanelID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_panel_master WHERE PanelID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("PanelID", PanelID));
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
            string sSQL = "SELECT * FROM f_panel_master WHERE PanelID = ? ";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@PanelID", PanelID)).Tables[0];

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
            string sParams = "PanelID=" + this.PanelID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string PatientID)
    {
        this.PanelID = Util.GetString(PanelID);
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Company_Name = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Company_Name]);
        this.Add1 = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Add1]);
        this.Add2 = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Add2]);
        this.PanelID = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.PanelID]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Hospital_ID]);
        this.Panel_Code = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Panel_Code]);
        this.ReferenceCode = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.ReferenceCode]);
        this.IsTPA = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.IsTPA]);
        this.EmailID = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.EmailID]);
        this.Phone = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Phone]);
        this.Mobile = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Mobile]);
        this.Contact_Person = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Contact_Person]);
        this.Fax_No = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.Fax_No]);
        this.ReferenceCodeOPD = Util.GetString(dtTemp.Rows[0][AllTables.PanelMaster.ReferenceCodeOPD]);
    }

    #endregion Helper Private Function
}
