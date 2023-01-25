using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
public partial class Design_OPD_investigation_master : System.Web.UI.Page
{
    private DataTable dtTime;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategory();
            LoadSubCategory("0");

            BindCentre();
            BindDocTimingShift();
        }
    }

    private void BindModality(string SubcategoryID, string CentreID)
    {
        DataTable dt = StockReports.GetDataTable("Select ID, Name from Modality_Master where IsActive=1 and SubCategoryID='" + SubcategoryID + "' and CentreID="+ CentreID +" order by Name");
        if (dt.Rows.Count > 0)
        {
            ddlModality.DataSource = dt;
            ddlModality.DataTextField = "Name";
            ddlModality.DataValueField = "ID";
            ddlModality.DataBind();
        }
        else
        {
            ddlModality.Items.Clear();

            ddlModality.Items.Insert(0,new ListItem("Select","0"));
        }

    }
    private void LoadCategory()
    {
        DataTable dtcat = StockReports.GetDataTable("SELECT cm.CategoryID,cm.Name FROM f_categorymaster cm INNER JOIN f_configrelation cr ON cr.CategoryID=cm.CategoryID WHERE Active=1 AND cr.ConfigID=3 ");
        ddlCategory.DataSource = dtcat;
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataBind();
    }
    private void LoadSubCategory(string CategoryID)
    {
        DataTable dtSubCategory = All_LoadData.BindSubCategoryByCategory(CategoryID);

        ddlSubCategory.DataSource = dtSubCategory;
        ddlSubCategory.DataValueField = "SubCategoryID";
        ddlSubCategory.DataTextField = "Name";
        ddlSubCategory.DataBind();
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
        }
    }
    private void BindDocTimingShift()
    {
        ddlDocTimingShift.DataSource = StockReports.GetDataTable("SELECT Id,ShiftName FROM VisitShift_master ORDER BY id ");
        ddlDocTimingShift.DataValueField = "Id";
        ddlDocTimingShift.DataTextField = "ShiftName";
        ddlDocTimingShift.DataBind();
    }
    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedValue != "3")
        {
            LoadSubCategory(ddlCategory.SelectedValue.ToString());
            divddlSub.Visible = true;
            divlblSubCategory.Visible = true;
        }
        else
        {
            divddlSub.Visible = false;
            divlblSubCategory.Visible = false;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (ddlSubCategory.SelectedIndex != -1)
        {
            BindModality(ddlSubCategory.SelectedItem.Value.ToString(),Util.GetString(ddlCentre.SelectedValue));
            var modalityID = Util.GetInt(ddlModality.SelectedItem.Value.ToString());
            SearchInvestigationSlotSchedule(modalityID);
        }
        else
            SearchInvestigationSlotSchedule(0);
    }

    private void SearchInvestigationSlotSchedule(int ModalityID)
    {
        lblerrmsg.Text = string.Empty;
        if (ddlCategory.SelectedValue != "3")
        {
            ViewState["dtTime"] = null;
            dtTime = null;
            grdTime.DataSource = null;
            grdTime.DataBind();

            string sql = "select * from investigation_slot_master where SubCategoryID='" + ddlSubCategory.SelectedItem.Value + "' and ModalityID='" + ddlModality.SelectedItem.Value + "'";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sql);

            if (dt != null && dt.Rows.Count > 0)
            {

                ddlduration.SelectedIndex = ddlduration.Items.IndexOf(ddlduration.Items.FindByText(dt.Rows[0]["AvgTime"].ToString()));

                if (ViewState["dtTime"] != null)
                {
                    dtTime = ((DataTable)ViewState["dtTime"]);
                }

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    ddlDocTimingShift.SelectedIndex = ddlDocTimingShift.Items.IndexOf(ddlDocTimingShift.Items.FindByText(dt.Rows[i]["ShiftName"].ToString()));
                    ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(dt.Rows[i]["CentreID"].ToString()));

                    dtTime = AddTime(dt.Rows[i]["Day"].ToString(), Util.GetDateTime(dt.Rows[i]["StartTime"]).ToString("hh:mmtt"), Util.GetDateTime(dt.Rows[i]["EndTime"]).ToString("hh:mmtt"), dt.Rows[i]["AvgTime"].ToString(), dt.Rows[i]["DurationforPatient"].ToString(), dtTime, Util.GetInt(dt.Rows[0]["StartBufferTime"]), Util.GetInt(dt.Rows[0]["EndBufferTime"]));
                }

                grdTime.DataSource = dtTime;
                grdTime.DataBind();
                string EndTime = dt.Rows[0]["EndTime"].ToString();

                if (ViewState["dtTime"] != null)
                {
                    ViewState["dtTime"] = dtTime;
                }
                else
                {
                    ViewState.Add("dtTime", dtTime);
                }
            }




            divLabDetail.Visible = false;
            divRadioDetail.Visible = true;
            btnSaveSchedule.Visible = true;
            btnSaveLab.Visible = false;
        }
        else
        {
            divLabDetail.Visible = true;
            divRadioDetail.Visible = false;
            btnSaveSchedule.Visible = false;
            btnSaveLab.Visible = true;
            DataTable dtSubCategory = StockReports.GetDataTable("SELECT sm.SubCategoryID,sm.Name,IFNULL(im.TotalTestLimit,'')TotalTestLimit,IF(IFNULL(TotalTestLimit,'')='','False','True')isTestLimit FROM f_subcategorymaster sm LEFT JOIN investigation_slot_master im  ON sm.SubCategoryID=im.SubCategoryID WHERE sm.Active=1 AND sm.CategoryID='" + ddlCategory.SelectedValue.ToString() + "' ORDER BY sm.Name");
            grdSubCategory.DataSource = dtSubCategory;
            grdSubCategory.DataBind();

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
                    dtNew.Columns.Add("DurationforPatient");
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
                string DurationforPatient = ddlduration.SelectedValue.ToString().Trim();
                int StartBT = Util.GetInt(txtStartBT.Text.Trim());
                int EndBT = Util.GetInt(txtEndBT.Text.Trim());
                int CentreID = Util.GetInt(ddlCentre.SelectedValue);
                // Devendra Singh 2018-09-26 , Replace function ValidateItems to ValidateItemsNew for multiple doctor shifting.
                if (chkMon.Checked == true)
                {
                    if (ValidateItemsNew("Monday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Monday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
                    }
                }
                if (chkTues.Checked == true)
                {
                    if (ValidateItemsNew("Tuesday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Tuesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
                    }
                }
                if (chkWed.Checked == true)
                {
                    if (ValidateItemsNew("Wednesday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Wednesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
                    }
                }
                if (chkThur.Checked == true)
                {
                    if (ValidateItemsNew("Thursday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Thursday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
                    }
                }
                if (chkFri.Checked == true)
                {
                    if (ValidateItemsNew("Friday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Friday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
                    }
                }
                if (chkSat.Checked == true)
                {
                    if (ValidateItemsNew("Saturday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Saturday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
                    }
                }
                if (chkSun.Checked == true)
                {
                    if (ValidateItemsNew("Sunday", StartTime, EndTime, CentreID))
                    {
                        dtTime = AddTime("Sunday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, DurationforPatient, dtTime, StartBT, EndBT);
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

                grdTime.DataSource = dtTime;
                grdTime.DataBind();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
    private bool ValidateItemsNew(string day, DateTime startTime, DateTime endTime, int CentreID)
    {

        foreach (DataRow row in dtTime.Rows)
        {

            DateTime StartDateTime = Util.GetDateTime(row["StartTime"].ToString());
            DateTime EndDateTime = Util.GetDateTime(row["EndTime"].ToString());
            DateTime SelectedStartDateTime = startTime;
            DateTime SelectedEndDateTime = endTime;

            if (row["Day"].ToString() == day && Util.GetInt(row["CentreID"])==CentreID)
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
    private DataTable AddTime(string Day, string StartTime, string EndTime, string AvgTime, string DurationforPatient, DataTable dt, int StartBT, int EndBT)
    {
        if (dt == null)
        {
            dt = new DataTable();
            dt.Columns.Add("Day");
            dt.Columns.Add("StartTime");
            dt.Columns.Add("EndTime");
            dt.Columns.Add("AvgTime");
            dt.Columns.Add("DurationforPatient");
            dt.Columns.Add("StartBufferTime");
            dt.Columns.Add("EndBufferTime");
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
            dr["DurationforPatient"] = DurationforPatient;
            dr["StartBufferTime"] = StartBT;
            dr["EndBufferTime"] = EndBT;
            dr["ShiftName"] = ddlDocTimingShift.SelectedItem.Text;
            dr["CentreName"] = ddlCentre.SelectedItem.Text;
            dr["CentreID"] = ddlCentre.SelectedItem.Value;
            dt.Rows.Add(dr);
        }
        return dt;
    }

    protected void btnSaveSchedule_Click(object sender, EventArgs e)
    {
        int iFlag = 0;

        if (chkMon.Checked == true || chkMon.Checked == true || chkTues.Checked == true || chkWed.Checked == true || chkThur.Checked == true || chkFri.Checked == true || chkSat.Checked == true || chkSun.Checked == true)
            iFlag = 1;

        if (grdTime.Rows.Count == 0 && iFlag == 0)
        {
            lblerrmsg.Text = "Please Specify Day of OPD Timings..";
            chkMon.Focus();
            return;
        }
        SaveRadiologySchedule();
    }

    private void SaveRadiologySchedule()
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        string SubCategoryID = ddlSubCategory.SelectedItem.Value;
        string SubCategoryName = ddlSubCategory.SelectedItem.Text;
        int Modality = Util.GetInt(ddlModality.SelectedItem.Value);
        string HospID = "";
        try
        {
            string returnStr = "";
              
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from Investigation_Slot_Master where SubCategoryID='" + SubCategoryID + "' and ModalityID='" + ddlModality.SelectedItem.Value + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from Investigation_Slot_Master_detail where SubCategoryID='" + SubCategoryID + "' and ModalityID='" + ddlModality.SelectedItem.Value + "'");

            
            if(grdTime.Rows.Count>0)
            {
                for (int i = 0; i < grdTime.Rows.Count; i++)
                {
                    DateTime EndTime = Util.GetDateTime(grdTime.Rows[i].Cells[3].Text);
                    DateTime StartTime = Util.GetDateTime(grdTime.Rows[i].Cells[2].Text);
                    string Day = grdTime.Rows[i].Cells[1].Text;
                    int AvgTime = Convert.ToInt32(grdTime.Rows[i].Cells[4].Text.ToString().Trim());
                    int StartBT = Util.GetInt(grdTime.Rows[i].Cells[5].Text);
                    int EndBT = Util.GetInt(grdTime.Rows[i].Cells[6].Text);
                    int DurationforPatient = Convert.ToInt32(grdTime.Rows[i].Cells[4].Text.ToString().Trim());
                    string VisitName = ((Label)grdTime.Rows[i].FindControl("lblShiftName")).Text.ToString().Trim();
                    int CentreID = Util.GetInt(((Label)grdTime.Rows[i].FindControl("lblCentreID")).Text.ToString().Trim());
                    if (rbtnType.SelectedItem.Value == "1")
                    {
                        returnStr = saveData(SubCategoryID, Day, StartTime, EndTime, SubCategoryName, AvgTime, StartBT, EndBT, DurationforPatient, tranX, VisitName, Modality);
                        if (returnStr == "0")
                        {
                            tranX.Rollback();
                            return;
                        }


                        DateTime startDateTime = Util.GetDateTime(StartTime);
                        DateTime endDateTime = Util.GetDateTime(EndTime);


                        int tokenno = 1;
                        ExcuteCMD excuteCMD = new ExcuteCMD();
                        while (startDateTime < endDateTime)
                        {
                            var slot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationforPatient).ToString("hh:mm tt");

                            string sqlCMD1 = "INSERT INTO investigation_slot_master_detail (ModalityID,SubCategoryID,SubCategoryName,Day,StartTime,EndTime,Duration,StartEndTimeSlot,ShiftName,CentreID,TokenNo) "
                           + "VALUES(@ModalityID,@SubCategoryID,@SubCategoryName,@Day,@StartTime,@EndTime,@DurationforPatient,@StartEndTimeSlot,@VisitName,@CentreID,@TokenNo)";

                            excuteCMD.DML(tranX, sqlCMD1, CommandType.Text, new
                            {
                                ModalityID = Modality,
                                SubCategoryID = SubCategoryID,
                                SubCategoryName = SubCategoryName,
                                Day = Day,
                                StartTime = startDateTime,
                                EndTime = startDateTime.AddMinutes(DurationforPatient),
                                DurationforPatient = DurationforPatient,
                                StartEndTimeSlot = slot,
                                VisitName = VisitName,
                                CentreID = Util.GetString(Session["CentreID"]),
                                TokenNo = tokenno
                            });
                            startDateTime = startDateTime.AddMinutes(DurationforPatient);
                            tokenno++;
                        }

                    }
                }
            }
            ClearFields();
            tranX.Commit();
            lblerrmsg.Text = "Record Save Successfully";
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = "Some Error Occurred...";

            return;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    
    private string saveData(string SubCategoryID, string Day, DateTime StartTime, DateTime EndTime, string SubCategoryName, int avgtime, int StartBufferTime, int EndBufferTime, int DurationforPatient, MySqlTransaction tnx, string VisitName, int ModalityID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string sqlCMD = "INSERT INTO investigation_slot_master (SubCategoryID,SubCategoryName,DAY,StartTime,EndTime,AvgTime,StartBufferTime,EndBufferTime,DurationforPatient,ShiftName,CentreID,ModalityID) "
                + "VALUES(@SubCategoryID,@SubCategoryName,@Day,@StartTime,@EndTime,@avgtime,@StartBufferTime,@EndBufferTime,@DurationforPatient,@VisitName,@CentreID,@ModalityID)";

            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                SubCategoryID = SubCategoryID,
                Day = Day,
                StartTime = StartTime,
                EndTime = EndTime,
                SubCategoryName = SubCategoryName,
                avgtime = avgtime,
                StartBufferTime = StartBufferTime,
                EndBufferTime = EndBufferTime,
                DurationforPatient = DurationforPatient,
                VisitName = VisitName,
                CentreID = Util.GetString(Session["CentreID"]),
                ModalityID = ModalityID
            });

            DateTime startDateTime = Util.GetDateTime(StartTime.ToString("hh:mm:ss"));
            DateTime endDateTime = Util.GetDateTime(EndTime.ToString("hh:mm:ss"));

            //while (startDateTime < endDateTime)
            //{
               // var slot = startDateTime.ToString("hh:mm tt") + "-" + startDateTime.AddMinutes(DurationforPatient).ToString("hh:mm tt");

               // string sqlCMD1 = "INSERT INTO investigation_slot_master_detail (ModalityID,SubCategoryID,SubCategoryName,Day,StartTime,EndTime,Duration,StartEndTimeSlot,ShiftName,CentreID) "
               //+ "VALUES(@ModalityID,@SubCategoryID,@SubCategoryName,@Day,@StartTime,@EndTime,@DurationforPatient,@StartEndTimeSlot,@VisitName,@CentreID)";

               // excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
               // {
               //     ModalityID = ModalityID,
               //     SubCategoryID = SubCategoryID,
               //     SubCategoryName = SubCategoryName,
               //     Day = Day,
               //     StartTime = StartTime,
               //     EndTime = EndTime,
               //     DurationforPatient = DurationforPatient,
               //     StartEndTimeSlot=slot,
               //     VisitName = VisitName,
               //     CentreID = Util.GetString(Session["CentreID"]),
                   
               // });
           // }


            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";

        }
    }
    protected void btnSaveLab_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var Result = 0;
        foreach (GridViewRow gr in grdSubCategory.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSubCategory")).Checked && Util.GetInt(((TextBox)gr.FindControl("txtTestCount")).Text)==0)
            {
                lblerrmsg.Text = "Please Enter Valid Number of Test Count ";
                return;
            }
        }
        foreach (GridViewRow gr in grdSubCategory.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSubCategory")).Checked)
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from Investigation_Slot_Master where SubCategoryID='" + ((Label)gr.FindControl("lblSubCategoryID")).Text + "'");

                    string sqlCMD = "INSERT INTO investigation_slot_master (SubCategoryID,SubCategoryName,TotalTestLimit,CentreID) VALUES(@SubCategoryID,@SubCategoryName,@TotalTestLimit,@CentreID)";

                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        SubCategoryID = ((Label)gr.FindControl("lblSubCategoryID")).Text,
                        SubCategoryName = ((Label)gr.FindControl("lblSubCategoryName")).Text,
                        TotalTestLimit = ((TextBox)gr.FindControl("txtTestCount")).Text,
                        CentreID = Util.GetString(Session["CentreID"])
                    });
                    Result = 1;
                }
                catch (Exception ex)
                {
                    Result = 0;
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                    lblerrmsg.Text = "Some Error Occurred";
                }
            }
        }
        if (Result == 1)
        {
            tnx.Commit();
            lblerrmsg.Text = "Record Save Successfully";
        }
    }

    private void ClearFields()
    {
        txtHr1.Text = "";
        txtHr2.Text = "";
        txtMin1.Text = "";
        txtMin2.Text = "";
        txtStartBT.Text = "";
        txtEndBT.Text = "";
        ddlduration.SelectedIndex = 0;
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
    }
    protected void ddlModality_SelectedIndexChanged(object sender, EventArgs e)
    {
        SearchInvestigationSlotSchedule(Util.GetInt(ddlModality.SelectedItem.Value));
    }
    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindModality(ddlSubCategory.SelectedItem.Value.ToString(), Util.GetString(ddlCentre.SelectedValue));
        var modalityID = Util.GetInt(ddlModality.SelectedItem.Value.ToString());
        SearchInvestigationSlotSchedule(modalityID);
    }
}