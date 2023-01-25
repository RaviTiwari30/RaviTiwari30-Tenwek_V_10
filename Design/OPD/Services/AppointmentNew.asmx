<%@ WebService Language="C#" Class="AppointmentNew" %>

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


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AppointmentNew : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true, Description = "Save Appointment")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveApp(List<appointment> Data, string mobileAppAppointmentID, string centreID)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD = new ExcuteCMD();
            try
            {

                int AppNo = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "Select get_AppNo(@doctorID,@appointmentDate,@centreID)", CommandType.Text, new
                {
                    doctorID = Data[0].DoctorID,
                    appointmentDate = Util.GetDateTime(Data[0].Date).ToString("yyyy-MM-dd"),
                    centreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString())
                }));


                List<docVisitDetail> visitDetail1 = AllLoadData_OPD.appVisitDetail(Util.GetDateTime(Data[0].Date), Util.GetString(Data[0].SubCategoryID), con);

                appointment ObjApp = new appointment(tnx);
                ObjApp.Title = Util.GetString(Data[0].Title);
                ObjApp.PfirstName = Util.GetString(Data[0].PfirstName);
                ObjApp.plastName = Util.GetString(Data[0].plastName);
                ObjApp.Pname = Util.GetString(Data[0].Pname);
                ObjApp.ContactNo = Util.GetString(Data[0].ContactNo);

                if (!string.IsNullOrEmpty(Data[0].Age))
                    ObjApp.Age = Util.GetString(Data[0].Age);
                else
                {
                    ObjApp.DOB = Util.GetDateTime(Data[0].DOB.ToString("yyyy-MM-dd"));
                    ObjApp.Age = Util.GetString(
                        excuteCMD.ExecuteScalar(tnx, "Select Get_Age(@dateOfBirth)", CommandType.Text, new
                        {
                            dateOfBirth = Data[0].DOB.ToString("yyyy-MM-dd")
                        }));
                }


                if (!string.IsNullOrEmpty(Data[0].DOB.ToString()))
                    ObjApp.DOB = Util.GetDateTime(Data[0].DOB.ToString("yyyy-MM-dd"));
                
                
                ObjApp.Email = Util.GetString(Data[0].Email);
                ObjApp.TypeOfApp = Util.GetString(Data[0].TypeOfApp);
                ObjApp.PatientType = Util.GetString(Data[0].PatientType);
                ObjApp.Nationality = Util.GetString(Data[0].Nationality);
                ObjApp.City = Util.GetString(Data[0].City);
                ObjApp.Sex = Util.GetString(Data[0].Sex);
                ObjApp.PurposeOfVisit = Util.GetString(Data[0].PurposeOfVisit);
                ObjApp.PurposeOfVisitID = Util.GetInt(Data[0].PurposeOfVisitID);
                ObjApp.VisitType = Data[0].VisitType;
                ObjApp.Date = Util.GetDateTime(Data[0].Date);
                ObjApp.DoctorID = Util.GetString(Data[0].DoctorID);
                ObjApp.Doctor_Name= Util.GetString(Data[0].Doctor_Name);
                ObjApp.Address = Util.GetString(Data[0].Address);
                string SelectTime1 = Data[0].SelectTime.ToString().Split('#')[0];
                ObjApp.Time = Util.GetDateTime(SelectTime1);
                int length = Data[0].SelectTime.ToString().Split('#').Length;
                string AppEndTime = Data[0].SelectTime.ToString().Split('#')[length - 1];
                ObjApp.EndTime = Util.GetDateTime(AppEndTime);
                ObjApp.Notes = Util.GetString(Data[0].Notes);
                ObjApp.EntryUserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                ObjApp.Amount = Util.GetDecimal(Data[0].Amount);
                ObjApp.PanelID = Util.GetInt(Data[0].PanelID);
                ObjApp.ItemID = Util.GetString(Data[0].ItemID);
                ObjApp.SubCategoryID = Util.GetString(Data[0].SubCategoryID);
                ObjApp.PatientID = Util.GetString(Data[0].PatientID);
                ObjApp.IpAddress = All_LoadData.IpAddress();
                ObjApp.AppNo = Util.GetInt(AppNo);
                ObjApp.hashCode = Util.GetString(Data[0].hashCode);
                ObjApp.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                ObjApp.Taluka = Data[0].Taluka;
                ObjApp.District = Data[0].District;
                ObjApp.LandMark = Data[0].LandMark;
                ObjApp.Place = Data[0].Place;

                ObjApp.PinCode = Util.GetString(Data[0].PinCode);
                ObjApp.Occupation = Data[0].Occupation;
                ObjApp.MaritalStatus = Data[0].MaritalStatus;
                ObjApp.Relation = Data[0].Relation;
                ObjApp.RelationName = Data[0].RelationName;
                ObjApp.AdharCardNo = Data[0].AdharCardNo;
                ObjApp.CountryID = Data[0].CountryID;
                ObjApp.StateID = Data[0].StateID;
                ObjApp.DistrictID = Data[0].DistrictID;
                ObjApp.CityID = Data[0].CityID;
                ObjApp.TalukaID = Data[0].TalukaID;
                ObjApp.LedgerTransactionNo = "0";


                ObjApp.PhoneSTDCODE = Data[0].PhoneSTDCODE;
                ObjApp.ResidentialNumber = Data[0].ResidentialNumber;
                ObjApp.ResidentialNumberSTDCODE = Data[0].ResidentialNumberSTDCODE;
                ObjApp.EmergencyFirstName = Data[0].EmergencyFirstName;
                ObjApp.EmergencySecondName = Data[0].EmergencySecondName;
                ObjApp.InternationalCountryID = Data[0].InternationalCountryID;
                ObjApp.InternationalCountry = Data[0].InternationalCountry;
                ObjApp.InternationalNumber = Data[0].ResidentialNumber;
                ObjApp.Phone = Data[0].Phone;

                if (string.IsNullOrEmpty(Data[0].PatientID))
                {
                    ObjApp.VisitType = "New Patient";
                    ObjApp.isNewPatient = 1;
                }
                else
                {
                    ObjApp.VisitType = "Old Patient";
                    ObjApp.isNewPatient = 0;
                }

                if (string.IsNullOrEmpty(centreID))
                    ObjApp.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                else
                    ObjApp.CentreID = Util.GetInt(centreID);

                ObjApp.RateListID = Data[0].RateListID;
                if (Data[0].chkApp == true)
                {
                    ObjApp.IsConform = 1;
                    ObjApp.ConformDate = Util.GetDateTime(DateTime.Now);
                    ObjApp.ConformBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());

                }
                if (visitDetail1.Count > 0)
                {
                    ObjApp.NextSubcategoryID = visitDetail1[0].nextSubcategoryID.ToString();
                    ObjApp.DocValidityPeriod = Util.GetInt(visitDetail1[0].docValidityPeriod.ToString());
                    ObjApp.nextVisitDateMax = Util.GetDateTime(visitDetail1[0].nextVisitDateMax.ToString());
                    ObjApp.nextVisitDateMin = Util.GetDateTime(visitDetail1[0].nextVisitDateMin.ToString());
                    ObjApp.lastVisitDateMax = Util.GetDateTime(visitDetail1[0].lastVisitDateMax.ToString());
                }

                ObjApp.EmergencyPhoneNo = Data[0].EmergencyPhoneNo;
                ObjApp.PlaceOfBirth = Data[0].PlaceOfBirth;
                ObjApp.IdentificationMark = Data[0].IdentificationMark;
                ObjApp.IsInternational = Data[0].IsInternational;
                ObjApp.OverSeaNumber = Data[0].OverSeaNumber;
                ObjApp.EthenicGroup = Data[0].EthenicGroup;
                ObjApp.IsTranslatorRequired = Data[0].IsTranslatorRequired;
                ObjApp.FacialStatus = Data[0].FacialStatus;
                ObjApp.Race = Data[0].Race;
                ObjApp.Employement = Data[0].Employement;
                ObjApp.MonthlyIncome = Data[0].MonthlyIncome;
                ObjApp.ParmanentAddress = Data[0].ParmanentAddress;
                ObjApp.IdentificationMarkSecond = Data[0].IdentificationMarkSecond;
                ObjApp.LanguageSpoken = Data[0].LanguageSpoken;
                ObjApp.EmergencyRelationOf = Data[0].EmergencyRelationOf;
                ObjApp.EmergencyRelationName = Data[0].EmergencyRelationName;
                ObjApp.EmergencyAddress = Data[0].EmergencyAddress;
                string AppID = ObjApp.Insert();

                if (string.IsNullOrEmpty(AppID))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In AppointMent" });
                }
                string[] SelectTime = Data[0].SelectTime.ToString().Split('#');
                for (int a = 0; a < SelectTime.Length; a++)
                {
                    excuteCMD.DML("INSERT INTO appointment_detail(App_ID,DoctorID,DATE,TIME)VALUES(@appointmentID,@doctorID,@date,@time)", CommandType.Text, new
                    {
                        appointmentID = AppID,
                        doctorID = Util.GetString(Data[0].DoctorID),
                        date = Util.GetDateTime(Data[0].Date).ToString("yyyy-MM-dd"),
                        time = Util.GetDateTime(SelectTime[a]).ToString("HH:mm")
                    });

                }

               


                // For Mobile Application Appointment Status Update 
                if (!string.IsNullOrEmpty(mobileAppAppointmentID))
                {
                    excuteCMD.DML(tnx, "UPDATE  app_appointment aap  SET  aap.IsVisited=1 WHERE aap.ID=@ID", CommandType.Text,
                        new { ID = Util.GetInt(mobileAppAppointmentID) }
                    );
                }

                tnx.Commit();


                //**************** SMS************************//
                if (Resources.Resource.SMSApplicable == "1" && !string.IsNullOrEmpty(ObjApp.ContactNo))
                {
                    var templateID = 1;
                    var columninfo = smstemplate.getColumnInfo(templateID, con);
                    if (columninfo.Count > 0)
                    {
                        columninfo[0].PatientID = string.Empty;
                        columninfo[0].PName =  ObjApp.Pname;
                        columninfo[0].Title = ObjApp.Title;
                        columninfo[0].Gender = ObjApp.Sex;
                        columninfo[0].ContactNo =  ObjApp.PhoneSTDCODE + ObjApp.ContactNo;
                        columninfo[0].DoctorName = ObjApp.Doctor_Name;
                        columninfo[0].AppointmentDate = (ObjApp.Date).ToString("yyyy-MM-dd");
                        columninfo[0].AppointmentTime = ObjApp.Time.ToString("HH:mm:ss");
                        columninfo[0].TemplateID = templateID;
                       // string sms = smstemplate.getSMSTemplate(templateID, columninfo, 1, con, ObjApp.EntryUserID);
                    }
                }



                //**************** Email************************//
                if (Resources.Resource.EmailApplicable == "1" && !string.IsNullOrEmpty(ObjApp.Email))
                {

                    var d = new EmailTemplateInfo()
                    {
                        PatientID = string.Empty,
                        PName = ObjApp.Pname,
                        Title = ObjApp.Title,
                        Gender = ObjApp.Sex,
                        ContactNo = ObjApp.ContactNo,
                        DoctorName = ObjApp.Doctor_Name,
                        AppointmentDate = (ObjApp.Date).ToString("yyyy-MM-dd"),
                        AppointmentTime = ObjApp.Time.ToString("HH:mm:ss"),
                        EmailTo = ObjApp.Email,
                        TransactionID = string.Empty
                    };
                    List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                    dd.Add(d);
                    //int sendEmailID = Email_Master.SaveEmailTemplate(2, Util.GetInt(Session["RoleID"].ToString()), "1", dd, string.Empty, null, con);
                }                
                
                
                
                
                
                
                
                
                
                
                
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, AppID = AppID, AppNo = AppNo, response = "<b style='color:black;font-size: 16px;'> Appointment Number &nbsp;:&nbsp;" + AppNo + "</b></br>" });
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
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Not A Valid Appointment Deatils" });
        }

    }

    [WebMethod(EnableSession = true, Description = "Update Appointment")]
    public string UpdateApp(object appointmentData)
    {
        int IsReturn = 0;
        List<appointment> Data = new JavaScriptSerializer().ConvertToType<List<appointment>>(appointmentData);
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD = new ExcuteCMD();
            try
            {
                string[] SelectTime = Data[0].SelectTime.ToString().Split('#');
                int length = Data[0].SelectTime.ToString().Split('#').Length;
                string AppEndTime = Data[0].SelectTime.ToString().Split('#')[length - 1];

                var appointmentID = Util.GetString(Data[0].App_ID);

                excuteCMD.DML(tnx, "Update appointment_detail SET IsCancel=2  where IsCancel=0 and App_ID=@appointmentID and DoctorID=@doctorID", CommandType.Text, new
                {
                    doctorID = Util.GetString(Data[0].DoctorID),
                    appointmentID = appointmentID
                });





                string AppNo = Util.GetString(excuteCMD.ExecuteScalar(tnx, "Select get_AppNo(@doctorID,@appointmentDate,@centreID)", CommandType.Text, new
                {
                    doctorID = Data[0].DoctorID,
                    appointmentDate = Util.GetDateTime(Data[0].Date).ToString("yyyy-MM-dd"),
                    centreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString())
                }));

                IsReturn = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE appointment SET AppNo=" + AppNo + ", TIME='" + Util.GetDateTime(SelectTime[0]).ToString("HH:mm") + "' ,EndTime='" + Util.GetDateTime(SelectTime[len - 1]).ToString("HH:mm") + "', DATE='" + Util.GetDateTime(Data[0].Date).ToString("yyyy-MM-dd") + "',IsReschedule=1,ReScheduleDate='" + Util.GetDateTime(Data[0].Date).ToString("yyyy-MM-dd") + "',RescheduleBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE App_ID=" + Data[0].App_ID + " ");
                


                //StringBuilder sqlCMD = new StringBuilder("Update Appointment Set ");
                //sqlCMD.Append(" Title=@Title, Pname=@Pname, PfirstName=@PfirstName, PlastName=@plastName,");
                //sqlCMD.Append(" DOB=@DOB, Age=@Age, AppNo=@AppNo, ");
                //sqlCMD.Append(" LastUpdatedBy=@LastUpdatedBy, Updatedate=now(),Sex=@Sex, ");
                //sqlCMD.Append(" ContactNo=@ContactNo, Email=@Email, VisitType=@VisitType, TypeOfApp=@TypeOfApp, ");
                //sqlCMD.Append(" PatientType=@PatientType, Nationality=@Nationality, RefDocID=@RefDocID, ");
                //sqlCMD.Append(" PurposeOfVisit=@PurposeOfVisit, PurposeOfVisitID=@PurposeOfVisitID, ");
                //sqlCMD.Append(" Amount=@Amount, PanelID=@PanelID, MaritalStatus=@MaritalStatus, ");
                //sqlCMD.Append(" City=@City, Address=@Address, ");
                //sqlCMD.Append(" Place=@Place, Taluka=@Taluka, LandMark=@LandMark, District=@District, ");
                //sqlCMD.Append(" PinCode=@PinCode, Occupation=@Occupation, Relation=@Relation,");
                //sqlCMD.Append(" RelationName=@RelationName,");
                //sqlCMD.Append(" AdharCardNo=@AdharCardNo, CountryID=@CountryID, DistrictID=@DistrictID, ");
                //sqlCMD.Append(" CityID=@CityID, TalukaID=@TalukaID,  State=@State, StateID=@StateID, ");
                //sqlCMD.Append(" RelationContactNo=@RelationContactNo,AptTime=@AptTime, P_Type=@P_Type, ");
                //sqlCMD.Append(" doc_App_ID=@doc_App_ID,EmergencyPhoneNo=@EmergencyPhoneNo, ");
                //sqlCMD.Append(" IsInternational=@IsInternational, OverSeaNumber=@OverSeaNumber, ");
                //sqlCMD.Append(" IsTranslatorRequired=@IsTranslatorRequired, FacialStatus=@FacialStatus, ");
                //sqlCMD.Append(" Race=@Race, Employement=@Employement, ParmanentAddress=@ParmanentAddress, ");
                //sqlCMD.Append(" IdentificationMarkSecond=@IdentificationMarkSecond, MonthlyIncome=@MonthlyIncome, ");
                //sqlCMD.Append(" EthenicGroup=@EthenicGroup, PlaceOfBirth=@PlaceOfBirth, IdentificationMark=@IdentificationMark, ");
                //sqlCMD.Append(" LanguageSpoken=@LanguageSpoken, EmergencyRelationOf=@EmergencyRelationOf, ");
                //sqlCMD.Append(" EmergencyRelationShip=@EmergencyRelationName WHERE App_ID=@App_ID");

                //Data[0].AppNo = Util.GetInt(AppNo);
                //Data[0].App_ID = Util.GetInt(appointmentID);
                //Data[0].LastUpdatedBy=HttpContext.Current.Session["ID"].ToString();

                //string s = excuteCMD.GetRowQuery(sqlCMD.ToString(), Data[0]);
                
                //excuteCMD.DML(tnx,sqlCMD.ToString(), CommandType.Text, Data[0]);

                
                



                for (int a = 0; a < SelectTime.Length; a++)
                {
                    excuteCMD.DML(tnx,"INSERT INTO appointment_detail(App_ID,DoctorID,DATE,TIME)VALUES(@appointmentID,@doctorID,@date,@time)", CommandType.Text, new
                    {
                        appointmentID = appointmentID,
                        doctorID = Util.GetString(Data[0].DoctorID),
                        date = Util.GetDateTime(Data[0].Date).ToString("yyyy-MM-dd"),
                        time = Util.GetDateTime(SelectTime[a]).ToString("HH:mm")
                    });

                }


                tnx.Commit();

                if (IsReturn > 0)
                {


                    var dt = excuteCMD.GetDataTable("SELECT ap.PatientID,ap.sex,ap.Pname,ap.Title,ap.ContactNo,dm.Name DoctorName, DATE_FORMAT(ap.Date,'%d-%b-%Y') AppointmentDate,TIME_FORMAT(ap.time,'%H:%i:%s') AppointmentTime ,ap.Email FROM appointment ap INNER JOIN doctor_master dm ON dm.DoctorID=ap.DoctorID WHERE ap.App_ID=@appointmentID", CommandType.Text,

                        new
                        {
                            appointmentID = appointmentID

                        });



                    //**************** SMS************************//
                    if (Resources.Resource.SMSApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["ContactNo"])))
                    {
                        var templateID = 3;
                        var columninfo = smstemplate.getColumnInfo(templateID, con);
                        if (columninfo.Count > 0)
                        {
                            columninfo[0].PatientID = Util.GetString(dt.Rows[0]["PatientID"]);
                            columninfo[0].PName = Util.GetString(dt.Rows[0]["Pname"]);
                            columninfo[0].Title = Util.GetString(dt.Rows[0]["Title"]);
                            columninfo[0].Gender = Util.GetString(dt.Rows[0]["Sex"]);
                            columninfo[0].ContactNo = Util.GetString(dt.Rows[0]["ContactNo"]);
                            columninfo[0].DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]);
                            columninfo[0].AppointmentDate = Util.GetString(dt.Rows[0]["AppointmentDate"]);
                            columninfo[0].AppointmentTime = Util.GetString(dt.Rows[0]["AppointmentTime"]);
                            columninfo[0].TemplateID = templateID;
                            //string sms = smstemplate.getSMSTemplate(templateID, columninfo, 1, con, Util.GetString(HttpContext.Current.Session["ID"]));
                        }
                    }



                    //**************** Email************************//
                    if (Resources.Resource.EmailApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["Email"])))
                    {

                        var d = new EmailTemplateInfo()
                        {
                            PatientID = Util.GetString(dt.Rows[0]["PatientID"]),
                            PName = Util.GetString(dt.Rows[0]["Pname"]),
                            Title = Util.GetString(dt.Rows[0]["Title"]),
                            Gender = Util.GetString(dt.Rows[0]["Sex"]),
                            ContactNo = Util.GetString(dt.Rows[0]["ContactNo"]),
                            DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]),
                            AppointmentDate = Util.GetString(dt.Rows[0]["AppointmentDate"]),
                            AppointmentTime = Util.GetString(dt.Rows[0]["AppointmentTime"]),
                            EmailTo = Util.GetString(dt.Rows[0]["Email"]),
                            TransactionID = string.Empty
                        };
                        List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                        dd.Add(d);
                       // int sendEmailID = Email_Master.SaveEmailTemplate(4, Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "1", dd, string.Empty, null, con);
                    } 
                    
                    
                    
                }
              
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, AppNo = AppNo, response = AllGlobalFunction.saveMessage });
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
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "" });
        }

    }
    [WebMethod]
    public string CheckAlreadyDone(string App_ID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM appointment WHERE App_ID=" + App_ID + " AND (IsConform=1 OR IsCancel=1) "));
        if (count > 0)
            return "1";
        else
            return "0";
    }

    [WebMethod]
    public string bindAppDetail(string DocID, string FromDate, string ToDate, string AppNo, string IsConform, string VisitType, string Status)
    {

        DataTable dtSearch = AllLoadData_OPD.SearchAppointment(DocID, Util.GetDateTime(FromDate), Util.GetDateTime(ToDate), AppNo, "", VisitType, Status,"");
        if (dtSearch.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
        else
            return "";

    }



}