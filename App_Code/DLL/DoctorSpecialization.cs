#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces

/// <summary>
/// Summary description for DoctorSpecialization
/// </summary>
public class DoctorSpecialization
{
    #region All Memory Variables
   // DoctorID Specilazation IssueDate ValidationDate IssuedBy IssuedAt
    private string _DoctorID;
    private string _Specilazation;
    private string _IssueDate;
    private string _ValidationDate;
    private string _IssuedBy;
    private string _IssuedAt;
    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public DoctorSpecialization()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public DoctorSpecialization(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
	#endregion
    #region Set All Property

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
    public virtual string Specilazation
    {
        get
        {
            return _Specilazation;
        }
        set
        {
            _Specilazation = value;
        }
    }

    public virtual string IssueDate
    {
        get
        {
            return _IssueDate;
        }
        set
        {
            _IssueDate = value;
        }
    }
    public virtual string ValidationDate
    {
        get
        {
            return _ValidationDate;
        }
        set
        {
            _ValidationDate = value;
        }
    }
    public virtual string IssuedBy
    {
        get
        {
            return _IssuedBy;
        }
        set
        {
            _IssuedBy = value;
        }
    }
    public virtual string IssuedAt
    {
        get
        {
            return _IssuedAt;
        }
        set
        {
            _IssuedAt = value;
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

            objSQL.Append("INSERT INTO doctor_specialization(DoctorID, Specilazation,IssueDate, ValidationDate, IssuedBy,IssuedAt)");
            objSQL.Append("VALUES (@DoctorID,@Specilazation, @IssueDate, @ValidationDate, @IssuedBy, @IssuedAt)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.DoctorID = Util.GetString(DoctorID);
            this.Specilazation = Util.GetString(Specilazation);
            this.IssueDate = Util.GetString(IssueDate);
            this.ValidationDate = Util.GetString(ValidationDate);
            this.IssuedBy = Util.GetString(IssuedBy);
            this.IssuedAt = Util.GetString(IssuedAt);


            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@Specilazation", Specilazation),
                 new MySqlParameter("@IssueDate", IssueDate),
                new MySqlParameter("@ValidationDate", ValidationDate),
                new MySqlParameter("@IssuedBy", IssuedBy),
               new MySqlParameter("@IssuedAt", IssuedAt));


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

    // created update/ delete/ load function by Sonika Dt 3 oct 2007
    public int Update()
    {
        try
        {
            this.DoctorID = Util.GetString(DoctorID);
            this.Specilazation = Util.GetString(Specilazation);
            this.IssueDate = Util.GetString(IssueDate);
            this.ValidationDate = Util.GetString(ValidationDate);
            this.IssuedBy = Util.GetString(IssuedBy);
            this.IssuedAt = Util.GetString(IssuedAt);
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();



            objSQL.Append("UPDATE doctor_specialization SET Specilazation = ?,IssueDate = ?, ValidationDate = ?,");
            objSQL.Append("IssuedBy = ?,IssuedAt=? WHERE DoctorID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


                 new MySqlParameter("@Specilazation", Specilazation),
                 new MySqlParameter("@IssueDate", IssueDate),
                 new MySqlParameter("@ValidationDate", ValidationDate),
                 new MySqlParameter("@IssuedBy", IssuedBy),
                 new MySqlParameter("@IssuedAt", IssuedAt),
                 new MySqlParameter("@DoctorID", DoctorID));


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


    public int Update(string DoctorID)
    {
        this.DoctorID = Util.GetString(DoctorID);
        return this.Update();
    }


    public int Delete(string DoctorID)
    {
        this.DoctorID = Util.GetString(DoctorID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM doctor_specialization WHERE DoctorID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("DoctorID", DoctorID));
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

            string sSQL = "SELECT * FROM doctor_specialization WHERE DoctorID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@DoctorID", DoctorID)).Tables[0];

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
            string sParams = "DoctorID=" + this.DoctorID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string DoctorID)
    {
        this.DoctorID = Util.GetString(DoctorID);
        return this.Load();
    }

    #endregion All Public Member Function


    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        //DoctorID Specilazation ValidationDate IssuedBy
        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.DoctorSpecialization.DoctorID]);
        this.Specilazation = Util.GetString(dtTemp.Rows[0][AllTables.DoctorSpecialization.Specilazation]);
        this.IssueDate = Util.GetString(dtTemp.Rows[0][AllTables.DoctorSpecialization.IssueDate]);
        this.ValidationDate = Util.GetString(dtTemp.Rows[0][AllTables.DoctorSpecialization.ValidationDate]);
        this.IssuedBy = Util.GetString(dtTemp.Rows[0][AllTables.DoctorSpecialization.IssuedBy]);
        this.IssuedAt = Util.GetString(dtTemp.Rows[0][AllTables.DoctorSpecialization.IssuedAt]);

    }
    #endregion
}

