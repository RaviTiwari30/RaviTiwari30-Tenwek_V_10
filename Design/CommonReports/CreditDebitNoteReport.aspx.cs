using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
public partial class Design_common_CreditDebitNoteReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPreview);
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod]
    public static string CreditDebitNote(string fromDate, string toDate, string CRDRType, string value, string CenterID, string GetType, string BillNo, string UHIDNo, string ReportType)
    {
        DataTable dt = new DataTable();
        string Output = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            if (ReportType == "S")
            {
                sb.Append("SELECT (CASE WHEN ltd.TYPE='O' THEN 'OPD' WHEN ltd.TYPE='I' THEN 'IPD' ELSE 'Emergency' END)TYPE,lt.LedgerTransactionNo,if(ltd.Type='I',adj.TransNo,'')IPDNo,lt.TransactionID,if(ltd.Type='I',adj.BillNo,lt.BillNo)BillNo, ");
                sb.Append("if(ltd.Type='I',Date_FORMAT(adj.BillDate,'%d-%b-%y %h:%m %p'),DATE_FORMAT(CONCAT(lt.Date,' ',lt.Time),'%d-%b-%y %h:%m %p'))BillDate, ");
                sb.Append("SUM(CASE WHEN ltd.TypeofTnx='CR' THEN ltd.NetItemAmt*-1 ELSE 0 END)CreditAmount, ");
                sb.Append("SUM(CASE WHEN ltd.TypeofTnx='DR' THEN ltd.NetItemAmt ELSE 0 END)DebitAmount, ");
                sb.Append("pm.PatientID,CONCAT(pm.Title,'',pm.PName)PatientName,cma.CentreName,cma.CentreID, ");
                sb.Append("(CASE WHEN ltd.Rate<0 THEN 'CR ON RATE' WHEN ltd.TotalDiscAmt>0 THEN 'CR ON DISCOUNT'  ");
                sb.Append("WHEN ltd.Rate>0 THEN 'DR ON RATE' WHEN ltd.TotalDiscAmt<0 THEN 'DR ON DISCOUNT' ELSE '' END)CRDRNoteType  ,CONCAT(em.Title ,' ',em.NAME)EmployeeName,DATE_FORMAT(ltd.EntryDate,'%d-%b-%y %h:%m %p')CreatedDate,IFNULL(dcr.Narration,'')Reason");
                sb.Append(" FROM f_ledgertnxdetail ltd   ");
                sb.Append("INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo     ");
                sb.Append("INNER JOIN f_subcategorymaster scm ON ltd.SubCategoryID = scm.SubCategoryID     ");
                sb.Append("INNER JOIN f_categorymaster cm ON scm.CategoryID = cm.CategoryID     ");
                //sb.Append("INNER JOIN f_drcrnote dr ON dr.LedgerTnxID=ltd.LedgerTnxRefID ");
                sb.Append("INNER JOIN patient_master pm ON pm.PatientID = lt.PatientID ");
                sb.Append("INNER JOIN employee_master em ON em.EmployeeID=ltd.UserID ");
                sb.Append(" INNER JOIN  f_drcrnote dcr ON dcr.CrDrNo=ltd.CrDrNo ");
                sb.Append("LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID ");//f_ipdadjustment
                sb.Append("INNER JOIN center_master cma ON cma.CentreID=lt.CentreID ");
                sb.Append("WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.TypeOfTnx IN ('CR','DR') ");
                if (value == "OPD")
                    sb.Append("AND ltd.Type='O' ");
                else if (value == "IPD")
                    sb.Append("AND ltd.Type='I' ");
                else if (value == "EMG")
                    sb.Append("AND ltd.Type='E' ");
                if (BillNo.Trim() != "")
                    sb.Append("AND lt.BillNo='" + BillNo.Trim() + "' ");
                if (UHIDNo.Trim() != "")
                    sb.Append("AND lt.PatientID='" + Util.GetFullPatientID(UHIDNo.Trim()) + "' ");
                if (CenterID != "0")
                    sb.Append("AND lt.CentreID IN (" + CenterID + ") ");
                if (CRDRType != "0")
                    sb.Append("AND " + CRDRType + " ");
                if (String.IsNullOrEmpty(UHIDNo.Trim()) && String.IsNullOrEmpty(BillNo.Trim()))
                    sb.Append("AND ltd.EntryDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'   ");
                sb.Append("GROUP BY ltd.LedgerTransactionNo ");
                dt = StockReports.GetDataTable(sb.ToString());
            }
            else if (ReportType == "D")
            {
                sb.Append("SELECT (CASE WHEN ltd.TYPE='O' THEN 'OPD' WHEN ltd.TYPE='I' THEN 'IPD' ELSE 'Emergency' END)TYPE,lt.LedgerTransactionNo,if(ltd.Type='I',adj.TransNo,'')IPDNo,lt.TransactionID,if(ltd.Type='I',adj.BillNo,lt.BillNo)BillNo, ");
                sb.Append("if(ltd.Type='I',Date_FORMAT(adj.BillDate,'%d-%b-%y %h:%m %p'),DATE_FORMAT(CONCAT(lt.Date,' ',lt.Time),'%d-%b-%y %h:%m %p'))BillDate, ");
                sb.Append("SUM(CASE WHEN ltd.TypeofTnx='CR' THEN ltd.NetItemAmt*-1 ELSE 0 END)CreditAmount, ");
                sb.Append("SUM(CASE WHEN ltd.TypeofTnx='DR' THEN ltd.NetItemAmt ELSE 0 END)DebitAmount, ");
                sb.Append("pm.PatientID,CONCAT(pm.Title,'',pm.PName)PatientName,cma.CentreName,cma.CentreID, ");
                sb.Append("(CASE WHEN ltd.Rate<0 THEN 'CR ON RATE' WHEN ltd.TotalDiscAmt>0 THEN 'CR ON DISCOUNT'  ");
                sb.Append("WHEN ltd.Rate>0 THEN 'DR ON RATE' WHEN ltd.TotalDiscAmt<0 THEN 'DR ON DISCOUNT' ELSE '' END)CRDRNoteType,ltd.ItemName,cm.Name CategoryName,CONCAT(em.Title ,' ',em.NAME)EmployeeName,DATE_FORMAT(ltd.EntryDate,'%d-%b-%y %h:%m %p')CreatedDate,IFNULL(dcr.Narration,'')Reason, ");
                sb.Append("IF((SELECT COUNT(*) FROM f_ledgertnxdetail ltd1 WHERE ltd1.TransactionID=ltd.TransactionID AND ltd1.IsPackage=1 LIMIT 1)>0,'True','False')isPackage  ");
                sb.Append("FROM f_ledgertnxdetail ltd   ");
                sb.Append("INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo     ");
                sb.Append("INNER JOIN f_subcategorymaster scm ON ltd.SubCategoryID = scm.SubCategoryID     ");
                sb.Append("INNER JOIN f_categorymaster cm ON scm.CategoryID = cm.CategoryID  ");
                sb.Append("INNER JOIN patient_master pm ON pm.PatientID = lt.PatientID  ");
                sb.Append("INNER JOIN employee_master em ON em.EmployeeID=ltd.UserID ");
                sb.Append("  INNER JOIN  f_drcrnote dcr ON dcr.CrDrNo=ltd.CrDrNo ");
                sb.Append("LEFT JOIN patient_medical_history  adj ON adj.TransactionID=lt.TransactionID  ");//f_ipdadjustment
                sb.Append("INNER JOIN center_master cma ON cma.CentreID=lt.CentreID ");
                sb.Append("WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.TypeOfTnx IN ('CR','DR') ");
                if (value == "OPD")
                    sb.Append("AND ltd.Type='O' ");
                else if (value == "IPD")
                    sb.Append("AND ltd.Type='I' ");
                if (BillNo.Trim() != "")
                    sb.Append("AND lt.BillNo='" + BillNo.Trim() + "' ");
                if (UHIDNo.Trim() != "")
                    sb.Append("AND lt.PatientID='" + Util.GetFullPatientID(UHIDNo.Trim()) + "' ");
                if (CenterID != "0")
                    sb.Append("AND lt.CentreID IN (" + CenterID + ") ");
                if (CRDRType != "0")
                    sb.Append("AND " + CRDRType + " ");
                if (String.IsNullOrEmpty(UHIDNo.Trim()) && String.IsNullOrEmpty(BillNo.Trim()))
                    sb.Append("AND ltd.EntryDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'   ");
                sb.Append("GROUP BY ltd.ID ORDER BY scm.DisplayPriority+1,IF(scm.DisplayName<>'',scm.DisplayName,scm.Name),ltd.ItemName,ltd.ID ASC ");
                dt = StockReports.GetDataTable(sb.ToString());
            }
            if (dt.Rows.Count > 0)
            {
                if (GetType.ToUpper() == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "From : " + fromDate.Trim() + "  To : " + toDate.Trim();
                    dt.Columns.Add(dc);
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    dt.WriteXmlSchema(@"E:\CRDRReport.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    if (ReportType == "S")
                        HttpContext.Current.Session["Reportname"] = "CreditDebitNoteReport_Summary";
                    else if (ReportType == "D")
                        HttpContext.Current.Session["Reportname"] = "CreditDebitNoteReport_Detail";
                    Output = "1";
                }
                else if (GetType.ToUpper() == "EXCEL")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "From : " + fromDate.Trim() + "  To : " + toDate.Trim();
                    dt.Columns.Add(dc);
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["Reportname"] = "Credit & Debit Note Report";
                    HttpContext.Current.Session["Period"] = "Period From : " + fromDate.Trim() + " To : " + toDate.Trim();

                    dt.Columns.Remove("Period");
                    dt.Columns.Remove("LedgerTransactionNo");
                    dt.Columns.Remove("TransactionID");
                    dt.Columns.Remove("CRDRNoteType");


                    dt.Columns["PatientID"].ColumnName = "UHID";

                    dt.Columns["UHID"].SetOrdinal(0);
                    dt.Columns["PatientName"].SetOrdinal(1);
                    dt.Columns["IPDNo"].SetOrdinal(2);
                    dt.Columns["Type"].SetOrdinal(3);
                    dt.Columns.Remove("CentreID");
                    dt = Util.GetDataTableRowSum(dt);
                    Output = "2";
                }
            }
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        return Output;
    }
}