using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;

public partial class Design_IPD_BillCancellation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    
    }
    [WebMethod]
    public static string BillCancellationSearch(string PatientID, string TransactionNo, string PName, string searchType)
    {
        if (TransactionNo != "")
            TransactionNo = StockReports.getTransactionIDbyTransNo(TransactionNo.Trim());//"ISHHI" +
        
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();

        //string IPDNo = StockReports.ExecuteScalar(" SELECT transactionID  FROM patient_medical_history WHERE TransNo = '" + TransactionNo + "' ");
        //if (IPDNo == "")
        //{ return ""; }
        //else
        //{
        //    TransactionNo = IPDNo;//"ISHHI" + 
        //}
        sb.Append("SELECT IP.BillNo BillNo,IP.TotalBilledAmt,IP.TransactionID,IP.TransNo IPDNo,IP.PatientID,PM.PName from patient_medical_history IP ");//f_ipdadjustment
        sb.Append("  INNER JOIN patient_master PM on IP.PatientID=PM.PatientID WHERE IFNULL(IP.BillNo,'')<>'' ");
        if (PatientID != "")
            sb.Append(" AND IP.PatientID='" + PatientID + "'");
        if (PName != "")
            sb.Append(" AND PM.PName like '" + PName + "%'");
        if (TransactionNo != "")
            sb.Append(" AND IP.TransactionID='" + TransactionNo + "' ");//ISHHI
        if (searchType == "1")
            sb.Append(" AND IP.IsBilledClosed=0");
        else
            sb.Append(" AND IP.IsBilledClosed=1");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string billCancel(string PatientID, string TransactionNo, string BillNo, string searchType, string Reason)
    {
        try
        {

           
            if (Resources.Resource.AllowFiananceIntegration == "2")//
            {
                string TransactionID = StockReports.ExecuteScalar("Select pmh.Transno from patient_medical_history pmh where pmh.TransactionID='" + TransactionNo + "'");
                if (TransactionID != "")
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(TransactionID) > 0)
                    {
                       

                        return "3";


                    }
                }
            }
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_medical_history WHERE TransactionID='" + TransactionNo + "' AND IFNULL(PanelInvoiceNo,'')<>'' "));
            if (count > 0)
            {
                return "2";
            }
            string Iscancel = "";
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            string str = "select max(PatientIPDProfile_ID) from patient_ipd_profile where TransactionID='" + TransactionNo + "' and status='out'";
            string IPDProfile = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
            str = "Select CONCAT(UserID,'#',BillDate)UserBillDate from patient_medical_history where TransactionID='" + TransactionNo + "'";
            string BillGenerateUserID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));


            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            if (searchType == "1")
            {
                Iscancel = CreateStockMaster.CancelBillNo(BillNo, TransactionNo, IPDProfile, Tranx);
                if (Iscancel == "1")
                {
                    BillCancellation BillCan = new BillCancellation(Tranx);
                    BillCan.BillNo = BillNo.Trim();
                    BillCan.TransactionID = TransactionNo.Trim();
                    BillCan.PatientID = PatientID.Trim();
                    BillCan.CancelDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    BillCan.CancelUserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                    BillCan.CancelReason = Reason.Trim();
                    BillCan.BillDate = Util.GetDateTime(BillGenerateUserID.Split('#')[1].ToString());
                    BillCan.BillGenerateUserID = BillGenerateUserID.Split('#')[0].ToString();
                    BillCan.IPAddress = HttpContext.Current.Request.UserHostAddress;
                    Iscancel = BillCan.Insert().ToString();
                }

                if (Util.GetInt(Iscancel) > 0)
                {

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from d_f_LedgerTransaction where TransactionID='" + TransactionNo.Trim() + "'");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from d_f_LedgertnxDetail where TransactionID='" + TransactionNo.Trim() + "'");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from d_f_ipdAdjustment where TransactionID='" + TransactionNo.Trim() + "'");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM d_f_surgery_doctor WHERE SurgeryTransactionID in (SELECT SurgeryTransactionID FROM d_f_surgery_discription WHERE TransactionID='" + TransactionNo.Trim() + "')");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete FROM d_f_surgery_discription WHERE TransactionID='" + TransactionNo.Trim() + "'");




                }

                if (Util.GetInt(Iscancel) > 0)
                {
                    Tranx.Commit();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "1";

                }
                else
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }
            else
            {

                BillFinalisedCancel BillFin = new BillFinalisedCancel(Tranx);
                BillFin.BillNo = BillNo.Trim();
                BillFin.TransactionID = TransactionNo.Trim();
                BillFin.PatientID = PatientID.Trim();
                BillFin.CancelDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                BillFin.CancelUserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                BillFin.CancelReason = Reason.Trim();
                BillFin.BillDate = Util.GetDateTime(BillGenerateUserID.Split('#')[1].ToString());
                BillFin.BillGenerateUserID = BillGenerateUserID.Split('#')[0].ToString();
                BillFin.IPAddress = HttpContext.Current.Request.UserHostAddress;
                Iscancel = BillFin.Insert().ToString();

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update patient_medical_history Set IsBilledClosed=0 WHERE TransactionID='" + TransactionNo.Trim() + "'");
                if (Util.GetInt(Iscancel) > 0)
                {
                    Tranx.Commit();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "1";

                }
                else
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }

    [WebMethod(EnableSession = true)]
    public static string CheckDataInFinance(string TID)
    {
        if (Resources.Resource.AllowFiananceIntegration == "2")//
        {
            string Transno = StockReports.ExecuteScalar("Select pmh.TransNo from patient_medical_history pmh where pmh.TransactionID='" + TID + "'");
            if (AllLoadData_IPD.CheckDataPostToFinance(Transno) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Patient's Final Bill Already Posted To Finance..." });
            }
            else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." }); }
        }
        else
        { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." }); }
    }

}
