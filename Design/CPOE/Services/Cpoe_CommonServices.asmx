<%@ WebService Language="C#" Class="Cpoe_CommonServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Data;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Text;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class Cpoe_CommonServices : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true, Description = "Save")]
    public string saveClinical(object Clinical)
    {
        List<ClinicalInvestigationNew> clinicalInvestigationNew = new JavaScriptSerializer().ConvertToType<List<ClinicalInvestigationNew>>(Clinical);
        if (clinicalInvestigationNew.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from Cpoe_Clinical where TransactionID='" + clinicalInvestigationNew[0].TID + "'");
                for (int i = 0; i < clinicalInvestigationNew.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO Cpoe_Clinical(TransactionID,PatientID,ClinicalID, Name,ClinicalNameCon,CreatedBy,ClinicalText  " +
                        " )VALUE('" + clinicalInvestigationNew[0].TID + "','" + clinicalInvestigationNew[0].PID + "','" + clinicalInvestigationNew[i].ClinicalID + "', " +
                        " '" + clinicalInvestigationNew[i].Name + "','" + clinicalInvestigationNew[i].ClinicalNameCon + "','" + Session["ID"].ToString() + "','" + clinicalInvestigationNew[i].ClinicalText + "' )");
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "";
        }
    }        
    [WebMethod(EnableSession = true, Description = "Bind Review Of System")]
    public string bindReviewSystem(string TID)
    {
        string s = Util.GetString(StockReports.ExecuteScalar("SELECT   CONCAT(IF(pm.DOB = '0001-01-01', (CASE WHEN pmh.CurrentAGE LIKE '%DAY%'  THEN ((TRIM(REPLACE(pmh.CurrentAGE ,'DAY(S)',''))+0)) WHEN pmh.CurrentAGE  LIKE '%MONTH%' THEN ((TRIM(REPLACE(pmh.CurrentAge,'MONTH(S)',''))+0)*30)  ELSE ((TRIM(REPLACE(pmh.CurrentAge,'YRS',''))+0)*365) END), DATEDIFF(NOW(),pm.DOB)) ,'#',IF(pm.Gender='Male','M','F'))AgeGender  FROM patient_medical_history pmh INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID WHERE pmh.TransactionID=" + TID + ""));
        
        
        DataTable review = StockReports.GetDataTable("Select bsm.BodySystemID,if(IFNULL(rs.BodySystemText,'')='',bsm.Description,rs.BodySystemText)Description,bsm.BodySystemName,IF(IFNULL(rs.BodySystemCon,'')='',1,rs.BodySystemCon)BodySystemCon,'Normal' Normal,'Not Indicated' NotIndicated,'Abnormal' Abnormal,bsm.BodyCondition,rs.CommentSystem  from cpoe_bodysystem_master bsm LEFT JOIN  cpoe_ReviewOfSystem rs ON bsm.BodySystemID=rs.BodySystemID " +
            " and rs.TransactionID='" + TID + "' "+
            " INNER JOIN cpoe_ReveiwSystemAgewise cra ON cra.BodySystemID=bsm.BodySystemID AND cra.Fromage<=IF(" + s.Split('#')[0] + "=0,'0'," + s.Split('#')[0] + ") AND cra.ToAge>=IF(" + s.Split('#')[0] + "=0,'0'," + s.Split('#')[0] + ") AND cra.Gender='" + s.Split('#')[1] + "'  " +
            " where IsActive=1 order by SequenceNo ");
        if (review.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(review);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Review Of System")]
    public string saveBodySystem(object Review)
    {

        List<BodySystem> bodySystem = new JavaScriptSerializer().ConvertToType<List<BodySystem>>(Review);
        if (bodySystem.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE  FROM cpoe_ReviewOfSystem where TransactionID='" + bodySystem[0].TID + "'");
                for (int i = 0; i < bodySystem.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_ReviewOfSystem(TransactionID,PatientID,BodySystemID,BodySystemCon,BodySystemText,CreatedBy,CommentSystem)VALUES('" + bodySystem[i].TID + "','" + bodySystem[i].PID + "','" + bodySystem[i].BodySystemID + "','" + bodySystem[i].BodySystemCon + "','" + (bodySystem[i].BodySystemText) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + (bodySystem[i].CommentSystem) + "') ");
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }
   
    [WebMethod(EnableSession = true, Description = "Bind Vaccination")]
    public string bindVaccination(string PID)
    {
        DataTable Vaccination = StockReports.GetDataTable("Select vam.VaccinationID,vam.VaccinationName,IFNULL(va.VaccinationNameCon,1)VaccinationNameCon,'Unknown' Unknown,'Yes' Yes,'No' No,if(IFNULL(VaccinationDate,'0001-01-01')='0001-01-01','',DATE_FORMAT(VaccinationDate,'%d-%b-%Y'))VaccinationDate,VaccDate from cpoe_Vaccination_master vam LEFT JOIN cpoe_Vaccination va ON vam.VaccinationID=va.VaccinationID and va.PatientID='" + PID + "' where vam.IsActive=1 group by vam.VaccinationID Order By vam.VaccinationID,VaccDate");
        if (Vaccination.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(Vaccination);
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true, Description = "Save Vaccination")]
    public string saveVaccination(object Vaccination)
    {
        List<Vaccination> vaccination = new JavaScriptSerializer().ConvertToType<List<Vaccination>>(Vaccination);
        if (vaccination.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from cpoe_Vaccination where PatientID='" + vaccination[0].PID + "'");
                for (int i = 0; i < vaccination.Count; i++)
                {
                    if (vaccination[i].VaccinationID != "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_Vaccination(TransactionID,PatientID,VaccinationID,VaccinationName,VaccinationNameCon,CreatedBy,VaccinationDate  " +
                            " )VALUE('" + vaccination[0].TID + "','" + vaccination[0].PID + "','" + vaccination[i].VaccinationID + "', " +
                            " '" + vaccination[i].VaccinationName + "','" + vaccination[i].VaccinationNameCon + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(vaccination[i].VaccinationDate).ToString("yyyy-MM-dd") + "' )");
                    }
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }

    

    [WebMethod(EnableSession = true)]
    public string cpoeSearch(string MRNo, string PName, string AppNo, string DoctorID, string status, string fromDate, string toDate, string DocDepartment, string AppStatus)
    {
       // DoctorID = StockReports.ExecuteScalar("SELECT de.DoctorID FROM doctor_employee de WHERE de.Employee_id='" + HttpContext.Current.Session["ID"].ToString() + "'");
        DataTable dtapp = DoctorAppointmentSearch(MRNo, PName, AppNo, DoctorID, status, fromDate, toDate, DocDepartment, AppStatus, false);
        DataView dvpending = new DataView(dtapp);
        dvpending.RowFilter = "P_Out = '" + AppStatus + "' and SubCategoryID <> " + Util.GetInt(Resources.Resource.EmergencySubcategoryID) + " ";
        DataTable dtPendingAppointmentList = dvpending.ToTable();

        DataView dvViewedAppointmentList = new DataView(dtapp);
        dvViewedAppointmentList.RowFilter = "P_Out = 1 and SubCategoryID <> " + Util.GetInt(Resources.Resource.EmergencySubcategoryID) + " ";
        DataTable dtViewedAppointmentList = dvViewedAppointmentList.ToTable();

        DataView dvEmergencyAppointmentList = new DataView(dtapp);
        dvEmergencyAppointmentList.RowFilter = "P_Out = 0 and SubCategoryID = " + Util.GetInt(Resources.Resource.EmergencySubcategoryID) + " ";
        DataTable dtEmergencyAppointmentList = dvEmergencyAppointmentList.ToTable();

        DataView dvEmergencyViewedAppointmentList = new DataView(dtapp);
        dvEmergencyViewedAppointmentList.RowFilter = "P_Out = 1 and SubCategoryID = " + Util.GetInt(Resources.Resource.EmergencySubcategoryID) + "";
        DataTable dtEmergencyViewedAppointmentList = dvEmergencyViewedAppointmentList.ToTable();
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { pendingAppointmentList = dtPendingAppointmentList, viewedAppointmentList = dtViewedAppointmentList, emergencyAppointmentList = dtEmergencyAppointmentList,emergencyViewedAppointmentList=dtEmergencyViewedAppointmentList });

    }



    public static DataTable DoctorAppointmentSearch(string MRNo, string PName, string AppNo, string DoctorID, string status, string fromDate, string toDate, string DocDepartment, string AppStatus,bool onlyEmergency)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT '0' ReportCount,t.* ,UPPER(SUBSTR(t.Sex,1,1))Gender FROM  ( SELECT IFNULL((SELECT CONCAT(Title,' ',NAME) FROM employee_master em WHERE em.employeeID=app.`DoctorAssignBy`),'')Assign, IFNULL(ref.AppID,'')AppID,");
        sb.Append(" app.PatientID,LedgerTnxNo,app.PatientID MRNo,app.App_ID,app.AppNo,CONCAT(app.Title,' ',app.Pname)Pname, ");
        sb.Append(" (SELECT pm.age FROM patient_master pm WHERE pm.PatientID=app.PatientID)Age, ");
        sb.Append(" (SELECT pm.gender FROM patient_master pm WHERE pm.PatientID=app.PatientID)Sex, ");
        sb.Append(" (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=app.DoctorID)DName, ");
        sb.Append(" (SELECT sub.Name  FROM f_subcategorymaster sub WHERE sub.subcategoryID=app.subcategoryID )SubName, ");
        sb.Append(" CONCAT(DATE_FORMAT(app.date,'%d-%b-%Y'),' ',DATE_FORMAT(app.Time,'%h:%i %p'))AppointmentDate, IF(DATE_ADD(CONCAT(app.Date,' ',app.Time),INTERVAL 24 HOUR)<=NOW(),if(app.hold=1,1,0),1)CanCall,app.ContactNo,app.VisitType,TypeOfApp,app.TransactionID,IF(app.flag = 1,'true','false')Isdone,IF(app.flag = 1,'Closed','Pending')IsCompleated, ");
        //sb.Append(" app.IsView,app.PanelID,IF(app.subcategoryID='" + HttpContext.GetGlobalResourceObject("Resource", "EmergencySubcategoryID").ToString() + "','1','0')IsEmergency,app.TemperatureRoom ");
        sb.Append(" app.IsView,app.PanelID,(SELECT p.company_name FROM  `f_panel_master` p WHERE p.`PanelID`=app.PanelID)PanelName,app.TemperatureRoom ");
       // sb.Append(" ,app.IsCall,app.CallNo,app.P_In,app.P_Out,app.Hold,app.DoctorID,0 AmountPaid,'' Naration, ");
        sb.Append(" ,app.IsCall,app.CallNo,0 P_In,app.P_Out,app.Hold,app.DoctorID,0 AmountPaid,'' Naration,app.SubCategoryID, ");
        sb.Append(" IFNULL((SELECT COUNT(*) FROM f_itemmaster im  INNER JOIN patient_test pt ON pt.test_id = im.ItemID INNER JOIN patient_labinvestigation_opd plo ON plo.Investigation_ID=im.Type_ID WHERE pt.OPDTransactionID=plo.TransactionID AND pt.TransactionID=app.TransactionID AND plo.Result_Flag=1 GROUP BY pt.TransactionID ),0) labResultCount,(SELECT IFNULL(pm.PurposeOfVisit,'')PurposeOfVisit FROM patient_master pm WHERE pm.PatientID=app.PatientID)PurposeOfVisit,IFNULL(app.PatientType,'')PatientType "); 
        sb.Append(" FROM appointment app ");//INNER JOIN patient_master pm ON pm.PatientID=app.PatientID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID and DefaultDepartmentDoctor<>1 ");
        //sb.Append(" INNER JOIN f_subcategorymaster sub on sub.subcategoryID=app.subcategoryID ");
        sb.Append(" LEFT JOIN cpoe_referralConsultation ref ON ref.AppID=app.App_ID  AND ref.`IsActive`=1  ");
        sb.Append(" WHERE app.PatientID<>''  AND app.IsConform=1 AND app.IsCancel=0 AND app.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

        //AND LedgerTnxNo<>''
        
        if (PName.Trim() != string.Empty)
            sb.Append(" AND app.Pname like '" + PName.Trim() + "%'");
        if (MRNo.Trim() != string.Empty)
            sb.Append(" AND app.PatientID='" + Util.GetFullPatientID(MRNo.Trim()) + "'");
        if (DoctorID != "0")
            sb.Append(" and app.DoctorID='" + DoctorID + "'");

        if (fromDate != string.Empty)
            sb.Append(" AND app.date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'");
        if (toDate != string.Empty)
            sb.Append(" AND app.date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");

        if (status != "2")
            sb.Append(" AND app.flag='" + status + "' ");
        if (AppNo.Trim() != string.Empty)
            sb.Append(" AND app.AppNo=" + AppNo.Trim() + "");
        if (DocDepartment != "0")
            sb.Append(" AND dm.DocDepartmentID=" + DocDepartment + " ");

        //For Confirmed Appoitments
        //sb.Append(" AND app.P_Out='" + AppStatus + "'");
        if (!onlyEmergency)
            sb.Append("AND app.SubCategoryID<>'" + Resources.Resource.EmergencyVisitSubCategoryId + "'");
        else
            sb.Append("AND app.SubCategoryID='" + Resources.Resource.EmergencyVisitSubCategoryId + "'");

       // sb.Append("AND app.TemperatureRoom <> '0' ");

        sb.Append("  Order by app.Date,app.App_ID ) t");
        return  StockReports.GetDataTable(sb.ToString());
    }
    
    
    
    
    
    
    
    
    [WebMethod(EnableSession = true, Description = "Save Patient Diagnosis")]
    public string saveDiagnosis(string PID, string TID, string LnxNo, string Diagnosis, string ProvisionalDiagnosis)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from cpoe_PatientDiagnosis where LedgerTransactionNo='" + LnxNo + "'");
            string sql = " insert into cpoe_PatientDiagnosis(PatientID,TransactionID,LedgerTransactionNo,Diagnosis,CreatedBy,ProvisionalDiagnosis) values('" + PID.ToString() + "','" + TID.ToString() + "','" + LnxNo.ToString() + "','" + (Diagnosis) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + ProvisionalDiagnosis + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true, Description = "Bind Patient Diagnosis")]
    public string bindDiagnosis(string LnxNo)
    {
        string sql = "Select Diagnosis,ProvisionalDiagnosis from cpoe_PatientDiagnosis where LedgerTransactionNo='" + LnxNo + "'";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(Description = "IPDHistory")]
    public string IPDHistory(string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ip.PatientID,REPLACE(ip.TransactionID,'ISHHI','')TransactionID,ip.TransactionID TID,");
        sb.Append("   DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(ich.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,");
        sb.Append("   DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,DATE_FORMAT(ich.TimeOfDischarge,'%h:%i %p')TimeOfDischarge,");
        sb.Append("   pmh.DischargeType AS DischargeStatus,ctm.Name AS BedCategory,rm.Bed_No AS BedNo,rm.Floor,");
        sb.Append("   CONCAT(dm.Title,' ',dm.Name)DoctorName,pnl.Company_Name Panel,pmh.Source,ich.Status");
        sb.Append("    FROM patient_ipd_profile ip INNER JOIN ipd_case_history ich ");
        sb.Append("    ON ip.TransactionID = ich.TransactionID INNER JOIN room_master rm ON rm.Room_Id = ip.Room_ID ");
        sb.Append("    INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseType_ID = rm.IPDCaseTypeID INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID ");
        sb.Append("    INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID INNER JOIN f_panel_master pnl ON pnl.PanelID = ip.PanelID ");
        sb.Append("    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID ");
        sb.Append("    WHERE ich.Status = 'OUT' AND pm.PatientID='"+PatientID+"' ");
        sb.Append("    GROUP BY ip.TransactionID HAVING MAX(EndDate) ORDER BY ich.TransactionID    ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(Description = "IPDInvestigation")]
    public string bindIPDInvestigation(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT otm.Name DepartmentName,IM.Name InvestigationName,DATE_FORMAT(DATE,'%d-%b-%Y') AS DATE, ");
        sb.Append(" SampleDate,pli.Investigation_ID AS InvestigationID,TransactionID,Test_ID, ");
        sb.Append(" IFNULL((SELECT LabInves_Description FROM patient_labinvestigation_ipd_text ");
        sb.Append(" WHERE PLI_ID=pli.ID  LIMIT 1),'')LabInves_Description,pli.ID,IF(Approved=1,'APPROVED','NOT-APPROVED')Approved,");
        sb.Append(" IF(Approved=1,'true','false')Print  FROM patient_labinvestigation_ipd pli  ");
        sb.Append("   INNER JOIN investigation_master im ON PLI.Investigation_ID=im.Investigation_Id  ");
        sb.Append("   INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID   ");
        sb.Append("   INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id    ");
        sb.Append(" WHERE result_flag=1 AND TransactionID='" + TID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(Description = "IPDInvestigation")]
    public string bindIPDInvestigations(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT om.Name DepartmentName,IM.Name InvestigationName,DATE_FORMAT(DATE,'%d-%b-%y') AS DATE,SampleDate,");
        sb.Append(" plo.Investigation_ID AS InvestigationID,plo.TransactionID,plo.Test_ID,plo.ID,");
        sb.Append(" IFNULL((Select LabInves_Description from patient_labinvestigation_ipd_text where PLI_ID=plo.ID  order by PLI_ID desc limit 1),'')LabInves_Description,");
        sb.Append(" plo.LabInvestigationIPD_ID ,");
        sb.Append(" (Case When plo.IsSampleCollected='N' then 'SN'");
        sb.Append(" When plo.IsSampleCollected='Y' and plo.Result_Flag=0 then 'RN'");
        sb.Append(" When plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=0 then 'NA'");
        sb.Append(" When plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=1 then 'A' end");
        sb.Append("  )Status,");
        sb.Append(" IF(plo.Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(plo.Approved=1,'true','false')Print,");
        sb.Append(" IM.Investigation_ID,im.Name,im.ReportType,im.FileLimitationName,");
        sb.Append(" OM.Name Department,om.Print_Sequence ");
        sb.Append(" FROM patient_labinvestigation_ipd plo ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id ");
        sb.Append(" INNER JOIN investigation_observationtype IO ON IM.Investigation_Id = IO.Investigation_ID");
        sb.Append(" INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id");
        sb.Append(" WHERE result_flag is not null ");
        sb.Append(" AND plo.TransactionID ='" + TID + "'");
        
        sb.Append(" Order By plo.Date DESC");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true, Description = "Bind Review Of System")]
    public string saveMedHistory(object medHistory)
    {
        List<MedHistory> medicalHistory = new JavaScriptSerializer().ConvertToType<List<MedHistory>>(medHistory);
        if (medicalHistory.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                string CurrentHistory = "";
                string CurrentHistoryID = "";
                for (int i = 0; i < medicalHistory.Count; i++)
                {
                    if (CurrentHistoryID != "")
                    {
                        CurrentHistoryID += "," + medicalHistory[i].CurrentHistoryID + "";
                        CurrentHistory += "," + medicalHistory[i].CurrentHistory + "";
                    }
                    else
                    {

                        CurrentHistoryID = "" + medicalHistory[i].CurrentHistoryID + "";
                        CurrentHistory = "" + medicalHistory[i].CurrentHistory + "";
                    }
                }
                int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT COUNT(*) FROM cpoe_hpexam WHERE TransactionID='" + medicalHistory[0].TID + "'"));
                if (ChkEntery > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_hpexam SET CurrentHistory='" + CurrentHistory + "',CurrentHistoryID='" + CurrentHistoryID + "',CurrentHistoryText='" + medicalHistory[0].CurrentHistoryText + "',CurrentHistoryCreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',CurrentHistoryCreatedDate=now(), " +
                        " OtherProblem='" + medicalHistory[0].OtherProblem + "',PreviousHospitalizations='" + medicalHistory[0].PreviousHospitalizations + "',AllergiesMed='" + medicalHistory[0].AllergiesMed + "',MedicationAllergies='" + medicalHistory[0].MedicationAllergies + "', " +
                        " FoodAllergies='" + medicalHistory[0].FoodAllergies + "',OtherAllergies='" + medicalHistory[0].OtherAllergies + "',MedicationHistory='" + medicalHistory[0].MedicationHistory + "' WHERE TransactionID='" + medicalHistory[0].TID + "'");
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_hpexam(TransactionID,PatientID,CurrentHistoryID,CurrentHistory,CurrentHistoryText,CurrentHistoryCreatedBy,CurrentHistoryCreatedDate, " +
                        " OtherProblem,PreviousHospitalizations,AllergiesMed,MedicationAllergies,FoodAllergies,OtherAllergies,MedicationHistory)VALUE('" + medicalHistory[0].TID + "','" + medicalHistory[0].PID + "','" + CurrentHistoryID + "', " +
                        " '" + CurrentHistory + "','" + medicalHistory[0].CurrentHistoryText + "','" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + medicalHistory[0].OtherProblem + "','" + medicalHistory[0].PreviousHospitalizations + "', " +
                        " '" + medicalHistory[0].AllergiesMed + "','" + medicalHistory[0].MedicationAllergies + "','" + medicalHistory[0].FoodAllergies + "','" + medicalHistory[0].OtherAllergies + "','" + medicalHistory[0].MedicationHistory + "')");
                }

                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }
   
    [WebMethod(EnableSession = true, Description = "Bind Medical History")]
    public string bindHistory(string TID)
    {
        DataTable history = StockReports.GetDataTable("Select ch.CurrentHistoryID,ch.CurrentHistory,CurrentHistoryText,AllergiesMed,IFNULL(MedicationAllergies,'')MedicationAllergies,IFNULL(FoodAllergies,'')FoodAllergies,IFNULL(OtherAllergies,'')OtherAllergies,IFNULL(MedicationHistory,'')MedicationHistory,IFNULL(OtherProblem,'')OtherProblem,IFNULL(PreviousHospitalizations,'')PreviousHospitalizations from cpoe_medicalHistory_master cmm inner JOIN cpoe_hpexam ch ON cmm.ID=ch.CurrentHistoryID and TransactionID='" + TID + "' where cmm.IsActive=1");
        if (history.Rows.Count > 0)
        {
            return history.Rows[0]["CurrentHistoryID"].ToString() + "~" + history.Rows[0]["CurrentHistoryText"].ToString() + "~" + history.Rows[0]["OtherProblem"].ToString() + "~" + history.Rows[0]["PreviousHospitalizations"].ToString() + "~" + history.Rows[0]["AllergiesMed"].ToString() + "~" + history.Rows[0]["MedicationAllergies"].ToString() + "~" + history.Rows[0]["FoodAllergies"].ToString() + "~" + history.Rows[0]["OtherAllergies"].ToString() + "~" + history.Rows[0]["MedicationHistory"].ToString();
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true, Description = "Save Set item")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string InsertMedicineSet(List<insert> Data)
    {
        int ISEmergency = 0;
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                int Emergency = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(SubcategoryID) FROM appointment WHERE TransactionID='" + Data[0].TID + "' AND SubcategoryID='" + Resources.Resource.EmergencySubcategoryID + "' "));
                if (Emergency > 0)
                {
                    ISEmergency = 1;
                }   
                for (int i = 0; i < Data.Count; i++)
                {
                    string str = "Insert into Patient_medicine(TransactionID,PatientID,Medicine_ID,NoOfDays,NoTimesDay,Dose,Date,DoctorID,LedgerTransactionNo,EnteryBy,Meal,MedicineName,isEmergency,CentreID,Hospital_ID,OrderQuantity) " +
                   " values('" + Data[i].TID + "','" + Data[i].PID + "','" + Data[i].ItemID + "','" + Data[i].Duration + "','" + Data[i].Time + "','" + Data[i].Dose + "','" + System.DateTime.Now.ToString("yyyy-MM-dd") + "','" + Data[i].Doc + "','" + Data[i].LnxNo + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[i].Meal + "','" + Data[i].MedicineName + "','" + ISEmergency + "','" + HttpContext.Current.Session["centreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','"+ Data[i].OrderQuantity +"')";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return "0";
        }

    }
    public class insert
    {
        public string ItemID { get; set; }
        public string Dose { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
        public string Meal { get; set; }
        public string TID { get; set; }
        public string PID { get; set; }
        public string Doc { get; set; }
        public string LnxNo { get; set; }
        public string MedicineName { get; set; }
        public string OrderQuantity { get; set; }
    }
    [WebMethod(EnableSession = true, Description = "Save LabSet item")]
    public string InsertSet(List<Labinsert> Data)
    {

        int len = Data.Count;
        if (len > 0)
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    string str = "Insert into patient_test(Test_ID,TransactionID,PatientID,PrescribeDate,Remarks,DoctorID,LedgerTransactionNo,ConfigID,Quantity,CreatedBy,IsUrgent) " +
                   " values('" + Data[i].ItemID + "','" + Data[i].TID + "','" + Data[i].PID + "',Now(),'" + Data[i].Remarks + "','" + Data[i].Doc + "','" + Data[i].LnxNo + "','3','" + Data[i].Quantity + "','" + HttpContext.Current.Session["ID"].ToString() + "','"+ Data[i].IsUrgent +"')";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

                }
                tranX.Commit();
                return "1";
            }


            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return "0";
        }

    }
   
    [WebMethod(EnableSession = true, Description = "Bind Last visits medicine")]
    public string bindLastVisitMedicine(string PID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT MedicineName,Medicine_ID,NoOfDays,NoTimesDay,PM.Dose,pm.OrderQuantity,im.MedicineType,DATE_FORMAT(EnteryDate,'%d-%b-%Y')DATE,Meal,IsIssue,IFNULL(CONCAT(dm.Title,'',dm.Name),'') drname FROM Patient_medicine pm ");
        sb.Append(" Left JOIN doctor_master dm ON dm.DoctorID=DoctorID ");
        sb.Append(" Inner join f_itemmaster im ON im.itemID=pm.Medicine_ID ");
        sb.Append(" WHERE PatientID='"+ PID +"' ");
        sb.Append(" ORDER BY EnteryDate DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string OutPatient(string App_ID)
    {
        try
        {
            string Update = "UPDATE appointment SET P_Out=1, OutTime=NOW(),P_OutCreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',P_OutDateTime=NOW() WHERE app_Id='" + App_ID + "' ";//TemperatureRoom='1',tempRoomupdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',tempRoomUpdateDate=now()
            StockReports.ExecuteDML(Update);
            return "1";
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public string UpdateTemperatureRoomOut(string App_ID)
    {
        try
        {
            if(string.IsNullOrEmpty(App_ID))
                return "0";
            
            string Update = "UPDATE appointment SET TemperatureRoom='1',tempRoomupdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',tempRoomUpdateDate=now() WHERE app_Id='" + App_ID + "' ";
            StockReports.ExecuteDML(Update);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    
    
    
    
    [WebMethod(EnableSession = true)]
    public string FileClose(string App_ID)
    {
        try
        {
            string Update = "UPDATE appointment SET flag='1',flagupdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',flagUpdateDate=now() WHERE app_Id='" + App_ID + "' ";
            StockReports.ExecuteDML(Update);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
     [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string diagnosisData(string PatientID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ProvisionalDiagnosis As DiagnosisName,Date_FORMAT(CreatedDate,'%d-%b-%Y')DiagnosisDate FROM cpoe_PatientDiagnosis WHERE  PatientID='" + PatientID + "' ORDER BY DATE(CreatedDate)");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt).Replace("?", "'");
        else
            return "";
    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string FinalDiagnosisData(string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT icd.ICD10_3_Code , icd.ICD10_3_Code_Desc ,icd.ICD10_Code , icd.WHO_Full_Desc,DATE_FORMAT(EntDate,'%d-%b-%Y')DATE FROM cpoe_10cm_patient icdp ");
        sb.Append(" INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.PatientID='" + PatientID + "' AND icdp.IsActive=1 ORDER BY DATE(EntDate) ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string AllergiesData(string PatientID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Allergies,Date_FORMAT(PastHistoryEntryDate,'%d-%b-%Y')EntryDate FROM cpoe_hpexam WHERE Allergies<>'' AND PatientID='" + PatientID + "' ORDER BY DATE(PastHistoryEntryDate)");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
      [WebMethod(EnableSession = true, Description = "Save Systemic Examination for Patient")]
    public string SaveSystemicExamination(object dataResult)
    {
        List<Cpoe_Systemic_Examination> dataExam = new JavaScriptSerializer().ConvertToType<List<Cpoe_Systemic_Examination>>(dataResult);
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        
        try
        {
            Cpoe_Systemic_Examination exam = new Cpoe_Systemic_Examination(tranx);
            exam.PatientID = Util.GetString(dataExam[0].PatientID);
            exam.TransactionID = Util.GetString(dataExam[0].TransactionID);
            exam.CardiovascularChk = Util.GetString(dataExam[0].CardiovascularChk);
            exam.CardiovascularSymp = Util.GetString(dataExam[0].CardiovascularSymp);
            exam.CardiovascularSign = Util.GetString(dataExam[0].CardiovascularSign);
            exam.RespiratoryChk = Util.GetString(dataExam[0].RespiratoryChk);
            exam.RespiratorySymp = Util.GetString(dataExam[0].RespiratorySymp);
            exam.RespiratorySign = Util.GetString(dataExam[0].RespiratorySign);
            exam.AbdomenChk = Util.GetString(dataExam[0].AbdomenChk);
            exam.AbdomenSymp = Util.GetString(dataExam[0].AbdomenSymp);
            exam.AbdomenSign = Util.GetString(dataExam[0].AbdomenSign);
            exam.GenitoUrinaryChk = Util.GetString(dataExam[0].GenitoUrinaryChk);
            exam.GenitoUrinarySymp = Util.GetString(dataExam[0].GenitoUrinarySymp);
            exam.GenitoUrinarySign = Util.GetString(dataExam[0].GenitoUrinarySign);
            exam.NervousChk = Util.GetString(dataExam[0].NervousChk);
            exam.NervousSymp = Util.GetString(dataExam[0].NervousSymp);
            exam.NervousSign = Util.GetString(dataExam[0].NervousSign);
            exam.BonesChk = Util.GetString(dataExam[0].BonesChk);
            exam.BonesSymp = Util.GetString(dataExam[0].BonesSymp);
            exam.BonesSign = Util.GetString(dataExam[0].BonesSign);
            exam.HaematologyChk = Util.GetString(dataExam[0].HaematologyChk);
            exam.HaematologySymp = Util.GetString(dataExam[0].HaematologySymp);
            exam.HaematologySign = Util.GetString(dataExam[0].HaematologySign);
            exam.ArterialChk = Util.GetString(dataExam[0].ArterialChk);
            exam.ArterialSymp = Util.GetString(dataExam[0].ArterialSymp);
            exam.ArterialSign = Util.GetString(dataExam[0].ArterialSign);
            exam.VenousChk = Util.GetString(dataExam[0].VenousChk);
            exam.VenousSymp = Util.GetString(dataExam[0].VenousSymp);
            exam.VenousSign = Util.GetString(dataExam[0].VenousSign);
            exam.BreastChk = Util.GetString(dataExam[0].BreastChk);
            exam.BreastSymp = Util.GetString(dataExam[0].BreastSymp);
            exam.BreastSign = Util.GetString(dataExam[0].BreastSign);
            exam.ThyroidChk = Util.GetString(dataExam[0].ThyroidChk);
            exam.ThyroidSymp = Util.GetString(dataExam[0].ThyroidSymp);
            exam.ThyroidSign = Util.GetString(dataExam[0].ThyroidSign);
            exam.EntryBy = Util.GetString(dataExam[0].EntryBy);
            exam.ID = exam.Insert();
            
            tranx.Commit();
            return "1";           
        }
        catch (Exception ex)
        {
            tranx.Rollback();           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";   
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Update Systemic Examination for Patient")]
    public string UpdateSystemicExamination(object dataResult)
    {
        List<Cpoe_Systemic_Examination> dataExam = new JavaScriptSerializer().ConvertToType<List<Cpoe_Systemic_Examination>>(dataResult);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            Cpoe_Systemic_Examination exam = new Cpoe_Systemic_Examination(tranx);
            exam.ID = Util.GetString(dataExam[0].ID);
            exam.PatientID = Util.GetString(dataExam[0].PatientID);
            exam.TransactionID = Util.GetString(dataExam[0].TransactionID);
            exam.CardiovascularChk = Util.GetString(dataExam[0].CardiovascularChk);
            exam.CardiovascularSymp = Util.GetString(dataExam[0].CardiovascularSymp);
            exam.CardiovascularSign = Util.GetString(dataExam[0].CardiovascularSign);
            exam.RespiratoryChk = Util.GetString(dataExam[0].RespiratoryChk);
            exam.RespiratorySymp = Util.GetString(dataExam[0].RespiratorySymp);
            exam.RespiratorySign = Util.GetString(dataExam[0].RespiratorySign);
            exam.AbdomenChk = Util.GetString(dataExam[0].AbdomenChk);
            exam.AbdomenSymp = Util.GetString(dataExam[0].AbdomenSymp);
            exam.AbdomenSign = Util.GetString(dataExam[0].AbdomenSign);
            exam.GenitoUrinaryChk = Util.GetString(dataExam[0].GenitoUrinaryChk);
            exam.GenitoUrinarySymp = Util.GetString(dataExam[0].GenitoUrinarySymp);
            exam.GenitoUrinarySign = Util.GetString(dataExam[0].GenitoUrinarySign);
            exam.NervousChk = Util.GetString(dataExam[0].NervousChk);
            exam.NervousSymp = Util.GetString(dataExam[0].NervousSymp);
            exam.NervousSign = Util.GetString(dataExam[0].NervousSign);
            exam.BonesChk = Util.GetString(dataExam[0].BonesChk);
            exam.BonesSymp = Util.GetString(dataExam[0].BonesSymp);
            exam.BonesSign = Util.GetString(dataExam[0].BonesSign);
            exam.HaematologyChk = Util.GetString(dataExam[0].HaematologyChk);
            exam.HaematologySymp = Util.GetString(dataExam[0].HaematologySymp);
            exam.HaematologySign = Util.GetString(dataExam[0].HaematologySign);
            exam.ArterialChk = Util.GetString(dataExam[0].ArterialChk);
            exam.ArterialSymp = Util.GetString(dataExam[0].ArterialSymp);
            exam.ArterialSign = Util.GetString(dataExam[0].ArterialSign);
            exam.VenousChk = Util.GetString(dataExam[0].VenousChk);
            exam.VenousSymp = Util.GetString(dataExam[0].VenousSymp);
            exam.VenousSign = Util.GetString(dataExam[0].VenousSign);
            exam.BreastChk = Util.GetString(dataExam[0].BreastChk);
            exam.BreastSymp = Util.GetString(dataExam[0].BreastSymp);
            exam.BreastSign = Util.GetString(dataExam[0].BreastSign);
            exam.ThyroidChk = Util.GetString(dataExam[0].ThyroidChk);
            exam.ThyroidSymp = Util.GetString(dataExam[0].ThyroidSymp);
            exam.ThyroidSign = Util.GetString(dataExam[0].ThyroidSign);
            exam.UpdateBy = Util.GetString(dataExam[0].UpdateBy);
            int rows = exam.Update();

            tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();          
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        
    }

    [WebMethod(EnableSession = true, Description = "Bind Systemic Examination for Patient")]
    public string BindSystemicExaminations(string PatientID, string TransactionID)
    {
        string result = "0";
        DataTable dt=StockReports.GetDataTable(" SELECT * FROM cpoe_systemic_examination WHERE TransactionID='" + TransactionID + "' ORDER BY EntryDate DESC LIMIT 1 ");       
        if (dt.Rows.Count > 0)
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
        return result;
    }
    [WebMethod(EnableSession = true, Description = "Update Doctor Tab Information")]
    public string BindSystemicExamination(string TID,int TabID)
    {
        bool Status = AllQuery.UpdateDoctorTab_Information(TID, TabID);
        if (!Status)
            return "1";
        else
            return "0";
    }

    [WebMethod(EnableSession = true,Description="Search Vitial Sign List")]
    public  string SearchVitialSignList(string Department)
    {
        DataTable dtAllDepartment = new DataTable();
       StringBuilder sb=new StringBuilder();
       sb.Append(" SELECT c.VitialID,c.VitialSign,NAME AS DepartmentName,IF(IFNULL(IsMandtory,0)=1,'Y','N')IsMandtory,tm.ID as DepartmentID,c.CentreID  FROM cpoe_VitalExaminationMandtoryMaster c ");
        sb.Append(" CROSS JOIN type_master tm ");
        sb.Append(" LEFT JOIN DoctorDepartmentwiseVitialSign ddvs ON DepartmentID=tm.ID  AND c.VitialID=ddvs.VitialID AND ddvs.IsMandtory=1 ");
        sb.Append(" WHERE tm.type='Doctor-Department' "); 
        if(Department!="0")
        {
            sb.Append(" AND tm.id='" + Department + "'  ");
        }
        dtAllDepartment = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtAllDepartment);
    }

    [WebMethod(EnableSession = true, Description = "Save Doctor Department Wise Vitial Sign Mandtory")]
    public string SaveDeptWiseVitilMandtory(List<DepartmentwiseVitialSignMandtory> VitialSign) {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < VitialSign.Count; i++)
            {
                var item = VitialSign[i];
                item.Createdby = HttpContext.Current.Session["ID"].ToString();
                item.Ipaddress = All_LoadData.IpAddress();
                if (item.Ismandtory.ToUpper() == "Y" || item.Ismandtory.ToUpper() == "1")
                    item.Ismandtory = "1";
                else
                    item.Ismandtory = "0";

                excuteCMD.DML(tnx, "UPDATE DoctorDepartmentwiseVitialSign SET IsMandtory=0 WHERE DepartmentID=@DepartmentID and CentreID=@CentreID and VitialID=@VitialID ", CommandType.Text, item);
                if (item.Ismandtory == "1")
                {
                    var sqlCmd = new StringBuilder(" INSERT INTO DoctorDepartmentwiseVitialSign (DepartmentID,Department,VitialID,VitialName,IsMandtory,CreatedBy,CreateDate,IPAddress,CentreID) ");
                    sqlCmd.Append(" VALUES (@DepartmentID,@Department,@VitialID,@VitialSign,@Ismandtory,@Createdby,NOW(),@Ipaddress,@CentreID) ");
                    excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                }
              
            }


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    
    }


    public class DepartmentwiseVitialSignMandtory {
        public string Department { get; set; }
        public string VitialSign { get; set; }
        public string Ismandtory { get; set; }
        public int DepartmentID { get; set; }
        public int VitialID { get; set; }
        public string Createdby { get; set; }
        public string Ipaddress { get; set; }
        public string Updatedby { get; set; }
        public string Updateddate { get; set; }
        public int CentreID { get; set; }
    }
    
}