<%@ WebService Language="C#" Class="PatientVisitRegistration" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Data;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[System.Web.Script.Services.ScriptService]
public class PatientVisitRegistration : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string CreateVisit(object patientMaster, object patientMedicalhistory)
    {
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(patientMedicalhistory);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            var patientID = string.Empty;
            var patientMasterInfo = Insert_PatientInfo.savePatientMaster(patientMaster, tnx, con);
            if (patientMasterInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
            }
            else
                patientID = patientMasterInfo[0].PatientID;



            var transactionID = Insert_PatientInfo.savePMH(dataPMH, patientID, Util.GetInt(patientMasterInfo[0].IsNewPatient), patientMasterInfo[0].HospPatientType, "OPD", "OPD-Lab", tnx, con);
            if (string.IsNullOrEmpty(transactionID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Patient Master" });
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, transactionID = transactionID });
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
    public bool ValidateOpenVisit(string patientID)
    {


        ExcuteCMD excuteCMD = new ExcuteCMD();
        var res = excuteCMD.ExecuteScalar("SELECT COUNT(*) FROM  patient_medical_history pmh WHERE pmh.IsVisitClose=0 AND pmh.PatientID=@patientID AND pmh.Type='OPD'", new
        {
            patientID = patientID

        });

        if (Util.GetInt(res) > 0)
            return true;
        else
            return false;

    }



    [WebMethod]
    public string ClosePatientOpenVisit(string patientID)
    {

        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var res = excuteCMD.DML("UPDATE patient_medical_history pmh  SET pmh.IsVisitClose=1  WHERE pmh.IsVisitClose=0 AND pmh.PatientID=@patientID AND pmh.Type='OPD'", CommandType.Text, new
            {
                patientID = patientID

            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }

    }


    [WebMethod(EnableSession = true)]
    public string CreateAppointment(object Appointment, object PM, object PMH, object patientDocuments, string lastVisitID, List<PanelDocument> panelDocuments)
    {
        List<appointment> dataApp = new JavaScriptSerializer().ConvertToType<List<appointment>>(Appointment);
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Patient_Master> dataPM = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string PatientID = string.Empty;
        string TransactionId = string.Empty;
        try
        {
            var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientMasterInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient Registration.", message = "Duplicate Patient Registration." });
            }
            else
                PatientID = PatientMasterInfo[0].PatientID;



            if (string.IsNullOrEmpty(lastVisitID))
            {
                dataPMH[0].IsVisitClose = 0;
                TransactionId = Insert_PatientInfo.savePMH(dataPMH, PatientID, Util.GetInt(PatientMasterInfo[0].IsNewPatient), PatientMasterInfo[0].HospPatientType, "OPD", "OPD-APPOINTMENT", tnx, con);
            }
            else
                TransactionId = lastVisitID;


            PatientDocument.SaveDocument(patientDocuments, PatientID);

            PatientDocument.SavePanelDocument(panelDocuments, TransactionId, PatientID, dataPMH[0].PanelID);
            
            

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
            ObjApp.Doctor_Name = dataApp[0].Doctor_Name;
            if (dataApp[0].SelectTime.Contains("#"))
            {
                ObjApp.Time = Util.GetDateTime(Util.GetDateTime(dataApp[0].SelectTime.Split('#')[0]).ToString("HH:mm:ss"));
                ObjApp.EndTime = Util.GetDateTime(Util.GetDateTime(dataApp[0].SelectTime.Split('#')[1]).ToString("HH:mm:ss"));
            }
            else
            {
                ObjApp.Time = Util.GetDateTime(Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss"));
                ObjApp.EndTime = Util.GetDateTime(Util.GetDateTime(dataApp[0].SelectTime).ToString("HH:mm:ss"));
            }
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
            ObjApp.TransactionID = TransactionId;
            ObjApp.LedgerTransactionNo = string.Empty; //FOR UPDATE WHILE BILLING
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
            
            ObjApp.PhoneSTDCODE = dataPM[0].PhoneSTDCODE;
            ObjApp.ResidentialNumber = dataPM[0].ResidentialNumber;
            ObjApp.ResidentialNumberSTDCODE = dataPM[0].ResidentialNumberSTDCODE;
            ObjApp.EmergencyFirstName = dataPM[0].EmergencyFirstName;
            ObjApp.EmergencySecondName = dataPM[0].EmergencySecondName;
            ObjApp.InternationalCountryID = dataPM[0].InternationalCountryID;
            ObjApp.InternationalCountry = dataPM[0].InternationalCountry;
            ObjApp.InternationalNumber = dataPM[0].ResidentialNumber;
            ObjApp.Phone = dataPM[0].Phone;
            ObjApp.EmergencyAddress = dataPM[0].EmergencyAddress;
            
            ObjApp.LedgerTransactionNo = "0";
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

            tnx.Commit();

            //for Skip Tempreature Room
            if (subID == Resources.Resource.EmergencyVisitSubCategoryId || subID == Resources.Resource.FollowUpVisitSubCategoryID)
            {
                excuteCMD.DML("UPDATE appointment SET TemperatureRoom=@status,tempRoomupdateBy=@tempRoomUpdateBy,tempRoomUpdateDate=now() WHERE app_Id=@appointmentID", CommandType.Text, new
                {
                    status = 1,
                    tempRoomUpdateBy = HttpContext.Current.Session["ID"].ToString(),
                    appointmentID = AppID
                });
            }



            //**************** SMS************************//
            if (Resources.Resource.SMSApplicable == "1" && !string.IsNullOrEmpty(PatientMasterInfo[0].MobileNo))
            {
                var templateID = 1;
                var columninfo = smstemplate.getColumnInfo(templateID, con);
                if (columninfo.Count > 0)
                {
                    columninfo[0].PatientID = PatientID;
                    columninfo[0].PName = dataPM[0].PName;
                    columninfo[0].Title = dataPM[0].Title;
                    columninfo[0].Gender = dataPM[0].Gender;
                    columninfo[0].ContactNo = dataPM[0].PhoneSTDCODE + dataPM[0].Mobile;
                    columninfo[0].DoctorName = dataApp[0].Doctor_Name;
                    columninfo[0].AppointmentDate = (ObjApp.Date).ToString("yyyy-MM-dd");
                    columninfo[0].AppointmentTime = Util.GetDateTime(ObjApp.Time).ToString("HH:mm:ss");
                    columninfo[0].TemplateID = templateID;
                    //string sms = smstemplate.getSMSTemplate(1, columninfo, templateID, con, dataPMH[0].UserID);
                }
            }



            //**************** Email************************//
            if (Resources.Resource.EmailApplicable == "1" && !string.IsNullOrEmpty(PatientMasterInfo[0].patientMaster.Email))
            {

                var d = new EmailTemplateInfo()
                {
                    PatientID = PatientID,
                    PName = dataPM[0].PName,
                    Title = dataPM[0].Title,
                    Gender = dataPM[0].Gender,
                    ContactNo = dataPM[0].Mobile,
                    DoctorName = ObjApp.Doctor_Name,
                    AppointmentDate = (ObjApp.Date).ToString("yyyy-MM-dd"),
                    AppointmentTime = Util.GetDateTime(ObjApp.Time).ToString("HH:mm:ss"),
                    EmailTo = PatientMasterInfo[0].patientMaster.Email,
                    TransactionID = TransactionId
                };
                List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                dd.Add(d);
                //int sendEmailID = Email_Master.SaveEmailTemplate(2, Util.GetInt(Session["RoleID"].ToString()), "1", dd, string.Empty, null,con);
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });


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
}