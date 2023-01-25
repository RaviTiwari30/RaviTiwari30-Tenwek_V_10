using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Surgery_Master
/// </summary>
public class Surgery_Master
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _Surgery_ID;
    private string _Department;
    private string _Name;
    private string _Ownership;
    private int _GroupID;
    private string _Creator_ID;
    private string _SurgeryCode;
    private int _IsActive;
    private string _CPTCode;
    private string _IPAddress;
    private string _SurgeryGrade;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Surgery_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public Surgery_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Location
    {
        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }

    public virtual string HospCode
    {
        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
        }
    }

    public virtual int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }

    public virtual string Surgery_ID
    {
        get
        {
            return _Surgery_ID;
        }
        set
        {
            _Surgery_ID = value;
        }
    }

    public virtual string Department
    {
        get
        {
            return _Department;
        }
        set
        {
            _Department = value;
        }
    }

    public virtual string Name
    {
        get
        {
            return _Name;
        }
        set
        {
            _Name = value;
        }
    }

    public virtual string Ownership
    {
        get
        {
            return _Ownership;
        }
        set
        {
            _Ownership = value;
        }
    }

    public virtual int GroupID
    {
        get
        {
            return _GroupID;
        }
        set
        {
            _GroupID = value;
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

    public virtual string SurgeryCode
    {
        get
        {
            return _SurgeryCode;
        }
        set
        {
            _SurgeryCode = value;
        }
    }

    public virtual int IsActive
    {
        get
        {
            return _IsActive;
        }
        set
        {
            _IsActive = value;
        }
    }

    public virtual string CPTCode
    {
        get
        {
            return _CPTCode;
        }
        set
        {
            _CPTCode = value;
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
    public virtual string SurgeryGrade
    {
        get
        {
            return _SurgeryGrade;
        }
        set
        {
            _SurgeryGrade = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Surgery");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@SurgeryID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Name = Util.GetString(Name);
            this.Ownership = Util.GetString(Ownership);
            this.GroupID = Util.GetInt(GroupID);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Department = Util.GetString(Department);
            this.SurgeryCode = Util.GetString(SurgeryCode);
            this.IsActive = Util.GetInt(IsActive);
            this.CPTCode = Util.GetString(CPTCode);
            this.IPAddress = Util.GetString(IPAddress);
            this.SurgeryGrade = Util.GetString(SurgeryGrade);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@Department", Department));
            cmd.Parameters.Add(new MySqlParameter("@SurgeryCode", SurgeryCode));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@CPTCode", CPTCode));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@SurgeryGrade", SurgeryGrade));
            cmd.Parameters.Add(paramTnxID);

            Surgery_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Surgery_ID;
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
            objSQL.Append("UPDATE f_surgery_master SET CPTCode=@CPTCode,Name = @Name, Ownership = @Ownership, GroupID = @GroupID, Creator_ID=@Creator_ID,Department=@Department,SurgeryCode=@SurgeryCode,IsActive=@IsActive,SurgeryGrade=@SurgeryGrade WHERE Surgery_ID = @Surgery_ID ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Name = Util.GetString(Name);
            this.Ownership = Util.GetString(Ownership);
            this.GroupID = Util.GetInt(GroupID);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Department = Util.GetString(Department);
            this.SurgeryCode = Util.GetString(SurgeryCode);
            this.Surgery_ID = Util.GetString(Surgery_ID);
            this.IsActive = Util.GetInt(IsActive);
            this.CPTCode = Util.GetString(CPTCode);
            this.SurgeryGrade = Util.GetString(SurgeryGrade);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@Creator_ID", 0),
               new MySqlParameter("@Department", Department),
                new MySqlParameter("@SurgeryCode", SurgeryCode),
            new MySqlParameter("@IsActive", IsActive),
            new MySqlParameter("@CPTCode", CPTCode),
            new MySqlParameter("@SurgeryGrade",SurgeryGrade),
                new MySqlParameter("@Surgery_ID", Surgery_ID));

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
        this.Surgery_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_surgery_master WHERE Surgery_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Surgery_ID", Surgery_ID));
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
            string sSQL = "SELECT * FROM f_surgery_master WHERE Surgery_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@Surgery_ID", Surgery_ID)).Tables[0];

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
            string sParams = "Surgery_ID=" + this.Surgery_ID.ToString();
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
        this.Surgery_ID = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_Master.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_Master.HospCode]);
        this.Surgery_ID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Master.Surgery_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Master.Name]);
        this.Department = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Master.Department]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Master.Ownership]);
        this.GroupID = Util.GetInt(dtTemp.Rows[0][AllTables.Surgery_Master.GroupID]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Master.Creator_ID]);
        this.SurgeryCode = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Master.SurgeryCode]);
        this.IsActive = Util.GetInt(dtTemp.Rows[0][AllTables.Surgery_Master.IsActive]);
    }

    #endregion Helper Private Function
}