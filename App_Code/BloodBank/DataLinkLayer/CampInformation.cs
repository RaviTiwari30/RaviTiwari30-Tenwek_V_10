using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for CampInformation
/// </summary>
public class CampInformation
{
    #region All Memory Variables

    private int _Camp_Id;
    private string _CampDate;
    private string _TimeOfAssemble;
    private string _TimeOfDeparture;
    private string _TimeOfArrival;
    private string _TimeOfStart;

    private string _TimeOfClosing;
    private string _VehicleType;
    private string _VehicleNo;
    private string _PresidentName;
    private string _PAddress;
    private string _PPhoneNo;
    private string _SecretaryName;
    private string _SAddress;
    private string _SPhoneNo;
    private string _ConvenerName;
    private string _CAddress;
    private string _CPhoneNo;
    private string _CreatedBy;
    private int _CentreId;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public CampInformation()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public CampInformation(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int Camp_Id
    {
        get
        {
            return _Camp_Id;
        }
        set
        {
            _Camp_Id = value;
        }
    }

    public virtual string CampDate
    {
        get
        {
            return _CampDate;
        }
        set
        {
            _CampDate = value;
        }
    }

    public virtual string TimeOfAssemble
    {
        get
        {
            return _TimeOfAssemble;
        }
        set
        {
            _TimeOfAssemble = value;
        }
    }

    public virtual string TimeOfDeparture
    {
        get
        {
            return _TimeOfDeparture;
        }
        set
        {
            _TimeOfDeparture = value;
        }
    }

    public virtual string TimeOfArrival
    {
        get
        {
            return _TimeOfArrival;
        }
        set
        {
            _TimeOfArrival = value;
        }
    }

    public virtual string TimeOfStart
    {
        get
        {
            return _TimeOfStart;
        }
        set
        {
            _TimeOfStart = value;
        }
    }

    public virtual string TimeOfClosing
    {
        get
        {
            return _TimeOfClosing;
        }
        set
        {
            _TimeOfClosing = value;
        }
    }

    public virtual string VehicleType
    {
        get
        {
            return _VehicleType;
        }
        set
        {
            _VehicleType = value;
        }
    }

    public virtual string VehicleNo
    {
        get
        {
            return _VehicleNo;
        }
        set
        {
            _VehicleNo = value;
        }
    }

    public virtual string PresidentName
    {
        get
        {
            return _PresidentName;
        }
        set
        {
            _PresidentName = value;
        }
    }

    public virtual string PAddress
    {
        get
        {
            return _PAddress;
        }
        set
        {
            _PAddress = value;
        }
    }

    public virtual string PPhoneNo
    {
        get
        {
            return _PPhoneNo;
        }
        set
        {
            _PPhoneNo = value;
        }
    }

    public virtual string SecretaryName
    {
        get
        {
            return _SecretaryName;
        }
        set
        {
            _SecretaryName = value;
        }
    }

    public virtual string SAddress
    {
        get
        {
            return _SAddress;
        }
        set
        {
            _SAddress = value;
        }
    }

    public virtual string SPhoneNo
    {
        get
        {
            return _SPhoneNo;
        }
        set
        {
            _SPhoneNo = value;
        }
    }

    public virtual string ConvenerName
    {
        get
        {
            return _ConvenerName;
        }
        set
        {
            _ConvenerName = value;
        }
    }

    public virtual string CAddress
    {
        get
        {
            return _CAddress;
        }
        set
        {
            _CAddress = value;
        }
    }

    public virtual string CPhoneNo
    {
        get
        {
            return _CPhoneNo;
        }
        set
        {
            _CPhoneNo = value;
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

    public virtual int CentreId
    {
        get
        {
            return _CentreId;
        }
        set
        {
            _CentreId = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_campInformation_Insert");
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

            this.Camp_Id = Util.GetInt(Camp_Id);
            this.CampDate = Util.GetString(CampDate);
            this.TimeOfAssemble = Util.GetString(TimeOfAssemble);
            this.TimeOfDeparture = Util.GetString(TimeOfDeparture);
            this.TimeOfArrival = Util.GetString(TimeOfArrival);
            this.TimeOfStart = Util.GetString(TimeOfStart);
            this.TimeOfClosing = Util.GetString(TimeOfClosing);
            this.VehicleType = Util.GetString(VehicleType);
            this.VehicleNo = Util.GetString(VehicleNo);
            this.PAddress = Util.GetString(PAddress);
            this.PPhoneNo = Util.GetString(PPhoneNo);
            this.SecretaryName = Util.GetString(SecretaryName);
            this.SAddress = Util.GetString(SAddress);
            this.SPhoneNo = Util.GetString(SPhoneNo);
            this.ConvenerName = Util.GetString(ConvenerName);
            this.CAddress = Util.GetString(CAddress);
            this.CPhoneNo = Util.GetString(CPhoneNo);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CentreId = Util.GetInt(CentreId);

            cmd.Parameters.Add(new MySqlParameter("@_Camp_Id", Camp_Id));
            cmd.Parameters.Add(new MySqlParameter("@_CampDate", CampDate));
            cmd.Parameters.Add(new MySqlParameter("@_TimeOfAssemble", TimeOfAssemble));
            cmd.Parameters.Add(new MySqlParameter("@_TimeOfDeparture", TimeOfDeparture));
            cmd.Parameters.Add(new MySqlParameter("@_TimeOfArrival", TimeOfArrival));
            cmd.Parameters.Add(new MySqlParameter("@_TimeOfStart", TimeOfStart));
            cmd.Parameters.Add(new MySqlParameter("@_TimeOfClosing", TimeOfClosing));
            cmd.Parameters.Add(new MySqlParameter("@_VehicleType", VehicleType));
            cmd.Parameters.Add(new MySqlParameter("@_VehicleNo", VehicleNo));
            cmd.Parameters.Add(new MySqlParameter("@_PAddress", PAddress));
            cmd.Parameters.Add(new MySqlParameter("@_PPhoneNo", PPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_SecretaryName", SecretaryName));
            cmd.Parameters.Add(new MySqlParameter("@_SAddress", SAddress));
            cmd.Parameters.Add(new MySqlParameter("@_SPhoneNo", SPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_ConvenerName", ConvenerName));
            cmd.Parameters.Add(new MySqlParameter("@_CAddress", CAddress));
            cmd.Parameters.Add(new MySqlParameter("@_CPhoneNo", CPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_CPhoneNo", CPhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreId));

            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

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
            throw (ex);
        }
    }

    #endregion All Public Member Function
}