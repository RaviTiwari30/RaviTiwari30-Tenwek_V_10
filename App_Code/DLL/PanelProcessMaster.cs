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
/// Summary description for PanelProcessMaster
/// </summary>
public class PanelProcessMaster
{
	#region All Memory Variables

    private int _ProcessID;
    private int _PanelID;
    private int _IsActive;
    private string _CreatedBy;
    private string _UpdatedBy;
    private int _Validity;
    private int _Priority;
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public PanelProcessMaster()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public PanelProcessMaster(MySqlTransaction objTrans)
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
    public virtual int IsActive
    {
        get
        {
            return _IsActive;
        }
        set
        {
            _IsActive = value;
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

    public virtual int Validity
    {
        get
        {
            return _Validity;
        }
        set
        {
            _Validity = value;
        }
    }
    public virtual int Priority
    {
        get
        {
            return _Priority;
        }
        set
        {
            _Priority = value;
        }
    }


     #endregion
    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.ProcessID = Util.GetInt(dtTemp.Rows[0][AllTables.Panel_Process_Master.ProcessID]);
        this.PanelID = Util.GetInt(dtTemp.Rows[0][AllTables.Panel_Process_Master.PanelID]);
        this.IsActive = Util.GetInt(dtTemp.Rows[0][AllTables.Panel_Process_Master.IsActive]);
        this.CreatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Panel_Process_Master.CreatedBy]);
        this.UpdatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Panel_Process_Master.UpdatedBy]);
        this.Validity = Util.GetInt(dtTemp.Rows[0][AllTables.Panel_Process_Master.Validity]);
        this.Priority = Util.GetInt(dtTemp.Rows[0][AllTables.Panel_Process_Master.Priority]);
    }
 #endregion
}
