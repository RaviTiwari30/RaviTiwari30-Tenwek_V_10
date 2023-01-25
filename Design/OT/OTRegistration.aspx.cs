using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Web.Services;
using System.Collections.Generic;



public partial class Design_OT_OTRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSchedulingDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            if (Request.QueryString["TID"] == null)
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            else
                ViewState["TID"] = Request.QueryString["TID"].ToString();

            if (Request.QueryString["PID"] == null)
                ViewState["PID"] = Request.QueryString["PatientId"].ToString();
            else
                ViewState["PID"] = Request.QueryString["PID"].ToString();


            DataTable dt = StockReports.GetDataTable("SELECT lt.TransactionID, lt.LedgerTransactionNo, lt.date, otd.Case_Type FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo LEFT JOIN ot_surgerydetail otd ON Otd.TransactionID = ltd.TransactionID WHERE ItemID = '" + Resources.Resource.OTItemID + "' AND ltd.isverified <> 2 AND lt.IsCancel = 0 AND lt.TransactionID='" + ViewState["TID"].ToString() + "'");
            if (dt.Rows.Count > 0)
            {
                ViewState["LedgerTransactionNo"] = dt.Rows[0]["LedgerTransactionNo"].ToString();
                ViewState["status"] = "IPD";
                All_LoadData.bindDoctor(ddlSurgeon, "Select");
                BindAssistantDoctor();
                BindSurgery();
                BindDoctor();
                binddata();
                bindSchudleDetails();
            }
            else
            {
                lblMsg.Text = "Please Prescribe OT Pack First.";
                btnsave.Enabled = false;
             
            }




           // ViewState["LedgerTransactionNo"] = Request.QueryString["LedgerTransactionNo"].ToString();
            //if (Request.QueryString["Status"].ToString().Trim() == "IN")
            //{
            //    ViewState["status"] = "IPD";
            //}
            //else
            //{ ViewState["status"] = "OPD"; }


            
        }
        txtSchedulingDate.Attributes.Add("readOnly", "readOnly");
        // calendarExteTxtSchedulingDate.StartDate = DateTime.Now;
    }


    public void bindSchudleDetails()
    {
        DataTable dt = StockReports.GetDataTable("SELECT s.IsReSchedule,s.IsRejected,s.IsExpired, s.IsApproved,s.OT, DATE_FORMAT(s.ScheduleFromDateTime,'%d-%b-%Y') ScheduleDate,DATE_FORMAT(s.ScheduleFromDateTime,'%h:%i %p') ScheduleFrom ,DATE_FORMAT(s.ScheduleToDateTime,'%h:%i %p') ScheduleTo,s.Surgeon,s.Surgery FROM ot_schedule_requestdetails s WHERE s.IsActive=1 and   s.TransactionID='" + ViewState["TID"].ToString() + "'");
        if (dt.Rows.Count > 0)
        {
            ddlSurgery.SelectedIndex = ddlSurgery.Items.IndexOf(ddlSurgery.Items.FindByValue(dt.Rows[0]["Surgery"].ToString()));
            ddlSurgeon.SelectedIndex = ddlSurgeon.Items.IndexOf(ddlSurgeon.Items.FindByValue(dt.Rows[0]["Surgeon"].ToString()));

            var OtDatetimeText = "On " + dt.Rows[0]["ScheduleDate"].ToString() + " From " + dt.Rows[0]["ScheduleFrom"].ToString() + " To " + dt.Rows[0]["ScheduleTo"].ToString();

            if (dt.Rows[0]["IsReSchedule"].ToString() == "1")
            {
                txtOTTiming.Text = OtDatetimeText;
                txtScheduleFromTime.Text = dt.Rows[0]["ScheduleFrom"].ToString();
                txtScheduleToTime.Text = dt.Rows[0]["ScheduleTo"].ToString();
                txtScheduleDate.Text = dt.Rows[0]["ScheduleDate"].ToString();
                txtOTNumber.Text = dt.Rows[0]["OT"].ToString();
                lblStatus.Text = "Re-Schedule & Approved From " + OtDatetimeText.Replace("On", "");
                lblStatus.ForeColor = System.Drawing.Color.Orange;
                btnsave.Enabled = false;
                return;
            }

            if (dt.Rows[0]["IsApproved"].ToString() == "0")
            {
                lblStatus.Text = "Waiting For Approval  " + OtDatetimeText;
                lblStatus.ForeColor = System.Drawing.Color.Red;

            }


            if (dt.Rows[0]["IsRejected"].ToString() == "1")
            {
                lblStatus.Text = "Rejected For " + OtDatetimeText;
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;

            }

            if (dt.Rows[0]["IsExpired"].ToString() == "1")
            {
                lblStatus.Text = "Expired From " + OtDatetimeText;
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }


            if (dt.Rows[0]["IsApproved"].ToString() == "1")
            {
                lblStatus.Text = "Approved For " + OtDatetimeText;
                lblStatus.ForeColor = System.Drawing.Color.Green;
                btnsave.Enabled = false;
            }



            txtOTTiming.Text = OtDatetimeText;
            txtScheduleFromTime.Text = dt.Rows[0]["ScheduleFrom"].ToString();
            txtScheduleToTime.Text = dt.Rows[0]["ScheduleTo"].ToString();
            txtScheduleDate.Text = dt.Rows[0]["ScheduleDate"].ToString();
            txtOTNumber.Text = dt.Rows[0]["OT"].ToString();
        }
    }


    private void BindDoctor()
    {
        DataTable dtDoctor = StockReports.GetDataTable("select DoctorID, Name from doctor_master where isactive=1 order by Name");
        if (dtDoctor != null && dtDoctor.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dtDoctor;
            ddlDoctor.DataTextField = "Name";
            ddlDoctor.DataValueField = "DoctorID";
            ddlDoctor.DataBind();
            ddlDoctor.Items.Insert(0, new ListItem("Select", "0"));
        }

    }

    private void BindAssistantDoctor()
    {
        DataTable dtDoctor = StockReports.GetDataTable("select ID,Name from OT_AssistantDoctor order by Name");
        if (dtDoctor != null && dtDoctor.Rows.Count > 0)
        {
            ddlassistant.DataSource = dtDoctor;
            ddlassistant.DataTextField = "Name";
            ddlassistant.DataValueField = "ID";
            ddlassistant.DataBind();
            ddlassistant.Items.Insert(0, new ListItem("Select", "0"));
        }
    }


    private void BindSurgery()
    {
        string str = "select Surgery_ID, ltrim(Name) Name from f_surgery_master Where IsActive = 1 order by ltrim(Name)";
        DataTable dtSurgery = new DataTable();
        dtSurgery = StockReports.GetDataTable(str);
        if (dtSurgery.Rows.Count > 0)
        {
            ddlSurgery.DataSource = dtSurgery;
            ddlSurgery.DataTextField = "Name";
            ddlSurgery.DataValueField = "Surgery_ID";
            ddlSurgery.DataBind();
        }
        ddlSurgery.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string assistant = string.Empty;
            string str = string.Empty;
            string anaesthetist = ddlDoctor.SelectedItem.Value;
            int abc = ddlassistant.SelectedIndex;
            if (ddlassistant.SelectedIndex != -1)
            {
                assistant = ddlassistant.SelectedItem.Value;
            }
            str = "delete from ot_surgerydetail where TransactionID='" + ViewState["TID"].ToString() + "' and LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            str = "insert into ot_surgerydetail(PatientID,TransactionID,DoctorID,Surgery_ID,Is_Surgery_Schedule,Is_PAC,Is_Post,Case_Type,UserID,Anaesthetist,Assistant,Diagnosis,weight,LedgerTransactionNo)values('" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + "" + "','" + "" + "',0,0,0,'" + ViewState["status"] + "','" + Session["ID"].ToString() + "','" + anaesthetist + "','" + assistant + "','" + txtdiagnosis.Text + "','" + txtweight.Text + "','" + ViewState["LedgerTransactionNo"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            if (rbtlistpac.SelectedIndex == 1)
            {
                str = "update ot_surgerydetail set Is_PAC=2  where TransactionID='" + ViewState["TID"].ToString() + "' and LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            else if (rbtlistpac.SelectedIndex == 0)
            {
                str = "update ot_surgerydetail set Is_PAC=1  where TransactionID='" + ViewState["TID"].ToString() + "' and LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }

            str = "UPDATE ot_schedule_requestdetails  s SET  s.IsActive=0 WHERE s.TransactionID='" + ViewState["TID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            str = " INSERT INTO ot_schedule_requestdetails (TransactionID,ScheduleFromDateTime, ScheduleToDateTime, Surgery, Surgeon,OT ) VALUES ('" + ViewState["TID"].ToString() + "','" + Util.GetDateTime(txtScheduleDate.Text + " " + txtScheduleFromTime.Text).ToString("yyyy-MM-dd HH:mm:00") + "', '" + Util.GetDateTime(txtScheduleDate.Text + " " + txtScheduleToTime.Text).ToString("yyyy-MM-dd HH:mm:00") + "', '" + ddlSurgery.SelectedItem.Value + "', '" + ddlSurgeon.SelectedItem.Value + "'," + txtOTNumber.Text + ") ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);



            lblMsg.Text = "Record Saved Successfully";
            Tranx.Commit();
            bindSchudleDetails();
            //if (rbtlistpac.SelectedIndex != 1)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.parent.location.href='PRE/OT_MainForm.aspx?TID=" + Request.QueryString["TID"].ToString() + "&Status=" + Request.QueryString["Status"].ToString() + "&PID=" + Request.QueryString["PID"].ToString() + "&LoginType=" + Request.QueryString["LoginType"].ToString() + "&LedgerTransactionNo=" + Request.QueryString["LedgerTransactionNo"].ToString() + "';", true);
            //}
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
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

    private void binddata()
    {
        DataTable dt = StockReports.GetDataTable("select Surgery_ID,Is_Surgery_Schedule,Is_PAC,Is_Post,Case_Type,EntData,UserID,Anaesthetist,Assistant,Diagnosis,Weight,LedgerTransactionNo  from ot_surgerydetail where TransactionID='" + ViewState["TID"].ToString() + "' and LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "'");
        if (dt.Rows.Count > 0)
        {
            txtdiagnosis.Text = dt.Rows[0]["Diagnosis"].ToString();
            txtweight.Text = dt.Rows[0]["Weight"].ToString();
            ddlassistant.SelectedIndex = ddlassistant.Items.IndexOf(ddlassistant.Items.FindByValue(dt.Rows[0]["Assistant"].ToString()));
            if (dt.Rows[0]["Is_PAC"].ToString() == "2")
            {
                rbtlistpac.SelectedIndex = rbtlistpac.Items.IndexOf(rbtlistpac.Items.FindByText("PAC Not Required"));
            }
            else if (dt.Rows[0]["Is_PAC"].ToString() == "1")
            {
                rbtlistpac.SelectedIndex = rbtlistpac.Items.IndexOf(rbtlistpac.Items.FindByText("PAC Required"));
            }
            string doctorid = dt.Rows[0]["Anaesthetist"].ToString();
            int a = ddlDoctor.Items.Count;
            ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(dt.Rows[0]["Anaesthetist"].ToString()));
        }
        else
        {
        }
    }

    protected void btnAnaAss_Click(object sender, EventArgs e)
    {
        if (txtAss.Text != "")
        {
            int count = Util.GetInt(StockReports.ExecuteScalar(" select Count(*) from OT_AssistantDoctor where name ='" + txtAss.Text + "' "));
            if (count == 0)
            {
                string str = "insert into OT_AssistantDoctor (Name,UserID) values ('" + txtAss.Text + "','" + Session["ID"].ToString() + "')";
                StockReports.ExecuteDML(str);
                lblMsg.Text = "Record Saved Successfully";
                lblAssError.Text = "";
                txtAss.Text = "";
                BindAssistantDoctor();
            }
            else
            {
                lblAssError.Text = "Name Already Exist";
             //   mpNewAss.Show();
            }
        }
        else
        {
            lblAssError.Text = "Please Enter Assistant Name";
           // mpNewAss.Show();
        }
    }






}