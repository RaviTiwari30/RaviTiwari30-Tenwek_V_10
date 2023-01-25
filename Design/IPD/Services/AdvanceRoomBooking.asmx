<%@ WebService Language="C#" Class="AdvanceRoomBooking" %>
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
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AdvanceRoomBooking : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }





    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveAdvanceRoomBooking(object bookingDetails, List<PanelDocument> panelDocuments)
    {
        List<Advance_Room_Booking> dataBooking = new JavaScriptSerializer().ConvertToType<List<Advance_Room_Booking>>(bookingDetails);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            Advance_Room_Booking objARB = new Advance_Room_Booking(tranx);
            objARB.PatientID = dataBooking[0].PatientID;
            objARB.BookingDate = dataBooking[0].BookingDate;
            objARB.IPDCaseType_ID = dataBooking[0].IPDCaseType_ID;
            objARB.Room_ID = dataBooking[0].Room_ID;
            objARB.IPDCaseType_ID_Bill = dataBooking[0].IPDCaseType_ID_Bill;
            objARB.DoctorID = dataBooking[0].DoctorID;
            objARB.EntryBy = dataBooking[0].EntryBy;
            objARB.Remarks = dataBooking[0].Remarks;
            objARB.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
            
            objARB.PanelID = Util.GetInt(dataBooking[0].PanelID);
            objARB.ApprovalAmount = Util.GetInt(dataBooking[0].ApprovalAmount);
            objARB.ApprovalRemark = Util.GetString(dataBooking[0].ApprovalRemark);
            objARB.PolicyNo = Util.GetString(dataBooking[0].PolicyNo);
            objARB.ExpiryDate =  Util.GetDateTime(Util.GetDateTime(dataBooking[0].ExpiryDate).ToString("yyyy-MM-dd"));
            objARB.PolicyCardNo = Util.GetString(dataBooking[0].PolicyCardNo);
            objARB.NameOnCard = Util.GetString(dataBooking[0].NameOnCard);
            objARB.CardHolder = Util.GetString(dataBooking[0].CardHolder);
            objARB.IgnorePolicy = Util.GetInt(dataBooking[0].IgnorePolicy);
            objARB.IgnorePolicyReason = Util.GetString(dataBooking[0].IgnorePolicyReason);
            objARB.referedSource = Util.GetString(dataBooking[0].referedSource);
            objARB.admissionType = Util.GetString(dataBooking[0].admissionType);


            objARB.ID = objARB.Insert();

            var response = PatientDocument.SavePanelDocument(panelDocuments, objARB.ID, objARB.PatientID, objARB.PanelID);

            tranx.Commit();

            var dt = excuteCMD.GetDataTable("SELECT pm.PName PatientName,pm.Mobile ContactNo,pm.Email EmailAddress,icm.Name RoomType,'' DoctorName,DATE_FORMAT(ad.BookingDate,'%d-%b-%Y') AdmissionDate FROM advance_room_booking  ad INNER JOIN ipd_case_type_master icm ON ad.IPDCaseTypeID=icm.IPDCaseTypeID INNER JOIN patient_master pm ON pm.PatientID=ad.PatientID WHERE ad.ID=@id", CommandType.Text, new
            {
                id = objARB.ID
            });


            //**************** SMS************************//
            if (Resources.Resource.SMSApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["ContactNo"])))
            {
                int templateID = 5;
                var columninfo = smstemplate.getColumnInfo(templateID, con);
                if (columninfo.Count > 0)
                {
                    columninfo[0].PName = Util.GetString(dt.Rows[0]["PatientName"]);
                    columninfo[0].ContactNo = Util.GetString("+230" + dt.Rows[0]["ContactNo"]);
                    columninfo[0].EmailAddress = Util.GetString(dt.Rows[0]["EmailAddress"]);
                    columninfo[0].Ward = Util.GetString(dt.Rows[0]["RoomType"]);
                    columninfo[0].AdmDate = Util.GetString(dt.Rows[0]["AdmissionDate"]);
                    columninfo[0].DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]);
                    columninfo[0].TemplateID = templateID;
                    string sms = smstemplate.getSMSTemplate(templateID, columninfo, 1, con, Util.GetString(HttpContext.Current.Session["ID"]));
                }
            }



            //**************** Email************************//
            if (Resources.Resource.EmailApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["EmailAddress"])))
            {

                var d = new EmailTemplateInfo()
                {

                    PName = Util.GetString(dt.Rows[0]["PatientName"]),
                    ContactNo = Util.GetString(dt.Rows[0]["ContactNo"]),
                    EmailTo = Util.GetString(dt.Rows[0]["EmailAddress"]),
                    EmailAddress = Util.GetString(dt.Rows[0]["EmailAddress"]),
                    RoomType=Util.GetString(dt.Rows[0]["RoomType"]),
                    AdmissionDate = Util.GetString(dt.Rows[0]["AdmissionDate"]),
                    DoctorName=Util.GetString(dt.Rows[0]["DoctorName"])
                };
                List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                dd.Add(d);
                int sendEmailID = Email_Master.SaveEmailTemplate(6, Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "1", dd, string.Empty, null, con);
            }
            
            
            
            
           
               
            
            
            


          

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, booking_ID = objARB.ID, patientID = dataBooking[0].PatientID,PanelID= objARB.PanelID });
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true, Description = "Bind Advance Room Booking Details")]
    public string RoomBookingPrintOut(string booking_ID, string userID)
    {
        StringBuilder query = new StringBuilder();
        query.Append(" SELECT pm.PatientID,UPPER(CONCAT(pm.Title,' ',pm.Pname))PatientName,UPPER(CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(pm.Street_Name,''),' ' , IFNULL(pm.Locality,''), ' ' , IFNULL(pm.City,''))) Address, ");
        query.Append(" pm.Country,PM.Age,DATE_FORMAT(pm.DOB,'%d %b %Y')DOB,UPPER(PM.Gender)Gender,PM.Mobile,DATE_FORMAT(arb.EntryDate,'%d-%b-%Y')EntryDate,CONCAT(em.Title,' ',em.Name) AS EntryBy, ");
        query.Append(" DATE_FORMAT(arb.BookingDate,'%d-%b-%y')BookingDate,ict.Name AS RoomType, (SELECT CONCAT(rm.Name,'-',rm.Room_No,'-',rm.Bed_No) FROM room_master rm  WHERE roomid=arb.roomid) RoomName,UPPER((SELECT CONCAT(Title,' ',NAME) FROM doctor_master WHERE DoctorID=arb.DoctorID))DocName ");
        query.Append(" FROM advance_room_booking arb INNER JOIN patient_master pm ON arb.PatientID=pm.PatientID ");
        query.Append(" INNER JOIN ipd_case_type_master ict ON ict.IPDCaseTypeID = arb.IPDCaseTypeID INNER JOIN employee_master em ON em.EmployeeID=arb.EntryBy WHERE arb.ID='" + booking_ID + "' LIMIT 1 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(userID).Rows[0][0].ToString();
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "PatientDetail";

            //DataTable dtImg = All_LoadData.CrystalReportLogo();
            //ds.Tables.Add(dtImg.Copy());
            //ds.Tables[1].TableName = "ClientImage";

           // ds.WriteXmlSchema(@"D:\\PtAdvanceRoomBooking.xml");

            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "PtAdvanceRoomBooking";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false });
        }
    }

    [WebMethod(EnableSession = true, Description = "Room Already Booked for Patient")]
    public string CheckAdvanceBooking(string patientID)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT CONCAT(ict.Name,'#',CONCAT(rm.Name,'-',rm.Room_No,'-',rm.Bed_No),'#',DATE_FORMAT(arb.BookingDate,'%d-%b-%Y'))BookingDetail ");
        query.Append(" FROM advance_room_booking arb INNER JOIN room_master rm ON arb.Room_ID=rm.Room_Id INNER JOIN ipd_case_type_master ict ON ict.IPDCaseTypeID = arb.IPDCaseTypeID ");
        query.Append(" WHERE PatientID='" + patientID + "' AND DATE(BookingDate)>=CURRENT_DATE() LIMIT 1 ");

        string str = Util.GetString(StockReports.ExecuteScalar(query.ToString()));

        if (str != "")
        {
            result = str;
        }

        return result;
    }


    [WebMethod]
    public string GetPanelDocument(string panelID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable("SELECT pd.DocumentID,pd.Document FROM  f_paneldocumentMaster pd INNER JOIN f_paneldocumentdetail pdd ON pd.DocumentID=pdd.DocumentID WHERE pd.IsActive=1 AND pdd.`IsActive`=1 AND pdd.PanelID=@panelID GROUP BY pd.DocumentID ", CommandType.Text, new { panelID = panelID });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }






    [WebMethod]
    public void AutoReminder() {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        
        try
        {

         StringBuilder sqlCmd= new StringBuilder("  SELECT pm.PName,pm.Mobile ContactNo,pm.Email,icm.Name,'' DoctorName , ");
        sqlCmd.Append(" DATE_FORMAT(ad.BookingDate,'%d-%b-%Y') AdmissionDate ");
        sqlCmd.Append(" FROM advance_room_booking  ad ");

        sqlCmd.Append(" INNER JOIN ipd_case_type_master icm ON ad.IPDCaseTypeID=icm.IPDCaseTypeID ");
        sqlCmd.Append(" INNER JOIN patient_master pm ON pm.PatientID=ad.PatientID   ");
        sqlCmd.Append(" WHERE  SUBDATE(ad.BookingDate,INTERVAL 1 DAY)=CURRENT_DATE() ");

        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, null);

        for (int i = 0; i < dt.Rows.Count; i++)
        {


            //**************** SMS************************//
            if (Resources.Resource.SMSApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["ContactNo"])))
            {
                int templateID = 6;
                var columninfo = smstemplate.getColumnInfo(templateID, con);
                if (columninfo.Count > 0)
                {

                    columninfo[0].PName = Util.GetString(dt.Rows[0]["PatientName"]);
                    columninfo[0].ContactNo = Util.GetString("+230" + dt.Rows[0]["ContactNo"]);
                    columninfo[0].EmailAddress = Util.GetString(dt.Rows[0]["EmailAddress"]);
                    columninfo[0].Ward = Util.GetString(dt.Rows[0]["RoomType"]);
                    columninfo[0].AdmDate = Util.GetString(dt.Rows[0]["AdmissionDate"]);
                    columninfo[0].DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]);
                    columninfo[0].TemplateID = templateID;
     //               string sms = smstemplate.getSMSTemplate(templateID, columninfo, 1, con, Util.GetString(HttpContext.Current.Session["ID"]));
                }
            }



            //**************** Email************************//
            if (Resources.Resource.EmailApplicable == "1" && !string.IsNullOrEmpty(Util.GetString(dt.Rows[0]["EmailAddress"])))
            {

                var d = new EmailTemplateInfo()
                {

                    PName = Util.GetString(dt.Rows[0]["PatientName"]),
                    ContactNo = Util.GetString(dt.Rows[0]["ContactNo"]),
                    EmailTo = Util.GetString(dt.Rows[0]["EmailAddress"]),
                    EmailAddress = Util.GetString(dt.Rows[0]["EmailAddress"]),
                    RoomType = Util.GetString(dt.Rows[0]["RoomType"]),
                    AdmissionDate = Util.GetString(dt.Rows[0]["AdmissionDate"]),
                    DoctorName = Util.GetString(dt.Rows[0]["DoctorName"])
                };
                List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                dd.Add(d);
       //         int sendEmailID = Email_Master.SaveEmailTemplate(7, Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "1", dd, string.Empty, null, con);
            }
            
            
            
        }
            
            
            
            
            
        }
        catch (Exception ex)
        {
          
            ClassLog cl = new ClassLog();
            cl.errLog(ex);  
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    
    }
    
    



}