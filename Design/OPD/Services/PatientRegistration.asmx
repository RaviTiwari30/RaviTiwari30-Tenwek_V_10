<%@ WebService Language="C#" Class="PatientRegistration" %>

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
public class PatientRegistration : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    
    [WebMethod(EnableSession = true, Description = "Save Registration")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveReg(object PM, object PMH, object LT, object PaymentDetail, object patientDocuments, object MultiPanel, string TransferRequestID)
    {
        List<Patient_Master> dataReg = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
        List<PatientDocuments> patientDocumentsDetails = new JavaScriptSerializer().ConvertToType<List<PatientDocuments>>(patientDocuments);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        List<PatientMultiPanel> dataPMultiPanel = new JavaScriptSerializer().ConvertToType<List<PatientMultiPanel>>(MultiPanel);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string regledgertransactionNo = string.Empty;
        string TransactionId = string.Empty;
        string ReceiptNo = string.Empty;
        string LedgerTransactionNo = string.Empty;
        int IsBill = 1;

        int len = dataReg.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                var PatientID = "";
                var IsdefaultPanelID = dataPMultiPanel.Where(i => i.IsDefaultPanel == 1).ToList();
                if (IsdefaultPanelID.Count > 0)
                {
                    dataReg[0].PanelID = Util.GetInt(IsdefaultPanelID[0].PPanelID);
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Kindly Select The One  Panel As Default", message = "Kindly Select The One  Panel As Default" });
                }

                var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(dataReg, tnx, con);
                if (PatientMasterInfo.Count == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
                }
                else
                    PatientID = PatientMasterInfo[0].PatientID;




                PatientDocument.SaveDocument(patientDocuments, PatientID);



                string BillNo = string.Empty;
                if (Resources.Resource.RegistrationChargesApplicable == "1" && PatientMasterInfo[0].patientMaster.IsNewPatient == 1)
                {
                    EncounterNo = Encounter.FindEncounterNo(PatientID);

                    if (EncounterNo == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

                    }
                    BillNo = SalesEntry.genBillNo_opd(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
                    dataPMH[0].BillNo = BillNo;
                    dataPMH[0].BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    dataPMH[0].BillGeneratedBy = HttpContext.Current.Session["ID"].ToString();
                    dataPMH[0].TotalBilledAmt = Util.GetDecimal(dataLT[0].GrossAmount);
                    dataPMH[0].ItemDiscount = dataLT[0].DiscountOnTotal;
                    dataPMH[0].NetBillAmount = Util.GetDecimal(dataLT[0].NetAmount);
                    TransactionId = Insert_PatientInfo.savePMH(dataPMH, PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), PatientMasterInfo[0].HospPatientType, "OPD", "OPD-OTHERS", tnx, con);
                    if (TransactionId == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });
                    }
                    Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);

                    ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjLdgTnx.LedgerNoCr = "OPD003";
                    ObjLdgTnx.LedgerNoDr = "HOSP0001";
                    ObjLdgTnx.TypeOfTnx = "OPD-OTHERS";
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
                    if (ObjLdgTnx.BillNo == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledger Transaction" });
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
                    ObjLdgTnx.IPNo = Util.GetString(dataLT[0].IPNo.Trim());
                    ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjLdgTnx.PatientType = PatientMasterInfo[0].HospPatientType;
                    ObjLdgTnx.CurrentAge = Util.GetString(PatientMasterInfo[0].Age);
                    ObjLdgTnx.PatientType_ID = Util.GetInt(PatientMasterInfo[0].PatientType_ID);
                    ObjLdgTnx.FieldBoyID = Util.GetInt(dataLT[0].FieldBoyID);
                    ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);
                    LedgerTransactionNo = ObjLdgTnx.Insert();

                    if (LedgerTransactionNo == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  LdgTnx" });
                    }



                    OPD opd = new OPD();
                    opd.OPDRegistration(TransactionId, dataPMH[0].DoctorID, LedgerTransactionNo, PatientMasterInfo[0].PanelID, con, tnx, 0);


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
                        ObjReceipt.isBloodBankItem = "0";
                        ReceiptNo = ObjReceipt.Insert();
                        if (ReceiptNo == "")
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
                            if (PaymentID == "")
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt Payment Details" });
                            }
                        }

                    }



                }



                //if (Resources.Resource.SMSApplicable == "1")
                //{
                //    var columninfo = smstemplate.getColumnInfo(1, con);
                //    if (columninfo.Count > 0)
                //    {
                //        columninfo[0].PatientID = PatientID;
                //        columninfo[0].PName = PatientMasterInfo[0].patientMaster.Title + " " + PatientMasterInfo[0].patientMaster.PName;
                //        columninfo[0].Gender = PatientMasterInfo[0].patientMaster.Gender;
                //        columninfo[0].Age = PatientMasterInfo[0].patientMaster.Age;
                //        columninfo[0].ContactNo = dataReg[0].PhoneSTDCODE + PatientMasterInfo[0].patientMaster.Mobile;
                //        columninfo[0].TemplateID = 1;
                //        string sms = smstemplate.getSMSTemplate(1, columninfo, 1, con, dataReg[0].RegisterBy);
                //    }
                //}

                if (dataPMultiPanel.Count > 0)
                {
                    try
                    {
                        dataPMultiPanel.ForEach(i =>
                            {
                                string strmp = @" INSERT INTO patient_policy_detail(Patient_ID,PolicyNo,PolicyExpiry,Panel_ID,CreatedBy,CreatedDate,IsActive,PanelGroupID,ParentPanelID,PanelCroporateID,PolicyCardNo,PanelCardName,PolciyCardHolderRelation,ApprovalAmount,ApprovalRemarks,IsDefaultPanel)
                                            VALUES(@Patient_ID,@PolicyNo,@PolicyExpiry,@Panel_ID,@CreatedBy,NOW(),1,@PanelGroupID,@ParentPanelID,@PanelCroporateID,@PolicyCardNo,@PanelCardName,@PolciyCardHolderRelation,@ApprovalAmount,@ApprovalRemarks,@IsDefaultPanel);";
                                excuteCMD.DML(tnx, strmp, CommandType.Text, new
                                {
                                    Patient_ID = PatientID,
                                    PolicyNo = i.PPolicyNo,
                                    PolicyExpiry = Util.GetDateTime(i.PExpiryDate).ToString("yyyy-MM-dd"),
                                    Panel_ID = Util.GetInt(i.PPanelID),
                                    CreatedBy = HttpContext.Current.Session["ID"],
                                    PanelGroupID = Util.GetInt(i.PPanelGroupID),
                                    ParentPanelID = Util.GetInt(i.PParentPanelID),
                                    PanelCroporateID = Util.GetInt(i.PPanelCorporateID),
                                    PolicyCardNo = i.PCardNo,
                                    PanelCardName = i.PCardHolderName,
                                    PolciyCardHolderRelation = i.PCardHolderRelation,
                                    ApprovalAmount = i.PApprovalAmount,
                                    ApprovalRemarks = i.PApprovalRemarks,
                                    IsDefaultPanel = Util.GetInt(i.IsDefaultPanel)
                                });

                            });

                    }
                    catch (Exception ex)
                    {
                        tnx.Rollback();
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
                    }

                }


                //OutsideTransferPatientIDUpdate
                int TransferID = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(id) FROM PatientTransferReqest ptr WHERE ptr.ID='" + TransferRequestID + "' AND ptr.IsRegister=0 AND ptr.IsActive=1"));
                if (TransferID != 0)
                {
                    string sqlCmd = "UPDATE PatientTransferReqest ptr  SET ptr.IsRegister=@IsRegister,ptr.RegisterBy=@RegisterBy,ptr.RegisterDate=NOW(),ptr.PatientID=@PatientID ";
                    sqlCmd += "     WHERE ptr.ID=@ID AND ptr.IsRegister=0 AND ptr.IsActive=1; ";

                    excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                    {
                        IsRegister = 1,
                        RegisterBy = HttpContext.Current.Session["ID"].ToString(),
                        ID = Util.GetInt(TransferRequestID),
                        PatientID=PatientID
                        
                    });

                }

                if (BillNo != "")
                {
                    int countBillno = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_ledgertransaction lt WHERE lt.`CentreID`='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND lt.`BillNo`='" + BillNo + "' "));
                    if (countBillno != 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please click on save button again", message = "Error In same billno generate." });
                    }
                }
                
                tnx.Commit();
                //tnx.Rollback();
                //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Registration  Successfully </br><b style='color:blue'>UHID :" + PatientID + "</b>", LedgerTransactionNo = LedgerTransactionNo, IsBill = IsBill, PatientID = PatientID });
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });


            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In PatientMaster" });
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateRegistration(object Data, string EmergencyNotify, string EmergencyAddress, string EmergencyAddressPhoneNo, string EmergencyRelationShip, object MultiPanels, string updateReasonRemarks)
    {
        List<Patient_Master> dataReg = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(Data);
        List<PatientMultiPanel> dataPMultiPanel = new JavaScriptSerializer().ConvertToType<List<PatientMultiPanel>>(MultiPanels);

        int len = dataReg.Count;
        string regledgertransactionNo = string.Empty;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD = new ExcuteCMD();


            var IsdefaultPanelID = dataPMultiPanel.Where(i => i.IsDefaultPanel == 1).ToList();
            if (IsdefaultPanelID.Count > 0)
            {
                dataReg[0].PanelID = Util.GetInt(IsdefaultPanelID[0].PPanelID);
            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Kindly Select The One  Panel As Default", message = "Kindly Select The One  Panel As Default" });
            }

            try
            {
                if (!string.IsNullOrEmpty(dataReg[0].PatientID))
                {
                    string PatientInfo = Update_PatientInfo.updatePatientMaster(dataReg, tnx, con);
                    excuteCMD.DML(tnx, "INSERT INTO  patient_master_editreason_log (EditReason, EditBy,IPAddress,PatientID) VALUES (@editReason,@editBy,@ipAddress,@PatientID)", CommandType.Text, new
                    {

                        editReason = updateReasonRemarks,
                        editBy = HttpContext.Current.Session["ID"].ToString(),
                        ipAddress = All_LoadData.IpAddress(),
                        PatientID = dataReg[0].PatientID
                    });


                    int dtMultiPanelExit = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_policy_detail WHERE Patient_ID='" + dataReg[0].PatientID + "'"));

                    if (dtMultiPanelExit != 0)
                    {
                        string ExitPanelDeactive = "update patient_policy_detail ppd set ppd.IsActive=0,ppd.UpdatedBy=@UpdatedBy,UpdatedDate=NOW() WHERE Patient_ID=@Patient_ID";
                        excuteCMD.DML(tnx, ExitPanelDeactive, CommandType.Text, new
                        {
                            UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                            Patient_ID = dataReg[0].PatientID
                        });
                    }
                    dataPMultiPanel.ForEach(i =>
                    {
                        string strmp = @" INSERT INTO patient_policy_detail(Patient_ID,PolicyNo,PolicyExpiry,Panel_ID,CreatedBy,CreatedDate,IsActive,PanelGroupID,ParentPanelID,PanelCroporateID,PolicyCardNo,PanelCardName,PolciyCardHolderRelation,ApprovalAmount,ApprovalRemarks,IsDefaultPanel)
                                            VALUES(@Patient_ID,@PolicyNo,@PolicyExpiry,@Panel_ID,@CreatedBy,NOW(),1,@PanelGroupID,@ParentPanelID,@PanelCroporateID,@PolicyCardNo,@PanelCardName,@PolciyCardHolderRelation,@ApprovalAmount,@ApprovalRemarks,@IsDefaultPanel);";
                        excuteCMD.DML(tnx, strmp, CommandType.Text, new
                        {
                            Patient_ID = dataReg[0].PatientID,
                            PolicyNo = i.PPolicyNo,
                            PolicyExpiry = Util.GetDateTime(i.PExpiryDate).ToString("yyyy-MM-dd"),
                            Panel_ID = Util.GetInt(i.PPanelID),
                            CreatedBy = HttpContext.Current.Session["ID"],
                            PanelGroupID = Util.GetInt(i.PPanelGroupID),
                            ParentPanelID = Util.GetInt(i.PParentPanelID),
                            PanelCroporateID = Util.GetInt(i.PPanelCorporateID),
                            PolicyCardNo = i.PCardNo,
                            PanelCardName = i.PCardHolderName,
                            PolciyCardHolderRelation = i.PCardHolderRelation,
                            ApprovalAmount = i.PApprovalAmount,
                            ApprovalRemarks = i.PApprovalRemarks,
                            IsDefaultPanel = Util.GetInt(i.IsDefaultPanel)
                        });
                    });



                    if (string.IsNullOrEmpty(PatientInfo))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Master" });
                    }

                }

                else
                {
                    var PatientInfo = Insert_PatientInfo.savePatientMaster(dataReg, tnx, con);
                    if (PatientInfo.Count == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Master" });
                    }
                }
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Master" });

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Master" });
        }

    }
    [WebMethod]
    public string PrintSticker(string PatientID)
    {
        string data = string.Empty;
        StringBuilder applet = new StringBuilder();
        string str1 = "SELECT CONCAT(Title,' ',PFirstName)pname,PatientID,Gender,IFNULL(mobile,'')ContactNo,Get_Current_Age(PatientID)Age,DATE_FORMAT(DateEnrolled,'%d-%b-%Y')DateEnrolled,CONCAT(LOWER(House_No),' ',LOWER(Street_Name))Address,Concat(Taluka,' ',Place,' ',District)Place,Mobile,IF(Relation!='',(CONCAT(Relation,' ',RelationName)),'N/A')RelationName,IF(occupation!='',occupation,'N/A')occupation  FROM patient_master WHERE PatientID='" + PatientID + "'";
        DataTable dt = StockReports.GetDataTable(str1);
        if (dt.Rows.Count > 0)
        {
            data = data + "" + (data == "" ? "" : "^") + dt.Rows[0]["Pname"].ToString() + "#" + dt.Rows[0]["age"].ToString() + "/" + dt.Rows[0]["gender"].ToString() + "#" +
                dt.Rows[0]["PatientID"].ToString() + "#" + dt.Rows[0]["DateEnrolled"].ToString() + "#" + dt.Rows[0]["Address"].ToString() + "#" +
                dt.Rows[0]["Mobile"].ToString() + "#" + dt.Rows[0]["Place"].ToString() + "#" + dt.Rows[0]["RelationName"].ToString() + "#" + dt.Rows[0]["occupation"].ToString();
            return data;
        }
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public string SaveBulkPatientRegistration(string Qty, string Gender, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string Title = string.Empty;
            if (Gender == "Male")
                Title = "Mr.";
            else if (Gender == "Female")
                Title = "Mrs.";
            else
                Title = "Mrs.";
            // var maxID = excuteCMD.ExecuteScalar(tnx, "SELECT MAX(IfNull(MaxID,0))+1 FROM patient_bulk_registration", CommandType.Text, new { });
            var maxID = 1;
            var lastNo = 0;
            var result = excuteCMD.ExecuteScalar(tnx, "SELECT CONCAT(MaxID,'#',MAX(CAST(SUBSTRING(PatientName,5) AS UNSIGNED))) FROM patient_bulk_registration GROUP BY MaxID ORDER BY MaxID DESC LIMIT 1", CommandType.Text, new { });
            if (!string.IsNullOrEmpty(result))
            {
                maxID = Util.GetInt(result.Split('#')[0]) + 1;
                lastNo = Util.GetInt(result.Split('#')[1]);
            }

            for (int i = 0; i < Util.GetInt(Qty); i++)
            {
                var sqlCMD = "INSERT INTO patient_bulk_registration (PatientID,Title,Gender,PatientName,Mobile,City,DOB,Age,Remarks,EntryBy,maxID) VALUES(@PatientID,@Title,@Gender,@PatientName,@Mobile,@City,@DOB,@Age,@Remarks,@EntryBy,@maxID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        PatientID = "",
                        Title = Title,
                        Gender = Gender,
                        PatientName = "Bulk" + (lastNo + i + 1),
                        Mobile = "0000000000",
                        City = Resources.Resource.DefaultCityID,
                        DOB = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")),
                        Age = "0 YRS",
                        Remarks = Remarks,
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        maxID = maxID
                    });
            }
            var sql = "CALL Insert_Bulk_Patient(@CentreID)";
            excuteCMD.ExecuteScalar(tnx, sql, CommandType.Text, new
                    {
                        CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                    });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully", BulkID = maxID });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Master" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string searchPreviousData(string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Remarks,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %I:%i %p')EntryDateTime,CONCAT(em.Title,'',em.Name)EName,COUNT(pr.ID)TotalQty,pr.Gender,pr.maxID  ");
        sb.Append("FROM  patient_bulk_registration pr ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=pr.EntryBy ");
        sb.Append("WHERE pr.ENtryDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND pr.ENtryDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("GROUP BY maxID ORDER BY maxID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string PrintBulkRegistration(string BulkID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pm.PatientID as Patient_ID,'' PNAME,pm.Gender,'' Age,'' DOB,'' Mobile,'' Address,pr.Remarks,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %I:%i %p')EntryDateTime FROM patient_bulk_registration pr ");
        sb.Append("INNER JOIN patient_master pm ON pr.ID=pm.OldPatientID ");
        sb.Append("WHERE pr.MaxID=" + BulkID + " ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        //   ds.WriteXmlSchema(@"D:\PrintBulkRegistrationPrint.xml");
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "PrintBulkRegistrationPrint";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
    }
}