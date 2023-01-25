#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class PurchaseRequestMaster
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _PurchaseRequestNo;
    private string _RaisedByID;
    private string _RaisedByName;
    private DateTime _RaisedDate;
    private int _Status;
    private DateTime _ApprovedDate;
    private int _Approved;
    private string _ReasonOfRejection;
    private string _RejectedBy;
    private string _Remarks;
    private DateTime _LastUpdatedDate;
    private string _LastUpdatedID;
    private string _LastUpdatedUserName;
    private string _StoreID;
    private string _Subject;
    private string _Type;
    private string _DeptLedgerNo;
    private int _CentreID;
    private string _Hospital_ID;
    private string _IpAddress;
    private string _IssuedTo;
    private int _CenterTo;
    private DateTime _date;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PurchaseRequestMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PurchaseRequestMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

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

    public virtual string PurchaseRequestNo
    {
        get
        {
            return _PurchaseRequestNo;
        }
        set
        {
            _PurchaseRequestNo = value;
        }
    }

    public virtual string RaisedByID
    {
        get
        {
            return _RaisedByID;
        }
        set
        {
            _RaisedByID = value;
        }
    }

    public virtual string RaisedByName
    {
        get
        {
            return _RaisedByName;
        }
        set
        {
            _RaisedByName = value;
        }
    }

    public virtual DateTime RaisedDate
    {
        get
        {
            return _RaisedDate;
        }
        set
        {
            _RaisedDate = value;
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

    public virtual DateTime ApprovedDate
    {
        get
        {
            return _ApprovedDate;
        }
        set
        {
            _ApprovedDate = value;
        }
    }

    public virtual int Approved
    {
        get
        {
            return _Approved;
        }
        set
        {
            _Approved = value;
        }
    }

    public virtual string ReasonOfRejection
    {
        get
        {
            return _ReasonOfRejection;
        }
        set
        {
            _ReasonOfRejection = value;
        }
    }

    public virtual string RejectedBy
    {
        get
        {
            return _RejectedBy;
        }
        set
        {
            _RejectedBy = value;
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

    public virtual DateTime LastUpdatedDate
    {
        get
        {
            return _LastUpdatedDate;
        }
        set
        {
            _LastUpdatedDate = value;
        }
    }

    public virtual string LastUpdatedID
    {
        get
        {
            return _LastUpdatedID;
        }
        set
        {
            _LastUpdatedID = value;
        }
    }

    public virtual string LastUpdatedUserName
    {
        get
        {
            return _LastUpdatedUserName;
        }
        set
        {
            _LastUpdatedUserName = value;
        }
    }

    public virtual string StoreID
    {
        get
        {
            return _StoreID;
        }
        set
        {
            _StoreID = value;
        }
    }

    public virtual string Subject
    {
        get
        {
            return _Subject;
        }
        set
        {
            _Subject = value;
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

   

    public DateTime bydate
    {
        get { return _date; }
        set { _date = value; }
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

    public virtual int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }

    public virtual string Hospital_ID
    {
        get { return _Hospital_ID; }
        set { _Hospital_ID = value; }
    }

    public virtual string IpAddress
    {
        get { return _IpAddress; }
        set { _IpAddress = value; }
    }

    public virtual string IssuedTo
    {
        get { return _IssuedTo; }
        set { _IssuedTo = value; }
    }


    public virtual int CenterTo
    {
        get { return _CenterTo; }
        set { _CenterTo = value; }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PurchaseRequest");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vPurchaseRequestNo";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.RaisedByID = Util.GetString(RaisedByID);
            this.RaisedByName = Util.GetString(RaisedByName);
            this.RaisedDate = Util.GetDateTime(RaisedDate);
            this.Status = Util.GetInt(Status);
            this.ApprovedDate = Util.GetDateTime(ApprovedDate);
            this.Approved = Util.GetInt(Approved);
            this.ReasonOfRejection = Util.GetString(ReasonOfRejection);
            this.RejectedBy = Util.GetString(RejectedBy);
            this.Remarks = Util.GetString(Remarks);
            this.LastUpdatedDate = Util.GetDateTime(LastUpdatedDate);
            this.LastUpdatedID = Util.GetString(LastUpdatedID);
            this.LastUpdatedUserName = Util.GetString(LastUpdatedUserName);
            this.StoreID = Util.GetString(StoreID);
            this.Subject = Util.GetString(Subject);
            this.Type = Util.GetString(Type);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.bydate = Util.GetDateTime(bydate);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.IpAddress = Util.GetString(IpAddress);
            this.IssuedTo = Util.GetString(IssuedTo);
            this.CenterTo = Util.GetInt(CenterTo);

            cmd.Parameters.Add(new MySqlParameter("@vLoc", Location));
            cmd.Parameters.Add(new MySqlParameter("@vHosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedByID", RaisedByID));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedByName", RaisedByName));
            cmd.Parameters.Add(new MySqlParameter("@vRaisedDate", RaisedDate));
            cmd.Parameters.Add(new MySqlParameter("@vStatus", Status));
            cmd.Parameters.Add(new MySqlParameter("@vApprovedDate", ApprovedDate));
            cmd.Parameters.Add(new MySqlParameter("@vApproved", Approved));
            cmd.Parameters.Add(new MySqlParameter("@vReasonOfRejection", ReasonOfRejection));
            cmd.Parameters.Add(new MySqlParameter("@vRejectedBy", RejectedBy));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedDate", LastUpdatedDate));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedID", LastUpdatedID));
            cmd.Parameters.Add(new MySqlParameter("@vLastUpdatedUserName", LastUpdatedUserName));
            cmd.Parameters.Add(new MySqlParameter("@vStoreID", StoreID));
            cmd.Parameters.Add(new MySqlParameter("@vSubject", Subject));
            cmd.Parameters.Add(new MySqlParameter("@vType", Type));
            cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@vbyDate", bydate));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", IpAddress));
            cmd.Parameters.Add(new MySqlParameter("@vIssuedTo", IssuedTo));
            cmd.Parameters.Add(new MySqlParameter("@vCenterTo", CenterTo));

            cmd.Parameters.Add(paramTnxID);

            PurchaseRequestNo = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseRequestNo.ToString();
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

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.HospCode]);
        this.ID = Util.GetInt(dtTemp.Rows[0][AllTables.PurchaseRequest.ID]);
        this.PurchaseRequestNo = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.PurchaseRequestNo]);
        this.RaisedByID = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.RaisedByID]);
        this.RaisedByName = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.RaisedByName]);
        this.RaisedDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.PurchaseRequest.RaisedDate]);
        this.Status = Util.GetInt(dtTemp.Rows[0][AllTables.PurchaseRequest.Status]);
        this.ApprovedDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.PurchaseRequest.ApprovedDate]);
        this.Approved = Util.GetInt(dtTemp.Rows[0][AllTables.PurchaseRequest.Approved]);
        this.ReasonOfRejection = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.ReasonOfRejection]);
        this.RejectedBy = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.RejectedBy]);
        this.Remarks = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.Remarks]);
        this.LastUpdatedID = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.LastUpdatedID]);
        this.LastUpdatedUserName = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.LastUpdatedUserName]);
        this.StoreID = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.StoreID]);
        this.DeptLedgerNo = Util.GetString(dtTemp.Rows[0][AllTables.PurchaseRequest.DeptLedgerNo]);
    }

    #endregion Helper Private Function
}