using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for DoctorRate
/// </summary>
public class DoctorRate
{
#region All Memory Variables
    
    private int _ID;
    private string _DoctorID;
    private decimal _OPD_App;
    private decimal _OPD_Pro;
    private decimal _OPD_Lab;
    private decimal _IPD_Visit;
   
    private decimal _IPD_Pro;
    private decimal _IPD_Ref;
    private int _Active;
    private System.DateTime _DateTime;
    private int _IsTotalBill;
    private decimal _IPD_Sur;
    private decimal _IPD_Lab;
    private decimal _Others;
    
    
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
      #region Overloaded Constructor
    public DoctorRate()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        

	}
    public DoctorRate(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property
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
    public virtual string DoctorID
    {
        get
        {
            return _DoctorID;
        }
        set
        {
            _DoctorID = value;
        }
    }
    public virtual decimal OPD_App
    {
        get
        {
            return _OPD_App;
        }
        set
        {
            _OPD_App = value;
        }
    }
    public virtual decimal OPD_Pro
    {
        get
        {
            return _OPD_Pro;
        }
        set
        {
            _OPD_Pro = value;
        }
    }
    public virtual decimal OPD_Lab
    {
        get
        {
            return _OPD_Lab;
        }
        set
        {
            _OPD_Lab = value;
        }
    }
    public virtual decimal IPD_Visit
    {
        get
        {
            return _IPD_Visit;
        }
        set
        {
            _IPD_Visit = value;
        }
    }
   
    public virtual decimal IPD_Pro
    {
        get
        {
            return _IPD_Pro;
        }
        set
        {
            _IPD_Pro = value;
        }
    }
    public virtual decimal IPD_Ref
    {
        get
        {
            return _IPD_Ref;
        }
        set
        {
            _IPD_Ref = value;
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
    public virtual DateTime DateTime
    {
        get
        {
            return _DateTime;
        }
        set
        {
            _DateTime = value;
        }
    }
    public virtual int IsTotalBill
    {
        get
        {
            return _IsTotalBill;

        }
        set
        {
            _IsTotalBill = value;
        }
    }
    public virtual decimal IPD_Sur
    {
        get
        {
            return _IPD_Sur;

        }
        set
        {
            _IPD_Sur = value;
        }
    }
    public virtual decimal IPD_Lab
    {
        get
        {
            return _IPD_Lab;

        }
        set
        {
            _IPD_Lab = value;
        }
    }
    public virtual decimal Others
    {
        get
        {
            return _Others;

        }
        set
        {
            _Others = value;
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
            objSQL.Append("Insert_DoctorRate");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@DoctorRate";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;




            this.ID = Util.GetInt(ID);
            this.DoctorID = Util.GetString(DoctorID);
            this.OPD_App = Util.GetDecimal(OPD_App);
            this.OPD_Pro = Util.GetDecimal(OPD_Pro);
            this.OPD_Lab = Util.GetDecimal(OPD_Lab);
            this.IPD_Visit = Util.GetDecimal(IPD_Visit);
            this.IPD_Pro = Util.GetDecimal(IPD_Pro);

            this.IPD_Ref = Util.GetDecimal(IPD_Ref);
            this.Active = Util.GetInt(Active);
            this.DateTime = Util.GetDateTime(DateTime);
            this.IsTotalBill = Util.GetInt(IsTotalBill);
            this.IPD_Sur = Util.GetDecimal(IPD_Sur);
            this.IPD_Lab = Util.GetDecimal(IPD_Lab);
            this.Others = Util.GetDecimal(Others);
            

            cmd.Parameters.Add(new MySqlParameter("@ID", ID));
            cmd.Parameters.Add(new MySqlParameter("@DoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@OPD_App", OPD_App));
            cmd.Parameters.Add(new MySqlParameter("@OPD_Pro", OPD_Pro));
            cmd.Parameters.Add(new MySqlParameter("@OPD_Lab", OPD_Lab));
            cmd.Parameters.Add(new MySqlParameter("@IPD_Visit", IPD_Visit));
            cmd.Parameters.Add(new MySqlParameter("@IPD_Pro", IPD_Pro));
            cmd.Parameters.Add(new MySqlParameter("@IPD_Ref", IPD_Ref));
            cmd.Parameters.Add(new MySqlParameter("@Active", Active));
            cmd.Parameters.Add(new MySqlParameter("@iDatetime", DateTime));
            cmd.Parameters.Add(new MySqlParameter("@IsTotalBill", IsTotalBill));
            cmd.Parameters.Add(new MySqlParameter("@IPD_Sur", IPD_Sur));
            cmd.Parameters.Add(new MySqlParameter("@IPD_Lab", IPD_Lab));
            cmd.Parameters.Add(new MySqlParameter("@Others", Others));
            
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();
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
    #endregion

}
