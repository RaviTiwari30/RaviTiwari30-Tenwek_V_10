<%@ WebService Language="C#" Class="IPDAdmission" %>

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
using System.IO;
using System.Text;
using System.Linq;
using System.Net.Http;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//[ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class IPDAdmission : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string bindRoomType()
    {
        DataTable dt = AllLoadData_IPD.LoadCaseType();
        if (dt.Rows.Count > 0)
        {
            DataView view = dt.DefaultView;
            view.RowFilter = "IsEmergency=0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(view.ToTable());
        }
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindBillingCategory()
    {
        DataTable dt = AllLoadData_IPD.BillingCategory();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindRoomBed(string caseType, int IsDisIntimated, string type, string bookingDate)
    {
        DataTable dt = AllLoadData_IPD.loadRoom(caseType, IsDisIntimated, type, bookingDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string AdmissionType()
    {
        DataTable dt = AllLoadData_IPD.dtAdmissionType();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindProMaster()
    {
        DataTable dt = AllLoadData_IPD.bindProMaster();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindReferDoctor()
    {
        DataTable dt = LoadCacheQuery.loadReferDoctor();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindAdmissionDoctor()
    {
        DataTable dt = All_LoadData.bindDoctor();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindPanel()
    {
        DataTable dtPanel = LoadCacheQuery.loadIPDPanel(HttpContext.Current.Session["CentreID"].ToString());
        if (dtPanel.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindPanelRoleWisePanelGroupWise()
    {
        DataTable dtPanel = All_LoadData.loadPanelRoleWisePanelGroupWise(0);// LoadCacheQuery.loadIPDPanel(HttpContext.Current.Session["CentreID"].ToString());
        if (dtPanel.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindCarHolderRelation()
    {
        string[] Relation = AllGlobalFunction.KinRelation;
        return Newtonsoft.Json.JsonConvert.SerializeObject(Relation);
    }
    [WebMethod(EnableSession = true)]
    public string bindAdmittedRoomBed(string caseType, int IsDisIntimated)
    {
        DataTable dt = AllLoadData_IPD.loadRoom(caseType, IsDisIntimated, "", "");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindAdmittedDoctor(string TID)
    {
        DataTable dt = AllLoadData_IPD.bindAdmittedDoctor(TID);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindDeliveryType()
    {
        string[] DeliveryType = AllGlobalFunction.DeliveryType;
        return Newtonsoft.Json.JsonConvert.SerializeObject(DeliveryType);
    }
    [WebMethod(EnableSession = true)]
    public string bindDeliveryDays()
    {
        string[] DeliveryDays = AllGlobalFunction.DeliveryDays;
        return Newtonsoft.Json.JsonConvert.SerializeObject(DeliveryDays);
    }
    [WebMethod(EnableSession = true)]
    public string bindDeliveryWeeks()
    {
        string[] DeliveryWeeks = AllGlobalFunction.DeliveryWeeks;
        return Newtonsoft.Json.JsonConvert.SerializeObject(DeliveryWeeks);
    }
    [WebMethod(EnableSession = true, Description = "Save IPD Admission")]
    public string SaveIPDAdmission(object PM, object PMH, object ICH, object PIP, object IPDAdj, List<doctors> doctors, int IsAdvance, object patientDocuments, List<PanelDocument> panelDocuments, int isAdmissionAgainstAdvanceBooking, int advanceID, bool sendApprovalEmail, string approvalAmount, string approvalRemark)
    {
        List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<IPD_Case_History> dataICH = new JavaScriptSerializer().ConvertToType<List<IPD_Case_History>>(ICH);
        List<Patient_IPD_Profile> dataPIP = new JavaScriptSerializer().ConvertToType<List<Patient_IPD_Profile>>(PIP);
        List<ipdadjustment> dataIPDAdj = new JavaScriptSerializer().ConvertToType<List<ipdadjustment>>(IPDAdj);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            if (doctors.Count < 1)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Doctors", message = "Error In IPD Adjustment" });
            }

            string PatientID = string.Empty; string TID = string.Empty; string ScheduleChargeID = string.Empty; string Date = string.Empty; string Time = string.Empty; string Update = string.Empty;

            var PatientInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
            }
            else
                PatientID = PatientInfo[0].PatientID;
            if (PatientID != "")
            {
                int blacklist = Util.GetInt(StockReports.ExecuteScalar("select COUNT(*) from blacklist bl where date(bl.StartDate)>=date(now()) and bl.IsBlackList=1 and bl.PatientID='" + PatientID + "'"));
                if (blacklist > 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This patient has been blacklist.", message = "This patient has been blacklist." });
                }
            }

            string EmgStatus = Util.GetString(StockReports.ExecuteScalar("SELECT IsReleased FROM Emergency_Patient_Details WHERE  PatientId='" + PatientID + "'"));
            if (EmgStatus == "0")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Already Admitted In Emergency.", message = "Please Already Admitted In Emergency." });
            }
            else if (EmgStatus == "2")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Already Released From Emergency for IPD. Kindly Shift to IPD.", message = "Please Already Admitted In Emergency." });
            }
            //int checkalreadyadmitted = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM ipd_case_history ich INNER JOIN f_ipdadjustment adj ON adj.TransactionID=ich.TransactionID "+
            //                           " WHERE  ich.Status='IN' AND adj.PatientID='" + PatientID + "' "));

            int checkalreadyadmitted = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_medical_history ich WHERE  ich.Status='IN' AND ich.`TYPE`='IPD'  AND ich.PatientID='" + PatientID + "' "));

            if (checkalreadyadmitted > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Already Admitted.", message = "Please Already Admitted." });
            }
            PatientDocument.SaveDocument(patientDocuments, PatientID);

            //*********************Insert Patient Medical History******************************//
            if (!string.IsNullOrEmpty(PatientID))
            {
                PanelAllocation Pa = new PanelAllocation();
                Patient_Medical_History objPatient_Medical_History = new Patient_Medical_History(tnx);
                objPatient_Medical_History.PatientID = PatientID;
                objPatient_Medical_History.DoctorID = doctors[0].doctorID;
                objPatient_Medical_History.DoctorID1 = Util.GetString(doctors.Count > 1 ? doctors[1].doctorID : "");//    dataPMH[0].DoctorID1;
                objPatient_Medical_History.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPatient_Medical_History.Time = Util.GetDateTime(dataPMH[0].Time.ToString("HH:mm:ss"));
                int docLen = doctors.Count;
                if (docLen > 2)
                    objPatient_Medical_History.IsMultipleDoctor = Util.GetInt(1);
                else
                    objPatient_Medical_History.IsMultipleDoctor = Util.GetInt(0);
                objPatient_Medical_History.DateOfVisit = Convert.ToDateTime(dataPMH[0].DateOfVisit.ToString("yyyy-MM-dd"));
                objPatient_Medical_History.FeesPaid = dataPMH[0].FeesPaid;
                objPatient_Medical_History.Type = "IPD";
                objPatient_Medical_History.UserID = HttpContext.Current.Session["ID"].ToString();
                objPatient_Medical_History.EntryDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                objPatient_Medical_History.PanelID = dataPMH[0].PanelID;
                objPatient_Medical_History.Source = dataPMH[0].Source;
                objPatient_Medical_History.ReferedBy = dataPMH[0].ReferedBy;
                objPatient_Medical_History.KinRelation = dataPMH[0].KinRelation;
                objPatient_Medical_History.KinName = dataPMH[0].KinName;
                objPatient_Medical_History.KinPhone = dataPMH[0].KinPhone;
                objPatient_Medical_History.ParentID = dataPMH[0].ParentID;
                objPatient_Medical_History.patient_type = PatientInfo[0].HospPatientType;
                objPatient_Medical_History.PolicyNo = dataPMH[0].PolicyNo;
                objPatient_Medical_History.ExpiryDate = dataPMH[0].ExpiryDate;
                //objPatient_Medical_History.Employee_id = "";
                objPatient_Medical_History.EmployeeID = "";
                objPatient_Medical_History.EmployeeDependentName = dataPMH[0].EmployeeDependentName;
                objPatient_Medical_History.DependentRelation = dataPMH[0].DependentRelation;
                objPatient_Medical_History.CardNo = dataPMH[0].CardNo;
                ScheduleChargeID = AllLoadData_IPD.GetScheduleChargeID(Util.GetInt(dataPMH[0].PanelID));
                objPatient_Medical_History.Admission_Type = dataPMH[0].Admission_Type;
                objPatient_Medical_History.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
                objPatient_Medical_History.PanelIgnoreReason = dataPMH[0].PanelIgnoreReason;
                objPatient_Medical_History.CardHolderName = dataPMH[0].EmployeeDependentName;
                objPatient_Medical_History.RelationWith_holder = dataPMH[0].RelationWith_holder;
                objPatient_Medical_History.HashCode = dataPMH[0].HashCode;
                objPatient_Medical_History.MLC_NO = dataPMH[0].MLC_NO;
                objPatient_Medical_History.MLC_Type = dataPMH[0].MLC_Type;
                if (Util.GetInt(dataPMH[0].isBirthDetail) == 1)
                    objPatient_Medical_History.MotherTID = "ISHHI" + dataPMH[0].MotherTID;
                else
                    objPatient_Medical_History.MotherTID = string.Empty;
                if (!string.IsNullOrWhiteSpace(dataPMH[0].TypeOfDelivery))
                    objPatient_Medical_History.TypeOfDelivery = dataPMH[0].TypeOfDelivery;
                else
                    objPatient_Medical_History.TypeOfDelivery = string.Empty;
                if (!string.IsNullOrWhiteSpace(dataPMH[0].DeliveryWeeks))
                    objPatient_Medical_History.DeliveryWeeks = dataPMH[0].DeliveryWeeks;
                else
                    objPatient_Medical_History.DeliveryWeeks = string.Empty;
                if (!string.IsNullOrWhiteSpace(dataPMH[0].Weight))
                    objPatient_Medical_History.Weight = dataPMH[0].Weight;
                else
                    objPatient_Medical_History.Weight = string.Empty;
                if (!string.IsNullOrWhiteSpace(dataPMH[0].Height))
                    objPatient_Medical_History.Height = dataPMH[0].Height;
                else
                    objPatient_Medical_History.Height = string.Empty;

                objPatient_Medical_History.isAdvance = IsAdvance;

                objPatient_Medical_History.BirthIgnoreReason = dataPMH[0].BirthIgnoreReason;
                objPatient_Medical_History.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPatient_Medical_History.IsNewPatient = Util.GetInt(PatientInfo[0].IsNewPatient);
                objPatient_Medical_History.ProId = dataPMH[0].ProId;
                objPatient_Medical_History.AdmissionReason = dataPMH[0].AdmissionReason;
                objPatient_Medical_History.DateOfAdmit = Util.GetDateTime(dataPMH[0].DateOfVisit.ToString("yyyy-MM-dd"));//
                objPatient_Medical_History.TimeOfAdmit = Util.GetDateTime(dataPMH[0].Time.ToString("HH:mm:ss"));//
                objPatient_Medical_History.DateOfDischarge = DateTime.Parse("01/01/0001");//
                objPatient_Medical_History.TimeOfDischarge = DateTime.Parse("00:00:00");//
                objPatient_Medical_History.STATUS = "IN";//
                objPatient_Medical_History.GroupID = "1";//
                objPatient_Medical_History.Consultant_Name = doctors[0].doctorName;//
                objPatient_Medical_History.CurrentAge = PatientInfo[0].Age;//
                objPatient_Medical_History.patient_type = dataPMH[0].patient_type;//
                objPatient_Medical_History.BillingRemarks = string.Empty;//
                objPatient_Medical_History.CreditLimitType = dataIPDAdj[0].CreditLimitType;//
                objPatient_Medical_History.CreditLimitPanel = dataIPDAdj[0].CreditLimitPanel;//
                objPatient_Medical_History.IsRoomRequest = dataICH[0].IsRoomRequest;//
                objPatient_Medical_History.RequestedRoomType = dataICH[0].RequestedRoomType;//
                objPatient_Medical_History.ReferralTypeID = dataPMH[0].ReferralTypeID;
                objPatient_Medical_History.AdmittedIPDCaseTypeID = Util.GetInt(dataPIP[0].IPDCaseTypeID);
                objPatient_Medical_History.CurrentIPDCaseTypeID = Util.GetInt(dataPIP[0].IPDCaseTypeID);
                objPatient_Medical_History.AdmittedRoomID = Util.GetInt(dataPIP[0].RoomID);
                objPatient_Medical_History.CurrentRoomID = Util.GetInt(dataPIP[0].RoomID);
                objPatient_Medical_History.BillingIPDCaseTypeID = Util.GetInt(dataPIP[0].IPDCaseTypeID_Bill);
                objPatient_Medical_History.EmergencyTransactionId = Pa.GetEmergencyTransactionID(PatientID);
                
                TID = objPatient_Medical_History.Insert();
                if (TID == string.Empty)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Medical History" });
                }


                PatientDocument.SavePanelDocument(panelDocuments, TID, PatientID, dataPMH[0].PanelID);
                
                //---Insert into Patient_IPD_Profile-----------//
                Patient_IPD_Profile objPatient_IPD_Profile = new Patient_IPD_Profile(tnx);
                objPatient_IPD_Profile.IsTempAllocated = 0;
                objPatient_IPD_Profile.Status = "IN";
                objPatient_IPD_Profile.TransactionID = TID;
                objPatient_IPD_Profile.IPDCaseTypeID = dataPIP[0].IPDCaseTypeID;
                objPatient_IPD_Profile.StartDate = Util.GetDateTime(dataPMH[0].DateOfVisit.ToString("yyyy-MM-dd"));
                objPatient_IPD_Profile.StartTime = Util.GetDateTime(dataPMH[0].Time.ToString("HH:mm:ss"));
                objPatient_IPD_Profile.RoomID = dataPIP[0].RoomID;
                // objIPD_Case_History.DateOfDischarge = DateTime.Parse("01/01/0001");
                //  objIPD_Case_History.TimeOfDischarge = DateTime.Parse("00:00:00");
                objPatient_IPD_Profile.TobeBill = 1;
                objPatient_IPD_Profile.PatientID = PatientID;
                objPatient_IPD_Profile.IPDCaseTypeID_Bill = dataPIP[0].IPDCaseTypeID_Bill;
                objPatient_IPD_Profile.PanelID = dataPIP[0].PanelID;
                objPatient_IPD_Profile.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPatient_IPD_Profile.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                int pIPCount = objPatient_IPD_Profile.Insert();
                if (pIPCount == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In IPD Profile" });
                }
                //=============== MAKING PATIENT'S LEDGER A/C IN LEDGER MASTER IF LEDGER NO DOES NOT EXIST=========
                bool Saved = false;
                Saved = CreateStockMaster.CheckLedgerNoByPatientID(PatientID, "PTNT");

                if (Saved == false)
                {
                    Ledger_Master objLedMas = new Ledger_Master(tnx);
                    objLedMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedMas.GroupID = "PTNT";
                    objLedMas.LegderName = dataPM[0].PFirstName.Trim() + " " + dataPM[0].PLastName.Trim();
                    objLedMas.LedgerUserID = PatientID;
                    objLedMas.OpeningBalance = 0;
                    objLedMas.Insert().ToString();
                }

                AllQuery AQ = new AllQuery();
                string ledgerNumber = AQ.GetLedgerNoByPatientID(PatientID, tnx);

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE patient_medical_history SET PatientLedgerNo='" + ledgerNumber + "' WHERE TransactionID='" + TID + "' ");//
                
                Date = Util.GetDateTime(dataPMH[0].DateOfVisit).ToString("yyyy-MM-dd");
                Time = Util.GetDateTime(dataPMH[0].Time).ToString("HH:mm:ss");
                
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert into f_DoctorShift (TransactionID,DoctorID,FromDate,FromTime,UserID,Status) values('" + TID + "','" + doctors[0].doctorID + "','" + Date + "','" + Util.GetDateTime(dataPMH[0].Time).ToString("HH:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','IN' )");

                DataTable dtDocument = MySqlHelper.ExecuteDataset(con, CommandType.Text, "Select PanelDocumentID from f_paneldocumentdetail where PanelID=" + dataIPDAdj[0].PanelID + " and IsActive=1").Tables[0];

                if (dtDocument.Rows.Count > 0)
                {
                    foreach (DataRow drDocs in dtDocument.Rows)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert into f_paneldocument_patient(PanelDocumentID,TransactionID,IsActive)values(" + drDocs["PanelDocumentID"].ToString() + ",'" + TID + "',1)");
                    }
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " Insert into emr_ipd_details (TransactionID) values ('" + TID + "')");



                //insert multipleDoctors
                for (int i = 0; i < doctors.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert into f_multipledoctor_ipd(TransactionID,DoctorID,DoctorName)values('" + TID + "','" + doctors[i].doctorID + "','" + doctors[i].doctorName + "')");

                }

                string ReferenceCode = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Referencecode FROM f_panel_master WHERE PanelID=1"));


                //******************Insert Room Charges*************************//

                string shiftDate = Util.GetDateTime(dataPMH[0].DateOfVisit).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(dataPMH[0].Time).ToString("HH:mm:ss");
                RoomBilling objRoom = new RoomBilling();
                if (Resources.Resource.IPD_Room_DocVisit_Admission_Charges.Split('#')[0].ToString() == "1")
                {

                    string RoomDetail = objRoom.GetRoomItemDetails(Util.GetInt(ReferenceCode), dataPIP[0].IPDCaseTypeID, Util.GetInt(ScheduleChargeID));//ToChangeRoomBill

                    if (RoomDetail != "")
                    {
                        RoomBilling RBill = new RoomBilling();
                        string RoomBill = RBill.RoomBill(HttpContext.Current.Session["HOSPID"].ToString(), TID, PatientID, Util.GetString(RoomDetail.Split('#')[3]), HttpContext.Current.Session["ID"].ToString(), Util.GetInt(dataIPDAdj[0].PanelID.ToString()), Util.GetString(RoomDetail.Split('#')[0].ToString()), Util.GetString(RoomDetail.Split('#')[1].ToString()), "", Util.GetDecimal(RoomDetail.Split('#')[2].ToString()), Date, Time, Util.GetString(RoomDetail.Split('#')[4]), shiftDate, tnx, dataPIP[0].IPDCaseTypeID, Util.GetInt(RoomDetail.Split('#')[5]), PatientInfo[0].HospPatientType, con, doctors[0].doctorID, dataPIP[0].RoomID);

                        if (RoomBill == "0")
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Room Billing" });
                        }
                    }
                }

                //**************Insert Doctor Visit************************//

                if (Resources.Resource.IPD_Room_DocVisit_Admission_Charges.Split('#')[1].ToString() == "1")
                {

                    string DocitemID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT itemID FROM f_itemmaster WHERE SubCategoryID='" + Resources.Resource.AdmissionDoctorVisitSubCatrgoryID + "' AND Type_ID='" + doctors[0].doctorID + "' "));
                    string DocVisit = objRoom.GetItemRateDetails(ReferenceCode, dataPIP[0].IPDCaseTypeID_Bill, ScheduleChargeID.ToString(), DocitemID, "1", con);
                    if (DocVisit.Split('#')[0].ToString() != "")
                    {
                        RoomBilling RBill1 = new RoomBilling();
                        string RoomBill = RBill1.RoomBill(HttpContext.Current.Session["HOSPID"].ToString(), TID, PatientID, Util.GetString(DocVisit.Split('#')[3]), HttpContext.Current.Session["ID"].ToString(), dataIPDAdj[0].PanelID, Util.GetString(DocVisit.Split('#')[0].ToString()), Util.GetString(DocVisit.Split('#')[1].ToString()), "", Util.GetDecimal(DocVisit.Split('#')[2].ToString()), Date, Time, Util.GetString(DocVisit.Split('#')[4]), shiftDate, tnx, dataPIP[0].IPDCaseTypeID, Util.GetInt(DocVisit.Split('#')[5]), PatientInfo[0].HospPatientType, con, doctors[0].doctorID, dataPIP[0].RoomID);
                        if (RoomBill != "1" && RoomBill != "2")
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Doctor Visit" });
                        }
                    }
                }

              
                //**************Insert Admission Charges************************//

                if (Resources.Resource.IPD_Room_DocVisit_Admission_Charges.Split('#')[2].ToString() == "1")
                {
                    string AdmissionCharge = objRoom.GetItemRateDetails(ReferenceCode, dataPIP[0].IPDCaseTypeID_Bill, ScheduleChargeID.ToString(), "5394", "20", con);

                    if (AdmissionCharge.Split('#')[0].ToString() != "")
                    {
                        RoomBilling RBill = new RoomBilling();
                        string RoomBill = RBill.RoomBill(HttpContext.Current.Session["HOSPID"].ToString(), TID, PatientID, Util.GetString(AdmissionCharge.Split('#')[3]), HttpContext.Current.Session["ID"].ToString(), dataIPDAdj[0].PanelID, Util.GetString(AdmissionCharge.Split('#')[0].ToString()), Util.GetString(AdmissionCharge.Split('#')[1].ToString()), "", Util.GetDecimal(AdmissionCharge.Split('#')[2].ToString()), Date, Time, Util.GetString(AdmissionCharge.Split('#')[4]), shiftDate, tnx, dataPIP[0].IPDCaseTypeID, Util.GetInt(AdmissionCharge.Split('#')[5]), PatientInfo[0].HospPatientType, con, doctors[0].doctorID, dataPIP[0].RoomID);
                        if (RoomBill != "1" && RoomBill != "2")
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In IPD Admission Charges" });
                        }
                    }
                }



                string notification = "";

                for (int i = 0; i < doctors.Count; i++)
                {
                    notification = Notification_Insert.notificationInsert(29, TID, null, doctors[i].doctorID, "", 0, Util.GetString(DateTime.Now.ToString("yyyy-MM-dd")));
                }

                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT fr.Role_ID FROM room_master rm INNER JOIN floor_master fm ON  fm.Name=rm.Floor INNER JOIN f_RoomType_role fr ON fr.FloorID=fm.ID Where RoomID='" + Util.GetString(dataPIP[0].RoomID) + "' GROUP BY fr.role_ID ").Tables[0];
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        notification = Notification_Insert.notificationInsert(29, TID, null, "", "", Util.GetInt(dt.Rows[i]["Role_ID"]), "0001-01-01", "");
                    }
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=2 WHERE RoomID='" + Util.GetString(dataPIP[0].RoomID) + "' ");

                if (isAdmissionAgainstAdvanceBooking == 1)
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "  UPDATE advance_room_booking SET IsAdmitted=1,TransactionID='" + Util.GetString(TID) + "',AdmittedBy='" + HttpContext.Current.Session["ID"].ToString() + "',AdmittedDateTime=NOW(),AdmittedRoomID='" + Util.GetString(dataPIP[0].RoomID) + "',AdmittedIPDCaseTypeID='" + Util.GetString(dataPIP[0].IPDCaseTypeID) + "',AdmittedIPDCaseTypeID_Bill='" + Util.GetString(dataPIP[0].IPDCaseTypeID_Bill) + "' WHERE ID=" + Util.GetInt(advanceID) + " ");


                //Devendra Singh 2018-11-12 Insert Finance Integarion 
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertIPDRevenueAtTimeAdmission(TID, "R", tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Intregation." });
                    }
                }

                int TransferRequestPatientID = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(id) FROM PatientTransferReqest ptr WHERE ptr.PatientID='" + PatientID + "' AND ptr.AdmissionStatus=0 AND ptr.IsActive=1"));
                if (TransferRequestPatientID != 0)
                {
                    string sqlCmd = "UPDATE PatientTransferReqest ptr  SET ptr.AdmissionStatus=@AdmissionStatus,ptr.AdmissionBy=@AdmissionBy,ptr.AdmissionDate=NOW(),ptr.TransactionID=@TransactionID ";
                    sqlCmd += "     WHERE ptr.PatientID=@PatientID AND ptr.AdmissionStatus=0 AND ptr.IsActive=1; ";

                    excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                    {
                        AdmissionStatus = 1,
                        AdmissionBy = HttpContext.Current.Session["ID"].ToString(),
                        TransactionID = TID.ToString(),
                        PatientID = PatientID.ToString()
                    });

                }
                tnx.Commit();

                var IPDNo = StockReports.getTransNobyTransactionID(TID);

                //**************** SMS************************//
                if (Resources.Resource.SMSApplicable == "1")
                {
                    // to Patient 
                    var columninfo = smstemplate.getColumnInfo(7, con);
                    if (columninfo.Count > 0)
                    {
                        columninfo[0].PName = dataPM[0].PName;
                        columninfo[0].Title = dataPM[0].Title;
                        columninfo[0].ContactNo = dataPM[0].Mobile;
                        columninfo[0].TemplateID = 7;
                        columninfo[0].PatientID = dataPMH[0].PatientID;
                        columninfo[0].DoctorName = StockReports.ExecuteScalar("SELECT CONCAT(Title,NAME,' (',Designation,')') FROM Doctor_master WHERE DoctorID=" + doctors[0].doctorID + " ");
                        columninfo[0].TransactionID = IPDNo;
                        string sms = smstemplate.getSMSTemplate(7, columninfo, 2, con, HttpContext.Current.Session["ID"].ToString());
                    }


                    // To Doctor

                    var columninfo1 = smstemplate.getColumnInfo(6, con);
                    if (columninfo1.Count > 0)
                    {
                        string DocMobile = StockReports.ExecuteScalar("SELECT dm.Mobile AS MobileNo FROM  doctor_master dm  WHERE DoctorID='" + doctors[0].doctorID + "'");
                        string IpdCaseTypeName = StockReports.ExecuteScalar("SELECT TRIM(CONCAT(rm.Floor,'/',icm.Name,'/',CONCAT(TRIM(rm.Name),'-',RM.Room_No),'/',TRIM(rm.Bed_No))) " +
                                                 "FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID " +
                                                 "WHERE rm.RoomId='" + dataPIP[0].RoomID + "'");
                         string [] mobileArray;
                         if (DocMobile != "")
                         {
                             mobileArray = DocMobile.Split('/');
                             foreach (var mobile in mobileArray)
                             {

                                 columninfo1[0].PName = dataPM[0].Title + dataPM[0].PName + " / " + dataPM[0].Gender + " / " + dataPM[0].Age;
                                 columninfo1[0].Title = dataPM[0].Title;
                                 columninfo1[0].ContactNo = mobile;
                                 columninfo1[0].TemplateID = 6;
                                 columninfo1[0].PatientID = dataPMH[0].PatientID;
                                 columninfo1[0].Ward = IpdCaseTypeName;
                                 columninfo1[0].TransactionID = IPDNo;
                                 string sms = smstemplate.getSMSTemplate(6, columninfo1, 2, con, HttpContext.Current.Session["ID"].ToString());

                             }
                         }
                        
                    }

                }
                
                
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "<b style='color:black;font-size: 16px;'> IPD Number &nbsp;:&nbsp;" + IPDNo + "</b></br><b style='color:black;font-size: 16px;'> UHID &nbsp;:&nbsp;" + PatientID + "<b>", IPDNO = IPDNo, patientID = PatientID, transactionID = TID });
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Notification Entry" });
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
    public class doctors
    {
        public string doctorID { get; set; }
        public string doctorName { get; set; }
    }
    [WebMethod(EnableSession = true, Description = "Update IPD Admission")]
    public string UpdateIPDAdmission(object PM, object PMH, object ICH, object PIP, object IPDAdj, List<doctors> doctors, int IsAdvance)
    {
        List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<IPD_Case_History> dataICH = new JavaScriptSerializer().ConvertToType<List<IPD_Case_History>>(ICH);
        List<Patient_IPD_Profile> dataPIP = new JavaScriptSerializer().ConvertToType<List<Patient_IPD_Profile>>(PIP);
        List<ipdadjustment> dataIPDAdj = new JavaScriptSerializer().ConvertToType<List<ipdadjustment>>(IPDAdj);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string PatientID = string.Empty; string TID = string.Empty; string ScheduleChargeID = string.Empty; string Update = string.Empty;

            Patient_Medical_History objPatient_Medical_History = new Patient_Medical_History(tnx);
            PatientID = dataPMH[0].PatientID;
            TID = dataPMH[0].TransactionID;
            objPatient_Medical_History.TransactionID = dataPMH[0].TransactionID;
            objPatient_Medical_History.PatientID = PatientID;
            objPatient_Medical_History.DoctorID = doctors[0].doctorID;
            objPatient_Medical_History.DoctorID1 = Util.GetString(doctors.Count > 1 ? doctors[1].doctorID : "");
            objPatient_Medical_History.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objPatient_Medical_History.Time = Util.GetDateTime(dataPMH[0].Time.ToString("HH:mm:ss"));
            int Doclen = doctors.Count;
            if (Doclen > 2)
                objPatient_Medical_History.IsMultipleDoctor = Util.GetInt(1);
            else
                objPatient_Medical_History.IsMultipleDoctor = Util.GetInt(0);
            objPatient_Medical_History.DateOfVisit = Convert.ToDateTime(dataPMH[0].DateOfVisit.ToString("yyyy-MM-dd"));
            objPatient_Medical_History.FeesPaid = dataPMH[0].FeesPaid;
            objPatient_Medical_History.Type = "IPD";
            objPatient_Medical_History.UserID = HttpContext.Current.Session["ID"].ToString();
            objPatient_Medical_History.EntryDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPatient_Medical_History.EntryDate = Convert.ToDateTime(DateTime.Now.ToString("HH:mm:ss"));
            objPatient_Medical_History.PanelID = dataPMH[0].PanelID;
            objPatient_Medical_History.Source = dataPMH[0].Source;
            objPatient_Medical_History.ReferedBy = dataPMH[0].ReferedBy;
            objPatient_Medical_History.KinPhone = dataPMH[0].KinPhone;
            objPatient_Medical_History.ParentID = dataPMH[0].ParentID;
            objPatient_Medical_History.Admission_Type = dataPMH[0].patient_type;
            objPatient_Medical_History.PolicyNo = dataPMH[0].PolicyNo;
            objPatient_Medical_History.EmployeeID = HttpContext.Current.Session["ID"].ToString();
            objPatient_Medical_History.EmployeeDependentName = dataPMH[0].EmployeeDependentName;
            objPatient_Medical_History.DependentRelation = dataPMH[0].DependentRelation;
            objPatient_Medical_History.CardNo = dataPMH[0].CardNo;
            ScheduleChargeID = AllLoadData_IPD.GetScheduleChargeID(Util.GetInt(dataPMH[0].PanelID));
            objPatient_Medical_History.Admission_Type = dataPMH[0].Admission_Type;
            objPatient_Medical_History.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
            objPatient_Medical_History.PanelIgnoreReason = dataPMH[0].PanelIgnoreReason;
            objPatient_Medical_History.CardHolderName = dataPMH[0].EmployeeDependentName;
            objPatient_Medical_History.RelationWith_holder = dataPMH[0].RelationWith_holder;
            objPatient_Medical_History.HashCode = dataPMH[0].HashCode;
            objPatient_Medical_History.MLC_NO = dataPMH[0].MLC_NO;
            objPatient_Medical_History.MLC_Type = dataPMH[0].MLC_Type;
            if (dataPMH[0].TypeOfDelivery != "SELECT")
                objPatient_Medical_History.TypeOfDelivery = dataPMH[0].TypeOfDelivery;
            else
                objPatient_Medical_History.TypeOfDelivery = "";
            if (dataPMH[0].DeliveryWeeks != ".")
                objPatient_Medical_History.DeliveryWeeks = dataPMH[0].DeliveryWeeks;
            else
                objPatient_Medical_History.DeliveryWeeks = "";
            if (dataPMH[0].Weight != "#Select")
                objPatient_Medical_History.Weight = dataPMH[0].Weight;
            else
                objPatient_Medical_History.Weight = "";
            if (dataPMH[0].Height != "#Select")
                objPatient_Medical_History.Height = dataPMH[0].Height;
            else
                objPatient_Medical_History.Height = "";
            objPatient_Medical_History.isAdvance = dataPMH[0].isAdvance;
            objPatient_Medical_History.ProId = dataPMH[0].ProId;
            int Row = objPatient_Medical_History.Update();
            if (Row == 0)
            {
                tnx.Rollback();
                return "";

            }
            string Date = Util.GetDateTime(dataPMH[0].DateOfVisit).ToString("yyyy-MM-dd");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " Update f_DoctorShift set DoctorID='" + dataIPDAdj[0].DoctorID + "',FromDate='" + Date + "',FromTime='" + Util.GetDateTime(dataPMH[0].Time).ToString("HH:mm:ss") + "',UserID='" + HttpContext.Current.Session["ID"].ToString() + "',Status='IN' Where TransactionID='" + TID + "' ");


            IPD_Case_History objIPD_Case_History = new IPD_Case_History(tnx);
            objIPD_Case_History.TransactionID = TID;
            objIPD_Case_History.Consultant_ID = doctors[0].doctorID;
            //objIPD_Case_History.Consultant_ID1 = dataICH[0].Consultant_ID1;
            objIPD_Case_History.Employed = "No";
            objIPD_Case_History.DateOfAdmit = Util.GetDateTime(dataPMH[0].DateOfVisit.ToString("yyyy-MM-dd"));
            objIPD_Case_History.TimeOfAdmit = Util.GetDateTime(dataPMH[0].Time.ToString("HH:mm:ss"));
            objIPD_Case_History.DateOfDischarge = DateTime.Parse("01/01/0001");
            objIPD_Case_History.TimeOfDischarge = DateTime.Parse("00:00:00");
            objIPD_Case_History.Status = "IN";
            objIPD_Case_History.Insurance = "No";
            objIPD_Case_History.IsRoomRequest = dataICH[0].IsRoomRequest;
            objIPD_Case_History.RequestedRoomType = dataICH[0].RequestedRoomType;
            objIPD_Case_History.GroupID = "1";
            objIPD_Case_History.Update();


            //---Update into Patient_IPD_Profile-----------//

            Patient_IPD_Profile objPatient_IPD_Profile = new Patient_IPD_Profile(tnx);
            objPatient_IPD_Profile.IsTempAllocated = 0;
            objPatient_IPD_Profile.Status = "IN";
            objPatient_IPD_Profile.TransactionID = TID;
            objPatient_IPD_Profile.IPDCaseTypeID = dataPIP[0].IPDCaseTypeID;
            objPatient_IPD_Profile.StartDate = Util.GetDateTime(dataPMH[0].DateOfVisit.ToString("yyyy-MM-dd"));
            objPatient_IPD_Profile.StartTime = Util.GetDateTime(dataPMH[0].Time.ToString("HH:mm:ss"));
            objPatient_IPD_Profile.RoomID = dataPIP[0].RoomID;
            objIPD_Case_History.DateOfDischarge = DateTime.Parse("01/01/0001");
            objIPD_Case_History.TimeOfDischarge = DateTime.Parse("00:00:00");
            objPatient_IPD_Profile.TobeBill = 1;
            objPatient_IPD_Profile.PatientID = PatientID;
            objPatient_IPD_Profile.IPDCaseTypeID_Bill = dataPIP[0].IPDCaseTypeID_Bill;
            objPatient_IPD_Profile.PanelID = dataPIP[0].PanelID;
            objPatient_IPD_Profile.Update();

            AllQuery AQ = new AllQuery();
            string ledgerNumber = AQ.GetLedgerNoByPatientID(dataPIP[0].PatientID, tnx);
            string UpdateAdj = " Update f_ipdadjustment set CreditLimitPanel='" + dataIPDAdj[0].CreditLimitPanel + "',CreditLimitType='" + dataIPDAdj[0].CreditLimitType + "',DoctorID='" + doctors[0].doctorID + "',PanelID=" + dataIPDAdj[0].PanelID + " Where TransactionID='" + TID + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateAdj);

            DataTable dtDocument = MySqlHelper.ExecuteDataset(con, CommandType.Text, "Select PanelDocumentID from f_paneldocumentdetail where PanelID=" + dataIPDAdj[0].PanelID + " and IsActive=1").Tables[0];
            foreach (DataRow drDocs in dtDocument.Rows)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " Update f_paneldocument_patient set PanelDocumentID ='" + drDocs["PanelDocumentID"].ToString() + "' where TransactionID='" + TID + "' ");
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from f_multipledoctor_ipd Where TransactionID='" + TID + "'  ");
            for (int i = 0; i < doctors.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert into f_multipledoctor_ipd(TransactionID,DoctorID,DoctorName)values('" + TID + "','" + doctors[i].doctorID + "','" + doctors[i].doctorName + "')");
            }
            tnx.Commit();
            return TID.Replace("ISHHI", "") + "#" + PatientID;
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
    [WebMethod]
    public string getPanelCreditLimit(string PanelID)
    {
        return StockReports.ExecuteScalar("SELECT CONCAT(CreditLimitType,'#',IFNULL(CreditLimit,0))CreditLimit FROM f_panel_master WHERE PanelID=" + PanelID + " ");
    }

    [WebMethod(EnableSession = true)]
    public string getPatientAdmissionDetails(string patientID, string transactionID)
    {

        DataTable dt = AllLoadData_IPD.bindAdmissionDetails(patientID, transactionID);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        var sqlCmd = "SELECT mi.DoctorID `value` ,mi.DoctorName `text`,(SELECT IF(COUNT(dm.`DoctorID`)>0,1,0)IsTeam FROM  doctor_master dm WHERE dm.`DoctorID`=mi.DoctorID AND dm.`IsUnit`=1)IsTeam FROM f_multipledoctor_ipd mi WHERE mi.TransactionID=@transactionID";
        DataTable doctorList = excuteCMD.GetDataTable(sqlCmd, CommandType.Text, new
        {
            transactionID = transactionID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { admissionDetails = dt, doctorList = doctorList });

    }

    [WebMethod]
    public string UpdatePatientAdmissionDetails(object data, List<doctors> doctors, string transactionID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            dynamic admissionDetails = Newtonsoft.Json.Linq.JObject.Parse(Newtonsoft.Json.JsonConvert.SerializeObject(data));

            var IsMultipleDoctor = 0;
            if (doctors.Count > 2)
                IsMultipleDoctor = 1;
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var sqlCmd = new StringBuilder("UPDATE patient_medical_history pmh SET pmh.KinName=@name,pmh.KinRelation=@relation,pmh.KinPhone=@phone,pmh.AdmissionReason=@AdmissionReason,pmh.DoctorID=@doctorID,pmh.DoctorID1=@doctorID1,pmh.IsMultipleDoctor=@IsMultipleDoctor,pmh.MLC_NO=@MLC_NO,pmh.MLC_Type=@MLC_Type,pmh.Admission_Type=@Admission_Type,pmh.Source=@Source,pmh.ProId=@ProId,RequestedRoomType=@RequestedRoomType,IsRoomRequest=@IsRoomRequest,TimeOfAdmit=@TimeOfAdmit,Consultant_Name=@Consultant_Name,ReferralTypeID=@ReferralTypeID,ReferedBy=@ReferedBy WHERE pmh.TransactionID=@TransactionID");
            excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
            {
                doctorID = Util.GetString(doctors[0].doctorID),
                doctorID1 = Util.GetString(doctors.Count > 1 ? doctors[1].doctorID : ""),
                IsMultipleDoctor = IsMultipleDoctor,
                MLC_NO = admissionDetails.MLC_NO,
                MLC_Type = admissionDetails.MLC_Type,
                Admission_Type = admissionDetails.Admission_Type,
                Source = admissionDetails.Source,
                ProId = admissionDetails.ProId,
                TransactionID = transactionID,
                AdmissionReason = admissionDetails.AdmissionReason,
                name = admissionDetails.KinName,
                relation = admissionDetails.KinRelation,
                phone = admissionDetails.KinPhone,
                Consultant_Name = Util.GetString(doctors[0].doctorID),//
                RequestedRoomType = admissionDetails.RequestedRoomType,//
                IsRoomRequest = string.IsNullOrEmpty(Util.GetString(admissionDetails.RequestedRoomType)) ? 0 : 1,//
                TimeOfAdmit = Util.GetDateTime(admissionDetails.TimeOfAdmit.ToString("HH:mm:ss")),//
                ReferralTypeID = admissionDetails.ReferralTypeID,  //
                ReferedBy = admissionDetails.ReferedBy

            });

            //sqlCmd.Clear();

            //sqlCmd.Append("UPDATE  ipd_case_history ich SET  ich.Consultant_ID=@Consultant_ID,ich.Consultant_ID1=@Consultant_ID1,ich.Consultant_Name=@Consultant_Name,");
            //sqlCmd.Append("ich.RequestedRoomType=@RequestedRoomType,ich.IsRoomRequest=@IsRoomRequest,ich.TimeOfAdmit=@TimeOfAdmit");
            //sqlCmd.Append(" WHERE ich.TransactionID=@TransactionID");
            //excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
            //{
            //    Consultant_ID = Util.GetString(doctors[0].doctorID),
            //    Consultant_ID1 = Util.GetString(doctors.Count > 1 ? doctors[1].doctorID : ""),
            //    Consultant_Name = Util.GetString(doctors[0].doctorID),
            //    RequestedRoomType = admissionDetails.RequestedRoomType,
            //    IsRoomRequest = string.IsNullOrEmpty(Util.GetString(admissionDetails.RequestedRoomType)) ? 0 : 1,
            //    TimeOfAdmit = Util.GetDateTime(admissionDetails.TimeOfAdmit.ToString("HH:mm:ss")),
            //    TransactionID = transactionID
            //});

            sqlCmd.Clear();
            sqlCmd.Append("SELECT ip.IPDCaseTypeID_Bill=@IPDCaseTypeID_Bill,ip.StartTime=@StartTime FROM  patient_ipd_profile ip WHERE ip.TransactionID=@TransactionID");
            excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
            {
                IPDCaseTypeID_Bill = Util.GetString(admissionDetails.IPDCaseTypeID_Bill),
                StartTime = Util.GetDateTime(admissionDetails.TimeOfAdmit.ToString("HH:mm:ss")),
                TransactionID = transactionID
            });

            //sqlCmd.Clear();

            //sqlCmd.Append("UPDATE f_ipdadjustment ipd SET ipd.DoctorID=@DoctorID WHERE ipd.TransactionID=@TransactionID");
            //excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
            //{
            //    doctorID = Util.GetString(doctors[0].doctorID),
            //    TransactionID = transactionID
            //});

            sqlCmd.Clear();
            sqlCmd.Append("DELETE FROM  f_multipledoctor_ipd  WHERE TransactionID=@TransactionID");

            excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
            {

                TransactionID = transactionID
            });


            foreach (var item in doctors)
            {
                sqlCmd.Clear();
                sqlCmd.Append("Insert into f_multipledoctor_ipd(TransactionID,DoctorID,DoctorName)values(@TransactionID,@DoctorID,@DoctorName)");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
                {
                    DoctorID = Util.GetString(item.doctorID),
                    DoctorName = Util.GetString(item.doctorName),
                    TransactionID = transactionID
                });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Update Successfully" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]

    public string AdvanceRoomCheck(string Roomid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pm.PatientID,CONCAT(pm.`Title`,'',pm.`PName` )PName,CONCAT(rm.`Name`,'/',rm.`Bed_No`)Name, DATE_FORMAT(arb.`BookingDate`,'%d-%b-%Y')AdDate ");
        sb.Append(" FROM advance_room_booking arb INNER JOIN room_master rm ON rm.`RoomId`=arb.`RoomID` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=arb.`PatientID` WHERE  arb.`EntryDate`>=DATE(NOW()) and arb.RoomID='" + Roomid + "'");
        DataTable dtRoom = StockReports.GetDataTable(sb.ToString());
        if (dtRoom.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRoom);
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public string SendPanelApprovalEmail(PanelApprovalDetails panelApprovalDetails, bool isAdvanceRoomBooking)
    {

        GetEncounterNo Encounter = new GetEncounterNo();


        if (Encounter.CheckDualityOfPanelRequest(panelApprovalDetails.panelID, panelApprovalDetails.transactionID) == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Amount Request Is Already Added For The Panel." });

        }
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var costEstimationPath = string.Empty;
        try
        {


            if (Util.GetDecimal(panelApprovalDetails.approvalAmount) < 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Approval Amont." });






            var panelEmailID = Util.GetString(excuteCMD.ExecuteScalar("SELECT pm.Email FROM f_center_panel pm WHERE pm.isActive=1 and pm.PanelID=@panelID AND CentreID=@CentreID", new
            {
                panelID = panelApprovalDetails.panelID,
                CentreID = Session["CentreID"].ToString()
            }));


            var NICNumber = Util.GetString(excuteCMD.ExecuteScalar("SELECT s.IDProofNumber FROM PatientID_proofs s WHERE s.PatientID=@patientID AND s.IDProofID=1", new
            {
                patientID = panelApprovalDetails.patientID

            }));

            // if (string.IsNullOrEmpty(panelEmailID))
            //   return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Email Not found for this panel." });

            var notifyMessage = string.Empty;



            if (panelApprovalDetails.attachCostEstimation)
            {
                costEstimationPath = Util.GetString(excuteCMD.ExecuteScalar("SELECT  s.path FROM f_costestimationbilling s WHERE s.PatientID=@patientID LIMIT 1", new
               {
                   patientID = panelApprovalDetails.patientID

               }));

                if (string.IsNullOrEmpty(costEstimationPath))
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Cost Estimation Not Found." });

            }

            var attchments = PatientDocument.SavePanelDocument(panelApprovalDetails.panelDocuments, panelApprovalDetails.transactionID, panelApprovalDetails.patientID, Util.GetInt(panelApprovalDetails.panelID));

            var sqlCMD = new StringBuilder();

            if (isAdvanceRoomBooking)
            {

                sqlCMD.Append("  SELECT  pm.PatientID MRNo, pm.PatientID, '' TransactionID, CONCAT(pm.Title,' ',pm.PName)PatientName, pm.Age,  ");
                sqlCMD.Append("   IFNULL(dm.DoctorID,'')DoctorID,IFNULL( CONCAT(dm.Title, '', dm.Name),'') DoctorName, ");
                sqlCMD.Append("  pm.Title, '' AppDate, IFNULL(rm.Room_No,'') RoomNo, IFNULL(rm.Bed_No,'') BedNo, fpm.Company_Name  PanelName, '' EmployeeName,  ");
                sqlCMD.Append(" '' UserName, ictm.Name RoomType, '' IPNo, '' Discount, '' ApprovalAmount  ");
                sqlCMD.Append(" FROM  advance_room_booking pmh  ");
                sqlCMD.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
                sqlCMD.Append(" left JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID  ");
                sqlCMD.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID  ");
                sqlCMD.Append(" LEFT JOIN room_master rm ON rm.RoomId=pmh.RoomID  ");
                sqlCMD.Append(" INNER JOIN ipd_case_type_master ictm ON ictm.IPDCaseTypeID=pmh.IPDCaseTypeID ");
                sqlCMD.Append(" WHERE pm.PatientID=@patientID  ");

            }
            else
            {

                sqlCMD = new StringBuilder(" SELECT pm.PatientID, pm.PatientID MRNo, CAST(pmh.TransactionID AS CHAR(50))AS TransactionID, CONCAT(pm.Title,' ',pm.PName)PatientName, pm.Age, CAST(dm.DoctorID AS CHAR(50))AS DoctorID, CONCAT(dm.Title,'',dm.Name) DoctorName, ");
                sqlCMD.Append("  pm.Title, '' AppDate, ipd.Room_No RoomNo, CAST(ipd.Bed_No AS CHAR(50)) AS BedNo, fpm.Company_Name  PanelName, '' EmployeeName,  ");
                sqlCMD.Append(" '' UserName, ipd.RoomType RoomType, REPLACE(CAST(pmh.TransactionID AS CHAR(50)),'ISHHI','') IPNo, '' Discount, '' ApprovalAmount  ");
                sqlCMD.Append("  FROM  patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
                sqlCMD.Append("  INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID INNER JOIN patient_ipd_profile pid ON pid.TransactionID=pmh.TransactionID  ");
                sqlCMD.Append("  INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID  ");
                sqlCMD.Append(" INNER JOIN ( SELECT ictm.Name RoomType,CAST(pip.TransactionID AS CHAR(50))AS TransactionID ,rm.Bed_No,rm.Name,rm.Floor,rm.Room_No FROM patient_ipd_profile pip ");
                sqlCMD.Append(" INNER JOIN patient_medical_history adj ON pip.TransactionID=adj.TransactionID INNER JOIN ipd_case_type_master ictm  ");//f_ipdadjustment
                sqlCMD.Append(" ON ictm.IPDCaseTypeID=pip.IPDCaseTypeID INNER JOIN room_master rm ON rm.RoomId=pip.RoomID  ");
                sqlCMD.Append(" WHERE  PIP.TransactionID=@transactionID AND  adj.Type='IPD'  ");//
                sqlCMD.Append(" GROUP BY PIP.TransactionID ORDER BY pip.PatientIPDProfile_ID DESC ) ipd ON ipd.TransactionID=pmh.TransactionID ");
                sqlCMD.Append(" WHERE pmh.TransactionID=@transactionID LIMIT 1  ");

            }

            DataTable dtEmailDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                transactionID = panelApprovalDetails.transactionID,
                patientID = panelApprovalDetails.patientID
            });


            var d = Util.GetListFromDataTable<EmailTemplateInfo>(dtEmailDetails);//EmailTemplateInfo

            d[0].EmployeeName = HttpContext.Current.Session["UserName"].ToString();
            d[0].UserName = HttpContext.Current.Session["UserName"].ToString();
            d[0].EmailTo = panelEmailID;
            d[0].ApprovalAmount = panelApprovalDetails.approvalAmount;
            d[0].PolicyCardNumber = panelApprovalDetails.policyCardNumber;
            d[0].PolicyNumber = panelApprovalDetails.policyNumber;
            d[0].PolicyExpiryDate = Util.GetDateTime(panelApprovalDetails.policyExpiryDate).ToString("yyyy-MM-dd");
            d[0].NICNumber = NICNumber;
            d[0].Password = string.Empty;


            var attchmentPaths = string.Join(",", attchments.panelDocuments.Select(i => i.DocumentSaveURLPath).ToList());

            if (!string.IsNullOrEmpty(costEstimationPath))
                attchmentPaths += "," + costEstimationPath;


            int sendEmailID = 0;// Email_Master.SaveEmailTemplate(0, Util.GetInt(Session["RoleID"].ToString()), "1", d, attchmentPaths, tnx);

            // if (sendEmailID < 1)
            // return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Unable to Schedule Email." });

            if (panelApprovalDetails.IsThroughsmartCard == 1 && panelApprovalDetails.IsThroughManul == 0)
            {


                int IsSmartCard = Encounter.IsPanelWithSmartCard(Util.GetString(panelApprovalDetails.panelID));

                if (IsSmartCard == 1)
                {
                    CardTokenResponseModel tokenResponse = AuthenticationHelper.GetBearerToken();

                    using (var client = CardClientHelper.GetClient(tokenResponse.AccessToken))
                    {
                        string recivedata = "";

                        client.BaseAddress = new Uri(CardBasicData.BaseUrl);
                        try
                        {
                            string Status = "PENDING";
                            string urldata = "api/visit?patientNumber=" + panelApprovalDetails.patientID + "&sessionStatus=" + Status + "";
                            HttpResponseMessage Ress = client.GetAsync(urldata).GetAwaiter().GetResult();
                            //Checking the response is successful or not which is sent using HttpClient  
                            if (Ress.IsSuccessStatusCode)
                            {
                                string recived = Ress.Content.ReadAsStringAsync().Result;
                                var Visitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);
                                object SeralizeVisitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);

                                GetMenberDetails FetchVisitDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(SeralizeVisitdata), typeof(GetMenberDetails));
                                if (FetchVisitDat != null && FetchVisitDat.content.Count > 0)
                                {
                                    try
                                    {
                                        string urldat = "api/member?patientNumber=" + panelApprovalDetails.patientID + "&sessionId=" + FetchVisitDat.content[0].session_id + "";

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
                                    
                                    panelApprovalDetails.IsThroughsmartCard = 1;
                                    panelApprovalDetails.IsThroughManul = 0;
                                    panelApprovalDetails.SessionId = FetchDat.content[0].session_id;                                    

                                }
                                else
                                {
                                   
                                        tnx.Rollback();
                                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Smart card Is Not Activated", message = "Error In Samrt Card." });
                                    

                                }

                            }
                            else
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Smart card Is Not Activated", message = "Error In Samrt Card." });
                                    

                            }

                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

                                    }
                                }
                                else
                                {
                                    tnx.Rollback();
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Smart card Is Not Activated", message = "Error In Samrt Card." });

                                }
                            }
                            else
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Smart card Is Not Activated", message = "Error In Samrt Card." });

                            }

                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);

                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Smart card Is Not Activated", message = "Error In Samrt Card." });

                        }



                    }

                }
                else
                {

                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Smart card Is not accepted by this panel", message = "Error In Samrt Card." });
                                    
                }

            }
            else if (panelApprovalDetails.IsThroughsmartCard == 1 && panelApprovalDetails.IsThroughManul == 1)
            {
                panelApprovalDetails.IsThroughsmartCard = 0;
                panelApprovalDetails.IsThroughManul = 1;
                panelApprovalDetails.SessionId = 0;
                int IsManual = Encounter.IsPanelWithIsManual(panelApprovalDetails.panelID);
                if (IsManual != 1)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Not Accepting Manual Please Process Through Smart Card", message = "Error In Samrt Card." });
                }
            }





            sqlCMD = new StringBuilder("INSERT INTO panelapproval_emaildetails (Email,TransactionID,SendEmailID,ApprovalAmount,PolicyCardNumber,PolicyExpiryDate,PolicyNumber,NICNumber,EntryBy ,ApprovalRemark,PanelID,NameOnCard,CardHolderRelation,IgnorePolicy,IgnorePolicyReason,IsThroughsmartCard,SessionId,IsThroughManul,IpdNo,PoolNr,PoolDesc) ");
            sqlCMD.Append(" VALUES ( @Email,@TransactionID,@SendEmailID,@ApprovalAmount,@PolicyCardNumber,@PolicyExpiryDate,@PolicyNumber,@NICNumber,@EntryBy,@ApprovalRemark,@panelID,@NameOnCard,@CardHolderRelation,@IgnorePolicy,@IgnorePolicyReason,@IsThroughsmartCard,@SessionId,@IsThroughManul,@IpdNo,@PoolNr,@PoolDesc) ");


            var response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                Email = panelEmailID,
                TransactionID = panelApprovalDetails.transactionID,
                SendEmailID = sendEmailID,
                ApprovalAmount = panelApprovalDetails.approvalAmount,
                PolicyCardNumber = panelApprovalDetails.policyCardNumber,
                PolicyExpiryDate = Util.GetDateTime(panelApprovalDetails.policyExpiryDate).ToString("yyyy-MM-dd"),
                PolicyNumber = panelApprovalDetails.policyNumber,
                NICNumber = panelApprovalDetails.NICNumber,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                ApprovalRemark = panelApprovalDetails.approvalRemark,
                panelID = panelApprovalDetails.panelID,
                NameOnCard = panelApprovalDetails.nameOnCard,
                CardHolderRelation = panelApprovalDetails.cardHolderRelation,
                IgnorePolicy = panelApprovalDetails.ignorePolicy == true ? 1 : 0,
                IgnorePolicyReason = panelApprovalDetails.ignorePolicyReason,
                IsThroughsmartCard = panelApprovalDetails.IsThroughsmartCard,
                SessionId = panelApprovalDetails.SessionId,
                IsThroughManul = panelApprovalDetails.IsThroughManul,
                IpdNo = Encounter.GetIpdNoByTransactionId(panelApprovalDetails.transactionID),
                PoolNr = Util.GetInt(panelApprovalDetails.PoolNr),
                PoolDesc = panelApprovalDetails.PoolDesc
            });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });


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

    [WebMethod(EnableSession = true)]
    public string bindTeamMember(string TeamID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ud.DoctorListId ID,ud.EmpName Name FROM unit_doctorlist ");
         sb.Append(" ud WHERE ud.UnitDoctorID='"+TeamID+"' AND ud.TeirId=1 AND ud.IsActive=1");
      
        
        
        DataTable dt  = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }



}