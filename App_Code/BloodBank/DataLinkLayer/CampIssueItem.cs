using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for CampIssueItem
/// </summary>
public class CampIssueItem
{
    #region All Memory Variables

    private int _camp_Id;
    private int _ItemId;
    private int _QtyIssued;
    private int _QtyReturned;
    private DateTime _IssueDate;
    private string _Issued_CreatedBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public CampIssueItem()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public CampIssueItem(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int camp_Id
    {
        get
        {
            return _camp_Id;
        }
        set
        {
            _camp_Id = value;
        }
    }

    public virtual int ItemId
    {
        get
        {
            return _ItemId;
        }
        set
        {
            _ItemId = value;
        }
    }

    public virtual int QtyIssued
    {
        get
        {
            return _QtyIssued;
        }
        set
        {
            _QtyIssued = value;
        }
    }

    public virtual int QtyReturned
    {
        get
        {
            return _QtyReturned;
        }
        set
        {
            _QtyReturned = value;
        }
    }

    public virtual DateTime IssueDate
    {
        get
        {
            return _IssueDate;
        }
        set
        {
            _IssueDate = value;
        }
    }

    public virtual string Issued_CreatedBy
    {
        get
        {
            return _Issued_CreatedBy;
        }
        set
        {
            _Issued_CreatedBy = value;
        }
    }

    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_Camp_IssueItem");
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
            this.camp_Id = Util.GetInt(camp_Id);
            this.ItemId = Util.GetInt(ItemId);
            this.QtyIssued = Util.GetInt(QtyIssued);
            this.QtyReturned = Util.GetInt(QtyReturned);
            this.IssueDate = Util.GetDateTime(IssueDate);
            this.Issued_CreatedBy = Util.GetString(Issued_CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@_camp_Id", camp_Id));
            cmd.Parameters.Add(new MySqlParameter("@_ItemId", ItemId));
            cmd.Parameters.Add(new MySqlParameter("@_QtyIssued", QtyIssued));
            cmd.Parameters.Add(new MySqlParameter("@_QtyReturned", QtyReturned));
            cmd.Parameters.Add(new MySqlParameter("@_IssueDate", IssueDate));
            cmd.Parameters.Add(new MySqlParameter("@_Issued_CreatedBy", Issued_CreatedBy));

            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

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

    #endregion Set All Property
}