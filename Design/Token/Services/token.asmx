<%@ WebService Language="C#" Class="token" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class token : System.Web.Services.WebService
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string searchToken()
    {
        //  string rtrn = ""; 
        //  StringBuilder sb = new StringBuilder();
        //  sb.Append(" SELECT TransactionID,PatientID,App_ID,AppNo,CONCAT(title,' ',PName)NAME,(SELECT CONCAT(Title,' ',NAME)");
        //  sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        //  sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%Y')AppDate,IsConform,IsReschedule, IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%Y %l:%i %p')ConformDate,IFNULL(LedgerTnxNo,'')LedgerTnxNo,");
        //  sb.Append(" CONCAT(DATE,' ',TIME)AppDateTime,ContactNo,if(ISNULL(tokenNo),0,1)tokenNoExit,IF(ISNULL(tokenNo),'',tokenNo)tokenNo FROM appointment app ");
        //  sb.Append(" where Date='" + DateTime.Now.ToString("yyyy-MM-dd") + "' and app.PatientID<>'' and LedgerTnxNo<>'' AND app.IsConform=1 ");
        //  sb.Append("  and app.IsCancel=0");

        DataTable dt = StockReports.GetDataTable("call cpoe_searchtoken()");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string createToken(string AppID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            string DocDepartmentID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select docm.DocDepartmentID FROM appointment app INNER JOIN doctor_master docm ON app.DoctorID=docm.DoctorID WHERE  App_ID=" + AppID + " "));
            string tokenNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "select create_tokenNo('" + DocDepartmentID + "') "));
            string token = "UPDATE appointment set IsCancelToken=0, TokenNo='" + tokenNo + "',TokenCreateBy='" + HttpContext.Current.Session["ID"].ToString() + "',TockenCreatedDate=CURDATE(),TokenCreatedTime=CURTIME() where App_ID=" + AppID + " ";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, token);
            tranX.Commit();
            return tokenNo;
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
    public string CancelToken(string AppID)
    {
        string token = "UPDATE appointment set  IsCancelToken=3,TokenCancelBy='" + HttpContext.Current.Session["ID"].ToString() + "',TokenCancelDateTime=NOW() where App_ID=" + AppID + " ";
        bool CancelToken = StockReports.ExecuteDML(token.ToString());
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT TransactionID,DATE_FORMAT(Date, '%Y-%m-%d')Date,PatientID,App_ID,AppNo,CONCAT(title,' ',PName)NAME,(SELECT CONCAT(Title,' ',NAME)");
        sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%Y')AppDate,IsConform,IsReschedule, IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%Y %l:%i %p')ConformDate,");
        sb.Append("  IFNULL(LedgerTnxNo,'')LedgerTnxNo,");
        sb.Append("  CONCAT(DATE,' ',TIME)AppDateTime,ContactNo,IF(ISNULL(tokenNo),0,1)tokenNoExit,IF(ISNULL(tokenNo),'',tokenNo)tokenNo,IsCancelToken FROM appointment app ");
        sb.Append("  WHERE DATE=CURDATE() AND app.PatientID<>'' AND LedgerTnxNo<>'' AND app.IsConform=1 ");
        sb.Append(" AND app.IsCancel=0 and  app.App_ID=" + AppID + " ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        sb.Clear();
        sb.Append("insert into CancelOPDToken(TransactionID,PatientID,App_ID ,AppNo ,NAME,DoctorName ,DoctorID ,VisitType ,AppTime ,AppDate,IsConform ,IsReschedule,IsCancel ");
        sb.Append(",CancelReason ,ConformDate ,LedgerTnxNo ,AppDateTime ,ContactNo ,tokenNoExit,tokenNo ,IsCancelToken,DATE ) ");
        sb.Append(" values('" + dt.Rows[0]["TransactionID"] + "','" + dt.Rows[0]["PatientID"] + "'," + dt.Rows[0]["App_ID"] + "," + dt.Rows[0]["AppNo"] + ",'" + dt.Rows[0]["NAME"] + "',");
        sb.Append(" '" + dt.Rows[0]["DoctorName"] + "','" + dt.Rows[0]["DoctorID"] + "','" + dt.Rows[0]["VisitType"] + "','" + dt.Rows[0]["AppTime"] + "','" + dt.Rows[0]["AppDate"] + "',");
        sb.Append(" " + dt.Rows[0]["IsConform"] + "," + dt.Rows[0]["IsReschedule"] + "," + dt.Rows[0]["IsCancel"] + ",'" + dt.Rows[0]["CancelReason"] + "','" + dt.Rows[0]["ConformDate"] + "', ");
        sb.Append("'" + dt.Rows[0]["LedgerTnxNo"] + "','" + dt.Rows[0]["AppDateTime"] + "','" + dt.Rows[0]["ContactNo"] + "','" + dt.Rows[0]["tokenNoExit"] + "','" + dt.Rows[0]["tokenNo"] + "', ");
        sb.Append("  2, '" + dt.Rows[0]["DATE"] + "' ) ");
        bool UpdateToken = StockReports.ExecuteDML(sb.ToString());
        return "1";
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadDoctor(string docDepartmentID)
    {
        string logo = "../DocDepartmentLogo/" + docDepartmentID;
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(app.DoctorID) DocID,CONCAT(dm.title,' ',dm.name)DocName,dm.DocDepartmentID,dh.Department,dh.Room_No,t2.PName,t2.MRNO,t2.TokenNo,t2.AppNo  FROM (SELECT DoctorID,Department,CONCAT(IFNULL(Room_No,''),'/ ',IFNULL(DocFloor,''))Room_No FROM doctor_hospital )dh INNER JOIN  appointment app ON app.DoctorID=dh.DoctorID  INNER JOIN doctor_master dm ON app.DoctorID=dm.DoctorID ");
        sb.Append(" INNER JOIN ( SELECT PatientID MRNO,PName,IFNULL(TokenNo,'')TokenNo,AppNo,dh.Room_No,app.DoctorID,app.IsCancelToken FROM (SELECT DISTINCT(DoctorID),CONCAT(IFNULL(Room_No,''),'/',IFNULL(DocFloor,''))Room_No ");
        sb.Append("  FROM doctor_hospital )dh INNER JOIN appointment app ON app.DoctorID=dh.DoctorID  WHERE TockenCreatedDate=CURDATE() ");
        sb.Append("    AND TokenNo<>'' AND P_out=0 AND P_IN=0  ) t2 ON t2.DoctorID=app.DoctorID");
        sb.Append(" where app.TockenCreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' and app.P_out=0 and app.P_IN=0 ");
        if (docDepartmentID != string.Empty)
            sb.Append(" and dm.DocDepartmentID IN(" + docDepartmentID + ")");
        sb.Append(" and t2.IsCancelToken=0 ORDER BY dh.Department,t2.TokenNo");
        DataTable dtDocList = StockReports.GetDataTable(sb.ToString());
        if (dtDocList.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDocList);
        else
            return "";
    }
    
    //[WebMethod(EnableSession = true)]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public string LoadDoctor(string docDepartmentID)
    //{
    //    //string logo = "../DocDepartmentLogo/" + docDepartmentID;
    //    string str = "";
    //    str = "SELECT DISTINCT(app.DoctorID) DocID,CONCAT(dm.title,' ',dm.name)DocName,dm.DocDepartmentID,dh.Department,dh.Room_No FROM (SELECT DoctorID,Department,CONCAT(IFNULL(Room_No,''),'/ ',IFNULL(DocFloor,''))Room_No FROM doctor_hospital )dh INNER JOIN  appointment app ON app.DoctorID=dh.DoctorID  INNER JOIN doctor_master dm ON app.DoctorID=dm.DoctorID where app.TockenCreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' and app.P_out=0 and app.P_IN=0 ";
    //    if (docDepartmentID != string.Empty)
    //        str += " and dm.DocDepartmentID IN(" + docDepartmentID + ")";
    //    DataTable dtDocList = StockReports.GetDataTable(str);
    //    if (dtDocList.Rows.Count > 0)
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(dtDocList);
    //    else
    //        return "";
    //}

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadPatient(string DocID)
    {
        DataTable dtpatientList = StockReports.GetDataTable("call cpoe_LoadPatient('" + DocID + "')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtpatientList);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadAppointment(string DoctorID)
    {
        DataTable dt = StockReports.GetDataTable("call cpoe_LoadAppointment('" + DoctorID + "')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadDoctorToken(string MRNo, string PName, string AppNo, string DoctorID, string status, string fromDate, string toDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT app.PatientID,LedgerTnxNo,app.PatientID MRNo,app.App_ID,app.P_IN,app.tokenNo,app.AppNo,CONCAT(app.Title,' ',app.Pname)Pname,CONCAT(dm.Title,'',dm.Name)DName, ");
        sb.Append(" Get_Current_Age(pm.PatientID)Age,app.Sex,DATE_FORMAT(app.date,'%d-%b-%y')AppointmentDate,app.Sex,app.ContactNo,app.VisitType,TypeOfApp,pmh.TransactionID,IF(app.flag = 1,'true','false')IsDone,IF(app.flag = 1,'Closed','Pending')IsCompleated, ");
        sb.Append(" P_Out,CASE WHEN (app.P_IN=0 AND app.P_OUT=0) THEN 'Pending' WHEN (app.P_IN=1 AND app.P_OUT=1) THEN 'Out' ");
        sb.Append(" WHEN (app.P_IN=1 AND app.P_OUT=0) THEN 'IN'   ELSE 'Pending' END AS 'Status', ");
        sb.Append(" if(((DATE('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "')=CURDATE() and DATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "')=CURDATE())),'1','0')CurrentDateCon, ");
        sb.Append(" IFNULL(DATE_FORMAT(app.TockenCreatedDate,'%d-%b-%Y'),'')TockenCreatedDate  ");
        sb.Append(" FROM appointment app INNER JOIN patient_master pm ON pm.PatientID=app.PatientID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=app.TransactionID AND pmh.Type='OPD' INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append(" WHERE app.PatientID<>'' and LedgerTnxNo<>'' AND app.IsConform=1 AND app.IsCancel=0 and app.tokenNo<>''  ");
        if (PName != string.Empty)
            sb.Append(" and app.Pname like '" + PName + "%'");
        if (MRNo != string.Empty)
            sb.Append(" and app.PatientID='" + MRNo + "'");
        if (DoctorID != "0")
            sb.Append(" and app.DoctorID='" + DoctorID + "'");
        if (status == "1")
            sb.Append(" and app.P_IN=0");
        else if (status == "2")
            sb.Append(" and app.P_IN=1 and app.P_OUT=0");
        else if (status == "3")
            sb.Append(" and app.P_OUT=1 and app.P_IN=1");
        else
            sb.Append(" ");
        if (((Util.GetDateTime(fromDate).ToString("yyyy-MM-dd")) == (DateTime.Now.ToString("yyyy-MM-dd"))) && (Util.GetDateTime(toDate).ToString("yyyy-MM-dd") == (DateTime.Now.ToString("yyyy-MM-dd"))))
        {
            sb.Append(" and TockenCreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' ");
        }
        else
        {
            sb.Append(" and app.date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" and app.date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");
        }
        sb.Append("  ORDER BY app.tokenNo+0,IFNULL(app.TockenCreatedDate,app.date)");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string patientStatus(string MRNo, string AppID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE appointment set  P_IN=1,P_INDateTime=now(),P_INCreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' where App_ID=" + AppID + " and PatientID='" + MRNo + "' ");
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
    public string patientOutStatus(string AppID, string status)
    {
        if (status == "1")
        {
            int POut = Util.GetInt(StockReports.ExecuteScalar("Select P_Out from appointment where App_ID=" + AppID + " "));
            if (POut == 1)
            {
                return "1";
            }
            else
            {
                return "0";
            }
        }
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE appointment set  P_Out=1,P_OutDateTime=now(),P_OutCreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' where App_ID=" + AppID + "  ");
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
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveTokenSreen(object Dept)
    {
        List<deptDetail> Data = new JavaScriptSerializer().ConvertToType<List<deptDetail>>(Dept);
        int count = 0;
        if (HttpUtility.UrlDecode(Data[0].buttonType.ToString()) == "Save")
        {
            count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from cpoe_tokenScreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo.ToString()) + "'"));
        }
        if (count == 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                string docDepartmentID = "";
                string docDepartmentName = "";
                for (int i = 0; i < Data.Count; i++)
                {
                    // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_tokenScreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + Data[i].DocDepartmentID + "','" + Data[i].DocDepartmentName + "','" + Data[i].ScreenNo + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
                    if (docDepartmentID != "")
                    {
                        docDepartmentID += "," + HttpUtility.UrlDecode(Data[i].DocDepartmentID) + "";
                        docDepartmentName += "," + HttpUtility.UrlDecode(Data[i].DocDepartmentName) + "";
                    }
                    else
                    {
                        docDepartmentID = "" + HttpUtility.UrlDecode(Data[i].DocDepartmentID) + "";
                        docDepartmentName = "" + HttpUtility.UrlDecode(Data[i].DocDepartmentName) + "";
                    }
                }
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from cpoe_tokenScreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "'");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_tokenScreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + docDepartmentID + "','" + docDepartmentName + "','" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
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
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveRadiologyToken(object Dept)
    {
        List<deptDetail> Data = new JavaScriptSerializer().ConvertToType<List<deptDetail>>(Dept);
        int count = 0;
        if (HttpUtility.UrlDecode(Data[0].buttonType.ToString()) == "Save")
        {
            count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from Radiology_tokenscreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo.ToString()) + "'"));
        }
        if (count == 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                string docDepartmentID = "";
                string docDepartmentName = "";
                for (int i = 0; i < Data.Count; i++)
                {
                    // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_tokenScreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + Data[i].DocDepartmentID + "','" + Data[i].DocDepartmentName + "','" + Data[i].ScreenNo + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
                    if (docDepartmentID != "")
                    {
                        docDepartmentID += "," + HttpUtility.UrlDecode(Data[i].DocDepartmentID) + "";
                        docDepartmentName += "," + HttpUtility.UrlDecode(Data[i].DocDepartmentName) + "";
                    }
                    else
                    {
                        docDepartmentID = "" + HttpUtility.UrlDecode(Data[i].DocDepartmentID) + "";
                        docDepartmentName = "" + HttpUtility.UrlDecode(Data[i].DocDepartmentName) + "";
                    }
                }
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from Radiology_tokenscreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "'");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO Radiology_tokenscreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + docDepartmentID + "','" + docDepartmentName + "','" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
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
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveLaboratoryToken(object Dept)
    {
        List<deptDetail> Data = new JavaScriptSerializer().ConvertToType<List<deptDetail>>(Dept);
        int count = 0;
        if (HttpUtility.UrlDecode(Data[0].buttonType.ToString()) == "Save")
        {
            count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from Laboratory_tokenscreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo.ToString()) + "'"));
        }
        if (count == 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                string docDepartmentID = "";
                string docDepartmentName = "";
                for (int i = 0; i < Data.Count; i++)
                {
                    // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_tokenScreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + Data[i].DocDepartmentID + "','" + Data[i].DocDepartmentName + "','" + Data[i].ScreenNo + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
                    if (docDepartmentID != "")
                    {
                        docDepartmentID += "," + HttpUtility.UrlDecode(Data[i].DocDepartmentID) + "";
                        docDepartmentName += "," + HttpUtility.UrlDecode(Data[i].DocDepartmentName) + "";
                    }
                    else
                    {
                        docDepartmentID = "" + HttpUtility.UrlDecode(Data[i].DocDepartmentID) + "";
                        docDepartmentName = "" + HttpUtility.UrlDecode(Data[i].DocDepartmentName) + "";
                    }
                }
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from Laboratory_tokenscreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "'");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO Laboratory_tokenscreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + docDepartmentID + "','" + docDepartmentName + "','" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
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

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindTokenSreen()
    {
        DataTable dt = StockReports.GetDataTable("Select ID,DocDepartmentID,DocDepartmentName,ScreenNo from  cpoe_tokenScreen where IsActive=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindRadioScreen()
    {
        DataTable dt = StockReports.GetDataTable("Select ID,DocDepartmentID,DocDepartmentName,ScreenNo from  Radiology_tokenscreen where IsActive=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindLaboratoryScreen()
    {
        DataTable dt = StockReports.GetDataTable("Select ID,DocDepartmentID,DocDepartmentName,ScreenNo from  Laboratory_tokenscreen where IsActive=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateCall(string App_ID, string DoctorID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateCall(App_ID, DoctorID);
        return Ret;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateUncall(string App_ID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateUncall(App_ID);
        return Ret;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Hold(string App_ID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.Hold(App_ID);
        return Ret;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateIn(string App_ID, string DoctorID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateIn(App_ID, DoctorID);
        return Ret;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateOut(string App_ID, string DoctorID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateOut(App_ID, DoctorID);
        return Ret;
    }
    public class deptDetail
    {
        public string DocDepartmentID { get; set; }
        public string DocDepartmentName { get; set; }
        public string ScreenNo { get; set; }
        public string buttonType { get; set; }

    }
}
