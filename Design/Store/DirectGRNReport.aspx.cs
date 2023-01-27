using System;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;
using System.Text;

public partial class Design_Store_DirectGRNReport : System.Web.UI.Page
{

    private ReportDocument obj1 = new ReportDocument(); 
    protected void Page_Load(object sender, EventArgs e)
    {
        string query = string.Empty;
        string LedTranNo = "";
        if (Request.QueryString["Hos_GRN"] != null)
            LedTranNo = Request.QueryString["Hos_GRN"].ToString();
        else if (Request.QueryString["Proj_GRN"] != null)
            LedTranNo = Request.QueryString["Proj_GRN"].ToString();

        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT cm.CentreName,cm.CentreCode,cm.CentreID,BillNo as LedgerTransactionNO,Freight,IF(IFNULL(ven.DrugLicence,'')<>'',CONCAT(ven.VendorName,'(BRN :',ven.DrugLicence,')'),ven.VendorName)VendorName,CONCAT(Address1,' ',Address2)VendorAddress,lt.Hospital_ID,ldm.LedgerName,DATE,BillNo,BillDate,lt.InvoiceNo, ");
        sb.Append("   (DiscountonTotal/(SELECT IFNULL(CurrencyFactor,1)CurrencyFactor FROM f_stock  WHERE LedgertransactionNo=lt.LedgertransactionNo LIMIT 1))DiscountonTotal, ");
        sb.Append("   ROUND((NetAmount/(SELECT IFNULL(s.CurrencyFactor,1)CurrencyFactor FROM f_stock s WHERE s.LedgertransactionNo=lt.LedgertransactionNo LIMIT 1)),4)  NetAmount, ");
        sb.Append("   (GrossAmount/(SELECT IFNULL(s.CurrencyFactor,1)CurrencyFactor FROM f_stock s WHERE s.LedgertransactionNo=lt.LedgertransactionNo LIMIT 1))GrossAmount, ");
        sb.Append("   (CASE WHEN InvoiceDate='0001-01-01 00:00:00' THEN '' ELSE DATE_FORMAT(InvoiceDate,'%d-%b-%Y') END)AS InvoiceDate,inv.ChalanNo,inv.ChalanDate,Octori, ");
        sb.Append("   GatePassIn AS GatePassInWard,RoundOff,(SELECT NAME FROM employee_master WHERE EmployeeID=USERID)UserID,IFNULL(inv.DiffBillAmt,'0')DiffBillAmt, ");
        sb.Append("   (SELECT PaymentMode FROM paymentmode_master WHERE PaymentModeID=lt.PaymentModeID)GrnPaymentMode,lt.AgainstPONo,");
        sb.Append("   ven.ContactPerson,ven.Mobile AS vendorMobile,ven.Email AS VendorEmail, (Select DATE_FORMAT(PODate,'%d-%b-%Y')PODate from f_stock where LedgertransactionNo=lt.LedgertransactionNo LIMIT 1)PODate,(SELECT StateName FROM master_state WHERE StateID = ven.StateID)VendorState,ven.Ven_GSTINNo,");
        sb.Append("   (SELECT ifnull(s.Currency,'')Currency FROM f_stock s WHERE s.LedgertransactionNo=lt.LedgertransactionNo LIMIT 1)Currency FROM F_LEDGERTRANSACTION lt ");
        sb.Append("   INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=lt.LedgerNoCr    INNER JOIN f_vendormaster ven ON ven.Vendor_ID=lm.LedgerUserID ");
        sb.Append("   INNER JOIN f_ledgermaster ldm ON ldm.LedgerNumber=lt.LedgerNoDr  ");
        sb.Append("   INNER JOIN f_invoicemaster inv ON inv.LedgerTnxNo=lt.LedgerTransactionNO INNER JOIN center_master cm ON cm.CentreID=lt.CentreID   WHERE LedgertransactionNo='" + LedTranNo.Trim() + "' limit 1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            dt.Columns.Add("DiffBillAmountWord");
            string DiffBillAmount = Util.GetString(dt.Rows[0]["DiffBillAmt"].ToString());
            string DiffBillAmountWord = StockReports.ChangeNumericToWords(DiffBillAmount);
            dt.Rows[0]["DiffBillAmountWord"] = DiffBillAmountWord;
            dt.AcceptChanges();

            DataTable dtHeaderclient = StockReports.GetDataTable("select HeaderText,FooterText from Receipt_Header WHERE HeaderType='Pharmacy' AND CentreID=" + dt.Rows[0]["CentreID"].ToString() + " ");
            if (dtHeaderclient.Rows.Count <= 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong. Please Reopen This Report Or Contact To Admin..!<span></center>");
                return;
            }
            DataColumn dcheaderdetails = new DataColumn();
            dcheaderdetails.ColumnName = "HeaderDetails";
            dcheaderdetails.DefaultValue = dtHeaderclient.Rows[0]["HeaderText"].ToString();
            dt.Columns.Add(dcheaderdetails);

            DataColumn dcfotterdetails = new DataColumn();
            dcfotterdetails.ColumnName = "FotterDetails";
            dcfotterdetails.DefaultValue = dtHeaderclient.Rows[0]["FooterText"].ToString();
            dt.Columns.Add(dcfotterdetails);

            string ServiceSubGroup = StockReports.ExecuteScalar("SELECT GROUP_CONCAT(DISTINCT sc.NAME) FROM f_stock st INNER JOIN f_itemmaster im ON im.ItemID=st.ItemID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID= im.SubcategoryID WHERE LedgertransactionNo='" + LedTranNo.Trim() + "' ");
            DataColumn dcserviceSubGroup = new DataColumn();
            dcserviceSubGroup.ColumnName = "ServiceSubGroup";
            dcserviceSubGroup.DefaultValue = ServiceSubGroup;
            dt.Columns.Add(dcserviceSubGroup);
        }
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Header";

        //query = "SELECT iscancel,IF(im.IsExpirable='NO',' ',DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y'))MedExpiryDate,st.BatchNumber,lt.LedgertransactionNo,CONCAT(ltd.ItemName,' (',IFNULL(ltd.HSNCode,''),')')ItemName,ltd.ItemID, st.UnitType, st.Mrp*IFNULL(st.conversionFactor,1)Mrp,st.MajorMRP, st.Rate Rate ,st.MajorUnit,  im.IsExpirable,(st.InitialCount/st.conversionFactor) Quantity,Amount,(SELECT NAME FROM  employee_master emp WHERE emp.Employee_ID=ltd.userID )NAME,st.Naration,ltd.DiscountPercentage,st.StockID,IF(iscancel=0,IF(IsPost=0,'Non-Post','Post'),'Cancel')IsPost,IsPost,IF(ltd.IsVerified=3,'Rejected','NotRejected')ItemStatus,ltd.CancelReason,if(st.IsFree=0,'No','Yes')IsFree,IFNULL(ltd.DiscAmt,0)DiscAmt,IF(st.isfree=0,st.PurTaxAmt,0)PurTaxAmt,st.taxCalculateon,st.MinorUnit,CONCAT('1/',ROUND(st.conversionFactor))conversionFactor, " +
        //    " IFNULL(st.PurTaxPer,0)VATPer,IF(st.isfree=0,IFNULL(st.PurTaxAmt,0),0)VATAmt,IFNULL(st.ExcisePer,0)ExcisePer,IFNULL(st.ExciseAmt,0)ExciseAmt,st.isdeal,ltd.`SpecialDiscPer`,ltd.`specialDiscAmt`,LTD.CGSTAmt,IF(st.GSTType='CGST&UTGST',LTD.SGSTAmt,0)UTGSTAmt,IF(st.GSTType='CGST&SGST',LTD.SGSTAmt,0)SGSTAmt,LTD.IGSTAmt,ST.GSTType,LTD.CGSTPercent,LTD.SGSTPercent,LTD.IGSTPercent " +
        //    " FROM F_LEDGERTRANSACTION lt " +
        //    " inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNO=ltd.LedgerTransactionNo " +
        //    " inner join f_stock st on st.StockID=ltd.StockID INNER JOIN f_itemmaster im ON im.ItemID=st.ItemID WHERE lt.LedgertransactionNo='" + LedTranNo.Trim() + "'  ORDER BY st.stockid; ";
        //DataTable dt1 = StockReports.GetDataTable(query);

        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT iscancel,IF(im.IsExpirable='NO',' ',DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y'))MedExpiryDate,st.BatchNumber,lt.LedgertransactionNo,  ");
     //   sb1.Append("CONCAT(ltd.ItemName,' (',IFNULL(ltd.HSNCode,''),')')ItemName,ltd.ItemID, st.UnitType,st.CurrencyFactor,  ");
        sb1.Append("ltd.ItemName,IFNULL(ltd.HSNCode,'')HSNCode,ltd.ItemID, st.UnitType,st.CurrencyFactor,  ");
        sb1.Append("ROUND((st.Mrp/IFNULL(st.CurrencyFactor,1))*IFNULL(st.conversionFactor,1),4)Mrp,ROUND(st.MajorMRP/IFNULL(st.CurrencyFactor,1),4) AS MajorMRP ,   ");
        sb1.Append("IF(st.IsFree=0,ROUND(st.Rate/IFNULL(st.CurrencyFactor,1),4),0) Rate ,st.MajorUnit,  im.IsExpirable,(st.InitialCount/st.conversionFactor) Quantity, ");
        sb1.Append("IF(st.IsFree=0,ROUND(ltd.Amount/IFNULL(st.CurrencyFactor,1),4),0) AS Amount, (SELECT NAME FROM  employee_master emp WHERE emp.EmployeeID=ltd.userID )NAME,st.Naration, ");
        sb1.Append("ltd.DiscountPercentage,st.StockID, IF(iscancel=0,IF(IsPost=0,'Non-Post','Post'),'Cancel')IsPost,IF(ltd.IsVerified=3,'Rejected','NotRejected')ItemStatus, ");
        if (Resources.Resource.IsGSTApplicable == "1")
        {
            sb1.Append(" 1 IsPost, ");
        }
        else { sb1.Append(" 0 IsPost, "); }
        sb1.Append("ltd.CancelReason, IF(st.IsFree=0,'No','Yes')IsFree,ROUND(IFNULL(ltd.DiscAmt,0)/IFNULL(st.CurrencyFactor,1),4)DiscAmt, ");
        sb1.Append("IF(st.isfree=0,ROUND(st.PurTaxAmt/IFNULL(st.CurrencyFactor,1),4),0)PurTaxAmt,st.taxCalculateon,st.MinorUnit, CONCAT('1/',ROUND(st.conversionFactor))conversionFactor,   ");
        if (Resources.Resource.IsGSTApplicable == "1")
        {
            sb1.Append(" ROUND((IFNULL(ltd.IGSTAmt,0)+IFNULL(ltd.SGSTAmt,0)+IFNULL(ltd.CGSTAmt,0))/IFNULL(st.CurrencyFactor,1),2) VATAmt, ROUND(IFNULL(ltd.IGSTPercent,0)+IFNULL(ltd.SGSTPercent,0)+IFNULL(ltd.CGSTPercent,0),2) VATPer , ");
        }
        else 
        {
            sb1.Append(" IFNULL(st.PurTaxPer,0)VATPer,IF(st.isfree=0,ROUND(IFNULL(st.PurTaxAmt,0)/IFNULL(st.CurrencyFactor,1),4),0)VATAmt, ");
        }
        sb1.Append(" IFNULL(st.ExcisePer,0)ExcisePer, ");//IF(st.isfree=0,ROUND(IFNULL(st.PurTaxAmt,0)/IFNULL(st.CurrencyFactor,1),4),0), IFNULL(st.PurTaxPer,0)
        sb1.Append("ROUND(IFNULL(st.ExciseAmt,0)/IFNULL(st.CurrencyFactor,1),4) ExciseAmt,st.isdeal,ltd.`SpecialDiscPer`,ROUND(ltd.`specialDiscAmt`/IFNULL(st.CurrencyFactor,1),4) specialDiscAmt, ");
        sb1.Append("ROUND(LTD.CGSTAmt/IFNULL(st.CurrencyFactor,1),4) CGSTAmt, IF(st.GSTType='CGST&UTGST',ROUND(LTD.SGSTAmt/IFNULL(st.CurrencyFactor,1),0),4)UTGSTAmt, ");
        sb1.Append("IF(st.GSTType='CGST&SGST',ROUND(LTD.SGSTAmt/IFNULL(st.CurrencyFactor,1),0),4)SGSTAmt,ROUND(LTD.IGSTAmt/IFNULL(st.CurrencyFactor,1),4) IGSTAmt,ST.GSTType,LTD.CGSTPercent, ");
        sb1.Append("LTD.SGSTPercent, LTD.IGSTPercent,(SELECT CONCAT(em.title,' ',em.Name) FROM employee_master em WHERE em.EmployeeID=st.PostUserID) PostUserID,pdd.ApprovedQty  FROM F_LEDGERTRANSACTION lt  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNO=ltd.LedgerTransactionNo    ");
        sb1.Append("INNER JOIN f_stock st ON st.StockID=ltd.StockID INNER JOIN f_itemmaster im ON im.ItemID=st.ItemID ");
        sb1.Append("LEFT JOIN f_purchaseorderdetails pdd ON pdd.PurchaseOrderNo= st.PONumber AND pdd.ItemID= st.ItemID ");
        sb1.Append("WHERE lt.LedgertransactionNo='" + LedTranNo.Trim() + "' AND ltd.IsVerified<>2  ORDER BY st.stockid   ");

        
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());



        ds.Tables.Add(dt1.Copy());
        ds.Tables[1].TableName = "ItemDetail";
        //DataTable dt2 = new DataTable();
        //dt2 = StockReports.GetDataTable(" select TC.ItemID,TC.LedgerTransactionNo , IF((TC.Percentage = 0.00),'',TM.TaxName) AS TaxName,  IF((TC.Percentage = 0.00),'',percentage) as TaxPercentage,StockID from  (select ltd.ItemID, a.TaxID, a.Percentage , lt.LedgerTransactionNo,ltd.StockID from f_ledgertransaction  lt inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo=ltd.LedgerTransactionNo left outer join   f_taxchargedlist a on a.LedgertransactionNo=lt.LedgertransactionNo and ltd.StockID=a.StockID where lt.LedgerTransactionNo ='" + Request.QueryString["Hos_GRN"].ToString() + "' group by ltd.ItemID,ltd.StockID)TC left outer join  f_taxmaster TM  on TC.TaxID = TM.TaxID  ");
        //ds.Tables.Add(dt2.Copy());
        //ds.Tables[2].TableName = "DetailsTax";

        DataColumn dc = new DataColumn("AmountToWord");
        decimal NetAmount = Util.GetDecimal(ds.Tables["ItemDetail"].Compute("sum(Amount)", "ItemStatus='NotRejected'"));
        decimal RoundOff = Convert.ToDecimal(ds.Tables[0].Rows[0]["RoundOff"]);
        decimal Octori = Convert.ToDecimal(ds.Tables[0].Rows[0]["Octori"]);
        decimal Freight = Convert.ToDecimal(ds.Tables[0].Rows[0]["Freight"]);



        //decimal AmountInWrod = Util.GetDecimal(((NetAmount + Octori + Freight) + RoundOff));
        decimal AmountInWrod = Util.GetDecimal(dt.Rows[0]["NetAmount"].ToString());
        string a = ConvertCurrencyInWord.AmountInWord(Convert.ToDecimal(AmountInWrod), Resources.Resource.BaseCurrencyNotation) + " Only.";
        dc.DefaultValue = ((a));
        ds.Tables[0].Columns.Add(dc);

        

        DataColumn dc1 = new DataColumn("PrintUser");
        dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0].ToString();
        ds.Tables[0].Columns.Add(dc1);


