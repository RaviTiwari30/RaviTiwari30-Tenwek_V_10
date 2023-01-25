using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
/// <summary>
/// Summary description for Blood_Collection
/// </summary>
public class Blood_Collection
{
    #region All Memory Variables

    private string _Visitor_Id;
    private string _BBTubeNo;
    private string _volume;
    private string _CollectionRemark;
    private string _Visit_ID;
    private int _Isdonated;
    private string _CollectedBy;
    private int _CentreID;
    private int _IsShocked;
    private string _BagType;
    private DateTime _CollectedDate;
    private DateTime _dtEntry;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Blood_Collection()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Blood_Collection(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Visitor_Id
    {
        get
        {
            return _Visitor_Id;
        }
        set
        {
            _Visitor_Id = value;
        }
    }

    public virtual string BBTubeNo
    {
        get
        {
            return _BBTubeNo;
        }
        set
        {
            _BBTubeNo = value;
        }
    }

    public virtual string volume
    {
        get
        {
            return _volume;
        }
        set
        {
            _volume = value;
        }
    }

    public virtual string CollectionRemark
    {
        get
        {
            return _CollectionRemark;
        }
        set
        {
            _CollectionRemark = value;
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

    public virtual int Isdonated
    {
        get
        {
            return _Isdonated;
        }
        set
        {
            _Isdonated = value;
        }
    }

    public virtual string CollectedBy
    {
        get
        {
            return _CollectedBy;
        }
        set
        {
            _CollectedBy = value;
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

    public virtual int IsShocked
    {
        get
        {
            return _IsShocked;
        }
        set
        {
            _IsShocked = value;
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

    public virtual DateTime CollectedDate
    {
        get
        {
            return _CollectedDate;
        }
        set
        {
            _CollectedDate = value;
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
            string BloodCollectionId = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Blood_collection");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_BloodCollectionId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.Visitor_Id = Util.GetString(Visitor_Id);
            this.BBTubeNo = Util.GetString(BBTubeNo);
            this.volume = Util.GetString(volume);
            this.CollectionRemark = Util.GetString(CollectionRemark);
            this.Visit_ID = Util.GetString(Visit_ID);
            this.Isdonated = Util.GetInt(Isdonated);
            this.CollectedBy = Util.GetString(CollectedBy);
            this.CentreID = Util.GetInt(CentreID);
            this.IsShocked = Util.GetInt(IsShocked);
            this.BagType = Util.GetString(BagType);
            this.CollectedDate = Util.GetDateTime(CollectedDate);

            cmd.Parameters.Add(new MySqlParameter("@_Visitor_Id", Visitor_Id));
            cmd.Parameters.Add(new MySqlParameter("@_BBTubeNo", BBTubeNo));
            cmd.Parameters.Add(new MySqlParameter("@_volume", volume));
            cmd.Parameters.Add(new MySqlParameter("@_CollectionRemark", CollectionRemark));
            cmd.Parameters.Add(new MySqlParameter("@_Visit_ID", Visit_ID));
            cmd.Parameters.Add(new MySqlParameter("@_Isdonated", Isdonated));
            cmd.Parameters.Add(new MySqlParameter("@_CollectedBy", CollectedBy));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@_IsShocked", IsShocked));
            cmd.Parameters.Add(new MySqlParameter("@_BagType", BagType));
            cmd.Parameters.Add(new MySqlParameter("@_CollectedDate", CollectedDate));
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            BloodCollectionId = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return BloodCollectionId.ToString();
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