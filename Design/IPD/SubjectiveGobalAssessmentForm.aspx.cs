
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


public partial class Design_IPD_SubjectiveGobalAssessmentForm : System.Web.UI.Page
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
       
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./SubjectiveGobalAssessment_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + lblID.Text + "'");
            if (rows.Length > 0)
            {
                txtDate.Text = rows[0]["Date1"].ToString();
                txtTime.Text = rows[0]["Time1"].ToString();
                if (rows[0]["NoChange"].ToString() == "1")
                {
                    chkNoChange.Checked = true;
                }
                else
                {
                    chkNoChange.Checked = false;
                }
                txtInadequate1.Text = rows[0]["Inadequate1"].ToString();
                rdbInadequate2.SelectedValue = rows[0]["Inadequate2"].ToString();
                rdbNutrient1.SelectedValue = rows[0]["Nutrient1"].ToString();
                txtNutrient2.Text = rows[0]["Nutrient2"].ToString();
                txtUsual.Text = rows[0]["Usual"].ToString();
                txtCurrent.Text = rows[0]["Current"].ToString();
                txtWeightLoss1.Text = rows[0]["WeightLoss1"].ToString();
                rdbWeightLoss2.SelectedValue = rows[0]["WeightLoss2"].ToString();
                rdbloss.SelectedValue = rows[0]["SubjectiveLoss"].ToString();
                txtAmount.Text = rows[0]["Amount"].ToString();
                rdbChange.SelectedValue = rows[0]["WeightChange"].ToString();
                rdbSymptoms2.SelectedValue = rows[0]["Symptoms2"].ToString();
                rdbSymptoms3.SelectedValue = rows[0]["Symptoms3"].ToString();
                rdbNoDysfunction.SelectedValue = rows[0]["Nodysfunction"].ToString();
                txtReduced1.Text = rows[0]["Reduced1"].ToString();
                rdbReduced2.SelectedValue = rows[0]["Reduced2"].ToString();
                rdbFunctional.SelectedValue = rows[0]["Functional"].ToString();
                rdbHigh.SelectedValue = rows[0]["High"].ToString();
                rdbLossA.SelectedValue = rows[0]["Loss1"].ToString();
                rdbLossB.SelectedValue = rows[0]["Loss2"].ToString();
                rdbPresence.SelectedValue = rows[0]["Presence"].ToString();
                rdbSGA.SelectedValue = rows[0]["SGA"].ToString();
                rdbContributing.SelectedValue = rows[0]["Contributing"].ToString();
                rdbUnderP.SelectedValue = rows[0]["Under"].ToString();
                rdbTriceps.SelectedValue = rows[0]["Triceps"].ToString();
                rdbRobs.SelectedValue = rows[0]["Robs"].ToString();
                rdbTemple.SelectedValue = rows[0]["Temple"].ToString();
                rdbClavicle.SelectedValue = rows[0]["Clavicle"].ToString();
                rdbShoulder.SelectedValue = rows[0]["Shoulder"].ToString();
                rdbScapula.SelectedValue = rows[0]["Scapula"].ToString();
                rdbQuadriceps.SelectedValue = rows[0]["Quadriceps"].ToString();
                rdbInterrosseous.SelectedValue = rows[0]["Interrosseous"].ToString();
                rdbEdema.SelectedValue = rows[0]["Edema"].ToString();
                rdbAscites.SelectedValue = rows[0]["Ascites"].ToString();
                if (rows[0]["Pain"].ToString() == "1")
                {
                    chkSymptoms1.Items[0].Selected = true;
                }
                if (rows[0]["Anorexia"].ToString() == "1")
                {
                    chkSymptoms1.Items[1].Selected = true;
                } 
                if (rows[0]["Vomiting"].ToString() == "1")
                {
                    chkSymptoms1.Items[2].Selected = true;
                } 
                if (rows[0]["Nausea"].ToString() == "1")
                {
                    chkSymptoms1.Items[3].Selected = true;
                } 
                if (rows[0]["Disphagia"].ToString() == "1")
                {
                    chkSymptoms1.Items[4].Selected = true;
                } 
                if (rows[0]["Diarrhea"].ToString() == "1")
                {
                    chkSymptoms1.Items[5].Selected = true;
                }
                if (rows[0]["Dental"].ToString() == "1")
                {
                    chkSymptoms1.Items[6].Selected = true;
                } 
                if (rows[0]["Feels"].ToString() == "1")
                {
                    chkSymptoms1.Items[7].Selected = true;
                } 
                if (rows[0]["Constipation"].ToString() == "1")
                {
                    chkSymptoms1.Items[8].Selected = true;
                } 
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=iu.CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1 from SubjectiveGobalAssessmentForm iu where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                ViewState["dt"] = dt;
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
            string nochange = "0";
            if (chkNoChange.Checked)
            {
                nochange = "1";
            }
            string pain = "0";
            if (chkSymptoms1.Items[0].Selected)
            {
                pain = "1";
            }
            string anorexia = "0";
            if (chkSymptoms1.Items[1].Selected)
            {
                anorexia = "1";
            }
            
            string vomiting = "0";
            if (chkSymptoms1.Items[2].Selected)
            {
                vomiting = "1";
            }
            string nausea = "0";
            if (chkSymptoms1.Items[3].Selected)
            {
                nausea = "1";
            }
            string disphagia = "0";
            if (chkSymptoms1.Items[4].Selected)
            {
                disphagia = "1";
            }
            string diarrhea = "0";
            if (chkSymptoms1.Items[5].Selected)
            {
                diarrhea = "1";
            }
            string dental = "0";
            if (chkSymptoms1.Items[6].Selected)
            {
                dental = "1";
            }
            string feels = "0";
            if (chkSymptoms1.Items[7].Selected)
            {
                feels = "1";
            }
            string constipation = "0";
            if (chkSymptoms1.Items[8].Selected)
            {
                constipation = "1";
            }
            
            var sqlCMD = "INSERT INTO subjectivegobalassessmentform ("+

 " Date,  Time,  NoChange,  Inadequate1,Inadequate2,  Nutrient1,  Nutrient2,  Usual,  Current,  WeightLoss1,  WeightLoss2,  SubjectiveLoss,  Amount,  WeightChange,  Symptoms1,  Symptoms2,  Symptoms3," +
"  Nodysfunction,  Reduced1,  Reduced2,  Functional,  High,  Loss1,  Loss2,  Presence,  SGA,  Contributing,  Under,  Triceps,  Robs,  Temple,  Clavicle,  Shoulder,  Scapula,  Quadriceps,"+
"  Interrosseous,  Edema,  Ascites,  CreatedBy, CreatedDate, PatientID,  TransactionID, Pain,  Anorexia,  Vomiting,  Nausea,  Disphagia,  Diarrhea,  Dental,  Feels,  Constipation)" +
" VALUES  (       @Date,    @Time,    @NoChange,    @Inadequate1,  @Inadequate2,    @Nutrient1,    @Nutrient2,    @Usual,    @Current,    @WeightLoss1,    @WeightLoss2,    @SubjectiveLoss,    @Amount," +
"    @WeightChange,    @Symptoms1,    @Symptoms2,    @Symptoms3,    @Nodysfunction,    @Reduced1,    @Reduced2,    @Functional,    @High,    @Loss1,    @Loss2,    @Presence,    @SGA,"+
  "  @Contributing,    @Under,    @Triceps,   @Robs,    @Temple,    @Clavicle,    @Shoulder,    @Scapula,    @Quadriceps,    @Interrosseous,    @Edema,    @Ascites,    @CreatedBy,"+
"    NOW(),     @PatientID,    @TransactionID , @Pain,  @Anorexia,  @Vomiting,  @Nausea,  @Disphagia,  @Diarrhea,  @Dental,  @Feels,  @Constipation );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    NoChange = nochange,
                    Inadequate1 = txtInadequate1.Text,
                    Inadequate2 = rdbInadequate2.SelectedValue,
                    Nutrient1 = rdbNutrient1.SelectedValue,
                    Nutrient2 = txtNutrient2.Text,
                    Usual = txtUsual.Text,
                    Current = txtCurrent.Text,
                    WeightLoss1 = txtWeightLoss1.Text,
                    WeightLoss2 = rdbWeightLoss2.SelectedValue,
                    SubjectiveLoss = rdbloss.SelectedValue,
                    Amount = txtAmount.Text,
                    WeightChange = rdbChange.SelectedValue,
                    Symptoms1 = "1",
                    Symptoms2 = rdbSymptoms2.SelectedValue,
                    Symptoms3 = rdbSymptoms3.SelectedValue,
                    Nodysfunction = rdbNoDysfunction.SelectedValue,
                    Reduced1 = txtReduced1.Text,
                    Reduced2 = rdbReduced2.SelectedValue,
                    Functional = rdbFunctional.SelectedValue,
                    High = rdbHigh.SelectedValue,
                    Loss1 = rdbLossA.SelectedValue,
                    Loss2 = rdbLossB.SelectedValue,
                    Presence = rdbPresence.SelectedValue,
                    SGA = rdbSGA.SelectedValue,
                    Contributing = rdbContributing.SelectedValue,
                    Under = rdbUnderP.SelectedValue,
                    Triceps = rdbTriceps.SelectedValue,
                    Robs = rdbRobs.SelectedValue,

                    Temple = rdbTemple.SelectedValue,
                    Clavicle = rdbClavicle.SelectedValue,
                    Shoulder = rdbShoulder.SelectedValue,
                    Scapula = rdbScapula.SelectedValue,
                    Quadriceps = rdbQuadriceps.SelectedValue,
                    Interrosseous = rdbInterrosseous.SelectedValue,
                    Edema = rdbEdema.SelectedValue,
                    Ascites = rdbAscites.SelectedValue,
                     Pain=pain,
                     Anorexia=anorexia,
                     Vomiting=vomiting, 
                     Nausea=nausea, 
                     Disphagia=disphagia,
                     Diarrhea=diarrhea, 
                     Dental=dental,  
                     Feels=feels, 
                     Constipation=constipation,
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

                        chkNoChange.Checked = false;
                
                txtInadequate1.Text = "";
                rdbInadequate2.SelectedIndex = -1;
                rdbNutrient1.SelectedIndex = -1;
                txtNutrient2.Text = "";
                txtUsual.Text ="";
                txtCurrent.Text = "";
                txtWeightLoss1.Text = "";
                rdbWeightLoss2.SelectedIndex = -1;
                rdbloss.SelectedIndex = -1;
                txtAmount.Text = "";
                rdbChange.SelectedIndex = -1;
                rdbSymptoms2.SelectedIndex = -1;
                rdbSymptoms3.SelectedIndex = -1;
                rdbNoDysfunction.SelectedIndex = -1;
                txtReduced1.Text = "";
                rdbReduced2.SelectedIndex = -1;
                rdbFunctional.SelectedIndex =-1;
                rdbHigh.SelectedIndex =-1;
                rdbLossA.SelectedIndex = -1;
                rdbLossB.SelectedIndex = -1;
                rdbPresence.SelectedIndex =-1;
                rdbSGA.SelectedIndex = -1;
                rdbContributing.SelectedIndex = -1;
                rdbUnderP.SelectedIndex = -1;
                rdbTriceps.SelectedIndex = -1;
                rdbRobs.SelectedIndex = -1;
                rdbTemple.SelectedIndex = -1;
                rdbClavicle.SelectedIndex = -1;
                rdbShoulder.SelectedIndex = -1;
                rdbScapula.SelectedIndex = -1;
                rdbQuadriceps.SelectedIndex = -1;
                rdbInterrosseous.SelectedIndex = -1;
                rdbEdema.SelectedIndex =-1;
                rdbAscites.SelectedIndex =-1;
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
            string nochange = "0";
            if (chkNoChange.Checked)
            {
                nochange = "1";
            }

            string pain = "0";
            if (chkSymptoms1.Items[0].Selected)
            {
                pain = "1";
            }
            string anorexia = "0";
            if (chkSymptoms1.Items[1].Selected)
            {
                anorexia = "1";
            }

            string vomiting = "0";
            if (chkSymptoms1.Items[2].Selected)
            {
                vomiting = "1";
            }
            string nausea = "0";
            if (chkSymptoms1.Items[3].Selected)
            {
                nausea = "1";
            }
            string disphagia = "0";
            if (chkSymptoms1.Items[4].Selected)
            {
                disphagia = "1";
            }
            string diarrhea = "0";
            if (chkSymptoms1.Items[5].Selected)
            {
                diarrhea = "1";
            }
            string dental = "0";
            if (chkSymptoms1.Items[6].Selected)
            {
                dental = "1";
            }
            string feels = "0";
            if (chkSymptoms1.Items[7].Selected)
            {
                feels = "1";
            }
            string constipation = "0";
            if (chkSymptoms1.Items[8].Selected)
            {
                constipation = "1";
            }
            var sqlCMD = "UPDATE subjectivegobalassessmentform  set " +

 " Date=@Date,  Time=@Time,  NoChange=@NoChange,  Inadequate1=@Inadequate1,Inadequate2=@Inadequate2,  Nutrient1=@Nutrient1,  Nutrient2=@Nutrient2,  Usual=@Usual,  Current=@Current"+
 ",  WeightLoss1=@WeightLoss1,  WeightLoss2=@WeightLoss2,  SubjectiveLoss=@SubjectiveLoss,  Amount=@Amount,  WeightChange=@WeightChange,  Symptoms1=@Symptoms1,  Symptoms2=@Symptoms2,  Symptoms3=@Symptoms3," +
"  Nodysfunction=@Nodysfunction,  Reduced1=@Reduced1,  Reduced2=@Reduced2,  Functional=@Functional,  High=@High,  Loss1=@Loss1,  Loss2=@Loss2,  Presence=@Presence,  SGA=@SGA"+
",  Contributing=@Contributing,  Under=@Under,  Triceps=@Triceps,  Robs=@Robs,  Temple=@Temple,  Clavicle=@Clavicle,  Shoulder=@Shoulder,  Scapula=@Scapula,  Quadriceps=@Quadriceps," +
" Pain=@Pain,  Anorexia=@Anorexia,  Vomiting=@Vomiting,  Nausea=@Nausea,  Disphagia=@Disphagia,  Diarrhea=@Diarrhea,  Dental=@Dental,  Feels=@Feels,  Constipation=@Constipation," +
"  Interrosseous=@Interrosseous,  Edema=@Edema,  Ascites=@Ascites" +
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    NoChange = nochange,
                    Inadequate1 = txtInadequate1.Text,
                    Inadequate2 = rdbInadequate2.SelectedValue,
                    Nutrient1 = rdbNutrient1.SelectedValue,
                    Nutrient2 = txtNutrient2.Text,
                    Usual = txtUsual.Text,
                    Current = txtCurrent.Text,
                    WeightLoss1 = txtWeightLoss1.Text,
                    WeightLoss2 = rdbWeightLoss2.SelectedValue,
                    SubjectiveLoss = rdbloss.SelectedValue,
                    Amount = txtAmount.Text,
                    WeightChange = rdbChange.SelectedValue,
                    Symptoms1 = "1",
                    Symptoms2 = rdbSymptoms2.SelectedValue,
                    Symptoms3 = rdbSymptoms3.SelectedValue,
                    Nodysfunction = rdbNoDysfunction.SelectedValue,
                    Reduced1 = txtReduced1.Text,
                    Reduced2 = rdbReduced2.SelectedValue,
                    Functional = rdbFunctional.SelectedValue,
                    High = rdbHigh.SelectedValue,
                    Loss1 = rdbLossA.SelectedValue,
                    Loss2 = rdbLossB.SelectedValue,
                    Presence = rdbPresence.SelectedValue,
                    SGA = rdbSGA.SelectedValue,
                    Contributing = rdbContributing.SelectedValue,
                    Under = rdbUnderP.SelectedValue,
                    Triceps = rdbTriceps.SelectedValue,
                    Robs = rdbRobs.SelectedValue,

                    Temple = rdbTemple.SelectedValue,
                    Clavicle = rdbClavicle.SelectedValue,
                    Shoulder = rdbShoulder.SelectedValue,
                    Scapula = rdbScapula.SelectedValue,
                    Quadriceps = rdbQuadriceps.SelectedValue,
                    Interrosseous = rdbInterrosseous.SelectedValue,
                    Edema = rdbEdema.SelectedValue,
                    Ascites = rdbAscites.SelectedValue,
                    Pain = pain,
                    Anorexia = anorexia,
                    Vomiting = vomiting,
                    Nausea = nausea,
                    Disphagia = disphagia,
                    Diarrhea = diarrhea,
                    Dental = dental,
                    Feels = feels,
                    Constipation = constipation,
                    
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