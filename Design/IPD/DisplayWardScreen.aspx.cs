using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_IPD_DisplayWardScreen : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string BindWardData(string WardID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(t2.Title, ' ',t2.PName)PName,t2.PatientID,t2.Gender,CONCAT(t2.House_No,'',t2.Street_Name,'',t2.City)Address,t2.Mobile,t2.Age, ");
        sb.Append(" t2.TransactionID,REPLACE(t2.TransactionID,'ISHHI','')IPDNO,dm.Name AS DName,rm.Name AS RName,fpm.Company_Name,t2.Name AS BillingCategory, ");
        sb.Append(" CONCAT(t2.DateOfAdmit,' ',t2.TimeOfAdmit)AdmitDate,CONCAT(t2.DateOfDischarge,' ',t2.TimeOfDischarge)DischargeDate,t2.Status, ");
        sb.Append(" CONCAT(t2.Age,' / ',t2.Gender)AgeSex, CONCAT(rm.Room_No,'/',rm.Bed_No,'/',rm.Name,'/',rm.Floor)RoomName,t2.IPDCaseType_ID,fpm.ReferenceCode,t2.PanelID,t2.ScheduleChargeID,  ");
        sb.Append(" IF(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID=t2.TransactionID AND IsCancel=0),0)=0,'0', IF(IFNULL((SELECT SUM(amount)   FROM f_ledgertnxdetail WHERE TransactionID=t2.TransactionID AND IsVerified=1  ");
        sb.Append(" AND IsPackage=0),0) - IFNULL((SELECT SUM(AmountPaid)   FROM f_reciept WHERE TransactionID=t2.TransactionID AND ");
        sb.Append(" IsCancel=0),0) > IFNULL((SELECT amount FROM f_thresholdlimit   WHERE IsActive=1 AND PanelID=fpm.ReferenceCode AND Room_Type=t2.IPDCaseType_ID LIMIT 1),0),'1','2')) amtpaid, dm.Designation Department,  adj.BillNo,t2.KinRelation,");
        sb.Append(" (SELECT NAME FROM employee_master WHERE employee_ID=t2.UserID)AdmittedBy,  (CASE WHEN adj.IsBilledClosed=1 THEN 'Bill Finalised' WHEN adj.IsBilledClosed=0 AND IFNULL(adj.BillNo,'')!='' THEN 'Bill Not-Finalised'  ");
        sb.Append(" WHEN t2.Status='IN' THEN 'Admitted' ELSE 'Discharged' END)BillStatus,adj.IsBilledClosed,IF(emr.header IS NULL,'0','1') AS DischargeSummary FROM  ( SELECT t1.*,pm.ID,pm.Title,PName,Gender,House_No,Street_Name,Locality,City,PinCode,Age,pm.PatientID,pm.Mobile    ");
        sb.Append(" FROM ( SELECT pip.PatientID,pip.IPDCaseType_ID,pip.IPDCaseType_ID_Bill,pip.Room_ID,pip.TransactionID,pip.Status,pip.IsDisIntimated, ");
        sb.Append(" DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,     TIME_FORMAT(ich.TimeOfAdmit,'%l:%i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID, pmh.ScheduleChargeID,IF(ich.DateOfDischarge='0001-01-01','-',DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge,");
        sb.Append(" IF(ich.TimeOfDischarge='00:00:00','',TIME_FORMAT(ich.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge,  IF(pmh.KinName <>'',CONCAT(pmh.KinName,'(',pmh.KinRelation,')'),'')KinRelation,pmh.UserID,ictm2.Name ");
        sb.Append(" FROM ( SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseType_ID,pip1.IntimationTime,pip1.IPDCaseType_ID_Bill,pip1.Room_ID,  pip1.TransactionID,pip1.Status,pip1.IsDisIntimated   FROM patient_ipd_profile pip1 ");
        sb.Append(" INNER JOIN ( SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID FROM patient_ipd_profile WHERE STATUS = 'IN'  ");
        //sb.Append("  IN ('LSHHI1','LSHHI2','LSHHI3','LSHHI4','LSHHI5','LSHHI7')  ");
        sb.Append("  GROUP BY TransactionID   )pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID   )pip INNER JOIN ipd_case_history ich ON pip.TransactionID = ich.TransactionID   ");
        sb.Append(" INNER JOIN ipd_case_type_master ictm2 ON ictm2.IPDCaseType_ID = pip.IPDCaseType_ID_Bill  INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ich.TransactionID AND pmh.Type='IPD'  ");
        sb.Append("  WHERE ich.status = 'IN'  ");
        if (WardID != null && WardID != "")
        {
            sb.Append(" AND ictm2.IPDCaseType_ID IN (" + WardID + ") ");
        }
        sb.Append(") t1 INNER JOIN  patient_master pm  ON t1.PatientID = pm.PatientID WHERE pm.PatientID <>'' ) t2 INNER JOIN f_ipdadjustment adj ON adj.TransactionID = T2.TransactionID ");
        sb.Append(" LEFT JOIN emr_ipd_details emr ON emr.TransactionID = T2.TransactionID   INNER JOIN doctor_master dm ON adj.doctorID = dm.DoctorID ");
        sb.Append("  INNER JOIN room_master rm ON rm.Room_Id = t2.room_id   INNER JOIN Floor_master flm ON flm.name=rm.Floor   INNER JOIN f_panel_master fpm ON fpm.PanelID = adj.PanelID  ");
        sb.Append(" WHERE adj.Patient_Type !='VIP'  ORDER BY t2.Name, REPLACE(T2.TransactionID,'ISHHI','') DESC,t2.ID , t2.PName, t2.PatientID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
}