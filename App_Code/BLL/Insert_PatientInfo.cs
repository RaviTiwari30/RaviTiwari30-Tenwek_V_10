using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Data;
using System.Linq;
using System.IO;
/// <summary>
/// Summary description for Insert_PatientInfo
/// </summary>
public class Insert_PatientInfo
{
    public Insert_PatientInfo()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static List<patientList> savePatientMaster(object PM, MySqlTransaction tnx, MySqlConnection con)
    {

        var patientMasterData = new List<patientList>();
        // var patientMasterData = new List<Patient_Master>();

        
        try
        {
            List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);

            if (dataPM[0].LastFamilyUHIDNumber == string.Empty || dataPM[0].LastFamilyUHIDNumber==null)
                dataPM[0].LastFamilyUHIDNumber = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT getFamilyUHIDNumber()"));

            string PatientID = ""; string Age = "";
            ExcuteCMD excuteCMD = new ExcuteCMD();
            Patient_Master objPM = new Patient_Master(tnx);

            if (string.IsNullOrEmpty(dataPM[0].PatientID))
            {
                objPM.HospCode = AllGlobalFunction.LHospCode;
                objPM.Title = dataPM[0].Title;
                objPM.PFirstName = dataPM[0].PFirstName;
                objPM.PLastName = dataPM[0].PLastName;
                objPM.PName = dataPM[0].PName;
                if (!(string.IsNullOrEmpty(dataPM[0].Age)))
                    objPM.Age = dataPM[0].Age;
                else
                    objPM.Age = Util.GetString(excuteCMD.ExecuteScalar("SELECT Get_Age(@dateOfBirth)", new { dateOfBirth = dataPM[0].DOB.ToString("yyyy-MM-dd") }));
                objPM.DOB = dataPM[0].DOB;
                objPM.Gender = dataPM[0].Gender.Trim();
                objPM.Mobile = dataPM[0].Mobile.Trim();
                objPM.Email = dataPM[0].Email.Trim();

                if (dataPM[0].Relation == "Select")
                    objPM.Relation = string.Empty;
                else
                    objPM.Relation = dataPM[0].Relation.Trim();

                objPM.RelationName = dataPM[0].RelationName.Trim();
                objPM.House_No = dataPM[0].House_No.Trim();
                objPM.Country = dataPM[0].Country.Trim();
                objPM.City = dataPM[0].City.Trim();
                objPM.FeesPaid = 0;
                objPM.HospPatientType = dataPM[0].HospPatientType;
                objPM.DateEnrolled = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));
                objPM.Taluka = dataPM[0].Taluka;
                objPM.LandMark = dataPM[0].LandMark;
                objPM.Place = dataPM[0].Place;
                objPM.District = dataPM[0].District;
                objPM.Locality = dataPM[0].Locality;
                objPM.PinCode = dataPM[0].PinCode;
                objPM.Occupation = dataPM[0].Occupation;
                objPM.MaritalStatus = dataPM[0].MaritalStatus;
                objPM.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPM.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPM.RegisterBy = HttpContext.Current.Session["ID"].ToString();
                objPM.IPAddress = All_LoadData.IpAddress();
                objPM.AdharCardNo = dataPM[0].AdharCardNo;
                objPM.CountryID = dataPM[0].CountryID;
                objPM.DistrictID = dataPM[0].DistrictID;
                objPM.CityID = dataPM[0].CityID;
                objPM.TalukaID = dataPM[0].TalukaID;
                objPM.OldPatientID = dataPM[0].OldPatientID;
                objPM.PatientType = dataPM[0].PatientType;
                objPM.State = dataPM[0].State;
                objPM.StateID = dataPM[0].StateID;
                objPM.EmergencyPhoneNo = dataPM[0].EmergencyPhoneNo;
                objPM.IsNewPatient = dataPM[0].IsNewPatient;
                objPM.IsRegistrationApply = Util.GetInt(Resources.Resource.RegistrationChargesApplicable);
                objPM.PatientType_ID = Util.GetInt(dataPM[0].PatientType_ID);
                objPM.PanelID = Util.GetInt(dataPM[0].PanelID);
                objPM.Religion = dataPM[0].Religion;
                objPM.PlaceOfBirth = dataPM[0].PlaceOfBirth;
                objPM.IdentificationMark = dataPM[0].IdentificationMark;
                objPM.IsInternational = dataPM[0].IsInternational;
                objPM.OverSeaNumber = dataPM[0].OverSeaNumber;
                objPM.EthenicGroup = dataPM[0].EthenicGroup;
                objPM.IsTranslatorRequired = dataPM[0].IsTranslatorRequired;
                objPM.FacialStatus = dataPM[0].FacialStatus;
                objPM.Race = dataPM[0].Race;
                objPM.Employement = dataPM[0].Employement;
                objPM.MonthlyIncome = dataPM[0].MonthlyIncome;
                objPM.ParmanentAddress = dataPM[0].ParmanentAddress;
                objPM.IdentificationMarkSecond = dataPM[0].IdentificationMarkSecond;
                objPM.LanguageSpoken = dataPM[0].LanguageSpoken;
                objPM.EmergencyRelationOf = dataPM[0].EmergencyRelationOf;
                objPM.EmergencyRelationName = dataPM[0].EmergencyRelationName;
                objPM.PhoneSTDCODE = dataPM[0].PhoneSTDCODE;
                objPM.ResidentialNumber = dataPM[0].ResidentialNumber;
                objPM.ResidentialNumberSTDCODE = dataPM[0].ResidentialNumberSTDCODE;
                objPM.EmergencyFirstName = dataPM[0].EmergencyFirstName;
                objPM.EmergencySecondName = dataPM[0].EmergencySecondName;
                objPM.InternationalCountryID = dataPM[0].InternationalCountryID;
                objPM.InternationalCountry = dataPM[0].InternationalCountry;
                objPM.InternationalNumber = dataPM[0].InternationalNumber;
                objPM.Phone = dataPM[0].Phone;
                objPM.EmergencyAddress = dataPM[0].EmergencyAddress;
                objPM.Remark = dataPM[0].Remark;
                objPM.StaffDependantID = dataPM[0].StaffDependantID;
                objPM.Active = 1;
                objPM.PMiddleName = dataPM[0].PMiddleName;
                objPM.EmergencyPhone = dataPM[0].EmergencyPhone;
                objPM.PurposeOfVisit = dataPM[0].PurposeOfVisit;
                objPM.PurposeOfVisitID = dataPM[0].PurposeOfVisitID;
                objPM.PRequestDept = dataPM[0].PRequestDept;
                objPM.SecondMobileNo=dataPM[0].SecondMobileNo;
				objPM.LastFamilyUHIDNumber = dataPM[0].LastFamilyUHIDNumber;
                
