using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_PharmacyAnalysisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = (new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string ProfitSummary(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT 'Total Sales of the Period:-' AS Title,ROUND(IFNULL(SUM(lt.NetAmount),0),2) AS TotalAmount,'1' AS Rupee FROM f_ledgertransaction lt ");
        query.Append(" WHERE lt.TypeOfTnx IN ('Sales','Pharmacy-Issue') AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Total Purchase of the Period:-' AS Title,ROUND(IFNULL(SUM(lt.NetAmount+lt.RoundOff),0),2) AS TotalAmount,'1' AS Rupee ");
        query.Append(" FROM f_ledgertransaction lt WHERE lt.IsCancel=0 AND lt.TypeOfTnx ='Purchase' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Total Sales Returned of the Period:-' AS Title,ROUND(IFNULL(SUM(lt.NetAmount),0),2) AS TotalAmount,'1' AS Rupee FROM f_ledgertransaction lt ");
        query.Append(" WHERE lt.TypeOfTnx IN ('Patient-Return','Pharmacy-Return') AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Total Purchase Returned of the Period:-' AS Title,ROUND(IFNULL(SUM(lt.NetAmount+lt.RoundOff),0),2) AS TotalAmount,'1' AS Rupee FROM f_ledgertransaction lt ");
        query.Append(" WHERE lt.IsCancel=0 AND lt.TypeOfTnx IN ('Vendor-return') AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Total Sales VAT of the Period:-' AS Title,ROUND(IFNULL(SUM(((sd.PerUnitSellingPrice-((sd.PerUnitSellingPrice*100)/(100+IF(IFNULL(s.PurTaxPer,0)>0,IFNULL(s.PurTaxPer,0),IFNULL(s.SaleTaxPer,0)))))*sd.soldUnits)),0),2) AS TotalAmount,'1' AS Rupee ");
        query.Append(" FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID WHERE sd.TrasactionTypeID  IN (16,3) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Total Cost of Goods Sold:-' AS Title,ROUND(IFNULL(SUM(sd.PerUnitBuyPrice*sd.SoldUnits),0),2) AS TotalAmount,'1' AS Rupee FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID ");
        query.Append(" WHERE sd.TrasactionTypeID  IN (16,3) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Total Cost of Goods Returned:-' AS Title,ROUND(IFNULL(SUM(sd.PerUnitBuyPrice*sd.SoldUnits),0),2) AS TotalAmount,'1' AS Rupee FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID ");
        query.Append(" WHERE sd.TrasactionTypeID  IN (17,5) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Gross Profit Margin:-' AS Title,ROUND(IFNULL((SalePrice - CostPrice - Tax),0),2) AS TotalAmount,'1' AS Rupee  FROM ( SELECT  ROUND(SUM(sd.PerUnitSellingPrice*sd.SoldUnits))SalePrice,ROUND(SUM(sd.PerUnitBuyPrice*sd.SoldUnits))CostPrice, ");
        query.Append(" ROUND(SUM(((sd.PerUnitSellingPrice-((sd.PerUnitSellingPrice*100)/(100+IF(IFNULL(s.PurTaxPer,0)>0,IFNULL(s.PurTaxPer,0),IFNULL(s.SaleTaxPer,0)))))*sd.soldUnits)))Tax ");
        query.Append(" FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID WHERE sd.TrasactionTypeID  IN (16,3,17,5) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "')t");

        query.Append(" UNION ALL SELECT 'Gross Profit Margin (%):-' AS Title,ROUND(IFNULL(((SalePrice - CostPrice - Tax)/SalePrice)*100,0),2) AS TotalAmount,'0' AS Rupee FROM (SELECT  ROUND(SUM(sd.PerUnitSellingPrice*sd.SoldUnits))SalePrice,ROUND(SUM(sd.PerUnitBuyPrice*sd.SoldUnits))CostPrice, ");
        query.Append(" ROUND(SUM(((sd.PerUnitSellingPrice-((sd.PerUnitSellingPrice*100)/(100+IF(IFNULL(s.PurTaxPer,0)>0,IFNULL(s.PurTaxPer,0),IFNULL(s.SaleTaxPer,0)))))*sd.soldUnits)))Tax ");
        query.Append(" FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID	WHERE sd.TrasactionTypeID  IN (16,3,17,5) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "')t ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string InventoryAnalysis(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();

        query.Append(" SELECT 'Current Inventory Value In PP (Exclusive expired products & VAT)' AS Title,ROUND(IFNULL(SUM(UnitPrice*(InitialCount-ReleasedCount)),0)) AS Amount,'1' AS IsRupee ");
        query.Append(" FROM f_stock WHERE ispost=1 AND InitialCount-ReleasedCount >0 AND MedExpiryDate>'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Current Inventory Value In MRP (Exclusive expired products)' AS Title,ROUND(IFNULL(SUM(MRP*(InitialCount-ReleasedCount)),0)) AS Amount,'1' AS IsRupee ");
        query.Append(" FROM f_stock WHERE ispost=1 AND InitialCount-ReleasedCount >0 AND MedExpiryDate>'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Average Daily Sales' AS Title,ROUND(IFNULL(SUM(lt.NetAmount),0)/DATEDIFF('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "')) AS AvgDailySale,'1' AS IsRupee ");
        query.Append(" FROM f_ledgertransaction lt WHERE lt.TypeOfTnx IN ('Sale','Pharmacy-Issue') AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        query.Append(" UNION ALL SELECT 'Stock Available for Next' AS Title,CONCAT(FLOOR(a.StockValue/b.AvgDailySale),' Days') AS Amount,'0' AS IsRupee ");
        query.Append(" FROM ( SELECT ROUND(SUM(MRP*(InitialCount-ReleasedCount))) AS StockValue FROM f_stock WHERE ispost=1 AND InitialCount-ReleasedCount >0 AND MedExpiryDate>'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "')a, ");
        query.Append(" (SELECT ROUND(SUM(IFNULL(lt.NetAmount,0))/DATEDIFF('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "')) AS AvgDailySale FROM f_ledgertransaction lt WHERE lt.TypeOfTnx IN ('Sale','Pharmacy-Issue') AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "')b ");

        query.Append(" UNION ALL SELECT 'Value of Expiry Goods In Next 90 Days' AS Title,ROUND(IFNULL(SUM(UnitPrice*(InitialCount-ReleasedCount)),0)) AS Amount,'1' AS IsRupee ");
        query.Append(" FROM f_stock WHERE ispost=1 AND InitialCount-ReleasedCount >0 AND MedExpiryDate>='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND MedExpiryDate <=ADDDATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "',INTERVAL 3 MONTH) ");

        query.Append(" UNION ALL SELECT 'Value of Already Expired Goods' AS Title,ROUND(IFNULL(SUM(st.unitPrice * (st.InitialCount-st.ReleasedCount)),0)) AS Amount,'1' AS IsRupee ");
        query.Append(" FROM f_stock st LEFT JOIN f_salesdetails sd ON st.StockID = sd.StockID AND sd.TrasactionTypeID IN (16,17,3,5) WHERE sd.StockID IS NULL AND st.InitialCount-st.ReleasedCount >0 and st.MedExpiryDate < '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string TopSellingProducts(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT t1.ItemName,ROUND((t1.Amt),2)Amount FROM (SELECT s.ItemName,SUM(sd.PerUnitSellingPrice*sd.SoldUnits)Amt FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID ");
        query.Append(" WHERE sd.TrasactionTypeID  IN (16,3) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.Date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY sd.ItemID ORDER BY amt DESC LIMIT 10 )t1 ");

        query.Append(" UNION ALL SELECT 'Others' ItemName,ROUND(SUM(Amt),2)Amount FROM (SELECT s.ItemName,SUM(sd.PerUnitSellingPrice*sd.SoldUnits)Amt FROM f_salesdetails sd  INNER JOIN f_stock s ON s.StockID=sd.StockID ");
        query.Append(" WHERE sd.TrasactionTypeID  IN (16,3) AND DATE(sd.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(sd.Date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY sd.ItemID ORDER BY amt DESC LIMIT 10,1000000000 )t ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 1)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string TopPurchasedProducts(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT * FROM (SELECT ltd.ItemName,ROUND(SUM(ltd.Amount),0)Amount FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
        query.Append(" WHERE lt.IsCancel=0 AND lt.TypeOfTnx ='Purchase' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY ltd.ItemID ORDER BY Amount DESC LIMIT 10 )t1 ");
        query.Append(" UNION ALL SELECT 'Others' ItemName,ROUND(SUM(Amount),0)Amount FROM (SELECT ltd.ItemName,SUM(ltd.Amount)Amount FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
        query.Append(" WHERE lt.IsCancel=0 AND lt.TypeOfTnx ='Purchase' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY ltd.ItemID ORDER BY Amount  DESC LIMIT 10,1000000000 )t2 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 1)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string ConsultantStatistics(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT CONCAT('Dr. ',dm.Name)Doctor,SUM(lt.NetAmount)Amount,COUNT(pmh.TransactionID)NoOfPrescriptions FROM f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ");
        query.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID WHERE lt.TypeOfTnx IN ('pharmacy-issue','sales') AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
        query.Append(" GROUP BY pmh.DoctorID ORDER BY Amount DESC LIMIT 10 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string TopSalesperson(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT Employee,NoOfOrders,Amount,ROUND((Amount/TotalSale)*100,2)Percent FROM ( SELECT CONCAT(em.Title,' ',em.Name)Employee,SUM(lt.NetAmount)Amount,COUNT(lt.LedgerTransactionNo)NoOfOrders FROM f_ledgertransaction lt INNER JOIN employee_master em ON em.EmployeeID = lt.UserID ");
        query.Append(" WHERE lt.TypeOfTnx IN ('pharmacy-issue','sales') AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND  DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY em.EmployeeID ORDER BY Amount DESC LIMIT 10 )t1, ");

        query.Append(" (SELECT SUM(IFNULL(lt.NetAmount,0))TotalSale FROM f_ledgertransaction lt WHERE lt.TypeOfTnx IN ('Sale','Pharmacy-Issue') ");
        query.Append(" AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND  DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' )t2 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string TopSuppliers(string fromDate, string toDate)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT LedgerName,NetPurchase,No_Of_GRN,ROUND((NetPurchase/TotalSale)*100,2)Percent FROM (SELECT lm.LedgerName, ROUND(SUM(lt.NetAmount+lt.RoundOff))NetPurchase,COUNT(lt.LedgerTransactionNo)No_Of_GRN FROM f_ledgertransaction lt INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = lt.LedgerNoCr ");
        query.Append(" WHERE lt.IsCancel=0 AND lt.TypeOfTnx ='Purchase'	AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND  DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY lt.LedgerNoCr ORDER BY NetPurchase DESC LIMIT 5 )t1, ");

        query.Append(" (SELECT SUM(IFNULL(lt.NetAmount,0))TotalSale FROM f_ledgertransaction lt WHERE lt.TypeOfTnx IN ('Sale','Pharmacy-Issue')	AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' ");
        query.Append(" AND DATE(lt.date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND  DATE(lt.date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' )t2 ");
        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string SalesTrend(string Year)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT DATE_FORMAT(lt.date,'%M') AS `Month`,ROUND(IFNULL(SUM(lt.NetAmount),0),2) AS Amount FROM f_ledgertransaction lt WHERE lt.TypeOfTnx IN ('Sales','Pharmacy-Issue') AND DeptLedgerNo='" + Resources.Resource.PharmacyDeptLedgerNo + "' ");
        query.Append(" AND YEAR(lt.date)='" + Year + "' GROUP BY MONTH(lt.date) ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }
}