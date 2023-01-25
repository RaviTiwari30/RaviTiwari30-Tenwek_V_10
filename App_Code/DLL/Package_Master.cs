using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class Package_Master
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _PackageID;
    private string _Name;
    private string _Description;
    private string _CreaterID;
    private DateTime _Creator_Date;
    private int _IsActive;
    private DateTime _FromDate;
    private DateTime _ToDate;
    private string _LastUpdatedBy;
    private DateTime _UpdateDate;
    private string _IPAddress;

    private int _IsVaccinationAllow;
    private int _IsConsumablesAllow;

    

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Package_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public Package_Master(MySqlTransaction objTrans)
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

    public virtual string PackageID
    {
        get
        {
            return _PackageID;
        }
        set
        {
            _PackageID = value;
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

    public virtual string CreaterID
    {
        get
        {
            return _CreaterID;
        }
        set
        {
            _CreaterID = value;
        }
    }

    public virtual DateTime Creator_Date
    {
        get
        {
            return _Creator_Date;
        }
        set
        {
            _Creator_Date = value;
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

    public virtual DateTime ToDate
    {
        get
        {
            return _ToDate;
        }
        set
        {
            _ToDate = value;
        }
    }

    public virtual DateTime FromDate
    {
        get
        {
            return _FromDate;
        }
        set
        {
            _FromDate = value;
        }
    }

    public virtual DateTime UpdateDate
    {
        get
        {
            return _UpdateDate;
        }
        set
        {
            _UpdateDate = value;
        }
    }

    public virtual string LastUpdatedBy
    {
        get
        {
            return _LastUpdatedBy;
        }
        set
        {
            _LastUpdatedBy = value;
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


    public virtual int IsConsumablesAllow
    {
        get { return _IsConsumablesAllow; }
        set { _IsConsumablesAllow = value; }
    }
    public virtual int IsVaccinationAllow
    {
        get { return _IsVaccinationAllow; }
        set { _IsVaccinationAllow = value; }
    }



    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PackageMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.CreaterID = Util.GetString(CreaterID);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.IsActive = Util.GetInt(IsActive);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.IPAddress = Util.GetString(IPAddress);
            this.IsConsumablesAllow = Util.GetInt(IsConsumablesAllow);
            this.IsVaccinationAllow = Util.GetInt(IsVaccinationAllow);


            MySqlParameter paramPakageID = new MySqlParameter();
            paramPakageID.ParameterName = "@PlabID";

            paramPakageID.MySqlDbType = MySqlDbType.VarChar;
            paramPakageID.Size = 50;

            paramPakageID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", CreaterID));
            cmd.Parameters.Add(new MySqlParameter("@Creater_date", Creator_Date));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@FromDate", FromDate));
            cmd.Parameters.Add(new MySqlParameter("@ToDate", ToDate));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@vIsConsumablesAllow", IsConsumablesAllow));
            cmd.Parameters.Add(new MySqlParameter("@vIsVaccinationAllow", IsVaccinationAllow));

            cmd.Parameters.Add(paramPakageID);
            iPkValue = Util.GetString(cmd.ExecuteScalar().ToString());

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
            objSQL.Append("UPDATE package_master SET IsConsumablesAllow=@vIsConsumablesAllow,IsVaccinationAllow=@vIsVaccinationAllow, Name =@Name, LastUpdatedBy=@LastUpdatedBy,IsActive=@IsActive,FromDate=@FromDate,ToDate=@ToDate,UpdateDate=@UpdateDate WHERE PackageID =@PackageID ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Name = Util.GetString(Name);
            this.LastUpdatedBy = Util.GetString(LastUpdatedBy);
            this.UpdateDate = Util.GetDateTime(UpdateDate);
            this.IsActive = Util.GetInt(IsActive);
            this.PackageID = Util.GetString(PackageID);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@UpdateDate", UpdateDate),
                new MySqlParameter("@LastUpdatedBy", LastUpdatedBy),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@FromDate", FromDate),
                new MySqlParameter("@ToDate", ToDate),
                new MySqlParameter("@PackageID", PackageID),
                new MySqlParameter("@vIsConsumablesAllow", IsConsumablesAllow),
                new MySqlParameter("@vIsVaccinationAllow", IsVaccinationAllow));

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

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.PackageLab_Master.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.PackageLab_Master.HospCode]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.PackageLab_Master.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.PackageLab_Master.Description]);
        this.Creator_Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.PackageLab_Master.CreationDate]);
        this.CreaterID = Util.GetString(dtTemp.Rows[0][AllTables.PackageLab_Master.CreatorID]);
        this.IsActive = Util.GetInt(dtTemp.Rows[0][AllTables.PackageLab_Master.IsActive]);
        this.FromDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.PackageLab_Master.FromDate]);
        this.ToDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.PackageLab_Master.Todate]);
    }

    #endregion Helper Private Function
}
