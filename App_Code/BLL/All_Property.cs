

using System;
using System.Collections.Generic;
public class All_Property
{

}

public class OPDBillGenerate
{
    public string DoctorID { get; set; }
    public string ItemID { get; set; }
    public string SubCategoryID { get; set; }
    public string ItemName { get; set; }
    public string ScheduleChargeID { get; set; }
    public decimal Amount { get; set; }
    public string UniqueHash { get; set; }
    public decimal PanelDisPer { get; set; }
    public decimal DoctorRate { get; set; }
    public decimal OPDPanelCreditLimit { get; set; }
    public string OPDCreditLimitType { get; set; }
}
public class OpdDiscount
{
    public decimal netAmount { get; set; }
    public string DiscountReason { get; set; }
    public string DiscountApproveBy { get; set; }
    public decimal DiscountOnTotal { get; set; }
    public decimal RoundOff { get; set; }
    public decimal Adjustment { get; set; }
    public int PaymentModeID { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal DiscountPercentage { get; set; }
    public decimal Amount { get; set; }
}
public class smsTemplateInfo
{
    public string PName { get; set; }
    public string PatientID { get; set; }
    public int AppNo { get; set; }
    public string Age { get; set; }
    public string TransactionID { get; set; }
    public string Gender { get; set; }
    public string LedgertransactionNo { get; set; }
    public string ContactNo { get; set; }
    public string DoctorID { get; set; }
    public string DoctorName { get; set; }
    public int TemplateID { get; set; }
    public string Title { get; set; }
    public string AppDate { get; set; }
    public string InvestigationName { get; set; }
    public string FromDepartment { get; set; }
    public string ErrorType { get; set; }
    public string Priority { get; set; }
    public string RoomNo { get; set; }
    public string BedNo { get; set; }
    public string PanelName { get; set; }
    public string AdmDate { get; set; }
    public string Ward { get; set; }
    public string IPDNO { get; set; }
    public string Amount { get; set; }
    public string AppointmentDate { get; set; }
    public string AppointmentTime { get; set; }
    public string EmailAddress { get; set; }
    public string FromWard { get; set; }

}
public class TaxCalculation_DirectGRN
{
    public decimal Rate { get; set; }
    public decimal Quantity { get; set; }
    public decimal MRP { get; set; }
    public decimal TaxPer { get; set; }
    public decimal DiscPer { get; set; }
    public string Type { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal ExcisePer { get; set; }
    public decimal deal { get; set; }
    public decimal deal2 { get; set; }
    public decimal ActualRate { get; set; }
    //gst
    public decimal CGSTPercent { get; set; }
    public decimal IGSTPrecent { get; set; }
    public decimal SGSTPercent { get; set; }
    public decimal SpecialDiscPer { get; set; }
    public decimal SpecialDiscAmt { get; set; }
}
public class FormatDetail
{
    public string Typename { get; set; }
    public string InitialChar { get; set; }
    public string FinYear { get; set; }
    public string Separator1 { get; set; }
    public string Separator2 { get; set; }
    public int Length { get; set; }
    public string FormatPreview { get; set; }
    public int chkFinancialYear { get; set; }
    public int formatID { get; set; }
    public int CentreID { get; set; }

}
public class Package
{
    public string PackageID { get; set; }
    public string PackageName { get; set; }
    public string ItemCode { get; set; }
    public string Active { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }


}
public class PackageItemDetail
{
    public string ItemID { get; set; }
    public string SubCategoryID { get; set; }
    public string InvestigationID { get; set; }
    public string ItemName { get; set; }
    public int Quantity { get; set; }
}

public class PackageDoctorVisti
{
    public string SubCategoryID { get; set; }
    public string DocDepartmentID { get; set; }
    public string DoctorID { get; set; }
}
public class bankMaster
{
    public string BankName { get; set; }
    public int IsActive { get; set; }
    public string BankID { get; set; }
    public string IsMobileApp { get; set; }
    public string BankCutPer { get; set; }
}
public class ApprovalTypeMaster
{
    public string ApprovalType { get; set; }
    public int IsActive { get; set; }
    public string ID { get; set; }

}
public class RightUpdate
{
    public string MasterId { get; set; }
    public int RoleID { get; set; }
    public string Employee_ID { get; set; }

}
public class FileRole
{
    public int UrlID { get; set; }
    public int SNo { get; set; }
}
public class MenuData
{
    public int RoleID { get; set; }
    public int MenuID { get; set; }
    public int SNo { get; set; }
}
public class Role
{
    public string URLId { get; set; }
    public int RoleID { get; set; }


}
public class InsertRole
{
    public string MasterId { get; set; }
    public int RoleID { get; set; }
    public string Employee_ID { get; set; }

}
public class FrameData
{
    public string FrameName { get; set; }
    public string FileName { get; set; }
    public string URL { get; set; }
    public string Description { get; set; }
    public int FrameID { get; set; } 
    public string MenuHeader { get; set; }


}
public class FrameRole
{
    public string URLId { get; set; }
    public int RoleID { get; set; }
    public int SequenceNo { get; set; }

}
public class Sequence
{
    public int SequenceNo { get; set; }
    public int RoleID { get; set; }
    public int URLId { get; set; }


}
public class ClinicalInvestigationNew
{
    public string ClinicalID { get; set; }
    public string Name { get; set; }
    public string ClinicalNameCon { get; set; }
    public string TID { get; set; }
    public string PID { get; set; }
    public string ClinicalText { get; set; }
}
public class BodySystem
{
    public string TID { get; set; }
    public string PID { get; set; }
    public string BodySystemID { get; set; }
    public string BodySystemCon { get; set; }
    public string BodySystemText { get; set; }
    public string CommentSystem { get; set; }

}
public class Vaccination
{
    public string VaccinationID { get; set; }
    public string VaccinationName { get; set; }
    public string VaccinationNameCon { get; set; }
    public string TID { get; set; }
    public string PID { get; set; }
    public string VaccinationDate { get; set; }
}
public class Labinsert
{
    public string ItemID { get; set; }
    public string Quantity { get; set; }
    public string TID { get; set; }
    public string PID { get; set; }
    public string Doc { get; set; }
    public string Remarks { get; set; }
    public string LnxNo { get; set; }
    public int IsUrgent { get; set; }

}
public class MedHistory
{
    public string TID { get; set; }
    public string PID { get; set; }
    public string CurrentHistoryID { get; set; }
    public string CurrentHistory { get; set; }
    public string CurrentHistoryText { get; set; }
    public string OtherProblem { get; set; }
    public string PreviousHospitalizations { get; set; }
    public string AllergiesMed { get; set; }
    public string MedicationAllergies { get; set; }
    public string FoodAllergies { get; set; }
    public string OtherAllergies { get; set; }
    public string MedicationHistory { get; set; }

}
public class docVisitDetail
{
    public string nextSubcategoryID { get; set; }
    public string docValidityPeriod { get; set; }
    public string nextVisitDateMax { get; set; }
    public string nextVisitDateMin { get; set; }
    public string lastVisitDateMax { get; set; }
    public string docVisitGroup { get; set; }
}
public class OutSourceLab
{
    public string Name { get; set; }
    public string Address { get; set; }
    public string ContactPerson { get; set; }
    public string MobileNo { get; set; }
    public string CreatedBy { get; set; }
    public int OutsourceLabID { get; set; }
    public int Active { get; set; }
}
public class PanelWiseDisc
{
    public int PanelID { get; set; }
    public string ItemID { get; set; }
    public string SubCategoryID { get; set; }
    public decimal Percentage { get; set; }
    public string CreatedBy { get; set; }
    public int IsActive { get; set; }
    public int IsPayable { get; set; }
}
[Serializable()]
public class PharmacyBulkSettlement
{

