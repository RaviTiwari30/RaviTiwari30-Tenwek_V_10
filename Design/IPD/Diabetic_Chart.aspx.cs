using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
public partial class Design_IPD_Diabetic_Chart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = string.Empty;
            All_LoadData.bindDoctor(ddlDoctor);
            //ddlDoctor.SelectedIndex= ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue("LSHHI113"));
            if (Request.QueryString["TransactionID"] == null)
            {
                TID = Request.QueryString["TID"].ToString();
                ViewState["TransactionID"] = TID;
                ViewState["PatientID"] = Request.QueryString["PID"].ToString();
                //string DoctorID = StockReports.ExecuteScalar("Select DoctorID from appointment Where TransactionID='" + TID + "'");
                //ddlDoctor.SelectedIndex = (ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(DoctorID)));
                calDate.EndDate = DateTime.Now;
                calDate.StartDate = DateTime.Now;
            }
            else
            {
                TID = Request.QueryString["TransactionID"].ToString();
                ViewState["TransactionID"] = TID;
                ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
                dt = AllLoadData_IPD.getAdmitDischargeData(ViewState["TransactionID"].ToString());
                if (TID.Contains("ISHHI"))
                {
                    calDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
                    if (dt.Rows[0]["Status"].ToString() == "OUT")
                    {
                        calDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
                        btnSave.Visible = false;
                        btnUpdate.Visible = false;
                        bynCancel.Visible = false;
                    }
                    else
                    {
                        calDate.EndDate = DateTime.Now;
                    }
                }
            }
            bindDiabiaticChart();
        }
        txtDate.Attributes.Add("readOnly", "readOnly");

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (ddlParticular.SelectedValue != "0" && txtCBG.Text != "")
            {
                string sb = "INSERT INTO Diabiatic_chart(PatientID,TransactionID,Date,Time,Particulars,CBG,Correction,DrName, " +
                      " EntryBy)VALUES('" + ViewState["PatientID"].ToString() + "','" + ViewState["TransactionID"].ToString() + "', " +
                      " '" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "', " +
                       " '" + ddlParticular.SelectedItem.Text + "','" + txtCBG.Text.Trim() + "','" + txtCorrection.Text.Trim() + "','" + ddlDoctor.SelectedValue + "'," +
                       " '" + Session["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                if (ViewState["TransactionID"].ToString().Contains("ISHHI"))
                {
                    string MaxID = (StockReports.ExecuteScalar("SELECT IFNULL((MAX(ID)+1),1)ID FROM Diabiatic_chart"));
                    string notification = Notification_Insert.notificationInsert(32, MaxID, tnx, Util.GetString(ddlDoctor.SelectedValue), "", 52, DateTime.Now.ToString("yyyy-MM-dd"), "");
                }
                tnx.Commit();
                Clear();
            }
            else
            {
                lblMsg.Text = "Please Select The Particular And Enter CBG";
                ddlParticular.Focus();
            }
            bindDiabiaticChart();
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
    private DataTable Search()
    {
        DataTable dt = StockReports.GetDataTable("SELECT dc.ID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%h:%i %p')TIME,Particulars,CBG,Correction,dm.Name AS DrName,em.Name AS EntryBy,dc.EntryBy As UserID, DATE_FORMAT(dc.EntryDate,'%d-%b-%Y %h:%i %p')EntryDate FROM Diabiatic_chart dc" +
                                               " INNER JOIN employee_master em ON em.EmployeeID=dc.EntryBy " +
                                               "  INNER JOIN doctor_master dm ON dm.DoctorID= dc.DrName WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ");
        return dt;
    }
    private void bindDiabiaticChart()
    {
        DataTable dtDiabiatic = Search();
        if (dtDiabiatic.Rows.Count > 0)
        {
            grdDiabiatic.DataSource = dtDiabiatic;
            grdDiabiatic.DataBind();
        }
    }
    protected void grdDiabiatic_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            if (((Label)grdDiabiatic.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString())
            {
                ((ImageButton)grdDiabiatic.Rows[id].FindControl("imgbtnEdit")).Enabled = true;
                lblID.Text = ((Label)grdDiabiatic.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdDiabiatic.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdDiabiatic.Rows[id].FindControl("lblTime")).Text;
                ddlParticular.SelectedIndex = ddlParticular.Items.IndexOf(ddlParticular.Items.FindByValue(((Label)grdDiabiatic.Rows[id].FindControl("lblParticulars")).Text));
                txtCBG.Text = ((Label)grdDiabiatic.Rows[id].FindControl("lblCBG")).Text;
                txtCorrection.Text = ((Label)grdDiabiatic.Rows[id].FindControl("lblCorrection")).Text;
                ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue((((Label)grdDiabiatic.Rows[id].FindControl("lblDrName")).Text)));
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                bynCancel.Visible = true;
            }
            else
            {
                ((ImageButton)grdDiabiatic.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                lblMsg.Text = "You are not able to Edit this Note";
            }

        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (ddlParticular.SelectedValue != "0" && txtCBG.Text != "")
            {
                string sb = "update Diabiatic_chart Set Date='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',Time='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "' " +
                            " ,Particulars='" + ddlParticular.SelectedItem.Text + "', CBG='" + txtCBG.Text + "',Correction='" + txtCorrection.Text + "',DrName='" + ddlDoctor.SelectedValue + "',EntryBy='" + Session["ID"].ToString() + "', " +
                            " EntryDate=NOW() where ID='" + lblID.Text + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                Clear();
                bindDiabiaticChart();
                btnSave.Visible = true;
                btnUpdate.Visible = false;
                bynCancel.Visible = false;
            }
            else
            {
                lblMsg.Text = "Please Select The Particular Or Enter CBG Value";
                ddlParticular.Focus();
            }
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
    protected void bynCancel_Click(object sender, EventArgs e)
    {
        Clear();
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        bynCancel.Visible = false;
    }
    private void Clear()
    {
        txtCorrection.Text = "";
        txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.ToString("hh:mm tt");
        ddlParticular.SelectedValue = "0";
        txtCBG.Text = "";
        ddlDoctor.SelectedIndex = 0;
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = Search();
        DataSet ds = new DataSet();
        if (dt.Rows.Count > 0)
        {
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "Diabi";
            DataTable dtStatus = new DataTable();
            DataTable dtInfo = new DataTable();
            if (string.IsNullOrEmpty(Request.QueryString["EMGNo"]))
            {
                AllQuery AQ = new AllQuery();
                dtStatus = AQ.GetPatientDischargeStatus(ViewState["TransactionID"].ToString());
                string Status = dtStatus.Rows[0]["Status"].ToString();
                dtInfo = AQ.GetPatientIPDInformation("", ViewState["TransactionID"].ToString(), Status);

            }
            else
            {
                string str = "SELECT pmh.Type,PM.Title,IF(pmh.height=' cm','',pmh.height)height,IF(pmh.weight=' KG','',pmh.weight)weight,pmh.allergies, ";
                str += "(SELECT ReferredBy FROM patient_referredby WHERE TransactionID=pmh.TransactionID)ReferedBy,PM.PName, ";
                str += "        CONCAT(PM.Age,'/',IF(pm.DOB<>'0001-01-01',DATE_FORMAT(pm.DOB,'%d-%b-%y'),''))Age,PM.Gender,PMH.PatientID AS Patient_ID,PMH.DoctorID AS Doctor_ID,";
                str += "PMH.ScheduleChargeID,PMH.Admission_Type,CONCAT(RM.Room_No,'/',RM.Name) RoomNo,FPM.Company_Name,PMH.TransactionID AS Transaction_ID,";
                str += "FPM.ReferenceCode,emg.IPDCaseTypeID AS IPDCaseType_ID,FPM.PanelID AS Panel_ID,emg.RoomID AS Room_ID,PMH.Employeeid AS Employee_id,PMH.PolicyNo,PMH.CardNo,";
                str += "PMH.MLC_NO,pmh.TransNo FROM emergency_patient_details emg ";
                str += "INNER JOIN (";
                str += " SELECT Height,Allergies,Weight,PatientID,TransactionID,PanelID,DoctorID,ScheduleChargeID,IFNULL(Admission_Type,'')Admission_Type,";
                str += "  Employeeid,PolicyNo,ReferedBy ReferedBy,CardNo,MLC_NO,TYPE,TransNo FROM patient_medical_history WHERE TransactionID = '" + Util.GetInt(ViewState["TransactionID"]) + "' AND TYPE='EMG' )PMH ";
                str += "    ON emg.TransactionID= PMH.TransactionID ";
                str += "     INNER JOIN Patient_Master PM ON PM.PatientID = PMH.PatientID ";
                str += "      LEFT JOIN room_master RM ON rm.RoomID= emg.RoomID ";
                str += "      INNER JOIN f_panel_master FPM ON PMH.PanelID = FPM.PanelID  ";
                str += "       ORDER BY PM.PName ;";
                dtInfo = StockReports.GetDataTable(str);
            }
            if (dtStatus != null)
            {
                ds.Tables.Add(dtInfo.Copy());
                ds.Tables[1].TableName = "PatientInfo";
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[2].TableName = "logo";
                // ds.WriteXmlSchema(@"E:\DiabeticAnkur.xml");
                Session["ReportName"] = "DiabeticChart";
                Session["ds"] = ds;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }
    protected void grdDiabiatic_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

        }
    }
}