using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for CenterMaster
/// </summary>
public class Center_Master
{
    #region All Global Variables

    private bool IsLocalConn;
    private MySqlConnection objCon;
    private MySqlTransaction objTrans;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Center_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Center_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    public virtual string CentreCode
    {
        get
        {
            return _CentreCode;
        }
        set
        {
            _CentreCode = value;
        }
    }

    public virtual string CentreID
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

    public virtual string CentreName
    {
        get
        {
            return _CentreName;
        }
        set
        {
            _CentreName = value;
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

    public virtual string CreatedDate
    {
        get
        {
            return _CreatedDate;
        }
        set
        {
            _CreatedDate = value;
        }
    }

    public virtual string DiscountType
    {
        get
        {
            return _DiscountType;
        }
        set
        {
            _DiscountType = value;
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

    public virtual string IsActive
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

    public virtual int IsDefault
    {
        get
        {
            return _IsDefault;
        }
        set
        {
            _IsDefault = value;
        }
    }

    public virtual string LandlineNo
    {
        get
        {
            return _LandlineNo;
        }
        set
        {
            _LandlineNo = value;
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

    public virtual string UpdateDate
    {
        get
        {
            return _UpdateDate;
        }
        set
        {
            _UpdateDate = value;
        }
    }

    public virtual string UpdatedBy
    {
        get
        {
            return _UpdatedBy;
        }
        set
        {
            _UpdatedBy = value;
        }
    }

    public virtual string Website
    {
        get
        {
            return _Website;
        }
        set
        {
            _Website = value;
        }
    }
      public virtual string Latitude
    {
        get
        {
            return _Latitude;
        }
        set
        {
            _Latitude = value;
        }
    }
      public virtual string Longitude
    {
        get
        {
            return _Longitude;
        }
        set
        {
            _Longitude = value;
        }
    }
 
    #endregion Set All Property

    #region All Memory Variables

    private string _Address;
    private string _CentreCode;
    private string _CentreID;
    private string _CentreName;
    private string _CreatedBy;
    private string _CreatedDate;
    private string _DiscountType;
    private string _EmailID;
    private string _IsActive;
    private int _IsDefault;
    private string _LandlineNo;
    private string _MobileNo;
    private string _UpdateDate;
    private string _UpdatedBy;
    private string _Website;
    private string _Latitude;
    private string _Longitude;

    #endregion All Memory Variables

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_CenterMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@CentreID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.CentreCode = Util.GetString(CentreCode);
            this.CentreName = Util.GetString(CentreName);
            this.Website = Util.GetString(Website);
            this.Address = Util.GetString(Address);
            this.MobileNo = Util.GetString(MobileNo);
            this.LandlineNo = Util.GetString(LandlineNo);
            this.EmailID = Util.GetString(EmailID);
            this.IsActive = Util.GetString(IsActive);
            this.DiscountType = Util.GetString(DiscountType);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.IsDefault = Util.GetInt(IsDefault);
            this.Latitude = Util.GetString(Latitude);
            this.Longitude = Util.GetString(Longitude);
            cmd.Parameters.Add(new MySqlParameter("@CentreCode", CentreCode));
            cmd.Parameters.Add(new MySqlParameter("@CentreName", CentreName));
            cmd.Parameters.Add(new MySqlParameter("@Website", Website));
            cmd.Parameters.Add(new MySqlParameter("@Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@MobileNo", MobileNo));
            cmd.Parameters.Add(new MySqlParameter("@LandlineNo", LandlineNo));
            cmd.Parameters.Add(new MySqlParameter("@EmailID", EmailID));
            cmd.Parameters.Add(new MySqlParameter("@DiscountType", DiscountType));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@IsDefault", IsDefault));
            cmd.Parameters.Add(new MySqlParameter("@Latitude", Latitude));
            cmd.Parameters.Add(new MySqlParameter("@Longitude", Longitude));
            cmd.Parameters.Add(paramTnxID);

            CentreID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return CentreID;
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

    #endregion All Public Member Function
}