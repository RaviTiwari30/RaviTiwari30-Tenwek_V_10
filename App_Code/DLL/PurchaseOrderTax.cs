using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for PurchaseOrderTax
/// </summary>
public class PurchaseOrderTax
{
    #region All Memory Variables

    private int _POTaxID;
    private int _PODetailID;
    private string _PONumber;
    private string _ITemID;
    private string _TaxID;
    private decimal _TaxPer;
    private decimal _TaxAmt;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PurchaseOrderTax()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PurchaseOrderTax(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public int POTaxID
    {
        get { return _POTaxID; }
        set { _POTaxID = value; }
    }

    public int PODetailID
    {
        get { return _PODetailID; }
        set { _PODetailID = value; }
    }

    public string PONumber
    {
        get { return _PONumber; }
        set { _PONumber = value; }
    }

    public string ITemID
    {
        get { return _ITemID; }
        set { _ITemID = value; }
    }

    public string TaxID
    {
        get { return _TaxID; }
        set { _TaxID = value; }
    }

    public decimal TaxPer
    {
        get { return _TaxPer; }
        set { _TaxPer = value; }
    }

    public decimal TaxAmt
    {
        get { return _TaxAmt; }
        set { _TaxAmt = value; }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int InsertTax()
    {
        int iPkValue;
        try
        {
            StringBuilder objSQL = new StringBuilder();
            if (TaxID != "T5")
                objSQL.Append("INSERT INTO f_purchaseordertax(PODetailID,PONumber,ITemID,TaxID,TaxPer,TaxAmt)");
            else
                objSQL.Append("INSERT INTO f_purchaseorderExcisetax(PODetailID,PONumber,ITemID,TaxID,TaxPer,TaxAmt)");

            objSQL.Append("VALUES (@PODetailID, @PONumber, @ITemID, @TaxID, @TaxPer,@TaxAmt)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PODetailID = Util.GetInt(PODetailID);
            this.PONumber = Util.GetString(PONumber);
            this.ITemID = Util.GetString(ITemID);
            this.TaxID = Util.GetString(TaxID);
            this.TaxPer = Util.GetDecimal(TaxPer);
            this.TaxAmt = Util.GetDecimal(TaxAmt);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PODetailID", PODetailID),
                new MySqlParameter("@PONumber", PONumber),
                new MySqlParameter("@ITemID", ITemID),
                new MySqlParameter("@TaxID", TaxID),
                new MySqlParameter("@TaxPer", TaxPer),
                new MySqlParameter("@TaxAmt", TaxAmt));

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iPkValue;
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