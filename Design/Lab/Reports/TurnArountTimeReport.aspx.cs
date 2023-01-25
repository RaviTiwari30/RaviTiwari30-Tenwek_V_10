using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;


public partial class Design_Lab_TurnArountTimeReport : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["RoleID"] = Session["RoleID"].ToString();
            ViewState["LoginType"] = Session["LoginType"].ToString();

            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00AM";
            txtToTime.Text = "11:59PM";
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            BindDept();
            BindInvestigation();
            txtLabNo.Focus();
        }
        lblMsg.Text = "";
    }

    public void BindDept()
    {
        DataTable dt = All_LoadData.BindLabRadioDepartment(ViewState["RoleID"].ToString());
        if (dt.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "ObservationType_ID";
            ddlSubCategory.DataBind();
        }
        else
        {
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataBind();
        }
        ddlSubCategory.Items.Insert(0, "ALL");
    }

    public void BindInvestigation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select im.Name,im.Investigation_ID from ");
        sb.Append(" investigation_master im ");
        sb.Append(" inner join f_itemmaster it on it.Type_ID = im.Investigation_ID and it.IsActive=1 ");
        sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID = it.SubCategoryID  ");
        sb.Append(" inner join f_configrelation co on co.CategoryID = sc.CategoryID and co.ConfigID=3 ");
        sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
        if (ddlSubCategory.SelectedItem.Value != "" && ddlSubCategory.SelectedItem.Value != "ALL")
            sb.Append(" and io.ObservationType_ID ='" + ddlSubCategory.SelectedItem.Value + "' ");
        if (ViewState["LoginType"].ToString().ToUpper() == "RADIOLOGY")
            sb.Append(" and im.ReportType=5 ");
        else
            sb.Append(" and im.ReportType<>5 ");
        sb.Append(" order by im.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            chkInvestigation.DataSource = dt;
            chkInvestigation.DataTextField = "Name";
            chkInvestigation.DataValueField = "Investigation_ID";
            chkInvestigation.DataBind();

        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    #endregion

    #region Search

    private string getSearchQuery(string InvestigationID)
    {
        string center = StockReports.GetSelection(chkCentre);
        if(String.IsNullOrEmpty(center))
        {
            lblMsg.Text = "Please Select Center";
            return "";
        }
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty, strReportType;
        if (Util.GetString(ViewState["LoginType"]).ToUpper() == "RADIOLOGY")
            strReportType = " = 5";
        else
            strReportType = " <> 5";

        sb.Append("  SELECT DISTINCT pli.SerialNo,pli.BarcodeNo LabNo, PM.PatientID,PM.pname,pm.age,pm.gender, ");
        sb.Append("  CONCAT(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo, ");
        sb.Append("  im.Name  ,IF(PLI.Result_Flag = 0,'false','true')IsResult,PLI.Result_Flag,  DATE_FORMAT(pli.date,'%d-%b-%Y')InDate, ");
        sb.Append("  DATE_FORMAT(pli.Time,'%I:%i %p')InTime,  IFNULL(DATE_FORMAT(DATE(pli.SampleReceiveDate),'%d-%b-%Y'),'')SampleDate,IFNULL(TIME_FORMAT(TIME(pli.SampleReceiveDate),'%I:%i%p'),'')SampleTime,");
        sb.Append("  IF(SampleReceiveDate IS NOT  NULL,IF(SampleReceiveDate<>'0001-01-01',IF(HOUR(TIMEDIFF(pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time)))<2,TIME_FORMAT(TIMEDIFF(pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time)),'%H:%i:%s'),TIME_FORMAT(TIMEDIFF(pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time)),'%H:%i:%s')),'Pending'),'Pending')  WaitTAT  ");
        sb.Append("  , DATE_FORMAT(DATE(pli.ResultEnteredDate),'%d-%b-%Y')ResultDate,TIME_FORMAT(TIME(pli.ResultEnteredDate),'%I:%i %p')ResultTime, ");
        sb.Append("  IF(ResultenteredDate IS NOT  NULL,IF(ResultenteredDate<>'0001-01-01',IF(     HOUR(TIMEDIFF(pli.ResultenteredDate,pli.SampleReceiveDate))<2,TIME_FORMAT(TIMEDIFF(pli.ResultenteredDate,pli.SampleReceiveDate),'%H:%i:%s'),		TIME_FORMAT(TIMEDIFF(pli.ResultenteredDate,pli.SampleReceiveDate),'%H:%i:%s')		),'Pending'),'Pending')  ResultTAT , ");
        sb.Append("  DATE_FORMAT(DATE(pli.ApprovedDate),'%d-%b-%Y')ApprovalDate,TIME_FORMAT(TIME(pli.ApprovedDate),'%I:%i %p')ApprovalTime, ");
        sb.Append("  IF(ApprovedDate IS NOT  NULL,	IF(ApprovedDate<>'0001-01-01',		IF(     HOUR(TIMEDIFF(pli.ApprovedDate,pli.ResultenteredDate))<2,TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,pli.ResultenteredDate),'%H:%i:%s'),			TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,pli.ResultenteredDate),'%H:%i:%s')		),'Pending'	),'Pending')  ApproveTAT, ");

        sb.Append("  IF(PLI.Result_Flag = 1,IF(HOUR(TIMEDIFF(pli.ApprovedDate, ");
        sb.Append("  IF(im.Type='R',pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time))))<2,TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,IF(im.Type='R',pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time))),'%H:%i:%s'), ");
        sb.Append("  TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,IF(im.Type='R',pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time))),'%H:%i:%s')),'Pending')TAT,im.Type, ");

        sb.Append("  IFNULL(TIME_TO_SEC(IF(PLI.Result_Flag = 1,IF(HOUR(TIMEDIFF(pli.ApprovedDate, ");
        sb.Append("  IF(im.Type='R',pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time))))<2,TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,IF(im.Type='R',pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time))),'%H:%i:%s'), ");
        sb.Append("  TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,IF(im.Type='R',pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time))),'%H:%i:%s')),'Pending')),0)TatinSecond, ");
        sb.Append("  TIME_TO_SEC(IF(SampleReceiveDate IS NOT  NULL,IF(SampleReceiveDate<>'0001-01-01',IF(HOUR(TIMEDIFF(pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time)))<2,TIME_FORMAT(TIMEDIFF(pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time)),'%H:%i:%s'),TIME_FORMAT(TIMEDIFF(pli.SampleReceiveDate,CONCAT(pli.Date,' ',pli.Time)),'%H:%i:%s')),'Pending'),'Pending')) WaitTATinSecond,  ");
        sb.Append("  TIME_TO_SEC(IF(ResultenteredDate IS NOT  NULL,IF(ResultenteredDate<>'0001-01-01',IF(     HOUR(TIMEDIFF(pli.ResultenteredDate,pli.SampleReceiveDate))<2,TIME_FORMAT(TIMEDIFF(pli.ResultenteredDate,pli.SampleReceiveDate),'%H:%i:%s'),		TIME_FORMAT(TIMEDIFF(pli.ResultenteredDate,pli.SampleReceiveDate),'%H:%i:%s')		),'Pending'),'Pending'))ResultTATinSecond , ");
        sb.Append("  TIME_TO_SEC(IF(ApprovedDate IS NOT  NULL,	IF(ApprovedDate<>'0001-01-01',		IF(     HOUR(TIMEDIFF(pli.ApprovedDate,pli.ResultenteredDate))<2,TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,pli.ResultenteredDate),'%H:%i:%s'),			TIME_FORMAT(TIMEDIFF(pli.ApprovedDate,pli.ResultenteredDate),'%H:%i:%s')		),'Pending'	),'Pending'))  ApproveTATinSecond ");

        sb.Append("  FROM patient_labinvestigation_opd pli  ");
        sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo AND pli.IsSampleCollected='Y'   ");
        sb.Append("  INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID  INNER JOIN investigation_master im ON  ");
        sb.Append("  pli.Investigation_ID = im.Investigation_Id   WHERE   ");
        sb.Append("  lt.IsCancel=0 and IM.ReportType " + strReportType +" ");
        if (rdbLabType.SelectedValue != "0")
            sb.Append("AND pli.Type='"+ rdbLabType.SelectedValue +"' ");
        if (txtMRNo.Text != string.Empty)
                sb.Append("AND pm.PatientID='" + Util.GetFullPatientID(txtMRNo.Text.Trim()) + "' ");

        if (txtCRNo.Text != string.Empty)
                sb.Append("AND PLI.TransactionID='ISHHI" + txtCRNo.Text.Trim() + "' ");

        if (ddlStatus.SelectedValue != "0")
            sb.Append("AND ifnull(PLI.Approved,2)='" + ddlStatus.SelectedValue + "' ");

        if (txtPName.Text != string.Empty)
            sb.Append(" and PM.PName like '%" + txtPName.Text.Trim() + "%'");
        if (txtLabNo.Text != string.Empty)
            sb.Append(" AND pli.BarcodeNo='" + txtLabNo.Text.Trim() + "'");
        if (txtCRNo.Text == string.Empty && txtLabNo.Text == string.Empty)
        {
            if (FrmDate.Text != string.Empty)
                sb.Append(" and PLI.SampleDate >='" + (Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + ' ' + Util.GetDateTime(txtFromTime.Text).ToString("H:mm:ss")) + "'");

            if (ToDate.Text != string.Empty)
                sb.Append(" and PLI.SampleDate <='" + (Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + ' ' + Util.GetDateTime(txtToTime.Text).ToString("H:mm:ss")) + "'");
        }
        sb.Append(" and PLI.Investigation_ID IN (" + InvestigationID + ") ");
        sb.Append(" group by PLI.LedgerTransactionNo,PLI.Investigation_ID order by SerialNo+0,pli.LedgerTransactionNo ");
        return sb.ToString();
    }

    private void Search()
    {
        string InvestigationID = string.Empty;
        InvestigationID = StockReports.GetSelection(chkInvestigation);

        if (InvestigationID == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM046','" + lblMsg.ClientID + "');", true);
            return;
        }
        DataTable dt = StockReports.GetDataTable(getSearchQuery(InvestigationID));
        if (dt.Rows.Count > 0)
        {
            DataColumn DC = new DataColumn("DATE_Range");
            DC.DefaultValue = "From : " + FrmDate.Text + " To : " + ToDate.Text;
            dt.Columns.Add(DC);

            DataColumn DC3 = new DataColumn("USER");
            DC3.DefaultValue = Session["LoginName"].ToString();
            dt.Columns.Add(DC3);

            DataColumn DC4 = new DataColumn("HEADER");

            if (rdbLabType.SelectedValue == "1")
                DC4.DefaultValue = "Turn Around Time Report for " + ViewState["LoginType"].ToString() + " (OPD)";
            else if (rdbLabType.SelectedValue == "2")
                DC4.DefaultValue = "Turn Around Time Report for " + ViewState["LoginType"].ToString() + " (IPD)";
            else if (rdbLabType.SelectedValue == "3")
                DC4.DefaultValue = "Turn Around Time Report for " + ViewState["LoginType"].ToString() + " (Emergency)";
            else
                DC4.DefaultValue = "Turn Around Time Report for " + ViewState["LoginType"].ToString() + " ";
            dt.Columns.Add(DC4);

            int TotalResultDone = Util.GetInt(dt.Compute("count(Result_Flag)", ""));

            int TotalResult = dt.Rows.Count;

            int TotalTatInSec = Util.GetInt(dt.Compute("sum(TatinSecond)", ""));

            float AverageSec = Util.GetFloat(TotalTatInSec / TotalResultDone);
            TimeSpan t = TimeSpan.FromSeconds(AverageSec);

            string TimeAvg = string.Format("{0:D2} Days:{1:D2} Hours:{2:D2} Minutes:{3:D2} Seconds", t.Days, t.Hours, t.Minutes, t.Seconds);

            lblMsg.Text = dt.Rows.Count + " Record(s) Found ...";

            DataColumn DC5 = new DataColumn("TotalResultDone");
            DC5.DefaultValue = "Total Result : " + TotalResult + ",Total Done Result : " + TotalResultDone + ", Average Time : ";
            dt.Columns.Add(DC5);

            DataColumn DC6 = new DataColumn("TimeAvg");
            DC6.DefaultValue = TimeAvg;
            dt.Columns.Add(DC6);

            //Total Wait TAT 
            int TotalWaitTATinSec = Util.GetInt(dt.Compute("sum(WaitTATinSecond)", ""));
            float TimeAvgWait = Util.GetFloat(TotalWaitTATinSec/TotalResult);
            TimeSpan t1 = TimeSpan.FromSeconds(TimeAvgWait);
            string TotalWaitTAT = string.Format("Avg Wait TAT : {0:D2}:{1:D2}:{2:D2}:{3:D2}", t1.Days, t1.Hours, t1.Minutes, t1.Seconds);
            DataColumn DC7 = new DataColumn("TotalWaitTAT");
            DC7.DefaultValue = TotalWaitTAT;
            dt.Columns.Add(DC7);

            //Total Result TAT 
            int TotalResultTATinSec = Util.GetInt(dt.Compute("sum(ResultTATinSecond)", ""));
            float TimeAvgResult = Util.GetFloat(TotalResultTATinSec / TotalResultDone);
            TimeSpan t2 = TimeSpan.FromSeconds(TimeAvgResult);
            string TotalResultTAT = string.Format("Total Result TAT : {0:D2}:{1:D2}:{2:D2}:{3:D2}", t2.Days, t2.Hours, t2.Minutes, t2.Seconds);
            DataColumn DC8 = new DataColumn("TotalResultTAT");
            DC8.DefaultValue = TotalResultTAT;
            dt.Columns.Add(DC8);

            //Total Approve TAT 
            int TotalApproveTATinSec = Util.GetInt(dt.Compute("sum(ApproveTATinSecond)", ""));
            float TimeAvgApprove = Util.GetFloat(TotalApproveTATinSec / TotalResultDone);
            TimeSpan t3 = TimeSpan.FromSeconds(TimeAvgApprove);
            string TotalApproveTAT = string.Format("Total approve TAT : {0:D2}:{1:D2}:{2:D2}:{3:D2}", t3.Days, t3.Hours, t3.Minutes, t3.Seconds);
            DataColumn DC9 = new DataColumn("TotalApproveTAT");
            DC9.DefaultValue = TotalApproveTAT;
            dt.Columns.Add(DC9);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
        
            //ds.WriteXmlSchema(@"D:\LabTurnAroundTime.xml");
            if (rblReportType.SelectedValue.ToString() == "PDF")
            {
                Session["ReportName"] = "LabTurnAroundTime";
                Session["ds"] = ds;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/Commonreport.aspx');", true);
            }
            else
            {
                dt.Columns.Remove("Type");
                Session["dtExport2Excel"] = dt;
                if (rdbLabType.SelectedValue == "1")
                      Session["ReportName"] = "Turn Arround Time Report (OPD)";
                else if (rdbLabType.SelectedValue == "2")
                    Session["ReportName"] = "Turn Arround Time Report (IPD)";
                else if (rdbLabType.SelectedValue == "3")
                    Session["ReportName"] = "Turn Arround Time Report (Emergency)";
                else
                    Session["ReportName"] = "Turn Arround Time Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = " Record Not Found ...";
        }
    }
    #endregion  
    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        chkAll.Checked = false;
        BindInvestigation();
    }
}
