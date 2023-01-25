using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_WriteOffReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        string FromDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        string ToDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");


        if (ddlType.SelectedValue == "0")
        {

            sb = new StringBuilder();

            sb.Append("    SELECT  pmh.`PatientID` UHID,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName ,pmh.`TransNo` IPDNo,pmh.`TYPE`,   ");
            sb.Append("    pmh.`BillNo`,(SELECT ROUND(SUM(ltd.`Rate`*ltd.`Quantity`),2) FROM f_ledgertnxdetail ltd WHERE ltd.`IsVerified`<>2 AND ltd.`TransactionID`=pmh.`TransactionID` )BillAmount,   ");
            sb.Append("    DATE_FORMAT(pmh.`BillDate`,'%d-%b-%Y %I:%i %p')BillDate ,    ");
            sb.Append("    (SELECT  GROUP_CONCAT(DISTINCT pnl.PanelGroup) FROM f_panel_master pnl    ");
            sb.Append("    INNER JOIN panel_amountallocation pa ON pnl.`PanelID`=pa.`PanelID`    ");
            sb.Append("    WHERE pa.`TransactionID`=pmh.`TransactionID` GROUP BY pa.`TransactionID`)PanelGroup ,   ");
            sb.Append("    (SELECT  GROUP_CONCAT(DISTINCT pnl.`Company_Name`) FROM f_panel_master pnl    ");
            sb.Append("    INNER JOIN panel_amountallocation pa ON pnl.`PanelID`=pa.`PanelID`    ");
            sb.Append("    WHERE pa.`TransactionID`=pmh.`TransactionID` GROUP BY pa.`TransactionID`)Panel,   ");
            sb.Append("    (SELECT ROUND(IFNULL(SUM(pa.`Amount`),0) ,2)FROM panel_amountallocation pa WHERE pa.`TransactionID`=pmh.`TransactionID`)PanelAllocation,   ");

            sb.Append("    (SELECT ROUND(IFNULL( SUM(fr.`AmountPaid`),0 ),2)FROM f_reciept fr WHERE fr.`TransactionID`=pmh.`TransactionID`)PatientAdvance,   ");
            sb.Append("    ROUND(SUM(IFNULL(wo.`WriteOffAmount`,0)),2) WaiverAmount,    ");
            sb.Append("     CONCAT(em.`Title`,' ',em.`NAME`)EmployeeName,DATE_FORMAT(wo.`EntryDateTime`,'%d-%b-%Y %I:%i %p')CreatedDate   ");
            sb.Append("     ,wo.`WriteOffReason`    ");
            sb.Append("    FROM patient_medical_history pmh   ");
            sb.Append("     INNER JOIN f_writeoff wo ON wo.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append("    INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`    ");
            sb.Append("    INNER JOIN employee_master em ON em.`EmployeeID`=wo.`EntryBy`   ");
            sb.Append("    WHERE pmh.type='IPD' AND pmh.`BillNo`<>''    ");

            sb.Append(" AND DATE(wo.`EntryDateTime`)>='" + FromDate + "' AND DATE(wo.`EntryDateTime`)<='" + ToDate + "'   ");

            if (txtIpdNo.Text != "")
            {


                sb.Append("   AND pmh.`TransNo`='" + txtIpdNo.Text + "'    ");
            }

            if (txtUhid.Text != "")
            {
                sb.Append("   AND pmh.`PatientID`='" + txtUhid.Text + "' ");

            }

            sb.Append("    GROUP BY  pmh.`TransNo`   ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {

                double BillAmount = Convert.ToDouble(dt.Compute("SUM(BillAmount)", string.Empty));
                double PanelAllocation = Convert.ToDouble(dt.Compute("SUM(PanelAllocation)", string.Empty));
                double PatientAdvance = Convert.ToDouble(dt.Compute("SUM(PatientAdvance)", string.Empty));
                double WaiverAmount = Convert.ToDouble(dt.Compute("SUM(WaiverAmount)", string.Empty));

                dt.Rows.Add("Total", "", "", "", "", BillAmount, "", "", "", PanelAllocation, PatientAdvance, WaiverAmount, "", "", "");

                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy") + "";
                Session["ReportName"] = "Write Off  Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMessage.Text = "No Record Found";
            }


        }
        else if (ddlType.SelectedValue == "1")
        {
            sb = new StringBuilder();

            sb.Append("  SELECT UHID,PatientName,IPDNo ,TYPE,BillNo,BillAmount,BillDate,PanelGroup,Panel,PanelAllocation,PatientAdvance,   ");
            sb.Append("    (BillAmount-PanelAllocation-PatientAdvance-WoAmount)PatientClearanceAmount,EmployeeName,CreatedDate,Reason  FROM(       ");
            sb.Append("     SELECT  pmh.`PatientID` UHID,pmh.`TransactionID`,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName ,pmh.`TransNo` IPDNo,pmh.`TYPE`,   ");
            sb.Append("       pmh.`BillNo`,(SELECT ROUND(SUM(ltd.`Rate`*ltd.`Quantity`),2) FROM f_ledgertnxdetail ltd    ");
            sb.Append("      WHERE ltd.`IsVerified`<>2 AND ltd.`TransactionID`=pmh.`TransactionID` )BillAmount,   ");
            sb.Append("     DATE_FORMAT(pmh.`BillDate`,'%d-%b-%Y %I:%i %p')BillDate ,   ");
            sb.Append("     (SELECT  GROUP_CONCAT(DISTINCT pnl.PanelGroup) FROM f_panel_master pnl   ");
            sb.Append("     INNER JOIN panel_amountallocation pa ON pnl.`PanelID`=pa.`PanelID`   ");
            sb.Append("      WHERE pa.`TransactionID`=pmh.`TransactionID` GROUP BY pa.`TransactionID`)PanelGroup ,   ");
            sb.Append("     GetClearancePanleDetails(pmh.`TransactionID`) Panel,   ");
            sb.Append("     (SELECT ROUND(IFNULL(SUM(pa.`Amount`),0) ,2)FROM panel_amountallocation pa WHERE pa.`TransactionID`=pmh.`TransactionID`)PanelAllocation,   ");
            sb.Append("     (SELECT ROUND(IFNULL( SUM(fr.`AmountPaid`),0 ),2)FROM f_reciept fr WHERE fr.`TransactionID`=pmh.`TransactionID`)PatientAdvance,   ");
            sb.Append("      (SELECT ROUND(IFNULL( SUM(wo.`WriteOffAmount`),0 ),2)FROM f_writeoff wo WHERE wo.`TransactionID`=pmh.`TransactionID`)WoAmount,   ");

            sb.Append("     CONCAT(em.`Title`,' ',em.`NAME`)EmployeeName ,   ");
            sb.Append("     DATE_FORMAT(pmh.ClearanceTimeStamp,'%d-%b-%Y %I:%i %p')CreatedDate,pmh.`ClearanceRemark` Reason   ");
            sb.Append("     FROM patient_medical_history pmh   ");

            sb.Append("      INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`   ");
            sb.Append("     INNER JOIN employee_master em ON em.`EmployeeID`=pmh.`ClearanceUserID`   ");
            sb.Append("     WHERE pmh.type='IPD' AND pmh.`IsClearance`=1 AND pmh.`BillNo`<>''   ");
            sb.Append("     AND DATE(pmh.BillDate)>='" + FromDate + "' AND DATE(pmh.BillDate)<='" + ToDate + "'   ");
            if (txtIpdNo.Text != "")
            { 
                sb.Append("   AND pmh.`TransNo`='" + txtIpdNo.Text + "'    ");
            }

            if (txtUhid.Text != "")
            {
                sb.Append("   AND pmh.`PatientID`='" + txtUhid.Text + "' ");

            }


            sb.Append("     GROUP BY  pmh.`TransNo`     ");
            sb.Append("     )t  where (BillAmount-PanelAllocation-PatientAdvance-WoAmount)>0   ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {

                double BillAmount = Convert.ToDouble(dt.Compute("SUM(BillAmount)", string.Empty));
                double PanelAllocation = Convert.ToDouble(dt.Compute("SUM(PanelAllocation)", string.Empty));
                double PatientAdvance = Convert.ToDouble(dt.Compute("SUM(PatientAdvance)", string.Empty));
                double PatientClearanceAmount = Convert.ToDouble(dt.Compute("SUM(PatientClearanceAmount)", string.Empty));

                dt.Rows.Add("Total", "", "", "", "", BillAmount, "", "", "", PanelAllocation, PatientAdvance, PatientClearanceAmount, "", "", "");


                dt.Columns["BillAmount"].ColumnName = "Bill Total Amount";
                dt.Columns["PatientAdvance"].ColumnName = "Patient Advance";

                dt.Columns["PatientClearanceAmount"].ColumnName = "Patient  Clearance Amount";
                dt.Columns["PanelAllocation"].ColumnName = "Panel Allocation Amount";


                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy") + "";
                Session["ReportName"] = "Patient Clearance";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMessage.Text = "No Record Found";
            }

        }
        else if (ddlType.SelectedValue == "2")
        {

            sb = new StringBuilder();

            sb.Append("    SELECT * FROM ( SELECT pmh.PatientID UHID,CONCAT(pm.Title,'',pm.PName)PatientName, IF(LT.TypeOfTnx='OPD-BILLING','OPD','PHY')TYPE,    ");
            sb.Append("   IFNULL(lt.EncounterNo,'')EncounterNo,pmh.BillNo,DATE_FORMAT(pmh.BillDate,'%d-%b-%Y')BillDate,    ");
            sb.Append("    ROUND(lt.NetAmount,2)NetBillAmount,(lt.NetAmount-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa    ");
            sb.Append("    WHERE pa.TransactionID=pmh.TransactionID),0))CashAmount,IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa    ");
            sb.Append("    WHERE pa.TransactionID=pmh.TransactionID),0)PanelAmount ,    ");
            sb.Append("    ROUND(IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT'     ");
            sb.Append("   AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0),2)PaidAmount,     ");
            sb.Append("   (lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT'     ");
            sb.Append("   AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa    ");
            sb.Append("   WHERE pa.TransactionID=pmh.TransactionID),0))PendingAmt ,cm.CentreName,    ");
            sb.Append("   CONCAT(em.Title,' ',em.Name)EmployeeName,DATE_FORMAT(ltd.`PaymentApprovedDate`,'%d-%b-%Y')CreatedDate,ltd.`PaymentApprovalRemark` Reason    ");
            sb.Append("   FROM patient_medical_history pmh      ");
            sb.Append("   INNER JOIN f_ledgertransaction lt ON lt.TransactionID = pmh.TransactionID AND IFNULL(lt.`AsainstLedgerTnxNo`,'')=''     ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo     ");
            sb.Append("   AND ltd.`IsVerified`<>2 AND IF(lt.`PanelID`<>1,ltd.`IsPayable`,1)=1  AND ltd.IsPaymentApproval=1     ");
            sb.Append("   INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID      ");
            sb.Append("   INNER JOIN center_master cm ON cm.CentreID = pmh.CentreID     ");
            sb.Append("   INNER JOIN f_panel_master fpm ON fpm.PanelID = pmh.PanelID     ");
            sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=ltd.PaymentApprovedBy    ");
            sb.Append("   WHERE pmh.TYPE='OPD'  AND (lt.NetAmount-lt.Adjustment)> 0    ");
            sb.Append("   AND pmh.CentreID = 1 AND DATE(pmh.BillDate) >= '" + FromDate + "'    ");
            sb.Append("   AND DATE( pmh.BillDate) <= '" + ToDate + "' ");
            if (txtIpdNo.Text != "")
            {
                sb.Append("   AND lt.EncounterNo='" + txtIpdNo.Text + "'    ");
            }

            if (txtUhid.Text != "")
            {
                sb.Append("   AND pmh.PatientID='" + txtUhid.Text + "' ");

            }

            sb.Append("   GROUP BY lt.LedgerTransactionNo     ");
            sb.Append("   ) t WHERE t.CashAmount<>0    ");




            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {

                double NetBillAmount = Convert.ToDouble(dt.Compute("SUM(NetBillAmount)", string.Empty));
                double CashAmount = Convert.ToDouble(dt.Compute("SUM(CashAmount)", string.Empty));
                double PanelAmount = Convert.ToDouble(dt.Compute("SUM(PanelAmount)", string.Empty));
                double PaidAmount = Convert.ToDouble(dt.Compute("SUM(PaidAmount)", string.Empty));
                double PendingAmt = Convert.ToDouble(dt.Compute("SUM(PendingAmt)", string.Empty));

                dt.Rows.Add("Total", "", "", "", "", "", NetBillAmount, CashAmount, PanelAmount, PaidAmount, PendingAmt, "", "", "", "");


                dt.Columns["NetBillAmount"].ColumnName = "Bill Total Amount";
                dt.Columns["CashAmount"].ColumnName = "Total cash Amount";
                dt.Columns["PaidAmount"].ColumnName = "Debt Collection(paid amount) ";
                dt.Columns["PendingAmt"].ColumnName = "Debt Amount(pending)";
                dt.Columns["PanelAmount"].ColumnName = "Panel Amount";


                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy") + "";
                Session["ReportName"] = " Opd debts(paid service)";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMessage.Text = "No Record Found";
            }

        }


    }
}