using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;
using System.Drawing.Drawing2D;
using System.Web;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;


public partial class Design_IPD_FlowSheetView : System.Web.UI.Page
{

    

    
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string FillVitalDiv(string sdate, string span, string spandays, string PID)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        StringBuilder sbdate = new StringBuilder();
        string type = StockReports.ExecuteScalar(" SELECT  type FROM patient_medical_history  WHERE PatientID='" + PID + "'  ORDER BY TransactionID DESC  LIMIT 1 ");
         if (type == "IPD")
         {

             sbdate.Append("SELECT DISTINCT REPLACE(REPLACE(CONCAT(SUBSTR(CreatedDate,1,10),SUBSTR(CreatedDate,12,9)),'-',''),':','')  AS 'class' ,SUBSTR(CreatedDate,1,10) DATE,SUBSTR(CreatedDate,12,9) TIME FROM IPD_Patient_ObservationChart ipo " +

      " WHERE  ipo.PatientID='" + PID + "' AND  DATE(SUBSTR(CreatedDate,1,10)) BETWEEN '" + sdt + "' and '" + edt + "' ORDER BY   ipo.CreatedDate desc ");
         }
         else
         {
             sbdate.Append("SELECT DISTINCT REPLACE(REPLACE(CONCAT(SUBSTR(EntryDate,1,10),SUBSTR(EntryDate,12,9)),'-',''),':','')  AS 'class' ,SUBSTR(EntryDate,1,10) DATE,SUBSTR(EntryDate,12,9) TIME FROM cpoe_vital cv " +

      " WHERE  cv.PatientID='" + PID + "' AND  DATE(SUBSTR(EntryDate,1,10)) BETWEEN '" + sdt + "' and '" + edt + "' ORDER BY   cv.EntryDate desc ");
         
         }

        DataTable dt = StockReports.GetDataTable(sbdate.ToString());


        StringBuilder sb = new StringBuilder();
        StringBuilder sb5 = new StringBuilder();

        string tbl = "<table id='tbl_VitalData' width='100%' border='1'>";
        sb.Append("<tr><th></th> ");
        sb5.Append("<tr><th></th> ");
        StringBuilder sb3 = new StringBuilder();
        sb3.Append("");
        string date = "";
        int c = 1;
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            date = dt.Rows[i]["DATE"].ToString().Substring(0, 10);

 
             sb5.Append("<th colspan='" + (c) + "'>" +Util.GetDateTime(date).ToString("dd-MM-yyyy") + "</th>");
            
            sb.Append("<th>" +dt.Rows[i]["TIME"].ToString() + "</th>");

