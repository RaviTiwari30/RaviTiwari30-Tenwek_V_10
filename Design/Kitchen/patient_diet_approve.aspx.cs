using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Linq;
public partial class Design_Kitchen_patient_diet_approve : System.Web.UI.Page
{

    protected void btnFreeze_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            bool flag = false;
            foreach (GridViewRow row in grdPatientDiet.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked && ((Label)row.FindControl("lblFreeze")).Text != "1")
                {
                    if (((Label)row.FindControl("lblType")).Text.ToUpper() == "PATIENT")
                    {
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request SET IsFreeze = '1',FreezeBy='" + ViewState["ID"].ToString() + "',FreezeDate=NOW(),FreezeIPAddress='" + HttpContext.Current.Request.UserHostAddress + "'  WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "'");
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_attendent_diet_request SET IsFreeze = '1',FreezeBy='" + ViewState["ID"].ToString() + "',FreezeDate=NOW(),FreezeIPAddress='" + HttpContext.Current.Request.UserHostAddress + "'  WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "'");
                    }
                    flag = true;
                }
            }
            Tranx.Commit();
            if (flag)
            {
                lblMsg.Text = "Diet Freezed Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Freezed Successfully');", true);
                BindGrid();
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Sorry, No Diet Available To Freeze');", true);
              //  lblMsg.Text = "Sorry, No Diet Available To Freeze";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + ex.Message + "');", true);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (ddlDietTiming.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Diet Timing";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Diet Timing');", true);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dsm.SubDietID,dsm.Name FROM diet_map_diet_component dmdc");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID=dmdc.DietTimeID ");
        sb.Append(" WHERE dt.ID='" + ddlDietTiming.SelectedValue + "' ");
        sb.Append(" GROUP BY dsm.SubDietID ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        ViewState.Add("SubDiet", oDT);

        BindGrid();
        if (grdPatientDiet.Rows.Count > 0)
        {
            lblMsg.Text = "";
            btnReport.Visible = true;
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Not Found');", true);
          //  lblMsg.Text = "Record Not Found";
    }
    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT * FROM ( ");
        sb.Append("SELECT 'Patient' AS `Type`,rm.Bed_No,rm.Room_No , dpdr.IsReceived,dpdr.ID RequestID,adj.PatientID, adj.`TransNo`  AS IPDNo,dpdr.TransactionID as TransactionID, ");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName) AS PName, CONCAT(rm.Name,'-',rm.Room_No,' /','Bed:',rm.Bed_No) AS 'Room_NAME',dpdr.SubDietID, ");
        sb.Append(" dsm.Name AS 'SubDietName',dpdr.DietMenuID,dmm.Name AS 'MenuName',dpdr.Remarks,dpdr.IsFreeze,dpdr.IsIssued,dpdr.DietID,ddm.name as 'DietName',adj.PanelID,adj.Patient_Type,dpdr.IPDCaseTypeID,rm.RoomID ");

        sb.Append(" from diet_patient_diet_request dpdr");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId=dpdr.RoomID ");
        sb.Append(" INNER JOIN Patient_medical_history adj ON adj.TransactionID = dpdr.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dpdr.SubDietID ");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dpdr.DietMenuID ");
        sb.Append(" INNER JOIN diet_diettype_master ddm on ddm.DietID=dpdr.DietID");

        sb.Append(" where DATE(dpdr.RequestDate)='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' AND dpdr.DietTimeID='" + ddlDietTiming.SelectedValue + "'");
        if (ddlWard.SelectedIndex > 0)
            sb.Append("and dpdr.IPDCaseTypeID='" + ddlWard.SelectedValue + "'");
        if (ddlFloor.SelectedIndex > 0)
            sb.Append("and rm.Floor='" + ddlFloor.SelectedValue + "'");

        sb.Append(" UNION ALL ");

        sb.Append("SELECT 'Attendent' AS `Type`,rm.Bed_No,rm.Room_No , dpdr.IsReceived,dpdr.ID RequestID,adj.PatientID, adj.`TransNo`  AS IPDNo,dpdr.TransactionID as TransactionID, ");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName) AS PName, CONCAT(rm.Name,'-',rm.Room_No,' /','Bed:',rm.Bed_No) AS 'Room_NAME',dpdr.SubDietID, ");
        sb.Append(" dsm.Name AS 'SubDietName',dpdr.DietMenuID,dmm.Name AS 'MenuName',dpdr.Remarks,dpdr.IsFreeze,dpdr.IsIssued,dpdr.DietID,ddm.name as 'DietName',adj.PanelID,adj.Patient_Type,dpdr.IPDCaseTypeID,rm.RoomID ");

        sb.Append(" from diet_attendent_diet_request dpdr");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId=dpdr.RoomID ");
        sb.Append(" INNER JOIN Patient_medical_history adj ON adj.TransactionID = dpdr.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dpdr.SubDietID ");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dpdr.DietMenuID ");
        sb.Append(" INNER JOIN diet_diettype_master ddm on ddm.DietID=dpdr.DietID");

        sb.Append(" where DATE(dpdr.RequestDate)='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' AND dpdr.DietTimeID='" + ddlDietTiming.SelectedValue + "'");
        if (ddlWard.SelectedIndex > 0)
            sb.Append("and dpdr.IPDCaseTypeID='" + ddlWard.SelectedValue + "'");
        if (ddlFloor.SelectedIndex > 0)
            sb.Append("and rm.Floor='" + ddlFloor.SelectedValue + "'");

        sb.Append(" )temp ORDER BY temp.Room_No,temp.Bed_No");


        DataTable oDT = StockReports.GetDataTable(sb.ToString());



        grdPatientDiet.DataSource = oDT;
        grdPatientDiet.DataBind();
        btnIssueAll.Visible = true;
        //oDT = oDT.AsEnumerable().Where(r => r.Field<string>("IsReceived") == "0").Where(r => r.Field<string>("IsIssued") == "0").AsDataView().ToTable();
        //if (oDT.Rows.Count > 0)
        //{
        //    btnIssueAll.Visible = true;
        //}
        //else
        //{
        //    btnIssueAll.Visible = false;
        //}
    }
    protected void btnIssue_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TID = ((Label)row.FindControl("lblTID")).Text;
            string PID = ((Label)row.FindControl("lblMRNo")).Text;
            string PanelID = ((Label)row.FindControl("lblPanelID")).Text;
            string Patient_Type = ((Label)row.FindControl("lblPatient_Type")).Text;
            string requestID = ((Label)row.FindControl("lblID")).Text;
            string IPDCaseType_ID = ((Label)row.FindControl("lblIPDCaseTypeID")).Text;
            string Room_ID = ((Label)row.FindControl("lblRoom_ID")).Text;
            string type = ((Label)row.FindControl("lblType")).Text.ToUpper();
            string data = "";

            DataTable dtItem = StockReports.GetDataTable("SELECT ComponentID,ComponentName ItemDisplayName,ItemID,Rate,Quantity,RateListID,NOW() Date,'" + Resources.Resource.DietSubcategoryID + "' SubCategoryID,'7' TnxTypeID,'' ItemCode,'" + Resources.Resource.DoctorID_Self + "' DoctorID,'0' DocCharges,'10'ConfigID   FROM diet_patient_component_detail WHERE RequestedID='" + requestID + "'");
           // dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, PID, "IPD-Billing", Util.GetInt(PanelID), ViewState["ID"].ToString(), TID, Util.GetString(Session["HOSPID"].ToString()), "Yes", "1", Tranx, IPDCaseType_ID, Patient_Type.Trim(), con, Room_ID);
            //if (dtItem != null)
            //{
                if (type == "PATIENT")
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request SET IsIssued = '1',IssueBy='" + ViewState["ID"].ToString() + "',IssueDate=NOW(),IssueIPAddress='" + HttpContext.Current.Request.UserHostAddress + "' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "' ");
                    Notification_Insert.notificationInsert(11, Util.GetString(((Label)row.FindControl("lblID")).Text), Tranx, "", IPDCaseType_ID, 0, "", "");
                    if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
                    {
                        data = data + "" + (data == "" ? "" : "^") + Util.GetString(((Label)row.FindControl("lblIPDNo")).Text) + "#"
                               + Util.GetString(((Label)row.FindControl("lblMRNo")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblPName")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblDiet")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblSubDiet")).Text) + "#"
                               + Util.GetString(((Label)row.FindControl("lblMenu")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblRoomName")).Text);
                    }
                    Tranx.Commit();
                    lblMsg.Text = "Diet Issued Successfully";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Issued Successfully');", true);
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "WriteToFile('" + data + "');", true);
                    btn.Enabled = false;
                    row.BackColor = System.Drawing.Color.YellowGreen;
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_attendent_diet_request SET IsIssued = '1',IssueBy='" + ViewState["ID"].ToString() + "',IssueDate=NOW(),IssueIPAddress='" + HttpContext.Current.Request.UserHostAddress + "' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "' ");
                    Notification_Insert.notificationInsert(11, Util.GetString(((Label)row.FindControl("lblID")).Text), Tranx, "", IPDCaseType_ID, 0, "", "");
                    if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
                    {
                        data = data + "" + (data == "" ? "" : "^") + Util.GetString(((Label)row.FindControl("lblIPDNo")).Text) + "#"
                               + Util.GetString(((Label)row.FindControl("lblMRNo")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblPName")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblDiet")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblSubDiet")).Text) + "#"
                               + Util.GetString(((Label)row.FindControl("lblMenu")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblRoomName")).Text);
                    }
                    Tranx.Commit();
                    lblMsg.Text = "Diet Issued Successfully";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Issued Successfully');", true);
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "WriteToFile('" + data + "');", true);
                    btn.Enabled = false;
                    row.BackColor = System.Drawing.Color.YellowGreen;
                }
            //}
            //else
            //{
            //    Tranx.Rollback();
            //    lblMsg.Text = "Error occurred, Please contact administrator ";
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator ');", true);
            //}
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator ";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator ');", true);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnIssueAll_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string data = "";
            foreach (GridViewRow row in grdPatientDiet.Rows)
            {
                if ((((Label)row.FindControl("lblFreeze")).Text == "1") && (((Label)row.FindControl("lblIssue")).Text == "0") && (((Label)row.FindControl("lblReceive")).Text == "0"))
                {
                    if (((CheckBox)row.FindControl("chkSelect")).Checked)
                    {
                        if (((Label)row.FindControl("lblType")).Text.ToUpper() == "PATIENT")
                        {
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request SET IsIssued = '1',IssueBy='" + ViewState["ID"].ToString() + "',IssueDate=NOW(),IssueIPAddress='" + HttpContext.Current.Request.UserHostAddress + "' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "' ");
                            DataTable dtItem = StockReports.GetDataTable("SELECT ComponentID,ComponentName ItemDisplayName,ItemID,Rate,Quantity,RateListID,NOW() Date,'" + Resources.Resource.DietSubcategoryID + "' SubCategoryID,'7' TnxTypeID,'' ItemCode,'" + Resources.Resource.DoctorID_Self + "' DoctorID,'0' DocCharges,'10'ConfigID   FROM diet_patient_component_detail WHERE RequestedID='" + ((Label)row.FindControl("lblID")).Text + "'");
                         //   dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, ((Label)row.FindControl("lblMRNo")).Text, "IPD-Billing", Util.GetInt(((Label)row.FindControl("lblPanelID")).Text), ViewState["ID"].ToString(), ((Label)row.FindControl("lblTID")).Text, Util.GetString(Session["HOSPID"].ToString()), "Yes", "1", Tranx, ((Label)row.FindControl("lblIPDCaseTypeID")).Text, ((Label)row.FindControl("lblPatient_Type")).Text.Trim(), con, ((Label)row.FindControl("lblRoom_ID")).Text.Trim());

                            if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
                            {
                                data = data + "" + (data == "" ? "" : "^") + Util.GetString(((Label)row.FindControl("lblIPDNo")).Text) + "#"
                                       + Util.GetString(((Label)row.FindControl("lblMRNo")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblPName")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblDiet")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblSubDiet")).Text) + "#"
                                       + Util.GetString(((Label)row.FindControl("lblMenu")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblRoomName")).Text);
                            }
                         /*   if (dtItem != null)
                            {
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request SET IsIssued = '1',IssueBy='" + ViewState["ID"].ToString() + "',IssueDate=NOW(),IssueIPAddress='" + HttpContext.Current.Request.UserHostAddress + "' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "' ");
                                Notification_Insert.notificationInsert(11, Util.GetString(((Label)row.FindControl("lblID")).Text), Tranx, "", ((Label)row.FindControl("lblIPDCaseTypeID")).Text, 0, "", "");
                               
                            }*/
                        }
                        else
                        {
                            DataTable dtItem = StockReports.GetDataTable("SELECT ComponentID,ComponentName ItemDisplayName,ItemID,Rate,Quantity,RateListID,NOW() Date,'" + Resources.Resource.DietSubcategoryID + "' SubCategoryID,'7' TnxTypeID,'' ItemCode,'" + Resources.Resource.DoctorID_Self + "' DoctorID,'0' DocCharges,'10'ConfigID   FROM diet_attendent_Component_Detail WHERE RequestedID='" + ((Label)row.FindControl("lblID")).Text + "'");
                           // dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, ((Label)row.FindControl("lblMRNo")).Text, "IPD-Billing", Util.GetInt(((Label)row.FindControl("lblPanelID")).Text), ViewState["ID"].ToString(), ((Label)row.FindControl("lblTID")).Text, Util.GetString(Session["HOSPID"].ToString()), "Yes", "1", Tranx, ((Label)row.FindControl("lblIPDCaseTypeID")).Text, ((Label)row.FindControl("lblPatient_Type")).Text.Trim(), con, ((Label)row.FindControl("lblRoom_ID")).Text.Trim());

                            if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
                            {
                                data = data + "" + (data == "" ? "" : "^") + Util.GetString(((Label)row.FindControl("lblIPDNo")).Text) + "#"
                                       + Util.GetString(((Label)row.FindControl("lblMRNo")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblPName")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblDiet")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblSubDiet")).Text) + "#"
                                       + Util.GetString(((Label)row.FindControl("lblMenu")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblRoomName")).Text);
                            }
                           /* if (dtItem != null)
                            {
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_attendent_diet_request SET IsIssued = '1',IssueBy='" + ViewState["ID"].ToString() + "',IssueDate=NOW(),IssueIPAddress='" + HttpContext.Current.Request.UserHostAddress + "' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "' ");
                                Notification_Insert.notificationInsert(11, Util.GetString(((Label)row.FindControl("lblID")).Text), Tranx, "", ((Label)row.FindControl("lblIPDCaseTypeID")).Text, 0, "", "");
                               
                            }*/
                        }
                    }
                    //string IPDCaseType_ID = ((Label)row.FindControl("lblIPDCaseTypeID")).Text;
                    //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request SET IsIssued = '1',IssueBy='" + ViewState["ID"].ToString() + "',IssueDate=NOW() WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "'");
                    //Notification_Insert.notificationInsert(11, Util.GetString(((Label)row.FindControl("lblID")).Text), Tranx, "", IPDCaseType_ID, 0, "", "");
                    //if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
                    //{
                    //    data = data + "" + (data == "" ? "" : "^") + Util.GetString(((Label)row.FindControl("lblIPDNo")).Text) + "#"
                    //           + Util.GetString(((Label)row.FindControl("lblMRNo")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblPName")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblDiet")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblSubDiet")).Text) + "#"
                    //           + Util.GetString(((Label)row.FindControl("lblMenu")).Text) + "#" + Util.GetString(((Label)row.FindControl("lblRoomName")).Text);
                    //}
                }
            }
            Tranx.Commit();
            lblMsg.Text = "Diet Issued Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Diet Issued Successfully');", true);
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "WriteToFile('" + data + "');", true);
            BindGrid();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + ex.Message + "');", true);
            lblMsg.Text = ex.Message;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnReportDetail_Click(object sender, EventArgs e)
    {
        if (rblReportType.SelectedValue == "Summary")
            SummaryReport();
        else
            DetailReport();

        AllLoadData_Diet.bindDietType(ddlDietType, "Select");
        AllLoadData_Diet.bindDietTime(ddltiming, "Select");
        AllLoadData_Diet.bindDietMenu(ddlmenu, "Select");
    }
    protected void grdPatientDiet_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "PrintLabel")
        {
            foreach (GridViewRow row in grdPatientDiet.Rows)
            {
                if (((CheckBox)row.FindControl("chkLabl")).Checked)
                {
                    if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
                    {
                        string data = e.CommandArgument.ToString();
                        data = data + "" + (data == "" ? "" : "^") + data.Split('#')[0].ToString() + "#"
                               + data.Split('#')[1].ToString() + "#" + data.Split('#')[2].ToString() + "#" + data.Split('#')[3].ToString() + "#" + data.Split('#')[4].ToString() + "#" +
                             data.Split('#')[5].ToString() + "#" + data.Split('#')[6].ToString();
                        // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "WriteToFile('" + data + "');", true);
                    }
                    else
                        lblMsg.Text = "Please On The Bacode Sticket";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please On The Bacode Sticket');", true);
                }
            }
            //if (Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0].ToString() == "4")
            //{
            //    string data = e.CommandArgument.ToString();
            //    data = data + "" + (data == "" ? "" : "^") + data.Split('#')[0].ToString() + "#"
            //           + data.Split('#')[1].ToString() + "#" + data.Split('#')[2].ToString() + "#" + data.Split('#')[3].ToString() + "#" + data.Split('#')[4].ToString() + "#" +
            //         data.Split('#')[5].ToString() + "#" + data.Split('#')[6].ToString();
            //   // ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "WriteToFile('" + data + "');", true);
            //}
            //else
            //    lblMsg.Text = "Please On The Bacode Sticket";
        }
    }

    protected void grdPatientDiet_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblFreeze")).Text == "1")
            {
                ((CheckBox)e.Row.FindControl("chkSelect")).Checked = true;
                e.Row.BackColor = System.Drawing.Color.LemonChiffon;
                ((CheckBox)e.Row.FindControl("chkSelect")).Enabled = false;
               // ((CheckBox)grdPatientDiet.HeaderRow.FindControl("checkAll")).Enabled = false;
                ((Button)e.Row.FindControl("btnIssue")).Enabled = true;
            }
            else
                ((Button)e.Row.FindControl("btnIssue")).Enabled = false;

            e.Row.BackColor = System.Drawing.Color.Pink;
            if (((Label)e.Row.FindControl("lblFreeze")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LemonChiffon;
            }

            if (((Label)e.Row.FindControl("lblIssue")).Text == "1")
            {
                ((Button)e.Row.FindControl("btnIssue")).Enabled = false;
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            if (((Label)e.Row.FindControl("lblReceive")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightSeaGreen;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            AllLoadData_IPD.bindCaseType(ddlWard, "Select", 0);
            AllLoadData_Diet.bindDietTime(ddlDietTiming, "Select");
            AllLoadData_Diet.bindDietType(ddlDietType, "Select");

            AllLoadData_Diet.bindDietTime(ddltiming, "Select");
            AllLoadData_Diet.bindDietMenu(ddlmenu, "Select");
            bindFloor();
            ucDate.Attributes.Add("readOnly", "readOnly");
            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
        }
    }

    private void bindFloor()
    {
        DataTable dt = All_LoadData.LoadFloor();
        if (dt.Rows.Count > 0)
        {
            ddlFloor.DataSource = dt;
            ddlFloor.DataTextField = "NAME";
            ddlFloor.DataValueField = "NAME";
            ddlFloor.DataBind();
            ddlFloor.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    private void DetailReport()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT adj.PatientID 'UHID',REPLACE(pip.`TransactionID`,'ISHHI','') AS 'IPD No.',CONCAT(pm.Title,' ',pm.PName) AS 'Patient Name', CONCAT(rm.Name,'-',rm.Room_No,' /','Bed:',rm.Bed_No,' /',' Floor:',rm.Floor) AS 'Room Name',dsm.Name AS 'SubDietType',dmm.Name AS 'MenuName',dpdr.Remarks, ");
        sb.Append(" GROUP_CONCAT(CONCAT(dpcd.COmponentName,'(Qty: ',Quantity,')')) ComponentName");
        sb.Append(" FROM patient_ipd_profile pip ");
        sb.Append(" INNER JOIN diet_patient_diet_request dpdr ON dpdr.TransactionID=pip.TransactionID AND DATE(dpdr.RequestDate)='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' AND dpdr.DietTimeID='" + ddlDietTiming.SelectedValue + "'  ");
        sb.Append(" INNER JOIN diet_patient_Component_Detail dpcd ON dpcd.RequestedID=dpdr.ID ");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId=pip.RoomID ");
        sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID = pip.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dpdr.SubDietID ");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dpdr.DietMenuID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID=dpdr.DietTimeID ");
        sb.Append(" WHERE pip.Status='IN' ");
        if (ddlWard.SelectedIndex > 0)
            sb.Append(" AND pip.IPDCaseType_ID='" + ddlWard.SelectedValue + "' ");
        if (ddltiming.SelectedItem.Text != "Select")
        {
            sb.Append("  AND dt.ID='" + ddltiming.SelectedValue + "'  ");
        }
        if (ddlDietType.SelectedItem.Text != "Select")
        {
            if (txtSubdiet.Text != " ")
            {
                sb.Append("  AND dsm.SubDietID='" + txtSubdiet.Text + "'  ");
            }
        }
        if (ddlmenu.SelectedItem.Text != "Select")
        {
            sb.Append("  AND dmm.DietMenuID='" + ddlmenu.SelectedValue + "'  ");
        }
        sb.Append(" GROUP BY dpdr.TransactionID ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = oDT;
            Session["ReportName"] = "Diet Detail Report";
            Session["Period"] = "Request Date :" + Util.GetDateTime(ucDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Not Found');", true);
        }
    }

    private void diettiming()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(" SELECT * FROM diet_timing WHERE isActive=1 ");
        ddltiming.DataSource = dt;
        ddltiming.DataTextField = "Name";
        ddltiming.DataValueField = "id";
        ddltiming.DataBind();
        ddltiming.Items.Insert(0, "Select");
    }
    private void SummaryReport()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT dsm.Name AS 'SubDietType',dmm.Name AS 'MenuName',COUNT(dpdr.SubDietID) AS 'Qty' FROM diet_patient_diet_request dpdr ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dpdr.SubDietID ");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dpdr.DietMenuID ");
        sb.Append(" WHERE DATE(dpdr.RequestDate)='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "'  AND dpdr.DietTimeID='" + ddlDietTiming.SelectedValue + "' ");
        if (ddltiming.SelectedItem.Text != "Select")
        {
            sb.Append("  AND dpdr.DietTimeId='" + ddltiming.SelectedValue + "'  ");
        }
        if (ddlDietType.SelectedItem.Text != "Select")
        {
            if (txtSubdiet.Text != " ")
            {
                sb.Append("  AND dsm.SubDietID='" + txtSubdiet.Text + "'  ");
            }
        }
        if (ddlmenu.SelectedItem.Text != "Select")
        {
            sb.Append("  AND dmm.DietMenuID='" + ddlmenu.SelectedValue + "'  ");
        }
        sb.Append(" GROUP BY dpdr.SubDietID,dpdr.DietMenuID ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = oDT;
            Session["ReportName"] = "Diet Summary Report";
            Session["Period"] = "Request Date :" + Util.GetDateTime(ucDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Not Found');", true);
        }
    }
    protected void btnComponentReport_Click(object sender, EventArgs e)
    {
        DataSet ds = new DataSet();
        int dietTimeID = Convert.ToInt32(ddlDietTiming.SelectedValue);
        DateTime dat = Convert.ToDateTime(ucDate.Text);
        string dt = dat.ToString("yyyy-MM-dd");

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dcm.Name, SUM(dpcd.Quantity) Quantity, dpcd.DietTimeID, dpcd.RequestDate, dt.Name Diet_Name FROM diet_component_master dcm INNER JOIN diet_patient_Component_Detail dpcd ON dpcd.ComponentID=dcm.ComponentID INNER JOIN diet_timing dt ON dt.ID=dpcd.DietTimeID WHERE dpcd.DietTimeID='" + dietTimeID + "' AND dpcd.RequestDate='" + dt + "' GROUP BY dcm.Name");

        DataTable dtt = StockReports.GetDataTable(sb.ToString());
        if (dtt.Rows.Count > 0)
        {
            ds.Tables.Add(dtt.Copy());
            // ds.WriteXmlSchema("E:\\ComponentReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ComponentReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }
}