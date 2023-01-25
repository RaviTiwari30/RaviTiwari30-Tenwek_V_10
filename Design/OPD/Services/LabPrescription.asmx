<%@ WebService Language="C#" Class="LabPrescription" %>

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
using System.Linq;
using MySql.Data.MySqlClient;
using System.IO;
using Newtonsoft.Json;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Http;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class LabPrescription : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    int IsContainConsultation = 0;
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true, Description = "Save LabPrescription")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveLabPrescriptionOPD(object PM, object PMH, object LT, object LTD, object PaymentDetail, object PT, object patientDocuments, int reportDispatchModeID, bool directDiscountOnBill, string lastVisitID, List<PanelDocument> panelDocuments, string approvalRemark, string approvalAmount, int IsHelpDeskBilling, int HelpDeskBookingCentreID, int PoolNr, string PoolDesc)
    {
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        List<Patient_Test> dataPatient_Test = new JavaScriptSerializer().ConvertToType<List<Patient_Test>>(PT);
        List<PatientDocuments> patientDocumentsDetails = new JavaScriptSerializer().ConvertToType<List<PatientDocuments>>(patientDocuments);
        List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string consultationLedgerTnxIDs = string.Empty;
            if (Resources.Resource.IsInvestigationAppointment == "1")
            {
                for (int i = 0; i < dataLTD.Count; i++)
                {
                    if (dataLTD[i].CategoryID == "7")
                    {
                        string str = "SELECT COUNT(*) FROM investigation_timeslot WHERE bookdate=@bookingdate AND starttime =@starttime AND endtime =@endtime AND modalityid =@modalityid ";
                        int isBooked = Util.GetInt(excuteCMD.ExecuteScalar(tnx, str, CommandType.Text, new
                        {
                            bookingdate = Util.GetDateTime(dataLTD[i].BookingDate).ToString("yyyy-MM-dd"),
                            starttime = Util.GetDateTime(dataLTD[i].BookingTime.Split('-')[0].ToString()).ToString("HH:mm:ss"),
                            endtime = Util.GetDateTime(dataLTD[i].BookingTime.Split('-')[1].ToString()).ToString("HH:mm:ss"),
                            modalityid = dataLTD[i].BookinginModality,
                        }));
                        if (isBooked > 0)
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Slot Already Booked for '" + dataLTD[i].ItemName + "'!<br/> Kindly Select Another Slot ", message = "Slot Already booked" });
                        }
                    }
                }
            }


            int IsPatientBilling = Util.GetInt(dataLTD.Count(s => (s.isDocCollect == 0 && (s.typeOfApp == "0" || s.typeOfApp == "2"))));





            int ReferenceCodeOPD = Util.GetInt(StockReports.ExecuteScalar("SELECT pnl.`ReferenceCodeOPD` FROM f_panel_master pnl WHERE pnl.`PanelID`=" + dataPMH[0].PanelID + " "));

            //setting doctor Rate and RateListID in LTD
            dataLTD.ForEach(item =>
            {
                if (item.IsPackage == 1)
                {
                    if (item.PackageType == 2)
                    {
                        var rateDetails = AllLoadData_OPD.GetRate(item.DoctorID, item.SubCategoryID, ReferenceCodeOPD, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));

                        item.Rate = Util.GetDecimal(rateDetails.Rows[0]["Rate"]);
                        item.ItemID = rateDetails.Rows[0]["ItemID"].ToString();
                        item.RateListID = Util.GetInt(rateDetails.Rows[0]["ID"]);
                        item.rateItemCode = rateDetails.Rows[0]["ItemCode"].ToString();
                        item.CategoryID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT sc.`CategoryID` FROM `f_subcategorymaster` sc WHERE sc.`SubCategoryID`='" + item.SubCategoryID + "'"));

                        item.Type = "OPD";
                    }
                    else
                    {
                        var rateDetails = AllLoadData_OPD.GetOPDItemRate(item.ItemID, item.SubCategoryID, ReferenceCodeOPD, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));

                        item.Rate = Util.GetDecimal(rateDetails.Rows[0]["Rate"]);
                        item.RateListID = Util.GetInt(rateDetails.Rows[0]["ID"]);
                        item.rateItemCode = rateDetails.Rows[0]["ItemCode"].ToString();
                        item.CategoryID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT sc.`CategoryID` FROM `f_subcategorymaster` sc WHERE sc.`SubCategoryID`='" + item.SubCategoryID + "'"));

                        if (item.Investigation_ID != string.Empty && item.Investigation_ID != "0")
                            item.Type = "LAB";
                    }
                }
            });

            var zeroRateItemList = dataLTD.Where(i => i.Rate <= 0 && i.SubCategoryID != Resources.Resource.FollowUpVisitSubCategoryID).ToList();

            if (zeroRateItemList.Count > 0)
            {
                string zeroRateItems = string.Join(",", zeroRateItemList.Select(i => i.ItemName).ToList());

                tnx.Rollback();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Item have Zero Rate. Items Are : " + zeroRateItems, message = zeroRateItems });
            }


            string PatientID = string.Empty, TransactionId = string.Empty, LedTxnID = string.Empty, ReceiptNo = string.Empty;
            string isBloodBankItem = "0";
            string BarcodeNo = ""; string TokenRoomName = string.Empty;
            dynamic PatientMasterInfo = null;


            //Bil No Generate
            string BillNo = string.Empty;
            if (IsPatientBilling > 0)
            {
                if (Util.GetString(dataLTD[0].Type) == "BB")
                {
                    BillNo = SalesEntry.genBillNoBloodBank(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
                    isBloodBankItem = "1";
                }
                else
                {
                    BillNo = SalesEntry.genBillNo_opd(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
                    isBloodBankItem = "0";

                 
                }
                if (string.IsNullOrEmpty(BillNo))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Kindly Generate Bill No." });
                }
            }



            //Patient Master
            PatientMasterInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientMasterInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
            }
            else
                PatientID = PatientMasterInfo[0].PatientID;

            //Patient Medical History
            if (IsPatientBilling > 0)
            {
                dataPMH[0].BillNo = BillNo;
                dataPMH[0].BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                dataPMH[0].BillGeneratedBy = HttpContext.Current.Session["ID"].ToString();
                dataPMH[0].TotalBilledAmt = Util.GetDecimal(dataLT[0].GrossAmount);
                dataPMH[0].ItemDiscount = dataLT[0].DiscountOnTotal;
                dataPMH[0].NetBillAmount = Util.GetDecimal(dataLT[0].NetAmount);
                TransactionId = Insert_PatientInfo.savePMH(dataPMH, PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), PatientMasterInfo[0].HospPatientType, "OPD", "OPD-Lab", tnx, con);
                if (string.IsNullOrEmpty(TransactionId))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Medical History" });
                }
            }

            PatientDocument.SaveDocument(patientDocuments, PatientID);





            // This Part Check  for Is Encounter No Is open for the Consultaion ,IF YES THEN  SAY TO COLSE PREVIOUS ENCOUNTER NO.


            for (int i = 0; i < dataLTD.Count; i++)
            {
                if (dataLTD[i].CategoryID == "1")
                {
                    IsContainConsultation = IsContainConsultation + 1;

                    string Res = Encounter.FindEncounterNoInCaseOfConsultatioin(PatientID, tnx, con);
                    if (Res.Contains("Close"))
                    {
                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Close the previous Encounter No.", message = "Error In Encounter No." });

                    }
                    else
                    {
                        EncounterNo = Util.GetInt(Res);
                    }
                }

            }

            //
            //IN CSE OF NON CONSULTATION TYPE
            if (IsContainConsultation == 0)
            {
                EncounterNo = Encounter.FindEncounterNo(PatientID);

            }

            if (EncounterNo == 0)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }



            DateTime Nowdt = Util.GetDateTime(DateTime.Now);
            if (!Encounter.IsApprovalAmountExit(Util.GetString(dataPMH[0].PanelID), Util.GetString(PatientID), Nowdt))
            {


                if (Encounter.IsLimitOnAmountInPanel(Util.GetString(dataPMH[0].PanelID)))
                {
                    decimal CanPayUpto = Encounter.getEncounterLimit(Util.GetString(PatientID), Util.GetString(dataPMH[0].PanelID), EncounterNo, tnx, con);


                    if (CanPayUpto > 0)
                    {

                        if (Util.GetDecimal(CanPayUpto) >= Util.GetDecimal(dataPMH[0].PanelPaybleAmt))
                        {
                            int issave = Encounter.UpdateEncounterLimit(Util.GetString(PatientID), EncounterNo, Util.GetDecimal(dataPMH[0].PanelPaybleAmt), tnx, con);
                        }
                        else
                        {
                            tnx.Rollback();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can pay using this panel upto " + CanPayUpto + " ", message = "Panel Payable Amount Is More then Remaing Panel Amount Limit" });

                        }

                    }
                    else
                    {

                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Limit Exhausted", message = "limit exhausted" });

                    }

                }


            }
            else
            {
                decimal CanPayUpto = Encounter.getApprovalAmountLimit(Util.GetString(PatientID), Util.GetString(dataPMH[0].PanelID), PoolNr, Nowdt);

                if (CanPayUpto > 0)
                {

                    if (Util.GetDecimal(CanPayUpto) >= Util.GetDecimal(dataPMH[0].PanelPaybleAmt))
                    {
                        int issave = Encounter.UpdateApprovalAmt(Util.GetString(dataPMH[0].PanelID), Util.GetString(PatientID), Util.GetDecimal(dataPMH[0].PanelPaybleAmt), Nowdt, tnx, con);
                    }
                    else
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can pay using this panel upto " + CanPayUpto + " ", message = "Panel Payable Amount Is More then Remaing Panel Amount Limit" });

                    }

                }
                else if(Util.GetDecimal(dataPMH[0].PanelPaybleAmt)>0)
                {

                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Limit Exhausted", message = "limit exhausted" });

                }

            }







            if (IsPatientBilling > 0)
                PatientDocument.SavePanelDocument(panelDocuments, TransactionId, PatientID, dataPMH[0].PanelID);

            string LedgerTransactionNo = "0";
            if (IsPatientBilling > 0)
            {
                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);

                ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnx.LedgerNoCr = "OPD003";
                ObjLdgTnx.LedgerNoDr = "HOSP0001";
                ObjLdgTnx.TypeOfTnx = "OPD-BILLING";
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
                ObjLdgTnx.IPNo = Util.GetString(dataLT[0].IPNo.Trim());
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());

                ObjLdgTnx.PatientType = dataPM[0].HospPatientType;// PatientMasterInfo[0].HospPatientType;
                ObjLdgTnx.CurrentAge = Util.GetString(dataPM[0].Age);
                ObjLdgTnx.PatientType_ID = Util.GetInt(dataPM[0].PatientType_ID);
                ObjLdgTnx.FieldBoyID = Util.GetInt(dataLT[0].FieldBoyID);
                ObjLdgTnx.BillNo = BillNo;
                ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);

                ObjLdgTnx.PoolNr = PoolNr;
                ObjLdgTnx.PoolDesc = PoolDesc;

                LedgerTransactionNo = ObjLdgTnx.Insert();

                if (string.IsNullOrEmpty(LedgerTransactionNo))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In  LdgTnx" });
                }
            }
            int sampleCollectCount = 0;

            string TokenNoCat = string.Empty;
            string TokenNoSub = string.Empty;
            string token = string.Empty;
            string catid = string.Empty;
            string subcatid = string.Empty;

            int IsMobile = 0;
            string sqlDocCollect = string.Empty;
            decimal itemWiseDiscountPercent = 0;
            DataTable dtDocShareDetails = new DataTable();
            string cashCollectedDoctorID = string.Empty;
            decimal cashCollectedDocShare = 0;
            int IsRegistrationchargeInclude = 0;
            string RegistrationChargeItemID = Resources.Resource.RegistrationItemID;

            for (int i = 0; i < dataLTD.Count; i++)
            {
                IsRegistrationchargeInclude = Util.GetString(dataLTD[i].ItemID).Trim().ToUpper() == RegistrationChargeItemID ? 1 : 0;


                if (dataLTD[i].isDocCollect == 1)
                {

                    cashCollectedDoctorID = Util.GetString(dataLTD[i].Type).Trim().ToUpper() == "OPD" ? Util.GetString(dataLTD[i].Type_ID).Trim() : Util.GetString(dataLTD[i].DoctorID).Trim();

                    dtDocShareDetails = StockReports.GetDataTable(" CALL `Get_DoctorShare_Details`(" + HttpContext.Current.Session["CentreID"].ToString() + ",'" + Util.GetString(dataLTD[i].ItemID).Trim() + "','" + cashCollectedDoctorID + "','" + Util.GetString(dataLTD[i].SubCategoryID).Trim() + "'," + Util.GetDecimal(dataLTD[i].Amount) + ",1,'HOSP') ");

                    if (dtDocShareDetails.Rows.Count > 0 && dtDocShareDetails != null)
                        cashCollectedDocShare = Util.GetDecimal(dtDocShareDetails.Rows[0]["ShareAmt"].ToString());

                    sqlDocCollect = "INSERT INTO f_Doctor_Self_Collection(PatientID,TransactionID,ItemID,DoctorID,GrossAmt,DiscAmt,NetAmt,DocCollection,DocShare,HospShare,EntryDate,EntryBy,PageURL,CentreID) VALUES(@PatientID, @TransactionID, @ItemID, @DoctorID, @GrossAmt, @DiscAmt, @NetAmt, @DocCollection, @DocShare, @HospShare,NOW(), @EntryBy,@PageURL,@CentreID)";
                    excuteCMD.DML(tnx, sqlDocCollect, CommandType.Text, new
                    {
                        PatientID = PatientID,
                        TransactionID = TransactionId,
                        ItemID = Util.GetString(dataLTD[i].ItemID).Trim(),
                        DoctorID = cashCollectedDoctorID,
                        GrossAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity),
                        DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt),
                        NetAmt = Util.GetDecimal(dataLTD[i].Amount),
                        DocCollection = Util.GetDecimal(dataLTD[i].docCollectAmt),
                        DocShare = cashCollectedDocShare,
                        HospShare = Util.GetDecimal(dataLTD[i].Amount) - cashCollectedDocShare,
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        PageURL = All_LoadData.getCurrentPageName(),
                        CentreID = HttpContext.Current.Session["CentreID"].ToString()
                    });


                    string labPrescribedID = Util.GetString(dataPatient_Test[i].PatientTest_ID).Trim();
                    if (labPrescribedID != "0")
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_Test SET IsIssue=1,OPDTransactionID='" + TransactionId + "',OPDLedgertansactionNO='" + LedgerTransactionNo + "',OPDLedgerTnxID='' WHERE PatientTest_ID='" + labPrescribedID + "' ");


                    if (dataLTD[i].Type == "OPD")
                    {
                        excuteCMD.DML(tnx, "UPDATE appointment  ap SET ap.LedgerTnxNo=@ledgertransactionNo,ap.PanelID=@panelID WHERE ap.App_ID=@appointmentID", CommandType.Text, new
                        {
                            ledgertransactionNo = LedgerTransactionNo,
                            panelID = dataPMH[0].PanelID,
                            transactionID = TransactionId,
                            doctorID = cashCollectedDoctorID,
                            appointmentID = dataLTD[i].salesID
                        });
                    }

                }
                else
                {

                    string LdgTnxDtlID = string.Empty;

                    LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                    ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                    ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[i].ItemID).Trim();
                    ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[i].Rate);
                    ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                    ObjLdgTnxDtl.StockID = string.Empty;
                    ObjLdgTnxDtl.IsTaxable = "NO";

                    ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                    if (Util.GetDecimal(dataLTD[i].Rate) == 0)
                        ObjLdgTnxDtl.DiscountPercentage = 0;
                    else
                    {
                        ObjLdgTnxDtl.DiscountPercentage = (Util.GetDecimal(dataLTD[i].DiscAmt) * 100) / ((Util.GetDecimal(dataLTD[i].Rate)) * (Util.GetDecimal(dataLTD[i].Quantity)));
                        itemWiseDiscountPercent = ObjLdgTnxDtl.DiscountPercentage;
                    }
                    if (dataLTD[i].IsPackage == 0)
                        ObjLdgTnxDtl.Amount = (Util.GetDecimal(dataLTD[i].Amount)) + (((Util.GetDecimal(dataLTD[i].Amount)) * (Util.GetDecimal(dataLT[0].GovTaxPer))) / 100);
                    else
                        ObjLdgTnxDtl.Amount = 0;

                    if (ObjLdgTnxDtl.DiscountPercentage > 0)
                        ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                    ObjLdgTnxDtl.IsPackage = dataLTD[i].IsPackage;
                    if (dataLTD[i].IsPackage == 1)
                        ObjLdgTnxDtl.PackageID = dataLTD[i].PackageID;

                    ObjLdgTnxDtl.IsVerified = 1;
                    ObjLdgTnxDtl.TransactionID = TransactionId;
                    ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                    ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[i].ItemName).Trim();
                    ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                    ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    if (ObjLdgTnxDtl.TotalDiscAmt > 0)
                    {
                        ObjLdgTnxDtl.DiscountReason = dataLTD[i].DiscountReason.Trim();
                    }

                    if (Util.GetString(dataLTD[i].Type).ToUpper() == "OPD")
                        ObjLdgTnxDtl.DoctorID = dataLTD[i].Type_ID.Trim();
                    else
                        ObjLdgTnxDtl.DoctorID = dataLTD[i].DoctorID.Trim();

                    ObjLdgTnxDtl.DoctorID = dataLTD[i].DoctorID.Trim();
                    ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                    ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dataLTD[i].TnxTypeID);
                    ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                    ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                    ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                    ObjLdgTnxDtl.RateListID = dataLTD[i].RateListID;
                    ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjLdgTnxDtl.Type = "O";
                    ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                    ObjLdgTnxDtl.rateItemCode = dataLTD[i].rateItemCode.Trim();
                    ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                    ObjLdgTnxDtl.roundOff = Util.GetDecimal(dataLT[0].RoundOff / dataLTD.Count);
                    // ObjLdgTnxDtl.typeOfTnx = ObjLdgTnx.TypeOfTnx;//"OPD-LAB"

                    if (dataLTD[i].IsPackage == 1 || Util.GetString(dataLTD[i].Type).ToUpper() == "PACK")
                        ObjLdgTnxDtl.typeOfTnx = "OPD-Package";
                    else if (Util.GetString(dataLTD[i].Type).ToUpper() == "LAB")
                        ObjLdgTnxDtl.typeOfTnx = "OPD-LAB";
                    else if (Util.GetInt(dataLTD[i].TnxTypeID) == 16)
                        ObjLdgTnxDtl.typeOfTnx = "Pharmacy-Issue";
                    else if (Util.GetString(dataLTD[i].Type).ToUpper() == "PRO")
                        ObjLdgTnxDtl.typeOfTnx = "OPD-PROCEDURE";
                    else if (Util.GetString(dataLTD[i].Type).ToUpper() == "OPD")
                        ObjLdgTnxDtl.typeOfTnx = "OPD-APPOINTMENT";
                    else if (Util.GetString(dataLTD[i].Type).ToUpper() == "BB")
                        ObjLdgTnxDtl.typeOfTnx = "OPD BB ISSUE";
                    else
                        ObjLdgTnxDtl.typeOfTnx = "OPD-OTHERS";

                    ObjLdgTnxDtl.CoPayPercent = dataLTD[i].CoPayPercent;
                    ObjLdgTnxDtl.IsPayable = dataLTD[i].IsPayable;
                    ObjLdgTnxDtl.isPanelWiseDisc = dataLTD[i].isPanelWiseDisc;
                    ObjLdgTnxDtl.panelCurrencyCountryID = dataLTD[0].panelCurrencyCountryID;
                    ObjLdgTnxDtl.panelCurrencyFactor = dataLTD[0].panelCurrencyFactor;
                    ObjLdgTnxDtl.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    ObjLdgTnxDtl.salesID = dataLTD[i].salesID;
                    ObjLdgTnxDtl.ServiceItemID = "0";
                    ObjLdgTnxDtl.IPDCaseTypeID = "0";
                    ObjLdgTnxDtl.RoomID = "0";


                    var BookingDate = DateTime.Now.ToString("yyyy-MM-dd");

                    if (Resources.Resource.IsTokenReceipt == "1")
                    {
                        string subcategoryid = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                        string categoryId = Util.GetString(dataLTD[i].CategoryID);
                        string modalityID = Util.GetString(dataLTD[i].BookinginModality);
                        token = GetTokenType(tnx, categoryId);
                        if (token == "Category")
                        {
                            subcategoryid = string.Empty;
                        }

                        if (dataLTD[i].BookingDate != "undefined")
                            BookingDate = Util.GetDateTime(dataLTD[i].BookingDate).ToString("yyyy-MM-dd") == "" ? DateTime.Now.ToString("yyyy-MM-dd") : Util.GetDateTime(dataLTD[i].BookingDate).ToString("yyyy-MM-dd");
                        if (!string.IsNullOrEmpty(token))
                        {
                            if (token == "Category")
                            {
                                if (catid != categoryId)
                                {
                                    catid = categoryId;
                                    TokenNoCat = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_Token_No('" + categoryId + "','" + subcategoryid + "','" + BookingDate + "','0'," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                                }
                                TokenRoomName = AllLoadData_OPD.getTokenRoom(tnx, categoryId, subcategoryid, "0", Util.GetInt(HttpContext.Current.Session["CentreID"]));
                            }
                            else if (token == "SubCategory")
                            {
                                if (catid != categoryId && subcatid != subcategoryid && Resources.Resource.IsInvestigationAppointment == "0")
                                {
                                    subcatid = subcategoryid;
                                    TokenNoSub = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_Token_No('" + categoryId + "','" + subcategoryid + "','" + BookingDate + "','" + modalityID + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                                }
                                if (Resources.Resource.IsInvestigationAppointment == "1")
                                {
                                    TokenNoSub = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_Token_No_Inv_Appointment('" + subcategoryid + "','" + modalityID + "','" + Util.GetDateTime(BookingDate).DayOfWeek.ToString() + "','" + dataLTD[i].BookingTime + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                                }
                                TokenRoomName = AllLoadData_OPD.getTokenRoom(tnx, categoryId, subcategoryid, modalityID, Util.GetInt(HttpContext.Current.Session["CentreID"])); ;

                            }
                        }
                    }
                    if (!string.IsNullOrEmpty(token))
                    {
                        if (token == "Category")
                        {
                            ObjLdgTnxDtl.TokenNo = TokenNoCat;
                        }
                        else if (token == "SubCategory")
                        {
                            ObjLdgTnxDtl.TokenNo = TokenNoSub;
                        }
                    }
                    else
                    {
                        ObjLdgTnxDtl.TokenNo = string.Empty;
                    }





                    //For Consumables Entry
                    if (ObjLdgTnxDtl.TnxTypeID == 16)
                    {

                        if (string.IsNullOrEmpty(ObjLdgTnxDtl.salesID))
                        {
                            tnx.Rollback();
                            con.Dispose();
                            tnx.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Sales ID Not Found." });

                        }


                        var dtItem = excuteCMD.GetDataTable("SELECT st.StockID,f.BatchNo, st.IsExpirable,f.medExpiryDate,st.PurTaxPer,st.IGSTPercent,st.CGSTPercent,st.SGSTPercent,st.UnitPrice,st.HSNCode FROM f_salesdetails f INNER JOIN f_stock st ON f.StockID=st.StockID WHERE f.SalesID=@salesID;", CommandType.Text, new
                        {
                            salesID = ObjLdgTnxDtl.salesID
                        });


                        if (dtItem.Rows.Count < 1)
                        {
                            tnx.Rollback();
                            con.Dispose();
                            tnx.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Sales Details Not Found." });
                        }



                        ObjLdgTnxDtl.StockID = Util.GetString(dtItem.Rows[0]["StockID"].ToString());
                        ObjLdgTnxDtl.IsExpirable = Util.GetInt(dtItem.Rows[0]["IsExpirable"].ToString());
                        ObjLdgTnxDtl.medExpiryDate = Util.GetDateTime(dtItem.Rows[0]["medExpiryDate"]);
                        ObjLdgTnxDtl.BatchNumber = Util.GetString(dtItem.Rows[0]["BatchNo"]);
                        ObjLdgTnxDtl.StoreLedgerNo = "STO00001";

                        decimal igstPercent = Util.GetDecimal(dtItem.Rows[0]["IGSTPercent"]);
                        decimal csgtPercent = Util.GetDecimal(dtItem.Rows[0]["CGSTPercent"]);
                        decimal sgstPercent = Util.GetDecimal(dtItem.Rows[0]["SGSTPercent"]);





                        ObjLdgTnxDtl.PurTaxPer = Util.GetDecimal(dtItem.Rows[0]["PurTaxPer"]);
                        if (Util.GetDecimal(dtItem.Rows[0]["PurTaxPer"]) > 0)
                            ObjLdgTnxDtl.PurTaxAmt = Util.GetDecimal(Util.GetDecimal(ObjLdgTnxDtl.Amount) * Util.GetDecimal(dtItem.Rows[0]["PurTaxPer"])) / 100;
                        else
                            ObjLdgTnxDtl.PurTaxAmt = 0;
                        ObjLdgTnxDtl.unitPrice = Util.GetDecimal(dtItem.Rows[0]["UnitPrice"]);

                        //GST Changes


                        decimal nonTaxableRate = (ObjLdgTnxDtl.Rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                        decimal discount = ObjLdgTnxDtl.Rate * ObjLdgTnxDtl.DiscountPercentage / 100;
                        decimal taxableAmt = ((ObjLdgTnxDtl.Rate - discount) * 100 * ObjLdgTnxDtl.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                        decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                        decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                        decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
                        ObjLdgTnxDtl.HSNCode = Util.GetString(dtItem.Rows[0]["HSNCode"]);
                        ObjLdgTnxDtl.IGSTPercent = igstPercent;
                        ObjLdgTnxDtl.IGSTAmt = IGSTTaxAmount;
                        ObjLdgTnxDtl.CGSTPercent = csgtPercent;
                        ObjLdgTnxDtl.CGSTAmt = CGSTTaxAmount;
                        ObjLdgTnxDtl.SGSTPercent = sgstPercent;
                        ObjLdgTnxDtl.SGSTAmt = SGSTTaxAmount;

                    }




                    if (dataLTD[i].typeOfApp == "0" || dataLTD[i].typeOfApp == "2")
                    {
                        LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();





                        if (string.IsNullOrEmpty(LdgTnxDtlID))
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In LdgTnx Details" });
                        }
                        if (dataLTD[i].typeOfApp == "2")
                        {
                            consultationLedgerTnxIDs = consultationLedgerTnxIDs + LdgTnxDtlID + "#";
                        }
                    }
                    excuteCMD.DML(tnx, " UPDATE f_ledgertnxdetail SET TokenRoomName=@roomName  WHERE ID=@id ", CommandType.Text, new
                    {
                        roomName = TokenRoomName,
                        id = LdgTnxDtlID
                    });
                    //For Consumables Entry
                    if (ObjLdgTnxDtl.TnxTypeID == 16)
                    {
                        // DiscAmt WHERE s.StockID=@salesID 
                        var response = excuteCMD.DML(tnx, "UPDATE f_salesdetails s SET s.LedgertransactionNo=@ledgertransactionNo,s.LedgerTnxNo=@ledgerTnxNo,s.BillNo=@billNo,s.IGSTAmt=@IGSTAmt,s.IGSTPercent=@IGSTPercent,s.CGSTPercent=@CGSTPercent,s.CGSTAmt=@CGSTAmt,s.SGSTAmt=@SGSTAmt,s.SGSTPercent=@SGSTPercent,s.DisPercent=@DisPercent,s.DiscAmt=@DiscAmt WHERE s.SalesID=@salesID", CommandType.Text, new
                         {
                             ledgertransactionNo = LedgerTransactionNo,
                             ledgerTnxNo = LdgTnxDtlID,
                             billNo = BillNo,
                             IGSTAmt = ObjLdgTnxDtl.IGSTAmt,
                             IGSTPercent = ObjLdgTnxDtl.IGSTPercent,
                             CGSTPercent = ObjLdgTnxDtl.CGSTPercent,
                             CGSTAmt = ObjLdgTnxDtl.CGSTAmt,
                             SGSTAmt = ObjLdgTnxDtl.SGSTAmt,
                             SGSTPercent = ObjLdgTnxDtl.SGSTPercent,
                             DisPercent = ObjLdgTnxDtl.DiscountPercentage,
                             DiscAmt = ObjLdgTnxDtl.DiscAmt,
                             salesID = ObjLdgTnxDtl.salesID
                         });


                        if (Util.GetInt(response) < 1)
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Sales Details" });


                    }

                    if (dataLTD[i].Type == "LAB")
                    {
                        Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                        objPLI.Investigation_ID = dataLTD[i].Type_ID;
                        if (dataLTD[i].IsPackage == 0)
                            objPLI.IsUrgent = Util.GetInt(dataPatient_Test[i].IsUrgent);
                        else
                            objPLI.IsUrgent = 0;

                        objPLI.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        objPLI.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                        objPLI.Lab_ID = "LAB1";
                        objPLI.DoctorID = dataPMH[0].DoctorID.Trim();
                        objPLI.TransactionID = TransactionId;
                        string sampletypedetail = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(im.sampletypename,'#',im.SampleTypeID,'#',IFNULL(OutSourceLabID,'0')) FROM investigation_master im WHERE im.Investigation_Id='" + dataLTD[i].Type_ID + "'"));

                        if (BarcodeNo == "")
                            BarcodeNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                        objPLI.BarcodeNo = BarcodeNo;
                        if (BarcodeNo == "0")
                            objPLI.PrePrintedBarcode = 1;
                        string sampleType = dataLTD[i].sampleType;
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
                            //objPLI.SampleReceiveDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                            //objPLI.SampleReceivedBy = HttpContext.Current.Session["ID"].ToString();
                            //objPLI.SampleReceiver = HttpContext.Current.Session["LoginName"].ToString();
                        }
                        string[] stringList = Resources.Resource.HistoCytoSubcategoryID.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                        if (stringList.Contains(dataLTD[i].SubCategoryID))
                        {
                            objPLI.HistoCytoSampleDetail = 1;
                        }
                        objPLI.CurrentAge = dataLT[0].CurrentAge;
                        objPLI.PatientID = PatientID;
                        objPLI.Special_Flag = 0;
                        objPLI.LedgerTransactionNo = LedgerTransactionNo;
                        objPLI.IPNo = Util.GetString(dataLT[0].IPNo.Trim());
                        objPLI.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objPLI.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objPLI.LedgerTnxID = Util.GetInt(LdgTnxDtlID);
                        //   objPLI.CurrentAge = Util.GetString(PatientMasterInfo[0].Age);
                        objPLI.CurrentAge = Util.GetString(dataPM[0].Age);
                        objPLI.OutSourceLabID = 0;
                        if (dataLTD[i].IsOutSource == 1)
                        {
                            objPLI.IsOutSource = 1;
                            objPLI.OutSourceBy = HttpContext.Current.Session["ID"].ToString();
                            objPLI.OutsourceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                            objPLI.OutSourceLabID = Util.GetInt(sampletypedetail.Split('#')[2]);
                        }
                        objPLI.ReportDispatchModeID = reportDispatchModeID;
                        objPLI.Type = 1;
                        objPLI.BookingCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objPLI.IPDCaseTypeID = "0";
                        objPLI.RoomID = "0";
                        objPLI.Remarks = dataLTD[i].Remark;
                        objPLI.BookingDate = Util.GetDateTime(Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"));
                        objPLI.BookingTime = Util.GetString(dataLTD[i].BookingTime) == "undefined" ? "" : Util.GetString(dataLTD[i].BookingTime);

                        int resultPLI = objPLI.Insert();
                        if (resultPLI == 0)
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient LAB Investingation" });
                        }

                    }

                    if (Resources.Resource.IsInvestigationAppointment == "1" && dataLTD[i].Type == "LAB")
                    {
                        var startdate = ""; var enddate = "";
                        if (dataLTD[i].BookingTime != "undefined")
                        {
                            startdate = dataLTD[i].BookingTime.Split('-')[0].ToString() == "" ? "" : dataLTD[i].BookingTime.Split('-')[0].ToString();
                            enddate = dataLTD[i].BookingTime.Split('-')[0].ToString() == "" ? "" : dataLTD[i].BookingTime.Split('-')[1].ToString();
                        }
                        else
                        {
                            startdate = System.DateTime.Now.ToString();
                            enddate = System.DateTime.Now.ToString();
                        }
                        string sb = "INSERT INTO investigation_timeslot (SubCategoryID,ItemID,DoctorID,CentreID,BookDate,StartTime,EndTime,IsOnlineBooking,PatientID,BookingID,TransactionID,ModalityID) "
                                   + " VALUES(@subcategoryId,@ItemID,@DoctorID,@centreId,@BookingDate,@startDate,@endDate,@isonlinebooking,@patientID,@LdgTnxDtlID,@TransactionID,@ModalityID)";
                        excuteCMD.DML(tnx, sb, CommandType.Text, new
                        {
                            subcategoryId = dataLTD[i].SubCategoryID,
                            ItemID = dataLTD[i].ItemID,
                            DoctorID = dataLTD[i].DoctorID,
                            centreId = '1',
                            BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                            startDate = Util.GetDateTime(startdate).ToString("HH:mm:ss"),
                            endDate = Util.GetDateTime(enddate).ToString("HH:mm:ss"),
                            isonlinebooking = '1',
                            patientID = PatientID,
                            LdgTnxDtlID = LdgTnxDtlID,
                            TransactionID = TransactionId,
                            ModalityID = dataLTD[i].BookinginModality,
                        });
                    }





                    if (dataLTD[i].IsPackage == 0)
                    {
                        string labPrescribedID = Util.GetString(dataPatient_Test[i].PatientTest_ID).Trim();
                        if (labPrescribedID != "0" && Util.GetInt(dataLTD[i].isMobileBooking) == 0)
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_Test SET IsIssue=1,OPDTransactionID='" + TransactionId + "',OPDLedgertansactionNO='" + LedgerTransactionNo + "',OPDLedgerTnxID='" + LdgTnxDtlID + "' WHERE PatientTest_ID='" + labPrescribedID + "' ");

                        if (labPrescribedID != "0" && Util.GetInt(dataLTD[i].isMobileBooking) == 1)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_investigationbooking inv set inv.IsPrescribe=1 where inv.ID='" + labPrescribedID + "' ");
                            if (IsMobile == 0)
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_investigationbooking inv inner join app_patient_master pm on pm.ID=inv.PatientID set pm.PatientID='" + PatientID + "' where ifnull(pm.PatientID,'')='' AND inv.ID='" + labPrescribedID + "' ");

                            IsMobile = 1;

                        }
                    }
                    if (dataLTD[i].Type == "OPD")
                    {
                        //------------Insert into Examination Room Start----------
                        int isGerenareExaminationToken = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT isExamTokenGenerate FROM `doctor_master` WHERE DoctorID='" + dataPMH[0].DoctorID.ToString() + "' "));
                        if (Util.GetString(dataLTD[0].SubCategoryID.ToString()) != Resources.Resource.FollowUpVisitSubCategoryID.ToString() && Util.GetString(dataLTD[0].SubCategoryID.ToString()) != Resources.Resource.EmergencyVisitSubCategoryId.ToString() && isGerenareExaminationToken == 1)
                        {
                            int ExamtokenNo = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT (IFNULL(MAX(ExaminationTokenNo),0)+1) Token FROM f_ExaminationToken where TodaysDate=CURDATE()", CommandType.Text, new { }));
                            if (ExamtokenNo != 0)
                            {
                                string str = "insert into f_ExaminationToken(PatientID,TransactionID,ExaminationTokenNo,CallStatus,TodaysDate,GeneratedBy) values(@PatientID,@TransactionID,@ExaminationTokenNo,0,CURDATE(),@UserID);";
                                excuteCMD.DML(tnx, str, CommandType.Text, new
                                {
                                    PatientID = PatientID,
                                    TransactionID = TransactionId,
                                    ExaminationTokenNo = ExamtokenNo,
                                    UserID = HttpContext.Current.Session["ID"].ToString(),
                                });
                            }
                        }
                        //------------Insert into Examination Room END ----------
                        if (dataLTD[i].appointmentID == 0)
                        {
                            string appointmentDate = string.Empty;
                            string appointmentTime = string.Empty;
                            if (dataLTD[i].IsPackage == 0)
                            {
                                appointmentDate = dataLTD[i].appointmentDateTime.Split('#')[0].Trim();
                                appointmentTime = dataLTD[i].appointmentDateTime.Split('#')[1].Trim();
                            }
                            else
                            {
                                if (dataLTD[i].IsSlotWiseToken == 1)
                                {
                                    appointmentDate = dataLTD[i].appointmentDateTime.Split('#')[0].Trim();
                                    appointmentTime = dataLTD[i].appointmentDateTime.Split('#')[1].Trim();
                                }
                                else
                                {
                                    appointmentDate = DateTime.Now.ToString();
                                }
                            }
                            int AppNo = 0;
                            if (dataLTD[i].IsSlotWiseToken == 0)
                            {
                                AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + dataLTD[i].Type_ID.ToString() + "','" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "','" + (IsHelpDeskBilling == 1 ? HelpDeskBookingCentreID : Util.GetInt(HttpContext.Current.Session["CentreID"].ToString())) + "')"));
                            }
                            else
                            {
                                AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_Token_No_Doctor_Appointment('" + dataLTD[i].Type_ID.ToString() + "','" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "','" + appointmentTime + "','" + (IsHelpDeskBilling == 1 ? HelpDeskBookingCentreID : Util.GetInt(HttpContext.Current.Session["CentreID"].ToString())) + "')"));
                            }

                            dataLTD[i].AppointmentNo = AppNo;

                            List<docVisitDetail> visitDetail1 = AllLoadData_OPD.appVisitDetail(DateTime.Now, Util.GetString(dataLTD[i].SubCategoryID), con);
                            appointment ObjApp = new appointment(tnx);
                            ObjApp.Title = dataPM[0].Title;
                            ObjApp.PfirstName = dataPM[0].PFirstName;
                            ObjApp.plastName = dataPM[0].PLastName;
                            ObjApp.Pname = dataPM[0].PName;
                            ObjApp.ContactNo = dataPM[0].Mobile;
                            //ObjApp.DOB = Util.GetDateTime(dataPM[0].DOB.ToString("yyyy-MM-dd"));
                            //ObjApp.Age = PatientMasterInfo[0].Age;
                            if (!(string.IsNullOrEmpty(dataPM[0].Age)))
                                ObjApp.Age = dataPM[0].Age;
                            else
                                ObjApp.Age = Util.GetString(excuteCMD.ExecuteScalar("SELECT Get_Age(@dateOfBirth)", new { dateOfBirth = dataPM[0].DOB.ToString("yyyy-MM-dd") }));
                            ObjApp.DOB = dataPM[0].DOB;

                            ObjApp.Email = dataPM[0].Email;
                            if (dataPM[0].PatientID != "")
                                ObjApp.VisitType = "Old Patient";
                            else
                                ObjApp.VisitType = "New Patient";

                            ObjApp.Address = dataPM[0].House_No;
                            ObjApp.TypeOfApp = Util.GetString(dataLTD[i].typeOfApp);
                            ObjApp.PatientType = dataPMH[0].patient_type.ToString();
                            ObjApp.Nationality = dataPM[0].Country;
                            ObjApp.City = dataPM[0].City;
                            ObjApp.Sex = dataPM[0].Gender;
                            ObjApp.RefDocID = "";
                            ObjApp.PurposeOfVisit = "";
                            ObjApp.PurposeOfVisitID = 0;
                            ObjApp.Date = Util.GetDateTime(appointmentDate);
                            ObjApp.DoctorID = dataLTD[i].Type_ID.ToString();
                            if (dataLTD[i].IsPackage == 0 || (dataLTD[i].IsPackage == 1 && dataLTD[i].IsSlotWiseToken == 1))
                            {
                                ObjApp.Time = Util.GetDateTime(appointmentTime.Split('-')[0]);
                                ObjApp.EndTime = Util.GetDateTime(appointmentTime.Split('-')[1]);
                            }
                            else
                            {
                                ObjApp.Time = Util.GetDateTime(DateTime.Now);
                                ObjApp.EndTime = Util.GetDateTime(DateTime.Now);
                            }
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
                            // ObjApp.IsConform = 1;

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
                            if (Util.GetString(dataLTD[i].typeOfApp) == "2")
                            {
                                ObjApp.IsConform = 1;
                                ObjApp.ConformDate = Util.GetDateTime(DateTime.Now);
                                ObjApp.ConformBy = HttpContext.Current.Session["ID"].ToString();
                            }

                            ObjApp.CentreID = IsHelpDeskBilling == 1 ? HelpDeskBookingCentreID : Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            ObjApp.AdharCardNo = dataPM[0].AdharCardNo;
                            ObjApp.District = dataPM[0].District;
                            ObjApp.CountryID = dataPM[0].CountryID;
                            ObjApp.DistrictID = dataPM[0].DistrictID;
                            ObjApp.CityID = dataPM[0].CityID;
                            ObjApp.TalukaID = dataPM[0].TalukaID;
                            ObjApp.State = dataPM[0].State;
                            ObjApp.StateID = dataPM[0].StateID;

                            if (visitDetail1.Count > 0)
                            {
                                ObjApp.NextSubcategoryID = visitDetail1[0].nextSubcategoryID.ToString();
                                ObjApp.DocValidityPeriod = Util.GetInt(visitDetail1[0].docValidityPeriod.ToString());
                                ObjApp.nextVisitDateMax = Util.GetDateTime(visitDetail1[0].nextVisitDateMax.ToString());
                                ObjApp.nextVisitDateMin = Util.GetDateTime(visitDetail1[0].nextVisitDateMin.ToString());
                                ObjApp.lastVisitDateMax = Util.GetDateTime(visitDetail1[0].lastVisitDateMax.ToString());
                            }
                            ObjApp.IsInternational = Util.GetString(dataPM[0].IsInternational);
                            ObjApp.ReferenceCodeOPD = ReferenceCodeOPD;
                            ObjApp.ScheduleChargeID = dataPMH[0].ScheduleChargeID;
                            string AppID = ObjApp.Insert();

                            if (AppID != "")
                            {
                                var Isreview = "True";
                                DateTime regidate = Util.GetDateTime(DateTime.Now);
                                TimeSpan regiTime = TimeSpan.Parse(DateTime.Now.ToString("HH:mm:ss"));
                                string dd = dataPM[0].Gender.Substring(0, 1);

                                if (dataPM[0].PatientID != "")
                                {
                                    Isreview = "False";
                                    DataTable dataregidetails = StockReports.GetDataTable("SELECT DateEnrolled, DATE_FORMAT(DateEnrolled,'%Y-%m-%d')RegiDate,TIME_FORMAT(DateEnrolled,'%H:%i:%s')RegiTime FROM patient_master pm WHERE  patientid='" + dataPM[0].PatientID + "'");
                                    regidate = Util.GetDateTime(dataregidetails.Rows[0]["RegiDate"]);
                                    regiTime = TimeSpan.Parse(Util.GetString(dataregidetails.Rows[0]["RegiTime"]));
                                }


                                if (dataLTD[i].IsPackage == 0 || (dataLTD[i].IsPackage == 1 && dataLTD[i].IsSlotWiseToken == 1))
                                { ObjApp.Time = Util.GetDateTime(appointmentTime.Split('-')[0]); }
                                else { ObjApp.Time = Util.GetDateTime(DateTime.Now); }


                                string DocSpecility = Util.GetString(StockReports.ExecuteScalar("Select ifnull(Designation,'')Designation from doctor_master where doctorID=" + dataLTD[i].Type_ID + ""));
                                if (DocSpecility == "OPHTHAL" || DocSpecility == "DENTAL")
                                {
                                    var str = "INSERT INTO APIConsultationsendToNetram(PK_VisitId,FK_BranchId,FK_RegId,VisitDate,VisitTime,ApptTime,Initial,FirstName,LastName,CareOfType,CareOfName,DOB,Sex,MobileNo,EmailAddress,Address,FK_DoctorId,IsReview,FK_AppointmentId,Remarks,EntryBy,EntryDate,TransactionID,Ledgertransactionno,LedgertnxID,Age,RegDate,RegTime,Speciality,DoctorName)";
                                    str += "                                    values(@PK_VisitId,@FK_BranchId,@FK_RegId,@VisitDate,@VisitTime,@ApptTime,@Initial,@FirstName,@LastName,@CareOfType,@CareOfName,@DOB,@Sex,@MobileNo,@EmailAddress,@Address,@FK_DoctorId,@IsReview,@FK_AppointmentId,@Remarks,@EntryBy,Now(),@TransactionID,@Ledgertransactionno,@LedgertnxID,@Age,@RegDate,@RegTime,@Speciality,@DoctorName)";

                                    excuteCMD.DML(tnx, str, CommandType.Text, new
                                    {
                                        PK_VisitId = Util.GetString(dataPMH[0].BillNo),
                                        FK_BranchId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),
                                        FK_RegId = Util.GetString(PatientID),
                                        VisitDate = Util.GetDateTime(appointmentDate),
                                        VisitTime = ObjApp.Time,
                                        ApptTime = ObjApp.Time,
                                        Initial = Util.GetString(dataPM[0].Title),
                                        FirstName = Util.GetString(dataPM[0].PFirstName),
                                        LastName = Util.GetString(dataPM[0].PLastName),
                                        CareOfType = Util.GetString(dataPM[0].Relation),
                                        CareOfName = Util.GetString(dataPM[0].RelationName),
                                        DOB = Util.GetDateTime(dataPM[0].DOB),
                                        Sex = dataPM[0].Gender.Substring(0, 1),
                                        MobileNo = Util.GetString(dataPM[0].Mobile),
                                        EmailAddress = Util.GetString(dataPM[0].Email),
                                        Address = Util.GetString(dataPM[0].House_No),
                                        FK_DoctorId = Util.GetInt(dataLTD[i].Type_ID.ToString()),
                                        IsReview = Util.GetString(Isreview),
                                        FK_AppointmentId = Util.GetInt(AppID),
                                        Remarks = "",
                                        EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                                        TransactionID = Util.GetString(TransactionId),
                                        Ledgertransactionno = Util.GetString(LedgerTransactionNo),
                                        LedgertnxID = Util.GetString(LdgTnxDtlID),
                                        Age = Util.GetString(dataPM[0].Age),
                                        RegDate = regidate.ToString("yyyy-MM-dd"),
                                        RegTime = regiTime,//TimeSpan.Parse(regiTime.ToString("HH:mm:ss"))
                                        Speciality = Util.GetString(DocSpecility),
                                        DoctorName = Util.GetString(dataLTD[i].ItemName)

                                    });
                                }



                            }

                            string notification = Notification_Insert.notificationInsert(1, AppID, tnx, Util.GetString(dataLTD[i].DoctorID), "", 52, DateTime.Now.ToString("yyyy-MM-dd"), "");
                            if (string.IsNullOrEmpty(AppID))
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Consultation" });

                            }
                        }
                        else
                        {
                            string str = "SELECT MAX(ap.OPDVisitNo)+1 FROM    appointment ap WHERE ap.`IsConform`=1 ";
                            int OPDVisitNo = Util.GetInt(excuteCMD.ExecuteScalar(tnx, str, CommandType.Text, new { }));
                            
                            StringBuilder sb = new StringBuilder();
                            sb.Append("UPDATE   appointment SET OPDVisitNo=@OPDVisitNo, PatientID  = @PatientID  ,Title  = @Title  ,PlastName  = @PlastName  ,PfirstName  = @PfirstName  ,Pname  = @Pname  ,DOB  = @DOB  , ");
                            sb.Append("Age  = @Age  ,TransactionID  = @TransactionID  ,IpAddress  = @IpAddress  ,MaritalStatus  = @MaritalStatus  ,Sex  = @Sex  ,ContactNo  = @ContactNo  , ");
                            sb.Append("Email  = @Email  ,City  = @City  ,RefDocID  = @RefDocID , ");
                            sb.Append("IsConform  = @IsConform  ,ConformDate  = @ConformDate  ,PanelID  = @PanelID  ,Amount  = @Amount  , ");
                            sb.Append("LedgerTnxNo  = @LedgerTnxNo  ,Address  = @Address  ,Taluka  = @Taluka  ,LandMark  = @LandMark  ,Place  = @Place  ,District  = @District  , ");
                            sb.Append("PinCode  = @PinCode  ,Occupation  = @Occupation  ,AdharCardNo  = @AdharCardNo  , ");
                            sb.Append("CentreID  = @CentreID  ,countryID  = @countryID  ,districtID  = @districtID  ,cityID  = @cityID  ,talukaID  = @talukaID  , ");
                            sb.Append("RateListID  = @RateListID  ,ConformBy  = @ConformBy  ,regLedgertransactionNo  = @regLedgertransactionNo  ,State  = @State  , ");
                            sb.Append("ScheduleChargeID  = @ScheduleChargeID  ,ReferenceCodeOPD  = @ReferenceCodeOPD  , ");
                            sb.Append("BookingCentreID  = @BookingCentreID  ,IsInternational  = @IsInternational  , ");
                            sb.Append("EmergencyRelationOf  = @EmergencyRelationOf  ,EmergencyRelationShip  = @EmergencyRelationShip  ,EmergencyPhoneNo  = @EmergencyPhoneNo  , ");
                            sb.Append("InternationalCountryID  = @InternationalCountryID  ,InternationalCountry  = @InternationalCountry  ,InternationalNumber  = @InternationalNumber  , ");
                            sb.Append("Phone  = @Phone  ,EmergencyAddress  = @EmergencyAddress  ");
                            sb.Append("where App_ID  = @App_ID; ");
                            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                            {
                                PatientID = PatientID,
                                Title = dataPM[0].Title,
                                PlastName = dataPM[0].PLastName,
                                PfirstName = dataPM[0].PFirstName,
                                Pname = dataPM[0].PName,
                                DOB = Util.GetDateTime(dataPM[0].DOB).ToString("yyyy-MM-dd"),
                                Age = dataPM[0].Age,
                                TransactionID = TransactionId,
                                IpAddress = "",
                                MaritalStatus = dataPM[0].MaritalStatus,
                                Sex = dataPM[0].Gender,
                                ContactNo = dataPM[0].Mobile,
                                Email = dataPM[0].Email,
                                City = dataPM[0].City,
                                RefDocID = dataPMH[0].ReferedBy,
                                IsConform = 1,
                                ConformDate = DateTime.Now.ToString("yyyy-MM-dd"),
                                PanelID = dataPMH[0].PanelID,
                                Amount = dataLTD[i].Rate,
                                LedgerTnxNo = LedgerTransactionNo,
                                Address = dataPM[0].ParmanentAddress,
                                Taluka = dataPM[0].Taluka,
                                LandMark = dataPM[0].LandMark,
                                Place = dataPM[0].Place,
                                District = dataPM[0].District,
                                PinCode = dataPM[0].PinCode,
                                Occupation = dataPM[0].Occupation,
                                AdharCardNo = dataPM[0].AdharCardNo,
                                CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                                countryID = dataPM[0].CountryID,
                                districtID = dataPM[0].DistrictID,
                                cityID = dataPM[0].CityID,
                                talukaID = dataPM[0].TalukaID,
                                RateListID = dataLTD[i].RateListID,
                                ConformBy = HttpContext.Current.Session["ID"].ToString(),
                                regLedgertransactionNo = LedgerTransactionNo,
                                State = dataPM[0].State,
                                ScheduleChargeID = dataPMH[0].ScheduleChargeID,
                                ReferenceCodeOPD = dataPMH[0].ScheduleChargeID,
                                BookingCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                                IsInternational = dataPM[0].IsInternational,
                                EmergencyRelationOf = dataPM[0].EmergencyRelationOf,
                                EmergencyRelationShip = dataPM[0].EmergencyRelationShip,
                                EmergencyPhoneNo = dataPM[0].EmergencyPhoneNo,
                                InternationalCountryID = dataPM[0].InternationalCountryID,
                                InternationalCountry = dataPM[0].InternationalCountry,
                                InternationalNumber = dataPM[0].InternationalNumber,
                                Phone = dataPM[0].Phone,
                                EmergencyAddress = dataPM[0].EmergencyAddress,
                                App_ID = dataLTD[i].appointmentID
                            });

                        }
                    }

                }
            }


            int IsBill = 1;
            if (IsPatientBilling > 0)
            {

                //   if (Resources.Resource.RegistrationChargesApplicable == "1" && PatientMasterInfo[0].patientMaster.FeesPaid != 0)
                if (Resources.Resource.RegistrationChargesApplicable == "1" && dataPM[0].FeesPaid != 0 && IsRegistrationchargeInclude == 1)
                {
                    //var dicountPercentForRegistration = directDiscountOnBill ? itemWiseDiscountPercent : 0;
                    // OPD opd = new OPD();
                    //   opd.OPDRegistration(TransactionId, dataPMH[0].DoctorID, LedgerTransactionNo, PatientMasterInfo[0].PanelID, con, tnx, dicountPercentForRegistration, dataLTD[0].panelCurrencyFactor);
                    //opd.OPDRegistration(TransactionId, dataPMH[0].DoctorID, LedgerTransactionNo, dataPMH[0].PanelID, con, tnx, dicountPercentForRegistration, dataLTD[0].panelCurrencyFactor);
                    string sql = "UPDATE `patient_master` pm SET pm.`FeesPaid`=1 WHERE pm.`PatientID`='" + PatientID + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                }

                ////////////////////////////// Insert in Receipt ///////////////////

                if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (dataLT[0].Adjustment > 0))
                {
                    Receipt ObjReceipt = new Receipt(tnx);
                    ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjReceipt.AmountPaid = dataLT[0].Adjustment;
                    ObjReceipt.AsainstLedgerTnxNo = LedgerTransactionNo.Trim();
                    ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    ObjReceipt.Depositor = PatientID;
                    ObjReceipt.Discount = 0;
                    ObjReceipt.PanelID = dataPMH[0].PanelID;
                    ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                    ObjReceipt.Depositor = PatientID;
                    ObjReceipt.TransactionID = TransactionId;
                    ObjReceipt.RoundOff = dataLT[0].RoundOff;
                    ObjReceipt.LedgerNoCr = "OPD003";
                    ObjReceipt.LedgerNoDr = "HOSP0001";
                    ObjReceipt.PaidBy = "PAT";
                    ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceipt.IpAddress = All_LoadData.IpAddress();
                    IsBill = 0;
                    ObjReceipt.isBloodBankItem = isBloodBankItem;
                    ReceiptNo = ObjReceipt.Insert();
                    if (string.IsNullOrEmpty(ReceiptNo))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipts" });
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
                        if (string.IsNullOrEmpty(PaymentID))
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt Payment Details" });
                        }
                    }

                }



                if (dataLTD[0].IsAdvance == "1")
                {
                    /***  ISADVANCE ITEM RECEIPT ENTRY   * ****/
                    StringBuilder sbb = new StringBuilder();
                    sbb.Append("  INSERT INTO Receipt_mapped (PatientID,TransactionID_Old,ReceiptNO,LedgerTransactionNo_OLD,DefaultMapped,CentreID,Hospital_ID)    ");
                    sbb.Append(" VALUES('" + PatientID + "','" + TransactionId + "','" + ReceiptNo + "','" + LedgerTransactionNo + "',0,'" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "');   ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbb.ToString());
                }
                if (sampleCollectCount > 0)
                {
                    string notification = Notification_Insert.notificationInsert(3, LedgerTransactionNo, tnx, "", "", 0, "");//LedgerTransactionNo

                    if (string.IsNullOrEmpty(notification))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Notification" });
                    }
                }


                //for panel Advance 
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

            }
            else
                IsBill = 2;

            if (IsPatientBilling > 0 && (dataPMH[0].PanelID != Util.GetInt(Resources.Resource.DefaultPanelID)))
            {
                var panelEmailID = Util.GetString(excuteCMD.ExecuteScalar("SELECT pm.Email FROM f_center_panel pm WHERE pm.isActive=1 and pm.PanelID=@panelID AND CentreID=@CentreID", new
                {
                    panelID = dataPMH[0].PanelID,
                    CentreID = HttpContext.Current.Session["CentreID"].ToString()
                }));

                var NICNumber = Util.GetString(excuteCMD.ExecuteScalar("SELECT s.IDProofNumber FROM patient_id_proofs s WHERE s.PatientID=@patientID AND s.IDProofID=1", new
                {
                    patientID = PatientID

                }));


                StringBuilder sqlCMD = new StringBuilder("INSERT INTO panelapproval_emaildetails (Email,TransactionID,SendEmailID,ApprovalAmount,PolicyCardNumber,PolicyExpiryDate,PolicyNumber,NICNumber,EntryBy ,ApprovalRemark,PanelID) ");
                sqlCMD.Append(" VALUES ( @Email,@TransactionID,@SendEmailID,@ApprovalAmount,@PolicyCardNumber,@PolicyExpiryDate,@PolicyNumber,@NICNumber,@EntryBy,@ApprovalRemark,@panelID) ");


                var response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {

                    Email = panelEmailID,
                    TransactionID = TransactionId,
                    SendEmailID = 0,
                    ApprovalAmount = Util.GetDecimal(approvalAmount),
                    PolicyCardNumber = dataPMH[0].CardNo,
                    PolicyExpiryDate = Util.GetDateTime(dataPMH[0].ExpiryDate).ToString("yyyy-MM-dd"),
                    PolicyNumber = dataPMH[0].PolicyNo,
                    NICNumber = NICNumber,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    ApprovalRemark = approvalRemark,
                    panelID = dataPMH[0].PanelID
                });


                sqlCMD = new StringBuilder(" Insert Into f_opdpanelapproval (isActive,PanelAppUserID,TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ApprovalExpiryDate,ClaimNo,PanelID) ");
                sqlCMD.Append(" VALUES(1,@EntryBy,@TransactionID, @EntryBy, @ApprovalAmount, now(), @ApprovalRemark, @PanelAppRemarksHistory, '', '', 'A', 'Open', @PolicyExpiryDate, @PolicyNumber, @panelID) ");

                response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {

                    TransactionID = TransactionId,
                    ApprovalAmount = Util.GetDecimal(approvalAmount),
                    PolicyExpiryDate = Util.GetDateTime(dataPMH[0].ExpiryDate).ToString("yyyy-MM-dd"),
                    PolicyNumber = dataPMH[0].PolicyNo,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    ApprovalRemark = approvalRemark,
                    PanelAppRemarksHistory = " Date : " + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "  User : " + HttpContext.Current.Session["LoginName"].ToString() + "  UserID : " + HttpContext.Current.Session["ID"].ToString() + ",  Remarks : " + approvalRemark + "",
                    panelID = dataPMH[0].PanelID
                });

                if (Util.GetDecimal(approvalAmount) != 0)
                {
                    sqlCMD = new StringBuilder("INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@ApprovalAmount,@EntryBy,'CR') ");

                    response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                    {
                        transactionID = TransactionId,
                        ApprovalAmount = Util.GetDecimal(approvalAmount),
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        panelID = dataPMH[0].PanelID
                    });
                }

                string sql1 = "DELETE FROM investigation_timeslot_hold  WHERE HoldUserID=@HoldUserID and CentreID=@CentreID ";
                excuteCMD.DML(tnx, sql1, CommandType.Text, new
                {
                    HoldUserID = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
                });

                excuteCMD.DML(tnx, " CALL PostBillWiseDoctorShare(@TransactionID,@UserID,0) ", CommandType.Text, new
                {
                    TransactionID = TransactionId,
                    UserID = HttpContext.Current.Session["ID"].ToString()

                });
            }


            int IsSmartCard = Encounter.IsPanelWithSmartCard(Util.GetString(dataPMH[0].PanelID));

            if (IsSmartCard == 1)
            {
                int LastSessionID = Util.GetInt(StockReports.ExecuteScalar(" SELECT pd.sessionId FROM paneldetails pd WHERE pd.PatientId='" + PatientID + "' AND Pd.PanelID='" + dataPMH[0].PanelID + "' ORDER BY id DESC LIMIT 1   "));

                              
                
                CardTokenResponseModel tokenResponse = AuthenticationHelper.GetBearerToken();

                using (var client = CardClientHelper.GetClient(tokenResponse.AccessToken))
                {
                    string recivedata = "";

                    client.BaseAddress = new Uri(CardBasicData.BaseUrl);
                    try
                    {
                        string urldat = "api/member?patientNumber=" + PatientID + "&sessionId=" + LastSessionID + "";
                        HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                        string status_code = Res.StatusCode.ToString();
                        //Checking the response is successful or not which is sent using HttpClient  
                        if (Res.IsSuccessStatusCode)
                        {
                            recivedata = Res.Content.ReadAsStringAsync().Result;
                            var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                            object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                            GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));


                            if (FetchDat.content.Count != 0)
                            {


                                int SaveVal = Encounter.IsUsingSmartCard(PatientID, Util.GetString(dataPMH[0].PanelID), FetchDat.content[0].session_id);

                                if (SaveVal == 1)
                                {
                                    int ismerge = IsSessionIdMergeWithEncounterNo(EncounterNo);

                                    if (ismerge == 0)
                                    {

                                        using (var clientMSId = CardClientHelper.GetClient(tokenResponse.AccessToken))
                                        {

                                            clientMSId.BaseAddress = new Uri(CardBasicData.BaseUrl);
                                            try
                                            {
                                                System.Net.Http.HttpContent requestContent = new System.Net.Http.StringContent("", Encoding.UTF8, "application/x-www-form-urlencoded");
                                                string urldatMSID = "api/patient-number/" + PatientID + "/visit-number/" + EncounterNo + "";
                                                HttpResponseMessage ResMSID = client.PutAsync(urldatMSID, requestContent).GetAwaiter().GetResult();

                                                recivedata = ResMSID.Content.ReadAsStringAsync().Result;
                                                var dataMSID = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                                //Checking the response is successful or not which is sent using HttpClient  
                                                if (ResMSID.IsSuccessStatusCode)
                                                {

                                                    excuteCMD.DML(tnx, "UPDATE patient_encounter s SET s.IsMerge=1,s.ForPoolNr=@PoolNr,s.SessionId=@SessionId WHERE s.EncounterNo=@EncounterNo", CommandType.Text, new
                                                    {
                                                        PoolNr = PoolNr,
                                                        EncounterNo = EncounterNo,
                                                        SessionId = FetchDat.content[0].session_id
                                                    });


                                                    excuteCMD.DML(tnx, "UPDATE paneldetails s SET s.IsMerge=1 WHERE s.PatientID=@PatientID and SessionId=@SessionId and PanelId=@PanelId and IsActive=1", CommandType.Text, new
                                                    {
                                                        PatientID = PatientID,
                                                        SessionId = FetchDat.content[0].session_id,
                                                        PanelId = Util.GetString(dataPMH[0].PanelID),
                                                    });
                                                }

                                            }
                                            catch (Exception ex)
                                            {
                                                ClassLog cl = new ClassLog();
                                                cl.errLog(ex);
                                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

                                            }

                                        }



                                    }
                                    else
                                    {
                                        int MappedPoolNr = Encounter.GetPoolNrByEncounterNo(EncounterNo);

                                        if (MappedPoolNr != PoolNr && Util.GetDecimal(dataPMH[0].PanelPaybleAmt)>0)
                                        {
                                            tnx.Rollback();
                                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Encounter No. " + EncounterNo + " is Mapped With PoolNr " + MappedPoolNr + " And PoolDesc " + Encounter.GetPoolDescByEncounterNo(EncounterNo, MappedPoolNr) + ",Please Select Previous Pool Nr Or Create New smart Card Session.   ", message = "Error In Samrt Card." });

                                        }

                                    }

                                }

                            }
                            else
                            {

                                int IsManual = Encounter.IsPanelWithIsManual(dataPMH[0].PanelID.ToString());
                                if (IsManual != 1)
                                {
                                    tnx.Rollback();
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Not Accepting Manual Please Process Through Smart Card", message = "Error In Samrt Card." });
                                }

                            }

                        }
                        else
                        {
                            int IsManual = Encounter.IsPanelWithIsManual(dataPMH[0].PanelID.ToString());
                            if (IsManual != 1)
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Not Accepting Manual Please Process Through Smart Card", message = "Error In Samrt Card." });
                            }

                        }

                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

                    }

                }

            }
            else
            {
                int IsManual = Encounter.IsPanelWithIsManual(dataPMH[0].PanelID.ToString());
                if (IsManual != 1)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Not Accepting Manual Please Process Through Smart Card", message = "Error In Samrt Card." });
                }
            }

            //if (BillNo != "")
            //{
            //    int countBillno = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_ledgertransaction lt WHERE lt.`CentreID`='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND lt.`BillNo`='" + BillNo + "' "));
            //    if (countBillno != 0)
            //    {
            //        tnx.Rollback();
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please refresh the page", message = "Error In same billno generate." });
            //    }
            //}

            tnx.Commit();


            //**************** SMS************************//
            if (Resources.Resource.SMSApplicable == "1")
            {
                //for (int i = 0; i < dataLTD.Count; i++)
                //{
                //    if (dataLTD[i].Type == "OPD")
                //    {
                //        if (dataLTD[i].typeOfApp != "2") // Not Walk-In
                //        {
                //            var columninfo = smstemplate.getColumnInfo(1, con);
                //            if (columninfo.Count > 0)
                //            {
                //                columninfo[0].PName = dataPM[0].PName;
                //                columninfo[0].Title = dataPM[0].Title;
                //                columninfo[0].ContactNo = dataPM[0].Mobile;
                //                columninfo[0].TemplateID = 1;
                //                columninfo[0].PatientID = dataPMH[0].PatientID;
                //                columninfo[0].AppointmentDate = dataLTD[i].appointmentDateTime.Split('#')[0].Trim();
                //                columninfo[0].AppointmentTime = (dataLTD[i].appointmentDateTime.Split('#')[1].Trim()).Split('-')[0];
                //                columninfo[0].DoctorName = Util.GetString(StockReports.GetDoctorNameByDoctorID(dataLTD[i].DoctorID));
                //                columninfo[0].AppNo = dataLTD[i].AppointmentNo;
                //                string sms = smstemplate.getSMSTemplate(1, columninfo, 2, con, HttpContext.Current.Session["ID"].ToString());
                //            }
                //        }
                //    }
                //}
            }



            if (IsBill != 2)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, LedgerTransactionNo = LedgerTransactionNo, IsBill = IsBill, consultationLedgerTnxID = consultationLedgerTnxIDs });
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage + " <br/><span class='patientInfo'>But Bill will not print because You have Booked Doctor Appointment On-Line/Phone.</span>", LedgerTransactionNo = LedgerTransactionNo, IsBill = IsBill });

        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string getAlreadyPrescribeItem(string PatientID, string ItemID)
    {
        if (ItemID == "33680")
        {
            ItemID = "00d1";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(entryDate,'%d-%b-%Y')EntryDate,(SELECT NAME FROM employee_master WHERE EmployeeID=ltd.userid LIMIT 1)UserName ");
        sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.TransactionID=ltd.TransactionID   ");
        sb.Append(" WHERE lt.PatientID='" + PatientID + "' AND ItemID='" + ItemID + "' AND lt.isCancel=0 AND isverified IN(0,1) AND TIMESTAMPDIFF(HOUR,ltd.entryDate,NOW())<'24' ORDER BY ltd.ID ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    public string lastVisitDetails(string patientID)
    {
        var sqlCmd = "SELECT IF(IFNULL((SELECT COUNT(*) FROM patient_labobservation_opd pl WHERE pl.`Test_ID`=plo.`Test_ID` AND (CAST(pl.`Value` AS DECIMAL)<CAST(pl.`MinValue` AS DECIMAL) OR CAST(pl.`Value` AS DECIMAL)>CAST(pl.`MaxValue` AS DECIMAL))),0)>0,'Yes','No')CriticalCase, im.Name,plo.`Test_ID`,plo.`Investigation_ID`, (SELECT ItemID FROM f_ledgertnxdetail WHERE ID=PLO.`LedgertnxID`)ItemID FROM patient_labinvestigation_opd plo INNER JOIN investigation_master im ON im.`Investigation_Id`=plo.`Investigation_ID` INNER JOIN ( SELECT lt.`LedgerTransactionNo` FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo` WHERE lt.`TypeOfTnx` IN('OPD-BILLING','OPD-LAB','OPD-BILLING','OPD-Package') AND lt.`PatientID`='" + patientID + "' AND lt.`IsCancel`=0 ORDER BY CONCAT(lt.date,' ',lt.`Time`) DESC LIMIT 1 )lt ON lt.LedgerTransactionNo=plo.`LedgerTransactionNo` ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCmd));
    }

    public int Countcategory(string categoryId)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int count = 0;

        string query = "SELECT COUNT(*) FROM token_master_detail where CategoryID='" + categoryId + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            count = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }
        return count;
    }
    public string GetTokenType(MySqlTransaction tnx, string categoryId)
    {
        string token = "";

        int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM token_master_detail where CategoryID='" + categoryId + "' and CentreID = " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ""));


        if (count > 0)
        {
            string query = "SELECT DISTINCT IFNULL(Token_Type,'') Token_Type FROM token_master_detail WHERE CategoryID='" + categoryId + "' and CentreID = " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " ";

            token = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, query));
        }
        return token;
    }


    [WebMethod(EnableSession = true)]
    public string GetUnBilledPatientSearvices(string visitID, string patientID)
    {

        StringBuilder sqlCMD = new StringBuilder();
        if (HttpContext.Current.Session["CentreID"].ToString() == "3")
        {
            sqlCMD.Append("SELECT ap.ItemID,sm.Name SubCategory,ap.App_ID SalesID,sm.CategoryID, 0 PatientTest_ID , 1 IsIssue,0 Rate, 0 IsUrgent, im.TypeName, 0 IsOutSource, ap.DoctorID DoctorID, 1 Quantity, cr.ConfigID, im.Type_ID, IFNULL(im.ItemCode,'')ItemCode, im.`IsAdvance` `isadvance`, im.`SubCategoryID`, 'OPD' LabType, '5'  TnxType, 'N' Sample, '' Remarks,im.TypeName ItemDisplayName FROM appointment ap INNER JOIN f_itemmaster im ON ap.ItemID=im.ItemID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid WHERE ap.PatientID=@patientID and ap.CentreID=@CentreID AND  ap.LedgerTnxNo='' ");
            sqlCMD.Append(" UNION ALL ");
        }
        sqlCMD.Append(" SELECT s.ItemID,sm.Name SubCategory, s.SalesID,sm.CategoryID,0 PatientTest_ID ,1 IsIssue, ROUND(s.PerUnitSellingPrice,4) Rate,0 IsUrgent, im.TypeName, 0 IsOutSource, ap.DoctorID DoctorID, s.SoldUnits Quantity, cr.ConfigID, im.Type_ID, IFNULL(im.ItemCode,'')ItemCode, im.`IsAdvance` `isadvance`, im.`SubCategoryID`, 'OPD' LabType, '16'  TnxType, 'N' Sample, '' Remarks,im.TypeName ItemDisplayName FROM patient_consumables pc INNER JOIN f_salesdetails s ON  s.SalesID=pc.SalesID INNER JOIN appointment ap ON ap.App_ID=pc.App_ID INNER JOIN f_itemmaster im ON s.ItemID=im.ItemID INNER JOIN f_salesdetails sd ON sd.SalesID=pc.SalesID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid WHERE pc.PatientID=@patientID and sd.LedgertransactionNo = 0 AND s.CentreID=@CentreID  ");
        sqlCMD.Append(" UNION ALL ");
        sqlCMD.Append("  SELECT DISTINCT (pt.Test_ID) ItemID,sm.Name SubCategory,'' SalesID,sm.CategoryID, pt.PatientTest_ID,pt.IsIssue,0 Rate,IsUrgent, fit.Typename, IFNULL(pt.OutSource, 0) IsOutSource, pt.DoctorID, (Quantity) Quantity, pt.ConfigID, fit.Type_id, IFNULL(fit.ItemCode,'')ItemCode, fit.`IsAdvance` `isadvance`, fit.`SubCategoryID`, ( CASE WHEN cr.ConfigID = 3 THEN 'LAB' WHEN cr.ConfigID IN (25) THEN 'PRO' WHEN cr.ConfigID IN (7) THEN 'BB' WHEN cr.ConfigID IN (20, 6) THEN 'OTH' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN 'OPD-BILLING' END ) LabType, ( CASE WHEN cr.ConfigID = 3 THEN '3' WHEN cr.ConfigID IN (25) THEN '4' WHEN cr.ConfigID IN (7) THEN '6' WHEN cr.ConfigID IN (20, 6) THEN '5' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN '16' END ) TnxType, (SELECT IF(TYPE = 'R', TYPE, 'N')  FROM Investigation_master WHERE Investigation_ID = fit.Type_ID) Sample, pt.Remarks, fit.TypeName ItemDisplayName FROM patient_test pt INNER JOIN f_itemmaster fit ON pt.test_id = fit.itemid INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = fit.SubCategoryID INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid  INNER JOIN appointment app ON app.TransactionID=pt.TransactionID WHERE pt.PatientID =@patientID AND app.CentreID=@CentreID AND pt.IsIssue=0 HAVING ItemID IS NOT NULL   ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = visitID,
            patientID = patientID,
            CentreID = HttpContext.Current.Session["CentreID"].ToString()
        });


        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            transactionID = visitID,
            patientID = patientID

        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetInvestigationTimeSlot(string DoctorId, string InvestigationDate, string BookingType, string ItemID, string SubCategoryID, string centreId, string Modality)
    {
        try
        {
            DateTime startDateTime = new DateTime();
            DateTime endDateTime = new DateTime();
            int DurationofTest = 10;
            DataTable dtDoctorSlot = new DataTable();
            //     InvestigationDate = DateTime.Now.ToString();
            string Query = " SELECT  StartTime,EndTime,IFNULL(ShiftName,'Day Shift') as ShiftName,ifnull(DurationforPatient,10)DurationforPatient FROM investigation_slot_master WHERE SubCategoryID='" + SubCategoryID + "' AND DAY='" + Util.GetDateTime(InvestigationDate).DayOfWeek.ToString() + "' and CentreID='" + centreId + "' and ModalityID='" + Modality + "' ";
            dtDoctorSlot = StockReports.GetDataTable(Query);

            string modalityname = StockReports.ExecuteScalar("SELECT NAME FROM modality_master WHERE id='" + Modality + "' ");


            DataTable dtBookedSlotinHospital = StockReports.GetDataTable("SELECT BookDate,StartTime,EndTime FROM Investigation_TimeSlot WHERE isactive=1 AND IsOnlineBooking=1 AND SubCategoryID='" + SubCategoryID + "' and CentreID ='" + centreId + "' and ModalityID='" + Modality + "'");
            DataTable dtBookedSlotOnline = StockReports.GetDataTable("SELECT BookDate,StartTime,EndTime FROM Investigation_TimeSlot WHERE isactive=1 AND IsOnlineBooking=2 AND SubCategoryID='" + SubCategoryID + "' and CentreID ='" + centreId + "' and ModalityID='" + Modality + "'");
            DataTable dtholdSlot = StockReports.GetDataTable("Select BookingDate,StartTime,EndTime from investigation_timeslot_hold where SubCategoryID='" + SubCategoryID + "' and CentreID ='" + centreId + "' and ModalityID='" + Modality + "'");
            string output = string.Empty;
            string defaultAvilableSlot = string.Empty;


            if (Util.GetDateTime(InvestigationDate).Date >= System.DateTime.Now.Date)
            {
                foreach (DataRow drSlot in dtDoctorSlot.Rows)
                {
                    startDateTime = Util.GetDateTime(drSlot["StartTime"].ToString());
                    endDateTime = Util.GetDateTime(drSlot["EndTime"].ToString());
                    DurationofTest = Util.GetInt(drSlot["DurationforPatient"]);
                    string slots = GetSlotDateWise(dtBookedSlotinHospital, dtBookedSlotOnline, dtholdSlot, startDateTime, endDateTime, InvestigationDate, defaultAvilableSlot, DurationofTest, Modality, modalityname, out defaultAvilableSlot);
                    if (slots != "")
                    {
                        slots = "<div class='row' ><div  class='col-md-24' ><b class='modal-title'># " + drSlot["ShiftName"].ToString() + "<br /><hr /><b /></div>" + slots + "</div>";
                        output += slots;
                    }
                }
                if (string.IsNullOrWhiteSpace(output))
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Slot Not Avilable" });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = output, defaultAvilableSlot = defaultAvilableSlot });

            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Not A Valid Appointment Date" });

        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    public static string GetSlotDateWise(DataTable dtBookedSlotinHospital, DataTable dtBookedSlotOnline, DataTable dtholdSlot, DateTime startDateTime, DateTime endDateTime, string InvestigationDate, string currentdefaultAvilableSlot, int DurationofTest, string Modality, string modalityname, out string defaultAvilableSlot)
    {
        DateTime currentTime = System.DateTime.Now;
        string output = "";
        int flag = 0;

        while (startDateTime < endDateTime)
        {
            foreach (DataRow row in dtBookedSlotinHospital.Rows)
            {
                if (Util.GetDateTime(InvestigationDate).Date == Util.GetDateTime(row["BookDate"]).Date && Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 1;
                }
            }

            foreach (DataRow row in dtBookedSlotOnline.Rows)
            {
                if (Util.GetDateTime(InvestigationDate).Date == Util.GetDateTime(row["BookDate"]).Date && Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 2;
                }
            }
            foreach (DataRow row in dtholdSlot.Rows)
            {
                if (Util.GetDateTime(InvestigationDate).Date == Util.GetDateTime(row["BookingDate"]).Date && Util.GetDateTime(row["StartTime"]).ToString("HH:mm") == startDateTime.ToString("HH:mm"))
                {
                    flag = 3;
                }

            }

            if (flag == 1)
            {
                //for Booked in hosp
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-yellow' ><span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";
            }

            else if (flag == 2)
            {
                //for online Appointments
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div class='circle badge-info'> <span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";

            }
            else if (flag == 3)
            {
                //for hold slots by user
                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div  id='" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "' " + ((Util.GetDateTime(InvestigationDate).Date == System.DateTime.Now.Date && currentTime > startDateTime.AddMinutes(DurationofTest)) ? "class='circle badge-grey'" : "data-title='Double Click To Select' class='circle badge-darkgoldenrod' ondblclick='$InvdobuleClick(this)'") + "  onclick='$selectInvSlot(this)'> <span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "</span><span id='spnModalInvestigationDate' style='display:none'>" + InvestigationDate + "</span><span id='spnModalInvestigationModality' style='display:none'>" + Modality + "</span><span id='spnModalInvestigationModalityName' style='display:none'>" + modalityname + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";

            }
            else
            {

                output += "<div class='ellipsis' style='float:left;margin: 2px;'> <div id='" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "' " + ((Util.GetDateTime(InvestigationDate).Date == System.DateTime.Now.Date && currentTime > startDateTime.AddMinutes(DurationofTest)) ? "class='circle badge-grey'" : "data-title='Double Click To Select' class='circle badge-avilable' ondblclick='$InvdobuleClick(this)'") + " onclick='$selectInvSlot(this)'> <span id='spnInvestigationTime' style='display:none'>" + startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + "</span><span id='spnModalInvestigationDate' style='display:none'>" + InvestigationDate + "</span><span id='spnModalInvestigationModality' style='display:none'>" + Modality + "</span><span id='spnModalInvestigationModalityName' style='display:none'>" + modalityname + "</span> " + startDateTime.ToString("hh:mm tt") + "<div style='font-weight:bold;color:white;text-align: center;height: 2px;background-color: black;width: 31px;margin-left: 14px;margin-top: 2px;'></div> " + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt") + " </div> </div> ";
                if (string.IsNullOrWhiteSpace(currentdefaultAvilableSlot) && startDateTime.AddMinutes(DurationofTest) > currentTime)
                    currentdefaultAvilableSlot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationofTest).ToString("hh:mm tt");

            }
            flag = 0;
            startDateTime = startDateTime.AddMinutes(DurationofTest);
        }

        defaultAvilableSlot = currentdefaultAvilableSlot;
        return output;
    }

    [WebMethod(EnableSession = true)]
    public string HoldTimeSlot(string modalityID, string SubCategoryID, string ItemID, string BookingDate, string TimeSlot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            int previousHoldSlotforsameItem = Util.GetInt(StockReports.ExecuteScalar("SELECT ID FROM investigation_timeslot_hold WHERE ItemID='" + ItemID + "' AND HoldUSerID='" + HttpContext.Current.Session["ID"].ToString() + "' and CentreID= " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " "));
            if (previousHoldSlotforsameItem != 0)
            {
                string sql = "DELETE FROM investigation_timeslot_hold  WHERE id=@ID";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                {
                    ID = previousHoldSlotforsameItem
                });
            }

            int isHold = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM investigation_timeslot_hold WHERE BookingDate =@bookingDate and StartEndTimeSlot=@Timeslot AND modalityid=@modalityID ", CommandType.Text, new
            {
                bookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                Timeslot = TimeSlot,
                modalityID = modalityID,
            }));

            if (isHold > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This Slot is Not Available. Select Another Slot" });
            }

            var startTime = TimeSlot.Split('-')[0].ToString();
            var EndTime = TimeSlot.Split('-')[1].ToString();

            string sqlCMD = "INSERT INTO investigation_timeslot_hold (ModalityID,SubCategoryID,ItemID,BookingDate,StartTime,EndTime,StartEndTimeSlot,HoldUserID,CentreID,IsOnlineBooking) "
                            + "VALUES(@modalityID,@SubCategoryID,@ItemID,@BookingDate,@startTime,@EndTime,@TimeSlot,@HoldUserID,@CentreID,@isOnlineBooking    )";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                modalityID = modalityID,
                SubCategoryID = SubCategoryID,
                ItemID = ItemID,
                BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd"),
                startTime = Util.GetDateTime(startTime).ToString("HH:mm:ss"),
                EndTime = Util.GetDateTime(EndTime).ToString("HH:mm:ss"),
                TimeSlot = TimeSlot,
                HoldUserID = HttpContext.Current.Session["ID"].ToString(),
                CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                isOnlineBooking = 2    // 1 for online 2 for hospital
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = '1' });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public string ClearSlots(string ItemID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            if (ItemID != string.Empty)
            {
                string sql = "DELETE FROM investigation_timeslot_hold  WHERE HoldUserID=@HoldUserID and ItemID=@ItemID and CentreID = @CentreID ";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                {
                    ItemID = ItemID,
                    HoldUserID = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
                });
            }
            else
            {
                string sql = "DELETE FROM investigation_timeslot_hold  WHERE HoldUserID=@HoldUserID and CentreID = @CentreID ";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                {
                    HoldUserID = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
                });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error Occured" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string getPatientDoctorAppointmentDetails(string appointmentID)
    {
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT ap.ItemID,sm.Name SubCategory,ap.App_ID,sm.CategoryID, 0 PatientTest_ID , 1 IsIssue,0 Rate, 0 IsUrgent, im.TypeName, 0 IsOutSource, ap.DoctorID DoctorID, 1 Quantity, cr.ConfigID, im.Type_ID, IFNULL(im.ItemCode,'')ItemCode, im.`IsAdvance` `isadvance`, im.`SubCategoryID`, 'OPD' LabType, '5'  TnxType, 'N' Sample, '' Remarks,im.TypeName ItemDisplayName FROM appointment ap INNER JOIN f_itemmaster im ON ap.ItemID=im.ItemID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid WHERE ap.app_ID=@app_ID and ap.CentreID=@CentreID ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            app_ID = appointmentID,
            CentreID = HttpContext.Current.Session["CentreID"].ToString()
        });


        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            appID = appointmentID,
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }




    public int IsSessionIdMergeWithEncounterNo(int EncounterNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM patient_encounter pe WHERE pe.EncounterNo=" + EncounterNo + " AND pe.IsMerge=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }

    }

    public int GetSessionId(string PatientId)
    {

        try
        {
            string recivedata = "";
            CardTokenResponseModel tokenResponse = AuthenticationHelper.GetBearerToken();

            using (var client = CardClientHelper.GetClient(tokenResponse.AccessToken))
            {

                client.BaseAddress = new Uri(CardBasicData.BaseUrl);
                try
                {
                    string urldat = "api/member?patientNumber=" + PatientId + "";
                    HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                    string status_code = Res.StatusCode.ToString();
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));

                        return FetchDat.content[0].session_id;
                    }
                    else
                    {
                        return 0;
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return 0;
                }

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }


    }
    [WebMethod]
    public string IsBillingThroughSmartCard(string PatientId, string PanelId)
    {
        int sessionID = Encounter.GetSessionId(PatientId);
        int IsSmartCard = Encounter.IsUsingSmartCard(PatientId, PanelId, sessionID);

        if (IsSmartCard != 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = IsSmartCard });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = IsSmartCard });
        }

    }




}