using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class DailyCollectionSettlement
{
	public DailyCollectionSettlement()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}

    public DailyCollectionSettlement(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private Int64 _BatchNumber;
    private string _Remarks;
    private int _Settled;
    private decimal _Amount;
    private decimal _OutstandingAmount;
    private decimal _ReceivedAmount;
    private decimal _CashAmount;
    #endregion

    #region Set All Property
    public virtual Int64 BatchNumber { get { return _BatchNumber; } set { _BatchNumber = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual int Settled { get { return _Settled; } set { _Settled = value; } }
    public virtual decimal Amount { get { return _Amount; } set { _Amount = value; } }
    public virtual decimal ReceivedAmount { get { return _ReceivedAmount; } set { _ReceivedAmount = value; } }
    public virtual decimal OutstandingAmount { get { return _OutstandingAmount; } set { _OutstandingAmount = value; } }
    public virtual decimal CashAmount { get { return _CashAmount; } set { _CashAmount=value; } }
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
}