                PatientID = objPM.Insert();
                if (string.IsNullOrEmpty(PatientID))
                {
                    return patientMasterData;
                }
                if ((!string.IsNullOrEmpty(dataPM[0].OldPatientID)) && (!string.IsNullOrEmpty(PatientID)))
                {
                    excuteCMD.DML(tnx, "UPDATE patient_master_old SET NewPatientID=@newPatientID WHERE PatientID=@oldPatientID ", CommandType.Text, new
                    {
                        newPatientID = PatientID,
                        PatientID = dataPM[0].OldPatientID

                    });
                }
            }
            else
            {
                PatientID = dataPM[0].PatientID;

                //=============================================Update Religion, Email and Marital Status============================
                string PatientInfo = Update_PatientInfo.updatePatientMaster(dataPM, tnx, con);
                //excuteCMD.DML(tnx, "UPDATE patient_master SET Religion=@religion,MaritalStatus=@maritalStatus,Email=@email where PatientID=@patientID", CommandType.Text, new
                //{
                //    religion = dataPM[0].Religion,
                //    maritalStatus = dataPM[0].MaritalStatus,
                //    email = dataPM[0].Email,
                //    patientID = PatientID
                //});

                //===============================================END================================================================

            }
            if (string.IsNullOrEmpty(Util.GetString(dataPM[0].Age)))
                Age = Util.GetString(excuteCMD.ExecuteScalar("SELECT Get_Age(@dateOfBirth)", new { dateOfBirth = dataPM[0].DOB.ToString("yyyy-MM-dd") }));
            else
                Age = dataPM[0].Age;


            patientMasterData.Add(new patientList() { PatientID = PatientID, HospPatientType = dataPM[0].HospPatientType, IsNewPatient = dataPM[0].IsNewPatient, Age = Age, PatientType_ID = dataPM[0].PatientType_ID, MobileNo = dataPM[0].Mobile.Trim(), PanelID = dataPM[0].PanelID, patientMaster = dataPM[0] });



            //======================================Save Patient ID Proofs======================================================

            excuteCMD.DML(tnx, "DELETE FROM PatientID_proofs WHERE PatientID=@patientID", CommandType.Text, new
            {
                patientID = PatientID
            });

            string sqlCMD = "INSERT INTO PatientID_proofs (PatientID,IDProofID,IDProofName,IDProofNumber,EntryBy,EntryDate) VALUES (@patientID,@proofID,@proofName,@proofNumber,@entryBy,Now()) ";
            foreach (IDProof idProof in dataPM[0].PatientIDProofs)
            {
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    patientID = PatientID,
                    proofID = idProof.IDProofID.Trim(),
                    proofName = idProof.IDProofName.Trim(),
                    proofNumber = idProof.IDProofNumber.Trim(),
                    entryBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            //==============================================================================================



            //======================================Save Patient Profile Pic=================================
            try
            {
                var catureStatus = Util.GetInt(dataPM[0].isCapTure);
                if (catureStatus == 1)
                {
                    if (All_LoadData.chkDocumentDrive() == 0)
                        throw new Exception("Please Create " + Resources.Resource.DocumentDriveName + " Drive");
                    DateTime patientEnrolledDate = System.DateTime.Now;
                    if (dataPM[0].PatientID == "")
                        patientEnrolledDate = objPM.DateEnrolled;
                    else
                        patientEnrolledDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT pm.DateEnrolled FROM  patient_master pm  WHERE pm.PatientID='" + PatientID + "'"));
                    var directoryPath = All_LoadData.createDocumentFolder("PatientPhoto", patientEnrolledDate.Year.ToString(), patientEnrolledDate.Month.ToString());
                    string filePath = Path.Combine(directoryPath.ToString(), PatientID.ToString().Replace("/", "_") + ".jpg");
                    if (File.Exists(filePath))
                        File.Delete(filePath);

                    string strImage = dataPM[0].base64PatientProfilePic.Replace(dataPM[0].base64PatientProfilePic.Split(',')[0] + ",", "");
                    System.IO.File.WriteAllBytes(filePath, Convert.FromBase64String(strImage));
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            //====================================================================================================           

            return patientMasterData;
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return patientMasterData;
        }

    }
    public class patientList
    {
        public string PatientID { get; set; }
        public string HospPatientType { get; set; }
        public int IsNewPatient { get; set; }
        public string Age { get; set; }
        public int PatientType_ID { get; set; }
        public string MobileNo { get; set; }
        public string TransactionID { get; set; }
        //public string HashCode { get; set; }
        public int PanelID { get; set; }
        public Patient_Master patientMaster { get; set; }
    }


    public static string savePMH(List<Patient_Medical_History> dataPMH, string PatientID, int IsNewPatient, string HospPatientType, string Type, string Source, MySqlTransaction tnx, MySqlConnection con)
    {


        try
        {
            int Co_PaymentOn = Util.GetInt(StockReports.ExecuteScalar("select ifnull(Co_PaymentOn,0) from f_panel_master where PanelID=" + dataPMH[0].PanelID + ""));

            Patient_Medical_History objPMH = new Patient_Medical_History(tnx);
            objPMH.PatientID = PatientID;
            objPMH.DoctorID = dataPMH[0].DoctorID.ToString();
            objPMH.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objPMH.Time = Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss"));
            objPMH.DateOfVisit = Util.GetDateTime(DateTime.Now);
            objPMH.Type = Type;
            objPMH.Purpose = dataPMH[0].Purpose.ToString();
            objPMH.PanelID = dataPMH[0].PanelID;
            objPMH.ParentID = dataPMH[0].ParentID;
            objPMH.ReferedBy = dataPMH[0].ReferedBy;
            objPMH.patient_type = HospPatientType;
            objPMH.HashCode = dataPMH[0].HashCode;
            objPMH.ScheduleChargeID = dataPMH[0].ScheduleChargeID;
            objPMH.Source = Source;
            objPMH.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objPMH.UserID = HttpContext.Current.Session["ID"].ToString();
            objPMH.IsNewPatient = Util.GetInt(IsNewPatient);
            objPMH.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPMH.patientTypeID = dataPMH[0].patientTypeID;
            objPMH.PanelPaybleAmt = dataPMH[0].PanelPaybleAmt;
            objPMH.PatientPaybleAmt = dataPMH[0].PatientPaybleAmt;
            objPMH.PanelPaidAmt = dataPMH[0].PanelPaidAmt;
            objPMH.PatientPaidAmt = dataPMH[0].PatientPaidAmt;
            objPMH.Co_PaymentOn = Co_PaymentOn;
            if (dataPMH[0].KinRelation == "Select")
                objPMH.KinRelation = "";
            else
                objPMH.KinRelation = dataPMH[0].KinRelation;
            objPMH.KinName = dataPMH[0].KinName;
            objPMH.KinPhone = dataPMH[0].KinPhone;
            objPMH.CardNo = dataPMH[0].CardNo;
            objPMH.PolicyNo = dataPMH[0].PolicyNo;
            objPMH.ExpiryDate = dataPMH[0].ExpiryDate;
            objPMH.CardHolderName = dataPMH[0].CardHolderName;
            objPMH.RelationWith_holder = dataPMH[0].RelationWith_holder;
            objPMH.PanelIgnoreReason = dataPMH[0].PanelIgnoreReason;
            objPMH.ProId = dataPMH[0].ProId;
            objPMH.BookingCenterID = Util.GetInt(HttpContext.Current.Session["BookingCentreID"].ToString());
            objPMH.IsVisitClose = 1;
            objPMH.TypeOfReference = dataPMH[0].TypeOfReference;
            objPMH.TriagingCode = dataPMH[0].TriagingCode;
            objPMH.CorporatePanelID = dataPMH[0].CorporatePanelID;//
            objPMH.ReferralTypeID = Util.GetInt(dataPMH[0].ReferralTypeID);//
           
            if (Type == "OPD")
            {
                objPMH.PatientSourceID = 6;
            }
            else if (Type == "IPD")
            {
                objPMH.PatientSourceID = 5;
            }
            else if (Type == "EMG")
            {
                objPMH.PatientSourceID = 7;
            }
            objPMH.BillNo = Util.GetString(dataPMH[0].BillNo);
            objPMH.BillDate = Util.GetDateTime(dataPMH[0].BillDate);
            objPMH.BillGeneratedBy = Util.GetString(dataPMH[0].BillGeneratedBy);
            objPMH.TotalBilledAmt = dataPMH[0].TotalBilledAmt;
            objPMH.ItemDiscount = dataPMH[0].ItemDiscount;
            objPMH.NetBillAmount = dataPMH[0].NetBillAmount;
            string TransactionId = objPMH.Insert();

            return TransactionId;

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }

    }

    public static string saveAppointment(object PM, string DoctorID, decimal Amount, int PanelID, string ItemID, string SubCategoryID, string HashCode, string TransactionId, string LedgerTransactionNo, string PatientID, MySqlTransaction tnx, MySqlConnection con)
    {
        try
        {
            List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);
            int AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + DoctorID + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));
            List<docVisitDetail> visitDetail1 = AllLoadData_OPD.appVisitDetail(DateTime.Now, Util.GetString(SubCategoryID), con);

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
                ObjApp.Age = StockReports.ExecuteScalar("Select Get_Age('" + dataPM[0].DOB.ToString("yyyy-MM-dd") + "')");
            }
            ObjApp.Email = dataPM[0].Email;
            if (dataPM[0].PatientID != "")
                ObjApp.VisitType = "Old Patient";
            else
                ObjApp.VisitType = "New Patient";

            ObjApp.TypeOfApp = Util.GetString("2");
            ObjApp.PatientType = dataPM[0].HospPatientType.ToString();
            ObjApp.Nationality = dataPM[0].Country;
            ObjApp.City = dataPM[0].City;
            ObjApp.Sex = dataPM[0].Gender;
            ObjApp.RefDocID = "";

            ObjApp.PurposeOfVisit = "";
            ObjApp.PurposeOfVisitID = 0;
            ObjApp.Date = Util.GetDateTime(DateTime.Now);
            ObjApp.DoctorID = DoctorID.ToString();
            ObjApp.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjApp.EntryUserID = HttpContext.Current.Session["ID"].ToString();

            ObjApp.Amount = Amount;
            ObjApp.PanelID = Util.GetInt(PanelID);
            ObjApp.ItemID = ItemID;
            ObjApp.SubCategoryID = SubCategoryID;
            if (dataPM[0].PatientID != "")
                ObjApp.PatientID = dataPM[0].PatientID;
            ObjApp.IpAddress = HttpContext.Current.Request.UserHostAddress;
            ObjApp.AppNo = Util.GetInt(AppNo);
            ObjApp.hashCode = HashCode;
            ObjApp.IsConform = 1;
            ObjApp.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjApp.Taluka = dataPM[0].Taluka;
            ObjApp.LandMark = dataPM[0].LandMark;
            ObjApp.Place = dataPM[0].Place;

            ObjApp.PinCode = dataPM[0].PinCode;
            ObjApp.Occupation = dataPM[0].Occupation;
            ObjApp.MaritalStatus = dataPM[0].MaritalStatus;
            ObjApp.Relation = dataPM[0].Relation;
            ObjApp.RelationName = dataPM[0].RelationName;
            ObjApp.TransactionID = TransactionId;
            ObjApp.LedgerTransactionNo = LedgerTransactionNo;
            ObjApp.ConformDate = Util.GetDateTime(DateTime.Now);
            ObjApp.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjApp.AdharCardNo = dataPM[0].AdharCardNo;
            ObjApp.District = dataPM[0].District;
            ObjApp.DistrictID = dataPM[0].DistrictID;
            ObjApp.CountryID = dataPM[0].CountryID;
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
            string notification = Notification_Insert.notificationInsert(1, AppID, tnx, Util.GetString(DoctorID), "", 52, DateTime.Now.ToString("yyyy-MM-dd"), "");
            if (AppID == "")
            {
                tnx.Rollback();
                return "";
            }
            return AppID;
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}