    public string LedgertransactionNo { get; set; }
    public string TransactionID { get; set; }
    public string PaidBy { get; set; }
    public string TypeOfTnx { get; set; }
    public string IsOTCollection { get; set; }
    public decimal RoundOff { get; set; }
    public decimal AmountPaid { get; set; }
    public int PanelID { get; set; }
    public string Receipt_No { get; set; }
}
public class SearchCateria
{
    public string PatientId { get; set; }
    public string PatientName { get; set; }
    public string AgeFrom { get; set; }
    public string AgeTo { get; set; }
    public string DischargeType { get; set; }
    public string RoomType { get; set; }
    public string DoctorId { get; set; }
    public string TransactionId { get; set; }
    public string parentPanelId { get; set; }
    public string PanelId { get; set; }
    public string FromDate { get; set; }
    public string Todate { get; set; }
    public string DeptId { get; set; }
    public string FileType { get; set; }

}
public class IDCardDetail
{
    public string IdCardId { get; set; }
    public string CardNumber { get; set; }
    public string CardName { get; set; }
}
public class IDProof
{
    public string IDProofID { get; set; }
    public string IDProofName { get; set; }
    public string IDProofNumber { get; set; }
}
public class PurchaseOrder
{
    public decimal Rate { get; set; }
    public decimal Quantity { get; set; }
    public decimal MRP { get; set; }
    public decimal GSTPer { get; set; }
    public decimal GSTAmt { get; set; }
    public decimal DiscPer { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal CGSTPercent { get; set; }
    public decimal IGSTPercent { get; set; }
    public decimal SGSTPercent { get; set; }
    public string TaxCalOn { get; set; }
    public string GSTType { get; set; }
    public string HSNCode { get; set; }
    public string Vendor_ID { get; set; }
    public string ItemID { get; set; }
    public string SubCategoryID { get; set; }
    public string PurchaseUnit { get; set; }
    public string StoreType { get; set; }
    public string ConversionFactor { get; set; }
    public string ManufactureID { get; set; }
    public string TaxID { get; set; }
    public int IsRateSet { get; set; }
    public decimal TotalAmount { get; set; }
}

//Direct GRN Work

public class DuplicateEmailTemplateInfo //
{
    public string PName { get; set; }
    public string PatientID { get; set; }
    public int? AppNo { get; set; }
    public string Age { get; set; }
    public int TransactionID { get; set; }//
    public string Gender { get; set; }
    public string LedgertransactionNo { get; set; }
    public string ContactNo { get; set; }
    public int DoctorID { get; set; }//
    public string DoctorName { get; set; }
    public int? TemplateID { get; set; }
    public string Title { get; set; }
    public string AppDate { get; set; }
    public string InvestigationName { get; set; }
    public string FromDepartment { get; set; }
    public string ErrorType { get; set; }
    public string Priority { get; set; }
    public string RoomNo { get; set; }
    public int BedNo { get; set; }//
    public string PanelName { get; set; }
    public string EmployeeName { get; set; }
    public string RoomType { get; set; }
    public string Date { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }
    public string BillNo { get; set; }
    public string ReceiptNo { get; set; }
    public string BillAmount { get; set; }
    public string BalanceAmount { get; set; }
    public string PaidAmount { get; set; }
    public int IPNo { get; set; }//
    public string EmailTo { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public string Discount { get; set; }
    public string SUBJECT { get; set; }
    public string MRNo { get; set; }
    public string IPDNo { get; set; }
    public string ApprovalAmount { get; set; }
    public string NICNumber { get; set; }
    public string PolicyNumber { get; set; }
    public string PolicyCardNumber { get; set; }
    public string PolicyExpiryDate { get; set; }
    public string AppointmentDate { get; set; }
    public string AppointmentTime { get; set; }
    public string EmailAddress { get; set; }
    public string AdmissionDate { get; set; }
    public string AdditionalEmailBody { get; set; }
}

public class EmailTemplateInfo
{
    public string PName { get; set; }
    public string PatientID { get; set; }
    public int? AppNo { get; set; }
    public string Age { get; set; }
    public string TransactionID { get; set; }
    public string Gender { get; set; }
    public string LedgertransactionNo { get; set; }
    public string ContactNo { get; set; }
    public string DoctorID { get; set; }
    public string DoctorName { get; set; }
    public int? TemplateID { get; set; }
    public string Title { get; set; }
    public string AppDate { get; set; }
    public string InvestigationName { get; set; }
    public string FromDepartment { get; set; }
    public string ErrorType { get; set; }
    public string Priority { get; set; }
    public string RoomNo { get; set; }
    public string BedNo { get; set; }
    public string PanelName { get; set; }
    public string EmployeeName { get; set; }
    public string RoomType { get; set; }
    public string Date { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }
    public string BillNo { get; set; }
    public string ReceiptNo { get; set; }
    public string BillAmount { get; set; }
    public string BalanceAmount { get; set; }
    public string PaidAmount { get; set; }
    public string IPNo { get; set; }
    public string EmailTo { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public string Discount { get; set; }
    public string SUBJECT { get; set; }
    public string MRNo { get; set; }
    public string IPDNo { get; set; }
    public string ApprovalAmount { get; set; }
    public string NICNumber { get; set; }
    public string PolicyNumber { get; set; }
    public string PolicyCardNumber { get; set; }
    public string PolicyExpiryDate { get; set; }
    public string AppointmentDate { get; set; }
    public string AppointmentTime { get; set; }
    public string EmailAddress { get; set; }
    public string AdmissionDate { get; set; }
    public string AdditionalEmailBody { get; set; }
    public string DOB { get; set; }
    public string SupplierName { get; set; }
    public string PurchaseOrderNo { get; set; }
    public string PageCallPath { get; set; }
}
//
public class DirectGRNItemDetails
{
    public string DeptLedgerNo { get; set; }
    public string StockID { get; set; }
    public string Hospital_ID { get; set; }
    public string ItemID { get; set; }
    public string ItemName { get; set; }
    public string LedgerTransactionNo { get; set; }
    public string BatchNumber { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal MRP { get; set; }
    public decimal Quantity { get; set; }
    public int IsReturn { get; set; }
    public DateTime MedExpiryDate { get; set; }
    public string StoreLedgerNo { get; set; }
    public string Naration { get; set; }
    public int IsFree { get; set; }
    public string SubCategoryID { get; set; }
    public decimal Rate { get; set; }
    public decimal DiscPer { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal PurTaxPer { get; set; }
    public decimal PurTaxAmt { get; set; }
    public decimal SaleTaxPer { get; set; }    
    public string MajorUnit { get; set; }
    public string MinorUnit { get; set; }
    public decimal ConversionFactor { get; set; }
    public decimal MajorMRP { get; set; }
    public string taxCalculateOn { get; set; }
    public string TypeOfTnx { get; set; }
    public string InvoiceNo { get; set; }
    public string ChalanNo { get; set; }
    public DateTime InvoiceDate { get; set; }
    public DateTime ChalanDate { get; set; }
    public string VenLedgerNo { get; set; }
    public string LedgerTnxNo { get; set; }
    public decimal InvoiceAmount { get; set; }
    public int CentreID { get; set; }
    public string IpAddress { get; set; }
    public int IsExpirable { get; set; }
    public string isDeal { get; set; }
    public string HSNCode { get; set; }
    public string GSTType { get; set; }
    public decimal IGSTPercent { get; set; }
    public decimal IGSTAmt { get; set; }
    public decimal SGSTPercent { get; set; }
    public decimal SGSTAmt { get; set; }
    public decimal CGSTPercent { get; set; }
    public decimal CGSTAmt { get; set; }
    public virtual decimal SpecialDiscPer { get; set; }
    public virtual decimal SpecialDiscAmt { get; set; }
    public virtual string RetrunFromGRN { get; set; }
    public virtual string RetrunFromInvoiceNo { get; set; }
    public virtual decimal ItemGrossAmount { get; set; }
    public virtual decimal ItemNetAmount { get; set; }
    public virtual decimal IsUpdateCF { get; set; }
    public virtual decimal IsUpdateHSNCode { get; set; }
    public virtual decimal IsUpdateGST { get; set; }
    public virtual decimal IsUpdateExpirable { get; set; }

    //Asset
    public virtual DateTime AssetPurDate { get; set; }
    public virtual string SerialNo { get; set; }
    public virtual string ModelNo { get; set; }
    public virtual string AssetTagNo { get; set; }
    public virtual DateTime InstDate { get; set; }
    public virtual DateTime ServiceFrom { get; set; }
    public virtual DateTime ServiceTo { get; set; }
    public virtual string WarrantyNo { get; set; }
    public virtual DateTime WarrantyDate { get; set; }
    public virtual DateTime WarrantyFrom { get; set; }
    public virtual DateTime WarrantyTo { get; set; }
    public virtual string PODID { get; set; }
    //Asset End

    public decimal markUpPercent { get; set; }
    public decimal otherCharges { get; set; }
    public int purchaseOrderDetailID { get; set; }

    public int ID { get; set; }

}
public class DirectGRNInvoiceDetails
{
    public string InvoiceNo { get; set; }
    public string ChalanNo { get; set; }
    public DateTime InvoiceDate { get; set; }
    public DateTime ChalanDate { get; set; }
    public string VenLedgerNo { get; set; }
    public string WayBillNo { get; set; }
    public DateTime WayBillDate { get; set; }
    public decimal GrossBillAmount { get; set; }
    public decimal NetAmount { get; set; }
    public decimal RoundOff { get; set; }
    public decimal DiscAmount { get; set; }
    public string GatePassIn { get; set; }
    public string StoreLedgerNo { get; set; }
    public int PaymentModeID { get; set; }
    public string PONumber { get; set; }
    public decimal otherCharges { get; set; }
    public int currencyCountryID { get; set; }
    public string currency { get; set; }
    public decimal CurrencyFactor { get; set; }
    public decimal FreightCharge { get; set; }
}




public class PanelApprovalDetails
{

    public string transactionID { get; set; }
    public string patientID { get; set; }
    public string panelID { get; set; }
    public List<PanelDocument> panelDocuments { get; set; }
    public string approvalAmount { get; set; }
    public string approvalRemark { get; set; }
    public string NICNumber { get; set; }
    public string policyNumber { get; set; }
    public string policyCardNumber { get; set; }
    public string policyExpiryDate { get; set; }
    public bool attachCostEstimation { get; set; }
    public string nameOnCard { get; set; }
    public string cardHolderRelation { get; set; }
    public bool ignorePolicy { get; set; }
    public string ignorePolicyReason { get; set; }
    public int IsThroughsmartCard { get; set; }
    public int SessionId { get; set; }
    public int IsThroughManul { get; set; }
    public string PoolNr { get; set; }
    public string PoolDesc { get; set; }



}


public class TaxCalculationDetails
{
    public decimal netAmount { get; set; }
    public decimal netAmountWithOutTax { get; set; }
    public decimal taxAmount { get; set; }
    public decimal taxPercent { get; set; }
    public decimal discountPercent { get; set; }
    public decimal discountAmount { get; set; }
    public decimal amount { get; set; }
    public decimal unitPrice { get; set; }
    public decimal MRP { get; set; }
    public decimal exciseAmount { get; set; }
    public decimal excisePercent { get; set; }



    public decimal CGSTPercent { get; set; }
    public decimal IGSTPrecent { get; set; }
    public decimal SGSTPercent { get; set; }
    public decimal igstTaxAmount { get; set; }
    public decimal cgstTaxAmount { get; set; }
    public decimal sgstTaxAmount { get; set; }
    public decimal specialDiscountAmount { get; set; }
    public decimal specialDiscountPer { get; set; }

}

public class TaxCalculationOn
{
    public decimal Rate { get; set; }
    public decimal Quantity { get; set; }
    public decimal MRP { get; set; }
    public decimal TaxPer { get; set; }
    public decimal DiscPer { get; set; }
    public string Type { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal ExcisePer { get; set; }
    public decimal deal { get; set; }
    public decimal deal2 { get; set; }
    public decimal ActualRate { get; set; }
    //gst
    public decimal CGSTPercent { get; set; }
    public decimal IGSTPrecent { get; set; }
    public decimal SGSTPercent { get; set; }
    public decimal SpecialDiscPer { get; set; }
    public decimal SpecialDiscAmt { get; set; }
    public string SpecialDiscType { get; set; }
}
public class TestCentre
{
    public string BookingCentre { get; set; }
    public string Investigation_ID { get; set; }
    public string TestCentre1 { get; set; }
    public string TestCentre2 { get; set; }
    public string TestCentre3 { get; set; }
    public string AllInvestigation_ID { get; set; }
}

public class DoctorUnit
{
    public string DoctorListId { get; set; }
    public string UnitDoctorID { get; set; }
    public string CreatedBy { get; set; }
    public DateTime CreatedDateTime { get; set; }
    public int IsActive { get; set; }
    public string Position { get; set; }
    public int IsPer { get; set; }
    public decimal OPD_Con { get; set; }
    public decimal OPD_Pro { get; set; }
    public decimal OPD_Lab { get; set; }
    public decimal OPD_Pac { get; set; }
    public decimal IPD_Visit { get; set; }
    public decimal IPD_Pro { get; set; }
    public decimal IPD_Lab { get; set; }
    public decimal IPD_Sur { get; set; }
    public decimal IPD_Pac { get; set; }
    public decimal OPD_Oth { get; set; }
    public decimal IPD_Oth { get; set; }
}

public class HisToNetram
{
    public string PK_VisitId { get; set; } // this is your Invoice ID (Unique)
    public int FK_BranchId { get; set; }  //Branch  Center ID (as of now I am using 1
    public int FK_RegId { get; set; }
    public DateTime VisitDate { get; set; } // (yyyy-mm-dd)
    public TimeSpan VisitTime { get; set; } //(hh:mm)
    public DateTime RegDate { get; set; }
    public TimeSpan RegTime { get; set; }
    public TimeSpan ApptTime { get; set; }
    public string Initial { get; set; } //varchar(10)
    public string FirstName { get; set; }   //varchar(50) 
    public string LastName { get; set; }    //varchar(50)
    public string CareOfType { get; set; }  //varchar(50) (S/o, D/o C/o like)
    public string CareOfName { get; set; }
    public int AgeYear { get; set; }
    public int AgeMonth { get; set; }
    public int AgeDays { get; set; }
    public DateTime DOB { get; set; }
    public string Sex { get; set; } //Char(1)
    public string MobileNo { get; set; } //varchar(20)
    public string EmailAddress { get; set; } //varchar(100)
    public string Address { get; set; }  //varchar(100)
    public int FK_DoctorId { get; set; } //(between 1 to 5)
    public bool IsReview { get; set; } //false if New Patient
    public int FK_AppointmentId { get; set; } //if apptime than pass 1 or AppointentID
    public string Remarks { get; set; }
    public string Speciality { get; set; }
    public string DoctorName { get; set; }
}

public class DoctorLoginDetailToNetram
{
    public  string UserId { get; set; }
    public  string LoginName  { get; set; } 
    public  string UserName { get; set; }
    public  string password { get; set; }
    public  string MobileNo { get; set; }
    public  string Email { get; set; }
    public  string Gender { get; set; }
    public  string NationalID { get; set; }
    public  string RegistrationNo { get; set; }
    public  DateTime DOB { get; set; }
    public  string Usertype { get; set; }
    public  string ClinicName { get; set; }
    public  string Specialization { get; set; }
    public string Speciality { get; set; }
    public int FK_BranchId { get; set; }
    public int DoctorId { get; set; }


}

public class PatientMultiPanel {

    public string PPanelID { get; set; }
    public string PPanelGroupID { get; set; }
    public string PParentPanelID { get; set; }
    public string PPanelCorporateID { get; set; }
    public string PPolicyNo { get; set; }
    public string PCardNo { get; set; }
    public string PCardHolderName { get; set; }
    public string PExpiryDate { get; set; }
    public string PCardHolderRelation { get; set; }
    public string PApprovalAmount { get; set; }
    public string PApprovalRemarks { get; set; }
    public int IsDefaultPanel { get; set; }

}

public class NoteCreation {
    public string NoteType { get; set; }
    public string Problem { get; set; }
    public string OnSet { get; set; }
    public string Description { get; set; }
    public string Code { get; set; }
    public string Surgery { get; set; }
    public string SurgeryDate { get; set; }
    public string Illness { get; set; }
    public string RelationShip { get; set; }
    public string Issue { get; set; }
    public string DoctorID { get; set; }
    public string PatientID { get; set; }
    public string TransactionID { get; set; }
    public string NoteCreationDate { get; set; }
    public string SaveType { get; set; }
    public string ID { get; set; }
    public string Detail { get; set; }
    public string ProgressNote { get; set; }
    public string Careplan { get; set; }
    public string sqno { get; set; }
}






public class LablePrintInsert
{
    public string PName { get; set; }
    public string MRNo { get; set; }
    public string SideEffect { get; set; }
    public string Duration { get; set; }
    public string Times { get; set; }
    public string Dose { get; set; }
    public string ItemName { get; set; } 
    public string ItemDispance { get; set; }
    public string ItemID { get; set; }
    public int NoOfPrint { get; set; }
    public string Remarks { get; set; }
    public string LedgerTransactionNo { get; set; }

}
 
                         