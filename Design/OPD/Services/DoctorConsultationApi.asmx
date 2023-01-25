<%@ WebService Language="C#" CodeBehind="~/App_Code/DoctorConsultationApi.cs" Class="DoctorConsultationApi" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DoctorConsultationApi : System.Web.Services.WebService
{
    [WebMethod]

    public string DoctorConsulationApi()
    {
        string result = string.Empty;

        DataTable dt = StockReports.GetDataTable(" SELECT *, ROUND(IF(SPLIT_STR(age,' ',2)='YRS',SPLIT_STR(age,' ',1),0))AgeYear,ROUND(IF(SPLIT_STR(age,' ',2) LIKE 'MONT%',SPLIT_STR(age,' ',1),0))AgeMonth,ROUND(IF(SPLIT_STR(age,' ',2) LIKE 'DAY%',SPLIT_STR(age,' ',1),0))AgeDays from     APIConsultationsendToNetram WHERE Issync=0 ");
        if (dt.Rows.Count > 0)
        {
            try
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    result = string.Empty;
                    Int64 OTP = 0;
                    var request = (HttpWebRequest)WebRequest.Create("http://dental_n_eye_sv/WEBAPI/Api/savevisit/objsavevisit");
                    request.Method = WebRequestMethods.Http.Post;
                    request.ContentType = "application/json; charset=UTF-8";
                    HisToNetram htn = new HisToNetram();
                    
                    Random random = new Random();
                    OTP = random.Next(100000, 999999);

                    htn.PK_VisitId = Util.GetString(dt.Rows[i]["PK_VisitId"]); //Util.GetString(OTP); //
                    htn.FK_BranchId = Util.GetInt(dt.Rows[i]["FK_BranchId"]);
                    htn.FK_RegId = Util.GetInt(dt.Rows[i]["FK_RegId"]);
                    htn.VisitDate = Util.GetDateTime(dt.Rows[i]["VisitDate"]);
                    htn.VisitTime = TimeSpan.Parse(dt.Rows[i]["VisitTime"].ToString());
                    htn.RegDate = Util.GetDateTime(dt.Rows[i]["RegDate"]);
                    htn.RegTime = TimeSpan.Parse(dt.Rows[i]["RegTime"].ToString());
                    htn.ApptTime = TimeSpan.Parse(dt.Rows[i]["ApptTime"].ToString());
                    htn.Initial = Util.GetString(dt.Rows[i]["Initial"]);
                    htn.FirstName = Util.GetString(dt.Rows[i]["FirstName"]);
                    htn.LastName = Util.GetString(dt.Rows[i]["LastName"]);
                    htn.CareOfType = Util.GetString(dt.Rows[i]["CareOfType"]);
                    htn.CareOfName = Util.GetString(dt.Rows[i]["CareOfName"]);
                    htn.AgeYear = Util.GetInt(dt.Rows[i]["AgeYear"]);
                    htn.AgeDays = Util.GetInt(dt.Rows[i]["AgeDays"]);
                    htn.AgeMonth = Util.GetInt(dt.Rows[i]["AgeMonth"]);
                    var dob = Util.GetDateTime(Util.GetDateTime(dt.Rows[i]["DOB"]).ToString("yyyy-MM-dd"));
                    htn.DOB = Util.GetDateTime(Util.GetDateTime(dt.Rows[i]["DOB"]).ToString("yyyy-MM-dd")); ;//Util.GetDateTime("2021-05-01");
                    htn.Sex = Util.GetString(dt.Rows[i]["Sex"]);
                    htn.MobileNo = Util.GetString(dt.Rows[i]["MobileNo"]);
                    htn.EmailAddress = Util.GetString(dt.Rows[i]["EmailAddress"]);
                    htn.Address = Util.GetString(dt.Rows[i]["Address"]);
                    htn.FK_DoctorId = Util.GetInt(dt.Rows[i]["FK_DoctorId"]);
                    htn.IsReview = Util.GetBoolean(dt.Rows[i]["IsReview"]);
                    htn.FK_AppointmentId =  Util.GetInt(dt.Rows[i]["FK_AppointmentId"]);
                    htn.Remarks = Util.GetString(dt.Rows[i]["Remarks"]);
                    htn.Speciality = Util.GetString(dt.Rows[i]["Speciality"]);
                    htn.DoctorName = Util.GetString(dt.Rows[i]["DoctorName"]);
                    try
                    {
                        using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                        {
                            streamWriter.Write(JsonConvert.SerializeObject(htn));
                        }
                        var response = (HttpWebResponse)request.GetResponse();
                        using (var streamReader = new StreamReader(response.GetResponseStream()))
                        {
                            var message = "";
                            message = streamReader.ReadToEnd();
                            if (message != "0")
                            { StockReports.ExecuteDML("UPDATE APIConsultationsendToNetram Set NetramID=" + message + ",IsSync=1,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                            result = "Sucess " + " Data Return " + message ;
                            }
                            else
                            { StockReports.ExecuteDML("UPDATE APIConsultationsendToNetram Set IsSync=0,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                            result = "Fail "+  message;
                            }
                        }
                        response.Close();
                        
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("UPDATE APIConsultationsendToNetram Set IsSync=0,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                        result = "Fail";
                    }

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                result = ex.Message;
            }

        }
        
        return result;
    }
   

    [WebMethod]
    public string DoctorLoginDetailToNetram()
    {
        string result = string.Empty;
        DataTable dt = StockReports.GetDataTable("SELECT dl.ID,dl.UserId,dl.UserName,dl.password,dl.MobileNo,em.Email,IFNULL(dl.Gender,'')Gender,dl.NationalID,dl.RegistrationNo,DATE_FORMAT(dl.dob,'%Y-%m-%d')dob,IFNULL(dl.Usertype,'')Usertype,dl.ClinicName,dl.Specialization,dl.Speciality,dl.FK_BranchId ,dl.LoginName,dl.Doctorid FROM APIDoctorLoginDetailToNetram dl INNER JOIN employee_master em ON dl.UserId=em.EmployeeID WHERE issync=0;");

        if (dt.Rows.Count > 0)
        {
            try {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    result = string.Empty;
                    var request = (HttpWebRequest)WebRequest.Create("http://dental_n_eye_sv/WEBAPI/Api/saveuser/objsaveuser");
                    request.Method = WebRequestMethods.Http.Post;
                    request.ContentType = "application/json; charset=UTF-8";
                    DoctorLoginDetailToNetram dld =new  DoctorLoginDetailToNetram();

                    dld.UserId = Util.GetString(dt.Rows[i]["UserId"]);
                    dld.FK_BranchId = Util.GetInt(dt.Rows[i]["FK_BranchId"]);
                    dld.LoginName = Util.GetString(dt.Rows[i]["LoginName"]);
                    dld.UserName = Util.GetString(dt.Rows[i]["UserName"]);
                    dld.password = Util.GetString(dt.Rows[i]["password"]);
                    dld.MobileNo = Util.GetString(dt.Rows[i]["MobileNo"]);
                    dld.Email = Util.GetString(dt.Rows[i]["Email"]);
                    dld.Gender = Util.GetString(dt.Rows[i]["Gender"]);
                    dld.NationalID = Util.GetString(dt.Rows[i]["NationalID"]);
                    dld.RegistrationNo = Util.GetString(dt.Rows[i]["RegistrationNo"]);
                    dld.DOB = Util.GetDateTime("1901-01-01"); //Util.GetDateTime(Util.GetDateTime(dt.Rows[i]["DOB"]).ToString("yyyy-MM-dd"));
                    dld.Usertype = "DOCTOR";//Util.GetString(dt.Rows[i]["Usertype"]);
                    dld.ClinicName = Util.GetString(dt.Rows[i]["ClinicName"]);
                    dld.Specialization = Util.GetString(dt.Rows[i]["Specialization"]);
                    dld.Speciality = Util.GetString(dt.Rows[i]["Speciality"]);
                    dld.DoctorId = Util.GetInt(dt.Rows[i]["Doctorid"]);

                    try {
                            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                            {
                                streamWriter.Write(JsonConvert.SerializeObject(dld));
                            }
                            var response = (HttpWebResponse)request.GetResponse();
                            using (var streamReader = new StreamReader(response.GetResponseStream()))
                            {
                                var message = "";
                                message = streamReader.ReadToEnd();
                                if (message != "0")
                                {
                                    StockReports.ExecuteDML("UPDATE APIDoctorLoginDetailToNetram Set NetramID=" + message + ",IsSync=1,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                                    result = "Sucess " + " Data Return " + message;
                                }
                                else
                                {
                                    StockReports.ExecuteDML("UPDATE APIDoctorLoginDetailToNetram Set IsSync=0,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                                    result = "Fail " + message;
                                }
                            }
                            response.Close();
                        }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("UPDATE APIConsultationsendToNetram Set IsSync=0,IsSyncDatetime=NOW() WHERE ID=" + Util.GetInt(dt.Rows[i]["ID"]) + "");
                        result = "Fail";
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                result = ex.Message;
            }        
        }
        return result;
    }
}