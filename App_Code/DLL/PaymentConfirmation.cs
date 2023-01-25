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
/// Summary description for PaymentConfirmation
/// </summary>
public class PaymentConfirmation
{
    #region All Memory Variables
    private string _TPAInvNo;
    private string _IPNo;
    private string _BillNo;
    private DateTime _ChequeDate;
    private DateTime _ChequeReceiveDate;
    private decimal _ChequeAmount;
    private string _CreatedBy;
    private string _UpdatedBy;
    private string _PaymentRemark;
    private string _Type;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public PaymentConfirmation()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public PaymentConfirmation(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property

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
    public virtual DateTime ChequeDate
    {
        get
        {
            return _ChequeDate;
        }
        set
        {
            _ChequeDate = value;
        }
    }
    public virtual DateTime ChequeReceiveDate
    {
        get
        {
            return _ChequeReceiveDate;
        }
        set
        {
            _ChequeReceiveDate = value;
        }
    }
    public virtual decimal ChequeAmount
    {
        get
        {
            return _ChequeAmount;
        }
        set
        {
            _ChequeAmount = value;
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
    public virtual string PaymentRemark
    {
        get
        {
            return _PaymentRemark;
        }
        set
        {
            _PaymentRemark = value;
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
       #endregion

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.TPAInvNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.TPAInvNo]);
        this.IPNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.IPNo]);
        this.BillNo = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.BillNo]);
        this.ChequeDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Payment_Confirmation.ChequeDate]);
        this.ChequeReceiveDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Payment_Confirmation.ChequeReceiveDate]);
        this.ChequeAmount = Util.GetDecimal(dtTemp.Rows[0][AllTables.Payment_Confirmation.ChequeAmount]);
        this.CreatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.CreatedBy]);
        this.UpdatedBy = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.UpdatedBy]);
        this.PaymentRemark = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.PaymentRemark]);
        this.Type = Util.GetString(dtTemp.Rows[0][AllTables.Payment_Confirmation.Type]);
    }
    #endregion



}
