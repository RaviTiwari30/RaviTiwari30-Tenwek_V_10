using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for itemmaster_deptWise
/// </summary>
public class itemmaster_deptWise
{
    #region All Memory Variables

    private string _ItemID;
    private string _DeptLedgerNo;
    private decimal _MaxLevel;
    private decimal _MinLevel;
    private decimal _ReorderLevel;
    private decimal _ReorderQty;
    private decimal _MaxReorderQty;
    private decimal _MinReorderQty;
    private string _MajorUnit;
    private string _MinorUnit;
    private decimal _ConversionFactor;
    private string _SubCategoryID;
    private string _CreatedBy;
    private string _ID;
    private string _ipAddress;
    private string _Rack;
    private string _Shelf;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public itemmaster_deptWise()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public itemmaster_deptWise(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string ItemID
    {
        get
        {
            return _ItemID;
        }
        set
        {
            _ItemID = value;
        }
    }

    public virtual string DeptLedgerNo
    {
        get
        {
            return _DeptLedgerNo;
        }
        set
        {
            _DeptLedgerNo = value;
        }
    }

    public virtual decimal MaxLevel
    {
        get
        {
            return _MaxLevel;
        }
        set
        {
            _MaxLevel = value;
        }
    }

    public virtual decimal MinLevel
    {
        get
        {
            return _MinLevel;
        }
        set
        {
            _MinLevel = value;
        }
    }

    public virtual decimal ReorderLevel
    {
        get
        {
            return _ReorderLevel;
        }
        set
        {
            _ReorderLevel = value;
        }
    }

    public virtual decimal ReorderQty
    {
        get
        {
            return _ReorderQty;
        }
        set
        {
            _ReorderQty = value;
        }
    }

    public virtual decimal MaxReorderQty
    {
        get
        {
            return _MaxReorderQty;
        }
        set
        {
            _MaxReorderQty = value;
        }
    }

    public virtual decimal MinReorderQty
    {
        get { return _MinReorderQty; }
        set { _MinReorderQty = value; }
    }

    public virtual string SubCategoryID
    {
        get { return _SubCategoryID; }
        set { _SubCategoryID = value; }
    }

    public virtual string majorUnit
    {
        get { return _MajorUnit; }
        set { _MajorUnit = value; }
    }

    public virtual string minorUnit
    {
        get { return _MinorUnit; }
        set { _MinorUnit = value; }
    }

    public virtual decimal ConversionFactor
    {
        get { return _ConversionFactor; }
        set { _ConversionFactor = value; }
    }

    public virtual string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }

    public virtual string ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public virtual string ipAddress
    {
        get { return _ipAddress; }
        set { _ipAddress = value; }
    }

    public virtual string Rack
    {
        get { return _Rack; }
        set { _Rack = value; }
    }

    public virtual string Shelf
    {
        get { return _Shelf; }
        set { _Shelf = value; }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_itemmaster_deptWise");
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

            this.ItemID = Util.GetString(ItemID);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.MaxLevel = Util.GetDecimal(MaxLevel);
            this.MinLevel = Util.GetDecimal(MinLevel);
            this.ReorderLevel = Util.GetDecimal(ReorderLevel);
            this.ReorderQty = Util.GetDecimal(ReorderQty);
            this.MaxReorderQty = Util.GetDecimal(MaxReorderQty);
            this.MinReorderQty = Util.GetDecimal(MinReorderQty);
            this.majorUnit = Util.GetString(majorUnit);
            this.minorUnit = Util.GetString(minorUnit);
            this.ConversionFactor = Util.GetDecimal(ConversionFactor);
            this.SubCategoryID = Util.GetString(SubCategoryID);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.ipAddress = Util.GetString(ipAddress);
            this.Rack = Util.GetString(Rack);
            this.Shelf = Util.GetString(Shelf);

            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@MaxLevel", MaxLevel));
            cmd.Parameters.Add(new MySqlParameter("@MinLevel", MinLevel));
            cmd.Parameters.Add(new MySqlParameter("@ReorderLevel", ReorderLevel));
            cmd.Parameters.Add(new MySqlParameter("@ReorderQty", ReorderQty));
            cmd.Parameters.Add(new MySqlParameter("@MaxReorderQty", MaxReorderQty));
            cmd.Parameters.Add(new MySqlParameter("@MinReorderQty", MinReorderQty));
            cmd.Parameters.Add(new MySqlParameter("@majorUnit", majorUnit));
            cmd.Parameters.Add(new MySqlParameter("@minorUnit", minorUnit));
            cmd.Parameters.Add(new MySqlParameter("@ConversionFactor", ConversionFactor));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryID", SubCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@ipAddress", ipAddress));
            cmd.Parameters.Add(new MySqlParameter("@Rack", Rack));
            cmd.Parameters.Add(new MySqlParameter("@Shelf", Shelf));
            cmd.Parameters.Add(paramTnxID);

            ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ItemID.ToString();
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
}