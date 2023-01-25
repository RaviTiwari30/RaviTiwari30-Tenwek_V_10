#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class DoctorMembership
{
    #region All Memory Variables

    private string _DoctorID;
    private string _Membership;
    private string _IssueDate;
    private string _IssuedAt;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DoctorMembership()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DoctorMembership(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

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

    public virtual string Membership
    {
        get
        {
            return _Membership;
        }
        set
        {
            _Membership = value;
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

    //public virtual string ValidationDate
    //{
    //    get
    //    {
    //        return _ValidationDate;
    //    }
    //    set
    //    {
    //        _ValidationDate = value;
    //    }
    //}
    //public virtual string IssuedBy
    //{
    //    get
    //    {
    //        return _IssuedBy;
    //    }
    //    set
    //    {
    //        _IssuedBy = value;
    //    }
    //}
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

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            // DoctorID Membership IssueDate ValidationDate IssuedBy IssuedAt
            objSQL.Append("INSERT INTO doctor_membership(DoctorID, Membership,IssueDate,IssuedAt)");
            objSQL.Append("VALUES(@DoctorID,@Membership, @IssueDate, @IssuedAt)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.DoctorID = Util.GetString(DoctorID);
            this.Membership = Util.GetString(Membership);
            this.IssueDate = Util.GetString(IssueDate);
            this.IssuedAt = Util.GetString(IssuedAt);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@Membership", Membership),
                new MySqlParameter("@IssueDate", IssueDate),
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

    //created updates/delete/load function by Sonika dt 3 oct2007

    public int Update()
    {
        try
        {
            this.DoctorID = Util.GetString(DoctorID);
            this.Membership = Util.GetString(Membership);
            this.IssueDate = Util.GetString(IssueDate);
            this.IssuedAt = Util.GetString(IssuedAt);
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("UPDATE doctor_membership SET Membership=?, IssueDate=?,");
            objSQL.Append("IssuedAt = ? WHERE DoctorID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                 new MySqlParameter("@Membership", Membership),
                 new MySqlParameter("@IssueDate", IssueDate),
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
            objSQL.Append("DELETE FROM doctor_membership WHERE DoctorID = ?");

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
            string sSQL = "SELECT * FROM doctor_membership WHERE DoctorID = ?";

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
        //DoctorID Degree ValidationDate IssuedBy
        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMembership.DoctorID]);
        this.Membership = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMembership.Membership]);
        this.IssueDate = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMembership.IssueDate]);
        //this.ValidationDate = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMembership.ValidationDate]);
        //this.IssuedBy = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMembership.IssuedBy]);
        this.IssuedAt = Util.GetString(dtTemp.Rows[0][AllTables.DoctorMembership.IssuedAt]);
        //DoctorID Membership IssueDate ValidationDate IssuedBy IssuedAt
    }

    #endregion Helper Private Function
}
