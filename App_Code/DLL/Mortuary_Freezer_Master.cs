using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Text;
using System.Data;

/// <summary>
/// Summary description for Mortuary_Freezer_Master
/// </summary>
public class Mortuary_Freezer_Master
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _RackID;
    private string _RackName;
    private string _Rack_No;
    private string _Room_No;
    private string _Floor;
    private int _ShelfNo;
    private string _Description;
    private int _IsMuslim;
    private int _IsActive;
    private string _CreatedBy;
    private int _CentreID;
    private int _HospCentreID;
    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Mortuary_Freezer_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public Mortuary_Freezer_Master(MySqlTransaction objTrans)
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

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public string RackID
    {
        get { return _RackID; }
        set { _RackID = value; }
    }

    public string RackName
    {
        get { return _RackName; }
        set { _RackName = value; }
    }

    public string Rack_No
    {
        get { return _Rack_No; }
        set { _Rack_No = value; }
    }

    public string Room_No
    {
        get { return _Room_No; }
        set { _Room_No = value; }
    }

    public string Floor
    {
        get { return _Floor; }
        set { _Floor = value; }
    }

    public int ShelfNo
    {
        get { return _ShelfNo; }
        set { _ShelfNo = value; }
    }


    public string Description
    {
        get { return _Description; }
        set { _Description = value; }
    }


    public int IsMuslim
    {
        get { return _IsMuslim; }
        set { _IsMuslim = value; }
    }


    public int IsActive
    {
        get { return _IsActive; }
        set { _IsActive = value; }
    }

    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
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

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_mortuary_freezer_master");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vRackID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.RackName = Util.GetString(RackName);
            this.Rack_No = Util.GetString(Rack_No);
            this.Room_No = Util.GetString(Room_No);
            this.Floor = Util.GetString(Floor);
            this.ShelfNo = Util.GetInt(ShelfNo);
            this.Description = Util.GetString(Description);
            this.IsMuslim = Util.GetInt(IsMuslim);
            this.IsActive = Util.GetInt(IsActive);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CentreID = Util.GetInt(CentreID);
            this.HospCentreID = Util.GetInt(HospCentreID);

            cmd.Parameters.Add(new MySqlParameter("@vLocation", Location));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@vRackName", RackName));
            cmd.Parameters.Add(new MySqlParameter("@vRack_No", Rack_No));
            cmd.Parameters.Add(new MySqlParameter("@vRoom_No", Room_No));
            cmd.Parameters.Add(new MySqlParameter("@vFloor", Floor));
            cmd.Parameters.Add(new MySqlParameter("@vShelfNo", ShelfNo));
            cmd.Parameters.Add(new MySqlParameter("@vDescription", Description));
            cmd.Parameters.Add(new MySqlParameter("@vIsMuslim", IsMuslim));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));
            cmd.Parameters.Add(paramTnxID);

            RackID = Util.GetString(cmd.ExecuteScalar().ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return RackID;
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
    #endregion All Public Member Function
}

