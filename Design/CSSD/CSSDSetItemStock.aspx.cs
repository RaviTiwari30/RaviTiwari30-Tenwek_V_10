using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_CSSD_CSSDSetItemStock : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            BindDepartments();
        }

    }
    private void BindDepartments()
    {

        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' AND LedgerNumber<>'" + ViewState["DeptLedgerNo"] + "' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue(Session["DeptLedgerNo"].ToString()));
            if (Session["LoginType"].ToString() != "CSSD")
                ddlDept.Enabled = false;

        }
        else
        {
            ddlDept.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }


    }

    [WebMethod(EnableSession = true)]
    public static string getReport(string deptLedgerNo, bool isOnlySet)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ( ");
        sb.Append(" SELECT lm.`LedgerName` 'Department',IF(cst.`ID` IS NULL ,'Open','Set')'IsInSet',im.`TypeName` 'ItemName',IFNULL(cst.`SetName`,'')'SetName',st.`BatchNumber`,SUM(st.`InitialCount`-st.`ReleasedCount`)'TotalStockQty' ");
        sb.Append(" ,SUM(IFNULL(cst.`ReceivedQty`,0))'SetQty',SUM((st.`InitialCount`-st.`ReleasedCount`)-IFNULL(cst.`ReceivedQty`,0))'OpenQty' ");
        sb.Append(" FROM f_stock st  ");
        if (isOnlySet)
            sb.Append(" INNER ");
        else
            sb.Append(" LEFT ");

        sb.Append(" JOIN `cssd_recieve_set_stock` cst ON cst.`StockID`=st.`StockID` AND cst.`IsReturned`=0 ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=st.`ItemID` AND im.`isCSSDItem`=1 AND st.`SetID`=0 ");
        sb.Append(" INNER JOIN `f_ledgermaster` lm ON lm.`LedgerNumber`=st.`DeptLedgerNo` ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`)>0 AND st.`DeptLedgerNo`='" + deptLedgerNo + "' GROUP BY st.`ItemID`,st.`BatchNumber`,cst.`SetStockID` ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT lm.`LedgerName` 'Department','Set' AS 'IsInSet',im.`TypeName` 'ItemName',IFNULL(sm.`Name`,'')'SetName',st.`BatchNumber` ");
        sb.Append(" ,SUM(st.`InitialCount`-st.`ReleasedCount`)'TotalStockQty',SUM(st.`InitialCount`-st.`ReleasedCount`)'SetQty',SUM(st.`InitialCount`-st.`ReleasedCount`)'OpenQty' ");
        sb.Append(" FROM f_stock st  ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=st.`ItemID` AND im.`isCSSDItem`=1  ");
        sb.Append(" INNER JOIN `cssd_f_set_master` sm ON sm.`Set_ID`=st.`SetID` ");
        sb.Append(" INNER JOIN `f_ledgermaster` lm ON lm.`LedgerNumber`=st.`DeptLedgerNo` ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`)>0 AND st.`DeptLedgerNo`='" + deptLedgerNo + "' GROUP BY st.`ItemID`,st.`BatchNumber`,st.`SetStockID` ");
        sb.Append(" )t ORDER BY t.ItemName,t.SetName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "CSSD Item Set Stock Details As On :" + DateTime.Now.ToString("dd-MMM-yyyy HH:mm tt");
            return "1";
        }
        else
            return "";
    }

}