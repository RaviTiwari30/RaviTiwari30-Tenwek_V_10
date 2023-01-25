<%@ WebService Language="C#" Class="OTBooking" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text;
using System.Linq;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OTBooking : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }



    public class Booking
    {
        public string otNumber { get; set; }
        public string patientName { get; set; }
        public string age { get; set; }
        public string gender { get; set; }
        public string address { get; set; }
        public string contactNo { get; set; }
        public string doctorID { get; set; }
        public string surgeryID { get; set; }
        public string OTID { get; set; }
        public string surgeryDate { get; set; }
        public string slotFromTime { get; set; }
        public string slotToTime { get; set; }
        public string outPatientID { get; set; }
        public string patientID { get; set; }
        public string transactionID { get; set; }
        public string centreID { get; set; }
        public string IPAddress { get; set; }
        public string entryBy { get; set; }
        public string rescheduledRefID { get; set; }
        public string SurgeryName { get; set; }
        public string SurgeryNameForOther { get; set; } 
    }



    public class surgerylist
    {
        public string surgeryID { get; set; }
        public string surgeryName { get; set; }
    }
    
    [WebMethod(EnableSession = true)]
    public string Save(Booking booking, int bookingID, string rescheduleReason, List<surgerylist> surgeryList)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();
        var centreID = HttpContext.Current.Session["CentreID"].ToString();
        var outPatientID = string.Empty;
        var otNumber = string.Empty;

        try
        {


            if (bookingID == 0)
            {
                otNumber = excuteCMD.ExecuteScalar(tnx, "SELECT get_OTBooking_Number(@centreID)", CommandType.Text, new
                {
                    centreID = centreID
                });
                if (string.IsNullOrEmpty(booking.patientID))
                    outPatientID = excuteCMD.ExecuteScalar(tnx, "SELECT get_otgeneralpatientID()", CommandType.Text, new { });
            }
            else
            {
                var bookingDetails = excuteCMD.GetDataTable("SELECT  ot.OutPatientID,ot.OTNumber FROM ot_booking ot WHERE ot.ID=@bookingID", CommandType.Text, new
                {
                    bookingID = bookingID
                });

                if (bookingDetails.Rows.Count < 1)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Invalid Patient Details." });


                if (!string.IsNullOrEmpty(rescheduleReason))
                {

                    excuteCMD.DML(tnx, "UPDATE ot_booking  ot SET ot.IsActive=0 ,ot.RescheduledReason=@rescheduledReason, ot.RescheduledBy=@rescheduledBy,ot.IsRescheduled=1,ot.RescheduledDate=NOW() WHERE ot.ID=@bookingID", CommandType.Text, new
                    {
                        rescheduledBy = userID,
                        rescheduledReason = rescheduleReason,
                        bookingID = bookingID
                    });
                    booking.rescheduledRefID = Util.GetString(bookingID);
                }
                else
                {
                    excuteCMD.DML(tnx, "UPDATE ot_booking  ot SET ot.IsActive=0 AND ot.LastUpdateBy=@lastUpdateBy,ot.LastUpdateDate=NOW() WHERE ot.ID=@bookingID", CommandType.Text, new
                    {
                        lastUpdateBy = userID,
                        bookingID = bookingID
                    });
                }



                outPatientID = Util.GetString(bookingDetails.Rows[0]["OutPatientID"]);
                otNumber = Util.GetString(bookingDetails.Rows[0]["OTNumber"]);

            }




            if (string.IsNullOrEmpty(otNumber))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In OT Number." });




            StringBuilder sqlCMD = new StringBuilder();
            sqlCMD.Append("INSERT INTO ot_booking ( OTNumber, PatientName, Age, Gender, Address, ContactNo, DoctorID, SurgeryID, OTID, SurgeryDate, SlotFromTime, SlotToTime, OutPatientID, PatientID, TransactionID, CentreID,IPAddress,EntryBy,RescheduledRefID,SurgeryName,SurgeryNameForOther)");
            sqlCMD.Append(" VALUES (@otNumber,@patientName,@age,@gender,@address,@contactNo,@doctorID,@surgeryID,@OTID,@surgeryDate,@slotFromTime,@slotToTime,@outPatientID,@patientID,@transactionID,@centreID,@IPAddress,@entryBy,@rescheduledRefID,@SurgeryName,@SurgeryNameForOther)");



            booking.entryBy = userID;
            booking.centreID = centreID;
            booking.IPAddress = All_LoadData.IpAddress();
            booking.surgeryDate = Util.GetDateTime(booking.surgeryDate).ToString("yyyy-MM-dd");
            booking.slotFromTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + booking.slotFromTime).ToString("HH:mm");
            booking.slotToTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + booking.slotToTime).ToString("HH:mm");
            booking.outPatientID = outPatientID;
            booking.otNumber = otNumber;

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, booking);
    

            //entry in multiple surgery table

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from ot_multiple_Surgery Where OtBookingId='" + otNumber + "'  ");
            for (int i = 0; i < surgeryList.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert into ot_multiple_Surgery(OtBookingId,SurgeryID,SurgerName)values('" + otNumber + "','" + surgeryList[i].surgeryID + "','" + surgeryList[i].surgeryName + "')");
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage, otNumber = otNumber });

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
    public string GetPatientBookingDetails(string bookingID, string patientID, string Fromdate, string Todate)
    {
        Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        StringBuilder sqlCMD = new StringBuilder();
       // sqlCMD.Append("SELECT ot.ID bookingID, ot.OTNumber, ot.PatientName, OT.PatientID , ot.Age, ot.Gender,ot.ContactNo , ot.Address, ot.DoctorID, CONCAT(dm.Title,' ',dm.Name)DoctorName, ot.SurgeryID,IF( IFNULL(ot.SurgeryNameForOther,'')<>'',ot.SurgeryNameForOther,sm.Name) SurgeryName, ot.OTID,om.Name OTName, DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, DATE_FORMAT(ot.SlotFromTime,'%h:%i %p')SlotFromTime, DATE_FORMAT(ot.SlotToTime,'%h:%i %p')SlotToTime, ot.PatientID, ot.IsCancel,ot.IsConfirm, ot.RescheduledRefID,IF(IFNULL(ot.PatientID,'')='',0,1)IsRegistredPatient FROM ot_booking  ot INNER JOIN  doctor_master  dm  ON dm.DoctorID=ot.DoctorID INNER JOIN f_surgery_master sm ON sm.Surgery_ID=ot.SurgeryID INNER JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 ");
        sqlCMD.Append("SELECT ot.ID bookingID, ot.OTNumber, ot.PatientName, OT.PatientID , ot.Age, ot.Gender,ot.ContactNo , ot.Address, ot.DoctorID, CONCAT(dm.Title,' ',dm.Name)DoctorName, ot.SurgeryID, (SELECT GROUP_CONCAT(TRIM(SurgerName)) FROM ot_multiple_Surgery WHERE OtBookingID=ot.OTNumber)  SurgeryName, ot.OTID,om.Name OTName, DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, DATE_FORMAT(ot.SlotFromTime,'%h:%i %p')SlotFromTime, DATE_FORMAT(ot.SlotToTime,'%h:%i %p')SlotToTime, ot.PatientID, ot.IsCancel,ot.IsConfirm, ot.RescheduledRefID,IF(IFNULL(ot.PatientID,'')='',0,1)IsRegistredPatient FROM ot_booking  ot INNER JOIN  doctor_master  dm  ON dm.DoctorID=ot.DoctorID INNER JOIN f_itemmaster im  ON im.ItemID=ot.SurgeryID INNER JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 ");


        if (!string.IsNullOrEmpty(bookingID))
            sqlCMD.Append(" and ot.OTNumber=@bookingID");
        else if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and ot.PatientID=@patientID");
        if (!string.IsNullOrEmpty(Fromdate) && !string.IsNullOrEmpty(Todate))
        {

            sqlCMD.Append(" and ot.`EntryDate`>='" + Fromdate + " 00:00:00' AND ot.`EntryDate`<='" + Todate + " 23:59:59'");
        }

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                bookingID = bookingID,
                patientID = patientID
            });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string CancelBooking(string bookingID, string reason)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();
        try
        {


            excuteCMD.DML(tnx, "UPDATE ot_booking  ot SET ot.IsCancel=1 ,ot.CancelReason=@cancelReason, ot.CancelBy=@cancelBy,ot.Canceldate=NOW() WHERE ot.ID=@bookingID", CommandType.Text, new
            {
                cancelBy = userID,
                cancelReason = reason,
                bookingID = bookingID
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

    public class EquipmentDetail
    {
        public string equipmentName { get; set; }
        public int quantity { get; set; }
        public int equipmentID { get; set; }
    }

    public class EquipmentStockDetail
    {

        public int EquipmentStockID { get; set; }
        public int EquipmentID { get; set; }
        public string EquipmentName { get; set; }
        public decimal AvailableStock { get; set; }
        public decimal DeductQuantity { get; set; }
    }

    [WebMethod]
    public string mappatientid(string patientID, string PatientName, string Age, string Gender, string Address, string ContactNo, string transactionID, string bookingID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            excuteCMD.DML(tnx, "UPDATE ot_booking  ot SET ot.patientID=@patientID,ot.PatientName=@PatientName,ot.Age=@Age,ot.Gender=@Gender,ot.Address=@Address,ot.ContactNo=@ContactNo,ot.TransactionID=@transactionID WHERE ot.ID=@bookingID ", CommandType.Text, new
            {
                patientID = patientID,
                PatientName = PatientName,
                Age = Age,
                Gender = Gender,
                Address = Address,
                ContactNo = ContactNo,
                transactionID = transactionID,
                bookingID = bookingID
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
    public string ConfirmBooking(string bookingID, string remark, string patientID, string transactionID, List<EquipmentDetail> equipmentDetails)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();
        var centreID = HttpContext.Current.Session["CentreID"].ToString();
        try
        {


            DataTable bookingDetails = excuteCMD.GetDataTable("SELECT ot.ID BookingID,ot.OTID,ot.OTNumber,ot.SurgeryID,DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, ot.SlotFromTime SlotFromTime, ot.SlotToTime SlotToTime FROM  ot_booking ot WHERE ot.ID=@bookingID", CommandType.Text, new
            {

                bookingID = bookingID

            });

            var surgeryDate = Util.GetDateTime(bookingDetails.Rows[0]["SurgeryDate"]).ToString("yyyy-MM-dd");
            var slotFromTime = Util.GetString(bookingDetails.Rows[0]["SlotFromTime"]);
            var slotToTime = Util.GetString(bookingDetails.Rows[0]["SlotToTime"]);


            var isAlreadySchedule = Util.GetInt(excuteCMD.ExecuteScalar("SELECT COUNT(*)IsAlreadySchedule FROM  ot_booking ot WHERE ot.SurgeryDate=@surgeryDate  AND  @slotFromTime>=ot.SlotFromTime AND @slotFromTime <=ot.SlotToTime AND ot.PatientID=@patientID AND ot.IsConfirm=1", new
            {
                surgeryDate = surgeryDate,
                slotFromTime = slotFromTime,
                patientID = patientID

            }));


            if (isAlreadySchedule > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Already OT Schedule." });


            //var isAlreadyExpired = Util.GetInt(excuteCMD.ExecuteScalar("SELECT COUNT(*)IsExpired FROM  ot_booking ot WHERE ot.SurgeryDate<=CURRENT_DATE() AND  ot.SlotFromTime<=TIME_FORMAT(NOW(),'%H:%i') AND ot.ID=@bookingID", new
            //{
            //    bookingID = bookingID
            //}));



            //if (isAlreadyExpired > 0)
            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "OT Timing Already Expired." });


            excuteCMD.DML(tnx, "UPDATE ot_booking  ot SET ot.patientID=@patientID,ot.TransactionID=@transactionID,ot.IsConfirm=1,ot.ConfirmBy=@confirmBy,ot.ConfirmDate=NOW() WHERE ot.ID=@bookingID", CommandType.Text, new
            {
                confirmBy = userID,
                patientID = patientID,
                bookingID = bookingID,
                transactionID = transactionID
            });

            var equipmentStockDetail = excuteCMD.GetDataTable("CALL Get_Equipment_StockAvailable(@slotDate,@fromTime,@toTime,1,@centreID)", CommandType.Text, new
            {
                slotDate = surgeryDate,
                fromTime = slotFromTime,
                toTime = slotToTime,
                centreID = centreID
            });

            var _equipmentStockDetail = Util.GetListFromDataTable<EquipmentStockDetail>(equipmentStockDetail);


            StringBuilder sqlCMD = new StringBuilder("INSERT INTO ot_equipment_booking ( OTBookingID, OTID, OTBookingNo, TransactionID, PatientID, SurgeryID, BookingDate, BookingStartTime, BookingEndTime, EquipmentStockID, EquipmentID, BookedQuantity, EntryBy ) ");
            sqlCMD.Append(" VALUES (@bookingID,@OTID,@bookingNumber,@transactionID,@patientID,@surgeryID,@bookingDate,@slotStartTime,@slotEndTime,@equipmentStockID,@equipmentID,@quantity,@userID)");
            for (int i = 0; i < equipmentDetails.Count; i++)
            {

                List<EquipmentStockDetail> filteredEquipmentStockDetail = _equipmentStockDetail.Where(s => s.EquipmentID == equipmentDetails[i].equipmentID).ToList();
                var requiredQuantity = equipmentDetails[i].quantity;
                List<EquipmentStockDetail> selectedEquipmentStock = new List<EquipmentStockDetail>();

                requiredQuantity = GetSelectedStockDetails(filteredEquipmentStockDetail, requiredQuantity, selectedEquipmentStock);

                for (int j = 0; j < selectedEquipmentStock.Count; j++)
                {
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                    {
                        bookingID = bookingID,
                        OTID = Util.GetString(bookingDetails.Rows[0]["OTID"]),
                        bookingNumber = Util.GetString(bookingDetails.Rows[0]["OTNumber"]),
                        transactionID = transactionID,
                        patientID = patientID,
                        surgeryID = Util.GetString(bookingDetails.Rows[0]["SurgeryID"]),
                        bookingDate = surgeryDate,
                        slotStartTime = Util.GetDateTime(surgeryDate + " " + slotFromTime).ToString("HH:mm"),
                        slotEndTime = Util.GetDateTime(surgeryDate + " " + slotToTime).ToString("HH:mm"),
                        equipmentStockID = selectedEquipmentStock[j].EquipmentStockID,
                        equipmentID = equipmentDetails[i].equipmentID,
                        quantity = selectedEquipmentStock[j].DeductQuantity,
                        userID = userID
                    });
                }
            }

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

    private static int GetSelectedStockDetails(List<EquipmentStockDetail> _equipmentStockDetail, int requiredQuantity, List<EquipmentStockDetail> selectedEquipmentStock)
    {
        for (int j = 0; j < _equipmentStockDetail.Count; j++)
        {
            if (_equipmentStockDetail[j].AvailableStock == requiredQuantity)
            {
                _equipmentStockDetail[j].DeductQuantity = requiredQuantity;
                selectedEquipmentStock.Add(_equipmentStockDetail[j]);
                break;
            }
            else if (_equipmentStockDetail[j].AvailableStock < requiredQuantity)
            {
                _equipmentStockDetail[j].DeductQuantity = _equipmentStockDetail[j].AvailableStock;
                requiredQuantity = (requiredQuantity - Util.GetInt(_equipmentStockDetail[j].DeductQuantity));
                selectedEquipmentStock.Add(_equipmentStockDetail[j]);
            }
            else if (_equipmentStockDetail[j].AvailableStock > requiredQuantity)
            {
                _equipmentStockDetail[j].DeductQuantity = requiredQuantity;
                requiredQuantity = (requiredQuantity - requiredQuantity);
                selectedEquipmentStock.Add(_equipmentStockDetail[j]);
                break;
            }
        }
        return requiredQuantity;
    }








    [WebMethod(EnableSession = true)]
    public string GetAdmittedPatient(string patientID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

       // StringBuilder sqlCMD = new StringBuilder("SELECT REPLACE(ich.TransactionID,'ISHHI','')TransactionID,pmh.PatientID FROM  ipd_case_history ich INNER JOIN  patient_medical_history pmh ON pmh.TransactionID=ich.TransactionID WHERE ich.Status='IN' AND ich.CentreID=@centreID");
        StringBuilder sqlCMD = new StringBuilder(" SELECT TransNo AS TransactionID,PatientID FROM patient_medical_history pmh WHERE pmh.STATUS='IN' AND pmh.TYPE IN ('IPD') AND pmh.CentreID=@centreID");
        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and pmh.PatientID=@patientID");



        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
         {
             centreID = Util.GetString(HttpContext.Current.Session["CentreID"].ToString()),
             patientID = patientID
         });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetAdmitPatientDetails(string transactionID)
    {
        int TID = 0;
        ExcuteCMD excuteCMD = new ExcuteCMD();
        if (transactionID != "0")        
            TID = Util.GetInt(StockReports.ExecuteScalar("SELECT transactionID FROM patient_medical_history WHERE TransNo='" + transactionID + "' And centreID='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString()) + "' "));
                
        var dt = excuteCMD.GetDataTable("SELECT pmh.TransactionID, pm.PatientID, CONCAT(pm.Title,' ',pm.PName)PatientName,pm.Age,pmh.DoctorID,CONCAT(dm.Title,' ',dm.Name)DoctorName,pm.Gender, pm.Mobile Phone,IFNULL(Get_Current_Room(pmh.TransactionID),'') BedDetail,IFNULL(CONCAT(pm.house_no,' ',pm.city),'') AS Address FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID WHERE pmh.TransactionID=@transactionID", CommandType.Text, new
        {
            transactionID = TID
        });



        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string getEquipments(string scheduleDate, string startTime, string endTime)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable("CALL Get_Equipment_StockAvailable(@scheduleDate,@startTime,@endTime,0,@centreID);", CommandType.Text, new
        {
            scheduleDate = Util.GetDateTime(scheduleDate).ToString("yyyy-MM-dd"),
            startTime = Util.GetDateTime(scheduleDate + ' ' + startTime).ToString("HH:mm"),
            endTime = Util.GetDateTime(scheduleDate + ' ' + endTime).ToString("HH:mm"),
            centreID = Util.GetString(HttpContext.Current.Session["CentreID"].ToString())
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public string ValidateExpiredBooking(string bookingID)
    {


        ExcuteCMD excuteCMD = new ExcuteCMD();

        var isAlreadyExpired = Util.GetInt(excuteCMD.ExecuteScalar("SELECT COUNT(*)IsExpired FROM  ot_booking ot WHERE ot.SurgeryDate<=CURRENT_DATE() AND  ot.SlotToTime<=TIME_FORMAT(NOW(),'%H:%i') AND ot.ID=@bookingID", new
        {
            bookingID = bookingID
        }));



        if (isAlreadyExpired > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "OT Timing Already Expired." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
    }

    [WebMethod(EnableSession = true)]
    public string GetPatientBookingDetailsForEdit(string bookingID, string patientID, string Fromdate, string Todate)
    {
        Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        StringBuilder sqlCMD = new StringBuilder();
       // sqlCMD.Append("SELECT ot.ID bookingID, ot.OTNumber, ot.PatientName, OT.PatientID , ot.Age, ot.Gender,ot.ContactNo , ot.Address, ot.DoctorID, CONCAT(dm.Title,' ',dm.Name)DoctorName, ot.SurgeryID, sm.Name SurgeryName, ot.OTID,om.Name OTName, DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, DATE_FORMAT(ot.SlotFromTime,'%h:%i %p')SlotFromTime, DATE_FORMAT(ot.SlotToTime,'%h:%i %p')SlotToTime, ot.PatientID, ot.IsCancel,ot.IsConfirm, ot.RescheduledRefID,IF(IFNULL(ot.PatientID,'')='',0,1)IsRegistredPatient FROM ot_booking  ot INNER JOIN  doctor_master  dm  ON dm.DoctorID=ot.DoctorID INNER JOIN f_surgery_master sm ON sm.Surgery_ID=ot.SurgeryID INNER JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 ");
          sqlCMD.Append("SELECT ot.ID bookingID, ot.OTNumber, ot.PatientName, OT.PatientID , ot.Age, ot.Gender,ot.ContactNo , ot.Address, ot.DoctorID, CONCAT(dm.Title,' ',dm.Name)DoctorName, ot.SurgeryID, im.TypeName SurgeryName, ot.OTID,om.Name OTName, DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, DATE_FORMAT(ot.SlotFromTime,'%h:%i %p')SlotFromTime, DATE_FORMAT(ot.SlotToTime,'%h:%i %p')SlotToTime, ot.PatientID, ot.IsCancel,ot.IsConfirm, ot.RescheduledRefID,IF(IFNULL(ot.PatientID,'')='',0,1)IsRegistredPatient FROM ot_booking  ot INNER JOIN  doctor_master  dm  ON dm.DoctorID=ot.DoctorID INNER JOIN f_itemmaster im  ON im.ItemID=ot.SurgeryID INNER JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 ");

        if (!string.IsNullOrEmpty(bookingID))
            sqlCMD.Append(" and ot.ID=@bookingID");
        else if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and ot.PatientID=@patientID");
         
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            bookingID = bookingID,
            patientID = patientID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


}