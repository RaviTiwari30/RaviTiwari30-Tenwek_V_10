using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class TaxChargedList
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _LedgerTransactionNo;
    private string _Hospital_ID;
    private string _TaxID;
    private decimal _Percentage;
    private string _IsOnTotal;
    private string _ItemID;
    private string _StockID;
    private decimal _Amount;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public TaxChargedList()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public TaxChargedList(MySqlTransaction objTrans)
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

    public virtual string TaxID
    {
        get
        {
            return _TaxID;
        }
        set
        {
            _TaxID = value;
        }
    }

    public virtual decimal Percentage
    {
        get
        {
            return _Percentage;
        }
        set
        {
            _Percentage = value;
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

    public virtual string IsOnTotal
    {
        get
        {
            return _IsOnTotal;
        }
        set
        {
            _IsOnTotal = value;
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

    public virtual string StockID
    {
        get
        {
            return _StockID;
        }
        set
        {
            _StockID = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;

            StringBuilder objSQL = new StringBuilder();
            if (TaxID == "T5")
                objSQL.Append("Insert_excisetax");
            else
                objSQL.Append("Insert_taxchargedlist");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.TaxID = Util.GetString(TaxID);
            this.Percentage = Util.GetDecimal(Percentage);
            this.IsOnTotal = Util.GetString(IsOnTotal);
            this.ItemID = Util.GetString(ItemID);
            this.StockID = Util.GetString(StockID);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTnxNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@TaxID", TaxID));
            cmd.Parameters.Add(new MySqlParameter("@Percentage", Percentage));
            cmd.Parameters.Add(new MySqlParameter("@IsOnTotal", IsOnTotal));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@TaxAmt", Amount));

            iPkValue = Util.GetInt(cmd.ExecuteScalar());

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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_taxchargedlist SET Hospital_Id=?,TaxID=?,Percentage=?,IsOnTotal=? WHERE LedgerTransactionNo = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.TaxID = Util.GetString(TaxID);
            this.Percentage = Util.GetDecimal(Percentage);
            this.IsOnTotal = Util.GetString(IsOnTotal);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@TaxID", TaxID),
                new MySqlParameter("@Percentage", Percentage),
                new MySqlParameter("@IsOnTotal", IsOnTotal),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
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
        this.LedgerTransactionNo = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_taxchargedlist WHERE LedgerTransactionNo = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("LedgerTransactionNo", LedgerTransactionNo));
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
            string sSQL = "SELECT * FROM f_taxchargedlist WHERE LedgerTransactionNo = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo)).Tables[0];

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
            string sParams = "LedgerTransactionNo=" + this.LedgerTransactionNo.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.LedgerTransactionNo = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        //Location,Hospcode,ID,LedgerTnxNo,Hospital_ID,TaxID,Percentage,IsOnTotal
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.TaxChargedList.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.TaxChargedList.HospCode]);
        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.TaxChargedList.Hospital_Id]);
        this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.TaxChargedList.LedgerTransactionNo]);
        this.TaxID = Util.GetString(dtTemp.Rows[0][AllTables.TaxChargedList.TaxID]);
        this.Percentage = Util.GetDecimal(dtTemp.Rows[0][AllTables.TaxChargedList.Percentage]);
        this.IsOnTotal = Util.GetString(dtTemp.Rows[0][AllTables.TaxChargedList.IsOnTotal]);
    }

    #endregion Helper Private Function
}