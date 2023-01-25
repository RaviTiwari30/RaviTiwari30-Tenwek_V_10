using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;
using System.Text;

public partial class SurgerySafetyCheckList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TransactionID.Text = Request.QueryString["TransactionID"].ToString();
            PatientId.Text = Request.QueryString["PatientId"].ToString();
            App_ID.Text = Request.QueryString["App_ID"].ToString();
            OTBookingID.Text = Request.QueryString["OTBookingID"].ToString();
            OTNumber.Text = Request.QueryString["OTNumber"].ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveSurgerySafety(Surgery_Safety SurgerySafetyDetails)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        SurgerySafetyDetails.Center_id = Util.GetInt(HttpContext.Current.Session["CentreID"]);
        SurgerySafetyDetails.Entry_by = HttpContext.Current.Session["ID"].ToString();
        try
        {
            var sqlcmd = "INSERT INTO Surgery_Safety_Check(PatientID,TransactionID,Appointment_ID,OTBOOKING_ID,PREOP_AREA_BEFORE,IS_PatientIDEN,ANY_ANESTHESIA,ANESTHESIA_SAFETY,RISK_BLOOD,TWO_IV,BLOOD_PRODUCTS,IN_CASE_OF,TIME_PATIENT_WHEELED,ANESTHETIST,DOSE_EVERYONE,WHAT_IS_PATIENT,PROCEDURE_NAME,IS_THE_CORRECT,EXPECTED_DURATION,DISCUSS_IF,IMPLANTS_OR,IS_ESSENTIAL,ANTIBIOTIC,ANTIBIOTIC_DRUG,ADMINISTRATION_TIME,IS_ANYTHING_UNIQUE,ANYTHING_VALUE,HAS_STERILITY,INCISION_TIME,TO_CIRCULATING_NURSE,IS_INSTRUMENT,INSTRUMENT_VAL,IS_ACTUALPROCE,ACTUALPROCE_VAL,IS_SPECIMEN,BLOOD_LOSS,COMPLICATION,COMPLICATION_VAl,IS_ANYSPECIAL,ANYSPECIAL_val,TIME_WHEELED_OUT,SO_CIRCULATING_NURSE,Center_ID,Entry_by,Entry_Date,DoctorID,Anesthetist_In_Charge, HGB, PLT, Na, K, Cr, TOther,TO_CIRCULATING_NURSE_VALUE,SO_CIRCULATING_NURSE_VALUE)"
                        + "VALUES(@PatientID,@TransactionID,@Appointment_ID,@OTBOOKING_ID,@PREOP_AREA_BEFORE,@IS_PatientIDEN,@ANY_ANESTHESIA,@ANESTHESIA_SAFETY,@RISK_BLOOD,@TWO_IV,@BLOOD_PRODUCTS,@IN_CASE_OF,@TIME_PATIENT_WHEELED,@ANESTHETIST,@DOSE_EVERYONE,@WHAT_IS_PATIENT,@PROCEDURE_NAME,@IS_THE_CORRECT,@EXPECTED_DURATION,@DISCUSS_IF,@IMPLANTS_OR,@IS_ESSENTIAL,@ANTIBIOTIC,@ANTIBIOTIC_DRUG,@ADMINISTRATION_TIME,@IS_ANYTHING_UNIQUE,@ANYTHING_VALUE,@HAS_STERILITY,@INCISION_TIME,@TO_CIRCULATING_NURSE,@IS_INSTRUMENT,@INSTRUMENT_VAL,@IS_ACTUALPROCE,@ACTUALPROCE_VAL,@IS_SPECIMEN,@BLOOD_LOSS,@COMPLICATION,@COMPLICATION_VAl,@IS_ANYSPECIAL,@ANYSPECIAL_val,@TIME_WHEELED_OUT,@SO_CIRCULATING_NURSE,@Center_ID,@Entry_by,NOW(),@DoctorID,@Anesthetist_In_Charge,@HGB,@PLT,@Na,@K,@Cr,@TOther,@TO_CIRCULATING_NURSE_VALUE,@SO_CIRCULATING_NURSE_VALUE);  SELECT @@identity;";
            int SSCID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, SurgerySafetyDetails));

            tnx.Commit();
            if (SSCID > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Not Save ??" });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
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

    public static string getSurgerySafety(string TransactionID, string PatientId)
    {

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
               SELECT ssc.sscid,DATE_FORMAT(ssc.Entry_date,'%d-%b-%y %r') Entry_date,CONCAT(pm.title,' ',pm.pname) patientname,
               CONCAT(em.title,' ',em.name) Entry_by FROM Surgery_Safety_Check  ssc 
               INNER JOIN patient_master pm ON ssc.PatientID=pm.PatientID 
               INNER JOIN employee_master em ON em.EmployeeID=ssc.entry_by 
               WHERE ssc.PatientID='" + PatientId + "' AND ssc.TransactionID='" + TransactionID + "' AND ssc.Is_active='1'  ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string remove(string SSCID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string user = HttpContext.Current.Session["ID"].ToString();
        try
        {
            string sqlcmd = " update Surgery_Safety_Check set Is_active=0,Remove_by='" + user + "',Remove_date=now()  where SSCID='" + SSCID + "'";
            excuteCMD.DML(tnx, sqlcmd, CommandType.Text);

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Remove Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    [WebMethod]
    public static string EditSurgerySafety(string SSCID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(@"
                    SELECT PREOP_AREA_BEFORE,IS_PatientIDEN,ANY_ANESTHESIA,ANESTHESIA_SAFETY,RISK_BLOOD,TWO_IV,BLOOD_PRODUCTS,IN_CASE_OF,
                 IFNULL(DATE_FORMAT(IF(TIME_PATIENT_WHEELED='00:00:00','',TIME_PATIENT_WHEELED),'%h:%i %p'),'') TIME_PATIENT_WHEELED,ANESTHETIST,DOSE_EVERYONE,WHAT_IS_PATIENT,PROCEDURE_NAME,IS_THE_CORRECT,EXPECTED_DURATION,DISCUSS_IF,
                    IMPLANTS_OR,IS_ESSENTIAL,ANTIBIOTIC,ANTIBIOTIC_DRUG,IFNULL(DATE_FORMAT(IF(ADMINISTRATION_TIME='00:00:00','',ADMINISTRATION_TIME),'%h:%i %p'),'') ADMINISTRATION_TIME,IS_ANYTHING_UNIQUE,ANYTHING_VALUE,HAS_STERILITY,
                  IFNULL(DATE_FORMAT(IF(INCISION_TIME='00:00:00','',INCISION_TIME),'%h:%i %p'),'')   INCISION_TIME,TO_CIRCULATING_NURSE,TO_CIRCULATING_NURSE_VALUE,IS_INSTRUMENT,INSTRUMENT_VAL,IS_ACTUALPROCE,ACTUALPROCE_VAL,IS_SPECIMEN,BLOOD_LOSS,
                    COMPLICATION,COMPLICATION_VAl,IS_ANYSPECIAL,ANYSPECIAL_val, IFNULL(DATE_FORMAT(IF(TIME_WHEELED_OUT='00:00:00','',TIME_WHEELED_OUT),'%h:%i %p'),'')TIME_WHEELED_OUT,SO_CIRCULATING_NURSE,SO_CIRCULATING_NURSE_VALUE,
                  DoctorID,Anesthetist_In_Charge,OTBOOKING_ID,HGB,PLT,Na,K,Cr,TOther  FROM Surgery_Safety_Check WHERE is_active=1 AND sscid='" + SSCID + "' ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string UpdateSurgerySafety(Surgery_Safety SurgerySafetyDetails, string SSCID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            SurgerySafetyDetails.Center_id = Util.GetInt(HttpContext.Current.Session["CentreID"]);
            SurgerySafetyDetails.update_by = HttpContext.Current.Session["ID"].ToString();


            var sqlcmd = @" update Surgery_Safety_Check set
                            PREOP_AREA_BEFORE=@PREOP_AREA_BEFORE,IS_PatientIDEN=@IS_PatientIDEN,ANY_ANESTHESIA=@ANY_ANESTHESIA,ANESTHESIA_SAFETY=@ANESTHESIA_SAFETY,
                            RISK_BLOOD=@RISK_BLOOD,TWO_IV=@TWO_IV,BLOOD_PRODUCTS=@BLOOD_PRODUCTS,IN_CASE_OF=@IN_CASE_OF,OTBOOKING_ID=@OTBOOKING_ID,
                            TIME_PATIENT_WHEELED=@TIME_PATIENT_WHEELED,ANESTHETIST=@ANESTHETIST,DOSE_EVERYONE=@DOSE_EVERYONE,WHAT_IS_PATIENT=@WHAT_IS_PATIENT,
                            PROCEDURE_NAME=@PROCEDURE_NAME,IS_THE_CORRECT=@IS_THE_CORRECT,EXPECTED_DURATION=@EXPECTED_DURATION,DISCUSS_IF=@DISCUSS_IF,
                            IMPLANTS_OR=@IMPLANTS_OR,IS_ESSENTIAL=@IS_ESSENTIAL,ANTIBIOTIC=@ANTIBIOTIC,ANTIBIOTIC_DRUG=@ANTIBIOTIC_DRUG,ADMINISTRATION_TIME=@ADMINISTRATION_TIME,
                            IS_ANYTHING_UNIQUE=@IS_ANYTHING_UNIQUE,ANYTHING_VALUE=@ANYTHING_VALUE,HAS_STERILITY=@HAS_STERILITY,
                            INCISION_TIME=@INCISION_TIME,TO_CIRCULATING_NURSE=@TO_CIRCULATING_NURSE,TO_CIRCULATING_NURSE_VALUE=@TO_CIRCULATING_NURSE_VALUE,IS_INSTRUMENT=@IS_INSTRUMENT,INSTRUMENT_VAL=@INSTRUMENT_VAL,
                            IS_ACTUALPROCE=@IS_ACTUALPROCE,ACTUALPROCE_VAL=@ACTUALPROCE_VAL,IS_SPECIMEN=@IS_SPECIMEN,BLOOD_LOSS=@BLOOD_LOSS,
                            COMPLICATION=@COMPLICATION,COMPLICATION_VAl=@COMPLICATION_VAl,IS_ANYSPECIAL=@IS_ANYSPECIAL,ANYSPECIAL_val=@ANYSPECIAL_val,
                            TIME_WHEELED_OUT=@TIME_WHEELED_OUT,SO_CIRCULATING_NURSE=@SO_CIRCULATING_NURSE,SO_CIRCULATING_NURSE_VALUE=@SO_CIRCULATING_NURSE_VALUE,update_date=now(),update_by=@update_by,
                            DoctorID=@DoctorID,Anesthetist_In_Charge=@Anesthetist_In_Charge,HGB=@HGB,PLT=@PLT,Na=@Na,K=@K,Cr=@Cr,TOther=@TOther where SSCID='" + SSCID + "' ";

            Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, SurgerySafetyDetails));

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Updated Sucessfully " });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod(EnableSession = true)]
    public static string PrintSurgerySafety(string SSCID)
    {
        DataSet ds = new DataSet();
        DataTable dt = StockReports.GetDataTable(@"
             SELECT '' AS Unit,ssc.TransactionID,CONCAT(pm.title,' ',pm.pname) patientname,
             pm.Age,pm.Gender,ssc.PatientID,ssc.OTBOOKING_ID,ssc.PREOP_AREA_BEFORE,ssc.IS_PatientIDEN,ssc.ANY_ANESTHESIA,ssc.ANESTHESIA_SAFETY,ssc.RISK_BLOOD,
             ssc.TWO_IV,ssc.BLOOD_PRODUCTS,ssc.IN_CASE_OF,
             IFNULL(DATE_FORMAT(IF(ssc.TIME_PATIENT_WHEELED='00:00:00','',ssc.TIME_PATIENT_WHEELED),'%h:%i %p'),'') TIME_PATIENT_WHEELED,ssc.ANESTHETIST,ssc.DOSE_EVERYONE,ssc.WHAT_IS_PATIENT,ssc.PROCEDURE_NAME,ssc.IS_THE_CORRECT,ssc.EXPECTED_DURATION,ssc.DISCUSS_IF,
             ssc.IMPLANTS_OR,ssc.IS_ESSENTIAL,ssc.ANTIBIOTIC,ssc.ANTIBIOTIC_DRUG,IFNULL(DATE_FORMAT(IF(ssc.ADMINISTRATION_TIME='00:00:00','',ssc.ADMINISTRATION_TIME),'%h:%i %p'),'') ADMINISTRATION_TIME,ssc.IS_ANYTHING_UNIQUE,ssc.ANYTHING_VALUE,ssc.HAS_STERILITY,
             IFNULL(DATE_FORMAT(IF(ssc.INCISION_TIME='00:00:00','',ssc.INCISION_TIME),'%h:%i %p'),'')   INCISION_TIME,ssc.TO_CIRCULATING_NURSE,ssc.IS_INSTRUMENT,ssc.INSTRUMENT_VAL,ssc.IS_ACTUALPROCE,ssc.ACTUALPROCE_VAL,ssc.IS_SPECIMEN,ssc.BLOOD_LOSS,
             ssc.COMPLICATION,ssc.COMPLICATION_VAl,ssc.IS_ANYSPECIAL,ssc.ANYSPECIAL_val, IFNULL(DATE_FORMAT(IF(ssc.TIME_WHEELED_OUT='00:00:00','',ssc.TIME_WHEELED_OUT),'%h:%i %p'),'')TIME_WHEELED_OUT,ssc.SO_CIRCULATING_NURSE,
             ssc.DoctorID,ssc.Anesthetist_In_Charge,ssc.entry_by,DATE_FORMAT(ssc.entry_date,'%d-%b-%y') entry_date,
             
             (SELECT IFNULL(staffname,' ') staffname FROM ot_staff_master  WHERE id=ssc.ANESTHETIST)   AS ANESTHETIST,
             (SELECT IFNULL(staffname,' ') staffname FROM ot_staff_master  WHERE id=ssc.Anesthetist_In_Charge) AS Anesthetist_In_Charge,
             (SELECT IFNULL(staffname,' ') staffname FROM ot_staff_master  WHERE id=ssc.TO_CIRCULATING_NURSE) AS TO_CIRCULATING_NURSE,
             (SELECT IFNULL(staffname,' ') staffname FROM ot_staff_master  WHERE id=ssc.SO_CIRCULATING_NURSE) AS SO_CIRCULATING_NURSE,
             (SELECT IFNULL (CONCAT (title,' ',NAME),'') surgon FROM doctor_master WHERE DoctorID=ssc.DoctorID) AS surgon,
             (SELECT OTNumber FROM ot_booking where id=ssc.OTBOOKING_ID) as O_R_No,
             (SELECT IFNULL(DATE_FORMAT(dateofadmit,'%d-%b-%y'),'') doa FROM  patient_medical_history where TransactionID=ssc.TransactionID) as DOA
             FROM Surgery_Safety_Check ssc
             INNER JOIN patient_master pm ON ssc.PatientID=pm.PatientID
             WHERE ssc.sscid='" + SSCID + "' AND ssc.is_active=1    ");
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Surgery_Safety_Check";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";

       // ds.WriteXmlSchema(@"E:\Surgery_Safety_Check.xml");
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "SurgerySafetyCheckList";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
    }


    [WebMethod]
    public static string BindAnesthetist()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(@"  SELECT s.`ID` AS DoctorID,s.`StaffName` AS NAME FROM ot_staff_master s 
                       WHERE s.`IsActive`=1 AND s.`StaffTypeID`=3 ORDER BY s.`StaffName` ");

        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindCirculatingNurse()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(@"  SELECT s.`ID` AS DoctorID,s.`StaffName` AS NAME FROM ot_staff_master s 
                       WHERE s.`IsActive`=1 AND s.`StaffTypeID`=5 ORDER BY s.`StaffName` ");

        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    public class Surgery_Safety
    {
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public int Appointment_ID { get; set; }
        public int OTBOOKING_ID { get; set; }
        public string PREOP_AREA_BEFORE { get; set; }
        public string IS_PatientIDEN { get; set; }
        public string ANY_ANESTHESIA { get; set; }
        public string ANESTHESIA_SAFETY { get; set; }
        public string RISK_BLOOD { get; set; }
        public string TWO_IV { get; set; }
        public string BLOOD_PRODUCTS { get; set; }
        public string IN_CASE_OF { get; set; }
        public System.DateTime TIME_PATIENT_WHEELED { get; set; }
        public int ANESTHETIST { get; set; }

        public string DOSE_EVERYONE { get; set; }
        public string WHAT_IS_PATIENT { get; set; }
        public string PROCEDURE_NAME { get; set; }
        public string IS_THE_CORRECT { get; set; }
        public string EXPECTED_DURATION { get; set; }
        public string DISCUSS_IF { get; set; }
        public string IMPLANTS_OR { get; set; }
        public string IS_ESSENTIAL { get; set; }
        public string ANTIBIOTIC { get; set; }
        public string ANTIBIOTIC_DRUG { get; set; }
        public System.DateTime ADMINISTRATION_TIME { get; set; }
        public int IS_ANYTHING_UNIQUE { get; set; }
        public string ANYTHING_VALUE { get; set; }
        public string HAS_STERILITY { get; set; }
        public System.DateTime INCISION_TIME { get; set; }
        public int TO_CIRCULATING_NURSE { get; set; }
        public string  TO_CIRCULATING_NURSE_VALUE { get; set; }

        public int IS_INSTRUMENT { get; set; }
        public string INSTRUMENT_VAL { get; set; }
        public int IS_ACTUALPROCE { get; set; }
        public string ACTUALPROCE_VAL { get; set; }
        public int IS_SPECIMEN { get; set; }
        public decimal BLOOD_LOSS { get; set; }
        public string COMPLICATION { get; set; }
        public string COMPLICATION_VAl { get; set; }
        public int IS_ANYSPECIAL { get; set; }
        public string ANYSPECIAL_val { get; set; }
        public System.DateTime TIME_WHEELED_OUT { get; set; }
        public int SO_CIRCULATING_NURSE { get; set; }
        public string  SO_CIRCULATING_NURSE_VALUE { get; set; }
        public string DoctorID { get; set; }
        public int Anesthetist_In_Charge { get; set; }

        public int Is_active { get; set; }
        public System.DateTime update_date { get; set; }
        public string Entry_by { get; set; }
        public System.DateTime Entry_Date { get; set; }
        public string update_by { get; set; }
        public string Remove_by { get; set; }
        public System.DateTime Remove_date { get; set; }
        public int Center_id { get; set; }

        public string HGB { get; set; }
        public string PLT { get; set; }
        public string Na { get; set; }
        public string K { get; set; }
        public string Cr { get; set; }
        public string TOther { get; set; }

    }
}
