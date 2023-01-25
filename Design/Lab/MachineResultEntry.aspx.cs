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
using System.Globalization;
using System.Threading;
using Resources;
using System.Xml;

public partial class PatientResultEntry : System.Web.UI.Page
{
    public string IsDefaultSing = string.Empty;
    public string ApprovalId = "";
    public string Year = DateTime.Now.Year.ToString();
    public string Month = DateTime.Now.ToString("MMM");
    Machine objMac = new Machine();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            txtSearchValue.Focus();
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            else
            {
                string RoleID = Util.GetString(HttpContext.Current.Session["RoleID"].ToString());
                ApprovalId = StockReports.ExecuteScalar("SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`='" + RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + HttpContext.Current.Session["ID"].ToString() + "'");
                IsDefaultSing = StockReports.ExecuteScalar("SELECT DefaultSignature  FROM `f_approval_labemployee` WHERE `RoleID`='" + RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + HttpContext.Current.Session["ID"].ToString() + "' Limit 1 ");
            }

            if (ApprovalId == "20")//4
            {

                ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Tested");

                if (selectedListItem != null)
                {
                    selectedListItem.Selected = true;
                }
            }
            else
            {
                ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Pending");

                if (selectedListItem != null)
                {
                    selectedListItem.Selected = true;
                }
            }

            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //bindAccessCentre();
            BindDepartment();
            // bindInvestigation();
            BindMachine();
            BindEmployee();
            BindApprovedBy();
            BindTestDon();

            // Open Page From Test Approval Screen

