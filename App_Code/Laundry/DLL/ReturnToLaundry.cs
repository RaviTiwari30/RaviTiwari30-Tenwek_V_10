using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for ReturnToLaundry
/// </summary>
public class ReturnToLaundry
{
	
    #region All Memory Variables
     
    private string _StockID;
    private string  _ItemID;
    private string  _ItemName;
    private string _BatchNo;   
    private decimal _ReturnQty;
    private string _ReturnBy;
    private string _SubCategoryID;
    private string _FromDept;
    private string _DeptLedgerNo;
    private int _TnxID;
    private string _Unit;
    private DateTime _MedExpiryDate;
    private string _FromStockID;
    private int _CentreID;
    private int _HospCentreID;
    private string _Hospital_ID;
    private string _Remark;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
   #region Overloaded Constructor
    public ReturnToLaundry()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public ReturnToLaundry(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion

  

        #region Set All Property

       

   
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

    public virtual string ItemName
    {
        get
        {
            return _ItemName;
        }
        set
        {
            _ItemName = value;
        }
    }
    public virtual string BatchNo
    {
        get
        {
            return _BatchNo;
        }
        set
        {
            _BatchNo = value;
        }
    }
    public virtual decimal ReturnQty
    {
        get
        {
            return _ReturnQty;
        }
        set
        {
            _ReturnQty = value;
        }
    }



    public virtual string ReturnBy
    {
        get
        {
            return _ReturnBy;
        }
        set
        {
            _ReturnBy = value;
        }
    }

    public virtual string SubCategoryID
    {
        get
        {
            return _SubCategoryID;
        }
        set
        {
            _SubCategoryID = value;
        }
    }

    public virtual string FromDept
    {
        get
        {
            return _FromDept;
        }
        set
        {
            _FromDept = value;
        }
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
    public virtual int TnxID
    {
        get
        {
            return _TnxID;
        }
        set
        {
            _TnxID = value;
        }
    }
    private int _ID;

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }
    public virtual string Unit
    {
        get
        {
            return _Unit;
        }
        set
        {
            _Unit = value;
        }
    }
    public virtual DateTime MedExpiryDate
    {
        get
        {
            return _MedExpiryDate;
        }
        set
        {
            _MedExpiryDate = value;
        }
    }
    public virtual string FromStockID
    {
        get
        {
            return _FromStockID;
        }
        set
        {
            _FromStockID = value;
        }
    }
    public virtual int CentreID
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
    public virtual int HospCentreID
    {
        get
        {
            return _HospCentreID;
        }
        set
        {
            _HospCentreID = value;
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
    public virtual string Remark
    {
        get
        {
            return _Remark;
        }
        set
        {
            _Remark = value;
        }
    }
     #endregion

        #region All Public Member Function
        public string Insert()
        {
            try
            {
                StringBuilder objSQL = new StringBuilder();
                objSQL.Append("Laundry_ReturnToDepartment");

                if (IsLocalConn)
                {
                    this.objCon.Open();
                    this.objTrans = this.objCon.BeginTransaction();
                }

                MySqlParameter paramTnxID = new MySqlParameter();
                paramTnxID.ParameterName = "@_ID";

                paramTnxID.MySqlDbType = MySqlDbType.VarChar;
                paramTnxID.Size = 50;
                paramTnxID.Direction = ParameterDirection.Output;
                MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
                cmd.CommandType = CommandType.StoredProcedure;

               
                this.StockID = Util.GetString(StockID);
                this.ItemID = Util.GetString(ItemID);
                this.ItemName = Util.GetString(ItemName);
                this.BatchNo = Util.GetString(BatchNo);
                this.ReturnQty = Util.GetDecimal(ReturnQty);
                this.ReturnBy = Util.GetString(ReturnBy);
                this.SubCategoryID = Util.GetString(SubCategoryID);
                this.FromDept = Util.GetString(FromDept);
                this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
                this.Unit = Util.GetString(Unit);
                this.MedExpiryDate = Util.GetDateTime(MedExpiryDate);
                this.FromStockID= Util.GetString(FromStockID);
                this.CentreID = Util.GetInt(CentreID);
                this.HospCentreID = Util.GetInt(HospCentreID);
                this.Hospital_ID = Util.GetString(Hospital_ID);
                this.Remark = Util.GetString(Remark);
                cmd.Parameters.Add(new MySqlParameter("@_StockID", StockID));
                cmd.Parameters.Add(new MySqlParameter("@_ItemID", ItemID));
                cmd.Parameters.Add(new MySqlParameter("@_ItemName", ItemName));
                cmd.Parameters.Add(new MySqlParameter("@_BatchNo", BatchNo));
                cmd.Parameters.Add(new MySqlParameter("@_ReturnQty", ReturnQty));
                cmd.Parameters.Add(new MySqlParameter("@_ReturnBy", ReturnBy));
                cmd.Parameters.Add(new MySqlParameter("@_SubCategoryID", SubCategoryID));
                cmd.Parameters.Add(new MySqlParameter("@_FromDept", FromDept));
                cmd.Parameters.Add(new MySqlParameter("@_DeptLedgerNo", DeptLedgerNo));
                cmd.Parameters.Add(new MySqlParameter("@_Unit", Unit));
                cmd.Parameters.Add(new MySqlParameter("@_MedExpiryDate", MedExpiryDate));
                cmd.Parameters.Add(new MySqlParameter("@_FromStockID", FromStockID));
                cmd.Parameters.Add(new MySqlParameter("@_CentreID", CentreID));
                cmd.Parameters.Add(new MySqlParameter("@_HospCentreID", HospCentreID));
                cmd.Parameters.Add(new MySqlParameter("@_Hospital_ID", Hospital_ID));
                cmd.Parameters.Add(new MySqlParameter("@_Remark", Remark));
                cmd.Parameters.Add(paramTnxID);

                ID = Util.GetInt(cmd.ExecuteScalar().ToString());
                
                if (IsLocalConn)
                {
                    this.objTrans.Commit();
                    this.objCon.Close();
                }

                return ID.ToString();
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