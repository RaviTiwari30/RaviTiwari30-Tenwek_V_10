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
/// Summary description for Process_Master
/// </summary>
public class ProcessMaster
{
	#region All Memory Variables

    private int _ProcessID;
    private string _Process;
    private int _IsActive;
    private string _CreatedBy;
    private string _UpdatedBy;
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public ProcessMaster()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public ProcessMaster(MySqlTransaction objTrans)
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
    public virtual string Process
    {
        get
        {
            return _Process;
        }
        set
        {
            _Process = value;
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
    
    



     #endregion
    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.ProcessID = Util.GetInt(dtTemp.Rows[0][AllTables.Process_Master.ProcessID]);
        this.Process = Util.GetString(dtTemp.Rows[0][AllTables.Process_Master.Process]);
        this.IsActive = Util.GetInt(dtTemp.Rows[0][AllTables.Process_Master.IsActive]);
        this.CreatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Process_Master.CreatedBy]);
        this.UpdatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Process_Master.UpdatedBy]);
    }
 #endregion
}
