using System;
using System.Data;
using System.Text;
public partial class Design_IPD_PatientFinalMsg : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
            }
            else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
            }
            if (Request.QueryString["msg"] != null)
            {
                string msg = Request.QueryString["msg"].ToString();
                lblMsg.Text = msg;
            }
            else
            {
                lblMsg.Text = "";
            }

            if (Request.QueryString["TransactionID"] != null)
            {
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            }
            else if (Request.QueryString["TID"] != null)
            {
                ViewState["TID"] = Request.QueryString["TID"].ToString();
            }

            LoadDetails(ViewState["TID"].ToString());
        }
    }

    private void LoadDetails(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" CALL GetIPDBillMsg(" + TID + ")");

        //sb.Append("SELECT REPLACE(MRNo,'LSHHI','')MRNo,REPLACE(t.TransactionID,'ISHHI','')IPNo,t.DateOfAdmit,t.TimeOfAdmit,t.DateOfDischarge,");
        //sb.Append("t.TimeOfDischarge,t.PName PatientName,Age,Gender,House_No AS Address,Locality,State,Country,Phone,Mobile,MaritalStatus,");
        //sb.Append("(SELECT NAME FROM Ipd_case_type_Master WHERE IPDCaseTypeID=adpip.IPDCaseTypeID LIMIT 1)AdmittedRoomType,");
        //sb.Append("(SELECT CONCAT(NAME,' ',Bed_No) FROM room_master WHERE RoomID=adpip.RoomID  LIMIT 1)AdmittedBedNo,");
        //sb.Append("(SELECT NAME FROM Ipd_case_type_Master WHERE IPDCaseTypeID=dipip.IPDCaseTypeID LIMIT 1)DischargedRoomType,");
        //sb.Append("(SELECT CONCAT(NAME,' ',Bed_No) FROM room_master WHERE RoomID=dipip.RoomID LIMIT 1)DischargedBedNo,");
        //sb.Append("(SELECT NAME FROM Ipd_case_type_Master WHERE IPDCaseTypeID=dipip.IPDCaseTypeID_Bill LIMIT 1)BillingRoomType,");
        //sb.Append("MainConsultant,SecondaryConsultant,AdmittedBy,Relation,RelationName,KinRelation,KinName,KinAddress,KinPhone,");
        //sb.Append("MLC_NO,Admission_Type,Source,Panel,ParentPanel,VulnerableType,CurStatus,t.Remarks,DischargeType,");
        //sb.Append("DischargedBy,AdmissionCancelDate,AdmissionCancelledBy,AdmissionCancelReason,DischargeCancelDate,");
        //sb.Append("DischargedCancelledBy,DischargeCancelReason,BillNoCancelled,BillDateOfBillNoCancelled,BillCancellationDate,");
        //sb.Append("BillCancelUserID,t.BillNo,t.BillDate,BillGeneratedBy,Round(TotalBilledAmt)TotalBilledAmt,Round(DiscountOnBill)DiscountOnBill,");
        //sb.Append("Round(ItemWiseDiscount)ItemWiseDiscount,Round(ItemWiseDiscount+DiscountOnBill)TotalDiscount,");
        //sb.Append("Round((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetAmount,Round(ReceiveAmt)ReceiveAmt,");
        
        //sb.Append("TDS,Deduction_Acceptable,Deduction_NonAcceptable,DeductionReason,WriteOff,WriteOffRemarks,DebitAmt,CreditAmt,");
        //sb.Append("Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+Deduction_Acceptable+ReceiveAmt+TDS+WriteOff)-CreditAmt+DebitAmt+ ServiceTaxAmt+ServiceTaxSurChgAmt) As OutStanding_After_BillDate,");

        //sb.Append("ClaimNo,t.PolicyNo,t.CardNo,t.CardHolderName,t.RelationWith_holder,FileNo,PanelAppRemarks,PanelApprovedAmt,PanelApprovalDate,");
        //sb.Append("DiscountOnBillReason,BillingRemarks,t.ApprovalBy DiscApprovedBy,BillingStatus,");
        //sb.Append("BillFinalisedBy,BillFinalisedDate,MedClearBy,MedClearDate,");
        //sb.Append("DATE_FORMAT(dis.DispatchDate,'%d-%b-%y')DispatchDate,");
        //sb.Append("dis.DocketNo,dis.Remarks DispatchRemarks,dis.CourierComp ");
        //sb.Append("FROM (");
        //sb.Append("    SELECT pm.PatientID MRNo,pm.Title,pm.PName,pm.House_No,pm.Street_Name,pm.Locality,pm.City,");
        //sb.Append("    pm.State,pm.Country,pm.Phone,pm.Mobile,pm.Age,pm.Relation,pm.RelationName,pm.Gender,pm.MaritalStatus,");
        //sb.Append("    pmh.TransactionID,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,ich.TimeOfAdmit,");
        //sb.Append("    DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%y')DateOfDischarge,ich.TimeOfDischarge,");
        //sb.Append("    (SELECT NAME FROM employee_master WHERE employee_ID=pmh.UserID)AdmittedBy,");
        //sb.Append("    (SELECT NAME FROM Doctor_master WHERE DoctorID=pmh.DoctorID)MainConsultant,");
        //sb.Append("    (SELECT NAME FROM Doctor_master WHERE DoctorID=pmh.DoctorID1)SecondaryConsultant,");
        //sb.Append("    (SELECT MIN(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID)AdPatientIPDProfile_ID,");
        //sb.Append("    (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID)DisPatientIPDProfile_ID,");
        //sb.Append("    pmh.KinName,pmh.KinRelation,pmh.KinAddress,pmh.KinPhone,pmh.MLC_NO,pmh.Admission_Type,pmh.Source,");

        //sb.Append("    (SELECT Company_Name FROM f_panel_master WHERE PanelID= pmh.PanelID)Panel,");
        //sb.Append("    (SELECT Company_Name FROM f_panel_master WHERE ParentID= pmh.PanelID)ParentPanel,");
        //sb.Append("    pmh.VulnerableType,UCASE(ich.Status)CurStatus,PMH.Remarks,pmh.DischargeType,");
        //sb.Append("    (SELECT NAME FROM employee_master WHERE employee_ID=ich.DischargedBy)DischargedBy,");
        //sb.Append("    DATE_FORMAT(ich.AdmissionCancelDate,'%d-%b-%y')AdmissionCancelDate,");
        //sb.Append("    (SELECT NAME FROM employee_master WHERE employee_ID=ich.AdmissionCancelledBy)AdmissionCancelledBy,");
        //sb.Append("    AdmissionCancelReason,DATE_FORMAT(ich.DischargeCancelDate,'%d-%b-%y')DischargeCancelDate,");
        //sb.Append("    (SELECT NAME FROM employee_master WHERE employee_ID=ich.DischargedCancelledBy)DischargedCancelledBy,");
        //sb.Append("    DischargeCancelReason,");
        //sb.Append("    (SELECT BillNo FROM f_billcancellation WHERE TransactionID=pmh.TransactionID LIMIT 1)BillNoCancelled,");
        //sb.Append("    (SELECT DATE_FORMAT(BillDate,'%d-%b-%y') FROM f_billcancellation WHERE TransactionID=pmh.TransactionID  LIMIT 1)BillDateOfBillNoCancelled,");
        //sb.Append("    (SELECT DATE_FORMAT(CancelDate,'%d-%b-%y') FROM f_billcancellation WHERE TransactionID=pmh.TransactionID  LIMIT 1)BillCancellationDate,");
        //sb.Append("    (SELECT NAME FROM employee_master WHERE employee_ID=(SELECT CancelUserID FROM f_billcancellation ");
        //sb.Append("    WHERE TransactionID=pmh.TransactionID ORDER BY BillCancel_ID DESC LIMIT 1))BillCancelUserID,pmh.BillNo,");
        //sb.Append("    IF(Date(pmh.BillDate)='0001-01-01','',DATE_FORMAT(pmh.BillDate,'%d-%b-%y'))Billdate,");
        //sb.Append("    IF(UCASE(ich.Status)<>'CANCEL',");
        //sb.Append("    (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ");
        //sb.Append("    WHERE TransactionID = pmh.TransactionID AND IsVerified = 1 AND IsPackage = 0 ");
        //sb.Append("    GROUP BY TransactionID),0)TotalBilledAmt,IFNULL(pmh.DiscountOnBill,0)DiscountOnBill,");

        ////ReceiveAmt_AsOn_BillDate,");
        //sb.Append("    IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =pmh.TransactionID ");
        //sb.Append("    AND IsCancel = 0 GROUP BY TransactionID),0)ReceiveAmt,");
        
        //sb.Append("    IF(UCASE(ich.Status)<>'CANCEL',IFNULL((SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail ");
        //sb.Append("    WHERE TransactionID = pmh.TransactionID AND IsVerified = 1 AND IsPackage = 0 ");
        //sb.Append("    GROUP BY TransactionID),0),0)ItemWiseDiscount, ");
        //sb.Append("    (SELECT NAME FROM employee_master WHERE employee_ID=pmh.UserID)BillGeneratedBy,ifnull(pmh.TDS,0)TDS,");
       
        //sb.Append("    IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,");
        //sb.Append("    pmh.DeductionReason,IFNULL(pmh.WriteOff,0)WriteOff,pmh.WriteOffRemarks,pmh.ServiceTaxAmt,pmh.ServiceTaxSurChgAmt,");
        //sb.Append("    pmh.ClaimNo,pmh.PolicyNo,pmh.CardNo,pmh.CardHolderName,pmh.RelationWith_holder,pmh.FileNo,");
        //sb.Append("    pmh.PanelAppRemarks,pmh.PanelApprovedAmt,");
        //sb.Append("    IF(PanelApprovalDate='0001-01-01','',DATE_FORMAT(PanelApprovalDate,'%d-%b-%y'))PanelApprovalDate,");
        //sb.Append("    pmh.DiscountOnBillReason,pmh.BillingRemarks,");

        //sb.Append("    IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=pmh.TransactionID  ");
        //sb.Append("    AND CRDR='CR01' AND cancel=0  GROUP BY TransactionID),0)CreditAmt, ");
        //sb.Append("    IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=pmh.TransactionID  ");
        //sb.Append("    AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID),0)DebitAmt, ");

        //sb.Append("    pmh.ApprovalBy,IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus, ");
        //sb.Append("    (SELECT Name from employee_master where Employee_ID=pmh.BillClosedUserId)BillFinalisedBy,");
        //sb.Append("    CONCAT(DATE_FORMAT(pmh.BillCloseddate,'%d-%b-%y'),' ',TIME_FORMAT(BillCloseddate,'%H:%i:%s'))BillFinalisedDate,");
        //sb.Append("    (SELECT Name from employee_master where Employee_ID=pmh.MedClearedBy and pmh.IsMedCleared=1)MedClearBy,");
        //sb.Append("    CONCAT(DATE_FORMAT(pmh.MedClearedDate,'%d-%b-%y'),' ',TIME_FORMAT(MedClearedDate,'%H:%i:%s'))MedClearDate ");

        //sb.Append("    FROM patient_medical_history pmh INNER JOIN ipd_case_history ich ON pmh.TransactionID = ich.TransactionID ");
        //sb.Append("   ");
        //sb.Append("    INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID where pmh.TransactionID ='" + TID + "' ");
        //sb.Append(")t INNER JOIN patient_ipd_profile adpip ON adpip.PatientIPDProfile_ID = t.AdPatientIPDProfile_ID ");
        //sb.Append("INNER JOIN patient_ipd_profile dipip ON dipip.PatientIPDProfile_ID = t.DisPatientIPDProfile_ID ");
        //sb.Append("LEFT JOIN f_dispatch dis ON t.TransactionID = dis.TransactionID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            BindPatientDetails(dt);           
        }
    }

    private void BindPatientDetails(DataTable dt)
    {
        lblPname.Text = dt.Rows[0]["PatientName"].ToString();
        lblPID.Text = dt.Rows[0]["MRNo"].ToString();
        lblTID.Text = dt.Rows[0]["IPNo"].ToString();
        lblAgeSex.Text = dt.Rows[0]["Age"].ToString() + " / " + dt.Rows[0]["Gender"].ToString();
        lblAddress.Text = dt.Rows[0]["Address"].ToString() + " " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["State"].ToString() + " " + dt.Rows[0]["Country"].ToString() ;
        lblMobile.Text = dt.Rows[0]["Mobile"].ToString();
        lblRelation.Text = dt.Rows[0]["Relation"].ToString() + "&nbsp;:&nbsp;";
        lblRelationOf.Text = dt.Rows[0]["RelationName"].ToString();   
        StringBuilder sb=new StringBuilder();                
        //==========Admission Details ===========================
        sb.Append("<div class='POuter_Box_Inventory'>");
        sb.Append("     <div class='Purchaseheader'>Admission Details</div>");
        sb.Append("     <div class='content' style='text-align: center;'>");        
        sb.Append("         <table border='0' cellpadding='0' cellspacing='0' style='width: 100%'>");
        sb.Append("             <tr>");//DateOfAdmit/AdmittedBy
        sb.Append("                 <td style='width: 20%' align='right'>Admission Date :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DateOfAdmit"].ToString() + " " + dt.Rows[0]["TimeOfAdmit"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Admitted By :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["AdmittedBy"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//RoomType/BedNo
        sb.Append("                 <td style='width: 20%' align='right'>Room Type :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["AdmittedRoomType"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right' >Bed No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["AdmittedBedNo"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//Main Consultant / Secondary Consultant
        sb.Append("                 <td style='width: 20%' align='right'>Main Doctor :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["MainConsultant"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Sec. Doctor :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["SecondaryConsultant"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//Admission_Type
        sb.Append("                 <td style='width: 20%' align='right'>Admission Type :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["Admission_Type"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Source :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["Source"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//Diagnosis / MLC_NO
        sb.Append("                 <td style='width: 20%' align='right'>MLC No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["MLC_NO"].ToString() + " </td>");
        sb.Append("             </tr>");

        // IF Admission Cancelled
        if (dt.Rows[0]["AdmissionCancelledBy"].ToString() != "")
        {
            sb.Append("             <tr>");//Admission Cancel Date / Admission Cancelled By
            sb.Append("                 <td style='width: 20%' align='right'>Admission Cancel Date :&nbsp;</td>");
            sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["AdmissionCancelDate"].ToString() + " </td>");
            sb.Append("                 <td style='width: 20%' align='right'>Admission Cancelled By :&nbsp;</td>");
            sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["AdmissionCancelledBy"].ToString() + " </td>");
            sb.Append("             </tr>");

            sb.Append("             <tr>");//Admission Cancel Reason
            sb.Append("                 <td style='width: 20%' align='right'>Admission Cancel Reason :&nbsp;</td>");
            sb.Append("                 <td style='width: 85%' align='left' colspan='3' Class='ItDoseLabelSp'>" + dt.Rows[0]["AdmissionCancelReason"].ToString() + " </td>");            
            sb.Append("             </tr>");
        }

        sb.Append("         </table>");
        sb.Append("     </div>");
        sb.Append("</div>");


        //==========Discharge Details ===========================
        sb.Append("<div class='POuter_Box_Inventory'>");
        sb.Append("     <div class='Purchaseheader'>Discharge Details</div>");
        sb.Append("     <div class='content' style='text-align: center;'>");
        sb.Append("         <table border='0' cellpadding='0' cellspacing='0' style='width: 100%'>");
        sb.Append("             <tr>");//DateOfAdmit/DischargeBy
        sb.Append("                 <td style='width: 20%' align='right'>Discharge Date :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DateOfDischarge"].ToString() + " " + dt.Rows[0]["TimeOfDischarge"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Discharge By :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargedBy"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//RoomType/BedNo
        sb.Append("                 <td style='width: 20%' align='right'>Room Type :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargedRoomType"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Bed No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargedBedNo"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//DischargeType
        sb.Append("                 <td style='width: 20%' align='right'>Discharge Type :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargeType"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Billing Category :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["BillingRoomType"].ToString() + " </td>");
        sb.Append("             </tr>");


        // IF Discharge Details
        if (dt.Rows[0]["DischargedCancelledBy"].ToString() != "")
        {
            sb.Append("             <tr>");//Discharge Cancel Date / Discharge Cancelled By
            sb.Append("                 <td style='width: 20%' align='right'>Discharge Cancel Date :&nbsp;</td>");
            sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargeCancelDate"].ToString() + " </td>");
            sb.Append("                 <td style='width: 20%' align='right'>Discharge CancelledBy :&nbsp;</td>");
            sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargedCancelledBy"].ToString() + " </td>");
            sb.Append("             </tr>");

            sb.Append("             <tr>");//Discharge Cancel Reason
            sb.Append("                 <td style='width: 20%' align='right'>Discharge Cancel Reason :&nbsp;</td>");
            sb.Append("                 <td style='width: 85%' align='left' colspan='3' Class='ItDoseLabelSp'>" + dt.Rows[0]["DischargeCancelReason"].ToString() + " </td>");
            sb.Append("             </tr>");
        }

        sb.Append("         </table>");
        sb.Append("     </div>");
        sb.Append("</div>");

        //==========Panel Details ===========================
        sb.Append("<div class='POuter_Box_Inventory'>");
        sb.Append("     <div class='Purchaseheader'>Panel Details</div>");
        sb.Append("     <div class='content' style='text-align: center;'>");
        sb.Append("         <table border='0' cellpadding='0' cellspacing='0' style='width: 100%'>");
        sb.Append("             <tr>");//Panel/ParentPanel
        sb.Append("                 <td style='width: 20%' align='right'>Panel :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["Panel"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Parent Panel :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["ParentPanel"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//ClaimNo / PolicyNo
        sb.Append("                 <td style='width: 20%' align='right'>Claim No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["ClaimNo"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Policy No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["PolicyNo"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//CardNo/CardHolderName/RelationWith_holder
        sb.Append("                 <td style='width: 20%' align='right'>Card No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["CardNo"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Card Holder Name :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["CardHolderName"].ToString() + " (" + dt.Rows[0]["RelationWith_holder"].ToString() + ") </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//FileNo / PanelApprovedAmt
        sb.Append("                 <td style='width: 20%' align='right'>File No. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["FileNo"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Panel Approved Amt. :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["PanelApprovedAmt"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("             <tr>");//PanelApprovalDate / PanelAppRemarks
        sb.Append("                 <td style='width: 20%' align='right'>Panel Approval Date :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["PanelApprovalDate"].ToString() + " </td>");
        sb.Append("                 <td style='width: 20%' align='right'>Panel Approval Remarks :&nbsp;</td>");
        sb.Append("                 <td style='width: 30%' align='left' Class='ItDoseLabelSp'>" + dt.Rows[0]["PanelAppRemarks"].ToString() + " </td>");
        sb.Append("             </tr>");
        sb.Append("         </table>");
        sb.Append("     </div>");
        sb.Append("</div>");

        //==========Billing Details ===========================
        //sb.Append("<div class='POuter_Box_Inventory'>");
        //sb.Append("     <div class='Purchaseheader'>Billing Details</div>");
        //sb.Append("     <div class='content' style='text-align: center;'>");
        //sb.Append("         <table border='0' cellpadding='0' cellspacing='0' style='width: 100%'>");
        //sb.Append("             <tr>");//MedClearBy / MedClearDate
        //sb.Append("                 <td style='width: 20%' align='right'>Med.Clear By :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["MedClearBy"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>MedClearDate :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["MedClearDate"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//BillNo/BillDate
        //sb.Append("                 <td style='width: 20%' align='right'>Bill No. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillNo"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Bill Date :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillDate"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//BillGeneratedBy / BillingStatus
        //sb.Append("                 <td style='width: 20%' align='right'>Bill Generated By :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillGeneratedBy"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>BillingStatus :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillingStatus"].ToString() + " </td>");
        //sb.Append("             </tr>");        
        //sb.Append("             <tr>");//BillFinalisedBy / BillFinalisedDate
        //sb.Append("                 <td style='width: 20%' align='right'>Bill Finalized By :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillFinalisedBy"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Bill Finalized Date :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillFinalisedDate"].ToString() + " </td>");
        //sb.Append("             </tr>");        

        //sb.Append("             <tr>");//TotalBilledAmt / TotalDiscount
        //sb.Append("                 <td style='width: 20%' align='right'>Total Billed Amt. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["TotalBilledAmt"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Total Discount :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["TotalDiscount"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//NetAmount / ReceiveAmt
        //sb.Append("                 <td style='width: 20%' align='right'>Net Amount :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["NetAmount"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Receive Amt. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["ReceiveAmt"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//TDS / Deduction_Acceptable
        //sb.Append("                 <td style='width: 20%' align='right'>TDS :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["TDS"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Deduction Acceptable :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["Deduction_Acceptable"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//Deduction_NonAcceptable / DeductionReason
        //sb.Append("                 <td style='width: 20%' align='right'>Deduction_NonAcceptable :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["Deduction_NonAcceptable"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>DeductionReason :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["DeductionReason"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//WriteOff / WriteOffRemarks
        //sb.Append("                 <td style='width: 20%' align='right'>WriteOff :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["WriteOff"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>WriteOffRemarks :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["WriteOffRemarks"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//DebitAmt / CreditAmt
        //sb.Append("                 <td style='width: 20%' align='right'>Debit Amt. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["DebitAmt"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Credit Amt. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["CreditAmt"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//OutStanding_After_BillDate / DiscountOnBillReason
        //sb.Append("                 <td style='width: 20%' align='right'>OutStanding :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["OutStanding_After_BillDate"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Discount On Bill Reason :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["DiscountOnBillReason"].ToString() + " </td>");
        //sb.Append("             </tr>");

        // IF Bill Cancelled
        //if (dt.Rows[0]["BillCancelUserID"].ToString() != "")
        //{
        //    sb.Append("             <tr>");//Admission Cancel Date / Admission Cancelled By
        //    sb.Append("                 <td style='width: 20%' align='right'>Bill Cancellation Date :&nbsp;</td>");
        //    sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillCancellationDate"].ToString() + " </td>");
        //    sb.Append("                 <td style='width: 20%' align='right'>Bill Cancelled By :&nbsp;</td>");
        //    sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillCancelUserID"].ToString() + " </td>");
        //    sb.Append("             </tr>");

        //    sb.Append("             <tr>");//BillNoCancelled / BillDateOfBillNoCancelled
        //    sb.Append("                 <td style='width: 20%' align='right'>Bill No. Cancelled :&nbsp;</td>");
        //    sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillNoCancelled"].ToString() + " </td>");
        //    sb.Append("                 <td style='width: 20%' align='right'>Bill No. Cancelled :&nbsp;</td>");
        //    sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["BillDateOfBillNoCancelled"].ToString() + " </td>");
        //    sb.Append("             </tr>");
        //}

        //sb.Append("         </table>");
        //sb.Append("     </div>");
        //sb.Append("</div>");

        //==========Dispatch Details ===========================
        //sb.Append("<div class='POuter_Box_Inventory'>");
        //sb.Append("     <div class='Purchaseheader'>Dispatch Details</div>");
        //sb.Append("     <div class='content' style='text-align: center;'>");
        //sb.Append("         <table border='0' cellpadding='0' cellspacing='0' style='width: 100%'>");
        //sb.Append("             <tr>");//DispatchDate/DocketNo
        //sb.Append("                 <td style='width: 20%' align='right'>Dispatch Date :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["DispatchDate"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Docket No. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["DocketNo"].ToString() + " </td>");
        //sb.Append("             </tr>");
        //sb.Append("             <tr>");//CourierComp / DispatchRemarks
        //sb.Append("                 <td style='width: 20%' align='right'>Courier Comp. :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["CourierComp"].ToString() + " </td>");
        //sb.Append("                 <td style='width: 20%' align='right'>Dispatch Remarks :&nbsp;</td>");
        //sb.Append("                 <td style='width: 30%' align='left'>" + dt.Rows[0]["DispatchRemarks"].ToString() + " </td>");
        //sb.Append("             </tr>");        
        //sb.Append("         </table>");
        //sb.Append("     </div>");
        //sb.Append("</div>");

        

        lblDetails.Text = sb.ToString();
    }

   
   
}
