using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class TreatmentDoctor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }
       
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["ID"] = Session["ID"].ToString();
            //string TID = Request.QueryString["TransactionID"].ToString();
            AllQuery AQ = new AllQuery();

            DataTable dt = AQ.GetPatientAdjustmentDetails(TID);
            
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                {
                    string Msg = "Patient's Bill has been freezed. No Doctor Shifting can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);
            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Doctor Shifting can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            // DataTable dt = AQ.GetPatientAdjustmentDetails(TID);

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    string Msg = "Patient's Final Bill has been Generated. No Doctor can be Sifted Now..";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }        
            BindPatientDetails(TID);
            binddoc();			
            ddlDoc.DataSource = null;
            ddlDoc.DataBind();
            BindDocDetails(TID);

        }
        ((TextBox)txtDate.FindControl("txtStartDate")).Attributes.Add("readOnly", "readOnly");
        ((AjaxControlToolkit.CalendarExtender)txtDate.FindControl("calStartDate")).EndDate = DateTime.Now;
    }
    public void binddoc()
    {
        string str = "Select CONCAT(Title,' ',Name)Name,DoctorID from doctor_master where IsActive = 1 and IsUnit=1   order by Name";
        DataTable dt=new DataTable();
        dt=StockReports.GetDataTable(str);
        ddlDoc.DataSource=dt;
        ddlDoc.DataTextField="Name";
        ddlDoc.DataValueField="DoctorID";
        ddlDoc.DataBind();
        ddlDoc.Items.Insert(0, "Select");
    }

    private void BindPatientDetails(string TransactionID)
    {
        string str = "SELECT pmh.PatientID,pmh.TransactionID,pmh.patient_type,date_format(pmh.DateOfAdmit,'%d-%b-%Y')as DateOfAdmit,DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID,pmh.ScheduleChargeID, " +
                      "(SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)CurrentDoctor" +
                     " FROM patient_medical_history pmh "+
                    " WHERE pmh.TransactionID='" + TransactionID + "'and pmh.Status='IN'";
                    DataTable dt=new DataTable();
         dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
            lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();
            
            lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
            ViewState["DoctorID"]=dt.Rows[0]["DoctorID"].ToString();
            
            //lblShiftDate.Text = dt.Rows[0]["StartDate"].ToString() + " " + dt.Rows[0]["StartTime"].ToString();
            ViewState["Patient_Type"] = dt.Rows[0]["patient_type"].ToString();


        }
    }


    protected void grdDocDetail_RowDataBound(object sender, GridViewRowEventArgs e)
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
    protected void btnShift_Click(object sender, EventArgs e)
    {        
        DateTime s = Util.GetDateTime(Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy"));
        if (Util.GetDateTime(Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy")).Date < Util.GetDateTime(ViewState["StartDate"]).Date)
        {
            lblmsg.Text = "Shifting date/time is less then Admit Date or Last Shifted Date";
            return;
        }

        bool IsSaved = true;

        IsSaved = SaveData();
       

    }
    private bool SaveData()
    {
        string TID = Request.QueryString["TransactionID"].ToString();
        string MaxID = StockReports.ExecuteScalar("Select id from f_doctotreatingteam where TransactionID='" + lblTransactionNo.Text + "' and Status='IN' ");

        if (ddlDoc.SelectedItem.Value == ViewState["DoctorID"].ToString())
        {
            lblmsg.Visible = true;
            lblmsg.Text = "Patient is already in same Team";
            return false;
        }
        /*if (ddlDoc.SelectedIndex == 0)
        {
            lblmsg.Visible = true;
            lblmsg.Text = "Select Team Doctor";
            return false;

        }
        if (ddlDoctorTeamList.SelectedIndex == 0)
        {
            lblmsg.Visible = true;
            lblmsg.Text = "Select First Call Doctor";
            return false;

        }*/
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (chkFirstCall.Checked)
            {
                string time = Util.GetDateTime(((TextBox)txtDate.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                string ShiftTime = Util.GetDateTime(time).ToString("HH:mm:ss");

                string ShiftDate = Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd");


                if (MaxID != "")
                {
                    string strUpd = "Update f_doctotreatingteam set ToDate='" + ShiftDate + "',ToTime='" + ShiftTime + "',Status='OUT' where ID=" + MaxID;
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strUpd);
                }

                string strIns = "Insert into f_doctotreatingteam (TransactionID,TeamDoctorID,FirstcallDoctorID,FromDate,FromTime,UserID,Status)values ('" + lblTransactionNo.Text + "','" + ddlDoc.SelectedItem.Value + "','" + ddlDoctorTeamList.SelectedItem.Value + "','" + ShiftDate + "','" + ShiftTime + "', '" + ViewState["ID"] + "','IN')";

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strIns);
            }

            else if (chkChangeTeam.Checked)
            {
                string TeamName = Util.GetString(StockReports.ExecuteScalar("SELECT ifnull(NAME,'')NAME from doctor_master dm where dm.doctorID='" + ddlDoc.SelectedItem.Value + "' "));
                string UpdateDoctor = "", InsertDoctor = "";
                int Count = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM `f_multipledoctor_ipd` mip INNER JOIN doctor_master dm ON dm.`DoctorID`=mip.`DoctorID` WHERE mip.`TransactionID`='" + lblTransactionNo.Text + "' AND dm.isunit=1 "));
                if (Count > 0)
                {
                    UpdateDoctor = " UPDATE `f_multipledoctor_ipd` mdp INNER JOIN `doctor_master` dm ON mdp.`DoctorID`=dm.`DoctorID`  SET mdp.`IsActive`=0 WHERE dm.`IsUnit`=1 AND mdp.`TransactionID`='" + lblTransactionNo.Text + "'; ";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, UpdateDoctor);
                }
                InsertDoctor = "INSERT INTO `f_multipledoctor_ipd`  (TransactionID,DoctorID,DoctorName,IsPrimary,IsActive,Updateby,UpdateDate)VALUES('" + lblTransactionNo.Text + "','" + ddlDoc.SelectedItem.Value + "','" + TeamName + "','1','1','" + Session["ID"].ToString() + "',NOW())";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, InsertDoctor);
                UpdateDoctor = " UPDATE patient_medical_history pmh SET pmh.`DoctorID1`='" + ddlDoc.SelectedValue + "' WHERE pmh.`TransactionID`='" + lblTransactionNo.Text + "'; ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, UpdateDoctor);
            }
            else { lblmsg.Text = "Please Check A Checkbox For Team Change Or First Call Change"; return false; }
           

            Tnx.Commit();
           

            BindDocDetails(TID);
            BindPatientDetails(TID);

            lblmsg.Text = "Change Team or First Call Successfully";

            return true;


        }
        catch (Exception ex)
        {
            Tnx.Rollback();
           

            lblmsg.Text = "Not Shifted";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }

       
    }
    public void BindDocDetails(string TransactionID) 
    {
        StringBuilder sb = new StringBuilder();
        string str1 = "Select min(ID) from f_doctotreatingteam where TransactionID = '" + TransactionID + "' ";
        string min = StockReports.ExecuteScalar(str1);
        if (min != "")
        {

            sb.Append("SELECT (SELECT CONCAT(Title,'',NAME)DoctorName FROM  doctor_master dm WHERE  dm.DoctorID=ds.TeamDoctorID )Team,(SELECT CONCAT(Title,'',NAME)DoctorName FROM employee_master dm WHERE dm.EmployeeID=ds.FirstcallDoctorID)FirstCall,CONCAT(DATE_FORMAT(ds.FromDate,'%d-%b-%Y'),' ',TIME_FORMAT(ds.FromTime,'%h:%i %p'))EntryDate,");
            sb.Append("CONCAT(DATE_FORMAT(ds.ToDate,'%d-%b-%Y'),' ',TIME_FORMAT(ds.ToTime,'%h:%i %p'))LeaveDate,em.Name,ds.Status ");
            sb.Append("FROM f_doctotreatingteam ds  ");
            sb.Append("LEFT JOIN employee_master em ON em.EmployeeID = ds.UserID ");
            sb.Append("WHERE TransactionID='" + TransactionID + "' ORDER BY ds.ID DESC");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdDocDetail.DataSource = dt;
                grdDocDetail.DataBind();
            }
            else
            {
                grdDocDetail.DataSource = null;
                grdDocDetail.DataBind();
            }
        }
    }
    //[WebMethod(EnableSession = true)]
    //public static string bindDoctorTeamList(string TeamID)
    //{
    //    DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.name)DoctorName FROM unit_doctorlist udl INNER JOIN doctor_master dm ON  udl.DoctorListId=dm.doctorID WHERE udl.UnitDoctorID=538 AND udl.IsActive=1");
    //    if (dt.Rows.Count > 0)
    //    {
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
    //    }
    //    else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    //}
    protected void ddlDoc_SelectedIndexChanged(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ud.DoctorListId DoctorID,ud.EmpName DoctorName  FROM unit_doctorlist  ud WHERE ud.UnitDoctorID='"+ddlDoc.SelectedValue+"'   AND ud.IsActive=1");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlDoctorTeamList.DataSource = dt;
            ddlDoctorTeamList.DataTextField = "DoctorName";
            ddlDoctorTeamList.DataValueField = "DoctorID";
            ddlDoctorTeamList.DataBind();
            ddlDoctorTeamList.Items.Insert(0, "Select");
        }

    }
}
