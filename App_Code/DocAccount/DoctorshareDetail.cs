using MySql.Data.MySqlClient;
using System;
using System.Data;

/// <summary>
/// Summary description for DoctorshareDetail
/// </summary>
public class DoctorshareDetail
{
    #region All Memory Variables

    private string _DoctorID;
    private string _ReceiptNo;
    private string _BillNo;
    private decimal _GrossAmount;
    private decimal _Discount;
    private decimal _NetAmount;
    private decimal _PaidAmount;
    private decimal _DoctorSharePercentage;
    private decimal _DoctorShare;
    private DateTime _FromDate;
    private DateTime _ToDate;
    private string _CreatedBy;
    private string _TypeOfTnx;
    private string _SubcategoryName;
    private string _SubcategoryId;
    private string _PatientID;
    private DateTime _BillDate;
    private string _Type;
    private int _PaymentType;
    private string _ItemID;
    private string _ItemName;    
    private decimal _Quantity;
    private decimal _ItemRate;
    private decimal _ItemNetAmount;    
    private string _IPAddress;
    private string _UserName;
    private string _PanelName;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DoctorshareDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DoctorshareDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    public virtual string ReceiptNo
    {
        get
        {
            return _ReceiptNo;
        }
        set
        {
            _ReceiptNo = value;
        }
    }

    public virtual string BillNo
    {
        get
        {
            return _BillNo;
        }
        set
        {
            _BillNo = value;
        }
    }

    public virtual decimal GrossAmount
    {
        get
        {
            return _GrossAmount;
        }
        set
        {
            _GrossAmount = value;
        }
    }

    public virtual decimal Discount
    {
        get
        {
            return _Discount;
        }
        set
        {
            _Discount = value;
        }
    }

    public virtual decimal NetAmount
    {
        get
        {
            return _NetAmount;
        }
        set
        {
            _NetAmount = value;
        }
    }

    public virtual decimal PaidAmount
    {
        get
        {
            return _PaidAmount;
        }
        set
        {
            _PaidAmount = value;
        }
    }

    public virtual decimal DoctorSharePercentage
    {
        get
        {
            return _DoctorSharePercentage;
        }
        set
        {
            _DoctorSharePercentage = value;
        }
    }

    public virtual decimal DoctorShare
    {
        get
        {
            return _DoctorShare;
        }
        set
        {
            _DoctorShare = value;
        }
    }

    public virtual DateTime FromDate
    {
        get
        {
            return _FromDate;
        }
        set
        {
            _FromDate = value;
        }
    }

    public virtual DateTime ToDate
    {
        get
        {
            return _ToDate;
        }
        set
        {
            _ToDate = value;
        }
    }

    public virtual string CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }

    public virtual string TypeOfTnx
    {
        get
        {
            return _TypeOfTnx;
        }
        set
        {
            _TypeOfTnx = value;
        }
    }

    public virtual string SubcategoryName
    {
        get
        {
            return _SubcategoryName;
        }
        set
        {
            _SubcategoryName = value;
        }
    }

    public virtual string SubcategoryId
    {
        get
        {
            return _SubcategoryId;
        }
        set
        {
            _SubcategoryId = value;
        }
    }

    public virtual string PatientID
    {
        get
        {
            return _PatientID;
        }
        set
        {
            _PatientID = value;
        }
    }

    public virtual DateTime BillDate
    {
        get
        {
            return _BillDate;
        }
        set
        {
            _BillDate = value;
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
    public virtual int PaymentType
    {
        get
        {
            return _PaymentType;
        }
        set
        {
            _PaymentType = value;
        }
    }
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
    public virtual string ItemName
    {
        get
        {
            return _ItemName;
        }
        set
        {
            _ItemName = value;
        }
    }
    public virtual decimal Quantity
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
    public virtual decimal ItemRate
    {
        get
        {
            return _ItemRate;
        }
        set
        {
            _ItemRate = value;
        }
    }
    public virtual decimal ItemNetAmount
    {
        get
        {
            return _ItemNetAmount;
        }
        set
        {
            _ItemNetAmount = value;
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


    public virtual string UserName
    {
        get
        {
            return _UserName;
        }
        set
        {
            _UserName = value;
        }
    }
    public virtual string PanelName
    {
        get
        {
            return _PanelName;
        }
        set
        {
            _PanelName = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue;

            System.Text.StringBuilder objSQL = new System.Text.StringBuilder();

            objSQL.Append("da_DoctorShareDetail_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@@Identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.DoctorID = Util.GetString(DoctorID);
            this.ReceiptNo = Util.GetString(ReceiptNo);
            this.BillNo = Util.GetString(BillNo);
            this.GrossAmount = Util.GetDecimal(GrossAmount);
            this.Discount = Util.GetDecimal(Discount);
            this.NetAmount = Util.GetDecimal(NetAmount);
            this.PaidAmount = Util.GetDecimal(PaidAmount);
            this.DoctorSharePercentage = Util.GetDecimal(DoctorSharePercentage);
            this.DoctorShare = Util.GetDecimal(DoctorShare);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.TypeOfTnx = Util.GetString(TypeOfTnx);
            this.SubcategoryId = Util.GetString(SubcategoryId);
            this.SubcategoryName = Util.GetString(SubcategoryName);
            this.PatientID = Util.GetString(PatientID);
            this.BillDate = Util.GetDateTime(BillDate);
            this.Type = Util.GetString(Type);
            this.PaymentType = Util.GetInt(PaymentType);
            this.ItemID = Util.GetString(ItemID);
            this.ItemName = Util.GetString(ItemName);
            this.Quantity = Util.GetDecimal(Quantity);
            this.ItemRate = Util.GetDecimal(ItemRate);
            this.ItemNetAmount = Util.GetDecimal(ItemNetAmount);            
            this.IPAddress = Util.GetString(IPAddress);
            this.UserName = Util.GetString(UserName);
            this.PanelName = Util.GetString(PanelName);

            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", ReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@vBillNo", BillNo));
            cmd.Parameters.Add(new MySqlParameter("@vGrossAmount", GrossAmount));
            cmd.Parameters.Add(new MySqlParameter("@vDiscount", Discount));
            cmd.Parameters.Add(new MySqlParameter("@vNetAmount", NetAmount));
            cmd.Parameters.Add(new MySqlParameter("@vPaidAmount", PaidAmount));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorSharePercentage", DoctorSharePercentage));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorShare", DoctorShare));
            cmd.Parameters.Add(new MySqlParameter("@vFromDate", FromDate));
            cmd.Parameters.Add(new MySqlParameter("@vToDate", ToDate));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfTnx", TypeOfTnx));
            cmd.Parameters.Add(new MySqlParameter("@vSubcategoryId", SubcategoryId));
            cmd.Parameters.Add(new MySqlParameter("@vSubcategoryName", SubcategoryName));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vBillDate", BillDate));
            cmd.Parameters.Add(new MySqlParameter("@vType", Type));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentType", PaymentType));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@vItemName", ItemName));
            cmd.Parameters.Add(new MySqlParameter("@vQuantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@vItemRate", ItemRate));
            cmd.Parameters.Add(new MySqlParameter("@vItemNetAmount",ItemNetAmount));            
            cmd.Parameters.Add(new MySqlParameter("@vIPAddress", IPAddress));
            cmd.Parameters.Add(new MySqlParameter("@vUserName", UserName));
            cmd.Parameters.Add(new MySqlParameter("@vPanelName", PanelName)); 
          


            cmd.Parameters.Add(paramTnxID);

            iPkValue = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue.ToString();
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