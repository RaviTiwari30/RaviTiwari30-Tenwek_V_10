using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodScreening
/// </summary>
public class BloodScreening
{
    #region All Memory Variables

    private string _BloodCollection_Id;
    private string _TestName;
    private string _value;
    private string _Method;
    private int _MethodID;
    private string _Result;
    private int _ResultID;
    private string _Result_Approval;
    private int _IsApproved;
    private string _CreatedBy;
    private string _ApprovedBy;
    private string _ApprovedDate;
    private int _CentreID;
    private string _ScreeningId;
    private int _ResultStep;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public BloodScreening()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodScreening(MySqlTransaction objTrans)
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

    public virtual string TestName
    {
        get
        {
            return _TestName;
        }
        set
        {
            _TestName = value;
        }
    }

    public virtual string value
    {
        get
        {
            return _value;
        }
        set
        {
            _value = value;
        }
    }

    public virtual string Method
    {
        get
        {
            return _Method;
        }
        set
        {
            _Method = value;
        }
    }

    public virtual int MethodID
    {
        get
        {
            return _MethodID;
        }
        set
        {
            _MethodID = value;
        }
    }

    public virtual string Result
    {
        get
        {
            return _Result;
        }
        set
        {
            _Result = value;
        }
    }

    public virtual int ResultID
    {
        get
        {
            return _ResultID;
        }
        set
        {
            _ResultID = value;
        }
    }

    public virtual string Result_Approval
    {
        get
        {
            return _Result_Approval;
        }
        set
        {
            _Result_Approval = value;
        }
    }

    public virtual int IsApproved
    {
        get
        {
            return _IsApproved;
        }
        set
        {
            _IsApproved = value;
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

    public virtual string ApprovedBy
    {
        get
        {
            return _ApprovedBy;
        }
        set
        {
            _ApprovedBy = value;
        }
    }

    public virtual string ApprovedDate
    {
        get
        {
            return _ApprovedDate;
        }
        set
        {
            _ApprovedDate = value;
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

    public virtual string ScreeningId
    {
        get
        {
            return _ScreeningId;
        }
        set
        {
            _ScreeningId = value;
        }
    }

    public virtual int ResultStep
    {
        get
        {
            return _ResultStep;
        }
        set
        {
            _ResultStep = value;
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

            objSQL.Append("bb_Blood_screening");
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
            this.BloodCollection_Id = Util.GetString(BloodCollection_Id);
            this.TestName = Util.GetString(TestName);
            this.value = Util.GetString(value);
            this.Method = Util.GetString(Method);
            this.MethodID = Util.GetInt(MethodID);
            this.Result = Util.GetString(Result);
            this.ResultID = Util.GetInt(ResultID);
            this.Result_Approval = Util.GetString(Result_Approval);
            this.IsApproved = Util.GetInt(IsApproved);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.ApprovedBy = Util.GetString(ApprovedBy);
            this.ApprovedDate = Util.GetString(ApprovedDate);
            this.CentreID = Util.GetInt(CentreID);
            this.ScreeningId = Util.GetString(ScreeningId);
            this.ResultStep = Util.GetInt(ResultStep);
            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            cmd.Parameters.Add(new MySqlParameter("@_TestName", TestName));
            cmd.Parameters.Add(new MySqlParameter("@_value", value));
            cmd.Parameters.Add(new MySqlParameter("@_Method", Method));
            cmd.Parameters.Add(new MySqlParameter("@_MethodID", MethodID));
            cmd.Parameters.Add(new MySqlParameter("@_Result", Result));
            cmd.Parameters.Add(new MySqlParameter("@_ResultID", ResultID));
            cmd.Parameters.Add(new MySqlParameter("@_Result_Approval", Result_Approval));
            cmd.Parameters.Add(new MySqlParameter("@_IsApproved", IsApproved));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@_ApprovedBy", ApprovedBy));
            cmd.Parameters.Add(new MySqlParameter("@_ApprovedDate", ApprovedDate));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@_ScreeningId", ScreeningId));
            cmd.Parameters.Add(new MySqlParameter("@_ResultStep", ResultStep));
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