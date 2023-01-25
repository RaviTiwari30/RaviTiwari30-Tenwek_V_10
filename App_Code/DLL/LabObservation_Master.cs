#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class Labobservation_master
{
	#region All Memory Variables

    private string      _Location;
    private string      _HospCode;
    private int         _ID;
    private string      _LabObservation_ID;
    private string      _Name;
    private string      _Description;
    private string      _DefaultDescription;
    private string      _Minimum;
    private string      _Maximum;
    private string      _DefaultValue;
    private string      _ReadingFormat;
    private string      _Ownership;
    private string      _Creator_ID;
    private string      _GroupID;
    private int         _Child_Flag;
    private string      _ParentID;
    private int         _Culture_Flag;
    private string  _MinFemale;
    private string  _MaxFemale;
    private string _MinChild;
    private string _MaxChild;
    private string _Suffix;
    private string _Shortname;
    private int _ShowFlag;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Labobservation_master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }
    public Labobservation_master(MySqlTransaction objTrans)
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
    public virtual string LabObservation_ID
    {
        get
        {
            return _LabObservation_ID;
        }
        set
        {
            _LabObservation_ID = value;
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
    public virtual string DefaultDescription
    {
        get
        {
            return _DefaultDescription;
        }
        set
        {
            _DefaultDescription = value;
        }
    }
    public virtual string Minimum
    {
        get
        {
            return _Minimum;
        }
        set
        {
            _Minimum = value;
        }
    }
    public virtual string Maximum
    {
        get
        {
            return _Maximum;
        }
        set
        {
            _Maximum = value;
        }
    }
    public virtual string DefaultValue
    {
        get
        {
            return _DefaultValue;
        }
        set
        {
            _DefaultValue = value;
        }
    }
    public virtual string ReadingFormat
    {
        get
        {
            return _ReadingFormat;
        }
        set
        {
            _ReadingFormat = value;
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
    public virtual int Child_Flag
    {
        get
        {
            return _Child_Flag;
        }
        set
        {
            _Child_Flag = value;
        }
    }
    public virtual string ParentID
    {
        get
        {
            return _ParentID;
        }
        set
        {
            _ParentID = value;
        }
    }

    public virtual int Culture_Flag
    {
        get
        {
            return _Culture_Flag;
        }
        set
        {
            _Culture_Flag = value;
        }
    }

    public virtual string MaxFemale
    {
        get
        {
            return _MaxFemale;
        }
        set
        {
            _MaxFemale = value;
        }
    }
    public virtual string MinFemale
    {
        get
        {
            return _MinFemale;
        }
        set
        {
            _MinFemale = value;
        }
    }

    public virtual string MaxChild
    {
        get
        {
            return _MaxChild;
        }
        set
        {
            _MaxChild = value;
        }
    }
    public virtual string MinChild
    {
        get
        {
            return _MinChild;
        }
        set
        {
            _MinChild = value;
        }
    }
    public virtual string Suffix
    {
        get
        {
            return _Suffix;
        }
        set
        {
            _Suffix = value;
        }
    }
    public virtual string Shortname
    {
        get
        {
            return _Shortname;
        }
        set
        {
            _Shortname = value;
        }
    }
    public virtual int ShowFlag
    {
        get
        {
            return _ShowFlag;
        }
        set
        {
            _ShowFlag = value;
        }
    }

       
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {
                        
            StringBuilder objSQL = new StringBuilder();
           // objSQL.Append("INSERT INTO Labobservation_master (Observation_ID,  Name, Description, Minimum, Maximum,");
           // objSQL.Append("ReadingFormat, Ownership, Creator_ID, GroupID)");
            objSQL.Append("Insert_LabObesarvation");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@LabObservationTypeID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            //this.LabObservation_ID = Util.GetString(LabObservation_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.DefaultDescription = Util.GetString(DefaultDescription);
            this.Minimum = Util.GetString(Minimum);
            this.Maximum = Util.GetString(Maximum);
            this.DefaultValue = Util.GetString(DefaultValue);
            this.ReadingFormat = Util.GetString(ReadingFormat);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.GroupID = Util.GetString(GroupID);
            this.Child_Flag = Util.GetInt(Child_Flag);
            this.ParentID = Util.GetString(ParentID);
            this.MaxFemale = Util.GetString(MaxFemale);
            this.MinFemale = Util.GetString(MinFemale);
            this.MaxChild = Util.GetString(MaxChild);
            this.MinChild = Util.GetString(MinChild);
            this.Suffix = Util.GetString(Suffix);
            this.Shortname = Util.GetString(Shortname);
            this.ShowFlag = Util.GetInt(ShowFlag);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
           cmd.Parameters.Add(new MySqlParameter("@Description", Description));
           cmd.Parameters.Add(new MySqlParameter("@DefaultDescription", DefaultDescription));
           cmd.Parameters.Add(new MySqlParameter("@Minimum", Minimum));
           cmd.Parameters.Add(new MySqlParameter("@Maximum", Maximum));
           cmd.Parameters.Add(new MySqlParameter("@DefaultValue", DefaultValue));
           cmd.Parameters.Add(new MySqlParameter("@ReadingFormat", ReadingFormat));
           cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
           cmd.Parameters.Add(new MySqlParameter("@Creator_ID", Creator_ID));
           cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));          
           cmd.Parameters.Add(new MySqlParameter("@Child_Flag", Child_Flag));
           cmd.Parameters.Add(new MySqlParameter("@ParentID", ParentID));
           cmd.Parameters.Add(new MySqlParameter("@Culture_Flag", Culture_Flag));
           cmd.Parameters.Add(new MySqlParameter("@MaxFemale", MaxFemale));
           cmd.Parameters.Add(new MySqlParameter("@MinFemale", MinFemale));
           cmd.Parameters.Add(new MySqlParameter("@MaxChild", MaxChild));
           cmd.Parameters.Add(new MySqlParameter("@MinChild", MinChild));
           cmd.Parameters.Add(new MySqlParameter("@Suffix", Suffix));
           cmd.Parameters.Add(new MySqlParameter("@Shortname", Shortname));
           cmd.Parameters.Add(new MySqlParameter("@ShowFlag", ShowFlag));
            cmd.Parameters.Add(paramTnxID);
            //cmd.ExecuteNonQuery();
            string LabObservation_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return LabObservation_ID;
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

            string sSQL = "SELECT * FROM Labobservation_master WHERE LabObservation_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@LabObservation_ID", LabObservation_ID)).Tables[0];

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
            string sParams = "LabObservation_ID=" + this.LabObservation_ID.ToString();
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
        this.LabObservation_ID = iPkValue.ToString();
        return this.Load();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE Labobservation_master SET Name = ?, Description = ?, DefaultDescription = ?, Minimum = ?, Maximum = ?,DefaultValue = ? ,");
            objSQL.Append("ReadingFormat = ?, Ownership= ?, Creator_ID=?, GroupID = ?, Child_Flag = ?, ParentID = ?,Culture_Flag = ? ,MaxFemale = ?, MinFemale = ? ,MaxChild = ?, MinChild = ? WHERE LabObservation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@DefaultDescription", DefaultDescription),
                new MySqlParameter("@Minimum", Minimum),
                new MySqlParameter("@Maximum", Maximum),
                new MySqlParameter("@DefaultValue", DefaultValue),
                new MySqlParameter("@ReadingFormat", ReadingFormat),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@Child_Flag", Child_Flag),
                new MySqlParameter("@ParentID", ParentID),
                new MySqlParameter("@Culture_Flag", Culture_Flag),
                new MySqlParameter("@LabObservation_ID", LabObservation_ID),
                new MySqlParameter("@MaxFemale", MaxFemale),
                new MySqlParameter("@MinFemale", MinFemale),
                new MySqlParameter("@MaxChild", MaxChild),
                new MySqlParameter("@MinChild", MinChild));

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
        this.LabObservation_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM Labobservation_master WHERE LabObservation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("LabObservation_ID", LabObservation_ID));
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
        this.LabObservation_ID = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.LabObservation_ID]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.Name]);
        this.DefaultDescription = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.DefaultDescription]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.Description]);
        this.Minimum = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.Minimum]);
        this.Maximum = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.Maximum]);
        this.DefaultValue = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.DefaultValue]);
        this.ReadingFormat = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.ReadingFormat]);
        this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.Ownership]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.Creator_ID]);
        this.GroupID = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.GroupID]);
        this.Child_Flag = Util.GetInt(dtTemp.Rows[0][AllTables.LabObservation_Master.Child_Flag]);
        this.ParentID = Util.GetString(dtTemp.Rows[0][AllTables.LabObservation_Master.ParentID]);
        this.Culture_Flag = Util.GetInt(dtTemp.Rows[0][AllTables.LabObservation_Master.Culture_Flag]);
    }
    #endregion
}
