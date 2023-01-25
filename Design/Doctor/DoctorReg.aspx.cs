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
using System.Web.UI.HtmlControls;
public partial class Design_Doctor_DoctorReg : System.Web.UI.Page
{
    private DataTable dtTime;

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM DOCTOR_MASTER WHERE Name='" + txtName.Text.ToString() + "'"));
        if (count > 0)
        {
            lblerrmsg.Text = "Doctor Already Exist";
        }
        else
        {

            if (txtName.Text.Trim() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblerrmsg.ClientID + "');", true);

                txtName.Focus();
                return;
            }
            if (TxtMobileNo.Text.Trim() == "")
            {
                lblerrmsg.Text = "Please Enter Doctor Mobile No.";

                txtName.Focus();
                return;
            }
            if (ddldoctorgroup.SelectedIndex == 0)
            {
                lblerrmsg.Text = "Please Select Doctor Type";
                ddldoctorgroup.Focus();
                return;
            }
            if (ddlSpecial.SelectedIndex == 0)
            {
                lblerrmsg.Text = "Please Select Doctor Sepcilization";
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM172','" + lblerrmsg.ClientID + "');", true);

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
                lblerrmsg.Text = "Please Specify Day of OPD Timings..";
                chkMon.Focus();
                return;
            }
            if (chkLogin.Checked)
            {
                if (txtUsername.Text == "")
                {
                    lblerrmsg.Text = "Please Enter User Name";
                    txtUsername.Focus();
                    return;
                }
                if (txtPassword.Text == "")
                {
                    lblerrmsg.Text = "Please Enter User Name";
                    txtPassword.Focus();
                    return;
                }
                if (txtPassword.Text.ToString() != txtConfirmpwd.Text.ToString())
                {
                    txtConfirmpwd.Focus();
                    lblerrmsg.Text = "Password Does Not Match";
                    return;
                }
            }
            DropCache();
            SaveDoctorReg();
        }
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
    protected void btntimings_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        if (txtHr1.Text == "")
        {
            lblerrmsg.Text = "Please Enter Start Time In Hours";
            txtHr1.Focus();
            return;
        }
        if (txtMin1.Text == "")
        {
            lblerrmsg.Text = "Please Enter Start Time In Minutes";
            txtHr1.Focus();
            return;
        }
        if (txtHr2.Text == "")
        {
            lblerrmsg.Text = "Please Enter End Time In Hours";
            txtHr1.Focus();
            return;
        }
        if (txtMin2.Text == "")
        {
            lblerrmsg.Text = "Please Enter End Time In Minutes";
            txtMin2.Focus();
            return;
        }

        if (chkMon.Checked == true || chkTues.Checked == true || chkWed.Checked == true || chkThur.Checked == true || chkFri.Checked == true || chkSat.Checked == true || chkSun.Checked == true)
        {
            try
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
                string avgtime = ddlduration.SelectedValue.ToString().Trim();
                string DurationforOldPatient = ddldurationOld.SelectedValue.ToString().Trim();
                string DurationforNewPatient = ddlduration.SelectedValue.ToString().Trim();
                int StartBT = Util.GetInt(txtStartBT.Text.Trim());
                int EndBT = Util.GetInt(txtEndBT.Text.Trim());

                // Devendra Singh 2018-09-26 , Replace function ValidateItems to ValidateItemsNew for multiple doctor shifting.
                if (chkMon.Checked == true)
                {
                    if (ValidateItemsNew("Monday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Monday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }
                if (chkTues.Checked == true)
                {
                    if (ValidateItemsNew("Tuesday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Tuesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }
                if (chkWed.Checked == true)
                {
                    if (ValidateItemsNew("Wednesday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Wednesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }
                if (chkThur.Checked == true)
                {
                    if (ValidateItemsNew("Thursday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Thursday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }
                if (chkFri.Checked == true)
                {
                    if (ValidateItemsNew("Friday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Friday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }
                if (chkSat.Checked == true)
                {
                    if (ValidateItemsNew("Saturday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Saturday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }
                if (chkSun.Checked == true)
                {
                    if (ValidateItemsNew("Sunday", StartTime, EndTime))
                    {
                        dtTime = AddTime("Sunday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);
                    }
                }

                if (ViewState["dtTime"] != null)
                {
                    ViewState["dtTime"] = dtTime;
                }
                else
                {
                    ViewState.Add("dtTime", dtTime);
                }

                //chkMon.Checked = false;
                //chkTues.Checked = false;
                //chkWed.Checked = false;
                //chkThur.Checked = false;
                //chkFri.Checked = false;
                //chkSat.Checked = false;
                //chkSun.Checked = false;

                grdTime.DataSource = dtTime;
                grdTime.DataBind();
                EnableDisableSchedueType();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
        else
        {
            try
            {
                if (rbtnType.SelectedItem.Value == "2")
                {
                    lblerrmsg.Text = "";
                    if (txtDate.Text.Trim() == "")
                    {
                        lblerrmsg.Text = "Please Select Date";
                        return;

                    }

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
                    dtTime = AddTime(txtDate.Text.Trim(), StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforNewPatient, dtTime, StartBT, EndBT, DurationforOldPatient);

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

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }

    protected void chkLogin_CheckedChanged(object sender, EventArgs e)
    {
        if (chkLogin.Checked)
        {
            pnlLogin.Visible = true;
        }
        else
        {
            pnlLogin.Visible = false;
        }
    }

    protected void ddlSpecial_SelectedIndexChanged(object sender, EventArgs e)
    {
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

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ViewState["userid"] = Util.GetString(Session["ID"]);
            if (!IsPostBack)
            {
                txtName.Focus();

                All_LoadData.bindDocTypeList(ddlSpecial, 3, "Select");
                All_LoadData.bindDocTypeList(cmbDept, 5, "Select");
                BindCentre();
                Binddoctorgroup();
                BindDocFloor();
                BindDocTimingShift();
                bindCadre();
                bindTier();
                txtNotAvailableDateFrom.Text = txtNotAvailableDateTo.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy");
            }
            txtDate.Attributes.Add("readonly", "true");
            txtNotAvailableDateFrom.Attributes.Add("readonly", "true");
            txtNotAvailableDateTo.Attributes.Add("readonly", "true");
            txtDate_CalendarExtender.StartDate = cdNAFrom.StartDate = cdNATo.StartDate = DateTime.Now;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
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
        if (dt != null && dt.Rows.Count > 0) {
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
    private DataTable AddTime(string Day, string StartTime, string EndTime, string AvgTime, string DurationforNewPatient, DataTable dt, int StartBT, int EndBT, string DurationforOldPatient)
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
            dr["StartBufferTime"] = StartBT;
            dr["EndBufferTime"] = EndBT;
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
    private void BindDocTimingShift()
    {
        ddlDocTimingShift.DataSource = StockReports.GetDataTable("SELECT Id,ShiftName FROM VisitShift_master ORDER BY id ");
        ddlDocTimingShift.DataValueField = "Id";
        ddlDocTimingShift.DataTextField = "ShiftName";
        ddlDocTimingShift.DataBind();
    }
    private void Binddoctorgroup()
    {
        string strdoctorgroup = "select ID,DocType from DoctorGroup where IsActive=1";
        DataTable dt = StockReports.GetDataTable(strdoctorgroup);
        if (dt.Rows.Count > 0)
        {
            ddldoctorgroup.DataSource = dt;
            ddldoctorgroup.DataTextField = "DocType";
            ddldoctorgroup.DataValueField = "ID";
            ddldoctorgroup.DataBind();
            ddldoctorgroup.Items.Insert(0, new ListItem("Select", "0"));
        }
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
        ddlSpecial.SelectedIndex = 0;
        cmbTitle.SelectedIndex = 0;
        txtUsername.Text = "";
        chkLogin.Checked = false;
        ddlduration.SelectedIndex = 0;
        ddldurationOld.SelectedIndex = 0;
        txtDocDegree.Text = "";
        rblDocShare.SelectedIndex = 1;
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
        grdNATiming.DataSource = null;
        grdNATiming.DataBind();

        ViewState["dtTime"] = null;
    }


    private void DropCache()
    {
        LoadCacheQuery.DropCentreWiseCache();
        //  LoadCacheQuery.dropCache("Doctor_" + Session["CentreID"].ToString());
        DataTable dt = All_LoadData.dtbind_Center();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {

                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Doctor_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Doctor_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }

            }
        }
        File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/OPDDiagnosisItems.txt"));
    }

    private string saveData(string DID, string Day, string HospID, DateTime StartTime, DateTime EndTime, string Roomno, string Dept, int avgtime, int StartBufferTime, int EndBufferTime, int DurationforNewPatient, int DurationforOldPatient, string DocFloor, MySqlTransaction Trans, string VisitName, int CentreID)
    {
        return AllInsert.SaveDocOPD(DID, HospID, Day, StartTime, EndTime, Util.GetString(Roomno), Dept, avgtime, StartBufferTime, EndBufferTime, DurationforNewPatient, DurationforOldPatient, DocFloor, Trans, VisitName, CentreID);
    }

    private void SaveDoctorReg()
    {
        
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        string HospID = Convert.ToString(Session["HOSPID"]);
        string Dept = cmbDept.SelectedItem.Text;
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            DoctorMaster objDoctorMaster = new DoctorMaster(tranX);
            if (hfType.Value.ToString() == "1")
            objDoctorMaster.Title = "";
            else
                objDoctorMaster.Title = cmbTitle.SelectedItem.Text.Trim();
            objDoctorMaster.Name = txtName.Text.Trim();
            objDoctorMaster.Phone1 = txtPhone1.Text.Trim();
            objDoctorMaster.Mobile = TxtMobileNo.Text.Trim();
            objDoctorMaster.Street_Name = txtAdd.Text.Trim();
            objDoctorMaster.Specialization = ddlSpecial.SelectedItem.Text.Trim();
            objDoctorMaster.DoctorTime = UpdateDoctorTiming();
            objDoctorMaster.Designation = cmbDept.SelectedItem.Text;
            objDoctorMaster.DocGroupId = ddldoctorgroup.SelectedItem.Value;
            objDoctorMaster.DocDepartmentID = cmbDept.SelectedItem.Value;
            objDoctorMaster.Degree = txtDocDegree.Text.Trim();
            objDoctorMaster.LastUpdatedBy = Session["ID"].ToString();
            objDoctorMaster.IsDocShare = Util.GetInt(rblDocShare.SelectedItem.Value.Trim());
            objDoctorMaster.IsEmergencyAvailable = Util.GetInt(rblIsAvailableEmergency.SelectedItem.Value);
            objDoctorMaster.CreatedBy = Session["ID"].ToString();
            objDoctorMaster.IsSlotWiseToken = Util.GetInt(rblIsSlotWiseToken.SelectedItem.Value);
            objDoctorMaster.DocDateTime = Util.GetString(txtDoctorTiminig.Text.Trim());
            objDoctorMaster.Cadreid = Util.GetInt(ddlCadre.SelectedItem.Value);
            objDoctorMaster.TierID = Util.GetInt(ddlTier.SelectedItem.Value);

            if (hfType.Value.ToString() == "1")
                objDoctorMaster.IsUnit = 1;
            else
                objDoctorMaster.IsUnit = 0;

            string DID = objDoctorMaster.Insert();

            if (hfType.Value.ToString() == "1" && rblDocShare.SelectedValue == "0")
            {
                //string DoctorID = txtUnitDoctorList.Text;
                //string[] DoctorIDList = DoctorID.Split(',');
                //foreach (string ID in DoctorIDList)
                //{
                //    string DocID = ID;
                //    if (DocID != "")
                //    {
                //        objDoctorMaster.DoctorListId = DocID;
                //        objDoctorMaster.UnitDoctorID = DID;
                //        objDoctorMaster.CreatedBy = Session["ID"].ToString();
                //        objDoctorMaster.CreatedDateTime = DateTime.Now;
                //        objDoctorMaster.IsActive = 1;

                //        string val = objDoctorMaster.InsertDoctorUnit();
                //    }
                //}

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "SaveDocShareUnit('" + DID + "');", true);
            }
            else if (hfType.Value.ToString() == "1" && rblDocShare.SelectedValue == "1")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "SaveDocShareUnit('" + DID + "');", true);
            }

            Ledger_Master objLedMas = new Ledger_Master(tranX);
            objLedMas.Hospital_ID = HospID;
            objLedMas.GroupID = "DOC";
            objLedMas.LegderName = Util.GetString(txtName.Text.Trim());
            objLedMas.LedgerUserID = Util.GetString(DID);
            objLedMas.OpeningBalance = Util.GetDecimal("0");
            objLedMas.Insert().ToString();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT t.Company_Name,t.PanelID,t.ReferenceCode,t.ReferenceCodeOPD,rs.ScheduleChargeID   FROM ");
            sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD  ");
            sb.Append(" FROM f_panel_master WHERE PanelID IN ( ");
            sb.Append(" SELECT DISTINCT(ReferenceCodeOPD) FROM f_panel_master) ");
            sb.Append(" )t  INNER JOIN f_rate_schedulecharges rs ON rs.panelid =t.PanelID WHERE rs.IsDefault=1 ");
            sb.Append("  ORDER BY t.Company_Name ");

            DataTable dtPanel = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

            DataTable dtSubCategoryID = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("5"));

            //Inserting rates for OPD 
            //shatrughan 18.04.13
            DataTable dtDocGroupRate = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocGroupID,DocGroup,Type,SubCategoryID,Panel,RoomTypeID,Rate,DocTypeId FROM DocgroupRate ").Tables[0];


            DataTable docGroupRateOPD = dtDocGroupRate.AsEnumerable().Where(r => r.Field<string>("Type") == "OPD").CopyToDataTable();
            var Save = CreateStockMaster.SaveItemDetails(dtSubCategoryID, DID, Util.GetString(txtName.Text.Trim()), "NO", "", "NO", "", "", "YES", "", "", "", "", "0.0", "0", tranX, docGroupRateOPD, dtPanel, ddldoctorgroup.SelectedItem.Value, ViewState["userid"].ToString(), "", Util.GetInt(cmbDept.SelectedItem.Value), Util.GetInt(rdoIsDiscountable.SelectedItem.Value.Trim()));

            if (!Save)
            {
                tranX.Rollback();
                return;
            }
            //Inserting rates for IPD 

            DataTable dtRoomType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT(NAME)RoomName,IPDCaseTypeID FROM ipd_case_type_master WHERE isActive=1 ").Tables[0];
            DataTable dtSubCategoryIDIPD = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("1"));
            DataTable docGroupRateIPD = dtDocGroupRate.AsEnumerable().Where(r => r.Field<string>("Type") == "IPD").CopyToDataTable();

            var SaveIPD = CreateStockMaster.SaveItemDetailsIPD(dtSubCategoryIDIPD, DID, Util.GetString(txtName.Text.Trim()), "NO", "", "NO", "", "", "YES", "", "", "", "", "0.0", "0", tranX, docGroupRateIPD, dtPanel, ddldoctorgroup.SelectedItem.Value, dtRoomType, ViewState["userid"].ToString(), Util.GetInt(cmbDept.SelectedItem.Value), Util.GetInt(rdoIsDiscountable.SelectedItem.Value.Trim()));
            if (!SaveIPD)
            {
                tranX.Rollback();
                return;
            }

            //=======================  END  ==============================
            string returnStr = "";

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from Doctor_hospital where DoctorID='" + DID + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from Doctor_TimingDateWise where DoctorID='" + DID + "'");

            if (grdTime.Rows.Count == 0 && rbtnType.SelectedValue == "1")
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
                    returnStr = saveData(DID, "Monday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkTues.Checked == true)
                {
                    returnStr = saveData(DID, "Tuesday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkWed.Checked == true)
                {
                    returnStr = saveData(DID, "Wednesday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkThur.Checked == true)
                {
                    returnStr = saveData(DID, "Thursday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkFri.Checked == true)
                {
                    returnStr = saveData(DID, "Friday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkSat.Checked == true)
                {
                    returnStr = saveData(DID, "Saturday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);

                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
                if (chkSun.Checked == true)
                {
                    returnStr = saveData(DID, "Sunday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
                    if (returnStr == "0")
                    {
                        tranX.Rollback();
                        return;
                    }
                }
            }
            else
            {

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
                        returnStr = saveData(DID, Day, HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, StartBT, EndBT, DurationforNewPatient, DurationforOldPatient, Util.GetString(ddlDocFloor.SelectedItem.Text), tranX, VisitName, CentreID);
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
                           + "VALUES(@Doctor_ID,@DoctorName,@Day,@StartTime,@EndTime,@DurationforPatient,@StartEndTimeSlot,@VisitName,@CentreID,@TokenNo)";

                            excuteCMD.DML(tranX, sqlCMD1, CommandType.Text, new
                            {
                                Doctor_ID = DID,
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
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO Doctor_TimingDateWise(DoctorID,DATE,IsRepeat,DurationforOldPatient,DurationforNewPatient,StartTime,EndTime,DocFloor,Room_No,ShiftName,CentreID)VALUES('" + DID + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'," + IsRepeat + ",'" + DurationforOldPatient + "','" + DurationforNewPatient + "','" + Util.GetDateTime(StartTime).ToString("HH:mm:ss") + "','" + Util.GetDateTime(EndTime).ToString("HH:mm:ss") + "','" + Util.GetString(ddlDocFloor.SelectedItem.Text) + "','" + txtRoomNo.Text.Trim() + "','" + Util.GetString(VisitName) + "'," + Util.GetInt(CentreID) + ")");
                        //  MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete From doctor_hospital where DoctorID='" + DID + "' ");
                    }

                }

            }

            // Devendra Singh 06-Oct-2018 For Doctor Not-Availability
            for (int i = 0; i < grdNATiming.Rows.Count; i++)
            {

                if (((CheckBox)grdNATiming.Rows[i].FindControl("chkSelect")).Checked)
                {
                    string Date = ((Label)grdNATiming.Rows[i].FindControl("lblNADate")).Text;
                    string DayValue = ((Label)grdNATiming.Rows[i].FindControl("lblDayValue")).Text;
                    DateTime StartTime = Convert.ToDateTime(((TextBox)grdNATiming.Rows[i].FindControl("txtNAHr1")).Text.Trim() + ":" + ((TextBox)grdNATiming.Rows[i].FindControl("txtNAMin1")).Text.Trim() + ((DropDownList)grdNATiming.Rows[i].FindControl("cmbNAAMPM1")).SelectedItem.Text.Trim());
                    DateTime EndTime = Convert.ToDateTime(((TextBox)grdNATiming.Rows[i].FindControl("txtNAHr2")).Text.Trim() + ":" + ((TextBox)grdNATiming.Rows[i].FindControl("txtNAMin2")).Text.Trim() + ((DropDownList)grdNATiming.Rows[i].FindControl("cmbNAAMPM2")).SelectedItem.Text.Trim());
                    int CentreID = Util.GetInt(((Label)grdNATiming.Rows[i].FindControl("lblNACentreID")).Text.ToString().Trim());

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO doctor_notavailable_datewise(DoctorID,`Date`,`Day`,FromTime,ToTime,CreatedBy,CreatedDate,CentreID) VALUES('" + DID + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "','" + DayValue + "','" + StartTime.ToString("HH:mm:ss") + "','" + EndTime.ToString("HH:mm:ss") + "','" + Session["ID"].ToString() + "',now()," + Util.GetInt(CentreID) + ")");
                }
            }
            if (chkLogin.Checked)
            {
                string Password = EncryptPassword(txtPassword.Text);
                MSTEmployee objMSTEmployee = new MSTEmployee(tranX);
                objMSTEmployee.Title = cmbTitle.SelectedItem.Text.Trim();
                objMSTEmployee.Name = txtName.Text.Trim();
                objMSTEmployee.Street_Name = txtAdd.Text.Trim();
                objMSTEmployee.Mobile = TxtMobileNo.Text.Trim();                
                objMSTEmployee.Allowpartialpayment = Util.GetInt(0);
                objMSTEmployee.Cadreid = Util.GetInt(ddlCadre.SelectedItem.Value);
                objMSTEmployee.TierID = Util.GetInt(ddlTier.SelectedItem.Value);
                

                string Employee_id = objMSTEmployee.Insert();

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " Update employee_master em set em.TabPosition=2 WHERE em.EmployeeID='" + Employee_id + "' ");

                EmployeeHospital EmHsp = new EmployeeHospital(tranX);
                EmHsp.EmployeeID = Employee_id;
                EmHsp.Hospital_ID = HospID;
                EmHsp.CentreID = Util.GetInt(ddlCentre.SelectedItem.Value);
                EmHsp.Insert();

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO doctor_employee(DoctorID,Employeeid) values('" + DID + "','" + Employee_id + "')");
                int roleid = 323;
                if (ddldoctorgroup.SelectedValue == "3")
                    roleid = 52;
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_login(RoleId,EmployeeID,UserName,Password) values(" + roleid + ",'" + Employee_id + "','" + txtUsername.Text + "','" + Password + "')");
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
                        Doctorid = DID,
                        FK_BranchId = Session["CentreID"].ToString(),
                        EntryBy = Session["ID"].ToString(),
                        LoginName = Util.GetString(txtUsername.Text)
                    });
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

                string filePathNew = Server.MapPath("~/Design/Doctor/DoctorSignature/") + DID + System.IO.Path.GetExtension(filePath);
                if (File.Exists(filePathNew))
                {
                    File.Delete(filePathNew);
                }
                fuDrSignature.SaveAs(filePathNew);
            }
            if (Resources.Resource.ApplicationRunCentreWise == "0")
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + DID + "','" + Session["CentreID"].ToString() + "','" + Session["ID"].ToString() + "')");
            }
            else
            {
                int oldCentreID = 0, newCentreID = 0;
                for (int i = 0; i < grdTime.Rows.Count; i++)
                {
                    if (i == 0)
                    {
                        oldCentreID = newCentreID = Util.GetInt(((Label)grdTime.Rows[i].FindControl("lblCentreID")).Text.ToString().Trim());
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + DID + "','" + newCentreID + "','" + Session["ID"].ToString() + "')");
                    }
                    else
                    {
                        newCentreID = Util.GetInt(((Label)grdTime.Rows[i].FindControl("lblCentreID")).Text.ToString().Trim());
                        if (oldCentreID != newCentreID)
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_center_doctor CD set isActive=0 WHERE isActive=1 AND CD.DoctorID='" + DID + "' AND CD.CentreID='" + newCentreID + "' ");
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + DID + "','" + newCentreID + "','" + Session["ID"].ToString() + "')");
                            oldCentreID = newCentreID;
                        }
                    }
                   
                }
            }
            tranX.Commit();

            ClearFields();
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblerrmsg.ClientID + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "Save();", true);
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblerrmsg.ClientID + "');", true);

            return;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void show()
    {
        DataTable dt1 = StockReports.GetDataTable("SELECT Day,Shift,NoOfSlot,StartTime,EndTime,AvgTime,DurationforNewPatient,StartBufferTime,EndBufferTime,DurationforOldPatient,Room_No,Department,,, FROM doctor_hospital where DoctorID='" + Request.QueryString["DID"].ToString() + "'");


        if (dt1 != null && dt1.Rows.Count > 0)
        {
            if (ViewState["dtTime"] != null)
            {
                dtTime = ((DataTable)ViewState["dtTime"]);
            }

            for (int i = 0; i < dt1.Rows.Count; i++)
            {
                if (dt1.Rows[i]["Day"].ToString() == "Monday")
                {
                    chkMon.Checked = true;
                }
                if (dt1.Rows[i]["Day"].ToString() == "Tuesday")
                {
                    chkTues.Checked = true;
                }
                if (dt1.Rows[i]["Day"].ToString() == "Wednesday")
                {
                    chkWed.Checked = true;
                }
                if (dt1.Rows[i]["Day"].ToString() == "Thursday")
                {
                    chkThur.Checked = true;
                }
                if (dt1.Rows[i]["Day"].ToString() == "Friday")
                {
                    chkFri.Checked = true;
                }
                if (dt1.Rows[i]["Day"].ToString() == "Saturday")
                {
                    chkSat.Checked = true;
                }
                if (dt1.Rows[i]["Day"].ToString() == "Sunday")
                {
                    chkSun.Checked = true;
                }

                dtTime = AddTime(dt1.Rows[i]["Day"].ToString(), Util.GetDateTime(dt1.Rows[i]["StartTime"]).ToString("hh:mm:tt"), Util.GetDateTime(dt1.Rows[i]["EndTime"]).ToString("hh:mm:tt"), (dt1.Rows[i]["AvgTime"]).ToString(), (dt1.Rows[i]["DurationforNewPatient"]).ToString(), dtTime, Util.GetInt(dt1.Rows[i]["StartBufferTime"]), Util.GetInt(dt1.Rows[i]["EndBufferTime"]), (dt1.Rows[i]["DurationforOldPatient"]).ToString());
            }
            string time = Util.GetDateTime(dt1.Rows[0]["StartTime"]).ToShortTimeString();
            string hr = Util.GetDateTime(dt1.Rows[0]["StartTime"]).Hour.ToString();
            string min = Util.GetDateTime(dt1.Rows[0]["StartTime"]).Minute.ToString();
            string AMPM = "";

            if (Util.GetInt(hr) > 12)
            {

                AMPM = "PM";
            }
            else
            {
                AMPM = "AM";
            }

            txtHr1.Text = hr.ToString();
            txtMin1.Text = min.ToString();
            cmbAMPM1.SelectedIndex = cmbAMPM1.Items.IndexOf(cmbAMPM1.Items.FindByText(AMPM.ToString()));
            string time1 = Util.GetDateTime(dt1.Rows[0]["EndTime"]).ToShortTimeString();
            string hr1 = Util.GetDateTime(dt1.Rows[0]["EndTime"]).Hour.ToString();
            string min1 = Util.GetDateTime(dt1.Rows[0]["EndTime"]).Minute.ToString();
            string AMPM1 = "";

            if (Util.GetInt(hr1) > 12)
            {

                AMPM1 = "PM";
            }
            else
            {
                AMPM1 = "AM";
            }

            txtHr2.Text = hr1.ToString();
            txtMin2.Text = min1.ToString();
            cmbAMPM2.SelectedIndex = cmbAMPM2.Items.IndexOf(cmbAMPM2.Items.FindByText(AMPM1.ToString()));
            string EndTime = dt1.Rows[0]["EndTime"].ToString();

            txtRoomNo.Text = dt1.Rows[0]["Room_No"].ToString();
            int a = cmbDept.Items.IndexOf(cmbDept.Items.FindByText(dt1.Rows[0]["Department"].ToString()));
            cmbDept.SelectedIndex = cmbDept.Items.IndexOf(cmbDept.Items.FindByText(dt1.Rows[0]["Department"].ToString()));

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
    }

    private string UpdateDoctorTiming()
    {
        DateTime EndTim = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
        DateTime StartTim = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());
        string Etime = EndTim.ToShortTimeString();
        string Stime = StartTim.ToShortTimeString();
        string Day = "";
        if (chkMon.Checked == true)
        {
            Day = "Mon" + ",";
        }
        if (chkTues.Checked == true)
        {
            Day += "Tue" + ",";
        }
        if (chkWed.Checked == true)
        {
            Day += "Wed" + ",";
        }
        if (chkThur.Checked == true)
        {
            Day += "Thur" + ",";
        }
        if (chkFri.Checked == true)
        {
            Day += "Fri" + ",";
        }

        if (chkSat.Checked == true)
        {
            Day += "Sat" + ",";
        }
        if (chkSun.Checked == true)
        {
            Day += "Sun" + ",";
        }

        if (Day == "" && grdTime.Rows.Count > 0)
        {
            foreach (GridViewRow row in grdTime.Rows)
            {
                Day += row.Cells[0].Text.Substring(0, 3) + ",";
            }
        }

        int userlength = Day.Length - 1;
        Day = Day.Remove(userlength, 1);
        Day += "  " + Stime + "-" + Etime;

        return Day;
    }

    private bool ValidateItems(string day)
    {


        foreach (DataRow row in dtTime.Rows)
        {
            if (row["Day"].ToString() == day)
            {
                return false;

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

    private void Validation()
    {
        TxtMobileNo.Attributes.Add("onKeyUp", "NumberValidatorJS('" + TxtMobileNo.ClientID + "');");
        txtPhone1.Attributes.Add("onKeyUp", "NumberValidatorJS('" + txtPhone1.ClientID + "');");

        if (Request.QueryString["updateFlag"].ToString() == "0")
        {
            btnSave.Attributes.Add("OnClick", "DoctorRegJS('" + txtName.ClientID + "','" + cmbTitle.ClientID + "','" + txtAdd.ClientID + "','" + txtPhone1.ClientID + "','" + TxtMobileNo.ClientID + "');return false;");
        }
        else
        {
            lblerrmsg.Text = "Record not Saved";
        }
    }

    private void Validation1()
    {
        txtHr1.Attributes.Add("onKeyUp", "TimeValidatorJS('" + txtHr1.ClientID + "','" + txtMin1.ClientID + "',11);");
        txtMin1.Attributes.Add("onKeyUp", "TimeValidatorJS('" + txtMin1.ClientID + "','" + cmbAMPM1.ClientID + "',59);");
    }
    protected void rbtnType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnType.SelectedItem.Value == "1")
        {
            trDaysWise.Visible = true;
            trDateWise.Visible = false;
        }
        else
        {
            trDaysWise.Visible = false;
            trDateWise.Visible = true;
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
    protected void btnNASearch_Click(object sender, EventArgs e)
    {
        DataTable dtALL = new DataTable();
        if (ViewState["OldNADate"] != null)
            dtALL = (DataTable)ViewState["OldNADate"];

        string sql = "CALL get_temp_date('" + Util.GetDateTime(txtNotAvailableDateFrom.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtNotAvailableDateTo.Text).ToString("yyyy-MM-dd") + "','','" + ddlNACentre.SelectedItem.Text + "','" + Util.GetInt(ddlNACentre.SelectedItem.Value) + "')";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dtALL == null || dtALL.Rows.Count == 0)
            {
                dtALL = dt;
            }
            else
            {
                foreach (DataRow row in dt.Rows)
                {
                    DataRow[] dr = dtALL.Select("DateValue = '" + row["DateValue"].ToString() + "' AND CentreID = " + row["CentreID"].ToString() + "");
                    if (dr.Length == 0)
                    {
                        dtALL.Rows.Add(row.ItemArray);
                    }
                }
            }
            dtALL.AcceptChanges();
            ViewState["OldNADate"] = dtALL;
        }
        if (dtALL != null && dtALL.Rows.Count > 0)
        {
            grdNATiming.DataSource = dtALL;
            grdNATiming.DataBind();
        }
        else
        {
            grdNATiming.DataSource = null;
            grdNATiming.DataBind();
        }
    }
}