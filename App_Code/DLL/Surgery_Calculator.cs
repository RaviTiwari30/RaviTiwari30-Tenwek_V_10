#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

/// <summary>
/// Summary description for Surgery_Calculator
/// </summary>
public class Surgery_Calculator
{
    #region All Memory Variables

    private string _SurgeryID;
    private string _ItemID;
    private decimal _Percentage;
    private int _IsDiscountable;

    private int _SurgeryGroupID;
    private string _CreatedBy;
    private decimal _Rate;
    private int _GroupID;
    private int _PanelID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Surgery_Calculator()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Surgery_Calculator(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string SurgeryID
    {
        get
        {
            return _SurgeryID;
        }
        set
        {
            _SurgeryID = value;
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

    public virtual int IsDiscountable
    {
        get
        {
            return _IsDiscountable;
        }
        set
        {
            _IsDiscountable = value;
        }
    }


      public virtual int SurgeryGroupID
    {
        get
        {
            return _SurgeryGroupID;
        }
        set
        {
            _SurgeryGroupID = value;
        }
    }
      public virtual int GroupID
    {
        get
        {
            return _GroupID;
        }
        set
        {
            _GroupID = value;
        }
    }
      public virtual int PanelID
    {
        get
        {
            return _PanelID;
        }
        set
        {
            _PanelID = value;
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
    

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_surgery_calculator(SurgeryID,ItemID,Percentage,IsDiscountable,SurgeryGroupID,CreatedBy,Rate,GroupID,PanelID,Updatedate_trigger )");
            objSQL.Append("VALUES (@SurgeryID, @ItemID, @Percentage, @IsDiscountable,@SurgeryGroupID,@CreatedBy,@Rate,@GroupID,@PanelID,now())");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.SurgeryID = Util.GetString(SurgeryID);
            this.ItemID = Util.GetString(ItemID);
            this.Percentage = Util.GetDecimal(Percentage);
            this.IsDiscountable = Util.GetInt(IsDiscountable);

            this.SurgeryGroupID = Util.GetInt(SurgeryGroupID);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.Rate = Util.GetDecimal(Rate);
            this.GroupID = Util.GetInt(GroupID);
            this.PanelID = Util.GetInt(PanelID);
            
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("@SurgeryID", SurgeryID),
            new MySqlParameter("@ItemID", ItemID),
            new MySqlParameter("@Percentage", Percentage),
            new MySqlParameter("@IsDiscountable", IsDiscountable),

            new MySqlParameter("@SurgeryGroupID", SurgeryGroupID),
            new MySqlParameter("@CreatedBy", CreatedBy),
            new MySqlParameter("@Rate", Rate),
            new MySqlParameter("@GroupID", GroupID),
            new MySqlParameter("@PanelID", PanelID));

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
            throw (ex);
        }
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.SurgeryID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Calculator.SurgeryID]);
        this.ItemID = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Calculator.ItemID]);
        this.Percentage = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Calculator.Percentage]);
        this.IsDiscountable = Util.GetInt(dtTemp.Rows[0][AllTables.Surgery_Calculator.IsDiscountable]);

        this.SurgeryGroupID = Util.GetInt(dtTemp.Rows[0][AllTables.Surgery_Calculator.SurgeryGroupID]);
        this.CreatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Surgery_Calculator.CreatedBy]);
        this.Rate = Util.GetDecimal(dtTemp.Rows[0][AllTables.Surgery_Calculator.Rate]);
        this.GroupID = Util.GetInt(dtTemp.Rows[0][AllTables.Surgery_Calculator.GroupID]);
        this.PanelID = Util.GetInt(dtTemp.Rows[0][AllTables.Surgery_Calculator.PanelID]);
        
    }

    #endregion Helper Private Function
}