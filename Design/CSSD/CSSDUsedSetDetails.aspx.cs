using System;
using System.Data;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;

public partial class Design_CSSD_CSSDUsedSetDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindDepartments();
            calFrom.EndDate = DateTime.Now;
            calTo.EndDate = DateTime.Now;
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
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue(Session["DeptLedgerNo"].ToString()));
            ddlDept.Enabled = false;

        }
        else
        {
            ddlDept.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }
    }
    [WebMethod(EnableSession = true)]
    public static string Search(string UsedDeptLedgerNo, string SetId, string UsedUHID, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT rm.`RoleName` 'UsedDepartment',req.`requestId`,DATE_FORMAT(req.`createdDateTime`,'%d-%b-%Y %h:%i %p')'RequestedOn', ");
        sb.Append("  sm.`Name` 'SetName',im.`TypeName`'ItemName', ");
        sb.Append("  IFNULL(req.`usedAgainstUHID`,'')'UsedUHID',IFNULL(CONCAT(pm.`Title`,' ',pm.`PName`),'')'UsedPatientName', ");
        sb.Append("  IFNULL(REPLACE(req.`usedAgainstTID`,'ISHHI',''),'')'UsedIPDNo',CONCAT(em.`Title`,' ',em.`Name`)'UsedUpdatedBy', ");
        sb.Append("  IFNULL(DATE_FORMAT(req.`usedUpdatedOn`,'%d-%b-%Y %h:%i %p'),'')'UsedUpdatedOn' ");
        sb.Append("  FROM cssd_requisition req  ");
        sb.Append("  INNER JOIN `f_rolemaster` rm ON rm.`DeptLedgerNo`=req.`fromDept` ");
        sb.Append("  INNER JOIN f_itemmaster im ON im.`ItemID`=req.`itemId` AND req.`isUsed`=1 ");
        sb.Append("  INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=req.`setId` ");
        sb.Append("  LEFT JOIN `patient_master` pm ON pm.`PatientID`=req.`usedAgainstUHID` ");
        sb.Append("  INNER JOIN `employee_master` em ON em.`EmployeeID`=req.`usedUpdatedBy` ");
        sb.Append("  WHERE req.`usedUpdatedOn`>=@fromDate AND req.`usedUpdatedOn`<=@toDate ");
        if (UsedDeptLedgerNo != "0")
            sb.Append(" AND req.`fromDept`=@deptLedgerNo ");
        if (!String.IsNullOrEmpty(UsedUHID))
            sb.Append(" AND req.`usedAgainstUHID`=@uhid ");
        if (SetId != "0")
            sb.Append(" AND req.`setId`=@setId ");
        ExcuteCMD cmd = new ExcuteCMD();
        DataTable dt = cmd.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            fromDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00",
            toDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59",
            deptLedgerNo = UsedDeptLedgerNo,
            uhid = UsedUHID,
            setId = SetId
        });
        if (dt.Rows.Count > 0)
        {
           HttpContext.Current.Session["dtExport2Excel"] = dt;
           HttpContext.Current.Session["ReportName"] = "Used Set Details Report";
           HttpContext.Current.Session["Period"] = "From Date : " + FromDate + " To :" + ToDate;
          return "1";
        }
        else
            return "";

    }
}