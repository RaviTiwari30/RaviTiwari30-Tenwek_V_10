using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class Room_Master
{
    #region All Memory Variables

    private int _ID;
    private string _UpdaterID;
    private string _Location;
    private string _HospCode;
    private string _Room_ID;
    private string _Floor;
    private string _IPDCaseType_ID;
    private string _Creator_ID;
    private string _Description;
    private System.DateTime _Creator_Date;
    private string _Name;
    private string _Room_No;
    private string _Bed_No;
    private int _IsActive;
    private int _IsCountable;
    private string _IPAddress;
    private int _CentreID;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Room_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Room_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public Room_Master(Room_Master obj)
    {
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual System.DateTime Creator_Date
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
    public virtual string UpdaterID
    {
        get
        {
            return _UpdaterID;
        }
        set
        {
            _UpdaterID = value;
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

    public virtual string Room_ID
    {
        get
        {
            return _Room_ID;
        }
        set
        {
            _Room_ID = value;
        }
    }

    public virtual string Floor
    {
        get
        {
            return _Floor;
        }
        set
        {
            _Floor = value;
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

    public virtual string Room_No
    {
        get
        {
            return _Room_No;
        }
        set
        {
            _Room_No = value;
        }
    }

    public virtual string Bed_No
    {
        get
        {
            return _Bed_No;
        }
        set
        {
            _Bed_No = value;
        }
    }

    public virtual string IPDCaseType_ID
    {
        get
        {
            return _IPDCaseType_ID;
        }
        set
        {
            _IPDCaseType_ID = value;
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

    public virtual int IsCountable
    {
        get
        {
            return _IsCountable;
        }
        set
        {
            _IsCountable = value;
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
    public virtual int CentreID
    {
        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public void Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_room");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Floor = Util.GetString(Floor);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Room_No = Util.GetString(Room_No);
            this.Bed_No = Util.GetString(Bed_No);
            this.IsActive = Util.GetInt(IsActive);
            this.IsCountable = Util.GetInt(IsCountable);
            this.IPAddress = Util.GetString(IPAddress);
            this.CentreID = Util.GetInt(CentreID);
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Room_No", Room_No));
            cmd.Parameters.Add(new MySqlParameter("@Bed_No", Bed_No));
            cmd.Parameters.Add(new MySqlParameter("@FLOOR", Floor));
            cmd.Parameters.Add(new MySqlParameter("@IPDCaseTypeID", IPDCaseType_ID));
            cmd.Parameters.Add(new MySqlParameter("@Descr", Description));
            cmd.Parameters.Add(new MySqlParameter("@CreatorID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@Creator_Date", Creator_Date));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@IsCountable", IsCountable));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);
        }
    }
    public void InsertRoomLog()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Room_Log");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Floor = Util.GetString(Floor);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Room_No = Util.GetString(Room_No);
            this.Bed_No = Util.GetString(Bed_No);
            this.IsActive = Util.GetInt(IsActive);
            this.IsCountable = Util.GetInt(IsCountable);
            this.IPAddress = Util.GetString(IPAddress);
            this.CentreID = Util.GetInt(CentreID);
            this.Room_ID = Util.GetString(Room_ID);
            this.UpdaterID = Util.GetString(UpdaterID);
            cmd.Parameters.Add(new MySqlParameter("@Room_ID", Room_ID));
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Room_No", Room_No));
            cmd.Parameters.Add(new MySqlParameter("@Bed_No", Bed_No));
            cmd.Parameters.Add(new MySqlParameter("@FLOOR", Floor));
            cmd.Parameters.Add(new MySqlParameter("@IPDCaseTypeID", IPDCaseType_ID));
            cmd.Parameters.Add(new MySqlParameter("@Descr", Description));
            cmd.Parameters.Add(new MySqlParameter("@CreatorID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@Creator_Date", Creator_Date));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@IsCountable", IsCountable));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@UpdaterID", UpdaterID));
            cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);
        }
    }
    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE room_master SET  Location= ?, HospCode = ?,");
            objSQL.Append("Name = ?,Room_No=?,Bed_No=?,Floor = ?,IPDCaseTypeID = ?,Description= ?,Creator_ID = ?,Creator_Date=?,IsActive=? WHERE Room_ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Floor = Util.GetString(Floor);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Room_No = Util.GetString(Room_No);
            this.Bed_No = Util.GetString(Bed_No);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.IsActive = Util.GetInt(IsActive);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Location", Location),
                new MySqlParameter("@HospCode", HospCode),
                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Room_No", Room_No),
                new MySqlParameter("@Bed_No", Bed_No),
                new MySqlParameter("@Floor", Floor),
                new MySqlParameter("@IPDCaseType_ID", IPDCaseType_ID),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@Creator_Date", Creator_Date),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@Room_ID", Room_ID));

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
            throw (ex);
        }
    }

    public int Delete(string iPkValue)
    {
        this.Room_ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM room_master WHERE Room_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Room_ID", Room_ID));
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
            throw (ex);
        }
    }

    public bool Load()
    {
        DataTable dtTemp;

        try
        {
            string sSQL = "SELECT * FROM room_master WHERE Room_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@Room_ID ", Room_ID)).Tables[0];

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
            string sParams = "Room_ID =" + this.Room_ID.ToString();
            throw (ex);
        }
    }

    public bool Load(string iPkValue)
    {
        this.Room_ID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.ID = Util.GetInt(dtTemp.Rows[0][AllTables.Room_Master.ID]);
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.HospCode]);
        this.Room_ID = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Room_ID]);
        this.Floor = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Floor]);
        this.Creator_ID = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Creator_ID]);
        this.Creator_Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.Room_Master.Creator_Date]);
        this.Name = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Name]);
        this.Description = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Description]);
        this.Room_No = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Room_No]);
        this.Bed_No = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.Bed_No]);
        this.IPDCaseType_ID = Util.GetString(dtTemp.Rows[0][AllTables.Room_Master.IPDCaseType_ID]);
    }

    #endregion Helper Private Function
}