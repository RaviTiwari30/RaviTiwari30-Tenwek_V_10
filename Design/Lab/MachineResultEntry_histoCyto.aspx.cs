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

public partial class Design_Lab_MachineResultEntry_histoCyto : System.Web.UI.Page
{

    public string ApprovalId = "";
    public string Year = DateTime.Now.Year.ToString();
    public string Month = DateTime.Now.ToString("MMM");

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
            }

            ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Pending");

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }

            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            // bindInvestigation();
            BindMachine();
        }
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
            ddlMachine.DataSource = StockReports.GetDataTable("SELECT MachineID FROM `machost_pathcare`.`mac_machinemaster` ORDER BY MachineID");
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
        string histoid = string.Empty;
        int len = Resources.Resource.HistoCytoSubcategoryID.Split(',').Length;
        for (int i = 0; i < len; i++)
        {
            if (histoid == string.Empty)
                histoid = "'" + Resources.Resource.HistoCytoSubcategoryID.Split(',')[i] + "'";
            else
                histoid += ",'" + Resources.Resource.HistoCytoSubcategoryID.Split(',')[i] + "'";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append(" WHERE ot.Description IN (" + histoid + ") ");
        sb.Append(" order by ot.Name");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "ObservationType_ID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("ALL", ""));
    }

    private void BindTestDon()
    {
        string str = "SELECT * FROM macmaster WHERE IsActive=1";
        DataTable dt = StockReports.GetDataTable(str);
        ddlTestDon.DataSource = dt;
        ddlTestDon.DataTextField = "Name";
        ddlTestDon.DataValueField = "ID";
        ddlTestDon.DataBind();
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetTestMaster()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"         SELECT IF(inv.TestCode='',typename,CONCAT(inv.TestCode,' ~ ',typename)) testname,inv.Investigation_ID testid FROM f_itemmaster im 
         INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` 
         INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID  
         INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID 
         INNER JOIN investigation_master inv ON inv.Investigation_id=im.Type_id   
         INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID 
         INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID 
         AND im.IsActive=1 AND inv.ReportType=7 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  AND cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "'  ORDER BY testname ");
        //DataTable dt = StockReports.GetDataTable("       SELECT IF(inv.TestCode='',typename,CONCAT(inv.TestCode,' ~ ',typename)) testname,inv.`Investigation_ID` testid FROM   f_itemmaster im          INNER JOIN investigation_master inv ON inv.Investigation_id=im.Type_id   AND         im.isactive=1 AND inv.ReportType=7 ORDER BY testname");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PatientSearch(string SearchType, string SearchValue, string FromDate, string ToDate, string SmpleColl, string Department, string MachineID, string ZSM, string TimeFrm, string TimeTo, string isUrgent, string InvestigationId, string PanelId, string SampleStatusText, string chremarks, string chcomments)
    {

        try
        {
            string checkSession = HttpContext.Current.Session["CentreID"].ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();

        sbQuery.Append("  SELECT pli.HistoCytoStatus, '' ReferLab,pli.Approved,DATE_FORMAT(pli.incubationdatetime, '%d-%b-%Y') incubationdate,DATE_FORMAT(pli.incubationdatetime, '%h:%i:%s') incubationtime,pli.slidenumber, ");
        sbQuery.Append("  DATE_FORMAT(pli.sampledate, '%d-%b-%y %H:%i') DATE,pli.`LedgerTransactionNo`,'' SampleLocation,''CombinationSample,pm.`PName`,CONCAT(pli.CurrentAge,'/',pm.`Gender`) Age_Gender,pm.`Gender`,lt.PatientID,");
        sbQuery.Append(" CONCAT(dm.title,' ',dm.Name) AS Doctor,cm.CentreName AS Centre,pli.`BarcodeNo`, fpm.Company_Name AS panelname,im.investigation_ID,  im.Name AS Test,pli.Test_ID Test_ID");
        sbQuery.Append(" ,IF(pm.DOB = '0001-01-01', (CASE WHEN pli.CurrentAge LIKE '%DAY%' THEN ((TRIM(REPLACE(pli.CurrentAge,'DAY(S)',''))+0)) WHEN pli.CurrentAge ");
        sbQuery.Append(" LIKE '%MONTH%' THEN ((TRIM(REPLACE(pli.CurrentAge,'MONTH(S)',''))+0)*30) ");
        sbQuery.Append(" ELSE ((TRIM(REPLACE(pli.CurrentAge,'YRS',''))+0)*365) END),DATEDIFF(NOW(),pm.DOB)) AGE_in_Days ");
        sbQuery.Append(",  IFNULL((SELECT Remarks FROM patient_labinvestigation_opd_remarks plor WHERE plor.Test_ID =pli.Test_ID And IsActive=1 ORDER BY ID DESC LIMIT 1 ),'')RemarkStatus");
        sbQuery.Append(", (SELECT LedgertransactionNo FROM patient_labinvestigation_attachment WHERE LedgertransactionNo=pli.LedgerTransactionNo LIMIT 1)DocumentStatus");
        sbQuery.Append(" , IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'1','0') TATDelay,IF(pli.isurgent = 1,'Y','N')Urgent");
        sbQuery.Append(" ,CASE ");
        sbQuery.Append(" WHEN pli.isPrint=1 AND pli.isSampleCollected<>'R' AND pli.Approved=1 THEN 'Printed' ");
        sbQuery.Append(" WHEN pli.Approved=1 THEN 'Approved' ");
        sbQuery.Append(" WHEN pli.isHold=1 THEN 'Hold' ");
        sbQuery.Append("   WHEN pli.Result_Flag=1 and pli.isForward=0  THEN 'Tested' ");
        sbQuery.Append("   WHEN pli.isForward=1 THEN  'Forwarded' ");
        sbQuery.Append("   WHEN (select count(*) from mac_Data where reading<>'' and Test_ID=pli.Test_ID)>0 and pli.Result_Flag=0 THEN 'MacData' ");
        sbQuery.Append("  WHEN pli.isSampleCollected='N' THEN  'Not-Collected' ");
        sbQuery.Append("   WHEN pli.isSampleCollected='S' THEN 'Collected' ");
        sbQuery.Append("  WHEN pli.isSampleCollected='Y'  THEN 'Received' ");//and HistoCytoStatus='SlideComplete'
        sbQuery.Append("  WHEN  IFNULL(pli.HistoCytoStatus,'')<>'SlideComplete' THEN 'Collected' ");
        sbQuery.Append("  WHEN  pli.isSampleCollected='R' THEN 'Rejected' ");
        sbQuery.Append("  ELSE 'NA'  ");
        sbQuery.Append("  END `Status` ");
        sbQuery.Append(" ,'' Comments ");
        sbQuery.Append(" FROM ");
        if (SearchType == "pli.BarcodeNo" && SearchValue.Trim() != "")
        {
            sbQuery.Append(" (select * from `patient_labinvestigation_opd`  where BarcodeNo like '%" + SearchValue.Trim() + "%'  ) pli ");
        }
        else
        {
            sbQuery.Append(" `patient_labinvestigation_opd` pli ");
        }
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=pli.`LedgerTransactionNo` AND lt.`IsCancel`=0 "); //and (pli.HistoCytoPerformingDoctor='" + HttpContext.Current.Session["ID"].ToString() + "' or pli.ForwardToDoctor='"+HttpContext.Current.Session["ID"].ToString()+"')  ");
        sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.reporttype=7    ");
        sbQuery.Append(" INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sbQuery.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID ");
        sbQuery.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pli.DoctorID ");
        sbQuery.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=lt.PanelID ");
        sbQuery.Append(" INNER join investigation_observationtype iot on iot.Investigation_ID=pli.Investigation_ID  ");
        sbQuery.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = iot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        if (Department != "")
            sbQuery.Append("  and iot.ObservationType_ID='" + Department + "' ");

        sbQuery.Append("  and IF(ifnull(pli.ForwardToDoctor,0)=0,pli.sampleTransferCentreID ='" + HttpContext.Current.Session["CentreID"].ToString() + "',  pli.ForwardToCentre ='" + HttpContext.Current.Session["CentreID"].ToString() + "' )  ");
        if (InvestigationId != "" && InvestigationId != "null")
        {
            sbQuery.Append("  and pli.`Investigation_ID` in ('" + InvestigationId.Replace(",", "','") + "') ");
        }
        if (PanelId != "" && PanelId != "null")
        {
            sbQuery.Append("  and lt.PanelID='" + PanelId + "' ");
        }

        if (isUrgent == "1")
        {
            sbQuery.Append(" and pli.isUrgent=1  ");
        }
        if (MachineID.Trim() != "ALL")
            sbQuery.Append(" inner join mac_data md on md.Test_ID=pli.Test_ID and md.MachineName='" + MachineID + "' ");
        if (!SmpleColl.Contains("having"))
        {
            sbQuery.Append(" " + SmpleColl + " ");
        }
        if (SearchValue.Trim() != "")
        {

            sbQuery.Append(" and " + SearchType + " = '" + SearchValue.Trim() + "' ");
            if (SampleStatusText != "Pending")
            {
                sbQuery.Append("  AND pli.sampledate >='" + (Util.GetDateTime(ToDate).AddDays(-90).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND pli.sampledate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");
            }
        }
        if (SampleStatusText == "Pending")
        {

            sbQuery.Append("  and if(ifnull(pli.ForwardToDoctor,0)!=0, ForwardToDoctor='" + HttpContext.Current.Session["ID"].ToString() + "', pli.isForward=0) ");

        }
        if ((SearchType.Trim() == "lt.PatientID") || ((SearchValue.Trim() == "") && (SearchType.Trim() == "pli.BarcodeNo")))
        {
            if (SampleStatusText != "Pending")
            {
                sbQuery.Append("  AND pli.sampledate >='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
                sbQuery.Append(" AND pli.sampledate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");
            }
        }
        sbQuery.Append("  GROUP BY pli.test_id");

        if (SmpleColl.Contains("having"))
        {
            sbQuery.Append(" " + SmpleColl + " ");
        }
        sbQuery.Append(" order by pli.sampledate ");

        if (SearchValue.Trim() != "")
        {
            sbQuery.Append(" limit 1000");
        }

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
                // string strPartialupdt = "update patient_labinvestigation_opd set BarcodeNo='" + Barcode + "',macstatus=0 where  Test_ID in ('" + TestID.Replace(",", "','") + "') and  LedgerTransactionNo=" + LedgerTransactionNo;



                int j = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET BarcodeNo = @BarcodeNo, macStatus = @macStatus WHERE Test_ID IN @Test_ID AND LedgerTransactionNo=@LedgerTransactionNo",
                           new MySqlParameter("@BarcodeNo", Barcode), new MySqlParameter("@macStatus", 0),
                           new MySqlParameter("@Test_ID", TestID.Replace(",", "','")), new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo)
                           );



                //  int j = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strPartialupdt);
                if (j > 0)
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from mac_data where Test_ID IN @Test_ID AND LedgerTransactionNo=@LedgerTransactionNo",
                       new MySqlParameter("@Test_ID", TestID.Replace(",", "','")),
                       new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));

                    //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from mac_data where Test_ID in ('" + TestID.Replace(",", "','") + "') and  LedgerTransactionNo=" + LedgerTransactionNo);
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


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetPatientInvsetigationsNameOnly(string LabNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT cast( GROUP_CONCAT( IF(   pli.IsSampleCollected='Y'   ");

        sb.Append(" , CONCAT(\"<a onmouseout=hideme() onmouseover=getme('\",pli.Test_ID,\"')  href=\",'\" javascript:void(0); \" ' , concat(\"style=\'background-color:\",CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.IsFOReceive='1' THEN '#E9967A' WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' WHEN pli.Approved='1' AND pli.isHold='0' THEN '#90EE90' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0'AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' THEN '#FFC0CB' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' WHEN pli.Result_Flag='0' AND (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#FFFF00' WHEN pli.IsSampleCollected='N' OR pli.IsSampleCollected='S' THEN '#CC99FF' WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' WHEN pli.IsSampleCollected<>'Y' THEN '#CC99FF' ELSE '#FFFFFF' END,\";'\") ,\" onclick=\", '~' ,\"  GetParameters('\",sc.Abbreviation,\"','\",pli.Test_ID,\"','\", Im.ReportType, ");
        sb.Append(" \"','\",pli.Test_ID,\"','\",pli.Investigation_ID,\"','\", ");
        sb.Append(" (CASE  WHEN pli.LedgerTransactionNo=\"\" THEN \"Test Cancel\" WHEN pli.isHold=\"1\" AND pli.LedgerTransactionNo!=\"\" THEN \"Hold\" WHEN pli.Approved=\"1\" ");
        sb.Append(" AND pli.LedgerTransactionNo!=\"\" THEN \"Approved\" WHEN pli.Approved=\"0\" AND pli.Result_Flag=\"1\" AND pli.LedgerTransactionNo!=\"\" THEN \"Result Done\" ");
        sb.Append("  WHEN pli.IsSampleCollected=\"Y\" AND pli.Result_Flag=\"0\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample LabReceived\" WHEN pli.IsSampleCollected=\"S\" ");
        sb.Append("  AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Collected\" WHEN pli.IsSampleCollected=\"N\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Not Collected\" ");
        sb.Append(" WHEN pli.IsSampleCollected=\"R\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Rejected\" END ),  \"','\",io.observationType_ID,\"','\",im.isculture,\"'); ~ >\", ");
        sb.Append("  Im.Name ,\"</a>\"),IF(   pli.IsSampleCollected='S',  CONCAT('<a style=\"background-color:bisque;\"  href=\"javascript:void(0);\">', Im.Name,'</a>' ),CONCAT('<a style=\"background-color:#CC99FF;\"  href=\"javascript:void(0);\">', Im.Name,'</a>' )))  SEPARATOR \" \") as char) AS IName ");
        sb.Append(" FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo='" + LabNo + "'   )pli  ");
        sb.Append(" INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id ");
        sb.Append(" INNER JOIN f_itemmaster fim ON fim.type_id=pli.Investigation_ID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=fim.SubCategoryID  ");
        sb.Append(" INNER JOIN investigation_observationtype io ON io.investigation_id = im.Investigation_Id ");
        sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id; ");

        string rtrn = StockReports.ExecuteScalar(sb.ToString());

        rtrn = rtrn.Replace('~', '"');



        //  string rtrn = StockReports.ExecuteScalar(" SELECT GROUP_CONCAT( Im.Name  SEPARATOR '  ,  ') AS IName FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo='" + LabNo + "' OR `LedgerTransactionNoOLD`='" + LabNo + "'   )pli  " + 
        // "   INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id  ");

        return rtrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string LabObservationSearch(string LabNo, string TestID, float AgeInDays, string RangeType, string Gender, string MachineID, string macId, string reportnumber)
    {
        StringBuilder sbObs = new StringBuilder();

        sbObs.Append(" SELECT ");
        sbObs.Append(" '" + LabNo + "' LabNo,'" + AgeInDays + "' AgeInDays,'' incubationdate,'' incubationtime,'' mystatus,pli.BarcodeNo,pli.ItemName TestName ,om.Print_Sequence Dept_Sequence,om.name Dept, ");
        sbObs.Append(" im.PrintSeparate INV_PrintSeparate,lom.PrintSeparate OBS_PrintSeparate,'' Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,'' `Flag`, (CASE WHEN loi.Child_Flag='1' THEN 'HEAD'  WHEN IFNULL(plo.Value,'')!='' THEN plo.Value  WHEN IFNULL(plo.Value ,'')='' AND IFNULL(mac.MacReading,'')!='' THEN IF(IsNumeric(mac.MacReading)=1,mac.MacReading,mac.MacReading)    WHEN IFNULL(plo.Value,'')='' AND IFNULL(mac.MacReading,'')='' AND IFNULL(IFNULL(lr.DefaultReading,lr2.DefaultReading), '') != '' AND pli.Result_Flag<>1  THEN IFNULL(lr.DefaultReading,lr2.DefaultReading)    ELSE '' END ) `Value`,  mac.MacReading,mac.MachineID,mac.machinename,mac.MachineID1,mac.MachineID2,mac.MachineID3, IFNULL(CONCAT(DATE(mac.dtentry),' ',TIME(mac.dtentry)),'0001-01-01 00:00:00')  dtMacEntry, lom.DefaultValue,plo.ID,LOM.LabObservation_ID,mac.Reading1,mac.Reading2,mac.Reading3, (CONCAT(loi.prefix,'',LOM.Name)) AS `LabObservationName`, '' `MinValue`,   ''  `MaxValue`,'' DisplayReading,   '' DefaultReading, ");
        sbObs.Append(" '1' rangetype,   ");
        sbObs.Append(" '' ReadingFormat,        ");
        sbObs.Append(" IFNULL(lr.AbnormalValue,lr2.AbnormalValue)AbnormalValue,       IFNULL(loi.IsBold,0) IsBold,       IFNULL(loi.IsUnderLine,0)IsUnderLine,        ");
        sbObs.Append(" loi.PrintOrder Priorty,Im.ReportType,lom.ParentID,loi.Child_Flag, ifnull(loi.Formula,'')Formula,   ");
        sbObs.Append(" '' Method,   ");
        sbObs.Append(" 0 PrintMethod,   im.Print_Sequence,lom.IsMultiChild,     ");
        sbObs.Append(" loi.IsCritical,IFNULL(lr.MinCritical,lr2.MinCritical)MinCritical,IFNULL(lr.MaxCritical,lr2.MaxCritical )MaxCritical  ,ifnull(h.Help,'') Help,   ");
        sbObs.Append(" im.IsMic,lom.IsComment,lom.ResultRequired   , pli.isPartial_Result,lom.DLCCheck,loi.isamr isAmr,loi.isreflex Isreflex,IFNULL(lr.AMRMin,lr2.AMRMin) AmrMin,IFNULL(lr.AMRMax,lr2.AMRMax) AmrMax,IFNULL(lr.reflexmin,lr2.reflexmin) ReflexMin,IFNULL(lr.reflexmax,lr2.reflexmax) ReflexMax ,  ");
        sbObs.Append(" (select IFNULL(GROUP_CONCAT(LabObservationIDto SEPARATOR '#'),'') from investigation_maphold where LabObservationIDfrom =loi.LabObservation_ID) HoldObsId");

        sbObs.Append(@" ,IFNUll(( SELECT GROUP_CONCAT( CONCAT('<a target=\'_blank\' href=\'../../Uploaded Document/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  SEPARATOR '<br/>') FileUrl FROM patient_labinvestigation_attachment  WHERE Test_ID=pli.Test_ID GROUP BY test_id ),'')IsAttached ");

        sbObs.Append(" ,CASE ");
        sbObs.Append(" WHEN pli.isPrint=1 THEN '#00FFFF' /*'Printed'*/ ");
        sbObs.Append(" WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/ ");
        sbObs.Append("   WHEN pli.Result_Flag=1  and pli.isForward=0  THEN '#FFC0CB' /*'Result_Done'*/ ");
        sbObs.Append("   WHEN pli.isForward=1  THEN '#3399FF' /*'Forwarded'*/ ");

        sbObs.Append("   WHEN (select count(*) from mac_Data where reading<>'' and Test_Id=pli.Test_Id )>0 and pli.Result_Flag=0 THEN '#E2680A' /*'MacData'*/ ");

        sbObs.Append("  WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/ ");
        sbObs.Append("   WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/ ");
        sbObs.Append("  WHEN pli.isSampleCollected='Y' and pli.CultureStatus='Incubation'  THEN '#FFFFFF' /*'Received'*/ ");
        sbObs.Append("  WHEN  IFNULL(pli.CultureStatus,'')<>'Incubation' THEN '#CC99FF' /*'Collected'*/ ");
        sbObs.Append("  WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/ ");

        sbObs.Append("  ELSE '#FFFFFF'  ");
        sbObs.Append("  END `Status` ");
        sbObs.Append(" ,'0' micro, om.Name DeptName,im.Name as InvName ");
        sbObs.Append(" FROM (select * from patient_labinvestigation_opd where LedgerTransactionNo='" + LabNo + "' ");  // AND IsSampleCollected='Y'
        if (TestID != "")
        {
            sbObs.Append(" AND Test_ID in ('" + TestID.Replace(",", "','") + "') ");
        }
        sbObs.Append(" ) pli ");
        sbObs.Append(" INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id  AND im.ReportType=1 and im.isCulture=1  ");
        sbObs.Append(" INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id  ");
        sbObs.Append(" INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID  ");
        sbObs.Append(" INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id    ");
        sbObs.Append(" INNER JOIN  labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID and (lom.Gender= left('" + Gender + "',1) or lom.Gender='B') ");

        sbObs.Append(" LEFT JOIN patient_labobservation_opd_mic plo ON pli.Test_ID=plo.TestID AND plo.LabObservation_ID=LOM.LabObservation_ID and plo.reporttype='" + reportnumber + "' ");

        sbObs.Append(" LEFT OUTER JOIN   ");
        sbObs.Append(" ( SELECT LabNo,LabObservation_ID,Reading MacReading,Reading1,Reading2,Reading3,if('" + macId + "'<>'','" + macId + "',MachineID)MachineID,machinename,MachineID1,MachineID2,MachineID3,dtEntry,Test_ID FROM  mac_data WHERE LedgerTransactionNo='" + LabNo + "' and Reading<>''   ");
        sbObs.Append("      GROUP BY Test_ID,LabObservation_ID ) mac ON mac.Test_ID=pli.Test_ID  AND mac.LabObservation_ID= lom.LabObservation_ID   AND mac.LabNo = pli.`BarcodeNo`  ");

        sbObs.Append(" LEFT OUTER JOIN labobservation_range lr ON lr.Gender=LEFT('" + Gender + "',1) ");
        sbObs.Append(" AND lr.FromAge<=if(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr.ToAge>=if(" + AgeInDays + "=0,4381," + AgeInDays + ")   ");
        sbObs.Append(" AND lr.LabObservation_ID=lom.LabObservation_ID AND lr.macID = mac.MachineID and lr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  and lr.rangetype='" + RangeType + "' ");

        sbObs.Append(" LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT('" + Gender + "',1) ");
        sbObs.Append(" AND lr2.FromAge<=if(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr2.ToAge>=if(" + AgeInDays + "=0,4381," + AgeInDays + ")  ");
        //sbObs.Append(" AND lr2.LabObservation_ID=lom.LabObservation_ID AND   IFNULL(lr2.macID,'1') = if('" + macId + "'<>'','" + macId + "','1') and lr2.CentreID=if('" + macId + "'<>'','" + HttpContext.Current.Session["CentreID"].ToString() + "','1')  and lr2.rangetype='" + RangeType + "' ");
        sbObs.Append(" AND lr2.LabObservation_ID=lom.LabObservation_ID AND   IFNULL(lr2.macID,'1') = if('" + macId + "'<>'','" + macId + "','1') and lr2.CentreID=1  and lr2.rangetype='" + RangeType + "' ");

        sbObs.Append(" LEFT OUTER JOIN ");
        sbObs.Append(" (SELECT GROUP_CONCAT(concat(lhm.Help,'#',if(ifnull(lhm.ShortKey,'')='',lhm.Help,lhm.ShortKey) ) ORDER BY IF(IFNULL(lhm.ShortKey,'')='',lhm.id,lhm.ShortKey) SEPARATOR '|' )Help,loh.labObservation_ID  ");
        sbObs.Append(" FROM LabObservation_Help loh  ");
        sbObs.Append(" INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId  ");
        sbObs.Append(" GROUP BY loh.LabObservation_ID ) h ON h.LabObservation_ID = lom.LabObservation_ID ");



        sbObs.Append(" UNION ALL  ");


        sbObs.Append(" SELECT  ");
        sbObs.Append(" '" + LabNo + "' LabNo,'" + AgeInDays + "' AgeInDays,'' incubationdate,'' incubationtime,'' mystatus,pli.BarcodeNo,pli.ItemName TestName,om.Print_Sequence Dept_Sequence,om.name Dept,  ");
        sbObs.Append(" im.PrintSeparate INV_PrintSeparate,'0' OBS_PrintSeparate,'' Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,'' `Flag`,  ");
        sbObs.Append(" '' `Value`,  '' MacReading, '' MachineID,'' machinename,'' MachineID1,'' MachineID2,'' MachineID3, '0001-01-01 00:00:00'  dtMacEntry, '' DefaultValue,'' ID,pli.Test_ID LabObservation_ID,'' Reading1,'' Reading2,'' Reading3,  im.Name `LabObservationName` , ''`MinValue`,   ''  `MaxValue`,    '' DisplayReading,  '' DefaultReading,  ");
        sbObs.Append(" ''  rangetype,    ");
        sbObs.Append(" '' ReadingFormat,         ");
        sbObs.Append(" '' AbnormalValue,      0 IsBold,       0 IsUnderLine,         ");
        sbObs.Append(" 0 Priorty,Im.ReportType,0 ParentID,0 Child_Flag, '' Formula,    ");
        sbObs.Append(" '' `Method`,    ");
        sbObs.Append(" 0 PrintMethod,   im.Print_Sequence,0 IsMultiChild,      ");
        sbObs.Append(" 0 IsCritical,'' MinCritical,'' MaxCritical  ,'' HELP ,    ");
        sbObs.Append(" im.IsMic,'' IsComment,'0' ResultRequired   , pli.isPartial_Result,0 DLCCheck,0 isAmr,0 Isreflex,0 AmrMin,0 AmrMax,0 ReflexMin,0 ReflexMax,    ");
        sbObs.Append(" '' HoldObsId");

        sbObs.Append(@" ,IFNUll(( SELECT GROUP_CONCAT( CONCAT('<a target=\'_blank\' href=\'../../Uploaded Document/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  SEPARATOR '<br/>') FileUrl FROM patient_labinvestigation_attachment  WHERE Test_ID=pli.Test_ID GROUP BY test_id ),'')IsAttached ");

        sbObs.Append(" ,CASE  ");
        sbObs.Append(" WHEN pli.isPrint=1 THEN '#00FFFF' /*'Printed'*/  ");
        sbObs.Append(" WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/  ");
        sbObs.Append(" WHEN pli.Result_Flag=1  AND pli.isForward=0  THEN '#FFC0CB' /*'Result_Done'*/  ");
        sbObs.Append(" WHEN pli.isForward=1  THEN '#3399FF' /*'Forwarded'*/  ");

        sbObs.Append(" WHEN (SELECT COUNT(*) FROM mac_Data WHERE reading<>'' AND Test_Id=pli.Test_Id )>0 AND pli.Result_Flag=0 THEN '#E2680A' /*'MacData'*/  ");

        sbObs.Append(" WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/  ");
        sbObs.Append(" WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/  ");
        sbObs.Append(" WHEN pli.isSampleCollected='Y' THEN '#FFFFFF' /*'Received'*/  ");
        sbObs.Append(" WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/  ");

        sbObs.Append(" ELSE '#FFFFFF'   ");
        sbObs.Append(" END `Status`    ");

        sbObs.Append(" ,'0' micro,om.Name DeptName,im.Name as InvName ");
        sbObs.Append(" FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo='" + LabNo + "'    ");

        sbObs.Append(" AND Test_ID IN ('" + TestID.Replace(",", "','") + "')   ");

        sbObs.Append(" ) pli  ");
        sbObs.Append(" INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id  AND im.ReportType<>1  and im.isCulture=1 ");
        sbObs.Append(" INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id  ");
        sbObs.Append(" INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID  ");
        sbObs.Append(" ORDER BY Dept_Sequence,Dept, Print_Sequence,Priorty");





        DataTable dt = StockReports.GetDataTable(sbObs.ToString());

        System.Data.DataColumn newColumn = new System.Data.DataColumn("Inv", typeof(System.String));
        newColumn.DefaultValue = "0";
        dt.Columns.Add(newColumn);
        DataTable dtreportfile = new DataTable();
        if (dt.Rows.Count > 0)
        {
            dtreportfile = StockReports.GetDataTable(@"SELECT test_id, CONCAT('<a target=\'_blank\' href=\'../../Uploaded Report/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  FileUrl FROM patient_labinvestigation_attachment_report  WHERE Test_ID IN ('" + TestID.Replace(",", "','") + "')  ");
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

                    if (tempDept != dr["Dept"].ToString())
                    {
                        tempDept = dr["Dept"].ToString();
                        drNew = dtClone.NewRow();
                        drNew["LabObservationName"] = dr["Dept"].ToString();
                        string micro = Util.GetString(StockReports.ExecuteScalar("SELECT ifnull(GROUP_CONCAT( DISTINCT organismid),'0') FROM patient_labobservation_opd_mic WHERE testid='" + dr["Test_ID"].ToString() + "' and reporttype='" + reportnumber + "'"));

                        drNew["micro"] = micro;

                        string indatetime = Util.GetString(StockReports.ExecuteScalar("SELECT concat(DATE_FORMAT(pli.incubationdatetime, '%d-%b-%Y'),'^',DATE_FORMAT(pli.incubationdatetime, '%h:%i:%s')) incubationtime FROM patient_labinvestigation_opd pli WHERE test_id='" + dr["Test_ID"].ToString() + "' "));

                        string mystatus = StockReports.ExecuteScalar(@" SELECT 
 CASE WHEN IFNULL(plomic.`testid`,'0')='0' THEN 'Pending' WHEN IFNULL(plomic.Result_flag,'0')='1' && IFNULL(plomic.Approved,'0')='0'  THEN 'Tested' WHEN IFNULL(plomic.Approved,'0')='1' THEN 'Approved'
 WHEN plo.ishold=1 THEN 'Hold' END mystatus FROM `patient_labinvestigation_opd` plo  LEFT JOIN `patient_labobservation_opd_mic` plomic ON plo.`Test_ID`=plomic.`testid`  and plomic.reporttype='" + reportnumber + "' WHERE plo.`Test_ID`='" + dr["Test_ID"].ToString() + "' limit 1");
                        try
                        {
                            drNew["incubationdate"] = indatetime.Split('^')[0];
                            drNew["incubationtime"] = indatetime.Split('^')[1];
                            drNew["mystatus"] = mystatus;
                        }
                        catch
                        {
                        }
                        drNew["PrintMethod"] = 0;
                        drNew["Inv"] = 3;
                        drNew["Flag"] = "";
                        drNew["IsAttached"] = dr["IsAttached"].ToString();
                        drNew["LabNo"] = dr["LabNo"].ToString();
                        dtClone.Rows.Add(drNew);
                    }
                    drCopy = dr;
                    temp = dr["Test_ID"].ToString();
                    drNew = dtClone.NewRow();
                    drNew["LabObservationName"] = dr["InvName"].ToString();
                    drNew["PrintMethod"] = 0;
                    drNew["Inv"] = 1;
                    drNew["Flag"] = "";
                    drNew["IsAttached"] = dr["IsAttached"].ToString();
                    drNew["LabNo"] = dr["LabNo"].ToString();
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
                            drNew1["Value"] = dwreport["FileUrl"].ToString();
                            drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                            drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                            drNew1["LabNo"] = drCopy["LabNo"].ToString();

                            dtClone.Rows.Add(drNew1);
                        }


                    }

                }

                dtClone.ImportRow(dr);

            }

            for (int a = 1; a <= 2; a++)
            {
                drNew1 = dtClone.NewRow();
                if (a == 1)
                {
                    drNew1["LabObservationName"] = "MicroScopy";
                }
                else
                {
                    drNew1["LabObservationName"] = "MicroScopy Observation";
                }
                drNew1["PrintMethod"] = 0;
                drNew1["Inv"] = 2;
                drNew1["Flag"] = "";
                if (a == 1)
                {
                    drNew1["value"] = StockReports.ExecuteScalar("select MicroScopic from patient_labinvestigation_opd_micro_status where test_id='" + drCopy["test_id"].ToString() + "'");
                }
                else
                {
                    drNew1["value"] = StockReports.ExecuteScalar("select MicroScopicComment from patient_labinvestigation_opd_micro_status where test_id='" + drCopy["test_id"].ToString() + "'");
                }

                drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                drNew1["LabNo"] = drCopy["LabNo"].ToString();

                dtClone.Rows.Add(drNew1);
            }

            //drNew1 = dtClone.NewRow();
            //drNew1["LabObservationName"] = "Comments";
            //drNew1["PrintMethod"] = 0;
            //drNew1["Inv"] = 2;
            //drNew1["Flag"] = "";
            //drNew1["Value"] = StockReports.ExecuteScalar("select comments from patient_labinvestigation_opd_comments where Test_ID='" + drCopy["Test_ID"].ToString() + "'");
            //drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
            //drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
            //drNew1["LabNo"] = drCopy["LabNo"].ToString();

            //dtClone.Rows.Add(drNew1);


            //dtClone.Rows.Add(drNew1);
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

            string str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it " +
        " INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Investigation_ID`= it.`Investigation_ID`  " +
        " WHERE pli.`Test_ID`=@LabObservation_ID ";




            DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, str,
               new MySqlParameter("@LabObservation_ID", LabObservation_ID)).Tables[0];


            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, "SELECT Comments_ID,Comments_Head FROM labobservation_comments WHERE `LabObservation_ID`=@LabObservation_ID",
              new MySqlParameter("@LabObservation_ID", LabObservation_ID)).Tables[0];

            //  string str = "SELECT Comments_ID,Comments_Head FROM labobservation_comments WHERE LabObservation_ID='" + LabObservation_ID + "' ";
            //  DataTable dt = StockReports.GetDataTable(str);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetComments_labobservation(string CmntID, string type)
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
        return temp;
    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Getpatient_labobservation_opd_text(string TestId)
    {

        string str = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, "SELECT `LabInves_Description` FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
            new MySql.Data.MySqlClient.MySqlParameter("@Test_ID", TestId)));

        return str;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveLabObservationOpdData(string reportnumber, List<Patient_lab_ObservationOPD_MIC> antibioticdata, List<ResultEntryProperty> data, string ResultStatus, string ApprovedBy, string ApprovalName)
    {

        if (data.Count == 0)
            return "";

        ResultEntryProperty pOpd = new ResultEntryProperty();
        int noOfRowsUpdated = data.Count;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string deleteTestID = "";
        string myplotestid = "";

        try
        {

            foreach (ResultEntryProperty pdeatil in data)
            {



                string ID = pdeatil.ID;
                string PLId = pdeatil.PLIID;
                string value = pdeatil.Value;

                if (deleteTestID != pdeatil.Test_ID && Util.GetString(pdeatil.Test_ID) != "")
                {

                    if (ResultStatus == "Forward")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=@ForwardDate,reportnumber=@reportnumber WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isForward", 1), new MySqlParameter("@ForwardBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@ForwardByName", HttpContext.Current.Session["LoginName"].ToString()),
                            new MySqlParameter("@ForwardDate", DateTime.Now),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isForward", 'Y'), new MySqlParameter("@reportnumber", reportnumber));



                    }
                    if (ResultStatus == "Approved")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=@ApprovedDate, ResultEnteredBy=if(Result_Flag=0,'" + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1,reportnumber=@reportnumber WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", ApprovedBy), new MySqlParameter("@ApprovedName", ApprovalName),
                            new MySqlParameter("@ApprovedDoneBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@ApprovedDate", DateTime.Now),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'), new MySqlParameter("@reportnumber", reportnumber));
                        myplotestid = pdeatil.Test_ID;

                    }
                    if (ResultStatus == "Not Approved")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, isForward = @isForward, isPrint = @isPrint,reportnumber=@reportnumber WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Approved", "0"), new MySqlParameter("@isForward", "0"), new MySqlParameter("@isPrint", "0"),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'), new MySqlParameter("@reportnumber", reportnumber));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  patient_labobservation_opd_mic set Approved='0' WHERE `TestID`=@Test_ID and reporttype=@reportnumber",
                         new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@reportnumber", reportnumber));



                    }
                    if (ResultStatus == "Un Forward")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isForward = @isForward WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isForward", "0"),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));


                    }
                    if (ResultStatus == "Preliminary Report")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Preliminary = @Preliminary,PreliminaryBy = @PreliminaryBy,PreliminaryName=@PreliminaryName,PreliminaryDateTime=@PreliminaryDateTime,ApprovedBy=@ApprovedBy,ApprovedName=@ApprovedName,reportnumber=@reportnumber WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Preliminary", "1"),
                            new MySqlParameter("@PreliminaryBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@PreliminaryName",HttpContext.Current.Session["LoginName"].ToString()), new MySqlParameter("@PreliminaryDateTime", DateTime.Now), new MySqlParameter("@ApprovedBy", ApprovedBy), new MySqlParameter("@ApprovedName", ApprovalName),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'), new MySqlParameter("@reportnumber", reportnumber));


                    }
                    if (ResultStatus == "Hold")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Approved = @Approved,ReportType = @ReportType,isHold=@isHold,HoldBy=@HoldBy,HoldByName=@HoldByName ,ResultEnteredBy=if(Result_Flag=0,'" + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1,reportnumber=@reportnumber WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                          new MySqlParameter("@Approved", "0"),
                          new MySqlParameter("@ReportType", pdeatil.ReportType), new MySqlParameter("@isHold", "1"), new MySqlParameter("@HoldBy", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@HoldByName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                          new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                          new MySqlParameter("@isSampleCollected", 'Y'), new MySqlParameter("@reportnumber", reportnumber));
                    }

                    if (ResultStatus == "UnHold")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,UnHoldBy = @UnHoldBy,UnHoldByName=@UnHoldByName,unholddate=now(),reportnumber=@reportnumber WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isHold", "0"),
                            new MySqlParameter("@UnHoldBy", HttpContext.Current.Session["ID"].ToString()),
                            new MySqlParameter("@UnHoldByName",HttpContext.Current.Session["LoginName"].ToString()),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'), new MySqlParameter("@reportnumber", reportnumber));


                    }
                    if (ResultStatus == "Save")
                    {



                        string str = "update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,'" + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1,Approved=0,reportnumber='" + reportnumber + "' ";
                        str += " where test_id=" + pdeatil.Test_ID + "  and isSampleCollected='Y' ";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                    }

                    if (ResultStatus == "Save" || ResultStatus == "Approved")
                    {
                        MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_mic WHERE `TestID`=@Test_ID and Reporttype=@reportnumber",
                         new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@reportnumber", reportnumber));
                    }



                    string audit = savestatus(tnx, pdeatil.BarcodeNo, pdeatil.LabNo, pdeatil.Test_ID, "Report (" + reportnumber + ")" + ResultStatus + " For :" + pdeatil.TestName);
                    if (audit == "fail")
                    {
                        Exception ex = new Exception("Status Not Saved.Please Contact To Itdose..!");
                        throw (ex);
                    }
                }
                deleteTestID = pdeatil.Test_ID;


                if (ResultStatus == "Save" || ResultStatus == "Approved")
                {

                    if (Util.GetString(pdeatil.LabObservation_ID) != "")
                    {
                        Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(tnx);
                        plo.testid = Util.GetString(pdeatil.Test_ID);
                        plo.labobservation_id = Util.GetString(pdeatil.LabObservation_ID);
                        plo.labobservation_name = Util.GetString(pdeatil.LabObservationName);
                        plo.value = Util.GetString(pdeatil.Value);
                        plo.unit = "";

                        plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                        plo.Result_flag = 1;

                        plo.Reporttype = reportnumber;

                        plo.IPAddress = All_LoadData.IpAddress();
                        plo.Insert();
                    }
                    if (pdeatil.LabObservationName == "MicroScopy" || pdeatil.LabObservationName == "MicroScopy Observation")
                    {
                        Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(tnx);
                        plo.testid = Util.GetString(pdeatil.Test_ID);
                        plo.labobservation_id = "0";
                        plo.labobservation_name = Util.GetString(pdeatil.LabObservationName);
                        plo.value = Util.GetString(pdeatil.Value);
                        plo.unit = "";

                        plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                        plo.Result_flag = 1;
                        plo.Reporttype = reportnumber;
                        plo.IPAddress = All_LoadData.IpAddress();
                        plo.Insert();

                        if (pdeatil.LabObservationName == "MicroScopy")
                        {
                            MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "update patient_labinvestigation_opd_micro_status set MicroScopic='" + Util.GetString(pdeatil.Value) + "' WHERE `Test_id`=@Test_ID",
                               new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                        }
                        else if (pdeatil.LabObservationName == "MicroScopy Observation")
                        {
                            MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "update patient_labinvestigation_opd_micro_status set MicroScopicComment='" + Util.GetString(pdeatil.Value) + "' WHERE `Test_id`=@Test_ID", new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                        }

                    }

                }




            }
            if (ResultStatus == "Save" || ResultStatus == "Approved")
            {
                foreach (Patient_lab_ObservationOPD_MIC myplo in antibioticdata)
                {
                    Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(tnx);
                    plo.testid = myplo.testid;
                    plo.OrganismID = myplo.OrganismID;
                    plo.OrganismName = myplo.OrganismName;
                    plo.Antibioticid = myplo.Antibioticid;
                    plo.AntibioticName = myplo.AntibioticName;
                    plo.AntibioticGroupid = myplo.AntibioticGroupid;
                    plo.AntibioticGroupname = myplo.AntibioticGroupname;
                    plo.AntibioticInterpreatation = myplo.AntibioticInterpreatation;
                    plo.MIC = myplo.MIC;
                    plo.BreakPoint = myplo.BreakPoint;
                    plo.MIC_BP = myplo.MIC_BP;

                    plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);

                    plo.Result_flag = 1;
                    plo.Reporttype = reportnumber;
                    plo.IPAddress = All_LoadData.IpAddress();
                    plo.Insert();


                }
            }
            if (ResultStatus == "Approved")
            {
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "update patient_labobservation_opd_mic set Approved=1,ApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ApprovedByname='" +HttpContext.Current.Session["LoginName"].ToString() + "',ApprovedDateTime=now() WHERE `Testid`=@Test_ID and reporttype=@reporttype", new MySqlParameter("@Test_ID", myplotestid), new MySqlParameter("@reporttype", reportnumber));
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
        sbQuery.Append(" SELECT plo.testid Test_ID,plo.IsSampleCollected, im.name,plo.`SampleTypeID`,plo.`SampleTypeName`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`, ");
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
            string checkSession = HttpContext.Current.Session["CentreID"].ToString();
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
                           new MySqlParameter("@SampleSegratedBy",HttpContext.Current.Session["LoginName"].ToString()),
                           new MySqlParameter("@SegratedDate", DateTime.Now),
                           new MySqlParameter("@UpdateID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@UpdateName", HttpContext.Current.Session["ID"].ToString()),
                           new MySqlParameter("@updateDate", DateTime.Now), new MySqlParameter("@IPAddress", All_LoadData.IpAddress()),
                           new MySqlParameter("@Test_ID", Item[i].Split('_')[0].ToString()));


                        //sb.Append(" Update patient_labinvestigation_opd Set IsSampleCollected = 'Y' ,");
                        //sb.Append(" SampleTypeID='" + Item[i].Split('_')[1].ToString() + "', ");
                        //sb.Append(" SampleTypeName='" + Item[i].Split('_')[2].ToString() + "', ");
                        //sb.Append(" SampleSegratedBy_ID='" + HttpContext.Current.Session["ID"].ToString() + "', ");
                        //sb.Append(" SampleSegratedBy = '" +HttpContext.Current.Session["LoginName"].ToString() + "',SegratedDate=NOW(), ");
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
                           new MySqlParameter("@SampleSegratedBy",HttpContext.Current.Session["LoginName"].ToString()),
                           new MySqlParameter("@SegratedDate", DateTime.Now),
                           new MySqlParameter("@UpdateID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@UpdateName", HttpContext.Current.Session["ID"].ToString()),
                           new MySqlParameter("@updateDate", DateTime.Now), new MySqlParameter("@IPAddress", All_LoadData.IpAddress()),
                           new MySqlParameter("@Test_ID", Item[i].Split('_')[0].ToString()));


                        //sb.Append(" Update patient_labinvestigation_opd Set IsSampleCollected = 'S' ,");
                        //sb.Append(" SampleTypeID='" + Item[i].Split('_')[1].ToString() + "', ");
                        //sb.Append(" SampleTypeName='" + Item[i].Split('_')[2].ToString() + "', ");
                        //sb.Append(" SampleSegratedBy_ID='" + HttpContext.Current.Session["ID"].ToString() + "', ");
                        //sb.Append(" SampleSegratedBy = '" +HttpContext.Current.Session["LoginName"].ToString() + "',SegratedDate=NOW(), ");
                        //sb.Append(" UpdateID='" + Item[i].Split('_')[1].ToString() + "', ");
                        //sb.Append(" UpdateName='" + HttpContext.Current.Session["ID"].ToString() + "', ");
                        //sb.Append(" updatedate=NOW(),IPAddress='" + All_LoadData.IpAddress() + "'  where Test_ID='" + Item[i].Split('_')[0].ToString() + "' ");

                    }

                }
                tnx.Commit();
                // StockReports.ExecuteScalar(sb.ToString());
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
        sb.Append(" AND plo.testid IN ('" + TestID + "')    ");
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


                // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_labinvestigation_opd_remarks where Test_ID='" + arr[i] + "'");


                StringBuilder sbIns = new StringBuilder();

                sbIns.Append("INSERT INTO patient_labinvestigation_opd_remarks(UserID,UserName,Test_ID,Remarks,LedgerTransactionNo) ");
                sbIns.Append(" VALUES(@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbIns.ToString(),
                    new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
                    new MySqlParameter("@UserName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                    new MySqlParameter("@Test_ID", arr[i]),
                    new MySqlParameter("@Remarks", Remarks),
                    new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));



                //  sbIns.Append(" INSERT INTO patient_labinvestigation_opd_remarks(UserID,UserName,Test_ID,Remarks,LedgerTransactionNo) ");
                //  sbIns.Append(" values('" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + arr[i] + "','" + Remarks + "','" + LedgerTransactionNo + "' ) ");
                //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbIns.ToString());
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
                      new MySqlParameter("@Status", status), new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()), new MySqlParameter("@UserName",HttpContext.Current.Session["LoginName"].ToString()),
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
    public static string BindobsAntibiotic(string obid, string obname, string testid, string Barcodeno, string reportnumber)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT distinct '" + obid + "' obid,'" + obname + "' obname, mm.name,mm.id, ");
        sb.Append("(   CASE WHEN  (IF(plo.AntibioticInterpreatation<>'',plo.AntibioticInterpreatation,IFNULL(mov.`Interpretation`,''))='I') THEN   'Intermediate' ");
        sb.Append(" WHEN  (IF(plo.AntibioticInterpreatation<>'',plo.AntibioticInterpreatation,IFNULL(mov.`Interpretation`,''))='S') THEN   'Sensitive'  WHEN  (IF(plo.AntibioticInterpreatation<>'',plo.AntibioticInterpreatation,IFNULL(mov.`Interpretation`,''))='R') THEN   'Resistant' ");
        sb.Append(" ELSE   IFNULL(plo.AntibioticInterpreatation,'')   END)  VALUE, ");
        sb.Append(" '0' Approved,'' ReadingFormat ,'0' Result_Flag,ifnull(plo.breakpoint,mmm.`breakpoint`) breakpoint,");
        sb.Append(" IF(plo.mic<>'',plo.mic,IFNULL(mov.reading,''))   mic,ifnull(plo.mic_bp,'') mic_bp,  ");
        sb.Append(" ifnull((SELECT ID FROM micro_master WHERE id=(SELECT masterid FROM micro_master_mapping WHERE mapmasterid=mm.id AND typeid=3 limit 1) limit 1),'0') AntibioticGroupID, ");
        sb.Append(" ifnull((SELECT NAME FROM micro_master WHERE id=(SELECT masterid FROM micro_master_mapping WHERE mapmasterid=mm.id AND typeid=3 limit 1) limit 1) ,'')AntibioticGroupName ");
        sb.Append(" FROM  micro_master_mapping mmm INNER JOIN micro_master mm ON mmm.mapmasterid=mm.id   ");
        sb.Append(" AND masterid = '" + obid + "'");


        sb.Append(" LEFT  JOIN  " + AllGlobalFunction.MachineDB + ".`mac_observation_vitek` mov ON  mm.`Anti_Code`=mov.`Machine_ParamID` AND mov.`Type`='2' and mov.labno='" + Barcodeno + "' AND mm.`Anti_Code` IS NOT NULL ");
        sb.Append(" LEFT JOIN patient_labobservation_opd_mic plo ON plo.testid='" + testid + "' AND plo.`Antibioticid`= mm.id  AND plo.`OrganismID` ='" + obid + "' and reporttype='" + reportnumber + "' order by mm.name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


}