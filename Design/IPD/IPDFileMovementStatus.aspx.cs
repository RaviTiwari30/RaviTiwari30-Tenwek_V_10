using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
public partial class Design_IPD_IPDFileMovementStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSendDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = "00:00 AM";

        }
    }

    [WebMethod(EnableSession = true)]
    public static string Send(string date, string time, string takenby, string takendept, string sendremarks, string TransactionID, string PatientID, string fileID, string recievetakenby, string recieveremarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD _ExcuteCMD = new ExcuteCMD();
        try
        {
            string str = "", message = "";
            if (fileID == "0")
            {
                str = @"INSERT INTO ipd_patientfilemovementdetail (
                                  TransactionID,
                                  PatientID,
                                  FileSendDate,
                                  FileSendTime,
                                  FileSendBy,
                                  FileTakenBy,
                                  FileTakenDepartment,
                                  SendRemarks,
                                  IPAddress,
                                  HostName,
                                  CentreID) values(@TransactionID,
                                  @PatientID,
                                  @FileSendDate,
                                  @FileSendTime,
                                  @FileSendBy,
                                  @FileTakenBy,
                                  @FileTakenDepartment,
                                  @SendRemarks,
                                  @IPAddress,
                                  @HostName,
                                  @CentreID)";
                message = "File Send Successfully";
            }
            else
            {
                str = @"update ipd_patientfilemovementdetail set  FileReciveDateTime=NOW(),FileRecieveBy=@FileRecieveBy,RecieveRemarks=@RecieveRemarks,FileBringby=@FileBringby,IsFileRecieve=1 where ID=@ID";
                message = "File Recieved Successfully";
            }
            _ExcuteCMD.DML(tnx, str, CommandType.Text, new
            {
                TransactionID = TransactionID,
                PatientID = PatientID,
                FileSendDate = Util.GetDateTime(date).ToString("yyyy-MM-dd"),
                FileSendTime = Util.GetDateTime(time).ToString("HH:mm:ss"),
                FileSendBy = HttpContext.Current.Session["ID"].ToString(),
                FileTakenBy = takenby,
                FileTakenDepartment = takendept,
                SendRemarks = sendremarks,
                IPAddress = All_LoadData.IpAddress(),
                HostName = Environment.MachineName,
                CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                RecieveRemarks = recieveremarks,
                FileBringby = recievetakenby,
                ID = fileID,
                FileRecieveBy = HttpContext.Current.Session["ID"].ToString(),
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getDetail(string TransactionID)
    {
        int IsSend = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM ipd_PatientFilemovementDetail WHERE IsFileRecieve=0 AND IsCancel=0 and TransactionID='" + TransactionID + "';"));
        int FileID = Util.GetInt(StockReports.ExecuteScalar("SELECT Max(ID) FROM ipd_PatientFilemovementDetail WHERE IsFileRecieve=0 AND IsCancel=0 and TransactionID='" + TransactionID + "';"));

        string str = @"SELECT f.ID as FileID,DATE_FORMAT(FileSendDate,'%d-%b-%Y')FileSendDate,TIME_FORMAT(FileSendTime,'H:%i %p')FileSendTime,
em.NAME FileSendBy,
FileTakenBy,
Ifnull(rm.RoleName,'')FileTakenDepartment,
SendRemarks,ifnull(e1.NAME,'') FileRecieveBy,ifnull(DATE_FORMAT(f.FileReciveDateTime,'%d-%b-%Y'),'')FileReciveDateTime,
ifnull(f.RecieveRemarks,'')RecieveRemarks,ifnull(e2.NAME,'') CancelBy,ifnull(f.CancelRemarks,'')CancelRemarks,
ifnull(DATE_FORMAT(f.CancelDateTime,'%d-%b-%Y'),'')CancelDateTime ,
IF(f.IsCancel=1,'Cencelled',IF(f.IsFileRecieve=0,'Pending to Recieve','Recieved'))fileStatus,FileBringby
FROM ipd_PatientFilemovementDetail f
INNER JOIN employee_MAster em ON em.EmployeeID= f.FileSendBy
LEFT JOIN employee_MAster e1 ON e1.EmployeeID= f.FileRecieveBy
LEFT JOIN employee_MAster e2 ON e2.EmployeeID= f.CancelBy
left Join f_rolemaster rm on rm.ID=f.FileTakenDepartment
WHERE TransactionID=" + TransactionID + " ORDER BY f.ID DESC ";
        var dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsSend = IsSend, response = dt, FileID = FileID });
    }

    [WebMethod(EnableSession = true)]
    public static string CancelReq(string reqID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD _ExcuteCMD = new ExcuteCMD();
        try
        {
            string str = @"update ipd_patientfilemovementdetail set   IsCancel=1,
      CancelBy=@CancelBy,
      CancelDateTime=NOW(),
      CancelRemarks=@CancelRemarks  where ID=@ID";


            _ExcuteCMD.DML(tnx, str, CommandType.Text, new
            {
                CancelBy = HttpContext.Current.Session["ID"].ToString(),
                CancelRemarks = Remarks,
                ID = reqID
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "File Send Canclled Successfully" });
        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("SELECT rm.`ID`,rm.`RoleName` FROM  `f_centre_role` fcr INNER JOIN `f_rolemaster` rm ON fcr.`RoleID`=rm.`ID` WHERE  centreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcr.`isActive`=1 AND rm.`Active`=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}
