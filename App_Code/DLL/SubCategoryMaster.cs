using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class SubCategoryMaster
{
    #region All Memory Variables

    //private string _Location;
    //private string _HospCode;
    private int _ID;
    private string _SubCategoryID;
    private string _CategoryID;
    private string _Hospital_ID;
    private string _Name;
    private string _Description;
    private string _DisplayName;
    private int _DisplayPriority;
    private int _Active;
    private string _Abbreviation;
    private string _IPAddress;
    private string _CreatedBy;
    private int _DocValidityPeriod;
    private int _IsAsset;
    private string assetdepartid;

    [System.ComponentModel.DefaultValue("1.00")]
    private decimal _scaleOfCost;






    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public SubCategoryMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.Location = AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
    }

    public SubCategoryMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    //public virtual string Location
    //{
    //    get
    //    {
    //        return _Location;
    //    }
    //    set
    //    {
    //        _Location = value;
    //    }
    //}

    //public virtual string HospCode
    //{
    //    get
    //    {
    //        return _HospCode;
    //    }
    //    set
    //    {
    //        _HospCode = value;
    //    }
    //}

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

    public virtual string SubCategoryID
    {
        get
        {
            return _SubCategoryID;
        }
        set
        {
            _SubCategoryID = value;
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

    public string DisplayName
    {
        get { return _DisplayName; }
        set { _DisplayName = value; }
    }

    public int DisplayPriority
    {
        get { return _DisplayPriority; }
        set { _DisplayPriority = value; }
    }

    public string IPAddress
    {
        get { return _IPAddress; }
        set { _IPAddress = value; }
    }

    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }
    public int DocValidityPeriod
    {
        get { return _DocValidityPeriod; }
        set { _DocValidityPeriod = value; }
    }
    public int IsAsset
    {
        get { return _IsAsset; }
        set { _IsAsset = value; }
    }
    public string Asset_DepartId
    {
        get { return assetdepartid; }
        set { assetdepartid = value; }
    }


    public decimal scaleOfCost
    {
        get { return _scaleOfCost; }
        set { _scaleOfCost = value; }
    }



    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_SubCategoryMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@SubCategoryID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //this.Location = AllGlobalFunction.Location;
            //this.HospCode = AllGlobalFunction.HospCode;
            //this.Location = Util.GetString(Location);
            //this.HospCode = Util.GetString(HospCode);
            this.CategoryID = Util.GetString(CategoryID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.DisplayName = Util.GetString(DisplayName);
            this.DisplayPriority = Util.GetInt(DisplayPriority);
            this.Active = Util.GetInt(Active);
            this.Abbreviation = Util.GetString(Abbreviation);
            this.IPAddress = Util.GetString(IPAddress);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.DocValidityPeriod = Util.GetInt(DocValidityPeriod);
            this.IsAsset = IsAsset;
            this.scaleOfCost = Util.GetDecimal(scaleOfCost);

            // this.Asset_DepartId = assetdepartid;

            //cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            //cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@CategoryID", CategoryID));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@DisplayName", DisplayName));
            cmd.Parameters.Add(new MySqlParameter("@DisplayPriority", DisplayPriority));
            cmd.Parameters.Add(new MySqlParameter("@Active", Active));
            cmd.Parameters.Add(new MySqlParameter("@Abbreviation", Abbreviation));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@DocValidityPeriod", DocValidityPeriod));
            cmd.Parameters.Add(new MySqlParameter("@IsAsset", IsAsset));
            cmd.Parameters.Add(new MySqlParameter("@scaleOfCost", scaleOfCost));


            // cmd.Parameters.Add(new MySqlParameter("@Asset_DepartId", Asset_DepartId));

            cmd.Parameters.Add(paramTnxID);
            string SubCategoryID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return SubCategoryID;
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
            objSQL.Append("UPDATE f_Subcategorymaster SET CategoryID=@CategoryID,Hospital_ID=@Hospital_ID,Name = @Name, Description = @Description,DisplayName = @DisplayName,DisplayPriority = @DisplayPriority WHERE SubCategoryID = @SubCategoryID ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.CategoryID = Util.GetString(CategoryID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.DisplayName = Util.GetString(DisplayName);
            this.DisplayPriority = Util.GetInt(DisplayPriority);

            this.SubCategoryID = Util.GetString(SubCategoryID);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@CategoryID", CategoryID),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@DisplayName", DisplayName),
                new MySqlParameter("@DisplayPriority", DisplayPriority),
                new MySqlParameter("@SubCategoryID", SubCategoryID));

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
            objSQL.Append("DELETE FROM f_Subcategorymaster WHERE SubCategoryID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("SubCategoryID", SubCategoryID));
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
            string sSQL = "SELECT * FROM f_Subcategorymaster WHERE SubCategoryID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@SubCategoryID", SubCategoryID)).Tables[0];

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
            string sParams = "SubCategoryID=" + this.SubCategoryID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.SubCategoryID = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        //this.Location = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.Location]);
        //this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.HospCode]);
        this.SubCategoryID = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.SubCategoryID]);
        this.CategoryID = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.CategoryID]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.Hospital_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.Description]);
        this.DisplayName = Util.GetString(dtTemp.Rows[0][AllTables.SubCategoryMaster.DisplayName]);
        this.DisplayPriority = Util.GetInt(dtTemp.Rows[0][AllTables.SubCategoryMaster.DisplayPriority]);
    }

    #endregion Helper Private Function

    public int GetIsAssetBySubCategoryId(string CatID)
    {
        int isAssett = 0;
        try
        {
            this.objCon.Open();
            this.objTrans = this.objCon.BeginTransaction();

            string query = "SELECT IsAsset FROM f_subcategorymaster WHERE SubCategoryID=@SubCategoryID";
            using (MySqlCommand cmd = new MySqlCommand(query, objTrans.Connection, objTrans))
            {
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.AddWithValue("@SubCategoryID", CatID);
                isAssett = Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return isAssett;
    }
}