using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.Services;

public partial class Design_OPD_ViewLabReportsWard : System.Web.UI.Page
{
    private DataTable dtSearch;
    string PID = "";
    string TID = "";
    string LabType = "";

    string LoginType = "";
    string EncounterNo = "0";
    string IsView = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        //TID = Request.QueryString["TransactionID"].ToString();



        if (Request.QueryString["TransactionID"] == null)
            TID = Request.QueryString["TID"].ToString();
        else
            TID = Request.QueryString["TransactionID"].ToString();


        //PID = Request.QueryString["PatientID"].ToString();


        //ViewState["PatientID"] = string.Empty;

        if (Request.QueryString["PatientID"] == null)
            PID = Request.QueryString["PID"].ToString();
        else
            PID = Request.QueryString["PatientID"].ToString();


        LoginType = Convert.ToString(Session["LoginType"]).ToUpper();


        if (!string.IsNullOrEmpty(Request.QueryString["EncounterNo"]))
        {
            EncounterNo = Request.QueryString["EncounterNo"].ToString();
        }

        if (!string.IsNullOrEmpty(Request.QueryString["IsView"]))
        {
            IsView = Request.QueryString["IsView"].ToString();
        }



        if (!IsPostBack)
        {
            ViewState["SELECTED"] = "1";
            SearchPatient("", EncounterNo);

            string[] cookies = Request.Cookies.AllKeys;
            string CacheID = Request.UserHostAddress;

            foreach (string cookie in cookies)
                if (cookie != "ASP.NET_SessionId")
                    if (cookie == CacheID)
                        Response.Cookies[cookie].Expires = DateTime.Now.AddDays(-1);
            DateTime AdmDate;
            if (Request.QueryString["EMGNo"] == null)
                AdmDate = Util.GetDateTime(StockReports.ExecuteScalar("Select DateOfAdmit from patient_medical_history where TransactionID='" + TID + "'"));//Ipd_case_history
            else
                AdmDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT DATE(EnteredOn) FROM emergency_patient_details WHERE TransactionID='" + TID + "'"));
            ucFromDate.Text = AdmDate.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            fc1.StartDate = AdmDate;
            fc2.EndDate = DateTime.Now;

        }
        lblMsg.Text = "";
        ucToDate.Attributes.Add("readOnly", "true");
        ucFromDate.Attributes.Add("readOnly", "true");
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {

        string TestID = "";
        string OutSourceLabNo = "";
        int LabreportType = 11;
        string TestCode = "";
        string NewTestIDs="";
        foreach (GridViewRow gr in GridView1.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelect")).Checked)
            {

                if (TestID == "")
                {
                    TestID = ((Label)gr.FindControl("lblTest_ID")).Text;
                    NewTestIDs = "'"+((Label)gr.FindControl("lblTest_ID")).Text + "'";
                }
                else
                {
                    TestID = TestID + "," + ((Label)gr.FindControl("lblTest_ID")).Text;
                    NewTestIDs = NewTestIDs + "," + "'" + ((Label)gr.FindControl("lblTest_ID")).Text+ "'";
                }

                
               

                if (((Label)gr.FindControl("lblisoutsource")).Text == "1")
                {
                    OutSourceLabNo = ((Label)gr.FindControl("lblLTNo")).Text;
                }
            }
        }
        if (NewTestIDs != "")
        {
            TestCode = StockReports.ExecuteScalar("SELECT GROUP_CONCAT(im.ItemCode,'')  FROM patient_labinvestigation_opd plo INNER JOIN f_ledgertnxdetail ltd ON ltd.id= plo.LedgertnxID INNER JOIN f_itemmaster im ON im.ItemID= ltd.ItemID WHERE plo.Test_ID in (" + NewTestIDs + ")");

            if (OutSourceLabNo == "")
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('../../Design/Lab/printLabReport_pdf.aspx?TestID=" + TestID + "&LabType=" + LabType + "&LabreportType=" + LabreportType + "');", true);
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('https://report.apollodiagnostics.in/apollo/Cronjob/LabReportView.aspx?LabNo=" + OutSourceLabNo + "&TestCode=" + TestCode + "&InterfaceClient=RMAT');", true);
            }
        }
        else
        {
            lblMsg.Text = "Please select atleast one report.";
        }
    }
    private void SetCheckBoxStatus()
    {
        foreach (GridViewRow row in GridView1.Rows)
        {
            int reportType = Util.GetInt(((Label)row.FindControl("lblReportType")).Text);
            string App_Status = Util.GetString(((Label)row.FindControl("lblStatus")).Text);

            if (reportType != 5)
            {

                //((ImageButton)row.FindControl("imbPrint")).Visible = false;
                if (App_Status == "A")
                {
                    ((CheckBox)row.FindControl("chkSelect")).Checked = true;

                    if (chkSelectAll.Checked == false)
                    {
                        if (ViewState["SELECTED"].ToString() == "0")
                        {
                            ((CheckBox)row.FindControl("chkSelect")).Checked = false;
                        }
                    }
                }
                if (App_Status == "SN" || App_Status == "RN" )
                {
                    ((CheckBox)row.FindControl("chkSelect")).Enabled = false;
                    ((CheckBox)row.FindControl("chkSelect")).Checked = false;
                }
            }
            else
            {


                if (App_Status == "SN" || App_Status == "RN" || App_Status == "SC")
                {
                    ((CheckBox)row.FindControl("chkSelect")).Enabled = false;
                }
                if (App_Status == "A")
                {
                    ((CheckBox)row.FindControl("chkSelect")).Checked = true;
                    ((CheckBox)row.FindControl("chkSelect")).Enabled = true;
                }


                if (chkSelectAll.Checked == false)
                {
                    ((CheckBox)row.FindControl("chkSelect")).Checked = false;
                }
            }
        }
    }

    private void SearchPatient(string Status, string EncounterNo="0")
    {

        string TransactionID = TID;

        dtSearch = getLabToPrintNew("", LabType, TransactionID, "", Status, "", "", rblLabDepartmentType.SelectedValue,EncounterNo);

        //if (dtSearch != null)
        //{
        //    DataView dv = dtSearch.DefaultView;
        //    dv.Sort = "Date DESC";
        //    dtSearch = dv.ToTable();
        //}

        GridView1.DataSource = dtSearch;
        GridView1.DataBind();
        SetCheckBoxStatus();
        ViewState.Add("dtSearch", dtSearch);

        if (GridView1.Rows.Count == 0)
        {
            lblMsg.Text = "Record Not Found";
            Panel1.Visible = false;
            btnPrint.Visible = false;
        }
        else
        {
            Panel1.Visible = true;
            btnPrint.Visible = true;
        }
    }



    #region GetDataTable
    private DataTable GetDataTable(string strQuery)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        DataTable dt = new DataTable();
        dt = MySqlHelper.ExecuteDataset(conn, CommandType.Text, strQuery).Tables[0];
        if (conn.State == ConnectionState.Open)
            conn.Close();
        if (conn != null)
        {
            conn.Dispose();
            conn = null;
        }
        return dt;

    }
    #endregion
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "PackUrl")
        {
            string TestID = Util.GetString(e.CommandArgument);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('" + Resources.Resource.PacksURL + "" + TestID + "');", true);
        }
        else
        {
            //DataSet ds = new DataSet();
            string TestID = "'" + Util.GetString(e.CommandArgument) + "'";
            //dtSearch = ViewState["dtSearch"] as DataTable;
            //dtSearch.TableName = "InvestigationToPrint";
            //ds = LabOPD.getDataSetForReport(TestID, PID, dtSearch, LabType, "");
            //Session["ds"] = ds;
            //Session["EndOfReport"] = "1";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('../Lab/printLabReport.aspx?TestID=" + TestID.Replace("'", "") + "&LabType=" + LabType + "')", true);
        }
    }

    private DataTable getLabToPrintNew(string LedgerTransactionNo, string LabType, string TransactionID, string ReportType, string Status, string FromDate, string ToDate, string labDepartmentType, string EncounterNo = "0")
    {
        DataTable dt = new DataTable();
        if (Util.GetInt(EncounterNo) == 0)
        {
            string str = "";

            str += "SELECT  (SELECT pla.`FileUrl` URL FROM patient_labinvestigation_attachment_report pla WHERE pla.Test_ID=plo.Test_ID ORDER BY id DESC LIMIT 1) URL,if(ifnull((SELECT pla.`FileUrl` URL FROM patient_labinvestigation_attachment_report pla WHERE pla.Test_ID=plo.Test_ID ORDER BY id DESC LIMIT 1),'')!='',1,0)CanViewFile, plo.isoutsource,plo.BarcodeNo,plo.LedgerTransactionNo,TIME_FORMAT(TIME,'%h:%i:%p') AS TIME,DATE_FORMAT(plo.DATE,'%d-%b-%y') AS DATE,SampleDate,";
            str += "plo.Investigation_ID AS InvestigationID,plo.TransactionID,plo.Test_ID,plo.ID,plo.IsView,if(plo.IsView=1, CONCAT('Acknowledge By ',plo.ViewByName,' on ',DATE_FORMAT(plo.ViewDateTime,'%d-%b-%Y %r')),'') Ackstring, ";
            str += "ifnull((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=plo.ID  order by PLO_ID desc limit 1),'')LabInves_Description,";

        str += " if(plo.Type=1,'OPD','IPD') Type,";
        // SN = SampleNotDone
        // SC = Sample Collected but Department Not Receive
        // RN = SampleDoneButResultNotDone
        // NA = ResultDoneButNotApproved
        // A  = Approved

            str += " (Case When plo.IsSampleCollected='N' then 'SN' ";
            str += " WHEN plo.IsSampleCollected='S' THEN 'SC' ";
            str += " When plo.IsSampleCollected='Y' and plo.Result_Flag=0 then 'RN' ";
            str += " When plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=0 then 'NA' ";
            str += " When plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=1 then 'A' end  ";
            str += " )Status,";
            str += "IF(plo.Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(plo.Approved=1,'true','false')Print,";
            str += "IM.Investigation_ID,im.Name,im.ReportType,im.FileLimitationName,";
            str += "OM.Name Department,om.Print_Sequence ";
            str += "FROM patient_labinvestigation_opd plo ";
            str += " INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgertnxID AND ltd.IsVerified<>2 ";
            str += " INNER JOIN investigation_observationtype IO ON IM.Investigation_Id = IO.Investigation_ID ";
            str += " INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id ";
            str += " WHERE result_flag is not null ";

            if (labDepartmentType != "ALL")
            {
                str += "AND im.ReportType" + (labDepartmentType == "LAB" ? " <> 5 " : " = 5 ") + "";
            }

            str += "AND plo.PatientID ='" + PID + "'";
            if (Status != "")
            {
                if (Status == "SN")
                    str += " AND plo.IsSampleCollected='N'";
                if (Status == "SC")
                    str += " AND plo.IsSampleCollected='S'";
                else if (Status == "RN")
                    str += " AND plo.IsSampleCollected='Y' and plo.Result_Flag=0 ";
                else if (Status == "NA")
                    str += " AND plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=0 ";
                else if (Status == "A")
                    str += " AND plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=1";
            }
            if (FromDate != "" && ToDate != "")
            {
                str += " AND plo.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ";
            }
            str += " Order By plo.Date DESC,plo.BarcodeNo";
            dt = new DataTable("InvestigationToPrint");
            dt = StockReports.GetDataTable(str);


        }
        else
        {

            string str = "";

            str += "SELECT  (SELECT pla.`FileUrl` URL FROM patient_labinvestigation_attachment_report pla WHERE pla.Test_ID=plo.Test_ID ORDER BY id DESC LIMIT 1) URL,if(ifnull((SELECT pla.`FileUrl` URL FROM patient_labinvestigation_attachment_report pla WHERE pla.Test_ID=plo.Test_ID ORDER BY id DESC LIMIT 1),'')!='',1,0)CanViewFile,  plo.isoutsource,plo.BarcodeNo,plo.LedgerTransactionNo,TIME_FORMAT(plo.TIME,'%h:%i:%p') AS TIME,DATE_FORMAT(plo.DATE,'%d-%b-%y') AS DATE,SampleDate,";
            str += "plo.Investigation_ID AS InvestigationID,plo.TransactionID,plo.Test_ID,plo.ID,plo.IsView,if(plo.IsView=1, CONCAT('Acknowledge By ',plo.ViewByName,' on ',DATE_FORMAT(plo.ViewDateTime,'%d-%b-%Y %r')),'') Ackstring, ";
            str += "ifnull((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=plo.ID  order by PLO_ID desc limit 1),'')LabInves_Description,";

            str += " if(plo.Type=1,'OPD','IPD') Type,";
            // SN = SampleNotDone
            // SC = Sample Collected but Department Not Receive
            // RN = SampleDoneButResultNotDone
            // NA = ResultDoneButNotApproved
            // A  = Approved

            str += " (Case When plo.IsSampleCollected='N' then 'SN' ";
            str += " WHEN plo.IsSampleCollected='S' THEN 'SC' ";
            str += " When plo.IsSampleCollected='Y' and plo.Result_Flag=0 then 'RN' ";
            str += " When plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=0 then 'NA' ";
            str += " When plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=1 then 'A' end  ";
            str += " )Status,";
            str += "IF(plo.Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(plo.Approved=1,'true','false')Print,";
            str += "IM.Investigation_ID,im.Name,im.ReportType,im.FileLimitationName,";
            str += "OM.Name Department,om.Print_Sequence ";
            str += "FROM patient_labinvestigation_opd plo ";
            str += " INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgertnxID AND ltd.IsVerified<>2 ";
            str += " INNER JOIN investigation_observationtype IO ON IM.Investigation_Id = IO.Investigation_ID ";
            str += " INNER JOIN  f_ledgertransaction lt ON lt.TransactionID=plo.TransactionID and lt.EncounterNo="+Util.GetInt(EncounterNo)+" ";
            str += " INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id ";
            str += " WHERE result_flag is not null ";

            if (labDepartmentType != "ALL")
            {
                str += "AND im.ReportType" + (labDepartmentType == "LAB" ? " <> 5 " : " = 5 ") + "";
            }

            str += "AND plo.PatientID ='" + PID + "'";
            if (Status != "")
            {
                if (Status == "SN")
                    str += " AND plo.IsSampleCollected='N'";
                if (Status == "SC")
                    str += " AND plo.IsSampleCollected='S'";
                else if (Status == "RN")
                    str += " AND plo.IsSampleCollected='Y' and plo.Result_Flag=0 ";
                else if (Status == "NA")
                    str += " AND plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=0 ";
                else if (Status == "A")
                    str += " AND plo.Result_Flag=1 and IFNULL(plo.Approved,'0')=1";
            }
            if (FromDate != "" && ToDate != "")
            {
                str += " AND plo.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ";
            }
            str += " Order By plo.Date DESC,plo.BarcodeNo";
            dt = new DataTable("InvestigationToPrint");
            dt = StockReports.GetDataTable(str);

        }

        return dt;

    }


    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // SN = SampleNotDone ---Yellow
        // RN = SampleDoneButResultNotDone  ---- White
        // NA = ResultDoneButNotApproved  ---- Coral
        // A  = Approved  ---- Green
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Resources.Resource.Packsbutton == "1")
            {
                GridView1.Columns[6].Visible = true;
                if (((Label)e.Row.FindControl("lblReportType")).Text.ToUpper() == "5" && ((((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "NA" || (((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "A"))))
                {
                    ((ImageButton)e.Row.FindControl("imbPacksimage")).Visible = true;
                }
                else
                    ((ImageButton)e.Row.FindControl("imbPacksimage")).Visible = false;
            }
            else
            {
                GridView1.Columns[6].Visible = false;
                ((ImageButton)e.Row.FindControl("imbPacksimage")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "SN")
            {
                e.Row.Attributes.Add("style", "background-color:lightyellow");
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "SC" && ((Label)e.Row.FindControl("lblisoutsource")).Text.ToUpper()=="1")
            {
                e.Row.Attributes.Add("style", "background-color:#00FFFF");
                 ((CheckBox)e.Row.FindControl("chkSelect")).Enabled = true;
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "RN")
            {
                e.Row.Attributes.Add("style", "background-color:#CC99FF");
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "NA")
            {
                e.Row.Attributes.Add("style", "background-color:Coral");
                e.Row.FindControl("lblApprove").Visible = true;
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text.ToUpper() == "A")
            {
                e.Row.Attributes.Add("style", "background-color:lightgreen");
                e.Row.FindControl("lblApprove").Visible = true;
                ((CheckBox)e.Row.FindControl("chkSelect")).Enabled = true;
            }
        }

    }
    protected void btnSN_Click(object sender, EventArgs e)
    {
        SearchPatient("SN", EncounterNo);
    }
    protected void btnRN_Click(object sender, EventArgs e)
    {
        SearchPatient("RN", EncounterNo);
    }
    protected void btnNA_Click(object sender, EventArgs e)
    {
        SearchPatient("NA", EncounterNo);
    }
    protected void btnA_Click(object sender, EventArgs e)
    {
        SearchPatient("A", EncounterNo);
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectAll.Checked)
        {
            ViewState["SELECTED"] = "1";
            chkSelectAll.Text = "De-Select All";
        }
        else
        {
            ViewState["SELECTED"] = "0";
            chkSelectAll.Text = "Select All";
        }

        SetCheckBoxStatus();
    }

    protected void rbtType_SelectedIndexChanged(object sender, EventArgs e)
    {
        SearchPatient("", EncounterNo);
    }

    protected void btnSearchbyDate_Click(object sender, EventArgs e)
    {
        string TransactionID = TID;

        DataTable dtSearch1 = getLabToPrintNew("", LabType, TransactionID, "", "", ucFromDate.Text, ucToDate.Text, rblLabDepartmentType.SelectedValue);

        if (dtSearch1 != null)
        {
            DataView dv = dtSearch1.DefaultView;
            dv.Sort = "Date DESC,BarcodeNo ,Print_Sequence ASC";
            dtSearch1 = dv.ToTable();
        }

        GridView1.DataSource = dtSearch1;
        GridView1.DataBind();
        SetCheckBoxStatus();
        ViewState.Add("dtSearch", dtSearch1);

        if (GridView1.Rows.Count == 0)
        {
            lblMsg.Text = "Record Not Found";
            Panel1.Visible = false;
            btnPrint.Visible = false;
        }
        else
        {
            Panel1.Visible = true;
            btnPrint.Visible = true;
        }
    }
    protected void btnSC_Click(object sender, EventArgs e)
    {
        SearchPatient("SC", EncounterNo);
    }

    protected void rbllabType_SelectedIndexChanged(object sender, EventArgs e)
    {
        SearchPatient("", EncounterNo);
    }


     
     [WebMethod(EnableSession = true)]
    public static string ViewOrders(string Id)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;

        try
        {
            sqlCMD = "update patient_labinvestigation_opd set IsView=1,ViewBy=@Updateby,ViewByName=@ViewByName,ViewDateTime=now() where ID in ("+Id+") ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Updateby = HttpContext.Current.Session["ID"].ToString(),
                ViewByName = HttpContext.Current.Session["EmployeeName"].ToString()                
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Acknowledge Successfully." });
      

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
      
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
   


}
