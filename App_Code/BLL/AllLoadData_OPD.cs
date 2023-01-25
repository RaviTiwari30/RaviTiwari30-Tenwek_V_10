using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Linq;
/// <summary>
/// Summary description for AllLoadData_OPD
/// </summary>
public class AllLoadData_OPD
{
    public AllLoadData_OPD()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static DataTable bindOPDPackageDetail(string PackageID, string PanelID,int CentreID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Item,ItemID,SubCategoryID,CAST(LabType AS BINARY)LabType,IFNULL(Type_ID,'')Type_ID,IF(Sample='R',Sample,'N')Sample,TnxType ");
        sb.Append(" ,IFNULL(ItemCode,'')ItemCode,IFNULL(GenderInvestigate,'')GenderInvestigate,IFNULL(Investigation_Id,'')Investigation_Id,IFNULL(Rate,0)Rate,Quantity,IsOutSource,RateListID ");
        sb.Append(" FROM( SELECT detailid,im.TypeName Item,ims.GenderInvestigate, ");
        sb.Append(" im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode,(CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID IN (25,7) THEN 'PRO'  ");
        sb.Append(" WHEN cr.ConfigID IN (20,6)  THEN 'OTH' END)LabType,(CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID IN (25,7) THEN '4' ");
        sb.Append(" WHEN cr.ConfigID IN(20,6) THEN '5' END)TnxType,ims.Investigation_Id,pd.Quantity,ifnull(ims.isOutSource,0)IsOutSource, ");
        sb.Append(" (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample,IFNULL(rt.Rate,0)Rate,IFNULL(rt.ID,0)RateListID ");
        sb.Append(" FROM package_detail pd INNER JOIN f_itemmaster im ON im.itemid=pd.ItemID  ");
        sb.Append(" INNER JOIN f_subcategorymaster sm   ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON sm.CategoryID = cr.CategoryID  ");
        sb.Append(" LEFT OUTER JOIN f_ratelist rt ON im.ItemID = rt.itemID AND rt.PanelID=" + PanelID + " AND rt.IsCurrent=1 AND rt.CentreID="+ CentreID +" ");
        sb.Append(" LEFT OUTER JOIN f_rate_schedulecharges rs   ON rs.ScheduleChargeID = rt.ScheduleChargeID  AND rs.IsDefault=1 LEFT JOIN investigation_master ims ON ims.Investigation_Id = pd.InvestigationId  ");
        sb.Append(" WHERE pd.PackageID='" + PackageID + "' AND pd.IsActive=1 AND im.IsActive=1 GROUP BY  IM.ItemID)t1 ORDER BY detailid");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable bindOPDPackageEdit(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Item,ItemID,SubCategoryID,CAST(LabType AS BINARY)LabType,IFNULL(Type_ID,'')Type_ID,IF(Sample='R',Sample,'N')Sample,TnxType ");
        sb.Append(" ,IFNULL(ItemCode,'')ItemCode,IFNULL(GenderInvestigate,'')GenderInvestigate,IFNULL(Investigation_Id,'')Investigation_Id,Quantity ,IsVaccinationAllow,IsConsumablesAllow");
        sb.Append(" FROM( SELECT im.TypeName Item,ims.GenderInvestigate,mm.IsVaccinationAllow,mm.IsConsumablesAllow, ");
        sb.Append(" im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode,(CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID IN (25,7) THEN 'PRO'  ");
        sb.Append(" WHEN cr.ConfigID IN (20,6)  THEN 'OTH' END)LabType,(CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID IN (25,7) THEN '4' ");
        sb.Append(" WHEN cr.ConfigID IN(20,6) THEN '5' END)TnxType,ims.Investigation_Id,pd.Quantity, ");
        sb.Append(" (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample ");
        sb.Append(" FROM package_detail pd INNER JOIN f_itemmaster im ON im.itemid=pd.ItemID  ");
        sb.Append(" INNER JOIN package_master mm ON mm.PackageID=pd.PackageID INNER JOIN f_subcategorymaster sm   ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON sm.CategoryID = cr.CategoryID  ");
        sb.Append("  LEFT JOIN investigation_master ims ON ims.Investigation_Id = pd.InvestigationId  ");
        sb.Append(" WHERE pd.PackageID='" + PackageID + "' AND pd.IsActive=1 AND im.IsActive=1 )t1 ORDER BY Item");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable bindOPDPackageDocDetail(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(CONCAT(dm.Title,' ',dm.Name),'')DName,sub.Name VisitType,tm.Name Department,IFNULL(pdv.DoctorID,'')DoctorID,sub.SubCategoryID,  ");
        sb.Append(" pdv.DocDepartmentID FROM Package_DoctorVistiDetail pdv INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=pdv.SubCategoryID INNER JOIN type_master tm ON tm.id=pdv.DocDepartmentID AND TypeID=5");
        sb.Append(" LEFT JOIN doctor_master dm ON dm.DoctorID=pdv.DoctorID ");
        sb.Append(" where pdv.PackageID='" + PackageID + "' ");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable bindPackageRate(string PackageID, string PanelID, decimal panelCurrencyFactor,string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rt.ID,(IFNULL(rt.Rate,0)*" + panelCurrencyFactor + ")Rate,sc.SubCategoryID,rs.ScheduleChargeID,IFNULL(rt.ItemCode,'')ItemCode FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_ratelist rt ON im.ItemID = rt.itemID ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
        sb.Append(" INNER JOIN f_rate_schedulecharges rs ON rs.ScheduleChargeID = rt.ScheduleChargeID ");
        sb.Append(" WHERE im.IsActive=1 AND rs.IsDefault=1 and im.Type_ID='" + PackageID + "' AND cf.ConfigID=23 ");
        sb.Append(" AND rt.PanelID=" + PanelID + " AND rt.IsCurrent=1 and rt.CentreID='"+CentreID+"'");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable SearchAppointment(string DocID, DateTime FromDate, DateTime ToDate, string AppNo, string IsConform, string VisitType, string Status, string doctorDepartmentID, string Centre = "")
    {
        StringBuilder sb = new StringBuilder();
        //=======Start By Amit======
        sb.Append("SELECT app.IsConform,app.IsCancel,app.IsReschedule,app.TransactionID,app.App_ID,dm.DoctorID,TIME_FORMAT(app.TIME,'%l:%i %p')AppTime ,IFNULL(app.LedgerTnxNo,'')LedgerTnxNo,app.CentreID,cm.CentreName,");
        sb.Append("app.PatientID AS UHID,app.AppNo,CONCAT(DATE_FORMAT(app.DATE,'%d-%b-%Y'), ' ' ,TIME_FORMAT(app.TIME,'%l:%i %p'))AppDateTime,(SELECT CONCAT(em.Title,' ',em.Name)  FROM employee_master em WHERE em.EmployeeID=app.EntryUserID)AppBookingBy,");
        sb.Append("CONCAT(app.title,' ',app.Pname)NAME,app.Age,VisitType AS PtientType,ContactNo,(SELECT CONCAT(dm.Title,' ',NAME)  FROM Doctor_master dm WHERE dm.DoctorID=app.DoctorID)DoctorName,(SELECT dm.Specialization  FROM Doctor_master dm WHERE dm.DoctorID=app.DoctorID)Speciality,");
        sb.Append("'' AS STATUS,(SELECT Complain FROM complain_master WHERE Complain_id = PurposeOfVisitID)PurposeOfVisit,(CASE WHEN app.IsConform=1 THEN 'YES' ELSE 'NO' END)IsConform,if(app.IsConform=1,DATE_FORMAT(app.ConformDate,'%d-%b-%Y %l:%i %p'),'')ConformDate,(SELECT CONCAT(em.Title,' ',em.Name)  FROM employee_master em WHERE em.EmployeeID=app.ConformBy)ConformBy,");
        sb.Append("(CASE WHEN app.IsReschedule=1 THEN 'YES' ELSE 'NO' END)IsReschedule,DATE_FORMAT(app.ReScheduleDate,'%d-%b-%Y %l:%i %p')ReScheduleDate,(SELECT CONCAT(em.Title,' ',em.Name)  FROM employee_master em WHERE em.EmployeeID=app.RescheduleBy)RescheduleBy,");
        sb.Append("(CASE WHEN app.IsCancel=1 THEN 'YES' ELSE 'NO' END)IsCancel,DATE_FORMAT(app.CancelDate,'%d-%b-%Y %l:%i %p')CancelDate,(SELECT CONCAT(em.Title,' ',em.Name)  FROM employee_master em WHERE em.EmployeeID=app.Cancel_UserID)CanceledBy,");
        sb.Append("app.CancelReason,CONCAT(l.BillDate,' ',l.TIME)BillDateTime,(SELECT CONCAT(em.Title,' ',em.Name)  FROM employee_master em WHERE em.EmployeeID=l.UserID)BillGenerateBy ");
        sb.Append(" FROM appointment app INNER JOIN Center_master cm ON cm.CentreID = app.CentreID INNER JOIN doctor_master dm ON app.DoctorID=dm.DoctorID INNER JOIN type_master tm ON tm.ID=dm.DocDepartmentID ");
        sb.Append(" LEFT JOIN f_ledgertransaction l ON l.TransactionID=app.TransactionID WHERE app.Date>='" + FromDate.ToString("yyyy-MM-dd") + "' AND app.Date<='" + ToDate.ToString("yyyy-MM-dd") + "'");
        //=======End By Amit======
        if (Centre != "")
            sb.Append("  AND app.CentreID IN (" + Centre + ") ");
        else
            sb.Append(" AND app.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

        if (DocID != "")
            sb.Append(" AND app.DoctorID='" + DocID + "'");

        if (doctorDepartmentID != "0" && doctorDepartmentID != "")
            sb.Append(" AND tm.ID in ( " + doctorDepartmentID + ")");


        if (AppNo != "")
            sb.Append(" AND AppNo='" + AppNo + "'");
        if (IsConform != "")
            sb.Append(" AND IsConform=1");
        if (VisitType != "" && VisitType != "All")
            sb.Append(" AND VisitType='" + VisitType + "'");
        if (Status != "" && Status != "All")
        {
            if (Status == "Confirmed")
                sb.Append(" AND app.IsConform=1");
            if (Status == "ReScheduled")
                sb.Append(" AND IsReschedule=1");
            if (Status == "Canceled")
                sb.Append(" AND app.IsCancel=1");
            if (Status == "App. Time Expired")
                sb.Append(" AND app.DATE<'" + System.DateTime.Now.ToString("yyyy-MM-dd") + "' AND app.TIME<'" + System.DateTime.Now.ToString("hh: mm tt") + "' AND app.IsConform=0 ");
            if (Status == "Pending")
                sb.Append(" AND app.IsConform=0");
        }


        sb.Append(" GROUP BY app.App_ID  ORDER BY app.DATE,app.TIME,app.AppNo");
        return StockReports.GetDataTable(sb.ToString());

    }
    
    public static DataTable SearchAppointment(string DocID, DateTime FromDate, DateTime ToDate, string AppNo, string IsConform)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PatientID,App_ID,AppNo,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
        sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%y')AppDate,IsConform,IsReschedule, IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%y %l:%i %p')ConformDate, ");
        sb.Append(" IFNULL(LedgerTnxNo,'')LedgerTnxNo FROM appointment app ");
        sb.Append(" where Date>='" + FromDate.ToString("yyyy-MM-dd") + "'");
        sb.Append(" and Date<='" + ToDate.ToString("yyyy-MM-dd") + "' AND app.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'  ");

        if (DocID != "")
        {
            sb.Append(" and DoctorID='" + DocID + "'");
        }
        if (AppNo != "")
        {
            sb.Append(" and AppNo='" + AppNo + "'");
        }
        if (IsConform != "")
        {
            sb.Append(" and IsConform=1");
        }
        sb.Append("  ORDER BY DATE,TIME,AppNo");
        return StockReports.GetDataTable(sb.ToString());

    }
    public static DataTable SearchConfirm(DateTime FromDate, DateTime ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT app_id,PatientID,AppNo,TransactionID,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
        sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%y')AppDate,IsConform,DATE_FORMAT(ConformDate,'%d-%b-%y %l:%i %p')ConformDate,IFNULL(LedgerTnxNo,'')LedgerTnxNo FROM appointment app ");
        sb.Append(" where Date>='" + FromDate.ToString("yyyy-MM-dd") + "'");
        sb.Append(" and Date<='" + ToDate.ToString("yyyy-MM-dd") + "'");
        sb.Append("  AND IsConform = 1 AND IFNULL(PatientID,'')<>'' AND app.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable LoadAppointedSlots_DoctorWise(string DocotrID, string PatientType, DateTime AppDate)
    {

        //Get list of Already Appointed time
        string str = "SELECT TIME as AppointmentTime FROM Appointment WHERE DoctorID='" + DocotrID + "' AND DATE='" + AppDate.ToString("yyyy-MM-dd") + "'";
        DataTable dtAppointedList = StockReports.GetDataTable(str);

        //Get Doctor bufferTimeSlots
        str = "";
        str = "select * from doctor_hospital where DoctorID='" + DocotrID + "' and Day = DATE_FORMAT('" + AppDate.ToString("yyyy-MM-dd") + "','%W')";
        DataTable dtDocSlots = StockReports.GetDataTable(str);

        int avgtime = 0;
        DataTable dtSlots = new DataTable();
        dtSlots.Columns.Add("Slots");
        dtSlots.Columns.Add("IsAvailable");

        if (dtDocSlots.Rows.Count > 0)
        {
            foreach (DataRow dr in dtDocSlots.Rows)
            {
                DateTime starttime = DateTime.Parse(AppDate.ToString("yyyy-MM-dd") + " " + dr["StartTime"].ToString());
                DateTime endtime = DateTime.Parse(AppDate.ToString("yyyy-MM-dd") + " " + dr["EndTime"].ToString());

                TimeSpan span = endtime.Subtract(starttime);
                int total_min = Util.GetInt(span.TotalMinutes);
                if (PatientType == "1")
                {
                    avgtime = Convert.ToInt32(dr["DurationforNewPatient"].ToString());
                }
                else
                {
                    avgtime = Convert.ToInt32(dr["DurationforOldPatient"].ToString());
                }
                int noslots = total_min / avgtime;
                int add = 0;

                for (int i = 0; i < noslots; i++)
                {
                    DataRow row = dtSlots.NewRow();
                    if (starttime.AddMinutes(add).CompareTo(DateTime.Now) > 0)
                    {
                        row["Slots"] = (starttime.AddMinutes(add)).ToShortTimeString();
                        if (dtAppointedList.Rows.Count > 0)
                        {
                            foreach (DataRow dr2 in dtAppointedList.Rows)
                            {
                                if ((Util.GetDateTime((starttime.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm:ss") == dr2["AppointmentTime"].ToString()))
                                {
                                    row["IsAvailable"] = "1";
                                }
                                //else
                                //{
                                //    row["IsAvailable"] = "0";
                                //}
                            }
                        }
                        else
                        {
                            row["IsAvailable"] = "0";
                        }
                        dtSlots.Rows.Add(row);
                    }
                    add += avgtime;
                }
            }
        }
        return dtSlots;
    }

    public static DataTable bindAppointmentDetail(string AppID)
    {
        StringBuilder sb = new StringBuilder("SELECT 0 OPDAdvanceAmount, App.Title, PFirstName, PLastName,App.`PatientID`, App.MaritalStatus , App.Sex Gender, App.Age, DATE_FORMAT(App.DOB, '%d-%m-%Y') DOB, App.Email, App.ContactNo Mobile, App.Nationality, City, App.RefDocID, App.PanelID `PanelID`, fpm.`HideRate`, fpm.`ShowPrintOut`, App.ItemID, App.Amount, App.Notes, App.App_ID,   DATE_FORMAT(App.Date,'%d-%b-%Y')`Date`, App.PurposeOfVisitID, App.Address House_No, Taluka, LandMark, App.District, IF(App.PinCode = 0, '', App.PinCode) PinCode, App.Place, App.Occupation, App.Relation, App.RelationName, App.PatientType patientType, App.AdharCardNo, mas.appointmentType , App.VisitType, CountryID countryID, DistrictID districtID, CityID cityID, TalukaID, App.DoctorID `DoctorID`, App.SubcategoryID, App.State, App.StateID, App.RelationContactNo,  App.`ScheduleChargeID`,App.`ReferenceCodeOPD`,  App.ReferenceCodeOPD `ParentID`,app.RateListID ,  IFNULL(app.`TransactionID`,'')TransactionID,  app.`Time`,app.`EndTime`,Occupation,PlaceOfBirth placeofBirth,IsInternational,EthenicGroup,IsTranslatorRequired,FacialStatus,Race,Employement,MonthlyIncome,ParmanentAddress parmanentAddress,IdentificationMarkSecond,IdentificationMark,LanguageSpoken,EmergencyRelationOf,OverSeaNumber OverSeanumber ,EmergencyPhoneNo,Phone_STDCODE, ResidentialNumber, ResidentialNumber_STDCODE, EmergencyFirstName, EmergencySecondName, InternationalCountryID, InternationalCountry, InternationalNumber, app.Phone, EmergencyAddress ");
        sb.Append(" EmergencyRelationShip FROM Appointment App INNER JOIN master_appointmenttype mas ON app.TypeOfApp = mas.appointmentTypeid INNER JOIN f_Panel_Master fpm ON fpm.PanelID = App.PanelID");
        sb.Append(" WHERE App.App_ID=" + Util.GetInt(AppID) + " AND App.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        return StockReports.GetDataTable(sb.ToString());

    }

    public static DataTable SearchRegisteredPatientWithAddress(DateTime FromDate, DateTime ToDate, string CentreID, int countryId, int stateid, int districtID, int cityid, string village)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,pm.CentreID,pm.PatientID,pm.PatientID MRNo,CONCAT(pm.House_No,', ',IF(pm.PinCode=0,'',CONCAT(pm.PinCode,', ')),pm.City,', ',pm.Country)Address,");
        sb.Append(" pm.mobile,pm.Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y')DateEnrolled,CONCAT(pm.title,' ',PName)PName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB ");
        sb.Append(" ,(Select CONCAT(title,' ',Name)RegisterBy from Employee_master WHERE EmployeeID=RegisterBy)RegisterBy,IF(pm.IsInternational=1,'YES','NO')IsInternational,pm.InternationalCountry,pm.InternationalNumber ");
        sb.Append(" FROM Patient_master pm INNER JOIN center_master cm ON pm.CentreID=cm.CentreID");
        sb.Append(" WHERE DATE(pm.DateEnrolled)>='" + FromDate.ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND DATE(pm.DateEnrolled)<='" + ToDate.ToString("yyyy-MM-dd") + "' AND cm.CentreID IN (" + CentreID + ")");
        if (countryId != 0)
        {
            sb.Append(" AND pm.countryID='" + countryId + "'");
        }
        if (stateid != 0)
        {
            sb.Append(" AND pm.StateID='" + stateid + "'");
        }
        if (districtID != 0)
        {
            sb.Append(" AND pm.districtID='" + districtID + "'");
        }
        if (cityid != 0)
        {
            sb.Append(" AND pm.cityID='" + cityid + "'");
        }
        if (village != "")
        {
            sb.Append(" OR Locality='" + village + "'");
        }

        sb.Append(" order by pm.DateEnrolled");
        return StockReports.GetDataTable(sb.ToString());

    }
    public static DataTable SearchRegisteredPatient(DateTime FromDate, DateTime ToDate, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,pm.CentreID,pm.PatientID,pm.PatientID MRNo,CONCAT(pm.House_No,', ',IF(pm.PinCode=0,'',CONCAT(pm.PinCode,', ')),pm.City,', ',pm.Country)Address,");
        sb.Append(" pm.mobile,pm.Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y')DateEnrolled,CONCAT(pm.title,' ',PName)PName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB ");
        sb.Append(" ,(Select CONCAT(title,' ',Name)RegisterBy from Employee_master WHERE EmployeeID=RegisterBy)RegisterBy");
        sb.Append(" FROM Patient_master pm INNER JOIN center_master cm ON pm.CentreID=cm.CentreID");
        sb.Append(" WHERE DATE(pm.DateEnrolled)>='" + FromDate.ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND DATE(pm.DateEnrolled)<='" + ToDate.ToString("yyyy-MM-dd") + "' AND cm.CentreID IN (" + CentreID + ")");
        sb.Append(" order by pm.DateEnrolled");
        return StockReports.GetDataTable(sb.ToString());

    }
    public static DataTable DoctorWiseOPDDetail(string DocID, DateTime FromDate, DateTime ToDate, int PackageCondition, string Centre, string DocGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT('Dr.',' ',ltd.ItemName)ItemName,app.AppNo,ltd.ItemID,lt.LedgerTransactionNo,CONCAT(pm.title,' ',pm.Pname)Pname,CONCAT(pm.Age,' ',LEFT(pm.Gender,1))AGE,Rate*Quantity GrossAmount, CONCAT(lt.date,' ',lt.time)DATETIME,lt.PatientID,cm.`CentreID`,cm.`CentreName`,  ");
        sb.Append(" (SELECT Company_Name FROM f_panel_master WHERE PanelID=pmh.PanelID)PanelName,dm.Designation As Dept,lt.DiscountReason,ltd.Amount NetAmount,pmh.DoctorID,  ");
        sb.Append(" ltd.SubCategoryID,sm.Name,IF(IFNULL(rc.ReceiptNo,'')='',lt.BillNo,rc.ReceiptNo)ReceiptNo,if(lt.TypeofTnx='OPD-Package',0,((ltd.Amount/lt.NetAmount)*(IFNULL(rc.AmountPaid,0))))AmountPaid,ltd.Amount NetAmount,lt.DiscountOnTotal FROM f_ledgertransaction lt INNER JOIN patient_master pm ");
        sb.Append(" ON lt.PatientID=pm.PatientID INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo ");
        sb.Append(" INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID INNER JOIN appointment app ON app.LedgerTnxNo=lt.LedgerTransactionNo ");
        if (PackageCondition == 1)
            sb.Append(" AND sm.CategoryID='LSHHI1' ");
        sb.Append(" LEFT OUTER  JOIN f_reciept rc ON rc.AsainstLedgerTnxNo=lt.LedgerTransactionNo");
        sb.Append(" WHERE lt.Date>='" + FromDate.ToString("yyyy-MM-dd") + "' AND lt.Date<='" + ToDate.ToString("yyyy-MM-dd") + "'   AND lt.IsCancel=0 and lt.CentreID IN (" + Centre + ")");
        if (PackageCondition == 0)
            sb.Append("  AND ltd.TypeOfTnx='OPD-APPOINTMENT' ");
        if (DocID != "")
            sb.Append(" and pmh.DoctorID='" + DocID + "'");
        if (DocGroup != "0")
            sb.Append(" and dm.DocGroupID='" + DocGroup + "'");
        sb.Append("  ORDER BY ItemName,lt.Date,ReceiptNo");

        return StockReports.GetDataTable(sb.ToString());

    }
    public static DataTable DoctorWiseOPDSummary(string DocID, DateTime FromDate, DateTime ToDate, int PackageCondition, string Centre, string DocGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ltd.ItemName Doctor,sm.Name Visit,SUM(Quantity) COUNT,SUM(Rate*Quantity)Amount,cm.`CentreID`,cm.`CentreName`  FROM f_ledgertransaction lt  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo ");
        sb.Append("INNER JOIN center_master cm ON cm.`CentreID`=ltd.`CentreID` INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID ");
        if (PackageCondition == 1)
            sb.Append(" AND sm.CategoryID='LSHHI1' ");
        sb.Append(" WHERE  lt.Date>='" + FromDate.ToString("yyyy-MM-dd") + "' AND lt.Date<='" + ToDate.ToString("yyyy-MM-dd") + "' AND lt.iscancel=0 and ltd.CentreID IN (" + Centre + ") ");
        if (PackageCondition == 0)
            sb.Append(" AND ltd.TypeOfTnx='OPD-APPOINTMENT' ");
        if (DocGroup != "0")
            sb.Append(" and dm.DocGroupID='" + DocGroup + "'");
        sb.Append(" GROUP BY ltd.ItemID,ltd.SubCategoryID ");

        sb.Append(" UNION ALL ");

        sb.Append(" SELECT im.TypeName `Doctor`,  'Unbilled' Visit ,COUNT(ap.App_ID) `Count`, SUM(ap.Amount) Amount,ap.CentreID ,cm.CentreName ");
        sb.Append(" FROM appointment ap ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ap.ItemID ");
        sb.Append(" INNER JOIN center_master cm ON cm.CentreID=ap.CentreID ");
        sb.Append(" WHERE ap.IsConform=1 AND ap.LedgerTnxNo=0  and  ap.Date>='" + FromDate.ToString("yyyy-MM-dd") + "' AND ap.Date<='" + ToDate.ToString("yyyy-MM-dd") + "' AND ap.CentreID IN (" + Centre + ")  GROUP BY ap.ItemID ");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable BindPatientTrackDetails(string PatientID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(a.date, '%d-%b-%Y')DATE,PatientID MRNo,LOWER(a.TypeOfTnx)TypeOfTnx,BillNo,GrossAmount,DiscountOnTotal,NetAmount,(SELECT CONCAT(Title,' ',Pname) FROM Patient_Master WHERE PatientID='" + PatientID + "')PName FROM (");
        sb.Append(" SELECT lt.Date,lt.PatientID,TypeOfTnx,BillNo,GrossAmount,DiscountOnTotal,NetAmount FROM f_ledgertransaction lt WHERE lt.isCancel=0 AND lt.PatientID='" + PatientID + "' AND TypeOfTnx IN ('OPD-APPOINTMENT','GEN-OPD','opd-lab','opd-package')");
        sb.Append(" UNION ALL");
        sb.Append(" SELECT DateOfAdmit,pmh.PatientID,'Admission','',0,0,0 FROM ipd_case_history ich INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ich.TransactionID WHERE pmh.PatientID='" + PatientID + "' AND ich.Status='IN' AND pmh.type='IPD' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT DateOfAdmit,pmh.PatientID,'Discharge','',0,0,0 FROM ipd_case_history ich INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ich.TransactionID WHERE pmh.PatientID='" + PatientID + "' AND ich.Status='OUT' AND pmh.type='IPD' ");
        sb.Append(" UNION ALL");
        sb.Append(" SELECT DATE,PatientID,'Surgery Booking','',Amount,0,Amount FROM presurgerybooking WHERE PatientID='" + PatientID + "'");
        sb.Append(" )a ORDER BY DATE");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable SearchPreSurgery(string PreSurgeryID, string PID, DateTime FromDate, DateTime ToDate, string PName, int IsRejected)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pre_s.PreSurgeryID,pre_s.DiagnosisName,pm.PatientID,pre_s.ProcedureName,pre_s.TotalAmt,");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName)Pname,pm.Age, DATE_FORMAT(pre_s.date,'%d-%b-%y')DATE");
        sb.Append(" FROM presurgerybooking_summary pre_s INNER JOIN patient_master pm ON pm.PatientID=pre_s.PatientID");
        if (PreSurgeryID == "" && PID == "" && PName == "")
            sb.Append(" AND DATE(pre_s.Date)>='" + FromDate.ToString("yyyy-MM-dd") + "' AND DATE(pre_s.Date)<='" + ToDate.ToString("yyyy-MM-dd") + "' ");
        if (PreSurgeryID != "")
            sb.Append(" and pre_s.PreSurgeryID='" + PreSurgeryID + "'");
        if (PID != "")
            sb.Append(" and pm.PatientID='" + PID + "'");
        if (PName != "")
            sb.Append(" and pm.PName like '%" + PName + "%'");
        sb.Append(" and pre_s.IsRejected=" + Util.GetInt(IsRejected) + "");
        return StockReports.GetDataTable(sb.ToString());

    }
    public static DataTable SearchPhysioAppointment(string DocID, DateTime FromDate, DateTime ToDate, string IsConform, string Status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT app.Amount,TransactionID,PatientID,App_ID,AppNo,CONCAT(app.title, ' ', Pname) NAME,(SELECT CONCAT(Title, ' ', NAME) FROM Doctor_master dm");
        sb.Append("      WHERE dm.DoctorID = app.DoctorID) DoctorName,app.DoctorID,VisitType,TIME_FORMAT(TIME, '%l: %i %p') AppTime,DATE_FORMAT(DATE, '%d-%b-%Y') AppDate,");
        sb.Append("        IsConform,IsReschedule,IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%Y %l:%i %p') ConformDate,IFNULL(LedgerTnxNo, '') LedgerTnxNo,");
        sb.Append("       CONCAT(DATE, ' ', TIME) AppDateTime,ContactNo,'' STATUS ");
        sb.Append("       FROM appointment app  INNER JOIN (SELECT DoctorID FROM doctor_hospital WHERE department='Physiotherapy' GROUP BY DoctorID)dh    ON dh.DoctorID=app.DoctorID");
        sb.Append(" where Date>='" + FromDate.ToString("yyyy-MM-dd") + "'");
        sb.Append(" and Date<='" + ToDate.ToString("yyyy-MM-dd") + "' and app.IsCancel=0");

        if (DocID != "")
        {
            sb.Append(" and app.DoctorID ='" + DocID + "'");
        }

        if (IsConform != "")
        {
            sb.Append(" and IsConform=1");
        }
        if (Status != "" && Status != "All")
        {
            if (Status == "Confirmed")
            {
                sb.Append(" and IsConform=1");
            }
            if (Status == "ReScheduled")
            {
                sb.Append(" and IsReschedule=1");
            }
            if (Status == "Canceled")
            {
                sb.Append(" and IsCancel=1");
            }
            if (Status == "App Time Expired")
            {
                //sb.Append(" and AppDateTime<'" + System.DateTime.Now.ToString("dd-MMM-yy hh: mm tt") + "' and IsConform=0");
                sb.Append(" and DATE<'" + System.DateTime.Now.ToString("yyyy-MM-dd") + "'and TIME<'" + System.DateTime.Now.ToString("hh: mm tt") + "' and IsConform=0");
            }
            if (Status == "Pending")
            {
                sb.Append(" and IsConform=0");
            }
        }


        sb.Append("  ORDER BY DATE,TIME,AppNo");
        return StockReports.GetDataTable(sb.ToString());

    }
    public static DataTable LoadSympton(string PID, string TID, string LnxNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,AppID,SymptomsName,(SELECT CONCAT(Title,' ',NAME) ");
        sb.Append(" FROM employee_master em WHERE em.EmployeeID=sd.EntryBy)");
        sb.Append(" EntryBy,DATE_FORMAT(EntryDate,'%d %b %y %l:%i %p')EntryDate FROM cpoe_Symptoms_detail sd");
        sb.Append(" where sd.LedgerTnxNo='" + LnxNo + "' and sd.TransactionID='" + TID + "' and PatientID='" + PID + "'");
        sb.Append(" ORDER BY ID ASC");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable dtBindOPDPackage()
    {
        return StockReports.GetDataTable("SELECT CONCAT(pm.PackageID,'#',itm.ItemID,'#',sub.SubCategoryID,'#',pm.IsVaccinationAllow,'#',pm.IsConsumablesAllow)PackageID,pm.Name,itm.ItemID FROM package_master pm INNER JOIN f_itemmaster itm ON  itm.Type_ID=pm.PackageID INNER JOIN f_subcategorymaster " +
            "  sub ON sub.SubCategoryID=itm.subCategoryID INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID AND con.configID=23  WHERE pm.IsActive=1 AND itm.IsActive=1 ORDER BY NAME ");

    }
    public static void BindOPDPackage(DropDownList ddlObject)
    {
        DataTable dtData = dtBindOPDPackage();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "PackageID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.Items.Insert(0, new ListItem("No Package", "0"));
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable patientSearchByBarCode(string PatientID, int PatientRegStatus)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(DATE(pm.MemberShipDate)<CURDATE() AND IFNULL(pm.MemberShip,'')<>'','Membership Card is Expired !','')IsMemberShipExpire,IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo,Title,PFirstName,PLastName,PName,DATE_FORMAT(DOB,'%d-%m-%Y') AS DOB,Date_Format(pm.DateEnrolled,'%d-%c-%Y')DateEnrolled,pm.Age,IFNULL(pmh.KinRelation,IFNULL(pm.`Relation`,''))Relation,IFNULL(pmh.KinName,IFNULL(pm.`RelationName`,''))RelationName,IFNULL(pmh.KinPhone,IFNULL(pm.`RelationPhoneNo`,pm.EmergencyPhone))RelationPhoneNo,Gender,House_No,pm.Taluka,IFNULL(pm.Occupation,'')Occupation,pm.District,pmh.AdmissionReason, ");
        sb.Append(" pm.LandMark,pm.PinCode,IFNULL(pm.Place,'')Place,IFNULL(EmergencyNotify,'')EmergencyNotify,IFNULL(EmergencyRelationShip,'')EmergencyRelationShip,IFNULL(EmergencyAddress,'')EmergencyAddress,IFNULL(EmergencyPhoneNo,'')EmergencyPhoneNo,  ");
        sb.Append(" MaritalStatus,Religion,Country,State,pm.Mobile,IFNULL(pm.Email,'')Email,pm.City,ifnull(pmh.PanelID,pm.PanelID)PanelID,ifnull(pmh.ParentID,pm.PanelID)ParentID,IFNULL(pnl.ReferenceCodeOPD,1)ReferenceCodeOPD,IFNULL(pnl.HideRate,0)HideRate,IFNULL(pnl.ShowPrintOut,1)ShowPrintOut,  ");
        sb.Append(" IFNULL((SELECT CONCAT(Id,'#',IsMainDoctor,'#',IsDisable) FROM referraltype_master WHERE Id=IFNULL(pmh.ReferralTypeID,1)),'1#0#1') AS ReferralTypeID,pmh.DoctorID,pm.FeesPaid,pm.patientType,IFNULL(pm.AdharCardNo,'')AdharCardNo,IFNULL(HospPatientType,'')HospPatientType,pm.countryID,pm.districtID,pm.cityID,pm.talukaID,pm.State,pm.StateID, IFNULL((SELECT  SUM(oa.AdvanceAmount-oa.BalanceAmt) FROM opd_advance oa WHERE oa.IsCancel = 0  AND   oa.PatientID = '" + PatientID.Trim() + "'),0) OPDAdvanceAmount ,(SELECT COUNT(*) FROM  patient_medical_history pmh WHERE pmh.IsVisitClose=0 AND pmh.PatientID='" + PatientID.Trim() + "' AND pmh.Type='OPD')AvilableOpenVisit,(SELECT  IFNULL(pmh.TransactionID,'')  FROM  patient_medical_history pmh WHERE pmh.IsVisitClose=0 AND pmh.PatientID='" + PatientID.Trim() + "' AND  PMH.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND  pmh.Type='OPD' ORDER BY id DESC LIMIT 1 ) TransactionID,PMiddleName ");
        if (PatientRegStatus == 1)
            sb.Append(" ,pm.PatientID,pmh.CardNo,pmh.PolicyNo,DATE_FORMAT(pmh.ExpiryDate,'%d-%b-%Y') AS ExpiryDate,pmh.CardHolderName,'' oldPatientID,IFNULL((SELECT CONCAT('[',GROUP_CONCAT(CONCAT('{\"IDProofID\":\"',IDProofID,'\",\"IDProofName\":\"',IDProofName,'\",\"IDProofNumber\":\"',IDProofNumber,'\"}')),']') FROM PatientID_proofs WHERE PatientID=pm.PatientID),'')patientIDProofs,placeofBirth,IsInternational,OverSeanumber,EthenicGroup,LanguageSpoken,IsTranslatorRequired,FacialStatus,Race,Employement,Occupation,MonthlyIncome,EmergencyPhoneNo,parmanentAddress,IdentificationMark,IdentificationMarkSecond,PM.EmergencyRelationShip,pm.EmergencyRelationOf,pm.Phone_STDCODE,pm.ResidentialNumber,pm.ResidentialNumber_STDCODE,pm.EmergencyFirstName,pm.EmergencySecondName,pm.InternationalCountryID,pm.InternationalCountry,pm.InternationalNumber,pm.Phone,pm.EmergencyAddress,pm.`Remark`,ifnull(pm.talukaID,'0')talukaID,ifnull(pm.Taluka,'')Taluka,IFNULL(pm.PurposeOfVisit,'')PurposeOfVisit,IFNULL(pm.PurposeOfVisitID,'')PurposeOfVisitID ,IFNULL(pm.PRequestDept,'')PRequestDept ,IFNULL(pm.SecondMobileNo,'')SecondMobileNo,IFNULL(pm.StaffDependantID,'')StaffDependantID FROM patient_master pm   ");
        else
            sb.Append(" ,IF(pm.NewPatientID='',pm.PatientID,pm.NewPatientID)PatientID,pm.PatientID oldPatientID FROM patient_master_Old pm   ");
        sb.Append(" Left  JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID ");
        sb.Append(" LEFT JOIN f_panel_master pnl ON pnl.PanelID=Pmh.PanelID ");
        sb.Append("   WHERE pm.PatientID='" + PatientID.Trim() + "'  ");
        if (PatientRegStatus == 1)
            sb.Append(" and PatientType<>2 and pm.active=1");
        sb.Append(" ORDER BY pmh.TransactionID DESC LIMIT 1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn dc = new DataColumn("PatientPhotoPath");
        if (Resources.Resource.ShowPatientPhoto == "1")
        {
            string pathname = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + dt.Rows[0]["DateEnrolled"].ToString().Split('-')[2] + "\\" + dt.Rows[0]["DateEnrolled"].ToString().Split('-')[1] + "\\" + dt.Rows[0]["PatientID"].ToString().Replace("/", "_").Replace("/", "_").Replace("/", "_") + ".jpg");
            if (File.Exists(pathname))
            {
                byte[] byteArray = File.ReadAllBytes(pathname);
                string base64 = Convert.ToBase64String(byteArray);
                dc.DefaultValue = string.Format("data:image/jpg;base64,{0}", base64);
            }
            else
                dc.DefaultValue = "";
        }
        else
            dc.DefaultValue = "";
        dt.Columns.Add(dc);


        dc = new DataColumn("PatientDocumentsCount");
        string documentFolderPath = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\OPDDocument\\" + dt.Rows[0]["PatientID"].ToString().Replace("/", "_").Replace("/", "_").Replace("/", "_") + "\\");

        System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(documentFolderPath);
        if (dir.Exists)
        {
            int fcount = dir.GetFiles().Length;
            if (fcount > 0)
            {
                dc.DefaultValue = fcount;
            }
            else
                dc.DefaultValue = "0";
        }
        else
            dc.DefaultValue = "0";


        dt.Columns.Add(dc);

        return dt;
    }
    public static DataTable bindPackageOtherDetail(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(ToDate,'%d-%b-%Y')ToDate,ItemCode,im.IsActive FROM package_master pm INNER JOIN f_itemmaster im ON pm.PackageID=im.Type_ID ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID=sm.CategoryID ");
        sb.Append(" WHERE cf.ConfigID=23 AND pm.PackageID='" + PackageID + "'");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable bindlabInv(string str, string CPTCode, string category, string Subcategory)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT item,CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#',");
        sb.Append(" IFNULL(Type_ID,''),'#',IF(Sample='R',Sample,'N'),'#',TnxType,'#',IFNULL(ItemCode,''),'#',IFNULL(GenderInvestigate,''))ItemID ");
        sb.Append(" FROM(SELECT CONCAT(IFNULL(im.ItemCode,''),' # ',im.TypeName)Item,ims.GenderInvestigate,im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode, ");
        sb.Append(" (CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID in (25,7) THEN 'PRO'  ");
        sb.Append(" WHEN cr.ConfigID in (20,6)  THEN 'OTH' END)LabType,");
        sb.Append(" (CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID in (25,7) THEN '4' ");
        sb.Append(" WHEN cr.ConfigID in(20,6) THEN '5' END)TnxType ,");
        sb.Append(" (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample  FROM f_itemmaster im  LEFT JOIN investigation_master ims ON ims.Investigation_Id = im.Type_ID INNER JOIN f_subcategorymaster sm ");
        sb.Append(" ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid ");
        if (str == "1")
            sb.Append(" WHERE cr.ConfigID in (3)");
        else if (str == "2")
            sb.Append(" WHERE cr.ConfigID in (25)");
        else if (str == "3")
            sb.Append(" WHERE cr.ConfigID in (20,6)");
        if (CPTCode != string.Empty)
            sb.Append(" and im.ItemCode like '%" + CPTCode + "%' ");
        if (category != "-Select-")
            sb.Append("  AND cr.CategoryID='" + category + "'");
        if (Subcategory != "-Select-")
            sb.Append("   AND sm.SubCategoryID='" + Subcategory + "'");
        sb.Append(" and im.IsActive=1 )t1 order by Item");
        return StockReports.GetDataTable(sb.ToString());

    }

    public static DataTable oldPatientSearch(string PatientID, string FamilyNo, string PName, string LName, string ContactNo, string Address, string FromDate, string ToDate, int PatientRegStatus, string isCheck, string IDProof, string MembershipCardNo, string DOB, int IsDOBChecked, string Relation, string RelationName, string emailID, string patientType, string IPDNo = "", string panelID = "", string cardNo = "", string visitID = "")
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.IsRegistrationApply,IFNULL(PM.MemberShip,'')MemberShipCardNo,IFNULL(DATE_FORMAT(PM.MemberShipDate,'%d-%b-%y'),'')MemberShipValidTo,pm.Title,pm.PName,pm.PFirstName,pm.PLastName,IF(pm.DOB='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y')) AS DOB,pmhout.AdmissionReason,");
        sb.Append(" pm.Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%y') AS Date,pm.House_No,SUBSTRING(pm.House_No,'1','20')SubHouseNo,IFNULL(pm.mobile,'')ContactNo,pm.Email,pm.Country,pm.City,IFNULL(pmhout.KinRelation,pm.Relation) As Relation,IFNULL(pmhout.KinName,pm.RelationName) As RelationName,IFNULL(pmhout.KinPhone,pm.EmergencyPhone) As RelationPhoneNo ");
        if (PatientRegStatus == 1)
            sb.Append("  ,pm.PatientID MRNo,'1' PatientRegStatus,  ");
        else
            sb.Append("  ,IF(pm.NewPatientID='',pm.PatientID,pm.NewPatientID) MRNo,IF(pm.NewPatientID='','2','1') PatientRegStatus ,   ");

        sb.Append("IFNULL((SELECT CONCAT( pmhout.TransNo, '#', icm.Name, '#', IPDCaseTypeID_Bill ) TID FROM patient_ipd_profile pip INNER JOIN ipd_case_type_master icm ON pip.IPDCaseTypeID = icm.IPDCaseTypeID WHERE STATUS = 'IN' AND pip.PatientID =pm.PatientID LIMIT 1 ),'')IPDDetails,");
        sb.Append("IFNULL((SELECT CONCAT(DATE_FORMAT(arb.BookingDate,'%d-%b-%Y'),'#',ictm.Name,'#',CONCAT(rm.Name,'-',rm.Room_No,'-',rm.Bed_No))FROM advance_room_booking arb INNER JOIN ipd_case_type_master ictm ON arb.IPDCaseTypeID=ictm.IPDCaseTypeID INNER JOIN room_master rm ON arb.RoomID=rm.RoomId WHERE PatientID=pm.PatientID AND iscancel=0  AND BookingDate>=CURRENT_DATE LIMIT 1),'')AdvRoomBookingDetails, ");
        sb.Append("placeofBirth,IsInternational,OverSeanumber,EthenicGroup,LanguageSpoken,IsTranslatorRequired,FacialStatus,Race,Employement,Occupation,MonthlyIncome,EmergencyPhoneNo,parmanentAddress,IdentificationMark,IdentificationMarkSecond,EmergencyRelationOf,EmergencyRelationShip,IFNULL(pm.Taluka,'')Taluka,IFNULL(pm.talukaID,'')talukaID,ifnull(pm.PurposeOfVisit,'')PurposeOfVisit,iFNULL(pm.PurposeOfVisitID,'')PurposeOfVisitID,IFNULL(pm.PRequestDept,'')PRequestDept,IFNULL(pm.SecondMobileNo,'')SecondMobileNo,IFNULL(pm.StaffDependantID,'')StaffDependantID,ifnull(pm.LastFamilyUHIDNumber,'')FamilyNo ");
        if (patientType == "1")
        { sb.Append(" ,cte.Reason as TransferReason"); }
        else { sb.Append(" ,'' TransferReason"); }
        sb.Append(" FROM patient_master pm ");

        if ((!string.IsNullOrEmpty(panelID) && !string.IsNullOrEmpty(cardNo)))
            sb.Append("     INNER JOIN `patient_medical_history` pmhin ON pmhin.PatientID=pm.PatientID AND  pmhin.PanelID=" + panelID + " AND pmhin.CardNo='" + cardNo + "' ");
        else if (Relation.Trim() != "" && Relation.Trim() != "0")
            sb.Append("     INNER JOIN `patient_medical_history` pmhin ON pmhin.PatientID=pm.PatientID AND KinRelation='" + Relation.Trim() + "' AND KinName='" + RelationName.Trim() + "' ");
        else
        {
            sb.Append("     LEFT JOIN  ( ");
            sb.Append("              SELECT MAX(TransactionID)ID,PatientID FROM patient_medical_history GROUP BY PatientID  ");
            sb.Append("     )pmhin ON pmhin.PatientID=pm.PatientID ");
        }
        //sb.Append("  INNER JOIN patient_medical_history pmhout ON pmhin.ID=pmhout.ID ");
        sb.Append("  LEFT JOIN patient_medical_history pmhout ON pmhin.ID=pmhout.TransactionID ");

        if (!string.IsNullOrEmpty(IPDNo))
            sb.Append(" LEFT JOIN patient_ipd_profile pip  ON pip.PatientID = pm.PatientID ");
        if (!string.IsNullOrEmpty(IDProof))
            sb.Append(" LEFT JOIN PatientID_proofs pi  ON pi.PatientID = pm.PatientID ");

        if (patientType == "1")
        { sb.Append(" INNER  JOIN cpoe_transfertoemergency cte ON cte.PatientID=pm.PatientID AND IsPatientAdmitted=0 "); }
        sb.Append("WHERE  pm.PatientID <>'' ");

        if (PatientRegStatus == 1)
            sb.Append(" AND pm.PatientType<>2 and active=1");
        if (PatientID.Trim() != "")
            sb.Append(" AND pm.PatientID='" +PatientID.Trim() + "'");
        if (PName.Trim() != "")
            sb.Append(" AND pm.PFirstName LIKE '%" + PName.Trim() + "%'");
        if (LName.Trim() != "")
            sb.Append(" AND pm.PLastName LIKE '%" + LName.Trim() + "%'");
        if (!string.IsNullOrEmpty(IPDNo))
            sb.Append(" AND pip.TransactionID='" + IPDNo.Trim() + "'");
        if (!string.IsNullOrEmpty(IDProof))
            sb.Append(" AND pi.IDProofNumber = '" + IDProof.Trim() + "' ");
        if (!string.IsNullOrEmpty(visitID))
            sb.Append(" AND pmhout.TransactionID='" + visitID.Trim() + "'");

        if (!string.IsNullOrEmpty(emailID))
            sb.Append(" AND pm.Email='" + emailID.Trim() + "'");

        if (PatientID.Trim() == "" && FamilyNo.Trim()=="" && ContactNo.Trim() == "" && PName.Trim() == "" && LName.Trim() == "" && MembershipCardNo.Trim() == "" && isCheck == "0" && string.IsNullOrEmpty(IPDNo) && IsDOBChecked == 0 && Relation.Trim() == "0" && emailID.Trim() =="" && patientType=="2")
        {
            if (FromDate.Trim() != "" && ToDate.Trim() != "")
                sb.Append(" AND DATE(pm.DateEnrolled)>= '" + Util.GetDateTime(FromDate.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(pm.DateEnrolled)<='" + Util.GetDateTime(ToDate.Trim()).ToString("yyyy-MM-dd") + "'");
        }
        else if(patientType=="1"){  
            if (FromDate.Trim() != "" && ToDate.Trim() != "")
                sb.Append(" AND DATE(cte.TransferDate)>= '" + Util.GetDateTime(FromDate.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(cte.TransferDate)<='" + Util.GetDateTime(ToDate.Trim()).ToString("yyyy-MM-dd") + "'");
            }
        if (Address.Trim() != "")
            sb.Append(" AND pm.House_No LIKE '" + Address.Trim() + "%'");
        if (ContactNo.Trim() != "")
            sb.Append(" AND (pm.Phone = '" + ContactNo.Trim() + "' OR pm.Mobile = '" + ContactNo.Trim() + "') ");

        if (MembershipCardNo.Trim() != "")
            sb.Append(" AND pm.MemberShip='" + MembershipCardNo.Trim() + "'");

        if (FamilyNo.Trim() != "")
            sb.Append(" AND pm.LastFamilyUHIDNumber LIKE '" + FamilyNo.Trim() + "%'");

        if (IsDOBChecked != 0)
            sb.Append(" AND pm.DOB='" + Util.GetDateTime(DOB.Trim()).ToString("yyyy-MM-dd") + "'");

        sb.Append(" GROUP BY pm.PatientID ORDER BY pm.DateEnrolled DESC LIMIT 100");

        return StockReports.GetDataTable(sb.ToString());

    }

    public static DataTable getLastVisitDetail(string PatientID, string DoctorID, MySqlConnection con)
    {

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT * FROM ( SELECT DATE_FORMAT((lt.Date),'%d %b %Y')VisitDate,CONCAT(dm.Title,' ',dm.Name)Doctor,ltd.DoctorID,DATEDIFF(NOW(),lt.date)Days, ");
        //sb.Append(" lt.Date,DATEDIFF(NOW(),(SELECT lt.date FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ltd.ledgertransactionNo = lt.ledgertransactionNo WHERE lt.PatientID='" + PatientID + "'   ");
        //sb.Append(" AND lt.IsCancel=0 AND lt.TypeOfTnx='OPD-APPOINTMENT' AND ltd.subcategoryID IN ('LSHHI1','LSHHI5') ");
        //if (DoctorID != "")
        //    sb.Append("  AND ltd.DoctorID='" + DoctorID + "' ");
        //sb.Append(" ORDER BY lt.date DESC LIMIT 1))PaidVisitDate, ltd.SubCategoryID,(SELECT validityPeriod FROM f_itemmaster WHERE ItemID=ltd.ItemID  ");
        //sb.Append(" AND validityPeriod<>0  LIMIT 1)validityPeriod FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
        //sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=ltd.DoctorID WHERE lt.PatientID='" + PatientID + "' ");
        //if (DoctorID != "")
        //    sb.Append("  AND ltd.DoctorID='" + DoctorID + "' ");
        //sb.Append(" AND lt.IsCancel=0 AND lt.TypeOfTnx='OPD-APPOINTMENT' ");
        //sb.Append(" ORDER BY lt.date DESC LIMIT 1  ");
        //sb.Append(" )t WHERE IFNULL(t.VisitDate,'')<>''");

        sb.Append(" SELECT app.App_ID ,DATE_FORMAT(app.Date,'%d-%b-%Y')VisitDate,app.DoctorID, CONCAT(dm.Title,' ',dm.Name)Doctor,DATEDIFF(DATE_ADD(NOW(), INTERVAL 1 DAY),app.date)Days, ");
        sb.Append(" DATE_FORMAT(app.Date,'%Y-%c-%d')appDate, CONCAT(DATE_FORMAT(DATE_ADD(app.Date, INTERVAL IF(sm.DocValidityPeriod=0,1,sm.DocValidityPeriod-1) DAY),'%d-%b-%Y'),' (',sm.DocValidityPeriod,' D)')ValidTo,app.NextSubcategoryID,DATE_FORMAT(app.nextVisitDateMin,'%Y-%c-%d')nextVisitDateMin,DATE_FORMAT(app.nextVisitDateMax,'%Y-%c-%d')nextVisitDateMax,DATE_FORMAT(app.lastVisitDateMax,'%Y-%c-%d')lastVisitDateMax,sm.name VisitType,sm.DocValidityPeriod,IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE `AsainstLedgerTnxNo`=app.LedgerTnxNo),0)AmountPaid, ");
        sb.Append(" IF(DATEDIFF(NOW() ,app.date)>= sm.DocValidityPeriod,'0',IF((SELECT COUNT(*) FROM appointment WHERE patientID='" + PatientID + "' AND SubCategoryID='" + Resources.Resource.FollowUpVisitSubCategoryID + "' AND doctorID=app.DoctorID)<'" + Resources.Resource.MaxFollowUpVisitCount + "','1','0'))IsValidForFollowUpVisit");
        sb.Append(" FROM Appointment app INNER JOIN doctor_master dm ON app.DoctorID=dm.DoctorID  ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sm ON app.`SubCategoryID`=sm.`SubCategoryID` ");
     //   sb.Append(" WHERE app.IsConform=1 AND app.IsCancel=0 AND app.PatientID='" + PatientID + "' AND sm.SubCategoryID<>'" + Resources.Resource.FollowUpVisitSubCategoryID + "' ");
        sb.Append(" WHERE app.IsConform=1 AND app.IsCancel=0 AND app.PatientID='" + PatientID + "' AND sm.SubCategoryID='" + Resources.Resource.FirstVisitSubCategoryID + "' ");
        if (DoctorID != "")
            sb.Append("  AND app.DoctorID='" + DoctorID + "' ");
        sb.Append(" ORDER BY app.date DESC");
        dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }

    public static int hospChargesApp(string DoctorID, string PatientID, int PatientInfo, string SubCategoryID, MySqlConnection con)
    {
        int hospChargeaApp = 0;
        int docType = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DocGroupID FROM doctor_master WHERE DoctorID='" + DoctorID + "'"));
        if (docType == 2 || docType == 4)
        {
            if (Util.GetInt(PatientInfo) == 1)
                hospChargeaApp = 1;
            else
            {
                if (SubCategoryID != "LSHHI114" || SubCategoryID != "LSHHI115" || SubCategoryID != "LSHHI116" || SubCategoryID != "LSHHI2" || SubCategoryID != "")
                {
                    hospChargeaApp = 1;
                }
                else
                    hospChargeaApp = 0;
            }
        }

        return hospChargeaApp;
    }

    public static DataTable doctorSignature(string DoctorID)
    {
        DataTable doc = StockReports.GetDataTable("Select CONCAT(Title,' ',Name)DocName,Degree,Designation FROM Doctor_master where DoctorID='" + DoctorID + "'");
        DataTable dtImg = new DataTable();
        dtImg.TableName = "doctorSignature";
        dtImg.Columns.Add("DoctorName");
        dtImg.Columns.Add("Degree");
        dtImg.Columns.Add("DoctorSignature", System.Type.GetType("System.Byte[]"));
        dtImg.Columns.Add("Designation");
        DataRow drImg = dtImg.NewRow();
        drImg["DoctorName"] = doc.Rows[0]["DocName"].ToString();
        drImg["Degree"] = doc.Rows[0]["Degree"].ToString();
        drImg["Designation"] = doc.Rows[0]["Designation"].ToString();
        string path1 = HttpContext.Current.Server.MapPath("../../Design/Doctor/DoctorSignature/" + DoctorID + ".jpg");
        bool exists = System.IO.File.Exists(path1);
        if (exists)
        {
            FileStream fs1 = new FileStream(path1, FileMode.Open, System.IO.FileAccess.Read);
            byte[] imgbyte1 = new byte[fs1.Length + 1];
            fs1.Read(imgbyte1, 0, (int)fs1.Length);
            fs1.Close();
            drImg["DoctorSignature"] = imgbyte1;
        }
        dtImg.Rows.Add(drImg);
        dtImg.AcceptChanges();
        return dtImg;
    }
    
    public static DataTable GetItemRateByType_ID(string Type_ID, string referenceCodeOPD, string SubCategoryID, decimal countryCurrencyFactor,int CenteID)
    {
        DataTable Items = new DataTable();
        try
        {
            // string RefCodeopd = StockReports.ExecuteScalar("SELECT ReferenceCodeOPD FROM f_panel_master where PanelID='" + PanelID + "'");
            string strQuery = "SELECT IFNULL(RL.ID,0)ID,ROUND((IFNULL(RL.Rate,0)*" + countryCurrencyFactor + "),4)Rate,RL.RateListID,RL.ItemID,IFNULL(RL.FromDate,'')FromDate,  IFNULL(RL.IsTaxable,'')IsTaxable,IF(IFNULL(rl.ItemDisplayName,'')='',IM.TypeName,rl.ItemDisplayName) Item, RL.PanelID,IM.Type_ID,IM.ValidityPeriod,IM.SubCategoryID,rl.ScheduleChargeID,IFNULL(rl.ItemCode,'')ItemCode from f_itemmaster im inner join f_ratelist rl on im.itemid = rl.itemid INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rl.PanelID   INNER JOIN f_panel_master pm ON rsc.panelid=pm.PanelID INNER JOIN (SELECT MAX(c.id) MaXID,c.* FROM  converson_master c  GROUP BY  c.S_CountryID  ORDER BY id DESC )cm  ON cm.S_CountryID=pm.RateCurrencyCountryID  AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rl.ScheduleChargeID where im.subcategoryid='" + SubCategoryID + "' AND im.type_id='" + Type_ID + "' AND rl.PanelID='" + referenceCodeOPD + "' AND rl.iscurrent=1 and rl.CentreID=" + CenteID + " ";
            return StockReports.GetDataTable(strQuery);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable GetItem(string ItemId, string PanelID)
    {
        DataTable Items = new DataTable();
        try
        {
            string ReferPanelOPD = StockReports.ExecuteScalar("SELECT ReferenceCodeOPD FROM f_panel_master WHERE PanelID=" + PanelID + " ");
            string SchedulechargeID = StockReports.ExecuteScalar("SELECT schedulechargeID from f_rate_schedulecharges where PanelID=" + ReferPanelOPD + " ");
            string strQuery = "select Rate from f_ratelist where itemID='" + ItemId + "' and PanelID=" + ReferPanelOPD + " and schedulechargeID='" + SchedulechargeID + "' AND isCurrent=1";
            return StockReports.GetDataTable(strQuery);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable CrystalReportLogoForInvoice()
    {
        DataTable dtImg = new DataTable();
        dtImg.TableName = "Logo";
        dtImg.Columns.Add("ReportHeaderName");
        dtImg.Columns.Add("ClientEmail");
        dtImg.Columns.Add("ClientTelophone");
        dtImg.Columns.Add("ClientWebsite");
        dtImg.Columns.Add("ReportClientLogo", System.Type.GetType("System.Byte[]"));
        dtImg.Columns.Add("FooterLogoReport", System.Type.GetType("System.Byte[]"));
        DataRow drImg = dtImg.NewRow();
        drImg["ReportHeaderName"] = HttpContext.GetGlobalResourceObject("Resource", "ReportHeader").ToString();
        drImg["ClientEmail"] = HttpContext.GetGlobalResourceObject("Resource", "ClientEmail").ToString();
        drImg["ClientTelophone"] = HttpContext.GetGlobalResourceObject("Resource", "ClientTelophone").ToString();
        drImg["ClientWebsite"] = HttpContext.GetGlobalResourceObject("Resource", "ClientWebsite").ToString();
        string path = HttpContext.Current.Server.MapPath("~/Images/cns_logo.jpg");

        FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
        byte[] imgbyte = new byte[fs.Length + 1];
        fs.Read(imgbyte, 0, (int)fs.Length);
        fs.Close();

        string path1 = HttpContext.Current.Server.MapPath("~/Images/cns_logo.jpg");
        FileStream fs1 = new FileStream(path1, FileMode.Open, System.IO.FileAccess.Read);
        byte[] imgbyte1 = new byte[fs1.Length + 1];
        fs1.Read(imgbyte1, 0, (int)fs1.Length);
        fs1.Close();

        drImg["FooterLogoReport"] = imgbyte1;
        drImg["ReportClientLogo"] = imgbyte;
        dtImg.Rows.Add(drImg);
        dtImg.AcceptChanges();
        return dtImg;
    }
    public static DataTable BindLabRadioDepartment(String RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT UPPER(ot.Name)Name,ot.ObservationType_ID FROM  observationtype_master ot INNER JOIN f_subcategorymaster sm ON ot.Description=sm.SubCategoryID  ");
        sb.Append("  INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID  AND cr.RoleID='" + RoleID + "'");
        sb.Append(" WHERE ot.IsActive=1 ORDER BY ot.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
            return dt;
        else
            return null;
    }
    public static DataTable GetSurgery(string SurgeryCode, string SearchByWord)
    {
        string query = "SELECT Surgery_ID,Upper(CONCAT(IFNULL(SurgeryCode,''),' # ',Name))NAME FROM f_surgery_master WHERE IsActive=1 ";
        if (SurgeryCode != "")
            query += " AND SurgeryCode like '%" + SurgeryCode + "%' ";
        if (SearchByWord != "")
            query += " AND NAME like '%" + SearchByWord + "%' ";
        query += "  ORDER BY NAME ";
        return StockReports.GetDataTable(query);
    }
    public static DataTable doctorload_dept(string Department)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.DoctorID,CONCAT(dm.title ,' ',dm.Name)NAME FROM doctor_master dm INNER JOIN doctor_hospital dh ON dm.DoctorID = dh.DoctorID WHERE isactive=1");
        if (Department != "ALL")
            sb.Append(" AND dh.Department='" + Department + "'");
        sb.Append("  GROUP BY dm.DoctorID ORDER BY dm.Name");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable Cash()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency,Selling_Specific ");
        sb.Append(" FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID ");
        sb.Append("  WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 AND cnm.DATE=(SELECT ");
        sb.Append(" MAX(cnm.DATE) FROM converson_master cm WHERE cnm.S_CountryID=cm.CountryID) ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable Credit()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency,Selling_Specific ");
        sb.Append(" FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID ");
        sb.Append("  WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 AND cnm.DATE=(SELECT ");
        sb.Append(" MAX(cnm.DATE) FROM converson_master cm WHERE cnm.S_CountryID=cm.CountryID) ");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable LoadScheduleIDByPanelID(string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.PanelID,rs.ScheduleChargeID  FROM ");
        sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD  ");
        sb.Append(" FROM f_panel_master WHERE PanelID IN ( ");
        sb.Append(" SELECT DISTINCT(ReferenceCodeOPD) FROM f_panel_master) ");
        sb.Append(" )t  INNER JOIN f_rate_schedulecharges rs ON rs.panelid =t.PanelID WHERE rs.IsDefault=1 and PanelID=" + PanelID + " ");
        sb.Append("  ORDER BY t.Company_Name ");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static decimal patientOPDAdv(string PatientID)
    {
        return Util.GetDecimal(StockReports.ExecuteScalar("SELECT IFNULL(SUM(IFNULL(AdvanceAmount,0)-IFNULL(BalanceAmt,0)),0)AdvanceAmount FROM OPD_Advance WHERE PatientID='" + PatientID + "' AND IsCancel=0 GROUP BY PatientID"));

    }

    public static string followUpAppMsg(DateTime AppDate, DateTime AppTime, string PName, int AppNo)
    {
        return "Your App. Date is " + Util.GetDateTime(AppDate).ToString("dd-MM-yyyy");

    }

    public static DataTable getAppVisitType()
    {

        return CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("5"));
    }
    public static string getAppVisitDetail(int AppID, DateTime visitDate)
    {
        string patientVisitDate = "";
        if (visitDate.ToString() == "0001-01-01")
            patientVisitDate = DateTime.Now.ToString("yyyy-MM-dd");
        else
            patientVisitDate = visitDate.ToString("yyyy-MM-dd");
        string patientVisitDetail = "";
        string visitDetail = Util.GetString(StockReports.ExecuteScalar("SELECT CONCAT(NextSubcategoryID,'#',nextVisitDateMin,'#',nextVisitDateMax,'#',lastVisitDateMax)VisitDetail FROM appointment WHERE App_ID='" + AppID + "' "));
        if (visitDetail != "null")
        {
            if (Util.GetDateTime(patientVisitDate) <= Util.GetDateTime(visitDetail.Split('#')[2]))
            {
                patientVisitDetail = visitDetail.Split('#')[0];

            }
            else if (Util.GetDateTime(patientVisitDate) > Util.GetDateTime(visitDetail.Split('#')[3]))
            {
                patientVisitDetail = StockReports.ExecuteScalar("SELECT SubcategoryID FROM  ( SELECT VisitGroup FROM docvisit_serial WHERE SubcategoryID='" + visitDetail.Split('#')[0] + "' )t INNER JOIN docvisit_serial doc ON doc.VisitGroup=t.VisitGroup ORDER BY doc.id 	ASC LIMIT 1 ");
            }

            else if (Util.GetDateTime(patientVisitDate) > Util.GetDateTime(visitDetail.Split('#')[2]))
            {
                double totaldays = (Util.GetDateTime(patientVisitDate) - Util.GetDateTime(visitDetail.Split('#')[1])).TotalDays;
                DataTable dt = StockReports.GetDataTable(" SELECT SubcategoryID,doc.DocValidity FROM  ( SELECT VisitGroup FROM docvisit_serial WHERE SubcategoryID='" + visitDetail.Split('#')[0] + "' )t INNER JOIN docvisit_serial doc ON doc.VisitGroup=t.VisitGroup ORDER BY doc.id 	");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (Util.GetDouble(dt.Rows[i]["DocValidity"]) > totaldays)
                        {
                            patientVisitDetail = dt.Rows[i]["SubcategoryID"].ToString();
                            break;
                        }
                    }
                }
            }
        }
        return patientVisitDetail;
    }
    public static DataTable getDoctorDetail(string DName, string Specialization, string Deptartment)
    {
        string strQuery = "";

        try
        {

            strQuery = "SELECT  DM.Name,DM.DoctorID AS DID, IFNULL((SELECT Department FROM doctor_hospital WHERE DoctorID=dm.DoctorID LIMIT 1),'')Department,DM.Specialization,DM.Degree,IsDocShare,IsUnit FROM doctor_master DM where Dm.DoctorID<>'' AND DM.`IsActive`=1  ";
            if (DName != "")
                strQuery = strQuery + " and DM.Name like '%" + DName + "%'";
            if (Specialization != "")
                strQuery = strQuery + "and Specialization = '" + Specialization + "'";
            if (Deptartment != "")
                strQuery = strQuery + "and DocDepartmentID = '" + Deptartment + "'";
            strQuery = strQuery + " ORDER BY DM.Name";

            DataTable dt = StockReports.GetDataTable(strQuery);
            if (dt.Rows.Count > 0)
                return dt;
            else
                return null;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static List<docVisitDetail> appVisitDetail(DateTime date, string SubCategoryID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT NextSubcategoryID,DocValidityPeriod,nextVisitDateMax, '" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' nextVisitDateMin,DATE_ADD('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "',INTERVAL (t1.DocValidity-1) DAY )lastVisitDateMax,VisitGroup docVisitGroup FROM (  ");
        sb.Append("    SELECT t.*,(SELECT MAX(DocValidity) FROM docVisit_serial WHERE VisitGroup=t.VisitGroup )DocValidity FROM  ");
        sb.Append("    ( ");
        sb.Append("    SELECT ds.NextSubcategoryID,sub.DocValidityPeriod,IF(sub.DocValidityPeriod>0,DATE_ADD('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "',INTERVAL (sub.DocValidityPeriod-1) DAY),'" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' )nextVisitDateMax,ds.VisitGroup  ");
        sb.Append("    FROM docVisit_serial ds  INNER JOIN f_subcategorymaster sub ON ds.SubcategoryID=sub.SubCategoryID WHERE ds.subcategoryid='" + SubCategoryID + "'  ");
        sb.Append("    )t ");
        sb.Append(" )t1");
        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

        List<docVisitDetail> visitDetail = new List<docVisitDetail>();
        visitDetail = (from DataRow dr in dt.Rows
                       select new docVisitDetail()
                       {
                           nextSubcategoryID = dr["NextSubcategoryID"].ToString(),
                           docValidityPeriod = dr["DocValidityPeriod"].ToString(),
                           nextVisitDateMax = dr["nextVisitDateMax"].ToString(),
                           nextVisitDateMin = dr["nextVisitDateMin"].ToString(),
                           lastVisitDateMax = dr["lastVisitDateMax"].ToString(),
                           docVisitGroup = dr["docVisitGroup"].ToString()
                       }).ToList();
        return visitDetail;
    }

    public static DataTable bindOutsourceLab()
    {
        return StockReports.GetDataTable(" SELECT ID,Name,Active,Address,ContactPerson,MobileNo FROM outsourceLabMaster where Name<>'' AND Active=1");
    }

    public static DataTable GetRate(string type_id, string subcategoryid, int PanelID, int CentreId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(RL.`ItemCode`,'') AS ItemCode,im.ItemID,IFNULL(RL.ID,0)ID,IFNULL(RL.Rate,0)Rate,IFNULL(rsc.ScheduleChargeID,0)ScheduleChargeID FROM f_itemmaster im LEFT JOIN f_ratelist rl ON im.itemid = rl.itemid  AND rl.PanelID='" + PanelID + "'   AND rl.iscurrent=1 AND rl.CentreID=" + CentreId + " ");
        sb.Append(" LEFT JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rl.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rl.ScheduleChargeID  ");
        sb.Append(" WHERE im.subcategoryid='" + subcategoryid + "' AND im.type_id='" + type_id + "'  ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable GetOPDItemRate(string ItemID, string subcategoryid, int PanelID, int CentreId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(RL.`ItemCode`,'') AS ItemCode,im.ItemID,IFNULL(RL.ID,0)ID,IFNULL(RL.Rate,0)Rate,IFNULL(rsc.ScheduleChargeID,0)ScheduleChargeID FROM f_itemmaster im LEFT JOIN f_ratelist rl ON im.itemid = rl.itemid  AND rl.PanelID='" + PanelID + "'   AND rl.iscurrent=1 AND rl.CentreID=" + CentreId + " ");
        sb.Append(" LEFT JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rl.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rl.ScheduleChargeID  ");
        sb.Append(" WHERE im.subcategoryid='" + subcategoryid + "' AND im.ItemID='" + ItemID + "'  ");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static string getTokenRoom(MySqlTransaction tnx, string categoryId, string subCategoryId, string modalityId,int CentreID)
    {
        ExcuteCMD cmd = new ExcuteCMD();
        string sqlCommand = string.Empty;
        string strGroupID = "";
        if(Resources.Resource.IsInvestigationAppointment=="1")
            strGroupID= " SELECT GroupID FROM token_master_detail WHERE CategoryID='" + categoryId + "' AND SubCategoryID='" + subCategoryId + "' and ModalityID='" + modalityId + "' and CentreID =" + CentreID + "";  
        else
            strGroupID = " SELECT GroupID FROM token_master_detail WHERE CategoryID='" + categoryId + "' AND SubCategoryID='" + subCategoryId + "' and CentreID =" + CentreID + " LIMIT 1;";  
        string groupId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, strGroupID));
        if (!String.IsNullOrEmpty(groupId))
        {
            sqlCommand = " SELECT srm.`roomName`,sgm.`id` FROM `sampleRoomGroupNameMapping`  sgm INNER JOIN `samplecollectionroommaster` srm ON sgm.`roomId`=srm.`id`  WHERE sgm.`groupId`='" + groupId.Trim() + "' and sgm.CentreID =" + CentreID + "";
            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommand).Tables[0];
            if (dt.Rows.Count == 1)
            {
                sqlCommand = " UPDATE sampleRoomGroupNameMapping srm SET srm.`IsUsed`=1 WHERE srm.`id`=@mappingId ";
                cmd.DML(tnx, sqlCommand, CommandType.Text, new
                {
                    mappingId = Util.GetString(dt.Rows[0]["id"])
                });

                return Util.GetString(dt.Rows[0]["roomName"]);

            }
            else if (dt.Rows.Count > 1)
            {
                string sqlCommandUnsed = "SELECT srm.`roomName`,sgm.`id` FROM `sampleRoomGroupNameMapping`  sgm INNER JOIN `samplecollectionroommaster` srm ON sgm.`roomId`=srm.`id`  WHERE sgm.`groupId`='" + groupId.Trim() + "' AND sgm.`IsUsed`=0 and CentreID =" + CentreID + " ORDER BY srm.`roomName` ";
                DataTable dtUnusedRoom = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommandUnsed).Tables[0];
                if (dtUnusedRoom.Rows.Count > 0)
                {
                    sqlCommand = " UPDATE sampleRoomGroupNameMapping srm SET srm.`IsUsed`=1 WHERE srm.`id`=@mappingId ";
                    cmd.DML(tnx, sqlCommand, CommandType.Text, new
                    {
                        mappingId = Util.GetString(dtUnusedRoom.Rows[0]["id"])
                    });

                    return Util.GetString(dtUnusedRoom.Rows[0]["roomName"]);

                }
                else
                {
                    sqlCommand = " UPDATE sampleRoomGroupNameMapping srm SET srm.`IsUsed`=0 WHERE srm.`groupId`=@groupId ";
                    cmd.DML(tnx, sqlCommand, CommandType.Text, new
                    {
                        groupId = groupId
                    });

                    dtUnusedRoom = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommandUnsed).Tables[0];

                    sqlCommand = " UPDATE sampleRoomGroupNameMapping srm SET srm.`IsUsed`=1 WHERE srm.`id`=@mappingId ";

                    cmd.DML(tnx, sqlCommand, CommandType.Text, new
                    {
                        mappingId = Util.GetString(dtUnusedRoom.Rows[0]["id"])
                    });

                    return Util.GetString(dtUnusedRoom.Rows[0]["roomName"]);
                }

            }
            else
                return "";
        }
        else
            return "";
    }
}