            sb3.Append("<td class='" + dt.Rows[i]["Class"].ToString() + "'></td>");
        }
        
        sb.Append("</tr>");
        sb5.Append("</tr>");

        StringBuilder sb4 = new StringBuilder();
        sb4.Append("<tr id='trBP' ><td>BP</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trPulse' ><td>Pulse</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trResp' ><td>Resp</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trHT' ><td>HT</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trT' ><td>T</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trWT' ><td>WT</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trSPO2' ><td>SPO2</td>" + sb3.ToString() + "</tr>");
        sb4.Append("<tr id='trBloodGlucose' ><td>Blood Glucose</td>" + sb3.ToString() + "</tr>");
       
        
        return (tbl +sb5.ToString()+ sb.ToString() + sb4.ToString() + "</table>");

    }
    

    [WebMethod]
    public static string FillDiv(string sdate, string span, string spandays, string PID)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        StringBuilder sbdate = new StringBuilder();

        sbdate.Append("SELECT DISTINCT date_format(DATE(ploi.ResultDateTime),'%d-%m-%Y') as Date FROM patient_labobservation_opd ploi   INNER JOIN patient_labinvestigation_opd pli  ON ploi.Test_ID = pli.Test_ID  INNER JOIN   investigation_master im ON im.Investigation_Id = pli.Investigation_Id " +

  " WHERE   pli.PatientID='" + PID + "' AND DATE(ploi.ResultDateTime) BETWEEN '" + sdt + "' and '" + edt + "'   ORDER BY  ploi.Id desc  ");


        DataTable dt = StockReports.GetDataTable(sbdate.ToString());


        StringBuilder sb = new StringBuilder();
       
        string tbl = "<table id='tbl_Data' width='100%' border='1'>";
        sb.Append("<tr> <th>Investigation </th><th>Parameter</th><th>Range</th>");
        StringBuilder sb3 = new StringBuilder();
        sb3.Append("<td class='Investigation'> </td><td class='Parameter'></td><td class='Diffference'></td>");
        for (int i=0;i<dt.Rows.Count;i++)
        {

            sb.Append("<th>" + dt.Rows[i]["Date"].ToString().Substring(0,10)+ "</th>");
            string date = dt.Rows[i]["Date"].ToString().Replace("-", "");
            string newdate = date.Substring(4, 4) + date.Substring(2, 2) + date.Substring(0, 2);

            sb3.Append("<td class='" + newdate + "'></td>");
        }
        sb.Append("</tr>");
        StringBuilder sbtd = new StringBuilder();
        sbtd.Append("  SELECT   ploi.`LabObservationName`,ploi.LabObservation_ID Id FROM patient_labobservation_opd ploi" +
  " INNER JOIN patient_labinvestigation_opd pli  ON ploi.Test_ID = pli.Test_ID INNER JOIN   investigation_master im ON im.Investigation_Id = pli.Investigation_Id  where  pli.PatientID='" + PID + "'" +
  " AND  DATE(ploi.ResultDateTime) BETWEEN '" + sdt + "' and '" + edt + "'  GROUP BY ploi.`LabObservationName` ORDER BY  ploi.Id desc  ");


        StringBuilder sb2 = new StringBuilder();

        DataTable dttd = StockReports.GetDataTable(sbtd.ToString());
        for (int i = 0; i < dttd.Rows.Count; i++)
        {
            sb2.Append("<tr class='item' id='tr" + dttd.Rows[i]["Id"] + "'>");
            
            sb2.Append(sb3.ToString());
            sb2.Append("</tr>");

        }
        
        return (tbl+sb.ToString()+sb2.ToString()+"</table>");
       
    }

    [WebMethod]
    public static string bindVitals(string sdate, string span, string spandays, string PID)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");

        StringBuilder sb = new StringBuilder();
        string type = StockReports.ExecuteScalar(" SELECT  type FROM patient_medical_history  WHERE PatientID='" + PID + "'   ORDER BY TransactionID DESC  LIMIT 1 ");
        if (type == "IPD")
        {
            sb.Append("  SELECT ipo.bp BP,ipo.`Pulse` P,ipo.`Temp` T,ipo.`Resp` R,ipo.`Height` HT,ipo.`Weight` WT,ipo.`Oxygen` SPO2,ipo.`BloodSugar` CBG , REPLACE(REPLACE(CONCAT(SUBSTR(CreatedDate,1,10),SUBSTR(CreatedDate,12,9)),'-',''),':','')  AS 'class' ,SUBSTR(CreatedDate,1,10) DATE,SUBSTR(CreatedDate,12,9) TIME FROM IPD_Patient_ObservationChart ipo  where ipo.PatientID='" + PID + "'" +
      " AND  DATE(SUBSTR(CreatedDate,1,10)) BETWEEN '" + sdt + "' and '" + edt + "' ORDER BY  ipo.Id desc  ");
        }
        else
        {
                sb.Append("  SELECT cv.bp BP,CV.`P` P,cv.`T` T,cv.`R` R,cv.`HT` HT,cv.`WT` WT,cv.SPO2 SPO2,cv.`CBG` CBG , REPLACE(REPLACE(CONCAT(SUBSTR(EntryDate,1,10),SUBSTR(EntryDate,12,9)),'-',''),':','')  AS 'class' ,SUBSTR(EntryDate,1,10) DATE,SUBSTR(EntryDate,12,9) TIME FROM cpoe_vital cv  where cv.PatientID='" + PID + "'" +
         " AND  DATE(SUBSTR(EntryDate,1,10)) BETWEEN '" + sdt + "' and '" + edt + "' ORDER BY  cv.Id desc  ");
        
            
        }


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return "";
    }
    
    [WebMethod]
    public static string bindData(string sdate, string span, string spandays, string PID)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT  CONCAT(ploi.MinValue,'-',ploi.MaxValue) AS Diffference ,im.`NAME`,ploi.LabObservation_ID ID, ploi.`LabObservationName`,ploi.`VALUE`,pli.TransactionID,DATE(ploi.ResultDateTime) as Date FROM patient_labobservation_opd ploi" +
  " INNER JOIN patient_labinvestigation_opd pli  ON ploi.Test_ID = pli.Test_ID INNER JOIN   investigation_master im ON im.Investigation_Id = pli.Investigation_Id  where pli.PatientID='" + PID + "'" +
  " AND  DATE(ploi.ResultDateTime) BETWEEN '" + sdt + "' and '" + edt + "' ORDER BY  ploi.Id desc  ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return "";
    }
    [WebMethod]
    public static string FillDocNotesTable(string sdate, string span, string spandays, string PID)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        StringBuilder sbdate = new StringBuilder();

        string sbdate1 = "Select DISTINCT DATE(EntryDate) as Date from nursing_doctorprogressnote" +
            " where isActive=1  AND  DATE(EntryDate) BETWEEN '" + sdt + "' and '" + edt + "' and TransactionID in (Select TransactionID from patient_medical_history where PatientID='" + PID + "')  order by Date ";
        

        DataTable dt = StockReports.GetDataTable(sbdate1.ToString());


        StringBuilder sb = new StringBuilder();

        string tbl = "<table id='tbl_DocNotes_Data' width='100%' border='1'>";
        sb.Append("<tr> ");
        StringBuilder sb3 = new StringBuilder();
        sb3.Append("");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<th>" + dt.Rows[i]["Date"].ToString().Substring(0, 10) + "</th>");
            string date = dt.Rows[i]["Date"].ToString().Replace("-", "");
            string newdate = date.Substring(4, 4) + date.Substring(2, 2) + date.Substring(0, 2);
            sb3.Append("<td width='200px' class='" + newdate + "'></td>");
        }
        sb.Append("</tr>");
        StringBuilder sbtd = new StringBuilder();
        string sbtd1 = "Select Careplan,ID,TransactionId,DATE(EntryDate) as Date,(Select Concat(title,' ',Name) from Employee_master" +
            " where EmployeeID=UserID)EntryBy,ProgressNote,UserID,TIMESTAMPDIFF(MINUTE,EntryDate,NOW())createdDateDiff from nursing_doctorprogressnote" +
            " where  isActive=1  AND  DATE(EntryDate) BETWEEN '" + sdt + "' and '" + edt + "' and TransactionID in (Select TransactionID from patient_medical_history where PatientID='" + PID + "'  )  order by Date ";
        
       

        StringBuilder sb2 = new StringBuilder();

        DataTable dttd = StockReports.GetDataTable(sbtd1.ToString());
        //for (int i = 0; i < dttd.Rows.Count; i++)
        {
            sb2.Append("<tr id='trd'>");

            sb2.Append(sb3.ToString());
            sb2.Append("</tr>");

        }

        return (tbl + sb.ToString() + sb2.ToString() + "</table>");

    }
    [WebMethod]
    public static string bindDocNotes(string sdate, string span, string spandays, string PID)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");

        string str = "Select Careplan,ID,TransactionId,DATE(EntryDate) as Date,(Select Concat(title,' ',Name) from Employee_master" +
            " where EmployeeID=UserID)EntryBy,ProgressNote,UserID,TIMESTAMPDIFF(MINUTE,EntryDate,NOW())createdDateDiff from nursing_doctorprogressnote"+
            " where  isActive=1  AND  DATE(EntryDate) BETWEEN '" + sdt + "' and '" + edt + "' and TransactionID in (Select TransactionID from patient_medical_history where PatientID='"+PID+"')  order by Date ";
        DataTable dtDetails = StockReports.GetDataTable(str.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";

    }
    [WebMethod]
    public static string FillMedicationTable(string sdate, string span, string spandays, string PID, string PType)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        StringBuilder sbdate = new StringBuilder();
        string sbdate1="";
        if (PType != "OPD")
        {

            sbdate1 = " SELECT DISTINCT DATE_FORMAT(DATE(om.EntryDate),'%d-%m-%Y') AS DATE FROM orderset_medication om " +
                       " INNER JOIN tenwek_docotor_medicine_order tdmo ON tdmo.`TransactionId`=om.`TransactionID` " +
                      " AND tdmo.`ItemId`=om.`MedicineID` AND tdmo.`PatientId`=om.`PatientID` AND tdmo.`IndentNo`=om.`IndentNo` WHERE  om.PatientID='" + PID + "' " +
                      " AND  DATE(om.EntryDate) BETWEEN '" + sdt + "' and '" + edt + "'  Order By om.EntryId Desc ";
        }
        else {
            sbdate1 = "SELECT DISTINCT DATE_FORMAT(DATE(pm.`DATE`),'%d-%m-%Y') AS DATE FROM patient_medicine pm  WHERE  PatientID='" + PID + "'  " +
                 " AND  DATE(DATE) BETWEEN '" + sdt + "' and '" + edt + "'  ";
        }


        DataTable dt = StockReports.GetDataTable(sbdate1.ToString());


        StringBuilder sb = new StringBuilder();

        string tbl = "<table id='tbl_Medication' width='100%' border='1'>";
        sb.Append("<tr> <th>Medicine </th>");
        StringBuilder sb3 = new StringBuilder();
        sb3.Append("<td class='Medication'> </td>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<th>" + dt.Rows[i]["Date"].ToString().Substring(0, 10) + "</th>");
            string date = dt.Rows[i]["Date"].ToString().Replace("-", "");
            string newdate = date.Substring(4, 4) + date.Substring(2, 2) + date.Substring(0, 2);
            sb3.Append("<td class='" + newdate + "'></td>");
        }
        sb.Append("</tr>");
        StringBuilder sbtd = new StringBuilder();
        string sbtd1 ="";
        if (PType != "OPD")
        {

            sbtd1 = " SELECT om.MedicineID AS Id,om.MedicineName FROM orderset_medication om" +
                    "  INNER JOIN tenwek_docotor_medicine_order tdmo ON tdmo.`TransactionId`=om.`TransactionID` " +
                  "    AND tdmo.`ItemId`=om.`MedicineID` AND tdmo.`PatientId`=om.`PatientID` AND tdmo.`IndentNo`=om.`IndentNo` " +
                  "   where  om.PatientID='" + PID + "' AND    DATE(om.EntryDate) BETWEEN '" + sdt + "' and '" + edt + "' group by om.MedicineName  ";
        }
        else {
            sbtd1 = " SELECT pm.Medicine_ID AS Id,pm.MedicineName FROM patient_medicine pm " +
        " where  PatientID='" + PID + "' AND    DATE(pm.DATE) BETWEEN '" + sdt + "' and '" + edt + "' group by pm.MedicineName  ";
        }

        StringBuilder sb2 = new StringBuilder();

        DataTable dttd = StockReports.GetDataTable(sbtd1.ToString());
        for (int i = 0; i < dttd.Rows.Count; i++)
        {
            sb2.Append("<tr  class='item1'  id='trm" + dttd.Rows[i]["Id"] + "'>");

            sb2.Append(sb3.ToString());
            sb2.Append("</tr>");

        }

        return (tbl + sb.ToString() + sb2.ToString() + "</table>");
       

       
    }
    [WebMethod]
    public static string bindMedication(string sdate, string span, string spandays, string PID, string PType)
    {
        string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");

        string str ="";
        if (PType != "OPD")
        {
            str = "SELECT om.MedicineID AS Id,om.MedicineName,CONCAT (tdmo.`Dose`,' ',tdmo.`DoseUnit`) Dose,om.ReqQty,  " +
                   "  tdmo.`DurationName`  AS Duration,tdmo.`IntervalName` IntervalName ,DATE(om.EntryDate) AS DATE FROM orderset_medication om" +
                  "  INNER JOIN tenwek_docotor_medicine_order tdmo ON tdmo.`TransactionId`=om.`TransactionID` " +
                  "    AND tdmo.`ItemId`=om.`MedicineID` AND tdmo.`PatientId`=om.`PatientID` AND tdmo.`IndentNo`=om.`IndentNo` " +

                " where   om.PatientID='" + PID + "' AND  DATE(om.EntryDate) BETWEEN '" + sdt + "' and '" + edt + "'   Order By om.EntryId Desc ";
        }
        else {
            str = "SELECT pm.`Medicine_ID` AS  Id,pm.MedicineName,pm.Dose,pm.`OrderQuantity`as ReqQty,pm.`DurationName` AS Duration ,DATE(pm.Date) AS DATE FROM patient_medicine pm" +
               " where   pm.PatientID='" + PID + "' AND  DATE(pm.Date) BETWEEN '" + sdt + "' and '" + edt + "' AND pm.IsActive=1 ";
        
        }
        DataTable dtDetails = StockReports.GetDataTable(str.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";

    }



   
}