            if (Util.GetString(Request.QueryString["fromdate"]) != "")
            {
                txtFormDate.Text = Util.GetString(Request.QueryString["fromdate"]);
                txtToDate.Text = Util.GetString(Request.QueryString["todate"]);
                txtFromTime.Text = Util.GetString(Request.QueryString["fromtime"]);
                txtToTime.Text = Util.GetString(Request.QueryString["totime"]);
                ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Tested");

                if (selectedListItem != null)
                {
                    selectedListItem.Selected = true;
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "$('#back').show();SearchSampleCollection();", true);

            }

        }
    }
    private void BindEmployee()
    {
        try
        {
            string str;
            if (Session["RoleID"].ToString() == "11")
            {
                str = "SELECT DISTINCT em.EmployeeID,em.NAME FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID='11' AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME";
            }
            else if (Session["RoleID"].ToString() == "104")
            {
                str = "SELECT DISTINCT em.EmployeeID,em.NAME FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID='104' AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME";
                lblDoctor.Visible = true;
                ddlEmployee.Visible = true;

            }
            else
            {
                str = "SELECT DISTINCT em.EmployeeID,em.NAME FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID IN (11,104) AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME";
            }
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlEmployee.DataSource = dt;
                ddlEmployee.DataTextField = "Name";
                ddlEmployee.DataValueField = "EmployeeID";
                ddlEmployee.DataBind();
                ddlEmployee.Items.Insert(0, "Select");
                ddlEmployee.SelectedValue = Session["ID"].ToString();
                //lblDoctor.Text = Session["RoleID"].ToString();
            }
            else
            {
                ddlEmployee.Items.Clear();
            }
        }
        catch
        { }
    }
   
    private void BindApprovedBy()
    {
        DataTable dtApproval = StockReports.GetDataTable("SELECT DISTINCT em.Name, fa.EmployeeID FROM f_approval_labemployee fa INNER JOIN employee_master em ON em.EmployeeID=fa.EmployeeID   " +
" AND IF(fa.`TechnicalId`='',fa.`EmployeeID`,fa.`TechnicalId`)='" + HttpContext.Current.Session["ID"].ToString() + "' AND fa.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' WHERE fa.Approval IN (1,3,4)  " +
" ORDER BY fa.isDefault DESC,em.Name ");
        ddlApprove.DataSource = dtApproval;

        ddlApprove.DataTextField = "Name";
        ddlApprove.DataValueField = "EmployeeID";
        ddlApprove.DataBind();

        if (dtApproval.Rows.Count == 1)
        {
            ddlApprove.Enabled = false;
        }
    }

    private void BindMachine()
    {
        try
        {
            ddlMachine.DataSource = // objMac.MachineList(); //StockReports.GetDataTable("SELECT MachineID FROM '" + AllGlobalFunction.MachineDB + "'.`mac_machinemaster` where centreid='" + HttpContext.Current.Session["CentreID"].ToString() + "'  ORDER BY MachineID");
                 ddlMachine.DataSource = StockReports.GetDataTable("SELECT MachineID FROM '" + AllGlobalFunction.MachineDB + "'.`mac_machinemaster` where centreid='" + HttpContext.Current.Session["CentreID"].ToString() + "'  ORDER BY MachineID");
            ddlMachine.DataTextField = "MachineID";
            ddlMachine.DataValueField = "MachineID";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("ALL Machine", "ALL"));
        }
        catch
        {
            ddlMachine.Items.Insert(0, new ListItem("ALL Machine", "ALL"));
        }
    }

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name NAME,ot.ObservationType_ID SubCategoryID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append(" order by ot.Name");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
    }

    private void BindTestDon()
    {
        string str = "SELECT NAME as TEXT,id as VALUE FROM macmaster WHERE IsActive=1 AND LabMachine=1 ";
        DataTable dt = StockReports.GetDataTable(str);
        //DataTable dt = StockReports.GetDataTable("SELECT MachineID TEXT,MachineID VALUE FROM labobservation_range  GROUP BY MachineID ");
        ddlTestDon.DataSource = dt;
        ddlTestDon.DataTextField = "TEXT";
        ddlTestDon.DataValueField = "VALUE";
        ddlTestDon.DataBind();
        ddlTestDon.Items.Insert(0, new ListItem("", ""));
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindAccessCentre()
    {
        DataTable dt = StockReports.GetDataTable(" select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + HttpContext.Current.Session["CentreID"].ToString() + "' ) or cm.CentreID = '" + HttpContext.Current.Session["CentreID"].ToString() + "') and cm.isActive=1 order by cm.centrecode,cm.Centre ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PatientSearch(string SearchType, string SearchValue, string FromDate, string ToDate, string SmpleColl, string Department, string MachineID, string ZSM, string TimeFrm, string TimeTo, string isUrgent, string InvestigationId, string PanelId, string SampleStatusText, string chremarks, string chcomments, string TATOption, int PatientType,string ForwardToDoctor)
    {
        try
        {
            string checkSession = HttpContext.Current.Session["CentreID"].ToString().ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" select * from ( ");
        sbQuery.Append("  SELECT  IF(pli.Type=2,(SELECT sm.`NAME`  FROM `patient_labinvestigation_opd` plo INNER JOIN `patient_test` pt ON plo.`TransactionID`=pt.`OPDTransactionID`INNER JOIN `appointment` app ON  app.`LedgerTnxNo`=pt.`LedgerTransactionNo` INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=app.`SubCategoryID` "+
        " WHERE plo.`TransactionID`=pmh.TransactionID LIMIT 1),IF(pli.Type=1,(SELECT NAME FROM type_master WHERE ID=dm.DocDepartmentID),'EMG'))ClinicWard,(Select NAME from type_master where ID=dm.DocDepartmentID)Clinic,IF(pli.Type=2,'IPD',IF(pli.Type=1,'OPD','EMG'))PatientType, im.ReportType,im.Name InvestigationName,''srno,sum(pli.IsTestRerun) isrerun, '' CombinationSampleDept,'' ReferLab,pli.Approved, ");
        sbQuery.Append("  DATE_FORMAT(IF(im.ReportType = 5,pli.SampleReceiveDate,pli.sampledate), '%d-%b-%y %H:%i') DATE,pli.LedgerTransactionNo,'' SampleLocation,'' CombinationSample,pm.`PName`,CONCAT(pm.`Age`,'/',pm.`Gender`) Age_Gender,pm.`Gender`,lt.PatientID,");
        sbQuery.Append(" CONCAT(dm.Title,'',dm.Name) AS  Doctor,cm.CentreName Centre,pli.`BarcodeNo`, fpm.Company_Name panelname,  GROUP_CONCAT(distinct  im.Name) AS Test, ");
        
        if (Department == "")
        {
            sbQuery.Append(" if(im.ReportType=1,(select CAST(GROUP_CONCAT(distinct tt.Test_ID)AS CHAR)Test_ID  from   patient_labinvestigation_opd tt where tt.`LedgerTransactionNo`= pli.LedgerTransactionNo AND tt.ReportType=1 AND  tt.sampleTransferCentreID ='" + HttpContext.Current.Session["CentreID"].ToString() + "'),pli.Test_ID)Test_ID ");
        }
        else { sbQuery.Append(" IF(im.ReportType=1,(SELECT CAST(GROUP_CONCAT(DISTINCT tt.Test_ID)AS CHAR)Test_ID  FROM   patient_labinvestigation_opd tt INNER JOIN investigation_observationtype ttt ON ttt.Investigation_ID=tt.Investigation_ID  WHERE tt.`LedgerTransactionNo`= pli.LedgerTransactionNo AND tt.ReportType=1 AND  tt.sampleTransferCentreID ='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND ttt.ObservationType_ID=" + Department + "),pli.Test_ID)Test_ID "); }
       
        sbQuery.Append(" ,IF(pm.DOB = '0001-01-01', (CASE WHEN pli.CurrentAge LIKE '%DAY%' THEN ((TRIM(REPLACE(pli.CurrentAge,'DAY(S)',''))+0)) WHEN pli.CurrentAge ");
        sbQuery.Append(" LIKE '%MONTH%' THEN ((TRIM(REPLACE(pli.CurrentAge,'MONTH(S)',''))+0)*30) ");
        sbQuery.Append(" ELSE ((TRIM(REPLACE(pli.CurrentAge,'YRS',''))+0)*365) END),DATEDIFF(NOW(),pm.DOB)) AGE_in_Days ");
        sbQuery.Append(" ,IFNULL((SELECT Remarks FROM patient_labinvestigation_opd_remarks plor WHERE plor.Test_ID =pli.Test_ID And IsActive=1 ORDER BY ID DESC LIMIT 1 ),'')RemarkStatus");
        sbQuery.Append(" ,(SELECT LedgertransactionNo FROM patient_labinvestigation_attachment WHERE LedgertransactionNo=pli.LedgerTransactionNo LIMIT 1)DocumentStatus ");
        sbQuery.Append(" ,IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'1','0')) TATDelay,TIMESTAMPDIFF(SECOND,pli.DeliveryDate,IF(pli.Approved=0,NOW(),pli.ApprovedDate))TatDelayinSecond,IF(pli.isurgent = 1,'Y','N')Urgent");
        sbQuery.Append(" ,IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL 60*-1 MINUTE),'1','0')) TATIntimate");
        sbQuery.Append(" ,CASE ");
        sbQuery.Append(" WHEN COUNT(pli.isPrint)=SUM(pli.isPrint) THEN 'Printed' ");
        sbQuery.Append(" WHEN COUNT(pli.Approved)=SUM(pli.Approved) THEN 'Approved' ");
        sbQuery.Append(" WHEN COUNT(pli.isHold)=SUM(pli.isHold) THEN 'Hold' ");
        sbQuery.Append("   WHEN COUNT(pli.Result_Flag)=SUM(pli.Result_Flag)  and   SUM(pli.isForward*pli.Result_Flag)=0 THEN 'Tested' ");
        sbQuery.Append("   WHEN COUNT(pli.isForward)=SUM(pli.isForward) THEN  'Forwarded' ");
        sbQuery.Append("   WHEN (select count(1) from mac_Data where reading<>'' and Test_ID=pli.Test_ID and `centreid`=pli.sampleTransferCentreID)>0 and pli.Result_Flag=0 THEN 'MacData' ");
        sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='N',1,0)) THEN  'Not-Collected' ");
        sbQuery.Append("   WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='S',1,0)) THEN 'Collected' ");
        sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='Y',1,0)) THEN 'Received' ");
        sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='R',1,0)) THEN 'Rejected' ");
        sbQuery.Append("  ELSE 'NA'  ");
        sbQuery.Append("  END `Status` ");
        sbQuery.Append(" ,'' Comments, ");
        sbQuery.Append(" IF (pli.SCRequestdatetime='0001-01-01 00:00:00','', DATE_FORMAT(pli.SCRequestdatetime,'%d-%b-%y %l:%i %p'))Samplerequestdate, ");
        sbQuery.Append(" IF(pli.IsSampleCollected='N','',DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p'))Acutalwithdrawdate, ");
        sbQuery.Append(" IF(pli.SCRequestdatetime='0001-01-01 00:00:00' ,'',IF(pli.IsSampleCollected='N','', ");
        sbQuery.Append(" TIME_FORMAT(TIMEDIFF(pli.SampleDate,pli.SCRequestdatetime),'%H Hr %i M ')))DevationTime ");
        sbQuery.Append(" ,IF(pli.`DeliveryDate`='0000-00-00 00:00:00' OR pli.`DeliveryDate`='0001-01-01 00:00:00','',TIME_FORMAT(TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)),'%H Hr %i M '))TimeDiff ,IF(pli.Type=2,pmh.TransNo,'')IPDNo,DATE_FORMAT(ltd.EntryDate, '%d-%b-%y')BillDate");
        sbQuery.Append(" FROM ");
        if (SearchType == "pli.BarcodeNo" && SearchValue.Trim() != "")
        {
            sbQuery.Append(" (select * from `patient_labinvestigation_opd`  where BarcodeNo = '" + SearchValue.Trim() + "'  ) pli ");
        }
        else
        {
            sbQuery.Append(" `patient_labinvestigation_opd` pli ");
        }
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo AND lt.`IsCancel`=0   ");
        sbQuery.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=pli.LedgertnxID AND ltd.IsVerified<>2    ");
        sbQuery.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID INNER JOIN doctor_master dm ON dm.DoctorID=pli.DoctorID INNER JOIN f_panel_master fpm ON fpm.PanelID=lt.PanelID ");
        sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0 and im.ReportType<>7    ");
        sbQuery.Append(" INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sbQuery.Append("  inner join investigation_observationtype iot on iot.Investigation_ID=pli.Investigation_ID  ");
        if (Department != "")
            sbQuery.Append("  and iot.ObservationType_ID='" + Department + "' ");
        sbQuery.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sbQuery.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = iot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sbQuery.Append(" and pli.sampleTransferCentreID ='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (ForwardToDoctor != null && ForwardToDoctor != "Select" && ForwardToDoctor != "undefined")
        {
            //sbQuery.Append(" and pli.ForwardToDoctor ='" + ForwardToDoctor + "' ");
        }
        if (InvestigationId != "" && InvestigationId != "null")
        {
            sbQuery.Append("  and pli.Investigation_ID ='" + InvestigationId + "' ");
        }
        if (isUrgent == "1")
        {
            sbQuery.Append(" and pli.isUrgent=1  ");
        }
        if (PatientType != 0)
        {
            sbQuery.Append(" and pli.Type=" + PatientType + " ");
        }
        if (MachineID.Trim() != "ALL")
            sbQuery.Append(" inner join mac_data md on md.Test_ID=pli.Test_ID and md.MachineName='" + MachineID + "'  and md.`centreid`=pli.sampleTransferCentreID ");
        if (!SmpleColl.Contains("having"))
        {
            sbQuery.Append(" " + SmpleColl + " ");
        }


        var sampleFromDateTime = (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm);
        var sampleToDateTime = (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo);

        if (SearchValue.Trim() != "")
        {
            if (SearchType.Trim() == "pm.PName")
            {
                sbQuery.Append(" and " + SearchType + " like  '%" + SearchValue.Trim() + "%' ");
            }
            else
            {
                sbQuery.Append(" and " + SearchType + " = '" + SearchValue.Trim() + "' ");
            }
            if (SampleStatusText != "Pending")
            {
                sbQuery.Append("  AND IF(im.ReportType = 5,pli.SampleReceiveDate >= '" + sampleFromDateTime + "',pli.sampledate >= '" + sampleFromDateTime + "') ");
                sbQuery.Append(" AND IF(im.ReportType = 5,pli.SampleReceiveDate <= '" + sampleToDateTime + "',pli.sampledate <= '" + sampleToDateTime + "') ");
            }

        }
        if (SampleStatusText == "Tested")
        {

            sbQuery.Append("  and if(ifnull(pli.ForwardToDoctor,0)!=0, ForwardToDoctor='" + HttpContext.Current.Session["ID"].ToString() + "', pli.isForward=0) ");

        }
        if (((SearchType.Trim() == "lt.PatientID") || (SearchType.Trim() == "lt.PName")) || ((SearchValue.Trim() == "") && (SearchType.Trim() == "pli.BarcodeNo")))
        {
            if (SampleStatusText != "Pending")
            {
                //sbQuery.Append("  AND pli.sampledate >='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                // sbQuery.Append(" AND pli.sampledate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");

                sbQuery.Append("  AND IF(im.ReportType = 5,pli.SampleReceiveDate >= '" + sampleFromDateTime + "',pli.sampledate >= '" + sampleFromDateTime + "') ");
                sbQuery.Append(" AND IF(im.ReportType = 5,pli.SampleReceiveDate <= '" + sampleToDateTime + "',pli.sampledate <= '" + sampleToDateTime + "') ");


            }
        }
        if (SampleStatusText == "Pending")
        {
            //sbQuery.Append("  AND pli.sampledate >='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
            //sbQuery.Append(" AND pli.sampledate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");
            sbQuery.Append("  AND IF(im.ReportType = 5,pli.SampleReceiveDate >= '" + sampleFromDateTime + "',pli.sampledate >= '" + sampleFromDateTime + "') ");
            sbQuery.Append(" AND IF(im.ReportType = 5,pli.SampleReceiveDate <= '" + sampleToDateTime + "',pli.sampledate <= '" + sampleToDateTime + "') ");
        }
        sbQuery.Append(" AND IF(im.ReportType = 5,pli.P_IN=1,pli.P_IN=0 )");
        sbQuery.Append(" GROUP BY pli.Test_ID ");
        //sbQuery.Append("GROUP BY if(im.ReportType<>1,Pli.Test_ID, lt.`LedgerTransactionNo`),pli.BarcodeNo");


        if (SmpleColl.Contains("having"))
        {
            sbQuery.Append(" " + SmpleColl + " ");
        }


        if (SampleStatusText == "Tested")
        {
            sbQuery.Append(" order by pli.isurgent asc,TatDelayinSecond desc, pli.sampledate asc ");
        }
        else
        {
            sbQuery.Append(" order by  pli.sampledate asc ");
        }


        if (SearchValue.Trim() != "")
        {
            sbQuery.Append(" limit 1000");
        }
        sbQuery.Append(" ");
        sbQuery.Append(" )tt");
        if (TATOption == "1")
        {
            sbQuery.Append(" where tatdelay=0 and TATIntimate=0");
        }
        if (TATOption == "2")
        {
            sbQuery.Append(" where tatdelay=0 and TATIntimate=1");
        }
        if (TATOption == "3")
        {
            sbQuery.Append(" where tatdelay=1 ");
        }

        //System.IO.File.WriteAllText(@"F:\nirajlabsearch.txt", sbQuery.ToString());

        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateLabInvestigationOpdData(string TestID, string Barcode, string LedgerTransactionNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string IsAvail = StockReports.ExecuteScalar("select count(BarcodeNo) from patient_labinvestigation_opd  where BarcodeNo='" + Barcode + "' and  LedgerTransactionNo<>'" + LedgerTransactionNo + "'");
            if (IsAvail == "0")
            {
                int j = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET BarcodeNo = @BarcodeNo, macStatus = @macStatus WHERE Test_ID IN @Test_ID AND LedgerTransactionNo=@LedgerTransactionNo",
                           new MySqlParameter("@BarcodeNo", Barcode), new MySqlParameter("@macStatus", 0),
                           new MySqlParameter("@Test_ID", TestID.Replace(",", "','")), new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo)
                           );
                if (j > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from mac_data where Test_ID IN @Test_ID AND LedgerTransactionNo=@LedgerTransactionNo",
                       new MySqlParameter("@Test_ID", TestID.Replace(",", "','")),
                       new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
                }
            }
            else
            {
                return "duplicate";
            }

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return "Try Again....";

        }
        return "success";
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetPatientInvsetigationsNameOnly(string LabNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT ifnull(cast( GROUP_CONCAT( IF(   pli.IsSampleCollected='Y'   ");
        sb.Append(" , CONCAT(\"<a onmouseover=getme('\",pli.Test_ID,\"')  href=\",'\" javascript:void(0); \" ' , concat(\"style=\'background-color:\",CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.IsFOReceive='1' THEN '#E9967A' WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' WHEN pli.Approved='1' AND pli.isHold='0' THEN '#90EE90' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0'AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' THEN '#FFC0CB' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' WHEN pli.Result_Flag='0' AND (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>''  and mac.`centreid`=pli.sampleTransferCentreID)>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#FFFF00' WHEN pli.IsSampleCollected='N' OR pli.IsSampleCollected='S' THEN '#CC99FF' WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' WHEN pli.IsSampleCollected<>'Y' THEN '#CC99FF' ELSE '#FFFFFF' END,\";'\") ,\" onclick=\", '~' ,\"  GetParameters('\",'',\"','\",pli.Test_ID,\"','\", Im.ReportType, ");
        sb.Append(" \"','\",pli.Test_ID,\"','\",pli.Investigation_ID,\"','\", ");
        sb.Append(" (CASE  WHEN pli.LedgerTransactionNo=\"\" THEN \"Test Cancel\" WHEN pli.isHold=\"1\" AND pli.LedgerTransactionNo!=\"\" THEN \"Hold\" WHEN pli.Approved=\"1\" ");
        sb.Append(" AND pli.LedgerTransactionNo!=\"\" THEN \"Approved\" WHEN pli.Approved=\"0\" AND pli.Result_Flag=\"1\" AND pli.LedgerTransactionNo!=\"\" THEN \"Result Done\" ");
        sb.Append("  WHEN pli.IsSampleCollected=\"Y\" AND pli.Result_Flag=\"0\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample LabReceived\" WHEN pli.IsSampleCollected=\"S\" ");
        sb.Append("  AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Collected\" WHEN pli.IsSampleCollected=\"N\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Not Collected\" ");
        sb.Append(" WHEN pli.IsSampleCollected=\"R\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Rejected\" END ),  \"','\",'',\"','\",im.isculture,\"'); ~ >\", ");
        sb.Append("  Im.Name ,\"</a>\"),IF(   pli.IsSampleCollected='S',  CONCAT('<a style=\"background-color:#CC99FF;\"  href=\"javascript:void(0);\">', Im.Name,'</a>' ),CONCAT('<a style=\"background-color:#CC99FF;\"  href=\"javascript:void(0);\">', Im.Name,'</a>' )))  SEPARATOR \" \") as char),'') AS IName ");
        sb.Append(" FROM patient_labinvestigation_opd pli INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID INNER JOIN investigation_observationtype io ON io.Investigation_ID=   pli.Investigation_ID  INNER JOIN f_categoryRole cr ON cr.ObservationType_ID = io.ObservationType_ID AND cr.RoleID=" + Util.GetInt(HttpContext.Current.Session["RoleID"]) + " ");
        sb.Append(" WHERE pli.LedgerTransactionNo=" + LabNo + " AND im.ReportType<>5 ");
        string rtrn = StockReports.ExecuteScalar(sb.ToString());
        rtrn = rtrn.Replace('~', '"');
        return rtrn;
    }

    [WebMethod(EnableSession=true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string LabObservationSearch(string LabNo, string TestID, float AgeInDays, string RangeType, string Gender, string MachineID, string macId)
    {
        if (string.IsNullOrEmpty(macId))
        {
            macId = "";
        }
        StringBuilder sbObs = new StringBuilder();
        sbObs.Append("SELECT plo.Value1,pli.IsTestRerun pliIsReRun,io.ObservationType_ID AS SubCategoryID, ");
        sbObs.Append(" pli.LedgertransactionNo,'' RequiredField,pli.PatientID,'" + Gender + "' Gender, '" + LabNo + "' LabNo,'" + AgeInDays + "' AgeInDays,'' InterfaceCName, ");
        sbObs.Append("'' CancelByInterface,'0' IsPackage,pli.BarcodeNo,im.Name TestName ,om.Print_Sequence Dept_Sequence,om.name Dept,   ");
        sbObs.Append("im.PrintSeperate INV_PrintSeparate, ");
        sbObs.Append("0 OBS_PrintSeparate,plo.Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID, ");
        sbObs.Append("pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,plo.flag `Flag`,  ");
        sbObs.Append("(CASE WHEN loi.Child_Flag='1' THEN 'HEAD'  WHEN IFNULL(plo.Value,'')!='' AND pli.Result_Flag=1  THEN plo.Value  WHEN (IFNULL(plo.Value ,'')='' OR pli.Result_Flag=0) AND IFNULL(mac.MacReading,'')!='' THEN IF(IsNumeric(mac.MacReading)=1,mac.MacReading,mac.MacReading)    WHEN IFNULL(plo.Value,'')='' AND IFNULL(mac.MacReading,'')='' AND IFNULL(IFNULL(lr.DefaultReading,lr2.DefaultReading), '') != '' AND pli.Result_Flag<>1  THEN IFNULL(lr.DefaultReading,lr2.DefaultReading)    ELSE '' END ) `Value`,  mac.MacReading,mac.MachineID,mac.machinename,mac.MachineID1,mac.MachineID2,mac.MachineID3, IFNULL(CONCAT(DATE(mac.MacDate),' ',TIME(mac.MacDate)),'0001-01-01 00:00:00')  dtMacEntry, lom.DefaultValue,plo.ID,LOM.LabObservation_ID,mac.Reading1,mac.Reading2,mac.Reading3, (CONCAT(loi.prefix,'',LOM.Name)) AS `LabObservationName`,  IF(IFNULL(plo.value,'')<>'' AND pli.approved=1 ,plo.MinValue , IFNULL(lr.MinReading,lr2.MinReading)) `MinValue`,    IF(IFNULL(plo.value,'')<>'' AND pli.approved=1 ,plo.MaxValue , IFNULL(lr.MaxReading,lr2.MaxReading)) `MaxValue`,  REPLACE( IF(IFNULL(plo.value,'')<>'' AND pli.approved=1,plo.`DisplayReading`, IFNULL(lr.DisplayReading,lr2.DisplayReading)),' ");
        sbObs.Append("','~')DisplayReading,    IFNULL(lr.DefaultReading,lr2.DefaultReading)DefaultReading,  '1' rangetype,   ");
        sbObs.Append("IF(IFNULL(plo.value,'')<>'' AND pli.approved=1, plo.ReadingFormat, IFNULL(lr.ReadingFormat,lr2.ReadingFormat))ReadingFormat,    ");
        sbObs.Append("'' AbnormalValue,        ");
        sbObs.Append("IFNULL(loi.IsBold,0) IsBold,       IFNULL(loi.IsUnderLine,0)IsUnderLine,          ");
        sbObs.Append("loi.PrintOrder Priorty,Im.ReportType,lom.ParentID,loi.Child_Flag, IFNULL(lom.Formula,'')Formula,     ");
        sbObs.Append(" ifnull(loi.MethodName,'') Method, 0 ShowAbnormalAlert, ");
        sbObs.Append(" '' ShowDeltaReport,    ");
        sbObs.Append("IFNULL(plo.PrintMethod,1)PrintMethod,   im.Print_Sequence,lom.IsMultiChild,       ");
        sbObs.Append("loi.IsCritical,ROUND(IF(IFNULL(plo.value,'')<>'' AND pli.approved=1,plo.`MinCritical`, ");
        sbObs.Append("IFNULL(lr.MinCritical,lr2.MinCritical)),2)MinCritical,ROUND(IF(IFNULL(plo.value,'')<>''  ");
        sbObs.Append("AND pli.approved=1,plo.`MaxCritical`,IFNULL(lr.MaxCritical,lr2.MaxCritical )),2)MaxCritical  , ");
        sbObs.Append("IFNULL(h.Help,'') Help,    im.IsMic,lom.IsComment,'' ResultRequired   ,  ");
        sbObs.Append("pli.isPartial_Result,'' DLCCheck,'' isAmr,'' Isreflex,0 helpvalueonly, ");
        sbObs.Append("'' AmrMin,'' AmrMax, ");
        sbObs.Append("'' ReflexMin,'' ReflexMax ,    ");
        sbObs.Append("(SELECT IFNULL(GROUP_CONCAT(LabObservationIDto SEPARATOR '#'),'') FROM investigation_maphold  ");
        sbObs.Append("WHERE LabObservationIDfrom =loi.LabObservation_ID) HoldObsId , ");
        sbObs.Append("''IsAttached  , ");
        sbObs.Append("CASE  WHEN pli.isPrint=1 AND pli.isSampleCollected<>'R' AND pli.Approved=1 THEN '#00FFFF' /*'Printed'*/   ");
        sbObs.Append("WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/    WHEN pli.Result_Flag=1  AND pli.isForward=0   ");
        sbObs.Append("THEN '#FFC0CB' /*'Result_Done'*/    WHEN pli.isForward=1  THEN '#3399FF' /*'Forwarded'*/     ");
        sbObs.Append("WHEN (SELECT COUNT(*) FROM mac_Data WHERE reading<>'' AND Test_Id=pli.Test_Id  ");
        sbObs.Append("AND `centreid`=pli.sampleTransferCentreID )>0 AND pli.Result_Flag=0 THEN '#E2680A' /*'MacData'*/    ");
        sbObs.Append("WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/    ");
        sbObs.Append("WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/    ");
        sbObs.Append("WHEN pli.isSampleCollected='Y' THEN '#FFFFFF' /*'Received'*/    ");
        sbObs.Append("WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/    ");
        sbObs.Append("ELSE '#FFFFFF'    END `Status`  ,plo.Value1,plo.Value2, ");
        sbObs.Append("(SELECT COUNT(*) FROM `patient_labinvestigation_opd_micro` WHERE Test_ID= pli.Test_ID ) micro,  ");
        sbObs.Append("om.Name DeptName,IF(pli.IsTestRerun=0,im.Name,CONCAT(im.name,'(RERUN)')) AS InvName  , ");
        sbObs.Append("(SELECT COUNT(*) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID AND IsActive='1') Remarks, ");
        sbObs.Append("'true' SaveInv ,  ");
        sbObs.Append("if(im.ReportType=1,(SELECT SUBSTRING_INDEX(IFNULL(GROUP_CONCAT(ploo.Value ORDER BY ploo.`ResultDateTime` DESC SEPARATOR ','),''),',',7) FROM  `patient_labobservation_opd` ploo  ");
        sbObs.Append("INNER JOIN `patient_labinvestigation_opd` plop ON plop.Test_ID = ploo.`Test_ID` ");
        sbObs.Append("WHERE ploo.`LabObservation_ID` = plo.`LabObservation_ID` AND plop.`PatientID` = pli.PatientID AND ploo.`Test_ID`<> pli.Test_ID),'') ");
        sbObs.Append(" oldvalues FROM (SELECT * FROM patient_labinvestigation_opd  ");
        sbObs.Append("WHERE LedgerTransactionNo=" + LabNo + "   AND Test_ID IN ('" + TestID.Replace(",", "','") + "')  ) pli   ");
        sbObs.Append("INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id   ");
        sbObs.Append("AND im.ReportType=1 AND im.IsMic=0 AND im.isCulture=0    ");
        sbObs.Append("INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id    ");
        sbObs.Append("INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID    ");
        sbObs.Append("INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id   ");
        sbObs.Append("INNER JOIN  labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID  ");
        sbObs.Append("LEFT JOIN patient_labobservation_opd plo ON pli.Test_ID=plo.Test_ID AND plo.LabObservation_ID=LOM.LabObservation_ID    ");
        sbObs.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sbObs.Append("LEFT OUTER JOIN    ( ");
        sbObs.Append("SELECT LedgerTransactionNo,LabNo,LabObservation_ID,Reading MacReading,Reading1,Reading2,Reading3, ");
        sbObs.Append("IF(''<>'','',MachineID)MachineID,machinename,MachineID1,MachineID2,MachineID3,MacDate,Test_ID,centreid  ");
        sbObs.Append("FROM  mac_data WHERE LedgerTransactionNo=" + LabNo + " AND ( Reading<>'' OR Reading1<>'')    ");
        sbObs.Append("GROUP BY Test_ID,LabObservation_ID ,centreid) mac ON mac.Test_ID=pli.Test_ID   ");
        sbObs.Append("AND mac.LabObservation_ID= lom.LabObservation_ID  AND mac.LedgerTransactionNo = pli.LedgerTransactionNo AND mac.`centreid`=pli.sampleTransferCentreID   ");
        sbObs.Append("LEFT JOIN mac_machine_mapping mm ON mm.NewMachineID=mac.machinename   ");
        sbObs.Append("LEFT OUTER JOIN labobservation_range lr ON lr.Gender=LEFT('" + Gender + "',1)  AND lr.FromAge<=if(" + AgeInDays + "=0," + AgeInDays + "," + AgeInDays + ") AND lr.ToAge>=if(" + AgeInDays + "=0," + AgeInDays + "," + AgeInDays + ")   ");
        sbObs.Append("AND lr.LabObservation_ID=lom.LabObservation_ID ");
        sbObs.Append("AND  IFNULL(lr.MachineID,'') = if('" + macId + "'<>'','" + macId + "',IF(IFNULL(mm.OldMachineID,'')<>'',mm.OldMachineID,'')) ");
        sbObs.Append("and lr.CentreID=if('" + macId + "'<>'','" + HttpContext.Current.Session["CentreID"].ToString() + "','1')   ");
        sbObs.Append("LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT('" + Gender + "',1)   ");
        sbObs.Append("AND lr2.FromAge<=if(" + AgeInDays + "=0," + AgeInDays + "," + AgeInDays + ") AND lr2.ToAge>=if(" + AgeInDays + "=0," + AgeInDays + "," + AgeInDays + ")   AND lr2.LabObservation_ID=lom.LabObservation_ID  ");
        //sbObs.Append("AND  IFNULL(lr2.MachineID,'') = if('" + macId + "'<>'','" + macId + "',IF(IFNULL(mm.OldMachineID,'')<>'',mm.OldMachineID,'')) ");
        sbObs.Append("and lr2.CentreID=if('" + macId + "'<>'','" + HttpContext.Current.Session["CentreID"].ToString() + "','1')   ");
        //sbObs.Append("AND lr2.CentreID="+ HttpContext.Current.Session["CentreID"].ToString() +"  ");
        sbObs.Append("LEFT OUTER JOIN  (SELECT GROUP_CONCAT(CONCAT(lhm.Help,'#',IF(IFNULL(lhm.ShortKey,'')='',lhm.Help,lhm.ShortKey) )  ");
        sbObs.Append("ORDER BY IF(IFNULL(lhm.ShortKey,'')='',lhm.id,lhm.ShortKey) SEPARATOR '|' )Help,loh.labObservation_ID    ");
        sbObs.Append("FROM LabObservation_Help loh    ");
        sbObs.Append("INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId    ");
        sbObs.Append("GROUP BY loh.LabObservation_ID ) h ON h.LabObservation_ID = lom.LabObservation_ID  GROUP BY lom.LabObservation_ID,loi.Investigation_Id ");
        sbObs.Append("UNION ALL    ");
        sbObs.Append("SELECT ''Value1,pli.IsTestRerun pliIsReRun,io.ObservationType_ID AS SubCategoryID,pli.LedgerTransactionno LedgerTransactionID ,'' RequiredField,pli.PatientID, ");
        sbObs.Append(" '" + Gender + "' Gender,  '" + LabNo + "' LabNo,'" + AgeInDays + "' AgeInDays,'' InterfaceCName,'' CancelByInterface, ");
        sbObs.Append("0 IsPackage,pli.BarcodeNo,im.Name TestName,om.Print_Sequence Dept_Sequence,om.name Dept,    ");
        sbObs.Append("im.PrintSeperate INV_PrintSeparate,'0' OBS_PrintSeparate,'' Description,pli.IsSampleCollected,'' AS LabInvestigation_ID, ");
        sbObs.Append("pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,'' `Flag`,   '' `Value`,   ");
        sbObs.Append("'' MacReading, '' MachineID,'' machinename,'' MachineID1,'' MachineID2,'' MachineID3, '0001-01-01 00:00:00'  dtMacEntry,  ");
        sbObs.Append("'' DefaultValue,'' ID,pli.Test_ID LabObservation_ID,'' Reading1,'' Reading2,'' Reading3,  im.Name `LabObservationName` ,  ");
        sbObs.Append("''`MinValue`,   ''  `MaxValue`,    '' DisplayReading,  '' DefaultReading,   ''  rangetype,     '' ReadingFormat,           ");
        sbObs.Append("'' AbnormalValue,      0 IsBold,       0 IsUnderLine,          0 Priorty,Im.ReportType,0 ParentID,0 Child_Flag, '' Formula,      ");
        sbObs.Append("'' `Method`, '' ShowAbnormalAlert ,'0' ShowDeltaTReport,   0 PrintMethod,   im.Print_Sequence,0 IsMultiChild,        ");
        sbObs.Append("0 IsCritical,'' MinCritical,'' MaxCritical  ,'' Help ,     im.IsMic,'' IsComment,'0' ResultRequired   ,  ");
        sbObs.Append("pli.isPartial_Result,0 DLCCheck,0 isAmr,0 Isreflex,0 helpvalueonly,0 AmrMin,0 AmrMax,0 ReflexMin,0 ReflexMax,      ");
        sbObs.Append("'' HoldObsId ,''IsAttached  , ");
        sbObs.Append("CASE   WHEN pli.isPrint=1 THEN '#00FFFF' /*'Printed'*/   WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/ ");
        sbObs.Append("WHEN pli.Result_Flag=1  AND pli.isForward=0  THEN '#FFC0CB' /*'Result_Done'*/   WHEN pli.isForward=1   ");
        sbObs.Append("THEN '#3399FF' /*'Forwarded'*/   WHEN (SELECT COUNT(*) FROM mac_Data WHERE reading<>''  ");
        sbObs.Append("AND Test_Id=pli.Test_Id AND `centreid`=pli.sampleTransferCentreID)>0 AND pli.Result_Flag=0  ");
        sbObs.Append("THEN '#E2680A' /*'MacData'*/   WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/    ");
        sbObs.Append("WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/   WHEN pli.isSampleCollected='Y'  ");
        sbObs.Append("THEN '#FFFFFF' /*'Received'*/   WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/    ");
        sbObs.Append("ELSE '#FFFFFF'    END `Status`     ,'' Value1,'' Value2,'0' micro,om.Name DeptName,im.Name AS InvName  , ");
        sbObs.Append("(SELECT COUNT(*) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID AND IsActive='1' ) Remarks , ");
        sbObs.Append("'true' SaveInv ,'' oldvalues ");

        sbObs.Append("FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=" + LabNo + "    ");
        sbObs.Append("AND Test_ID IN ('" + TestID.Replace(",", "','") + "')    ) pli    ");
        sbObs.Append("INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id   ");
        sbObs.Append("AND im.ReportType<>1 AND im.ReportType<>7 AND im.isCulture=0   ");
        sbObs.Append("INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id    ");
        sbObs.Append("INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID    ");
        sbObs.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sbObs.Append("ORDER BY Dept_Sequence,Dept, Print_Sequence,Priorty ");

        //System.IO.File.WriteAllText (@"F:\obser.txt", sbObs.ToString());

        DataTable dt = StockReports.GetDataTable(sbObs.ToString());

        System.Data.DataColumn newColumn = new System.Data.DataColumn("Inv", typeof(System.String));
        newColumn.DefaultValue = "0";
        dt.Columns.Add(newColumn);
        DataTable dtreportfile = new DataTable();
        if (dt.Rows.Count > 0)
        { //onclick="ViewDocumentReport(\'' + dtdetail[i].FileUrl + '\')"
             dtreportfile = StockReports.GetDataTable(@"SELECT test_id, CONCAT('<a target=\'_blank\' href=\'../../HISDocument/LABINVESTIGATION/OutSourceLabReport/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  FileUrl FROM patient_labinvestigation_attachment_report  WHERE Test_ID IN ('" + TestID.Replace(",", "','") + "')  ");

           // dtreportfile = StockReports.GetDataTable(@"SELECT r.test_id, CONCAT('<a target=\'_blank\' onclick=\'ViewDocumentReport( \'' , FileUrl, '\')>',AttachedFile,'</a>')  FileUrl FROM patient_labinvestigation_attachment_report  r INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID` = r.`Test_id` WHERE LedgerTransactionNo=" + LabNo + " ");
            string temp = "";
            string tempDept = "";
            DataTable dtClone = dt.Clone();
            DataRow drCopy = null;
            DataRow drNew1 = null;
            DataRow drNew = null;
            foreach (DataRow dr in dt.Rows)
            {

                if (temp != dr["Test_ID"].ToString())
                {
                    if (temp != "")
                    {
                        drCopy = dt.Rows[dt.Rows.IndexOf(dr) - 1];
                        drNew1 = dtClone.NewRow();
                        drNew1["LabObservationName"] = "Comments";
                        drNew1["PrintMethod"] = 0;
                        drNew1["Inv"] = 2;
                        drNew1["Flag"] = "";
                        drNew1["saveinv"] = "true";
                        drNew1["Value"] = StockReports.ExecuteScalar("select comments from patient_labinvestigation_opd_comments where Test_ID='" + drCopy["Test_ID"].ToString() + "'");
                        drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                        drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                        drNew1["LabNo"] = drCopy["LabNo"].ToString();
                        dtClone.Rows.Add(drNew1);
                    }
                    if (tempDept != dr["Dept"].ToString())
                    {
                        tempDept = dr["Dept"].ToString();
                        drNew = dtClone.NewRow();
                        drNew["LabObservationName"] = dr["Dept"].ToString();
                        drNew["PrintMethod"] = 0;
                        drNew["Inv"] = 3;
                        drNew["Flag"] = "";
                        drNew["saveinv"] = "";
                        drNew["IsAttached"] = dr["IsAttached"].ToString();
                        drNew["LabNo"] = dr["LabNo"].ToString();
                        dtClone.Rows.Add(drNew);
                    }
                    drCopy = dr;
                    temp = dr["Test_ID"].ToString();
                    drNew = dtClone.NewRow();
                    drNew["PLIID"] = dr["Test_ID"].ToString();
                    drNew["LabObservationName"] = dr["InvName"].ToString();
                    drNew["PrintMethod"] = 0;
                    drNew["Inv"] = 1;
                    drNew["saveinv"] = "true";
                    drNew["Test_ID"] = dr["Test_ID"].ToString();
                    drNew["Flag"] = "";
                    drNew["IsAttached"] = dr["IsAttached"].ToString();
                    drNew["LabNo"] = dr["LabNo"].ToString();
                    drNew["Remarks"] = dr["Remarks"].ToString();
                    drNew["pliIsReRun"] = dr["pliIsReRun"].ToString();
                    if (dr["investigation_id"].ToString() == "924" || dr["investigation_id"].ToString() == "933")
                    {
                        string ss1 = StockReports.ExecuteScalar("SELECT GROUP_CONCAT(CONCAT(fieldname,' : ',fieldvalue,' ',unit)) requiredfield FROM `patient_labinvestigation_opd_requiredfield`  WHERE `LedgerTransactionID`='" + dr["LedgerTransactionID"] + "'");

                        string ss2 = StockReports.ExecuteScalar("SELECT DATE_FORMAT(dob,'%d-%b-%Y') FROM patient_master WHERE PatientID='" + dr["PatientID"] + "'");
                        drNew["RequiredField"] = ss1 + ",DOB : " + ss2;
                    }


                    dtClone.Rows.Add(drNew);

                    if (dtreportfile.Select("test_id='" + drCopy["Test_ID"].ToString() + "'").Length > 0)
                    {
                        foreach (DataRow dwreport in dtreportfile.Select("test_id='" + drCopy["Test_ID"].ToString() + "'"))
                        {
                            drNew1 = dtClone.NewRow();
                            drNew1["LabObservationName"] = "Attached Report";
                            drNew1["PrintMethod"] = 0;
                            drNew1["Inv"] = 4;
                            drNew1["Flag"] = "";
                            drNew1["saveinv"] = "true";
                            drNew1["Value"] = dwreport["FileUrl"].ToString();
                            drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                            drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                            drNew1["LabNo"] = drCopy["LabNo"].ToString();
                            drNew1["PLIID"] = drCopy["PLIID"].ToString();
                            drNew1["barcodeno"] = drCopy["barcodeno"].ToString();
                            drNew1["TestName"] = drCopy["TestName"].ToString();

                            dtClone.Rows.Add(drNew1);
                        }


                    }

                }

                dtClone.ImportRow(dr);

            }

            drNew1 = dtClone.NewRow();
            drNew1["LabObservationName"] = "Comments";
            drNew1["PrintMethod"] = 0;
            drNew1["Inv"] = 2;
            drNew1["Flag"] = "";
            drNew1["saveinv"] = "true";
            drNew1["Value"] = StockReports.ExecuteScalar("select comments from patient_labinvestigation_opd_comments where Test_ID='" + drCopy["Test_ID"].ToString() + "'");
            drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
            drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
            drNew1["LabNo"] = drCopy["LabNo"].ToString();

            dtClone.Rows.Add(drNew1);
            dt = dtClone.Copy();




        }


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Comments_LabObservation(string LabObservation_ID, string Type)
    {
        if (Type == "Value")
        {
            string str = ""; string ReportType = "";

             ReportType = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, "SELECT im.reporttype FROM investigation_master im WHERE im.investigation_id IN (SELECT investigation_id FROM patient_labinvestigation_opd pli WHERE pli.`Test_ID`= @Test_ID )" ,
                          new MySql.Data.MySqlClient.MySqlParameter("@Test_ID", LabObservation_ID)));           

            if(ReportType == "5")
            {
                 str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it " +
                        " INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Investigation_ID`= it.`Investigation_ID`  " +
                        " WHERE pli.`Test_ID`=@LabObservation_ID  and it.Template_ID in(Select TemplateId from tblInvestigationTemplateUser where UserId='" + HttpContext.Current.Session["ID"].ToString() +
                        "' and IsActive=1)  #and (it.FavDoctorId=0 or it.FavDoctorId=" + HttpContext.Current.Session["ID"].ToString() + ") ";
            }
            else
            {
                 str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it " +
                       " INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Investigation_ID`= it.`Investigation_ID`  " +
                       " WHERE pli.`Test_ID`=@LabObservation_ID  #and (it.FavDoctorId=0 or it.FavDoctorId=" + HttpContext.Current.Session["ID"].ToString() + ") ";
            }
            
            DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, str, new MySqlParameter("@LabObservation_ID", LabObservation_ID)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, "SELECT Comments_ID,Comments_Head FROM labobservation_comments WHERE `LabObservation_ID`=@LabObservation_ID ",
             new MySqlParameter("@LabObservation_ID", LabObservation_ID)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetComments_labobservation(string CmntID, string type, string BarcodeNo, string Test_ID)
    {
        string temp = "";
        string str = "";
        if (type == "Value")
        {
            str = "SELECT `Template_Desc` FROM `investigation_template` WHERE `Template_ID`='" + CmntID + "'";
        }
        else
        {
            str = "select Comments from labobservation_comments where Comments_ID='" + CmntID + "'";
        }

        temp = StockReports.ExecuteScalar(str);
        DataTable dtMacData;
        try
        {
            if (CmntID.Trim() != "" && CmntID.Trim() != "0" && temp.Trim() != "")
            {
                StringBuilder sbQuery = new StringBuilder();
                sbQuery.Append(" SELECT * FROM ( SELECT pm.`LabObservation_id`,mo.`Reading` FROM '" + AllGlobalFunction.MachineDB + "'.`mac_observation` mo ");
                sbQuery.Append(" INNER JOIN '" + AllGlobalFunction.MachineDB + "'.mac_param_master pm ON pm.`Machine_ParamID`=mo.`Machine_ParamID`  ");
                sbQuery.Append(" WHERE mo.`LabNo`='" + BarcodeNo.Trim() + "' AND mo.`Reading`<>'' ORDER BY mo.`id`) a ");
                sbQuery.Append(" GROUP BY LabObservation_id ");

                //dtMacData = StockReports.GetDataTable("Select LabObservation_ID,Reading from mac_data where LabNo='" + BarcodeNo.Trim() + "' and Test_ID='" + Test_ID.Trim()+ "' and reading<>'' ");
                dtMacData = StockReports.GetDataTable(sbQuery.ToString());

                if (dtMacData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtMacData.Rows)
                    {
                        if (temp.Contains("{" + dr["LabObservation_id"] + "}"))
                        {
                            if (Util.GetString(dr["LabObservation_id"]) == "1097")
                            {
                                temp = temp.Replace("{" + dr["LabObservation_id"] + "}", Util.GetString(Util.GetInt(dr["Reading"]) / 7) + "/" + Util.GetString(Util.GetInt(dr["Reading"]) % 7));
                            }
                            else if (Util.GetString(dr["LabObservation_id"]) == "1110" || Util.GetString(dr["LabObservation_id"]) == "1111" || Util.GetString(dr["LabObservation_id"]) == "1112" || Util.GetString(dr["LabObservation_id"]) == "1120" || Util.GetString(dr["LabObservation_id"]) == "1113")
                            {
                                string valToShow = "";
                                if (Util.GetString(dr["Reading"]).ToLower() == "low")
                                {
                                    valToShow = "NEGATIVE";
                                }
                                else if (Util.GetString(dr["Reading"]).ToLower() == "increased")
                                {
                                    valToShow = "POSITIVE";
                                }
                                else
                                {
                                    valToShow = Util.GetString(dr["Reading"]);
                                }

                                temp = temp.Replace("{" + dr["LabObservation_id"] + "}", Util.GetString(dr["Reading"]));
                                temp = temp.Replace("{-" + dr["LabObservation_id"] + "}", valToShow);
                            }
                            else if (Util.GetString(dr["LabObservation_id"]) == "1201" || Util.GetString(dr["LabObservation_id"]) == "1203" || Util.GetString(dr["LabObservation_id"]) == "1206" || Util.GetString(dr["LabObservation_id"]) == "1210" || Util.GetString(dr["LabObservation_id"]) == "1208")
                            {
                                string valToShow = "";
                                if (Util.GetString(dr["Reading"]).ToLower() == "low")
                                {
                                    valToShow = "NEGATIVE";
                                }
                                else if (Util.GetString(dr["Reading"]).ToLower() == "increased")
                                {
                                    valToShow = "POSITIVE";
                                }
                                else
                                {
                                    valToShow = Util.GetString(dr["Reading"]);
                                }

                                temp = temp.Replace("{" + dr["LabObservation_id"] + "}", Util.GetString(dr["Reading"]));
                                temp = temp.Replace("{-" + dr["LabObservation_id"] + "}", valToShow);
                            }
                            else if (Util.GetString(dr["LabObservation_id"]) == "1095")
                            {
                                string Year = string.Empty;
                                string Month = string.Empty;
                                string DispData = string.Empty;
                                try
                                {
                                    Year = Util.GetString(dr["Reading"]).Split('.')[0];
                                    // Month = (Util.GetInt(Util.GetString(dr["Reading"]).Split('.')[1]) * 12).ToString("0000").Substring(0, 2);
                                    Month = (Util.GetInt((Util.GetString(dr["Reading"]).Split('.')[1].Length == 1) ? Util.GetString(dr["Reading"]).Split('.')[1] + "0" : Util.GetString(dr["Reading"]).Split('.')[1]) * 12).ToString("0000").Substring(0, 2);
                                    DispData = Year + "/" + Month;
                                }
                                catch
                                {
                                    DispData = Util.GetString(dr["Reading"]) + "/0";
                                }
                                temp = temp.Replace("{" + dr["LabObservation_id"] + "}", DispData);
                            }
                            else
                            {
                                temp = temp.Replace("{" + dr["LabObservation_id"] + "}", Util.GetString(dr["Reading"]));
                            }

                        }
                    }
                }
                temp = System.Text.RegularExpressions.Regex.Replace(temp, "{.*?}", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            }
        }
        catch
        {
        }
        return temp;
    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Getpatient_labobservation_opd_text(string TestId, string BarcodeNo)
    {
        string str = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, "SELECT Concat(`LabInves_Description`,'$',FindingText) FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
            new MySql.Data.MySqlClient.MySqlParameter("@Test_ID", TestId)));
        return str;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveLabObservationOpdData(List<ResultEntryProperty> data, string ResultStatus, string ApprovedBy, string ApprovalName, string HoldRemarks, string criticalsave, string notapprovalcomment, string macvalue, string MachineID_Manual, string FindingValue, int MobileApproved = 0, string IsDefaultSing = "0", string MobileEMINo = "", string MobileNo = "", string MobileLatitude = "", string MobileLongitude = "")
    {
        if (data.Count == 0)
            return "";

        data = data.Where(x => x.SaveInv == "true").ToList();

        if (data.Count == 0)
            return "";

      // Client Does not want this check that DLC should be equal to 100.
      //  DLC_Check(data, ResultStatus);

        ResultEntryProperty pOpd = new ResultEntryProperty();
        int noOfRowsUpdated = data.Count;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);


        string oldPLIID = "";
        string oldPLIIDForUpdateStatus = "";

        int RowsAffected = 0;

        string isPartial_PLID = "";
        int isPartial = 0;
        string deleteTestID = "";
        string deleteTestIDAftersave = "";
        string testtobook = "";
        string doctorMobileNo = string.Empty;
        string patientID = string.Empty;
        string patientName = string.Empty;
        DataTable oldvalue = new DataTable();



        try
        {


            DataTable smsDetails = new DataTable();
            int i = 0;
            string oldCurLabNo = string.Empty;
            foreach (ResultEntryProperty pdeatil in data)
            {
                if ((pdeatil.Inv == "1") || (pdeatil.Inv == "3"))
                    continue;

                else if (pdeatil.Inv == "2")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_labinvestigation_opd_comments where Test_ID=@Test_ID",
                         new MySqlParameter("@Test_ID", pdeatil.Test_ID));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into patient_labinvestigation_opd_comments(LedgerTransactionNo,Test_ID,comments,UserID,UserName) values(@LedgerTransactionNo,@Test_ID,@comments,@UserID,@UserName)",
                          new MySqlParameter("@LedgerTransactionNo", pdeatil.LedgerTransactionNo),
                          new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                          new MySqlParameter("@comments", pdeatil.Value),
                          new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
                          new MySqlParameter("@UserName", HttpContext.Current.Session["LoginName"].ToString())
                          );
                    continue;
                }

                string str = "";
                string ID = pdeatil.ID;
                string PLId = pdeatil.PLIID;
                string value = pdeatil.Value;
                string rangetype = pdeatil.rangetype;
                int ResultRequiredField = Util.GetInt(pdeatil.ResultRequired);
                string flag = pdeatil.Flag;
                if (flag == "Normal")
                    flag = "";
                int strPrintSeparate;

                if (pdeatil.Flag == "" || pdeatil.Flag == "0")
                    strPrintSeparate = 0;
                else
                    strPrintSeparate = 1;

                // Delete PLO Value
                if (deleteTestID != pdeatil.Test_ID)
                {
                    MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd WHERE `Test_ID`=@Test_ID",
                    new MySqlParameter("@Test_ID", pdeatil.Test_ID));

                    deleteTestID = pdeatil.Test_ID;

                    oldvalue = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select id,value,LabObservation_ID from patient_labobservation_opd_audittrail where   Test_ID='" + pdeatil.Test_ID + "' ").Tables[0];
                }

                if (pdeatil.ReportType == "1")
                {
                    float re = 0;
                    if (pdeatil.isAmr == "1" && pdeatil.AmrMin != "" && pdeatil.AmrMax != "" && pdeatil.AmrMin != null && pdeatil.AmrMax != null)
                    {
                        if (float.TryParse(pdeatil.Value, out re))
                        {
                            if (Util.GetFloat(pdeatil.Value) < Util.GetFloat(pdeatil.AmrMin) || Util.GetFloat(pdeatil.Value) > Util.GetFloat(pdeatil.AmrMax))
                            {
                                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select AmrValueAccess from employee_master where employeeid='" + HttpContext.Current.Session["ID"].ToString() + "'")) == 0)
                                {
                                    Exception ex = new Exception(pdeatil.LabObservationName + " value must be with in " + pdeatil.AmrMin + " to " + pdeatil.AmrMax);
                                    throw (ex);
                                }
                            }
                        }
                        else if (pdeatil.Value.Trim() != "")
                        {
                            Exception ex = new Exception(pdeatil.LabObservationName + " value must be numeric and in proper format");
                            throw (ex);
                        }
                    }

                    if (ResultStatus == "Approved" || ResultStatus == "Forward" || ResultStatus == "Save")
                    {
                        if (float.TryParse(pdeatil.Value.Trim(), out re))
                        {
                            if (Util.GetFloat(pdeatil.Value.Trim()) < 0)
                            {
                                //Exception ex = new Exception(pdeatil.LabObservationName + " value cannot be negative ");
                                //throw (ex);
                            }
                        }
                    }
                    Patient_LabObservation_OPD objPLOI = new Patient_LabObservation_OPD(tnx);
                    objPLOI.LabObservation_ID = pdeatil.LabObservation_ID;
                    objPLOI.LabObservationName = pdeatil.LabObservationName;
                    objPLOI.MaxValue = pdeatil.MaxValue;
                    objPLOI.MinValue = pdeatil.MinValue;
                    objPLOI.Test_ID = pdeatil.Test_ID;
                    objPLOI.Value = ((Util.GetInt(pdeatil.IsComment) == 0) ? pdeatil.Value : pdeatil.Description);
                    objPLOI.ResultDateTime = Util.GetDateTime(DateTime.Now);
                    objPLOI.Priorty = i;
                    objPLOI.ReadingFormat = pdeatil.ReadingFormat;
                    objPLOI.DisplayReading = pdeatil.DisplayReading;
                    objPLOI.Description = pdeatil.Description;
                    objPLOI.OrganismID = pdeatil.OrganismID;
                    objPLOI.IsOrganism = Util.GetInt(pdeatil.IsOrganism);
                    objPLOI.ParamEnteredBy = HttpContext.Current.Session["ID"].ToString().ToString();
                    objPLOI.ParamEnteredByName = Util.GetString(HttpContext.Current.Session["LoginName"]);
                    objPLOI.MacReading = pdeatil.MacReading;
                    try
                    {
                        objPLOI.dtMacEntry = Util.GetDateTime(pdeatil.dtMacEntry);
                    }
                    catch
                    {
                    }
                    objPLOI.MachineID = Util.GetInt(pdeatil.MachineID);
                    objPLOI.Method = pdeatil.Method;
                    objPLOI.PrintMethod = Util.GetInt(pdeatil.PrintMethod);
                    objPLOI.LedgerTransactionNo = pdeatil.LabNo;
                    objPLOI.IsCommentField = Util.GetInt(pdeatil.IsComment);
                    objPLOI.ResultRequiredField = Util.GetInt(pdeatil.ResultRequiredField);
                    objPLOI.IsCritical = 0;// Util.GetInt(pdeatil.IsCritical);
                    objPLOI.MinCritical = Util.GetString(pdeatil.MinCritical);
                    objPLOI.MaxCritical = Util.GetString(pdeatil.MaxCritical);
                    objPLOI.ResultEnteredBy = HttpContext.Current.Session["ID"].ToString().ToString();
                    objPLOI.ResultEnteredDate = DateTime.Now;
                    objPLOI.ResultEnteredName = Util.GetString(HttpContext.Current.Session["LoginName"]);
                    objPLOI.AbnormalValue = Util.GetString(pdeatil.AbnormalValue);
                    objPLOI.Flag = Util.GetString(pdeatil.Flag);
                    objPLOI.MachineName = Util.GetString(pdeatil.machinename);
                    if (objPLOI.Value == "HEAD" && objPLOI.IsOrganism == 1)
                    {
                        objPLOI.IsBold = 1;
                        objPLOI.IsUnderLine = 1;
                    }
                    else
                    {
                        objPLOI.IsBold = Util.GetInt(pdeatil.IsBold);
                        objPLOI.IsUnderLine = Util.GetInt(pdeatil.IsUnderLine);
                    }

                    objPLOI.IsMic = Util.GetInt(pdeatil.isMic);
                    objPLOI.PrintSeparate = Util.GetInt(pdeatil.PrintSeparate);
                    objPLOI.ShowDeltaReport = Util.GetInt(pdeatil.ShowDeltaReport);
                    objPLOI.Value1 = Util.GetString(pdeatil.Value1);
                    objPLOI.Insert();
                    i++;

                    // Save Audit

                    StringBuilder sbsaveaudit = new StringBuilder();
                    string oldsavedvalue = "";
                    try
                    {
                        if (oldvalue.Rows.Count > 0)
                        {

                            DataRow[] dr = oldvalue.Select("LabObservation_ID='" + pdeatil.LabObservation_ID + "'");
                            DataTable dtnewoldvalue = dr.CopyToDataTable<DataRow>();



                            if (dtnewoldvalue.Rows.Count > 0)
                            {
                                dtnewoldvalue.DefaultView.Sort = "id desc";
                                dtnewoldvalue = dtnewoldvalue.DefaultView.ToTable();
                                oldsavedvalue = Util.GetString(dtnewoldvalue.Rows[0]["value"]);
                                if (oldsavedvalue != pdeatil.Value)
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into patient_labobservation_opd_audittrail (LabObservation_ID,Test_ID,Value,OldValue,ResultDateTime,ResultEnterdByID,ResultEnterdByName) values('" + pdeatil.LabObservation_ID + "','" + pdeatil.Test_ID + "','" + pdeatil.Value + "','" + oldsavedvalue + "',now(),'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "') ");
                                }
                            }
                            else
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into patient_labobservation_opd_audittrail (LabObservation_ID,Test_ID,Value,OldValue,ResultDateTime,ResultEnterdByID,ResultEnterdByName) values('" + pdeatil.LabObservation_ID + "','" + pdeatil.Test_ID + "','" + pdeatil.Value + "','',now(),'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "') ");
                            }
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into patient_labobservation_opd_audittrail (LabObservation_ID,Test_ID,Value,OldValue,ResultDateTime,ResultEnterdByID,ResultEnterdByName) values('" + pdeatil.LabObservation_ID + "','" + pdeatil.Test_ID + "','" + pdeatil.Value + "','',now(),'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "') ");
                        }


                    }
                    catch
                    {
                    }




                    double isdouble;
                    if (criticalsave != "1")
                    {
                        if ((value != string.Empty) && (pdeatil.IsCritical == "1") && double.TryParse(value.Trim(), out isdouble) && Util.GetString(pdeatil.AbnormalValue) == "" && pdeatil.MinCritical != null && pdeatil.MaxCritical != null)
                        {
                            try
                            {
                                if (Util.GetDouble(value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                                {
                                    Exception ex = new Exception("Critical");
                                    throw (ex);

                                    // Show Popup In Case of Critical

                                    //         MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Approved = @Approved,ReportType = @ReportType,isHold=@isHold,HoldBy=@HoldBy,HoldByName=@HoldByName  WHERE Test_ID=@ID AND isSampleCollected=@isSampleCollected",
                                    //new MySqlParameter("@Approved", "0"), 
                                    //new MySqlParameter("@ReportType", pdeatil.ReportType), new MySqlParameter("@isHold", "1"), new MySqlParameter("@HoldBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@HoldByName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                                    //new MySqlParameter("@ID", PLId),
                                    //new MySqlParameter("@isSampleCollected", 'Y'));



                                }
                            }
                            catch (Exception ex)
                            {
                                throw (ex);
                            }
                        }
                        else if ((value != string.Empty) && (pdeatil.IsCritical == "1") && (Util.GetString(pdeatil.AbnormalValue) != "") && (value.ToUpper() == pdeatil.AbnormalValue.ToUpper()))
                        {
                            Exception ex = new Exception("Critical");
                            throw (ex);
                        }
                        else if ((value != string.Empty) && (pdeatil.Flag != "Normal") && (pdeatil.ShowAbnormalAlert == "1"))
                        {
                            try
                            {
                                Exception ex = new Exception("AbnormalAlert");
                                throw (ex);
                            }
                            catch (Exception ex)
                            {
                                throw (ex);
                            }
                        }
                    }

                    try
                    {
                        if (macvalue != "1")
                        {
                            if (pdeatil.MacReading != "" && pdeatil.MacReading != null && Util.GetDouble(value.Trim()) != Util.GetDouble(pdeatil.MacReading))
                            {
                                Exception ex = new Exception("MacValue");
                                throw (ex);
                            }
                        }
                    }
                    catch
                    {
                    }



                    decimal val;
                    bool isNumeric = decimal.TryParse(value, out val);

                    //**************Checking is Critical*******************//

                    if (isNumeric)
                    {
                        if (Util.GetDouble(value) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(value) >= Util.GetDouble(pdeatil.MaxCritical))
                            pdeatil.IsCritical = "1";
                    }
                    //**************Checking is Critical*******************//


                    //**************Retriving SMS Details While Critical*******************//

                    if (pdeatil.IsCritical == "1")
                    {
                        if (smsDetails.Rows.Count == 0)
                        {

                            smsDetails = StockReports.GetDataTable("SELECT pm.PName PatientName, dm.Mobile AS MobileNo,dm.DoctorID,pmh.PatientID FROM f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID   INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID WHERE lt.LedgertransactionNo=" + pdeatil.LabNo);
                            doctorMobileNo = Util.GetString(smsDetails.Rows[0]["MobileNo"]);
                            // doctorMobileNo = "59135031";
                            patientID = Util.GetString(smsDetails.Rows[0]["PatientID"]);
                            patientName = Util.GetString(smsDetails.Rows[0]["PatientName"]);

                        }
                    }

                    //**************Retriving SMS Details While Critical*******************//


                    if (ResultStatus == "Approved" && value != string.Empty && pdeatil.IsCritical == "1")
                    {

                        if ((value != string.Empty) && (pdeatil.IsCritical == "1") && (Util.GetString(pdeatil.AbnormalValue) != "") && (value.ToUpper() == pdeatil.AbnormalValue.ToUpper()))
                        {
                            oldCurLabNo = Util.GetString(pdeatil.LabNo);
                            //StringBuilder sbCritical = new StringBuilder();
                            //sbCritical.Append(" insert into Email_Critical(LedgertransactionNo,EnteredByID,IpAddress,LabObservation_ID)");
                            //sbCritical.Append(" values(@LedgertransactionNo,@EnteredByID,@IpAddress,@LabObservation_ID) ");
                            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbCritical.ToString(),
                            //new MySqlParameter("@LedgertransactionNo", oldCurLabNo),
                            //new MySqlParameter("@EnteredByID", Util.GetString(HttpContext.Current.Session["ID"].ToString())),
                            //new MySqlParameter("@IpAddress", Util.GetString(All_LoadData.IpAddress())),
                            //new MySqlParameter("@LabObservation_ID", Util.GetString(pdeatil.LabObservation_ID)));

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labobservation_opd set IsCritical=@IsCritical where Test_ID=@Test_ID and LabObservation_ID=@LabObservation_ID",
                                    new MySqlParameter("@IsCritical", "1"),
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                    new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID));
                        }
                        else if (double.TryParse(value, out isdouble) && Util.GetDouble(pdeatil.MaxCritical) != 0)
                        {
                            if (Util.GetDouble(value) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(value) >= Util.GetDouble(pdeatil.MaxCritical))
                            {



                                //**************Sending SMS While Critical*******************//

                                //if (!string.IsNullOrEmpty(doctorMobileNo))
                                //{

                                //    string SMS_TEXT = "Critical Alert:  Patient " + patientName + ", " + pdeatil.LabObservationName + " is " + pdeatil.Value + " " + pdeatil.ReadingFormat + " ,(" + pdeatil.MinCritical + "-" + pdeatil.MaxCritical + "). Thanks";


                                //    StringBuilder sbSQL = new StringBuilder();
                                //    sbSQL.Append("INSERT INTO `sms_log`(`SMS_Text`, `sms_api`, `sms_response`,`Mobile_No`,`PatientID`,`TemplateID`,`UserID`,`smsType`,`DoctorID`,`isSend`,`EmployeeID`,BookingNo) VALUES ");
                                //    sbSQL.Append("('" + SMS_TEXT + "','','','+230" + doctorMobileNo + "','" + patientID + "','0','" + HttpContext.Current.Session["ID"].ToString() + "','100',0,0,'" + HttpContext.Current.Session["ID"].ToString() + "','" + pdeatil.LedgerTransactionNo + "') ");
                                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSQL.ToString());

                                //}
                                //**************Sending SMS While Critical*******************//






                                oldCurLabNo = Util.GetString(pdeatil.LabNo);
                                //            StringBuilder sbCritical = new StringBuilder();
                                //            sbCritical.Append(" insert into Email_Critical(LedgertransactionNo,EnteredByID,IpAddress,LabObservation_ID)");
                                //            sbCritical.Append(" values(@LedgertransactionNo,@EnteredByID,@IpAddress,@LabObservation_ID) ");
                                //            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbCritical.ToString(),
                                //            new MySqlParameter("@LedgertransactionNo", oldCurLabNo),
                                //            new MySqlParameter("@EnteredByID", Util.GetString(HttpContext.Current.Session["ID"].ToString())),
                                //            new MySqlParameter("@IpAddress", Util.GetString(All_LoadData.IpAddress())),
                                //new MySqlParameter("@LabObservation_ID", Util.GetString(pdeatil.LabObservation_ID)));

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labobservation_opd set IsCritical=@IsCritical where Test_ID=@Test_ID and LabObservation_ID=@LabObservation_ID",
                                    new MySqlParameter("@IsCritical", "1"),
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                    new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID));

                            }
                        }

                    }
                    if ((ResultStatus != "UnHold") && (ResultStatus != "Approved"))
                    {
                        if (pdeatil.LabObservation_ID == "211" && (pdeatil.Value.ToUpper() == "POSITIVE" || pdeatil.Value.ToUpper() == "REACTIVE"))// HIV Case
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Approved = @Approved,ReportType = @ReportType,isHold=@isHold,HoldBy=@HoldBy,HoldByName=@HoldByName  WHERE Test_ID=@ID AND isSampleCollected=@isSampleCollected",
                                                     new MySqlParameter("@Approved", "0"),
                                                     new MySqlParameter("@ReportType", pdeatil.ReportType), new MySqlParameter("@isHold", "1"), new MySqlParameter("@HoldBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@HoldByName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                                                     new MySqlParameter("@ID", PLId),
                                                     new MySqlParameter("@isSampleCollected", 'Y'));

                        }
                    }


                }
                else
                {
                    // To Check Text Report Value
                    if ((pdeatil.ReportType == "3" || pdeatil.ReportType == "5") && pdeatil.ReportType != null)
                    {
                        string htmltext = (pdeatil.Description == null) ? "" : pdeatil.Description;
                        string plaintext = System.Text.RegularExpressions.Regex.Replace(htmltext.Trim(), @"<[^>]+>|&nbsp;|\n|\t", "").Trim();
                        int AddReportQty = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_labinvestigation_attachment_report WHERE Test_ID =@Test_ID ", new MySqlParameter("@Test_ID", pdeatil.Test_ID)));
                        int IsAvailText = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_labobservation_opd_text WHERE Test_ID =@Test_ID ", new MySqlParameter("@Test_ID", pdeatil.Test_ID)));
                        if ((pdeatil.ReportType == "3" || pdeatil.ReportType == "5") && pdeatil.ReportType != null && plaintext.Trim() == "" && AddReportQty == 0 && IsAvailText == 0)
                        {
                            Exception ex = new Exception(pdeatil.LabObservationName + " value can't be blank.....!");
                            throw (ex);
                        }
                    }
                    if (pdeatil.Method == "1")
                    {
                        MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                        new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                        StringBuilder myStr = new StringBuilder();
                        myStr.Append("INSERT INTO `patient_labobservation_opd_text`(`Test_ID`,`LabInves_Description`,`EntDate`,UserID,FindingText) ");
                        myStr.Append(" VALUES(@Test_ID,@LabInves_Description,@EntDate,@UserID,@FindingValue)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@LabInves_Description", pdeatil.Description),
                            new MySqlParameter("@EntDate", DateTime.Now),
                            new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
                            new MySqlParameter("@FindingValue", FindingValue));
                    }
                }


                // Update Result Status
                if (deleteTestIDAftersave != pdeatil.Test_ID)
                {

                    if (ResultStatus == "Forward")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=now() WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isForward", 1), new MySqlParameter("@ForwardBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@ForwardByName", HttpContext.Current.Session["LoginName"].ToString()),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));



                    }
                    if ((ResultStatus == "Approved" || ResultStatus == "Preliminary Report") && IsDefaultSing.Trim() == "1")
                    {
                        StringBuilder sbDef = new StringBuilder();
                        sbDef.Append(" SELECT ia.`ApproveById`,em.`Name` FROM investigation_autoapprovemaster ia ");
                        sbDef.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.`TestCentreID`=ia.`CentreId` ");
                        sbDef.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=ia.`ApproveById` AND plo.`SubCategoryID`=ia.`departmentid` ");
                        sbDef.Append(" Where plo.`Test_ID`=@Test_ID AND plo.`SubCategoryID`=@SubCategoryID AND ia.`IsActive`=@IsActive  AND  em.`IsActive`=@IsActive");
                        DataTable dtDefaulSign = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbDef.ToString(),
                             new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                             new MySqlParameter("@SubCategoryID", pdeatil.SubCategoryID),
                             new MySqlParameter("@IsActive", "1")).Tables[0];
                        if (dtDefaulSign.Rows.Count > 0)
                        {
                            ApprovedBy = Util.GetString(dtDefaulSign.Rows[0]["ApproveById"]);
                            ApprovalName = Util.GetString(dtDefaulSign.Rows[0]["Name"]);
                        }
                        else
                        {
                            Exception ex = new Exception("Report Not Approved Because Signature Is Not Available.Please Contact To IT Team..!");
                            throw (ex);
                        }

                    }
                    if (ResultStatus == "Approved")//&& (value != string.Empty)
                    {
                        str = "select ifnull(Approved,0) from patient_labinvestigation_opd where Test_ID='" + PLId + "'";
                        int Approvedcheck = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, str.ToString()));
                        if (Approvedcheck == 0)
                        {
                            int ORes = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDate=now(), ResultEnteredBy=if(Result_Flag=0,'" + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1,PDoctorID=@PDoctorID WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and Approved=0 and `isHold`=0",
                                  new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@ApprovedName", HttpContext.Current.Session["LoginName"].ToString()),
                                //new MySqlParameter("@PDoctorID", ApprovedBy),
                                  new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                  new MySqlParameter("@isSampleCollected", 'Y'),
                                  new MySqlParameter("@PDoctorID", ApprovedBy));
                            if (ORes == 0)
                            {
                                Exception ex = new Exception("Report Not Approved");
                                throw (ex);
                            }
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO LabApprovalLog (DoctorID,Test_ID,IsApproved,EntryBy) VALUES ('" + ApprovedBy + "','" + pdeatil.Test_ID + "','1','" + HttpContext.Current.Session["ID"].ToString() + "') ");
                            // if (Resources.Resource.AllowFiananceIntegration == "1")
                            // {
                            str = "select Type from patient_labinvestigation_opd where Test_ID='" + PLId + "'";
                            int BillingType = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, str.ToString()));

                            str = "select LedgerTnxID from patient_labinvestigation_opd where Test_ID='" + PLId + "'";
                            string PLOUNique = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str.ToString()));

                            string ptientType = string.Empty;

                            if (BillingType == 1)
                                ptientType = "1";
                            else if (BillingType == 2)
                                ptientType = "2";
                            else
                                ptientType = "1";
                            string docstring = All_LoadData.CalcaluteDoctorShare("", PLOUNique, ptientType, "PATH", tnx, con);
                            //string IsIntegrated = Util.GetString(EbizFrame.InsertDoctorShareOnTestApproval(ptientType, Util.GetInt(PLOUNique), 1, tnx));
                            //if (IsIntegrated == "0")
                            //{
                            //    Exception ex = new Exception("Finance Integration Error");
                            //    throw (ex);
                            //}
                            // }
                        }
                        else
                        {
                            Exception ex = new Exception("Report Already UnApproved");
                            throw (ex);
                        }

                    }
                    if (ResultStatus == "Not Approved")
                    {
                        str = "select ifnull(Approved,0) from patient_labinvestigation_opd where Test_ID='" + PLId + "'";
                        int Approvedcheck = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, str.ToString()));
                        if (Approvedcheck == 1)
                        {
                            str = "select Type from patient_labinvestigation_opd where Test_ID='" + PLId + "'";
                            int BillingType = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, str.ToString()));

                            str = "select LedgerTnxID from patient_labinvestigation_opd where Test_ID='" + PLId + "'";
                            string PLOUNique = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str.ToString()));

                            string ptientType = string.Empty;

                            if (BillingType == 1)
                                ptientType = "1";
                            else if (BillingType == 2)
                                ptientType = "2";
                            else
                                ptientType = "1";
                            string docstring = All_LoadData.CalcaluteDoctorShare("", PLOUNique, ptientType, "PATH-1", tnx, con);

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, isForward = @isForward, isPrint = @isPrint WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                                new MySqlParameter("@Approved", "0"), new MySqlParameter("@isForward", "0"), new MySqlParameter("@isPrint", "0"),
                                new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                new MySqlParameter("@isSampleCollected", 'Y'));

                            // Save Not Approval Data in New Table
                            //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, @"INSERT INTO Report_Unapprove(LedgerTransactionNo, Test_ID,UnapprovebyID,Unapproveby,Comments,ipaddress,UnapproveDate) VALUES('" + Util.GetString(pdeatil.LabNo) + "','" + pdeatil.Test_ID + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "', '" + Util.GetString(HttpContext.Current.Session["LoginName"].ToString()) + "' ,'" + notapprovalcomment.ToUpper() + "','" + All_LoadData.IpAddress() + "',now()) ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO LabApprovalLog (DoctorID,Test_ID,IsApproved,EntryBy) VALUES ('" + ApprovedBy + "','" + pdeatil.Test_ID + "','-1','" + HttpContext.Current.Session["ID"].ToString() + "') ");
                            // if (Resources.Resource.AllowFiananceIntegration == "1")
                            //  {

                            //string IsIntegrated = Util.GetString(EbizFrame.InsertDoctorShareOnTestApproval(ptientType, Util.GetInt(PLOUNique), 0, tnx));
                            //if (IsIntegrated == "0")
                            //{
                            //    tnx.Rollback();
                            //}
                            //}
                        }
                        else
                        {
                            Exception ex = new Exception("Report Already UnApproved");
                            //throw (ex);
                        }
                    }
                    if (ResultStatus == "Un Forward")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET ForwardToDoctor=0,ForwardToCentre=0, isForward = @isForward WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isForward", "0"),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if (ResultStatus == "Preliminary Report")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Preliminary = @Preliminary,PreliminaryBy = @PreliminaryBy,PreliminaryName=@PreliminaryName,PreliminaryDateTime=@PreliminaryDateTime,ApprovedBy=@ApprovedBy,ApprovedName=@ApprovedName WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Preliminary", "1"),
                            new MySqlParameter("@PreliminaryBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@PreliminaryName", HttpContext.Current.Session["LoginName"].ToString()), new MySqlParameter("@PreliminaryDateTime", DateTime.Now), new MySqlParameter("@ApprovedBy", ApprovedBy), new MySqlParameter("@ApprovedName", ApprovalName),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if (ResultStatus == "UnHold")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,UnHoldBy = @UnHoldBy,UnHoldByName=@UnHoldByName,unholddate=now() WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and isHold=1",
                            new MySqlParameter("@isHold", "0"),
                            new MySqlParameter("@UnHoldBy", HttpContext.Current.Session["ID"].ToString()),
                            new MySqlParameter("@UnHoldByName", HttpContext.Current.Session["LoginName"].ToString()),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if (ResultStatus == "Hold")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,HoldBy = @HoldBy,HoldByName=@HoldByName,Hold_Reason=@Hold_Reason WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and isHold =0 ",
                            new MySqlParameter("@isHold", "1"),
                            new MySqlParameter("@HoldBy", HttpContext.Current.Session["ID"].ToString()),
                            new MySqlParameter("@HoldByName", HttpContext.Current.Session["LoginName"].ToString()), new MySqlParameter("@Hold_Reason", HoldRemarks),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    isPartial = 0;
                    string audit = savestatus(tnx, pdeatil.BarcodeNo, pdeatil.LabNo, pdeatil.Test_ID, "Report " + ResultStatus + " For :" + pdeatil.TestName);
                    if (audit == "fail")
                    {
                        Exception ex = new Exception("Status Not Saved.Please Contact To Itdose..!");
                        throw (ex);
                    }

                    deleteTestIDAftersave = pdeatil.Test_ID;
                }

                if ((value != string.Empty) || (pdeatil.Description != string.Empty && pdeatil.Description != null))
                {
                    if ((oldPLIID != PLId))
                    {
                        if (value != "HEAD" && ResultStatus == "Save")
                        {
                            str = "update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,'" + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1 ";
                            if (isPartial == 0)
                            {
                                str += ",isPartial_Result='0' ";
                            }
                            str += " where test_id='" + PLId + "'  and isSampleCollected='Y' and approved=0 ";
                            RowsAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                            oldPLIID = PLId;
                            isPartial = 0;
                        }
                    }
                }
                else
                {
                    if (isPartial_PLID != PLId && ResultRequiredField == 1)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  PrintSeparate = @PrintSeparate,isPartial_Result = @isPartial_Result  WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@PrintSeparate", strPrintSeparate), new MySqlParameter("@isPartial_Result", "1"),
                            new MySqlParameter("@Test_ID", PLId),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                        isPartial_PLID = PLId;
                        isPartial = 1;
                    }
                }
            }
            string oldInterTestID = string.Empty;
            foreach (ResultEntryProperty pdeatil in data)
            {
                if ((pdeatil.Inv == "1") || (pdeatil.Inv == "3"))
                    continue;

                else if (pdeatil.Inv == "2")
                {
                    continue;
                }
                int ObsQty = 0;
                int DoInter = 0;
                int DoInterObs = 0;
                string TypeOfInterpretation = string.Empty;
                DataTable dtTempInter = new DataTable();
                if (oldInterTestID != pdeatil.Test_ID)
                {
                    oldInterTestID = pdeatil.Test_ID;
                }
                else
                {
                    continue;
                }
                string ploDataFlag = Util.GetString(pdeatil.Flag);
                if (ploDataFlag.Trim() == "")
                    ploDataFlag = "Normal";
                ObsQty = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT count(*) FROM `labobservation_investigation` WHERE investigation_id=@investigation_id ",
                        new MySqlParameter("@investigation_id", pdeatil.Investigation_ID)));
                dtTempInter = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT labObservation_ID,flag,Interpretation,PrintInterTest,PrintInterPackage FROM labobservation_master_interpretation   where labObservation_ID=@labObservation_ID and flag=@flag and centreid=@centreid and macid=@macid ",
                        new MySqlParameter("@labObservation_ID", pdeatil.LabObservation_ID),
                        new MySqlParameter("@flag", ploDataFlag),
                        new MySqlParameter("@centreid", "2"),
                        new MySqlParameter("@macid", "1")).Tables[0];
                if (ObsQty == 1 && dtTempInter.Rows.Count > 0)  // Observation Wise Interpretation 
                {
                    if (pdeatil.IsPackage == "1" && Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"]) == "1")
                    {
                        DoInterObs = 1;
                        TypeOfInterpretation = "ObservationWise";
                    }
                    else if (pdeatil.IsPackage == "0" && Util.GetString(dtTempInter.Rows[0]["PrintInterTest"]) == "1")
                    {
                        DoInterObs = 1;
                        TypeOfInterpretation = "ObservationWise";
                    }
                    if (DoInterObs == 1 && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br/>" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br />")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from patient_labinvestigation_opd_interpretation where Test_ID=@Test_ID and TYPE=@TYPE ",
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@TYPE", "ObservationWise"));
                        StringBuilder myStr = new StringBuilder();
                        myStr.Append(" INSERT INTO patient_labinvestigation_opd_interpretation  ");
                        myStr.Append(" (Test_ID,Interpretation,PrintInterTest,PrintInterPackage,TYPE,dtEntry,EnteredByID,EnteredByName) ");
                        myStr.Append(" VALUES(@Test_ID,@Interpretation,@PrintInterTest,@PrintInterPackage,@TYPE,@dtEntry,@EnteredByID,@EnteredByName) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@Interpretation", dtTempInter.Rows[0]["Interpretation"].ToString()),
                            new MySqlParameter("@PrintInterTest", Util.GetString(dtTempInter.Rows[0]["PrintInterTest"])),
                            new MySqlParameter("@PrintInterPackage", Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"])),
                            new MySqlParameter("@TYPE", TypeOfInterpretation),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@EnteredByID", HttpContext.Current.Session["ID"].ToString()),
                            new MySqlParameter("@EnteredByName", HttpContext.Current.Session["LoginName"].ToString()));
                    }
                }
                dtTempInter = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT Investigation_Id,Interpretation,PrintInterTest,PrintInterPackage FROM investigation_master_Interpretation where Investigation_Id=@Investigation_Id and centreid=@centreid and macid=@macid ",
                    new MySqlParameter("@Investigation_Id", pdeatil.Investigation_ID),
                    new MySqlParameter("@centreid", "2"),
                    new MySqlParameter("@macid", "1")).Tables[0];
                if (dtTempInter.Rows.Count > 0)
                {
                    if (pdeatil.IsPackage == "1" && Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"]) == "1")
                    {
                        DoInter = 1;
                        TypeOfInterpretation = "InvestigationWise";
                    }
                    else if (pdeatil.IsPackage == "0" && Util.GetString(dtTempInter.Rows[0]["PrintInterTest"]) == "1")
                    {
                        DoInter = 1;
                        TypeOfInterpretation = "InvestigationWise";
                    }
                    if (DoInter == 1 && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br/>" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br />")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from patient_labinvestigation_opd_interpretation where Test_ID=@Test_ID and TYPE=@TYPE ",
                               new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@TYPE", "InvestigationWise"));
                        StringBuilder myStr = new StringBuilder();
                        myStr.Append(" INSERT INTO patient_labinvestigation_opd_interpretation  ");
                        myStr.Append(" (Test_ID,Interpretation,PrintInterTest,PrintInterPackage,TYPE,dtEntry,EnteredByID,EnteredByName) ");
                        myStr.Append(" VALUES(@Test_ID,@Interpretation,@PrintInterTest,@PrintInterPackage,@TYPE,@dtEntry,@EnteredByID,@EnteredByName) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@Interpretation", dtTempInter.Rows[0]["Interpretation"].ToString()),
                            new MySqlParameter("@PrintInterTest", Util.GetString(dtTempInter.Rows[0]["PrintInterTest"])),
                            new MySqlParameter("@PrintInterPackage", Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"])),
                            new MySqlParameter("@TYPE", TypeOfInterpretation),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@EnteredByID", HttpContext.Current.Session["ID"].ToString()),
                            new MySqlParameter("@EnteredByName", HttpContext.Current.Session["LoginName"].ToString()));
                    }
                }
            }
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);
        }
        return "success";
    }



    private static void DLC_Check(List<ResultEntryProperty> data, string ResultStatus)
    {
        float DLC = 0f;
        float Semen = 0f;
        string test = "";
        string test1 = "";
        int atfile = 0;
        int _isBloodGroup = 0;
        int crNo = 0;
        XmlDocument loResource = new XmlDocument();
        loResource.Load(HttpContext.Current.Server.MapPath("App_LocalResources/MachineResultEntry.aspx.resx"));
        foreach (ResultEntryProperty pdeatil in data)
        {
            crNo = crNo + 1;
            string[] DLC_ObervationIDs = loResource.SelectSingleNode("root/data[@name='DLC_ObervationIDs']/value").InnerText.ToString().Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (DLC_ObervationIDs.Contains(pdeatil.LabObservation_ID))
            {
                DLC = DLC + Util.GetFloat(pdeatil.Value);
                test = test + ", " + pdeatil.LabObservationName;
            }
            string[] Semen_ObservationIDs = loResource.SelectSingleNode("root/data[@name='Semen_ObservationIDs']/value").InnerText.ToString().Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (Semen_ObservationIDs.Contains(pdeatil.LabInvestigation_ID))// semen report
            {
                Semen = Semen + Util.GetFloat(pdeatil.Value);
                test1 = test1 + ", " + pdeatil.LabObservationName;
            }
            if (pdeatil.LabObservationName == "Attached Report")
            {
                atfile = 1;
            }
            if ((pdeatil.ResultRequired == "1") && (pdeatil.Value == "") && (ResultStatus == "Approved") && (pdeatil.Method != "1") && (atfile == 0))
                throw (new Exception("All parameter needs to be filled before approval."));
            if (pdeatil.Investigation_ID == "25")
            {
                _isBloodGroup = 1;
            }

            double o;
            if ((pdeatil.Value != string.Empty) && (pdeatil.IsCritical == "1") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                // bool aa = double.TryParse(pdeatil.Value.Trim(), out o);
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == "")
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {
                        if (Util.GetInt(pdeatil.isrerun) == 0 && Util.GetString(pdeatil.MacReading) != "" && Util.GetString(pdeatil.Reading1) == "")
                            throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to proceed further"));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != "" && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {
                    if (Util.GetInt(pdeatil.isrerun) == 0 && Util.GetString(pdeatil.MacReading) != "" && Util.GetString(pdeatil.Reading1) == "")
                        throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to proceed further"));
                }
            }
            if ((pdeatil.Value != string.Empty) && Util.GetInt(pdeatil.pliIsReRun) == 1 && (pdeatil.IsCritical == "1") && (pdeatil.MacReading == "") && (pdeatil.Reading1 != "") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == "")
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {
                        throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to machine for proceed further"));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != "" && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {
                    throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to machine for proceed further"));
                }
            }
            if ((pdeatil.Value != string.Empty) && (pdeatil.IsCritical == "1") && (Util.GetString(pdeatil.Value1) == "") && (Util.GetString(pdeatil.MacReading) == "") && (Util.GetString(pdeatil.Reading1) == "") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == "")
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {
                        throw (new Exception("ManualCritical|" + pdeatil.LabObservationName + '|' + pdeatil.Value.Trim() + '|' + pdeatil.Test_ID + '|' + pdeatil.LabObservation_ID + '|' + crNo + '|' + pdeatil.ManualValue));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != "" && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {
                    throw (new Exception("ManualCritical|" + pdeatil.LabObservationName + '|' + pdeatil.Value.Trim() + '|' + pdeatil.Test_ID + '|' + pdeatil.LabObservation_ID + '|' + crNo + '|' + pdeatil.ManualValue));
                }
            }

        }
        if (_isBloodGroup == 1)
        {
            var bloodGroupCount = data.Count(x => x.Investigation_ID == "25" && Util.GetString(x.Value) == "");
            var Is_BLOODGROUPTYPE_Blank = data.Count(x => x.Investigation_ID == "25" && Util.GetString(x.Value) == "" && Util.GetString(x.MacReading) == "" && x.LabObservation_ID == "933");
            var Is_RhTYPE_Blank = data.Count(x => x.Investigation_ID == "25" && Util.GetString(x.Value) == "" && Util.GetString(x.MacReading) == "" && x.LabObservation_ID == "934");
            if ((bloodGroupCount != 8) && (Is_BLOODGROUPTYPE_Blank == 1 || Is_RhTYPE_Blank == 1))
            {
                throw (new Exception("Please Enter Correct Format For Blood Group"));
            }
        }
        test = test.Trim(',');
        test1 = test1.Trim(',');
        //if (Util.GetFloat(data[0].AgeInDays) > 4745)
        //{
        if ((DLC > 0) && (Convert.ToInt32(DLC) != 100))
            throw (new Exception("Total " + test + " should be equal to 100."));

        //if ((Semen > 0) && (Semen != 100))
        //    throw (new Exception("Total " + test1 + " should be equal to 100."));
        //}
    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchInvestigation(string LabNo, string SmpleColl, string Department)
    {
        try
        {
            string checkSession = HttpContext.Current.Session["CentreID"].ToString().ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT plo.InvestigationName, plo.Test_ID,plo.IsSampleCollected, im.name,plo.`SampleTypeID`,plo.`SampleTypeName`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`, ");
        sbQuery.Append(" IF(plo.SampleTypeID=0,   ");
        sbQuery.Append(" IFNULL((SELECT CONCAT(ist.SampleTypeID ,'^',ist.SampleTypeName) FROM investigations_SampleType ist   ");
        sbQuery.Append("  WHERE ist.Investigation_Id =plo.Investigation_ID ORDER BY ist.isDefault DESC,ist.SampleTypeName LIMIT  1),'1|')  ");
        sbQuery.Append(" ,CONCAT(plo.`SampleTypeID`,'|',plo.`SampleTypeName`))  SampleID,    ");
        sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(inv_smpl.SampleTypeID,'|',inv_smpl.SampleTypeName)ORDER BY  inv_smpl.SampleTypeName SEPARATOR '$')SampleTypes    ");
        sbQuery.Append(" FROM `patient_labinvestigation_opd` plo ");
        sbQuery.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");

        if (Department != "")
            sbQuery.Append(" inner join investigation_observationtype iot on iot.Investigation_ID=plo.Investigation_ID and iot.ObservationType_ID='" + Department + "' ");

        switch (SmpleColl)
        {
            case "N": sbQuery.Append(" and plo.IsSampleCollected='N' ");
                break;
            case "Y": sbQuery.Append(" and plo.IsSampleCollected='Y' ");
                break;
            case "S": sbQuery.Append(" and plo.IsSampleCollected='S' ");
                break;
        }
        sbQuery.Append(" LEFT JOIN `investigations_SampleType` inv_smpl  ");
        sbQuery.Append(" ON inv_smpl.`Investigation_ID`=im.`Investigation_Id` ");
        sbQuery.Append(" WHERE plo.`LedgerTransactionNo`='" + LabNo + "' ");
        sbQuery.Append(" GROUP BY plo.LedgerTransactionNo,plo.Investigation_ID ");
        DataTable dt1 = StockReports.GetDataTable(sbQuery.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt1);

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveSampleCollection(string ItemData, string Type)
    {
        try
        {
            string checkSession = HttpContext.Current.Session["CentreID"].ToString().ToString();
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            ItemData = ItemData.TrimEnd('#');
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
            string UserID = HttpContext.Current.Session["ID"].ToString().ToString();
            if (ItemData != "")
            {
                for (int i = 0; i < len; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    if (Type == "CR")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  IsSampleCollected = @IsSampleCollected,SampleTypeID = @SampleTypeID,SampleTypeName=@SampleTypeName,SampleSegratedBy_ID=@SampleSegratedBy_ID,SegratedDate=@SegratedDate, UpdateID=@UpdateID,UpdateName=@UpdateName,updateDate=@updateDate,IPAddress=@IPAddress  WHERE Test_ID=@Test_ID",
                           new MySqlParameter("@IsSampleCollected", 'Y'),
                           new MySqlParameter("@SampleTypeID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@SampleTypeName", Item[i].Split('_')[2].ToString()), new MySqlParameter("@SampleSegratedBy_ID", HttpContext.Current.Session["ID"].ToString()),
                           new MySqlParameter("@SampleSegratedBy", HttpContext.Current.Session["LoginName"].ToString()),
                           new MySqlParameter("@SegratedDate", DateTime.Now),
                           new MySqlParameter("@UpdateID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@UpdateName", HttpContext.Current.Session["ID"].ToString()),
                           new MySqlParameter("@updateDate", DateTime.Now), new MySqlParameter("@IPAddress", All_LoadData.IpAddress()),
                           new MySqlParameter("@Test_ID", Item[i].Split('_')[0].ToString()));


                        //sb.Append(" Update patient_labinvestigation_opd Set IsSampleCollected = 'Y' ,");
                        //sb.Append(" SampleTypeID='" + Item[i].Split('_')[1].ToString() + "', ");
                        //sb.Append(" SampleTypeName='" + Item[i].Split('_')[2].ToString() + "', ");
                        //sb.Append(" SampleSegratedBy_ID='" + HttpContext.Current.Session["ID"].ToString() + "', ");
                        //sb.Append(" SampleSegratedBy = '" + HttpContext.Current.Session["LoginName"].ToString() + "',SegratedDate=NOW(), ");
                        //sb.Append(" UpdateID='" + Item[i].Split('_')[1].ToString() + "', ");
                        //sb.Append(" UpdateName='" + HttpContext.Current.Session["ID"].ToString() + "', ");
                        //sb.Append(" updatedate=NOW(),IPAddress='" + All_LoadData.IpAddress() + "'  where Test_ID='" + Item[i].Split('_')[0].ToString() + "' ");
                    }
                    if (Type == "C")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  IsSampleCollected = @IsSampleCollected,SampleTypeID = @SampleTypeID,SampleTypeName=@SampleTypeName,SampleSegratedBy_ID=@SampleSegratedBy_ID,SampleSegratedBy=@SampleSegratedBy,SegratedDate=@SegratedDate, UpdateID=@UpdateID,UpdateName=@UpdateName,updateDate=@updateDate,IPAddress=@IPAddress  WHERE Test_ID=@Test_ID",
                           new MySqlParameter("@IsSampleCollected", 'S'),
                           new MySqlParameter("@SampleTypeID", Item[i].Split('_')[1].ToString()),
                           new MySqlParameter("@SampleTypeName", Item[i].Split('_')[2].ToString()),
                           new MySqlParameter("@SampleSegratedBy_ID", HttpContext.Current.Session["ID"].ToString()),
                           new MySqlParameter("@SampleSegratedBy", HttpContext.Current.Session["LoginName"].ToString()),
                           new MySqlParameter("@SegratedDate", DateTime.Now),
                           new MySqlParameter("@UpdateID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@UpdateName", HttpContext.Current.Session["ID"].ToString()),
                           new MySqlParameter("@updateDate", DateTime.Now), new MySqlParameter("@IPAddress", All_LoadData.IpAddress()),
                           new MySqlParameter("@Test_ID", Item[i].Split('_')[0].ToString()));
                    }

                }
                tnx.Commit();
                return "1";
            }
            else
            {
                return "0";
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getBarcode(string LabNo, string TestID)
    {
        StringBuilder sb = new StringBuilder();

        TestID = TestID.Replace(",", "','");


        sb.Append("SELECT UPPER(PName) AS Patient,CONCAT_WS('/', Age, Gender) AS AG, TestName, ");
        sb.Append(" BarcodeNo AS MachineCode,  LedgerTransactionNo AS PatientNo, ");
        sb.Append(" DATE_FORMAT(DATE, '%d-%b-%y') AS DATE,  Suffix, ");
        sb.Append(" SampleTypeName,ColorCode, ");
        sb.Append("  (SELECT `Company_Name` FROM f_panel_master pnl WHERE pnl.PanelID = PanelID LIMIT 1) PanelName ");

        sb.Append(" FROM (SELECT lt.date,pm.PName PName, ");
        sb.Append(" inv_mas.Name TestName,pm.Age,pm.Gender,lt.`LedgerTransactionNo`,IFNULL(ist.SampleTypeName, '') SampleTypeName, ");
        sb.Append("   lt.PanelID,plo.BarcodeNo,im.PrintName,inv_mas.ColorCode,IFNULL(lm.`Suffix`, '') Suffix    ");
        sb.Append("  FROM `f_ledgertransaction` lt      ");
        sb.Append("  INNER JOIN patient_labinvestigation_opd plo    ");
        sb.Append("  ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo`  ");

        sb.Append(" INNER JOIN investigation_master inv_mas ON inv_mas.Investigation_Id=plo.Investigation_ID");
        sb.Append(" AND plo.test_id IN ('" + TestID + "')    ");
        sb.Append("  INNER JOIN f_itemmaster im ON im.type_id=plo.Investigation_id INNER JOIN f_subcategorymaster sc ON sc.subcategoryid=im.subcategoryid AND sc.categoryid='LSHHI3'    ");
        sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=lt.`PatientID`  ");
        sb.Append("  LEFT JOIN   `labobservation_investigation` li ON plo.Investigation_id=li.Investigation_id ");
        sb.Append("  LEFT JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
        sb.Append("  LEFT JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=plo.`Investigation_ID`    and ist.IsDefault='1' ");
        sb.Append("  GROUP BY IFNULL(li.Investigation_id,''),IFNULL(lm.`Suffix`,'') ");

        sb.Append(" ) aa  ");

        sb.Append("   GROUP BY  SampleTypeName,Suffix;     ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        string returnStr = "";

        foreach (DataRow dr in dt.Rows)
            returnStr = returnStr + "" + (returnStr == "" ? "" : "^") + dr["Patient"].ToString() + "," +
                        dr["AG"].ToString() + ",a," + dr["MachineCode"].ToString() + "" + dr["Suffix"].ToString().Trim() + "," +
                        dr["PatientNo"].ToString() + "," +
                        dr["DATE"].ToString();

        return returnStr;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CheckBarcode(string BarcodeNo)
    {
        string[] barcode = BarcodeNo.Split(',');
        string str = "";
        for (int i = 0; i < barcode.Length; i++)
        {
            if (str == "")
            {
                str += "'" + barcode[i] + "'";
            }
            else
            {
                str += "," + "'" + barcode[i] + "'";
            }
        }

        string Exists = "";
        DataTable barcodes = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text,
            "SELECT GROUP_CONCAT(DISTINCT barcodeNo)barcodeNo FROM `patient_labinvestigation_opd` WHERE barcodeNo in (" + str + ")").Tables[0];
        if (barcodes.Rows.Count > 0)
        {
            Exists = Util.GetString(barcodes.Rows[0]["barcodeNo"]);
        }
        return Exists;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveRemarksStatus(string TestID, string Remarks, string LedgerTransactionNo)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] arr = TestID.Split(',');
            for (int i = 0; i < arr.Length; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labinvestigation_opd_remarks WHERE `Test_ID`=@Test_ID",
                       new MySqlParameter("@Test_ID", arr[i]));

                StringBuilder sbIns = new StringBuilder();

                sbIns.Append("INSERT INTO patient_labinvestigation_opd_remarks(UserID,UserName,Test_ID,Remarks,LedgerTransactionNo) ");
                sbIns.Append(" VALUES(@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbIns.ToString(),
                    new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
                    new MySqlParameter("@UserName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                    new MySqlParameter("@Test_ID", arr[i]),
                    new MySqlParameter("@Remarks", Remarks),
                    new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
            }
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);

        }
        return "1";
    }



    static string savestatus(MySqlTransaction tnx, string barcodeno, string LedgerTransactionNo, string ID, string status)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                      new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                      new MySqlParameter("@SinNo", barcodeno), new MySqlParameter("@Test_ID", ID),
                      new MySqlParameter("@Status", status), new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@UserName", HttpContext.Current.Session["LoginName"].ToString()),
                      new MySqlParameter("@IpAddress", All_LoadData.IpAddress()), new MySqlParameter("@CentreID", HttpContext.Current.Session["CentreID"].ToString()), new MySqlParameter("@RoleID", HttpContext.Current.Session["RoleID"].ToString()), new MySqlParameter("@DispatchCode", ""));
            return "success";
        }
        catch
        {
            return "fail";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindTestToForward(string testid)
    {
        testid = "'" + testid + "'";
        testid = testid.Replace(",", "','");
        DataTable dt = StockReports.GetDataTable(" select im.name,plo.test_id from patient_labinvestigation_opd plo  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` and plo.test_id in(" + testid + ") ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindCentreToForward()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT centreid,CentreName centre FROM center_master WHERE ISActive=1  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindDoctorToForward(string centre)
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
        sbQuery.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=fl.`EmployeeID` ");
        sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
        sbQuery.Append("  WHERE centreid=" + centre + " and fl.employeeid<>'" + HttpContext.Current.Session["ID"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ForwardMe(string testid, string centre, string forward, int MobileApproved = 0, string MobileEMINo = "", string MobileNo = "", string MobileLatitude = "", string MobileLongitude = "")
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=@ForwardDate,ForwardToCentre=@ForwardToCentre,ForwardToDoctor=@ForwardToDoctor WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                new MySqlParameter("@isForward", 1), new MySqlParameter("@ForwardBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@ForwardByName", HttpContext.Current.Session["LoginName"].ToString()),
                new MySqlParameter("@ForwardDate", DateTime.Now), new MySqlParameter("@ForwardToCentre", centre), new MySqlParameter("@ForwardToDoctor", forward),
                new MySqlParameter("@Test_ID", testid),
                new MySqlParameter("@isSampleCollected", 'Y'));

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,'Forward','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','" + All_LoadData.IpAddress() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
            sb.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + testid + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            //*Start The below code use for store mobile transaction details 
            if (MobileApproved == 1)
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append("INSERT INTO `patient_labinvestigation_opd_mobile_transaction`(`Test_ID`,`Status`,`UserID`,`MobileEMINo`,MobileNo,MobileLatitude,MobileLongitude)");
                sb1.Append(" VALUES(@Test_ID,@Status,@UserID,@MobileEMINo,@MobileNo,@MobileLatitude,@MobileLongitude)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),
                    new MySqlParameter("@Test_ID", testid),
                    new MySqlParameter("@Status", "Forward"),
                    new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
                    // new MySqlParameter("@EntryDateTime", Util.GetString(HttpContext.Current.Session["LoginName"].ToString())), new MySqlParameter("@dtEntry", DateTime.Now),
                    new MySqlParameter("@MobileEMINo", Util.GetString(MobileEMINo)),
                    new MySqlParameter("@MobileNo", Util.GetString(MobileNo)),
                    new MySqlParameter("@MobileLatitude", Util.GetString(MobileLatitude)),
                    new MySqlParameter("@MobileLongitude", Util.GetString(MobileLongitude))
                 );
            }
            //* End
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);

        }


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savetemplate(string temp, string tempname, string invid)
    {
        try
        {
            temp = temp.Replace("\'", "");
            temp = temp.Replace("–", "-");
            temp = temp.Replace("'", "");
            temp = temp.Replace("µ", "&micro;");
            temp = temp.Replace("ᴼ", "&deg;");
            temp = temp.Replace("#aaaaaa 1px dashed", "none");
            temp = temp.Replace("dashed", "none");

            StockReports.ExecuteDML("insert into investigation_template (Investigation_ID,Temp_Head,Template_Desc,UpdateBy) values( '" + invid + "','" + tempname + "','" + temp + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return "1";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getreflextestlist(string Test_ID, string LabObservation_ID, string LabNo, string Investigation_ID)
    {
        string q1 = @"SELECT ifnull(GROUP_CONCAT(CONCAT(NAME,'#',investigation_id,'#','" + Test_ID + "','#','" + LabObservation_ID + "')),'') testtobook FROM investigation_master im  INNER JOIN investigation_reflecttest ir ON im.investigation_id=ir.Reflecttestid AND ir.labobservation_id='" + LabObservation_ID + "' AND ir.investigationid='" + Investigation_ID + "' and investigation_id not in (select investigation_id from patient_labinvestigation_opd where LedgerTransactionNo='" + LabNo + "')";
        return StockReports.ExecuteScalar(q1);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Crop(string W, string H, string X, string Y, string ImgPath)
    {
        string filePath = HttpContext.Current.Server.MapPath("~/HistoUploads/");
        File.WriteAllBytes(filePath, Convert.FromBase64String(ImgPath));
        string ImageName = HttpContext.Current.Session["WorkingImage"].ToString();
        string filename = HttpContext.Current.Session["filename"].ToString();
        string SaveTo = "";

        int w = Convert.ToInt32(W);

        int h = Convert.ToInt32(H);

        int x = Convert.ToInt32(X);

        int y = Convert.ToInt32(Y);

        String path = filePath + "HistoUploads\\";
        byte[] CropImage = Crop(path + ImageName, w, h, x, y);

        using (System.IO.MemoryStream ms = new System.IO.MemoryStream(CropImage, 0, CropImage.Length))
        {

            ms.Write(CropImage, 0, CropImage.Length);

            using (SD.Image CroppedImage = SD.Image.FromStream(ms, true))
            {

                SaveTo = path + ImageName;

                CroppedImage.Save(SaveTo, CroppedImage.RawFormat);

            }

        }
        string TempPath = HttpContext.Current.Server.MapPath("~");
        TempPath = TempPath + @"\HistoUploads\" + ImageName;
        byte[] UploadFileButes = System.IO.File.ReadAllBytes(TempPath);
        //ReportServerFileUpload.FileUploadedService FlReportService = new ReportServerFileUpload.FileUploadedService();
        //FlReportService.UploadFile(UploadFileButes, filename, HttpContext.Current.Session["CurrentFileUploadedLocation"].ToString());
        return Convert.ToBase64String(UploadFileButes);
        //return filePath + ImageName;
    }

    static byte[] Crop(string Img, int Width, int Height, int X, int Y)
    {

        try
        {

            using (SD.Image OriginalImage = SD.Image.FromFile(Img))
            {

                using (SD.Bitmap bmp = new SD.Bitmap(Width, Height))
                {

                    bmp.SetResolution(OriginalImage.HorizontalResolution, OriginalImage.VerticalResolution);

                    using (SD.Graphics Graphic = SD.Graphics.FromImage(bmp))
                    {

                        Graphic.SmoothingMode = SmoothingMode.AntiAlias;

                        Graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;

                        Graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;

                        Graphic.DrawImage(OriginalImage, new SD.Rectangle(0, 0, Width, Height), X, Y, Width, Height, SD.GraphicsUnit.Pixel);

                        System.IO.MemoryStream ms = new System.IO.MemoryStream();

                        bmp.Save(ms, OriginalImage.RawFormat);

                        return ms.GetBuffer();

                    }

                }

            }

        }

        catch (Exception Ex)
        {

            throw (Ex);

        }

    }
    [WebMethod]
    public static string BindPatientDetails(string LedgerTransactionNo)
    {
        DataTable PatientDetails = StockReports.GetDataTable("SELECT CONCAT(pm.Title,' ',pm.PName)PName,plo.BarcodeNo,pm.PatientID FROM patient_labinvestigation_opd plo INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID WHERE plo.LedgerTransactionNo =" + LedgerTransactionNo + " LIMIT 1");
        DataTable grvAttachment = StockReports.GetDataTable("SELECT FileUrl,(SELECT NAME FROM `employee_master` WHERE EmployeeID= UploadedBy) UploadedBy,Updatedate FROM patient_labinvestigation_attachment WHERE LedgerTransactionNo=" + LedgerTransactionNo + " order by 1 desc ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { PatientDetails, grvAttachment });
    }

    [WebMethod]
    public static string BindTestDDL(string LedgerTransactionNo, string TestID)
    {
        TestID = "'" + TestID + "'";
        TestID = TestID.Replace(",", "','");
        StringBuilder sb = new StringBuilder();
        sb = new StringBuilder();
        sb.Append("SELECT pli.`Test_ID`,CONCAT(im.Name,' (',pli.Remarks,')')Name FROM patient_labinvestigation_opd pli ");
        sb.Append("INNER JOIN `investigation_master` im ");
        sb.Append("ON pli.`Investigation_ID`=im.`Investigation_Id` ");
        sb.Append("AND pli.LedgerTransactionNo = " + Util.GetString(LedgerTransactionNo) + " AND Test_ID in (" + TestID + ")  ");
        //sb.Append("AND pli.Approved=0 AND pli.`IsSampleCollected`='Y' And pli.IsOutSource=1 ORDER BY im.`Name` ");
        sb.Append("AND pli.Approved=0 AND pli.`IsSampleCollected`='Y' ORDER BY im.`Name` ");
        DataTable PatientDetails = StockReports.GetDataTable(sb.ToString());
        //if (PatientDetails.Rows.Count == 0)
        //{
        //    // lblMsg.Text = "This Test Is Not OutSource";
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { PatientDetails }); "0";
        //    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('This Test Is Not OutSource');", true);
        //}
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { PatientDetails });
    }
    [WebMethod]
    public static string bindAttachment(string TestID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pli.Test_ID,pli.`id`,pli.`AttachedFile`,plo.Approved,pli.FileUrl AS FileUrl,em.`Name` AS UploadedBy,DATE_FORMAT(pli.`dtEntry`,'%d-%b-%y') AS dtEntry  ");
        sb.Append(" FROM `patient_labinvestigation_attachment_report` pli  ");
        sb.Append(" inner join `patient_labinvestigation_opd` plo on pli.Test_ID=plo.Test_ID  ");
        sb.Append(" INNER JOIN `employee_master` em ON em.`EmployeeID`=pli.`UploadedBy` and pli.Test_ID='" + TestID + "' ");
        DataTable dtdetail = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtdetail });
    }

    [WebMethod]
    public static bool RemoveData(string TestID, string FileUrl)
    {
        var RootDir = All_LoadData.createDocumentFolder("LABINVESTIGATION", "OutSourceLabReport");
        string filePath = Path.Combine(RootDir.ToString(), FileUrl);
        if (File.Exists(filePath))
        {
            File.Delete(filePath);
        }
        bool text = StockReports.ExecuteDML("delete from patient_labinvestigation_attachment_report where Test_ID='" + TestID + "'");
        return text;
    }

    [WebMethod]
    public static string Bindsampleinfo(string LedgerTransactionNo,string Test_ID )
    {
        Test_ID = Test_ID.ToString().Replace(",", "','");
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT IFNULL(date_format(pm.DOB,'%d-%b-%Y'),'') DOB,plo.LedgerTransactionNo, IFNULL((SELECT ID FROM patient_labinvestigation_attachment dd WHERE dd.LedgerTransactionNo =lt.`LedgerTransactionNo` LIMIT 1 ),'')DocumentStatus,plo.BarcodeNo,em.name as WorkOrderBy,plo.Remarks Comments,plo.isHold,if(plo.isHold=1,IFNULL(plo.holdByName,''),'')holdByName,if(plo.isHold=1,plo.Hold_Reason,'')Hold_Reason,IFNULL(DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%y %I:%i%p'),'') SegratedDate,plo.SampleCollector, CONCAT(dm.Title,' ',dm.Name) AS ReferDoctor  ,fpm.Company_Name Panel_Code, plo.Approved,  plo.ApprovedBy, IFNULL(plo.ApprovedName,'')ApprovedName, IFNULL(Date_Format(plo.ApprovedDate,'%d-%b-%y %I:%i%p'),'')ApprovedDate, if(plo.IsSampleCollected='R',psr.RejectionReason,'')RejectionReason,IFNULL(plo.ResultEnteredName,'') ResultEnteredName,IFNULL(DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%y %I:%i%p'),'')ResultEnteredDate,(select Name from employee_master where EmployeeID=plo.ApprovedBy)ApprovedDoneBy,  ");
        sb.Append("    plo.sampletype SampleType,CONCAT(pm.Title,' ',pm.PName) PName, pm.Gender,CONCAT(pm.Age,'/',LEFT(pm.Gender,1)) Age,PM.Mobile Mobile,otm.Name DepartmentName, if(plo.IsSampleCollected='R',psr.RejectionReason,'')RejectionReason, plo.SampleCollector, IFNULL(DATE_FORMAT(plo.SampleCollectionDate, '%d-%b-%y %I:%i%p'),'') SegratedDate,  ");
        sb.Append("    if(plo.IsSampleCollected='R',IFNULL(DATE_FORMAT(psr.entdate,'%d-%b-%y %I:%i%p'),''),'') RejectDate,  ");
        //sb.Append("    DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%y %I:%i%p')SampleReceiveDate ,SampleReceiver SampleReceivedBy, ");

        sb.Append("   IF(DATE(plo.SampleReceiveDate)='0001-01-01','',IFNULL(DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%y %I:%i%p'),''))SampleReceiveDate,IFNULL((SELECT NAME FROM employee_master WHERE EmployeeID = plo.SampleReceivedBy),'') SampleReceivedBy, ");
        sb.Append("    if(plo.IsSampleCollected='R',(SELECT NAME FROM employee_master WHERE EmployeeID=psr.UserID),'') RejectUser , im.name,'' HomeCollectionDate ");
        sb.Append("    ,if(plo.Type=2,Get_Current_Room(plo.TransactionID),'') BedDetails FROM   ");
        sb.Append("    (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo='" + LedgerTransactionNo + "' AND Test_ID IN ('" + Test_ID + "') ) plo  ");
        sb.Append("    inner join f_ledgertransaction lt on lt.LedgerTransactionNo=plo.LedgerTransactionNo inner join employee_master em on em.EmployeeID=lt.UserID  ");
        sb.Append("    INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID  ");
        sb.Append("    INNER JOIN doctor_master dm ON dm.DoctorID = plo.DoctorID ");
        sb.Append("    INNER JOIN f_panel_master fpm ON fpm.PanelID=lt.PanelID ");
        sb.Append("    INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = plo.Investigation_ID  ");
        sb.Append("    INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id   ");
        sb.Append("    INNER JOIN investigation_master im ON im.Investigation_Id=iom.Investigation_ID");
        sb.Append("    LEFT JOIN (SELECT * FROM patient_sample_rejection psr WHERE psr.Test_ID IN ('" + Test_ID + "') ORDER BY EntDate DESC LIMIT 1 ) psr ON psr.Test_ID=plo.test_ID  ");
        sb.Append("    GROUP BY plo.Investigation_Id  ");
        DataTable SampleInfodt = new DataTable();
        SampleInfodt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { SampleInfodt });
    }


    [WebMethod(EnableSession = true)]
    public static string GetLabActiveData(string LedgerTransactionNo)
    {
        DataTable appointmentDetails = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT plo.`ID`,plo.`Test_ID`,im.`NAME`,plo.`Investigation_ID`FROM patient_labinvestigation_opd plo  ");
            sb.Append("  INNER JOIN investigation_master im ON im.`Investigation_Id`=plo.`Investigation_ID`  ");
            sb.Append("  WHERE plo.`LedgerTransactionNo`='" + LedgerTransactionNo + "' and plo.Approved=0  ");

            appointmentDetails = StockReports.GetDataTable(sb.ToString());


            if (appointmentDetails.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "No Item Found. Result is already Approved ." });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "Error in fetching lab data." });
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RecollectData(string TestID,string ResionToRecollect)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsAvail = Util.GetInt(StockReports.ExecuteScalar("select count(BarcodeNo) from patient_labinvestigation_opd  where Approved=0 AND Test_Id in ('" + TestID.Replace(",", "','") + "') "));
            if (IsAvail > 0)
            {
                int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_recollect_log SELECT plo.*  FROM patient_labinvestigation_opd plo  WHERE Test_Id IN ('" + TestID.Replace(",", "','") + "') ");
                int j = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd plo SET macstatus=0,RecollectResion='" + ResionToRecollect + "',plo.`Result_Flag`=0,plo.`IsSampleCollected`='N',plo.`RecollectedBy`='" + HttpContext.Current.Session["ID"].ToString() + "',plo.`RecollectedByName`='" + HttpContext.Current.Session["EmployeeName"].ToString() + "',plo.`IsRecollect`=1,plo.`RecollectedDate`=Now() WHERE Test_ID in ('" + TestID.Replace(",", "','") + "') ");
                if (j>0)
                {
                    int k = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labobservation_opd_recollect_log SELECT plo.*  FROM patient_labobservation_opd plo  WHERE Test_Id IN ('" + TestID.Replace(",", "','") + "') ");
                    int l = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd  WHERE Test_ID IN ('" + TestID.Replace(",", "','") + "')");

                }
                else
                {

                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                     
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Unable To recollect sample." });

                }
               



            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Selected test is Approved, Please Unapporved It." });
            }

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Save Successfully." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Unable to recollect sample." });

        }

    }

}