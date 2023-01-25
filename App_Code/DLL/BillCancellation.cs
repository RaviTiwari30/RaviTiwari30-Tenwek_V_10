using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class BillCancellation
{
    #region All Memory Variables
       
    private int _BillCancel_ID;
    private string _PatientID;
    private string _TransactionID;
    private string _BillNo;    
    private System.DateTime _CancelDate;    
    private string _CancelUserID;
    private string _CancelReason;
    private System.DateTime _BillDate;
    private string _BillGenerateUserID;
    private string _IPAddress;
    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

	public BillCancellation()
	{
		objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        
	}
    public BillCancellation(MySqlTransaction objTrans)
	{
		this.objTrans = objTrans;
        this.IsLocalConn = false;
	}
 #region Set All Property

    public virtual int BillCancel_ID
    {
        get
        {
            return _BillCancel_ID;
        }
        set
        {
            _BillCancel_ID = value;
        }
    }
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
    public virtual string TransactionID
    {
        get
        {
            return _TransactionID;
        }
        set
        {
            _TransactionID = value;
        }
    }
    public virtual string BillNo
    {
        get
        {
            return _BillNo;
        }
        set
        {
            _BillNo = value;
        }
    }


    public virtual DateTime CancelDate
    {
        get
        {
            return _CancelDate;
        }
        set
        {
            _CancelDate = value;
        }
    }

    public virtual string CancelUserID
    {
        get
        {
            return _CancelUserID;
        }
        set
        {
            _CancelUserID = value;
        }
    }


    public virtual string CancelReason
    {
        get
        {
            return _CancelReason;
        }
        set
        {
            _CancelReason = value;
        }
    }

    public virtual DateTime BillDate
    {
        get
        {
            return _BillDate;
        }
        set
        {
            _BillDate = value;
        }
    }

    public virtual string BillGenerateUserID
    {
        get
        {
            return _BillGenerateUserID;
        }
        set
        {
            _BillGenerateUserID = value;
        }
    }

    public virtual string IPAddress
    {
        get
        {
            return _IPAddress;
        }
        set
        {
            _IPAddress = value;
        }
    }
    #endregion
    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_billcancellation(PatientID,TransactionID,BillNo,CancelDate,CancelUserID,CancelReason,BillDate,BillGenerateUserID,IPAddress)");
            objSQL.Append("VALUES (@PatientID, @TransactionID, @BillNo, @CancelDate, @CancelUserID, @CancelReason, @BillDate, @BillGenerateUserID,@IPAddress)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.BillNo = Util.GetString(BillNo);
            this.CancelDate = Util.GetDateTime(CancelDate);
            this.CancelUserID = Util.GetString(CancelUserID);
            this.CancelReason = Util.GetString(CancelReason);
            this.BillDate = Util.GetDateTime(BillDate);
            this.BillGenerateUserID = Util.GetString(BillGenerateUserID);
            this.IPAddress = Util.GetString(IPAddress);
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@TransactionID", TransactionID),
                new MySqlParameter("@BillNo", BillNo),
                new MySqlParameter("@CancelDate", CancelDate),
                new MySqlParameter("@CancelUserID", CancelUserID),
                new MySqlParameter("@CancelReason", CancelReason),
                new MySqlParameter("@BillDate", BillDate),
                new MySqlParameter("@IPAddress", IPAddress),
                new MySqlParameter("@BillGenerateUserID", BillGenerateUserID));


            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE bodypart_symptom SET PatientID = ?, TransactionID = ?, BillNo = ?, CancelDate = ?, CancelUserID = ?,CancelReason = ?,BillDate = ?,BillGenerateUserID = ? WHERE BillCancel_ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.BillNo = Util.GetString(BillNo);
            this.CancelDate = Util.GetDateTime(CancelDate);
            this.CancelUserID = Util.GetString(CancelUserID);
            this.CancelReason = Util.GetString(CancelReason);
            this.BillDate = Util.GetDateTime(BillDate);
            this.BillGenerateUserID = Util.GetString(BillGenerateUserID);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

               new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@TransactionID", TransactionID),
                new MySqlParameter("@BillNo", BillNo),
                new MySqlParameter("@CancelDate", CancelDate),
                new MySqlParameter("@CancelUserID", CancelUserID),
                new MySqlParameter("@CancelReason", CancelReason),
                new MySqlParameter("@BillDate", BillDate),
                new MySqlParameter("@BillGenerateUserID", BillGenerateUserID));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }

    }

    public int Delete(int iPkValue)
    {
        this.BillCancel_ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_billcancellation WHERE BillCancel_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("BillCancel_ID", BillCancel_ID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
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

    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM f_billcancellation WHERE BillCancel_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@BillCancel_ID", BillCancel_ID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);
            string sParams = "BillCancel_ID=" + this.BillCancel_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(int iPkValue)
    {
        this.BillCancel_ID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.BillCancel_ID = Util.GetInt(dtTemp.Rows[0][AllTables.billcancellation.BillCancel_ID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.billcancellation.PatientID]);
        this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.billcancellation.TransactionID]);
        this.BillNo = Util.GetString(dtTemp.Rows[0][AllTables.billcancellation.BillNo]);
        this.CancelDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.billcancellation.CancelDate]);
        this.CancelUserID = Util.GetString(dtTemp.Rows[0][AllTables.billcancellation.CancelUserID]);
        this.CancelReason = Util.GetString(dtTemp.Rows[0][AllTables.billcancellation.CancelReason]);
    }
    #endregion
}

