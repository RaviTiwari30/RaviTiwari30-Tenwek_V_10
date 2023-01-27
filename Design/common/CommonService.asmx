<%@ WebService Language="C#" Class="CommonService" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;
using Core;

[WebService(Namespace = "http:www.itdoseinfo.com/2012/11/17")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[ScriptService]
public class CommonService : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";

    }
    [WebMethod(EnableSession = true)]
    public string IsReceivedPatient(string TID, int IsReceived)
    {
        try
        {
            if (IsReceived == 1)
            {
                StockReports.ExecuteDML(" UPDATE patient_ipd_profile SET IsPatientReceived=1,PatReceivedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',PatReceivedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID='" + TID + "' ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Received Successfully" });
            }
            else if (IsReceived == 0)
            {
                StockReports.ExecuteDML(" UPDATE patient_ipd_profile SET IsPatientReceived=0,PatReceivedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',PatReceivedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE TransactionID='" + TID + "' ");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient NonReceived Successfully" });
            }
            else
            {
                return "";
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }

    }





    [WebMethod(EnableSession = true)]
    public string checkblacklist(string patientID, string molbileno)
    {
        string result="";
         if (patientID != "")
            {
                int blacklist = Util.GetInt(StockReports.ExecuteScalar("select COUNT(*) from blacklist bl where date(bl.StartDate)<=date(now()) and bl.IsBlackList=1 and bl.PatientID='" + patientID + "'"));
                if (blacklist > 0)
                {
                    result = "1";
                    //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This patient has been blacklist.", message = "This patient has been blacklist." });
                }
                else {
                    result = "0";
                }
            }
         if (molbileno != "")
         {
             string patientid = StockReports.ExecuteScalar("SELECT PatientID FROM patient_master WHERE Mobile='" + molbileno + "'");
             int blacklist1 = Util.GetInt(StockReports.ExecuteScalar("select COUNT(*) from blacklist bl where date(bl.StartDate)<=date(now()) and bl.IsBlackList=1 and bl.PatientID='" + patientid + "'"));
             if (blacklist1 > 0)
             {
                 result = "1";
                 //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This patient has been blacklist.", message = "This patient has been blacklist." });
             }
             else
             {
                 result = "0";
             }
         }
         return result;  
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DoctorTimingManagementDetails(string doctorID, string Department, string Specialization, string Centre, string FromDate, string ToDate)
    {

        string str = "SELECT  cm.CentreName,A.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,dm.Specialization,DATE_FORMAT(A.DATE,'%d-%b-%Y')Date,A.Day,SUM(A.TotalTimeInSecAllocated)TotalTimeInSecAllocated,";
        str += "SUM(A.TotalTimeInSecOccupied)TotalTimeInSecOccupied ,";
        str += "(CASE WHEN SUM(A.TotalTimeInSecAllocated)-SUM(A.TotalTimeInSecOccupied)>0 THEN SUM(A.TotalTimeInSecAllocated)-SUM(A.TotalTimeInSecOccupied) ELSE 0 END)freetime, ";
        str += "(CASE WHEN SUM(A.TotalTimeInSecOccupied)-SUM(A.TotalTimeInSecAllocated)>0 THEN SUM(A.TotalTimeInSecOccupied)-SUM(A.TotalTimeInSecAllocated) ELSE 0 END)extratime ";
        str += "FROM doctor_available_datewise A INNER JOIN doctor_master dm ON A.DoctorID=dm.DoctorID INNER JOIN f_center_doctor cd ON cd.DoctorID=dm.DoctorID INNER JOIN center_master cm ON cm.CentreID=cd.CentreID where cd.CentreID<>0";
        //    string str = " SELECT '" + Util.GetDateTime(Date).ToString("dd-MMM-yyyy") + "' AppDate,dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,dm.Mobile,dh.Day,dh.Day DayValue,ifnull(dh.ShiftName,'Day Shift')ShiftName,DATE_FORMAT(dh.StartTime,'%h:%i %p')StartTime,dh.StartTime StartTimeValue,DATE_FORMAT(dh.EndTime,'%h:%i %p')EndTime,dt.Name Department,dm.Specialization,dh.Room_No,dh.DocFloor,ROUND((TIME_TO_SEC(TIMEDIFF(dh.EndTime,dh.StartTime))/60)/IFNULL(dh.DurationforNewPatient,1)) TotalSlots,IFNULL((SELECT COUNT(*)IsBooked FROM  appointment a WHERE a.DoctorID = dm.DoctorID  AND a.Date = '" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'   AND a.IScancel =0 AND a.Time>=dh.StartTime AND a.Time<=dh.EndTime),0)+IFNULL((SELECT COUNT(*)IsBooked FROM app_appointment app WHERE app.DoctorID=dm.DoctorID AND app.AppointmentDate='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND app.StartTime>=dh.StartTime AND app.StartTime<=dh.EndTime),0)Booked,IFNULL((SELECT GROUP_CONCAT(CONCAT(sc.Name,':',ROUND(IFNULL((SELECT rt.Rate FROM f_ratelist rt WHERE rt.ItemID=im.ItemID AND rt.IsCurrent=1 AND rt.PanelID=1 LIMIT 1),0),4)) ORDER BY sc.DisplayPriority SEPARATOR '<br />') Rate FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID=sc.CategoryID WHERE cf.ConfigID=5 AND im.IsActive=1 AND im.Type_ID=dm.DoctorID ),'Doctor Visit Not Set')Rate FROM doctor_master dm INNER JOIN doctor_hospital dh ON dm.DoctorID=dh.DoctorID INNER JOIN type_master dt ON dt.id=dm.DocDepartmentID INNER JOIN f_center_doctor cd ON cd.DoctorID=dm.DoctorID INNER JOIN center_master cm ON cd.CentreID=cm.CentreID WHERE dm.DoctorID<>'' ";
        if (doctorID != "0")
            str += " AND dm.DoctorID='" + doctorID + "' ";
        if (Department != "0")
            str += " AND dm.DocDepartmentID='" + Department + "' ";
        if (Specialization != "All")
            str += " AND dm.Specialization='" + Specialization + "' ";
        if (Centre != "0")
            str += " AND cd.CentreID='" + Centre + "' ";
        if (FromDate != "" && ToDate != "")
        {
            str += " AND A.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND A.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ";
        }
        str += " GROUP BY A.DoctorID,A.Date order by A.Date";
        DataTable detail = StockReports.GetDataTable(str);

        if (detail.Rows.Count > 0)
        {
            HttpContext.Current.Session["ReportName"] = "DoctorTimeReport";
            HttpContext.Current.Session["dtExport2Excel"] = detail;
            Session["Period"] = "";

            return Newtonsoft.Json.JsonConvert.SerializeObject(detail);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public string GetDiscReason(string Type)
    {
        string strDiscReason = "select ID,DiscountReason from discount_reason where Active=1 AND Type='" + Type + "'";
        DataTable dt = StockReports.GetDataTable(strDiscReason);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string DiscReasonInsert(string DiscReason, string Type)
    {
        return AllInsert.SaveDiscReason(DiscReason, Type);
    }

    [WebMethod]
    public bool CompareDate(string DateFrom, string DateTo)
    {
        return Util.CompareDate(DateFrom, DateTo);
    }

    [WebMethod]
    public string getFormatedDate()
    {
        return Util.getFormatedDate();
    }
    [WebMethod]
    public string getDate()
    {
        return Util.getDate();
    }
    [WebMethod]
    public string getTomorrow()
    {
        return Util.getTomorrow();
    }
    [WebMethod]
    public string getHours()
    {
        return Util.getHours();
    }
    [WebMethod]
    public string getMintus()
    {
        return Util.getMintus();
    }
    [WebMethod]
    public string getTime()
    {
        return Util.getTime();
    }
    [WebMethod]
    public decimal getConvertCurrecncy(int countryID, decimal Amount)
    {
        AllSelectQuery Asq = new AllSelectQuery();
        return Asq.ConvertCurrencyBase(countryID, Amount);
    }

    [WebMethod]
    public decimal ConvertCurrency(int countryID, decimal Amount)
    {
        AllSelectQuery Asq = new AllSelectQuery();
        return Asq.ConvertCurrency(countryID, Amount);
    }

    [WebMethod]
    public string loadCountryFactor(string CountryID)
    {
        DataTable dtItem = All_LoadData.LoadCurrencyFactor(CountryID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtItem);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetVillage()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Locality FROM patient_master WHERE Locality!='' OR Locality!=NULL");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else { return ""; }
    }
    [WebMethod]
    public decimal GetConversionFactor(int countryID)
    {
        AllSelectQuery Asq = new AllSelectQuery();
        return Asq.GetConversionFactor(countryID);
    }
    [WebMethod]
    public string getCity(string districtID, string StateID)
    {
        return All_LoadData.BindCity(districtID, StateID).ToJson();
    }
    [WebMethod]
    public string getBillingCategory(string CaseType)
    {

        string BillingCategoryID = StockReports.ExecuteScalar("Select BillingCategoryID from ipd_case_type_Master where IPDCaseType_ID='" + CaseType + "'");
        DataTable dtBillingCategoryID = StockReports.GetDataTable(BillingCategoryID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtBillingCategoryID);
    }
    [WebMethod(Description = "To bind IPD Room Type")]
    public string getRoomType(string CaseType)
    {

        string sql = "select distinct CONCAT(RM.Name,'-',RM.Room_No,' /','Bed:',RM.Bed_No) Name,RM.Room_Id,IF(pip.IsDisIntimated=1,IntimationTime,'')IntimationTime, " +
            " IF(pip.Room_ID IS NULL,'OUT','IN')STATUS FROM (SELECT * FROM room_master  WHERE IsActive=1 AND IPDCaseTypeID='" + CaseType + "')rm INNER JOIN " +
            "  ( SELECT  BillingCategoryID,IPDCaseType_ID FROM ipd_case_type_master WHERE IsActive=1 AND IFNULL(BillingCategoryID,'')<>'')ctm ON ctm.IPDCaseType_ID=rm.IPDCaseTypeID " +
            "  LEFT JOIN (SELECT * FROM patient_ipd_profile WHERE STATUS='IN' AND IPDCaseType_ID='" + CaseType + "')pip ON pip.Room_ID = rm.Room_ID Where pip.room_ID is null";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string CityInsert(string City, string Country, string DistrictID, string StateID)
    {
        return AllInsert.SaveCity(City, Country, DistrictID, StateID);

    }
    [WebMethod(EnableSession = true)]
    public string Complaint(string CName)
    {
        return AllInsert.SaveComplaint(CName);
    }
    [WebMethod(EnableSession = true)]
    public string TypeOfAppointment(string TypeOfAppointment)
    {
        return AllInsert.SaveAppointmentType(TypeOfAppointment);
    }
    [WebMethod(EnableSession = true)]
    public string RefDoc(string Title, string Name, string HouseNo, string Mobile, string proID)
    {
        return AllInsert.saveRefDoc(Title, Name, HouseNo, Mobile, proID);
    }
    [WebMethod]
    public string SurgeryIpd(string TypeName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Surgery_ID,UPPER(CONCAT(IFNULL(SurgeryCode,''),' # ',NAME))NAME FROM f_surgery_master where IsActive = 1");
        sb.Append("  and NAME  LIKE '%" + TypeName + "%' ");
        sb.Append(" order by Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string IpdServices(string Typename)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(AllLoadData_IPD.IpdServices(Typename));
    }
    [WebMethod]
    public string Minor(string Typename)
    {
        string CategoryID = "";
        CategoryID = "25";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select CONCAT(IFNULL(im.ItemCode,''),' # ',IM.TypeName)TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#',IFNULL(SC.SubCategory,''),'#',IFNULL(Type_ID,''))ItemID,IM.SubCategoryID,SC.CategoryID from (Select itemcode,TypeName,ItemID,SubCategoryID,Type_ID from f_itemmaster where SubCategoryID in (Select SubCategoryID from f_SubCategoryMaster where CategoryID in (Select CategoryID from f_configrelation Where ConfigID in (" + CategoryID + "))  and isactive=1) and IsActive=1) IM,(Select Name as SubCategory,SubCategoryID,CategoryID from f_SubCategoryMaster where CategoryID in (Select CategoryID from f_configrelation Where ConfigID in (" + CategoryID + ")))SC Where SC.SubCategoryID = IM.SubCategoryID  ");
        sb.Append(" AND im.TypeName LIKE '%" + Typename + "%' ");
        sb.Append(" ORDER BY TypeName");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string Investigation(string Typename, string IPDCaseTypeID, string ReferenceCode)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(AllLoadData_IPD.bindIPDInvestigation(Typename, IPDCaseTypeID, ReferenceCode));
    }
    [WebMethod]
    public string LoadScheduleCharges(string PanelID)
    {
        DataTable dtScheduleCharge = StockReports.GetDataTable("SELECT Name,ScheduleChargeID,IsDefault FROM f_rate_schedulecharges WHERE  PanelID =" + PanelID + " ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtScheduleCharge);
    }
    [WebMethod]
    public string BindPackageOtherDetail(string PackageID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(AllLoadData_OPD.bindPackageOtherDetail(PackageID));
    }

    [WebMethod (EnableSession=true)]
    public string LoadOPD_All_Items(string Type, string CategoryID, string SubCategoryID)
    {        
        return Newtonsoft.Json.JsonConvert.SerializeObject(LoadCacheQuery.loadOPDDiagnosisItems(Type, CategoryID, SubCategoryID));
    }

    [WebMethod]
    public string bindComplaint()
    {
        try
        {
            DataTable complain = StockReports.GetDataTable("Select Complain_id,Complain from complain_master where IsActive=1 order by Complain ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(complain);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindDoctorWithoutUnit(string Department)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME,dm.Designation Department,dm.DocDepartmentID,dm.Specialization,dm.docGroupID,dm.IsDocShare ");
        sb.Append(" FROM doctor_master dm  INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 AND Designation='" + Department + "' AND IsUnit=0 ORDER BY dm.DoctorID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string bindDoctorDept(string Department)
    {
        try
        {
            DataView DoctorView = All_LoadData.bindDoctor().AsDataView();
            if (Department.ToUpper() != "ALL")
                DoctorView.RowFilter = "Department='" + Department + "'";
            return Newtonsoft.Json.JsonConvert.SerializeObject(DoctorView.ToTable());
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public string Loadrate(string DoctorID, string referenceCodeOPD, string SubCategoryID, decimal panelCurrencyFactor)
    {
        DataTable dtItems = AllLoadData_OPD.GetItemRateByType_ID(Util.GetString(DoctorID), Util.GetString(referenceCodeOPD), SubCategoryID, panelCurrencyFactor,Util.GetInt(HttpContext.Current.Session["CentreID"]));
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtItems);
    }

    [WebMethod]
    public string LoadrateRegistration(string ItemId, string PanelID)
    {
        DataTable dtItems = AllLoadData_OPD.GetItem(Util.GetString(ItemId), Util.GetString(PanelID));
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtItems);
    }
    [WebMethod(EnableSession = true)]
    public string BindInvestigation(string PatientId, string FromDate, string ToDate, string Condition)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT (pt.Test_ID) ItemID,sm.Name as SubCategory, pt.PatientTest_ID, pt.IsIssue, IsUrgent, fit.Typename, IFNULL(pt.OutSource, 0) IsOutSource, pt.DoctorID, SUM(Quantity) Quantity, cr.ConfigID, fit.Type_id, IFNULL(fit.ItemCode,'')ItemCode, fit.`IsAdvance` `isadvance`, fit.`SubCategoryID`,sm.CategoryID, ( CASE WHEN cr.ConfigID = 3 THEN 'LAB' WHEN cr.ConfigID IN (25) THEN 'PRO' WHEN cr.ConfigID IN (23) THEN 'PACK' WHEN cr.ConfigID IN (7) THEN 'BB' WHEN cr.ConfigID IN (20, 6) THEN 'OTH' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN 'OPD-BILLING' END ) LabType, ( CASE WHEN cr.ConfigID = 3 THEN '3' WHEN cr.ConfigID IN (25) THEN '4' WHEN cr.ConfigID IN (23) THEN '23' WHEN cr.ConfigID IN (7) THEN '6'   WHEN cr.ConfigID IN(5) THEN '5' WHEN cr.ConfigID IN (20, 6) THEN '20' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN '16' END ) TnxType, IFNULL((SELECT IF(TYPE = 'R', TYPE, 'N')  FROM Investigation_master WHERE Investigation_ID = fit.Type_ID),'') Sample,pt.Remarks FROM patient_test pt INNER JOIN f_itemmaster fit ON pt.test_id = fit.itemid INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = fit.SubCategoryID INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid  where pt.PatientID ='" + PatientId + "' ");
        if (FromDate != "" && ToDate != "")
            sb.Append("And pt.IsActive=1 AND pt.PrescribeDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND pt.PrescribeDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" GROUP BY ItemID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string BindSurgery(string PatientId, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT cps.itemName,cps.ItemID,cse.Patient_surgery_ID FROM cpoe_surgery_estimate cse INNER JOIN cpoe_procedure_surgery cps ON cps.Patient_surgery_ID=cse.Patient_surgery_ID WHERE  PatientID='" + PatientId + "'");
        if (FromDate != "" && ToDate != "")
            sb.Append(" AND EntryDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND EntryDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string Iscash(string PanelCompany)
    {
        DataTable dt = StockReports.GetDataTable("Select rtrim(ltrim(Company_Name)) as Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD from f_panel_master  order by Company_Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public string bindRoleDepartment()
    {
        DataTable dtDept = StockReports.GetDataTable("SELECT DeptName,DeptLedgerNo FROM f_rolemaster WHERE active=1 ORDER BY DeptName ");
        if (dtDept.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDept);
        return "";
    }

    [WebMethod(EnableSession = true)]
    public string IndentOpenCount(string storeid, string deptno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT COUNT(*) FROM  ");
        sb.Append("(SELECT SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty  FROM f_indent_detail WHERE storeid='STO00001' and deptto='" + deptno + "' GROUP BY IndentNo )t ");
        sb.Append("WHERE t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty ");

        return StockReports.ExecuteScalar(sb.ToString());
    }
    [WebMethod(EnableSession = true)]
    public string listbox(string FromDate, string ToDate, string Dept)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(im.ItemID,'#',im.SubCategoryID)ItemId,(im.typename)itemname FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON  ");
        sb.Append(" cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im ON sc.SubCategoryID = im.SubCategoryID  ");
        sb.Append(" INNER JOIN f_stock s ON s.ItemID = im.ItemID AND s.DeptLedgerNo = '" + Dept + "' ");
        sb.Append(" WHERE cf.ConfigID=11 AND s.InitialCount-s.ReleasedCount > 0  and s.IsPost=1  AND DATE(MedExpiryDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(MedExpiryDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" GROUP BY im.ItemID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string IndentOpenCountGen(string storeid, string deptno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT COUNT(*) FROM  ");
        sb.Append("(SELECT SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty  FROM f_indent_detail WHERE storeid='STO00002' and deptto='" + deptno + "' GROUP BY IndentNo )t ");
        sb.Append("WHERE t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty ");
        return StockReports.ExecuteScalar(sb.ToString());
    }
    [WebMethod(EnableSession = true)]
    public string room(string Room)
    {
        DataTable dt = StockReports.GetDataTable(" select distinct lm.AlmID, am.Name from mrd_location_master lm inner join  mrd_almirah_master am on am.AlmID=lm.AlmID where lm.MaxPos >= (CurPos+AdditionalNo) and am.RmID='" + Room + "' order by am.Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string almirah(string Almirah)
    {
        DataTable dt = StockReports.GetDataTable(" select distinct ShelfNo,CONCAT(ShelfNo,'$',ifnull(CurPos,0)+1)ID from mrd_location_master  where AlmID = '" + Almirah + "' and  MaxPos >= (CurPos+AdditionalNo) order by ShelfNo ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string GetNotificationCount(int RoleID, string UserID)
    {
        return StockReports.ExecuteScalar(" CALL NotificationCount_new(" + RoleID + ",'" + UserID + "') ");

    }
    [WebMethod(EnableSession = true)]
    public string GetNotificationDetail(int RoleID, string UserID)
    {
        DataTable dt = StockReports.GetDataTable(" CALL NotificationDetail_New(" + RoleID + ",'" + UserID + "'," + HttpContext.Current.Session["CentreID"].ToString() + ") ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod()]
    public string[] GetCompletion(string prefixText, int count)
    {
      // DataTable medicalitems = StockReports.GetDataTable("SELECT Typename FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM  ON sm.SubcategoryID=IM.Subcategoryid INNER JOIN f_configrelation CM ON SM.categoryid=CM.categoryID WHERE cm.configid='11' AND typename like '" + prefixText + "%'");
         DataTable medicalitems = StockReports.GetDataTable("SELECT Typename,CONCAT('(Qty:',ROUND(IFNULL(st.Qty,0),2),')')AvlQty, im.ItemID FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM  ON sm.SubcategoryID=IM.Subcategoryid INNER JOIN f_configrelation CM ON SM.categoryid=CM.categoryID LEFT JOIN ( SELECT SUM(InitialCount - ReleasedCount) Qty, ItemID FROM f_stock WHERE ispost = 1 AND MedExpiryDate > CURDATE() AND (InitialCount - ReleasedCount)>0 AND CentreID=1 AND DeptledgerNo='LSHHI57' GROUP BY ITemID ) st ON st.itemID = im.ItemID WHERE cm.configid='11' AND typename like '" + prefixText + "%'");
        string[] items = new string[medicalitems.Rows.Count];            
        int i = 0;
        foreach (DataRow dr in medicalitems.Rows)
        {
            items.SetValue(dr["AvlQty"].ToString() + "#" + dr["Typename"].ToString() + "#" + dr["ItemID"].ToString(), i);         
            i++;
        }
        return items;
    }
    [WebMethod]
    public List<string> GetProcedures(string prefixText, int count)
    {
        DataTable Procedure = StockReports.GetDataTable("SELECT SurgeryCode FROM f_surgery_master where SurgeryCode LIKE '" + prefixText + "%' AND IsActive=1");
        List<string> GetProcedures = new List<string>();
        for (int i = 0; i < Procedure.Rows.Count; i++)
        {
            GetProcedures.Add(Procedure.Rows[i][0].ToString());
        }
        return GetProcedures;
    }
    [WebMethod]
    public List<string> GetProceduresSearch(string prefixText, int count)
    {
        DataTable Procedure = StockReports.GetDataTable("SELECT NAME FROM f_surgery_master where Name LIKE '" + prefixText + "%' AND IsActive=1");
        List<string> GetProcedures = new List<string>();
        for (int i = 0; i < Procedure.Rows.Count; i++)
        {
            GetProcedures.Add(Procedure.Rows[i][0].ToString());
        }
        return GetProcedures;
    }
    [WebMethod]
    public string[] GetInvestigations(string prefixText, int count)
    {
        DataTable procedure = StockReports.GetDataTable(" SELECT TypeName,CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#', IFNULL(Type_ID,''),'#',IF(Sample='R',Sample,'N'),'#',TnxType,'#',ifnull(ItemCode,''),'#',ifnull(GenderInvestigate,''))ItemID  FROM(SELECT im.ItemCode AS TypeName,ims.GenderInvestigate,im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode,  (CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID in (25,7) THEN 'PRO'   WHEN cr.ConfigID in (20,6)  THEN 'OTH' END)LabType, (CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID in (25,7) THEN '4'  WHEN cr.ConfigID in(20,6) THEN '5' END)TnxType , (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample  FROM f_itemmaster im  LEFT JOIN investigation_master ims ON ims.Investigation_Id = im.Type_ID INNER JOIN f_subcategorymaster sm  ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid  WHERE cr.ConfigID in (3) and im.IsActive=1   AND im.ItemCode LIKE '" + prefixText + "%'  )t1 order by TypeName");

        string[] items = new string[procedure.Rows.Count];
        int i = 0;
        foreach (DataRow dr in procedure.Rows)
        {
            items.SetValue(dr["TypeName"].ToString(), i);
            i++;
        }
        return items;
    }
    [WebMethod]
    public string[] GetInvestigationsSearch(string prefixText, int count)
    {
        DataTable procedure = StockReports.GetDataTable(" SELECT TypeName,CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#', IFNULL(Type_ID,''),'#',IF(Sample='R',Sample,'N'),'#',TnxType,'#',ifnull(ItemCode,''),'#',ifnull(GenderInvestigate,''))ItemID  FROM(SELECT im.TypeName AS TypeName,ims.GenderInvestigate,im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode,  (CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID in (25,7) THEN 'PRO'   WHEN cr.ConfigID in (20,6)  THEN 'OTH' END)LabType, (CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID in (25,7) THEN '4'  WHEN cr.ConfigID in(20,6) THEN '5' END)TnxType , (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample  FROM f_itemmaster im  LEFT JOIN investigation_master ims ON ims.Investigation_Id = im.Type_ID INNER JOIN f_subcategorymaster sm  ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid  WHERE cr.ConfigID in (3) and im.IsActive=1   AND im.TypeName LIKE '%" + prefixText + "%'  )t1 order by TypeName");

        string[] items = new string[procedure.Rows.Count];
        int i = 0;
        foreach (DataRow dr in procedure.Rows)
        {
            items.SetValue(dr["TypeName"].ToString(), i);
            i++;
        }
        return items;
    }
    [WebMethod]
    public string[] GetCompletionListCode(string prefixText, int count)
    {
        DataTable ICD = StockReports.GetDataTable("Select ICD10_Code from icd_10_new Where ISActive=1 AND ICD10_Code like '" + prefixText + "%'");
        string[] items = new string[ICD.Rows.Count];
        int i = 0;
        foreach (DataRow dr in ICD.Rows)
        {
            items.SetValue(dr["ICD10_Code"].ToString(), i);
            i++;
        }
        return items;
    }
    [WebMethod]
    public bool CompareYear(string DateFrom, string DateTo)
    {
        return Util.CompareYear(DateFrom, DateTo);
    }
    [WebMethod]
    public string BindLabInv(string str, string CPTCode, string category, string Subcategory)
    {

        DataTable dt = AllLoadData_OPD.bindlabInv(str, CPTCode, category, Subcategory);
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string BindCategory(string Type)
    {
        DataView CategoryView = LoadCacheQuery.loadCategory().AsDataView();
        if (Type == "1" || Type == "9" || Type == "10")
            CategoryView.RowFilter = " ConfigID=3";
        else if (Type == "2")
            CategoryView.RowFilter = " ConfigID=25";
        else if (Type == "3")
            CategoryView.RowFilter = " ConfigID in (20,6)";
        else if (Type == "4")
            CategoryView.RowFilter = " ConfigID=5";
        else if (Type == "5")
            CategoryView.RowFilter = " ConfigID=7";
         else if (Type == "6")
            CategoryView.RowFilter = " ConfigID in (2,6,8,9,10,20,24,14,26,27,29) ";
        else if (Type == "7")
            CategoryView.RowFilter = "  ConfigID in(11,28) ";
 	else if (Type == "8")
            CategoryView.RowFilter = "  ConfigID in(7,11,28) ";
        else if (Type == "11")
            CategoryView.RowFilter = " ConfigID=23";
        //for Blood bank
        //CategoryView.RowFilter = " ConfigID in (3,25,6,7,20)";

        if (Type == "9")
            CategoryView.RowFilter = " CategoryID=3";
        if (Type == "10")
            CategoryView.RowFilter = " CategoryID=7";

        if (Type == "10000")
        {
            CategoryView.RowFilter = " ConfigID=-1";
        }

        if (Type == "100")
        {
            string configIDs= "3";
            
            DataTable dtUserAuthorization = StockReports.GetDataTable("SELECT IF(IsCanLab =1 AND IsCanRadio=1 ,'25', IF(IsCanLab =1 AND IsCanRadio=0 ,'25,7',IF(IsCanLab =0 AND IsCanRadio=1 ,'25,3','25,3,7'))) AS IsCanLabRadio,IF(IsCanCon=1,'5','') AS IsCanCon,IF(IsCanPack=1,'23','') AS IsCanPack,IF(IsCanOther=1,'20,6','') AS IsCanOther,IF(IsCanPro=1,'25','') AS IsCanPro FROM userAuthorization WHERE RoleId=" + Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) + " and  EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
             if (dtUserAuthorization != null && dtUserAuthorization.Rows.Count > 0)
             {

             
                 if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString()) != string.Empty)
                     configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString());
                 
                 if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString()) != string.Empty)
                     configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString());
                 
                 if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString()) != string.Empty)
                     configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString());
                 
                 if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString()) != string.Empty)
                     configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString());

                 CategoryView.RowFilter = " ConfigID IN(" + configIDs + ") AND CategoryID NOT IN(" + Util.GetString(dtUserAuthorization.Rows[0]["IsCanLabRadio"].ToString()) + ") ";

             }
        }
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(CategoryView.ToTable());

    }
    [WebMethod(EnableSession=true)]
    public string BindSubCategory(string Type, string CategoryID)
    {
        DataView SubCategory = LoadCacheQuery.loadSubCategory().AsDataView();
        if (CategoryID == "0")
        {
            if (Type == "1")
                SubCategory.RowFilter = " ConfigID=3";
            else if (Type == "2")
                SubCategory.RowFilter = " ConfigID=25";
            else if (Type == "3")
                SubCategory.RowFilter = " ConfigID in (20,6)";
            else if (Type == "4")
                SubCategory.RowFilter = " ConfigID=5";
            else if (Type == "5")
                SubCategory.RowFilter = " ConfigID in (7)";
            else if (Type == "6")
                SubCategory.RowFilter = "  ConfigID in (2,6,8,9,10,20,24,14,26,27,29) ";
             else if (Type == "7")
                SubCategory.RowFilter = "  ConfigID in (11,28)  ";
            else if (Type == "8")
                SubCategory.RowFilter = "  ConfigID in (7,11,28)  ";
            else if (Type == "9")
                SubCategory.RowFilter = "  CategoryID=3  ";
            else if (Type == "10")
                SubCategory.RowFilter = "  CategoryID=7  ";
            else if (Type == "11")
                SubCategory.RowFilter = "  ConfigID=23  ";
            else if (Type == "10000")
                SubCategory.RowFilter = "  ConfigID=-1  ";
            else if (Type == "100")
            {
                string configIDs = "3";

                DataTable dtUserAuthorization = StockReports.GetDataTable("SELECT IF(IsCanLab =1 AND IsCanRadio=1 ,'25', IF(IsCanLab =1 AND IsCanRadio=0 ,'25,7',IF(IsCanLab =0 AND IsCanRadio=1 ,'25,3','25,3,7'))) AS IsCanLabRadio,IF(IsCanCon=1,'5','') AS IsCanCon,IF(IsCanPack=1,'23','') AS IsCanPack,IF(IsCanOther=1,'20,6','') AS IsCanOther,IF(IsCanPro=1,'25','') AS IsCanPro FROM userAuthorization WHERE RoleId=" + Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) + " and  EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
                if (dtUserAuthorization != null && dtUserAuthorization.Rows.Count > 0)
                {


                    if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString()) != string.Empty)
                        configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString());

                    if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString()) != string.Empty)
                        configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString());

                    if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString()) != string.Empty)
                        configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString());

                    if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString()) != string.Empty)
                        configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString());

                    SubCategory.RowFilter = " ConfigID IN(" + configIDs + ") AND CategoryID NOT IN(" + Util.GetString(dtUserAuthorization.Rows[0]["IsCanLabRadio"].ToString()) + ") ";

                }
            }

            //SubCategory.RowFilter = " ConfigID in (3,25,6,20)";
        }
        else
        {
            SubCategory.RowFilter = "CategoryID='" + CategoryID + "'";
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(SubCategory.ToTable());

    }

    [WebMethod]
    public string FrameMenu(string LoginType)
    {
        DataTable frame = StockReports.GetDataTable(" SELECT URLName,DisplayName,MenuID FROM f_framemaster fm " +
            " INNER JOIN f_rolemaster rm ON fm.RoleID = rm.ID AND rm.Active=1 WHERE fm.IsActive = 1  AND rm.RoleName = '" + LoginType.ToString() + "' ORDER BY DisplayName");

        return Newtonsoft.Json.JsonConvert.SerializeObject(frame);
    }

