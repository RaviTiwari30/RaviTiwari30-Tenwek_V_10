using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_DisplayBillInProcess : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["CentreID"] = Session["CentreID"].ToString();
        }
    }

    [WebMethod(EnableSession = false)]
    public static string BindAllBillInProcess()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT pmh.`DischargeIntimateDate`, CONCAT(pm.Title,' ',pm.PName)PName,pnl.Company_Name AS Panel,CONCAT(dm.Title,'',dm.Name) AS DoctorName,pmh.TransNo TransactionID, ");
        sb.Append(" (SELECT CONCAT(rm.Floor,'/',rm.Name,'/',rm.Bed_No) FROM patient_ipd_profile pip INNER JOIN room_master rm ON rm.RoomId=pip.RoomId  WHERE pip.TransactionID=pmh.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1 )BedNo, ");
        sb.Append(" (SELECT rm.Name FROM patient_ipd_profile pip INNER JOIN room_master rm ON rm.RoomId=pip.RoomId  WHERE pip.TransactionID=pmh.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1 )Ward, IFNULL(em.name,'')DischargedBy ,  IF(pmh.`IsDischargeIntimate`=1,DATE_FORMAT(pmh.DischargeIntimateDate,'%d-%b-%y %I:%i %p'),'')Intemation, ");
        sb.Append(" IF(pmh.IsMedCleared=1,DATE_FORMAT(pmh.MedClearedDate,'%d-%b-%y %I:%i %p'),'')MedClearnace, IF(pmh.IsBillFreezed=1,DATE_FORMAT(pmh.BillFreezedTimeStamp,'%d-%b-%y %I:%i %p'),'')BillInProcess,  IF(pmh.IsBillFreezed=1,DATE_FORMAT(pmh.BillFreezedTimeStamp,'%d-%b-%y %I:%i %p'),'')BillFreeze, IF(pmh.Status='OUT',DATE_FORMAT(CONCAT(pmh.DateOfDischarge,' ',pmh.TimeOfDischarge),'%d-%b-%y %I:%i %p'),'')DischargeDate, ");
        sb.Append(" IF((IFNULL(pmh.BillNo,''))<>'',DATE_FORMAT(pmh.BillDate,'%d-%b-%y %I:%i %p'),'')BillDate,IF(pmh.IsClearance=1,DATE_FORMAT(pmh.ClearanceTimeStamp,'%d-%b-%y %I:%i %p'),'')PatientClearnace, IF(pmh.IsNurseClean=1,DATE_FORMAT(pmh.NurseCleanTimeStamp,'%d-%b-%y %I:%i %p'),'')NurseClearnace, IF(pmh.IsRoomClean=1,DATE_FORMAT(pmh.RoomCleanTimeStamp,'%d-%b-%y %I:%i %p'),'')RoomClearnace,IsBillFreezed ");
        sb.Append(" FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID  INNER JOIN Doctor_master dm ON dm.DoctorID=pmh.DoctorID LEFT JOIN employee_master em ON em.employeeid=pmh.DischargedBy WHERE  pmh.`IsDischargeIntimate`=1 AND pmh.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ORDER BY MedClearedDate ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}