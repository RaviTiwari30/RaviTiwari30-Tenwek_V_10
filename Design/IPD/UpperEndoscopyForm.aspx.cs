
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


public partial class Design_IPD_UpperEndoscopyForm : System.Web.UI.Page
{
    private void FillClientDetails(string PID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select *,DATE_FORMAT(DOB, '%d %b %Y') as DOB1 from patient_master where PatientID='" + PID + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["PFirstName"].ToString() != "")
            {
                lblFirstName.Text = dt.Rows[0]["PFirstName"].ToString();
            }
            if (dt.Rows[0]["PLastName"].ToString() != "")
            {
               lblSurName.Text = dt.Rows[0]["PLastName"].ToString();
            }

            if (dt.Rows[0]["Age"].ToString() != "")
            {
                lblAge.Text = dt.Rows[0]["Age"].ToString();
            }
            if (dt.Rows[0]["Gender"].ToString() != "")
            {
                lblSex.Text = dt.Rows[0]["Gender"].ToString();
            }

            if (dt.Rows[0]["Mobile"].ToString() != "")
            {
                lblPhone.Text = dt.Rows[0]["Mobile"].ToString();
            }
            if (dt.Rows[0]["SecondMobileNo"].ToString() != "")
            {
                lblAlternative.Text = dt.Rows[0]["SecondMobileNo"].ToString();
            }
            if (dt.Rows[0]["state"].ToString() != "")
            {
                lblCounty.Text = dt.Rows[0]["state"].ToString();
                //+" " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
            if (dt.Rows[0]["Taluka"].ToString() != "")
            {
                lblVillage.Text = dt.Rows[0]["Taluka"].ToString();
                //+" " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
            if (dt.Rows[0]["Locality"].ToString() != "")
            {
                lblLocation.Text = dt.Rows[0]["Locality"].ToString();
                //+" " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
        }
       


    }
    private void FillHeight()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT cv.*, ");
        sb.Append("   IF(IFNULL(HTType,'CM')='CM',CONCAT(HT,'/',ROUND(Ht*0.393701,2)),CONCAT(ROUND(HT*2.54,2),'/',HT))HHTType, ");
        sb.Append("   IF(IFNULL(WTType,'KG')='KG',CONCAT(WT,'/',ROUND(WT*2.20462,2)),CONCAT(ROUND(WT/2.20462,2),'/',WT))WWTType, ");
        sb.Append("   IF(IFNULL(TType,'C')='C',CONCAT(T,'/',ROUND(((T * 9/5) + 32) ,2)),CONCAT(ROUND(((T-32)* 5/9)),'/',T))TTType, ");

        sb.Append("   pm.Pname,em.name Username FROM Cpoe_Vital cv");
        sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
        sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
        sb.Append("   WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            txtHeight.Text = dt.Rows[0]["HHTType"].ToString();
            txtWeight.Text = dt.Rows[0]["WWTType"].ToString();
            lblBMI.Text = dt.Rows[0]["BMI"].ToString();
        }
            
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
        txtReportBy.Text = entryby;
        FillClientDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        FillHeight();
        //txtPersonInserting.Text = entryby;
        //txtTotal.Enabled = false;
        //txtAssessmentBy.Text = entryby;
    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
        //    if (((Label)e.Row.FindControl("lblCreatedID")).Text != Session["ID"].ToString())
        //    {
        //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
        //    }
        //    else
        //    {
        //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
        //    }
        //}
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./UpperEndoscopyForm_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            decimal createdDateDiff = Util.GetDecimal(((Label)grdPhysical.Rows[id].FindControl("lblTimeDiff")).Text);
            if ( createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text;
                //rdbBestMotorResponse.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblBestMotorResponse")).Text;


                txtTribe.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTribe")).Text;
                txtChief.Text = ((Label)grdPhysical.Rows[id].FindControl("lblChief")).Text;
                txtHealth.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHealth")).Text;
                txtSymptoms.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSymptoms")).Text;
                txtHeight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHeight")).Text;
                txtWeight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWeight")).Text;
                lblBMI.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBMI")).Text;
                ddlSwallows.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSwallowsSolids")).Text;
                ddlLiquids.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblLiquids")).Text;
                ddlSaliva.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSaliva")).Text;
                ddlOdynophagia.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOdynophagia")).Text;
                txtEmesis.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEmesis")).Text;
                txtHematemesis.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHematemesis")).Text;
                txtAbdPain.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAbdPain")).Text;
                txtDyspepsia.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDyspepsia")).Text;
                txtAnemia.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAnemia")).Text;
                txtWeightLoss.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWeightLoss")).Text;
                txtBlackStools.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBlack")).Text;
                txtBloodyStools.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBloody")).Text;
                txtOther.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOther")).Text;
                txtDuration.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDuration")).Text;
                ddlAlcohol1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAlcohol1")).Text;
                ddlSmoking1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSmoking1")).Text;
                ddlNSAIDS1.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblNSAIDS1")).Text;
                ddlAlcohol2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAlcohol2")).Text;
                ddlSmoking2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSmoking2")).Text;
                ddlNSAIDS2.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblNSAIDS2")).Text;
                ddlEso.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblEso")).Text;
                txtPersonAge1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPersonAge1")).Text;
                ddlOtherCancer.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOtherCancer")).Text;
                txtPersonAge2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPersonAge2")).Text;
                txtLastEGDDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLastEGDDate")).Text;
                txtAdditionalHistory.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAdditional")).Text;
                txtPharnyx.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPharnyx")).Text;
                txtEsophagus.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEsophagus")).Text;
                txtStomach.Text = ((Label)grdPhysical.Rows[id].FindControl("lblStomach")).Text;
                txtDuodenum.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDuodenum")).Text;
                ddlSedation.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSedation")).Text;
                txtVersed.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVersed")).Text;
                txtFentanyl.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFentanyl")).Text;
                txtKetamine.Text = ((Label)grdPhysical.Rows[id].FindControl("lblKetamine")).Text;
                txtOxygen.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOxygen")).Text;
                txtOther2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOther2")).Text;
                ddlImages.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblImages")).Text;
                txtImpression.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImpression")).Text;
                txtEndoscopyIntervention.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEndoscopy")).Text;
                txtRecommendations.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRecommendations")).Text;
                txtFollowUpDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFollowUpDate")).Text;
                txtProcedure.Text = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure")).Text;
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,DATE_FORMAT(LastEGDDate, '%d %b %Y') as LastEGDDate1,DATE_FORMAT(FollowUpDate, '%d %b %Y') as FollowUpDate1,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff from upperendoscopy where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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
            string LastEGDDate = Util.GetDateTime(txtLastEGDDate.Text).ToString("yyyy-MM-dd");
            string FollowUpDate = Util.GetDateTime(txtFollowUpDate.Text).ToString("yyyy-MM-dd");
           
            
                var sqlCMD = "INSERT INTO upperendoscopy("+
  
"Date,Time,Tribe,Chief,Health,Symptoms,Height,Weight,BMI,SwallowsSolids,Liquids,Saliva,Odynophagia,Emesis,Hematemesis,AbdPain,"+
"Dyspepsia,Anemia,WeightLoss,Black,Bloody,Other,Duration,Alcohol1,Smoking1,NSAIDS1,Alcohol2,Smoking2,NSAIDS2,Eso,PersonAge1,"+
"OtherCancer,PersonAge2,LastEGDDate,Additional,Pharnyx,Esophagus,Stomach,Duodenum,Sedation,Versed,Fentanyl,Ketamine,Oxygen,Other2,"+
"Images,Impression,Endoscopy,Recommendations,FollowUpDate,ReportBy,Procedure1,CreatedBy,CreatedDate,PatientID,TransactionID) "+
" VALUES(@Date,@Time,@Tribe,@Chief,@Health,@Symptoms,@Height,@Weight,@BMI,@SwallowsSolids,@Liquids,@Saliva,@Odynophagia,"+
"@Emesis,@Hematemesis,@AbdPain,@Dyspepsia,@Anemia,@WeightLoss,@Black,@Bloody,@Other,@Duration,@Alcohol1,@Smoking1,@NSAIDS1,"+
"@Alcohol2,@Smoking2,@NSAIDS2,@Eso,@PersonAge1,@OtherCancer,@PersonAge2,@LastEGDDate,@Additional,@Pharnyx,@Esophagus,@Stomach,@Duodenum,"+
"@Sedation,@Versed,@Fentanyl,@Ketamine,@Oxygen,@Other2,@Images,@Impression,@Endoscopy,@Recommendations,@FollowUpDate,@ReportBy,@Procedure,"+
"@CreatedBy,NOW(),@PatientID,@TransactionID);";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Tribe = txtTribe.Text,
                    Chief = txtChief.Text,
                    Health = txtHealth.Text,
                    Symptoms = txtSymptoms.Text,
                    Height = txtHeight.Text,
                    Weight = txtWeight.Text,
                    BMI = lblBMI.Text,
                    SwallowsSolids = ddlSwallows.SelectedValue,
                    Liquids = ddlLiquids.SelectedValue,
                    Saliva = ddlSaliva.SelectedValue,
                    Odynophagia = ddlOdynophagia.SelectedValue,
                    Emesis = txtEmesis.Text,
                    Hematemesis = txtHematemesis.Text,
                    AbdPain = txtAbdPain.Text,
                    Dyspepsia = txtDyspepsia.Text,
                    Anemia = txtAnemia.Text,
                    WeightLoss = txtWeightLoss.Text,
                    Black = txtBlackStools.Text,
                    Bloody = txtBloodyStools.Text,

                    Other = txtOther.Text,
                    Duration = txtDuration.Text,
                    Alcohol1 = ddlAlcohol1.SelectedValue,
                    Smoking1 = ddlSmoking1.SelectedValue,
                    NSAIDS1 = ddlNSAIDS1.SelectedValue,
                    Alcohol2 = ddlAlcohol2.SelectedValue,
                    Smoking2 = ddlSmoking2.SelectedValue,
                    NSAIDS2 = ddlNSAIDS2.SelectedValue,
                    Eso = ddlEso.SelectedValue,
                    PersonAge1 = txtPersonAge1.Text,
                    OtherCancer = ddlOtherCancer.SelectedValue,
                    PersonAge2 = txtPersonAge2.Text,
                    LastEGDDate = LastEGDDate,
                    Additional = txtAdditionalHistory.Text,
                    Pharnyx = txtPharnyx.Text,
                    Esophagus = txtEsophagus.Text,
                    Stomach = txtStomach.Text,
                    Duodenum = txtDuodenum.Text,
                    Sedation = ddlSedation.SelectedValue,
                    Versed = txtVersed.Text,
                    Fentanyl = txtFentanyl.Text,
                    Ketamine = txtKetamine.Text,

                    Oxygen = txtOxygen.Text,
                    Other2 = txtOther2.Text,
                    Images = ddlImages.SelectedValue,
                    Impression = txtImpression.Text,
                    Endoscopy = txtEndoscopyIntervention.Text,
                    Recommendations = txtRecommendations.Text,
                    FollowUpDate = FollowUpDate,
                    ReportBy = HttpContext.Current.Session["ID"].ToString(),
                    Procedure = txtProcedure.Text,
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
                    txtTribe.Text = "";
                    txtChief.Text = "";
                    txtHealth.Text = "";
                    txtSymptoms.Text = "";
                    txtHeight.Text = "";
                    txtWeight.Text = "";
                    lblBMI.Text = "";
                    ddlSwallows.SelectedIndex =-1 ;
                    ddlLiquids.SelectedIndex = -1;
                    ddlSaliva.SelectedIndex = -1;
                    ddlOdynophagia.SelectedIndex =-1;
                    txtEmesis.Text = "";
                    txtHematemesis.Text = "";
                    txtAbdPain.Text ="";
                    txtDyspepsia.Text = "";
                    txtAnemia.Text = "";
                    txtWeightLoss.Text = "";
                    txtBlackStools.Text = "";
                    txtBloodyStools.Text = "";
                    txtOther.Text = "";
                    txtDuration.Text ="";
                    ddlAlcohol1.SelectedIndex = -1;
                    ddlSmoking1.SelectedIndex = -1;
                    ddlNSAIDS1.SelectedIndex = -1;
                    ddlAlcohol2.SelectedIndex = -1;
                    ddlSmoking2.SelectedIndex =-1;
                    ddlNSAIDS2.SelectedIndex = -1;
                    ddlEso.SelectedIndex = -1;
                    txtPersonAge1.Text = "";
                    ddlOtherCancer.SelectedIndex = -1;
                    txtPersonAge2.Text = "";
                    txtLastEGDDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtAdditionalHistory.Text = "";
                    txtPharnyx.Text = "";
                    txtEsophagus.Text ="";
                    txtStomach.Text = "";
                    txtDuodenum.Text = "";
                    ddlSedation.SelectedIndex = -1;
                    txtVersed.Text = "";
                    txtFentanyl.Text = "";
                    txtKetamine.Text = "";
                    txtOxygen.Text = "";
                    txtOther2.Text = "";
                    ddlImages.SelectedIndex = -1;
                    txtImpression.Text = "";
                    txtEndoscopyIntervention.Text = "";
                    txtRecommendations.Text ="";
                    txtFollowUpDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtProcedure.Text = "";
                
                    
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
            string LastEGDDate = Util.GetDateTime(txtLastEGDDate.Text).ToString("yyyy-MM-dd");
            string FollowUpDate = Util.GetDateTime(txtFollowUpDate.Text).ToString("yyyy-MM-dd");

            var sqlCMD = "UPDATE upperendoscopy SET Date=@Date,Time=@Time,UpdateDate=NOW(),UpdatedBy=@UpdatedBy,Tribe=@Tribe," +
                "Chief=@Chief,Health=@Health,Symptoms=@Symptoms,Height=@Height,Weight=@Weight,BMI=@BMI,SwallowsSolids=@SwallowsSolids,Liquids=@Liquids,Saliva=@Saliva," +
                "Odynophagia=@Odynophagia,Emesis=@Emesis," +
                "Hematemesis=@Hematemesis,AbdPain=@AbdPain,Dyspepsia=@Dyspepsia,Anemia=@Anemia,WeightLoss=@WeightLoss,Black=@Black,Bloody=@Bloody,Other=@Other,Duration=@Duration," +
                    "Alcohol1=@Alcohol1,Smoking1=@Smoking1,NSAIDS1=@NSAIDS1,Alcohol2=@Alcohol2,Smoking2=@Smoking2,NSAIDS2=@NSAIDS2,Eso=@Eso,PersonAge1=@PersonAge1,OtherCancer=@OtherCancer," +
                    "PersonAge2=@PersonAge2,LastEGDDate=@LastEGDDate,Additional=@Additional,Pharnyx=@Pharnyx,Esophagus=@Esophagus,Stomach=@Stomach,Duodenum=@Duodenum," +
                    "Sedation=@Sedation,Versed=@Versed,Fentanyl=@Fentanyl,Ketamine=@Ketamine,Oxygen=@Oxygen,Other2=@Other2,Images=@Images,Impression=@Impression," +
                    "Endoscopy=@Endoscopy,Recommendations=@Recommendations,FollowUpDate=@FollowUpDate,Procedure1=@Procedure " +
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,

                    Tribe = txtTribe.Text,
                    Chief = txtChief.Text,
                    Health = txtHealth.Text,
                    Symptoms = txtSymptoms.Text,
                    Height = txtHeight.Text,
                    Weight = txtWeight.Text,
                    BMI = lblBMI.Text,
                    SwallowsSolids = ddlSwallows.SelectedValue,
                    Liquids = ddlLiquids.SelectedValue,
                    Saliva = ddlSaliva.SelectedValue,
                    Odynophagia = ddlOdynophagia.SelectedValue,
                    Emesis = txtEmesis.Text,
                    
                    Hematemesis = txtHematemesis.Text,
                    AbdPain = txtAbdPain.Text,
                    Dyspepsia = txtDyspepsia.Text,
                    Anemia = txtAnemia.Text,
                    WeightLoss = txtWeightLoss.Text,
                    Black = txtBlackStools.Text,
                    Bloody = txtBloodyStools.Text,

                    Other = txtOther.Text,
                    Duration = txtDuration.Text,
                    Alcohol1 = ddlAlcohol1.SelectedValue,
                    Smoking1 = ddlSmoking1.SelectedValue,
                    NSAIDS1 = ddlNSAIDS1.SelectedValue,
                    Alcohol2 = ddlAlcohol2.SelectedValue,
                    Smoking2 = ddlSmoking2.SelectedValue,
                    NSAIDS2 = ddlNSAIDS2.SelectedValue,
                    Eso = ddlEso.SelectedValue,
                    PersonAge1 = txtPersonAge1.Text,
                    OtherCancer = ddlOtherCancer.SelectedValue,
                    PersonAge2 = txtPersonAge2.Text,
                    LastEGDDate = LastEGDDate,
                    Additional = txtAdditionalHistory.Text,
                    Pharnyx = txtPharnyx.Text,
                    Esophagus = txtEsophagus.Text,
                    Stomach = txtStomach.Text,
                    Duodenum = txtDuodenum.Text,
                    
                    Sedation = ddlSedation.SelectedValue,
                    Versed = txtVersed.Text,
                    Fentanyl = txtFentanyl.Text,
                    Ketamine = txtKetamine.Text,

                    Oxygen = txtOxygen.Text,
                    Other2 = txtOther2.Text,
                    Images = ddlImages.SelectedValue,
                    Impression = txtImpression.Text,
                    Endoscopy = txtEndoscopyIntervention.Text,
                    Recommendations = txtRecommendations.Text,
                    FollowUpDate = FollowUpDate,
                    ReportBy = HttpContext.Current.Session["ID"].ToString(),
                    Procedure = txtProcedure.Text,
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