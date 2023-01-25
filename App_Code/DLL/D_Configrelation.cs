using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for D_Configrelation
/// </summary>
public class D_Configrelation
{
    #region All Memory Variables

    private int _ConfigID;
    private string _Name;
    private string _CategoryID;
    private string _ConfigIDMain;
    private string _TypeDummy;
    
    #endregion
     #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn=false;
       #endregion
       #region Overloaded Constructor
  
    public D_Configrelation()
	{
			objCon = Util.GetMySqlCon();
			this.IsLocalConn = true;
	}
    public D_Configrelation(MySqlTransaction objTrans)
		{
			this.objTrans = objTrans;
			this.IsLocalConn = false;
		}
	#endregion
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

    public virtual string ConfigIDMain
    {
        get
        {
            return _ConfigIDMain;
        }
        set
        {
            _ConfigIDMain = value;
        }
    }

    public virtual string TypeDummy
    {
        get
        {
            return _TypeDummy;
        }
        set
        {
            _TypeDummy = value;
        }
    }
    public int Insert()
    {
        try
        {

            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_d_ConfigRelation");
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
            cmd.Parameters.Add(new MySqlParameter("@ConfigIDMain", ConfigIDMain));
            cmd.Parameters.Add(new MySqlParameter("@TypeDummy", TypeDummy));

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

