using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_VenderReturnReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT cm.CentreName, Stockid 'Stock ID',bsm.ComponentName 'Component Name',bv.BBTubeNo 'Batch No',bsm.bagType 'Bag Type',DATE_FORMAT(bv.EntryDate,'%d-%b-%Y')'Return Date' ");
        sb.Append("  FROM  bb_venderreturn bv INNER JOIN  ");
        sb.Append(" bb_stock_master bsm ON bv.Stockid=bsm.Stock_id INNER JOIN center_master cm ON bv.CentreID=cm.CentreID  WHERE bsm.isvenderReturn=1 and bv.CentreID in (" + Centre + ") ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["ReportName"] = "Vender Return Report";
            Session["dtExport2Excel"] = dt;
            Session["Period"] = "Period From " + Util.GetDateTime(txtReturndatefrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtReturndateTo.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtReturndatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtReturndateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BloodBank.bindComponent(ddlComponentName);
            ddlComponentName.Items.Insert(0, new ListItem("Select"));
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
        }
        txtReturndatefrom.Attributes.Add("readOnly", "true");
        txtReturndateTo.Attributes.Add("readOnly", "true");
    }
}