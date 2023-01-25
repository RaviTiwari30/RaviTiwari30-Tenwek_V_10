using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_IPDCreditLimitReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT * FROM (  ");
        sb.Append(" SELECT pm.Pname,pm.PatientID,REPLACE(adj.TransactionID,'ISHHI','')IPDNo, BillAmt,IFNULL((BillAmt-IFNULL(DiscountOnBill,0)),0)NetAmt, ");
        sb.Append(" adj.CreditLimitPanel,adj.CreditLimitType,IFNULL(DiscountOnBill,0)DiscountOnBill,ich.Status,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit FROM ( ");
        sb.Append("    SELECT SUM(IFNULL(amount,0))BillAmt,TransactionID FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  AND TYPE='I' GROUP BY TransactionID  ");
        sb.Append(" )t INNER JOIN f_ipdadjustment adj ON adj.TransactionID=t.TransactionID ");
        sb.Append("    INNER JOIN ipd_case_history ich ON ich.TransactionID=adj.TransactionID  INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID ");
        sb.Append("    WHERE adj.PanelID=1 AND adj.CreditLimitType='A' AND ich.Status<>'Cancel' ");
        if (txtFromDate.Text != "")
            sb.Append("  AND date(ich.DateOfAdmit)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' ");
        if (txtToDate.Text != "")
            sb.Append(" AND date(ich.DateOfAdmit)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' ");

        sb.Append(" AND adj.CentreID IN (" + Centre + ") )t1 WHERE t1.NetAmt>t1.CreditLimitPanel AND CreditLimitPanel>0 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            // ds.WriteXmlSchema("E:\\IPDCreditLimtReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IPDCreditLimtReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
            lblMsg.Text = "";
    }
}