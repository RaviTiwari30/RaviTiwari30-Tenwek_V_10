using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Visitors
/// </summary>
public class Visitors
{
    #region All Memory Variables

    private int _ID;
    private string _Visitor_ID;
    private string _Title;
    private string _Dfirstname;
    private string _Dlastname;
    private string _Name;
    private string _dtBirth;
    private string _Gender;
    private string _Kin_Name;
    private string _Relation;
    private int _BloodGroup_Id;
    private int _Tested_BloodGroup_Id;
    private string _Address;
    private string _Country;
    private string _City;
    private string _PinCode;
    private string _PhoneNo;
    private string _MobileNo;
    private string _Email;
    private string _IdProof;
    private string _IdProofNo;
    
    private int _isFit;

    //private string _dtEntry ;
    private string _EntryBy;

    private int _CentreID;
    private DateTime _Blood_DonateDate;
    private int _isRevisit;
    private DateTime _dtEntry;
    private DateTime _DOB;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Visitors()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Visitors(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

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

    public virtual string Title
    {
        get
        {
            return _Title;
        }
        set
        {
            _Title = value;
        }
    }

    public virtual string Dfirstname
    {
        get
        {
            return _Dfirstname;
        }
        set
        {
            _Dfirstname = value;
        }
    }

    public virtual string Dlastname
    {
        get
        {
            return _Dlastname;
        }
        set
        {
            _Dlastname = value;
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

    public virtual string dtBirth
    {
        get
        {
            return _dtBirth;
        }
        set
        {
            _dtBirth = value;
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

    public virtual string Kin_Name
    {
        get
        {
            return _Kin_Name;
        }
        set
        {
            _Kin_Name = value;
        }
    }

    public virtual string Relation
    {
        get
        {
            return _Relation;
        }
        set
        {
            _Relation = value;
        }
    }

    public virtual int BloodGroup_Id
    {
        get
        {
            return _BloodGroup_Id;
        }
        set
        {
            _BloodGroup_Id = value;
        }
    }

    public virtual int Tested_BloodGroup_Id
    {
        get
        {
            return _Tested_BloodGroup_Id;
        }
        set
        {
            _Tested_BloodGroup_Id = value;
        }
    }

    public virtual string Address
    {
        get
        {
            return _Address;
        }
        set
        {
            _Address = value;
        }
    }

    public virtual string Country
    {
        get
        {
            return _Country;
        }
        set
        {
            _Country = value;
        }
    }

    public virtual string City
    {
        get
        {
            return _City;
        }
        set
        {
            _City = value;
        }
    }

    public virtual string PinCode
    {
        get
        {
            return _PinCode;
        }
        set
        {
            _PinCode = value;
        }
    }

    public virtual string PhoneNo
    {
        get
        {
            return _PhoneNo;
        }
        set
        {
            _PhoneNo = value;
        }
    }

    public virtual string MobileNo
    {
        get
        {
            return _MobileNo;
        }
        set
        {
            _MobileNo = value;
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

    public virtual string Email
    {
        get
        {
            return _Email;
        }
        set
        {
            _Email = value;
        }
    }
    public virtual string IdProof
    {
        get
        {
            return _IdProof;
        }
        set
        {
            _IdProof = value;
        }
    }
    public virtual string IdProofNo
    {
        get
        {
            return _IdProofNo;
        }
        set
        {
            _IdProofNo = value;
        }
    }

    //public virtual string dtEntry
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

    public virtual DateTime Blood_DonateDate
    {
        get
        {
            return _Blood_DonateDate;
        }
        set
        {
            _Blood_DonateDate = value;
        }
    }

    public virtual int isRevisit
    {
        get
        {
            return _isRevisit;
        }
        set
        {
            _isRevisit = value;
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

    public virtual DateTime DOB
    {
        get
        {
            return _DOB;
        }
        set
        {
            _DOB = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string VisitorID = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_visitors_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_VisitorID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //this.Visitor_ID = Util.GetString(Visitor_ID);
            this.Title = Util.GetString(Title);
            this.Dfirstname = Util.GetString(Dfirstname);
            this.Dlastname = Util.GetString(Dlastname);
            this.Name = Util.GetString(Name);
            this.dtBirth = Util.GetString(dtBirth);
            this.Gender = Util.GetString(Gender);
            this.Kin_Name = Util.GetString(Kin_Name);
            this.Relation = Util.GetString(Relation);
            this.BloodGroup_Id = Util.GetInt(BloodGroup_Id);
            this.Tested_BloodGroup_Id = Util.GetInt(Tested_BloodGroup_Id);
            this.Address = Util.GetString(Address);
            this.Country = Util.GetString(Country);
            this.City = Util.GetString(City);
            this.PinCode = Util.GetString(PinCode);
            this.PhoneNo = Util.GetString(PhoneNo);
            this.MobileNo = Util.GetString(MobileNo);
            this.Email = Util.GetString(Email);
            this.IdProof = Util.GetString(IdProof);
            this.IdProofNo = Util.GetString(IdProofNo);
            this.isFit =Util.GetInt(isFit);

            //this.dtEntry = Util.GetString(dtEntry);
            this.EntryBy = Util.GetString(EntryBy);
            this.CentreID = Util.GetInt(CentreID);
            this.Blood_DonateDate = Util.GetDateTime(Blood_DonateDate);
            this.isRevisit = Util.GetInt(isRevisit);

            this.DOB = Util.GetDateTime(DOB);

            //cmd.Parameters.Add(new MySqlParameter("@_Visitor_ID", Visitor_ID));
            cmd.Parameters.Add(new MySqlParameter("@_Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@_Name", Name));
            cmd.Parameters.Add(new MySqlParameter("@_Dfirstname", Dfirstname));
            cmd.Parameters.Add(new MySqlParameter("@_Dlastname", Dlastname));
            cmd.Parameters.Add(new MySqlParameter("@_dtBirth", dtBirth));
            cmd.Parameters.Add(new MySqlParameter("@_Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@_Kin_Name", Kin_Name));
            cmd.Parameters.Add(new MySqlParameter("@_Relation", Relation));
            cmd.Parameters.Add(new MySqlParameter("@_BloodGroup_Id", BloodGroup_Id));
            cmd.Parameters.Add(new MySqlParameter("@_Tested_BloodGroup_Id", Tested_BloodGroup_Id));
            cmd.Parameters.Add(new MySqlParameter("@_Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@_Country", Country));
            cmd.Parameters.Add(new MySqlParameter("@_City", City));
            cmd.Parameters.Add(new MySqlParameter("@_PinCode", PinCode));
            cmd.Parameters.Add(new MySqlParameter("@_PhoneNo", PhoneNo));
            cmd.Parameters.Add(new MySqlParameter("@_MobileNo", MobileNo));
            cmd.Parameters.Add(new MySqlParameter("@_Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@_IdProof", IdProof));
            cmd.Parameters.Add(new MySqlParameter("@_IdProofNo", IdProofNo));
            cmd.Parameters.Add(new MySqlParameter("@_IsFit", isFit));

            //cmd.Parameters.Add(new MySqlParameter("@_dtEntry", dtEntry));
            cmd.Parameters.Add(new MySqlParameter("@_EntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@_Blood_DonateDate", Blood_DonateDate));
            cmd.Parameters.Add(new MySqlParameter("@_isRevisit", isRevisit));

            cmd.Parameters.Add(new MySqlParameter("@_DOB", Util.GetDateTime(DOB)));
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            VisitorID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return VisitorID.ToString();
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