#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class DoctorHospital
{
    #region All Memory Variables

    private int _DoctorHospital_ID;
    private string _DoctorID;
    private string _Hospital_ID;
    private int _ConsultantOutFlag;
    private System.DateTime _TimeIn;
    private System.DateTime _TimeOut;
    private string _Days;
    private string _Description;
    private string _Creator_ID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DoctorHospital()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DoctorHospital(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int DoctorHospital_ID
    {
        get
        {
            return _DoctorHospital_ID;
        }
        set
        {
            _DoctorHospital_ID = value;
        }
    }

    public virtual int ConsultantOutFlag
    {
        get
        {
            return _ConsultantOutFlag;
        }
        set
        {
            _ConsultantOutFlag = value;
        }
    }

    public virtual string DoctorID
    {
        get
        {
            return _DoctorID;
        }
        set
        {
            _DoctorID = value;
        }
    }

    public virtual string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
        }
    }

    public virtual System.DateTime Timein
    {
        get
        {
            return _TimeIn;
        }
        set
        {
            _TimeIn = value;
        }
    }

    public virtual System.DateTime Timeout
    {
        get
        {
            return _TimeOut;
        }
        set
        {
            _TimeOut = value;
        }
    }

    public virtual string Day
    {
        get
        {
            return _Days;
        }
        set
        {
            _Days = value;
        }
    }

    public virtual string Description
    {
        get
        {
            return _Description;
        }
        set
        {
            _Description = value;
        }
    }

    public virtual string Creator_ID
    {
        get
        {
            return _Creator_ID;
        }
        set
        {
            _Creator_ID = value;
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
            objSQL.Append("INSERT INTO doctor_hospital (DoctorHospital_ID,DoctorID,ConsultantOutFlag,Hospital_ID,TimeIn,TimeOut,Days,Description,Creator_ID)");
            objSQL.Append("VALUES (@DoctorHospital_ID,@DoctorID,@ConsultantOutFlag,@Hospital_ID,@TimeIn,@TimeOut,@Day,@Description,@Creator_ID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.DoctorHospital_ID = Util.GetInt(DoctorHospital_ID);
            this.DoctorID = Util.GetString(DoctorID);
            this.ConsultantOutFlag = Util.GetInt(ConsultantOutFlag);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Timein = Util.GetDateTime(Timein);
            this.Timeout = Util.GetDateTime(Timeout);
            this.Day = Util.GetString(Day);
            this.Description = Util.GetString(Description);
            Creator_ID = Util.GetString(Creator_ID);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@DoctorHospital_ID", DoctorHospital_ID),
                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@ConsultantOutFlag", ConsultantOutFlag),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@TimeIn", Timein),
                new MySqlParameter("@TimeOut", Timeout),
                new MySqlParameter("@Day", Day),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Creator_ID", Creator_ID));

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

    public bool Load()
    {
        DataTable dtTemp;

        try
        {
            string sSQL = "SELECT * FROM doctor_hospital WHERE DoctorHospital_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@DoctorHospital_ID", DoctorHospital_ID)).Tables[0];

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
            string sParams = "DoctorHospital_ID=" + this.DoctorHospital_ID.ToString();
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
        this.DoctorHospital_ID = iPkValue;
        return this.Load();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE doctor_hospital SET DoctorID = ?, Hospital_ID = ?,ConsultantOutFlag=?, TimeIn = ?, TimeOut = ?,");
            objSQL.Append("Days = ?, Creator_ID = ? WHERE DoctorHospital_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.DoctorHospital_ID = Util.GetInt(DoctorHospital_ID);
            this.DoctorID = Util.GetString(DoctorID);
            this.ConsultantOutFlag = Util.GetInt(ConsultantOutFlag);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Timein = Util.GetDateTime(Timein);
            this.Timeout = Util.GetDateTime(Timeout);
            this.Day = Util.GetString(Day);
            this.Description = Util.GetString(Description);
            Creator_ID = Util.GetString(Creator_ID);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("DoctorID", DoctorID),
                new MySqlParameter("Hospital_ID", Hospital_ID),
                new MySqlParameter("ConsultantOutFlag", ConsultantOutFlag),
                new MySqlParameter("TimeIn", Timein),
                new MySqlParameter("TimeOut", Timeout),
                new MySqlParameter("Days", Day),
                new MySqlParameter("Description", Description),
                new MySqlParameter("Creator_ID", Creator_ID),
                new MySqlParameter("DoctorHospital_ID", DoctorHospital_ID));

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
        this.DoctorHospital_ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM doctor_hospital WHERE DoctorHospital_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("DoctorHospital_ID", DoctorHospital_ID));
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

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.DoctorHospital_ID = Util.GetInt(dtTemp.Rows[0][AllTables.doctor_hospital.DoctorHospital_ID]);
        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.doctor_hospital.DoctorID]);
        this.ConsultantOutFlag = Util.GetInt(dtTemp.Rows[0][AllTables.doctor_hospital.ConsultantOutFlag]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.doctor_hospital.Hospital_ID]);
        this.Timein = Util.GetDateTime(dtTemp.Rows[0][AllTables.doctor_hospital.TimeIn]);
        this.Timeout = Util.GetDateTime(dtTemp.Rows[0][AllTables.doctor_hospital.TimeOut]);
        this.Day = Util.GetString(dtTemp.Rows[0][AllTables.doctor_hospital.Days]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.doctor_hospital.Description]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.doctor_hospital.Creator_ID]);
    }

    #endregion Helper Private Function
}
