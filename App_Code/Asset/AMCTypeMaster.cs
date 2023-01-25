using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for AMCTypeMaster
/// </summary>
public class AMCTypeMaster
{
    public AMCTypeMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public AMCTypeMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _AMCTypeID;
    private string _AMCName;
    private string _AMCCode;
    private int _IsActive;
    private string _CreatedBy;
    private string _Address;
    private string _ContactNo;
    private string _Country;
    private string _City;
    private string _EmailID;
    private string _FaxNo;
    private string _AMCDuedays;
    private string _ContactPerson_1;
    private string _ContactPersonContctNo_1;
    private string _ContactPersonDesignation_1;
    private string _ContactPersonEmailID_1;
    private string _ContactPerson_2;
    private string _ContactPersonContctNo_2;
    private string _ContactPersonDesignation_2;
    private string _ContactPersonEmailID_2;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int AMCTypeID { get { return _AMCTypeID; } set { _AMCTypeID = value; } }
    public virtual string AMCName { get { return _AMCName; } set { _AMCName = value; } }
    public virtual string AMCCode { get { return _AMCCode; } set { _AMCCode = value; } }
    public virtual int IsActive { get { return _IsActive; } set { _IsActive = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string Address { get { return _Address; } set { _Address = value; } }
    public virtual string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
    public virtual string Country { get { return _Country; } set { _Country = value; } }
    public virtual string City { get { return _City; } set { _City = value; } }
    public virtual string EmailID { get { return _EmailID; } set { _EmailID = value; } }
    public virtual string FaxNo { get { return _FaxNo; } set { _FaxNo = value; } }
    public virtual string AMCDuedays { get { return _AMCDuedays; } set { _AMCDuedays = value; } }
    public virtual string ContactPerson_1 { get { return _ContactPerson_1; } set { _ContactPerson_1 = value; } }
    public virtual string ContactPersonContctNo_1 { get { return _ContactPersonContctNo_1; } set { _ContactPersonContctNo_1 = value; } }
    public virtual string ContactPersonDesignation_1 { get { return _ContactPersonDesignation_1; } set { _ContactPersonDesignation_1 = value; } }
    public virtual string ContactPersonEmailID_1 { get { return _ContactPersonEmailID_1; } set { _ContactPersonEmailID_1 = value; } }
    public virtual string ContactPerson_2 { get { return _ContactPerson_2; } set { _ContactPerson_2 = value; } }
    public virtual string ContactPersonContctNo_2 { get { return _ContactPersonContctNo_2; } set { _ContactPersonContctNo_2 = value; } }
    public virtual string ContactPersonDesignation_2 { get { return _ContactPersonDesignation_2; } set { _ContactPersonDesignation_2 = value; } }
    public virtual string ContactPersonEmailID_2 { get { return _ContactPersonEmailID_2; } set { _ContactPersonEmailID_2 = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_amctypemaster_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vAMCName", Util.GetString(AMCName)));
            cmd.Parameters.Add(new MySqlParameter("@vAMCCode", Util.GetString(AMCCode)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vAddress", Util.GetString(Address)));
            cmd.Parameters.Add(new MySqlParameter("@vContactNo", Util.GetString(ContactNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCountry", Util.GetString(Country)));
            cmd.Parameters.Add(new MySqlParameter("@vCity", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@vEmailID", Util.GetString(EmailID)));
            cmd.Parameters.Add(new MySqlParameter("@vFaxNo", Util.GetString(FaxNo)));
            cmd.Parameters.Add(new MySqlParameter("@vAMCDuedays", Util.GetString(AMCDuedays)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPerson_1", Util.GetString(ContactPerson_1)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPersonContctNo_1", Util.GetString(ContactPersonContctNo_1)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPersonDesignation_1", Util.GetString(ContactPersonDesignation_1)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPersonEmailID_1", Util.GetString(ContactPersonEmailID_1)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPerson_2", Util.GetString(ContactPerson_2)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPersonContctNo_2", Util.GetString(ContactPersonContctNo_2)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPersonDesignation_2", Util.GetString(ContactPersonDesignation_2)));
            cmd.Parameters.Add(new MySqlParameter("@vContactPersonEmailID_2", Util.GetString(ContactPersonEmailID_2)));

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

    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ass_amctypemaster_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_AMCTypeID", AMCTypeID));
            cmd.Parameters.Add(new MySqlParameter("@_AMCName", AMCName));
            cmd.Parameters.Add(new MySqlParameter("@_AMCCode", AMCCode));
            cmd.Parameters.Add(new MySqlParameter("@_IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@_Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@_ContactNo", ContactNo));
            cmd.Parameters.Add(new MySqlParameter("@_Country", Country));
            cmd.Parameters.Add(new MySqlParameter("@_City", City));
            cmd.Parameters.Add(new MySqlParameter("@_EmailID", EmailID));
            cmd.Parameters.Add(new MySqlParameter("@_FaxNo", FaxNo));
            cmd.Parameters.Add(new MySqlParameter("@_AMCDuedays", AMCDuedays));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPerson_1", ContactPerson_1));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPersonContctNo_1", ContactPersonContctNo_1));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPersonDesignation_1", ContactPersonDesignation_1));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPersonEmailID_1", ContactPersonEmailID_1));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPerson_2", ContactPerson_2));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPersonContctNo_2", ContactPersonContctNo_2));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPersonDesignation_2", ContactPersonDesignation_2));
            cmd.Parameters.Add(new MySqlParameter("@_ContactPersonEmailID_2", ContactPersonEmailID_2));

            Output = cmd.ExecuteNonQuery().ToString();

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