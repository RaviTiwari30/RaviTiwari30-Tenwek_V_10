using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Organisation_master
/// </summary>
public class Organisation_master
{
    #region All Memory Variables

    private string _Organisation;
    private string _Address;
    private string _City;
    private string _State;
    private string _Pincode;
    private string _PhoneNo;
    private string _MobileNo;
    private string _FaxNo;
    private string _EmailID;

    private int _IsActive;
    private string _CreatedBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Organisation_master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Organisation_master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Organisation
    {
        get
        {
            return _Organisation;
        }
        set
        {
            _Organisation = value;
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

    public virtual string State
    {
        get
        {
            return _State;
        }
        set
        {
            _State = value;
        }
    }

    public virtual string Pincode
    {
        get
        {
            return _Pincode;
        }
        set
        {
            _Pincode = value;
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

    public virtual string MobileNo
    {
        get
        {
            return _MobileNo;
        }
        set
        {
            _MobileNo = value;
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

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Organisation_Master");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@@Identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Organisation = Util.GetString(Organisation);
            this.Address = Util.GetString(Address);
            this.City = Util.GetString(City);
            this.State = Util.GetString(State);
            this.Pincode = Util.GetString(Pincode);
            this.PhoneNo = Util.GetString(PhoneNo);
            this.MobileNo = Util.GetString(MobileNo);
            this.FaxNo = Util.GetString(FaxNo);
            this.EmailID = Util.GetString(EmailID);
            this.IsActive = Util.GetInt(IsActive);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@_Organisation", Organisation));
            cmd.Parameters.Add(new MySqlParameter("@_Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@_City", City));
            cmd.Parameters.Add(new MySqlParameter("@_State", State));
            cmd.Parameters.Add(new MySqlParameter("@_Pincode", Pincode));
            cmd.Parameters.Add(new MySqlParameter("@_PhoneNo", PhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_MobileNo", MobileNo));
            cmd.Parameters.Add(new MySqlParameter("@_FaxNo", FaxNo));
            cmd.Parameters.Add(new MySqlParameter("@_EmailID", EmailID));

            cmd.Parameters.Add(new MySqlParameter("@_IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(paramTnxID);
            iPkValue = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue.ToString();
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