#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class ObservationType_Master
{
	#region All Memory Variables
    private string      _Location;
    private string      _HospCode;
    private int      _ID;
    private string      _ObservationType_ID;
    private string      _Name;
    private string      _Description;
    private string      _Ownership;
    private string      _Creator_ID;
    private string _GroupID;
    private int _Flag;
    private int _IsActive;
    private string _DeptEmailID;
    private int _Print_Sequence;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public ObservationType_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }
    public ObservationType_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

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
    public virtual string ObservationType_ID
    {
        get
        {
            return _ObservationType_ID;
        }
        set
        {
            _ObservationType_ID = value;
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
    public virtual string GroupID
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
    public virtual int Flag
    {
        get
        {
            return _Flag;
        }
        set
        {
            _Flag = value;
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
    public virtual string DeptEmailID
    {
        get
        {
            return _DeptEmailID;
        }
        set
        {
            _DeptEmailID = value;
        }
    }
    public virtual int Print_Sequence
    {
        get
        {
            return _Print_Sequence;
        }
        set
        {
            _Print_Sequence = value;
        }
    }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {

            //int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            //objSQL.Append("INSERT INTO ObservationType_Master (ObservationType_ID,  Name, Description,");
            //objSQL.Append("Ownership, Creator_ID, GroupID)");
            objSQL.Append("insert_observationtype");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ObservationType_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.ObservationType_ID = Util.GetString(ObservationType_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.GroupID = Util.GetString(GroupID);
            this.Flag = Util.GetInt(Flag);
            
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@TYPE", ""));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@Flag", Flag));
            cmd.Parameters.Add(new MySqlParameter("@DeptEmailID", DeptEmailID));
            cmd.Parameters.Add(paramTnxID);
            //cmd.ExecuteNonQuery();

            string ObservationTypeID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ObservationTypeID;
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

            string sSQL = "SELECT * FROM observationtype_master WHERE ObservationType_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@ObservationType_ID", ObservationType_ID)).Tables[0];

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
            string sParams = "ObservationType_ID=" + this.ObservationType_ID.ToString();
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
        this.ObservationType_ID = iPkValue.ToString();
        return this.Load();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE observationtype_master SET Name = @Name, Description = @Description,");
            objSQL.Append("Ownership=@Ownership , Creator_ID=@Creator_ID, GroupID = @GroupID,Flag=@Flag,IsActive=@IsActive,Print_Sequence=@Print_Sequence WHERE ObservationType_ID = @ObservationType_ID");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;


            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.ObservationType_ID = Util.GetString(ObservationType_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.GroupID = Util.GetString(GroupID);
            this.Flag = Util.GetInt(Flag);
            this.IsActive = Util.GetInt(IsActive);
            this.Print_Sequence= Util.GetInt(Print_Sequence);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@Flag", Flag),
                 new MySqlParameter("@IsActive", IsActive),
                 new MySqlParameter("@Print_Sequence",Print_Sequence),
                new MySqlParameter("@ObservationType_ID", ObservationType_ID));

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
        this.ObservationType_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM observationtype_master WHERE ObservationType_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("ObservationType_ID", ObservationType_ID));
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

        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_Master.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_Master.HospCode]);
        this.ObservationType_ID = Util.GetString(dtTemp.Rows[0][AllTables.ObservationType_Master.ObservationType_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.ObservationType_Master.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.ObservationType_Master.Description]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.ObservationType_Master.Ownership]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.ObservationType_Master.Creator_ID]);
        this.GroupID = Util.GetString(dtTemp.Rows[0][AllTables.ObservationType_Master.GroupID]);
        this.Flag = Util.GetInt(dtTemp.Rows[0][AllTables.ObservationType_Master.Flag]);

    }
    #endregion
}
