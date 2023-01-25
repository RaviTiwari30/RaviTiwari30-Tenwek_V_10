using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_LabReportDispatch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["CentreID"] = Session["CentreID"].ToString();
        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string BindInvestigation(string Department)
    {
        var sb = new StringBuilder();
        sb.Append(" select inv.Name ,inv.Investigation_id from f_itemmaster im   ");
        sb.Append(" INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
        sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append(" inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
        sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id   ");
        sb.Append(" INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID ");
        sb.Append(" AND c.ConfigID=3 ");
        if (Department != "0")
        {
            sb.Append(" AND io.ObservationType_ID='"+ Department +"' ");
        }
        sb.Append(" AND im.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  AND cr.RoleID='" + HttpContext.Current.Session["RoleID"] + "' order by inv.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Centre(HttpContext.Current.Session["ID"].ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession=true)]
    public static string SearchPatient(List<string> searchdata, string colorcode, string PageNo, string PageSize)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT (CASE WHEN pli.Type=1 THEN 'OPD' WHEN pli.Type=2 THEN 'IPD' ELSE 'Emergency' END) AS PatientType,(CASE WHEN DATE(pli.ApprovedDate)<'2017-09-19'  THEN '1' ELSE '0' END) isold, ");
        sb.Append(" pli.reporttype,pli.Result_Flag,pli.IsUrgent,DATE_FORMAT(lt.Date,'%d-%b-%Y %h:%i %p') EntryDate,lt.LedgerTransactionNo,pli.BarcodeNo,pli.PatientID, ");
         sb.Append("CONCAT(pm.Title,'',Replace(pm.Pname,' ','_'))PName,CONCAT(pm.Age,'/',pm.Gender) pinfo,pm.mobile, ");
         sb.Append("(SELECT CentreName FROM center_master WHERE centreid=lt.centreid)centre, ");
         sb.Append("Replace(CONCAT(dm.Title,'',dm.Name),' ','_') DoctorName,Replace(ot.Name,' ','_') AS Dept,Replace(im.Name,' ','_') ItemName,pli.Test_ID, ");
         sb.Append("pli.Approved,'' SampleStatus,(SELECT rdis.DispatchMode FROM report_dispatchmaster rdis WHERE rdis.ID=pli.ReportDispatchModeID)DispatchMode, ");
         sb.Append("CASE   WHEN pli.IsDispatch='1' THEN '#44A3AA'   ");
         sb.Append("WHEN pli.IsSampleCollected='R' THEN '#FF0000'  ");
         sb.Append("WHEN pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF'   ");
         sb.Append("WHEN pli.Approved='1'  THEN '#90EE90'   ");
         sb.Append("WHEN pli.Result_Flag='1' AND  pli.IsSampleCollected<>'R'  THEN '#FFC0CB'   ");
         sb.Append("WHEN pli.IsSampleCollected='N' THEN '#CC99FF'   ");
         sb.Append("WHEN pli.IsSampleCollected='S' THEN 'bisque'   ");
         sb.Append("WHEN pli.IsSampleCollected='Y' THEN '#FFFFFF'  ");
         sb.Append("ELSE '#FFFFFF' END rowColor,   ");
         sb.Append("IF(pli.isTransfer=1 AND pli.IsSampleCollected='S',1,'') LogisticStatus   ");
         sb.Append(",'' Remarks , ");

        sb.Append("  CASE WHEN (");
        sb.Append(" SELECT COUNT(*) FROM patient_labobservation_opd plo ");
        sb.Append(" WHERE plo.Test_ID=pli.Test_ID AND  plo.Value<>''");
        sb.Append(" AND (plo.MinCritical>0 OR plo.MaxCritical>0) ");
        sb.Append(" AND (CAST(plo.Value AS DECIMAL(10,2))<CAST(plo.MinCritical AS DECIMAL(10,2)) OR CAST(plo.Value AS DECIMAL(10,2))>CAST(plo.MaxCritical AS DECIMAL(10,2)))");
        sb.Append(" GROUP BY Test_ID)>0 THEN CONCAT(pli.Test_ID,'#Critical') ");
        sb.Append(" WHEN (SELECT COUNT(*) FROM patient_labobservation_opd plo ");
        sb.Append(" WHERE plo.Test_ID=pli.Test_ID AND  plo.Value<>''");
        sb.Append(" AND (plo.MinValue>0 OR plo.MaxValue>0) ");
        sb.Append(" AND (CAST(plo.Value AS DECIMAL(10,2))<CAST(plo.MinValue AS DECIMAL(10,2)) OR CAST(plo.Value AS DECIMAL(10,2))>CAST(plo.MaxValue AS DECIMAL(10,2)))");
        sb.Append(" GROUP BY Test_ID)>0 THEN CONCAT(pli.Test_ID,'#Abnormal') ELSE CONCAT(pli.Test_ID,'#Normal') END ctitical,pli.isoutsource,pli.IsSampleCollected,fim.ItemCode, IF(ROUND((IFNULL(pmh.patientpaybleamt,0)-(IFNULL(pmh.panelpaybleamt,0)+IFNULL(pmh.patientpaidamt,0))))=0,1,0) AS PaymentPendingStatus,ROUND((IFNULL(pmh.patientpaybleamt,0)-(IFNULL(pmh.panelpaybleamt,0)+IFNULL(pmh.patientpaidamt,0)))) PaymentPendingAMt    ");

        sb.Append("FROM patient_labinvestigation_opd pli   ");
         sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pli.PatientID ");
         sb.Append("INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo AND lt.IsCancel=0 ");
         sb.Append("INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID AND pmh.transactionid=lt.transactionid ");
         sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID =pli.DoctorID ");
         sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID ");
         sb.Append("INNER JOIN f_itemmaster fim ON im.Investigation_ID=fim.Type_ID  inner join f_subcategorymaster sc on sc.subcategoryid = fim.subcategoryid inner join f_configrelation cfr on cfr.categoryid = sc.categoryid and cfr.configID=3 ");
         sb.Append("INNER JOIN investigation_observationtype io ON io.Investigation_ID=pli.Investigation_ID ");
         sb.Append("INNER JOIN observationtype_master ot ON ot.ObservationType_ID=io.ObservationType_Id ");
         sb.Append("INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' "); 
         sb.Append("WHERE pli.BarcodeNo<>'' ");
         if (!String.IsNullOrEmpty(searchdata[0]) && !String.IsNullOrEmpty(searchdata[8]))
             sb.Append(" and " + searchdata[8] + " LIKE '%" + searchdata[0] + "%'  ");
         if (!String.IsNullOrEmpty(searchdata[1]))
             sb.Append("AND pm.PatientID='" + Util.GetFullPatientID(searchdata[1]) + "' ");
        if(searchdata[2] != "0")
         sb.Append("AND ot.ObservationType_ID='"+ searchdata[2] +"' ");
        if (String.IsNullOrEmpty(searchdata[0]) && String.IsNullOrEmpty(searchdata[1]))
        {
            if (!String.IsNullOrEmpty(searchdata[3]) && !String.IsNullOrEmpty(searchdata[4]))
            {
                sb.Append("AND lt.Date>='" + Util.GetDateTime(searchdata[3]).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(searchdata[4]).ToString("yyyy-MM-dd") + "' ");
            }
        }
        if (searchdata[5] != "0")
            sb.Append("AND im.Investigation_Id='" + searchdata[5] + "' ");
        if (searchdata[6] != "0")
            sb.Append("AND lt.CentreID='" + searchdata[6] + "' ");
        if (searchdata[7] != "0")
            sb.Append("AND pli.DoctorID='" + searchdata[7] + "' ");
        if (!string.IsNullOrEmpty(searchdata[10]))
        sb.Append("AND pm.mobile='" + searchdata[10] + "' ");
        if(!string.IsNullOrEmpty(searchdata[9]))
            sb.Append("AND " + searchdata[9] + " ");
        sb.Append(" AND pli.Approved='1' GROUP BY pli.Test_ID  ORDER BY pli.ID DESC ");
        if (PageNo != "0")
        {
            int from = Util.GetInt(PageSize) * Util.GetInt(PageNo);
            int to = Util.GetInt(PageSize);
            sb.Append(" limit " + from + "," + to + " ");
        }
        //System.IO.File.WriteAllText (@"D:\Shat\aa.txt", sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (PageNo == "0")
        {
            if (dt.Rows.Count > 0)
            {
                int count = dt.Rows.Count;
                dt.Columns.Add("TotalRecord");
                foreach (DataRow dw in dt.Rows)
                {
                    dw["TotalRecord"] = dt.Rows.Count.ToString();
                }
                dt.AcceptChanges();
                dt = dt.AsEnumerable().Skip(0).Take(Util.GetInt(PageSize)).CopyToDataTable();
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string DispatchLabReport(string TestID, string LedgerNo,string IsEmail,string IsSms)
    {
        try
        {
            Email_Host EH = new Email_Host();
            string additionallink = EH.LoadTinyEmail(LedgerNo);
            if (additionallink == "0" && additionallink == "") {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please try again.", message = "Error occurred, Please try again." });
            }
            if (Resources.Resource.SMSApplicable == "1" && IsSms == "1")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from patient_labinvestigation_opd Where LedgerTransactionNo=" + LedgerNo + " AND Approved=0 "));
                if (count == 0)
                {
                    DataTable dt = StockReports.GetDataTable("select plo.PatientID,pm.Mobile from patient_labinvestigation_opd plo inner join patient_master pm on pm.PatientID=plo.PatientID where LedgerTransactionNo='" + LedgerNo + "'");
                    string sms = additionallink;
                    Sms_Host smstiny = new Sms_Host();
                    smstiny.LoadTinySMS(LedgerNo, dt.Rows[0]["PatientID"].ToString(), "+230" + dt.Rows[0]["Mobile"].ToString(), sms);
                }
            }
            if (Resources.Resource.EmailApplicable == "1" && IsEmail == "1")
            {
                DataTable dt = StockReports.GetDataTable("select plo.PatientID,pm.Email,plo.TransactionID,pm.PatientID from patient_labinvestigation_opd plo inner join patient_master pm on pm.PatientID=plo.PatientID where LedgerTransactionNo='" + LedgerNo + "'");
                if (dt.Rows[0]["Email"].ToString() != "")
                {
                    var d = new EmailTemplateInfo()
                    {
                        EmailTo = dt.Rows[0]["Email"].ToString(),
                        AdditionalEmailBody = additionallink,//EH.LoadTinyEmail(LedgerNo),
                        TransactionID = dt.Rows[0]["TransactionID"].ToString(),
                        PatientID = dt.Rows[0]["PatientID"].ToString()
                    };
                    List<EmailTemplateInfo> dd = new List<EmailTemplateInfo>();
                    dd.Add(d);
                    int sendEmailID = Email_Master.SaveEmailTemplate(8, Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "1", dd, string.Empty, null);
                }
            }
            StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET  IsEmail=" + IsEmail + ",IsDispatch=1,DispatchDate=NOW(),DispatchBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE test_id IN (" + TestID + ") AND IsDispatch=0");
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    [WebMethod]
    public static string isAmountPending(string testID)
    {
        decimal amount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT (lt.`NetAmount`-lt.`Adjustment`)PendingAmount FROM `patient_labinvestigation_opd` plo  INNER JOIN f_ledgertransaction lt ON lt.`LedgertransactionNo`=plo.`LedgerTransactionNo` WHERE plo.Test_ID='" + testID + "' "));
        if (amount > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient have some Pending Amount : Rs. " + amount });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient have some Pending A" });


    }
}

