#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class Investigation_Master
{
	#region All Memory Variables
    private string      _Location;
    private string      _HospCode;
    private int         _ID;
    private string      _Investigation_ID;
    private string      _Name;
    private string      _Description;
    private string      _Type;
    private string      _Ownership;
    private string      _Creator_ID;
    private string      _Group_ID;
    private string      _FileLimitationName;
    private int         _ReportType;
    private int         _Print_Sequence;
    private string      _Principle;
    private string      _Interpretation;
    private int _IsNabl;
    private string _GenderInvestigate;
    private string _sampletypename;
    private int _IsOutSource;
    private string _IpAddress;

    private int _IsUrgent;
    private int _ShowPtRpt;
    private int _ShowOnlineRpt;
    private int _PrintSeparate;
    private int _PrintSampleName;
    private string _SampleTypeID;
    private string _IsCulture;
    private string _SampleContainer;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Investigation_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }
    public Investigation_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
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

    public virtual string Type
    {
        get
        {
            return _Type;
        }
        set
        {
            _Type = value;
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
    public virtual string Group_ID
    {
        get
        {
            return _Group_ID;
        }
        set
        {
            _Group_ID = value;
        }
    }
    public virtual string FileLimitationName
    {
        get
        {
            return _FileLimitationName;
        }
        set
        {
            _FileLimitationName = value;
        }
    }  
    public virtual int ReportType
    {
        get
        {
            return _ReportType;
        }
        set
        {
            _ReportType = value;
        }
    }
    public virtual string  Principle
    {
        get
        {
            return _Principle;
        }
        set
        {
            _Principle = value;
        }
    }
    public virtual string Interpretation
    {
        get
        {
            return _Interpretation;
        }
        set
        {
            _Interpretation = value;
        }
    }
    public virtual int IsNabl
    {
        get
        {
            return _IsNabl;
        }
        set
        {
            _IsNabl = value;
        }
    }
    public virtual string GenderInvestigate
    {
        get
        {
            return _GenderInvestigate;
        }
        set
        {
            _GenderInvestigate = value;
        }
    }
    public virtual string sampletypename
    {
        get
        {
            return _sampletypename;
        }
        set
        {
            _sampletypename = value;
        }
    }
    public virtual int IsOutSource
    {
        get
        {
            return _IsOutSource;
        }
        set
        {
            _IsOutSource = value;
        }
    }
    public virtual string IpAddress
    {
        get
        {
            return _IpAddress;
        }
        set
        {
            _IpAddress = value;
        }
    }

    public virtual int IsUrgent
    {
        get
        {
            return _IsUrgent;
        }
        set
        {
            _IsUrgent = value;
        }
    }
    public virtual int ShowPtRpt
    {
        get
        {
            return _ShowPtRpt;
        }
        set
        {
            _ShowPtRpt = value;
        }
    }
    public virtual int ShowOnlineRpt
    {
        get
        {
            return _ShowOnlineRpt;
        }
        set
        {
            _ShowOnlineRpt = value;
        }
    }
    public virtual int PrintSeperate
    {
        get
        {
            return _PrintSeparate;
        }
        set
        {
            _PrintSeparate = value;
        }
    }
    public virtual int PrintSampleName
    {
        get
        {
            return _PrintSampleName;
        }
        set
        {
            _PrintSampleName = value;
        }
    }
    public virtual string SampleTypeID { get { return _SampleTypeID; } set { _SampleTypeID = value; } }
    public virtual string IsCulture { get { return _IsCulture; } set { _IsCulture = value; } }
    public virtual string SampleContainer { get { return _SampleContainer; } set { _SampleContainer = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Investigation");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }                       
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@InvestID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;



            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;


            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Investigation_ID = Util.GetString(Investigation_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Type = Util.GetString(Type);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Group_ID = Util.GetString(Group_ID);
            this.FileLimitationName = Util.GetString(FileLimitationName);
            this.ReportType = Util.GetInt(ReportType);
            this.Print_Sequence = Util.GetInt(Print_Sequence);
            this.Principle = Util.GetString (Principle);
            this.Interpretation = Util.GetString(Interpretation);
            this.IsNabl = Util.GetInt(IsNabl);
            this.GenderInvestigate = Util.GetString(GenderInvestigate);
            this.sampletypename = Util.GetString(sampletypename);
            this.IsOutSource = Util.GetInt(IsOutSource);
            this.IpAddress = Util.GetString(IpAddress);

            this.IsUrgent = Util.GetInt(IsUrgent);
            this.ShowPtRpt = Util.GetInt(ShowPtRpt);
            this.ShowOnlineRpt = Util.GetInt(ShowOnlineRpt);
            this.PrintSeperate = Util.GetInt(PrintSeperate);
            this.PrintSampleName = Util.GetInt(PrintSampleName);
            this.SampleTypeID = Util.GetString(SampleTypeID);
            this.IsCulture = Util.GetString(IsCulture);
            this.SampleContainer = Util.GetString(SampleContainer);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@TYPE", Type));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@Group_ID", Group_ID));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@FileName", FileLimitationName));
            cmd.Parameters.Add(new MySqlParameter("@ReportType", ReportType));
            cmd.Parameters.Add(new MySqlParameter("@Print_Sequence", Print_Sequence));
            cmd.Parameters.Add(new MySqlParameter("@Principle", Principle));
            cmd.Parameters.Add(new MySqlParameter("@Interpretation", Interpretation));
            cmd.Parameters.Add(new MySqlParameter("@IsNabl", IsNabl));
            cmd.Parameters.Add(new MySqlParameter("@GenderInvestigate", GenderInvestigate));
            cmd.Parameters.Add(new MySqlParameter("@sampletypename", sampletypename));
            cmd.Parameters.Add(new MySqlParameter("@IsOutSource", IsOutSource));
            cmd.Parameters.Add(new MySqlParameter("@IpAddress", IpAddress));

            cmd.Parameters.Add(new MySqlParameter("@IsUrgent", IsUrgent));
            cmd.Parameters.Add(new MySqlParameter("@ShowPtRpt", ShowPtRpt));
            cmd.Parameters.Add(new MySqlParameter("@ShowOnlineRpt", ShowOnlineRpt));
            cmd.Parameters.Add(new MySqlParameter("@PrintSeperate", PrintSeperate));
            cmd.Parameters.Add(new MySqlParameter("@PrintSampleName", PrintSampleName));
            cmd.Parameters.Add(new MySqlParameter("@SampleTypeID", SampleTypeID));
            cmd.Parameters.Add(new MySqlParameter("@IsCulture", IsCulture));
            cmd.Parameters.Add(new MySqlParameter("@SampleContainer", SampleContainer));
            cmd.Parameters.Add(paramTnxID);
            Investigation_ID = cmd.ExecuteScalar().ToString();            

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Investigation_ID;
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

            string sSQL = "SELECT * FROM Investigation_Master WHERE Investigation_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@Investigation_ID", Investigation_ID)).Tables[0];

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
            string sParams = "Investigation_ID=" + this.Investigation_ID.ToString();
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
        this.Investigation_ID = iPkValue.ToString();
        return this.Load();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE Investigation_Master SET Name = ?, Description = ?,Type =?,");
            objSQL.Append("Ownership= ?, Creator_ID=?, Group_ID = ?, FileLimitationName = ?, ReportType = ?,Print_Sequence=?,Principle=?,Interpretation=?,sampletypename=? WHERE Investigation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Type", Type),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@Group_ID", Group_ID),
                new MySqlParameter("@FileLimitationName", FileLimitationName),
                new MySqlParameter("@ReportType", ReportType),
                new MySqlParameter("@Investigation_ID", Investigation_ID));
                new MySqlParameter("@Print_Sequence", Print_Sequence);
                new MySqlParameter("@Principle",Principle);
                new MySqlParameter("@Interpretation", Interpretation);
                new MySqlParameter("@sampletypename", sampletypename);
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
        this.Investigation_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM Investigation_Master WHERE Investigation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Investigation_ID", Investigation_ID));
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
        this.Investigation_ID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Investigation_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Description]);
        this.Type = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Type]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Ownership]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Creator_ID]);
        this.Group_ID = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.Group_ID]);
        this.FileLimitationName = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.FileLimitationName]);
        this.ReportType = Util.GetInt(dtTemp.Rows[0][AllTables.Investigation_Master.ReportType]);
        this.sampletypename = Util.GetString(dtTemp.Rows[0][AllTables.Investigation_Master.sampletypename]);
    }
    #endregion
}
