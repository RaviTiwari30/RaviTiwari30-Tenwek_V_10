using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Web.Services;

public partial class Design_Doctor_DoctorEdit : System.Web.UI.Page
{
    private DataTable dtTime;

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (txtName.Text.Trim() == "")
        {
            lblerrmsg.Text = "Please Enter Doctor Name";
            txtName.Focus();
            return;
        }
        if (ddldoctorgroup.SelectedIndex == 0)
        {
            lblerrmsg.Text = "Please Select Doctor Group";
            ddldoctorgroup.Focus();
            return;
        }
        if (ddlSpecial.SelectedIndex == 0)
        {
            lblerrmsg.Text = "Please Select Doctor Specialization";
            ddlSpecial.Focus();
            return;
        }
        if (cmbDept.SelectedIndex == 0)
        {
            lblerrmsg.Text = "Please Select Doctor Department";
            cmbDept.Focus();
            return;
        }
        if (grdTime.Rows == null || grdTime.Rows.Count == 0)
        {
            lblerrmsg.Text = "Please Specify Day Or Date of OPD Timings";
            if (rbtnType.SelectedValue == "1")
            {
                chkMon.Focus();
            }
            else
            {
                txtDate.Focus();
            }
            return;
        }

        int iFlag = 0;

        if (chkMon.Checked == true || chkMon.Checked == true || chkTues.Checked == true || chkWed.Checked == true || chkThur.Checked == true || chkFri.Checked == true || chkSat.Checked == true || chkSun.Checked == true)
            iFlag = 1;

        if (grdTime.Rows.Count == 0 && iFlag == 0)
        {
            lblerrmsg.Text = "Please Specify Day of OPD Timings";
            return;
        }
        string isShare = rblDocShare.SelectedValue;
        string docGroup = ddldoctorgroup.SelectedValue;

