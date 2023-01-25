using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public partial class Design_OPD_OPDAdvance : System.Web.UI.Page
{
    [WebMethod(EnableSession = true)]
    public static string SaveAdvanceAmount(object PM, object patientDocuments, object PaymentDetail, decimal advAmount, string UhashCode, string Type, int isAdvanceRoomBookingAmount, int advanceBookingId,string advanceReason, string DoctorID)
    {
        GetEncounterNo Encounter = new GetEncounterNo();
        int EncounterNo = 0;

        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string PatientID = string.Empty, LedgerTransactionNo = string.Empty, TransactionId = string.Empty, ReceiptNo = string.Empty;
            string BillNo = string.Empty;
            var PatientInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
            }
            else
                PatientID = PatientInfo[0].PatientID;

            BillNo = SalesEntry.genBillNo_opd(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            //if (BillNo == "")
            //{
            //    BillNo = SalesEntry.genBillNo_opd(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            //}
            
            if(string.IsNullOrEmpty(BillNo)){
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Kindly Generte Bill No.", message = "Kindly Generte Bill No." });
            }

            PatientDocument.SaveDocument(patientDocuments, PatientID);
            EncounterNo = Encounter.FindEncounterNo(PatientID);
            if (EncounterNo == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }
            if (Type == "2")
                advAmount = -1 * Util.GetDecimal(advAmount);

            string doctorID = DoctorID;//Resources.Resource.DoctorID_Self;
            string hashCode = UhashCode;
            Patient_Medical_History objPMH = new Patient_Medical_History(tnx);
            objPMH.PatientID = PatientID;
            objPMH.DoctorID = doctorID;// "1";  //doctorID;
            objPMH.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objPMH.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            objPMH.DateOfVisit = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPMH.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPMH.Type = "OPD";
            objPMH.PanelID = 1;
            objPMH.ParentID = 1;
            objPMH.ReferedBy = "";
            objPMH.patient_type = PatientInfo[0].HospPatientType;
            objPMH.ScheduleChargeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SchedulechargeID from f_rate_schedulecharges where PanelID='1'  AND IsDefault=1"));
            objPMH.Source = "OPD-Advance";
            objPMH.HashCode = hashCode;
            objPMH.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objPMH.UserID = HttpContext.Current.Session["ID"].ToString();
            objPMH.IsVisitClose = 1;
            objPMH.BillNo= BillNo;
            objPMH.BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            objPMH.BillGeneratedBy  =HttpContext.Current.Session["ID"].ToString();
            objPMH.TotalBilledAmt = Util.GetDecimal(advAmount);
            objPMH.NetBillAmount = Util.GetDecimal(advAmount);
            TransactionId = objPMH.Insert();
            if (string.IsNullOrEmpty(TransactionId) && TransactionId == "0")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });

            }
            

            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);
            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            if (Type == "1")
                ObjLdgTnx.LedgerNoCr = "LSHHI13";
            else
                ObjLdgTnx.LedgerNoCr = "OPD003";

            ObjLdgTnx.LedgerNoDr = "HOSP0006";
            ObjLdgTnx.TypeOfTnx = "OPD-Advance";

            ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjLdgTnx.NetAmount = Util.GetDecimal(advAmount);
            ObjLdgTnx.GrossAmount = Util.GetDecimal(advAmount);
            ObjLdgTnx.PatientID = PatientID;
            ObjLdgTnx.PanelID = 1;
            ObjLdgTnx.TransactionID = TransactionId;

            ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnx.DiscountReason = "";
            ObjLdgTnx.DiscountApproveBy = "";
            ObjLdgTnx.BillNo = BillNo;
            ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.RoundOff = 0;
            ObjLdgTnx.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
            ObjLdgTnx.UniqueHash = hashCode;
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.Adjustment = Util.GetDecimal(advAmount);
            ObjLdgTnx.GovTaxPer = Util.GetDecimal(0);
            ObjLdgTnx.GovTaxAmount = Util.GetDecimal(0);
            ObjLdgTnx.IsPaid = 1;
            ObjLdgTnx.IsCancel = 0;
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.PatientType = PatientInfo[0].HospPatientType;
            ObjLdgTnx.CurrentAge = PatientInfo[0].Age;
            ObjLdgTnx.PatientType_ID = Util.GetInt(PatientInfo[0].PatientType_ID);
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);
            LedgerTransactionNo = ObjLdgTnx.Insert();
            if (string.IsNullOrEmpty(LedgerTransactionNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In LdgTnx" });

            }

            string SubCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SubCategoryID FROM f_itemmaster WHERE itemID='" + Resources.Resource.OPDAdvanceItemID + "'"));
            if (string.IsNullOrEmpty(SubCategoryID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Advance Item Not found" });

            }
            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
            ObjLdgTnxDtl.ItemID = Resources.Resource.OPDAdvanceItemID;
            ObjLdgTnxDtl.Rate = Math.Abs(advAmount);
            if (Type == "1")
                ObjLdgTnxDtl.Quantity = 1;
            else
                ObjLdgTnxDtl.Quantity = -1;

            ObjLdgTnxDtl.StockID = "";
            ObjLdgTnxDtl.IsTaxable = "NO";
            ObjLdgTnxDtl.Amount = advAmount;
            ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0);
            ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
            ObjLdgTnxDtl.IsPackage = 0;
            ObjLdgTnxDtl.PackageID = "";
            ObjLdgTnxDtl.IsVerified = 1;
            ObjLdgTnxDtl.TransactionID = TransactionId;
            ObjLdgTnxDtl.SubCategoryID = SubCategoryID;
            ObjLdgTnxDtl.ItemName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT TypeName FROM f_itemmaster WHERE itemID='" + Resources.Resource.OPDAdvanceItemID + "'")); ;
            ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnxDtl.DiscountReason = "";
            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(SubCategoryID), con));
            ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
            ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
            ObjLdgTnxDtl.DoctorID = doctorID;
            ObjLdgTnxDtl.RateListID = 0;
            ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
            ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnxDtl.Type = "O";
            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            ObjLdgTnxDtl.IpAddress = HttpContext.Current.Request.UserHostAddress;
            ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnxDtl.typeOfTnx = "OPD-Advance";
            string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
            if (string.IsNullOrEmpty(LdgTnxDtlID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In ledger Treansaction Details" });

            }

            Receipt ObjReceipt = new Receipt(tnx);
            ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjReceipt.AmountPaid = advAmount;
            ObjReceipt.AsainstLedgerTnxNo = LedgerTransactionNo;
            ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjReceipt.Depositor = PatientID;
            ObjReceipt.Discount = 0;
            ObjReceipt.PanelID = 1;
            ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
            ObjReceipt.Depositor = PatientID;
            ObjReceipt.TransactionID = TransactionId;
            ObjReceipt.Naration = dataPaymentDetail[0].PaymentRemarks;
            ObjReceipt.RoundOff = 0;
            ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjReceipt.IpAddress = All_LoadData.IpAddress();
            ObjReceipt.PaidBy = "PAT";
            if (Type == "1")
                ObjReceipt.LedgerNoCr = "LSHHI13";
            else
                ObjReceipt.LedgerNoCr = "OPD003";

            ObjReceipt.LedgerNoDr = "";
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
                if (Type == "2")
                    ObjReceiptPayment.Amount = -1 * Util.GetDecimal(dataPaymentDetail[i].Amount);
                else
                    ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);

                ObjReceiptPayment.ReceiptNo = ReceiptNo;
                ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                if (Type == "2")
                    ObjReceiptPayment.S_Amount = -1 * Util.GetDecimal(dataPaymentDetail[i].S_Amount);
                else
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

                if (Type == "1")
                {
                    OPD_Advance adv = new OPD_Advance(tnx);
                    adv.PatientID = PatientID;
                    adv.TransactionID = TransactionId;
                    adv.LedgerTransactionNo = LedgerTransactionNo;
                    adv.AdvanceAmount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                    adv.ReceiptNo = ReceiptNo;
                    adv.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    adv.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    adv.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                    adv.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                    adv.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                    adv.BankName = dataPaymentDetail[i].BankName;
                    adv.RefNo = dataPaymentDetail[i].RefNo;
                    adv.advanceReason = advanceReason;
                    int advID = adv.Insert();
                    if (advID == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In OPD Advance" });
                    }
                }

                //for Patient Advance Refund
                if (Type == "2")
                {
                    DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmt,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE PatientID ='" + PatientID + "'  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmt,0))>0 ORDER BY ID+0").Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        decimal advanceAmount = dataPaymentDetail[i].Amount;
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
                            advd.advanceReason = advanceReason;
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
            }

            //Devendra Singh 2018-10-10 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string TransType = string.Empty;
                if (Type == "2")
                    TransType = "S";
                else
                    TransType = "A";

                string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(Util.GetInt(LedgerTransactionNo), ReceiptNo, TransType, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }

            if (isAdvanceRoomBookingAmount == 1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE advance_room_booking SET PatientAdvance=" + Util.GetDecimal(advAmount) + ",ReceiptNo='" + ReceiptNo + "' WHERE ID=" + advanceBookingId + " ");
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", ledgerTransactionNo = LedgerTransactionNo, PatientID = PatientID, IsBill = 0 });
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }
}