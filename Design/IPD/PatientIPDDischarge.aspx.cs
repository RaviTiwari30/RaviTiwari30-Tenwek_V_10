using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.Services;

public partial class Design_IPD_PatientIPDDischarge : System.Web.UI.Page
{
    string TID;
    string PatientId="0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           ViewState["ID"] = Session["ID"].ToString();
            TID = Request.QueryString["TransactionID"].ToString();
            BindRefferingCentre();
            bindDoctor();
            
            AllLoadData_IPD.bindTypeOfDeath(ddltypeOfDeath);
            bindDischargeType();
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            lblTID.Text = TID;
            DataTable dt = new DataTable();
            dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            BindPatientDetails(Request.QueryString["TransactionID"].ToString());           
            lblTID.Text = TID;
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    if (Session["RoleID"].ToString() == "3")
                    {
                        AllLoadData_IPD.fromDatetoDate(TID, txtDate, txtDate, calStartDate1, calStartDate1);
                        AllLoadData_IPD.fromDatetoDate(TID, EntryDate1, EntryDate1, calStartDate2, calStartDate2);
                        btnDischarge.Text = "Edit Discharge";
                        btnDisIntimate.Visible = false;
                        return;
                    }
                    else
                    {
                        string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dt.Rows[0]["DateofDischarge"].ToString().Trim()).ToString("dd-MMM-yyyy");
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
                else
                {
                    if (btnDischarge.Text != "Edit Discharge")
                    {
                        ((TextBox)StartTime.FindControl("txtTime")).Text = System.DateTime.Now.ToString("hh:mm tt");

                        txtDate.Text = System.DateTime.Today.ToString("dd-MMM-yyyy");

                        string strdate = string.Empty;
                        strdate = "SELECT DATE_FORMAT(LEFT(MAX(EntryDATE),10), '%d-%b-%Y') EntryDATE FROM f_ledgertnxdetail WHERE IsVerified<>2 AND TransactionID='" + lblTransactionNo.Text + "' ";
                        string str = StockReports.ExecuteScalar(strdate);
                        if (string.IsNullOrEmpty(str))
                            str = System.DateTime.Now.ToString();
                        calStartDate1.StartDate = Convert.ToDateTime(str.ToString());
                        calStartDate1.EndDate = System.DateTime.Now.AddDays(0);

                        EntryDate1.Text = System.DateTime.Today.ToString("dd-MMM-yyyy");
                        calStartDate2.StartDate = Convert.ToDateTime(str.ToString());
                        calStartDate2.EndDate = System.DateTime.Now.AddDays(0);
                    }

                    int IsDischargeIntimate = Util.GetInt(StockReports.ExecuteScalar("SELECT IsDischargeIntimate FROM patient_medical_history WHERE TransactionID='" + lblTransactionNo.Text + "' "));//ipd_case_history
                    if (IsDischargeIntimate == 1)
                    {
                        string validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.Discharge, TID);
                        if (String.IsNullOrEmpty(validateDischargeProcess))
                        {
                            btnDischarge.Enabled = true;
                            lblMsg.Text = "";
                        }
                        else
                        {
                            btnDischarge.Enabled = false;
                            //lblMsg.Text = "Please Add at least One IPD Consultation Visit In Patient Bill First.";
                            lblMsg.Text = validateDischargeProcess; //"Patient Bill Freeze First";
                        }

                        btnDisIntimate.Visible = false;
                        btnDischarge.Visible = true;
                    }
                    else
                    {
                        StringBuilder   sb = new StringBuilder();
                        sb.Append(" SELECT Count(1) FROM cpoe_10cm_patient icdp where icdp.IsActive=1 AND icdp.TransactionID='" + lblTransactionNo.Text + "' ");                        
                        int isFinalDiagnosischeck = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
                        if (isFinalDiagnosischeck > 0)
                        {
                            string validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.DischargeIntimation, TID);
                            if (String.IsNullOrEmpty(validateDischargeProcess))
                            {
                                btnDisIntimate.Enabled = true;
                                lblMsg.Text = "";
                            }
                            else
                            {
                                btnDisIntimate.Enabled = false;
                                lblMsg.Text = validateDischargeProcess;
                            }
                            btnDisIntimate.Visible = true;
                            btnDischarge.Visible = false;
                        }
                        else
                        {
                            btnDisIntimate.Enabled = false;
                            btnDischarge.Visible = false;
                           // lblMsg.Text = "Please Enter Final Diagnosis Information. After that, you can discharge intimate.";
                           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Final Diagnosis Information. After that, you can discharge intimate.');", true);
                        }
                    }
                }
            }
        }
        string causeofdeath = (StockReports.ExecuteScalar("SELECT CauseOfDeath FROM patient_medical_history WHERE TransactionID='" + lblTransactionNo.Text + "' "));//ipd_case_history
        if (causeofdeath != "")
        {
            txtcauseOfDeath.Text = causeofdeath;
            txtcauseOfDeath.Attributes.Add("readOnly", "true");
        }
        txtDate.Attributes.Add("readOnly", "true");
        EntryDate1.Attributes.Add("readOnly", "true");
    }

    private void BindRefferingCentre()
    {
        DataTable dtRH = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE Isactive=1");
        DataView dtview = dtRH.AsDataView();
        dtview.RowFilter = " CentreID <>'" + Session["CentreID"] + "'";

        if (dtview.ToTable().Rows.Count > 0)
        {
            ddlRefferingHospital.DataSource = dtview.ToTable();
            ddlRefferingHospital.DataTextField = "CentreName";
            ddlRefferingHospital.DataValueField = "CentreID";
            ddlRefferingHospital.DataBind();
            ddlRefferingHospital.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void bindDoctor()
    {
        DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.NAME)Dname FROM f_center_doctor cd INNER JOIN doctor_master dm ON dm.DoctorID=cd.DoctorID WHERE cd.CentreID='" + Session["CentreID"] + "' AND cd.isActive=1 order by dm.Name");


        if (dt.Rows.Count > 0)
        {
            ddlInchargeDoctor.DataSource = dt;
            ddlInchargeDoctor.DataTextField = "Dname";
            ddlInchargeDoctor.DataValueField = "DoctorID";
            ddlInchargeDoctor.DataBind();
            ddlInchargeDoctor.Items.Insert(0, new ListItem("Select", "0"));
        }        
    }
    private void BindPatientDetails(string TransactionID)
    {
        AllQuery AQ = new AllQuery();
        if (btnDischarge.Text != "Edit Discharge")
        {
            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID);
            if (dt != null && dt.Rows.Count > 0)
            {
                
                lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();              
                lblRoom_ID.Text = dt.Rows[0]["RoomID"].ToString();
                lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                lblIPDCaseTypeID.Text = dt.Rows[0]["IPDCaseTypeID"].ToString();
                ddlInchargeDoctor.SelectedIndex = ddlRefferingHospital.Items.IndexOf(ddlInchargeDoctor.Items.FindByValue(dt.Rows[0]["DoctorID"].ToString()));
                if(dt.Rows[0]["DischargeType"].ToString()!="")
                {
                    ddlType.SelectedIndex=ddlType.Items.IndexOf(ddlType.Items.FindByValue(dt.Rows[0]["DischargeType"].ToString()));

                    ddlType.Enabled = false;

                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                clear();
            }
        }
     
    }

    public void clear()
    {
       
        lblPatientID.Text = "";       
        lblTransactionNo.Text ="";      
     }
    protected void btnDischarge_Click(object sender, EventArgs e)
    {

        TID = Request.QueryString["TransactionID"].ToString();

       // int medClear = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(stockID)  FROM f_ledgertnxdetail WHERE TransactionID='" + TID + "' AND stockid!='' AND IsVerified=1"));
      //  int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from f_ipdadjustment where TransactionID='" + TID + "'"));

        if (ddlType.SelectedItem.Text.ToString().ToUpper() == "SELECT")
        {
            lblMsg.Text = "Please Select Discharge Type";
            return;
        }


        if (ddlType.SelectedItem.Text.ToString().ToUpper() == "DEATH")
        {
            if (txtcauseOfDeath.Text.ToString() == "")
            {
                lblMsg.Text = "Please Enter CauseOfDeath";
                return;
            }

           /* if (ddltypeOfDeath.SelectedItem.Text.ToString().ToUpper() == "SELECT")
            {
                lblMsg.Text = "Please Enter TypeOfDeath";
                return;
            }*/

            string dtDistime = ((TextBox)StartTime.FindControl("txtTime")).Text;
            DateTime dtDischarge = Util.GetDateTime((txtDate).Text + " " + dtDistime);

            DateTime dtDeath = Util.GetDateTime(((TextBox)EntryDateDeath.FindControl("txtStartDate")).Text + " " + ((TextBox)EntryTimeDeath.FindControl("txtTime")).Text);
            TimeSpan tSpan = (dtDischarge - dtDeath);

            if (tSpan.TotalHours > 24 && chkDeathover48hrs.Checked == false)
            {
                lblMsg.Text = "Time Difference between Time of Discharge & Time of Death is Over 48 Hrs. Please select the death over 48 hrs.";
                chkDeathover48hrs.Focus();
                return;
            }         
        }       
        string time = ((TextBox)StartTime.FindControl("txtTime")).Text;
        try
        {
            
                string dttime =((TextBox)StartTime.FindControl("txtTime")).Text;
                DateTime dtDis = Util.GetDateTime(txtDate.Text + " " + dttime);
                string strdate = string.Empty;
                strdate = "SELECT DATE_FORMAT(LEFT(MAX(EntryDATE),10), '%d-%b-%Y') EntryDATE FROM f_ledgertnxdetail WHERE IsVerified<>2 AND TransactionID='" + lblTransactionNo.Text + "' ";
                string ltddate = StockReports.ExecuteScalar(strdate);
                strdate = "SELECT DATE_FORMAT(TIME(MAX(EntryDATE)), '%I:%i %p' ) EntryTime  FROM f_ledgertnxdetail WHERE IsVerified<>2 AND TransactionID='" + lblTransactionNo.Text + "' ";
                string ltdtime = StockReports.ExecuteScalar(strdate); ;
                DateTime ltdDis = Util.GetDateTime(ltddate + " " + ltdtime);
                TimeSpan tSpan = (ltdDis - dtDis);

                //if ((DateTime.Now.Date != dtDis.Date) && (tSpan.TotalHours > 9))
                if ( (tSpan.TotalHours > 0 ))
                {
                    lblMsg.Text = "Cannot Discharge on Back or Advance Date. Please Contact EDP for such purposes.";
                    return;
                }
            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Patient Not Discharged. Try Again.";
            return;
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction();
        ExcuteCMD excuteCMD=new ExcuteCMD();
        try
        {
            AllUpdate AU = new AllUpdate(objtnx);
            AllQuery AQ = new AllQuery();
            AllSelectQuery ASQ = new AllSelectQuery();
            IPDBilling objupdate = new IPDBilling();
            DataSet ds = new DataSet();


            //=============Current IPDCaseTypeID(p.k.) and PIPid (p.k.) Where status= 'IN' ===========

            if (btnDischarge.Text == "Edit Discharge")
            {
                ds = ASQ.GetIPDCHIDandPIPPPID(Request.QueryString["TransactionID"].ToString(), "OUT");//IPDCaseHistory_ID,PatientIPDProfile_ID
            }
            else
            {
                ds = ASQ.GetIPDCHIDandPIPPPID1(Request.QueryString["TransactionID"].ToString());//IPDCaseHistory_ID,PatientIPDProfile_ID,Room_ID
            }

            string RoomId = "";
            int IPDCaseHistory_ID = Util.GetInt(ds.Tables[0].Rows[0][0].ToString());
            int PatientIPDProfile_ID = Util.GetInt(ds.Tables[0].Rows[0][1].ToString());
            
            if (btnDischarge.Text != "Edit Discharge")
            {
                RoomId = Util.GetString(ds.Tables[0].Rows[0][2].ToString());
            }
            else // Get Room Id to Update IsRoomClean status
            {
                RoomId = Util.GetString(StockReports.ExecuteScalar(" SELECT Room_ID FROM patient_ipd_profile WHERE PatientIPDProfile_ID='" + PatientIPDProfile_ID + "' "));
            }


            //========================================================================================

            //=========== Discharge Time =============================================================

            string strtime = ((TextBox)StartTime.FindControl("txtTime")).Text;
            int RowUpdated = 0;
            // =========== Update IPD Case History ===================================================

            string UsrID=Util.GetString(Session["ID"]);
            RowUpdated = objupdate.updateICH(IPDCaseHistory_ID, Util.GetDateTime(txtDate.Text), Util.GetDateTime(strtime), objtnx, UsrID);

            string str = "Select max(ID) as ID from f_doctorShift where TransactionID='" + TID + "'";
            string Max = StockReports.ExecuteScalar(str);
            string strUpd = "Update f_doctorshift set ToDate='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "', ToTime='" + Util.GetDateTime(strtime).ToString("H:mm:ss") + "' where ID='" + Max + "' ";
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, strUpd);

            if (ddlType.SelectedValue == "Transfer On Requrest")
            {
                saveTransferRequestDetail(objtnx);
            }

            
            if (RowUpdated == 0)
            {
                objtnx.Rollback();
                con.Close();
                con.Dispose();
                lblMsg.Text = "Patient Not Discharged";
                return;
            }
            RowUpdated = 0;
            //=========== Update Patient IPD Profile =================================================
            RowUpdated = objupdate.updatePIP(PatientIPDProfile_ID, Util.GetDateTime(txtDate.Text), Util.GetDateTime(strtime), objtnx);
            if (RowUpdated == 0)
            {
                objtnx.Rollback();
                con.Close();
                con.Dispose();
                lblMsg.Text = "Patient Not Discharged";
                return;
            }
            RowUpdated = 0;
            string strQuerydiet = "Update diet_patientdiet_detail Set EndDate ='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "', EndTime ='" + Util.GetDateTime(strtime).ToString("HH:mm:ss") + "' Where TransactionID ='" + TID + "'  AND CurrentStatus=1";
            int resultdiet = MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, strQuerydiet);

            //========================================================================================
           
            //UPDATING Patient Medical History for Discharge Type i.e. normal, lama etc.
            if (ddlType.SelectedItem.Value.Trim().ToUpper() != "DEATH")
            {
                AU.UpdatePatientMedicalHistory(Request.QueryString["TransactionID"].ToString(), ddlType.SelectedItem.Value.Trim());
            }
            else
            {
                string TimeOfDeath = Util.GetDateTime( ((TextBox)EntryDateDeath.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + " " +Util.GetDateTime( ((TextBox)EntryTimeDeath.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                int TypeOfDeath =Util.GetInt(ddltypeOfDeath.SelectedValue.ToString());
                string CauseOfDeath = txtcauseOfDeath.Text.ToString();
                int Deathover48hrs = 0;
                if (chkDeathover48hrs.Checked == true)
                {
                    Deathover48hrs = 1;
                }
                string Remarks = txtRemarks.Text.ToString();
                AU.UpdatePatientMedicalHistoryDeath(Request.QueryString["TransactionID"].ToString(), ddlType.SelectedItem.Value.Trim(),TimeOfDeath, TypeOfDeath, CauseOfDeath, Deathover48hrs, Remarks);                
            }
                            
          if (btnDischarge.Text == "Edit Discharge")
          {
              lblMsg.Text = "Patient Discharge Status Updated Successfully";
          }
          else
          {
              string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.Discharge);
              //if (!String.IsNullOrEmpty(skipStepIDs))
              //{
              //    AllUpdate objUpdate = new AllUpdate(objtnx);
              //    bool updateStatus = objUpdate.UpdateDischargeProcessStep(Request.QueryString["TransactionID"].ToString(), Util.GetString(Session["ID"]), skipStepIDs);
              //    if (!updateStatus)
              //    {
              //        objtnx.Rollback();

              //    }
              //}
              string strQuery = " UPDATE room_master SET IsRoomClean=1 WHERE RoomID='" + RoomId + "' ";
              MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, strQuery);
             

                 lblMsg.Text = "Patient Successfully Discharged";
             
                //For requested room type
                 string query = "SELECT Count(*) FROM patient_medical_history WHERE RequestedRoomType='" + lblIPDCaseTypeID.Text + "' AND IsRoomRequest='1' ";//ipd_case_history
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, query));
                if (count > 0)
                {
                    //For requested room type
                    string notification = Notification_Insert.notificationInsert(22, lblIPDCaseTypeID.Text, objtnx, "", "");
                }
                
                string notification1 = Notification_Insert.notificationInsert(18,lblTransactionNo.Text, objtnx, "", "",181,DateTime.Now.ToString("yyyy-MM-dd"));

            }
          //--------------Update f_indent_detail_patient Flag IsAutoReject=1 to show discharge patient open status indent to autoreject

            string strQry = "UPDATE f_indent_detail_patient SET IsAutoReject=1,AutoRejectNarration='All Open/Partial Pending Indent Are Rejected On Patient Discharge.' WHERE TransactionID='" + Request.QueryString["TransactionID"].ToString() + "' AND ReqQty >(ReceiveQty+RejectQty)";
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, strQry);

            // --------------Update Room cleaness status-------------------------- //
            //strQry = " UPDATE room_master SET IsRoomClean=1 WHERE Room_ID='" + RoomId + "' ";
            //MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, strQry);

          objtnx.Commit();
            objtnx.Dispose();

            //--------------SMS----------------------
            if (Resources.Resource.SMSApplicable == "1")
            {
                var columninfo1 = smstemplate.getColumnInfo(4, con);
                if (columninfo1.Count > 0)
                {
                    DataTable dtPatientInfo = StockReports.GetDataTable("Select Concat(Title,PName)PName,Mobile from Patient_Master where PAtientID='" + lblPatientID.Text + "'");
                   
                        columninfo1[0].PName = dtPatientInfo.Rows[0]["PName"].ToString();
                        columninfo1[0].ContactNo = dtPatientInfo.Rows[0]["Mobile"].ToString();
                        columninfo1[0].TemplateID = 4;
                        columninfo1[0].PatientID = lblPatientID.Text;
                        string sms = smstemplate.getSMSTemplate(4, columninfo1, 2, con, Session["ID"].ToString());
                    
                }
            }



            con.Close();
            con.Dispose();
            clear();
            if (ddlType.SelectedItem.Text.ToString() == "Death")
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.location='PatientIPDDischarge.aspx?TransactionID=" + lblTransactionNo.Text + "';", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='PatientBillMsg.aspx?Msg=Patient Discharged successfully';", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='PatientBillMsg.aspx?Msg=Patient Discharged successfully';", true);

            }
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            objtnx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Patient Not Discharged";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            clear();
      
        }
    }

    private void saveTransferRequestDetail(MySqlTransaction objtnx)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string PID = Request.QueryString["PID"].ToString();
        int NeedIcuHduBed = 0;
        if (chkUseICU.Checked)
        {
            NeedIcuHduBed = 1;
        }
        int IsEXIT = Util.GetInt(StockReports.ExecuteScalar("select * from PatientTransferReqest where TransactionID='" + lblTransactionNo.Text + "'"));
        if (IsEXIT > 0)
        {
            string sqlUCMD = " Update PatientTransferReqest set IsActive=@IsActive where TransactionID=@TransactionID";
            excuteCMD.DML(objtnx, sqlUCMD, CommandType.Text, new 
            {
                    IsActive=0,
                    TransactionID = lblTransactionNo.Text
            });
        }

        string sqlCmd = "INSERT INTO PatientTransferReqest (PatientID,TransactionID,CentreIDFrom,CentreIDTo,InchargeDoctorID,DiagnosisReason,ManagmentStatusReason,NeedIcuandHdu,CreatedBy,CreatedDate,CentreID,IPAddress,CallerName,ReturnPhoneNo,IsActive,PatientTransferCategory,IsRegister,RegisterBy,RegisterDate)";
        sqlCmd += " VALUES (@PatientID,@TransactionID,@CentreIDFrom,@CentreIDTo,@InchargeDoctorID,@DiagnosisReason,@ManagmentStatusReason,@NeedIcuandHdu,@CreatedBy,NOW(),@CentreID,@IPAddress,@CallerName,@ReturnPhoneNo,@IsActive,@PatientTransferCategory,@IsRegister,RegisterBy,NOW())";
        excuteCMD.DML(objtnx, sqlCmd, CommandType.Text, new
        {
            PatientID = PID,
            TransactionID = Util.GetInt(lblTransactionNo.Text),
            CentreIDFrom = Util.GetInt(Session["CentreID"]),
            CentreIDTo = Util.GetInt(ddlRefferingHospital.SelectedItem.Value),
            InchargeDoctorID = Util.GetInt(ddlInchargeDoctor.SelectedItem.Value),
            DiagnosisReason = txtDiagnosisReason.Text.Trim().ToString(),
            ManagmentStatusReason = txtManagementReason.Text.Trim().ToString(),
            NeedIcuandHdu = Util.GetInt(NeedIcuHduBed),
            CreatedBy = Session["ID"].ToString(),
            CentreID = Util.GetInt(Session["CentreID"]),
            IPAddress=All_LoadData.IpAddress(),
            CallerName=Util.GetString(txtNameofcaller.Text.Trim()),
            ReturnPhoneNo = Util.GetString(txtReturnPhoneNo.Text.Trim()),
            IsActive=1,
            PatientTransferCategory=1,
            IsRegister=1,
            RegisterBy = Session["ID"].ToString()
        });
    }

    protected void btnNarSave_Click(object sender, EventArgs e)
    {
        if (ddlType.SelectedItem.Text.ToString().ToUpper() == "SELECT")
        {
            lblMsg.Text = "Please Select Discharge Type";
            return;
        }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {


            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO f_dischargeintimate(TransactionID,PatientID,PatientLedgerNo,UserID,TentativeDate) ");
            sb.Append("VALUES('" + lblTransactionNo.Text + "','" + lblPatientID.Text + "','" + lblTransactionNo.Text + "','" + Session["id"].ToString() + "','" + Util.GetDateTime(((TextBox)EntryDate1.FindControl("EntryDate1")).Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)EntryTime1.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "') ");
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append("Update Patient_IPD_profile pip INNER JOIN patient_medical_history ich ON pip.TransactionID=ich.TransactionID Set pip.Discharge_IntimatedBy ='" + Util.GetString(Session["ID"]) + "',pip.IsDisIntimated=1,pip.IntimationTime='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)EntryTime1.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "', ");//ipd_case_history
            sb.Append(" ich.DischargeType='"+ddlType.SelectedItem.Text+"',ich.IsDischargeIntimate=1,ich.CauseOfDeath='"+txtcauseOfDeath.Text+"',ich.DischargeIntimateBy='" + Util.GetString(Session["ID"]) + "',ich.DischargeIntimateDate='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)EntryTime1.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "'    Where pip.TransactionID='" + lblTransactionNo.Text + "' AND  pip.Status='IN' AND ich.Type='IPD' ");
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, sb.ToString());

            if (ddlType.SelectedItem.Text == "Death")
            {
                string TimeOfDeath = Util.GetDateTime(((TextBox)EntryDateDeath.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)EntryTimeDeath.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                string strQuery = "Update patient_medical_history Set TimeOfDeath='" + TimeOfDeath + "' Where TransactionID ='" + lblTransactionNo.Text + "'";
                MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, strQuery.ToString());
            }

            string notification = Notification_Insert.notificationInsert(19, lblTransactionNo.Text, objtnx, "", "", 3, "0001-01-01");

            if (notification == "")
            {
                objtnx.Rollback();
                return;
            }

            // Update skipped steps in discharge process
            // string skipStepIDs = "'" + (int)AllGlobalFunction.DischargeProcessStep.MedicalClearance + "'";
            string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.DischargeIntimation);
            if (!String.IsNullOrEmpty(skipStepIDs))
            {
                AllUpdate objUpdate = new AllUpdate(objtnx);
                bool updateStatus = objUpdate.UpdateDischargeProcessStep(lblTransactionNo.Text, Util.GetString(ViewState["ID"]), skipStepIDs);
                if (!updateStatus)
                {
                    objtnx.Rollback();
                    return;
                }
            }          
                //**************** SMS************************//
            DataTable dt = StockReports.GetDataTable("SELECT pm.PatientID,pm.Title,pm.Pname,pm.Mobile,pm.Email,pm.DateEnrolled,SUBSTRING(pid.TransactionID,6) IPDNO FROM patient_master pm INNER JOIN patient_ipd_profile pid ON pm.PatientID=pid.PatientID WHERE  pm.PatientID='" + lblPatientID.Text + "'");
            if (dt.Rows.Count > 0)
            {
                if (Resources.Resource.SMSApplicable == "1" && (dt.Rows[0]["Mobile"].ToString().Length == 10 && dt.Rows[0]["Mobile"].ToString() != ""))
                {                  
                        var columninfo = smstemplate.getColumnInfo(2, con);
                        if (columninfo.Count > 0)
                        {
                            //  string DoctorName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT dm.Name FROM doctor_master dm WHERE dm.`DoctorID`='" + Data[0].DoctorID + "' "));
                            columninfo[0].PatientID = dt.Rows[0]["PatientID"].ToString();
                            columninfo[0].PName = dt.Rows[0]["Pname"].ToString();
                            columninfo[0].Title = dt.Rows[0]["Title"].ToString();
                            columninfo[0].DoctorName = "";
                            columninfo[0].ContactNo = dt.Rows[0]["Mobile"].ToString();
                            columninfo[0].TransactionID = dt.Rows[0]["IPDNO"].ToString();
                            columninfo[0].Amount = hdnbalance.Value;
                            columninfo[0].AppDate = Util.GetDateTime(dt.Rows[0]["DateEnrolled"].ToString()).ToString("dd-MMM-yyyy");
                            columninfo[0].TemplateID = 7;
                            //string sms = smstemplate.getSMSTemplate(9, columninfo, 1, con, Util.GetString(Session["RoleID"]));

                        }
                }
                //if (dt.Rows[0]["Email"].ToString().Length > 0 && dt.Rows[0]["Email"].ToString()!="")
                //{
                //    var columninfo = Email_Master.getemailColumnInfo("UserName#Password#EmailTo");
                //    if (columninfo.Count > 0)
                //    {                                       
                //        columninfo[0].MRNo = dt.Rows[0]["PatientID"].ToString();
                //        columninfo[0].PName = dt.Rows[0]["Pname"].ToString();
                //        columninfo[0].Title = dt.Rows[0]["Title"].ToString();
                //        columninfo[0].DoctorName = "";
                //        columninfo[0].ContactNo = dt.Rows[0]["Mobile"].ToString();
                //        columninfo[0].IPDNo = dt.Rows[0]["IPDNO"].ToString();
                //        columninfo[0].BillAmount = hdnbalance.Value;
                //        columninfo[0].AppDate = Util.GetDateTime(dt.Rows[0]["DateEnrolled"].ToString()).ToString("dd-MMM-yyyy");
                //        columninfo[0].TemplateID = 1;
                //        columninfo[0].UserName = "ankur.kakran@itdoseinfo.com";
                //        columninfo[0].Password = "kakran@123456";
                //        columninfo[0].EmailTo = dt.Rows[0]["Email"].ToString();
                //        string email = Email_Master.SaveEmailTemplate(1, Util.GetInt(Session["RoleID"].ToString()), "1", columninfo, null);
                //    }
                //}  
            }
            objtnx.Commit();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.location='PatientIPDDischarge.aspx?TransactionID=" + lblTransactionNo.Text + "'&PID='" + lblPatientID.Text + "';", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='PatientBillMsg.aspx?Msg=Patient Discharged Intimate successfully';", true);
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            clear();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void bindDischargeType()
    {
        AllLoadData_IPD.bindDischargeType(ddlType);
      //  ddlType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
    }
    [WebMethod(EnableSession = true)]
    public static string CheckICD(string TID)
    {
        var dt = Util.GetString(StockReports.ExecuteScalar(" SELECT Count(1) FROM cpoe_10cm_patient icdp where icdp.IsActive=1 AND icdp.TransactionID='" + TID + "' "));

        if (dt != "" && dt!="0")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }
}
