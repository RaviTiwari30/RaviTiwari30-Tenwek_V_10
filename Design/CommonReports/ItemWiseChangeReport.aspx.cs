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
using System.Web.Script.Services;

public partial class Design_EDP_ItemWiseChangeReport : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getItem(string categoryId, string subCategoryId, string ItemName, string Report_type)
    {
        StringBuilder sb = new StringBuilder();

        string Report_Name = string.Empty;
        sb.Append("");
        if (Report_type == "1")
        {
            Report_Name = "ITEM WISE VENDOR CHANGE REPORT";

            sb.Append("   select  im.`ItemID`,im.typeName ItemName,  ");
            sb.Append("    (SELECT lm.ledgerName FROM f_ledgermaster lm WHERE lm.LedgerNumber=(select st_in.VenLedgerNo from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1))CurrentVendor,  ");
            sb.Append("    (select date_format(st_in.stockdate,'%d-%b-%Y') from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1)CurrentDate, ");
            sb.Append("    (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(select st_in.UserID from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1))CurrentUser, ");
            sb.Append("    (SELECT lm.ledgerName FROM f_ledgermaster lm WHERE lm.LedgerNumber=(select st_in.VenLedgerNo from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 1,1))Vendor_Change, ");
            sb.Append("    (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1)Date_Change, ");
            sb.Append("    (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1))User_Change, ");
            sb.Append("    (SELECT lm.ledgerName FROM f_ledgermaster lm WHERE lm.LedgerNumber=(SELECT st_in.VenLedgerNo FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1))Vendor_Change, ");
            sb.Append("    (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1)Vendor_Date, ");
            sb.Append("    (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1))Vendor_User ");
            sb.Append("      from f_itemmaster im  ");
            sb.Append("    inner join f_subcategorymaster sc on im.`SubcategoryID`=sc.`SubCategoryID` ");
            sb.Append("      inner join f_configrelation cr on sc.`CategoryID`=cr.`CategoryID` ");
            sb.Append("      where  cr.ConfigID in(11,28)  ");

            if (!string.IsNullOrEmpty(categoryId))
                sb.Append(" and  sc.`CategoryID`='" + categoryId + "' ");
            if (!string.IsNullOrEmpty(subCategoryId) && subCategoryId != "0")
                sb.Append(" and  sc.`SubCategoryID`='" + subCategoryId + "' ");
            if (!string.IsNullOrEmpty(ItemName))
                sb.Append(" and  im.TypeName like '%" + ItemName + "%' ");
        }
        else if (Report_type == "2")
        {
            Report_Name = "MANUFACTURING COMPANY CHANGE REPORT";

            sb.Append(" select  im.`ItemID`,im.typeName ItemName, ");
            sb.Append("    (SELECT lm.NAME FROM f_manufacture_master lm WHERE lm.ManufactureID=(select st_in.Manufacturerid from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1))CurrentManufacturer, ");
            sb.Append("    (select date_format(st_in.stockdate,'%d-%b-%Y') from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1)CurrentDate, ");
            sb.Append("    (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(select st_in.UserID from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1))CurrentUser, ");
            sb.Append("    (SELECT lm.NAME FROM f_manufacture_master lm WHERE lm.ManufactureID=(select st_in.Manufacturerid from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 1,1))Manufacturer_Change, ");
            sb.Append("    (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1)Date_Change, ");
            sb.Append("    (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1))User_Change, ");
            sb.Append("    (SELECT lm.NAME FROM f_manufacture_master lm WHERE lm.ManufactureID=(SELECT st_in.Manufacturerid  FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1))Manufacturer_Change, ");
            sb.Append("    (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1)Date_Change, ");
            sb.Append("    (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1))User_Change ");
            sb.Append("     from f_itemmaster im ");
            sb.Append("    inner join f_subcategorymaster sc on im.`SubcategoryID`=sc.`SubCategoryID` ");
            sb.Append("   inner join f_configrelation cr on sc.`CategoryID`=cr.`CategoryID` ");
            sb.Append("      where  cr.ConfigID in(11,28)  ");

            if (!string.IsNullOrEmpty(categoryId))
                sb.Append(" and  sc.`CategoryID`='" + categoryId + "' ");
            if (!string.IsNullOrEmpty(subCategoryId) && subCategoryId != "0")
                sb.Append(" and  sc.`SubCategoryID`='" + subCategoryId + "' ");
            if (!string.IsNullOrEmpty(ItemName))
                sb.Append(" and  im.TypeName like '%" + ItemName + "%' ");



        }
        else if (Report_type == "3")
        {
            Report_Name = "ITEM WISE RATE CHANGE REPORT";


            sb.Append("  select  im.`ItemID`,im.typeName ItemName, ");
            sb.Append("  (select round(st_in.rate,2)Rate from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1)Current_Rate, ");
            sb.Append("  (select date_format(st_in.stockdate,'%d-%b-%Y') from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1)CurrentDate, ");
            sb.Append("  (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(select st_in.UserID from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1))CurrentUser, ");
            sb.Append("  (select round(st_in.rate,2)Rate from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 1,1)Rate_Change, ");
            sb.Append("  (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1)Date_Change, ");
            sb.Append("  (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1))User_Change, ");
            sb.Append("  (SELECT round(st_in.rate,2)Rate  FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1)Rate_Change, ");
            sb.Append("  (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1)Date_Change, ");
            sb.Append("  (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1))User_Change ");
            sb.Append("    from f_itemmaster im ");
            sb.Append("   inner join f_subcategorymaster sc on im.`SubcategoryID`=sc.`SubCategoryID` ");
            sb.Append("   inner join f_configrelation cr on sc.`CategoryID`=cr.`CategoryID` ");
            sb.Append("   where  cr.ConfigID in(11) ");
            if (!string.IsNullOrEmpty(categoryId))
                sb.Append(" and  sc.`CategoryID`='" + categoryId + "' ");
            if (!string.IsNullOrEmpty(subCategoryId) && subCategoryId != "0")
                sb.Append(" and  sc.`SubCategoryID`='" + subCategoryId + "' ");
            if (!string.IsNullOrEmpty(ItemName))
                sb.Append(" and  im.TypeName like '%" + ItemName + "%' ");


        }
        else if (Report_type == "4")
        {
            Report_Name = "ITEM WISE MRP CHANGE REPORT";


            sb.Append(" select  im.`ItemID`,im.typeName ItemName, ");
            sb.Append(" (select round(st_in.Mrp,2)Mrp from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1)Current_Mrp, ");
            sb.Append(" (select date_format(st_in.stockdate,'%d-%b-%Y') from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1)CurrentDate, ");
            sb.Append(" (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(select st_in.UserID from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 0,1))CurrentUser, ");
            sb.Append(" (select ROUND(st_in.Mrp,2)Mrp from f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo where st_in.itemid=im.itemid  ORDER BY (st_in.id)  desc limit 1,1)Mrp_Change, ");
            sb.Append(" (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1)Date_Change, ");
            sb.Append(" (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 1,1))User_Change, ");
            sb.Append(" (SELECT ROUND(st_in.Mrp,2)Mrp  FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1)Mrp_Change, ");
            sb.Append(" (SELECT DATE_FORMAT(st_in.stockdate,'%d-%b-%Y') FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1)Date_Change, ");
            sb.Append(" (SELECT em.NAME FROM employee_master em WHERE em.EmployeeID=(SELECT st_in.UserID FROM f_ledgertransaction lt_in INNER JOIN f_stock st_in ON lt_in.LedgerTransactionNo = st_in.LedgerTransactionNo WHERE st_in.itemid=im.itemid  ORDER BY (st_in.id)  DESC LIMIT 2,1))User_Change ");
            sb.Append("   from f_itemmaster im  ");
            sb.Append("   inner join f_subcategorymaster sc on im.`SubcategoryID`=sc.`SubCategoryID` ");
            sb.Append("   inner join f_configrelation cr on sc.`CategoryID`=cr.`CategoryID` ");
            sb.Append("   where  cr.ConfigID in(11) ");
            if (!string.IsNullOrEmpty(categoryId))
                sb.Append(" and  sc.`CategoryID`='" + categoryId + "' ");
            if (!string.IsNullOrEmpty(subCategoryId) && subCategoryId != "0")
                sb.Append(" and  sc.`SubCategoryID`='" + subCategoryId + "' ");
            if (!string.IsNullOrEmpty(ItemName))
                sb.Append(" and  im.TypeName like '%" + ItemName + "%' ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["ReportName"] = Report_Name;
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["Period"] = "";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, output = "../../Design/Common/ExportToExcel.aspx" });
        }

        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, output = "" });


    }

    [WebMethod]
    public static string GetAllCategory()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT cm.Name,cm.CategoryID,ConfigID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  Where  cf.ConfigID in(11,28) and cm.Active=1 ORDER BY cm.Name "));
    }
    [WebMethod]
    public static string GetSubCategoryByCategory(string categoryID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT SubCategoryID,sm.CategoryID,sm.Name,DisplayName,ConfigID,DisplayPriority FROM f_subcategorymaster sm INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid  WHERE sm.active=1 and sm.categoryid='" + categoryID + "' ORDER BY sm.DisplayPriority "));
    }
}
