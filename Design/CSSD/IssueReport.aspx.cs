using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_CSSD_IssueReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtIssuedatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtIssuedateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            caldatefrom.EndDate = DateTime.Now;
            caldateTo.EndDate = DateTime.Now;
        }
        txtIssuedatefrom.Attributes.Add("readOnly", "true");
        txtIssuedateTo.Attributes.Add("readOnly", "true");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();

        dt = SearchSetItem();

        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            if (rblReportType.SelectedValue == "1")
            {
                Session["ReportName"] = "Issue Report Set Wise";
            }
            else
            {
                Session["ReportName"] = "Issue Report CSSD To OR";
            }
            Session["Period"] = "From " + Util.GetDateTime(txtIssuedatefrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtIssuedateTo.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);

            return;
        }

    }
    private DataTable SearchSetItem()
    {
        DataTable dt1 = new DataTable();
        StringBuilder sb = new StringBuilder();
        if (rblReportType.SelectedValue == "1")
        {

            sb.Append(" SELECT SetID 'Set ID',SetName 'Set Name',COUNT(*)'No. of Set' FROM ( select SetID,SetName from cssd_f_batch_tnxdetails");
            sb.Append(" where isSet=1 and IsProcess=3 AND DATE(ReturnDateTime)>='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append(" AND DATE(ReturnDateTime)<='" + Util.GetDateTime(txtIssuedateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY SetstockID)t GROUP BY SetID Order By SetID+0");

            dt1 = StockReports.GetDataTable(sb.ToString());

            return dt1;

        }
        else
        {
            sb.Append("  SELECT  sd.salesno 'Issue No.',DATE_FORMAT(sd.Date,'%d-%b-%y')'Issue Date',st.ItemName 'Item Name', sd.SoldUnits 'Qty.',st.BatchNumber 'Batch No.', ");
            sb.Append(" (SELECT NAME FROM employee_master WHERE employee_ID=sd.userID)'Issue By' ");
            sb.Append(" FROM f_salesdetails sd INNER JOIN f_stock st  ");
            sb.Append(" ON st.StockID = sd.StockID        ");
            sb.Append("   WHERE sd.TrasactionTypeID=1 AND sd.DeptLedgerNo='LSHHI116' ");
            sb.Append("   AND sd.LedgerNumber='LSHHI114' AND sd.LedgerTransactionNo=''   ");
            sb.Append("  AND DATE(sd.Date)>='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "'");
            sb.Append(" AND DATE(sd.Date)<='" + Util.GetDateTime(txtIssuedateTo.Text).ToString("yyyy-MM-dd") + "' ORDER BY sd.salesno");

           
            dt1 = StockReports.GetDataTable(sb.ToString());
            return dt1;
        }


    }
}