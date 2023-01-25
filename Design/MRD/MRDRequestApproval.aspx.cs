using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_MRDRequestApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginType"] == null && Session["UserName"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                //if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                //}
                txtFromDate.Text = System.DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
                txtToDate.Text = System.DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
                fc1.EndDate = DateTime.Now.AddDays(0);
                calExeto.EndDate = DateTime.Now.AddDays(0);
            }
            bindPatientType();
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }
    private void bindPatientType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(pmh.TYPE)PType FROM patient_medical_history pmh ORDER BY TYPE");
        ddlPatientType.DataSource = dt;
        ddlPatientType.DataTextField = "PType";
        ddlPatientType.DataValueField = "PType";
        ddlPatientType.DataBind();
        ddlPatientType.Items.Insert(0, new ListItem("ALL"));
        ddlPatientType.SelectedIndex = 2;
    }
    [WebMethod]
    public static string SearchMRDRequisition(string MRNo, string PName, string IPDNo, string fromDate, string toDate, string MRDFileNo, string Status, string ReturnStatus, string pType)
    {
        StringBuilder sb = new StringBuilder();

        if (ReturnStatus == "1")
        {
            sb.Append("    SELECT pmh.type, mfr.`MRDReturnID` AS MRDRequisitionID,mfr.PatientID,mfr.TransactionID,IF(pmh.TYPE='IPD', pmh.TransNo,'')TransNo,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,pm.Gender, ");
                  sb.Append("    IFNULL(pm.`Age`,'')DOB, DATE_FORMAT(mfr.ReturnRequestedDate,'%d-%b-%y %l:%i %p') AS RequestedDate, ");
                  sb.Append("    CONCAT(em.Title,'',em.Name) AS RequestedBy,rm.DeptName,IF(mra.unApproved=1,1,0)UnApproved, ");
                  sb.Append("    IF(mra.Rejected=1,1,0)Rejected,'0'AS STATUS, ReturnIsIssue,ReturnIsApproved AS IsApproved ,DATE_FORMAT(mfr.RejectedDate,'%d-%b-%y')RejectedDate, ");
                  sb.Append("    CONCAT(em1.Title,'',em1.Name) AS RejectedBy , mfr.`ReturnRemarks` as Remarks ");
                  sb.Append("    FROM mrd_fileReturn mfr  ");
                  sb.Append("    INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=mfr.TransactionID  ");  
                  sb.Append("    INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
                  sb.Append("    INNER JOIN mrd_file_master mfm ON mfm.FileID=mfr.FileID  ");
                  sb.Append("    INNER JOIN mrd_RequestApprovel mra ON mra.RoleID=mfr.ReturnRequestedRoleID AND mra.EmployeeID='EMP001' ");
                  sb.Append("    INNER JOIN employee_master em ON em.EmployeeID=mfr.ReturnRequestedBy  ");
                  sb.Append("    LEFT JOIN employee_master em1 ON em1.EmployeeID=mfr.ReturnRejectedBy  ");
                  sb.Append("    INNER JOIN f_rolemaster rm ON rm.ID=mfr.ReturnRequestedRoleID  ");
                  sb.Append(" WHERE  mfr.ReturnIsApproved='" + Status + "' ");
            if (PName.Trim() != string.Empty)
                sb.Append("AND mpw.PatientName LIKE '%" + PName.Trim() + "%' ");
            if (MRNo.Trim() != string.Empty)
                sb.Append("AND mfr.PatientID = '" + MRNo.Trim() + "' ");
            if (IPDNo.Trim() != string.Empty)
            {
                IPDNo = Util.GetString(StockReports.getTransactionIDbyTransNo(IPDNo.Trim()));
                sb.Append("AND mfr.TransactionID = '" + IPDNo + "' ");
            }
            if (MRDFileNo.Trim() != string.Empty)
                sb.Append("AND mfm.FileID = '" + MRDFileNo.Trim() + "' ");
            if (MRDFileNo.Trim() == string.Empty && IPDNo.Trim() == string.Empty)
            {
                if (fromDate.Trim() != string.Empty && toDate.Trim() != string.Empty)
                {
                    sb.Append("AND Date(mfr.ReturnRequestedDate) >= '" + Util.GetDateTime(fromDate.Trim()).ToString("yyyy-MM-dd") + "' AND Date(mfr.ReturnRequestedDate)<='" + Util.GetDateTime(toDate.Trim()).ToString("yyyy-MM-dd") + "' ");
                }
            }
        }
        else
        {

            sb.Append("SELECT pmh.type, mfr.MRDRequisitionID,mfr.PatientID,mfr.TransactionID,IF(pmh.TYPE='IPD', pmh.TransNo,'')TransNo,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,pm.Gender,IFNULL(pm.`Age`,'')DOB, ");
            sb.Append("DATE_FORMAT(mfr.RequestedDate,'%d-%b-%y %l:%i %p') AS RequestedDate,CONCAT(em.Title,'',em.Name) AS RequestedBy,rm.DeptName,if(mra.unApproved=1,1,0)UnApproved,IF(mra.Rejected=1,1,0)Rejected,'" + Status + "'as Status, ");
            sb.Append("IsIssue,IsApproved,DATE_FORMAT(mfr.RejectedDate,'%d-%b-%y')RejectedDate,CONCAT(em1.Title,'',em1.Name) AS RejectedBy , mfr.`Remarks`");
            sb.Append("FROM mrd_fileRequisition mfr INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=mfr.TransactionID  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`");
            sb.Append("INNER JOIN mrd_file_master mfm ON mfm.FileID=mfr.FileID ");
            sb.Append("LEFT JOIN mrd_RequestApprovel mra ON mra.RoleID=mfr.RequestedRoleID AND mra.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
            sb.Append("INNER JOIN employee_master em ON em.EmployeeID=mfr.RequestedBy ");
            sb.Append("left JOIN employee_master em1 ON em1.EmployeeID=mfr.RejectedBy ");
            sb.Append("INNER JOIN f_rolemaster rm ON rm.ID=mfr.RequestedRoleID ");
            sb.Append("WHERE  mfr.IsApproved='" + Status + "'  and mfr.CentreID="+Util.GetInt(HttpContext.Current.Session["CentreID"])+" ");
            if (pType != "ALL")
            {
                sb.Append(" and pmh.Type='" + pType + "' ");
            }
            if (PName.Trim() != string.Empty)
                sb.Append("AND mpw.PatientName LIKE '%" + PName.Trim() + "%' ");
            if (MRNo.Trim() != string.Empty)
                sb.Append("AND mfr.PatientID = '" + MRNo.Trim() + "' ");
            if (IPDNo.Trim() != string.Empty)
            {
                IPDNo = Util.GetString(StockReports.getTransactionIDbyTransNo(IPDNo.Trim()));
                sb.Append("AND mfr.TransactionID = '" + IPDNo.Trim() + "' ");
            }
            if (MRDFileNo.Trim() != string.Empty)
                sb.Append("AND mfm.FileID = '" + MRDFileNo.Trim() + "' ");
            if (MRDFileNo.Trim() == string.Empty && IPDNo.Trim() == string.Empty)
            {
                if (fromDate.Trim() != string.Empty && toDate.Trim() != string.Empty)
                {
                    sb.Append("AND Date(mfr.RequestedDate) >= '" + Util.GetDateTime(fromDate.Trim()).ToString("yyyy-MM-dd") + "' AND Date(mfr.RequestedDate)<='" + Util.GetDateTime(toDate.Trim()).ToString("yyyy-MM-dd") + "' ");
                }
            }
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession=true)]
    public static string ApprovedRequisition(string RequestID, string Status, string Reason,string ReturnStatus)
    {
         MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            string strApproved = "";

            if (ReturnStatus == "0")
            {
                if (Status == "1")
                {
                    strApproved = "UPDATE mrd_fileRequisition SET IsApproved=1, ApprovedDate=NOW(),ApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ApprovedIPAddress='" + All_LoadData.IpAddress() + "' WHERE MRDRequisitionID='" + RequestID.Trim() + "' and CentreID="+Util.GetInt(HttpContext.Current.Session["CentreID"])+" ";
                    //All_LoadData.updateNotification(RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, tranX, "MRD");
                    // Notification_Insert.notificationInsert(37,RequestID,tranX,"","",181,DateTime.Now.ToString("yyyy-MM-dd"),"");
                }
                if (Status == "2")
                {
                    strApproved = "UPDATE mrd_fileRequisition SET IsApproved=2,UnApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UnApprovedDate=Now() WHERE MRDRequisitionID='" + RequestID.Trim() + "' AND IsIssue=0  and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "";
                    // All_LoadData.updateNotification(RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, tranX, "MRD");
                    // Notification_Insert.notificationInsert(42, RequestID,tranX,"", "",181, DateTime.Now.ToString("yyyy-MM-dd"),"");
                }
                if (Status == "3")
                {
                    strApproved = "UPDATE mrd_fileRequisition SET IsApproved=3, RejectedDate=NOW(),RejectedBy='" + HttpContext.Current.Session["ID"].ToString() + "',RejectionReason='" + Reason + "' WHERE MRDRequisitionID='" + RequestID.Trim() + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " ";
                    // All_LoadData.updateNotification(RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, tranX, "MRD");
                    // Notification_Insert.notificationInsert(41,RequestID,tranX, "", "", 181, DateTime.Now.ToString("yyyy-MM-dd"), "");
                }
                if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strApproved) == 0)
                {
                    tranX.Rollback();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                else
                {
                    if (Status == "2")
                    {
                        string strUNApproved = "INSERT INTO mrd_FileRequisitionUnApproved (RequisitionID,UnApprovedBy,UnApprovedDateTime,IPAddress,CentreID) VALUES ('" + RequestID.Trim() + "','" + HttpContext.Current.Session["ID"].ToString() + "',NOW(),'" + All_LoadData.IpAddress() + "',"+Util.GetInt(HttpContext.Current.Session["CentreID"])+")";
                        if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strUNApproved) == 0)
                        {
                            tranX.Rollback();
                            con.Close();
                            con.Dispose();
                            return "0";
                        }
                    }
                    tranX.Commit();
                    return "1";
                }
            }

            else {


                if (Status == "1")
                {
                    strApproved = "UPDATE mrd_fileReturn SET ReturnIsApproved=1, ReturnApprovedDate=NOW(),ReturnApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ReturnApprovedIPAddress='" + All_LoadData.IpAddress() + "' WHERE MRDReturnID='" + RequestID.Trim() + "' AND CentreID="+HttpContext.Current.Session["CentreID"]+" ";
                    //All_LoadData.updateNotification(RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, tranX, "MRD");
                    // Notification_Insert.notificationInsert(37,RequestID,tranX,"","",181,DateTime.Now.ToString("yyyy-MM-dd"),"");
                }
                if (Status == "2")
                {
                    strApproved = "UPDATE mrd_fileReturn SET ReturnIsApproved=2,UnApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UnApprovedDate=Now() WHERE MRDReturnID='" + RequestID.Trim() + "' AND ReturnIsIssue=0 AND CentreID=" + HttpContext.Current.Session["CentreID"] + " ";
                    // All_LoadData.updateNotification(RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, tranX, "MRD");
                    // Notification_Insert.notificationInsert(42, RequestID,tranX,"", "",181, DateTime.Now.ToString("yyyy-MM-dd"),"");
                }
                if (Status == "3")
                {
                    strApproved = "UPDATE mrd_fileReturn SET ReturnIsApproved=3, RejectedDate=NOW(),ReturnRejectedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ReturnRejectionReason='" + Reason + "' WHERE MRDReturnID='" + RequestID.Trim() + "' AND CentreID=" + HttpContext.Current.Session["CentreID"] + "";
                    // All_LoadData.updateNotification(RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, tranX, "MRD");
                    // Notification_Insert.notificationInsert(41,RequestID,tranX, "", "", 181, DateTime.Now.ToString("yyyy-MM-dd"), "");
                }
                if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strApproved) == 0)
                {
                    tranX.Rollback();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                else
                {
                    if (Status == "2")
                    {
                        string strUNApproved = "INSERT INTO mrd_fileReturnunapproved (ReturnId,ReturnUnApprovedBy,ReturnUnApprovedDateTime,ReturnIPAddress,CentreID) VALUES ('" + RequestID.Trim() + "','" + HttpContext.Current.Session["ID"].ToString() + "',NOW(),'" + All_LoadData.IpAddress() + "',"+HttpContext.Current.Session["CentreID"]+")";
                        if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strUNApproved) == 0)
                        {
                            tranX.Rollback();
                            con.Close();
                            con.Dispose();
                            return "0";
                        }
                    }
                    tranX.Commit();
                    return "1";
                }
 
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
}