        DataTable dtImg = new DataTable();
        dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());

        //ds.WriteXmlSchema(@"E:\DirectGRN.xml");
        //ReportDocument obj1 = new ReportDocument();
        obj1.Load(Server.MapPath("~/Reports/Reports/DirectGRNCarbon.rpt"));

         obj1.SetDataSource(ds);
         //System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
         //obj1.Close();
         //obj1.Dispose();
         //Response.ClearContent();
         //Response.ClearHeaders();
         //Response.Buffer = true;
         //Response.ContentType = "application/pdf";
         //Response.BinaryWrite(m.ToArray());
         //m.Flush();
         //m.Close();
         //m.Dispose();
		 
        // System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
        //obj1.Close();
        //obj1.Dispose();
        //Response.ClearContent();
        //Response.ClearHeaders();
        //Response.Buffer = true;
        //Response.ContentType = "application/pdf";
        //Response.BinaryWrite(m.ToArray());

        // System.IO.Stream oStream = null;
        // byte[] byteArray = null;
        // oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
        // byteArray = new byte[oStream.Length];
        // oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
        // obj1.Close();
        // obj1.Dispose();
        // Response.ClearContent();
        // Response.ClearHeaders();
        // Response.ContentType = "application/pdf";
        // Response.BinaryWrite(byteArray);
        // Response.Flush();
        // Response.Close();
		// ds.Dispose();


         System.IO.Stream oStream = null;
         byte[] byteArray = null;
         oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
         byteArray = new byte[oStream.Length];
         oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
         obj1.Close();
         obj1.Dispose();
         Response.ClearContent();
         Response.ClearHeaders();
         Response.Buffer = true;
         Response.ContentType = "application/pdf";
         Response.BinaryWrite(byteArray);

         System.Drawing.Printing.PrinterSettings printer = new System.Drawing.Printing.PrinterSettings();
         System.Drawing.Printing.PageSettings page = new System.Drawing.Printing.PageSettings();


    }
    public DataTable GetTaxDetails(string LTNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select tc.Percentage as TaxPercentage,tc.StockID,tm.TaxName,LedgerTransactionNo,ItemID from f_nmtaxchargedlist tc inner join f_taxmaster tm");
        sb.Append(" on tc.taxid = tm.taxid where tc.LedgerTransactionNo = '" + LTNo + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
		
	protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
        }
    }

}
