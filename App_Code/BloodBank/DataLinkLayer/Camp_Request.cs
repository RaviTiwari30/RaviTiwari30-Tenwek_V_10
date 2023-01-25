using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Camp_Request
/// </summary>
public class Camp_Request
{
    #region All Memory Variables

    private string _InformerName;
    private string _PhoneNo;
    private DateTime _DateOfInformation;
    private DateTime _DateOfCamp;
    private string _Place_Venue;
    private string _Organisation;
    private string _ExpectedDonation;
    private string _Req_CreatedBy;
    private int _CentreId;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Camp_Request()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Camp_Request(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string InformerName
    {
        get
        {
            return _InformerName;
        }
        set
        {
            _InformerName = value;
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

    public virtual DateTime DateOfInformation
    {
        get
        {
            return _DateOfInformation;
        }
        set
        {
            _DateOfInformation = value;
        }
    }

    public virtual DateTime DateOfCamp
    {
        get
        {
            return _DateOfCamp;
        }
        set
        {
            _DateOfCamp = value;
        }
    }

    public virtual string Place_Venue
    {
        get
        {
            return _Place_Venue;
        }
        set
        {
            _Place_Venue = value;
        }
    }

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

    public virtual string ExpectedDonation
    {
        get
        {
            return _ExpectedDonation;
        }
        set
        {
            _ExpectedDonation = value;
        }
    }

    public virtual string Req_CreatedBy
    {
        get
        {
            return _Req_CreatedBy;
        }
        set
        {
            _Req_CreatedBy = value;
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
            string CampReqId = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Camp_RequestInsert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_CampReqId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.InformerName = Util.GetString(InformerName);
            this.PhoneNo = Util.GetString(PhoneNo);
            this.DateOfInformation = Util.GetDateTime(DateOfInformation);
            this.DateOfCamp = Util.GetDateTime(DateOfCamp);
            this.Place_Venue = Util.GetString(Place_Venue);
            this.Organisation = Util.GetString(Organisation);
            this.ExpectedDonation = Util.GetString(ExpectedDonation);
            this.Req_CreatedBy = Util.GetString(Req_CreatedBy);
            this.CentreId = Util.GetInt(CentreId);
            cmd.Parameters.Add(new MySqlParameter("@_InformerName", InformerName));
            cmd.Parameters.Add(new MySqlParameter("@_PhoneNo", PhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_DateOfInformation", DateOfInformation));
            cmd.Parameters.Add(new MySqlParameter("@_DateOfCamp", DateOfCamp));
            cmd.Parameters.Add(new MySqlParameter("@_Place_Venue", Place_Venue));
            cmd.Parameters.Add(new MySqlParameter("@_Organisation", Organisation));
            cmd.Parameters.Add(new MySqlParameter("@_ExpectedDonation", ExpectedDonation));
            cmd.Parameters.Add(new MySqlParameter("@_Req_CreatedBy", Req_CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", _CentreId));
            cmd.Parameters.Add(paramTnxID);
            CampReqId = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return CampReqId.ToString();
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