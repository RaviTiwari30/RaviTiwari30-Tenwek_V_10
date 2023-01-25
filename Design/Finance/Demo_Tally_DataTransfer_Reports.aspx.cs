using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
//using System.Data.OracleClient;
using System.Linq;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json;
using System.Reflection;

public partial class Design_EDP_Demo_Tally_DataTransfer_Reports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        All_LoadData.bindCenterDropDownList(ddlCentre, Resources.Resource.DefaultCentreID);
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
        if (!IsPostBack)
            CheckUnMappedItems();
    }

    protected void CheckUnMappedItems()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT im.itemid,im.TypeName,sm.Name AS SubCategory,cm.Name AS Category FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID ");
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
        sb.Append(" LEFT JOIN  demo_His_Mapping_Master st ON st.HIS_ItemID=im.ItemID ");
        sb.Append(" WHERE his_itemID IS NULL AND cm.CategoryID<>'LSHHI8' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            chkBeforeTransfer.Enabled = false;
        }
        else
        {
            chkBeforeTransfer.Enabled = true;
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        var type = rdoType.SelectedValue;
        var tnxType = rblTnxType.SelectedValue;
        StringBuilder sb = new StringBuilder();

        if (tnxType == "Bill/Invoice")
        {
            if (type == "1")
            {
                if (chkBeforeTransfer.Checked == false)
                {
                    sb.Append("SELECT IFNULL(BillNo,'')BillNo,IFNULL(ReceiptNo,'')ReceiptNo,IFNULL(MRNo,'')MRNo,IFNULL(PName,'')PatientName,BillNo,IFNULL(BillDate,'')BillDate,IFNULL(BillAmount,'')BillAmount,IFNULL(PaidAmount,'')PaidAmount,IFNULL(PaymentMode,'')PaymentMode,IFNULL(CurrencyType,'')CurrencyType,IFNULL(ChequeNo,'')ChequeNo,PanelName FROM demo_finance_cashcollection     WHERE  BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND BillDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND BillAmount >= 0 ");
                }
                else
                {
                    sb.Append("SELECT t.* FROM ( ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,lt.BillNo,rec.ReceiptNo,lt.PatientID MRNo, IF(pm.PatientID='CASH002', ");
                    sb.Append("(SELECT  NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),(SELECT Pname FROM patient_master WHERE ");
                    sb.Append("PatientID=pm.PatientID))Pname,rec.Date,NetAmount BillAmount,lt_pay.S_Amount PaidAmount,lt_pay.PaymentMode,lt_pay.S_Currency CurrencyType,lt_pay.RefNo Chequeno,IF(lt_pay.PaymentModeID=2,lt_pay.RefDate,'0001-01-01')ChequeDate,lt.Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID ");
                    sb.Append("INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo ");
                    sb.Append("INNER  JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=rec.PanelID ");
                    sb.Append("INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID  ");
                    //sb.Append("WHERE  lt_pay.PaymentModeID<>4 AND lt.IsCancel=0 AND rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("WHERE  lt_pay.PaymentModeID<>4 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,'' BillNo,rec.ReceiptNo,rec.Depositor MRNo,PName,rec.Date,AmountPaid BillAmount,rec_pay.S_Amount PaidAmount,rec_pay.PaymentMode,rec_pay.S_Currency CurrencyType,rec_pay.RefNo Chequeno ,IF(rec_pay.PaymentModeID=2,rec_pay.RefDate,'0001-01-01') ChequeDate,'' Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName ");
                    sb.Append("FROM f_patientaccount acc INNER JOIN f_reciept rec ON acc.ReceiptNo=rec.ReceiptNo ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
                    sb.Append("INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=rec.PanelID ");
                    sb.Append("INNER JOIN employee_master em ON em.Employee_ID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                    //sb.Append("WHERE  IsAdvanceAmt=1 AND acc.LedgerTransactionNo<>'' AND rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("WHERE  IsAdvanceAmt=1 AND acc.LedgerTransactionNo<>'' AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,adj.billNo,rec.ReceiptNo,rec.Depositor MRNo,PName,rec.Date,adj.TotalBilledAmt BillAmount,rec_pay.S_Amount PaidAmount,rec_pay.PaymentMode,rec_pay.S_Currency CurrencyType,rec_pay.RefNo Chequeno,IF(rec_pay.PaymentModeID=2,rec_pay.RefDate,'0001-01-01') ChequeDate,'' Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName FROM f_reciept rec ");
                    sb.Append("INNER JOIN f_ipdadjustment adj ON adj.TransactionID=rec.TransactionID  ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
                    sb.Append("INNER JOIN employee_master em ON rec.Reciever=em.Employee_ID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
                    sb.Append("INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=adj.PanelID ");
                    //sb.Append("WHERE rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("WHERE CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,cd.BillNo,rec.ReceiptNo,rec.Depositor MRNo,pm.CName PName,rec.Date,cd.TotalBilledAmt BillAmount,rec_pay.S_Amount PaidAmount,rec_pay.PaymentMode,rec_pay.S_Currency CurrencyType,rec_pay.RefNo Chequeno,IF(rec_pay.PaymentModeID=2,rec_pay.RefDate,'0001-01-01') ChequeDate,'' Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName FROM mortuary_receipt rec ");
                    sb.Append("INNER JOIN mortuary_corpse_master pm ON pm.Corpse_ID=rec.Depositor ");
                    sb.Append("INNER JOIN mortuary_corpse_deposite cd ON cd.CorpseID=pm.Corpse_ID ");
                    sb.Append("INNER JOIN employee_master em ON rec.Reciever=em.Employee_ID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
                    sb.Append("INNER JOIN mortuary_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=cd.PanelID ");
                    //sb.Append("WHERE rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("WHERE CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
                    sb.Append(")t ORDER BY DATE(DATE) ");
                }
            }
            else if (type == "2")
            {
                if (chkBeforeTransfer.Checked == false)
                {
                    sb.Append("SELECT IFNULL(MRNo,'')MRNo,IFNULL(PatientName,'')PatientName,IFNULL(CostCentreName,'')CostCentreName,IFNULL(RevenueName,'')RevenueName,IFNULL(CentreName,'')CentreName,BillNo,IFNULL(BillDate,'')BillDate,IFNULL(BillAmount,'')BillAmount,IFNULL(ItemAmount,'')ItemAmount,IFNULL(PanelPaidAmt,'')PanelPaidAmt,IFNULL(DeptName,'')DeptName,PanelName  FROM demo_finance_revenuedetails   WHERE  BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND BillDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND BillAmount >= 0 ");
                }
                else
                {
                    sb.Append("SELECT *  FROM (SELECT MRNo,PatientName,CostCentreName,CostCentreID,RevenueName,RevenueID,CentreName,CentreID, ");
                    sb.Append("BillDate,ROUND(NetAmount,2) BillAmount,ROUND(SUM(ItemAmount),2) ItemAmount, ROUND(SUM(RoundOff),2) RoundOff, ROUND(PanelPaidAmt,2) PanelPaidAmt,'' IPDCaseType_ID,'' DeptName,BillNo,PanelID,PanelName ");
                    sb.Append("FROM (SELECT IF(pmh.PatientID<>'CASH002',pmh.PatientID, ");
                    sb.Append("(SELECT PGM.CustomerID FROM patient_general_master PGM WHERE PGM.AgainstLedgerTnxNo=LT.LedgerTransactionNo LIMIT 1)) MRNo, ");
                    sb.Append("IF(pmh.PatientID='CASH002',(SELECT PGM.Name FROM patient_general_master PGM ");
                    sb.Append("WHERE PGM.AgainstLedgerTnxNo=LT.LedgerTransactionNo LIMIT 1), ");
                    sb.Append("(SELECT PName FROM patient_master WHERE PatientID = pmh.PatientID) )PatientName,lt.Date AS BillDate,lt.BillNo,lt.NetAmount,ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/lt.NetAmount)RoundOff, ");
                    sb.Append("IF(pmh.PanelAmount=0,pmh.PanelAmount,(ltd.Amount *pmh.PanelAmount)/lt.NetAmount)PanelAmount, ");
                    sb.Append("IF(pmh.PanelPaidAmt=0,pmh.PanelPaidAmt,(ltd.Amount *pmh.PanelPaidAmt)/lt.NetAmount)PanelPaidAmt, ");
                    sb.Append("IF(IFNULL(pmh.TDS,0)=0,IFNULL(pmh.TDS,0),(ltd.Amount *IFNULL(pmh.TDS,0))/lt.NetAmount)TDS, ");
                    sb.Append("IF(IFNULL(pmh.Deduction_Acceptable,0)=0,IFNULL(pmh.Deduction_Acceptable,0),(ltd.Amount *IFNULL(pmh.Deduction_Acceptable,0))/lt.NetAmount)Deduction_Acceptable, ");
                    sb.Append("IF(IFNULL(pmh.WriteOff,0)=0,IFNULL(pmh.WriteOff,0),(ltd.Amount *IFNULL(pmh.WriteOff,0))/lt.NetAmount)WriteOff, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID,fpm.PanelID AS PanelID,fpm.Company_Name AS PanelName,cm.CentreName,cm.`CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName ");
                    sb.Append("FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                    sb.Append("INNER JOIN `center_master` cm ON cm.`CentreID`=pmh.`CentreID` ");
                    sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=pmh.`PanelID` ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("WHERE LT.DATE>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("AND LT.DATE <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("AND lt.IsCancel=0  AND ltd.IsVerified=1 ");
                    sb.Append("AND tmm.CostCentreID NOT IN ('C15','C16','C17','C18','C19','C20','C21','C22','C23') AND lt.BillNo<>'' ");
                    sb.Append("AND PMH.Type<>'IPD' ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT adj.PatientID MRNo,(SELECT PName FROM patient_master WHERE PatientID = adj.PatientID) PatientName, ");
                    sb.Append("adj.BillDate BillDate,adj.BillNo BillNo, ");
                    sb.Append("adj.TotalBilledAmt AS NetAmount, ");
                    sb.Append("ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/lt.NetAmount)RoundOff, ");
                    sb.Append("IF(pmh.PanelAmount=0,pmh.PanelAmount,(ltd.Amount *pmh.PanelAmount)/lt.NetAmount)PanelAmount, ");
                    sb.Append("IF(pmh.PanelPaidAmt=0,pmh.PanelPaidAmt,(ltd.Amount *pmh.PanelPaidAmt)/lt.NetAmount)PanelPaidAmt, ");
                    sb.Append("IF(IFNULL(pmh.TDS,0)=0,IFNULL(pmh.TDS,0),(ltd.Amount *IFNULL(pmh.TDS,0))/lt.NetAmount)TDS, ");
                    sb.Append("IF(IFNULL(pmh.Deduction_Acceptable,0)=0,IFNULL(pmh.Deduction_Acceptable,0),(ltd.Amount *IFNULL(pmh.Deduction_Acceptable,0))/lt.NetAmount)Deduction_Acceptable, ");
                    sb.Append("IF(IFNULL(pmh.WriteOff,0)=0,IFNULL(pmh.WriteOff,0),(ltd.Amount *IFNULL(pmh.WriteOff,0))/lt.NetAmount)WriteOff, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID,fpm.PanelID AS PanelID,fpm.Company_Name AS PanelName,cm.CentreName,cm.`CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName ");
                    sb.Append("FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                    sb.Append("INNER JOIN `center_master` cm ON cm.`CentreID`=pmh.`CentreID` ");
                    sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=pmh.`PanelID` ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("INNER JOIN f_ipdadjustment adj ON adj.TransactionID = PMH.TransactionID  ");
                    sb.Append("WHERE ADJ.BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("AND ADJ.BillDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    sb.Append("AND ltd.IsVerified=1 ");
                    sb.Append("AND tmm.CostCentreID NOT IN ('C15','C16','C17','C18','C19','C20','C21','C22','C23') AND IFNULL(adj.billno,'')<>'' ");
                    sb.Append(")t1  GROUP BY BillNO,CentreID,CostCentreID,RevenueID,BillDate ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT t.MRNo,t.PatientName,t.CostCentreName,t.CostCentreID,t.RevenueName,t.RevenueID,CentreName,CentreID, ");
                    sb.Append("BillDate,ROUND(TotalBilledAmt,2) BillAmount,ROUND(SUM(ItemAmount),2) ItemAmount, ROUND(SUM(RoundOff),2) RoundOff,ROUND(PanelPaidAmt,2) PanelPaidAmt,IPDCaseType_ID,DeptName,BillNo,PanelID,PanelName ");
                    sb.Append("FROM ( ");
                    sb.Append("SELECT pm.PatientID MRNo,pm.PName PatientName,ltd.IPDCaseType_ID,(SELECT Description FROM ipd_case_type_master WHERE IPDCaseType_ID=ltd.IPDCaseType_ID)DeptName,lt.TransactionID,DATE(adj.BillDate)BillDate,adj.BillNo,lt.NetAmount,ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/adj.TotalBilledAmt)RoundOff, ");
                    sb.Append("IF(pmh.PanelID<>1,ltd.Amount,0)PanelAmount, ");
                    sb.Append("'0' PanelPaidAmt, ");
                    sb.Append("IF(IFNULL(pmh.TDS,0)=0,IFNULL(pmh.TDS,0),(ltd.Amount *IFNULL(pmh.TDS,0))/adj.TotalBilledAmt)TDS, ");
                    sb.Append("IF(IFNULL(pmh.Deduction_Acceptable,0)=0,IFNULL(pmh.Deduction_Acceptable,0),(ltd.Amount *IFNULL(pmh.Deduction_Acceptable,0))/adj.TotalBilledAmt)Deduction_Acceptable, ");
                    sb.Append("IF(IFNULL(pmh.WriteOff,0)=0,IFNULL(pmh.WriteOff,0),(ltd.Amount *IFNULL(pmh.WriteOff,0))/adj.TotalBilledAmt)WriteOff,adj.TotalBilledAmt, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID, ");
                    sb.Append("pnl.PanelID AS PanelID,pnl.Company_Name AS PanelName,cm.CentreName,cm.`CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName,cc.IPD_CaseTypeID CostCentreCaseID ");
                    sb.Append("FROM f_ledgertransaction lt ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
                    sb.Append("INNER JOIN f_ipdadjustment adj ON adj.TransactionID=pmh.TransactionID  ");
                    sb.Append("INNER JOIN `center_master` cm ON cm.`CentreID`=adj.`CentreID` ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("INNER JOIN demo_costcentre cc ON cc.IPD_CaseTypeID=ltd.IPDCaseType_ID AND tmm.CostCentreID=cc.ID ");
                    sb.Append("WHERE DATE(adj.BillDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("AND (adj.BillNo<>NULL OR adj.BillNo<>'')  ");
                    sb.Append("AND tmm.CostCentreID IN ('C15','C16','C17','C18','C19','C20','C21','C22','C23') ");
                    sb.Append("AND ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                    sb.Append(")t GROUP BY BillNO,CentreID,CostCentreCaseID,RevenueID,BillDate ");
                    sb.Append("UNION ALL  ");
                    sb.Append("SELECT MRNo,PatientName,CostCentreName,CostCentreID,RevenueName,RevenueID,CentreName,CentreID, ");
                    sb.Append("BillDate,ROUND(TotalBilledAmt,2) BillAmount,ROUND(ItemAmount,2) ItemAmount, ROUND(RoundOff,2) RoundOff,ROUND(PanelPaidAmt,2) PanelPaidAmt,'' IPDCaseType_ID,'' DeptName,BillNo,PanelID,PanelName ");
                    sb.Append("FROM (SELECT Corpse_ID MRNo,CName PatientName,BillDate,BillNo,TotalBilledAmt,SUM(ItemAmount)ItemAmount,RoundOff,PanelAmount,PanelPaidAmt,TDS, ");
                    sb.Append("t.PanelID,t.PanelName,CentreName,CentreID, ");
                    sb.Append("t.CostCentreID,t.CostCentreName,t.RevenueID,t.RevenueName ");
                    sb.Append("FROM (	SELECT cm.Corpse_ID,cm.CName,DATE(lt.Date)BillDate,cd.BillNo,lt.NetAmount,cd.TotalBilledAmt,ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/lt.NetAmount)RoundOff, ");
                    sb.Append("IF(lt.PanelID<>1,ltd.Amount,0)PanelAmount, ");
                    sb.Append("0 PanelPaidAmt,0 TDS, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID,fpm.PanelID AS PanelID,fpm.Company_Name AS PanelName,'University Hospital' CentreName,'1' `CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName ");
                    sb.Append("FROM mortuary_ledgertransaction lt INNER JOIN mortuary_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN mortuary_corpse_deposite cd ON cd.TransactionID=lt.TransactionID ");
                    sb.Append("INNER JOIN mortuary_corpse_master cm ON cm.Corpse_ID=cd.CorpseID ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=lt.`PanelID`  ");
                    //sb.Append("WHERE lt.BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.BillDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   AND lt.IsCancel=0  AND ltd.IsVerified=1 ");
                    sb.Append("WHERE lt.BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.BillDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND ltd.IsVerified=1 ");
                    sb.Append("AND tmm.CostCentreID='C13' AND (lt.BillNo<>NULL OR lt.BillNo<>'') ");
                    sb.Append(")t ");
                    sb.Append(")t1  GROUP BY BillNO,CentreID,CostCentreID,RevenueID,BillDate)t ORDER BY CentreID,CostCentreID,RevenueID,BillDate ");
                }
            }
            else if (type == "3")
            {
                sb.Append("SELECT IFNULL(CostCentreName,'')CostCentreName,IFNULL(RevenueName,'')RevenueName,IFNULL(CentreName,'')CentreName,IFNULL(BillDate,'')BillDate,IFNULL(ItemAmount,'')ItemAmount,IFNULL(PanelAmount,'')PanelAmount,IFNULL(DeptName,'')DeptName FROM  demo_finance_revenuesummary   WHERE  BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND BillDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
            }
        }
        else if (tnxType == "Bill Cancel")
        {
            if (type == "1")
            {
                if (chkBeforeTransfer.Checked == false)
                {
                    sb.Append("SELECT IFNULL(BillNo,'')BillNo,IFNULL(ReceiptNo,'')ReceiptNo,IFNULL(MRNo,'')MRNo,IFNULL(PName,'')PatientName,BillNo,IFNULL(BillDate,'')BillDate,IFNULL(BillAmount,'')BillAmount,IFNULL(PaidAmount,'')PaidAmount,IFNULL(PaymentMode,'')PaymentMode,IFNULL(CurrencyType,'')CurrencyType,IFNULL(ChequeNo,'')ChequeNo,PanelName FROM demo_finance_cashcollection WHERE BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND BillDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND BillAmount < 0 ");
                }
                else
                {
                    sb.Append("SELECT t.* FROM ( ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,lt.BillNo,rec.ReceiptNo,lt.PatientID MRNo, IF(pm.PatientID='CASH002', ");
                    sb.Append("(SELECT  NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),(SELECT Pname FROM patient_master WHERE ");
                    sb.Append("PatientID=pm.PatientID))Pname,rec.Date,NetAmount BillAmount,lt_pay.S_Amount PaidAmount,lt_pay.PaymentMode,lt_pay.S_Currency CurrencyType,lt_pay.RefNo Chequeno,IF(lt_pay.PaymentModeID=2,lt_pay.RefDate,'0001-01-01')ChequeDate,lt.Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID ");
                    sb.Append("INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo ");
                    sb.Append("INNER  JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=rec.PanelID ");
                    sb.Append("INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID  ");
                    sb.Append("WHERE  lt_pay.PaymentModeID<>4 AND lt.IsCancel=1 AND rec.IsCancel=1 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,'' BillNo,rec.ReceiptNo,rec.Depositor MRNo,PName,rec.Date,AmountPaid BillAmount,rec_pay.S_Amount PaidAmount,rec_pay.PaymentMode,rec_pay.S_Currency CurrencyType,rec_pay.RefNo Chequeno ,IF(rec_pay.PaymentModeID=2,rec_pay.RefDate,'0001-01-01') ChequeDate,'' Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName ");
                    sb.Append("FROM f_patientaccount acc INNER JOIN f_reciept rec ON acc.ReceiptNo=rec.ReceiptNo ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
                    sb.Append("INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=rec.PanelID ");
                    sb.Append("INNER JOIN employee_master em ON em.Employee_ID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                    sb.Append("WHERE  IsAdvanceAmt=1 AND acc.LedgerTransactionNo<>'' AND rec.IsCancel=1 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,adj.billNo,rec.ReceiptNo,rec.Depositor MRNo,PName,rec.Date,adj.TotalBilledAmt BillAmount,rec_pay.S_Amount PaidAmount,rec_pay.PaymentMode,rec_pay.S_Currency CurrencyType,rec_pay.RefNo Chequeno,IF(rec_pay.PaymentModeID=2,rec_pay.RefDate,'0001-01-01') ChequeDate,'' Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName FROM f_reciept rec ");
                    sb.Append("INNER JOIN f_ipdadjustment adj ON adj.TransactionID=rec.TransactionID  ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
                    sb.Append("INNER JOIN employee_master em ON rec.Reciever=em.Employee_ID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
                    sb.Append("INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=adj.PanelID ");
                    sb.Append("WHERE rec.IsCancel=1 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT cm.CentreName,cm.CentreID,cd.BillNo,rec.ReceiptNo,rec.Depositor MRNo,pm.CName PName,rec.Date,cd.TotalBilledAmt BillAmount,rec_pay.S_Amount PaidAmount,rec_pay.PaymentMode,rec_pay.S_Currency CurrencyType,rec_pay.RefNo Chequeno,IF(rec_pay.PaymentModeID=2,rec_pay.RefDate,'0001-01-01') ChequeDate,'' Refund_Against_BillNo,pnl.PanelID PanelID,pnl.Company_Name PanelName FROM mortuary_receipt rec ");
                    sb.Append("INNER JOIN mortuary_corpse_master pm ON pm.Corpse_ID=rec.Depositor ");
                    sb.Append("INNER JOIN mortuary_corpse_deposite cd ON cd.CorpseID=pm.Corpse_ID ");
                    sb.Append("INNER JOIN employee_master em ON rec.Reciever=em.Employee_ID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
                    sb.Append("INNER JOIN mortuary_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=cd.PanelID ");
                    sb.Append("WHERE rec.IsCancel=1 AND CONCAT(rec.Date,' ',rec.Time)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND CONCAT(rec.Date,' ',rec.Time)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
                    sb.Append(")t ORDER BY DATE(DATE) ");
                }
            }
            else if (type == "2")
            {
                if (chkBeforeTransfer.Checked == false)
                {
                    sb.Append("SELECT IFNULL(MRNo,'')MRNo,IFNULL(PatientName,'')PatientName,IFNULL(CostCentreName,'')CostCentreName,IFNULL(RevenueName,'')RevenueName,IFNULL(CentreName,'')CentreName,BillNo,IFNULL(BillDate,'')BillDate,IFNULL(BillAmount,'')BillAmount,IFNULL(ItemAmount,'')ItemAmount,IFNULL(PanelPaidAmt,'')PanelPaidAmt,IFNULL(DeptName,'')DeptName,PanelName  FROM demo_finance_revenuedetails   WHERE  BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND BillDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND BillAmount < 0 ");
                }
                else
                {
                    sb.Append("SELECT *  FROM (SELECT MRNo,PatientName,CostCentreName,CostCentreID,RevenueName,RevenueID,CentreName,CentreID, ");
                    sb.Append("BillDate,ROUND(NetAmount,2) BillAmount,ROUND(SUM(ItemAmount),2) ItemAmount, ROUND(SUM(RoundOff),2) RoundOff, ROUND(PanelPaidAmt,2) PanelPaidAmt,'' IPDCaseType_ID,'' DeptName,BillNo,PanelID,PanelName ");
                    sb.Append("FROM (SELECT IF(pmh.PatientID<>'CASH002',pmh.PatientID, ");
                    sb.Append("(SELECT PGM.CustomerID FROM patient_general_master PGM WHERE PGM.AgainstLedgerTnxNo=LT.LedgerTransactionNo LIMIT 1)) MRNo, ");
                    sb.Append("IF(pmh.PatientID='CASH002',(SELECT PGM.Name FROM patient_general_master PGM ");
                    sb.Append("WHERE PGM.AgainstLedgerTnxNo=LT.LedgerTransactionNo LIMIT 1), ");
                    sb.Append("(SELECT PName FROM patient_master WHERE PatientID = pmh.PatientID) )PatientName,lt.Date AS BillDate,lt.BillNo,lt.NetAmount,ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/lt.NetAmount)RoundOff, ");
                    sb.Append("IF(pmh.PanelAmount=0,pmh.PanelAmount,(ltd.Amount *pmh.PanelAmount)/lt.NetAmount)PanelAmount, ");
                    sb.Append("IF(pmh.PanelPaidAmt=0,pmh.PanelPaidAmt,(ltd.Amount *pmh.PanelPaidAmt)/lt.NetAmount)PanelPaidAmt, ");
                    sb.Append("IF(IFNULL(pmh.TDS,0)=0,IFNULL(pmh.TDS,0),(ltd.Amount *IFNULL(pmh.TDS,0))/lt.NetAmount)TDS, ");
                    sb.Append("IF(IFNULL(pmh.Deduction_Acceptable,0)=0,IFNULL(pmh.Deduction_Acceptable,0),(ltd.Amount *IFNULL(pmh.Deduction_Acceptable,0))/lt.NetAmount)Deduction_Acceptable, ");
                    sb.Append("IF(IFNULL(pmh.WriteOff,0)=0,IFNULL(pmh.WriteOff,0),(ltd.Amount *IFNULL(pmh.WriteOff,0))/lt.NetAmount)WriteOff, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID,fpm.PanelID AS PanelID,fpm.Company_Name AS PanelName,cm.CentreName,cm.`CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName ");
                    sb.Append("FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                    sb.Append("INNER JOIN `center_master` cm ON cm.`CentreID`=pmh.`CentreID` ");
                    sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=pmh.`PanelID` ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("WHERE LT.DATE>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("AND LT.DATE <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    sb.Append("AND lt.IsCancel=1 ");
                    //sb.Append("AND tmm.CostCentreID NOT IN ('C15','C16','C17','C18','C19','C20','C21','C22','C23') AND lt.BillNo<>'' ");
                    sb.Append(" AND lt.BillNo<>'' ");
                    sb.Append("AND PMH.Type<>'IPD' ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT adj.PatientID MRNo,(SELECT PName FROM patient_master WHERE PatientID = adj.PatientID) PatientName, ");
                    sb.Append("adj.BillDate BillDate,adj.TempBillNo BillNo, ");
                    sb.Append("adj.TotalBilledAmt AS NetAmount, ");
                    sb.Append("ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/lt.NetAmount)RoundOff, ");
                    sb.Append("IF(pmh.PanelAmount=0,pmh.PanelAmount,(ltd.Amount *pmh.PanelAmount)/lt.NetAmount)PanelAmount, ");
                    sb.Append("IF(pmh.PanelPaidAmt=0,pmh.PanelPaidAmt,(ltd.Amount *pmh.PanelPaidAmt)/lt.NetAmount)PanelPaidAmt, ");
                    sb.Append("IF(IFNULL(pmh.TDS,0)=0,IFNULL(pmh.TDS,0),(ltd.Amount *IFNULL(pmh.TDS,0))/lt.NetAmount)TDS, ");
                    sb.Append("IF(IFNULL(pmh.Deduction_Acceptable,0)=0,IFNULL(pmh.Deduction_Acceptable,0),(ltd.Amount *IFNULL(pmh.Deduction_Acceptable,0))/lt.NetAmount)Deduction_Acceptable, ");
                    sb.Append("IF(IFNULL(pmh.WriteOff,0)=0,IFNULL(pmh.WriteOff,0),(ltd.Amount *IFNULL(pmh.WriteOff,0))/lt.NetAmount)WriteOff, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID,fpm.PanelID AS PanelID,fpm.Company_Name AS PanelName,cm.CentreName,cm.`CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName ");
                    sb.Append("FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                    sb.Append("INNER JOIN `center_master` cm ON cm.`CentreID`=pmh.`CentreID` ");
                    sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=pmh.`PanelID` ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("INNER JOIN f_ipdadjustment adj ON adj.TransactionID = PMH.TransactionID  ");
                    sb.Append("WHERE ADJ.BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("AND ADJ.BillDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    sb.Append("AND ltd.IsVerified=1 AND adj.TempBillNo<>'' ");
                    sb.Append("AND tmm.CostCentreID NOT IN ('C15','C16','C17','C18','C19','C20','C21','C22','C23') AND IFNULL(adj.billno,'')<>'' ");
					sb.Append(" AND IFNULL(adj.billno,'')<>'' ");
                    sb.Append(")t1 where BillNO<>''  GROUP BY BillNO,CentreID,CostCentreID,RevenueID,BillDate ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT t.MRNo,t.PatientName,t.CostCentreName,t.CostCentreID,t.RevenueName,t.RevenueID,CentreName,CentreID, ");
                    sb.Append("BillDate,ROUND(TotalBilledAmt,2) BillAmount,ROUND(SUM(ItemAmount),2) ItemAmount, ROUND(SUM(RoundOff),2) RoundOff,ROUND(PanelPaidAmt,2) PanelPaidAmt,IPDCaseType_ID,DeptName,BillNo,PanelID,PanelName ");
                    sb.Append("FROM ( ");
                    sb.Append("SELECT pm.PatientID MRNo,pm.PName PatientName,ltd.IPDCaseType_ID,(SELECT Description FROM ipd_case_type_master WHERE IPDCaseType_ID=ltd.IPDCaseType_ID)DeptName,lt.TransactionID,DATE(adj.BillDate)BillDate,adj.BillNo,lt.NetAmount,ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/adj.TotalBilledAmt)RoundOff, ");
                    sb.Append("IF(pmh.PanelID<>1,ltd.Amount,0)PanelAmount, ");
                    sb.Append("'0' PanelPaidAmt, ");
                    sb.Append("IF(IFNULL(pmh.TDS,0)=0,IFNULL(pmh.TDS,0),(ltd.Amount *IFNULL(pmh.TDS,0))/adj.TotalBilledAmt)TDS, ");
                    sb.Append("IF(IFNULL(pmh.Deduction_Acceptable,0)=0,IFNULL(pmh.Deduction_Acceptable,0),(ltd.Amount *IFNULL(pmh.Deduction_Acceptable,0))/adj.TotalBilledAmt)Deduction_Acceptable, ");
                    sb.Append("IF(IFNULL(pmh.WriteOff,0)=0,IFNULL(pmh.WriteOff,0),(ltd.Amount *IFNULL(pmh.WriteOff,0))/adj.TotalBilledAmt)WriteOff,adj.TotalBilledAmt, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID, ");
                    sb.Append("pnl.PanelID AS PanelID,pnl.Company_Name AS PanelName,cm.CentreName,cm.`CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName,cc.IPD_CaseTypeID CostCentreCaseID ");
                    sb.Append("FROM f_ledgertransaction lt ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
                    sb.Append("INNER JOIN f_ipdadjustment adj ON adj.TransactionID=pmh.TransactionID  ");
                    sb.Append("INNER JOIN `center_master` cm ON cm.`CentreID`=adj.`CentreID` ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("INNER JOIN demo_costcentre cc ON cc.IPD_CaseTypeID=ltd.IPDCaseType_ID AND tmm.CostCentreID=cc.ID ");
                    sb.Append("WHERE DATE(adj.BillDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("AND (adj.BillNo<>NULL OR adj.BillNo<>'')  ");
                    sb.Append("AND tmm.CostCentreID IN ('C15','C16','C17','C18','C19','C20','C21','C22','C23') ");
                    sb.Append("AND ltd.IsVerified=1 AND ltd.IsPackage=0 and adj.TempBillNo<>'' ");
                    sb.Append(")t GROUP BY BillNO,CentreID,CostCentreCaseID,RevenueID,BillDate ");
                    sb.Append("UNION ALL  ");
                    sb.Append("SELECT MRNo,PatientName,CostCentreName,CostCentreID,RevenueName,RevenueID,CentreName,CentreID, ");
                    sb.Append("BillDate,ROUND(TotalBilledAmt,2) BillAmount,ROUND(ItemAmount,2) ItemAmount, ROUND(RoundOff,2) RoundOff,ROUND(PanelPaidAmt,2) PanelPaidAmt,'' IPDCaseType_ID,'' DeptName,BillNo,PanelID,PanelName ");
                    sb.Append("FROM (SELECT Corpse_ID MRNo,CName PatientName,BillDate,BillNo,TotalBilledAmt,SUM(ItemAmount)ItemAmount,RoundOff,PanelAmount,PanelPaidAmt,TDS, ");
                    sb.Append("t.PanelID,t.PanelName,CentreName,CentreID, ");
                    sb.Append("t.CostCentreID,t.CostCentreName,t.RevenueID,t.RevenueName ");
                    sb.Append("FROM (	SELECT cm.Corpse_ID,cm.CName,DATE(lt.Date)BillDate,cd.BillNo,lt.NetAmount,cd.TotalBilledAmt,ltd.Amount ItemAmount, ");
                    sb.Append("IF(lt.roundoff=0,lt.roundoff,(ltd.Amount *lt.RoundOff)/lt.NetAmount)RoundOff, ");
                    sb.Append("IF(lt.PanelID<>1,ltd.Amount,0)PanelAmount, ");
                    sb.Append("0 PanelPaidAmt,0 TDS, ");
                    sb.Append("tmm.HIS_CategoryID,tmm.HIS_SubCategoryID,fpm.PanelID AS PanelID,fpm.Company_Name AS PanelName,'University Hospital' CentreName,'1' `CentreID`, ");
                    sb.Append("tmm.CostCentreID AS CostCentreID,tmm.CostCentreName AS CostCentreName,tmm.RevenueID AS RevenueID,tmm.RevenueName AS RevenueName ");
                    sb.Append("FROM mortuary_ledgertransaction lt INNER JOIN mortuary_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN mortuary_corpse_deposite cd ON cd.TransactionID=lt.TransactionID ");
                    sb.Append("INNER JOIN mortuary_corpse_master cm ON cm.Corpse_ID=cd.CorpseID ");
                    sb.Append("INNER JOIN demo_his_mapping_master tmm ON tmm.HIS_ItemID = ltd.ItemID AND tmm.isActive=1 ");
                    sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=lt.`PanelID`  ");
                    sb.Append("WHERE lt.BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.BillDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   AND lt.IsCancel=1  AND ltd.IsVerified=1 ");
                    sb.Append("AND tmm.CostCentreID='C13' AND (lt.BillNo<>NULL OR lt.BillNo<>'') ");
                    sb.Append(")t ");
                    sb.Append(")t1 where BillNO<>'' GROUP BY BillNO,CentreID,CostCentreID,RevenueID,BillDate)t ORDER BY CentreID,CostCentreID,RevenueID,BillDate ");
                }
            }
            else if (type == "3")
            {
                sb.Append("SELECT IFNULL(CostCentreName,'')CostCentreName,IFNULL(RevenueName,'')RevenueName,IFNULL(CentreName,'')CentreName,IFNULL(BillDate,'')BillDate,IFNULL(ItemAmount,'')ItemAmount,IFNULL(PanelAmount,'')PanelAmount,IFNULL(DeptName,'')DeptName FROM  demo_finance_revenuesummary   WHERE  BillDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND BillDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
            }
        }

        var data = StockReports.GetDataTable(sb.ToString());
        if (data.Rows.Count > 0)
        {
            spnMsg.Text = data.Rows.Count + " Records Found";
            Session["dtExport2Excel"] = data;
            Session["ReportName"] = rdoType.SelectedItem.Text + " Transfer Report";
            Session["Period"] = "From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
            spnMsg.Text = "0 Records Found";

    }
    protected void btnMappedUnmappedReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (chkMapped.Checked)
            sb.Append("SELECT DISTINCT im.itemid,cm.Name AS Category,sm.Name AS SubCategory,im.TypeName,st.CostCentreName,st.RevenueName,IFNULL((SELECT CONCAT(em.Title,'',em.Name) FROM employee_master em WHERE  em.EmployeeID=st.CreatedBy),'')`Mapped By` FROM f_itemmaster im ");
        else
            sb.Append("SELECT DISTINCT im.itemid,cm.Name AS Category,sm.Name AS SubCategory,im.TypeName,IFNULL(( SELECT CONCAT(em.Title,'',em.Name) FROM  demo_His_Mapping_Master d INNER JOIN employee_master em ON em.EmployeeID=d.UpdatedBy WHERE d.HIS_ItemID=im.ItemID  AND d.IsActive=0),'')`UnMapped By`,CONCAT(ee.Title, '', ee.Name) `Create By` FROM f_itemmaster im  INNER JOIN employee_master ee ON ee.EmployeeID=im.CreaterID ");
        sb.Append("INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID  ");
        sb.Append("INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID  ");
        sb.Append("INNER JOIN f_configrelation cr ON cr.CategoryID=cm.CategoryID ");
        if (chkMapped.Checked)
        {
            sb.Append("INNER JOIN  demo_His_Mapping_Master st ON st.HIS_ItemID=im.ItemID AND st.IsActive=1 ");
        }
        else
        {
            sb.Append("LEFT JOIN  demo_His_Mapping_Master st ON st.HIS_ItemID=im.ItemID AND st.IsActive=1 ");
            sb.Append("WHERE his_itemID IS NULL ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            spnMsg.Text = "";
            dt.Columns.Remove("itemid");
            Session["dtExport2Excel"] = dt;
            if (chkMapped.Checked)
                Session["ReportName"] = "Mapped Item Report";
            else
                Session["ReportName"] = "Un-Mapped Item Report";
            Session["Period"] = DateTime.Now.ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
            spnMsg.Text = "No Record Found..!!!";
    }
    
    protected void btnMappedUnMappedPurchaseAccountReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (chkMappedPurchase.Checked)
            sb.Append("SELECT DISTINCT im.itemid,cm.Name AS Category,sm.Name AS SubCategory,im.TypeName,ifm.COA_NM AS 'Purchase_Account_Code',mc.COA_NM 'CONSUMPTION',ms.COA_NM 'STOCK',mt.COA_NM 'STOCK_TRF',ma.COA_NM 'STOCK Adjustment' FROM f_itemmaster im ");
        else
            sb.Append("SELECT DISTINCT im.itemid,cm.Name AS Category,sm.Name AS SubCategory,im.TypeName FROM f_itemmaster im ");
        sb.Append("INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID  ");
        sb.Append("INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID  ");
        sb.Append("INNER JOIN f_configrelation cr ON cr.CategoryID=cm.CategoryID ");
        if (chkMappedPurchase.Checked)
        {
            sb.Append(" INNER JOIN  ess_itemmastermapping st ON st.ItemID=im.ItemID  ");
            sb.Append(" LEFT JOIN ess.itemmaster_financecoa_mapping ifm ON ifm.COA_ID=st.purchase ");
            sb.Append(" LEFT JOIN ess.itemmaster_financecoa_mapping mc ON mc.COA_ID=st.CONSUMPTION   ");
            sb.Append(" LEFT JOIN ess.itemmaster_financecoa_mapping ms ON ms.COA_ID=st.STOCK ");
            sb.Append(" LEFT JOIN ess.itemmaster_financecoa_mapping mt ON mt.COA_ID=st.STOCK_TRF ");
            sb.Append(" LEFT JOIN ess.itemmaster_financecoa_mapping ma ON ma.COA_ID=st.STOCK_ADJUSTMENT ");

            sb.Append(" WHERE IFNULL(st.PURCHASE,'')<>'' ");
        }
        else
        {
            sb.Append(" Left JOIN  ess_itemmastermapping st ON st.ItemID=im.ItemID  ");
            sb.Append(" WHERE st.ItemID is Null and ConfigID in(7,11,28)  ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            spnMsg.Text = "";
            dt.Columns.Remove("itemid");
            Session["dtExport2Excel"] = dt;
            if (chkMappedPurchase.Checked)
                Session["ReportName"] = "Mapped Purchase Account - Item Report";
            else
                Session["ReportName"] = "Un-Mapped Purchase Account - Item Report";
            Session["Period"] = DateTime.Now.ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
            spnMsg.Text = "No Record Found..!!!";
        
            
    }
}