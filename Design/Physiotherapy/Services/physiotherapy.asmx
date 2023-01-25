<%@ WebService Language="C#" Class="physiotherapy" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]

public class physiotherapy : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SavePhyApp(List<Marker> Data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            // int k = Data.Count;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT app.TypeOfApp,app.PatientType,app.PurposeOfVisit,app.PurposeOfVisitID,pm.PatientID,pm.Title,pm.Pfirstname,pm.PlastName,pm.Pname,pm.Mobile,pm.Gender,pm.MaritalStatus,pm.Email,'Old Patient' visitType,pm.City,pm.Country");
            sb.Append(" ,DATE_FORMAT(pm.DOB,'%Y-%m-%d') AS DOB,Get_Current_Age(pm.PatientID)Age  FROM patient_master pm  inner join appointment app on app.PatientID=pm.PatientID");
            sb.Append(" WHERE pm.PatientID='" + Data[0].PatientID + "' and TransactionID='" +Data[0].TransactionID  + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            for (int i = 0; i < Data.Count; i++)
            {
              //  string AppNo = StockReports.ExecuteScalar("Select IFNULL(MAX(AppNo),0)+1 AppNo from Appointment where Date='" + Util.GetDateTime(Data[i].SelectedDate).ToString("yyyy-MM-dd") + "' and DoctorID='" + Data[i].DoctorID + "' ");
                int AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + Data[i].DoctorID + "','" + Util.GetDateTime(Data[i].SelectedDate).ToString("yyyy-MM-dd") + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));

                appointment app = new appointment();
                app.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                app.PatientID = Data[0].PatientID;
                app.Title = dt.Rows[0]["Title"].ToString();
                app.PfirstName = dt.Rows[0]["Pfirstname"].ToString();
                app.plastName = dt.Rows[0]["PlastName"].ToString();
                app.Pname = dt.Rows[0]["Pname"].ToString();
                app.ContactNo = dt.Rows[0]["Mobile"].ToString();
                app.MaritalStatus = dt.Rows[0]["MaritalStatus"].ToString();
                app.Age = dt.Rows[0]["Age"].ToString();
                app.DOB = Util.GetDateTime(dt.Rows[0]["DOB"].ToString());
                app.Email = dt.Rows[0]["Email"].ToString();
                app.VisitType = dt.Rows[0]["visitType"].ToString();
                app.TypeOfApp = dt.Rows[0]["TypeOfApp"].ToString();
                app.PatientType = dt.Rows[0]["PatientType"].ToString();
                app.City = dt.Rows[0]["City"].ToString();
                app.Nationality = dt.Rows[0]["Country"].ToString();
                app.Sex = dt.Rows[0]["Gender"].ToString();
                app.PurposeOfVisit = dt.Rows[0]["PurposeOfVisit"].ToString();
                app.PurposeOfVisitID = Util.GetInt(dt.Rows[0]["PurposeOfVisitID"].ToString()); 
                app.Date = Util.GetDateTime(Data[i].SelectedDate);
                app.Time = Util.GetDateTime(Data[i].SelectTime.Split('#')[0]);
                int len = Data[i].SelectTime.Split('#').Length;
                string AppEndTime = Data[i].SelectTime.Split('#')[len - 1];
                app.EndTime = Util.GetDateTime(AppEndTime);
                app.EntryUserID = HttpContext.Current.Session["ID"].ToString();
                app.DoctorID = Data[i].DoctorID;
                app.Amount = Util.GetDecimal(Data[i].Rate);
                app.PanelID = Util.GetInt(Data[i].PanelID);
                app.ItemID = Util.GetString(Data[i].ItemId);
                app.SubCategoryID = Data[i].SubcategoryID;
                app.hashCode = Util.getHash();
                app.AppNo = Util.GetInt(AppNo);
                app.IpAddress = HttpContext.Current.Request.UserHostAddress;
                app.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                string AppID = app.Insert();

                if (AppID == "")
                {
                    tnx.Rollback();

                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update appointment SET Physiotherapy_ID='" + Data[i].TransactionID + "' where APP_ID='" + AppID + "'");

                string[] SelectTime = Data[i].SelectTime.Split('#');
                for (int a = 0; a < SelectTime.Length; a++)
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO appointment_detail(App_ID,DoctorID,DATE,TIME)VALUES(" + AppID + ",'" + Util.GetString(Data[i].DoctorID) + "','" + Util.GetDateTime(Data[i].SelectedDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(SelectTime[a]).ToString("HH:mm") + "');");
                }
            }

            tnx.Commit();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        
        return "1";
    }
    public class Marker
    {
        public string SelectTime { get; set; }
        public string SelectedDate { get; set; }
        public string DocScheduleTime { get; set; }
        public string Rate { get; set; }
        public string SubcategoryID { get; set; }
        public string DoctorID { get; set; }
        public string PanelID { get; set; }
        public string ItemId { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PshyBookedHistory(string PatientID,string TransactionID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT app.PurposeOfVisitID,app.PatientID,App_ID,AppNo,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
        sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(app.TIME,'%l: %i %p')AppTime");
        sb.Append(" ,DATE_FORMAT(app.DATE,'%d-%b-%Y')AppDate,IsReschedule, app.IsCancel,app.CancelReason, ");
        sb.Append(" DATE_FORMAT(ConformDate,'%d-%b-%y %l:%i %p')ConformDate, ");
        sb.Append(" CONCAT(app.DATE,' ',app.TIME)AppDateTime,ContactNo,'' STATUS,app.Amount,IFNULL(lt.GrossAmount,0) PaidAmount,IF(IsConform=1,'Yes','No')IsConform FROM appointment app  LEFT OUTER JOIN f_ledgertransaction lt ON app.LedgerTnxNo=lt.LedgerTransactionNo AND app.IsCancel=0 ");
        sb.Append(" WHERE  app.IsCancel=0 AND app.PatientID='" + PatientID + "'  AND Physiotherapy_ID='" + TransactionID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
           return rtrn;

        }
        else
        {
            return rtrn;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdatePshyAppointmentStatus(string BookAppID,String Reason)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AllUpdate Updt = new AllUpdate();
            string result = Updt.UpdateAppointmentStatus(BookAppID, "", "1", "", Reason, tnx);

            if (result == "")
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}