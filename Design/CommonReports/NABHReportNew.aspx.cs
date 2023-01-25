using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Text;

public partial class Design_EDP_NABHReportNew : System.Web.UI.Page
{
    DataTable dt = new DataTable();
    StringBuilder sb = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        sb.Append("");
        string Report_type = "";

        if (rbtActive.SelectedValue == "1")
        {

            Report_type = "Laboratory Detailed Report";


            sb.Append("    SELECT pm.PNAME,plo.`SampleDate`,plo.`ResultEnteredDate`,plo.`UnApprovedDate`,plo.`UnApprovedBy`, ");
            sb.Append("    plo.`UnApprovalReason`, ");


            sb.Append(" CASE ");
            sb.Append(" WHEN COUNT(plo.isPrint)=SUM(plo.isPrint) THEN 'Printed' ");
            sb.Append(" WHEN COUNT(plo.Approved)=SUM(plo.Approved) THEN 'Approved' ");
            sb.Append(" WHEN COUNT(plo.isHold)=SUM(plo.isHold) THEN 'Hold' ");
            sb.Append("   WHEN COUNT(plo.Result_Flag)=SUM(plo.Result_Flag)  and   SUM(plo.isForward*plo.Result_Flag)=0 THEN 'Tested' ");
            sb.Append("   WHEN COUNT(plo.isForward)=SUM(plo.isForward) THEN  'Forwarded' ");
            sb.Append("   WHEN (select count(1) from mac_Data where reading<>'' and Test_ID=plo.Test_ID and `centreid`=plo.sampleTransferCentreID)>0 and plo.Result_Flag=0 THEN 'MacData' ");
            sb.Append("  WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='N',1,0)) THEN  'Not-Collected' ");
            sb.Append("   WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='S',1,0)) THEN 'Collected' ");
            sb.Append("  WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='Y',1,0)) THEN 'Received' ");
            sb.Append("  WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='R',1,0)) THEN 'Rejected' ");
            sb.Append("  ELSE 'NA'  ");
            sb.Append("  END Parameter ");

            sb.Append("    FROM `patient_labinvestigation_opd` plo  ");
            sb.Append("    INNER JOIN patient_master pm ON pm.PatientID = plo.PatientID  ");
            sb.Append("    INNER JOIN patient_medical_history pmh ON pmh.PatientID = plo.PatientID  ");
            sb.Append("    WHERE pmh.type in('OPD','EMG') and ifnull(plo.reporttype,0) <>0 AND plo.date>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND plo.date <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
            sb.Append("    UNION ALL  ");
            sb.Append("    SELECT pm.PNAME ,plo.`SampleDate`,plo.`ResultEnteredDate`,plo.`UnApprovedDate`,plo.`UnApprovedBy`, ");
            sb.Append("    plo.`UnApprovalReason`, ");

            sb.Append(" CASE ");
            sb.Append(" WHEN COUNT(plo.isPrint)=SUM(plo.isPrint) THEN 'Printed' ");
            sb.Append(" WHEN COUNT(plo.Approved)=SUM(plo.Approved) THEN 'Approved' ");
            sb.Append(" WHEN COUNT(plo.isHold)=SUM(plo.isHold) THEN 'Hold' ");
            sb.Append("   WHEN COUNT(plo.Result_Flag)=SUM(plo.Result_Flag)  and   SUM(plo.isForward*plo.Result_Flag)=0 THEN 'Tested' ");
            sb.Append("   WHEN COUNT(plo.isForward)=SUM(plo.isForward) THEN  'Forwarded' ");
            sb.Append("   WHEN (select count(1) from mac_Data where reading<>'' and Test_ID=plo.Test_ID and `centreid`=plo.sampleTransferCentreID)>0 and plo.Result_Flag=0 THEN 'MacData' ");
            sb.Append("  WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='N',1,0)) THEN  'Not-Collected' ");
            sb.Append("   WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='S',1,0)) THEN 'Collected' ");
            sb.Append("  WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='Y',1,0)) THEN 'Received' ");
            sb.Append("  WHEN COUNT(plo.isSampleCollected)=SUM(IF(plo.isSampleCollected='R',1,0)) THEN 'Rejected' ");
            sb.Append("  ELSE 'NA'  ");
            sb.Append("  END Parameter ");

                 sb.Append("    FROM `patient_labinvestigation_opd` plo INNER JOIN patient_medical_history pmh ON pmh.TransactionID =plo.TransactionID  ");
            sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID ");
            sb.Append("    WHERE pmh.type='IPD' and ifnull(plo.reporttype,0) AND plo.date>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND plo.date <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
                        
                        
        }
        else if (rbtActive.SelectedValue == "2")
        {
            Report_type = "Laboratory Indicator";

            sb.Append("    SELECT  ");
            sb.Append("    (SUM(REDO_REPEAT)/SUM(TestNo))*1000 AS REDO_REPEAT ,(SUM(REPORTING_ERROR)/SUM(TestNo))*1000 AS REPORTING_ERROR ,");
            sb.Append("    MONTH_A MONTH FROM ( ");

            sb.Append("    SELECT MONTHNAME(plo.`Date`)MONTH_A,IF( ifnull(plo.reporttype,0) IN (1,2),1,0)REDO_REPEAT,");
            sb.Append("    IF( ifnull(plo.reporttype,0)=3,1,0)REPORTING_ERROR,1  AS TestNo ");
            sb.Append("    FROM `patient_labinvestigation_opd` plo INNER JOIN patient_medical_history pmh ON pmh.TransactionID =plo.TransactionID  ");
	        sb.Append("    INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID`	 ");
            sb.Append("    WHERE pmh.type in('OPD','EMG') and plo.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND plo.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND im.`ReportType` IN (1,3) ");

	        sb.Append("    UNION ALL ");
            sb.Append("    SELECT MONTHNAME(plo.`Date`)MONTH_A,IF( ifnull(plo.reporttype,0) IN (1,2),1,0)REDO_REPEAT, ");
            sb.Append("    IF( ifnull(plo.reporttype,0)=3,1,0)REPORTING_ERROR,1  AS TestNo ");
            sb.Append("    FROM `patient_labinvestigation_opd` plo  INNER JOIN patient_medical_history pmh ON pmh.TransactionID =plo.TransactionID  ");
	        sb.Append("    INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append("    WHERE pmh.type='IPD' and plo.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND plo.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
	        sb.Append("    AND im.`ReportType`IN (1,3) ");

            sb.Append("    )t GROUP BY MONTH ");
         
        }
        else if (rbtActive.SelectedValue == "3")
        {
            Report_type = " Radiology Indicator";

            sb.Append("    SELECT  ");
            sb.Append("    (SUM(REDO_REPEAT)/SUM(TestNo))*1000 AS REDO_REPEAT ,(SUM(REPORTING_ERROR)/SUM(TestNo))*1000 AS REPORTING_ERROR ,");
            sb.Append("    MONTH_A MONTH  FROM ( ");
            sb.Append("    SELECT MONTHNAME(plo.`Date`)MONTH_A,IF(ifnull(plo.reporttype,0) IN (1,2),1,0)REDO_REPEAT,");
            sb.Append("    IF(ifnull(plo.reporttype,0)=3,1,0)REPORTING_ERROR,1  AS TestNo ");
            sb.Append("    FROM `patient_labinvestigation_opd` plo  ");
            sb.Append("    INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID`	 ");
            sb.Append("    WHERE plo.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND plo.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND im.`ReportType`=5 ");
            sb.Append("    UNION ALL ");
            sb.Append("    SELECT MONTHNAME(plo.`Date`)MONTH_A,IF(ifnull(plo.reporttype,0) IN (1,2),1,0)REDO_REPEAT, ");
            sb.Append("    IF(ifnull(plo.reporttype,0)=3,1,0)REPORTING_ERROR,1  AS TestNo ");
            sb.Append("    FROM `patient_labinvestigation_opd` plo  ");
            sb.Append("    INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append("    WHERE  plo.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND plo.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND im.`ReportType`=5 ");
            sb.Append("    )t GROUP BY MONTH  ");
 
        }
        else if (rbtActive.SelectedValue == "4")
        {
            Report_type = "Medical Assessment";

            sb.Append("    SELECT Month_Name MONTH, ");
            sb.Append("    SUM(Time_difference_Min)/COUNT(TransactionID) AS Average_TIME, ");
            sb.Append("    (SUM(IF(Time_difference_Min/60 < 1,1,0))/COUNT(TransactionID))*100 AS PerCentage_OF_IA, ");
            sb.Append("    (IF(SUM(Time_difference_Min)/COUNT(TransactionID)*.2 >  Time_difference_Min,1,0)/(COUNT(TransactionID)))*100 AS Outliers ");

            sb.Append("    FROM ( ");
            sb.Append("      SELECT MONTHNAME(dt.`DATETIME`)Month_Name ,dt.`TransactionID`,CONCAT(ArrivalDate,' ',ArrivalTime)DatetimeArrival,MIN(dt.`DATETIME`) DatetimeDRNotes,  ");
            sb.Append("      TIME_TO_SEC(TIMEDIFF((dt.`DATETIME`),(CONCAT(ArrivalDate,' ',ArrivalTime))))/60 AS Time_difference_Min ");
            sb.Append("      FROM cpoe_vital vital ");
            sb.Append("      inner join JOIN d_discharge_patienttemplate_time dt ON dt.`TransactionID`=vital.TransactionID ");
            sb.Append("      WHERE date(vital.`EntryDate`) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND date(vital.`EntryDate`) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("      GROUP BY dt.`TransactionID` ");
            sb.Append("    )t GROUP BY MONTH ");

        }
        else if (rbtActive.SelectedValue == "5")
        {
            Report_type = "Nursing Assessment";

            sb.Append("    SELECT Month_Name MONTH, ");
            sb.Append("    SUM(Time_difference_Min)/COUNT(TransactionID) AS Average_TIME, ");
            sb.Append("    (SUM(IF(Time_difference_Min < 30,1,0))/COUNT(TransactionID))*100 AS PerCentage_OF_IA, ");
            sb.Append("    (IF(SUM(Time_difference_Min)/COUNT(TransactionID)*.2 >  Time_difference_Min,1,0)/(COUNT(TransactionID)))*100 AS CCC ");

            sb.Append("    FROM ( ");
            sb.Append("    SELECT MONTHNAME(vital.`ArrivalDate`)Month_Name ,vital.`TransactionID`,MIN(EntryDate)EntryDate,");
            sb.Append("    CONCAT(vital.ArrivalDate,' ',vital.ArrivalTime)DatetimeArrival,  ");
            sb.Append("    TIME_TO_SEC(TIMEDIFF((vital.`EntryDate`),(CONCAT(vital.ArrivalDate,' ',vital.ArrivalTime))))/60 AS Time_difference_Min ");
            sb.Append("    FROM cpoe_vital vital ");

            sb.Append("    WHERE vital.`ArrivalDate` >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND vital.`ArrivalDate` <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
        	
            sb.Append("    GROUP BY vital.`TransactionID` ");
            sb.Append("    )t GROUP BY MONTH ");

        }
        else if (rbtActive.SelectedValue == "6")
        {
            Report_type = "Medical Assessment Detailed Report ";

            sb.Append("    SELECT MIN(dt.`DATETIME`) Datetime_DRNotes,pm.PNAME Patient_Name,ct.name Department,  ");
            sb.Append("    TIME_TO_SEC(TIMEDIFF((dt.`DATETIME`),(CONCAT(ArrivalDate,' ',ArrivalTime))))/60 AS Gap_Time_Minutes ");
            sb.Append("    FROM cpoe_vital vital ");
            sb.Append("    INNER JOIN d_discharge_patienttemplate_time dt ON dt.`TransactionID`=vital.`TransactionID`  ");
            sb.Append("    inner join patient_ipd_profile pip on pip.TransactionID=vital.TransactionID ");
            sb.Append("    inner join `ipd_case_type_master` ct on ct.IPDCaseTypeID=pip.IPDCaseTypeID  ");
            sb.Append("    inner join  patient_medical_history pmh on pmh.TransactionID  =pip.TransactionID  ");
            sb.Append("    inner join patient_master pm on pm.PatientID =pmh.PatientID  ");
            sb.Append("    WHERE vital.ArrivalDate >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND vital.ArrivalDate <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");   //   AND pip.status ='IN'   (Display Both Admitted & Dischage Patient) 10.01.2017 Gaurav
            sb.Append("    GROUP BY dt.`TransactionID`  ");

        }

        else if (rbtActive.SelectedValue == "7")
        {
            Report_type = "Nursing Assessment Detailed Report ";

            sb.Append("    SELECT MIN(vital.EntryDate)Nursing_AssessmentDate,pm.PNAME Patient_Name,ct.name Department, ");
            sb.Append("    TIME_TO_SEC(TIMEDIFF((vital.`EntryDate`), ");
            sb.Append("    (CONCAT(vital.ArrivalDate,' ',vital.ArrivalTime))))/60 AS Time_difference_Min ");
            sb.Append("    FROM cpoe_vital vital ");
            sb.Append("    INNER JOIN patient_ipd_profile pip ON pip.TransactionID=vital.TransactionID");
            sb.Append("    INNER JOIN `ipd_case_type_master` ct ON ct.IPDCaseTypeID=pip.IPDCaseTypeID  ");
            sb.Append("    INNER JOIN  patient_medical_history pmh ON pmh.TransactionID  =pip.TransactionID  ");
            sb.Append("    INNER JOIN patient_master pm ON pm.PatientID =pmh.PatientID  ");
            sb.Append("    WHERE vital.`ArrivalDate` >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND vital.`ArrivalDate` <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    GROUP BY vital.`TransactionID` ");   

        }
        else if (rbtActive.SelectedValue == "8")
        {
            Report_type = "HIA Detailed Report ";

            sb.Append("    select date_format(HIA.CreatedDateTime,'%d-%m-%Y')EntryDate ,replace(HIA.PatientID,'LSHHI','')MRNO,REPLACE(HIA.TransactionID,'ISHHI','')IPDNO, ");
            sb.Append("    HIA.PName Patient_Name,Ct.`Name` Department,HIA.ClinicalDiagnosis,HIA.AppearanceofanysignofPhlebitis Incidence,HIA.NoofIVCannulization No_OF_IV_Canula ");
            sb.Append("    ,HIA.AppearanceofanysignofCLRBI CAUTI,HIA.NoofCentralLineDays Central_Line,HIA.AppearanceofanysignofUTI CAUTI,HIA.NoofFoleysCatheterdays Foleys_Cath,HIA.AppearanceofanysignofPnemonia VAP, ");
            sb.Append("    HIA.Noofventilatordays Vantillator,HIA.AppearanceofsignofSSI SSI,HIA.TypeofSurgery,HIA.AppearanceofWorseningofExistingBedSore BedSores,HIA.RCA, ");
            sb.Append("    HIA.CorrectiveAction Corrective ,HIA.PreventativeAction Preventive,HIA.NameofICN ICN ");

            sb.Append("    from `MIS_HOSPITALACQUIREDINFECTION`  HIA  ");
            sb.Append("    INNER JOIN patient_ipd_profile pip ON pip.TransactionID=HIA.TransactionID ");
            sb.Append("    INNER JOIN `ipd_case_type_master` ct ON ct.IPDCaseTypeID=pip.IPDCaseTypeID  ");
            sb.Append("    where DATE(HIA.`CreatedDateTime`) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(HIA.`CreatedDateTime`) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    group by pip.`TransactionID` ");


        }
        else if (rbtActive.SelectedValue == "9")
        {
            Report_type = "NIA Detailed Report ";


            sb.Append("     SELECT NS.`Emp_Name`, NS.Designation,NS.NSI_BBF, ");
            sb.Append("     date_format(NS.Incident_Occurred_Date,'%d-%m-%Y')Incident_Occurred_Date,");
            sb.Append("     NS.Body_Site_of_Injury,NS.Injury_Caused_Device,   NS.Injury_Occurred_Department,");
            sb.Append("     NS.Infective_Status,NS.Vaccination_Status,NS.washing_wound_with_running_water_and_soap, ");
            sb.Append("     DATE_FORMAT(NS.Blood_Sample_Date,'%d-%m-%Y')Blood_Sample_Date,NS.Blood_Sample_Result, ");
            sb.Append("     DATE_FORMAT(NS.Sample_exposed_Date,'%d-%m-%Y')Sample_exposed_Date, ");
            sb.Append("     NS.Blood_test_Result,NS.Booster,DATE_FORMAT(NS.Booster_Date,'%d-%m-%Y')Booster_Date,");
            sb.Append("     NS.Complete_Series_of_HepB_Vaccine, ");
            sb.Append("     DATE_FORMAT(NS.Complete_Series_of_HepB_Vaccine_Date,'%d-%m-%Y')Complete_Series_of_HepB_Vaccine_Date, ");
            sb.Append("     NS.HBLG,DATE_FORMAT(NS.HBLG_Date,'%d-%m-%Y')HBLG_Date,NS.Basic_Regimen_HIV, ");
            sb.Append("     DATE_FORMAT(NS.Basic_Regimen_HIV_StartDate,'%d-%m-%Y')Basic_Regimen_HIV_StartDate, ");
            sb.Append("     NS.Expanded_Regimen_HIV,DATE_FORMAT(NS.Expanded_Regimen_HIV_StartDate,'%d-%m-%Y')Expanded_Regimen_HIV_StartDate, ");
            sb.Append("     NS.ELISA_for_Hiv_6_Week,   NS.Elisa_Result_6_Week,NS.HBsAg_6_Week, ");
            sb.Append("     NS.HBSAG_Result_6_Week,NS.ELISA_for_Hiv_12_Week,NS.ELISA_for_Hiv_12_Week_Result,   ");
            sb.Append("     NS.HBsAg_for_Hiv_12_Week,NS.HBsAg_for_Hiv_12_Week_Result,NS.Anti_HVC_16_Week,");
            sb.Append("     NS.Anti_HVC_16_Week_Result,   NS.ELISA_for_Hiv_24_Week, ");
            sb.Append("     NS.ELISA_for_Hiv_24_Week_Result,NS.Anti_HVC_24_Week,NS.Anti_HVC_24_Week_Result, ");
            sb.Append("     NS.RCA,    NS.PREVENTIVE_ACTION,NS.Remarks,NS.Sign_of_Chairman_HICC,NS.Entered_Date    ");
            sb.Append("     FROM    MIS_NiddleStick_Injury NS where  ");
            sb.Append("     DATE(NS.Entered_Date) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' ");
            sb.Append("     and DATE(NS.Entered_Date) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");


        }
        else if (rbtActive.SelectedValue == "10")
        {
            Report_type = "Patient Incident Report ";

            sb.Append("     SELECT REPLACE(IDetail.PatientID,'LSHHI','')MR_NO,REPLACE(IDetail.TransactionID,'ISHHI','')IPD_NO,IDetail.PNAME,");
            sb.Append("     DATE_FORMAT(IDetail.DOA,'%d-%b-%Y')DATE_OF_ADMISSION,IDetail.DoctorName,IDetail.Incident_Type,IDetail.Severity,IDetail.Incident_Date,IDetail.Incident_Detail,");
            sb.Append("     IDetail.Investigation_Team,IDetail.Analysis_Date,IDetail.Root_Cause_Analysis,IDetail.Lessons_Learnt,IDetail.Corrective_Action,IDetail.Preventive_Action,");
            sb.Append("     (SELECT NAME FROM employee_master WHERE employeeid=IDetail.`EnteredBy`)EnteredBy,");
            sb.Append("     IDetail.Entereddate FROM  mis_patient_incident_detail IDetail ");
            sb.Append("     where DATE(IDetail.EnteredDate) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' ");
            sb.Append("     and DATE(IDetail.EnteredDate) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");

        }
        else if (rbtActive.SelectedValue == "11")
        {
            Report_type = "OT Detailed Report ";

            sb.Append("     select PatientID,TransactionID,PNAME,DATE_FORMAT(DOA,'%d-%b-%Y')DOA,DoctorName,SurgeryName,");
            sb.Append("     Modification_of_Anesthesia_plan,  Unplanned_vantilation_following_Anesthesia,Adverse_Anesthesia_Event,");
            sb.Append("     Anesthesia_Related_Mortality,  Unplanned_Return_to_OT,Surgery_Rescheduled,");
            sb.Append("     Prevention_of_wrong_site_wrong_patient_wrong_surgery,  ");
            sb.Append("     Prophylactic_Antibiotic_given_with_in_difined_time_frame,");
            sb.Append("     Intraoperative_change_in_planned_surgery,  Re_exploration,Reason,(SELECT NAME FROM employee_master WHERE employeeid=CreatedBy)EnteredBy,DATE_FORMAT(CreatedDateTime,'%d-%b-%Y %h:%i %p')EnteredDate");
            sb.Append("     from MIS_OT_Detail ");
            sb.Append("     where DATE(CreatedDateTime) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     and DATE(CreatedDateTime) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
 
        }
        else if (rbtActive.SelectedValue == "12")
        {
            Report_type = "LAB Co-Relation Report ";

            sb.Append("     SELECT Month_Name,");
            sb.Append("   ROUND((SUM(IF(Correlating_clinical_Diagnosis,1,0))/COUNT(TransactionID))*100,2) AS PerCentage_OF_CO ");
            sb.Append("    FROM (	");
            sb.Append(" SELECT MONTHNAME(plo.`Date`)Month_Name ,plo.`Date`,item.`ItemID`,im.`Investigation_Id`,im.`Name`,plo.`TransactionID`, ");
            sb.Append(" 0 Correlating_clinical_Diagnosis ");
            sb.Append(" FROM patient_labinvestigation_opd plo INNER JOIN investigation_master im  ");
            sb.Append(" ON im.`Investigation_Id`= plo.`Investigation_ID` ");
            sb.Append(" INNER JOIN f_itemmaster item ON item.`Type_ID`= im.`Investigation_Id` ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=item.`SubCategoryID` ");

            // MOdify on 23-01-2020 - To include the MRI & CT Scan departments
            // sb.Append(" WHERE item.`IsActive`=1 AND sc.`SubCategoryID`='LSHHI144' ");
            sb.Append(" WHERE item.`IsActive`=1  ");
           // sb.Append(" WHERE item.`IsActive`=1 AND sc.SubCategoryID IN ('LSHHI144','LSHHI151','LSHHI150') ");//
            //

            sb.Append("  AND plo.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND plo.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("  ORDER BY MONTH(plo.`Date`) ");
            sb.Append("  )t GROUP BY Month_Name ORDER BY MONTH(DATE) ");
        }
        else if (rbtActive.SelectedValue == "13")
        {
            Report_type = "RADIO Co-Relation Report ";



            sb.Append(" SELECT Month_Name,DATE,");
            sb.Append(" (SUM(IF(Correlating_clinical_Diagnosis,1,0))/COUNT(TransactionID))*100 AS PerCentage_OF_CO_RADIO");
            sb.Append(" FROM (	");
            sb.Append(" SELECT MONTHNAME(plo.`Date`)Month_Name ,plo.`Date`,item.`ItemID`,im.`Investigation_Id`,im.`Name`,plo.`TransactionID`,   ");
            sb.Append(" 0 Correlating_clinical_Diagnosis  ");
            sb.Append(" FROM patient_labinvestigation_opd plo INNER JOIN investigation_master im ");
            sb.Append(" ON im.`Investigation_Id`= plo.`Investigation_ID` ");
            sb.Append(" INNER JOIN f_itemmaster item ON item.`Type_ID`= im.`Investigation_Id` ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=item.`SubCategoryID` ");
            sb.Append(" WHERE item.`IsActive`=1 ");
           // sb.Append(" WHERE item.`IsActive`=1 AND sc.`SubCategoryID`IN ('LSHHI151','LSHHI150') ");
            sb.Append(" AND plo.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND plo.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" ORDER BY MONTH(plo.`Date`)");

            sb.Append("   )t GROUP BY Month_Name ORDER BY MONTH(DATE) ");
 
        }
        else if (rbtActive.SelectedValue == "14")
        {
            Report_type = "Return To ICU within 48 Hours Report ";




            sb.Append(" SELECT Month_Name ,");
            sb.Append(" SUM(IFNULL(aa,0))/COUNT(TID)*100 AS RTI");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT SUM(ISReturn)aa,COUNT(TransactionID)TID,Month_Name,DateOfDischarge");
            sb.Append(" FROM (");

            sb.Append(" SELECT MONTHNAME(ich.`DateOfDischarge`)Month_Name,IF(pip.ISReturn =1,1,0)ISReturn,pip.`TransactionID`,");
            sb.Append(" ich.`DateOfDischarge`");
            sb.Append(" FROM `patient_ipd_profile` pip ");
            sb.Append(" INNER JOIN patient_medical_history ich ON ich.`TransactionID`= pip.`TransactionID`");
            sb.Append(" WHERE ich.`Status`='OUT'");
            sb.Append(" AND ich.`DateOfDischarge` >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND ich.`DateOfDischarge` <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
          
            //sb.Append(" AND pip.`IPDCaseTypeID` IN ('LSHHI15','LSHHI16','LSHHI18','LSHHI17','LSHHI19','LSHHI5')");


            sb.Append(" )t GROUP BY TransactionID");
            sb.Append(" )t2 GROUP BY MONTH(DateOfDischarge)");

        }
        else if (rbtActive.SelectedValue == "15")
        {
            Report_type = "Mortality Report";



            sb.Append(" SELECT MONTHNAME(ich.DateOfDischarge)MONTH_NAME,");
            sb.Append(" IFNULL(SUM(IF(UCASE(pmh.DischargeType)='EXPIRED' ,1,0)),0)/COUNT(ich.TransactionID)*100 AS Gross_Mortality_Rate,");
            sb.Append(" IFNULL(SUM(IF(TIMESTAMPDIFF(HOUR, CONCAT(ich.`DateOfAdmit`,' ',ich.`TimeOfAdmit`),CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge` ))>48 AND UCASE(pmh.DischargeType)='EXPIRED' ,1,0)),0)/(COUNT(ich.TransactionID)-IFNULL(SUM(IF(TIMESTAMPDIFF(HOUR, CONCAT(ich.`DateOfAdmit`,' ',ich.`TimeOfAdmit`),CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge` ))<=48 AND UCASE(pmh.DischargeType)='EXPIRED' ,1,0)),0)) * 100 AS Net_mortality_Rate");
            sb.Append(" FROM patient_medical_history pmh INNER JOIN patient_medical_history ich ON ");
            sb.Append(" pmh.TransactionID  = ich.TransactionID ");
            sb.Append(" WHERE  UCASE(ich.Status)<>'CANCEL' ");
            sb.Append(" AND DATE(ich.DateOfDischarge) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' ");
            sb.Append(" AND DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");

            sb.Append(" GROUP BY MONTH(ich.DateOfDischarge)");


        }
        else if (rbtActive.SelectedValue == "16")
        {
            Report_type = "Return to Casualty Within 72 Hours Report";


            sb.Append(" SELECT DATE_FORMAT(t.date,'%d-%m-%Y')Last_Visited_Date_Casualty,COUNT(lt.`PatientID`)No_Of_Visits,pm.`PName`,REPLACE(lt.`PatientID`,'LSHHI','') MR_NO");
            sb.Append(" FROM  `f_ledgertransaction` lt  INNER JOIN `f_ledgertnxdetail` ltd");
            sb.Append(" ON lt.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=lt.`PatientID`");
            sb.Append(" LEFT JOIN (");
            sb.Append(" SELECT MAX(lt.`Date`)DATE,lt.`PatientID` ");
            sb.Append(" FROM  `f_ledgertransaction` lt  INNER JOIN `f_ledgertnxdetail` ltd");
            sb.Append(" ON lt.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=lt.`PatientID`");
            sb.Append(" WHERE lt.`TypeOfTnx`='OPD-APPOINTMENT' AND ltd.`SubCategoryID`='LSHHI81'");
            sb.Append(" AND lt.`IsCancel` <> 1 AND lt.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND lt.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            sb.Append(" GROUP BY lt.`PatientID` HAVING COUNT(lt.`PatientID`)>1");

            sb.Append(" )t ON t.PatientID=lt.`PatientID`");
            sb.Append(" WHERE lt.`TypeOfTnx`='OPD-APPOINTMENT' AND ltd.`SubCategoryID`='LSHHI81'");
            sb.Append(" AND lt.`IsCancel` <> 1 AND lt.`Date`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND lt.`Date`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            sb.Append(" AND DATE(lt.`Date`) >= DATE_SUB(t.date, INTERVAL 3 DAY)");
            sb.Append(" GROUP BY lt.`PatientID` HAVING COUNT(lt.`PatientID`)>1");



        }
        else if (rbtActive.SelectedValue == "17")
        {
            Report_type = "Re-Intubation Report";

            sb.Append(" SELECT  Month_Name,");
            sb.Append(" SUM(IFNULL(aa,0))/COUNT(TID)*100 AS Re_Intubation");
            sb.Append(" FROM (");
            sb.Append(" SELECT SUM(Re_intubation)aa,COUNT(TransactionID)TID,Month_Name,dtEntry");
            sb.Append(" FROM (");
            sb.Append(" SELECT MONTHNAME(dtEntry)Month_Name,IF(Re_intubation='YES',1,0)Re_intubation,`TransactionID` ,dtEntry");
            sb.Append(" FROM  `f_indent_detail_patient`");
            sb.Append(" WHERE  itemname LIKE '%ET TUBE%' ");
            sb.Append(" AND DATE(dtEntry) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(dtEntry) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            sb.Append(" AND `RejectQty` =0 ");
            sb.Append(" )t GROUP BY TransactionID");
            sb.Append(" )t2 GROUP BY MONTH(dtEntry)");



        }
        else if (rbtActive.SelectedValue == "18")
        {
            Report_type = "Time taken For Discharge(In Hours) Report";


            sb.Append(" SELECT MONTH_NAME,(SUM(GAP_TIME)/COUNT(TID))*100 AS TimeTaken_for_Discharge FROM ( ");
            sb.Append(" SELECT ");
            sb.Append(" pip.`IntimationTime`,COUNT(ich.`TransactionID`)TID,ich.`DateOfDischarge`,MONTHNAME(ich.DateOfDischarge)MONTH_NAME,");
            sb.Append(" CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge`) DateOfDischarge11,");
            sb.Append(" TIMESTAMPDIFF(MINUTE, pip.`IntimationTime`,CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge` ))GAP_TIME");
            sb.Append(" FROM `patient_ipd_profile` pip INNER JOIN `patient_medical_history` ich ");
            sb.Append(" ON ich.`TransactionID`= pip.`TransactionID`");
            sb.Append(" INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ich.`TransactionID`");
            sb.Append(" WHERE pip.`IsDisIntimated` =1");
            sb.Append(" AND ich.`Status`='OUT' AND pmh.`PanelID`=1");
            sb.Append(" AND ich.DateOfDischarge >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND ich.DateOfDischarge <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            sb.Append(" GROUP BY ich.TransactionID");
            sb.Append(" )t GROUP BY MONTH(DateOfDischarge)");



        }
        else if (rbtActive.SelectedValue == "19")
        {
            Report_type = "ICU Equipment Utilization Report";



            sb.Append(" SELECT ");
            sb.Append(" MONTHNAME(LT.BillDate)MONTH_NAME,");
            sb.Append(" ROUND((SUM(ltd.`Quantity`)/(7*DAY(LAST_DAY(LT.BillDate))))*100,3) AS Equipment_Utilization");
            sb.Append(" FROM f_ledgertnxdetail ltd ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`");
            sb.Append(" INNER JOIN patient_medical_history adj ON lt.`TransactionID`=adj.TransactionID");
            sb.Append(" WHERE  LT.IsCancel = 0 AND LTD.IsFree = 0   AND LTD.IsVerified =1 ");
            sb.Append(" AND (adj.BillNo IS NOT NULL) AND adj.billNo <> ''");
            sb.Append(" AND  DATE(LT.BillDate) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(LT.BillDate) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
           // sb.Append(" AND ltd.itemid IN ('LSHHI25688','LSHHI23294','LSHHI23569')");//add infusion pump LSHHI23569
            sb.Append(" GROUP BY MONTH(LT.BillDate)");



        }
        else if (rbtActive.SelectedValue == "20")
        {
            Report_type = "ICU BED Utilization Report";


            sb.Append(" SELECT  ");
            sb.Append(" MONTHNAME(LT.BillDate)MONTH_NAME, ");

            sb.Append(" CASE LTD.ITEMID WHEN 'LSHHI24347' THEN 'CCU' WHEN 'LSHHI24341' THEN 'CTVS' WHEN 'LSHHI24350' THEN 'HDU/ICU' ");
            sb.Append(" WHEN 'LSHHI24344' THEN 'PICU' WHEN 'LSHHI23825' THEN 'NICU_OLD' WHEN 'LSHHI24338' THEN 'NICU_NEW'");
            sb.Append(" ELSE 'NA' END AS UTILIZATION_TYPE,");

            sb.Append(" CASE LTD.ITEMID WHEN 'LSHHI24347' THEN ROUND((SUM(ltd.`Quantity`)/(7*DAY(LAST_DAY(LT.BillDate))))*100,3) ");
            sb.Append(" WHEN 'LSHHI24341' THEN  ROUND((SUM(ltd.`Quantity`)/(3*DAY(LAST_DAY(LT.BillDate))))*100,3)");
            sb.Append(" WHEN 'LSHHI24350' THEN ROUND((SUM(ltd.`Quantity`)/(12*DAY(LAST_DAY(LT.BillDate))))*100,3)");//add 3 bed
            sb.Append(" WHEN 'LSHHI24344' THEN ROUND((SUM(ltd.`Quantity`)/(3*DAY(LAST_DAY(LT.BillDate))))*100,3)");
            sb.Append(" WHEN 'LSHHI23825' THEN ROUND((SUM(ltd.`Quantity`)/(7*DAY(LAST_DAY(LT.BillDate))))*100,3) ");
            sb.Append(" WHEN 'LSHHI24338' THEN ROUND((SUM(ltd.`Quantity`)/(7*DAY(LAST_DAY(LT.BillDate))))*100,3)");
            sb.Append(" ELSE 'NA' END AS UTILIZATION_RATE ");

            sb.Append(" FROM f_ledgertnxdetail ltd ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`");
            sb.Append(" INNER JOIN patient_medical_history adj ON lt.`TransactionID`=adj.TransactionID");
            sb.Append(" WHERE  LT.IsCancel = 0 AND LTD.IsFree = 0   AND LTD.IsVerified =1 ");
            sb.Append(" AND (adj.BillNo IS NOT NULL) AND adj.billNo <> ''");
            sb.Append(" AND  DATE(LT.BillDate) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(LT.BillDate) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            
            
            //sb.Append(" AND ltd.itemid IN ('LSHHI24347','LSHHI24341','LSHHI24350','LSHHI23155','LSHHI23825','LSHHI24338','LSHHI24344')");
            
            sb.Append(" GROUP BY MONTH(LT.BillDate),LTD.`ItemID`");


        }
        else if (rbtActive.SelectedValue == "21")
        {
            Report_type = "Missing Record Report";


            sb.Append(" SELECT SUM(MissingFiles)/COUNT(Total_Discharge)*100 AS Missing_Record,");
            sb.Append(" MONTH_NAME FROM ( ");
            sb.Append(" SELECT  ");
            sb.Append(" IF(MRD_IsFile=1 AND DATEDIFF(ich.`ReceiveFile_Date`,CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge`))>30 ,1,0)MissingFiles,COUNT(ich.`TransactionID`)Total_Discharge,");
            sb.Append(" ich.`MRD_IsFile`,MONTHNAME(ich.`DateOfDischarge`)MONTH_NAME, ");
            sb.Append(" ich.`ReceiveFile_Date` ,CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge`)DateOfDischarge, ");
            sb.Append(" DATEDIFF(ich.`ReceiveFile_Date`,CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge`)) c  ");
            sb.Append(" FROM patient_medical_history ich WHERE  ");
            sb.Append(" ich.`Status`='OUT' AND DATE(ich.`DateOfDischarge`) >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' ");
            sb.Append(" AND DATE(ich.`DateOfDischarge`)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" GROUP BY ich.`TransactionID` ");
            sb.Append(" )t  GROUP BY MONTH(DateOfDischarge) ");


        }
        else if (rbtActive.SelectedValue == "22")
        {
            Report_type = "Incident Reporting";


            sb.Append(" SELECT  ");
            sb.Append(" MONTHNAME(Entereddate)MONTH_NAME, ");
            sb.Append(" SUM(IF(Severity='Sentinnel Event' AND DATEDIFF(Analysis_Date,Incident_Date) <=1 ,1,0))/SUM(IF(Severity='Sentinnel Event',1,0))*100 AS Sentinnel_Event,");
            sb.Append(" SUM(IF(Severity='Adverse Event' AND DATEDIFF(Analysis_Date,Incident_Date) <=1,1,0))/SUM(IF(Severity='Adverse Event',1,0))*100 AS Adverse_Event,");
            sb.Append(" SUM(IF(Severity='Near Miss',1,0))/COUNT(`TransactionID`)*100 AS Near_Miss");

            sb.Append(" FROM `mis_patient_incident_detail` ");
            sb.Append(" WHERE DATE(Entereddate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(Entereddate) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            sb.Append(" GROUP BY MONTH(Entereddate)");


        }
        else if (rbtActive.SelectedValue == "23")
        {
            Report_type = "HAI Indicator Report";



            sb.Append(" SELECT MONTHNAME(Entereddate)MONTH_NAME, ");
            sb.Append(" ROUND(SUM(AppearanceofanysignofPhlebitis)/SUM(NoofIVCannulization)*100,3) AS Incidence_of_Phlebitis, ");
            sb.Append(" ROUND(SUM(AppearanceofanysignofCLRBI)/SUM(NoofCentralLineDays)*1000,3)AS CABS_Infection_Rate, ");
            sb.Append(" ROUND(SUM(AppearanceofanysignofUTI)/SUM(NoofFoleysCatheterdays)*1000,3) AS CAUTI_Rate, ");
            sb.Append(" ROUND(SUM(AppearanceofanysignofPnemonia)/SUM(Noofventilatordays)*1000,3) AS VAP_Rate, ");
            sb.Append(" ROUND(SUM(AppearanceofsignofSSI)/SUM(Surgery)*100,3) AS SSI_Total_Rate, ");
            sb.Append(" ROUND(SUM(IF(TypeofSurgery='Herniorraphy',AppearanceofsignofSSI,0))/SUM(IF(TypeofSurgery='Herniorraphy',1,0))*100,3) AS Herniorraphy_SSI_Rate, ");
            sb.Append(" ROUND(SUM(IF(TypeofSurgery='CABG',AppearanceofsignofSSI,0))/SUM(IF(TypeofSurgery='CABG',1,0))*100,3) AS CABG_SSI_Rate, ");
            sb.Append(" ROUND(SUM(IF(TypeofSurgery='C Section',AppearanceofsignofSSI,0))/SUM(IF(TypeofSurgery='C Section',1,0))*100,3) AS C_Section_SSI_Rate, ");
            sb.Append(" ROUND(SUM(IF(TypeofSurgery='Cholecystectomy',AppearanceofsignofSSI,0))/SUM(IF(TypeofSurgery='Cholecystectomy',1,0))*100,3) AS Cholecystectomy_SSI_Rate,");
            sb.Append(" ROUND(SUM(AppearanceofWorseningofExistingBedSore)/  ");
            sb.Append(" (SELECT COUNT(TransactionID)PatientDays FROM patient_ipd_profile pip INNER JOIN  (  ");
            sb.Append(" SELECT * FROM temp_for_date WHERE DATE(dt)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(dt)<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'      ) tfd  ");
            sb.Append(" WHERE UCASE(pip.Status)<>'CANCEL' AND CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','23:59:59') ");
            sb.Append(" AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >=  ");
            sb.Append(" CONCAT(tfd.dt,' ','23:59:59'))*1000,3)Incidence_Of_Bed_Sores ");


            sb.Append(" FROM `MIS_HOSPITALACQUIREDINFECTION` ");
            sb.Append(" WHERE date(CreatedDateTime) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND date(CreatedDateTime) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" GROUP BY MONTH(CreatedDateTime) ");


        }
        else if (rbtActive.SelectedValue == "24")
        {
            Report_type = "NSI/BBF Indicator Report";



            sb.Append(" SELECT MONTHNAME(Entered_Date)MONTH_NAME, ");

            sb.Append(" ROUND(SUM(IF(NSI_BBF='NSI',1,0))/  ");
            sb.Append(" (SELECT COUNT(TransactionID)PatientDays FROM patient_ipd_profile pip INNER JOIN  (  ");
            sb.Append(" SELECT * FROM temp_for_date WHERE DATE(dt)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(dt)<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'      ) tfd  ");
            sb.Append(" WHERE UCASE(pip.Status)<>'CANCEL' AND CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','23:59:59')   ");
            sb.Append(" AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >=  ");
            sb.Append(" CONCAT(tfd.dt,' ','23:59:59'))*1000,3)NSI, ");

            sb.Append(" ROUND(SUM(IF(NSI_BBF='BBF',1,0))/  ");
            sb.Append(" (SELECT COUNT(TransactionID)PatientDays FROM patient_ipd_profile pip INNER JOIN  (  ");
            sb.Append(" SELECT * FROM temp_for_date WHERE DATE(dt)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(dt)<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'      ) tfd ");
            sb.Append(" WHERE UCASE(pip.Status)<>'CANCEL' AND CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','23:59:59') ");
            sb.Append(" AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >= ");
            sb.Append(" CONCAT(tfd.dt,' ','23:59:59'))*1000,3)BBF ");

            sb.Append(" FROM `mis_niddlestick_injury` ");
            sb.Append(" WHERE Entered_Date >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND Entered_Date <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            sb.Append(" GROUP BY MONTH(Entered_Date)");



        }
        else if (rbtActive.SelectedValue == "25")
        {
            Report_type = "OT Indicator Report";



            sb.Append(" SELECT MONTHNAME(CreatedDateTime)MONTH_NAME, ");

            sb.Append(" IFNULL(ROUND(SUM(IF(Modification_of_Anesthesia_plan='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(TransactionID)Nos FROM ot_surgerydetail WHERE IS_PAC=2 ");
            sb.Append(" AND  DATE(EntData)>= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(EntData)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'),0)*100,3),0) Modification_of_Anesthesia_plan, ");

            sb.Append(" IFNULL(ROUND(SUM(IF(Unplanned_vantilation_following_Anesthesia='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(TransactionID)Nos FROM ot_surgerydetail WHERE IS_PAC=2 ");
            sb.Append(" AND  DATE(EntData)>= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(EntData)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'),0)*100,3),0) Unplanned_vantilation_following_Anesthesia, ");


            sb.Append(" IFNULL(ROUND(SUM(IF(Adverse_Anesthesia_Event='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(TransactionID)Nos FROM ot_surgerydetail WHERE IS_PAC=2 ");
            sb.Append(" AND  DATE(EntData)>= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(EntData)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'),0)*100,3),0) Adverse_Anesthesia_Event, ");

            sb.Append(" IFNULL(ROUND(SUM(IF(Anesthesia_Related_Mortality='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(TransactionID)Nos FROM ot_surgerydetail WHERE IS_PAC=2 ");
            sb.Append(" AND  DATE(EntData)>= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND DATE(EntData)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'),0)*100,3),0) Anesthesia_Related_Mortality, ");

            sb.Append(" IFNULL(ROUND(SUM(IF(Unplanned_Return_to_OT='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(ledgertransactionNo) ");
            sb.Append(" FROM f_ledgertnxdetail WHERE IsVerified=1 AND entrydate>=CONCAT('" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "',' ','00:00:00') ");
            sb.Append(" AND entrydate <=CONCAT('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "',' ','23:23:59') AND issurgery=1),0)*100,3),0) Unplanned_Return_to_OT, ");


            sb.Append(" IFNULL(ROUND(SUM(IF(Surgery_Rescheduled='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(ledgertransactionNo)  ");
            sb.Append(" FROM f_ledgertnxdetail WHERE IsVerified=1 AND entrydate>=CONCAT('" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "',' ','00:00:00') ");
            sb.Append(" AND entrydate <=CONCAT('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "',' ','23:23:59') AND issurgery=1),0)*100,3),0) Surgery_Rescheduled, ");


            sb.Append(" IFNULL(ROUND(SUM(IF(Prevention_of_wrong_site_wrong_patient_wrong_surgery='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(ledgertransactionNo) ");
            sb.Append(" FROM f_ledgertnxdetail WHERE IsVerified=1 AND entrydate>=CONCAT('" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "',' ','00:00:00') ");
            sb.Append(" AND entrydate <=CONCAT('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "',' ','23:23:59') AND issurgery=1),0)*100,3),0) Prevention_of_wrong_site_wrong_patient_wrong_surgery,");

            sb.Append(" IFNULL(ROUND(SUM(IF(Prophylactic_Antibiotic_given_with_in_difined_time_frame='YES',1,0))/");
            sb.Append(" IFNULL((SELECT COUNT(ledgertransactionNo) ");
            sb.Append(" FROM f_ledgertnxdetail WHERE IsVerified=1 AND entrydate>=CONCAT('" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "',' ','00:00:00')");
            sb.Append(" AND entrydate <=CONCAT('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "',' ','23:23:59') AND issurgery=1),0)*100,3),0) Prophylactic_Antibiotic_given_with_in_difined_time_frame,");

            sb.Append(" IFNULL(ROUND(SUM(IF(Intraoperative_change_in_planned_surgery='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(ledgertransactionNo)  ");
            sb.Append(" FROM f_ledgertnxdetail WHERE IsVerified=1 AND entrydate>=CONCAT('" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "',' ','00:00:00') ");
            sb.Append(" AND entrydate <=CONCAT('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "',' ','23:23:59') AND issurgery=1),0)*100,3),0) Intraoperative_change_in_planned_surgery, ");

            sb.Append(" IFNULL(ROUND(SUM(IF(Re_exploration='YES',1,0))/ ");
            sb.Append(" IFNULL((SELECT COUNT(ledgertransactionNo)  ");
            sb.Append(" FROM f_ledgertnxdetail WHERE IsVerified=1 AND entrydate>=CONCAT('" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "',' ','00:00:00') ");
            sb.Append(" AND entrydate <=CONCAT('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "',' ','23:23:59') AND issurgery=1),0)*100,3),0) Re_exploration ");


            sb.Append(" FROM `mis_ot_detail`  ");
            sb.Append(" WHERE date(CreatedDateTime) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND date(CreatedDateTime) <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" GROUP BY MONTH(CreatedDateTime) ");

        }
        else if (rbtActive.SelectedValue == "26")
        {
            Report_type = "OT Utilization Report";

            sb.Append(" SELECT MONTHNAME(Start_DateTime)MONTH_NAME,OT,");
            sb.Append(" ROUND((SUM(TIMESTAMPDIFF(MINUTE,Start_DateTime,End_Datetime)/60)/ ");
            sb.Append(" (DATEDIFF('" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "')*24)*100),3) AS OT_UTILIZATION ");
            sb.Append(" FROM `ot_surgery_schedule` ");
            sb.Append(" WHERE Start_DateTime >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND Start_DateTime <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" GROUP BY OT,MONTH(Start_DateTime)");

        }
        else if (rbtActive.SelectedValue == "27")
        {
            Report_type = "Drug Procured By LP Report";

            sb.Append(" SELECT  ");
            sb.Append(" MONTHNAME(CreaterDateTime)MONTH_NAME, ");
            sb.Append(" (COUNT(IM.`ItemID`)/(SELECT COUNT(IM.`ItemID`) FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
            sb.Append(" INNER JOIN `f_categorymaster` cm ON cm.`CategoryID`=sc.`CategoryID` ");
            sb.Append(" INNER JOIN `f_configrelation` cr ON cr.`CategoryID`=cm.`CategoryID`");
            sb.Append(" WHERE cr.`ConfigID`=11 ");
            sb.Append(" AND im.`IsActive`=1 )*100)DRUG_PROCURED_BY_LP ");

            sb.Append(" FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
            sb.Append(" INNER JOIN `f_categorymaster` cm ON cm.`CategoryID`=sc.`CategoryID` ");
            sb.Append(" INNER JOIN `f_configrelation` cr ON cr.`CategoryID`=cm.`CategoryID` ");
            sb.Append(" WHERE cr.`ConfigID`=11 ");
            sb.Append(" AND im.`IsActive`=1  ");
            sb.Append(" AND im.`CreaterDateTime` >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND im.`CreaterDateTime` <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" GROUP BY MONTH(CreaterDateTime) ");

        }
        else if (rbtActive.SelectedValue == "28")
        {
            Report_type = "Rejecttion Before GRN Report";

            sb.Append(" SELECT MONTHNAME(PRA.`RaisedDate`) MONTH_NAME, ");
            sb.Append(" ROUND((SUM(IF(PRA.`Status`=2 AND PRA.`Approved`=2 AND PRD.`RequestedQty` <> PRD.`ApprovedQty` ,1,0))/ ");
            sb.Append(" COUNT(PRD.`PurchaseRequisitionNo`))*100,2)AS CAHNGES_BPOG ");
            sb.Append(" FROM f_purchaserequestdetails PRD  ");
            sb.Append(" INNER JOIN  `f_purchaserequestmaster` PRA ON PRA.`PurchaseRequestNo`=PRD.`PurchaseRequisitionNo` ");
            sb.Append(" WHERE PRA.`Status`=2 AND PRA.`Approved`=2  ");
            sb.Append(" AND PRA.`RaisedDate`>= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' AND PRA.`RaisedDate`<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
            sb.Append(" AND PRA.`StoreID`='STO00001' ");
            sb.Append(" GROUP BY MONTH(PRA.`RaisedDate`)");

        }
        else if (rbtActive.SelectedValue == "29")
        {
            Report_type = "Re-Intubation Detailed Report";

            sb.Append(" SELECT ItemName,Re_intubation,Re_Intubation_Reason, REPLACE(TransactionID,'ISHHI','')IPD_NO, ");
            sb.Append(" (SELECT PNAME FROM PATIENT_MASTER PM INNER JOIN `patient_medical_history` PMH  ");
            sb.Append(" ON pmh.PatientID =pm.PatientID WHERE pmh.TransactionID =DT.`TransactionID`)PNAME, ");
            sb.Append(" (SELECT NAME FROM EMPLOYEE_MASTER WHERE employeeid=DT.UserId)ENTEREDBY ");
            sb.Append(" FROM f_indent_detail_patient DT WHERE (`Re_intubation` IS NOT NULL) AND Re_intubation<>'' ");
            sb.Append(" AND DATE(dtEntry)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "' ");
            sb.Append(" AND DATE(dtEntry)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");

        }
        else if (rbtActive.SelectedValue == "30")
        {
            Report_type = "Return To ICU Detailed Report";

            sb.Append(" SELECT  REPLACE(DT.TransactionID,'ISHHI','')IPD_NO, ");
            sb.Append(" (SELECT PNAME FROM PATIENT_MASTER PM INNER JOIN `patient_medical_history` PMH  ");
            sb.Append(" ON pmh.PatientID =pm.PatientID WHERE pmh.TransactionID =DT.`TransactionID`)PNAME, ");
            sb.Append(" DT.ISReturn,'' Reason ,CONCAT(StartDate,StartTime)RETURN_DATE, ");
            sb.Append(" (SELECT NAME FROM EMPLOYEE_MASTER WHERE employeeid=DT.UserID)ENTEREDBY ");
            sb.Append(" FROM patient_ipd_profile  DT ");

            sb.Append(" WHERE (DT.`ISReturn` IS NOT NULL) AND DT.ISReturn<>'' ");
            sb.Append(" AND DATE(DT.StartDate)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "'  ");
            sb.Append(" AND DATE(DT.StartDate)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");

        }
        else if (rbtActive.SelectedValue == "31")
        {
            Report_type = "Time taken For Discharge In Detail Report";

            sb.Append(" SELECT CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,REPLACE(ich.`TransactionID`,'ISHHI','')IPNo, DATE_FORMAT(ich.`DateOfAdmit`,'%d-%b-%Y') AdmissionDate,DATE_FORMAT(ich.`TimeOfAdmit`,'%I:%i %p') AdmissionTime,DATE_FORMAT(pip.`IntimationTime`,'%d-%b-%Y') DischargeIntimationDate,DATE_FORMAT(pip.`IntimationTime`,'%I:%i %p') DischargeIntimationTime,DATE_FORMAT(ich.`DateOfDischarge`,'%d-%b-%Y') DischargeDate  ");
            sb.Append(" ,DATE_FORMAT(ich.`TimeOfDischarge`,'%I:%i %p') DischargeTime ");
            sb.Append(" FROM `patient_ipd_profile` pip  ");
            sb.Append(" INNER JOIN `patient_medical_history` ich ON ich.`TransactionID`= pip.`TransactionID` ");
            sb.Append(" INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`= ich.`TransactionID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append(" WHERE pip.`IsDisIntimated` =1 ");
            sb.Append(" AND ich.`Status`='OUT' AND pmh.`PanelID`=1 ");
            sb.Append(" AND ich.DateOfDischarge >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + "'  ");
            sb.Append(" AND ich.DateOfDischarge <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" GROUP BY ich.TransactionID ORDER BY CONCAT(ich.`DateOfDischarge`,' ',ich.`TimeOfDischarge`) ");
        }
        else if (rbtActive.SelectedValue == "32")
        {
            Report_type = "Dispensing time of medication in Detailed Report";

            sb.Append(" SELECT CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,REPLACE(adj.`TransactionID`,'ISHHI','')IPNo, id.`IndentNo`, ");
            sb.Append(" DATE_FORMAT(id.`dtEntry`,'%d-%b-%Y') IndentRiseDate, ");
            sb.Append(" DATE_FORMAT(id.`dtEntry`,'%I:%i %p') IndentRiseTime, ");
            sb.Append(" IFNULL(DATE_FORMAT(IFNULL((SELECT CONCAT(sd.`Date`,' ',sd.`Time`) FROM f_salesdetails sd  ");
            sb.Append(" WHERE sd.`IndentNo`=id.`IndentNo` LIMIT 1),''),'%d-%b-%Y'),'Not-Issue') IssueDate, ");

            sb.Append(" IFNULL(DATE_FORMAT(IFNULL((SELECT CONCAT(sd.`Date`,' ',sd.`Time`) FROM f_salesdetails sd  ");
            sb.Append(" WHERE sd.`IndentNo`=id.`IndentNo` LIMIT 1),''),'%I:%i %p'),'Not-Issue') IssueTime ");

            sb.Append(" FROM `f_indent_detail_patient` id  ");
            sb.Append(" INNER JOIN patient_medical_history adj ON adj.`TransactionID`=id.`TransactionID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=adj.`PatientID` ");
            sb.Append(" WHERE  id.`dtEntry`>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd")  + " 00:00:00' ");
            sb.Append(" AND id.`dtEntry`<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" GROUP BY id.`IndentNo` ORDER BY id.`IndentNo` ");
        }

        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            lblErrorMsg.Text = dt.Rows.Count + " Record(s) Found";
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = Report_type;
            Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

        }
        else
           lblErrorMsg.Text = "No Record Found";
    }
}
