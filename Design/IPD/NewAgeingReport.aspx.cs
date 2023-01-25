using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;


public partial class Design_IPD_NewAgeingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {                   
            BindPanelGroup();        
            BindPanel(ddlPanelGroup.SelectedValue);          
        }
    }


    private void BindPanelGroup()
    {
        DataTable dt = StockReports.GetDataTable("Select * from f_panelgroup where active=1 order by PanelGroup");

        ddlPanelGroup.DataSource = dt;
        ddlPanelGroup.DataTextField = "PanelGroup";
        ddlPanelGroup.DataValueField = "PanelGroup";
        ddlPanelGroup.DataBind();
        ddlPanelGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
    }
    public void BindPanel(string PanelGroup)
    {
        DataTable dtPanel = new DataTable();
        if (PanelGroup.ToUpper() == "ALL")
            //dtPanel = EDPReports.GetPanels();
            dtPanel = GetPanels();
        else
            //dtPanel = EDPReports.GetPanels(PanelGroup);
            dtPanel = GetPanels(PanelGroup);

        cblPanel.DataSource = dtPanel;
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            cblPanel.DataTextField = "text";
            cblPanel.DataValueField = "value";
            cblPanel.DataBind();
        }      
    }

    private DataTable GetPanels()
    {
        string str = "select PanelID value,Company_Name text From f_panel_master pm order by Company_Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }

    private DataTable GetPanels(string PanelGroup)
    {
        string str = "select PanelID value,Company_Name text From f_panel_master where PanelGroup='" + PanelGroup + "' order by Company_Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
       
        string PanelIDs = GetSelection(cblPanel);
        try
        {

            string PanelID = GetSelection(cblPanel);
            if (PanelID == "")
            {
                if (ddlPanelGroup.SelectedItem.Value.ToUpper() == "ALL")
                {                    
                    PanelID = "";
                }
                else
                {
                    DataTable dtpanel = EDPReports.GetPanels(ddlPanelGroup.SelectedItem.Value);
                       
                       string newPanelID = "";
                       foreach (DataRow dr in dtpanel.Rows)
                       {
                           newPanelID = newPanelID + Util.GetString(dr[0]) + ",";

                       }
                       PanelID = newPanelID.Substring(0, newPanelID.Length - 1);
                }
            }
              GetAgeingData(PanelID); 
        }

        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
           // lblMsg.Text = "Error";
            return;
        }



    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
    private void GetAgeingData(string panelID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        if (rdoReportType.SelectedValue == "1")
        {
            sb.Append("SELECT  PName,REPLACE(TransactionID,'ISHHI','')IPDNo,REPLACE(PatientID,'LSHHI','')MR_No, ");
            sb.Append("BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')Billdate,DATE_FORMAT(DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(DateOfDischarge,'%d-%b-%Y')DateOfDischarge,  ");
            sb.Append("InsuranceCompanyNAME As ParentPanel,Panel PanelName,IFNULL(CardNo,'')CardNo,IFNULL(ClaimNo,'')ClaimNo,IFNULL(PolicyNo,'')PolicyNo, ");
            sb.Append("CardHolderName,RelationWith_holder, ");
            
            if (ChktxtAge.Checked == true)
            {
                sb.Append("ROUND(OutStanding,2)OutStandingAmt,ROUND(OutStanding,2)TotalOutStandingAmt ");
            }
            else
            {

                if (rdoAgeLimit.SelectedValue.ToString() == "ALL")
                {
                    sb.Append("IF(Days<60,ROUND(OutStanding,2),0)DaysLessThan60,IF(Days>=60 AND Days<120,ROUND(OutStanding,2),0)Days60to120, ");
                    sb.Append("IF(Days>=120 AND Days<180,ROUND(OutStanding,2),0)Days120to180,IF(Days>=180,ROUND(OutStanding,2),0)DaysMoreThan180,ROUND(OutStanding,2)TotalOutStandingAmt ");
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "LessThan60")
                {
                    sb.Append("IF(Days<60,ROUND(OutStanding,2),0)DaysLessThan60,ROUND(OutStanding,2)TotalOutStandingAmt ");

                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "60-120")
                {
                    sb.Append("IF(Days>=60 AND Days<120,ROUND(OutStanding,2),0)Days60to120,ROUND(OutStanding,2)TotalOutStandingAmt ");
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "120-180")
                {
                    sb.Append("IF(Days>=120 AND Days<180,ROUND(OutStanding,2),0)Days120to180,ROUND(OutStanding,2)TotalOutStandingAmt ");

                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "GreaterThan180")
                {
                    sb.Append("IF(Days>=180,ROUND(OutStanding,2),0)DaysMoreThan180,ROUND(OutStanding,2)TotalOutStandingAmt ");
                }
            }
            sb.Append(",DATE_FORMAT(DispatchDate,'%d-%b-%y')DispatchDate,DocketNo,DispatchRemarks,CourierComp  ");
            sb.Append("FROM (       ");
            sb.Append("     SELECT BillDate, ");
            sb.Append("     DATEDIFF(DATE(CURRENT_DATE),DATE(BillDate))Days, ");
            sb.Append("     BillNo,PatientID,REPLACE(T4.TransactionID,'ISHHI','')TransactionID,UPPER(PName)PName,      ");
            sb.Append("     CAST(InsuranceCompanyNAME AS CHAR)InsuranceCompanyNAME,CAST(PolicyHolderNAME AS CHAR)PolicyHolderNAME, ");
            sb.Append("     CAST(EmployeeCODE AS CHAR)EmployeeCODE,CAST(DispatchDate AS CHAR)DispatchDate,CAST(DocketNo AS CHAR)DocketNo, ");
            sb.Append("     CAST(DispatchRemarks AS CHAR)DispatchRemarks,CAST(CourierComp AS CHAR)CourierComp, ");
            sb.Append("     ROUND(CAST(GrossAmt AS DECIMAL(15,2)),2)GrossBillAmt,ROUND(CAST(TotalDiscount AS DECIMAL(15,2)),2)TotalDiscount,      ");
            sb.Append("     ROUND(CAST(NetAmount AS DECIMAL(15,2)),2)AS NetBillAmount,      ");
            sb.Append("     CAST((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID=T4.TransactionID AND IsCancel = 0 AND AmountPaid >0      ");
            sb.Append("     GROUP BY T4.TransactionID) AS DECIMAL(15,2))TotalDeposit,CAST((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept      ");
            sb.Append("     WHERE TransactionID =T4.TransactionID AND IsCancel = 0 AND AmountPaid <0 GROUP BY T4.TransactionID)      ");
            sb.Append("     AS DECIMAL(15,2))TotalRefund,ROUND(CAST(ReceiveAmt AS DECIMAL(15,2)),2)ReceiveAmt,      ");
            sb.Append("     ROUND(CAST(AdjustmentAmt AS DECIMAL(15,2)),2)AdjustmentAmt,ROUND(CAST(OutStanding AS DECIMAL(15,2)),2) AS OutStanding,      ");
            sb.Append("     ROUND(CAST(TDS AS DECIMAL(15,2)),2)TDS, ");
            sb.Append("     ROUND(CAST(DeductionAcceptable AS DECIMAL(15,2)),2) AS DeductionAcceptable,ROUND(CAST(DeductionNonAcceptable AS DECIMAL(15,2)),2) AS DeductionNonAcceptable, ");
            sb.Append("     ROUND(CAST(WriteOff AS DECIMAL(15,2)),2) AS WriteOff,ROUND(CAST(CreditAmt AS DECIMAL(15,2)),2) AS CreditAmt,ROUND(CAST(DebitAmt AS DECIMAL(15,2)),2) AS DebitAmt, ");
            sb.Append("     CAST(ServiceTaxAmt AS DECIMAL(15,2))ServiceTaxAmt,      ");   
            sb.Append("     CAST(ServiceTaxSurChgAmt AS DECIMAL(15,2))ServiceTaxSurChgAmt,UPPER(DiscountOnBillReason)DiscountOnBillReason,         ");
            sb.Append("     UPPER(ApprovalBy)ApprovalBy,UPPER(Panel)Panel,CAST(PanelApprovedAmt AS DECIMAL(15,2))PanelApprovedAmt,UPPER(PolicyNo)PolicyNo,         ");
            sb.Append("     UPPER(CardNo)CardNo,UPPER(ClaimNo)ClaimNo,UPPER(CardHolderName)CardHolderName,UPPER(RelationWith_holder)RelationWith_holder,UPPER(PanelAppRemarks)PanelAppRemarks,PanelApprovalDate         ");
            sb.Append("     ,IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus,DateOfAdmit,DateOfDischarge      ");
            sb.Append("     FROM (      ");
            sb.Append("             SELECT BillDate,BillNo,PatientID,TransactionID,PName,ROUND(TotalBilledAmt) GrossAmt,         ");
            sb.Append("             ROUND((ItemWiseDiscount+DiscountOnBill))TotalDiscount,ROUND((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))         ");
            sb.Append("             AS NetAmount,ROUND(AdjustmentAmt)AdjustmentAmt,ROUND(ReceiveAmt)ReceiveAmt,         ");
            sb.Append("             ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt+TDS+DeductionAcceptable+DeductionNonAcceptable+WriteOff +DebitAmt)-CreditAmt+ ServiceTaxAmt+         ");
            sb.Append("             ServiceTaxSurChgAmt)) AS OutStanding,Panel,ROUND(TDS)TDS, ");
            sb.Append("             ROUND(DeductionAcceptable)DeductionAcceptable,ROUND(DeductionNonAcceptable)DeductionNonAcceptable, ");
            sb.Append("             ROUND(WriteOff)WriteOff,ROUND(CreditAmt)CreditAmt,ROUND(DebitAmt)DebitAmt, ");
            sb.Append("             ROUND(ServiceTaxAmt,2)ServiceTaxAmt,         ");
            sb.Append("             ROUND(ServiceTaxSurChgAmt,2)ServiceTaxSurChgAmt,PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,      ");   
            sb.Append("             PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed,DateOfAdmit,DateOfDischarge,      ");
            sb.Append("             InsuranceCompanyNAME,PolicyHolderNAME,EmployeeCODE,CardHolderName,RelationWith_holder,DispatchDate,DocketNo,DispatchRemarks,CourierComp       ");
            sb.Append("             FROM(");
            sb.Append("                     SELECT BillDate,BillNo,PatientID,TransactionID,PName,IFNULL(TotalBilledAmt,0)TotalBilledAmt,");
            sb.Append("                     IFNULL(ItemWiseDiscount,0)ItemWiseDiscount,IFNULL(DiscountOnBill,0)DiscountOnBill,");
            sb.Append("                     IFNULL(AdjustmentAmt,0)AdjustmentAmt,IFNULL(ReceiveAmt,0)ReceiveAmt,IFNULL(TDS,0)TDS,");
            sb.Append("                     IFNULL(Deduction_Acceptable,0)DeductionAcceptable,IFNULL(Deduction_NonAcceptable,0)DeductionNonAcceptable, ");
            sb.Append("                     IFNULL(WriteOff,0)WriteOff,IFNULL(CreditAmt,0)CreditAmt,IFNULL(DebitAmt,0)DebitAmt, ");
            sb.Append("                     ServiceTaxAmt,ServiceTaxSurChgAmt,Panel,PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,         ");
            sb.Append("                     PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed,DateOfAdmit,DateOfDischarge,      ");
            sb.Append("                     InsuranceCompanyNAME,PolicyHolderNAME,EmployeeCODE,CardHolderName,RelationWith_holder,DispatchDate,DocketNo,DispatchRemarks,CourierComp       ");
            sb.Append("                     FROM (             ");
            sb.Append("                             SELECT T1.BillNo,T1.BillDate,T1.PatientID,T1.TransactionID,T1.TotalBilledAmt,T1.DiscountOnBill,pmh.TDS,         ");
            sb.Append("                             pmh.Deduction_Acceptable,pmh.Deduction_NonAcceptable,pmh.WriteOff,(SELECT SUM(amount) FROM f_drcrnote ");
            sb.Append("                             WHERE TransactionID=T1.TransactionID AND CRDR='CR01' AND cancel=0 GROUP BY TransactionID)CreditAmt, ");
            sb.Append("                             (SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=T1.TransactionID AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID)DebitAmt,    ");
            sb.Append("                             T1.AdjustmentAmt,T1.ReceiveAmt,T1.ItemWiseDiscount,T1.PName,ServiceTaxAmt,ServiceTaxSurChgAmt,        ");
            sb.Append("                             pmh.PolicyNo,pmh.CardNo,T1.ClaimNo,pmh.CardHolderName,pmh.RelationWith_holder,T1.PanelApprovedAmt,T1.PanelAppRemarks,         ");
            sb.Append("                             DATE_FORMAT(T1.PanelApprovalDate,'%d-%b-%y')PanelApprovalDate,T1.DiscountOnBillReason,T1.ApprovalBy,PM.Company_Name         ");
            sb.Append("                             Panel,IsBilledClosed,ich.DateOfAdmit,ich.DateOfDischarge,      ");
            sb.Append("                             (SELECT Company_name FROM f_panel_master WHERE PanelID=pmh.ParentID)InsuranceCompanyNAME,''PolicyHolderNAME,pmh.Employee_id EmployeeCODE,       ");
            sb.Append("                             (SELECT  ds.DispatchDate   FROM f_dispatch ds WHERE ds.TransactionID=pmh.TransactionID ");
		    sb.Append("                             GROUP BY TransactionID)DispatchDate   ");
		    sb.Append("                             ,(SELECT  ds.DocketNo  FROM f_dispatch ds WHERE ds.TransactionID=pmh.TransactionID  ");
		    sb.Append("                             GROUP BY TransactionID)DocketNo ");
		    sb.Append("                             ,(SELECT  ds.Remarks   FROM f_dispatch ds WHERE ds.TransactionID=pmh.TransactionID  ");
		    sb.Append("                             GROUP BY TransactionID)DispatchRemarks ");
		    sb.Append("                             ,(SELECT  ds.CourierComp  FROM f_dispatch ds WHERE ds.TransactionID=pmh.TransactionID  ");
            sb.Append("                             GROUP BY TransactionID)CourierComp             ");
            sb.Append("                             FROM  (      ");
            sb.Append("                                     SELECT BillNo,BillDate,PatientID,Temp1.TransactionID,(SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail          ");
            sb.Append("                                     WHERE TransactionID = Temp1.TransactionID AND IsVerified = 1 AND IsPackage = 0         ");
            sb.Append("                                     GROUP BY TransactionID)TotalBilledAmt,DiscountOnBill,AdjustmentAmt,");
            sb.Append("                                     (SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID AND IsCancel = 0          ");
            sb.Append("                                     GROUP BY TransactionID)ReceiveAmt,(SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail          ");
            sb.Append("                                     WHERE TransactionID = Temp1.TransactionID AND IsVerified = 1 AND IsPackage = 0 GROUP BY TransactionID)         ");
            sb.Append("                                     ItemWiseDiscount, UserID,ServiceTaxAmt,ServiceTaxSurChgAmt,PName,ClaimNo,PanelAppRemarks,PanelApprovedAmt,         ");
            sb.Append("                                     PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed        ");
            sb.Append("                                     FROM  (      ");
            sb.Append("                                             SELECT LT.BillNo,LT.BillDate,Adj.PatientID,Adj.TransactionID,Adj.TotalBilledAmt,Adj.DiscountOnBill,Adj.AdjustmentAmt,Adj.UserID,Adj.TDS,         ");
            sb.Append("                                             Adj.ServiceTaxAmt,Adj.ServiceTaxSurChgAmt,PT.PName PName,adj.ClaimNo,adj.PanelAppRemarks,adj.PanelApprovedAmt,         ");
            sb.Append("                                             adj.PanelApprovalDate,adj.DiscountOnBillReason,adj.ApprovalBy,adj.IsBilledClosed       ");
            sb.Append("                                             FROM (         ");
            sb.Append("                                                     SELECT BillNo,TransactionID,Billdate FROM f_ledgertransaction WHERE IsCancel = 0          ");
            sb.Append("                                                     GROUP BY BillNo      ");
            sb.Append("                                             )lt INNER JOIN f_ipdadjustment adj ON adj.TransactionID = lt.TransactionID INNER JOIN patient_master pt       ");
            sb.Append("                                             ON pt.PatientID = adj.PatientID WHERE (Adj.BillNo IS NOT NULL) AND Adj.BillNo <> ''         ");
            sb.Append("                                     )Temp1 ");
            sb.Append("                             ) T1 ");
            sb.Append("                             INNER JOIN patient_medical_history pmh ON T1.TransactionID = pmh.TransactionID         ");
            sb.Append("                             INNER JOIN ipd_case_History ich ON ich.TransactionID = pmh.TransactionID         ");
            sb.Append("                             LEFT OUTER JOIN f_panel_master PM ON PM.PanelID = pmh.PanelID       ");
            if (panelID != "")
                sb.Append("                         where pmh.PanelID   IN (" + panelID + ") ");

            sb.Append("                     )T2 ");
            sb.Append("             )T3 ");
            sb.Append("     )T4 ");
            sb.Append(")T5 ");

            sb.Append("WHERE OutStanding <> 0         ");

            if (ChktxtAge.Checked == true)
            {
                sb.Append("AND days >="+txtAge.Text.ToString().Trim()+"  ");
            }
            else
            {
                if (rdoAgeLimit.SelectedValue.ToString() == "LessThan60")
                    sb.Append(" AND days <60 ");
                else if (rdoAgeLimit.SelectedValue.ToString() == "60-120")
                    sb.Append(" AND Days>=60 AND Days<120 ");
                else if (rdoAgeLimit.SelectedValue.ToString() == "120-180")
                    sb.Append("and Days>=120 AND Days<180 ");
                else if (rdoAgeLimit.SelectedValue.ToString() == "GreaterThan180")
                    sb.Append("and  Days>=180 ");
             }
        }
        else
        {
            //new changes
            sb.Append(" SELECT  PanelName,PatientID MR_No,PName,IF(IFNULL(BillNo,'')='',ReceiptNo,BillNo)BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')Billdate, ");
            sb.Append(" IFNULL(CardNo,'')CardNo,IFNULL(PolicyNo,'')PolicyNo, ");

            if (ChktxtAge.Checked == true)
            {
                sb.Append("ROUND(OutStandingAmt,2)OutStandingAmt,ROUND(OutStandingAmt,2)TotalOutStandingAmt ");
            }
            else
            {
                if (rdoAgeLimit.SelectedValue.ToString() == "ALL")
                {
                    sb.Append("IF(Days<60,ROUND(OutStandingAmt,2),0)DaysLessThan60,IF(Days>=60 AND Days<120,ROUND(OutStandingAmt,2),0)Days60to120, ");
                    sb.Append("IF(Days>=120 AND Days<180,ROUND(OutStandingAmt,2),0)Days120to180,IF(Days>=180,ROUND(OutStandingAmt,2),0)DaysMoreThan180,ROUND(OutStandingAmt,2)TotalOutStandingAmt ");
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "LessThan60")
                {
                    sb.Append("IF(Days<60,ROUND(OutStandingAmt,2),0)DaysLessThan60,ROUND(OutStandingAmt,2)TotalOutStandingAmt ");
                 
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "60-120")
                {

                    sb.Append("IF(Days>=60 AND Days<120,ROUND(OutStandingAmt,2),0)Days60to120,ROUND(OutStandingAmt,2)TotalOutStandingAmt ");
                 
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "120-180")
                {
                    sb.Append("IF(Days>=120 AND Days<180,ROUND(OutStandingAmt,2),0)Days120to180,ROUND(OutStandingAmt,2)TotalOutStandingAmt ");
                   
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "GreaterThan180")
                {
                    sb.Append("IF(Days>=180,ROUND(OutStandingAmt,2),0)DaysMoreThan180,ROUND(OutStandingAmt,2)TotalOutStandingAmt ");
                }
            }
         
             sb.Append("FROM ( ");
             sb.Append("  SELECT Billdate,DATEDIFF(CURRENT_DATE,BillDate)Days,BillNo,REPLACE(PatientID,'LSHHI','')PatientID, ");
             sb.Append("  REPLACE(REPLACE(TransactionID,'LLSHHI',''),'LSHHI','')TransactionID,(SELECT Pname FROM patient_master WHERE  ");
             sb.Append("  PatientID=t3.PatientID)PName,NetAmount TotalBilledAmt,''TotalDiscount,IFNULL(Amtpaid,0)ReceiveAmt,PanelName,NetAmount, ");
             sb.Append("  ''AdjustmentAmt,(NetAmount-AmtPaid)OutStandingAmt,PolicyNo,CardNo,ReceiptNo FROM ( ");
             sb.Append("     SELECT temp.PatientID,temp.TransactionID,temp.BillNo,''ReceiptNo,temp.BillDate,temp.PanelName,(SELECT SUM(ltd.Amount)  ");
             sb.Append("     FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=temp.LedgerTransactionNo GROUP BY ltd.LedgerTransactionNo)NetAmount ");
             sb.Append("     ,IFNULL(rt.AmountPaid+TDS+Deduction_Acceptable+WriteOff,0)AmtPaid,'' OutStanding,temp.PolicyNo,temp.CardNo FROM( ");
             sb.Append("        SELECT lt.BillNo,lt.Date BillDate,lt.LedgerTransactionNo,pnl.Company_Name PanelName,pmh.PanelID,lt.TransactionID,    ");
             sb.Append("        IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.WriteOff,0)WriteOff,pm.PatientID, ");
             sb.Append("        pmh.PolicyNo,pmh.CardNo FROM f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON  ");
             sb.Append("        lt.TransactionID=pmh.TransactionID INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID   ");
             sb.Append("        INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID   WHERE  lt.IsCancel=0 AND  ");
             sb.Append("        pmh.Type<> 'IPD'  ");

             if(panelID !="")
                sb.Append("        AND  pmh.PanelID IN   (" + panelID + ") ");

             sb.Append("     )temp   ");
             sb.Append("     LEFT JOIN f_reciept rt ON temp.LedgerTransactionNo=rt.AsainstLedgerTnxNo    ");
             sb.Append("     UNION ALL ");
             sb.Append("     SELECT t2.patientid PatientID,t2.transactionid TransactionID,lt.BillNo,t2.ReceiptNo,dtEntry BillDate,pnl.Company_Name PanelName ");
             sb.Append("     ,ABS(t2.NetAmount)NetAmount,(IFNULL(t2.AmountPaid,0)+IFNULL(pmh.TDS,0)+IFNULL(pmh.Deduction_Acceptable,0)+IFNULL(pmh.WriteOff,0))AmtPaid ");
             sb.Append("     ,t2.OutStanding,pmh.PolicyNo,pmh.CardNo FROM( ");
             sb.Append("        SELECT t.patientid,t.OutStanding,t.NetAmount,t.ReceiptNo,t.dtEntry,t.userid,t.transactionid,t1.AmountPaid, ");
             sb.Append("        t.LedgerTransactionNO FROM   ( ");
             sb.Append("          SELECT id,SUM(amount)OutStanding,patientid,amount NetAmount,TYPE,dtEntry,userid,ReceiptNo,LedgerTransactionNO, ");
             sb.Append("          transactionid FROM f_patientaccount GROUP BY patientid ");
             sb.Append("          )t LEFT JOIN (SELECT SUM(amount)AmountPaid,patientid FROM f_patientaccount WHERE TYPE='DEBIT' GROUP BY patientid)t1 ");
             sb.Append("          ON t.patientid=t1.patientid WHERE t.OutStanding<0 ");
             sb.Append("        )t2   INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNO=t2.LedgerTransactionNO   ");
             sb.Append("        INNER JOIN patient_medical_history pmh ON pmh.TransactionID=t2.TransactionID   INNER JOIN f_panel_master pnl ON  ");
             sb.Append("        pmh.PanelID=pnl.PanelID ");
             if (panelID != "")
             {
                sb.Append("        WHERE pmh.PanelID IN   (" + panelID + ")  ");
             }
             sb.Append("  )T3 ");
             sb.Append(")T4 WHERE OutStandingAmt>1  ");


             if (ChktxtAge.Checked == true)
             {
                 sb.Append("AND days >=" + txtAge.Text.ToString().Trim() + "  ");
             }
             else
             {
                 if (rdoAgeLimit.SelectedValue.ToString() == "ALL")
                 {
                 }
                 else if (rdoAgeLimit.SelectedValue.ToString() == "LessThan60")
                 {
                     sb.Append(" AND days <60 ");
                 }
                 else if (rdoAgeLimit.SelectedValue.ToString() == "60-120")
                 {

                     sb.Append(" AND Days>=60 AND Days<120 ");
                 }
                 else if (rdoAgeLimit.SelectedValue.ToString() == "120-180")
                 {

                     sb.Append("and Days>=120 AND Days<180 ");
                 }
                 else if (rdoAgeLimit.SelectedValue.ToString() == "GreaterThan180")
                 {
                     sb.Append("and Days>=180 ");
                 }
             }
         sb.Append("ORDER BY PanelName ");

        }

        dt = StockReports.GetDataTable(sb.ToString());
       //return dt;

        if (dt.Rows.Count > 0)
        {
            DataRow drNew = dt.NewRow();
           

            if (ChktxtAge.Checked == true)
            {
                sb.Append("ROUND(OutStanding,2)OutStandingAmt ");
                drNew["OutStandingAmt"] = dt.Compute("sum(OutStandingAmt)", "");
            }
            else
            {

                if (rdoAgeLimit.SelectedValue.ToString() == "ALL")
                {
                    drNew["DaysLessThan60"] = dt.Compute("sum(DaysLessThan60)", "");

                    drNew["Days60to120"] = dt.Compute("sum(Days60to120)", "");

                    drNew["Days120to180"] = dt.Compute("sum(Days120to180)", "");

                    drNew["DaysMoreThan180"] = dt.Compute("sum(DaysMoreThan180)", "");
                    
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "LessThan60")
                {
                    drNew["DaysLessThan60"] = dt.Compute("sum(DaysLessThan60)", "");

                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "60-120")
                {
                    drNew["Days60to120"] = dt.Compute("sum(Days60to120)", "");
                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "120-180")
                {
                    drNew["Days120to180"] = dt.Compute("sum(Days120to180)", "");

                }
                else if (rdoAgeLimit.SelectedValue.ToString() == "GreaterThan180")
                {
                    drNew["DaysMoreThan180"] = dt.Compute("sum(DaysMoreThan180)", "");
                }

                drNew["TotalOutStandingAmt"] = dt.Compute("sum(TotalOutStandingAmt)", "");
            }


            dt.Rows.InsertAt(drNew, dt.Rows.Count + 1);


            //Session["dtExport2Excel"] = dt;
            //Session["ReportName"] = "BillRegister";
            //Session["Period"] = "From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Ageing Report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);




        }
        else
           // lblMsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

    }
    protected void chkCompAll_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < cblPanel.Items.Count; i++)
            cblPanel.Items[i].Selected = chkCompAll.Checked;
    }
    protected void ddlPanelGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (ddlPanelGroup.SelectedItem.Value.ToUpper() != "ALL")
            dt = EDPReports.GetPanels(ddlPanelGroup.SelectedItem.Value);
        else
            dt = EDPReports.GetPanels();

        if (dt.Rows.Count > 0)
        {
            cblPanel.Visible = true;
            cblPanel.DataSource = dt;
            cblPanel.DataTextField = "text";
            cblPanel.DataValueField = "value";
            cblPanel.DataBind();
        }  
    }
}
