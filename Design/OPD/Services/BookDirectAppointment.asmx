<%@ WebService Language="C#" Class="BookDirectAppointment" %>

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
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Linq;
//[WebService(Namespace ="www.XMLWebServiceSoapHeaderAuth.net")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class BookDirectAppointment : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;

    [WebMethod(EnableSession = true, Description = "Save Direct Appointment")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public string SaveDirectApp(object Appointment, object PM, object PMH, object LT, object LTD, object PaymentDetail, object patientDocuments, object vitalSigns, bool directDiscountOnBill, string mobileAppAppointmentID, List<PanelDocument> panelDocuments)
    {
        // object patientDocuments=null;
        List<appointment> dataApp = new JavaScriptSerializer().ConvertToType<List<appointment>>(Appointment);
        List<Patient_Master> dataPM = (List<Patient_Master>)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(PM), typeof(List<Patient_Master>)); //     new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        //List<PatientDocuments> patientDocumentsDetails = new JavaScriptSerializer().ConvertToType<List<PatientDocuments>>(patientDocuments);



        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string PatientID = string.Empty, TransactionID = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, ReceiptNo = string.Empty;
            string regledgertransactionNo = string.Empty, hospledgertransactionNo = string.Empty;
            string FeePaid = string.Empty;
            ExcuteCMD excuteCMD = new ExcuteCMD();
            //   string AppNo = Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text,"Select IFNULL(MAX(AppNo),0)+1 AppNo from Appointment where Date='" + DateTime.Now.ToString("yyyy-MM-dd") + "' and DoctorID='" + dataPMH[0].DoctorID.ToString() + "' "));

            var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);





            if (PatientMasterInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });

            }
            else
                PatientID = PatientMasterInfo[0].PatientID;
            
            PatientDocument.SaveDocument(patientDocuments, PatientID);


          
                
            ////////RegistrationPayment///////////////////////





            //int hospChargeaApp = 0, regChargesApp = 0;

            //if (Resources.Resource.HospitalChargeApplicable == "1")
            //    hospChargeaApp = AllLoadData_OPD.hospChargesApp(dataPMH[0].DoctorID, PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), dataLTD[0].SubCategoryID, con);
            //else
            //    hospChargeaApp = 0;

            //if (Resources.Resource.RegistrationChargeApplicable == "1")
            //{
            //    if (Util.GetInt(PatientMasterInfo[0].IsNewPatient) == 1)
            //        regChargesApp = 1;
            //    else
            //        regChargesApp = 0;
            //}
            //else
            //    regChargesApp = 0;

            //if (hospChargeaApp > 0 || regChargesApp > 0)
            //{
            //    OPD opd = new OPD();
            //    string ChargesApp = string.Concat(regChargesApp, "#", hospChargeaApp);
            //    hospledgertransactionNo = opd.OPDBillRegistration(PatientID, dataPMH[0].PanelID, tnx, 0, dataPMH[0].DoctorID.ToString(), PatientMasterInfo[0].HospPatientType, ChargesApp, PatientMasterInfo[0].Age, con, PatientMasterInfo[0].PatientType_ID, dataPMH[0].ParentID);
            //    if (hospledgertransactionNo == "1" || hospledgertransactionNo == "2" || hospledgertransactionNo == "3" || hospledgertransactionNo == "")
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", hospledgertransactionNo = hospledgertransactionNo });
            //       // return hospledgertransactionNo;


            //}


            TransactionID = Insert_PatientInfo.savePMH(dataPMH, PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), PatientMasterInfo[0].HospPatientType, "OPD", "Direct Appointment", tnx, con);
            if (string.IsNullOrEmpty(TransactionID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Medical History" });

            }

            PatientDocument.SavePanelDocument(panelDocuments, TransactionID, PatientID, dataPMH[0].PanelID);

            EncounterNo = Encounter.FindEncounterNo(PatientID);
            if (EncounterNo == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }

            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);

            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            string a = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
            if (string.IsNullOrEmpty(a))
            {
                ObjLdgTnx.LedgerNoCr = string.Empty;
            }
            ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HttpContext.Current.Session["HOSPID"].ToString(), "HOSP", con);
            ObjLdgTnx.TypeOfTnx = "OPD-APPOINTMENT";
            ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjLdgTnx.NetAmount = Util.GetDecimal(dataLT[0].NetAmount);
            ObjLdgTnx.GrossAmount = Util.GetDecimal(dataLT[0].GrossAmount);
            ObjLdgTnx.Adjustment = dataLT[0].Adjustment;
            ObjLdgTnx.PatientID = PatientID;
            ObjLdgTnx.PanelID = dataPMH[0].PanelID;
            ObjLdgTnx.TransactionID = TransactionID;
            ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnx.DiscountReason = dataLT[0].DiscountReason;
            ObjLdgTnx.DiscountApproveBy = dataLT[0].DiscountApproveBy;
            ObjLdgTnx.DiscountOnTotal = dataLT[0].DiscountOnTotal;
            ObjLdgTnx.BillNo = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            if (string.IsNullOrEmpty(ObjLdgTnx.BillNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In LdgTnx" });

            }
            ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.RoundOff = dataLT[0].RoundOff;
            ObjLdgTnx.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
            ObjLdgTnx.UniqueHash = dataPMH[0].HashCode;
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.GovTaxPer = Util.GetDecimal(dataLT[0].GovTaxPer);
            ObjLdgTnx.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount);

            if (dataPaymentDetail[0].PaymentMode.ToString() != "Credit" && (dataLT[0].Adjustment > 0))
                ObjLdgTnx.IsPaid = 1;
            else
                ObjLdgTnx.IsPaid = 0;
            ObjLdgTnx.IsCancel = 0;
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.PatientType = PatientMasterInfo[0].HospPatientType;
            ObjLdgTnx.CurrentAge = Util.GetString(PatientMasterInfo[0].Age);
            ObjLdgTnx.PatientType_ID = Util.GetInt(PatientMasterInfo[0].PatientType_ID);
            ObjLdgTnx.Remarks = Util.GetString(dataPaymentDetail[0].PaymentRemarks);
            ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);

            string LedgerTransactionNo = ObjLdgTnx.Insert();
            if (string.IsNullOrEmpty(LedgerTransactionNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In  LdgTnx" });

            }



            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
            ObjLdgTnxDtl.ItemID = dataLTD[0].ItemID;
            ObjLdgTnxDtl.Rate = dataLTD[0].Rate;//dataLT[0].GrossAmount;
            ObjLdgTnxDtl.Quantity = 1;
            ObjLdgTnxDtl.StockID = string.Empty;
            ObjLdgTnxDtl.IsTaxable = "NO";
            ObjLdgTnxDtl.Amount = dataLTD[0].Amount;//dataLT[0].NetAmount;
            ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(dataLTD[0].DiscountPercentage);
            ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[0].DiscAmt);
            ObjLdgTnxDtl.IsPackage = 0;
            ObjLdgTnxDtl.PackageID = string.Empty;
            ObjLdgTnxDtl.IsVerified = 1;
            ObjLdgTnxDtl.TransactionID = TransactionID;
            ObjLdgTnxDtl.SubCategoryID = dataLTD[0].SubCategoryID;
            ObjLdgTnxDtl.ItemName = dataLTD[0].ItemName;
            ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnxDtl.DiscountReason = dataLTD[0].DiscountReason;
            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[0].SubCategoryID), con));
            ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
            ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[0].DiscAmt);
            ObjLdgTnxDtl.DoctorID = dataPMH[0].DoctorID.ToString();
            ObjLdgTnxDtl.RateListID = dataLTD[0].RateListID;
            ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
            ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnxDtl.Type = "O";
            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnxDtl.rateItemCode = dataLTD[0].rateItemCode;
            ObjLdgTnxDtl.roundOff = Util.GetDecimal(ObjLdgTnx.RoundOff / dataLTD.Count);
            ObjLdgTnxDtl.CoPayPercent = dataLTD[0].CoPayPercent;
            ObjLdgTnxDtl.IsPayable = dataLTD[0].IsPayable;
            ObjLdgTnxDtl.isPanelWiseDisc = dataLTD[0].isPanelWiseDisc;
            ObjLdgTnxDtl.typeOfTnx = "OPD-APPOINTMENT";
            ObjLdgTnxDtl.TnxTypeID = 5;
            ObjLdgTnxDtl.panelCurrencyCountryID = dataLTD[0].panelCurrencyCountryID;
            ObjLdgTnxDtl.panelCurrencyFactor = dataLTD[0].panelCurrencyFactor;

            string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
            if (string.IsNullOrEmpty(LdgTnxDtlID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In LdgTnx Details" });
            }

            if (Resources.Resource.RegistrationChargesApplicable == "1" && PatientMasterInfo[0].patientMaster.FeesPaid != 0)
            {
                var dicountPercentForRegistration = directDiscountOnBill ? ObjLdgTnxDtl.DiscountPercentage : 0;
                OPD opd = new OPD();
                opd.OPDRegistration(TransactionID, dataPMH[0].DoctorID, LedgerTransactionNo, PatientMasterInfo[0].PanelID, con, tnx, dicountPercentForRegistration, dataLTD[0].panelCurrencyFactor);
                string sql = "UPDATE `patient_master` pm SET pm.`FeesPaid`=1 WHERE pm.`PatientID`='" + PatientID + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            int AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + dataPMH[0].DoctorID.ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));

            List<docVisitDetail> visitDetail1 = AllLoadData_OPD.appVisitDetail(Util.GetDateTime(Util.GetDateTime(DateTime.Now)), Util.GetString(dataApp[0].SubCategoryID.ToString()), con);


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
                ObjApp.Age = Util.GetString(PatientMasterInfo[0].Age);
            }
            ObjApp.Email = dataPM[0].Email;
            if (dataPM[0].PatientID != "")
                ObjApp.VisitType = "Old Patient";
            else
                ObjApp.VisitType = "New Patient";
            ObjApp.TypeOfApp = dataApp[0].TypeOfApp.ToString();
            ObjApp.PatientType = dataApp[0].PatientType.ToString();
            ObjApp.Nationality = dataPM[0].Country;
            ObjApp.City = dataPM[0].City;
            ObjApp.Sex = dataPM[0].Gender;
            ObjApp.RefDocID = dataApp[0].RefDocID;
            ObjApp.PurposeOfVisit = dataApp[0].PurposeOfVisit;
            ObjApp.PurposeOfVisitID = dataApp[0].PurposeOfVisitID;
            ObjApp.Date = Util.GetDateTime(DateTime.Now);
            ObjApp.DoctorID = dataApp[0].DoctorID;
            ObjApp.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjApp.EndTime = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjApp.EntryUserID = HttpContext.Current.Session["ID"].ToString();
            ObjApp.Amount = dataApp[0].Amount;
            ObjApp.PanelID = dataApp[0].PanelID;
            ObjApp.ItemID = dataApp[0].ItemID;
            ObjApp.SubCategoryID = dataApp[0].SubCategoryID.ToString();
            if (dataPM[0].PatientID != "")
                ObjApp.PatientID = dataPM[0].PatientID;
            ObjApp.IpAddress = All_LoadData.IpAddress();
            ObjApp.AppNo = Util.GetInt(AppNo);
            ObjApp.hashCode = dataPMH[0].HashCode;
            ObjApp.IsConform = 1;
            ObjApp.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjApp.Taluka = dataPM[0].Taluka;
            ObjApp.LandMark = dataPM[0].LandMark;
            ObjApp.Place = dataPM[0].Place;
            ObjApp.District = dataPM[0].District;
            ObjApp.PinCode = dataApp[0].PinCode;
            ObjApp.Occupation = dataPM[0].Occupation;
            ObjApp.MaritalStatus = dataPM[0].MaritalStatus;
            ObjApp.Relation = dataPM[0].Relation;
            ObjApp.RelationName = dataPM[0].RelationName;
            ObjApp.TransactionID = TransactionID;
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
            ObjApp.isNewPatient = PatientMasterInfo[0].IsNewPatient;

            ObjApp.PlaceOfBirth = dataPM[0].PlaceOfBirth;
            ObjApp.IdentificationMark = dataPM[0].IdentificationMark;
            ObjApp.IsInternational = dataPM[0].IsInternational.ToString();
            ObjApp.OverSeaNumber = dataPM[0].OverSeaNumber;
            ObjApp.EthenicGroup = dataPM[0].EthenicGroup;
            ObjApp.IsTranslatorRequired = dataPM[0].IsTranslatorRequired.ToString();
            ObjApp.FacialStatus = dataPM[0].FacialStatus;
            ObjApp.Race = dataPM[0].Race;
            ObjApp.Employement = dataPM[0].Employement;
            ObjApp.MonthlyIncome = dataPM[0].MonthlyIncome.ToString();
            ObjApp.ParmanentAddress = dataPM[0].ParmanentAddress;
            ObjApp.IdentificationMarkSecond = dataPM[0].IdentificationMarkSecond;
            ObjApp.LanguageSpoken = dataPM[0].LanguageSpoken;
            ObjApp.EmergencyRelationOf = dataPM[0].EmergencyRelationOf;
            ObjApp.EmergencyRelationName = dataPM[0].EmergencyRelationName;
            ObjApp.EmergencyAddress = dataPM[0].EmergencyAddress;


            ObjApp.PhoneSTDCODE = dataPM[0].PhoneSTDCODE;
            ObjApp.ResidentialNumber = dataPM[0].ResidentialNumber;
            ObjApp.ResidentialNumberSTDCODE = dataPM[0].ResidentialNumberSTDCODE;
            ObjApp.EmergencyFirstName = dataPM[0].EmergencyFirstName;
            ObjApp.EmergencySecondName = dataPM[0].EmergencySecondName;
            ObjApp.InternationalCountryID = dataPM[0].InternationalCountryID;
            ObjApp.InternationalCountry = dataPM[0].InternationalCountry;
            ObjApp.InternationalNumber = dataPM[0].ResidentialNumber;
            ObjApp.Phone = dataPM[0].Phone;
            
            if (visitDetail1.Count > 0)
            {
                ObjApp.NextSubcategoryID = visitDetail1[0].nextSubcategoryID.ToString();
                ObjApp.DocValidityPeriod = Util.GetInt(visitDetail1[0].docValidityPeriod.ToString());
                ObjApp.nextVisitDateMax = Util.GetDateTime(visitDetail1[0].nextVisitDateMax.ToString());
                ObjApp.nextVisitDateMin = Util.GetDateTime(visitDetail1[0].nextVisitDateMin.ToString());
                ObjApp.lastVisitDateMax = Util.GetDateTime(visitDetail1[0].lastVisitDateMax.ToString());
            }
            ObjApp.IsVitalSignOnApp = dataApp[0].IsVitalSignOnApp;
            string AppID = ObjApp.Insert();
            string subID = Util.GetString(dataApp[0].SubCategoryID.ToString());


            if (string.IsNullOrEmpty(AppID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In AppointMent" });

            }

            if (dataApp[0].IsVitalSignOnApp == 1)
            {
                dynamic vitalsign = JObject.Parse(JsonConvert.SerializeObject(vitalSigns));
                var BP = vitalsign.BP;
                var Pulse = vitalsign.Pulse;
                var Resp = vitalsign.Resp;
                var Temp = vitalsign.Temp;
                var Height = vitalsign.Height;
                var Weight = vitalsign.Weight;
                var ArmSpan = vitalsign.ArmSpan;
                var SittingHeight = vitalsign.SittingHeight;
                var BMI = vitalsign.BMI;
                var IBW = vitalsign.IBW;
                var SPO2 = vitalsign.SPO2;



                excuteCMD.DML(tnx, con, "Insert into cpoe_vital (TransactionID,PatientID,BP,P,R,T,HT,WT,ArmSpan,SHight,BMI,IBWKg,SPO2,EntryBy,CentreID,Hospital_ID) values ('" + TransactionID + "','" + dataPM[0].PatientID + "',@BP,@P,@R,@T,@HT,@WT,@ArmSpan,@SHight,@BMI,@IBWKg,@SPO2,'" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetInt(Session["centreID"].ToString()) + "','" + Session["HOSPID"].ToString() + "')", CommandType.Text, new
                {
                    BP = BP,
                    P = Pulse,
                    R = Resp,
                    T = Temp,
                    HT = Height,
                    WT = Weight,
                    ArmSpan = ArmSpan,
                    SHight = SittingHeight,
                    BMI = BMI,
                    IBWKg = IBW,
                    SPO2 = SPO2,
                });

            }


           
            ////////////////////////////// Insert in Receipt ///////////////////
            int IsBill = 1;
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
                ObjReceipt.TransactionID = TransactionID;
                ObjReceipt.Naration = dataPaymentDetail[0].PaymentRemarks;
                ObjReceipt.RoundOff = dataLT[0].RoundOff;
                ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceipt.IpAddress = All_LoadData.IpAddress();
                ObjReceipt.PaidBy = "PAT";
                IsBill = 0;
                ReceiptNo = ObjReceipt.Insert();
                if (ReceiptNo == string.Empty)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Receipts" });

                }
                Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                for (int i = 0; i < dataPaymentDetail.Count; i++)
                {
                    ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                    ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                    ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                    ObjReceiptPayment.ReceiptNo = ReceiptNo;
                    ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                    ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                    ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
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
                    if (PaymentID == string.Empty)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Receipt Payment Details" });

                    }

                }
            }
           
            string notification = string.Empty;
            if (dataLTD[0].ItemID == Resources.Resource.EmergencySubcategoryID)
                notification = Notification_Insert.notificationInsert(21, AppID, tnx, dataApp[0].DoctorID, string.Empty, 52, DateTime.Now.ToString("yyyy-MM-dd"), "");
            else
                notification = Notification_Insert.notificationInsert(1, AppID, tnx, dataApp[0].DoctorID, string.Empty, 52, DateTime.Now.ToString("yyyy-MM-dd"), "");
            
            if (string.IsNullOrEmpty(notification))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Notification" });

            }

           

            //for panel advance concept
            var panelAdvancePayment = dataPaymentDetail.Where(p => p.PaymentModeID == 8).ToList();
            for (int i = 0; i < panelAdvancePayment.Count; i++)
            {
                var j = panelAdvancePayment[i];
                AllUpdate allUpdate = new AllUpdate();
                var response = allUpdate.SavePanelAdjustmentAdvance(HttpContext.Current.Session["HOSPID"].ToString(),
                Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),
                HttpContext.Current.Session["ID"].ToString(),
                HttpContext.Current.Session["ID"].ToString(),
                ReceiptNo,
                Util.GetString(dataPMH[0].PanelID),
                dataPaymentDetail[0].PaymentRemarks,
                j.Amount,
                j.PaymentMode,
                j.PaymentModeID,
                j.S_Amount,
                j.S_CountryID,
                j.S_Currency,
                j.S_Notation,
                j.C_Factor,
                j.currencyRoundOff, tnx);
                if (response == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Advance Amount is Less Then Receipt Amount ", message = "Error In Panel Account" });
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
                        advd.TransactionID = TransactionID;
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



            // For Online  Appointments Status Update 
            if (!string.IsNullOrEmpty(mobileAppAppointmentID))
            {
                excuteCMD.DML(tnx, "UPDATE  app_appointment app  SET app.IsVisited=1 WHERE app.ID=@ID", CommandType.Text,
                    new
                    {
                        ID = Util.GetInt(mobileAppAppointmentID)
                    }
                );
            }
            if (!string.IsNullOrEmpty(mobileAppAppointmentID))
            {
                excuteCMD.DML(tnx, "UPDATE app_appointment app INNER JOIN app_patient_master pm on pm.ID=app.PatientID SET pm.PatientID=@PatientID WHERE IFNULL(pm.PatientID,'')='' AND app.ID=@ID", CommandType.Text,
                    new
                    {
                        ID = Util.GetInt(mobileAppAppointmentID),
                        PatientID = Util.GetString(PatientID)
                    }
                );
            }

            //Devendra Singh 2018-10-10 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction( Util.GetInt(LedgerTransactionNo), ReceiptNo, "R", tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }
            
            /*********************Unit Doctor*****************************/
            string UnitDoctor = StockReports.ExecuteScalar("SELECT IsUnit  FROM doctor_master WHERE DoctorID='" + dataPMH[0].DoctorID + "'");
            if (UnitDoctor == "1")
            {
                DataTable dt = StockReports.GetDataTable("SELECT * FROM unit_doctorlist WHERE UnitDoctorID='" + dataPMH[0].DoctorID + "' AND ISACTIVE=1");

                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        string str = "INSERT INTO `Doctor_Unit_Detail` (TransactionID,DoctorID,Unit_doctorIDList)VALUES('" + TransactionID + "','" + Util.GetString(dataPMH[0].DoctorID) + "','" + Util.GetString(dt.Rows[i]["DoctorListId"]) + "')";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    }
                }
            }
            /************************END************************************/
            
            tnx.Commit();



            //**************** SMS************************//
            if (Resources.Resource.SMSApplicable == "1" && !String.IsNullOrEmpty(PatientMasterInfo[0].MobileNo))
            {
                var columninfo = smstemplate.getColumnInfo(1, con);
                if (columninfo.Count > 0)
                {
                    columninfo[0].PatientID = PatientID;
                    columninfo[0].PName = dataPM[0].PName;
                    columninfo[0].Title = dataPM[0].Title;
                    columninfo[0].Gender = dataPM[0].Gender;
                    columninfo[0].ContactNo = dataPM[0].PhoneSTDCODE + dataPM[0].Mobile;
                    columninfo[0].DoctorName = ObjApp.Doctor_Name;
                    columninfo[0].AppointmentDate = (ObjApp.Date).ToString("yyyy-MM-dd");
                    columninfo[0].AppointmentTime = ObjApp.AptTime.ToString("HH:mm:ss");
                    columninfo[0].TemplateID = 1;
                  //  string sms = smstemplate.getSMSTemplate(1, columninfo, 1, con, dataPMH[0].UserID);
                }
            }

            
            
            //**************** Email************************//
            if (Resources.Resource.EmailApplicable == "1" &&   !string.IsNullOrEmpty(PatientMasterInfo[0].patientMaster.Email))
            {
                var d = new EmailTemplateInfo() {
                    PatientID = PatientID,
                    PName = dataPM[0].PName,
                    Title = dataPM[0].Title,
                    Gender  = dataPM[0].Gender,
                    ContactNo = dataPM[0].Mobile,
                    DoctorName = ObjApp.Doctor_Name,
                    AppointmentDate = (ObjApp.Date).ToString("yyyy-MM-dd"),
                    AppointmentTime = ObjApp.AptTime.ToString("HH:mm:ss"),
                    EmailTo = PatientMasterInfo[0].patientMaster.Email,
                };
                List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                dd.Add(d);
                //int sendEmailID = Email_Master.SaveEmailTemplate(2, Util.GetInt(Session["RoleID"].ToString()), "1", dd,string.Empty ,null);
            }
            
            
            
            //for Skip Tempreature Room
            if (subID == Resources.Resource.EmergencyVisitSubCategoryId && subID == Resources.Resource.FollowUpVisitSubCategoryID)
            {
                excuteCMD.DML("UPDATE appointment SET TemperatureRoom=@status,tempRoomupdateBy=@tempRoomUpdateBy,tempRoomUpdateDate=now() WHERE app_Id=@appointmentID", CommandType.Text, new {
                    status=1,
                    tempRoomUpdateBy=HttpContext.Current.Session["ID"].ToString(),
                    appointmentID=AppID
                });
            }
            
            
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, LedgerTransactionNo = LedgerTransactionNo, hospledgertransactionNo = hospledgertransactionNo, PatientID = PatientID, IsBill = IsBill });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    //[WebMethod(EnableSession=true)]
    //public  string bindAppointmentDetail(string App_ID)
    //{
    //    DataTable dtAppDetail = AllLoadData_OPD.bindAppointmentDetail(App_ID);
    //    if (dtAppDetail.Rows.Count > 0)
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(dtAppDetail);
    //    else
    //        return "";
    //}


}