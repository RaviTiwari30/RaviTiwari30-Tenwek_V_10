using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_MRD_MRDDashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            ucDateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00 AM";
            txtToTime.Text = "11:59 PM";
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnissue);
        }
        ucDateFrom.Attributes.Add("readonly", "readonly");
        ucDateTo.Attributes.Add("readonly", "readonly");
    }
    
    protected void btnissue_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        string startDate = string.Empty, toDate = string.Empty;
        if (Util.GetDateTime(ucDateFrom.Text).ToString() != "")
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss");
            else
                startDate = Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd");
        if (Util.GetDateTime(ucDateTo.Text).ToString() != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtToTime.Text.Trim()).ToString("HH:mm") + ":59";
            else
                toDate = Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + " 23:59:59";

        if (txtIPDno.Text.Trim() != "")
        {
            txtIPDno.Text = StockReports.getTransactionIDbyTransNo(txtIPDno.Text.Trim());
            
        }


        StringBuilder sb = new StringBuilder();
        string ReportName = "";
        if (rbtnreport.SelectedValue == "1")
        {
            sb.Append(" SELECT cm.CentreName,pm.PatientID UHID,IFNULL(epd.EmergencyNo,'')EOP,CONCAT(pm.title,' ',pm.PFirstName)NAME,pm.PLastName OtherName, ");
            sb.Append("pm.Gender,pm.Age,  (SELECT CONCAT(title,' ',NAME)RegisterBy FROM Employee_master WHERE EmployeeID=RegisterBy)SeenBy,IFNULL(icd.ICD_Code,'')ICD_Code ");
            sb.Append(",(SELECT pd.ProvisionalDiagnosis FROM cpoe_PatientDiagnosis pd WHERE pd.TransactionID=pmh.TransactionID)ProvisionalDiagnosis, ");
            sb.Append("IFNULL(IF(PMH.Type='IPD',pmh.Transno,''),'')IPNo, ");
            sb.Append("IFNULL((SELECT CONCAT(title,'',NAME) FROM doctor_master WHERE DoctorID=pmh.DoctorID),'')PrimaryConsultant, ");
            sb.Append("IFNULL((SELECT SPECIALIZATION FROM doctor_master WHERE DoctorID=pmh.DoctorID),'')Speciality, ");
            sb.Append("IFNULL((SELECT CONCAT(rm.name,'/',rm.Bed_No) FROM room_master rm WHERE pip.RoomID=rm.roomID),'')BedNo, ");
            sb.Append(" (SELECT COUNT(*) FROM patient_medical_history WHERE CONCAT(dateofadmit,' ',timeofadmit)>='" + startDate + "' AND CONCAT(dateofadmit,' ',timeofadmit)<='" + toDate + "')TotalAdmission ");
            sb.Append(" ,(SELECT COUNT(*) FROM emergency_patient_details epd WHERE epd.IsReleased=2 AND epd.ReleasedDateTime>='" + startDate + "' AND epd.ReleasedDateTime<='" + toDate + "')totalEmertoIPD ");
            sb.Append("FROM Patient_master pm  ");
            sb.Append("INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID ");
            sb.Append("INNER JOIN center_master cm ON pm.CentreID=cm.CentreID  ");
            sb.Append("LEFT JOIN emergency_patient_details epd ON pm.PatientID=epd.PatientId ");
            sb.Append("LEFT JOIN icd_10cm_patient icd ON pmh.TransactionID=icd.TransactionID ");
            sb.Append("LEFT JOIN patient_ipd_profile pip ON pip.TransactionID=pmh.TransactionID ");
            sb.Append("WHERE pm.DateEnrolled>='" + startDate + "' AND pm.DateEnrolled<='" + toDate + "'  ");
            if (txtUHID.Text.Trim() != "")
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            if (txtIPDno.Text.Trim() != "")
            {
                txtIPDno.Text = StockReports.getTransactionIDbyTransNo(txtIPDno.Text.Trim());
                sb.Append(" AND pmh.TransactionID='" + txtIPDno.Text.Trim() + "'");
            }
            sb.Append("AND cm.CentreID IN (" + Centre + ") GROUP BY Pm.PatientID ORDER BY pm.DateEnrolled ");

            ReportName = "Patient Master File";
        }
        else if (rbtnreport.SelectedValue == "2")
        {
            sb.Append(" SELECT cm.CentreName,pm.PatientID UHID,IFNULL(epd.EmergencyNo,'')EOP,CONCAT(pm.title,' ',pm.PFirstName)NAME,pm.PLastName OtherName, ");
            sb.Append("pm.Gender,pm.Age,  (SELECT CONCAT(title,' ',NAME)RegisterBy FROM Employee_master WHERE EmployeeID=RegisterBy)SeenBy,IFNULL(icd.ICD_Code,'')ICD_Code ");
            sb.Append(",(SELECT pd.ProvisionalDiagnosis FROM cpoe_PatientDiagnosis pd WHERE pd.TransactionID=pmh.TransactionID)ProvisionalDiagnosis, ");
            sb.Append("IFNULL( IF(PMH.Type='IPD',pmh.Transno,''),'')IPNo, ");
            sb.Append("IFNULL((SELECT CONCAT(title,'',NAME) FROM doctor_master WHERE DoctorID=pmh.DoctorID),'')PrimaryConsultant, ");
            sb.Append("IFNULL((SELECT SPECIALIZATION FROM doctor_master WHERE DoctorID=pmh.DoctorID),'')Speciality, ");
            sb.Append("IFNULL((SELECT CONCAT(rm.name,'/',rm.Bed_No) FROM room_master rm WHERE pip.RoomID=rm.roomID),'')BedNo, ");
            sb.Append(" (SELECT COUNT(*) FROM patient_medical_history WHERE CONCAT(dateofadmit,' ',timeofadmit)>='" + startDate + "' AND CONCAT(dateofadmit,' ',timeofadmit)<='" + toDate + "')TotalAdmission ");
            sb.Append(" ,(SELECT COUNT(*) FROM emergency_patient_details epd WHERE epd.IsReleased=3 AND epd.ReleasedDateTime>='" + startDate + "' AND epd.ReleasedDateTime<='" + toDate + "')totalEmertoIPD ");
            sb.Append("FROM Patient_master pm  ");
            sb.Append("INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID ");
            sb.Append("INNER JOIN center_master cm ON pm.CentreID=cm.CentreID  ");
            sb.Append("inner JOIN emergency_patient_details epd ON pm.PatientID=epd.PatientId  AND epd.IsReleased=3 ");
            sb.Append("LEFT JOIN icd_10cm_patient icd ON pmh.TransactionID=icd.TransactionID ");
            sb.Append("inner JOIN patient_ipd_profile pip ON pip.TransactionID=pmh.TransactionID ");
            sb.Append("WHERE pm.DateEnrolled>='" + startDate + "' AND pm.DateEnrolled<='" + toDate + "'  ");
            if (txtUHID.Text.Trim() != "")
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            if (txtIPDno.Text.Trim() != "")
                sb.Append(" AND pmh.TransactionID='" + txtIPDno.Text.Trim() + "'");
            sb.Append("AND cm.CentreID IN (" + Centre + ") GROUP BY Pm.PatientID ORDER BY pm.DateEnrolled ");

            ReportName = "EmerGencyToIPDPatientRegister";
        }
        else if (rbtnreport.SelectedValue == "3")
        {

        }
        else if (rbtnreport.SelectedValue == "4")//Current IP Patient Register
        {
            sb.Append(" SELECT ip.PatientID UHID,IF(PMH.Type='IPD',pmh.Transno,'')IP, CONCAT(pm.Title,' ',pm.PFirstName)NAME,pm.PLastName OtherName,pm.Gender sex,pm.Age,  ");
            sb.Append(" DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')CheckInDate,TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')checkinTime,cm.CentreName ");
            sb.Append(" ,CONCAT(rm.Name,'/',rm.Room_No,'/',rm.Bed_No,'/',rm.Floor)Location, DATEDIFF(CURRENT_DATE(),pmh.DateOfAdmit)AS BedDays ");
            sb.Append(" ,pmh.status,CONCAT(dm.Title,' ',dm.Name)PrimaryConsultant,dm.SPECIALIZATION, ");
            sb.Append(" IFNULL((SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis WHERE TransactionID=ip.TransactionID),'')Diagnosis, ");
            sb.Append(" (SELECT COUNT(*)AdmitCount FROM patient_ipd_profile WHERE STATUS='IN' AND CentreID IN (" + Centre + "))totalAdmitPatient ");
            sb.Append(" FROM patient_ipd_profile ip  ");
            sb.Append(" INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID  ");
            sb.Append(" INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID  ");
            sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID  ");
            sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID   ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID  ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   ");
            sb.Append(" WHERE ip.Status = 'IN' AND pmh.CentreID IN (" + Centre + ")    ");
            ReportName = "CurrentIPPatientRegister";
        }
        else if (rbtnreport.SelectedValue == "5")
        {
        }
        else if (rbtnreport.SelectedValue == "6")//Hiv Lab Test Register
        {
            sb.Append(" SELECT cm.CentreName,pm.PatientID UHID,CONCAT(pm.Title,'',pm.PFirstName)Firstname,''MiddleName,pm.PLastName,pm.DOB DateofBirth, ");
            sb.Append(" pm.country,inv.Name TestName,MONTHNAME(plo.Date)MONTH,YEAR(plo.Date)YEAR  ");
            sb.Append(" FROM patient_labinvestigation_Opd plo  ");
            sb.Append(" INNER JOIN investigation_master inv ON plo.Investigation_ID=inv.Investigation_Id ");
            sb.Append(" INNER JOIN patient_master pm ON plo.PatientID=pm.PatientID INNER JOIN center_master cm ON plo.CentreID=cm.CentreID ");
            sb.Append(" WHERE inv.Investigation_Id IN ('LSHHI3724') ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (txtIPDno.Text.Trim() != "")
            {
                sb.Append(" AND plo.TransactionID='" + txtIPDno.Text.Trim() + "'");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" And plo.Date>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' AND plo.Time>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND plo.Date<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "' AND plo.Time<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59'  ");
            }
            ReportName = "HIVLabTestRegister";
        }
        else if (rbtnreport.SelectedValue == "7")//LabRadioRegister
        {
            sb.Append(" SELECT cm.CentreName, pm.PatientID UHID,CONCAT(pm.Title,'',pm.PFirstName)FirstName,''MiddleName,pm.PLastName,pm.Gender,DATE_FORMAT(pm.DOB ,'%d-%b-%y') BirthDate, ");
            sb.Append(" pm.Age PatientAge ,IF(pmh.Type='IPD',PMH.TransNO,'')PATIENTIDENTIFIERNO,im.ItemCode,im.TypeName, ");
            sb.Append(" (SELECT CONCAT(dr.Title,dr.Name) FROM doctor_master dr WHERE dr.DoctorID=pmh.DoctorID)DoctorName,DATE_FORMAT(plo.Date ,'%d-%b-%y')RequestDate,DATE_FORMAT(plo.ApprovedDate ,'%d-%b-%y')CompleteDate,''LevelDetailName, ");
            sb.Append(" IF(plo.Approved=1,'Approved','Not-Approved')ServiceStatus,''BillingStatus,MONTH(plo.Date)MONTH,YEAR(plo.Date)YEAR  ");
            sb.Append(" FROM patient_labinvestigation_opd plo INNER JOIN patient_medical_history pmh ON plo.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN f_itemmaster im ON plo.Investigation_ID=im.Type_ID ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON im.SubCategoryID=sc.SubCategoryID INNER JOIN f_configrelation cr ON sc.CategoryID=cr.CategoryID ");
            sb.Append(" INNER JOIN center_master cm ON plo.CentreID=cm.CentreID WHERE cr.ConfigID =3 and cm.centreID in (" + Centre + ") ");
            if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" and plo.Date>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' and plo.Date<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "'");
            }
            if (txtUHID.Text.Trim() != "")
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            if (txtIPDno.Text.Trim() != "")
                sb.Append(" AND pmh.TransactionID='" + txtIPDno.Text.Trim() + "'");
            sb.Append(" order by plo.Date");
            ReportName = "LabRadioRegister";
        }
        else if (rbtnreport.SelectedValue == "8")// IPD Patient Register(Hourly)
        {
            sb.Append(" SELECT ip.PatientID UHID,IF(PMH.Type='IPD',pmh.Transno,'')IP, CONCAT(pm.Title,' ',pm.PFirstName)NAME,pm.PLastName OtherName,pm.Gender sex,pm.Age,pm.Country Nationality, ");
            sb.Append(" DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')CheckInDate,TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')checkinTime,cm.CentreName ");
            sb.Append(" ,CONCAT(rm.Name,'/',rm.Room_No,'/',rm.Bed_No,'/',rm.Floor)BedNo, DATEDIFF(CURRENT_DATE(),pmh.DateOfAdmit)AS BedDays ");
            sb.Append(" ,pmh.status,CONCAT(dm.Title,' ',dm.Name)SeenBy,dm.SPECIALIZATION speciality,IFNULL(icd.ICD_Code,'Not Added') AS ICD_Code,pd.ProvisionalDiagnosis Diagnosis ");
            sb.Append(" ,(SELECT COUNT(*)AdmitCount FROM patient_medical_history ic WHERE  CentreID IN (" + Centre + ") AND ic.DateofAdmit>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' AND ic.TimeofAdmit>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND ic.dateofadmit<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "' AND ic.timeofadmit<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59')totalAdmitPatient ");
            sb.Append(" FROM patient_ipd_profile ip  ");
            sb.Append(" INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID  ");
            sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID  ");
            sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID  ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID  ");
            sb.Append(" LEFT JOIN icd_10cm_patient icd ON icd.TransactionID=pmh.TransactionID LEFT JOIN cpoe_PatientDiagnosis pd ON pd.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID  ");
            sb.Append(" WHERE PMh.Status <> 'Cancel' AND pmh.CentreID IN (" + Centre + ") AND PMh.DateOfAdmit >= '" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "'  AND pmh.TimeOfAdmit>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' ");
            sb.Append(" AND pmh.DateOfAdmit <= '" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "'  AND pmh.TimeOfAdmit<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59' ");
            sb.Append(" GROUP BY ip.TransactionID HAVING MIN(ip.StartDate) ORDER BY pmh.TransactionID ");
            ReportName = "IPPatientRegister_Hourly";
        }
        else if (rbtnreport.SelectedValue == "9")
        { }
        else if (rbtnreport.SelectedValue == "10")
        { }
        else if (rbtnreport.SelectedValue == "11")
        { }
        else if (rbtnreport.SelectedValue == "12") //New Emergency Patient Register
        {
            sb.Append(" SELECT cm.CentreName ,pm.PatientID UHID,epd.EmergencyNo EOP,CONCAT(pm.Title,' ',pm.PFirstName)'Name',pm.PLastName OtherName,pm.Gender 'Sex',pm.Age'Age',  ");
            sb.Append(" DATE_FORMAT(epd.EnteredOn,'%d-%b-%Y %h:%i %p')'CheckInTime',  IFNULL(DATE_FORMAT(epd.ReleasedDateTime,'%d-%b-%Y %h:%i %p'),'')'CheckOutTime',pm.Country 'Nationality',  CONCAT(dm.Title,' ',dm.Name)'SeenBy',  ");
            sb.Append(" IFNULL((SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis WHERE TransactionID=pmh.TransactionID),'')Diagnosis,IFNULL((SELECT Icd_Code FROM icd_10cm_patient WHERE TransactionID=pmh.TransactionID AND isactive=1),'')ICD_Code,  ");
            sb.Append(" IFNULL((SELECT cc.CarePlan  FROM Cpoe_careplan cc WHERE  cc.TransactionID=pmh.TransactionID AND cc.IsActive=1),'')DoctorAdvice,IFNULL((SELECT ce.MainComplaint FROM cpoe_hpexam ce WHERE ce.TransactionID=pmh.TransactionID ),'')ChiefComplain,  ");
            sb.Append(" IFNULL(lt.BillNo,'')BillNo  FROM Emergency_Patient_Details epd   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=epd.TransactionId    ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID  INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID    ");
            sb.Append(" INNER JOIN center_master cm ON pmh.CentreID=cm.CentreID Where cm.centreID in (" + Centre + ") ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" And epd.EnteredOn>='" + startDate + "' AND epd.EnteredOn<='" + toDate + "' ");
            }
            ReportName = "NewEmergencyPatientRegister";
        }
        else if (rbtnreport.SelectedValue == "13") //today's Scheduled Operation
        {
        }
        else if (rbtnreport.SelectedValue == "14")//ChaperOnServices
        {
            sb.Append(" SELECT cm.CentreName,pm.PatientID UHID,app.AppNo,pm.PLastName,pm.PFirstName,pm.Gender sex, pm.Age PatientAge,CONCAT(dm.Title,'',dm.Name)Dname,DATE_FORMAT(app.ConformDate,'%d-%b-%Y %h:%i %p')ConformDate  FROM appointment app  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON app.TransactionID=pmh.TransactionID INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb.Append(" INNER JOIN doctor_master dm ON app.DoctorID=dm.DoctorID INNER JOIN center_master cm ON app.CentreID=cm.CentreID WHERE app.CentreID IN (" + Centre + ") AND app.IsConform=1 ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {   
                sb.Append(" AND app.ConformDate>='" + startDate + "' AND app.ConformDate<='" + toDate + "' ");
            }
            sb.Append(" order by app.ConformDate,dm.Name");
            ReportName = "ChaperOnServices";
        }
        else if (rbtnreport.SelectedValue == "15")//Quarterly Wise Hospital Occupancy
        {

        }
        else if (rbtnreport.SelectedValue == "16")//Emergency Patient Register
        {
            sb.Append(" SELECT cm.CentreName ,pm.PatientID UHID,epd.EmergencyNo EOP,CONCAT(pm.Title,' ',pm.PFirstName)'Name',pm.PLastName OtherName,pm.Gender 'Sex',pm.Age'Age',  ");
            sb.Append(" DATE_FORMAT(epd.EnteredOn,'%d-%b-%Y %h:%i %p')'CheckInTime',  IFNULL(DATE_FORMAT(epd.ReleasedDateTime,'%d-%b-%Y %h:%i %p'),'')'CheckOutTime',pm.Country 'Nationality',  CONCAT(dm.Title,' ',dm.Name)'SeenBy',  ");
            sb.Append(" IFNULL((SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis WHERE TransactionID=pmh.TransactionID),'')Diagnosis,IFNULL((SELECT Icd_Code FROM icd_10cm_patient WHERE TransactionID=pmh.TransactionID AND isactive=1),'')ICD_Code,  ");
            sb.Append(" IFNULL(lt.BillNo,'')BillNo, DATE_FORMAT(lt.BillDate,'%d-%b-%Y')BillDate  FROM Emergency_Patient_Details epd   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=epd.TransactionId    ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID  INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID    ");
            sb.Append(" INNER JOIN center_master cm ON pmh.CentreID=cm.CentreID Where cm.centreID in (" + Centre + ") ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" And epd.EnteredOn>='" + startDate + "' AND epd.EnteredOn<='" + toDate + "' ");
            }
            ReportName = "EmergencyPatientRegister";
        }
        else if (rbtnreport.SelectedValue == "17")//OP Patient Register	
        {
            sb.Append(" SELECT cm.CentreName, pm.PatientID AS 'UHID',pmh.TransactionID AS 'OP No.', pm.PName,pm.Gender,pm.Age,pm.Country AS 'Nationality',DATE_FORMAT(pmh.DateOfVisit,'%d-%b-%y') AS CheckInDate,CONCAT(dm.Title,'',dm.Name) AS 'Seen By',  ");
            sb.Append(" IFNULL(icd.ICD_Code,'Not Added') AS ICD10,pd.ProvisionalDiagnosis,IFNULL(lt.BillNo,'Not Generated') AS 'Bill No',dm.Specialization FROM appointment app  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=app.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  ");
            sb.Append(" INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID LEFT JOIN icd_10cm_patient icd ON icd.TransactionID=pmh.TransactionID ");
            sb.Append(" LEFT JOIN cpoe_PatientDiagnosis pd ON pd.TransactionID=pmh.TransactionID LEFT JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN center_master cm ON pmh.CentreID=cm.CentreID WHERE cm.CentreID IN(" + Centre + ") ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" AND pmh.DateOfVisit>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' AND pmh.Time>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND pmh.DateOfVisit<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "' AND pmh.Time<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59' ");
            }
            sb.Append(" GROUP BY pmh.TransactionID ORDER BY pmh.DateOfVisit,pmh.TransactionID ");
            ReportName = "OPPatientRegister";
        }
        else if (rbtnreport.SelectedValue == "18")//IP Patient Register	
        {
            sb.Append(" SELECT ip.PatientID UHID,IF(PMH.Type='IPD',pmh.Transno,'')IP, CONCAT(pm.Title,' ',pm.PFirstName)NAME,pm.PLastName OtherName,pm.Gender sex,pm.Age,pm.Country Nationality, ");
            sb.Append(" DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')CheckInDate,TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')checkinTime,cm.CentreName ");
            sb.Append(" ,CONCAT(rm.Name,'/',rm.Room_No,'/',rm.Bed_No,'/',rm.Floor)BedNo, DATEDIFF(CURRENT_DATE(),pmh.DateOfAdmit)AS BedDays ");
            sb.Append(" ,pmh.status,CONCAT(dm.Title,' ',dm.Name)SeenBy,dm.SPECIALIZATION speciality,IFNULL(icd.ICD_Code,'Not Added') AS ICD_Code,pd.ProvisionalDiagnosis Diagnosis,IFNULL(pmh.BillNo,'Not Generated')BillNo, ");
            sb.Append(" (SELECT COUNT(*)AdmitCount FROM patient_medical_history ic WHERE  CentreID IN (" + Centre + ") AND ic.DateofAdmit>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' AND ic.TimeofAdmit>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND ic.dateofadmit<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "' AND ic.timeofadmit<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59')totalAdmitPatient ");
            sb.Append(" FROM patient_ipd_profile ip  ");
            sb.Append(" INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID  ");
            sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID  ");
            sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID  ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID  ");
            sb.Append(" LEFT JOIN icd_10cm_patient icd ON icd.TransactionID=pmh.TransactionID LEFT JOIN cpoe_PatientDiagnosis pd ON pd.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID  ");
            sb.Append(" WHERE pmh.Status <> 'Cancel' AND pmh.CentreID IN (" + Centre + ")");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (txtIPDno.Text.Trim() != "")
            {
                sb.Append(" AND pmh.TransactionID='" + txtIPDno.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" AND pmh.DateOfAdmit >= '" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "'  AND pmh.TimeOfAdmit>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' ");
                sb.Append(" AND pmh.DateOfAdmit <= '" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "'  AND pmh.TimeOfAdmit<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59' ");
            }
            sb.Append(" GROUP BY ip.TransactionID HAVING MIN(ip.StartDate) ORDER BY pmh.TransactionID ");
            ReportName = "IPPatientRegister";
        }
        else if (rbtnreport.SelectedValue == "19")//IP Discharge Patient Register	
        {
            sb.Append(" SELECT ip.PatientID UHID,IF(PMH.Type='IPD',pmh.Transno,'')IP, CONCAT(pm.Title,' ',pm.PFirstName)NAME,pm.PLastName OtherName,pm.Gender sex,pm.Age,pm.Country Nationality ");
            sb.Append(" ,CONCAT(DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p'))AdmisionDate,CONCAT(DATE_FORMAT(pmh.DateofDischarge,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.TimeofDischarge,'%h:%i %p'))DischargeDate,cm.CentreName ");
            sb.Append(" ,CONCAT(rm.Name,'/',rm.Room_No,'/',rm.Bed_No,'/',rm.Floor)BedNo,pmh.status,CONCAT(dm.Title,' ',dm.Name)SeenBy,dm.SPECIALIZATION speciality,IFNULL(icd.ICD_Code,'Not Added') AS ICD_Code,pd.ProvisionalDiagnosis Diagnosis,IFNULL(pmh.BillNo,'Not Generated')BillNo, ");
            sb.Append(" (SELECT COUNT(*)AdmitCount FROM patient_medical_history ic WHERE  CentreID IN (" + Centre + ") AND ic.DateofDischarge>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' AND ic.TimeofDischarge>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND ic.DateofDischarge<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "' AND ic.TimeofDischarge<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59')totalDischargePatient, ");
            sb.Append("  IFNULL((SELECT GROUP_CONCAT(DISTINCT(sm.Name)) FROM f_surgery_discription sd INNER JOIN f_surgery_master sm ON sd.SurgeryID=sm.Surgery_ID WHERE sd.TransactionID=pmh.TransactionID),'')SurgeryName");
            sb.Append(" FROM patient_ipd_profile ip  ");
            sb.Append(" INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID  ");
            sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID  ");
            sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID  ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID  ");
            sb.Append(" LEFT JOIN icd_10cm_patient icd ON icd.TransactionID=pmh.TransactionID LEFT JOIN cpoe_PatientDiagnosis pd ON pd.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID  ");
            sb.Append(" WHERE pmh.Status = 'OUT'  AND pmh.CentreID IN (" + Centre + ") ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (txtIPDno.Text.Trim() != "")
            {
                sb.Append(" AND pmh.TransactionID='" + txtIPDno.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" AND pmh.DateofDischarge >= '" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "'  AND pmh.TimeofDischarge>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' ");
                sb.Append(" AND pmh.DateofDischarge <= '" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "'  AND pmh.TimeofDischarge<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59' ");
            }
            sb.Append(" GROUP BY ip.TransactionID HAVING MAX(ip.EndDate) ORDER BY pmh.TransactionID ");
            ReportName = "IPDischargePatientRegister";
        }
        else if (rbtnreport.SelectedValue == "20")//Dialysis Patient Register	
        {
        }
        else if (rbtnreport.SelectedValue == "21")//Physiotheraphy Count Register	
        {
            sb.Append("	SELECT DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')EntryDate,COUNT(*)TotalCount,IF(ltd.TYPE='O','OPD','IPD')TYPE FROM f_ledgertnxdetail ltd  ");
            sb.Append(" WHERE SubCategoryId ='LSHHI151' AND ltd.IsVerified=1  AND ltd.CentreID IN(" + Centre + ") ");
            if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" AND ltd.EntryDate  >= '" + startDate + "' AND ltd.EntryDate  <= '" + toDate + "'  ");
            }
            sb.Append(" GROUP BY ltd.Type,ltd.EntryDate ORDER BY ltd.EntryDate");
            ReportName = "PhysioTherapyCount";
        }
        else if (rbtnreport.SelectedValue == "22")//Gastro Logy Register	
        {
        }
        else if (rbtnreport.SelectedValue == "23")//Current IP Surgery Register	
        {
            sb.Append("  SELECT ip.PatientID UHID,IF(PMH.Type='IPD',pmh.Transno,'')IP, CONCAT(pm.Title,' ',pm.PName)NAME,pm.Gender sex,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DateofBirth,pm.Age,CONCAT(DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p'))AdmisionDate, ");
            sb.Append("  cm.CentreName  ,CONCAT(rm.Name,'/',rm.Room_No,'/',rm.Bed_No,'/',rm.Floor)BedNo,pmh.status,CONCAT(dm.Title,' ',dm.Name)SeenBy,dm.SPECIALIZATION speciality,pd.ProvisionalDiagnosis Diagnosis,    DATEDIFF(CURRENT_DATE(),pmh.DateOfAdmit)AS BedDays, ");
            sb.Append("  IFNULL((SELECT GROUP_CONCAT(DISTINCT(sm.Name)) FROM f_surgery_discription sd INNER JOIN f_surgery_master sm ON sd.SurgeryID=sm.Surgery_ID WHERE sd.TransactionID=pmh.TransactionID),'')SurgeryName  ");
            sb.Append("  FROM patient_ipd_profile ip   INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID    ");
            sb.Append("  INNER JOIN room_master rm ON rm.RoomId = ip.RoomID    ");
            sb.Append("  INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID   INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID    ");
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID   LEFT JOIN cpoe_PatientDiagnosis pd ON pd.TransactionID=pmh.TransactionID  ");
            sb.Append("  INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID   WHERE pmh.Status = 'IN'  AND pmh.CentreID IN ('1')   ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (txtIPDno.Text.Trim() != "")
            {
                sb.Append(" AND pmh.TransactionID='" + txtIPDno.Text.Trim() + "' ");
            }
            sb.Append(" GROUP BY ip.TransactionID  ORDER BY pmh.TransactionID ");
            ReportName = "CurrentIPSurgeryRegister";
        }
        else if (rbtnreport.SelectedValue == "24")//Monthly Wise Occupancy Register	
        {
        }
        else if (rbtnreport.SelectedValue == "25")//Emrgency Report Hourly
        {
            sb.Append(" SELECT cm.CentreName ,pm.PatientID UHID,epd.EmergencyNo EOP,CONCAT(pm.Title,' ',pm.PFirstName)'Name',pm.PLastName OtherName,pm.Gender 'Sex',pm.Age'Age',  ");
            sb.Append(" DATE_FORMAT(epd.EnteredOn,'%d-%b-%Y %h:%i %p')'CheckInTime',  IFNULL(DATE_FORMAT(epd.ReleasedDateTime,'%d-%b-%Y %h:%i %p'),'')'CheckOutTime',pm.Country 'Nationality',  CONCAT(dm.Title,' ',dm.Name)'SeenBy',  ");
            sb.Append(" IFNULL((SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis WHERE TransactionID=pmh.TransactionID),'')Diagnosis,IFNULL((SELECT Icd_Code FROM icd_10cm_patient WHERE TransactionID=pmh.TransactionID AND isactive=1),'')ICD_Code,  ");
            sb.Append(" IFNULL((SELECT cc.CarePlan  FROM Cpoe_careplan cc WHERE  cc.TransactionID=pmh.TransactionID AND cc.IsActive=1),'')DoctorAdvice,IFNULL((SELECT ce.MainComplaint FROM cpoe_hpexam ce WHERE ce.TransactionID=pmh.TransactionID ),'')ChiefComplain,  ");
            sb.Append(" IFNULL(lt.BillNo,'')BillNo  FROM Emergency_Patient_Details epd   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=epd.TransactionId    ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID  INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID    ");
            sb.Append(" INNER JOIN center_master cm ON pmh.CentreID=cm.CentreID Where cm.centreID in (" + Centre + ") ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" And epd.EnteredOn>='" + startDate + "' AND epd.EnteredOn<='" + toDate + "' ");
            }
            ReportName = "NewEmergencyPatientRegister";
        
        }
        else if (rbtnreport.SelectedValue == "26")//OP Patient Register Hourly
        {
            sb.Append(" SELECT cm.CentreName, pm.PatientID AS 'UHID',pmh.TransactionID AS 'OP No.', pm.PName,pm.Gender,pm.Age,pm.Country AS 'Nationality',DATE_FORMAT(pmh.DateOfVisit,'%d-%b-%y') AS CheckInDate,CONCAT(dm.Title,'',dm.Name) AS 'Seen By',  ");
            sb.Append(" IFNULL(icd.ICD_Code,'Not Added') AS ICD10,pd.ProvisionalDiagnosis,IFNULL(lt.BillNo,'Not Generated') AS 'Bill No',dm.Specialization FROM appointment app  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=app.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  ");
            sb.Append(" INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID LEFT JOIN icd_10cm_patient icd ON icd.TransactionID=pmh.TransactionID ");
            sb.Append(" LEFT JOIN cpoe_PatientDiagnosis pd ON pd.TransactionID=pmh.TransactionID LEFT JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN center_master cm ON pmh.CentreID=cm.CentreID WHERE cm.CentreID IN(" + Centre + ") ");
            if (txtUHID.Text.Trim() != "")
            {
                sb.Append(" AND pm.PatientID='" + txtUHID.Text.Trim() + "' ");
            }
            else if (ucDateFrom.Text.Trim() != string.Empty && ucDateTo.Text.Trim() != string.Empty)
            {
                sb.Append(" AND pmh.DateOfVisit>='" + Util.GetDateTime(Util.GetDateTime(ucDateFrom.Text)).ToString("yyyy-MM-dd") + "' AND pmh.Time>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND pmh.DateOfVisit<='" + Util.GetDateTime(Util.GetDateTime(ucDateTo.Text)).ToString("yyyy-MM-dd") + "' AND pmh.Time<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm") + ":59' ");
            }
            sb.Append(" GROUP BY pmh.TransactionID ORDER BY pmh.DateOfVisit,pmh.TransactionID ");
            ReportName = "OPPatientRegister_Hourly";
        }
        else if (rbtnreport.SelectedValue == "27")//ICU Patient Register	
        {
        }
        else if (rbtnreport.SelectedValue == "28")//Day Care Patient Register
        { }
        else if (rbtnreport.SelectedValue == "29")//DAMA Patient Register
        {
        }
        else if (rbtnreport.SelectedValue == "30")//LAMA Patient Register
        {
        }
        else if (rbtnreport.SelectedValue == "31")//Monthly Wise Total Occupancy Report	
        {
        }
        else if (rbtnreport.SelectedValue == "32")//AFP Base Report
        { 
        }
        else if (rbtnreport.SelectedValue == "33")//Registration Remarks
        {
        }
        else if (rbtnreport.SelectedValue == "34")//Audit for Print Report
        {
        }
       DataTable dt = new DataTable();
        if (sb.ToString() != "")
        {
            dt = StockReports.GetDataTable(sb.ToString());
        }
        else
            dt = null;
        if (dt!=null && dt.Rows.Count > 0)
        {
            if (rdbreporttype.SelectedValue == "PDF")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt.Copy());

                // ds.WriteXmlSchema(@"E:\\MRDReport.xml");

                Session["ds"] = ds;
                Session["ReportName"] = ReportName;

                // ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='../../Design/Common/CommonCrystalReportViewer.aspx?';", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else if (rdbreporttype.SelectedValue == "Excel")
            {
                Session["ReportName"] = ReportName;
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "Period From : " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            txtIPDno.Text = "";
            txtUHID.Text = "";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", " modelAlert('No Record Found',function(){});", true);
        }

    }


}
