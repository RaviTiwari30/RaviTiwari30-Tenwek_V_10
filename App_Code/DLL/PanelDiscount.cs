using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Patient_Complains
/// </summary>
public class PanelDiscount
{
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public PanelDiscount()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public PanelDiscount(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Properties
    private int _PanelID;

    public int PanelID
    {
        get { return _PanelID; }
        set { _PanelID = value; }
    }
    private string _Panel;

    public string Panel
    {
        get { return _Panel; }
        set { _Panel = value; }
    }
    private string _SubCategoryID;

    public string SubCategoryID
    {
        get { return _SubCategoryID; }
        set { _SubCategoryID = value; }
    }
    private string _SubGroup;

    public string SubGroup
    {
        get { return _SubGroup; }
        set { _SubGroup = value; }
    }

    private string _OPDDiscount;

    public string OPDDiscount
    {
        get { return _OPDDiscount; }
        set { _OPDDiscount = value; }
    }

    private string _IPDDiscount;

    public string IPDDiscount
    {
        get { return _IPDDiscount; }
        set { _IPDDiscount = value; }
    }
  
    
    #endregion

  
}
