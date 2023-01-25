using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for laundry_stock_Detail
/// </summary>
public class laundry_stock_Detail
{
	 #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    
    #region Overloaded Constructor
    public laundry_stock_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public laundry_stock_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion


    #region Properties
    private int _ProcessID;

    public int ProcessID
    {
        get { return _ProcessID; }
        set { _ProcessID = value; }
    }

    private int _StockID;

    public int StockID
    {
        get { return _StockID; }
        set { _StockID = value; }
    }

    private decimal _ReturnQty;

    public decimal ReturnQty
    {
        get { return _ReturnQty; }
        set { _ReturnQty = value; }
    }



    private string _MachineName;

    public string MachineName
    {
        get { return _MachineName; }
        set { _MachineName = value; }
    }


    private int _MachineID;

    public int MachineID
    {
        get { return _MachineID; }
        set { _MachineID = value; }
    }

    private DateTime _StartDate;

    public DateTime StartDate
    {
        get { return _StartDate; }
        set { _StartDate = value; }
    }

    private DateTime _EndDate;

    public DateTime EndDate
    {
        get { return _EndDate; }
        set { _EndDate = value; }
    }

    private string _Remark;

    public string Remark
    {
        get { return _Remark; }
        set { _Remark = value; }
    }


    private string _CreatedBy;

    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }
    

    private string _ItemID;

    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }
    private string _ItemName;

    public string ItemName
    {
        get { return _ItemName; }
        set { _ItemName = value; }
    }
    private int _IsProcess;

    public int IsProcess
    {
        get { return _IsProcess; }
        set { _IsProcess = value; }
    }

    private string _batchType;

    public string batchType
    {
        get { return _batchType; }
        set { _batchType = value; }
    }

    private string _MethodType;

    public string MethodType
    {
        get { return _MethodType; }
        set { _MethodType = value; }
    }
    private string _DeptLedgerNo;

    public string DeptLedgerNo
    {
        get { return _DeptLedgerNo; }
        set { _DeptLedgerNo = value; }
    }
    private int _type;

    public int type
    {
        get { return _type; }
        set { _type = value; }
    }
    
    
    private int _ID;

    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }
    private string _returnID;

    public string returnID
    {
        get { return _returnID; }
        set { _returnID = value; }
    }
    private int _PostStockID;

    public int PostStockID
    {
        get { return _PostStockID; }
        set { _PostStockID = value; }
    }

    private int _IsComplete;
    public int IsComplete
    {
        get { return _IsComplete; }
        set { _IsComplete = value; }
    }
    private decimal _ActualReturnQty;
    public decimal ActualReturnQty
    {
        get { return _ActualReturnQty; }
        set { _ActualReturnQty = value; }
    }
    private int _CentreID;
    public int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }
    private int _HospCentreID;
    public int HospCentreID
    {
        get { return _HospCentreID; }
        set { _HospCentreID = value; }
    }
    private string _Hospital_ID;
     public string Hospital_ID
    {
        get { return _Hospital_ID; }
        set { _Hospital_ID = value; }
    }
    
    #endregion

    #region methods
    public string Insert()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("laundry_stock_Detail");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter param = new MySqlParameter("vSetID", MySqlDbType.Int32, 10);
            param.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.ProcessID = Util.GetInt(ProcessID);
            this.StockID = Util.GetInt(StockID);
            this.ReturnQty = Util.GetDecimal(ReturnQty);
            this.MachineName = Util.GetString(MachineName);
            this.MachineID = Util.GetInt(MachineID);
            this.StartDate = Util.GetDateTime(StartDate);
            this.EndDate = Util.GetDateTime(EndDate);
            this.Remark = Util.GetString(Remark);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.ItemID = Util.GetString(ItemID);
            this.ItemName = Util.GetString(ItemName);
            this.IsProcess = Util.GetInt(IsProcess);
            this.batchType = Util.GetString(batchType);
            this.MethodType = Util.GetString(MethodType);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);
            this.PostStockID = Util.GetInt(PostStockID);
            this.IsComplete = Util.GetInt(IsComplete);
            this.CentreID = Util.GetInt(CentreID);
            this.HospCentreID = Util.GetInt(HospCentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            cmd.Parameters.Add(new MySqlParameter("@vProcessID", ProcessID));
            cmd.Parameters.Add(new MySqlParameter("@vStockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@vReturnQty", ReturnQty));
            cmd.Parameters.Add(new MySqlParameter("@vMachineName", MachineName));
            cmd.Parameters.Add(new MySqlParameter("@vMachineID",MachineID));
            cmd.Parameters.Add(new MySqlParameter("@vStartDate", StartDate));
            cmd.Parameters.Add(new MySqlParameter("@vEndDate", EndDate));
            cmd.Parameters.Add(new MySqlParameter("@vRemark", Remark));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@vItemName", ItemName));
            cmd.Parameters.Add(new MySqlParameter("@vIsProcess", IsProcess));
            cmd.Parameters.Add(new MySqlParameter("@vbatchType", batchType));
            cmd.Parameters.Add(new MySqlParameter("@vMethodType", MethodType));
            cmd.Parameters.Add(new MySqlParameter("@vDeptLedgerNo", DeptLedgerNo));
            cmd.Parameters.Add(new MySqlParameter("@vPostStockID", PostStockID));
            cmd.Parameters.Add(new MySqlParameter("@vIsComplete", IsComplete));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));
            cmd.Parameters.Add(param);
            returnID = Util.GetString(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open)
                {
                    objTrans.Commit();
                    objCon.Close();
                }
            }
            return returnID.ToString();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                objTrans.Rollback();
                objCon.Close();
               
            }
            throw (ex);

        }

        
    }

    #endregion
}