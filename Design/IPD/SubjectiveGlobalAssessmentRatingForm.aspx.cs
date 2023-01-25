
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


public partial class Design_IPD_SubjectiveGlobalAssessmentRatingForm : System.Web.UI.Page
{
    protected void Radio1_Changed(object sender, EventArgs e)
    {
       
    }
    protected void Radio11_Changed(object sender, EventArgs e)
    {

    }
    
    protected void Radio2_Changed(object sender, EventArgs e)
    {

       
    }
    protected void Radio3_Changed(object sender, EventArgs e)
    {

       
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./SubjectiveGlobalAssessmentRatingForm_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text;
                txtBaseLine.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBaseLine")).Text;

                txtCurrentWeight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCurrent")).Text;
                txtActual.Text = ((Label)grdPhysical.Rows[id].FindControl("lblActual")).Text;
                txtPercentLoss.Text= ((Label)grdPhysical.Rows[id].FindControl("lblloss")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblWeight1")).Text != "")
                {
                    rdbWeight.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblWeight1")).Text;
                }
                txtRisk.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRisk1")).Text;
                txtNoChange1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNochange1")).Text;
                txtNoChange2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNochange2")).Text;
                rdbNoChange1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblchange")).Text;
                txtSub.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNoChange2")).Text;
                txtProtein.Text = ((Label)grdPhysical.Rows[id].FindControl("lblProtein")).Text;
                txtKcal.Text = ((Label)grdPhysical.Rows[id].FindControl("lblKcal")).Text;
                txtDuration.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDuration1")).Text;
                txtFull.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFullLiquid")).Text;
                txtHypocaloric.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHypocaloric")).Text;
                txtStarvation.Text = ((Label)grdPhysical.Rows[id].FindControl("lblStarvation")).Text;
                rdbNone1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblNone1")).Text;
                txtNone2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNone2")).Text;
                txtNone3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNone3")).Text;
                rdbAnorexia1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAnorexia1")).Text;
                txtAnorexia2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAnorexia2")).Text;
                txtAnorexia3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAnorexia3")).Text;
                rdbNausea1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblNausea1")).Text;
                txtNausea2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNausea2")).Text;
                txtNausea3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNausea3")).Text;
                rdbVomiting1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblVomiting1")).Text;
                txtVomiting2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVomiting2")).Text;
                txtVomiting3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVomiting3")).Text;
                rdbDiarrhea1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDiarrhea1")).Text;
                txtDiarrhea2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDiarrhea2")).Text;
                txtDiarrhea3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDiarrhea3")).Text;
                rdbNoDysfunction1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblNoDysfunction1")).Text;
                txtNoDysfunction2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNoDysfunction2")).Text;
                rdbChange1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblChange1")).Text;
                txtChange2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblChange2")).Text;
                rdbDifficulty11.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDifficulty11")).Text;
                txtDifficulty12.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDifficulty12")).Text;
                rdbDifficulty21.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDifficulty21")).Text;
                txtDifficulty22.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDifficulty22")).Text;
                rdbLight1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblLight1")).Text;
                txtLight2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLight2")).Text;
                rdbBed1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblBed1")).Text;
                txtBed2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBed2")).Text;
                rdbimprovement1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblimprovement1")).Text;
                txtimprovement2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblimprovement2")).Text;
                txtPrimary.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPrimary")).Text;
                ddlComorbidities.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblComorbidities")).Text;
                rdbNormal.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNormal")).Text;
                rdbIncreased.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblIncreased")).Text;
                rdbDecreased.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblDecreased")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblAcute")).Text != "")
                {

                    rdbAcute.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAcute")).Text;
                }
                rdbLoss1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblLoss1")).Text;
                txtLoss2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLoss2")).Text;
                //rdbSome1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSome1")).Text;
                //txtAll1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAll1")).Text;
                rdbMuscle1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblMuscle")).Text;
                txtMuscle2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMuscle1")).Text;
                //txtSome2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSome2")).Text;
                //txtAll2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAll2")).Text;
                rdbEdema1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblEdema")).Text;
                txtEdema2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEdema1")).Text;
                txtRisk3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRisk2")).Text;
                txtRisk4.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRisk3")).Text;
                txtRisk5.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRisk4")).Text;
                txtRisk6.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRisk5")).Text;
                txtDetail.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDetail")).Text;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
            
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=iu.CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff from subjectiveglobalassessmentratingform iu where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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
            
                var sqlCMD = "INSERT INTO subjectiveglobalassessmentratingform ("+

  "Date,  Time,  BaseLine,  Current,  Actual,  loss,  Weight1,  Risk1,  Nochange1,  Nochange2,  Change3,  Protein,  Kcal,  Duration1,  FullLiquid,  Hypocaloric,  Starvation,  None1,"+
