#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Patient_IPD_Profile
{
    #region All Memory Variables

    private int _PatientIPDProfile_ID;
    private string _TransactionID;
    private string _IPDCaseType_ID;
    private string _IPDCaseType_ID_Bill;
    private string _Room_ID;
    private System.DateTime _StartDate;
    private System.DateTime _StartTime;
    private System.DateTime _EndDate;
    private System.DateTime _EndTime;
    private string _Status;
    private int _IsTempAllocated;
    private int _PanelID;
    private string _PatientID;
    private int _TobeBill;
    private int _CentreID;
    private string _Hospital_Id;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Patient_IPD_Profile()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.TransactionID = "LHSP1";
    }

    public Patient_IPD_Profile(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int PatientIPDProfile_ID
    {
        get
        {
            return _PatientIPDProfile_ID;
        }
        set
        {
            _PatientIPDProfile_ID = value;
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

    public virtual string IPDCaseTypeID
    {
        get
        {
            return _IPDCaseType_ID;
        }
        set
        {
            _IPDCaseType_ID = value;
        }
    }

    public virtual string IPDCaseTypeID_Bill
    {
        get
        {
            return _IPDCaseType_ID_Bill;
        }
        set
        {
            _IPDCaseType_ID_Bill = value;
        }
    }

    public virtual string RoomID
    {
        get
        {
            return _Room_ID;
        }
        set
        {
            _Room_ID = value;
        }
    }

    public virtual System.DateTime StartDate
    {
        get
        {
            return _StartDate;
        }
        set
        {
            _StartDate = value;
        }
    }

    public virtual System.DateTime StartTime
    {
        get
        {
            return _StartTime;
        }
        set
        {
            _StartTime = value;
        }
    }

    public virtual System.DateTime EndDate
    {
        get
        {
            return _EndDate;
        }
        set
        {
            _EndDate = value;
        }
    }

    public virtual System.DateTime EndTime
    {
        get
        {
            return _EndTime;
        }
        set
        {
            _EndTime = value;
        }
    }

    public virtual string Status
    {
        get
        {
            return _Status;
        }
        set
        {
            _Status = value;
        }
    }

    public virtual int IsTempAllocated
    {
        get
        {
            return _IsTempAllocated;
        }
        set
        {
            _IsTempAllocated = value;
        }
    }

    public virtual int PanelID
    {
        get
        {
            return _PanelID;
        }
        set
        {
            _PanelID = value;
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

    public virtual int TobeBill
    {
        get
        {
            return _TobeBill;
        }
        set
        {
            _TobeBill = value;
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

    public virtual string Hospital_Id
    {
        get
        {
            return _Hospital_Id;
        }
        set
        {
            _Hospital_Id = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO patient_ipd_profile(TransactionID, IPDCaseTypeID, IPDCaseTypeID_Bill, RoomID, StartDate, StartTime,");
            objSQL.Append("EndDate, EndTime, Status, IsTempAllocated,PanelID,PatientID,TobeBill,CentreID,Hospital_Id)");
            objSQL.Append("VALUES (@TransactionID, @IPDCaseTypeID, @IPDCaseTypeID_Bill, @RoomID, @StartDate, @StartTime, @EndDate, @EndTime, @Status, @IsTempAllocated, @PanelID, @PatientID, @TobeBill,@CentreID,@Hospital_Id)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PatientIPDProfile_ID = Util.GetInt(PatientIPDProfile_ID);
            this.TransactionID = Util.GetString(TransactionID);
            this.IPDCaseTypeID = Util.GetString(IPDCaseTypeID);
            this.IPDCaseTypeID_Bill = Util.GetString(IPDCaseTypeID_Bill);
            this.RoomID = Util.GetString(RoomID);
            this.StartDate = Util.GetDateTime(StartDate);
            this.StartTime = Util.GetDateTime(StartTime);
            this.EndDate = Util.GetDateTime(EndDate);
            this.EndTime = Util.GetDateTime(EndTime);
            this.Status = Util.GetString(Status);
            this.IsTempAllocated = Util.GetInt(IsTempAllocated);
            this.PanelID = PanelID;
            this.PatientID = Util.GetString(PatientID);
            this.TobeBill = Util.GetInt(TobeBill);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_Id = Util.GetString(Hospital_Id);
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PatientIPDProfile_ID", PatientIPDProfile_ID),
                new MySqlParameter("@TransactionID", TransactionID),
                new MySqlParameter("@IPDCaseTypeID", IPDCaseTypeID),
                new MySqlParameter("@IPDCaseTypeID_Bill", IPDCaseTypeID_Bill),
                new MySqlParameter("@RoomID", RoomID),
                new MySqlParameter("@StartDate", StartDate),
                new MySqlParameter("@StartTime", StartTime),
                new MySqlParameter("@EndDate", EndDate),
                new MySqlParameter("@EndTime", EndTime),
                new MySqlParameter("@Status", Status),
                new MySqlParameter("@IsTempAllocated", IsTempAllocated),
                new MySqlParameter("@PanelID", PanelID),
                new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@TobeBill", TobeBill),
                 new MySqlParameter("@CentreID", CentreID),
                  new MySqlParameter("@Hospital_Id", Hospital_Id));

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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE patient_ipd_profile SET  IPDCaseTypeID = @IPDCaseTypeID, IPDCaseTypeID_Bill = @IPDCaseTypeID_Bill, RoomID=@RoomID, StartDate = @StartDate, StartTime = @StartTime,");
            objSQL.Append("EndDate = @EndDate, EndTime = @EndTime, Status = @Status,IsTempAllocated=@IsTempAllocated ,PatientID = @PatientID,TobeBill=@TobeBill ");
            objSQL.Append("WHERE PatientIPDProfile_ID =@PatientIPDProfile_ID ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PatientIPDProfile_ID = Util.GetInt(PatientIPDProfile_ID);
            this.TransactionID = Util.GetString(TransactionID);
            this.IPDCaseTypeID = Util.GetString(IPDCaseTypeID);
            this.IPDCaseTypeID_Bill = Util.GetString(IPDCaseTypeID_Bill);
            this.RoomID = Util.GetString(RoomID);
            this.StartDate = Util.GetDateTime(StartDate);
            this.StartTime = Util.GetDateTime(StartTime);
            this.EndDate = Util.GetDateTime(EndDate);
            this.EndTime = Util.GetDateTime(EndTime);
            this.Status = Util.GetString(Status);
            this.IsTempAllocated = Util.GetInt(IsTempAllocated);
            this.PatientID = Util.GetString(PatientID);
            this.TobeBill = Util.GetInt(TobeBill);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@IPDCaseTypeID", IPDCaseTypeID),
                new MySqlParameter("@IPDCaseTypeID_Bill", IPDCaseTypeID_Bill),
                new MySqlParameter("@RoomID", RoomID),
                new MySqlParameter("@StartDate", StartDate),
                new MySqlParameter("@StartTime", StartTime),
                new MySqlParameter("@EndDate", EndDate),
                new MySqlParameter("@EndTime", EndTime),
                new MySqlParameter("@Status", Status),
                new MySqlParameter("@IsTempAllocated", IsTempAllocated),
                new MySqlParameter("@PatientID", PatientID),
                new MySqlParameter("@TobeBill", TobeBill),
                new MySqlParameter("@PatientIPDProfile_ID", PatientIPDProfile_ID));

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
        this.PatientIPDProfile_ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_ipd_profile WHERE PatientIPDProfile_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("PatientIPDProfile_ID", PatientIPDProfile_ID));
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
            throw (ex);
        }
    }

    public bool Load()
    {
        DataTable dtTemp;

        try
        {
            string sSQL = "SELECT * FROM patient_ipd_profile WHERE PatientIPDProfile_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@PatientIPDProfile_ID", PatientIPDProfile_ID)).Tables[0];

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
            string sParams = "PatientIPDProfile_ID=" + this.PatientIPDProfile_ID.ToString();
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
        this.PatientIPDProfile_ID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.PatientIPDProfile_ID = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.PatientIPDProfile_ID]);
        this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.TransactionID]);
        this.IPDCaseTypeID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.IPDCaseTypeID]);
        this.IPDCaseTypeID_Bill = Util.GetString(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.IPDCaseTypeID_Bill]);
        this.RoomID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.RoomID]);
        this.StartDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.StartDate]);
        this.StartTime = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.StartTime]);
        this.EndDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.EndDate]);
        this.EndTime = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.EndTime]);
        this.Status = Util.GetString(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.Status]);
        this.IsTempAllocated = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.IsTempAllocated]);
        this.PanelID = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.PanelID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.PatientID]);
        this.TobeBill = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_IPD_Profile.ToBeBill]);
    }

    #endregion Helper Private Function
}