using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


/// <summary>
/// Summary description for Fuel_Entry
/// </summary>
public class Fuel_Entry
{
    #region All Memory Variables
    private string _EntryNo;    
    private int _VehicleID;    
    private int _DriverID;    
    private string _Letter;    
    private decimal _TotalAmount;    
    private string _Remarks;    
    private string _EntryBy;    
    private int _CentreID;    
    private int _HospCentreID;
    private DateTime _FuelDate;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Fuel_Entry()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Fuel_Entry(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    public string EntryNo
    {
        get { return _EntryNo; }
        set { _EntryNo = value; }
    }
    public int VehicleID
    {
        get { return _VehicleID; }
        set { _VehicleID = value; }
    }

    public int DriverID
    {
        get { return _DriverID; }
        set { _DriverID = value; }
    }

    public string Letter
    {
        get { return _Letter; }
        set { _Letter = value; }
    }

    public decimal TotalAmount
    {
        get { return _TotalAmount; }
        set { _TotalAmount = value; }
    }

    public string Remarks
    {
        get { return _Remarks; }
        set { _Remarks = value; }
    }

    public string EntryBy
    {
        get { return _EntryBy; }
        set { _EntryBy = value; }
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
    public DateTime FuelDate
    {
        get { return _FuelDate; }
        set { _FuelDate = value; }
    }

    #endregion
    
    #region All Public Member Function
    public void Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_fuelentry");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            this.VehicleID = Util.GetInt(this.VehicleID);
            this.DriverID = Util.GetInt(this.DriverID);
            this.Letter = Util.GetString(this.Letter);
            this.TotalAmount = Util.GetDecimal(this.TotalAmount);
            this.Remarks = Util.GetString(this.Remarks);
            this.EntryBy = Util.GetString(this.EntryBy);
            this.CentreID = Util.GetInt(this.CentreID);
            this.HospCentreID = Util.GetInt(this.HospCentreID);
            this.FuelDate = Util.GetDateTime(this.FuelDate);

            cmd.Parameters.Add(new MySqlParameter("@vVehicleID", VehicleID));
            cmd.Parameters.Add(new MySqlParameter("@vDriverID", DriverID));
            cmd.Parameters.Add(new MySqlParameter("@vLetter", Letter));
            cmd.Parameters.Add(new MySqlParameter("@vTotalAmount", TotalAmount));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));
            cmd.Parameters.Add(new MySqlParameter("@vFuelDate",FuelDate));

            this.EntryNo = cmd.ExecuteScalar().ToString();

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
    #endregion
}