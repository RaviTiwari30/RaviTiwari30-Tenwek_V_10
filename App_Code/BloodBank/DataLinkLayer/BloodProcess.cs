using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodProcess
/// </summary>
public class BloodProcess
{
    #region All Memory Variables

    private string _PatientID;
    private string _LedgerTnxID;
    private string _ItemID;
    private decimal _Qtypending;
    private string _ProsessBy;
    private int _CentreId;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public BloodProcess()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodProcess(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string PatientID
    {
        get
        {
            return _PatientID;
        }
        set
        {
            _PatientID = value;
        }
    }

    public virtual string LedgerTnxID
    {
        get
        {
            return _LedgerTnxID;
        }
        set
        {
            _LedgerTnxID = value;
        }
    }

    public virtual string ItemID
    {
        get
        {
            return _ItemID;
        }
        set
        {
            _ItemID = value;
        }
    }

    public virtual decimal Qtypending
    {
        get
        {
            return _Qtypending;
        }
        set
        {
            _Qtypending = value;
        }
    }

    public virtual string ProsessBy
    {
        get
        {
            return _ProsessBy;
        }
        set
        {
            _ProsessBy = value;
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

            objSQL.Append("bb_Prosess_blood");
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
            this.PatientID = Util.GetString(PatientID);
            this.LedgerTnxID = Util.GetString(LedgerTnxID);
            this.ItemID = Util.GetString(ItemID);
            this.Qtypending = Util.GetDecimal(Qtypending);
            this.ProsessBy = Util.GetString(ProsessBy);
            this.CentreId = Util.GetInt(CentreId);

            cmd.Parameters.Add(new MySqlParameter("@_PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTnxID", LedgerTnxID));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@_Qtypending", Qtypending));
            cmd.Parameters.Add(new MySqlParameter("@_ProsessBy", ProsessBy));
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