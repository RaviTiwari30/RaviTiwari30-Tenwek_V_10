using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Finance_SearchVendorReturn : System.Web.UI.Page
{
    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = GetVendorReturnReport();
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User Name";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"c:\amitVendor.xml");
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Vendor Return Report ( From " + (Convert.ToDateTime(ucFromDate.Text)).ToString("dd-MMM-yyyy") + " To " + (Convert.ToDateTime(ucToDate.Text)).ToString("dd-MMM-yyyy") + " )";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
            lblMsg.Text = "No Record Found";
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = GetVendorReturn();
        if (dt.Rows.Count > 0)
        {
            grdVendorReturn.DataSource = dt;
            grdVendorReturn.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            grdVendorReturn.DataSource = null;
            grdVendorReturn.DataBind();
            lblMsg.Text = "No Record Found";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindStore(lstVendor, "VEN", "Select");
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    private DataTable GetVendorReturn()
    {
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select LM.LedgerName,im.typename ItemName,REPLACE(Sd.ItemID,'LSHHI','')ItemID,SD.SoldUnits as Qty,SD.PerUnitBuyPrice as UnitPrice,date_format(SD.Date,'%d-%b-%Y')Date,Sd.IndentNo,");
            sb.Append(" Sd.salesno,Lt.Remarks,ROUND(IFNULL((SD.SoldUnits*SD.PerUnitBuyPrice),0),2)TotalAmountCoset from f_salesdetails Sd inner join f_ledgermaster LM on Sd.LedgerNumber=LM.LedgerNumber inner join f_itemmaster im on im.itemid = sd.itemid");
            sb.Append(" inner join f_ledgertransaction lt on lt.LedgerTransactionNo = sd.LedgerTransactionNo where lt.Iscancel=0 AND Sd.TrasactionTypeID='7'");

            if (lstVendor.SelectedIndex > 0)
                sb.Append(" and Sd.LedgerNumber='" + lstVendor.SelectedValue + "'");
            if (ucFromDate.Text != string.Empty)
                sb.Append(" and Sd.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");

            if (ucToDate.Text != string.Empty)
                sb.Append(" and Sd.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");

            if (txtIndentNo.Text.Trim() != string.Empty)
                sb.Append(" and Sd.IndentNo='" + txtIndentNo.Text.Trim() + "'");
            if (txtEntryNo.Text.Trim() != string.Empty)
                sb.Append(" and Sd.salesno = " + txtEntryNo.Text.Trim());

            dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return dt;
        }
    }

    private DataTable GetVendorReturnReport()
    {
        StringBuilder sb = new StringBuilder();
        // sb.Append(" select LM.LedgerName 'Vendor Name',im.typename 'Item Name',REPLACE(Sd.ItemID,'LSHHI','')'Item Id',SD.SoldUnits as Qunatity,SD.PerUnitBuyPrice as 'Unit Price',date_format(SD.Date,'%d-%b-%Y')Date,Sd.IndentNo 'Requisition No' ,");
        // sb.Append(" Sd.salesno 'Sales No',Lt.Remarks 
         sb.Append(" SELECT LM.LedgerName 'Vendor Name',im.typename 'Item Name',REPLACE(Sd.ItemID,'LSHHI','')'Item Id',SD.SoldUnits AS Qunatity,SD.PerUnitBuyPrice   ");
         sb.Append(" AS 'Unit Price',DATE_FORMAT(SD.Date,'%d-%b-%Y')DATE,Sd.IndentNo 'Requisition No' , Sd.salesno 'Sales No',Lt.Remarks, ");
         sb.Append(" st.BatchNumber,st.HSNCode,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') MedExpiryDate, ");
         sb.Append(" ROUND(st.CGSTPercent,1) CGSTPercent,ROUND(st.SGSTPercent,1) SGSTPercent,ROUND(st.IGSTPercent,1) IGSTPercent,st.MRP,SD.PerUnitBuyPrice,ROUND(ltd.rate,2) Rate,ROUND(ltd.DiscountPercentage,2) DiscPer,ROUND(ltd.DiscAmt,2) DiscAmt,ROUND(ltd.Amount,2) Amount, ");
         sb.Append(" CAST(ROUND(((ltd.Amount*100)/(100+st.CGSTPercent+st.SGSTPercent+st.IGSTPercent)),2) AS DECIMAL(15,2)) TaxableAmt, ");
         sb.Append(" CAST(ROUND(((ltd.Amount*100)/(100+st.CGSTPercent+st.SGSTPercent+st.IGSTPercent))*st.CGSTPercent/100,2) AS DECIMAL(15,2)) CGSTAmt, ");
         sb.Append(" CAST(ROUND(((ltd.Amount*100)/(100+st.CGSTPercent+st.SGSTPercent+st.IGSTPercent))*st.SGSTPercent/100,2) AS DECIMAL(15,2)) SGSTAmt, ");
         sb.Append(" CAST(ROUND(((ltd.Amount*100)/(100+st.CGSTPercent+st.SGSTPercent+st.IGSTPercent))*st.IGSTPercent/100,2) AS DECIMAL(15,2)) IGSTAmt, ");
         sb.Append(" CAST(ROUND(((ltd.Amount*100)/(100+st.CGSTPercent+st.SGSTPercent+st.IGSTPercent))*(st.CGSTPercent+st.SGSTPercent+st.IGSTPercent)/100,2) AS DECIMAL(15,2)) GSTAmt ");

         sb.Append(" from f_salesdetails Sd   INNER JOIN f_stock st ON st.stockID=Sd.stockID  inner join f_ledgermaster LM on Sd.LedgerNumber=LM.LedgerNumber inner join f_itemmaster im on im.itemid = sd.itemid INNER JOIN f_ledgertnxdetail ltd On ltd.Ledgertransactionno =sd.Ledgertransactionno AND ltd.StockID=sd.StockID");
        sb.Append(" inner join f_ledgertransaction lt on lt.LedgerTransactionNo = sd.LedgerTransactionNo where lt.IsCancel=0 AND  Sd.TrasactionTypeID='7'");

        if (lstVendor.SelectedIndex > 0)
            sb.Append(" and Sd.LedgerNumber='" + lstVendor.SelectedValue + "'");
        if (ucFromDate.Text != string.Empty)
            sb.Append(" and Sd.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");

        if (ucToDate.Text != string.Empty)
            sb.Append(" and Sd.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");

        if (txtIndentNo.Text.Trim() != string.Empty)
            sb.Append(" and Sd.IndentNo='" + txtIndentNo.Text.Trim() + "'");
        if (txtEntryNo.Text.Trim() != string.Empty)
            sb.Append(" and Sd.salesno = " + txtEntryNo.Text.Trim());

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();

            dr["Qunatity"] = Util.GetString(dt.Compute("sum(Qunatity)", ""));
            dr["TaxableAmt"] = Util.GetString(dt.Compute("sum(TaxableAmt)", ""));
            dr["Amount"] = Util.GetString(dt.Compute("sum(Amount)", ""));
            dr["CGSTAmt"] = Util.GetString(dt.Compute("sum(CGSTAmt)", ""));
            dr["SGSTAmt"] = Util.GetString(dt.Compute("sum(SGSTAmt)", ""));
            dr["IGSTAmt"] = Util.GetString(dt.Compute("sum(IGSTAmt)", ""));
            dr["GSTAmt"] = Util.GetString(dt.Compute("sum(GSTAmt)", ""));
            dt.Rows.Add(dr);
            dt.AcceptChanges();
        }
        return dt;
    }
    protected void grdVendorReturn_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
           string SalesNo = Util.GetString(e.CommandArgument).ToString();       
           StringBuilder sb = new StringBuilder();
           sb.Append(" select Round(SalesID),ven.VendorName VenderName,address1 address,address2,lm.LedgerName Store,SoldUnits,UnitType,PerUnitBuyPrice,date,TypeName, ");
           sb.Append("     IndentNo,Naration,Salesno,sales.IGSTPercent,sales.IGSTAmt,sales.CGSTPercent,sales.CGSTAmt,sales.SGSTPercent,sales.SGSTAmt,sales.GSTType,sales.HSNCode,InvoiceNo,InvoiceDate,BatchNumber,MedExpiryDate,sales.ConversionFactor, sales.PurTaxAmt,sales.PurTaxPer ");
           sb.Append("     FROM ( ");
           sb.Append("       select sd.SalesID,sd.LedgerNumber,sd.DepartmentID,sd.StockID,sd.SoldUnits,sd.PerUnitBuyPrice,DATE_FORMAT(sd.Date,'%d %b %Y')as Date,sd.ItemID, ");
           sb.Append("       sd.IndentNo,sd.Naration,sd.Salesno,sd.IGSTPercent,sd.IGSTAmt,sd.CGSTPercent,sd.CGSTAmt,sd.SGSTPercent,sd.SGSTAmt,sd.GSTType,sd.HSNCode,  sd.PurTaxAmt,sd.PurTaxPer, ");
           sb.Append("       (SELECT InvoiceNo FROM f_stock WHERE stockid=sd.stockid)InvoiceNo, ");
           sb.Append("       (SELECT DATE_FORMAT(InvoiceDate,'%d-%b-%Y')InvoiceDate FROM f_stock WHERE stockid=sd.stockid)InvoiceDate, ");
           sb.Append("       (SELECT DATE_FORMAT(MedExpiryDate,'%d-%b-%Y')MedExpiryDate FROM f_stock WHERE stockid=sd.stockid)MedExpiryDate, ");
           sb.Append("       (SELECT BatchNumber FROM f_stock WHERE stockid=sd.stockid)BatchNumber, ");
           sb.Append("       (SELECT ConversionFactor FROM f_stock WHERE stockid=sd.stockid)ConversionFactor ");
           sb.Append("       from f_salesdetails sd ");
           sb.Append("       where sd.TrasactionTypeID=7 ");
           sb.Append(" )Sales inner join ");
           sb.Append(" f_ledgermaster ld on Sales.LedgerNumber=ld.LedgerNumber left join f_ledgermaster lm on Sales.DepartmentID=lm.LedgerNumber ");
           sb.Append(" inner join f_itemmaster itm on itm.ItemID=sales.ItemID inner join f_vendormaster ven on ven.Vendor_ID=ld.LedgerUserID ");
           sb.Append(" where Salesno='" + SalesNo + "' ");

           DataTable dt = StockReports.GetDataTable(sb.ToString());
           DataSet ds = new DataSet();
           DataColumn DC3 = new DataColumn("USER");
           DC3.DefaultValue = Session["LoginName"].ToString();
           dt.Columns.Add(DC3);
           ds.Tables.Add(dt.Copy());
           ds.Tables[0].TableName = "NRGP";
           //ds.WriteXml("C:/NRGP.xml");
           Session["ds"] = ds;
           Session["ReportName"] = "NRGP";
           ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/Commonreport.aspx');", true);
        }
    }
}