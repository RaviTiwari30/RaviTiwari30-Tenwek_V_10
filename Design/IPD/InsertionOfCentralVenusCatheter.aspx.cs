
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;

using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;


public partial class Design_IPD_InsertionOfCentralVenusCatheter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtStartDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtStartTime.Text = DateTime.Now.ToString("hh:mm tt");

            //txtEndDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txtEndTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        CalendarExtender1.EndDate = DateTime.Now;
        CalendarExtender2.EndDate = DateTime.Now;
        //txtTotal.Enabled = false;
        //txtCreatedBy.Text = entryby;

        //txtCreatedBy.Enabled = false;
    }
    
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
                  }
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./InsertionOfCentralVenusCatheter_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            decimal createdDateDiff = Util.GetDecimal(((Label)grdPhysical.Rows[id].FindControl("lblTimeDiff")).Text);
            if (((Label)grdPhysical.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text;
                txtStartDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblStartDate")).Text;
                txtStartTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblStartTime")).Text;
                txtEndDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEndDate")).Text;
                txtEndTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEndTime")).Text;
                txtPostInsertion.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPostInsertion")).Text;
                txtTypeOfCatheter.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTypeOfCatheter")).Text;
                txtCatheterSite.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCatheterSite")).Text;
                txtProceduralist.Text = ((Label)grdPhysical.Rows[id].FindControl("lblProceduralist")).Text;
               txtProcedureAssistant.Text = ((Label)grdPhysical.Rows[id].FindControl("lblProcedureAssistant")).Text;
                ddlVerification1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification1")).Text;
                ddlVerification2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification2")).Text;
                ddlVerification3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification3")).Text;
                ddlVerification4.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification4")).Text;
                ddlVerification5.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification5")).Text;
                ddlVerification6.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification6")).Text;
                ddlVerification7.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification7")).Text;
                ddlVerification8.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification8")).Text;
                ddlVerification9.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerification9")).Text;
                ddlProcedure1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure1")).Text;
                ddlProcedure2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure2")).Text;
                ddlProcedure3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure3")).Text;
                //ddlProcedure4.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure4")).Text;
                ddlProcedure5.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure5")).Text;
                ddlProcedure6.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure6")).Text;
                ddlProcedure7.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure7")).Text;
                ddlProcedure8.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure8")).Text;
                ddlProcedure9.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure9")).Text;
                ddlProcedure10.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure10")).Text;
                ddlProcedure11.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure11")).Text;
                ddlProcedure12.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure12")).Text;
                ddlPostProcedure1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPostProcedure1")).Text;
                ddlPostProcedure2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPostProcedure2")).Text;
                ddlPostProcedure3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPostProcedure3")).Text;
                ddlPostProcedure4.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPostProcedure4")).Text;
                txtExplain1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblExplain1")).Text;
                txtExplain2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblExplain2")).Text;
                txtStartTime.Enabled = false;
                txtStartDate.Enabled = false;
                //txtPostInsertion.Enabled = false;
                //txtTypeOfCatheter.Enabled = false;
                //txtCatheterSite.Enabled = false;
                //txtProceduralist.Enabled = false;
                //txtProcedureAssistant.Enabled = false;
                //ddlVerification1.Enabled = false;
                //ddlVerification2.Enabled = false;
                //ddlVerification3.Enabled = false;
                //ddlVerification4.Enabled = false;
                //ddlVerification5.Enabled = false;
                //ddlVerification6.Enabled = false;
                //ddlVerification7.Enabled = false;
                //ddlVerification8.Enabled = false;
                //ddlVerification9.Enabled = false;
                //ddlProcedure1.Enabled = false;
                //ddlProcedure2.Enabled = false;
                //ddlProcedure3.Enabled = false;
                ////ddlProcedure4.Enabled = false;
                //ddlProcedure5.Enabled = false;
                //ddlProcedure6.Enabled = false;
                //ddlProcedure7.Enabled = false;
                //ddlProcedure8.Enabled = false;
                //ddlProcedure9.Enabled = false;
                //ddlProcedure10.Enabled = false;
                //ddlProcedure11.Enabled = false;
                //ddlProcedure12.Enabled = false;
                //ddlPostProcedure1.Enabled = false;
                //ddlPostProcedure2.Enabled = false;
                //ddlPostProcedure3.Enabled = false;
                //ddlPostProcedure4.Enabled = false;
                //txtExplain1.Enabled = false;
                //txtExplain2.Enabled = false;
                //txtAllergies.Enabled = false;
                //txtSaftyExplaination.Enabled = false;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
            }
            else
            {
                ((ImageButton)grdPhysical.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                lblMsg.Text = "You are not able to Edit this Detail after 12 hrs";
            }

        }
        
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindData(string PID, string TID)
    {
        string retn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select *,DATE_FORMAT(FPDate, '%d %b %Y') as Date1,TIME_FORMAT(FPTime, '%h:%i %p') as FPTime1,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) Enabled from inpatientfallsassessmentandprecautiontool,IF( SuperVision1='1','Yes','No') SuperVision11," +
"  IF( SuperVision2='1','Yes','No') SuperVision21 , IF( SuperVision3='1','Yes','No') SuperVision31,  IF( PatientRoom1='1','Yes','No') PatientRoom11 ,  IF( PatientRoom2='1','Yes','No') PatientRoom21,  IF( PatientRoom3='1','Yes','No') PatientRoom31,  IF( PatientRoom4='1','Yes','No') PatientRoom41,  IF( PatientRoom5='1','Yes','No') PatientRoom51,  IF( PatientRoom6='1','Yes','No') PatientRoom61,  IF( HRPS1='1','Yes','No') HRPS11,  IF( HRPS2='1','Yes','No') HRPS21,  IF( HRPS3='1','Yes','No') HRPS31,  IF( PatientAndFamily1='1','Yes','No') PatientAndFamily11,  IF( PatientAndFamily2='1','Yes','No') PatientAndFamily21,  IF( PatientAndFamily3='1','Yes','No') PatientAndFamily31, where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc limit 1");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retn;
        }
        else
        {
            return retn;
        }
    }
    public void BindDetails(string PID,string TID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=us.CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,DATE_FORMAT(StartDate, '%d %b %Y') as StartDate1,DATE_FORMAT(EndDate, '%d %b %Y') as EndDate1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIME_FORMAT(EndTime, '%h:%i %p') as EndTime1,TIME_FORMAT(StartTime, '%h:%i %p') as StartTime1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff,TIMESTAMPDIFF(MINUTE,CONCAT(StartDate,' ',StartTime),CONCAT(EndDate,' ',EndTime)) Minutes  from insertionofcentralvenuscatheter us where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPhysical.DataSource = dt;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }



    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            string startdate = Util.GetDateTime(txtStartDate.Text).ToString("yyyy-MM-dd");
            
            string starttime = Util.GetDateTime(txtStartTime.Text).ToString("HH:mm");
            string enddate = null;
            if (txtEndDate.Text != "")
            {
                enddate = Util.GetDateTime(txtEndDate.Text).ToString("yyyy-MM-dd");
            }
            string endtime = null;
            if (txtEndTime.Text != "")
            {
                endtime = Util.GetDateTime(txtEndTime.Text).ToString("HH:mm");
            }
            var sqlCMD = "INSERT INTO `insertionofcentralvenuscatheter` ("+

