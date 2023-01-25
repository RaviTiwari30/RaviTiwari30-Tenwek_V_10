using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using MySql.Data.MySqlClient;

public partial class Design_IPD_PatientSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR SPECIALIST")
            {
                string str = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de INNER JOIN f_center_doctor d ON d.DoctorID=de.DoctorID WHERE d.CentreID="+ Session["CentreID"].ToString() +" AND Employeeid='" + Convert.ToString(Session["ID"]) + "'");
                if (!string.IsNullOrEmpty(str))
                {
                    ViewState["DoctorID"] = Util.GetString(str);
                }
                else
                {
                    ViewState["DoctorID"] = "";
                    lblMsg.Text = "You are not authorize for this center.";
                }
            }
            else
                ViewState["DoctorID"] = "1";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindFloor()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT FloorID AS ID,Role_ID,fm.Name AS NAME FROM f_roomtype_role  rm INNER JOIN Floor_master fm ON fm.ID=rm.FloorID WHERE Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND fm.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' GROUP BY FloorID,Role_ID ORDER BY fm.SequenceNo+0 ");
        if (dt.Rows.Count < 1)
            dt = AllLoadData_IPD.loadFloor(Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string BindRoomType(string FloorID, int isAttenderRoom)
    {
        DataTable dtData = new DataTable();
        if (FloorID == "0")
        {
            if ((isAttenderRoom == 0) || (isAttenderRoom == 1))
                dtData = AllLoadData_IPD.LoadCaseType().AsEnumerable().Where(r => r.Field<int>("isAttenderRoom") == isAttenderRoom).AsDataView().ToTable();
            else
                dtData = AllLoadData_IPD.LoadCaseType();
        }
        else
        {
            dtData = StockReports.GetDataTable("SELECT DISTINCT(ich.IPDCaseTypeID)IPDCaseTypeID,ich.Name,Role_ID FROM f_roomtype_role rt INNER JOIN ipd_case_type_master ich ON ich.IPDCaseTypeID=rt.IPDCaseTypeID  where Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' And FloorID='" + FloorID + "' Order by Name");
            if (dtData.Rows.Count < 1)
                dtData = AllLoadData_IPD.LoadCaseType();
        }
        if (dtData.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string PatientSearch(string MRNo, string PName, string Department, string Floor, string AgeFrom, string ddlAgeFrom, string AgeTo, string ddlAgeTo, string RoomType, string IPDNo, string DoctorID, string Panel, string ParentPanel, string FromDate, string ToDate, string AdmitDischarge, string Type, string id, int IsPatientReceived, int IsownPrescription=0)
    {
        string FromAdmitDate = "", LabNo = "", ToAdmitDate = "", VisitDateFrom = "", VisitDateTo = "", DischargeDateFrom = "", DischargeDateTo = "";
        string TransactionId = "", status = "";
        string PAgeFrom = "", PAgeTo = "", FromIntimationDate = "", ToIntimationDate = "", UserType = "", UserID = "", NewDid="";


        if (IPDNo != "")
            TransactionId =  StockReports.getTransactionIDbyTransNo(IPDNo.Trim());//"ISHHI" +
        if (AgeFrom != "")
            PAgeFrom = AgeFrom.Trim() + " " + ddlAgeFrom.Trim();
        if (AgeTo != "")
            PAgeTo = AgeTo.Trim() + " " + ddlAgeTo.Trim();
        if (AdmitDischarge.ToUpper() == "CAD")
        {
            status = "IN";
            FromAdmitDate = "";
            ToAdmitDate = "";
        }
        else if (AdmitDischarge.ToUpper() == "AD")
        {
            status = "IN";
            FromAdmitDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            ToAdmitDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        }
        else if (AdmitDischarge.ToUpper() == "ID" || AdmitDischarge.ToUpper() == "PC")
        {
            status = "IN";
            FromIntimationDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            ToIntimationDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        }
        else
        {
            status = "OUT";
            DischargeDateFrom = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            DischargeDateTo = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        }

        UserID = HttpContext.Current.Session["ID"].ToString();
        UserType = StockReports.ExecuteScalar("SELECT IF(COUNT(*)>0,'NURSE','') FROM employee_master em INNER JOIN patient_nurse_assignment nas ON nas.NurseID=em.EmployeeID " +
                    " WHERE em.employeeId='" + UserID + "' AND nas.Status=0");

        if (IsownPrescription!=0)
        {
            string DRID = Util.GetString(StockReports.ExecuteScalar("SELECT de.DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' limit 1 "));

            string DId ="'"+ DRID + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString())+"'";
            NewDid = AllLoadData_IPD.GetAllTeamId(DId);

        }
       

        DataTable dt = AllLoadData_IPD.SearchPatient(MRNo, PName, TransactionId, RoomType, DoctorID, Panel, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status, LabNo, Department, PAgeFrom, PAgeTo, ParentPanel, Floor, FromIntimationDate, ToIntimationDate, AdmitDischarge, Type, IsPatientReceived, UserType, UserID, 0, NewDid);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("LoginType");
            dc.DefaultValue = HttpContext.Current.Session["RoleID"].ToString();
            dt.Columns.Add(dc);
            DataView dv = dt.DefaultView;
            if (id != "0")
            {
                if (id == "1")
                {
                    dv.RowFilter = "amtpaid='1' AND TransactionID <> ''";
                }
                else if (id == "2")
                {
                    dv.RowFilter = "amtpaid='2' AND TransactionID <> ''";
                }
                else if (id == "3")
                {
                    dv.RowFilter = "amtpaid='0' AND TransactionID <> ''";
                }
            }
            else
            {
               // dv.RowFilter = "TransactionID <> ''";
                dv.RowFilter = "TransactionID <> 0";
            }
            if (dv.ToTable().Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
            else
                return "";
        }
        else
            return "";
    }



    [WebMethod(EnableSession = true)]
    public static string PrintSticker(string patientID)
    {
        try
        {

            string PatientID = patientID;
            string sb = "SELECT   TransNo,CONCAT(t2.Title,' ',PFirstName,' ',PLastName)PName,t2.PatientID AS Patient_ID,t2.Gender,CONCAT(t2.House_No,'',t2.Street_Name,'',t2.Locality,'',t2.City,'',t2.Pincode)Address,t2.Age,TransNo As Transaction_ID,Concat(dm.Title,' ',dm.Name) AS DName,ictm1.Name AS RName,fpm.Company_Name,ictm2.Name AS BillingCategory,t2.DateOfAdmit as AdmitDate,DATE_FORMAT(t2.DOB,'%d-%b-%Y')DOB,CONCAT(t2.DateOfDischarge,' ',t2.TimeOfDischarge)DischargeDate,t2.Status,CONCAT(t2.Age,' / ',t2.Gender)AgeSex, " +
                        "CONCAT(rm.Name,'/',rm.Floor)RoomName,rm.Room_No,t2.IPDCaseTypeID AS IPDCaseType_ID,fpm.ReferenceCode,t2.PanelID FROM (SELECT t1.*,pm.DOB,pm.ID,pm.Title,PFirstName,PLastName,PName,Gender,House_No,Street_Name,Locality,City,Pincode,Age,pm.PatientID AS Patient_ID     FROM (SELECT pip.PatientID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,pip.RoomID,        pip.TransactionID,pip.Status,pmh.TransNo,DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')DateOfAdmit,        TIME_FORMAT(pmh.TimeOfAdmit,'%l: %i %p')" +
                        "TimeOfAdmit,pmh.DoctorID,pmh.PanelID,        IF(pmh.DateOfDischarge='0001-01-01','-',DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%y'))DateOfDischarge, " +
                        "IF(pmh.TimeOfDischarge='00:00:00','',TIME_FORMAT(pmh.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge    FROM     (SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,        pip1.IPDCaseTypeID_Bill,pip1.RoomID,pip1.TransactionID,pip1.Status " +
                        " FROM patient_ipd_profile pip1 INNER JOIN         (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID " +
                        " FROM patient_ipd_profile WHERE STATUS = 'IN' GROUP BY TransactionID         )pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID     )pip  " +  //INNER JOIN ipd_case_history ich ON pip.TransactionID = ich.TransactionID 
                        "    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = pip.TransactionID AND pmh.Type='IPD' WHERE pmh.status='IN'  ) t1 INNER JOIN  patient_master pm  ON t1.PatientID = pm.PatientID WHERE pm.PatientID='" + PatientID + "' ) " +
                        "t2 INNER JOIN f_panel_master fpm ON fpm.PanelID = t2.PanelID INNER JOIN doctor_master dm ON t2.DoctorID = dm.DoctorID  INNER JOIN ipd_case_type_master ictm1 ON ictm1.IPDCaseTypeID = t2.IPDCaseTypeID INNER JOIN ipd_case_type_master ictm2 ON ictm2.IPDCaseTypeID = t2.IPDCaseTypeID_Bill " +
                        "INNER JOIN room_master rm ON rm.RoomId = t2.roomid ORDER BY t2.ID DESC, t2.PName, t2.PatientID ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "Sticker";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "../Common/Commonreport.aspx"});

        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator",message=ex.Message });
        }
    }

    [WebMethod(EnableSession = true)]
    public static string ViewRadiologyNotification(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT rn.ID,ifnull(rn.Remarks,'')Remarks, im.name as Investigation,DATE_FORMAT(rn.NotificationDate,'%d-%b-%Y')NotificationDate,TIME_FORMAT(rn.NotificationTime,'%I:%i %p')NotificationTime,CONCAT(em.Title,'',em.Name)EntryBy,ifnull(rn.Reply,'')Reply,CONCAT(eml.Title,' ',eml.Name) replyBy ,DATE_FORMAT(rn.ReplyDateTime,'%d-%b-%Y %I:%i %p')ReplyDateTime FROM radiology_accepatance_notification rn ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON rn.TestID=plo.Test_ID INNER JOIN investigation_master im ON plo.Investigation_ID=im.Investigation_Id INNER JOIN employee_master em ON rn.EntryBy=em.EmployeeID ");
        sb.Append(" left JOIN employee_master eml ON rn.ReplyBy=eml.EmployeeID  ");
        sb.Append(" WHERE rn.TransactionID='" + TransactionID + "' order by rn.IsActive ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }





    [WebMethod(EnableSession = true)]
    public static string SaveNotificationReply(string reply, string notificationID)
    {

        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var userID = HttpContext.Current.Session["ID"].ToString();

            excuteCMD.DML("UPDATE radiology_accepatance_notification s SET s.Reply=@reply ,s.ReplyBy=@replyBy,s.ReplyDateTime=NOW() WHERE s.ID=@id", CommandType.Text, new
            {

                replyBy = userID,
                reply = reply,
                id = notificationID
            });


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }



    }

    [WebMethod]
    public static string bindAvailableRooms(string ipdCaseTypeID)
    {
        DataTable dtAvailRooms = RoomBilling.GetAvailRooms(ipdCaseTypeID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtAvailRooms);
    }

    [WebMethod(EnableSession = true)]
    public static string recieveandShiftPatient(string TID, string scheduleChargeID, string ipdCaseTypeID, string roomID, string panelID, string doctorID, string PID)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction Tnx = conn.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (roomID == "0")
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE patient_ipd_profile SET IsPatientReceived=1,PatReceivedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',PatReceivedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID='" + TID + "' and Status='IN'");

            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE patient_ipd_profile SET RoomID='" + roomID + "', IsPatientReceived=1,PatReceivedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',PatReceivedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID='" + TID + "' and Status='IN'");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE room_master SET IsRoomClean=2 WHERE RoomID='" + roomID + "' ");
                string PreviousRoom = StockReports.ExecuteScalar("SELECT RoomID FROM patient_ipd_profile WHERE STATUS='OUT' AND TransactionID='" + TID + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1 ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE RoomID='" + PreviousRoom + "' ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `patient_medical_history` pmh SET pmh.`CurrentRoomID`='" + roomID + "',pmh.`CurrentIPDCaseTypeID`='" + ipdCaseTypeID + "' WHERE pmh.`TransactionID`='"+TID+"' ");

            }

            Tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Received Successfully" });

        }

        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            Tnx.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }

}
