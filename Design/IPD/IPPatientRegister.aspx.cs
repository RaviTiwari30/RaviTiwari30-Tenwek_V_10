using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Reports_IPD_IPPatientRegister : System.Web.UI.Page
{
    protected void btnBinSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        lblMsg.Text = "";
        GetIPDRegister(Centre);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnBinSearch);

        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
        lblMsg.Text = "";
    }

    private void GetIPDRegister(string Centre)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.Append("SELECT t.CentreID,t.CentreName,MRNo,IF(t.Type='IPD',TransNo,'')IPDNo,t.DateOfAdmit,t.TimeOfAdmit,");
        sb.Append("CONCAT(t.title,' ',t.PName)  PatientName,Age,Gender Sex,CONCAT(House_No,' ',city) AS Address,Country,Mobile ContactNo,Relation,RelationName,");
        sb.Append("(SELECT NAME FROM Ipd_case_type_Master WHERE IPDCaseTypeID=adpip.IPDCaseTypeID LIMIT 1)AdmittedRoomType,");
        sb.Append("(SELECT CONCAT(NAME,' ',Bed_No) FROM room_master WHERE roomID=adpip.RoomID  LIMIT 1)AdmittedBedNo,MainConsultant,ROUND((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetAmount,ROUND(ReceiveAmt_After_BillDate)ReceiveAmt_After_BillDate,");
        sb.Append("(SELECT NAME FROM Ipd_case_type_Master WHERE IPDCaseTypeID=dipip.IPDCaseTypeID LIMIT 1)DischargedRoomType,");
        sb.Append("(SELECT CONCAT(NAME,' ',Bed_No) FROM room_master WHERE roomID=dipip.RoomID LIMIT 1)DischargedBedNo,");
        sb.Append("(SELECT NAME FROM Ipd_case_type_Master WHERE IPDCaseTypeID=dipip.IPDCaseTypeID_Bill LIMIT 1)BillingRoomType,");
        sb.Append("MainConsultant,SecondaryConsultant,AdmittedBy,Relation,RelationName,");
        sb.Append("MLC_No,Admission_Type,Source,Panel,ParentPanel,VulnerableType,CurrentStatus,t.Remarks,DischargeType,");
        sb.Append("DischargedBy,AdmissionCancelDate,AdmissionCancelledBy,AdmissionCancelReason,DischargeCancelDate,");
        sb.Append("DischargedCancelledBy,DischargeCancelReason,BillNoCancelled,BillDateOfBillNoCancelled,BillCancellationDate,");
        sb.Append("BillCancelUserID,t.BillNo,t.BillDate,BillGeneratedBy,Round(TotalBilledAmt)BillAmt,ROUND(IFNULL(ServiceTaxAmt,0),2)ServiceTaxAmt,ROUND(RoundOff,2)RoundOff,");
        sb.Append(" ROUND(IFNULL(TotalBilledAmt,0)+IFNULL(ServiceTaxAmt,0)+IFNULL(RoundOff,0))TotalBillAmt,Round(DiscountOnBill)DiscountOnBill,");
        sb.Append("Round(ItemWiseDiscount)ItemWiseDiscount,Round(ItemWiseDiscount+DiscountOnBill)TotalDiscount,");
        sb.Append("Round((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetAmount,");
        sb.Append("Round(Deposit_AsOn_BillDate)Deposit_AsOn_BillDate,Round(Refund_AsOn_BillDate)Refund_AsOn_BillDate,Round(ReceiveAmt_AsOn_BillDate)ReceiveAmt_AsOn_BillDate,");
        sb.Append("Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+ReceiveAmt_AsOn_BillDate)) As OutStanding_AsOn_BillDate,");
        sb.Append("Round(Deposit_After_BillDate)Deposit_After_BillDate,Round(Refund_After_BillDate)Refund_After_BillDate,Round(ReceiveAmt_After_BillDate)ReceiveAmt_After_BillDate,");
        sb.Append("TDS,Deduction_Acceptable,Deduction_NonAcceptable,DeductionReason,WriteOff,WriteOffRemarks,DebitAmt,CreditAmt,");
        sb.Append("Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+Deduction_Acceptable+Deduction_NonAcceptable+ReceiveAmt_AsOn_BillDate+ReceiveAmt_After_BillDate+TDS+WriteOff)-CreditAmt+DebitAmt+ ServiceTaxAmt+ServiceTaxSurChgAmt) As OutStanding_After_BillDate,");
        sb.Append("ClaimNo,t.PolicyNo,t.CardNo,t.CardHolderName,t.RelationWith_holder,FileNo,PanelAppRemarks,PanelApprovedAmt,PanelApprovalDate,");
        sb.Append("DiscountOnBillReason,BillingRemarks,t.ApprovalBy DiscApprovedBy,BillingStatus ");
        sb.Append("FROM (");
        sb.Append("    SELECT cm.`CentreID`,cm.`CentreName`,pm.PatientID MRNo,pm.Title,pm.PName,pm.House_No,pm.Street_Name,pm.Locality,pm.City,");
        sb.Append("    pm.State,pm.Country,pm.Phone,pm.Mobile,pm.Age,pm.Relation,pm.RelationName,pm.Gender,pm.MaritalStatus,");
        sb.Append("    pmh.TransactionID,DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,pmh.TimeOfAdmit,");
        sb.Append("    DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,pmh.TimeOfDischarge,");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employeeID=pmh.UserID)AdmittedBy,");
        sb.Append("    (SELECT NAME FROM Doctor_master WHERE DoctorID=pmh.DoctorID)MainConsultant,");
        sb.Append("    (SELECT NAME FROM Doctor_master WHERE DoctorID=pmh.DoctorID1)SecondaryConsultant,");
        sb.Append("    (SELECT MIN(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID)AdPatientIPDProfile_ID,");
        sb.Append("    (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID)DisPatientIPDProfile_ID,");
        sb.Append("    pmh.KinName,pmh.KinRelation,pmh.KinAddress,pmh.KinPhone,pmh.MLC_NO,pmh.Admission_Type,pmh.Source,");
        sb.Append("    (SELECT Company_Name FROM f_panel_master WHERE PanelID= pmh.PanelID)Panel,");
        sb.Append("    (SELECT Company_Name FROM f_panel_master WHERE ParentID= pmh.PanelID)ParentPanel,");
        sb.Append("    pmh.VulnerableType,UCASE(pmh.Status)CurrentStatus,PMH.Remarks,pmh.DischargeType,");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employeeID=pmh.DischargedBy)DischargedBy,");
        sb.Append("    DATE_FORMAT(pmh.AdmissionCancelDate,'%d-%b-%Y')AdmissionCancelDate,");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employeeID=pmh.AdmissionCancelledBy)AdmissionCancelledBy,");
        sb.Append("    AdmissionCancelReason,DATE_FORMAT(pmh.DischargeCancelDate,'%d-%b-%Y')DischargeCancelDate,");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employeeID=pmh.DischargedCancelledBy)DischargedCancelledBy,");
        sb.Append("    DischargeCancelReason,");
        sb.Append("    (SELECT BillNo FROM f_billcancellation WHERE TransactionID=pmh.TransactionID LIMIT 1)BillNoCancelled,");
        sb.Append("    (SELECT DATE_FORMAT(BillDate,'%d-%b-%Y') FROM f_billcancellation WHERE TransactionID=pmh.TransactionID  LIMIT 1)BillDateOfBillNoCancelled,");
        sb.Append("    (SELECT DATE_FORMAT(CancelDate,'%d-%b-%Y') FROM f_billcancellation WHERE TransactionID=pmh.TransactionID  LIMIT 1)BillCancellationDate,");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employeeID=(SELECT CancelUserID FROM f_billcancellation ");
        sb.Append("    WHERE TransactionID=pmh.TransactionID ORDER BY BillCancel_ID DESC LIMIT 1))BillCancelUserID,pmh.BillNo,");
        sb.Append("    IF(Date(pmh.BillDate)='0001-01-01','',DATE_FORMAT(pmh.BillDate,'%d-%b-%Y'))BillDate,");
        sb.Append("    IF(UCASE(pmh.Status)<>'CANCEL',");
        sb.Append("    (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ");
        sb.Append("    WHERE TransactionID = pmh.TransactionID AND IsVerified = 1 AND IsPackage = 0 ");
        sb.Append("    GROUP BY TransactionID),0)TotalBilledAmt,IFNULL(pmh.DiscountOnBill,0)DiscountOnBill, IFNULL(pmh.RoundOff,0)RoundOff,");

        //ReceiveAmt_AsOn_BillDate,");
        sb.Append("    IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =pmh.TransactionID ");
        sb.Append("    AND IsCancel = 0 and Date(Date) <=Date(pmh.BillDate) GROUP BY TransactionID),0)ReceiveAmt_AsOn_BillDate,");

        //ReceiveAmt_After_BillDate,");
        sb.Append("    IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =pmh.TransactionID ");
        sb.Append("    AND IsCancel = 0 and Date(Date) >Date(pmh.BillDate) GROUP BY TransactionID),0)ReceiveAmt_After_BillDate,");

        //Deposit_AsOn_BillDate
        sb.Append("    Cast(IFNULL((Select sum(AmountPaid) from f_reciept where TransactionID =pmh.TransactionID and IsCancel = 0 and AmountPaid >0 and Date(Date) <=Date(pmh.BillDate) group by pmh.TransactionID),0) as DECIMAL(15,2))Deposit_AsOn_BillDate,");

        //Deposit_After_BillDate
        sb.Append("    Cast(IFNULL((Select sum(AmountPaid) from f_reciept where TransactionID =pmh.TransactionID and IsCancel = 0 and AmountPaid >0 and Date(Date) >Date(pmh.BillDate) group by pmh.TransactionID),0) as DECIMAL(15,2))Deposit_After_BillDate,");

        //Refund_AsOn_BillDate
        sb.Append("    Cast(IFNULL((Select Replace(sum(AmountPaid),'-','') from f_reciept where TransactionID =pmh.TransactionID and IsCancel = 0 and AmountPaid <0 and Date(Date) <=Date(pmh.BillDate) group by pmh.TransactionID),0) as DECIMAL(15,2))Refund_AsOn_BillDate,");

        //Refund_After_BillDate
        sb.Append("    Cast(IFNULL((Select Replace(sum(AmountPaid),'-','') from f_reciept where TransactionID =pmh.TransactionID and IsCancel = 0 and AmountPaid <0 and Date(Date) >Date(pmh.BillDate) group by pmh.TransactionID),0) as DECIMAL(15,2))Refund_After_BillDate,");

        sb.Append("    IF(UCASE(pmh.Status)<>'CANCEL',IFNULL((SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail ");
        sb.Append("    WHERE TransactionID = pmh.TransactionID AND IsVerified = 1 AND IsPackage = 0 ");
        sb.Append("    GROUP BY TransactionID),0),0)ItemWiseDiscount, ");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employeeID=pmh.UserID)BillGeneratedBy,IFNULL(pmh.TDS,0)TDS,");

        sb.Append("    IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,");
        sb.Append("    pmh.DeductionReason,IFNULL(pmh.WriteOff,0)WriteOff,pmh.WriteOffRemarks,pmh.ServiceTaxAmt,pmh.ServiceTaxSurChgAmt,");
        sb.Append("    pmh.ClaimNo,pmh.PolicyNo,pmh.CardNo,pmh.CardHolderName,pmh.RelationWith_holder,pmh.FileNo,");
        sb.Append("    pmh.PanelAppRemarks,pmh.PanelApprovedAmt,");
        sb.Append("    IF(PanelApprovalDate='0001-01-01','',DATE_FORMAT(PanelApprovalDate,'%d-%b-%y'))PanelApprovalDate,");
        sb.Append("    pmh.DiscountOnBillReason,pmh.BillingRemarks,");

        sb.Append("    IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=pmh.TransactionID  ");
        sb.Append("    AND CRDR='CR01' AND cancel=0  GROUP BY TransactionID),0)CreditAmt, ");
        sb.Append("    IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=pmh.TransactionID  ");
        sb.Append("    AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID),0)DebitAmt, ");

        sb.Append("    pmh.ApprovalBy,IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus,pmh.Type,pmh.TransNo ");
        sb.Append("    FROM patient_medical_history pmh  ");
        sb.Append("     INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID`");
        sb.Append("    INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID where pmh.TransactionID <>'' and pmh.`CentreID` in ("+Centre+") ");
        if (txtIPDNo.Text == string.Empty)
        {
            if (txtFromDate.Text != string.Empty)
                sb.Append("and date(pmh.DateOfAdmit)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'");

            if (txtToDate.Text != string.Empty)
                sb.Append("and date(pmh.DateOfAdmit)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
        }
        else
            sb.Append(" AND pmh.TransactionID='" + Util.GetString(txtIPDNo.Text.Trim()) + "' ");
       

        sb.Append(" )t INNER JOIN patient_ipd_profile adpip ON adpip.PatientIPDProfile_ID = t.AdPatientIPDProfile_ID ");
        sb.Append("INNER JOIN patient_ipd_profile dipip ON dipip.PatientIPDProfile_ID = t.DisPatientIPDProfile_ID ");
        sb.Append("LEFT JOIN f_dispatch dis ON t.TransactionID = dis.TransactionID ");
        if (chkFinalBill.Checked)
            sb.Append("group by t.TransactionID ");
        if (rdoReportType.SelectedValue == "2")
            sb.Append(" Having OutStanding_After_BillDate > 0");
        if (rdoReportType.SelectedValue == "3")
            sb.Append(" Having OutStanding_After_BillDate < 0");
        dt = StockReports.GetDataTable(sb.ToString());

        if (chkcustomfieldApply.Checked == true)
        {
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
        }
        if (dt.Rows.Count > 0)
        {
            dt.Columns.Remove("CentreID");
            lblMsg.Text = "";
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "IPD Register";
            Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
            lblMsg.Text = "Record Not Found";
    }
}