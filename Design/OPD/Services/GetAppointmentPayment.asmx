<%@ WebService Language="C#" Class="GetAppointmentPayment" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using Newtonsoft.Json;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class GetAppointmentPayment : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    [WebMethod]
    public string helloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string SaveAppointmentPaymentDetails(object patientMaster, object PMH, object LT, object LTD, object paymentDetail, string parentPanelID, string scheduleChargeID, string rateListID, string hashCode, string appointmentID, string appointmentDate, string doctorID, object patientDocuments, List<PanelDocument> panelDocuments)
    {
        if (string.IsNullOrEmpty(appointmentID))
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "AppointMentID Not Valid" });


        List<Patient_Master> dataPM = (List<Patient_Master>)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(patientMaster), typeof(List<Patient_Master>));
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(paymentDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ///is  int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM appointment WHERE App_ID='" + dataReg[0].App_ID + "' AND PatientID<>'' "));   for later
            var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(patientMaster, tnx, con);
            if (PatientMasterInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Master" });
            }




            PatientDocument.SaveDocument(patientDocuments, PatientMasterInfo[0].PatientID);

            var transactionId = Insert_PatientInfo.savePMH(dataPMH, PatientMasterInfo[0].PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), PatientMasterInfo[0].HospPatientType, "OPD", "Appointment", tnx, con);
            if (transactionId == "")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });

            }

            PatientDocument.SavePanelDocument(panelDocuments, transactionId, PatientMasterInfo[0].PatientID, dataPMH[0].PanelID);

            var useSeparateVisitAndBilling = Util.GetInt(Resources.Resource.UseSeparateVisitAndBilling);

            string ledgerTransactionNo = string.Empty;
            string billNo = string.Empty;
            bool IsBill = true;
            if (useSeparateVisitAndBilling == 0)
            {
                EncounterNo = Encounter.FindEncounterNo(PatientMasterInfo[0].PatientID);
                if (EncounterNo == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

                }
                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);
                ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                string LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientMasterInfo[0].PatientID, "PTNT", con);
                if (LedgerNoCr == null)
                    ObjLdgTnx.LedgerNoCr = "";
                else
                    ObjLdgTnx.LedgerNoCr = LedgerNoCr;
                ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(ObjLdgTnx.Hospital_ID, "HOSP", con);
                ObjLdgTnx.TypeOfTnx = "OPD-APPOINTMENT";
                ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjLdgTnx.NetAmount = Util.GetDecimal(dataLT[0].NetAmount);
                ObjLdgTnx.GrossAmount = Util.GetDecimal(dataLT[0].GrossAmount);
                ObjLdgTnx.PatientID = PatientMasterInfo[0].PatientID;
                ObjLdgTnx.PanelID = PatientMasterInfo[0].PanelID;
                ObjLdgTnx.TransactionID = transactionId;
                ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnx.DiscountReason = dataLT[0].DiscountReason;
                ObjLdgTnx.DiscountApproveBy = dataLT[0].DiscountApproveBy;
                ObjLdgTnx.DiscountOnTotal = dataLT[0].DiscountOnTotal;


                billNo = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);

                ObjLdgTnx.BillNo = billNo;
                if (string.IsNullOrEmpty(ObjLdgTnx.BillNo))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Generating Bill No." });
                }
                ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now);
                ObjLdgTnx.RoundOff = dataLT[0].RoundOff;
                ObjLdgTnx.PaymentModeID = dataLT[0].Adjustment > 0 ? Util.GetInt(dataPaymentDetail[0].PaymentModeID) : 4;
                ObjLdgTnx.UniqueHash = hashCode;
                ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnx.Adjustment = dataLT[0].Adjustment;
                ObjLdgTnx.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount);
                ObjLdgTnx.IsPaid = 0;
                ObjLdgTnx.IsCancel = 0;
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnx.PatientType = PatientMasterInfo[0].patientMaster.PatientType;
                ObjLdgTnx.CurrentAge = Util.GetString(dataLT[0].CurrentAge);
                ObjLdgTnx.PatientType_ID = Util.GetInt(dataLT[0].PatientType_ID);
                ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);
           
                ledgerTransactionNo = ObjLdgTnx.Insert();

                if (string.IsNullOrEmpty(ledgerTransactionNo))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Ledger Transaction" });

                }

                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = ledgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[0].ItemID);
                ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[0].Rate);
                ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[0].Quantity);
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";
                ObjLdgTnxDtl.Amount = Util.GetDecimal(dataLTD[0].Amount);
                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[0].DiscAmt);
                ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(dataLTD[0].DiscountPercentage);
                ObjLdgTnxDtl.DoctorID = doctorID;
                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = transactionId;
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[0].SubCategoryID);
                ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[0].ItemName);
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnxDtl.DiscountReason = dataLTD[0].DiscountReason;
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[0].DiscAmt);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.RateListID = Util.GetInt(rateListID);
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[0].SubCategoryID), con));
                ObjLdgTnxDtl.typeOfTnx = "OPD-APPOINTMENT";
                ObjLdgTnxDtl.roundOff = Util.GetDecimal(ObjLdgTnx.RoundOff / dataLTD.Count);
                ObjLdgTnxDtl.panelCurrencyCountryID = dataLTD[0].panelCurrencyCountryID;
                ObjLdgTnxDtl.panelCurrencyFactor = dataLTD[0].panelCurrencyFactor;



                var ldgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                if (string.IsNullOrEmpty(ldgTnxDtlID))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Ledger Transaction Details" });
                }
                if (Resources.Resource.RegistrationChargesApplicable == "1" && PatientMasterInfo[0].patientMaster.IsNewPatient == 1)
                {
                    OPD opd = new OPD();
                    opd.OPDRegistration(transactionId, doctorID, ledgerTransactionNo, PatientMasterInfo[0].PanelID, con, tnx);
                }

               


                ////////////////////////////// Insert in Receipt ///////////////////

                var receiptNo = string.Empty;
                if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (dataLT[0].Adjustment > 0))
                {
                    Receipt ObjReceipt = new Receipt(tnx);
                    ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjReceipt.AmountPaid = dataLT[0].Adjustment;
                    ObjReceipt.AsainstLedgerTnxNo = ledgerTransactionNo;
                    ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    ObjReceipt.Depositor = PatientMasterInfo[0].PatientID;
                    ObjReceipt.Discount = 0;
                    ObjReceipt.PanelID = PatientMasterInfo[0].PanelID;
                    ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                    ObjReceipt.TransactionID = transactionId;
                    ObjReceipt.RoundOff = dataLT[0].RoundOff;
                    ObjReceipt.IpAddress = All_LoadData.IpAddress();
                    ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceipt.PaidBy = "PAT";
                    IsBill = false;
                    receiptNo = ObjReceipt.Insert();
                    if (string.IsNullOrEmpty(receiptNo))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Receipt" });
                    }
                    Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                    for (int i = 0; i < dataPaymentDetail.Count; i++)
                    {
                        ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                        ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                        ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                        ObjReceiptPayment.ReceiptNo = receiptNo;
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
                        ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        string PaymentID = ObjReceiptPayment.Insert().ToString();
                        if (string.IsNullOrEmpty(PaymentID))
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Receipt Payment Details" });
                        }
                    }

                }

              

            }
            //Update Appointment Table
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE appointment SET LedgerTnxNo='" + ledgerTransactionNo + "', TransactionID='" + transactionId + "' WHERE App_ID=" + appointmentID + "");

            StringBuilder sb = new StringBuilder();
            sb.Append(" Update Appointment set PatientID='" + PatientMasterInfo[0].PatientID + "',Title='" + PatientMasterInfo[0].patientMaster.Title.Trim() + "',PlastName='" + PatientMasterInfo[0].patientMaster.PFirstName.Trim() + "',PfirstName='" + PatientMasterInfo[0].patientMaster.PLastName.Trim() + "', ");
            sb.Append(" PName='" + PatientMasterInfo[0].patientMaster.PFirstName.Trim() + " " + PatientMasterInfo[0].patientMaster.PLastName.Trim() + "',ContactNo='" + PatientMasterInfo[0].patientMaster.Mobile.Trim() + "',Email='" + PatientMasterInfo[0].patientMaster.Email.Trim() + "',Sex='" + PatientMasterInfo[0].patientMaster.Gender.Trim() + "' , ");
            if (PatientMasterInfo[0].patientMaster.Age != "")
            {
                sb.Append(" Age='" + Util.GetString(PatientMasterInfo[0].patientMaster.Age) + "' , ");
            }

            else
            {
                sb.Append(" DOB='" + (PatientMasterInfo[0].patientMaster.DOB.ToString("yyyy-MM-dd")) + "' , ");
                sb.Append(" Age='" + MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select Get_Age('" + PatientMasterInfo[0].patientMaster.DOB.ToString("yyyy-MM-dd") + "')") + "' , ");
            }
            sb.Append(" MaritalStatus='" + PatientMasterInfo[0].patientMaster.MaritalStatus + "',Address='" + PatientMasterInfo[0].patientMaster.House_No.Trim() + "',AdharCardNo='" + Util.GetString(PatientMasterInfo[0].patientMaster.AdharCardNo).Trim() + "',PatientType='" + PatientMasterInfo[0].patientMaster.PatientType + "' ,");
            sb.Append(" Nationality='" + PatientMasterInfo[0].patientMaster.Country.Trim() + "' ,City='" + PatientMasterInfo[0].patientMaster.City.Trim() + "',");
            sb.Append(" District='" + PatientMasterInfo[0].patientMaster.District.Trim() + "' ,Taluka='" + PatientMasterInfo[0].patientMaster.Taluka.Trim() + "',");
            sb.Append(" CountryID='" + PatientMasterInfo[0].patientMaster.CountryID + "' ,DistrictID='" + PatientMasterInfo[0].patientMaster.DistrictID + "',");
            sb.Append(" CityID='" + PatientMasterInfo[0].patientMaster.CityID + "' ,TalukaID='" + PatientMasterInfo[0].patientMaster.TalukaID + "' ");

            sb.Append(" ,regLedgertransactionNo='" + Util.GetInt(ledgerTransactionNo) + "', LedgerTnxNo='" + Util.GetInt(ledgerTransactionNo) + "', TransactionID='" + transactionId + "' ");
            sb.Append(" where App_ID ='" + appointmentID + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            string notification = "";
            if (dataLTD[0].ItemID == Resources.Resource.EmergencySubcategoryID)
            {
                notification = Notification_Insert.notificationInsert(21, appointmentID, tnx, doctorID, "", 52, appointmentDate);
            }
            else
            {
                notification = Notification_Insert.notificationInsert(1, appointmentID, tnx, doctorID, "", 52, appointmentDate);
            }


            if (string.IsNullOrEmpty(notification))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Notification Entry" });

            }




            if (Resources.Resource.SMSApplicable == "1")
            {
                var columninfo = smstemplate.getColumnInfo(1, con);
                if (columninfo.Count > 0)
                {
                    columninfo[0].PatientID = PatientMasterInfo[0].PatientID;
                    columninfo[0].PName = PatientMasterInfo[0].patientMaster.Title + " " + PatientMasterInfo[0].patientMaster.PName;
                    columninfo[0].Gender = PatientMasterInfo[0].patientMaster.Gender;
                    columninfo[0].Age = PatientMasterInfo[0].patientMaster.Age;
                    columninfo[0].ContactNo = PatientMasterInfo[0].MobileNo;
                    columninfo[0].TemplateID = 1;
                    //string sms = smstemplate.getSMSTemplate(1, columninfo, 1, con, HttpContext.Current.Session["ID"].ToString());
                }
            }


            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = " Record Save Successfully", ledgerTransactionNo = ledgerTransactionNo, IsBill = IsBill });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }
}