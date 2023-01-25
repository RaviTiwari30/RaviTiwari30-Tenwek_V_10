<%@ WebService Language="C#" CodeBehind="~/App_Code/GetPayment.cs" Class="GetPayment" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;

/// <summary>
/// Summary description for GetPayment
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class GetPayment : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    
    
    
    [WebMethod(EnableSession = true, Description = "Save GetPayment")]
    public string SavaData(object LT, object LTD, object PaymentDetail, string PatientID, string DoctorID, int PanelID, int ParentPanelID, string ScheduleChargeID, string HashCode, string App_ID, string patientType, int rateListID, int IsNewPatient, string RegLedgertransactionNo, string AppDate)
    {
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM appointment WHERE App_ID=" + App_ID + " AND LedgerTnxNo<>'' "));
            if (count > 0)
                return "4";

            string TransactionId = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, ReceiptNo = string.Empty;
            string regledNo = string.Empty;
            OPD opd = new OPD();
            int hospChargeaApp = 0, regChargesApp = 0;

            if (IsNewPatient == 0)
            {
                hospChargeaApp = AllLoadData_OPD.hospChargesApp(DoctorID, PatientID, IsNewPatient, dataLTD[0].SubCategoryID, con);


                if (hospChargeaApp > 0 || regChargesApp > 0)
                {
                    string ChargesApp = string.Concat(regChargesApp, "#", hospChargeaApp);
                    regledNo = opd.OPDBillRegistration(PatientID, PanelID, tnx, 0, DoctorID, patientType, ChargesApp, Util.GetString(dataLT[0].CurrentAge), con, Util.GetString(dataLT[0].PatientType_ID), Util.GetInt(ParentPanelID));
                    if (regledNo == "1" || regledNo == "2" || regledNo == "3" || regledNo == "")
                    {
                        return regledNo;
                    }
                }
            }
            else
            {
                regledNo = RegLedgertransactionNo;
            }


            Patient_Medical_History objPMH = new Patient_Medical_History(tnx);
            objPMH.PatientID = PatientID;
            objPMH.DoctorID = DoctorID;
            objPMH.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objPMH.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            objPMH.DateOfVisit = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPMH.Type = "OPD";
            objPMH.PanelID = PanelID;
            objPMH.ParentID = ParentPanelID;
            objPMH.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
            objPMH.HashCode = HashCode;
            objPMH.Source = "Appointment";
            objPMH.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objPMH.IsNewPatient = IsNewPatient;
            objPMH.UserID = HttpContext.Current.Session["ID"].ToString();
            objPMH.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPMH.patient_type = patientType;
            TransactionId = objPMH.Insert();
            if (TransactionId == string.Empty)
            {
                tnx.Rollback();
                return "";
            }

            EncounterNo = Encounter.FindEncounterNo(PatientID);
            if (EncounterNo == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }
            
            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);

            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            string LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
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
            ObjLdgTnx.PatientID = PatientID;
            ObjLdgTnx.PanelID = PanelID;
            ObjLdgTnx.TransactionID = TransactionId;
            ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnx.DiscountReason = dataLT[0].DiscountReason;
            ObjLdgTnx.DiscountApproveBy = dataLT[0].DiscountApproveBy;
            ObjLdgTnx.DiscountOnTotal = dataLT[0].DiscountOnTotal;
            ObjLdgTnx.BillNo = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            if (ObjLdgTnx.BillNo == "")
            {
                tnx.Rollback();
                return "";
            }
            ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now);
            ObjLdgTnx.RoundOff = dataLT[0].RoundOff;
            ObjLdgTnx.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
            ObjLdgTnx.UniqueHash = dataLT[0].UniqueHash;
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.Adjustment = dataLT[0].Adjustment;
            ObjLdgTnx.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount);
            ObjLdgTnx.IsPaid = 0;
            ObjLdgTnx.IsCancel = 0;
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.PatientType = patientType;
            ObjLdgTnx.CurrentAge = Util.GetString(dataLT[0].CurrentAge);
            ObjLdgTnx.PatientType_ID = Util.GetInt(dataLT[0].PatientType_ID);
            ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);
            
            string LedgerTransactionNo = ObjLdgTnx.Insert();

            if (LedgerTransactionNo == "")
            {
                tnx.Rollback();
                return "";
            }


            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
            ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[0].ItemID);
            ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[0].Rate);
            ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[0].Quantity);
            ObjLdgTnxDtl.StockID = "";
            ObjLdgTnxDtl.IsTaxable = "NO";
            ObjLdgTnxDtl.Amount = Util.GetDecimal(dataLTD[0].Amount);
            ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[0].DiscAmt);
            ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(dataLTD[0].DiscountPercentage);
            ObjLdgTnxDtl.DoctorID = DoctorID;
            ObjLdgTnxDtl.IsPackage = 0;
            ObjLdgTnxDtl.PackageID = "";
            ObjLdgTnxDtl.IsVerified = 1;
            ObjLdgTnxDtl.TransactionID = TransactionId;
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
            ObjLdgTnxDtl.RateListID = rateListID;
            ObjLdgTnxDtl.Type = "O";
            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[0].SubCategoryID), con));
            string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
            if (LdgTnxDtlID == "")
            {
                tnx.Rollback();
                return "";
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
                ObjReceipt.PanelID = PanelID;
                ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                ObjReceipt.Depositor = PatientID;
                ObjReceipt.TransactionID = TransactionId;
                ObjReceipt.RoundOff = dataLT[0].RoundOff;
                ObjReceipt.IpAddress = All_LoadData.IpAddress();
                ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceipt.PaidBy = "PAT";
                IsBill = 0;
                ReceiptNo = ObjReceipt.Insert();
                if (ReceiptNo == string.Empty)
                {
                    tnx.Rollback();
                    return "";
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
                    ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    string PaymentID = ObjReceiptPayment.Insert().ToString();
                    if (PaymentID == string.Empty)
                    {
                        tnx.Rollback();
                        return "";
                    }
                }

            }

           

            //Update Appointment Table
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE appointment SET LedgerTnxNo='" + LedgerTransactionNo + "', TransactionID='" + TransactionId + "' WHERE App_ID=" + App_ID + "");
            string notification = "";
            if (dataLTD[0].ItemID == Resources.Resource.EmergencySubcategoryID)
            {
                notification = Notification_Insert.notificationInsert(21, App_ID, tnx, DoctorID, "", 52, AppDate);
            }
            else
            {
                notification = Notification_Insert.notificationInsert(1, App_ID, tnx, DoctorID, "", 52, AppDate);
            }


            if (notification == "")
            {
                tnx.Rollback();
                return "";

            }

            tnx.Commit();
            return LedgerTransactionNo + "#" + regledNo + "#" + IsBill;
        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}
