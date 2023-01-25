using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for PanelInvoice
/// </summary>
public class PanelInvoice
{
    public PanelInvoice()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable bindDispatchData(string BillFromDate, string BillToDate, string PatientID, string ClaimNo, string PolicyNo, string IPDNo, string DocketNo, string DispatchNo, string DispatchDate, int PanelID, string Type, string Status, string CashCredit, string chkDispatchDate, int CentreID, int IsCoverNote)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append(" CALL BindBillDetailsForPanelInvoice('" + Type + "','" + Util.GetDateTime(BillFromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(BillToDate).ToString("yyyy-MM-dd") + "'," + Util.GetInt(PanelID) + "," + Util.GetInt(CentreID) + ", ");
        sb.Append("  '" + chkDispatchDate + "','" + Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd") + "','" + DocketNo + "','" + DispatchNo + "','" + IPDNo + "', ");
        sb.Append(" '" + PolicyNo + "','" + PatientID + "','" + ClaimNo + "','" + Status + "' ) ");

        //if (Type == "IPD" || Type == "ALL")
        //{

        //    sb.Append(" SELECT TYPE,CoverNoteNo,CoverNoteDate,PatientID,TransactionID, TransactionID,LedgerTransactionNO,DateOfAdmit,TimeOfAdmit,AdmitDateTime,SUM(IPDBillAmount) IPDBillAmount, SUM(OPDBillAmount)OPDBillAmount, SUM(BillAmt) BillAmt,SUM(NetBillAmt) NetBillAmt ,SUM(ReceiveAmt) ReceiveAmt,SUM(OutStanding) OutStanding, SUM(TotalOutStanding)TotalOutstanding, SUM(Deduction) Deduction,SUM(TDS) TDS,SUM( WriteOff)WriteOff,SUM(PanelAmt) PanelAmt,DateOfDischarge, TimeOfDischarge,DischargeDateTime,PanelID,PatientName Company_Name,BillNo,BillDate,DispatchDate,Ref1,Ref2,DocketNo,Remarks ValidityDay,DispatchID,CourierComp,IsValid,Dispatch_No,IsSettled,SUM(discAmt) discAmt,PolicyNo,CardNo,panelinvoiceno, SUM(PatientPaybleAmt)PatientPaybleAmt,SUM(PatientPaidAmt) PatientPaidAmt,SUM(PanelPaidAmt) PanelPaidAmt, SUM(IPDBillAmount+OPDBillAmount) OPDIPDTotal,SUM(GrossAmount) GrossAmount FROM ( ");

        //    sb.Append(" SELECT * FROM (SELECT 'IPD' TYPE,'' CoverNoteNo,'' CoverNoteDate,t.PatientID,REPLACE(t.TransactionID,'ISHHI','')TransactionID,t.TransactionID TransactionID,'' AS LedgerTransactionNO,DATE_FORMAT(t.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(t.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,CONCAT(t.DateOfAdmit,' ',t.TimeOfAdmit)AdmitDateTime,");
        //    // sb.Append(" BillAmt,NetBillAmt,ReceiveAmt,if(t.PanelAmount<Round((NetBillAmt-(ReceiveAmt+Deduction+tds+WriteOff)),2),t.PanelAmount,Round((NetBillAmt-(ReceiveAmt+Deduction+tds+WriteOff)),2))OutStanding,Round((NetBillAmt-(ReceiveAmt+Deduction+tds+WriteOff)),2)TotalOutStanding,Deduction,TDS,WriteOff, ");
        //    sb.Append(" NetBillAmt IPDBillAmount,0 OPDBillAmount, BillAmt,NetBillAmt,ReceiveAmt,Round((NetBillAmt-(ReceiveAmt+Deduction+tds+WriteOff)),2)OutStanding,Round((NetBillAmt-(ReceiveAmt+Deduction+tds+WriteOff)),2)TotalOutStanding,Deduction,TDS,WriteOff, ");
        //    sb.Append(" (IF(OPDCreditLimitType='A',ROUND((BillAmt),2),ROUND((BillAmt*OPDPanelCreditLimit)/100,2))-ReceiveAmt-t.DiscountOnBill)PanelAmt, ");
        //    sb.Append(" DATE_FORMAT(t.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,t.TimeOfDischarge,CONCAT(t.DateOfDischarge,' ',t.TimeOfDischarge)DischargeDateTime,t.PanelID,t.PatientName,t.Company_Name, ");
        //    sb.Append(" t.BillNo,t.BillDate,IFNULL(DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y'),'')DispatchDate,dis.Ref1,dis.Ref2,dis.DocketNo,dis.Remarks,");
        //    sb.Append(" IFNULL(dis.DispatchDayValidity,IFNULL(dism.Day,0))ValidityDay,IFNULL(dism.DispatchDayID,0)DispatchDayID,IFNULL(dis.DispatchID,'')DispatchID,");
        //    sb.Append(" dis.CourierComp,IF(dis.DispatchDate IS NOT NULL,IF(ADDDATE(dis.DispatchDate,");
        //    sb.Append(" IFNULL(dis.DispatchDayValidity,IFNULL(dism.Day,0)))<CURDATE(),'false','true'),'true')IsValid,IFNULL(dis.Dispatch_No,'')Dispatch_No,IFNULL(dis.IsSettled,'0')IsSettled,t.GrossAmount,(t.DiscountOnBill+t.discAmt)discAmt,t.PolicyNo,t.CardNo,IFNULL(dis.panelinvoiceno,'')panelinvoiceno ");
        //    sb.Append("    ,t.PatientPaybleAmt,t.PatientPaidAmt,t.PanelPaidAmt  ");
        //    sb.Append("     FROM (");
        //    sb.Append("     SELECT pmh.PatientID,pmh.TransactionID,ich.DateOfAdmit,'A'OPDCreditLimitType,adj.CreditLimitPanel AS OPDPanelCreditLimit,ich.TimeOfAdmit,ich.DateOfDischarge, ");
        //    sb.Append("     ich.TimeOfDischarge,CONCAT(pm.Title,' ',pm.PName)PatientName,pnl.Company_Name,adj.BillNo,pmh.PanelID, ");
        //    sb.Append("     ROUND((SELECT SUM(ltd.Rate*ltd.Quantity)  FROM f_ledgertnxdetail ltd WHERE ltd.TransactionID = pmh.TransactionID AND ltd.IsPackage = 0 AND ltd.IsVerified = 1 ),2) AS GrossAmount, ");
        //    sb.Append("     ROUND((SELECT SUM(discAmt)  FROM f_ledgertnxdetail ltd WHERE ltd.TransactionID = pmh.TransactionID AND ltd.IsPackage = 0 AND ltd.IsVerified = 1 ),2) AS discAmt,");
        //    sb.Append("     ROUND((SELECT SUM(ltd.Amount)  FROM f_ledgertnxdetail ltd WHERE ltd.TransactionID = pmh.TransactionID AND ltd.IsPackage = 0 AND ltd.IsVerified = 1 AND ltd.ispayable=0),2) AS BillAmt, ");
        //    sb.Append("     ROUND(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =pmh.TransactionID AND IsCancel = 0  GROUP BY TransactionID),0),2)ReceiveAmt, ");
        //    sb.Append("     IFNULL(pmh.Deduction_Acceptable,0) Deduction,IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.WriteOff,0)WriteOff, ");
        //    //Devendra Singh
        //    sb.Append("   pmh.PanelPaybleAmt AS PanelAmount,pmh.PanelPaidAmt,pmh.PatientPaybleAmt,pmh.PatientPaidAmt, ");

        //    sb.Append("     DATE_FORMAT(adj.BillDate,'%d-%b-%Y')BillDate,IFNULL(adj.DiscountOnBill,0)DiscountOnBill,pmh.PolicyNo,pmh.CardNo,adj.S_Amount AS NetBillAmt ");
        //    sb.Append("     FROM ipd_case_history ich INNER JOIN patient_medical_history PMH ");
        //    sb.Append("     ON pmh.TransactionID = ich.TransactionID INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
        //    sb.Append("     INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
        //    sb.Append("     INNER JOIN f_ipdadjustment adj ON adj.TransactionID=pmh.TransactionID ");
        //    // sb.Append("     INNER JOIN ( ");
        //    // sb.Append("         SELECT lt.BillNo,lt.BillDate,lt.TransactionID FROM f_ledgertransaction lt  ");

        //    if (chkDispatchDate == "false" && DispatchNo.Trim() == "")
        //    {
        //        //  sb.Append("    WHERE (lt.BillNo IS NOT NULL OR lt.BillNo<>'')");
        //        //  sb.Append("    AND Date(lt.BillDate)>='" + Util.GetDateTime(BillFromDate).ToString("yyyy-MM-dd") + "' AND Date(lt.BillDate) <='" + Util.GetDateTime(BillToDate).ToString("yyyy-MM-dd") + "' ");
        //    }
        //    else
        //    {
        //        sb.Append("    INNER JOIN f_dispatch dis ON adj.TransactionID = dis.TransactionID AND dis.IsDispatched=1 AND dis.isCancel=0 ");

        //        if (DispatchDate != string.Empty)
        //            sb.Append("  and Date(dis.DispatchDate)='" + Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd") + "' ");

        //        if (DocketNo.Trim() != "")
        //            sb.Append(" and DocketNo='" + DocketNo.Trim() + "' ");

        //        if (DispatchNo.Trim() != "")
        //            sb.Append(" and Dispatch_No='" + DispatchNo.Trim() + "' ");
        //    }

        //    //  sb.Append("        GROUP BY lt.TransactionID ");

        //    //  sb.Append("     ) lt ON pmh.TransactionID = lt.TransactionID ");
        //    sb.Append("    WHERE ich.Status = 'OUT' AND pmh.CentreID='" + CentreID + "' AND adj.IsBilledClosed=1 ");
        //    if (IPDNo.Trim() != "")
        //        sb.Append(" AND adj.TransactionID='ISHHI" + IPDNo.Trim() + "'  ");
        //    else
        //        sb.Append(" AND Date(adj.BillDate)>='" + Util.GetDateTime(BillFromDate).ToString("yyyy-MM-dd") + "' AND Date(adj.BillDate) <='" + Util.GetDateTime(BillToDate).ToString("yyyy-MM-dd") + "' AND adj.PanelID IN (" + PanelID + ") ");

        //    //if ((PanelID != 0) && (IPDNo.Trim() == ""))
        //    //    sb.Append("AND pmh.PanelID IN (" + PanelID + ") ");

        //    if (PolicyNo.Trim() != "")
        //        sb.Append("AND pmh.PolicyNo='" + PolicyNo.Trim() + "'");

        //    //if (IPDNo.Trim() != "")
        //    //    sb.Append("AND pmh.TransactionID='ISHHI" + IPDNo.Trim() + "'");

        //    if (PatientID.Trim() != "")
        //        sb.Append(" AND pm.PatientID='" + PatientID.Trim() + "'");

        //    if (ClaimNo.Trim() != "")
        //        sb.Append("AND adj.ClaimNo='" + ClaimNo.Trim() + "'");

        //    sb.Append("     ORDER BY ich.TransactionID");
        //    sb.Append(" )t LEFT JOIN f_dispatch dis ON t.TransactionID = dis.TransactionID  AND dis.isCancel=0   ");
        //    sb.Append(" LEFT JOIN f_dispatchday_master dism ON dism.PanelID =t.PanelID AND dism.IsActive=1 )TT WHERE ");

        //    sb.Append("  PanelAmt>0 AND  tt.IsSettled=0 ");

        //    if (Status == "0")
        //        sb.Append(" and DispatchDate<>''    ");
        //    else if (Status == "1")
        //        sb.Append(" and DispatchDate=''     ");

        //    if (CashCredit == "0")
        //        sb.Append("  and    OutStanding=0     ");
        //    else if (CashCredit == "1")
        //        sb.Append("  and    OutStanding>0     ");


        //    sb.Append(" UNION ALL ");


        //    //if(string.IsNullOrEmpty(PatientID)){
        //    //    PatientID = StockReports.ExecuteScalar("SELECT pmh.PatientID FROM  patient_medical_history pmh WHERE pmh.TransactionID='ISHHI" + IPDNo.ToString() + "'  LIMIT  1;");
        //    //}




        //    sb.Append("   SELECT 'OPD' TYPE,t.CoverNoteNo,t.CoverNoteDate,t.PatientID,REPLACE(t.IPNo,'ISHHI','') AS TransactionID,t.TransactionID TransactionID,t.LedgerTransactionNO, ");
        //    sb.Append("   t.DateOfAdmit,t.TimeOfAdmit,CONCAT(t.DateOfAdmit,' ',t.TimeOfAdmit)AdmitDateTime, ");
        //    sb.Append("   0 IPDBillAmount,t.BillAmt OPDBillAmount,t.BillAmt, t.BillAmt AS NetBillAmt,t.ReceiveAmt,t.OutStanding,t.TotalOutstanding,t.Deduction,t.TDS,0 WriteOff,t.PanelAmount PanelAmt, ");
        //    sb.Append("   t.DateOfDischarge,t.TimeOfDischarge,CONCAT(t.DateOfDischarge,' ',t.TimeOfDischarge)DischargeDateTime,t.PanelID, ");
        //    sb.Append("   t.PatientName,t.Company_Name,    t.BillNo,t.BillDate,t.DispatchDate, ");
        //    sb.Append("   t.Ref1,t.Ref2,t.DocketNo,t.Remarks,t.ValidityDay, ");
        //    sb.Append("   t.DispatchDayID,IFNULL(t.DispatchID,'')DispatchID,   t.CourierComp, ");
        //    sb.Append("   t.IsValid,IFNULL(t.Dispatch_No,'')Dispatch_No,IFNULL(t.IsSettled,'0')IsSettled,t.GrossAmount,t.discAmt,t.PolicyNo,t.CardNo,IFNULL(t.panelinvoiceno,'')panelinvoiceno ");
        //    //Devendra Singh
        //    sb.Append("    ,t.PatientPaybleAmt,t.PatientPaidAmt,t.PanelPaidAmt  ");
        //    sb.Append("  FROM (  ");
        //    sb.Append("  SELECT temp.CoverNoteNo,temp.CoverNoteDate,temp.PatientID,temp.TransactionID,temp.IPNo,'' DateOfAdmit, '' TimeOfAdmit,'' DateOfDischarge,temp.LedgerTransactionNO,  ");
        //    sb.Append("  '' TimeOfDischarge,temp.PatientName,temp.Company_Name,temp.BillNo,temp.PanelID,(temp.NetAmount+temp.roundoff) AS BillAmt,temp.PanelAmount,temp.PanelPaidAmt,  ");
        //    sb.Append("  temp.ReceiveAmt,temp.Deduction_Acceptable Deduction,temp.TDS,temp.WriteOff,temp.temp.BillDate,  ");
        //    sb.Append("  IFNULL(DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y'),'')DispatchDate,dis.Ref1,dis.Ref2,dis.DocketNo,dis.Remarks,  ");
        //    sb.Append("  IFNULL(dis.DispatchDayValidity,IFNULL(dism.Day,0))ValidityDay,IFNULL(dism.DispatchDayID,0)DispatchDayID,IFNULL(dis.DispatchID,'')DispatchID,  ");
        //    sb.Append("  dis.CourierComp,IF(dis.DispatchDate IS NOT NULL,IF(ADDDATE(dis.DispatchDate,  ");
        //    sb.Append("  IFNULL(dis.DispatchDayValidity,IFNULL(dism.Day,0)))<CURDATE(),'false','true'),'true')IsValid,dis.Dispatch_No,IFNULL(dis.IsSettled,'0')IsSettled,  ");
        //    sb.Append("  ((temp.NetAmount+temp.roundoff)-(temp.ReceiveAmt+temp.Deduction_Acceptable+temp.tds+temp.WriteOff))TotalOutstanding,if(temp.PanelAmount<((temp.NetAmount+temp.roundoff)-(temp.ReceiveAmt+temp.Deduction_Acceptable+temp.tds+temp.WriteOff)),temp.PanelAmount,((temp.NetAmount+temp.roundoff)-(temp.ReceiveAmt+temp.Deduction_Acceptable+temp.tds+temp.WriteOff)))OutStanding,temp.GrossAmount,temp.discAmt,temp.PolicyNo,temp.CardNo,dis.panelInvoiceNo   ");
        //    //Devendra Singh
        //    sb.Append("    ,temp.PatientPaybleAmt,temp.PatientPaidAmt  ");
        //    sb.Append("  FROM (  SELECT ");
        //    if (IsCoverNote == 1)
        //        sb.Append("     cv.`CoverNoteNo`,DATE_FORMAT(cv.`CreatedDateTime`,'%d-%b-%Y HH:mm:ss')CoverNoteDate, ");
        //    else
        //        sb.Append("    '' `CoverNoteNo`,'' CoverNoteDate, ");
        //    sb.Append("    CONCAT(pm.Title,' ',pm.PName)PatientName,pm.PatientID,lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%Y')BillDate,lt.LedgerTransactionNo,lt.TransactionID,lt.IPNo,  ");
        //    sb.Append("    IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,  ");
        //    sb.Append("    IFNULL(pmh.WriteOff,0)WriteOff,SUM(ltd.Amount)NetAmount,SUM(ltd.Rate*ltd.Quantity)GrossAmount,SUM(ltd.discAmt)discAmt,");
        //    //Devendra Singh
        //    // sb.Append("   SUM(ltd.Amount)as PanelAmount,lt.Adjustment as PanelPaidAmt,lt.roundoff , ROUND(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept  WHERE TransactionID =pmh.TransactionID AND IsCancel = 0 GROUP BY TransactionID),0),2)ReceiveAmt, ");
        //    sb.Append("   pmh.PanelPaybleAmt AS PanelAmount,pmh.PanelPaidAmt,pmh.PatientPaybleAmt,pmh.PatientPaidAmt,lt.roundoff , lt.Adjustment AS ReceiveAmt, ");

        //    sb.Append("    pmh.PolicyNo,pmh.CardNo,pnl.PanelID,pnl.Company_Name FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
        //    sb.Append("    INNER JOIN patient_medical_history pmh ON             ");
        //    sb.Append("    lt.TransactionID=pmh.TransactionID  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID   ");
        //    sb.Append("    INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID	  ");
        //    //devendra singh 
        //    if (IsCoverNote == 1)
        //        sb.Append("    INNER JOIN f_covernote cv ON cv.`TransactionID`=lt.`TransactionID` AND lt.`BillNo`=cv.`BillNo` AND cv.`IsCancel`=0  ");

        //    if (chkDispatchDate == "false" && DispatchNo.Trim() == "")
        //    {
        //        sb.Append(" WHERE DATE(lt.Date)>='" + Util.GetDateTime(BillFromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(BillToDate).ToString("yyyy-MM-dd") + "'   ");
        //    }
        //    else
        //    {
        //        sb.Append("    INNER JOIN f_dispatch dis ON lt.TransactionID = dis.TransactionID WHERE dis.IsDispatched=1 AND dis.IsCancel=0 ");
        //        if (DispatchDate != string.Empty)
        //            sb.Append("          AND DATE(dis.DispatchDate)='" + Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd") + "'  ");

        //        if (DocketNo.Trim() != "")
        //            sb.Append(" AND DocketNo='" + DocketNo.Trim() + "' ");

        //        if (DispatchNo.Trim() != "")
        //            sb.Append(" AND Dispatch_No='" + DispatchNo.Trim() + "' ");
        //    }
        //    sb.Append(" AND   lt.NetAmount > lt.Adjustment  AND lt.IsCancel=0   AND lt.IsIPDMerged=1    AND pmh.CentreID='" + CentreID + "'  ");

        //    if (PanelID != 0)
        //        sb.Append("AND pmh.PanelID IN (" + PanelID + ") ");

        //    if (PolicyNo.Trim() != "")
        //        sb.Append("AND pmh.PolicyNo='" + PolicyNo.Trim() + "'");

        //    if (IPDNo.Trim() != "")
        //        sb.Append("AND lt.IPNo='ISHHI" + IPDNo.Trim() + "'");

        //    sb.Append("   GROUP BY ltd.LedgerTransactionNo       ");
        //    sb.Append("                   )temp  LEFT JOIN f_dispatch dis ON temp.TransactionID = dis.TransactionID  AND dis.isCancel=0     ");
        //    sb.Append(" LEFT JOIN f_dispatchday_master dism ON dism.PanelID =temp.PanelID AND dism.IsActive=1   )t  ");

        //    if (Status == "0")
        //        sb.Append(" WHERE DispatchDate<>'' AND t.IsSettled=0   AND  t.OutStanding>0 ");
        //    else if (Status == "1")
        //        sb.Append(" WHERE DispatchDate=''  AND t.IsSettled=0  AND  t.OutStanding>0");
        //    else
        //        sb.Append(" WHERE t.IsSettled=0 AND  t.OutStanding>0");



        //    sb.Append(") t GROUP BY t.TransactionID ");

        //}
        //if (Type == "OPD" || Type == "ALL")
        //{
        //    if (Type == "ALL")
        //        sb.Append(" UNION ALL ");

        //    sb.Append("   SELECT 'OPD' TYPE,t.CoverNoteNo,t.CoverNoteDate,t.PatientID,'' AS TransactionID,t.TransactionID TransactionID,t.LedgerTransactionNO, ");
        //    sb.Append("   t.DateOfAdmit,t.TimeOfAdmit,CONCAT(t.DateOfAdmit,' ',t.TimeOfAdmit)AdmitDateTime, ");
        //    sb.Append("   0 IPDBillAmount,t.BillAmt OPDBillAmount,t.BillAmt AS NetBillAmt,t.ReceiveAmt,t.OutStanding,t.TotalOutstanding,t.Deduction,t.TDS,t.PanelAmount PanelAmt, ");
        //    sb.Append("   t.DateOfDischarge,t.TimeOfDischarge,CONCAT(t.DateOfDischarge,' ',t.TimeOfDischarge)DischargeDateTime,t.PanelID, ");
        //    sb.Append("   t.PatientName,t.Company_Name,    t.BillNo,t.BillDate,t.DispatchDate, ");
        //    sb.Append("   t.Ref1,t.Ref2,t.DocketNo,t.Remarks,t.ValidityDay, ");
        //    sb.Append("   t.DispatchDayID,IFNULL(t.DispatchID,'')DispatchID,   t.CourierComp, ");
        //    sb.Append("   t.IsValid,IFNULL(t.Dispatch_No,'')Dispatch_No,IFNULL(t.IsSettled,'0')IsSettled,t.GrossAmount,t.discAmt,t.PolicyNo,t.CardNo,IFNULL(t.panelinvoiceno,'')panelinvoiceno ");
        //    //Devendra Singh
        //    sb.Append("    ,t.PatientPaybleAmt,t.PatientPaidAmt,t.PanelPaidAmt  ");
        //    sb.Append("  FROM (  ");
        //    sb.Append("  SELECT temp.CoverNoteNo,temp.CoverNoteDate,temp.PatientID,temp.TransactionID,'' DateOfAdmit, '' TimeOfAdmit,'' DateOfDischarge,temp.LedgerTransactionNO,  ");
        //    sb.Append("  '' TimeOfDischarge,temp.PatientName,temp.Company_Name,temp.BillNo,temp.PanelID,(temp.NetAmount+temp.roundoff) AS BillAmt,temp.PanelAmount,temp.PanelPaidAmt,  ");
        //    sb.Append("  temp.ReceiveAmt,temp.Deduction_Acceptable Deduction,temp.TDS,temp.WriteOff,temp.temp.BillDate,  ");
        //    sb.Append("  IFNULL(DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y'),'')DispatchDate,dis.Ref1,dis.Ref2,dis.DocketNo,dis.Remarks,  ");
        //    sb.Append("  IFNULL(dis.DispatchDayValidity,IFNULL(dism.Day,0))ValidityDay,IFNULL(dism.DispatchDayID,0)DispatchDayID,IFNULL(dis.DispatchID,'')DispatchID,  ");
        //    sb.Append("  dis.CourierComp,IF(dis.DispatchDate IS NOT NULL,IF(ADDDATE(dis.DispatchDate,  ");
        //    sb.Append("  IFNULL(dis.DispatchDayValidity,IFNULL(dism.Day,0)))<CURDATE(),'false','true'),'true')IsValid,dis.Dispatch_No,IFNULL(dis.IsSettled,'0')IsSettled,  ");
        //    sb.Append("  ((temp.NetAmount+temp.roundoff)-(temp.ReceiveAmt+temp.Deduction_Acceptable+temp.tds+temp.WriteOff))TotalOutstanding,if(temp.PanelAmount<((temp.NetAmount+temp.roundoff)-(temp.ReceiveAmt+temp.Deduction_Acceptable+temp.tds+temp.WriteOff)),temp.PanelAmount,((temp.NetAmount+temp.roundoff)-(temp.ReceiveAmt+temp.Deduction_Acceptable+temp.tds+temp.WriteOff)))OutStanding,temp.GrossAmount,temp.discAmt,temp.PolicyNo,temp.CardNo,dis.panelInvoiceNo   ");
        //    //Devendra Singh
        //    sb.Append("    ,temp.PatientPaybleAmt,temp.PatientPaidAmt  ");
        //    sb.Append("  FROM (  SELECT ");
        //    if (IsCoverNote == 1)
        //        sb.Append("     cv.`CoverNoteNo`,DATE_FORMAT(cv.`CreatedDateTime`,'%d-%b-%Y HH:mm:ss')CoverNoteDate, ");
        //    else
        //        sb.Append("    '' `CoverNoteNo`,'' CoverNoteDate,IFNULL((SELECT COUNT(*) FROM f_dispatch ds WHERE ds.TransactionID=lt.IPNo),0) IsInvoice, ");
        //    sb.Append("    CONCAT(pm.Title,' ',pm.PName)PatientName,pm.PatientID,lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%Y')BillDate,lt.LedgerTransactionNo,lt.TransactionID,  ");
        //    sb.Append("    IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,  ");
        //    sb.Append("    IFNULL(pmh.WriteOff,0)WriteOff,SUM(ltd.Amount)NetAmount,SUM(ltd.Rate*ltd.Quantity)GrossAmount,SUM(ltd.discAmt)discAmt,");
        //    //Devendra Singh
        //    // sb.Append("   SUM(ltd.Amount)as PanelAmount,lt.Adjustment as PanelPaidAmt,lt.roundoff , ROUND(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept  WHERE TransactionID =pmh.TransactionID AND IsCancel = 0 GROUP BY TransactionID),0),2)ReceiveAmt, ");
        //    sb.Append("   pmh.PanelPaybleAmt AS PanelAmount,pmh.PanelPaidAmt,pmh.PatientPaybleAmt,pmh.PatientPaidAmt,lt.roundoff , lt.Adjustment AS ReceiveAmt, ");

        //    sb.Append("    pmh.PolicyNo,pmh.CardNo,pnl.PanelID,pnl.Company_Name FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
        //    sb.Append("    INNER JOIN patient_medical_history pmh ON             ");
        //    sb.Append("    lt.TransactionID=pmh.TransactionID  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID   ");
        //    sb.Append("    INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID	  ");
        //    //devendra singh 
        //    if (IsCoverNote == 1)
        //        sb.Append("    INNER JOIN f_covernote cv ON cv.`TransactionID`=lt.`TransactionID` AND lt.`BillNo`=cv.`BillNo` AND cv.`IsCancel`=0  ");

        //    if (chkDispatchDate == "false" && DispatchNo.Trim() == "")
        //    {
        //        sb.Append(" WHERE DATE(lt.Date)>='" + Util.GetDateTime(BillFromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(BillToDate).ToString("yyyy-MM-dd") + "'   ");
        //    }
        //    else
        //    {
        //        sb.Append("    INNER JOIN f_dispatch dis ON lt.TransactionID = dis.TransactionID WHERE dis.IsDispatched=1 AND dis.IsCancel=0 ");
        //        if (DispatchDate != string.Empty)
        //            sb.Append("          AND DATE(dis.DispatchDate)='" + Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd") + "'  ");

        //        if (DocketNo.Trim() != "")
        //            sb.Append(" AND DocketNo='" + DocketNo.Trim() + "' ");

        //        if (DispatchNo.Trim() != "")
        //            sb.Append(" AND Dispatch_No='" + DispatchNo.Trim() + "' ");
        //    }
        //    sb.Append(" AND   lt.NetAmount > lt.Adjustment  AND lt.IsCancel=0   AND lt.IsIPDMerged=0 AND  pmh.Type<> 'IPD'   AND pmh.CentreID='" + CentreID + "'  ");

        //    if (PanelID != 0)
        //        sb.Append("AND pmh.PanelID IN (" + PanelID + ") ");

        //    if (PolicyNo.Trim() != "")
        //        sb.Append("AND pmh.PolicyNo='" + PolicyNo.Trim() + "'");

        //    if (PatientID.Trim() != "")
        //        sb.Append("AND pm.PatientID='" + PatientID.Trim() + "'");

        //    sb.Append("   GROUP BY ltd.LedgerTransactionNo  HAVING IsInvoice=0       ");
        //    sb.Append("                   )temp  LEFT JOIN f_dispatch dis ON temp.TransactionID = dis.TransactionID  AND dis.isCancel=0     ");
        //    sb.Append(" LEFT JOIN f_dispatchday_master dism ON dism.PanelID =temp.PanelID AND dism.IsActive=1   )t  ");

        //    if (Status == "0")
        //        sb.Append(" WHERE DispatchDate<>'' AND t.IsSettled=0   AND  t.OutStanding>0 ");
        //    else if (Status == "1")
        //        sb.Append(" WHERE DispatchDate=''  AND t.IsSettled=0  AND  t.OutStanding>0");
        //    else
        //        sb.Append(" WHERE t.IsSettled=0 AND  t.OutStanding>0 ");
        //}

        //string query = sb.ToString();

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public string saveDispatch(object Dispatch, int CentreID)
    {
        List<DispatchMaster> dataDispatch = new JavaScriptSerializer().ConvertToType<List<DispatchMaster>>(Dispatch);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string dispatch = "", LedgerTransactionNO = "", BillNo = "";
            string TPAInvNo = "";
            int strDispatchhNo = 0, isDispatch = 0;
            string panelInvoiceNo = "";
            for (int i = 0; i < dataDispatch.Count; i++)
            {
                DispatchMaster dm = new DispatchMaster(tranX);
                dm.Type = Util.GetString(dataDispatch[i].Type).Trim();
                dm.TransactionID = Util.GetString(dataDispatch[i].TransactionID);
                dm.DateOfAdmission = Util.GetDateTime(dataDispatch[i].DateOfAdmission);
                dm.DateOfDischarge = Util.GetDateTime(dataDispatch[i].DateOfDischarge);
                dm.PName = Util.GetString(dataDispatch[i].PName);
                dm.PanelName = Util.GetString(dataDispatch[i].PanelName);
                dm.BillAmount = Util.GetDecimal(dataDispatch[i].BillAmount);
                dm.DispatchDate = Util.GetDateTime(dataDispatch[i].DispatchDate);
                dm.DocketNo = Util.GetString(dataDispatch[i].DocketNo);
                dm.Remarks = Util.GetString(dataDispatch[i].Remarks);
                dm.DispatchDayValidity = Util.GetInt(dataDispatch[i].DispatchDayValidity);
                dm.DispatchDayID = Util.GetInt(dataDispatch[i].DispatchDayID);
                dm.UserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                dm.CourierComp = Util.GetString(dataDispatch[i].CourierComp);
                dm.Ref1 = Util.GetString(dataDispatch[i].Ref1);
                dm.Ref2 = Util.GetString(dataDispatch[i].Ref2);
                dm.PatientID = Util.GetString(dataDispatch[i].PatientID);
                dm.PanelID = Util.GetInt(dataDispatch[i].PanelID);
                dm.PanelAmt = Util.GetDecimal(dataDispatch[i].PanelAmt);
                dm.LedgerTransactionNO = Util.GetString(dataDispatch[i].LedgerTransactionNO);
                dm.BillNo = Util.GetString(dataDispatch[i].BillNo);
                dm.BillDate = Util.GetDateTime(dataDispatch[i].BillDate);
                dm.GrossAmount = Util.GetDecimal(dataDispatch[i].GrossAmount);
                dm.DiscAmt = Util.GetDecimal(dataDispatch[i].DiscAmt);
                dm.policyNo = Util.GetString(dataDispatch[i].policyNo);
                dm.cardNo = Util.GetString(dataDispatch[i].cardNo);
                dm.CoverNoteNo = Util.GetString(dataDispatch[i].CoverNoteNo);
                dm.CoverNoteDate = Util.GetDateTime(dataDispatch[i].CoverNoteDate);
                dm.PanelPaidAmt = Util.GetDecimal(dataDispatch[i].PanelPaidAmt);
                dm.PatientPaybleAmt = Util.GetDecimal(dataDispatch[i].PatientPaybleAmt);
                dm.PatientPaidAmt = Util.GetDecimal(dataDispatch[i].PatientPaidAmt);
                dm.OutStanding = Util.GetDecimal(dataDispatch[i].OutStanding);
                dm.IPDNetAmount = Util.GetDecimal(dataDispatch[i].IPDNetAmount);
                dm.OPDNetAmount = Util.GetDecimal(dataDispatch[i].OPDNetAmount);
                if (dataDispatch[i].DispatchID == "")
                {
                    if (panelInvoiceNo == "")
                    {
                        panelInvoiceNo = SalesEntry.getPanelInvoiceNo(tranX, CentreID, con);
                        if (panelInvoiceNo == null || panelInvoiceNo=="")
                        {
                            return "0";
                        }
                    }
                    dm.panelInvoiceNo = panelInvoiceNo;
                    if (Util.GetString(dataDispatch[i].Type).Trim().ToUpper() == "OPD" || Util.GetString(dataDispatch[i].Type).Trim().ToUpper() == "EMG")
                    {
                        if (LedgerTransactionNO == "")
                            LedgerTransactionNO += "'" + dataDispatch[i].LedgerTransactionNO + "'";
                        else
                            LedgerTransactionNO += "," + "'" + dataDispatch[i].LedgerTransactionNO + "'";
                    }
                    if (Util.GetString(dataDispatch[i].Type).Trim().ToUpper() == "IPD")
                    {
                        if (BillNo == "")
                            BillNo += "'" + dataDispatch[i].BillNo + "'";
                        else
                            BillNo += "," + "'" + dataDispatch[i].BillNo + "'";
                    }


                    if (strDispatchhNo == 0)
                        strDispatchhNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT IFNULL(MAX(Dispatch_No),0)+1 FROM f_dispatch"));
                    dm.DispatchNo = Util.GetString(strDispatchhNo);
                    dm.IpAddress = All_LoadData.IpAddress();
                    dm.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    dispatch = dm.Insert().ToString();


                    // Recovery Module---------------------------------
                    TPAInvNo = panelInvoiceNo;
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_dispatch SET TPAInvNo='" + panelInvoiceNo + "',TPAInvDate=now(),TPAInvCreatedBy='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' where DispatchID='" + dispatch + "' and TransactionID='" + Util.GetString(dataDispatch[i].TransactionID) + "' ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE patient_medical_history SET IsTPAInvActive=1,TPAInvNo='" + panelInvoiceNo + "',TPAInvDate=now(),TPAInvCreatedBy='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' where TransactionID='" + Util.GetString(dataDispatch[i].TransactionID) + "' ");//f_ipdadjustment
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO TPA_Invoice_Detail(TPAInvNo,TPA,PanelID,PatientID,TransactionID,PName,DateofAdmit,DateofDischarge,BillDate,BillNo,BillAmt,ClaimNo,DispatchDate,DocketNo,CourierCompany,DispatchedBy,PatientType,TPAInvoiceDate,TPAInvCreatedBy)VALUES('" + panelInvoiceNo + "','" + Util.GetString(dataDispatch[i].PanelName) + "'," + Util.GetInt(dataDispatch[i].PanelID) + ",'" + Util.GetString(dataDispatch[i].PatientID) + "','" + Util.GetString(dataDispatch[i].TransactionID) + "','" + Util.GetString(dataDispatch[i].PName) + "','" + Util.GetDateTime(dataDispatch[i].DateOfAdmission).ToString("yyyy-MM-dd hh:mm:ss") + "','" + Util.GetDateTime(dataDispatch[i].DateOfDischarge).ToString("yyyy-MM-dd hh:mm:ss") + "','" + Util.GetDateTime(dataDispatch[i].BillDate).ToString("yyyy-MM-dd hh:mm:ss") + "','" + Util.GetString(dataDispatch[i].BillNo) + "','" + Util.GetDecimal(dataDispatch[i].BillAmount) + "','" + Util.GetString(dataDispatch[i].policyNo) + "','" + Util.GetDateTime(dataDispatch[i].DispatchDate).ToString("yyyy-MM-dd hh:mm:ss") + "','" + Util.GetString(dataDispatch[i].DocketNo) + "','" + Util.GetString(dataDispatch[i].CourierComp) + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "','IPD',now(),'" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "')");
                }
                else
                {
                    isDispatch = 1;
                    // panelInvoiceNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT panelInvoiceNo FROM f_dispatch Where DispatchID='" + dataDispatch[i].DispatchID + "'"));
                    // dm.panelInvoiceNo = panelInvoiceNo;
                    dm.DispatchID = Util.GetString(dataDispatch[i].DispatchID);
                    panelInvoiceNo = dataDispatch[i].panelInvoiceNo;
                    dispatch = dm.Update().ToString();
                }
                if (dispatch == "")
                    return "0";
            }



            if (isDispatch == 0)
            {
                if (panelInvoiceNo != "")
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_generate_tpa_invoice(TPAInvNo,PanelID,UserId)VALUES('" + TPAInvNo + "'," + Util.GetInt(dataDispatch[0].PanelID) + ",'" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "')");
                }
                if (LedgerTransactionNO.Trim() != "")
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_ledgertransaction lt INNER JOIN patient_medical_history pmh on pmh.TransactionID=lt.TransactionID SET lt.panelInvoiceNo ='" + panelInvoiceNo + "',pmh.panelInvoiceNo ='" + panelInvoiceNo + "' WHERE LedgerTransactionNO IN (" + LedgerTransactionNO + ")");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_covernote SET IsInvoice=1,InvoiceDate=NOW(),InvoiceUserID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "',InvoiceNo='" + panelInvoiceNo + "' WHERE LedgerTransactionNo  IN (" + LedgerTransactionNO + ")");

                }
                else if (BillNo.Trim() != "")
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE patient_medical_history SET panelInvoiceNo ='" + panelInvoiceNo + "' WHERE BillNo IN (" + BillNo + ")");//f_ipdadjustment
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_covernote SET IsInvoice=1,InvoiceDate=NOW(),InvoiceUserID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "',InvoiceNo='" + panelInvoiceNo + "' WHERE BillNo IN (" + BillNo + ") ");


                }
            }

            tranX.Commit();
            return panelInvoiceNo;
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable searchInvoicedata(string InvoiceNo, string IPDNo)
    {
        DataTable dt = StockReports.GetDataTable("CALL panel_invoicesearch('" + InvoiceNo + "','" + IPDNo + "'," + HttpContext.Current.Session["CentreID"].ToString() + ")");
        return dt;
    }
    public DataTable invoiceDetailData(string invoiceNo, string IPDNo)
    {
        DataTable dt = StockReports.GetDataTable("CALL panel_invoiceDetail('" + invoiceNo + "','" + IPDNo + "')");
        return dt;
    }


    public decimal GetCalAmount(decimal totalBillAmount, decimal totalPayAmount, decimal ledBillAmount)
    {

        decimal s = (totalPayAmount * 100 / totalBillAmount);

        return Math.Round((ledBillAmount * s / 100), 2);
    }



    public string saveSettlement(object Invoice, decimal ReceivedAmount, decimal TDSAmount, decimal WriteOff, decimal DeducationAmt, string Type, string InvoiceNo, string InvoiceDate, int PanelID, string PatientType, decimal balanceAmount, decimal InvoiceAmount, int CentreID, string onAccountVoucharID)
    {
        List<panelInvoiceData> Invoiceinfo = new JavaScriptSerializer().ConvertToType<List<panelInvoiceData>>(Invoice);
        DataTable currencyDetail = AllLoadData_OPD.Cash();


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        string userID = HttpContext.Current.Session["ID"].ToString();
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {



            //   if (Resources.Resource.AllowFiananceIntegration == "1")
            // {

            if (Util.GetInt(onAccountVoucharID) > 0)
            {
                string remaningAmountAfterSettled = StockReports.ExecuteScalar("SELECT pt.GL_AMT_BS-(pt.SettledAmount+(" + Util.GetDecimal(ReceivedAmount) + "/" + Util.GetDecimal(Invoiceinfo[0].currencyFactor) + ")) FROM  ess.panel$onaccount pt WHERE pt.IsCancel=0 AND pt.ID=" + onAccountVoucharID);

                if (Util.GetDecimal(remaningAmountAfterSettled) < 0)
                {
                    tranX.Rollback();
                    return "2";
                }
                else
                {
                    excuteCMD.DML(tranX, "UPDATE ess.panel$onaccount pt SET  pt.SettledAmount=(pt.SettledAmount+@amount) WHERE pt.ID=@id", CommandType.Text, new
                    {
                        id = onAccountVoucharID,
                        invoiceNo = InvoiceNo,
                        userID = userID,
                        amount = ReceivedAmount / Util.GetDecimal(Invoiceinfo[0].currencyFactor)
                    });


                    excuteCMD.DML(tranX, "INSERT INTO panelonaccountsettlement (Voucher_ID, SettledBy,SettledAmount, PanelInvoiceNo, CentreID ) VALUES (@Voucher_ID,@userID,@settledAmount,@panelInvoiceNo,@CentreID)", CommandType.Text, new
                    {

                        Voucher_ID = onAccountVoucharID,
                        userID = userID,
                        settledAmount = ReceivedAmount / Util.GetDecimal(Invoiceinfo[0].currencyFactor),
                        panelInvoiceNo = InvoiceNo,
                        CentreID = CentreID
                    });

                }
            }
            //}


            DateTime InvDate = Util.GetDateTime(InvoiceDate);
            panelonaccount po = new panelonaccount(tranX);
            po.InvoiceNo = InvoiceNo;
            po.InvoiceDate = Util.GetDateTime(InvDate.ToString("yyyy-MM-dd"));
            po.ReceivedAmount = Util.GetDecimal(ReceivedAmount);
            po.TDSAmount = Util.GetDecimal(TDSAmount);
            po.WriteOff = Util.GetDecimal(WriteOff);
            po.DeducationAmt = Util.GetDecimal(DeducationAmt);
            po.Type = Type;
            po.CreatedBy = userID;
            po.IPAddress = All_LoadData.IpAddress();
            po.PanelID = Util.GetInt(PanelID);
            po.PatientType = PatientType;
            po.balanceAmount = balanceAmount;
            po.InvoiceAmount = InvoiceAmount;
            po.CentreID = CentreID;
            string inv = po.Insert();
            for (int i = 0; i < Invoiceinfo.Count; i++)
            {

                DataTable dtd = StockReports.GetDataTable("SELECT d.OutStanding BillAmount,d.IPDNetAmount,d.OPDNetAmount FROM f_dispatch d WHERE d.TransactionID='" + Invoiceinfo[i].TransactionID + "' AND d.isCancel=0");
                DataTable dts = StockReports.GetDataTable("SELECT lt.LedgerTransactionNo,(lt.NetAmount-lt.Adjustment)PAmount,lt.TransactionID  FROM f_ledgertransaction lt WHERE lt.IPNo='" + Invoiceinfo[i].TransactionID + "' AND lt.IsIPDMerged=1 AND lt.IsCancel=0 AND lt.NetAmount>lt.Adjustment");

                decimal totalPaymentAmount = Invoiceinfo[i].Amount;
                decimal totaltdsAmount = Invoiceinfo[i].TDSAmount;
                decimal totalDeducationAmt = Invoiceinfo[i].DeducationAmt;
                decimal totalwriteOff = Invoiceinfo[i].writeOff;


                decimal totalBillAmouunt = Util.GetDecimal(dtd.Rows[0]["BillAmount"]);

                if (dts.Rows.Count > 0)
                {
                    Invoiceinfo[i].panelAmount = Util.GetDecimal(dtd.Rows[0]["IPDNetAmount"]);
                    Invoiceinfo[i].Amount = GetCalAmount(totalBillAmouunt, totalPaymentAmount, Util.GetDecimal(dtd.Rows[0]["IPDNetAmount"]));
                    Invoiceinfo[i].DeducationAmt = GetCalAmount(totalBillAmouunt, totalDeducationAmt, Util.GetDecimal(dtd.Rows[0]["IPDNetAmount"]));
                    Invoiceinfo[i].TDSAmount = GetCalAmount(totalBillAmouunt, totaltdsAmount, Util.GetDecimal(dtd.Rows[0]["IPDNetAmount"]));
                    Invoiceinfo[i].writeOff = GetCalAmount(totalBillAmouunt, totalwriteOff, Util.GetDecimal(dtd.Rows[0]["IPDNetAmount"]));
                }


                Receipt objRecipt = new Receipt(tranX);
                string LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(Invoiceinfo[i].PatientID, "PTNT", con);
                if (LedgerNoCr == null)
                    objRecipt.LedgerNoCr = "";
                else
                    objRecipt.LedgerNoCr = LedgerNoCr;

                if (Invoiceinfo[i].TransactionID.Contains("ISHHI"))
                {
                    objRecipt.LedgerNoDr = "";
                }
                else
                {
                    if (Util.GetDecimal(balanceAmount) > 0)
                        objRecipt.LedgerNoDr = "HOSP0006";
                    else
                        objRecipt.LedgerNoDr = "HOSP0005";
                }
                objRecipt.AmountPaid = Invoiceinfo[i].Amount;
                objRecipt.AsainstLedgerTnxNo = Invoiceinfo[i].LedgertransactionNo;
                objRecipt.PanelID = PanelID;
                objRecipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                objRecipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objRecipt.Reciever = userID;
                objRecipt.Depositor = Invoiceinfo[i].PatientID;
                objRecipt.TransactionID = Invoiceinfo[i].TransactionID;
                objRecipt.IsPayementByInsurance = "COMPANY";
                objRecipt.Naration = "Panel Invoice Settlement";
                objRecipt.PaidBy = "PAN";
                objRecipt.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objRecipt.panelInvoiceNo = InvoiceNo;
                objRecipt.deductions = Invoiceinfo[i].DeducationAmt;
                objRecipt.UniqueHash = Util.getHash();
                objRecipt.TDS = Invoiceinfo[i].TDSAmount;
                objRecipt.WriteOff = Invoiceinfo[i].writeOff;
                objRecipt.IpAddress = All_LoadData.IpAddress();
                objRecipt.CentreID = CentreID;
                string ReceiptNo = objRecipt.Insert();

                currencyDetail = All_LoadData.LoadCurrencyFactor(Invoiceinfo[i].currency);

                Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tranX);
                ObjReceiptPayment.PaymentModeID = Util.GetInt(Invoiceinfo[i].PaymentModeID);
                ObjReceiptPayment.PaymentMode = Util.GetString(Invoiceinfo[i].PaymentMode);
                ObjReceiptPayment.Amount = Util.GetDecimal(Invoiceinfo[i].Amount);
                ObjReceiptPayment.ReceiptNo = ReceiptNo;
                ObjReceiptPayment.PaymentRemarks = Util.GetString("Panel Invoice Settlement");
                ObjReceiptPayment.RefDate = Util.GetDateTime(Invoiceinfo[i].chequeDate);
                ObjReceiptPayment.RefNo = Util.GetString(Invoiceinfo[i].chequeNo);
                ObjReceiptPayment.BankName = Util.GetString(Invoiceinfo[i].bankName);
                //ObjReceiptPayment.S_Amount = Util.GetDecimal(Invoiceinfo[i].Amount);
                //ObjReceiptPayment.C_Factor = Util.GetDecimal(currencyDetail.Rows[0]["Selling_Specific"].ToString());
                //ObjReceiptPayment.S_CountryID = Util.GetInt(currencyDetail.Rows[0]["S_CountryID"].ToString());

                ObjReceiptPayment.S_Amount = Util.GetDecimal(Invoiceinfo[i].Amount) / Util.GetDecimal(Invoiceinfo[i].currencyFactor);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(Invoiceinfo[i].currencyFactor);
                ObjReceiptPayment.S_CountryID = Util.GetInt(Invoiceinfo[i].currency);
                ObjReceiptPayment.S_Currency = Util.GetString(currencyDetail.Rows[0]["S_Currency"].ToString());
                // ObjReceiptPayment.S_Notation = Util.GetString(Resources.Resource.BaseCurrencyNotation);
                ObjReceiptPayment.S_Notation = Util.GetString(currencyDetail.Rows[0]["S_Notation"].ToString());
                ObjReceiptPayment.deductions = Invoiceinfo[i].DeducationAmt;
                ObjReceiptPayment.TDS = Invoiceinfo[i].TDSAmount;
                ObjReceiptPayment.WriteOff = Invoiceinfo[i].writeOff;
                ObjReceiptPayment.CentreID = CentreID;
                ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceiptPayment.un_VoucherID = Util.GetInt(onAccountVoucharID);
                ObjReceiptPayment.swipeMachine = Util.GetString(Invoiceinfo[i].machineName);
                string PaymentID = ObjReceiptPayment.Insert().ToString();

                if (Resources.Resource.AllowFiananceIntegration == "1")//
                {
                    excuteCMD.DML(tranX, " call insert_panel_unallocation_log(@ID,@settledAmount,@ToPanel,@userID,@transferId,@availType,@receiptNo,@invoiceNo,@CentreID,0) ", CommandType.Text, new
                    {
                        ToPanel = 0,
                        userID = userID,
                        settledAmount = ObjReceiptPayment.S_Amount,
                        ID = Util.GetInt(onAccountVoucharID),
                        transferId = 0,
                        availType = "PAT",
                        receiptNo = ReceiptNo,
                        invoiceNo = InvoiceNo,
                        CentreID = CentreID
                    });
                }




                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = string.Empty;
                    if (Invoiceinfo[i].TransactionID.Contains("ISHHI"))
                    {
                        IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(0, ReceiptNo, "S", tranX));
                    }
                    else
                    {
                        int IsEmerygency = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT COUNT(*) FROM emergency_patient_details e WHERE e.TransactionId='" + Invoiceinfo[i].TransactionID + "'"));
                        if (IsEmerygency > 0)
                        {
                            IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(0, ReceiptNo, "S", "", tranX));
                        }
                        else
                        {
                            IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(0, ReceiptNo, "S", tranX));
                        }
                    }
                    if (IsIntegrated == "0")
                    {
                        tranX.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                    }
                }

                PanelOnaccount_Detail pad = new PanelOnaccount_Detail(tranX);
                pad.PanelAccountID = Util.GetInt(inv);
                pad.ReceivedAmount = Util.GetDecimal(Invoiceinfo[i].Amount);
                pad.TDSAmount = Util.GetDecimal(Invoiceinfo[i].TDSAmount);
                pad.WriteOff = Util.GetDecimal(Invoiceinfo[i].writeOff);
                pad.DeducationAmt = Util.GetDecimal(Invoiceinfo[i].DeducationAmt);
                pad.PanelID = Util.GetInt(PanelID);
                pad.InvoiceNo = InvoiceNo;
                pad.balanceAmount = Util.GetDecimal(Invoiceinfo[i].panelAmount) - (Util.GetDecimal(Invoiceinfo[i].Amount) + Util.GetDecimal(Invoiceinfo[i].TDSAmount) + Util.GetDecimal(Invoiceinfo[i].writeOff) + Util.GetDecimal(Invoiceinfo[i].DeducationAmt));
                pad.PatientType = PatientType;
                pad.paymentModeID = Util.GetInt(Invoiceinfo[i].PaymentModeID);
                pad.paymentMode = Invoiceinfo[i].PaymentMode;
                pad.ChequeNo = Invoiceinfo[i].chequeNo;
                pad.ChequeDate = Util.GetDateTime(Invoiceinfo[i].chequeDate);
                pad.bankName = Invoiceinfo[i].bankName;
                pad.CreatedBy = userID;
                pad.LedgertransactionNo = Invoiceinfo[i].LedgertransactionNo;
                pad.TransactionID = Invoiceinfo[i].TransactionID;
                pad.ReceiptNo = ReceiptNo;
                pad.PatientID = Invoiceinfo[i].PatientID;
                pad.IpAddress = All_LoadData.IpAddress();
                pad.CentreID = CentreID;
                string invd = pad.Insert();

                decimal settleAmount = (Util.GetDecimal(Invoiceinfo[i].Amount) + Util.GetDecimal(Invoiceinfo[i].TDSAmount) + Util.GetDecimal(Invoiceinfo[i].writeOff) + Util.GetDecimal(Invoiceinfo[i].DeducationAmt));
                decimal previousTotalAmt = 0;

                StringBuilder sb1 = new StringBuilder();
                sb1.Append("  SELECT SUM(IFNULL(ReceivedAmount,0)+IFNULL(TDSAmount,0)+IFNULL(WriteOff,0)+IFNULL(DeducationAmt,0))previousTotalAmt ");
                sb1.Append(" FROM f_panelonaccount_Detail	WHERE InvoiceNo='" + InvoiceNo + "' AND ");
                sb1.Append(" TransactionID='" + Invoiceinfo[i].TransactionID.ToString() + "' AND IsCancelled=0 ");
                previousTotalAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb1.ToString()));

                StringBuilder sb = new StringBuilder();
                sb.Append(" update f_dispatch dis  set ");
                if (Util.GetDecimal(Util.GetDecimal(Invoiceinfo[i].panelAmount) - (Util.GetDecimal(settleAmount) + Util.GetDecimal(previousTotalAmt))) == 0)
                    sb.Append(" IsSettled=1 ");
                else
                    sb.Append(" IsSettled=2 ");
                sb.Append(" ,SettledDate=now(),settleAmount =settleAmount+" + Util.GetDecimal(settleAmount) + ", PanelPaidAmt= IFNULL(PanelPaidAmt,0) +" + Util.GetDecimal(settleAmount) + ", Outstanding= IFNULL(Outstanding,0) -" + Util.GetDecimal(settleAmount) + " where TransactionID='" + Invoiceinfo[i].TransactionID.ToString() + "' and PanelID='" + Util.GetInt(PanelID) + "' AND PanelInvoiceNo='" + InvoiceNo + "' ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update patient_medical_history set TDS=IFNULL(TDS,'0')+" + Util.GetDecimal(Invoiceinfo[i].TDSAmount) + ",WriteOff=IFNULL(WriteOff,'0')+ " + Util.GetDecimal(Invoiceinfo[i].writeOff) + " , " +
                    " Deduction_Acceptable=IFNULL(Deduction_Acceptable,'0') +" + Util.GetDecimal(Invoiceinfo[i].DeducationAmt) + ",FinalSettledDate=now(), PanelPaidAmt= IFNULL(PanelPaidAmt,0) +" + Util.GetDecimal(settleAmount) + " WHERE TransactionID='" + Invoiceinfo[i].TransactionID.ToString() + "' ");


                for (int j = 0; j < dts.Rows.Count; j++)
                {
                    Invoiceinfo[i].LedgertransactionNo = dts.Rows[j]["LedgerTransactionNo"].ToString();
                    Invoiceinfo[i].panelAmount = Util.GetDecimal(dts.Rows[j]["PAmount"]);
                    Invoiceinfo[i].Amount = GetCalAmount(totalBillAmouunt, totalPaymentAmount, Util.GetDecimal(dts.Rows[j]["PAmount"]));
                    Invoiceinfo[i].DeducationAmt = GetCalAmount(totalBillAmouunt, totalDeducationAmt, Util.GetDecimal(dts.Rows[j]["PAmount"]));
                    Invoiceinfo[i].TDSAmount = GetCalAmount(totalBillAmouunt, totaltdsAmount, Util.GetDecimal(dts.Rows[j]["PAmount"]));
                    Invoiceinfo[i].writeOff = GetCalAmount(totalBillAmouunt, totalwriteOff, Util.GetDecimal(dts.Rows[j]["PAmount"]));
                    Invoiceinfo[i].TransactionID = (dts.Rows[j]["TransactionID"]).ToString();



                    objRecipt = new Receipt(tranX);
                    LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(Invoiceinfo[i].PatientID, "PTNT", con);
                    if (LedgerNoCr == null)
                        objRecipt.LedgerNoCr = "";
                    else
                        objRecipt.LedgerNoCr = LedgerNoCr;

                    if (Util.GetDecimal(balanceAmount) > 0)
                        objRecipt.LedgerNoDr = "HOSP0006";
                    else
                        objRecipt.LedgerNoDr = "HOSP0005";
                    objRecipt.AmountPaid = Invoiceinfo[i].Amount;
                    objRecipt.AsainstLedgerTnxNo = Invoiceinfo[i].LedgertransactionNo;
                    objRecipt.PanelID = PanelID;
                    objRecipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    objRecipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objRecipt.Reciever = userID;
                    objRecipt.Depositor = Invoiceinfo[i].PatientID;
                    objRecipt.TransactionID = Invoiceinfo[i].TransactionID;
                    objRecipt.IsPayementByInsurance = "COMPANY";
                    objRecipt.Naration = "Panel Invoice Settlement";
                    objRecipt.PaidBy = "PAN";
                    objRecipt.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    objRecipt.panelInvoiceNo = InvoiceNo;
                    objRecipt.deductions = Invoiceinfo[i].DeducationAmt;
                    objRecipt.UniqueHash = Util.getHash();
                    objRecipt.TDS = Invoiceinfo[i].TDSAmount;
                    objRecipt.WriteOff = Invoiceinfo[i].writeOff;
                    objRecipt.IpAddress = All_LoadData.IpAddress();
                    objRecipt.CentreID = CentreID;
                    ReceiptNo = objRecipt.Insert();

                    currencyDetail = All_LoadData.LoadCurrencyFactor(Invoiceinfo[i].currency);

                    ObjReceiptPayment = new Receipt_PaymentDetail(tranX);
                    ObjReceiptPayment.PaymentModeID = Util.GetInt(Invoiceinfo[i].PaymentModeID);
                    ObjReceiptPayment.PaymentMode = Util.GetString(Invoiceinfo[i].PaymentMode);
                    ObjReceiptPayment.Amount = Util.GetDecimal(Invoiceinfo[i].Amount);
                    ObjReceiptPayment.ReceiptNo = ReceiptNo;
                    ObjReceiptPayment.PaymentRemarks = Util.GetString("Panel Invoice Settlement");
                    ObjReceiptPayment.RefDate = Util.GetDateTime(Invoiceinfo[i].chequeDate);
                    ObjReceiptPayment.RefNo = Util.GetString(Invoiceinfo[i].chequeNo);
                    ObjReceiptPayment.BankName = Util.GetString(Invoiceinfo[i].bankName);

                    //ObjReceiptPayment.S_Amount = Util.GetDecimal(Invoiceinfo[i].Amount);
                    //ObjReceiptPayment.C_Factor = Util.GetDecimal(currencyDetail.Rows[0]["Selling_Specific"].ToString());
                    //ObjReceiptPayment.S_CountryID = Util.GetInt(currencyDetail.Rows[0]["S_CountryID"].ToString());

                    ObjReceiptPayment.S_Amount = Util.GetDecimal(Invoiceinfo[i].Amount) / Util.GetDecimal(Invoiceinfo[i].currencyFactor);
                    ObjReceiptPayment.C_Factor = Util.GetDecimal(Invoiceinfo[i].currencyFactor);
                    ObjReceiptPayment.S_CountryID = Util.GetInt(Invoiceinfo[i].currency);

                    ObjReceiptPayment.S_Currency = Util.GetString(currencyDetail.Rows[0]["S_Currency"].ToString());
                    //   ObjReceiptPayment.S_Notation = Util.GetString(Resources.Resource.BaseCurrencyNotation);
                    ObjReceiptPayment.S_Notation = Util.GetString(currencyDetail.Rows[0]["S_Notation"].ToString());

                    ObjReceiptPayment.deductions = Invoiceinfo[i].DeducationAmt;
                    ObjReceiptPayment.TDS = Invoiceinfo[i].TDSAmount;
                    ObjReceiptPayment.WriteOff = Invoiceinfo[i].writeOff;
                    ObjReceiptPayment.CentreID = CentreID;
                    ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    PaymentID = ObjReceiptPayment.Insert().ToString();

                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(0, ReceiptNo, "S", tranX));

                        if (IsIntegrated == "0")
                        {
                            tranX.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                        }
                    }
                    pad = new PanelOnaccount_Detail(tranX);
                    pad.PanelAccountID = Util.GetInt(inv);
                    pad.ReceivedAmount = Util.GetDecimal(Invoiceinfo[i].Amount);
                    pad.TDSAmount = Util.GetDecimal(Invoiceinfo[i].TDSAmount);
                    pad.WriteOff = Util.GetDecimal(Invoiceinfo[i].writeOff);
                    pad.DeducationAmt = Util.GetDecimal(Invoiceinfo[i].DeducationAmt);
                    pad.PanelID = Util.GetInt(PanelID);
                    pad.InvoiceNo = InvoiceNo;
                    pad.balanceAmount = Util.GetDecimal(Invoiceinfo[i].panelAmount) - (Util.GetDecimal(Invoiceinfo[i].Amount) + Util.GetDecimal(Invoiceinfo[i].TDSAmount) + Util.GetDecimal(Invoiceinfo[i].writeOff) + Util.GetDecimal(Invoiceinfo[i].DeducationAmt));
                    pad.PatientType = PatientType;
                    pad.paymentModeID = Util.GetInt(Invoiceinfo[i].PaymentModeID);
                    pad.paymentMode = Invoiceinfo[i].PaymentMode;
                    pad.ChequeNo = Invoiceinfo[i].chequeNo;
                    pad.ChequeDate = Util.GetDateTime(Invoiceinfo[i].chequeDate);
                    pad.bankName = Invoiceinfo[i].bankName;
                    pad.CreatedBy = userID;
                    pad.LedgertransactionNo = Invoiceinfo[i].LedgertransactionNo;
                    pad.TransactionID = Invoiceinfo[i].TransactionID;
                    pad.ReceiptNo = ReceiptNo;
                    pad.PatientID = Invoiceinfo[i].PatientID;
                    pad.IpAddress = All_LoadData.IpAddress();
                    pad.CentreID = CentreID;
                    invd = pad.Insert();

                    settleAmount = (Util.GetDecimal(Invoiceinfo[i].Amount) + Util.GetDecimal(Invoiceinfo[i].TDSAmount) + Util.GetDecimal(Invoiceinfo[i].writeOff) + Util.GetDecimal(Invoiceinfo[i].DeducationAmt));
                    previousTotalAmt = 0;

                    sb1 = new StringBuilder();
                    sb1.Append("  SELECT SUM(IFNULL(ReceivedAmount,0)+IFNULL(TDSAmount,0)+IFNULL(WriteOff,0)+IFNULL(DeducationAmt,0))previousTotalAmt ");
                    sb1.Append(" FROM f_panelonaccount_Detail	WHERE InvoiceNo='" + InvoiceNo + "' AND ");
                    sb1.Append(" TransactionID='" + Invoiceinfo[i].TransactionID.ToString() + "' AND IsCancelled=0 ");
                    previousTotalAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb1.ToString()));

                    sb = new StringBuilder();
                    sb.Append(" update f_dispatch dis  set ");
                    if (Util.GetDecimal(Util.GetDecimal(Invoiceinfo[i].panelAmount) - (Util.GetDecimal(settleAmount) + Util.GetDecimal(previousTotalAmt))) == 0)
                        sb.Append(" IsSettled=1 ");
                    else
                        sb.Append(" IsSettled=2 ");
                    sb.Append(" ,SettledDate=now(),settleAmount =settleAmount+" + Util.GetDecimal(settleAmount) + ", PanelPaidAmt= IFNULL(PanelPaidAmt,0) +" + Util.GetDecimal(settleAmount) + ", Outstanding= IFNULL(Outstanding,0) -" + Util.GetDecimal(settleAmount) + " where TransactionID='" + Invoiceinfo[i].TransactionID.ToString() + "'  and PanelID='" + Util.GetInt(PanelID) + "' AND PanelInvoiceNo='" + InvoiceNo + "'  ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update patient_medical_history set TDS=IFNULL(TDS,'0')+" + Util.GetDecimal(Invoiceinfo[i].TDSAmount) + ",WriteOff=IFNULL(WriteOff,'0')+ " + Util.GetDecimal(Invoiceinfo[i].writeOff) + " , " +
                        " Deduction_Acceptable=IFNULL(Deduction_Acceptable,'0') +" + Util.GetDecimal(Invoiceinfo[i].DeducationAmt) + ",FinalSettledDate=now(), PanelPaidAmt= IFNULL(PanelPaidAmt,0) +" + Util.GetDecimal(settleAmount) + " WHERE TransactionID='" + Invoiceinfo[i].TransactionID.ToString() + "'");


                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_ledgertransaction set Adjustment=Adjustment+" + settleAmount + ",AdjustmentDate=now() where LedgerTransactionNo='" + Invoiceinfo[i].LedgertransactionNo.ToString() + "'");


                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  patient_medical_history pmh SET pmh.PanelPaidAmt=pmh.PanelPaidAmt+" + settleAmount + " WHERE pmh.TransactionID='" + Invoiceinfo[i] + "'");





                }
                if (Invoiceinfo[i].writeOff != 0)
                {
                    excuteCMD.DML(tranX, "INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason,IsActive,IsVerified,VerifiedBy,VerifiedOn) VALUES (@transactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason,@IsActive,@IsVerified,@VerifiedBy,now())", CommandType.Text, new
                    {
                        transactionID = Invoiceinfo[i].TransactionID,
                        panelID = PanelID,
                        writeOffAmount = Invoiceinfo[i].writeOff,
                        entryBy = HttpContext.Current.Session["ID"].ToString(),
                        writeOffReason = "",
                        IsActive="1",
                        IsVerified="1",
                        VerifiedBy=HttpContext.Current.Session["ID"].ToString()

                    });
                }

            }

            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class panelInvoiceData
    {
        public string TransactionID { get; set; }
        public string LedgertransactionNo { get; set; }
        public decimal Amount { get; set; }
        public string PatientID { get; set; }
        public decimal TDSAmount { get; set; }
        public decimal writeOff { get; set; }
        public decimal DeducationAmt { get; set; }
        public decimal panelAmount { get; set; }
        public decimal billAmount { get; set; }
        public string PaymentModeID { get; set; }
        public string PaymentMode { get; set; }
        public string bankName { get; set; }
        public string machineName { get; set; }
        public string chequeDate { get; set; }
        public string chequeNo { get; set; }
        public string currency { get; set; }
        public string currencyFactor { get; set; }
    }
    public DataTable InvoiceCancelData(string invoiceNo)
    {
        DataTable dt = StockReports.GetDataTable("CALL panel_invoiceCancelSearch('" + invoiceNo + "')");
        return dt;
    }
    public string InvoiceCancel(string InvoiceNo, string ID, decimal receivedAmt, decimal tdsAmt, decimal writeOff, decimal decAmt, string cancelReason, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string userID = HttpContext.Current.Session["ID"].ToString();
            StringBuilder sb = new StringBuilder();
            if (Type == "OPD" || Type == "EMG")
            {
                sb.Append(" UPDATE f_reciept re INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=re.AsainstLedgerTnxNo  ");
                sb.Append(" INNER JOIN patient_medical_history PMH ON PMH.TransactionID=lt.TransactionID ");
                sb.Append(" INNER JOIN f_panelonaccount_detail pad ON pad.ReceiptNo=re.ReceiptNo ");
                sb.Append(" INNER JOIN f_panelonaccount pa ON pad.PanelAccountID=pa.ID ");
                sb.Append(" INNER JOIN f_dispatch dis ON dis.PanelInvoiceNo=pad.InvoiceNo AND pad.`TransactionID`=dis.`TransactionID` AND pad.`PanelID`=dis.`PanelID` ");
                sb.Append(" SET re.IsCancel=1,re.CancelReason='" + cancelReason + "',re.CancelDate=NOW(),re.Cancel_UserID='" + userID + "', ");
                sb.Append(" lt.Adjustment=(lt.Adjustment-(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), ");
                sb.Append(" PMH.TDS=(IFNULL(PMH.TDS,0)-pad.TDSAmount), ");
                sb.Append(" PMH.Writeoff=(IFNULL(PMH.WriteOff,0)-pad.WriteOff),");
                sb.Append(" PMH.Deduction_Acceptable=(IFNULL(PMH.Deduction_Acceptable,0)-pad.DeducationAmt), dis.`OutStanding`= (dis.OutStanding+(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)),");
                sb.Append(" dis.IsSettled=2,dis.SettleAmount=(dis.SettleAmount-(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), dis.PanelPaidAmt= (dis.PanelPaidAmt-(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), dis.Outstanding= (dis.Outstanding+(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), ");
                sb.Append(" pa.IsCancelled=1,pa.CancelledBy='" + userID + "',pa.CancelDateTime=now(),pa.CancelReason='" + cancelReason + "', ");
                sb.Append(" pad.IsCancelled=1,pad.CancelledBy='" + userID + "',pad.CancelDateTime=now(),pad.CancelReason='" + cancelReason + "' ");
                sb.Append(" where pa.ID='" + ID + "' ");
            }
            else
            {
                sb.Append(" UPDATE f_panelonaccount pa INNER JOIN  f_panelonaccount_detail pad ON pa.ID = pad.PanelAccountID  ");
                sb.Append(" INNER JOIN f_reciept re ON re.receiptNo = pad.receiptNo ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = re.TransactionID INNER JOIN f_dispatch dis ON dis.PanelInvoiceNo=pa.InvoiceNo  AND pad.`TransactionID`=dis.`TransactionID` AND pad.`PanelID`=dis.`PanelID` ");
                sb.Append(" SET re.IsCancel=1,re.Cancelreason='" + cancelReason + "',re.CancelDate=NOW(),re.Cancel_UserID='" + userID + "',                  ");
                sb.Append(" PMH.TDS=(IFNULL(PMH.TDS,0)-pad.TDSAmount), ");
                sb.Append(" PMH.Writeoff=(IFNULL(PMH.WriteOff,0)-pad.WriteOff), ");
                sb.Append(" PMH.Deduction_Acceptable=(IFNULL(PMH.Deduction_Acceptable,0)-pad.DeducationAmt),  ");
                sb.Append(" dis.IsSettled=2,dis.SettleAmount=(dis.SettleAmount-(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), dis.PanelPaidAmt= (dis.PanelPaidAmt-(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), dis.`OutStanding`= (dis.OutStanding+(pa.ReceivedAmount+pa.TDSAmount+pa.WriteOff+pa.DeducationAmt)), ");
                sb.Append(" pa.IsCancelled=1,pa.CancelledBy='" + userID + "',pa.CancelDateTime=NOW(),pa.CancelReason='" + cancelReason + "', ");
                sb.Append(" pad.IsCancelled=1,pad.CancelledBy='" + userID + "',pad.CancelDateTime=NOW(),pad.CancelReason='" + cancelReason + "' ");
                sb.Append(" WHERE  pa.ID='" + ID + "'  ");
            }
            int rowsAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            if (rowsAffected > 0)
            {
                tnx.Commit();
                return "1";
            }
            else
            {
                tnx.Rollback();
                return "0";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public string dispatchCancelData(string InvoiceNo)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_dispatch WHERE PanelinvoiceNo='" + InvoiceNo + "' AND isSettled<>0 and IsCancel=0 "));
        if (count > 0)
            return "0";
        else
            return "1";
    }
    public DataTable dispatchData(string InvoiceNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT PatientID,BillNo,PanelAmount,fpm.PanelID,fpm.Company_Name,DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate,dis.Type,dis.PanelinvoiceNo FROM f_dispatch dis INNER JOIN f_panel_master fpm ");
        sb.Append(" ON fpm.PanelID=dis.PanelID WHERE PanelinvoiceNo='" + InvoiceNo + "' AND isSettled=0 And IsCancel=0 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    public string dispatchCancel(string InvoiceNo, string cancelReason, string type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("UPDATE f_dispatch SET isCancel=1,CancelledBy='" + HttpContext.Current.Session["ID"].ToString() + "',CancelDateTime=now(),CancelReason='" + cancelReason + "' WHERE PanelinvoiceNo='" + InvoiceNo + "' AND IsDispatched=1");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            //if (type == "OPD")
            //{
            //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction SET PanelinvoiceNo='' WHERE PanelinvoiceNo='" + InvoiceNo + "'");
            //}
            //else
            //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_medical_history SET PanelinvoiceNo='' WHERE PanelinvoiceNo='" + InvoiceNo + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction SET PanelinvoiceNo='' WHERE PanelinvoiceNo='" + InvoiceNo + "'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_medical_history SET PanelinvoiceNo='' WHERE PanelinvoiceNo='" + InvoiceNo + "'");

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public static string dispatchReportAll(string InvoiceNo, string Type, string dispatchNo = "")
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT dis.PatientID,dis.PanelID,dis.PanelName,dis.BillAmount,dis.panelAmount,     ");
            sb.Append(" if(IFNULL(dis.CoverNoteNo,'')='',DATE_FORMAT(dis.Billdate,'%d-%b-%Y'),DATE_FORMAT(dis.CoverNoteDate,'%d-%b-%Y'))BillDate,DATE_FORMAT(dis.DateOfAdmission,'%d-%b-%Y')DOA,DATE_FORMAT(dis.DateOfDischarge,'%d-%b-%Y')DOD, ");
            sb.Append(" if(IFNULL(dis.CoverNoteNo,'')='',dis.BillNo,dis.CoverNoteNo)BillNo  ,dis.PanelInvoiceNo, ");
            sb.Append(" IF(IFNULL(dis.CoverNoteNo,'')='',dis.PanelAmount,SUM(dis.PanelAmount))panelAmount,dis.PatientID,dis.PanelID,dis.PanelName,dis.BillAmount,dis.PName,DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate,dis.Dispatch_No,dis.DocketNo,     ");
            sb.Append(" dis.Remarks,DATE_FORMAT(dis.EntryDate,'%d-%b-%Y')EntryDate,dis.GrossAmount,dis.discAmt,dis.type,dis.policyNo,dis.cardNo ,   ");
            sb.Append(" IF(dis.Type='IPD',REPLACE(dis.TransactionID,'ISHHI',''),'')IPDNo,IF(dis.Type='IPD',IFNULL(adj.ClaimNo,''),'')ClaimNo,IFNULL(dis.CoverNoteNo,'')CoverNoteNo ");
            sb.Append(" ,dis.PanelPaidAmt,dis.PatientPaybleAmt,dis.PatientPaidAmt,dis.OutStanding ");
            sb.Append(" FROM f_dispatch dis ");
            sb.Append(" LEFT JOIN f_ipdadjustment adj ON dis.TransactionID=adj.TransactionID ");
            sb.Append(" WHERE  dis.IsDispatched=1 AND dis.isCancel=0 ");
            if (InvoiceNo != "")
                sb.Append("   AND dis.PanelInvoiceNo='" + InvoiceNo + "'   ");
            if (dispatchNo != "")
                sb.Append("   AND dis.Dispatch_No='" + dispatchNo + "'   ");
            sb.Append(" GROUP BY dis.TransactionID ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();

                DataColumn dc = new DataColumn();
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "Dispatch";

                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "logo";
                //ds.WriteXmlSchema("D:\\dispatchReportNew.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "dispatchReportAll";
                return "1";
            }
            else
                return "2";

        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
            return "0";
        }
    }

    public static DataTable dtPanelInvoice()
    {
        return StockReports.GetDataTable("SELECT PanelID,Company_Name FROM f_panel_master WHERE IsActive=1 AND PanelID<>1");
    }
    public static void bindInvoicePanel(DropDownList ddlObject, string Type = "")
    {
        DataTable dtData = dtPanelInvoice();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Company_Name";
            ddlObject.DataValueField = "PanelID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem(Type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
}