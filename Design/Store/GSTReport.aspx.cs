using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_GSTReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            todalcal.StartDate = Convert.ToDateTime("2017-07-01");
            BindGroup();
            BindItem(ddlGroup.SelectedValue);
            BindDepartment();
        }

        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void ddlGroup_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (rbtReportType.SelectedItem.Value == "1")
        {
            BindSalesIssueData();
        }
        else if (rbtReportType.SelectedItem.Value == "2")
        {
            BindSalesReturnData();
        }
        else if (rbtReportType.SelectedItem.Value == "3")
        {
            BindPurchaseData();
        }
        else
        {
            BindPurchaseReturnData();
        }
    }
    private void BindPurchaseData()
    {
        StringBuilder sb = new StringBuilder();

        if (rblFormattype.SelectedItem.Value.ToString() == "1")
        {
            sb.Append("  SELECT T1.Date,Supplier,SupplierTin,InvoiceNo,InvoiceDate,ROUND(SUM(PayAmount),2)PayAmount, ");
            sb.Append("  ROUND(SUM(NetTotalAmtAfterDisc),2)NetTotalAmtAfterDisc,TaxPercentage AS GSTPercent,ROUND(SUM(TaxValue),2)GSTValue,");
            sb.Append("  CGSTPercent,ROUND(SUM(CGSTValue),2)CGSTValue,SGSTPercent,ROUND(SUM(SGSTValue),2)SGSTValue,IGSTPercent,ROUND(SUM(IGSTValue),2)IGSTValue,");
            sb.Append("  SUM(Quantity) Quantity,IF(TaxPercentage>0,'R','E')Category FROM (  	");
            sb.Append("  SELECT t.Quantity,t.LedgerTransactionNo,t.Supplier,");
            sb.Append("  IFNULL(t.SupplierTin,'')SupplierTin,st.InvoiceNo,");
            sb.Append("  IF(DATE(st.InvoiceDate)='0001-01-01','',DATE_FORMAT(st.InvoiceDate,'%d-%b-%y'))InvoiceDate,  	");
            sb.Append("  IFNULL(st.PurTaxPer,0)TaxPercentage,");
            sb.Append("  IF(IFNULL(st.PurTaxPer,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.PurTaxPer,0)/100),0)TaxValue,");
            sb.Append("  IFNULL(st.CGSTPercent,0)CGSTPercent,");
            sb.Append("  IF(IFNULL(st.CGSTPercent,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.CGSTPercent,0)/100),0)CGSTValue,");
            sb.Append("  IFNULL(st.SGSTPercent,0)SGSTPercent,");
            sb.Append("  IF(IFNULL(st.SGSTPercent,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.SGSTPercent,0)/100),0)SGSTValue,");
            sb.Append("  IFNULL(st.IGSTPercent,0)IGSTPercent,");
            sb.Append("  IF(IFNULL(st.IGSTPercent,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.IGSTPercent,0)/100),0)IGSTValue,");
            sb.Append("  ((t.Rate * st.InitialCount))Amount,   	(NetTotalAmtAfterDisc)NetTotalAmtAfterDisc,");
            sb.Append("  ((IFNULL((NetTotalAmtAfterDisc*IFNULL(st.PurTaxPer,0)/100),0)+NetTotalAmtAfterDisc))PayAmount,LedgerNoCr,DATE FROM (   		");
            sb.Append("  SELECT    ltd.Quantity,lt.Date,lt.LedgerTransactionNo,lt.BillNo,ltd.ItemID,ltd.Rate,lt.LedgerNoCr,ltd.Amount,  		");
            sb.Append("  (SELECT ledgerName FROM f_ledgermaster WHERE ledgernumber=lt.LedgerNoCr )Supplier,	  		");
            sb.Append("  ( SELECT TinNo FROM f_vendormaster  ven	INNER JOIN f_ledgermaster lm ON ven.vendor_ID=lm.LedgerUserID ");
            sb.Append("  WHERE lm.ledgernumber=lt.LedgerNoCr )SupplierTin,");
            sb.Append("  ltd.StockID,(ltd.Rate*ltd.Quantity)- (((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100) NetTotalAmtAfterDisc");
            sb.Append("  FROM f_ledgertransaction lt");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo");
            sb.Append("  WHERE lt.IsCancel=0 AND lt.TypeOfTnx='Purchase'          ");
            sb.Append("  AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  	");
            sb.Append("  )t");
            sb.Append("  INNER JOIN f_stock st ON t.StockID = st.StockID AND st.IsPost=1 AND st.ISFree=0");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and st.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND st.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND st.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("  )t1 GROUP BY t1.LedgerTransactionNo,t1.LedgerNoCr,t1.TaxPercentage  ");
            sb.Append("  ORDER BY   t1.Date,t1.LedgerTransactionNo,ROUND(t1.TaxPercentage,0)  ");
        }
        else if (rblFormattype.SelectedItem.Value.ToString() == "2")
        {
            sb.Append("   SELECT T1.Date,Supplier,SupplierTin,InvoiceNo,InvoiceDate,ItemID,ItemNAme,ROUND(SUM(PayAmount),2)PayAmount,  ");
            sb.Append("   ROUND(SUM(NetTotalAmtAfterDisc),2)NetTotalAmtAfterDisc,TaxPercentage AS GSTPercent,ROUND(SUM(TaxValue),2)GSTValue,  ");
            sb.Append("   CGSTPercent,ROUND(SUM(CGSTValue),2)CGSTValue,SGSTPercent,ROUND(SUM(SGSTValue),2)SGSTValue,IGSTPercent,ROUND(SUM(IGSTValue),2)IGSTValue,  ");
            sb.Append("   SUM(Quantity) Quantity,IF(TaxPercentage>0,'R','E')Category FROM (  	  ");
            sb.Append("   SELECT st.`ItemName`,st.`ItemID`,t.Quantity,t.LedgerTransactionNo,t.Supplier,  ");
            sb.Append("   IFNULL(t.SupplierTin,'')SupplierTin,st.InvoiceNo,  ");
            sb.Append("   IF(DATE(st.InvoiceDate)='0001-01-01','',DATE_FORMAT(st.InvoiceDate,'%d-%b-%y'))InvoiceDate,  	  ");
            sb.Append("   IFNULL(st.PurTaxPer,0)TaxPercentage,  ");
            sb.Append("   IF(IFNULL(st.PurTaxPer,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.PurTaxPer,0)/100),0)TaxValue,  ");
            sb.Append("   IFNULL(st.CGSTPercent,0)CGSTPercent,  ");
            sb.Append("   IF(IFNULL(st.CGSTPercent,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.CGSTPercent,0)/100),0)CGSTValue,  ");
            sb.Append("   IFNULL(st.SGSTPercent,0)SGSTPercent,  ");
            sb.Append("   IF(IFNULL(st.SGSTPercent,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.SGSTPercent,0)/100),0)SGSTValue,  ");
            sb.Append("   IFNULL(st.IGSTPercent,0)IGSTPercent,  ");
            sb.Append("   IF(IFNULL(st.IGSTPercent,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.IGSTPercent,0)/100),0)IGSTValue,  ");
            sb.Append("   ((t.Rate * st.InitialCount))Amount,   	(NetTotalAmtAfterDisc)NetTotalAmtAfterDisc,  ");
            sb.Append("   ((IFNULL((NetTotalAmtAfterDisc*IFNULL(st.PurTaxPer,0)/100),0)+NetTotalAmtAfterDisc))PayAmount,LedgerNoCr,DATE FROM (   		  ");
            sb.Append("   SELECT    ltd.Quantity,lt.Date,lt.LedgerTransactionNo,lt.BillNo,ltd.ItemID,ltd.Rate,lt.LedgerNoCr,ltd.Amount,  		  ");
            sb.Append("   (SELECT ledgerName FROM f_ledgermaster WHERE ledgernumber=lt.LedgerNoCr )Supplier,	  		  ");
            sb.Append("   ( SELECT TinNo FROM f_vendormaster  ven	INNER JOIN f_ledgermaster lm ON ven.vendor_ID=lm.LedgerUserID  ");
            sb.Append("   WHERE lm.ledgernumber=lt.LedgerNoCr )SupplierTin,  ");
            sb.Append("   ltd.StockID,(ltd.Rate*ltd.Quantity)- (((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100) NetTotalAmtAfterDisc  ");
            sb.Append("   FROM f_ledgertransaction lt  ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
            sb.Append("   WHERE lt.IsCancel=0 AND lt.TypeOfTnx='Purchase'          ");
            sb.Append("  AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  	");
            sb.Append("  )t   ");
            sb.Append("   INNER JOIN f_stock st ON t.StockID = st.StockID AND st.IsPost=1 AND st.ISFree=0  ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and st.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND st.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND st.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("   )t1 GROUP BY t1.LedgerTransactionNo,t1.LedgerNoCr,t1.ItemID,t1.TaxPercentage  ");
            sb.Append("   ORDER BY   t1.Date,t1.LedgerTransactionNo,t1.ItemID,ROUND(t1.TaxPercentage,0)  ");
        }
  
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {


            if (rblFormattype.SelectedItem.Value.ToString() == "1")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Util.GetString(ViewState["ID"])).Rows[0][0].ToString();
                dt.Columns.Add(dc);

                DataColumn dc2 = new DataColumn();
                dc2.ColumnName = "Period";
                dc2.DefaultValue = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                dt.Columns.Add(dc2);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;

                //ds.WriteXmlSchema("E://PurchaseGSTReturnReport.xml");
                Session["ReportName"] = "PurchaseGSTReturnReport";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/CommonCrystalReportViewerOld.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "2")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Purchase GST Issue Report";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);

            }
            //ekta
            //else if (rblFormattype.SelectedItem.Value.ToString() == "4")
            //{
            //    Session["dtExport2Excel"] = dt;
            //    Session["ReportName"] = "Sales Issue Report(Detail)";
            //    Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            //} 

        }
        else
        {

            lblMsg.Text = "Record Not Found";
        }
    }
    private void BindPurchaseReturnData()
    {
        StringBuilder sb = new StringBuilder();

        //sb.Append(" SELECT Supplier,SupplierTin,CommodityCode,InvoiceNo,InvoiceDate,TaxPercentage,ROUND(SUM(PayAmount),2)PayAmount,ROUND(SUM(NetTotalAmtAfterDisc),2)NetTotalAmtAfterDisc,round(SUM(TaxValue),2)TaxValue,IF(TaxPercentage>0,'R','E')Category,SUM(Quantity) Quantity FROM ( ");
        //sb.Append(" 	SELECT t.Quantity,t.LedgerTransactionNo,t.Supplier,IFNULL(t.SupplierTin,'')SupplierTin,IF(st.PurTaxPer='0.00','752',IF(st.PurTaxPer='5.00','2044',IF(st.PurTaxPer='14.50','301','')))CommodityCode,st.InvoiceNo,IF(DATE(st.InvoiceDate)='0001-01-01','',DATE_FORMAT(st.InvoiceDate,'%d-%b-%y'))InvoiceDate, ");
        //sb.Append(" 	IFNULL(st.PurTaxPer,'0')TaxPercentage,IF(IFNULL(st.PurTaxPer,0)>0,(NetTotalAmtAfterDisc*IFNULL(st.PurTaxPer,0)/100),0)TaxValue,((t.Rate * st.InitialCount))Amount,  ");
        //sb.Append(" 	(NetTotalAmtAfterDisc)NetTotalAmtAfterDisc,((IFNULL((NetTotalAmtAfterDisc*IFNULL(st.PurTaxPer,0)/100),0)+NetTotalAmtAfterDisc))PayAmount,LedgerNoCr FROM (  ");
        //sb.Append(" 		SELECT  ltd.Quantity,lt.LedgerTransactionNo,lt.BillNo,ltd.ItemID,ltd.Rate,lt.LedgerNoCr,ltd.Amount, ");
        //sb.Append(" 		(SELECT ledgerName FROM f_ledgermaster WHERE ledgernumber=lt.LedgerNoCr )Supplier,	 ");
        //sb.Append(" 		( SELECT TinNo FROM f_vendormaster  ven	INNER JOIN f_ledgermaster lm ON ven.vendor_ID=lm.LedgerUserID WHERE lm.ledgernumber=lt.LedgerNoCr )SupplierTin, ");
        //sb.Append(" 		ltd.StockID,(ltd.Rate*ltd.Quantity)- (((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100) NetTotalAmtAfterDisc   ");
        //sb.Append(" 		FROM f_ledgertransaction lt  ");
        //sb.Append(" 		INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo      ");
        //sb.Append(" 		WHERE lt.IsCancel=0 AND lt.TypeOfTnx='Vendor-Return' ");
        //sb.Append("         AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        //sb.Append("         AND DATE(lt.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        //sb.Append(" 	)t    ");
        //sb.Append("     INNER JOIN f_stock st ON t.StockID = st.StockID AND st.IsPost=1 AND ISfree=0  AND st.PurTaxPer IN('0.00','5.00','14.50') ");
        ////sb.Append(" and st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  ");
        //if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
        //    sb.Append(" and st.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

        //if (chkGroupHead.Checked)
        //    sb.Append("     AND st.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

        //if (chkItem.Checked)
        //    sb.Append("     AND st.ItemID='" + ddlItem.SelectedValue + "' ");

        //sb.Append(" )t1 GROUP BY t1.LedgerTransactionNo,t1.LedgerNoCr,t1.TaxPercentage  ORDER BY round(t1.TaxPercentage,0),t1.LedgerTransactionNo  ");


        sb.Append("      SELECT Supplier,SupplierTin,CommodityCode,InvoiceNo,InvoiceDate,TaxPercentage,ROUND(SUM(PayAmount),2)PayAmount, ");
        sb.Append("       ROUND(SUM(NetTotalAmtAfterDisc),2)NetTotalAmtAfterDisc,ROUND(SUM(TaxValue),2)TaxValue,IF(TaxPercentage>0,'R','E')Category, ");
        sb.Append(" 	SUM(Quantity) Quantity FROM  ");
        sb.Append(" 	( SELECT t.Quantity,t.LedgerTransactionNo,t.Supplier,IFNULL(t.SupplierTin,'')SupplierTin,IF(st.PurTaxPer='0.00','752',IF(st.PurTaxPer='5.00','2044',IF(st.PurTaxPer='14.50','301','')))CommodityCode, ");
        sb.Append(" 	 st.InvoiceNo,IF(DATE(st.InvoiceDate)='0001-01-01','',DATE_FORMAT(st.InvoiceDate,'%d-%b-%y'))InvoiceDate,  	 ");
        sb.Append(" 	 (IFNULL(st.CGSTPercent,0)+IFNULL(st.SGSTPercent,0)+IFNULL(st.IGSTPercent,0)) TaxPercentage, ");

        sb.Append(" 	 ROUND(IF((IFNULL(st.CGSTPercent,0)+IFNULL(st.SGSTPercent,0)+IFNULL(st.IGSTPercent,0))>0,((NetTotalAmtAfterDisc*100/(100+(IFNULL(st.CGSTPercent,0)+IFNULL(st.SGSTPercent,0)+IFNULL(st.IGSTPercent,0))))*(IFNULL(st.CGSTPercent,0)+IFNULL(st.SGSTPercent,0)+IFNULL(st.IGSTPercent,0))/100),0),2)TaxValue, ");

        //# ((t.Rate * st.InitialCount))Amount,   	
        sb.Append(" 	 (NetTotalAmtAfterDisc)NetTotalAmtAfterDisc, ");
        sb.Append(" 	 (t.Amount)PayAmount,LedgerNoCr FROM  ");
        sb.Append(" 	 ( SELECT  ltd.Quantity,lt.LedgerTransactionNo,lt.BillNo,ltd.ItemID,ltd.Rate,lt.LedgerNoCr,ltd.Amount,(SELECT ledgerName FROM f_ledgermaster WHERE ledgernumber=lt.LedgerNoCr )Supplier,	   ");
        sb.Append(" 	           ( SELECT TinNo FROM f_vendormaster  ven	INNER JOIN f_ledgermaster lm ON ven.vendor_ID=lm.LedgerUserID WHERE lm.ledgernumber=lt.LedgerNoCr )SupplierTin,  		 ");
        sb.Append(" 	           ltd.StockID,(ltd.Rate*ltd.Quantity)- (((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100) NetTotalAmtAfterDisc    		 ");
        sb.Append(" 	           FROM f_ledgertransaction lt   		 ");
        sb.Append(" 	           INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo       ");
        sb.Append(" 		WHERE lt.IsCancel=0 AND lt.TypeOfTnx='Vendor-Return' ");
        sb.Append("         AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("         AND DATE(lt.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("  )t         ");
        sb.Append("     INNER JOIN f_stock st ON t.StockID = st.StockID AND st.IsPost=1 AND ISfree=0   ");
        //sb.Append(" and st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  ");
        if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
            sb.Append(" and st.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

        if (chkGroupHead.Checked)
            sb.Append("     AND st.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

        if (chkItem.Checked)
            sb.Append("     AND st.ItemID='" + ddlItem.SelectedValue + "' ");

        sb.Append(" )t1 GROUP BY t1.LedgerTransactionNo,t1.LedgerNoCr,t1.TaxPercentage  ORDER BY ROUND(t1.TaxPercentage,0),t1.LedgerTransactionNo  ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            //DataColumn dc = new DataColumn();
            //dc.ColumnName = "UserName";
            //dc.DefaultValue = StockReports.GetUserName(Util.GetString(ViewState["ID"])).Rows[0][0].ToString();
            //dt.Columns.Add(dc);

            //DataColumn dc2 = new DataColumn();
            //dc2.ColumnName = "Period";
            //dc2.DefaultValue = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
            //dt.Columns.Add(dc2);

            //DataSet ds = new DataSet();
            //ds.Tables.Add(dt.Copy());
            //Session["ds"] = ds;

            ////ds.WriteXmlSchema("E://PurchaseVatReturnReport.xml");
            //Session["ReportName"] = "PurchaseGSTReturnReport";

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/CommonCrystalReportViewer.aspx');", true);

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Purchase GST Return Report";
            Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
        {

            lblMsg.Text = "Record Not Found";
        }
    }


    private void BindSalesIssueData()
    {
        StringBuilder sb = new StringBuilder();

        if (rblFormattype.SelectedItem.Value.ToString() == "1")
        {
            sb.Append("  SELECT RIGHT(MIN(BILLNO),8) AS BillFrom,RIGHT(MAX(BILLNO),8) AS BillTo,IssueDate,SUM(RoundOff)RoundOff,  ");
            sb.Append("  SUM(TotaSaleValue)TotaSaleValue,GSTPer, ROUND(SUM(TotaSale)*GSTPer/100,3)TotalGST,   ");
            sb.Append("  a.CGSTPercent,ROUND(SUM(TotaSale)*a.CGSTPercent/100,3)CGSTAmt,a.SGSTPercent,ROUND(SUM(TotaSale)*a.SGSTPercent/100,3)SGSTAmt,a.IGSTPercent, ");
            sb.Append("  ROUND(SUM(TotaSale)*a.IGSTPercent/100,2)IGSTAmt,(SUM(TotaSaleValue) + ROUND(SUM(TotaSale)*GSTPer/100,2)) Total,Category,DATE ");
            sb.Append("    FROM   ( ");
            sb.Append("  	SELECT t.billno,t.IssueDate, ");
            sb.Append("  	ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSaleValue,     ");
            sb.Append("  	ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSale,SUM(RoundOff)RoundOff, ");
            sb.Append("  	GSTPer,IF(GSTPer>0,'R','E')Category,t.Date,t.CGSTPercent,t.SGSTPercent,t.IGSTPercent	 ");
            sb.Append("  	 FROM         (     ");
            sb.Append("  		SELECT sd.LedgerTransactionNo,ltd.`ItemID`,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate, ");
            sb.Append("  		ltd.Rate,sd.soldUnits, sd.Date, ");
            sb.Append("  		ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`, ");
            sb.Append("  		ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount, ");
            sb.Append("  		ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff, ");
            sb.Append("  		ROUND((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) + ");
            sb.Append("  		ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2)),2) TotalSaleAfterDisRounfOff, ");
            sb.Append("  		ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) + ");
            sb.Append("  		ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeVATAfDisRound, ");
            sb.Append("  		(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,IFNULL(sd.SGSTPercent,0)SGSTPercent,IFNULL(sd.CGSTPercent,0)CGSTPercent, IFNULL(sd.IGSTPercent,0)IGSTPercent,  ");
            sb.Append("  		ltd.`ItemName` ");
            sb.Append("  		FROM f_salesdetails sd ");
            sb.Append("  		INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid ");
            sb.Append("  		INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo ");
            sb.Append("  		AND ltd.stockID=sd.stockID and ltd.`IsVerified`!=2");
            sb.Append("  		INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo ");
            sb.Append("  		WHERE sd.TrasactionTypeID IN (16,3)       ");
            sb.Append("  		AND sd.Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND sd.Date<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("  	)t GROUP BY t.LedgerTransactionNo,t.GSTPer ORDER BY t.LedgerTransactionNo,t.GSTPer     ");
            sb.Append("   )a GROUP BY a.GSTPer,a.Date ORDER BY a.GSTPer,a.Date  ");
        }
        else if (rblFormattype.SelectedItem.Value.ToString() == "2")
        {
            sb.Append("  SELECT ItemName,RIGHT(MIN(BILLNO),8) AS BillFrom,RIGHT(MAX(BILLNO),8) AS BillTo,IssueDate,SUM(RoundOff)RoundOff,      ");
            sb.Append("  SUM(TotaSaleValue)TotaSaleValue,GSTPer, ROUND(SUM(TotaSale)*GSTPer/100,3)TotalGST,     ");
            sb.Append("  a.CGSTPercent,ROUND(SUM(TotaSale)*a.CGSTPercent/100,3)CGSTAmt,a.SGSTPercent,ROUND(SUM(TotaSale)*a.SGSTPercent/100,3)SGSTAmt,a.IGSTPercent,   ");
            sb.Append("  ROUND(SUM(TotaSale)*a.IGSTPercent/100,2)IGSTAmt,(SUM(TotaSaleValue) + ROUND(SUM(TotaSale)*GSTPer/100,2)) Total,Category,DATE   ");
            sb.Append("  FROM   (   ");
            sb.Append("  SELECT t.billno,t.IssueDate,ItemName,ItemID,   ");
            sb.Append("  ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSaleValue,       ");
            sb.Append("  ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSale,SUM(RoundOff)RoundOff,   ");
            sb.Append("  GSTPer,IF(GSTPer>0,'R','E')Category,t.Date,t.CGSTPercent,t.SGSTPercent,t.IGSTPercent	   ");
            sb.Append("  FROM         (       ");
            sb.Append("  SELECT s.StockID,sd.LedgerTransactionNo,ltd.`ItemID`,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,   ");
            sb.Append("  ltd.Rate,sd.soldUnits, sd.Date,   ");
            sb.Append("  ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,   ");
            sb.Append("  ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,   ");

            sb.Append("  ROUND((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2)),2) TotalSaleAfterDisRounfOff,   ");
            sb.Append("  ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeVATAfDisRound,   ");

            sb.Append("  (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,IFNULL(sd.SGSTPercent,0)SGSTPercent,IFNULL(sd.CGSTPercent,0)CGSTPercent, IFNULL(sd.IGSTPercent,0)IGSTPercent,    ");
            sb.Append("  ltd.`ItemName`,LEFT(IFNULL(s.HSNCode,''),4) HSNCode    ");
            sb.Append("  FROM f_salesdetails sd   ");

            sb.Append("  INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid   ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo   ");
            sb.Append("  AND ltd.stockID=sd.stockID   ");
            sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
            sb.Append("  WHERE sd.TrasactionTypeID IN (16,3)          ");
            sb.Append("  AND sd.Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND sd.Date<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'     ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");

            sb.Append("  )t GROUP BY  t.LedgerTransactionNo,t.StockID,t.ItemID,t.GSTPer ORDER BY t.LedgerTransactionNo,t.ItemID,t.GSTPer     ");
            sb.Append("  )a GROUP BY a.Date,a.ItemID,a.GSTPer ORDER BY a.Date,a.ItemID,a.GSTPer    ");
        }
        else if (rblFormattype.SelectedItem.Value.ToString() == "3")
        {
            sb.Append("   Select HSNCode,SUM(soldUnits) Quantity,SUM(TotalSaleValue) TotalSaleValue,SUM(TaxableAmount) TaxableAmount ,   ");
            sb.Append("   SUM(CGSTAmt) CGSTAmt ,SUM(SGSTAmt) SGSTAmt,SUM(IGSTAmt) IGSTAmt,SUM(GSTAmt) GSTAmt,SUM(RoundOff)RoundOff FROM(  ");
            sb.Append("   SELECT t.billno,t.IssueDate,t.ItemID,   ");
            sb.Append("   ROUND(SUM(TotaSaleAfterDiscount),2)TotalSaleValue,       ");
            sb.Append("   ROUND(SUM(ActualSaleBeforeGSTAfDis),2) TaxableAmount,SUM(RoundOff)RoundOff,   ");
            sb.Append("   IF(GSTPer>0,'R','E')Category,t.Date,  ");
            sb.Append("   t.CGSTPercent,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.CGSTPercent/100,2) CGSTAmt,  ");
            sb.Append("   t.SGSTPercent,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.SGSTPercent/100,2) SGSTAmt,  ");
            sb.Append("   t.IGSTPercent,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.IGSTPercent/100,2) IGSTAmt,  ");
            sb.Append("   GSTPer,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.GSTPer/100,2) GSTAmt,  ");
            sb.Append("   t.HSNCode,t.soldUnits	   ");
            sb.Append("   FROM         (       ");
            sb.Append("   SELECT s.StockID,sd.LedgerTransactionNo,ltd.`ItemID`,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,   ");
            sb.Append("   ltd.Rate,sd.soldUnits, sd.Date,   ");
            sb.Append("   ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,   ");
            sb.Append("   ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,   ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,   ");
            sb.Append("   ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeGSTAfDis,   ");
            sb.Append("   (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2 SGSTPercent,(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2 CGSTPercent, 0 IGSTPercent,    ");
            sb.Append("   ltd.`ItemName`,LEFT(IFNULL(s.HSNCode,''),4) HSNCode   ");
            sb.Append("     	FROM f_salesdetails sd   ");
            sb.Append("     	INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid   ");
            sb.Append("     	INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo   ");
            sb.Append("     	AND ltd.stockID=sd.stockID   ");
            sb.Append("     	INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
            sb.Append("  		WHERE sd.TrasactionTypeID IN (16,3)       ");
            sb.Append("  		AND (sd.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND (sd.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("     )t GROUP BY t.LedgerTransactionNo,t.StockID,t.ItemID,t.GSTPer  ");
            sb.Append("     )a GROUP BY a.HSNCode ORDER BY a.HSNCode  ");
        }
        else if (rblFormattype.SelectedItem.Value.ToString() == "4")
        {
            sb.Append("   SELECT s.stockID,sd.SalesID,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,  ");
            sb.Append("   ltd.Rate,sd.soldUnits, sd.Date,    ");
            sb.Append("  ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,    ");
            sb.Append("  ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,    ");
            sb.Append("  ROUND((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2)),2) TotalSaleAfterDisRounfOff,   ");
            sb.Append("  ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeVATAfDisRound,    ");

            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/100,2) TotalTax, ");
            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2))/100,2) TotalCGSTTax, ");
            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2))/100,2) TotalSGSTTax, ");
            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(IFNULL(sd.IGSTPercent,0))/100,2)*0 TotalIGSTTax, ");

            sb.Append("  (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2) SGSTPercent,((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2) CGSTPercent, 0 IGSTPercent,     ");
            sb.Append("  ltd.`ItemName`,IF(lt_pay.`PaymentModeID`=4,'Credit','Non-credit') Credittype,IF((SELECT COUNT(*) FROM f_reciept rec1 WHERE rec1.AsainstLedgerTnxNo=lt.LedgerTransactionno)>0 ,(SELECT GROUP_CONCAT(DISTINCT recpay1.PaymentMode) FROM f_reciept rec1  INNER JOIN f_receipt_paymentdetail recpay1 ON rec1.Receiptno=recpay1.Receiptno WHERE rec1.AsainstLedgerTnxNo=lt.LedgerTransactionno GROUP BY rec1.AsainstLedgerTnxNo),(SELECT GROUP_CONCAT( DISTINCT ltpay1.PaymentMode) FROM `f_ledgertransaction_paymentdetail` ltpay1 WHERE ltpay1.Ledgertransactionno=lt.LedgerTransactionno GROUP BY ltpay1.Ledgertransactionno)) PaymentMode,ROUND(s.`unitPrice`*100/(100+ (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))),4) PurchasePricePerItem,ROUND(s.`unitPrice`*100/(100+ (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))),4)*sd.soldUnits totalpurchase,ROUND(ROUND(s.`unitPrice`*100/(100+ (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))),4)*sd.soldUnits*(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/100,4) totalpurchaseGSTAMT,ROUND(s.`unitPrice`*sd.soldUnits,4) TotalPurchasewithGST ");
            sb.Append("  ,IF(IFNULL(lt.ipno,'')='',IF(lt.`LedgerNoCr`='CASH002','General','Opd'),'Ipd') TYPE,(SELECT CONCAT(Title,' ',NAME)  FROM doctor_master WHERE DoctorID=pmh.DoctorID) DoctorName");
            sb.Append("  ,IF(lt.`LedgerNoCr`='CASH002',(SELECT NAME  FROM patient_general_master WHERE CustomerID= sd.PatientID),(SELECT Pname FROM patient_master WHERE PatientID=sd.PatientID )) PatientName ");
            sb.Append("  FROM f_salesdetails sd    ");
            sb.Append("  INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid    ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo    ");
            sb.Append("  AND ltd.stockID=sd.stockID    ");
            sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo    ");
            sb.Append("  INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt.LedgerTransactionNo=lt_pay.LedgerTransactionNo    ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append("   WHERE sd.TrasactionTypeID IN (16,3)           ");
            sb.Append("  		AND (sd.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND (sd.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("  ORDER BY sd.Date,sd.`BillNo` ");
        }


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            if (rblFormattype.SelectedItem.Value.ToString() == "1")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Util.GetString(ViewState["ID"])).Rows[0][0].ToString();
                dt.Columns.Add(dc);

                DataColumn dc2 = new DataColumn();
                dc2.ColumnName = "Period";
                dc2.DefaultValue = " From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + "";
                dt.Columns.Add(dc2);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;

               // ds.WriteXmlSchema("D://SalesIssueVatReport.xml");
                Session["ReportName"] = "SalesIssueGSTReport";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/CommonCrystalReportViewerOld.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "2")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Sales GST Issue Report";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "3")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Sales HSN Issue Report";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "4")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Sales Issue Report Detail";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
        }
        else
        {

            lblMsg.Text = "Record Not Found";
        }
    }


    private void BindSalesReturnData()
    {
        StringBuilder sb = new System.Text.StringBuilder();

        if (rblFormattype.SelectedItem.Value.ToString() == "1")
        {
            sb.Append("  SELECT RIGHT(MIN(BILLNO),8) AS BillFrom,RIGHT(MAX(BILLNO),8) AS BillTo,IssueDate,SUM(RoundOff)RoundOff,  ");
            sb.Append("  SUM(TotaSaleValue)TotaSaleValue,GSTPer, ROUND(SUM(TotaSale)*GSTPer/100,3)TotalGST,    ");
            sb.Append("  a.CGSTPercent,ROUND(SUM(TotaSale)*a.CGSTPercent/100,3)CGSTAmt,a.SGSTPercent,ROUND(SUM(TotaSale)*a.SGSTPercent/100,3)SGSTAmt,a.IGSTPercent,  ");
            sb.Append("  ROUND(SUM(TotaSale)*a.IGSTPercent/100,2)IGSTAmt,(SUM(TotaSaleValue) + ROUND(SUM(TotaSale)*GSTPer/100,2)) Total,Category,DATE  ");
            sb.Append("    FROM   (  ");
            sb.Append("  	SELECT t.billno,t.IssueDate,  ");
            sb.Append("  	ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSaleValue,      ");
            sb.Append("  	ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSale,SUM(RoundOff)RoundOff,  ");
            sb.Append("  	GSTPer,IF(GSTPer>0,'R','E')Category,t.Date,t.CGSTPercent,t.SGSTPercent,t.IGSTPercent	  ");
            sb.Append("  	 FROM         (      ");
            sb.Append("  		SELECT sd.LedgerTransactionNo,ltd.`ItemID`,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,  ");
            sb.Append("  		ltd.Rate,sd.soldUnits, sd.Date,  ");
            sb.Append("  		ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,  ");
            sb.Append("  		ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,  ");
            sb.Append("  		ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,  ");
            sb.Append("  		ROUND((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +  ");
            sb.Append("  		ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2)),2) TotalSaleAfterDisRounfOff,  ");
            sb.Append("  		ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +  ");
            sb.Append("  		ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeVATAfDisRound,  ");
            sb.Append("  		(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,IFNULL(sd.SGSTPercent,0)SGSTPercent,IFNULL(sd.CGSTPercent,0)CGSTPercent, IFNULL(sd.IGSTPercent,0)IGSTPercent,   ");
            sb.Append("  		ltd.`ItemName`  ");
            sb.Append("  		FROM f_salesdetails sd  ");
            sb.Append("  		INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid  ");
            sb.Append("  		INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo  ");
            sb.Append("  		AND ltd.stockID=sd.stockID  ");
            sb.Append("  		INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
            sb.Append("  		WHERE sd.TrasactionTypeID IN (17,5)        ");
            sb.Append("  		AND (sd.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND (sd.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY sd.`ID`  ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("  	)t GROUP BY t.LedgerTransactionNo,t.GSTPer ORDER BY t.LedgerTransactionNo,t.GSTPer      ");
            sb.Append("  )a GROUP BY a.GSTPer,a.Date ORDER BY a.GSTPer,a.Date   ");
        }
        else if (rblFormattype.SelectedItem.Value.ToString() == "2")
        {
            sb.Append("  SELECT ItemName,RIGHT(MIN(BILLNO),8) AS BillFrom,RIGHT(MAX(BILLNO),8) AS BillTo,IssueDate,SUM(RoundOff)RoundOff,      ");
            sb.Append("  SUM(TotaSaleValue)TotaSaleValue,GSTPer, ROUND(SUM(TotaSale)*GSTPer/100,3)TotalGST,     ");
            sb.Append("  a.CGSTPercent,ROUND(SUM(TotaSale)*a.CGSTPercent/100,3)CGSTAmt,a.SGSTPercent,ROUND(SUM(TotaSale)*a.SGSTPercent/100,3)SGSTAmt,a.IGSTPercent,   ");
            sb.Append("  ROUND(SUM(TotaSale)*a.IGSTPercent/100,2)IGSTAmt,(SUM(TotaSaleValue) + ROUND(SUM(TotaSale)*GSTPer/100,2)) Total,Category,DATE   ");
            sb.Append("  FROM   (   ");
            sb.Append("  SELECT t.billno,t.IssueDate,ItemName,ItemID,   ");
            sb.Append("  ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSaleValue,       ");
            sb.Append("  ROUND(SUM(ActualSaleBeforeVATAfDisRound),2)TotaSale,SUM(RoundOff)RoundOff,   ");
            sb.Append("  GSTPer,IF(GSTPer>0,'R','E')Category,t.Date,t.CGSTPercent,t.SGSTPercent,t.IGSTPercent	   ");
            sb.Append("  FROM         (       ");
            sb.Append("  SELECT sd.LedgerTransactionNo,ltd.`ItemID`,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,   ");
            sb.Append("  ltd.Rate,sd.soldUnits, sd.Date,   ");
            sb.Append("  ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,   ");
            sb.Append("  ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,   ");
            sb.Append("  ROUND((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2)),2) TotalSaleAfterDisRounfOff,   ");
            sb.Append("  ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeVATAfDisRound,   ");
            sb.Append("  (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,IFNULL(sd.SGSTPercent,0)SGSTPercent,IFNULL(sd.CGSTPercent,0)CGSTPercent, IFNULL(sd.IGSTPercent,0)IGSTPercent,    ");
            sb.Append("  ltd.`ItemName`   ");
            sb.Append("  FROM f_salesdetails sd   ");
            sb.Append("  INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid   ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo   ");
            sb.Append("  AND ltd.stockID=sd.stockID   ");
            sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
            sb.Append("  WHERE sd.TrasactionTypeID IN (17,5)          ");
            sb.Append("  AND DATE(sd.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(sd.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'     ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");

            sb.Append("  )t GROUP BY t.LedgerTransactionNo,t.ItemID,t.GSTPer ORDER BY t.LedgerTransactionNo,t.ItemID,t.GSTPer     ");
            sb.Append("  )a GROUP BY a.GSTPer,a.ItemID,a.Date ORDER BY a.GSTPer,a.ItemID,a.Date    ");
        }

        if (rblFormattype.SelectedItem.Value.ToString() == "3")
        {

            sb.Append("   Select HSNCode,SUM(soldUnits) Quantity,SUM(TotalSaleValue) TotalSaleValue,SUM(TaxableAmount) TaxableAmount ,   ");
            sb.Append("   SUM(CGSTAmt) CGSTAmt ,SUM(SGSTAmt) SGSTAmt,SUM(IGSTAmt) IGSTAmt,SUM(GSTAmt) GSTAmt,SUM(RoundOff)RoundOff FROM(  ");
            sb.Append("   SELECT t.billno,t.IssueDate,t.ItemID,   ");
            sb.Append("   ROUND(SUM(TotaSaleAfterDiscount),2)TotalSaleValue,       ");
            sb.Append("   ROUND(SUM(ActualSaleBeforeGSTAfDis),2) TaxableAmount,SUM(RoundOff)RoundOff,   ");
            sb.Append("   IF(GSTPer>0,'R','E')Category,t.Date,  ");
            sb.Append("   t.CGSTPercent,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.CGSTPercent/100,2) CGSTAmt,  ");
            sb.Append("   t.SGSTPercent,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.SGSTPercent/100,2) SGSTAmt,  ");
            sb.Append("   t.IGSTPercent,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.IGSTPercent/100,2) IGSTAmt,  ");
            sb.Append("   GSTPer,ROUND(SUM(ActualSaleBeforeGSTAfDis)*t.GSTPer/100,2) GSTAmt,  ");
            sb.Append("   t.HSNCode,t.soldUnits	   ");
            sb.Append("   FROM         (       ");
            sb.Append("   SELECT s.StockID,sd.LedgerTransactionNo,ltd.`ItemID`,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,   ");
            sb.Append("   ltd.Rate,sd.soldUnits, sd.Date,   ");
            sb.Append("   ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,   ");
            sb.Append("   ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,   ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,   ");
            sb.Append("   ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeGSTAfDis,   ");
            sb.Append("   (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2 SGSTPercent,(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2 CGSTPercent, 0 IGSTPercent,    ");
            sb.Append("   ltd.`ItemName`,LEFT(IFNULL(s.HSNCode,''),4) HSNCode   ");
            sb.Append("     	FROM f_salesdetails sd   ");
            sb.Append("     	INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid   ");
            sb.Append("     	INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo   ");
            sb.Append("     	AND ltd.stockID=sd.stockID   ");
            sb.Append("     	INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
            sb.Append("  		WHERE sd.TrasactionTypeID IN (17,5)       ");
            sb.Append("  		AND (sd.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND (sd.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("     )t GROUP BY t.LedgerTransactionNo,t.StockID,t.ItemID,t.GSTPer  ");
            sb.Append("     )a GROUP BY a.HSNCode ORDER BY a.HSNCode  ");
        }
        else if (rblFormattype.SelectedItem.Value.ToString() == "4")
        {
          
            sb.Append("   SELECT sd.salesID,st.stockID,sd.BillNo,DATE_FORMAT(sd.Date,'%d-%b-%Y') IssueDate,  ");
            sb.Append("   ltd.Rate,sd.soldUnits, sd.Date,    ");
            sb.Append("  ROUND((ltd.Rate*sd.soldUnits),2) TotaSaleBeforeDiscount,ltd.`DiscountPercentage`,    ");
            sb.Append("  ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) TotaSaleAfterDiscount,   ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2) RoundOff,    ");
            sb.Append("  ROUND((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2)),2) TotalSaleAfterDisRounfOff,   ");
            sb.Append("  ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("  ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2) ActualSaleBeforeVATAfDisRound,    ");

            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/100,2) TotalTax, ");
            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2))/100,2) TotalCGSTTax, ");
            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2))/100,2) TotalSGSTTax, ");
            sb.Append("   ROUND(ROUND(((ROUND(((ltd.Rate*sd.soldUnits)*(100-ltd.`DiscountPercentage`)/100),2) +    ");
            sb.Append("   ROUND(ROUND((ltd.Rate*sd.soldUnits)*(100-ltd.DiscountPercentage)/100,2)*lt.RoundOff/(lt.`NetAmount`+lt.RoundOff),2))*100/(100+((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))))),2)*(IFNULL(sd.IGSTPercent,0))/100,2)*0 TotalIGSTTax, ");

            sb.Append("  (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))GSTPer,((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2) SGSTPercent,((IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/2) CGSTPercent, 0 IGSTPercent,     ");
            sb.Append("  ltd.`ItemName`,IF(lt_pay.`PaymentModeID`=4,'Credit','Non-credit') Credittype,IF((SELECT COUNT(*) FROM f_reciept rec1 WHERE rec1.AsainstLedgerTnxNo=lt.LedgerTransactionno)>0 ,(SELECT GROUP_CONCAT(DISTINCT recpay1.PaymentMode) FROM f_reciept rec1  INNER JOIN f_receipt_paymentdetail recpay1 ON rec1.Receiptno=recpay1.Receiptno WHERE rec1.AsainstLedgerTnxNo=lt.LedgerTransactionno GROUP BY rec1.AsainstLedgerTnxNo),(SELECT GROUP_CONCAT( DISTINCT ltpay1.PaymentMode) FROM `f_ledgertransaction_paymentdetail` ltpay1 WHERE ltpay1.Ledgertransactionno=lt.LedgerTransactionno GROUP BY ltpay1.Ledgertransactionno)) PaymentMode,ROUND(s.`unitPrice`*100/(100+ (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))),4) PurchasePricePerItem,ROUND(s.`unitPrice`*100/(100+ (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))),4)*sd.soldUnits totalpurchase,ROUND(ROUND(s.`unitPrice`*100/(100+ (IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))),4)*sd.soldUnits*(IFNULL(sd.CGSTPercent,0)+IFNULL(sd.SGSTPercent,0)+IFNULL(sd.IGSTPercent,0))/100,4) totalpurchaseGSTAMT,ROUND(s.`unitPrice`*sd.soldUnits,4) TotalPurchasewithGST ");
            sb.Append("  ,IF(IFNULL(lt.ipno,'')='',IF(lt.`LedgerNoCr`='CASH002','General','Opd'),'Ipd') TYPE,(SELECT CONCAT(Title,' ',NAME)  FROM doctor_master WHERE DoctorID=pmh.DoctorID) DoctorName");
            sb.Append("  ,IF(lt.`LedgerNoCr`='CASH002',(SELECT NAME  FROM patient_general_master WHERE CustomerID= sd.PatientID),(SELECT Pname FROM patient_master WHERE PatientID=sd.PatientID )) PatientName ");
            sb.Append("  FROM f_salesdetails sd    ");
            sb.Append("  INNER JOIN f_stock s ON s.StockID=sd.StockID AND s.Itemid=sd.Itemid    ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo    ");
            sb.Append("  AND ltd.stockID=sd.stockID    ");
            sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo    ");
            sb.Append("  INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt.LedgerTransactionNo=lt_pay.LedgerTransactionNo    ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append("   WHERE sd.TrasactionTypeID IN (17,5)           ");
            sb.Append("  		AND (sd.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND (sd.Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (ddlDepartment.SelectedValue.ToUpper().ToString() != "ALL")
                sb.Append(" and s.DeptLedgerNo='" + ddlDepartment.SelectedValue.ToString() + "'  ");

            if (chkGroupHead.Checked)
                sb.Append("     AND s.SubCategoryID='" + ddlGroup.SelectedValue + "' ");

            if (chkItem.Checked)
                sb.Append("     AND s.ItemID='" + ddlItem.SelectedValue + "' ");
            sb.Append("  ORDER BY sd.Date,sd.`BillNo` ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            if (rblFormattype.SelectedItem.Value.ToString() == "1")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Util.GetString(ViewState["ID"])).Rows[0][0].ToString();
                dt.Columns.Add(dc);

                DataColumn dc2 = new DataColumn();
                dc2.ColumnName = "Period";
                dc2.DefaultValue = " From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                dt.Columns.Add(dc2);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;

                //ds.WriteXmlSchema("D://SalesReturnVatReport.xml");
                Session["ReportName"] = "SalesReturnGSTReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/CommonCrystalReportViewerOld.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "2")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Sales GST Return Report";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "3")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Sales HSN Return Report";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else if (rblFormattype.SelectedItem.Value.ToString() == "4")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Sales return Report Detail";
                Session["Period"] = "Date Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yy") + "  To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
        }
        else
        {

            lblMsg.Text = "Record Not Found";
        }
    }
    private void BindGroup()
    {
        string sqlGroup = "  SELECT sc.Name GroupHead,sc.SubCategoryID FROM f_subcategorymaster sc  INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID WHERE sc.Active=1 AND cf.ConfigID ='11' ORDER BY sc.Name ";

        ddlGroup.DataSource = StockReports.GetDataTable(sqlGroup);
        ddlGroup.DataTextField = "GroupHead";
        ddlGroup.DataValueField = "SubCategoryID";
        ddlGroup.DataBind();

        ddlGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlGroup.SelectedIndex = 0;
    }

    private void BindItem(string SubCategoryID)
    {
        string sql = "Select TypeName,ItemID FROM f_Itemmaster WHERE IsActive=1 ";

        if (SubCategoryID != "ALL")
            sql = sql + " and SubCategoryID='" + SubCategoryID + "'";

        sql = sql + " ORDER BY TypeName";

        ddlItem.DataSource = StockReports.GetDataTable(sql);
        ddlItem.DataTextField = "TypeName";
        ddlItem.DataValueField = "ItemID";
        ddlItem.DataBind();
        ddlItem.Items.Add(new ListItem("--Select--", "0", true));
    }
    private void BindDepartment()
    {
        string sql = "SELECT RoleName,DeptLedgerNo FROM f_rolemaster where Active=1 AND DeptLedgerNo<>'' Order By  RoleName";
        ddlDepartment.DataSource = StockReports.GetDataTable(sql);
        ddlDepartment.DataTextField = "RoleName";
        ddlDepartment.DataValueField = "DeptLedgerNo";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlDepartment.SelectedIndex = 0;
    }
}