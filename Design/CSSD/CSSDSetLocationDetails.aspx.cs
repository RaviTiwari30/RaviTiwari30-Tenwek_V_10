using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_CSSD_CSSDSetLocationDetails : System.Web.UI.Page
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
            ddlDept.Items.Insert(0, new ListItem("All", "0"));

        }
        else
        {
            ddlDept.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }


    }
    [WebMethod]
    public static string getReport(string setId, string deptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.Department 'Location',t.SetName FROM ( ");
        sb.Append(" SELECT lm.`LedgerName` 'Department',IFNULL(cst.`SetName`,'')'SetName',cst.`SetStockID`,cst.`SetID` ");
        sb.Append(" FROM f_stock st  ");
        sb.Append(" INNER JOIN `cssd_recieve_set_stock` cst ON cst.`StockID`=st.`StockID` AND cst.`IsReturned`=0 AND st.`SetID`=0 ");
        if (setId != "0")
            sb.Append(" AND cst.`SetID`='" + setId + "' ");
        sb.Append(" INNER JOIN `f_ledgermaster` lm ON lm.`LedgerNumber`=st.`DeptLedgerNo` ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`)>0 ");
        if (deptLedgerNo != "0")
            sb.Append(" and st.`DeptLedgerNo`='" + deptLedgerNo + "'  ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT lm.`LedgerName` 'Department',IFNULL(sm.`Name`,'')'SetName',st.`SetStockID`,st.`SetID` ");
        sb.Append(" FROM f_stock st  ");
        sb.Append(" INNER JOIN `cssd_f_set_master` sm ON sm.`Set_ID`=st.`SetID` ");
        if (setId != "0")
            sb.Append(" And st.`SetID`='" + setId + "' ");
        sb.Append(" INNER JOIN `f_ledgermaster` lm ON lm.`LedgerNumber`=st.`DeptLedgerNo` ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`)>0  ");
        if (deptLedgerNo != "0")
            sb.Append(" AND st.`DeptLedgerNo`='" + deptLedgerNo + "'  ");
        sb.Append(" )t GROUP BY t.SetID,t.SetStockID ORDER BY t.Department,t.SetName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "CSSD Set Location Details As On :" + DateTime.Now.ToString("dd-MMM-yyyy HH:mm tt");
            return "1";
        }
        else
            return "";
        
    }
}