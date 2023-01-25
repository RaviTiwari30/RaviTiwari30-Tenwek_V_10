using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.Services;
using System.Linq;
public partial class Design_Lab_PatientLabSearch : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calEntryDate1.EndDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now;
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtMRNo.Focus();
            BindDepartment();
            All_LoadData.bindPanel(ddlPanel, "All");
            bindInvestigation();
            txtFromTime.Text = "00:00:00 AM";
            txtToTime.Text = "11:59:59 PM";
            switch (Session["LoginType"].ToString().ToUpper())
            {
                case "RADIOLOGY": // RadiologyTab
                case "CARDIAC":
                case "X-RAY": // RadiologyTab
                case "ULTRASOUND": // RadiologyTab
                case "CT SCAN": // RadiologyTab
                case "MRI": // RadiologyTab
                case "MAMMOGRAPHY": // RadiologyTab
                case "COLOUR DOPPLER": // RadiologyTab
                case "MRCP": // RadiologyTab
                case "OPD": // RadiologyTab
                    txtToTime.Visible = true;
                    txtFromTime.Visible = true;
                    btnWorkSheet.Visible = false;
                    break;
                default:
                    txtToTime.Visible = true;
                    txtFromTime.Visible = true;
                    btnWorkSheet.Visible = false;
                    break;
            }
        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
    }
    private void bindInvestigation()
    {
        DataTable dt = StockReports.GetDataTable("SELECT inv.Investigation_ID,inv.Name FROM investigation_master inv INNER JOIN f_itemmaster im ON inv.investigation_id=im.type_id INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` INNER JOIN f_subcategorymaster sm ON sm.subcategoryid=im.subcategoryid WHERE sm.categoryid='LSHHI3' AND im.isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + Session["CentreID"].ToString() + "' ORDER BY NAME ");
        if (dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "NAME";
            ddlInvestigation.DataValueField = "Investigation_ID";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, new ListItem("All", "0"));
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        DataTable dtInvest = Search();
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            // ViewState["dtInvest"] = dtInvest;

            grdLabSearch.DataSource = dtInvest;
            grdLabSearch.DataBind();


            lblMsg.Text = "Total Patient :" + dtInvest.AsEnumerable().Select(r => r.Field<string>("PatientID")).Distinct().Count() + " Total Test :" + dtInvest.Rows.Count;
            btnWorkSheet.Visible = false;
            //switch (Session["LoginType"].ToString())
            //{
            //    //  case "RADIOLOGY": // RadiologyTab
            //    case "CARDIAC":
            //    //case "X-RAY": // RadiologyTab
            //    // case "ULTRASOUND": // RadiologyTab
            //    //   case "CT SCAN": // RadiologyTab
            //    //  case "MRI": // RadiologyTab
            //    case "MAMMOGRAPHY": // RadiologyTab
            //    case "COLOUR DOPPLER": // RadiologyTab
            //    case "OPD": // RadiologyTab
            //    case "MRCP": // RadiologyTab
            //        grdLabSearch.Columns[13].Visible = false;
            //        grdLabSearch.Columns[14].Visible = false;
            //        grdLabSearch.Columns[11].Visible = true;
            //        btnWorkSheet.Visible = false;
            //        break;
            //    default:
            //        grdLabSearch.Columns[13].Visible = true;
            //        grdLabSearch.Columns[14].Visible = false;
            //        grdLabSearch.Columns[11].Visible = true;
            //        btnWorkSheet.Visible = false;
            //        break;
            //}
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
            btnWorkSheet.Visible = false;
        }
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dtInvest = Search();
        grdLabSearch.DataSource = null;
        grdLabSearch.DataBind();
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            lblMsg.Text = "";

            DataSet ds = new DataSet();
            ds.Tables.Add(dtInvest.Copy());
            Session["ds"] = ds;

            if (ddlStatus.SelectedItem.Text == "Not Approved")
            {
                Session["ReportName"] = "LabWorksheetNotApproved";

            }
            else
            {
                Session["ReportName"] = "LabWorksheet";
            }
            //ds.WriteXml(@"C://LabWorksheet.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
    }
    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, "All");
        }
    }
    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.TableSection = TableRowSection.TableHeader;

            if (Resources.Resource.Packsbutton == "1")
            {
                e.Row.Cells[3].Text = "Pacs&nbsp;No.";
                grdLabSearch.Columns[3].Visible = true;
            }
            else
            {
                grdLabSearch.Columns[3].Visible = false;
            }
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblReportType")).Text != "5")
            {
                e.Row.Cells[3].Text = "";
            }
            if (((Label)e.Row.FindControl("lblMacStatus")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Coral;
            }
            if (((Label)e.Row.FindControl("lblapprove")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                if (Session["LoginType"].ToString().ToLower() == "mri")
                {
                    e.Row.Cells[9].Enabled = false;
                    e.Row.Cells[15].Enabled = false;
                }
            }

            if (((Label)e.Row.FindControl("lblapprove")).Text != "1" && (((Label)e.Row.FindControl("lblResult")).Text != "true"))
            {
                if (((Label)e.Row.FindControl("lblUrgent")).Text.ToUpper() == "URGENT")
                {
                    ((Label)e.Row.FindControl("lblUrgent")).ForeColor = System.Drawing.Color.Red;
                    e.Row.BackColor = System.Drawing.Color.Pink;
                }
                else
                {
                    ((Label)e.Row.FindControl("lblUrgent")).ForeColor = System.Drawing.Color.Green;
                }
            }
            if (((Label)e.Row.FindControl("lblapprove")).Text != "1" && (((Label)e.Row.FindControl("lblResult")).Text != "true"))
            {
                if (((Label)e.Row.FindControl("lblIs_Outsource")).Text == "1")
                {
                    e.Row.BackColor = System.Drawing.Color.Aqua;
                }
            }
            if (((Label)e.Row.FindControl("lblPendingAmount")).Text != "1")
            {
                e.Row.BackColor = System.Drawing.Color.DarkGray;
            }
            if (((Label)e.Row.FindControl("lblIsDelay")).Text == "1")
            {
                ((Image)e.Row.FindControl("imgDelay")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lblIsPrint")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.DodgerBlue;
            }
            string LedgerTransactionNO = ((Label)e.Row.FindControl("lblLedgerTnx")).Text;
            string Type = ((Label)e.Row.FindControl("lblType")).Text;
            if (e.Row.RowIndex >= 1)
            {
                string PreviousLedgerTransactionNO = ((Label)grdLabSearch.Rows[e.Row.RowIndex - 1].FindControl("lblLedgerTnx")).Text;
                if (LedgerTransactionNO == PreviousLedgerTransactionNO)
                {
                    ((Label)e.Row.FindControl("lblAge")).Text = "";
                    ((Label)e.Row.FindControl("lblPatientID")).Text = "";
                    ((Label)e.Row.FindControl("lblPName")).Text = "";
                    ((Label)e.Row.FindControl("lblIPDNo")).Text = "";                    
                }
                string PreviousType = ((Label)grdLabSearch.Rows[e.Row.RowIndex - 1].FindControl("lblType")).Text;
                if (Type == PreviousType)
                {
                    ((Label)e.Row.FindControl("lblPatientType")).Text = "";

                }

            }
        }
    }
    protected void grdLabSearch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            string[] cookies = Request.Cookies.AllKeys;
            string CacheID = System.Web.HttpContext.Current.Request.UserHostAddress;

            foreach (string cookie in cookies)
            {
                if (cookie != "ASP.NET_SessionId")
                {
                    if (CacheID == cookie)
                    {
                        Response.Cookies[cookie].Expires = DateTime.Now.AddDays(-1);
                    }
                }
            }

            string LabType = string.Empty, PID = string.Empty, LedgerTransactionNo = string.Empty, TestId = string.Empty;
            if (rdbLabType.SelectedValue == "1")
                LabType = "OPD";
            else if (rdbLabType.SelectedValue == "2")
                LabType = "IPD";
            else if (rdbLabType.SelectedValue == "3")
                LabType = "Emergency";
            else
                LabType = "ALL";

            DataSet ds = new DataSet();
            DataTable dtSearch = new DataTable();
            TestId = "'" + Util.GetString(e.CommandArgument).Split('#')[1].ToString() + "'";
            PID = Util.GetString(e.CommandArgument).Split('#')[2].ToString();
            LedgerTransactionNo = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            dtSearch = LabOPD.getLabToPrint(LedgerTransactionNo, LabType, "");
            ds = LabOPD.getDataSetForReport(TestId, PID, dtSearch, LabType, "");

            Session["ds"] = ds;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Lab/ShowOPDLabReports.aspx');", true);
        }

    }
    #endregion

    #region Search
    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();
        string ListOf = "";
        if (ddlStatus.SelectedIndex > 0)
        {
            ListOf = "List of " + ddlStatus.SelectedItem.Text;
        }

        sb.Append("select '" + ListOf + " From " + FrmDate.Text + " To " + ToDate.Text + "' as ReportDate, if(pli.Type=1,'OPD','IPD')Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID,PM.PatientID PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.ID,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
        sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%Y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,'' TransactionID,''room, ");
        sb.Append("(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID =pli.DoctorID)DName, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus, ");
        sb.Append(" if(pli.Type=1,IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE),TRUE)PendingAmount, ");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay,fpm.Company_Name Panel,pli.isPrint,pli.BarcodeNo, ");
        sb.Append(" IF(IFNULL(pli.Remarks,'')<>'','display:block','display:none')Remarks ");
        sb.Append(" FROM patient_labinvestigation_opd pli  ");
        sb.Append(" INNER JOIN  f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
        sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
        sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  AND cr.RoleID='" + Session["RoleID"] + "'");
        sb.Append(" where lt.IsCancel=0 and (pli.IsSampleCollected='Y' OR pli.IsOutSource=1) AND pli.sampleTransferCentreID='" + Session["CentreID"].ToString() + "' ");
        if (txtMRNo.Text != string.Empty)
                sb.Append(" AND PM.PatientID='" + Util.GetFullPatientID(txtMRNo.Text.Trim()) + "' ");
        if (ddlInvestigation.SelectedIndex > 0)
            sb.Append(" AND im.Investigation_Id='" + ddlInvestigation.SelectedValue + "' ");
        if (ddlPanel.SelectedIndex > 0)
            sb.Append(" AND fpm.PanelID=" + ddlPanel.SelectedValue + " ");
        if (txtPName.Text != string.Empty)
            sb.Append(" AND PM.PName like '" + txtPName.Text.Trim() + "%'");
        if (ddlStatus.SelectedItem.Text == "Approved")
        {
            if (FrmDate.Text != string.Empty)
                sb.Append(" and pli.ApprovedDate>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' and PLI.Approved=1");
            if (ToDate.Text != string.Empty)
                sb.Append(" and PLI.ApprovedDate <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and PLI.Approved=1");
            sb.Append(" and pli.Result_Flag=1");
        }
        else if (ddlStatus.SelectedItem.Text == "Not Approved")
        {
            if (FrmDate.Text != string.Empty)
                sb.Append(" and PLI.ResultEnteredDate >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
            if (ToDate.Text != string.Empty)
                sb.Append(" and PLI.ResultEnteredDate <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
            sb.Append(" and pli.Result_Flag=1 and pli.Approved=0 ");
        }
        else if (ddlStatus.SelectedItem.Text == "Result Not Done")
        {
                if (FrmDate.Text != string.Empty)
                    sb.Append(" and pli.SampleReceiveDate>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
                if (ToDate.Text != string.Empty)
                    sb.Append(" and PLI.SampleReceiveDate<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
                sb.Append(" and pli.Result_Flag=0");
        }
        else
        {
            if (FrmDate.Text != string.Empty)
                sb.Append(" and PLI.SampleReceiveDate >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
            if (ToDate.Text != string.Empty)
                sb.Append(" and PLI.SampleReceiveDate <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
        }
        if (txtLabNo.Text != string.Empty)
        {
            sb.Append("AND pli.BarcodeNo='"+ txtLabNo.Text.Trim() +"'");
        }
        if (ddlDepartment.SelectedIndex > 0)
        {
            sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
        }
        if (ddlUrgent.SelectedValue != "2")
        {
            sb.Append(" and pli.IsUrgent='" + ddlUrgent.SelectedValue + "'");
        }
        if (txtCptcode.Text != string.Empty)
            sb.Append(" and imas.ItemCode='" + txtCptcode.Text.Trim() + "'");

        if (txtCRNo.Text != string.Empty)
        {
            if (rdbLabType.SelectedValue == "2")
            {
                sb.Append(" and  pli.TransactionID='ISHHI" + txtCRNo.Text.Trim() + "'");
            }
            else
                sb.Append(" and  pli.TransactionID like '%" + txtCRNo.Text.Trim() + "'");
        }
        if (rdbLabType.SelectedValue != "0")
            sb.Append(" AND pli.Type=" + rdbLabType.SelectedValue + " ");
        sb.Append(" group by pli.ID order by PLI.ID ");
        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        return dtInvest;
    }
    #endregion

    protected void btnWorkSheet_Click(object sender, EventArgs e)
    {
        if (rdbLabType.SelectedIndex == 2)
        {
            lblMsg.Text = "Please Select OPD or IPD";
            return;
        }
        ViewState["Worksheet"] = null;
        int count = 0;
        foreach (GridViewRow gr in grdLabSearch.Rows)
        {
            if ((((CheckBox)gr.FindControl("chkPrintWorksheet")) != null) && (((CheckBox)gr.FindControl("chkPrintWorksheet")).Checked))
            {
                string LabNo = ((ImageButton)gr.FindControl("imbPrint")).CommandArgument.ToString();
                getWorksheet(LabNo.Split('#')[0], LabNo.Split('#')[1], LabNo.Split('#')[3]);
                count = 1;
            }
        }
        DataTable dtWorksheet = (DataTable)ViewState["Worksheet"];
        if (dtWorksheet != null)
        {
            do
            {
                getChildTest(dtWorksheet);
            }
            while (dtWorksheet.Select("isParent='1'", "").Length != 0);
        }

        dtWorksheet = (DataTable)ViewState["Worksheet"];


        if (dtWorksheet != null)
        {

            string PatientId = "";
            int ColumnLoc = 1;
            for (int i = 0; i < dtWorksheet.Rows.Count; i++)
            {
                string tempPatientId = Util.GetString(dtWorksheet.Rows[i]["LabNo"]);


                if (tempPatientId != PatientId)
                {
                    PatientId = tempPatientId;
                    ColumnLoc = 1;
                    //i++;
                }
                else
                {
                    if (ColumnLoc == 1)
                    {
                        dtWorksheet.Rows[i - 1]["TestName3"] = Util.GetString(dtWorksheet.Rows[i]["TestName1"]);
                        dtWorksheet.Rows[i - 1]["TestName4"] = Util.GetString(dtWorksheet.Rows[i]["TestName2"]);
                        dtWorksheet.Rows[i].Delete();
                        dtWorksheet.AcceptChanges();
                        ColumnLoc = 2;
                    }
                    else
                    {
                        dtWorksheet.Rows[i - 1]["TestName3"] = Util.GetString(dtWorksheet.Rows[i]["TestName1"]);
                        dtWorksheet.Rows[i - 1]["TestName4"] = Util.GetString(dtWorksheet.Rows[i]["TestName2"]);
                        dtWorksheet.Rows[i].Delete();
                        dtWorksheet.AcceptChanges();
                        ColumnLoc = 1;
                    }
                }
            }


            DataSet ds = new DataSet();
            ds.Tables.Add(dtWorksheet.Copy());
            ds.Tables[0].TableName = "Worksheet";
            //ds.WriteXmlSchema(@"C:\LabWorkSheet2.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "LabWorksheet2";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            lblMsg.Text = "";
        }
        else
        {
            if (count == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM046','" + lblMsg.ClientID + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM054','" + lblMsg.ClientID + "');", true);
            }

        }

    }

    private void getChildTest(DataTable dtWorksheet)
    {

        for (int i = 0; i < dtWorksheet.Rows.Count; i++)
        {

            DataRow dr = dtWorksheet.Rows[i];
            if (dr["isParent"].ToString() == "1")
            {
                DataTable dtTemp = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT * FROM labobservation_master WHERE Parentid='" + dr["InvestigationId"].ToString() + "'");
                dtTemp = StockReports.GetDataTable(sb.ToString());


                foreach (DataRow drChild in dtTemp.Rows)
                {
                    DataRow drWork = dtWorksheet.NewRow();
                    drWork["PatientID"] = dr["PatientID"].ToString();
                    drWork["PatientName"] = dr["PatientName"].ToString();
                    drWork["Age"] = dr["Age"].ToString();
                    drWork["Gender"] = dr["Gender"].ToString();
                    drWork["LabNo"] = dr["LabNo"].ToString();
                    drWork["Department"] = ddlDepartment.SelectedItem.Text;
                    drWork["ReportType"] = "1";
                    drWork["TestName1"] = drChild["Name"].ToString() + "(" + dr["TestName1"].ToString() + ")";
                    drWork["TestName2"] = drChild["ReadingFormat"].ToString();
                    drWork["isParent"] = "0";
                    drWork["InvestigationId"] = drChild["LabObservation_ID"].ToString();
                    dtWorksheet.Rows.Add(drWork);


                }
                dtWorksheet.Rows[i].Delete();
                dtWorksheet.AcceptChanges();
            }



        }
        ViewState["Worksheet"] = dtWorksheet;

    }

    private void getWorksheet(string LabNo, string TestId, string ReportType)
    {
        DataTable dtWorksheet = vs_getWorksheet();


        DataTable dtTest = getTest(LabNo, TestId, ReportType);

        if (dtTest != null)
        {
            if (ReportType == "3" || ReportType == "2")
            {
                DataRow drTest = dtTest.Rows[0];
                DataRow drWork = dtWorksheet.NewRow();
                drWork["PatientID"] = drTest["PatientID"].ToString();
                drWork["PatientName"] = drTest["PatientName"].ToString();
                drWork["Age"] = drTest["Age"].ToString();
                drWork["Gender"] = drTest["Gender"].ToString();
                drWork["LabNo"] = drTest["LabNo"].ToString();
                drWork["Department"] = ddlDepartment.SelectedItem.Text;
                drWork["ReportType"] = "2";
                drWork["TestName1"] = drTest["IName"].ToString();
                drWork["TestName2"] = "";
                drWork["isParent"] = "0";
                drWork["InvestigationId"] = "";
                //drWork["SampleDate"] = drTest["SampleDate"].ToString();
                drWork["SampleDate"] = Util.GetDateTime(drTest["SampleDate"]).ToString("dd-MMM-yyyy hh:mm tt");
                dtWorksheet.Rows.Add(drWork);
                ViewState["Worksheet"] = dtWorksheet;
            }
            else if ((ReportType == "1" && (dtTest.Rows.Count > 0)))
            {

                for (int k = 0; k < dtTest.Rows.Count; k++)
                {
                    DataRow drTest = dtTest.Rows[k];
                    DataRow drWork = dtWorksheet.NewRow();
                    drWork["PatientID"] = drTest["PatientID"].ToString();
                    drWork["PatientName"] = drTest["PatientName"].ToString();
                    drWork["Age"] = drTest["Age"].ToString();
                    drWork["Gender"] = drTest["Gender"].ToString();
                    drWork["LabNo"] = drTest["LabNo"].ToString();
                    drWork["Department"] = ddlDepartment.SelectedItem.Text;
                    drWork["ReportType"] = "1";
                    drWork["TestName1"] = drTest["obName"].ToString();
                    drWork["TestName2"] = drTest["ReadingFormat"].ToString();
                    drWork["isParent"] = drTest["Child_Flag"].ToString();
                    drWork["InvestigationId"] = drTest["LabObservation_ID"].ToString();
                    //drWork["SampleDate"] = drTest["SampleDate"].ToString();
                    drWork["SampleDate"] = Util.GetDateTime(drTest["SampleDate"]).ToString("dd-MMM-yyyy hh:mm tt");
                    dtWorksheet.Rows.Add(drWork);
                    ViewState["Worksheet"] = dtWorksheet;
                }
            }

        }



    }

    private DataTable getTest(string LabNo, string TestId, string ReportType)
    {
        DataTable dtTest = new DataTable();
            if (ReportType == "1")
            {

                StringBuilder sb = new StringBuilder();
                sb.Append("    SELECT pli.LabInvestigationOPD_ID AS LabInvestigation_ID,im.Name,pli.Investigation_ID,pli.ID PLIID,pli.Test_ID, ");
                sb.Append("    pli.Result_Flag,plo.Value,plo.ID,CASE WHEN pli.Approved IS NOT NULL THEN 'True' ELSE 'False' END AS Approved,  ");
                sb.Append("    pli.Investigation_ID,LOM.Name AS obName,LOM.LabObservation_ID, CASE WHEN 'MALE' = 'CHILD'  ");
                sb.Append("    THEN lom.MinChild WHEN 'MALE' = 'MALE' THEN lom.Minimum WHEN 'MALE' = 'FEMALE'  ");
                sb.Append("    THEN lom.MinFemale ELSE 0 END Minimum , CASE WHEN 'MALE' = 'CHILD' THEN lom.MaxChild  ");
                sb.Append("    WHEN 'MALE' = 'MALE' THEN lom.Maximum WHEN 'MALE' = 'FEMALE' THEN lom.MaxFemale ELSE 0 END  ");
                sb.Append("    Maximum ,lom.ReadingFormat,loi.Priorty ,Im.ReportType,lom.ParentID,lom.Child_Flag,");
                sb.Append("    CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.LedgerTransactionNo AS LabNo,pm.PatientID,Date_Format(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate ");
                sb.Append("    FROM patient_labinvestigation_opd pli INNER JOIN investigation_master im  ");
                sb.Append("    ON pli.Investigation_ID=im.Investigation_Id  INNER JOIN labobservation_investigation loi  ");
                sb.Append("    ON im.Investigation_Id=loi.Investigation_Id  INNER JOIN  labobservation_master lom  ");
                sb.Append("    ON loi.labObservation_ID=lom.LabObservation_ID INNER JOIN patient_medical_history pmh ON pli.TransactionID=pmh.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID LEFT JOIN patient_labobservation_opd plo  ");
                sb.Append("    ON pli.Test_ID=plo.Test_ID AND plo.LabObservation_ID=LOM.LabObservation_ID  ");
                sb.Append("    WHERE pli.Test_id='" + TestId + "'  ");
                if (rdbLabType.SelectedIndex == 0)
                    sb.Append(" AND pli.Type=1 ");
                else if(rdbLabType.SelectedIndex == 1)
                    sb.Append(" AND pli.Type=2 ");
                sb.Append(" AND im.ReportType=1 ORDER BY loi.Priorty ");
                dtTest = StockReports.GetDataTable(sb.ToString());
            }
            else if (ReportType == "3" || ReportType == "2")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("     SELECT IF(pli.Approved=1,'false','true')Approved,ApprovedBy,pli.LabInvestigationOPD_ID AS LabInvestigation_ID,pli.ID,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,pli.Test_ID,pli.Result_Flag,  ");
                sb.Append("        pli.Investigation_ID,Im.Name AS IName,Im.ReportType,CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.LedgerTransactionNo AS LabNo,pm.PatientID,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate FROM patient_labinvestigation_opd pli   ");
                sb.Append("        INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id INNER JOIN patient_medical_history pmh ON pli.TransactionID=pmh.TransactionID   ");
                sb.Append("        INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID    ");
                sb.Append("        WHERE pli.Test_id='" + TestId + "' AND im.ReportType!=1  ");
                if (rdbLabType.SelectedIndex == 0)
                    sb.Append(" AND pli.Type=1 ");
                else if (rdbLabType.SelectedIndex == 1)
                    sb.Append(" AND pli.Type=2 ");
                dtTest = StockReports.GetDataTable(sb.ToString());
            }
        return dtTest;
    }
    private DataTable vs_getWorksheet()
    {
        DataTable dtWorksheet = (DataTable)ViewState["Worksheet"];
        if (dtWorksheet != null)
        {
            return dtWorksheet;
        }
        else
        {
            dtWorksheet = new DataTable();
            dtWorksheet.Columns.Add("PatientID");
            dtWorksheet.Columns.Add("PatientName");
            dtWorksheet.Columns.Add("Age");
            dtWorksheet.Columns.Add("Gender");
            dtWorksheet.Columns.Add("LabNo");
            dtWorksheet.Columns.Add("Department");
            dtWorksheet.Columns.Add("ReportType");
            dtWorksheet.Columns.Add("TestName1");
            dtWorksheet.Columns.Add("TestName2");
            dtWorksheet.Columns.Add("TestName3");
            dtWorksheet.Columns.Add("TestName4");
            dtWorksheet.Columns.Add("isParent");
            dtWorksheet.Columns.Add("InvestigationId");
            dtWorksheet.Columns.Add("SampleDate");
            dtWorksheet.AcceptChanges();
            return dtWorksheet;

        }
    }


    protected void rdbLabType_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        DataTable dtInvest = Search();
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            // ViewState["dtInvest"] = dtInvest;

            grdLabSearch.DataSource = dtInvest;
            grdLabSearch.DataBind();

            lblMsg.Text = "Total Patient :" + dtInvest.AsEnumerable().Select(r => r.Field<string>("PatientID")).Distinct().Count() + " Total Test :" + dtInvest.AsEnumerable().Select(r => r.Field<string>("Investigation_ID")).Distinct().Count();


            switch (Session["LoginType"].ToString())
            {
                case "RADIOLOGY": // RadiologyTab
                case "CARDIAC":
                case "X-RAY": // RadiologyTab
                case "ULTRASOUND": // RadiologyTab
                case "CT SCAN": // RadiologyTab
                case "MRI": // RadiologyTab
                case "MAMMOGRAPHY": // RadiologyTab
                case "COLOUR DOPPLER": // RadiologyTab
                case "MRCP": // RadiologyTab
                case "OPD": // RadiologyTab
                    grdLabSearch.Columns[11].Visible = true;
                    grdLabSearch.Columns[12].Visible = false;
                    btnWorkSheet.Visible = false;
                    break;
                default:
                    grdLabSearch.Columns[11].Visible = false;
                    grdLabSearch.Columns[12].Visible = true;
                    btnWorkSheet.Visible = false;
                    break;
            }

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
            btnWorkSheet.Visible = false;
        }
    }
    [WebMethod]
    public static string labRemarks(string LedgerTnx, string typeID, string type, string testID)
    {
        //  string a = "SELECT IFNULL(Remarks,'')Remarks FROM patient_test pt INNER JOIN f_itemmaster im ON pt.Test_ID=im.ItemID  WHERE pt.OPDLedgertansactionNO='" + LedgerTnx + "' AND im.type_ID='" + typeID + "'  AND pt.ConfigID IN(3,5) ";
        //if (type.ToUpper() == "OPD")
        //    return StockReports.ExecuteScalar("SELECT IFNULL(Remarks,'')Remarks FROM patient_test pt INNER JOIN f_itemmaster im ON pt.Test_ID=im.ItemID  WHERE pt.OPDLedgertansactionNO='" + LedgerTnx + "' AND im.type_ID='" + typeID + "'  AND pt.ConfigID IN(3,5)");
        //else
            return StockReports.ExecuteScalar("SELECT IFNULL(Remarks,'')Remarks FROM patient_labinvestigation_opd pli   WHERE Test_ID='" + testID + "' ");

    }


    [WebMethod(EnableSession = true)]
    public static string TrackTest(string testID, string patientType)
    {

        var sb = new StringBuilder("SELECT DISTINCT pli.SerialNo,REPLACE(REPLACE(lt.LedgerTransactionNo,'LOSHHI','1'),'LSHHI','2')LabNo, PM.PatientID MRNo,CONCAT(pm.Title,' ',PM.Pname)PatientName,pm.Age,pm.Gender,    ");
        sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.Test_ID,pli.LedgerTransactionNo,  ");
        sb.Append("im.Name  InvestigationName,  IF(PLI.IsDispatch=1,'Yes','No')Dispatch, ");
        sb.Append("(SELECT DispatchMode FROM `report_dispatchmaster` WHERE ID=ReportDispatchModeID)DispatchMode, ");
        sb.Append("DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y')InDate,  ");
        sb.Append("DATE_FORMAT(pli.SampleCollectionDate,'%I:%i %p')InTime,   DATE_FORMAT(pli.ApprovedDate,'%I:%i %p')ApprovedTime,  ");
        sb.Append("DATE_FORMAT(DATE(pli.ApprovedDate),'%d-%b-%Y')ApprovedDate,   ");
        sb.Append("DATE_FORMAT(DATE(pli.SampleReceiveDate),'%d-%b-%Y')SampleDate,  ");
        sb.Append("TIME_FORMAT(TIME(pli.SampleReceiveDate),'%I:%i %p')SampleTime,  ");
        sb.Append("DATE_FORMAT(DATE(pli.ResultEnteredDate),'%d-%b-%y')ResultDate,");
        sb.Append("TIME_FORMAT(TIME(pli.ResultEnteredDate),'%I:%i %p')ResultTime, ");
        sb.Append("DATE_FORMAT(DATE(pli.DispatchDate),'%d-%b-%y')DisPatchDate, ");
        sb.Append("TIME_FORMAT(TIME(pli.DispatchDate),'%I:%i %p')DisPatchTime, ");
        sb.Append("IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.DispatchDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'Delay','Not Delay'),'Not Defined')TAT  ");
        sb.Append("FROM patient_labinvestigation_opd pli    ");
        sb.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo AND pli.IsSampleCollected='Y' ");
        sb.Append("INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID  ");
        sb.Append("INNER JOIN investigation_master im ON    pli.Investigation_ID = im.Investigation_Id  ");
        sb.Append("WHERE  pli.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  AND lt.IsCancel=0 AND IM.ReportType  IN (1,3,5) AND pli.Test_ID='" + testID.Trim() + "' ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }


    [WebMethod(EnableSession = true)]
    public static string getLabPrescriptionSavePath(string documentName,string patientID)
    {
        var pathname = All_LoadData.createDocumentFolder("OPDDocument", patientID.Replace("/", "_"));
        return System.IO.Path.Combine(pathname + "\\" + documentName.Replace('/', '-') + ".jpeg");
    }


}
