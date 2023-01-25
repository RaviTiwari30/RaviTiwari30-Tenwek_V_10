using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_IPD_IPD_Discount_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        if (rdbNormal.Checked)
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cm.`CentreID`,cm.`CentreName`,ad.PatientID,pm.Pname,REPLACE(ad.TransactionID,'ISHHI','')IPD_No,ad.BillNo,ad.BillDate,(ad.TotalBilledAmt)TotalBilledAmt,(Round(IFNULL(ad.DiscountOnBill,0),2)+(ROUND(SUM(((Rate*Quantity)*DiscountPercentage)/100),2))) Discount,ad.DiscountOnBillReason,IFNULL(ad.ApprovalBy,ltd.ApprovalBy)ApprovalBy,ad.roundoff  ");
            sb.Append("FROM f_ipdadjustment ad INNER JOIN  f_ledgertransaction LT ON ad.TransactionID = LT.TransactionID  ");
            sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID = ad.PatientID  INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append("WHERE (Ad.BillNo IS NOT NULL) AND Ad.BillNo <> '' AND  ");
            sb.Append("DATE(ad.BillDate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(ad.BillDate) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("AND IsVerified = 1 AND IsPackage = 0 AND ad.CentreID IN (" + Centre + ") ");
            sb.Append("GROUP BY ltd.TransactionID HAVING Discount>0");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();   
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "DiscountTable";
               // ds.WriteXmlSchema(@"E:\IPD_Discount.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "FreeSubsidyReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else
        {
            FreePatients(Centre);
        }
    }

    private void FreePatients( string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select * from (select CentreID, CentreName,BillNo,date_format(BillDate,'%d-%b-%y')BillDate,PatientID, ");
        sb.Append("temp1.TransactionID AS CR_NO,PatientName,Round(TotalBilledAmt,2)TotalBilledAmt,DiscountOnBillReason,");
        sb.Append("Round(BillDiscount,2)BillDiscount,Round(AdjustAmt,2)AdjustAmt,Round(ItemWiseDiscount,2)ItemWiseDiscount,");
        sb.Append("Round((BillDiscount+AdjustAmt+ItemWiseDiscount),2)TotalDiscount,ApprovalBy,DATE_FORMAT(DateOfAdmit,'%d-%b-%y')DateOfAdmit From (select distinct(adj.BillNo),adj.BillDate,adj.PatientID,cm.`CentreID`,cm.`CentreName`,adj.TransactionID,adj.DiscountOnBillReason,");
        sb.Append("Concat(pm.Title,' ',pm.PName)PatientName,adj.TotalBilledAmt,if(adj.DiscountOnBill is null,0,adj.DiscountOnBill)BillDiscount,");
        sb.Append("if(adj.AdjustmentAmt is null,0,adj.AdjustmentAmt)AdjustAmt,adj.ApprovalBy,ich.DateOfAdmit From f_ipdadjustment adj inner join patient_master pm on ");
        sb.Append("adj.PatientID = pm.PatientID   inner join ipd_case_history ich on ich.TransactionID = adj.TransactionID inner join f_ledgertransaction LT on LT.TransactionID = adj.TransactionID INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append("Where (adj.BillNo is not null) and adj.Billno <> '' and adj.centreID in (" + Centre + ") and (date(adj.BillDate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "') and (date(adj.BillDate) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'))temp1 inner join (select TransactionID,sum(((Rate*Quantity)*DiscountPercentage)/100)ItemWiseDiscount ");
        sb.Append("from f_ledgertnxdetail where IsVerified = 1 and IsPackage = 0 group by TransactionID )temp2 on temp1.TransactionID = temp2.TransactionID ");
        sb.Append(")temp3 where Round(TotalDiscount)= Round(TotalBilledAmt) order by billno ");
         DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
           // ds.WriteXmlSchema(@"d:\IDDiscount.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IPDFreeSubsidyReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
}
