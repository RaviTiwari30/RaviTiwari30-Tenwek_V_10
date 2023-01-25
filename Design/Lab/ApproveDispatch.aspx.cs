using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using SD = System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Linq;
using System.IO;
using System.Web.Script.Serialization;


public partial class Design_Lab_ApproveDispatch : System.Web.UI.Page
{
    public string IsDefaultSing = string.Empty;
    public string ApprovalId = "";
    public string Year = DateTime.Now.Year.ToString();
    public string Month = DateTime.Now.ToString("MMM");
    public string HIVSaveRight = "0";
    public string IsAllowForRerun = "0";
    public static string Fromtime = "23:59:59";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["ID"] == null)
        {
            Response.Redirect("~/CustomError.ASPX");
        }
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            txtSearchValue.Focus();
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
             
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            BindApprovedBy();

            // Open Page From Test Approval Screen

            //if (Util.GetString(Request.QueryString["fromdate"]) != "")
            //{
            //    txtFormDate.Text = Util.GetString(Request.QueryString["fromdate"]);
            //    txtToDate.Text = Util.GetString(Request.QueryString["todate"]);

            //    if (Util.GetString(Request.QueryString["department"]) != "")
            //    {
            //        ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(Util.GetString(Request.QueryString["department"])));
            //    }

                DataTable dt = StockReports.GetDataTable(" select  cm.CentreID,cm.CentreName Centre from center_master cm where cm.CentreID = '" + Util.GetString(Session["CentreID"]) + "' ");
                ddlCentreAccess.DataSource = dt;
                ddlCentreAccess.DataTextField = "Centre";
                ddlCentreAccess.DataValueField = "CentreID";
                ddlCentreAccess.DataBind();
            //}
        }
    }
    private void BindApprovedBy()
    {
        DataTable dtApproval = StockReports.GetDataTable("SELECT DISTINCT em.Name, fa.EmployeeID FROM f_approval_labemployee fa INNER JOIN employee_master em ON em.EmployeeID=fa.EmployeeID   " +
" AND IF(fa.`TechnicalId`='',fa.`EmployeeID`,fa.`TechnicalId`)='" + HttpContext.Current.Session["ID"].ToString() + "' AND fa.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' WHERE fa.Approval IN (1,3,4)  " +
" ORDER BY fa.isDefault DESC,em.Name ");

        //   DataTable dtApproval = StockReports.GetDataTable(str);
        ddlApprove.DataSource = dtApproval;

        ddlApprove.DataTextField = "Name";
        ddlApprove.DataValueField = "EmployeeID";
        ddlApprove.DataBind();
        ddlApprove.Items.Insert(0, new ListItem("Select Doctor", "0"));
        ddlApprove.SelectedIndex = ddlApprove.Items.IndexOf(ddlApprove.Items.FindByValue(Session["ID"].ToString()));

        if (dtApproval.Rows.Count == 1)
            ddlApprove.Enabled = true;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Checkcolor(string testid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT");
        sb.Append(" plo.LabObservationName,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,plo.readingFormat ");
        sb.Append(" FROM `patient_labobservation_opd` plo where Test_ID='" + testid + "' ");
      
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='3'   ");
        
        sb.Append(" ORDER BY NAME");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("ALL", "0"));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PatientSearch(string SearchType, string SearchValue, string FromDate, string ToDate, string CentreID, string Department, string TimeFrm, string Timeto, string InvestigationId, string _Flag, string Inv_ID)
    {

        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("  SELECT plo.flag, plo.LabObservation_ID, pli.reporttype,plo.MinCritical,plo.MaxCritical,plo.LabObservationName,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,plo.readingFormat, pli.IsDispatch,pli.Approved,pli.test_id,DATE_FORMAT(lt.Date, '%d-%b-%y %H:%i')RegDate,(SELECT CentreCode FROM center_master WHERE CentreID=pli.sampleTransferCentreID)TestCentreCode,DATE_FORMAT(pli.DeliveryDate,'%d-%b-%y')DeliveryDate,pli.investigation_ID,im.`NAME` InvestigationName ,''srno,'0' isrerun, '' CombinationSampleDept,'' ReferLab,pli.Approved, ");
        sbQuery.Append("  if(DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i')='01-Jan-00 00:00' || DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i')='01-Jan-01 00:00','',DATE_FORMAT(ifnull(pli.SampleReceiveDate,''), '%d-%b-%y %H:%i'))DATE, DATE_FORMAT(ifnull(pli.SampleCollectionDate,''), '%d-%b-%y %H:%i') colledate,DATE_FORMAT(ifnull(pli.ResultEnteredDate,''), '%d-%b-%y %H:%i') ResultEnteredDate,DATE_FORMAT(ifnull(pli.ResultEnteredDate,''), '%d-%b-%y %H:%i')ProvisionalDispatchDate,pli.`LedgerTransactionNo` ,IF(pli.TYPE=1,'OPD','IPD') SampleLocation,'' CombinationSample,pm.PName PName,pm.`Gender`,lt.PatientID Patient_ID,");
        //
        sbQuery.Append(" cm.CentreName Centre,pli.`BarcodeNo`,    ");
        sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(plo.LabObservationName)) AS Test,   ");

        //sbQuery.Append(" (SELECT IF(HOUR(IF(IFNULL(Provisionaldatetime,'')='',TIMEDIFF(NOW(),SampleCollectionDate),TIMEDIFF(Provisionaldatetime,SampleCollectionDate)))>tat.ProcessingHour,'1','0') FROM TestProcessingTimeMaster tat WHERE tat.`ItemID`=pli.ItemID) delayimg ");
        sbQuery.Append(" '' delayimg");
        sbQuery.Append(" FROM patient_labinvestigation_opd pli ");
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgertransactionNo`=pli.`LedgerTransactionNo` AND lt.`IsCancel`=0  AND pli.`Result_Flag`=1 ");// 
        sbQuery.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=lt.`PatientID`");
        sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0 and im.ReportType<>7    ");
        sbQuery.Append(" INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.`Investigation_Id` ");
        sbQuery.Append(" INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sbQuery.Append(" INNER JOIN patient_labobservation_opd  plo  ON plo.`test_id`=pli.`test_id` ");
        if (_Flag != "A")
        {
            if (_Flag == "H")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND Flag ='High' ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }
            else if (_Flag == "L")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND Flag ='Low' ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }

            else if (_Flag == "CH")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND `MaxCritical`<>0 AND isnumeric(`Value`)=1 AND  CAST(`Value` AS DECIMAL(11,2)) > CAST(`MaxCritical` AS DECIMAL(11,2)) ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }
            else if (_Flag == "CL")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND `MinCritical`<>0 AND isnumeric(`Value`)=1 AND  CAST(`Value` AS DECIMAL(11,2)) < CAST(`MinCritical` AS DECIMAL(11,2)) ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }


        }
        sbQuery.Append(" Where pli.result_flag=1 and pli.approved=0 and pli.ishold=0 ");
        if (Department != "" && Department != "0")
            sbQuery.Append("  and imm.SubcategoryID='" + Department + "' ");


        if (InvestigationId != "" && InvestigationId != "null")
            sbQuery.Append("  and pli.`Investigation_ID` in ('" + InvestigationId.Replace(",", "','") + "') ");

        if (SearchValue.Trim() != "")
        {
            if (SearchType.Trim() == "lt.PName")
                sbQuery.Append(" and " + SearchType + " like  '%" + SearchValue.Trim() + "%' ");
            else
                sbQuery.Append(" and " + SearchType + " = '" + SearchValue.Trim() + "' ");
        }

        if (Inv_ID != "" && Inv_ID != "null")
        {
            sbQuery.Append(" and pli.ItemID='" + Inv_ID + "'  ");
        }


        if (((SearchType.Trim() == "lt.Patient_ID") || (SearchType.Trim() == "lt.PName")) || ((SearchValue.Trim() == "") && (SearchType.Trim() == "pli.LedgerTransactionNo")))

        {
            sbQuery.Append(" AND pli.ResultEnteredDate>='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "'  ");
            sbQuery.Append(" AND pli.ResultEnteredDate<='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "'  ");
        }

        sbQuery.Append(" AND lt.`IsCancel`=0 GROUP BY if(im.ReportType<>1,Pli.Test_ID, lt.`LedgerTransactionNo`),pli.BarcodeNo,plo.LabObservation_ID");
        sbQuery.Append(" order by  lt.PatientID,im.Print_Sequence,plo.Priorty ");

        //System.IO.File.WriteAllText(@"E:\code\aa.txt", sbQuery.ToString());
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());

        if (_Flag == "N")
        {

            var dc = dt.Select("flag = 'High' or flag = 'Low'").CopyToDataTable().DefaultView.ToTable(true, "test_id");

            foreach (DataRow dw in dc.Rows)
            {
                dt.AsEnumerable().Where(r => r.Field<int>("test_id") == Util.GetInt(dw[0].ToString())).ToList().ForEach(row => row.Delete());
                dt.AcceptChanges();
            }


        }
        if (dt.Rows.Count > 0)
        {
            int count = dt.Rows.Count;
            dt.Columns.Add("TotalRecord");
            foreach (DataRow dw in dt.Rows)
            {
                dw["TotalRecord"] = dt.Rows.Count.ToString();
            }
            dt.AcceptChanges();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void btnReport_Click(object sender, System.EventArgs e)
    {
        string SearchType = ddlSearchType.SelectedValue.ToString();
        string SearchValue = txtSearchValue.Text;
        string FromDate = txtFormDate.Text;
        string ToDate = txtToDate.Text;
        string CentreID = ddlCentreAccess.SelectedValue.ToString();
        string Department = ddlDepartment.SelectedValue.ToString();
        string TimeFrm = txtFromTime.Text;
        string Timeto = txtToTime.Text;
        string InvestigationId = "";
        string _Flag = ddlresultstatus.SelectedValue.ToString();         
        string Inv_ID = ddlinvestigation.SelectedValue.ToString();

        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("  SELECT plo.flag, plo.LabObservation_ID, pli.reporttype,Round(plo.MinCritical,2)MinCritical,Round(plo.MaxCritical,2)MaxCritical,plo.LabObservationName,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,plo.readingFormat, pli.IsDispatch,pli.Approved,pli.test_id,DATE_FORMAT(lt.Date, '%d-%b-%y %H:%i')RegDate,(SELECT CentreCode FROM center_master WHERE CentreID=pli.sampleTransferCentreID)TestCentreCode,DATE_FORMAT(pli.DeliveryDate,'%d-%b-%y')DeliveryDate,pli.investigation_ID,im.`NAME` InvestigationName ,''srno,'0' isrerun, '' CombinationSampleDept,'' ReferLab,pli.Approved, ");
        sbQuery.Append("  if(DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i')='01-Jan-00 00:00' || DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i')='01-Jan-01 00:00','',DATE_FORMAT(ifnull(pli.SampleReceiveDate,''), '%d-%b-%y %H:%i'))DATE, DATE_FORMAT(ifnull(pli.SampleCollectionDate,''), '%d-%b-%y %H:%i') colledate,DATE_FORMAT(ifnull(pli.ResultEnteredDate,''), '%d-%b-%y %h:%i %p') ResultEnteredDate,DATE_FORMAT(ifnull(pli.ResultEnteredDate,''), '%d-%b-%y %H:%i')ProvisionalDispatchDate,pli.`LedgerTransactionNo` ,IF(pli.TYPE=1,'OPD','IPD') SampleLocation,'' CombinationSample,pm.PName PName,pm.`Gender`,lt.PatientID Patient_ID,");
        //
        sbQuery.Append(" cm.CentreName Centre,pli.`BarcodeNo`,    ");
        sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(plo.LabObservationName)) AS Test,   ");
        sbQuery.Append(" '' delayimg");
        sbQuery.Append(" FROM patient_labinvestigation_opd pli ");
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgertransactionNo`=pli.`LedgerTransactionNo` AND lt.`IsCancel`=0  AND pli.`Result_Flag`=1 ");// 
        sbQuery.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=lt.`PatientID`");
        sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0 and im.ReportType<>7    ");
        sbQuery.Append(" INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.`Investigation_Id` ");
        sbQuery.Append(" INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sbQuery.Append(" INNER JOIN patient_labobservation_opd  plo  ON plo.`test_id`=pli.`test_id` ");
        if (_Flag != "A")
        {
            if (_Flag == "H")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND Flag ='High' ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }
            else if (_Flag == "L")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND Flag ='Low' ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }

            else if (_Flag == "CH")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND `MaxCritical`<>0 AND isnumeric(`Value`)=1 AND  CAST(`Value` AS DECIMAL(11,2)) > CAST(`MaxCritical` AS DECIMAL(11,2)) ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }
            else if (_Flag == "CL")
            {
                sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                sbQuery.Append(" `ResultEnteredDate` >= '" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND `ResultEnteredDate` <= '" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "' ");
                sbQuery.Append(" AND `MinCritical`<>0 AND isnumeric(`Value`)=1 AND  CAST(`Value` AS DECIMAL(11,2)) < CAST(`MinCritical` AS DECIMAL(11,2)) ) a   ");
                sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
            }


        }
        sbQuery.Append(" Where pli.result_flag=1 and pli.approved=0 and pli.ishold=0 ");
        if (Department != "" && Department != "0")
            sbQuery.Append("  and imm.SubcategoryID='" + Department + "' ");


        if (InvestigationId != "" && InvestigationId != "null")
            sbQuery.Append("  and pli.`Investigation_ID` in ('" + InvestigationId.Replace(",", "','") + "') ");

        if (SearchValue.Trim() != "")
        {
            if (SearchType.Trim() == "lt.PName")
                sbQuery.Append(" and " + SearchType + " like  '%" + SearchValue.Trim() + "%' ");
            else
                sbQuery.Append(" and " + SearchType + " = '" + SearchValue.Trim() + "' ");
        }

        if (Inv_ID != "" && Inv_ID != "null")
        {
            sbQuery.Append(" and pli.ItemID='" + Inv_ID + "'  ");
        }


        if (((SearchType.Trim() == "lt.Patient_ID") || (SearchType.Trim() == "lt.PName")) || ((SearchValue.Trim() == "") && (SearchType.Trim() == "pli.LedgerTransactionNo")))
        {
            sbQuery.Append(" AND pli.ResultEnteredDate>='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "'  ");
            sbQuery.Append(" AND pli.ResultEnteredDate<='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + Timeto) + "'  ");
        }

        sbQuery.Append(" AND lt.`IsCancel`=0 GROUP BY if(im.ReportType<>1,Pli.Test_ID, lt.`LedgerTransactionNo`),pli.BarcodeNo,plo.LabObservation_ID");
        sbQuery.Append(" order by  lt.PatientID,im.Print_Sequence,plo.Priorty ");

        //System.IO.File.WriteAllText(@"E:\code\aa.txt", sbQuery.ToString());
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());

        if (_Flag == "N")
        {
            var dc = dt.Select("flag = 'High' or flag = 'Low'").CopyToDataTable().DefaultView.ToTable(true, "test_id");

            foreach (DataRow dw in dc.Rows)
            {
                dt.AsEnumerable().Where(r => r.Field<int>("test_id") == Util.GetInt(dw[0].ToString())).ToList().ForEach(row => row.Delete());
                dt.AcceptChanges();
            }
        }
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + FromDate + " To : " + ToDate;
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "InvestigationStatusReport";
          //  ds.WriteXmlSchema(@"F:\InvestigationStatusReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "InvestigationStatusReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
    public static string SaveLabObservationOpdData(string Testid, string ResultStatus, string ApprovedBy, string ApprovalName)
    {
      Testid=  Testid.TrimEnd(',');

      MySqlConnection con = Util.GetMySqlCon();
      con.Open();
      MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

      try
      {

          if (ResultStatus == "Approved")
          {
              string query = "UPDATE patient_labinvestigation_opd SET Approved = 1, ApprovedBy = '" + ApprovedBy + "',ApprovedName = '" + ApprovalName + "',ApprovedDate=now() WHERE Test_ID in (" + Testid + ") ";
              int ORes = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query);

              StringBuilder sb = new StringBuilder();
              sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
              sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,'Report Approved & Dispatched','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','172.0.0.1','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
              sb.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE   Test_ID in (" + Testid + ") ");

              int result_Status = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

              if (ORes == 0)
              {
                  Exception ex = new Exception("Report Not Approved");
                  throw (ex);
              }
          }
          tnx.Commit();
         
          return "success";
      }
      catch (Exception ex)
      {
          ClassLog cl = new ClassLog();
          cl.errLog(ex);
          return "Report Not Approved !!";
      }
      finally {
          tnx.Dispose();
          con.Close();
          con.Dispose();
      }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetTestMaster()
    {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select IF(im.ItemCode='',typename,CONCAT(im.ItemCode,' ~ ',typename)) testname,inv.Investigation_ID testid from f_itemmaster im ");
            sb.Append(" iNNER jOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
            sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
            sb.Append(" inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
            sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id   ");
            sb.Append(" INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID ");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID ");
            sb.Append(" and c.ConfigID='3' and im.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  AND cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "'  order by inv.Print_Sequence ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            //System.IO.File.WriteAllText(@"E:\code\aa.txt", sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }
}