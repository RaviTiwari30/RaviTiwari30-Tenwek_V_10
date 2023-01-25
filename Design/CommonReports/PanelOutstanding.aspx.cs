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
using System.Text;
using System.IO;
using MySql.Data.MySqlClient;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

[Serializable]
public partial class Design_CommonReports_PanelOutstanding : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
            BindCentre();
            BindPanel();
        }
        // txtFromDate.Attributes.Add("readonly", "true");
        // txtToDate.Attributes.Add("readonly", "true");
    }





    public void BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Centre(Session["ID"].ToString());
        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Session["CentreID"].ToString()));
    }

    public void BindPanel()
    {
        int CentreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        DataTable dt = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID FROM f_panel_master pm INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID WHERE pm.Isactive=1 AND fcp.CentreID='" + CentreID + "' AND fcp.isActive=1 AND pm.DateTo>NOW() ORDER BY Company_Name");
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
        ddlPanel.Items.Insert(0, new ListItem("All", "0"));
        ddlPanel.SelectedIndex = -1;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (rbtReportType.SelectedItem.Value != "2")
        {
            if (ddlReportType.SelectedValue == "2")
            {
                lblMsg.Text = "Please Select The Excel";
                return;
            }
        }
        string startDate = string.Empty, toDate = string.Empty;

        startDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");

        toDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
        //return;
        StringBuilder sb = new StringBuilder();

        if (ddlReportType.SelectedValue != "4")
        {
            if (ddlDateType.SelectedValue == "5" && ddlTotalOutstanding.SelectedValue == "2")
            {
                sb.Append(" CALL sp_PanelAllocation('" + startDate + "','" + toDate + "'," + Util.GetInt(ddlCentre.SelectedValue) + ",'" + Util.GetInt(ddlReportType.SelectedValue) + "') ");
            }
            else
            {

                if (ddlReportType.SelectedValue == "3")
                {
                    sb.Append("SELECT GROUP_CONCAT(DISTINCT(CentreName))CentreName,GROUP_CONCAT( DISTINCT(PanelGroup))PanelGroup,GROUP_CONCAT(DISTINCT(PanelName))PanelName,GROUP_CONCAT(DISTINCT(RefNo))RefNo,GROUP_CONCAT(DISTINCT(PanelInvoiceNo))PanelInvoiceNo,GROUP_CONCAT(DISTINCT(PatientType))PatientType,GROUP_CONCAT(DISTINCT(IPDNO))IPDNO,GROUP_CONCAT(DISTINCT(BillDate))BillDate, GROUP_CONCAT(DISTINCT(BillNo))BillNo,PatientID,PatientName,IF(PatientType='OPD', sum(BillAmt) ,BillAmt) BillAmt, ");
                    sb.Append("	IF(PatientType='OPD', sum(DiscAmt) ,DiscAmt) DiscAmt, IF(PatientType='OPD', sum(NetAmt) ,NetAmt) NetAmt,SUM(ClaimAmt)ClaimAmt,SUM(ReceivedAmt)ReceivedAmt, ");
                    sb.Append("SUM(Outstanding)Outstanding,SUM(PatientPayableAmt)PatientPayableAmt,SUM(PatientPaidAmt)PatientPaidAmt,SUM(PatientOutstanding)PatientOutstanding,SUM(TotalOutstanding)TotalOutstanding  FROM  ( ");

                }
                if (ddlReportType.SelectedValue == "2")
                {
                    sb.Append("SELECT t.CentreName,t.PanelName,sum(t.ClaimAmt)OutStanding from ( ");
                }
                sb.Append("SELECT CM.CentreName,a.PanelGroup,a.PanelName,a.RefNo,a.PanelInvoiceNo,a.PatientType,IF(a.PatientType='IPD',REPLACE(a.TransNo,'ISHHI',''),'')IPDNO,a.BillDate, a.BillNo,a.PatientID,PatientName,ROUND(a.BillAmt,2)BillAmt, ");
                sb.Append("	ROUND(a.DiscAmt,2)DiscAmt,ROUND(a.NetAmt,2)NetAmt,ROUND(a.ClaimAmt,2)ClaimAmt,ROUND(a.ReceivedAmt,2)ReceivedAmt, ");
                if (ddlReportType.SelectedValue == "3")
                {
                    sb.Append(" a.TransactionID, a.EncounterNo, ");
                }
                sb.Append("ROUND(a.Outstanding,2)Outstanding,ROUND(a.PatientPayableAmt,2)PatientPayableAmt,ROUND(a.PatientPaidAmt,2)PatientPaidAmt,(ROUND(a.PatientPayableAmt,2)-ROUND(a.PatientPaidAmt,2))PatientOutstanding,ROUND(a.TotalOutstanding,2)TotalOutstanding  FROM  ( ");
                //# IPD
                if (ddlPatientType.SelectedValue == "Both" || ddlPatientType.SelectedValue == "IPD")
                {
                    sb.Append("SELECT t.CentreID,t.Aging,t.TransactionID, t.PanelID,t.PanelGroup,t.PanelName,t.RefNo,t.PanelInvoiceNo,t.PatientType,t.BillDate, t.BillNo,t.PatientID,UPPER(t.PName) AS PatientName,t.BillAmt,t.DiscAmt,t.NetAmt,t.ClaimAmt,t.ReceivedAmt,(t.ClaimAmt-t.ReceivedAmt) Outstanding, ");
                    sb.Append("t.PatientPayableAmt,t.PatientPaidAmt,(t.ClaimAmt+t.PatientPayableAmt-t.ReceivedAmt-t.PatientPaidAmt) AS TotalOutstanding,t.TransNo,t.EncounterNo FROM ( ");
                    sb.Append("SELECT adj.CentreID, ");
                    sb.Append("(DATEDIFF(CURDATE(),IF(" + ddlDateType.SelectedValue + "=1,adj.DateOfAdmit,IF(" + ddlDateType.SelectedValue + "=2,adj.DateOfDischarge,IF(" + ddlDateType.SelectedValue + "=3, ");
                    sb.Append("DATE(adj.BillDate),IF(" + ddlDateType.SelectedValue + "=4,dp.DispatchDate,DATE(paa.EntryOn))))))+1)Aging, ");
                    sb.Append("adj.TransactionID,adj.PatientID,PNL.PanelID,pnl.PanelGroup,pnl.Company_Name AS PanelName, ");
                    sb.Append("(SELECT IFNULL(GROUP_CONCAT(DISTINCT ipa.ClaimNo),'') FROM f_ipdpanelapproval ipa WHERE ipa.TransactionID=adj.TransactionID ");
                    sb.Append("AND ipa.isActive=1)  AS RefNo, ");
                    sb.Append("IFNULL(GROUP_CONCAT(DISTINCT dp.PanelInvoiceNo),'') AS PanelInvoiceNo,'IPD' PatientType,  ");
                    sb.Append("IF(IFNULL(adj.BillNo,'')='','NA',DATE_FORMAT(adj.BillDate,'%Y-%m-%d')) AS BillDate,IF(IFNULL(adj.BillNo,'')='','NOT-GENERATE',adj.BillNo) AS BillNo,pm.PName, ");
                    sb.Append("IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,1),0) AS BillAmt,IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,3),0) AS DiscAmt,IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,2),0) AS NetAmt ");
                    sb.Append(",SUM(paa.Amount) ClaimAmt, IFNULL(GETPanelReceivedAmt(adj.TransactionID,paa.PanelID),0) ReceivedAmt,0 PatientPayableAmt, 0 PatientPaidAmt,adj.`TransNo`,adj.`TransNo` EncounterNo ");
                    sb.Append("FROM patient_medical_history adj   ");

                    sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=adj.PatientID ");
                    if (!string.IsNullOrEmpty(txtUHID.Text.Trim()))
                        sb.Append("AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
                    sb.Append("INNER JOIN panel_amountallocation paa ON adj.TransactionID=paa.TransactionID  AND paa.PanelID<>1 ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=paa.PanelID ");
                    sb.Append("LEFT JOIN f_dispatch dp ON dp.TransactionID=adj.TransactionID  ");
                    sb.Append("WHERE adj.PatientID<>'' AND adj.Type='IPD'  ");
                    if (ddlCentre.SelectedValue != "0")
                        sb.Append("AND adj.CentreID=" + ddlCentre.SelectedValue + " ");
                    if (ddlDateType.SelectedValue == "1")
                        sb.Append("AND adj.DateOfAdmit>='" + startDate + "' AND adj.DateOfAdmit<='" + toDate + "' ");
                    if (ddlDateType.SelectedValue == "2")
                        sb.Append("AND adj.DateOfDischarge>='" + startDate + "' AND adj.DateOfDischarge<='" + toDate + "' ");
                    if (ddlDateType.SelectedValue == "3")
                        sb.Append("AND adj.BillDate>=CONCAT('" + startDate + "',' 00:00:00') AND adj.BillDate<=CONCAT('" + toDate + "',' 23:59:59') ");
                    if (ddlDateType.SelectedValue == "4")
                        sb.Append("AND dp.DispatchDate>='" + startDate + "' AND dp.DispatchDate<='" + toDate + "' ");
                    if (ddlDateType.SelectedValue == "5")
                        sb.Append("AND paa.EntryOn>=CONCAT('" + startDate + "',' 00:00:00') AND paa.EntryOn<=CONCAT('" + toDate + "',' 23:59:59') ");
                    if (!string.IsNullOrEmpty(txtBillNo.Text.Trim()))
                        sb.Append("AND adj.BillNo='" + txtBillNo.Text.Trim() + "' ");
                    sb.Append("GROUP BY adj.TransactionID,paa.PanelID ");
                    sb.Append("UNION ALL ");
                    sb.Append("Select * from (SELECT adj.CentreID, ");
                    sb.Append("(DATEDIFF(CURDATE(),IF(" + ddlDateType.SelectedValue + "=1,adj.DateOfAdmit,IF(" + ddlDateType.SelectedValue + "=2,adj.DateOfDischarge,DATE(adj.BillDate))))+1)Aging, ");
                    sb.Append("adj.TransactionID,adj.PatientID,1 PanelID,pnl.PanelGroup,CONCAT('CASH',' - ', pnl.Company_Name) AS PanelName, '' RefNo,'' PanelInvoiceNo,'IPD' PatientType,  ");
                    sb.Append("IF(IFNULL(adj.BillNo,'')='','NA',DATE_FORMAT(adj.BillDate,'%Y-%m-%d')) AS BillDate,IF(IFNULL(adj.BillNo,'')='','NOT-GENERATE',adj.BillNo) AS BillNo,pm.PName, ");
                    sb.Append("IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,1),0) AS BillAmt,IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,3),0) AS DiscAmt,IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,2),0) AS NetAmt,0 ClaimAmt,0 ReceivedAmt, ");
                    sb.Append("ROUND((IFNULL(GETIPDBillGrossDiscNet(adj.TransactionID,2),0) -IFNULL(( SELECT ROUND(SUM(Amount),4) FROM panel_amountallocation paa WHERE paa.TransactionID=adj.TransactionID  AND paa.PanelID<>1),0)),4) PatientPayableAmt, ");
                    sb.Append("ROUND(SUM(IFNULL(rt.AmountPaid,0)),4) PatientPaidAmt,adj.`TransNo`,adj.`TransNo` EncounterNo ");
                    sb.Append("FROM  patient_medical_history adj  INNER JOIN f_panel_master pnl ON pnl.PanelID=adj.PanelID ");
                    if (ddlDateType.SelectedValue == "1")
                        sb.Append("AND adj.DateOfAdmit>='" + startDate + "' AND adj.DateOfAdmit<='" + toDate + "' ");
                    if (ddlDateType.SelectedValue == "2")
                        sb.Append("AND adj.DateOfDischarge>='" + startDate + "' AND adj.DateOfDischarge<='" + toDate + "' ");
                    sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=adj.PatientID ");
                    if (!string.IsNullOrEmpty(txtUHID.Text.Trim()))
                        sb.Append("AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
                    sb.Append("LEFT JOIN f_reciept rt  ON adj.TransactionID=rt.TransactionID AND rt.IsCancel=0 AND rt.PaidBy='PAT'  ");
                    sb.Append("WHERE adj.PatientID<>'' AND adj.Type='IPD'  ");
                    if (ddlCentre.SelectedValue != "0")
                        sb.Append("AND adj.CentreID=" + ddlCentre.SelectedValue + "  ");
                    if (ddlDateType.SelectedValue == "3")
                        sb.Append("AND adj.BillDate>=CONCAT('" + startDate + "',' 00:00:00') AND adj.BillDate<=CONCAT('" + toDate + "',' 23:59:59') ");
                    //if(ddlDateType.SelectedValue == "4")
                    //sb.Append("AND IF(("+ ddlDateType.SelectedValue +"=4 OR "+ ddlDateType.SelectedValue +"=5),adj.TransactionID=0,1=1) ");
                    if (!string.IsNullOrEmpty(txtBillNo.Text.Trim()))
                        sb.Append("AND adj.BillNo='" + txtBillNo.Text.Trim() + "'   ");
                    sb.Append("GROUP BY adj.TransactionID  HAVING (PatientPayableAmt<>0 OR PatientPaidAmt<>0)  ORDER BY PanelID,TransactionID)t0 ");
                    if (ddlPanel.SelectedValue != "0")
                        sb.Append("WHERE t0.PanelID='" + ddlPanel.SelectedValue + "' ");
                    sb.Append(")t   ");
                }
                if (ddlPatientType.SelectedValue == "Both")
                {
                    sb.Append("UNION ALL ");
                }
                //# EMG
                if (ddlPatientType.SelectedValue == "Both" || ddlPatientType.SelectedValue == "EMG")
                {
                    sb.Append("SELECT t.CentreID,t.Aging,t.TransactionID,t.PanelID,t.PanelGroup,t.PanelName,t.RefNo,t.PanelInvoiceNo,t.PatientType,t.BillDate, t.BillNo,t.PatientID,UPPER(t.PName) AS PatientName,t.BillAmt,t.DiscAmt,t.NetAmt,t.ClaimAmt,t.ReceivedAmt,(t.ClaimAmt-t.ReceivedAmt) Outstanding, ");
                    sb.Append("t.PatientPayableAmt,t.PatientPaidAmt,(t.ClaimAmt+t.PatientPayableAmt-t.ReceivedAmt-t.PatientPaidAmt) AS TotalOutstanding,t.TransNo,t.EncounterNo FROM ( ");
                    sb.Append("SELECT lt.CentreID, ");
                    sb.Append("(DATEDIFF(CURDATE(),IF(" + ddlDateType.SelectedValue + "=1,DATE(ich.EnteredOn),IF(" + ddlDateType.SelectedValue + "=2,DATE(ich.ReleasedDateTime),IF(" + ddlDateType.SelectedValue + "=3, ");
                    sb.Append("DATE(lt.Date),IF(" + ddlDateType.SelectedValue + "=4,dp.DispatchDate,DATE(paa.EntryOn))))))+1)Aging, ");
                    sb.Append("lt.TransactionID,lt.PatientID,PNL.PanelID,pnl.PanelGroup,pnl.Company_Name AS PanelName,IFNULL(GROUP_CONCAT(DISTINCT ipa.ClaimNo),'') AS RefNo,IFNULL(GROUP_CONCAT(DISTINCT dp.PanelInvoiceNo),'') AS PanelInvoiceNo,'EMG' PatientType,  ");
                    sb.Append("IF(IFNULL(lt.BillNo,'')='','NA',DATE_FORMAT(lt.Date,'%Y-%m-%d')) AS BillDate,IF(IFNULL(lt.BillNo,'')='','NOT-GENERATE',lt.BillNo) AS BillNo, ");
                    sb.Append("pm.PName,lt.GrossAmount AS BillAmt,lt.DiscountOnTotal AS DiscAmt,lt.NetAmount AS NetAmt ");
                    sb.Append(",SUM(Distinct paa.Amount) ClaimAmt, IFNULL(GETPanelReceivedAmt(lt.TransactionID,paa.PanelID),0) ReceivedAmt,0 PatientPayableAmt, 0 PatientPaidAmt,pmh.`TransNo`,pmh.`TransNo` EncounterNo ");
                    sb.Append("FROM f_LedgerTransaction lt   ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID  ");
                    sb.Append("AND pmh.Type='EMG' ");
                    sb.Append("INNER JOIN emergency_patient_details ich ON ich.LedgerTransactionNo=lt.LedgerTransactionNo ");
                    if (ddlDateType.SelectedValue == "1")
                        sb.Append("AND ich.EnteredOn>=CONCAT('" + startDate + "',' 00:00:00') AND ich.EnteredOn<=CONCAT('" + toDate + "',' 23:59:59') ");
                    if (ddlDateType.SelectedValue == "2")
                        sb.Append("AND ich.ReleasedDateTime>=CONCAT('" + startDate + "',' 00:00:00') AND ich.ReleasedDateTime<=CONCAT('" + toDate + "',' 23:59:59') ");
                    sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=lt.PatientID ");
                    if (!string.IsNullOrEmpty(txtUHID.Text.Trim()))
                        sb.Append("AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");

                    sb.Append("INNER JOIN panel_amountallocation paa ON lt.TransactionID=paa.TransactionID  AND paa.PanelID<>1 ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=paa.PanelID ");
                    sb.Append("LEFT JOIN f_opdpanelapproval ipa ON ipa.TransactionID=lt.TransactionID AND ipa.isActive=1 ");
                    sb.Append("LEFT JOIN f_dispatch dp ON dp.TransactionID=lt.TransactionID  ");
                    sb.Append("WHERE LT.TypeOfTnx='Emergency' ");
                    if (ddlDateType.SelectedValue == "3")
                        sb.Append("AND lt.Date>='" + startDate + "' AND lt.Date<='" + toDate + "' ");
                    if (ddlDateType.SelectedValue == "4")
                        sb.Append("AND dp.DispatchDate>='" + startDate + "' AND dp.DispatchDate<='" + toDate + "' ");
                    if (ddlDateType.SelectedValue == "5")
                        sb.Append("AND paa.EntryOn>=CONCAT('" + startDate + "',' 00:00:00') AND paa.EntryOn<=CONCAT('" + toDate + "',' 23:59:59') ");
                    if (!string.IsNullOrEmpty(txtBillNo.Text.Trim()))
                        sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "'  ");
                    if (ddlCentre.SelectedValue != "0")
                        sb.Append("AND lt.CentreID=" + ddlCentre.SelectedValue + " ");
                    sb.Append("GROUP BY lt.TransactionID,paa.PanelID ");
                    sb.Append("UNION ALL ");
                    sb.Append("Select * from (SELECT lt.CentreID, ");
                    sb.Append("(DATEDIFF(CURDATE(),IF(" + ddlDateType.SelectedValue + "=1,DATE(ich.EnteredOn),IF(" + ddlDateType.SelectedValue + "=2,DATE(ich.ReleasedDateTime),DATE(lt.Date))))+1)Aging, ");
                    sb.Append("lt.TransactionID,lt.PatientID,1 PanelID,pnl.PanelGroup,CONCAT('CASH',' - ', pnl.Company_Name) AS PanelName,'' AS RefNo,'' PanelInvoiceNo,'EMG' PatientType,  ");
                    sb.Append("IF(IFNULL(lt.BillNo,'')='','NA',DATE_FORMAT(lt.Date,'%Y-%m-%d')) AS BillDate,IF(IFNULL(lt.BillNo,'')='','NOT-GENERATE',lt.BillNo) AS BillNo, ");
                    sb.Append("pm.PName,lt.GrossAmount AS BillAmt,lt.DiscountOnTotal AS DiscAmt,lt.NetAmount AS NetAmt,0 ClaimAmt,0 ReceivedAmt, ");
                    sb.Append("ROUND((lt.NetAmount -IFNULL(( SELECT ROUND(SUM(Amount),4) FROM panel_amountallocation paa WHERE paa.TransactionID=lt.TransactionID  AND paa.PanelID<>1),0)),4) PatientPayableAmt, ");
                    sb.Append("ROUND(SUM(IFNULL(rt.AmountPaid,0)),4) PatientPaidAmt,pmh.`TransNo`,pmh.`TransNo` EncounterNo ");
                    sb.Append("FROM  f_LedgerTransaction lt INNER JOIN f_panel_master pnl ON pnl.PanelID=lt.PanelID  ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID  ");
                    sb.Append("AND pmh.Type='EMG' ");
                    sb.Append("INNER JOIN emergency_patient_details ich ON ich.LedgerTransactionNo=lt.LedgerTransactionNo ");
                    if (ddlPatientType.SelectedValue == "1")
                        sb.Append("AND ich.EnteredOn>=CONCAT('" + startDate + "',' 00:00:00') AND ich.EnteredOn<=CONCAT('" + toDate + "',' 23:59:59') ");
                    if (ddlPatientType.SelectedValue == "2")
                        sb.Append("AND ich.ReleasedDateTime>=CONCAT('" + startDate + "',' 00:00:00') AND ich.ReleasedDateTime<=CONCAT('" + toDate + "',' 23:59:59')  ");
                    sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=lt.PatientID ");
                    if (!string.IsNullOrEmpty(txtUHID.Text.Trim()))
                        sb.Append("AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
                    sb.Append("LEFT JOIN f_reciept rt  ON rt.AsainstLedgerTnxNo=lt.LedgertransactionNo AND rt.IsCancel=0 AND rt.PaidBy='PAT'  ");
                    sb.Append("WHERE LT.TypeOfTnx='Emergency' ");
                    if (ddlDateType.SelectedValue == "3")
                        sb.Append("AND lt.Date>='" + startDate + "' AND lt.Date<='" + toDate + "' ");
                    //if(ddlDateType.SelectedValue == "4")
                    sb.Append("AND IF((" + ddlDateType.SelectedValue + "=4 OR " + ddlDateType.SelectedValue + "=5),LT.TypeOfTnx<>'Emergency',1=1) ");
                    if (!string.IsNullOrEmpty(txtBillNo.Text.Trim()))
                        sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
                    if (ddlCentre.SelectedValue != "0")
                        sb.Append("AND lt.CentreID=" + ddlCentre.SelectedValue + " ");
                    sb.Append("GROUP BY lt.TransactionID  HAVING (PatientPayableAmt<>0 OR PatientPaidAmt<>0)  ORDER BY PanelID,TransactionID)t0 ");
                    if (ddlPanel.SelectedValue != "0")
                        sb.Append("WHERE t0.PanelID='" + ddlPanel.SelectedValue + "' ");
                    sb.Append(")t ");
                }
                if (ddlPatientType.SelectedValue == "Both")
                {
                    sb.Append("UNION ALL ");
                }
                //# OPD
                if (ddlPatientType.SelectedValue == "Both" || ddlPatientType.SelectedValue == "OPD")
                {
                    sb.Append("SELECT t.CentreID,t.Aging,t.TransactionID,t.PanelID,t.PanelGroup ,t.PanelName,t.RefNo,t.PanelInvoiceNo,t.PatientType,t.BillDate, t.BillNo,t.PatientID,UPPER(t.PName) AS PatientName,t.BillAmt,t.DiscAmt,t.NetAmt,t.ClaimAmt,t.ReceivedAmt, ");
                    sb.Append("(t.ClaimAmt-t.ReceivedAmt) Outstanding,t.PatientPayableAmt,t.PatientPaidAmt,(t.ClaimAmt+PatientPayableAmt-t.ReceivedAmt-t.PatientPaidAmt) AS TotalOutstanding,t.TransNo,t.EncounterNo FROM ( ");
                    sb.Append("SELECT lt.CentreID, ");
                    sb.Append("(DATEDIFF(CURDATE(),IF(" + ddlDateType.SelectedValue + "=3,lt.Date,dp.DispatchDate))+1)Aging, ");
                    sb.Append("lt.TransactionID,lt.PatientID,PNL.PanelID,pnl.PanelGroup,pnl.Company_Name AS PanelName,'' AS RefNo,IFNULL(GROUP_CONCAT(DISTINCT dp.PanelInvoiceNo),'') PanelInvoiceNo, ");
                    sb.Append("'OPD' PatientType, IF(IFNULL(lt.BillNo,'')='','NA',DATE_FORMAT(lt.Date,'%Y-%m-%d')) AS BillDate,IF(IFNULL(lt.BillNo,'')='','NOT-GENERATE',lt.BillNo) AS BillNo, ");
                    sb.Append("pm.PName,lt.GrossAmount AS BillAmt,lt.DiscountOnTotal AS DiscAmt,lt.NetAmount AS NetAmt, ");
                    sb.Append("IFNULL(( SELECT ROUND(SUM(Amount),4) FROM panel_amountallocation paa WHERE paa.TransactionID=lt.TransactionID  AND paa.PanelID<>1),0) ClaimAmt,pmh.PanelPaidAmt ReceivedAmt,ROUND((lt.NetAmount -IFNULL(( SELECT ROUND(SUM(Amount),4) FROM panel_amountallocation paa WHERE paa.TransactionID=lt.TransactionID  AND paa.PanelID<>1),0)),4)PatientPayableAmt,ROUND(SUM(IFNULL(rt.AmountPaid,0)),4) PatientPaidAmt,pmh.`TransNo`,lt.`EncounterNo` ");
                    sb.Append("FROM  f_LedgerTransaction lt   ");
                    sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID  ");
                    sb.Append("AND pmh.Type='OPD' ");
                    sb.Append("AND IF((" + ddlDateType.SelectedValue + "=1 OR " + ddlDateType.SelectedValue + "=2 OR " + ddlDateType.SelectedValue + "=5), pmh.Type<>'OPD',1=1) ");
                    sb.Append("INNER JOIN f_panel_master pnl  ON pnl.PanelID=pmh.PanelID ");
                    sb.Append("LEFT JOIN f_reciept rt  ON rt.AsainstLedgerTnxNo=lt.LedgertransactionNo AND rt.IsCancel=0 AND rt.PaidBy='PAT'  ");
                    sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=lt.PatientID ");
                    if (!string.IsNullOrEmpty(txtUHID.Text.Trim()))
                        sb.Append("AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
                    sb.Append("LEFT JOIN f_dispatch dp ON dp.TransactionID=lt.TransactionID  ");
                    if (ddlDateType.SelectedValue == "3")
                        sb.Append("WHERE lt.Date>='" + startDate + "' AND  lt.Date<='" + toDate + "' ");
                    if (!string.IsNullOrEmpty(txtBillNo.Text.Trim()))
                        sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
                    if (ddlDateType.SelectedValue == "4")
                        sb.Append("AND dp.DispatchDate>='" + startDate + "' AND dp.DispatchDate<='" + toDate + "' ");
                    if (ddlCentre.SelectedValue != "0")
                        sb.Append("AND lt.CentreID=" + ddlCentre.SelectedValue + "   ");
                    sb.Append("AND lt.NetAmount<>lt.Adjustment GROUP BY lt.TransactionID  ORDER BY PanelID,TransactionID ");
                    sb.Append(")t ");
                    sb.Append("ORDER BY PanelName,PatientType,PatientName ");
                }
                sb.Append(")a INNER JOIN center_master cm ON cm.CentreID=a.CentreID  WHERE 1=1 ");
                if (ddlPanel.SelectedValue != "0")
                    sb.Append("AND a.PanelID=" + ddlPanel.SelectedValue + " ");
                if (ddlPatientType.SelectedValue != "Both")
                    sb.Append("AND PatientType='" + ddlPatientType.SelectedValue + "' ");
                //if(!string.IsNullOrEmpty(txtReceiptNo.Text.Trim()))
                //sb.Append("AND IF('"+txtReceiptNo.Text.Trim() +"'<>'',a.TransactionID='',1=1)  ");
                if (ddlAgingCriteria.SelectedValue != "0")
                    sb.Append("AND a.Aging>=" + Util.GetInt(ddlAgingCriteria.SelectedItem.Value.Split('-')[0].ToString()) + " AND a.Aging<=" + Util.GetInt(ddlAgingCriteria.SelectedItem.Value.Split('-')[1].ToString()) + " ");
                if (ddlTotalOutstanding.SelectedValue == "1")
                    sb.Append("AND TotalOutstanding>0 ");
                if (ddlReportType.SelectedValue == "2")
                {
                    sb.Append(")t GROUP BY t.CentreName,t.PanelName ORDER BY t.BillNo DESC; ");
                }

                if (ddlReportType.SelectedValue == "3")
                {
                    sb.Append(")t GROUP BY t.PatientID,t.EncounterNo,t.BillNo,t.PatientType ORDER BY t.BillNo DESC; ");
                }

            }
            //StreamWriter tsw = new StreamWriter(@"E:\query.txt", true);
            //tsw.WriteLine(sb.ToString());
            //tsw.Close();

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                if (rbtReportType.SelectedItem.Value == "2")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "Period From : " + txtFromDate.Text + " To : " + txtToDate.Text;
                    dt.Columns.Add(dc);
                    dt = Util.GetDataTableRowSum(dt);

                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCachedt(CacheName, dt);
                    string ReportName = "Panel Outstanding Report";
                    if (ddlReportType.SelectedValue == "3")
                    {
                        ReportName = "Panel Outstanding Summary Report";

                    }
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
                }
                else
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "From : " + txtFromDate.Text + " To : " + txtToDate.Text;
                    dt.Columns.Add(dc);
                    DataTable dtImg = All_LoadData.CrystalReportLogo();
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtImg.Copy());
                    ds.Tables.Add(dt.Copy());
                    //  ds.WriteXmlSchema(@"E:\\PanelOutstanding.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "PanelOutstanding";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                }
            }
            else
                lblMsg.Text = "No Record Found";
        }
        else {

            StringBuilder sbs = new StringBuilder();

            sbs.Append(" SELECT t.*,IF(t.PanelPayableAmount=PanelPaidAmount,'Completed','Pending')OutStandingStatus FROM (SELECT pmh.PatientID AS UHID, ");
            sbs.Append(" IF(pmh.`TYPE`='OPD',GROUP_CONCAT(DISTINCT lt.`EncounterNo`),pmh.`TransNo`)'EN/IPD/EMGNo', ");
            sbs.Append(" fpm.`PanelGroup`,fpm.`Company_Name` as PanelName,concat(Pm.title,pm.Pname) AS PatientName  ,pmh.`TYPE` as PatientType,fd.`panelInvoiceNo` as InvoiceNumber, ");
            sbs.Append(" CONCAT(DATE_FORMAT(fd.`EntryDate`,'%d-%b-%Y'),' ',TIME_FORMAT(fd.`EntryDate`,'%h:%i:%s %p'))InvoiceDate, ");
            sbs.Append(" IFNULL((SELECT SUM(pal.Amount) FROM `panel_amountallocation` pal WHERE pal.TransactionID=fd.`TransactionID`  AND pal.Panelid=fd.`PanelID`),0)PanelPayableAmount, ");
            sbs.Append(" IFNULL((SELECT SUM(AmountPaid) FROM `f_reciept` rt WHERE rt.TransactionID=fd.`TransactionID` AND rt.PanelID=fd.Panelid AND rt.PaidBy='PAN'),0)PanelPaidAmount ");
            sbs.Append(" FROM f_ledgertransaction lt ");
            sbs.Append(" INNER JOIN `patient_medical_history` pmh ON lt.`TransactionID`=pmh.`TransactionID` ");
            sbs.Append(" INNER JOIN `f_dispatch` fd ON pmh.`TransactionID`=fd.`TransactionID` ");
            sbs.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
            sbs.Append(" INNER JOIN `f_panel_master` fpm ON fpm.`PanelID`=fd.`PanelID`  WHERE ");
           
            if(ddlDateType.SelectedValue=="3")
            {
                 sbs.Append(" DATE(pmh.BillDate)>='" + startDate + "' AND date(pmh.BillDate)<='" + toDate + "' ");
            }
            else if (ddlDateType.SelectedValue == "4")
                        sbs.Append("AND fd.DispatchDate>='" + startDate + "' AND fd.DispatchDate<='" + toDate + "' ");

            else if (ddlDateType.SelectedValue == "1")
                sbs.Append("AND adj.DateOfAdmit>='" + startDate + "' AND adj.DateOfAdmit<='" + toDate + "' ");
            else if (ddlDateType.SelectedValue == "2")
                sbs.Append("AND adj.DateOfDischarge>='" + startDate + "' AND adj.DateOfDischarge<='" + toDate + "' ");


            if (!string.IsNullOrEmpty(txtBillNo.Text.Trim()))
                sbs.Append("AND pmh.BillNo='" + txtBillNo.Text.Trim() + "'  ");

            if (ddlPatientType.SelectedItem.Value != "Both")
            { sbs.Append("AND pmh.Type='" + ddlPatientType.SelectedItem.Value + "'  "); }

            if (!string.IsNullOrEmpty(txtUHID.Text.Trim()))
                sbs.Append("AND pmh.PatientID='" + txtUHID.Text.Trim() + "' ");

            if (ddlCentre.SelectedValue != "0")
                sbs.Append("AND pmh.CentreID=" + ddlCentre.SelectedValue + " ");

            sbs.Append(" GROUP BY fd.panelInvoiceNo,fd.PatientID,fd.panelid )t");

            DataTable dt = StockReports.GetDataTable(sbs.ToString());

            if (dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Panel Outstanding Report";
                Session["Period"] = "From : " + txtFromDate.Text + " To : " + txtToDate.Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);

         
                }
            
            else
                lblMsg.Text = "No Record Found";

        }




    }

    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPanel();
    }
}
