using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_PatientSearchMRD : System.Web.UI.Page
{
    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                bindPatientType();
                txtPatientID.Focus();
                UserValidation(Session["LoginType"].ToString());
                ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                ucFromDateOPD.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                ucToDateOPD.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                BindPanel();
                BindParentPanel();
                All_LoadData.BindPanelIPD(cmbCompany);
                cmbCompany.Items.Insert(0, new ListItem("Select"));
                All_LoadData.bindDoctor(cmbDoctor, "All");
                AllLoadData_IPD.bindCaseType(cmbRoom);
                cmbRoom.Items.Insert(0, new ListItem("All"));
                All_LoadData.BindDepartment(ddlDepartment, "All");
                AllLoadData_IPD.bindDischargeType(ddlDischageType);
                ddlDischageType.Items.Insert(0, new ListItem("All"));
                txtPatientID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
                txtName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
                txtTransactionNo.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
                txtPatientID.Focus();
                //System.Timers.Timer timer1 = new System.Timers.Timer();
                // timer1.Interval = 10000;
                btnSave.Visible = false;
                btnReport.Visible = false;
                //  timer1.s

                DataTable dt = StockReports.GetDataTable("Select IPDCaseTypeID,Role_ID from f_roomtype_role where Role_ID='" + Session["RoleID"].ToString() + "'");

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Rows.Count == 1)
                    {
                        cmbRoom.Enabled = false;
                        cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dt.Rows[0]["IPDCaseTypeID"].ToString()));
                        ViewState["LoginRoomTypeID"] = dt.Rows[0]["IPDCaseTypeID"].ToString();
                    }
                    else
                    {
                        string LoginRoomTypeID = "";
                        foreach (DataRow dr in dt.Rows)
                        {
                            if (LoginRoomTypeID == "")
                                LoginRoomTypeID = "'" + dr["IPDCaseTypeID"].ToString() + "'";
                            else
                                LoginRoomTypeID += ",'" + dr["IPDCaseTypeID"].ToString() + "'";
                        }

                        ViewState["LoginRoomTypeID"] = LoginRoomTypeID;
                    }
                }
                
            }
            txtTransactionNo.Attributes.Add("onkeyup", "doClick('" + btnSearch.ClientID + "',event)");
            ucFromDate.Attributes.Add("readOnly", "readOnly");
            ucToDate.Attributes.Add("readOnly", "readOnly");
            ucFromDateOPD.Attributes.Add("readOnly", "readOnly");
            ucToDateOPD.Attributes.Add("readOnly", "readOnly");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void bindPatientType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(pmh.TYPE)PType FROM patient_medical_history pmh ORDER BY TYPE");
        ddlPatientType.DataSource = dt;
        ddlPatientType.DataTextField = "PType";
        ddlPatientType.DataValueField = "PType";
        ddlPatientType.DataBind();
        ddlPatientType.Items.Insert(0, new ListItem("ALL"));
        ddlPatientType.SelectedIndex = 2;
    }
    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string Type = "";
            if (rdblAdDis.SelectedItem.Value.ToUpper() == "DI")
            {
                Type = "Discharge";
            }
            else if (rdblAdDis.SelectedItem.Value.ToUpper() == "CAD" || rdblAdDis.SelectedItem.Value.ToUpper() == "AD")
            {
                Type = "Admit";
            }

            string transactionId = e.CommandArgument.ToString().Split('#')[1];
            string Case = e.CommandArgument.ToString().Split('#')[2];

            LoadPatientDetails(Type, transactionId, Case);
        }
        else if (e.CommandName == "BarCode")
        {
            for (int i = 0; i < grdPatient.Rows.Count; i++)
            {
                if (((CheckBox)grdPatient.Rows[i].FindControl("chkBar")).Checked)
                {
                    string TID = e.CommandArgument.ToString();
                    TextBox txtprint = (TextBox)grdPatient.Rows[i].FindControl("txtPrintout");

                    string ip = Util.GetString(All_LoadData.IpAddress());
                    DataTable dtPrinter = StockReports.GetDataTable("select BarcodePrinter from opd_printer where ipAddress='" + ip + "'");

                    if (dtPrinter != null && dtPrinter.Rows.Count > 0)
                    {
                        string BarcodePrinter = dtPrinter.Rows[0]["BarcodePrinter"].ToString();

                        for (int j = 1; j <= Convert.ToInt32(txtprint.Text); j++)
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2" + i + j, "window.open('../FrontOffice/PatientAdmisssionBarCode.aspx?TID=" + TID + "&BarcodePrinter=" + BarcodePrinter + "');", true);
                        }
                        txtprint.Text = "";
                    }
                }
            }
            DataTable dt = (DataTable)ViewState["dt"];
            grdPatient.DataSource = dt;
            grdPatient.DataBind();
        }
        else if (e.CommandName == "Sticker")
        {
            string PatientID = e.CommandArgument.ToString();
            //string query=Request.QueryString["PID"].ToString();
            string sb = "SELECT CONCAT(t2.Title, ' ',t2.PName)PName,REPLACE(t2.PatientID,'LSHHI','') AS PatientID,t2.Gender,CONCAT(t2.House_No,'',t2.Street_Name,'',t2.Locality,'',t2.City)Address,t2.Age,Replace(t2.TransactionID,'ISHHI','')As TransactionID,Concat(dm.Title,' ',dm.Name) AS DName,ictm1.Name AS RName,fpm.Company_Name,ictm2.Name AS BillingCategory,t2.DateOfAdmit AS AdmitDate,CONCAT(t2.DateOfDischarge)DischargeDate,t2.Status,CONCAT(t2.Age,' / ',t2.Gender)AgeSex, " +
                        "CONCAT(rm.Name,'/',rm.Floor)RoomName,rm.Room_No,t2.IPDCaseType_ID,fpm.ReferenceCode,t2.PanelID FROM (SELECT t1.*,pm.ID,pm.Title,PName,Gender,House_No,Street_Name,Locality,City,Pincode,Age,pm.PatientID     FROM (SELECT pip.PatientID,pip.IPDCaseType_ID,pip.IPDCaseType_ID_Bill,pip.Room_ID,        pip.TransactionID,pip.Status,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,        TIME_FORMAT(ich.TimeOfAdmit,'%l: %i %p')" +
                        "TimeOfAdmit,pmh.DoctorID,pmh.PanelID,        IF(ich.DateOfDischarge='0001-01-01','-',DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%y'))DateOfDischarge, " +
                        "IF(ich.TimeOfDischarge='00:00:00','',TIME_FORMAT(ich.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge    FROM     (SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseType_ID,        pip1.IPDCaseType_ID_Bill,pip1.Room_ID,pip1.TransactionID,pip1.Status " +
                        " FROM patient_ipd_profile pip1 INNER JOIN         (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID " +
                        " FROM patient_ipd_profile WHERE STATUS = 'IN' GROUP BY TransactionID         )pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID     )pip INNER JOIN ipd_case_history ich " +
                        "ON pip.TransactionID = ich.TransactionID     INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ich.TransactionID AND pmh.Type='IPD' WHERE ich.status='IN'  ) t1 INNER JOIN  patient_master pm  ON t1.PatientID = pm.PatientID WHERE pm.PatientID='" + PatientID + "' ) " +
                        "t2 INNER JOIN f_panel_master fpm ON fpm.PanelID = t2.PanelID INNER JOIN doctor_master dm ON t2.DoctorID = dm.DoctorID  INNER JOIN ipd_case_type_master ictm1 ON ictm1.IPDCaseType_ID = t2.IPDCaseType_ID INNER JOIN ipd_case_type_master ictm2 ON ictm2.IPDCaseType_ID = t2.IPDCaseType_ID_Bill " +
                        "INNER JOIN room_master rm ON rm.Room_Id = t2.room_id ORDER BY t2.ID DESC, t2.PName, t2.PatientID ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            //ds.WriteXmlSchema("C:/Sticker.xml");
            Session["ReportName"] = "Sticker";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);

            //    Response.Redirect("~/Design/frontoffice/sticker.aspx?PID='" + PatientID + "'");
        }
        else if (e.CommandName == "DiscSummary")
        {
            string TID = e.CommandArgument.ToString().Split('#')[0];
            string Status = e.CommandArgument.ToString().Split('#')[1];
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key12", "window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=" + TID + "&Status=" + Status + "&ReportType=PDF');", true);
          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key12", "../EMR/printDischargeReport_pdf.aspx?TID=ISHHI" + TID + "&Status=" + Status + "&ReportType=PDF);", true);
        }
        else if (e.CommandName == "DocNotes")
        {
            string PatientID = e.CommandArgument.ToString().Split('#')[0];
            string TID = e.CommandArgument.ToString().Split('#')[1];
            string sb = "SELECT CONCAT(t2.Title, ' ',t2.PName)PName,REPLACE(t2.PatientID,'LSHHI','') AS PatientID,t2.Gender,CONCAT(t2.House_No,'',t2.Street_Name,'',t2.Locality,'',t2.City)Address,t2.Age,Replace(t2.TransactionID,'ISHHI','')As TransactionID,Concat(dm.Title,' ',dm.Name) AS DName,ictm1.Name AS RName,fpm.Company_Name,ictm2.Name AS BillingCategory,t2.DateOfAdmit AS AdmitDate,CONCAT(t2.DateOfDischarge)DischargeDate,t2.Status,CONCAT(t2.Age,' / ',t2.Gender)AgeSex, " +
                      "CONCAT(rm.Name,'/',rm.Floor)RoomName,rm.Room_No,t2.IPDCaseType_ID,fpm.ReferenceCode,t2.PanelID FROM (SELECT t1.*,pm.ID,pm.Title,PName,Gender,House_No,Street_Name,Locality,City,Pincode,Age,pm.PatientID     FROM (SELECT pip.PatientID,pip.IPDCaseType_ID,pip.IPDCaseType_ID_Bill,pip.Room_ID,        pip.TransactionID,pip.Status,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,        TIME_FORMAT(ich.TimeOfAdmit,'%l: %i %p')" +
                      "TimeOfAdmit,pmh.DoctorID,pmh.PanelID,        IF(ich.DateOfDischarge='0001-01-01','-',DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%y'))DateOfDischarge, " +
                      "IF(ich.TimeOfDischarge='00:00:00','',TIME_FORMAT(ich.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge    FROM     (SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseType_ID,        pip1.IPDCaseType_ID_Bill,pip1.Room_ID,pip1.TransactionID,pip1.Status " +
                      " FROM patient_ipd_profile pip1 INNER JOIN         (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID " +
                      " FROM patient_ipd_profile  GROUP BY TransactionID         )pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID     )pip INNER JOIN ipd_case_history ich " +
                      "ON pip.TransactionID = ich.TransactionID     INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ich.TransactionID AND pmh.Type='IPD'  ) t1 INNER JOIN  patient_master pm  ON t1.PatientID = pm.PatientID WHERE pm.PatientID='" + PatientID + "' ) " +
                      "t2 INNER JOIN f_panel_master fpm ON fpm.PanelID = t2.PanelID INNER JOIN doctor_master dm ON t2.DoctorID = dm.DoctorID  INNER JOIN ipd_case_type_master ictm1 ON ictm1.IPDCaseType_ID = t2.IPDCaseType_ID INNER JOIN ipd_case_type_master ictm2 ON ictm2.IPDCaseType_ID = t2.IPDCaseType_ID_Bill " +
                      "INNER JOIN room_master rm ON rm.Room_Id = t2.room_id ORDER BY t2.ID DESC, t2.PName, t2.PatientID ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb);

            DataTable dtnotes = StockReports.GetDataTable("SELECT REPLACE(transactionId,'ISHHI','')Ipdno,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p')EntryDate,progressnote,(SELECT CONCAT(title,'',NAME) FROM employee_master em WHERE em.employee_id=userID)EntryBy FROM nursing_doctorprogressnote WHERE TransactionID='ISHHI" + TID + "'");

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "PateintDetail";
            ds.Tables.Add(dtnotes.Copy());
            ds.Tables[1].TableName = "DocNotes";
            Session["ds"] = ds;
            ds.WriteXmlSchema("D:/DoctorNote.xml");
            Session["ReportName"] = "DoctorProgressNote";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
        }
        else
        {
            string TID = e.CommandArgument.ToString().Split('#')[0];
            string LoginType = e.CommandArgument.ToString().Split('#')[1];

            //Checking Whether Bill is generated or not
            string BillNo = StockReports.ExecuteScalar("Select BillNo from f_ipdAdjustment where TransactionID='" + TID + "'");

            if (string.IsNullOrEmpty(BillNo))
                Response.Redirect("~/Design/IPD/IPDBilling.aspx?TID=" + TID + "&LoginType=" + LoginType);
            else
                Response.Redirect("~/Design/IPD/IPDBilling.aspx?TID=" + TID + "&LoginType=" + LoginType + "&BillNo=" + BillNo);
        }
    }

    protected void grdPatient_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //if (((Label)e.Row.FindControl("lblPayStatus")).Text.ToUpper() == "TRUE")
            e.Row.Attributes.Add("style", "background-color:lightpink");

            ((Image)e.Row.FindControl("NewImage")).Attributes.Add("OnClick", "WriteToFile('" + ((Label)e.Row.FindControl("lbl1")).Text + "','" + ((Label)e.Row.FindControl("lbl2")).Text + "','" + ((TextBox)e.Row.FindControl("txtPrintout")).ClientID + "');");

            if (((Label)e.Row.FindControl("lblIsReceived")).Text == "1")
            {
                ((CheckBox)e.Row.FindControl("chkBox")).Visible = false;
                ((CheckBox)e.Row.FindControl("chkBox")).Enabled = false;
                e.Row.Attributes.Add("style", "background-color:lightgreen");
            }

            if (((Label)e.Row.FindControl("lblDischargeSummary")).Text == "1")
            {
                ((ImageButton)e.Row.FindControl("imgDiscSummary")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lblDoctorNotes")).Text == "1")
            {
                ((ImageButton)e.Row.FindControl("imgDocNotes")).Visible = true;
            }
        }
    }

    #endregion Events

    #region Local Functions

    public void BindPanel()
    {
        try
        {
            DataTable dt = LoadCacheQuery.loadAllPanel();
            cmbCompany.DataSource = dt;
            cmbCompany.DataTextField = "Company_Name";
            cmbCompany.DataValueField = "PanelID";
            cmbCompany.DataBind();
            cmbCompany.Items.Insert(0, new ListItem("Select"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    public void BindParentPanel()
    {
        try
        {
            DataTable dt = LoadCacheQuery.loadAllPanel();
            ddlParentPanel.DataSource = dt;
            ddlParentPanel.DataTextField = "Company_Name";
            ddlParentPanel.DataValueField = "PanelID";
            ddlParentPanel.DataBind();
            ddlParentPanel.Items.Insert(0, new ListItem("Select"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void LoadPatientDetails(string Type, string TID, string Case)
    {
        DataTable dt = new DataTable();
        if (Type == "Discharge")
        {
            dt = CreateStockMaster.GetAdmitDetail(TID, Type);
        }
        else
        {
            dt = CreateStockMaster.GetAdmitDetail(TID, Type);
        }
        if (dt != null && dt.Rows.Count > 0)
        {
            lblPhone.Text = dt.Rows[0]["Phone"].ToString();
            lblMobile.Text = dt.Rows[0]["Mobile"].ToString();
            lblRoom.Text = dt.Rows[0]["Room"].ToString();
            lblKinRelation.Text = dt.Rows[0]["KinRelation"].ToString();
            lblKinName.Text = dt.Rows[0]["KinName"].ToString();
            lblAdmitDate.Text = Util.GetDateTime(dt.Rows[0]["AdmitDate"]).ToString("dd-MMM-yyyy") + " " + Util.GetDateTime(dt.Rows[0]["TimeOfAdmit"]).ToString("HH:mm:ss");

            if (dt.Columns.Contains("DischargeDate") == true)
            {
                lblDisDate.Text = dt.Rows[0]["DischargeDate"].ToString();
            }
            else
            {
                lblDisDate.Text = "-";
            }
        }
        lblPName.Text = dt.Rows[0]["Pname"].ToString();
        lblGender.Text = dt.Rows[0]["Gender"].ToString();
        lblAge.Text = dt.Rows[0]["Age"].ToString();
        lblCase.Text = Case;
        lblAddress.Text = dt.Rows[0]["Address"].ToString();

        mdlPatient.Show();
    }

    private DataTable SearchPatient(string patientType,string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status, string LabNo, string Department, string Locality, string AgeFrom, string AgeTo, string KinName, string Location, string ParentPanel, string IsReceived)
    {
        try
        {
            if (AgeFrom.Contains("YR") == true)
                AgeFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(AgeFrom.Replace("YRS", "").Trim()) * 365)));
            else if (AgeFrom.Contains("DAY") == true)
                AgeFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(AgeFrom.Replace("DAY(S)", "").Trim()) * 1)));
            else if (AgeFrom.Contains("MON") == true)
                AgeFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(AgeFrom.Replace("MONTH(S)", "").Trim()) * 30)));

            if (AgeTo.Contains("YR") == true)
                AgeTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(AgeTo.Replace("YRS", "").Trim()) * 365)));
            else if (AgeFrom.Contains("DAY") == true)
                AgeTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(AgeTo.Replace("DAY(S)", "").Trim()) * 1)));
            else if (AgeFrom.Contains("MON") == true)
                AgeTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(AgeTo.Replace("MONTH(S)", "").Trim()) * 30)));

            int iCheck = 0;
            if (TransactionId != "" || PatientId != "" || PatientName != "")
                iCheck = 1;

            StringBuilder sb = new StringBuilder();
            sb.Append("");

            sb.Append("Select t2.Type,IF (IsIssued IS NULL,'NO','YES')Register,CASE WHEN IsIssued=0 THEN 'IN' WHEN IsIssued=1 THEN 'OUT' ELSE '' END issueSTATUS ,CONCAT(t2.Title, ' ',t2.PName)PName,t2.PatientID,");
            sb.Append("CONCAT(t2.House_No,'',t2.Street_Name,'',t2.Locality,' ',t2.City)Address,t2.Mobile,");
            sb.Append("t2.Age,REPLACE(T2.TransactionID,'ISHHI','')TransactionID,dm.Name as DName,dm.Specialization,ictm1.Name as RName,CONCAT(rm.Bed_No,'/',rm.Name)RoomName,fpm.Company_Name,");
            sb.Append("IF(t2.DateofAdmit='01-Jan-0001','-', CONCAT(t2.DateOfAdmit,' ',t2.TimeOfAdmit))AdmitDate,t2.MRD_IsFile,t2.ReceiveFile_By,t2.ReceiveFile_Date ,CONCAT(t2.DateOfDischarge,' ',t2.TimeOfDischarge)DischargeDate,t2.Status,");
            sb.Append("CONCAT(t2.Age,' / ',t2.Gender)AgeSex,t2.IPDCaseTypeID,fpm.ReferenceCode,t2.PanelID,t2.ScheduleChargeID, ");

            sb.Append(" Department,adj.BillNo,(Select Name from employee_master where employeeID=t2.UserID)AdmittedBy, ");
            sb.Append("(case when adj.IsBilledClosed=1 then 'Bill Finalised' WHEN adj.Type<>'IPD' THEN 'Bill Finalised' when adj.IsBilledClosed=0 and IFNULL(adj.BillNo,'')!='' then 'Bill Not-Finalised'  when t2.Status='IN' then 'Admitted' else 'Discharged' end)BillStatus,adj.IsBilledClosed ");
            sb.Append(",(SELECT IF(IsSend=1,CONCAT(DeliveryStatus,' at ',CONCAT(DATE_FORMAT(DeliveryDate,'%d-%b-%Y'),' ',TIME(DeliveryDate))),IFNULL(error_msg,'Connection Problem'))SmsStatus FROM sms WHERE TransactionID=t2.TransactionID AND DoctorID=t2.DoctorID Limit 1)SmsStatus,Relation,RelationName,StayDays,adj.DischargeType,DaysAfterDischarge,IF(emr.header IS NULL,'0','1') AS DischargeSummary,IF((SELECT COUNT(*) FROM nursing_doctorprogressnote WHERE TransactionID=t2.TransactionID)>1,1,0)DoctorNote,IF(adj.TransNo=0,'',adj.TransNo )TransNo,t2.IsSendToMrd ");
            sb.Append("  from (");
            sb.Append("     Select t1.*,pm.ID,pm.Title,PName,Gender,House_No,Street_Name,Locality,City,Age,pm.Mobile,pm.Relation,pm.RelationName ");
            sb.Append("     from (Select pmh.Type, pmh.PatientID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,pip.RoomID,");
            sb.Append("     pmh.TransactionID,pip.Status,Date_Format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,pmh.MRD_IsFile,pmh.ReceiveFile_By,Date_Format(pmh.ReceiveFile_Date,'%d-%b-%Y %l: %i %p')ReceiveFile_Date,");
            sb.Append("     Time_format(pmh.TimeOfAdmit,'%l: %i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID,pmh.ScheduleChargeID,");
            sb.Append("     if(pmh.DateOfDischarge='0001-01-01','-',Date_Format(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge,");
            sb.Append("     if(pmh.TimeOfDischarge='00:00:00','',Time_format(pmh.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge, ");
            sb.Append("     if(pmh.KinName <>'',CONCAT(pmh.KinName,'(',pmh.KinRelation,')'),'')KinRelation,pmh.UserID, ");

            sb.Append("     IF(DateOfDischarge='0001-01-01','',CONCAT( FLOOR(HOUR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))) / 24), ' days ', ");
            sb.Append("     MOD(HOUR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))), 24), ' hours ', ");
            sb.Append("     MINUTE(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))), ' minutes'))StayDays,pmh.DischargeType, ");
            sb.Append("     if(DateOfDischarge='0001-01-01','',CONCAT( FLOOR(HOUR(TIMEDIFF(CURRENT_TIMESTAMP,CONCAT(DateOfDischarge,' ',TimeOfDischarge))) / 24), ' days ', ");
            sb.Append("     MOD(HOUR(TIMEDIFF(CURRENT_TIMESTAMP,CONCAT(DateOfDischarge,' ',TimeOfDischarge))), 24), ' hours ', ");
            sb.Append("     MINUTE(TIMEDIFF(CURRENT_TIMESTAMP,CONCAT(DateOfDischarge,' ',TimeOfDischarge))), ' minutes'))DaysAfterDischarge  ");

            sb.Append("    ,IFNULL((SELECT COUNT(*) FROM filesendtomrd m WHERE m.`TransactionId`=pmh.TransactionID AND m.CentreID=" + Util.GetInt(Session["CentreID"]) + " AND m.`IsSent`=1 ),0) AS IsSendToMrd ");
            sb.Append("     from patient_medical_history pmh LEFT JOIN (");
            sb.Append("         Select pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,");
            sb.Append("         pip1.IPDCaseTypeID_Bill,pip1.RoomID,pip1.TransactionID,pip1.Status ");
            sb.Append("         from patient_ipd_profile pip1 inner join (");
            sb.Append("             Select max(PatientIPDProfile_ID)PatientIPDProfile_ID ");
            sb.Append("             from patient_ipd_profile ");

            if (TransactionId != "")
            {
                sb.Append("         Where TransactionID='" + TransactionId + "'  and ucase(status) <> 'CANCEL' ");
            }
            else
            {
                sb.Append("         Where status = '" + status + "' ");
            }

            if (PatientId != "")
            {
                sb.Append("         and PatientID='" + PatientId + "'");
            }
            if (RoomID != "")
            {
                sb.Append("         and IPDCaseTypeID in (" + RoomID + ")");
            }

            sb.Append("             group by TransactionID ");
            sb.Append("        )pip2 on pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID ");
            sb.Append("     )pip  ");
            sb.Append("     on pmh.TransactionID = pip.TransactionID WHERE pmh.BillNo<>'' ");

            if (TransactionId != "")
            {
                sb.Append("         AND  pmh.TransactionID='" + TransactionId + "' ");
            }

            if(ddlPatientType.SelectedItem.Value!="ALL")
            {
                sb.Append("         AND  pmh.Type = '" + ddlPatientType.SelectedItem.Value + "' ");
            }
            if (FromAdmitDate != "" && ToAdmitDate != "")
            {
                sb.Append("   and DATE(pmh.Billdate) >= '" + FromAdmitDate + "' and pmh.DateOfAdmit <= '" + ToAdmitDate + "'");
            }
            else if (FromAdmitDate != "" && ToAdmitDate == "")
            {
                sb.Append(" and pmh.DateOfAdmit >= '" + FromAdmitDate + "'");
            }
            if (IsReceived != "")
            {
                sb.Append(" and pmh.MRD_IsFile='" + IsReceived + "'");
            }
            if (ParentPanel != "")
            {
                sb.Append(" and pmh.ParentID ='" + ParentPanel + "'");
            }
            if (ddlDischageType.SelectedIndex!=0)
            {
                sb.Append("  and pmh.DischargeType ='" + ddlDischageType.SelectedItem.Text.ToString() + "'");
            }

            if (iCheck == 0)
            {
                if (DischargeDateFrom != "" && DischargeDateTo != "")
                {
                    sb.Append("   and DATE(pmh.Billdate) >= '" + DischargeDateFrom + "' and DATE(pmh.Billdate) <= '" + DischargeDateTo + "'");
                }
                else if (DischargeDateFrom != "" && DischargeDateTo == "")
                {
                    sb.Append("  and DATE(pmh.Billdate) >= '" + DischargeDateFrom + "'");
                }
            }
            if (Company != "")
            {
                sb.Append(" and PanelID=" + Company + " ");
            }

            if (DoctorID != "")
            {
                sb.Append(" and DoctorID = '" + DoctorID + "'");
            }

            sb.Append(") t1 inner join  patient_master pm  ");
            sb.Append("on t1.PatientID = pm.PatientID ");
            sb.Append("Where pm.PatientID <>'' ");
           

            if (PatientId != "")
            {
                sb.Append(" and PatientID='" + PatientId + "'");
            }

            if (PatientName != "" && PatientId == "")
            {
                sb.Append(" and pname like '%" + PatientName + "%'");
            }

            if (AgeFrom != "")
            {
                sb.Append(" and (Case when Age like '%Yr%' then trim(Replace(Age,'YRS',''))*365 ");
                sb.Append(" when Age like '%DAY%' then trim(Replace(Age,'DAY(S)',''))*1  ");
                sb.Append(" when Age like '%MON%' then trim(Replace(Age,'MON',''))*30 end) >= '" + AgeFrom + "'");
            }

            if (AgeTo != "")
            {
                sb.Append(" and (Case when Age like '%Yr%' then trim(Replace(Age,'YRS',''))*365 ");
                sb.Append(" when Age like '%DAY%' then trim(Replace(Age,'DAY(S)',''))*1  ");
                sb.Append(" when Age like '%MON%' then trim(Replace(Age,'MON',''))*30 end) <= '" + AgeTo + "'");
            }

            sb.Append(" ) t2 ");
            sb.Append(" inner join f_panel_master fpm on fpm.PanelID = t2.PanelID ");
            //sb.Append(" inner join patient_medical_history  ptmh on ptmh.ParentID = t2.ParentID ");
            sb.Append(" inner join doctor_master dm on t2.DoctorID = dm.DoctorID ");
            sb.Append(" LEFT join (Select DoctorID,Department from doctor_Hospital ");

            if (Department != "")
                sb.Append("where Department like '" + Department + "' ");

            sb.Append(" group by DoctorID) dh on t2.DoctorID = dh.DoctorID ");
            sb.Append(" LEFT join ipd_case_type_master ictm1 on ictm1.IPDCaseTypeID = t2.IPDCaseTypeID  ");
            sb.Append(" LEFT join ipd_case_type_master ictm2 on ictm2.IPDCaseTypeID = t2.IPDCaseTypeID_Bill ");
            sb.Append(" LEFT join room_master rm on rm.RoomId = t2.roomid ");
            sb.Append(" inner join patient_medical_history adj on adj.TransactionID = T2.TransactionID LEFT JOIN emr_ipd_details emr ON emr.TransactionID = T2.TransactionID ");
            //sb.Append(" INNER JOIN FileSendToMrd fsm ON fsm.`TransactionId`=t2.Transactionid ");
            sb.Append(" LEFT JOIN  mrd_file_master mfm ON mfm.PatientID=t2.PatientID where  adj.Centreid=" + Util.GetInt(Session["CentreID"]) + "    ");

            if (rdblAdDis.SelectedItem.Value.ToUpper() == "BNF" && TransactionId == "")
            {
                sb.Append(" and adj.IsBilledClosed=0 and ifnull(BillNo,'')<>''  ");
            }

            if (rdblAdDis.SelectedItem.Value.ToUpper() == "BF" && TransactionId == "")
            {
                sb.Append(" and adj.IsBilledClosed=1 and ifnull(BillNo,'')<>''  ");
            }

            sb.Append(" order by adj.TransNo  desc,t2.ID , t2.PName, t2.PatientID");

            DataTable Items = StockReports.GetDataTable(sb.ToString());

            if (Items.Rows.Count > 0)
            {
                //Checking for automatically select radiobutton if user is searching by IP No

                if (TransactionId != "")
                {
                    ListItem BNF = rdblAdDis.Items.FindByValue("BNF");// BNF - Bill Not Finalised
                    ListItem BF = rdblAdDis.Items.FindByValue("BF");// BF - Bill Finalised
                    ListItem DI = rdblAdDis.Items.FindByValue("DI");

                    if (Items.Rows[0]["Status"].ToString().ToUpper() == "IN")
                        rdblAdDis.SelectedValue = "CAD";
                    else if (Items.Rows[0]["BillNo"].ToString() == "" && Items.Rows[0]["IsBilledClosed"].ToString() == "0" && Items.Rows[0]["Status"].ToString().ToUpper() == "OUT" && rdblAdDis.Items.Contains(DI) == true)
                        rdblAdDis.SelectedValue = "DI";
                    else if (Items.Rows[0]["BillNo"].ToString() != "" && Items.Rows[0]["IsBilledClosed"].ToString() == "0" && Items.Rows[0]["Status"].ToString().ToUpper() == "OUT" && rdblAdDis.Items.Contains(BNF) == true)
                        rdblAdDis.SelectedValue = "BNF";
                    else if (Items.Rows[0]["BillNo"].ToString() != "" && Items.Rows[0]["IsBilledClosed"].ToString() == "1" && Items.Rows[0]["Status"].ToString().ToUpper() == "OUT" && rdblAdDis.Items.Contains(BF) == true)
                        rdblAdDis.SelectedValue = "BF";
                    else
                        rdblAdDis.SelectedValue = "DI";
                }

                return Items;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    private void UserValidation(string LoginType)
    {
        try
        {
            switch (LoginType.ToUpper())
            {
                case "BILLING":
                case "ACCOUNT":
                case "ADMIN":
                case "MEDICAL STORE":
                    break;

                default:
                    ListItem BNF = rdblAdDis.Items.FindByValue("BNF");// BNF - Bill Not Finalised
                    rdblAdDis.Items.Remove(BNF);
                    ListItem BF = rdblAdDis.Items.FindByValue("BF");// BF - Bill Finalised
                    rdblAdDis.Items.Remove(BF);
                    break;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    #endregion Local Functions


    protected void btnSearch_Click1(object sender, EventArgs e)
    {
        SearchGrid();
    }
    private void SearchGrid()
    {
        try
        {
            if (rdbselectedtype.SelectedItem.Value == "1")
            {
                grdPatient.Visible = true;
                grdMRD.Visible = false;
                grdgeneral.Visible = false;
                string FromAdmitDate = "", LabNo = "", ToAdmitDate = "", VisitDateFrom = "", VisitDateTo = "", DischargeDateFrom = "", DischargeDateTo = "";
                string DoctorID = "", Company = "", RoomID = "", PatientName = "", PatientId = "", TransactionId = "", status = "";
                string Department = "", Locality = "", AgeFrom = "", AgeTo = "", KinName = "", Location = "", ParentPanel = "", IsReceived = "";

                rdblAdDis.SelectedValue = "DI";

                if (rdblAdDis.SelectedItem.Value.ToUpper() == "CAD")
                {
                    status = "IN";
                    FromAdmitDate = "";
                    ToAdmitDate = "";
                }
                else if (rdblAdDis.SelectedItem.Value.ToUpper() == "AD")
                {
                    status = "IN";
                    FromAdmitDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
                    ToAdmitDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
                }
                else
                {
                    status = "OUT";
                    DischargeDateFrom = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
                    DischargeDateTo = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
                }

                if (txtName.Text != "")
                {
                    PatientName = txtName.Text.Trim();
                }

                if (txtPatientID.Text != "")
                {
                    PatientId = txtPatientID.Text.Trim();
                }
                if (txtTransactionNo.Text != "")
                {
                    TransactionId = StockReports.getTransactionIDbyTransNo(txtTransactionNo.Text.Trim());// "ISHHI" + txtTransactionNo.Text.Trim();
                }
                if (cmbCompany.SelectedIndex != 0)
                {
                    Company = cmbCompany.SelectedItem.Value;
                }

                if (cmbDoctor.SelectedIndex != 0)
                {
                    DoctorID = cmbDoctor.SelectedItem.Value;
                }

                if (cmbRoom.SelectedIndex != 0)
                {
                    RoomID = "'" + cmbRoom.SelectedItem.Value + "'";
                }
                else
                {
                    if (ViewState["LoginRoomTypeID"] != null)
                        RoomID = ViewState["LoginRoomTypeID"].ToString();

                    if (TransactionId != "")
                    {
                        DataTable dtCase = StockReports.GetDataTable("Select * from ipd_case_type_master");

                        if (dtCase != null && dtCase.Rows.Count > 0)
                        {
                            RoomID = "";
                            foreach (DataRow dr in dtCase.Rows)
                            {
                                if (RoomID == "")
                                    RoomID = "'" + dr["IPDCaseTypeID"].ToString() + "'";
                                else
                                    RoomID += ",'" + dr["IPDCaseTypeID"].ToString() + "'";
                            }
                        }
                    }
                }

                if (ddlDepartment.SelectedIndex != 0)
                {
                    Department = ddlDepartment.SelectedItem.Value;
                }

                if (txtAgeFrom.Text != "")
                {
                    AgeFrom = txtAgeFrom.Text.Trim() + " " + ddlAgeFrom.SelectedItem.Text;
                }

                if (txtAgeTo.Text != "")
                {
                    AgeTo = txtAgeTo.Text.Trim() + " " + ddlAgeTo.SelectedItem.Text;
                }

                if (ddlParentPanel.SelectedIndex != 0)
                {
                    ParentPanel = ddlParentPanel.SelectedItem.Value;
                }
                if (ddlStatus.SelectedItem.Value != "2")
                {
                    IsReceived = ddlStatus.SelectedItem.Value;
                }
                string patientType = ddlPatientType.SelectedItem.Value;
                DataTable dt;
                //dt = CreateStockMaster.SearchPatient(PatientId, PatientName, TransactionId, RoomID, DoctorID, Company, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status,LabNo,Department,Locality);
                dt = SearchPatient(patientType,PatientId, PatientName, TransactionId, RoomID, DoctorID, Company, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status, LabNo, Department, Locality, AgeFrom, AgeTo, KinName, Location, ParentPanel, IsReceived);
                ViewState["dt"] = dt;
                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Columns.Contains("LoginType") == false)
                    {
                        DataColumn dc = new DataColumn();
                        dc.ColumnName = "LoginType";
                        dc.DefaultValue = Session["LoginType"].ToString();
                        dt.Columns.Add(dc);
                        //dc = new DataColumn();
                        //dc.ColumnName = "Type";
                        //dc.DefaultValue = "IPD";
                        //dt.Columns.Add(dc);
                    }
                    else
                    {
                        dt.Columns["LoginType"].DefaultValue = Session["LoginType"].ToString();
                    }
                    grdPatient.DataSource = dt;
                    grdPatient.DataBind();
                    btnSave.Visible = true;
                    btnReport.Visible = true;
                    ViewState["dt"] = dt;
                    lblMsg.Text = "";
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' Record Not Found ', function(){});", true);
                    grdPatient.DataSource = null;
                    grdPatient.DataBind();
                    btnSave.Visible = false;
                    btnReport.Visible = false;
                }
            }
            else if (rdbselectedtype.SelectedItem.Value == "2")
            {
                grdMRD.Visible = true;
                grdPatient.Visible = false;
                grdgeneral.Visible = false;
                btnSave.Visible = false;
                btnReport.Visible = false;
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT IF (IsIssued IS NULL,'NO','YES')Register,CASE WHEN IsIssued=0 THEN 'IN' WHEN IsIssued=1 THEN 'OUT' ELSE '' END issueSTATUS,  app.TransactionID,app.PatientID,App_ID,AppNo,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
                sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,app.VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
                sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%y')AppDate,IsConform,IsReschedule, IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%y %l:%i %p')ConformDate,ifnull(LedgerTnxNo,'')LedgerTnxNo,CONCAT(DATE,' ',TIME)AppDateTime,ContactNo,'' Status, ");
                sb.Append(" IF(IFNULL(Isissue,0)=0,'TRUE','FALSE')IsIssue,IF(IFNULL(Isreturn,0)=0,'TRUE','FALSE')IsReturn FROM appointment app ");
                sb.Append(" LEFT JOIN mrd_opd_fileStatus mrdf ON mrdf.PatientID=app.PatientID and mrdf.AppointmentID=app.App_ID");
                sb.Append(" LEFT JOIN  mrd_file_master mfm ON mfm.PatientID=app.PatientID");

                sb.Append(" where Date>='" + Util.GetDateTime(ucFromDateOPD.Text).ToString("yyyy-MM-dd") + "'");
                sb.Append(" and Date<='" + Util.GetDateTime(ucToDateOPD.Text).ToString("yyyy-MM-dd") + "' and IsConform=1 AND app.PatientID!='' ");
                if (txtMrnoOpd.Text != "")
                {
                    sb.Append(" and app.PatientID='" + txtMrnoOpd.Text + "'");
                }
                if (txtPatientnameOpd.Text != "")
                {
                    sb.Append(" and app.pname like'%" + txtPatientnameOpd.Text + "%'");
                }
                if (ddlFileStatus_OPD.SelectedValue != "2")
                {
                    sb.Append(" and IsIssued='" + ddlFileStatus_OPD.SelectedValue + "'");
                }
                sb.Append("  ORDER BY DATE,TIME,AppNo");
                DataTable dtMRD = StockReports.GetDataTable(sb.ToString());
                if (dtMRD.Rows.Count > 0)
                {
                    if (dtMRD.Columns.Contains("LoginType") == false)
                    {
                        DataColumn dc = new DataColumn();
                        dc.ColumnName = "LoginType";
                        dc.DefaultValue = Session["LoginType"].ToString();
                        dtMRD.Columns.Add(dc);
                        dc = new DataColumn();
                        dc.ColumnName = "Type";
                        dc.DefaultValue = "OPD";
                        dtMRD.Columns.Add(dc);
                        dc = new DataColumn();
                        dc.ColumnName = "Billno";
                        dc.DefaultValue = " ";
                        dtMRD.Columns.Add(dc);
                    }
                    else
                    {
                        dtMRD.Columns["LoginType"].DefaultValue = Session["LoginType"].ToString();
                    }

                    grdMRD.DataSource = dtMRD;
                    grdMRD.DataBind();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                    grdMRD.DataSource = null;
                    grdMRD.DataBind();
                }
            }
            else if (rdbselectedtype.SelectedItem.Value == "3")
            {
                grdMRD.Visible = false;
                grdPatient.Visible = false;
                grdgeneral.Visible = true;
                btnSave.Visible = false;
                btnReport.Visible = false;
                string ucfromdate = Util.GetDateTime(ucFromDateOPD.Text).ToString("yyyy-MM-dd");
                string uctodate = Util.GetDateTime(ucToDateOPD.Text).ToString("yyyy-MM-dd");
                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT IF (IsIssued IS NULL,'NO','YES')Register,CASE WHEN IsIssued=0 THEN 'IN' WHEN IsIssued=1 THEN 'OUT' ELSE '' END issuestatus , pm.PatientID,CONCAT(House_No,', ',City,', ',Country)Address,");
                sb.Append("   mobile,Age,Gender,DATE_FORMAT(DateEnrolled,'%d-%m-%Y') DateEnrolled,CONCAT(title,' ',PName)PName ,");
                sb.Append("  (SELECT CONCAT(title,' ',NAME)RegisterBy FROM Employee_master WHERE Employee_ID=RegisterBy)RegisterBy ");
                sb.Append(" FROM Patient_master pm LEFT JOIN  mrd_file_master mfm ON mfm.PatientID=pm.PatientID ");

                sb.Append("  where pm.PatientID LIKE 'MR%' ");
                if (txtMrnoOpd.Text != "")
                {
                    sb.Append(" and pm.PatientID='" + txtMrnoOpd.Text + "'");
                }
                if (txtPatientnameOpd.Text != "")
                {
                    sb.Append(" and pm.pname like'%" + txtPatientnameOpd.Text + "%'");
                }
                if (ddlFileStatus_OPD.SelectedValue != "2")
                {
                    sb.Append(" and IsIssued='" + ddlFileStatus_OPD.SelectedValue + "'");
                }
                if (txtMrnoOpd.Text == "" && txtPatientnameOpd.Text == "")
                {
                    sb.Append(" and DATE(DateEnrolled)>='" + ucfromdate + "' AND DATE(DateEnrolled)<='" + uctodate + "'");
                }
                sb.Append(" ORDER BY DateEnrolled");
                DataTable dtMRD = StockReports.GetDataTable(sb.ToString());
                if (dtMRD.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "LoginType";
                    dc.DefaultValue = Session["LoginType"].ToString();
                    dtMRD.Columns.Add(dc);
                    dc = new DataColumn();
                    dc.ColumnName = "TransactionID";
                    dc.DefaultValue = "";
                    dtMRD.Columns.Add(dc);
                    dc = new DataColumn();
                    dc.ColumnName = "Type";
                    dc.DefaultValue = "General";
                    dtMRD.Columns.Add(dc);
                    dc = new DataColumn();
                    dc.ColumnName = "Billno";
                    dc.DefaultValue = " ";
                    dtMRD.Columns.Add(dc);
                    grdgeneral.DataSource = dtMRD;
                    grdgeneral.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdMRD_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "FileIssue")
        {
            int index = int.Parse(e.CommandArgument.ToString());
            GridViewRow row = grdMRD.Rows[index];
            lblIssuePatientID.Text = ((Label)row.FindControl("lblMRNo")).Text.ToString();
            StringBuilder sb4 = new StringBuilder();
            sb4.Append("SELECT * FROM mrd_file_master where PatientID='" + lblIssuePatientID.Text + "' and IsIssued = 1 ");
            DataTable dt2 = StockReports.GetDataTable(sb4.ToString());
            if (dt2.Rows.Count > 0)
            {
                lblMsg.Text = "File Already Issued In IPD";
                return;
            }
            StringBuilder sb5 = new StringBuilder();
            sb5.Append("SELECT *  FROM mrd_opd_fileStatus where PatientID='" + lblIssuePatientID.Text + "' and isreturn=0");
            DataTable dt3 = StockReports.GetDataTable(sb5.ToString());
            if (dt3.Rows.Count > 0)
            {
                lblMsg.Text = "File is Already Issued";
                return;
            }

            StringBuilder sb2 = new StringBuilder();
            sb2.Append("SELECT MAX(entdate)entdate FROM mrd_file_master where PatientID='" + lblIssuePatientID.Text + "'");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    lblDate.Text = Util.GetDateTime(dt.Rows[j]["EntDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                }
            }

            StringBuilder sb3 = new StringBuilder();
            sb3.Append("SELECT * FROM mrd_file_master where PatientID='" + lblIssuePatientID.Text + "'and entdate='" + lblDate.Text + "'");
            DataTable dt1 = StockReports.GetDataTable(sb3.ToString());
            if (dt1.Rows.Count > 0)
            {
                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    lbltran.Text = Util.GetString(dt1.Rows[j]["TransactionID"].ToString());
                }
            }
            lblIssuePatientName.Text = ((Label)row.FindControl("lblPatientName")).Text.ToString();
            lblAppID.Text = ((Label)row.FindControl("lblAppID")).Text.ToString();
            txtIssueDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            DateTime con = Util.GetDateTime(((Label)row.FindControl("lblConfirmdate")).Text.ToString());
            calIssueDate.StartDate = Util.GetDateTime(con.ToString());
            mpopIssue.Show();
        }
        if (e.CommandName.ToString() == "FileReturn")
        {
            int index = Util.GetInt(e.CommandArgument.ToString());
            GridViewRow row = grdMRD.Rows[index];
            lblReturnPatientID.Text = ((Label)row.FindControl("lblMRNo")).Text.ToString();
            StringBuilder sb2 = new StringBuilder();
            sb2.Append("SELECT MAX(entdate)entdate FROM mrd_file_master where PatientID='" + lblReturnPatientID.Text + "'");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    lblDate.Text = Util.GetDateTime(dt.Rows[j]["EntDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                }
            }

            StringBuilder sb3 = new StringBuilder();
            sb3.Append("SELECT * FROM mrd_file_master where PatientID='" + lblReturnPatientID.Text + "'and entdate='" + lblDate.Text + "'");
            DataTable dt1 = StockReports.GetDataTable(sb3.ToString());
            if (dt1.Rows.Count > 0)
            {
                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    lbltran.Text = Util.GetString(dt1.Rows[j]["TransactionID"].ToString());
                }
            }

            StringBuilder sb4 = new StringBuilder();
            sb4.Append("SELECT mam.Name Rackname,mrm.Name RoomName,mfm.rmid,mfm.almid,shelfno ,mfm.visittype FROM mrd_file_master mfm INNER JOIN mrd_room_master mrm ON mrm.RmID=mfm.RmID INNER JOIN mrd_almirah_master mam ON mfm.AlmID=mam.AlmID  WHERE PatientID='" + lblReturnPatientID.Text + "'and TransactionID='" + lbltran.Text + "'");
            DataTable dt4 = StockReports.GetDataTable(sb4.ToString());
            if (dt4.Rows.Count > 0)
            {
                for (int j = 0; j < dt4.Rows.Count; j++)
                {
                    if (dt4.Rows[j]["visittype"].ToString() == "Old Patient")
                    {
                        cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dt4.Rows[0]["RmID"].ToString()));
                        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
                        cmbAlmirah.SelectedIndex = cmbAlmirah.Items.IndexOf(cmbAlmirah.Items.FindByValue(dt4.Rows[0]["AlmID"].ToString()));
                        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
                        cmbShelf.SelectedIndex = cmbShelf.Items.IndexOf(cmbShelf.Items.FindByValue(dt4.Rows[0]["ShelfNo"].ToString()));
                    }
                }
            }
            lblReturnPatientName.Text = ((Label)row.FindControl("lblPatientName")).Text.ToString();
            lbltran.Text = ((Label)row.FindControl("lblTransactionid")).Text.ToString();
            lblvisittype.Text = ((Label)row.FindControl("lblvisit")).Text.ToString();
            lblAppIDReturn.Text = ((Label)row.FindControl("lblAppID")).Text.ToString();
            txtReturnDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calReturn.StartDate = Issuedate(lblReturnPatientID.Text, lblAppIDReturn.Text);
            mpopReturn.Show();
        }
        if (e.CommandName == "AViewDetail")
        {
            StringBuilder sb1 = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            string PatientID = Util.GetString(e.CommandArgument).Split('#')[0];
            string App_ID = Util.GetString(e.CommandArgument).Split('#')[1];
            sb1.Append("SELECT DATE_FORMAT(issuedate,'%d-%b-%y')IssueDate ,issueremarks,DATE_FORMAT(returndate,'%d-%b-%y')Returndate,return_remarks FROM mrd_opd_fileStatus WHERE PatientID='" + PatientID + "' AND appointmentid='" + App_ID + "'");
            DataTable dtnew = StockReports.GetDataTable(sb1.ToString());
            sb2.Append("SELECT mam.Name Rackname,mrm.Name RoomName,mfm.rmid,mfm.almid,shelfno ,mfm.visittype FROM mrd_file_master mfm INNER JOIN mrd_room_master mrm ON mrm.RmID=mfm.RmID INNER JOIN mrd_almirah_master mam ON mfm.AlmID=mam.AlmID  WHERE PatientID='" + PatientID + "'");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if (dt.Rows[j]["visittype"].ToString() == "Old Patient")
                    {
                        cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dt.Rows[0]["RmID"].ToString()));
                        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
                        cmbAlmirah.SelectedIndex = cmbAlmirah.Items.IndexOf(cmbAlmirah.Items.FindByValue(dt.Rows[0]["AlmID"].ToString()));
                        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
                        cmbShelf.SelectedIndex = cmbShelf.Items.IndexOf(cmbShelf.Items.FindByValue(dt.Rows[0]["ShelfNo"].ToString()));
                        lblRoom.Visible = true;
                        lblRack.Visible = true;
                        lblshelf.Visible = true;
                        lblRoomno.Text = Util.GetString(dt.Rows[j]["RoomName"].ToString());
                        lblRackno.Text = Util.GetString(dt.Rows[j]["Rackname"].ToString());
                        lblShelfNo.Text = Util.GetString(dt.Rows[j]["shelfno"].ToString());
                    }
                    else if (dt.Rows[j]["visittype"].ToString() == "New Patient")
                    {
                        lblRoom.Visible = true;
                        lblRack.Visible = true;
                        lblshelf.Visible = true;
                        lblRoomno.Text = Util.GetString(dt.Rows[j]["RoomName"].ToString());
                        lblRackno.Text = Util.GetString(dt.Rows[j]["Rackname"].ToString());
                        lblShelfNo.Text = Util.GetString(dt.Rows[j]["shelfno"].ToString());
                    }
                }
            }
            for (int i = 0; i < dtnew.Rows.Count; i++)
            {
                lblIssueDate.Text = Util.GetString(dtnew.Rows[i]["IssueDate"].ToString());
                lblIssueRemarks.Text = Util.GetString(dtnew.Rows[i]["issueremarks"].ToString());
                lblReturnDate.Text = Util.GetString(dtnew.Rows[i]["Returndate"].ToString());
                lblReturnRemarks.Text = Util.GetString(dtnew.Rows[i]["return_remarks"].ToString());
            }

            mpe2.Show();
        }
    }

    public DateTime Issuedate(string Patientid, string AppID)
    {
        DateTime str = Util.GetDateTime(StockReports.ExecuteScalar("select IssueDate from mrd_opd_filestatus where PatientID='" + Patientid.ToString() + "' AND AppointmentID='" + AppID.ToString() + "' ").ToString());
        return str;
    }

    protected void grdMRD_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblIssueStatus")).Text.ToUpper() == "TRUE")
            {
                ((Button)e.Row.FindControl("btnFileReturn")).Enabled = false;
                ((Button)e.Row.FindControl("btnFileIssue")).Enabled = true;
            }
            else
            {
                e.Row.Attributes.Add("style", "background-color:lightgreen");
                ((Button)e.Row.FindControl("btnFileReturn")).Enabled = true;
                ((Button)e.Row.FindControl("btnFileIssue")).Enabled = false;
            }
            if (((Label)e.Row.FindControl("lblIssueStatus")).Text.ToUpper() == "FALSE" && ((Label)e.Row.FindControl("lblReturnStatus")).Text.ToUpper() == "FALSE")
            {
                e.Row.Attributes.Add("style", "background-color:lightpink");
                ((Button)e.Row.FindControl("btnFileReturn")).Enabled = false;
                ((Button)e.Row.FindControl("btnFileIssue")).Enabled = false;
            }
            
        }
    }

    public void BindShelf(string AlmID)
    {
        if (AlmID.ToString() != "Select")
        {
            string sql = " select distinct ShelfNo,CONCAT(ShelfNo,'$',IFNULL(CurPos,0)+1)ID from mrd_location_master  where AlmID = '" + AlmID + "' and  MaxPos > (CurPos+AdditionalNo) order by ShelfNo ";
            DataTable dt = StockReports.GetDataTable(sql);

            if (dt != null && dt.Rows.Count > 0)
            {
                cmbShelf.DataSource = dt;
                cmbShelf.DataTextField = "ShelfNo";
                cmbShelf.DataValueField = "ID";
                cmbShelf.DataBind();
                cmbShelf.Items.Insert(0, "Select");
                lblCounter.Text = Util.GetString(dt.Rows[0]["ID"]).Split('$')[1];
            }
            else
            {
                cmbShelf.DataSource = null;
                cmbShelf.DataBind();
                cmbShelf.SelectedIndex = -1;
                cmbShelf.Items.Clear();
                lblCounter.Text = "";
                cmbShelf.Items.Insert(0, "No Shelf Available");
            }
        }
    }

    public void BindAlmirah(string RmID)
    {
        string sql = " select distinct lm.AlmID, am.Name from mrd_location_master lm inner join  mrd_almirah_master am on am.AlmID=lm.AlmID where lm.MaxPos >= (CurPos+AdditionalNo) and am.RmID='" + RmID + "' order by am.Name ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            cmbAlmirah.DataSource = dt;
            cmbAlmirah.DataTextField = "Name";
            cmbAlmirah.DataValueField = "AlmID";
            cmbAlmirah.DataBind();
            cmbAlmirah.Items.Insert(0, "Select");
            //BindShelf(Util.GetString(dt.Rows[0]["AlmID"]));
        }
        else
        {
            cmbAlmirah.DataSource = null;
            cmbAlmirah.DataBind();
            cmbShelf.SelectedIndex = -1;
            cmbAlmirah.SelectedIndex = -1;
            cmbAlmirah.Controls.Clear();
            cmbAlmirah.Items.Clear();
            cmbShelf.Items.Clear();
            cmbShelf.Controls.Clear();
            cmbShelf.DataSource = null;
            cmbShelf.DataBind();
            lblCounter.Text = "";
            // cmbAlmirah.Items.Insert(0, "Select");
            // cmbShelf.Items.Insert(0, "Select");
        }
    }

    protected void cmbAlmirah_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
        lblReturn.Text = "";
        // ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + cmbAlmirah.ClientID + "';", true);
    }

    protected void cmbRoom_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
        lblReturn.Text = "";
        // ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + cmbRoom.ClientID + "';", true);
    }

    protected void cmbShelf_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblCounter.Text = Util.GetString(cmbShelf.SelectedItem.Value).Split('$')[1];
        lblReturn.Text = "";
        // ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + cmbShelf.ClientID + "';", true);
    }

    protected void btnIssueSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string TID = lbltran.Text;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            if (TID != "")
            {
                StringBuilder sb3 = new StringBuilder();
                sb3.Append("SELECT * FROM mrd_file_master where TransactionID='" + TID + "'");
                DataTable dt1 = StockReports.GetDataTable(sb3.ToString());
                if (dt1.Rows.Count > 0)
                {
                    for (int j = 0; j < dt1.Rows.Count; j++)
                    {
                        lblissueroomno.Text = Util.GetString(dt1.Rows[j]["Rmid"].ToString());
                        lblissuerackno.Text = Util.GetString(dt1.Rows[j]["Almid"].ToString());
                        lblissueshelno.Text = Util.GetString(dt1.Rows[j]["Shelfno"].ToString());
                    }
                }

                string sql = "";
                sql = " update mrd_location_master set CurPos=CurPos -1 where RmID='" + lblissueroomno.Text + "' and AlmID='" + lblissuerackno.Text + "' and ShelfNo='" + lblissueshelno.Text.Split('$')[0] + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            if (txtIssueDate.Text != "" && txtIssueRemarks.Text.Trim() != "")
            {
                string sql = "Insert into  mrd_opd_fileStatus(PatientID,AppointmentID,Issue_By,IssueDate,IsIssue,IssueRemarks)values('" + lblIssuePatientID.Text + "','" + lblAppID.Text + "','" + Session["ID"].ToString() + "','" + Util.GetDateTime(txtIssueDate.Text).ToString("yyyy-MM-dd") + "',1,'" + txtIssueRemarks.Text.Trim() + "') ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else
            {
                lblIssue.Text = "Please Enter Issue Remarks";
                mpopIssue.Show();
                return;
            }
            tnx.Commit();
            SearchGrid();
            txtIssueRemarks.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            con.Close();
            con.Dispose();
            tnx.Dispose();
        }
    }

    protected void btnReturnSave_Click(object sender, EventArgs e)
    {
        lblReturn.Text = "";
        if (cmbRoom.SelectedItem.Text == "Select")
        {
            lblReturn.Text = "Please Select room";
            mpopReturn.Show();
            return;
        }
        else if (cmbAlmirah.SelectedItem.Text == "Select")
        {
            lblReturn.Text = "Please Select Rack";
            mpopReturn.Show();
            return;
        }
        else if (cmbShelf.SelectedItem.Text == "Select")
        {
            lblReturn.Text = "Please Select Shelf";
            mpopReturn.Show();
            return;
        }
        else if (cmbShelf.SelectedItem.Text == "No Shelf Available")
        {
            lblReturn.Text = "No Shelf Available under This Rack";
            mpopReturn.Show();
            return;
        }

        DataTable dt = (DataTable)ViewState["dt"];
        string TID = lbltran.Text;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            if (lblFileNo.Text.Trim().ToString() == "")
            {
                string BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from f_ledgertransaction where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");

                string sql = "insert into mrd_file_master(PatientID, TransactionID, " +
                              "  RmID, AlmID, ShelfNo, CurPos, Narration, UserID,VisitType ) " +
                              " values('" + lblReturnPatientID.Text + "', '" + TID + "', " +
                              "  '" + cmbRoom.SelectedItem.Value + "', '" + cmbAlmirah.SelectedItem.Value + "', '" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', '" + lblCounter.Text.Trim() + "', '" + txtReturnRemarks.Text.Trim() + "', '" + ViewState["ID"].ToString() + "','" + lblvisittype.Text + "') ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                string FileID = "";
                if (ddlFileNo.Visible != true)
                {
                    sql = "select FileID from mrd_file_master where TransactionID ='" + TID + "' order by fileid desc";
                    FileID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));
                }
                else
                {
                    FileID = ddlFileNo.SelectedItem.Value.ToString();
                }

                if (FileID == null || FileID == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblReturn.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo";
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                if (count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM125','" + lblReturn.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }
                sql = " update mrd_location_master set CurPos=CurPos +1  where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else
            {
                string BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from f_ledgertransaction where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");

                string sql = "update mrd_file_master set PatientID='" + Util.GetString(dt.Rows[0]["PatientID"]) + "', TransactionID= '" + TID + "', BillNo= '" + Util.GetString(dt.Rows[0]["BillNo"]) + "',BillDate='" + BillDate + "',  DischargeDateTime='" + Util.GetDateTime(Util.GetString(dt.Rows[0]["DateOfDischarge"])).ToString("yyyy-MM-dd") + "', " +
                              "  RmID= '" + cmbRoom.SelectedItem.Value + "', AlmID='" + cmbAlmirah.SelectedItem.Value + "', ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', CurPos='" + lblCounter.Text.Trim() + "', Narration='" + txtReturnRemarks.Text.Trim() + "', UserID='" + ViewState["ID"] + "' where   FileID='" + lblFileNo.Text.Trim().ToString() + "' ";

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo";
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                if (count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM125','" + lblReturn.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                sql = " update mrd_location_master set CurPos=CurPos +1 where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }

            lblReturn.Text = "";

            if (txtReturnDate.Text != "" && txtReturnRemarks.Text.Trim() != "")
            {
                string sql = "update  mrd_opd_fileStatus set Return_To='" + Session["ID"].ToString() + "',ReturnDate='" + Util.GetDateTime(txtReturnDate.Text).ToString("yyyy-MM-dd") + "',IsReturn=1,Return_Remarks='" + txtReturnRemarks.Text.Trim() + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else
            {
                lblReturn.Text = "Please Enter Return Remarks";
                mpopReturn.Show();
                return;
            }
            tnx.Commit();
            SearchGrid();
            txtReturnRemarks.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            con.Close();
            con.Dispose();
            tnx.Dispose();
        }
    }

    protected void timer1_Tick(object sender, EventArgs e)
    {
        EventArgs abc = new EventArgs();

        btnSearch_Click1(this, abc);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int Count = 0;
        if (grdPatient.Rows.Count > 0)
        {
            for (int i = 0; i < grdPatient.Rows.Count; i++)
            {
                if (((CheckBox)grdPatient.Rows[i].FindControl("chkBox")).Checked == true)
                {
                    Count = 1;

                   string z = StockReports.getTransactionIDbyTransNo(((Label)grdPatient.Rows[i].FindControl("lblTransactionID")).Text);
                   StockReports.ExecuteDML(" Update patient_medical_history Set MRD_IsFile=1,ReceiveFile_By='" + Session["LoginName"].ToString() + "',ReceiveFile_Date='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where TransactionID=" + ((Label)grdPatient.Rows[i].FindControl("lbl2")).Text + "");
                }
            }
            if (Count == 1)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Update Successfully', function(){});", true);
                SearchGrid();
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dtReport = (DataTable)ViewState["dt"];
        if (dtReport.Rows.Count > 0)
        {
            if (dtReport.Columns.Contains("ReferenceCode"))
                dtReport.Columns.Remove("ReferenceCode");
            if (dtReport.Columns.Contains("PanelID"))
                dtReport.Columns.Remove("PanelID");
            if (dtReport.Columns.Contains("IPDCaseType_ID"))
                dtReport.Columns.Remove("IPDCaseType_ID");
            if (dtReport.Columns.Contains("ScheduleChargeID"))
                dtReport.Columns.Remove("ScheduleChargeID");
            if (dtReport.Columns.Contains("MRD_IsFile"))
                dtReport.Columns.Remove("MRD_IsFile");
            if (dtReport.Columns.Contains("IsBilledClosed"))
                dtReport.Columns.Remove("IsBilledClosed");
            if (dtReport.Columns.Contains("SmsStatus"))
                dtReport.Columns.Remove("SmsStatus");
            if (dtReport.Columns.Contains("KinRelation"))
                dtReport.Columns.Remove("KinRelation");
            if (dtReport.Columns.Contains("Age"))
                dtReport.Columns.Remove("Age");

            if (dtReport.Columns.Contains("PatientID"))
            {
                dtReport.Columns["PatientID"].ColumnName = "UHID";
                dtReport.Columns["PName"].ColumnName = "Patient Name";
                dtReport.Columns["Mobile"].ColumnName = "Contact No.";
                dtReport.Columns["Company_Name"].ColumnName = "Panel Name";
                //dtReport.Columns["BillingCategory"].ColumnName = "";
                dtReport.Columns["AdmitDate"].ColumnName = "Admit Date & Time";
                dtReport.Columns["DischargeDate"].ColumnName = "Discharge Date & Time";
                dtReport.Columns["DName"].ColumnName = "Doctor Name";
                dtReport.Columns["RName"].ColumnName = "Room Type";
                dtReport.Columns["AgeSex"].ColumnName = "Age / Sex";
                //dtReport.Columns["RoomName"].ColumnName = "Room Name";
                // dtReport.Columns["PayStatus"].ColumnName = "Pay Status";
                dtReport.Columns["BillNo"].ColumnName = "Bill No.";
                //  dtReport.Columns["RelationName"].ColumnName = "Relation Name";
                dtReport.Columns["DaysAfterDischarge"].ColumnName = "Day & Time After Discharge";
                dtReport.Columns["DischargeType"].ColumnName = "Discharge Type";
                dtReport.Columns["StayDays"].ColumnName = "Stay Days & Time";
                dtReport.Columns["BillStatus"].ColumnName = "Bill Status";
                dtReport.Columns["AdmittedBy"].ColumnName = "Admitted By";
                dtReport.Columns["LoginType"].ColumnName = "Login Type";
                dtReport.Columns["ReceiveFile_Date"].ColumnName = "Receive Date & Time";
            }
            else
                dtReport.Columns["UHID"].ColumnName = "UHID";
            if (dtReport.Columns.Contains("TransactionID"))
                dtReport.Columns["TransactionID"].ColumnName = "IPD No.";
            else
                dtReport.Columns["IPD No."].ColumnName = "IPD No.";
            //dtReport.AcceptChanges();

            Session["dtExport2Excel"] = dtReport;
            Session["ReportName"] = "MRD Patient List";
            Session["Period"] = "From " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
    }

}