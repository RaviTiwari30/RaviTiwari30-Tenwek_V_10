#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Surgery_Description
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _SurgeryDescID;
    private string _SurgeryTransactionID;
    private string _TransactionID;
    private string _PatientID;
    private string _LedgerTransactionNo;
    private string _BillNo;
    private string _ItemID;
    private decimal _Rate;
    private decimal _Discount;
    private decimal _Amount;
    private string _Surgery_ID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Surgery_Description()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Surgery_Description(MySqlTransaction objTrans)
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

    public virtual int SurgeryDescID
    {
        get
        {
            return _SurgeryDescID;
        }
        set
        {
            _SurgeryDescID = value;
        }
    }

    public virtual string SurgeryTransactionID
    {
        get
        {
            return _SurgeryTransactionID;
        }
        set
        {
            _SurgeryTransactionID = value;
        }
    }

    public virtual string TransactionID
    {
        get
        {
            return _TransactionID;
        }
        set
        {
            _TransactionID = value;
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

    public virtual string LedgerTransactionNo
    {
        get
        {
            return _LedgerTransactionNo;
        }
        set
        {
            _LedgerTransactionNo = value;
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

    public virtual decimal Rate
    {
        get
        {
            return _Rate;
        }
        set
        {
            _Rate = value;
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

    public virtual decimal Amount
    {
        get
        {
            return _Amount;
        }
        set
        {
            _Amount = value;
        }
    }

    public virtual string Surgery_ID
    {
        get
        {
            return _Surgery_ID;
        }
        set
        {
            _Surgery_ID = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("Insert_surgery_discription");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            MySqlParameter LedTxnID = new MySqlParameter();
            LedTxnID.ParameterName = "@SurgeryTransactionID";

            LedTxnID.MySqlDbType = MySqlDbType.VarChar;
            LedTxnID.Size = 50;
            LedTxnID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.TransactionID = Util.GetString(TransactionID);
            this.PatientID = Util.GetString(PatientID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.BillNo = Util.GetString(BillNo);
            this.ItemID = Util.GetString(ItemID);
            this.Rate = Util.GetDecimal(Rate);
            this.Discount = Util.GetDecimal(Discount);
            this.Amount = Util.GetDecimal(Amount);
            this.Surgery_ID = Util.GetString(Surgery_ID);

            cmd.Parameters.Add(new MySqlParameter("@Loc", AllGlobalFunction.Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", AllGlobalFunction.HospCode));
            cmd.Parameters.Add(new MySqlParameter("@TransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@BillNo", BillNo));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@Discount", Discount));
            cmd.Parameters.Add(new MySqlParameter("@Amount", Amount));
            cmd.Parameters.Add(new MySqlParameter("@SurgeryID", Surgery_ID));

            cmd.Parameters.Add(LedTxnID);

            //cmd.ExecuteNonQuery();

            SurgeryTransactionID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return SurgeryTransactionID.ToString();
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

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.HospCode]);
        this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.TransactionID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.PatientID]);
        this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.LedgerTransactionNo]);
        this.BillNo = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.BillNo]);
        this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.ItemID]);
        this.Rate = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Description.Rate]);
        this.Discount = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Description.Discount]);
        this.Amount = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Description.Amount]);
        this.Surgery_ID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Description.Surgery_ID]);
    }

    #endregion Helper Private Function
}