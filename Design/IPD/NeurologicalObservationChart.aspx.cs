
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


public partial class Design_IPD_NeurologicalObservationChart : System.Web.UI.Page
{
    protected void Radio1_Changed(object sender, EventArgs e)
    {
        if (rdbEyeOpening.SelectedIndex >= 0)
        {
            lblEyeOpening1.Text = rdbEyeOpening.SelectedItem.Value;
            CalcScore();
        }
    }
    protected void Radio2_Changed(object sender, EventArgs e)
    {

        if (rdbVerbalAdult.SelectedIndex >= 0)
        {
            lblVerbalAdult1.Text = rdbVerbalAdult.SelectedItem.Value;
            CalcScore();
        }
    }
    protected void Radio3_Changed(object sender, EventArgs e)
    {

        if (rdbBestMotorResponse.SelectedIndex >= 0)
        {
            lblBestMotorResponse1.Text = rdbBestMotorResponse.SelectedItem.Value;
            CalcScore();
        }
    }
    private void CalcScore()
    {
        int total = 0;
        if (rdbEyeOpening.SelectedIndex >= 0)
        {
            total+=Int32.Parse( rdbEyeOpening.SelectedItem.Value);
        }
        if (rdbVerbalAdult.SelectedIndex >= 0)
        {
            total += Int32.Parse(rdbVerbalAdult.SelectedItem.Value);
        }
        if (rdbBestMotorResponse.SelectedIndex >= 0)
        {
            total += Int32.Parse(rdbBestMotorResponse.SelectedItem.Value);
        }
        lblGlascowComaScaleScore1.Text = total.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        
        //txtPersonInserting.Text = entryby;
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./NeurologicalObservationChart_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
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
                if (((Label)grdPhysical.Rows[id].FindControl("lblEyeOpening")).Text != "")
                {
                    rdbEyeOpening.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblEyeOpening")).Text;
                }
                if (((Label)grdPhysical.Rows[id].FindControl("lblVerbalAdult")).Text != "")
                {
                    rdbVerbalAdult.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVerbalAdult")).Text;
                }
                if (((Label)grdPhysical.Rows[id].FindControl("lblBestMotorResponse")).Text != "")
                {
                    rdbBestMotorResponse.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblBestMotorResponse")).Text;
                }
                
                    lblEyeOpening1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEyeOpening")).Text;
                
                lblVerbalAdult1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVerbalAdult")).Text;
                lblBestMotorResponse1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBestMotorResponse")).Text;
                int total = Int32.Parse(lblEyeOpening1.Text) + Int32.Parse(lblVerbalAdult1.Text) + Int32.Parse(lblBestMotorResponse1.Text);
                txtGlascowComaScaleScore.Text = ((Label)grdPhysical.Rows[id].FindControl("lblGlascow")).Text;
                lblGlascowComaScaleScore1.Text = total.ToString();
                txtRisk.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRisk")).Text;
                txtSluggish.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSluggish")).Text;
                txtNoReaction.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNoReaction")).Text;
                txtEyesClosed.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEyesClosed")).Text;
                txtArmsNormalPower1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEyesClosed")).Text;
                txtArmsNormalPower1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblANormalPower1")).Text;
                txtArmsNormalPower2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblANormalPower2")).Text;
                txtArmsSevereWeakness1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblASevereWeakness1")).Text;
                txtArmsSevereWeakness2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblASevereWeakness2")).Text;
                txtArmsSpasticFlexion1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblASpasticFlexion1")).Text;
                txtArmsSpasticFlexion2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblASpasticFlexion2")).Text;
                txtArmsExtension1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAExtension1")).Text;
                txtArmsExtension2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAExtension2")).Text;
                txtArmsNoResponse1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblANoResponse1")).Text;
                txtArmsNoResponse2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblANoResponse2")).Text;
                txtLegsNormalPower1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLNormalPower1")).Text;
                txtLegsNormalPower2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLNormalPower2")).Text;
                txtLegsMildWeakness1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLMildWeakness1")).Text;
                txtLegsMildWeakness2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLMildWeakness2")).Text;
                txtLegsSpasticFlexion1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLSpasticFlexion1")).Text;
                txtLegsSpasticFlexion2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLSpasticFlexion2")).Text;
                txtLegsExtension1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLExtension1")).Text;
                txtLegsExtension2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLExtension2")).Text;
                txtLegsNoResponse1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLNoResponse1")).Text;
                txtLegsNoResponse2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLNoResponse2")).Text;
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
        sb.Append("Select *,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) Enabled from painmanagementtoolneonatal where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc limit 1");
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff from neurologicalobservationchart where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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


    [WebMethod(EnableSession = true)]

    public static string SaveData(string TransactionID, string PatientID, string Date, string Time, string InsertedBy, string Location, string LeftCatheterGauge, string Reason, string CleanedWith, string InsertionEase, string ComplianceLevel, string Appearence, string FlushedWith, string CheckedBy, string SaveType, string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(Date).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(Time).ToString("HH:mm");
            if (SaveType == "Save")
            {

                var sqlCMD = "INSERT INTO `peripheralvenouscatheterinsertionchecklist` ( CreatedBy,CreatedDate, `Date`,  `Time`,  `InsertedBy`,  `Location`,  `LeftCatheterGauge`,  `Reason`,  `CatheterSiteCleanedWith`,  `InsertionEase`,  `ComplianceLevel`,  `Appearence`,  `FlushedWith`,  `CheckedBy`,PatientID,TransactionID) " +
" VALUES  (     @CreatedBy,NOW(),    @Date,   @Time,    @InsertedBy,    @Location,    @LeftCatheterGauge,    @Reason,    @CatheterSiteCleanedWith,    @InsertionEase,    @ComplianceLevel,    @Appearence,    @FlushedWith,    @CheckedBy ,@PatientID,@TransactionID );";       
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    InsertedBy = InsertedBy,
                    Location = Location,
                    LeftCatheterGauge = LeftCatheterGauge,
                    Reason=Reason,
                    CatheterSiteCleanedWith = CleanedWith,
                    InsertionEase = InsertionEase,
                    ComplianceLevel=ComplianceLevel,
                    Appearence=Appearence,
                    FlushedWith=FlushedWith,
                    CheckedBy = HttpContext.Current.Session["ID"].ToString(),
                    PatientID=PatientID,
                    TransactionID=TransactionID
                });
                message = "Record Save Sucessfully";
            }
            else
            {
                var sqlCMD = "UPDATE peripheralvenouscatheterinsertionchecklist SET Date=@Date,Time=@Time,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy,Location=@Location,LeftCatheterGauge=@LeftCatheterGauge,Reason=@Reason,CatheterSiteCleanedWith=@CatheterSiteCleanedWith,InsertionEase=@InsertionEase,ComplianceLevel=@ComplianceLevel,Appearence=@Appearence,FlushedWith=@FlushedWith,CheckedBy=@CheckedBy WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                   UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    InsertedBy = InsertedBy,
                    Location = Location,
                    LeftCatheterGauge = LeftCatheterGauge,
                    Reason=Reason,
                    CatheterSiteCleanedWith = CleanedWith,
                    InsertionEase = InsertionEase,
                    ComplianceLevel=ComplianceLevel,
                    Appearence=Appearence,
                    FlushedWith=FlushedWith,
                    CheckedBy=CheckedBy,
                   //ID = Util.GetInt(lblID.Text)
                    

                });
                message = "Record Update Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
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
            
                var sqlCMD = "INSERT INTO `neurologicalobservationchart` (  `Date`,  `Time`,  `EyeOpening`,  `VerbalAdult`,  `BestMotorResponse`,  `Glascow`,  `Risk`,  `Sluggish`,"+
