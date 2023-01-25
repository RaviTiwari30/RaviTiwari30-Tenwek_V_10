using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Visitors_History
/// </summary>
public class Visitors_History
{
    #region All Memory Variables

    private string _Visitor_ID;
    private string _Visit_ID;
    private string _Blood_Pressure;
    private string _Weight;
    private string _Pulse;
    private string _GPE;
    private string _Height;
    private string _Temprature;
    private string _Hb;
    private int _isFit;
    private string _BagType;
    private string _Quantity;
    private string _Remarks;

    //private string _dtEntry ;
    private string _EntryBy;

    private string _donationtype;
    private string _typedetail;
    private int _CentreID;
    private string _IPDNo;
    private string _isPhlebotomy;
    private string _Platelets;
    private string _Blood_donate;
    private DateTime _dtEntry;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Visitors_History()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Visitors_History(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Visitor_ID
    {
        get
        {
            return _Visitor_ID;
        }
        set
        {
            _Visitor_ID = value;
        }
    }

    public virtual string Visit_ID
    {
        get
        {
            return _Visit_ID;
        }
        set
        {
            _Visit_ID = value;
        }
    }

    public virtual string Blood_Pressure
    {
        get
        {
            return _Blood_Pressure;
        }
        set
        {
            _Blood_Pressure = value;
        }
    }

    public virtual string Weight
    {
        get
        {
            return _Weight;
        }
        set
        {
            _Weight = value;
        }
    }

    public virtual string Pulse
    {
        get
        {
            return _Pulse;
        }
        set
        {
            _Pulse = value;
        }
    }

    public virtual string GPE
    {
        get
        {
            return _GPE;
        }
        set
        {
            _GPE = value;
        }
    }

    public virtual string Height
    {
        get
        {
            return _Height;
        }
        set
        {
            _Height = value;
        }
    }

    public virtual string Temprature
    {
        get
        {
            return _Temprature;
        }
        set
        {
            _Temprature = value;
        }
    }

    public virtual string Hb
    {
        get
        {
            return _Hb;
        }
        set
        {
            _Hb = value;
        }
    }

    public virtual int isFit
    {
        get
        {
            return _isFit;
        }
        set
        {
            _isFit = value;
        }
    }

    public virtual string BagType
    {
        get
        {
            return _BagType;
        }
        set
        {
            _BagType = value;
        }
    }

    public virtual string Quantity
    {
        get
        {
            return _Quantity;
        }
        set
        {
            _Quantity = value;
        }
    }

    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }
        set
        {
            _Remarks = value;
        }
    }

    //public virtual int dtEntry
    //{
    //    get
    //    {
    //        return _dtEntry;
    //    }
    //    set
    //    {
    //        _dtEntry = value;
    //    }
    //}
    public virtual string EntryBy
    {
        get
        {
            return _EntryBy;
        }
        set
        {
            _EntryBy = value;
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

    public virtual string donationtype
    {
        get
        {
            return _donationtype;
        }
        set
        {
            _donationtype = value;
        }
    }

    public virtual string typedetail
    {
        get
        {
            return _typedetail;
        }
        set
        {
            _typedetail = value;
        }
    }

    public virtual string IPDNo
    {
        get
        {
            return _IPDNo;
        }
        set
        {
            _IPDNo = value;
        }
    }

    public virtual string isPhlebotomy
    {
        get
        {
            return _isPhlebotomy;
        }
        set
        {
            _isPhlebotomy = value;
        }
    }

    public virtual string Platelets
    {
        get
        {
            return _Platelets;
        }
        set
        {
            _Platelets = value;
        }
    }

    public virtual string Blood_donate
    {
        get
        {
            return _Blood_donate;
        }
        set
        {
            _Blood_donate = value;
        }
    }

    public virtual DateTime dtEntry
    {
        get
        {
            return _dtEntry;
        }
        set
        {
            _dtEntry = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string VisitID = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_visitors_history_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_VisitID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Visitor_ID = Util.GetString(Visitor_ID);
            //this.Visit_ID = Util.GetString(Visit_ID);
            this.Blood_Pressure = Util.GetString(Blood_Pressure);
            this.Weight = Util.GetString(Weight);
            this.Pulse = Util.GetString(Pulse);
            this.GPE = Util.GetString(GPE);
            this.Height = Util.GetString(Height);
            this.Temprature = Util.GetString(Temprature);
            this.Hb = Util.GetString(Hb);
            this.isFit = Util.GetInt(isFit);
            this.BagType = Util.GetString(BagType);
            this.Quantity = Util.GetString(Quantity);
            this.Remarks = Util.GetString(Remarks);
            this.EntryBy = Util.GetString(EntryBy);
            this.CentreID = Util.GetInt(CentreID);
            this.donationtype = Util.GetString(donationtype);
            this.typedetail = Util.GetString(typedetail);
            this.IPDNo = Util.GetString(IPDNo);
            this.isPhlebotomy = Util.GetString(isPhlebotomy);
            this.Platelets = Util.GetString(Platelets);
            this.Blood_donate = Util.GetString(Blood_donate);

            cmd.Parameters.Add(new MySqlParameter("@_Visitor_ID", Visitor_ID));
            //cmd.Parameters.Add(new MySqlParameter("@_Visit_ID", Visit_ID));
            cmd.Parameters.Add(new MySqlParameter("@_Blood_Pressure", Blood_Pressure));
            cmd.Parameters.Add(new MySqlParameter("@_Weight", Weight));
            cmd.Parameters.Add(new MySqlParameter("@_Pulse", Pulse));
            cmd.Parameters.Add(new MySqlParameter("@_GPE", GPE));
            cmd.Parameters.Add(new MySqlParameter("@_Height", Height));
            cmd.Parameters.Add(new MySqlParameter("@_Temprature", Temprature));
            cmd.Parameters.Add(new MySqlParameter("@_Hb", Hb));
            cmd.Parameters.Add(new MySqlParameter("@_isFit", isFit));
            cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            cmd.Parameters.Add(new MySqlParameter("@_Quantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@_EntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@_donationtype", donationtype));
            cmd.Parameters.Add(new MySqlParameter("@_typedetail", typedetail));
            cmd.Parameters.Add(new MySqlParameter("@_IPDNo", IPDNo));
            cmd.Parameters.Add(new MySqlParameter("@_isPhlebotomy", isPhlebotomy));
            cmd.Parameters.Add(new MySqlParameter("@_Platelets", Platelets));
            cmd.Parameters.Add(new MySqlParameter("@_Blood_donate", Blood_donate));
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            VisitID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return VisitID.ToString();
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