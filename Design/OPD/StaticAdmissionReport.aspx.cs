using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_StaticAdmissionReport : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            GetMyWardList();
            GetMyMonthList();
            GetMyYearList();
            GetAnesthesiaList();
            GetSurgeonList();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");

    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (ddlReportType.SelectedValue == "0")
        {
            lblMsg.Text = "Select Report Type";
            return;
        }

        if (ddlReportType.SelectedValue == "1")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("    SELECT  pmh.`PatientID` 'UHID',pmh.`TransNo` 'IPD No.',CONCAT(pm.`Title`,'', pm.`PName`) 'Patient Name', ");
            sb.Append("   CONCAT(dm.`Title`,' ',dm.`NAME`) 'Doctor Name',pm.`Age`,pm.`Gender` 'Sex', ");
            sb.Append("  ic.`WHO_Full_Desc` 'Diagnosis',IC.`ICD10_Code` 'ICD 10 Codes', CONCAT(DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfAdmit`,'%r'))'Date of Admission & Time', ");
            sb.Append("   CONCAT(DATE_FORMAT(pmh.`DateOfDischarge`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfDischarge`,'%r')) 'Date of Discharge & Time', ");
            sb.Append("   CONCAT(ipc.`NAME`,'/',rm.`Room_No`,'/',rm.`Bed_No`) 'Ward/Room/Bed', ");
            sb.Append("   pmh.`DischargeType` 'Patient Type', pnl.`Company_Name` 'Insurance' ");
            sb.Append("    FROM patient_medical_history  pmh  ");
            sb.Append("   left JOIN `cpoe_10cm_patient` cmp ON cmp.`TransactionID`=pmh.`TransactionID` ");
            sb.Append("   left JOIN icd_10_new ic ON ic.`ICD10_Code`=cmp.`ICD_Code` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append("   INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append("   INNER JOIN  f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append("   INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append("   INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID` AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   WHERE pmh.`TYPE`='IPD'   ");

            if (!string.IsNullOrEmpty(txtUhid.Text.ToString()))
            {
                sb.Append(" and pmh.`PatientID`='" + txtUhid.Text.ToString() + "'");

            }
            if (!string.IsNullOrEmpty(txtDiagnosis.Text.ToString()))
            {
                sb.Append(" and  ic.`WHO_Full_Desc` LIKE '%" + txtDiagnosis.Text.ToString() + "%' ");

            }
            if (!string.IsNullOrEmpty(txtIpdNo.Text.ToString()))
            {
                sb.Append(" and pmh.`TransNo`='" + txtIpdNo.Text.ToString() + "'");

            }

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append(" AND  DATE(pmh.`DateOfDischarge`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.`DateOfDischarge`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

            sb.Append("   GROUP BY ic.`ICD10_Code` , pmh.`TransNo` ORDER BY PM.`PatientID` DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "IPD Discharge List";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "2")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("    SELECT  pmh.`PatientID` 'UHID',pmh.`TransNo` 'IPD No.',CONCAT(pm.`Title`,'', pm.`PName`) 'Patient Name', ");
            sb.Append("   CONCAT(dm.`Title`,' ',dm.`NAME`) 'Doctor Name',pm.`Age`,pm.`Gender` 'Sex', ");
            sb.Append("   ic.`WHO_Full_Desc` 'Diagnosis',IC.`ICD10_Code` 'ICD 10 Codes', CONCAT(DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfAdmit`,'%r'))'Date of Admission & Time', ");
            sb.Append("   CONCAT(ipc.`NAME`,'/',rm.`Room_No`,'/',rm.`Bed_No`) 'Ward/Room/Bed', ");
            sb.Append("    pnl.`Company_Name` 'Insurance' ");
            sb.Append("    FROM patient_medical_history  pmh  ");
            sb.Append("   left JOIN `cpoe_10cm_patient` cmp ON cmp.`TransactionID`=pmh.`TransactionID` ");
            sb.Append("   left JOIN icd_10_new ic ON ic.`ICD10_Code`=cmp.`ICD_Code` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append("   INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append("   INNER JOIN  f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append("   INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`  ");
            sb.Append("   INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID` ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   WHERE pmh.`TYPE`='IPD'   ");

            if (!string.IsNullOrEmpty(txtUhid.Text.ToString()))
            {
                sb.Append(" and pmh.`PatientID`='" + txtUhid.Text.ToString() + "'");

            }
            if (!string.IsNullOrEmpty(txtDiagnosis.Text.ToString()))
            {
                sb.Append(" and  ic.`WHO_Full_Desc` LIKE '%" + txtDiagnosis.Text.ToString() + "%' ");

            }
            if (!string.IsNullOrEmpty(txtIpdNo.Text.ToString()))
            {
                sb.Append(" and pmh.`TransNo`='" + txtIpdNo.Text.ToString() + "'");

            }

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

            sb.Append("   GROUP BY ic.`ICD10_Code` , pmh.`TransNo` ORDER BY PM.`PatientID` DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "IPD Admission List";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "3")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("    SELECT  pmh.`PatientID` 'UHID',pmh.`TransNo` 'IPD No.',CONCAT(pm.`Title`,'', pm.`PName`) 'Patient Name', ");
            sb.Append("   CONCAT(dm.`Title`,' ',dm.`NAME`) 'Doctor Name',pm.`Age`,pm.`Gender` 'Sex', ");
            sb.Append("   ic.`WHO_Full_Desc` 'Diagnosis',IC.`ICD10_Code` 'ICD 10 Codes', CONCAT(DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfAdmit`,'%r'))'Date of Admission & Time', ");
            sb.Append("    rm.`NAME` 'Department Name', ");
            sb.Append(" (SELECT GROUP_CONCAT( im.`TypeName`) FROM `f_itemmaster` im  ");
            sb.Append("   INNER JOIN  cpoe_otnotes_deptofsurgery ods ON im.`ItemID`=ods.PrimaryProcedureVal  ");
            sb.Append("   WHERE ods.`TransactionID`=pmh.`TransactionID` GROUP BY im.`ItemID` limit 1 ) 'Procedure Name', ");
            sb.Append("   CONCAT(ipc.`NAME`,'/',rm.`Room_No`,'/',rm.`Bed_No`) 'Ward/Room/Bed', ");
            sb.Append("    pnl.`Company_Name` 'Insurance' ");
            sb.Append("    FROM patient_medical_history  pmh  ");
            sb.Append("   left JOIN `cpoe_10cm_patient` cmp ON cmp.`TransactionID`=pmh.`TransactionID` ");
            sb.Append("   left JOIN icd_10_new ic ON ic.`ICD10_Code`=cmp.`ICD_Code` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append("   INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append("   INNER JOIN  f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append("   INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID` AND ip.`STATUS`='IN' ");
            sb.Append("   INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='IN' ");

            if (!string.IsNullOrEmpty(txtUhid.Text.ToString()))
            {
                sb.Append(" and pmh.`PatientID`='" + txtUhid.Text.ToString() + "'");

            }
            if (!string.IsNullOrEmpty(txtDiagnosis.Text.ToString()))
            {
                sb.Append(" and  ic.`WHO_Full_Desc` LIKE '%" + txtDiagnosis.Text.ToString() + "%' ");

            }
            if (!string.IsNullOrEmpty(txtIpdNo.Text.ToString()))
            {
                sb.Append(" and pmh.`TransNo`='" + txtIpdNo.Text.ToString() + "'");

            }

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

            sb.Append("   GROUP BY ic.`ICD10_Code` , pmh.`TransNo` ORDER BY PM.`PatientID` DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "Occupancy List";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "4")
        {
            StringBuilder sb = new StringBuilder();



            sb.Append("       SELECT  pmh.`PatientID` 'UHID',pmh.`TransNo` 'IPD No.',CONCAT(pm.`Title`,'', pm.`PName`) 'Patient Name', ");
            sb.Append("   CONCAT(dm.`Title`,' ',dm.`NAME`) 'Doctor Name',pm.`Age`,pm.`Gender` 'Sex', ");
            sb.Append("   pic.`WHO_Full_Desc` 'Previous Diagnosis',  ic.`WHO_Full_Desc` 'Current Diagnosis',  ");
            sb.Append("   CONCAT(DATE_FORMAT(SPM.`DateOfAdmit`,'%d-%b-%Y'),' ',TIME_FORMAT(SPM.`TimeOfAdmit`,'%r'))'Last Date of Admission & Time', ");

            sb.Append("   CONCAT(DATE_FORMAT(SPM.`DateOfDischarge`,'%d-%b-%Y'),' ',TIME_FORMAT(SPM.`TimeOfDischarge`,'%r')) 'Last Date of Discharge & Time', ");

            sb.Append("    CONCAT(DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfAdmit`,'%r'))'Current Date of Admission & Time', ");
            sb.Append("   CONCAT(ipc.`NAME`,'/',rm.`Room_No`,'/',rm.`Bed_No`) 'Ward/Room/Bed', ");
            sb.Append("   spm.`DischargeType` 'Last Patient Type', pnl.`Company_Name` 'Insurance' ");
            sb.Append("    FROM patient_medical_history  pmh  ");

            sb.Append("   INNER JOIN patient_medical_history SPM ON SPM.`PatientID`=PMH.`PatientID` ");
            sb.Append("  AND SPM.`TYPE`='IPD' AND SPM.`STATUS`='OUT' AND SPM.`TransNo`<>PMH.`TransNo` ");
            sb.Append("   left JOIN `cpoe_10cm_patient` pcmp ON Pcmp.`TransactionID`=SPM.`TransactionID` ");
            sb.Append("   left JOIN icd_10_new  pic ON pic.`ICD10_Code`=pcmp.`ICD_Code`    ");


            sb.Append("   left JOIN `cpoe_10cm_patient` cmp ON cmp.`TransactionID`=pmh.`TransactionID` ");
            sb.Append("   left JOIN icd_10_new ic ON ic.`ICD10_Code`=cmp.`ICD_Code` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append("   INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append("   INNER JOIN  f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append("   INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID` ");
            sb.Append("   INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID` ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='IN'  ");

            if (!string.IsNullOrEmpty(txtUhid.Text.ToString()))
            {
                sb.Append(" and pmh.`PatientID`='" + txtUhid.Text.ToString() + "'");

            }
            if (!string.IsNullOrEmpty(txtDiagnosis.Text.ToString()))
            {
                sb.Append(" and  ic.`WHO_Full_Desc` LIKE '%" + txtDiagnosis.Text.ToString() + "%' ");

            }
            if (!string.IsNullOrEmpty(txtIpdNo.Text.ToString()))
            {
                sb.Append(" and pmh.`TransNo`='" + txtIpdNo.Text.ToString() + "'");

            }

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

            sb.Append("   GROUP BY ic.`ICD10_Code` , pmh.`TransNo` ORDER BY PM.`PatientID` DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "IPD Readmission List";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "5")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("    SELECT  pmh.`PatientID` 'UHID',pmh.`TransNo` 'IPD No.',CONCAT(pm.`Title`,'', pm.`PName`) 'Patient Name', ");
            sb.Append("   CONCAT(dm.`Title`,' ',dm.`NAME`) 'Doctor Name',pm.`Age`,pm.`Gender` 'Sex', ");
            sb.Append("    ic.`WHO_Full_Desc` 'Diagnosis',IC.`ICD10_Code` 'ICD 10 Codes', CONCAT(DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfAdmit`,'%r'))'Date of Admission & Time', ");
            sb.Append("   CONCAT(DATE_FORMAT(pmh.`DateOfDischarge`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TimeOfDeath`,'%r')) 'Date OF Death', ");
            sb.Append("   CONCAT(ipc.`NAME`,'/',rm.`Room_No`,'/',rm.`Bed_No`) 'Ward/Room/Bed', ");
            sb.Append("   pmh.`DischargeType` 'Patient Type', pnl.`Company_Name` 'Insurance' ");
            sb.Append("    FROM patient_medical_history  pmh  ");
            sb.Append("   INNER JOIN `cpoe_10cm_patient` cmp ON cmp.`TransactionID`=pmh.`TransactionID` ");
            sb.Append("   INNER JOIN icd_10_new ic ON ic.`ICD10_Code`=cmp.`ICD_Code` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append("   INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append("   INNER JOIN  f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append("   INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID` AND ip.`STATUS`='OUT' ");
            sb.Append("   INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID` ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='OUT' AND PMH.`DischargeType`='Death' ");

            if (!string.IsNullOrEmpty(txtUhid.Text.ToString()))
            {
                sb.Append(" and pmh.`PatientID`='" + txtUhid.Text.ToString() + "'");

            }
            if (!string.IsNullOrEmpty(txtDiagnosis.Text.ToString()))
            {
                sb.Append(" and  ic.`WHO_Full_Desc` LIKE '%" + txtDiagnosis.Text.ToString() + "%' ");

            }
            if (!string.IsNullOrEmpty(txtIpdNo.Text.ToString()))
            {
                sb.Append(" and pmh.`TransNo`='" + txtIpdNo.Text.ToString() + "'");

            }

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

            sb.Append("   GROUP BY ic.`ICD10_Code` , pmh.`TransNo` ORDER BY PM.`PatientID` DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "In Patient Morality Listing";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "6")
        {

            StringBuilder sb = new StringBuilder();

            sb.Append(" select tos.*,ROUND(IFNULL(((tos.TotalNoOfNursingDays/tos.NoOfTrueBeds)/tos.NoOfdays)*100,0),2)Occupency from (");
            sb.Append(" SELECT t.NAME 'Ward Name',MaleAdmission,FemaleAdmission,TotalAdmission,MaleDischarge,FemaleDischarge,TotalDischarge,(SELECT COUNT(rm.RoomID) FROM room_master rm  WHERE rm.`IPDCaseTypeID`=t.IPDCaseTypeID) NoOFTrueBeds,((DATEDIFF('" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'))+1) NoOfdays,(SELECT SUM(total) FROM (SELECT ictm.IPDCaseTypeID  , COUNT(*) Total ");
            sb.Append(" FROM ( SELECT * FROM patient_ipd_profile pip  ");
            sb.Append(" INNER JOIN   ");
            sb.Append(" (SELECT * FROM temp_for_date WHERE dt>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND dt<= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "') tfd  ");
            sb.Append(" WHERE CONCAT(pip.StartDate,' ',pip.StartTime )   ");
            sb.Append(" <= CONCAT(tfd.dt,' ','23:59:59')  ");
            sb.Append(" AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'),  ");
            sb.Append(" CONCAT(PIP.EndDate,' ',pip.EndTime)) >= CONCAT(tfd.dt,' ','23:59:59')  ) a  ");
            sb.Append(" INNER JOIN ipd_case_type_master ictm ON a.IPDCaseTypeID = ictm.IPDCaseTypeID  ");

            sb.Append(" GROUP BY (a.dt),ictm.IPDCaseTypeID  )tn WHERE tn.IPDCaseTypeID=t.`IPDCaseTypeID` GROUP BY IPDCaseTypeID ) TotalNoOfNursingDays");
            sb.Append("    FROM (   ");
            sb.Append(" SELECT t.NAME ,SUM(t.MaleAdmission) MaleAdmission,  ");
            sb.Append(" SUM(t.FemaleAdmission)FemaleAdmission,SUM(t.TotalAdmission)TotalAdmission,   ");
            sb.Append(" SUM(t.MaleDischarge)  MaleDischarge,SUM(t.FemaleDischarge) FemaleDischarge,sum((t.TotalDischarge)) TotalDischarge , SUM(t.NoOfAdmitDay)NoOfAdmitDay,IPDCaseTypeID  ");
            sb.Append(" FROM (  ");
            sb.Append(" SELECT t.NAME ,SUM(t.Male) MaleAdmission,SUM(t.Female)FemaleAdmission,(SUM(t.Male)+SUM(t.Female))TotalAdmission,  ");
            sb.Append(" 0 MaleDischarge,0 FemaleDischarge,0 TotalDischarge,0 NoOfAdmitDay ,t.IPDCaseTypeID FROM   ");
            sb.Append(" ( SELECT t.`NAME`,t.`IPDCaseTypeID`,SUM(t.Male)Male,Female FROM ( SELECT ipc.`NAME`,ip.`IPDCaseTypeID`,1 as Male,0 Female  FROM patient_medical_history pmh   ");
            sb.Append(" INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append("  INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("  WHERE pmh.`TYPE`='IPD'    ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append("  AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND pm.`Gender`='Male'  GROUP BY  ip.TransactionID,ip.`IPDCaseTypeID` )t    GROUP BY  t.IPDCaseTypeID  ");

            sb.Append("   UNION ALL  ");
            sb.Append("   SELECT t.`NAME`,t.`IPDCaseTypeID`,0 Male,sum(Female)Female FROM ( SELECT ipc.`NAME`,ip.`IPDCaseTypeID`,0 Male,1 Female  FROM patient_medical_history pmh   ");
            sb.Append(" INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append(" INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("   WHERE pmh.`TYPE`='IPD'     ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }
            sb.Append("  AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("   AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND pm.`Gender`='Female'  GROUP BY  ip.TransactionID,ip.`IPDCaseTypeID` )t    GROUP BY  t.IPDCaseTypeID )t     ");



            sb.Append(" GROUP BY t.IPDCaseTypeID   ");

            sb.Append(" UNION ALL   ");

            sb.Append(" SELECT t.NAME ,0 MaleAdmission,0 FemaleAdmission,0 TotalAdmission,  ");
            sb.Append(" SUM(t.MaleDischarge)  MaleDischarge,SUM(t.FemaleDischarge) FemaleDischarge,  ");
            sb.Append(" (SUM(t.FemaleDischarge)+SUM(t.MaleDischarge)) TotalDischarge ,SUM(t.NoOfAdmitDay)NoOfAdmitDay,t.IPDCaseTypeID FROM   ");
            sb.Append(" (  ");
            sb.Append(" SELECT t.NAME ,0 MaleAdmission,0 FemaleAdmission,0 TotalAdmission,  ");
            sb.Append(" COUNT(t.Gender) MaleDischarge,0 FemaleDischarge,0 TotalDischarge ,t.IPDCaseTypeID,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append(" SELECT NAME,IPDCaseTypeID,Gender,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append("  SELECT ipc.`NAME`,ip.`IPDCaseTypeID` ,pm.`Gender`,  ");
            sb.Append("  DATEDIFF(pmh.`DateOfDischarge`,pmh.`DateOfAdmit`)NoOfAdmitDay,pmh.`TransNo`   ");
            sb.Append("  FROM patient_medical_history pmh   ");
            sb.Append("  INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append(" INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("  WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='OUT'    ");
            sb.Append("  AND  DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("    AND  DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }
            sb.Append("    )t GROUP BY t.TransNo ,t.`IPDCaseTypeID`     ");
            sb.Append(" )t WHERE t.`Gender`='Male' GROUP BY  t.`IPDCaseTypeID`     ");
            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT t.NAME ,0 MaleAdmission,0 FemaleAdmission,0 TotalAdmission,  ");
            sb.Append(" 0 MaleDischarge,COUNT(t.Gender)  FemaleDischarge,0 TotalDischarge ,t.IPDCaseTypeID,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append(" SELECT NAME,IPDCaseTypeID,Gender,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append(" SELECT ipc.`NAME`,ip.`IPDCaseTypeID` ,pm.`Gender`,  ");
            sb.Append(" DATEDIFF(pmh.`DateOfDischarge`,pmh.`DateOfAdmit`)NoOfAdmitDay,pmh.`TransNo`   ");
            sb.Append(" FROM patient_medical_history pmh   ");
            sb.Append(" INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`  ");
            sb.Append(" INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID` ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("  WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='OUT'    ");
            sb.Append("  AND  DATE(pmh.`DateOfDischarge`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("  AND  DATE(pmh.`DateOfDischarge`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }


            sb.Append("  )t GROUP BY t.TransNo ,t.`IPDCaseTypeID`    ");
            sb.Append(" )t WHERE  t.`Gender`='Female' GROUP BY  t.`IPDCaseTypeID`     ");
            sb.Append(" )t GROUP BY  t.`IPDCaseTypeID`  ");
            sb.Append("  ) t GROUP BY t.IPDCaseTypeID     ");
            sb.Append("  )t  ");

            sb.Append(" INNER JOIN room_master  rm ON rm.`IPDCaseTypeID`=t.`IPDCaseTypeID`  ");

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND rm.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append("   GROUP BY t.`IPDCaseTypeID`   ORDER BY t.name ASC )tos ");
            
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {
                double MaleA = Convert.ToDouble(dt.Compute("SUM(MaleAdmission)", string.Empty));
                double FemaleA = Convert.ToDouble(dt.Compute("SUM(FemaleAdmission)", string.Empty));
                double TotalA = Convert.ToDouble(dt.Compute("SUM(TotalAdmission)", string.Empty));
                double MaleD = Convert.ToDouble(dt.Compute("SUM(MaleDischarge)", string.Empty));
                double FemaleD = Convert.ToDouble(dt.Compute("SUM(FemaleDischarge)", string.Empty));
                double TotalD = Convert.ToDouble(dt.Compute("SUM(TotalDischarge)", string.Empty));

                double NoOFTrueBeds = Convert.ToDouble(dt.Compute("SUM(NoOFTrueBeds)", string.Empty));
                double NoOfdays = Convert.ToDouble(dt.Compute("SUM(NoOfdays)", string.Empty));
                double TotalNoOfNursingDays = Convert.ToDouble(dt.Compute("SUM(TotalNoOfNursingDays)", string.Empty));
                double Occupency = Convert.ToDouble(dt.Compute("SUM(Occupency)", string.Empty));

                dt.Rows.Add("Total", MaleA, FemaleA, TotalA, MaleD, FemaleD, TotalD, NoOFTrueBeds, NoOfdays, TotalNoOfNursingDays, Util.GetDecimal(Occupency));

                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "Ipd Patient Info";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "7")
        {
            decimal FromAgeinDay = (Util.GetDecimal(txtFromAge.Text) * 365);
            decimal ToAgeInDay = (Util.GetDecimal(txtToAge.Text) * 365);

            StringBuilder sb = new StringBuilder();

            sb.Append(" select tos.WardName,tos.MaleAdmission Male,tos.FemaleAdmission Female,TotalAdmission Total from (");
            sb.Append(" SELECT t.NAME WardName,MaleAdmission,FemaleAdmission,TotalAdmission,MaleDischarge,FemaleDischarge,TotalDischarge,(SELECT COUNT(rm.RoomID) FROM room_master rm  WHERE rm.`IPDCaseTypeID`=t.IPDCaseTypeID) NoOFTrueBeds,((DATEDIFF('" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'))+1) NoOfdays,(SELECT SUM(total) FROM (SELECT ictm.IPDCaseTypeID  , COUNT(*) Total ");
            sb.Append(" FROM ( SELECT * FROM patient_ipd_profile pip  ");
            sb.Append(" INNER JOIN   ");
            sb.Append(" (SELECT * FROM temp_for_date WHERE dt>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND dt<= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "') tfd  ");
            sb.Append(" WHERE CONCAT(pip.StartDate,' ',pip.StartTime )   ");
            sb.Append(" <= CONCAT(tfd.dt,' ','23:59:59')  ");
            sb.Append(" AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'),  ");
            sb.Append(" CONCAT(PIP.EndDate,' ',pip.EndTime)) >= CONCAT(tfd.dt,' ','23:59:59')  ) a  ");
            sb.Append(" INNER JOIN ipd_case_type_master ictm ON a.IPDCaseTypeID = ictm.IPDCaseTypeID  ");

            sb.Append(" GROUP BY (a.dt),ictm.IPDCaseTypeID  )tn WHERE tn.IPDCaseTypeID=t.`IPDCaseTypeID` GROUP BY IPDCaseTypeID ) TotalNoOfNursingDays");
            sb.Append("    FROM (   ");
            sb.Append(" SELECT t.NAME ,SUM(t.MaleAdmission) MaleAdmission,  ");
            sb.Append(" SUM(t.FemaleAdmission)FemaleAdmission,SUM(t.TotalAdmission)TotalAdmission,   ");
            sb.Append(" SUM(t.MaleDischarge)  MaleDischarge,SUM(t.FemaleDischarge) FemaleDischarge,sum((t.TotalDischarge)) TotalDischarge , SUM(t.NoOfAdmitDay)NoOfAdmitDay,IPDCaseTypeID  ");
            sb.Append(" FROM (  ");
            sb.Append(" SELECT t.NAME ,SUM(t.Male) MaleAdmission,SUM(t.Female)FemaleAdmission,(SUM(t.Male)+SUM(t.Female))TotalAdmission,  ");
            sb.Append(" 0 MaleDischarge,0 FemaleDischarge,0 TotalDischarge,0 NoOfAdmitDay ,t.IPDCaseTypeID FROM   ");
            sb.Append(" ( SELECT t.`NAME`,t.`IPDCaseTypeID`,SUM(t.Male)Male,Female FROM ( SELECT ipc.`NAME`,ip.`IPDCaseTypeID`,1 as Male,0 Female  FROM patient_medical_history pmh   ");
            sb.Append(" INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append("  INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("   AND IF(pm.Age LIKE '%YRS%',(SUBSTRING_INDEX(pm.Age,' ',1)*365),  ");
            sb.Append("  IF(pm.Age LIKE '%MONTH%',(SUBSTRING_INDEX(pm.Age,' ',1)*30),  ");
            sb.Append("  IF(pm.Age LIKE '%DAY%',(SUBSTRING_INDEX(pm.Age,' ',1)),0)) ) BETWEEN  " + FromAgeinDay + " AND " + ToAgeInDay + "  ");

            sb.Append("  WHERE pmh.`TYPE`='IPD'    ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append("  AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND pm.`Gender`='Male'  GROUP BY  ip.TransactionID,ip.`IPDCaseTypeID` )t    GROUP BY  t.IPDCaseTypeID  ");

            sb.Append("   UNION ALL  ");
            sb.Append("   SELECT t.`NAME`,t.`IPDCaseTypeID`,0 Male,sum(Female)Female FROM ( SELECT ipc.`NAME`,ip.`IPDCaseTypeID`,0 Male,1 Female  FROM patient_medical_history pmh   ");
            sb.Append(" INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append(" INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  AND IF(pm.Age LIKE '%YRS%',(SUBSTRING_INDEX(pm.Age,' ',1)*365),  ");
            sb.Append("  IF(pm.Age LIKE '%MONTH%',(SUBSTRING_INDEX(pm.Age,' ',1)*30),  ");
            sb.Append("  IF(pm.Age LIKE '%DAY%',(SUBSTRING_INDEX(pm.Age,' ',1)),0)) ) BETWEEN " + FromAgeinDay + " AND " + ToAgeInDay + "  ");
            sb.Append("   WHERE pmh.`TYPE`='IPD'     ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }
            sb.Append("  AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("   AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND pm.`Gender`='Female'  GROUP BY  ip.TransactionID,ip.`IPDCaseTypeID` )t    GROUP BY  t.IPDCaseTypeID )t     ");



            sb.Append(" GROUP BY t.IPDCaseTypeID   ");

            sb.Append(" UNION ALL   ");

            sb.Append(" SELECT t.NAME ,0 MaleAdmission,0 FemaleAdmission,0 TotalAdmission,  ");
            sb.Append(" SUM(t.MaleDischarge)  MaleDischarge,SUM(t.FemaleDischarge) FemaleDischarge,  ");
            sb.Append(" (SUM(t.FemaleDischarge)+SUM(t.MaleDischarge)) TotalDischarge ,SUM(t.NoOfAdmitDay)NoOfAdmitDay,t.IPDCaseTypeID FROM   ");
            sb.Append(" (  ");
            sb.Append(" SELECT t.NAME ,0 MaleAdmission,0 FemaleAdmission,0 TotalAdmission,  ");
            sb.Append(" COUNT(t.Gender) MaleDischarge,0 FemaleDischarge,0 TotalDischarge ,t.IPDCaseTypeID,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append(" SELECT NAME,IPDCaseTypeID,Gender,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append("  SELECT ipc.`NAME`,ip.`IPDCaseTypeID` ,pm.`Gender`,  ");
            sb.Append("  DATEDIFF(pmh.`DateOfDischarge`,pmh.`DateOfAdmit`)NoOfAdmitDay,pmh.`TransNo`   ");
            sb.Append("  FROM patient_medical_history pmh   ");
            sb.Append("  INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append(" INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID`  ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("  WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='OUT'    ");
            sb.Append("  AND  DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("    AND  DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }
            sb.Append("    )t GROUP BY t.TransNo ,t.`IPDCaseTypeID`     ");
            sb.Append(" )t WHERE t.`Gender`='Male' GROUP BY  t.`IPDCaseTypeID`     ");
            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT t.NAME ,0 MaleAdmission,0 FemaleAdmission,0 TotalAdmission,  ");
            sb.Append(" 0 MaleDischarge,COUNT(t.Gender)  FemaleDischarge,0 TotalDischarge ,t.IPDCaseTypeID,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append(" SELECT NAME,IPDCaseTypeID,Gender,SUM(NoOfAdmitDay)NoOfAdmitDay FROM (  ");
            sb.Append(" SELECT ipc.`NAME`,ip.`IPDCaseTypeID` ,pm.`Gender`,  ");
            sb.Append(" DATEDIFF(pmh.`DateOfDischarge`,pmh.`DateOfAdmit`)NoOfAdmitDay,pmh.`TransNo`   ");
            sb.Append(" FROM patient_medical_history pmh   ");
            sb.Append(" INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`  ");
            sb.Append(" INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID` ");
            sb.Append("  INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("  WHERE pmh.`TYPE`='IPD' AND pmh.`STATUS`='OUT'    ");
            sb.Append("  AND  DATE(pmh.`DateOfDischarge`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("  AND  DATE(pmh.`DateOfDischarge`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND ip.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }


            sb.Append("  )t GROUP BY t.TransNo ,t.`IPDCaseTypeID`    ");
            sb.Append(" )t WHERE  t.`Gender`='Female' GROUP BY  t.`IPDCaseTypeID`     ");
            sb.Append(" )t GROUP BY  t.`IPDCaseTypeID`  ");
            sb.Append("  ) t GROUP BY t.IPDCaseTypeID     ");
            sb.Append("  )t  ");

            sb.Append(" INNER JOIN room_master  rm ON rm.`IPDCaseTypeID`=t.`IPDCaseTypeID`  ");

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND rm.`IPDCaseTypeID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            sb.Append("   GROUP BY t.`IPDCaseTypeID`   ORDER BY t.name ASC )tos ");
            
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {

                double Male = Convert.ToDouble(dt.Compute("SUM(Male)", string.Empty));
                double Female = Convert.ToDouble(dt.Compute("SUM(Female)", string.Empty));
                double Total = Convert.ToDouble(dt.Compute("SUM(Total)", string.Empty));
                dt.Rows.Add("Total", Male, Female, Total);

                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From Age " + txtFromAge.Text + " To Age " + txtToAge.Text; ;
                Session["ReportName"] = "IPD Census By Ward (Age Wise)";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }


        }
        else if (ddlReportType.SelectedValue == "8")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT t.NAME NAME, ");
            if (Util.GetInt(ddlMonth.SelectedValue) == 0)
            {
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=1,1,0))>0,Cnt,0)) AS  'Jan" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=2,1,0))>0,Cnt,0)) AS 'Feb" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=3,1,0))>0,Cnt,0)) AS 'Mar" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=4,1,0))>0,Cnt,0)) AS 'Apr" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=5,1,0))>0,Cnt,0)) AS 'May" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=6,1,0))>0,Cnt,0)) AS 'Jun" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=7,1,0))>0,Cnt,0)) AS 'Jul" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=8,1,0))>0,Cnt,0)) AS 'Aug" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=9,1,0))>0,Cnt,0)) AS 'Sep" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=10,1,0))>0,Cnt,0)) AS 'Oct" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=11,1,0))>0,Cnt,0)) AS 'Nov" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=12,1,0))>0,Cnt,0)) AS 'Dec" + ddlYear.SelectedValue + "',  ");
            }
            else
            {
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=" + Util.GetInt(ddlMonth.SelectedValue) + ",1,0))>0,Cnt,0)) AS  '" + ddlMonth.SelectedItem.Text + "" + ddlYear.SelectedValue + "', ");
            }
            sb.Append(" SUM(Cnt) Total  FROM ( ");

            sb.Append("SELECT t.Name, t.`DateOfAdmit`,SUM(Cnt) Cnt,t.IPDCaseTypeID FROM (SELECT ipc.`NAME`,ip.`IPDCaseTypeID`,1 Cnt,DATE(pmh.`DateOfAdmit`) DateOfAdmit   FROM patient_medical_history pmh   ");
                       sb.Append("   INNER JOIN `patient_ipd_profile` ip ON ip.`TransactionID`=pmh.`TransactionID`  ");
                        sb.Append("    INNER JOIN `room_master`  rm ON rm.`IPDCaseTypeID`=ip.`IPDCaseTypeID`  AND rm.`RoomID`=ip.`RoomID` "); 
                        sb.Append("      INNER JOIN  ipd_case_type_master ipc  ON ipc.`IPDCaseTypeID`=ip.`IPDCaseTypeID` "); 
                         sb.Append("      INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append("  WHERE pmh.`TYPE`='IPD'   ");
            sb.Append("  AND  YEAR(pmh.`DateOfAdmit`)=" + Util.GetInt(ddlYear.SelectedValue) + " ");
            if (Util.GetInt(ddlMonth.SelectedValue) != 0)
            {



                sb.Append("  AND  MONTH(pmh.`DateOfAdmit`)=" + Util.GetInt(ddlMonth.SelectedValue) + "  ");

            }

            sb.Append("  GROUP BY  ip.TransactionID,ip.`IPDCaseTypeID` ) t   ");

            sb.Append("  GROUP BY MONTH(t.`DateOfAdmit`),t.IPDCaseTypeID)t     GROUP BY t.IPDCaseTypeID ORDER BY NAME ASC    ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {



                if (Util.GetInt(ddlMonth.SelectedValue) == 0)
                {
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=1,1,0))>0,Cnt,0)) AS 'Jan" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=2,1,0))>0,Cnt,0)) AS 'Feb" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=3,1,0))>0,Cnt,0)) AS 'Mar" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=4,1,0))>0,Cnt,0)) AS 'Apr" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=5,1,0))>0,Cnt,0)) AS 'May" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=6,1,0))>0,Cnt,0)) AS 'Jun" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=7,1,0))>0,Cnt,0)) AS 'Jul" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=8,1,0))>0,Cnt,0)) AS 'Aug" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=9,1,0))>0,Cnt,0)) AS 'Sep" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=10,1,0))>0,Cnt,0)) AS 'Oct" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=11,1,0))>0,Cnt,0)) AS 'Nov" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=12,1,0))>0,Cnt,0)) AS 'Dec" + ddlYear.SelectedValue + "',  ");

                    double Jan = Convert.ToDouble(dt.Compute("SUM(Jan" + ddlYear.SelectedValue + ")", string.Empty));
                    double Feb = Convert.ToDouble(dt.Compute("SUM(Feb" + ddlYear.SelectedValue + ")", string.Empty));
                    double Mar = Convert.ToDouble(dt.Compute("SUM(Mar" + ddlYear.SelectedValue + ")", string.Empty));

                    double Apr = Convert.ToDouble(dt.Compute("SUM(Apr" + ddlYear.SelectedValue + ")", string.Empty));
                    double May = Convert.ToDouble(dt.Compute("SUM(May" + ddlYear.SelectedValue + ")", string.Empty));
                    double Jun = Convert.ToDouble(dt.Compute("SUM(Jun" + ddlYear.SelectedValue + ")", string.Empty));

                    double Jul = Convert.ToDouble(dt.Compute("SUM(Jul" + ddlYear.SelectedValue + ")", string.Empty));
                    double Aug = Convert.ToDouble(dt.Compute("SUM(Aug" + ddlYear.SelectedValue + ")", string.Empty));
                    double Sep = Convert.ToDouble(dt.Compute("SUM(Sep" + ddlYear.SelectedValue + ")", string.Empty));

                    double Oct = Convert.ToDouble(dt.Compute("SUM(Oct" + ddlYear.SelectedValue + ")", string.Empty));
                    double Nov = Convert.ToDouble(dt.Compute("SUM(Nov" + ddlYear.SelectedValue + ")", string.Empty));
                    double Dec = Convert.ToDouble(dt.Compute("SUM(Dec" + ddlYear.SelectedValue + ")", string.Empty));


                    double Total = Convert.ToDouble(dt.Compute("SUM(Total)", string.Empty));

                    dt.Rows.Add("Total", Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec, Total);



                }
                else
                {
                    double FTotal = Convert.ToDouble(dt.Compute("SUM(" + ddlMonth.SelectedItem.Text + "" + ddlYear.SelectedValue + ")", string.Empty));
                    double Total = Convert.ToDouble(dt.Compute("SUM(Total)", string.Empty));

                    dt.Rows.Add("Total", FTotal, Total);

                }


                Session["dtExport2Excel"] = dt;
                Session["Period"] = "Month " + ddlMonth.SelectedItem.Text + " Of Year " + ddlYear.SelectedValue;
                Session["ReportName"] = "IPD Census By Ward (YEARLY)";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }


        }

        else if (ddlReportType.SelectedValue == "9")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("select * from ( SELECT pm.`PatientID` UHID, pmh.`TransNo` IpdNo,CONCAT(pm.`Title`,'',pm.`PName`)NAME,pm.`Age`,pm.`Gender` Sex , ");
            sb.Append(" IF(cdn.`PrimaryProcedureText`='select','',cdn.`PrimaryProcedureText`)Primary_Procedure, ");
            sb.Append(" IF(cdn.`SecondaryProcedureText`='select','',cdn.`SecondaryProcedureText`)Secondary_Procedure, ");
            sb.Append(" (SELECT  GROUP_CONCAT( otat.`StaffName` ) FROM ot_PatientTAT  otat  ");
            sb.Append(" WHERE otat.`TransactionID`=cdn.`TransactionID` AND otat.`IsActive`=1 AND otat.OTBookingID=ob.`ID` AND otat.`StaffTypeID`=1)Surgeon_Name, ");
            sb.Append(" (SELECT  GROUP_CONCAT( otat.`StaffName` ) FROM ot_PatientTAT  otat  ");
            sb.Append(" WHERE otat.`TransactionID`=cdn.`TransactionID` AND otat.`IsActive`=1 AND otat.OTBookingID=ob.`ID` AND otat.`StaffTypeID`=2)Anesthesia_Name, ");
            sb.Append(" om.`NAME` Opreation_Theatre, ");
            sb.Append(" cdn.`NatureOfSurgary` Nature_Of_Case, ");
            sb.Append(" (SELECT  CONCAT( DATE_FORMAT(otat.`OtStartDate`,'%d-%b-%Y'),' ',TIME_FORMAT(otat.`StartTime`,'%r') ) ");
            sb.Append("   FROM ot_PatientTAT  otat WHERE otat.`TransactionID`=cdn.`TransactionID` AND otat.`IsActive`=1 AND otat.`TATTypeID`=5 AND otat.OTBookingID=ob.`ID` ORDER BY  otat.id LIMIT 1) Start_Date_Time, ");
            sb.Append(" (SELECT  CONCAT( DATE_FORMAT(otat.`OtStartDate`,'%d-%b-%Y'),' ',TIME_FORMAT(otat.`StartTime`,'%r') ) ");
            sb.Append("   FROM ot_PatientTAT  otat WHERE otat.`TransactionID`=cdn.`TransactionID` AND otat.`IsActive`=1 AND otat.`TATTypeID`=6 AND otat.OTBookingID=ob.`ID` ORDER BY otat.id LIMIT 1) End_Date_Time, ");
            sb.Append(" IF(pmh.`PanelID`<>1,'Insurance','Cash')Payment_Type, ");
            sb.Append(" IFNULL((SELECT SUM(ltd.`NetItemAmt`) FROM f_ledgertnxdetail ltd ");
            sb.Append(" WHERE ltd.`TransactionID`=cdn.`TransactionID` AND ltd.`IsVerified`<>2),0)Bill_Amount, ");
            sb.Append(" pnl.`Company_Name` Insurance  ");

            sb.Append(" FROM cpoe_OTNotes_DeptofSurgery cdn ");
            sb.Append(" INNER JOIN   patient_medical_history pmh ON pmh.`TransactionID`=cdn.`TransactionID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append(" INNER JOIN  f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
            sb.Append(" INNER JOIN ot_booking ob ON ob.`TransactionID`=cdn.`TransactionID` ");
            sb.Append(" INNER JOIN ot_master om ON om.`ID`=ob.`OTID` ");
            sb.Append(" WHERE cdn.`IsActive`=1 ");

            if (!string.IsNullOrEmpty(txtIpdNo.Text.ToString()))
            {
                sb.Append(" and pmh.`TransNo`='" + txtIpdNo.Text.ToString() + "'");

            }
            if (!string.IsNullOrEmpty(txtUhid.Text.ToString()))
            {
                sb.Append(" and pmh.`PatientID`='" + txtUhid.Text.ToString() + "'");

            }

            sb.Append(" AND  DATE(pmh.`DateOfAdmit`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.`DateOfAdmit`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");


            sb.Append(" GROUP BY  cdn.`TransactionID` ,cdn.`LedgerTransactionNo`  ORDER BY ob.ID ) as t ");



            if (!string.IsNullOrEmpty(ddlAnesthesiaName.SelectedValue))
            {
                sb.Append(" where t.Anesthesia_Name like '%" + ddlAnesthesiaName.SelectedItem.Text + "%'");
                if (!string.IsNullOrEmpty(ddlSurgeonName.SelectedValue))
                {
                    sb.Append(" and t.Surgeon_Name like '%" + ddlSurgeonName.SelectedItem.Text + "%'");

                }
                else
                {

                    if (!string.IsNullOrEmpty(txtProcedure.Text))
                    {
                        sb.Append(" and t.PrimaryProcedureText like '%" + txtProcedure.Text + "%' or  t.SecondaryProcedureText like '%" + txtProcedure.Text + "%' ");

                    }
                    else
                    { 
                    }
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(ddlSurgeonName.SelectedValue))
                {
                    sb.Append(" where t.Surgeon_Name like '%" + ddlSurgeonName.SelectedItem.Text + "%'");
                    if (!string.IsNullOrEmpty(txtProcedure.Text))
                    {
                        sb.Append(" and t.PrimaryProcedureText like '%" + txtProcedure.Text + "%' or  t.SecondaryProcedureText like '%" + txtProcedure.Text + "%' ");

                    }
                    else
                    {
                    }
                }
                else
                {

                    if (!string.IsNullOrEmpty(txtProcedure.Text))
                    {
                        sb.Append(" where t.PrimaryProcedureText like '%" + txtProcedure.Text + "%' or  t.SecondaryProcedureText like '%" + txtProcedure.Text + "%' ");

                    }
                    else
                    {
                    }
                }
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {


                Session["dtExport2Excel"] = dt;
                Session["Period"] = "";
                Session["ReportName"] = "Precedure Done By Surgeon Wise (Theatre)";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }

    }



    public void GetMyWardList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.IPDCaseTypeID Id,im.NAME  FROM ipd_case_type_master im WHERE im.IsActive=1 AND im.CentreID='" + Util.GetString(Session["CentreID"].ToString()) + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlward.DataSource = dt;
        ddlward.DataValueField = "Id";
        ddlward.DataTextField = "NAME";
        ddlward.DataBind();
        ddlward.Items.Insert(0, new ListItem("All", ""));
    }

    public void GetAnesthesiaList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT otat.OTBookingID as Id,otat.StaffName FROM ot_PatientTAT otat  WHERE StaffName<>'' AND otat.IsActive='1'  AND StaffTypeID=2 AND otat.CentreID='" + Util.GetString(Session["CentreID"].ToString()) + "' group by StaffName");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlAnesthesiaName.DataSource = dt;
        ddlAnesthesiaName.DataValueField = "Id";
        ddlAnesthesiaName.DataTextField = "StaffName";
        ddlAnesthesiaName.DataBind();
        ddlAnesthesiaName.Items.Insert(0, new ListItem("All", ""));
       // ddlAnesthesiaName.SelectedValue = "970";
    }
    public void GetSurgeonList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT concat(  otat.OTBookingID,otat.StaffName) as Id,otat.StaffName  FROM ot_PatientTAT otat WHERE StaffName<>'' AND otat.IsActive='1'  AND StaffTypeID=1 AND otat.CentreID='" + Util.GetString(Session["CentreID"].ToString()) + "' group by StaffName");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlSurgeonName.DataSource = dt;
        ddlSurgeonName.DataValueField = "Id";
        ddlSurgeonName.DataTextField = "StaffName";
        ddlSurgeonName.DataBind();
        ddlSurgeonName.Items.Insert(0, new ListItem("All", ""));
    }


    public void GetMyMonthList()
    {
        DateTime month = Convert.ToDateTime("01/01/2022");
        for (int i = 0; i < 12; i++)
        {
            DateTime NextMont = month.AddMonths(i);
            ListItem list = new ListItem();
            list.Text = NextMont.ToString("MMM");
            list.Value = NextMont.Month.ToString();
            ddlMonth.Items.Add(list);
        }

        // ddlMonth.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
        ddlMonth.Items.Insert(0, new ListItem("All", "0"));
    }


    public void GetMyYearList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(YEAR(cpoe.EntDate))YearId FROM cpoe_10cm_patient cpoe ORDER BY (YEAR(cpoe.EntDate)) ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlYear.DataSource = dt;
        ddlYear.DataValueField = "YearId";
        ddlYear.DataTextField = "YearId";
        ddlYear.DataBind();
        ddlYear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;

    }


}