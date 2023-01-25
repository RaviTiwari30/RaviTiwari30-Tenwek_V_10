using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_CSSD_ExpiredSetDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy");
            calFrom.EndDate = calTo.EndDate = DateTime.Now.AddDays(-1);
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindDepartments();
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }
    private void BindDepartments()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            ddlDept.Items.Insert(0, new ListItem("All", "0"));
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue(ViewState["DeptLedgerNo"].ToString()));
            ddlDept.Enabled = false;

        }
        else
        {
            ddlDept.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }
    }
    [WebMethod(EnableSession = true)]
    public static string Search(string DeptLedgerNo, string SetId, string boilerType, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT rm.`RoleName` 'ExpiredInDepartment',t.processType 'BatchProcessType',t.RequestId,t.BatchNo,t.BoilerName,sm.`Name` 'SetName',im.`TypeName` 'ItemName' ");
        sb.Append(" ,t.Quantity,DATE_FORMAT(t.validityDate,'%d-%b-%Y')'ExpiryDate' ,CONCAT(em.`Title`,' ',em.`Name`)'BatchProcessedBy'FROM ( ");
        sb.Append(" SELECT bt.`processType`,bt.`requestReturnId` 'RequestId',bt.`BatchNo`,bt.`BoilerName`,bt.`SetID`,bt.`ItemID`,bt.`Quantity`,bt.`UserID` ");
        sb.Append(" ,bt.`validityDate`,req.`toDept` 'DeptLedgerNo' ");
        sb.Append(" FROM cssd_f_batch_tnxdetails bt  ");
        sb.Append(" INNER JOIN cssd_requisition req ON req.`requestId`=bt.`requestReturnId` AND bt.`IsIssued`=0 AND bt.`IsProcess`=2 AND bt.`validityDate`<CURDATE() ");
        sb.Append(" WHERE bt.`validityDate`>=@fromDate AND bt.`validityDate`<=@toDate ");
        if (SetId != "0")
            sb.Append(" AND bt.`SetID`=@setId  ");
        if (boilerType != "0")
            sb.Append(" AND bt.`BoilerType`=@boilerTypeId  ");
        if (DeptLedgerNo != "0")
            sb.Append(" AND req.`toDept`=@deptLedgerNo ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT bt.`processType`,bt.`requestReturnId` 'RequestId',bt.`BatchNo`,bt.`BoilerName`,bt.`SetID`,bt.`ItemID`,btnx.`IssuedQty` 'Quantity',bt.`UserID` ");
        sb.Append(" ,bt.`validityDate`,req.`fromDept` 'DeptLedgerNo' ");
        sb.Append(" FROM cssd_f_batch_tnxdetails bt  ");
        sb.Append(" INNER JOIN cssd_batchtnx_requisition btnx ON btnx.`batchTnxId`=bt.`ID` AND bt.`IsIssued`=1 AND bt.`IsProcess`=2 AND bt.`validityDate`<CURDATE() ");
        sb.Append(" INNER JOIN cssd_requisition req ON req.`requestId`=btnx.`requisitionid` AND req.`isUsed`=0  ");
        sb.Append(" WHERE bt.`validityDate`>=@fromDate AND bt.`validityDate`<=@toDate ");
        if (SetId != "0")
            sb.Append(" AND bt.`SetID`=@setId  ");
        if (boilerType != "0")
            sb.Append(" AND bt.`BoilerType`=@boilerTypeId  ");
        if (DeptLedgerNo != "0")
            sb.Append(" AND req.`fromDept`=@deptLedgerNo ");
        sb.Append(" )t INNER JOIN `f_rolemaster` rm ON rm.`DeptLedgerNo`=t.`DeptLedgerNo` ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=t.`ItemID`  ");
        sb.Append(" INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=t.`SetID` ");
        sb.Append(" INNER JOIN `employee_master` em ON em.`EmployeeID`=t.UserID ");
        ExcuteCMD cmd = new ExcuteCMD();
        DataTable dt = cmd.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            fromdate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"),
            todate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"),
            deptLedgerNo = DeptLedgerNo,
            boilerTypeId = boilerType,
            setId = SetId
        });
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Expired Set Details Report";
            HttpContext.Current.Session["Period"] = "Expiry From Date : " + FromDate + " To :" + ToDate;
            return "1";
        }
        else
            return "";
    }
}