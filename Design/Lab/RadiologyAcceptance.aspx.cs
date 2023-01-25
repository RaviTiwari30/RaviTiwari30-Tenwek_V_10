using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web;
using System.Drawing;
using System.Web;
using System.Web.Script.Services;

public partial class Design_Lab_RadiologyAcceptance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtNotificationDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtNotificationTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            All_LoadData.bindPanel(ddlPanel, "All");
            ViewState["CentreID"] = StockReports.GetDataTable("Select CentreID , CentreName from Center_master where isactive=1 and CentreID<>" + Util.GetInt(Session["CentreID"].ToString()) + " ");
            AuthorisedUser(Session["ID"].ToString(), Session["RoleID"].ToString());
            BindLabDepartment();
            bindRoomList();
        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
        txtNotificationDate.Attributes.Add("readonly", "true");
        ccNotifiDate.StartDate = System.DateTime.Now;
    }

    protected void bindRoomList()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT id,roomName FROM sampleCollectionRoomMaster WHERE isActive=1 and roleid =" + Util.GetInt(ViewState["RoleDept"]) + " ORDER BY roomName  ");
        if (dt.Rows.Count > 0)
        {
            ddlRoomName.DataSource = dt;
            ddlRoomName.DataTextField = "roomName";
            ddlRoomName.DataValueField = "id";
            ddlRoomName.DataBind();
        }
        ddlRoomName.Items.Insert(0, new ListItem("", "0"));

    }

    private void BindLabDepartment()
    {
        DataTable dt = AllLoadData_OPD.BindLabRadioDepartment(HttpContext.Current.Session["RoleID"].ToString());
        if (dt != null)
        {
            if (dt.Rows.Count > 0)
            {
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "Name";
                ddlDepartment.DataValueField = "ObservationType_ID";
                ddlDepartment.DataBind();
                ddlDepartment.Items.Insert(0, new ListItem("ALL", "0"));
            }
        }
    }
    private void AuthorisedUser(string EmpID, string RoleID)
    {
        btnRemoveTest.Visible = false;
        if (All_LoadData.GetAuthorization(Util.GetInt(RoleID), EmpID, "IsLabReject") == "1" && (rbtSample.SelectedItem.Text.ToUpper() == "NO" || rbtSample.SelectedItem.Text.ToUpper() == "YES"))
            btnRemoveTest.Visible = true;
        else
            btnRemoveTest.Visible = false;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
        AuthorisedUser(ViewState["EmpID"].ToString(), ViewState["RoleDept"].ToString());
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindTestToForward(string testid)
    {
        testid = "'" + testid + "'";
        testid = testid.Replace(",", "','");
        //DataTable dt = StockReports.GetDataTable(" select im.name,plo.test_id from patient_labinvestigation_opd plo  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` and plo.test_id in(" + testid + ") ");
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
        //sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
        //sbQuery.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=fl.`EmployeeID` ");
        //sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
        //sbQuery.Append("  WHERE centreid=" + centre + " and fl.employeeid<>'" + HttpContext.Current.Session["ID"].ToString() + "' ");
        sbQuery.Append(" SELECT DISTINCT em.EmployeeID as employeeid,em.NAME as Name FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID "+
            " INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID IN (11,104)  " +
            " AND fl.`CentreID`='" + HttpContext.Current.Session["CentreID"].ToString() + "' ORDER BY NAME");
        
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
            int n=MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=@ForwardDate,ForwardToCentre=@ForwardToCentre,ForwardToDoctor=@ForwardToDoctor WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
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

    private void Search()
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        string RoleDept = ViewState["RoleDept"].ToString();

        sb.Append("SELECT  ltd.ID LtdId,CASE    WHEN pli.IsPortable ='1' THEN 'Portable'    ELSE 'Not Portable' END as Text, CASE    WHEN pli.IsPortable ='1' THEN 'blinking'    ELSE '' END as Portable,fpm.Company_Name,otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,UPPER(PM.pname)pname,CONCAT(pm.age,'/',Date_Format(pm.DOB,'%d-%b-%Y'))age,pm.gender, ");
            sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.technician, ");
            sb.Append("pli.Test_ID,pli.LedgerTransactionNo,im.Name , ");
            sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,DATE_FORMAT(pli.date,'%d-%b-%y')InDate,Time_Format(pli.Time,'%I:%i %p')Time, ");
            sb.Append("PLI.ID,pli.SampleReceiveDate, (CASE WHEN pli.Type=1 THEN 'OPD' WHEN pli.Type=2 THEN 'IPD' ELSE 'Emergency' END) AS EntryType,ifnull(pli.LedgerTnxID,'')LedgerTnxID, IFNULL(( ");
            sb.Append("       SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
            sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
            sb.Append("       ) LIMIT 1 ");
            sb.Append("),0) IsRefund,IF(rn.ID IS NULL,0,1)isnotificationsent,IFNULL(DATE_FORMAT(rn.NotificationDate,'%d-%b-%Y'),'')NotificationDate,IFNULL(TIME_FORMAT(rn.NotificationTime,'%I:%i %p'),'')NotificationTime ");
            sb.Append(" ,pli.isTransfer,pli.sampleTransferCentreID,pli.P_IN,pli.P_Out,IF(pli.P_Out = 0,'style=display:none','style=display:block')con,getCRDRAgainstLedgerTnxID(pli.LedgertnxID) vIsRemoveCRDREntry  ,CONCAT(dm.Title,' ',dm.Name)DoctorName,ltd.`TokenNo`,ltd.`TokenCallStatus` 'CallStatus', ");
            sb.Append("IF((pli.Type=1 AND lt.IsPaymentApproval=0),(lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' ");
            sb.Append("AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa ");
            sb.Append("WHERE pa.TransactionID=pli.TransactionID),0)),0)Pendingcheck, ");

            sb.Append(" IF(pli.Type=1, IF(lt.PanelId=1,IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            sb.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1, ");
            sb.Append(" IF(IFNULL(lt.Adjustment,0) < IFNULL(lt.NetAmount,0),0,1)), ");
            sb.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            sb.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1, ");
            sb.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            sb.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=1)=1, ");
            sb.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            sb.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=0)=1,1,0) ");
            sb.Append(" ,IF(IFNULL(lt.Adjustment,0)<IFNULL((SELECT  pmh.PatientPaybleAmt FROM patient_medical_history pmh  ");
            sb.Append(" WHERE pmh.TransactionID=lt.TransactionId),0),0,1)) )  ) ,1 )IsPaymentApproved,  ");

            sb.Append("IF(pli.Type=1, IF(lt.PanelId=1,IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            sb.Append("  WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1,  ");
            sb.Append(" IF(IFNULL(lt.Adjustment,0) < IFNULL(lt.NetAmount,0),CONCAT('Please Make a Payment of Rs ',(IFNULL(lt.NetAmount,0)-IFNULL(lt.Adjustment,0))),1)),  ");
            sb.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            sb.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1,  ");
            sb.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            sb.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=1)=1,  ");
            sb.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            sb.Append("  WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=0)=1,1,'Pending Approval')  ");
            sb.Append("  ,IF(IFNULL(lt.Adjustment,0)<IFNULL((SELECT  pmh.PatientPaybleAmt FROM patient_medical_history pmh   ");
            sb.Append("  WHERE pmh.TransactionID=lt.TransactionId),0),CONCAT('Please Make a Payment of Rs ',IFNULL((SELECT  pmh.PatientPaybleAmt FROM patient_medical_history pmh   ");
            sb.Append("  WHERE pmh.TransactionID=lt.TransactionId),0)),1))) ) ,'' )PendingApprovalMessage   ");
          

            sb.Append(" FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=pli.LedgertnxID ");
            sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
			 sb.Append("  INNER JOIN  doctor_master dm ON dm.DoctorID=pmh.DoctorID  ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
            sb.Append(" INNER JOIN patient_master PM ON pmh.PatientID = PM.PatientID  INNER JOIN investigation_master im ");
            sb.Append(" ON pli.Investigation_ID = im.Investigation_Id INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=pli.LedgertransactionNo ");
            sb.Append("INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
            sb.Append("INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
            sb.Append("LEFT JOIN radiology_accepatance_notification rn ON pli.Test_ID =rn.TestID AND rn.IsActive=1 ");
	    sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = iom.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
            sb.Append(" where im.ReportType='5' AND  pli.sampleTransferCentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " AND IF(pli.Type=1 AND lt.PaymentModeID=1,lt.NetAmount<=lt.Adjustment,1=1) ");
            sb.Append(" AND ltd.`ItemID` NOT IN (SELECT fd.`ItemID` FROM f_drcrnote fd WHERE fd.`TransactionID`=ltd.`TransactionID`) ");
      
			//ltd.IsVerified<>2 and
			
            if (rbtSample.SelectedValue == "SY")
                sb.Append(" AND pli.P_IN = 0 AND pli.IsSampleCollected<>'R' ");
            else if (rbtSample.SelectedValue == "Y")
                sb.Append(" AND pli.P_IN = 1 AND pli.IsSampleCollected<>'R' ");
            else if(rbtSample.SelectedValue == "R")
                sb.Append(" AND pli.IsSampleCollected='R' ");
            if (ddlDepartment.SelectedValue != "0")
            {
                sb.Append(" AND otm.ObservationType_ID='" + ddlDepartment.SelectedValue + "' ");
            }
            if (rdbLabType.SelectedValue != "0")
            {
                if(rdbLabType.SelectedValue=="1")
                    sb.Append(" and pli.Type=1 ");
                else if (rdbLabType.SelectedValue == "2")
                    sb.Append(" and pli.Type=2 ");
                else if(rdbLabType.SelectedValue == "3")
                    sb.Append(" and pli.Type=3 ");
            }
            if (txtMRNo.Text != string.Empty)
            {
                sb.Append(" and pm.PatientID='" + Util.GetFullPatientID(txtMRNo.Text.Trim()) + "'");
            }
            else if (txtCRNo.Text != string.Empty)
            {
                if (rdbLabType.SelectedValue != "OPD")
                {
                    sb.Append(" and pmh.TransactionID='ISHHI" + txtCRNo.Text.Trim() + "'");
                }
            }

        if (ddlPanel.SelectedIndex > 0)
            sb.Append(" AND fpm.PanelID=" + ddlPanel.SelectedValue + " ");

        if (txtPName.Text != string.Empty)
            sb.Append(" and PM.PName like '" + txtPName.Text.Trim() + "%'");

        if (FrmDate.Text != string.Empty)
            sb.Append(" and if(pli.isTransfer=1,DATE(pli.sampleTransferDate),PLI.Date) >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

        if (ToDate.Text != string.Empty)
            sb.Append(" and if(pli.isTransfer=1,DATE(pli.sampleTransferDate),PLI.Date) <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND IFNULL(TRIM(LOWER(IFNULL(ltd.`TokenRoomName`,''))),'')='" + ddlRoomName.SelectedItem.Text.ToLower().Trim() + "' ");
        sb.Append(" order by PLI.ID Desc ");


//System.IO.File.WriteAllText (@"E:\aa.txt", sb.ToString());


        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            if (rbtSample.SelectedItem.Value == "SY")
            {
                btnCall.Visible = btnUnCall.Visible = true;
            }
            else
            {
                btnCall.Visible = btnUnCall.Visible = false;
            }
            btnRemoveTest.Visible = true;
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            ViewState["dtInvest"] = dtInvest;

            grdLabSearch.DataSource = dtInvest;
            grdLabSearch.DataBind();
            pnlHide.Visible = true;
            btnSave.Visible = true;
        }
        else
        {
            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
            pnlHide.Visible = false;
            btnSave.Visible = false;
            lblMsg.Text = "Record not found.";
            btnCall.Visible = btnUnCall.Visible = btnRemoveTest.Visible = false;

        }
    }

    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //string str = "Select CentreID , CentreName from Center_master where isactive=1 and CentreID<>" + Util.GetInt(Session["CentreID"].ToString()) + " ";
            DataTable dt = (DataTable)ViewState["CentreID"];
            if (dt.Rows.Count > 0)
            {
                DropDownList ddlList = (DropDownList)e.Row.FindControl("ddlTransferCentre");
                ddlList.DataSource = dt;
                ddlList.DataTextField = "CentreName";
                ddlList.DataValueField = "CentreID";
                ddlList.DataBind();
                ddlList.Items.Insert(0, new ListItem("--Select--", "0"));
            }
            CheckBox cbSample = (CheckBox)e.Row.FindControl("chkSampleCollect");
            if (Util.GetInt(((Label)e.Row.FindControl("lblCallStatus")).Text) == 1 || Util.GetInt(((Label)e.Row.FindControl("lblCallStatus")).Text) == 3)
            {

                cbSample.Checked = true;
                cbSample.Visible = true;

            }
            else
            {
                cbSample.Checked = false;
                cbSample.Visible = false;

            }
            CheckBox cbCall = (CheckBox)e.Row.FindControl("chkCallUncall");
            if (Util.GetInt(((Label)e.Row.FindControl("lblCallStatus")).Text) == 3)
            {

                cbCall.Checked = false;
                cbCall.Visible = false;

            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true")
                e.Row.CssClass = "GridViewResultItemStyle";
            if (((Label)e.Row.FindControl("lblEntryType")).Text != "IPD")
                ((Label)e.Row.FindControl("lblTransactionID")).Style.Add("display", "none");
            if (rbtSample.SelectedValue == "SY")
            {
                if (((Label)e.Row.FindControl("lblEntryType")).Text == "IPD")
                {
                    if (((Label)e.Row.FindControl("lblIsNotificationSent")).Text == "1")
                    {
                        ((ImageButton)e.Row.FindControl("imgNotification")).Style.Add("display", "none");
                        ((ImageButton)e.Row.FindControl("imgNotificationSent")).Style.Add("display", "block");
                         }
                        ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "block");
                        ((CheckBox)e.Row.FindControl("chkTransfer")).Style.Add("display", "block");
                  
                }
                else
                {
                    ((ImageButton)e.Row.FindControl("imgNotification")).Style.Add("display", "none");
                    ((ImageButton)e.Row.FindControl("imgNotificationSent")).Style.Add("display", "none");
                    ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "block");
                    ((CheckBox)e.Row.FindControl("chkTransfer")).Style.Add("display", "block");
                }
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgNotification")).Style.Add("display", "none");
                ((ImageButton)e.Row.FindControl("imgNotificationSent")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkTransfer")).Style.Add("display", "none");
            }
            e.Row.BackColor = System.Drawing.Color.FromArgb(204, 153, 255);

            if (Util.GetInt(((Label)e.Row.FindControl("lblCallStatus")).Text) == 1)
            {
                e.Row.BackColor = System.Drawing.Color.FromArgb(188, 193, 132);

            }
            if (Util.GetInt(((Label)e.Row.FindControl("lblCallStatus")).Text) == 2)
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;


            }

            if (((Label)e.Row.FindControl("lblP_IN")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
                ((CheckBox)e.Row.FindControl("chkPout")).Style.Add("display", "block");
                //((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "none");
               // ((ImageButton)e.Row.FindControl("imgcon")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lblP_Out")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.FromArgb(144, 238, 144);
                ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkPout")).Style.Add("display", "none");
              //  ((ImageButton)e.Row.FindControl("imgcon")).Visible = true;
            }
            if (rbtSample.SelectedValue == "R")
            {
                e.Row.BackColor = System.Drawing.Color.Red;
                ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkPout")).Style.Add("display", "none");
            }
            if (((Label)e.Row.FindControl("lblIsRemoveCRDREntry")).Text == "1") {
                ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkPout")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkTransfer")).Style.Add("display", "none");
                ((ImageButton)e.Row.FindControl("imgNotificationSent")).Style.Add("display", "none");
            }
            //
            if (((Label)e.Row.FindControl("lblPendingcheck")).Text == "0") {
                ((CheckBox)e.Row.FindControl("chkSampleCollect")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkPout")).Style.Add("display", "none");
                ((CheckBox)e.Row.FindControl("chkTransfer")).Style.Add("display", "none");
                ((ImageButton)e.Row.FindControl("imgNotificationSent")).Style.Add("display", "none");
              ///  ((CheckBox)e.Row.FindControl("chkCallUncall")).Style.Add("display", "none");
                //
            }

        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        int IsSelected = 0,IsSelectTransfer=0;
        for (int i = 0; i < grdLabSearch.Rows.Count; i++)
        {
            if (((CheckBox)grdLabSearch.Rows[i].FindControl("chkSampleCollect")).Checked)
                IsSelected = 1;
            if (((CheckBox)grdLabSearch.Rows[i].FindControl("chkTransfer")).Checked)
                IsSelectTransfer = 1;
            if (((CheckBox)grdLabSearch.Rows[i].FindControl("chkPout")).Checked)
                IsSelected = 1;
        }

        if (IsSelected == 0 && IsSelectTransfer==0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "KeySrejct", "modelAlert('Kindly Select Atleast one Record');", true);
            return;
        }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            string sql = "";
            foreach (GridViewRow gr in grdLabSearch.Rows)
            {
                // Test Acceptance
                if (((CheckBox)gr.FindControl("chkSampleCollect")).Checked)
                {
                    string EntryType = ((Label)gr.FindControl("lblEntryType")).Text;
                    string ID = ((Label)gr.FindControl("lblID")).Text;
                    
                    sql = "Update patient_labinvestigation_opd Set P_IN=1,P_INByID='" + ViewState["EmpID"].ToString() + "',P_INByName='" + ViewState["EmpName"].ToString() + "',P_InDateTime=NOW(),IsSampleCollected = 'Y',SampleReceiveDate='" + DateTime.Now.ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:ss") + "',SampleReceivedBy='" + ViewState["EmpName"].ToString() + "',SampleReceiver='" + ViewState["EmpID"].ToString() + "' Where ID = " + ID;
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                    string str = "UPDATE radiology_accepatance_notification SET IsActive = 0 WHERE TestID='" + ((Label)gr.FindControl("lblTestId")).Text + "'";

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    string currentTokenNo = ((Label)gr.FindControl("lblTokenNo")).Text;
                   ExcuteCMD cmd = new ExcuteCMD();
                   cmd.DML(tnx, "UPDATE  `f_ledgertnxdetail` ltd INNER JOIN `f_subcategorymaster` sm ON ltd.`SubcategoryID`=sm.`SubCategoryID` SET ltd.`TokenCallStatus`=3 WHERE ltd.`TokenNo`=@tokenNo AND ltd.`LedgerTransactionNo`=@LtnxNo And ltd.Id=@Id AND sm.`CategoryID`=7 ", CommandType.Text, new
                    {
                        tokenNo = Util.GetString(((Label)gr.FindControl("lblTokenNo")).Text),
                        LtnxNo = Util.GetString(((Label)gr.FindControl("lblLedTnx")).Text),
                        Id= Util.GetInt(((Label)gr.FindControl("lblLtdId")).Text)
                    }); 
					
					/*string id = StockReports.ExecuteScalar("(SELECT id FROM f_ledgertnxdetail WHERE `SubCategoryID` IN (SELECT `SubCategoryID` FROM f_subcategorymaster WHERE `CategoryID`='7') AND LedgerTransactionNo='" + Util.GetString(((Label)gr.FindControl("lblLedTnx")).Text) + "' ORDER BY ID ASC LIMIT 1)");
           
                    ExcuteCMD cmd = new ExcuteCMD();
                    cmd.DML(tnx, "UPDATE  `f_ledgertnxdetail` ltd SET ltd.`TokenCallStatus`=3 WHERE ltd.`TokenNo`=@tokenNo AND ltd.`ID`=@id", CommandType.Text, new
                    {
                        tokenNo = currentTokenNo,
                        id = id
                    }); */

                }
                if (((CheckBox)gr.FindControl("chkPout")).Checked)
                {
                    string EntryType = ((Label)gr.FindControl("lblEntryType")).Text;
                    string ID = ((Label)gr.FindControl("lblID")).Text;

                    sql = "Update patient_labinvestigation_opd Set technician='" + txtTechnician.Text + "', P_Out=1,P_OutByID='" + ViewState["EmpID"].ToString() + "',P_OUTByName='" + ViewState["EmpName"].ToString() + "',P_OutDateTime=NOW() Where ID = " + ID;
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                }
                // Transfer To Centre
                if (((CheckBox)gr.FindControl("chkTransfer")).Checked)
                {
                    string TransferCentreID = ((DropDownList)gr.FindControl("ddlTransferCentre")).SelectedValue;
                    if (TransferCentreID == "0")
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "KeySSelect", "modelAlert('Please Select Centre');", true);
                        ((DropDownList)gr.FindControl("ddlTransferCentre")).Style.Add("display", "block");
                        return;
                    }
                    string TestID = ((Label)gr.FindControl("lblTestId")).Text;
                    string str = "UPDATE  patient_labinvestigation_opd SET sampleTransferCentreID=" + Util.GetInt(TransferCentreID) + ",sampleTransferDate=NOW(),sampleTransferUserID='" + Session["ID"].ToString() + "',isTransfer=1 WHERE test_Id='" + TestID + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                }
            }
            tnx.Commit();
            con.Close();
            con.Dispose();
            // lblMsg.Text = "Record Saved Successfully ..";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "KeySrejct", "modelAlert('Record Save Successfully');", true);

            Search();
            return;

        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            con.Close();
            con.Dispose();
            return;
        }


    }

    protected void btnRemove_Click(object sender, EventArgs e)
    {
        if (txtReasonRemove.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Kindly Enter the Reject Reason";
            return;
        }
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction();
            ExcuteCMD excuteCMD = new ExcuteCMD();
            try
            {

                bool flag = false;
                foreach (GridViewRow gr in grdLabSearch.Rows)
                {
                    string sql = "";
                    if (((CheckBox)gr.FindControl("chkSampleCollect")).Checked)
                    {
                        flag = true;

                        string EntryType = ((Label)gr.FindControl("lblEntryType")).Text;
                        string LedgerTnxID = ((Label)gr.FindControl("lblLedgerTnxID")).Text;
                        string ID = ((Label)gr.FindControl("lblID")).Text;
                        DataTable dt = StockReports.GetDataTable("SELECT IF(plo.Type='2',plo.TransactionID,plo.LedgerTransactionNo)TransNo,plo.Test_ID,plo.Type,pm.mobile,pm.PatientID,plo.TransactionID," +
                                       " plo.Investigation_ID,plo.LedgertransactionNo,io.ObservationType_Id,plo.LedgertnxID,ltd.ItemID,ltd.ItemName,lt.PanelID,ltd.IsPackage " +
                                       " FROM patient_labinvestigation_opd plo   "+
                                       " INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID  "+
                                       " INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgertnxID "+
                                       " INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo  "+
                                       " INNER JOIN Patient_master pm ON pm.PatientID=plo.PatientID  " +
                                       " WHERE plo.ID='" + ID + "'");
                        string sql1 = "insert into patient_sample_Rejection(PatientID, TransactionID, Test_ID,Investigation_ID, LedgerTransactionNo, ObservationType_Id, " +
                                      "RejectionReason, UserID ) values ('" + Util.GetString(dt.Rows[0]["PatientID"].ToString()) + "', " +
                                      " '" + Util.GetString(dt.Rows[0]["TransactionID"].ToString()) + "', '" + Util.GetString(dt.Rows[0]["Test_ID"].ToString()) + "', " +
                                      " '" + Util.GetString(dt.Rows[0]["Investigation_ID"]) + "','" + Util.GetString(dt.Rows[0]["LedgertransactionNo"]) + "' , " +
                                      " '" + Util.GetString(dt.Rows[0]["ObservationType_Id"]) + "' , '" + Util.GetString(txtReasonRemove.Text.Trim()) + "', " +
                                      " '" + HttpContext.Current.Session["ID"].ToString() + "' ) ";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql1);
                        sql = "Update patient_labinvestigation_opd Set IsSampleCollected = 'R' Where ID = " + ID;
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                        if (AllLoadData_IPD.CheckDataPostToFinance(dt.Rows[0]["TransNo"].ToString()) > 0)
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "KeySrejct", "modelAlert('Patient Final Bill Already Posted To Finance...');", true);
                            return;
                        }
                        if (dt.Rows[0]["Type"].ToString() != "1")
                        {
                            string TypeBill = "IPD";
                            if (dt.Rows[0]["Type"].ToString() == "3")
                                TypeBill = "EMG";
                            if (AllLoadData_IPD.CheckBillGenerate(dt.Rows[0]["TransactionID"].ToString(), TypeBill) > 0)
                            {
                                tnx.Rollback();
                                tnx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "KeySrejct", "modelAlert('Bill Already Generated.');", true);
                                return;
                            }
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET LabSampleCollected='R',IsVerified=2,Updatedate=NOW() WHERE ID=" + Util.GetInt(dt.Rows[0]["LedgertnxID"]) + " ");
                            if (dt.Rows[0]["Type"].ToString() == "3")
                            {
                                string UpdateQuery = "Call updateEmergencyBillAmounts(" + dt.Rows[0]["LedgertransactionNo"].ToString() + ")";
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
                                string docstring = All_LoadData.CalcaluteDoctorShare("", dt.Rows[0]["LedgertnxID"].ToString(), "1", "HOSP", tnx, con);
                            }
                            else
                            {
                                string docstringIPD = All_LoadData.CalcaluteDoctorShare("", dt.Rows[0]["LedgertnxID"].ToString(), "2", "HOSP", tnx, con);
                            }
                        }
                        else
                        {
                            if (dt.Rows[0]["IsPackage"].ToString() == "0")
                            {
                                decimal CrAmount = Util.GetDecimal(excuteCMD.ExecuteScalar("SELECT (SUM(LTD.Amount)+(IFNULL(SUM(D.`Amount`),0))) FROM f_LedgerTnxDetail LTD LEFT JOIN `f_LedgerTnxDetail` d ON d.LedgerTnxRefID=ltd.ID AND d.IsVerified=1 WHERE LTD.ID=@ltdID", new
                                {
                                    ltdID = dt.Rows[0]["LedgertnxID"].ToString()
                                }));

                                var billNo = Util.GetString(excuteCMD.ExecuteScalar("Select BillNo from f_Ledgertransaction where TransactionID=@transactionID  Limit 1", new
                                {
                                    transactionID = dt.Rows[0]["TransactionID"].ToString()

                                }));

                                var patientLedgerNumber = Util.GetString(excuteCMD.ExecuteScalar("SELECT lm.LedgerNumber FROM f_ledgermaster lm WHERE lm.LedgerUserID=@patientID", new
                                {
                                    patientID = dt.Rows[0]["PatientID"].ToString()

                                }));
                                var patientType = "";
                                patientType = "CR";
                                string creditDebitNumber = Util.GetString(excuteCMD.ExecuteScalar(tnx, "select get_CrDrNo(CURRENT_DATE(),@patientType,@unit)", CommandType.Text, new
                                {
                                    patientType = patientType,
                                    unit = HttpContext.Current.Session["CentreID"].ToString()
                                }));
                                if (creditDebitNumber == "0")
                                {
                                    tnx.Rollback();
                                    tnx.Dispose();
                                }
                                drcrnote _drcrnote = new drcrnote(tnx);
                                _drcrnote.CRDR = "CR";
                                _drcrnote.CrDrNo = creditDebitNumber;
                                _drcrnote.TransactionID = dt.Rows[0]["TransactionID"].ToString();
                                _drcrnote.Amount = CrAmount;
                                _drcrnote.EntryDateTime = System.DateTime.Now;
                                _drcrnote.PtTYPE = "PTNT";
                                _drcrnote.BillNo = billNo;
                                _drcrnote.LedgerName = patientLedgerNumber;
                                _drcrnote.Narration = txtReasonRemove.Text.Trim();
                                _drcrnote.ItemID = dt.Rows[0]["ItemID"].ToString();
                                _drcrnote.UserID = HttpContext.Current.Session["ID"].ToString();
                                _drcrnote.ItemName = dt.Rows[0]["ItemName"].ToString();
                                _drcrnote.LedgerTnxID = Util.GetInt(dt.Rows[0]["LedgertnxID"].ToString());
                                _drcrnote.LedgerTransactionNo = Util.GetInt(dt.Rows[0]["LedgerTransactionNo"].ToString());
                                _drcrnote.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                                _drcrnote.PanelID = Util.GetInt(dt.Rows[0]["PanelID"].ToString());
                                _drcrnote.CRDRNoteType = 1;
                                _drcrnote.Insert();

                                decimal Rate = 0;
                                decimal DiscountAmount = 0;
                                decimal DiscountPercentage = 0;
                                decimal Amount = 0;

                                Rate = CrAmount * -1;
                                Amount = CrAmount * -1;
                                var Ledgertnxdetail = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "CALL Insert_CRDR_ledgertnxdetail(@vTypeofTnx,@vLedgerTnxID,@vAmount,@vUserID,@vpageURL, " +
                                    "@vCentreID,@vRoleID,@vIpAddress,@vcreditDebitNumber,@vRate,@vDiscountPercentage,@vDiscAmt)", CommandType.Text, new
                                    {
                                        vTypeofTnx = "CR",
                                        vLedgerTnxID = Util.GetInt(dt.Rows[0]["LedgertnxID"].ToString()),
                                        vAmount = Amount,
                                        vUserID = HttpContext.Current.Session["ID"].ToString(),
                                        vpageURL = All_LoadData.getCurrentPageName(),
                                        vCentreID = HttpContext.Current.Session["CentreID"].ToString(),
                                        vRoleID = HttpContext.Current.Session["RoleID"].ToString(),
                                        vIpAddress = All_LoadData.IpAddress(),
                                        vcreditDebitNumber = creditDebitNumber,
                                        vRate = Rate,
                                        vDiscountPercentage = DiscountPercentage,
                                        vDiscAmt = DiscountAmount
                                    }));
                                var LedgerTransacionUpdate = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "CALL Insert_CRDR_f_ledgertransaction(@vLedgerTransactionNo)", CommandType.Text, new
                                {
                                    vLedgerTransactionNo = dt.Rows[0]["LedgerTransactionNo"].ToString()
                                }));

                                if (dt.Rows[0]["PanelID"].ToString() == "1")
                                {
                                    var pmh = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "UPDATE patient_medical_history pmh SET pmh.PatientPaybleAmt= (pmh.PatientPaybleAmt + (@vnewAmount)) WHERE pmh.TransactionID=@vTransactionID AND pmh.PatientPaybleAmt>0 ", CommandType.Text, new
                                    {
                                        vTransactionID = dt.Rows[0]["TransactionID"].ToString(),
                                        vnewAmount = Amount
                                    }));
                                }
                                if (dt.Rows[0]["PanelID"].ToString() != "1")
                                {
                                    var pmh = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "UPDATE patient_medical_history pmh SET pmh.PanelPaybleAmt= (pmh.PanelPaybleAmt + (@vnewAmount)) WHERE pmh.TransactionID=@vTransactionID AND pmh.PanelPaybleAmt>0 ", CommandType.Text, new
                                    {
                                        vTransactionID = dt.Rows[0]["TransactionID"].ToString(),
                                        vnewAmount = Amount
                                    }));
                                }
                            }
                        }       
                    }
                }
                if (!flag)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return;
                }
                tnx.Commit();
                con.Close();
                con.Dispose();
                txtReasonRemove.Text = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "KeySrejct", "modelAlert('Test Rejected Successfully');", true);

                Search();
                return;

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveNotificationTime(string TransactionID, string TestID, string Date, string Time, string remarks)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            int ID = Util.GetInt(StockReports.ExecuteScalar("SELECT ID FROM radiology_accepatance_notification WHERE TransactionID='ISHHI" + TransactionID + "' AND TestID='" + TestID + "' AND isactive=1"));
            
            if (ID > 0)
            {
                string str = "UPDATE radiology_accepatance_notification SET IsActive = 0 WHERE ID = '" + ID + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            }
            string sql = "INSERT INTO radiology_accepatance_notification (TransactionID,TestID,NotificationDate,NotificationTime,EntryBy,Remarks) ";
            sql += "VALUES('ISHHI" + TransactionID + "','" + TestID + "','" + Util.GetDateTime(Date.ToString()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(Time.ToString()).ToString("HH:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + remarks + "')";
             System.IO.File.WriteAllText(@"F:\WriteText.txt", sql);
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            // System.IO.File.WriteAllText(@"F:\WriteText.txt", sql);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
      
    }


    [WebMethod]
    public static string GetNotificationDetails(string transactionID, string testID)
    {


        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dt = excuteCMD.GetDataTable("SELECT DATE_FORMAT( n.notificationDate,'%d-%b-%Y')notificationDate ,TIME_FORMAT(n.notificationTime,'%h:%i:%p') notificationTime,DATE_FORMAT(n.EntryDateTime,'%d-%b-%Y %h:%i:%p')entryDateTime, CONCAT(em.Title,' ',em.Name)createBy , DATE_FORMAT(n.EntryDateTime,'%d-%b-%Y %h:%i:%p') entryDateTime, IFNULL( n.Remarks,'') Remarks,n.Reply, CONCAT(em1.Title,' ',em1.Name) ReplyBy,DATE_FORMAT( n.ReplyDateTime,'%d-%b-%Y')ReplyDate FROM  radiology_accepatance_notification n INNER JOIN employee_master  em ON em.EmployeeID=n.EntryBy LEFT JOIN  employee_master  em1 ON em1.EmployeeID=n.ReplyBy WHERE n.TransactionID=@transactionID AND n.TestID=@testID  ORDER BY n.ID desc", CommandType.Text, new
        {

            transactionID = transactionID,
            testID = testID

        });



        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }

    protected void btnCall_Click(object sender, EventArgs e)
    {
        //string checkAlreadyCalled = Util.GetString(StockReports.ExecuteScalar(" SELECT ltd.`TokenNo`FROM `f_ledgertnxdetail` ltd WHERE ltd.`TokenCallStatus`=1 AND LOWER(ltd.`TokenRoomName`)='" + ddlRoomName.SelectedItem.Text.ToLower() + "' "));
        //if (!String.IsNullOrEmpty(checkAlreadyCalled))
        //{
        //    string returnMsg = "Token No :" + checkAlreadyCalled + " Already Called In Room :" + ddlRoomName.SelectedItem.Text;
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + returnMsg + "');", true);
        //    return;
        //}

       // var str = " SELECT ltd.`TokenNo`,CONCAT(pm.Title,' ',pm.PName)Pname,pm.PatientID,DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')EntryDate FROM `f_ledgertnxdetail` ltd INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  WHERE ltd.`TokenCallStatus`=1 AND LOWER(ltd.`TokenRoomName`)='" + ddlRoomName.SelectedItem.Text.ToLower() + "' ";
       // DataTable checkAlreadyCalled = StockReports.GetDataTable(str);
       // if (checkAlreadyCalled != null && checkAlreadyCalled.Rows.Count > 0)
       // {
       //  //   string returnMsg = "Token No :" + checkAlreadyCalled.Rows[0]["TokenNo"].ToString() + " Already Called In Room :" + ddlRoomName.SelectedItem.Text + " of </br> Patient : " + checkAlreadyCalled.Rows[0]["Pname"].ToString() + " &nbsp; &nbsp; UHID : " + checkAlreadyCalled.Rows[0]["PatientID"].ToString() + " &nbsp; Date : " + checkAlreadyCalled.Rows[0]["EntryDate"].ToString();
       // //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + returnMsg + "');", true);
       ////     return;
       // }

        string previousCallToken = string.Empty;
        string LedgerTnxNo = string.Empty;
        int isMultiple = 0;
        string LtdId = "";
        for (int i = 0; i < grdLabSearch.Rows.Count; i++)
        {
            if (((CheckBox)grdLabSearch.Rows[i].FindControl("chkCallUncall")).Checked)
            {
                string currentTokenNo = ((Label)grdLabSearch.Rows[i].FindControl("lblTokenNo")).Text;
                LedgerTnxNo = ((Label)grdLabSearch.Rows[i].FindControl("lblLedTnx")).Text;
                if (previousCallToken != currentTokenNo && !String.IsNullOrEmpty(previousCallToken))
                {
                    isMultiple = 1;
                }
                else
                    previousCallToken = currentTokenNo;


                if (LtdId=="")
                {
                   LtdId = ((Label)grdLabSearch.Rows[i].FindControl("lblLtdId")).Text;
                }
                else
                {
                    LtdId = "'" + LtdId + "'," + "'" + ((Label)grdLabSearch.Rows[i].FindControl("lblLtdId")).Text + "'";
                }



            }
        }
        if (isMultiple == 1)
        {

            string returnMsg = "Please Select Single Token.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + returnMsg + "');", true);
            return;
        }
        else
        {
           ExcuteCMD cmd = new ExcuteCMD();
           cmd.DML("UPDATE  `f_ledgertnxdetail` ltd INNER JOIN `f_subcategorymaster` sm ON ltd.`SubcategoryID`=sm.`SubCategoryID` SET ltd.`TokenCallStatus`=1 WHERE ltd.`TokenNo`=@tokenNo  AND ltd.`LedgerTransactionNo`=@LtnxNo And ltd.Id in ("+LtdId+") AND sm.`CategoryID`=7", CommandType.Text, new
            {
                tokenNo = previousCallToken,
                LtnxNo = LedgerTnxNo
                
            }); 
			
			/*string id = StockReports.ExecuteScalar("(SELECT id FROM f_ledgertnxdetail WHERE `SubCategoryID` IN (SELECT `SubCategoryID` FROM f_subcategorymaster WHERE `CategoryID`='7') AND LedgerTransactionNo='" + LedgerTnxNo + "' ORDER BY ID ASC LIMIT 1)");
           
            ExcuteCMD cmd = new ExcuteCMD();
            cmd.DML("UPDATE  `f_ledgertnxdetail` ltd SET ltd.`TokenCallStatus`=1 WHERE ltd.`TokenNo`=@tokenNo  AND ltd.`ID`=@id", CommandType.Text, new
            {
                tokenNo = previousCallToken,
                id = id
            }); */


        }
        Search();

    }
    protected void btnUnCall_Click(object sender, EventArgs e)
    {
        for (int i = 0; i < grdLabSearch.Rows.Count; i++)
        {
            if (((CheckBox)grdLabSearch.Rows[i].FindControl("chkCallUncall")).Checked)
            {
                string LedgerTnxNo = Util.GetString(((Label)grdLabSearch.Rows[i].FindControl("lblLedTnx")).Text);
                string currentTokenNo = ((Label)grdLabSearch.Rows[i].FindControl("lblTokenNo")).Text;
                ExcuteCMD cmd = new ExcuteCMD();
                cmd.DML("UPDATE  `f_ledgertnxdetail` ltd SET ltd.`TokenCallStatus`=2 WHERE ltd.`TokenNo`=@tokenNo  AND ltd.`LedgerTransactionNo`=@LtnxNo", CommandType.Text, new
                {
                    tokenNo = currentTokenNo,
                    LtnxNo = LedgerTnxNo
                });
            }
        }

        Search();
    }


}
