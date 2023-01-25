using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for ipd_case_type_master
/// </summary>
public class ipd_case_type_master
{
    #region All Memory Variables
    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _IPDCaseType_ID;
    private string _Name;
    private string _Description;
    private string _Ownership;
    private System.DateTime _Creator_Date;
    private string _Creator_Id;
    private int _No_Of_Round;
    private int _IsActive;
    private string _BillingCategoryID;
    private string _IpAddress;
    private int _CentreID;
    private int _IsEmergency;
    private int _RevenueMappingID;
    private string _RevenueCoa_ID;
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor

    public ipd_case_type_master()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;

	}
    public ipd_case_type_master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
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
    public virtual string IPDCaseType_ID
    {
        get
        {
            return _IPDCaseType_ID;
        }
        set
        {
            _IPDCaseType_ID = value;
        }
    }
    public virtual string Name
    {
        get
        {
            return _Name;
        }
        set
        {
            _Name = value;
        }
    }
    public virtual string Description
    {
        get
        {
            return _Description;
        }
        set
        {
            _Description = value;
        }
    }

    public virtual string Ownership
    {
        get
        {
            return _Ownership;
        }
        set
        {
            _Ownership = value;
        }
    }

    public virtual string Creator_Id
    {
        get
        {
            return _Creator_Id;
        }
        set
        {
            _Creator_Id = value;
        }
    }
    public virtual System.DateTime Creator_Date
    {
        get
        {
            return _Creator_Date;
        }
        set
        {
            _Creator_Date = value;
        }
    }
    public virtual int No_Of_Round
    {
        get
        {
            return _No_Of_Round;
        }
        set
        {
            _No_Of_Round = value;
        }
    }

    public virtual int IsActive
    {
        get
        {
            return _IsActive;
        }
        set
        {
            _IsActive = value;
        }
    }
    public virtual string BillingCategoryID
    {
        get
        {
            return _BillingCategoryID;
        }
        set
        {
            _BillingCategoryID = value;
        }
    }
    public virtual string IpAddress
    {
        get
        {
            return _IpAddress;
        }
        set
        {
            _IpAddress = value;
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
    public virtual int IsEmergency { get { return _IsEmergency; } set { _IsEmergency = value; } }

    public virtual int RevenueMappingID {
        get {

            return _RevenueMappingID;
        }
        set {
            _RevenueMappingID = value;
        }
    }
    public virtual string RevenueCoa_ID {
        get {
            return _RevenueCoa_ID;
        }
        set {
            _RevenueCoa_ID = value;
        }
    }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {
            
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_ipd_casetype_master");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@IPD_CaseType_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_Id = Util.GetString(Creator_Id);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.No_Of_Round = Util.GetInt(No_Of_Round);
            this.IsActive = Util.GetInt(IsActive);
            this.BillingCategoryID = Util.GetString(BillingCategoryID);
            this.IpAddress = Util.GetString(IpAddress);
            this.CentreID = Util.GetInt(CentreID);
            this.IsEmergency = Util.GetInt(IsEmergency);
            this.RevenueMappingID = Util.GetInt(RevenueMappingID);
            this.RevenueCoa_ID = Util.GetString(RevenueCoa_ID);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@Creator_Id", Creator_Id));
            cmd.Parameters.Add(new MySqlParameter("@Creator_Date", Creator_Date));
            cmd.Parameters.Add(new MySqlParameter("@No_Of_Round", No_Of_Round));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@BillingCategoryID", BillingCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@IpAddress", IpAddress));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vRevenueMappingID", RevenueMappingID));
            cmd.Parameters.Add(new MySqlParameter("@vRevenueCoa_ID", RevenueCoa_ID));
            cmd.Parameters.Add(paramTnxID);
            
            string IPDCaseTypeID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return IPDCaseTypeID;
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE ipd_casetype_master SET Name = ?,Description=?, Creator_Id = ?, Creator_Date = ?,No_Of_Round=?,IsActive=? WHERE IPDCaseType_ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_Id = Util.GetString(Creator_Id);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.No_Of_Round = Util.GetInt(No_Of_Round);
            this.IsActive = Util.GetInt(IsActive);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Creator_Id", Creator_Id),
                new MySqlParameter("@Creator_Date", Creator_Date),
                new MySqlParameter("@No_Of_Round", No_Of_Round),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@IPDCaseType_ID", IPDCaseType_ID));
            

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
        this.IPDCaseType_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM ipd_casetype_master WHERE IPDCaseType_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("IPDCaseType_ID", IPDCaseType_ID));
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

            string sSQL = "SELECT * FROM ipd_casetype_master WHERE IPDCaseType_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@IPDCaseType_ID", IPDCaseType_ID)).Tables[0];

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
            string sParams = "IPDCaseType_ID=" + this.IPDCaseType_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    public bool Load(int iPkValue)
    {
        this.IPDCaseType_ID = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.HospCode]);
        this._IPDCaseType_ID = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.IPDCaseType_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.Description]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.Ownership]);
        this.Creator_Id = Util.GetString(dtTemp.Rows[0][AllTables.ipd_case_type_master.Creator_ID]);
        this.Creator_Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.ipd_case_type_master.Creator_Date]);
        this.No_Of_Round = Util.GetInt(dtTemp.Rows[0][AllTables.ipd_case_type_master.No_Of_Round]);
    }
    #endregion





}
