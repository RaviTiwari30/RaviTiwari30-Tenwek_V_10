<%@ WebService Language="C#" Class="EmergencyAdmission" %>
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
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//[ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class EmergencyAdmission : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string GenerateName1(object obj)
    {
        string name=StockReports.ExecuteScalar("SELECT max(ID)+1 as Name from patient_master "); 
        return name;
    }

    [WebMethod(EnableSession = true)]
    public string SaveEmergencyAdmission(object PM, object PMH, object patientDocuments, string roomType, string roomNo, string triagingCode, string admissionDate, string admissionTime, object MultiPanel, string TransferRequestID)
    {
        List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<PatientMultiPanel> dataPMultiPanel = new JavaScriptSerializer().ConvertToType<List<PatientMultiPanel>>(MultiPanel);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string LedgerTransactionNo = string.Empty;
        try
        {
            string PatientID = string.Empty; string TID = string.Empty; string ScheduleChargeID = string.Empty; string emergencyNo = string.Empty;

            var IsdefaultPanelID = dataPMultiPanel.Where(i => i.IsDefaultPanel == 1).ToList();
            if (IsdefaultPanelID.Count > 0)
            {
                dataPM[0].PanelID = Util.GetInt(IsdefaultPanelID[0].PPanelID);
            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Kindly Select The One  Panel As Default", message = "Kindly Select The One  Panel As Default" });
            }

            var PatientInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
            }
            else
                PatientID = PatientInfo[0].PatientID;
            //int checkalreadyadmitted = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM ipd_case_history ich INNER JOIN f_ipdadjustment adj ON adj.TransactionID=ich.TransactionID " +
                                       //" WHERE  ich.Status='IN' AND adj.PatientID='" + PatientID + "' "));

            int checkalreadyadmitted = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM `patient_medical_history` WHERE STATUS='IN' AND TYPE IN ('IPD','EMG') AND PatientID='" + PatientID + "'"));//
            
            if (checkalreadyadmitted > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Already Admitted.", message = "Please Already Admitted." });
            }
            PatientDocument.SaveDocument(patientDocuments, PatientID);
            //*********************Insert Patient Medical History******************************//
            if (!string.IsNullOrEmpty(PatientID))
            {

                Patient_Medical_History objPatient_Medical_History = new Patient_Medical_History(tnx);
                objPatient_Medical_History.PatientID = PatientID;
                objPatient_Medical_History.DoctorID = dataPMH[0].DoctorID;
                objPatient_Medical_History.DoctorID1 = "";//    dataPMH[0].DoctorID1;
                objPatient_Medical_History.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPatient_Medical_History.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                objPatient_Medical_History.IsMultipleDoctor = Util.GetInt(0);
                objPatient_Medical_History.DateOfVisit = Convert.ToDateTime(DateTime.Now);
                objPatient_Medical_History.FeesPaid = dataPMH[0].FeesPaid;
                objPatient_Medical_History.Type = "EMG";
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
                objPatient_Medical_History.MotherTID = string.Empty;
                objPatient_Medical_History.TypeOfDelivery = string.Empty;
                objPatient_Medical_History.DeliveryWeeks = string.Empty;
                objPatient_Medical_History.Weight = string.Empty;
                objPatient_Medical_History.Height = string.Empty;
                objPatient_Medical_History.isAdvance = 0;
                objPatient_Medical_History.BirthIgnoreReason = string.Empty;
                objPatient_Medical_History.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPatient_Medical_History.IsNewPatient = Util.GetInt(PatientInfo[0].IsNewPatient);
                objPatient_Medical_History.ProId = dataPMH[0].ProId;
                objPatient_Medical_History.TriagingCode = Util.GetInt(triagingCode);
                objPatient_Medical_History.IsVisitClose = 1;
                objPatient_Medical_History.ReferralTypeID = dataPMH[0].ReferralTypeID;
                objPatient_Medical_History.STATUS = "IN";
                objPatient_Medical_History.DateOfAdmit = Util.GetDateTime(Util.GetDateTime(admissionDate).ToString("yyyy-MM-dd"));
                objPatient_Medical_History.TimeOfAdmit = Util.GetDateTime(Util.GetDateTime(admissionTime).ToString("HH:mm:ss")); 

                TID = objPatient_Medical_History.Insert();
                if (string.IsNullOrEmpty(TID))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Medical History" });
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

                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);
                ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
                ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(ObjLdgTnx.Hospital_ID, "HOSP", con);
                ObjLdgTnx.TypeOfTnx = "Emergency";
                ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjLdgTnx.BillNo = string.Empty;
                // ObjLdgTnx.NetAmount = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                // ObjLdgTnx.GrossAmount = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                ObjLdgTnx.PatientID = PatientID;
                ObjLdgTnx.PanelID = dataPMH[0].PanelID;
                ObjLdgTnx.TransactionID = TID;
                ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnx.IpAddress = HttpContext.Current.Request.UserHostAddress;
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnx.PatientType = PatientInfo[0].HospPatientType;
                ObjLdgTnx.CurrentAge = Util.GetString(PatientInfo[0].Age);
                ObjLdgTnx.PatientType_ID = Util.GetInt(PatientInfo[0].PatientType_ID);
                LedgerTransactionNo = ObjLdgTnx.Insert();
                if (string.IsNullOrEmpty(LedgerTransactionNo))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Ledgertransaction" });
                }


                RoomBilling objRoom = new RoomBilling();
                //string RoomDetail = "";// objRoom.GetRoomItemDetails(Util.GetInt(dataPMH[0].PanelID), roomType, Util.GetInt(ScheduleChargeID));

                int ReferenceCode= Util.GetInt( MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"SELECT ReferenceCode FROM f_panel_master pm WHERE pm.PanelID='" + dataPMH[0].PanelID + "'"));
                string RoomDetail = objRoom.GetRoomItemDetails(Util.GetInt(ReferenceCode), roomType, Util.GetInt(ScheduleChargeID));

                if (!string.IsNullOrEmpty(RoomDetail))
                {
                    LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                    ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                    ObjLdgTnxDtl.ItemID = Util.GetString(RoomDetail.Split('#')[0].ToString());
                    ObjLdgTnxDtl.Rate = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                    ObjLdgTnxDtl.Quantity = 1;
                    ObjLdgTnxDtl.StockID = string.Empty;
                    ObjLdgTnxDtl.IsTaxable = "NO";
                    ObjLdgTnxDtl.Amount = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                    ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0.00);
                    ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                    ObjLdgTnxDtl.IsPackage = 0;
                    ObjLdgTnxDtl.PackageID = string.Empty;
                    ObjLdgTnxDtl.IsVerified = 1;
                    ObjLdgTnxDtl.TransactionID = TID;
                    ObjLdgTnxDtl.SubCategoryID = Util.GetString(RoomDetail.Split('#')[3]);
                    ObjLdgTnxDtl.ItemName = Util.GetString(RoomDetail.Split('#')[1].ToString());
                    ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                    ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ObjLdgTnxDtl.SubCategoryID), con));
                    ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                    ObjLdgTnxDtl.IPDCaseTypeID = roomType;
                    ObjLdgTnxDtl.RateListID = Util.GetInt(RoomDetail.Split('#')[5]);
                    ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjLdgTnxDtl.Type = "E";
                    ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    ObjLdgTnxDtl.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    ObjLdgTnxDtl.DoctorID = dataPMH[0].DoctorID;
                    ObjLdgTnxDtl.RoomID = roomNo;
                    ObjLdgTnxDtl.typeOfTnx = "EMERGENCY";
                    ObjLdgTnxDtl.TnxTypeID = 27;
                    ObjLdgTnxDtl.DoctorID = dataPMH[0].DoctorID;
                    
                    string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                    if (string.IsNullOrEmpty(LdgTnxDtlID))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Ledgertransaction Details" });
                    }

                  //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE room_master rm SET rm.`IsRoomClean`=2 WHERE rm.`RoomId`='" + roomNo + "'");

                }
            }


            emergencyNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Get_ID_YearWise('Emergency No.'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ")"));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_medical_history SET TransNo='" + emergencyNo + "' WHERE TransactionID=" + TID + "");//
            if (String.IsNullOrEmpty(emergencyNo))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Emergency No" });
            }

           
            

            string objSQL = "insert_emergency_patient_details";
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, tnx);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vEmergencyNo", emergencyNo));
            cmd.Parameters.Add(new MySqlParameter("@vPatientId", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionId", TID));
            cmd.Parameters.Add(new MySqlParameter("@vEnteredBy", Session["ID"].ToString()));
            cmd.Parameters.Add(new MySqlParameter("@vIPAddress", All_LoadData.IpAddress()));
            cmd.Parameters.Add(new MySqlParameter("@vRoomId", roomNo));
            cmd.Parameters.Add(new MySqlParameter("@vIPDCaseTypeID", roomType));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@vPatientReceiveddate", Util.GetDateTime(Util.GetDateTime(admissionDate).ToString("yyyy-MM-dd"))));
            cmd.Parameters.Add(new MySqlParameter("@vPatientReceivedTime", Util.GetDateTime(Util.GetDateTime(admissionTime).ToString("HH:mm:ss"))));
            
            
            cmd.ExecuteScalar();



            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(tnx, "INSERT INTO emr_ipd_details(TransactionID) VALUES(@transactionID)", CommandType.Text, new
            {
                transactionID = TID
            });

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

            int TransferPatientID=0;
            TransferPatientID = Util.GetInt(StockReports.ExecuteScalar("select ID from  cpoe_transfertoemergency where PatientID='" + PatientID + "' and IsPatientAdmitted=0"));
            if (TransferPatientID != 0 )
            {
                string sqlCMD = "update cpoe_transfertoemergency set IsPatientAdmitted=1 where id=@id ";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    id = TransferPatientID
                }); 
            }

            //OutsideTransferPatientIDUpdate
            int TransferID = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(id) FROM PatientTransferReqest ptr WHERE ptr.ID='" + TransferRequestID + "' AND ptr.IsRegister=0 AND ptr.IsActive=1"));
            if (TransferID != 0)
            {
                string sqlCmd = "UPDATE PatientTransferReqest ptr  SET ptr.IsRegister=@IsRegister,ptr.RegisterBy=@RegisterBy,ptr.RegisterDate=NOW(),ptr.PatientID=@PatientID,ptr.AdmissionBy=@AdmissionBy,ptr.AdmissionDate=NOW() ";
                sqlCmd += "     WHERE ptr.ID=@ID AND ptr.IsRegister=0 AND ptr.IsActive=1; ";

                excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                {
                    IsRegister = 1,
                    RegisterBy = HttpContext.Current.Session["ID"].ToString(),
                    ID = Util.GetInt(TransferRequestID),
                    PatientID = PatientID,
                    AdmissionStatus = 1,
                    AdmissionBy = HttpContext.Current.Session["ID"].ToString()

                });

            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE room_master rm SET rm.`IsRoomClean`=2 WHERE rm.`RoomId`='" + roomNo + "'");


            string UpdateQuery = "Call updateEmergencyBillAmounts(" + LedgerTransactionNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
            
            
            
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, TID = TID, PID = PatientID, response = "<b style='color:black;font-size: 16px;'> Emergency Number &nbsp;:&nbsp;" + emergencyNo + "</b></br><b style='color:black;font-size: 16px;'> UHID &nbsp;:&nbsp;" + PatientID + "</b>", message = "" });
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
    public string GetTriagingCodes()
    {
        var dt = StockReports.GetDataTable("SELECT cc.ID,cc.CodeType,cc.ColorCode,cc.MaxWaitingMinutes FROM emr_TriagingCodes cc WHERE cc.IsActive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession=true)]
    public string SaveTriaging(string Triaging, string TID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(tnx, "UPDATE patient_medical_history pmh SET pmh.TriagingCode=@TriagingCode,pmh.LastUpdatedBy=@LastUpdatedBy,pmh.Updatedate=NOW() WHERE pmh.TransactionID=@TransactionID ", CommandType.Text, new
            {
                TriagingCode = Triaging,
                TransactionID = TID,
                LastUpdatedBy = Session["ID"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Update Successfully.", message = "" });
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
    public string SavePrimaryDoctor(string DoctorID, string TID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(tnx, "UPDATE patient_medical_history pmh SET pmh.DoctorID=@DoctorID,pmh.LastUpdatedBy=@LastUpdatedBy,pmh.Updatedate=NOW() WHERE pmh.TransactionID=@TransactionID ", CommandType.Text, new
            {
                DoctorID = DoctorID,
                TransactionID = TID,
                LastUpdatedBy = Session["ID"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Update Successfully.", message = "" });
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
    public string bindMedicResidanceCentrewise(string CentreID)
    {
        StringBuilder sbQuery = new StringBuilder();        
        /*sbQuery.Append(" SELECT t.* FROM ( ");
        //for employee
        

        sbQuery.Append(" UNION ALL ");
        
        
        
        // For Medic        
        sbQuery.Append(" SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))Name FROM doctor_master dm ");
        sbQuery.Append(" INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID ");
        sbQuery.Append(" WHERE dm.IsActive = 1 AND fcp.CentreID='" + CentreID + "' AND fcp.isActive=1 AND Cadreid=1 AND IsUnit=0 ");
        
        sbQuery.Append(" UNION ALL ");
        
        // For Resident
        sbQuery.Append(" SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))Name FROM doctor_master dm ");
        sbQuery.Append(" INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID ");
        sbQuery.Append(" WHERE dm.IsActive = 1 AND fcp.CentreID='" + CentreID + "' AND fcp.isActive=1 AND TierID=3 AND IsUnit=0 ");
        sbQuery.Append(" ) t ");
        
        sbQuery.Append(" GROUP BY t.DoctorID ORDER BY t.name ");   */
        sbQuery.Append(" SELECT  Employeeid as DoctorID,NAME as Name FROM employee_master WHERE cadreid='1' OR tierID='3' ");     
        var dt = StockReports.GetDataTable(sbQuery.ToString());
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveMedicResidenceDoctor(string DoctorID, string TID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(tnx, "UPDATE emergency_patient_details epd SET epd.MedicResidenceDocID=@DoctorID,epd.UpdatedBy=@LastUpdatedBy,epd.UpdatedOn=NOW() WHERE epd.TransactionID=@TransactionID ", CommandType.Text, new
            {
                DoctorID = DoctorID,
                TransactionID = TID,
                LastUpdatedBy = Session["ID"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Update Successfully.", message = "" });
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
    public string IsReceivedPatient(string TID, int IsReceived)
    {
        try
        {
            if (IsReceived == 1)
            {
                StockReports.ExecuteDML(" UPDATE Emergency_Patient_Details SET IsPatientReceived=1,NursingPatientReceiveddate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',NursingPatientReceivedby='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID='" + TID + "' ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Received Successfully" });
            }
            else if (IsReceived == 0)
            {
                StockReports.ExecuteDML(" UPDATE Emergency_Patient_Details SET IsPatientReceived=0,NursingPatientReceiveddate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',NursingPatientReceivedby='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID='" + TID + "' ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient NonReceived Successfully" });
            }
            else
            {
                return "";
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }

    }

}