using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for VehicleRequest
/// </summary>
public class VehicleRequest
{
    #region All Memory Variables
    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _VehicleRequestID;    
    private string _DeptFrom;
    private string _DeptTo;
    private string _VehicleType;
    private DateTime _TravelDate;
    private DateTime _TravelTime;
    private string _Purpose;
    private string _EntryBy;
    private int _CentreID;
    private int _HospCentreID;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public VehicleRequest()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public VehicleRequest(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion



    #region Set All Property
    public virtual string Location
    {

        get{ return _Location;}
        set{_Location = value;}
    }
    public virtual string HospCode
    {

        get{return _HospCode;}
        set{_HospCode = value;}
    }
    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public string VehicleRequestID
    {
        get { return _VehicleRequestID; }
        set { _VehicleRequestID = value; }
    }
    public string DeptFrom
    {
        get { return _DeptFrom; }
        set { _DeptFrom = value; }
    }

    public string DeptTo
    {
        get { return _DeptTo; }
        set { _DeptTo = value; }
    }

    public string VehicleType
    {
        get { return _VehicleType; }
        set { _VehicleType = value; }
    }

    public DateTime TravelDate
    {
        get { return _TravelDate; }
        set { _TravelDate = value; }
    }
    public DateTime TravelTime
    {
        get { return _TravelTime; }
        set { _TravelTime = value; }
    }
    public string Purpose
    {
        get { return _Purpose; }
        set { _Purpose = value; }
    }
    public int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }
    public int HospCentreID
    {
        get { return _HospCentreID; }
        set { _HospCentreID = value; }
    }
    public string EntryBy
    {
        get { return _EntryBy; }
        set { _EntryBy = value; }
    }
    #endregion

    #region All Public Member Function
    public string Insert()
    {        
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_department_vehicle");
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
            this.DeptFrom = Util.GetString(this.DeptFrom);
            this.DeptTo = Util.GetString(this.DeptTo);
            this.VehicleType = Util.GetString(this.VehicleType);
            this.TravelDate = Util.GetDateTime(this.TravelDate);
            this.TravelTime = Util.GetDateTime(this.TravelTime);
            this.Purpose = Util.GetString(this.Purpose);
            this.EntryBy = Util.GetString(this.EntryBy);
            this.CentreID = Util.GetInt(this.CentreID);
            this.HospCentreID = Util.GetInt(this.HospCentreID);

            cmd.Parameters.Add(new MySqlParameter("@vLoc", Location));
            cmd.Parameters.Add(new MySqlParameter("@vHosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@vDeptFrom", DeptFrom));
            cmd.Parameters.Add(new MySqlParameter("@vDeptTo", DeptTo));
            cmd.Parameters.Add(new MySqlParameter("@vVehicleType", VehicleType));
            cmd.Parameters.Add(new MySqlParameter("@vTravelDate", TravelDate));
            cmd.Parameters.Add(new MySqlParameter("@vTravelTime", TravelTime));
            cmd.Parameters.Add(new MySqlParameter("@vPurpose", Purpose));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));

            VehicleRequestID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return VehicleRequestID;
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
    #endregion
}