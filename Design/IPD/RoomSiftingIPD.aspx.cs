using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_IPD_RoomBilling : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["Transaction_ID"] = Request.QueryString["TransactionID"].ToString();
            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);
            DataTable dt = AQ.GetPatientAdjustmentDetails(TID);

            if (dt != null && dt.Rows.Count > 0)
            {
                int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1" && auth==0)
                {
                    string Msg = "Patient's Bill has been freezed. No Room Shifting can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Room Shifting can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    string Msg = "Patient's Final Bill has been Generated. No Room can be Sifted Now..";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            BindPatientDetails(TID);
            BindRoomCategory();
            BindAvailableRooms(cmbRoomType.SelectedValue.ToString());
            BindRoomDetails(TID);
            SearchPendingRequest();
        }
        ((TextBox)txtDate.FindControl("txtStartDate")).Attributes.Add("readOnly", "readOnly");
        ((AjaxControlToolkit.CalendarExtender)txtDate.FindControl("calStartDate")).EndDate = DateTime.Now;
    }
    public void BindRoomDetails(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pmh.TransNo as IPDNo,pm.PatientID MRNo,pm.PName,(ictm.Name)RoomType, ");
        sb.Append(" CONCAT(rm.Name,'/',rm.Bed_No)Room, ");
        sb.Append(" (Select Name from IPD_Case_Type_Master where IPDCaseTypeID=pip.IPDCaseTypeID_Bill)BillingCategory, ");
        sb.Append(" CONCAT(DATE_FORMAT(pip.StartDate,'%d-%b-%Y'),' ',TIME_FORMAT(pip.StartTime,'%h:%i %p'))EntryDate, ");
        sb.Append(" IF(pip.Status='IN','',CONCAT(DATE_FORMAT(pip.EndDate,'%d-%b-%Y'),' ',TIME_FORMAT(pip.EndTime,'%h:%i %p')))LeaveDate,(SELECT Name FROM employee_master WHERE employeeid=pip.UserID)Name,pip.Status FROM patient_ipd_profile pip ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pip.TransactionID=pmh.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
        sb.Append(" LEFT JOIN room_master rm ON rm.RoomId=pip.RoomID ");
        sb.Append(" LEFT JOIN ipd_case_type_master ictm ON pip.IPDCaseTypeID=ictm.IPDCaseTypeID ");
        sb.Append(" WHERE pip.TransactionID='" + TransactionID + "' ");
        sb.Append(" ORDER BY pip.patientipdprofile_id DESC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdRoomDetail.DataSource = dt;
            grdRoomDetail.DataBind();
        }
        else
        {
            grdRoomDetail.DataSource = null;
            grdRoomDetail.DataBind();
        }
    }
    public void BindAvailableRooms(string IPDCaseTypeID)
    {
        lbl.Text = "0";
        DataTable dtAvailRooms = RoomBilling.GetAvailRooms(IPDCaseTypeID);
        if (dtAvailRooms != null && dtAvailRooms.Rows.Count > 0)
        {
            cmbAvailRooms.Items.Clear();
            cmbAvailRooms.DataSource = dtAvailRooms;
            cmbAvailRooms.DataTextField = "Name";
            cmbAvailRooms.DataValueField = "RoomId";
            cmbAvailRooms.DataBind();
            cmbAvailRooms.Items.Insert(0, new ListItem("Select", "Select"));
            btnShift.Enabled = true;
           
           lblmsg.Text = "";
        }
        else
        {
            if (Resources.Resource.RoomShifitingRequest != "1")
            {
                lblmsg.Text = "No Room Available under Current Selected RoomType";
                btnShift.Enabled = false;
            }
            else { btnShift.Enabled = true; }
      
            cmbAvailRooms.Items.Clear();
        }
    }

    public void BindRoomCategory()
    {
        try
        {
            AllLoadData_IPD.bindCaseType(cmbRoomType);
            cmbRoomType.SelectedIndex = cmbRoomType.Items.IndexOf(cmbRoomType.Items.FindByValue(ViewState["IPDCaseTypeID"].ToString()));
            AllLoadData_IPD.bindBillingCategory(ddlBillCategory, "Select");
            ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(ViewState["IPDCaseTypeID_Bill"].ToString()));
            ddlBillCategory.Enabled = false;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void cmbRoomType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAvailableRooms(cmbRoomType.SelectedValue.ToString());
        string BillingCategoryID = StockReports.ExecuteScalar("SElect BillingCategoryID from Ipd_Case_Type_master where IPDCaseTypeID='" + cmbRoomType.SelectedValue.ToString() + "'");
        ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(BillingCategoryID));
    }

    private void BindPatientDetails(string TransactionID)
    {
        string str = "SELECT pmh.PatientID,pmh.TransactionID,pmh.TransNo as IPDNo,pmh.patient_type,pmh.PanelID,pmh.PatientTypeID,pmh.ScheduleChargeID, " +
                    "pip.RoomID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,DATE_FORMAT(pip.StartDate,'%d-%b-%Y')StartDate,DATE_FORMAT(pip.StartTime,'%h:%i %p')StartTime, " +
                    "(Select Name from ipd_case_type_master where IPDCaseTypeID=pip.IPDCaseTypeID)RoomType," +
                    "(Select Name from ipd_case_type_master where IPDCaseTypeID=pip.IPDCaseTypeID_Bill)BillingType," +
                    "(Select concat(Floor,'/',Name,'-',Room_No,'/BedNo - ',Bed_No) from Room_master where RoomID=pip.RoomID)RoomName,pmh.DoctorID " +
                    "FROM patient_medical_history pmh INNER JOIN patient_ipd_profile pip ON " +
                    "pmh.TransactionID = pip.TransactionID " +
                    "WHERE pmh.TransactionID='" + TransactionID + "' AND pip.Status='IN'";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
            lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();
            lblIPDNo.Text = dt.Rows[0]["IPDNo"].ToString();
            lblRoom_ID.Text = dt.Rows[0]["RoomID"].ToString();
            lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
            lblCurRoomCat.Text = dt.Rows[0]["RoomType"].ToString();
            lblCurBillCat.Text = dt.Rows[0]["BillingType"].ToString();
            lblCurRoom.Text = dt.Rows[0]["RoomName"].ToString();
            lblShiftDate.Text = dt.Rows[0]["StartDate"].ToString() + " " + dt.Rows[0]["StartTime"].ToString();
            ViewState["Patient_Type"] = dt.Rows[0]["patient_type"].ToString();
            ViewState["IPDCaseTypeID"] = dt.Rows[0]["IPDCaseTypeID"].ToString();
            ViewState["IPDCaseTypeID_Bill"] = dt.Rows[0]["IPDCaseTypeID_Bill"].ToString();
            ViewState["StartDate"] = dt.Rows[0]["StartDate"].ToString();
            ViewState["StartTime"] = dt.Rows[0]["StartTime"].ToString();
            ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
            lblDoctorID.Text = dt.Rows[0]["DoctorID"].ToString();
            ViewState["PatientTypeID"] = dt.Rows[0]["PatientTypeID"].ToString();
        }
    }

    protected void btnShift_Click(object sender, EventArgs e)
    {
      /*  DateTime s = Util.GetDateTime(Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy"));
        if (Util.GetDateTime(Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy")).Date < Util.GetDateTime(ViewState["StartDate"]).Date)
        {
            lblmsg.Text = "Shifting date/time is less then Admit Date or Last Shifted Date...";
            return;
        }

        if (cmbAvailRooms.SelectedItem.Text.Trim().ToUpper() == "SELECT")
        {
            lblmsg.Text = "Please Select Room";
            return;
        }
        */

        bool IsSaved = true;

        IsSaved = SaveData();
        BindRoomDetails(lblTransactionNo.Text);
      
        BindPatientDetails(lblTransactionNo.Text);
        BindRoomCategory();
        BindAvailableRooms(cmbRoomType.SelectedValue.ToString());

    }

    private bool SaveData()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction Tnx = conn.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            if (Resources.Resource.RoomShifitingRequest == "1")
            {
                string query1 = "SELECT startDate,starttime,Room_id,IPDCaseType_ID_Bill,Requested_IPDCaseType_ID,Requested_RoomId from patient_roomshift_request " +
                         "WHERE Transaction_ID='" + lblTransactionNo.Text + "' AND isapprove=0 ";
                DataTable dt = StockReports.GetDataTable(query1);
                if (dt != null && dt.Rows.Count > 0)
                {
                    // string SiftDate = Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd");                
                    //  string SiftTime = Util.GetDateTime(((TextBox)txtDate.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                    //  string RoomId = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, " SELECT Room_ID FROM patient_ipd_profile where Transaction_ID='" + lblTransactionNo.Text + "' and Status='IN' "));

                    string SiftDate = Util.GetDateTime(dt.Rows[0]["startDate"]).ToString("yyyy-MM-dd");
                    string SiftTime = Util.GetDateTime(dt.Rows[0]["starttime"]).ToString("HH:mm:ss");
                    string RoomId = dt.Rows[0]["Room_id"].ToString();
                    string ReqIPDCaseTypeID = dt.Rows[0]["Requested_IPDCaseType_ID"].ToString();
                    string BillingCategoryID = dt.Rows[0]["IPDCaseType_ID_Bill"].ToString();
                    string RequestedRoomId = dt.Rows[0]["Requested_RoomId"].ToString();

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE RoomID='" + RoomId + "' ");


                    string str = "Update patient_ipd_profile Set ";
                    str += "EndDate='" + SiftDate + "',";
                    str += "EndTime='" + SiftTime + "',";
                    str += "Status='OUT',TobeBill=0,UserID='" + ViewState["ID"] + "' ";
                    str += "Where TransactionID='" + lblTransactionNo.Text + "' and Status='IN'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                    Patient_IPD_Profile objIPD = new Patient_IPD_Profile(Tnx);
                    objIPD.TransactionID = lblTransactionNo.Text;
                    objIPD.TobeBill = 1;
                    objIPD.StartDate = Util.GetDateTime(SiftDate);
                    objIPD.StartTime = Util.GetDateTime(SiftTime);
                    objIPD.IPDCaseTypeID = ReqIPDCaseTypeID;

                    /*  if (ddlBillCategory.SelectedItem.Text.ToUpper() == "SELECT")
                      {
                          str = "select BillingCategoryID from ipd_case_type_master where IPDCaseType_ID='" + cmbRoomType.SelectedValue + "' ";
                          string BillingCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, str));

                          objIPD.IPDCaseType_ID_Bill = BillingCategoryID;
                          ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(BillingCategoryID));
                      }
                      else
                          objIPD.IPDCaseType_ID_Bill = ddlBillCategory.SelectedItem.Value; */

                    objIPD.IPDCaseTypeID_Bill = BillingCategoryID;
                    objIPD.RoomID = RequestedRoomId;
                    objIPD.PanelID = Util.GetInt(lblPanelID.Text);
                    objIPD.PatientID = lblPatientID.Text;
                    objIPD.Status = "IN";
                    objIPD.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objIPD.Hospital_Id = Session["HOSPID"].ToString();

                    objIPD.Insert();


                    string RoomDetail = GetRoomItemDetails(lblPanelID.Text.Trim(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ViewState["ScheduleChargeID"]));

                    //if (ViewState["IPDCaseType_ID_Bill"].ToString() != ddlBillCategory.SelectedItem.Value)
                    //{
                    //    RoomBill(Session["HOSPID"].ToString(), lblTransactionNo.Text.Trim(), lblPatientID.Text.Trim(), Util.GetString(RoomDetail.Split('#')[3]), ViewState["ID"].ToString(), Util.GetInt(lblPanelID.Text.Trim()), Util.GetString(RoomDetail.Split('#')[0].ToString()), Util.GetString(RoomDetail.Split('#')[1].ToString()), "", Util.GetDecimal(RoomDetail.Split('#')[2].ToString()), SiftDate, SiftTime, Util.GetString(RoomDetail.Split('#')[4]), SiftDate + " " + SiftTime, ViewState["Patient_Type"].ToString(), Tnx, Util.GetInt(RoomDetail.Split('#')[5].ToString()), conn, lblDoctorID.Text.Trim(), cmbAvailRooms.SelectedItem.Value);
                    //}

                    //For requested room type
                    string query = "SELECT COUNT(*) FROM patient_medical_history WHERE TransactionID='" + lblTransactionNo.Text + "' AND RequestedRoomType='" + cmbRoomType.SelectedItem.Value + "' AND IsRoomRequest='1' ";//ipd_case_history
                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, query));
                    if (count > 0)
                    {
                        query = "UPDATE patient_medical_history SET CurrentIPDCaseTypeID='" + objIPD.IPDCaseTypeID + "',CurrentRoomID='" + objIPD.RoomID + "',BillingIPDCaseTypeID='" + objIPD.IPDCaseTypeID_Bill + "',IsRoomRequest='2',LastUpdatedBy='" + Util.GetString(ViewState["ID"]) + "',UpdateDate=NOW() WHERE TransactionID='" + lblTransactionNo.Text + "' ";//ipd_case_history
                        All_LoadData.updateNotification(cmbRoomType.SelectedItem.Value, "", "", 22, Tnx);
                    }
                    else
                    {
                        query = "UPDATE patient_medical_history SET CurrentIPDCaseTypeID='" + objIPD.IPDCaseTypeID + "',CurrentRoomID='" + objIPD.RoomID + "',BillingIPDCaseTypeID='" + objIPD.IPDCaseTypeID_Bill + "',LastUpdatedBy='" + Util.GetString(ViewState["ID"]) + "',UpdateDate=NOW() WHERE TransactionID='" + lblTransactionNo.Text + "' ";//ipd_case_history
                    }
                    MySqlHelper.ExecuteScalar(conn, CommandType.Text, query);

                    // All_LoadData.updateNotification(cmbAvailRooms.SelectedItem.Value);

                    //query = "SELECT COUNT(*) FROM ipd_case_history WHERE RequestedRoomType='" + cmbRoomType.SelectedItem.Value + "' AND IsRoomRequest='1'AND Transaction_ID='" + lblTransactionNo.Text + "' ";
                    //count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, query));
                    //if (count > 0)
                    //{

                    //}
                    //For requested room type            
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=2 WHERE RoomID='" + RequestedRoomId + "' ");

                    // For Update Room Shift Requesition Status
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE patient_roomshift_request SET IsApprove=1,Req_Approved_By='" + ViewState["ID"] + "'  ,Req_Approved_DateTime=NOW() WHERE Transaction_ID='" + lblTransactionNo.Text + "' AND Isapprove=0 and Requested_RoomId= '" + RequestedRoomId + "' ");
                    Tnx.Commit();
                    if (Resources.Resource.SMSApplicable == "1")
                    {
                        var columninfo1 = smstemplate.getColumnInfo(5, conn);
                        if (columninfo1.Count > 0)
                        {
                            string DocMobile = StockReports.ExecuteScalar("SELECT dm.Mobile AS MobileNo FROM  doctor_master dm  WHERE DoctorID='" + lblDoctorID.Text + "'");
                            DataTable dtPatientInfo = StockReports.GetDataTable("Select Concat(Title,PName)PName,Mobile from Patient_Master where PAtientID='" + lblPatientID.Text + "'");
                            string IpdCaseTypeName = StockReports.ExecuteScalar("SELECT TRIM(CONCAT(rm.Floor,'/',icm.Name,'/',CONCAT(TRIM(rm.Name),'-',RM.Room_No),'/',TRIM(rm.Bed_No))) " +
                                                     "FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID " +
                                                     "WHERE rm.RoomId='" + cmbAvailRooms.SelectedItem.Value + "'");
                            string FromIpdCaseTypeName = StockReports.ExecuteScalar("SELECT TRIM(CONCAT(rm.Floor,'/',icm.Name,'/',CONCAT(TRIM(rm.Name),'-',RM.Room_No),'/',TRIM(rm.Bed_No))) " +
                                                    "FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID " +
                                                    "WHERE rm.RoomId='" + RoomId + "'");
                            string[] mobileArray;
                            if (DocMobile != "")
                            {
                                mobileArray = DocMobile.Split('/');
                                foreach (var mobile in mobileArray)
                                {
                                    columninfo1[0].PName = dtPatientInfo.Rows[0]["PName"].ToString();
                                    columninfo1[0].ContactNo = mobile;
                                    columninfo1[0].TemplateID = 5;
                                    columninfo1[0].PatientID = lblPatientID.Text;
                                    columninfo1[0].Ward = IpdCaseTypeName;
                                    columninfo1[0].FromWard = FromIpdCaseTypeName;
                                    columninfo1[0].TransactionID = StockReports.getTransNobyTransactionID(lblTransactionNo.Text);
                                    string sms = smstemplate.getSMSTemplate(5, columninfo1, 2, conn, HttpContext.Current.Session["ID"].ToString());
                                }
                            }
                        }
                    }

                    lblmsg.Text = "Room Is Shifted Successfully";
                    SearchPendingRequest();
                }
                else
                {
                    // lblmsg.Text = "No Room Shift Request Pending. And Without request you can not shift Room.";
                    // Response.Write("<script>alert('No Room Shift Request Pending. And Without request you can't shift Room.')</script>");
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('No Room Shift Request Pending. And Without request you can not shift Room.')", true);

                    
                }

               

                BindRoomDetails(lblTransactionNo.Text);
                return true;
            }
            else { 
            
                 string SiftDate = Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd");
                 string SiftTime = Util.GetDateTime(((TextBox)txtDate.FindControl("txtTime")).Text).ToString("HH:mm:ss");

                 string RoomId =Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, " SELECT RoomID FROM patient_ipd_profile where TransactionID='" + lblTransactionNo.Text + "' and Status='IN' "));

                 MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE RoomID='" + RoomId + "' ");


                 string str = "Update patient_ipd_profile Set ";
                 str += "EndDate='" + SiftDate + "',";
                 str += "EndTime='" + SiftTime + "',";
                 str += "Status='OUT',TobeBill=0,UserID='" + ViewState["ID"] + "' ";
                 str += "Where TransactionID='" + lblTransactionNo.Text + "' and Status='IN'";
                 MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                 Patient_IPD_Profile objIPD = new Patient_IPD_Profile(Tnx);
                 objIPD.TransactionID = lblTransactionNo.Text;
                 objIPD.TobeBill = 1;
                 objIPD.StartDate = Util.GetDateTime(SiftDate);
                 objIPD.StartTime = Util.GetDateTime(SiftTime);
                 objIPD.IPDCaseTypeID = cmbRoomType.SelectedItem.Value;

                 if (ddlBillCategory.SelectedItem.Text.ToUpper() == "SELECT")
                 {
                     str = "select BillingCategoryID from ipd_case_type_master where IPDCaseTypeID='" + cmbRoomType.SelectedValue + "' ";
                     string BillingCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, str));

                     objIPD.IPDCaseTypeID_Bill = BillingCategoryID;
                     ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(BillingCategoryID));
                 }
                 else
                     objIPD.IPDCaseTypeID_Bill = ddlBillCategory.SelectedItem.Value;


                 objIPD.RoomID = cmbAvailRooms.SelectedItem.Value;
                 objIPD.PanelID = Util.GetInt(lblPanelID.Text);
                 objIPD.PatientID = lblPatientID.Text;
                 objIPD.Status = "IN";
                 objIPD.CentreID = Util.GetInt(Session["CentreID"].ToString());
                 objIPD.Hospital_Id = Session["HOSPID"].ToString();
          
                 objIPD.Insert();

                 string RoomDetail = GetRoomItemDetails(lblPanelID.Text.Trim(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ViewState["ScheduleChargeID"]));

                 //if (ViewState["IPDCaseType_ID_Bill"].ToString() != ddlBillCategory.SelectedItem.Value)
                 //{
                 //    RoomBill(Session["HOSPID"].ToString(), lblTransactionNo.Text.Trim(), lblPatientID.Text.Trim(), Util.GetString(RoomDetail.Split('#')[3]), ViewState["ID"].ToString(), Util.GetInt(lblPanelID.Text.Trim()), Util.GetString(RoomDetail.Split('#')[0].ToString()), Util.GetString(RoomDetail.Split('#')[1].ToString()), "", Util.GetDecimal(RoomDetail.Split('#')[2].ToString()), SiftDate, SiftTime, Util.GetString(RoomDetail.Split('#')[4]), SiftDate + " " + SiftTime, ViewState["Patient_Type"].ToString(), Tnx, Util.GetInt(RoomDetail.Split('#')[5].ToString()), conn, lblDoctorID.Text.Trim(), cmbAvailRooms.SelectedItem.Value);
                 //}

                 //For requested room type
                 string query = "SELECT COUNT(*) FROM patient_medical_history WHERE TransactionID='" + lblTransactionNo.Text + "' AND RequestedRoomType='" + cmbRoomType.SelectedItem.Value + "' AND IsRoomRequest='1' ";//ipd_case_history
                 int count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, query));
                 if (count > 0)
                 {
                     query = "UPDATE patient_medical_history SET CurrentIPDCaseTypeID='" + objIPD.IPDCaseTypeID + "',CurrentRoomID='" + objIPD.RoomID + "',BillingIPDCaseTypeID='" + objIPD.IPDCaseTypeID_Bill + "',IsRoomRequest='2',LastUpdatedBy='" + Util.GetString(ViewState["ID"]) + "',UpdateDate=NOW() WHERE TransactionID='" + lblTransactionNo.Text + "' ";//ipd_case_history
                     All_LoadData.updateNotification(cmbRoomType.SelectedItem.Value, "", "", 22, Tnx);
                 }
                 else
                 {
                     query = "UPDATE patient_medical_history SET CurrentIPDCaseTypeID='" + objIPD.IPDCaseTypeID + "',CurrentRoomID='" + objIPD.RoomID + "',BillingIPDCaseTypeID='" + objIPD.IPDCaseTypeID_Bill + "',LastUpdatedBy='" + Util.GetString(ViewState["ID"]) + "',UpdateDate=NOW() WHERE TransactionID='" + lblTransactionNo.Text + "' ";//ipd_case_history
                 }
                 MySqlHelper.ExecuteScalar(conn, CommandType.Text, query);
            
                 //For requested room type            
                 MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE room_master SET IsRoomClean=2 WHERE RoomID='" + cmbAvailRooms.SelectedItem.Value + "' ");
                 Tnx.Commit();

                 if (Resources.Resource.SMSApplicable == "1")
                 {
                     var columninfo1 = smstemplate.getColumnInfo(5, conn);
                     if (columninfo1.Count > 0)
                     {
                         string DocMobile = StockReports.ExecuteScalar("SELECT dm.Mobile AS MobileNo FROM  doctor_master dm  WHERE DoctorID='" + lblDoctorID.Text + "'");
                         DataTable dtPatientInfo = StockReports.GetDataTable("Select Concat(Title,PName)PName,Mobile from Patient_Master where PAtientID='" + lblPatientID.Text + "'");
                         string IpdCaseTypeName = StockReports.ExecuteScalar("SELECT TRIM(CONCAT(rm.Floor,'/',icm.Name,'/',CONCAT(TRIM(rm.Name),'-',RM.Room_No),'/',TRIM(rm.Bed_No))) " +
                                                  "FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID " +
                                                  "WHERE rm.RoomId='" + cmbAvailRooms.SelectedItem.Value + "'");
                         string FromIpdCaseTypeName = StockReports.ExecuteScalar("SELECT TRIM(CONCAT(rm.Floor,'/',icm.Name,'/',CONCAT(TRIM(rm.Name),'-',RM.Room_No),'/',TRIM(rm.Bed_No))) " +
                                                 "FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID " +
                                                 "WHERE rm.RoomId='" + RoomId + "'");
                          string [] mobileArray;
                          if (DocMobile != "")
                          {
                              mobileArray = DocMobile.Split('/');
                              foreach (var mobile in mobileArray)
                              {
                                  columninfo1[0].PName = dtPatientInfo.Rows[0]["PName"].ToString();
                                  columninfo1[0].ContactNo = mobile;
                                  columninfo1[0].TemplateID = 5;
                                  columninfo1[0].PatientID = lblPatientID.Text;
                                  columninfo1[0].Ward = IpdCaseTypeName;
                                  columninfo1[0].FromWard = FromIpdCaseTypeName;
                                  columninfo1[0].TransactionID = StockReports.getTransNobyTransactionID(lblTransactionNo.Text);
                                  string sms = smstemplate.getSMSTemplate(5, columninfo1, 2, conn, HttpContext.Current.Session["ID"].ToString());
                              }
                          }
                     }
                 }

                 lblmsg.Text = "Room Is Shifted Successfully";

                 BindRoomDetails(lblTransactionNo.Text);
                 return true;
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            lblmsg.Text = "Room Is Not Shifted";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            Tnx.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }

    protected void ChkRoomShift_CheckedChanged(object sender, EventArgs e)
    {
        cmbRoomType.Enabled = true;
        cmbAvailRooms.Enabled = true;
        ddlBillCategory.Enabled = true;
        btnShift.Enabled = true;
        ((TextBox)txtDate.FindControl("txtStartDate")).Enabled = true;
    }

    private string RoomBill(string Hospital_ID, string TransactionID, string PatientID, string SubCategory_ID, string User_ID, int PanelID, string Item_ID, string ItemName, string BillingRoomName, decimal TotalBillAmount, string StartDate, string StartTime, string BufferTime, string SiftDate, string PatientType, MySqlTransaction Tnx, int rateListID,MySqlConnection con,string DoctorID,string Room_ID)
    {
        try
        {
            string MembershipNo = StockReports.ExecuteScalar("SELECT IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo from patient_master pm where PatientID='" + PatientID + "'");
                
            DateTime start = Util.GetDateTime(StartTime);
            DateTime sdate = Util.GetDateTime(StartDate);
            sdate = Util.GetDateTime(sdate.ToShortDateString() + " " + start.ToShortTimeString());
            int BTime = Util.GetInt(BufferTime);

            TimeSpan TimeSpent = (DateTime.Now - sdate);

            if (TimeSpent.TotalHours >= BTime)
            {

                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(Tnx);

                ObjLdgTnx.Hospital_ID = Hospital_ID;
                ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT",con);
                ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(Hospital_ID, "HOSP",con);
                ObjLdgTnx.TypeOfTnx = "IPD-Room-Shift";
                ObjLdgTnx.Date = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd"));
                ObjLdgTnx.Time = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("HH:mm:ss"));
                ObjLdgTnx.BillNo = "";
                ObjLdgTnx.NetAmount = TotalBillAmount;
                ObjLdgTnx.GrossAmount = TotalBillAmount;

                if (PatientID == "")
                    PatientID = Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text,"SELECT PatientID from patient_medical_history WHERE TransactionID='" + TransactionID + "'"));

                ObjLdgTnx.PatientID = PatientID;
                ObjLdgTnx.PanelID = PanelID;
                ObjLdgTnx.TransactionID = TransactionID;
                ObjLdgTnx.UserID = User_ID;
                ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnx.PatientType = PatientType;
                string LedgerTransactionNo = ObjLdgTnx.Insert();


                if (LedgerTransactionNo != "")
                {

                    DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(TransactionID,con);

                    LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(Tnx);
                    ObjLdgTnxDtl.Hospital_Id = Hospital_ID;
                    ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                    ObjLdgTnxDtl.ItemID = Item_ID;
                    ObjLdgTnxDtl.Rate = TotalBillAmount;
                    ObjLdgTnxDtl.Quantity = 1;
                    ObjLdgTnxDtl.StockID = "";
                    ObjLdgTnxDtl.IsTaxable = "NO";
                    ObjLdgTnxDtl.IsVerified = 1;
                    ObjLdgTnxDtl.TransactionID = TransactionID;
                    ObjLdgTnxDtl.SubCategoryID = SubCategory_ID;
                    ObjLdgTnxDtl.ItemName = ItemName;
                    ObjLdgTnxDtl.UserID = User_ID;
                    ObjLdgTnxDtl.EntryDate = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd HH:mm:ss"));
                    ObjLdgTnxDtl.IsPayable = StockReports.GetIsPayableItems(ObjLdgTnxDtl.ItemID, ObjLdgTnx.PanelID);
                    ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(SubCategory_ID),con));
                    ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                    ObjLdgTnxDtl.RateListID = rateListID;
                    ObjLdgTnxDtl.IPDCaseTypeID = ddlBillCategory.SelectedItem.Value;
                    ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                    ObjLdgTnxDtl.DoctorID = DoctorID;
                    ObjLdgTnxDtl.Type = "I";
                    ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd HH:mm:ss"));
                    ObjLdgTnxDtl.VarifiedUserID = User_ID;
                    ObjLdgTnxDtl.RoomID = Room_ID;

                    int patientTypeID = Util.GetInt(ViewState["PatientTypeID"]);
                    var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(Item_ID), patientTypeID);
                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                    {
                        int iCtr = 0;
                        foreach (DataRow drPkg in dtPkg.Rows)
                        {
                            if (iCtr == 0)
                            {
                                DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(TransactionID, drPkg["PackageID"].ToString(), Item_ID, TotalBillAmount, 1, Util.GetInt(ddlBillCategory.SelectedItem.Value), con);

                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                {
                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                    {
                                        ObjLdgTnxDtl.Amount = 0;
                                        ObjLdgTnxDtl.DiscountPercentage = 0;
                                        ObjLdgTnxDtl.DiscAmt = 0;
                                        ObjLdgTnxDtl.IsPackage = 1;
                                        ObjLdgTnxDtl.PackageID = Util.GetString(dtPkgDetl.Rows[0]["PackageID"]);
                                        ObjLdgTnxDtl.NetItemAmt = 0;
                                        ObjLdgTnxDtl.TotalDiscAmt = 0;
                                        iCtr = 1;
                                    }
                                    else
                                    {
                                      //  decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(Item_ID),"I",con));
                                        decimal DiscPerc = 0;
                                        if (Resources.Resource.IsmembershipInIPD == "1")
                                        {
                                            if (Util.GetInt(PanelID) == 1)
                                            {
                                                if (MembershipNo != "")
                                                {
                                                    GetDiscount ds = new GetDiscount();
                                                    DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(Item_ID), MembershipNo, "IPD").Split('#')[0].ToString());
                                                }
                                                else
                                                {
                                                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                                }
                                            }
                                            else
                                            {
                                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                            }
                                        }
                                        else
                                        {
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                        }
                                        if (DiscPerc > 0)
                                        {
                                            decimal GrossAmt = Util.GetDecimal(TotalBillAmount);
                                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                            ObjLdgTnxDtl.Amount = NetAmount;
                                            ObjLdgTnxDtl.DiscountPercentage = DiscPerc;
                                            ObjLdgTnxDtl.DiscAmt = GrossAmt - NetAmount;
                                            ObjLdgTnxDtl.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                            ObjLdgTnxDtl.NetItemAmt = NetAmount;
                                            ObjLdgTnxDtl.DiscountReason = "Panel Wise Discount";
                                            ObjLdgTnxDtl.DiscUserID = User_ID;
                                            if(PanelID !=1)
                                            ObjLdgTnxDtl.isPanelWiseDisc = 1;
                                            iCtr = 1;
                                        }
                                        else
                                        {
                                            ObjLdgTnxDtl.DiscountPercentage = 0;
                                            ObjLdgTnxDtl.DiscAmt = (TotalBillAmount * DiscPerc) / 100;
                                            ObjLdgTnxDtl.Amount = Util.GetDecimal(TotalBillAmount);
                                            ObjLdgTnxDtl.TotalDiscAmt = (TotalBillAmount * DiscPerc) / 100;
                                            ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(TotalBillAmount);
                                            iCtr = 1;
                                        }
                                    }
                                }
                                else
                                {
                                    ObjLdgTnxDtl.Amount = 0;
                                    ObjLdgTnxDtl.DiscountPercentage = 0;
                                    ObjLdgTnxDtl.DiscAmt = 0;
                                    ObjLdgTnxDtl.IsPackage = 1;
                                    ObjLdgTnxDtl.PackageID = Util.GetString(dtPkg.Rows[0]["PackageID"]);
                                    ObjLdgTnxDtl.TotalDiscAmt = 0;
                                    ObjLdgTnxDtl.NetItemAmt = 0;
                                    iCtr = 1;
                                }
                            }
                        }
                    }
                    else
                    {
                     //   decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(Item_ID), "I", con));
                        decimal DiscPerc = 0;
                        if (Resources.Resource.IsmembershipInIPD == "1")
                        {
                            if (Util.GetInt(PanelID) == 1)
                            {
                                if (MembershipNo != "")
                                {
                                    GetDiscount ds = new GetDiscount();
                                    DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(Item_ID), MembershipNo, "IPD").Split('#')[0].ToString());
                                }
                                else
                                {
                                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                }
                            }
                            else
                            {
                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                            }
                        }
                        else
                        {
                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                        }
                        if (DiscPerc > 0)
                        {
                            decimal GrossAmt = Util.GetDecimal(TotalBillAmount);
                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                            ObjLdgTnxDtl.Amount = NetAmount;
                            ObjLdgTnxDtl.DiscountPercentage = DiscPerc;
                            ObjLdgTnxDtl.DiscAmt = GrossAmt - NetAmount;
                            ObjLdgTnxDtl.TotalDiscAmt = GrossAmt - NetAmount;
                            ObjLdgTnxDtl.NetItemAmt = NetAmount;
                            ObjLdgTnxDtl.DiscountReason = "Panel Wise Discount";
                            ObjLdgTnxDtl.DiscUserID = User_ID;
                            ObjLdgTnxDtl.isPanelWiseDisc = 1;
                        }
                        else
                        {
                            ObjLdgTnxDtl.DiscountPercentage = 0;
                            ObjLdgTnxDtl.DiscAmt = (TotalBillAmount * DiscPerc) / 100;
                            ObjLdgTnxDtl.Amount = Util.GetDecimal(TotalBillAmount);
                            ObjLdgTnxDtl.TotalDiscAmt = (TotalBillAmount * DiscPerc) / 100;
                            ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(TotalBillAmount);
                        }
                    }

                    ObjLdgTnxDtl.typeOfTnx = "IPD-Room-Shift";
                    ObjLdgTnxDtl.IsPayable = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                    ObjLdgTnxDtl.CoPayPercent=Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);


                    string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                    if (LdgTnxDtlID == "")
                    {
                        return "";
                    }

                    //Devendra Singh 2018-11-12 Insert Finance Integarion 
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedgerTransactionNo), "", "R", Tnx));
                        if (IsIntegrated == "0")
                        {
                            Tnx.Rollback();
                            Tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return "";
                        }
                    }
                }
                else
                {
                    return "";
                }
            }
            else
            {
                return "1";
            }


            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }

    }

    public string GetRoomItemDetails(string PanelID, string IPDCaseTypeID, int ScheduleChargeID)
    {
        string sql = "SELECT CONCAT(t1.ItemID,'#',IF(t1.Rate IS NULL,0,t1.Rate),'#',t1.SubCategoryID,'#',t1.BufferTime,'#',IFNULL(t1.ID,0))DATA " +
                     "FROM (" +
                     "      SELECT CONCAT(im.ItemID,'#',im.TypeName)ItemID,rt.Rate,im.SubCategoryID,im.BufferTime,rt.ID " +
                     "      FROM f_itemmaster im LEFT JOIN (" +
                     "              SELECT ID,Rate,ItemID FROM f_ratelist_ipd WHERE PanelID='" + PanelID + "' " +
                     "              AND IPDCaseTypeID = '" + IPDCaseTypeID + "' AND ScheduleChargeID='" + ScheduleChargeID + "' AND IsCurrent=1 " +
                     "      )  rt ON rt.ItemID = im.ItemID INNER JOIN f_subcategorymaster sc ON " +
                     "      sc.SubCategoryID = im.SubCategoryID INNER JOIN f_configrelation cf " +
                     "      ON cf.CategoryID = sc.CategoryID WHERE im.Type_ID = '" + IPDCaseTypeID + "' AND cf.ConfigID=2 " +
                     ")t1";
        return StockReports.ExecuteScalar(sql);
    }



    protected void grdRoomDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (((Label)e.Row.FindControl("lblStatus")).Text.ToString().Trim() == "OUT")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF99CC");
            }
            else
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#99FFCC");
            }
        }
    }


  
    protected void rbtSample_SelectedIndexChanged(object sender, EventArgs e)
    {
        SearchPendingRequest();
    }
    private void SearchPendingRequest()
    {
        StringBuilder sb = new StringBuilder();

        if (rbtSample.SelectedValue == "P")
        {
            sb.Append(" SELECT REPLACE(pmh.TransNo,'ISHHI','')IPDNo,pm.PatientID as  MRNo,pm.PName, ");
            sb.Append(" (SELECT ictm.Name FROM ipd_case_type_master ictm WHERE ictm.IPDCaseTypeID=prs.IPDCaseType_ID)CurrentRoomType, ");
            sb.Append(" (SELECT CONCAT(rm.Name,'/',rm.Bed_No) FROM room_master rm WHERE rm.`RoomId`=prs.room_id)CurrentRoom,  ");
            sb.Append(" (SELECT ictm.Name FROM ipd_case_type_master ictm WHERE ictm.IPDCaseTypeID=prs.Requested_IPDCaseType_ID)RequestedRoomType, ");
            sb.Append(" (SELECT CONCAT(rm.Name,'/',rm.Bed_No) FROM room_master rm WHERE rm.`RoomId`=prs.Requested_RoomId)RequestedRoom,  ");
            sb.Append(" CONCAT(DATE_FORMAT(prs.Request_dateTime,'%d-%b-%Y'),' ',TIME_FORMAT(prs.Request_dateTime,'%h:%i %p'))RequestTime,");
            sb.Append(" (SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=prs.Requested_By)RequestedBy,'True' CanReject,prs.Remarks");
            sb.Append(" FROM patient_roomshift_request prs  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON prs.Transaction_ID=pmh.TransactionID  ");
            sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
            sb.Append(" WHERE  IsApprove=0 and prs.Transaction_ID='" + ViewState["Transaction_ID"].ToString() + "'");
        }
        else if (rbtSample.SelectedValue == "A")
        {
            sb.Append(" SELECT REPLACE(pmh.TransNo,'ISHHI','')IPDNo,pm.PatientID as  MRNo,pm.PName, ");
            sb.Append(" (SELECT ictm.Name FROM ipd_case_type_master ictm WHERE ictm.IPDCaseTypeID=prs.IPDCaseType_ID)CurrentRoomType, ");
            sb.Append(" (SELECT CONCAT(rm.Name,'/',rm.Bed_No) FROM room_master rm WHERE rm.`RoomId`=prs.room_id)CurrentRoom,  ");
            sb.Append(" (SELECT ictm.Name FROM ipd_case_type_master ictm WHERE ictm.IPDCaseTypeID=prs.Requested_IPDCaseType_ID)RequestedRoomType, ");
            sb.Append(" (SELECT CONCAT(rm.Name,'/',rm.Bed_No) FROM room_master rm WHERE rm.`RoomId`=prs.Requested_RoomId)RequestedRoom,  ");
            sb.Append(" CONCAT(DATE_FORMAT(prs.Request_dateTime,'%d-%b-%Y'),' ',TIME_FORMAT(prs.Request_dateTime,'%h:%i %p'))RequestTime,");
            sb.Append(" (SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=prs.Requested_By)RequestedBy,'False' CanReject,prs.Remarks");
            sb.Append(" FROM patient_roomshift_request prs  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON prs.Transaction_ID=pmh.TransactionID  ");
            sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
            sb.Append(" WHERE  IsApprove=1 and prs.Transaction_ID='" + ViewState["Transaction_ID"].ToString() + "'");
        }
        else
        {
            sb.Append(" SELECT REPLACE(pmh.TransNo,'ISHHI','')IPDNo,pm.PatientID as  MRNo,pm.PName, ");
            sb.Append(" (SELECT ictm.Name FROM ipd_case_type_master ictm WHERE ictm.IPDCaseTypeID=prs.IPDCaseType_ID)CurrentRoomType, ");
            sb.Append(" (SELECT CONCAT(rm.Name,'/',rm.Bed_No) FROM room_master rm WHERE rm.`RoomId`=prs.room_id)CurrentRoom,  ");
            sb.Append(" (SELECT ictm.Name FROM ipd_case_type_master ictm WHERE ictm.IPDCaseTypeID=prs.Requested_IPDCaseType_ID)RequestedRoomType, ");
            sb.Append(" (SELECT CONCAT(rm.Name,'/',rm.Bed_No) FROM room_master rm WHERE rm.`RoomId`=prs.Requested_RoomId)RequestedRoom,  ");
            sb.Append(" CONCAT(DATE_FORMAT(prs.Request_dateTime,'%d-%b-%Y'),' ',TIME_FORMAT(prs.Request_dateTime,'%h:%i %p'))RequestTime,");
            sb.Append(" (SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=prs.Requested_By)RequestedBy,'False' CanReject,prs.Remarks");
            sb.Append(" FROM patient_roomshift_request prs  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON prs.Transaction_ID=pmh.TransactionID  ");
            sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
            sb.Append(" WHERE  IsApprove=3 and prs.Transaction_ID='" + ViewState["Transaction_ID"].ToString() + "'");
        }

        DataTable dtRequisition = StockReports.GetDataTable(sb.ToString());
        if (dtRequisition != null && dtRequisition.Rows.Count > 0)
        {
            grdRequestSearch.DataSource = dtRequisition;
            grdRequestSearch.DataBind();
        }
        else
        {
            grdRequestSearch.DataSource = null;
            grdRequestSearch.DataBind();
        }
    }


    protected void grdRequestSearch_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtCancelReason.Text = "";
        mpDetail.Show();
    }

    protected void grdRequestSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCanReject")).Text == "True")
            {
                grdRequestSearch.Columns[10].Visible = true;
                grdRequestSearch.Columns[11].Visible = false;
            }
            else
            {
                grdRequestSearch.Columns[10].Visible = false;
                grdRequestSearch.Columns[11].Visible = true;
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            if (txtCancelReason.Text.Trim() == "")
            {
                lblmsgpopup.Text = "Please Enter Cancel Reason";
                txtCancelReason.Focus();
                mpDetail.Show();
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE patient_roomshift_request SET isapprove=3, `Req_Approved_By`= '" + ViewState["ID"] + "' , `Req_Approved_DateTime`= NOW(),Remarks= '" + txtCancelReason.Text + "' WHERE transaction_id='" + ViewState["Transaction_ID"] + "' AND isapprove=0 ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            Tranx.Commit();
            mpDetail.Hide();
            lblmsg.Text = "Request Canecelled Successfully";
            SearchPendingRequest();
        }
        catch (Exception ex)
        {
            lblmsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

   
    private bool SaveRoomRequestData()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction Tnx = conn.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        string query = " SELECT COUNT(*) FROM patient_roomshift_request WHERE transaction_id='" + lblTransactionNo.Text + "' AND isapprove=0 ";
        int count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, query));
        if (count > 0)
        {
            lblmsg.Text = "Previous Room Request is already Pending.Please look at that first.";
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Previous Room Request is already Pending.Please look at that first.')", true);
            return false;
        }

        try
        {
            string SiftDate = Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd");
            string SiftTime = Util.GetDateTime(((TextBox)txtDate.FindControl("txtTime")).Text).ToString("HH:mm:ss");

            string IPDCaseType_ID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, " SELECT IPDCaseType_ID FROM patient_ipd_profile where Transaction_ID='" + lblTransactionNo.Text + "' and Status='IN' "));

            string RoomId = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, " SELECT Room_ID FROM patient_ipd_profile where Transaction_ID='" + lblTransactionNo.Text + "' and Status='IN' "));

            /*  string str = "Update patient_ipd_profile Set ";
              str += "EndDate='" + SiftDate + "',";
              str += "EndTime='" + SiftTime + "',";
              str += "Status='OUT',TobeBill=0,UserID='" + ViewState["ID"] + "' ";
              str += "Where Transaction_ID='" + lblTransactionNo.Text + "' and Status='IN'";
              MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

              Patient_IPD_Profile objIPD = new Patient_IPD_Profile(Tnx);
              objIPD.Transaction_ID = lblTransactionNo.Text;
              objIPD.TobeBill = 1;
              objIPD.StartDate = Util.GetDateTime(SiftDate);
              objIPD.StartTime = Util.GetDateTime(SiftTime);
              objIPD.IPDCaseType_ID = cmbRoomType.SelectedItem.Value;

              if (ddlBillCategory.SelectedItem.Text.ToUpper() == "SELECT")
              {
                  str = "select BillingCategoryID from ipd_case_type_master where IPDCaseType_ID='" + cmbRoomType.SelectedValue + "' ";
                  string BillingCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, str));

                  objIPD.IPDCaseType_ID_Bill = BillingCategoryID;
                  ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(BillingCategoryID));
              }
              else
                  objIPD.IPDCaseType_ID_Bill = ddlBillCategory.SelectedItem.Value;


              objIPD.Room_ID = cmbAvailRooms.SelectedItem.Value;
              objIPD.PanelID = Util.GetInt(lblPanel_ID.Text);
              objIPD.PatientID = lblPatientID.Text;
              objIPD.Status = "IN";
              objIPD.CentreID = Util.GetInt(Session["CentreID"].ToString());
              objIPD.Hospital_Id = Session["HOSPID"].ToString();

              objIPD.Insert();

              string RoomDetail = GetRoomItemDetails(lblPanel_ID.Text.Trim(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ViewState["ScheduleChargeID"]));

              //For requested room type
              string query = "SELECT COUNT(*) FROM ipd_case_history WHERE Transaction_ID='" + lblTransactionNo.Text + "' AND RequestedRoomType='" + cmbRoomType.SelectedItem.Value + "' AND IsRoomRequest='1' ";
              int count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, query));
              if (count > 0)
              {
                  query = "UPDATE ipd_case_history SET IsRoomRequest='2',LastUpdatedBy='" + Util.GetString(ViewState["ID"]) + "',UpdateDate=NOW() WHERE Transaction_ID='" + lblTransactionNo.Text + "' ";
                  MySqlHelper.ExecuteScalar(conn, CommandType.Text, query);
                  All_LoadData.updateNotification(cmbRoomType.SelectedItem.Value, "", "", 22, Tnx);
              } */

            string BillingCategoryID = "";
            if (ddlBillCategory.SelectedItem.Text.ToUpper() == "SELECT")
            {


                string str = "select BillingCategoryID from ipd_case_type_master where IPDCaseType_ID='" + cmbRoomType.SelectedValue + "' ";
                BillingCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, str));
            }
            else
                BillingCategoryID = ddlBillCategory.SelectedItem.Value;

            string sqlQuery = "INSERT INTO patient_roomshift_request(Transaction_ID,PatientID,IPDCaseType_ID,Room_ID,Requested_IPDCaseType_ID,Requested_RoomId,IPDCaseType_ID_Bill,StartDate,StartTime,EndDate,EndTime,Requested_By,Request_dateTime) VALUES (@Transaction_ID, @PatientID, @IPDCaseType_ID, @Room_ID, @Requested_IPDCaseType_ID, @Requested_RoomId,@IPDCaseType_ID_Bill,@StartDate,@StartTime,@EndDate,@EndTime, @Requested_By, @Request_dateTime)";

            excuteCMD.DML(Tnx, sqlQuery, CommandType.Text, new
            {
                Transaction_ID = lblTransactionNo.Text,
                PatientID = lblPatientID.Text,
                IPDCaseType_ID = IPDCaseType_ID,
                Room_ID = RoomId,
                Requested_IPDCaseType_ID = ddlBillCategory.SelectedItem.Value,
                Requested_RoomId = cmbAvailRooms.SelectedItem.Value,
                IPDCaseType_ID_Bill = BillingCategoryID,
                StartDate = SiftDate,
                StartTime = SiftTime,
                EndDate = SiftDate,
                EndTime = SiftTime,
                Requested_By = Util.GetString(ViewState["ID"]),
                Request_dateTime = SiftDate + ' ' + SiftTime
            });

            Tnx.Commit();
            lblmsg.Text = "Room Shift Request Send Successfully";

            BindRoomDetails(lblTransactionNo.Text);
            return true;
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            lblmsg.Text = "Opps!! Something Wrong. Check and Send Again. ";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            Tnx.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }
}
