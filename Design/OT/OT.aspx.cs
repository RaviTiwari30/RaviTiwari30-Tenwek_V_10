using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_IPD_IPD_FinalDiagnosis : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TransactionID.Text = Request.QueryString["TransactionID"].ToString();
            PatientId.Text = Request.QueryString["PatientId"].ToString();
            OTBookingID.Text = Request.QueryString["OTBookingID"].ToString();
            App_ID.Text = Request.QueryString["App_ID"].ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string printplananesthesia(string ANEID)
    {
        DataSet ds = new DataSet();
        DataTable dt = StockReports.GetDataTable(@"
                       SELECT ANEID,Anaesthesiaplan,Anaesthesiaplanallchecked,ANAESPRESENT,ANAESPATIENTAGREED
                       FROM Plan_of_Anesthesia WHERE  Is_active=1 AND ANEID='" + ANEID + "' ");
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Plan_of_Anesthesia";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";

        //ds.WriteXmlSchema(@"D:\PlanofAnesthesia.xml");
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "PlanofAnesthesia";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
    }

    [WebMethod(EnableSession = true)]
    public static string printPAC(string PACID)
    {
        DataSet ds = new DataSet();
        DataTable dt = StockReports.GetDataTable(@"
                       SELECT SURGICAL_ANESTHETIC,ANTIICIPATED_AIRWAY,RESPIRATORY,CARDIOVASCULAR,split_str(CARDIOVASCULAR,'OTHERS#',2)CARDIOVASCULAR_other,
                       RENAL_ENDOCRINE,HEPATO_GASTROINTESTINAL,split_str(HEPATO_GASTROINTESTINAL,'OTHERS#',2)HEPATO_GASTROINTESTINAL_other   ,
                       NEURO_MUSCULOSKELETAL,split_str(NEURO_MUSCULOSKELETAL,'OTHERS#',2)NEURO_MUSCULOSKELETAL_other ,
                       OTHERS,PRESENT_MEDICATIONS,split_str(PRESENT_MEDICATIONS,'OTHERS#',2)PRESENT_MEDICATIONS_other,
                      (IF(SUBSTRING_INDEX(SUBSTRING_INDEX(RESPIRATORY, 'SMOKER#', -1),',',1)>0,SUBSTRING_INDEX(SUBSTRING_INDEX(RESPIRATORY, 'SMOKER#', -1),',',1),'') ) smokeryear
                      FROM OT_PAC where Is_active=1 and pacid=" + PACID + "   ");

        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "PACDETAILS";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";

        //ds.WriteXmlSchema(@"D:\AppConfirmationReport.xml");
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "PREANESTHETICEVALUATION";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
    }


    [WebMethod(EnableSession = true)]
    public static string printpreop(string PREID, string TransactionID)
    {
        DataSet ds = new DataSet();
        DataTable dt = StockReports.GetDataTable(@"                     
                        SELECT patient_master.Age,
                        (CASE
                        WHEN patient_master.gender = 'Male' THEN 'M'
                          WHEN patient_master.gender = 'Female' THEN 'F'
                          WHEN patient_master.gender='TransGender' THEN 'T'
                          ELSE ''
                        END) AS Gender,
                        pre_op_instruction.PatientID as Patient_ID ,PREID ,MALAMPATTI_SCORE,MOUTH_OPENING_ADEQATE,
                        TEETH,DENTURES,T_M_DISTANCE,NCEK_MOVEMENTS,ASA_CLASS,IS_NPO_FROM, IFNULL(DATE_FORMAT(IF(NPO_time='00:00:00','',NPO_time),'%h:%i %p'),'') NPO_time, 
                        IFNULL(DATE_FORMAT(IF(NPO_date='0001-01-01','',NPO_date),'%d-%b-%y'),'') NPO_date,IS_APPLY_EMLA,IS_REMOVE_ALL,IS_SHIFT_OT,IS_NEBULISATION,
                        NEBULISATION,  IFNULL(DATE_FORMAT(IF(NEBULISATION_time='00:00:00','',NEBULISATION_time),'%h:%i %p'),'')NEBULISATION_time, 
                        IFNULL(DATE_FORMAT(IF(NEBULISATION_date='0001-01-01','',NEBULISATION_date),'%d-%b-%y'),'') NEBULISATION_date,IS_patient_can, 
                        IS_STOP_ORAL, IFNULL(DATE_FORMAT(IF(STOP_ORAL_from_date='0001-01-01','',STOP_ORAL_from_date),'%d-%b-%y'),'')STOP_ORAL_from_date, 
                        IFNULL(DATE_FORMAT(IF(STOP_ORAL_time='00:00:00','',STOP_ORAL_time),'%h:%i %p'),'')STOP_ORAL_time,
                        IFNULL(DATE_FORMAT(IF(STOP_ORAL_from_on='0001-01-01','',STOP_ORAL_from_on),'%d-%b-%y'),'')STOP_ORAL_from_on,Other,ALLERGIES ,

                       (SELECT DATE_FORMAT(surgerydate,'%d-%b-%y') surgerydate  FROM ot_booking WHERE id=otbookingid)AS surgerydate,
                       (SELECT NAME FROM ot_booking INNER JOIN f_surgery_master 
                       ON f_surgery_master.surgery_id=ot_booking.SurgeryID 
                       WHERE ot_booking.id=otbookingid) AS Procedurename


                        FROM pre_op_instruction  
                        INNER JOIN patient_master  ON pre_op_instruction.PatientID=patient_master.PatientID
                        WHERE  is_active=1 AND PREID=" + PREID + " ");


        DataTable dt1 = StockReports.GetDataTable(@" 
                         SELECT IFNULL(medicine_id,'') medicine_id,preid,
                        IFNULL(medicine_name,'') medicine_name, 
                        IFNULL(medicine_dose,'') medicine_dose,
                        IFNULL(DATE_FORMAT(IF(medicine_time='00:00:00','',medicine_time),'%h:%i %p'),'') medicine_time,
                        IFNULL(DATE_FORMAT(IF(medicine_date='0001-01-01','',medicine_date),'%d-%b-%y'),'')  medicine_date  
                        FROM pre_op_instruction_medicine   WHERE preid=" + PREID + " and is_active=1  ");

        DataTable dt2 = StockReports.GetDataTable(@"
                           SELECT temp,pulse,bp,IFNULL(DATE_FORMAT(DATE,'%d-%b-%y'),'')DATE,IFNULL(DATE_FORMAT(TIME,'%h:%i %p'),'')TIME ,
                           oxygen,Weight FROM IPD_Patient_ObservationChart WHERE  transactionID = '" + TransactionID + "' and isActive=1 ORDER BY id DESC LIMIT 1");

        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "PREOPINSTRUCTIONS";

        ds.Tables.Add(dt1.Copy());
        ds.Tables[1].TableName = "PREOPINSTRUCTIONSMEDICINE";

        ds.Tables.Add(dt2.Copy());
        ds.Tables[2].TableName = "IPD_Patient_ObservationChart";

        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[3].TableName = "logo";
       // ds.WriteXmlSchema(@"E:\PREOPINSTRUCTIONS.xml");
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "PREOPINSTRUCTIONS";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
    }

}
