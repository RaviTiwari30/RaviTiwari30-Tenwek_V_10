using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_PharmacyConsultNotes : System.Web.UI.Page
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
                ViewState["IsEmergency"] = "0";
                clcAppDate.EndDate = Util.GetDateTime(DateTime.Now);

            }
            else
            {
                TID = Request.QueryString["TID"].ToString();
                ViewState["PatientID"] = Request.QueryString["PID"].ToString();
                ViewState["IsEmergency"] = "1";
                clcAppDate.EndDate = Util.GetDateTime(DateTime.Now);
                clcAppDate.StartDate = Util.GetDateTime(DateTime.Now);
            }
            ViewState["TransactionID"] = TID;

            grdNursingbind();

            if (TID.Contains("ISHHI"))
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
        txtDate.Attributes.Add("readOnly", "readOnly");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string str = "Insert into PharmacyConsultNotes(CreateUserId,Date,NursingNotes,TransactionID,PatientID,Createddatetime,IsActive)values(  '" + ViewState["UserID"] + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "', '" + txtPrescription.Text.Replace("'", "@") + "','" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','1')";
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
        sb.Append(" SELECT np.ID, DATE_FORMAT(UpdateDateTime,'%d-%b-%Y %h:%i:%p') AS UpdateDateTime ,DATE_FORMAT(DATE,'%d-%b-%Y') AS DATETIME,  DATE_FORMAT(DATE,'%h:%i %p') AS TIME,NursingNotes,CreateUserID,  (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=CreateUserID)EntryBy, ");
        sb.Append(" CONCAT(pm.title,'',pm.PName) AS PatientName,np.PatientID,np.TransactionID,CONCAT(dm.Title,'',dm.Name) AS DoctorName,TIMESTAMPDIFF(MINUTE,CreatedDateTime,NOW())createdDateDiff  ");
        sb.Append(" FROM PharmacyConsultNotes np ");        
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
            ((Label)e.Row.FindControl("lblNursing")).Text = ((Label)e.Row.FindControl("lblNursing")).Text.Replace("@", "'");
        }
    }
    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;
            DateTime dttime = Util.GetDateTime(((Label)grdNursing.Rows[id].FindControl("lbldate")).Text + " " + ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text);
            DateTime current = Util.GetDateTime(DateTime.Now);
            TimeSpan diff = current.Subtract(dttime); // current - dttime;

            // date2.Subtract(date1);
            if (((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('You are not right person to edit this Notes');", true);

            }
            else if (((diff.Days * 24) + diff.Hours) > 2)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Edit Time Period Expired You can edit only within two hours From Entry Date Time');", true);
            }
            else
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = true;

                txtPrescription.Text = ((Label)grdNursing.Rows[id].FindControl("lblNursing")).Text;
                txtTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text;
                txtDate.Text = ((Label)grdNursing.Rows[id].FindControl("lbldate")).Text;
                btnUpdate.Visible = true;
                Btnsave.Visible = false;
                btnCancel.Visible = true;
            }



        }
    }
    private void Clear()
    {
        txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.ToString("hh:mm tt");

        txtPrescription.Text = "";
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
            string str = "UPDATE PharmacyConsultNotes SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',NursingNotes='" + txtPrescription.Text.Replace("'", "") + "',Createddatetime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss") + "',UpdateDateTime=now() WHERE ID='" + lblID.Text + "'";
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
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = Search();
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "NursingDailyNotes";
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
                sb.Append("SELECT PM.Title,IF(pmh.height=' cm','',pmh.height)height,IF(pmh.weight=' KG','',pmh.weight)weight,pmh.allergies,(SELECT ReferredBy FROM patient_referredby WHERE Transactionid='" + ViewState["TransactionID"].ToString() + "')ReferedBy, ");
                sb.Append("PM.PName,CONCAT(PM.Age,'/',IF(pm.DOB<>'0001-01-01',DATE_FORMAT(pm.DOB,'%d-%b-%y'),''))Age,PM.Gender,PMH.Patient_ID,PMH.Doctor_ID,PMH.ScheduleChargeID,PMH.Admission_Type, ");
                sb.Append("CONCAT(RM.Room_No,'/',RM.Name) RoomNo,FPM.Company_Name,pip.EmergencyNo AS Transaction_ID,FPM.ReferenceCode,PIP.IPDCaseType_ID as IPDCaseType_ID,FPM.PanelID as PanelID,PIP.RoomId,PMH.EmployeeID, ");
                sb.Append("PMH.PolicyNo,PMH.CardNo,PMH.MLC_NO FROM emergency_patient_details pip  ");
                sb.Append("INNER JOIN  patient_medical_history PMH ON PIP.TransactionId= PMH.TransactionID  ");
                sb.Append("INNER JOIN Patient_Master PM ON PM.PatientID = PMH.PatientID  ");
                sb.Append("LEFT JOIN room_master RM ON rm.RoomID= PIP.RoomId  ");
                sb.Append("INNER JOIN f_panel_master FPM ON PMH.PanelID = FPM.PanelID  ");
                sb.Append("WHERE pip.TransactionId='" + ViewState["TransactionID"].ToString() + "' ");
                dtInfo = StockReports.GetDataTable(sb.ToString());
            }
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "NursingDailyNotes";
            Session["ds"] = ds;
            // ds.WriteXmlSchema(@"E:\nursing.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }

    }
}