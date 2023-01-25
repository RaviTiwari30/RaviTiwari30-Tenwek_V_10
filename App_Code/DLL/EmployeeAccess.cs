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
public class EmployeeAccess
{
	#region All Memory Variables
    private int _CenterID;
    private int _RoleID;
    private bool _Status;
    private string _Employee_ID;
    private string _UserName;
    private string _Password;
    private string _IsUpdateLogin;
    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    #endregion
    #region Overloaded Constructor
    public EmployeeAccess()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public EmployeeAccess(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    public virtual int CenterID
    {
        get
        {
            return _CenterID;
        }
        set
        {
            _CenterID = value;
        }
    }
    public virtual int RoleID
    {
        get
        {
            return _RoleID;
        }
        set
        {
            _RoleID = value;
        }
    }
    public virtual bool Status
    {
        get
        {
            return _Status;
        }
        set
        {
            _Status = value;
        }
    }
    public virtual string EmployeeID
    {
        get
        {
            return _Employee_ID;
        }
        set
        {
            _Employee_ID = value;
        }
    }
    public virtual string UserName
    {
        get
        {
            return _UserName;
        }
        set
        {
            _UserName = value;
        }
    }
    public virtual string Password
    {
        get
        {
            return _Password;
        }
        set
        {
            _Password = value;
        }
    }

    public virtual string IsUpdateLogin
    {
        get
        {
            return _IsUpdateLogin;
        }
        set
        {
            _IsUpdateLogin = value;
        }
    }

    #endregion
 
}
