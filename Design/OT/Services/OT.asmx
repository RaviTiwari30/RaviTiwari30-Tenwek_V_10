<%@ WebService Language="C#" Class="OT" %>

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
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OT : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    public string SaveIPDAdmission(object getAnesthesiadetails)
    {
        return "";
    }

    public class Plan_of_Anesthesia
    {
        public int ANEID { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public int Appointment_ID { get; set; }
        public int OTBookingID { get; set; }
        public string Anaesthesiaplan { get; set; }
        public string Anaesthesiaplanallchecked { get; set; }
        public string ANAESPRESENT { get; set; }
        public string ANAESPATIENTAGREED { get; set; }
        public string Entry_by { get; set; }
        public System.DateTime Entry_date { get; set; }
        public string Is_active { get; set; }
        public System.DateTime update_date { get; set; }
        public string update_by { get; set; }


    }
    [WebMethod(EnableSession = true)]
    public string SaveAnesthesia(Plan_of_Anesthesia PlanofAnesthesia)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string center_id = HttpContext.Current.Session["CentreID"].ToString();
        try
        {
            PlanofAnesthesia.Entry_by = HttpContext.Current.Session["ID"].ToString();

            // PlanofAnesthesia.Appointment_ID
           
            var sqlcmd = "INSERT INTO Plan_of_Anesthesia(PatientID,TransactionID,Appointment_ID,OTBookingID,Anaesthesiaplan,Anaesthesiaplanallchecked,ANAESPRESENT,ANAESPATIENTAGREED,Entry_by,Entry_date,Is_active,Center_ID)"
                         + "VALUES(@PatientID,@TransactionID,@Appointment_ID,@OTBookingID,@Anaesthesiaplan,@Anaesthesiaplanallchecked,@ANAESPRESENT,@ANAESPATIENTAGREED,@Entry_by,NOW(),'1','" + center_id + "'); SELECT @@identity; ";
            int ANEID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, PlanofAnesthesia));
            if (ANEID > 0)
            {
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            }
            else {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Save !!" });
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

    public class Pac
    {
        public int PACID { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public int Appointment_ID { get; set; }
        public int OTBookingID { get; set; }
        public string SURGICAL_ANESTHETIC { get; set; }
        public string ANTIICIPATED_AIRWAY { get; set; }
        public string RESPIRATORY { get; set; }
        public string CARDIOVASCULAR { get; set; }
        public string RENAL_ENDOCRINE { get; set; }
        public string HEPATO_GASTROINTESTINAL { get; set; }
        public string NEURO_MUSCULOSKELETAL { get; set; }
        public string OTHERS { get; set; }
        public string PRESENT_MEDICATIONS { get; set; }
        public string Entry_by { get; set; }
        public System.DateTime Entry_date { get; set; }
        public string Is_active { get; set; }
        public System.DateTime update_date { get; set; }
        public string update_by { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public string SavePAC(Pac Pac)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string center_id = HttpContext.Current.Session["CentreID"].ToString();
        try
        {
            Pac.Entry_by = HttpContext.Current.Session["ID"].ToString();

            // PlanofAnesthesia.Appointment_ID
          
            var sqlcmd = "INSERT INTO OT_PAC(PatientID,TransactionID,Appointment_ID,OTBookingID,SURGICAL_ANESTHETIC,ANTIICIPATED_AIRWAY,RESPIRATORY,CARDIOVASCULAR,RENAL_ENDOCRINE,HEPATO_GASTROINTESTINAL,NEURO_MUSCULOSKELETAL,OTHERS,PRESENT_MEDICATIONS,Entry_by,Entry_date,Is_active,center_id)"
                         + "VALUES(@PatientID,@TransactionID,@Appointment_ID,@OTBookingID,@SURGICAL_ANESTHETIC,@ANTIICIPATED_AIRWAY,@RESPIRATORY,@CARDIOVASCULAR,@RENAL_ENDOCRINE,@HEPATO_GASTROINTESTINAL,@NEURO_MUSCULOSKELETAL,@OTHERS,@PRESENT_MEDICATIONS,@Entry_by,Now(),1,'" + center_id + "'); SELECT @@identity; ";
         int   PACID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, Pac));
         if (PACID > 0)
         {
             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
         }
         else
         {
             tnx.Rollback();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Save !!" });
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

    [WebMethod(EnableSession = true)]
    public string UpdatePAC(Pac Pac, string pacID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            Pac.Entry_by = HttpContext.Current.Session["ID"].ToString();

            // PlanofAnesthesia.Appointment_ID
            // string PACID = string.Empty;
            var sqlcmd = "UPDATE  OT_PAC SET PatientID=@PatientID,TransactionID=@TransactionID,Appointment_ID=@Appointment_ID,OTBookingID=@OTBookingID,SURGICAL_ANESTHETIC=@SURGICAL_ANESTHETIC,ANTIICIPATED_AIRWAY=@ANTIICIPATED_AIRWAY,RESPIRATORY=@RESPIRATORY,CARDIOVASCULAR=@CARDIOVASCULAR,RENAL_ENDOCRINE=@RENAL_ENDOCRINE,HEPATO_GASTROINTESTINAL=@HEPATO_GASTROINTESTINAL,NEURO_MUSCULOSKELETAL=@NEURO_MUSCULOSKELETAL,OTHERS=@OTHERS,PRESENT_MEDICATIONS=@PRESENT_MEDICATIONS,Update_by=@Entry_by,Update_date=NOW() where pacid='" + pacID + "'";

            Util.GetString(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, Pac));

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
    public string UPdateANE(Plan_of_Anesthesia PlanofAnesthesia, string AnID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            PlanofAnesthesia.Entry_by = HttpContext.Current.Session["ID"].ToString();

            // PlanofAnesthesia.Appointment_ID
            // string PACID = string.Empty;
            var sqlcmd = "UPDATE  Plan_of_Anesthesia SET PatientID=@PatientID,TransactionID=@TransactionID,Appointment_ID=@Appointment_ID,OTBookingID=@OTBookingID,Anaesthesiaplan=@Anaesthesiaplan,Anaesthesiaplanallchecked=@Anaesthesiaplanallchecked,ANAESPRESENT=@ANAESPRESENT,ANAESPATIENTAGREED=@ANAESPATIENTAGREED,Update_by=@Entry_by,Update_date=NOW() where ANEID='" + AnID + "'";

            Util.GetString(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, PlanofAnesthesia));

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

    public class pre_op_instruction
    {
        public int PREID { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public int Appointment_ID { get; set; }
        public int OTBookingID { get; set; }
        public string MALAMPATTI_SCORE { get; set; }
        public string MOUTH_OPENING_ADEQATE { get; set; }
        public string TEETH { get; set; }
        public string DENTURES { get; set; }
        public string T_M_DISTANCE { get; set; }
        public string NCEK_MOVEMENTS { get; set; }
        public string ASA_CLASS { get; set; }
        public string IS_NPO_FROM { get; set; }
        public string PRESENT_MEDICATIONS { get; set; }
        public System.DateTime NPO_time { get; set; }
        public System.DateTime NPO_date { get; set; }
        public string IS_APPLY_EMLA { get; set; }
        public string IS_REMOVE_ALL { get; set; }
        public string IS_SHIFT_OT { get; set; }
        public string IS_NEBULISATION { get; set; }
        public string NEBULISATION { get; set; }
        public System.DateTime NEBULISATION_time { get; set; }
        public System.DateTime NEBULISATION_date { get; set; }
        public string IS_patient_can { get; set; }
        public string IS_STOP_ORAL { get; set; }
        public System.DateTime STOP_ORAL_from_date { get; set; }
        public System.DateTime STOP_ORAL_time { get; set; }
        public System.DateTime STOP_ORAL_from_on { get; set; }
        public string Other { get; set; }
        public string Entry_by { get; set; }
        public System.DateTime Entry_date { get; set; }
        public string Is_active { get; set; }
        public System.DateTime update_date { get; set; }
        public string update_by { get; set; }
        public string ALLERGIES { get; set; }
 

    }

    public class LabItems
    {
        public string itemID { get; set; }
        public string tabname { get; set; }
        public string tabdose { get; set; }
        public System.DateTime time { get; set; }
        public System.DateTime date { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string Updatepreopinstruction(pre_op_instruction PREOPInstructionsdetails, List<LabItems> labItems, string preid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string center_id = HttpContext.Current.Session["CentreID"].ToString();
        try
        {
            PREOPInstructionsdetails.Entry_by = HttpContext.Current.Session["ID"].ToString();
            string PREID = string.Empty;
            var sqlcmd = @"Update pre_op_instruction set PatientID=@PatientID,TransactionID=@TransactionID,Appointment_ID=@Appointment_ID,OTBookingID=@OTBookingID,MALAMPATTI_SCORE=@MALAMPATTI_SCORE,
                         MOUTH_OPENING_ADEQATE=@MOUTH_OPENING_ADEQATE,TEETH=@TEETH,DENTURES=@DENTURES,"
            + @"T_M_DISTANCE=@T_M_DISTANCE,NCEK_MOVEMENTS=@NCEK_MOVEMENTS,ASA_CLASS=@ASA_CLASS,IS_NPO_FROM=@IS_NPO_FROM,NPO_time=@NPO_time,NPO_date=@NPO_date,IS_APPLY_EMLA=@IS_APPLY_EMLA,
               IS_REMOVE_ALL=@IS_REMOVE_ALL,IS_SHIFT_OT=@IS_SHIFT_OT,IS_NEBULISATION=@IS_NEBULISATION,NEBULISATION=@NEBULISATION,NEBULISATION_time=@NEBULISATION_time,"
            + "NEBULISATION_date=@NEBULISATION_date,IS_patient_can=@IS_patient_can,IS_STOP_ORAL=@IS_STOP_ORAL,STOP_ORAL_from_date=@STOP_ORAL_from_date,STOP_ORAL_time=@STOP_ORAL_time,STOP_ORAL_from_on=@STOP_ORAL_from_on,Other=@Other,update_by=@Entry_by,update_date=now(),Is_active='1',ALLERGIES=@ALLERGIES where preid='" + preid + "'";

            excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, PREOPInstructionsdetails);


            sqlcmd = " Delete from pre_op_instruction_medicine where PREID='" + preid + "'";

            excuteCMD.DML(tnx, sqlcmd, CommandType.Text);

            for (int i = 0; i < labItems.Count; i++)
            {
                string sqlCMD = "INSERT INTO pre_op_instruction_medicine(PREID,medicine_id,medicine_name,medicine_dose,medicine_time ,medicine_date,update_by,update_date,Is_active,center_id) "
               + " VALUES (@PREID,@medicine_id,@medicine_name,@medicine_dose,@medicine_time,@medicine_date,@Entry_by,now(),1,'" + center_id + "');SELECT @@identity; ";

                var PREMEDID = excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                {
                    PREID = preid,
                    medicine_id = labItems[i].itemID,
                    medicine_name = labItems[i].tabname,
                    medicine_dose = labItems[i].tabdose,
                    medicine_time = labItems[i].time,
                    medicine_date = labItems[i].date,
                    Entry_by = HttpContext.Current.Session["ID"].ToString()

                });
            }



            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, PREID = PREID, response = "Record Updated Successfully " });
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
    public string Savepreopinstruction(pre_op_instruction PREOPInstructionsdetails, List<LabItems> labItems)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string center_id = HttpContext.Current.Session["CentreID"].ToString();
        try
        {
            PREOPInstructionsdetails.Entry_by = HttpContext.Current.Session["ID"].ToString();
           
            var sqlcmd = "INSERT INTO pre_op_instruction(PatientID,TransactionID,Appointment_ID,OTBookingID,MALAMPATTI_SCORE,MOUTH_OPENING_ADEQATE,TEETH,DENTURES,"
            + "T_M_DISTANCE,NCEK_MOVEMENTS,ASA_CLASS,IS_NPO_FROM,NPO_time,NPO_date,IS_APPLY_EMLA,IS_REMOVE_ALL,IS_SHIFT_OT,IS_NEBULISATION,NEBULISATION,NEBULISATION_time,"
            + "NEBULISATION_date,IS_patient_can,IS_STOP_ORAL,STOP_ORAL_from_date,STOP_ORAL_time,STOP_ORAL_from_on,Other,Entry_by,Entry_date,Is_active,ALLERGIES,center_id)"

            + "VALUES(@PatientID,@TransactionID,@Appointment_ID,@OTBookingID,@MALAMPATTI_SCORE,@MOUTH_OPENING_ADEQATE,@TEETH,@DENTURES,"
            + "@T_M_DISTANCE,@NCEK_MOVEMENTS,@ASA_CLASS,@IS_NPO_FROM,@NPO_time,@NPO_date,@IS_APPLY_EMLA,@IS_REMOVE_ALL,@IS_SHIFT_OT,@IS_NEBULISATION,@NEBULISATION,@NEBULISATION_time,"
            + "@NEBULISATION_date,@IS_patient_can,@IS_STOP_ORAL,@STOP_ORAL_from_date,@STOP_ORAL_time,@STOP_ORAL_from_on,@Other,@Entry_by,now(),1,@ALLERGIES,'" + center_id + "'); SELECT @@identity; ";

          int  PREID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, PREOPInstructionsdetails));

            for (int i = 0; i < labItems.Count; i++)
            {
                string sqlCMD = "INSERT INTO pre_op_instruction_medicine(PREID,medicine_id,medicine_name,medicine_dose,medicine_time ,medicine_date,Entry_by,Entry_date,Is_active,center_id) "
               + " VALUES (@PREID,@medicine_id,@medicine_name,@medicine_dose,@medicine_time,@medicine_date,@Entry_by,now(),1,'" + center_id + "');SELECT @@identity; ";

                var PREMEDID = excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                {
                    PREID = PREID,
                    medicine_id = labItems[i].itemID,
                    medicine_name = labItems[i].tabname,
                    medicine_dose = labItems[i].tabdose,
                    medicine_time = labItems[i].time,
                    medicine_date = labItems[i].date,
                    Entry_by = HttpContext.Current.Session["ID"].ToString()

                });
            }


            if (PREID > 0)
            {
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, PREID = PREID, response = AllGlobalFunction.saveMessage });
            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Save !!" });
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
    public string LoadAllItem(string PreFix)
    {

        DataTable dtItem = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IM.Typename ItemName, IM.ItemID FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
        sb.Append("   INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID ");
        sb.Append(" WHERE CR.ConfigID = '11' AND im.IsActive=1  GROUP BY im.ItemID  ORDER BY ItemName ");
        dtItem = StockReports.GetDataTable(sb.ToString());
        if (dtItem.Rows.Count > 0)
        {
            var dt = dtItem;
            DataView DvInvestigation = dt.AsDataView();
            string filter = string.Empty;
            if (!string.IsNullOrEmpty(PreFix))
            {
                filter = "ItemName LIKE '%" + PreFix + "%'";
                DvInvestigation.RowFilter = filter;
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
        }
        else
        {
            return "No Item Found";
        }
    }


    [WebMethod]

    public string getpacresultdetails(string TransactionID, string PatientId)
    {

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT poi.pacid,Date_Format(poi.Entry_date,'%d-%b-%y %r') Entry_date,CONCAT(pm.title,' ',pm.pname) patientname,CONCAT(em.title,' ',em.name) Entry_by  ");
        sb.Append(" FROM OT_PAC  poi INNER JOIN patient_master pm ON poi.PatientID=pm.PatientID INNER JOIN employee_master em ON em.EmployeeID=poi.entry_by  ");
        sb.Append(" WHERE poi.PatientID='" + PatientId + "' AND poi.TransactionID='" + TransactionID + "' and Is_active='1' ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]

    public string getAnesthesiadetails(string TransactionID, string PatientId)
    {

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT poi.ANEID,Date_Format(poi.Entry_date,'%d-%b-%y %r') Entry_date,CONCAT(pm.title,' ',pm.pname) patientname,CONCAT(em.title,' ',em.name) Entry_by  ");
        sb.Append(" FROM Plan_of_Anesthesia  poi INNER JOIN patient_master pm ON poi.PatientID=pm.PatientID INNER JOIN employee_master em ON em.EmployeeID=poi.entry_by  ");
        sb.Append(" WHERE poi.PatientID='" + PatientId + "' AND poi.TransactionID='" + TransactionID + "' and Is_active='1' ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string getpreopresultdetails(string TransactionID, string PatientId)
    {

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT poi.preid,Date_Format(poi.Entry_date,'%d-%b-%y %r') Entry_date, ");
        sb.Append(" (SELECT CONCAT(pm.title,' ',pm.pname) patientname FROM patient_master pm WHERE pm.PatientID=poi.PatientID ) patientname,  ");
        sb.Append(" (SELECT CONCAT(em.title,' ',em.name) Entry_by FROM employee_master em WHERE em.EmployeeID=poi.entry_by   ) Entry_by ");
        sb.Append("  FROM pre_op_instruction  poi WHERE poi.PatientID='" + PatientId + "' AND poi.TransactionID='" + TransactionID + "' and Is_active='1' ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string editpreopresultdetails(string PREID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(@" SELECT IFnull(medicine_id,'') medicine_id,IFnull(medicine_name,'') medicine_name, IFnull(medicine_dose,'') medicine_dose,IFNULL(DATE_FORMAT(IF(medicine_time='00:00:00','',medicine_time),'%h:%i %p'),'') medicine_time,IFNULL(DATE_FORMAT(IF(medicine_date='0001-01-01','',medicine_date),'%d-%b-%y'),'')  medicine_date, MALAMPATTI_SCORE,MOUTH_OPENING_ADEQATE,TEETH,DENTURES,T_M_DISTANCE,NCEK_MOVEMENTS,ASA_CLASS,IS_NPO_FROM,
                     IFNULL(DATE_FORMAT(IF(NPO_time='00:00:00','',NPO_time),'%h:%i %p'),'') NPO_time, 
                     IFNULL(DATE_FORMAT(IF(NPO_date='0001-01-01','',NPO_date),'%d-%b-%y'),'') NPO_date,IS_APPLY_EMLA,IS_REMOVE_ALL,IS_SHIFT_OT,IS_NEBULISATION,NEBULISATION,  IFNULL(DATE_FORMAT(IF(NEBULISATION_time='00:00:00','',NEBULISATION_time),'%h:%i %p'),'')NEBULISATION_time, IFNULL(DATE_FORMAT(IF(NEBULISATION_date='0001-01-01','',NEBULISATION_date),'%d-%b-%y'),'') NEBULISATION_date,IS_patient_can, 
                     IS_STOP_ORAL, IFNULL(DATE_FORMAT(IF(STOP_ORAL_from_date='0001-01-01','',STOP_ORAL_from_date),'%d-%b-%y'),'')STOP_ORAL_from_date, IFNULL(DATE_FORMAT(IF(STOP_ORAL_time='00:00:00','',STOP_ORAL_time),'%h:%i %p'),'')STOP_ORAL_time,IFNULL(DATE_FORMAT(IF(STOP_ORAL_from_on='0001-01-01','',STOP_ORAL_from_on),'%d-%b-%y'),'')STOP_ORAL_from_on,Other ,ALLERGIES
                     FROM pre_op_instruction  LEFT JOIN pre_op_instruction_medicine 
                     ON  pre_op_instruction.PREID=pre_op_instruction_medicine.PREID WHERE pre_op_instruction.preid=" + PREID + "  ");

        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string editpacresultdetails(string PACID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(@" SELECT SURGICAL_ANESTHETIC,ANTIICIPATED_AIRWAY,RESPIRATORY,CARDIOVASCULAR,RENAL_ENDOCRINE,HEPATO_GASTROINTESTINAL,NEURO_MUSCULOSKELETAL,
                     OTHERS,PRESENT_MEDICATIONS FROM OT_PAC   WHERE pacid='" + PACID + "' ");

        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string removegetpreop(string PREID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string user = HttpContext.Current.Session["ID"].ToString();
        try
        {
            string sqlcmd = " update pre_op_instruction set Is_active=0,Remove_by='" + user + "',Remove_date=now()  where PREID='" + PREID + "'";
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

    [WebMethod(EnableSession = true)]
    public string removepac(string PACID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string user = HttpContext.Current.Session["ID"].ToString();
        try
        {
            string sqlcmd = " update OT_PAC set Is_active=0,Remove_By='" + user + "',Remove_date=now()  where PACID='" + PACID + "'";
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
    [WebMethod(EnableSession = true)]
    public string removeane(string ANEID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string user = HttpContext.Current.Session["ID"].ToString();
        try
        {
            string sqlcmd = " update Plan_of_Anesthesia set Is_active=0,Remove_by='" + user + "',Remove_date=now()  where ANEID='" + ANEID + "'";
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
    public string editAnesultdetails(string AnID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ANEID,Anaesthesiaplan,Anaesthesiaplanallchecked,ANAESPRESENT,ANAESPATIENTAGREED ");
        sb.Append(" FROM Plan_of_Anesthesia WHERE ANEID='" + AnID + "' AND Is_active='1' ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}