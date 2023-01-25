using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

/// <summary>
/// Summary description for RecoveryAction
/// </summary>
public class RecoveryAction
{
	#region All Memory Variables

    private string _TPAInvNo;
    private string _IPNo;
    private int _ProcessID;
    private int _QueryID;
    private string _BillNo;
    private DateTime _TargetDate;
    private DateTime _ExpectedDate;
    private string _CreatedBy;
    private string _UpdatedBy;
    private int _IsTPAQuery;
    private string _UserRemark;
    private int _RAID;
    private string _Type;
    private int _IsClose;

    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public RecoveryAction()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public RecoveryAction(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property
    public virtual int ProcessID
    {
        get
        {
            return _ProcessID;
        }
        set
        {
            _ProcessID = value;
        }
    }
    public virtual int QueryID
    {
        get
        {
            return _QueryID;
        }
        set
        {
            _QueryID = value;
        }
    }
    public virtual string TPAInvNo
    {
        get
        {
            return _TPAInvNo;
        }
        set
        {
            _TPAInvNo = value;
        }
    }
    public virtual string IPNo
    {
        get
        {
            return _IPNo;
        }
        set
        {
            _IPNo = value;
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
    public virtual DateTime TargetDate
    {
        get
        {
            return _TargetDate;
        }
        set
        {
            _TargetDate = value;
        }
    }
    public virtual DateTime ExpectedDate
    {
        get
        {
            return _ExpectedDate;
        }
        set
        {
            _ExpectedDate = value;
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
    public virtual string UpdatedBy
    {
        get
        {
            return _UpdatedBy;
        }
        set
        {
            _UpdatedBy = value;
        }
    }
    public virtual int IsTPAQuery
    {
        get
        {
            return _IsTPAQuery;
        }
        set
        {
            _IsTPAQuery = value;
        }
    }
    public virtual string UserRemark
    {
        get
        {
            return _UserRemark;
        }
        set
        {
            _UserRemark = value;
        }
    }
    public virtual int RAID
    {
        get
        {
            return _RAID;
        }
        set
        {
            _RAID = value;
        }
    }
    public virtual string Type
    {
        get
        {
            return _Type;
        }
        set
        {
            _Type = value;
        }
    }
    public virtual int IsClose
    {
        get
        {
            return _IsClose;
        }
        set
        {
            _IsClose = value;
        }
    }

     #endregion
    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.ProcessID = Util.GetInt(dtTemp.Rows[0][AllTables.Recovery_Action.ProcessID]);
        this.QueryID = Util.GetInt(dtTemp.Rows[0][AllTables.Recovery_Action.QueryID]);
        this.TPAInvNo = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.TPAInvNo]);
        this.IPNo = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.IPNo]);
        this.BillNo = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.BillNo]);
        this.TargetDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Recovery_Action.TargetDate]);
        this.ExpectedDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Recovery_Action.ExpectedDate]);
        this.CreatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.CreatedBy]);
        this.UpdatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.UpdatedBy]);
        this.IsTPAQuery = Util.GetInt(dtTemp.Rows[0][AllTables.Recovery_Action.IsTPAQuery]);
        this.UserRemark = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.UserRemark]);
        this.IsTPAQuery = Util.GetInt(dtTemp.Rows[0][AllTables.Recovery_Action.RAID]);
        this.Type = Util.GetString(dtTemp.Rows[0][AllTables.Recovery_Action.Type]);
        this.IsClose = Util.GetInt(dtTemp.Rows[0][AllTables.Recovery_Action.IsClose]);
    }
 #endregion
}
