using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for BillFinalisedCancel
/// </summary>
public class BillFinalisedCancel
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

	public BillFinalisedCancel()
	{
		objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        
	}
    public BillFinalisedCancel(MySqlTransaction objTrans)
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
            objSQL.Append("INSERT INTO f_BillFinalisedCancel(PatientID,TransactionID,BillNo,CancelDate,CancelUserID,CancelReason,BillDate,BillGenerateUserID,IPAddress)");
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
            throw (ex);
        }

    }



    #endregion



}