[WebMethod(EnableSession=true)]
    public string PatientSearchByBarCode(string PatientID, int PatientRegStatus)
    {
        DataTable PInfo = AllLoadData_OPD.patientSearchByBarCode(PatientID, PatientRegStatus);
        return Newtonsoft.Json.JsonConvert.SerializeObject(PInfo);
    }
    [WebMethod]
    public string CountPatientTestByPatientID(string patientID)
    {
        string count = StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_test pt WHERE pt.IsActive=1 AND pt.PatientID='" + patientID + "'  AND DATE(pt.createdDate)=DATE(NOW())");

        return Newtonsoft.Json.JsonConvert.SerializeObject(count);
    }

    [WebMethod]
    public string GetLastVisitDetail(string PatientID, string DoctorID)
    {
        DataTable visitInfo = AllLoadData_OPD.getLastVisitDetail(PatientID, DoctorID, null);
        return Newtonsoft.Json.JsonConvert.SerializeObject(visitInfo);
    }

    [WebMethod]
    public string IPDFrame(int RoleID, int FrameID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
                    " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + RoleID + " AND fmm.FrameID='" + FrameID + "' ORDER BY ffr.SequenceNo");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string DefaultCountry()
    {
        string str = StockReports.ExecuteScalar("SELECT Countryid FROM country_master WHERE IsActive=1 AND IsBaseCurrency=1  ORDER By Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(str);
    }
    [WebMethod]
    public string SetDefaultCity(string Country)
    {
        string str = StockReports.ExecuteScalar("SELECT distinct City from city_master where Country='" + Country + "' and city !='' order by City asc");
        return Newtonsoft.Json.JsonConvert.SerializeObject(str);
    }
    [WebMethod]
    public string BaseCurrency()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CountryID,NAME,cm.Currency,cm.Notation,B_CountryID,B_Currency");
        sb.Append("  FROM country_master cm INNER JOIN Converson_Master conmst ON cm.CountryID=conmst.S_CountryID WHERE cm.IsActive=1 ");
        sb.Append(" AND    cm.IsBaseCurrency=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(Description = "GetMinCurrency")]
    public string MinCurrency(string CountryID)
    {
        return StockReports.ExecuteScalar(" Select getMinCurrency('" + CountryID + "')");

    }
    [WebMethod]
    public string bindTitle()
    {
        string[] title = AllGlobalFunction.NameTitle;
        return Newtonsoft.Json.JsonConvert.SerializeObject(title);
    }

    [WebMethod]
    public string bindTitleWithGender()
    {
        object[] title = AllGlobalFunction.NameTitleWithGender;
        return Newtonsoft.Json.JsonConvert.SerializeObject(title);
    }

    [WebMethod]
    public string bindRelation()
    {
        string[] Relation = AllGlobalFunction.KinRelation;
        return Newtonsoft.Json.JsonConvert.SerializeObject(Relation);
    }
    [WebMethod]
    public string getCountry()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(LoadCacheQuery.loadCountry());
    }
    [WebMethod]
    public string bindPatientType()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtPatientType());
    }
    [WebMethod(EnableSession = true)]
    public string bindDoctor()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.bindDoctor());
    }

    [WebMethod(EnableSession = true)]
    public string bindDoctorCentrewise(string CentreID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.bindDoctorCentrewise(CentreID));
    }

    [WebMethod(EnableSession = true)]
    public string bindReferDoctor()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtReferDoctor());
    }
    [WebMethod(EnableSession = true)]
    public string bindPRO(string referDoctorID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtPRO(referDoctorID));
    }
    [WebMethod(EnableSession = true)]
    public string bindPanel()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.LoadPanelOPD());
    }
    [WebMethod(EnableSession = true)]
    public string bindPanelByGroupID(string GroupID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,HideRate,ShowPrintOut, ");
        sb.Append(" CONCAT(pm.PanelID,'#',ReferenceCodeOPD,'#',HideRate,'#',ShowPrintOut)PanelCompanyValue FROM f_panel_master pm  ");
        sb.Append(" INNER JOIN f_rate_schedulecharges sc ON pm.ReferenceCodeOPD=sc.PanelID  INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID ");
        sb.Append(" WHERE sc.IsDefault=1 AND pm.Isactive=1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 AND pm.DateTo>NOW() AND PanelGroupID='" + GroupID + "' ORDER BY pm.PanelID ");
        DataTable pnl = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(pnl);
    }
    [WebMethod(EnableSession = true)]
    public string BindCorporatePanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,HideRate,ShowPrintOut, ");
        sb.Append(" CONCAT(pm.PanelID,'#',ReferenceCodeOPD,'#',HideRate,'#',ShowPrintOut)PanelCompanyValue FROM f_panel_master pm  ");
        sb.Append(" INNER JOIN f_rate_schedulecharges sc ON pm.ReferenceCodeOPD=sc.PanelID  INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID ");
        sb.Append(" WHERE sc.IsDefault=1 AND pm.Isactive=1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 AND pm.DateTo>NOW() AND PanelGroupID=4 ORDER BY pm.PanelID ");
        DataTable corporate = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(corporate);
    }
    [WebMethod(EnableSession = true)]
    public string BindPanelGroup()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT PanelGroupID,PanelGroup FROM f_panelgroup WHERE active=1 AND PanelGroup<>'CORPORATE' ORDER BY PanelGroupID");
        DataTable pg = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(pg);
    }
    [WebMethod]
    public string bindPurposeOfVisit()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtPurposeOfVisit());
    }
    [WebMethod]
    public string oldPatientSearch(string PatientID, string FamilyNo, string PName, string LName, string ContactNo, string Address, string FromDate, string ToDate, int PatientRegStatus, string isCheck, string IDProof, string MembershipCardNo, string DOB, int IsDOBChecked, string Relation, string RelationName, string IPDNO, string panelID, string cardNo, string visitID, string emailID,string patientType)
    {
        DataTable dt = AllLoadData_OPD.oldPatientSearch(PatientID, FamilyNo, PName, LName, ContactNo, Address, FromDate, ToDate, PatientRegStatus, isCheck, IDProof, MembershipCardNo, DOB, IsDOBChecked, Relation, RelationName, emailID,patientType, IPDNO, panelID, cardNo, visitID);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession=true)]
    public string bindPackage()
    {
        DataTable dtPackage = AllLoadData_OPD.dtBindOPDPackage();
        if (dtPackage.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPackage);
        else
            return "";
    }
    [WebMethod]
    public string bindPackageDocDetail(string PackageID)
    {
        DataTable dtPackageDocName = AllLoadData_OPD.bindOPDPackageDocDetail(PackageID);
        if (dtPackageDocName.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPackageDocName);
        else
            return "";
    }
    
     [WebMethod]
    public string bindPackageItemDetailsNew(string PackageID)
    {
        DataTable dtPackageDocName = StockReports.GetDataTable(" CALL sp_PackageItemDetails("+ Util.GetInt(PackageID) +")");
      //  if (dtPackageDocName.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPackageDocName);
      //  else
        //    return "";
    }
    
    [WebMethod]
    public string bindDocPackage(string SubCategoryID, string DocDepartmentID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select CONCAT(Title,' ',Name)DName,DoctorID DoctorID from Package_DoctorVistiDetail pvd LEFT JOIN doctor_master dm ");
        sb.Append(" ON dm.DoctorID=pvd.DoctorID where pvd.SubCategoryID='" + SubCategoryID + "' AND pvd.DocDepartmentID='" + DocDepartmentID + "'");
        DataTable doc = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(doc);
    }
    [WebMethod (EnableSession=true)]
    public string bindPackageRate(string PackageID, string PanelID, decimal panelCurrencyFactor)
    {

        string RefID = StockReports.ExecuteScalar(" SELECT ReferenceCodeOPD FROM f_panel_master WHERE PanelID =" + PanelID + " ");

        DataTable PackageRate = AllLoadData_OPD.bindPackageRate(PackageID, RefID, panelCurrencyFactor, HttpContext.Current.Session["CentreID"].ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(PackageRate);

    }
    [WebMethod]
    public string bindGovTaxPercentage(string Name)
    {
        string GovTaxPercentage = StockReports.ExecuteScalar("Select GovTax FROM GovTax_Master WHERE Name='" + Name + "' AND IsActive=1");
        if (GovTaxPercentage != "")
            return GovTaxPercentage;
        else
            return "0";
    }
    [WebMethod]
    public string Cash()
    {
        DataTable dt = AllLoadData_OPD.Cash();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string Credit()
    {
        DataTable dt = AllLoadData_OPD.Credit();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession=true)]
    public string bindPackageDetail(string PackageID, string PanelID)
    {
        string RefID = StockReports.ExecuteScalar(" SELECT ReferenceCodeOPD FROM f_panel_master WHERE PanelID =" + PanelID + " ");
        int CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        DataTable dtPackageName = AllLoadData_OPD.bindOPDPackageDetail(PackageID, RefID,CentreID);
        if (dtPackageName.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPackageName);
        else
            return "";
    }
    [WebMethod]
    public string bindOPDPackageEdit(string PackageID)
    {
        DataTable dtPackageName = AllLoadData_OPD.bindOPDPackageEdit(PackageID);
        if (dtPackageName.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPackageName);
        else
            return "";
    }
    [WebMethod (EnableSession=true)]
    public string GetRate(string type_id, string subcategoryid, string PanelID)
    {
        //StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT im.ItemID,IFNULL(RL.ID,0)ID,IFNULL(RL.Rate,0)Rate,IFNULL(rsc.ScheduleChargeID,0)ScheduleChargeID FROM f_itemmaster im LEFT JOIN f_ratelist rl ON im.itemid = rl.itemid  AND rl.PanelID='" + PanelID + "'   AND rl.iscurrent=1 ");
        //sb.Append(" LEFT JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rl.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rl.ScheduleChargeID  ");
        //sb.Append(" WHERE im.subcategoryid='" + subcategoryid + "' AND im.type_id='" + type_id + "'  ");

        // DataTable dtRate = StockReports.GetDataTable(sb.ToString())
        DataTable dtRate = AllLoadData_OPD.GetRate(type_id, subcategoryid, Util.GetInt(PanelID), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
      if (dtRate.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRate);
        else
            return "";

    }
    [WebMethod]
    public string BindPaymentModePanelWise(string PanelID)
    {
        DataTable dtPaymentMode = All_LoadData.BindPaymentModePanelWise(PanelID);
        if (dtPaymentMode.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPaymentMode);
        else
            return "";
    }
    [WebMethod (EnableSession=true)]
    public string bindLabInvestigationRate(string PanelID, string ItemID, string TID, string IPDCaseTypeID, decimal panelCurrencyFactor)
    {
        DataTable dtRate = new DataTable();
        int NightChargexray = 0; int NightChargectscan = 0; int NightChargmri = 0;

        if (PanelID == Resources.Resource.DefaultPanelID) // only for cash patient
        {
            // subcategoryid xray = 236, ct scan = 238  mri = 237
            TimeSpan fromtime = TimeSpan.Parse("20:00:00"); TimeSpan totime = TimeSpan.Parse("07:00:00");
            if ((System.DateTime.Now.TimeOfDay >= fromtime && System.DateTime.Now.TimeOfDay <= TimeSpan.Parse("23:59:59")) || (System.DateTime.Now.TimeOfDay <= totime && System.DateTime.Now.TimeOfDay >= TimeSpan.Parse("00:00:0")))
            {
                NightChargexray = 100; NightChargectscan = 500; NightChargmri = 1000;
            }
        } 
        if (TID != "")
        {
            string ScheduleChargeID = StockReports.ExecuteScalar(" SELECT ScheduleChargeID FROM patient_medical_history WHERE TransactionID ='" + TID + "'  AND TYPE='IPD' ");
            dtRate = IPDBilling.LoadItemsHavingRateFixed("'" + ItemID.Trim() + "'", PanelID.Trim(), IPDCaseTypeID.Trim(), ScheduleChargeID.ToString().Trim(),HttpContext.Current.Session["CentreID"].ToString());
        }
        else
        {
            string RefID = StockReports.ExecuteScalar(" SELECT ReferenceCodeOPD FROM f_panel_master WHERE PanelID =" + PanelID + " ");
         //   string str = "SELECT (IFNULL(rt.Rate,0)*1)Rate";
            string str = "SELECT (IF(im.subcategoryid=236,IFNULL(rt.Rate,0)+" + NightChargexray + ",IF(im.subcategoryid=237,IFNULL(rt.Rate,0)+" + NightChargmri + ",IF(im.subcategoryid=238,IFNULL(rt.Rate,0)+" + NightChargectscan + ",IFNULL(rt.Rate,0))))*" + panelCurrencyFactor + ")Rate ";
            str += " ,rt.ScheduleChargeID,rt.ID,IFNULL(rt.ItemCode,'')ItemCode,IFNULL(rt.ItemDisplayName,'')ItemDisplayName  from f_ratelist rt INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rt.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID INNER JOIN f_itemmaster im ON im.ItemID = rt.ItemID  where rt.ItemID='" + ItemID + "' and rt.PanelID=" + RefID + " and IsCurrent=1 and rt.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'";
            dtRate = StockReports.GetDataTable(str);
        }
        if (dtRate != null)
        {
            if (dtRate.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtRate);
            else
                return "";
        }
        else
            return "";

    }
    [WebMethod]
    public string AlreadyAddmittedPatient(string PatientID)
    {
        if (StockReports.RestrictOPD_For_AlreadyAddmittedPatient(PatientID))
            return "1";
        else
            return "0";

    }
    [WebMethod]
    public string bindHashCode()
    {
        return Util.getHash();
    }
    [WebMethod]
    public string bindCPOEInvestigation(string ItemID)
    {
        DataTable dtInv = new DataTable();
        if (HttpContext.Current.Cache["OPD_Investigation"] != null)
            dtInv = HttpContext.Current.Cache["OPD_Investigation"] as DataTable;
        else
        {
            CommonService cm = new CommonService();
            dtInv = cm.OPDDiagnosisItems("0", "0", "0");
        }
        DataView DvInvestigation = dtInv.AsDataView();
        DvInvestigation.RowFilter = "NewItemID='" + ItemID + "'";
        if (dtInv.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
        else
            return "";
    }
    [WebMethod]
    public DataTable OPDDiagnosisItems(string Type, string CategoryID, string SubCategoryID)
    {       
        return LoadCacheQuery.loadOPDDiagnosisItems(Type, CategoryID, SubCategoryID);
    }
    [WebMethod]
    public string PackageExpirayDate(string PackageID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM package_master WHERE packageID='" + PackageID + "' AND CURRENT_DATE()<=toDate"));
            if (count > 0)
                return "1";
            else
                return "0";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }
    [WebMethod]
    public string bindTypeOfApp()
    {
        DataTable dtTypeOfApp = LoadCacheQuery.loadTypeOfAppointment();
        if (dtTypeOfApp.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtTypeOfApp);
        else
            return "";
    }
    [WebMethod]
    public string bindPurposeofVisit()
    {
        DataTable dtPurposeofVisit = All_LoadData.dtComplane();
        if (dtPurposeofVisit.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPurposeofVisit);
        else
            return "";
    }
    [WebMethod]
    public string bindDepartment()
    {
        DataTable dtDepartment = All_LoadData.getDocTypeList(5);
        if (dtDepartment.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDepartment);
        else
            return "";
    }
    [WebMethod]
    public string bindAppVisitType()
    {
        DataTable dtAppVisitType = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("5"));



        if (dtAppVisitType.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtAppVisitType);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindAppDoctor(string Department)
    {
        DataView DoctorView = All_LoadData.bindDoctor().Copy().AsDataView();
        if (Department.ToUpper() != "ALL")
            DoctorView.RowFilter = "Department='" + Department + "'";
        if (DoctorView.Count > 0)
        {
            DataTable dt = DoctorView.ToTable();
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string CalculateAgeBaseOnDOB(DateTime Dob)
    {
        string value = "";
        DateTime Now = DateTime.Now;
        int Years = new DateTime(DateTime.Now.Subtract(Dob).Ticks).Year - 1;
        DateTime PastYearDate = Dob.AddYears(Years);
        int Months = 0;
        for (int i = 1; i <= 12; i++)
        {
            if (PastYearDate.AddMonths(i) == Now) { Months = i; break; }
            else if (PastYearDate.AddMonths(i) >= Now)
            {
                Months = i - 1;
                break;
            }
        }
        int Days = Now.Subtract(PastYearDate.AddMonths(Months)).Days;
        if (Years == 0 && Months != 0)
        {
            value = "0 Year " + Util.GetString(Months) + " Month " + Util.GetString(Days) + " Days";
        }
        else if (Years == 0 && Months == 0)
        {
            value = "0 Year 0 Month " + Util.GetString(Days) + " Days";
        }
        else
        {
            value = Util.GetString(Years) + " Year " + Util.GetString(Months) + " Month " + Util.GetString(Months) + " Days";
        }

        return value;
    }
    [WebMethod(EnableSession = true)]
    public List<TestList> GetPatientList(string modalityName, DateTime FromDate, DateTime ToDate)
    {
        List<TestList> PatientList = new List<TestList>();
        DataTable dt = new DataTable("dtData");
        dt.Columns.Add("PatientName", typeof(string));
        dt.Columns.Add("PatientID", typeof(string));
        dt.Columns.Add("Age", typeof(string));
        dt.Columns.Add("DOB", typeof(DateTime));
        dt.Columns.Add("SEX", typeof(string));
        dt.Columns.Add("ReferingPhysicianName", typeof(string));
        dt.Columns.Add("AccessionNumber", typeof(string));
        dt.Columns.Add("ModalityName", typeof(string));
        dt.Columns.Add("ReqProcedureDescription", typeof(string));
        dt.Columns.Add("SchProcStepStartDate", typeof(DateTime));
        dt.Columns.Add("StudyInstanceUId", typeof(string));


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(pm.`Title`,' ',pm.`PName`) PatientName, pm.`PatientID` PatientID, ");
        sb.Append(" pm.`Age`,pm.`DOB`,pm.`Gender` SEX, ");
        sb.Append(" (SELECT  CONCAT(dm.`Title`,' ',dm.`Name`)ReferingPhysicianName FROM `doctor_referal` dm WHERE dm.DoctorID=pmh.`ReferedBy` )ReferingPhysicianName, ");
        sb.Append(" CONCAT(lt.`LedgerTransactionNo`,'_',REPLACE(plo.`Test_ID`,'LSHHI','')) AccessionNumber, ");
        sb.Append(" sc.`ModalityName`, ");
        sb.Append(" im.`TypeName` ReqProcedureDescription, ");
        sb.Append(" CONCAT(DATE_format(lt.date,'%d-%b-%Y'),' ',lt.`Time`) SchProcStepStartDate, ");
        sb.Append(" '' StudyInstanceUId ");
        sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` AND lt.`IsCancel`=0  ");
        sb.Append(" AND DATE(plo.`Date`)>='" + FromDate.ToString("yyyy-MM-dd") + "' AND DATE(plo.`Date`)<='" + ToDate.ToString("yyyy-MM-dd") + "'  ");
        sb.Append(" INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=lt.`TransactionID`  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`Type_ID`=plo.`Investigation_ID`  ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID` = im.`SubCategoryID` AND sc.`CategoryID`='" + Resources.Resource.PathologyCategoryID.ToString() + "' AND sc.`ModalityName`='" + modalityName + "' order by pm.PName  ");



        // File.WriteAllText(@"D:\ing.txt", sb.ToString());

        dt = StockReports.GetDataTable(sb.ToString());

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            TestList tl = new TestList();
            tl.PatientID = dt.Rows[i]["PatientID"].ToString();
            tl.PatientName = dt.Rows[i]["PatientName"].ToString();
            tl.Age = dt.Rows[i]["Age"].ToString();
            tl.DOB = Util.GetDateTime(dt.Rows[i]["DOB"]);
            tl.SEX = dt.Rows[i]["SEX"].ToString();
            tl.ReferingPhysicianName = dt.Rows[i]["ReferingPhysicianName"].ToString();
            tl.AccessionNumber = dt.Rows[i]["AccessionNumber"].ToString();
            tl.ModalityName = dt.Rows[i]["ModalityName"].ToString();
            tl.ReqProcedureDescription = dt.Rows[i]["ReqProcedureDescription"].ToString();
            tl.SchProcStepStartDate = Util.GetDateTime(dt.Rows[i]["SchProcStepStartDate"]);
            tl.StudyInstanceUId = dt.Rows[i]["StudyInstanceUId"].ToString();

            PatientList.Add(tl);

        }


        return PatientList;

    }
    public class TestList
    {
        private string _PatientID;

        public string PatientID
        {
            get { return _PatientID; }
            set { _PatientID = value; }
        }
        private string _PatientName;

        public string PatientName
        {
            get { return _PatientName; }
            set { _PatientName = value; }
        }


        private string _Age;
        public string Age
        {
            get { return _Age; }
            set { _Age = value; }
        }


        private DateTime _DOB;
        public DateTime DOB
        {
            get { return _DOB; }
            set { _DOB = value; }
        }

        private string _SEX;
        public string SEX
        {
            get { return _SEX; }
            set { _SEX = value; }
        }

        private string _ReferingPhysicianName;
        public string ReferingPhysicianName
        {
            get { return _ReferingPhysicianName; }
            set { _ReferingPhysicianName = value; }
        }


        private string _AccessionNumber;
        public string AccessionNumber
        {
            get { return _AccessionNumber; }
            set { _AccessionNumber = value; }
        }

        private string _ModalityName;
        public string ModalityName
        {
            get { return _ModalityName; }
            set { _ModalityName = value; }
        }

        private string _ReqProcedureDescription;
        public string ReqProcedureDescription
        {
            get { return _ReqProcedureDescription; }
            set { _ReqProcedureDescription = value; }
        }

        private DateTime _SchProcStepStartDate;
        public DateTime SchProcStepStartDate
        {
            get { return _SchProcStepStartDate; }
            set { _SchProcStepStartDate = value; }
        }


        private string _StudyInstanceUId;
        public string StudyInstanceUId
        {
            get { return _StudyInstanceUId; }
            set { _StudyInstanceUId = value; }
        }


    }
    [WebMethod]
    public bool updateModalityWorkList(string AccessionNumber)
    {
        try
        {
            StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd set Result_Flag=1  Where Test_ID = 'LSHHI" + AccessionNumber.Split('_')[1] + "'");
            return true;
        }
        catch (Exception ex)
        {

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return false;
        }
    }
    [WebMethod]
    public string Patient_Master_log(DateTime FromDate, DateTime ToDate)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT pm.ID  AS SNo,pm.PatientID,pm.Title,pm.PFirstName,pm.PLastName,Age,Gender,DATE_FORMAT(DOB,'%d %b %Y')DOB,DATE_FORMAT(pm.tg_datetime,'%d %b %Y')ModifiedDate,Country,City FROM mscl_log.patient_master_before_update pm WHERE DATE(pm.tg_datetime)>='" + FromDate.ToString("yyyy-MM-dd") + "' AND  DATE(pm.tg_datetime)<='" + ToDate.ToString("yyyy-MM-dd") + "' "));
    }
    [WebMethod]
    public string Compare_Log(int LogID, string PatientID)
    {
        string query = "SELECT pm.PatientID `UHID`,pm.Title,pm.PFirstName `First Name`,pm.PLastName `Last Name`,Gender `Sex`,DATE_FORMAT(DOB,'%d %b %Y')DOB,House_No Address,Country,City,Passport_No `Passport No.`,LanguageSpoken `Language`,Occupation,ReligiousAffiliation Religion,PlaceOfBirth `Place Of Birth`,DATE_FORMAT(Updatedate,'%d %b %Y %h:%i %p') `Modified Date`,(SELECT CONCAT(title, ' ', NAME) FROM employee_master WHERE Employee_ID = pm.LastUpdatedBy) `Modified By`  FROM patient_master pm WHERE PatientID='" + PatientID + "' UNION ALL SELECT pm.PatientID `UHID`,pm.Title,pm.PFirstName `First Name`,pm.PLastName `Last Name`,Gender `Sex`,DATE_FORMAT(DOB,'%d %b %Y')DOB,House_No Address,Country,City,Passport_No `Passport No.`,LanguageSpoken `Language`,Occupation,ReligiousAffiliation Religion,PlaceOfBirth `Place Of Birth`,DATE_FORMAT(pm.tg_datetime,'%d %b %Y %h:%i %p') `Modified Date`,(SELECT CONCAT(title,' ',NAME) FROM employee_master WHERE Employee_ID=pm.LastUpdatedBy)`Modified By` FROM mscl_log.patient_master_before_update pm WHERE  pm.ID=" + LogID + "";
        DataTable dtLog = StockReports.GetDataTable(query);
        if (dtLog.Rows.Count > 0)
        {
            DataTable Log = new DataTable();
            Log.Columns.Add("ColumnName");
            Log.Columns.Add("CurrentData");
            Log.Columns.Add("PreviousData");
            Log.Columns.Add("ChangeLog");
            for (int i = 0; i < dtLog.Columns.Count; i++)
            {
                DataRow row = Log.NewRow();
                row["ColumnName"] = dtLog.Columns[i].ColumnName;
                row["CurrentData"] = dtLog.Rows[0][dtLog.Columns[i].ColumnName].ToString();
                row["PreviousData"] = dtLog.Rows[1][dtLog.Columns[i].ColumnName].ToString();

                if (dtLog.Rows[0][dtLog.Columns[i].ColumnName].ToString() != dtLog.Rows[1][dtLog.Columns[i].ColumnName].ToString())
                    row["ChangeLog"] = "1";
                else
                    row["ChangeLog"] = "0";
                Log.Rows.Add(row);
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(Log);
        }
        else
            return "";

    }
    [WebMethod]
    public string editPatientSearch(string PatientID, string PName, string DateEnrolledFrom, string DateEnrolledTo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PatientID,title,PFirstName,PLastName,Age,DATE_FORMAT(DOB,'%d-%b-%Y')DOB,Mobile,");
        sb.Append(" Country,City,DATE_FORMAT(DateEnrolled,'%d-%b-%y')DateEnrolled FROM Patient_master WHERE PatientID<>''");
        if (PatientID.Trim() != "")
        {
            sb.Append(" and PatientID='" + PatientID.Trim() + "'");
        }
        else if (PName.Trim() != "")
        {
            sb.Append(" and PName like '%" + PName + "%'");
            sb.Append(" and DateEnrolled>='" + Util.GetDateTime(DateEnrolledFrom).ToString("yyyy-MM-dd") + "' AND DateEnrolled<='" + Util.GetDateTime(DateEnrolledTo).ToString("yyyy-MM-dd") + "'");

        }
        else if ((PatientID.Trim() == "") && (PName.Trim() == ""))
            sb.Append(" and DateEnrolled>='" + Util.GetDateTime(DateEnrolledFrom).ToString("yyyy-MM-dd") + "' AND DateEnrolled<='" + Util.GetDateTime(DateEnrolledTo).ToString("yyyy-MM-dd") + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string editPatientDetail(string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PatientID,Title,PFirstName,PLastName,Age,DATE_FORMAT(DOB,'%d-%b-%Y')DOB,Mobile,House_No,Email,Passport_No,Country,City,Gender,Relation,RelationName, ");
        sb.Append(" occupation,ResidentialAddress,LanguageSpoken,ReligiousAffiliation,PlaceOfBirth,Employer,PinCode,Ethnicity FROM  Patient_master WHERE PatientID='" + PatientID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string getPatientID(string TID)
    {
        StringBuilder sb = new StringBuilder();
        string PID = StockReports.ExecuteScalar("Select PatientID from patient_ipd_profile where status='IN' and TransactionID='ISHHI" + TID + "' ");

        if (PID != "")
            return PID;
        else
            return "";

    }
    [WebMethod]
    public string getTransactionID(string PatientID)
    {
        string TID = StockReports.ExecuteScalar("Select CONCAT(pip.TransactionID,'#',icm.Name,'#',IPDCaseType_ID_Bill)TID from patient_ipd_profile pip INNER JOIN ipd_case_type_master icm ON pip.IPDCaseType_ID=icm.IPDCaseType_ID where status='IN' and pip.PatientID='" + PatientID + "' ");

        if (TID != "")
            return TID;
        else
            return TID;
    }
    [WebMethod]
    public string IPD_Threshold(string PatientID)
    {
        DataTable dt = AllLoadData_IPD.getIPDThreshold(PatientID);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string docTimingDateWise(string DoctorID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DATE_FORMAT(DATE,'%y')DocYear,DATE_FORMAT(DATE,'%b')DocMonth,GROUP_CONCAT(DATE_FORMAT(DATE,'%d')) DocDate FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' AND  DATE(DATE)>=CURDATE() GROUP BY MONTH(DATE),YEAR(DATE) ORDER BY MONTH(DATE),YEAR(DATE)");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string LoadMedicineSet(string DoctorID)
    {
        StringBuilder sb = new StringBuilder();
        if (DoctorID != "")
        {
            sb.Append(" SELECT msm.ID,msm.SetName FROM MedicineSetmasterDoctorWise msmd INNER JOIN MedicineSetmaster msm ON msm.ID=msmd.SetID ");
            sb.Append(" WHERE msmd.DoctorID='" + DoctorID + "' ");
        }
        else
            sb.Append(" SELECT msm.ID,msm.SetName FROM MedicineSetmaster msm where IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string LoadMedSetItems(string SetID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT med.ID,med.quantity,im.Typename NAME,im.ItemID,med.SetID,msm.Setname setName,im.MedicineType,med.Dose,med.times,med.Duration,med.Route,med.Meal FROM MedicineSetItemMaster med INNER JOIN f_itemmaster im ON im.ItemID=med.itemID INNER JOIN  MedicineSetmaster msm ON med.setID=msm.ID WHERE med.setID='" + SetID + "' ORDER BY im.Typename ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string GetMedicineStock(string MedicineID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT rm.RoleName DeptName,SUM(st.InitialCount-st.ReleasedCount)Quantity FROM f_stock st INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=st.DeptLedgerNo inner Join f_itemmaster im on im.itemID=st.itemID WHERE st.ItemID='" + MedicineID + "' AND st.IsPost=1 AND rm.IsStore=1  GROUP BY rm.DeptLedgerNo ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string PatientOutstanding(string PatientID)
    {
        return Util.GetString(StockReports.ExecuteScalar("SELECT PatientOutstanding('" + PatientID + "')"));
    }

    [WebMethod]
    public string GetAdvanceBooking(string patientID)
    {
        string result = "0";

        DataTable dt = StockReports.GetDataTable(" SELECT arb.ID,arb.PatientID,DATE_FORMAT(arb.BookingDate,'%d-%b-%Y')BookingDate,arb.IPDCaseType_ID,arb.Room_ID,arb.IPDCaseType_ID_Bill,arb.DoctorID,arb.ReferedBy,arb.Parent_ID,arb.PanelID,arb.PolicyNo, " +
                                                    " DATE_FORMAT(arb.ExpiryDate,'%d-%b-%Y')ExpiryDate,arb.CardNo,arb.CardHolderName,arb.RelationWith_holder,arb.PanelIgnoreReason,CONCAT(rm.Name,'-',rm.Room_No,'-',rm.Bed_No)Room_No " +
                                                    " FROM advance_room_booking arb INNER JOIN room_master rm ON arb.Room_ID=rm.Room_ID WHERE arb.IsCancel=0 AND DATE(arb.BookingDate)>=CURRENT_DATE() AND PatientID='" + patientID + "' ORDER BY arb.ID DESC LIMIT 1 ");
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }
    [WebMethod(EnableSession = true)]
    public string DistrictInsert(string District, string countryID, string stateID)
    {
        return AllInsert.districtInsert(District, countryID, stateID);
    }


    [WebMethod(EnableSession = true)]
    public string PurposeOfVisitInsert(string VisitName)
    {
        return AllInsert.PurposeVisit(VisitName);
    }
    [WebMethod(EnableSession = true)]
    public string TalukaInsert(string Taluka, string districtID, string cityID)
    {
        return AllInsert.talukInsert(Taluka, districtID, cityID);

    }
    [WebMethod]
    public string getDistrict(string countryID, string stateID)
    {
        DataTable dtDistrict = LoadCacheQuery.loadDistrict(countryID, stateID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtDistrict);
    }
    [WebMethod]
    public string getTaluka(string DistrictID)
    {
        DataTable dtTaluka = LoadCacheQuery.loadTaluk(DistrictID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtTaluka);
    }
    [WebMethod]
    public string getTimeDuration(string Type)
    {
        DataTable dt = LoadCacheQuery.LoadMedicineQuantity(Type);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string GetDoctorGroup()
    {
        string strdoctorgroup = "select ID,DocType from doctorGroup where IsActive=1";
        DataTable dt = StockReports.GetDataTable(strdoctorgroup);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string SaveRocording(string Audio, string TID, string PID, string FileName, string Type)
    {
        return AllInsert.InsertVoice(Audio, PID, TID, Type, FileName, HttpContext.Current.Session["ID"].ToString());
    }
    [WebMethod]
    public decimal patientOPDAdv(String PatientID)
    {
        return Util.GetDecimal(AllLoadData_OPD.patientOPDAdv(PatientID));

    }
    [WebMethod]
    public string LoadFrameIPD(int RoleID)
    {

        DataTable dt = StockReports.GetDataTable(" SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
                    " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + RoleID + " and upper(FrameName)='IPD' ORDER BY ffr.SequenceNo");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string[] getDoTimingDateWise(string DoctorID)
    {
        List<string> dates = new List<string>();
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT CONCAT(DATE_FORMAT(DATE,'%Y-%c-%e'))DocDate  FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' AND DATE(DATE)>=CURDATE()");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                //  dates.Add(string.Format("{0:dd/MM/yyyy}", dt.Rows[i]["DocDate"].ToString()));
                dates.Add(dt.Rows[i]["DocDate"].ToString());
            }
        }
        return dates.ToArray();
    }
    [WebMethod]
    public string getDocDays(string DoctorID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(DAY) FROM `doctor_hospital` WHERE DoctorID='" + DoctorID + "'");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string getVisitDetail(int AppID, string date)
    {
        return AllLoadData_OPD.getAppVisitDetail(AppID, Util.GetDateTime(date));
    }
    [WebMethod]
    public string getOutsourceLab()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(AllLoadData_OPD.bindOutsourceLab());

    }
    [WebMethod]
    public string getState(int countryID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(LoadCacheQuery.loadState(countryID));
    }

    [WebMethod(EnableSession = true)]
    public string StateInsert(string CountryID, string StateName)
    {
        return AllInsert.stateInsert(CountryID, StateName);

    }
    [WebMethod(EnableSession = true)]
    public string bindFieldBoy()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT FieldBoyID,FieldBoyName FROM master_fieldboy WHERE IsActive=1"));

    }

    [WebMethod(EnableSession = true)]
    public string FieldBoyInsert(string Name, string Address, string ContactNo)
    {

        return AllInsert.FieldBoyInsert(Name, Address, ContactNo);
    }

    [WebMethod]
    public string LoadMembershipDisc(string TnxType, string MembershipCardNo, string SubCategoryID, string Type, string ItemID)
    {
        if (TnxType == "Appointment")
            ItemID = StockReports.ExecuteScalar("SELECT ItemID from f_itemmaster where Type_ID='" + ItemID + "' and subcategoryid='" + SubCategoryID + "' LIMIT 1 ");
        else if (TnxType == "OPDPackage")
            ItemID = StockReports.ExecuteScalar("SELECT im.ItemID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID WHERE im.IsActive=1  AND cf.ConfigID=23 and Type_ID='" + ItemID + "' LIMIT 1 ");

        GetDiscount ds = new GetDiscount();
        string MembershipDisc = ds.GetDefaultDiscount_Membership(ItemID, MembershipCardNo, Type);
        return Newtonsoft.Json.JsonConvert.SerializeObject(MembershipDisc);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getPanel(string PanelGroup)
    {
        DataTable dtPanel = new DataTable();
        if (PanelGroup == "" || PanelGroup == "ALL")
            dtPanel = StockReports.GetDataTable("SELECT PanelID,Company_Name FROM f_panel_master where IsActive=1 ORDER BY Company_Name");
        else
            dtPanel = StockReports.GetDataTable("Select Company_Name,PanelID from f_Panel_master where IsActive=1 and PanelGroup='" + PanelGroup + "' ORDER BY Company_Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getPanelGroup()
    {
        DataTable dtPanelGroup = StockReports.GetDataTable("Select * from f_panelgroup where active=1 order by PanelGroup");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanelGroup);
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindPanelPatient(string PatientID, string Name, string PanelID, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.`PatientID`,CONCAT(pm.`Title`,' ',pm.`PName`)PName,CONCAT(pm.Age,'/',pm.Gender)AgeSex,pm.Mobile,pm.city,pm.State ");
        sb.Append(" FROM patient_medical_history pmh  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON pmh.`TransactionID`=lt.`TransactionID` ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.`PatientID`=pm.`PatientID` ");
        sb.Append(" WHERE pmh.Type='OPD' ");
        if (PatientID != "")
            sb.Append(" AND pm.PatientID='" + PatientID + "' ");
        if (Name != "")
            sb.Append(" AND pm.PName LIKE' " + Name + "%'");
        if (PanelID != "0")
            sb.Append(" AND pmh.PanelID =" + PanelID + " ");

        if (PatientID == "" && Name == "" && PanelID == "0")
            sb.Append(" AND DATE(lt.Date)>='" + Convert.ToDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Convert.ToDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" GROUP BY pmh.PatientID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindPatientIDProof()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CONCAT(ID,'#',IDNoLength)ID,IDProofName,IDNoLength FROM PatientID_proof_master WHERE IsActive=1 ");

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindReligion()
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM patient_Religion");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else { return ""; }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getTnxDetail(string PatientID, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(CONCAT(lt.`Date`,' ',lt.`Time`),'%d-%b-%Y %H:%i %p')VisitDate, lt.`TypeOfTnx`,pnl.Company_Name Panel,pmh.`TransactionID` ");
        sb.Append(" FROM patient_medical_history pmh  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON pmh.`TransactionID`=lt.`TransactionID` ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID` ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.`PatientID`=pm.`PatientID` ");
        sb.Append(" WHERE pmh.Type='OPD' ");

        if (PatientID != "")
            sb.Append(" AND pm.PatientID='" + PatientID + "' ");

        if (PatientID == "")
            sb.Append(" AND DATE(lt.Date)>='" + Convert.ToDateTime(FromDate).ToString("yyyy-MM-dd") + "' and DATE(lt.Date)<='" + Convert.ToDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" ORDER by CONCAT(lt.Date,' ',lt.Time),pmh.TransactionID,pmh.PatientID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getDocumentDetail(string TransactionID, string Status)
    {

        string ServerPath = Server.MapPath("~");
        string newSp = "\\\\";
        string oldsp = "\\";
        ServerPath = ServerPath.Replace(oldsp, newSp);
        string str = string.Empty;
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,FileName,FilePath,PatientID, ");
        sb.Append(" TransactionID TID,DATE_FORMAT(DateTime,'%d-%b-%Y %H:%i %p')Date,FileExtn ");
        sb.Append(" FROM patient_document WHERE TransactionID='" + TransactionID + "'");

        if (Status != "All")
            sb.Append(" AND IsActive='" + Status + "' ");

        DataTable dtDocumentDetail = StockReports.GetDataTable(sb.ToString());

        if (dtDocumentDetail.Rows.Count > 0 && dtDocumentDetail != null)
        {
            string IpFolder = "";
            string Ip = "";
            string FilePath2 = "";
            string SubDirPath = @"C:\inetpub\wwwroot\his\PanelDocument\" + Util.GetString(dtDocumentDetail.Rows[0]["PatientID"]);


            DirectoryInfo folder = new DirectoryInfo(@"C:\inetpub\wwwroot\his\PanelDocument");
            if (folder.Exists)
            {
                DirectoryInfo[] User = folder.GetDirectories(Util.GetString(dtDocumentDetail.Rows[0]["PatientID"]));
                if (User.Length > 0)
                {
                    foreach (DirectoryInfo Sub in User)
                    {
                        if (Sub.Name == Util.GetString(dtDocumentDetail.Rows[0]["PatientID"]))
                        {
                            IpFolder = Sub.Name;
                            Ip = Path.Combine(@"C:\inetpub\wwwroot\his\PanelDocument", IpFolder);
                            FilePath2 = Path.Combine(Ip, Util.GetString(dtDocumentDetail.Rows[0]["FileName"]) + Util.GetString(dtDocumentDetail.Rows[0]["FileExtn"]) + Util.GetString(dtDocumentDetail.Rows[0]["FileName"]) + Util.GetString(dtDocumentDetail.Rows[0]["FileExtn"]));
                            break;
                        }
                    }
                }
                else
                {
                    DirectoryInfo subFold = folder.CreateSubdirectory(Util.GetString(dtDocumentDetail.Rows[0]["PatientID"]));
                    IpFolder = subFold.Name;
                    Ip = Path.Combine(@"C:\inetpub\wwwroot\his\PanelDocument", IpFolder);
                    FilePath2 = Path.Combine(Ip, Util.GetString(dtDocumentDetail.Rows[0]["FileName"]) + Util.GetString(dtDocumentDetail.Rows[0]["FileExtn"]) + Util.GetString(dtDocumentDetail.Rows[0]["FileName"]) + Util.GetString(dtDocumentDetail.Rows[0]["FileExtn"]));
                }
                for (int i = 0; i < dtDocumentDetail.Rows.Count; i++)
                {
                    string sourceFile = @"D:\shubham\HISDocument\OPDDocument\" + Util.GetString(dtDocumentDetail.Rows[i]["PatientID"]) + @"\" + Util.GetString(dtDocumentDetail.Rows[i]["FileName"]) + Util.GetString(dtDocumentDetail.Rows[i]["FileExtn"]);
                    string destinationFile = @"C:\inetpub\wwwroot\his\PanelDocument\" + Util.GetString(dtDocumentDetail.Rows[i]["PatientID"]) + @"\" + Util.GetString(dtDocumentDetail.Rows[i]["FileName"]) + Util.GetString(dtDocumentDetail.Rows[i]["FileExtn"]);

                    System.IO.File.Delete(destinationFile);
                    // To Copy a file or folder to a new location:
                    System.IO.File.Copy(sourceFile, destinationFile);
                }
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDocumentDetail);
        }
        else
            return "0";


    }
    [WebMethod]
    public string GetBankMaster()
    {
        var dt = LoadCacheQuery.loadBank();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession=true)]
    public string LoadOPD_All_ItemsLabAutoComplete(int searchType, string prefix, string Type, string CategoryID, string SubCategoryID, string itemID)
    {       
        var dt = LoadCacheQuery.loadOPDDiagnosisItems(Type, CategoryID, SubCategoryID);

        DataView DvInvestigation = dt.AsDataView();
        string filter = string.Empty;
        if (!string.IsNullOrEmpty(itemID))
        {
            filter = "Item_ID='" + itemID + "'";
            DvInvestigation.RowFilter = filter;
        }
        else
        {
            if (searchType == 1)
            {
                filter = "TypeName LIKE '%" + prefix + "%'";
                DvInvestigation.RowFilter = filter;
            }
            else
            {
                filter = "ItemCode LIKE '%" + prefix + "%'";
                DvInvestigation.RowFilter = filter;
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
    }


    [WebMethod]
    public string LoadCurrencyDetail()
    {
        DataTable dtDetail = All_LoadData.LoadCurrencyFactor("");
        DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");
        var baseNotation = dr[0]["Notation"].ToString();
        //lblFactor.Text = dr[0]["Selling_Specific"].ToString();
        var baseCountryID = dr[0]["B_CountryID"].ToString();
        var baseCurrency = dr[0]["B_Currency"].ToString();
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { currancyDetails = dtDetail, baseNotation = baseNotation, baseCountryID = baseCountryID, baseCurrency = baseCurrency });
    }


    [WebMethod]
    public string BindDispatchMode()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT r.ID,r.DispatchMode FROM report_dispatchmaster r"));
    }

    [WebMethod]
    public string GetItemIDBySubCategoryIDAndDoctorID(string SubCategoryID, int DoctorID,int centreID)
    {
       // string itemid = Util.GetString(StockReports.ExecuteScalar("SELECT ItemID FROM f_itemmaster WHERE Type_ID='" + DoctorID + "' AND SubcategoryID=" + SubCategoryID + ""));

        if(SubCategoryID == string.Empty)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, DoctorItemID = "Please Contact to EDP for Set Default Doctor Visit " });
          
        string itemid = Util.GetString(StockReports.ExecuteScalar(" SELECT im.ItemID FROM f_itemmaster im INNER JOIN `f_itemmaster_centerwise` cm ON cm.`ItemID`=im.`ItemID` AND cm.`CentreID`=1 AND cm.`IsActive`=1 WHERE im.Type_ID='" + DoctorID + "' AND im.SubcategoryID=1 LIMIT 1 "));
        
        if(itemid != string.Empty && itemid != null && itemid != "0")
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, DoctorItemID = itemid });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, DoctorItemID = "Please Contact to EDP for Map doctor visit with Centre " });  
    }

    [WebMethod(EnableSession = true)]
    public string CheckAuthorization()
    {
        string IsCanCon = Util.GetString(StockReports.ExecuteScalar(" SELECT IF(COUNT(*)>0,'1','0') FROM userAuthorization u WHERE u.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' AND u.ColName='IsCanCon' AND u.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND u.RoleID=" + Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) + " "));
            
      //  string IsCanCon = "1";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = IsCanCon });
    }

    [WebMethod]
    public string GetDiscountWithCoPay(string itemID, int panelID, int patientTypeID, string memberShipCardNo)
    {
        DataTable dt = StockReports.GetDataTable("CALL  GetPanelItemDisc_Copay_Payble ('" + itemID + "'," + panelID + "," + patientTypeID + ")");
        int IsPayble = Util.GetInt(dt.Rows[0]["IsPayble"]);
        string ItemID = Util.GetString(dt.Rows[0]["ItemID"]);
        decimal OPDPanelDiscPercent = Util.GetDecimal(dt.Rows[0]["OPDPanelDiscPercent"]);
        decimal OPDCoPayPercent = Util.GetDecimal(dt.Rows[0]["OPDCoPayPercent"]);
        decimal IPDPanelDiscPercent = Util.GetDecimal(dt.Rows[0]["IPDPanelDiscPercent"]);
        decimal IPDCoPayPercent = Util.GetDecimal(dt.Rows[0]["OPDPanelDiscPercent"]);
        if (OPDPanelDiscPercent > 0 || memberShipCardNo == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            string str = " SELECT md.`OPD` FROM `membership_discount_subcategorywise` md  INNER JOIN membershipcard mc ON md.`CardID`=mc.`MembershipCardID` AND mc.`CardNo`='" + memberShipCardNo + "' ";
            str += " INNER JOIN f_itemmaster im ON im.`SubCategoryID`=md.`SubcategoryID` AND im.`ItemID`='" + itemID + "' ";
            decimal MemberDisc = Util.GetDecimal(StockReports.ExecuteScalar(str));
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT " + IsPayble + " as 'IsPayble'," + MemberDisc + " as 'OPDPanelDiscPercent'," + OPDCoPayPercent + " as 'OPDCoPayPercent'," + IPDPanelDiscPercent + " as 'IPDPanelDiscPercent'," + IPDCoPayPercent + " as 'IPDCoPayPercent' "));

        }
    }


    [WebMethod]
    public string GetPatientType()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT pt.id,pt.PatientType FROM patient_type pt WHERE  pt.IsActive=1"));
    }

    [WebMethod(EnableSession=true)]
    public string RerunLabTest(string test_ID, string isTestRerun, string reason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction();

        try
        {
            string query = " CALL UpdateRerunLabTest(@vTest_ID,@vIsTestRerun,@vUser_ID,@vReason); ";

            var result = Util.GetString(
                             MySqlHelper.ExecuteScalar(tranx, CommandType.Text, query,
                                    new MySqlParameter("@vTest_ID", test_ID),
                                    new MySqlParameter("@vIsTestRerun", isTestRerun),
                                    new MySqlParameter("@vUser_ID", HttpContext.Current.Session["ID"].ToString()),
                                    new MySqlParameter("@vReason", reason)
                             )
                         );

            if (result == "1")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Test Re-Run Request Saved Successfully" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string GetEmployeeType()
    {
        var userTypes = All_LoadData.dtUserType("Employee");
        return Newtonsoft.Json.JsonConvert.SerializeObject(userTypes);
    }

    //[WebMethod]
    //public string GetEmpByEmployeeType(string employeeType) {
    //    var sqlCmd = new StringBuilder("SELECT CONCAT(em.title,' ',em.name) `Name`,em.Employee_ID FROM employee_master em ");
    //    if (!string.IsNullOrEmpty(employeeType) && employeeType!="0")
    //          sqlCmd.Append("WHERE em.Employee_ID IN (SELECT eh.Employee_ID FROM employee_hospital eh WHERE  eh.Designation='%" + employeeType + "%')");

    //    DataTable dataTable = StockReports.GetDataTable(sqlCmd.ToString());
    //    return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    //}


    [WebMethod]
    public string GetRoles()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,RoleName FROM f_rolemaster WHERE active=1 ORDER BY RoleName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SetDefaultRole(int roleID)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML("UPDATE f_login f SET f.isDefault=0 WHERE  f.EmployeeID=@empID", CommandType.Text, new
            {
                empID = HttpContext.Current.Session["ID"].ToString()
            });

            excuteCMD.DML("UPDATE f_login f SET f.isDefault=1 WHERE f.RoleID=@roleID AND f.EmployeeID=@empID", CommandType.Text, new
            {
                roleID = roleID,
                empID = HttpContext.Current.Session["ID"].ToString()
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Set Successfully", message = "" });

        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }


    [WebMethod(EnableSession = true)]
    public string SaveNewDiscountReason(string discountReason, string type)
    {
        return AllInsert.SaveDiscReason(discountReason, type);
    }

    [WebMethod]
    public string LoadFrameMortuary(int RoleID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
                    " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + RoleID + " and upper(FrameName)='MORTUARY' ORDER BY ffr.SequenceNo");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string bindFloor()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Name FROM floor_master ORDER BY SequenceNo");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string bindBloodGroup()
    {
        object[] BloodGroup = AllGlobalFunction.BG;
        return Newtonsoft.Json.JsonConvert.SerializeObject(BloodGroup);
    }


    [WebMethod]
    public string ValidateDuplicatePatientEntry(string patientID, string firstName, string lastName, string mobileNumber, List<IDProof> IDProof)
    {
        if (IDProof.Count > 0)
        {
            string msg = "";
            for (int i = 0; i < IDProof.Count; i++)
            {
                DataTable dt = StockReports.GetDataTable("SELECT PatientID,IDProofName,IDProofNumber FROM PatientID_proofs WHERE IDProofID=" + IDProof[i].IDProofID + " AND TRIM(IDProofNumber)=TRIM('" + IDProof[i].IDProofNumber + "') and PatientID<>'" + patientID + "' ");
                if (dt.Rows.Count > 0)
                {
                    for (int J = 0; J < dt.Rows.Count; J++)
                    {
                        //dt.Rows[J]["IDProofName"].ToString() + " : " + dt.Rows[J]["IDProofNumber"].ToString() + "
                        msg += dt.Rows[J]["IDProofName"].ToString() + " Allready Exist with Patient ID : " + dt.Rows[J]["PatientID"].ToString() + "<br/>";
                    }
                }
            }
            if (msg != "")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = msg, patientID = "0", IsIDProof = "1" });
            }
        }
        if (string.IsNullOrEmpty(patientID))
        {
            DataTable dt = StockReports.GetDataTable("SELECT pm.PatientID FROM patient_master pm WHERE pm.PFirstName='" + firstName + "' AND pm.PLastName='" + lastName + "' AND pm.Mobile='" + mobileNumber + "'");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Already Registred", patientID = dt.Rows[0]["PatientID"].ToString(), IsIDProof = "0" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", IsIDProof = "0" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", IsIDProof = "0" });

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPanelDetails(string PanelID)
    {
        string PanelAdvanceAmt = StockReports.ExecuteScalar(" SELECT SUM((pla.`LedgerReceivedAmt`-pla.`AdjustmentAmount`))AdvanceAmt FROM panel_ledgeraccount pla WHERE pla.`IsCancel`=0 AND pla.`LedgerReceivedAmt`>pla.`AdjustmentAmount` AND IF(pla.`PaymentModeID`=2,pla.`IsClear`=1,pla.`IsClear` IN(0,1)) AND pla.`PanelID`=" + PanelID + " ");
        decimal panelAdvanceAmount = 0;

        if (!string.IsNullOrEmpty(PanelAdvanceAmt))
            panelAdvanceAmount = Util.GetDecimal(PanelAdvanceAmt);

        DataTable dt = StockReports.GetDataTable("SELECT p.RateCurrencyCountryID ,cm.S_Currency,cm.S_Notation,cm.Selling_Specific,cm.ID FROM  f_panel_master p INNER JOIN (SELECT * FROM converson_master WHERE ID IN(SELECT MAX(c.id) MaXID FROM converson_master c GROUP BY c.S_CountryID ORDER BY id DESC )) cm  ON cm.S_CountryID=p.RateCurrencyCountryID WHERE p.PanelID=" + PanelID);

        var details = new
        {
            panelAdvanceAmount = panelAdvanceAmount,
            RateCurrencyCountryID = Util.GetString(dt.Rows[0]["RateCurrencyCountryID"]),
            panelCurrency = Util.GetString(dt.Rows[0]["S_Currency"]),
            panelCurrencyFactor = Util.GetString(dt.Rows[0]["Selling_Specific"])
        };

        return Newtonsoft.Json.JsonConvert.SerializeObject(details);

    }

    [WebMethod(EnableSession = true)]
    public string bindEmergencyDoctor()
    {
        try
        {
            DataView DoctorView = All_LoadData.bindDoctor().AsDataView();
            DoctorView.RowFilter = "IsEmergencyAvailable='1'";
            return Newtonsoft.Json.JsonConvert.SerializeObject(DoctorView.ToTable());
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }
    
    [WebMethod(EnableSession = true)]
    public string validateEmergencyPatient(string PID)
    {

        return Util.GetString(StockReports.ExecuteScalar("SELECT EmergencyNo FROM Emergency_Patient_Details WHERE IsReleased=0 AND PatientId='" + PID + "'"));

    }
    [WebMethod]
    public float validateRegistrationCharges(string PID)
    {

        return Util.GetFloat(StockReports.ExecuteScalar(" SELECT pm.`FeesPaid` FROM `patient_master` pm WHERE pm.`PatientID`='" + PID + "'; "));

    }



    [WebMethod(EnableSession = true)]
    public string BindDoctorCost(string Type_ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT sc.Name,ROUND(IFNULL((SELECT rt.Rate FROM f_ratelist rt WHERE rt.ItemID=im.ItemID AND rt.IsCurrent=1 AND rt.PanelID=1 LIMIT 1),0),4)Rate FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID=sc.CategoryID WHERE cf.ConfigID=5 AND im.IsActive=1 AND im.Type_ID='" + Type_ID + "' ORDER BY sc.DisplayPriority");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string BindOnlineBookingInvestigation(string FromDate, string ToDate, string Mobile)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT '1' IsRegistred,PM.PFirstName,PM.PLastName,PM.Relation,PM.RelationName,PM.Source,PM.House_No,ib.patientID,ib.EntryNo,DATE_FORMAT(ib.BookingDate,'%d-%b-%Y')BookingDate,pm.id OnlinePID,GROUP_CONCAT(ib.ItemID)ItemID,ib.PanelID, pm.Title,pm.PName PatientName,pm.Age,pm.Mobile,pm.Gender,COUNT(*) TotalTest,GROUP_CONCAT(im.TypeName SEPARATOR ',<br>')TestName,GROUP_CONCAT(ib.ID)IbID FROM app_InvestigationBooking ib INNER JOIN patient_master pm ON pm.PatientID=ib.PatientID INNER JOIN f_itemmaster im ON im.ItemID=ib.ItemID WHERE ib.IsPrescribe=0 ");
        if (FromDate != "" && ToDate != "")
            sb.Append(" AND ib.BookingDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND ib.BookingDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");

        if (Mobile != "")
            sb.Append(" and pm.Mobile='" + Mobile + "' ");
        sb.Append("  GROUP BY pm.PatientID,ib.BookingDate,ib.EntryNo ");
        sb.Append(" UNION ALL ");
        sb.Append("SELECT  '0' IsRegistred,PM.PFirstName,PM.PLastName,PM.Relation,PM.RelationName,PM.Source,PM.House_No,ib.patientID,ib.EntryNo,DATE_FORMAT(ib.BookingDate,'%d-%b-%Y')BookingDate,pm.id OnlinePID,GROUP_CONCAT(ib.ItemID)ItemID,ib.PanelID, pm.Title,pm.PatientName,pm.Age,pm.Mobile,pm.Gender,COUNT(*) TotalTest,GROUP_CONCAT(im.TypeName SEPARATOR ',<br>')TestName,GROUP_CONCAT(ib.ID)IbID FROM app_InvestigationBooking ib INNER JOIN app_patient_master pm ON pm.ID=ib.PatientID INNER JOIN f_itemmaster im ON im.ItemID=ib.ItemID WHERE ib.IsPrescribe=0 ");
        if (FromDate != "" && ToDate != "")
            sb.Append(" AND ib.BookingDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND ib.BookingDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");

        if (Mobile != "")
            sb.Append(" and pm.Mobile='" + Mobile + "' ");
        sb.Append("  GROUP BY pm.ID,ib.BookingDate,ib.EntryNo ");

        sb.Append("  order by BookingDate,PatientName desc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string BindOnlineBookingInvestigationDetails(string BookingIds)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT pt.itemID, pt.ID PatientTest_ID, pt.IsPrescribe IsIssue, IsUrgent, fit.Typename, IFNULL(im.IsOutSource, 0) IsOutSource, '' DoctorID, 1 Quantity, cr.ConfigID, fit.Type_id,  ");
        sb.Append(" IFNULL(fit.ItemCode,'')ItemCode, fit.`IsAdvance` `isadvance`, fit.`SubCategoryID`, ( CASE WHEN cr.ConfigID = 3 THEN 'LAB' WHEN cr.ConfigID IN (25) THEN 'PRO' WHEN cr.ConfigID IN (7) THEN 'BB'  ");
        sb.Append(" WHEN cr.ConfigID IN (20, 6) THEN 'OTH' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN 'OPD-BILLING' END ) LabType, ( CASE WHEN cr.ConfigID = 3 THEN '3' WHEN cr.ConfigID IN (25) THEN '4'  ");
        sb.Append(" WHEN cr.ConfigID IN (7) THEN '6' WHEN cr.ConfigID IN (20, 6) THEN '5' WHEN cr.ConfigID IN (3, 25, 20, 6) THEN '16' END ) TnxType, (SELECT IF(TYPE = 'R', TYPE, 'N')  FROM Investigation_master WHERE Investigation_ID = fit.Type_ID) Sample  ");
        sb.Append(" FROM app_InvestigationBooking pt  ");
        sb.Append(" INNER JOIN f_itemmaster fit ON pt.ItemID = fit.ItemID  ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=fit.Type_ID ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = fit.SubCategoryID  ");
        sb.Append(" INNER JOIN f_configrelation cr ON cr.categoryid = sm.categoryid   ");
        sb.Append(" WHERE pt.IsPrescribe=0 AND pt.IsCancel=0 AND pt.id IN (" + BookingIds + ") GROUP BY pt.ID ORDER BY fit.ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetEthenicGroup()
    {
        var dt = StockReports.GetDataTable("SELECT em.EthenicGroup,em.ID FROM ethenicGroup_master em ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string GetLanguage()
    {
        var dt = StockReports.GetDataTable("SELECT l.ID,l.Language FROM language_master l ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetFacialStatus()
    {
        var dt = StockReports.GetDataTable("SELECT f.ID,f.FacialStatus FROM facialStatus_master f");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string GetRace()
    {
        var dt = StockReports.GetDataTable("SELECT f.ID,f.Race FROM race_master f");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetEmployment()
    {
        var dt = StockReports.GetDataTable("SELECT f.ID,f.Employment FROM employment_master f");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetLastTwoDaysOPDTransaction()
    {
        var dt = StockReports.GetDataTable("CALL `GetOPDLastDay_Lab_Medicine_Transaction`(1,'MR/18/000098')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string AdvanceRoomBookDetail(string PatientID)
    {
        string sql = "SELECT ab.ID,ab.Remarks,ab.PatientID,ab.IPDCaseTypeID,DATE_FORMAT(ab.BookingDate,'%d-%b-%Y')BookingDate,ab.RoomID,ictm.Name RoomType,(SELECT CONCAT(RM.Name,'-',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) FROM room_master rm WHERE rm.RoomID=AB.RoomID)RoomName FROM advance_room_booking ab INNER JOIN ipd_case_type_master ictm ON ictm.IPDCaseTypeID=ab.IPDCaseTypeID WHERE PatientID='" + PatientID + "' AND IsCancel=0 AND BookingDate>=CURDATE() LIMIT 1 ";//
        var dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }




    [WebMethod(EnableSession = true)]
    public string CreateTypeOfReference(string typeOfReference)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            var isAlreadyExits = Util.GetInt(excuteCMD.ExecuteScalar("select count(*) from typeofreference_master where TypeOfReference=@typeOfReference", new
            {
                typeOfReference = typeOfReference
            }));

            if (isAlreadyExits > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Aleady Exits." });


            string sqlCmd = "INSERT INTO typeofreference_master (TypeOfReference,CreateBy) VALUES (@typeOfReference,@userID)";
            excuteCMD.DML(sqlCmd, CommandType.Text, new
            {
                typeOfReference = typeOfReference,
                userID = HttpContext.Current.Session["ID"].ToString()
            });

            LoadCacheQuery.DropCentreWiseCache();//
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
    }


    [WebMethod]
    public string GetTypeOfReference()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,TypeOfReference from  typeofreference_master WHERE isactive=1"));

    }


    [WebMethod(EnableSession = true)]
    public string CreateAdvanceReason(string advanceReason)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            var isAlreadyExits = Util.GetInt(excuteCMD.ExecuteScalar("select count(*) from Advance_Reason where Reason=@advanceReason", new
            {
                advanceReason = advanceReason
            }));

            if (isAlreadyExits > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Aleady Exits." });


            string sqlCmd = "INSERT INTO Advance_Reason (Reason,CreateBy) VALUES (@advanceReason,@userID)";
            excuteCMD.DML(sqlCmd, CommandType.Text, new
            {
                advanceReason = advanceReason,
                userID = HttpContext.Current.Session["ID"].ToString()
            });


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
    }


    [WebMethod]
    public string GetAdvanceReason()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Reason from  Advance_Reason WHERE isactive=1"));
    }




    [WebMethod]
    public string GetPanelDocument(string panelID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable("SELECT pd.DocumentID,pd.Document FROM  f_paneldocumentMaster pd INNER JOIN f_paneldocumentdetail pdd ON pd.DocumentID=pdd.DocumentID WHERE pd.IsActive=1  AND pdd.PanelID=@panelID", CommandType.Text, new { panelID = panelID });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string getUserRights()
    {

        DataTable dt = StockReports.GetDataTable(" SELECT CanEditEMGBilling,CanRejectEMGBilling,CanViewRatesEMGBilling,CanReleaseEMGPatient,CanCloseEMGBilling,CanEditCloseEMGBilling FROM userauthorization WHERE RoleId='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND EmpId='" + HttpContext.Current.Session["ID"].ToString() + "' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            dt = StockReports.GetDataTable(" SELECT 0 CanEditEMGBilling,0 CanRejectEMGBilling,0 CanViewRatesEMGBilling,0 CanReleaseEMGPatient,0 CanCloseEMGBilling, 0 CanEditCloseEMGBilling  ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindAgeingBuckets(string bucketType, string AgeingWho)
    {
        DataTable dt = StockReports.GetDataTable("SELECT a.ID,a.AgeingWho,a.SequenceNo,a.`Type`,a.`FromLimit`,a.`ToLimit` FROM ageing_bucket a WHERE a.`IsActive`=1 and a.Type='" + bucketType + "' and a.AgeingWho='" + AgeingWho + "'");
        if (dt.Rows.Count == 0 || dt == null)
        {
            DataRow dr = dt.NewRow();

            dr["AgeingWho"] = AgeingWho;
            dr["Type"] = bucketType;
            dr["SequenceNo"] = 1;
            dr["FromLimit"] = 0;
            dr["ToLimit"] = 0;
            dr["ID"] = 0;

            dt.Rows.Add(dr);
            dt.AcceptChanges();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string EmpIdsearch(string employeeID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT COUNT(*)Emp,IFNULL(em.Name,'')NAME FROM employee_master em WHERE em.RegNo='" + employeeID + "' AND em.IsActive=1 ;");
            if (Util.GetInt(dt.Rows[0]["Emp"]) != 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", message = " Your dependent Name: " + dt.Rows[0]["NAME"] });
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You enter a wrong employeeid", message = "" });
        }


        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You enter a wrong employeeid", message = "" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string saveAgeingBuckets(System.Collections.Generic.List<AgeingBuckets> AgeingBuckets)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < AgeingBuckets.Count; i++)
            {
                var item = AgeingBuckets[i];
                item.CreatedBy = HttpContext.Current.Session["ID"].ToString();

                if (i == 0)
                    excuteCMD.DML(tnx, "UPDATE ageing_bucket SET IsActive=0,UpdatedBy=@CreatedBy,Updateddatetime=now() WHERE IsActive=1 AND Type=@Type and AgeingWho=@AgeingWho", CommandType.Text, item);

                var sqlCmd = new StringBuilder("INSERT INTO ageing_bucket(FromLimit,ToLimit,`Type`,SequenceNo,AgeingWho,CreatedBy,CreateddateTime) VALUES(@FromLimit, @ToLimit, @Type, @SequenceNo, @AgeingWho, @CreatedBy, now())");

                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class AgeingBuckets
    {
        public string AgeingWho { get; set; }
        public string Type { get; set; }
        public int SequenceNo { get; set; }
        public int FromLimit { get; set; }
        public int ToLimit { get; set; }
        public string CreatedBy { get; set; }
    }
    [WebMethod]
    public string checkMemberShipCardPackageValidity(string itemID, string cardNo, string patientID)
    {
        if (string.IsNullOrEmpty(cardNo)) {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
        }

        string str = string.Empty;
        str = "SELECT Count(*)" +
                 " FROM Patient_master pm INNER JOIN membershipcard mc ON mc.`CardNo`=pm.`MemberShip`" +
                 " INNER JOIN membership_discount_opdpackage mdo ON mdo.`CardId`=mc.`MembershipCardID` " +
                 " WHERE pm.`MemberShip`='" + cardNo + "' AND mdo.`ItemId`='" + itemID + "' AND  TIMESTAMPDIFF(DAY, pm.`AsOnDate`,CURRENT_DATE) < mdo.`validityDays` ";
        int Days = Util.GetInt(StockReports.ExecuteScalar(str));
        if (Days > 0)
        {
            str = "SELECT Count(*) FROM f_ledgertnxdetail ltd " +
                  " INNER JOIN `f_ledgertransaction` lt ON lt.`TransactionID`=ltd.`TransactionID` " +
                  " WHERE lt.`PatientID`='" + patientID + "' AND ltd.`ItemID`='" + itemID + "' ";
            int IsAvail = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsAvail == 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status=true});
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient has already avail this Package", isAvail = 2 });
        }
        else {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This Package Membership Validity has been Expired", isAvail = 1});
        }
    }
    [WebMethod]
    public string BindModality(string SubcategoryID,string CentreID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("Select ID, Name from Modality_Master where SubcategoryID = '" + SubcategoryID + "' and CentreID= " + CentreID + " and IsActive=1 order by Name"));
    }
    [WebMethod]
    public string BindAllCentre()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE IsActive=1 ORDER BY CentreName"));
    }

    [WebMethod(EnableSession = true)]
    public string BindOPDFilterTypeUserWise()
    {
        string filterType = string.Empty;
        int totalAuthorizationCount = 0;
        
        DataTable dtUserAuthorization = StockReports.GetDataTable("SELECT * FROM userAuthorization WHERE RoleId=" + Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) + " and  EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
        if (dtUserAuthorization != null && dtUserAuthorization.Rows.Count > 0)
        {


            // IsCanLab,IsCanRadio,IsCanPro,IsCanCon,IsCanPack,IsCanOther 9,10,2,4,11,3

            if (Util.GetInt(dtUserAuthorization.Rows[0]["IsCanLab"].ToString()) == 1)
            {
                totalAuthorizationCount = totalAuthorizationCount + 1;
                if (filterType == string.Empty)
                    filterType = "9";
                else
                    filterType = filterType + "," + 9;
            }
            if (Util.GetInt(dtUserAuthorization.Rows[0]["IsCanRadio"].ToString()) == 1)
            {
                totalAuthorizationCount = totalAuthorizationCount + 1;
                if (filterType == string.Empty)
                    filterType = "10";
                else
                    filterType = filterType + "," + 10;
            }
            if (Util.GetInt(dtUserAuthorization.Rows[0]["IsCanPro"].ToString()) == 1)
            {
                totalAuthorizationCount = totalAuthorizationCount + 1;
                if (filterType == string.Empty)
                    filterType = "2";
                else
                    filterType = filterType + "," + 2;
            }
            if (Util.GetInt(dtUserAuthorization.Rows[0]["IsCanCon"].ToString()) == 1)
            {
                totalAuthorizationCount = totalAuthorizationCount + 1;
                if (filterType == string.Empty)
                    filterType = "4";
                else
                    filterType = filterType + "," + 4;
            }
            if (Util.GetInt(dtUserAuthorization.Rows[0]["IsCanPack"].ToString()) == 1)
            {
                totalAuthorizationCount = totalAuthorizationCount + 1;
                if (filterType == string.Empty)
                    filterType = "11";
                else
                    filterType = filterType + "," + 11;
            }
            if (Util.GetInt(dtUserAuthorization.Rows[0]["IsCanOther"].ToString()) == 1)
            {
                totalAuthorizationCount = totalAuthorizationCount + 1;
                if (filterType == string.Empty)
                    filterType = "3";
                else
                    filterType = filterType + "," + 3;
            }
        }

        if (totalAuthorizationCount > 1)
        {
            filterType = filterType + "," + 100;
        }
        
        if (filterType == string.Empty)
            filterType = "10000";

        DataTable dtFilterType = StockReports.GetDataTable("SELECT m.`TypeID`,m.`TypeName` FROM master_FilterTypeConfiguration m WHERE m.`IsActive`=1 and m.TypeID IN(" + filterType + ") ORDER BY Priority ASC ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(dtFilterType);


    }

    [WebMethod]
    public string bindMedicineDoseType()
    {
        string[] medicineDoseType = AllGlobalFunction.MedicineDoseType;
        return Newtonsoft.Json.JsonConvert.SerializeObject(medicineDoseType);
    }
    
    [WebMethod(EnableSession = true)]
    public string bindPanelRoleWisePanelGroupWise(int Type)
    {
        DataTable dtPanel = All_LoadData.loadPanelRoleWisePanelGroupWise(Type);// LoadCacheQuery.loadIPDPanel(HttpContext.Current.Session["CentreID"].ToString());
      //  if (dtPanel.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
       // else
       //     return "";
    }

    

    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string CentreWiseCache()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(LoadCacheQuery.CentreWiseCache());
    }
    [WebMethod(EnableSession = true)]
    public string CentreWisePanelControlCache()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(LoadCacheQuery.CentreWisePanelControlCache());
    }

    [WebMethod(EnableSession = true)]
    public string RoleWiseOPDServiceBookingControls()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(LoadCacheQuery.RoleWiseOPDServiceBookingControls());
    }
    [WebMethod(EnableSession = true)]
    public string getGSTTypeOnCentreBasis(int CustomerStateID)
    {
        int loginCentreID= Util.GetInt(HttpContext.Current.Session["CentreID"]);
        string sqlQuery = "SELECT GetSaleGSTType(" + loginCentreID + "," + CustomerStateID + ")";
        return Util.GetString(StockReports.ExecuteScalar(sqlQuery));
    }
    [WebMethod(EnableSession = true)]

    public string BindPatientMultiPanelDetails(string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  PolicyNo,if(PolicyExpiry='0001-01-01','',PolicyExpiry)PolicyExpiry,fpm.Company_Name AS PPanelName,ppd.Panel_ID AS PPanelID,fppm.Company_Name AS PParentPanel,fppm.PanelID AS  PParentPanelId ");
        sb.Append(" ,IFNULL(fcpm.Company_Name,'') AS PCorporateName,IFNULL(fcpm.PanelID,'0')  PCorporateID ");
        sb.Append(" ,fpm.PanelGroupID AS PPanelgroupID,fpm.PanelGroup AS PPanelGroup,ppd.PolicyCardNo AS PPolicyNo,ppd.PolicyCardNo AS PCardNo,ppd.PanelCardName AS PCardHolderName ");
        sb.Append(" ,if(ppd.PolicyExpiry='0001-01-01','',Date_Format(PolicyExpiry,'%d-%b-%y')) AS PExpiryDate,ppd.PolciyCardHolderRelation AS PCardHolderRelation,ppd.ApprovalAmount AS PApprovalAmount, ppd.ApprovalRemarks AS PApprovalRemarks,IsDefaultPanel ");
        sb.Append(" FROM patient_policy_detail ppd  ");
        sb.Append(" INNER JOIN f_panel_master fpm ON ppd.Panel_ID=fpm.PanelID ");
        sb.Append(" INNER JOIN f_panel_master fppm ON fppm.PanelID=ppd.ParentPanelID ");
        sb.Append(" LEFT JOIN f_panel_master fcpm ON fcpm.PanelID=ppd.PanelCroporateID WHERE ppd.Patient_ID='"+PatientID+"' and ppd.isactive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else {

            sb.Clear();
            sb.Append(" SELECT  '' PolicyNo,'' PolicyExpiry,fpm.Company_Name AS PPanelName,pm.PanelID AS PPanelID ");
            sb.Append(" ,fppm.Company_Name AS PParentPanel,fppm.PanelID AS  PParentPanelId  ");
            sb.Append(" ,IFNULL(fcpm.Company_Name,'') AS PCorporateName,IFNULL(fcpm.PanelID,'0')  PCorporateID  ");
            sb.Append(" ,fpm.PanelGroupID AS PPanelgroupID,fpm.PanelGroup AS PPanelGroup,''  PPolicyNo,''  PCardNo,''  PCardHolderName  ");
            sb.Append(" ,'' PExpiryDate,'' PCardHolderRelation,'' PApprovalAmount, '' PApprovalRemarks,'1' IsDefaultPanel  ");
            sb.Append(" FROM f_panel_master fpm  ");
            sb.Append(" INNER JOIN patient_master pm ON fpm.PanelID=pm.PanelID ");
            sb.Append(" INNER JOIN f_panel_master fppm ON fppm.PanelID=fpm.ReferenceCode  ");
            sb.Append(" LEFT JOIN f_panel_master fcpm ON fcpm.PanelID=fpm.PanelID AND fcpm.PanelGroup='CORPORATES'  WHERE pm.PatientID='"+PatientID+"'  ");
            dt.Clear();
             dt = StockReports.GetDataTable(sb.ToString());
               return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        
        
         
    }

    [WebMethod]
    public string BindPrequestDeparmtnet()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT id,NAME FROM type_master WHERE TYPE='Doctor-Department' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string GetStateByCountryID(int countryID)
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append("SELECT StateID,sm.StateName,IF(sm.IsActive=1,'Yes','No')Active,CountryID FROM master_State sm WHERE CountryID='" + countryID + "'");
        DataTable dt = StockReports.GetDataTable(sb1.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string GetDistrictByCountryAndStateID(int countryID, int StateID)
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append("SELECT dm.`DistrictID`,dm.StateID,dm.`District`,IF(dm.`IsActive`=1,'Yes','No')Active,dm.CountryID FROM Master_District dm WHERE StateID='" + StateID + "' AND CountryID='" + countryID + "'");

        DataTable dt = StockReports.GetDataTable(sb1.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string GetCityByCountryStateDistrictID(int countryID, int StateID, int districtID)
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append("SELECT cm.`City`,cm.`ID`,cm.`districtID`,cm.`stateID`,cm.`Country`,IF(cm.`IsActive`=1,'Yes','No')Active FROM city_master cm WHERE Country='" + countryID + "' AND stateID='" + StateID + "' AND districtID='" + districtID + "'");
        DataTable dt = StockReports.GetDataTable(sb1.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string FamilyNumberSearch(string PatientID, string FName, string LName, string ContactNo, string Address, string FamilyNumber, int PanelID)
    {
        DataTable dt = StockReports.GetDataTable("CALL sp_GetFamilyNumberDetails('" + PatientID.Trim() + "','" + FName + "','" + LName + "','" + ContactNo + "','" + Address + "','" + FamilyNumber + "'," + PanelID + " ) ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public string GetItemIds(string SubCategoryID, string TypeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(im.ItemID,'')ItemID,im.ItemCode,im.SubcategoryID,sb.CategoryID FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=im.SubcategoryID ");
        sb.Append(" WHERE   im.Type_ID='" + TypeId + "' AND im.SubcategoryID='" + SubCategoryID + "' AND sb.CategoryID=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, ItemId = dt.Rows[0]["ItemID"].ToString(), SubcategoryID = dt.Rows[0]["SubcategoryID"].ToString() });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, ItemId = "", SubcategoryID = "" });

        }


    }


    [WebMethod(EnableSession = true)]
    public string IsSmartCardCheck(string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM f_panel_master pm WHERE pm.PanelID='"+PanelID+"' AND pm.IsActive=1 AND pm.IsSmartCard=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsSmartCard = Util.GetInt( dt.Rows[0]["IsSmartCard"].ToString()), IsManual = Util.GetInt( dt.Rows[0]["IsManual"].ToString()) });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, IsSmartCard = 0 , IsManual = 1});

        }


    }

    [WebMethod(EnableSession = true)]
    public string MatchReffNo(string RefNo, string Depositor)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select Depositor PatientID from `f_receipt_paymentdetail` frp ");
        sb.Append(" inner join f_reciept fr on fr.`ReceiptNo`=frp.`ReceiptNo`  ");
        sb.Append(" where frp.`PaymentModeID`=9 and frp.`RefNo`='" + RefNo + "' and fr.Depositor!='" + Depositor + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            string Msg = "The Ref No:" + RefNo + " Already Pay With PatientID:" + dt.Rows[0]["PatientID"].ToString() + " ";
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Msg });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" });

        }


    }

    [WebMethod(EnableSession = true)]
    public string GetItemActualQuantity(string ItemId, string Dose, string Time, string Duration)
    { 
        decimal ActualQuantity = 0;
        decimal FormalDuration = Util.GetDecimal(Duration);
        decimal FormalTime = Util.GetDecimal(Time);

        StringBuilder sb = new StringBuilder("SELECT im.`ItemDose` FROM f_itemmaster im WHERE im.`ItemID`='"+ItemId+"'");
         
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
           
            decimal ActualDose = Util.GetDecimal(dt.Rows[0]["ItemDose"].ToString());
            decimal FormalDose = Util.GetDecimal(Dose);
            
            if (ActualDose>0 && FormalDose!=0)
            { 
                
                ActualQuantity = ((FormalDose / ActualDose) * (FormalDuration * FormalTime));
            }
            else
            {
                ActualQuantity = (FormalDuration * FormalTime);
            }


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, quantity = Math.Ceiling(ActualQuantity) });

        }
        else
        {
            ActualQuantity = (FormalDuration * FormalTime);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, quantity = Math.Ceiling(ActualQuantity) });

        }


    }
}