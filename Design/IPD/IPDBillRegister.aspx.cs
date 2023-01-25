using System;
using System.Data;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPDBillRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
           BindPanels();
            BindDoctors();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnBinSearch);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void BindPanels()
    {

        DataTable dt = LoadCacheQuery.loadAllPanel();

        if (dt.Rows.Count > 0)
        { 
        chkPanel.DataSource = dt;
        chkPanel.DataTextField = "Company_Name";
        chkPanel.DataValueField = "PanelID";
        chkPanel.DataBind();
        }
        else
            lblMsg.Text = "No Company Found";    
    }

    private void BindDoctors()
    {
        DataTable dt = All_LoadData.bindDoctor();
        if (dt.Rows.Count > 0)
        {
            chkDoctor.DataSource = dt;
            chkDoctor.DataTextField = "Name";
            chkDoctor.DataValueField = "DoctorID";
            chkDoctor.DataBind();
        }
        else
            lblMsg.Text = "No Doctor Found";
    }
    
    protected void btnBinSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string PanelIds = string.Empty;
        PanelIds = StockReports.GetSelection(chkPanel);
        string DoctorIDs = string.Empty;
        DoctorIDs = StockReports.GetSelection(chkDoctor);
        GetIPDBillRegister(PanelIds, DoctorIDs,Centre);
    }
   
    private void GetIPDBillRegister(string PanelIds,string DoctorIDs,string Centre)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();

        //Query modified by Anand on 04-12-2011
        if (rbtType.SelectedValue == "1")
        {
            if (rbtSummaryBy.SelectedValue == "1") //BillNo Wise
            {
                sb.Append(" SELECT  PanelGroup,T4.CentreID,T4.CentreName,T4.BillDate,T4.BillNo,T4.PatientID MRNo,IF(T4.TransNo<>'0',T4.TransNo,'') AS IPDNo,");
                sb.Append(" UPPER(PName)PName,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,");
                sb.Append(" DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%y')DateOfDischarge, ");
                sb.Append(" (SELECT CONCAT(Bed_No,'-',UPPER(NAME))Room FROM room_master WHERE RoomID= (SELECT ");
                sb.Append(" RoomID AS Room_ID FROM patient_ipd_profile WHERE PatientIPDProfile_ID =(SELECT  ");
                sb.Append(" MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=T4.TransactionID)))Room,");
                sb.Append(" UPPER(DoctorName)DoctorName, ROUND(CAST(GrossAmt AS DECIMAL(15,2)),2)GrossBillAmt,CAST(T4.ServiceTaxAmt AS DECIMAL(15,2))ServiceTaxAmt,ROUND(CAST(T4.RoundOff AS DECIMAL(15,2)),2)AS RoundOff, ");
                sb.Append(" ROUND(CAST(TotalDiscount AS DECIMAL(15,2)),2)TotalDiscount,");
                sb.Append(" (ROUND(CAST(NetAmount AS DECIMAL(15,2)))+ROUND(CAST(T4.ServiceTaxAmt AS DECIMAL(15,2))))AS NetBillAmount,  ");
                sb.Append(" GetIPDPatient_Copay_Payble(1,T4.TransactionID)PatientCopay,GetIPDPatient_Copay_Payble(2,T4.TransactionID)NonPayableAmt,");
                sb.Append(" CAST(Deposit_AsOn_BillDate AS DECIMAL(15,2))Deposit_AsOn_BillDate, ");
                sb.Append(" CAST(Refund_AsOn_BillDate AS DECIMAL(15,2))Refund_AsOn_BillDate, ");
                sb.Append(" ROUND(CAST(ReceiveAmt_AsOn_BillDate AS DECIMAL(15,2)),2)ReceiveAmt_AsOn_BillDate,");
                sb.Append(" ROUND(CAST(OutStanding_AsOnBillDate AS DECIMAL(15,2)),2) AS OutStanding_AsOnBillDate,");
                sb.Append(" CAST(Deposit_After_BillDate AS DECIMAL(15,2))Deposit_After_BillDate, ");
                sb.Append(" CAST(Refund_After_BillDate AS DECIMAL(15,2))Refund_After_BillDate, ");
                sb.Append(" ROUND(CAST(ReceiveAmt_After_BillDate AS DECIMAL(15,2)),2)ReceiveAmt_After_BillDate,");
                sb.Append(" ROUND(CAST(T4.AdjustmentAmt AS DECIMAL(15,2)),2)AdjustmentAmt,ROUND(CAST(T4.TDS AS DECIMAL(15,2)),2)TDS, ");
                sb.Append(" ROUND(CAST(T4.Deduction_Acceptable AS DECIMAL(15,2)),2)DeductionAcceptable,ROUND(CAST(T4.Deduction_NonAcceptable AS DECIMAL(15,2)),2)DeductionNonAcceptable,ROUND(CAST(T4.WriteOff AS DECIMAL(15,2)),2)WriteOff,ROUND(CAST(CreditAmt AS DECIMAL(15,2)),2)CreditAmt,ROUND(CAST(DebitAmt AS DECIMAL(15,2)),2)DebitAmt, ");
                sb.Append(" CAST(T4.ServiceTaxSurChgAmt AS DECIMAL(15,2))ServiceTaxSurChgAmt,ROUND(CAST(OutStanding_AsOnDate AS DECIMAL(15,2)),2) AS OutStanding_AsOnDate, ");
                sb.Append(" UPPER(T4.DiscountOnBillReason)DiscountOnBillReason,UPPER(T4.ApprovalBy)ApprovalBy,UPPER(Panel)Panel,CAST(T4.PanelApprovedAmt AS DECIMAL(15,2))PanelApprovedAmt,  ");
                sb.Append(" UPPER(T4.PolicyNo)PolicyNo,UPPER(T4.ClaimNo)ClaimNo,UPPER(T4.CardNo)CardNo,UPPER(T4.CardHolderName)CardHolderName,");
                sb.Append(" UPPER(T4.RelationWith_holder)RelationWith_holder,UPPER(T4.FileNo)FileNo,UPPER(T4.PanelAppRemarks)PanelAppRemarks,T4.PanelApprovalDate,UPPER(T4.UserID) BillGeneratedBy,IF(T4.IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus FROM ( ");
                sb.Append("      SELECT T3.`CentreID`,T3.`CentreName`,DATE_FORMAT(BillDate,'%d-%b-%y')BillDate,BillNo,PatientID,TransactionID,PName,ROUND(TotalBilledAmt,2) GrossAmt, ");
                sb.Append("      ROUND((ItemWiseDiscount+DiscountOnBill),2)TotalDiscount,ROUND((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)),2) ");
                sb.Append("      AS NetAmount,ROUND(AdjustmentAmt)AdjustmentAmt,ROUND(ReceiveAmt_AsOn_BillDate)ReceiveAmt_AsOn_BillDate,ROUND(ReceiveAmt_After_BillDate)ReceiveAmt_After_BillDate, ");
                sb.Append("      ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt_AsOn_BillDate))) AS OutStanding_AsOnBillDate, ");
                sb.Append("      ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt_AsOn_BillDate+ReceiveAmt_After_BillDate+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff)-CreditAmt+DebitAmt + ServiceTaxAmt+ServiceTaxSurChgAmt)) AS OutStanding_AsOnDate, ");
                sb.Append("      UserID,DoctorName, Panel,PanelGroup,ROUND(TDS)TDS,ROUND(Deduction_Acceptable)Deduction_Acceptable,ROUND(Deduction_NonAcceptable)Deduction_NonAcceptable,ROUND(WriteOff)WriteOff,ROUND(CreditAmt)CreditAmt,ROUND(DebitAmt)DebitAmt,ROUND(ServiceTaxAmt,2)ServiceTaxAmt,ROUND(CAST(RoundOff AS DECIMAL(15,2)),2)AS RoundOff,ROUND(ServiceTaxSurChgAmt,2)ServiceTaxSurChgAmt,  ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid >0 and Date(Date) <=Date(BillDate) GROUP BY T3.TransactionID)),0)Deposit_AsOn_BillDate, ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid <0 and Date(Date) <=Date(BillDate) GROUP BY T3.TransactionID)),0)Refund_AsOn_BillDate, ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid >0 and Date(Date) >Date(BillDate) GROUP BY T3.TransactionID)),0)Deposit_After_BillDate, ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid <0 and Date(Date) >Date(BillDate) GROUP BY T3.TransactionID)),0)Refund_After_BillDate, ");
                sb.Append("      PolicyNo,CardNo,CardHolderName,RelationWith_holder,FileNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed,T3.TransNo  FROM ( ");
                sb.Append("            SELECT T2.`CentreID`,T2.`CentreName`,BillDate,BillNo,PatientID,TransactionID,PName,UserID,DoctorName,  ");
                sb.Append("            IF(TotalBilledAmt IS NULL,0,TotalBilledAmt)TotalBilledAmt, ");
                sb.Append("            IF(ItemWiseDiscount IS NULL,0,ItemWiseDiscount)ItemWiseDiscount, ");
                sb.Append("            IF(DiscountOnBill IS NULL,0,DiscountOnBill)DiscountOnBill, ");
                sb.Append("            IFNULL(AdjustmentAmt,0)AdjustmentAmt,IFNULL(ReceiveAmt_AsOn_BillDate,0)ReceiveAmt_AsOn_BillDate,");
                sb.Append("            IFNULL(ReceiveAmt_After_BillDate,0)ReceiveAmt_After_BillDate,IFNULL(TDS,0)TDS,Deduction_Acceptable,");
                sb.Append("            Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,RoundOff,ServiceTaxSurChgAmt,Panel,PanelGroup, ");
                sb.Append("            PolicyNo,CardNo,CardHolderName,RelationWith_holder,FileNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed,T2.TransNo FROM ( ");
                sb.Append("               SELECT cm.`CentreID`,cm.`CentreName`,T1.BillNo,T1.BillDate,T1.PatientID,T1.TransactionID,T1.TotalBilledAmt,T1.DiscountOnBill,T1.TDS,T1.Deduction_Acceptable,T1.Deduction_NonAcceptable,T1.WriteOff,T1.CreditAmt,T1.DebitAmt,T1.AdjustmentAmt,  ");
                sb.Append("               T1.ReceiveAmt_AsOn_BillDate,T1.ReceiveAmt_After_BillDate,T1.ItemWiseDiscount,T1.PName,Em.Name UserID,T1.ServiceTaxAmt,T1.RoundOff,T1.ServiceTaxSurChgAmt,dm.Name DoctorName,pmh.PolicyNo, ");
                sb.Append("               pmh.CardNo,pmh.CardHolderName,pmh.RelationWith_holder,pmh.FileNo,T1.ClaimNo,T1.PanelApprovedAmt,T1.PanelAppRemarks,DATE_FORMAT(T1.PanelApprovalDate,'%d-%b-%y')PanelApprovalDate,T1.DiscountOnBillReason,T1.ApprovalBy,  ");
                sb.Append("               PM.Company_Name Panel,T1.IsBilledClosed,pm.PanelGroup,T1.TransNo FROM ( ");
                sb.Append("                    SELECT BillNo,BillDate,PatientID,Temp1.TransactionID, ");
                sb.Append("                    (SELECT SUM(ltd.GrossAmount) FROM f_ledgertnxdetail ltd  ");
                sb.Append("                    INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID  ");
                sb.Append("                    WHERE ltd.TransactionID = Temp1.TransactionID AND ltd.IsVerified = 1 AND  ");
                sb.Append("                    ltd.IsPackage = 0     ");
                //Hide HS Items which are prescribed after 2011-01-02 and serviceItemid is blank 
                //sb.Append("                   AND IF(DATE(Temp1.BillDate)<= '2012-01-02',1,IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS'))  ");
                sb.Append("                   GROUP BY TransactionID)TotalBilledAmt,DiscountOnBill,AdjustmentAmt, ");
                sb.Append("                   (SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID ");
                sb.Append("                   AND IsCancel = 0 and Date(Date)<=Date(Temp1.BillDate) GROUP BY TransactionID)ReceiveAmt_AsOn_BillDate, ");
                sb.Append("                   (SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID ");
                sb.Append("                   AND IsCancel = 0 and Date(Date)>Date(Temp1.BillDate) GROUP BY TransactionID)ReceiveAmt_After_BillDate, ");
                sb.Append("                   (SELECT SUM(TotalDiscAmt) FROM  ");
                sb.Append("                   f_ledgertnxdetail WHERE TransactionID = Temp1.TransactionID  ");
                sb.Append("                   AND IsVerified = 1 AND IsPackage = 0 ");
                sb.Append("                   GROUP BY TransactionID)ItemWiseDiscount, UserID,TDS,Deduction_Acceptable,Deduction_NonAcceptable,");
                sb.Append("                   WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,RoundOff,ServiceTaxSurChgAmt,PName,ClaimNo,CardHolderName,RelationWith_holder,FileNo,PanelAppRemarks, ");
                sb.Append("                   PanelApprovedAmt,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed,Temp1.TransNo  FROM  ( ");
                sb.Append("                       SELECT  LT.BillNo,LT.BillDate,Adj.PatientID,Adj.TransactionID, ");
                sb.Append("                       Adj.TotalBilledAmt,Adj.DiscountOnBill,Adj.AdjustmentAmt,Adj.UserID,IFNULL(adj.TDS,0)TDS,");
                sb.Append("                       IFNULL(adj.Deduction_Acceptable,0)Deduction_Acceptable, ");
                sb.Append("                       IFNULL(adj.Deduction_NonAcceptable,0)Deduction_NonAcceptable,IFNULL(adj.WriteOff,0)WriteOff, ");
                sb.Append("                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ");
                sb.Append("                       AND CRDR='CR01' AND cancel=0  GROUP BY TransactionID),0)CreditAmt, ");
                sb.Append("                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ");
                sb.Append("                       AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID),0)DebitAmt,adj.CardHolderName,adj.RelationWith_holder,adj.FileNo, ");
                sb.Append("                       Adj.ServiceTaxAmt,adj.RoundOff,Adj.ServiceTaxSurChgAmt,CONCAT(PT.Title,' ',PT.PName)PName,adj.ClaimNo,adj.PanelAppRemarks,adj.PanelApprovedAmt, ");
                sb.Append("                       adj.PanelApprovalDate,adj.DiscountOnBillReason,adj.ApprovalBy,adj.IsBilledClosed,adj.TransNo FROM ( ");
                sb.Append("                            SELECT BillNo,TransactionID,BillDate FROM patient_medical_history   ");//f_ipdadjustment

                if (ChkDate.Checked)
                    sb.Append("                     WHERE Date(BillDate) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and Date(BillDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

                sb.Append("                            GROUP BY BillNo ");
                sb.Append("                       )  lt  INNER JOIN patient_medical_history adj ON lt.TransactionID=adj.TransactionID  ");//INNER JOIN f_ipdadjustment adj ON adj.TransactionID = lt.TransactionID
                sb.Append("                       INNER JOIN patient_master pt ON pt.PatientID = adj.PatientID ");
                //sb.Append("                       INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                sb.Append("                       WHERE (Adj.BillNo IS NOT NULL) AND Adj.BillNo <> ''  ");
                sb.Append("                   )Temp1 ");
                sb.Append("                   UNION ALL ");
                sb.Append("                   SELECT BC.BillNo,BC.BillDate,BC.PatientID,BC.TransactionID,0.0 TotalBilledAmt, ");
                sb.Append("                   0.0 DiscountOnBill, 0.0 AdjustmentAmt,0.0 ReceiveAmt_AsOn_BillDate,0.0 ReceiveAmt_After_BillDate,0.0 ItemWiseDiscount, ");
                sb.Append("                   BC.BillGenerateUserID,0.0 TDS,0.0 Deduction_Acceptable,0.0 Deduction_NonAcceptable,0.0 WriteOff,0.0 CreditAmt,0.0 DebitAmt,");
                sb.Append("                   0.0 ServiceTaxAmt,0.0 RoundOff,0.0 ServiceTaxSurChgAmt,CONCAT(PT.Pname,'---CANCEL')PNAME,");
                sb.Append("                   '' ClaimNo,'' CardHolderName,'' RelationWith_holder,'' FileNo,''PanelAppRemarks,  ");
                sb.Append("                   ''PanelApprovedAmt,''PanelApprovalDate,''DiscountOnBillReason,''ApprovalBy,'0' IsBilledClosed,pmh.TransNo  ");
                sb.Append("                   FROM f_billcancellation BC INNER JOIN patient_master PT ON BC.PatientID = PT.PatientID INNER JOIN patient_medical_history pmh ON BC.TransactionID=pmh.TransactionID  ");
                sb.Append("               ) T1  INNER JOIN patient_medical_history pmh ON T1.TransactionID = pmh.TransactionID and pmh.Type='IPD' INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` ");
                sb.Append("               INNER JOIN Doctor_Master dm ON dm.DoctorID = pmh.DoctorID ");
                sb.Append("               INNER JOIN employee_master EM ON EM.EmployeeID = T1.UserID ");
                sb.Append("               LEFT OUTER JOIN f_panel_master PM ON PM.PanelID = pmh.PanelID ");
                //WHERE DATE(BillDate) >= '2012-03-15' AND DATE(BillDate) <= '2012-03-19'
                if (ChkDate.Checked)
                    sb.Append("         where Date(pmh.BillDate) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and Date(pmh.BillDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

                if (PanelIds != string.Empty)
                    if (ChkDate.Checked)
                        sb.Append("     and pmh.PanelID  in (" + PanelIds + ")");
                    else
                        sb.Append("     where pmh.PanelID  in (" + PanelIds + ")");

                if (DoctorIDs != string.Empty)
                    sb.Append("         and pmh.DoctorID  in (" + DoctorIDs + ")");

                sb.Append("     and pmh.`CentreID` in ("+Centre+")   )T2");
                sb.Append("    )T3");
                sb.Append(")T4 left join patient_medical_history ich on ich.TransactionID = T4.TransactionID ");//ipd_case_History



                if (rdoReportType.Text == "2")
                    sb.Append(" Where OutStanding_AsOnBillDate > 1");

                if (rdoReportType.Text == "3")
                    sb.Append(" Where OutStanding_AsOnBillDate < -1");

                sb.Append(" order by Billno");
            }
            else if (rbtSummaryBy.SelectedValue == "2")  //BillDate Wise
            {
                sb.Append(" SELECT PanelGroup,CentreName,BillDate,ROUND(CAST(sum(GrossAmt) AS DECIMAL(15,2)),2)GrossBillAmt, ");
                sb.Append(" ROUND(CAST(sum(TotalDiscount) AS DECIMAL(15,2)),2)TotalDiscount,");
                sb.Append(" ROUND(CAST(sum(NetAmount) AS DECIMAL(15,2)),2)AS NetBillAmount,  ");
                sb.Append(" ROUND(CAST(sum(PatientCopay) AS DECIMAL(15,2)),2)AS PatientCopay,  ");
                sb.Append(" ROUND(CAST(sum(NonPayableAmt) AS DECIMAL(15,2)),2)AS NonPayableAmt,  ");
                sb.Append(" CAST(sum(Deposit_AsOn_BillDate) AS DECIMAL(15,2))Deposit_AsOn_BillDate, ");
                sb.Append(" CAST(sum(Refund_AsOn_BillDate) AS DECIMAL(15,2))Refund_AsOn_BillDate, ");
                sb.Append(" ROUND(CAST(sum(ReceiveAmt_AsOn_BillDate) AS DECIMAL(15,2)),2)ReceiveAmt_AsOn_BillDate,");
                sb.Append(" ROUND(CAST(sum(OutStanding_AsOnBillDate) AS DECIMAL(15,2)),2) AS OutStanding_AsOnBillDate,");
                sb.Append(" CAST(sum(Deposit_After_BillDate) AS DECIMAL(15,2))Deposit_After_BillDate, ");
                sb.Append(" CAST(sum(Refund_After_BillDate) AS DECIMAL(15,2))Refund_After_BillDate, ");
                sb.Append(" ROUND(CAST(sum(ReceiveAmt_After_BillDate) AS DECIMAL(15,2)),2)ReceiveAmt_After_BillDate,");
                sb.Append(" ROUND(CAST(sum(AdjustmentAmt) AS DECIMAL(15,2)),2)AdjustmentAmt,");
                sb.Append(" ROUND(CAST(sum(TDS) AS DECIMAL(15,2)),2)TDS, ");
                sb.Append(" ROUND(CAST(sum(Deduction_Acceptable) AS DECIMAL(15,2)),2)DeductionAcceptable,");
                sb.Append(" ROUND(CAST(sum(Deduction_NonAcceptable) AS DECIMAL(15,2)),2)DeductionNonAcceptable,");
                sb.Append(" ROUND(CAST(sum(WriteOff) AS DECIMAL(15,2)),2)WriteOff,");
                sb.Append(" ROUND(CAST(sum(CreditAmt) AS DECIMAL(15,2)),2)CreditAmt,");
                sb.Append(" ROUND(CAST(sum(DebitAmt) AS DECIMAL(15,2)),2)DebitAmt, ");
                sb.Append(" CAST(sum(ServiceTaxAmt) AS DECIMAL(15,2))ServiceTaxAmt,");
                sb.Append(" CAST(sum(ServiceTaxSurChgAmt) AS DECIMAL(15,2))ServiceTaxSurChgAmt,");
                sb.Append(" ROUND(CAST(sum(OutStanding_AsOnDate) AS DECIMAL(15,2)),2) AS OutStanding_AsOnDate, ");
                sb.Append(" CAST(sum(PanelApprovedAmt) AS DECIMAL(15,2))PanelApprovedAmt FROM (  ");
                sb.Append("      SELECT T3.`CentreID`,T3.`CentreName`,DATE_FORMAT(BillDate,'%d-%b-%y')BillDate,BillNo,PatientID,TransactionID,PName,ROUND(TotalBilledAmt) GrossAmt, ");
                sb.Append("      ROUND((ItemWiseDiscount+DiscountOnBill))TotalDiscount,ROUND((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill))) AS NetAmount,");
                sb.Append("      GetIPDPatient_Copay_Payble(1,TransactionID)PatientCopay,GetIPDPatient_Copay_Payble(2,TransactionID)NonPayableAmt,");
                sb.Append("      ROUND(AdjustmentAmt)AdjustmentAmt,ROUND(ReceiveAmt_AsOn_BillDate)ReceiveAmt_AsOn_BillDate,ROUND(ReceiveAmt_After_BillDate)ReceiveAmt_After_BillDate, ");
                sb.Append("      ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt_AsOn_BillDate))) AS OutStanding_AsOnBillDate, ");
                sb.Append("      ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt_AsOn_BillDate+ReceiveAmt_After_BillDate+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff)-CreditAmt+DebitAmt + ServiceTaxAmt+ServiceTaxSurChgAmt)) AS OutStanding_AsOnDate, ");
                sb.Append("      UserID,DoctorName, Panel,ROUND(TDS)TDS,ROUND(Deduction_Acceptable)Deduction_Acceptable,ROUND(Deduction_NonAcceptable)Deduction_NonAcceptable,ROUND(WriteOff)WriteOff,ROUND(CreditAmt)CreditAmt,ROUND(DebitAmt)DebitAmt,ROUND(ServiceTaxAmt,2)ServiceTaxAmt,ROUND(ServiceTaxSurChgAmt,2)ServiceTaxSurChgAmt,  ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid >0 and Date(Date) <=Date(BillDate) GROUP BY T3.TransactionID)),0)Deposit_AsOn_BillDate, ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid <0 and Date(Date) <=Date(BillDate) GROUP BY T3.TransactionID)),0)Refund_AsOn_BillDate, ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid >0 and Date(Date) >Date(BillDate) GROUP BY T3.TransactionID)),0)Deposit_After_BillDate, ");
                sb.Append("      if(UPPER(PName)not like '%Cancel%',Round((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =T3.TransactionID AND IsCancel = 0 AND AmountPaid <0 and Date(Date) >Date(BillDate) GROUP BY T3.TransactionID)),0)Refund_After_BillDate, ");
                sb.Append("      PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed  FROM ( ");
                sb.Append("            SELECT T2.`CentreID`,T2.`CentreName`,BillDate,BillNo,PatientID,TransactionID,PName,UserID,DoctorName,  ");
                sb.Append("            IF(TotalBilledAmt IS NULL,0,TotalBilledAmt)TotalBilledAmt, ");
                sb.Append("            IF(ItemWiseDiscount IS NULL,0,ItemWiseDiscount)ItemWiseDiscount, ");
                sb.Append("            IF(DiscountOnBill IS NULL,0,DiscountOnBill)DiscountOnBill, ");
                sb.Append("            IFNULL(AdjustmentAmt,0)AdjustmentAmt,IFNULL(ReceiveAmt_AsOn_BillDate,0)ReceiveAmt_AsOn_BillDate,");
                sb.Append("            IFNULL(ReceiveAmt_After_BillDate,0)ReceiveAmt_After_BillDate,IFNULL(TDS,0)TDS,Deduction_Acceptable,");
                sb.Append("            Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,ServiceTaxSurChgAmt,Panel,PanelGroup, ");
                sb.Append("            PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed FROM ( ");
                sb.Append("               SELECT cm.`CentreID`,cm.`CentreName`, T1.BillNo,T1.BillDate,T1.PatientID,T1.TransactionID,T1.TotalBilledAmt,T1.DiscountOnBill,T1.TDS,T1.Deduction_Acceptable,T1.Deduction_NonAcceptable,T1.WriteOff,T1.CreditAmt,T1.DebitAmt,T1.AdjustmentAmt,  ");
                sb.Append("               T1.ReceiveAmt_AsOn_BillDate,T1.ReceiveAmt_After_BillDate,T1.ItemWiseDiscount,T1.PName,Em.Name UserID,ServiceTaxAmt,ServiceTaxSurChgAmt,dm.Name DoctorName,pmh.PolicyNo, ");
                sb.Append("               pmh.CardNo,T1.ClaimNo,T1.PanelApprovedAmt,T1.PanelAppRemarks,DATE_FORMAT(T1.PanelApprovalDate,'%d-%b-%y')PanelApprovalDate,T1.DiscountOnBillReason,T1.ApprovalBy,  ");
                sb.Append("               PM.Company_Name Panel,IsBilledClosed,pm.PanelGroup FROM ( ");
                sb.Append("                    SELECT BillNo,BillDate,PatientID,Temp1.TransactionID, ");
                sb.Append("                    (SELECT SUM(ltd.GrossAmount) FROM f_ledgertnxdetail ltd  ");
                sb.Append("                    INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID  ");
                sb.Append("                    WHERE ltd.TransactionID = Temp1.TransactionID AND ltd.IsVerified = 1 AND  ");
                sb.Append("                    ltd.IsPackage = 0     ");
                //Hide HS Items which are prescribed after 2011-01-02 and serviceItemid is blank 
                //sb.Append("                   AND IF(DATE(Temp1.BillDate)<= '2012-01-02',1,IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS'))  ");
                sb.Append("                   GROUP BY TransactionID)TotalBilledAmt,DiscountOnBill,AdjustmentAmt, ");
                sb.Append("                   (SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID ");
                sb.Append("                   AND IsCancel = 0 and Date(Date)<=Date(Temp1.BillDate) GROUP BY TransactionID)ReceiveAmt_AsOn_BillDate, ");
                sb.Append("                   (SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID ");
                sb.Append("                   AND IsCancel = 0 and Date(Date)>Date(Temp1.BillDate) GROUP BY TransactionID)ReceiveAmt_After_BillDate, ");
                sb.Append("                   (SELECT SUM(TotalDiscAmt) FROM  ");
                sb.Append("                   f_ledgertnxdetail WHERE TransactionID = Temp1.TransactionID  ");
                sb.Append("                   AND IsVerified = 1 AND IsPackage = 0 ");
                sb.Append("                   GROUP BY TransactionID)ItemWiseDiscount, UserID,TDS,Deduction_Acceptable,Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,ServiceTaxSurChgAmt,PName,ClaimNo,PanelAppRemarks, ");
                sb.Append("                   PanelApprovedAmt,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed  FROM  ( ");
                sb.Append("                       SELECT LT.BillNo,LT.BillDate,Adj.PatientID,Adj.TransactionID, ");
                sb.Append("                       Adj.TotalBilledAmt,Adj.DiscountOnBill,Adj.AdjustmentAmt,Adj.UserID,IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable, ");
                sb.Append("                       IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,IFNULL(pmh.WriteOff,0)WriteOff, ");
                sb.Append("                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ");
                sb.Append("                       AND CRDR='CR01' AND cancel=0  GROUP BY TransactionID),0)CreditAmt, ");
                sb.Append("                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ");
                sb.Append("                       AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID),0)DebitAmt, ");
                sb.Append("                       Adj.ServiceTaxAmt,Adj.ServiceTaxSurChgAmt,CONCAT(PT.Title,' ',PT.PName)PName,adj.ClaimNo,adj.PanelAppRemarks,adj.PanelApprovedAmt, ");
                sb.Append("                       adj.PanelApprovalDate,adj.DiscountOnBillReason,adj.ApprovalBy,adj.IsBilledClosed FROM ( ");
                sb.Append("                            SELECT BillNo,TransactionID,BillDate FROM f_ipdadjustment  ");

                if (ChkDate.Checked)
                    sb.Append("                     WHERE  Date(BillDate) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and Date(BillDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

                sb.Append("                            GROUP BY BillNo ");
                sb.Append("                       )  lt INNER JOIN f_ipdadjustment adj ON adj.TransactionID = lt.TransactionID ");
                sb.Append("                       INNER JOIN patient_master pt ON pt.PatientID = adj.PatientID ");
                sb.Append("                       INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
                sb.Append("                       WHERE (Adj.BillNo IS NOT NULL) AND Adj.BillNo <> ''  ");
                sb.Append("                   )Temp1 ");
                sb.Append("                   UNION ALL ");
                sb.Append("                   SELECT BC.BillNo,BC.BillDate,BC.PatientID,BC.TransactionID,0.0 TotalBilledAmt, ");
                sb.Append("                   0.0 DiscountOnBill, 0.0 AdjustmentAmt,0.0 ReceiveAmt_AsOn_BillDate,0.0 ReceiveAmt_After_BillDate,0.0 ItemWiseDiscount, ");
                sb.Append("                   BC.BillGenerateUserID,0.0 TDS,0.0 Deduction_Acceptable,0.0 Deduction_NonAcceptable,0.0 WriteOff,0.0 CreditAmt,0.0 DebitAmt,0.0 ServiceTaxAmt,0.0 ServiceTaxSurChgAmt,CONCAT(PT.Pname,'---CANCEL')PNAME,'' ClaimNo,''PanelAppRemarks,  ");
                sb.Append("                   ''PanelApprovedAmt,''PanelApprovalDate,''DiscountOnBillReason,''ApprovalBy,'0' IsBilledClosed  ");
                sb.Append("                   FROM f_billcancellation BC INNER JOIN patient_master PT ON BC.PatientID = PT.PatientID ");
                sb.Append("               ) T1  INNER JOIN patient_medical_history pmh ON T1.TransactionID = pmh.TransactionID  INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID`  ");
                sb.Append("               INNER JOIN Doctor_Master dm ON dm.DoctorID = pmh.DoctorID ");
                sb.Append("               INNER JOIN employee_master EM ON EM.Employee_ID = T1.UserID ");
                sb.Append("               LEFT OUTER JOIN f_panel_master PM ON PM.PanelID = pmh.PanelID ");

                //WHERE DATE(BillDate) >= '2012-03-15' AND DATE(BillDate) <= '2012-03-19'



                if (ChkDate.Checked)
                    sb.Append("         where Date(BillDate) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "' and Date(BillDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + "'");

                if (PanelIds != string.Empty)
                    if (ChkDate.Checked)
                        sb.Append("     and pmh.PanelID  in (" + PanelIds + ")");
                    else
                        sb.Append("     where pmh.PanelID  in (" + PanelIds + ")");

                if (DoctorIDs != string.Empty )
                    sb.Append("         and pmh.DoctorID  in (" + DoctorIDs + ")");

                sb.Append("       and pmh.`CentreID` in (" + Centre + ")  )T2");
                sb.Append("    )T3");
                sb.Append(")T4 ");


                if (rdoReportType.Text == "2")
                    sb.Append(" Where OutStanding_AsOnBillDate > 1");

                if (rdoReportType.Text == "3")
                    sb.Append(" Where OutStanding_AsOnBillDate < -1");

                sb.Append(" group by BillDate order by BillDate ");
            }


            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                DataRow drNew = dt.NewRow();
                drNew["GrossBillAmt"] = dt.Compute("sum(GrossBillAmt)", "");

                drNew["TotalDiscount"] = dt.Compute("sum(TotalDiscount)", "");

                drNew["NetBillAmount"] = dt.Compute("sum(NetBillAmount)", "");

                drNew["Deposit_AsOn_BillDate"] = dt.Compute("sum(Deposit_AsOn_BillDate)", "");

                drNew["Deposit_After_BillDate"] = dt.Compute("sum(Deposit_After_BillDate)", "");

                drNew["Refund_AsOn_BillDate"] = dt.Compute("sum(Refund_AsOn_BillDate)", "");

                drNew["Refund_After_BillDate"] = dt.Compute("sum(Refund_After_BillDate)", "");

                drNew["OutStanding_AsOnDate"] = dt.Compute("sum(OutStanding_AsOnDate)", "");

                drNew["ReceiveAmt_AsOn_BillDate"] = dt.Compute("sum(ReceiveAmt_AsOn_BillDate)", "");

                drNew["ReceiveAmt_After_BillDate"] = dt.Compute("sum(ReceiveAmt_After_BillDate)", "");

		        drNew["OutStanding_AsOnBillDate"] = dt.Compute("sum(OutStanding_AsOnBillDate)", "");

                drNew["AdjustmentAmt"] = dt.Compute("sum(AdjustmentAmt)", "");

                drNew["TDS"] = dt.Compute("sum(TDS)", "");
                
                drNew["DeductionAcceptable"] = dt.Compute("sum(DeductionAcceptable)", "");
                
                drNew["DeductionNonAcceptable"] = dt.Compute("sum(DeductionNonAcceptable)", "");
                
                drNew["WriteOff"] = dt.Compute("sum(WriteOff)", "");
                
                drNew["CreditAmt"] = dt.Compute("sum(CreditAmt)", "");
                
                drNew["DebitAmt"] = dt.Compute("sum(DebitAmt)", "");
                //Deduction_Acceptable+Deduction_NonAcceptable+WriteOff)-CreditAmt+DebitAmt
                drNew["ServiceTaxAmt"] = dt.Compute("sum(ServiceTaxAmt)", "");

                drNew["ServiceTaxSurChgAmt"] = dt.Compute("sum(ServiceTaxSurChgAmt)", "");

                drNew["PanelApprovedAmt"] = dt.Compute("sum(PanelApprovedAmt)", "");

                dt.Rows.InsertAt(drNew, dt.Rows.Count + 1);
                 dt.Columns.Remove("CentreID");
                    foreach (ListItem li in chkfieldlist.Items)
                    {
                        if (li.Selected == true)
                        {

                        }
                        else
                        {
                            dt.Columns.Remove(li.Text);
                        }
                    }
                
                if (rbtSummaryBy.SelectedValue == "1")
                {
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "BillRegister (" + rbtSummaryBy.SelectedItem.Text + ")";
                    Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                }
                else if (rbtSummaryBy.SelectedValue == "2")
                {
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "BillRegister (" + rbtSummaryBy.SelectedItem.Text + ")";
                    Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                }
            }
            else
                lblMsg.Text = "No Record Found";
        }
        else
        {
            sb.Append("SELECT PanelGroup,BillNo,BillDate,upper(PName)PName,Replace(PatientID,'LSHHI','')MRNo,IF(t.TransNo<>'0',t.TransNo,'') AS IPDNo,CAST(TotalBilledAmt AS DECIMAL(15,2))TotalBilledAmt,");
            sb.Append(" GetIPDPatient_Copay_Payble(1,TransactionID)PatientCopay,GetIPDPatient_Copay_Payble(2,TransactionID)NonPayableAmt,");
            sb.Append(" upper(SurgeryName)SurgeryName,upper(SurgeryDepartment)SurgeryDepartment,CAST(DiscAmt AS DECIMAL(15,2))DiscAmt,CAST(DiscountOnBill AS DECIMAL(15,2))DiscountOnBill,");
            sb.Append(" CAST(Amount AS DECIMAL(15,2))Amount,upper(SubCategory)SubCategory,IF(DisplayName='',UPPER(SubCategory),UPPER(DisplayName))DisplayName,ConfigID AS ConfigID,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge,upper(Doctor)Doctor,upper(Panel)Panel,upper(Room)Room,StayPeriod,CAST(GrossAmtItem AS DECIMAL(15,2))GrossAmtItem,upper(if(IsBilledClosed=1,'Bill Finalised','Bill Not Finalised'))BillingStatus FROM (");
            sb.Append("    SELECT LT.BillNo,LT.BillDate,pmh.PatientID,pmh.TransactionID,");
            
            //sb.Append("    adj.TotalBilledAmt,");
            sb.Append("    Round((Select sum(ltd.GrossAmount) From f_ledgertnxdetail ltd ");
            sb.Append("    inner join f_Itemmaster im on im.ItemID = Ltd.ItemID ");
            sb.Append("	   where ltd.TransactionID = pmh.TransactionID and ltd.IsVerified = 1 And ltd.IsPackage = 0 ");

            //Hide HS Items which are prescribed after 2011-01-02 and serviceItemid is blank            
            //sb.Append("	   AND IF(DATE(LT.BillDate)<= '2012-01-02',1,IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS')) ");
            sb.Append("	   Group by TransactionID))TotalBilledAmt,");


            sb.Append("	   ( select GROUP_CONCAT(distinct IFNULL(ltd.SurgeryName,' ')) from f_ledgertnxdetail ltd ");
            sb.Append("	   where IFNULL(ltd.SurgeryName,'')!='' and ltd.TransactionID = pmh.TransactionID group by TransactionID ) SurgeryName, ");

            sb.Append("	   ( select GROUP_CONCAT(distinct IFNULL(sm.Department,' ')) from f_ledgertnxdetail ltd ");
            sb.Append("	   inner join f_surgery_master sm on sm.Surgery_id=ltd.Surgeryid ");
            sb.Append("	   where IFNULL(ltd.SurgeryName,'')!='' and ltd.TransactionID = pmh.TransactionID group by TransactionID ) SurgeryDepartment, ");


            sb.Append("");
            sb.Append("    IFNULL(pmh.DiscountOnBill,0)DiscountOnBill,CONCAT(PT.Title,' ',PT.PName)PName,ROUND(SUM(lt.amount),2)Amount,ROUND(SUM(DiscAmt),2)DiscAmt,");
            sb.Append("    lt.SubCategoryID,IF(ConfigID in (2,25,22,11),DisplayName,sc.Name)SubCategory,sc.DisplayName,cf.ConfigID,sc.DisplayPriority, ");
            sb.Append("    DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')DateOfAdmit,DATE_FORMAT(pmh.TimeOfAdmit,'%T')TimeOfAdmit,");
            sb.Append("    DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%y')DateOfDischarge,DATE_FORMAT(pmh.TimeOfDischarge,'%T')TimeOfDischarge, ");
            sb.Append("    dm.Name Doctor,pnl.Company_Name Panel,pnl.PanelGroup, ");
            sb.Append("    (SELECT CONCAT(Bed_No,'-',NAME)Room FROM room_master WHERE RoomID= (SELECT RoomID AS Room_ID FROM patient_ipd_profile WHERE ");
            sb.Append("    PatientIPDProfile_ID =(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=lt.TransactionID)))Room,");
            sb.Append("    (DATEDIFF(pmh.DateOfDischarge,pmh.DateOfAdmit)+1)StayPeriod,round(sum(GrossAmtItem),2)GrossAmtItem,pmh.IsBilledClosed,pmh.TransNo FROM (");
            sb.Append("        SELECT lt.BillNo,lt.TransactionID,Date_Format(lt.Billdate,'%d-%b-%y')Billdate,im.SubCategoryID,ltd.Amount,");
            sb.Append("        (ltd.TotalDiscAmt)DiscAmt,(ltd.GrossAmount) GrossAmtItem ");
		    
            
            //Table name changed to pick billdate from adjustment table
            //sb.Append("        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
            sb.Append("        FROM patient_medical_history lt INNER JOIN f_ledgertnxdetail ltd ON lt.TransactionID = ltd.TransactionID ");//f_ipdadjustment
            
            sb.Append("        INNER JOIN f_Itemmaster im ON im.ItemID = ltd.ItemID ");
            sb.Append("        WHERE lt.BillDate >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append("        AND lt.BillDate <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' AND ltd.IsVerified=1 AND ltd.IsPackage=0 ");

            if (PanelIds != string.Empty)
                if (ChkDate.Checked)
                    sb.Append("     and lt.PanelID  in (" + PanelIds + ")");
                else
                    sb.Append("     where lt.PanelID  in (" + PanelIds + ")");

            if (DoctorIDs != string.Empty && rdbReportType.SelectedItem.Value == "3")
                sb.Append("         and lt.DoctorID  in (" + DoctorIDs + ")");

            //Hide HS Items which are prescribed after 2011-01-02 and serviceItemid is blank  
            //sb.Append("        AND IF(DATE(lt.BillDate)<= '2012-01-02',1,IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS'))");

            sb.Append("    )  lt  ");//INNER JOIN f_ipdadjustment adj ON adj.TransactionID = lt.TransactionID
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID  ");
	        sb.Append("    INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=lt.SubCategoryID ");
	        sb.Append("    INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
           // sb.Append("    INNER JOIN ipd_case_history ich ON ich.TransactionID = adj.TransactionID ");
           // sb.Append("    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID ");
            sb.Append("    INNER JOIN doctor_master dm ON dm.DoctorID =pmh.DoctorID  ");
            sb.Append("    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
            sb.Append("     ");
            sb.Append("    INNER JOIN patient_master pt ON pt.PatientID = pmh.PatientID ");
            sb.Append("    WHERE (pmh.BillNo IS NOT NULL) AND pmh.BillNo <> '' GROUP BY pmh.TransactionID,IF(ConfigID in (2,25,22,11),DisplayName,sc.Name) ");
            sb.Append(")t ORDER BY BillNo,DisplayPriority+0");

            dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                DataTable dtMerge = new DataTable();
                dtMerge.Columns.Add("PanelGroup");
                dtMerge.Columns.Add("BillNo");
                dtMerge.Columns.Add("BillDate");
                dtMerge.Columns.Add("PName");
                dtMerge.Columns.Add("MRNo");
                dtMerge.Columns.Add("IPDNo");
                dtMerge.Columns.Add("TotalBilledAmt");
                dtMerge.Columns.Add("ItemWiseDiscount");
                dtMerge.Columns.Add("DiscountOnBill");
                dtMerge.Columns.Add("NetBillAmount");
                dtMerge.Columns.Add("PatientCopay");
                dtMerge.Columns.Add("NonPayableAmt");
                dtMerge.Columns.Add("DateOfAdmit");
                dtMerge.Columns.Add("DateOfDischarge");
                dtMerge.Columns.Add("TimeOfAdmit");
                dtMerge.Columns.Add("TimeOfDischarge");
                dtMerge.Columns.Add("Doctor");
                dtMerge.Columns.Add("Panel");
               // dtMerge.Columns.Add("Diagnosis");
                dtMerge.Columns.Add("Room");
                dtMerge.Columns.Add("StayPeriod");
                dtMerge.Columns.Add("SurgeryName");
                dtMerge.Columns.Add("SurgeryDepartment");
                dtMerge.Columns.Add("BillingStatus");

               
                //Creating each Subcategory Value as a Column in dtMerge
                foreach (DataRow drSub in dt.Rows)
                {
                    if (rbtSubCateoryType.SelectedValue == "1")
                    {
                        if (dtMerge.Columns.Contains(drSub["SubCategory"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")) == false)
                        {
                            dtMerge.Columns.Add(drSub["SubCategory"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", ""));
                            dtMerge.Columns[drSub["SubCategory"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")].DataType = System.Type.GetType("System.Decimal");
                        }
                    }
                    else
                    {
                        if (dtMerge.Columns.Contains(drSub["DisplayName"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")) == false)
                        {
                            dtMerge.Columns.Add(drSub["DisplayName"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", ""));
                            dtMerge.Columns[drSub["DisplayName"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")].DataType = System.Type.GetType("System.Decimal");
                        }
                    }
                }

                //dtMerge.WriteXmlSchema("C:/ANANDXML.xml");

                foreach (DataRow dr in dt.Rows)
                {
                    DataRow[] RowCreated = dtMerge.Select("BillNo='" + dr["BillNo"].ToString() + "'");

                    if (RowCreated.Length == 0)
                    {
                        DataRow[] RowExist = dt.Select("BillNo='" + dr["BillNo"].ToString() + "'");

                        if (RowExist.Length > 0)
                        {
                            DataRow row = dtMerge.NewRow();

                            string DiscOnBill = "";
                            string itemDisocount = "";
                            foreach (DataRow NewRow in RowExist)
                            {
                                row["BillNo"] = NewRow["BillNo"].ToString();
                                row["BillDate"] = NewRow["BillDate"].ToString();
                                row["PName"] = NewRow["PName"].ToString().ToUpper();
                                row["MRNo"] = NewRow["MRNo"].ToString();
                                row["IPDNo"] = NewRow["IPDNo"].ToString();
                                row["TotalBilledAmt"] = NewRow["TotalBilledAmt"].ToString();
                                row["PatientCopay"] = NewRow["PatientCopay"].ToString();
                                row["NonPayableAmt"] = NewRow["NonPayableAmt"].ToString();

                                //row["DiscountOnBill"] = Util.GetString(Util.GetDecimal(row["DiscountOnBill"]) + Util.GetDecimal(NewRow["DiscAmt"]));
                                row["ItemWiseDiscount"] = Util.GetString(Util.GetDecimal(row["ItemWiseDiscount"]) + Util.GetDecimal(NewRow["DiscAmt"]));
                                row["DiscountOnBill"] = Util.GetString(Util.GetDecimal(row["DiscountOnBill"]));

                                row["DateOfAdmit"] = NewRow["DateOfAdmit"].ToString();
                                row["DateOfDischarge"] = NewRow["DateOfDischarge"].ToString();
                                row["TimeOfAdmit"] = NewRow["TimeOfAdmit"].ToString();
                                row["TimeOfDischarge"] = NewRow["TimeOfDischarge"].ToString();
                                row["Doctor"] = NewRow["Doctor"].ToString().ToUpper();
                                row["Panel"] = NewRow["Panel"].ToString().ToUpper();
                                row["PanelGroup"] = NewRow["PanelGroup"].ToString().ToUpper();
                                //row["Diagnosis"] = NewRow["Diagnosis"].ToString().ToUpper();
                                row["Room"] = NewRow["Room"].ToString().ToUpper();
                                row["StayPeriod"] = NewRow["StayPeriod"].ToString();
                                row["SurgeryName"] = NewRow["SurgeryName"].ToString().ToUpper();
                                row["SurgeryDepartment"] = NewRow["SurgeryDepartment"].ToString().ToUpper();
                                row["BillingStatus"] = NewRow["BillingStatus"].ToString().ToUpper();
                                
                                //Pushing the Value of Amount having respective column name that is created above by SubCategory
                                if (rbtSubCateoryType.SelectedValue == "1")
                                {
                                    row[NewRow["SubCategory"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")] = NewRow["GrossAmtItem"];
                                }
                                else
                                {
                                    //Pushing the Value of Amount having respective column name that is created above by SubCategory
                                    //row[NewRow["SubCategory"].ToString()] = NewRow["Amount"];
                                    //Vipin Changes to the above line
                                    row[NewRow["DisplayName"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")] = Util.GetString(Math.Round(Util.GetDecimal(row[NewRow["DisplayName"].ToString().Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "")]) + Util.GetDecimal(NewRow["Amount"]), 2));

                                }

                                //Adding SumTotal of Amount as NetBillAmount
                                row["NetBillAmount"] = Util.GetString(Util.GetDecimal(row["NetBillAmount"]) + Util.GetDecimal(NewRow["Amount"]));

                                //stroing Discount on TotalBill for further descresing the final Net Amount of Bill after end of looping
                                DiscOnBill = NewRow["DiscountOnBill"].ToString();
                                itemDisocount = Util.GetString(Util.GetDecimal(itemDisocount) + Util.GetDecimal(NewRow["DiscAmt"]));
                            }
                            //Making Round for column NetBillAmount
                            row["NetBillAmount"] = Util.GetString(Math.Round(Util.GetDecimal(row["NetBillAmount"]) - Util.GetDecimal(DiscOnBill)));
                            row["DiscountOnBill"] = Util.GetString(Math.Round(Util.GetDecimal(row["DiscountOnBill"]) + Util.GetDecimal(DiscOnBill)));
                            row["ItemWiseDiscount"] = Util.GetString(Math.Round(Util.GetDecimal(itemDisocount)));
                            dtMerge.Rows.Add(row);
                        }
                    }
                }

                DataRow iRow = dtMerge.NewRow();

                //foreach (DataColumn Col in dtMerge.Columns)
                //{
                //    if (Col.DataType == System.Type.GetType("System.Decimal"))
                //    {
                //        iRow[Col] = dtMerge.Compute("sum(" + Col + ")", "");
                //    }                    
                //}

                //dtMerge.Rows.InsertAt(iRow, dtMerge.Rows.Count + 1);
                dtMerge = Util.GetDataTableRowSum(dtMerge);
                Session["dtExport2Excel"] = dtMerge;
                Session["ReportName"] = "BillRegister";
                Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                
            }
            else
                lblMsg.Text = "Record Not Found";
        }

    }

    protected void chkCompAll_CheckedChanged(object sender, EventArgs e)
    {
        for(int i = 0;i<chkPanel.Items.Count;i++)
                chkPanel.Items[i].Selected = chkCompAll.Checked;
    }
    protected void chkDocAll_CheckedChanged(object sender, EventArgs e)
    {
        for(int i = 0;i<chkDoctor.Items.Count;i++)
            chkDoctor.Items[i].Selected = chkDocAll.Checked;   
    }
    protected void rbtType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtType.SelectedValue == "2")
        {
            rbtSubCateoryType.Visible = true;
            rbtSummaryBy.Visible = false;
            chkfieldlist.Visible = true;
            chkcustomfieldApply.Checked = true;
            chkcustomfieldApply.Visible = true;
            rdoReportType.Visible = false;
            trreportgroup.Visible = false;
            divcustomfield.Visible = true;
        }
        else
        {
            rbtSubCateoryType.Visible = false;
            rbtSummaryBy.Visible = true;
            chkfieldlist.Visible = true;
            chkcustomfieldApply.Visible = true;
            rdoReportType.Visible = true;
            trreportgroup.Visible = true;
            divcustomfield.Visible = true;
        }
    }
}
