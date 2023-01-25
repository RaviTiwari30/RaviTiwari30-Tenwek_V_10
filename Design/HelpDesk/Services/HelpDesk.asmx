<%@ WebService Language="C#" Class="HelpDesk" %>

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
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class HelpDesk : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(Description = "Bind Help Desk Error Type")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string errorTypeSearch()
    {
        DataTable errorType = StockReports.GetDataTable(" SELECT et.EmployeeID,Error_ID,Error_type,RoleName,IF(et.IsActive=1,'Active','InActive')IsActive,rm.ID RoleID,Ifnull(CONCAT(em.Title,em.Name),'')EmployeeName FROM ticket_error_type et INNER JOIN f_rolemaster rm ON et.RoleID=rm.ID LEFT JOIN employee_master em ON em.EmployeeID=et.EmployeeID WHERE rm.Active=1 ");
        if (errorType.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(errorType);
        else
            return "";
    }
    [WebMethod(Description = "Bind Help Desk Error Type")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string sectionSearch()
    {
        DataTable errorType = StockReports.GetDataTable(" SELECT sm.ID,sm.Section_Name,IF(sm.IsActive=1,'Active','InActive')IsActive,Ifnull(CONCAT(em.Title,' ',em.Name),'')EntryBy FROM Section_Master sm  INNER JOIN employee_master em ON em.EmployeeID=sm.EntryBy  ");
        if (errorType.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(errorType);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindErrorType(string Department)
    {
        DataTable errorType = StockReports.GetDataTable("SELECT RoleID,error_id,error_type FROM  ticket_error_type WHERE  RoleID='" + Department + "'  order by error_type");
        return Newtonsoft.Json.JsonConvert.SerializeObject(errorType);
    }
    [WebMethod(Description = "Save Help Desk Error Type", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveSection(string Section_Name,  string Status)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Section_Master WHERE Section_Name='" + Section_Name + "'  "));
            if (count == 0)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO Section_Master (Section_Name,EntryBy,IsActive) VALUE('" + Section_Name + "','" + HttpContext.Current.Session["ID"].ToString() + "','"+Status+"')");
                tranX.Commit();
                result = "1";
            }
            else
            {
                result = "2";
            }
            return result;
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return result;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    
    [WebMethod(Description = "Save Help Desk Error Type", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveErrorType(string ErrorType, string Department, string Status, string EmployeeID)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ticket_error_type WHERE Error_Type='" + ErrorType + "' AND RoleID='" + Department + "' AND EmployeeID='" + EmployeeID + "' "));
            if (count == 0)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO ticket_error_type (Error_type,RoleID,UserID,EmployeeID)VALUE('" + ErrorType + "','" + Department + "','" + HttpContext.Current.Session["ID"].ToString() + "','')");
                tranX.Commit();
                result = "1";
            }
            else
            {
                result = "2";
            }
            return result;
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return result;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(Description = "Update Help Desk Error Type", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateSection(string Section_Name, string Status, string RowID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE Section_Master SET Section_Name='" + Section_Name + "',IsActive='" + Status + "' where ID=" + RowID + "");
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
    
    
    [WebMethod(Description = "Update Help Desk Error Type", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateErrorType(string ErrorType, string Department, string Status, string errorID, string EmployeeID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_error_type SET Error_type='" + ErrorType + "',IsActive='" + Status + "',RoleID=" + Department + ",EmployeeID='" + EmployeeID + "' where Error_ID=" + errorID + "");
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
    [WebMethod(Description = "PreMade Help Desk Bind")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string premadeSearch()
    {
        DataTable dtPreMade = StockReports.GetDataTable(" SELECT ID,Title,Description,IF(STATUS=1,'Active','InActive')Status,DATE_FORMAT(LAST_UPDATE,'%d-%b-%Y %h:%i %p')AS Last_Update from ticket_premade_reply_master ");
        if (dtPreMade.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPreMade);
        else
            return "";
    }
    [WebMethod(Description = "Save Help Desk PreMade Replay", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string savePreMade(string Title, string Status, string Description)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ticket_premade_reply_master WHERE Title='" + Title + "' "));
            if (count == 0)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " INSERT INTO ticket_premade_reply_master(TITLE,STATUS,Description,LAST_UPDATE )VALUE ('" + Title + "','" + Status + "','" + Description + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "') ");
                tranX.Commit();
                return "1";
            }
            else
            {
                return "2";
            }
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

    [WebMethod(Description = "Update Help Desk PreMade Replay", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updatePreMade(string Title, string Status, string Description, string PreMadeID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ticket_premade_reply_master WHERE Title='" + Title + "' AND ID!='" + PreMadeID + "' "));
            if (count == 0)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_premade_reply_master SET Title='" + Title + "',STATUS='" + Status + "',Description='" + Description + "',LAST_UPDATE='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where ID=" + PreMadeID + "");
                tranX.Commit();
                return "1";
            }
            else
            {
                return "2";
            }
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

    [WebMethod(Description = "Bind Ticket Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindReport(string department, string priority, string FromDate, string ToDate)
    {
        string Query = "SELECT DATE_FORMAT(DATE,'%d-%b-%Y')DATE,COUNT(*)NewTicket,COUNT(*)-SUM(IF(STATUS=2,1,0))OPEN,SUM(IF(STATUS=2,1,0))Resolve FROM ticket_master WHERE Active=1 and DATE(DATE)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(DATE)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'   ";
        if (department != "ALL")
            Query += " and ErrorDeptID=" + department + "";
        if (priority != "ALL")
            Query += " and Priority='" + priority + "'";

        Query += " GROUP BY DATE(DATE) ";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(Description = "Search Doctor")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string searchDoctor(string Department, string Name, string ContactNo, string Specialization)
    {
        string Query = "Select dm.DoctorID,CONCAT(Title,' ',Name)DName,dm.Degree,dm.Designation Department,dm.Specialization,dg.DocType,dm.Mobile FROM doctor_master dm inner join DoctorGroup dg on dm.DocGroupId=dg.ID  WHERE dm.IsActive=1";
        if (Department != "ALL")
            Query += " and dm.Designation='" + Department + "'";
        if (Name != "")
            Query += " and dm.Name LIKE '" + Name + "%'";
        if (ContactNo != "")
            Query += " and dm.Mobile = '" + ContactNo + "'";
        if (Specialization != "ALL")
            Query += " and dm.Specialization='" + Specialization + "'";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(Description = "Save Help Desk Save Ticket ", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveTicket(string DepartmentFrom, string Floor, string EmpCode, string DepartmentTo, string ErrorType, string ErrorTypeID, string Summary, string Attachment, string Priority, string NoOfPeopleEffected, string StartDate, string StartTime)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query = " INSERT INTO ticket_master(EmployeeID,Description,PeopleEffeced,Priority,ProblemStartTime,Errortype,ErrorTypeID,ErrorDeptID,LastUpdate,RoleID,Department,Floor,PayrollEmpID) VALUES ('" + HttpContext.Current.Session["ID"].ToString() + "','" + Summary + "','" + NoOfPeopleEffected + "','" + Priority + "','" + Util.GetDateTime(StartDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(StartTime).ToString("HH:mm:ss") + "','" + ErrorType + "','" + ErrorTypeID + "','" + DepartmentTo + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + HttpContext.Current.Session["RoleID"].ToString() + "','" + DepartmentFrom + "','" + Floor + "','" + EmpCode + "') ";

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, Query);

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



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string packageDetail(string packageID)
    {
        string str = "SELECT pm.PlabID,inv.Name,inv.Investigation_Id,im.IsActive,inv.ReportType,pm.Name PackageName,DATE_FORMAT(pm.FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(pm.ToDate,'%d-%b-%Y')ToDate  FROM investigation_master inv INNER JOIN f_itemmaster im ON inv.Investigation_Id = im.Type_ID INNER JOIN f_subcategorymaster sc ON ";
        str += "sc.SubCategoryID = im.SubCategoryID INNER JOIN f_configrelation cf ON  cf.CategoryID = sc.CategoryID INNER JOIN package_labdetail pd ON pd.InvestigationID = inv.Investigation_Id INNER JOIN packagelab_master pm ON pm.plabid=pd.PlabID ";
        str += "WHERE cf.ConfigID=3 ";
        if (packageID != "0")
            str += "AND pd.PlabID = '" + packageID + "'";
        str += " order by inv.Name ";


        DataTable package = StockReports.GetDataTable(str);
        if (package.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(package);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string doctorTimingDetail(string doctorID, string Department, string Specialization, string Centre, string Date)
    {
        string str = "SELECT t.* FROM (SELECT cm.CentreID,cm.CentreName,'" + Util.GetDateTime(Date).ToString("dd-MMM-yyyy") + "' AppDate,dm.DoctorID, ";
        str += "CONCAT(dm.Title,' ',dm.Name)DName,dm.Mobile,dh.Day,dh.Day DayValue,ifnull(dh.ShiftName,'Day Shift')ShiftName,DATE_FORMAT(dh.StartTime,'%h:%i %p')StartTime, ";
        str += "dh.StartTime StartTimeValue,DATE_FORMAT(dh.EndTime,'%h:%i %p')EndTime,dt.Name Department,dm.Specialization,dh.Room_No,dh.DocFloor, ";
        str += "ROUND((TIME_TO_SEC(TIMEDIFF(dh.EndTime,dh.StartTime))/60)/IFNULL(dh.DurationforNewPatient,1)) TotalSlots,IFNULL((SELECT COUNT(*)IsBooked FROM   ";
        str += "appointment a WHERE a.DoctorID = dm.DoctorID  AND a.Date = '" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'   AND a.IScancel =0 AND a.Time>=dh.StartTime  ";
        str += "AND a.Time<=dh.EndTime),0)+IFNULL((SELECT COUNT(*)IsBooked FROM app_appointment app WHERE app.DoctorID=dm.DoctorID  ";
        str += "AND app.AppointmentDate='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND app.StartTime>=dh.StartTime AND app.StartTime<=dh.EndTime),0)Booked, ";
        str += "IFNULL((SELECT GROUP_CONCAT(CONCAT(sc.Name,':',ROUND(IFNULL((SELECT rt.Rate FROM f_ratelist rt WHERE rt.ItemID=im.ItemID AND rt.IsCurrent=1 AND rt.PanelID=1   ";
        str += "AND rt.CentreID=cm.CentreID  LIMIT 1),0),4)) ORDER BY sc.DisplayPriority SEPARATOR '<br />') Rate FROM f_itemmaster im  ";
        str += "INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID=sc.CategoryID  ";
        str += "WHERE cf.ConfigID=5 AND im.IsActive=1 AND im.Type_ID=dm.DoctorID ),'Doctor Visit Not Set')Rate  ";
        str += "FROM doctor_master dm  ";
        str += "INNER JOIN f_center_doctor cd ON cd.DoctorID=dm.DoctorID  AND cd.isActive=1   ";
        str += "INNER JOIN center_master cm ON cd.CentreID=cm.CentreID  ";
        str += "INNER JOIN doctor_hospital dh ON cd.DoctorID=dh.DoctorID AND dh.CentreID=cd.CentreID  ";
        str += "INNER JOIN type_master dt ON dt.id=dm.DocDepartmentID   ";

        str += "WHERE dm.DoctorID<>'' ";
        if (doctorID != "0")
            str += " AND dm.DoctorID='" + doctorID + "' ";
        if (Department != "0")
            str += " AND dm.DocDepartmentID='" + Department + "' ";
        if (Specialization != "All")
            str += " AND dm.Specialization='" + Specialization + "' ";
        if (Centre != "0")
            str += " AND cd.CentreID='" + Centre + "' ";

        if (Date != "")
            str += " AND dh.Day= DAYNAME('" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "')";
        str += "  GROUP BY dh.OPD_ID ";
        str += " UNION ALL";
        str += " SELECT cm.CentreID,cm.CentreName,'" + Util.GetDateTime(Date).ToString("dd-MMM-yyyy") + "' AppDate,dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName, ";
        str += " dm.Mobile,CONCAT(DATE_FORMAT(DATE,'%d-%b-%y'),'(',DAYNAME(dh.Date),')')Day,DAYNAME(dh.Date) DayValue,ifnull(dh.ShiftName,'Day Shift')ShiftName, ";
        str += " DATE_FORMAT(dh.StartTime,'%h:%i %p')StartTime,dh.StartTime StartTimeValue, DATE_FORMAT(dh.EndTime,'%h:%i %p')EndTime,dt.Name,dm.Specialization, ";
        str += " dh.Room_No,dh.DocFloor,ROUND((TIME_TO_SEC(TIMEDIFF(dh.EndTime,dh.StartTime))/60)/IFNULL(dh.DurationforNewPatient,1)) TotalSlots, ";
        str += " IFNULL((SELECT COUNT(*)IsBooked FROM  appointment a WHERE a.DoctorID = dm.DoctorID  AND a.Date = '" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'  ";
        str += " AND a.IScancel =0 AND a.Time>=dh.StartTime AND a.Time<=dh.EndTime),0)+IFNULL((SELECT COUNT(*)IsBooked FROM app_appointment app  ";
        str += " WHERE app.DoctorID=dm.DoctorID AND app.AppointmentDate='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND app.StartTime>=dh.StartTime  ";
        str += " AND app.StartTime<=dh.EndTime),0)Booked,IFNULL((SELECT GROUP_CONCAT(CONCAT(sc.Name,':',ROUND(IFNULL((SELECT rt.Rate FROM f_ratelist rt  ";
        str += " WHERE rt.ItemID=im.ItemID AND rt.IsCurrent=1 AND rt.PanelID=1 LIMIT 1),0),4)) ORDER BY sc.DisplayPriority SEPARATOR '<br />') Rate  ";
        str += " FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID=sc.CategoryID  ";
        str += " WHERE cf.ConfigID=5 AND im.IsActive=1 AND im.Type_ID=dm.DoctorID ),'Doctor Visit Not Set')Rate  ";
        str += " FROM doctor_master dm  ";
        str += " INNER JOIN f_center_doctor cd ON cd.DoctorID=dm.DoctorID  AND cd.isActive=1  ";
        str += " INNER JOIN center_master cm ON cd.CentreID=cm.CentreID  ";
        str += " INNER JOIN doctor_timingdatewise dh ON cd.DoctorID=dh.DoctorID   AND dh.CentreID=cd.CentreID ";
        str += " INNER JOIN type_master dt ON dt.id=dm.DocDepartmentID ";
        str += " WHERE dm.DoctorID<>''  ";
        if (doctorID != "0")
            str += " AND dm.DoctorID='" + doctorID + "' ";
        if (Department != "0")
            str += " AND dm.DocDepartmentID='" + Department + "' ";
        if (Specialization != "All")
            str += " AND dm.Specialization='" + Specialization + "' ";
        if (Centre != "0")
            str += " AND cd.CentreID='" + Centre + "' ";

        if (Date != "")
            str += " And dh.Date = '" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ";

        str += "  GROUP BY dh.ID ";

        //Devendra Singh 01-Oct-2018 
        //  str += " order by DName,FIELD(DayValue, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'),StartTimeValue )t ORDER BY t.CentreID ASC ";
        str += " )t ORDER BY t.CentreID,DName,FIELD(DayValue, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'),StartTimeValue ASC  ";

        DataTable detail = StockReports.GetDataTable(str);
        if (detail.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(detail);
        else
            return "";
    }
    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true, BufferResponse = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TicketSave(string DepartmentFrom, string Floor, string EmpCode, string DepartmentTo, string ErrorType, string ErrorTypeID, string Summary, string Attachment, string Priority, string NoOfPeopleEffected, string StartDate, string StartTime, string Extension)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query = " INSERT INTO ticket_master(EmployeeID,Description,PeopleEffeced,Priority,ProblemStartTime,ErrorType,ErrorTypeID,ErrorDeptID,LastUpdate,RoleID,Department,Floor,PayrollEmpID,CreatedBy) " +
                " VALUES ('" + HttpContext.Current.Session["ID"].ToString() + "','" + Summary + "','" + NoOfPeopleEffected + "','" + Priority + "','" + Util.GetDateTime(StartDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(StartTime).ToString("HH:mm:ss") + "','" + ErrorType + "','" + ErrorTypeID + "','" + DepartmentTo + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + HttpContext.Current.Session["RoleID"].ToString() + "','" + DepartmentFrom + "','" + Floor + "','" + EmpCode + "','" + HttpContext.Current.Session["ID"].ToString() + "') ";

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, Query);
            string TicketNo = StockReports.ExecuteScalar("select max(TicketID) from ticket_master");
            string path = HttpContext.Current.Server.MapPath("~/Design/HelpDesk/SupportAttachment");
            bool IsExists = System.IO.Directory.Exists(path);
            if (!IsExists)
            {
                System.IO.Directory.CreateDirectory(path);
            }

            HttpContext context = HttpContext.Current;
            // StreamReader fil = new StreamReader(context.Request.Files[0].InputStream);
            HttpPostedFile fil = context.Request.Files["myFile"];
            int shat = context.Request.Files.Count;
            var file = context.Request.Files[0];
            string Exte = Extension;
            if (Exte != "")
            {
                if (Exte != "pdf" && Exte != "jpg" && Exte != "jpeg" && Exte != "doc" && Exte != "docx" && Exte != "gif")
                {
                    return "0";
                }
            }
            tranX.Commit();

            string fileName;
            if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE")
            {
                string[] files = file.FileName.Split(new char[] { '\\' });
                fileName = files[files.Length - 1];
            }
            else
            {
                fileName = file.FileName;
            }


            string strFileName = fileName;
            string Ext = fileName.Substring(fileName.LastIndexOf("."));
            fileName = Path.Combine(path, fileName);
            Attachment = string.Concat(TicketNo + Ext);
            file.SaveAs(fileName + Attachment);
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

    [WebMethod(Description = "Bind Ticket Search")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ticketSearch(string department, string status, string Priority, string TicketNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tm.Assigned_Engineer,tm.TicketID TicketNo,tm.EmployeeID,tm.ErrorType,tm.Description,tm.PeopleEffeced,tm.Priority, ");
        sb.Append(" DATE_FORMAT(tm.DATE,'%d-%b-%Y %h:%i %p')DATE,DATE_FORMAT(tm.ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartTime,");

        sb.Append("  (SELECT GROUP_CONCAT(CONCAT(' ',rm.`RoleName`,' ( ',tms.`TicketID`,' )')) FROM f_rolemaster rm   ");
        sb.Append(" INNER JOIN ticket_master tms ON rm.`ID`=tms.`ErrorDeptID`   ");
        sb.Append(" WHERE tms.`ForwordAginstTokenNo`=TM.TicketID) ForwordTo,  ");
        sb.Append(" ifnull((SELECT GROUP_CONCAT(tms.`TicketID`) FROM ticket_master tms  WHERE tms.`ForwordAginstTokenNo`=tm.TicketID),'')ForwordedTicketNo ,");

        sb.Append(" DATE_FORMAT(tm.CloseDate,'%d-%b-%Y %h:%i %p')ProblemEndTime,TIMEDIFF(tm.CloseDate,tm.ProblemStartTime)DownTime,");
        sb.Append(" IF(tm.IsReopen=1,'ReOpen',(CASE WHEN tm.STATUS = '0' THEN 'Pending' WHEN tm.STATUS = '1' THEN 'Process' WHEN tm.STATUS = '2' THEN 'Close' WHEN tm.STATUS = '4' THEN 'Assigned'  WHEN tm.STATUS = '5' THEN 'Forworded'  ELSE 'STOP' END)) Status, ");
        sb.Append(" Date_Format(tm.LastUpdate,'%d-%b-%Y')LastUpdate,IFNULL((SELECT GROUP_CONCAT(ReopenReason) FROM `ticket_master_description` WHERE TicketId=TM.TicketID AND isReopen=1 GROUP BY TicketID),'')ReopenReason FROM ticket_master TM WHERE tm.Active=1  ");

        if (department != "Select")
        {
            sb.Append(" and tm.RoleID=" + department + "");
        }

        if (status != "All")
        {
            sb.Append(" and tm.status=" + status + "");
        }

        if (Priority != "All")
        {
            sb.Append(" and tm.Priority='" + Priority + "'");
        }

        if (TicketNo != "")
        {
            sb.Append(" and tm.TicketID=" + TicketNo + "");
        }

        sb.Append(" order by tm.TicketID DESC");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ticketSearchByTr(string department, string status)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT Assigned_Engineer,TicketID TicketNo,EmployeeID,ErrorType,Description,PeopleEffeced,Priority,DATE_FORMAT(DATE,'%d-%b-%Y %h:%i %p')DATE,DATE_FORMAT(ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartTime, ");
        sb.Append("  (SELECT GROUP_CONCAT(CONCAT(' ',rm.`RoleName`,' ( ',tms.`TicketID`,' )')) FROM f_rolemaster rm   ");
        sb.Append(" INNER JOIN ticket_master tms ON rm.`ID`=tms.`ErrorDeptID`   ");
        sb.Append(" WHERE tms.`ForwordAginstTokenNo`=ticket_master.TicketID) ForwordTo,  ");
        sb.Append(" ifnull((SELECT GROUP_CONCAT(tms.`TicketID`) FROM ticket_master tms  WHERE tms.`ForwordAginstTokenNo`=ticket_master.TicketID),'')ForwordedTicketNo ,");

        sb.Append(" DATE_FORMAT(CloseDate,'%d-%b-%Y %h:%i %p')ProblemEndTime,TIMEDIFF(CloseDate,ProblemStartTime)DownTime,(CASE WHEN STATUS = '0' THEN 'Pending' WHEN STATUS = '1' THEN 'Process' WHEN STATUS = '2' THEN 'Close' WHEN STATUS = '3' THEN 'ReOpen' WHEN STATUS = '4' THEN 'Assigned'  WHEN STATUS = '5' THEN 'Forworded'  ELSE 'STOP' END)Status, ");
        sb.Append(" Date_Format(LastUpdate,'%d-%b-%Y')LastUpdate,IFNULL((SELECT GROUP_CONCAT(ReopenReason) FROM `ticket_master_description` WHERE TicketId=ticket_master.TicketID AND isReopen=1 GROUP BY TicketID),'')ReopenReason FROM ticket_master WHERE Active=1");

        if (department != "Select")
        {
            sb.Append(" and RoleID=" + department + "");
        }

        if (status != "")
        {
            sb.Append(" and status=" + status + "");
        }

        sb.Append(" order by TicketID DESC");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindTicketSearch(string department, string Status, string ErrorType)
    {
        StringBuilder query = new StringBuilder();
        query.Append(" SELECT  (SELECT CONCAT(Title,' ',NAME) RequestedBy FROM employee_master emp WHERE emp.EmployeeID=ticket_master.EmployeeID)"+
" RequestedBy, Location,LocationCode,Assigned_Engineer,TicketID TicketNo,EmployeeID,Errortype,Department,Description,PeopleEffeced,Priority,DATE_FORMAT(DATE,'%d-%b-%Y %h:%i %p')DATE,DATE_FORMAT(ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartTime, ");

        query.Append("  (SELECT GROUP_CONCAT(CONCAT(' ',rm.`RoleName`,' ( ',tms.`TicketID`,' )')) FROM f_rolemaster rm   ");
        query.Append(" INNER JOIN ticket_master tms ON rm.`ID`=tms.`ErrorDeptID`   ");
        query.Append(" WHERE tms.`ForwordAginstTokenNo`=ticket_master.TicketID) ForwordTo,  ");
        query.Append(" ifnull((SELECT GROUP_CONCAT(tms.`TicketID`) FROM ticket_master tms  WHERE tms.`ForwordAginstTokenNo`=ticket_master.TicketID),'')ForwordedTicketNo ,");


        query.Append(" DATE_FORMAT(CloseDate,'%d-%b-%Y %h:%i %p')ProblemEndTime,TIMEDIFF(CloseDate,ProblemStartTime)DownTime,(CASE WHEN STATUS = '0' THEN 'Pending' WHEN STATUS = '1' THEN 'Process' WHEN STATUS = '2' THEN 'Close' WHEN STATUS = '3' THEN 'ReOpen'  WHEN STATUS = '4' THEN 'Assigned'  WHEN STATUS = '5' THEN 'Forworded' ELSE 'STOP' END) STATUS, ");
        query.Append(" Date_Format(LastUpdate,'%d-%b-%Y')LastUpdate,IFNULL((SELECT GROUP_CONCAT(ReopenReason) FROM `ticket_master_description` WHERE TicketId=ticket_master.TicketID AND isReopen=1 GROUP BY TicketID),'')ReopenReason FROM ticket_master WHERE Active=1 ");

        if (department != "0")
        {
            query.Append(" and ErrorDeptID='" + department + "' ");
        }

        if (Status != "All")
        {
            query.Append(" and status=" + Status + "");
        }
        else
        {
            query.Append(" and status IN(0,1,2,3,4,5) ");
        }
        if (ErrorType != "0")
        {
            query.Append(" AND TRIM(Errortype)='" + ErrorType.Trim() + "' ");
        }
        query.Append(" order by TicketID DESC ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindTicketSearchByDate(string department, string FrmDate, string ToDate, string Status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Assigned_Engineer,TicketID TicketNo,EmployeeID,Errortype,Department,Description,PeopleEffeced,Priority,");
        sb.Append(" DATE_FORMAT(ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartTime,DATE_FORMAT(CloseDate,'%d-%b-%Y %h:%i %p')ProblemEndTime,");
        sb.Append("  (SELECT GROUP_CONCAT(CONCAT(' ',rm.`RoleName`,' ( ',tms.`TicketID`,' )')) FROM f_rolemaster rm   ");
        sb.Append(" INNER JOIN ticket_master tms ON rm.`ID`=tms.`ErrorDeptID`   ");
        sb.Append(" WHERE tms.`ForwordAginstTokenNo`=tm.TicketID) ForwordTo,  ");

        sb.Append(" ifnull((SELECT GROUP_CONCAT(tms.`TicketID`) FROM ticket_master tms  WHERE tms.`ForwordAginstTokenNo`=tm.TicketID),'')ForwordedTicketNo ,");


        sb.Append(" TIMEDIFF(CloseDate,ProblemStartTime)DownTime,(CASE WHEN STATUS = '0' THEN 'Pending' WHEN STATUS = '1' THEN 'Process' WHEN STATUS = '2' THEN 'Close' WHEN STATUS = '3' THEN 'ReOpen'  WHEN STATUS = '4' THEN 'Assigned'  WHEN STATUS = '5' THEN 'Forworded' ELSE 'STOP' END) STATUS,");
        sb.Append(" Date_Format(LastUpdate,'%d-%b-%Y')LastUpdate,IFNULL((SELECT GROUP_CONCAT(ReopenReason) FROM `ticket_master_description` WHERE TicketId=TM.TicketID AND isReopen=1 GROUP BY TicketID),'')ReopenReason FROM ticket_master TM WHERE Active=1 ");

        if (department != "0")
        {
            sb.Append(" and ErrorDeptID=" + department + " ");
        }

        if (Status == "true")
        {
            sb.Append("   AND Date(Date) >= '" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("   AND Date(Date) <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }
        sb.Append(" order by TicketID desc ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ticketExcelReport(string department, string FrmDate, string ToDate, string Status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT TicketID TicketNo,ErrorType,Description,Department,Priority,DATE,DATE_FORMAT(ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartDateTime,");
        sb.Append(" DATE_FORMAT(CloseDate,'%d-%b-%Y %h:%i %p')ProblemEndDateTime,TIMEDIFF(CloseDate,ProblemStartTime)DownTime,");
        sb.Append(" (CASE WHEN STATUS = '0' THEN 'Pending' WHEN STATUS = '1' THEN 'Process' WHEN STATUS = '2' THEN 'Close' WHEN STATUS = '3' THEN 'ReOpen' ELSE 'STOP' END) Status,Date_Format(LastUpdate,'%d-%b-%Y')LastUpdate, ");
        sb.Append(" IFNULL((SELECT GROUP_CONCAT(ReopenReason) FROM `ticket_master_description` WHERE TicketId=TM.TicketID AND isReopen=1 GROUP BY TicketID),'')ReopenReason FROM ticket_master TM WHERE Active=1 ");

        if (department != "0")
            sb.Append(" and ErrorDeptID=" + department + "");

        if (Status == "true")
        {
            sb.Append("   AND Date(Date) >= '" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("   AND Date(Date) <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }
        sb.Append(" order by TicketID desc");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Ticket Status Report";
            HttpContext.Current.Session["Period"] = "Period From : " + Util.GetDateTime(FrmDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy") + " ";
            return "1";
        }
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateTicket_Master( string TicketId, string CostCentre, string ProjectSupervisor)
    {
        string Query = string.Empty;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string strC = "";




                sb.Append(" UPDATE ticket_master SET CostCentre='" + CostCentre + "',ProjectSupervisor='"+ProjectSupervisor+"' where TicketID='"+TicketId+"' ");

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updatePriority(string statusID, string Priority, string PriorityID, string TicketId, string Decription, string CloseDate, string CloseTime, string status, string AssignedEngineer, string AssignedEngineerID, string ForwordToDepartment,string Section,string IsSubTicket)
    {
        string Query = string.Empty;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string strC = "";




            if (statusID != "3" && statusID != "4" && statusID != "5")
            {
                AssignedEngineer = "";
                AssignedEngineerID = "";
                ForwordToDepartment = "";
                sb.Append(" UPDATE ticket_master SET STATUS=" + statusID + ",IsReopen=0, ");

                if (statusID == "2")
                    sb.Append(" CloseBy='" + HttpContext.Current.Session["ID"].ToString() + "',CloseDate='" + Util.GetDateTime(CloseDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(CloseTime).ToString("HH:mm:ss") + "', ");

                sb.Append(" Priority='" + Priority + "',PriorityID=" + PriorityID + ",");
                sb.Append(" LastUpdate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                sb.Append(" WHERE TicketID=" + TicketId + "");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                if (statusID == "2")
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update ticket_master_description set StatusID='2',STATUS='Close' where TicketId='" + TicketId + "'");
                
                }
                if (statusID == "1")
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Processed' WHERE TicketID=" + TicketId);
            }
            else if (statusID == "4")
            {
                if (IsSubTicket == "1")
                {
                    StringBuilder sbsub = new StringBuilder();
                    //string tno = StockReports.ExecuteScalar(" SELECT Max(IF(TicketNo=NULL,0,SUBSTR(TicketNo,POSITION('-' IN TicketNo)+1,1)))+1 FROM sub_ticket_master WHERE TicketID='" + TicketId + "' ");
                    //string tno = StockReports.ExecuteScalar(" SELECT Max(IF(TicketNo=NULL,0,SUBSTR(TicketNo,POSITION('-' IN TicketNo)+1,1)))+1 FROM sub_ticket_master WHERE TicketID='" + TicketId + "' ");
                    string parcount = StockReports.ExecuteScalar(" SELECT  count(*) FROM ticket_master tm INNER JOIN  ticket_master_description tmd  ON tm.TicketID=tmd.TicketID " +
                              " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy INNER JOIN Section_Master sm on sm.ID=tmd.Section WHERE tm.TicketID='" + TicketId + "' and tmd.Section='" + Section + "' ");
                    if (Int32.Parse(parcount) > 0)
                    {
                        return "7";
                    }
                    else
                    {
                        string duplicatesubAssign = StockReports.ExecuteScalar(" SELECT count(*) FROM sub_ticket_master WHERE TicketID='" + TicketId + "' and Section='" + Section + "' and Assigned_Engineer_ID='" + AssignedEngineerID + "'  ");
                        if (duplicatesubAssign == "0")
                        {
                            string srno = StockReports.ExecuteScalar(" SELECT COUNT(DISTINCT Section)+1 FROM sub_ticket_master stm  WHERE TicketID='" + TicketId + "' ");
                        
                            sbsub.Append("  INSERT INTO sub_ticket_master(TicketNo,EmployeeID,Priority,LastUpdate,Status,Active,IsClose,StockID,Date,TicketId,Section,Assigned_Engineer_ID,Assigned_Engineer) " +
                                   " VALUES (concat('" + TicketId + "','-','" + srno + "'),'" + Session["ID"].ToString() + "','Normal','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','Assigned','1','0','0','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + TicketId + "','" + Section + "','" + AssignedEngineerID + "','" + AssignedEngineer + "') ");
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbsub.ToString());
                        }
                        else
                        {
                            return "5";
                        }
                    }

                }
                else
                {
                    ForwordToDepartment = "";
                    sb.Append(" UPDATE ticket_master SET STATUS=" + statusID + ",IsAssign=1,Assigned_Engineer='" + AssignedEngineer + "',Assigned_Engineer_ID='" + AssignedEngineerID + "', ");
                    sb.Append(" AssignedDateTime=now(), AssignedBy='" + HttpContext.Current.Session["ID"].ToString() + "'");
                    sb.Append(" WHERE TicketID=" + TicketId + "");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID=" + TicketId);
                }
            }
            else if (statusID == "5")
            {
                AssignedEngineer = "";
                AssignedEngineerID = "";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_master SET STATUS=" + statusID + "  WHERE TicketID=" + TicketId);

                sb.Append(" INSERT INTO ticket_master(EmployeeID,EmailAddress , FullName,TelephoneNo,Department,SUBJECT,IssueSummary,Attachment,   ");
                sb.Append(" Priority,Description,PeopleEffeced,ProblemStartTime,ErrorTypeID,FLOOR  , DATE , STATUS  , RoleID ,Errortype,Downtime , PriorityID ,  ");
                sb.Append("Attachment_Name ,AssetName , StockID, IsForworded , ForwordBy,  ForwordAginstTokenNo,  ForwordedDateTime,ErrorDeptID  ");
                sb.Append(") SELECT EmployeeID,EmailAddress , FullName,TelephoneNo,Department,SUBJECT,IssueSummary,Attachment,   ");
                sb.Append(" Priority,Description ,PeopleEffeced,ProblemStartTime,ErrorTypeID,FLOOR , DATE , 0  , RoleID ,Errortype,Downtime , PriorityID ,   ");
                sb.Append("  Attachment_Name ,AssetName , StockID, 1 , '" + HttpContext.Current.Session["ID"].ToString() + "'," + TicketId + ",  NOW(),'" + ForwordToDepartment + "'  ");
                sb.Append("FROM ticket_master WHERE TicketID=" + TicketId + "   ");

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID=" + TicketId);

            }
            else
            {
                AssignedEngineer = "";
                AssignedEngineerID = "";
                ForwordToDepartment = "";
                sb.Append(" UPDATE ticket_master SET IsResolved=1 ");
                sb.Append(" WHERE TicketID=" + TicketId + "");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_master_description SET StatusID='3',STATUS='Resolve' WHERE TicketId=" + TicketId);
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID=" + TicketId);

            }
            if (statusID == "2")
            {
                AssignedEngineer = "";
                AssignedEngineerID = "";
                ForwordToDepartment = "";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_master SET IsClose=1  WHERE TicketID=" + TicketId);
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE sub_ticket_master SET Status='Close'  WHERE TicketID=" + TicketId);
                
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Close' WHERE TicketID=" + TicketId);
            }

            if (IsSubTicket != "1" && statusID != "3" && statusID != "2")
            {

                string duplicatesubAssign = StockReports.ExecuteScalar(" SELECT count(*) FROM ticket_master_description WHERE TicketID='" + TicketId + "' and Section='" + Section + "' and Assign_Engineer_Id='" + AssignedEngineerID + "'  ");
                        if (duplicatesubAssign == "0")
                        {
                                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO ticket_master_description(TicketId,StatusID,Priority,PriorityID,CreatedBy,IsReopen,Status,Assign_Engineer_Id,Assign_Engineer,ForwordToDepartment,Section)VALUES(" + TicketId + ",'" + statusID + "','" + Priority + "','" + PriorityID + "','" + HttpContext.Current.Session["ID"].ToString() + "',0,'" + status + "','" + AssignedEngineerID + "','" + AssignedEngineer + "','" + ForwordToDepartment + "','" + Section + "') ");

                        }
                        else
                        {
                            return "13";
                        }
            }
            int roleID = Util.GetInt(StockReports.ExecuteScalar(" SELECT RoleID FROM ticket_master WHERE TicketID='" + TicketId + "' "));
            Notification_Insert.notificationInsert(35, TicketId, tranX, "", "", roleID, DateTime.Now.ToString("yyyy-MM-dd"), "");

            //MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into ticket_reply(TicketID,userID,Description,Reply_Time,Status1 )VALUE ('" + TicketId + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Decription + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + status + "') ");

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
        //string Query = string.Empty;
        //if (status == "2")
        //    Query = "UPDATE ticket_master SET STATUS=" + status + ",CloseBy='" + HttpContext.Current.Session["ID"].ToString() + "',Priority='" + Priority + "',PriorityID=" + PriorityID + ",CloseDate='" + Util.GetDateTime(CloseDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(CloseTime).ToString("HH:mm:ss") + "' WHERE TicketID=" + TicketId + "";
        //else
        //    Query = "UPDATE ticket_master SET STATUS=" + status + ",Priority='" + Priority + "',PriorityID=" + PriorityID + "  WHERE TicketID=" + TicketId + "";
        //StockReports.ExecuteDML(Query);


        //StockReports.ExecuteDML(" update ticket_master set LastUpdate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where TicketId=" + TicketId + "");
        //StockReports.ExecuteDML(" insert into ticket_reply(TICKETID,USERID,DESCRIPTION,REPLY_TIME,STATUS1 )VALUE ('" + TicketId + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Decription + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + status + "') ");
        //return "1";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ReplyTicket(string status, string Description, string TicketId)
    {
        string str = "INSERT INTO ticket_reply(TICKETID,USERID,DESCRIPTION,REPLY_TIME,STATUS1,ReplyFromId,ReplyFromName )VALUE ('" + TicketId + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Description + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + status + "','" + HttpContext.Current.Session["RoleID"].ToString() + "','" + HttpContext.Current.Session["LoginType"].ToString() + "' )";
        StockReports.ExecuteDML(str);
        int roleID = Util.GetInt(StockReports.ExecuteScalar(" SELECT RoleID FROM ticket_master WHERE TicketID='" + TicketId + "' "));


        if (roleID != Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()))
        {
            string isVst = StockReports.ExecuteScalar("Select IsVisit from ticket_master WHERE TicketID='" + TicketId + "' ");
            if (isVst == "0")
            {
                StockReports.ExecuteDML("update ticket_master set IsVisit=1, LastUpdate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where TicketId=" + TicketId + "");

                StockReports.ExecuteDML("UPDATE ass_breakdown SET lastStatus='Visited' WHERE TicketID=" + TicketId + "");
            }
            Notification_Insert.notificationInsert(36, TicketId, null, "", "", roleID, DateTime.Now.ToString("yyyy-MM-dd"), "");

        }


        return "1";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string reply_bind(string TicketID)
    {
        All_LoadData.updateNotification(TicketID, HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["RoleID"].ToString(), 32);
        string s = "select TicketID,ReplyFromName,DATE_FORMAT(e.REPLY_TIME,'%d-%b-%Y %h:%i %p')AS REPLY_TIME,D.Name,Replace(E.DESCRIPTION,'\n','<br>') DESCRIPTION from ticket_reply e,employee_master d where e.USERID=D.EmployeeID and TicketID=" + TicketID + "";
        DataTable dt = StockReports.GetDataTable(s);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindTicketDetail(string TicketNo)
    {
        string select = " SELECT CostCentre,tk.ProjectSupervisor, CONCAT(Title,' ',NAME) RequestedBy ,tk.Location,tk.LocationCode,TicketID TicketNo,RoleID,ErrorDeptID,CloseBy,Date_Format(CloseDate,'%d-%b-%Y %h:%i %p')CloseDate, " +
                        " Department,FLOOR,emp.EmployeeID,Attachment,Attachment_Name,DATE_FORMAT(ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartTime," +
                        " Description,NAME,ErrorType,Description,PeopleEffeced,Priority,PriorityID,DATE_FORMAT(Date,'%d-%b-%Y %h:%i %p')DATE,STATUS StatusID, " +
                        " (CASE WHEN STATUS = '0' THEN 'Pending' WHEN STATUS = '1' THEN 'Process' WHEN STATUS = '2' THEN 'Close'  WHEN STATUS = '3' THEN 'ReOpen' ELSE 'STOP' END) STATUS," +
                        " DATE_FORMAT(LastUpdate,'%d-%b-%Y')LastUpdate,tk.IsVisit FROM ticket_master tk INNER JOIN employee_master emp ON tk.EmployeeID=emp.EmployeeID WHERE Active=1  AND TicketID=" + TicketNo;

        DataTable dt = StockReports.GetDataTable(select);

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindEmpTicketDetail(string CloseBy)
    {
        string Name = StockReports.ExecuteScalar("select Name from employee_master where EmployeeID='" + CloseBy + "'");
        if (Name != "")
            return Name;
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindResponse(string Reply)
    {
        string Description = StockReports.ExecuteScalar("SELECT Description FROM ticket_premade_reply_master WHERE ID = '" + Reply + "' ");

        if (Description != "")
            return Description;
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string searchTicketingInfo(string FrmDate, string ToDate, string Raised, string Resolved, string ticketNo, string chkIssue, string chkRaised)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ft.TicketId TicketNo,ft.Department AS FromDepartment, em.name EmployeeName,(SELECT RoleName FROM f_rolemaster WHERE ID=ft.ErrorDeptID LIMIT 1)ToDepartment,DATE_FORMAT(ft.Date,'%d-%b-%Y %h:%i %p')StartingDateTime, DATE_FORMAT(ft.closedate,'%d-%b-%Y %h:%i %p')ClosingDateTime, ");
        sb.Append(" fm.name AS CloseBy,ft.Priority, ft.ErrorType, ft.Description,(CASE WHEN ft.STATUS = '0' THEN 'Pending' WHEN ft.STATUS = '1'  THEN 'Process' WHEN ft.STATUS = '2' THEN 'Close' WHEN ft.STATUS = '3' THEN 'ReOpen' ELSE 'STOP' END) Status, ");
        sb.Append(" ft.PeopleEffeced,DATE_FORMAT(ft.ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartDateTime,ft.Floor,IFNULL((SELECT GROUP_CONCAT(ReopenReason) FROM `ticket_master_description` WHERE TicketId=ft.TicketID AND isReopen=1 GROUP BY TicketID),'')ReopenReason FROM ticket_master ft LEFT JOIN ticket_reply ftr ON ft.TicketID=ftr.TICKETID ");
        sb.Append(" LEFT JOIN   employee_master em ON em.EmployeeID= ft.EmployeeID  LEFT JOIN employee_master fm ON fm.`EmployeeID`=ft.`CloseBy`       ");
        sb.Append(" WHERE DATE(ft.Date) >= '" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" AND DATE(ft.Date) <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");

        if (ticketNo != "")
        {
            sb.Append("  AND ft.ticketid='" + ticketNo + "' ");
        }

        if (chkIssue == "true")
        {
            if (Raised != "0")
            {
                sb.Append(" AND ft.roleid='" + Raised + "' ");
            }
        }

        if (chkRaised == "true")
        {
            if (Resolved != "0")
            {
                sb.Append(" AND ft.errordeptid='" + Resolved + "' ");
            }
        }
        sb.Append(" GROUP BY ft.TicketID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Ticketing All Information Report";
            Session["Period"] = "Period From : " + Util.GetDateTime(FrmDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy") + " ";
            return "1";
        }
        else
        {
            return "0";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindPriority()
    {
        // DataTable Priority = StockReports.GetDataTable("Select ID,Name from ticket_priority");
        DataTable Priority = StockReports.GetDataTable("Select ID,Name from f_priority");

        return Newtonsoft.Json.JsonConvert.SerializeObject(Priority);
    }

    [WebMethod]
    public string ticketDetail(string TicketID)
    {
        string query = " SELECT  tm.TicketID,'Parent' as Ticket,sm.Section_Name,CONCAT(em.Title,' ',em.Name)CreatedBy,tm.TicketID,tmd.Status,tmd.Priority,if(tmd.IsReopen=1,'Yes','No')IsReopen, " +
                       " DATE_FORMAT(tmd.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate,IFNULL(tmd.ReopenReason,'')Reason,tmd.Assign_Engineer,(SELECT rm.`RoleName` FROM f_rolemaster rm  WHERE  rm.`ID`=tmd.ForwordToDepartment)ForwordToDepartment FROM ticket_master tm INNER JOIN  ticket_master_description tmd  ON tm.TicketID=tmd.TicketID " +
                       " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy INNER JOIN Section_Master sm on sm.ID=tmd.Section WHERE tm.TicketID=" + TicketID + "";

        DataTable dt = StockReports.GetDataTable(query);

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string ticketDetailReply(string TicketID)
    {
        string query = "SELECT  DISTINCT (SELECT sm.Section_Name FROM `section_master` sm WHERE sm.ID=stm.Section)Section_Name ,CONCAT(em.Title,' ',em.Name)CreatedBy,stm.TicketID,tmd.Status,tmd.Priority,IF(tmd.IsReopen=1,'Yes','No')IsReopen, "+
"DATE_FORMAT(stm.Date,'%d-%b-%Y %h:%i %p')CreatedDate,IFNULL(tmd.ReopenReason,'')Reason,"+
"(SELECT CONCAT(emp.Title,' ',emp.Name) FROM `employee_Master` emp WHERE emp.EmployeeID=stm.Assigned_Engineer_ID) Assigned_Engineer,"+
"(SELECT rm.`RoleName` FROM f_rolemaster rm  "+
"WHERE  rm.`ID`=tmd.ForwordToDepartment)ForwordToDepartment FROM  sub_ticket_master stm "+
 "INNER JOIN  ticket_master_description tmd  ON stm.TicketID=tmd.TicketId   "+
                        " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy  WHERE stm.TicketID=" + TicketID + "";

        DataTable dt = StockReports.GetDataTable(query);

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public string reopenTicket(string TicketId, string ReopenPriority, string ReopenPriorityID, string Reason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO ticket_master_description(TicketId,StatusID,Priority,PriorityID,CreatedBy,IsReopen,Status,ReopenReason) " +
                " VALUES(" + TicketId + ",'3','" + ReopenPriority + "','" + ReopenPriorityID + "','" + HttpContext.Current.Session["ID"].ToString() + "',1,'ReOpen','" + Reason + "') ");

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_master SET isReopen=1, Status=3 WHERE TicketID='" + TicketId + "' ");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ticket_master_description SET StatusID=3, STATUS='ReOpen' WHERE TicketID='" + TicketId + "' ");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE sub_ticket_master SET isReopen=1, STATUS='Assigned' WHERE TicketID='" + TicketId + "' and STATUS='Close' ");

            int roleID = Util.GetInt(StockReports.ExecuteScalar(" SELECT RoleID FROM ticket_master WHERE TicketID='" + TicketId + "' "));
            Notification_Insert.notificationInsert(34, TicketId, tranX, "", "", roleID, DateTime.Now.ToString("yyyy-MM-dd"), "");

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

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string employeeSearch(string Name, string contactNo, string city)
    {
        DataTable emp = StockReports.GetDataTable("select CONCAT(Title,' ',Name)Name,CONCAT(House_No,' ',City)Address,Mobile ContactNo from pay_employee_master WHERE IsActive=1");
        if (emp.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(emp);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string panelSearch(string Panel, string PanelGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select pm.Company_Name,pm.Add1,pm.Add2,pm.PanelID,pmIPD.Company_Name as Ref_Company,pm.ReferenceCode,pm.Panel_Code,pm.IsTPA,pm.EmailID,pm.Phone, ");
        sb.Append(" pm.Mobile,pm.Contact_Person,pm.Fax_No,pmOPD.Company_Name as Ref_CompanyOPD,pm.ReferenceCodeOPD, ");
        sb.Append(" pm.Agreement,if(pm.IsServiceTax='1','Yes','No')IsServiceTax,DATE_FORMAT(pm.DateFrom,'%d-%b-%y')DateFrom,");
        sb.Append(" DATE_FORMAT(pm.DateTo,'%d-%b-%y')DateTo,pm.CreditLimit,pm.PaymentMode,pm.PanelGroup ");
        sb.Append(" from f_panel_master pm inner join f_panel_master pmIPD on pmIPD.PanelID = pm.ReferenceCode ");
        sb.Append(" inner join f_panel_master pmOPD on pmOPD.PanelID = pm.ReferenceCodeOPD where pm.PanelID<>0 ");


        if (Panel != "0")
            sb.Append("and pm.PanelID=" + Panel + " ");
        if (PanelGroup != "0")
            sb.Append("and pm.PanelGroup='" + PanelGroup + "'");
        sb.Append(" order by pm.Company_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string IPDDetail(string FDSearch, string type, string City, string TDSearch, string PatientID, string PName, string ContactNo)
    {
        string str1 = "select   rm.NAME AS RoomName,da.PatientID,da.Title,da.Pname,date_format(ich.DateOfAdmit,'%d-%b-%Y') as DateOfAdmit,if(DateOfDischarge='0001-01-01','',date_format(ich.DateOfDischarge,'%d-%b-%Y')) as DateOfDischarge, ";
        str1 += " da.Mobile ContactNo,da.State,dm.Name ,rm.Room_No,rm.Bed_No,rm.Floor,ich.Status as Status, ";
        str1 += " Concat(da.House_No,'',da.Street_Name)Address,CONCAT(Relation,' ',RelationName)Relation ";
        str1 += " from patient_master da ,patient_ipd_profile ip,patient_medical_history ich,doctor_master dm ,room_master rm where ip.TransactionID=ich.TransactionID AND ip.RoomID=rm.RoomID AND ip.PatientID=da.PatientID AND ich.DoctorID=dm.DoctorID";
        if (FDSearch != "" && TDSearch != "")
        {
            if (type == "Currently Admitted")
                str1 += " AND ich.Status='IN' AND ip.Status='IN' ";
            else if (type == "Admitted")
                str1 += " AND ich.DateOfAdmit  between '" + Convert.ToDateTime(FDSearch).ToString("yyyy-MM-dd") + "' and '" + Convert.ToDateTime(TDSearch).ToString("yyyy-MM-dd") + "' AND ich.Status='IN' AND ip.Status='IN'  ";
            else if (type == "Discharged")
                str1 += " AND ich.DateOfDischarge  between '" + Convert.ToDateTime(FDSearch).ToString("yyyy-MM-dd") + "' and '" + Convert.ToDateTime(TDSearch).ToString("yyyy-MM-dd") + "' AND ich.Status='OUT' ";
        }

        if (PatientID != "")
            str1 += " AND da.PatientID ='" + PatientID + "'";
        if (PName != "")
            str1 += " AND da.Pname LIKE'" + PName + "%'";
        if (ContactNo != "")
            str1 += " AND da.Mobile LIKE '" + ContactNo + "%'";
        if (City != "")
            str1 += " AND City LIKE '" + City + "%'";
        str1 += " GROUP BY ich.TransactionID ";
        DataTable dt = StockReports.GetDataTable(str1);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string OPDDetail(string FDSearch, string type, string City, string TDSearch, string PatientID, string PName, string ContactNo)
    {
        return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string packageOPDDetail(string packageID, string PanelID)
    {

        string str = " SELECT (SELECT Company_Name FROM f_panel_master WHERE PanelID=rt.PanelID)PanelName,rt.PanelID, pm.Name PackageName,rt.Rate,pm.PlabID,im.ItemID FROM f_itemmaster im  " +
                                  " INNER JOIN packagelab_master pm ON im.Type_ID = pm.PlabID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID  INNER JOIN f_configrelation  " +
                                  " cf ON cf.CategoryID = sc.CategoryID INNER JOIN f_ratelist rt ON rt.Itemid = im.ItemID INNER JOIN f_rate_schedulecharges rs ON rs.PanelID = rt.PanelID " +
                                  " WHERE cf.ConfigID=23 AND rs.IsDefault=1 AND  IsCurrent=1 ";

        if (PanelID != "0")
            str = str + " AND rs.PanelID=" + PanelID + " ";

        if (packageID != "0")
            str = str + " AND pm.PlabID='" + packageID + "'";

        str = str + " GROUP BY PanelName ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string packageItemDetail(string packageID, string PanelID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT 'Investigation' Type,(SELECT Company_Name FROM f_panel_master WHERE PanelID=" + PanelID + ")PanelName,pm.PlabID,(pm.Name)PackageName,(im.Name)ItemName  FROM package_labdetail pd INNER JOIN  packagelab_master pm ON   pm.PlabID=pd.PlabID ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=pd.InvestigationID where pm.PlabID='" + packageID + "'   AND pm.IsActive=1 AND pd.IsActive=1  UNION SELECT 'Doctor' Type,(SELECT Company_Name FROM f_panel_master WHERE PanelID='" + PanelID + "')PanelName,pm.PlabID, ");
        sb.Append(" (pm.Name)PackageName,(SELECT CONCAT(Title,NAME) FROM doctor_master WHERE DoctorID=pdoc.DoctorID )ItemName  FROM  package_doctordetail pdoc ");
        sb.Append(" INNER JOIN  packagelab_master pm ON   pm.PlabID=pdoc.PlabID where pm.PlabID='" + packageID + "' and pdoc.IsActive=1 ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindPackage(string PanelID)
    {
        string str = " SELECT (SELECT Company_Name FROM f_panel_master WHERE PanelID=rt.PanelID)Panelname, pm.Name Packagename,rt.Rate,pm.PlabID,im.ItemID FROM f_itemmaster im  " +
                   " INNER JOIN packagelab_master pm ON im.Type_ID = pm.PlabID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID  INNER JOIN f_configrelation  " +
                   " cf ON cf.CategoryID = sc.CategoryID INNER JOIN f_ratelist rt ON rt.Itemid = im.ItemID INNER JOIN f_rate_schedulecharges rs ON rs.PanelID = rt.PanelID " +
                   " WHERE cf.ConfigID=23 AND rs.IsDefault=1 AND rs.PanelID=" + PanelID + "  GROUP BY Panelname";

        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string showHelpdeskDoctor(string Department, string DName, string Specialization)
    {
        string strQuery = "";
        strQuery = "SELECT  DM.Name,DM.DoctorID AS DID, IFNULL((SELECT Department FROM doctor_hospital WHERE DoctorID=dm.DoctorID LIMIT 1),'')Department,DM.Specialization,DM.Degree FROM doctor_master DM where Dm.doctorID<>'' ";
        if (DName != "")
            strQuery = strQuery + " and DM.Name like '%" + DName + "%'";
        if (Specialization != "ALL")
            strQuery = strQuery + " and Specialization like '%" + Specialization + "%'";
        if (Department != "0")
            strQuery = strQuery + "and DocDepartmentID = '" + Department + "'";
        strQuery = strQuery + " ORDER BY DM.Name";

        DataTable dt = StockReports.GetDataTable(strQuery);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindScheduleChage(string PanelID)
    {
        string str = "SELECT NAME,ScheduleChargeID,IsDefault FROM f_rate_schedulecharges rs INNER JOIN f_panel_master pm ";
        str += " ON pm.PanelID = rs.PanelID WHERE ";
        str += "rs.PanelID='" + PanelID + "'";

        DataTable dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string viewDoctorRate(string Type, string DoctorID, string Reference, string SubCategory, string CaseType, string ScheduleChargeID)
    {
        string CentreId = HttpContext.Current.Session["CentreID"].ToString();
        DataTable dt = CreateStockMaster.GetRateList(Type, DoctorID, Reference, SubCategory, CaseType, ScheduleChargeID, CentreId);

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindOPDDetail(string PatientID, string Name, string ContactNo, string City, string FromDate, string ToDate)
    {
        string str = "SELECT pm.Patient_ID,CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.House_No,' ',pm.City)Address,pm.Mobile ContactNo,pm.Gender,";
        str += " DATE_FORMAT(pmh.dateofvisit,'%d-%b-%Y')Dateofvisit,CONCAT(dm.Title,' ',dm.name)DName FROM patient_master pm ";
        str += " INNER JOIN patient_medical_history pmh ON pm.patient_id=pmh.patient_id INNER JOIN doctor_master dm ON dm.doctor_id=pmh.doctor_id WHERE TYPE='OPD' ";
        if (PatientID != "")
            str += " AND pm.Patient_ID='" + PatientID + "' ";
        if (Name != "")
            str += " AND pm.PName LIKE '" + Name + "%'";
        if (ContactNo != "")
            str += " AND pm.Mobile='" + ContactNo + "' ";
        if (City != "")
            str += " AND pm.City='" + City + "' ";

        if (PatientID == "" && ContactNo == "")
        {
            if (FromDate != "" && ToDate != "")
                str += " AND pmh.dateofvisit  between '" + Convert.ToDateTime(FromDate).ToString("yyyy-MM-dd") + "' and '" + Convert.ToDateTime(ToDate).ToString("yyyy-MM-dd") + "'";
        }
        str += "Group by pmh.Patient_ID";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindForwordDepartment()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT rm.ID, rm.RoleName Name FROM f_rolemaster rm INNER JOIN ticket_error_type et ON et.RoleID=rm.ID WHERE rm.Active=1 AND rm.ID!='" + HttpContext.Current.Session["RoleID"].ToString() + "' GROUP BY rm.ID ORDER BY rm.RoleName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindAssignedToEmployee()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT( em.`EmployeeID`) Id,CONCAT(em.`Title`,'',em.`NAME`)EmpName ");
        sb.Append(" FROM employee_master em ");
        sb.Append(" INNER JOIN f_login fl ON fl.`EmployeeID`=em.`EmployeeID` AND fl.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append(" WHERE fl.`Active`=1 AND em.`IsActive`=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }




    [WebMethod(EnableSession = true, Description = "Save Item List")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveItemList(object data)
    {
        List<AddItemListOnClose> dataPrint = new JavaScriptSerializer().ConvertToType<List<AddItemListOnClose>>(data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sbUpd = new StringBuilder();

            sbUpd.Append("update ticket_Item_details set IsActive=0 where TicketId=@TicketId");

            int IsUpdate = excuteCMD.DML(tnx, sbUpd.ToString(), CommandType.Text, new
            {
                TicketId = dataPrint[0].TicketId,

            });

            foreach (var item in dataPrint)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(" INSERT INTO  ticket_Item_details ");
                sb.Append(" (ItemName,Rate,Qty,Total,TicketId,FromDepartment,EntryBy) ");
                sb.Append(" VALUES (@ItemName,@Rate,@Qty,@Total,@TicketId,@FromDepartment,@EntryBy)");
                int T = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    ItemName = item.ItemNmae,
                    Rate = Util.GetDecimal(item.Rate),
                    Qty = Util.GetDecimal(item.Qty),
                    Total = Util.GetDecimal(item.Total),
                    TicketId = item.TicketId,
                    FromDepartment = HttpContext.Current.Session["RoleID"].ToString(),
                    EntryBy = HttpContext.Current.Session["ID"].ToString()

                });
            }

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Message = "Item Added Successfully." });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Message = "Error in saving Item Data." });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true, Description = "Bind Saved Item")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindSavedItem(string TickId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ticket_Item_details tid WHERE tid.`IsActive`=1 AND tid.`TicketId`='" + TickId + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0 && dt != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "No data found" });

        }
    }

    [WebMethod(EnableSession = true, Description = "Bind Status")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindStatus(string TickId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tm.TicketID,IF(tm.IsReopen=1,'ReOpen',  ");
        sb.Append(" (CASE WHEN tm.STATUS = '0' THEN 'Pending' WHEN tm.STATUS = '1' THEN 'Process'  ");
        sb.Append(" WHEN tm.STATUS = '2' THEN 'Close' WHEN tm.STATUS = '4' THEN 'Assigned'   ");
        sb.Append("  WHEN tm.STATUS = '5' THEN 'Forworded'  ELSE 'STOP' END)  ");
        sb.Append("  ) Status FROM ticket_master tm WHERE tm.`TicketID` IN (" + TickId + ") ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0 && dt != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "No data found" });

        }
    }





    [WebMethod(EnableSession = true, Description = "Print Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PrintReport(string TickId, string FTickId)
    { 
        try
        {

            string select = " SELECT tmd.STATUS STATUSTMD,(SELECT GROUP_CONCAT(distinct Section_Name) FROM sub_ticket_master st INNER JOIN Section_Master sma ON sma.ID=st.Section   WHERE st.TicketID=tk.TicketID)SectionGroup, (CASE WHEN tk.STATUS = '0' THEN 'Pending' WHEN tk.STATUS = '1' THEN 'Process' WHEN tk.STATUS = '2' THEN 'Close'  WHEN tk.STATUS = '3' THEN 'ReOpen' ELSE 'STOP' END) STATUSTK, tk.Location,tk.LocationCode,tk.CostCentre,(SELECT CONCAT(Title,' ',NAME) FROM employee_Master em where em.EmployeeID=tk.ProjectSupervisor )ProjectSupervisor,(Select sm.Section_Name from Section_Master sm where sm.ID=(Select tmd.Section from ticket_master_description tmd where tmd.TicketID=tk.TicketID limit 1) limit 1) Section_Name,tk.TicketID TicketNo,RoleID,ErrorDeptID,CloseBy,Date_Format(CloseDate,'%d-%b-%Y %h:%i %p')CloseDate, " +
                       " Department,rm.RoleName FLOOR,emp.EmployeeID,Attachment,Attachment_Name,DATE_FORMAT(ProblemStartTime,'%d-%b-%Y %h:%i %p')ProblemStartTime," +
                       "  (SELECT GROUP_CONCAT(CONCAT(' ',rm.`RoleName`,' ( ',tms.`TicketID`,' )')) FROM f_rolemaster rm   "+
                       " INNER JOIN ticket_master tms ON rm.`ID`=tms.`ErrorDeptID`   "+
                       " WHERE tms.`ForwordAginstTokenNo`=tk.TicketID) ForwordTo," +
                       " ifnull((SELECT GROUP_CONCAT(tms.`TicketID`) FROM ticket_master tms  WHERE tms.`ForwordAginstTokenNo`=tk.TicketID),'')ForwordedTicketNo , " + 
                       " Description,NAME,ErrorType,Description,PeopleEffeced,tk.Priority,tk.PriorityID,DATE_FORMAT(Date,'%d-%b-%Y %h:%i %p')DATE,tk.STATUS StatusID, " +
                       " (CASE WHEN tk.STATUS = '0' THEN 'Pending' WHEN tk.STATUS = '1' THEN 'Process' WHEN tk.STATUS = '2' THEN 'Close'  WHEN tk.STATUS = '3' THEN 'ReOpen' ELSE 'Forward' END) STATUS," +
                       " DATE_FORMAT(LastUpdate,'%d-%b-%Y')LastUpdate,tk.IsVisit FROM ticket_master tk " +
                       " INNER JOIN employee_master emp ON tk.EmployeeID=emp.EmployeeID " +
                       " INNER JOIN f_rolemaster rm ON rm.id = tk.ErrorDeptID "+
                       " INNER JOIN ticket_master_description tmd ON tk.TicketID=tmd.TicketId "+
       "  INNER JOIN Section_Master sm ON sm.ID=tmd.Section "+
 
           " WHERE tk.Active=1 AND tk.TicketID=" + TickId+" ";

            DataTable dt = StockReports.GetDataTable(select);


            string queryDes = " SELECT CONCAT(em.Title,' ',em.Name)CreatedBy,tm.TicketID,tmd.Status,tmd.Priority,if(tmd.IsReopen=1,'Yes','No')IsReopen, " +
                     " DATE_FORMAT(tmd.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate,IFNULL(tmd.ReopenReason,'')Reason,tmd.Assign_Engineer,(SELECT rm.`RoleName` FROM f_rolemaster rm  WHERE  rm.`ID`=tmd.ForwordToDepartment)ForwordToDepartment FROM ticket_master tm INNER JOIN  ticket_master_description tmd  ON tm.TicketID=tmd.TicketID " +
                     " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy WHERE tm.TicketID=" + TickId + "";

            DataTable dtTicketdescription = StockReports.GetDataTable(queryDes);

            
            StringBuilder sb = new StringBuilder();

            string WholeTickId = TickId + "," + FTickId;

           // sb.Append(" SELECT * FROM ticket_Item_details tid WHERE tid.`IsActive`=1 AND tid.`TicketId` in (" + WholeTickId + ") ");
            sb.Append(" SELECT rm.RoleName FromDepartment,tid.* FROM ticket_Item_details tid INNER JOIN f_rolemaster rm ON rm.Id = tid.FromDepartment WHERE tid.`IsActive`=1 AND tid.`TicketId` IN (" + WholeTickId + ") ");

            DataTable dtItemDetails = StockReports.GetDataTable(sb.ToString());

            string s = "select TicketID,ReplyFromName,DATE_FORMAT(e.REPLY_TIME,'%d-%b-%Y %h:%i %p')AS REPLY_TIME,D.Name,Replace(E.DESCRIPTION,'\n','<br>') DESCRIPTION from ticket_reply e,employee_master d where e.USERID=D.EmployeeID and TicketID in(" + WholeTickId + ")";
            DataTable dtReplyDetails = StockReports.GetDataTable(s);
            
            DataSet ds = new DataSet();
            
            dt.TableName = "TicketDetails";
            ds.Tables.Add(dt.Copy());

            dtTicketdescription.TableName = "TicketDescription";
            ds.Tables.Add(dtTicketdescription.Copy());

            dtItemDetails.TableName = "ItemDetails";
            ds.Tables.Add(dtItemDetails.Copy());

            dtReplyDetails.TableName = "ReplyDetails";
            ds.Tables.Add(dtReplyDetails.Copy());
            
          //  ds.WriteXmlSchema(@"E:\PrintReportTicket.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "PrintReportTicket";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = "../common/Commonreport.aspx" });


        }
        catch (Exception ex)
        {
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data =ex.ToString() });

        }
         
    }

    
    
    public class AddItemListOnClose
    {
        public string ItemNmae { get; set; }
        public string TicketId { get; set; }
        public string Qty { get; set; }
        public string Rate { get; set; }
        public string Total { get; set; }

    }


}