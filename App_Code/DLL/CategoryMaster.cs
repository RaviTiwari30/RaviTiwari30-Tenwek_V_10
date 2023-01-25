using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class CategoryMaster
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _CategoryID;
    private string _Hospital_ID;
    private string _Name;
    private string _Description;
    private string _TableReference;
    private string _IsEffectiveEventory;
    private int _Active;
    private string _Abbreviation;
    private string _UserID;
    private string _IPAddress;
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public CategoryMaster()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;

	}
    public CategoryMaster(MySqlTransaction objTrans)
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

    public virtual string TableReference
    {
        get
        {
            return _TableReference;
        }
        set
        {
            _TableReference = value;
        }
    }
    public virtual string IsEffectiveEventory
    {
        get
        {
            return _IsEffectiveEventory;
        }
        set
        {
            _IsEffectiveEventory = value;
        }
    }
    public virtual int Active
    {
        get
        {
            return _Active;
        }
        set
        {
            _Active = value;
        }
    }
    public virtual string Abbreviation
    {
        get
        {
            return _Abbreviation;
        }
        set
        {
            _Abbreviation = value;
        }
    }
    public virtual string UserID
    {
        get
        {
            return _UserID;
        }
        set
        {
            _UserID = value;
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
    public string Insert()
    {
        try
        {
            string iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_CategoryMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new
                MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@CategoryID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.TableReference = Util.GetString(TableReference);
            this.IsEffectiveEventory = Util.GetString(IsEffectiveEventory);
            this.Active = Util.GetInt(Active);
            this.Abbreviation = Util.GetString(Abbreviation);
            this.UserID = Util.GetString(UserID);
            this.IPAddress = Util.GetString(IPAddress);



            
            //cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            //cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@TableReference", TableReference));
            cmd.Parameters.Add(new MySqlParameter("@IsEffectiveEventory", IsEffectiveEventory));
            cmd.Parameters.Add(new MySqlParameter("@Active", Active));
            cmd.Parameters.Add(new MySqlParameter("@Abbreviation", Abbreviation));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));

            cmd.Parameters.Add(paramTnxID);

            iPkValue = Util.GetString(cmd.ExecuteScalar());

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
    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_categorymaster SET Hospital_ID=?,Name = ?, Description = ?, TableReference = ?,IsEffectiveEventory=? WHERE CategoryID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.CategoryID = Util.GetString(CategoryID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.TableReference = Util.GetString(TableReference);
            this.IsEffectiveEventory = Util.GetString(IsEffectiveEventory);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@TableReference", TableReference),
                new MySqlParameter("@IsEffectiveEventory", IsEffectiveEventory),
                new MySqlParameter("@CategoryID", CategoryID));


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
        this.CategoryID = iPkValue.ToString();
        return this.Delete();
    }
    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_categorymaster WHERE CategoryID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("CategoryID", CategoryID));
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

            string sSQL = "SELECT * FROM f_categorymaster WHERE CategoryID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@CategoryID", CategoryID)).Tables[0];

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
            string sParams = "CategoryID=" + this.CategoryID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }
    public bool Load(int iPkValue)
    {
        this.CategoryID = iPkValue.ToString();
        return this.Load();
    }
    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.HospCode]);
        this.CategoryID = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.CategoryID]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.Hospital_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.Description]);
        this.TableReference = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.TableReference]);
        this.IsEffectiveEventory = Util.GetString(dtTemp.Rows[0][AllTables.CategoryMaster.IsEffectiveEventory]);
    }
    #endregion



}
