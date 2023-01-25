#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Surgery_Doctor
{
    #region All Memory Variables

    private string _SurgeryTransactionID;
    private string _DoctorID;
    private decimal _Percentage;
    private decimal _Discount;
    private decimal _Amount;
    private string _ItemID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Surgery_Doctor()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Surgery_Doctor(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    public virtual string DoctorID
    {
        get
        {
            return _DoctorID;
        }
        set
        {
            _DoctorID = value;
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

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_surgery_doctor(SurgeryTransactionID,DoctorID,Percentage,Amount,Discount,ItemID )");
            objSQL.Append("VALUES (@SurgeryTransactionID, @DoctorID,@Percentage, @Amount, @Discount,@ItemID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.SurgeryTransactionID = Util.GetString(SurgeryTransactionID);
            this.DoctorID = Util.GetString(DoctorID);
            this.Percentage = Util.GetDecimal(Percentage);
            this.Amount = Util.GetDecimal(Amount);
            this.Discount = Util.GetDecimal(Discount);
            this.ItemID = Util.GetString(ItemID);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@SurgeryTransactionID", SurgeryTransactionID),
                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@Percentage", Percentage),
                new MySqlParameter("@Amount", Amount),
                new MySqlParameter("@Discount", Discount),
                new MySqlParameter("@ItemID", ItemID));

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select max(SurgeryDoctorID) from f_surgery_doctor"));

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
            throw (ex);
        }
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.SurgeryTransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Doctor.SurgeryTransactionID]);
        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Doctor.DoctorID]);
        this.Percentage = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Doctor.Percentage]);
        this.Discount = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Doctor.Discount]);
        this.Amount = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Doctor.Amount]);
        this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Doctor.ItemID]);
    }

    #endregion Helper Private Function
}