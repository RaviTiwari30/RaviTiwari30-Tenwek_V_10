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


public partial class Design_IPD_InPatientFallsAssessmentAndPrecautionTool : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtFPDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFPTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        CalendarExtender1.EndDate = DateTime.Now;
        txtAssessedBy.Text = entryby;
        txtCheckedBy.Text = entryby;
        txtTotal.Attributes.Add("readonly", "readonly");
        //txtTotal.Enabled = false;
        //txtAssessmentBy.Text = entryby;
    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
            if (((Label)e.Row.FindControl("lblCreatedID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
            }
        }
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./InPatientFallsAssessmentAndPrecautionTool_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
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
                txtFPDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFPDate")).Text;
                txtFPTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFPTime")).Text;
                txtMobility.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMobility")).Text;
                txtMentalState.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMentalState")).Text;
                txtToileting.Text = ((Label)grdPhysical.Rows[id].FindControl("lblToileting")).Text;
                txtPatientAge.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPatientAge")).Text;
                txtDiagnosis.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDiagnosis")).Text;
                txtGender.Text = ((Label)grdPhysical.Rows[id].FindControl("lblGender")).Text;
                txtMedication.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMedication")).Text;
               txtTotal.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTotal")).Text;
                txtTotalFallsRiskScore.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTotalFallsRiskScore")).Text;
                txtAssessedBy.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAssessmentBy")).Text;
                ddlSuperVision1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSuperVision1")).Text;
                ddlSuperVision2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSuperVision2")).Text;
                ddlSuperVision3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSuperVision3")).Text;
                ddlPatientRoom1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientRoom1")).Text;
                ddlPatientRoom2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientRoom2")).Text;
                ddlPatientRoom3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientRoom3")).Text;
                ddlPatientRoom4.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientRoom4")).Text;
                ddlPatientRoom5.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientRoom5")).Text;
                ddlPatientRoom6.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientRoom6")).Text;
                ddlHRPS1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHRPS1")).Text;
                ddlHRPS2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHRPS2")).Text;
                ddlHRPS3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblHRPS3")).Text;
                ddlPatientAndFamily1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientAndFamily1")).Text;
                ddlPatientAndFamily2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientAndFamily2")).Text;
                ddlPatientAndFamily3.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientAndFamily3")).Text;
                ddlPatientAndFamily4.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblPatientAndFamily4")).Text;
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,(Select concat(title,' ',name) from Employee_master where EmployeeID=AssessmentBy)AssessmentBy1,DATE_FORMAT(FPDate, '%d %b %Y') as FPDate1,TIME_FORMAT(FPTime, '%h:%i %p') as FPTime1,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff,IF( SuperVision1='1','Yes','No') SuperVision11," +
"  IF( SuperVision2='1','Yes','No') SuperVision21 , IF( SuperVision3='1','Yes','No') SuperVision31,  IF( PatientRoom1='1','Yes','No') PatientRoom11 ,  IF( PatientRoom2='1','Yes','No') PatientRoom21,  IF( PatientRoom3='1','Yes','No') PatientRoom31,  IF( PatientRoom4='1','Yes','No') PatientRoom41,  IF( PatientRoom5='1','Yes','No') PatientRoom51,  IF( PatientRoom6='1','Yes','No') PatientRoom61,  IF( HRPS1='1','Yes','No') HRPS11,  IF( HRPS2='1','Yes','No') HRPS21,  IF( HRPS3='1','Yes','No') HRPS31,  IF( PatientAndFamily1='1','Yes','No') PatientAndFamily11,  IF( PatientAndFamily2='1','Yes','No') PatientAndFamily21,  IF( PatientAndFamily3='1','Yes','No') PatientAndFamily31,  IF( PatientAndFamily4='1','Yes','No') PatientAndFamily41  from inpatientfallsassessmentandprecautiontool where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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
            string fpdate = Util.GetDateTime(txtFPDate.Text).ToString("yyyy-MM-dd");
            string fptime = Util.GetDateTime(txtFPTime.Text).ToString("HH:mm");
            
                var sqlCMD = "INSERT INTO `inpatientfallsassessmentandprecautiontool` ("+
  
 " `Date`,  `Time`,  `Mobility`,  `MentalState`,  `Toileting`,  `PatientAge`,  `Diagnosis`,  `Gender`,  `Medication`,  `Total`,  `TotalFallsRiskScore`,  `AssessmentBy`,  `FPDate`,"+
"  `FPTime`,  `SuperVision1`,  `SuperVision2`,  `SuperVision3`,  `PatientRoom1`,  `PatientRoom2`,  `PatientRoom3`,  `PatientRoom4`,  `PatientRoom5`,  `PatientRoom6`,  `HRPS1`,"+
"  `HRPS2`,  `HRPS3`,  `PatientAndFamily1`,  `PatientAndFamily2`,  `PatientAndFamily3`,  `PatientAndFamily4`,  `CheckedBy`,  `CreatedBy`,  `CreatedDate`,  `PatientID`,  `TransactionID`)" +
" VALUES  (        @Date,    @Time,    @Mobility,    @MentalState,    @Toileting,    @PatientAge,    @Diagnosis,    @Gender,    @Medication,    @Total,    @TotalFallsRiskScore,"+
"    @AssessmentBy,    @FPDate,    @FPTime,    @SuperVision1,    @SuperVision2,    @SuperVision3,    @PatientRoom1,    @PatientRoom2,    @PatientRoom3,    @PatientRoom4,    @PatientRoom5,"+
"@PatientRoom6,    @HRPS1,    @HRPS2,    @HRPS3,    @PatientAndFamily1,    @PatientAndFamily2,    @PatientAndFamily3,@PatientAndFamily4,    @CheckedBy,    @CreatedBy,    Now(),    @PatientID,    @TransactionID  );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Mobility = txtMobility.Text,
                    MentalState = txtMentalState.Text,
                    Toileting = txtToileting.Text,
                    PatientAge = txtPatientAge.Text,
                    Diagnosis = txtDiagnosis.Text,
                    Gender = txtGender.Text,
                    Medication = txtMedication.Text,
                    Total = txtTotal.Text,
                    TotalFallsRiskScore = txtTotalFallsRiskScore.Text,
                    AssessmentBy = HttpContext.Current.Session["ID"].ToString(),
                    FPDate = fpdate,
                    FPTime = fptime,
                    SuperVision1 = ddlSuperVision1.SelectedValue,
                    SuperVision2 = ddlSuperVision2.SelectedValue,
                    SuperVision3 = ddlSuperVision3.SelectedValue,
                    PatientRoom1 = ddlPatientRoom1.SelectedValue,
                    PatientRoom2 = ddlPatientRoom2.SelectedValue,
                    PatientRoom3 = ddlPatientRoom3.SelectedValue,
                    PatientRoom4 = ddlPatientRoom4.SelectedValue,
                    PatientRoom5 = ddlPatientRoom5.SelectedValue,
                    PatientRoom6 = ddlPatientRoom6.SelectedValue,
                    HRPS1 = ddlHRPS1.SelectedValue,
                    HRPS2 = ddlHRPS2.SelectedValue,
                    HRPS3 = ddlHRPS3.SelectedValue,
                    PatientAndFamily1 = ddlPatientAndFamily1.Text,
                    PatientAndFamily2 = ddlPatientAndFamily2.Text,
                    PatientAndFamily3 = ddlPatientAndFamily3.Text,
                    PatientAndFamily4 = ddlPatientAndFamily4.Text,
                    CheckedBy = HttpContext.Current.Session["ID"].ToString(),
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
                    txtFPDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtFPTime.Text = DateTime.Now.ToString("hh:mm tt");
                    txtMobility.Text = "";
                    txtMentalState.Text = "";
                    txtToileting.Text = "";
                    txtPatientAge.Text = "";
                    txtDiagnosis.Text = "";
                    txtGender.Text = "";
                    txtMedication.Text = "";
                    txtTotal.Text = "";
                    txtTotalFallsRiskScore.Text = "";
                    txtAssessedBy.Text = "";
                    ddlSuperVision1.SelectedValue = "0";
                    ddlSuperVision2.SelectedValue = "0";
                    ddlSuperVision3.SelectedValue = "0";
                    ddlPatientRoom1.SelectedValue = "0";
                    ddlPatientRoom2.SelectedValue = "0";
                    ddlPatientRoom3.SelectedValue = "0";
                    ddlPatientRoom4.SelectedValue = "0";
                    ddlPatientRoom5.SelectedValue = "0";
                    ddlPatientRoom6.SelectedValue = "0";
                    ddlHRPS1.SelectedValue = "0";
                    ddlHRPS2.SelectedValue = "0";
                    ddlHRPS3.SelectedValue = "0";
                    ddlPatientAndFamily1.SelectedValue = "0";
                    ddlPatientAndFamily2.SelectedValue = "0";
                    ddlPatientAndFamily3.SelectedValue = "0";
                    ddlPatientAndFamily4.SelectedValue = "0";
                
        //txtCheckedBy.Text = HttpContext.Current.Session["ID"].ToString();
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
            string fpdate = Util.GetDateTime(txtFPDate.Text).ToString("yyyy-MM-dd");
            string fptime = Util.GetDateTime(txtFPTime.Text).ToString("HH:mm");

            var sqlCMD = "UPDATE inpatientfallsassessmentandprecautiontool SET UpdateDate=NOW(),UpdatedBy=@UpdatedBy,Mobility=@Mobility," +
                "MentalState=@MentalState,Toileting=@Toileting,PatientAge=@PatientAge,Diagnosis=@Diagnosis," +
                "Gender=@Gender,Medication=@Medication,Total=@Total,TotalFallsRiskScore=@TotalFallsRiskScore," +
                "FPDate=@FPDate,FPTime=@FPTime,SuperVision1=@SuperVision1,SuperVision2=@SuperVision2,SuperVision3=@SuperVision3,PatientRoom1=@PatientRoom1,PatientRoom2=@PatientRoom2,PatientRoom3=@PatientRoom3,PatientRoom4=@PatientRoom4,PatientRoom5=@PatientRoom5,PatientRoom6=@PatientRoom6," +
                "HRPS1=@HRPS1,HRPS2=@HRPS2,HRPS3=@HRPS3,PatientAndFamily1=@PatientAndFamily1,PatientAndFamily2=@PatientAndFamily2,PatientAndFamily3=@PatientAndFamily3,PatientAndFamily4=@PatientAndFamily4" +
                " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    
                    Mobility = txtMobility.Text,
                    MentalState = txtMentalState.Text,
                    Toileting = txtToileting.Text,
                    PatientAge = txtPatientAge.Text,
                    Diagnosis = txtDiagnosis.Text,
                    Gender = txtGender.Text,
                    Medication = txtMedication.Text,
                    Total = txtTotal.Text,
                    TotalFallsRiskScore = txtTotalFallsRiskScore.Text,
                    //AssessmentBy = HttpContext.Current.Session["ID"].ToString(),
                    FPDate = fpdate,
                    FPTime = fptime,
                    SuperVision1 = ddlSuperVision1.SelectedValue,
                    SuperVision2 = ddlSuperVision2.SelectedValue,
                    SuperVision3 = ddlSuperVision3.SelectedValue,
                    PatientRoom1 = ddlPatientRoom1.SelectedValue,
                    PatientRoom2 = ddlPatientRoom2.SelectedValue,
                    PatientRoom3 = ddlPatientRoom3.SelectedValue,
                    PatientRoom4 = ddlPatientRoom4.SelectedValue,
                    PatientRoom5 = ddlPatientRoom5.SelectedValue,
                    PatientRoom6 = ddlPatientRoom6.SelectedValue,
                    HRPS1 = ddlHRPS1.SelectedValue,
                    HRPS2 = ddlHRPS2.SelectedValue,
                    HRPS3 = ddlHRPS3.SelectedValue,
                    PatientAndFamily1 = ddlPatientAndFamily1.Text,
                    PatientAndFamily2 = ddlPatientAndFamily2.Text,
                    PatientAndFamily3 = ddlPatientAndFamily3.Text,
                    PatientAndFamily4 = ddlPatientAndFamily4.Text,
                    CheckedBy = HttpContext.Current.Session["ID"].ToString(),
                    ID=Util.GetString(lblID.Text)
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