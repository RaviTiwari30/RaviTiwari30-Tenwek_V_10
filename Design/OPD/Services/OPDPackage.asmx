<%@ WebService Language="C#" Class="OPDPackage" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OPDPackage : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    

    [WebMethod(EnableSession = true, Description = "Save OPDPackage")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveOPDPackage(object PM, object PMH, object LT, object LTD, object PaymentDetail, bool directDiscountOnBill, string MobilePrescriptionID)
    {
        List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        MySqlConnection con = Util.GetMySqlCon();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {



            int ReferenceCodeOPD = Util.GetInt(StockReports.ExecuteScalar("SELECT pnl.`ReferenceCodeOPD` FROM f_panel_master pnl WHERE pnl.`PanelID`=" + dataPMH[0].PanelID + " "));

            //setting doctor Rate and RateListID in LTD
            dataLTD.ForEach(item =>
            {
                if (item.PackageType == 2)
                {
                    //  var rateDetails = AllLoadData_OPD.GetRate(item.DoctorID, item.SubCategoryID, dataPMH[0].PanelID);
                    //  var rateDetails = AllLoadData_OPD.GetRate(item.DoctorID, item.SubCategoryID, dataPMH[0].PanelID, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
                    var rateDetails = AllLoadData_OPD.GetRate(item.DoctorID, item.SubCategoryID, ReferenceCodeOPD, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));

                    item.Rate = Util.GetDecimal(rateDetails.Rows[0]["Rate"]);
                    item.ItemID = rateDetails.Rows[0]["ItemID"].ToString();
                    item.RateListID = Util.GetInt(rateDetails.Rows[0]["ID"]);
                }
            });

            var zeroRateItemList = dataLTD.Where(i => i.Rate <= 0).ToList();

            if (zeroRateItemList.Count > 0) {
                string zeroRateItems = string.Join(",", zeroRateItemList.Select(i => i.ItemName).ToList());

                tnx.Rollback();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Item have Zero Rate. Items Are : " + zeroRateItems, message = zeroRateItems });
            }
            
            string PatientID = string.Empty, TransactionId = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, ReceiptNo = string.Empty;
            string BarcodeNo = "";
            Patient_Master objPM = new Patient_Master(tnx);
            var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientMasterInfo.Count == 0){
		tnx.Rollback();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
	    }
            else
                PatientID = PatientMasterInfo[0].PatientID;

            TransactionId = Insert_PatientInfo.savePMH(dataPMH, PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), PatientMasterInfo[0].HospPatientType, "OPD", "OPD-Package", tnx, con);
            if (string.IsNullOrEmpty(TransactionId))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Master" });
            }


            EncounterNo = Encounter.FindEncounterNo(PatientID);
            if (EncounterNo == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }
            
            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);

            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnx.LedgerNoCr = "OPD003";
            ObjLdgTnx.LedgerNoDr = "HOSP0001";
            ObjLdgTnx.TypeOfTnx = "OPD-Package";
            ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjLdgTnx.NetAmount = Util.GetDecimal(dataLT[0].NetAmount);
            ObjLdgTnx.GrossAmount = Util.GetDecimal(dataLT[0].GrossAmount);
            ObjLdgTnx.PatientID = PatientID;
            ObjLdgTnx.PanelID = dataPMH[0].PanelID;
            ObjLdgTnx.TransactionID = TransactionId;
            ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnx.DiscountReason = dataLT[0].DiscountReason.Trim();
            ObjLdgTnx.DiscountApproveBy = dataLT[0].DiscountApproveBy.Trim();
            ObjLdgTnx.DiscountOnTotal = dataLT[0].DiscountOnTotal;
            ObjLdgTnx.BillNo = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            if (string.IsNullOrEmpty(ObjLdgTnx.BillNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Generating Bill No." });

            }
            ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now);
            ObjLdgTnx.RoundOff = dataLT[0].RoundOff;
            ObjLdgTnx.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
            ObjLdgTnx.UniqueHash = dataLT[0].UniqueHash;
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.Adjustment = dataLT[0].Adjustment;
            ObjLdgTnx.GovTaxPer = Util.GetDecimal(dataLT[0].GovTaxPer);
            ObjLdgTnx.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount);
            if (dataPaymentDetail[0].PaymentMode.ToString() != "Credit" && (dataLT[0].Adjustment > 0))
                ObjLdgTnx.IsPaid = 1;
            else
                ObjLdgTnx.IsPaid = 0;
            ObjLdgTnx.IsCancel = 0;
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.CurrentAge = Util.GetString(PatientMasterInfo[0].Age);
            ObjLdgTnx.PatientType = PatientMasterInfo[0].HospPatientType;
            ObjLdgTnx.PatientType_ID = Util.GetInt(PatientMasterInfo[0].patientMaster.PatientType_ID);
            ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);
            string LedgerTransactionNo = ObjLdgTnx.Insert();

            if (string.IsNullOrEmpty(LedgerTransactionNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledger Transaction" });

            }

            // Mobile Booking
            if (MobilePrescriptionID != "" && MobilePrescriptionID != "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_packagebooking P set P.IsPrescribe=1 where P.ID='" + MobilePrescriptionID + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_packagebooking p inner join app_patient_master pm on pm.ID=p.PatientID set pm.PatientID='" + PatientID + "' where ifnull(pm.PatientID,'')='' AND p.ID='" + MobilePrescriptionID + "' ");

            }
          


            int sampleCollectCount = 0;
            for (int i = 0; i < dataLTD.Count; i++)
            {
                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[i].ItemID).Trim();
                ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[i].Rate);
                ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";
                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(dataLTD[i].DiscountPercentage);
                if (dataLTD[i].IsPackage == 0)
                    ObjLdgTnxDtl.Amount = (Util.GetDecimal(dataLTD[i].Amount)) + (((Util.GetDecimal(dataLTD[i].Amount)) * (Util.GetDecimal(dataLT[0].GovTaxPer))) / 100);
                else
                    ObjLdgTnxDtl.Amount = 0;
                ObjLdgTnxDtl.IsPackage = dataLTD[i].IsPackage;
                ObjLdgTnxDtl.PackageID = dataLTD[i].PackageID;
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = TransactionId;
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[i].ItemName).Trim();
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnxDtl.DiscountReason = Util.GetString(dataLT[0].DiscountReason.Trim());
                ObjLdgTnxDtl.DoctorID = dataPMH[0].DoctorID;
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                ObjLdgTnxDtl.TnxTypeID = Util.GetInt(14);
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                ObjLdgTnxDtl.RateListID = dataLTD[i].RateListID;
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.roundOff = Util.GetDecimal(ObjLdgTnx.RoundOff / dataLTD.Count);
                ObjLdgTnxDtl.typeOfTnx = ObjLdgTnx.TypeOfTnx;
                ObjLdgTnxDtl.CoPayPercent = dataLTD[i].CoPayPercent;
                ObjLdgTnxDtl.IsPayable = dataLTD[i].IsPayable;
                ObjLdgTnxDtl.isPanelWiseDisc = dataLTD[i].isPanelWiseDisc;
                ObjLdgTnxDtl.panelCurrencyCountryID = dataLTD[0].panelCurrencyCountryID;
                ObjLdgTnxDtl.panelCurrencyFactor = dataLTD[0].panelCurrencyFactor;
                ObjLdgTnxDtl.StockID = dataLTD[i].StockID;



                string LdgTnxDtlID = string.Empty;
                
                
                if (!string.IsNullOrEmpty(ObjLdgTnxDtl.StockID))
                {

                    var transactionType = 16;
                    var centreID = HttpContext.Current.Session["CentreID"].ToString();
                    var departmentLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    var userID = HttpContext.Current.Session["ID"].ToString();
                    
                    var sqlCMD = new StringBuilder(" SELECT ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice, ");
                    sqlCMD.Append(" (ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable, ");
                    sqlCMD.Append("  DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled, ");
                    sqlCMD.Append("  im.Type_ID,im.IsUsable,im.ServiceItemID,0 MedID,0 isItemWiseDisc, ");
                    sqlCMD.Append("  st.HSNCode,st.IGSTPercent,st.IGSTAmtPerUnit,st.SGSTPercent,st.SGSTAmtPerUnit,st.CGSTPercent,st.CGSTAmtPerUnit,st.GSTType, ");
                    sqlCMD.Append("   st.PurTaxPer,st.SaleTaxPer VAT FROM f_stock ST  ");
                    sqlCMD.Append("   INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID  ");
                    sqlCMD.Append("   INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1  ");
                    sqlCMD.Append("   AND CR.ConfigID = 11 AND IM.ItemID =@itemID  ");
                    sqlCMD.Append("   AND st.DeptLedgerNo=@departmentLedgerNo   AND st.StockID=@stockID ");



                    var dtStockDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
                    {
                        itemID = ObjLdgTnxDtl.ItemID,
                        departmentLedgerNo = departmentLedgerNo,
                        stockID = ObjLdgTnxDtl.StockID,
                    });

                   
                    ObjLdgTnxDtl.IsExpirable = Util.GetString(dtStockDetails.Rows[0]["isexpirable"]) == "NO" ? 0 : 1;
                    ObjLdgTnxDtl.medExpiryDate = Util.GetDateTime(dtStockDetails.Rows[0]["MedExpiryDate"]);
                    ObjLdgTnxDtl.BatchNumber = Util.GetString(dtStockDetails.Rows[0]["BatchNumber"]);
                    ObjLdgTnxDtl.StoreLedgerNo = "STO00001";







                    ObjLdgTnxDtl.PurTaxPer = Util.GetDecimal(dtStockDetails.Rows[0]["PurTaxPer"]);
                    if (Util.GetDecimal(ObjLdgTnxDtl.PurTaxPer) > 0)
                        ObjLdgTnxDtl.PurTaxAmt = Util.GetDecimal(Util.GetDecimal(ObjLdgTnxDtl.Amount) * Util.GetDecimal(ObjLdgTnxDtl.PurTaxPer)) / 100;
                    else
                        ObjLdgTnxDtl.PurTaxAmt = 0;

                    ObjLdgTnxDtl.unitPrice = Util.GetDecimal(dtStockDetails.Rows[0]["UnitPrice"]); //to be confirmed from dev





                    ObjLdgTnxDtl.HSNCode = Util.GetString(dtStockDetails.Rows[0]["HSNCode"]);
                    ObjLdgTnxDtl.IGSTPercent = 0;
                    ObjLdgTnxDtl.IGSTAmt = 0;
                    ObjLdgTnxDtl.CGSTPercent = 0;
                    ObjLdgTnxDtl.CGSTAmt = 0;
                    ObjLdgTnxDtl.SGSTPercent = 0;
                    ObjLdgTnxDtl.SGSTAmt = 0;





                    LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                    var ledgerNumber = Util.GetString(excuteCMD.ExecuteScalar("select LedgerNumber from f_ledgermaster where LedgerUserID=@patientID and GroupID='PTNT' ", new
                    {
                        patientID = PatientID
                    }));


                    var salesNo = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "Select Get_SalesNo(@transactionType,@storeType,@centreID)", CommandType.Text, new
                    {
                        transactionType = transactionType,
                        storeType = AllGlobalFunction.MedicalStoreID,
                        centreID = centreID
                    }));



                    Sales_Details ObjSales = new Sales_Details(tnx);
                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjSales.LedgerNumber = ledgerNumber;
                    ObjSales.DepartmentID = "STO00001";
                    ObjSales.ItemID = Util.GetString(dataLTD[i].ItemID);
                    ObjSales.StockID = Util.GetString(dataLTD[i].StockID);
                    ObjSales.SoldUnits = Util.GetDecimal(dataLTD[i].Quantity);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtStockDetails.Rows[0]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtStockDetails.Rows[0]["MRP"]);
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.IsReturn = 0;
                    ObjSales.LedgerTransactionNo = LedgerTransactionNo;
                    ObjSales.UserID = userID;
                    ObjSales.TrasactionTypeID = transactionType;
                    ObjSales.IsService = "NO";
                    ObjSales.Naration = string.Empty;
                    ObjSales.SalesNo = salesNo;
                    ObjSales.DeptLedgerNo = departmentLedgerNo;
                    ObjSales.Type_ID = Util.GetString(dtStockDetails.Rows[0]["Type_ID"]);
                    ObjSales.ServiceItemID = Util.GetString(dtStockDetails.Rows[0]["ServiceItemID"]);
                    ObjSales.ToBeBilled = Util.GetInt(dtStockDetails.Rows[0]["ToBeBilled"]);
                    ObjSales.IndentNo = "-";
                    ObjSales.BillNoforGP = string.Empty;
                    ObjSales.PatientID = PatientID;
                    ObjSales.CentreID = Util.GetInt(centreID);
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.LedgerTnxNo = Util.GetInt(LdgTnxDtlID);
                    ObjSales.BillNo = ObjLdgTnx.BillNo;
                    ObjSales.medExpiryDate = Util.GetDateTime(dtStockDetails.Rows[0]["MedExpiryDate"]);
                    ObjSales.BatchNo = Util.GetString(dtStockDetails.Rows[0]["BatchNumber"]);
                    ObjSales.PurTaxPer = Util.GetDecimal(dtStockDetails.Rows[0]["PurTaxPer"]);
                    ObjSales.TransactionID = TransactionId;




                    var rate = ObjSales.PerUnitSellingPrice;

                    decimal igstPercent = Util.GetDecimal(0);
                    decimal csgtPercent = Util.GetDecimal(0);
                    decimal sgstPercent = Util.GetDecimal(0);

                    decimal nonTaxableRate = (rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                    decimal discount = rate * 0 / 100;
                    decimal taxableAmt = ((rate - discount) * 100 * ObjSales.SoldUnits) / (100 + igstPercent + csgtPercent + sgstPercent);

                    decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);



                    ObjSales.IGSTPercent = igstPercent;
                    ObjSales.IGSTAmt = IGSTTaxAmount;
                    ObjSales.CGSTPercent = csgtPercent;
                    ObjSales.CGSTAmt = CGSTTaxAmount;
                    ObjSales.SGSTPercent = sgstPercent;
                    ObjSales.SGSTAmt = SGSTTaxAmount;
                    ObjSales.HSNCode = Util.GetString(dtStockDetails.Rows[0]["HSNCode"]);
                    ObjSales.GSTType = Util.GetString(dtStockDetails.Rows[0]["GSTType"]);


                    decimal MRP = ObjSales.PerUnitSellingPrice;
                    decimal SaleTaxPer = Util.GetDecimal(dtStockDetails.Rows[0]["VAT"]);
                    decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);

                    ObjSales.TaxPercent = SaleTaxPer;
                    ObjSales.TaxAmt = SaleTaxAmtPerUnit * Util.GetDecimal(ObjSales.SoldUnits);

                    decimal TaxablePurVATAmt = (Util.GetDecimal(ObjSales.PerUnitBuyPrice) * Util.GetDecimal(ObjSales.SoldUnits)) * (100 / (100 + Util.GetDecimal(dataLTD[i].PurTaxPer)));
                    decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(ObjSales.PurTaxPer) / 100;
                    ObjSales.PurTaxPer = Util.GetDecimal(ObjSales.PurTaxPer);
                    ObjSales.PurTaxAmt = vatPuramt;

                    var salesID = ObjSales.Insert();




                    string strCheck = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(ObjSales.SoldUnits) + "),0,1)CHK from f_stock where stockID='" + Util.GetString(ObjSales.StockID) + "'";
                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(tnx, CommandType.Text, strCheck)) <= 0)
                    {
                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = string.Empty });

                    }

                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(ObjSales.SoldUnits) + " where StockID = '" + Util.GetString(ObjSales.StockID) + "' and ReleasedCount + " + ObjSales.SoldUnits + "<=InitialCount";
                    int flag = Util.GetInt(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock));
                    if (flag == 0)
                    {
                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = string.Empty });

                    }
 
                }
                else
                    LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();






             

                if (string.IsNullOrEmpty(LdgTnxDtlID))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Ledger Transaction Details" });

                }







                if (dataLTD[i].PackageType == 2)
                {
                    int AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + dataLTD[i].DoctorID.ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));
                    List<docVisitDetail> visitDetail1 = AllLoadData_OPD.appVisitDetail(DateTime.Now, Util.GetString(dataLTD[i].SubCategoryID), con);
                    appointment ObjApp = new appointment(tnx);
                    ObjApp.Title = dataPM[0].Title;
                    ObjApp.PfirstName = dataPM[0].PFirstName;
                    ObjApp.plastName = dataPM[0].PLastName;
                    ObjApp.Pname = dataPM[0].PName;
                    ObjApp.ContactNo = dataPM[0].Mobile;
                    if (dataPM[0].Age != "")
                        ObjApp.Age = Util.GetString(dataPM[0].Age);
                    else
                    {
                        ObjApp.DOB = Util.GetDateTime(dataPM[0].DOB.ToString("yyyy-MM-dd"));
                        ObjApp.Age = PatientMasterInfo[0].Age;
                    }
                    ObjApp.Email = dataPM[0].Email;
                    if (dataPM[0].PatientID != "")
                        ObjApp.VisitType = "Old Patient";
                    else
                        ObjApp.VisitType = "New Patient";

                    ObjApp.TypeOfApp = Util.GetString("2");
                    ObjApp.PatientType = dataPMH[0].patient_type.ToString();
                    ObjApp.Nationality = dataPM[0].Country;
                    ObjApp.City = dataPM[0].City;
                    ObjApp.Sex = dataPM[0].Gender;
                    ObjApp.RefDocID = "";
                    ObjApp.PurposeOfVisit = "";
                    ObjApp.PurposeOfVisitID = 0;
                    ObjApp.Date = Util.GetDateTime(DateTime.Now);
                    ObjApp.DoctorID = dataLTD[i].DoctorID.ToString();
                    ObjApp.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    ObjApp.EntryUserID = HttpContext.Current.Session["ID"].ToString();
                    ObjApp.Amount = dataLTD[i].Rate;
                    ObjApp.PanelID = Util.GetInt(dataPMH[0].PanelID);
                    ObjApp.ItemID = dataLTD[i].ItemID;
                    ObjApp.SubCategoryID = dataLTD[i].SubCategoryID;
                    if (dataPM[0].PatientID != "")
                        ObjApp.PatientID = dataPM[0].PatientID;
                    ObjApp.IpAddress = All_LoadData.IpAddress();
                    ObjApp.AppNo = Util.GetInt(AppNo);
                    ObjApp.hashCode = Util.getHash();
                    ObjApp.IsConform = 1;
                    ObjApp.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjApp.Taluka = dataPM[0].Taluka;
                    ObjApp.LandMark = dataPM[0].LandMark;
                    ObjApp.Place = dataPM[0].Place;
                    ObjApp.District = dataPM[0].District;
                    ObjApp.PinCode = dataPM[0].PinCode;
                    ObjApp.Occupation = dataPM[0].Occupation;
                    ObjApp.MaritalStatus = dataPM[0].MaritalStatus;
                    ObjApp.Relation = dataPM[0].Relation;
                    ObjApp.RelationName = dataPM[0].RelationName;
                    ObjApp.TransactionID = TransactionId;
                    ObjApp.LedgerTransactionNo = LedgerTransactionNo;
                    ObjApp.PatientID = PatientID;
                    ObjApp.ConformDate = Util.GetDateTime(DateTime.Now);
                    ObjApp.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjApp.AdharCardNo = dataPM[0].AdharCardNo;
                    ObjApp.District = dataPM[0].District;
                    ObjApp.CountryID = dataPM[0].CountryID;
                    ObjApp.DistrictID = dataPM[0].DistrictID;
                    ObjApp.CityID = dataPM[0].CountryID;
                    ObjApp.TalukaID = dataPM[0].TalukaID;
                    ObjApp.ConformBy = HttpContext.Current.Session["ID"].ToString();
                    if (visitDetail1.Count > 0)
                    {
                        ObjApp.NextSubcategoryID = visitDetail1[0].nextSubcategoryID.ToString();
                        ObjApp.DocValidityPeriod = Util.GetInt(visitDetail1[0].docValidityPeriod.ToString());
                        ObjApp.nextVisitDateMax = Util.GetDateTime(visitDetail1[0].nextVisitDateMax.ToString());
                        ObjApp.nextVisitDateMin = Util.GetDateTime(visitDetail1[0].nextVisitDateMin.ToString());
                        ObjApp.lastVisitDateMax = Util.GetDateTime(visitDetail1[0].lastVisitDateMax.ToString());
                    }
                    string AppID = ObjApp.Insert();
                    string notification = Notification_Insert.notificationInsert(1, AppID, tnx, Util.GetString(dataLTD[i].DoctorID), "", 52, DateTime.Now.ToString("yyyy-MM-dd"), "");
                    if (string.IsNullOrEmpty(AppID))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Consultation" });

                    }
                }
                else if (dataLTD[i].PackageType == 1)
                {
                    Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                    objPLI.Investigation_ID = dataLTD[i].Investigation_ID;
                    objPLI.Date = Util.GetDateTime(DateTime.Now);
                    objPLI.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    objPLI.Lab_ID = "LAB1";
                    objPLI.DoctorID = dataPMH[0].DoctorID;
                    objPLI.TransactionID = TransactionId;
                    string sampleType = dataLTD[i].IsSampleCollected;
                    if (BarcodeNo == "")
                        BarcodeNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                    objPLI.BarcodeNo = BarcodeNo;
                    if (BarcodeNo == "0")
                        objPLI.PrePrintedBarcode = 1;
                    if (sampleType == "R")
                    {
                        objPLI.IsSampleCollected = "N";
                        sampleCollectCount += 1;
                    }
                    else
                    {
                        objPLI.IsSampleCollected = "S";
                        objPLI.SampleDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        objPLI.sampleCollectCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objPLI.SampleCollectionBy = HttpContext.Current.Session["ID"].ToString();
                        objPLI.SampleCollectionDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        objPLI.SampleCollector = HttpContext.Current.Session["LoginName"].ToString();
                    }
                    objPLI.PatientID = PatientID;
                    objPLI.Special_Flag = 0;
                    objPLI.LedgerTransactionNo = LedgerTransactionNo;
                    objPLI.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objPLI.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objPLI.LedgerTnxID = Util.GetInt(LdgTnxDtlID);
                    objPLI.CurrentAge = Util.GetString(PatientMasterInfo[0].Age);
                    if (dataLTD[i].IsOutSource == 1)
                    {
                        objPLI.IsOutSource = Util.GetInt(dataLTD[i].IsOutSource);
                        objPLI.OutSourceBy = HttpContext.Current.Session["ID"].ToString();
                        objPLI.OutsourceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        objPLI.OutSourceLabID = 0;
                    }
                    int resultPLI = objPLI.Insert();
                    if (resultPLI == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Lab Investigation" });

                    }
                }
            }


            var package = dataLTD.Where(i => i.IsPackage == 1).FirstOrDefault();
            if (Resources.Resource.RegistrationChargesApplicable == "1" && PatientMasterInfo[0].patientMaster.FeesPaid != 0)
            {
                var dicountPercentForRegistration = directDiscountOnBill ? package.DiscountPercentage : 0;
                OPD opd = new OPD();
                opd.OPDRegistration(TransactionId, dataPMH[0].DoctorID, LedgerTransactionNo, PatientMasterInfo[0].PanelID, con, tnx, dicountPercentForRegistration, dataLTD[0].panelCurrencyFactor);
                string sql = "UPDATE `patient_master` pm SET pm.`FeesPaid`=1 WHERE pm.`PatientID`='" + PatientID + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }



           
            ////////////////////////////// Insert in Receipt ///////////////////
            int isBill = 1;
            if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (dataLT[0].Adjustment > 0))
            {
                Receipt ObjReceipt = new Receipt(tnx);
                ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceipt.AmountPaid = dataLT[0].Adjustment;
                ObjReceipt.AsainstLedgerTnxNo = LedgerTransactionNo;
                ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjReceipt.Depositor = PatientID;
                ObjReceipt.Discount = 0;
                ObjReceipt.PanelID = dataPMH[0].PanelID;
                ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                ObjReceipt.Depositor = PatientID;
                ObjReceipt.TransactionID = TransactionId;
                ObjReceipt.RoundOff = dataLT[0].RoundOff;
                ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceipt.IpAddress = All_LoadData.IpAddress();
                isBill = 0;
                ReceiptNo = ObjReceipt.Insert();
                if (string.IsNullOrEmpty(ReceiptNo))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt" });

                }
                Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                for (int i = 0; i < dataPaymentDetail.Count; i++)
                {
                    ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                    ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                    ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                    ObjReceiptPayment.ReceiptNo = ReceiptNo;
                    ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks).Trim();
                    ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo).Trim();
                    ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName).Trim();
                    ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                    ObjReceiptPayment.S_Amount = Util.GetDecimal(dataPaymentDetail[i].S_Amount);
                    ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                    ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                    ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);
                    ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(dataPaymentDetail[i].currencyRoundOff);
                    ObjReceiptPayment.swipeMachine = Util.GetString(dataPaymentDetail[i].swipeMachine);
                    ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceiptPayment.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                    string PaymentID = ObjReceiptPayment.Insert().ToString();
                    if (string.IsNullOrEmpty(PaymentID))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt Payment Details" });

                    }
                }

            }

          
            if (sampleCollectCount > 0)
            {
                string notification = Notification_Insert.notificationInsert(3, LedgerTransactionNo, tnx, "", "", 0, "");

                if (string.IsNullOrEmpty(notification))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Notification" });

                }
            }



            //for Patient Advance 
            var patientAdvancePaymentMode = dataPaymentDetail.Where(p => p.PaymentModeID == 7).ToList();
            for (int i = 0; i < patientAdvancePaymentMode.Count; i++)
            {
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmt,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE PatientID ='" + PatientID + "'  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmt,0))>0 ORDER BY ID+0").Tables[0];
                if (dt.Rows.Count > 0)
                {
                    decimal advanceAmount = patientAdvancePaymentMode[i].Amount;
                    for (int s = 0; s < dt.Rows.Count; s++)
                    {
                        decimal paidAmt = 0;

                        if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(advanceAmount) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");
                            paidAmt = advanceAmount;

                            advanceAmount = 0;
                        }
                        else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");

                            advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                            paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                        }

                        OPD_Advance_Detail advd = new OPD_Advance_Detail(tnx);
                        advd.PaidAmount = Util.GetDecimal(paidAmt);
                        advd.PatientID = PatientID;
                        advd.TransactionID = TransactionId;
                        advd.LedgerTransactionNo = LedgerTransactionNo;
                        advd.ReceiptNo = ReceiptNo;

                        advd.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        advd.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        advd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                        advd.AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString());
                        advd.ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString();
                        advd.Insert();

                        if (advanceAmount == 0)
                            break;
                    }
                    if (advanceAmount > 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                    }
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                }

            }

            /*******************Unit Doctor*********************************/
            string UnitDoctor = StockReports.ExecuteScalar("SELECT IsUnit  FROM doctor_master WHERE DoctorID='" + dataPMH[0].DoctorID + "'");
            if (UnitDoctor == "1")
            {
                DataTable dt = StockReports.GetDataTable("SELECT * FROM unit_doctorlist WHERE UnitDoctorID='" + dataPMH[0].DoctorID + "' AND ISACTIVE=1");

                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        string str = "INSERT INTO `Doctor_Unit_Detail` (TransactionID,DoctorID,Unit_doctorIDList)VALUES('" + TransactionId + "','" + Util.GetString(dataPMH[0].DoctorID) + "','" + Util.GetString(dt.Rows[i]["DoctorListId"]) + "')";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    }
                }
            }
            /******************************************************/


            //Devendra Singh 2018-10-10 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(Util.GetInt(LedgerTransactionNo), ReceiptNo, "R", tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }
			
			
			    //doctor Share transaction update

            excuteCMD.DML(tnx, "UPDATE f_DocShare_TransactionDetail s SET s.Transferdate=CURRENT_DATE() WHERE s.TransactionID=@transactionID", CommandType.Text, new
            {
                transactionID = TransactionId
            });

            //doctor Share transaction update
			

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully", ledgerTransactionNo = LedgerTransactionNo, isBill = isBill });

            // return LedgerTransactionNo + "#" + isBill;

        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}