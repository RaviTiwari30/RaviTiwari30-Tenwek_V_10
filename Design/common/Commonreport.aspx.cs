using System;
using System.Data;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

public partial class Design_common_Commonreport : System.Web.UI.Page
{
    ReportDocument obj1 = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        //System.IO.Stream oStream = null;
        try
        {
            if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                
                Response.Redirect(Request.RawUrl + "?access=" + Util.getHash(), false);
            }
            else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
            }
            //else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) != "")
            //{
            //    Response.Redirect(Request.RawUrl + "&access=" + Util.GetString(Request.QueryString["access"]));
            //}
            string cmd = Util.GetString(Request.QueryString["cmd"]);


            DataSet ds = new DataSet();

            ds = (DataSet)Session["ds" + cmd];
            string ReportName = "";

            if (Session["ReportName" + cmd] != null)
            {
                ReportName = Session["ReportName" + cmd].ToString();
                Session.Remove("ReportName" + cmd);
                Session.Remove("ds" + cmd);
                switch (ReportName)
                {
                    case "BirthCertificatePrint":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\BirthCertificatePrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "MacData":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\MacData.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AdmitDischarge":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\AdmitDischarge.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DepartmentWiseSummaryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DepartmentWiseSummaryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NonMedLowStockReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\NonMedicalLowStockReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "FieldBoyDetailReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FieldBoyDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FieldBoySummaryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FieldBoySummaryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorksheet":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\LabWorksheet.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "GenericReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/GenericReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorksheet2":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\LabWorksheet2.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RateListReportIPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RateListReportIPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysisSummaryItemwise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummaryItemwise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NonMedStoreCurrentReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\NonMedStoreCurrentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PatientwiseReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PatientwiseIssue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StockIssueReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\StockIssueReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeptIssueItem":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DeptIssueItemWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeptIssueItemDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockIssueDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ALLDepartment":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ALLDepartment.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OT_Schedule":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OT_Schedule.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailPanelReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailPanelReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "WeeklyPanelReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/WeeklyPanelReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPD_OutstandingReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OPD_OutstandingReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DepartmentWiseDetailReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DepartmentWiseDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MonthlyPanelReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelMonthlyPatient.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StockExpiryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StoreExpiryItems.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreVendorReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StoreVendorDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreClosingReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockClosingReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StockStatusReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockStatusReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreBinCardReport":
                        {                           
                            // obj1.Load(Server.MapPath("~/Reports/Reports/StockBinCard.rpt"));
                            obj1.Load(Server.MapPath("~/Reports/Reports/NewStockBinCard.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CreditReportDept":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CreditBillReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CreditReportPanel":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CreditBillReportPanel.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreLedgerReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockLedgerReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreLedgerReportCategoryWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockLedgerReportCategoryWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "StoreLedgerReportDept":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockLedgerReportDept.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }



                    case "StoreLedgerReportOnlyItemWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StoreLedgerReportOnlyItemWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PAC_Checkuplist":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OT_PAC_Checkuplist.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OT_POI":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OT_POI.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeathReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DeathReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeathCertificate":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DeathCertificate.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DischargeWithoutBill":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DischargeWithoutBill.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DoctorWiseOpdAppointment":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorWiseOpdAppointment.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FreeSubsidyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPD_Discount_Report.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StockAdjustmentReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockAdjustment.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SearchSales":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SearchSales.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ReturnSearch":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ReturnSearch.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPDFreeSubsidyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OpdDiscount.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "VendorReturn":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/VendorReturn.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FreeItem":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FreeItem.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BothDiscountReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BothDiscountReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreReturnReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StoreReturnReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysis":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysisSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FreeMedicineIssue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FreeMedicineIssue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemWiseComparative":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemWiseComparativeReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemWiseSupplierList":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemWiseSupplierList.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "VendorBillDetails":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/VendorBillDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "VendorBillSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/VendorBillSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AverageConsumptionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AverageConsumptionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemMovementReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemMovementReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemExpiryChange":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemExpiryChange.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PatientIssueMedicalDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientStoreIssueDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    //case "PatientIssueMedicalDetail":
                    //{
                    //    obj1.Load(Server.MapPath("~/Reports/Reports/PatientStoreIssueDetails.rpt"));
                    //    obj1.SetDataSource(ds);
                    //break;}
                    case "StoreIssueCancel":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StoreIssueCancel.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DoctorWiseOpdProcedure":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorWiseOpdProcedure.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SummaryPR":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SummaryPR.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailPR":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailPR.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailPO":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailPO.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SummaryPO":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SummaryPO.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "WardCollectionSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/WardWiseCollectionSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "WardCollectionDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/WardWiseCollectionDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PurchaseSummaryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PurchaseSummaryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SmartCardReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SmartCardReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BirthDayReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BirthDayReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TDSReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TDSReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AccountBillSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AccountBillSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AccountBillDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AccountBillDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AccountSurgeryDoctorDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AccountSurgeryDoctor.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BedOccupancyRoomWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BedOccupancyReportRoomWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BedOccupancyPatientWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BedOccupancyReportPatientWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDFreeSubsidyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FreeIPDDiscount.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PurchaseAmendementReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PurchaseAmendmentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ChalanItem":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/GetItemByChalan.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PharmacyTaxReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PharmacyTaxReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Itemwise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Itemwise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Receiptwise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Receiptwise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailIssue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailIssue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NonMedicalSummaryIsuue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/NonMedicalSummaryIsuue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NonMedicalDetailIsuue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/NonMedicalDetailIsuue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AdmitDischargeMonthComparison":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AdmitDischargeMonthComparison.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NMPurchaseSummaryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/NMPurchaseSummaryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailPharmacyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailPharmacyReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemWisePharmacyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemWisePharmacy.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PanelWisePharmacyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelWisePharmacyReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SummaryIndent":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SummaryIndent.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailIndent":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailIndent.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPDByLocation":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OPDPatientByLocation.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPDBySource":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OPDPatientBySource.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SummaryPharmacyReturn":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SummaryPharmacyReturn.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailPharmacyReturn":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DetailPharmacyReturn.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PharmacySalesReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PharmacySalesReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PharmacyIssueReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PharmacyIssueReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PurchaseStoreLedgerReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PurchaseStockLedgerReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreIssueReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\DeptItemIssueReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ComparativeDetail":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\ComparativeChartReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "CurrentStockLedger":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CurrentStockLedger.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "VendorReturnReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\VendorReturnItemsReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "POClose":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\POClose.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RGP_OUT":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\RGP_OUT.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RGP_IN":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\RGP_IN.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OutStandRGP":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\OutStandRGP.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeptIssueCategoryWise":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\DeptIssueCategoryWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NRGP":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\NRGP.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SummaryDocAccount":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DocAcctSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DetailDocAccount":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DocAcctDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SummaryOPDCollection":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SummaryOPDCollection.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemCreation":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemCreation.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PDetailReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DoctorWiseBusiness":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorWiseBusiness.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "GRNDetailMedical":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/GRNDetailMedical.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "GRNDetailNonMedical":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/GRNDetailNonMedical.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AdmittedList":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AdmittedList.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreCurrentReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CurrentStockLedger.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LowStockReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\LowStockReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "StoreCurrentReportNew":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CurrentStockLedgerNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DocLabDetails":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\DocLabDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CancelledReceipt":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CancelOPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CancelledBill":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CancelBill.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CancelledAdmission":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CancelAdmission.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PaymentDetails":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PaymentDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MedLowStockReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\MinStockReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NewIndent":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\NewIndent.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PatientNewIndent":
                        {
                              //obj1.Load(Server.MapPath(@"~\Reports\Reports\PatientNewIndent.rpt"));
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PatientNewIndentNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PtAdmitDetails":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PtAdmitDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "BBDonorRegistration":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\BBDonorRegistration.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }



                    case "RateListReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\RateListReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BillRegisterReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\IpdBillRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BillRegisterReportPanel":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\IpdBillRegisterPanel.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BillRegisterReportPanelDoctor":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\IpdBillRegisterPanelDoctor.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionBillReceiptReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionBillReceiptReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FOFileIssueReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FOFileIssueReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FOFileReceivedReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FOFileReceivedReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "FOFilePendingReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FOFilePendingReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    //case "DocReferDetails":
                    //    {
                    //        obj1.Load(Server.MapPath("~/Reports/Reports/NewReferDoctorDetail.rpt"));
                    //        obj1.SetDataSource(ds);
                    //        break;
                    //    }
                    case "censusReportOPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CensusReportOPDNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "censusReportIPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/censusReportIPDNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "censusReportDetail":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\censusReportDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NewIndentForStore":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\NewIndentForStore.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DocAccDetails":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DocAccountDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeptWiseBillReceiptReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DeptWiseBillReceiptReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OT_PAC":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OT_PAC_Print.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }


                    case "OT_Chart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OT_otchat.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OT_Notes":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/OT_OperationRecord.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OperationList":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/OperationList.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "OTCancelReport":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/OTCancelReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }


                    case "CalculatedDocShare":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CalculatedDocShare.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RadiologyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RadiologyReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "RefundReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RefundReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CancelIPDReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CancelIPDReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Sticker":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Sticker.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DoctorSummaryOPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorSummaryOPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BedOccupancyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BedOccupancyReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BedOccupancyReportPatient":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BedOccupancyPatientWisenew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysisSummaryDeptWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummaryDeptWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysisSummaryBensup":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummaryBensup.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysisSummaryDeptWiseBensup":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummaryDeptWiseBensup.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NewAgeingReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\AgeingReportOPD_IPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "drcrnote":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CreditDebitNote.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Vendor_CompanyReport1":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Vendor_CompanyReport1.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Vendor_CompanyReport2":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Vendor_CompanyReport2.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportincludingrefund":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportincludingrefund.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorksheetNotApproved":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\LabWorksheetNotApproved.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabTurnAroundTime":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/LabTurnAroundTime.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportSummaryOnly":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummaryOnly.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SampleRejectionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SampleRejectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportSummaryOnlyDatewise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummaryOnlyDatewise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DepartmentReturn":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DeptReturn.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }


                    case "AutoPurchaseOrder":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AutoPo.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "AutoPurchaseOrderLog":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AutoPoLog.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "PatientIssueReturnSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientIssueReturnSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "DoctorWiseAppointmentDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorWiseAppointmentDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "DoctorWiseAppointmentSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorWiseAppointmentSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "CollectionReportSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;


                        }
                    case "GhanaHealthService_OPD":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\GhanaHealthService_OPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IncomeReportDatewise":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\IncomeReportDatewise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RegistrationReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\RegistrationReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RecieptWiseCollectionReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\RecieptWiseCollectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "GeneralConsentForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/GeneralConsentForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "PhysicalTherapy":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Physical_Therapy.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "PatientRegistrationForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientRegistrationForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "GeneralConsentForm_1":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/GeneralConsentForm_1.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }

                    case "FinancialAgreementForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FinancialAgreementForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "SurgeryEstimate":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SurgeryEstimate.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "StockStatus":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/StockStatus.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ConsumeGatherReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ConsumeGatherReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Sales":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Sales.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CreditIssueDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CreditIssueDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AppConfirmationReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AppConfirmationReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SurgeryAnalysis":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SurgeryAnalysisDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SurgeryAnalysisSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SurgeryAnalysisSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SurgeryAnalysisSummaryDeptWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SurgeryAnalysisSummaryDeptWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OpdPatientIssue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OpdPatientIssue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportSummaryDateWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionSummaryDateWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPD_Discount_Report":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OpdDiscount.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AppointmentcancellationReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\AppointmentcancellationReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchSRS":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_SRS.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchVAS":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_VAS.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchODI":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_ODI.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchSF36":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_SF36.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchSCTR":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_SCTR.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchHIP":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_HIP.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ResearchKNEE":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\Research_KNEE.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Anesthesia":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Anesthesia.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportSummaryDepartmentWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummaryDepartmentWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "HealthServiceReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/HealthServiceReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Morbidity":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Morbidity.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "DoctorShareDetail":
                        {
                            obj1.Load(Server.MapPath("~/Design/DocAccount/Report/DocShareDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "Print":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PrintCard.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "OPDTaxReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TaxReportOPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "DoctorWiseDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemAnalysisDoctorWiseDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }

                    case "TravellingDetail":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/TravelDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TransportSummary":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/TransportSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DriverLicenceExpiry":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/DriverLicenceExpiry.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "vehicleInsuranceExpiry":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/vehicleInsuranceExpiry.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BirthNotificationDetails":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BirthNotificationDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationBill":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\InvestigationBill.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DocDiscDetails":
                        {
                            obj1.Load(Server.MapPath("~/Design/DocAccount/Report/DocDiscDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DocDiscDetails_Summary":
                        {
                            obj1.Load(Server.MapPath("~/Design/DocAccount/Report/DocDisDetails_Summary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationAnalysisSummaryDeptWise_Panel":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummaryDeptWise_Panel.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "InvestigationAnalysisSummary_Doctor":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationAnalysisSummary_Doctor.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RevenueSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RevenueSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RevenueSummaryBreakup":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RevenueSummaryBreakup.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DocReferDetails":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/NewReferDoctorDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PanelWiseOutStanding":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelWiseOutStanding.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PanelWiseOutStanding_patient_wise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelWiseOutStanding_patient_wise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }


                    case "DoctorDetailReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InvestigationBillIPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InvestigationBillIPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PharmacyBillIPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PharmacyInvoice.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "collectionDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "collection":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "CollectionIPDDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionIPDDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "IPDOutStanding":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPDOutStanding.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "BillNotPrepared":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BillNotPrepared.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "BillWiseCollection":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BillWiseCollection.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PanelWiseCollection":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelWiseCollection.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "DiagnisticsReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DiagnisticsDuesReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CategorywiseReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CategorywiseRepot.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DiabeticChart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DiabiaticChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NursingCarePlan":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/NursingCarePlan.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ObservationChart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ObservationChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MedicationRecord":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DrugChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "InTakeOutPutChart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/InTakeOutPutChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "BloodTransfusionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BloodTransfusionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LoginDetails":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/LoginDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MedicinePrescriptionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MedicinePrescriptionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PurchaseVatReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PurchaseVatReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SalesIssueVatReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SalesIssueVatReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SalesReturnVatReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SalesReturnVatReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DrugCartegoryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DrugScheduleReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SupplierPaymentReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SupplierPaymentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "OutSourceReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OutSourceReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MedicalCertificate":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MedicalCertificate.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Patient Room Transfer":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientRoomTransfer.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PtAdvanceRoomBooking":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AdvanceRoomBookingRpt.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PRNormReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PRNormsReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PatientIndentReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientIndentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PanelWiseDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelWiseDetailReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PanelWiseSummarised":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelWiseSummaryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IncidentReportForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IncidentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NeedleInjuryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/NeedleInjuryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DoctorReferalCase":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorReferalReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RequestedRoomReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RequestedRoomReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SMSReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/SMS/SMSReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPDAdvanceOutstandingReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OPDAdvanceOutstandingReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LowStockReport_Norms":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/LowStockReport_Norms.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PatientHistoryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientHistoryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CorpseDepositeReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Mortuary_CorpseDepositeRpt.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MortuarySticker":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Mortuary_Sticker.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MortuaryDetailedBill":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MortuaryDetailedBillRpt.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CorpsePostmortemStatusReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MortuaryPostmortemStatusReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RadiologyConsentForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/RadiologyConsentForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MedicineBillClearence":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MedClearenceReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDConsultationVisitReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPDConsultationReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDOutStandingCategoryWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPDOutStandingCategoryWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportPaymentWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportPaymentWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PharmacySummaryCollectionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PharmacySummaryCollectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "DoctorRefer":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DoctorRefer.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PROReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PROReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PharmacyBalance":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PharmacyBalance.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDPanelGroupReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPDPanelGroupReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDCreditLimtReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPDCreditLimit.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPDPanelGroupReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/OPDPanelGroup.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ExpenseDateWiseReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ExpenseDateWiseReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PtntSourcewiseReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PtntSourcewiseReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DirectDepartmentIssue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DirectDepartmentIssuePrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "VehicleIssue":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/VehicleIssue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TransportTransactionReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/TransportTransactionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TPARecInvoice":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TPARecInvoice.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TPARecInvoiceESI":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TPARecInvoiceESI.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TPARecInvoiceCGHS":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TPARecInvoiceCGHS.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TPARecInvoiceECHS":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TPARecInvoiceECHS.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TPARecInvoicePSU":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/TPARecInvoicePSU.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DiscountReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DiscountReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ItemExpiryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ItemExpiryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DailyCollectionSettlement":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DailyCollectionReportDetailNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MortuaryCorpseReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MortuaryCorpseReportRpt.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MortuarySummaryBill":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/MortuarySummaryBillRpt.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PatientReturnIndent":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PatientReturnIndent.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ComponentReport":
                        {
                            obj1.Load(Server.MapPath(@"~/Design/Kitchen/ComponentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "CollectionReportSummarySpecialitytWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummarySpecialityWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportSummaryDoctorWise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummaryDoctorWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DoctorProgressNote":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/DoctorProgressNote.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Patient Master File":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_PatientMasterFile.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "EmerGencyToIPDPatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_EmerGencyToIPDPatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CurrentIPPatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_CurrentIPPatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabRadioRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_LabRadioRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPPatientRegister_Hourly":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_IPPatientRegister_Hourly.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "HIVLabTestRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_HIVLabTestRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NewEmergencyPatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_NewEmergencyPatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ChaperOnServices":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_ChaperOnServices.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "EmergencyPatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_EmergencyPatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPPatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_OPPatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPPatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_IPPatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDischargePatientRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_IPDischargePatientRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PhysioTherapyCount":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_PhysioTherapyCount.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CurrentIPSurgeryRegister":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_CurrentIPSurgeryRegister.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OPPatientRegister_Hourly":
                        {
                            obj1.Load(Server.MapPath(@"~/Reports/Reports/MRD_OPPatientRegister_Hourly.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LaboratoryOutPatientRecordForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/LaboratoryOutPatientReForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "IPDConsentForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IPDConsentForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ApprovedByReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ApproveByReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BabyFeedingandOnservationChart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BabyFeedingandOnservationChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BloodGasChart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BloodGasChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AdultAssessMentPrint":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AdultAssessMentPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DeceasedPatientCheckList":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DeceasedPatientCheckList.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DischargePatientCheckList":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DischargePatientCheckList.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "EMGFalseAssessment":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/EMGFalseAssessment.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CreditDebitNoteReport_Summary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CreditDebitNoteReport_Summary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CreditDebitNoteReport_Detail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CreditDebitNoteReport_Detail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SampleCollectionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SampleCollectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PanelOutstanding":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PanelOutstanding.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PREOPINSTRUCTIONS":
                        {

                            obj1.Load(Server.MapPath("~/Reports/Reports/PREOPINSTRUCTIONS.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PREANESTHETICEVALUATION":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PREANESTHETICEVALUATION.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PlanofAnesthesia":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PLANOFANESTHESIA.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SurgerySafetyCheckList":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/SurgerySafetyCheckList.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Departmentofsurgery":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/departmentofsurgery.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "PrintBulkRegistrationPrint":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PrintBulkRegistrationPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "Antenatal_Patient_report":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/Antenatal_Patient_report.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NwardActivityReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/WardActivityPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ConsentForm":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ConsentForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ECGReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ECGReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "VehicleFuelEntryReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/VehicleFuelEntryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "VehicleServiceReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Transport/Report/VehicleServiceReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BioMedicalWasteReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BioMedicalWasteReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BioMedicalWasteHospitalReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/BioMedicalHospitalReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CanteenSales":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CanteenSales.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CanteenItemwise":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CanteenItemwise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ReprintAssetDepartmentIssue":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ReprintAssetDepartmentIssue.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PrintAssetBarcode":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PrintAssetBarcode.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AMCWarrantyReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/AMCWarrantyReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "AssetReturnIndentPrint":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\AssetReturnIndentPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "ReprintAssetDepartmentReturn":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/ReprintAssetDepartmentReturn.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
						    case "PatientAdvanceStatement":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientAdvanceStatement.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                            case "CollectionReportSummaryTotal":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionReportSummaryTotal.rpt"));
                            obj1.SetDataSource(ds);
                            break;


                        }
                            case "RecieptWiseCollectionReportNew":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\RecieptWiseCollectionReportNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                            case "CollectionRevenueSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CollectionRevenueSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;


                        }
                            case "CollectionRevenueDetail":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CollectionRevenueDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                            case "DueBill":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/DuePharmacyBillReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                            case "DailyPharmacyReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\DailyPharmacyReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                        case "InvestigationStatusReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\InvestigationStatusReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                        case "LabelToPrint":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\LabelToPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                        case "DischargeSlip":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\DischargeSlip.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                        case "PatientReferalForm":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PatientReferalForm.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
 			case "PrintPostOPRecord":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PostOPRecord.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        } 
			case "IntraOPObservationChart":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/IntraOPObservationChart.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
			case "CurrentPreganancy":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/CurrentPregnancy.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
			 case "OPDBillCollection":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\OPDBillCollection.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

             case "dispatchReportSummaryOPD":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/dispatchReportSummaryOPD.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

             case "dispatchReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/dispatchReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
             case "PatientStatementReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/PatientStatementReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
             case "CSSDLabelToPrint":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\CSSDLabelToPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
			case "LaundryCount":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\LaundryCount.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
					   case "VehicleAckPrint":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\VehicleAckPrint.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
					   case "PrintReportTicket":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\PrintReportTicket.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                       case "BirthCertificateEntryReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\BirthCertificateEntryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }


     			case "UserTestPerformReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Reports\UserTestPerformReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                case "FitnessCertificate":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/FitnessCertificate.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                case "EmergencyCertificate":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Reports/EmergencyCertificate.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                }


                if (Request.Browser.IsMobileDevice)
                {

                    if (!Directory.Exists(Server.MapPath(@"~\TempMobileFile")))
                    {
                        Directory.CreateDirectory(Server.MapPath(@"~\TempMobileFile"));
                    }
                    string NewFileName = Guid.NewGuid().ToString() + ".pdf";
                    obj1.ExportToDisk(ExportFormatType.PortableDocFormat, Server.MapPath(@"~\TempMobileFile\" + NewFileName));
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key5", "window.open('../../TempMobileFile/" + NewFileName + "');", true);
                    Response.Redirect("../../TempMobileFile/" + NewFileName);
                    //Response.ContentType = "application/pdf";
                    //Response.TransmitFile(@"C:\MobileBrowserFile\5b27e6d6-5385-4da8-bcb0-800904915faf.pdf");
                    //Response.Flush();
                }
                else
                {
                    //System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                    //obj1.Close();
                    //obj1.Dispose();
                    //Response.ClearContent();
                    //Response.ClearHeaders();
                    //Response.Buffer = true;
                    //Response.ContentType = "application/pdf";
                    //Response.BinaryWrite(m.ToArray());
                    //m.Flush();
                    //m.Close();
                    //m.Dispose();
                    //ds.Dispose();

                    System.IO.Stream oStream = null;
                    byte[] byteArray = null;
                    oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                    byteArray = new byte[oStream.Length];
                    oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.ContentType = "application/pdf";
                    Response.BinaryWrite(byteArray);
                    Response.Flush();
                    Response.Close();
                    obj1.Close();
                }
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }


    }

    protected void page_Unload(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
        }
    }
}
