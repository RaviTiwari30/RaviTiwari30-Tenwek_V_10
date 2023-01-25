<%@ WebService Language="C#" Class="FileSentToMRD" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;

/// <summary>
/// Summary description for FileSentToMRD
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]

[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[ScriptService]
public class FileSentToMRD : System.Web.Services.WebService
{

    public FileSentToMRD()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    
    public string SearchPatient(object SearchData, int IsIgnore)
    {
        
        SearchCateria Searchcateria = new JavaScriptSerializer().ConvertToType<SearchCateria>(SearchData);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pmh.type,pm.PatientID ,pmh.TransactionID,IF(pmh.TYPE='IPD', pmh.TransNo,'')TransNo,CONCAT(pm.Title,' ',pm.PName)Pname,CONCAT(pm.Age,'/',pm.Gender)Age,pm.Mobile,CONCAT(pm.House_No,'',pm.Street_Name,'',pm.City)Address, ");
        sb.Append(" CONCAT(dm.Title,' ',dm.NAME)DoctorName,fpm.Company_Name AS Panel ");
        sb.Append(" FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientId=pm.PatientID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID LEFT JOIN filesendtomrd fsm ON fsm.TransactionId=pmh.TransactionID ");
        sb.Append(" WHERE fsm.FileSentId IS NULL AND Billno<>'' AND pmh.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

        if (Searchcateria.pType != "ALL")
        {
             sb.Append(" and pmh.Type='"+Searchcateria.pType+"' ");
        }
        if (Searchcateria.TransactionId != string.Empty)
        {
            Searchcateria.TransactionId = StockReports.getTransactionIDbyTransNo(Searchcateria.TransactionId.Trim());
            sb.Append("   and pmh.TransactionID='" + Searchcateria.TransactionId + "'  and ucase(pmh.status) <> 'CANCEL' ");
        }
        if (Searchcateria.PatientId != string.Empty && Searchcateria.PatientId != "Select")
        {
            sb.Append("  and pm.PatientID='" + Searchcateria.PatientId + "'");
        }
        if ((Searchcateria.PanelId != "Select") && (Searchcateria.PanelId != null))
        {
            sb.Append(" and pmh.PanelID='" + Searchcateria.PanelId + "'");
        }
        if ((Searchcateria.DoctorId != string.Empty) && (Searchcateria.DoctorId != null && Searchcateria.DoctorId!="0"))
        {
            sb.Append(" and pmh.DoctorID = '" + Searchcateria.DoctorId + "'");
        }
        if (IsIgnore != 1)
        {
            sb.Append("  AND DATE(pmh.BillDate) >= '" + Util.GetDateTime(Searchcateria.FromDate).ToString("yyyy-MM-dd") + "' AND DATE(pmh.BillDate) <= '" + Util.GetDateTime(Searchcateria.Todate).ToString("yyyy-MM-dd") + "'");
        }
        if (Searchcateria.PatientName != string.Empty && Searchcateria.PatientId == string.Empty)
        {
            sb.Append(" and pname like '%" + Searchcateria.PatientName + "%'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string SaveSentFile(object Data)
    {
        // List<PanelWiseDisc> dataItem = new JavaScriptSerializer().ConvertToType<List<PanelWiseDisc>>(item);
        List<SearchCateria> FileRecord = new JavaScriptSerializer().ConvertToType<List<SearchCateria>>(Data);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {

            for (int i = 0; i < FileRecord.Count; i++)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("  insert into  `filesendtomrd` ( `PatientId`, `TransactionId`,`LegderID`,`IsSent`, `SentBy`, `SentDate`,CentreID)");
                sb.Append("values ('" + FileRecord[i].PatientId + "','" + FileRecord[i].TransactionId + "', '" + Util.GetString(HttpContext.Current.Session["DeptLedgerNo"]) + "', '1','" + Util.GetString(HttpContext.Current.Session["ID"]) + "',NOW(),'" + Util.GetInt( HttpContext.Current.Session["CentreID"]) + "')");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
            }
            tranX.Commit();
            tranX.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception e)
        {
            tranX.Rollback();
            tranX.Dispose();
            con.Close();
            con.Dispose();
            return "0";
        }

    }
    [WebMethod]
    public string MRDRequisitionSearch(object SearchData, string AdmittedDate, string DischargeDate, int IsIgnore)
    {
        SearchCateria Searchcateria = new JavaScriptSerializer().ConvertToType<SearchCateria>(SearchData);
       // int centreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  pmh.type,pmh.`TransactionID` AS Transaction_ID,IF(pmh.TYPE='IPD', pmh.TransNo,'')TransNo, pmh.`PatientID` Patient_ID, CONCAT(pm.`Title`,' ',pm.`PName`)NAME,CONCAT(pm.`Age`,'/',pm.`Gender`)AgeSex,");
        sb.Append(" pmh.`PanelID`,mfm.`FileID`,CONCAT(dm.`Title`,' ',dm.`Name`)Doctor,IFNULL(mfm.IsIssued,'0')IsIssued,IFNULL(mfm.HardCopyIssue,'0')HardCopyIssue, ");
        sb.Append(" IFNULL(mfr.HardCopy,'0')HardCopy,IFNULL(mfr.SoftCopy,'0')SoftCopy ,IF(pmh.DateOfAdmit='0001-01-01','',DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%y'))AdmissionDateTime,IF(pmh.DateOfDischarge='0001-01-01','' ,DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%y'))DischargeDateTime,DATE_FORMAT(mfm.`EntDate`,'%d-%b-%y')FileEntryDateTime,mfd.UploadStatus");
        sb.Append(" ,mfr.`AveragereturnDay`AS ReturnDay,mfr.`AverageReturnHour` AS ReturnHours , fpm.Company_Name");
        sb.Append(" FROM mrd_file_master mfm ");
        sb.Append(" INNER JOIN mrd_file_detail mfd ON mfd.`FileID`=mfm.`FileID` ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=mfm.`TransactionID` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID  ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
        sb.Append(" LEFT JOIN mrd_fileRequisition mfr ON mfr.FileID=mfm.FileID  ");
        if (Searchcateria.FileType == 1)
        {
            sb.Append(" LEFT JOIN mrd_filereturn mfrr ON mfrr.FileID=mfm.FileID  And ReturnToMrd=0");
        }
        sb.Append(" WHERE  pmh.MRD_IsFile=1");
        if (Searchcateria.pType != "ALL")
        {
            sb.Append(" and pmh.Type='" + Searchcateria.pType + "' ");
        }
        
        if (Searchcateria.FileType == 1)
        {
            sb.Append(" AND mfm.HardCopyIssue=1 AND ( mfrr.MRDReturnID IS NULL  OR mfrr.ReturnIsApproved=2 ) ");
        }
        if (Searchcateria.PatientId != string.Empty)
        {
            sb.Append(" AND pmh.`PatientID`='" + Searchcateria.PatientId + "' ");
        }
        if (Searchcateria.TransactionId != string.Empty)
        {
            Searchcateria.TransactionId = StockReports.getTransactionIDbyTransNo(Searchcateria.TransactionId.Trim() );

            sb.Append(" AND pmh.`TransactionID`='" + Searchcateria.TransactionId + "' ");
        }
        if (Searchcateria.PatientName != string.Empty)
        {
            sb.Append(" AND pm.`PName` like '%" + Searchcateria.PatientName + "%' ");
        }
        if ((Searchcateria.DoctorId != "0") && (Searchcateria.DoctorId != null))
        {
            sb.Append(" AND  pmh.`DoctorID`='" + Searchcateria.DoctorId + "'");
        }
        if (Searchcateria.DischargeType != string.Empty)
        {
            // sb.Append(" AND  ");
        }
        if ((Searchcateria.parentPanelId != string.Empty) && (Searchcateria.parentPanelId != null))
        {
            sb.Append(" AND pmh.`PanelID`='" + Searchcateria.parentPanelId + "' ");
        }
        if ((Searchcateria.PanelId != string.Empty) && (Searchcateria.PanelId != null ) && (Searchcateria.PanelId !="Select") )
        {
            sb.Append(" AND  pmh.`PanelID`='" + Searchcateria.PanelId + "' ");
        }
        if (IsIgnore != 1)
        {
            if (Searchcateria.FromDate != string.Empty && Searchcateria.FromDate != null && Searchcateria.Todate != string.Empty && Searchcateria.Todate != null)
            {
                sb.Append(" AND  Date(mfm.`EntDate`)>='" + Util.GetDateTime(Searchcateria.FromDate).ToString("yyyy-MM-dd") + "' AND Date(mfm.`EntDate`)<='" + Util.GetDateTime(Searchcateria.Todate).ToString("yyyy-MM-dd") + "'");
            }
        }
        if (AdmittedDate != string.Empty)
        {
            sb.Append(" And Date(mfm.`AdmissionDateTime`)='" + Util.GetDateTime(AdmittedDate).ToString("yyyy-MM-dd") + "'");
        }
        if (DischargeDate != string.Empty)
        {
            sb.Append(" And Date(mfm.`DischargeDateTime`)='" + Util.GetDateTime(DischargeDate).ToString("yyyy-MM-dd") + "'");
        }
        sb.Append(" GROUP BY mfm.`FileID`");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return JsonConvert.SerializeObject(dt);
        else
            return "";
    }

      [WebMethod(EnableSession = true)]
    public int VaidateMRDFileRequest(string IPDNO)
    {

        string SqlQuery = "SELECT COUNT(*) FROM mrd_filerequisition m WHERE m.`RequestedRoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND m.`TransactionID`='" + IPDNO + "' AND m.`IsActive`=1 AND m.`IsApproved`=0 AND m.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "";
        int IsAlreadyRequested = Util.GetInt(StockReports.ExecuteScalar(SqlQuery));
        return IsAlreadyRequested;
      
      }
    
    [WebMethod(EnableSession = true)]
    public string SaveMRDRequisition(string MRNo, string IPDNO, string MRDFileID, string HardCopy, string SoftCopy, string ReturnDays, string ReturnHours, string Remarks)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO mrd_filerequisition (PatientID,TransactionID,FileID,HardCopy,SoftCopy,RequestedRoleID,RequestedBy,RequestedIPAddress,AverageReturnDay,AverageReturnHour,Remarks,CentreID) ");
            sb.Append("VALUES ('" + MRNo.Trim() + "','" + IPDNO.Trim() + "','" + MRDFileID.Trim() + "','" + HardCopy.Trim() + "','" + SoftCopy.Trim() + "','" + HttpContext.Current.Session["RoleID"].ToString() + "', ");
            sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "','" + ReturnDays.Trim() + "','" + ReturnHours.Trim() + "','" + Remarks.Replace("&", "@") + "',"+ Util.GetInt( HttpContext.Current.Session["CentreID"])+" )");
            if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString()) == 0)
            {
                tranX.Rollback();
                con.Close();
                con.Dispose();
                return "0";
            }
            string ID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT MAX(MRDRequisitionID) FROM mrd_filerequisition "));
            //string EmpID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT EmployeeId FROM `mrd_requestapprovel` WHERE RoleId='" + Util.GetString(HttpContext.Current.Session["RoleID"].ToString()) + "';"));
            //Notification_Insert.notificationInsert(36, ID, tranX, "", "", Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), DateTime.Now.ToString("yyyy-MM-dd"), EmpID);// mrd roleId=181 (it will check by logic)
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
    [WebMethod(EnableSession = true)]
    public string SaveMRDReturnFile(string MRNo, string IPDNO, string MRDFileID, string HardCopy, string ReturnDays, string ReturnHours, string Remarks)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO mrd_fileReturn (PatientID,TransactionID,FileID,HardCopy,ReturnRequestedRoleID,ReturnRequestedBy,ReturnRequestedIPAddress,ReturnAveragereturnDay,ReturnAverageReturnHour,ReturnRemarks,CentreID) ");
            sb.Append("VALUES ('" + MRNo.Trim() + "','" + IPDNO.Trim() + "','" + MRDFileID.Trim() + "','" + HardCopy.Trim() + "','" + HttpContext.Current.Session["RoleID"].ToString() + "', ");
            sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "','" + ReturnDays.Trim() + "','" + ReturnHours.Trim() + "','" + Remarks.Replace("&", "@") + "',"+HttpContext.Current.Session["CentreID"]+" )");
            if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString()) == 0)
            {
                tranX.Rollback();
                con.Close();
                con.Dispose();
                return "0";
            }
            string ID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT MAX(MRDReturnID) FROM mrd_fileReturn "));
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

    [WebMethod(EnableSession = true)]

    public string MRDSentfilestatus(object SearchData, int IsIgnore)
    {

        SearchCateria Searchcateria = new JavaScriptSerializer().ConvertToType<SearchCateria>(SearchData);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pmh.MRD_IsFile, pmh.type,pm.PatientID ,pmh.TransactionID,IF(pmh.TYPE='IPD', pmh.TransNo,'')TransNo,CONCAT(pm.Title,' ',pm.PName)Pname,CONCAT(pm.Age,'/',pm.Gender)Age,pm.Mobile,CONCAT(pm.House_No,'',pm.Street_Name,'',pm.City)Address, ");
        sb.Append(" CONCAT(dm.Title,' ',dm.NAME)DoctorName,fpm.Company_Name AS Panel ");
        sb.Append(" FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientId=pm.PatientID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID INNER JOIN filesendtomrd fsm ON fsm.TransactionId=pmh.TransactionID ");
        sb.Append(" WHERE Billno<>'' AND pmh.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

        if (Searchcateria.pType != "ALL")
        {
            sb.Append(" and pmh.Type='" + Searchcateria.pType + "' ");
        }
        if (Searchcateria.TransactionId != string.Empty)
        {
            Searchcateria.TransactionId = StockReports.getTransactionIDbyTransNo(Searchcateria.TransactionId.Trim());
            sb.Append("   Where pmh.TransactionID='" + Searchcateria.TransactionId + "'  and ucase(pmh.status) <> 'CANCEL' ");
        }
        if (Searchcateria.PatientId != string.Empty && Searchcateria.PatientId != "Select")
        {
            sb.Append("  and pm.PatientID='" + Searchcateria.PatientId + "'");
        }
        if ((Searchcateria.PanelId != "Select") && (Searchcateria.PanelId != null))
        {
            sb.Append(" and pmh.PanelID='" + Searchcateria.PanelId + "'");
        }
        if ((Searchcateria.DoctorId != string.Empty) && (Searchcateria.DoctorId != null && Searchcateria.DoctorId != "0"))
        {
            sb.Append(" and pmh.DoctorID = '" + Searchcateria.DoctorId + "'");
        }
        if (IsIgnore != 1)
        {
            sb.Append("  AND DATE(fsm.SentDate) >= '" + Util.GetDateTime(Searchcateria.FromDate).ToString("yyyy-MM-dd") + "' AND DATE(fsm.SentDate) <= '" + Util.GetDateTime(Searchcateria.Todate).ToString("yyyy-MM-dd") + "'");
        }
        if (Searchcateria.PatientName != string.Empty && Searchcateria.PatientId == string.Empty)
        {
            sb.Append(" and pname like '%" + Searchcateria.PatientName + "%'");
        }
        if ((Searchcateria.FileStatus != "2") && (Searchcateria.FileStatus != null))
        {
            sb.Append(" and pmh.MRD_IsFile='" + Searchcateria.FileStatus + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}
public class SearchCateria
{
   

    public string AgeFrom { get; set; }
    public string AgeTo { get; set; }
    public string DeptId { get; set; }
    public string DischargeType { get; set; }
    public string DoctorId { get; set; }
    public string FromDate { get; set; }
    public string PanelId { get; set; }
    public string parentPanelId { get; set; }
    public string PatientId { get; set; }
    public string PatientName { get; set; }
    public string RoomType { get; set; }
    public string Todate { get; set; }
    public string TransactionId { get; set; }
    public int FileType { get; set; }
    public string pType { get; set; }
    public string FileStatus { get; set; }
}