"  None2,  None3,  Anorexia1,  Anorexia2,  Anorexia3,  Nausea1,  Nausea2,  Nausea3,  Vomiting1,  Vomiting2,  Vomiting3,  Diarrhea1,  Diarrhea2,  Diarrhea3,  NoDysfunction1,  NoDysfunction2,"+
"  Change1, Change2,  Difficulty11,  Difficulty12,  Difficulty21,  Difficulty22,  Light1, Light2, Bed1,  Bed2,  improvement1,  improvement2,  Primary1,  Comorbidities,  Normal,  Increased,"+
"  Decreased,  Acute,Loss1,  Loss2,  Muscle,Muscle1,  Edema,Edema1,  Risk2,  Risk3,  Risk4,  Risk5,  CreatedBy,  CreatedDate,  PatientID,  TransactionID,Detail)"+
" VALUES  (        @Date,    @Time,    @BaseLine,    @Current,   @Actual,    @loss,    @Weight1,    @Risk1,    @Nochange1,   @Nochange2,    @Change3,    @Protein,    @Kcal,    @Duration1,"+
"    @FullLiquid,    @Hypocaloric,   @Starvation,    @None1,    @None2,   @None3,    @Anorexia1,   @Anorexia2,    @Anorexia3,    @Nausea1,    @Nausea2,    @Nausea3,    @Vomiting1,"+
"    @Vomiting2,    @Vomiting3,    @Diarrhea1,    @Diarrhea2,    @Diarrhea3,    @NoDysfunction1,    @NoDysfunction2,    @Change1,    @Change2,    @Difficulty11,    @Difficulty12,"+
"    @Difficulty21,    @Difficulty22,    @Light1,    @Light2,    @Bed1,    @Bed2,   @improvement1,    @improvement2,    @Primary1,    @Comorbidities,  @Normal,    @Increased,    @Decreased,"+
"    @Acute, @Loss1,   @Loss2,    @Muscle,@Muscle1,    @Edema,@Edema1 ,   @Risk2,    @Risk3,    @Risk4,    @Risk5,    @CreatedBy,    Now(),    @PatientID,    @TransactionID ,@Detail );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    BaseLine = txtBaseLine.Text,
                    Current = txtCurrentWeight.Text,
                    Actual = txtActual.Text,
                    loss = txtPercentLoss.Text,
                    Weight1 = rdbWeight.SelectedValue,
                    Risk1 = txtRisk.Text,
                    Nochange1 = txtSub.Text,
                    Nochange2 = txtNoChange2.Text,
                    Change3 = rdbNoChange1.SelectedValue,
                    Protein = txtProtein.Text,
                    Kcal = txtKcal.Text,
                    Duration1 = txtDuration.Text,
                    FullLiquid =txtFull.Text,
                    Hypocaloric = txtHypocaloric.Text,
                    Starvation = txtStarvation.Text,
                    None1 = rdbNone1.SelectedValue,
                    None2 = txtNone2.Text,
                    None3 = txtNone3.Text,
                    Anorexia1 = rdbAnorexia1.SelectedValue,
                    Anorexia2 = txtAnorexia2.Text,
                    Anorexia3 = txtAnorexia3.Text,
                    Nausea1 = rdbNausea1.SelectedValue,
                    Nausea2 = txtNausea2.Text,
                    Nausea3 = txtNausea3.Text,
                    Vomiting1 = rdbVomiting1.SelectedValue,
                    Vomiting2 = txtVomiting2.Text,
                    Vomiting3 = txtVomiting3.Text,
                
                    Diarrhea1 = rdbDiarrhea1.SelectedValue,
                    Diarrhea2 = txtDiarrhea2.Text,
                    Diarrhea3 = txtDiarrhea3.Text,
                    NoDysfunction1 = rdbNoDysfunction1.SelectedValue,
                    NoDysfunction2 = txtNoDysfunction2.Text,
                    Change1 = rdbChange1.SelectedValue,
                    Change2 = txtChange2.Text,
                    Difficulty11 = rdbDifficulty11.SelectedValue,
                    Difficulty12 = txtDifficulty12.Text,
                    Difficulty21 = rdbDifficulty21.SelectedValue,
                    Difficulty22 = txtDifficulty22.Text,
                    Light1 = rdbLight1.SelectedValue,
                    Light2 = txtLight2.Text,
                    Bed1 = rdbBed1.SelectedValue,
                    Bed2 = txtBed2.Text,
                    improvement1 = rdbimprovement1.SelectedValue,
                    improvement2 = txtimprovement2.Text,
                    Primary1 = txtPrimary.Text,
                    Comorbidities = ddlComorbidities.SelectedValue,
                    Normal = rdbNormal.SelectedValue,
                    Increased = rdbIncreased.SelectedValue,
                    Decreased = rdbDecreased.SelectedValue,
                    Acute = rdbAcute.SelectedValue,
                    Loss1 = rdbLoss1.SelectedValue,
                    Loss2 = txtLoss2.Text,
                    //Some1 = txtSome1.Text,
                    // All1 = txtAll1.Text,
                    Muscle = rdbMuscle1.SelectedValue,
                    Muscle1 = txtMuscle2.Text,
                    //Some2 = txtSome2.Text,
                    //All2 = txtAll2.Text,
                    Edema = rdbEdema1.SelectedValue,
                    Edema1 = txtEdema2.Text,
                    Risk2 = txtRisk3.Text,
                    Risk3 = txtRisk4.Text,
                    Risk4 = txtRisk5.Text,
                    Risk5 = txtRisk6.Text,
                    Detail=txtDetail.Text,
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

                    txtBaseLine.Text = "";

                    txtCurrentWeight.Text = "";
                    txtActual.Text = "";
                    txtPercentLoss.Text = "";
                    rdbWeight.SelectedIndex =-1;
                    txtRisk.Text = "";
                    txtNoChange1.Text = "";
                    txtNoChange2.Text = "";
                    txtSub.Text = "";
                    txtProtein.Text = "";
                    txtKcal.Text = "";
                    txtDuration.Text ="";
                    txtFull.Text = "";
                    txtHypocaloric.Text = "";
                    txtStarvation.Text = "";
                    rdbNone1.SelectedIndex = -1;
                    txtNone2.Text = "";
                    txtNone3.Text = "";
                    rdbAnorexia1.SelectedIndex = -1;
                    txtAnorexia2.Text = "";
                    txtAnorexia3.Text ="";
                    rdbNausea1.SelectedIndex =-1;
                    txtNausea2.Text = "";
                    txtNausea3.Text = "";
                    rdbVomiting1.SelectedIndex = -1;
                    txtVomiting2.Text = "";
                    txtVomiting3.Text = "";
                    rdbDiarrhea1.SelectedIndex =-1;
                    txtDiarrhea2.Text = "";
                    txtDiarrhea3.Text ="";
                    rdbNoDysfunction1.SelectedIndex =-1;
                    txtNoDysfunction2.Text = "";
                    rdbChange1.SelectedIndex = -1;
                    txtChange2.Text ="";
                    rdbDifficulty11.SelectedIndex = -1;
                    txtDifficulty12.Text = "";
                    rdbDifficulty21.SelectedIndex = -1;
                    txtDifficulty22.Text = "";
                    rdbLight1.SelectedIndex = -1;
                    txtLight2.Text ="";
                    rdbBed1.SelectedIndex = -1;
                    txtBed2.Text = "";
                    rdbimprovement1.SelectedIndex = -1;
                    txtimprovement2.Text ="";
                    txtPrimary.Text = "";
                    ddlComorbidities.SelectedValue = "0";
                    rdbNormal.SelectedIndex = -1;
                    rdbIncreased.SelectedIndex = -1;
                    rdbDecreased.SelectedIndex = -1;
                    rdbAcute.SelectedIndex = -1;
                    rdbLoss1.SelectedIndex = -1;
                    //txtSome1.Text = "";
                    //txtAll1.Text = "";
                    rdbMuscle1.SelectedIndex = -1;
                    //txtSome2.Text = "";
                    //txtAll2.Text = "";
                    rdbEdema1.SelectedIndex = -1;
                    txtRisk3.Text = "";
                    txtRisk4.Text ="";
                    txtRisk5.Text ="";
                    txtRisk6.Text ="";
                    txtDetail.Text = "";
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
            var sqlCMD = "UPDATE subjectiveglobalassessmentratingform SET Date=@Date,Time=@Time,UpdateDate=NOW(),UpdatedBy=@UpdatedBy,BaseLine=@BaseLine," +
                "Current=@Current,Actual=@Actual,loss=@loss,Weight1=@Weight1," +
                "Risk1=@Risk1,Nochange1=@Nochange1,Nochange2=@Nochange2,Change3=@Change," +
                "Protein=@Protein,Kcal=@Kcal,Duration1=@Duration1,FullLiquid=@FullLiquid," +
                "Hypocaloric=@Hypocaloric,Starvation=@Starvation,None1=@None1,None2=@None2,None3=@None3,Anorexia1=@Anorexia1,Anorexia2=@Anorexia2," +
                "Anorexia3=@Anorexia3,NoDysfunction1=@NoDysfunction1,NoDysfunction2=@NoDysfunction2,Change1=@Change1,Change2=@Change2,Difficulty11=@Difficulty11,Difficulty12=@Difficulty12,Difficulty21=@Difficulty21,Difficulty22=@Difficulty22," +
                    "Light1=Light1,Light2=Light2,Bed1=@Bed1,Bed2=@Bed2,improvement1=@improvement1,improvement2=@improvement2,Primary1=@Primary,Comorbidities=@Comorbidities,Normal=@Normal,Increased=@Increased,Decreased=@Decreased,Acute=@Acute," +
                    "Loss1=@Loss1,Loss2=@Loss2,Muscle=@Muscle,Muscle1=@Muscle1,Edema=@Edema,Edema1=@Edema1,Risk2=@Risk2,Risk3=@Risk3,Risk4=@Risk4,Risk5=@Risk5,Detail=@Detail" +
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    BaseLine = txtBaseLine.Text,
                    Current = txtCurrentWeight.Text,
                    Actual = txtActual.Text,
                    loss = txtPercentLoss.Text,
                    Weight1 = rdbWeight.SelectedValue,
                    Risk1 = txtRisk.Text,
                    Nochange1 = txtSub.Text,
                    Nochange2 = txtNoChange2.Text,
                    Change = rdbChange1.SelectedValue,
                    Protein = txtProtein.Text,
                    Kcal = txtKcal.Text,
                    Duration1 = txtDuration.Text,
                    FullLiquid = txtFull.Text,
                    Hypocaloric = txtHypocaloric.Text,
                    Starvation = txtStarvation.Text,
                    None1 = rdbNone1.SelectedValue,
                    None2 = txtNone2.Text,
                    None3 = txtNone3.Text,
                    Anorexia1 = rdbAnorexia1.SelectedValue,
                    Anorexia2 = txtAnorexia2.Text,
                    Anorexia3 = txtAnorexia3.Text,

                    Nausea1 = rdbNausea1.SelectedValue,
                    Nausea2 = txtNausea2.Text,
                    Nausea3 = txtNausea3.Text,
                    Vomiting1 = rdbVomiting1.SelectedValue,
                    Vomiting2 = txtVomiting2.Text,
                    Vomiting3 = txtVomiting3.Text,

                    Diarrhea1 = rdbDiarrhea1.SelectedValue,
                    Diarrhea2 = txtDiarrhea2.Text,
                    Diarrhea3 = txtDiarrhea3.Text,
                    
                    NoDysfunction1 = rdbNoDysfunction1.SelectedValue,
                    NoDysfunction2 = txtNoDysfunction2.Text,
                    Change1 = rdbChange1.SelectedValue,
                    Change2 = txtChange2.Text,
                    Difficulty11 = rdbDifficulty11.SelectedValue,
                    Difficulty12 = txtDifficulty12.Text,
                    Difficulty21 = rdbDifficulty21.SelectedValue,
                    Difficulty22 = txtDifficulty22.Text,

                    Light1 = rdbLight1.SelectedValue,
                    Light2 = txtLight2.Text,
                    Bed1 = rdbBed1.SelectedValue,
                    Bed2 = txtBed2.Text,
                    improvement1 = rdbimprovement1.SelectedValue,
                    improvement2 = txtimprovement2.Text,
                    Primary = txtPrimary.Text,
                    Comorbidities = ddlComorbidities.SelectedValue,
                    Normal = rdbNormal.SelectedValue,
                    Increased = rdbIncreased.SelectedValue,
                    Decreased = rdbDecreased.SelectedValue,
                    Acute = rdbAcute.SelectedValue,
                    Loss1 = rdbLoss1.SelectedValue,
                    Loss2 = txtLoss2.Text,
                    //Some1 = txtSome1.Text,
                    //All1 = txtAll1.Text,
                    Muscle = rdbMuscle1.SelectedValue,
                    Muscle1 = txtMuscle2.Text,
                    //Some2 = txtSome2.Text,
                    //All2 = txtAll2.Text,
                    Edema = rdbEdema1.SelectedValue,
                    Edema1 = txtEdema2.Text,
                    Risk2 = txtRisk3.Text,
                    Risk3 = txtRisk4.Text,
                    Risk4 = txtRisk5.Text,
                    Risk5 = txtRisk6.Text,
                    Detail = txtDetail.Text,
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