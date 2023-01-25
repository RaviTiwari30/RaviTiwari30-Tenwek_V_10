using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for LabObservation_Range
/// </summary>
public class LabObservation_Range
{

    #region All Memory Variables
    private int _ID;
    private string _Range_ID;
    private string _Investigation_ID;
    private string _LabObservation_ID;
    private string _Gender;
    private decimal _FromAge;
    private decimal _ToAge;
    private string _MinReading;
    private string _maxReading;
    private decimal _MinCritical;
    private decimal _MaxCritical;
    private string _ReadingFormat;
    private string _Interpretation;
    private string _UserID;
    private DateTime  _Entdatetime;
    private string _UpdateID;
    private string _UpdateName;
    private string _UpdateRemarks;
    private DateTime  _updateDate;
    private string _DisplayReading;
    private string _DefaultReading;
    private string _ConversionFactor;
    private string _ConversionFactorUnit;
    private string _MachineID;
    private int _CentreID;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public LabObservation_Range()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public LabObservation_Range(MySqlTransaction objTrans)
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
    public virtual string Range_ID
    {
        get
        {
            return _Range_ID;
        }
        set
        {
            _Range_ID = value;
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
    public virtual string Gender
    {
        get
        {
            return _Gender;
        }
        set
        {
            _Gender = value;
        }

    }
    
    public virtual decimal FromAge
    {
        get
        {
            return _FromAge;
        }
        set
        {
            _FromAge = value;
        }
    }

    public virtual decimal ToAge
    {
        get
        {
            return _ToAge;
        }
        set
        {
            _ToAge = value;
        }
    }
    public virtual string MinReading
    {
        get
        {
            return _MinReading;
        }
        set
        {
            _MinReading = value;
        }
    }
    public virtual string maxReading
    {
        get
        {
            return _maxReading;
        }
        set
        {
            _maxReading = value;
        }
    }
    public virtual decimal MinCritical
    {
        get
        {
            return _MinCritical;
        }
        set
        {
            _MinCritical = value;
        }
    }
    public virtual decimal MaxCritical
    {
        get
        {
            return _MaxCritical;
        }
        set
        {
            _MaxCritical = value;
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
    public virtual string UserID
    {
        get
        {
            return _UserID;
        }
        set
        {
            _UserID = value;
        }
    }
    public virtual DateTime  Entdatetime
    {
        get
        {
            return _Entdatetime;
        }
        set
        {
            _Entdatetime = value;
        }
    }
    public virtual string UpdateID
    {
        get
        {
            return _UpdateID;
        }
        set
        {
            _UpdateID = value;
        }
    }
    public virtual string UpdateName
    {
        get
        {
            return _UpdateName;
        }
        set
        {
            _UpdateName = value;
        }
    }
    public virtual string UpdateRemarks
    {
        get
        {
            return _UpdateRemarks;
        }
        set
        {
            _UpdateRemarks = value;
        }
    }
    public virtual DateTime  updateDate
    {
        get
        {
            return _updateDate;
        }
        set
        {
            _updateDate = value;
        }
    }
    public virtual string DisplayReading
    {
        get
        {
            return _DisplayReading;
        }
        set
        {
            _DisplayReading = value;
        }
    }
    public virtual string DefaultReading
    {
        get
        {
            return _DefaultReading;
        }
        set
        {
            _DefaultReading = value;
        }
    }
    public virtual string ConversionFactor { get { return _ConversionFactor; } set { _ConversionFactor = value; } }
    public virtual string ConversionFactorUnit { get { return _ConversionFactorUnit; } set { _ConversionFactorUnit = value; } }
    public virtual string MachineID { get { return _MachineID; } set { _MachineID = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    //MachineID
     #endregion

    #region All Public Member Function

    public string Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_LabObservation_Range");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //this.Range_ID = Util.GetString(Range_ID);
            this.Investigation_ID = Util.GetString(Investigation_ID);
            this.LabObservation_ID = Util.GetString(LabObservation_ID);
            this.Gender = Util.GetString(Gender);
            this.FromAge = Util.GetDecimal(FromAge);
            this.ToAge = Util.GetDecimal(ToAge);
            this.MinReading = Util.GetString(MinReading);
            this.maxReading = Util.GetString(maxReading);
            this.MinCritical = Util.GetDecimal(MinCritical);
            this.MaxCritical = Util.GetDecimal(MaxCritical);
            this.ReadingFormat = Util.GetString(ReadingFormat);
            this.Interpretation = Util.GetString(Interpretation);
            this.UserID = Util.GetString(UserID);
            this.Entdatetime = Util.GetDateTime (Entdatetime);
            this.UpdateID = Util.GetString(UpdateID);
            this.UpdateName = Util.GetString(UpdateName);
            this.UpdateRemarks = Util.GetString(UpdateRemarks);
            this.updateDate = Util.GetDateTime (updateDate);
            this.DisplayReading = Util.GetString(DisplayReading);
            this.DefaultReading = Util.GetString(DefaultReading);
            this.ConversionFactor = Util.GetString(ConversionFactor);
            this.ConversionFactorUnit = Util.GetString(ConversionFactorUnit);
            this.MachineID = MachineID;
            this.CentreID = Util.GetInt(CentreID);

            cmd.Parameters.Add(new MySqlParameter("@Investigation_ID", Investigation_ID));
            cmd.Parameters.Add(new MySqlParameter("@LabObservation_ID", LabObservation_ID));
             cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@FromAge", FromAge));
            cmd.Parameters.Add(new MySqlParameter("@ToAge", ToAge));
            cmd.Parameters.Add(new MySqlParameter("@MinReading", MinReading));
            cmd.Parameters.Add(new MySqlParameter("@maxReading", maxReading));
            cmd.Parameters.Add(new MySqlParameter("@MinCritical", MinCritical));
            cmd.Parameters.Add(new MySqlParameter("@MaxCritical", MaxCritical));
            cmd.Parameters.Add(new MySqlParameter("@ReadingFormat", ReadingFormat));
            cmd.Parameters.Add(new MySqlParameter("@Interpretation", Interpretation));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@Entdatetime", Entdatetime));
            cmd.Parameters.Add(new MySqlParameter("@UpdateID", UpdateID));
            cmd.Parameters.Add(new MySqlParameter("@UpdateName", UpdateName));
            cmd.Parameters.Add(new MySqlParameter("@UpdateRemarks", UpdateRemarks));
            cmd.Parameters.Add(new MySqlParameter("@updateDate", updateDate));
            cmd.Parameters.Add(new MySqlParameter("@DisplayReading", DisplayReading));
            cmd.Parameters.Add(new MySqlParameter("@DefaultReading", DefaultReading));
            cmd.Parameters.Add(new MySqlParameter("@ConversionFactor", ConversionFactor));
            cmd.Parameters.Add(new MySqlParameter("@ConversionFactorUnit", ConversionFactorUnit));
            cmd.Parameters.Add(new MySqlParameter("@MachineID", MachineID));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(paramTnxID);
            string ID = cmd.ExecuteScalar().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ID;
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