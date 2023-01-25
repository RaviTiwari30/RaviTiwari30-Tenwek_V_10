using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_EDP_LabRadItemConsumeReport : System.Web.UI.Page
{
    DataTable dt = new DataTable();
    StringBuilder sb = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindItemList();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        string Report_type = "";
        string ItemList = GetSelectedItems();
        ItemList.TrimEnd(',');
        //
        StringBuilder sb = new StringBuilder();


        sb.Append("  SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,pmh.patientID,pm.pname PatientName,ltd.itemName InvestigationName, ");
        sb.Append("  imq.TypeName ConsumeItemName,cq.cQty ConsumeQty FROM f_ledgertransaction lt  ");
        sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.Ledgertransactionno=ltd.Ledgertransactionno ");
        sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.transactionID=lt.transactionID ");
        sb.Append("  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
        sb.Append("  INNER JOIN f_itemmaster  im ON im.itemID=ltd.itemID ");
        sb.Append("  INNER JOIN f_subcategorymaster sub ON im.SubcategoryID=sub.SubCategoryID ");
        sb.Append("  INNER JOIN f_categorymaster cm ON cm.categoryID=sub.categoryid ");
        sb.Append("  INNER JOIN Patientinvestigation_Consumeitem_details cq ON cq.Ledgertransactionno =lt.Ledgertransactionno AND cq.Investigationid=im.type_id ");
        //  sb.Append("  INNER JOIN f_consumemaster cum on  cq.InvestigationID=cum.InvestigationID");
        sb.Append("  INNER JOIN f_itemmaster imq ON cq.itemid=imq.itemID ");
        sb.Append("  WHERE  lt.IScancel=0 AND Lt.Date>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
        sb.Append("  AND Lt.Date<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
        //added by neha on 15-11-19
        sb.Append(" AND imq.itemid IN ('" + ItemList + "')");
        //
        sb.Append("  AND ltd.isverified<>2 ORDER BY lt.Date ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            lblErrorMsg.Text = dt.Rows.Count + " Record(s) Found";
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = Report_type;
            Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

        }
        else
           lblErrorMsg.Text = "No Record Found";
    }


    protected void BindItemList()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT im.`ItemID`,im.`TypeName` FROM f_itemmaster im  ");
        sb.Append(" INNER JOIN Investigation_ConsumeItems_Mapping cm ON im.itemid=cm.itemid AND im.`IsActive`=1  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                ListItem item = new ListItem();
                item.Text = dt.Rows[i]["TypeName"].ToString();
                item.Value = dt.Rows[i]["ItemID"].ToString();
                chkItemList.Items.Add(item);

            }
        }
    }
    protected string GetSelectedItems()
    {
        string chkitems = "";
        foreach (ListItem item in chkItemList.Items)
        {
            if (item.Selected)
            {
                chkitems += item.Value + "','";
            }
        }
        return chkitems.ToString();
    }

}
