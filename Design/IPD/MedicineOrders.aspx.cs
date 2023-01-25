using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_MedicineOrders : System.Web.UI.Page
{
    string PID = "";
    string TID = "";
    string LabType = "";

    string LoginType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] == null)
            TID = Request.QueryString["TID"].ToString();
        else
            TID = Request.QueryString["TransactionID"].ToString();



        if (Request.QueryString["PatientID"] == null)
            PID = Request.QueryString["PID"].ToString();
        else
            PID = Request.QueryString["PatientID"].ToString();

        lblMsg.Text = "";


        spnTransactionID.InnerText = TID;
        spnPatientID.InnerText = PID;

        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            txtSelectDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            CalendarExtender1.StartDate = DateTime.Now;

        }

    }

    [WebMethod(EnableSession = true)]
    public static string GetOrderData(string PatientId, string TransactionId, string FromDate, string ToDate)
    {
        DataTable appointmentDetails = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT cr.PatientId,cr.Id OrId,cr.IndentNo IndentNo,cr.IsIndentDone, IF(cr.IsIndentDone=1,IF(fid.ReceiveQty>0,'Transfered To Ward','Indent Done'),'Indent Not Done ')Status,  ");
            sb.Append(" cr.ItemId,im.TypeName ItemName,cr.Dose,cr.Duration,cr.Timing,cr.Meal,cr.Route,   ");
            sb.Append("  IF((CONCAT(cr.AutoStopDate,' ' ,cr.AutoStopTime)>=NOW() AND CONCAT(cr.StartDate,' ' ,cr.StartTime)<=NOW() AND IFNULL(fid.ReceiveQty,0)>0 ),1,0)CanGiveMedicne, ");
            sb.Append(" DATE_FORMAT(CONCAT(cr.StartDate,' ' ,cr.StartTime),'%d-%b-%Y %r')StartDateTime,   ");
            sb.Append(" DATE_FORMAT(CONCAT(cr.AutoStopDate,' ' ,cr.AutoStopTime),'%d-%b-%Y %r')StopDateTime,   ");
            sb.Append(" IF(cr.IsIndentDone=1,IF(fid.ReceiveQty>0,1,0),0)IsTransferedToWard,  ");

            sb.Append(" IF(IFNULL(im.TypeofmeasurmentQty,0)>0,");
            sb.Append(" CONCAT(ROUND(fid.ReceiveQty,2), ' ( ', ROUND(fid.ReceiveQty,2 ),' X ',ROUND(im.TypeofmeasurmentQty,2),' = ',ROUND((fid.ReceiveQty * im.TypeofmeasurmentQty) ,2),' ',im.TypeofmeasurmentUnit,' )' ),");
            sb.Append(" ROUND(fid.ReceiveQty,2))RecivedQty, ");
            sb.Append(" IF(IFNULL(im.TypeofmeasurmentQty,0)>0,  ");
            sb.Append(" CONCAT(ROUND(fid.ReqQty,2), ' ( ', ROUND(fid.ReqQty,2 ),' X ',ROUND(im.TypeofmeasurmentQty,2),' = ',  ");
            sb.Append(" ROUND((fid.ReqQty * im.TypeofmeasurmentQty) ,2),' ',im.TypeofmeasurmentUnit,' )' ),  ");
            sb.Append(" ROUND(fid.ReqQty,2))RequestedQty ,  ");

            sb.Append(" IF(IFNULL(im.TypeofmeasurmentQty,0)>0,  ");
            sb.Append(" ROUND( ((fid.ReceiveQty*im.TypeofmeasurmentQty)-(SELECT  IFNULL(SUM(tam.Quantity),0)   ");
            sb.Append(" FROM tenwek_activemedication  tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID  )),2),  ");
            sb.Append(" ROUND((fid.ReceiveQty-(SELECT  IFNULL(SUM(tam.Quantity),0)   ");
            sb.Append("  FROM tenwek_activemedication  tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID  )),2 ))RemainingQty ,  ");

            sb.Append(" IF(IFNULL(im.TypeofmeasurmentQty,0)>0,  ");
            sb.Append(" CONCAT( ROUND( ((fid.ReceiveQty*im.TypeofmeasurmentQty)-(SELECT  IFNULL(SUM(tam.Quantity),0)   ");
            sb.Append(" FROM tenwek_activemedication  tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID  )),2),' ', im.TypeofmeasurmentUnit),  ");
            sb.Append(" ROUND((fid.ReceiveQty-(SELECT  IFNULL(SUM(tam.Quantity),0)   ");
            sb.Append("  FROM tenwek_activemedication  tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID  )),2 ) )RemainingQtyDisplay ,  ");

            sb.Append(" IF(IFNULL(im.TypeofmeasurmentQty,0)>0,CONCAT( ROUND((SELECT  IFNULL(SUM(tam.Quantity),0)FROM tenwek_activemedication  ");
            sb.Append("  tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID ),2),' ', im.TypeofmeasurmentUnit),  ");
            sb.Append("   ROUND((SELECT  IFNULL(SUM(tam.Quantity),0)FROM tenwek_activemedication  ");
            sb.Append(" tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID ),2)) GivenQtyToDisplay,  ");

            sb.Append(" ROUND( IF(IFNULL(im.TypeofmeasurmentQty,0)>0,  ");
            sb.Append(" (SELECT  IFNULL(SUM(tam.Quantity),0)FROM tenwek_activemedication   ");
            sb.Append("  tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID),  ");
            sb.Append("    (SELECT  IFNULL(SUM(tam.Quantity),0)FROM tenwek_activemedication  ");
            sb.Append(" tam WHERE tam.IsActive=1 AND tam.OrderId=cr.ID )),2 )GivenQty  ");

            sb.Append(" FROM crm_reminders_status cr   ");
            sb.Append(" INNER JOIN  f_itemmaster im  ");
            sb.Append(" ON im.ItemID=cr.ItemId  ");
            sb.Append(" INNER JOIN f_indent_detail_patient fid ON fid.IndentNo=cr.IndentNo	   ");
            sb.Append(" WHERE cr.PatientId='"+PatientId+"' AND cr.TransactionId='"+TransactionId+"' AND    cr.ReminderID=4 AND cr.IsMedicineIndent=1 AND cr.IsIndentDone=1  ");
            sb.Append("   AND  cr.StartDate>='" + Util.GetDateTime(FromDate.ToString()).ToString("yyyy-MM-dd") + "' AND CR.StartDate<='" + Util.GetDateTime(ToDate.ToString()).ToString("yyyy-MM-dd") + "' ");


            appointmentDetails = StockReports.GetDataTable(sb.ToString());


            if (appointmentDetails.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }








    [WebMethod(EnableSession = true, Description = "Medication")]
    public static string Medication(int OrderId, string Date, string Time, string Dose, string Route, string Frequency, string PId, string Tid, string ItemId, string ItemName, int Qty, string Remark)
    {
        string LedgerTransactionNo = string.Empty;
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            //Discontinued ORDER 

            //NEW ENTRY AGAINSET DISCONTINUED ORDERED
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  tenwek_activemedication ");
            sb.Append(" (PatientId,TransactionId, OrderId,DoseDate,DoseTime,EntryBy,ItemId,ItemName,Route,Frequency,Dose,Quantity,Remark )  ");
            sb.Append("  VALUES(@PatientId,@TransactionId, @OrderId,@DoseDate,@DoseTime,@EntryBy,@ItemId,@ItemName,@Route,@Frequency,@Dose ,@Quantity,@Remark)");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                PatientId = PId,
                TransactionId = Tid,
                OrderId = OrderId,
                DoseDate = Util.GetDateTime(Date).ToString("yyyy-MM-dd"),
                DoseTime = Util.GetDateTime(Time).ToString("HH:mm:ss"),
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                ItemId = ItemId,
                ItemName = ItemName,
                Route = Route,
                Frequency = Frequency,
                Dose = Dose,
                Quantity = Util.GetInt(Qty),
                Remark = Remark
            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Given Successfully" });

            }
            else
            {
                tnx.Rollback();
                //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }









}

