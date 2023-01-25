using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for BloodGrouping
/// </summary>
public class BloodGrouping
{
    #region All Memory Variables

    private string _BloodCollection_Id;
    private string _Grouping_Id;
    private string _ScreenedBG;
    private string _AntiA;

    //public string _AntiA1;
    private string _AntiB;

    private string _AntiAB;

    //private string _AntiD;
    private string _RH;

    private string _ACell;
    private string _BCell;
    private string _OCell;

    //private string _PtCell;
    private int _CentreId;

    private int _Status;
    private string _CreatedBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public BloodGrouping()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public BloodGrouping(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Grouping_Id
    {
        get
        {
            return _Grouping_Id;
        }
        set
        {
            _Grouping_Id = value;
        }
    }

    public virtual string BloodCollection_Id
    {
        get
        {
            return _BloodCollection_Id;
        }
        set
        {
            _BloodCollection_Id = value;
        }
    }

    public virtual string ScreenedBG
    {
        get
        {
            return _ScreenedBG;
        }
        set
        {
            _ScreenedBG = value;
        }
    }

    public virtual string AntiA
    {
        get
        {
            return _AntiA;
        }
        set
        {
            _AntiA = value;
        }
    }

    //public virtual string AntiA1
    //{
    //    get
    //    {
    //        return _AntiA1;
    //    }
    //    set
    //    {
    //        _AntiA1 = value;
    //    }
    //}
    public virtual string RH
    {
        get
        {
            return _RH;
        }
        set
        {
            _RH = value;
        }
    }

    public virtual string AntiB
    {
        get
        {
            return _AntiB;
        }
        set
        {
            _AntiB = value;
        }
    }

    public virtual string AntiAB
    {
        get
        {
            return _AntiAB;
        }
        set
        {
            _AntiAB = value;
        }
    }

    //public virtual string AntiD
    //{
    //    get
    //    {
    //        return _AntiD;
    //    }
    //    set
    //    {
    //        _AntiD = value;
    //    }
    //}
    public virtual string ACell
    {
        get
        {
            return _ACell;
        }
        set
        {
            _ACell = value;
        }
    }

    public virtual string BCell
    {
        get
        {
            return _BCell;
        }
        set
        {
            _BCell = value;
        }
    }

    public virtual string OCell
    {
        get
        {
            return _OCell;
        }
        set
        {
            _OCell = value;
        }
    }

    //public virtual string PtCell
    //{
    //    get
    //    {
    //        return _PtCell;
    //    }
    //    set
    //    {
    //        _PtCell = value;
    //    }
    //}
    public virtual int CentreId
    {
        get
        {
            return _CentreId;
        }
        set
        {
            _CentreId = value;
        }
    }

    public virtual int Status
    {
        get
        {
            return _Status;
        }
        set
        {
            _Status = value;
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

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string GroupingId = "";

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_grouping");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "_GroupingId";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.BloodCollection_Id = Util.GetString(BloodCollection_Id);
            this.ScreenedBG = Util.GetString(ScreenedBG);
            this.AntiA = Util.GetString(AntiA);
            //this.AntiA1=Util.GetString(AntiA1);
            this.AntiB = Util.GetString(AntiB);
            this.AntiAB = Util.GetString(AntiAB);
            //this.AntiD=Util.GetString(AntiD);
            this.RH = Util.GetString(RH);
            this.ACell = Util.GetString(ACell);
            this.BCell = Util.GetString(BCell);
            this.OCell = Util.GetString(OCell);
            //this.PtCell=Util.GetString(PtCell);
            this.Status = Util.GetInt(Status);
            this.CentreId = Util.GetInt(CentreId);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@_BloodCollection_Id", BloodCollection_Id));
            cmd.Parameters.Add(new MySqlParameter("@_ScreenedBG", ScreenedBG));
            cmd.Parameters.Add(new MySqlParameter("@_AntiA", AntiA));
            //cmd.Parameters.Add(new MySqlParameter("@_AntiA1", AntiA1));
            cmd.Parameters.Add(new MySqlParameter("@_AntiB", AntiB));
            cmd.Parameters.Add(new MySqlParameter("@_AntiAB", AntiAB));
            //cmd.Parameters.Add(new MySqlParameter("@_AntiD", AntiD));
            cmd.Parameters.Add(new MySqlParameter("@_RH", RH));
            cmd.Parameters.Add(new MySqlParameter("@_ACell", ACell));
            cmd.Parameters.Add(new MySqlParameter("@_BCell", BCell));
            cmd.Parameters.Add(new MySqlParameter("@_OCell", OCell));
            //cmd.Parameters.Add(new MySqlParameter("@_PtCell", PtCell));
            cmd.Parameters.Add(new MySqlParameter("@_Status", Status));
            cmd.Parameters.Add(new MySqlParameter("@_CentreId", CentreId));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", CreatedBy));
            cmd.Parameters.Add(paramTnxID);
            GroupingId = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return GroupingId.ToString();
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