using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class PurchaseOrderPurchaseRequest
{
    #region All Properties

    private int _POPurchaseRequestID;

    public int POPurchaseRequestID
    {
        get { return _POPurchaseRequestID; }
        set { _POPurchaseRequestID = value; }
    }

    private string _PRNumber;

    public string PRNumber
    {
        get { return _PRNumber; }
        set { _PRNumber = value; }
    }

    private string _PONumber;

    public string PONumber
    {
        get { return _PONumber; }
        set { _PONumber = value; }
    }

    private string _ITemID;

    public string ITemID
    {
        get { return _ITemID; }
        set { _ITemID = value; }
    }

    private decimal _OrderedQty;

    public decimal OrderedQty
    {
        get { return _OrderedQty; }
        set { _OrderedQty = value; }
    }

    private int _PODetailID;

    public int PODetailID
    {
        get { return _PODetailID; }
        set { _PODetailID = value; }
    }

    private int _CentreID;

    public int CentreID
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

    private string _Hospital_ID;

    public string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
        }
    }

    #endregion All Properties

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PurchaseOrderPurchaseRequest()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PurchaseOrderPurchaseRequest(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region All Public Member Function

    public void InsertPoPr()
    {
        int iPkValue;
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_purchaseorderpurchaserequest(PRNumber,PONumber,ITemID,OrderedQty,PODetailID,CentreID,Hospital_ID)");
            objSQL.Append("VALUES (@PRNumber, @PONumber,@ITemID,@OrderedQty,@PODetailID,@CentreID,@Hospital_ID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PRNumber = Util.GetString(PRNumber);
            this.PONumber = Util.GetString(PONumber);
            this.ITemID = Util.GetString(ITemID);
            this.OrderedQty = Util.GetDecimal(OrderedQty);
            this.PODetailID = Util.GetInt(PODetailID);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PRNumber", PRNumber),
                new MySqlParameter("@PONumber", PONumber),
                new MySqlParameter("@ITemID", ITemID),
                new MySqlParameter("@OrderedQty", OrderedQty),
                new MySqlParameter("@PODetailID", PODetailID),
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@Hospital_ID", Hospital_ID));

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
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