"  `Date`,  `Time`, `StartDate`, `StartTime`,`EndDate` , `EndTime`,  `PostInsertion`,  `TypeOfCatheter`,  `CatheterSite`,  `Proceduralist`,  `ProcedureAssistant`,  `Verification1`,  `Verification2`," +
"  `Verification3`,  `Verification4`,  `Verification5`,  `Verification6`,  `Verification7`,  `Verification8`,  `Verification9`,  `Procedure1`,  `Procedure2`,  `Procedure3`,"+
"  `Procedure4`,  `Procedure5`,  `Procedure6`,  `Procedure7`,  `Procedure8`,  `Procedure9`,  `Procedure10`,  `Procedure11`,  `Procedure12`,  `Explain1`,  `PostProcedure1`,"+
"  `PostProcedure2`,  `PostProcedure3`,  `PostProcedure4`,  `Explain2`,  `CreatedBy`,  `CreatedDate`,  `PatientID`,  `TransactionID`)"+
" VALUES  (        @Date,    @Time, @StartDate,   @StartTime, @EndDate,   @EndTime,    @PostInsertion,    @TypeOfCatheter,    @CatheterSite,    @Proceduralist,    @ProcedureAssistant,    @Verification1,"+
"    @Verification2,    @Verification3,    @Verification4,    @Verification5,    @Verification6,    @Verification7,    @Verification8,    @Verification9,    @Procedure1,    @Procedure2,"+
"@Procedure3,   '',    @Procedure5,    @Procedure6,    @Procedure7,    @Procedure8,    @Procedure9,    @Procedure10,    @Procedure11,    @Procedure12,    @Explain1,"+
"@PostProcedure1,    @PostProcedure2,    @PostProcedure3,    @PostProcedure4,    @Explain2,    @CreatedBy,    NOW(),    @PatientID,    @TransactionID  );";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    StartDate=startdate,
                    StartTime = starttime,
                    EndDate = enddate,
                    EndTime = endtime,
                    PostInsertion = txtPostInsertion.Text,
                    TypeOfCatheter = txtTypeOfCatheter.Text,
                    CatheterSite = txtCatheterSite.Text,
                    Proceduralist = txtProceduralist.Text,
                    ProcedureAssistant = txtProcedureAssistant.Text,
                    Verification1 = ddlVerification1.SelectedValue,
                    Verification2 = ddlVerification2.SelectedValue,
                    Verification3 = ddlVerification3.SelectedValue,
                    Verification4 = ddlVerification4.SelectedValue,
                    Verification5 = ddlVerification5.SelectedValue,
                    Verification6 = ddlVerification6.SelectedValue,
                    Verification7 = ddlVerification7.SelectedValue,
                    Verification8 = ddlVerification8.SelectedValue,
                    Verification9 = ddlVerification9.SelectedValue,
                    Procedure1 = ddlProcedure1.SelectedValue,
                    Procedure2 = ddlProcedure2.SelectedValue,
                    Procedure3 = ddlProcedure3.SelectedValue,
                    //Procedure4 = ddlProcedure4.SelectedValue,
                    Procedure5 = ddlProcedure5.SelectedValue,
                    Procedure6 = ddlProcedure6.SelectedValue,
                    Procedure7 = ddlProcedure7.SelectedValue,
                    Procedure8 = ddlProcedure8.SelectedValue,
                    Procedure9 = ddlProcedure9.SelectedValue,
                    Procedure10 = ddlProcedure10.SelectedValue,
                    Procedure11 = ddlProcedure11.SelectedValue,
                    Procedure12 = ddlProcedure12.SelectedValue,
                    PostProcedure1 = ddlPostProcedure1.SelectedValue,
                    PostProcedure2 = ddlPostProcedure2.SelectedValue,
                    PostProcedure3 = ddlPostProcedure3.SelectedValue,
                    PostProcedure4 = ddlPostProcedure4.SelectedValue,
                    Explain1 = txtExplain1.Text,
                    Explain2 = txtExplain2.Text,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    PatientID = ViewState["PID"].ToString(),
                    TransactionID = ViewState["TID"].ToString()
                });
            message = "Record Save Sucessfully";
            Clear();

            tnx.Commit();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " modelAlert('"+message+"',function(){});", true);

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact Administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    private void Clear()
    {

                    txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                    txtStartTime.Text = DateTime.Now.ToString("hh:mm tt");
                    txtPostInsertion.Text = "";
                    txtTypeOfCatheter.Text = "";
                    txtCatheterSite.Text = "";
                    txtProceduralist.Text = "";
                    txtProcedureAssistant.Text = "";
                    ddlVerification1.SelectedIndex = -1;
                    ddlVerification2.SelectedIndex = -1;
                    ddlVerification3.SelectedIndex = -1;
                    ddlVerification4.SelectedIndex = -1;
                    ddlVerification5.SelectedIndex = -1;
                    ddlVerification6.SelectedIndex = -1;
                    ddlVerification7.SelectedIndex = -1;
                    ddlVerification8.SelectedIndex = -1;
                    ddlVerification9.SelectedIndex = -1;
                    ddlProcedure1.SelectedIndex = -1;
                    ddlProcedure2.SelectedIndex = -1;
                    ddlProcedure3.SelectedIndex = -1;
                    //ddlProcedure4.SelectedIndex = -1;
                    ddlProcedure5.SelectedIndex = -1;
                    ddlProcedure6.SelectedIndex = -1;
                    ddlProcedure7.SelectedIndex = -1;
                    ddlProcedure8.SelectedIndex = -1;
                    ddlProcedure9.SelectedIndex = -1;
                    ddlProcedure10.SelectedIndex = -1;
                    ddlProcedure11.SelectedIndex = -1;
                    ddlProcedure12.SelectedIndex = -1;
                    ddlPostProcedure1.SelectedIndex = -1;
                    ddlPostProcedure2.SelectedIndex = -1;
                    ddlPostProcedure3.SelectedIndex = -1;
                    ddlPostProcedure4.SelectedIndex = -1;
                    txtExplain1.Text = "";
                    txtExplain2.Text = "";
                    txtAllergies.Text = "";
                    txtSaftyExplaination.Text = "";        //txtCheckedBy.Text = HttpContext.Current.Session["ID"].ToString();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";

            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            string startdate = Util.GetDateTime(txtStartDate.Text).ToString("yyyy-MM-dd");

            string starttime = Util.GetDateTime(txtStartTime.Text).ToString("HH:mm");
            string enddate = null;
            if (txtEndDate.Text != "")
            {
                enddate = Util.GetDateTime(txtEndDate.Text).ToString("yyyy-MM-dd");
            }
            string endtime = null;
            if (txtEndTime.Text != "")
            {
                endtime = Util.GetDateTime(txtEndTime.Text).ToString("HH:mm");
            }
            var sqlCMD = "UPDATE insertionofcentralvenuscatheter SET UpdateDate=NOW(),UpdatedBy=@UpdatedBy," +
                "EndDate=@EndDate,EndTime=@EndTime,TypeOfCatheter=@TypeOfCatheter,CatheterSite=@CatheterSite,Proceduralist=@Proceduralist,ProcedureAssistant=@ProcedureAssistant," +
                "Verification1=@Verification1,Verification2=@Verification2,Verification3=@Verification3,Verification4=@Verification4,Verification5=@Verification5," +
                "Verification6=@Verification6,Verification7=@Verification7,Verification8=@Verification8,Verification9=@Verification9,Procedure1=@Procedure1," +
                "Procedure2=@Procedure2,Procedure3=@Procedure3,Procedure5=@Procedure5,Procedure6=@Procedure6,Procedure7=@Procedure7," +
                "Procedure8=@Procedure8,Procedure9=@Procedure9,Procedure10=@Procedure10,Procedure11=@Procedure11,Procedure12=@Procedure12,PostProcedure1=@PostProcedure1," +
                "PostProcedure2=@PostProcedure2,PostProcedure3=@PostProcedure3,PostProcedure4=@PostProcedure4,Explain1=@Explain1,Explain2=@Explain2" +
                " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    EndDate = enddate,
                    EndTime = endtime,
                    PostInsertion = txtPostInsertion.Text,
                    TypeOfCatheter = txtTypeOfCatheter.Text,
                    CatheterSite = txtCatheterSite.Text,
                    Proceduralist = txtProceduralist.Text,
                    ProcedureAssistant = txtProcedureAssistant.Text,
                    Verification1 = ddlVerification1.SelectedValue,
                    Verification2 = ddlVerification2.SelectedValue,
                    Verification3 = ddlVerification3.SelectedValue,
                    Verification4 = ddlVerification4.SelectedValue,
                    Verification5 = ddlVerification5.SelectedValue,
                    Verification6 = ddlVerification6.SelectedValue,
                    Verification7 = ddlVerification7.SelectedValue,
                    Verification8 = ddlVerification8.SelectedValue,
                    Verification9 = ddlVerification9.SelectedValue,
                    Procedure1 = ddlProcedure1.SelectedValue,
                    Procedure2 = ddlProcedure2.SelectedValue,
                    Procedure3 = ddlProcedure3.SelectedValue,
                    //Procedure4 = ddlProcedure4.SelectedValue,
                    Procedure5 = ddlProcedure5.SelectedValue,
                    Procedure6 = ddlProcedure6.SelectedValue,
                    Procedure7 = ddlProcedure7.SelectedValue,
                    Procedure8 = ddlProcedure8.SelectedValue,
                    Procedure9 = ddlProcedure9.SelectedValue,
                    Procedure10 = ddlProcedure10.SelectedValue,
                    Procedure11 = ddlProcedure11.SelectedValue,
                    Procedure12 = ddlProcedure12.SelectedValue,
                    PostProcedure1 = ddlPostProcedure1.SelectedValue,
                    PostProcedure2 = ddlPostProcedure2.SelectedValue,
                    PostProcedure3 = ddlPostProcedure3.SelectedValue,
                    PostProcedure4 = ddlPostProcedure4.SelectedValue,
                    Explain1 = txtExplain1.Text,
                    Explain2 = txtExplain2.Text,
                    ID = Util.GetString(lblID.Text)
                     });
                message = "Record Update Successfully";
                Clear();
                btnUpdate.Visible = false;
                btnSave.Visible = true;    
                tnx.Commit();

                BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact Administrator";
           }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
    }
}