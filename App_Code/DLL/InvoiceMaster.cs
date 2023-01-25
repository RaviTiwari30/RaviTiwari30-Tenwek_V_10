using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class InvoiceMaster
{
    #region All Memory Variables
    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _Hospital_ID;
    private string _InvoiceNo;
    private string _ChalanNo;
    private DateTime _InvoiceDate;
    private string _IsCompleteInvoice;
    private DateTime _ChalanDate;
    private string _PONumber;
    private DateTime _PODate;
    private string _VenLedgerNo;
    private string _LedgerTnxNo;
    private decimal _DiffBillAmt;
    //Challan Work
    private string _WayBillNo;
    private DateTime _WayBillDate;
    private string _ReferenceNo;
    private decimal _GrossAmount;
    private decimal _DiscountOnTotal;
    private string _DeptLedgerNo;
    private int _CentreID;
    private decimal _Freight;
    private decimal _Octori;
    private decimal _OtherCharges;
    private string _GatePassInWard;
    private decimal _RoundOff;
    private int _PaymentModeID;
    //
    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    public InvoiceMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }
    public InvoiceMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #region Set All Property

    public virtual decimal DiffBillAmt
    {
        get
        {
            return _DiffBillAmt;
        }
        set
        {
            _DiffBillAmt = value;
        }
    }
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

    public virtual string Hospital_ID
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
    public virtual string InvoiceNo
    {
        get
        {
            return _InvoiceNo;
        }
        set
        {
            _InvoiceNo = value;
        }
    }
    public virtual string ChalanNo
    {
        get
        {
            return _ChalanNo;
        }
        set
        {
            _ChalanNo = value;
        }
    }
    public virtual DateTime InvoiceDate
    {
        get
        {
            return _InvoiceDate;
        }
        set
        {
            _InvoiceDate = value;
        }
    }

    public virtual string IsCompleteInvoice
    {
        get
        {
            return _IsCompleteInvoice;
        }
        set
        {
            _IsCompleteInvoice = value;
        }
    }

    public virtual DateTime ChalanDate
    {
        get
        {
            return _ChalanDate;
        }
        set
        {
            _ChalanDate = value;
        }
    }
    public virtual string PONumber
    {
        get
        {
            return _PONumber;
        }
        set
        {
            _PONumber = value;
        }
    }
    public virtual DateTime PODate
    {
        get
        {
            return _PODate;
        }
        set
        {
            _PODate = value;
        }
    }
    public virtual string VenLedgerNo
    {
        get
        {
            return _VenLedgerNo;
        }
        set
        {
            _VenLedgerNo = value;
        }
    }   

    public string LedgerTnxNo
    {
        get { return _LedgerTnxNo; }
        set { _LedgerTnxNo = value; }
    }
    private decimal _InvoiceAmount;

    public decimal InvoiceAmount
    {
        get { return _InvoiceAmount; }
        set { _InvoiceAmount = value; }
    }
    //Challan Work
    public string WayBillNo
    {
        get { return _WayBillNo; }
        set { _WayBillNo = value; }
    }
    public DateTime WayBillDate
    {
        get { return _WayBillDate; }
        set { _WayBillDate = value; }
    }
    public string ReferenceNo { get { return _ReferenceNo; } set { _ReferenceNo = value; } }
    public decimal GrossAmount { get { return _GrossAmount; } set { _GrossAmount = value; } }
    public decimal DiscountOnTotal { get { return _DiscountOnTotal; } set { _DiscountOnTotal = value; } }
    public string DeptLedgerNo { get { return _DeptLedgerNo; } set { _DeptLedgerNo = value; } }
    public int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public decimal Freight { get { return _Freight; } set { _Freight = value; } }
    public decimal Octori { get { return _Octori; } set { _Octori = value; } }
    public decimal OtherCharges { get { return _OtherCharges; } set { _OtherCharges = value; } }
    public string GatePassInWard { get { return _GatePassInWard; } set { _GatePassInWard = value; } }
    public decimal RoundOff { get { return _RoundOff; } set { _RoundOff = value; } }
    public int PaymentModeID { get { return _PaymentModeID; } set { _PaymentModeID = value; } }

    //
    #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {
            
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_invoicemaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter RefNo = new MySqlParameter();
            RefNo.ParameterName = "@RefNo";

            RefNo.MySqlDbType = MySqlDbType.VarChar;
            RefNo.Size = 50;
            RefNo.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            
            this.InvoiceNo = Util.GetString(InvoiceNo);
            this.ChalanNo = Util.GetString(ChalanNo);
            this.InvoiceDate = Util.GetDateTime(InvoiceDate);

            this.IsCompleteInvoice = Util.GetString(IsCompleteInvoice);
            this.ChalanDate = Util.GetDateTime(ChalanDate);
            this.PONumber = Util.GetString(PONumber);
            this.PODate = Util.GetDateTime(PODate);
            this.VenLedgerNo = Util.GetString(VenLedgerNo);
            this.LedgerTnxNo = Util.GetString(LedgerTnxNo);
            this.InvoiceAmount = Util.GetDecimal(InvoiceAmount);
            this.DiffBillAmt = Util.GetDecimal(DiffBillAmt);
            //Challan Work
            this.WayBillNo = Util.GetString(WayBillNo);
            this.WayBillDate = Util.GetDateTime(WayBillDate);
            this.ReferenceNo = Util.GetString(ReferenceNo);
            this.GrossAmount = Util.GetDecimal(GrossAmount);
            this.DiscountOnTotal = Util.GetDecimal(DiscountOnTotal);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.CentreID = Util.GetInt(CentreID);
            this.Freight = Util.GetDecimal(Freight);
            this.Octori = Util.GetDecimal(Octori);
            this.OtherCharges = Util.GetDecimal(OtherCharges);
            this.GatePassInWard = Util.GetString(GatePassInWard);
            this.RoundOff = Util.GetDecimal(RoundOff);
            this.PaymentModeID = Util.GetInt(PaymentModeID);

            cmd.Parameters.Add(new MySqlParameter("@InvoiceNo", InvoiceNo));
            cmd.Parameters.Add(new MySqlParameter("@ChalanNo", ChalanNo));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceDate", InvoiceDate));
            cmd.Parameters.Add(new MySqlParameter("@IsCompleteInvoice", IsCompleteInvoice));
            cmd.Parameters.Add(new MySqlParameter("@ChalanDate", ChalanDate));
            cmd.Parameters.Add(new MySqlParameter("@PONumber", PONumber));
            cmd.Parameters.Add(new MySqlParameter("@PODate", PODate));
            cmd.Parameters.Add(new MySqlParameter("@VenLedgerNo", VenLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTnxNo", LedgerTnxNo));
            cmd.Parameters.Add(new MySqlParameter("@InvAmount", InvoiceAmount));
            cmd.Parameters.Add(new MySqlParameter("@DiffBillAmt", DiffBillAmt));
            //Challan Work
            cmd.Parameters.Add(new MySqlParameter("@WayBillNo", WayBillNo));
            cmd.Parameters.Add(new MySqlParameter("@WayBillDate",WayBillDate));
            //
            cmd.Parameters.Add(new MySqlParameter("@vReferenceNo", ReferenceNo));
            cmd.Parameters.Add(new MySqlParameter("@vGrossAmount", GrossAmount));
            cmd.Parameters.Add(new MySqlParameter("@vDiscountOnTotal", DiscountOnTotal));
            cmd.Parameters.Add(new MySqlParameter("@vDeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vFreight", Freight));
            cmd.Parameters.Add(new MySqlParameter("@vOctori", Octori));
            cmd.Parameters.Add(new MySqlParameter("@vOtherCharges", OtherCharges));
            cmd.Parameters.Add(new MySqlParameter("@vGatePassInWard", GatePassInWard));
            cmd.Parameters.Add(new MySqlParameter("@vRoundOff", RoundOff));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", PaymentModeID));
            cmd.Parameters.Add(RefNo);

            string ID = cmd.ExecuteNonQuery().ToString();
            return ID;
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
    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_invoicemaster SET Hospital_Id=?,ChalanNo=?,InvoiceIssueDate=?,InvoiceRecieptDate=?,IsCompleteInvoice=?,ChalanIssueDate=?,ChalanReceiptDate=? WHERE InvoiceNo = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.ChalanNo = Util.GetString(ChalanNo);
            this.InvoiceDate = Util.GetDateTime(InvoiceDate);

            this.IsCompleteInvoice = Util.GetString(IsCompleteInvoice);
            this.ChalanDate = Util.GetDateTime(ChalanDate);

            this.InvoiceNo = Util.GetString(InvoiceNo);


            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@ChalanNo", ChalanNo),
                new MySqlParameter("@InvoiceDate", InvoiceDate),

                new MySqlParameter("@IsCompleteInvoice", IsCompleteInvoice),
                new MySqlParameter("@ChalanDate", ChalanDate),

                new MySqlParameter("@InvoiceNo", InvoiceNo));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }

    }
    public int Delete(int iPkValue)
    {
        this.InvoiceNo = iPkValue.ToString();
        return this.Delete();
    }
    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_invoicemaster WHERE InvoiceNo = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("InvoiceNo", InvoiceNo));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
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
    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM f_invoicemaster WHERE InvoiceNo = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@InvoiceNo", InvoiceNo)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);
            string sParams = "InvoiceNo=" + this.InvoiceNo.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }
    public bool Load(int iPkValue)
    {
        this.InvoiceNo = iPkValue.ToString();
        return this.Load();
    }
    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {

        //Location,Hospcode,ID,LedgerTnxNo,Hospital_ID,TaxID,Percentage,IsOnTotal
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.InvoiceMaster.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.InvoiceMaster.HospCode]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.InvoiceMaster.Hospital_Id]);
        this.InvoiceDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.InvoiceMaster.InvoiceDate]);
        //this.InvoiceRecieptDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.InvoiceMaster.InvoiceRecieptDate]);
        this.IsCompleteInvoice = Util.GetString(dtTemp.Rows[0][AllTables.InvoiceMaster.IsCompleteInvoice]);
        this.ChalanDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.InvoiceMaster.ChalanDate]);
        //this.ChalanReceiptDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.InvoiceMaster.ChalanReceiptDate]);
        this.InvoiceNo = Util.GetString(dtTemp.Rows[0][AllTables.InvoiceMaster.InvoiceNo]);

    }
    #endregion

}
