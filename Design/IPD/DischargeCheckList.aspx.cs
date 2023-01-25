using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;

public partial class Design_IPD_DischargeCheckList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (!IsPostBack)
        {

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["UserID"] = Session["ID"].ToString(); ;
            string a = ViewState["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();

            ViewState["TransID"] = TID;
            dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            caldate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
            {
                caldate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
            }
            else
            {
                caldate.EndDate = DateTime.Now;
            }
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");

            caldate.EndDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readOnly", "true");
    }


    [WebMethod(EnableSession = true)]
    public static string BindPatientDetail(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,TransactionID,PatientID,IsAware,AwareRemarks,IsConsumables,ConsumablesRemarks,IsDrugsReturn,DrugsReturnRemarks, ");
        sb.Append(" IsTTO,TTORemarks,IsEnsureDS,EnsureDSRemarks,IsSigned,SignedRemarks,IsRefferal,RefferalRemarks,IsVenflon,VenflonRemarks, ");
        sb.Append(" IsWound,WoundRemarks,IsDischrageLog,DischargeLogRemarks,IsEnsureBilling,EnsureBillingRemarks,IsCheckout,CheckoutRemarks,CreateDate, ");
        sb.Append(" IF(IFNULL(CreateBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreateDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'1')IsEdit ");
        sb.Append(" FROM ipd_dischargechecklist WHERE TransactionID='"+TID+"' AND isactive=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCheckList(object Data, string TID, string PID)
    {
        List<CheckList> checklist = new JavaScriptSerializer().ConvertToType<List<CheckList>>(Data);
        if (checklist.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < checklist.Count; i++)
                {
                    sb.Append("INSERT INTO ipd_dischargechecklist (TransactionID,PatientID,IsAware,AwareRemarks,IsConsumables,ConsumablesRemarks,IsDrugsReturn, ");
                    sb.Append("DrugsReturnRemarks,IsTTO,TTORemarks,IsEnsureDS,EnsureDSRemarks,IsSigned,SignedRemarks,IsRefferal,RefferalRemarks,IsVenflon, ");
                    sb.Append("VenflonRemarks,IsWound,WoundRemarks,IsDischrageLog,DischargeLogRemarks,IsEnsureBilling,EnsureBillingRemarks,IsCheckout,CheckoutRemarks, ");
                    sb.Append("CreateBy,CreateDate) ");
                    sb.Append("VALUES(   ");
                    sb.Append(" '" + TID + "','" + PID + "'," + checklist[i].IsAware + ",'"+checklist[i].AwareRemarks+"',"+checklist[i].IsConsumables+",'"+checklist[i].ConsumablesRemarks+"',"+checklist[i].IsDrugsReturn+" ");
                    sb.Append(" ,'"+checklist[i].DrugsReturnRemarks+"',"+checklist[i].IsTTO+",'"+checklist[i].TTORemarks+"',"+checklist[i].IsEnsureDS+",'"+checklist[i].EnsureDSRemarks+"',"+checklist[i].IsSigned+",'"+checklist[i].SignedRemarks+"',"+checklist[i].IsRefferal+" ,'"+checklist[i].RefferalRemarks+"',"+checklist[i].IsVenflon+" ");
                    sb.Append(" ,'"+checklist[i].VenflonRemarks+"',"+checklist[i].IsWound+",'"+checklist[i].WoundRemarks+"',"+checklist[i].IsDischrageLog+",'"+checklist[i].DischargeLogRemarks+"',"+checklist[i].IsEnsureBilling+",'"+checklist[i].EnsureBillingRemarks+"',"+checklist[i].IsCheckout+",'"+checklist[i].CheckoutRemarks+"' ");
                    sb.Append(",'"+HttpContext.Current.Session["ID"].ToString()+"',NOW() ); ");

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                }

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
    public static string UpdateCheckList(object Data, string TID, string PID)
    {
        List<CheckList> checklist = new JavaScriptSerializer().ConvertToType<List<CheckList>>(Data);
        if (checklist.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < checklist.Count; i++)
                {
                    string str = "Update ipd_dischargechecklist set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID= '" + checklist[i].ID + "' ";
                    int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    if (result == 1)
                    {
                        sb.Append("INSERT INTO ipd_dischargechecklist (TransactionID,PatientID,IsAware,AwareRemarks,IsConsumables,ConsumablesRemarks,IsDrugsReturn, ");
                        sb.Append("DrugsReturnRemarks,IsTTO,TTORemarks,IsEnsureDS,EnsureDSRemarks,IsSigned,SignedRemarks,IsRefferal,RefferalRemarks,IsVenflon, ");
                        sb.Append("VenflonRemarks,IsWound,WoundRemarks,IsDischrageLog,DischargeLogRemarks,IsEnsureBilling,EnsureBillingRemarks,IsCheckout,CheckoutRemarks, ");
                        sb.Append("CreateBy,CreateDate) ");
                        sb.Append("VALUES(   ");
                        sb.Append(" '" + TID + "','" + PID + "'," + checklist[i].IsAware + ",'" + checklist[i].AwareRemarks + "'," + checklist[i].IsConsumables + ",'" + checklist[i].ConsumablesRemarks + "'," + checklist[i].IsDrugsReturn + " ");
                        sb.Append(" ,'" + checklist[i].DrugsReturnRemarks + "'," + checklist[i].IsTTO + ",'" + checklist[i].TTORemarks + "'," + checklist[i].IsEnsureDS + ",'" + checklist[i].EnsureDSRemarks + "'," + checklist[i].IsSigned + ",'" + checklist[i].SignedRemarks + "'," + checklist[i].IsRefferal + " ,'" + checklist[i].RefferalRemarks + "'," + checklist[i].IsVenflon + " ");
                        sb.Append(" ,'" + checklist[i].VenflonRemarks + "'," + checklist[i].IsWound + ",'" + checklist[i].WoundRemarks + "'," + checklist[i].IsDischrageLog + ",'" + checklist[i].DischargeLogRemarks + "'," + checklist[i].IsEnsureBilling + ",'" + checklist[i].EnsureBillingRemarks + "'," + checklist[i].IsCheckout + ",'" + checklist[i].CheckoutRemarks + "' ");
                        sb.Append(",'" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(checklist[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ) ");
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                    }
                }

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

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT idc.ID, idc.TransactionID,pm.PatientID,If(IsAware='1','YES','NO')IsAware,AwareRemarks,if(IsConsumables='1','YES','NO')IsConsumables,ConsumablesRemarks,If(IsDrugsReturn='1','YES','NO')IsDrugsReturn,DrugsReturnRemarks, ");
        sb.Append("If(IsTTO='1','YES','NO')IsTTO,TTORemarks,If(IsEnsureDS='1','YES','NO')IsEnsureDS,EnsureDSRemarks,If(IsSigned='1','YES','NO')IsSigned,SignedRemarks,If(IsRefferal='1','YES','NO')IsRefferal,RefferalRemarks,if(IsVenflon='1','YES','NO')IsVenflon,VenflonRemarks, ");
        sb.Append("If(IsWound='1','YES','NO')IsWound,WoundRemarks,If(IsDischrageLog='1','YES','NO')IsDischrageLog,DischargeLogRemarks,If(IsEnsureBilling='1','YES','NO')IsEnsureBilling,EnsureBillingRemarks,If(IsCheckout='1','YES','NO')IsCheckout,CheckoutRemarks, ");
        sb.Append("CONCAT(pm.Title,'',pm.PName)Pname,pm.PatientID,REPLACE(idc.TransactionID,'ISHHI','')IPDNo, ");
       // sb.Append("CONCAT(DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'),' ',TIME_FORMAT(ich.TimeOfAdmit,'%l:%i %p'))DischargeDate, ");
	    sb.Append(" IF(DATE(ich.DateOfDischarge)='0001-01-01','',CONCAT(DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'),' ',TIME_FORMAT(ich.TimeOfAdmit,'%l:%i %p')))DischargeDate, ");
        sb.Append("CONCAT(em.Title,'',em.Name)EntryBy,DATE_FORMAT(idc.CreateDate,'%d-%b-%Y')EntryDate FROM ipd_dischargechecklist idc  ");
        sb.Append("INNER JOIN patient_medical_history ich ON ich.TransactionID=idc.TransactionID INNER JOIN patient_master pm ON pm.PatientID=idc.PatientID ");//ipd_case_history
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=idc.CreateBy WHERE idc.TransactionID='" + ViewState["TransID"].ToString() + "' AND idc.isactive=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "DischargePatientCheckList";

            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "logo";

            Session["ReportName"] = "DischargePatientCheckList";
            Session["ds"] = ds;
          //  ds.WriteXmlSchema(@"E:\DischargePatientCheckList.xml");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "modelAlert('No Record to Print');", true);
        }
    }




    public class CheckList
    {
        public int IsAware { get; set; }
        public int IsConsumables { get; set; }
        public int IsDrugsReturn { get; set; }
        public int IsTTO { get; set; }
        public int IsEnsureDS { get; set; }
        public int IsSigned { get; set; }
        public int IsRefferal { get; set; }
        public int IsVenflon { get; set; }
        public int IsWound { get; set; }
        public int IsDischrageLog { get; set; }
        public int IsEnsureBilling { get; set; }
        public int IsCheckout { get; set; }
        public string AwareRemarks { get; set; }
        public string ConsumablesRemarks { get; set; }
        public string DrugsReturnRemarks { get; set; }
        public string TTORemarks { get; set; }
        public string EnsureDSRemarks { get; set; }
        public string SignedRemarks { get; set; }
        public string RefferalRemarks { get; set; }
        public string VenflonRemarks { get; set; }
        public string WoundRemarks { get; set; }
        public string DischargeLogRemarks { get; set; }
        public string EnsureBillingRemarks { get; set; }
        public string CheckoutRemarks { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }
}