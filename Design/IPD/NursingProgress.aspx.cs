using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_NursingProgress : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = "";
            if (Request.QueryString["TransactionID"] != null)
            {
                TID = Request.QueryString["TransactionID"].ToString();
                ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();                             
            }
            else
            {
                TID = Request.QueryString["TID"].ToString();
                ViewState["PatientID"] = Request.QueryString["PID"].ToString();                
                
                clcAppDate.EndDate = Util.GetDateTime(DateTime.Now);
                clcAppDate.StartDate = Util.GetDateTime(DateTime.Now); 
            }
            ViewState["TransactionID"] = TID;

            if (Request.QueryString["EMGNo"] != null)
                ViewState["IsEmergency"] = "1";
            else
                ViewState["IsEmergency"] = "0";  

            grdNursingbind();
            DateTime admitDate;
            if (Request.QueryString["EMGNo"] != null)
            {
                admitDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT DATE(EnteredOn) FROM emergency_patient_details WHERE TransactionID=" + Util.GetInt(ViewState["TransactionID"]) + " "));
                clcAppDate.StartDate = admitDate;
            }
            else
            {
                dt = AllLoadData_IPD.getAdmitDischargeData(ViewState["TransactionID"].ToString());
                clcAppDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
                if (dt.Rows[0]["Status"].ToString() == "OUT")
                {
                    clcAppDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
                    Btnsave.Visible = false;
                    btnUpdate.Visible = false;
                    btnCancel.Visible = false;
                }
                else
                {
                    clcAppDate.EndDate = DateTime.Now;
                }              
            }
        }
        txtDate.Enabled = false;
        txtTime.Enabled = false;

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string str = "Insert into NursingProgress(CreateUserId,Date,GoalObject,NursingInterventionManagementPlan,Rationale,TransactionID,Createddatetime,PatientID,IsActive,NursingDiagnosis,Implementation,EvaluationOutcome,ActiveEvaluated) values(  '" + ViewState["UserID"] + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "','" + txtProblems.Text.Replace("'", "@") + "','" + txtPrescription.Text.Replace("'", "@") + "','" + txtEvaluation.Text.Replace("'", "@") + "','" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "','1'," +
            "'"+txtNursingDiagnosis.Text+"',    '"+txtImplementation.Text+"',    '"+txtEvaluationOutcome.Text+"' ,   '"+txtActiveEvaluated.Text+"')";
            StockReports.ExecuteDML(str);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
            grdNursingbind();
            Clear();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
    }

    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT np.NursingDiagnosis,np.Implementation,np.EvaluationOutcome,  np.ActiveEvaluated ,np.ID,DATE_FORMAT(DATE,'%d-%b-%Y') AS DATETIME,DATE_FORMAT(DATE,'%h:%i %p') AS TIME,GoalObject,NursingInterventionManagementPlan,Rationale,CreateUserID,(Select Concat(title,' ',Name) from Employee_master where EmployeeID=CreateUserID)EntryBy, ");
        sb.Append(" CONCAT(pm.title,'',pm.PName) AS PatientName,  pm.PatientID,np.TransactionID,CONCAT(dm.Title,'',dm.Name) AS DoctorName,TIMESTAMPDIFF(MINUTE,CreatedDateTime,NOW())createdDateDiff ");
        sb.Append(" FROM NursingProgress np ");
        // sb.Append(" INNER JOIN employee_master em ON em.employee_ID=np.CreateUserID  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.PatientID = np.PatientID");
        sb.Append(" INNER JOIN Patient_master pm ON pm.PatientID = pmh.PatientID ");

        sb.Append(" INNER JOIN Doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
        sb.Append(" where np.transactionID='" + ViewState["TransactionID"] + "' AND np.IsActive=1 GROUP BY np.ID  ORDER BY DATE DESC ");
        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());

        return dtInvest;
    }

    public void grdNursingbind()
    {
        DataTable dt = Search();
        grdNursing.DataSource = dt;
        grdNursing.DataBind();


    }
    protected void grdNursing_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
            ((Label)e.Row.FindControl("lblGoalObject")).Text = ((Label)e.Row.FindControl("lblGoalObject")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblNursingInterventionManagementPlan")).Text = ((Label)e.Row.FindControl("lblNursingInterventionManagementPlan")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblRationale")).Text = ((Label)e.Row.FindControl("lblRationale")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblNursingDiagnosis")).Text = ((Label)e.Row.FindControl("lblNursingDiagnosis")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblImplementation")).Text = ((Label)e.Row.FindControl("lblImplementation")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblEvaluationOutcome")).Text = ((Label)e.Row.FindControl("lblEvaluationOutcome")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblActiveEvaluated")).Text = ((Label)e.Row.FindControl("lblActiveEvaluated")).Text.Replace("@", "'");

        }
    }
    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;
            decimal createdDateDiff = Util.GetDecimal(((Label)grdNursing.Rows[id].FindControl("lblTimeDiff")).Text);
            if (((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
            if (((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
            }
            else
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = true;
            }

            txtProblems.Text = ((Label)grdNursing.Rows[id].FindControl("lblGoalObject")).Text;
            txtPrescription.Text = ((Label)grdNursing.Rows[id].FindControl("lblNursingInterventionManagementPlan")).Text;
            txtEvaluation.Text = ((Label)grdNursing.Rows[id].FindControl("lblRationale")).Text;
            txtNursingDiagnosis.Text = ((Label)grdNursing.Rows[id].FindControl("lblNursingDiagnosis")).Text;
            txtImplementation.Text = ((Label)grdNursing.Rows[id].FindControl("lblImplementation")).Text;
            txtEvaluationOutcome.Text = ((Label)grdNursing.Rows[id].FindControl("lblEvaluationOutcome")).Text;
            txtActiveEvaluated.Text = ((Label)grdNursing.Rows[id].FindControl("lblActiveEvaluated")).Text;
            txtTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text;
            txtDate.Text = ((Label)grdNursing.Rows[id].FindControl("lbldate")).Text;
            btnUpdate.Visible = true;
            Btnsave.Visible = false;
            btnCancel.Visible = true;
            }
            else
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                lblMsg.Text = "You are not able to Edit this Note after 12 hrs";
            }
        }
    }
    private void Clear()
    {
        txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.ToString("HH:mm tt");
        txtEvaluation.Text = "";
        txtPrescription.Text = "";
        txtProblems.Text = "";
        txtNursingDiagnosis.Text = "";
        txtImplementation.Text = "";
        txtEvaluationOutcome.Text = "";
        txtActiveEvaluated.Text = "";
           
        btnCancel.Visible = false;
        btnUpdate.Visible = false;
        Btnsave.Visible = true;

    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "UPDATE nursingprogress SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " " + 
                Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',GoalObject='" + txtProblems.Text.Replace("'", "") +
                "',NursingInterventionManagementPlan='" + txtPrescription.Text.Replace("'", "") + "',Rationale='" + txtEvaluation.Text.Replace("'", "") + "',Createddatetime='" +
                DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss") + "',"+
            "NursingDiagnosis = '"+txtNursingDiagnosis.Text+"',  Implementation = '"+txtImplementation.Text+"',EvaluationOutcome = '"+txtEvaluationOutcome.Text+"',"+
  "ActiveEvaluated = '"+txtActiveEvaluated.Text+"' WHERE ID='" + lblID.Text + "'";
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            if (result == 1)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Update Successfully');", true);
            tnx.Commit();
            grdNursingbind();
            Clear();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
  


    protected void btnPrintNurNote_Click(object sender, EventArgs e)
    {
        DataTable dt = Search();
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "NursingCarePlan";
            AllQuery AQ = new AllQuery();
            DataTable dtInfo = new DataTable();
            if (Util.GetString(ViewState["IsEmergency"]) == "0")
            {
                DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TransactionID"].ToString());
                string Status = dtStatus.Rows[0]["Status"].ToString();
                dtInfo = AQ.GetPatientIPDInformation("", ViewState["TransactionID"].ToString(), Status);
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT PM.Title,IF(pmh.height=' cm','',pmh.height)height,IF(pmh.weight=' KG','',pmh.weight)weight,pmh.allergies,(SELECT ReferredBy FROM patient_referredby WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "')ReferedBy, ");
                sb.Append("PM.PName,CONCAT(PM.Age,'/',IF(pm.DOB<>'0001-01-01',DATE_FORMAT(pm.DOB,'%d-%b-%y'),''))Age,PM.Gender,PMH.PatientID AS Patient_ID,PMH.DoctorID AS Doctor_ID,PMH.ScheduleChargeID,PMH.Admission_Type, ");
                sb.Append("CONCAT(RM.Room_No,'/',RM.Name) RoomNo,FPM.Company_Name,pip.EmergencyNo AS Transaction_ID,FPM.ReferenceCode,PIP.IPDCaseTypeID AS IPDCaseType_ID,FPM.PanelID AS Panel_ID,PIP.RoomId,PMH.Employeeid AS Employee_id, ");
                sb.Append("PMH.PolicyNo,PMH.CardNo,PMH.MLC_NO,'' AS TransNo FROM emergency_patient_details pip  ");
                sb.Append("INNER JOIN  patient_medical_history PMH ON PIP.TransactionId= PMH.TransactionID  ");
                sb.Append("INNER JOIN Patient_Master PM ON PM.PatientID = PMH.PatientID  ");
                sb.Append("LEFT JOIN room_master RM ON rm.RoomID= PIP.RoomId  ");
                sb.Append("INNER JOIN f_panel_master FPM ON PMH.PanelID = FPM.PanelID  ");
                sb.Append("WHERE pip.TransactionId='" + ViewState["TransactionID"].ToString() + "'; ");
                dtInfo = StockReports.GetDataTable(sb.ToString());
            }
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "NursingCarePlan";
            Session["ds"] = ds;
            ds.WriteXmlSchema(@"E:\nursing.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
}