        DropCache();
        SaveDetail(docGroup);

    }

    protected void btntimings_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        try
        {
            if (chkMon.Checked == true || chkTues.Checked == true || chkWed.Checked == true || chkThur.Checked == true || chkFri.Checked == true || chkSat.Checked == true || chkSun.Checked == true)
            {
                if (ViewState["dtTime"] != null)
                {
                    dtTime = ((DataTable)ViewState["dtTime"]);
                }
                else
                {
                    DataTable dtNew = new DataTable();
                    dtNew.Columns.Add("Day");
                    dtNew.Columns.Add("StartTime");
                    dtNew.Columns.Add("EndTime");
                    dtNew.Columns.Add("AvgTime");
                    dtNew.Columns.Add("DurationforNewPatient");
                    dtNew.Columns.Add("StartBufferTime");
                    dtNew.Columns.Add("EndBufferTime");
                    dtNew.Columns.Add("DurationforOldPatient");
                    dtNew.Columns.Add("Date");
                    dtNew.Columns.Add("IsRepeat");
                    dtNew.Columns.Add("ShiftName");
                    dtNew.Columns.Add("CentreName");
                    dtNew.Columns.Add("CentreID");
                    dtTime = dtNew;
                }

                DateTime EndTime = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
                DateTime StartTime = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());

                int StartBT = Util.GetInt(txtStartBT.Text.Trim());
                int EndBT = Util.GetInt(txtEndBT.Text.Trim());

                // Devendra Singh 2018-09-26 , Replace function ValidateItems to ValidateItemsNew for multiple doctor shifting.

                if (chkMon.Checked == true)
                {
                    if (ValidateItemsNew("Monday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Monday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }
                if (chkTues.Checked == true)
                {
                    if (ValidateItemsNew("Tuesday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Tuesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }
                if (chkWed.Checked == true)
                {
                    if (ValidateItemsNew("Wednesday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Wednesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }
                if (chkThur.Checked == true)
                {
                    if (ValidateItemsNew("Thursday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Thursday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }
                if (chkFri.Checked == true)
                {
                    if (ValidateItemsNew("Friday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Friday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }
                if (chkSat.Checked == true)
                {
                    if (ValidateItemsNew("Saturday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Saturday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }
                if (chkSun.Checked == true)
                {
                    if (ValidateItemsNew("Sunday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Sunday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                    }
                }

                grdTime.DataSource = dtTime;
                grdTime.DataBind();
                if (ViewState["dtTime"] != null)
                {
                    ViewState["dtTime"] = dtTime;
                }
                else
                {
                    ViewState.Add("dtTime", dtTime);
                }
            }
            else
            {
                if (rbtnType.SelectedItem.Value == "2")
                {
                    lblerrmsg.Text = "";
                    if (txtDate.Text.Trim() == "")
                    {
                        lblerrmsg.Text = "Select Date";
                        return;

                    }
                    else
                    {

                        //Devendra Singh 2018-09-26 For Multiple Visit
                        DateTime EndTime = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
                        DateTime StartTime = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());
                        for (int i = 0; i < grdTime.Rows.Count; i++)
                        {
                            DateTime IsRepeat = Util.GetDateTime(((Label)grdTime.Rows[i].FindControl("lblDate")).Text.ToString());
                            DateTime StartDateTime = Util.GetDateTime(((Label)grdTime.Rows[i].FindControl("lblStartTime")).Text.ToString());
                            DateTime EndDateTime = Util.GetDateTime(((Label)grdTime.Rows[i].FindControl("lblEndTime")).Text.ToString());

                            if (Util.GetDateTime(txtDate.Text) == IsRepeat)
                            {
                                if ((StartDateTime >= StartTime && EndTime >= StartDateTime) || (EndDateTime >= StartTime && EndTime >= EndDateTime))
                                {
                                    lblerrmsg.Text = "Selected Time Period Already Exist in Same Days.";
                                    return;
                                }

                            }

                        }

                        if (ViewState["dtTime"] != null)
                        {
                            dtTime = ((DataTable)ViewState["dtTime"]);
                        }
                        else
                        {
                            DataTable dtNew = new DataTable();
                            dtNew.Columns.Add("Day");
                            dtNew.Columns.Add("StartTime");
                            dtNew.Columns.Add("EndTime");
                            dtNew.Columns.Add("AvgTime");
                            dtNew.Columns.Add("DurationforNewPatient");
                            dtNew.Columns.Add("StartBufferTime");
                            dtNew.Columns.Add("EndBufferTime");
                            dtNew.Columns.Add("DurationforOldPatient");
                            dtNew.Columns.Add("Date");
                            dtNew.Columns.Add("IsRepeat");
  						    dtNew.Columns.Add("ShiftName");
                            dtNew.Columns.Add("CentreName");
                            dtNew.Columns.Add("CentreID");
                            dtTime = dtNew;
                        }

                    
                        string avgtime = ddlduration.SelectedValue.ToString().Trim();
                        string DurationforOldPatient = ddldurationOld.SelectedValue.ToString().Trim();
                        string DurationforNewPatient = ddlduration.SelectedValue.ToString().Trim();
                        int StartBT = Util.GetInt(txtStartBT.Text.Trim());
                        int EndBT = Util.GetInt(txtEndBT.Text.Trim());
                        dtTime = AddTime(txtDate.Text.Trim(), StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), ddlduration.SelectedValue.ToString().Trim(), StartBT, EndBT, ddldurationOld.SelectedValue.ToString(), dtTime);
                        //dtTime = AddTime(txtDate.Text.Trim(), StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);

                        if (ViewState["dtTime"] != null)
                        {
                            ViewState["dtTime"] = dtTime;
                        }
                        else
                        {
                            ViewState.Add("dtTime", dtTime);
                        }

                        grdTime.DataSource = dtTime;
                        grdTime.DataBind();
                        EnableDisableSchedueType();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdTime_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (ViewState["dtTime"] != null)
        {
            dtTime = ((DataTable)ViewState["dtTime"]);
        }

        string Day = dtTime.Rows[e.RowIndex]["Day"].ToString();

        switch (Day)
        {
            case "Monday":
                chkMon.Checked = false;
                break;

            case "Tuesday":
                chkTues.Checked = false;
                break;

            case "Wednesday":
                chkWed.Checked = false;
                break;

            case "Thursday":
                chkThur.Checked = false;
                break;

            case "Friday":
                chkFri.Checked = false;
                break;

            case "Saturday":
                chkSat.Checked = false;
                break;

            case "Sunday":
                chkSun.Checked = false;
                break;
        }

        dtTime.Rows.RemoveAt(e.RowIndex);
        ViewState["dtTime"] = dtTime as DataTable;
        grdTime.DataSource = dtTime;
        grdTime.DataBind();

        DataRow[] drDay = dtTime.Select("Day='" + Day + "'");
        if (drDay.Length > 0)
        {
            switch (Day)
            {
                case "Monday":
                    chkMon.Checked = true;
                    break;

                case "Tuesday":
                    chkTues.Checked = true;
                    break;

                case "Wednesday":
                    chkWed.Checked = true;
                    break;

                case "Thursday":
                    chkThur.Checked = true;
                    break;

                case "Friday":
                    chkFri.Checked = true;
                    break;

                case "Saturday":
                    chkSat.Checked = true;
                    break;

                case "Sunday":
                    chkSun.Checked = true;
                    break;
            }
        }
        EnableDisableSchedueType();
    }
    private void EnableDisableSchedueType()
    {
        if (grdTime.Rows.Count > 0)
        {
            rbtnType.Enabled = false;
            chkRepeat.Checked = false;
        }
        else
        {
            rbtnType.Enabled = true;

        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtName.Focus();
            BindDocFloor();
            All_LoadData.bindDocTypeList(ddlSpecial, 3, "Select");
            All_LoadData.bindDocTypeList(cmbDept, 5, "Select");
            txtNotAvailableDateFrom.Text = txtNotAvailableDateTo.Text = Util.GetDateTime(System.DateTime.Now.AddDays(1)).ToString("dd-MMM-yyyy");
            Binddoctorgroup();
            BindCentre();
            BindDocTimingShift();
            bindCadre();
            bindTier();
            if (Request.QueryString["DID"] != "")
            {
                BindDoctorDetail(Request.QueryString["DID"]);
                ViewState["DID"] = Request.QueryString["DID"].ToString();
                BindDoctorNotAvailable();
                DisableDocDetail();
            }           
        }
        txtDate.Attributes.Add("readOnly", "true");
        txtNotAvailableDateFrom.Attributes.Add("readonly", "true");
        txtNotAvailableDateTo.Attributes.Add("readonly", "true");
        txtDate_CalendarExtender.StartDate = DateTime.Now;
        cdNAFrom.StartDate = cdNATo.StartDate = DateTime.Now.AddDays(1);       
    }
    private void bindTier()
    {
        DataTable dt = StockReports.GetDataTable("select ID,TierName from employee_tier_master WHERE Active=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlTier.DataSource = dt;
            ddlTier.DataValueField = "ID";
            ddlTier.DataTextField = "TierName";
            ddlTier.DataBind();
            ddlTier.Items.Insert(0, new ListItem("Select", "0"));

        }
    }

    private void bindCadre()
    {
        DataTable dt = StockReports.GetDataTable("select ID,CadreName from employee_cadre_master WHERE Active=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCadre.DataSource = dt;
            ddlCadre.DataValueField = "ID";
            ddlCadre.DataTextField = "CadreName";
            ddlCadre.DataBind();
            ddlCadre.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    private void BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCentre.DataSource = dt;
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataTextField = "CentreName";
            ddlCentre.DataBind();

            ddlNACentre.DataSource = dt;
            ddlNACentre.DataValueField = "CentreID";
            ddlNACentre.DataTextField = "CentreName";
            ddlNACentre.DataBind();         
        } 
    }

    private void DisableDocDetail()
    {
        string roleid = Util.GetString(Session["RoleID"]);
        if (roleid == "342")
        {
            cmbTitle.Attributes.Add("disabled", "disabled");
            txtName.Enabled = false;
            ddldoctorgroup.Attributes.Add("disabled", "disabled");
            txtPhone1.Enabled = false;
            TxtMobileNo.Enabled = false;
            txtAdd.Enabled = false;
            ddlSpecial.Attributes.Add("disabled", "disabled");
            cmbDept.Attributes.Add("disabled", "disabled");
            txtDocDegree.Enabled=false;
            rblDocShare.Enabled = false;   
            rblIsAvailableEmergency.Enabled = false;                    
        }    
    }


    private void BindDocTimingShift()
    {
        ddlDocTimingShift.DataSource = StockReports.GetDataTable("SELECT Id,ShiftName FROM VisitShift_master ORDER BY id ");
        ddlDocTimingShift.DataValueField = "Id";
        ddlDocTimingShift.DataTextField = "ShiftName";
        ddlDocTimingShift.DataBind();
    }

    protected void SaveDetail(string docGroup)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
          ExcuteCMD excuteCMD = new ExcuteCMD();
        

        string returnStr = "";
        string HospID = Convert.ToString(Session["HOSPID"]);
        string Dept = cmbDept.SelectedItem.Text;

        try
        {
            string DocId = ViewState["DID"].ToString();

            if (docGroup == "4")
            {
                UpdateDoctorUnit(DocId, con);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "SaveDocShareUnit('" + DocId + "');", true);
            }

            if (hfType.Value.ToString() == "1")
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update doctor_master set Title='" + cmbTitle.SelectedItem.Text + "',Name='" + txtName.Text.Trim() + "',Specialization='" + ddlSpecial.SelectedItem.Text + "',Phone1='" + txtPhone1.Text.Trim() + "',Mobile='" + TxtMobileNo.Text.Trim() + "',Street_Name='" + txtAdd.Text.Trim() + "',DocGroupId='" + ddldoctorgroup.SelectedItem.Value + "',Designation='" + cmbDept.SelectedItem.Text + "',DocDepartmentID='" + cmbDept.SelectedItem.Value + "',LastUpdatedBy='" + Session["ID"].ToString() + "',UpdateDate=now(),Degree='" + txtDocDegree.Text.Trim() + "',IsDocShare='" + Util.GetInt(rblDocShare.SelectedItem.Value.Trim()) + "',IsEmergencyAvailable=" + Util.GetInt(rblIsAvailableEmergency.SelectedItem.Value) + ",IsUnit=1,DocDateTime='" + txtDoctorTiminig.Text.Trim() + "',Cadreid='" + ddlCadre.SelectedItem.Value + "', TierID='"+ddlTier.SelectedItem.Value+"' where DoctorID='" + ViewState["DID"].ToString() + "'");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update doctor_master set Title='" + cmbTitle.SelectedItem.Text + "',Name='" + txtName.Text.Trim() + "',Specialization='" + ddlSpecial.SelectedItem.Text + "',Phone1='" + txtPhone1.Text.Trim() + "',Mobile='" + TxtMobileNo.Text.Trim() + "',Street_Name='" + txtAdd.Text.Trim() + "',DocGroupId='" + ddldoctorgroup.SelectedItem.Value + "',Designation='" + cmbDept.SelectedItem.Text + "',DocDepartmentID='" + cmbDept.SelectedItem.Value + "',LastUpdatedBy='" + Session["ID"].ToString() + "',UpdateDate=now(),Degree='" + txtDocDegree.Text.Trim() + "',IsDocShare='" + Util.GetInt(rblDocShare.SelectedItem.Value.Trim()) + "',IsEmergencyAvailable=" + Util.GetInt(rblIsAvailableEmergency.SelectedItem.Value) + ",DocDateTime='" + txtDoctorTiminig.Text.Trim() + "' ,Cadreid='" + ddlCadre.SelectedItem.Value + "', TierID='" + ddlTier.SelectedItem.Value + "' where DoctorID='" + ViewState["DID"].ToString() + "'");
            }

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update doctor_master set isSlotWiseToken= " + Util.GetInt(rdoIsSlotWiseToken.SelectedValue) + " where DoctorID=" + ViewState["DID"].ToString() + " ");

            ///Update Doctor Name in ItemMaster
            string UpdateItemMaster = "update f_configrelation c inner join f_subcategorymaster sc on sc.CategoryID = c.CategoryID " +
            " inner join f_itemmaster im on im.SubCategoryID = sc.SubCategoryID " +
            "   set im.TypeName = '" + txtName.Text.Trim() + "',im.LastUpdatedBy='" + Session["ID"].ToString() + "',im.UpdateDate=Now() where ConfigID=5 and im.Type_ID='" + ViewState["DID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, UpdateItemMaster);

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update doctor_hospital set Department='" + cmbDept.SelectedItem.Text + "',StartBufferTime= " + Util.GetInt(txtStartBT.Text.Trim()) + ",EndBufferTime=" + Util.GetInt(txtEndBT.Text.Trim()) + "  where DoctorID='" + ViewState["DID"].ToString() + "'");

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from doctor_hospital where DoctorID='" + ViewState["DID"].ToString() + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from doctor_hospital_SlotMaster where DoctorID='" + ViewState["DID"].ToString() + "'");

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from Doctor_TimingDateWise where DoctorID='" + ViewState["DID"].ToString() + "'");

            if (grdTime.Rows.Count == 0)
            {
                DateTime EndTime = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
                DateTime StartTime = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());
                int AvgTime = Convert.ToInt32(ddlduration.SelectedValue.ToString().Trim());
                int DurationforNewPatient = Convert.ToInt32(ddlduration.SelectedValue.ToString().Trim());
                int DurationforOldPatient = Convert.ToInt32(ddldurationOld.SelectedValue.ToString().Trim());
                int StartBT = Util.GetInt(txtStartBT.Text.Trim());
                int EndBT = Util.GetInt(txtEndBT.Text.Trim());
                string VisitName = ddlDocTimingShift.SelectedItem.Text;
                int CentreID = Util.GetInt(ddlNACentre.SelectedItem.Value);
                if (chkMon.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Monday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkTues.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Tuesday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkWed.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Wednesday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkThur.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Thursday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkFri.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Friday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkSat.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Saturday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkSun.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Sunday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, DurationforNewPatient, StartBT, EndBT, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
            }
            else
            {
                //delete doctor datewise timing
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "delete from Doctor_TimingDateWise where DoctorID='" + ViewState["DID"].ToString() + "'");
                for (int i = 0; i < grdTime.Rows.Count; i++)
                {
                    DateTime EndTime = Util.GetDateTime(grdTime.Rows[i].Cells[3].Text);
                    DateTime StartTime = Util.GetDateTime(grdTime.Rows[i].Cells[2].Text);
                    string Day = grdTime.Rows[i].Cells[1].Text;
                    int AvgTime = Convert.ToInt32(grdTime.Rows[i].Cells[4].Text.ToString().Trim());
                    int DurationforOldPatient = Convert.ToInt32(((Label)grdTime.Rows[i].FindControl("lblDurationforOldPatient")).Text.ToString().Trim());
                    int StartBT = Util.GetInt(grdTime.Rows[i].Cells[5].Text);
                    int EndBT = Util.GetInt(grdTime.Rows[i].Cells[6].Text);
                    int DurationforNewPatient = Convert.ToInt32(grdTime.Rows[i].Cells[4].Text.ToString().Trim());
                    int IsRepeat = Convert.ToInt32(((Label)grdTime.Rows[i].FindControl("lblRepeat")).Text.ToString().Trim());
                    string Date = ((Label)grdTime.Rows[i].FindControl("lblDate")).Text.ToString().Trim();
                    string VisitName = ((Label)grdTime.Rows[i].FindControl("lblShiftName")).Text.ToString().Trim();
                    int CentreID = Util.GetInt(((Label)grdTime.Rows[i].FindControl("lblCentreID")).Text.ToString().Trim());
                    if (rbtnType.SelectedItem.Value == "1")
                    {
                        returnStr = saveData(ViewState["DID"].ToString(), Day, HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                        if (returnStr == "0")
                        {
                            tranX.Rollback();
                            return;
                        }
                            // to save Doctor slots token wise
              

                            int tokenno = 1;
                          


                            DateTime startDateTime = Util.GetDateTime(StartTime);
                            DateTime endDateTime = Util.GetDateTime(EndTime);

                            while (startDateTime < endDateTime)
                            {
                                var slot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationforNewPatient).ToString("hh:mm tt");

                                string sqlCMD1 = "INSERT INTO doctor_hospital_SlotMaster (DoctorID,DoctorName,Day,StartTime,EndTime,Duration,StartEndTimeSlot,ShiftName,CentreID,TokenNo) "
                               + "VALUES(@DoctorID,@DoctorName,@Day,@StartTime,@EndTime,@DurationforPatient,@StartEndTimeSlot,@VisitName,@CentreID,@TokenNo)";

                                excuteCMD.DML(tranX, sqlCMD1, CommandType.Text, new
                                {
                                    DoctorID = ViewState["DID"].ToString(),
                                    DoctorName = cmbTitle.SelectedItem.Text + txtName.Text.Trim(),
                                    Day = Day,
                                    StartTime = startDateTime,
                                    EndTime = startDateTime.AddMinutes(DurationforNewPatient),
                                    DurationforPatient = DurationforNewPatient,
                                    StartEndTimeSlot = slot,
                                    VisitName = VisitName,
                                    CentreID = Util.GetString(Session["CentreID"]),
                                    TokenNo = tokenno
                                });
                                startDateTime = startDateTime.AddMinutes(DurationforNewPatient);
                                tokenno++;
                            }
                        }
                    else
                    {

                        //Doctor schedue Date wise save
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO Doctor_TimingDateWise(DoctorID,DATE,IsRepeat,DurationforOldPatient,DurationforNewPatient,StartTime,EndTime,DocFloor,Room_No,ShiftName,CentreID)VALUES('" + ViewState["DID"].ToString() + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'," + IsRepeat + ",'" + DurationforOldPatient + "','" + DurationforNewPatient + "','" + Util.GetDateTime(StartTime).ToString("HH:mm:ss") + "','" + Util.GetDateTime(EndTime).ToString("HH:mm:ss") + "','" + Util.GetString(ddlDocFloor.SelectedItem.Text) + "','" + txtRoomNo.Text.Trim() + "','" + Util.GetString(VisitName) + "'," + Util.GetInt(CentreID) + ")");
                    }
                }
            }

            // Devendra Singh 06-Oct-2018 For Doctor Not-Availability
            for (int i = 0; i < grdNATiming.Rows.Count; i++)
            {
                string Date = ((Label)grdNATiming.Rows[i].FindControl("lblNADate")).Text;
                string DayValue = ((Label)grdNATiming.Rows[i].FindControl("lblDayValue")).Text;
                DateTime StartTime = Convert.ToDateTime(((TextBox)grdNATiming.Rows[i].FindControl("txtNAHr1")).Text.Trim() + ":" + ((TextBox)grdNATiming.Rows[i].FindControl("txtNAMin1")).Text.Trim() + ((DropDownList)grdNATiming.Rows[i].FindControl("cmbNAAMPM1")).SelectedItem.Text.Trim());
                DateTime EndTime = Convert.ToDateTime(((TextBox)grdNATiming.Rows[i].FindControl("txtNAHr2")).Text.Trim() + ":" + ((TextBox)grdNATiming.Rows[i].FindControl("txtNAMin2")).Text.Trim() + ((DropDownList)grdNATiming.Rows[i].FindControl("cmbNAAMPM2")).SelectedItem.Text.Trim());
                int CentreID = Util.GetInt(((Label)grdNATiming.Rows[i].FindControl("lblNACentreID")).Text.ToString().Trim());
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " UPDATE doctor_notavailable_datewise SET isActive=0,UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDatetime=NOW() WHERE `Date`='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND isActive=1 AND CentreID=" + CentreID + " AND DoctorID='" + ViewState["DID"].ToString() + "' ");
                   
                if (((CheckBox)grdNATiming.Rows[i].FindControl("chkSelect")).Checked)
                {
                     MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO doctor_notavailable_datewise(DoctorID,`Date`,`Day`,FromTime,ToTime,CreatedBy,CreatedDate,CentreID) VALUES('" + ViewState["DID"].ToString() + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "','" + DayValue + "','" + StartTime.ToString("HH:mm:ss") + "','" + EndTime.ToString("HH:mm:ss") + "','" + Session["ID"].ToString() + "',now()," + CentreID + ")");
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT t.Company_Name,t.PanelID,t.ReferenceCode,t.ReferenceCodeOPD,rs.ScheduleChargeID   FROM ");
            sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD  ");
            sb.Append(" FROM f_panel_master WHERE PanelID IN ( ");
            sb.Append(" SELECT DISTINCT(ReferenceCodeOPD) FROM f_panel_master) ");
            sb.Append(" )t  INNER JOIN f_rate_schedulecharges rs ON rs.panelid =t.PanelID WHERE rs.IsDefault=1 ");
            sb.Append("  ORDER BY t.Company_Name ");
            DataTable dtPanel = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

            if (chkDoctorGroupRate.Checked)
            {
                StringBuilder sb2 = new StringBuilder();
                sb2.Append("  SELECT  Rate,  ItemID FROM (SELECT  im.*  FROM f_itemmaster im  INNER JOIN f_subcategorymaster sm    ON im.subCategoryID = sm.SubCategoryID ");
                sb2.Append("   INNER JOIN f_configrelation cf ON cf.categoryID = sm.CategoryID  AND ConfigID = 5      WHERE Type_ID = '" + ViewState["DID"].ToString() + "' ) a");
                sb2.Append("   INNER JOIN docgroupRate dr    ON dr.SubCategoryID = a.SubCategoryID WHERE TYPE = 'OPD'    AND DocTypeId = '" + ddldoctorgroup.SelectedItem.Value + "'");
                sb2.Append("   AND a.IsActive = 1    AND dr.IsActive = 1");

                DataTable dtitemid = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb2.ToString()).Tables[0];
                //update old OPD Rate panel wise

                if (dtitemid.Rows.Count > 0)
                {
                    for (int j = 0; j < dtPanel.Rows.Count; j++)
                    {
                        for (int i = 0; i < dtitemid.Rows.Count; i++)
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_ratelist SET IsCurrent=0 WHERE ItemID='" + dtitemid.Rows[i]["ItemID"].ToString() + "' AND PanelID=" + dtPanel.Rows[j]["PanelID"].ToString() + " AND ScheduleChargeID='" + dtPanel.Rows[j]["ScheduleChargeID"].ToString() + "' ");
                        }
                    }
                }

                //Insert New OPD Rate
                for (int j = 0; j < dtPanel.Rows.Count; j++)
                {
                    StringBuilder sb1 = new StringBuilder();
                    sb1.Append(" INSERT INTO f_ratelist(Location,HospCode,Rate,ItemID,PanelID,IsCurrent,UserID,ScheduleChargeID) ");
                    sb1.Append(" SELECT 'L','SHHI',Rate,ItemID," + dtPanel.Rows[j]["PanelID"] + ",1,'" + Util.GetString(Session["ID"]) + "','" + dtPanel.Rows[j]["ScheduleChargeID"] + "' FROM ( ");
                    sb1.Append(" SELECT im.ItemID,im.IsActive,im.SubCategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON im.subCategoryID=sm.SubCategoryID ");
                    sb1.Append(" INNER JOIN f_configrelation cf ON cf.categoryID=sm.CategoryID AND ConfigID=5  ");
                    sb1.Append(" WHERE Type_ID='" + ViewState["DID"].ToString() + "')a ");
                    sb1.Append(" INNER JOIN docgroupRate dr ON dr.SubCategoryID=a.SubCategoryID ");
                    sb1.Append(" WHERE TYPE='OPD' AND DocTypeId='" + ddldoctorgroup.SelectedItem.Value + "' AND panel=" + dtPanel.Rows[j]["PanelID"] + " AND a.IsActive=1 AND dr.IsActive=1 ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb1.ToString());
                }
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " UPDATE f_ratelist SET RateListID=CONCAT(LOCATION,HospCode,ID) WHERE IFNULL(RateListID,'')='' ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist) WHERE groupname='f_ratelist' ");

                //Update OLD IPD Rate

                sb2 = new StringBuilder();
                sb2.Append("  SELECT  Rate,  ItemID FROM (SELECT  im.*  FROM f_itemmaster im  INNER JOIN f_subcategorymaster sm    ON im.subCategoryID = sm.SubCategoryID ");
                sb2.Append("   INNER JOIN f_configrelation cf ON cf.categoryID = sm.CategoryID  AND ConfigID = 1      WHERE Type_ID = '" + ViewState["DID"].ToString() + "' ) a");
                sb2.Append("   INNER JOIN docgroupRate dr    ON dr.SubCategoryID = a.SubCategoryID WHERE TYPE = 'IPD'    AND DocTypeId = '" + ddldoctorgroup.SelectedItem.Value + "'");
                sb2.Append("   AND a.IsActive = 1    AND dr.IsActive = 1");
                dtitemid = new DataTable();

                dtitemid = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb2.ToString()).Tables[0];

                if (dtitemid.Rows.Count > 0)
                {
                    for (int j = 0; j < dtPanel.Rows.Count; j++)
                    {
                        for (int i = 0; i < dtitemid.Rows.Count; i++)
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_ratelist_ipd SET IsCurrent=0 WHERE ItemID='" + dtitemid.Rows[i]["ItemID"].ToString() + "' AND PanelID=" + dtPanel.Rows[j]["PanelID"].ToString() + " AND ScheduleChargeID='" + dtPanel.Rows[j]["ScheduleChargeID"].ToString() + "' ");
                        }
                    }
                }

                //Insert New IPD Rate
                for (int j = 0; j < dtPanel.Rows.Count; j++)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_ratelist_ipd(Location,HospCode,Rate,ItemID,IPDCaseTypeID,PanelID,IsCurrent,userid,ScheduleChargeID) ");
                    sb.Append(" SELECT 'L','SHHI',Rate,ItemID,RoomTypeID," + dtPanel.Rows[j]["PanelID"] + ",1,'" + Util.GetString(Session["ID"]) + "','" + dtPanel.Rows[j]["ScheduleChargeID"] + "' FROM ( ");
                    sb.Append(" SELECT im.ItemID,im.IsActive,im.SubCategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON im.subCategoryID=sm.SubCategoryID ");
                    sb.Append(" INNER JOIN f_configrelation cf ON cf.categoryID=sm.CategoryID AND ConfigID=1  ");
                    sb.Append(" WHERE Type_ID='" + ViewState["DID"].ToString() + "')a ");
                    sb.Append(" INNER JOIN docgroupRate dr ON dr.SubCategoryID=a.SubCategoryID ");
                    sb.Append(" WHERE TYPE='IPD' AND DocTypeId='" + ddldoctorgroup.SelectedItem.Value + "' AND panel=" + dtPanel.Rows[j]["PanelID"] + " AND a.IsActive=1 AND dr.IsActive=1 ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                }

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " UPDATE f_ratelist_ipd SET RateListID=CONCAT(LOCATION,HospCode,ID) WHERE IFNULL(RateListID,'')='' ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");
            }
            if (chkLogin.Checked)
            {
                int roleid = 323;
                if (ddldoctorgroup.SelectedValue == "3")
                    roleid = 52;
                string Password = EncryptPassword(txtPassword.Text);
                DataTable dtEmp = StockReports.GetDataTable("Select Employeeid from doctor_employee where DoctorID='" + ViewState["DID"].ToString() + "'");
                if (dtEmp.Rows.Count > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Update f_login set RoleId="+ roleid +", Username='" + txtUsername.Text + "',Password='" + Password + "' where EmployeeID='" + dtEmp.Rows[0]["Employeeid"].ToString() + "'");
		    string DocSpecility = Util.GetString(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM apidoctorlogindetailtonetram WHERE userID='" + dtEmp.Rows[0]["Employeeid"].ToString() + "';"));

                    if (DocSpecility == "0")
                    {
                        if (Util.GetString(cmbDept.SelectedItem.Text) == "OPHTHAL" || Util.GetString(cmbDept.SelectedItem.Text) == "DENTAL")
                        {
                            var str = "INSERT INTO APIDoctorLoginDetailToNetram(UserId,UserName,PASSWORD,MobileNo,Email,Gender,NationalID,RegistrationNo,DOB,Usertype,ClinicName,Specialization,Speciality,Doctorid,FK_BranchId,EntryBy,EntryDate,LoginName) ";
                            str += " VALUES(@UserId,@UserName,@PASSWORD,@MobileNo,@Email,@Gender,@NationalID,@RegistrationNo,@DOB,Usertype,@ClinicName,@Specialization,@Speciality,@Doctorid,@FK_BranchId,@EntryBy,NOW(),@LoginName)";

                            excuteCMD.DML(tranX, str, CommandType.Text, new
                            {

                                UserId = dtEmp.Rows[0]["EmployeeID"].ToString(),
                                UserName = txtName.Text.Trim(),
                                PASSWORD = Password,
                                MobileNo = TxtMobileNo.Text,
                                Email = "",
                                Gender = "",
                                NationalID = "",
                                RegistrationNo = "",
                                DOB = Util.GetDateTime(""),
                                Usertype = "",
                                ClinicName = Session["CentreName"].ToString(),
                                Specialization = Util.GetString(ddlSpecial.SelectedItem.Text),
                                Speciality = Util.GetString(cmbDept.SelectedItem.Text),
                                Doctorid = ViewState["DID"].ToString(),
                                FK_BranchId = Session["CentreID"].ToString(),
                                EntryBy = Session["ID"].ToString(),
                                LoginName = Util.GetString(txtUsername.Text)
                            });
                        }
                    }	
                }
                else
                {
                    MSTEmployee objMSTEmployee = new MSTEmployee(tranX);
                    objMSTEmployee.Title = cmbTitle.SelectedItem.Text.Trim();
                    objMSTEmployee.Name = txtName.Text.Trim();
                    //objMSTEmployee.House_No = txtAdd.Text.Trim();
                    objMSTEmployee.Mobile = TxtMobileNo.Text.Trim();
                    objMSTEmployee.Allowpartialpayment = Util.GetInt(0);
                    objMSTEmployee.Cadreid = Util.GetInt(ddlCadre.SelectedItem.Value);
                    objMSTEmployee.TierID = Util.GetInt(ddlTier.SelectedItem.Value);
                    string Employee_id = objMSTEmployee.Insert();

                    EmployeeHospital EmHsp = new EmployeeHospital(tranX);
                    EmHsp.EmployeeID = Employee_id;
                    EmHsp.Hospital_ID = HospID;
                    EmHsp.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    EmHsp.Insert();
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into doctor_employee(DoctorID,Employeeid) values('" + ViewState["DID"].ToString() + "','" + Employee_id + "')");
                    
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into f_login(RoleId,EmployeeID,Username,Password) values("+ roleid+",'" + Employee_id + "','" + txtUsername.Text + "','" + Password + "')");

                    if (Util.GetString(cmbDept.SelectedItem.Text) == "OPHTHAL" || Util.GetString(cmbDept.SelectedItem.Text) == "DENTAL")
                    {
                        var str = "INSERT INTO APIDoctorLoginDetailToNetram(UserId,UserName,PASSWORD,MobileNo,Email,Gender,NationalID,RegistrationNo,DOB,Usertype,ClinicName,Specialization,Speciality,Doctorid,FK_BranchId,EntryBy,EntryDate,LoginName) ";
                        str += " VALUES(@UserId,@UserName,@PASSWORD,@MobileNo,@Email,@Gender,@NationalID,@RegistrationNo,@DOB,Usertype,@ClinicName,@Specialization,@Speciality,@Doctorid,@FK_BranchId,@EntryBy,NOW(),@LoginName)";

                        excuteCMD.DML(tranX, str, CommandType.Text, new
                        {

                            UserId = Employee_id,
                            UserName = txtName.Text.Trim(),
                            PASSWORD = Password,
                            MobileNo = TxtMobileNo.Text,
                            Email = "",
                            Gender = "",
                            NationalID = "",
                            RegistrationNo = "",
                            DOB = Util.GetDateTime(""),
                            Usertype = "",
                            ClinicName = Session["CentreName"].ToString(),
                            Specialization = Util.GetString(ddlSpecial.SelectedItem.Text),
                            Speciality = Util.GetString(cmbDept.SelectedItem.Text),
                            Doctorid = ViewState["DID"].ToString(),
                            FK_BranchId = Session["CentreID"].ToString(),
                            EntryBy = Session["ID"].ToString(),
                            LoginName = Util.GetString(txtUsername.Text)
                        });
                    }
                }
            }
            if (fuDrSignature.HasFile)
            {
                string Ext = System.IO.Path.GetExtension(fuDrSignature.FileName);
                if (Ext != ".jpg")
                {
                    lblerrmsg.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblerrmsg.ClientID + "');", true);
                    return;
                }

                string directoryPath = Server.MapPath("~/Design/Doctor/DoctorSignature");
                if (!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(directoryPath);
                }
                string filePath = Path.Combine(directoryPath, fuDrSignature.FileName);

                string filePathNew = Server.MapPath("~/Design/Doctor/DoctorSignature/") + ViewState["DID"].ToString() + System.IO.Path.GetExtension(filePath);
                if (File.Exists(filePathNew))
                {
                    File.Delete(filePathNew);
                }
                fuDrSignature.SaveAs(filePathNew);
            }
            if (Resources.Resource.ApplicationRunCentreWise == "0")
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + ViewState["DID"].ToString() + "','" + Session["CentreID"].ToString() + "','" + Session["ID"].ToString() + "')");
            }
            else
            {
                int oldCentreID = 0, newCentreID = 0;
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_center_doctor CD set isActive=0 WHERE isActive=1 AND CD.DoctorID='" + ViewState["DID"].ToString() + "' ");           
                oldCentreID = Util.GetInt(((Label)grdTime.Rows[0].FindControl("lblCentreID")).Text.ToString().Trim());
                for (int i = 0; i < grdTime.Rows.Count; i++)
                {
                    newCentreID = Util.GetInt(((Label)grdTime.Rows[i].FindControl("lblCentreID")).Text.ToString().Trim());
                    if (i == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + ViewState["DID"].ToString() + "','" + newCentreID + "','" + Session["ID"].ToString() + "')");
                    }
                    else
                    {                
                      if (oldCentreID != newCentreID)
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + ViewState["DID"].ToString() + "','" + newCentreID + "','" + Session["ID"].ToString() + "')");
                            oldCentreID = newCentreID;
                        }
                    }
                   
                }
            }
            tranX.Commit();

            ClearFields();
            lblerrmsg.Text = "Record Updated Successfully";
            ScriptManager.RegisterStartupScript(this, GetType(), "Key200", "alert('Record Updated Successfully');", true);

            if (docGroup != "4")
            {
                Response.Redirect("ViewDoctorDetail.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
           

        }

        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            tranX.Rollback();

            lblerrmsg.Text = "Record Not Saved";
            return;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2"));
        }
        return strBuilder.ToString();
    }

    private DataTable AddTime(string Day, string StartTime, string EndTime, string AvgTime, string DurationforNewPatient, int StartBufferTime, int EndBufferTime, string DurationforOldPatient, DataTable dt)
    {
        if (dt == null)
        {
            dt = new DataTable();
            dt.Columns.Add("Day");
            dt.Columns.Add("StartTime");
            dt.Columns.Add("EndTime");
            dt.Columns.Add("AvgTime");
            dt.Columns.Add("DurationforNewPatient");
            dt.Columns.Add("StartBufferTime");
            dt.Columns.Add("EndBufferTime");
            dt.Columns.Add("DurationforOldPatient");
            dt.Columns.Add("Date");
            dt.Columns.Add("IsRepeat");
            dt.Columns.Add("ShiftName");
			dt.Columns.Add("CentreName");
            dt.Columns.Add("CentreID");
        }

        if (dt != null)
        {
            DataRow dr = dt.NewRow();
            dr["Day"] = Day;
            dr["StartTime"] = StartTime;
            dr["EndTime"] = EndTime;
            dr["AvgTime"] = AvgTime;
            dr["DurationforNewPatient"] = DurationforNewPatient;
            dr["StartBufferTime"] = StartBufferTime;
            dr["EndBufferTime"] = EndBufferTime;
            dr["DurationforOldPatient"] = DurationforOldPatient;
            dr["IsRepeat"] = chkRepeat.Checked == true ? 1 : 0;
            dr["Date"] = txtDate.Text;
            dr["ShiftName"] = ddlDocTimingShift.SelectedItem.Text;
			dr["CentreName"] = ddlCentre.SelectedItem.Text;
		    dr["CentreID"] = ddlCentre.SelectedItem.Value;
            dt.Rows.Add(dr);
        }
        return dt;
    }



    private void BindDocFloor()
    {
        ddlDocFloor.DataSource = All_LoadData.LoadFloor();
        ddlDocFloor.DataValueField = "NAME";
        ddlDocFloor.DataTextField = "NAME";
        ddlDocFloor.DataBind();
    }

    private void BindDoctorDetail(string DocID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DoctorID,Title,Name,Specialization,Phone1,Mobile,Street_Name,DocType,DocDateTime,DocGroupId,Degree,DocDepartmentID,IsEmergencyAvailable as EmerAvail,IsDocShare,IsUnit,Designation,isSlotWiseToken,Cadreid,TierID from doctor_master where DoctorID='" + DocID + "'");
        if (dt.Rows.Count > 0)
        {
            cmbTitle.SelectedIndex = cmbTitle.Items.IndexOf(cmbTitle.Items.FindByText(Util.GetString(dt.Rows[0]["Title"]).ToUpper()));
            txtName.Text = Util.GetString(dt.Rows[0]["Name"]);
           // rbtType.SelectedIndex = Util.GetInt(dt.Rows[0]["IsUnit"]);//
            int isUnit = Util.GetInt(dt.Rows[0]["IsUnit"]);
            if (isUnit == 1)
            {
                hfDepartment.Value = Util.GetString(dt.Rows[0]["Designation"]);
            }
            txtAdd.Text = Util.GetString(dt.Rows[0]["Street_Name"]);
            TxtMobileNo.Text = Util.GetString(dt.Rows[0]["Mobile"]);
            txtPhone1.Text = Util.GetString(dt.Rows[0]["Phone1"]);
            ddlSpecial.SelectedIndex = ddlSpecial.Items.IndexOf(ddlSpecial.Items.FindByText(Util.GetString(dt.Rows[0]["Specialization"])));
            txtDocDegree.Text = Util.GetString(dt.Rows[0]["Degree"]);
            ddldoctorgroup.SelectedIndex = ddldoctorgroup.Items.IndexOf(ddldoctorgroup.Items.FindByValue(dt.Rows[0]["DocGroupId"].ToString()));
            cmbDept.SelectedIndex = cmbDept.Items.IndexOf(cmbDept.Items.FindByValue(dt.Rows[0]["DocDepartmentID"].ToString()));
            rblDocShare.SelectedIndex = rblDocShare.Items.IndexOf(rblDocShare.Items.FindByValue(dt.Rows[0]["IsDocShare"].ToString()));
            rblIsAvailableEmergency.SelectedIndex = rblIsAvailableEmergency.Items.IndexOf(rblIsAvailableEmergency.Items.FindByValue(dt.Rows[0]["EmerAvail"].ToString()));
            rdoIsSlotWiseToken.SelectedIndex = rdoIsSlotWiseToken.Items.IndexOf(rdoIsSlotWiseToken.Items.FindByValue(dt.Rows[0]["isSlotWiseToken"].ToString()));
            txtDoctorTiminig.Text = Util.GetString(dt.Rows[0]["DocDateTime"]);
            ddlCadre.SelectedIndex = ddlCadre.Items.IndexOf(ddlCadre.Items.FindByValue(dt.Rows[0]["Cadreid"].ToString()));
            ddlTier.SelectedIndex = ddlTier.Items.IndexOf(ddlTier.Items.FindByValue(dt.Rows[0]["TierID"].ToString()));
            string sql = "select * from doctor_hospital where DoctorID='" + DocID + "'";
            dt = new DataTable();
            dt = StockReports.GetDataTable(sql);

            if (dt != null && dt.Rows.Count > 0)
            {

                ddlduration.SelectedIndex = ddlduration.Items.IndexOf(ddlduration.Items.FindByText(dt.Rows[0]["AvgTime"].ToString()));
                ddldurationOld.SelectedIndex = ddldurationOld.Items.IndexOf(ddldurationOld.Items.FindByText(dt.Rows[0]["DurationforOldPatient"].ToString()));
                
                if (ViewState["dtTime"] != null)
                {
                    dtTime = ((DataTable)ViewState["dtTime"]);
                }

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    ddlDocTimingShift.SelectedIndex = ddlDocTimingShift.Items.IndexOf(ddlDocTimingShift.Items.FindByText(dt.Rows[i]["ShiftName"].ToString()));
                    ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(dt.Rows[i]["CentreID"].ToString()));
                   
				    dtTime = AddTime(dt.Rows[i]["Day"].ToString(), Util.GetDateTime(dt.Rows[i]["StartTime"]).ToString("hh:mmtt"), Util.GetDateTime(dt.Rows[i]["EndTime"]).ToString("hh:mmtt"), dt.Rows[i]["AvgTime"].ToString(), dt.Rows[i]["DurationforNewPatient"].ToString(), Util.GetInt(dt.Rows[0]["StartBufferTime"]), Util.GetInt(dt.Rows[0]["EndBufferTime"]), dt.Rows[i]["DurationforOldPatient"].ToString(), dtTime);
                }

                grdTime.DataSource = dtTime;
                grdTime.DataBind();
                string EndTime = dt.Rows[0]["EndTime"].ToString();
                txtRoomNo.Text = dt.Rows[0]["Room_No"].ToString();

                ddlDocFloor.SelectedIndex = ddlDocFloor.Items.IndexOf(ddlDocFloor.Items.FindByText(dt.Rows[0]["DocFloor"].ToString()));
                if (ViewState["dtTime"] != null)
                {
                    ViewState["dtTime"] = dtTime;
                }
                else
                {
                    ViewState.Add("dtTime", dtTime);
                }

                string login = "SELECT lg.UserName,lg.Password,lg.RoleID,lg.EmployeeID FROM doctor_employee de INNER JOIN f_login lg ON de.Employeeid = lg.EmployeeID  WHERE de.DoctorID ='" + DocID + "' ";
                dt = new DataTable();
                dt = StockReports.GetDataTable(login);
                if (dt != null && dt.Rows.Count > 0)
                {
                    txtUsername.Text = dt.Rows[0]["UserName"].ToString();
                    txtPassword.Text = dt.Rows[0]["Password"].ToString();
                }
                rbtnType.SelectedIndex = 0;
                
                rbtnType.Enabled = true;
                trDateWise.Visible = false;
                trdt.Visible = false;
                trDaysWise.Visible = true;
                trdy.Visible = true;
            }
            else
            {
                rbtnType.SelectedIndex = 1;
                rbtnType.Enabled = true;
                trDateWise.Visible = true;
                trdt.Visible = true;
                trDaysWise.Visible = false;
                trdy.Visible = false;
                dtTime = StockReports.GetDataTable(" SELECT DATE_FORMAT(DATE,'%d %b %Y')DAY,TIME_FORMAT(StartTime,'%h:%i%p')StartTime,TIME_FORMAT(EndTime,'%h:%i%p')EndTime,DurationforNewPatient AvgTime,DurationforNewPatient,''StartBufferTime,''EndBufferTime,DurationforOldPatient,DATE_FORMAT(DATE,'%d %b %Y')DATE,IsRepeat,Room_No,ShiftName,cm.CentreID,cm.CentreName FROM  Doctor_TimingDateWise dt INNER JOIN center_master cm on cm.CentreID=dt.CentreID WHERE DoctorID='" + DocID + "' ");
                if (dtTime.Rows.Count > 0)
                {
                    ddlduration.SelectedIndex = ddlduration.Items.IndexOf(ddlduration.Items.FindByText(dtTime.Rows[0]["AvgTime"].ToString()));
                    ddldurationOld.SelectedIndex = ddldurationOld.Items.IndexOf(ddldurationOld.Items.FindByText(dtTime.Rows[0]["DurationforOldPatient"].ToString()));
                   
                    ViewState["dtTime"] = dtTime;
                    grdTime.DataSource = dtTime;
                    grdTime.DataBind();
                }

            }
        }
    }

    private void Binddoctorgroup()
    {
        string strdoctorgroup = "select ID,DocType from doctorGroup where IsActive=1";
        DataTable dt = StockReports.GetDataTable(strdoctorgroup);
        ddldoctorgroup.DataSource = dt;
        ddldoctorgroup.DataTextField = "DocType";
        ddldoctorgroup.DataValueField = "ID";
        ddldoctorgroup.DataBind();
        ddldoctorgroup.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void ClearFields()
    {
        txtAdd.Text = "";
        txtHr1.Text = "";
        txtHr2.Text = "";
        txtMin1.Text = "";
        txtMin2.Text = "";
        TxtMobileNo.Text = "";
        txtName.Text = "";
        txtPhone1.Text = "";
        txtRoomNo.Text = "";
        txtStartBT.Text = "";
        txtEndBT.Text = "";
        // txtDocTimings.Text = "";
        ddlSpecial.SelectedIndex = 0;
        cmbTitle.SelectedIndex = 0;
        txtUsername.Text = "";
        if (chkMon.Checked || chkTues.Checked || chkWed.Checked || chkThur.Checked || chkFri.Checked || chkSat.Checked || chkSun.Checked)
        {
            chkMon.Checked = false;
            chkTues.Checked = false;
            chkWed.Checked = false;
            chkThur.Checked = false;
            chkFri.Checked = false;
            chkSat.Checked = false;
            chkSun.Checked = false;
        }

        grdTime.DataSource = null;
        grdTime.DataBind();

        ViewState["dtTime"] = null;
        txtDocDegree.Text = "";
    }

    private void DataTableSpecialization()
    {
        DataTable dtSpecialization = new DataTable();
        dtSpecialization.Columns.Add("Specilazation");
    }

    private void DropCache()
    {
        LoadCacheQuery.dropCache("Doctor_" + Session["CentreID"].ToString());
    }

    private string saveData(string DID, string Day, string HospID, DateTime StartTime, DateTime EndTime, string Roomno, string Dept, int avgtime, int StartBufferTime, int EndBufferTime, int DurationforNewPatient, int DurationforOldPatient, string DocFloor, MySqlTransaction Trans, string VisitName,int CentreID)
    {
        return AllInsert.SaveDocOPD(DID, HospID, Day, StartTime, EndTime, Util.GetString(Roomno), Dept, avgtime, StartBufferTime, EndBufferTime, DurationforNewPatient, DurationforOldPatient, DocFloor, Trans, VisitName,CentreID);

    }

    private bool ValidateItems(string day)
    {
        foreach (DataRow row in dtTime.Rows)
        {
            if (row["Day"].ToString() == day)
            {
                return false;
                //break;
            }
        }
        return true;
    }

    //Devendra Singh 2018-09-26 For Multiple Visit : Create this function in place of ValidateItems
    private bool ValidateItemsNew(string day, DateTime startTime, DateTime endTime)
    {

        foreach (DataRow row in dtTime.Rows)
        {

            DateTime StartDateTime = Util.GetDateTime(row["StartTime"].ToString());
            DateTime EndDateTime = Util.GetDateTime(row["EndTime"].ToString());
            DateTime SelectedStartDateTime = startTime;
            DateTime SelectedEndDateTime = endTime;

            if (row["Day"].ToString() == day)
            {
                if ((StartDateTime >= SelectedStartDateTime && SelectedEndDateTime >= StartDateTime) || (EndDateTime >= SelectedStartDateTime && SelectedEndDateTime >= EndDateTime))
                {
                    lblerrmsg.Text = "Selected Time Period Already Exist. Kindly Cross verify.";
                    return false;
                }

            }
        }
        return true;
    }

    protected void rbtnType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnType.SelectedItem.Value == "1")
        {
            trDaysWise.Visible = true;
            trDateWise.Visible = false;
            trdt.Visible = false;
            trdy.Visible = true;
        }
        else
        {
            trDaysWise.Visible = false;
            trDateWise.Visible = true;
            trdt.Visible = true;
            trdy.Visible = false;
        }
    }

    protected void btnNASearch_Click(object sender, EventArgs e)
    {
        BindDoctorNotAvailable();
    }
    private void BindDoctorNotAvailable()
    {
        string sql = "CALL get_temp_date('" + Util.GetDateTime(txtNotAvailableDateFrom.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtNotAvailableDateTo.Text).ToString("yyyy-MM-dd") + "','" + ViewState["DID"].ToString() + "','" + ddlNACentre.SelectedItem.Text + "','" + Util.GetInt(ddlNACentre.SelectedItem.Value) + "')";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            grdNATiming.DataSource = dt;
            grdNATiming.DataBind();
        }
        else
        {
            grdNATiming.DataSource = null;
            grdNATiming.DataBind();
        }
    }
    protected void grdNATiming_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsCheck")).Text == "true"){
                e.Row.BackColor = System.Drawing.Color.LightGreen;
				 CheckBox checkBox = ((CheckBox)e.Row.FindControl("chkSelect"));
                checkBox.Checked = true;
			}
            DropDownList ddlFrom = (DropDownList)e.Row.FindControl("cmbNAAMPM1");
            DropDownList ddlTo = (DropDownList)e.Row.FindControl("cmbNAAMPM2");
            ddlFrom.SelectedIndex = ddlFrom.Items.IndexOf(ddlFrom.Items.FindByText(((Label)e.Row.FindControl("lblNAST")).Text));
            ddlTo.SelectedIndex = ddlTo.Items.IndexOf(ddlTo.Items.FindByText(((Label)e.Row.FindControl("lblNAET")).Text));
        }
    }

    public void DeleteUnit(int ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE FROM unit_doctorlist WHERE Id=" + ID + "");
            tranX.Commit();
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            tranX.Rollback();

            lblerrmsg.Text = "Something went wrong. Unit not deleted";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetUnitList(string DoctorID)
    {
        //string strTempData = "SELECT dm.`name` docName,udl.`DoctorID` docId,udl.`position`,udl.`isPer`,udl.`opd_con`,udl.`opd_pro`, udl.`opd_lab`,udl.`opd_pac`,udl.`ipd_visit`,udl.`ipd_pro`,udl.`ipd_lab`,udl.`ipd_sur`,udl.`ipd_pac`,udl.IPD_Oth,udl.OPD_Oth FROM tempunit udl INNER JOIN doctor_master dm ON udl.DoctorID = dm.`DoctorID` WHERE udl.`UnitDoctorId` = '" + DoctorID + "'";
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Id,DoctorListId,UnitDoctorID,position, ");
        sb.Append(" (SELECT CONCAT(Title,' ',NAME) FROM doctor_master WHERE DoctorID=DoctorListId)'DoctorName', (SELECT CONCAT(Title,' ',NAME) FROM doctor_master WHERE DoctorID=UnitDoctorID)'UnitName' FROM unit_doctorlist WHERE UnitDoctorID='" + DoctorID + "' AND IsActive=1 ");
        DataTable dtTemp = StockReports.GetDataTable(Util.GetString(sb.ToString()));
        if (dtTemp.Rows.Count > 0)
        {
            //var row = dtTemp.Rows[0];
            //if (!String.IsNullOrWhiteSpace(Util.GetString(row["IsPer"])))
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtTemp);
        }
        else
        {
            StringBuilder sbSqlCmd = new StringBuilder();
            sbSqlCmd.Append(" SELECT dm.`name` docName,udl.`DoctorListId` docId,udl.`position` ");
            sbSqlCmd.Append(" FROM unit_doctorList udl INNER JOIN doctor_master dm ON udl.`DoctorListId` = dm.`DoctorID` ");
            sbSqlCmd.Append("WHERE udl.`UnitDoctorId` = '" + DoctorID + "' AND udl.`IsActive`=1");
            DataTable dtab = StockReports.GetDataTable(Util.GetString(sbSqlCmd));

            if (dtab.Rows.Count > 0)
            {
                //var row = dtab.Rows[0];
                //if (!String.IsNullOrWhiteSpace(Util.GetString(row["IsPer"])))
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dtab);
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject("");
    }

    private static DataSet GetData(string ID)
    {
        DataSet ds = new DataSet();
        MySqlDataAdapter Adp = new MySqlDataAdapter();
        MySqlDataReader dr;

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME,dm.Designation FROM Doctor_master dm INNER JOIN Unit_DoctorList ud ON ud.DoctorListId=dm.DoctorID WHERE UnitDoctorID='" + ID + "' AND ud.IsActive=1";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            Adp.SelectCommand = cmd;
            Adp.Fill(ds, "Customers");
        }
        return ds;
    }

    [WebMethod] // 
    public static string BindDoctorByUnitID(string unitID)
    {
        return GetData(unitID).GetXml();
    }

    public void UpdateDoctorUnit(string unitID, MySqlConnection conn)
    {
        StringBuilder sbSqlCmd = new StringBuilder();
        sbSqlCmd.Append("UPDATE unit_doctorlist SET IsActive=0, UpdatedBy = '" + Util.GetString(Session["ID"]) + "', UpdatedDateTime = now() WHERE UnitDoctorId='" + unitID + "' AND IsActive=1");
        MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, Util.GetString(sbSqlCmd));
    }
}