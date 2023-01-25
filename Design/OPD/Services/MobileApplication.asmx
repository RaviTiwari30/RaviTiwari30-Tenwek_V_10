<%@ WebService Language="C#" Class="MobileApplication" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class MobileApplication : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod]
    public string GetMobileApplicationAppointment()
    {
        var sqlCmd = new StringBuilder("SELECT aap.ID, apm.Title,apm.PFirstName,apm.PLastName,apm.PatientName,apm.Age,");
                        sqlCmd.Append("apm.Gender,apm.Mobile,apm.Email,");
                        sqlCmd.Append("apm.CountryID countryID,apm.cityID,apm.House_No,");
                        sqlCmd.Append("DATE_FORMAT(aap.AppointmentDate,'%d-%b-%Y') AppointmentDate,aap.DoctorID DoctorID,");
                        sqlCmd.Append("Time_format(aap.StartTime,'%h:%i %p') StartTime,Time_format(DATE_ADD(aap.StartTime, INTERVAL 10 MINUTE),'%h:%i %p') EndTime,(SELECT CONCAT(dm.Title,' ',dm.Name) FROM  doctor_master dm WHERE dm.DoctorID=aap.DoctorID) Doctor,aap.IsRegistred,aap.ID patientID FROM app_appointment  aap ");
                        sqlCmd.Append("INNER JOIN app_patient_master  apm ON aap.PatientID=apm.ID WHERE aap.IsRegistred=0 and   aap.AppointmentDate=CURDATE() AND aap.IsVisited=0");
                        sqlCmd.Append(" UNION ALL ");
                        sqlCmd.Append("SELECT aap.ID, apm.Title,apm.PFirstName,apm.PLastName,apm.PName PatientName,apm.Age, ");
                        sqlCmd.Append("apm.Gender,apm.Mobile,apm.Email, ");
                        sqlCmd.Append("apm.CountryID countryID,apm.cityID,apm.House_No, ");
                        sqlCmd.Append("DATE_FORMAT(aap.AppointmentDate,'%d-%b-%Y') AppointmentDate,aap.DoctorID DoctorID, ");
                        sqlCmd.Append("Time_format(aap.StartTime,'%h:%i %p') StartTime,Time_format(DATE_ADD(aap.StartTime, INTERVAL 10 MINUTE),'%h:%i %p') EndTime,(SELECT CONCAT(dm.Title,' ',dm.Name) FROM  doctor_master dm WHERE dm.DoctorID=aap.DoctorID) Doctor,aap.IsRegistred,aap.PatientID FROM app_appointment  aap ");
                        sqlCmd.Append("INNER JOIN patient_master  apm ON aap.PatientID=apm.PatientID WHERE aap.IsRegistred=1 and aap.AppointmentDate=CURDATE() AND aap.IsVisited=0");

                        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCmd.ToString()));
        
    }



}