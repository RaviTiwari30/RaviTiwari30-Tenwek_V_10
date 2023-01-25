#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class AutoPo
{
    #region All Memory Variables


    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public AutoPo()
	{
		objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}

    public AutoPo(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
	#endregion
    #region Set All Property
    private string _PRNo;

    public string PRNo
    {
        get { return _PRNo; }
        set { _PRNo = value; }
    }

    private string _UserID;

    public string UserID
    {
        get { return _UserID; }
        set { _UserID = value; }
    }
	

    private string _UserName;

    public string UserName
    {
        get { return _UserName; }
        set { _UserName = value; }
    }

    private string _PAUserID;

    public string PAUserID
    {
        get { return _PAUserID; }
        set { _PAUserID = value; }
    }

    private string _PRstatus;

    public string PRstatus
    {
        get { return _PRstatus; }
        set { _PRstatus = value; }
    }

    private string _AppTypeID;

    public string AppTypeID
    {
        get { return _AppTypeID; }
        set { _AppTypeID = value; }
    }
   
    private string _ItemID;

    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }

    private string _PurchaseOrderNo;

    public string PurchaseOrderNo
    {
        get { return _PurchaseOrderNo; }
        set { _PurchaseOrderNo = value; }
    }

    private int _CentreID;

    public int CentreID
        {
        get { return _CentreID; }
        set { _CentreID = value; }
        }
    private string _Hospital_ID;

    public string Hospital_ID
        {
        get { return _Hospital_ID; }
        set { _Hospital_ID = value; }
        }
	
	
     #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {                   
            
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("CheckAutoPo");
     
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vPoNumber";
            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;           
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@PRNo", PRNo));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@UserName", UserName));
            cmd.Parameters.Add(new MySqlParameter("@PAUserID", PAUserID));
            cmd.Parameters.Add(new MySqlParameter("@PRstatus", PRstatus));
            cmd.Parameters.Add(new MySqlParameter("@AppTypeID", AppTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));
            cmd.Parameters.Add(paramTnxID);
            PurchaseOrderNo = cmd.ExecuteScalar().ToString();
          
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseOrderNo.ToString();
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
    #endregion
}
