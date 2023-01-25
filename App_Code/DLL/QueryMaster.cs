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
/// Summary description for QueryMaster
/// </summary>
public class QueryMaster
{
		#region All Memory Variables

    private int _QueryID;
    private string _Query;
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
    public QueryMaster()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public QueryMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property
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
    public virtual string Query
    {
        get
        {
            return _Query;
        }
        set
        {
            _Query = value;
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
        this.QueryID = Util.GetInt(dtTemp.Rows[0][AllTables.Query_Master.QueryID]);
        this.Query = Util.GetString(dtTemp.Rows[0][AllTables.Query_Master.Query]);
        this.IsActive = Util.GetInt(dtTemp.Rows[0][AllTables.Query_Master.IsActive]);
        this.CreatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Query_Master.CreatedBy]);
        this.UpdatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Query_Master.UpdatedBy]);
    }
 #endregion
}