"  `NoReaction`,  `EyesClosed`,  `ANormalPower1`,  `ANormalPower2`,  `ASevereWeakness1`,  `ASevereWeakness2`,  `ASpasticFlexion1`,  `ASpasticFlexion2`,  `AExtension1`,  `AExtension2`,"+
"  `ANoResponse1`,  `ANoResponse2`,  `LNormalPower1`,  `LNormalPower2`,  `LMildWeakness1`,  `LMildWeakness2`,  `LSpasticFlexion1`,  `LSpasticFlexion2`,  `LExtension1`,  `LExtension2`,"+
"  `LNoResponse1`,  `LNoResponse2`,  `CreatedBy`,  `CreatedDate`,  `PatientID`,  `TransactionID`)"+
" VALUES  (        @Date,    @Time,    @EyeOpening,    @VerbalAdult,    @BestMotorResponse,    @Glascow,    @Risk,    @Sluggish,    @NoReaction,    @EyesClosed,    @ANormalPower1,"+
"    @ANormalPower2,    @ASevereWeakness1,    @ASevereWeakness2,    @ASpasticFlexion1,    @ASpasticFlexion2,    @AExtension1,    @AExtension2,    @ANoResponse1,    @ANoResponse2,"+
"    @LNormalPower1,    @LNormalPower2,    @LMildWeakness1,    @LMildWeakness2,    @LSpasticFlexion1,    @LSpasticFlexion2,    @LExtension1,    @LExtension2,    @LNoResponse1,"+
"    @LNoResponse2,    @CreatedBy,    NOW(),    @PatientID,    @TransactionID  );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    EyeOpening = rdbEyeOpening.SelectedValue,
                    VerbalAdult = rdbVerbalAdult.SelectedValue,
                    BestMotorResponse = rdbBestMotorResponse.SelectedValue,
                    Glascow = txtGlascowComaScaleScore.Text,
                    Risk = txtRisk.Text,
                    Sluggish = txtSluggish.Text,
                    NoReaction = txtNoReaction.Text,
                    EyesClosed = txtEyesClosed.Text,
                    ANormalPower1 = txtArmsNormalPower1.Text,
                    ANormalPower2 = txtArmsNormalPower2.Text,
                    ASevereWeakness1 = txtArmsSevereWeakness1.Text,
                    ASevereWeakness2 = txtArmsSevereWeakness2.Text,
                    ASpasticFlexion1 = txtArmsSpasticFlexion1.Text,
                    ASpasticFlexion2 = txtArmsSpasticFlexion2.Text,
                    AExtension1 = txtArmsExtension1.Text,
                    AExtension2 = txtArmsExtension2.Text,
                    ANoResponse1 = txtArmsNoResponse1.Text,
                    ANoResponse2 = txtArmsNoResponse2.Text,
                    LNormalPower1 = txtLegsNormalPower1.Text,
                    LNormalPower2 = txtLegsNormalPower2.Text,
                    LMildWeakness1 = txtLegsMildWeakness1.Text,
                    LMildWeakness2 = txtLegsMildWeakness2.Text,
                    LSpasticFlexion1 = txtLegsSpasticFlexion1.Text,
                    LSpasticFlexion2 = txtLegsSpasticFlexion2.Text,
                    LExtension1 = txtLegsExtension1.Text,
                    LExtension2 = txtLegsExtension2.Text,
                    LNoResponse1 = txtLegsNoResponse1.Text,
                    LNoResponse2 = txtLegsNoResponse2.Text,
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
                    rdbEyeOpening.SelectedIndex = -1;
                    rdbVerbalAdult.SelectedIndex = -1;
                    rdbBestMotorResponse.SelectedIndex = -1;
                    txtGlascowComaScaleScore.Text = "";

                    lblEyeOpening1.Text = "";
                    lblVerbalAdult1.Text = "";
                    lblBestMotorResponse1.Text ="";
                    lblGlascowComaScaleScore1.Text = "";
                    txtRisk.Text = "";
                    txtSluggish.Text = "";
                    txtNoReaction.Text = "";
                    txtEyesClosed.Text = "";
                    txtArmsNormalPower1.Text = "";
                    txtArmsNormalPower1.Text = "";
                    txtArmsNormalPower2.Text = "";
                    txtArmsSevereWeakness1.Text = "";
                    txtArmsSevereWeakness2.Text = "";
                    txtArmsSpasticFlexion1.Text = "";
                    txtArmsSpasticFlexion2.Text = "";
                    txtArmsExtension1.Text = "";
                    txtArmsExtension2.Text = "";
                    txtArmsNoResponse1.Text = "";
                    txtArmsNoResponse2.Text = "";
                    txtLegsNormalPower1.Text = "";
                    txtLegsNormalPower2.Text = "";
                    txtLegsMildWeakness1.Text = "";
                    txtLegsMildWeakness2.Text = "";
                    txtLegsSpasticFlexion1.Text = "";
                    txtLegsSpasticFlexion2.Text = "";
                    txtLegsExtension1.Text = "";
                    txtLegsExtension2.Text = "";
                    txtLegsNoResponse1.Text = "";
                    txtLegsNoResponse2.Text = "";
             
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
            var sqlCMD = "UPDATE neurologicalobservationchart SET Date=@Date,Time=@Time,UpdateDate=NOW(),UpdatedBy=@UpdatedBy,EyeOpening=@EyeOpening," +
                "VerbalAdult=@VerbalAdult,BestMotorResponse=@BestMotorResponse,Glascow=@Glascow,Risk=@Risk," +
                "Sluggish=@Sluggish,NoReaction=@NoReaction,EyesClosed=@EyesClosed,ANormalPower1=@ANormalPower1," +
                "ANormalPower2=@ANormalPower2,ASevereWeakness1=@ASevereWeakness1,ASevereWeakness2=@ASevereWeakness2,ASpasticFlexion1=@ASpasticFlexion1," +
                "ASpasticFlexion2=@ASpasticFlexion2,AExtension1=@AExtension1,AExtension2=@AExtension2,ANoResponse1=@ANoResponse1,ANoResponse2=@ANoResponse2," +
                "LNormalPower1=@LNormalPower1,LNormalPower2=@LNormalPower2,LMildWeakness1=@LMildWeakness1,LMildWeakness2=@LMildWeakness2," +
                "LSpasticFlexion1=@LSpasticFlexion1,LSpasticFlexion2=@LSpasticFlexion2,LExtension1=@LExtension1,LExtension2=@LExtension2," +
                "LNoResponse1=@LNoResponse1,LNoResponse2=@LNoResponse2" +
                " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    EyeOpening = rdbEyeOpening.SelectedValue,
                    VerbalAdult = rdbVerbalAdult.SelectedValue,
                    BestMotorResponse = rdbBestMotorResponse.SelectedValue,
                    Glascow = txtGlascowComaScaleScore.Text,
                    Risk = txtRisk.Text,
                    Sluggish = txtSluggish.Text,
                    NoReaction = txtNoReaction.Text,
                    EyesClosed = txtEyesClosed.Text,
                    ANormalPower1 = txtArmsNormalPower1.Text,
                    ANormalPower2 = txtArmsNormalPower2.Text,
                    ASevereWeakness1 = txtArmsSevereWeakness1.Text,
                    ASevereWeakness2 = txtArmsSevereWeakness2.Text,
                    ASpasticFlexion1 = txtArmsSpasticFlexion1.Text,
                    ASpasticFlexion2 = txtArmsSpasticFlexion2.Text,
                    AExtension1 = txtArmsExtension1.Text,
                    AExtension2 = txtArmsExtension2.Text,
                    ANoResponse1 = txtArmsNoResponse1.Text,
                    ANoResponse2 = txtArmsNoResponse2.Text,
                    LNormalPower1 = txtLegsNormalPower1.Text,
                    LNormalPower2 = txtLegsNormalPower2.Text,
                    LMildWeakness1 = txtLegsMildWeakness1.Text,
                    LMildWeakness2 = txtLegsMildWeakness2.Text,
                    LSpasticFlexion1 = txtLegsSpasticFlexion1.Text,
                    LSpasticFlexion2 = txtLegsSpasticFlexion2.Text,
                    LExtension1 = txtLegsExtension1.Text,
                    LExtension2 = txtLegsExtension2.Text,
                    LNoResponse1 = txtLegsNoResponse1.Text,
                    LNoResponse2 = txtLegsNoResponse2.Text,
                    ID = Util.GetInt(lblID.Text)
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