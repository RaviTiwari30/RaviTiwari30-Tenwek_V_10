#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces




public class Investigation_ObservationType
{
	#region All Memory Variables

    private int         _Investigation_ObservationType_ID;
    private string      _Investigation_ID;
    private string      _ObservationType_ID;
    private string      _Ownership;
    private string      _Creator_ID;
    private string      _GroupID;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Investigation_ObservationType()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
           }
    public Investigation_ObservationType(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;       
    }
    #endregion

    #region Set All Property
    public virtual int Investigation_ObservationType_ID
    {
        get
        {
            return _Investigation_ObservationType_ID;
        }
        set
        {
            _Investigation_ObservationType_ID = value;
        }
    }
    public virtual string Investigation_ID
    {
        get
        {
            return _Investigation_ID;
        }
        set
        {
            _Investigation_ID = value;
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

    #endregion

    #region All Public Member Function
    public int Insert()
    {
        try
        {

            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO Investigation_ObservationType (Investigation_ObservationType_ID,  Investigation_ID, ObservationType_ID, ");
            objSQL.Append("Ownership, GroupID, Creator_ID)");
            objSQL.Append("VALUES (@Investigation_ObservationType_ID,@Investigation_ID,@ObservationType_ID,@Ownership,@GroupID,@Creator_ID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Investigation_ObservationType_ID = Util.GetInt(Investigation_ObservationType_ID);
            this.Investigation_ID = Util.GetString(Investigation_ID);
            this.ObservationType_ID = Util.GetString(ObservationType_ID);
            this.Ownership = Util.GetString(Ownership);
            this.GroupID = Util.GetString(GroupID);
            this.Creator_ID = Util.GetString(Creator_ID);            

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Investigation_ObservationType_ID", Investigation_ObservationType_ID),
                new MySqlParameter("@Investigation_ID", Investigation_ID),
                new MySqlParameter("@ObservationType_ID", ObservationType_ID),
                new MySqlParameter("@Ownership", Ownership),                
                new MySqlParameter("@GroupID", GroupID),
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

            string sSQL = "SELECT * FROM Investigation_ObservationType WHERE Investigation_ObservationType_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@Investigation_ObservationType_ID", Investigation_ObservationType_ID)).Tables[0];

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
            string sParams = "Investigation_ObservationType_ID=" + this.Investigation_ObservationType_ID.ToString();
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
        this.Investigation_ObservationType_ID = iPkValue;
        return this.Load();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE Investigation_ObservationType SET Investigation_ID = ?, ObservationType_ID = ?,");
            objSQL.Append("Ownership= ?, GroupID = ?, Creator_ID=?  WHERE Investigation_ObservationType_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Investigation_ID", Investigation_ID),
                new MySqlParameter("@ObservationType_ID", ObservationType_ID),
                new MySqlParameter("@Ownership", Ownership),                
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@Investigation_ObservationType_ID", Investigation_ObservationType_ID));

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
        this.Investigation_ObservationType_ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM Investigation_ObservationType WHERE Investigation_ObservationType_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("Investigation_ObservationType_ID", Investigation_ObservationType_ID));
            
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
        this.Investigation_ObservationType_ID = Util.GetInt(dtTemp.Rows[0][AllTables.Investigation_ObservationType.Investigation_ObservationType_ID]);
        this.Investigation_ID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_ObservationType.Investigation_ID]);
        this.ObservationType_ID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_ObservationType.ObservationType_ID]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_ObservationType.Ownership]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_ObservationType.Creator_ID]);
        this.GroupID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_ObservationType.GroupID]);

    }
    #endregion
	
}
