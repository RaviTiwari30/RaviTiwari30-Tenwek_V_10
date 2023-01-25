using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Component
/// </summary>
public class Component
{
    #region All Memory Variables

    private string _BloodCollection_Id;
    private int _Component_Id;
    private string _BagType;
    private string _Volumn;
    public int _IsComponent;
    private string _CreatedBy;
    private DateTime _ExpiryDate;
    private DateTime _Createddate;
    private int _status;
    private int _CentreID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Component()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Component(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string BloodCollection_Id
    {
        get
        {
            return _BloodCollection_Id;
        }
        set
        {
            _BloodCollection_Id = value;
        }
    }

    public virtual int Component_Id
    {
        get
        {
            return _Component_Id;
        }
        set
        {
            _Component_Id = value;
        }
    }

    public virtual string BagType
    {
        get
        {
            return _BagType;
        }
        set
        {
            _BagType = value;
        }
    }

    public virtual string Volumn
    {
        get
        {
            return _Volumn;
        }
        set
        {
            _Volumn = value;
        }
    }

    public virtual int IsComponent
    {
        get
        {
            return _IsComponent;
        }
        set
        {
            _IsComponent = value;
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

    public virtual DateTime ExpiryDate
    {
        get
        {
            return _ExpiryDate;
        }
        set
        {
            _ExpiryDate = value;
        }
    }

    public virtual DateTime Createddate
    {
        get
        {
            return _Createddate;
        }
        set
        {
            _Createddate = value;
        }
    }

    public virtual int status
    {
        get
        {
            return _status;
        }
        set
        {
            _status = value;
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

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string BloodComponentId = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Component_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_BloodComponentId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.BloodCollection_Id = Util.GetString(BloodCollection_Id);
            this.Component_Id = Util.GetInt(Component_Id);
            this.BagType = Util.GetString(BagType);
            this.Volumn = Util.GetString(Volumn);
            this.IsComponent = Util.GetInt(IsComponent);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.ExpiryDate = Util.GetDateTime(ExpiryDate);
            this.Createddate = Util.GetDateTime(Createddate);
            this.status = Util.GetInt(status);
            this.CentreID = Util.GetInt(CentreID);

            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            cmd.Parameters.Add(new MySqlParameter("@_Component_Id", Component_Id));
            cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            cmd.Parameters.Add(new MySqlParameter("@_Volumn", Volumn));
            cmd.Parameters.Add(new MySqlParameter("@_IsComponent", IsComponent));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@_ExpiryDate", ExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@_Createddate", Createddate));
            cmd.Parameters.Add(new MySqlParameter("@_Status", status));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreID));

            cmd.Parameters.Add(paramTnxID);
            BloodComponentId = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return BloodComponentId.ToString();
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