using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodScreening_History
/// </summary>
public class BloodScreening_History
{
    #region All Memory Variables

    private string _Screening_Id;
    private string _BloodCollection_Id;
    private int _IsApproved;
    private string _RejectrdBy;
    private int _CentreID;
    private string _Remarks;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public BloodScreening_History()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodScreening_History(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Screening_Id
    {
        get
        {
            return _Screening_Id;
        }
        set
        {
            _Screening_Id = value;
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

    public virtual string RejectrdBy
    {
        get
        {
            return _RejectrdBy;
        }
        set
        {
            _RejectrdBy = value;
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

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string RejectScreeningId = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_screening_historyInsert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_RejectScreeningId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Screening_Id = Util.GetString(Screening_Id);
            this.BloodCollection_Id = Util.GetString(BloodCollection_Id);
            this.IsApproved = Util.GetInt(IsApproved);
            this.RejectrdBy = Util.GetString(RejectrdBy);
            this.CentreID = Util.GetInt(CentreID);
            this.Remarks = Util.GetString(Remarks);
            cmd.Parameters.Add(new MySqlParameter("@_Screening_Id", Screening_Id));
            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            cmd.Parameters.Add(new MySqlParameter("@_IsApproved", IsApproved));
            cmd.Parameters.Add(new MySqlParameter("@_RejectrdBy", RejectrdBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));
            cmd.Parameters.Add(paramTnxID);

            RejectScreeningId = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return RejectScreeningId.ToString();
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