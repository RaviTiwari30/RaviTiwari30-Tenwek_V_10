using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_OPDIPDPackageProfitLoss : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();
            All_LoadData.bindPanel(ddlPanel, "All");
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        string SubCategoryID = "('LSHHI117'),('LSHHI491'),('LSHHI221'),('LSHHI423'),('LSHHI424'),('LSHHI425'),('LSHHI493'),('LSHHI426'),('LSHHI427'),('LSHHI428'),('LSHHI429'),('LSHHI220'),('LSHHI492'),('LSHHI430'),('LSHHI431'),('LSHHI432'),('LSHHI433'),('LSHHI434'),('LSHHI435'),('LSHHI494'),('LSHHI436'),('LSHHI495'),('LSHHI437'),('LSHHI438'),('LSHHI439'),('LSHHI440'),('LSHHI334'),('LSHHI441'),('LSHHI496'),('LSHHI442'),('LSHHI497'),('LSHHI117'),('LSHHI443'),('LSHHI24')";
        CreateTempTable(SubCategoryID, "tmpSubCat" + Session["ID"].ToString(), "SubCategoryID");  //"('LSHHI117')"

        //sb.Append("SELECT adj.PatientID 'UHID',Pm.PName,(SELECT CONCAT(dm.`Title`,' ',dm.`Name`) FROM doctor_master dm WHERE DoctorID=ltd.DoctorID)'Consultant', (SELECT pmh.DoctorID1 FROM patient_medical_history pmh WHERE pmh.transactionID=ltd.transactionID)'ref Consultant Name', ");
        //sb.Append(" adj.BillNo,DATE_FORMAT(adj.`BillDate` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO', (SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=adj.PanelID) 'Panel Name','IPD' TYPE,ltd.ItemName 'Package Name', ");
        //sb.Append(" (SELECT GROUP_CONCAT(ltdd.ItemName) FROM f_ledgertnxdetail ltdd WHERE ltdd.PackageID=ltd.`ItemID` AND ltdd.IsPackage=1)'Itemname', ");
        //sb.Append(" (SELECT  GROUP_CONCAT(DISTINCT sm.name) FROM f_ledgertnxdetail ltd1 INNER JOIN `f_subcategorymaster` sm ON ltd1.SubCategoryID=sm.SubCategoryID  WHERE ltd1.PackageID=ltd.`ItemID`)'SubCategory', ");
        //sb.Append(" (SELECT SUM(ltdd.Rate*ltdd.Quantity) FROM f_ledgertnxdetail ltdd WHERE ltdd.PackageID=ltd.`ItemID` AND ltdd.IsPackage=1  ) 'ServiceAmt', ");
        //sb.Append(" ( SELECT cm.Name FROM f_Categorymaster cm WHERE cm.CategoryID=(SELECT sub.CategoryID FROM `f_subcategorymaster` sub WHERE sub.SubcategoryID=ltd.`SubCategoryID`))'Category', ");
        //sb.Append("  ltd.Amount 'PackageAmt',   ltd.Amount  'Service Actual Amt' ");
        //sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_ipdadjustment adj ON adj.transactionID = ltd.transactionID ");
        //sb.Append("  INNER JOIN patient_master PM ON pm.PatientID = adj.PatientID INNER JOIN tmpSubCatEMP001 tsc ON tsc.SubCategoryID = ltd.SubCategoryID ");
        //sb.Append(" WHERE ltd.isverified=1 AND adj.CentreID IN (" + Session["CentreID"].ToString() + ")   AND DATE(adj.`BillDate`)  >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.`BillDate`)  <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

        /*************************************************************************************************************************************/
        //sb.Append(" UNION ALL ");

        //sb.Append(" SELECT pm.`PatientID` 'UHID',Pm.PName,(SELECT CONCAT(dm.`Title`,' ',dm.`Name`) FROM doctor_master dm WHERE DoctorID=ltd.DoctorID)'Consultant', ");
        //sb.Append(" (SELECT pmh.DoctorID1 FROM patient_medical_history pmh WHERE pmh.transactionID=ltd.transactionID)'ref Consultant Name', ");
        //sb.Append(" lt.`BillNo`,DATE_FORMAT(lt.`BillDate` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO', ");
        //sb.Append(" (SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=lt.`PanelID`) 'Panel Name','OPD' TYPE,ltd.ItemName 'Package Name', ");
        //sb.Append(" (SELECT GROUP_CONCAT(ltdd.ItemName) FROM f_ledgertnxdetail ltdd WHERE ltdd.PackageID=ltd.`ItemID` AND ltdd.IsPackage=1)'Itemname', ");
        //sb.Append(" (SELECT  GROUP_CONCAT(DISTINCT sm.name) FROM f_ledgertnxdetail ltd1 INNER JOIN `f_subcategorymaster` sm ON ltd1.SubCategoryID=sm.SubCategoryID  WHERE ltd1.PackageID=ltd.`ItemID`)'SubCategory', ");
        //sb.Append(" (SELECT SUM(ltdd.Rate*ltdd.Quantity) FROM f_ledgertnxdetail ltdd WHERE ltdd.PackageID=ltd.`ItemID` AND ltdd.IsPackage=1  ) 'ServiceAmt', ");
        //sb.Append(" '' Category, ltd.Amount 'PackageAmt',   ltd.Amount  'Service Actual Amt' ");
        //sb.Append("  FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo   INNER JOIN patient_master PM ON pm.PatientID = lt.PatientID INNER JOIN tmpSubCatEMP001 tsc ON tsc.SubCategoryID = ltd.SubCategoryID ");
        //sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + "' AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + "'  AND lt.IsCancel=0 AND ltd.Type='O'   	AND lt.CentreID IN (" + Session["CentreID"].ToString() + ") ");
        /**************************************************************************************************************************************/

        //sb.Append(" Select t11.* from ( ");

        //sb.Append("SELECT t2.* FROM (  SELECT lt.`PatientID` 'UHID',pm.`PName`, lt.BillNo, DATE_FORMAT(lt.`Date` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO','OPD' TYPE,ltd.ItemName 'Package Name',  ");
        //sb.Append(" IFNULL(ltd.Amount,0) 'PackageAmt',   0  'Service Actual Amt',(SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=lt.`PanelID`) 'Panel Name',lt.`PanelID` PanelID  FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo   INNER JOIN patient_master PM ON pm.PatientID = lt.PatientID  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ");
        //sb.Append("  INNER JOIN tmpSubCatEMP001 tsc ON tsc.SubCategoryID = ltd.SubCategoryID  WHERE lt.Date >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  AND ltd.`IsPackage`=0 AND ltd.`PackageID`=''   AND lt.IsCancel=0 AND ltd.Type='O'   	AND lt.CentreID IN ('" + Session["CentreID"].ToString() + "') GROUP BY ltd.`ItemID` ");

        //sb.Append(" UNION ALL ");

        //sb.Append(" SELECT lt.`PatientID` 'UHID',pm.`PName`, lt.BillNo,DATE_FORMAT(lt.`Date` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO','OPD' TYPE,ltd.ItemName 'Package Name', 0 'PackageAmt',   IFNULL(SUM(ltd.`Rate`*ltd.`Quantity`),0)  'Service Actual Amt',(SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=lt.`PanelID`) 'Panel Name',lt.`PanelID` PanelID ");
        //sb.Append("  FROM f_ledgertransaction lt   INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo INNER JOIN patient_master PM ON pm.PatientID = lt.PatientID  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID  WHERE lt.Date >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND ltd.`IsPackage`=1 AND lt.IsCancel=0 AND ltd.Type='O'   	AND lt.CentreID IN ('" + Session["CentreID"].ToString() + "') GROUP BY ltd.`PackageID`,ltd.`ItemID` )t2");  // OPD packages end (OPD)

        //sb.Append(" UNION ALL ");

        //sb.Append(" SELECT t3.* FROM ( SELECT adj.`PatientID` 'UHID',pm.`PName`,adj.BillNo,DATE_FORMAT(adj.`billDate` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO','IPD' TYPE,ltd.ItemName 'Package Name', IFNULL(ltd.Amount,0) 'PackageAmt',   0  'Service Actual Amt',(SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=adj.`PanelID`) 'Panel Name',adj.`PanelID` ");
        //sb.Append("  FROM f_ledgertnxdetail ltd  INNER JOIN f_ipdadjustment adj ON adj.transactionID = ltd.transactionID  INNER JOIN patient_master PM ON pm.PatientID = adj.PatientID   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID  INNER JOIN tmpSubCatEMP001 tsc ON tsc.SubCategoryID = ltd.SubCategoryID  WHERE ltd.isverified=1  AND adj.CentreID IN ('" + Session["CentreID"].ToString() + "') AND ltd.`IsPackage`=0 AND ltd.`PackageID`='' AND DATE(adj.billDate)  >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate)  <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY ltd.`ItemID` ");

        //sb.Append(" UNION ALL ");

        //sb.Append(" SELECT adj.`PatientID` 'UHID',pm.`PName`, adj.BillNo,DATE_FORMAT(adj.`billDate` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO','IPD' TYPE,ltd.ItemName 'Package Name', 0 'PackageAmt',   IFNULL(SUM(ltd.`Rate`*ltd.`Quantity`),0)  'Service Actual Amt',(SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=adj.`PanelID`) 'Panel Name',adj.`PanelID` ");
        //sb.Append(" FROM f_ledgertnxdetail ltd  INNER JOIN f_ipdadjustment adj ON adj.transactionID = ltd.transactionID  INNER JOIN patient_master PM ON pm.PatientID = adj.PatientID   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID INNER JOIN tmpSubCatEMP001 tsc ON tsc.SubCategoryID = ltd.SubCategoryID   WHERE ltd.isverified=1  AND adj.CentreID IN ('" + Session["CentreID"].ToString() + "')  AND ltd.`IsPackage`=1 AND DATE(adj.billDate)  >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate)  <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY ltd.`PackageID`,ltd.`ItemID` )t3 "); // OPD packages end (IPD)

        //sb.Append(" UNION ALL ");

        //sb.Append(" SELECT t4.* FROM ( SELECT adj.PatientID 'UHID',Pm.PName,adj.BillNo,DATE_FORMAT(adj.`BillDate` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO','IPD' TYPE,ltd.ItemName 'Package Name',IFNULL(ltd.Amount,0) 'PackageAmt',   0  'Service Actual Amt', (SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=adj.PanelID) 'Panel Name',adj.`PanelID` ");
        //sb.Append(" FROM f_ledgertnxdetail ltd  INNER JOIN f_ipdadjustment adj ON adj.transactionID = ltd.transactionID  INNER JOIN patient_master PM ON pm.PatientID = adj.PatientID INNER JOIN tmpSubCatEMP001 tsc ON tsc.SubCategoryID = ltd.SubCategoryID WHERE ltd.isverified=1 AND adj.CentreID IN ('" + Session["CentreID"].ToString() + "')   AND ltd.`IsPackage`=0 AND ltd.`PackageID`='' AND DATE(adj.`BillDate`)  >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.`BillDate`)<= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY ltd.`ItemID` )t4");

        //sb.Append(" UNION ALL ");

        //sb.Append(" SELECT t5.* FROM ( SELECT adj.PatientID 'UHID',Pm.PName,adj.BillNo,DATE_FORMAT(adj.`BillDate` ,'%d-%b-%y') 'BillDate',REPLACE(ltd.`transactionID`,'ISHHI','')'IPDNO','IPD' TYPE,ltd.ItemName 'Package Name',0 'PackageAmt',   IFNULL(SUM(ltd.`Rate`*ltd.`Quantity`),0)  'Service Actual Amt',(SELECT pnl.Company_Name FROM f_panel_master pnl WHERE pnl.PanelID=adj.PanelID) 'Panel Name',adj.`PanelID` ");
        //sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_ipdadjustment adj ON adj.transactionID = ltd.transactionID  INNER JOIN patient_master PM ON pm.PatientID = adj.PatientID WHERE ltd.isverified=1 AND adj.CentreID IN ('" + Session["CentreID"].ToString() + "')   AND ltd.`IsPackage`=1  AND DATE(adj.`BillDate`)  >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.`BillDate`)<= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' Group by ltd.PackageID  )t5");

        //sb.Append(" )t11  ");

        //if (ddlPanel.SelectedValue != "0")
        //{
        //    sb.Append(" WHERE t11.PanelID='" + ddlPanel.SelectedValue + "' ");
        //}

        //sb.Append(" ORDER BY t11.BillNo ");

        /**********************************************************************************/

        sb.Append("SELECT PatientID 'UHID',Patientname,Consultant,BillDate,BillNo,if(TID is null,NetAmount,BillAmt)'BillAmt',REPLACE(transactionID,'ISHHI','')'IPDNO',Panel,TYPE ");
        sb.Append(" ,GROUP_CONCAT(DISTINCT PackageName)PackageName, GROUP_CONCAT(CONCAT(Servicename,' Qty : ',Quantity) SEPARATOR ',')'Itemname',Service_Actual_Amt,PkgAmt ");
        sb.Append(" FROM ( SELECT lt.`PatientID`,ltd.`transactionID`,ltd.`ItemID`, ltd. PackageID, IF(adj.`transactionID` IS NULL,lt.`BillDate`,adj.`BillDate`)'BillDate',adj.`transactionID`'TID',lt.NetAmount, ");
        sb.Append(" (SELECT SUM(ltx.Rate*ltx.Quantity)-ROUND(SUM(((ltx.Rate*ltx.Quantity)*ltx.DiscountPercentage)/100) +IFNULL(adj.DiscountOnBill,0),2)  FROM f_ledgertnxdetail ltx WHERE  ltx.`transactionID` = ltd.`transactionID` AND ltx.IsFree = 0 AND ltx.IsVerified = 1 AND ltx.IsPackage = 0 AND ltx.`ConfigID` IN (14,23)) 'BillAmt', ");//ltx.`ItemID` = ltd.`PackageID` AND
        sb.Append(" IF(adj.`transactionID` IS NULL,lt.BillNo,adj.BillNo)'BillNo', (SELECT Company_Name FROM f_panel_master WHERE PanelID=lt.`PanelID`)'Panel', ltd.Type,(SELECT NAME FROM f_subcategorymaster WHERE SubcategoryID=ltd.`SubCategoryID`)'Subcategory', ");
        sb.Append(" (SELECT SUM(ltdd.`Rate`*ltdd.`Quantity`) FROM f_ledgertnxdetail ltdd WHERE ltdd.IsVerified=1 AND ltdd.`ConfigID` IN (14,23) AND ltdd.`transactionID` = ltd.`transactionID` LIMIT 1)'PkgAmt', ");
        sb.Append(" (SELECT ROUND((SUM(ll.`Rate`*ll.`Quantity`))-(SUM(((ll.Rate * ll.Quantity)*ll.DiscountPercentage)/100)),2) FROM f_ledgertnxdetail ll WHERE ll.ISpackage=1 AND ll.IsVerified=1 AND ll.`transactionID` = ltd.`transactionID`)'Service_Actual_Amt', ");
        sb.Append(" (SELECT CONCAT(dm.Title,' ',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID) 'Consultant',(SELECT pm.PName FROM patient_master pm WHERE pm.PatientID=lt.PatientID)'Patientname', (SELECT GROUP_CONCAT(DISTINCT ItemName) FROM f_ledgertnxdetail l WHERE  l.`transactionID` = ltd.`transactionID` AND l.IsVerified=1 AND l.`ConfigID` IN (14,23) LIMIT 1) PackageName, ");//l.`ItemID` = ltd.`PackageID` AND
        sb.Append(" ltd.`ItemName` Servicename,SUM(ltd.`Quantity`)Quantity FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ltd.`LedgerTransactionNo` = lt.`LedgerTransactionNo` LEFT JOIN patient_medical_history adj ON adj.`transactionID` = ltd.`transactionID` WHERE ltd.`IsVerified`=1 AND ltd.`IsPackage`=1 ");
        if (ddlPanel.SelectedValue != "0")
        {
            sb.Append(" AND lt.`PanelID`='" + ddlPanel.SelectedValue + "' ");
        }
        sb.Append(" AND IF(adj.`transactionID` IS NULL,(lt.`BillDate` BETWEEN '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'),adj.`BillDate` BETWEEN '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "') ");
        sb.Append(" GROUP BY ltd.`transactionID`,ltd.`ItemID` )p GROUP BY transactionID ");

        dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        decimal pakgTotal = 0, servicetotal = 0, netprofit = 0;
        dt.Columns.Add("Net ProfitLoss");
        //dt.Columns.Remove("PanelID");
        if (dt.Rows.Count > 0)
        {
            DataRow drr = dt.NewRow();
            foreach (DataRow dr in dt.Rows)
            {
                decimal packgamt = Util.GetDecimal(dr["PkgAmt"]);
                pakgTotal = pakgTotal + packgamt;
                decimal serviceamt = Util.GetDecimal(dr["Service_Actual_Amt"]);
                servicetotal = servicetotal + serviceamt;
                decimal net = packgamt - serviceamt;
                dr["Net ProfitLoss"] = net.ToString();
                netprofit = netprofit + net;
                drr["Net ProfitLoss"] = netprofit;
                drr["PkgAmt"] = pakgTotal;
                drr["Service_Actual_Amt"] = servicetotal;
            }
            dt.Rows.Add(drr);
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "OPD And IPD Packges Profit And Loss Report";
            Session["Period"] = "From : " + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + " To :" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }

    }

    private void CreateTempTable(string Data, string tableName, string ColName )//string Data2
    {
        try
        {
            if (Data != string.Empty)
            {
                StockReports.ExecuteDML("Drop table if exists " + tableName);

                string str = "CREATE TABLE " + tableName + " (" + ColName + " VARCHAR(20), INDEX(" + ColName + "))";
                StockReports.ExecuteDML(str);

                str = "Insert into " + tableName + " values " + Data;
              //  string str2 = "Insert into " + tableName + " values " + Data2;
                StockReports.ExecuteDML(str);
               // StockReports.ExecuteDML(str2);
            }
        }
        catch (Exception ex)
        {

        }

    }
}