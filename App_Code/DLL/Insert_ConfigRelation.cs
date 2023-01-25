using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Insert_ConfigRelation
/// </summary>
public class Insert_ConfigRelation
{
    #region All Memory Variables

    private int _ConfigID;
    private string _Name;
    private string _CategoryID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn = false;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Insert_ConfigRelation()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Insert_ConfigRelation(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    public virtual int ConfigID
    {
        get
        {
            return _ConfigID;
        }
        set
        {
            _ConfigID = value;
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

    public virtual string CategoryID
    {
        get
        {
            return _CategoryID;
        }
        set
        {
            _CategoryID = value;
        }
    }

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_ConfigRelation");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.ConfigID = Util.GetInt(ConfigID);
            this.Name = Util.GetString(Name);
            this.CategoryID = Util.GetString(CategoryID);

            cmd.Parameters.Add(new MySqlParameter("@ConfigID", ConfigID));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@CategoryID", CategoryID));

            iPkValue = Util.GetInt(cmd.ExecuteNonQuery());

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
}
