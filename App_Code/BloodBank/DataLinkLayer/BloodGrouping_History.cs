using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodGrouping_History
/// </summary>
public class BloodGrouping_History
{
    #region All Memory Variables

    private string _Grouping_Id;
    private string _BloodCollection_Id;
    private int _IsApproved;
    private string _RejectedBy;
    private int _CentreID;
    private string _Remarks;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public BloodGrouping_History()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodGrouping_History(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Grouping_Id
    {
        get
        {
            return _Grouping_Id;
        }
        set
        {
            _Grouping_Id = value;
        }
    }

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

    public virtual string RejectedBy
    {
        get
        {
            return _RejectedBy;
        }
        set
        {
            _RejectedBy = value;
        }
    }

    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }
        set
        {
            _Remarks = value;
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
            string RejectedgroupingID = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_grouping_history");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_RejectedgroupingID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Grouping_Id = Util.GetString(Grouping_Id);
            this.BloodCollection_Id = Util.GetString(BloodCollection_Id);
            this.IsApproved = Util.GetInt(IsApproved);
            this.RejectedBy = Util.GetString(RejectedBy);
            this.Remarks = Util.GetString(Remarks);

            this.CentreID = Util.GetInt(CentreID);

            cmd.Parameters.Add(new MySqlParameter("@_Grouping_Id", Grouping_Id));
            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            cmd.Parameters.Add(new MySqlParameter("@_IsApproved", IsApproved));
            cmd.Parameters.Add(new MySqlParameter("@_RejectedBy", RejectedBy));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));

            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(paramTnxID);

            RejectedgroupingID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return RejectedgroupingID.ToString();
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