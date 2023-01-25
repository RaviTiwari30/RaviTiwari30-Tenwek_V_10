using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_IPD_BillNotPrepared : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtTodate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtTodate.Attributes.Add("readOnly", "true");


    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {

        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(DateOfDischarge,'%d-%b-%Y')DischargeDate,TransNo IPDNo,SUM(Gross)Gross,SUM(TotalDiscAmt)Disc,");
        sb.Append(" SUM(Net)Net,PName,centreID,centreName,Company_Name,BillingRemarks FROM ( SELECT cmt.centreID,cmt.centreName,ltd.Quantity Qty,ltd.GrossAmount AS Gross,");
        sb.Append(" ltd.NetItemAmt AS Net,ltd.LedgerTransactionNo,adj.TransNo,adj.DateOfDischarge,ltd.TotalDiscAmt,adj.TransactionID,CONCAT(pm.Title,' ',pm.Pname)PName,fpm.`Company_Name`,BillingRemarks FROM");
        sb.Append("  patient_medical_history adj  ");//f_ipdadjustment  //INNER JOIN ipd_case_history ich ON ich.TransactionID=adj.TransactionID
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID inner join center_master cmt on cmt.centreID=adj.CentreID INNER JOIN f_ledgertnxdetail ltd ON   adj.TransactionID = ltd.TransactionID  ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`PanelID`=adj.panelid WHERE adj.status='OUT' AND IFNULL(adj.BillNo,'')=''  AND IsVerified=1 AND IsPackage=0 and adj.DateOfDischarge>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
        sb.Append(" AND adj.DateOfDischarge<='" + Util.GetDateTime(txtTodate.Text).ToString("yyyy-MM-dd") + "' and adj.CentreID in (" + Centre + ") )t GROUP BY t.TransactionID ORDER BY DateOfDischarge ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From Discharge Date " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To Discharge Date " + Util.GetDateTime(txtTodate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ReportName"] = "BillNotPrepared";
            Session["ds"] = ds;
           // ds.WriteXmlSchema("F:\\BillNotPrepared.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

        }
        else
            lblMsg.Text = "Record Not Found";
       
            
    }
}